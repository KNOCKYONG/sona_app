import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/cache_manager.dart';
import '../models/tutorial_animation.dart' as anim_model;
import 'animated_tutorial/animated_tutorial_guide.dart';

class TutorialOverlay extends StatefulWidget {
  final Widget child;
  final String screenKey;
  final List<TutorialStep> tutorialSteps;
  final List<anim_model.AnimatedTutorialStep>? animatedSteps;
  final VoidCallback? onTutorialComplete;

  const TutorialOverlay({
    super.key,
    required this.child,
    required this.screenKey,
    required this.tutorialSteps,
    this.animatedSteps,
    this.onTutorialComplete,
  });

  @override
  State<TutorialOverlay> createState() => _TutorialOverlayState();
}

class _TutorialOverlayState extends State<TutorialOverlay> {
  bool _showTutorial = false;
  int _currentStep = 0;
  Map<int, bool> _dontShowAgainSteps = {}; // 각 스텝별 다시 보지 않기 상태

  @override
  void initState() {
    super.initState();
    _checkTutorialStatus();
  }

  Future<void> _checkTutorialStatus() async {
    // 🔧 FIX: 빈 튜토리얼 스텝에 대한 사전 체크
    if (widget.tutorialSteps.isEmpty) {
      debugPrint('⚠️ No tutorial steps provided for ${widget.screenKey}');
      return;
    }
    
    final prefs = await SharedPreferences.getInstance();
    final authService = context.read<AuthService>();
    final userId = authService.user?.uid ?? 'anonymous';
    
    // 튜토리얼 모드인 경우 항상 표시, 일반 모드에서는 한 번만 표시
    final isTutorialMode = prefs.getBool('is_tutorial_mode') ?? false;
    final hasSeenTutorial = prefs.getBool('tutorial_${widget.screenKey}_$userId') ?? false;
    final allPersonasViewed = prefs.getBool('all_personas_viewed_$userId') ?? false;
    
    // persona_selection 화면이고 첫 사용자인 경우 튜토리얼 표시
    if (widget.screenKey == 'persona_selection' && !hasSeenTutorial) {
      // 첫 사용자인지 체크
      final isFirstTime = await CacheManager.instance.isFirstTimeUser();
      if (!isFirstTime) {
        return;
      }
      
      // 모든 페르소나를 확인했다면 튜토리얼 표시 안함
      if (allPersonasViewed) {
        return;
      }
      
      debugPrint('TutorialOverlay - Showing tutorial for persona_selection (first time user)');
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) {
        setState(() {
          _showTutorial = true;
        });
      }
      return;
    }
    
    // 각 스텝별로 다시 보지 않기 설정 확인 (사용자별로)
    bool allStepsHidden = true;
    for (int i = 0; i < widget.tutorialSteps.length; i++) {
      final stepHidden = prefs.getBool('tutorial_${widget.screenKey}_step_${i}_$userId') ?? false;
      if (!stepHidden) {
        allStepsHidden = false;
        break;
      }
    }
    
    // 모든 스텝이 숨겨져 있으면 튜토리얼 표시 안함
    if (allStepsHidden && !isTutorialMode) {
      return;
    }
    
