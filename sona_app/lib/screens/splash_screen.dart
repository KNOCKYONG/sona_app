import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animations/animations.dart';
import '../services/auth/auth_service.dart';
import '../services/persona/persona_service.dart';
import '../widgets/common/sona_logo.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> 
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
    ));
    
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 0.8, curve: Curves.elasticOut),
    ));
    
    _startAnimation();
  }

  void _startAnimation() async {
    await _animationController.forward();
    await Future.delayed(const Duration(seconds: 1));
    
    if (mounted) {
      final authService = Provider.of<AuthService>(context, listen: false);
      final personaService = Provider.of<PersonaService>(context, listen: false);
      
      // PersonaService 초기화 (로컬 데이터만 사용)
      await personaService.initialize(userId: authService.currentUser?.uid);
      
      if (authService.isAuthenticated) {
        Navigator.of(context).pushReplacementNamed('/main');
      } else {
        _showWelcomeDialog();
      }
    }
  }

  void _showWelcomeDialog() {
    showModal<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SonaLogo(size: 40, showText: true),
              SizedBox(height: 12),
              Text(
                '오신 걸 환영해요💕',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF6B9D),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'AI랑 연애하면 어떤 기분일까?\n당신만의 페르소나를 만나보세요.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly
              ),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                //   Container(
                //     width: double.infinity,
                //     child: ElevatedButton(
                //     onPressed: () {
                //       Navigator.of(context).pop();
                //       _startTutorialMode();
                //     },
                //     style: ElevatedButton.styleFrom(
                //       backgroundColor: const Color(0xFFFF6B9D),
                //     ),
                //     child: const Padding(
                //       padding: EdgeInsets.symmetric(vertical: 4),
                //       child: Text(
                //         '튜토리얼 시작',
                //         style: TextStyle(
                //           fontSize: 15,
                //           fontWeight: FontWeight.bold,
                //           color: Colors.white,
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                // const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pushNamed('/login');
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFFF6B9D)),
                    ),
                    child: const Text(
                      '로그인/회원가입',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFF6B9D),
                      ),
                    ),
                  ),
                ),

              ],
              ),
            ),
          ],
        );
      },
    );
  }

  void _startTutorialMode() {
    // Tutorial mode removed - navigate directly to persona selection
    Navigator.of(context).pushReplacementNamed('/persona-selection');
  }

  void _signInAnonymously() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(
            color: Color(0xFFFF6B9D),
          ),
        );
      },
    );

    final success = await authService.signInAnonymously();
    
    if (mounted) {
      Navigator.of(context).pop(); // 로딩 다이얼로그 닫기
      
      if (success) {
        Navigator.of(context).pushReplacementNamed('/main');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('로그인에 실패했습니다. 다시 시도해주세요.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFE0E6),
              Color(0xFFFFB3C6),
              Color(0xFFFF6B9D),
            ],
          ),
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // SONA 로고
                      const SonaLogoLarge(size: 120),
                      const SizedBox(height: 16),
                      
                      // 부제
                      const Text(
                        '감정으로 만나는 특별한 인연',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const SizedBox(height: 80),
                      
                      // 로딩 인디케이터
                      const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 2,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}