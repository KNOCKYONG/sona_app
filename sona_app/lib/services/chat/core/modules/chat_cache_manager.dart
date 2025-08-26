import 'dart:collection';
import 'package:flutter/material.dart';

/// 캐시된 응답 데이터
class CachedResponse {
  final String response;
  final DateTime timestamp;
  final String personaId;
  final Map<String, dynamic>? metadata;
  
  CachedResponse({
    required this.response,
    required this.timestamp,
    required this.personaId,
    this.metadata,
  });
  
  /// 캐시 유효성 확인 (기본 5분)
  bool isValid({Duration maxAge = const Duration(minutes: 5)}) {
    return DateTime.now().difference(timestamp) < maxAge;
  }
}

/// 채팅 캐시 관리 모듈
/// 응답 캐싱 및 메모리 관리 담당
class ChatCacheManager {
  // 캐시 저장소 (LRU 캐시)
  final LinkedHashMap<String, CachedResponse> _responseCache = 
      LinkedHashMap<String, CachedResponse>();
  
  // 캐시 설정
  static const int _maxCacheSize = 100;
  static const Duration _defaultCacheDuration = Duration(minutes: 5);
  static const Duration _cleanupInterval = Duration(minutes: 10);
  
  // 통계
  int _cacheHits = 0;
  int _cacheMisses = 0;
  DateTime? _lastCleanup;
  
  /// 캐시 키 생성
  String generateCacheKey(String personaId, String message) {
    // 간단한 해시 함수 (실제로는 더 복잡한 해시 사용 권장)
    final normalized = message.toLowerCase().trim();
    final hash = normalized.hashCode;
    return '${personaId}_$hash';
  }
  
  /// 캐시된 응답 가져오기
  String? getCachedResponse(String key, {Duration? maxAge}) {
    final cached = _responseCache[key];
    
    if (cached == null) {
      _cacheMisses++;
      return null;
    }
    
    // 유효성 확인
    if (!cached.isValid(maxAge: maxAge ?? _defaultCacheDuration)) {
      _responseCache.remove(key);
      _cacheMisses++;
      return null;
    }
    
    // LRU 업데이트 (최근 사용으로 이동)
    _responseCache.remove(key);
    _responseCache[key] = cached;
    
    _cacheHits++;
    return cached.response;
  }
  
  /// 응답 캐시에 추가
  void addToCache(
    String key, 
    String response, 
    String personaId, {
    Map<String, dynamic>? metadata,
  }) {
    // 캐시 크기 제한 확인
    if (_responseCache.length >= _maxCacheSize) {
      // LRU: 가장 오래된 항목 제거
      final oldestKey = _responseCache.keys.first;
      _responseCache.remove(oldestKey);
    }
    
    // 새 항목 추가
    _responseCache[key] = CachedResponse(
      response: response,
      timestamp: DateTime.now(),
      personaId: personaId,
      metadata: metadata,
    );
    
    // 주기적 정리
    _performCleanupIfNeeded();
  }
  
  /// 특정 페르소나의 캐시 삭제
  void clearPersonaCache(String personaId) {
    _responseCache.removeWhere((key, value) => value.personaId == personaId);
  }
  
  /// 모든 캐시 삭제
  void clearAllCache() {
    _responseCache.clear();
    _cacheHits = 0;
    _cacheMisses = 0;
  }
  
  /// 오래된 캐시 정리
  void cleanupOldCache({Duration? maxAge}) {
    final cutoff = maxAge ?? _defaultCacheDuration;
    final now = DateTime.now();
    
    _responseCache.removeWhere((key, value) {
      return now.difference(value.timestamp) > cutoff;
    });
    
    _lastCleanup = now;
  }
  
  /// 필요시 자동 정리
  void _performCleanupIfNeeded() {
    if (_lastCleanup == null) {
      _lastCleanup = DateTime.now();
      return;
    }
    
    if (DateTime.now().difference(_lastCleanup!) > _cleanupInterval) {
      cleanupOldCache();
    }
  }
  
  /// 캐시 크기 가져오기
  int getCacheSize() => _responseCache.length;
  
  /// 캐시 메모리 추정 (바이트)
  int getEstimatedMemoryUsage() {
    int totalSize = 0;
    
    _responseCache.forEach((key, value) {
      // 키 크기
      totalSize += key.length * 2; // UTF-16
      // 응답 크기
      totalSize += value.response.length * 2;
      // 메타데이터 추정
      totalSize += 100; // 대략적인 오버헤드
    });
    
    return totalSize;
  }
  
  /// 캐시 히트율 계산
  double getHitRate() {
    final total = _cacheHits + _cacheMisses;
    if (total == 0) return 0.0;
    return _cacheHits / total;
  }
  
  /// 캐시 통계
  Map<String, dynamic> getStatistics() {
    return {
      'cacheSize': _responseCache.length,
      'maxSize': _maxCacheSize,
      'hits': _cacheHits,
      'misses': _cacheMisses,
      'hitRate': '${(getHitRate() * 100).toStringAsFixed(1)}%',
      'estimatedMemory': '${(getEstimatedMemoryUsage() / 1024).toStringAsFixed(1)} KB',
      'lastCleanup': _lastCleanup?.toIso8601String() ?? 'Never',
      'oldestEntry': _responseCache.isEmpty 
          ? null 
          : _responseCache.values.first.timestamp.toIso8601String(),
      'newestEntry': _responseCache.isEmpty
          ? null
          : _responseCache.values.last.timestamp.toIso8601String(),
    };
  }
  
  /// 캐시 내용 디버깅 (개발용)
  void debugPrintCache() {
    debugPrint('=== Cache Contents ===');
    debugPrint('Total entries: ${_responseCache.length}');
    
    _responseCache.forEach((key, value) {
      final age = DateTime.now().difference(value.timestamp);
      debugPrint('Key: $key');
      debugPrint('  PersonaId: ${value.personaId}');
      debugPrint('  Age: ${age.inSeconds}s');
      debugPrint('  Response preview: ${value.response.substring(0, 
          value.response.length > 50 ? 50 : value.response.length)}...');
    });
    
    debugPrint('=== Cache Statistics ===');
    final stats = getStatistics();
    stats.forEach((key, value) {
      debugPrint('$key: $value');
    });
  }
  
  /// 특정 메시지에 대한 캐시 확인
  bool hasCachedResponse(String personaId, String message) {
    final key = generateCacheKey(personaId, message);
    final cached = _responseCache[key];
    
    if (cached == null) return false;
    return cached.isValid();
  }
  
  /// 캐시 워밍 (사전 로딩)
  void warmCache(Map<String, String> preloadData, String personaId) {
    preloadData.forEach((message, response) {
      final key = generateCacheKey(personaId, message);
      addToCache(key, response, personaId);
    });
  }
  
  /// 캐시 압축 (메모리 부족 시)
  void compressCache({int targetSize = 50}) {
    if (_responseCache.length <= targetSize) return;
    
    // 가장 오래된 항목들 제거
    while (_responseCache.length > targetSize) {
      final oldestKey = _responseCache.keys.first;
      _responseCache.remove(oldestKey);
    }
    
    debugPrint('Cache compressed to $targetSize entries');
  }
}