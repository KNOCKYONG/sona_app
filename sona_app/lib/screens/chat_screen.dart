import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../services/auth_service.dart';
import '../../services/persona_service.dart';
import '../../services/chat_service.dart';
import '../../services/subscription_service.dart';
import '../../models/persona.dart';
import '../widgets/message_bubble.dart';
import '../widgets/typing_indicator.dart';
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
  
  String _selectedEmotion = 'neutral';

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
    Widget scaffold = Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          
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
        color: Colors.white,
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