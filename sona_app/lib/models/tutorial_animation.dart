import 'package:flutter/material.dart';

/// 튜토리얼 애니메이션 타입 정의
enum TutorialAnimationType {
  swipeRight,
  swipeLeft,
  swipeUp,
  tap,
  typing,
  pulse,
  bounce,
  ripple,
  glow,
  highlight,
}

/// 애니메이션 가이드 데이터 모델
class TutorialAnimation {
  final TutorialAnimationType type;
  final Offset startPosition;
  final Offset? endPosition;
  final Duration duration;
  final Duration delay;
  final Color? color;
  final double? size;
  final String? iconData;
  final bool repeat;
  final Curve curve;

  const TutorialAnimation({
    required this.type,
    required this.startPosition,
    this.endPosition,
    this.duration = const Duration(seconds: 2),
    this.delay = Duration.zero,
    this.color,
    this.size,
    this.iconData,
    this.repeat = true,
    this.curve = Curves.easeInOut,
  });
}

/// 애니메이션 단계 모델
class AnimatedTutorialStep {
  final List<TutorialAnimation> animations;
  final HighlightArea? highlightArea;
  final Duration stepDuration;
  final VoidCallback? onComplete;

  const AnimatedTutorialStep({
    required this.animations,
    this.highlightArea,
    this.stepDuration = const Duration(seconds: 5),
    this.onComplete,
  });
}

/// 하이라이트 영역 모델 (기존 모델 재사용)
class HighlightArea {
  final double left;
  final double top;
  final double width;
  final double height;
  final BorderRadius? borderRadius;
  final double? glowRadius;
  final Color? glowColor;

  const HighlightArea({
    required this.left,
    required this.top,
    required this.width,
    required this.height,
    this.borderRadius,
    this.glowRadius,
    this.glowColor,
  });
}

/// 스와이프 방향별 피드백 정보
class SwipeFeedback {
  final IconData icon;
  final Color color;
  final String emoji;

  const SwipeFeedback({
    required this.icon,
    required this.color,
    required this.emoji,
  });
}

/// 스와이프 방향별 피드백 상수
class SwipeFeedbacks {
  static const right = SwipeFeedback(
    icon: Icons.favorite,
    color: Color(0xFF4CAF50),
    emoji: '❤️',
  );

  static const up = SwipeFeedback(
    icon: Icons.star,
    color: Color(0xFFFFD700),
    emoji: '⭐',
  );

  static const left = SwipeFeedback(
    icon: Icons.close,
    color: Color(0xFFF44336),
    emoji: '❌',
  );
}
