import 'package:flutter/material.dart';

class AnimatedActionButton extends StatefulWidget {
  final VoidCallback? onTap;
  final double size;
  final List<Color> gradientColors;
  final Color shadowColor;
  final IconData icon;
  final double iconSize;
  final bool isLoading;
  final String tooltip;

  const AnimatedActionButton({
    super.key,
    required this.onTap,
    required this.size,
    required this.gradientColors,
    required this.shadowColor,
    required this.icon,
    required this.iconSize,
    this.isLoading = false,
    this.tooltip = '',
  });

  @override
  State<AnimatedActionButton> createState() => _AnimatedActionButtonState();
}

class _AnimatedActionButtonState extends State<AnimatedActionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _shadowAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _shadowAnimation = Tween<double>(
      begin: 1.0,
      end: 0.6,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    Widget button = AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: widget.gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: widget.shadowColor
                      .withOpacity(0.4 * _shadowAnimation.value),
                  blurRadius: 15 * _shadowAnimation.value,
                  offset: Offset(0, 8 * _shadowAnimation.value),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(widget.size / 2),
                onTap: widget.onTap,
                onTapDown: _handleTapDown,
                onTapUp: _handleTapUp,
                onTapCancel: _handleTapCancel,
                splashColor: Colors.white.withOpacity(0.3),
                highlightColor: Colors.white.withOpacity(0.1),
                child: Center(
                  child: widget.isLoading
                      ? SizedBox(
                          width: widget.iconSize * 0.8,
                          height: widget.iconSize * 0.8,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : TweenAnimationBuilder<double>(
                          duration: const Duration(milliseconds: 300),
                          tween: Tween(begin: 0, end: _isPressed ? 1 : 0),
                          builder: (context, value, child) {
                            return Transform.rotate(
                              angle: value * 0.1,
                              child: Icon(
                                widget.icon,
                                color: Colors.white,
                                size: widget.iconSize,
                              ),
                            );
                          },
                        ),
                ),
              ),
            ),
          ),
        );
      },
    );

    if (widget.tooltip.isNotEmpty) {
      return Tooltip(
        message: widget.tooltip,
        child: button,
      );
    }

    return button;
  }
}
