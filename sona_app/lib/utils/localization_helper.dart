import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

/// Comprehensive localization helper for date, time, number, and currency formatting
class LocalizationHelper {
  static final LocalizationHelper _instance = LocalizationHelper._internal();
  factory LocalizationHelper() => _instance;
  LocalizationHelper._internal();

  static bool _initialized = false;

  /// Initialize date formatting for all supported locales
  static Future<void> initialize() async {
    if (_initialized) return;
    
    // Initialize all supported locales
    await initializeDateFormatting('en_US', null);
    await initializeDateFormatting('ko_KR', null);
    await initializeDateFormatting('ja_JP', null);
    await initializeDateFormatting('zh_CN', null);
    await initializeDateFormatting('th_TH', null);
    await initializeDateFormatting('vi_VN', null);
    await initializeDateFormatting('id_ID', null);
    await initializeDateFormatting('es_ES', null);
    await initializeDateFormatting('fr_FR', null);
    await initializeDateFormatting('de_DE', null);
    await initializeDateFormatting('ru_RU', null);
    await initializeDateFormatting('pt_PT', null);
    await initializeDateFormatting('it_IT', null);
    
    _initialized = true;
  }

  /// Get locale string for Intl package
  static String getIntlLocale(Locale locale) {
    final map = {
      'en': 'en_US',
      'ko': 'ko_KR',
      'ja': 'ja_JP',
      'zh': 'zh_CN',
      'th': 'th_TH',
      'vi': 'vi_VN',
      'id': 'id_ID',
      'es': 'es_ES',
      'fr': 'fr_FR',
      'de': 'de_DE',
      'ru': 'ru_RU',
      'pt': 'pt_PT',
      'it': 'it_IT',
    };
    return map[locale.languageCode] ?? 'en_US';
  }

  // ===== Date Formatting =====

  /// Format date in short format (e.g., 1/30/25)
  static String formatDateShort(DateTime date, Locale locale) {
    final intlLocale = getIntlLocale(locale);
    return DateFormat.yMd(intlLocale).format(date);
  }

  /// Format date in medium format (e.g., Jan 30, 2025)
  static String formatDateMedium(DateTime date, Locale locale) {
    final intlLocale = getIntlLocale(locale);
    return DateFormat.yMMMMd(intlLocale).format(date);
  }

  /// Format date in long format (e.g., Thursday, January 30, 2025)
  static String formatDateLong(DateTime date, Locale locale) {
    final intlLocale = getIntlLocale(locale);
    return DateFormat.yMMMMEEEEd(intlLocale).format(date);
  }

  /// Format date with custom pattern
  static String formatDateCustom(DateTime date, String pattern, Locale locale) {
    final intlLocale = getIntlLocale(locale);
    return DateFormat(pattern, intlLocale).format(date);
  }

  // ===== Time Formatting =====

  /// Format time in short format (e.g., 3:30 PM)
  static String formatTimeShort(DateTime time, Locale locale) {
    final intlLocale = getIntlLocale(locale);
    return DateFormat.jm(intlLocale).format(time);
  }

  /// Format time in 24-hour format (e.g., 15:30)
  static String formatTime24Hour(DateTime time, Locale locale) {
    final intlLocale = getIntlLocale(locale);
    return DateFormat.Hm(intlLocale).format(time);
  }

  /// Format time with seconds (e.g., 3:30:45 PM)
  static String formatTimeWithSeconds(DateTime time, Locale locale) {
    final intlLocale = getIntlLocale(locale);
    return DateFormat.jms(intlLocale).format(time);
  }

  // ===== DateTime Formatting =====

  /// Format date and time together
  static String formatDateTime(DateTime dateTime, Locale locale) {
    final intlLocale = getIntlLocale(locale);
    return DateFormat.yMMMd(intlLocale).add_jm().format(dateTime);
  }

  /// Format date and time in full format
  static String formatDateTimeFull(DateTime dateTime, Locale locale) {
    final intlLocale = getIntlLocale(locale);
    return DateFormat.yMMMMEEEEd(intlLocale).add_jms().format(dateTime);
  }

  // ===== Relative Time Formatting =====

