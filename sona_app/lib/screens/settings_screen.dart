import 'package:flutter/material.dart';
import 'language_settings_screen.dart';
import 'privacy_settings_screen.dart';
import 'faq_screen.dart';
import 'profile_edit_screen.dart';
import 'settings/blocked_personas_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import '../services/auth/auth_service.dart';
import '../services/auth/device_id_service.dart';
import '../services/theme/theme_service.dart';
import '../services/ui/haptic_service.dart';
import '../services/cache/image_preload_service.dart';
import '../services/block_service.dart';
import '../config/custom_cache_manager.dart';
import '../utils/account_deletion_dialog.dart';
import '../l10n/app_localizations.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _soundEnabled = true;
  bool _hapticEnabled = true;
  final BlockService _blockService = BlockService();
  
  Future<bool> _isGuestMode() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    return await authService.isGuestUser;
  }

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _initializeBlockService();
  }

  Future<void> _initializeBlockService() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final userId = authService.user?.uid ?? await DeviceIdService.getDeviceId();
    if (userId.isNotEmpty) {
      await _blockService.initialize(userId);
    }
  }

  Future<int> _getBlockedCount() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final userId = authService.user?.uid ?? await DeviceIdService.getDeviceId();
    if (userId.isNotEmpty) {
      final blockedPersonas = await _blockService.getBlockedPersonas(userId);
      return blockedPersonas.length;
    }
    return 0;
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
      _soundEnabled = prefs.getBool('sound_enabled') ?? true;
      _hapticEnabled = HapticService.isEnabled;
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_enabled', _notificationsEnabled);
    await prefs.setBool('sound_enabled', _soundEnabled);
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        title: Text(
          localizations.settings,
          style: TextStyle(
            color: Theme.of(context).textTheme.headlineSmall?.color,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).iconTheme.color,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // 프로필 설정
            _buildSectionTitle(localizations.profileSettings),
            _buildMenuItem(
              icon: Icons.person_outline,
              title: localizations.editProfile,
              subtitle: localizations.isKorean 
                  ? '성별, 생년월일, 자기소개 수정'
                  : 'Edit gender, birthdate, and introduction',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileEditScreen(),
                  ),
                );
              },
            ),

            // 알림 설정
            _buildSectionTitle(localizations.notificationSettings),
            _buildSwitchItem(
              icon: Icons.notifications_outlined,
              title: localizations.pushNotifications,
              subtitle: localizations.newMessageNotification,
              value: _notificationsEnabled,
              onChanged: (value) {
                setState(() {
                  _notificationsEnabled = value;
                });
                _saveSettings();
              },
            ),

            // 소리 설정
            _buildSectionTitle(localizations.soundSettings),
            _buildSwitchItem(
              icon: Icons.volume_up_outlined,
              title: localizations.effectSound,
              subtitle: localizations.effectSoundDescription,
              value: _soundEnabled,
              onChanged: (value) {
                setState(() {
                  _soundEnabled = value;
                });
                _saveSettings();
              },
            ),
            _buildSwitchItem(
              icon: Icons.vibration_outlined,
              title: localizations.hapticFeedback,
              subtitle: localizations.subtleVibrationOnTouch,
              value: _hapticEnabled,
              onChanged: (value) async {
                setState(() {
                  _hapticEnabled = value;
                });
                await HapticService.setEnabled(value);
                // 설정 변경 시 즉시 햅틱 피드백 제공 (켜진 경우에만)
                if (value) {
                  await HapticService.lightImpact();
                }
              },
            ),

            // 프라이버시 설정
            _buildSectionTitle(localizations.privacySettings),
            _buildMenuItem(
              icon: Icons.privacy_tip_outlined,
              title: localizations.privacySettings,
              subtitle: localizations.isKorean 
                  ? '감정분석, 메모리앨범 등 개인정보 보호 설정'
                  : 'Emotion analysis, memory album, etc.',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PrivacySettingsScreen(),
                  ),
                );
              },
            ),

            // 테마 설정
            _buildSectionTitle(localizations.theme),
            Consumer<ThemeService>(
              builder: (context, themeService, child) {
                return _buildMenuItem(
                  icon: themeService.getThemeIcon(themeService.currentTheme),
                  title: localizations.themeSettings,
                  subtitle: themeService
                      .getThemeDisplayName(themeService.currentTheme),
                  onTap: () {
                    Navigator.pushNamed(context, '/theme-settings');
                  },
                );
              },
            ),

            // 차단 관리
            _buildSectionTitle(localizations.blockedAIs),
            FutureBuilder<int>(
              future: _getBlockedCount(),
              builder: (context, snapshot) {
                final blockedCount = snapshot.data ?? 0;
                return _buildMenuItem(
                  icon: Icons.block,
                  title: localizations.manageBlockedAIs,
                  subtitle: blockedCount > 0 
                      ? localizations.blockedAICount(blockedCount)
                      : localizations.noBlockedAIs,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BlockedPersonasScreen(),
                      ),
                    );
                  },
                );
              },
            ),

            // 기타
            _buildSectionTitle(localizations.others),
            _buildMenuItem(
              icon: Icons.language,
              title: localizations.languageSettings,
              subtitle: localizations.isKorean ? localizations.koreanLanguage : 'English',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LanguageSettingsScreen(),
                  ),
                );
              },
            ),
            _buildMenuItem(
              icon: Icons.help_outline,
              title: localizations.frequentlyAskedQuestions,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FAQScreen(),
                  ),
                );
              },
            ),
            _buildMenuItem(
              icon: Icons.info_outline,
              title: localizations.about,
              subtitle: '${localizations.version} 1.0.0',
              onTap: () {
                _showAppInfoDialog();
              },
            ),
            _buildMenuItem(
              icon: Icons.privacy_tip_outlined,
              title: localizations.privacy,
              onTap: () {
                Navigator.pushNamed(context, '/privacy-policy');
              },
            ),
            _buildMenuItem(
              icon: Icons.description_outlined,
              title: localizations.terms,
              onTap: () {
                Navigator.pushNamed(context, '/terms-of-service');
              },
            ),
            _buildMenuItem(
              icon: Icons.payment_outlined,
              title: localizations.purchasePolicy,
              onTap: () {
                Navigator.pushNamed(context, '/purchase-policy');
              },
            ),

            // 저장소 관리
            _buildSectionTitle(localizations.storageManagement),
            _buildMenuItem(
              icon: Icons.storage_outlined,
              title: localizations.imageCacheManagement,
              subtitle: localizations.managePersonaImageCache,
              onTap: () {
                _showCacheManagementDialog();
              },
            ),

            // 계정 관리 - 게스트 모드일 때는 숨김
            FutureBuilder<bool>(
              future: _isGuestMode(),
              builder: (context, snapshot) {
                // 게스트 모드가 아닐 때만 표시
                if (snapshot.data == true) {
                  return const SizedBox.shrink();
                }
                
                return Column(
                  children: [
                    _buildSectionTitle(localizations.accountManagement),
                    _buildMenuItem(
                      icon: Icons.delete_outline,
                      title: localizations.deleteAccount,
                      subtitle: localizations.deleteAccountWarning,
                      onTap: () {
                        AccountDeletionDialog.show(context);
                      },
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7),
        ),
      ),
    );
  }

  Widget _buildSwitchItem({
    required IconData icon,
    required String title,
    String? subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
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
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
              )
            : null,
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }


  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
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
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
              )
            : null,
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.5),
        ),
        onTap: onTap,
      ),
    );
  }


  void _showAppInfoDialog() {
    final localizations = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(localizations.about),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.favorite,
              size: 60,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            const Text(
              'SONA',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${localizations.version} 1.0.0',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              localizations.appTagline,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              localizations.confirm,
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
          ),
        ],
      ),
    );
  }

  void _showCacheManagementDialog() async {
    // 캐시 크기 계산 중 로딩 표시
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    // 캐시 크기 계산
    int cacheSize = 0;
    try {
      // 캐시된 이미지 개수로 대략적인 크기 추정
      final prefs = await SharedPreferences.getInstance();
      final preloadedImages = prefs.getStringList('preloaded_images') ?? [];

      // 이미지당 평균 크기 추정
      // thumb: 50KB, small: 150KB, medium: 400KB
      final avgSizePerImage = (50 + 150 + 400) * 1024; // 600KB per persona

      // 페르소나 수 계산 (각 페르소나당 3개 이미지)
      final personaCount = preloadedImages.length ~/ 3;
      cacheSize = personaCount * avgSizePerImage;

      // 최소값 설정
      if (cacheSize == 0 && preloadedImages.isNotEmpty) {
        cacheSize = preloadedImages.length * 200 * 1024; // 이미지당 200KB 평균
      }
    } catch (e) {
      debugPrint('Error calculating cache size: $e');
      // 대략적인 크기 추정
      cacheSize = 50 * 1024 * 1024; // 기본값 50MB
    }

    // 로딩 다이얼로그 닫기
    if (mounted) Navigator.pop(context);

    // 캐시 관리 다이얼로그 표시
    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(AppLocalizations.of(context)!.imageCacheManagement),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.storage,
              size: 48,
              color: Color(0xFFFF6B9D),
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.currentCacheSize,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _formatBytes(cacheSize),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '페르소나 이미지가 기기에 저장되어 있어 빠르게 로드됩니다.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '캐시를 삭제하면 이미지를 다시 다운로드해야 합니다.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.red[400],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _clearCache();
            },
            child: Text(
              AppLocalizations.of(context)!.deleteCache,
              style: TextStyle(color: Colors.red[400]),
            ),
          ),
        ],
      ),
    );
  }

  String _formatBytes(int bytes) {
    if (bytes == 0) return '0 B';
    const k = 1024;
    const sizes = ['B', 'KB', 'MB', 'GB'];
    final i = (bytes == 0) ? 0 : (bytes.bitLength - 1) ~/ 10;

    if (i >= sizes.length) {
      return '${(bytes / (k * k * k)).toStringAsFixed(1)} GB';
    }

    final divisor = i == 0 ? 1 : (i == 1 ? k : (i == 2 ? k * k : k * k * k));
    return '${(bytes / divisor).toStringAsFixed(1)} ${sizes[i]}';
  }

  Future<void> _clearCache() async {
    // 캐시 삭제 중 로딩 표시
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      // 모든 캐시 삭제
      await DefaultCacheManager().emptyCache();
      await PersonaCacheManager.instance.emptyCache();

      // 이미지 프리로드 상태 초기화
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('images_preloaded');
      await prefs.remove('images_preload_date');

      if (mounted) {
        Navigator.pop(context); // 로딩 다이얼로그 닫기

        // 성공 메시지
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.cacheDeleted),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // 로딩 다이얼로그 닫기

        // 에러 메시지
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('캐시 삭제 중 오류가 발생했습니다: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
