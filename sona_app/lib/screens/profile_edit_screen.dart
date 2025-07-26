import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../services/user_service.dart';
import '../theme/app_theme.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nicknameController = TextEditingController();
  final _introController = TextEditingController();
  
  File? _profileImage;
  bool _isCheckingNickname = false;
  bool _isNicknameAvailable = true;
  String? _selectedGender;
  
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }
  
  void _loadUserData() {
    final userService = context.read<UserService>();
    final user = userService.currentUser;
    
    if (user != null) {
      _nicknameController.text = user.nickname;
      _introController.text = user.intro ?? '';
      _selectedGender = user.gender;
    }
  }
  
  @override
  void dispose() {
    _nicknameController.dispose();
    _introController.dispose();
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
    
    final userService = context.read<UserService>();
    final currentUser = userService.currentUser;
    
    // 현재 닉네임과 같으면 체크하지 않음
    if (currentUser != null && nickname == currentUser.nickname) {
      setState(() {
        _isNicknameAvailable = true;
        _isCheckingNickname = false;
      });
      return;
    }
    
    setState(() {
      _isCheckingNickname = true;
    });
    
    final isAvailable = await userService.isNicknameAvailable(nickname);
    
    setState(() {
      _isNicknameAvailable = isAvailable;
      _isCheckingNickname = false;
    });
  }
  
  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    
    final userService = context.read<UserService>();
    
    final success = await userService.updateUserProfile(
      nickname: _nicknameController.text,
      gender: _selectedGender,
      intro: _introController.text.isEmpty ? null : _introController.text,
      profileImage: _profileImage,
    );
    
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('프로필이 업데이트되었습니다'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(userService.error ?? '프로필 업데이트 실패'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final userService = context.watch<UserService>();
    final user = userService.currentUser;
    
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          '프로필 편집',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: userService.isLoading ? null : _saveProfile,
            child: Text(
              '완료',
              style: TextStyle(
                color: userService.isLoading 
                    ? Colors.grey 
                    : AppTheme.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 24),
              
              // 프로필 이미지
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Stack(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFFFF6B9D),
                            width: 3,
                          ),
                        ),
                        child: ClipOval(
                          child: _profileImage != null
                              ? Image.file(
                                  _profileImage!,
                                  fit: BoxFit.cover,
                                )
                              : (user?.profileImageUrl != null
                                  ? Image.network(
                                      user!.profileImageUrl!,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          color: Colors.grey[200],
                                          child: Icon(
                                            Icons.person,
                                            size: 50,
                                            color: Colors.grey[400],
                                          ),
                                        );
                                      },
                                    )
                                  : Container(
                                      color: Colors.grey[200],
                                      child: Icon(
                                        Icons.person,
                                        size: 50,
                                        color: Colors.grey[400],
                                      ),
                                    )),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF6B9D),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 2,
                            ),
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '프로필 사진 변경',
                style: TextStyle(
                  color: Color(0xFFFF6B9D),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 32),
              
              // 입력 필드들
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 닉네임
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
                    const SizedBox(height: 24),
                    
                    // 성별
                    const Text(
                      '성별',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),
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
                    
                    // 자기소개
                    TextFormField(
                      controller: _introController,
                      decoration: const InputDecoration(
                        labelText: '자기소개',
                        hintText: '간단한 자기소개를 작성해주세요',
                        alignLabelWithHint: true,
                      ),
                      maxLines: 3,
                      maxLength: 100,
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
}