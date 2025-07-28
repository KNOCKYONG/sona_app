import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/message.dart';
import '../common/emotion_indicator.dart';
import '../../services/purchase/subscription_service.dart';
import '../../theme/app_theme.dart';

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
    if (message.relationshipScoreChange != null && 
        message.relationshipScoreChange != 0 &&
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
class _TextMessage extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final isFromUser = message.isFromUser;
    final maxWidth = MediaQuery.of(context).size.width * 0.75;
    
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: isFromUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isFromUser && _shouldShowEmotion) ...[
            Padding(
              padding: const EdgeInsets.only(right: 8, bottom: 8),
              child: EmotionIndicator(
                emotion: message.emotion!,
                size: 24,
              ),
            ),
          ],
          
          // Modern message bubble with gradient and soft shadows
          Flexible(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
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
                      Text(
                        message.content,
                        style: isFromUser ? _userTextStyle : _aiTextStyle,
                      ),
                      const SizedBox(height: 4),
                      _TimeAndScore(
                        message: message,
                        isFromUser: isFromUser,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool get _shouldShowEmotion =>
      message.emotion != null && 
      message.relationshipScoreChange != null &&
      message.relationshipScoreChange!.abs() >= 3;
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
        
        // Score change (only rebuild this part when subscription changes)
        Consumer<SubscriptionService>(
          builder: (context, subscriptionService, child) {
            if (!subscriptionService.canShowIntimacyScore ||
                message.relationshipScoreChange == null ||
                message.relationshipScoreChange == 0) {
              return const SizedBox.shrink();
            }
            
            final scoreChange = message.relationshipScoreChange!;
            final isPositive = scoreChange > 0;
            
            return Padding(
              padding: const EdgeInsets.only(left: 8),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: isPositive
                      ? AppTheme.successColor.withOpacity(0.15)
                      : AppTheme.errorColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isPositive
                            ? Icons.favorite_rounded
                            : Icons.heart_broken_rounded,
                        size: 12,
                        color: isPositive
                            ? AppTheme.successColor
                            : AppTheme.errorColor,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '${isPositive ? '+' : ''}$scoreChange',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: isPositive
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
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
              const Row(
                children: [
                  Icon(
                    Icons.auto_stories,
                    color: Color(0xFFFF6B9D),
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    '스토리 이벤트',
                    style: TextStyle(
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
                const Text(
                  '선택하세요:',
                  style: TextStyle(
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
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (message.emotion != null)
                EmotionIndicator(
                  emotion: message.emotion!,
                  size: 20,
                ),
              const SizedBox(width: 8),
              Text(
                message.content,
                style: const TextStyle(
                  color: Color(0xFFFF6B9D),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}