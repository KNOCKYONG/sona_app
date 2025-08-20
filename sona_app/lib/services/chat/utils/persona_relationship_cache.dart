import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../models/persona.dart';
import '../../../core/constants.dart';
import '../../base/base_service.dart';
import '../analysis/user_speech_pattern_analyzer.dart';
import '../../../helpers/firebase_helper.dart';

/// 페르소나와 casual speech 설정을 함께 반환하는 클래스
class PersonaWithSpeechStyle {
  final Persona persona;
  final bool isCasualSpeech;
  final DateTime? lastGreetingTime;  // 마지막 인사 시간
  final DateTime? lastWellBeingQuestionTime;  // 마지막 안부 질문 시간
  final Map<String, dynamic>? dailyQuestionStats;  // 일별 질문 통계

  PersonaWithSpeechStyle({
    required this.persona,
    required this.isCasualSpeech,
    this.lastGreetingTime,
    this.lastWellBeingQuestionTime,
    this.dailyQuestionStats,
  });
}

/// 페르소나 관계 정보를 캐싱하여 빠른 접근을 제공하는 서비스
/// Firebase 호출을 최소화하고 완전한 persona 정보를 유지
class PersonaRelationshipCache extends BaseService {
  static PersonaRelationshipCache? _instance;
  static PersonaRelationshipCache get instance =>
      _instance ??= PersonaRelationshipCache._();

  PersonaRelationshipCache._();

  // 캐시 저장소
  final Map<String, _CachedPersonaRelationship> _cache = {};

  // 캐시 유효 시간 (5분)
  static const Duration _cacheValidDuration = Duration(minutes: 5);

  // 주기적 갱신을 위한 타이머
  Timer? _refreshTimer;

  /// 캐시 초기화 및 주기적 갱신 시작
  void initialize() {
    // 3분마다 캐시 갱신
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(
      const Duration(minutes: 3),
      (_) => _refreshExpiredCache(),
    );
  }

  /// 페르소나의 완전한 관계 정보를 가져옴 (캐시 우선)
  Future<PersonaWithSpeechStyle> getCompletePersona({
    required String userId,
    required Persona basePersona,
  }) async {
    final cacheKey = '${userId}_${basePersona.id}';

    // 캐시 확인
    final cached = _cache[cacheKey];
    if (cached != null && !cached.isExpired) {
      debugPrint('✅ Using cached persona relationship for ${basePersona.name}');
      return PersonaWithSpeechStyle(
        persona: cached.persona,
        isCasualSpeech: cached.isCasualSpeech,
        lastGreetingTime: cached.lastGreetingTime,
      );
    }

    // 캐시 미스 - Firebase에서 로드
    final result = await executeWithLoading(() async {
      final personaData = await _loadPersonaRelationship(userId, basePersona);

      // 캐시에 저장
      _cache[cacheKey] = _CachedPersonaRelationship(
        persona: personaData.persona,
        isCasualSpeech: personaData.isCasualSpeech,
        lastGreetingTime: personaData.lastGreetingTime,
        lastWellBeingQuestionTime: personaData.lastWellBeingQuestionTime,
        dailyQuestionStats: personaData.dailyQuestionStats ?? {},
        timestamp: DateTime.now(),
      );

      debugPrint(
          '📥 Loaded and cached persona relationship for ${basePersona.name}');
      return personaData;
    });

    // executeWithLoading이 null을 반환할 수 있으므로 기본값 처리
    return result ??
        PersonaWithSpeechStyle(
          persona: basePersona,
          isCasualSpeech: false,
        );
  }

