import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../models/tutorial_animation.dart';

/// 제스처 애니메이션을 렌더링하는 위젯
class GestureAnimator extends StatelessWidget {
  final TutorialAnimation animation;
  final AnimationController controller;

  const GestureAnimator({
    super.key,
    required this.animation,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    switch (animation.type) {
      case TutorialAnimationType.swipeRight:
      case TutorialAnimationType.swipeLeft:
      case TutorialAnimationType.swipeUp:
        return _buildSwipeAnimation();
      case TutorialAnimationType.tap:
        return _buildTapAnimation();
      case TutorialAnimationType.typing:
        return _buildTypingAnimation();
      case TutorialAnimationType.pulse:
        return _buildPulseAnimation();
      case TutorialAnimationType.bounce:
        return _buildBounceAnimation();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildSwipeAnimation() {
    final endPosition = animation.endPosition ?? animation.startPosition;
    
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final curvedValue = animation.curve.transform(controller.value);
        
        // 위치 계산
        final currentPosition = Offset.lerp(
          animation.startPosition,
          endPosition,
          curvedValue,
        )!;

        // 스와이프 방향별 피드백 정보
        SwipeFeedback? feedback;
        if (animation.type == TutorialAnimationType.swipeRight) {
          feedback = SwipeFeedbacks.right;
        } else if (animation.type == TutorialAnimationType.swipeUp) {
          feedback = SwipeFeedbacks.up;
        } else if (animation.type == TutorialAnimationType.swipeLeft) {
          feedback = SwipeFeedbacks.left;
        }

        return Stack(
          children: [
            // 트레일 효과
            if (curvedValue > 0.1)
              CustomPaint(
                painter: SwipeTrailPainter(
                  start: animation.startPosition,
                  end: currentPosition,
                  color: feedback?.color ?? const Color(0xFFFF6B9D),
                  opacity: curvedValue,
                ),
              ),

            // 손가락 아이콘
            Positioned(
              left: currentPosition.dx - 30,
              top: currentPosition.dy - 30,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: curvedValue < 0.9 ? 1.0 : 0.0,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: (feedback?.color ?? const Color(0xFFFF6B9D))
                            .withValues(alpha: 0.5),
                        blurRadius: 15,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Transform.rotate(
                    angle: animation.type == TutorialAnimationType.swipeLeft 
                        ? math.pi / 6  // 왼쪽 스와이프일 때 약간 기울임
                        : animation.type == TutorialAnimationType.swipeRight
                        ? -math.pi / 6  // 오른쪽 스와이프일 때 약간 기울임
                        : 0,  // 위 스와이프일 때는 기울이지 않음
                    child: const Icon(
                      Icons.touch_app,  // 손가락 포인터 아이콘
                      color: Color(0xFFFF6B9D),
                      size: 35,
                    ),
                  ),
                ),
              ),
            ),

            // 방향 피드백 아이콘
            if (feedback != null && curvedValue > 0.5)
              Positioned(
                left: endPosition.dx - 40,
                top: endPosition.dy - 40,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: curvedValue > 0.5 ? (curvedValue - 0.5) * 2 : 0.0,
                  child: Transform.scale(
                    scale: 0.5 + (curvedValue - 0.5),
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: feedback.color.withValues(alpha: 0.2),
                      ),
                      child: Center(
                        child: Text(
                          feedback.emoji,
                          style: const TextStyle(fontSize: 40),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildTapAnimation() {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final scale = 1.0 + math.sin(controller.value * math.pi) * 0.3;
        final opacity = 1.0 - controller.value;

        return Positioned(
          left: animation.startPosition.dx - 40,
          top: animation.startPosition.dy - 40,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 100),
            opacity: opacity,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // 리플 효과
                Transform.scale(
                  scale: 1.0 + controller.value * 2,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFFF6B9D).withValues(alpha: opacity * 0.5),
                        width: 3,
                      ),
                    ),
                  ),
                ),
                // 탭 아이콘
                Transform.scale(
                  scale: scale,
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF6B9D).withValues(alpha: 0.3),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.touch_app,
                      color: Color(0xFFFF6B9D),
                      size: 30,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTypingAnimation() {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final textLength = (controller.value * 20).floor();
        final cursorOpacity = math.sin(controller.value * math.pi * 4).abs();
        
        return Positioned(
          left: animation.startPosition.dx,
          top: animation.startPosition.dy,
          child: Row(
            children: [
              // 타이핑 텍스트
              Text(
                '•' * textLength,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[600],
                  letterSpacing: 2,
                ),
              ),
              // 커서
              Container(
                width: 2,
                height: 20,
                color: const Color(0xFFFF6B9D).withValues(alpha: cursorOpacity),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPulseAnimation() {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final scale = 1.0 + math.sin(controller.value * math.pi * 2) * 0.2;
        
        return Positioned(
          left: animation.startPosition.dx - 30,
          top: animation.startPosition.dy - 30,
          child: Transform.scale(
            scale: scale,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: (animation.color ?? const Color(0xFFFF6B9D))
                    .withValues(alpha: 0.3),
                border: Border.all(
                  color: animation.color ?? const Color(0xFFFF6B9D),
                  width: 3,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBounceAnimation() {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        // 바운스 효과를 위한 계산
        final bounceValue = Curves.elasticOut.transform(controller.value);
        final yOffset = math.sin(bounceValue * math.pi) * 20;
        
        return Positioned(
          left: animation.startPosition.dx - 30,
          top: animation.startPosition.dy - 30 - yOffset,
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: animation.color ?? const Color(0xFFFF6B9D),
              boxShadow: [
                BoxShadow(
                  color: (animation.color ?? const Color(0xFFFF6B9D))
                      .withValues(alpha: 0.3),
                  blurRadius: 10 + yOffset / 2,
                  offset: Offset(0, 5 + yOffset / 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.mood,
              color: Colors.white,
              size: 35,
            ),
          ),
        );
      },
    );
  }
}

/// 스와이프 트레일을 그리는 CustomPainter
class SwipeTrailPainter extends CustomPainter {
  final Offset start;
  final Offset end;
  final Color color;
  final double opacity;

  SwipeTrailPainter({
    required this.start,
    required this.end,
    required this.color,
    required this.opacity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: opacity * 0.3)
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // 그라데이션 효과를 위한 경로
    final path = Path()
      ..moveTo(start.dx, start.dy)
      ..quadraticBezierTo(
        (start.dx + end.dx) / 2,
        (start.dy + end.dy) / 2,
        end.dx,
        end.dy,
      );

    canvas.drawPath(path, paint);

    // 화살표 그리기
    if (opacity > 0.5) {
      final angle = math.atan2(end.dy - start.dy, end.dx - start.dx);
      final arrowPaint = Paint()
        ..color = color.withValues(alpha: opacity * 0.6)
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;

      canvas.save();
      canvas.translate(end.dx, end.dy);
      canvas.rotate(angle);
      
      // 화살표 머리
      canvas.drawLine(
        const Offset(-15, -10),
        Offset.zero,
        arrowPaint,
      );
      canvas.drawLine(
        const Offset(-15, 10),
        Offset.zero,
        arrowPaint,
      );
      
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(SwipeTrailPainter oldDelegate) {
    return oldDelegate.start != start ||
        oldDelegate.end != end ||
        oldDelegate.opacity != opacity;
  }
}