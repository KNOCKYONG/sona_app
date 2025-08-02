import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animations/animations.dart';
import '../services/auth/auth_service.dart';
import '../services/auth/user_service.dart';
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
    
    if (mounted) {
      debugPrint('🚀 [SplashScreen] Animation completed, starting auth check...');
      
      final authService = Provider.of<AuthService>(context, listen: false);
      final userService = Provider.of<UserService>(context, listen: false);
      final personaService = Provider.of<PersonaService>(context, listen: false);
      
      try {
        // Firebase Auth 상태가 초기화될 때까지 대기
        debugPrint('🚀 [SplashScreen] Waiting for Firebase Auth initialization...');
        await Future.delayed(const Duration(seconds: 1));
        
        // Auth 상태가 아직 로드되지 않았으면 추가 대기
        if (authService.user == null) {
          debugPrint('🚀 [SplashScreen] Auth user is null, waiting for auth state...');
          await authService.waitForAuthState();
        }
        
        debugPrint('🚀 [SplashScreen] Auth state check completed. Authenticated: ${authService.isAuthenticated}');
        
        // 로그인된 사용자가 있으면 UserService가 사용자 정보를 로드할 때까지 대기
        if (authService.isAuthenticated && authService.currentUser != null) {
          debugPrint('🔐 [SplashScreen] User is authenticated: ${authService.currentUser!.uid}');
          
          // UserService가 Firebase에서 사용자 정보를 로드할 시간을 줌 (최대 5초)
          int retries = 0;
          const maxRetries = 25; // 200ms * 25 = 5초
          
          debugPrint('🔐 [SplashScreen] Waiting for UserService to load user data...');
          while (userService.currentUser == null && retries < maxRetries) {
            await Future.delayed(const Duration(milliseconds: 200));
            retries++;
            if (retries % 5 == 0) { // 1초마다 로그 출력
              debugPrint('🔐 [SplashScreen] Still waiting for user data... ($retries/$maxRetries)');
            }
          }
          
          // UserService에서 사용자 정보 설정
          if (userService.currentUser != null) {
            debugPrint('✅ [SplashScreen] User data loaded successfully: ${userService.currentUser!.nickname}');
            debugPrint('🔐 [SplashScreen] Setting user info for PersonaService: ${userService.currentUser!.gender}, genderAll: ${userService.currentUser!.genderAll}');
            personaService.setCurrentUser(userService.currentUser!);
            
            // PersonaService 초기화
            debugPrint('🔐 [SplashScreen] Initializing PersonaService...');
            await personaService.initialize(userId: authService.currentUser!.uid);
            
            debugPrint('✅ [SplashScreen] All services initialized, navigating to main screen');
            Navigator.of(context).pushNamedAndRemoveUntil('/main', (route) => false);
          } else {
            debugPrint('❌ [SplashScreen] UserService.currentUser is still null after waiting. This might indicate a Firestore issue.');
            debugPrint('❌ [SplashScreen] Showing welcome dialog to allow re-login');
            _showWelcomeDialog();
          }
        } else {
          debugPrint('🔐 [SplashScreen] User is not authenticated, showing welcome dialog');
          // 로그인되지 않은 경우
          _showWelcomeDialog();
        }
      } catch (e) {
        debugPrint('❌ [SplashScreen] Error during auth initialization: $e');
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
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'AI랑 연애하면 어떤 기분일까?\n당신만의 페르소나를 만나보세요.',
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).brightness == Brightness.dark 
                      ? Colors.white 
                      : Colors.black87,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Row(
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
        Navigator.of(context).pushNamedAndRemoveUntil('/main', (route) => false);
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