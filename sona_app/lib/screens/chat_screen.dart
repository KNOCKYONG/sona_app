import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/auth_service.dart';
import '../../services/persona_service.dart';
import '../../services/chat_service.dart';
import '../../services/subscription_service.dart';
import '../../models/persona.dart';
import '../../models/message.dart';
import '../widgets/message_bubble.dart';
import '../widgets/typing_indicator.dart';
import '../widgets/tutorial_overlay.dart';
import '../../models/tutorial_animation.dart' as anim_model;
import '../widgets/sona_logo.dart';
import '../widgets/persona_profile_viewer.dart';
import '../widgets/modern_emotion_picker.dart';
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

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  
  bool _isTyping = false;
  String _selectedEmotion = 'neutral';
  static const int _maxTutorialMessages = 30;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeChat();
    });
  }

  Future<void> _initializeChat() async {
    if (!mounted) return;
    
    final personaService = Provider.of<PersonaService>(context, listen: false);
    final chatService = Provider.of<ChatService>(context, listen: false);
    final authService = Provider.of<AuthService>(context, listen: false);
    final subscriptionService = Provider.of<SubscriptionService>(context, listen: false);
    
    chatService.setPersonaService(personaService);
    
    final userId = authService.user?.uid ?? 'tutorial_user';
    chatService.setCurrentUserId(userId);
    
    debugPrint('🔗 ChatService initialized with PersonaService and userId: $userId');
    
    if (authService.user != null) {
      await subscriptionService.loadSubscription(authService.user!.uid);
    } else if (authService.isTutorialMode) {
      await subscriptionService.loadSubscription('tutorial_user');
    }
    
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Persona) {
      if (authService.isTutorialMode) {
        await personaService.setCurrentPersonaForTutorial(args);
      } else {
        await personaService.selectPersona(args);
        // 🔧 FIX: Force refresh relationship data from Firebase for accurate display
        debugPrint('🔄 Forcing relationship refresh for persona: ${args.name}');
        await personaService.refreshMatchedPersonasRelationships();
      }
    }
    
    if (personaService.currentPersona != null) {
      try {
        await chatService.loadChatHistory(
          userId,
          personaService.currentPersona!.id
        );
        
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
        userId: authService.user?.uid ?? 'tutorial_user',
        personaId: persona.id,
        persona: persona,
      );
    }
  }

  String _getPersonalizedWelcomeMessage(Persona persona) {
    // 모든 페르소나는 일반 페르소나
    final isExpert = false;
    
    if (isExpert) {
      // 전문가용 첫 인사말 - 더 전문적이지만 친근하게
      const expertMessages = [
        '안녕하세요, {name}입니다. 만나서 반가워요. 편안하게 마음을 나눠주세요.',
        '안녕하세요~ 저는 {name}라고 해요. 오늘은 어떤 이야기를 나누고 싶으세요?',
        '반가워요! {name}입니다. 어떤 고민이든 편하게 말씀해 주세요.',
      ];
      
      final template = expertMessages[DateTime.now().millisecondsSinceEpoch % expertMessages.length];
      return template.replaceAll('{name}', persona.name);
    } else {
      // 일반 페르소나용 인사말
      const messages = [
        '안녕하세요! {name}이라고 해요. 만나서 반가워요ㅎㅎ',
        '안녕하세요~ 오늘 하루는 어떠셨나요? 저는 {name}이라고 해요.',
        '반가워요! 전 {name}이라고 해요. 편하게 대화해요ㅎㅎ',
      ];
      
      final template = messages[DateTime.now().millisecondsSinceEpoch % messages.length];
      return template.replaceAll('{name}', persona.name);
    }
  }

  void _sendMessage() async {
    final content = _messageController.text.trim();
    if (content.isEmpty) return;
    
    final chatService = Provider.of<ChatService>(context, listen: false);
    final authService = Provider.of<AuthService>(context, listen: false);
    final personaService = Provider.of<PersonaService>(context, listen: false);
    
    if (authService.isTutorialMode) {
      final currentCount = await chatService.getTotalTutorialMessageCount();
      if (currentCount >= _maxTutorialMessages) {
        _showLoginPromptDialog();
        return;
      }
    }
    
    _messageController.clear();
    
    final persona = personaService.currentPersona ?? Persona(
      id: 'tutorial_persona',
      name: '튜토리얼',
      age: 22,
      description: 'SONA 앱 체험용 페르소나',
      photoUrls: [],
      personality: '친근하고 도움이 되는 성격',
    );
    
    final userId = authService.user?.uid ?? 'tutorial_user';
    
    final success = await chatService.sendMessage(
      content: content,
      userId: userId,
      persona: persona,
    );
    
    if (success) {
      _scrollToBottom();
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

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    
    Widget scaffold = Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          // Tutorial mode banner
          if (authService.isTutorialMode) const _TutorialBanner(),
          
          // Chat messages list
          Expanded(
            child: Consumer2<ChatService, PersonaService>(
              builder: (context, chatService, personaService, child) {
                if (chatService.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFFFF6B9D),
                    ),
                  );
                }

                final messages = chatService.messages;
                
                if (messages.isEmpty) {
                  return const _EmptyState();
                }
                
                // Use ListView.builder for better performance
                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length + (chatService.isTyping ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == messages.length && chatService.isTyping) {
                      return const Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: TypingIndicator(),
                      );
                    }
                    
                    final message = messages[index];
                    return MessageBubble(
                      key: ValueKey(message.id),
                      message: message,
                      isExpertChat: personaService.currentPersona?.isExpert ?? false,
                      onScoreChange: () {
                        // Handle score change if needed
                      },
                    );
                  },
                );
              },
            ),
          ),
          
          // Message input
          Consumer<PersonaService>(
            builder: (context, personaService, child) {
              final isExpertChat = false;
              return _MessageInput(
                controller: _messageController,
                focusNode: _focusNode,
                onSend: _sendMessage,
                onAttachment: _showAttachmentMenu,
                onEmotion: _showEmotionPicker,
                isExpertChat: isExpertChat,
              );
            },
          ),
        ],
      ),
    );
    
    if (authService.isTutorialMode) {
      final tutorialSteps = _getChatTutorialSteps();
      // 🔧 FIX: 튜토리얼 스텝이 있을 때만 오버레이 표시
      if (tutorialSteps.isNotEmpty) {
        return TutorialOverlay(
          screenKey: 'chat_screen',
          child: scaffold,
          tutorialSteps: tutorialSteps,
          animatedSteps: _getAnimatedTutorialSteps(),  // 애니메이션 스텝 추가
        );
      }
    }

    return scaffold;
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white.withOpacity(0.95),
      leading: Center(
        child: ModernIconButton(
          icon: Icons.arrow_back_ios_rounded,
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/chat-list');
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

  List<anim_model.AnimatedTutorialStep> _getAnimatedTutorialSteps() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    return [
      // 스텝 1: 메시지 입력 가이드
      anim_model.AnimatedTutorialStep(
        animations: [
          // 타이핑 애니메이션 - 입력창 중앙에 위치
          anim_model.TutorialAnimation(
            type: anim_model.TutorialAnimationType.typing,
            startPosition: Offset(screenWidth * 0.5, screenHeight - 65),  // 입력창 중앙
            duration: const Duration(seconds: 3),
            delay: const Duration(milliseconds: 500),
          ),
          // 전송 버튼 탭 - 실제 버튼 위치에 맞춤
          anim_model.TutorialAnimation(
            type: anim_model.TutorialAnimationType.tap,
            startPosition: Offset(screenWidth - 60, screenHeight - 65),  // 오른쪽 전송 버튼
            duration: const Duration(seconds: 1),
            delay: const Duration(seconds: 4),
          ),
        ],
        highlightArea: anim_model.HighlightArea(
          left: 20,
          top: screenHeight - 100,  // 하단 입력창 영역
          width: screenWidth - 40,
          height: 70,
          borderRadius: BorderRadius.circular(35),
          glowColor: const Color(0xFFFF6B9D),
        ),
        stepDuration: const Duration(seconds: 8),
      ),
      // 스텝 2: 감정 버튼 가이드
      anim_model.AnimatedTutorialStep(
        animations: [
          // 감정 버튼 바운스 - 입력창 내부 왼쪽의 이모지 버튼
          anim_model.TutorialAnimation(
            type: anim_model.TutorialAnimationType.bounce,
            startPosition: Offset(60, screenHeight - 65),  // 입력창 내부 왼쪽 이모지 버튼
            duration: const Duration(seconds: 2),
            color: const Color(0xFFFFEB3B),
            repeat: true,
          ),
          // 탭 애니메이션
          anim_model.TutorialAnimation(
            type: anim_model.TutorialAnimationType.tap,
            startPosition: Offset(60, screenHeight - 65),  // 입력창 내부 왼쪽 이모지 버튼
            duration: const Duration(seconds: 1),
            delay: const Duration(seconds: 3),
          ),
        ],
        highlightArea: anim_model.HighlightArea(
          left: 35,  // 이모지 버튼 주변
          top: screenHeight - 90,  // 입력창 높이
          width: 50,
          height: 50,
          borderRadius: BorderRadius.circular(25),
          glowColor: const Color(0xFFFFEB3B),
          glowRadius: 20,
        ),
        stepDuration: const Duration(seconds: 6),
      ),
    ];
  }
  
  List<TutorialStep> _getChatTutorialSteps() {
    final screenSize = MediaQuery.of(context).size;
    
    // 레거시 텍스트 스텝 (백업용) - 2개로 줄임
    return [
      TutorialStep(
        title: '',
        description: '',
        messagePosition: Offset(0, 0),
      ),
      TutorialStep(
        title: '',
        description: '',
        messagePosition: Offset(0, 0),
      ),
    ];
  }

  void _showLoginPromptDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            '🎉 튜토리얼 체험 완료!',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFF6B9D),
            ),
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.message,
                size: 60,
                color: Color(0xFFFF6B9D),
              ),
              const SizedBox(height: 16),
              const Text(
                '30개의 메시지를 모두 사용하셨습니다.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                '로그인하시면 제한 없이 대화를 나누고\n모든 기능을 사용할 수 있어요!',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: const [
                    Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.blue, size: 16),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '무제한 대화',
                            style: TextStyle(fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.blue, size: 16),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '데이터 저장 및 동기화',
                            style: TextStyle(fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.blue, size: 16),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '프리미엄 기능 사용',
                            style: TextStyle(fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                '나중에',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                final authService = Provider.of<AuthService>(context, listen: false);
                
                // Show loading
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFFF6B9D),
                      ),
                    );
                  },
                );
                
                // Exit tutorial and sign in
                final success = await authService.exitTutorialAndSignIn();
                
                if (mounted) {
                  Navigator.of(context).pop(); // Remove loading
                  
                  if (!success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('로그인에 실패했습니다. 다시 시도해주세요.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  } else {
                    // Navigate to chat list after successful login
                    Navigator.of(context).pushReplacementNamed('/chat-list');
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6B9D),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                '로그인하기',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showAttachmentMenu() {
    final authService = Provider.of<AuthService>(context, listen: false);
    if (authService.isTutorialMode) {
      _showPremiumFeatureDialog();
      return;
    }
    // Show attachment menu implementation
  }

  void _showEmotionPicker() {
    final authService = Provider.of<AuthService>(context, listen: false);
    if (authService.isTutorialMode) {
      _showPremiumFeatureDialog();
      return;
    }
    
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

  void _showPremiumFeatureDialog() {
    // Implementation remains the same
  }

  List<TutorialStep> _getTutorialSteps(BuildContext context) {
    // 🔧 FIX: 채팅 화면용 기본 튜토리얼 스텝 제공
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    
    return [
      TutorialStep(
        title: '채팅을 시작해보세요 💬',
        description: '하단의 메시지 입력창에 메시지를 입력하고 전송해보세요.\n소나가 응답해줄 거예요!',
        messagePosition: Offset(screenWidth * 0.5, screenHeight * 0.4),
        highlightArea: HighlightArea(
          left: 16,
          top: screenHeight - 100,
          width: screenWidth - 32,
          height: 60,
        ),
      ),
      TutorialStep(
        title: 'Like 시스템 📊',
        description: '대화를 나누면서 소나와의 Like가 변화해요.\n좋은 대화를 나누면 관계가 발전할 수 있답니다!',
        messagePosition: Offset(screenWidth * 0.5, screenHeight * 0.5),
        highlightArea: null,
      ),
    ];
  }
}

// Separate widgets for better performance

class _TutorialBanner extends StatelessWidget {
  const _TutorialBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFF6B9D).withValues(alpha: 0.1),
        border: const Border(
          bottom: BorderSide(
            color: Color(0xFFFF6B9D),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.info_outline,
            color: Color(0xFFFF6B9D),
            size: 20,
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              '튜토리얼 모드입니다.',
              style: TextStyle(
                color: Color(0xFFFF6B9D),
                fontSize: 12,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              'Login',
              style: TextStyle(
                color: Color(0xFFFF6B9D),
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AppBarTitle extends StatelessWidget {
  const _AppBarTitle();

  @override
  Widget build(BuildContext context) {
    return Consumer2<PersonaService, AuthService>(
      builder: (context, personaService, authService, child) {
        final persona = personaService.currentPersona;
        
        if (persona == null) {
          return const _TutorialPersonaTitle();
        }
        
        return _PersonaTitle(persona: persona);
      },
    );
  }
}

class _TutorialPersonaTitle extends StatelessWidget {
  const _TutorialPersonaTitle();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        _ProfileImage(photoUrl: null),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '튜토리얼님과의 대화',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'On',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ),
      ],
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
        // 모든 페르소나는 일반 페르소나
        final isExpert = false;
        
        return Row(
      children: [
        GestureDetector(
          onTap: () => _showPersonaProfile(context, updatedPersona),
          child: Builder(
            builder: (context) {
              final thumbnailUrl = updatedPersona.getThumbnailUrl();
              debugPrint('🖼️ Profile Image URL: $thumbnailUrl');
              debugPrint('📦 ImageUrls data: ${updatedPersona.imageUrls}');
              return _ProfileImage(
                photoUrl: thumbnailUrl,
              );
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // 전문가 뱃지 표시
                  if (isExpert) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2196F3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        '전문가',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                  ],
                  Expanded(
                    child: Text(
                      isExpert
                          ? '${updatedPersona.name}님과의 상담'
                          : '${updatedPersona.name}님과의 대화',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              // 전문가는 전문 분야 표시, 일반 페르소나는 온라인 상태 표시
              if (isExpert)
                Text(
                  updatedPersona.profession ?? '전문 상담',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                )
              else
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
    debugPrint('🔍 _ProfileImage build - photoUrl: $photoUrl');
    
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0xFFFF6B9D),
          width: 2,
        ),
      ),
      child: ClipOval(
        child: photoUrl != null && photoUrl!.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: photoUrl!,
                fit: BoxFit.cover,
                memCacheWidth: 80,
                memCacheHeight: 80,
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
    // 🔍 DEBUG: 전문가 페르소나 확인
    debugPrint('🩺 _OnlineStatus - Persona: ${persona.name}');
    debugPrint('   - Role: ${persona.role}');
    debugPrint('   - IsExpert: ${persona.isExpert}');
    debugPrint('   - Should NOT show for experts!');
    
    // Use currentRelationship if available, otherwise calculate from score
    final relationshipType = persona.currentRelationship != RelationshipType.friend || persona.relationshipScore > 0
        ? persona.currentRelationship 
        : persona.getRelationshipType();
    final colors = _getRelationshipColors(relationshipType);
    
    return Row(
      children: [
        Text(
          'On',
          style: TextStyle(
            fontSize: 12,
            color: Colors.green[600],
          ),
        ),
        const Text(
          ' • ',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: colors['background'],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            relationshipType.displayName,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: colors['text'],
            ),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          'Like ${persona.relationshipScore}',
          style: const TextStyle(
            fontSize: 10,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Map<String, Color> _getRelationshipColors(RelationshipType type) {
    switch (type) {
      case RelationshipType.friend:
        return {'background': Colors.blue[100]!, 'text': Colors.blue[700]!};
      case RelationshipType.crush:
        return {'background': Colors.orange[100]!, 'text': Colors.orange[700]!};
      case RelationshipType.dating:
        return {'background': Colors.pink[100]!, 'text': Colors.pink[700]!};
      case RelationshipType.perfectLove:
        return {'background': Colors.red[100]!, 'text': Colors.red[700]!};
    }
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
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            '아직 대화가 없어요',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '첫 메시지를 보내보세요!',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
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
  final bool isExpertChat;

  const _MessageInput({
    required this.controller,
    required this.focusNode,
    required this.onSend,
    required this.onAttachment,
    required this.onEmotion,
    this.isExpertChat = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: AppTheme.softShadow,
      ),
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Hide attachment button for expert chat
              if (!isExpertChat) ...[
                // Attachment button
                Consumer<AuthService>(
                  builder: (context, authService, child) {
                    return ModernIconButton(
                      icon: Icons.add_rounded,
                      onPressed: onAttachment,
                      color: authService.isTutorialMode 
                          ? Colors.grey[400] 
                          : AppTheme.accentColor,
                      tooltip: '파일 첨부',
                    );
                  },
                ),
                const SizedBox(width: 8),
              ],
              
              // Message input field
              Expanded(
                child: Container(
                  constraints: const BoxConstraints(maxHeight: 120),
                  decoration: BoxDecoration(
                    color: AppTheme.backgroundColor,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                  child: TextField(
                    controller: controller,
                    focusNode: focusNode,
                    decoration: InputDecoration(
                      hintText: '메시지를 입력하세요...',
                      hintStyle: TextStyle(
                        color: Colors.grey[500],
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
              
              // Emotion button (hidden for expert chat)
              if (!isExpertChat) ...[
                Consumer<AuthService>(
                  builder: (context, authService, child) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      child: ModernIconButton(
                        icon: Icons.mood_rounded,
                        onPressed: onEmotion,
                        color: authService.isTutorialMode 
                            ? Colors.grey[400] 
                            : AppTheme.primaryColor,
                        tooltip: '감정 선택',
                      ),
                    );
                  },
                ),
                const SizedBox(width: 8),
              ],
              
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