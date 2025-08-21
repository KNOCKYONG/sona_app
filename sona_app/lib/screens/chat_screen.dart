import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../services/auth/auth_service.dart';
import '../services/auth/device_id_service.dart';
import '../services/auth/user_service.dart';
import '../services/persona/persona_service.dart';
import '../services/chat/core/chat_service.dart';
import '../services/purchase/purchase_service.dart';
import '../services/relationship/relation_score_service.dart';
import '../services/relationship/relationship_visual_system.dart';
import '../services/ui/haptic_service.dart';
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
  bool _isUserScrolling = false;
  bool _isNearBottom = true;
  int _previousMessageCount = 0;
  int _unreadAIMessageCount = 0;
  bool _previousIsTyping = false;
  // Track welcome messages per persona to prevent repetition
  final Map<String, bool> _hasShownWelcomePerPersona = {};
  bool _hasInitiallyScrolled = false; // Track if we've done initial scroll for this chat
  // _showMoreMenu 제거됨 - PopupMenuButton으로 대체
  
  // Reply functionality
  Message? _replyingToMessage;
  final Set<String> _newMessageIds = {}; // Track new messages for animation
  
  // 스크롤 디바운싱 관련 변수
  Timer? _scrollDebounceTimer;
  bool _isScrolling = false; // 현재 스크롤 중인지 추적

  // Service references for dispose method
  ChatService? _chatService;
  String? _userId;
  Persona? _currentPersona;
  bool _isInitialized = false;  // 🔥 Add initialization flag
  
  // 스크롤 위치 기억용 Map (personaId -> scrollPosition)
  final Map<String, double> _savedScrollPositions = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _setupScrollListener();
    _setupKeyboardListener();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeChat();
    });
  }

  bool _isLoadingMore = false;

  void _setupScrollListener() {
    _scrollController.addListener(() {
      // 스크롤 중이거나 로딩 중이면 리스너 무시 (충돌 방지)
      if (_isScrolling || _isLoadingMore) return;
      
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;
      final minScroll = _scrollController.position.minScrollExtent;
      final scrollThreshold = 100.0; // 임계값 증가하여 민감도 감소
      final paginationThreshold = 300.0; // 페이지네이션 임계값

      // 사용자가 맨 아래에 가까운지 확인 (100픽셀 이내)
      final isNearBottom = maxScroll - currentScroll <= scrollThreshold;

      // 사용자가 위로 스크롤했는지 감지 (현재 위치가 맨 아래에서 멀어졌을 때)
      // 단, 로딩 중이 아닐 때만 상태 변경
      if (!isNearBottom && _isNearBottom && !_isLoadingMore) {
        // 사용자가 위로 스크롤함 - 자동 스크롤 차단
        setState(() {
          _isUserScrolling = true;
          _isNearBottom = false;
        });
      } else if (isNearBottom && !_isNearBottom) {
        // 사용자가 다시 맨 아래로 왔음
        setState(() {
          _isNearBottom = true;
          _isUserScrolling = false;  // 맨 아래로 왔으니 자동 스크롤 허용
          // 읽지 않은 메시지 카운트 초기화
          if (_unreadAIMessageCount > 0) {
            _unreadAIMessageCount = 0;
          }
        });
      }

      // 상단 근처에서 추가 메시지 로드 (상단 300픽셀 이내)
      // 스크롤 속도를 체크하여 의도적인 스크롤일 때만 로드
      if (currentScroll <= minScroll + paginationThreshold && 
          !_isLoadingMore && 
          !_isScrolling) {
        _loadMoreMessages();
      }
    });
  }

  void _setupKeyboardListener() {
    // 키보드 상태 감지를 위한 FocusNode 리스너
    bool wasHasFocus = false;
    _focusNode.addListener(() {
      final hasFocus = _focusNode.hasFocus;
      // 포커스가 새로 활성화될 때만 스크롤 (조건 강화)
      if (hasFocus && !wasHasFocus && _scrollController.hasClients) {
        // 사용자가 이미 맨 아래에 있고 스크롤 중이 아닐 때만 스크롤
        if (_isNearBottom && !_isUserScrolling && !_isScrolling) {
          // 키보드가 올라올 때 약간의 딜레이로 레이아웃 업데이트 대기
          Future.delayed(const Duration(milliseconds: 150), () {
            if (mounted && _scrollController.hasClients && _focusNode.hasFocus && 
                _isNearBottom && !_isUserScrolling) {
              final bottomInset = MediaQuery.of(context).viewInsets.bottom;
              if (bottomInset > 0) {
                // 키보드가 올라왔을 때만 스크롤
                _scrollToBottom(force: false, smooth: true);
              }
            }
          });
        }
      }
      wasHasFocus = hasFocus;
    });
  }

  Future<void> _loadMoreMessages() async {
    if (_isLoadingMore ||
        _currentPersona == null ||
        _userId == null ||
        _userId!.isEmpty) return;

    _isLoadingMore = true;
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
            _scrollController.jumpTo(currentScrollPosition + scrollDiff);
          }
        }
      });
    }

    _isLoadingMore = false;
    if (mounted) setState(() {});
  }

  Future<void> _initializeChat() async {
    if (!mounted) return;

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
      // 🔥 Clear any existing chat state before loading new persona
      setState(() {
        _isInitialized = false;
      });
      
      await personaService.selectPersona(args);
      _currentPersona = args; // Store current persona for dispose method
      
      // 🔥 Verify the persona was actually selected
      if (personaService.currentPersona?.id != args.id) {
        debugPrint('⚠️ Persona selection mismatch, retrying...');
        await personaService.selectPersona(args);
      }
      
      // 🔧 FIX: Force refresh relationship data from Firebase for accurate display
      debugPrint('🔄 Forcing relationship refresh for persona: ${args.name}');
      await personaService.refreshMatchedPersonasRelationships();
    }

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
          await chatService.loadChatHistory(
              _userId!, personaService.currentPersona!.id);

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

        // Check if we need to show initial greeting
        final messages =
            chatService.getMessages(personaService.currentPersona!.id);
        debugPrint(
            '🔍 Checking messages for initial greeting: ${messages.length} messages found');
        if (messages.isEmpty) {
          debugPrint('📢 No messages found, showing welcome message');
          _showWelcomeMessage();
        } else {
          debugPrint('💬 Messages exist, skipping welcome message');
          
          // 저장된 스크롤 위치가 있는지 확인
          final savedPosition = _savedScrollPositions[personaService.currentPersona!.id];
          
          if (savedPosition != null && savedPosition > 0) {
            // 저장된 위치로 복원 (단순화: 중복 애니메이션 제거)
            debugPrint('📍 Restoring scroll position for ${personaService.currentPersona!.name}: $savedPosition');
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (_scrollController.hasClients) {
                final maxScroll = _scrollController.position.maxScrollExtent;
                final targetPosition = savedPosition.clamp(0.0, maxScroll);
                // jumpTo만 사용하여 즉시 위치 복원
                _scrollController.jumpTo(targetPosition);
              }
            });
          } else {
            // 저장된 위치가 없으면 마지막 메시지로 스크롤
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (_scrollController.hasClients) {
                // 단순화: 즉시 마지막으로 이동
                _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
              }
            });
          }
        }
      } catch (e) {
        debugPrint('❌ Error loading chat history: $e');
        // Don't show welcome message on error to prevent duplicates
      }
    } else {
      debugPrint('⚠️ No current persona available for chat');
    }
    
    // 🔥 Mark as initialized after all loading is complete
    if (mounted) {
      setState(() {
        _isInitialized = true;
      });
    }
  }

  void _showWelcomeMessage() async {
    debugPrint('🎉 _showWelcomeMessage called');

    final personaService = Provider.of<PersonaService>(context, listen: false);
    final chatService = Provider.of<ChatService>(context, listen: false);
    final authService = Provider.of<AuthService>(context, listen: false);
    final persona = personaService.currentPersona;

    // Get user ID (either Firebase or device ID)
    final userId = await DeviceIdService.getCurrentUserId(
      firebaseUserId: authService.user?.uid,
    );
    debugPrint('👤 User ID for welcome message: $userId');

    if (persona != null) {
      debugPrint('🤖 Persona found: ${persona.name}');

      // Check if we've already shown welcome for this persona
      if (_hasShownWelcomePerPersona[persona.id] == true) {
        debugPrint(
            '⚠️ Welcome message already shown for ${persona.name}, skipping');
        return;
      }

      // 이전 메시지가 없을 때만 초기 인사 메시지 전송
      final existingMessages = chatService.getMessages(persona.id);
      if (existingMessages.isEmpty) {
        debugPrint('✅ No existing messages, sending initial greeting');

        // Mark that we've shown welcome for this persona
        _hasShownWelcomePerPersona[persona.id] = true;

        await chatService.sendInitialGreeting(
          userId: userId,
          personaId: persona.id,
          persona: persona,
        );
      } else {
        debugPrint(
            '📝 Previous messages exist for ${persona.name}, skipping initial greeting');
        // Also mark as shown since messages already exist
        _hasShownWelcomePerPersona[persona.id] = true;
      }
    } else {
      debugPrint('❌ No persona available for welcome message');
    }
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

    // Check daily message limit first
    if (userService.isDailyMessageLimitReached()) {
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
      debugPrint('No persona selected');
      return;
    }

    final userId = authService.user?.uid;

    if (userId == null || userId.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('로그인이 필요한 서비스입니다'),
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
      
      // 스크롤은 _scrollToBottom 메서드로 통일
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
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
      return '오늘';
    } else if (messageDate == yesterday) {
      return '어제';
    } else if (messageDate.isAfter(today.subtract(const Duration(days: 7)))) {
      // 이번 주
      final weekdays = ['월요일', '화요일', '수요일', '목요일', '금요일', '토요일', '일요일'];
      return weekdays[date.weekday - 1];
    } else {
      // 더 오래된 날짜는 월/일 형식으로
      return DateFormat('M월 d일').format(date);
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
    // 사용자가 위로 스크롤 중이고 강제가 아니면 자동 스크롤 차단
    if (_isUserScrolling && !force) {
      debugPrint('📌 User is scrolling up, skip auto-scroll');
      return;
    }
    
    // 맨 아래에 있지 않고 강제가 아니면 자동 스크롤 차단  
    if (!_isNearBottom && !force && _hasInitiallyScrolled) {
      debugPrint('📌 Not near bottom, skip auto-scroll');
      return;
    }
    
    // 이미 스크롤 중이면 무시 (중복 스크롤 방지)
    if (_isScrolling && !force) {
      return;
    }
    
    // 초기 스크롤 완료 표시
    if (!_hasInitiallyScrolled) {
      _hasInitiallyScrolled = true;
    }

    // 디바운싱: 이전 타이머 취소
    _scrollDebounceTimer?.cancel();
    
    // 디바운싱: 새로운 스크롤 요청을 적절한 딜레이 후 실행 (50ms → 100ms로 증가)
    _scrollDebounceTimer = Timer(const Duration(milliseconds: 100), () {
      if (!mounted || !_scrollController.hasClients) return;
      
      // 다시 한번 사용자 스크롤 상태 확인
      if (_isUserScrolling && !force) return;
      
      _isScrolling = true;
      
      // 키보드 높이를 고려한 스크롤 위치 계산
      final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
      var targetScroll = _scrollController.position.maxScrollExtent;
      
      // 키보드가 올라와 있으면 추가 오프셋 적용
      if (keyboardHeight > 0) {
        // 키보드 위에 여백을 두고 마지막 메시지가 보이도록
        targetScroll = _scrollController.position.maxScrollExtent;
      }

      // iOS에서는 애니메이션 대신 즉시 이동으로 통일 (충돌 방지)
      if (Platform.isIOS || !smooth) {
        // iOS 또는 smooth가 false일 때: 즉시 이동
        _scrollController.jumpTo(targetScroll);
        _isScrolling = false;
        _isNearBottom = true;
        _isUserScrolling = false;  // 스크롤 완료 후 사용자 스크롤 상태 초기화
      } else {
        // Android에서 smooth가 true일 때만: 애니메이션 스크롤
        _scrollController.animateTo(
          targetScroll,
          duration: const Duration(milliseconds: 200),  // 애니메이션 시간 단축
          curve: Curves.easeOutCubic,  // 더 부드러운 커브
        ).then((_) {
          _isScrolling = false;
          _isNearBottom = true;
          _isUserScrolling = false;  // 스크롤 완료 후 사용자 스크롤 상태 초기화
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

      // Reload chat for new persona
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _initializeChat();
        // 페르소나가 변경되면 첫 로드 플래그 설정하고 메시지 로드 후 스크롔
        _hasInitiallyScrolled = false;
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted && _scrollController.hasClients) {
            // 단일 PostFrameCallback으로 단순화
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (_scrollController.hasClients) {
                _scrollToBottom(force: true, smooth: false);
              }
            });
          }
        });
      });
    }
  }

  String? _currentPersonaId;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      // 스크롤 위치 저장
      if (_currentPersona != null && _scrollController.hasClients) {
        _savedScrollPositions[_currentPersona!.id] = _scrollController.position.pixels;
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
    // 현재 스크롤 위치 저장
    if (_currentPersona != null && _scrollController.hasClients) {
      _savedScrollPositions[_currentPersona!.id] = _scrollController.position.pixels;
      debugPrint('📍 Saved scroll position for ${_currentPersona!.name}: ${_scrollController.position.pixels}');
    }
    
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
    // iOS에서는 FocusNode 리스너에서 처리하므로 여기서는 Android만 처리
    if (Platform.isIOS) return;
    
    // Handle keyboard appearance immediately (Android only)
    if (mounted) {
      final bottomInset = MediaQuery.of(context).viewInsets.bottom;
      // 키보드가 올라왔고, 사용자가 맨 아래에 있으며, 사용자가 스크롤 중이 아닐 때만
      if (bottomInset > 100 && _isNearBottom && !_isUserScrolling && !_isScrolling) {
        // 짧은 딜레이 후 부드럽게 스크롤 (레이아웃 업데이트 대기)
        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted && _scrollController.hasClients && _isNearBottom && !_isUserScrolling) {
            // 키보드가 올라왔을 때 스크롤 (smooth 옵션으로 부드럽게)
            _scrollToBottom(force: false, smooth: true);
          }
        });
      }
    }
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
                          // Don't show loading indicator on initial load
                          // Messages are already preloaded from chat_list_screen
                          if (chatService.isLoading && chatService.messages.isNotEmpty) {
                            // Only show loading for additional operations
                            return const Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFFFF6B9D),
                              ),
                            );
                          }

                          final messages = chatService.messages;
                          final currentPersona = personaService.currentPersona;

                          if (messages.isEmpty) {
                            return const _EmptyState();
                          }

                          if (currentPersona == null) {
                            return const Center(
                              child: Text('No persona selected'),
                            );
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

                              // 사용자가 맨 아래에 있고 스크롤 중이 아닐 때만 자동 스크롤
                              if (_isNearBottom && !_isUserScrolling && !_isScrolling) {
                                // 키보드가 올라와 있으면 딜레이를 더 줌
                                final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
                                final delay = keyboardHeight > 0 
                                    ? const Duration(milliseconds: 200)
                                    : const Duration(milliseconds: 100);
                                
                                Future.delayed(delay, () {
                                  if (mounted && _isNearBottom && !_isUserScrolling) {
                                    _scrollToBottom(force: false, smooth: true);
                                  }
                                });
                              }
                            }
                          }

                          // 타이핑 인디케이터 상태 변경 감지
                          final isTyping =
                              chatService.isPersonaTyping(currentPersona.id);
                          // 실제로 false -> true로 변경될 때만 스크롤
                          if (isTyping && !_previousIsTyping && _isNearBottom && !_isUserScrolling) {
                            _previousIsTyping = isTyping;
                            // 사용자가 맨 아래에 있고 스크롤 중이 아닐 때만 스크롤
                            _scrollToBottom(force: false, smooth: true);
                          } else if (!isTyping && _previousIsTyping) {
                            // 타이핑이 끝났을 때 상태만 업데이트
                            _previousIsTyping = isTyping;
                          }

                          // Use ListView.builder with optimizations
                          return ListView.builder(
                            key: ValueKey('chat_list_${currentPersona.id}'),
                            controller: _scrollController,
                            physics: Platform.isIOS 
                                ? const ClampingScrollPhysics() // iOS: bounce 효과 제거
                                : const BouncingScrollPhysics(), // Android: 기본 동작 유지
                            cacheExtent: 200.0, // 캐시 범위 축소로 메모리 최적화
                            addAutomaticKeepAlives: false, // 불필요한 위젯 유지 방지
                            addRepaintBoundaries: true, // 리페인트 최적화
                            padding: EdgeInsets.only(
                              left: 16,
                              right: 16,
                              top: 16,
                              bottom: MediaQuery.of(context).viewInsets.bottom > 0
                                  ? 160 + MediaQuery.of(context).viewInsets.bottom  // 키보드가 올라왔을 때 더 큰 여백
                                  : 120, // 기본 여백 증가
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
                                                ? '새 메시지 1개'
                                                : '새 메시지 $_unreadAIMessageCount개',
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
      debugPrint('🔍 Conditions met, showing loading dialog');

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
        await chatService.sendChatErrorReport(
          userId: userId,
          personaId: currentPersona.id,
        );
        success = true;
      } catch (e) {
        debugPrint('🔥 Error sending chat error report: $e');
        errorMessage = e.toString().contains('permission')
            ? '권한이 없습니다. 나중에 다시 시도해 주세요.'
            : '네트워크 오류가 발생했습니다.';
      }

      // Close loading dialog
      navigator.pop();

      // Show result message
      if (success) {
        scaffoldMessenger.showSnackBar(
          const SnackBar(
            content: Text('대화 오류가 성공적으로 전송되었습니다.'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text('오류 전송 실패: $errorMessage'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      debugPrint(
          '🔍 Conditions not met - userId: $userId, currentPersona: $currentPersona');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('페르소나를 선택해 주세요.'),
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
        title: const Text('다시 대화하기'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${currentPersona.name}와 다시 대화를 시작하시겠어요?'),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.favorite, color: Colors.red[400], size: 20),
                const SizedBox(width: 8),
                Text(
                  '하트 1개가 필요합니다',
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
                  '하트가 부족합니다. (현재: $currentHearts개)',
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
            child: const Text('취소'),
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
                  '하트 1개 사용하기',
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
              content: Text('${currentPersona.name}와 다시 대화를 시작합니다!'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
        } else {
          // 로딩 다이얼로그 닫기
          Navigator.of(context).pop();
          
          // 실패 메시지
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('하트 사용에 실패했습니다.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        // 로딩 다이얼로그 닫기
        Navigator.of(context).pop();
        
        debugPrint('Error restarting chat: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('오류가 발생했습니다. 다시 시도해주세요.'),
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
      final selectedMessage = await showDialog<Message>(
        context: context,
        builder: (dialogContext) => AlertDialog(
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
                Text(
                  AppLocalizations.of(context)!.selectTranslationError,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 16),
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
                          onTap: () => Navigator.of(dialogContext).pop(msg),
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
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
          ],
        ),
      );

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
            'messageId': selectedMessage.id,
            'originalContent': selectedMessage.content,
            'translatedContent': selectedMessage.translatedContent,
            'targetLanguage': selectedMessage.targetLanguage,
            'userLanguage': currentUser?.preferredLanguage ?? 'ko',
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

              // 추가 딜레이를 주어 확실히 업데이트되도록 함
              await Future.delayed(const Duration(milliseconds: 300));

              // Wait to ensure update is complete
              await Future.delayed(const Duration(milliseconds: 100));
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
                if (value == 'error_report') {
                  await _handleErrorReport();
                } else if (value == 'translation_error') {
                  await _handleTranslationError();
                } else if (value == 'restart_chat') {
                  await _handleRestartChat();
                } else if (value == 'leave_chat') {
                  await _handleLeaveChat();
                }
              },
              itemBuilder: (BuildContext context) {
                final personaService = Provider.of<PersonaService>(context, listen: false);
                final currentPersona = personaService.currentPersona;
                final isOffline = currentPersona != null && currentPersona.likes <= 0;
                
                return [
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
                          '대화 오류 전송하기',
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
                            '다시 대화하기',
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
                Expanded(
                  child: _PersonaTitle(persona: persona),
                ),
                // Show guest indicator
                if (isGuest) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.guestModeTitle.split(' ')[0], // "게스트"
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue[700],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
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
                  widthFactor: remainingMessages / 10,
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
