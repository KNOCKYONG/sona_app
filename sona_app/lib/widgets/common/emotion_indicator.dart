import 'package:flutter/material.dart';
import '../../models/message.dart';

class EmotionIndicator extends StatefulWidget {
  final EmotionType emotion;
  final double size;
  final bool animate;

  const EmotionIndicator({
    super.key,
    required this.emotion,
    this.size = 24,
    this.animate = true,
  });

  @override
  State<EmotionIndicator> createState() => _EmotionIndicatorState();
}

class _EmotionIndicatorState extends State<EmotionIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    
    if (widget.animate) {
      _animationController = AnimationController(
        duration: const Duration(milliseconds: 1500),
        vsync: this,
      );
      
      _pulseAnimation = Tween<double>(
        begin: 0.8,
        end: 1.2,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticInOut,
      ));
      
      _rotationAnimation = Tween<double>(
        begin: -0.1,
        end: 0.1,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ));
      
      _animationController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    if (widget.animate) {
      _animationController.dispose();
    }
    super.dispose();
  }

  Color _getEmotionColor() {
    switch (widget.emotion) {
      case EmotionType.love:
        return Colors.pink;
      case EmotionType.happy:
        return Colors.orange;
      case EmotionType.shy:
        return Colors.pink[200]!;
      case EmotionType.jealous:
        return Colors.green[700]!;
      case EmotionType.angry:
        return Colors.red;
      case EmotionType.sad:
        return Colors.blue[300]!;
      case EmotionType.surprised:
        return Colors.purple[300]!;
      case EmotionType.thoughtful:
        return Colors.grey[600]!;
      case EmotionType.anxious:
        return Colors.deepPurple[300]!;
      case EmotionType.concerned:
        return Colors.orange[300]!;
      case EmotionType.neutral:
        return Colors.grey;
    }
  }

  Widget _buildEmotionWidget() {
    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        color: _getEmotionColor().withValues(alpha: 0.1),
        shape: BoxShape.circle,
        border: Border.all(
          color: _getEmotionColor().withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Center(
        child: Text(
          widget.emotion.emoji,
          style: TextStyle(
            fontSize: widget.size * 0.6,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.animate) {
      return _buildEmotionWidget();
    }

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Transform.rotate(
            angle: _rotationAnimation.value,
            child: _buildEmotionWidget(),
          ),
        );
      },
    );
  }
}

class EmotionBar extends StatelessWidget {
  final Map<EmotionType, int> emotionCounts;
  final double height;

  const EmotionBar({
    super.key,
    required this.emotionCounts,
    this.height = 40,
  });

  @override
  Widget build(BuildContext context) {
    if (emotionCounts.isEmpty) {
      return const SizedBox.shrink();
    }

    final totalCount = emotionCounts.values.reduce((a, b) => a + b);
    
    return Container(
      height: height,
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: emotionCounts.entries.map((entry) {
          final emotion = entry.key;
          final count = entry.value;
          final percentage = count / totalCount;
          
          return Expanded(
            flex: count,
            child: Container(
              decoration: BoxDecoration(
                color: _getEmotionColor(emotion).withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      emotion.emoji,
                      style: const TextStyle(fontSize: 16),
                    ),
                    if (percentage > 0.15) ...[
                      const SizedBox(width: 4),
                      Text(
                        '$count',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Color _getEmotionColor(EmotionType emotion) {
    switch (emotion) {
      case EmotionType.love:
        return Colors.pink;
      case EmotionType.happy:
        return Colors.orange;
      case EmotionType.shy:
        return Colors.pink[200]!;
      case EmotionType.jealous:
        return Colors.green[700]!;
      case EmotionType.angry:
        return Colors.red;
      case EmotionType.sad:
        return Colors.blue[300]!;
      case EmotionType.surprised:
        return Colors.purple[300]!;
      case EmotionType.thoughtful:
        return Colors.grey[600]!;
      case EmotionType.anxious:
        return Colors.deepPurple[300]!;
      case EmotionType.concerned:
        return Colors.orange[300]!;
      case EmotionType.neutral:
        return Colors.grey;
    }
  }
}