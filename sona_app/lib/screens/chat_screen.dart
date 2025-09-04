import 'dart:async';
import 'dart:io' show Platform;
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../services/auth/auth_service.dart';
import '../services/auth/device_id_service.dart';
import '../services/auth/user_service.dart';
import '../services/persona/persona_service.dart';
import '../services/chat/core/chat_service.dart';
import '../services/purchase/purchase_service.dart';
import '../services/relationship/relation_score_service.dart';
import '../services/relationship/relationship_visual_system.dart';
import '../services/ui/haptic_service.dart';
import '../services/block_service.dart';
import '../models/persona.dart';
import '../models/message.dart';
import '../widgets/chat/message_bubble.dart';
import '../widgets/chat/animated_message_bubble.dart';
import '../widgets/chat/typing_indicator.dart';
import '../widgets/persona/persona_profile_viewer.dart';
import '../widgets/common/modern_emotion_picker.dart';
import '../widgets/common/heart_usage_dialog.dart';
import '../theme/app_theme.dart';
import '../l10n/app_localizations.dart';
import '../core/constants.dart';
import '../core/preferences_manager.dart';

/// Optimized ChatScreen with performance improvements:
/// - Uses ListView.builder for efficient message list
/// - Const widgets where possible
/// - Optimized message bubble rendering
/// - Reduced unnecessary rebuilds
/// - Cached profile images
/// - Efficient state management
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with WidgetsBindingObserver {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  String _selectedEmotion = 'neutral';
  double _lastScrollPosition = 0.0; // 마지막 스크롤 위치 추적
  bool _isNearBottom = true;
  int _previousMessageCount = 0;
  int _unreadAIMessageCount = 0;
  bool _previousIsTyping = false;
  // Track welcome messages per persona to prevent repetition
  final Map<String, bool> _hasShownWelcomePerPersona = {};
  // _showMoreMenu 제거됨 - PopupMenuButton으로 대체
  bool _alwaysShowTranslation = false; // 번역 항상 표시 설정
  
  // Reply functionality
  Message? _replyingToMessage;
  final Set<String> _newMessageIds = {}; // Track new messages for animation
  
  // 스크롤 디바운싱 관련 변수
  Timer? _scrollDebounceTimer;
  bool _isScrolling = false; // 현재 스크롤 중인지 추적
  Timer? _scrollStateTimer; // 스크롤 상태 변경 디바운싱용
  Timer? _loadMoreDebounceTimer; // 메시지 로드 디바운싱용

  // Service references for dispose method
  ChatService? _chatService;
  String? _userId;
  Persona? _currentPersona;
  // 🔥 Removed _isInitialized flag - using progressive loading instead
  bool _isInitialLoad = true;  // 초기 로드 추적을 위한 플래그
  bool _hasInitializedOnce = false;  // 한 번이라도 초기화 되었는지 추적
  late final DateTime _initTime = DateTime.now();  // Track initialization time for loading state
  
  // 스크롤 위치 기억용 Map (personaId -> scrollPosition)
  // Removed: Scroll position saving is not needed

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _setupScrollListener();
    _setupKeyboardListener();
    // Load translation preference
    _loadTranslationPreference();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeChat();
    });
  }
  
  Future<void> _loadTranslationPreference() async {
    final alwaysShow = await PreferencesManager.getBool('always_show_translation') ?? false;
    if (mounted) {
      setState(() {
        _alwaysShowTranslation = alwaysShow;
      });
    }
  }

  bool _isLoadingMore = false;
  bool _isKeyboardVisible = false; // 키보드 상태 추적

  void _setupScrollListener() {
    _scrollController.addListener(() {
      // 로딩 중이거나 키보드가 보이는 중이면 리스너 무시
      if (_isLoadingMore || _isKeyboardVisible) {
        return;
      }
      
      // ScrollController가 attached 되어있는지 확인
      if (!_scrollController.hasClients) {
        return;
      }
      
      // 스크롤이 안정화되지 않았으면 무시 (bouncing 방지)
      if (_scrollController.position.isScrollingNotifier.value) {
        // 실제로 사용자가 스크롤 중일 때만 처리
        _isScrolling = true;
      } else {
        _isScrolling = false;
      }
      
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;
      final minScroll = _scrollController.position.minScrollExtent;
      final scrollThreshold = 100.0; // 임계값 감소하여 더 빠른 반응 (200 -> 100)
      final paginationThreshold = 200.0; // 페이지네이션 임계값 줄임 (300 -> 200)

      // 스크롤 위치 추적
      _lastScrollPosition = currentScroll;

      // 사용자가 맨 아래에 가까운지 확인
      final isNearBottom = maxScroll - currentScroll <= scrollThreshold;
      
      // 맨 아래 근처 상태 업데이트 - setState 최소화
      final wasNearBottom = _isNearBottom;
      final hadUnreadMessages = _unreadAIMessageCount > 0;
      
      if (isNearBottom != _isNearBottom) {
        // 맨 아래로 돌아왔을 때는 즉시 업데이트 (버튼 숨기기)
        if (isNearBottom) {
          _isNearBottom = isNearBottom;
          // 읽지 않은 메시지 카운트 초기화
          if (_unreadAIMessageCount > 0) {
            _unreadAIMessageCount = 0;
          }
          // 즉시 setState로 버튼 숨기기
          if (mounted) setState(() {});
        } else {
          // 위로 스크롤할 때는 디바운싱 적용 (버튼 표시 지연)
          _scrollStateTimer?.cancel();
          _scrollStateTimer = Timer(const Duration(milliseconds: 800), () {
            if (mounted && !isNearBottom) {
              setState(() {
                _isNearBottom = false;
              });
            }
          });
        }
      }

      // 상단 근처에서 추가 메시지 로드 (상단 200픽셀 이내)
      // 디바운싱으로 중복 호출 방지
      if (currentScroll <= minScroll + paginationThreshold && 
          !_isLoadingMore) {
        // 이전 타이머 취소하고 새로운 타이머 설정
        _loadMoreDebounceTimer?.cancel();
        _loadMoreDebounceTimer = Timer(const Duration(milliseconds: 300), () {
          // 타이머 실행 시점에 다시 조건 확인
          if (!_isLoadingMore && mounted && _scrollController.hasClients) {
            final current = _scrollController.position.pixels;
            final min = _scrollController.position.minScrollExtent;
            // 여전히 상단 근처에 있을 때만 로드
            if (current <= min + paginationThreshold) {
              debugPrint('📌 Loading more messages at top (debounced)');
              _loadMoreMessages();
            }
          }
        });
      }
    });
  }

  void _setupKeyboardListener() {
    // 키보드 상태 감지를 위한 FocusNode 리스너
    bool wasHasFocus = false;
    _focusNode.addListener(() {
      final hasFocus = _focusNode.hasFocus;
      
      // 포커스 상태 변경 감지
      if (hasFocus != wasHasFocus) {
        if (hasFocus) {
          // 키보드가 나타나기 시작할 때 - 스크롤 리스너 일시 중단
          _isKeyboardVisible = true;
          debugPrint('🎹 Keyboard appearing - disabling scroll listener');
          
          // 키보드 애니메이션이 완료되기를 기다림
          Future.delayed(const Duration(milliseconds: 300), () {
            if (mounted && _scrollController.hasClients && _focusNode.hasFocus) {
              debugPrint('📌 Keyboard activated - scrolling to bottom');
              _scrollToBottom(force: true, smooth: true);
              
              // 스크롤 완료 후 리스너 재활성화
              Future.delayed(const Duration(milliseconds: 200), () {
                if (mounted) {
                  _isKeyboardVisible = false;
                  debugPrint('🎹 Re-enabling scroll listener');
                }
              });
            }
          });
        } else {
          // 키보드가 사라질 때
          _isKeyboardVisible = false;
        }
      }
      wasHasFocus = hasFocus;
    });
  }

  Future<void> _loadMoreMessages() async {
    // 즉시 플래그 설정하여 중복 호출 방지
    if (_isLoadingMore ||
        _isKeyboardVisible ||  // 키보드가 보이는 중이면 로드하지 않음
        _currentPersona == null ||
        _userId == null ||
        _userId!.isEmpty) return;

    _isLoadingMore = true;
    
    // 로드 타이머 취소 (중복 방지)
    _loadMoreDebounceTimer?.cancel();
    
    if (mounted) setState(() {});

    final chatService = Provider.of<ChatService>(context, listen: false);
    final personaService = Provider.of<PersonaService>(context, listen: false);

    if (personaService.currentPersona != null) {
      // Store current scroll position
      final currentScrollPosition = _scrollController.position.pixels;
      final currentMaxScroll = _scrollController.position.maxScrollExtent;

      await chatService.loadMoreMessages(
          _userId!, personaService.currentPersona!.id);

      // After loading, maintain relative scroll position
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          final newMaxScroll = _scrollController.position.maxScrollExtent;
          final scrollDiff = newMaxScroll - currentMaxScroll;

          // Jump to maintain position (add the height of new messages)
          if (scrollDiff > 0) {
            // Calculate the position to maintain visual continuity
            final targetPosition = currentScrollPosition + scrollDiff;
            
            // Single jump to prevent multiple scroll events
            _scrollController.jumpTo(targetPosition);
            
            // Temporarily disable scroll listener to prevent re-triggering
            _isLoadingMore = true;
            Future.delayed(const Duration(milliseconds: 100), () {
              _isLoadingMore = false;
            });
          }
        }
      });
    }

    _isLoadingMore = false;
    if (mounted) setState(() {});
  }

  Future<void> _initializeChat() async {
    if (!mounted) return;
    
    // 🔥 Prevent re-initialization if already done
    if (_hasInitializedOnce && _currentPersona != null) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Persona && args.id == _currentPersona!.id) {
        debugPrint('✅ Already initialized for this persona, skipping re-initialization');
        return;
      }
    }
    
    // 🔥 FIX: Set a flag to prevent welcome message during initialization
    bool isFirstTimeEntering = !_hasInitializedOnce;

    final personaService = Provider.of<PersonaService>(context, listen: false);
    final chatService = Provider.of<ChatService>(context, listen: false);
    final authService = Provider.of<AuthService>(context, listen: false);
    // Store service references for dispose method
    _chatService = chatService;
    _userId = authService.user?.uid ?? '';

    chatService.setPersonaService(personaService);
    chatService.setCurrentUserId(_userId!);

    // Set up callback for incoming AI messages (햅틱 제거)
    chatService.onAIMessageReceived = () {
      // 햅틱 피드백 제거 (사용자 요청)
      
      // 사용자가 맨 아래에 있지 않으면 새 메시지 카운트 증가
      if (!_isNearBottom && mounted) {
        setState(() {
          _unreadAIMessageCount++;
        });
      }
    };

    debugPrint(
        '🔗 ChatService initialized with PersonaService and userId: $_userId');

    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Persona) {
      // 🔥 No setState here - progressive loading instead
      
      await personaService.selectPersona(args);
      _currentPersona = args; // Store current persona for dispose method
      
      // 🔥 Verify the persona was actually selected
      if (personaService.currentPersona?.id != args.id) {
        debugPrint('⚠️ Persona selection mismatch, retrying...');
        await personaService.selectPersona(args);
      }
      
      // 🔥 Only refresh if not already done in navigation
      if (!_hasInitializedOnce) {
        debugPrint('🔄 Initial relationship refresh for persona: ${args.name}');
        await personaService.refreshMatchedPersonasRelationships();
      }
    } // Close if (args is Persona) block

    if (personaService.currentPersona != null) {
      // 🔥 Final verification that we have the correct persona
      if (_currentPersona != null && 
          personaService.currentPersona!.id != _currentPersona!.id) {
        debugPrint('⚠️ Persona mismatch detected, correcting...');
        await personaService.selectPersona(_currentPersona!);
      }
      
      try {
        // Only load chat history if user is authenticated
        if (_userId!.isNotEmpty) {
          // leftChat 상태 체크
          final hasLeft = await personaService.hasLeftChat(personaService.currentPersona!.id);
          if (hasLeft) {
            debugPrint('♻️ User is entering a left chat room, rejoining...');
            // 자동으로 rejoin 처리
            await chatService.rejoinChatRoom(_userId!, personaService.currentPersona!.id);
            await personaService.resetLeftChatStatus(personaService.currentPersona!.id);
          } else {
            // 🔥 Check if this is first time entering after matching
            // If messages are empty and this is the first time, don't load from Firebase
            final existingMessages = chatService.getMessages(personaService.currentPersona!.id);
            final isFirstTimeAfterMatching = existingMessages.isEmpty && isFirstTimeEntering;
            
            // 정상적으로 채팅 히스토리 로드
            await chatService.loadChatHistory(
                _userId!, personaService.currentPersona!.id,
                isFirstTimeAfterMatching: isFirstTimeAfterMatching);
          }

          // 🔵 채팅방 진입 시 모든 페르소나 메시지를 읽음으로 표시
          await chatService.markAllMessagesAsRead(
              _userId!, personaService.currentPersona!.id);

          // Force refresh to ensure UI updates
          await Future.delayed(const Duration(milliseconds: 100));
        } else {
          debugPrint('⚠️ User not authenticated');
          // 로그인하지 않은 사용자는 채팅 불가
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content:
                    Text(AppLocalizations.of(context)!.loginRequiredService),
                backgroundColor: Colors.red,
              ),
            );
            Navigator.of(context).pushReplacementNamed('/auth');
          }
          return;
        }

        // 🔥 FIX: Enhanced synchronization to prevent flicker
        // First, wait for loadChatHistory to complete
        await Future.delayed(const Duration(milliseconds: 100));
        
        if (!mounted) return;
        
        // 🔥 FIX: Wait for loading to complete with proper state check
        int retryCount = 0;
        while (chatService.isLoadingMessages && retryCount < 10) {
          // Removed debug print to avoid showing loading messages
          await Future.delayed(const Duration(milliseconds: 100));
          retryCount++;
          if (!mounted) return;
        }
        
        // 🔥 FIX: Additional safety delay to ensure messages are fully synchronized
        if (retryCount > 0) {
          await Future.delayed(const Duration(milliseconds: 100));
          if (!mounted) return;
        }
        
        // 🔥 REMOVED: Immediate greeting logic that was causing the flash
        // Now only the delayed greeting in _showWelcomeMessage will run
        
        // Get messages for logging only
        final messages =
            chatService.getMessages(personaService.currentPersona!.id);
        debugPrint(
            '🔍 Messages check: ${messages.length} messages found, loading: ${chatService.isLoadingMessages}');
        
        // 🔥 CRITICAL FIX: Prevent any immediate greeting
        // Only schedule welcome message once, with proper checks
        final personaId = personaService.currentPersona!.id;
        
        if (messages.isEmpty && 
            !chatService.isLoadingMessages &&
            _hasShownWelcomePerPersona[personaId] != true &&
            isFirstTimeEntering) {
          // 🔥 IMMEDIATELY mark as shown to prevent duplicate calls
          _hasShownWelcomePerPersona[personaId] = true;
          
          debugPrint('📢 Scheduling ONE welcome message with 1s delay...');
          // Schedule welcome message with delay - this is the ONLY place it should be called
          _showWelcomeMessage();  // This already has 1.5 second delay inside
        } else {
          // Log why we're not showing welcome
          if (messages.isNotEmpty) {
            debugPrint('💬 Messages exist (${messages.length}), no welcome needed');
          } else if (_hasShownWelcomePerPersona[personaId] == true) {
            debugPrint('✅ Welcome already marked as shown for this persona');
          } else if (chatService.isLoadingMessages) {
            debugPrint('⏳ Messages still loading, no welcome yet');
          }
        }
        
        // 초기 로드 시 맨 아래로 스크롤 (메시지가 있을 때만)
        if (_isInitialLoad && messages.isNotEmpty) {
          debugPrint('📌 Initial load with messages - scrolling to bottom');
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && _scrollController.hasClients) {
              _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
              _isInitialLoad = false;  // 초기 로드 완료
            }
          });
        }
      } catch (e) {
        debugPrint('❌ Error loading chat history: $e');
        // Don't show welcome message on error to prevent duplicates
      }
    } else {
      debugPrint('⚠️ No current persona available for chat');
    }
    
    // 🔥 Mark that initialization has been done at least once
    _hasInitializedOnce = true;
  }

  void _showWelcomeMessage() async {
    debugPrint('🎉 _showWelcomeMessage called - waiting 1 second...');

    // 🔥 CRITICAL: Add 1 second delay before showing first greeting
    await Future.delayed(const Duration(seconds: 1));
    
    // Check if still mounted after delay
    if (!mounted) return;

    final personaService = Provider.of<PersonaService>(context, listen: false);
    final chatService = Provider.of<ChatService>(context, listen: false);
    final authService = Provider.of<AuthService>(context, listen: false);
    final persona = personaService.currentPersona;

    if (persona == null) {
      debugPrint('❌ No persona found for welcome message');
      return;
    }

    // Get user ID (either Firebase or device ID)
    final userId = await DeviceIdService.getCurrentUserId(
      firebaseUserId: authService.user?.uid,
    );
    debugPrint('👤 User ID for delayed welcome: $userId');
    debugPrint('🤖 Sending delayed greeting from: ${persona.name}');

    // 🔥 No need to check _hasShownWelcomePerPersona here - already checked before calling
    // 🔥 No need to check messages - we already verified they're empty before calling
    
    // Just send the greeting after delay
    await chatService.sendInitialGreeting(
      userId: userId,
      personaId: persona.id,
      persona: persona,
    );
    
    debugPrint('✅ Delayed welcome message sent successfully');
  }

  void _sendMessage() async {
    final content = _messageController.text.trim();
    if (content.isEmpty) return;

    // 햅틱 피드백 제거 (사용자 요청)

    final chatService = Provider.of<ChatService>(context, listen: false);
    final authService = Provider.of<AuthService>(context, listen: false);
    final userService = Provider.of<UserService>(context, listen: false);
    final purchaseService =
        Provider.of<PurchaseService>(context, listen: false);
    final personaService = Provider.of<PersonaService>(context, listen: false);

    // Check if guest user has exhausted messages
    final isGuest = await userService.isGuestUser;
    if (isGuest && userService.isGuestMessageLimitReached()) {
      // Show login prompt for guest users
      _showGuestLoginPrompt();
      return;
    }

    // Check daily message limit first
    if (!isGuest && userService.isDailyMessageLimitReached()) {
      final shouldUseHeart = await HeartUsageDialog.show(
        context: context,
        title: AppLocalizations.of(context)!.dailyLimitTitle,
        description: AppLocalizations.of(context)!.dailyLimitDescription,
        heartCost: 1,
        onConfirm: () async {
          // Use heart to reset message count
          final success = await purchaseService.useHearts(1);
          if (success) {
            await userService.resetMessageCountWithHeart();
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content:
                      Text(AppLocalizations.of(context)!.messageLimitReset),
                  backgroundColor: Colors.green,
                ),
              );
            }
          } else {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content:
                      Text(AppLocalizations.of(context)!.heartInsufficient),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        },
        icon: Icons.message,
      );

      if (!shouldUseHeart) {
        return;
      }
    }

    _messageController.clear();
    
    // Clear reply state without setState
    final hadReply = _replyingToMessage != null;
    _replyingToMessage = null;
    
    // Single setState for UI update if needed
    if (hadReply && mounted) {
      setState(() {});
    }
    
    // 스크롤은 메시지 추가 후에 한 번만 실행

    final persona = personaService.currentPersona;
    if (persona == null) {
      // No persona selected - silent return
      return;
    }

    final userId = authService.user?.uid;

    if (userId == null || userId.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.loginRequired),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    // 답장 정보를 메타데이터에 포함
    Map<String, dynamic>? metadata;
    if (_replyingToMessage != null) {
      metadata = {
        'replyTo': {
          'id': _replyingToMessage!.id,
          'content': _replyingToMessage!.content,
          'isFromUser': _replyingToMessage!.isFromUser,
          'senderName': _replyingToMessage!.isFromUser 
              ? AppLocalizations.of(context)!.you 
              : persona.name,
        },
      };
    }
    
    final success = await chatService.sendMessage(
      content: content,
      userId: userId,
      persona: persona,
      metadata: metadata,
    );

    if (success) {
      // 답장 상태 초기화와 애니메이션 ID 추가를 한 번에 처리
      final messages = chatService.getMessages(persona.id);
      if (messages.isNotEmpty) {
        setState(() {
          _replyingToMessage = null;
          _newMessageIds.add(messages.last.id);
        });
      } else if (_replyingToMessage != null) {
        setState(() {
          _replyingToMessage = null;
        });
      }
      
      // 사용자가 메시지를 보낸 후 자동 스크롤 (키보드가 활성화되어 있으므로)
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          debugPrint('📌 User sent message - scrolling to bottom');
          _scrollToBottom(force: true, smooth: true);
        }
      });
    } else {
      _messageController.text = content;
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.messageSendFailed),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // 날짜 구분선을 위한 헬퍼 함수들
  String _getDateLabel(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final messageDate = DateTime(date.year, date.month, date.day);
    
    if (messageDate == today) {
      return AppLocalizations.of(context)!.today;
    } else if (messageDate == yesterday) {
      return AppLocalizations.of(context)!.yesterday;
    } else if (messageDate.isAfter(today.subtract(const Duration(days: 7)))) {
      // 이번 주
      final weekdays = AppLocalizations.of(context)!.weekdays.split(',');
      return weekdays[date.weekday - 1];
    } else {
      // 더 오래된 날짜는 월/일 형식으로
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return AppLocalizations.of(context)!.monthDay(months[date.month - 1], date.day);
    }
  }
  
  bool _shouldShowDateSeparator(Message currentMessage, Message? previousMessage) {
    if (previousMessage == null) return true;
    
    final currentDate = DateTime(
      currentMessage.timestamp.year,
      currentMessage.timestamp.month,
      currentMessage.timestamp.day,
    );
    
    final previousDate = DateTime(
      previousMessage.timestamp.year,
      previousMessage.timestamp.month,
      previousMessage.timestamp.day,
    );
    
    return currentDate != previousDate;
  }
  
  Widget _buildDateSeparator(DateTime date) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 1,
              color: Colors.grey.withOpacity(0.2),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              _getDateLabel(date),
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 1,
              color: Colors.grey.withOpacity(0.2),
            ),
          ),
        ],
      ),
    );
  }

  void _scrollToBottom({bool force = false, bool smooth = false}) {
    // 이미 스크롤 중이면 무시 (중복 스크롤 방지)
    if (_isScrolling && !force) {
      debugPrint('📌 Already scrolling - skip duplicate request');
      return;
    }

    // 디바운싱: 이전 타이머 취소
    _scrollDebounceTimer?.cancel();
    
    // 디바운싱: 새로운 스크롤 요청을 적절한 딜레이 후 실행
    _scrollDebounceTimer = Timer(const Duration(milliseconds: 100), () {
      if (!mounted || !_scrollController.hasClients) return;
      
      _isScrolling = true;
      
      // 스크롤 위치 계산
      final targetScroll = _scrollController.position.maxScrollExtent;

      // 플랫폼별 스크롤 처리
      if (Platform.isAndroid || force || !smooth) {
        // Android나 강제 스크롤은 jumpTo 사용
        _scrollController.jumpTo(targetScroll);
        _isScrolling = false;
        _isNearBottom = true;
        debugPrint('📌 Jump scroll to bottom');
      } else if (Platform.isIOS && smooth) {
        // iOS에서 부드러운 애니메이션
        _scrollController.animateTo(
          targetScroll,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutQuart,
        ).then((_) {
          _isScrolling = false;
          _isNearBottom = true;
          debugPrint('📌 Animated scroll completed');
        }).catchError((error) {
          _isScrolling = false;
          _isNearBottom = true;
          if (_scrollController.hasClients) {
            _scrollController.jumpTo(targetScroll);
          }
        });
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Check if persona changed
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Persona && _currentPersonaId != args.id) {
      // Clear previous chat messages immediately
      if (_currentPersonaId != null) {
        final chatService = Provider.of<ChatService>(context, listen: false);
        // This will trigger the immediate clear in ChatService.loadChatHistory
        debugPrint('🔄 Persona changed from $_currentPersonaId to ${args.id}');
      }

      _currentPersonaId = args.id;
      _currentPersona = args; // Update stored persona reference
      // No need to reset welcome flag - it's now tracked per persona
      
      // Reset initial load flag for new persona
      _isInitialLoad = true;

      // Only reload if not the initial load from initState
      if (_hasInitializedOnce) {
        // Reload chat for new persona
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _initializeChat();
        });
      }
      // If it's the first load, initState will handle it
    }
  }

  String? _currentPersonaId;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      // 스크롤 위치 저장
      if (_currentPersona != null && _scrollController.hasClients) {
        // Removed: No need to save scroll position
        debugPrint('📍 Saved scroll position on pause for ${_currentPersona!.name}: ${_scrollController.position.pixels}');
      }
      // Mark messages as read when app goes to background
      _markMessagesAsReadOnExit();
    }
  }

  void _markMessagesAsReadOnExit() {
    // Use stored references instead of Provider to avoid widget lifecycle issues
    if (_chatService != null &&
        _userId != null &&
        _userId!.isNotEmpty &&
        _currentPersona != null) {
      _chatService!.markAllMessagesAsRead(_userId!, _currentPersona!.id);
    }
  }

  @override
  void dispose() {
    // Removed: No need to save scroll position
    
    // Cancel timers
    _scrollDebounceTimer?.cancel();
    _scrollStateTimer?.cancel();
    _loadMoreDebounceTimer?.cancel();
    
    WidgetsBinding.instance.removeObserver(this);
    // Mark all messages as read when leaving chat
    _markMessagesAsReadOnExit();

    // Clean up chat service state without clearing messages
    if (_chatService != null) {
      _chatService!.onAIMessageReceived = null;
      _chatService!.clearCurrentChatState();
    }

    _messageController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    // Android에서도 키보드 이벤트는 FocusNode 리스너에서만 처리하여 충돌 방지
    // 이 메서드에서는 키보드 관련 스크롤을 처리하지 않음
    return;
  }

  @override
  Widget build(BuildContext context) {
    // iOS와 Android 플랫폼별 처리
    final scaffold = Scaffold(
      appBar: _buildAppBar(),
      resizeToAvoidBottomInset: true, // 키보드가 올라올 때 화면 크기 조정
      body: Stack(
          children: [
            Column(
              children: [
                // Chat messages list
                Expanded(
                  child: Stack(
                    children: [
                      Consumer2<ChatService, PersonaService>(
                        builder: (context, chatService, personaService, child) {
                          // 🔥 REMOVED: Don't show loading indicator for first-time chat
                          // Loading indicator causes flicker between matching and first greeting
                          // if (chatService.isLoading && chatService.messages.isEmpty) {
                          //   return const Center(
                          //     child: CircularProgressIndicator(
                          //       color: Color(0xFFFF6B9D),
                          //     ),
                          //   );
                          // }

                          final messages = chatService.messages;
                          final currentPersona = personaService.currentPersona;

                          // 🔥 FIX: For first-time chat entry, show empty chat immediately
                          // No loading indicator needed for new conversations after matching
                          if (messages.isEmpty) {
                            // Don't show any loading or empty state - just empty chat area
                            // The welcome message will appear automatically
                            return const SizedBox.shrink();
                          }

                          if (currentPersona == null) {
                            // Don't show any text, just empty space
                            return const SizedBox.shrink();
                          }

                          // 초기 로드 시 맨 아래로 스크롤
                          if (_isInitialLoad && messages.isNotEmpty) {
                            _isInitialLoad = false;
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (mounted && _scrollController.hasClients) {
                                _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
                                debugPrint('📌 Initial messages loaded - scrolled to bottom');
                              }
                            });
                          }

                          // 메시지 수 변화 감지 및 AI 메시지 추가 시 처리
                          if (messages.length > _previousMessageCount) {
                            final newMessageCount =
                                messages.length - _previousMessageCount;
                            bool hasNewAIMessage = false;
                            bool isLastAIMessage = false;

                            // 새로 추가된 메시지들 중 AI 메시지가 있는지 확인
                            for (int i = messages.length - newMessageCount;
                                i < messages.length;
                                i++) {
                              if (!messages[i].isFromUser) {
                                hasNewAIMessage = true;
                                // 사용자가 위로 스크롤 중이면 읽지 않은 AI 메시지 카운트 증가
                                if (!_isNearBottom) {
                                  _unreadAIMessageCount++;
                                }

                                // 마지막 AI 메시지인지 확인
                                final metadata = messages[i].metadata;
                                if (metadata != null &&
                                    metadata['isLastInSequence'] == true) {
                                  isLastAIMessage = true;
                                }
                              }
                            }

                            _previousMessageCount = messages.length;

                            // AI 메시지가 추가되었을 때 처리
                            if (hasNewAIMessage) {
                              // Mark only the last new message for animation
                              if (newMessageCount > 0 && messages.isNotEmpty) {
                                _newMessageIds.add(messages.last.id);
                              }
                              
                              // 채팅방에 있을 때는 즉시 읽음 처리
                              final authService = Provider.of<AuthService>(
                                  context,
                                  listen: false);
                              final userId = authService.user?.uid ?? '';
                              if (userId.isNotEmpty && mounted) {
                                // Mark messages as read after a short delay to ensure they're saved
                                Future.delayed(
                                    const Duration(milliseconds: 300),
                                    () async {
                                  if (mounted) {
                                    await chatService.markAllMessagesAsRead(
                                        userId, currentPersona.id);
                                  }
                                });
                              }

                              // 키보드가 활성화된 상태에서만 자동 스크롤
                              if (_focusNode.hasFocus && !_isScrolling) {
                                // 키보드가 올라와 있을 때 자동 스크롤
                                Future.delayed(const Duration(milliseconds: 50), () {
                                  if (mounted && _focusNode.hasFocus && !_isScrolling) {
                                    debugPrint('📌 New AI message with keyboard active - auto-scrolling');
                                    _scrollToBottom(force: false, smooth: true);
                                  }
                                });
                              } else {
                                // 키보드가 비활성화 상태면 자동 스크롤 하지 않음
                                debugPrint('📌 New AI message but keyboard inactive - no auto-scroll');
                              }
                            }
                          }

                          // 타이핑 인디케이터 상태 변경 감지
                          final isTyping =
                              chatService.isPersonaTyping(currentPersona.id);
                          // 실제로 false -> true로 변경될 때만 스크롤
                          if (isTyping && !_previousIsTyping) {
                            _previousIsTyping = isTyping;
                            // 키보드가 활성화된 상태에서만 자동 스크롤
                            if (_focusNode.hasFocus && !_isScrolling) {
                              debugPrint('📌 Typing started with keyboard active - auto-scrolling');
                              _scrollToBottom(force: false, smooth: true);
                            } else {
                              debugPrint('📌 Typing started but keyboard inactive - no auto-scroll');
                            }
                          } else if (!isTyping && _previousIsTyping) {
                            // 타이핑이 끝났을 때 상태만 업데이트
                            _previousIsTyping = isTyping;
                          }

                          // Use ListView.builder with optimizations
                          return ListView.builder(
                            key: ValueKey('chat_list_${currentPersona.id}'),
                            controller: _scrollController,
                            physics: Platform.isIOS 
                                ? const BouncingScrollPhysics() // iOS에서 자연스러운 바운스
                                : const ClampingScrollPhysics(), // Android에서 안정적인 클램핑
                            cacheExtent: 200.0, // 캐시 범위 축소로 메모리 최적화
                            addAutomaticKeepAlives: false, // 불필요한 위젯 유지 방지
                            addRepaintBoundaries: true, // 리페인트 최적화
                            padding: EdgeInsets.only(
                              left: 16,
                              right: 16,
                              top: 16,
                              bottom: MediaQuery.of(context).viewInsets.bottom > 0
                                  ? (Platform.isIOS ? 20 : 30) + MediaQuery.of(context).viewInsets.bottom  // iOS는 더 작은 패딩, Android는 조금 더
                                  : Platform.isIOS ? 90 : 100, // 기본 패딩도 플랫폼별 최적화
                            ),
                            keyboardDismissBehavior:
                                ScrollViewKeyboardDismissBehavior
                                    .onDrag, // 스크롤 시 키보드 숨김
                            itemCount: messages.length +
                                (_isLoadingMore
                                    ? 1
                                    : 0) + // Loading indicator at top
                                (chatService.isPersonaTyping(currentPersona.id)
                                    ? 1
                                    : 0), // Typing indicator at bottom
                            itemBuilder: (context, index) {
                              // Loading more indicator at the top
                              if (_isLoadingMore && index == 0) {
                                return const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  child: Center(
                                    child: SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Color(0xFFFF6B9D),
                                      ),
                                    ),
                                  ),
                                );
                              }

                              // Adjust index for messages when loading indicator is shown
                              final messageIndex =
                                  _isLoadingMore ? index - 1 : index;

                              // Typing indicator at the bottom
                              if (messageIndex == messages.length &&
                                  chatService
                                      .isPersonaTyping(currentPersona.id)) {
                                return const Padding(
                                  padding: EdgeInsets.only(top: 8),
                                  child: TypingIndicator(),
                                );
                              }

                              // Regular message with date separator
                              if (messageIndex < messages.length) {
                                final message = messages[messageIndex];
                                final previousMessage = messageIndex > 0 
                                    ? messages[messageIndex - 1] 
                                    : null;
                                final showDateSeparator = _shouldShowDateSeparator(
                                    message, previousMessage);
                                final isNew = _newMessageIds.contains(message.id);
                                
                                // Clear new message flag after animation
                                if (isNew) {
                                  Future.delayed(const Duration(milliseconds: 600), () {
                                    if (mounted) {
                                      setState(() {
                                        _newMessageIds.remove(message.id);
                                      });
                                    }
                                  });
                                }
                                
                                // 날짜 구분선과 메시지를 Column으로 묶어서 반환
                                return Column(
                                  children: [
                                    if (showDateSeparator)
                                      _buildDateSeparator(message.timestamp),
                                    SwipeableMessageBubble(
                                      key: ValueKey(message.id),
                                      message: message,
                                      alwaysShowTranslation: _alwaysShowTranslation,
                                      onScoreChange: () {
                                        // Handle score change if needed
                                      },
                                      onSwipeReply: (msg) {
                                        _replyingToMessage = msg;
                                        if (mounted) setState(() {});
                                        // 키보드 포커스
                                        _focusNode.requestFocus();
                                      },
                                      onReaction: (msg, emoji) {
                                        // 리액션 처리 (향후 구현)
                                        debugPrint('🎉 Reaction: $emoji on message ${msg.id}');
                                      },
                                      isNewMessage: isNew,
                                      index: messageIndex,
                                    ),
                                  ],
                                );
                              }

                              return const SizedBox.shrink();
                            },
                          );
                        },
                      ),
                      // 새 메시지 알림 플로팅 버튼
                      if (!_isNearBottom)
                        Positioned(
                          bottom: 16,
                          right: 16,
                          child: TweenAnimationBuilder<double>(
                            tween: Tween(
                              begin: 0.0,
                              end: 1.0,
                            ),
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOutBack,
                            builder: (context, value, child) {
                              return Transform.scale(
                                scale: value,
                                child: child,
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: _unreadAIMessageCount > 0 
                                    ? const Color(0xFFFF6B9D)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(
                                  _unreadAIMessageCount > 0 ? 20 : 24,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.15),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(
                                    _unreadAIMessageCount > 0 ? 20 : 24,
                                  ),
                                  onTap: () {
                                    HapticService.lightImpact();
                                    _scrollToBottom(force: true);
                                    _unreadAIMessageCount = 0;
                                    if (mounted) setState(() {});
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: _unreadAIMessageCount > 0 ? 16 : 12,
                                      vertical: _unreadAIMessageCount > 0 ? 10 : 12,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        if (_unreadAIMessageCount > 0) ...[
                                          Text(
                                            _unreadAIMessageCount == 1
                                                ? AppLocalizations.of(context)!.newMessage
                                                : AppLocalizations.of(context)!.newMessageCount(_unreadAIMessageCount),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                        ],
                                        Icon(
                                          Icons.keyboard_arrow_down_rounded,
                                          color: _unreadAIMessageCount > 0
                                              ? Colors.white
                                              : const Color(0xFFFF6B9D),
                                          size: 24,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                // Message input with reply UI
                Consumer<PersonaService>(
                  builder: (context, personaService, child) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Reply preview
                        if (_replyingToMessage != null)
                          _ReplyPreview(
                            message: _replyingToMessage!,
                            onCancel: _cancelReply,
                            personaName: personaService.currentPersona?.name ?? '',
                          ),
                        // Message input
                        _MessageInput(
                          controller: _messageController,
                          focusNode: _focusNode,
                          onSend: _sendMessage,
                          onAttachment: _showAttachmentMenu,
                          onEmotion: _showEmotionPicker,
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
            // More menu overlay removed - using PopupMenuButton instead
          ],
        ),
      );

    // iOS는 기본 스와이프 백 제스처 사용, Android는 PopScope로 커스텀 처리
    if (Platform.isIOS) {
      return scaffold;
    } else {
      // Android는 기존 PopScope 로직 유지
      return PopScope(
        canPop: false,
        onPopInvoked: (didPop) async {
          if (didPop) return;

          // 캐시 업데이트 (현재 like score를 캐시에 반영)
          final authService = Provider.of<AuthService>(context, listen: false);
          final userId = authService.user?.uid;
          if (userId != null && _currentPersona != null) {
            // 현재 persona의 최신 likes를 캐시에 업데이트
            RelationScoreService.instance.getLikes(
              userId: userId,
              personaId: _currentPersona!.id,
            );
          }

          // Navigate to chat list instead of popping
          Navigator.pushReplacementNamed(
            context,
            '/main',
            arguments: {'initialIndex': 1}, // 채팅 목록 탭
          );
        },
        child: scaffold,
      );
    }
  }

  Future<void> _handleReportAI() async {
    final chatService = Provider.of<ChatService>(context, listen: false);
    final authService = Provider.of<AuthService>(context, listen: false);
    final personaService = Provider.of<PersonaService>(context, listen: false);
    
    final userId = authService.user?.uid ?? await DeviceIdService.getDeviceId();
    final currentPersona = personaService.currentPersona;
    
    if (userId.isEmpty || currentPersona == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.selectPersonaPlease),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    
    // Import BlockService
    final BlockService blockService = BlockService();
    
    // 신고 사유 목록
    final localizations = AppLocalizations.of(context)!;
    final reasons = [
      localizations.inappropriateContent,
      localizations.spamAdvertising,
      localizations.hateSpeech,
      localizations.sexualContent,
      localizations.violentContent,
      localizations.harassmentBullying,
      localizations.personalInfoExposure,
      localizations.copyrightInfringement,
      localizations.other,
    ];
    
    String? selectedReason;
    String customReason = '';
    bool shouldBlock = true; // 기본적으로 차단 체크
    
    // 다이얼로그 표시
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Row(
                children: [
                  Icon(Icons.warning_amber_outlined, color: Colors.orange[600], size: 24),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(localizations.reportAndBlock),
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localizations.reportAndBlockDescription,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      localizations.selectReportReason,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    ...reasons.map((reason) => RadioListTile<String>(
                      dense: true,
                      title: Text(reason, style: const TextStyle(fontSize: 14)),
                      value: reason,
                      groupValue: selectedReason,
                      onChanged: (value) {
                        setState(() {
                          selectedReason = value;
                        });
                      },
                    )),
                    if (selectedReason == localizations.other) ...[
                      const SizedBox(height: 8),
                      TextField(
                        decoration: InputDecoration(
                          labelText: localizations.detailedReason,
                          hintText: localizations.explainReportReason,
                          border: const OutlineInputBorder(),
                        ),
                        maxLines: 3,
                        onChanged: (value) {
                          customReason = value;
                        },
                      ),
                    ],
                    const SizedBox(height: 16),
                    CheckboxListTile(
                      dense: true,
                      title: Text(
                        localizations.alsoBlockThisAI,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      subtitle: Text(
                        localizations.blockConfirm.split('\n')[1], // "차단된 AI는 매칭과 채팅 목록에서 제외됩니다."
                        style: const TextStyle(fontSize: 12),
                      ),
                      value: shouldBlock,
                      onChanged: (value) {
                        setState(() {
                          shouldBlock = value ?? true;
                        });
                      },
                      activeColor: Colors.red,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(null),
                  child: Text(localizations.cancel),
                ),
                ElevatedButton(
                  onPressed: selectedReason == null
                      ? null
                      : () => Navigator.of(dialogContext).pop({
                            'reason': selectedReason,
                            'customReason': customReason,
                            'shouldBlock': shouldBlock,
                          }),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange[600],
                  ),
                  child: Text(localizations.send),
                ),
              ],
            );
          },
        );
      },
    );
    
    // 사용자가 신고를 제출한 경우
    if (result != null) {
      // Store context before async operation
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      final navigator = Navigator.of(context);
      
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) => const Center(
          child: CircularProgressIndicator(
            color: Color(0xFFFF6B9D),
          ),
        ),
      );
      
      bool reportSuccess = false;
      bool blockSuccess = false;
      String? errorMessage;
      
      try {
        // 1. 신고 제출
        await chatService.sendChatErrorReport(
          userId: userId,
          personaId: currentPersona.id,
          userMessage: result['customReason'].isNotEmpty 
              ? result['customReason'] 
              : result['reason'],
        );
        reportSuccess = true;
        
        // 2. AI 차단 (선택한 경우)
        if (result['shouldBlock'] == true) {
          blockSuccess = await blockService.blockPersona(
            userId: userId,
            personaId: currentPersona.id,
            personaName: currentPersona.name,
            reason: result['reason'],
          );
          
          // 차단 성공 시 PersonaService에서도 즉시 제거
          if (blockSuccess) {
            personaService.removeFromMatched(currentPersona.id);
          }
        }
      } catch (e) {
        debugPrint('🔥 Error in report/block: $e');
        errorMessage = e.toString();
      }
      
      // Close loading dialog
      navigator.pop();
      
      // Show result message
      if (reportSuccess) {
        String message = localizations.reportSubmittedSuccess;
        if (result['shouldBlock'] == true && blockSuccess) {
          message += '\n${localizations.blockedSuccessfully}';
          
          // 차단 성공 시 채팅 화면 닫기
          if (mounted) {
            Navigator.of(context).pop();
          }
        }
        
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );
      } else {
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text(localizations.reportFailed),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _handleErrorReport() async {
    final chatService = Provider.of<ChatService>(context, listen: false);
    final authService = Provider.of<AuthService>(context, listen: false);
    final personaService = Provider.of<PersonaService>(context, listen: false);

    debugPrint('🔍 Chat Error Report - Start');
    final userId = authService.user?.uid ?? await DeviceIdService.getDeviceId();
    final currentPersona = personaService.currentPersona;

    debugPrint('🔍 userId: $userId');
    debugPrint(
        '🔍 currentPersona: ${currentPersona?.id} - ${currentPersona?.name}');

    if (userId.isNotEmpty && currentPersona != null) {
      // Get last 10 messages instead of 3
      final messages = chatService.getMessages(currentPersona.id);
      final recentMessages = messages.length > 10
          ? messages.sublist(messages.length - 10)
          : messages;
      
      // Directly send error report without dialog
      // 다이얼로그 없이 바로 전송
      String? errorDescription = 'User reported chat error';
      String? problemMessage = null;
      
      // Skip dialog and directly send report
      /*
      final result = await showDialog<Map<String, String>>(
        context: context,
        builder: (context) {
          String selectedMessage = '';
          String description = '';
          
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: Text(AppLocalizations.of(context)!.reportChatError),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 설명 추가
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.blue.withOpacity(0.3)),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.info_outline, color: Colors.blue[700], size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                AppLocalizations.of(context)!.chatErrorAnalysisInfo,
                                style: TextStyle(
                                  color: Colors.blue[700],
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        AppLocalizations.of(context)!.selectProblematicMessage,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: recentMessages.map((msg) {
                            final isSelected = selectedMessage == msg.content;
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  selectedMessage = msg.content;
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: isSelected 
                                    ? Theme.of(context).primaryColor.withOpacity(0.2)
                                    : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: isSelected 
                                      ? Theme.of(context).primaryColor
                                      : Colors.grey.withOpacity(0.3),
                                  ),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      msg.isFromUser ? Icons.person : Icons.smart_toy,
                                      size: 16,
                                      color: msg.isFromUser ? Colors.blue : Colors.purple,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        msg.content.length > 100 
                                          ? '${msg.content.substring(0, 100)}...'
                                          : msg.content,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Theme.of(context).textTheme.bodyLarge?.color,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        AppLocalizations.of(context)!.whatWasAwkward,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)!.errorExampleHint,
                          border: const OutlineInputBorder(),
                        ),
                        maxLines: 3,
                        onChanged: (value) {
                          description = value;
                        },
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, null),
                    child: Text(AppLocalizations.of(context)!.cancel),
                  ),
                  ElevatedButton(
                    onPressed: description.isNotEmpty ? () {
                      Navigator.pop(context, {
                        'message': selectedMessage,
                        'description': description,
                      });
                    } : null,
                    child: Text(AppLocalizations.of(context)!.sendReport),
                  ),
                ],
              );
            },
          );
        },
      );
      
      if (result != null) {
        errorDescription = result['description'];
        problemMessage = result['message'];
      }
      */
        
        debugPrint('🔍 Sending error report directly with 10 messages');
        debugPrint('🔍 Messages count: ${recentMessages.length}');

        // Store context before async operation
        final scaffoldMessenger = ScaffoldMessenger.of(context);
        final navigator = Navigator.of(context);

        // Show loading dialog
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (dialogContext) => const Center(
            child: CircularProgressIndicator(
              color: Color(0xFFFF6B9D),
            ),
          ),
        );

        bool success = false;
        String? errorMessage;

        try {
          // Combine problem message and description for userMessage
          final fullErrorDescription = problemMessage != null && problemMessage.isNotEmpty
              ? '${AppLocalizations.of(context)!.problemMessage}: "$problemMessage"\n\n${AppLocalizations.of(context)!.errorDescription}: $errorDescription'
              : '${AppLocalizations.of(context)!.errorDescription}: $errorDescription';
          
          await chatService.sendChatErrorReport(
            userId: userId,
            personaId: currentPersona.id,
            userMessage: fullErrorDescription,
          );
          success = true;
        } catch (e) {
          debugPrint('🔥 Error sending chat error report: $e');
          errorMessage = e.toString().contains('permission')
              ? AppLocalizations.of(context)!.permissionDeniedTryLater
              : AppLocalizations.of(context)!.networkErrorOccurred;
        }

        // Close loading dialog
        navigator.pop();

        // Show result message
        if (success) {
          scaffoldMessenger.showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.chatErrorSentSuccessfully),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          scaffoldMessenger.showSnackBar(
            SnackBar(
              content: Text('${AppLocalizations.of(context)!.errorSendingFailed}: $errorMessage'),
              backgroundColor: Colors.red,
            ),
          );
        }
      // Closing brace for the main if condition
    } else {
      debugPrint(
          '🔍 Conditions not met - userId: $userId, currentPersona: $currentPersona');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.selectPersonaPlease),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  Future<void> _handleLeaveChat() async {
    // Show confirmation dialog
    final shouldLeave = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.leaveChatTitle),
        content: Text(AppLocalizations.of(context)!.leaveChatConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              AppLocalizations.of(context)!.leave,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (shouldLeave == true && mounted) {
      // Leave chat room
      final chatService = Provider.of<ChatService>(context, listen: false);
      final authService = Provider.of<AuthService>(context, listen: false);
      final personaService =
          Provider.of<PersonaService>(context, listen: false);

      final userId =
          authService.user?.uid ?? await DeviceIdService.getDeviceId();
      final currentPersona = personaService.currentPersona;

      if (userId.isNotEmpty && currentPersona != null) {
        // 채팅방 나가기 상태를 Firebase/로컬에 저장
        await chatService.leaveChatRoom(userId, currentPersona.id);
        
        // Navigate back to main navigation
        if (mounted) {
          Navigator.pushReplacementNamed(
            context,
            '/main',
            arguments: {'initialIndex': 1}, // 채팅 목록 탭
          );
        }
      }
    }
  }

  Future<void> _handleRestartChat() async {
    final personaService = Provider.of<PersonaService>(context, listen: false);
    final purchaseService = Provider.of<PurchaseService>(context, listen: false);
    final relationScoreService = Provider.of<RelationScoreService>(context, listen: false);
    final authService = Provider.of<AuthService>(context, listen: false);
    
    final currentPersona = personaService.currentPersona;
    if (currentPersona == null) return;
    
    // 현재 하트 개수 확인
    final currentHearts = purchaseService.hearts;
    
    // 확인 다이얼로그 표시
    final shouldRestart = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.restartConversation),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppLocalizations.of(context)!.restartConversationQuestion(currentPersona.name)),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.favorite, color: Colors.red[400], size: 20),
                const SizedBox(width: 8),
                Text(
                  AppLocalizations.of(context)!.heartRequired,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: currentHearts >= 1 ? null : Colors.red[400],
                  ),
                ),
              ],
            ),
            if (currentHearts < 1)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  AppLocalizations.of(context)!.notEnoughHeartsCount(currentHearts),
                  style: TextStyle(
                    color: Colors.red[400],
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: currentHearts >= 1 
              ? () => Navigator.of(context).pop(true)
              : null,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.favorite, size: 16, color: currentHearts >= 1 ? Colors.red[400] : Colors.grey),
                const SizedBox(width: 4),
                Text(
                  AppLocalizations.of(context)!.useOneHeart,
                  style: TextStyle(
                    color: currentHearts >= 1 ? Colors.red[400] : Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    
    if (shouldRestart == true && currentHearts >= 1) {
      try {
        // 로딩 다이얼로그 표시
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
        );
        
        // 1. 하트 1개 사용
        final heartUsed = await purchaseService.useHearts(1);
        
        if (heartUsed) {
          // 2. likes를 50으로 리셋
          final userId = authService.user?.uid ?? await DeviceIdService.getDeviceId();
          
          await relationScoreService.updateLikes(
            userId: userId,
            personaId: currentPersona.id,
            likeChange: 50 - currentPersona.likes, // 현재 likes에서 50으로 만들기 위한 변화량
            currentLikes: currentPersona.likes,
          );
          
          // 3. PersonaService에서 persona 정보 갱신
          await personaService.refreshCurrentPersona();
          
          // 로딩 다이얼로그 닫기
          Navigator.of(context).pop();
          
          // 성공 메시지 표시
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.restartConversationWithName(currentPersona.name)),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
        } else {
          // 로딩 다이얼로그 닫기
          Navigator.of(context).pop();
          
          // 실패 메시지
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.heartUsageFailed),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        // 로딩 다이얼로그 닫기
        Navigator.of(context).pop();
        
        debugPrint('Error restarting chat: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.errorOccurredTryAgain),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _handleTranslationError() async {
    final chatService = Provider.of<ChatService>(context, listen: false);
    final authService = Provider.of<AuthService>(context, listen: false);
    final personaService = Provider.of<PersonaService>(context, listen: false);
    final userService = Provider.of<UserService>(context, listen: false);

    final userId = authService.user?.uid ?? await DeviceIdService.getDeviceId();
    final currentPersona = personaService.currentPersona;
    final currentUser = userService.currentUser;

    if (userId.isNotEmpty && currentPersona != null) {
      // Get recent messages with translations (실제 번역 내용이 있는 메시지만)
      final messages = chatService.getMessages(currentPersona.id);
      final translatedMessages = messages
          .where((msg) => 
              !msg.isFromUser && 
              msg.translatedContent != null && 
              msg.translatedContent!.isNotEmpty)
          .toList();

      if (translatedMessages.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.noTranslatedMessages),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      // Show dialog to select which message has translation error
      Message? selectedMessage;
      String userDescription = '';
      
      final result = await showDialog<Map<String, dynamic>>(
        context: context,
        builder: (dialogContext) {
          final descriptionController = TextEditingController();
          return AlertDialog(
            title: Row(
              children: [
                const Icon(Icons.translate, color: Color(0xFFFF6B9D)),
                const SizedBox(width: 8),
                Text(AppLocalizations.of(context)!.translationError),
              ],
            ),
            content: SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 설명 추가
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, size: 16, color: Colors.blue[700]),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            AppLocalizations.of(context)!.translationErrorAnalysisInfo,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.blue[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    AppLocalizations.of(context)!.selectTranslationError,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 12),
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: translatedMessages.length
                          .clamp(0, 5), // Show max 5 recent translated messages
                      itemBuilder: (context, index) {
                        final msg = translatedMessages[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: InkWell(
                            onTap: () {
                              selectedMessage = msg;
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${currentPersona.name}: ${msg.content}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(Icons.translate,
                                          size: 14, color: Colors.grey[600]),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          msg.translatedContent ?? '',
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey[700]),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  // 사용자 설명 입력 필드
                  Text(
                    AppLocalizations.of(context)!.whatWasWrongWithTranslation,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: descriptionController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!.translationErrorHint,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.all(12),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: Text(AppLocalizations.of(context)!.cancel),
              ),
              ElevatedButton(
                onPressed: () {
                  if (selectedMessage != null) {
                    Navigator.of(dialogContext).pop({
                      'message': selectedMessage,
                      'description': descriptionController.text,
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(AppLocalizations.of(context)!.pleaseSelectMessage),
                        backgroundColor: Colors.orange,
                      ),
                    );
                  }
                },
                child: Text(AppLocalizations.of(context)!.reportErrorButton),
              ),
            ],
          );
        },
      );

      if (result != null && result['message'] != null) {
        selectedMessage = result['message'] as Message;
        userDescription = result['description'] as String? ?? '';
      }

      if (selectedMessage != null) {
        // Show loading
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (dialogContext) => const Center(
            child: CircularProgressIndicator(color: Color(0xFFFF6B9D)),
          ),
        );

        try {
          // Save translation error report
          final errorData = {
            'userId': userId,
            'personaId': currentPersona.id,
            'personaName': currentPersona.name,
            'messageId': selectedMessage?.id ?? '',
            'originalContent': selectedMessage?.content ?? '',
            'translatedContent': selectedMessage?.translatedContent ?? '',
            'targetLanguage': selectedMessage?.targetLanguage ?? '',
            'userLanguage': currentUser?.preferredLanguage ?? 'ko',
            'userDescription': userDescription, // 사용자가 입력한 설명 추가
            'timestamp': DateTime.now().toIso8601String(),
            'errorType': 'translation',
          };

          final success = await chatService.reportChatError(
            userId,
            currentPersona.id,
            {'translation_error': errorData},
          );

          // Close loading dialog
          if (mounted) Navigator.of(context).pop();

          if (success && mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    AppLocalizations.of(context)!.translationErrorReported),
                backgroundColor: Colors.green,
              ),
            );
          } else if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(AppLocalizations.of(context)!.reportFailed),
                backgroundColor: Colors.red,
              ),
            );
          }
        } catch (e) {
          // Close loading dialog
          if (mounted) Navigator.of(context).pop();

          debugPrint('❌ Translation error report failed: $e');
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(AppLocalizations.of(context)!.reportFailed),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      }
    }
  }

  void _showGuestLoginPrompt() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(
                Icons.message_outlined,
                color: Theme.of(context).colorScheme.primary,
                size: 28,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  AppLocalizations.of(context)!.guestMessageExhausted,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.guestLoginPromptMessage,
                style: const TextStyle(
                  fontSize: 15,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.favorite,
                      color: Theme.of(context).colorScheme.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        AppLocalizations.of(context)!.memberBenefits,
                        style: TextStyle(
                          fontSize: 13,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text(
                AppLocalizations.of(context)!.later,
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            FilledButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                
                // Navigate to login screen or show login options
                final authService = Provider.of<AuthService>(context, listen: false);
                
                // Show login options dialog
                final result = await showDialog<String>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      title: Text(
                        AppLocalizations.of(context)!.loginTitle,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Google Sign In
                          _buildSocialLoginButton(
                            icon: Icons.g_mobiledata,
                            label: AppLocalizations.of(context)!.continueWithGoogle,
                            onPressed: () {
                              Navigator.of(context).pop('google');
                            },
                            backgroundColor: Colors.white,
                            iconColor: Colors.red,
                          ),
                          const SizedBox(height: 12),
                          // Apple Sign In (iOS only)
                          if (Platform.isIOS)
                            _buildSocialLoginButton(
                              icon: Icons.apple,
                              label: AppLocalizations.of(context)!.continueWithApple,
                              onPressed: () {
                                Navigator.of(context).pop('apple');
                              },
                              backgroundColor: Colors.black,
                              iconColor: Colors.white,
                              isDark: true,
                            ),
                        ],
                      ),
                    );
                  },
                );
                
                if (result != null) {
                  bool success = false;
                  if (result == 'google') {
                    success = await authService.signInWithGoogle();
                  } else if (result == 'apple') {
                    success = await authService.signInWithApple();
                  }
                  
                  if (success && mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(AppLocalizations.of(context)!.loginComplete),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                }
              },
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(AppLocalizations.of(context)!.login),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSocialLoginButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required Color backgroundColor,
    required Color iconColor,
    bool isDark = false,
  }) {
    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(12),
      elevation: 2,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 24,
                color: iconColor,
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0.5,
      leading: Center(
        child: ModernIconButton(
          icon: Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back_ios_rounded,
          onPressed: () async {
            // Mark all messages as read before leaving
            final chatService =
                Provider.of<ChatService>(context, listen: false);
            final authService =
                Provider.of<AuthService>(context, listen: false);
            final personaService =
                Provider.of<PersonaService>(context, listen: false);

            final userId = authService.user?.uid ?? '';
            final currentPersona = personaService.currentPersona;

            debugPrint(
                '🔙 Back button pressed - userId: $userId, persona: ${currentPersona?.name}');

            if (userId.isNotEmpty && currentPersona != null) {
              // First, get current messages
              final messagesBefore = chatService.getMessages(currentPersona.id);
              final unreadBefore = messagesBefore
                  .where((m) =>
                      !m.isFromUser && (m.isRead == false || m.isRead == null))
                  .length;
              debugPrint('📊 Before marking - Unread count: $unreadBefore');

              // Wait for messages to be marked as read
              await chatService.markAllMessagesAsRead(
                  userId, currentPersona.id);

              // 메시지 상태 확인
              final messagesAfter = chatService.getMessages(currentPersona.id);
              final unreadAfter = messagesAfter
                  .where((m) =>
                      !m.isFromUser && (m.isRead == false || m.isRead == null))
                  .length;
              debugPrint(
                  '📊 After marking as read - Unread count: $unreadAfter');
              
              // Wait to ensure update is complete
              await Future.delayed(const Duration(milliseconds: 400));
            }

            // iOS는 일반 pop, Android는 pushReplacement 사용
            if (mounted) {
              if (Platform.isIOS) {
                Navigator.of(context).pop();
              } else {
                Navigator.pushReplacementNamed(
                  context,
                  '/main',
                  arguments: {'initialIndex': 1}, // 채팅 목록 탭
                );
              }
            }
          },
          tooltip: AppLocalizations.of(context)!.backButton,
        ),
      ),
      title: const _AppBarTitle(),
      actions: [
        Center(
          child: Padding(
            padding: const EdgeInsets.only(right: 8),
            child: PopupMenuButton<String>(
              icon: Icon(
                Icons.more_horiz_rounded,
                color: Theme.of(context).iconTheme.color,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 8,
              offset: const Offset(0, 8),
              onSelected: (value) async {
                if (value == 'report_ai') {
                  await _handleReportAI();
                } else if (value == 'error_report') {
                  await _handleErrorReport();
                } else if (value == 'translation_error') {
                  await _handleTranslationError();
                } else if (value == 'restart_chat') {
                  await _handleRestartChat();
                } else if (value == 'leave_chat') {
                  await _handleLeaveChat();
                } else if (value == 'translation_toggle') {
                  setState(() {
                    _alwaysShowTranslation = !_alwaysShowTranslation;
                  });
                  // Save preference
                  await PreferencesManager.setBool('always_show_translation', _alwaysShowTranslation);
                }
              },
              itemBuilder: (BuildContext context) {
                final personaService = Provider.of<PersonaService>(context, listen: false);
                final currentPersona = personaService.currentPersona;
                final isOffline = currentPersona != null && currentPersona.likes <= 0;
                
                return [
                  // 신고 및 차단 메뉴 (최상단) - 통합된 메뉴
                  PopupMenuItem<String>(
                    value: 'report_ai',
                    child: Row(
                      children: [
                        Icon(
                          Icons.block,
                          color: Colors.orange[600],
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          AppLocalizations.of(context)!.reportAndBlock,
                          style: TextStyle(
                            color: Colors.orange[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const PopupMenuDivider(),
                  PopupMenuItem<String>(
                    value: 'error_report',
                    child: Row(
                      children: [
                        Icon(
                          Icons.bug_report_outlined,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          AppLocalizations.of(context)!.sendChatError,
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'translation_error',
                    child: Row(
                      children: [
                        Icon(
                          Icons.translate,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          AppLocalizations.of(context)!.translationError,
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const PopupMenuDivider(),
                  // 번역 항상 표시 토글
                  PopupMenuItem<String>(
                    value: 'translation_toggle',
                    child: Row(
                      children: [
                        Icon(
                          _alwaysShowTranslation ? Icons.translate : Icons.translate_outlined,
                          color: _alwaysShowTranslation ? Colors.blue : Theme.of(context).textTheme.bodyLarge?.color,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          _alwaysShowTranslation 
                              ? AppLocalizations.of(context)!.alwaysShowTranslationOff
                              : AppLocalizations.of(context)!.alwaysShowTranslationOn,
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const PopupMenuDivider(),
                  // 오프라인 상태일 때만 '다시 대화하기' 표시
                  if (isOffline)
                    PopupMenuItem<String>(
                      value: 'restart_chat',
                      child: Row(
                        children: [
                          Icon(
                            Icons.refresh,
                            color: Colors.green[400],
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            AppLocalizations.of(context)!.restartConversation,
                            style: TextStyle(
                              color: Colors.green[400],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  PopupMenuItem<String>(
                    value: 'leave_chat',
                    child: Row(
                      children: [
                        Icon(
                          Icons.exit_to_app,
                          color: Colors.red[400],
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          AppLocalizations.of(context)!.leaveChatRoom,
                          style: TextStyle(
                            color: Colors.red[400],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ];
              },
            ),
          ),
        ),
      ],
    );
  }

  void _showAttachmentMenu() {
    // Show attachment menu implementation
  }

  void _showEmotionPicker() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.3),
      builder: (context) => ModernEmotionPicker(
        selectedEmotion: _selectedEmotion,
        onEmotionSelected: (emotion) {
          setState(() {
            _selectedEmotion = emotion;
          });
        },
      ),
    );
  }
  
  void _handleSwipeReply(Message message) {
    setState(() {
      _replyingToMessage = message;
    });
    
    // Focus the input field
    _focusNode.requestFocus();
    
    // Light haptic feedback
    HapticService.lightImpact();
  }
  
  void _cancelReply() {
    setState(() {
      _replyingToMessage = null;
    });
  }
  
  void _handleReaction(Message message, String emoji) {
    // Update the message with the new reaction
    final chatService = Provider.of<ChatService>(context, listen: false);
    final currentReactions = Map<String, int>.from(message.reactions ?? {});
    
    // Toggle or add reaction
    if (currentReactions.containsKey(emoji)) {
      currentReactions[emoji] = currentReactions[emoji]! + 1;
    } else {
      currentReactions[emoji] = 1;
    }
    
    // Update the message in the chat service
    // Note: In a real app, this would sync with Firebase
    setState(() {
      // Update local state for immediate feedback
      final updatedMessage = message.copyWith(reactions: currentReactions);
      // You would update this in your chat service
    });
    
    // Haptic feedback
    HapticService.success();
  }
}

// Separate widgets for better performance

class _AppBarTitle extends StatelessWidget {
  const _AppBarTitle();

  @override
  Widget build(BuildContext context) {
    return Consumer3<PersonaService, AuthService, UserService>(
      builder: (context, personaService, authService, userService, child) {
        final persona = personaService.currentPersona;

        if (persona == null) {
          return Text(AppLocalizations.of(context)!.selectPersona);
        }

        // Check if user is a guest
        final isGuestFuture = userService.isGuestUser;
        
        return FutureBuilder<bool>(
          future: isGuestFuture,
          builder: (context, snapshot) {
            final isGuest = snapshot.data ?? false;
            final remainingMessages = isGuest 
                ? userService.getGuestRemainingMessages()
                : userService.getRemainingMessages();
            
            return Row(
              children: [
                Flexible(
                  flex: 1,
                  child: _PersonaTitle(persona: persona),
                ),
                // Show guest indicator
                if (isGuest) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.guestModeTitle.split(' ')[0], // "게스트"
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.blue[700],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                ],
                // Show message limit indicator (for both guests and regular users when limits are low)
                if ((isGuest && remainingMessages <= AppConstants.guestWarningThreshold) ||
                    (!isGuest && remainingMessages <= 10))
                  _MessageLimitIndicator(
                    remainingMessages: remainingMessages,
                    isGuest: isGuest,
                  ),
              ],
            );
          },
        );
      },
    );
  }
}

class _PersonaTitle extends StatelessWidget {
  final Persona persona;

  const _PersonaTitle({required this.persona});

  @override
  Widget build(BuildContext context) {
    // Listen to PersonaService for real-time updates
    return Consumer<PersonaService>(
      builder: (context, personaService, child) {
        // Get the updated persona with latest relationship score
        final updatedPersona = personaService.currentPersona ?? persona;

        // 🔧 FIX: Use existing likes directly without FutureBuilder
        final likes = updatedPersona.likes ?? 0;

        return Row(
          children: [
            GestureDetector(
              onTap: () => _showPersonaProfile(context, updatedPersona),
              child: Builder(
                builder: (context) {
                  final thumbnailUrl = updatedPersona.getThumbnailUrl();

                  // 링 시스템으로 감싼 프로필 이미지
                  return RelationshipRingSystem.buildRing(
                    likes: likes,
                    size: 44,
                    child: _ProfileImage(
                      photoUrl: thumbnailUrl,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!
                        .conversationWith(updatedPersona.name),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  _OnlineStatus(persona: updatedPersona),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void _showPersonaProfile(BuildContext context, Persona persona) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        pageBuilder: (context, animation, secondaryAnimation) {
          return PersonaProfileViewer(
            persona: persona,
            onClose: () {},
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }
}

class _ProfileImage extends StatelessWidget {
  final String? photoUrl;

  const _ProfileImage({this.photoUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: ClipOval(
        child: photoUrl != null && photoUrl!.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: photoUrl!,
                fit: BoxFit.cover,
                memCacheWidth: 88,
                memCacheHeight: 88,
                placeholder: (context, url) => Container(
                  color: Colors.grey[200],
                  child: const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Color(0xFFFF6B9D),
                    ),
                  ),
                ),
                errorWidget: (context, url, error) {
                  debugPrint('❌ Image load error: $error for URL: $url');
                  return _buildDefaultAvatar();
                },
              )
            : _buildDefaultAvatar(),
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      color: Colors.grey[200],
      child: const Icon(
        Icons.person,
        color: Color(0xFFFF6B9D),
        size: 24,
      ),
    );
  }
}

class _OnlineStatus extends StatelessWidget {
  final Persona persona;

  const _OnlineStatus({required this.persona});

  @override
  Widget build(BuildContext context) {
    // 🔧 FIX: Use existing likes directly without FutureBuilder
    final likes = persona.likes ?? 0;
    final visualInfo = RelationScoreService.instance.getVisualInfo(likes);

    return Row(
      children: [
        // 온라인 표시 (like score가 0 이하면 회색)
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: likes <= 0 ? Colors.grey[400] : Colors.green[500],
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: likes <= 0
                    ? Colors.grey.withOpacity(0.4)
                    : Colors.green.withOpacity(0.4),
                blurRadius: 4,
                spreadRadius: 1,
              ),
            ],
          ),
        ),
        const SizedBox(width: 6),
        // Online 텍스트 (like score가 0 이하면 Offline)
        Text(
          likes <= 0 ? 'Offline' : 'Online',
          style: TextStyle(
            fontSize: 12,
            color: likes <= 0 ? Colors.grey : Colors.green,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 8),
        // 하트 아이콘
        SizedBox(
          width: 14,
          height: 14,
          child: visualInfo.heart,
        ),
        const SizedBox(width: 4),
        // Like 수 (포맷팅됨)
        Text(
          visualInfo.formattedLikes,
          style: TextStyle(
            fontSize: 12,
            color: visualInfo.color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _MessageLimitIndicator extends StatelessWidget {
  final int remainingMessages;
  final bool isGuest;

  const _MessageLimitIndicator({
    required this.remainingMessages,
    this.isGuest = false,
  });

  @override
  Widget build(BuildContext context) {
    // Determine color based on remaining messages (different thresholds for guests)
    Color indicatorColor;
    if (isGuest) {
      // Guest thresholds
      if (remainingMessages <= 2) {
        indicatorColor = Colors.red;
      } else if (remainingMessages <= AppConstants.guestWarningThreshold) {
        indicatorColor = Colors.orange;
      } else {
        indicatorColor = Colors.blue;
      }
    } else {
      // Regular user thresholds
      if (remainingMessages <= 2) {
        indicatorColor = Colors.red;
      } else if (remainingMessages <= 5) {
        indicatorColor = Colors.orange;
      } else {
        indicatorColor = Colors.green;
      }
    }

    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: indicatorColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: indicatorColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Battery-like icon showing fill level
          Container(
            width: 20,
            height: 12,
            decoration: BoxDecoration(
              border: Border.all(color: indicatorColor, width: 1.5),
              borderRadius: BorderRadius.circular(2),
            ),
            child: Stack(
              children: [
                // Battery fill
                FractionallySizedBox(
                  widthFactor: isGuest 
                      ? (remainingMessages / AppConstants.guestDailyMessageLimit).clamp(0.0, 1.0)
                      : (remainingMessages / 10).clamp(0.0, 1.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: indicatorColor,
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Battery tip
          Container(
            width: 2,
            height: 6,
            margin: const EdgeInsets.only(left: 1),
            decoration: BoxDecoration(
              color: indicatorColor,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(1),
                bottomRight: Radius.circular(1),
              ),
            ),
          ),
          const SizedBox(width: 6),
          // Remaining count
          Text(
            remainingMessages.toString(),
            style: TextStyle(
              color: indicatorColor,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 80,
            color:
                Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.noConversationYet,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.sendFirstMessage,
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReplyPreview extends StatelessWidget {
  final Message message;
  final VoidCallback onCancel;
  final String personaName;
  
  const _ReplyPreview({
    required this.message,
    required this.onCancel,
    required this.personaName,
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).dividerColor.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.05),
          borderRadius: BorderRadius.circular(8),
          border: Border(
            left: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 3,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.reply_rounded,
              color: Theme.of(context).colorScheme.primary,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    message.isFromUser 
                        ? AppLocalizations.of(context)!.you
                        : personaName,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Text(
                    message.content,
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.close,
                size: 18,
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
              onPressed: onCancel,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(
                minWidth: 32,
                minHeight: 32,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageInput extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onSend;
  final VoidCallback onAttachment;
  final VoidCallback onEmotion;
  const _MessageInput({
    required this.controller,
    required this.focusNode,
    required this.onSend,
    required this.onAttachment,
    required this.onEmotion,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: AppTheme.softShadow,
      ),
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Message input field
              Expanded(
                child: Container(
                  constraints: const BoxConstraints(maxHeight: 120),
                  decoration: BoxDecoration(
                    color: Theme.of(context).inputDecorationTheme.fillColor,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: Theme.of(context).dividerColor.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                  child: TextField(
                    controller: controller,
                    focusNode: focusNode,
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!.typeMessage,
                      hintStyle: TextStyle(
                        color: Theme.of(context).textTheme.bodySmall?.color,
                        fontSize: 14,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                    maxLines: null,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => onSend(),
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 8),

              // Send button
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: AppTheme.primaryGradient,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryColor.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: onSend,
                      child: const Center(
                        child: Icon(
                          Icons.send_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
