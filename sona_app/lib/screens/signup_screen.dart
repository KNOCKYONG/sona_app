import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../services/auth/user_service.dart';
import '../services/persona/persona_service.dart';
import '../theme/app_theme.dart';
import '../widgets/auth/terms_agreement_widget.dart';
import '../utils/permission_helper.dart';
import '../l10n/app_localizations.dart';

class SignUpScreen extends StatefulWidget {
  final bool isGoogleSignUp;
  final bool isAppleSignUp;

  const SignUpScreen({
    super.key,
    this.isGoogleSignUp = false,
    this.isAppleSignUp = false,
  });

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _pageController = PageController();

  // Controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nicknameController = TextEditingController();
  final _introController = TextEditingController();
  final _referralEmailController = TextEditingController(); // 추천인 이메일

  // Form data
  String? _selectedGender;
  DateTime? _selectedBirth;
  int? _selectedYear;
  int? _selectedMonth;
  int? _selectedDay;
  bool _genderAll = false;
  File? _profileImage;

  // Terms agreement
  bool _agreedToTerms = false;
  bool _agreedToPrivacy = false;
  bool _agreedToMarketing = false;

  int _currentPage = 0;
  bool _isCheckingNickname = false;
  bool _isNicknameAvailable = false; // 초기값을 false로 변경
  Timer? _nicknameCheckTimer;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nicknameController.dispose();
    _introController.dispose();
    _referralEmailController.dispose();
    _pageController.dispose();
    _nicknameCheckTimer?.cancel();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final image = await PermissionHelper.requestAndPickImage(
      context: context,
      source: ImageSource.gallery,
    );

