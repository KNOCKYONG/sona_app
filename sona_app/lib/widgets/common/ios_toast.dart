import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../services/ui/haptic_service.dart';

/// iOS-style toast notification widget
/// Features: Blur background, smooth animations, haptic feedback
class IOSToast {
  static void show({
    required BuildContext context,
    required String message,
    IOSToastType type = IOSToastType.info,
    Duration duration = const Duration(seconds: 3),
    IconData? icon,
    VoidCallback? onTap,
  }) {
    _showToast(
      context: context,
      message: message,
      type: type,
      duration: duration,
      icon: icon,
      onTap: onTap,
    );
  }

  static void _showToast({
    required BuildContext context,
    required String message,
    required IOSToastType type,
    required Duration duration,
    IconData? icon,
    VoidCallback? onTap,
  }) async {
    // Haptic feedback based on toast type
    switch (type) {
      case IOSToastType.success:
        await HapticService.success();
        break;
      case IOSToastType.error:
        await HapticService.error();
        break;
      case IOSToastType.warning:
        await HapticService.warning();
        break;
      case IOSToastType.info:
        await HapticService.lightImpact();
        break;
    }

    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => _IOSToastWidget(
        message: message,
        type: type,
        duration: duration,
        icon: icon,
        onTap: onTap,
      ),
    );

    overlay.insert(overlayEntry);

    // Remove after duration
    Future.delayed(duration, () {
      overlayEntry.remove();
    });
  }
}

enum IOSToastType {
  success,
  error,
  warning,
  info,
}

class _IOSToastWidget extends StatefulWidget {
  final String message;
  final IOSToastType type;
  final Duration duration;
  final IconData? icon;
  final VoidCallback? onTap;

  const _IOSToastWidget({
    required this.message,
    required this.type,
    required this.duration,
    this.icon,
    this.onTap,
  });

  @override
  State<_IOSToastWidget> createState() => _IOSToastWidgetState();
}

class _IOSToastWidgetState extends State<_IOSToastWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));

    _animationController.forward();

    // Auto dismiss animation
    Future.delayed(widget.duration - const Duration(milliseconds: 400), () {
      if (mounted) {
        _animationController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Color _getBackgroundColor() {
    switch (widget.type) {
      case IOSToastType.success:
        return Colors.green.withOpacity(0.95);
      case IOSToastType.error:
        return Colors.red.withOpacity(0.95);
      case IOSToastType.warning:
        return Colors.orange.withOpacity(0.95);
      case IOSToastType.info:
        return const Color(0xFF2196F3).withOpacity(0.95);
    }
  }

  IconData _getIcon() {
    if (widget.icon != null) return widget.icon!;
    
    switch (widget.type) {
      case IOSToastType.success:
        return Icons.check_circle_rounded;
      case IOSToastType.error:
        return Icons.error_rounded;
      case IOSToastType.warning:
        return Icons.warning_rounded;
      case IOSToastType.info:
        return Icons.info_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final safeAreaPadding = MediaQuery.of(context).padding;
    
    return Positioned(
      top: safeAreaPadding.top + 10,
      left: 16,
      right: 16,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: GestureDetector(
              onTap: widget.onTap != null
                  ? () async {
                      await HapticService.lightImpact();
                      widget.onTap!();
                    }
                  : null,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: _getBackgroundColor(),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getIcon(),
                      color: Colors.white,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        widget.message,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ),
                    if (widget.onTap != null) ...[
                      const SizedBox(width: 8),
                      Icon(
                        Icons.chevron_right,
                        color: Colors.white.withOpacity(0.8),
                        size: 20,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Extension for easy access
extension IOSToastExtension on BuildContext {
  void showIOSToast(
    String message, {
    IOSToastType type = IOSToastType.info,
    Duration duration = const Duration(seconds: 3),
    IconData? icon,
    VoidCallback? onTap,
  }) {
    IOSToast.show(
      context: this,
      message: message,
      type: type,
      duration: duration,
      icon: icon,
      onTap: onTap,
    );
  }

  void showSuccessToast(String message) {
    showIOSToast(message, type: IOSToastType.success);
  }

  void showErrorToast(String message) {
    showIOSToast(message, type: IOSToastType.error);
  }

  void showWarningToast(String message) {
    showIOSToast(message, type: IOSToastType.warning);
  }
}