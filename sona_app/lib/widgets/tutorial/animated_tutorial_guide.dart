import 'dart:async';
import 'package:flutter/material.dart';
import '../../models/tutorial_animation.dart';
import 'gesture_animator.dart';
import 'highlight_animator.dart';
import 'skip_button.dart';

/// 애니메이션 기반 튜토리얼 가이드 위젯
class AnimatedTutorialGuide extends StatefulWidget {
  final AnimatedTutorialStep step;
  final int currentStep;
  final int totalSteps;
  final VoidCallback onNext;
  final VoidCallback onSkip;
  final VoidCallback? onPrevious;

  const AnimatedTutorialGuide({
    super.key,
    required this.step,
    required this.currentStep,
    required this.totalSteps,
    required this.onNext,
    required this.onSkip,
    this.onPrevious,
  });

  @override
  State<AnimatedTutorialGuide> createState() => _AnimatedTutorialGuideState();
}

class _AnimatedTutorialGuideState extends State<AnimatedTutorialGuide>
    with TickerProviderStateMixin {
  Timer? _stepTimer;
  final List<AnimationController> _animationControllers = [];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    debugPrint(
        'AnimatedTutorialGuide - Step ${widget.currentStep + 1}: Duration = ${widget.step.stepDuration}');

    // 타이머로 스텝 duration 관리
    _stepTimer?.cancel();
    _stepTimer = Timer(widget.step.stepDuration, () {
      if (mounted) {
        debugPrint(
            'AnimatedTutorialGuide - Step ${widget.currentStep + 1} completed after ${widget.step.stepDuration}, moving to next');
        widget.step.onComplete?.call();
        widget.onNext();
      }
    });

    // 각 애니메이션을 위한 컨트롤러 생성
    for (var animation in widget.step.animations) {
      final controller = AnimationController(
        duration: animation.duration,
        vsync: this,
      );
      _animationControllers.add(controller);

      // 지연 후 애니메이션 시작
      Future.delayed(animation.delay, () {
        if (mounted) {
          if (animation.repeat) {
            controller.repeat();
          } else {
            controller.forward();
          }
        }
      });
    }
  }

  @override
  void didUpdateWidget(AnimatedTutorialGuide oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 스텝이 변경되면 애니메이션 재초기화
    if (oldWidget.step != widget.step ||
        oldWidget.currentStep != widget.currentStep) {
      _stepTimer?.cancel();
      for (var controller in _animationControllers) {
        controller.dispose();
      }
      _animationControllers.clear();
      _initializeAnimations();
    }
  }

  @override
  void dispose() {
    _stepTimer?.cancel();
    for (var controller in _animationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // dim 화면 제거 - 애니메이션과 하이라이트만 표시

        // 하이라이트 애니메이션 효과
        if (widget.step.highlightArea != null)
          HighlightAnimator(
            highlightArea: widget.step.highlightArea!,
          ),

        // 각 애니메이션 렌더링
        ...widget.step.animations.asMap().entries.map((entry) {
          final index = entry.key;
          final animation = entry.value;
          return GestureAnimator(
            animation: animation,
            controller: _animationControllers[index],
          );
        }),

        // Skip 버튼 - 튜토리얼 종료 (가장 위에 렌더링)
        SkipButton(
          onSkip: widget.onSkip, // 튜토리얼 전체를 스킵
          currentStep: widget.currentStep,
          totalSteps: widget.totalSteps,
        ),

        // 진행 표시기
        Positioned(
          bottom: 50,
          left: 0,
          right: 0,
          child: _buildProgressIndicator(),
        ),
      ],
    );
  }

  Widget _buildProgressIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.totalSteps, (index) {
        final isActive = index == widget.currentStep;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: isActive
                ? const Color(0xFFFF6B9D)
                : Colors.white.withValues(alpha: 0.5),
          ),
        );
      }),
    );
  }
}
