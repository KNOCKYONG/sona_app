import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import '../services/auth/auth_service.dart';
import '../utils/permission_helper.dart';
import '../services/auth/user_service.dart';
import '../services/persona/persona_service.dart';
import '../services/chat/chat_service.dart';
import 'matched_personas_screen.dart';
import 'profile_edit_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ImagePicker _picker = ImagePicker();
  bool _isUploadingImage = false;
  
  Future<void> _pickAndUploadImage() async {
    final File? imageFile = await PermissionHelper.requestAndPickImage(
      context: context,
      source: ImageSource.gallery,
    );
    
    if (imageFile != null && mounted) {
      setState(() {
        _isUploadingImage = true;
      });
      
      try {
        final userService = Provider.of<UserService>(context, listen: false);
        final success = await userService.updateProfileImage(imageFile);
        
        if (mounted) {
          if (success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('프로필 사진이 업데이트되었습니다'),
                backgroundColor: Colors.green,
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('프로필 사진 업데이트에 실패했습니다'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      } finally {
        if (mounted) {
          setState(() {
            _isUploadingImage = false;
          });
        }
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final userService = Provider.of<UserService>(context);
    final personaService = Provider.of<PersonaService>(context);
    final chatService = Provider.of<ChatService>(context);
    final firebaseUser = authService.user;
    final appUser = userService.currentUser;
    final isLoggedIn = authService.isAuthenticated;
    
    // 로그인하지 않은 경우 로그인 유도 화면 표시
    if (!isLoggedIn) {
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Text(
            'Profile',
            style: TextStyle(
              color: Theme.of(context).textTheme.headlineSmall?.color,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.person_outline,
                  size: 100,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 24),
                Text(
                  '로그인이 필요합니다',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.headlineMedium?.color,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '프로필을 보고 소나와의 기록을 확인하려면\n로그인이 필요해요',
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.7),
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      '로그인 / 회원가입',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    
    // 통계 계산
    int totalMessages = 0;
    int totalRelationshipScore = 0;
    for (final persona in personaService.matchedPersonas) {
      final messages = chatService.getMessages(persona.id);
      totalMessages += messages.length;
      totalRelationshipScore += persona.relationshipScore;
    }
    final avgScore = personaService.matchedPersonas.isNotEmpty 
        ? (totalRelationshipScore / personaService.matchedPersonas.length).round()
        : 0;
    
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Profile',
          style: TextStyle(
            color: Theme.of(context).textTheme.headlineSmall?.color,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Theme.of(context).iconTheme.color,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 프로필 헤더
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  // 프로필 이미지
                  Stack(
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
                          child: _isUploadingImage
                              ? Container(
                                  color: Colors.grey[200],
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                )
                              : (appUser?.profileImageUrl != null || firebaseUser?.photoURL != null)
                                  ? _buildProfileImage(
                                      appUser?.profileImageUrl ?? firebaseUser?.photoURL ?? '',
                                    )
                                  : Container(
                                      color: Colors.grey[200],
                                      child: Icon(
                                        Icons.person,
                                        size: 50,
                                        color: Colors.grey[400],
                                      ),
                                    ),
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
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            icon: Icon(
                              Icons.camera_alt,
                              size: 18,
                              color: _isUploadingImage ? Colors.white54 : Colors.white,
                            ),
                            onPressed: _isUploadingImage ? null : _pickAndUploadImage,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // 사용자 이름
                  Text(
                    appUser?.nickname ?? firebaseUser?.displayName ?? '소나 친구',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.headlineMedium?.color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  
                  // 이메일
                  if (firebaseUser?.email != null)
                    Text(
                      firebaseUser!.email!,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  const SizedBox(height: 20),
                  
                  // 통계 정보
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatItem('매칭', '${personaService.matchedPersonas.length}'),
                      _buildStatItem('대화', '$totalMessages'),
                      _buildStatItem('친밀도', '$avgScore'),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // 메뉴 리스트
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildMenuItem(
                    icon: Icons.favorite,
                    title: '매칭된 소나',
                    subtitle: '${personaService.matchedPersonas.length}명의 소나와 대화중',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MatchedPersonasScreen(),
                        ),
                      );
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.edit,
                    title: '프로필 편집',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfileEditScreen(),
                        ),
                      );
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.shopping_bag,
                    title: '스토어',
                    subtitle: '하트 구매 및 프리미엄 가입',
                    onTap: () {
                      Navigator.pushNamed(context, '/purchase');
                    },
                  ),
                  const SizedBox(height: 20),
                  
                  // 로그아웃 버튼
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            title: const Text('로그아웃'),
                            content: const Text('정말 로그아웃하시겠습니까?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('취소'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  Navigator.pop(context);
                                  await authService.signOut();
                                  // 상태가 자동으로 업데이트되어 로그인 유도 화면이 표시됨
                                },
                                child: const Text(
                                  '로그아웃',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.error.withOpacity(0.1),
                        foregroundColor: Theme.of(context).colorScheme.error,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        '로그아웃',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).textTheme.bodySmall?.color,
          ),
        ),
      ],
    );
  }

  Widget _buildProfileImage(String imageUrl) {
    // base64 이미지인 경우
    if (imageUrl.startsWith('data:image')) {
      final base64String = imageUrl.split(',').last;
      return Image.memory(
        base64Decode(base64String),
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
      );
    }
    
    // 일반 URL인 경우
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      placeholder: (context, url) => Container(
        color: Colors.grey[200],
        child: Center(
          child: CircularProgressIndicator(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
      errorWidget: (context, url, error) => Container(
        color: Colors.grey[200],
        child: Icon(
          Icons.person,
          size: 50,
          color: Colors.grey[400],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              )
            : null,
        trailing: trailing ??
            (onTap != null
                ? Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.5),
                  )
                : null),
        onTap: onTap,
      ),
    );
  }
}