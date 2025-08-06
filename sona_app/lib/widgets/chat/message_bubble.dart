import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/message.dart';
import '../../models/persona.dart';
import '../../services/persona/persona_service.dart';
import '../../theme/app_theme.dart';
import '../persona/persona_profile_viewer.dart';
import '../../l10n/app_localizations.dart';

/// Optimized MessageBubble with performance improvements:
/// - Const constructors where possible
/// - Removed unnecessary animations for simple messages
/// - Cached DateFormat instance
/// - Reduced widget rebuilds with const widgets
/// - Optimized shadow rendering
class MessageBubble extends StatelessWidget {
  final Message message;
  final VoidCallback? onScoreChange;
  
  // Static DateFormat to avoid recreating on each build
  static final _timeFormat = DateFormat('HH:mm');
  
  // Cached colors to avoid recreating
  static const _userBubbleColor = AppTheme.primaryColor;
  static final _aiBubbleColor = Colors.white;
  static const _shadowColor = Color(0x0D000000); // Softer shadow

  const MessageBubble({
    super.key,
    required this.message,
    this.onScoreChange,
  });

  @override
  Widget build(BuildContext context) {
    // Call score change callback if needed
    if (message.likesChange != null && 
        message.likesChange != 0 &&
        onScoreChange != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        onScoreChange!();
      });
    }

    switch (message.type) {
      case MessageType.system:
        return _SystemMessage(message: message);
      case MessageType.storyEvent:
        return _StoryEventMessage(message: message);
      case MessageType.emotion:
        return _EmotionMessage(message: message);
      default:
        return _TextMessage(message: message);
    }
  }
}

// Separate widget for text messages to avoid rebuilds
class _TextMessage extends StatefulWidget {
  final Message message;
  
  static const _userTextStyle = TextStyle(
    color: Colors.white,
    fontSize: 16,
    height: 1.4,
  );
  
  static const _aiTextStyle = TextStyle(
    color: Colors.black87,
    fontSize: 16,
    height: 1.4,
  );

  const _TextMessage({
    required this.message,
  });

  @override
  State<_TextMessage> createState() => _TextMessageState();
}

class _TextMessageState extends State<_TextMessage> {
  bool _showTranslation = false;

