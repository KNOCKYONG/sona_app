import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../services/locale_service.dart';

class LanguageSettingsScreen extends StatefulWidget {
  const LanguageSettingsScreen({super.key});

  @override
  State<LanguageSettingsScreen> createState() => _LanguageSettingsScreenState();
}

class _LanguageSettingsScreenState extends State<LanguageSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final localeService = Provider.of<LocaleService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.languageSettings),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        children: [
          // 앱 UI 언어 설정 섹션
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.phone_android,
                      color: Theme.of(context).colorScheme.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      l10n.language,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.isKorean
                      ? l10n.setAppInterfaceLanguage
                      : l10n.setAppInterfaceLanguage,
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                ),
              ],
            ),
          ),

          // 시스템 언어 사용 스위치
          SwitchListTile(
            title: Text(l10n.useSystemLanguage),
            subtitle: Text(l10n.followDeviceLanguage),
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
                              color:
                                  localeService.locale?.languageCode == 'en' ||
                                          (localeService.useSystemLanguage &&
                                              l10n.isKorean == false)
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: localeService.locale?.languageCode ==
                                            'en' ||
                                        (localeService.useSystemLanguage &&
                                            l10n.isKorean == false)
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).dividerColor,
                                width: 2,
                              ),
                              boxShadow:
                                  localeService.locale?.languageCode == 'en' ||
                                          (localeService.useSystemLanguage &&
                                              l10n.isKorean == false)
                                      ? [
                                          BoxShadow(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary
                                                .withOpacity(0.3),
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
                                    color: localeService.locale?.languageCode ==
                                                'en' ||
                                            (localeService.useSystemLanguage &&
                                                l10n.isKorean == false)
                                        ? Colors.white
                                        : Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.color,
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
                              color:
                                  localeService.locale?.languageCode == 'ko' ||
                                          (localeService.useSystemLanguage &&
                                              l10n.isKorean == true)
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: localeService.locale?.languageCode ==
                                            'ko' ||
                                        (localeService.useSystemLanguage &&
                                            l10n.isKorean == true)
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).dividerColor,
                                width: 2,
                              ),
                              boxShadow:
                                  localeService.locale?.languageCode == 'ko' ||
                                          (localeService.useSystemLanguage &&
                                              l10n.isKorean == true)
                                      ? [
                                          BoxShadow(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary
                                                .withOpacity(0.3),
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
                                  l10n.koreanLanguage,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: localeService.locale?.languageCode ==
                                                'ko' ||
                                            (localeService.useSystemLanguage &&
                                                l10n.isKorean == true)
                                        ? Colors.white
                                        : Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.color,
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
        ],
      ),
    );
  }
}
