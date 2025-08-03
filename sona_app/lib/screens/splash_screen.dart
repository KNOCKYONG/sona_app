import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animations/animations.dart';
import '../services/auth/auth_service.dart';
import '../services/auth/user_service.dart';
import '../services/persona/persona_service.dart';
import '../widgets/common/sona_logo.dart';
import '../l10n/app_localizations.dart';

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
  
  // 진행률 관련 변수
  double _progress = 0.0;
  String _loadingMessage = '';
  bool _showProgress = false;

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
    // 애니메이션 시작과 동시에 진행률 표시
    setState(() {
      _showProgress = true;
      _loadingMessage = '앱을 시작하고 있어요';
      _progress = 0.1;
    });
    
    await _animationController.forward();
    
    if (mounted) {
      debugPrint('🚀 [SplashScreen] Animation completed, starting auth check...');
      
      setState(() {
        _progress = 0.2;
        _loadingMessage = '사용자 정보 확인 중';
      });
      
      final authService = Provider.of<AuthService>(context, listen: false);
      final userService = Provider.of<UserService>(context, listen: false);
      final personaService = Provider.of<PersonaService>(context, listen: false);
      
      try {
        // Firebase Auth 상태가 초기화될 때까지 대기
        debugPrint('🚀 [SplashScreen] Waiting for Firebase Auth initialization...');
        setState(() {
          _progress = 0.3;
          _loadingMessage = '서버 연결 중';
        });
        await Future.delayed(const Duration(seconds: 1));
        
        // Auth 상태가 아직 로드되지 않았으면 추가 대기
        if (authService.user == null) {
          debugPrint('🚀 [SplashScreen] Auth user is null, waiting for auth state...');
          setState(() {
            _progress = 0.4;
            _loadingMessage = '인증 확인 중';
          });
          await authService.waitForAuthState();
        }
        
        debugPrint('🚀 [SplashScreen] Auth state check completed. Authenticated: ${authService.isAuthenticated}');
        
        // 로그인된 사용자가 있으면 UserService가 사용자 정보를 로드할 때까지 대기
        if (authService.isAuthenticated && authService.currentUser != null) {
          debugPrint('🔐 [SplashScreen] User is authenticated: ${authService.currentUser!.uid}');
          
          setState(() {
            _progress = 0.5;
            _loadingMessage = '프로필 불러오는 중';
          });
          
          // UserService가 Firebase에서 사용자 정보를 로드할 시간을 줌 (최대 5초)
          int retries = 0;
          const maxRetries = 25; // 200ms * 25 = 5초
          
          debugPrint('🔐 [SplashScreen] Waiting for UserService to load user data...');
          while (userService.currentUser == null && retries < maxRetries) {
            await Future.delayed(const Duration(milliseconds: 200));
            retries++;
            
            // 진행률 업데이트 (0.5 -> 0.8)
            setState(() {
              _progress = 0.5 + (0.3 * (retries / maxRetries));
            });
            
            if (retries % 5 == 0) { // 1초마다 로그 출력
              debugPrint('🔐 [SplashScreen] Still waiting for user data... ($retries/$maxRetries)');
            }
          }
          
          // UserService에서 사용자 정보 설정
          if (userService.currentUser != null) {
            debugPrint('✅ [SplashScreen] User data loaded successfully: ${userService.currentUser!.nickname}');
            debugPrint('🔐 [SplashScreen] Setting user info for PersonaService: ${userService.currentUser!.gender}, genderAll: ${userService.currentUser!.genderAll}');
            personaService.setCurrentUser(userService.currentUser!);
            
            setState(() {
              _progress = 0.9;
              _loadingMessage = '페르소나 준비 중';
            });
            
            // PersonaService 초기화
            debugPrint('🔐 [SplashScreen] Initializing PersonaService...');
            await personaService.initialize(userId: authService.currentUser!.uid);
            
            setState(() {
              _progress = 1.0;
              _loadingMessage = '완료!';
            });
            
            await Future.delayed(const Duration(milliseconds: 300));
            
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
          setState(() {
            _progress = 1.0;
            _loadingMessage = '환영합니다!';
          });
          await Future.delayed(const Duration(milliseconds: 500));
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
          title: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SonaLogo(size: 40, showText: true),
              const SizedBox(height: 12),
              Text(
                AppLocalizations.of(context)!.welcomeMessage,
                style: const TextStyle(
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
                AppLocalizations.of(context)!.aiDatingQuestion,
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
                    child: Text(
                      AppLocalizations.of(context)!.loginSignup,
                      style: const TextStyle(
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
    
    // 진행률 초기화
    setState(() {
      _progress = 0.1;
      _loadingMessage = '익명 로그인 중';
      _showProgress = true;
    });
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Container(
            color: Colors.black54,
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(
                      color: Color(0xFFFF6B9D),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '로그인 중...',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFFFF6B9D),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

    setState(() {
      _progress = 0.5;
      _loadingMessage = '계정 생성 중';
    });

    final success = await authService.signInAnonymously();
    
    if (mounted) {
      Navigator.of(context).pop(); // 로딩 다이얼로그 닫기
      
      if (success) {
        setState(() {
          _progress = 1.0;
          _loadingMessage = '완료!';
        });
        await Future.delayed(const Duration(milliseconds: 300));
        Navigator.of(context).pushNamedAndRemoveUntil('/main', (route) => false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.loginFailedTryAgain),
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
                      Text(
                        AppLocalizations.of(context)!.emotionBasedEncounters,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const SizedBox(height: 60),
                      
                      // 진행률 표시
                      if (_showProgress) ...[
                        Container(
                          width: 280,
                          child: Column(
                            children: [
                              // 진행률 바 컨테이너
                              Container(
                                height: 16,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.white.withOpacity(0.3),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.5),
                                    width: 1,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(7),
                                  child: Stack(
                                    children: [
                                      // 진행률 바
                                      AnimatedContainer(
                                        duration: const Duration(milliseconds: 300),
                                        width: 278 * _progress,
                                        height: 14,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.white.withOpacity(0.9),
                                              Colors.white,
                                            ],
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                          ),
                                        ),
                                      ),
                                      // 반짝이는 효과
                                      if (_progress > 0 && _progress < 1)
                                        Positioned(
                                          left: (_progress * 278) - 30,
                                          child: Container(
                                            width: 30,
                                            height: 14,
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  Colors.white.withOpacity(0),
                                                  Colors.white.withOpacity(0.6),
                                                  Colors.white.withOpacity(0),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              // 퍼센트 표시
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  '${(_progress * 100).toStringAsFixed(0)}%',
                                  style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              // 로딩 메시지
                              Text(
                                _loadingMessage,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ] else
                        // 진행률 표시 전 로딩 인디케이터
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