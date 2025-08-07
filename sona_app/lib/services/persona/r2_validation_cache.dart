import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// R2 이미지 검증 결과를 캐싱하는 서비스
/// 메모리와 SharedPreferences를 사용한 2단계 캐싱
class R2ValidationCache {
  // 메모리 캐시
  static final Map<String, bool> _memoryCache = {};
  static final Map<String, DateTime> _cacheExpiry = {};

  // 캐시 설정
  static const Duration _memoryCacheDuration = Duration(hours: 24);
  static const Duration _persistentCacheDuration = Duration(days: 7);
  static const String _cacheKeyPrefix = 'r2_validation_';
  static const String _cacheMetaKey = 'r2_validation_meta';

  /// 캐시에서 검증 결과 가져오기
  static Future<bool?> getCached(String personaId) async {
    // 1. 메모리 캐시 확인
    final memoryResult = _getFromMemoryCache(personaId);
    if (memoryResult != null) {
      return memoryResult;
    }

    // 2. SharedPreferences 캐시 확인
    final persistentResult = await _getFromPersistentCache(personaId);
    if (persistentResult != null) {
      // 메모리 캐시에도 저장
      _setMemoryCache(personaId, persistentResult);
    }

    return persistentResult;
  }

  /// 캐시에 검증 결과 저장
  static Future<void> setCache(String personaId, bool hasR2Image) async {
    // 1. 메모리 캐시에 저장
    _setMemoryCache(personaId, hasR2Image);

    // 2. SharedPreferences에도 저장
    await _setPersistentCache(personaId, hasR2Image);
  }

  /// 특정 페르소나의 캐시 무효화
  static Future<void> invalidate(String personaId) async {
    // 메모리 캐시에서 제거
    _memoryCache.remove(personaId);
    _cacheExpiry.remove(personaId);

    // SharedPreferences에서 제거
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('$_cacheKeyPrefix$personaId');

    // 메타데이터 업데이트
    await _updateCacheMeta(prefs);
  }

  /// 모든 캐시 삭제
  static Future<void> clearAll() async {
    // 메모리 캐시 클리어
    _memoryCache.clear();
    _cacheExpiry.clear();

    // SharedPreferences 클리어
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs
        .getKeys()
        .where((key) => key.startsWith(_cacheKeyPrefix))
        .toList();

    for (final key in keys) {
      await prefs.remove(key);
    }

    await prefs.remove(_cacheMetaKey);
  }

  /// 만료된 캐시 정리
  static Future<void> cleanExpiredCache() async {
    final now = DateTime.now();

    // 메모리 캐시 정리
    final expiredKeys = <String>[];
    _cacheExpiry.forEach((key, expiry) {
      if (now.isAfter(expiry)) {
        expiredKeys.add(key);
      }
    });

    for (final key in expiredKeys) {
      _memoryCache.remove(key);
      _cacheExpiry.remove(key);
    }

    // SharedPreferences 정리
    final prefs = await SharedPreferences.getInstance();
    final meta = await _getCacheMeta(prefs);
    final updatedMeta = <String, dynamic>{};

    meta.forEach((personaId, timestamp) {
      final expiry = DateTime.parse(timestamp).add(_persistentCacheDuration);
      if (now.isBefore(expiry)) {
        updatedMeta[personaId] = timestamp;
      } else {
        // 만료된 항목 제거
        prefs.remove('$_cacheKeyPrefix$personaId');
      }
    });

    await prefs.setString(_cacheMetaKey, jsonEncode(updatedMeta));
  }

  // Private methods

  static bool? _getFromMemoryCache(String personaId) {
    final expiry = _cacheExpiry[personaId];
    if (expiry != null && DateTime.now().isBefore(expiry)) {
      return _memoryCache[personaId];
    }
    // 만료된 경우 제거
    _memoryCache.remove(personaId);
    _cacheExpiry.remove(personaId);
    return null;
  }

  static void _setMemoryCache(String personaId, bool hasR2Image) {
    _memoryCache[personaId] = hasR2Image;
    _cacheExpiry[personaId] = DateTime.now().add(_memoryCacheDuration);
  }

  static Future<bool?> _getFromPersistentCache(String personaId) async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getBool('$_cacheKeyPrefix$personaId');

    if (value != null) {
      // 만료 확인
      final meta = await _getCacheMeta(prefs);
      final timestamp = meta[personaId];

      if (timestamp != null) {
        final expiry = DateTime.parse(timestamp).add(_persistentCacheDuration);
        if (DateTime.now().isBefore(expiry)) {
          return value;
        }
      }

      // 만료된 경우 제거
      await prefs.remove('$_cacheKeyPrefix$personaId');
    }

    return null;
  }

  static Future<void> _setPersistentCache(
      String personaId, bool hasR2Image) async {
    final prefs = await SharedPreferences.getInstance();

    // 값 저장
    await prefs.setBool('$_cacheKeyPrefix$personaId', hasR2Image);

    // 메타데이터 업데이트
    final meta = await _getCacheMeta(prefs);
    meta[personaId] = DateTime.now().toIso8601String();
    await prefs.setString(_cacheMetaKey, jsonEncode(meta));
  }

  static Future<Map<String, dynamic>> _getCacheMeta(
      SharedPreferences prefs) async {
    final metaString = prefs.getString(_cacheMetaKey);
    if (metaString != null) {
      return Map<String, dynamic>.from(jsonDecode(metaString));
    }
    return {};
  }

  static Future<void> _updateCacheMeta(SharedPreferences prefs) async {
    final meta = await _getCacheMeta(prefs);

    // 실제로 존재하는 캐시 항목만 유지
    final validMeta = <String, dynamic>{};
    for (final entry in meta.entries) {
      if (prefs.containsKey('$_cacheKeyPrefix${entry.key}')) {
        validMeta[entry.key] = entry.value;
      }
    }

    await prefs.setString(_cacheMetaKey, jsonEncode(validMeta));
  }

  /// 캐시 통계 가져오기 (디버깅용)
  static Future<Map<String, dynamic>> getCacheStats() async {
    final prefs = await SharedPreferences.getInstance();
    final meta = await _getCacheMeta(prefs);

    return {
      'memoryCount': _memoryCache.length,
      'persistentCount': meta.length,
      'memoryCacheSize': _memoryCache.length * 8, // 대략적인 바이트 크기
      'oldestEntry': _findOldestEntry(meta),
      'newestEntry': _findNewestEntry(meta),
    };
  }

  static String? _findOldestEntry(Map<String, dynamic> meta) {
    if (meta.isEmpty) return null;

    String? oldest;
    DateTime? oldestTime;

    meta.forEach((key, value) {
      final time = DateTime.parse(value);
      if (oldestTime == null || time.isBefore(oldestTime!)) {
        oldest = key;
        oldestTime = time;
      }
    });

    return oldest;
  }

  static String? _findNewestEntry(Map<String, dynamic> meta) {
    if (meta.isEmpty) return null;

    String? newest;
    DateTime? newestTime;

    meta.forEach((key, value) {
      final time = DateTime.parse(value);
      if (newestTime == null || time.isAfter(newestTime!)) {
        newest = key;
        newestTime = time;
      }
    });

    return newest;
  }
}