  /// Get relative time string (e.g., "2 hours ago", "in 3 days")
  static String formatRelativeTime(DateTime dateTime, Locale locale) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    // Language-specific relative time strings
    final relativeTimeFormats = {
      'en': _RelativeTimeEN(),
      'ko': _RelativeTimeKO(),
      'ja': _RelativeTimeJA(),
      'zh': _RelativeTimeZH(),
      'th': _RelativeTimeTH(),
      'vi': _RelativeTimeVI(),
      'id': _RelativeTimeID(),
      'es': _RelativeTimeES(),
      'fr': _RelativeTimeFR(),
      'de': _RelativeTimeDE(),
      'ru': _RelativeTimeRU(),
      'pt': _RelativeTimePT(),
      'it': _RelativeTimeIT(),
    };
    
    final formatter = relativeTimeFormats[locale.languageCode] ?? _RelativeTimeEN();
    return formatter.format(difference);
  }

  // ===== Number Formatting =====

  /// Format number with locale-specific thousands separator
  static String formatNumber(num number, Locale locale) {
    final intlLocale = getIntlLocale(locale);
    return NumberFormat.decimalPattern(intlLocale).format(number);
  }

  /// Format number as percentage
  static String formatPercent(double number, Locale locale, {int decimals = 0}) {
    final intlLocale = getIntlLocale(locale);
    final formatter = NumberFormat.percentPattern(intlLocale)
      ..minimumFractionDigits = decimals
      ..maximumFractionDigits = decimals;
    return formatter.format(number);
  }

  /// Format number with specified decimal places
  static String formatDecimal(double number, Locale locale, {int decimals = 2}) {
    final intlLocale = getIntlLocale(locale);
    final formatter = NumberFormat.decimalPattern(intlLocale)
      ..minimumFractionDigits = decimals
      ..maximumFractionDigits = decimals;
    return formatter.format(number);
  }

  /// Format number in compact form (e.g., 1.2K, 3.4M)
  static String formatCompact(num number, Locale locale) {
    final intlLocale = getIntlLocale(locale);
    return NumberFormat.compact(locale: intlLocale).format(number);
  }

  // ===== Currency Formatting =====

  /// Get currency symbol for locale
  static String getCurrencySymbol(Locale locale) {
    final currencyMap = {
      'en': '\$',
      'ko': '₩',
      'ja': '¥',
      'zh': '¥',
      'th': '฿',
      'vi': '₫',
      'id': 'Rp',
      'es': '€',
      'fr': '€',
      'de': '€',
      'ru': '₽',
      'pt': '€',
      'it': '€',
    };
    return currencyMap[locale.languageCode] ?? '\$';
  }

  /// Get currency code for locale
  static String getCurrencyCode(Locale locale) {
    final currencyCodeMap = {
      'en': 'USD',
      'ko': 'KRW',
      'ja': 'JPY',
      'zh': 'CNY',
      'th': 'THB',
      'vi': 'VND',
      'id': 'IDR',
      'es': 'EUR',
      'fr': 'EUR',
      'de': 'EUR',
      'ru': 'RUB',
      'pt': 'EUR',
      'it': 'EUR',
    };
    return currencyCodeMap[locale.languageCode] ?? 'USD';
  }

  /// Format currency with locale-specific formatting
  static String formatCurrency(double amount, Locale locale, {int decimals = 2}) {
    final intlLocale = getIntlLocale(locale);
    final currencyCode = getCurrencyCode(locale);
    
    // Special handling for currencies without decimals
    final noDecimalCurrencies = ['KRW', 'JPY', 'VND', 'IDR'];
    if (noDecimalCurrencies.contains(currencyCode)) {
      decimals = 0;
    }
    
    final formatter = NumberFormat.currency(
      locale: intlLocale,
      symbol: getCurrencySymbol(locale),
      decimalDigits: decimals,
    );
    return formatter.format(amount);
  }

  /// Format currency in compact form
  static String formatCurrencyCompact(double amount, Locale locale) {
    final symbol = getCurrencySymbol(locale);
    final compact = formatCompact(amount, locale);
    return '$symbol$compact';
  }

  // ===== Weekday and Month Names =====

  /// Get localized weekday name
  static String getWeekdayName(int weekday, Locale locale, {bool abbreviated = false}) {
    final intlLocale = getIntlLocale(locale);
    final format = abbreviated ? DateFormat.E(intlLocale) : DateFormat.EEEE(intlLocale);
    // Create a date with the specific weekday (Monday = 1, Sunday = 7)
    final date = DateTime(2024, 1, weekday);
    return format.format(date);
  }

  /// Get localized month name
  static String getMonthName(int month, Locale locale, {bool abbreviated = false}) {
    final intlLocale = getIntlLocale(locale);
    final format = abbreviated ? DateFormat.MMM(intlLocale) : DateFormat.MMMM(intlLocale);
    final date = DateTime(2024, month);
    return format.format(date);
  }

  /// Get list of all weekday names
  static List<String> getAllWeekdayNames(Locale locale, {bool abbreviated = false}) {
    return List.generate(7, (index) => getWeekdayName(index + 1, locale, abbreviated: abbreviated));
  }

  /// Get list of all month names
  static List<String> getAllMonthNames(Locale locale, {bool abbreviated = false}) {
    return List.generate(12, (index) => getMonthName(index + 1, locale, abbreviated: abbreviated));
  }

  // ===== Text Direction =====

  /// Check if locale uses RTL text direction
  static bool isRTL(Locale locale) {
    // Add RTL languages here when supported
    final rtlLanguages = ['ar', 'he', 'fa', 'ur'];
    return rtlLanguages.contains(locale.languageCode);
  }

  /// Get text direction for locale
  static ui.TextDirection getTextDirection(Locale locale) {
    if (isRTL(locale)) {
      return ui.TextDirection.rtl;
    } else {
      return ui.TextDirection.ltr;
    }
  }

  // ===== Font Families =====

  /// Get recommended font family for locale
  static String getFontFamily(Locale locale) {
    final fontMap = {
      'ko': 'Noto Sans KR',
      'ja': 'Noto Sans JP',
      'zh': 'Noto Sans SC',
      'th': 'Noto Sans Thai',
      'ar': 'Noto Sans Arabic',
      'he': 'Noto Sans Hebrew',
      'ru': 'Noto Sans',
      'default': 'Noto Sans',
    };
    return fontMap[locale.languageCode] ?? fontMap['default']!;
  }
}

