import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import '../services/auth/auth_service.dart';
import '../utils/permission_helper.dart';
import '../services/auth/user_service.dart';
import '../services/persona/persona_service.dart';
import '../services/chat/core/chat_service.dart';
import '../services/purchase/purchase_service.dart';
import '../services/ui/haptic_service.dart';
import 'matched_personas_screen.dart';
import 'profile_edit_screen.dart';
import '../l10n/app_localizations.dart';
import '../utils/localization_helper.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ImagePicker _picker = ImagePicker();
  bool _isUploadingImage = false;
  
  @override
  void initState() {
    super.initState();
    _preloadUserImage();
  }
  
  Future<void> _preloadUserImage() async {
    // 사용자 프로필 이미지 프리로드
    final authService = Provider.of<AuthService>(context, listen: false);
    final userService = Provider.of<UserService>(context, listen: false);
    final imageUrl = userService.currentUser?.profileImageUrl ?? 
                     authService.user?.photoURL;
    
    if (imageUrl != null && imageUrl.isNotEmpty && !imageUrl.startsWith('data:')) {
      try {
        await precacheImage(
          CachedNetworkImageProvider(imageUrl),
          context,
        );
      } catch (e) {
        debugPrint('Failed to preload profile image: $e');
      }
    }
  }

  Future<void> _pickAndUploadImage() async {
    // Haptic feedback when opening image picker
    await HapticService.selectionClick();
    
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
            // Success haptic feedback
            await HapticService.success();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content:
                    Text(AppLocalizations.of(context)!.profilePhotoUpdated),
                backgroundColor: Colors.green,
              ),
            );
          } else {
            // Error haptic feedback
            await HapticService.error();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    AppLocalizations.of(context)!.profilePhotoUpdateFailed),
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
    final purchaseService = Provider.of<PurchaseService>(context);
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
            AppLocalizations.of(context)!.profile,
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
                  AppLocalizations.of(context)!.loginRequired,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.headlineMedium?.color,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  AppLocalizations.of(context)!.loginRequiredForProfile,
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.color
                        ?.withOpacity(0.7),
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
                    child: Text(
                      AppLocalizations.of(context)!.loginSignup,
                      style: const TextStyle(
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
    final matchedPersonaCount = personaService.matchedPersonas.length;
    int totalLikes = 0;
    for (final persona in personaService.matchedPersonas) {
      totalLikes += persona.likes;
    }
    final hearts = purchaseService.hearts;
    final remainingMessages = userService.getRemainingMessages();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          AppLocalizations.of(context)!.profile,
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
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                )
                              : (appUser?.profileImageUrl != null ||
                                      firebaseUser?.photoURL != null)
                                  ? _buildProfileImage(
                                      appUser?.profileImageUrl ??
                                          firebaseUser?.photoURL ??
                                          '',
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
                              color: _isUploadingImage
                                  ? Colors.white54
                                  : Colors.white,
                            ),
                            onPressed:
                                _isUploadingImage ? null : _pickAndUploadImage,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // 사용자 이름
                  Text(
                    appUser?.nickname ??
                        firebaseUser?.displayName ??
                        AppLocalizations.of(context)!.sonaFriend,
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
                      Flexible(
                        child: _buildStatItem(AppLocalizations.of(context)!.messagesRemaining(remainingMessages), LocalizationHelper.formatNumber(remainingMessages, Localizations.localeOf(context))),
                      ),
                      Flexible(
                        child: _buildStatItem(AppLocalizations.of(context)!.totalLikes,
                            LocalizationHelper.formatNumber(totalLikes, Localizations.localeOf(context))),
                      ),
                      Flexible(
                        child: _buildStatItem(
                            AppLocalizations.of(context)!.ownedHearts, LocalizationHelper.formatNumber(hearts, Localizations.localeOf(context))),
                      ),
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
                    title: AppLocalizations.of(context)!.matchedPersonas,
                    subtitle: AppLocalizations.of(context)!
                        .chattingWithPersonas(
                            personaService.matchedPersonas.length),
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
                    title: AppLocalizations.of(context)!.editProfile,
                    onTap: () async {
                      // Check if user is guest
                      final userService = Provider.of<UserService>(context, listen: false);
                      final isGuest = await userService.isGuestUser;
                      
                      if (isGuest) {
                        // Show login required dialog for guest users
                        final shouldNavigate = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text(AppLocalizations.of(context)!.loginRequiredTitle),
                            content: Text(AppLocalizations.of(context)!.profileEditLoginRequiredMessage),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: Text(AppLocalizations.of(context)!.cancel),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: Text(AppLocalizations.of(context)!.loginButton),
                              ),
                            ],
                          ),
                        );
                        
                        // Navigate to login screen if user confirmed
                        if (shouldNavigate == true && mounted) {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/login',
                            (route) => false,
                          );
                        }
                      } else {
                        // Regular users can edit profile
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProfileEditScreen(),
                          ),
                        );
                      }
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.shopping_bag,
                    title: AppLocalizations.of(context)!.store,
                    subtitle: AppLocalizations.of(context)!.purchaseHeartsOnly,
                    onTap: () async {
                      // Check if user is guest
                      final userService = Provider.of<UserService>(context, listen: false);
                      final isGuest = await userService.isGuestUser;
                      
                      if (isGuest) {
                        // Show login required dialog for guest users
                        final shouldNavigate = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text(AppLocalizations.of(context)!.loginRequiredTitle),
                            content: Text(AppLocalizations.of(context)!.storeLoginRequiredMessage),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: Text(AppLocalizations.of(context)!.cancel),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: Text(AppLocalizations.of(context)!.loginButton),
                              ),
                            ],
                          ),
                        );
                        
                        // Navigate to login screen if user confirmed
                        if (shouldNavigate == true && mounted) {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/login',
                            (route) => false,
                          );
                        }
                      } else {
                        // Regular users can access the store
                        Navigator.pushNamed(context, '/purchase');
                      }
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
                            title: Text(AppLocalizations.of(context)!.logout),
                            content: Text(
                                AppLocalizations.of(context)!.logoutConfirm),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child:
                                    Text(AppLocalizations.of(context)!.cancel),
                              ),
                              TextButton(
                                onPressed: () async {
                                  Navigator.pop(context);
                                  await authService.signOut();
                                  // 상태가 자동으로 업데이트되어 로그인 유도 화면이 표시됨
                                },
                                child: Text(
                                  AppLocalizations.of(context)!.logout,
                                  style: const TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context)
                            .colorScheme
                            .error
                            .withOpacity(0.1),
                        foregroundColor: Theme.of(context).colorScheme.error,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.logout,
                        style: const TextStyle(
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

  double _getLabelFontSize(String languageCode) {
    // 언어별로 최적화된 폰트 크기 반환
    switch (languageCode) {
      case 'en':
      case 'es':
      case 'fr':
      case 'de':
      case 'it':
      case 'pt':
        return 11.0; // 라틴 문자 언어들
      case 'zh':
      case 'ja':
        return 12.0; // 한자/일본어
      case 'th':
      case 'vi':
      case 'id':
        return 11.5; // 동남아 언어들
      case 'ko':
      case 'ru':
      default:
        return 12.0; // 한국어, 러시아어 등
    }
  }

  Widget _buildStatItem(String label, String value) {
    final localizations = AppLocalizations.of(context)!;
    final languageCode = Localizations.localeOf(context).languageCode;
    
    // 언어별 폰트 크기 조정
    final labelFontSize = _getLabelFontSize(languageCode);
    // 텍스트 길이에 따라 자동으로 높이 조정
    final needsWrap = label.length > 10; // 10자 이상이면 줄바꿈 필요
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Column(
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Container(
            height: needsWrap ? 36 : 20, // 텍스트가 길면 높이를 늘림
            child: Text(
              label,
              style: TextStyle(
                fontSize: labelFontSize,
                color: Theme.of(context).textTheme.bodySmall?.color,
                height: 1.2, // 줄 간격 조정
              ),
              overflow: TextOverflow.visible,
              maxLines: 2, // 최대 2줄까지 표시
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
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

    // 로컬 파일 경로인 경우
    if (imageUrl.startsWith('/')) {
      final file = File(imageUrl);
      return Image.file(
        file,
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
                    color: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.color
                        ?.withOpacity(0.5),
                  )
                : null),
        onTap: onTap != null
            ? () async {
                // iOS-style light haptic feedback for menu taps
                await HapticService.lightImpact();
                onTap();
              }
            : null,
      ),
    );
  }
}
