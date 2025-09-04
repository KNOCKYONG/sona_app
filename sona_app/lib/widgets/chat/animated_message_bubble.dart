import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';
import '../../models/message.dart';
import 'message_bubble.dart';
import 'message_reaction_picker.dart';
import '../../services/ui/haptic_service.dart';

/// Optimized animated wrapper for message bubbles with smooth transitions
/// Provides elegant animations for better UX without performance issues
class AnimatedMessageBubble extends StatefulWidget {
  final Message message;
  final VoidCallback? onScoreChange;
  final bool isNewMessage;
  final int index;
  final bool alwaysShowTranslation;
  
  const AnimatedMessageBubble({
    super.key,
    required this.message,
    this.onScoreChange,
    this.isNewMessage = false,
    this.index = 0,
    this.alwaysShowTranslation = false,
  });

  @override
  State<AnimatedMessageBubble> createState() => _AnimatedMessageBubbleState();
}

class _AnimatedMessageBubbleState extends State<AnimatedMessageBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: widget.isNewMessage 
          ? const Duration(milliseconds: 350)  // Smooth animation for new messages
          : Duration.zero,  // No animation for existing messages
      vsync: this,
    );
    
    // Fade animation - gentle fade in
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
    
    // Slide animation - subtle slide from bottom
    _slideAnimation = Tween<Offset>(
      begin: widget.isNewMessage 
          ? const Offset(0, 0.1)  // Very subtle slide from bottom
          : Offset.zero,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));
    
    // Start animation for new messages
    if (widget.isNewMessage) {
      _controller.forward();
    } else {
      _controller.value = 1.0;
    }
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    if (!widget.isNewMessage) {
      // Return without animation for existing messages
      return MessageBubble(
        message: widget.message,
        onScoreChange: widget.onScoreChange,
        alwaysShowTranslation: widget.alwaysShowTranslation,
      );
    }
    
    // Animated version for new messages
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: MessageBubble(
          message: widget.message,
          onScoreChange: widget.onScoreChange,
          alwaysShowTranslation: widget.alwaysShowTranslation,
        ),
      ),
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
  final bool alwaysShowTranslation;
  
  const SwipeableMessageBubble({
    super.key,
    required this.message,
    this.onScoreChange,
    required this.onSwipeReply,
    required this.onReaction,
    this.isNewMessage = false,
    this.index = 0,
    this.alwaysShowTranslation = false,
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
                  alwaysShowTranslation: widget.alwaysShowTranslation,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}