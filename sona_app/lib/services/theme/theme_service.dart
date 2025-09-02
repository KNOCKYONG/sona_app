import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../base/base_service.dart';
import '../../core/preferences_manager.dart';
import '../../l10n/app_localizations.dart';

enum ThemeType {
  system,
  light,
  dark,
}

class ThemeService extends BaseService {
  static const String _themeKey = 'theme_mode';

  ThemeType _currentTheme = ThemeType.system;

  ThemeType get currentTheme => _currentTheme;

  ThemeMode get themeMode {
    switch (_currentTheme) {
      case ThemeType.system:
        return ThemeMode.system;
      case ThemeType.light:
        return ThemeMode.light;
      case ThemeType.dark:
        return ThemeMode.dark;
    }
  }

  bool get isDarkMode {
    switch (_currentTheme) {
      case ThemeType.system:
        // Check system brightness
        final brightness =
            SchedulerBinding.instance.platformDispatcher.platformBrightness;
        return brightness == Brightness.dark;
      case ThemeType.light:
        return false;
      case ThemeType.dark:
        return true;
    }
  }

  Future<void> initialize() async {
    await executeWithLoading(() async {
      final savedTheme = await PreferencesManager.getString(_themeKey);
      if (savedTheme != null) {
        _currentTheme = ThemeType.values.firstWhere(
          (type) => type.toString() == savedTheme,
          orElse: () => ThemeType.system,
        );
      }
      notifyListeners();
    }, showError: false);
  }

  Future<void> setTheme(ThemeType theme) async {
    _currentTheme = theme;
    await PreferencesManager.setString(_themeKey, theme.toString());
    notifyListeners();
  }

  String getThemeDisplayName(ThemeType theme, BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    switch (theme) {
      case ThemeType.system:
        return localizations.systemThemeName;
      case ThemeType.light:
        return localizations.lightThemeName;
      case ThemeType.dark:
        return localizations.darkThemeName;
    }
  }

  IconData getThemeIcon(ThemeType theme) {
    switch (theme) {
      case ThemeType.system:
        return Icons.brightness_auto;
      case ThemeType.light:
        return Icons.light_mode;
      case ThemeType.dark:
        return Icons.dark_mode;
    }
  }
}