  /// Firebase에서 페르소나 관계 정보 로드
  Future<PersonaWithSpeechStyle> _loadPersonaRelationship(
      String userId, Persona basePersona) async {
    try {
      final docId = '${userId}_${basePersona.id}';
      final relationshipDoc = await FirebaseFirestore.instance
          .collection(AppConstants.userPersonaRelationshipsCollection)
          .doc(docId)
          .get();

      if (!relationshipDoc.exists) {
        // 관계 문서가 없으면 기본값 반환
        debugPrint('⚠️ No relationship document found for ${basePersona.name}');
        return PersonaWithSpeechStyle(
          persona: basePersona,
          isCasualSpeech: false,
        );
      }

      final data = relationshipDoc.data()!;
      final isCasualSpeech = data['isCasualSpeech'] ?? false;

      // 관계 정보로 페르소나 업데이트
      final updatedPersona = basePersona.copyWith(
        likes: data['likes'] ?? data['relationshipScore'] ?? 0,
        // TODO: RelationshipType 정의 후 주석 해제
        // currentRelationship: _parseRelationshipType(data['currentRelationship']),
      );

      // 인사 시간 로드
      final lastGreeting = data['lastGreetingTime'] != null
          ? (data['lastGreetingTime'] as Timestamp).toDate()
          : null;
      
      // 안부 질문 시간 로드
      final lastWellBeing = data['lastWellBeingQuestionTime'] != null
          ? (data['lastWellBeingQuestionTime'] as Timestamp).toDate()
          : null;
      
      // 일별 질문 통계 로드
      final dailyStats = data['dailyQuestionStats'] as Map<String, dynamic>?;

      return PersonaWithSpeechStyle(
        persona: updatedPersona,
        isCasualSpeech: isCasualSpeech,
        lastGreetingTime: lastGreeting,
        lastWellBeingQuestionTime: lastWellBeing,
        dailyQuestionStats: dailyStats,
      );
    } catch (e) {
      debugPrint('❌ Error loading persona relationship: $e');
      return PersonaWithSpeechStyle(
        persona: basePersona,
        isCasualSpeech: false,
      );
    }
  }

  /// 특정 페르소나의 캐시 무효화
  void invalidatePersona(String userId, String personaId) {
    final cacheKey = '${userId}_$personaId';
    _cache.remove(cacheKey);
    debugPrint('🗑️ Invalidated cache for persona $personaId');
  }

  /// 사용자의 모든 페르소나 캐시 무효화
  void invalidateUser(String userId) {
    _cache.removeWhere((key, _) => key.startsWith('${userId}_'));
    debugPrint('🗑️ Invalidated all cache for user $userId');
  }

  /// 인사 상태 업데이트
  Future<void> updateGreetingTime({
    required String userId,
    required String personaId,
  }) async {
    try {
      final cacheKey = '${userId}_$personaId';
      final now = DateTime.now();
      
      // Firebase 업데이트
      final docId = '${userId}_$personaId';
      await FirebaseFirestore.instance
          .collection(AppConstants.userPersonaRelationshipsCollection)
          .doc(docId)
          .set({
            'lastGreetingTime': Timestamp.fromDate(now),
          }, SetOptions(merge: true));
      
      // 캐시 업데이트
      final cached = _cache[cacheKey];
      if (cached != null) {
        _cache[cacheKey] = _CachedPersonaRelationship(
          persona: cached.persona,
          isCasualSpeech: cached.isCasualSpeech,
          lastGreetingTime: now,
          lastWellBeingQuestionTime: cached.lastWellBeingQuestionTime,
          dailyQuestionStats: cached.dailyQuestionStats,
          timestamp: cached.timestamp,
        );
      }
      
      debugPrint('👋 Updated greeting time for persona $personaId');
    } catch (e) {
      debugPrint('❌ Error updating greeting time: $e');
    }
  }

  /// 인사가 필요한지 확인 (24시간 기준)
  bool shouldGreet(DateTime? lastGreetingTime) {
    if (lastGreetingTime == null) {
      return true; // 처음 대화
    }
    
    final hoursSinceGreeting = DateTime.now().difference(lastGreetingTime).inHours;
    return hoursSinceGreeting >= 24; // 24시간 이상 지났으면 인사 필요
  }
  
