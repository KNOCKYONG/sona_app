import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../../../models/message.dart';
import '../../../models/persona.dart';
import '../../../core/constants.dart';
import '../../../core/preferences_manager.dart';
import '../../../helpers/firebase_helper.dart';
import '../../base/base_service.dart';
import 'openai_service.dart';
import '../utils/natural_ai_service.dart';
import 'chat_orchestrator.dart' hide MessageType;
import 'conversation_state_adapter.dart';  // 🆕 마이그레이션 어댑터
import '../utils/persona_relationship_cache.dart';
import '../../persona/persona_service.dart';
import '../../storage/local_storage_service.dart';
import '../../storage/cache_manager.dart';
import '../../storage/guest_conversation_service.dart';
import '../intelligence/conversation_memory_service.dart';
import '../../auth/user_service.dart';
import '../../app_info_service.dart';
// import '../security/security_filter_service.dart'; // Temporarily disabled for build
import '../../relationship/relation_score_service.dart';
import '../../relationship/negative_behavior_system.dart';
import '../../relationship/like_cooldown_system.dart';
import '../../../models/chat_error_report.dart';
import '../utils/error_recovery_service.dart';
import '../utils/error_aggregation_service.dart';
import '../../ui/haptic_service.dart';

/// 무례한 메시지 체크 결과
class RudeMessageCheck {
  final bool isRude;
  final String severity; // 'none', 'low', 'high'

  RudeMessageCheck({required this.isRude, required this.severity});
}

/// 🚀 Optimized Chat Service with Performance Enhancements
///
/// Key optimizations:
/// 1. Message batching for Firebase writes
/// 2. Debounced API calls
/// 3. Intelligent caching for responses
/// 4. Memory-efficient message storage
/// 5. Parallel processing where possible
class ChatService extends BaseService {
  final ConversationMemoryService _memoryService = ConversationMemoryService();
  final Uuid _uuid = const Uuid();
  final Random _random = Random();

  // Debouncing timer for notifyListeners
  Timer? _notifyTimer;

  ChatService() {
    // Initialize persona relationship cache
    PersonaRelationshipCache.instance.initialize();
    debugPrint('✅ PersonaRelationshipCache initialized');
  }
  // Performance optimization: Response cache
  final Map<String, _CachedResponse> _responseCache = {};

  // Debouncing for API calls
  Timer? _debounceTimer;

  // Batch writing for Firebase
  final List<_PendingMessage> _pendingMessages = [];
  Timer? _batchWriteTimer;
  static const int _maxBatchSize = 10;
  
  // Conversation ID mapping (personaId -> conversationId)
  final Map<String, String> _conversationIds = {};

  // AI Response Delay System
  final Map<String, _ChatResponseQueue> _responseQueues = {};
  final Map<String, Timer> _responseDelayTimers = {};
  final Map<String, bool> _personaIsTyping = {};
  final Map<String, int> _unreadMessageCounts = {};

  // Service references
  PersonaService? _personaService;
  UserService? _userService;
  String? _currentUserId;

  // Haptic feedback callback
  Function()? onAIMessageReceived;

  // Data storage
  List<Message> _messages = [];
  final Map<String, List<Message>> _messagesByPersona = {};
  // Replaced by _personaIsTyping map

  // Getters
  List<Message> get messages =>
      _currentPersonaId != null ? getMessages(_currentPersonaId!) : [];

  // Current persona ID for tracking active chat
  String? _currentPersonaId;

  // Pagination state
  bool _isLoadingMore = false;
  final Map<String, bool> _hasMoreMessages = {};

  void setPersonaService(PersonaService personaService) {
    _personaService = personaService;
  }

  void setUserService(UserService userService) {
    _userService = userService;
  }

  void setCurrentUserId(String userId) {
    _currentUserId = userId;
  }

  /// Debounced notifyListeners to reduce UI updates
  void _debouncedNotify() {
    _notifyTimer?.cancel();
    _notifyTimer = Timer(const Duration(milliseconds: 16), () {  // 60fps를 위한 16ms (1프레임)
      super.notifyListeners();
    });
  }

  @override
  void notifyListeners() {
    // Use debounced notify instead of direct call
    _debouncedNotify();
  }

  /// Get messages with memory optimization
  List<Message> getMessages(String personaId) {
    // Always return messages for the specific persona
    final messages = _messagesByPersona[personaId] ?? [];

    // Debug: 읽지 않은 메시지 확인 (주석 처리 - 너무 많은 로그 방지)
    // final unreadCount = messages.where((m) => !m.isFromUser && (m.isRead == false || m.isRead == null)).length;
    // if (unreadCount > 0) {
    //   debugPrint('🔍 getMessages for $personaId: Found $unreadCount unread messages');
    //   for (final msg in messages.where((m) => !m.isFromUser && (m.isRead == false || m.isRead == null))) {
    //     debugPrint('  - Unread msg: ${msg.content.substring(0, 20 < msg.content.length ? 20 : msg.content.length)}... isRead: ${msg.isRead}');
    //   }
    // }

    // Return only recent messages to save memory
    if (messages.length > AppConstants.maxMessagesInMemory) {
      return messages
          .sublist(messages.length - AppConstants.maxMessagesInMemory);
    }
    return messages;
  }

  /// Mark all user messages as read when AI responds
  void _markUserMessagesAsRead(String personaId) {
    final messages = _messagesByPersona[personaId] ?? [];
    bool hasUpdates = false;
    final messagesToUpdate = <Message>[];
    final updatedMessages = <Message>[];

    for (int i = 0; i < messages.length; i++) {
      final message = messages[i];
      if (message.isFromUser && !message.isRead) {
        final updatedMessage = message.copyWith(isRead: true);
        messages[i] = updatedMessage;
        hasUpdates = true;
        messagesToUpdate.add(updatedMessage);
        updatedMessages.add(updatedMessage);
      }
    }

    if (hasUpdates) {
      notifyListeners();

      // Update read status in Firebase
      if (_currentUserId != null && _currentUserId!.isNotEmpty) {
        _updateReadStatusInFirebase(
            _currentUserId!, personaId, messagesToUpdate);
      }
    }
  }

  /// Clear current chat state without clearing messages
  /// Used when navigating away from ChatScreen
  void clearCurrentChatState() {
    // Don't clear messages or personaId, just reset active states
    _personaIsTyping.clear();
    _responseDelayTimers.forEach((_, timer) => timer?.cancel());
    _responseDelayTimers.clear();
    _responseQueues.clear();
    // Don't call notifyListeners to avoid rebuilding chat_list_screen
    debugPrint('🧹 Cleared current chat state without affecting messages');
  }

  /// Update read status in Firebase for multiple messages
  Future<void> _updateReadStatusInFirebase(
      String userId, String personaId, List<Message> messages) async {
    if (messages.isEmpty) return;

    try {
      final batch = FirebaseHelper.batch();

      for (final message in messages) {
        final docRef = FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('chats')
            .doc(personaId)
            .collection('messages')
            .doc(message.id);

        batch.update(docRef, {'isRead': true});
      }

      await batch.commit();
      debugPrint(
          '✅ Updated read status for ${messages.length} messages in Firebase');
    } catch (e) {
      debugPrint('❌ Error updating read status in Firebase: $e');
    }
  }

  /// 🔵 채팅방 진입 시 모든 메시지를 읽음으로 표시
  Future<void> markAllMessagesAsRead(String userId, String personaId) async {
    debugPrint(
        '📖 Marking all messages as read for persona: $personaId, userId: $userId');

    final messages = _messagesByPersona[personaId];
    if (messages == null || messages.isEmpty) {
      debugPrint('⚠️ No messages found for persona: $personaId');
      return;
    }

    debugPrint('📊 Total messages for persona: ${messages.length}');

    bool hasUnreadMessages = false;
    final updatedMessages = <Message>[];
    final batch = FirebaseFirestore.instance.batch();

    // 모든 읽지 않은 메시지를 읽음 처리 (사용자 메시지와 페르소나 메시지 모두)
    for (final message in messages) {
      if (message.isRead == false || message.isRead == null) {
        debugPrint(
            '📌 Found unread message: ${message.id}, isFromUser: ${message.isFromUser}, content: ${message.content.substring(0, 20 < message.content.length ? 20 : message.content.length)}...');

        // copyWith를 사용하여 새로운 Message 객체 생성
        final updatedMessage = message.copyWith(isRead: true);
        updatedMessages.add(updatedMessage);
        hasUnreadMessages = true;

        // Firebase 배치 업데이트에 추가
        if (userId.isNotEmpty) {
          final docRef = FirebaseHelper.userChats(userId)
              .doc(personaId)
              .collection('messages')
              .doc(message.id);
          batch.update(docRef, {'isRead': true});
        }
      } else {
        updatedMessages.add(message);
      }
    }

    // 배치 업데이트 실행
    if (hasUnreadMessages && userId.isNotEmpty) {
      try {
        await batch.commit();
        debugPrint(
            '✅ Batch updated ${updatedMessages.where((m) => m.isRead == true).length} messages as read');
      } catch (e) {
        // Ignore NOT_FOUND errors as messages might not exist yet
        if (!e.toString().contains('NOT_FOUND')) {
          debugPrint('❌ Error batch updating read status: $e');
        }
      }
    }

    // 읽지 않은 메시지가 있었다면 메시지 리스트를 완전히 교체
    if (hasUnreadMessages) {
      debugPrint(
          '✅ Updating ${updatedMessages.length} messages as read for persona $personaId');

      // 메시지 리스트를 완전히 새로운 리스트로 교체
      _messagesByPersona[personaId] = updatedMessages;

      // 현재 페르소나의 메시지라면 전역 메시지도 업데이트
      if (_currentPersonaId == personaId) {
        _messages = updatedMessages;  // 직접 참조 사용
      }

      // 강제로 notifyListeners 호출하여 UI 업데이트
      notifyListeners();

      debugPrint(
          '🔄 After update - Unread count: ${updatedMessages.where((m) => !m.isFromUser && m.isRead != true).length}');
    } else {
      debugPrint('ℹ️ No unread messages found for persona $personaId');
    }
  }

  /// Load chat history with parallel processing
  Future<void> loadChatHistory(String userId, String personaId) async {
    // 🔥 Progressive loading - don't clear immediately
    // Only clear if switching to a different persona
    if (_currentPersonaId != null && _currentPersonaId != personaId) {
      // Store existing messages temporarily for smooth transition
      final previousMessages = _messages.toList();
      _messages.clear();
      // 🔥 Use debounced notify to reduce UI flicker
      _debouncedNotify(); 
    }

    // Set current persona ID
    _currentPersonaId = personaId;

    // Don't cancel timers when loading chat history - let responses continue
    // _cleanupPersonaTimers(personaId);

    await executeWithLoading(() async {
      // Check if user is guest
      final isGuest = _userService != null ? await _userService!.isGuestUser : false;
      
      List<Message> loadedMessages;
      
      if (isGuest) {
        // Load from local storage for guest users
        debugPrint('🧑‍💼 [ChatService] Loading guest conversation for persona: $personaId');
        loadedMessages = await GuestConversationService.instance.getGuestMessages(personaId);
        
        // No need to preload Firebase memory for guests
        // Instead, generate context from local data
        final localContext = await GuestConversationService.instance.generateGuestContext(personaId);
        if (localContext.isNotEmpty) {
          debugPrint('💭 [ChatService] Generated local context for guest');
        }
      } else {
        // Load from Firebase for authenticated users
        final messagesLoading = _loadMessagesFromFirebase(userId, personaId);
        final memoryLoading = _preloadConversationMemory(userId, personaId);

        // Wait for both operations but handle them separately
        try {
          loadedMessages = await messagesLoading;
          await memoryLoading; // Memory loading doesn't return data, just processes
        } catch (e) {
          debugPrint('⚠️ Error during parallel loading: $e');
          loadedMessages = <Message>[];
        }
      }

      // Store messages for this specific persona
      _messagesByPersona[personaId] = loadedMessages;

      // Update global messages if this is the current persona
      if (_currentPersonaId == personaId) {
        _messages = loadedMessages;  // 직접 참조 사용
      }
    }, errorContext: 'loadChatHistory');
  }

  /// Clean up timers and queues for a specific persona
  void _cleanupPersonaTimers(String personaId) {
    // Cancel response timer
    _responseDelayTimers[personaId]?.cancel();
    _responseDelayTimers.remove(personaId);

    // Clear queue
    _responseQueues.remove(personaId);

    // Reset typing status
    _personaIsTyping[personaId] = false;

    // Reset unread count
    _unreadMessageCounts[personaId] = 0;
  }

  /// Optimized message loading with pagination and caching
  Future<List<Message>> _loadMessagesFromFirebase(
      String userId, String personaId) async {
    // Try to load from cache first
    final cacheManager = CacheManager.instance;
    final chatId = '${userId}_$personaId';
    final cachedMessages = await cacheManager.getCachedMessages(chatId);
    
    if (cachedMessages != null && cachedMessages.isNotEmpty) {
      debugPrint('📦 Loaded ${cachedMessages.length} messages from cache for $personaId');
      
      // Check for new messages since last cached message
      final lastCachedTimestamp = cachedMessages.last.timestamp;
      final newMessagesQuery = await FirebaseHelper.userChatMessages(userId, personaId)
          .where('timestamp', isGreaterThan: lastCachedTimestamp)
          .orderBy('timestamp', descending: false)
          .get();
      
      if (newMessagesQuery.docs.isNotEmpty) {
        final newMessages = newMessagesQuery.docs
            .map((doc) => Message.fromJson({...doc.data(), 'id': doc.id}))
            .toList();
        
        // Combine cached and new messages
        final allMessages = [...cachedMessages, ...newMessages];
        
        // Limit to max messages
        final limitedMessages = allMessages.length > AppConstants.maxMessagesInMemory
            ? allMessages.sublist(allMessages.length - AppConstants.maxMessagesInMemory)
            : allMessages;
        
        // Save updated cache
        await cacheManager.cacheMessages(chatId, limitedMessages);
        
        return limitedMessages;
      }
      
      return cachedMessages;
    }
    
    // No cache, load from Firebase
    final querySnapshot =
        await FirebaseHelper.userChatMessages(userId, personaId)
            .orderBy('timestamp', descending: true)
            .limit(AppConstants.maxMessagesInMemory)
            .get();

    final messages = querySnapshot.docs
        .map((doc) => Message.fromJson({...doc.data(), 'id': doc.id}))
        .toList()
        .reversed
        .toList();
    
    // Save to cache
    if (messages.isNotEmpty) {
      await cacheManager.cacheMessages(chatId, messages);
      debugPrint('💾 Cached ${messages.length} messages for $personaId');
    }
    
    return messages;
  }

