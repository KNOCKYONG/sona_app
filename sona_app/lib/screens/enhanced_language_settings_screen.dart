import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../services/locale_service.dart';
import 'package:intl/intl.dart';

class EnhancedLanguageSettingsScreen extends StatefulWidget {
  const EnhancedLanguageSettingsScreen({super.key});

  @override
  State<EnhancedLanguageSettingsScreen> createState() => _EnhancedLanguageSettingsScreenState();
}

class _EnhancedLanguageSettingsScreenState extends State<EnhancedLanguageSettingsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  
  // Enhanced language list with regions and native speakers count
  final List<EnhancedLanguageOption> _languages = [
    EnhancedLanguageOption('en', 'English', '🇺🇸', 'English', 'United States', 1500, 'Noto Sans'),
    EnhancedLanguageOption('ko', '한국어', '🇰🇷', 'Korean', 'South Korea', 77, 'Noto Sans KR'),
    EnhancedLanguageOption('ja', '日本語', '🇯🇵', 'Japanese', 'Japan', 125, 'Noto Sans JP'),
    EnhancedLanguageOption('zh', '中文', '🇨🇳', 'Chinese', 'China', 1118, 'Noto Sans SC'),
    EnhancedLanguageOption('th', 'ภาษาไทย', '🇹🇭', 'Thai', 'Thailand', 60, 'Noto Sans Thai'),
    EnhancedLanguageOption('vi', 'Tiếng Việt', '🇻🇳', 'Vietnamese', 'Vietnam', 85, 'Noto Sans'),
    EnhancedLanguageOption('id', 'Bahasa Indonesia', '🇮🇩', 'Indonesian', 'Indonesia', 199, 'Noto Sans'),
    EnhancedLanguageOption('es', 'Español', '🇪🇸', 'Spanish', 'Spain', 559, 'Noto Sans'),
    EnhancedLanguageOption('fr', 'Français', '🇫🇷', 'French', 'France', 280, 'Noto Sans'),
    EnhancedLanguageOption('de', 'Deutsch', '🇩🇪', 'German', 'Germany', 95, 'Noto Sans'),
    EnhancedLanguageOption('ru', 'Русский', '🇷🇺', 'Russian', 'Russia', 258, 'Noto Sans'),
    EnhancedLanguageOption('pt', 'Português', '🇵🇹', 'Portuguese', 'Portugal', 260, 'Noto Sans'),
    EnhancedLanguageOption('it', 'Italiano', '🇮🇹', 'Italian', 'Italy', 85, 'Noto Sans'),
  ];

  List<EnhancedLanguageOption> get filteredLanguages {
    if (_searchQuery.isEmpty) return _languages;
    
    return _languages.where((lang) {
      final query = _searchQuery.toLowerCase();
      return lang.nativeName.toLowerCase().contains(query) ||
             lang.englishName.toLowerCase().contains(query) ||
             lang.region.toLowerCase().contains(query);
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final localeService = Provider.of<LocaleService>(context);
    final theme = Theme.of(context);

    // Find current language
    final currentLanguage = _languages.firstWhere(
      (lang) => lang.code == (localeService.locale?.languageCode ?? 'en'),
      orElse: () => _languages.first,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.languageSettings),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Header with current language display
          Container(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary.withOpacity(0.15),
                    theme.colorScheme.primary.withOpacity(0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: theme.colorScheme.primary.withOpacity(0.2),
                ),
              ),
              child: Row(
                children: [
                  // Flag with animation
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      currentLanguage.flag,
                      style: const TextStyle(fontSize: 32),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.currentLanguage,
                          style: TextStyle(
                            fontSize: 12,
                            color: theme.textTheme.bodySmall?.color,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          currentLanguage.nativeName,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: currentLanguage.fontFamily,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${currentLanguage.region} • ${_formatSpeakers(currentLanguage.speakersMillions)}',
                          style: TextStyle(
                            fontSize: 13,
                            color: theme.textTheme.bodySmall?.color,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // System language toggle
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
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
              ),
            ),
          ),

          if (!localeService.useSystemLanguage) ...[
            // Search bar
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: l10n.searchLanguage,
                  prefixIcon: Icon(
                    Icons.search,
                    color: theme.colorScheme.primary,
                  ),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              _searchController.clear();
                              _searchQuery = '';
                            });
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: theme.cardColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: theme.dividerColor.withOpacity(0.2),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: theme.colorScheme.primary,
                      width: 2,
                    ),
                  ),
                ),
              ),
            ),

            // Language grid
            Expanded(
              child: filteredLanguages.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.language,
                            size: 64,
                            color: theme.textTheme.bodySmall?.color?.withOpacity(0.5),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            l10n.noLanguagesFound,
                            style: TextStyle(
                              color: theme.textTheme.bodySmall?.color,
                            ),
                          ),
                        ],
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1.5,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: filteredLanguages.length,
                      itemBuilder: (context, index) {
                        final language = filteredLanguages[index];
                        final isSelected = language.code == currentLanguage.code;

                        return GestureDetector(
                          onTap: () {
                            localeService.setLocale(language.code);
                            // Show confirmation snackbar
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Language changed to ${language.nativeName}',
                                  style: TextStyle(fontFamily: language.fontFamily),
                                ),
                                backgroundColor: theme.colorScheme.primary,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? theme.colorScheme.primary.withOpacity(0.15)
                                  : theme.cardColor,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected
                                    ? theme.colorScheme.primary
                                    : theme.dividerColor.withOpacity(0.2),
                                width: isSelected ? 2 : 1,
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: theme.colorScheme.primary.withOpacity(0.2),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ]
                                  : [],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        language.flag,
                                        style: const TextStyle(fontSize: 28),
                                      ),
                                      if (isSelected) ...[
                                        const SizedBox(width: 8),
                                        Icon(
                                          Icons.check_circle,
                                          color: theme.colorScheme.primary,
                                          size: 20,
                                        ),
                                      ],
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    language.nativeName,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: language.fontFamily,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    language.englishName,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: theme.textTheme.bodySmall?.color,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatSpeakers(int millions) {
    if (millions >= 1000) {
      return '${(millions / 1000).toStringAsFixed(1)}B speakers';
    }
    return '${millions}M speakers';
  }
}

class EnhancedLanguageOption {
  final String code;
  final String nativeName;
  final String flag;
  final String englishName;
  final String region;
  final int speakersMillions;
  final String fontFamily;

  EnhancedLanguageOption(
    this.code,
    this.nativeName,
    this.flag,
    this.englishName,
    this.region,
    this.speakersMillions,
    this.fontFamily,
  );
}

class LanguageOption {
  final String code;
  final String nativeName;
  final String flag;
  final String englishName;

  LanguageOption(this.code, this.nativeName, this.flag, this.englishName);
}