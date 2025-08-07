import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/persona.dart';
import '../../core/constants.dart';
import '../base/base_service.dart';
import 'user_speech_pattern_analyzer.dart';
import '../../helpers/firebase_helper.dart';

/// 페르소나와 casual speech 설정을 함께 반환하는 클래스
class PersonaWithSpeechStyle {
  final Persona persona;
  final bool isCasualSpeech;

  PersonaWithSpeechStyle({
    required this.persona,
    required this.isCasualSpeech,
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
      );
    }

    // 캐시 미스 - Firebase에서 로드
    final result = await executeWithLoading(() async {
      final personaData = await _loadPersonaRelationship(userId, basePersona);

      // 캐시에 저장
      _cache[cacheKey] = _CachedPersonaRelationship(
        persona: personaData.persona,
        isCasualSpeech: personaData.isCasualSpeech,
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

      return PersonaWithSpeechStyle(
        persona: updatedPersona,
        isCasualSpeech: isCasualSpeech,
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
  final DateTime timestamp;

  _CachedPersonaRelationship({
    required this.persona,
    required this.isCasualSpeech,
    required this.timestamp,
  });

  /// 캐시가 만료되었는지 확인
  bool get isExpired {
    return DateTime.now().difference(timestamp) >
        PersonaRelationshipCache._cacheValidDuration;
  }
}
