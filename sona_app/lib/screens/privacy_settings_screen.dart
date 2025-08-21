import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../l10n/app_localizations.dart';
import '../services/ui/haptic_service.dart';

class PrivacySettingsScreen extends StatefulWidget {
  const PrivacySettingsScreen({super.key});

  @override
  State<PrivacySettingsScreen> createState() => _PrivacySettingsScreenState();
}

class _PrivacySettingsScreenState extends State<PrivacySettingsScreen> {
  // Privacy settings
  bool _emotionAnalysisEnabled = true;
  bool _memoryAlbumEnabled = true;
  bool _weatherContextEnabled = true;
  bool _dailyCareEnabled = true;
  bool _interestSharingEnabled = true;
  bool _conversationContinuityEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _emotionAnalysisEnabled = prefs.getBool('emotion_analysis_enabled') ?? true;
      _memoryAlbumEnabled = prefs.getBool('memory_album_enabled') ?? true;
      _weatherContextEnabled = prefs.getBool('weather_context_enabled') ?? true;
      _dailyCareEnabled = prefs.getBool('daily_care_enabled') ?? true;
      _interestSharingEnabled = prefs.getBool('interest_sharing_enabled') ?? true;
      _conversationContinuityEnabled = prefs.getBool('conversation_continuity_enabled') ?? true;
    });
  }
  
  Future<void> _savePrivacySettings(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
    
    // Haptic feedback on toggle
    await HapticService.lightImpact();
    
    // Show warning if disabling a feature
    if (!value && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.privacySettingsInfo,
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.orange,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        title: Text(
          localizations.privacySettings,
          style: TextStyle(
            color: theme.textTheme.headlineSmall?.color,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: theme.iconTheme.color,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            
            // Info Banner
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.blue.withOpacity(0.1),
                    Colors.purple.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.blue.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.info_outline,
                      color: Colors.blue[700],
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          localizations.privacySettingsScreen,
                          style: TextStyle(
                            fontSize: 15,
                            color: theme.textTheme.bodyLarge?.color,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          localizations.allFeaturesRequired,
                          style: TextStyle(
                            fontSize: 13,
                            color: theme.textTheme.bodySmall?.color,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Privacy Settings List
            _buildPrivacySwitchItem(
              icon: Icons.emoji_emotions_outlined,
              iconColor: const Color(0xFFFF6B9D),
              title: localizations.emotionAnalysis,
              subtitle: localizations.emotionAnalysisDesc,
              value: _emotionAnalysisEnabled,
              onChanged: (value) {
                setState(() {
                  _emotionAnalysisEnabled = value;
                });
                _savePrivacySettings('emotion_analysis_enabled', value);
              },
            ),
            
            _buildPrivacySwitchItem(
              icon: Icons.photo_album_outlined,
              iconColor: const Color(0xFF9C88FF),
              title: localizations.memoryAlbum,
              subtitle: localizations.memoryAlbumDesc,
              value: _memoryAlbumEnabled,
              onChanged: (value) {
                setState(() {
                  _memoryAlbumEnabled = value;
                });
                _savePrivacySettings('memory_album_enabled', value);
              },
            ),
            
            _buildPrivacySwitchItem(
              icon: Icons.cloud_outlined,
              iconColor: const Color(0xFF74B9FF),
              title: localizations.weatherContext,
              subtitle: localizations.weatherContextDesc,
              value: _weatherContextEnabled,
              onChanged: (value) {
                setState(() {
                  _weatherContextEnabled = value;
                });
                _savePrivacySettings('weather_context_enabled', value);
              },
            ),
            
            _buildPrivacySwitchItem(
              icon: Icons.favorite_outline,
              iconColor: const Color(0xFFFF6B9D),
              title: localizations.dailyCare,
              subtitle: localizations.dailyCareDesc,
              value: _dailyCareEnabled,
              onChanged: (value) {
                setState(() {
                  _dailyCareEnabled = value;
                });
                _savePrivacySettings('daily_care_enabled', value);
              },
            ),
            
            _buildPrivacySwitchItem(
              icon: Icons.interests_outlined,
              iconColor: const Color(0xFFFECA57),
              title: localizations.interestSharing,
              subtitle: localizations.interestSharingDesc,
              value: _interestSharingEnabled,
              onChanged: (value) {
                setState(() {
                  _interestSharingEnabled = value;
                });
                _savePrivacySettings('interest_sharing_enabled', value);
              },
            ),
            
            _buildPrivacySwitchItem(
              icon: Icons.link_outlined,
              iconColor: const Color(0xFF5F97FF),
              title: localizations.conversationContinuity,
              subtitle: localizations.conversationContinuityDesc,
              value: _conversationContinuityEnabled,
              onChanged: (value) {
                setState(() {
                  _conversationContinuityEnabled = value;
                });
                _savePrivacySettings('conversation_continuity_enabled', value);
              },
            ),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivacySwitchItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: value 
              ? iconColor.withOpacity(0.3)
              : Colors.grey.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: value 
                ? iconColor.withOpacity(0.1)
                : Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: value
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    iconColor.withOpacity(0.05),
                    iconColor.withOpacity(0.02),
                  ],
                )
              : null,
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          leading: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: value
                  ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        iconColor.withOpacity(0.2),
                        iconColor.withOpacity(0.1),
                      ],
                    )
                  : null,
              color: value ? null : Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: value ? iconColor : Colors.grey,
              size: 26,
            ),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: value 
                  ? theme.textTheme.bodyLarge?.color
                  : Colors.grey,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              subtitle,
              style: TextStyle(
                fontSize: 13,
                color: value
                    ? theme.textTheme.bodySmall?.color
                    : Colors.grey.withOpacity(0.7),
                height: 1.5,
              ),
            ),
          ),
          trailing: Transform.scale(
            scale: 0.95,
            child: Switch.adaptive(
              value: value,
              onChanged: onChanged,
              activeColor: iconColor,
              activeTrackColor: iconColor.withOpacity(0.3),
              inactiveThumbColor: Colors.grey[400],
              inactiveTrackColor: Colors.grey[300],
            ),
          ),
        ),
      ),
    );
  }
}