// ===== Relative Time Formatter Classes =====

abstract class _RelativeTimeFormatter {
  String format(Duration difference);
}

class _RelativeTimeEN extends _RelativeTimeFormatter {
  @override
  String format(Duration difference) {
    if (difference.isNegative) {
      difference = -difference;
      if (difference.inDays > 365) {
        final years = (difference.inDays / 365).floor();
        return 'in $years ${years == 1 ? 'year' : 'years'}';
      } else if (difference.inDays > 30) {
        final months = (difference.inDays / 30).floor();
        return 'in $months ${months == 1 ? 'month' : 'months'}';
      } else if (difference.inDays > 0) {
        return 'in ${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'}';
      } else if (difference.inHours > 0) {
        return 'in ${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'}';
      } else if (difference.inMinutes > 0) {
        return 'in ${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'}';
      } else {
        return 'in a moment';
      }
    } else {
      if (difference.inDays > 365) {
        final years = (difference.inDays / 365).floor();
        return '$years ${years == 1 ? 'year' : 'years'} ago';
      } else if (difference.inDays > 30) {
        final months = (difference.inDays / 30).floor();
        return '$months ${months == 1 ? 'month' : 'months'} ago';
      } else if (difference.inDays > 0) {
        return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
      } else {
        return 'just now';
      }
    }
  }
}

class _RelativeTimeKO extends _RelativeTimeFormatter {
  @override
  String format(Duration difference) {
    if (difference.isNegative) {
      difference = -difference;
      if (difference.inDays > 365) {
        final years = (difference.inDays / 365).floor();
        return '$years년 후';
      } else if (difference.inDays > 30) {
        final months = (difference.inDays / 30).floor();
        return '$months개월 후';
      } else if (difference.inDays > 0) {
        return '${difference.inDays}일 후';
      } else if (difference.inHours > 0) {
        return '${difference.inHours}시간 후';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes}분 후';
      } else {
        return '곧';
      }
    } else {
      if (difference.inDays > 365) {
        final years = (difference.inDays / 365).floor();
        return '$years년 전';
      } else if (difference.inDays > 30) {
        final months = (difference.inDays / 30).floor();
        return '$months개월 전';
      } else if (difference.inDays > 0) {
        return '${difference.inDays}일 전';
      } else if (difference.inHours > 0) {
        return '${difference.inHours}시간 전';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes}분 전';
      } else {
        return '방금';
      }
    }
  }
}

