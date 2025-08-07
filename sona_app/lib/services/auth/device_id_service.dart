import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

/// 🔧 디바이스 고유 ID 관리 서비스
///
/// 사용자가 로그인하지 않아도 임시 userId를 제공하여
/// Firebase 작업이 정상적으로 수행될 수 있도록 합니다.
class DeviceIdService {
  static const String _deviceIdKey = 'device_unique_id';
  static const String _deviceUserIdKey = 'device_user_id';
  static const Uuid _uuid = Uuid();

  static String? _cachedDeviceId;
  static String? _cachedUserId;

  /// 📱 디바이스 고유 ID 가져오기 (UUID 기반)
  static Future<String> getDeviceId() async {
    if (_cachedDeviceId != null) {
      return _cachedDeviceId!;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      String? deviceId = prefs.getString(_deviceIdKey);

      if (deviceId == null || deviceId.isEmpty) {
        // 새로운 디바이스 ID 생성
        deviceId = _uuid.v4();
        await prefs.setString(_deviceIdKey, deviceId);
        debugPrint('🆔 Generated new device ID: $deviceId');
      } else {
        debugPrint('🆔 Loaded existing device ID: $deviceId');
      }

      _cachedDeviceId = deviceId;
      return deviceId;
    } catch (e) {
      debugPrint('❌ Error getting device ID: $e');
      // 폴백: 임시 UUID
      final fallbackId = _uuid.v4();
      _cachedDeviceId = fallbackId;
      return fallbackId;
    }
  }

  /// 👤 임시 사용자 ID 가져오기 (device_user_ 접두사)
  static Future<String> getTemporaryUserId() async {
    if (_cachedUserId != null) {
      return _cachedUserId!;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString(_deviceUserIdKey);

      if (userId == null || userId.isEmpty) {
        // 디바이스 ID 기반으로 사용자 ID 생성
        final deviceId = await getDeviceId();
        userId = 'device_user_${deviceId.substring(0, 8)}'; // 처음 8자리만 사용
        await prefs.setString(_deviceUserIdKey, userId);
        debugPrint('👤 Generated temporary user ID: $userId');
      } else {
        debugPrint('👤 Loaded existing temporary user ID: $userId');
      }

      _cachedUserId = userId;
      return userId;
    } catch (e) {
      debugPrint('❌ Error getting temporary user ID: $e');
      // 폴백: 간단한 임시 ID
      final fallbackUserId =
          'device_user_${DateTime.now().millisecondsSinceEpoch}';
      _cachedUserId = fallbackUserId;
      return fallbackUserId;
    }
  }

  /// 🎯 현재 사용자 ID 가져오기 (로그인 상태 고려)
  static Future<String> getCurrentUserId({
    String? firebaseUserId,
  }) async {
    if (firebaseUserId != null && firebaseUserId.isNotEmpty) {
      debugPrint('🔥 Using Firebase user ID: $firebaseUserId');
      return firebaseUserId;
    }

    // Firebase 사용자가 없으면 임시 ID 사용
    final tempUserId = await getTemporaryUserId();
    debugPrint('⚡ Using temporary device user ID: $tempUserId');
    return tempUserId;
  }

  /// 🧹 캐시 클리어
  static void clearCache() {
    _cachedDeviceId = null;
    _cachedUserId = null;
  }

  /// 🔄 사용자 ID 리셋 (디바이스 ID는 유지)
  static Future<void> resetUserId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_deviceUserIdKey);
      _cachedUserId = null;
      debugPrint('🔄 User ID reset - will generate new one next time');
    } catch (e) {
      debugPrint('❌ Error resetting user ID: $e');
    }
  }

  /// 📊 디바이스 정보 로그
  static Future<void> logDeviceInfo() async {
    final deviceId = await getDeviceId();
    final userId = await getTemporaryUserId();

    debugPrint('📱 Device Info:');
    debugPrint('   Device ID: $deviceId');
    debugPrint('   Temp User ID: $userId');
    debugPrint('   Cached Device ID: $_cachedDeviceId');
    debugPrint('   Cached User ID: $_cachedUserId');
  }

  /// ✅ 사용자 ID 유효성 검사
  static bool isValidUserId(String? userId) {
    if (userId == null || userId.isEmpty) {
      return false;
    }

    // 최소 길이 체크
    if (userId.length < 3) {
      return false;
    }

    // 알려진 유효한 패턴들
    final validPatterns = [
      'tutorial_user',
      'device_user_',
      // Firebase UID는 보통 28자
    ];

    return validPatterns.any((pattern) => userId.startsWith(pattern)) ||
        userId.length >= 20; // Firebase UID 길이
  }
}
