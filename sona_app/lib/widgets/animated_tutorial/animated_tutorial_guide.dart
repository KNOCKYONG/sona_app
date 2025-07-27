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
  late AnimationController _stepController;
  final List<AnimationController> _animationControllers = [];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    // 전체 스텝 타이머
    _stepController = AnimationController(
      duration: widget.step.stepDuration,
      vsync: this,
    );

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

    // 스텝 완료 시 다음으로
    _stepController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.step.onComplete?.call();
        widget.onNext();
      }
    });

    _stepController.forward();
  }

  @override
  void didUpdateWidget(AnimatedTutorialGuide oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 스텝이 변경되면 애니메이션 재초기화
    if (oldWidget.step != widget.step || oldWidget.currentStep != widget.currentStep) {
      _stepController.dispose();
      for (var controller in _animationControllers) {
        controller.dispose();
      }
      _animationControllers.clear();
      _initializeAnimations();
    }
  }

  @override
  void dispose() {
    _stepController.dispose();
    for (var controller in _animationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 하이라이트 영역
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

        // Skip 버튼 - 다음 스텝으로 이동
        SkipButton(
          onSkip: widget.onNext,  // onSkip 대신 onNext 호출
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