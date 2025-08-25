import 'dart:collection';
import 'dart:math';
import 'package:flutter/foundation.dart';

/// 응답 변형 캐싱 시스템
/// 반복 응답을 방지하고 다양한 변형을 저장/관리
class ResponseVariationCache {
  static final ResponseVariationCache _instance = ResponseVariationCache._internal();
  factory ResponseVariationCache() => _instance;
  ResponseVariationCache._internal();

  // 페르소나별 응답 캐시
  final Map<String, PersonaResponseCache> _personaCaches = {};
  
  // 전역 응답 히스토리 (반복 방지용)
  final LinkedHashMap<String, DateTime> _globalResponseHistory = LinkedHashMap();
  static const int _maxGlobalHistory = 200;  // 100 -> 200으로 확대
  
  // AI가 생성한 응답을 캐싱하기 위한 저장소 (하드코딩 없음)
  // 카테고리별로 OpenAI API가 생성한 응답들만 저장됨
  final Map<String, List<String>> _variationTemplates = {};

  /// 페르소나별 캐시 가져오기 (없으면 생성)
  PersonaResponseCache getPersonaCache(String personaId) {
    return _personaCaches.putIfAbsent(
      personaId,
      () => PersonaResponseCache(personaId),
    );
  }

  /// 응답이 최근에 사용되었는지 확인 (의미 기반)
  bool isRecentlyUsed(String response, {int withinTurns = 10}) {
    final normalized = _normalizeResponse(response);
    
    // 짧은 응답은 더 엄격하게 체크 (5단어 이하)
    final wordCount = response.split(' ').length;
    final strictCheck = wordCount <= 5;
    
    // 전역 히스토리에서 의미 유사도 체크
    for (final entry in _globalResponseHistory.entries) {
      final historyNormalized = _normalizeResponse(entry.key);
      final similarity = _calculateSemanticSimilarity(normalized, historyNormalized);
      
      // 의미 유사도가 높으면 반복으로 간주
      if (similarity > 0.7) {  // 70% 이상 유사
        final minutesSinceUsed = DateTime.now().difference(entry.value).inMinutes;
        
        // 짧은 응답은 더 긴 시간 필터링
        final timeThreshold = strictCheck ? 60 : 30;
        if (minutesSinceUsed < timeThreshold) {
          return true;
        }
      }
    }
    
    return false;
  }

  /// 응답 사용 기록
  void recordResponse(String response) {
    final normalized = _normalizeResponse(response);
    
    // 전역 히스토리에 추가
    _globalResponseHistory[normalized] = DateTime.now();
    
    // 크기 제한
    if (_globalResponseHistory.length > _maxGlobalHistory) {
      _globalResponseHistory.remove(_globalResponseHistory.keys.first);
    }
  }

  /// 카테고리별 변형 가져오기 (캐싱된 응답만 반환, 하드코딩 없음)
  String? getVariation(String category, {String? personaId}) {
    // 하드코딩된 응답을 반환하지 않음
    // AI가 생성한 응답만 캐싱에서 가져옴
    final templates = _variationTemplates[category];
    if (templates == null || templates.isEmpty) return null;
    
    // 사용 가능한 변형 찾기 (최근 사용하지 않은 것)
    final availableVariations = templates.where((template) {
      return !isRecentlyUsed(template, withinTurns: 10);
    }).toList();
    
    if (availableVariations.isEmpty) {
      // 모든 변형이 최근 사용됨 - null 반환하여 AI가 새로운 응답 생성하도록
      return null;
    }
    
    // 랜덤 선택
    final selected = availableVariations[Random().nextInt(availableVariations.length)];
    recordResponse(selected);
    
    return selected;
  }

  /// 카테고리에 새로운 변형 추가 (중복 체크 강화)
  void addVariation(String category, String variation) {
    // 이미 유사한 응답이 있는지 체크
    final templates = _variationTemplates.putIfAbsent(category, () => []);
    
    // 의미 유사도 체크
    bool isDuplicate = false;
    for (final existing in templates) {
      final similarity = _calculateSemanticSimilarity(
        _normalizeResponse(variation),
        _normalizeResponse(existing),
      );
      if (similarity > 0.8) {  // 80% 이상 유사하면 중복
        isDuplicate = true;
        break;
      }
    }
    
    if (!isDuplicate) {
      templates.add(variation);
      
      // 카테고리별 최대 50개 제한
      if (templates.length > 50) {
        templates.removeAt(0);
      }
    }
  }