    if (image != null) {
      setState(() {
        _profileImage = image;
      });
    }
  }

  Future<void> _checkNicknameAvailability(String nickname) async {
    if (nickname.isEmpty) return;

    setState(() {
      _isCheckingNickname = true;
    });

    final userService = context.read<UserService>();
    final isAvailable = await userService.isNicknameAvailable(nickname);

    setState(() {
      _isNicknameAvailable = isAvailable;
      _isCheckingNickname = false;
    });
  }

  void _updateSelectedBirth() {
    if (_selectedYear != null &&
        _selectedMonth != null &&
        _selectedDay != null) {
      setState(() {
        _selectedBirth =
            DateTime(_selectedYear!, _selectedMonth!, _selectedDay!);
      });
    }
  }

  List<int> _getValidDays() {
    if (_selectedYear == null || _selectedMonth == null) {
      return List.generate(31, (index) => index + 1);
    }

    // 해당 년월의 마지막 날 계산
    final lastDay = DateTime(_selectedYear!, _selectedMonth! + 1, 0).day;
    return List.generate(lastDay, (index) => index + 1);
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;

    // If gender is not selected, automatically set genderAll to true
    if (_selectedGender == null) {
      _genderAll = true;
    }

    if (!_agreedToTerms || !_agreedToPrivacy) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text(AppLocalizations.of(context)!.requiredTermsAgreement)),
      );
      return;
    }

    final userService = context.read<UserService>();

    if (widget.isGoogleSignUp) {
      // 구글 로그인 후 추가 정보 저장
      final user = await userService.completeGoogleSignUp(
        nickname: _nicknameController.text,
        gender: _selectedGender,
        birth: _selectedBirth,
        preferredAgeRange: null,
        interests: [],
        intro: _introController.text.isEmpty ? null : _introController.text,
        profileImage: _profileImage,
        purpose: null, // Optional - removed from signup
        preferredMbti: null, // Optional - removed from signup
        preferredTopics: null,
        genderAll: _genderAll,
        referralEmail: _referralEmailController.text.isEmpty 
            ? null 
            : _referralEmailController.text,
      );

      if (user != null && mounted) {
        // PersonaService 초기화 추가
        final personaService = Provider.of<PersonaService>(context, listen: false);
        
        // Firebase Auth 토큰 전파를 위한 짧은 딜레이
        await Future.delayed(const Duration(milliseconds: 500));
        debugPrint('🔄 [SignupScreen] Initializing PersonaService for new user: ${user.uid}');
        
        try {
          await personaService.initialize(userId: user.uid);
          debugPrint('✅ [SignupScreen] PersonaService initialized successfully');
        } catch (e) {
          debugPrint('⚠️ [SignupScreen] PersonaService initialization error (continuing): $e');
          // PersonaService 초기화 실패해도 계속 진행
        }
        
        Navigator.pushReplacementNamed(context, '/main');
      }
    } else if (widget.isAppleSignUp) {
      // Apple 로그인 후 추가 정보 저장
      final user = await userService.completeAppleSignUp(
        nickname: _nicknameController.text,
        gender: _selectedGender,
        birth: _selectedBirth,
        preferredAgeRange: null,
        interests: [],
        intro: _introController.text.isEmpty ? null : _introController.text,
        profileImage: _profileImage,
        purpose: null, // Optional - removed from signup
        preferredMbti: null, // Optional - removed from signup
        preferredTopics: null,
        genderAll: _genderAll,
        referralEmail: _referralEmailController.text.isEmpty 
            ? null 
            : _referralEmailController.text,
      );

      if (user != null && mounted) {
        // PersonaService 초기화 추가
        final personaService = Provider.of<PersonaService>(context, listen: false);
        
        // Firebase Auth 토큰 전파를 위한 짧은 딜레이
        await Future.delayed(const Duration(milliseconds: 500));
        debugPrint('🔄 [SignupScreen] Initializing PersonaService for new Apple user: ${user.uid}');
        
        try {
          await personaService.initialize(userId: user.uid);
          debugPrint('✅ [SignupScreen] PersonaService initialized successfully');
        } catch (e) {
          debugPrint('⚠️ [SignupScreen] PersonaService initialization error (continuing): $e');
          // PersonaService 초기화 실패해도 계속 진행
        }
        
        Navigator.pushReplacementNamed(context, '/main');
      }
    } else {
      // 이메일/비밀번호 회원가입
      final user = await userService.signUpWithEmail(
        email: _emailController.text,
        password: _passwordController.text,
        nickname: _nicknameController.text,
        gender: _selectedGender,
        birth: _selectedBirth,
        preferredAgeRange: null,
        interests: [],
        intro: _introController.text.isEmpty ? null : _introController.text,
        profileImage: _profileImage,
        purpose: null, // Optional - removed from signup
        preferredMbti: null, // Optional - removed from signup
        preferredTopics: null,
        genderAll: _genderAll,
        referralEmail: _referralEmailController.text.isEmpty 
            ? null 
            : _referralEmailController.text,
      );

      if (user != null && mounted) {
        // PersonaService 초기화 추가
        final personaService = Provider.of<PersonaService>(context, listen: false);
        
        // Firebase Auth 토큰 전파를 위한 짧은 딜레이
        await Future.delayed(const Duration(milliseconds: 500));
        debugPrint('🔄 [SignupScreen] Initializing PersonaService for new user: ${user.uid}');
        
        try {
          await personaService.initialize(userId: user.uid);
          debugPrint('✅ [SignupScreen] PersonaService initialized successfully');
        } catch (e) {
          debugPrint('⚠️ [SignupScreen] PersonaService initialization error (continuing): $e');
          // PersonaService 초기화 실패해도 계속 진행
        }
        
        Navigator.pushReplacementNamed(context, '/main');
      }
    }

    // 에러 처리
    if (userService.error != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(userService.error!)),
      );
    }
  }

  void _nextPage() {
    // 현재 페이지의 유효성 검사
    bool canProceed = false;

    switch (_currentPage) {
      case 0: // 계정 & 프로필 페이지
        canProceed = _validateAccountAndProfile();
        break;
      case 1: // 약관 동의 페이지
        canProceed = _validateTermsAgreement();
        break;
    }

    if (canProceed && _currentPage < 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  bool _validateAccountAndProfile() {
    // 이메일 가입인 경우
    if (!widget.isGoogleSignUp && !widget.isAppleSignUp) {
      // 이메일 검사
      if (_emailController.text.isEmpty) {
        _showErrorSnackBar(AppLocalizations.of(context)!.enterEmail);
        return false;
      }
      if (!_emailController.text.contains('@')) {
        _showErrorSnackBar(AppLocalizations.of(context)!.invalidEmailFormat);
        return false;
      }

      // 비밀번호 검사
      if (_passwordController.text.isEmpty) {
        _showErrorSnackBar(AppLocalizations.of(context)!.enterPassword);
        return false;
      }
      if (_passwordController.text.length < 6) {
        _showErrorSnackBar(AppLocalizations.of(context)!.passwordTooShort);
        return false;
      }
    }

    // 닉네임 검사
    if (_nicknameController.text.isEmpty) {
      _showErrorSnackBar(AppLocalizations.of(context)!.enterNickname);
      return false;
    }
    if (_nicknameController.text.length < 2 ||
        _nicknameController.text.length > 10) {
      _showErrorSnackBar(AppLocalizations.of(context)!.nicknameLengthError);
      return false;
    }
    if (!_isNicknameAvailable) {
      _showErrorSnackBar(AppLocalizations.of(context)!.nicknameAlreadyUsed);
      return false;
    }

    // 성별과 생년월일은 이제 선택사항이므로 체크하지 않음
    // 자기소개도 선택사항

    return true;
  }



  bool _validateTermsAgreement() {
    if (!_agreedToTerms) {
      _showErrorSnackBar(AppLocalizations.of(context)!.serviceTermsAgreement);
      return false;
    }
    if (!_agreedToPrivacy) {
      _showErrorSnackBar(AppLocalizations.of(context)!.privacyPolicyAgreement);
      return false;
    }
    return true;
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  bool _canProceedToNextPage() {
    switch (_currentPage) {
      case 0: // 계정 & 프로필 페이지
        // 이메일 가입인 경우
        if (!widget.isGoogleSignUp && !widget.isAppleSignUp) {
          if (_emailController.text.isEmpty ||
              !_emailController.text.contains('@') ||
              _passwordController.text.isEmpty ||
              _passwordController.text.length < 6) {
            return false;
          }
        }
        // 닉네임 검사
        bool nicknameValid = _nicknameController.text.length >= 3 &&
            _nicknameController.text.length <= 10 &&
            _isNicknameAvailable &&
            !_isCheckingNickname;
        // 성별과 생년월일은 선택사항이므로 검사하지 않음
        return nicknameValid;

      case 1: // 약관 동의 페이지
        return _agreedToTerms && _agreedToPrivacy;

      default:
        return false;
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userService = context.watch<UserService>();
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.signup),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Progress indicator
              LinearProgressIndicator(
                value: (_currentPage + 1) / 2,
                backgroundColor: Colors.grey[300],
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppTheme.primaryColor,
                ),
              ),

              // Page content
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (page) {
                    setState(() {
                      _currentPage = page;
                    });
                  },
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildAccountAndProfilePage(), // 통합된 계정 & 프로필 페이지
                    _buildTermsAgreementPage(),
                  ],
                ),
              ),

              // Navigation buttons
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (_currentPage > 0)
                      TextButton(
                        onPressed: _previousPage,
                        child: Text(AppLocalizations.of(context)!.previous),
                      )
                    else
                      const SizedBox(width: 60),
                    if (_currentPage < 1)
                      ElevatedButton(
                        onPressed: _canProceedToNextPage() ? _nextPage : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _canProceedToNextPage()
                              ? AppTheme.primaryColor
                              : Colors.grey[300],
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 12,
                          ),
                        ),
                        child: Text(
                          localizations.next,
                          style: TextStyle(
                            color: _canProceedToNextPage()
                                ? Colors.white
                                : Colors.grey[600],
                          ),
                        ),
                      )
                    else
                      ElevatedButton(
                        onPressed: userService.isLoading ? null : _signUp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 12,
                          ),
                        ),
                        child: userService.isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : Text(
                                AppLocalizations.of(context)!.completeSignup),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 통합된 계정 & 프로필 페이지
  Widget _buildAccountAndProfilePage() {
    final localizations = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '계정 & 프로필 정보',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.enterBasicInformation,
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),

          // Profile image (선택)
          Center(
            child: GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[200],
                  image: _profileImage != null
                      ? DecorationImage(
                          image: FileImage(_profileImage!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: _profileImage == null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.camera_alt, size: 32, color: Colors.grey),
                          Text(
                            localizations.optional,
                            style: TextStyle(color: Colors.grey, fontSize: 10),
                          ),
                        ],
                      )
                    : null,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Email & Password (이메일 가입시에만)
          if (!widget.isGoogleSignUp && !widget.isAppleSignUp) ...[
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: localizations.emailRequired,
                hintText: localizations.emailHint,
                prefixIcon: Icon(Icons.email_outlined),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return localizations.enterEmail;
                }
                if (!value.contains('@')) {
                  return localizations.invalidEmailFormat;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: localizations.passwordRequired,
                hintText: localizations.passwordHint,
                prefixIcon: Icon(Icons.lock_outline),
              ),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return localizations.enterPassword;
                }
                if (value.length < 6) {
                  return localizations.passwordTooShort;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
          ],

          // Nickname
          TextFormField(
            controller: _nicknameController,
            decoration: InputDecoration(
              labelText: localizations.nicknameLabel,
              hintText: '3~10자 한글/영문/숫자',
              prefixIcon: const Icon(Icons.person_outline),
              suffixIcon: _isCheckingNickname
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : _nicknameController.text.isNotEmpty
                      ? Icon(
                          _isNicknameAvailable &&
                                  _nicknameController.text.length >= 3 &&
                                  _nicknameController.text.length <= 10
                              ? Icons.check_circle
                              : Icons.error,
                          color: _isNicknameAvailable &&
                                  _nicknameController.text.length >= 3 &&
                                  _nicknameController.text.length <= 10
                              ? Colors.green
                              : Colors.red,
                        )
                      : null,
            ),
            onChanged: (value) {
              // 타이머 취소
              _nicknameCheckTimer?.cancel();

              // 닉네임이 비어있거나 길이가 맞지 않으면 검사하지 않음
              if (value.isEmpty || value.length < 3 || value.length > 10) {
                setState(() {
                  _isNicknameAvailable = false;
                  _isCheckingNickname = false;
                });
                return;
              }

              // 500ms 후에 중복 확인
              setState(() {
                _isCheckingNickname = true;
              });

              _nicknameCheckTimer =
                  Timer(const Duration(milliseconds: 500), () {
                _checkNicknameAvailability(value);
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return localizations.enterNickname;
              }
              if (value.length < 3 || value.length > 10) {
                return '닉네임은 3~10자로 입력해주세요';
              }
              if (!_isNicknameAvailable && value.length >= 3) {
                return localizations.nicknameAlreadyUsed;
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Referral Email (선택)
          TextFormField(
            controller: _referralEmailController,
            decoration: InputDecoration(
              labelText: '추천인 이메일 (선택)',
              hintText: AppLocalizations.of(context)!.referrerEmail,
              prefixIcon: const Icon(Icons.people_outline),
              helperText: '친구의 추천으로 가입하시나요?',
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              // 선택 필드이므로 비어있어도 OK
              if (value != null && value.isNotEmpty) {
                if (!value.contains('@')) {
                  return AppLocalizations.of(context)!.invalidEmailFormat;
                }
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Gender (선택)
          Text(localizations.genderOptional,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          // 성별 미선택 시 안내 메시지
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, size: 16, color: Colors.blue),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    localizations.genderNotSelectedInfo,
                    style: TextStyle(fontSize: 12, color: Colors.blue[700]),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: RadioListTile<String>(
                  title: Text(localizations.male),
                  value: 'male',
                  groupValue: _selectedGender,
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value;
                    });
                  },
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              Expanded(
                child: RadioListTile<String>(
                  title: Text(localizations.female),
                  value: 'female',
                  groupValue: _selectedGender,
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value;
                    });
                  },
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
          RadioListTile<String>(
            title: Text(localizations.other),
            value: 'other',
            groupValue: _selectedGender,
            onChanged: (value) {
              setState(() {
                _selectedGender = value;
              });
            },
            contentPadding: EdgeInsets.zero,
          ),
          const SizedBox(height: 16),

          // Birth date (선택)
          Text(localizations.birthDateOptional,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          // 생년월일 미선택 시 안내 메시지
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    localizations.canChangeInSettings,
                    style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              // 년도 드롭다운
              Expanded(
                child: DropdownButtonFormField<int>(
                  decoration: InputDecoration(
                    labelText: localizations.year,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  value: _selectedYear,
                  items: List.generate(
                    82, // 18세부터 99세까지
                    (index) {
                      final year = DateTime.now().year - 18 - index;
                      return DropdownMenuItem(
                        value: year,
                        child: Text('$year'),
                      );
                    },
                  ),
                  onChanged: (value) {
                    setState(() {
                      _selectedYear = value;
                      if (_selectedDay != null &&
                          _selectedDay! > _getValidDays().length) {
                        _selectedDay = null;
                      }
                      _updateSelectedBirth();
                    });
                  },
                ),
              ),
              const SizedBox(width: 8),
              // 월 드롭다운
              Expanded(
                child: DropdownButtonFormField<int>(
                  decoration: InputDecoration(
                    labelText: localizations.month,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  value: _selectedMonth,
                  items: List.generate(
                    12,
                    (index) => DropdownMenuItem(
                      value: index + 1,
                      child: Text('${index + 1}'),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _selectedMonth = value;
                      if (_selectedDay != null &&
                          _selectedDay! > _getValidDays().length) {
                        _selectedDay = null;
                      }
                      _updateSelectedBirth();
                    });
                  },
                ),
              ),
              const SizedBox(width: 8),
              // 일 드롭다운
              Expanded(
                child: DropdownButtonFormField<int>(
                  decoration: InputDecoration(
                    labelText: localizations.day,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  value: _selectedDay,
                  items: _getValidDays()
                      .map((day) => DropdownMenuItem(
                            value: day,
                            child: Text('$day'),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedDay = value;
                      _updateSelectedBirth();
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Introduction (선택)
          TextFormField(
            controller: _introController,
            decoration: InputDecoration(
              labelText: localizations.selfIntroduction,
              hintText: localizations.selfIntroductionHint,
              alignLabelWithHint: true,
            ),
            maxLines: 3,
            maxLength: 100,
          ),
          const SizedBox(height: 16),

          // Gender preference (선택)
          Text(
            localizations.personaGenderPreference,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          CheckboxListTile(
            title: Text(localizations.showAllGenders),
            subtitle: Text(localizations.showOppositeGenderOnly),
            value: _genderAll,
            onChanged: (value) {
              setState(() {
                _genderAll = value ?? false;
              });
            },
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
          ),
          const SizedBox(height: 16),

          // Removed preferred age range - now using default [20, 35]
        ],
      ),
    );
  }


  Widget _buildTermsAgreementPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.termsAgreement,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.termsAgreementDescription,
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 32),
          TermsAgreementWidget(
            agreedToTerms: _agreedToTerms,
            agreedToPrivacy: _agreedToPrivacy,
            agreedToMarketing: _agreedToMarketing,
            onTermsChanged: (value) {
              setState(() {
                _agreedToTerms = value;
              });
            },
            onPrivacyChanged: (value) {
              setState(() {
                _agreedToPrivacy = value;
              });
            },
            onMarketingChanged: (value) {
              setState(() {
                _agreedToMarketing = value;
              });
            },
          ),
        ],
      ),
    );
  }


}