class _RelativeTimeJA extends _RelativeTimeFormatter {
  @override
  String format(Duration difference) {
    if (difference.isNegative) {
      difference = -difference;
      if (difference.inDays > 365) {
        final years = (difference.inDays / 365).floor();
        return '$years年後';
      } else if (difference.inDays > 30) {
        final months = (difference.inDays / 30).floor();
        return '$monthsヶ月後';
      } else if (difference.inDays > 0) {
        return '${difference.inDays}日後';
      } else if (difference.inHours > 0) {
        return '${difference.inHours}時間後';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes}分後';
      } else {
        return 'まもなく';
      }
    } else {
      if (difference.inDays > 365) {
        final years = (difference.inDays / 365).floor();
        return '$years年前';
      } else if (difference.inDays > 30) {
        final months = (difference.inDays / 30).floor();
        return '$monthsヶ月前';
      } else if (difference.inDays > 0) {
        return '${difference.inDays}日前';
      } else if (difference.inHours > 0) {
        return '${difference.inHours}時間前';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes}分前';
      } else {
        return 'たった今';
      }
    }
  }
}

class _RelativeTimeZH extends _RelativeTimeFormatter {
  @override
  String format(Duration difference) {
    if (difference.isNegative) {
      difference = -difference;
      if (difference.inDays > 365) {
        final years = (difference.inDays / 365).floor();
        return '$years年后';
      } else if (difference.inDays > 30) {
        final months = (difference.inDays / 30).floor();
        return '$months个月后';
      } else if (difference.inDays > 0) {
        return '${difference.inDays}天后';
      } else if (difference.inHours > 0) {
        return '${difference.inHours}小时后';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes}分钟后';
      } else {
        return '马上';
      }
    } else {
      if (difference.inDays > 365) {
        final years = (difference.inDays / 365).floor();
        return '$years年前';
      } else if (difference.inDays > 30) {
        final months = (difference.inDays / 30).floor();
        return '$months个月前';
      } else if (difference.inDays > 0) {
        return '${difference.inDays}天前';
      } else if (difference.inHours > 0) {
        return '${difference.inHours}小时前';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes}分钟前';
      } else {
        return '刚刚';
      }
    }
  }
}

class _RelativeTimeTH extends _RelativeTimeFormatter {
  @override
  String format(Duration difference) {
    if (difference.isNegative) {
      difference = -difference;
      if (difference.inDays > 365) {
        final years = (difference.inDays / 365).floor();
        return 'ใน $years ปี';
      } else if (difference.inDays > 30) {
        final months = (difference.inDays / 30).floor();
        return 'ใน $months เดือน';
      } else if (difference.inDays > 0) {
        return 'ใน ${difference.inDays} วัน';
      } else if (difference.inHours > 0) {
        return 'ใน ${difference.inHours} ชั่วโมง';
      } else if (difference.inMinutes > 0) {
        return 'ใน ${difference.inMinutes} นาที';
      } else {
        return 'เร็วๆ นี้';
      }
    } else {
      if (difference.inDays > 365) {
        final years = (difference.inDays / 365).floor();
        return '$years ปีที่แล้ว';
      } else if (difference.inDays > 30) {
        final months = (difference.inDays / 30).floor();
        return '$months เดือนที่แล้ว';
      } else if (difference.inDays > 0) {
        return '${difference.inDays} วันที่แล้ว';
      } else if (difference.inHours > 0) {
        return '${difference.inHours} ชั่วโมงที่แล้ว';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes} นาทีที่แล้ว';
      } else {
        return 'เมื่อสักครู่';
      }
    }
  }
}

class _RelativeTimeVI extends _RelativeTimeFormatter {
  @override
  String format(Duration difference) {
    if (difference.isNegative) {
      difference = -difference;
      if (difference.inDays > 365) {
        final years = (difference.inDays / 365).floor();
        return 'trong $years năm';
      } else if (difference.inDays > 30) {
        final months = (difference.inDays / 30).floor();
        return 'trong $months tháng';
      } else if (difference.inDays > 0) {
        return 'trong ${difference.inDays} ngày';
      } else if (difference.inHours > 0) {
        return 'trong ${difference.inHours} giờ';
      } else if (difference.inMinutes > 0) {
        return 'trong ${difference.inMinutes} phút';
      } else {
        return 'sắp tới';
      }
    } else {
      if (difference.inDays > 365) {
        final years = (difference.inDays / 365).floor();
        return '$years năm trước';
      } else if (difference.inDays > 30) {
        final months = (difference.inDays / 30).floor();
        return '$months tháng trước';
      } else if (difference.inDays > 0) {
        return '${difference.inDays} ngày trước';
      } else if (difference.inHours > 0) {
        return '${difference.inHours} giờ trước';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes} phút trước';
      } else {
        return 'vừa xong';
      }
    }
  }
}

