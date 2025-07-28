import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../services/auth/user_service.dart';
import '../models/app_user.dart';
import '../theme/app_theme.dart';
import '../widgets/auth/terms_agreement_widget.dart';
import '../utils/permission_helper.dart';

class SignUpScreen extends StatefulWidget {
  final bool isGoogleSignUp;
  
  const SignUpScreen({
    super.key,
    this.isGoogleSignUp = false,
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
  
  // Form data
  String? _selectedGender;
  DateTime? _selectedBirth;
  String _preferredGender = 'female';
  RangeValues _preferredAgeRange = const RangeValues(20, 35);
  List<String> _selectedInterests = [];
  File? _profileImage;
  
  // 새로운 필드들
  String? _selectedPurpose;
  List<String> _selectedPersonaTypes = ['normal']; // 기본값: 일반 페르소나
  List<String> _selectedPreferredMbti = [];
  String _communicationStyle = 'adaptive'; // 기본값: 적응형
  List<String> _selectedPreferredTopics = [];
  
  // Terms agreement
  bool _agreedToTerms = false;
  bool _agreedToPrivacy = false;
  bool _agreedToMarketing = false;
  
  int _currentPage = 0;
  bool _isCheckingNickname = false;
  bool _isNicknameAvailable = true;
  Timer? _nicknameCheckTimer;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nicknameController.dispose();
    _introController.dispose();
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

  Future<void> _selectBirthDate() async {
    final now = DateTime.now();
    final initialDate = _selectedBirth ?? DateTime(now.year - 25, now.month, now.day);
    
    if (Platform.isIOS) {
      await showCupertinoModalPopup(
        context: context,
        builder: (context) => Container(
          height: 300,
          color: Colors.white,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('취소'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('완료'),
                  ),
                ],
              ),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: initialDate,
                  maximumDate: DateTime(now.year - 18, now.month, now.day),
                  minimumDate: DateTime(now.year - 100, now.month, now.day),
                  onDateTimeChanged: (date) {
                    setState(() {
                      _selectedBirth = date;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      final picked = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime(now.year - 100, now.month, now.day),
        lastDate: DateTime(now.year - 18, now.month, now.day),
      );
      
      if (picked != null) {
        setState(() {
          _selectedBirth = picked;
        });
      }
    }
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (_selectedBirth == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('생년월일을 선택해주세요')),
      );
      return;
    }
    
    if (_selectedInterests.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('관심사를 최소 1개 이상 선택해주세요')),
      );
      return;
    }
    
    if (!_agreedToTerms || !_agreedToPrivacy) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('필수 약관에 동의해주세요')),
      );
      return;
    }
    
    final userService = context.read<UserService>();
    
    if (widget.isGoogleSignUp) {
      // 구글 로그인 후 추가 정보 저장
      final user = await userService.completeGoogleSignUp(
        nickname: _nicknameController.text,
        gender: _selectedGender,
        birth: _selectedBirth!,
        preferredGender: _preferredGender,
        preferredAgeRange: [
          _preferredAgeRange.start.toInt(),
          _preferredAgeRange.end.toInt(),
        ],
        interests: _selectedInterests,
        intro: _introController.text.isEmpty ? null : _introController.text,
        profileImage: _profileImage,
        purpose: _selectedPurpose,
        preferredPersonaTypes: _selectedPersonaTypes,
        preferredMbti: _selectedPreferredMbti.isEmpty ? null : _selectedPreferredMbti,
        communicationStyle: _communicationStyle,
        preferredTopics: _selectedPreferredTopics.isEmpty ? null : _selectedPreferredTopics,
      );
      
      if (user != null && mounted) {
        Navigator.pushReplacementNamed(context, '/main');
      }
    } else {
      // 이메일/비밀번호 회원가입
      final user = await userService.signUpWithEmail(
        email: _emailController.text,
        password: _passwordController.text,
        nickname: _nicknameController.text,
        gender: _selectedGender,
        birth: _selectedBirth!,
        preferredGender: _preferredGender,
        preferredAgeRange: [
          _preferredAgeRange.start.toInt(),
          _preferredAgeRange.end.toInt(),
        ],
        interests: _selectedInterests,
        intro: _introController.text.isEmpty ? null : _introController.text,
        profileImage: _profileImage,
        purpose: _selectedPurpose,
        preferredPersonaTypes: _selectedPersonaTypes,
        preferredMbti: _selectedPreferredMbti.isEmpty ? null : _selectedPreferredMbti,
        communicationStyle: _communicationStyle,
        preferredTopics: _selectedPreferredTopics.isEmpty ? null : _selectedPreferredTopics,
      );
      
      if (user != null && mounted) {
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
      case 0: // 기본 정보 페이지
        canProceed = _validateBasicInfo();
        break;
      case 1: // 프로필 정보 페이지  
        canProceed = _validateProfileInfo();
        break;
      case 2: // 사용 목적 페이지
        canProceed = _validatePurpose();
        break;
      case 3: // 선호 설정 페이지
        canProceed = _validatePreferences();
        break;
      case 4: // 관심사 페이지
        canProceed = _validateInterests();
        break;
      case 5: // 선호 주제 페이지
        canProceed = _validateTopics();
        break;
    }
    
    if (canProceed && _currentPage < 6) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
  
  bool _validateBasicInfo() {
    // 이메일 가입인 경우
    if (!widget.isGoogleSignUp) {
      // 이메일 검사
      if (_emailController.text.isEmpty) {
        _showErrorSnackBar('이메일을 입력해주세요');
        return false;
      }
      if (!_emailController.text.contains('@')) {
        _showErrorSnackBar('올바른 이메일 형식이 아닙니다');
        return false;
      }
      
      // 비밀번호 검사
      if (_passwordController.text.isEmpty) {
        _showErrorSnackBar('비밀번호를 입력해주세요');
        return false;
      }
      if (_passwordController.text.length < 6) {
        _showErrorSnackBar('비밀번호는 6자 이상이어야 합니다');
        return false;
      }
    }
    
    // 닉네임 검사
    if (_nicknameController.text.isEmpty) {
      _showErrorSnackBar('닉네임을 입력해주세요');
      return false;
    }
    if (_nicknameController.text.length < 2 || _nicknameController.text.length > 10) {
      _showErrorSnackBar('닉네임은 2-10자여야 합니다');
      return false;
    }
    if (!_isNicknameAvailable) {
      _showErrorSnackBar('이미 사용 중인 닉네임입니다');
      return false;
    }
    
    return true;
  }
  
  bool _validateProfileInfo() {
    // 성별 검사 (선택사항이므로 체크하지 않음)
    
    // 생년월일 검사 (필수)
    if (_selectedBirth == null) {
      _showErrorSnackBar('생년월일을 선택해주세요');
      return false;
    }
    
    // 자기소개는 선택사항이므로 체크하지 않음
    
    return true;
  }
  
  bool _validatePreferences() {
    // 선호 성별과 나이 범위는 기본값이 있으므로 체크하지 않음
    return true;
  }
  
  bool _validateInterests() {
    if (_selectedInterests.isEmpty) {
      _showErrorSnackBar('관심사를 최소 1개 이상 선택해주세요');
      return false;
    }
    return true;
  }
  
  bool _validatePurpose() {
    if (_selectedPurpose == null) {
      _showErrorSnackBar('사용 목적을 선택해주세요');
      return false;
    }
    return true;
  }
  
  bool _validateTopics() {
    // 선택사항이므로 항상 true
    return true;
  }
  
  bool _validateTermsAgreement() {
    if (!_agreedToTerms) {
      _showErrorSnackBar('서비스 이용약관에 동의해주세요');
      return false;
    }
    if (!_agreedToPrivacy) {
      _showErrorSnackBar('개인정보 처리방침에 동의해주세요');
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
      case 0: // 기본 정보 페이지
        // 이메일 가입인 경우
        if (!widget.isGoogleSignUp) {
          if (_emailController.text.isEmpty || 
              !_emailController.text.contains('@') ||
              _passwordController.text.isEmpty ||
              _passwordController.text.length < 6) {
            return false;
          }
        }
        // 닉네임 검사
        return _nicknameController.text.length >= 2 && 
               _nicknameController.text.length <= 10 &&
               _isNicknameAvailable &&
               !_isCheckingNickname;
               
      case 1: // 프로필 정보 페이지
        return _selectedBirth != null;
        
      case 2: // 사용 목적 페이지
        return _selectedPurpose != null;
        
      case 3: // 선호 설정 페이지
        return true; // 기본값이 있으므로 항상 true
        
      case 4: // 관심사 페이지
        return _selectedInterests.isNotEmpty;
        
      case 5: // 선호 주제 페이지
        return true; // 선택사항이므로 항상 true
        
      case 6: // 약관 동의 페이지
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
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('회원가입'),
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
                value: (_currentPage + 1) / 7,
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
                    _buildBasicInfoPage(),
                    _buildProfileInfoPage(),
                    _buildPurposePage(), // 새로운 페이지
                    _buildPreferencePage(),
                    _buildInterestsPage(),
                    _buildTopicsPage(), // 새로운 페이지
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
                        child: const Text('이전'),
                      )
                    else
                      const SizedBox(width: 60),
                    
                    if (_currentPage < 6)
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
                          '다음',
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
                            : const Text('가입완료'),
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

  Widget _buildBasicInfoPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '기본 정보',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '계정 생성을 위한 기본 정보를 입력해주세요',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 32),
          
          // Email & Password (이메일 가입시에만)
          if (!widget.isGoogleSignUp) ...[
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: '이메일 *',
                hintText: 'example@email.com',
                prefixIcon: Icon(Icons.email_outlined),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '이메일을 입력해주세요';
                }
                if (!value.contains('@')) {
                  return '올바른 이메일 형식이 아닙니다';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: '비밀번호 *',
                hintText: '6자 이상',
                prefixIcon: Icon(Icons.lock_outline),
              ),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '비밀번호를 입력해주세요';
                }
                if (value.length < 6) {
                  return '비밀번호는 6자 이상이어야 합니다';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
          ],
          
          // Nickname
          TextFormField(
            controller: _nicknameController,
            decoration: InputDecoration(
              labelText: '닉네임 *',
              hintText: '2-10자',
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
                          _isNicknameAvailable
                              ? Icons.check_circle
                              : Icons.error,
                          color: _isNicknameAvailable
                              ? Colors.green
                              : Colors.red,
                        )
                      : null,
            ),
            onChanged: (value) {
              // 타이머 취소
              _nicknameCheckTimer?.cancel();
              
              // 닉네임이 비어있거나 너무 짧으면 검사하지 않음
              if (value.isEmpty || value.length < 2) {
                setState(() {
                  _isNicknameAvailable = true;
                  _isCheckingNickname = false;
                });
                return;
              }
              
              // 500ms 후에 중복 확인
              setState(() {
                _isCheckingNickname = true;
              });
              
              _nicknameCheckTimer = Timer(const Duration(milliseconds: 500), () {
                _checkNicknameAvailability(value);
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '닉네임을 입력해주세요';
              }
              if (value.length < 2 || value.length > 10) {
                return '닉네임은 2-10자여야 합니다';
              }
              if (!_isNicknameAvailable) {
                return '이미 사용 중인 닉네임입니다';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProfileInfoPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '프로필 정보',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '프로필 사진과 기본 정보를 입력해주세요',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 32),
          
          // Profile image
          Center(
            child: GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: 120,
                height: 120,
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
                    ? const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.camera_alt, size: 40, color: Colors.grey),
                          Text(
                            '프로필 사진',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      )
                    : null,
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Center(
            child: Text(
              '선택사항',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
          const SizedBox(height: 32),
          
          // Gender
          const Text('성별', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: RadioListTile<String>(
                  title: const Text('남성'),
                  value: 'male',
                  groupValue: _selectedGender,
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value;
                    });
                  },
                ),
              ),
              Expanded(
                child: RadioListTile<String>(
                  title: const Text('여성'),
                  value: 'female',
                  groupValue: _selectedGender,
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value;
                    });
                  },
                ),
              ),
            ],
          ),
          RadioListTile<String>(
            title: const Text('기타'),
            value: 'other',
            groupValue: _selectedGender,
            onChanged: (value) {
              setState(() {
                _selectedGender = value;
              });
            },
          ),
          const SizedBox(height: 24),
          
          // Birth date
          const Text('생년월일 *', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          InkWell(
            onTap: _selectBirthDate,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _selectedBirth != null
                        ? DateFormat('yyyy년 MM월 dd일').format(_selectedBirth!)
                        : '생년월일을 선택해주세요',
                    style: TextStyle(
                      color: _selectedBirth != null ? Colors.black : Colors.grey,
                    ),
                  ),
                  const Icon(Icons.calendar_today, color: Colors.grey),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          
          // Introduction
          TextFormField(
            controller: _introController,
            decoration: const InputDecoration(
              labelText: '자기소개',
              hintText: '간단한 자기소개를 작성해주세요 (선택)',
              alignLabelWithHint: true,
            ),
            maxLines: 3,
            maxLength: 100,
          ),
        ],
      ),
    );
  }

  Widget _buildPreferencePage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '선호 설정',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'AI 페르소나 매칭을 위한 선호도를 설정해주세요',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 32),
          
          // Preferred gender
          const Text(
            '선호하는 페르소나 성별 *',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: RadioListTile<String>(
                  title: const Text('여성'),
                  value: 'female',
                  groupValue: _preferredGender,
                  onChanged: (value) {
                    setState(() {
                      _preferredGender = value!;
                    });
                  },
                ),
              ),
              Expanded(
                child: RadioListTile<String>(
                  title: const Text('남성'),
                  value: 'male',
                  groupValue: _preferredGender,
                  onChanged: (value) {
                    setState(() {
                      _preferredGender = value!;
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Preferred age range
          const Text(
            '선호하는 페르소나 나이 범위 *',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            '${_preferredAgeRange.start.toInt()}세 ~ ${_preferredAgeRange.end.toInt()}세',
            style: const TextStyle(fontSize: 16),
          ),
          RangeSlider(
            values: _preferredAgeRange,
            min: 18,
            max: 50,
            divisions: 32,
            labels: RangeLabels(
              _preferredAgeRange.start.toInt().toString(),
              _preferredAgeRange.end.toInt().toString(),
            ),
            onChanged: (values) {
              setState(() {
                _preferredAgeRange = values;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPurposePage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '사용 목적',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'SONA를 사용하시는 목적을 선택해주세요',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 32),
          
          ...PurposeOptions.purposes.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: InkWell(
                onTap: () {
                  setState(() {
                    _selectedPurpose = entry.key;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _selectedPurpose == entry.key 
                          ? AppTheme.primaryColor 
                          : Colors.grey[300]!,
                      width: _selectedPurpose == entry.key ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    color: _selectedPurpose == entry.key 
                        ? AppTheme.primaryColor.withOpacity(0.05)
                        : null,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _getPurposeIcon(entry.key),
                        size: 32,
                        color: _selectedPurpose == entry.key 
                            ? AppTheme.primaryColor 
                            : Colors.grey[600],
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              entry.value,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: _selectedPurpose == entry.key 
                                    ? AppTheme.primaryColor 
                                    : Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _getPurposeDescription(entry.key),
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (_selectedPurpose == entry.key)
                        const Icon(
                          Icons.check_circle,
                          color: AppTheme.primaryColor,
                        ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
          
          const SizedBox(height: 32),
          
          const Text(
            '선호하는 페르소나 유형',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildPersonaTypeChip('normal', '일반 페르소나'),
              _buildPersonaTypeChip('expert', '전문가 페르소나'),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildPersonaTypeChip(String type, String label) {
    final isSelected = _selectedPersonaTypes.contains(type);
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          if (selected) {
            _selectedPersonaTypes.add(type);
          } else {
            _selectedPersonaTypes.remove(type);
          }
        });
      },
      selectedColor: AppTheme.primaryColor.withOpacity(0.2),
      checkmarkColor: AppTheme.primaryColor,
    );
  }
  
  IconData _getPurposeIcon(String purpose) {
    switch (purpose) {
      case 'friendship':
        return Icons.people;
      case 'dating':
        return Icons.favorite;
      case 'counseling':
        return Icons.psychology;
      case 'entertainment':
        return Icons.theater_comedy;
      default:
        return Icons.chat;
    }
  }
  
  String _getPurposeDescription(String purpose) {
    switch (purpose) {
      case 'friendship':
        return '새로운 친구를 만나고 대화를 나누고 싶어요';
      case 'dating':
        return '연애 감정을 느끼며 로맨틱한 관계를 원해요';
      case 'counseling':
        return '전문가의 조언과 상담이 필요해요';
      case 'entertainment':
        return '재미있는 대화와 즐거운 시간을 보내고 싶어요';
      default:
        return '';
    }
  }

  Widget _buildInterestsPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '관심사',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '관심사를 선택해주세요 (최소 1개)',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: InterestOptions.allInterests.map((interest) {
              final isSelected = _selectedInterests.contains(interest);
              return FilterChip(
                label: Text(interest),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedInterests.add(interest);
                    } else {
                      _selectedInterests.remove(interest);
                    }
                  });
                },
                selectedColor: AppTheme.primaryColor.withOpacity(0.2),
                checkmarkColor: AppTheme.primaryColor,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
  
  Widget _buildTopicsPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '선호하는 대화 주제',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '어떤 주제로 대화하고 싶으신가요? (선택사항)',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: TopicOptions.allTopics.map((topic) {
              final isSelected = _selectedPreferredTopics.contains(topic);
              return FilterChip(
                label: Text(topic),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedPreferredTopics.add(topic);
                    } else {
                      _selectedPreferredTopics.remove(topic);
                    }
                  });
                },
                selectedColor: AppTheme.primaryColor.withOpacity(0.2),
                checkmarkColor: AppTheme.primaryColor,
              );
            }).toList(),
          ),
          
          const SizedBox(height: 40),
          
          const Text(
            '선호하는 대화 스타일',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          Column(
            children: [
              RadioListTile<String>(
                title: const Text('편안하고 캐주얼한 대화'),
                subtitle: const Text('친구처럼 편하게 대화해요'),
                value: 'casual',
                groupValue: _communicationStyle,
                onChanged: (value) {
                  setState(() {
                    _communicationStyle = value!;
                  });
                },
              ),
              RadioListTile<String>(
                title: const Text('정중하고 포멀한 대화'),
                subtitle: const Text('존댓말로 예의 바르게 대화해요'),
                value: 'formal',
                groupValue: _communicationStyle,
                onChanged: (value) {
                  setState(() {
                    _communicationStyle = value!;
                  });
                },
              ),
              RadioListTile<String>(
                title: const Text('상황에 맞게 조절'),
                subtitle: const Text('관계가 발전함에 따라 자연스럽게 변해요'),
                value: 'adaptive',
                groupValue: _communicationStyle,
                onChanged: (value) {
                  setState(() {
                    _communicationStyle = value!;
                  });
                },
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          const Text(
            '선호하는 MBTI (선택사항)',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '특정 MBTI 유형의 페르소나를 선호하신다면 선택해주세요',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 16),
          
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: MbtiOptions.allTypes.map((mbti) {
              final isSelected = _selectedPreferredMbti.contains(mbti);
              return FilterChip(
                label: Text(mbti),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedPreferredMbti.add(mbti);
                    } else {
                      _selectedPreferredMbti.remove(mbti);
                    }
                  });
                },
                selectedColor: AppTheme.primaryColor.withOpacity(0.2),
                checkmarkColor: AppTheme.primaryColor,
              );
            }).toList(),
          ),
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
          const Text(
            '약관 동의',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '서비스 이용을 위한 약관에 동의해주세요',
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