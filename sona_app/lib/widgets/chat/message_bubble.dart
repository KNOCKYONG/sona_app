import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/message.dart';
import '../../models/persona.dart';
import '../../services/persona/persona_service.dart';
import '../../services/chat/core/chat_service.dart';
import '../../services/auth/auth_service.dart';
import '../../services/ui/haptic_service.dart';
import '../../theme/app_theme.dart';
import '../persona/persona_profile_viewer.dart';
import '../../l10n/app_localizations.dart';
import '../../utils/localization_helper.dart';

/// Optimized MessageBubble with performance improvements:
/// - Const constructors where possible
/// - Removed unnecessary animations for simple messages
/// - Cached DateFormat instance
/// - Reduced widget rebuilds with const widgets
/// - Optimized shadow rendering
class MessageBubble extends StatelessWidget {
  final Message message;
  final VoidCallback? onScoreChange;

  // Removed static DateFormat - now using LocalizationHelper

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

  // 번역 컨텐츠에서 언어 태그 및 한글 제거
  String _extractTranslatedContent(String content) {
    // [EN], [JA] 등의 태그가 있으면 태그 이후 부분만 추출
    final tagPattern = RegExp(r'\[(EN|JA|ZH|ES|FR|DE|IT|PT|RU|AR|TH|ID|MS|VI)\]');
    final match = tagPattern.firstMatch(content);
    if (match != null) {
      final tagEnd = match.end;
      var translatedText = content.substring(tagEnd).trim();
      
      // [KO] 태그가 있으면 그 전까지만
      final koIndex = translatedText.indexOf('[KO]');
      if (koIndex != -1) {
        translatedText = translatedText.substring(0, koIndex).trim();
      }
      
      // 한글이 포함되어 있으면 제거
      final koreanPattern = RegExp(r'[ᄀ-ᇿ㄰-㆏가-힣]+');
      if (koreanPattern.hasMatch(translatedText)) {
        // 한글 이전까지만 추출
        final koreanMatch = koreanPattern.firstMatch(translatedText);
        if (koreanMatch != null && koreanMatch.start > 0) {
          translatedText = translatedText.substring(0, koreanMatch.start).trim();
        }
      }
      
      return translatedText;
    }
    
    // 태그가 없어도 한글이 포함되어 있으면 제거
    final koreanPattern = RegExp(r'[ᄀ-ᇿ㄰-㆏가-힣]+');
    if (koreanPattern.hasMatch(content)) {
      // [KO] 태그가 있으면 그 전까지만
      final koTagIndex = content.indexOf('[KO]');
      if (koTagIndex != -1) {
        return content.substring(0, koTagIndex).trim();
      }
      
      // 한글 이전까지만 추출
      final koreanMatch = koreanPattern.firstMatch(content);
      if (koreanMatch != null && koreanMatch.start > 0) {
        return content.substring(0, koreanMatch.start).trim();
      }
    }
    
    return content;
  }

  // [KO] 태그가 있는 경우 한국어 부분만 추출
  String _extractKoreanContent(String content) {
    // [KO] 태그가 있는지 확인
    if (content.contains('[KO]')) {
      final koIndex = content.indexOf('[KO]');
      var koreanStart = koIndex + 4; // '[KO]'.length = 4
      
      // 다른 언어 태그가 있으면 그 전까지만 추출
      var koreanEnd = content.length;
      final possibleTags = ['[EN]', '[JA]', '[ZH]', '[ES]', '[FR]', '[DE]', '[IT]', '[PT]', '[RU]', '[AR]', '[TH]', '[ID]', '[MS]', '[VI]'];
      for (final tag in possibleTags) {
        final tagIndex = content.indexOf(tag, koreanStart);
        if (tagIndex != -1 && tagIndex < koreanEnd) {
          koreanEnd = tagIndex;
        }
      }
      
      return content.substring(koreanStart, koreanEnd).trim();
    }
    
    // [KO] 태그가 없으면 원본 반환
    return content;
  }

