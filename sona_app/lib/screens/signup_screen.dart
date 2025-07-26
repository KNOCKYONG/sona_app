import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../services/user_service.dart';
import '../models/app_user.dart';
import '../theme/app_theme.dart';

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
  
  int _currentPage = 0;
  bool _isCheckingNickname = false;
  bool _isNicknameAvailable = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nicknameController.dispose();
    _introController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 85,
    );
    
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
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
    if (_currentPage < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
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
                value: (_currentPage + 1) / 4,
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
                    _buildPreferencePage(),
                    _buildInterestsPage(),
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
                    
                    if (_currentPage < 3)
                      ElevatedButton(
                        onPressed: _nextPage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 12,
                          ),
                        ),
                        child: const Text('다음'),
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
                labelText: '이메일',
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
                labelText: '비밀번호',
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
              labelText: '닉네임',
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
              if (value.length >= 2) {
                _checkNicknameAvailability(value);
              }
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
}