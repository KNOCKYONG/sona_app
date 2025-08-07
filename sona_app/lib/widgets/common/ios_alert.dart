import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../services/ui/haptic_service.dart';

/// iOS-style alert dialog with blur background and smooth animations
class IOSAlert {
  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    String? message,
    List<IOSAlertAction> actions = const [],
    bool barrierDismissible = true,
  }) async {
    // Haptic feedback when alert appears
    await HapticService.lightImpact();
    
    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierLabel: '',
      barrierColor: Colors.black.withOpacity(0.4),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Center(
          child: _IOSAlertDialog(
            title: title,
            message: message,
            actions: actions,
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: animation.value * 10,
            sigmaY: animation.value * 10,
          ),
          child: FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: Tween<double>(
                begin: 0.9,
                end: 1.0,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutBack,
              )),
              child: child,
            ),
          ),
        );
      },
    );
  }

  static Future<bool?> confirm({
    required BuildContext context,
    required String title,
    String? message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    bool isDestructive = false,
  }) {
    return show<bool>(
      context: context,
      title: title,
      message: message,
      actions: [
        IOSAlertAction(
          text: cancelText,
          onPressed: () => Navigator.of(context).pop(false),
          isCancel: true,
        ),
        IOSAlertAction(
          text: confirmText,
          onPressed: () => Navigator.of(context).pop(true),
          isDestructive: isDestructive,
        ),
      ],
    );
  }
}

class IOSAlertAction {
  final String text;
  final VoidCallback onPressed;
  final bool isDestructive;
  final bool isCancel;
  final bool isDefault;

  const IOSAlertAction({
    required this.text,
    required this.onPressed,
    this.isDestructive = false,
    this.isCancel = false,
    this.isDefault = false,
  });
}

class _IOSAlertDialog extends StatelessWidget {
  final String title;
  final String? message;
  final List<IOSAlertAction> actions;

  const _IOSAlertDialog({
    required this.title,
    this.message,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 270,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 30,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title and message
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    letterSpacing: -0.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (message != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    message!,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.black.withOpacity(0.6),
                      letterSpacing: -0.08,
                      height: 1.3,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ),
          // Divider
          Container(
            height: 0.5,
            color: Colors.grey.withOpacity(0.3),
          ),
          // Actions
          if (actions.isNotEmpty)
            Column(
              mainAxisSize: MainAxisSize.min,
              children: _buildActions(context),
            ),
        ],
      ),
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    final widgets = <Widget>[];
    
    for (int i = 0; i < actions.length; i++) {
      final action = actions[i];
      
      if (i > 0) {
        // Add divider between actions
        widgets.add(
          Container(
            height: 0.5,
            color: Colors.grey.withOpacity(0.3),
          ),
        );
      }
      
      widgets.add(
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () async {
              await HapticService.lightImpact();
              action.onPressed();
            },
            borderRadius: i == actions.length - 1
                ? const BorderRadius.only(
                    bottomLeft: Radius.circular(14),
                    bottomRight: Radius.circular(14),
                  )
                : null,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: Text(
                  action.text,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: action.isDefault
                        ? FontWeight.w600
                        : action.isCancel
                            ? FontWeight.w400
                            : FontWeight.w500,
                    color: action.isDestructive
                        ? Colors.red
                        : action.isCancel
                            ? Colors.grey[600]
                            : const Color(0xFF007AFF),
                    letterSpacing: -0.4,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
    
    return widgets;
  }
}

/// iOS-style action sheet
class IOSActionSheet {
  static Future<T?> show<T>({
    required BuildContext context,
    String? title,
    String? message,
    required List<IOSActionSheetItem> actions,
    bool showCancel = true,
    String cancelText = 'Cancel',
  }) async {
    await HapticService.lightImpact();
    
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _IOSActionSheetWidget(
        title: title,
        message: message,
        actions: actions,
        showCancel: showCancel,
        cancelText: cancelText,
      ),
    );
  }
}

class IOSActionSheetItem {
  final String text;
  final IconData? icon;
  final dynamic value;
  final bool isDestructive;

  const IOSActionSheetItem({
    required this.text,
    this.icon,
    this.value,
    this.isDestructive = false,
  });
}

class _IOSActionSheetWidget extends StatelessWidget {
  final String? title;
  final String? message;
  final List<IOSActionSheetItem> actions;
  final bool showCancel;
  final String cancelText;

  const _IOSActionSheetWidget({
    this.title,
    this.message,
    required this.actions,
    required this.showCancel,
    required this.cancelText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Actions container
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.95),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title and message
                if (title != null || message != null)
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        if (title != null)
                          Text(
                            title!,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Colors.black.withOpacity(0.5),
                              letterSpacing: -0.08,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        if (title != null && message != null)
                          const SizedBox(height: 8),
                        if (message != null)
                          Text(
                            message!,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black.withOpacity(0.5),
                              letterSpacing: -0.08,
                              height: 1.3,
                            ),
                            textAlign: TextAlign.center,
                          ),
                      ],
                    ),
                  ),
                if (title != null || message != null)
                  Container(
                    height: 0.5,
                    color: Colors.grey.withOpacity(0.3),
                  ),
                // Action items
                ...actions.asMap().entries.map((entry) {
                  final index = entry.key;
                  final action = entry.value;
                  
                  return Column(
                    children: [
                      if (index > 0)
                        Container(
                          height: 0.5,
                          color: Colors.grey.withOpacity(0.3),
                        ),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () async {
                            await HapticService.lightImpact();
                            Navigator.of(context).pop(action.value);
                          },
                          borderRadius: index == actions.length - 1 &&
                                  (title == null && message == null)
                              ? const BorderRadius.only(
                                  bottomLeft: Radius.circular(14),
                                  bottomRight: Radius.circular(14),
                                )
                              : null,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (action.icon != null) ...[
                                  Icon(
                                    action.icon,
                                    size: 22,
                                    color: action.isDestructive
                                        ? Colors.red
                                        : const Color(0xFF007AFF),
                                  ),
                                  const SizedBox(width: 12),
                                ],
                                Text(
                                  action.text,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                    color: action.isDestructive
                                        ? Colors.red
                                        : const Color(0xFF007AFF),
                                    letterSpacing: 0.38,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
          // Cancel button
          if (showCancel) ...[
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () async {
                    await HapticService.lightImpact();
                    Navigator.of(context).pop();
                  },
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    child: Center(
                      child: Text(
                        cancelText,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF007AFF),
                          letterSpacing: 0.38,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
          // Bottom safe area
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}