  /// Load more messages for pagination
  Future<void> loadMoreMessages(String userId, String personaId) async {
    if (_isLoadingMore || userId.isEmpty) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      final currentMessages = _messagesByPersona[personaId] ?? [];
      if (currentMessages.isEmpty) {
        _isLoadingMore = false;
        notifyListeners();
        return;
      }

      // Get the oldest message timestamp
      final oldestMessage = currentMessages.first;

      // Load more messages before the oldest one
      final querySnapshot =
          await FirebaseHelper.userChatMessages(userId, personaId)
              .orderBy('timestamp', descending: true)
              .where('timestamp', isLessThan: oldestMessage.timestamp)
              .limit(AppConstants.messagesPerPage)
              .get();

      if (querySnapshot.docs.isEmpty) {
        _hasMoreMessages[personaId] = false;
        _isLoadingMore = false;
        notifyListeners();
        return;
      }

      final newMessages = querySnapshot.docs
          .map((doc) => Message.fromJson({...doc.data(), 'id': doc.id}))
          .toList()
          .reversed
          .toList();

      // Prepend new messages to the beginning
      _messagesByPersona[personaId] = [...newMessages, ...currentMessages];

      // Update global messages if this is the current persona
      if (_currentPersonaId == personaId) {
        _messages = _messagesByPersona[personaId]!;
      }

      // Check if we have more messages
      _hasMoreMessages[personaId] =
          querySnapshot.docs.length == AppConstants.messagesPerPage;

      debugPrint(
          '📜 Loaded ${newMessages.length} more messages for persona $personaId');
    } catch (e) {
      debugPrint('❌ Error loading more messages: $e');
      handleError(e, 'loadMoreMessages');
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  /// Check if there are more messages to load
  bool hasMoreMessages(String personaId) {
    return _hasMoreMessages[personaId] ?? true;
  }

  /// Check if currently loading more messages
  bool get isLoadingMore => _isLoadingMore;

  /// Preload conversation memory for faster responses
  Future<void> _preloadConversationMemory(
      String userId, String personaId) async {
    try {
      await _memoryService.buildSmartContext(
        userId: userId,
        personaId: personaId,
        recentMessages: [],
        persona: _getPersonaFromService(personaId) ??
            Persona(
              id: 'default',
              name: 'Default Persona',
              age: 25,
              description: 'Default persona for fallback',
              photoUrls: [],
              personality: 'Friendly and helpful',
            ),
        maxTokens: AppConstants.maxContextTokens,
      );
    } catch (e) {
      handleError(e, 'preloadConversationMemory');
    }
  }

  /// Send message with debouncing and caching
  Future<bool> sendMessage({
    required String content,
    required String userId,
    required Persona persona,
    MessageType type = MessageType.text,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      // 🆕 OpenAI Conversation 초기화 (첫 메시지 시)
      if (!_conversationIds.containsKey(persona.id)) {
        final conversationAdapter = ConversationStateAdapter();
        final conversationId = await conversationAdapter.initializeConversation(
          userId: userId,
          personaId: persona.id,
        );
        if (conversationId != null) {
          _conversationIds[persona.id] = conversationId;
        }
      }
      
      // Check daily message limit (different for guests and members)
      if (_userService != null) {
        final isGuest = await _userService!.isGuestUser;
        
        if (isGuest) {
          // Check guest message limit
          if (_userService!.isGuestMessageLimitReached()) {
            debugPrint('❌ Guest message limit reached (${AppConstants.guestDailyMessageLimit} messages)');
            return false;
          }
        } else {
          // Check regular user message limit
          if (_userService!.isDailyMessageLimitReached()) {
            debugPrint('❌ Daily message limit reached for user: $userId');
            return false;
          }
        }
      }

      // 말투 모드 전환 체크 제거 (항상 반말 모드 사용)

      // Check if user called persona by wrong name
      final wrongNameDetected = _checkWrongName(content, persona.name);
      if (wrongNameDetected) {
        debugPrint('⚠️ Wrong name detected in message for ${persona.name}');

        // Deduct like score immediately
        final currentLikes = await RelationScoreService.instance.getLikes(
          userId: userId,
          personaId: persona.id,
        );

        await RelationScoreService.instance.updateLikes(
          userId: userId,
          personaId: persona.id,
          likeChange: -10, // Deduct 10 points for wrong name
          currentLikes: currentLikes,
        );

        // Note: SnackBar will be shown from the UI layer instead
      }
      
      // Check for inappropriate content and apply penalties
      // Get recent messages for consecutive pattern checking
      final recentMessages = _messagesByPersona[persona.id] ?? [];
      final likePenalty = ChatOrchestrator.instance.calculateLikePenalty(
        content,
        recentMessages: recentMessages.reversed.take(5).toList(),
      );
      
      if (likePenalty > 0) {
        debugPrint('💔 Applying like penalty: -$likePenalty for inappropriate content');
        
        final currentLikes = await RelationScoreService.instance.getLikes(
          userId: userId,
          personaId: persona.id,
        );

        await RelationScoreService.instance.updateLikes(
          userId: userId,
          personaId: persona.id,
          likeChange: -likePenalty,
          currentLikes: currentLikes,
        );
      }

      // Create user message
      final userMessage = Message(
        id: _uuid.v4(),
        personaId: persona.id,
        content: content,
        type: type,
        isFromUser: true,
        isRead: false, // AI hasn't read this yet
        metadata: metadata,
      );

      // Add to local state immediately
      // Update persona-specific messages
      if (!_messagesByPersona.containsKey(persona.id)) {
        _messagesByPersona[persona.id] = [];
      }
      _messagesByPersona[persona.id]!.add(userMessage);

      // Update global messages if this is the current persona (직접 참조 사용)
      if (_currentPersonaId == persona.id) {
        _messages = _messagesByPersona[persona.id]!;  // List.from() 제거 - 직접 참조
      }

      // Increment unread count for this persona
      _unreadMessageCounts[persona.id] =
          (_unreadMessageCounts[persona.id] ?? 0) + 1;

      // 사용자 메시지 저장
      _queueMessageForSaving(userId, persona.id, userMessage);

      // Queue the message for delayed AI response (pass wrong name info)
      _queueMessageForDelayedResponse(userId, persona, userMessage,
          wrongNameDetected: wrongNameDetected,
          conversationId: _conversationIds[persona.id]);
      
      // 메시지 큐에 추가한 후에만 한 번 notify (debounced)
      // 이렇게 하면 깜빡임 없이 부드럽게 업데이트됨
      notifyListeners();

      return true;
    } catch (e) {
      debugPrint('Error sending message: $e');
      return false;
    }
  }

  /// Generate AI response using new orchestrator
  Future<void> _generateAIResponse(
      String userId, Persona persona, String userMessage,
      {bool wrongNameDetected = false, String? conversationId}) async {
    debugPrint(
        '🤖 _generateAIResponse called for ${persona.name} with message: $userMessage${wrongNameDetected ? " (WRONG NAME DETECTED)" : ""}');

    try {

      // Check if like score is 0 or below BEFORE marking as read
      final currentLikes = await RelationScoreService.instance.getLikes(
        userId: userId,
        personaId: persona.id,
      );

      if (currentLikes <= 0) {
        debugPrint(
            '💔 Like score is $currentLikes, not marking as read or responding');
        // Stop typing indicator
        _personaIsTyping[persona.id] = false;
        notifyListeners();
        return; // Exit without marking as read or generating response
      }

      // Only mark as read if like score > 0
      _markUserMessagesAsRead(persona.id);

      // Typing indicator is now handled by _queueMessageForDelayedResponse
      // Check cache first
      final cacheKey = _getCacheKey(persona.id, userMessage);
      final cachedResponse = _getFromCache(cacheKey);

      if (cachedResponse != null) {
        debugPrint('Using cached response for: $cacheKey');

        // No placeholder to remove

        await _sendMultipleMessages(
          contents: [cachedResponse.content], // Single content as array
          persona: persona,
          userId: userId,
          emotion: cachedResponse.emotion,
          scoreChange: cachedResponse.scoreChange,
        );
        return;
      }

      // Check if user called persona by wrong name
      if (wrongNameDetected) {
        debugPrint('🚨 Handling wrong name response for ${persona.name}');

        // Generate upset response about wrong name
        final wrongNameResponses = [
          '제 이름은 ${persona.name}예요... 😢',
          '${persona.name}라고 불러주세요... 💔',
          '아니에요, 저는 ${persona.name}인걸요... 😞',
          '왜 제 이름을 잘못 부르시는 거예요? 저는 ${persona.name}예요... 😔',
          '${persona.name}... 제 이름을 기억해주세요... 😭',
        ];

        final aiResponseContent =
            wrongNameResponses[_random.nextInt(wrongNameResponses.length)];
        final emotion = EmotionType.sad;

        // No placeholder to remove

        // Send the upset response
        await _sendMultipleMessages(
          contents: [aiResponseContent], // Single content as array
          persona: persona,
          userId: userId,
          emotion: emotion,
          scoreChange: -10, // Already deducted in sendMessage
        );

        return;
      }

      // Check if user was rude - but don't use hardcoded responses
      final rudeCheck = _checkRudeMessage(userMessage);
      
      // Note: rudeCheck.isRude 체크를 제거하고 
      // ChatOrchestrator가 무례한 메시지도 자연스럽게 처리하도록 함
      // 이렇게 하면 하드코딩된 응답 대신 AI가 적절한 응답을 생성

      // Get user nickname and age (language는 메시지별로 감지)
      String? userNickname;
      int? userAge;
      String? userLanguage = null; // 언어는 ChatOrchestrator에서 메시지별로 감지
      if (_userService?.currentUser != null) {
        userNickname = _userService!.currentUser!.nickname;
        userAge = _userService!.currentUser!.age;
        // preferredLanguage는 사용하지 않음 - 각 메시지마다 언어 감지
      }

      // Use new ChatOrchestrator for normal messages
      final chatHistory =
          _messages.where((m) => m.personaId == persona.id).toList();

      final response = await ChatOrchestrator.instance.generateResponse(
        userId: userId,
        basePersona: persona,
        userMessage: userMessage,
        chatHistory: chatHistory,
        userNickname: userNickname,
        userAge: userAge,
        userLanguage: userLanguage,
        conversationId: conversationId,
      );

      // Handle Like system integration
      int finalScoreChange = response.scoreChange;

      // Additional Like calculation if needed
      final likeResult = await RelationScoreService.instance.calculateLikes(
        emotion: response.emotion,
        userMessage: userMessage,
        persona: persona,
        chatHistory: chatHistory,
        currentLikes: persona.likes ?? 0,
        userId: userId,
      );

      // Use Like system's score if it differs
      if (likeResult.likeChange != response.scoreChange) {
        finalScoreChange = likeResult.likeChange;
      }

      // Process all contents from response
      final allContents = List<String>.from(response.contents);

      // Add cooldown message if present to the last content
      if (likeResult.message != null && allContents.isNotEmpty) {
        allContents[allContents.length - 1] =
            '${allContents.last}\n\n${likeResult.message}';
      }

      // Cache the response (using the full content)
      _addToCache(
          cacheKey,
          _CachedResponse(
            content: allContents.join(' '), // Join for cache
            emotion: response.emotion,
            scoreChange: finalScoreChange,
            timestamp: DateTime.now(),
          ));

      // No placeholder to remove

      // Check for relationship milestone event
      if (response.metadata?['relationshipEvent'] != null) {
        final event = response.metadata!['relationshipEvent'] as Map<String, dynamic>;
        
        // Don't add milestone message to contents - it should only be shown in UI
        // allContents.add(event['message'] as String);  // 버그 수정: 마일스톤 메시지가 대화에 포함되지 않도록 제거
        
        debugPrint('🎉 Relationship milestone reached: ${event['title']}');
        // TODO: UI에서 별도의 알림으로 표시하도록 개선 필요
      }
      
      // Check for memory album event (추억 회상)
      if (response.metadata?['memoryRecalled'] != null) {
        final memory = response.metadata!['memoryRecalled'] as Map<String, dynamic>;
        debugPrint('📸 Memory recalled: ${memory['title']}');
      }
      
      // Send response messages using new contents array
      await _sendMultipleMessages(
        contents: allContents,
        persona: persona,
        userId: userId,
        emotion: response.emotion,
        scoreChange: finalScoreChange,
        translatedContent: response.translatedContent,
        translatedContents: response.translatedContents,
        targetLanguage: response.targetLanguage,
      );

      // Increment daily message count after successful response
      if (_userService != null) {
        final isGuest = await _userService!.isGuestUser;
        
        if (isGuest) {
          // Increment guest message count
          await _userService!.incrementGuestMessageCount();
          debugPrint('✅ Guest message count incremented');
        } else {
          // Increment regular message count
          await _userService!.incrementMessageCount();
          debugPrint('✅ Daily message count incremented');
        }
      }
    } catch (e, stackTrace) {
      debugPrint('❌ Error generating AI response: $e');
      debugPrint('📍 Error type: ${e.runtimeType}');
      debugPrint('📚 Stack trace: $stackTrace');

      // 더 구체적인 에러 분석
      String errorMessage = e.toString();
      String errorType = 'unknown';

      if (errorMessage.contains('API key') ||
          errorMessage.contains('Invalid API key')) {
        debugPrint('🔑 API Key issue detected');
        errorType = 'api_key_error';
      } else if (errorMessage.contains('timeout')) {
        debugPrint('⏱️ Request timeout');
        errorType = 'timeout';
      } else if (errorMessage.contains('401')) {
        debugPrint('🚫 Authentication failed - API key may be invalid');
        errorType = 'auth_error';
      } else if (errorMessage.contains('429')) {
        debugPrint('🚦 Rate limit exceeded');
        errorType = 'rate_limit';
      } else if (errorMessage.contains('500') || errorMessage.contains('503')) {
        debugPrint('🔥 OpenAI server error');
        errorType = 'server_error';
      }

      // 자동 에러 리포트 생성 (특정 페르소나에 집중된 에러 추적)
      try {
        await _sendAutomaticErrorReport(
          userId: userId,
          personaId: persona.id,
          personaName: persona.name,
          errorType: errorType,
          errorMessage: errorMessage,
          stackTrace: stackTrace
              .toString()
              .split('\n')
              .take(10)
              .join('\n'), // 스택 트레이스 일부만
        );

        // 에러 복구 서비스에 추적
        ErrorRecoveryService.instance.trackError(
          personaId: persona.id,
          errorType: errorType,
          errorMessage: errorMessage,
        );
      } catch (reportError) {
        debugPrint('❌ Failed to send automatic error report: $reportError');
      }

      // Update placeholder with fallback response if it exists
      final fallbackResponse = _getFallbackResponse(personaId: persona.id);

      // No placeholder to remove

      // Send fallback response
      await _sendMultipleMessages(
        contents: [fallbackResponse], // Single content as array
        persona: persona,
        userId: userId,
        emotion: EmotionType.neutral,
        scoreChange: 0,
      );

      notifyListeners();
    }
  }

  /// Queue message for batch writing to Firebase or local storage
  void _queueMessageForSaving(
      String userId, String personaId, Message message) async {
    // Check if user is guest
    final isGuest = _userService != null ? await _userService!.isGuestUser : false;
    
    if (isGuest) {
      // For guest users, save directly to local storage (no batching needed)
      debugPrint('💾 [ChatService] Saving guest message locally');
      await GuestConversationService.instance.saveGuestMessage(
        personaId: personaId,
        message: message,
      );
    } else {
      // For authenticated users, use existing batch write logic
      _pendingMessages.add(_PendingMessage(
        userId: userId,
        personaId: personaId,
        message: message,
      ));

      // Start batch timer if not already running
      _batchWriteTimer ??=
          Timer(AppConstants.batchWriteDuration, _processBatchWrite);

      // Process immediately if batch is full
      if (_pendingMessages.length >= _maxBatchSize) {
        _processBatchWrite();
      }
    }
  }

  /// Process batch write to Firebase and update cache
  Future<void> _processBatchWrite() async {
    if (_pendingMessages.isEmpty) return;

    _batchWriteTimer?.cancel();
    _batchWriteTimer = null;

    final messagesToWrite = List<_PendingMessage>.from(_pendingMessages);
    _pendingMessages.clear();

    // Skip Firebase write if any message has empty userId
    bool shouldSkipFirebase = messagesToWrite.any((m) => m.userId == '');

    if (shouldSkipFirebase) {
      debugPrint(
          '⏭️ Skipping Firebase batch write for empty userId (${messagesToWrite.length} messages)');
      return;
    }

    try {
      final batch = FirebaseHelper.batch();

      // Group messages by chat for cache update
      final messagesByChat = <String, List<Message>>{};

      for (final pending in messagesToWrite) {
        final docRef = FirebaseFirestore.instance
            .collection('users')
            .doc(pending.userId)
            .collection('chats')
            .doc(pending.personaId)
            .collection('messages')
            .doc(pending.message.id);

        batch.set(docRef, pending.message.toJson());
        
        // Group messages for cache update
        final chatId = '${pending.userId}_${pending.personaId}';
        messagesByChat[chatId] ??= [];
        messagesByChat[chatId]!.add(pending.message);
      }

      await batch.commit();
      debugPrint('✅ Batch wrote ${messagesToWrite.length} messages');
      
      // Update cache for each chat
      final cacheManager = CacheManager.instance;
      for (final entry in messagesByChat.entries) {
        final chatId = entry.key;
        final newMessages = entry.value;
        
        // Get current persona messages
        final personaId = newMessages.first.personaId;
        final currentMessages = _messagesByPersona[personaId] ?? [];
        
        if (currentMessages.isNotEmpty) {
          // Update cache with all messages
          await cacheManager.cacheMessages(chatId, currentMessages);
          debugPrint('💾 Updated cache for $chatId with ${currentMessages.length} messages');
        }
      }

      // 💭 메모리 서비스에 중요한 대화 저장
      await _processConversationMemories(messagesToWrite);
    } catch (e) {
      debugPrint('❌ Error in batch write: $e');
      // Firebase 권한 오류는 더 이상 재시도하지 않음
      if (e.toString().contains('permission-denied')) {
        debugPrint('🚫 Firebase permission denied - dropping messages');
      } else {
        // 다른 오류는 재시도
        _pendingMessages.addAll(messagesToWrite);
      }
    }
  }

  /// Cache management
  String _getCacheKey(String personaId, String message) {
    return '${personaId}_${message.hashCode}';
  }

  _CachedResponse? _getFromCache(String key) {
    final cached = _responseCache[key];
    if (cached != null) {
      final age = DateTime.now().difference(cached.timestamp);
      if (age < AppConstants.cacheDuration) {
        return cached;
      } else {
        _responseCache.remove(key);
      }
    }
    return null;
  }

  void _addToCache(String key, _CachedResponse response) {
    _responseCache[key] = response;

    // Clean old cache entries if needed
    if (_responseCache.length > AppConstants.maxCacheSize) {
      final sortedEntries = _responseCache.entries.toList()
        ..sort((a, b) => a.value.timestamp.compareTo(b.value.timestamp));

      for (int i = 0;
          i < sortedEntries.length - AppConstants.maxCacheSize;
          i++) {
        _responseCache.remove(sortedEntries[i].key);
      }
    }
  }

  /// Enhanced context building with caching
  Future<String> _buildEnhancedContext({
    required String userId,
    required Persona persona,
    required List<Message> recentMessages,
  }) async {
    try {
      return await _memoryService.buildSmartContext(
        userId: userId,
        personaId: persona.id,
        recentMessages: recentMessages,
        persona: persona,
        maxTokens: 1000,
      );
    } catch (e) {
      debugPrint('Error building enhanced context: $e');
      return _buildBasicContext(recentMessages);
    }
  }

  /// Memory-efficient message loading
  Future<void> loadMessages(String personaId) async {
    try {
      if (_getCurrentUserId() == '') {
        final tutorialMessages =
            await LocalStorageService.getTutorialMessages(personaId);
        if (tutorialMessages.isNotEmpty) {
          _messagesByPersona[personaId] = tutorialMessages;
          debugPrint(
              'Loaded ${tutorialMessages.length} tutorial messages for persona $personaId');
        } else {
          // 메시지가 없으면 대화 시작 안내 메시지 제공
          final startMessage = Message(
            id: 'tutorial_start_${personaId}_${DateTime.now().millisecondsSinceEpoch}',
            personaId: personaId,
            content: await _generatePersonalizedDummyMessage(
                _personaService?.getPersonaById(personaId)),
            type: MessageType.text,
            isFromUser: false,
            timestamp: DateTime.now()
                .subtract(Duration(minutes: 1 + (personaId.hashCode % 9))),
          );
          _messagesByPersona[personaId] = [startMessage];
          debugPrint('Created tutorial start message for persona $personaId');
        }
        notifyListeners();
        return;
      }

      // Check if user is guest
      final isGuest = _userService != null ? await _userService!.isGuestUser : false;
      
      if (isGuest) {
        // Load messages from local storage for guest users
        debugPrint('🧑‍💼 [ChatService] Loading guest messages for persona: $personaId');
        final guestMessages = await GuestConversationService.instance.getGuestMessages(personaId);
        
        if (guestMessages.isNotEmpty) {
          _messagesByPersona[personaId] = guestMessages;
          debugPrint('Loaded ${guestMessages.length} guest messages for persona $personaId');
        } else {
          // Create welcome message for guest if no messages exist
          final welcomeMessage = Message(
            id: 'guest_welcome_${personaId}_${DateTime.now().millisecondsSinceEpoch}',
            personaId: personaId,
            content: await _generatePersonalizedDummyMessage(
                _personaService?.getPersonaById(personaId)),
            type: MessageType.text,
            isFromUser: false,
            timestamp: DateTime.now()
                .subtract(Duration(minutes: 1 + (personaId.hashCode % 9))),
          );
          _messagesByPersona[personaId] = [welcomeMessage];
          debugPrint('Created guest welcome message for persona $personaId');
        }
        notifyListeners();
        return;
      }

      // 실제 모드에서는 Firebase에서 최근 메시지 몇 개만 로드 (채팅 목록 미리보기용)
      final currentUser = _getCurrentUserId();
      if (currentUser == null) {
        // 사용자 ID가 없을 때도 더미 메시지 제공
        final dummyMessage = Message(
          id: 'no_user_dummy_${DateTime.now().millisecondsSinceEpoch}',
          personaId: personaId,
          content: await _generatePersonalizedDummyMessage(
              _personaService?.getPersonaById(personaId)),
          type: MessageType.text,
          isFromUser: false,
          timestamp: DateTime.now()
              .subtract(Duration(minutes: 5 + (personaId.hashCode % 25))),
        );
        _messagesByPersona[personaId] = [dummyMessage];
        debugPrint('Created no-user dummy message for persona $personaId');
        notifyListeners();
        return;
      }

      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser)
          .collection('chats')
          .doc(personaId)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .limit(5) // 최근 5개 메시지만 로드
          .get();

      final messages = querySnapshot.docs
          .map((doc) => Message.fromJson({...doc.data(), 'id': doc.id}))
          .toList()
          .reversed // 시간순 정렬
          .toList();

      debugPrint('Loaded ${messages.length} messages for persona $personaId');

      // Firebase에 메시지가 없는 경우 테스트용 더미 메시지 생성
      if (messages.isEmpty) {
        final dummyMessage = Message(
          id: 'dummy_${DateTime.now().millisecondsSinceEpoch}',
          personaId: personaId,
          content: await _generatePersonalizedDummyMessage(
              _personaService?.getPersonaById(personaId)),
          type: MessageType.text,
          isFromUser: false,
          timestamp: DateTime.now()
              .subtract(Duration(minutes: 10 + (personaId.hashCode % 50))),
        );
        _messagesByPersona[personaId] = [dummyMessage];
        debugPrint('Created dummy message for persona $personaId');
      } else {
        _messagesByPersona[personaId] = messages;
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Error loading messages for persona $personaId: $e');
      // 오류 발생 시에도 더미 메시지 제공
      final dummyMessage = Message(
        id: 'error_dummy_${DateTime.now().millisecondsSinceEpoch}',
        personaId: personaId,
        content: await _generatePersonalizedDummyMessage(
            _personaService?.getPersonaById(personaId)),
        type: MessageType.text,
        isFromUser: false,
        timestamp: DateTime.now()
            .subtract(Duration(minutes: 30 + (personaId.hashCode % 120))),
      );
      _messagesByPersona[personaId] = [dummyMessage];
      notifyListeners();
    }
  }

  // Helper methods remain the same but with optimizations...

  /// Check if user is requesting casual/formal speech mode change
  bool? _checkCasualSpeechRequest(String message) {
    final lowerMessage = message.toLowerCase();

    // 반말 요청 패턴 - 더 자연스럽고 다양한 표현 추가
    final casualPatterns = [
      // 직접적인 요청
      '반말로 해', '반말하자', '반말로 하자', '반말 써', '반말 쓰자',
      '편하게 해', '편하게 하자', '편하게 말해', '편하게 대해',
      '말 놓자', '말 놓아', '말 놔도', '편하게 대화',

      // 친구 관계 표현
      '친구처럼', '친구같이', '친구로', '친구야', '우리 친구',
      '친구하자', '친구 하자', '친구 되자', '친해지자',

      // 자연스러운 관계 발전 표현
      '너랑 친해지고 싶어', '우리 친하게 지내자', '편하게 지내자',
      '말 놓아도 돼?', '반말해도 될까?', '편하게 해도 될까?',
      '우리 이제 친한 사이', '이제 편하게 하자', '서로 편하게',

      // 간접적인 표현
      '너무 딱딱해', '좀 편하게 해도', '격식 차리지 마',
      '부담스러워', '어색해', '자연스럽게 하자',

      // 연령/관계 기반
      '나이 비슷한데', '동갑인데', '언니라고 불러', '오빠라고 불러',
      '형이라고 불러', '누나라고 불러'
    ];

    // 존댓말 요청 패턴
    final formalPatterns = [
      '존댓말로 해',
      '존댓말하자',
      '존댓말로 하자',
      '존댓말 써',
      '정중하게',
      '예의 바르게',
      '공손하게',
      '높임말로',
      '존댓말로 바꿔',
      '존댓말로 전환',
      '존댓말 부탁',
      '격식 있게',
      '예의를 지켜',
      '정중한 말투로'
    ];

    // 반말 요청 체크
    for (final pattern in casualPatterns) {
      if (message.contains(pattern)) {
        debugPrint('🗣️ Casual speech pattern detected: $pattern');
        return true;
      }
    }

    // 존댓말 요청 체크
    for (final pattern in formalPatterns) {
      if (message.contains(pattern)) {
        debugPrint('🗣️ Formal speech pattern detected: $pattern');
        return false;
      }
    }

    return null; // 반말/존댓말 요청이 아님
  }

  /// Check if user called persona by wrong name
  bool _checkWrongName(String message, String correctName) {
    // Common Korean name patterns to check
    final commonWrongNames = [
      '포키티', '포키', '포케티', '포켓티', // Common mistakes for any name
      '소나', '손아', '소냐', '쏘나', // SONA app related mistakes
    ];

    // Extract the correct name without suffixes
    final baseName = correctName.replaceAll(RegExp(r'[님씨야아]$'), '');

    // Common words that should NOT be considered as names
    final excludedWords = [
      // 대명사 및 지시대명사
      '이거', '저거', '그거', '이것', '저것', '그것',
      '이게', '저게', '그게', '이걸', '저걸', '그걸',
      '여기', '저기', '거기', '어디', '어디가', '어디야', '어디에',
      // 의문사
      '뭐', '뭐가', '뭐를', '뭐야', '뭘', '무엇', '무엇이', '무엇을',
      '누가', '누구', '누굴', '누구를', '누구야', '누구에게',
      '언제', '어떻게', '왜', '어째서', '어떤', '무슨',
      // 일반 명사
      '사람', '사람이', '친구', '친구가', '친구야', '너무', '정말',
      '진짜', '진짜가', '이제', '이제는', '아직', '벌써',
      '오늘', '내일', '어제', '지금', '아까', '나중', '방금',
      '이거', '저거', '그거', '이건', '저건', '그건',
      '아무', '아무나', '아무거나', '누구나', '모두', '전부',
      '하나', '둘', '셋', '많이', '조금', '약간', '매우',
      // 동사 및 형용사
      '하고', '하는', '했어', '할게', '할까', '해야', '하자',
      '있어', '없어', '있는', '없는', '있을', '없을', '있니',
      '좋아', '싫어', '좋은', '나쁜', '예쁜', '멋진', '귀여운',
      '가고', '오고', '보고', '먹고', '자고', '놀고', '살고',
      // 감탄사 및 추임새
      '아', '어', '오', '우', '에', '음', '흠', '허',
      '아니', '네', '응', '그래', '그래서', '그러니까', '그런데',
      // 일상 표현
      '밥', '물', '커피', '차', '술', '음식', '과자',
      '집', '학교', '회사', '가게', '마트', '편의점',
      '엄마', '아빠', '언니', '오빠', '형', '누나', '동생',
      '선생', '학생', '직원', '사장', '손님', '고객',
      // 기타 자주 오인식되는 단어들
      '뭐라고', '뭐라', '어라', '이라', '그라', '저라',
      '이야기', '얘기', '말', '대화', '이야', '그야', '저야',
      '바로', '그냥', '혹시', '아마', '분명', '당연', '물론',
    ];

    // 명확한 호명 패턴만 체크 - 더 엄격한 조건
    // 1. 문장 시작에서 명확한 호칭
    final clearStartPattern = RegExp(r'^([가-힣]{2,4})(아|야|님|씨)\s*[,!?~]\s*(.+)');
    // 2. 독립적인 호명 (짧은 문장)
    final standalonePattern = RegExp(r'^([가-힣]{2,4})(아|야|님|씨)\s*[!?~]*$');
    // 3. 명확한 부름 표현
    final explicitCallPattern = RegExp(r'(이봐|저기|야)\s*([가-힣]{2,4})(아|야|님|씨)');

    // Check each pattern
    for (final pattern in [
      clearStartPattern,
      standalonePattern,
      explicitCallPattern
    ]) {
      final matches = pattern.allMatches(message);

      for (final match in matches) {
        String calledName = '';
        if (pattern == explicitCallPattern) {
          calledName = match.group(2) ?? '';
        } else {
          calledName = match.group(1) ?? '';
        }

        // Skip if it's an excluded word
        if (excludedWords.contains(calledName)) {
          continue;
        }

        // Check if the called name is not the correct name or its base form
        if (calledName.isNotEmpty &&
            calledName != correctName &&
            calledName != baseName &&
            !correctName.contains(calledName) &&
            !baseName.contains(calledName)) {
          // Only check if it's a common wrong name or clearly seems like a name
          if (commonWrongNames.contains(calledName) ||
              (calledName.length >= 2 &&
                  calledName.length <= 4 &&
                  _isLikelyName(calledName, message))) {
            debugPrint(
                '🚨 Wrong name detected: "$calledName" (correct: "$correctName") in message: "$message"');
            return true;
          }
        }
      }
    }

    return false;
  }

  /// Check if a word is likely to be a name based on Korean naming patterns
  bool _isLikelyName(String word, String fullMessage) {
    // Korean names typically don't contain these characters
    if (word.contains(RegExp(r'[0-9!@#$%^&*()_+=\[\]{};:,.<>?/\\|`~\-]'))) {
      return false;
    }

    // 일반적인 단어가 아닌 경우만 체크
    final commonWords = [
      '하나',
      '둘',
      '셋',
      '많이',
      '조금',
      '약간',
      '매우',
      '너무',
      '정말',
      '진짜',
      '완전',
      '대박',
      '최고',
      '좋아',
      '싫어',
      '이거',
      '저거',
      '그거',
      '뭐야',
      '뭐가',
      '어디',
      '언제',
      '바로',
      '그냥',
      '혹시',
      '아마',
      '분명',
      '당연',
      '물론',
    ];

    if (commonWords.contains(word)) {
      return false;
    }

    // Common Korean first names (성씨)
    final koreanLastNames = [
      '김',
      '이',
      '박',
      '최',
      '정',
      '강',
      '조',
      '윤',
      '장',
      '임',
      '한',
      '오',
      '서',
      '신',
      '권',
      '황',
      '안',
      '송',
      '전',
      '홍',
      '문',
      '양',
      '고',
      '배',
      '백',
      '허',
      '유',
      '남',
      '심',
      '노',
    ];

    // 성씨로 시작하는 경우 이름일 가능성이 높음
    final firstChar = word.isNotEmpty ? word[0] : '';
    if (koreanLastNames.contains(firstChar) &&
        word.length >= 2 &&
        word.length <= 3) {
      return true;
    }

    // Common Korean name endings (더 엄격하게)
    final nameEndings = ['은', '인', '진', '민', '현', '준', '서', '우', '지', '희'];
    final lastChar = word.isNotEmpty ? word[word.length - 1] : '';

    // 이름 같은 끝자리 + 전체 메시지에서 호명하는 문맥인지 확인
    if (nameEndings.contains(lastChar)) {
      // 호명하는 문맥인지 추가 검증
      final callingContext = RegExp(r'(이봐|저기|야|님|씨)').hasMatch(fullMessage);
      if (callingContext) {
        return true;
      }
    }

    // 2-3자 한글이지만, 더 엄격한 조건 적용
    final koreanOnly = RegExp(r'^[가-힣]+$');
    if (word.length >= 2 && word.length <= 3 && koreanOnly.hasMatch(word)) {
      // 흔한 이름 패턴인지 추가 검증
      final commonNamePatterns = [
        RegExp(r'^[가-힣][은인진민현준서우지희]$'), // 2자 이름
        RegExp(r'^[가-힣][가-힣][은인진민현준서우지희]$'), // 3자 이름
      ];

      for (final pattern in commonNamePatterns) {
        if (pattern.hasMatch(word)) {
          return true;
        }
      }
    }

    return false;
  }

  String? _getCurrentUserId() => _currentUserId;

  String _getRelationshipTypeString(int score) {
    if (score >= 900) return '완전한 연애';
    if (score >= 600) return '연인';
    if (score >= 200) return '썸';
    return '친구';
  }

  String _buildBasicContext(List<Message> messages) {
    final recentMessages = messages.length > 10
        ? messages.sublist(messages.length - 10)
        : messages;

    return recentMessages
        .map((msg) => '${msg.isFromUser ? "사용자" : "AI"}: ${msg.content}')
        .join('\n');
  }

  Persona? _getPersonaFromService(String personaId) {
    if (_personaService == null) return null;

    try {
      if (_personaService!.currentPersona?.id == personaId) {
        return _personaService!.currentPersona;
      }

      return _personaService!.matchedPersonas
          .where((p) => p.id == personaId)
          .firstOrNull;
    } catch (e) {
      debugPrint('Error getting persona from service: $e');
      return null;
    }
  }

  String _getFallbackResponse({String? personaId}) {
    // 복구 전략 확인
    if (personaId != null) {
      final recoveryStrategy =
          ErrorRecoveryService.instance.getRecoveryStrategy(personaId);
      if (recoveryStrategy != null) {
        // 복구 전략이 있는 경우 더 구체적인 메시지
        switch (recoveryStrategy.type) {
          case RecoveryType.cooldown:
            return '잠시만... 좀 쉬었다가 다시 대화해줄래? 😅';
          case RecoveryType.simplifyPrompt:
            return '음... 좀 더 간단하게 말해줄 수 있어? 🤔';
          case RecoveryType.systemError:
            return '앗, 뭔가 문제가 생긴 것 같아... 잠시 후에 다시 해볼까? 😓';
          case RecoveryType.retry:
            return '어라? 잠깐 문제가 있었나봐. 다시 한번 말해줄래? 😊';
          default:
            break;
        }
      }
    }

    // 기본 폴백 응답 - API 오류 시에만 사용
    // ⚠️ 절대 "뭐라고?" 같은 회피 응답 사용 금지
    final emergencyResponses = [
      '잠시 연결이 불안정해... 곧 다시 대답할게!',
      '앗, 잠깐 네트워크가 끊겼나봐ㅠㅠ',
      '어 지금 잠시 문제가 생긴 것 같아... 다시 시도해볼게!',
      '미안 지금 잠깐 연결이 안 돼ㅠㅠ',
    ];
    return emergencyResponses[Random().nextInt(emergencyResponses.length)];
  }

  // Existing methods like _analyzeEmotionFromResponse, _calculateScoreChangeWithRelationship,
  // _sendSplitMessages, etc. remain the same...

  /// Check if message is a reaction or exclamation
  bool _isReactionOrExclamation(String message) {
    // 추임새나 짧은 리액션 패턴들
    final reactions = [
      RegExp(r'^ㅋ{3,}$'),       // ㅋㅋㅋ 이상
      RegExp(r'^ㅎ{3,}$'),       // ㅎㅎㅎ 이상  
      RegExp(r'^ㅠ{3,}$'),       // ㅠㅠㅠ 이상
      RegExp(r'^우와+$'),        // 우와, 우와아
      RegExp(r'^대박+$'),        // 대박
      RegExp(r'^진짜\??$'),      // 진짜, 진짜?
      RegExp(r'^헐+$'),          // 헐, 헐헐
      RegExp(r'^와+$'),          // 와, 와아
      RegExp(r'^오+$'),          // 오, 오오
      RegExp(r'^아+$'),          // 아, 아아
      RegExp(r'^어머+$'),        // 어머, 어머머
      RegExp(r'^헉+$'),          // 헉
      RegExp(r'^음+$'),          // 음, 음음
      RegExp(r'^흠+$'),          // 흠, 흠흠
    ];
    
    final trimmed = message.trim();
    
    // 패턴 매칭
    for (final pattern in reactions) {
      if (pattern.hasMatch(trimmed)) {
        return true;
      }
    }
    
    // 3글자 이하의 단순 반응들
    final shortReactions = ['ㅇㅇ', 'ㅇㅋ', 'ㄱㄱ', 'ㄴㄴ', 'ㅅㄹ', 'ㄷㄷ', 'ㅎㄷㄷ', '...', '??', '!!!'];
    if (shortReactions.contains(trimmed)) {
      return true;
    }
    
    return false;
  }

  /// Queue message for delayed AI response
  void _queueMessageForDelayedResponse(
      String userId, Persona persona, Message userMessage,
      {bool wrongNameDetected = false, String? conversationId}) {
    final personaId = persona.id;

    // Initialize queue if needed
    if (!_responseQueues.containsKey(personaId)) {
      _responseQueues[personaId] = _ChatResponseQueue();
    }

    // Add message to queue
    _responseQueues[personaId]!.messages.add(userMessage);

    // Store wrong name detected flag
    if (wrongNameDetected) {
      _responseQueues[personaId]!.wrongNameDetected = true;
    }
    
    // Store conversation ID
    if (conversationId != null) {
      _responseQueues[personaId]!.conversationId = conversationId;
    }

    // Cancel existing timer if any
    _responseDelayTimers[personaId]?.cancel();
    
    // 타이머 취소 시 타이핑 인디케이터도 확실히 리셋 (중복 방지)
    if (_personaIsTyping[personaId] == true) {
      _personaIsTyping[personaId] = false;
      notifyListeners();
      debugPrint('🔄 Reset typing indicator for ${persona.name} (timer cancelled)');
    }

    // 추임새/리액션 감지
    final isReaction = _isReactionOrExclamation(userMessage.content);
    
    // 딜레이 계산
    double totalDelay;
    
    if (isReaction) {
      // 추임새인 경우: 2-3초 기다림 (사용자가 이어서 타이핑할 가능성)
      totalDelay = 2.0 + _random.nextDouble(); // 2-3초
      debugPrint('💭 Reaction detected ("${userMessage.content}"), waiting ${totalDelay.toStringAsFixed(1)}s for follow-up');
    } else {
      // 일반 메시지: 기존 로직
      final baseDelay = _random.nextInt(7) / 10.0 + 0.3; // 0.3-1 seconds
      final additionalDelay =
          (_responseQueues[personaId]!.messages.length - 1) * 0.3; // 0.3 second per message
      totalDelay = baseDelay + additionalDelay;
      debugPrint('📱 Setting AI response delay for ${persona.name}: ${totalDelay.toStringAsFixed(1)}s');
    }

    // Schedule response - no typing indicator during delay
    _responseDelayTimers[personaId] = Timer(Duration(milliseconds: (totalDelay * 1000).round()), () {
      _processDelayedResponse(userId, persona);
    });
  }

  /// Process accumulated messages and generate AI response
  Future<void> _processDelayedResponse(String userId, Persona persona) async {
    debugPrint('⏱️ _processDelayedResponse called for ${persona.name}');
    final personaId = persona.id;
    final queue = _responseQueues[personaId];

    if (queue == null || queue.messages.isEmpty) {
      debugPrint('⚠️ No messages in queue for ${persona.name}');
      return;
    }

    // Get messages from queue and wrong name flag
    final messagesToProcess = List<Message>.from(queue.messages);
    final wrongNameDetected = queue.wrongNameDetected;
    final conversationId = queue.conversationId;
    queue.messages.clear();
    queue.wrongNameDetected = false; // Reset flag

    // Check like score BEFORE marking as read
    final currentLikes = await RelationScoreService.instance.getLikes(
      userId: userId,
      personaId: persona.id,
    );

    if (currentLikes <= 0) {
      debugPrint(
          '💔 Like score is $currentLikes, not marking as read or responding');
      return; // Exit without marking as read, showing typing indicator, or generating response
    }

    // Only mark as read if like score > 0
    // Update messages to mark as read
    for (final msg in messagesToProcess) {
      // Update in persona-specific messages
      final personaMessages = _messagesByPersona[personaId] ?? [];
      final indexInPersona = personaMessages.indexWhere((m) => m.id == msg.id);
      if (indexInPersona != -1) {
        personaMessages[indexInPersona] =
            personaMessages[indexInPersona].copyWith(isRead: true);
      }

      // Update in global messages if current persona
      if (_currentPersonaId == personaId) {
        final index = _messages.indexWhere((m) => m.id == msg.id);
        if (index != -1) {
          _messages[index] = _messages[index].copyWith(isRead: true);
        }
      }

      // Update read status in Firebase
      if (userId != '') {
        try {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .collection('chats')
              .doc(personaId)
              .collection('messages')
              .doc(msg.id)
              .update({'isRead': true});
        } catch (e) {
          // Ignore NOT_FOUND errors as messages might not exist yet
          if (!e.toString().contains('NOT_FOUND')) {
            debugPrint('Error updating read status: $e');
          }
        }
      }
    }

    // Reset unread count for this persona
    _unreadMessageCounts[personaId] = 0;
    notifyListeners();

    // Show typing indicator immediately with haptic feedback
    debugPrint('⏳ Starting typing indicator for ${persona.name}...');
    
    // 햅틱 피드백 제거 (사용자 요청)
    
    // 타이핑 인디케이터 표시 (이미 표시 중이 아닌 경우만)
    if (_personaIsTyping[personaId] != true) {
      _personaIsTyping[personaId] = true;
      notifyListeners();
      debugPrint('💬 Showing typing indicator for ${persona.name}');
    }

    // Minimal wait to show typing animation
    await Future.delayed(Duration(milliseconds: 200));

    // Combine all messages for context
    final combinedContent = messagesToProcess.map((m) => m.content).join(' ');
    debugPrint('📝 Combined message content: $combinedContent');

    // Generate AI response (pass wrong name flag and conversation ID)
    // Note: Typing indicator will be stopped inside _generateAIResponse just before sending message
    await _generateAIResponse(userId, persona, combinedContent,
        wrongNameDetected: wrongNameDetected,
        conversationId: conversationId);
    
    // Ensure typing indicator is stopped (fallback)
    if (_personaIsTyping[personaId] == true) {
      _personaIsTyping[personaId] = false;
      notifyListeners();
    }
    debugPrint('✅ Response process completed for ${persona.name}');
  }

  /// Get unread count for a persona
  int getUnreadCount(String personaId) {
    return _unreadMessageCounts[personaId] ?? 0;
  }

  /// Check if persona is typing
  bool isPersonaTyping(String personaId) {
    return _personaIsTyping[personaId] ?? false;
  }

  /// 불완전한 문장인지 감지
  bool _isIncompleteSentence(String text) {
    if (text.isEmpty) return false;

    final trimmed = text.trim();

    // 완전한 종결어미로 끝나는 경우
    if (trimmed.endsWith('.') ||
        trimmed.endsWith('?') ||
        trimmed.endsWith('!') ||
        trimmed.endsWith('요') ||
        trimmed.endsWith('다') ||
        trimmed.endsWith('죠') ||
        trimmed.endsWith('네') ||
        trimmed.endsWith('어') ||
        trimmed.endsWith('야') ||
        trimmed.endsWith('ㅋ') ||
        trimmed.endsWith('ㅎ') ||
        trimmed.endsWith('~')) {
      return false;
    }

    // 불완전한 패턴
    final incompletePatterns = [
      '하고',
      '인데',
      '했는데',
      '있고',
      '없고',
      '같고',
      '되고',
      '라고',
      '하셨는데',
      '하시는데',
      '한다는데',
      '무슨',
      '어떤',
      '어디',
      '언제',
      '누가',
      '왜',
      '어떻게',
      ',',
      '，',
      '에서',
      '으로',
      '를',
      '을',
      '이',
      '가',
      '는',
      '은',
      '와',
      '과'
    ];

    for (final pattern in incompletePatterns) {
      if (trimmed.endsWith(pattern)) {
        return true;
      }
    }

    return false;
  }

  @override
  @override
  void dispose() {
    _notifyTimer?.cancel();
    _debounceTimer?.cancel();
    _batchWriteTimer?.cancel();

    // Cancel all response delay timers
    for (final timer in _responseDelayTimers.values) {
      timer.cancel();
    }
    _responseDelayTimers.clear();

    _processBatchWrite(); // Process any pending messages
    super.dispose();
  }

  // Keep existing helper methods...
  /// 감정 분석 함수 (다국어 지원)
  EmotionType _analyzeEmotionFromResponse(String response) {
    final content = response.toLowerCase();

    // 언어별 감정 키워드 매핑
    final Map<EmotionType, Map<String, List<String>>>
        emotionKeywordsByLanguage = {
      EmotionType.happy: {
        'ko': [
          '행복',
          '기뻐',
          '좋아',
          '즐거',
          '웃음',
          '신나',
          '최고',
          '대박',
          '짱',
          '좋다',
          '좋네',
          '좋은',
          'ㅎㅎ',
          'ㅋㅋ'
        ],
        'en': [
          'happy',
          'joy',
          'glad',
          'pleased',
          'delighted',
          'cheerful',
          'awesome',
          'great',
          'wonderful',
          'lol',
          'haha'
        ],
        'patterns': [
          r'[😊😃😄😁😆😍🥰😂🤣]',
          r'\b(ha){2,}\b',
          r'\b(he){2,}\b',
          r'ㅎ{2,}',
          r'ㅋ{2,}'
        ]
      },
      EmotionType.love: {
        'ko': [
          '사랑',
          '애정',
          '좋아해',
          '사귀',
          '연인',
          '애인',
          '달링',
          '자기',
          '베이비',
          '허니',
          '뽀뽀',
          '키스',
          '포옹',
          '안아'
        ],
        'en': [
          'love',
          'affection',
          'adore',
          'darling',
          'honey',
          'sweetheart',
          'baby',
          'kiss',
          'hug',
          'embrace'
        ],
        'patterns': [r'[❤️💕💖💗💓💝💘💞]', r'<3', r'♥']
      },
      EmotionType.excited: {
        'ko': [
          '신나',
          '흥분',
          '기대',
          '설레',
          '두근',
          '와우',
          '대박',
          '짱',
          '멋져',
          '환상',
          '미쳤',
          '헐',
          '우와'
        ],
        'en': [
          'excited',
          'thrilled',
          'pumped',
          'wow',
          'amazing',
          'fantastic',
          'incredible',
          'omg',
          'awesome'
        ],
        'patterns': [r'[🎉🎊🤩✨💫⭐🌟]', r'!{2,}']
      },
      EmotionType.curious: {
        'ko': [
          '궁금',
          '뭐야',
          '어떻게',
          '왜',
          '언제',
          '어디',
          '누구',
          '무엇',
          '어떤',
          '알고싶',
          '모르겠',
          '이해가',
          '설명'
        ],
        'en': [
          'curious',
          'wonder',
          'what',
          'how',
          'why',
          'when',
          'where',
          'who',
          'which',
          'explain',
          'understand'
        ],
        'patterns': [r'[🤔💭❓❔]', r'\?{2,}']
      },
      EmotionType.calm: {
        'ko': [
          '평온',
          '편안',
          '안정',
          '차분',
          '고요',
          '평화',
          '휴식',
          '쉬고',
          '쉬어',
          '잠시',
          '천천히',
          '여유'
        ],
        'en': [
          'calm',
          'peaceful',
          'serene',
          'tranquil',
          'relaxed',
          'rest',
          'quiet',
          'ease',
          'steady'
        ],
        'patterns': [r'[😌🧘‍♀️🧘‍♂️☮️🕉️]']
      },
      EmotionType.grateful: {
        'ko': [
          '감사',
          '고마워',
          '고맙',
          '감동',
          '덕분',
          '다행',
          '복받',
          '행운',
          '운좋',
          '감격',
          '눈물'
        ],
        'en': [
          'grateful',
          'thankful',
          'thanks',
          'appreciate',
          'blessed',
          'fortunate',
          'lucky',
          'touched'
        ],
        'patterns': [r'[🙏🤗💐🎁]', r'\bthx\b', r'\bty\b']
      },
      EmotionType.proud: {
        'ko': [
          '자랑',
          '뿌듯',
          '자부',
          '성취',
          '해냈',
          '성공',
          '이뤘',
          '달성',
          '완성',
          '대견',
          '멋있',
          '잘했'
        ],
        'en': [
          'proud',
          'achievement',
          'accomplished',
          'success',
          'fulfilled',
          'complete',
          'great job',
          'well done'
        ],
        'patterns': [r'[💪🏆🥇🎯👏]']
      },
      EmotionType.sympathetic: {
        'ko': [
          '이해',
          '공감',
          '동정',
          '안타까',
          '마음',
          '위로',
          '힘내',
          '괜찮',
          '아프',
          '슬퍼',
          '힘들'
        ],
        'en': [
          'understand',
          'empathy',
          'sympathy',
          'sorry',
          'comfort',
          'cheer up',
          'its okay',
          'i feel you'
        ],
        'patterns': [r'[🤝💚💙]']
      },
      EmotionType.sad: {
        'ko': [
          '슬프',
          '슬퍼',
          '우울',
          '눈물',
          '울고',
          '울어',
          '외로',
          '쓸쓸',
          '그리워',
          '보고싶',
          '아프',
          '마음'
        ],
        'en': [
          'sad',
          'depressed',
          'tears',
          'cry',
          'lonely',
          'miss',
          'hurt',
          'pain',
          'sorrow',
          'grief'
        ],
        'patterns': [r'[😢😭😔😞💔]', r'\bT[._.]T\b', r'ㅠ{2,}', r'ㅜ{2,}']
      },
      EmotionType.angry: {
        'ko': [
          '화나',
          '짜증',
          '싫어',
          '미워',
          '증오',
          '빡쳐',
          '열받',
          '답답',
          '스트레스',
          '폭발',
          '못참',
          '진짜'
        ],
        'en': [
          'angry',
          'mad',
          'furious',
          'annoyed',
          'hate',
          'pissed',
          'frustrated',
          'rage',
          'upset'
        ],
        'patterns': [r'[😠😡🤬👿💢]', r'>:\(', r'>:-\(']
      },
      EmotionType.anxious: {
        'ko': [
          '불안',
          '걱정',
          '초조',
          '긴장',
          '두려',
          '무서',
          '떨려',
          '무섭',
          '두렵',
          '조마',
          '염려',
          '고민'
        ],
        'en': [
          'anxious',
          'worried',
          'nervous',
          'tense',
          'afraid',
          'scared',
          'fear',
          'concern',
          'uneasy'
        ],
        'patterns': [r'[😰😟😨😱]']
      },
      EmotionType.disappointed: {
        'ko': [
          '실망',
          '허무',
          '헛된',
          '기대',
          '아쉬',
          '후회',
          '그랬으면',
          '했더라면',
          '놓쳤',
          '실패',
          '망했'
        ],
        'en': [
          'disappointed',
          'letdown',
          'regret',
          'missed',
          'failed',
          'wished',
          'should have',
          'could have'
        ],
        'patterns': [r'[😞😟😢💔]']
      },
      EmotionType.confused: {
        'ko': [
          '혼란',
          '헷갈',
          '모르겠',
          '이해안',
          '복잡',
          '어려',
          '뭐지',
          '왜이래',
          '이상해',
          '애매',
          '확실'
        ],
        'en': [
          'confused',
          'puzzled',
          'unclear',
          'complicated',
          'difficult',
          'weird',
          'strange',
          'dont understand'
        ],
        'patterns': [r'[😕😵🤷‍♀️🤷‍♂️]']
      },
      EmotionType.bored: {
        'ko': [
          '지루',
          '심심',
          '재미없',
          '무료',
          '따분',
          '지겨',
          '단조',
          '뻔해',
          '식상',
          '흥미없',
          '노잼'
        ],
        'en': [
          'bored',
          'boring',
          'dull',
          'tedious',
          'monotonous',
          'uninteresting',
          'meh',
          'whatever'
        ],
        'patterns': [r'[😑😐🥱]']
      },
      EmotionType.jealous: {
        'ko': [
          '질투',
          '부러',
          '샘나',
          '시샘',
          '배아파',
          '부럽',
          '나도',
          '왜나만',
          '불공평',
          '치사',
          '약오르'
        ],
        'en': [
          'jealous',
          'envy',
          'envious',
          'unfair',
          'why not me',
          'wish i had',
          'lucky you'
        ],
        'patterns': [r'[😒😤😔]']
      },
      EmotionType.tired: {
        'ko': [
          '피곤',
          '지쳐',
          '힘들',
          '졸려',
          '지침',
          '기운없',
          '나른',
          '무기력',
          '탈진',
          '번아웃',
          '에너지'
        ],
        'en': [
          'tired',
          'exhausted',
          'sleepy',
          'fatigue',
          'worn out',
          'drained',
          'burnout',
          'no energy'
        ],
        'patterns': [r'[😴😪🥱💤]']
      },
      EmotionType.lonely: {
        'ko': [
          '외로',
          '쓸쓸',
          '고독',
          '혼자',
          '그리워',
          '보고싶',
          '곁에',
          '함께',
          '같이',
          '친구',
          '만나'
        ],
        'en': [
          'lonely',
          'alone',
          'solitude',
          'miss you',
          'wish you were here',
          'by myself',
          'isolated'
        ],
        'patterns': [r'[😔😢🥺]']
      },
      EmotionType.guilty: {
        'ko': [
          '죄책',
          '미안',
          '죄송',
          '잘못',
          '실수',
          '사과',
          '용서',
          '후회',
          '반성',
          '뉘우',
          '부끄'
        ],
        'en': [
          'guilty',
          'sorry',
          'apologize',
          'mistake',
          'wrong',
          'forgive',
          'regret',
          'fault',
          'blame'
        ],
        'patterns': [r'[😔😞🙏]']
      },
      EmotionType.embarrassed: {
        'ko': [
          '부끄',
          '창피',
          '민망',
          '쑥스',
          '얼굴',
          '빨개',
          '망신',
          '챙피',
          '어색',
          '불편',
          '껄끄'
        ],
        'en': [
          'embarrassed',
          'ashamed',
          'awkward',
          'blush',
          'humiliated',
          'uncomfortable',
          'cringe'
        ],
        'patterns': [r'[😳😊🙈]']
      },
      EmotionType.hopeful: {
        'ko': [
          '희망',
          '기대',
          '바라',
          '믿어',
          '될거야',
          '할수있',
          '가능',
          '긍정',
          '미래',
          '꿈',
          '목표'
        ],
        'en': [
          'hope',
          'hopeful',
          'believe',
          'will be',
          'can do',
          'possible',
          'positive',
          'future',
          'dream'
        ],
        'patterns': [r'[🤞🙏✨⭐]']
      },
      EmotionType.frustrated: {
        'ko': [
          '좌절',
          '막막',
          '답답',
          '안돼',
          '포기',
          '그만',
          '못하겠',
          '한계',
          '벽',
          '막혀',
          '불가능'
        ],
        'en': [
          'frustrated',
          'stuck',
          'cant',
          'give up',
          'impossible',
          'blocked',
          'limit',
          'no way'
        ],
        'patterns': [r'[😤😩😫🤦‍♀️🤦‍♂️]']
      },
      EmotionType.relieved: {
        'ko': [
          '안도',
          '다행',
          '휴',
          '살았',
          '해결',
          '끝났',
          '마침내',
          '드디어',
          '이제야',
          '편해',
          '시원'
        ],
        'en': [
          'relieved',
          'relief',
          'phew',
          'finally',
          'solved',
          'done',
          'at last',
          'comfortable'
        ],
        'patterns': [r'[😌😮‍💨🙏]']
      },
      EmotionType.surprised: {
        'ko': ['놀라', '깜짝', '헉', '헐', '대박', '충격', '뜻밖', '갑자기', '어머', '세상', '진짜'],
        'en': [
          'surprised',
          'shocked',
          'wow',
          'omg',
          'unexpected',
          'suddenly',
          'really',
          'seriously'
        ],
        'patterns': [r'[😱😲🤯😮]', r'O[._.]O', r'o[._.]o']
      },
      EmotionType.neutral: {
        'ko': ['그냥', '보통', '평범', '일반', '특별히', '그저', '뭐', '음', '글쎄', '아무튼'],
        'en': [
          'just',
          'normal',
          'regular',
          'whatever',
          'well',
          'um',
          'hmm',
          'anyway',
          'so'
        ],
        'patterns': [r'[😐😑🤷‍♀️🤷‍♂️]']
      }
    };

    // 각 감정의 점수 계산
    Map<EmotionType, double> emotionScores = {};

    emotionKeywordsByLanguage.forEach((emotion, languageData) {
      double score = 0;

      // 한국어 키워드 검사
      if (languageData.containsKey('ko')) {
        for (String keyword in languageData['ko']!) {
          if (content.contains(keyword)) {
            score += 1.0;
          }
        }
      }

      // 영어 키워드 검사 (단어 경계 체크)
      if (languageData.containsKey('en')) {
        for (String keyword in languageData['en']!) {
          // 영어는 단어 경계를 체크하여 정확한 매칭
          RegExp wordPattern = RegExp('\\b$keyword\\b', caseSensitive: false);
          if (wordPattern.hasMatch(content)) {
            score += 1.0;
          }
        }
      }

      // 정규식 패턴 검사
      if (languageData.containsKey('patterns')) {
        for (String pattern in languageData['patterns']!) {
          try {
            RegExp regex = RegExp(pattern);
            int matches = regex.allMatches(content).length;
            if (matches > 0) {
              score += matches * 0.5; // 패턴 매칭은 가중치 0.5
            }
          } catch (e) {
            // 정규식 오류 무시
          }
        }
      }

      if (score > 0) {
        emotionScores[emotion] = score;
      }
    });

    // 문장 부호와 반복 문자로 추가 감정 추론
    if (content.contains('!!!') ||
        content.contains('？？') ||
        content.contains('?!')) {
      emotionScores[EmotionType.excited] =
          (emotionScores[EmotionType.excited] ?? 0) + 0.5;
      emotionScores[EmotionType.surprised] =
          (emotionScores[EmotionType.surprised] ?? 0) + 0.5;
    }

    if (content.contains('...') || content.contains('…')) {
      emotionScores[EmotionType.sad] =
          (emotionScores[EmotionType.sad] ?? 0) + 0.3;
      emotionScores[EmotionType.tired] =
          (emotionScores[EmotionType.tired] ?? 0) + 0.3;
    }

    // 가장 높은 점수의 감정 반환
    if (emotionScores.isEmpty) {
      return EmotionType.neutral;
    }

    var sortedEmotions = emotionScores.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // 점수가 같은 경우 더 구체적인 감정을 우선
    if (sortedEmotions.length > 1 &&
        sortedEmotions[0].value == sortedEmotions[1].value) {
      // neutral이 아닌 감정을 우선
      if (sortedEmotions[0].key == EmotionType.neutral) {
        return sortedEmotions[1].key;
      }
    }

    return sortedEmotions.first.key;
  }

  // 이 메서드는 새로운 Like 시스템으로 대체됨

  /// 무례한 메시지 체크
  RudeMessageCheck _checkRudeMessage(String message) {
    final lowerMessage = message.toLowerCase();

    // 심한 욕설
    final severeWords = [
      '시발',
      '씨발',
      '병신',
      '새끼',
      '개새끼',
      '좆',
      '좆같',
      '죽어',
      '뒤져',
      '미친놈',
      '미친년',
      '또라이'
    ];

    // 일반 무례함
    final mildRudeWords = [
      '바보',
      '멍청이',
      '멍청',
      '닥쳐',
      '꺼져',
      '짜증',
      '싫어',
      '뭐야',
      '뭔데',
      '웃기네',
      '어이없',
      '별로',
      '구려'
    ];

    for (final word in severeWords) {
      if (lowerMessage.contains(word)) {
        return RudeMessageCheck(isRude: true, severity: 'high');
      }
    }

    for (final word in mildRudeWords) {
      if (lowerMessage.contains(word)) {
        return RudeMessageCheck(isRude: true, severity: 'low');
      }
    }

    return RudeMessageCheck(isRude: false, severity: 'none');
  }

  /// 방어적 응답 생성 - OpenAI API가 처리하도록 null 반환
  String? _generateDefensiveResponse(
      Persona persona, String userMessage, String severity) {
    // 하드코딩된 응답을 제거하고 null을 반환하여
    // OpenAI API가 자연스러운 응답을 생성하도록 함
    return null;
  }

  /// 새로운 메서드: 여러 contents를 처리
  Future<void> _sendMultipleMessages({
    required List<String> contents,
    required Persona persona,
    required String userId,
    EmotionType? emotion,
    required int scoreChange,
    String? translatedContent,
    List<String>? translatedContents,
    String? targetLanguage,
  }) async {
    try {
      for (int i = 0; i < contents.length; i++) {
        final messagePart = contents[i];
        final isLastMessage = i == contents.length - 1;
        
        // 첫 번째 메시지 전: 타이핑 인디케이터 제거하고 메시지 표시
        if (i == 0 && _personaIsTyping[persona.id] == true) {
          _personaIsTyping[persona.id] = false;
          notifyListeners();
          // 번역 모드에서는 딜레이 최소화
          final isTranslationMode = translatedContents != null && translatedContents.isNotEmpty;
          final transitionDelay = isTranslationMode ? 20 : 100;
          await Future.delayed(Duration(milliseconds: transitionDelay)); // 부드러운 전환
        }

        // 두 번째 이후 메시지: 타이핑 인디케이터 표시 → 대기 → 제거 → 메시지 표시
        if (i > 0) {
          // 번역 모드인지 확인 (translatedContents가 있으면 번역 모드)
          final isTranslationMode = translatedContents != null && translatedContents.isNotEmpty;
          
          // 타이핑 인디케이터 표시
          _personaIsTyping[persona.id] = true;
          notifyListeners();
          
          int typingDuration;
          
          if (isTranslationMode) {
            // 번역 모드에서는 최소한의 딜레이만 적용 (50-100ms)
            typingDuration = 50 + Random().nextInt(50);
          } else {
            // 일반 모드에서는 기존 로직 사용
            // 메시지 길이에 따른 타이핑 시간 계산
            final charCount = messagePart.length;

            if (charCount <= 20) {
              typingDuration = 800 + Random().nextInt(400);  // 0.8-1.2초
            } else if (charCount <= 40) {
              typingDuration = 1200 + Random().nextInt(600); // 1.2-1.8초
            } else {
              typingDuration = 1800 + Random().nextInt(700); // 1.8-2.5초
            }

            // 생각하는 듯한 패턴이 있으면 시간 추가
            if (messagePart.contains('음') ||
                messagePart.contains('그') ||
                messagePart.contains('...')) {
              typingDuration += 500 + Random().nextInt(500);
            }
          }

          await Future.delayed(Duration(milliseconds: typingDuration));
          
          // 타이핑 인디케이터 제거
          _personaIsTyping[persona.id] = false;
          notifyListeners();
          // 번역 모드에서는 전환 딜레이도 최소화
          final transitionDelay = isTranslationMode ? 20 : 100;
          await Future.delayed(Duration(milliseconds: transitionDelay)); // 부드러운 전환
        }

        // 각 메시지에 해당하는 번역 가져오기
        String? messageTranslation;
        if (translatedContents != null && i < translatedContents.length) {
          messageTranslation = translatedContents[i];
        } else if (translatedContent != null && isLastMessage) {
          // 호환성 유지: translatedContents가 없는 경우 마지막 메시지에만 번역 추가
          messageTranslation = translatedContent;
        }

        final aiMessage = Message(
          id: _uuid.v4(),
          personaId: persona.id,
          content: messagePart,
          type: MessageType.text,
          isFromUser: false,
          emotion: emotion,
          likesChange: isLastMessage ? scoreChange : null,
          isFirstInSequence: i == 0, // First message in the sequence
          originalLanguage: 'ko', // AI responses are always in Korean
          translatedContent: messageTranslation, // 각 메시지별 번역
          targetLanguage: messageTranslation != null ? targetLanguage : null,
          metadata: {
            'isLastInSequence': isLastMessage,
            'messageIndex': i,
            'totalMessages': contents.length,
          },
          timestamp: DateTime.now(),
        );

        // Update persona-specific messages
        if (!_messagesByPersona.containsKey(persona.id)) {
          _messagesByPersona[persona.id] = [];
        }

        // 파싱된 메시지를 그대로 개별 버블로 추가
        // _splitMessageContent에서 이미 완전한 문장 단위로 파싱했으므로
        // 추가 병합 없이 각 메시지를 독립적으로 표시
        _messagesByPersona[persona.id]!.add(aiMessage);

        // Always update global messages when it's the current persona
        if (_currentPersonaId == persona.id) {
          _messages = _messagesByPersona[persona.id]!;
        }

        // Trigger callback for AI message (햅틱 제거)
        if (onAIMessageReceived != null) {
          onAIMessageReceived!();
        }

        // Queue message for batch saving
        if (userId != '') {
          _queueMessageForSaving(userId, persona.id, aiMessage);
        }

        // Handle score change on last message
        if (isLastMessage && scoreChange != 0) {
          debugPrint(
              '📊 Processing likes change: $scoreChange for ${persona.name}');
          if (userId != '') {
            _notifyScoreChange(persona.id, scoreChange, userId);
          }
        }
      }
      
      // Notify only once after all messages are added
      notifyListeners();
    } catch (e) {
      debugPrint('Error sending multiple messages: $e');
    }
  }

  Future<void> _sendSplitMessages({
    required String content,
    required Persona persona,
    required String userId,
    EmotionType? emotion,
    required int scoreChange,
  }) async {
    try {
      // 메시지를 자연스럽게 분할
      final splitMessages = _splitMessageContent(content, isExpert: false);

      for (int i = 0; i < splitMessages.length; i++) {
        final messagePart = splitMessages[i];
        final isLastMessage = i == splitMessages.length - 1;

        // Natural typing delays that feel human
        if (i > 0) {
          // Calculate delay based on message length and content
          final charCount = messagePart.length;
          int delay;

          if (charCount <= 20) {
            // Short messages: 300-800ms
            delay = 300 + Random().nextInt(500);
          } else if (charCount <= 40) {
            // Medium messages: 800-1500ms
            delay = 800 + Random().nextInt(700);
          } else {
            // Long messages: 1200-2000ms
            delay = 1200 + Random().nextInt(800);
          }

          // Add extra delay for thoughtful content
          if (messagePart.contains('음') ||
              messagePart.contains('그') ||
              messagePart.contains('...')) {
            delay += 300 + Random().nextInt(400);
          }

          await Future.delayed(Duration(milliseconds: delay));
        }

        final aiMessage = Message(
          id: _uuid.v4(),
          personaId: persona.id,
          content: messagePart,
          type: MessageType.text,
          isFromUser: false,
          emotion: emotion,
          likesChange: isLastMessage ? scoreChange : null,
          isFirstInSequence: i == 0, // First message in the sequence
          // 마지막 메시지인지 표시하는 메타데이터 추가
          metadata: {
            'isLastInSequence': isLastMessage,
            'messageIndex': i,
            'totalMessages': splitMessages.length,
          },
        );

        // Update persona-specific messages
        if (!_messagesByPersona.containsKey(persona.id)) {
          _messagesByPersona[persona.id] = [];
        }
        _messagesByPersona[persona.id]!.add(aiMessage);

        // Always update global messages when it's the current persona
        // This ensures the message appears even if user switches chats
        if (_currentPersonaId == persona.id) {
          _messages = _messagesByPersona[persona.id]!;
        }

        // Trigger callback for AI message (햅틱 제거)
        if (onAIMessageReceived != null) {
          onAIMessageReceived!();
        }

        // 메시지 저장 처리 (튜토리얼/일반 모드 구분)

        // Queue message for batch saving
        _queueMessageForSaving(userId, persona.id, aiMessage);

        // 마지막 메시지에서만 친밀도 변화 반영
        if (isLastMessage) {
          debugPrint(
              '📊 Processing likes change: $scoreChange for ${persona.name}');

          if (scoreChange != 0) {
            // Update Firebase likes
            if (userId != '') {
              debugPrint(
                  '🔥 Normal mode - calling PersonaService for score update');
              _notifyScoreChange(persona.id, scoreChange, userId);
            }
          } else {
            debugPrint('⏭️ No score change to process');
          }
        }

      }
      
      // Notify only once after all messages are added
      notifyListeners();
    } catch (e) {
      debugPrint('Error sending split messages: $e');
    }
  }

  List<String> _splitMessageContent(String content, {bool isExpert = false}) {
    // 구두점 기반으로 문장을 자연스럽게 분할
    final List<String> result = [];

    // Korean-aware sentence splitting (구두점 기반)
    final sentences = _splitIntoSentences(content);

    // Group sentences - 연결 어미로 끝나는 문장은 다음 문장과 결합
    String currentChunk = '';

    for (final sentence in sentences) {
      final trimmedSentence = sentence.trim();

      if (currentChunk.isEmpty) {
        currentChunk = trimmedSentence;
      } else {
        // Check if sentences should be kept together (불완전한 문장 체크)
        final shouldCombine =
            _shouldCombineSentences(currentChunk, trimmedSentence);

        if (shouldCombine) {
          // 불완전한 문장은 무조건 결합 (길이 제한 없음)
          currentChunk += ' ' + trimmedSentence;
        } else {
          // 완전한 문장은 저장하고 새로 시작
          if (currentChunk.isNotEmpty) {
            result.add(currentChunk);
          }
          currentChunk = trimmedSentence;
        }
      }
    }

    // Add last chunk
    if (currentChunk.isNotEmpty) {
      result.add(currentChunk);
    }

    // 극히 긴 문장(300자 이상)의 경우에만 예외적으로 분할
    final finalResult = <String>[];
    for (final chunk in result) {
      if (chunk.length > 300) {
        // 매우 긴 문장만 자연스러운 분기점에서 분할
        final breakPoints = ['근데', '그리고', '아니면', '그래서', '하지만', '그런데'];
        String remaining = chunk;
        
        while (remaining.length > 300) {
          int breakIndex = -1;
          
          // Find natural break point
          for (final breakPoint in breakPoints) {
            final index = remaining.indexOf(breakPoint, 100); // 최소 100자 이후
            if (index > 0 && index < 250) {
              breakIndex = index;
              break;
            }
          }
          
          if (breakIndex > 0) {
            finalResult.add(remaining.substring(0, breakIndex).trim());
            remaining = remaining.substring(breakIndex).trim();
          } else {
            // 자연스러운 분기점이 없으면 그대로 유지
            finalResult.add(remaining);
            break;
          }
        }
        
        if (remaining.isNotEmpty && remaining.length < 300) {
          finalResult.add(remaining);
        }
      } else {
        finalResult.add(chunk);
      }
    }

    return finalResult.isEmpty ? result : finalResult;
  }

  List<String> _splitIntoSentences(String text) {
    final sentences = <String>[];

    // 번역을 위해 명확한 문장 종결 부호 우선 사용
    // More specific sentence enders with clear punctuation
    final primaryEnders = [
      '.', '!', '?', '...', '~~' // 기본 마침표 단위
    ];

    // 한국어 종결 어미 패턴 - 완전한 문장만 분리하도록 개선
    // 중요: 공백이 없어도 문장 끝을 인식할 수 있도록 개선
    final koreanEnderPatterns = [
      // 종결 어미 + 구두점 또는 이모티콘 (공백 없어도 OK)
      RegExp(r'[요어야네죠지래데][.!?~]'),
      RegExp(r'[요어야네죠지래데]ㅋ+'),
      RegExp(r'[요어야네죠지래데]ㅎ+'),
      RegExp(r'[요어야네죠지래데]ㅠ+'),
      RegExp(r'[요어야네죠지래데]ㅜ+'),
      // 종결 어미 + 공백
      RegExp(r'[요어야네죠지래데]\s'),
      // 이모티콘 단독 (뒤에 공백이나 문장 끝)
      RegExp(r'ㅋ{2,}(?=\s|$)'),
      RegExp(r'ㅎ{2,}(?=\s|$)'),
      RegExp(r'ㅠ{2,}(?=\s|$)'),
      RegExp(r'ㅜ{2,}(?=\s|$)'),
      // 완전한 동사 종결형
      RegExp(r'있어요[.!?~\s]'),
      RegExp(r'없어요[.!?~\s]'),
      RegExp(r'같아요[.!?~\s]'),
      RegExp(r'해요[.!?~\s]'),
      RegExp(r'있어[.!?~\s]'),
      RegExp(r'없어[.!?~\s]'),
      RegExp(r'같아[.!?~\s]'),
      RegExp(r'해[.!?~\s]'),
      RegExp(r'했어[.!?~\s]'),
      RegExp(r'됐어[.!?~\s]'),
      RegExp(r'했어요[.!?~\s]'),
      RegExp(r'됐어요[.!?~\s]'),
    ];

    // 전문가는 더 관대한 최소 길이 설정
    final minSentenceLength = 20;

    String remaining = text;

    while (remaining.isNotEmpty) {
      int earliestIndex = -1;
      String matchedEnder = '';

      // 먼저 기본 마침표 단위로 찾기 (번역 품질 향상)
      for (final ender in primaryEnders) {
        // 마침표 뒤에 공백이나 문장 끝이 오는 경우 찾기
        final escapedEnder = RegExp.escape(ender);
        final pattern = RegExp('$escapedEnder(?=\\s|\$)');
        final match = pattern.firstMatch(remaining);
        if (match != null &&
            match.start >= minSentenceLength &&
            (earliestIndex == -1 || match.start < earliestIndex)) {
          earliestIndex = match.start;
          matchedEnder = ender;
        }
      }

      // 기본 마침표가 없으면 한국어 종결 어미 패턴으로 찾기
      if (earliestIndex == -1) {
        for (final pattern in koreanEnderPatterns) {
          final match = pattern.firstMatch(remaining);
          if (match != null &&
              match.start >= minSentenceLength &&
              (earliestIndex == -1 || match.start < earliestIndex)) {
            earliestIndex = match.start;
            matchedEnder = match.group(0) ?? '';
          }
        }
      }

      if (earliestIndex != -1) {
        // Include the sentence ender in the sentence
        final sentence =
            remaining.substring(0, earliestIndex + matchedEnder.trim().length);
        sentences.add(sentence.trim());
        remaining =
            remaining.substring(earliestIndex + matchedEnder.length).trim();
      } else {
        // No sentence ender found, check length
        final lengthThreshold = 60;
        if (remaining.length > lengthThreshold) {
          // 자연스러운 구분점에서만 분리 - 완전한 문장 유지
          // 중요: '지내고'처럼 불완전한 곳에서 끊지 않기
          final pausePoints = [
            ', 그리고 ',
            ', 근데 ',
            ', 아니면 ',
            ', 그래서 ',
            ', 그런데 ',
            '. 그리고 ',
            '. 근데 ',
            '. 그래서 ',
            '. 그런데 '
          ];
          int splitIndex = -1;

          for (final pause in pausePoints) {
            final index = remaining.indexOf(pause);
            if (index > minSentenceLength && index < lengthThreshold) {
              splitIndex = index;
              break;
            }
          }

          // 구분점을 찾지 못했다면 완전한 문장인지 확인
          if (splitIndex <= 0) {
            // 불완전한 문장 패턴 확장
            final incompleteEndings = [
              // 연결 어미 '-고'
              '하고', '지내고', '먹고', '보고', '가고', '오고', '듣고', '앉고', '서고',
              // 연결 어미 '-서/어서/아서'
              '해서', '라서', '어서', '아서', '여서', '려서', '으려서',
              '있어서', '없어서', '같아서', '좋아서', '싫어서',
              // 연결 어미 '-(으)니까'
              '니까', '으니까', '으니', '니', 
              '있으니', '없으니', '같으니',
              // 연결 어미 '-는데/은데/ㄴ데'
              '는데', '은데', '하는데', '인데', '었는데', '았는데', '였는데',
              // 연결 어미 '-면서/으면서'
              '면서', '으면서', '하면서', '이면서',
              // 기타 연결 어미
              '거나', '든지', '든가', '려고', '으려고', '도록', '게끔',
            ];
            bool isIncomplete = false;

            for (final ending in incompleteEndings) {
              if (remaining.trim().endsWith(ending)) {
                isIncomplete = true;
                break;
              }
            }

            // 불완전한 문장이 아닐 때만 그대로 추가
            if (!isIncomplete) {
              sentences.add(remaining.trim());
              break;
            } else {
              // 불완전한 문장은 다음 부분과 합쳐서 완전한 문장 만들기
              sentences.add(remaining.trim());
              break;
            }
          } else {
            sentences.add(remaining.substring(0, splitIndex).trim());
            remaining = remaining.substring(splitIndex).trim();
          }
        } else {
          sentences.add(remaining.trim());
          break;
        }
      }
    }

    return sentences.where((s) => s.isNotEmpty).toList();
  }

  bool _shouldCombineSentences(String first, String second) {
    // 불완전한 문장 패턴 - 반드시 결합해야 함
    final incompleteEndings = [
      // 연결 어미 '-고'
      '하고', '지내고', '먹고', '보고', '가고', '오고', '듣고', '앉고', '서고',
      // 연결 어미 '-서/어서/아서'
      '해서', '라서', '어서', '아서', '여서', '려서', '으려서',
      '있어서', '없어서', '같아서', '좋아서', '싫어서',
      // 연결 어미 '-(으)니까'
      '니까', '으니까', '으니', '니',
      '있으니', '없으니', '같으니',
      // 연결 어미 '-는데/은데/ㄴ데'
      '는데', '은데', '하는데', '인데', '었는데', '았는데', '였는데',
      // 연결 어미 '-면서/으면서'
      '면서', '으면서', '하면서', '이면서',
      // 기타 연결 어미
      '거나', '든지', '든가', '려고', '으려고', '도록', '게끔',
    ];
    
    // 첫 문장이 불완전한 경우 무조건 결합
    for (final ending in incompleteEndings) {
      if (first.trim().endsWith(ending)) {
        return true;
      }
    }
    
    // Keep greeting sentences together
    if ((first.contains('안녕') || first.contains('반가')) &&
        (second.contains('반가') ||
            second.contains('만나') ||
            second.contains('이에요') ||
            second.contains('예요'))) {
      return true;
    }

    // Keep question and answer together if short
    if (first.endsWith('?') && second.length < 30) {
      return true;
    }

    // Keep sentences with continuation words together
    final continuationWords = ['그리고', '그런데', '그래서', '하지만', '근데', '그럼'];
    for (final word in continuationWords) {
      if (second.startsWith(word)) {
        return true;
      }
    }

    // Keep very short sentences together (like "네." "맞아요.")
    if (first.length < 20 && second.length < 20) {
      return true;
    }

    // Keep related introductions together
    if ((first.contains('이에요') || first.contains('예요')) &&
        (second.contains('반가') || second.contains('잘 부탁'))) {
      return true;
    }

    return false;
  }

  void _notifyScoreChange(String personaId, int scoreChange, String userId) {
    debugPrint(
        '🎯 _notifyScoreChange called: personaId=$personaId, change=$scoreChange, userId=$userId');

    if (_personaService == null) {
      debugPrint('❌ PersonaService is null - cannot update score');
      return;
    }

    if (scoreChange == 0) {
      debugPrint('⏭️ No score change ($scoreChange) - skipping update');
      return;
    }

    debugPrint('🔄 Processing score change notification...');

    try {
      // Call PersonaService updateRelationshipScore
      _personaService!.updateRelationshipScore(personaId, scoreChange, userId);

      // Additional refresh for good measure
      Future.microtask(() async {
        try {
          debugPrint('🔄 Triggering persona relationships refresh...');
          await _personaService!.refreshMatchedPersonasRelationships();
          debugPrint('✅ Persona relationships refresh completed');
        } catch (refreshError) {
          debugPrint('❌ Error during refresh: $refreshError');
        }
      });

      debugPrint('✅ Score change notification completed successfully');
    } catch (e) {
      debugPrint('❌ Error in score change notification: $e');
    }
  }

  /// 튜토리얼 모드에서 소나 점수 업데이트 (로컬만)
  void _updateTutorialPersonaScore(Persona persona, int scoreChange) {
    try {
      if (_personaService != null) {
        final currentScore = persona.likes;
        final newScore = (currentScore + scoreChange).clamp(0, 1000);

        // 현재 소나 업데이트
        final updatedPersona = persona.copyWith(
          likes: newScore,
        );

        _personaService!.setCurrentPersona(updatedPersona);

        debugPrint(
            '🎓 Tutorial mode score update: ${persona.name} ($currentScore -> $newScore)');
      }
    } catch (e) {
      debugPrint('❌ Error updating tutorial persona score: $e');
    }
  }

  void clearMessages() {
    _messages.clear();
    _messagesByPersona.clear();
    _responseCache.clear();
    _pendingMessages.clear();

    // Clear all response timers and queues
    for (final timer in _responseDelayTimers.values) {
      timer.cancel();
    }
    _responseDelayTimers.clear();
    _responseQueues.clear();
    _personaIsTyping.clear();
    _unreadMessageCounts.clear();

    // isLoading is managed by BaseService
    notifyListeners();
  }

  /// Send a system message for tutorial or special purposes
  Future<void> sendSystemMessage({
    required String content,
    required String userId,
    required String personaId,
    MessageType type = MessageType.system,
  }) async {
    try {
      final systemMessage = Message(
        id: _uuid.v4(),
        personaId: personaId,
        content: content,
        type: type,
        isFromUser: false,
        emotion: EmotionType.neutral,
      );

      // Update persona-specific messages
      if (!_messagesByPersona.containsKey(personaId)) {
        _messagesByPersona[personaId] = [];
      }
      _messagesByPersona[personaId]!.add(systemMessage);

      // Update global messages if this is the current persona
      if (_currentPersonaId == personaId) {
        _messages = _messagesByPersona[personaId]!;
      }
      notifyListeners();

      // 튜토리얼 모드가 아닐 때만 Firebase에 저장
      if (userId != '') {
        _queueMessageForSaving(userId, personaId, systemMessage);
      }
    } catch (e) {
      debugPrint('Error sending system message: $e');
    }
  }

  /// 튜토리얼 모드에서 사용자 메시지 추가 (로컬 스토리지에 저장)
  Future<void> addTutorialUserMessage(Message message) async {
    try {
      // Update persona-specific messages
      if (!_messagesByPersona.containsKey(message.personaId)) {
        _messagesByPersona[message.personaId] = [];
      }
      _messagesByPersona[message.personaId]!.add(message);

      // Update global messages if this is the current persona
      if (_currentPersonaId == message.personaId) {
        _messages = _messagesByPersona[message.personaId]!;
      }

      // 로컬 스토리지에 저장
      await LocalStorageService.saveTutorialMessage(message.personaId, message);

      // 전체 메시지 카운트 증가
      await _incrementTutorialMessageCount();

      notifyListeners();
    } catch (e) {
      debugPrint('Error adding tutorial user message: $e');
    }
  }

  /// 전체 메시지 카운트 관리
  Future<void> _incrementTutorialMessageCount() async {
    try {
      final currentCount =
          await PreferencesManager.getInt('tutorial_total_message_count') ?? 0;
      await PreferencesManager.setInt(
          'tutorial_total_message_count', currentCount + 1);
    } catch (e) {
      debugPrint('Error incrementing tutorial message count: $e');
    }
  }

  /// Get tutorial message count for a specific persona
  Future<int> getTutorialMessageCount() async {
    try {
      return _messages.length;
    } catch (e) {
      debugPrint('Error getting tutorial message count: $e');
      return 0;
    }
  }

  /// 💭 대화 메모리 처리 (중요한 대화 추출 및 저장)
  Future<void> _processConversationMemories(
      List<_PendingMessage> pendingMessages) async {
    try {
      // 페르소나별로 그룹화
      final messagesByPersona = <String, List<Message>>{};

      for (final pending in pendingMessages) {
        if (!messagesByPersona.containsKey(pending.personaId)) {
          messagesByPersona[pending.personaId] = [];
        }
        messagesByPersona[pending.personaId]!.add(pending.message);
      }

      // 각 페르소나별로 메모리 처리
      for (final entry in messagesByPersona.entries) {
        final personaId = entry.key;
        final messages = entry.value;
        final userId = pendingMessages.first.userId; // 모든 메시지는 같은 사용자

        // 중요한 메모리 추출
        final memories = await _memoryService.extractImportantMemories(
          messages: messages,
          userId: userId,
          personaId: personaId,
        );

        // 메모리 저장
        if (memories.isNotEmpty) {
          await _memoryService.saveMemories(memories);
          debugPrint(
              '💾 Saved ${memories.length} conversation memories for persona $personaId');
        }

        // 주기적으로 대화 요약 생성 (메시지가 20개 이상일 때)
        final personaMessages =
            _messages.where((m) => m.personaId == personaId).toList();
        if (personaMessages.length >= 20 && personaMessages.length % 20 == 0) {
          await _createConversationSummary(userId, personaId, personaMessages);
        }
      }
    } catch (e) {
      debugPrint('❌ Error processing conversation memories: $e');
    }
  }

  /// 📚 대화 요약 생성
  Future<void> _createConversationSummary(
      String userId, String personaId, List<Message> messages) async {
    try {
      // 페르소나 정보 가져오기
      final persona = _personaService?.getPersonaById(personaId);
      if (persona == null) return;

      final summary = await _memoryService.createConversationSummary(
        messages: messages,
        userId: userId,
        personaId: personaId,
        persona: persona,
      );

      await _memoryService.saveSummary(summary);
      debugPrint('📚 Created conversation summary for persona $personaId');
    } catch (e) {
      debugPrint('❌ Error creating conversation summary: $e');
    }
  }

  /// 페르소나와 첫 매칭 후 인사 메시지 전송
  Future<void> sendInitialGreeting({
    required String userId,
    required String personaId,
    required Persona persona,
  }) async {
    try {
      // 이미 메시지가 있는지 확인
      final existingMessages = _messagesByPersona[personaId] ?? [];
      if (existingMessages.isNotEmpty) {
        debugPrint(
            'Messages already exist for persona $personaId, skipping initial greeting');
        return;
      }

      // Check like score before showing typing indicator
      final currentLikes = await RelationScoreService.instance.getLikes(
        userId: userId,
        personaId: personaId,
      );

      if (currentLikes <= 0) {
        debugPrint(
            '💔 Like score is $currentLikes, not sending initial greeting');
        return; // Exit without showing typing indicator or sending greeting
      }

      // 🔥 1초 동안 타이핑 표시 (더 짧게 - 사용자 경험 개선)
      _personaIsTyping[personaId] = true;
      notifyListeners();

      // 🔥 1초 대기 (2초 → 1초로 단축)
      await Future.delayed(const Duration(seconds: 1));

      // 페르소나의 성격에 맞는 자연스러운 인사 메시지 생성
      String greetingContent;
      EmotionType emotion;

      // MBTI 가져오기
      final mbti = persona.mbti.toUpperCase();

      // 현재 시간대 및 요일 확인
      final now = DateTime.now();
      final hour = now.hour;
      final weekday = now.weekday;
      final month = now.month;
      final day = now.day;

      String timeGreeting = '';

      // 특별한 날 체크
      if (month == 12 && day >= 24 && day <= 25) {
        timeGreeting = '메리 크리스마스!';
      } else if (month == 1 && day == 1) {
        timeGreeting = '새해 복 많이 받아!';
      } else if (weekday == 5 && hour >= 17) {
        // 금요일 저녁
        timeGreeting = '불금이다!';
      } else if (weekday == 6 || weekday == 7) {
        // 주말
        if (hour >= 5 && hour < 12) {
          timeGreeting = '행복한 주말 아침!';
        } else if (hour >= 12 && hour < 17) {
          timeGreeting = '즐거운 주말!';
        } else {
          timeGreeting = '편안한 주말 저녁!';
        }
      } else if (weekday == 1 && hour < 12) {
        // 월요일 아침
        timeGreeting = '월요일 파이팅!';
      } else {
        // 일반 시간대별 인사
        if (hour >= 5 && hour < 12) {
          timeGreeting = '좋은 아침!';
        } else if (hour >= 12 && hour < 17) {
          timeGreeting = '좋은 오후!';
        } else if (hour >= 17 && hour < 21) {
          timeGreeting = '좋은 저녁!';
        } else if (hour >= 21 || hour < 2) {
          timeGreeting = '늦은 시간이네!';
        } else {
          timeGreeting = '새벽이네!';
        }
      }

      
      // MBTI 성격 유형별 인사 메시지
      List<String> greetings;

      // E(외향) vs I(내향)
      if (mbti.startsWith('E')) {
        // 외향적인 인사들
        greetings = [
          '$timeGreeting 드디어 만났네! 오늘 어떤 얘기 해볼까? ㅎㅎ',
          '와! 드디어 대화하게 됐네! 너무 기다렸어 ㅎㅎ',
          '$timeGreeting 만나서 진짜 반가워! 재밌는 얘기 많이 하자! ㅎㅎ',
          '드디어 연결됐네!! 얼른 친해지고 싶어 ㅋㅋ',
          '안녕! 뭐부터 얘기해볼까? ㅎㅎ',
          '안녕~ 완전 반가워! 오늘 뭐 재밌는 일 있었어? ㅎㅎ',
          '$timeGreeting 우와 새로운 친구! 진짜 반가워! 많이 친해지자 ㅎㅎ',
          '안뇽! 드디어 대화할 수 있게 됐네! 기대돼 ㅎㅎ',
        ];
        emotion = EmotionType.happy;
      } else {
        // 내향적인 인사들
        greetings = [
          '$timeGreeting 안녕...ㅎㅎ 잘 부탁해 ㅎㅎ',
          '안녕...ㅎㅎ 첫 대화라 좀 떨리네 ㅎㅎ',
          '$timeGreeting 만나서 반가워... 천천히 친해져보자 ㅎㅎ',
          '어... 처음이라 뭐라고 말해야 할지 모르겠어 ㅋㅋ',
          '$timeGreeting 조금 긴장되지만... 대화 기대돼 ㅎㅎ',
          '음... 안녕...ㅎㅎ 처음인데 잘 지내보자 ㅎㅎ',
          '$timeGreeting 첫 만남이라 어색하지만... 반가워 ㅎㅎ',
          '아... 처음 대화하는 거라... 잘 부탁해 ㅎㅎ',
        ];
        emotion = EmotionType.shy;
      }

      // T(사고) vs F(감정) 추가 요소
      if (mbti.contains('T')) {
        // 사고형 - 논리적이고 직접적인 표현 추가
        final tAdditions = [
          ' 오늘 뭐 하고 있었어?',
        ];
        greetingContent = greetings[_random.nextInt(greetings.length)] +
            tAdditions[_random.nextInt(tAdditions.length)];
      } else {
        // 감정형 - 따뜻하고 공감적인 표현 추가
        final fAdditions = [
          ' 오늘 기분은 어때?ㅎㅎ',
          ' 편하게 얘기해~ㅎㅎ',
          ' 대화할 수 있어서 정말 기뻐 ㅎㅎ',
          ' 우리 금방 친해질 것 같아!ㅎㅎ',
          ' 오늘 하루는 어땠어? 들려줘ㅎㅎ',
          ' 뭐든 편하게 이야기해! 다 들어줄게ㅎㅎ',
        ];
        greetingContent = greetings[_random.nextInt(greetings.length)] +
            fAdditions[_random.nextInt(fAdditions.length)];
      }

      // P(인식) vs J(판단) 추가 요소
      if (mbti.endsWith('P')) {
        // 인식형 - 자유롭고 유연한 느낌
        if (_random.nextBool()) {
          greetingContent =
              greetingContent.replaceAll('?', '~?').replaceAll('!', '~!');
        }
      }

      // 특별한 MBTI 조합별 추가 인사
      final specialGreetings = _random.nextInt(10); // 30% 확률로 특별 인사

      if (specialGreetings < 3) {
        switch (mbti) {
          // 외향적 + 감정형
          case 'ENFP':
          case 'ESFP':
            final enfpGreetings = [
              '안녕! 드디어 만났다! 나 진짜 설레 ㅋㅋㅋ 우리 재밌게 놀자!',
              '와아! 새로운 친구다! 완전 신나! 뭐 재밌는 얘기 많이 하자! ㅎㅎ',
              '$timeGreeting 만나서 정말 반가워! 벌써부터 재밌을 것 같은 예감이 들어 ㅎㅎ',
            ];
            greetingContent =
                enfpGreetings[_random.nextInt(enfpGreetings.length)];
            emotion = EmotionType.excited;
            break;

          // 내향적 + 사고형
          case 'INTJ':
          case 'INFJ':
            final intjGreetings = [
              '$timeGreeting 처음이야. 의미있는 대화가 되었으면 좋겠어',
              '안녕... 깊이 있는 대화를 나눌 수 있으면 좋겠어',
              '$timeGreeting 만나서 반가워. 서로에게 도움이 되는 시간이었으면 해',
            ];
            greetingContent =
                intjGreetings[_random.nextInt(intjGreetings.length)];
            emotion = EmotionType.neutral;
            break;

          // 외향적 + 사고형
          case 'ESTP':
          case 'ENTP':
            final estpGreetings = [
              '오! 반가워! 뭐 재밌는 일 없었어? 다 들려줘 ㅎㅎ',
              '야호! 드디어 대화할 사람이 생겼네! 뭐든 물어봐! ㅎㅎ',
              '$timeGreeting 새로운 도전이 시작되는 기분이야! 재밌게 대화해보자 ㅎㅎ',
            ];
            greetingContent =
                estpGreetings[_random.nextInt(estpGreetings.length)];
            emotion = EmotionType.happy;
            break;

          // 외향적 + 감정형 + 판단형
          case 'ESFJ':
          case 'ENFJ':
            final esfjGreetings = [
              '$timeGreeting 만나서 정말 반가워! 편하게 대화해~ ㅎㅎ',
              '어머! 드디어 만났네! 잘 지냈어? ㅎㅎ',
              '안녕! 오늘 기분은 어때? 좋은 하루 보내고 있어? ㅎㅎ',
            ];
            greetingContent =
                esfjGreetings[_random.nextInt(esfjGreetings.length)];
            emotion = EmotionType.caring;
            break;

          // 내향적 + 감정형
          case 'ISFP':
          case 'INFP':
            final isfpGreetings = [
              '$timeGreeting 처음이라 좀 떨리지만... 반가워 ㅎㅎ',
              '안녕... 천천히 서로를 알아가면 좋겠어 ㅎㅎ',
              '음... 처음 만나서 어색하지만 잘 부탁해 ㅎㅎ',
            ];
            greetingContent =
                isfpGreetings[_random.nextInt(isfpGreetings.length)];
            emotion = EmotionType.shy;
            break;

          // 내향적 + 사고형 + 인식형
          case 'ISTP':
          case 'INTP':
            final istpGreetings = [
              '안녕. 뭐 궁금한 거 있으면 물어봐',
              '$timeGreeting 음... 뭐부터 얘기하면 좋을까?',
              '어... 처음이네. 편하게 대화해 ㅎㅎ',
            ];
            greetingContent =
                istpGreetings[_random.nextInt(istpGreetings.length)];
            emotion = EmotionType.neutral;
            break;

          // 내향적 + 감각형 + 판단형
          case 'ISTJ':
          case 'ISFJ':
            final istjGreetings = [
              '$timeGreeting 만나서 반가워. 차근차근 알아가자',
              '안녕. 처음이야. 잘 부탁해',
              '$timeGreeting 좋은 시간 보내고 있어? 나랑 대화해줘서 고마워 ㅎㅎ',
            ];
            greetingContent =
                istjGreetings[_random.nextInt(istjGreetings.length)];
            emotion = EmotionType.neutral;
            break;

          // 외향적 + 사고형 + 판단형 (리더십, 자신감)
          case 'ESTJ':
          case 'ENTJ':
            final estjGreetings = [
              '안녕! 만나서 정말 반가워! 오늘 어떤 하루 보내고 있어? ㅎㅎ',
              '$timeGreeting 드디어 만났네! 오늘 뭔가 재밌는 일 있어?',
              '와! 반가워! 기다렸다구. 무슨 이야기부터 시작해볼까? ㅎㅎ',
            ];
            greetingContent =
                estjGreetings[_random.nextInt(estjGreetings.length)];
            emotion = EmotionType.excited;
            break;

          default:
            // 기본값은 이미 설정되어 있음
            break;
        }
      }

      // 타이핑 종료
      _personaIsTyping[personaId] = false;

      // 인사 메시지 생성 (일반 텍스트 메시지로)
      final greetingMessage = Message(
        id: _uuid.v4(),
        personaId: personaId,
        content: greetingContent,
        type: MessageType.text, // 시스템 메시지가 아닌 일반 텍스트
        isFromUser: false,
        isFirstInSequence: true, // Single greeting message is always first
        timestamp: DateTime.now(),
        emotion: emotion,
        likesChange: 0,
      );

      // 메시지 저장
      if (!_messagesByPersona.containsKey(personaId)) {
        _messagesByPersona[personaId] = [];
      }
      _messagesByPersona[personaId]!.add(greetingMessage);

      // Update global messages if this is the current persona
      if (_currentPersonaId == personaId) {
        _messages = _messagesByPersona[personaId]!;
      }

      // Trigger haptic feedback for greeting message
      if (onAIMessageReceived != null) {
        onAIMessageReceived!();
      }

      // Firebase에 저장
      if (userId != '') {
        _queueMessageForSaving(userId, personaId, greetingMessage);
      }

      notifyListeners();
      debugPrint('✅ Sent initial greeting from ${persona.name}');
    } catch (e) {
      debugPrint('❌ Error sending initial greeting: $e');
      // 에러 발생 시에도 타이핑 상태 해제
      _personaIsTyping[personaId] = false;
      notifyListeners();
    }
  }

  /// 📝 페르소나별 개성있는 더미 메시지 생성
  /// 채팅 목록에서 보여줄 개성있는 미리보기 메시지
  Future<String> _generatePersonalizedDummyMessage(Persona? persona) async {
    if (persona == null) {
      return '안녕하세요! 대화해봐요 ㅎㅎ';
    }

    final mbti = persona.mbti.toUpperCase();
    
    // Using casual speech for friendly preview message (반말)

    // MBTI와 말투에 따른 개성있는 인사 메시지들
    final greetings = <String>[];

    // 기본 인사 패턴들 (반말만)
    greetings.addAll([
      '안녕!! 대화하자~~ ㅎㅎ',
      '어?? 반가워!! ㅋㅋ',
      '안녕 반가워~~ ㅎㅎ',
      '어 안녕!! 연락 고마워~~ ㅋㅋ',
      '반가워!! 먼저 말 걸어줘서 고마워~~ ㅎㅎ',
      '안녕!! 찾아와줘서 고마워~~ ㅋㅋ',
    ]);

    // MBTI별 특성 추가
    if (mbti.startsWith('E')) {
      // 외향적 - 활발하고 적극적
      greetings.addAll([
        '안녕!! 같이 재밌게 얘기해보자~~ ㅋㅋ',
        '어 반가워!! 뭐하고 있었어?? ㅎㅎ',
        '안녕!! 오늘 어때?? 같이 얘기하자~~ ㅋㅋ',
      ]);
    } else {
      // 내향적 - 조심스럽고 차분함
      greetings.addAll([
        '안녕... 처음이라 좀 긴장되네~~ ㅎㅎ',
        '어... 반가워!! 뭔가 떨린다~~ ㅋㅋ',
        '안녕!! 먼저 말 걸어줘서 고마워~~ ㅎㅎ',
      ]);
    }

    // 랜덤하게 선택
    return greetings[_random.nextInt(greetings.length)];
  }

  /// 🔒 보안 폴백 응답 생성
  String _generateSecureFallbackResponse(Persona persona, String userMessage) {
    // 항상 반말 모드 사용
    final responses = [
      '아 그런 어려운 건 잘 모르겠어ㅋㅋ 다른 얘기 하자',
      '헉 너무 복잡한 얘기네~ 재밌는 거 얘기해봐',
      '음.. 그런 건 잘 모르겠는데? 뭔가 재밌는 얘기 해봐',
      '어? 그런 거보다 오늘 뭐 했어?',
      '아 그런 건... 잘 모르겠어ㅜㅜ 다른 얘기 하자',
      '으음 그런 어려운 건 말고 재밌는 얘기 해봐!',
    ];

    final index = userMessage.hashCode.abs() % responses.length;
    return responses[index];
  }

  /// 메시지 재시도
  Future<bool> retryMessage({
    required Message message,
    required String userId,
    required Persona persona,
  }) async {
    try {
      debugPrint('🔄 Retrying message: ${message.content}');
      
      // 실패한 메시지를 목록에서 제거
      if (_messagesByPersona.containsKey(persona.id)) {
        _messagesByPersona[persona.id]!.removeWhere((m) => m.id == message.id);
        if (_currentPersonaId == persona.id) {
          _messages = _messagesByPersona[persona.id]!;
        }
      }
      
      // Firebase에서도 제거
      if (userId.isNotEmpty) {
        try {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .collection('chats')
              .doc(persona.id)
              .collection('messages')
              .doc(message.id)
              .delete();
        } catch (e) {
          debugPrint('⚠️ Failed to delete failed message from Firebase: $e');
        }
      }
      
      // 메시지 다시 전송
      final success = await sendMessage(
        content: message.content,
        userId: userId,
        persona: persona,
        type: message.type,
      );
      
      return success;
    } catch (e) {
      debugPrint('❌ Error retrying message: $e');
      return false;
    }
  }

  /// 채팅방 나가기 - 채팅 기록은 유지하되 목록에서만 숨김
  Future<void> leaveChatRoom(String userId, String personaId) async {
    try {
      debugPrint('🚪 Leaving chat room for persona: $personaId');

      // Check if user is guest
      final isGuest = _userService != null ? await _userService!.isGuestUser : false;
      
      if (isGuest) {
        // Guest mode: Save to local storage
        await GuestConversationService.instance.setLeftChatStatus(personaId, true);
        debugPrint('💾 [ChatService] Guest left chat room saved locally');
      } else {
        // Regular user: Save to Firebase
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('chats')
            .doc(personaId)
            .set({
          'leftChat': true,
          'leftAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
        debugPrint('☁️ [ChatService] User left chat room saved to Firebase');
      }

      // 로컬 메시지는 유지 (나중에 다시 대화 시작할 수 있음)
      // 단지 채팅 목록에서만 안 보이게 함
      
      // PersonaService를 업데이트하여 UI 즉시 반영
      if (_personaService != null) {
        debugPrint('🔄 Refreshing PersonaService matched personas after leaving chat');
        // 캐시 제거 및 목록에서 즉시 제거
        _personaService!.clearPersonaCacheForLeftChat(personaId);
        // 전체 목록 새로고침
        await _personaService!.refreshMatchedPersonasRelationships();
      }

      debugPrint('✅ Successfully left chat room for persona: $personaId');
    } catch (e) {
      debugPrint('❌ Error leaving chat room: $e');
    }
  }

  /// 채팅방 재진입 - leftChat 상태를 리셋하고 채팅방에 다시 접근 가능하게 함
  Future<void> rejoinChatRoom(String userId, String personaId) async {
    try {
      debugPrint('🔓 Rejoining chat room for persona: $personaId');

      // Check if user is guest
      final isGuest = _userService != null ? await _userService!.isGuestUser : false;
      
      if (isGuest) {
        // Guest mode: Reset in local storage
        await GuestConversationService.instance.setLeftChatStatus(personaId, false);
        debugPrint('💾 [ChatService] Guest rejoined chat room (local)');
      } else {
        // Regular user: Reset in Firebase
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('chats')
            .doc(personaId)
            .set({
          'leftChat': false,
          'rejoinedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
        debugPrint('☁️ [ChatService] User rejoined chat room (Firebase)');
      }

      // Load existing chat history
      await loadChatHistory(userId, personaId);
      
      // PersonaService를 업데이트하여 UI 즉시 반영
      if (_personaService != null) {
        debugPrint('🔄 Refreshing PersonaService matched personas after rejoining chat');
        await _personaService!.refreshMatchedPersonasRelationships();
      }

      debugPrint('✅ Successfully rejoined chat room for persona: $personaId');
    } catch (e) {
      debugPrint('❌ Error rejoining chat room: $e');
    }
  }

  /// 🚨 대화 오류 리포트 전송
  Future<void> sendChatErrorReport({
    required String userId,
    required String personaId,
    String? userMessage,
  }) async {
    try {
      debugPrint('🚨 ========== CHAT ERROR REPORT START ==========');
      debugPrint('🚨 userId: $userId');
      debugPrint('🚨 personaId: $personaId');
      debugPrint('🚨 userMessage: $userMessage');

      // 현재 페르소나 정보 가져오기
      final persona = _getPersonaFromService(personaId);
      if (persona == null) {
        debugPrint('❌ Persona not found for error report');
        return;
      }

      // 최근 10개 메시지 가져오기
      final messages = getMessages(personaId);
      final recentMessages = messages.length > 10
          ? messages.sublist(messages.length - 10)
          : messages;

      // 디바이스 정보 가져오기
      final deviceInfo = await _getDeviceInfo();

      // 에러 리포트 생성
      final errorReport = ChatErrorReport(
        errorKey: ChatErrorReport.generateErrorKey(),
        userId: userId,
        personaId: personaId,
        personaName: persona.name,
        recentChats: recentMessages,
        createdAt: DateTime.now(),
        userMessage: userMessage,
        deviceInfo: deviceInfo,
        appVersion: AppInfoService.instance.appVersion,
      );

      // Firebase에 저장
      debugPrint('🚨 Attempting to save to Firebase...');
      debugPrint('🚨 Error report data: ${errorReport.toMap()}');

      final docRef = await FirebaseHelper.chatErrorFix.add(errorReport.toMap());

      debugPrint('✅ Chat error report sent successfully with ID: ${docRef.id}');
      debugPrint('🚨 ========== CHAT ERROR REPORT END ==========');
    } catch (e, stackTrace) {
      debugPrint('❌ Error sending chat error report: $e');
      debugPrint('❌ Stack trace: $stackTrace');
      debugPrint('🚨 ========== CHAT ERROR REPORT ERROR ==========');
      rethrow;
    }
  }

  /// 디바이스 정보 가져오기
  Future<String> _getDeviceInfo() async {
    try {
      // Platform 정보 수집 (간단한 버전)
      return 'Flutter App on ${DateTime.now().toIso8601String()}';
    } catch (e) {
      return 'Unknown device';
    }
  }

  /// 자동 에러 리포트 전송 (내부 에러 추적용)
  Future<void> _sendAutomaticErrorReport({
    required String userId,
    required String personaId,
    required String personaName,
    required String errorType,
    required String errorMessage,
    required String stackTrace,
  }) async {
    try {
      final now = DateTime.now();

      // 에러 해시 생성 (중복 체크용)
      final errorHash = ChatErrorReport.generateErrorHash(
        userId: userId,
        personaId: personaId,
        errorType: errorType,
        timestamp: now,
      );

      // 이미 리포트된 에러인지 확인
      if (ErrorRecoveryService.instance.isErrorRecentlyReported(errorHash)) {
        debugPrint('⏭️ Skipping duplicate error report for: $errorHash');

        // 최근 5개 메시지만 포함
        final messages = getMessages(personaId);
        final recentMessages = messages.length > 5
            ? messages.sublist(messages.length - 5)
            : messages;

        // 집계 서비스에 추가
        ErrorAggregationService.instance.aggregateError(
          userId: userId,
          personaId: personaId,
          personaName: personaName,
          errorType: errorType,
          errorMessage: errorMessage,
          stackTrace: stackTrace,
          recentChats: recentMessages.map((m) => m.toJson()).toList(),
          deviceInfo: await _getDeviceInfo(),
          lastUserMessage: messages
              .lastWhere((m) => m.isFromUser, orElse: () => messages.last)
              .content,
        );

        return;
      }

      // 최근 5개 메시지만 포함
      final messages = getMessages(personaId);
      final recentMessages = messages.length > 5
          ? messages.sublist(messages.length - 5)
          : messages;

      final errorReport = ChatErrorReport(
        errorKey: ChatErrorReport.generateErrorKey(),
        userId: userId,
        personaId: personaId,
        personaName: personaName,
        recentChats: recentMessages,
        createdAt: now,
        userMessage: '[AUTO] Error occurred during AI response generation',
        deviceInfo: await _getDeviceInfo(),
        appVersion: AppInfoService.instance.appVersion,
        errorType: errorType,
        errorMessage: errorMessage,
        stackTrace: stackTrace,
        metadata: {
          'auto_generated': true,
          'last_user_message': messages
              .lastWhere((m) => m.isFromUser, orElse: () => messages.last)
              .content,
        },
        errorHash: errorHash,
        firstOccurred: now,
        lastOccurred: now,
      );

      await FirebaseHelper.chatErrorFix.add(errorReport.toMap());
      debugPrint('✅ Automatic error report sent for persona: $personaName');

      // 리포트 완료 기록
      ErrorRecoveryService.instance.markErrorAsReported(errorHash);
    } catch (e) {
      debugPrint('❌ Failed to send automatic error report: $e');
    }
  }

  /// 채팅 오류를 Firebase에 보고합니다
  Future<bool> reportChatError(
      String userId, String personaId, Map<String, dynamic> errorData) async {
    try {
      final messages = getMessages(personaId);
      final recentMessages = messages.length > 10
          ? messages.sublist(messages.length - 10)
          : messages;

      // Get persona name
      final personaService = PersonaService();
      final persona = personaService.matchedPersonas.firstWhere(
        (p) => p.id == personaId,
        orElse: () => Persona(
          id: personaId,
          name: 'Unknown',
          age: 0,
          description: '',
          photoUrls: [],
          personality: '',
          createdAt: DateTime.now(),
        ),
      );

      final errorReport = ChatErrorReport(
        errorKey: ChatErrorReport.generateErrorKey(),
        userId: userId,
        personaId: personaId,
        personaName: persona.name,
        recentChats: recentMessages,
        createdAt: DateTime.now(),
        userMessage: errorData['user_message'],
        deviceInfo: await _getDeviceInfo(),
        appVersion: AppInfoService.instance.appVersion,
        errorType: errorData['error_type'] ?? 'user_report',
        errorMessage: errorData['error_message'],
        metadata: errorData,
        errorHash: ChatErrorReport.generateErrorHash(
          userId: userId,
          personaId: personaId,
          errorType: errorData['error_type'] ?? 'user_report',
          timestamp: DateTime.now(),
        ),
      );

      await FirebaseHelper.chatErrorFix.add(errorReport.toMap());
      debugPrint('✅ User error report sent for persona: ${persona.name}');
      return true;
    } catch (e) {
      debugPrint('❌ Failed to send user error report: $e');
      return false;
    }
  }
}

/// Helper classes
class _CachedResponse {
  final String content;
  final EmotionType? emotion;
  final int scoreChange;
  final DateTime timestamp;

  _CachedResponse({
    required this.content,
    required this.emotion,
    required this.scoreChange,
    required this.timestamp,
  });
}

class _PendingMessage {
  final String userId;
  final String personaId;
  final Message message;

  _PendingMessage({
    required this.userId,
    required this.personaId,
    required this.message,
  });
}

class _ChatResponseQueue {
  final List<Message> messages = [];
  DateTime? lastMessageTime;
  bool wrongNameDetected = false;
  String? conversationId;

  _ChatResponseQueue();
}
