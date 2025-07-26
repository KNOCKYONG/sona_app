import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TutorialOverlay extends StatefulWidget {
  final Widget child;
  final String screenKey;
  final List<TutorialStep> tutorialSteps;

  const TutorialOverlay({
    super.key,
    required this.child,
    required this.screenKey,
    required this.tutorialSteps,
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
    // 튜토리얼 모드인 경우 항상 표시, 일반 모드에서는 한 번만 표시
    final isTutorialMode = prefs.getBool('is_tutorial_mode') ?? false;
    final hasSeenTutorial = prefs.getBool('tutorial_${widget.screenKey}') ?? false;
    final allPersonasViewed = prefs.getBool('all_personas_viewed') ?? false;
    
    // 페르소나 선택 화면에서 모든 페르소나를 확인했다면 튜토리얼 표시 안함
    if (widget.screenKey == 'persona_selection' && allPersonasViewed && !isTutorialMode) {
      return;
    }
    
    // 각 스텝별로 다시 보지 않기 설정 확인
    bool allStepsHidden = true;
    for (int i = 0; i < widget.tutorialSteps.length; i++) {
      final stepHidden = prefs.getBool('tutorial_${widget.screenKey}_step_$i') ?? false;
      if (!stepHidden) {
        allStepsHidden = false;
        break;
      }
    }
    
    // 모든 스텝이 숨겨져 있으면 튜토리얼 표시 안함
    if (allStepsHidden && !isTutorialMode) {
      return;
    }
    
    if (isTutorialMode || !hasSeenTutorial) {
      // 화면이 완전히 로드된 후 튜토리얼 표시
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) {
        setState(() {
          _showTutorial = true;
        });
      }
    }
  }

  String _getIconEmoji(IconData icon) {
    // Material Icons를 이모지로 변환하는 헬퍼 메서드
    if (icon == Icons.swipe) return '👆';
    if (icon == Icons.photo_library) return '📷';
    if (icon == Icons.star) return '⭐';
    if (icon == Icons.favorite) return '💕';
    if (icon == Icons.chat) return '💬';
    if (icon == Icons.info_outline) return 'ℹ️';
    if (icon == Icons.lightbulb_outline) return '💡';
    if (icon == Icons.swipe_left) return '👈';
    if (icon == Icons.swipe_right) return '👉';
    if (icon == Icons.touch_app) return '👆';
    if (icon == Icons.pan_tool) return '✋';
    return 'ℹ️'; // 기본값
  }

  void _nextStep() async {
    // 🔧 FIX: 빈 배열에 대한 안전한 처리
    if (widget.tutorialSteps.isEmpty) {
      _completeTutorial();
      return;
    }
    
    // 현재 스텝을 다시 보지 않기로 선택했다면 저장
    if (_dontShowAgainSteps[_currentStep] == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('tutorial_${widget.screenKey}_step_$_currentStep', true);
    }
    
    if (_currentStep < widget.tutorialSteps.length - 1) {
      setState(() {
        _currentStep++;
      });
    } else {
      _completeTutorial();
    }
  }

  void _previousStep() {
    // 🔧 FIX: 빈 배열에 대한 안전한 처리
    if (widget.tutorialSteps.isEmpty) return;
    
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  Future<void> _completeTutorial() async {
    final prefs = await SharedPreferences.getInstance();
    final isTutorialMode = prefs.getBool('is_tutorial_mode') ?? false;
    
    // 튜토리얼 모드가 아닐 때만 완료 상태를 저장
    if (!isTutorialMode) {
      await prefs.setBool('tutorial_${widget.screenKey}', true);
    }
    
    setState(() {
      _showTutorial = false;
    });
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
    
    final currentStep = widget.tutorialSteps[_currentStep];
    
    return GestureDetector(
      onTap: () {}, // 오버레이 클릭 방지
      child: Container(
        color: Colors.black.withValues(alpha: 0.7),
        child: Stack(
          children: [
            // 하이라이트 영역
            if (currentStep.highlightArea != null)
              Positioned(
                left: currentStep.highlightArea!.left,
                top: currentStep.highlightArea!.top,
                width: currentStep.highlightArea!.width,
                height: currentStep.highlightArea!.height,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xFFFF6B9D),
                      width: 3,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFF6B9D).withValues(alpha: 0.5),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                ),
              ),
            
            // 설명 카드
            _buildPositionedMessageCard(currentStep),
            
            // 제스처 힌트 애니메이션
            if (currentStep.gestureHint != null)
              _buildGestureHint(currentStep.gestureHint!),
          ],
        ),
      ),
    );
  }

  Widget _buildPositionedMessageCard(TutorialStep step) {
    final screenSize = MediaQuery.of(context).size;
    const margin = 16.0;
    const cardPadding = 16.0;
    const bottomNavHeight = 80.0; // 하단 네비게이션 바 높이 + SafeArea
    
    // 화면 크기에 따른 동적 카드 너비 (최대 300, 최소 280)
    final cardWidth = (screenSize.width - margin * 2).clamp(280.0, 300.0);
    
    // 초기 위치
    double left = step.messagePosition.dx;
    double top = step.messagePosition.dy;
    
    // 화면 범위를 벗어나지 않도록 조정
    // 오른쪽 경계 체크
    if (left + cardWidth + margin > screenSize.width) {
      left = screenSize.width - cardWidth - margin;
    }
    
    // 왼쪽 경계 체크
    if (left < margin) {
      left = margin;
    }
    
    // 아래쪽 경계 체크 (대략적인 카드 높이 추정 + 하단 네비게이션 바 고려)
    const estimatedCardHeight = 380.0;
    final bottomLimit = screenSize.height - bottomNavHeight;
    if (top + estimatedCardHeight + margin > bottomLimit) {
      top = bottomLimit - estimatedCardHeight - margin;
    }
    
    // 위쪽 경계 체크
    if (top < margin) {
      top = margin;
    }
    
    return Positioned(
      left: left,
      top: top,
      child: Container(
        width: cardWidth,
        padding: const EdgeInsets.all(cardPadding),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  step.icon != null 
                    ? _getIconEmoji(step.icon!)
                    : 'ℹ️',
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    step.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFF6B9D),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              step.description,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black87,
                height: 1.4,
              ),
              maxLines: 6,
              overflow: TextOverflow.ellipsis,
            ),
            if (step.tip != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF6B9D).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Text(
                      '💡',
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        step.tip!,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFFFF6B9D),
                          fontStyle: FontStyle.italic,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 16),
            // 다시 보지 않기 체크박스
            Material(
              color: Colors.transparent,
              child: Row(
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: Checkbox(
                      value: _dontShowAgainSteps[_currentStep] ?? false,
                      onChanged: (value) {
                        setState(() {
                          _dontShowAgainSteps[_currentStep] = value ?? false;
                        });
                      },
                      activeColor: const Color(0xFFFF6B9D),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Expanded(
                    child: Text(
                      '이 가이드 다시 보지 않기',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Column(
              children: [
                // 단계 표시
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${_currentStep + 1} / ${widget.tutorialSteps.length}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // 버튼들
                Row(
                  children: [
                    if (_currentStep > 0)
                      Expanded(
                        flex: 1,
                        child: TextButton(
                          onPressed: _previousStep,
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                          ),
                          child: const Text(
                            '이전',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ),
                      ),
                    if (_currentStep > 0) const SizedBox(width: 4),
                    Expanded(
                      flex: 1,
                      child: TextButton(
                        onPressed: _skipTutorial,
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                        ),
                        child: const Text(
                          '건너뛰기',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: _nextStep,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF6B9D),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        ),
                        child: Text(
                          _currentStep < widget.tutorialSteps.length - 1 
                              ? '다음' 
                              : '시작하기',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGestureHint(GestureHint hint) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(seconds: 2),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Positioned(
          left: hint.startPosition.dx + (hint.endPosition.dx - hint.startPosition.dx) * value,
          top: hint.startPosition.dy + (hint.endPosition.dy - hint.startPosition.dy) * value,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 500),
            opacity: hint.type == GestureType.tap ? (value < 0.5 ? 1.0 : 0.0) : 1.0,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFF6B9D).withValues(alpha: 0.3),
                border: Border.all(
                  color: const Color(0xFFFF6B9D),
                  width: 2,
                ),
              ),
              child: Center(
                child: Icon(
                  hint.type == GestureType.swipeLeft 
                      ? Icons.swipe_left
                      : hint.type == GestureType.swipeRight
                      ? Icons.swipe_right
                      : hint.type == GestureType.tap
                      ? Icons.touch_app
                      : Icons.pan_tool,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

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