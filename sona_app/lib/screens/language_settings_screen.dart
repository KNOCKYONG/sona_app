import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../core/preferences_manager.dart';
import '../services/theme/theme_service.dart';
import '../services/locale_service.dart';

class LanguageSettingsScreen extends StatefulWidget {
  const LanguageSettingsScreen({super.key});

  @override
  State<LanguageSettingsScreen> createState() => _LanguageSettingsScreenState();
}

class _LanguageSettingsScreenState extends State<LanguageSettingsScreen> {
  @override
  void initState() {
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final localeService = Provider.of<LocaleService>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.language),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        children: [
          // 시스템 언어 사용 스위치
          SwitchListTile(
            title: const Text('Use System Language\n시스템 언어 사용'),
            subtitle: const Text('Follow device language settings\n기기의 언어 설정을 따릅니다'),
            value: localeService.useSystemLanguage,
            onChanged: (value) {
              localeService.setUseSystemLanguage(value);
            },
            activeColor: Theme.of(context).colorScheme.primary,
          ),
          
          if (!localeService.useSystemLanguage) ...[
            const Divider(),
            
            // 언어 선택 버튼들
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Select Language\n언어 선택',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      // 영어 버튼
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            localeService.setLocale('en');
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              color: localeService.locale?.languageCode == 'en' || (localeService.useSystemLanguage && l10n.isKorean == false)
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: localeService.locale?.languageCode == 'en' || (localeService.useSystemLanguage && l10n.isKorean == false)
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).dividerColor,
                                width: 2,
                              ),
                              boxShadow: localeService.locale?.languageCode == 'en' || (localeService.useSystemLanguage && l10n.isKorean == false)
                                  ? [
                                      BoxShadow(
                                        color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Column(
                              children: [
                                const Text(
                                  '🇺🇸',
                                  style: TextStyle(fontSize: 32),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'English',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: localeService.locale?.languageCode == 'en' || (localeService.useSystemLanguage && l10n.isKorean == false)
                                        ? Colors.white
                                        : Theme.of(context).textTheme.bodyLarge?.color,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // 한국어 버튼
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            localeService.setLocale('ko');
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              color: localeService.locale?.languageCode == 'ko' || (localeService.useSystemLanguage && l10n.isKorean == true)
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: localeService.locale?.languageCode == 'ko' || (localeService.useSystemLanguage && l10n.isKorean == true)
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).dividerColor,
                                width: 2,
                              ),
                              boxShadow: localeService.locale?.languageCode == 'ko' || (localeService.useSystemLanguage && l10n.isKorean == true)
                                  ? [
                                      BoxShadow(
                                        color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Column(
                              children: [
                                const Text(
                                  '🇰🇷',
                                  style: TextStyle(fontSize: 32),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '한국어',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: localeService.locale?.languageCode == 'ko' || (localeService.useSystemLanguage && l10n.isKorean == true)
                                        ? Colors.white
                                        : Theme.of(context).textTheme.bodyLarge?.color,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
          
          const SizedBox(height: 20),
          
          // 언어 설정 안내
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDarkMode 
                  ? Colors.grey[800]!.withOpacity(0.3)
                  : Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 20,
                      color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Language Settings Info\n언어 설정 안내',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.grey[300] : Colors.grey[800],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '• The app will automatically detect your device language on first launch.\n'
                  '• You can manually select a language if you prefer.\n'
                  '• Changes will take effect after restarting the app.\n\n'
                  '• 첫 실행 시 기기의 언어를 자동으로 감지합니다.\n'
                  '• 원하는 언어를 수동으로 선택할 수 있습니다.\n'
                  '• 변경사항은 앱을 재시작한 후 적용됩니다.',
                  style: TextStyle(
                    fontSize: 13,
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}