    // 튜토리얼 모드이거나, (튜토리얼을 본 적이 없고 모든 스텝이 숨겨지지 않은 경우)에만 표시
    if (isTutorialMode || (!hasSeenTutorial && !allStepsHidden)) {
      // 화면이 완전히 로드된 후 튜토리얼 표시
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) {
        setState(() {
          _showTutorial = true;
        });
      }
    }
  }


  void _nextStep() async {
    debugPrint('TutorialOverlay - Moving from step $_currentStep to next');
    
    // 🔧 FIX: 빈 배열에 대한 안전한 처리
    if (widget.tutorialSteps.isEmpty) {
      _completeTutorial();
      return;
    }
    
    // 현재 스텝을 다시 보지 않기로 선택했다면 저장 (사용자별로)
    if (_dontShowAgainSteps[_currentStep] == true) {
      final prefs = await SharedPreferences.getInstance();
      final authService = context.read<AuthService>();
      final userId = authService.user?.uid ?? 'anonymous';
      await prefs.setBool('tutorial_${widget.screenKey}_step_${_currentStep}_$userId', true);
    }
    
    if (_currentStep < widget.tutorialSteps.length - 1) {
      setState(() {
        _currentStep++;
      });
    } else {
      _completeTutorial();
    }
  }


  Future<void> _completeTutorial() async {
    final prefs = await SharedPreferences.getInstance();
    final authService = context.read<AuthService>();
    final userId = authService.user?.uid ?? 'anonymous';
    final isTutorialMode = prefs.getBool('is_tutorial_mode') ?? false;
    
    // 현재 화면의 튜토리얼 완료 상태 저장
    await prefs.setBool('tutorial_${widget.screenKey}_$userId', true);
    
    // persona_selection 튜토리얼을 완료했으면 첫 사용자 튜토리얼 완료 표시
    if (widget.screenKey == 'persona_selection') {
      await CacheManager.instance.markTutorialCompleted();
    }
    
    setState(() {
      _showTutorial = false;
    });
    
    // 완료 콜백 호출
    widget.onTutorialComplete?.call();
  }

  void _skipTutorial() {
    _completeTutorial();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_showTutorial)
          Positioned.fill(
            child: _buildTutorialOverlay(),
          ),
      ],
    );
  }

  Widget _buildTutorialOverlay() {
    // 🔧 FIX: 안전한 tutorialSteps 접근
    if (widget.tutorialSteps.isEmpty || _currentStep >= widget.tutorialSteps.length) {
      debugPrint('❌ Invalid tutorial step: $_currentStep of ${widget.tutorialSteps.length}');
      return const SizedBox.shrink(); // 빈 위젯 반환
    }
    
    // 애니메이션 스텝이 제공되었으면 사용
    if (widget.animatedSteps != null && _currentStep < widget.animatedSteps!.length) {
      final animatedStep = widget.animatedSteps![_currentStep];
      return Stack(
        children: [
          // 약한 dim layer - 클릭 방지용
          Positioned.fill(
            child: GestureDetector(
              onTap: () {}, // 클릭 이벤트 흡수
              child: Container(
                color: Colors.black.withValues(alpha: 0.1), // 매우 약한 dim
              ),
            ),
          ),
          // 애니메이션 가이드
          AnimatedTutorialGuide(
            step: animatedStep,
            currentStep: _currentStep,
            totalSteps: widget.tutorialSteps.length,
            onNext: _nextStep,
            onSkip: _nextStep, // skip을 다음 스텝으로 변경
          ),
        ],
      );
    }
    
    // 애니메이션 스텝이 없으면 빈 위젯 반환
    return const SizedBox.shrink();
  }
}

// Legacy TutorialStep 클래스 (하위 호환성을 위해 유지)
class TutorialStep {
  final String title;
  final String description;
  final String? tip;
  final IconData? icon;
  final HighlightArea? highlightArea;
  final Offset messagePosition;
  final GestureHint? gestureHint;

  TutorialStep({
    required this.title,
    required this.description,
    this.tip,
    this.icon,
    this.highlightArea,
    required this.messagePosition,
    this.gestureHint,
  });
}

class HighlightArea {
  final double left;
  final double top;
  final double width;
  final double height;

  HighlightArea({
    required this.left,
    required this.top,
    required this.width,
    required this.height,
  });
}

class GestureHint {
  final GestureType type;
  final Offset startPosition;
  final Offset endPosition;

  GestureHint({
    required this.type,
    required this.startPosition,
    required this.endPosition,
  });
}

enum GestureType {
  tap,
  swipeLeft,
  swipeRight,
  longPress,
}