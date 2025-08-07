import 'package:flutter/material.dart';

class TypingIndicator extends StatefulWidget {
  final String? personaName;

  const TypingIndicator({
    super.key,
    this.personaName,
  });

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late List<AnimationController> _dotControllers;
  late List<Animation<double>> _dotAnimations;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // 3개의 점에 대한 개별 애니메이션 컨트롤러 생성
    _dotControllers = List.generate(3, (index) {
      return AnimationController(
        duration: const Duration(milliseconds: 600),
        vsync: this,
      );
    });

    // 각 점에 대한 애니메이션 생성
    _dotAnimations = _dotControllers.map((controller) {
      return Tween<double>(
        begin: 0.4,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOut,
      ));
    }).toList();

    // 순차적으로 점 애니메이션 시작
    _startDotAnimations();
  }

  void _startDotAnimations() async {
    while (mounted) {
      for (int i = 0; i < _dotControllers.length; i++) {
        if (mounted) {
          _dotControllers[i].forward();
          await Future.delayed(const Duration(milliseconds: 200));
        }
      }

      // 모든 점이 끝나면 역순으로 애니메이션
      for (int i = _dotControllers.length - 1; i >= 0; i--) {
        if (mounted) {
          _dotControllers[i].reverse();
          await Future.delayed(const Duration(milliseconds: 200));
        }
      }

      await Future.delayed(const Duration(milliseconds: 300));
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    for (var controller in _dotControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // 타이핑 중임을 나타내는 아이콘
          Container(
            width: 24,
            height: 24,
            margin: const EdgeInsets.only(right: 8, bottom: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFFF6B9D).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.edit,
              size: 14,
              color: Color(0xFFFF6B9D),
            ),
          ),

          // 타이핑 인디케이터 버블
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(4),
                  bottomRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 타이핑 중 텍스트
                  Text(
                    '입력 중...',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(width: 8),

                  // 애니메이션 점들
                  Row(
                    children: List.generate(3, (index) {
                      return AnimatedBuilder(
                        animation: _dotAnimations[index],
                        builder: (context, child) {
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 1),
                            child: Opacity(
                              opacity: _dotAnimations[index].value,
                              child: Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFF6B9D),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TypingIndicatorSimple extends StatefulWidget {
  const TypingIndicatorSimple({super.key});

  @override
  State<TypingIndicatorSimple> createState() => _TypingIndicatorSimpleState();
}

class _TypingIndicatorSimpleState extends State<TypingIndicatorSimple>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Row(
                children: List.generate(3, (index) {
                  final delay = index * 0.3;
                  final animationValue = Curves.easeInOut.transform(
                    (_animationController.value + delay) % 1.0,
                  );

                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    child: Opacity(
                      opacity: 0.4 + (animationValue * 0.6),
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFF6B9D),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  );
                }),
              );
            },
          ),
          const SizedBox(width: 8),
          Text(
            '입력 중...',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
