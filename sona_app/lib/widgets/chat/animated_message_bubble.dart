import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';
import '../../models/message.dart';
import 'message_bubble.dart';
import 'message_reaction_picker.dart';
import '../../services/ui/haptic_service.dart';

/// Animated wrapper for message bubbles with slide-in and bounce effects
/// Provides WhatsApp/Telegram-level animations for better UX
class AnimatedMessageBubble extends StatefulWidget {
  final Message message;
  final VoidCallback? onScoreChange;
  final bool isNewMessage;
  final int index;
  
  const AnimatedMessageBubble({
    super.key,
    required this.message,
    this.onScoreChange,
    this.isNewMessage = false,
    this.index = 0,
  });

  @override
  State<AnimatedMessageBubble> createState() => _AnimatedMessageBubbleState();
}

class _AnimatedMessageBubbleState extends State<AnimatedMessageBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  
  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: Duration(milliseconds: widget.isNewMessage ? 400 : 300),
      vsync: this,
    );
    
    // Slide animation - messages slide in from side
    _slideAnimation = Tween<double>(
      begin: widget.message.isFromUser ? 50.0 : -50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    
    // Fade animation
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));
    
    // Scale animation for bounce effect (new messages only)
    if (widget.isNewMessage) {
      _scaleAnimation = TweenSequence<double>([
        TweenSequenceItem(
          tween: Tween<double>(begin: 0.0, end: 1.1)
              .chain(CurveTween(curve: Curves.easeOut)),
          weight: 70.0,
        ),
        TweenSequenceItem(
          tween: Tween<double>(begin: 1.1, end: 0.95)
              .chain(CurveTween(curve: Curves.easeInOut)),
          weight: 15.0,
        ),
        TweenSequenceItem(
          tween: Tween<double>(begin: 0.95, end: 1.0)
              .chain(CurveTween(curve: Curves.easeOut)),
          weight: 15.0,
        ),
      ]).animate(_animationController);
    } else {
      _scaleAnimation = Tween<double>(
        begin: 0.95,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack,
      ));
    }
    
    // Stagger animation for multiple messages
    Future.delayed(Duration(milliseconds: widget.index * 50), () {
      if (mounted) {
        _animationController.forward();
      }
    });
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_slideAnimation.value, 0),
          child: Transform.scale(
            scale: _scaleAnimation.value,
            alignment: widget.message.isFromUser 
                ? Alignment.centerRight 
                : Alignment.centerLeft,
            child: Opacity(
              opacity: _fadeAnimation.value,
              child: MessageBubble(
                message: widget.message,
                onScoreChange: widget.onScoreChange,
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Swipeable message wrapper for reply functionality
class SwipeableMessageBubble extends StatefulWidget {
  final Message message;
  final VoidCallback? onScoreChange;
  final Function(Message) onSwipeReply;
  final Function(Message, String) onReaction;
  final bool isNewMessage;
  final int index;
  
  const SwipeableMessageBubble({
    super.key,
    required this.message,
    this.onScoreChange,
    required this.onSwipeReply,
    required this.onReaction,
    this.isNewMessage = false,
    this.index = 0,
  });
  
  @override
  State<SwipeableMessageBubble> createState() => _SwipeableMessageBubbleState();
}

class _SwipeableMessageBubbleState extends State<SwipeableMessageBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _swipeController;
  late Animation<double> _swipeAnimation;
  double _dragExtent = 0.0;
  bool _isSwipeActive = false;
  
  @override
  void initState() {
    super.initState();
    
    _swipeController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _swipeAnimation = Tween<double>(
      begin: 0.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _swipeController,
      curve: Curves.easeOut,
    ));
  }
  
  @override
  void dispose() {
    _swipeController.dispose();
    super.dispose();
  }
  
  void _handleHorizontalDragUpdate(DragUpdateDetails details) {
    setState(() {
      // Only allow swipe right for AI messages, left for user messages
      if (widget.message.isFromUser) {
        _dragExtent = details.primaryDelta! < 0 
            ? (_dragExtent + details.primaryDelta!).clamp(-80.0, 0.0)
            : 0.0;
      } else {
        _dragExtent = details.primaryDelta! > 0
            ? (_dragExtent + details.primaryDelta!).clamp(0.0, 80.0)
            : 0.0;
      }
      
      // Activate reply when threshold reached
      if (_dragExtent.abs() > 60 && !_isSwipeActive) {
        _isSwipeActive = true;
        // Haptic feedback for swipe threshold
        HapticFeedback.mediumImpact();
      } else if (_dragExtent.abs() <= 60 && _isSwipeActive) {
        _isSwipeActive = false;
      }
    });
  }
  
  void _handleHorizontalDragEnd(DragEndDetails details) {
    if (_isSwipeActive) {
      // Trigger reply action
      widget.onSwipeReply(widget.message);
      
      // Bounce back animation
      _swipeAnimation = Tween<double>(
        begin: _dragExtent,
        end: 0.0,
      ).animate(CurvedAnimation(
        parent: _swipeController,
        curve: Curves.elasticOut,
      ));
      
      _swipeController.forward(from: 0.0).then((_) {
        setState(() {
          _dragExtent = 0.0;
          _isSwipeActive = false;
        });
      });
    } else {
      // Spring back animation
      _swipeAnimation = Tween<double>(
        begin: _dragExtent,
        end: 0.0,
      ).animate(CurvedAnimation(
        parent: _swipeController,
        curve: Curves.easeOut,
      ));
      
      _swipeController.forward(from: 0.0).then((_) {
        setState(() {
          _dragExtent = 0.0;
        });
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: _handleHorizontalDragUpdate,
      onHorizontalDragEnd: _handleHorizontalDragEnd,
      // Long press removed - translation is priority
      child: Stack(
        children: [
          // Reply icon that appears when swiping
          if (_dragExtent != 0)
            Positioned(
              left: widget.message.isFromUser ? null : 16,
              right: widget.message.isFromUser ? 16 : null,
              top: 0,
              bottom: 0,
              child: AnimatedOpacity(
                opacity: _dragExtent.abs() / 80.0,
                duration: const Duration(milliseconds: 100),
                child: AnimatedScale(
                  scale: _isSwipeActive ? 1.2 : 1.0,
                  duration: const Duration(milliseconds: 100),
                  child: Container(
                    alignment: Alignment.center,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.reply_rounded,
                        color: Theme.of(context).colorScheme.primary,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          
          // The actual message bubble
          AnimatedBuilder(
            animation: _swipeController,
            builder: (context, child) {
              final offset = _swipeController.isAnimating 
                  ? _swipeAnimation.value 
                  : _dragExtent;
              
              return Transform.translate(
                offset: Offset(offset, 0),
                child: AnimatedMessageBubble(
                  message: widget.message,
                  onScoreChange: widget.onScoreChange,
                  isNewMessage: widget.isNewMessage,
                  index: widget.index,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}