class _RelativeTimeID extends _RelativeTimeFormatter {
  @override
  String format(Duration difference) {
    if (difference.isNegative) {
      difference = -difference;
      if (difference.inDays > 365) {
        final years = (difference.inDays / 365).floor();
        return 'dalam $years tahun';
      } else if (difference.inDays > 30) {
        final months = (difference.inDays / 30).floor();
        return 'dalam $months bulan';
      } else if (difference.inDays > 0) {
        return 'dalam ${difference.inDays} hari';
      } else if (difference.inHours > 0) {
        return 'dalam ${difference.inHours} jam';
      } else if (difference.inMinutes > 0) {
        return 'dalam ${difference.inMinutes} menit';
      } else {
        return 'segera';
      }
    } else {
      if (difference.inDays > 365) {
        final years = (difference.inDays / 365).floor();
        return '$years tahun yang lalu';
      } else if (difference.inDays > 30) {
        final months = (difference.inDays / 30).floor();
        return '$months bulan yang lalu';
      } else if (difference.inDays > 0) {
        return '${difference.inDays} hari yang lalu';
      } else if (difference.inHours > 0) {
        return '${difference.inHours} jam yang lalu';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes} menit yang lalu';
      } else {
        return 'baru saja';
      }
    }
  }
}

class _RelativeTimeES extends _RelativeTimeFormatter {
  @override
  String format(Duration difference) {
    if (difference.isNegative) {
      difference = -difference;
      if (difference.inDays > 365) {
        final years = (difference.inDays / 365).floor();
        return 'en $years ${years == 1 ? 'año' : 'años'}';
      } else if (difference.inDays > 30) {
        final months = (difference.inDays / 30).floor();
        return 'en $months ${months == 1 ? 'mes' : 'meses'}';
      } else if (difference.inDays > 0) {
        return 'en ${difference.inDays} ${difference.inDays == 1 ? 'día' : 'días'}';
      } else if (difference.inHours > 0) {
        return 'en ${difference.inHours} ${difference.inHours == 1 ? 'hora' : 'horas'}';
      } else if (difference.inMinutes > 0) {
        return 'en ${difference.inMinutes} ${difference.inMinutes == 1 ? 'minuto' : 'minutos'}';
      } else {
        return 'pronto';
      }
    } else {
      if (difference.inDays > 365) {
        final years = (difference.inDays / 365).floor();
        return 'hace $years ${years == 1 ? 'año' : 'años'}';
      } else if (difference.inDays > 30) {
        final months = (difference.inDays / 30).floor();
        return 'hace $months ${months == 1 ? 'mes' : 'meses'}';
      } else if (difference.inDays > 0) {
        return 'hace ${difference.inDays} ${difference.inDays == 1 ? 'día' : 'días'}';
      } else if (difference.inHours > 0) {
        return 'hace ${difference.inHours} ${difference.inHours == 1 ? 'hora' : 'horas'}';
      } else if (difference.inMinutes > 0) {
        return 'hace ${difference.inMinutes} ${difference.inMinutes == 1 ? 'minuto' : 'minutos'}';
      } else {
        return 'ahora mismo';
      }
    }
  }
}

