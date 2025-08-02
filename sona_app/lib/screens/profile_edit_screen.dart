import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../services/auth/user_service.dart';
import '../services/persona/persona_service.dart';
import '../theme/app_theme.dart';
import '../utils/permission_helper.dart';

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
  bool _genderAll = false;
  
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
      _genderAll = user.genderAll;
    }
  }
  
  @override
  void dispose() {
    _nicknameController.dispose();
    _introController.dispose();
    super.dispose();
  }
  
  Future<void> _pickImage() async {
    final imageFile = await PermissionHelper.requestAndPickImage(
      context: context,
      source: ImageSource.gallery,
    );
    
    if (imageFile != null) {
      setState(() {
        _profileImage = imageFile;
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
      genderAll: _genderAll,
    );
    
    if (success && mounted) {
      // Update PersonaService with new user data
      final personaService = context.read<PersonaService>();
      if (userService.currentUser != null) {
        personaService.setCurrentUser(userService.currentUser!);
        // Force reshuffle to apply new gender preferences
        personaService.reshuffleAvailablePersonas();
      }
      
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        title: Text(
          '프로필 편집',
          style: TextStyle(
            color: Theme.of(context).textTheme.headlineSmall?.color,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).iconTheme.color),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: userService.isLoading ? null : _saveProfile,
            child: Text(
              '완료',
              style: TextStyle(
                color: userService.isLoading 
                    ? Theme.of(context).textTheme.bodySmall?.color 
                    : Theme.of(context).colorScheme.primary,
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
                            color: Theme.of(context).colorScheme.primary,
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
                            color: Theme.of(context).colorScheme.primary,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Theme.of(context).cardColor,
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
              Text(
                '프로필 사진 변경',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
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
                        if (value.length >= 3) {
                          _checkNicknameAvailability(value);
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '닉네임을 입력해주세요';
                        }
                        if (value.length < 3 || value.length > 10) {
                          return '닉네임은 3-10자여야 합니다';
                        }
                        if (!_isNicknameAvailable) {
                          return '이미 사용 중인 닉네임입니다';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    
                    // 성별
                    Text(
                      '성별',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).textTheme.bodySmall?.color,
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
                    const SizedBox(height: 16),
                    
                    // Gender All checkbox
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: CheckboxListTile(
                        title: const Text(
                          '모든 성별 페르소나 보기',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        subtitle: const Text(
                          '체크하지 않으면 이성 페르소나만 표시됩니다',
                          style: TextStyle(fontSize: 12),
                        ),
                        value: _genderAll,
                        onChanged: (value) {
                          setState(() {
                            _genderAll = value ?? false;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                      ),
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