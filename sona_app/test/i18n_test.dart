import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sona_app/l10n/app_localizations.dart';
import 'package:sona_app/services/locale_service.dart';

void main() {
  group('Internationalization Tests', () {
    test('All supported locales should be available', () {
      final supportedLocales = AppLocalizations.supportedLocales;
      
      // Check we have all 13 languages
      expect(supportedLocales.length, 13);
      
      // Check specific locales exist
      expect(supportedLocales.any((l) => l.languageCode == 'en'), true);
      expect(supportedLocales.any((l) => l.languageCode == 'ko'), true);
      expect(supportedLocales.any((l) => l.languageCode == 'ja'), true);
      expect(supportedLocales.any((l) => l.languageCode == 'zh'), true);
      expect(supportedLocales.any((l) => l.languageCode == 'th'), true);
      expect(supportedLocales.any((l) => l.languageCode == 'vi'), true);
      expect(supportedLocales.any((l) => l.languageCode == 'id'), true);
      expect(supportedLocales.any((l) => l.languageCode == 'es'), true);
      expect(supportedLocales.any((l) => l.languageCode == 'fr'), true);
      expect(supportedLocales.any((l) => l.languageCode == 'de'), true);
      expect(supportedLocales.any((l) => l.languageCode == 'ru'), true);
      expect(supportedLocales.any((l) => l.languageCode == 'pt'), true);
      expect(supportedLocales.any((l) => l.languageCode == 'it'), true);
    });

    test('LocaleService should initialize correctly', () async {
      final localeService = LocaleService();
      await localeService.initialize();
      
      // By default, should use system language
      expect(localeService.useSystemLanguage, true);
    });

    test('LocaleService should switch languages', () async {
      final localeService = LocaleService();
      await localeService.initialize();
      
      // Switch to Korean
      await localeService.setLocale('ko');
      expect(localeService.locale?.languageCode, 'ko');
      expect(localeService.useSystemLanguage, false);
      
      // Switch to Japanese
      await localeService.setLocale('ja');
      expect(localeService.locale?.languageCode, 'ja');
      expect(localeService.useSystemLanguage, false);
      
      // Switch back to system language
      await localeService.setUseSystemLanguage(true);
      expect(localeService.useSystemLanguage, true);
    });

    testWidgets('App should load correct translations', (WidgetTester tester) async {
      // Test English
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (context) {
              final l10n = AppLocalizations.of(context)!;
              return Text(l10n.appName);
            },
          ),
        ),
      );
      
      expect(find.text('SONA'), findsOneWidget);
      
      // Test Korean
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('ko'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (context) {
              final l10n = AppLocalizations.of(context)!;
              return Text(l10n.appName);
            },
          ),
        ),
      );
      
      expect(find.text('SONA'), findsOneWidget);
    });

    testWidgets('Translations should have all required keys', (WidgetTester tester) async {
      for (final locale in AppLocalizations.supportedLocales) {
        await tester.pumpWidget(
          MaterialApp(
            locale: locale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Builder(
              builder: (context) {
                final l10n = AppLocalizations.of(context)!;
                
                // Test some essential keys exist and are not null
                expect(l10n.appName, isNotNull);
                expect(l10n.loading, isNotNull);
                expect(l10n.error, isNotNull);
                expect(l10n.cancel, isNotNull);
                expect(l10n.confirm, isNotNull);
                expect(l10n.settings, isNotNull);
                expect(l10n.profile, isNotNull);
                expect(l10n.chat, isNotNull);
                expect(l10n.language, isNotNull);
                expect(l10n.languageSettings, isNotNull);
                
                return Text('Test for ${locale.languageCode}');
              },
            ),
          ),
        );
        
        await tester.pump();
      }
    });
  });
}