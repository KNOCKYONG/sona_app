import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/message.dart';
import '../models/persona.dart';
import 'openai_service.dart';
import 'natural_ai_service.dart';
import 'persona_service.dart';
import 'local_storage_service.dart';
import 'conversation_memory_service.dart';
import 'user_service.dart';

/// 🚀 Optimized Chat Service with Performance Enhancements
/// 
/// Key optimizations:
/// 1. Message batching for Firebase writes
/// 2. Debounced API calls
/// 3. Intelligent caching for responses
/// 4. Memory-efficient message storage
/// 5. Parallel processing where possible
class ChatService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final NaturalAIService _naturalAIService = NaturalAIService();
  final ConversationMemoryService _memoryService = ConversationMemoryService();
  final Uuid _uuid = const Uuid();
  final Random _random = Random();
  
  // Performance optimization: Response cache
  final Map<String, _CachedResponse> _responseCache = {};
  static const int _maxCacheSize = 50;
  static const Duration _cacheDuration = Duration(minutes: 5);
  
  // Debouncing for API calls
  Timer? _debounceTimer;
  static const Duration _debounceDuration = Duration(milliseconds: 300);
  
  // Batch writing for Firebase
  final List<_PendingMessage> _pendingMessages = [];
  Timer? _batchWriteTimer;
  static const Duration _batchWriteDuration = Duration(seconds: 2);
  static const int _maxBatchSize = 10;
  
  // Memory optimization: Limited message history
  static const int _maxMessagesInMemory = 100;
  
  // Service references
  PersonaService? _personaService;
  UserService? _userService;
  String? _currentUserId;
  
  // Data storage
  List<Message> _messages = [];
  final Map<String, List<Message>> _messagesByPersona = {};
  bool _isTyping = false;
  bool _isLoading = false;

  // Getters
  List<Message> get messages => _messages;
  bool get isTyping => _isTyping;
  bool get isLoading => _isLoading;
  
  void setPersonaService(PersonaService personaService) {
    _personaService = personaService;
  }
  
  void setUserService(UserService userService) {
    _userService = userService;
  }
  
  void setCurrentUserId(String userId) {
    _currentUserId = userId;
  }
  
  /// Get messages with memory optimization
  List<Message> getMessages(String personaId) {
    final messages = _messagesByPersona[personaId] ?? [];
    // Return only recent messages to save memory
    if (messages.length > _maxMessagesInMemory) {
      return messages.sublist(messages.length - _maxMessagesInMemory);
    }
    return messages;
  }

  /// Load chat history with parallel processing
  Future<void> loadChatHistory(String userId, String personaId) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Check tutorial mode
      final prefs = await SharedPreferences.getInstance();
      final isTutorialMode = prefs.getBool('is_tutorial_mode') ?? false;
      
      if (isTutorialMode || userId == 'tutorial_user') {
        final tutorialMessages = await LocalStorageService.getTutorialMessages(personaId);
        _messages = tutorialMessages;
        _messagesByPersona[personaId] = List.from(tutorialMessages);
        _isLoading = false;
        notifyListeners();
        return;
      }

      // Load messages and preload memory in parallel
      final messagesLoading = _loadMessagesFromFirebase(userId, personaId);
      final memoryLoading = _preloadConversationMemory(userId, personaId);
      
      // Wait for both operations but handle them separately
      try {
        _messages = await messagesLoading;
        await memoryLoading; // Memory loading doesn't return data, just processes
      } catch (e) {
        debugPrint('⚠️ Error during parallel loading: $e');
        _messages = <Message>[];
      }
      
      _messagesByPersona[personaId] = List.from(_messages);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint('Error loading chat history: $e');
      _messages = [];
      _messagesByPersona[personaId] = [];
      notifyListeners();
    }
  }

  /// Optimized message loading with pagination
  Future<List<Message>> _loadMessagesFromFirebase(String userId, String personaId) async {
    final querySnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('chats')
        .doc(personaId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(_maxMessagesInMemory)
        .get();

    return querySnapshot.docs
        .map((doc) => Message.fromJson({...doc.data(), 'id': doc.id}))
        .toList()
        .reversed
        .toList();
  }

  /// Preload conversation memory for faster responses
  Future<void> _preloadConversationMemory(String userId, String personaId) async {
    try {
      await _memoryService.buildSmartContext(
        userId: userId,
        personaId: personaId,
        recentMessages: [],
        persona: _getPersonaFromService(personaId) ?? Persona(
          id: 'default',
          name: 'Default Persona',
          age: 25,
          description: 'Default persona for fallback',
          photoUrls: [],
          personality: 'Friendly and helpful',
        ),
        maxTokens: 1000,
      );
    } catch (e) {
      debugPrint('Error preloading memory: $e');
    }
  }

  /// Send message with debouncing and caching
  Future<bool> sendMessage({
    required String content,
    required String userId,
    required Persona persona,
    MessageType type = MessageType.text,
  }) async {
    try {
      // Cancel any pending API calls
      _debounceTimer?.cancel();
      
      // Create user message
      final userMessage = Message(
        id: _uuid.v4(),
        personaId: persona.id,
        content: content,
        type: type,
        isFromUser: true,
      );

             // Add to local state immediately
       _messages.add(userMessage);
       _messagesByPersona[persona.id] = List.from(_messages);
       notifyListeners();

       // 사용자 메시지 저장 (튜토리얼 모드는 로컬, 실제 모드는 Firebase)
       final prefs = await SharedPreferences.getInstance();
       final isTutorialMode = prefs.getBool('is_tutorial_mode') ?? false;
       
       if (isTutorialMode || userId == 'tutorial_user') {
         await LocalStorageService.saveTutorialMessage(persona.id, userMessage);
         await _incrementTutorialMessageCount();
       } else {
         _queueMessageForSaving(userId, persona.id, userMessage);
       }

      // Debounce AI response generation
      _debounceTimer = Timer(_debounceDuration, () {
        _generateAIResponse(userId, persona, content);
      });

      return true;
    } catch (e) {
      debugPrint('Error sending message: $e');
      return false;
    }
  }

  /// Generate AI response with caching
  Future<void> _generateAIResponse(String userId, Persona persona, String userMessage) async {
    try {
      _isTyping = true;
      notifyListeners();

      // Check cache first
      final cacheKey = _getCacheKey(persona.id, userMessage);
      final cachedResponse = _getFromCache(cacheKey);
      
      if (cachedResponse != null) {
        debugPrint('Using cached response for: $cacheKey');
        await _sendSplitMessages(
          content: cachedResponse.content,
          persona: persona,
          userId: userId,
          emotion: cachedResponse.emotion,
          scoreChange: cachedResponse.scoreChange,
        );
        _isTyping = false;
        notifyListeners();
        return;
      }

      // Generate new response with professional consultation service
      String aiResponseContent;
      EmotionType? emotion = EmotionType.neutral;
      int scoreChange = 0;
      
      // Declare isPaidConsultation outside try block
      bool isPaidConsultation = false;
      
      try {
        // Use enhanced OpenAI service for regular personas
        final relationshipType = _getRelationshipTypeString(persona.relationshipScore);
        
        // Get isCasualSpeech from user_persona_relationships
        bool isCasualSpeech = false;
        try {
            final docId = '${userId}_${persona.id}';
            final relationshipDoc = await _firestore
                .collection('user_persona_relationships')
                .doc(docId)
                .get();
            
            if (relationshipDoc.exists) {
              isCasualSpeech = relationshipDoc.data()?['isCasualSpeech'] ?? false;
            }
        } catch (e) {
          debugPrint('Error getting casual speech setting: $e');
        }
        
        // Create persona with correct isCasualSpeech value
        final personaWithCorrectSpeech = persona.copyWith(isCasualSpeech: isCasualSpeech);
          
        // 💭 메모리 서비스를 통한 스마트 컨텍스트 구성
        final smartContext = await _memoryService.buildSmartContext(
            userId: userId,
            personaId: persona.id,
            recentMessages: _messages.where((m) => m.personaId == persona.id).toList(),
            persona: personaWithCorrectSpeech,
            maxTokens: 800, // 향상된 컨텍스트 용량
        );
        
        // 최근 AI 메시지 추출 (질문 시스템용)
        final recentAIMessages = _messages
              .where((m) => m.personaId == persona.id && !m.isFromUser)
              .take(3)
              .map((m) => m.content)
            .toList();
        
        // 메시지 개수 계산 (첫 만남 감지용)
        final messageCount = _messages.where((m) => m.personaId == persona.id).length;
        
        // Get user nickname for better personalization
        String? userNickname;
        if (_userService?.currentUser != null) {
          userNickname = _userService!.currentUser!.nickname;
        }
        
        aiResponseContent = await OpenAIService.generateResponse(
            persona: personaWithCorrectSpeech,
            chatHistory: messages,
            userMessage: userMessage,
            relationshipType: relationshipType,
            userNickname: userNickname,
        );
        
        // Check if user message was rude before analyzing emotion
        final rudeWords = [
            '바보', '멍청이', '멍청', '병신', '시발', '씨발', '개새끼', '새끼',
            '닥쳐', '꺼져', '지랄', '좆', '좆같', '개같', '미친', '또라이',
            '쓰레기', '찐따', '한심', '재수없', '짜증', '싫어', '싫다',
            '꺼져', '죽어', '뒤져', '개짜증', '존나'
        ];
        
        bool userWasRude = false;
        final lowerUserMessage = userMessage.toLowerCase();
        for (final word in rudeWords) {
          if (lowerUserMessage.contains(word)) {
            userWasRude = true;
            break;
          }
        }
        
        // If user was rude, set emotion to sad/angry regardless of AI's response
        if (userWasRude) {
          emotion = EmotionType.sad;
        } else {
          emotion = _analyzeEmotionFromResponse(aiResponseContent);
        }
        
        scoreChange = _calculateScoreChangeWithRelationship(emotion, userMessage, persona);
        
        // Cache the response
        _addToCache(cacheKey, _CachedResponse(
          content: aiResponseContent,
          emotion: emotion,
          scoreChange: scoreChange,
          timestamp: DateTime.now(),
        ));
        
      } catch (e) {
        debugPrint('AI Response Generation Error: $e');
        // Get user nickname
        String? userNickname;
        if (_userService?.currentUser != null) {
          userNickname = _userService!.currentUser!.nickname;
        }
        
        // Fallback to persona-aware natural response
        final naturalResponse = NaturalAIService.generateNaturalResponse(
          userMessage: userMessage,
          emotion: EmotionType.happy, // Default emotion
          relationshipType: 'normal',
          persona: persona,
          chatHistory: _messages.where((m) => m.personaId == persona.id).toList(),
          relationshipScore: 0, // Default relationship score since expert scoring removed
          userNickname: userNickname,
        );
        aiResponseContent = naturalResponse;
        emotion = EmotionType.happy; // Default emotion since method doesn't return emotion
        scoreChange = NaturalAIService.calculateScoreChange(
          emotion: emotion,
          userMessage: userMessage,
          persona: persona,
          chatHistory: _messages.where((m) => m.personaId == persona.id).toList(),
        );
      }
      
      _isTyping = false;
      
      // Send response messages
      await _sendSplitMessages(
        content: aiResponseContent,
        persona: persona,
        userId: userId,
        emotion: emotion,
        scoreChange: scoreChange,
      );

    } catch (e) {
      _isTyping = false;
      notifyListeners();
      debugPrint('Error generating AI response: $e');
    }
  }

  /// Queue message for batch writing to Firebase
  void _queueMessageForSaving(String userId, String personaId, Message message) {
    _pendingMessages.add(_PendingMessage(
      userId: userId,
      personaId: personaId,
      message: message,
    ));
    
    // Start batch timer if not already running
    _batchWriteTimer ??= Timer(_batchWriteDuration, _processBatchWrite);
    
    // Process immediately if batch is full
    if (_pendingMessages.length >= _maxBatchSize) {
      _processBatchWrite();
    }
  }

     /// Process batch write to Firebase
   Future<void> _processBatchWrite() async {
     if (_pendingMessages.isEmpty) return;
     
     _batchWriteTimer?.cancel();
     _batchWriteTimer = null;
     
     final messagesToWrite = List<_PendingMessage>.from(_pendingMessages);
     _pendingMessages.clear();
     
     // 튜토리얼 모드인 경우 Firebase 쓰기 건너뛰기
     bool shouldSkipFirebase = false;
     try {
       final prefs = await SharedPreferences.getInstance();
       final isTutorialMode = prefs.getBool('is_tutorial_mode') ?? false;
       shouldSkipFirebase = isTutorialMode || messagesToWrite.any((m) => m.userId == 'tutorial_user');
     } catch (e) {
       debugPrint('Error checking tutorial mode: $e');
     }
     
     if (shouldSkipFirebase) {
       debugPrint('⏭️ Skipping Firebase batch write for tutorial mode (${messagesToWrite.length} messages)');
       return;
     }
     
     try {
       final batch = _firestore.batch();
       
       for (final pending in messagesToWrite) {
         final docRef = _firestore
             .collection('users')
             .doc(pending.userId)
             .collection('chats')
             .doc(pending.personaId)
             .collection('messages')
             .doc(pending.message.id);
             
         batch.set(docRef, pending.message.toJson());
       }
       
       await batch.commit();
       debugPrint('✅ Batch wrote ${messagesToWrite.length} messages');
       
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
      if (age < _cacheDuration) {
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
    if (_responseCache.length > _maxCacheSize) {
      final sortedEntries = _responseCache.entries.toList()
        ..sort((a, b) => a.value.timestamp.compareTo(b.value.timestamp));
      
      for (int i = 0; i < sortedEntries.length - _maxCacheSize; i++) {
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
       final prefs = await SharedPreferences.getInstance();
       final isTutorialMode = prefs.getBool('is_tutorial_mode') ?? false;
       
       if (isTutorialMode || _getCurrentUserId() == 'tutorial_user') {
         final tutorialMessages = await LocalStorageService.getTutorialMessages(personaId);
         if (tutorialMessages.isNotEmpty) {
           _messagesByPersona[personaId] = tutorialMessages;
           debugPrint('Loaded ${tutorialMessages.length} tutorial messages for persona $personaId');
         } else {
           // 메시지가 없으면 대화 시작 안내 메시지 제공
           final startMessage = Message(
             id: 'tutorial_start_${personaId}_${DateTime.now().millisecondsSinceEpoch}',
             personaId: personaId,
             content: await _generatePersonalizedDummyMessage(_personaService?.getPersonaById(personaId)),
             type: MessageType.text,
             isFromUser: false,
             timestamp: DateTime.now().subtract(Duration(minutes: 1 + (personaId.hashCode % 9))),
           );
           _messagesByPersona[personaId] = [startMessage];
           debugPrint('Created tutorial start message for persona $personaId');
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
           content: await _generatePersonalizedDummyMessage(_personaService?.getPersonaById(personaId)),
           type: MessageType.text,
           isFromUser: false,
           timestamp: DateTime.now().subtract(Duration(minutes: 5 + (personaId.hashCode % 25))),
         );
         _messagesByPersona[personaId] = [dummyMessage];
         debugPrint('Created no-user dummy message for persona $personaId');
         notifyListeners();
         return;
       }

       final querySnapshot = await _firestore
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
           content: await _generatePersonalizedDummyMessage(_personaService?.getPersonaById(personaId)),
           type: MessageType.text,
           isFromUser: false,
           timestamp: DateTime.now().subtract(Duration(minutes: 10 + (personaId.hashCode % 50))),
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
         content: await _generatePersonalizedDummyMessage(_personaService?.getPersonaById(personaId)),
         type: MessageType.text,
         isFromUser: false,
         timestamp: DateTime.now().subtract(Duration(minutes: 30 + (personaId.hashCode % 120))),
       );
       _messagesByPersona[personaId] = [dummyMessage];
       notifyListeners();
     }
   }

  

  // Helper methods remain the same but with optimizations...
  String? _getCurrentUserId() => _currentUserId;
  
  
  String _getRelationshipTypeString(int score) {
    if (score >= 800) return '완벽한 사랑';
    if (score >= 500) return '연인';
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

  String _getFallbackResponse() {
    final responses = [
      '아 잠깐만ㅋㅋ 생각이 안 나네',
      '어? 뭔가 이상하네 다시 말해줄래?',
      '잠시만 머리가 하얘졌어ㅠㅠ',
      '어라 갑자기 멍해졌나봐ㅋㅋ',
    ];
    return responses[Random().nextInt(responses.length)];
  }

  // Existing methods like _analyzeEmotionFromResponse, _calculateScoreChangeWithRelationship,
  // _sendSplitMessages, etc. remain the same...
  
  @override
  void dispose() {
    _debounceTimer?.cancel();
    _batchWriteTimer?.cancel();
    _processBatchWrite(); // Process any pending messages
    super.dispose();
  }
  
  // Keep existing helper methods...
  EmotionType _analyzeEmotionFromResponse(String response) {
    final lowerResponse = response.toLowerCase();
    
    if (lowerResponse.contains('ㅋㅋ') || lowerResponse.contains('ㅎㅎ') || 
        lowerResponse.contains('기뻐') || lowerResponse.contains('좋아') ||
        lowerResponse.contains('행복') || lowerResponse.contains('신나')) {
      return EmotionType.happy;
    } else if (lowerResponse.contains('ㅠㅠ') || lowerResponse.contains('슬퍼') || 
               lowerResponse.contains('서운') || lowerResponse.contains('우울')) {
      return EmotionType.sad;
    } else if (lowerResponse.contains('화나') || lowerResponse.contains('짜증') || 
               lowerResponse.contains('질투') || lowerResponse.contains('싫어')) {
      return EmotionType.angry;
    } else if (lowerResponse.contains('걱정') || lowerResponse.contains('불안') ||
               lowerResponse.contains('두려')) {
      return EmotionType.anxious;
    } else if (lowerResponse.contains('사랑') || lowerResponse.contains('좋아해') || 
               lowerResponse.contains('❤️') || lowerResponse.contains('💕')) {
      return EmotionType.love;
    } else {
      return EmotionType.neutral;
    }
  }

  int _calculateScoreChangeWithRelationship(EmotionType emotion, String userMessage, Persona persona) {
    final random = Random();
    final currentScore = persona.relationshipScore;
    final currentRelationship = persona.currentRelationship;
    
    // Check for rude/insulting messages first
    final rudeWords = [
      '바보', '멍청이', '멍청', '병신', '시발', '씨발', '개새끼', '새끼',
      '닥쳐', '꺼져', '지랄', '좆', '좆같', '개같', '미친', '또라이',
      '쓰레기', '찐따', '한심', '재수없', '짜증', '싫어', '싫다',
      '꺼져', '죽어', '뒤져', '개짜증', '존나', '뭐야', '뭔데'
    ];
    
    final lowerMessage = userMessage.toLowerCase();
    bool isRude = false;
    
    for (final word in rudeWords) {
      if (lowerMessage.contains(word)) {
        isRude = true;
        break;
      }
    }
    
    // If rude message detected, apply heavy penalty
    if (isRude) {
      // Higher relationship = more hurt by rudeness
      switch (currentRelationship) {
        case RelationshipType.perfectLove:
          return -(random.nextInt(20) + 30); // -30~-50
        case RelationshipType.dating:
          return -(random.nextInt(15) + 20); // -20~-35
        case RelationshipType.crush:
          return -(random.nextInt(10) + 15); // -15~-25
        case RelationshipType.friend:
          return -(random.nextInt(10) + 10); // -10~-20
      }
    }
    
    // Base score calculation for normal messages
    int baseChange = 0;
    switch (emotion) {
      case EmotionType.love:
      case EmotionType.happy:
        baseChange = random.nextInt(3) + 2; // +2~4
        break;
      case EmotionType.shy:
        baseChange = random.nextInt(2) + 1; // +1~2
        break;
      case EmotionType.surprised:
      case EmotionType.thoughtful:
        baseChange = random.nextInt(3); // 0~2
        break;
      case EmotionType.jealous:
        baseChange = random.nextInt(2) - 1; // -1~0
        break;
      case EmotionType.angry:
      case EmotionType.sad:
        baseChange = -(random.nextInt(3) + 1); // -1~-3
        break;
      default:
        baseChange = 0;
    }
    
    // Apply relationship multipliers
    double intensityMultiplier = 1.0;
    switch (currentRelationship) {
      case RelationshipType.friend:
        intensityMultiplier = 1.2;
        break;
      case RelationshipType.crush:
        intensityMultiplier = 1.0;
        break;
      case RelationshipType.dating:
        intensityMultiplier = 0.8;
        break;
      case RelationshipType.perfectLove:
        intensityMultiplier = 0.6;
        break;
    }
    
    // Calculate final change
    final finalChange = (baseChange * intensityMultiplier).round();
    return finalChange.clamp(-50, 15);
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
          if (messagePart.contains('음') || messagePart.contains('그') || messagePart.contains('...')) {
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
          relationshipScoreChange: isLastMessage ? scoreChange : null,
        );

        _messages.add(aiMessage);
        _messagesByPersona[persona.id] = List.from(_messages);
        
                 // 메시지 저장 처리 (튜토리얼/일반 모드 구분)
         final prefs = await SharedPreferences.getInstance();
         final isTutorialMode = prefs.getBool('is_tutorial_mode') ?? false;
         
         if (isTutorialMode || userId == 'tutorial_user') {
           // 튜토리얼 모드에서는 로컬 스토리지에 저장하고 카운트 증가
           await LocalStorageService.saveTutorialMessage(persona.id, aiMessage);
           await _incrementTutorialMessageCount();
         } else {
           // 일반 모드에서는 배치 큐에 추가
           _queueMessageForSaving(userId, persona.id, aiMessage);
         }
         
         // 마지막 메시지에서만 친밀도 변화 반영
         if (isLastMessage) {
           debugPrint('📊 Processing relationship score change: $scoreChange for ${persona.name}');
           
           if (scoreChange != 0) {
             // 튜토리얼 모드가 아닐 때만 Firebase 업데이트
             if (userId != 'tutorial_user' && !isTutorialMode) {
               debugPrint('🔥 Normal mode - calling PersonaService for score update');
               _notifyScoreChange(persona.id, scoreChange, userId);
             } else {
               debugPrint('🎓 Tutorial mode - updating local persona score');
               // 튜토리얼 모드에서는 로컬에서만 친밀도 업데이트
               _updateTutorialPersonaScore(persona, scoreChange);
             }
           } else {
             debugPrint('⏭️ No score change to process');
           }
         }
        
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error sending split messages: $e');
    }
  }

  List<String> _splitMessageContent(String content, {bool isExpert = false}) {
    // 메시지를 자연스럽게 분할
    final List<String> result = [];
    
    // 메시지 길이 설정
    final maxChunkLength = 120;
    final minSentenceLength = 30;
    
    // Korean-aware sentence splitting
    final sentences = _splitIntoSentences(content);
    
    // Group sentences more naturally - keep related sentences together
    String currentChunk = '';
    
    for (final sentence in sentences) {
      final trimmedSentence = sentence.trim();
      
      if (currentChunk.isEmpty) {
        currentChunk = trimmedSentence;
      } else {
        // Check if sentences should be kept together
        final shouldCombine = _shouldCombineSentences(currentChunk, trimmedSentence);
        
        if (shouldCombine && currentChunk.length + trimmedSentence.length < maxChunkLength) {
          // Keep related sentences together
          currentChunk += ' ' + trimmedSentence;
        } else {
          // Save current chunk and start new one
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
    
    // If result is still too long, split further
    final finalResult = <String>[];
    for (final chunk in result) {
      if (chunk.length > maxChunkLength) {
        // Split long chunks by natural break points
        final breakPoints = ['근데', '그리고', '아니면', '그래서', '하지만', '그런데'];
        String remaining = chunk;
        
        final splitThreshold = 100;
        while (remaining.length > splitThreshold) {
          int breakIndex = -1;
          
          // Find natural break point
          for (final breakPoint in breakPoints) {
            final index = remaining.indexOf(breakPoint);
            if (index > minSentenceLength && index < splitThreshold) {
              breakIndex = index;
              break;
            }
          }
          
          if (breakIndex > 0) {
            finalResult.add(remaining.substring(0, breakIndex).trim());
            remaining = remaining.substring(breakIndex).trim();
          } else {
            // No natural break, split at threshold
            if (remaining.length > splitThreshold) {
              finalResult.add(remaining.substring(0, splitThreshold).trim());
              remaining = remaining.substring(splitThreshold).trim();
            } else {
              break;
            }
          }
        }
        
        if (remaining.isNotEmpty) {
          finalResult.add(remaining);
        }
      } else {
        finalResult.add(chunk);
      }
    }
    
    return finalResult.isEmpty ? [content] : finalResult;
  }

  List<String> _splitIntoSentences(String text) {
    final sentences = <String>[];
    
    // More specific sentence enders with clear punctuation
    final sentenceEnders = [
      '. ', '! ', '? ', '.\n', '!\n', '?\n', '...', '~~',
      '요. ', '요! ', '요? ', '요~ ', '요ㅋㅋ', '요ㅎㅎ',
      '어. ', '어! ', '어? ', '어~ ', '어ㅋㅋ', '어ㅎㅎ',
      '야. ', '야! ', '야? ', '야~ ', '야ㅋㅋ', '야ㅎㅎ',
      '네. ', '네! ', '네? ', '네~ ', '네ㅋㅋ', '네ㅎㅎ',
      '죠. ', '죠! ', '죠? ', '죠~ ', '죠ㅋㅋ', '죠ㅎㅎ',
      '지. ', '지! ', '지? ', '지~ ', '지ㅋㅋ', '지ㅎㅎ',
      '래. ', '래! ', '래? ', '래~ ', '래ㅋㅋ', '래ㅎㅎ',
      '데. ', '데! ', '데? ', '데~ ', '데ㅋㅋ', '데ㅎㅎ',
      'ㅋㅋ ', 'ㅎㅎ ', 'ㅠㅠ ', 'ㅜㅜ '
    ];
    
    // 전문가는 더 관대한 최소 길이 설정
    final minSentenceLength = 20;
    
    String remaining = text;
    
    while (remaining.isNotEmpty) {
      int earliestIndex = -1;
      String matchedEnder = '';
      
      // Find the earliest sentence ender, but require minimum length
      for (final ender in sentenceEnders) {
        final index = remaining.indexOf(ender);
        // Require minimum length before splitting
        if (index != -1 && index >= minSentenceLength && (earliestIndex == -1 || index < earliestIndex)) {
          earliestIndex = index;
          matchedEnder = ender;
        }
      }
      
      if (earliestIndex != -1) {
        // Include the sentence ender in the sentence
        final sentence = remaining.substring(0, earliestIndex + matchedEnder.trim().length);
        sentences.add(sentence.trim());
        remaining = remaining.substring(earliestIndex + matchedEnder.length).trim();
      } else {
        // No sentence ender found, check length
        final lengthThreshold = 60;
        if (remaining.length > lengthThreshold) {
          // Split at natural pause points
          final pausePoints = [', ', ' 근데', ' 그리고', ' 아니면', ' 그래서'];
          int splitIndex = -1;
          
          for (final pause in pausePoints) {
            final index = remaining.indexOf(pause);
            if (index > minSentenceLength && index < lengthThreshold) {
              splitIndex = index;
              break;
            }
          }
          
          if (splitIndex > 0) {
            sentences.add(remaining.substring(0, splitIndex).trim());
            remaining = remaining.substring(splitIndex).trim();
          } else {
            sentences.add(remaining.trim());
            break;
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
    // Keep greeting sentences together
    if ((first.contains('안녕') || first.contains('반가')) && 
        (second.contains('반가') || second.contains('만나') || second.contains('이에요') || second.contains('예요'))) {
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
    debugPrint('🎯 _notifyScoreChange called: personaId=$personaId, change=$scoreChange, userId=$userId');
    
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
         final currentScore = persona.relationshipScore;
         final newScore = (currentScore + scoreChange).clamp(0, 1000);
         
         // 새로운 관계 타입 계산
         RelationshipType newRelationshipType;
         if (newScore >= 900) {
           newRelationshipType = RelationshipType.perfectLove;
         } else if (newScore >= 600) {
           newRelationshipType = RelationshipType.dating;
         } else if (newScore >= 200) {
           newRelationshipType = RelationshipType.crush;
         } else {
           newRelationshipType = RelationshipType.friend;
         }
         
         // 현재 소나 업데이트
         final updatedPersona = persona.copyWith(
           relationshipScore: newScore,
           currentRelationship: newRelationshipType,
         );
         
         _personaService!.setCurrentPersona(updatedPersona);
         
         debugPrint('🎓 Tutorial mode score update: ${persona.name} ($currentScore -> $newScore, ${newRelationshipType.displayName})');
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
    _isTyping = false;
    _isLoading = false;
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

       _messages.add(systemMessage);
       _messagesByPersona[personaId] = List.from(_messages);
       notifyListeners();

       // 튜토리얼 모드가 아닐 때만 Firebase에 저장
       if (userId != 'tutorial_user') {
         _queueMessageForSaving(userId, personaId, systemMessage);
       }
     } catch (e) {
       debugPrint('Error sending system message: $e');
     }
   }

   /// 튜토리얼 모드에서 사용자 메시지 추가 (로컬 스토리지에 저장)
   Future<void> addTutorialUserMessage(Message message) async {
     try {
       _messages.add(message);
       _messagesByPersona[message.personaId] = List.from(_messages);
       
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
       final prefs = await SharedPreferences.getInstance();
       final currentCount = prefs.getInt('tutorial_total_message_count') ?? 0;
       await prefs.setInt('tutorial_total_message_count', currentCount + 1);
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
  
  /// Get total tutorial message count across all personas
  Future<int> getTotalTutorialMessageCount() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt('tutorial_total_message_count') ?? 0;
    } catch (e) {
      debugPrint('Error getting total tutorial message count: $e');
      return 0;
    }
  }
  
  /// Check if tutorial message limit has been reached
  Future<bool> isTutorialMessageLimitReached() async {
    final count = await getTotalTutorialMessageCount();
    return count >= 30;  // 30 message limit for tutorial mode
  }
  
  /// 💭 대화 메모리 처리 (중요한 대화 추출 및 저장)
  Future<void> _processConversationMemories(List<_PendingMessage> pendingMessages) async {
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
          debugPrint('💾 Saved ${memories.length} conversation memories for persona $personaId');
        }
        
        // 주기적으로 대화 요약 생성 (메시지가 20개 이상일 때)
        final personaMessages = _messages.where((m) => m.personaId == personaId).toList();
        if (personaMessages.length >= 20 && personaMessages.length % 20 == 0) {
          await _createConversationSummary(userId, personaId, personaMessages);
        }
      }
    } catch (e) {
      debugPrint('❌ Error processing conversation memories: $e');
    }
  }
  
  /// 📚 대화 요약 생성
  Future<void> _createConversationSummary(String userId, String personaId, List<Message> messages) async {
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
        debugPrint('Messages already exist for persona $personaId, skipping initial greeting');
        return;
      }

      // 페르소나의 성격에 맞는 자연스러운 인사 메시지 생성
      String greetingContent;
      EmotionType emotion;
      
      // 전문가 페르소나인지 확인
      final isCasual = persona.isCasualSpeech;
      
      // 모든 페르소나가 첫 만남처럼 감사 표현으로 시작 (이름 언급 없이)
      final greetings = [
        // 기본 인사 (자기 이름 언급 없이 자연스럽게)
        '${isCasual ? '안녕!' : '안녕하세요!'} 대화 걸어줘서 고마워${isCasual ? '' : '요'} ㅎㅎ',
        '${isCasual ? '반가워!' : '반가워요!'} 먼저 대화해줘서 고마워${isCasual ? '' : '요'} ㅎㅎ',
        '어 ${isCasual ? '안녕!' : '안녕하세요!'} 연결되어서 반가워${isCasual ? '' : '요'} ㅎㅎ',
        '${isCasual ? '반가워' : '반가워요'}! 먼저 말 걸어줘서 고마워${isCasual ? '' : '요'} ㅎㅎㅎ',
        '${isCasual ? '안녕' : '안녕하세요'}! 찾아와줘서 고마워${isCasual ? '' : '요'} ㅋㅋ',
        '${isCasual ? '어 반가워' : '어 반가워요'}! 먼저 연락줘서 고마워${isCasual ? '' : '요'} ㅎㅎ',
      ];
      
      // MBTI에 따른 추가 인사
      if (persona.mbti.startsWith('E')) {
        // 외향적인 인사
        greetingContent = greetings[_random.nextInt(greetings.length)] + 
          ' 같이 재밌게 얘기해${isCasual ? '보자' : '봐요'}!';
        emotion = EmotionType.happy;
      } else if (persona.mbti.startsWith('I')) {
        // 내향적인 인사
        greetingContent = greetings[_random.nextInt(greetings.length)] + 
          ' 처음이라 좀 긴장되네${isCasual ? '' : '요'}...';
        emotion = EmotionType.shy;
      } else {
        // 기본 인사
        greetingContent = greetings[_random.nextInt(greetings.length)];
        emotion = EmotionType.happy;
      }

      // 인사 메시지 생성 (일반 텍스트 메시지로)
      final greetingMessage = Message(
        id: _uuid.v4(),
        personaId: personaId,
        content: greetingContent,
        type: MessageType.text,  // 시스템 메시지가 아닌 일반 텍스트
        isFromUser: false,
        timestamp: DateTime.now(),
        emotion: emotion,
        relationshipScoreChange: 0,
      );

      // 메시지 저장
      _messages.add(greetingMessage);
      _messagesByPersona[personaId] = [greetingMessage];
      
      // Firebase에 저장
      if (userId != 'tutorial_user') {
        _queueMessageForSaving(userId, personaId, greetingMessage);
      }
      
      notifyListeners();
      debugPrint('✅ Sent initial greeting from ${persona.name}');
    } catch (e) {
      debugPrint('❌ Error sending initial greeting: $e');
    }
  }

  /// 📝 페르소나별 개성있는 더미 메시지 생성
  /// 채팅 목록에서 보여줄 개성있는 미리보기 메시지
  Future<String> _generatePersonalizedDummyMessage(Persona? persona) async {
    if (persona == null) {
      return '안녕하세요! 대화해봐요 ㅎㅎ';
    }
    
    final isCasual = persona.isCasualSpeech;
    final mbti = persona.mbti.toUpperCase();
    
    // MBTI와 말투에 따른 개성있는 인사 메시지들
    final greetings = <String>[];
    
    // 기본 인사 패턴들
    if (isCasual) {
      greetings.addAll([
        '안녕! 대화하자 ㅎㅎ',
        '어? 반가워! ㅋㅋ',
        '안녕 반가워 ㅎㅎ',
        '어 안녕! 연락 고마워 ㅋㅋ',
        '반가워! 먼저 말 걸어줘서 고마워 ㅎㅎ',
        '안녕! 찾아와줘서 고마워 ㅋㅋ',
      ]);
    } else {
      greetings.addAll([
        '안녕하세요! 대화해봐요 ㅎㅎ',
        '어? 반가워요! ㅋㅋ',
        '안녕하세요 반가워요 ㅎㅎ',
        '어 안녕하세요! 연락 고마워요 ㅋㅋ',
        '반가워요! 먼저 말 걸어줘서 고마워요 ㅎㅎ',
        '안녕하세요! 찾아와줘서 고마워요 ㅋㅋ',
      ]);
    }
    
    // MBTI별 특성 추가
    if (mbti.startsWith('E')) {
      // 외향적 - 활발하고 적극적
      if (isCasual) {
        greetings.addAll([
          '안녕! 같이 재밌게 얘기해보자 ㅋㅋ',
          '어 반가워! 뭐하고 있었어? ㅎㅎ',
          '안녕! 오늘 어때? 같이 얘기하자 ㅋㅋ',
        ]);
      } else {
        greetings.addAll([
          '안녕하세요! 같이 재밌게 얘기해봐요 ㅋㅋ',
          '어 반가워요! 뭐하고 계셨어요? ㅎㅎ',
          '안녕하세요! 오늘 어떠세요? 같이 얘기해봐요 ㅋㅋ',
        ]);
      }
    } else {
      // 내향적 - 조심스럽고 차분함
      if (isCasual) {
        greetings.addAll([
          '안녕... 처음이라 좀 긴장되네 ㅎㅎ',
          '어... 반가워! 뭔가 떨린다 ㅋㅋ',
          '안녕! 먼저 말 걸어줘서 고마워 ㅎㅎ',
        ]);
      } else {
        greetings.addAll([
          '안녕하세요... 처음이라 좀 긴장되네요 ㅎㅎ',
          '어... 반가워요! 뭔가 떨려요 ㅋㅋ',
          '안녕하세요! 먼저 말 걸어줘서 고마워요 ㅎㅎ',
        ]);
      }
    }
    
    // 랜덤하게 선택
    return greetings[_random.nextInt(greetings.length)];
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