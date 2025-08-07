import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../services/ui/haptic_service.dart';

/// Modern emoji reaction picker with beautiful animations
/// Similar to iMessage/Instagram reaction system
class MessageReactionPicker extends StatefulWidget {
  final Function(String) onReactionSelected;
  final VoidCallback onDismiss;
  final Offset position;
  
  const MessageReactionPicker({
    super.key,
    required this.onReactionSelected,
    required this.onDismiss,
    required this.position,
  });
  
  @override
  State<MessageReactionPicker> createState() => _MessageReactionPickerState();
}

class _MessageReactionPickerState extends State<MessageReactionPicker>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _itemController;
  late Animation<double> _scaleAnimation;
  late List<Animation<double>> _itemAnimations;
  
  static const List<String> reactions = ['❤️', '👍', '😂', '😮', '😢', '🔥'];
  
  @override
  void initState() {
    super.initState();
    
    // Main scale animation
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeOutBack,
    ));
    
    // Individual item animations
    _itemController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    
    _itemAnimations = List.generate(reactions.length, (index) {
      return Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: _itemController,
        curve: Interval(
          index * 0.1,
          0.5 + index * 0.1,
          curve: Curves.elasticOut,
        ),
      ));
    });
    
    _scaleController.forward();
    _itemController.forward();
    
    // Light haptic feedback on show
    HapticService.lightImpact();
  }
  
  @override
  void dispose() {
    _scaleController.dispose();
    _itemController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onDismiss,
      behavior: HitTestBehavior.translucent,
      child: Material(
        color: Colors.transparent,
        child: Stack(
          children: [
            Positioned(
              left: widget.position.dx - 150,
              top: widget.position.dy - 70,
              child: AnimatedBuilder(
                animation: _scaleController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Container(
                      width: 300,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(reactions.length, (index) {
                          return AnimatedBuilder(
                            animation: _itemAnimations[index],
                            builder: (context, child) {
                              return Transform.scale(
                                scale: _itemAnimations[index].value,
                                child: _ReactionButton(
                                  emoji: reactions[index],
                                  onTap: () {
                                    HapticService.selectionClick();
                                    widget.onReactionSelected(reactions[index]);
                                  },
                                ),
                              );
                            },
                          );
                        }),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReactionButton extends StatefulWidget {
  final String emoji;
  final VoidCallback onTap;
  
  const _ReactionButton({
    required this.emoji,
    required this.onTap,
  });
  
  @override
  State<_ReactionButton> createState() => _ReactionButtonState();
}

class _ReactionButtonState extends State<_ReactionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _hoverAnimation;
  bool _isHovered = false;
  
  @override
  void initState() {
    super.initState();
    
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _hoverAnimation = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeInOut,
    ));
  }
  
  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _isHovered = true;
        });
        _hoverController.forward();
      },
      onTapUp: (_) {
        setState(() {
          _isHovered = false;
        });
        _hoverController.reverse();
        widget.onTap();
      },
      onTapCancel: () {
        setState(() {
          _isHovered = false;
        });
        _hoverController.reverse();
      },
      child: AnimatedBuilder(
        animation: _hoverAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _hoverAnimation.value,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _isHovered 
                    ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                    : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  widget.emoji,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Animated reaction display on message
class MessageReaction extends StatefulWidget {
  final String emoji;
  final int count;
  final bool isFromUser;
  final VoidCallback? onTap;
  
  const MessageReaction({
    super.key,
    required this.emoji,
    required this.count,
    required this.isFromUser,
    this.onTap,
  });
  
  @override
  State<MessageReaction> createState() => _MessageReactionState();
}

class _MessageReactionState extends State<MessageReaction>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _bounceAnimation;
  
  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
    ));
    
    _bounceAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.9),
        weight: 25.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.9, end: 1.1),
        weight: 25.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.1, end: 0.95),
        weight: 25.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.95, end: 1.0),
        weight: 25.0,
      ),
    ]).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.6, 1.0, curve: Curves.easeInOut),
    ));
    
    _animationController.forward();
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
        return Transform.scale(
          scale: _scaleAnimation.value * _bounceAnimation.value,
          child: GestureDetector(
            onTap: widget.onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: widget.isFromUser
                    ? Colors.white.withOpacity(0.2)
                    : Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: widget.isFromUser
                      ? Colors.white.withOpacity(0.3)
                      : Theme.of(context).colorScheme.primary.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.emoji,
                    style: const TextStyle(fontSize: 16),
                  ),
                  if (widget.count > 1) ...[
                    const SizedBox(width: 4),
                    Text(
                      widget.count.toString(),
                      style: TextStyle(
                        fontSize: 12,
                        color: widget.isFromUser
                            ? Colors.white
                            : Theme.of(context).textTheme.bodySmall?.color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}