  /// 응답 정규화 (의미 보존)
  String _normalizeResponse(String response) {
    // 기본 정규화: 이모티콘, 공백 제거
    String normalized = response
        .replaceAll(RegExp(r'[ㅋㅎㅠ~♥♡💕.!?]+'), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim()
        .toLowerCase();
    
    // 동의어 통일화
    final synonyms = {
      '맞아': '맞아',
      '그래': '맞아',
      '응': '맞아',
      '어': '맞아',
      '좋아': '좋아',
      '개좋아': '좋아',
      '진짜 좋아': '좋아',
      '완전 좋아': '좋아',
      '진짜': '진짜',
      '대박': '진짜',
      '헐': '진짜',
      '와': '진짜',
    };
    
    for (final entry in synonyms.entries) {
      normalized = normalized.replaceAll(entry.key, entry.value);
    }
    
    return normalized;
  }

  /// 카테고리에서 가장 오래된 사용 기록 제거
  void _clearOldestFromCategory(String category) {
    final templates = _variationTemplates[category];
    if (templates == null) return;
    
    DateTime? oldestTime;
    String? oldestKey;
    
    for (final template in templates) {
      final normalized = _normalizeResponse(template);
      if (_globalResponseHistory.containsKey(normalized)) {
        final time = _globalResponseHistory[normalized]!;
        if (oldestTime == null || time.isBefore(oldestTime)) {
          oldestTime = time;
          oldestKey = normalized;
        }
      }
    }
    
    if (oldestKey != null) {
      _globalResponseHistory.remove(oldestKey);
    }
  }

  /// 캐시 통계
  Map<String, dynamic> getStatistics() {
    return {
      'totalPersonaCaches': _personaCaches.length,
      'globalHistorySize': _globalResponseHistory.length,
      'variationCategories': _variationTemplates.keys.toList(),
      'totalVariations': _variationTemplates.values
          .fold(0, (sum, list) => sum + list.length),
    };
  }

  /// 캐시 초기화
  void clear() {
    _personaCaches.clear();
    _globalResponseHistory.clear();
  }
  
  /// 의미 기반 유사도 계산 (향상된 알고리즘)
  double _calculateSemanticSimilarity(String s1, String s2) {
    if (s1.isEmpty || s2.isEmpty) return 0.0;
    if (s1 == s2) return 1.0;
    
    // 1. 단어 수준 비교
    final words1 = s1.split(' ').toSet();
    final words2 = s2.split(' ').toSet();
    final wordIntersection = words1.intersection(words2).length;
    final wordUnion = words1.union(words2).length;
    final wordSimilarity = wordUnion > 0 ? wordIntersection / wordUnion : 0.0;
    
    // 2. 문자 수준 비교 (Levenshtein 거리 기반)
    final charSimilarity = 1 - (_levenshteinDistance(s1, s2) / (s1.length + s2.length));
    
    // 3. 패턴 기반 비교
    final patterns = [
      '진짜', '대박', '헐', '와', '아', '어', '음',
      '그래', '맞아', '좋아', '싫어', '모르겠',
    ];
    int patternCount = 0;
    for (final pattern in patterns) {
      if (s1.contains(pattern) && s2.contains(pattern)) {
        patternCount++;
      }
    }
    final patternSimilarity = patterns.isNotEmpty ? patternCount / patterns.length : 0.0;
    
    // 가중 평균
    return wordSimilarity * 0.5 + charSimilarity * 0.3 + patternSimilarity * 0.2;
  }
  
  /// Levenshtein 거리 계산
  int _levenshteinDistance(String s1, String s2) {
    final m = s1.length;
    final n = s2.length;
    if (m == 0) return n;
    if (n == 0) return m;
    
    final dp = List.generate(m + 1, (_) => List.filled(n + 1, 0));
    
    for (int i = 0; i <= m; i++) dp[i][0] = i;
    for (int j = 0; j <= n; j++) dp[0][j] = j;
    
    for (int i = 1; i <= m; i++) {
      for (int j = 1; j <= n; j++) {
        final cost = s1[i - 1] == s2[j - 1] ? 0 : 1;
        dp[i][j] = [
          dp[i - 1][j] + 1,      // deletion
          dp[i][j - 1] + 1,      // insertion
          dp[i - 1][j - 1] + cost // substitution
        ].reduce((a, b) => a < b ? a : b);
      }
    }
    
    return dp[m][n];
  }
}

/// 페르소나별 응답 캐시
class PersonaResponseCache {
  final String personaId;
  final Map<String, List<String>> _contextResponses = {};
  final LinkedHashMap<String, DateTime> _usageHistory = LinkedHashMap();
  static const int _maxHistorySize = 50;

  PersonaResponseCache(this.personaId);

  /// 컨텍스트별 응답 추가
  void addContextResponse(String context, String response) {
    _contextResponses.putIfAbsent(context, () => []).add(response);
    
    // 컨텍스트별 최대 10개 제한
    if (_contextResponses[context]!.length > 10) {
      _contextResponses[context]!.removeAt(0);
    }
    
    // 사용 기록
    _recordUsage(response);
  }

  /// 컨텍스트에 맞는 응답 가져오기
  String? getContextResponse(String context) {
    final responses = _contextResponses[context];
    if (responses == null || responses.isEmpty) return null;
    
    // 최근 사용하지 않은 응답 찾기
    for (final response in responses) {
      if (!_isRecentlyUsed(response)) {
        _recordUsage(response);
        return response;
      }
    }
    
    // 모두 최근 사용됨 - null 반환하여 새로운 응답 생성 유도
    return null;
  }

  /// 사용 기록
  void _recordUsage(String response) {
    _usageHistory[response] = DateTime.now();
    
    // 크기 제한
    if (_usageHistory.length > _maxHistorySize) {
      _usageHistory.remove(_usageHistory.keys.first);
    }
  }

  /// 최근 사용 여부 확인
  bool _isRecentlyUsed(String response, {int withinMinutes = 30}) {  // 10 -> 30분
    if (!_usageHistory.containsKey(response)) return false;
    
    final lastUsed = _usageHistory[response]!;
    return DateTime.now().difference(lastUsed).inMinutes < withinMinutes;
  }

  /// 통계
  Map<String, dynamic> getStatistics() {
    return {
      'personaId': personaId,
      'contextCount': _contextResponses.length,
      'totalResponses': _contextResponses.values
          .fold(0, (sum, list) => sum + list.length),
      'historySize': _usageHistory.length,
    };
  }
}