import 'package:flutter/material.dart';
import 'dart:ui';
import '../theme/app_theme.dart';

class ModernEmotionPicker extends StatefulWidget {
  final Function(String) onEmotionSelected;
  final String selectedEmotion;
  
  const ModernEmotionPicker({
    Key? key,
    required this.onEmotionSelected,
    required this.selectedEmotion,
  }) : super(key: key);
  
  @override
  State<ModernEmotionPicker> createState() => _ModernEmotionPickerState();
}

class _ModernEmotionPickerState extends State<ModernEmotionPicker>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  
  final List<EmotionItem> emotions = [
    EmotionItem(
      emoji: '😊',
      label: '행복',
      color: const Color(0xFFFFD93D),
      gradient: const LinearGradient(
        colors: [Color(0xFFFFD93D), Color(0xFFF6B93B)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    EmotionItem(
      emoji: '😍',
      label: '사랑',
      color: const Color(0xFFFF6B9D),
      gradient: const LinearGradient(
        colors: [Color(0xFFFF6B9D), Color(0xFFC06C84)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    EmotionItem(
      emoji: '😢',
      label: '슬픔',
      color: const Color(0xFF4834D4),
      gradient: const LinearGradient(
        colors: [Color(0xFF4834D4), Color(0xFF686DE0)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    EmotionItem(
      emoji: '😡',
      label: '화남',
      color: const Color(0xFFEE5A6F),
      gradient: const LinearGradient(
        colors: [Color(0xFFEE5A6F), Color(0xFFEB3B5A)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    EmotionItem(
      emoji: '😎',
      label: '쿨함',
      color: const Color(0xFF0FB9B1),
      gradient: const LinearGradient(
        colors: [Color(0xFF0FB9B1), Color(0xFF20BF6B)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    EmotionItem(
      emoji: '🤔',
      label: '생각',
      color: const Color(0xFF778CA3),
      gradient: const LinearGradient(
        colors: [Color(0xFF778CA3), Color(0xFF4B6584)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
  ];
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
    
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
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
        return FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Dialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: Container(
                constraints: const BoxConstraints(maxWidth: 320),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Header
                          Container(
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    gradient: AppTheme.primaryGradient,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.mood_rounded,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Text(
                                  '감정 선택',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const Spacer(),
                                IconButton(
                                  onPressed: () => Navigator.pop(context),
                                  icon: const Icon(Icons.close_rounded),
                                  color: Colors.grey[600],
                                ),
                              ],
                            ),
                          ),
                          
                          // Emotion Grid
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                childAspectRatio: 1,
                              ),
                              itemCount: emotions.length,
                              itemBuilder: (context, index) {
                                final emotion = emotions[index];
                                final isSelected = widget.selectedEmotion == emotion.emoji;
                                
                                return _EmotionButton(
                                  emotion: emotion,
                                  isSelected: isSelected,
                                  onTap: () {
                                    widget.onEmotionSelected(emotion.emoji);
                                    Navigator.pop(context);
                                  },
                                );
                              },
                            ),
                          ),
                          
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _EmotionButton extends StatefulWidget {
  final EmotionItem emotion;
  final bool isSelected;
  final VoidCallback onTap;
  
  const _EmotionButton({
    required this.emotion,
    required this.isSelected,
    required this.onTap,
  });
  
  @override
  State<_EmotionButton> createState() => _EmotionButtonState();
}

class _EmotionButtonState extends State<_EmotionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  
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
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                gradient: widget.isSelected ? widget.emotion.gradient : null,
                color: widget.isSelected ? null : Colors.grey[100],
                borderRadius: BorderRadius.circular(20),
                boxShadow: widget.isSelected
                    ? [
                        BoxShadow(
                          color: widget.emotion.color.withOpacity(0.4),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.emotion.emoji,
                    style: TextStyle(
                      fontSize: widget.isSelected ? 36 : 32,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.emotion.label,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: widget.isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: widget.isSelected ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class EmotionItem {
  final String emoji;
  final String label;
  final Color color;
  final Gradient gradient;
  
  const EmotionItem({
    required this.emoji,
    required this.label,
    required this.color,
    required this.gradient,
  });
}