class _RelativeTimeFR extends _RelativeTimeFormatter {
  @override
  String format(Duration difference) {
    if (difference.isNegative) {
      difference = -difference;
      if (difference.inDays > 365) {
        final years = (difference.inDays / 365).floor();
        return 'dans $years ${years == 1 ? 'an' : 'ans'}';
      } else if (difference.inDays > 30) {
        final months = (difference.inDays / 30).floor();
        return 'dans $months mois';
      } else if (difference.inDays > 0) {
        return 'dans ${difference.inDays} ${difference.inDays == 1 ? 'jour' : 'jours'}';
      } else if (difference.inHours > 0) {
        return 'dans ${difference.inHours} ${difference.inHours == 1 ? 'heure' : 'heures'}';
      } else if (difference.inMinutes > 0) {
        return 'dans ${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'}';
      } else {
        return 'bientôt';
      }
    } else {
      if (difference.inDays > 365) {
        final years = (difference.inDays / 365).floor();
        return 'il y a $years ${years == 1 ? 'an' : 'ans'}';
      } else if (difference.inDays > 30) {
        final months = (difference.inDays / 30).floor();
        return 'il y a $months mois';
      } else if (difference.inDays > 0) {
        return 'il y a ${difference.inDays} ${difference.inDays == 1 ? 'jour' : 'jours'}';
      } else if (difference.inHours > 0) {
        return 'il y a ${difference.inHours} ${difference.inHours == 1 ? 'heure' : 'heures'}';
      } else if (difference.inMinutes > 0) {
        return 'il y a ${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'}';
      } else {
        return 'à l\'instant';
      }
    }
  }
}

class _RelativeTimeDE extends _RelativeTimeFormatter {
  @override
  String format(Duration difference) {
    if (difference.isNegative) {
      difference = -difference;
      if (difference.inDays > 365) {
        final years = (difference.inDays / 365).floor();
        return 'in $years ${years == 1 ? 'Jahr' : 'Jahren'}';
      } else if (difference.inDays > 30) {
        final months = (difference.inDays / 30).floor();
        return 'in $months ${months == 1 ? 'Monat' : 'Monaten'}';
      } else if (difference.inDays > 0) {
        return 'in ${difference.inDays} ${difference.inDays == 1 ? 'Tag' : 'Tagen'}';
      } else if (difference.inHours > 0) {
        return 'in ${difference.inHours} ${difference.inHours == 1 ? 'Stunde' : 'Stunden'}';
      } else if (difference.inMinutes > 0) {
        return 'in ${difference.inMinutes} ${difference.inMinutes == 1 ? 'Minute' : 'Minuten'}';
      } else {
        return 'gleich';
      }
    } else {
      if (difference.inDays > 365) {
        final years = (difference.inDays / 365).floor();
        return 'vor $years ${years == 1 ? 'Jahr' : 'Jahren'}';
      } else if (difference.inDays > 30) {
        final months = (difference.inDays / 30).floor();
        return 'vor $months ${months == 1 ? 'Monat' : 'Monaten'}';
      } else if (difference.inDays > 0) {
        return 'vor ${difference.inDays} ${difference.inDays == 1 ? 'Tag' : 'Tagen'}';
      } else if (difference.inHours > 0) {
        return 'vor ${difference.inHours} ${difference.inHours == 1 ? 'Stunde' : 'Stunden'}';
      } else if (difference.inMinutes > 0) {
        return 'vor ${difference.inMinutes} ${difference.inMinutes == 1 ? 'Minute' : 'Minuten'}';
      } else {
        return 'gerade eben';
      }
    }
  }
}

class _RelativeTimeRU extends _RelativeTimeFormatter {
  @override
  String format(Duration difference) {
    if (difference.isNegative) {
      difference = -difference;
      if (difference.inDays > 365) {
        final years = (difference.inDays / 365).floor();
        return 'через $years ${_pluralRussian(years, 'год', 'года', 'лет')}';
      } else if (difference.inDays > 30) {
        final months = (difference.inDays / 30).floor();
        return 'через $months ${_pluralRussian(months, 'месяц', 'месяца', 'месяцев')}';
      } else if (difference.inDays > 0) {
        return 'через ${difference.inDays} ${_pluralRussian(difference.inDays, 'день', 'дня', 'дней')}';
      } else if (difference.inHours > 0) {
        return 'через ${difference.inHours} ${_pluralRussian(difference.inHours, 'час', 'часа', 'часов')}';
      } else if (difference.inMinutes > 0) {
        return 'через ${difference.inMinutes} ${_pluralRussian(difference.inMinutes, 'минуту', 'минуты', 'минут')}';
      } else {
        return 'скоро';
      }
    } else {
      if (difference.inDays > 365) {
        final years = (difference.inDays / 365).floor();
        return '$years ${_pluralRussian(years, 'год', 'года', 'лет')} назад';
      } else if (difference.inDays > 30) {
        final months = (difference.inDays / 30).floor();
        return '$months ${_pluralRussian(months, 'месяц', 'месяца', 'месяцев')} назад';
      } else if (difference.inDays > 0) {
        return '${difference.inDays} ${_pluralRussian(difference.inDays, 'день', 'дня', 'дней')} назад';
      } else if (difference.inHours > 0) {
        return '${difference.inHours} ${_pluralRussian(difference.inHours, 'час', 'часа', 'часов')} назад';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes} ${_pluralRussian(difference.inMinutes, 'минуту', 'минуты', 'минут')} назад';
      } else {
        return 'только что';
      }
    }
  }
  
  String _pluralRussian(int n, String one, String few, String many) {
    if (n % 10 == 1 && n % 100 != 11) return one;
    if (n % 10 >= 2 && n % 10 <= 4 && (n % 100 < 10 || n % 100 >= 20)) return few;
    return many;
  }
}