  /// 안부 질문 시간 업데이트
  Future<void> updateWellBeingQuestionTime({
    required String userId,
    required String personaId,
  }) async {
    try {
      final cacheKey = '${userId}_$personaId';
      final now = DateTime.now();
      final today = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
      
      // Firebase 업데이트
      final docId = '${userId}_$personaId';
      await FirebaseFirestore.instance
          .collection(AppConstants.userPersonaRelationshipsCollection)
          .doc(docId)
          .set({
            'lastWellBeingQuestionTime': Timestamp.fromDate(now),
            'dailyQuestionStats': {
              'date': today,
              'wellBeingCount': FieldValue.increment(1),
              'lastQuestionTime': Timestamp.fromDate(now),
            }
          }, SetOptions(merge: true));
      
      // 캐시 업데이트
      final cached = _cache[cacheKey];
      if (cached != null) {
        final stats = Map<String, dynamic>.from(cached.dailyQuestionStats);
        if (stats['date'] != today) {
          stats['date'] = today;
          stats['wellBeingCount'] = 1;
        } else {
          stats['wellBeingCount'] = (stats['wellBeingCount'] ?? 0) + 1;
        }
        stats['lastQuestionTime'] = now;
        
        _cache[cacheKey] = _CachedPersonaRelationship(
          persona: cached.persona,
          isCasualSpeech: cached.isCasualSpeech,
          lastGreetingTime: cached.lastGreetingTime,
          lastWellBeingQuestionTime: now,
          dailyQuestionStats: stats,
          timestamp: cached.timestamp,
        );
      }
      
      debugPrint('💬 Updated well-being question time for persona $personaId');
    } catch (e) {
      debugPrint('❌ Error updating well-being question time: $e');
    }
  }
  
  /// 오늘 안부 질문을 했는지 확인
  bool hasAskedWellBeingToday({
    required String userId,
    required String personaId,
  }) {
    final cacheKey = '${userId}_$personaId';
    final cached = _cache[cacheKey];
    
    if (cached == null) return false;
    
    final today = DateTime.now();
    final todayStr = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    
    final stats = cached.dailyQuestionStats;
    if (stats['date'] == todayStr) {
      final count = stats['wellBeingCount'] ?? 0;
      return count > 0;  // 오늘 1번이라도 물었으면 true
    }
    
    return false;
  }

  /// 만료된 캐시 항목 갱신
  Future<void> _refreshExpiredCache() async {
    final expiredEntries =
        _cache.entries.where((entry) => entry.value.isExpired).toList();

    if (expiredEntries.isEmpty) return;

    debugPrint('♻️ Refreshing ${expiredEntries.length} expired cache entries');

    for (final entry in expiredEntries) {
      final parts = entry.key.split('_');
      if (parts.length >= 2) {
        final userId = parts[0];
        final personaId = parts[1];

        // 기존 페르소나 정보를 기반으로 갱신
        final oldPersona = entry.value.persona;
        try {
          await getCompletePersona(userId: userId, basePersona: oldPersona);
        } catch (e) {
          debugPrint('❌ Failed to refresh cache for ${oldPersona.name}: $e');
        }
      }
    }
  }

  /// 관계 타입 파싱
  // TODO: RelationshipType 정의 후 주석 해제
  // RelationshipType _parseRelationshipType(String? type) {
  //   switch (type) {
  //     case 'friend':
  //       return RelationshipType.friend;
  //     case 'crush':
  //       return RelationshipType.crush;
  //     case 'dating':
  //       return RelationshipType.dating;
  //     case 'perfectLove':
  //       return RelationshipType.perfectLove;
  //     default:
  //       return RelationshipType.friend;
  //   }
  // }

  /// 캐시 상태 정보
  Map<String, dynamic> getCacheStats() {
    final total = _cache.length;
    final expired = _cache.values.where((c) => c.isExpired).length;
    final valid = total - expired;

    return {
      'total': total,
      'valid': valid,
      'expired': expired,
      'cacheKeys': _cache.keys.toList(),
    };
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _cache.clear();
    super.dispose();
  }
}

/// 캐시된 페르소나 관계 정보
class _CachedPersonaRelationship {
  final Persona persona;
  final bool isCasualSpeech;
  final DateTime? lastGreetingTime;
  final DateTime? lastWellBeingQuestionTime;  // 안부 질문 시간 추가
  final Map<String, dynamic> dailyQuestionStats;  // 일별 질문 통계 추가
  final DateTime timestamp;

  _CachedPersonaRelationship({
    required this.persona,
    required this.isCasualSpeech,
    this.lastGreetingTime,
    this.lastWellBeingQuestionTime,
    Map<String, dynamic>? dailyQuestionStats,
    required this.timestamp,
  }) : dailyQuestionStats = dailyQuestionStats ?? {};

  /// 캐시가 만료되었는지 확인
  bool get isExpired {
    return DateTime.now().difference(timestamp) >
        PersonaRelationshipCache._cacheValidDuration;
  }
}
