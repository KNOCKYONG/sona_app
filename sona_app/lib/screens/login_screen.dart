import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth/auth_service.dart';
import '../services/auth/user_service.dart';
import '../services/persona/persona_service.dart';
import '../widgets/common/sona_logo.dart';
import '../theme/app_theme.dart';
import 'signup_screen.dart';
import '../utils/network_utils.dart';
import '../l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  late TabController _tabController;
  bool _isLoading = false;
  bool _obscurePassword = true;

  // 로그인 상태 관리
  String? _currentError;
  bool _showPasswordReset = false;
  bool _isPasswordResetLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // 입력 필드 변경 시 에러 상태 초기화
    _emailController.addListener(_clearErrorOnChange);
    _passwordController.addListener(_clearErrorOnChange);
  }

  void _clearErrorOnChange() {
    if (_currentError != null) {
      setState(() {
        _currentError = null;
        _showPasswordReset = false;
      });
    }
  }

  @override
  void dispose() {
    _emailController.removeListener(_clearErrorOnChange);
    _passwordController.removeListener(_clearErrorOnChange);
    _emailController.dispose();
    _passwordController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _handleEmailLogin() async {
    if (!_formKey.currentState!.validate()) return;

    debugPrint(
        '📧 [LoginScreen] Starting email login for: ${_emailController.text.trim()}');

    // 이전 상태 초기화
    setState(() {
      _currentError = null;
      _showPasswordReset = false;
    });

    // 네트워크 연결 확인
    final isConnected = await NetworkUtils.isConnected();
    if (!isConnected && mounted) {
      debugPrint('❌ [LoginScreen] Network connection failed');
      setState(() {
        _currentError = AppLocalizations.of(context)!.checkInternetConnection;
      });
      return;
    }

    setState(() => _isLoading = true);

    try {
      final userService = Provider.of<UserService>(context, listen: false);
      debugPrint('📧 [LoginScreen] Calling UserService.signInWithEmail...');
      final user = await userService.signInWithEmail(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (user != null && mounted) {
        debugPrint(
            '✅ [LoginScreen] Login successful, initializing PersonaService...');
        
        // PersonaService 초기화 추가
        final personaService = Provider.of<PersonaService>(context, listen: false);
        
        // Firebase Auth 토큰 전파를 위한 짧은 딜레이
        await Future.delayed(const Duration(milliseconds: 500));
        debugPrint('🔄 [LoginScreen] Initializing PersonaService for user: ${user.uid}');
        
        try {
          await personaService.initialize(userId: user.uid);
          debugPrint('✅ [LoginScreen] PersonaService initialized successfully');
        } catch (e) {
          debugPrint('⚠️ [LoginScreen] PersonaService initialization error (continuing): $e');
          // PersonaService 초기화 실패해도 계속 진행 (PersonaSelectionScreen에서 재시도)
        }
        
        debugPrint('✅ [LoginScreen] Navigating to main screen');
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/main', (route) => false);
      } else if (mounted) {
        final errorMessage =
            userService.error ?? 'Unknown login error occurred';
        debugPrint('❌ [LoginScreen] Login failed: $errorMessage');
        _handleLoginError(errorMessage);
      }
    } catch (e) {
      debugPrint('❌ [LoginScreen] Unexpected error during login: $e');
      if (mounted) {
        _handleLoginError(
            '${AppLocalizations.of(context)!.unexpectedLoginError}: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _handleLoginError(String errorMessage) {
    setState(() {
      _currentError = errorMessage;
      // 비밀번호 관련 오류이거나 등록되지 않은 이메일일 때 비밀번호 찾기 버튼 표시
      _showPasswordReset = errorMessage.contains('비밀번호') ||
          errorMessage.contains('등록되지 않은') ||
          errorMessage.contains('올바르지 않습니다') ||
          errorMessage.contains('user-not-found') ||
          errorMessage.contains('wrong-password') ||
          errorMessage.contains('invalid-credential');
    });
  }

  Future<void> _handleGoogleSignIn() async {
    debugPrint('🔵 [LoginScreen] Starting Google Sign-In...');

    // 이전 상태 초기화
    setState(() {
      _currentError = null;
      _showPasswordReset = false;
    });

    // 네트워크 연결 확인
    final isConnected = await NetworkUtils.isConnected();
    if (!isConnected && mounted) {
      debugPrint(
          '❌ [LoginScreen] Network connection failed for Google Sign-In');
      setState(() {
        _currentError = AppLocalizations.of(context)!.checkInternetConnection;
      });
      return;
    }

    setState(() => _isLoading = true);

    try {
      final userService = Provider.of<UserService>(context, listen: false);
      debugPrint('🔵 [LoginScreen] Calling UserService.signInWithGoogle...');
      final firebaseUser = await userService.signInWithGoogle();

      if (firebaseUser != null && mounted) {
        debugPrint('✅ [LoginScreen] Google Sign-In successful');
        // 기존 사용자인지 확인
        if (userService.currentUser != null) {
          // 기존 사용자 - 페르소나 선택 화면으로
          debugPrint(
              '✅ [LoginScreen] Existing user, navigating to main screen');
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/main', (route) => false);
        } else {
          // 신규 사용자 - 추가 정보 입력 화면으로
          debugPrint('🆕 [LoginScreen] New user, navigating to signup screen');
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const SignUpScreen(isGoogleSignUp: true),
            ),
          );
        }
      } else if (mounted) {
        // 사용자가 취소했거나 다른 이유로 실패한 경우
        final errorMessage = userService.error ??
            AppLocalizations.of(context)!.googleLoginCanceled;
        debugPrint('❌ [LoginScreen] Google Sign-In failed: $errorMessage');
        _handleLoginError(errorMessage);
      }
    } catch (e) {
      debugPrint('❌ [LoginScreen] Unexpected error during Google Sign-In: $e');
      if (mounted) {
        _showErrorSnackBar(AppLocalizations.of(context)!.googleLoginError);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red[600],
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Future<void> _handlePasswordReset() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      setState(() {
        _currentError = AppLocalizations.of(context)!.passwordResetEmailPrompt;
      });
      return;
    }

    final authService = Provider.of<AuthService>(context, listen: false);
    if (!authService.isValidEmail(email)) {
      setState(() {
        _currentError = AppLocalizations.of(context)!.invalidEmailFormatError;
      });
      return;
    }

    setState(() => _isPasswordResetLoading = true);

    try {
      final success = await authService.sendPasswordResetEmail(email);

      if (success && mounted) {
        _showSuccessSnackBar(
            AppLocalizations.of(context)!.passwordResetEmailSent);
        setState(() {
          _currentError = null;
          _showPasswordReset = false;
        });
      } else if (mounted && authService.error != null) {
        setState(() {
          _currentError = authService.error!;
        });
      }
    } finally {
      if (mounted) {
        setState(() => _isPasswordResetLoading = false);
      }
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green[600],
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
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
              Color(0xFFFFE5EC),
              Color(0xFFFFB3C6),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 로고
                  const SonaLogo(),
                  const SizedBox(height: 16),

                  // 환영 메시지 통합
                  Text(
                    AppLocalizations.of(context)!.meetAIPersonas,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),

                  // 로그인/회원가입 컨테이너
                  Container(
                    constraints: const BoxConstraints(maxWidth: 400),
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppTheme.darkCardColor
                          : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // 탭 바
                        Container(
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? AppTheme.darkSurfaceColor
                                    : Colors.grey[100],
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),
                          child: TabBar(
                            controller: _tabController,
                            labelColor:
                                Theme.of(context).brightness == Brightness.dark
                                    ? AppTheme.darkPrimaryColor
                                    : AppTheme.primaryColor,
                            unselectedLabelColor:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.grey[600]
                                    : Colors.grey,
                            indicatorColor:
                                Theme.of(context).brightness == Brightness.dark
                                    ? AppTheme.darkPrimaryColor
                                    : AppTheme.primaryColor,
                            indicatorWeight: 3,
                            tabs: [
                              Tab(text: AppLocalizations.of(context)!.login),
                              Tab(text: AppLocalizations.of(context)!.signUp),
                            ],
                          ),
                        ),

                        // 탭 뷰
                        Container(
                          height: 380,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              // 로그인 탭
                              SingleChildScrollView(
                                child: _buildLoginTab(),
                              ),

                              // 회원가입 탭
                              SingleChildScrollView(
                                child: _buildSignUpTab(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // 튜토리얼 모드 버튼
                  // TextButton(
                  //   onPressed: _isLoading ? null : _handleTutorialMode,
                  //   child: const Text(
                  //     '로그인 없이 둘러보기',
                  //     style: TextStyle(
                  //       color: Colors.white70,
                  //       fontSize: 14,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginTab() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(height: 16),
          // 이메일 입력
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.email,
              hintText: 'example@email.com',
              prefixIcon: const Icon(Icons.email_outlined),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppLocalizations.of(context)!.enterEmail;
              }
              if (!value.contains('@')) {
                return AppLocalizations.of(context)!.invalidEmailFormat;
              }
              return null;
            },
          ),
          const SizedBox(height: 12),

          // 비밀번호 입력
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.password,
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
            ),
            obscureText: _obscurePassword,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppLocalizations.of(context)!.enterPassword;
              }
              return null;
            },
          ),
          const SizedBox(height: 12),

          // 로그인 버튼
          ElevatedButton(
            onPressed: _isLoading ? null : _handleEmailLogin,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: _isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    AppLocalizations.of(context)!.login,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),

          // 에러 메시지 표시
          if (_currentError != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red[200]!),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Colors.red[600],
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _currentError!,
                      style: TextStyle(
                        color: Colors.red[700],
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          // 비밀번호 찾기 버튼
          if (_showPasswordReset) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed:
                    _isPasswordResetLoading ? null : _handlePasswordReset,
                icon: _isPasswordResetLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.email_outlined),
                label: Text(
                  _isPasswordResetLoading
                      ? AppLocalizations.of(context)!.sendingEmail
                      : AppLocalizations.of(context)!.forgotPassword,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.primaryColor,
                  side: BorderSide(color: AppTheme.primaryColor),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],

          SizedBox(
              height: _showPasswordReset || _currentError != null ? 8 : 16),

          // 구분선
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 1,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[700]
                      : Colors.grey[300],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  AppLocalizations.of(context)!.or,
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey[400]
                        : Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 1,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[700]
                      : Colors.grey[300],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Google 로그인 버튼
          SizedBox(
            height: 48,
            child: OutlinedButton(
              onPressed: _isLoading ? null : _handleGoogleSignIn,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                side: BorderSide(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[700]!
                      : Colors.grey[300]!,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 18,
                    height: 18,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text(
                        'G',
                        style: TextStyle(
                          color: Color(0xFF4285F4),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    AppLocalizations.of(context)!.loginWithGoogle,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignUpTab() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 16),
        const Icon(
          Icons.favorite,
          size: 48,
          color: AppTheme.primaryColor,
        ),
        const SizedBox(height: 16),
        Text(
          AppLocalizations.of(context)!.simpleInfoRequired,
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey[400]
                : Colors.grey,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),

        // 이메일로 회원가입 버튼
        ElevatedButton(
          onPressed: _isLoading
              ? null
              : () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignUpScreen(),
                    ),
                  );
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryColor,
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            AppLocalizations.of(context)!.startWithEmail,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Google로 회원가입 버튼
        OutlinedButton.icon(
          onPressed: _isLoading ? null : _handleGoogleSignIn,
          icon: Container(
            width: 20,
            height: 20,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text(
                'G',
                style: TextStyle(
                  color: Color(0xFF4285F4),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          label: Text(
            AppLocalizations.of(context)!.startWithGoogle,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black87,
            ),
          ),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 56),
            side: BorderSide(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey[700]!
                  : Colors.grey[300]!,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }
}