class _RelativeTimePT extends _RelativeTimeFormatter {
  @override
  String format(Duration difference) {
    if (difference.isNegative) {
      difference = -difference;
      if (difference.inDays > 365) {
        final years = (difference.inDays / 365).floor();
        return 'em $years ${years == 1 ? 'ano' : 'anos'}';
      } else if (difference.inDays > 30) {
        final months = (difference.inDays / 30).floor();
        return 'em $months ${months == 1 ? 'mês' : 'meses'}';
      } else if (difference.inDays > 0) {
        return 'em ${difference.inDays} ${difference.inDays == 1 ? 'dia' : 'dias'}';
      } else if (difference.inHours > 0) {
        return 'em ${difference.inHours} ${difference.inHours == 1 ? 'hora' : 'horas'}';
      } else if (difference.inMinutes > 0) {
        return 'em ${difference.inMinutes} ${difference.inMinutes == 1 ? 'minuto' : 'minutos'}';
      } else {
        return 'em breve';
      }
    } else {
      if (difference.inDays > 365) {
        final years = (difference.inDays / 365).floor();
        return 'há $years ${years == 1 ? 'ano' : 'anos'}';
      } else if (difference.inDays > 30) {
        final months = (difference.inDays / 30).floor();
        return 'há $months ${months == 1 ? 'mês' : 'meses'}';
      } else if (difference.inDays > 0) {
        return 'há ${difference.inDays} ${difference.inDays == 1 ? 'dia' : 'dias'}';
      } else if (difference.inHours > 0) {
        return 'há ${difference.inHours} ${difference.inHours == 1 ? 'hora' : 'horas'}';
      } else if (difference.inMinutes > 0) {
        return 'há ${difference.inMinutes} ${difference.inMinutes == 1 ? 'minuto' : 'minutos'}';
      } else {
        return 'agora mesmo';
      }
    }
  }
}

class _RelativeTimeIT extends _RelativeTimeFormatter {
  @override
  String format(Duration difference) {
    if (difference.isNegative) {
      difference = -difference;
      if (difference.inDays > 365) {
        final years = (difference.inDays / 365).floor();
        return 'tra $years ${years == 1 ? 'anno' : 'anni'}';
      } else if (difference.inDays > 30) {
        final months = (difference.inDays / 30).floor();
        return 'tra $months ${months == 1 ? 'mese' : 'mesi'}';
      } else if (difference.inDays > 0) {
        return 'tra ${difference.inDays} ${difference.inDays == 1 ? 'giorno' : 'giorni'}';
      } else if (difference.inHours > 0) {
        return 'tra ${difference.inHours} ${difference.inHours == 1 ? 'ora' : 'ore'}';
      } else if (difference.inMinutes > 0) {
        return 'tra ${difference.inMinutes} ${difference.inMinutes == 1 ? 'minuto' : 'minuti'}';
      } else {
        return 'a breve';
      }
    } else {
      if (difference.inDays > 365) {
        final years = (difference.inDays / 365).floor();
        return '$years ${years == 1 ? 'anno' : 'anni'} fa';
      } else if (difference.inDays > 30) {
        final months = (difference.inDays / 30).floor();
        return '$months ${months == 1 ? 'mese' : 'mesi'} fa';
      } else if (difference.inDays > 0) {
        return '${difference.inDays} ${difference.inDays == 1 ? 'giorno' : 'giorni'} fa';
      } else if (difference.inHours > 0) {
        return '${difference.inHours} ${difference.inHours == 1 ? 'ora' : 'ore'} fa';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minuto' : 'minuti'} fa';
      } else {
        return 'proprio ora';
      }
    }
  }
}