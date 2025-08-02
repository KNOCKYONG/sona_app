import 'package:flutter/material.dart';
import '../core/preferences_manager.dart';
import '../core/constants.dart';

/// 언어 설정을 관리하는 서비스
class LocaleService extends ChangeNotifier {
  Locale? _locale;
  bool _useSystemLanguage = true;
  
  Locale? get locale => _locale;
  bool get useSystemLanguage => _useSystemLanguage;
  
  LocaleService();
  
  Future<void> initialize() async {
    await _loadLocale();
  }
  
  Future<void> _loadLocale() async {
    _useSystemLanguage = await PreferencesManager.getUseSystemLanguage();
    
    debugPrint('🌐 Loading locale - Use system language: $_useSystemLanguage');
    
    if (!_useSystemLanguage) {
      final savedLanguageCode = await PreferencesManager.getLanguageCode();
      debugPrint('🌐 Saved language code: $savedLanguageCode');
      
      if (savedLanguageCode != null) {
        _locale = Locale(savedLanguageCode);
        debugPrint('🌐 Loaded locale: $_locale');
      }
    }
    
    notifyListeners();
  }
  
  Future<void> setLocale(String languageCode) async {
    debugPrint('🌐 Setting locale to: $languageCode');
    
    final success1 = await PreferencesManager.setLanguageCode(languageCode);
    final success2 = await PreferencesManager.setUseSystemLanguage(false);
    
    debugPrint('🌐 Saved to preferences - Language: $success1, UseSystem: $success2');
    
    // 저장 후 바로 다시 읽어서 확인
    final savedLang = await PreferencesManager.getLanguageCode();
    final savedUseSystem = await PreferencesManager.getUseSystemLanguage();
    debugPrint('🌐 Verification - Saved language: $savedLang, Use system: $savedUseSystem');
    
    _locale = Locale(languageCode);
    _useSystemLanguage = false;
    
    debugPrint('🌐 Locale set successfully. Current locale: $_locale');
    
    notifyListeners();
  }
  
  Future<void> setUseSystemLanguage(bool useSystem) async {
    await PreferencesManager.setUseSystemLanguage(useSystem);
    
    _useSystemLanguage = useSystem;
    
    if (useSystem) {
      _locale = null;
    } else {
      final savedLanguageCode = await PreferencesManager.getLanguageCode();
      if (savedLanguageCode != null) {
        _locale = Locale(savedLanguageCode);
      }
    }
    
    notifyListeners();
  }
}