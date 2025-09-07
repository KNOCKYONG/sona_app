import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animations/animations.dart';
import '../services/auth/auth_service.dart';
import '../services/auth/user_service.dart';
import '../services/persona/persona_service.dart';
import '../services/chat/core/chat_service.dart';
import '../widgets/common/sona_logo.dart';
import '../l10n/app_localizations.dart';
import '../utils/network_utils.dart';
import '../widgets/no_network_dialog.dart';

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
  double _targetProgress = 0.0; // 목표 진행률 (스무스 애니메이션용)
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
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_animationStarted) {
      _animationStarted = true;
      _startAnimation();
    }
  }

  bool _animationStarted = false;

  void _startAnimation() async {
    // 애니메이션 시작과 동시에 진행률 표시
    setState(() {
      _showProgress = true;
      _loadingMessage = AppLocalizations.of(context)!.startingApp;
      _targetProgress = 0.1;
    });
    _animateProgress();

    await _animationController.forward();

    if (mounted) {
      // First check network connectivity
      debugPrint('🌐 [SplashScreen] Checking network connectivity...');
      final isConnected = await NetworkUtils.isConnected();
      
      if (!isConnected) {
        debugPrint('❌ [SplashScreen] No network connection detected');
        _showNoNetworkDialog();
        return; // Stop here until network is available
      }
      
      debugPrint('✅ [SplashScreen] Network connection verified');
      // Continue with initialization after network check passes
      _continueInitialization();
    }
  }

  // 스무스한 프로그레스 애니메이션
  void _animateProgress() {
    if (!mounted) return;
    
    // 현재 진행률이 목표에 도달하지 않았으면 계속 애니메이션
    if (_progress < _targetProgress) {
      setState(() {
        _progress = _progress + ((_targetProgress - _progress) * 0.1);
        if ((_targetProgress - _progress).abs() < 0.001) {
          _progress = _targetProgress;
        }
      });
      Future.delayed(const Duration(milliseconds: 16), _animateProgress);
    }
  }

  void _updateProgress(double target, String? message) {
    if (!mounted) return;
    setState(() {
      _targetProgress = target;
      if (message != null) _loadingMessage = message;
    });
    _animateProgress();
  }

  void _showNoNetworkDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: NoNetworkDialog(
          onRetry: () async {
            Navigator.of(context).pop();
            // Re-check network after user clicks retry
            debugPrint('🔄 [SplashScreen] Retrying network connection...');
            final isConnected = await NetworkUtils.isConnected();
            
            if (isConnected) {
              debugPrint('✅ [SplashScreen] Network connection restored');
              // Continue with normal initialization
              _continueInitialization();
            } else {
              debugPrint('❌ [SplashScreen] Still no network connection');
              // Show dialog again
              _showNoNetworkDialog();
            }
          },
        ),
      ),
    );
  }
  
  void _continueInitialization() async {
    debugPrint('🚀 [SplashScreen] Continuing with initialization...');
    
    _updateProgress(0.2, AppLocalizations.of(context)!.checkingUserInfo);

    final authService = Provider.of<AuthService>(context, listen: false);
    final userService = Provider.of<UserService>(context, listen: false);
    final personaService = Provider.of<PersonaService>(context, listen: false);

    try {
      // Firebase Auth 상태가 초기화될 때까지 대기
      debugPrint('🚀 [SplashScreen] Waiting for Firebase Auth initialization...');
      setState(() {
        _targetProgress = 0.3;
        _loadingMessage = AppLocalizations.of(context)!.connectingToServer;
      });
      await Future.delayed(const Duration(seconds: 1));

      // Auth 상태가 아직 로드되지 않았으면 추가 대기
      if (authService.user == null) {
        debugPrint('🚀 [SplashScreen] Auth user is null, waiting for auth state...');
        setState(() {
          _targetProgress = 0.4;
          _loadingMessage = AppLocalizations.of(context)!.verifyingAuth;
        });
        await authService.waitForAuthState();
      }

      debugPrint('🚀 [SplashScreen] Auth state check completed. Authenticated: ${authService.isAuthenticated}');

      // Continue with the rest of the existing initialization code...
      // (The rest of the code is the same as before)
      if (authService.isAuthenticated && authService.currentUser != null) {
        // ... existing authentication flow ...
        _continueAuthenticatedFlow(authService, userService, personaService);
      } else {
        // ... existing guest flow ...
        _continueGuestFlow(personaService);
      }
    } catch (e) {
      debugPrint('❌ [SplashScreen] Error during auth initialization: $e');
      _showWelcomeDialog();
    }
  }
  
  void _continueAuthenticatedFlow(AuthService authService, UserService userService, PersonaService personaService) async {
    // Move all authenticated user flow here
    debugPrint('🔐 [SplashScreen] User is authenticated: ${authService.currentUser!.uid}');

    _updateProgress(0.5, AppLocalizations.of(context)!.loadingProfile);

    // UserService가 Firebase에서 사용자 정보를 로드할 시간을 줌 (최대 5초)
    int retries = 0;
    const maxRetries = 25; // 200ms * 25 = 5초

    debugPrint('🔐 [SplashScreen] Waiting for UserService to load user data...');
    while (userService.currentUser == null && retries < maxRetries) {
      await Future.delayed(const Duration(milliseconds: 200));
      retries++;

      // 진행률 업데이트 (0.5 -> 0.8)
      _updateProgress(0.5 + (0.3 * (retries / maxRetries)), null);

      if (retries % 5 == 0) {
        // 1초마다 로그 출력
        debugPrint('🔐 [SplashScreen] Still waiting for user data... ($retries/$maxRetries)');
      }
    }

    // UserService에서 사용자 정보 설정
    if (userService.currentUser != null) {
      debugPrint('✅ [SplashScreen] User data loaded successfully: ${userService.currentUser!.nickname}');
      debugPrint('🔐 [SplashScreen] Setting user info for PersonaService: ${userService.currentUser!.gender}, genderAll: ${userService.currentUser!.genderAll}');
      personaService.setCurrentUser(userService.currentUser!);

      // PersonaService 완전 초기화 - 진행률 표시와 함께
      debugPrint('🔐 [SplashScreen] Starting full PersonaService initialization...');
      
      // 베이스 진행률 0.6에서 시작
      final baseProgress = 0.6;
      await personaService.initialize(
        userId: authService.currentUser!.uid,
        onProgress: (progress, message) {
          // PersonaService의 진행률 (0.0~1.0)을 0.6~0.9 범위로 매핑
          final mappedProgress = baseProgress + (progress * 0.3);
          
          // Translate message keys to localized strings
          String localizedMessage = message;
          final l10n = AppLocalizations.of(context)!;
          
          // Map message keys to localized strings
          if (message == 'loadingPersonaData') {
            localizedMessage = l10n.loadingPersonaData;
          } else if (message == 'checkingMatchedPersonas') {
            localizedMessage = l10n.checkingMatchedPersonas;
          } else if (message == 'preparingImages') {
            localizedMessage = l10n.preparingImages;
          } else if (message == 'finalPreparation') {
            localizedMessage = l10n.finalPreparation;
          } else if (message == 'complete') {
            localizedMessage = l10n.complete;
          }
          
          _updateProgress(mappedProgress, localizedMessage);
          
          // 페르소나 개수 표시를 위한 특별 처리
          if (message == 'loadingPersonaData' && personaService.allPersonas.isNotEmpty) {
            final count = personaService.allPersonas.length;
            _updateProgress(mappedProgress, '$localizedMessage ($count)');
          } else if (message == 'checkingMatchedPersonas' && personaService.matchedPersonas.isNotEmpty) {
            final count = personaService.matchedPersonas.length;
            _updateProgress(mappedProgress, '$localizedMessage ($count)');
          }
        },
      );
      
      debugPrint('✅ [SplashScreen] PersonaService fully loaded with ${personaService.allPersonas.length} personas');
      debugPrint('✅ [SplashScreen] Matched personas: ${personaService.matchedPersonas.length}');

      // 대화 데이터 미리 로드
      if (personaService.matchedPersonas.isNotEmpty) {
        _updateProgress(0.9, 'Loading conversations...');
        
        final chatService = Provider.of<ChatService>(context, listen: false);
        chatService.setCurrentUserId(authService.currentUser!.uid);
        
        // 최대 5개의 매칭된 페르소나 대화만 미리 로드 (성능 최적화)
        final personasToPreload = personaService.matchedPersonas.take(5).toList();
        final chatFutures = <Future<void>>[];
        
        for (final persona in personasToPreload) {
          debugPrint('💬 [SplashScreen] Preloading chat for ${persona.name}');
          chatFutures.add(
            chatService.loadChatHistory(authService.currentUser!.uid, persona.id)
          );
        }
        
        await Future.wait(chatFutures);
        debugPrint('✅ [SplashScreen] Chat histories preloaded for ${personasToPreload.length} personas');
        
        _updateProgress(0.95, AppLocalizations.of(context)!.readyToChat);
      }

      _updateProgress(1.0, AppLocalizations.of(context)!.complete);

      await Future.delayed(const Duration(milliseconds: 300));

      debugPrint('✅ [SplashScreen] All services ready, navigating to main screen');
      Navigator.of(context).pushNamedAndRemoveUntil('/main', (route) => false);
    } else {
      debugPrint('❌ [SplashScreen] UserService.currentUser is still null after waiting. This might indicate a Firestore issue.');
      debugPrint('❌ [SplashScreen] Showing welcome dialog to allow re-login');
      _showWelcomeDialog();
    }
  }
  
  void _continueGuestFlow(PersonaService personaService) async {
    debugPrint('🔐 [SplashScreen] User is not authenticated, initializing for guest');
    
    // 게스트 사용자도 PersonaService 초기화 (첫 설치 무한 로딩 방지)
    _updateProgress(0.5, AppLocalizations.of(context)!.preparingPersonas);
    
    try {
      debugPrint('🔐 [SplashScreen] Initializing PersonaService for guest user...');
      
      // PersonaService 초기화 (게스트는 userId null로)
      await personaService.initialize(
        userId: null,
        onProgress: (progress, message) {
          // 진행률 0.5~0.9 범위로 매핑
          final mappedProgress = 0.5 + (progress * 0.4);
          _updateProgress(mappedProgress, message);
          
          // 페르소나 개수 표시
          if (message.contains('Persona data') && personaService.allPersonas.isNotEmpty) {
            final count = personaService.allPersonas.length;
            _updateProgress(mappedProgress, AppLocalizations.of(context)!.preparingPersonasCount(count.toString()));
          }
        },
      );
      
      debugPrint('✅ [SplashScreen] Guest PersonaService loaded with ${personaService.allPersonas.length} personas');
    } catch (e) {
      debugPrint('⚠️ [SplashScreen] Error initializing PersonaService for guest: $e');
      // 에러가 발생해도 계속 진행 (로컬 데이터 사용)
    }
    
    // 로그인되지 않은 경우
    _updateProgress(1.0, AppLocalizations.of(context)!.guestModeWelcome);
    await Future.delayed(const Duration(milliseconds: 500));
    _showWelcomeDialog();
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
              const Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly),
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
      _loadingMessage = AppLocalizations.of(context)!.anonymousLogin;
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
                      AppLocalizations.of(context)!.loggingIn,
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
      _loadingMessage = AppLocalizations.of(context)!.creatingAccount;
    });

    final success = await authService.signInAnonymously();

    if (mounted) {
      Navigator.of(context).pop(); // 로딩 다이얼로그 닫기

      if (success) {
        setState(() {
          _progress = 1.0;
          _loadingMessage = AppLocalizations.of(context)!.complete;
        });
        await Future.delayed(const Duration(milliseconds: 300));
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/main', (route) => false);
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

                      // 진행률 표시 (퍼센티지만)
                      if (_showProgress) ...[
                        Column(
                          children: [
                            // 퍼센트 표시
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '${(_progress * 100).toStringAsFixed(0)}%',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  letterSpacing: 1,
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
                      ] else
                        // 진행률 표시 전 로딩 인디케이터
                        const CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
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
