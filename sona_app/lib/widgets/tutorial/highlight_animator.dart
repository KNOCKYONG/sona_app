import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../models/tutorial_animation.dart';

/// 하이라이트 영역을 애니메이션으로 표시하는 위젯
class HighlightAnimator extends StatefulWidget {
  final HighlightArea highlightArea;

  const HighlightAnimator({
    super.key,
    required this.highlightArea,
  });

  @override
  State<HighlightAnimator> createState() => _HighlightAnimatorState();
}

class _HighlightAnimatorState extends State<HighlightAnimator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _glowAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          children: [
            // 글로우 효과
            Positioned(
              left: widget.highlightArea.left - 10,
              top: widget.highlightArea.top - 10,
              child: Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
                  width: widget.highlightArea.width + 20,
                  height: widget.highlightArea.height + 20,
                  decoration: BoxDecoration(
                    borderRadius: widget.highlightArea.borderRadius ??
                        BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: (widget.highlightArea.glowColor ??
                                const Color(0xFFFF6B9D))
                            .withValues(alpha: _glowAnimation.value * 0.5),
                        blurRadius: widget.highlightArea.glowRadius ?? 30,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // 보더 효과
            Positioned(
              left: widget.highlightArea.left,
              top: widget.highlightArea.top,
              child: CustomPaint(
                size: Size(
                  widget.highlightArea.width,
                  widget.highlightArea.height,
                ),
                painter: AnimatedBorderPainter(
                  progress: _controller.value,
                  color: widget.highlightArea.glowColor ?? 
                      const Color(0xFFFF6B9D),
                  borderRadius: widget.highlightArea.borderRadius,
                ),
              ),
            ),

            // 코너 강조 표시
            ..._buildCornerIndicators(),
          ],
        );
      },
    );
  }

  List<Widget> _buildCornerIndicators() {
    final corners = <Widget>[];
    final area = widget.highlightArea;
    final color = area.glowColor ?? const Color(0xFFFF6B9D);

    // 좌상단
    corners.add(
      Positioned(
        left: area.left - 5,
        top: area.top - 5,
        child: _buildCornerIndicator(0, color),
      ),
    );

    // 우상단
    corners.add(
      Positioned(
        left: area.left + area.width - 15,
        top: area.top - 5,
        child: _buildCornerIndicator(math.pi / 2, color),
      ),
    );

    // 우하단
    corners.add(
      Positioned(
        left: area.left + area.width - 15,
        top: area.top + area.height - 15,
        child: _buildCornerIndicator(math.pi, color),
      ),
    );

    // 좌하단
    corners.add(
      Positioned(
        left: area.left - 5,
        top: area.top + area.height - 15,
        child: _buildCornerIndicator(3 * math.pi / 2, color),
      ),
    );

    return corners;
  }

  Widget _buildCornerIndicator(double rotation, Color color) {
    return Transform.rotate(
      angle: rotation,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Opacity(
            opacity: 0.6 + _glowAnimation.value * 0.4,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: color,
                    width: 3,
                  ),
                  left: BorderSide(
                    color: color,
                    width: 3,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// 애니메이션 보더를 그리는 CustomPainter
class AnimatedBorderPainter extends CustomPainter {
  final double progress;
  final Color color;
  final BorderRadius? borderRadius;

  AnimatedBorderPainter({
    required this.progress,
    required this.color,
    this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rrect = borderRadius != null
        ? RRect.fromRectAndCorners(
            rect,
            topLeft: borderRadius!.topLeft,
            topRight: borderRadius!.topRight,
            bottomLeft: borderRadius!.bottomLeft,
            bottomRight: borderRadius!.bottomRight,
          )
        : RRect.fromRectAndRadius(rect, const Radius.circular(12));

    final paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // 대시 패턴 애니메이션
    final dashLength = 15.0;
    final dashSpace = 10.0;
    final perimeter = 2 * (size.width + size.height);
    final dashCount = perimeter / (dashLength + dashSpace);
    final animatedOffset = progress * (dashLength + dashSpace);

    final path = Path()..addRRect(rrect);
    
    // 대시 라인 그리기
    final dashPaint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    _drawDashedPath(
      canvas,
      path,
      dashPaint,
      dashLength: dashLength,
      dashSpace: dashSpace,
      offset: animatedOffset,
    );
  }

  void _drawDashedPath(
    Canvas canvas,
    Path path,
    Paint paint, {
    required double dashLength,
    required double dashSpace,
    required double offset,
  }) {
    final pathMetrics = path.computeMetrics();
    
    for (final metric in pathMetrics) {
      var distance = offset % (dashLength + dashSpace);
      
      while (distance < metric.length) {
        final remainingLength = metric.length - distance;
        
        if (remainingLength >= dashLength) {
          final extractPath = metric.extractPath(distance, distance + dashLength);
          canvas.drawPath(extractPath, paint);
          distance += dashLength + dashSpace;
        } else {
          final extractPath = metric.extractPath(distance, distance + remainingLength);
          canvas.drawPath(extractPath, paint);
          break;
        }
      }
    }
  }

  @override
  bool shouldRepaint(AnimatedBorderPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color;
  }
}