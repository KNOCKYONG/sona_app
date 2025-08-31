#!/usr/bin/env python3
"""
Refactor AppLocalizations.dart to use ARB files instead of isKorean
"""

import re

def generate_refactored_class():
    """Generate the refactored AppLocalizations class"""
    
    content = '''import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

/// Refactored AppLocalizations class that uses ARB files instead of isKorean
class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;
  
  // Store localized strings from ARB
  late Map<String, dynamic> _localizedStrings;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = [
    Locale('en', 'US'),
    Locale('ko', 'KR'),
  ];

  // Load the localized strings from ARB files
  Future<bool> load() async {
    String jsonString = await rootBundle.loadString(
        'lib/l10n/app_${locale.languageCode}.arb');
    
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    
    _localizedStrings = jsonMap;
    
    return true;
  }

  // Get a localized string by key
  String getString(String key) {
    return _localizedStrings[key] ?? key;
  }

  // Helper method to format strings with placeholders
  String _formatString(String key, Map<String, dynamic> placeholders) {
    String template = getString(key);
    
    placeholders.forEach((placeholder, value) {
      template = template.replaceAll('{$placeholder}', value.toString());
    });
    
    return template;
  }

  // Keep isKorean for backward compatibility but mark as deprecated
  @deprecated
  bool get isKorean => locale.languageCode == 'ko';
'''
    
    # Read the original file to get all method signatures
    with open('sona_app/lib/l10n/app_localizations.dart', 'r', encoding='utf-8') as f:
        original = f.read()
    
    # Extract all simple getters
    simple_getters = re.findall(r'String get (\w+) =>', original)
    
    # Generate simple getters
    content += '\n  // ===== Simple getters from ARB =====\n'
    for getter in simple_getters:
        content += f'  String get {getter} => getString(\'{getter}\');\n'
    
    # Add parameterized methods
    content += '''
  
  // ===== Parameterized methods =====
  String waitingForChat(String name) => 
      _formatString('waitingForChat', {'name': name});
  
  String conversationWith(String name) => 
      _formatString('conversationWith', {'name': name});
  
  String refreshComplete(int count) => 
      _formatString('refreshComplete', {'count': count});
  
  String daysRemaining(int days) => 
      _formatString('daysRemaining', {'days': days});
  
  String purchaseConfirmMessage(String product, String price) => 
      _formatString('purchaseConfirmMessage', {'product': product, 'price': price});
  
  String discountAmountValue(String amount) => 
      _formatString('discountAmountValue', {'amount': amount});
  
  String chattingWithPersonas(int count) => 
      _formatString('chattingWithPersonas', {'count': count});
  
  String purchaseConfirmContent(String product, String price) => 
      _formatString('purchaseConfirmContent', {'product': product, 'price': price});
  
  String reportError(String error) => 
      _formatString('reportError', {'error': error});
  
  String permissionDeniedMessage(String permissionName) => 
      _formatString('permissionDeniedMessage', {'permissionName': permissionName});
  
  String daysAgo(int days) => 
      _formatString('daysAgo', {'days': days});
  
  String hoursAgo(int hours) => 
      _formatString('hoursAgo', {'hours': hours});
  
  String minutesAgo(int minutes) => 
      _formatString('minutesAgo', {'minutes': minutes});
  
  String isTyping(String name) => 
      _formatString('isTyping', {'name': name});
  
  String ageRange(int min, int max) => 
      _formatString('ageRange', {'min': min, 'max': max});
  
  String blockedAICount(int count) => 
      _formatString('blockedAICount', {'count': count});
  
  String guestMessageRemaining(int count) => 
      _formatString('guestMessageRemaining', {'count': count});
  
  String newMessageCount(int count) => 
      _formatString('newMessageCount', {'count': count});
  
  String notEnoughHeartsCount(int count) => 
      _formatString('notEnoughHeartsCount', {'count': count});
  
  String restartConversationWithName(String name) => 
      _formatString('restartConversationWithName', {'name': name});
  
  String restartConversationQuestion(String name) => 
      _formatString('restartConversationQuestion', {'name': name});
  
  String monthDay(int month, int day) {
    if (locale.languageCode == 'ko') {
      return _formatString('monthDay', {'month': month, 'day': day});
    } else {
      // For English, use month name
      final monthName = _getMonthName(month);
      return _formatString('monthDay', {'month': monthName, 'day': day});
    }
  }
  
  String alreadyChattingWith(String name) => 
      _formatString('alreadyChattingWith', {'name': name});
  
  String cacheDeleteError(String error) => 
      _formatString('cacheDeleteError', {'error': error});
  
  String unblockPersonaConfirm(String name) => 
      _formatString('unblockPersonaConfirm', {'name': name});
  
  String errorWithMessage(String error) => 
      _formatString('errorWithMessage', {'error': error});

  // Helper method for month names (English)
  String _getMonthName(int month) {
    const monthNames = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return month >= 1 && month <= 12 ? monthNames[month - 1] : '';
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ko'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
'''
    
    return content

def main():
    # Generate the refactored class
    refactored = generate_refactored_class()
    
    # Back up the original file
    import shutil
    shutil.copy('sona_app/lib/l10n/app_localizations.dart', 
                'sona_app/lib/l10n/app_localizations_backup.dart')
    print("Backed up original file to app_localizations_backup.dart")
    
    # Write the refactored version
    with open('sona_app/lib/l10n/app_localizations.dart', 'w', encoding='utf-8') as f:
        f.write(refactored)
    
    print("Refactored app_localizations.dart successfully!")
    print("The isKorean property is now deprecated and all strings are loaded from ARB files.")

if __name__ == "__main__":
    main()