  String _getLanguageName(String languageCode) {
    switch (languageCode) {
      case 'en':
        return 'English';
      case 'ja':
        return '日本語';
      case 'zh':
        return '中文';
      case 'id':
        return 'Bahasa';
      case 'vi':
        return 'Tiếng Việt';
      case 'es':
        return 'Español';
      case 'th':
        return 'ไทย';
      case 'ko':
      default:
        return '한국어';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isFromUser = widget.message.isFromUser;
    final maxWidth = MediaQuery.of(context).size.width * 0.75;
    
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: isFromUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile picture for AI messages (only on first message in sequence)
          if (!isFromUser && widget.message.isFirstInSequence) ...[
            _ProfileAvatar(),
            const SizedBox(width: 8),
          ] else if (!isFromUser) ...[
            // Empty space to maintain alignment
            const SizedBox(width: 44), // 36 (avatar) + 8 (spacing)
          ],
          
          // Modern message bubble with gradient and soft shadows
          Flexible(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: GestureDetector(
                onTap: () {
                  // 번역이 있는 경우에만 토글
                  if (!isFromUser && 
                      widget.message.translatedContent != null && 
                      widget.message.translatedContent!.isNotEmpty) {
                    setState(() {
                      _showTranslation = !_showTranslation;
                    });
                  }
                },
                onLongPress: () {
                  // 메시지 내용을 클립보드에 복사
                  final textToCopy = _showTranslation && widget.message.translatedContent != null
                      ? widget.message.translatedContent!
                      : widget.message.content;
                  Clipboard.setData(ClipboardData(text: textToCopy));
                  
                  // 스낵바로 피드백 제공
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        AppLocalizations.of(context)!.messageCopied,
                        style: const TextStyle(fontSize: 14),
                      ),
                      duration: const Duration(seconds: 1),
                      backgroundColor: Colors.grey[800],
                      behavior: SnackBarBehavior.floating,
                      margin: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  );
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutCubic,
                  decoration: BoxDecoration(
                  gradient: isFromUser
                      ? AppTheme.primaryGradient
                      : null,
                  color: isFromUser
                      ? null
                      : MessageBubble._aiBubbleColor,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(24),
                    topRight: const Radius.circular(24),
                    bottomLeft: Radius.circular(isFromUser ? 24 : 8),
                    bottomRight: Radius.circular(isFromUser ? 8 : 24),
                  ),
                  boxShadow: isFromUser
                      ? [
                          BoxShadow(
                            color: AppTheme.primaryColor.withOpacity(0.25),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ]
                      : AppTheme.softShadow,
                  border: isFromUser
                      ? null
                      : Border.all(
                          color: Colors.grey.withOpacity(0.1),
                          width: 1,
                        ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 번역이 있는 메시지
                      if (!isFromUser && 
                          widget.message.translatedContent != null && 
                          widget.message.translatedContent!.isNotEmpty) ...[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 한국어 원문 (토글 상태와 관계없이 항상 일반 스타일)
                            if (!_showTranslation) ...[
                              Stack(
                                children: [
                                  // 한국어 메시지 텍스트
                                  Padding(
                                    padding: const EdgeInsets.only(right: 30),
                                    child: Text(
                                      widget.message.content,
                                      style: _TextMessage._aiTextStyle,
                                    ),
                                  ),
                                  // 번역 인디케이터 아이콘 (우측 상단)
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: Icon(
                                      Icons.language,
                                      size: 16,
                                      color: Colors.grey[400],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            // 번역 모드 (회색 배경)
                            if (_showTranslation) ...[
                              Stack(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      widget.message.translatedContent!,
                                      style: TextStyle(
                                        color: Colors.grey[700],
                                        fontSize: 16,
                                        height: 1.4,
                                      ),
                                    ),
                                  ),
                                  // 번역 인디케이터 아이콘 (우측 상단)
                                  Positioned(
                                    top: 4,
                                    right: 8,
                                    child: Icon(
                                      Icons.language,
                                      size: 16,
                                      color: AppTheme.primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              // 원문 표시 (작은 글씨)
                              Text(
                                '원문: ${widget.message.content}',
                                style: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 12,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ] else ...[
                        // 번역이 없는 일반 메시지
                        Text(
                          widget.message.content,
                          style: isFromUser ? _TextMessage._userTextStyle : _TextMessage._aiTextStyle,
                        ),
                      ],
                      const SizedBox(height: 4),
                      _TimeAndScore(
                        message: widget.message,
                        isFromUser: isFromUser,
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
    );
  }
}

// Separate widget for time and score to optimize rebuilds
class _TimeAndScore extends StatelessWidget {
  final Message message;
  final bool isFromUser;

  const _TimeAndScore({
    required this.message,
    required this.isFromUser,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          MessageBubble._timeFormat.format(message.timestamp),
          style: TextStyle(
            color: isFromUser 
                ? Colors.white70 
                : Colors.grey[600],
            fontSize: 12,
          ),
        ),
        
        // Read status for user messages
        if (isFromUser) ...[
          const SizedBox(width: 4),
          Icon(
            message.isRead ? Icons.done_all : Icons.done,
            size: 14,
            color: message.isRead ? Colors.green : Colors.white54,
          ),
        ],
      ],
    );
  }
}

// System message widget
class _SystemMessage extends StatelessWidget {
  final Message message;

  const _SystemMessage({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: AppTheme.backgroundColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.grey.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.info_outline_rounded,
                size: 16,
                color: Colors.grey[500],
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  message.content,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Story event message widget
class _StoryEventMessage extends StatelessWidget {
  final Message message;

  const _StoryEventMessage({required this.message});

  @override
  Widget build(BuildContext context) {
    final choices = message.metadata?['choices'] as List<dynamic>?;
    
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryColor.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.primaryColor.withOpacity(0.05),
                AppTheme.secondaryColor.withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.auto_stories,
                    color: Color(0xFFFF6B9D),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    AppLocalizations.of(context)!.storyEvent,
                    style: const TextStyle(
                      color: Color(0xFFFF6B9D),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              Text(
                message.content,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                  height: 1.4,
                ),
              ),
              
              if (choices != null && choices.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  AppLocalizations.of(context)!.chooseOption,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                
                ...choices.asMap().entries.map((entry) {
                  final index = entry.key;
                  final choice = entry.value;
                  
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          // Handle choice
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFFFF6B9D),
                          side: const BorderSide(color: Color(0xFFFF6B9D)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text(
                          '${index + 1}. ${choice['text']}',
                          style: const TextStyle(fontSize: 14),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                  );
                }),
              ],
              
              const SizedBox(height: 8),
              Text(
                MessageBubble._timeFormat.format(message.timestamp),
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Emotion message widget
class _EmotionMessage extends StatelessWidget {
  final Message message;
  
  static const _containerColor = Color(0x1AFF6B9D); // Pre-calculated alpha

  const _EmotionMessage({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: _containerColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            message.content,
            style: const TextStyle(
              color: Color(0xFFFF6B9D),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

// Profile avatar widget for messages
class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar();
  
  @override
  Widget build(BuildContext context) {
    // AI Persona avatar with click functionality
    return Consumer<PersonaService>(
      builder: (context, personaService, child) {
        final persona = personaService.currentPersona;
        final thumbnailUrl = persona?.getThumbnailUrl();
        
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: persona != null
                ? () => _showPersonaProfile(context, persona)
                : null,
            customBorder: const CircleBorder(),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[200],
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipOval(
                child: thumbnailUrl != null && thumbnailUrl.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: thumbnailUrl,
                        fit: BoxFit.cover,
                        memCacheWidth: 72,
                        memCacheHeight: 72,
                        placeholder: (context, url) => Container(
                          color: Colors.grey[200],
                          child: const Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Color(0xFFFF6B9D),
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => _buildDefaultAvatar(),
                      )
                    : _buildDefaultAvatar(),
              ),
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildDefaultAvatar() {
    return Container(
      color: Colors.grey[200],
      child: const Icon(
        Icons.person,
        color: Color(0xFFFF6B9D),
        size: 20,
      ),
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