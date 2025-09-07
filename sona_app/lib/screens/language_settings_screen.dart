import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import '../l10n/app_localizations.dart';
import '../services/locale_service.dart';
import '../core/preferences_manager.dart';

class LanguageSettingsScreen extends StatefulWidget {
  const LanguageSettingsScreen({super.key});

  @override
  State<LanguageSettingsScreen> createState() => _LanguageSettingsScreenState();
}

class _LanguageSettingsScreenState extends State<LanguageSettingsScreen> {
  bool _alwaysShowTranslation = false;
  
  @override
  void initState() {
    super.initState();
    _loadTranslationPreference();
  }
  
  Future<void> _loadTranslationPreference() async {
    final alwaysShow = await PreferencesManager.getBool('always_show_translation') ?? false;
    if (mounted) {
      setState(() {
        _alwaysShowTranslation = alwaysShow;
      });
    }
  }
  // Get localized language names
  List<LanguageOption> _getLanguages(AppLocalizations l10n) {
    return [
      LanguageOption('en', 'English', '🇺🇸', l10n.englishLanguage),
      LanguageOption('ko', '한국어', '🇰🇷', l10n.koreanLanguage),
      LanguageOption('ja', '日本語', '🇯🇵', l10n.japaneseLanguage),
      LanguageOption('zh', '中文', '🇨🇳', l10n.chineseLanguage),
      LanguageOption('th', 'ภาษาไทย', '🇹🇭', l10n.thaiLanguage),
      LanguageOption('vi', 'Tiếng Việt', '🇻🇳', l10n.vietnameseLanguage),
      LanguageOption('id', 'Bahasa Indonesia', '🇮🇩', l10n.indonesianLanguage),
      LanguageOption('es', 'Español', '🇪🇸', l10n.spanishLanguage),
      LanguageOption('tl', 'Filipino', '🇵🇭', l10n.tagalogLanguage),
      LanguageOption('fr', 'Français', '🇫🇷', l10n.frenchLanguage),
      LanguageOption('de', 'Deutsch', '🇩🇪', l10n.germanLanguage),
      LanguageOption('ru', 'Русский', '🇷🇺', l10n.russianLanguage),
      LanguageOption('pt', 'Português', '🇵🇹', l10n.portugueseLanguage),
      LanguageOption('it', 'Italiano', '🇮🇹', l10n.italianLanguage),
      LanguageOption('nl', 'Nederlands', '🇳🇱', l10n.dutchLanguage),
      LanguageOption('sv', 'Svenska', '🇸🇪', l10n.swedishLanguage),
      LanguageOption('pl', 'Polski', '🇵🇱', l10n.polishLanguage),
      LanguageOption('tr', 'Türkçe', '🇹🇷', l10n.turkishLanguage),
      LanguageOption('ar', 'العربية', '🇸🇦', l10n.arabicLanguage),
      LanguageOption('hi', 'हिन्दी', '🇮🇳', l10n.hindiLanguage),
      LanguageOption('ur', 'اردو', '🇵🇰', l10n.urduLanguage),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final localeService = Provider.of<LocaleService>(context);
    final theme = Theme.of(context);
    final languages = _getLanguages(l10n);

    // 현재 선택된 언어 찾기
    // 항상 현재 앱에서 사용 중인 언어를 표시
    String currentLanguageCode = Localizations.localeOf(context).languageCode;
    
    final currentLanguage = languages.firstWhere(
      (lang) => lang.code == currentLanguageCode,
      orElse: () => languages.first,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.languageSettings),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 헤더 섹션
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: theme.dividerColor.withOpacity(0.2),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.language,
                      color: theme.colorScheme.primary,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      l10n.language,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.setAppInterfaceLanguage,
                  style: TextStyle(
                    fontSize: 14,
                    color: theme.textTheme.bodySmall?.color,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 시스템 언어 사용 스위치
          Container(
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: theme.dividerColor.withOpacity(0.2),
              ),
            ),
            child: SwitchListTile(
              title: Text(
                l10n.useSystemLanguage,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              subtitle: Text(
                l10n.followDeviceLanguage,
                style: TextStyle(
                  fontSize: 13,
                  color: theme.textTheme.bodySmall?.color,
                ),
              ),
              value: localeService.useSystemLanguage,
              onChanged: (value) {
                localeService.setUseSystemLanguage(value);
              },
              activeColor: theme.colorScheme.primary,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
            ),
          ),

          // 언어 선택 드롭다운
          if (!localeService.useSystemLanguage) ...[
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: theme.dividerColor.withOpacity(0.2),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.selectLanguage,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: theme.textTheme.bodySmall?.color,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: theme.colorScheme.primary.withOpacity(0.3),
                          width: 1.5,
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: currentLanguage.code,
                          isExpanded: true,
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: theme.colorScheme.primary,
                          ),
                          elevation: 8,
                          style: TextStyle(
                            color: theme.textTheme.bodyLarge?.color,
                            fontSize: 16,
                          ),
                          dropdownColor: theme.cardColor,
                          borderRadius: BorderRadius.circular(12),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              localeService.setLocale(newValue);
                            }
                          },
                          items: languages.map<DropdownMenuItem<String>>(
                            (LanguageOption language) {
                              return DropdownMenuItem<String>(
                                value: language.code,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4, // 8에서 4로 줄임
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        language.flag,
                                        style: const TextStyle(fontSize: 20), // 24에서 20으로 줄임
                                      ),
                                      const SizedBox(width: 10), // 12에서 10으로 줄임
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              language.nativeName,
                                              style: const TextStyle(
                                                fontSize: 13, // 14에서 13으로 줄임
                                                fontWeight: FontWeight.w500,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                            Text(
                                              language.englishName,
                                              style: TextStyle(
                                                fontSize: 10, // 11에서 10으로 줄임
                                                color: theme
                                                    .textTheme.bodySmall?.color,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (language.code == currentLanguage.code)
                                        Icon(
                                          Icons.check_circle,
                                          color: theme.colorScheme.primary,
                                          size: 18, // 20에서 18로 줄임
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],

          const SizedBox(height: 20),

          // 번역 설정 섹션
          Container(
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: theme.dividerColor.withOpacity(0.2),
              ),
            ),
            child: Column(
              children: [
                // 번역 설정 헤더
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(
                        Icons.translate,
                        color: theme.colorScheme.primary,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.translationSettings ?? 'Translation Settings',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              AppLocalizations.of(context)!.translationSettingsDescription ?? 'Configure how translations appear in chat',
                              style: TextStyle(
                                fontSize: 12,
                                color: theme.textTheme.bodySmall?.color,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(height: 1, color: theme.dividerColor.withOpacity(0.2)),
                // 항상 번역 표시 스위치
                SwitchListTile(
                  title: Text(
                    AppLocalizations.of(context)!.alwaysShowTranslation ?? 'Always Show Translation',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(
                    AppLocalizations.of(context)!.alwaysShowTranslationDescription ?? 'Automatically show translations for all messages',
                    style: TextStyle(
                      fontSize: 13,
                      color: theme.textTheme.bodySmall?.color,
                    ),
                  ),
                  value: _alwaysShowTranslation,
                  onChanged: (value) async {
                    setState(() {
                      _alwaysShowTranslation = value;
                    });
                    await PreferencesManager.setBool('always_show_translation', value);
                  },
                  activeColor: theme.colorScheme.primary,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 현재 선택된 언어 정보
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: theme.colorScheme.primary.withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                Text(
                  currentLanguage.flag,
                  style: const TextStyle(fontSize: 32),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.currentLanguage,
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.textTheme.bodySmall?.color,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        currentLanguage.nativeName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

}

// 언어 옵션 데이터 클래스
class LanguageOption {
  final String code;
  final String nativeName;
  final String flag;
  final String englishName;

  LanguageOption(this.code, this.nativeName, this.flag, this.englishName);
}