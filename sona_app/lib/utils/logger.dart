import 'package:flutter/foundation.dart';

/// Simple logger utility for production-ready logging
/// Automatically disabled in release mode
class Logger {
  static const bool _enableLogging = kDebugMode;

  /// Log debug messages (only in debug mode)
  static void debug(String message, [String? tag]) {
    if (_enableLogging) {
      final prefix = tag != null ? '[$tag] ' : '';
      debugPrint('$prefix$message');
    }
  }

  /// Log error messages (always logged)
  static void error(String message, [Object? error, StackTrace? stackTrace]) {
    final errorMessage = error != null ? '\nError: $error' : '';
    final stackMessage = stackTrace != null ? '\nStack: $stackTrace' : '';
    debugPrint('❌ ERROR: $message$errorMessage$stackMessage');
  }

  /// Log warning messages (always logged)
  static void warning(String message) {
    debugPrint('⚠️ WARNING: $message');
  }

  /// Log info messages (only in debug mode)
  static void info(String message) {
    if (_enableLogging) {
      debugPrint('ℹ️ INFO: $message');
    }
  }

  /// Log success messages (only in debug mode)
  static void success(String message) {
    if (_enableLogging) {
      debugPrint('✅ SUCCESS: $message');
    }
  }
}
