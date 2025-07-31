import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../services/auth/auth_service.dart';
import '../services/persona/persona_service.dart';
import '../services/chat/chat_service.dart';
import '../services/purchase/subscription_service.dart';
import '../services/relationship/relation_score_service.dart';
import '../services/relationship/relationship_visual_system.dart';
import '../models/persona.dart';
import '../widgets/chat/message_bubble.dart';
import '../widgets/chat/typing_indicator.dart';
import '../widgets/persona/persona_profile_viewer.dart';
import '../widgets/common/modern_emotion_picker.dart';
import '../theme/app_theme.dart';

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

  void _setupScrollListener() {
    _scrollController.addListener(() {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;
      final scrollThreshold = 100.0;
      
      // 사용자가 맨 아래에 가까운지 확인 (100픽셀 이내)
      final isNearBottom = maxScroll - currentScroll <= scrollThreshold;
      
      if (_isNearBottom != isNearBottom) {
        setState(() {
          _isNearBottom = isNearBottom;
          // 맨 아래로 돌아왔으면 읽지 않은 메시지 카운트 초기화
          if (isNearBottom) {
            _unreadAIMessageCount = 0;
          }
        });
      }
      
      // 사용자가 스크롤 중인지 감지
      if (_scrollController.position.isScrollingNotifier.value) {
        if (!_isUserScrolling) {
          setState(() {
            _isUserScrolling = true;
          });
        }
      } else {
        // 스크롤이 멈췄을 때
        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted && !_scrollController.position.isScrollingNotifier.value) {
            setState(() {
              _isUserScrolling = false;
            });
          }
        });
      }
    });
  }
  
  void _setupKeyboardListener() {
    // 키보드 상태 감지를 위한 FocusNode 리스너
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        // 키보드가 올라올 때 자동으로 맨 아래로 스크롤
        Future.delayed(const Duration(milliseconds: 300), () {
          _scrollToBottom(force: true);
        });
      }
    });
  }

  Future<void> _initializeChat() async {
    if (!mounted) return;
    
    final personaService = Provider.of<PersonaService>(context, listen: false);
    final chatService = Provider.of<ChatService>(context, listen: false);
    final authService = Provider.of<AuthService>(context, listen: false);
    final subscriptionService = Provider.of<SubscriptionService>(context, listen: false);
    
    chatService.setPersonaService(personaService);
    
    final userId = authService.user?.uid ?? '';
    chatService.setCurrentUserId(userId);
    
    debugPrint('🔗 ChatService initialized with PersonaService and userId: $userId');
    
    if (authService.user != null) {
      await subscriptionService.loadSubscription(authService.user!.uid);
    }
    
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Persona) {
      await personaService.selectPersona(args);
      // 🔧 FIX: Force refresh relationship data from Firebase for accurate display
      debugPrint('🔄 Forcing relationship refresh for persona: ${args.name}');
      await personaService.refreshMatchedPersonasRelationships();
    }
    
    if (personaService.currentPersona != null) {
      try {
        // Only load chat history if user is authenticated
        if (userId.isNotEmpty) {
          await chatService.loadChatHistory(
            userId,
            personaService.currentPersona!.id
          );
          
          // 🔵 채팅방 진입 시 모든 페르소나 메시지를 읽음으로 표시
          await chatService.markAllMessagesAsRead(
            userId,
            personaService.currentPersona!.id
          );
          
          // Force refresh to ensure UI updates
          await Future.delayed(const Duration(milliseconds: 100));
          chatService.notifyListeners();
        } else {
          debugPrint('⚠️ User not authenticated, skipping chat history load');
          // Clear any existing messages for guest users
          chatService.clearMessages();
        }
        
        if (chatService.messages.isEmpty) {
          _showWelcomeMessage();
        }
      } catch (e) {
        debugPrint('❌ Error loading chat history: $e');
        // Show welcome message as fallback
        _showWelcomeMessage();
      }
    } else {
      debugPrint('⚠️ No current persona available for chat');
    }
  }

  void _showWelcomeMessage() async {
    final personaService = Provider.of<PersonaService>(context, listen: false);
    final chatService = Provider.of<ChatService>(context, listen: false);
    final authService = Provider.of<AuthService>(context, listen: false);
    final persona = personaService.currentPersona;
    
    if (persona != null) {
      // 초기 인사 메시지 전송
      await chatService.sendInitialGreeting(
        userId: authService.user?.uid ?? '',
        personaId: persona.id,
        persona: persona,
      );
    }
  }


  void _sendMessage() async {
    final content = _messageController.text.trim();
    if (content.isEmpty) return;
    
    final chatService = Provider.of<ChatService>(context, listen: false);
    final authService = Provider.of<AuthService>(context, listen: false);
    final personaService = Provider.of<PersonaService>(context, listen: false);
    
    
    _messageController.clear();
    
    final persona = personaService.currentPersona;
    if (persona == null) {
      debugPrint('No persona selected');
      return;
    }
    
    final userId = authService.user?.uid ?? '';
    
    final success = await chatService.sendMessage(
      content: content,
      userId: userId,
      persona: persona,
    );
    
    if (success) {
      _scrollToBottom(force: true);
    } else {
      _messageController.text = content;
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('메시지 전송에 실패했습니다. 다시 시도해주세요.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _scrollToBottom({bool force = false, bool smooth = true}) {
    // 자동 스크롤 조건 체크
    // 1. force가 true이거나
    // 2. 사용자가 스크롤 중이 아니고 맨 아래에 가까이 있을 때만 자동 스크롤
    if (!force && (_isUserScrolling || !_isNearBottom)) {
      return;
    }
    
    // force가 true면 즉시 실행, 아니면 다음 프레임에서 실행
    if (force) {
      if (_scrollController.hasClients) {
        final targetScroll = _scrollController.position.maxScrollExtent;
        
        if (smooth) {
          // 부드러운 스크롤 애니메이션
          _scrollController.animateTo(
            targetScroll,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
          );
        } else {
          // 즉시 이동
          _scrollController.jumpTo(targetScroll);
        }
      }
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          final targetScroll = _scrollController.position.maxScrollExtent;
          
          if (smooth) {
            // 부드러운 스크롤 애니메이션
            _scrollController.animateTo(
              targetScroll,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
            );
          } else {
            // 즉시 이동
            _scrollController.jumpTo(targetScroll);
          }
        }
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Check if persona changed
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Persona && _currentPersonaId != args.id) {
      _currentPersonaId = args.id;
      // Reload chat for new persona
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _initializeChat();
      });
    }
  }
  
  String? _currentPersonaId;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      // Mark messages as read when app goes to background
      _markMessagesAsReadOnExit();
    }
  }
  
  void _markMessagesAsReadOnExit() {
    final chatService = Provider.of<ChatService>(context, listen: false);
    final authService = Provider.of<AuthService>(context, listen: false);
    final personaService = Provider.of<PersonaService>(context, listen: false);
    
    final userId = authService.user?.uid ?? '';
    final currentPersona = personaService.currentPersona;
    
    if (userId.isNotEmpty && currentPersona != null) {
      chatService.markAllMessagesAsRead(userId, currentPersona.id);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // Mark all messages as read when leaving chat
    _markMessagesAsReadOnExit();
    
    _messageController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget scaffold = Scaffold(
      appBar: _buildAppBar(),
      resizeToAvoidBottomInset: true, // 키보드가 올라올 때 화면 크기 조정
      body: Column(
        children: [
          
          // Chat messages list
          Expanded(
            child: Stack(
              children: [
                Consumer2<ChatService, PersonaService>(
                  builder: (context, chatService, personaService, child) {
                if (chatService.isLoading) {
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
                  final newMessageCount = messages.length - _previousMessageCount;
                  bool hasNewAIMessage = false;
                  bool isLastAIMessage = false;
                  
                  // 새로 추가된 메시지들 중 AI 메시지가 있는지 확인
                  for (int i = messages.length - newMessageCount; i < messages.length; i++) {
                    if (!messages[i].isFromUser) {
                      hasNewAIMessage = true;
                      // 사용자가 위로 스크롤 중이면 읽지 않은 AI 메시지 카운트 증가
                      if (!_isNearBottom) {
                        _unreadAIMessageCount++;
                      }
                      
                      // 마지막 AI 메시지인지 확인
                      final metadata = messages[i].metadata;
                      if (metadata != null && metadata['isLastInSequence'] == true) {
                        isLastAIMessage = true;
                      }
                    }
                  }
                  
                  _previousMessageCount = messages.length;
                  
                  // AI 메시지가 추가되었을 때 처리
                  if (hasNewAIMessage) {
                    // 채팅방에 있을 때는 즉시 읽음 처리
                    final authService = Provider.of<AuthService>(context, listen: false);
                    final userId = authService.user?.uid ?? '';
                    if (userId.isNotEmpty && mounted) {
                      // Mark messages as read after a short delay to ensure they're saved
                      Future.delayed(const Duration(milliseconds: 300), () async {
                        if (mounted) {
                          await chatService.markAllMessagesAsRead(userId, currentPersona.id);
                          chatService.notifyListeners();
                        }
                      });
                    }
                    
                    // 스크롤 처리
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _scrollToBottom(force: true);
                    });
                  }
                }
                
                // 타이핑 인디케이터 상태 변경 감지
                final isTyping = chatService.isPersonaTyping(currentPersona.id);
                if (isTyping && _previousIsTyping != isTyping) {
                  _previousIsTyping = isTyping;
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _scrollToBottom(force: true);
                  });
                }
                
                // Use ListView.builder for better performance
                return ListView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 16,
                    bottom: 16 + MediaQuery.of(context).viewInsets.bottom, // 키보드 높이만큼 패딩 추가
                  ),
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag, // 스크롤 시 키보드 숨김
                  itemCount: messages.length + (chatService.isPersonaTyping(currentPersona.id) ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == messages.length && chatService.isPersonaTyping(currentPersona.id)) {
                      return const Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: TypingIndicator(),
                      );
                    }
                    
                    final message = messages[index];
                    return MessageBubble(
                      key: ValueKey(message.id),
                      message: message,
                      onScoreChange: () {
                        // Handle score change if needed
                      },
                    );
                  },
                );
              },
            ),
            // 스크롤 상태 표시기 (맨 아래로 이동 버튼)
            if (!_isNearBottom)
              Positioned(
                bottom: 16,
                right: 16,
                child: AnimatedOpacity(
                  opacity: _isNearBottom ? 0.0 : 1.0,
                  duration: const Duration(milliseconds: 200),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(24),
                        onTap: () {
                          _scrollToBottom(force: true);
                          setState(() {
                            _unreadAIMessageCount = 0;
                          });
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              child: const Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: Color(0xFFFF6B9D),
                                size: 24,
                              ),
                            ),
                            // 읽지 않은 AI 메시지 개수 표시
                            if (_unreadAIMessageCount > 0)
                              Positioned(
                                top: 4,
                                right: 4,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFFF6B9D),
                                    shape: BoxShape.circle,
                                  ),
                                  constraints: const BoxConstraints(
                                    minWidth: 18,
                                    minHeight: 18,
                                  ),
                                  child: Center(
                                    child: Text(
                                      _unreadAIMessageCount.toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
          
          // Message input
          Consumer<PersonaService>(
            builder: (context, personaService, child) {
              return _MessageInput(
                controller: _messageController,
                focusNode: _focusNode,
                onSend: _sendMessage,
                onAttachment: _showAttachmentMenu,
                onEmotion: _showEmotionPicker,
              );
            },
          ),
        ],
      ),
    );
    
    return scaffold;
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0.5,
      leading: Center(
        child: ModernIconButton(
          icon: Icons.arrow_back_ios_rounded,
          onPressed: () async {
            // Mark all messages as read before leaving
            final chatService = Provider.of<ChatService>(context, listen: false);
            final authService = Provider.of<AuthService>(context, listen: false);
            final personaService = Provider.of<PersonaService>(context, listen: false);
            
            final userId = authService.user?.uid ?? '';
            final currentPersona = personaService.currentPersona;
            
            debugPrint('🔙 Back button pressed - userId: $userId, persona: ${currentPersona?.name}');
            
            if (userId.isNotEmpty && currentPersona != null) {
              // First, get current messages
              final messagesBefore = chatService.getMessages(currentPersona.id);
              final unreadBefore = messagesBefore.where((m) => !m.isFromUser && (m.isRead == false || m.isRead == null)).length;
              debugPrint('📊 Before marking - Unread count: $unreadBefore');
              
              // Wait for messages to be marked as read
              await chatService.markAllMessagesAsRead(userId, currentPersona.id);
              
              // 메시지 상태 확인
              final messagesAfter = chatService.getMessages(currentPersona.id);
              final unreadAfter = messagesAfter.where((m) => !m.isFromUser && (m.isRead == false || m.isRead == null)).length;
              debugPrint('📊 After marking as read - Unread count: $unreadAfter');
              
              // 추가 딜레이를 주어 확실히 업데이트되도록 함
              await Future.delayed(const Duration(milliseconds: 300));
              
              // Force refresh multiple times to ensure update
              chatService.notifyListeners();
              await Future.delayed(const Duration(milliseconds: 100));
              chatService.notifyListeners();
            }
            
            // Navigate back to chat list tab
            if (mounted) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/chat-list',
                (route) => false,
              );
            }
          },
          tooltip: '뒤로가기',
        ),
      ),
      title: const _AppBarTitle(),
      actions: [
        Center(
          child: Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ModernIconButton(
              icon: Icons.more_horiz_rounded,
              onPressed: () {
                // Menu options
              },
              tooltip: '더보기',
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


}

// Separate widgets for better performance


class _AppBarTitle extends StatelessWidget {
  const _AppBarTitle();

  @override
  Widget build(BuildContext context) {
    return Consumer2<PersonaService, AuthService>(
      builder: (context, personaService, authService, child) {
        final persona = personaService.currentPersona;
        
        if (persona == null) {
          return const Text('페르소나를 선택해주세요');
        }
        
        return _PersonaTitle(persona: persona);
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
        
        return FutureBuilder<int>(
          future: _getLikes(context, updatedPersona),
          builder: (context, snapshot) {
            final likes = snapshot.data ?? updatedPersona.relationshipScore ?? 0;
            
            return Row(
              children: [
                GestureDetector(
                  onTap: () => _showPersonaProfile(context, updatedPersona),
                  child: Builder(
                    builder: (context) {
                      final thumbnailUrl = updatedPersona.getThumbnailUrl();
                      debugPrint('🖼️ Profile Image URL: $thumbnailUrl');
                      debugPrint('📦 ImageUrls data: ${updatedPersona.imageUrls}');
                      
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
                        '${updatedPersona.name}님과의 대화',
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
      },
    );
  }
  
  Future<int> _getLikes(BuildContext context, Persona persona) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final userId = authService.user?.uid;
    
    if (userId == null) return persona.relationshipScore ?? 0;
    
    return await RelationScoreService.instance.getLikes(
      userId: userId,
      personaId: persona.id,
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
    debugPrint('🔍 _ProfileImage build - photoUrl: $photoUrl');
    
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
    return FutureBuilder<int>(
      future: _getLikes(context),
      builder: (context, snapshot) {
        final likes = snapshot.data ?? persona.relationshipScore ?? 0;
        final visualInfo = RelationScoreService.instance.getVisualInfo(likes);
        
        return Row(
          children: [
            // 온라인 표시
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: Colors.green[500],
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.4),
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ],
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
            const SizedBox(width: 8),
            // 뱃지
            SizedBox(
              width: 12,
              height: 12,
              child: visualInfo.badge,
            ),
          ],
        );
      },
    );
  }
  
  Future<int> _getLikes(BuildContext context) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final userId = authService.user?.uid;
    
    if (userId == null) return persona.relationshipScore ?? 0;
    
    return await RelationScoreService.instance.getLikes(
      userId: userId,
      personaId: persona.id,
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
            color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            '아직 대화가 없어요',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '첫 메시지를 보내보세요!',
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
              // Attachment button
              ModernIconButton(
                icon: Icons.add_rounded,
                onPressed: onAttachment,
                color: AppTheme.accentColor,
                tooltip: '파일 첨부',
              ),
              const SizedBox(width: 8),
              
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
                      hintText: '메시지를 입력하세요...',
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
              
              // Emotion button
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                child: ModernIconButton(
                  icon: Icons.mood_rounded,
                  onPressed: onEmotion,
                  color: AppTheme.primaryColor,
                  tooltip: '감정 선택',
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