  String _getLanguageName(String languageCode) {
    switch (languageCode) {
      case 'en':
        return 'English';
      case 'ja':
        return '日本語';
      case 'zh':
        return '中文';
      case 'id':
        return 'Bahasa Indonesia';
      case 'ms':
        return 'Bahasa Melayu';
      case 'vi':
        return 'Tiếng Việt';
      case 'es':
        return 'Español';
      case 'fr':
        return 'Français';
      case 'de':
        return 'Deutsch';
      case 'it':
        return 'Italiano';
      case 'pt':
        return 'Português';
      case 'ru':
        return 'Русский';
      case 'ar':
        return 'العربية';
      case 'th':
        return 'ไทย';
      case 'ko':
      default:
        return AppLocalizations.of(context)!.koreanLanguage;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isFromUser = widget.message.isFromUser;
    final maxWidth = MediaQuery.of(context).size.width * 0.75;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment:
            isFromUser ? MainAxisAlignment.end : MainAxisAlignment.start,
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
                onLongPress: () async {
                  // Medium haptic for copy action
                  await HapticService.mediumImpact();
                  
                  // 메시지 내용을 클립보드에 복사
                  final textToCopy = _showTranslation &&
                          widget.message.translatedContent != null
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
                child: IntrinsicHeight(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutCubic,
                    decoration: BoxDecoration(
                      gradient: isFromUser ? AppTheme.primaryGradient : null,
                      color: isFromUser ? null : MessageBubble._aiBubbleColor,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(24),
                        topRight: const Radius.circular(24),
                        bottomLeft: Radius.circular(isFromUser ? 24 : 8),
                        bottomRight: Radius.circular(isFromUser ? 8 : 24),
                      ),
                      boxShadow: isFromUser
                          ? [
                              BoxShadow(
                                color: const Color(0xFFFF8FAD).withOpacity(0.20),
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
                    child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                        // 답장 정보 표시
                        if (widget.message.metadata != null && 
                            widget.message.metadata!['replyTo'] != null) ...[
                          Container(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: isFromUser 
                                    ? Colors.white.withOpacity(0.15)
                                    : Colors.grey.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border(
                                  left: BorderSide(
                                    color: widget.message.metadata!['replyTo']['isFromUser'] == true
                                        ? AppTheme.primaryColor
                                        : AppTheme.secondaryColor,
                                    width: 2,
                                  ),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    widget.message.metadata!['replyTo']['senderName'] ?? '',
                                    style: TextStyle(
                                      color: isFromUser ? Colors.white70 : Colors.grey[600],
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    widget.message.metadata!['replyTo']['content'] ?? '',
                                    style: TextStyle(
                                      color: isFromUser ? Colors.white60 : Colors.grey[500],
                                      fontSize: 12,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                        // 번역이 있는 메시지 (실제 번역이 있고, 유효한 번역일 때만 표시)
                        if (!isFromUser &&
                            widget.message.translatedContent != null &&
                            widget.message.translatedContent!.isNotEmpty &&
                            !widget.message.translatedContent!.contains('[Translation processing...]')) ...[
                          // 전체 메시지를 감싸는 GestureDetector
                          GestureDetector(
                            onTap: () async {
                              // Light haptic for translation toggle
                              await HapticService.selectionClick();
                              setState(() {
                                _showTranslation = !_showTranslation;
                              });
                            },
                            child: AnimatedSize(
                              duration: const Duration(milliseconds: 250),
                              curve: Curves.easeInOutCubic,
                              alignment: Alignment.topLeft,
                              clipBehavior: Clip.none,
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 200),
                                switchInCurve: Curves.easeIn,
                                switchOutCurve: Curves.easeOut,
                                child: Column(
                                  key: ValueKey(_showTranslation),
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                  // 한국어 원문 (토글 상태와 관계없이 항상 일반 스타일)
                                  if (!_showTranslation) ...[
                                    Stack(
                                      children: [
                                        // 한국어 메시지 텍스트 (태그 제거 처리)
                                        Padding(
                                          padding: const EdgeInsets.only(right: 35),
                                          child: Text(
                                            _extractKoreanContent(widget.message.content),
                                            style: _TextMessage._aiTextStyle,
                                            softWrap: true,
                                            textAlign: TextAlign.left,
                                          ),
                                        ),
                                        // 번역 아이콘 표시 (우측 상단) - 시각적 표시용
                                        Positioned(
                                          top: -4,
                                          right: -4,
                                          child: Container(
                                            padding: const EdgeInsets.all(4),
                                            child: Icon(
                                              Icons.language,
                                              size: 18,
                                              color: Theme.of(context).colorScheme.primary.withOpacity(0.6),
                                            ),
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
                                          padding: const EdgeInsets.only(
                                            left: 12,
                                            right: 35,
                                            top: 8,
                                            bottom: 8,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.blue.withOpacity(0.08),
                                            borderRadius: BorderRadius.circular(12),
                                            border: Border.all(
                                              color: Colors.blue.withOpacity(0.2),
                                              width: 1,
                                            ),
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              // 번역된 텍스트 (태그 제거 및 한글 제외)
                                              Text(
                                                _extractTranslatedContent(widget.message.translatedContent!),
                                                style: TextStyle(
                                                  color: Colors.blue[900],
                                                  fontSize: 16,
                                                  height: 1.4,
                                                ),
                                                softWrap: true,
                                                textAlign: TextAlign.left,
                                              ),
                                            ],
                                          ),
                                        ),
                                        // 지구본 아이콘 표시 (우측 상단) - 시각적 표시용
                                        Positioned(
                                          top: -4,
                                          right: -4,
                                          child: Container(
                                            padding: const EdgeInsets.all(4),
                                            child: Icon(
                                              Icons.language,
                                              size: 18,
                                              color: Colors.blue.withOpacity(0.8),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ],
                                ),
                              ),
                            ),
                          ),
                        ] else ...[
                          // 번역이 없는 일반 메시지 (태그 제거 처리)
                          Text(
                            isFromUser ? widget.message.content : _extractKoreanContent(widget.message.content),
                            style: isFromUser
                                ? _TextMessage._userTextStyle
                                : _TextMessage._aiTextStyle,
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
                      // 전송 실패 시 재시도 버튼
                      if (widget.message.hasFailed && isFromUser)
                        Positioned(
                          bottom: 4,
                          right: 4,
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () async {
                                await HapticService.lightImpact();
                                // 재시도 로직 호출
                                final chatService = Provider.of<ChatService>(context, listen: false);
                                final personaService = Provider.of<PersonaService>(context, listen: false);
                                final authService = Provider.of<AuthService>(context, listen: false);
                                
                                if (personaService.currentPersona != null) {
                                  await chatService.retryMessage(
                                    message: widget.message,
                                    userId: authService.user?.uid ?? '',
                                    persona: personaService.currentPersona!,
                                  );
                                }
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.9),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.refresh,
                                      size: 14,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 3),
                                    Text(
                                      AppLocalizations.of(context)!.retryButton,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(width: 2),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      // 전송 중 표시기
                      if (widget.message.isSending && isFromUser)
                        Positioned(
                          bottom: 4,
                          right: 4,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            child: SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(
                                strokeWidth: 1.5,
                                color: Colors.white.withOpacity(0.7),
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
          ), // Closing parenthesis for Flexible widget at line 220
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
    // Show relative time if message is less than 1 hour old
    final now = DateTime.now();
    final difference = now.difference(message.timestamp);
    final String timeText;
    
    if (difference.inMinutes < 60) {
      final locale = Localizations.localeOf(context);
      timeText = LocalizationHelper.formatRelativeTime(message.timestamp, locale);
    } else {
      final locale = Localizations.localeOf(context);
      timeText = LocalizationHelper.formatTimeShort(message.timestamp, locale);
    }
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          timeText,
          style: TextStyle(
            color: isFromUser ? Colors.white70 : Colors.grey[600],
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
                LocalizationHelper.formatTimeShort(message.timestamp, Localizations.localeOf(context)),
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
                ? () async {
                    // Light haptic for avatar tap
                    await HapticService.lightImpact();
                    _showPersonaProfile(context, persona);
                  }
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
                        errorWidget: (context, url, error) =>
                            _buildDefaultAvatar(),
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
