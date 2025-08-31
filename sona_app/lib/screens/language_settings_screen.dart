import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import '../l10n/app_localizations.dart';
import '../services/locale_service.dart';

class LanguageSettingsScreen extends StatefulWidget {
  const LanguageSettingsScreen({super.key});

  @override
  State<LanguageSettingsScreen> createState() => _LanguageSettingsScreenState();
}

class _LanguageSettingsScreenState extends State<LanguageSettingsScreen> {
  // Get localized language names
  List<LanguageOption> _getLanguages(AppLocalizations l10n) {
    return [
      LanguageOption('en', 'English', '🇺🇸', l10n.english),
      LanguageOption('ko', '한국어', '🇰🇷', l10n.korean),
      LanguageOption('ja', '日本語', '🇯🇵', l10n.japanese),
      LanguageOption('zh', '中文', '🇨🇳', l10n.chinese),
      LanguageOption('th', 'ภาษาไทย', '🇹🇭', l10n.thai),
      LanguageOption('vi', 'Tiếng Việt', '🇻🇳', l10n.vietnamese),
      LanguageOption('id', 'Bahasa Indonesia', '🇮🇩', l10n.indonesian),
      LanguageOption('es', 'Español', '🇪🇸', l10n.spanish),
      LanguageOption('fr', 'Français', '🇫🇷', l10n.french),
      LanguageOption('de', 'Deutsch', '🇩🇪', l10n.german),
      LanguageOption('ru', 'Русский', '🇷🇺', l10n.russian),
      LanguageOption('pt', 'Português', '🇵🇹', l10n.portuguese),
      LanguageOption('it', 'Italiano', '🇮🇹', l10n.italian),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final localeService = Provider.of<LocaleService>(context);
    final theme = Theme.of(context);
    final languages = _getLanguages(l10n);

    // 현재 선택된 언어 찾기
    // 시스템 언어 사용 시 실제 시스템 로케일 사용
    String currentLanguageCode;
    if (localeService.useSystemLanguage) {
      // 시스템 언어 사용 중일 때는 실제 시스템 로케일 가져오기
      final systemLocale = View.of(context).platformDispatcher.locale;
      currentLanguageCode = systemLocale.languageCode;
    } else {
      // 수동 설정된 언어 사용
      currentLanguageCode = localeService.locale?.languageCode ?? 'en';
    }
    
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
                          items: _languages.map<DropdownMenuItem<String>>(
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