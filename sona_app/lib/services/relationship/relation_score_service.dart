import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/persona.dart';
import '../../models/message.dart';
import '../base/base_service.dart';
import '../../helpers/firebase_helper.dart';
import '../../core/constants.dart';
import 'like_cooldown_system.dart';
import 'relationship_visual_system.dart';
import '../../utils/like_formatter.dart';
import 'negative_behavior_system.dart';

/// 페르소나 감정 상태
enum PersonaEmotionalState {
  normal,      // 평상시
  happy,       // 기쁨 (좋은 대화)
  upset,       // 삐짐 (레벨 1 부정적 행동)
  angry,       // 화남 (레벨 2 부정적 행동)  
  hurt,        // 상처받음 (레벨 3 부정적 행동)
  recovering,  // 회복 중 (사과 후)
}

/// 감정 상태 정보
class EmotionalStateInfo {
  final PersonaEmotionalState state;
  final DateTime startTime;
  final DateTime? recoveryTime;  // 회복 완료 시간
  
  EmotionalStateInfo({
    required this.state,
    required this.startTime,
    this.recoveryTime,
  });
  
  // 상태 지속 시간 계산
  Duration get duration => DateTime.now().difference(startTime);
  
  // 자연 회복 가능 여부
  bool get canAutoRecover {
    if (recoveryTime == null) return false;
    return DateTime.now().isAfter(recoveryTime!);
  }
  
  // 회복까지 남은 시간
  Duration? get remainingRecoveryTime {
    if (recoveryTime == null) return null;
    final now = DateTime.now();
    if (now.isAfter(recoveryTime!)) return Duration.zero;
    return recoveryTime!.difference(now);
  }
  
  // 회복 진행도 (0.0 ~ 1.0)
  double get recoveryProgress {
    if (state == PersonaEmotionalState.normal || state == PersonaEmotionalState.happy) {
      return 1.0;
    }
    if (recoveryTime == null) return 0.0;
    
    final totalDuration = recoveryTime!.difference(startTime);
    final elapsed = duration;
    
    if (elapsed >= totalDuration) return 1.0;
    return elapsed.inSeconds / totalDuration.inSeconds;
  }
}

/// 💝 관계 점수 관리 서비스 V2.0
///
/// 핵심 기능:
/// 1. 무제한 Like 시스템 (기존 점수 제한 제거)
/// 2. 다차원 감정 기반 Like 계산
/// 3. 시각적 관계 표현 (색상, 뱃지, 링)
/// 4. 쿨다운 및 품질 기반 보너스
/// 5. 부정적 행동 페널티 및 이별 시스템
/// 6. 관계 이력 및 마일스톤 추적
class RelationScoreService extends BaseService {
  static RelationScoreService? _instance;
  static RelationScoreService get instance =>
      _instance ??= RelationScoreService._();

  RelationScoreService._();

  final Random _random = Random();
  final LikeCooldownSystem _cooldown = LikeCooldownSystem();
  final RelationshipVisualSystem _visual = RelationshipVisualSystem();

  // 일일 통계 추적
  final Map<String, DailyStats> _dailyStats = {};

  // 사용자별 마지막 메시지 시간
  final Map<String, DateTime> _lastMessageTimes = {};
  
  // 경고 시스템 추적 (페르소나별 경고 횟수)
  final Map<String, int> _warningCounts = {};
  final Map<String, DateTime> _lastWarningTime = {};
  
  // 페르소나 감정 상태 추적
  final Map<String, EmotionalStateInfo> _emotionalStates = {};

  // Like score 캐싱 시스템
  final Map<String, int> _likesCache = {};
  final Map<String, DateTime> _cacheTimestamps = {};
  static const Duration _cacheTTL = Duration(minutes: 5);

  /// 🎯 다차원 Like 계산 시스템
  Future<LikeCalculationResult> calculateLikes({
    required EmotionType emotion,
    required String userMessage,
    required Persona persona,
    required List<Message> chatHistory,
    required int currentLikes,
    required String userId,
    String? aiResponse,
    double? conversationQuality,
  }) async {
    final personaKey = '${userId}_${persona.id}';
    final now = DateTime.now();

    // 일일 통계 초기화
    _updateDailyStats(personaKey, now);
    final stats = _dailyStats[personaKey]!;

    // 쿨다운 체크
    final lastMessageTime = _lastMessageTimes[personaKey];
    if (lastMessageTime != null && _cooldown.isOnCooldown(lastMessageTime)) {
      return LikeCalculationResult(
        likeChange: 0,
        reason: 'cooldown',
        cooldownRemaining: _cooldown.getRemainingCooldown(lastMessageTime),
      );
    }

    // 일일 한계 체크
    if (stats.todayLikes >=
        DailyLikeSystem.baseDailyLimit +
            stats.qualityBonus +
            stats.eventBonus) {
      return LikeCalculationResult(
        likeChange: 0,
        reason: 'daily_limit',
        message: '오늘은 충분히 대화했어요. 내일 다시 만나요! 💤',
      );
    }

    // 피로도 체크
    final fatigueMultiplier =
        _cooldown.getFatigueMultiplier(stats.todayMessages);
    final fatigueResponse = _cooldown.getFatigueResponse(stats.todayMessages);

    // 사과 감지 - 경고 리셋 및 회복 보너스
    if (detectApology(userMessage)) {
      resetWarnings(userId, persona.id);
      resetEmotionalState(userId, persona.id); // 감정 상태도 회복
      debugPrint('💚 Apology detected - warnings reset, emotional state recovered, and recovery bonus applied');
      // 사과 시 작은 회복 보너스 제공
      return LikeCalculationResult(
        likeChange: _random.nextInt(10) + 5, // 5~15 회복 보너스
        reason: 'apology_recovery',
        message: '', // AI가 생성하도록 비워둠
        emotionalState: PersonaEmotionalState.happy, // 사과받아서 기분 좋아짐
      );
    }
    
    // 부정적 행동 체크 (관계 점수 및 게임 컨텍스트 고려)
    final negativityLevel =
        _analyzeNegativity(userMessage, currentLikes, chatHistory);
    if (negativityLevel > 0) {
      return _handleNegativeBehavior(negativityLevel, currentLikes, personaKey,
          persona, userMessage, chatHistory);
    }

    // 기본 Like 계산
    int baseLikes = _calculateBaseLikes(emotion, userMessage, persona);

    // 동적 조정 시스템
    double dynamicMultiplier = 1.0;

    // 1. 대화 품질 기반 조정 (0-100 점수)
    if (conversationQuality != null) {
      // 품질이 80점 이상이면 보너스, 40점 이하면 페널티
      dynamicMultiplier *= (0.5 + conversationQuality / 100);
    }

    // 2. 대화 주제별 가중치
    final topicMultiplier = _getTopicMultiplier(userMessage, chatHistory);
    dynamicMultiplier *= topicMultiplier;

    // 3. 관계 발전 단계별 차별화
    final stageMultiplier = _getRelationshipStageMultiplier(currentLikes);
    dynamicMultiplier *= stageMultiplier;

    // 4. 특별한 순간 감지
    int specialBonus = 0;
    if (aiResponse != null) {
      specialBonus = _detectSpecialMomentBonus(
          userMessage, aiResponse, chatHistory, currentLikes);
    }

    // 품질 보너스 (개선된 버전)
    final qualityBonus = _calculateEnhancedQualityBonus(
        userMessage, lastMessageTime, conversationQuality ?? 50.0);

    // 연속 대화 페널티
    final consecutivePenalty =
        _cooldown.getConsecutivePenalty(stats.recentMessages);

    // 최종 Like 계산
    int finalLikes = (baseLikes *
            dynamicMultiplier *
            (1 + qualityBonus * 0.1) *
            fatigueMultiplier *
            (1 - consecutivePenalty / 100))
        .round();
    finalLikes += specialBonus;

    // 관계 단계에 따른 최소/최대값 제한
    finalLikes = _applyRelationshipStageLimits(finalLikes, currentLikes);

    // 통계 업데이트
    stats.todayLikes += finalLikes;
    stats.todayMessages++;
    stats.recentMessages++;
    stats.qualityBonus += (qualityBonus * 2).round();
    _lastMessageTimes[personaKey] = now;

    // 현재 감정 상태 가져오기
    final currentEmotionalState = getEmotionalState(userId, persona.id);
    
    return LikeCalculationResult(
      likeChange: finalLikes,
      reason: 'success',
      qualityBonus: qualityBonus,
      fatigueMultiplier: fatigueMultiplier,
      message: fatigueResponse,
      specialBonus: specialBonus,
      emotionalState: currentEmotionalState, // 현재 감정 상태 포함
    );
  }

  /// 🎨 감정별 기본 Like 계산 (무제한 시스템)
  int _calculateBaseLikes(
      EmotionType emotion, String message, Persona persona) {
    // 기본 Like 범위 (관계 깊이 무관)
    final baseRanges = {
      EmotionType.happy: [8, 15], // 8~15
      EmotionType.love: [15, 30], // 15~30
      EmotionType.surprised: [5, 12], // 5~12
      EmotionType.shy: [10, 20], // 10~20
      EmotionType.jealous: [3, 8], // 3~8
      EmotionType.thoughtful: [8, 18], // 8~18
      EmotionType.anxious: [2, 6], // 2~6
      EmotionType.concerned: [5, 10], // 5~10
      EmotionType.angry: [-5, 5], // -5~5 (상황에 따라)
      EmotionType.sad: [0, 8], // 0~8
      EmotionType.neutral: [3, 10], // 3~10
    };

    final range = baseRanges[emotion] ?? [1, 5];
    final baseLikes = _random.nextInt(range[1] - range[0] + 1) + range[0];

    // 페르소나 성격에 따른 보정
    double personalityModifier = 1.0;
    if (persona.mbti.startsWith('E')) personalityModifier *= 1.2; // 외향적
    if (persona.mbti.contains('F')) personalityModifier *= 1.1; // 감정적

    // 메시지 길이 보너스 (깊은 대화)
    final lengthBonus = (message.length / 50).clamp(0.8, 1.5);

    return (baseLikes * personalityModifier * lengthBonus).round();
  }

  /// 🚨 부정적 행동 분석 시스템 (관계 점수 및 게임 컨텍스트 고려)
  int _analyzeNegativity(
      String message, int currentLikes, List<Message> chatHistory) {
    // 최근 메시지 추출
    final recentMessages = chatHistory.take(5).map((m) => m.content).toList();

    // NegativeBehaviorSystem을 사용하여 분석
    final analysis = NegativeBehaviorSystem().analyze(
      message,
      likes: currentLikes,
      recentMessages: recentMessages,
    );
    return analysis.level;
  }

  /// 💔 부정적 행동 처리 (완화된 페널티 시스템)
  LikeCalculationResult _handleNegativeBehavior(
    int level,
    int currentLikes,
    String personaKey,
    Persona persona,
    String userMessage,
    List<Message> chatHistory,
  ) {
    // personaKey에서 userId와 personaId 추출
    final parts = personaKey.split('_');
    final userId = parts[0];
    final personaId = parts.length > 1 ? parts.sublist(1).join('_') : persona.id;
    
    // 최근 메시지 추출
    final recentMessages = chatHistory.take(5).map((m) => m.content).toList();

    // NegativeBehaviorSystem을 사용하여 상세 분석
    final analysis = NegativeBehaviorSystem().analyze(
      userMessage,
      likes: currentLikes,
      recentMessages: recentMessages,
    );

    // 페르소나 반응 생성
    final response = NegativeBehaviorSystem()
        .generateResponse(analysis, persona, likes: currentLikes);

    // 경고 시스템 체크
    final now = DateTime.now();
    final lastWarning = _lastWarningTime[personaKey];
    final warningCount = _warningCounts[personaKey] ?? 0;
    
    // 24시간이 지나면 경고 횟수 리셋
    if (lastWarning != null && now.difference(lastWarning).inHours >= 24) {
      _warningCounts[personaKey] = 0;
    }
    
    // 관계 점수별 페널티 감소율 계산
    double penaltyReduction = 0;
    if (currentLikes < 300) {
      penaltyReduction = 0.5; // 초보자 보호: 50% 감소
    } else if (currentLikes < 1000) {
      penaltyReduction = 0.3; // 30% 감소
    } else if (currentLikes >= 3000) {
      penaltyReduction = -0.2; // 깊은 관계: 20% 증가 (더 상처받음)
    }

    switch (level) {
      case 3: // 심각한 협박/욕설 - 경고 후 큰 페널티
        // 감정 상태를 '상처받음'으로 설정 (2시간 회복)
        _updateEmotionalState(userId, personaId, PersonaEmotionalState.hurt,
            recoveryTime: const Duration(hours: 2));
        
        // 첫 번째는 강한 경고와 함께 중간 페널티
        if (warningCount == 0) {
          _warningCounts[personaKey] = 1;
          _lastWarningTime[personaKey] = now;
          final penalty = _random.nextInt(100) + 100; // -100~-200
          final adjustedPenalty = (penalty * (1 - penaltyReduction)).round();
          return LikeCalculationResult(
            likeChange: -adjustedPenalty,
            reason: 'severe_warning',
            message: response.isNotEmpty ? response : '',
            isWarning: true,
            emotionalState: PersonaEmotionalState.hurt,
          );
        }
        // 반복 시 더 큰 페널티 (하지만 즉시 이별은 아님)
        final penalty = _random.nextInt(300) + 200; // -200~-500
        final adjustedPenalty = (penalty * (1 - penaltyReduction)).round();
        return LikeCalculationResult(
          likeChange: -adjustedPenalty,
          reason: 'severe_negativity',
          message: response.isNotEmpty ? response : '',
          isBreakup: currentLikes - adjustedPenalty <= 0, // 0 이하가 되면 이별
          emotionalState: PersonaEmotionalState.hurt,
        );

      case 2: // 중간 수준 욕설
        // 감정 상태를 '화남'으로 설정 (30분 회복)
        _updateEmotionalState(userId, personaId, PersonaEmotionalState.angry,
            recoveryTime: const Duration(minutes: 30));
        
        // 첫 번째는 경고와 작은 페널티
        if (warningCount == 0) {
          _warningCounts[personaKey] = 1;
          _lastWarningTime[personaKey] = now;
          final penalty = _random.nextInt(20) + 10; // -10~-30
          final adjustedPenalty = (penalty * (1 - penaltyReduction)).round();
          return LikeCalculationResult(
            likeChange: -adjustedPenalty,
            reason: 'moderate_warning',
            message: response.isNotEmpty ? response : '',
            isWarning: true,
            emotionalState: PersonaEmotionalState.angry,
          );
        }
        // 반복 시 정상 페널티
        final penalty = analysis.penalty ?? (_random.nextInt(100) + 50); // -50~-150
        final adjustedPenalty = (penalty.abs() * (1 - penaltyReduction)).round();
        return LikeCalculationResult(
          likeChange: -adjustedPenalty,
          reason: 'moderate_negativity',
          message: response.isNotEmpty ? response : '',
          isWarning: analysis.isWarning,
          emotionalState: PersonaEmotionalState.angry,
        );

      case 1: // 경미한 비난 또는 추임새 욕설
        // 감정 상태를 '삐짐'으로 설정 (10분 회복)
        _updateEmotionalState(userId, personaId, PersonaEmotionalState.upset,
            recoveryTime: const Duration(minutes: 10));
        
        // 첫 번째는 경고만
        if (warningCount == 0 && currentLikes < 1000) {
          _warningCounts[personaKey] = 1;
          _lastWarningTime[personaKey] = now;
          return LikeCalculationResult(
            likeChange: 0, // 첫 번째는 페널티 없음
            reason: 'mild_warning',
            message: response.isNotEmpty ? response : '',
            isWarning: true,
            emotionalState: PersonaEmotionalState.upset,
          );
        }
        // 반복 시 작은 페널티
        final penalty = analysis.penalty ?? (_random.nextInt(25) + 5); // -5~-30
        final adjustedPenalty = (penalty.abs() * (1 - penaltyReduction)).round();
        return LikeCalculationResult(
          likeChange: -adjustedPenalty,
          reason: analysis.category == 'casual_swear'
              ? 'casual_swear'
              : 'mild_negativity',
          message: response.isNotEmpty ? response : '',
          isWarning: analysis.isWarning,
          emotionalState: PersonaEmotionalState.upset,
        );

      default:
        return LikeCalculationResult(likeChange: 0, reason: 'none');
    }
  }

  /// 📊 일일 통계 업데이트
  void _updateDailyStats(String personaKey, DateTime now) {
    if (!_dailyStats.containsKey(personaKey)) {
      _dailyStats[personaKey] = DailyStats();
    }

    final stats = _dailyStats[personaKey]!;

    // 날짜가 바뀌었으면 리셋
    if (stats.date.day != now.day) {
      final yesterdayQuality =
          (stats.qualityBonus / stats.todayMessages * 10).round();
      stats.reset();
      stats.date = now;

      // 연속 일수 계산
      if (now.difference(stats.date).inDays == 1) {
        stats.streakDays++;
      } else {
        stats.streakDays = 1;
      }

      // 아침 보너스
      stats.eventBonus =
          DailyLikeSystem.getMorningBonus(yesterdayQuality, stats.streakDays);
    }

    // 최근 메시지 카운트 리셋 (5분마다)
    if (now.difference(stats.lastResetTime).inMinutes >= 5) {
      stats.recentMessages = 0;
      stats.lastResetTime = now;
    }
  }

  /// 🎨 시각적 관계 정보 가져오기
  RelationshipVisualInfo getVisualInfo(int likes) {
    return RelationshipVisualInfo(
      likes: likes,
      color: RelationshipColorSystem.getRelationshipColor(likes),
      badge: RelationshipBadgeSystem.getBadge(likes),
      heart: HeartEvolutionSystem.getHeart(likes),
      formattedLikes: LikeFormatter.format(likes),
      milestone: LikeFormatter.getNextMilestone(likes),
      milestoneProgress: _calculateMilestoneProgress(likes),
    );
  }

  /// 마일스톤 진행도 계산
  double _calculateMilestoneProgress(int likes) {
    final nextMilestone = LikeFormatter.getNextMilestone(likes);
    if (nextMilestone == null) return 1.0;

    // 현재 마일스톤 찾기
    int currentMilestone = 0;
    final milestones = [
      100,
      500,
      1000,
      2000,
      5000,
      10000,
      20000,
      50000,
      100000
    ];

    for (final milestone in milestones) {
      if (likes >= milestone) {
        currentMilestone = milestone;
      } else {
        break;
      }
    }

    if (currentMilestone == 0) {
      return likes / nextMilestone;
    }

    return (likes - currentMilestone) / (nextMilestone - currentMilestone);
  }

  /// 💔 이별 처리
  Future<void> processBreakup({
    required String userId,
    required String personaId,
    required String reason,
  }) async {
    await executeWithLoading(() async {
      final docId = '${userId}_${personaId}';

      // Like를 0으로 리셋
      await FirebaseHelper.userPersonaRelationships.doc(docId).set({
        'userId': userId,
        'personaId': personaId,
        'likes': 0,
        'breakupAt': FieldValue.serverTimestamp(),
        'breakupReason': reason,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // 이별 이력 추가
      await FirebaseFirestore.instance.collection('breakup_history').add({
        'userId': userId,
        'personaId': personaId,
        'reason': reason,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // 로컬 통계 리셋
      final personaKey = '${userId}_${personaId}';
      _dailyStats.remove(personaKey);
      _lastMessageTimes.remove(personaKey);

      debugPrint('💔 Breakup processed: $personaId (reason: $reason)');
    });
  }

  /// 💝 Like 업데이트 (무제한 시스템)
  Future<void> updateLikes({
    required String userId,
    required String personaId,
    required int likeChange,
    required int currentLikes,
    String? breakupReason,
  }) async {
    if (likeChange == 0 && breakupReason == null) return;

    await executeWithLoading(() async {
      final docId = '${userId}_${personaId}';
      final newLikes = max(0, currentLikes + likeChange);

      // 캐시 즉시 업데이트
      _updateCache(userId, personaId, newLikes);

      // 이별 처리
      if (breakupReason != null || newLikes == 0) {
        await processBreakup(
          userId: userId,
          personaId: personaId,
          reason: breakupReason ?? 'negative_behavior',
        );
        return;
      }

      // Like 업데이트
      await FirebaseHelper.userPersonaRelationships.doc(docId).set({
        'userId': userId,
        'personaId': personaId,
        'likes': newLikes,
        'lastInteraction': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // 마일스톤 체크
      final milestoneMessage = LikeFormatter.getMilestoneMessage(newLikes);
      if (milestoneMessage != null) {
        await _addMilestoneHistory(
          userId: userId,
          personaId: personaId,
          likes: newLikes,
          message: milestoneMessage,
        );
      }

      debugPrint('💕 Likes updated: $personaId ($currentLikes -> $newLikes)');
    });
  }

  /// 🏆 마일스톤 이력 추가
  Future<void> _addMilestoneHistory({
    required String userId,
    required String personaId,
    required int likes,
    required String message,
  }) async {
    await FirebaseFirestore.instance.collection('milestone_history').add({
      'userId': userId,
      'personaId': personaId,
      'likes': likes,
      'message': message,
      'timestamp': FieldValue.serverTimestamp(),
    });

    debugPrint('🏆 Milestone reached: $likes likes - $message');
  }

  /// 💕 특정 페르소나와의 Like 조회
  Future<int> getLikes({
    required String userId,
    required String personaId,
  }) async {
    final result = await executeSafely<int>(() async {
      final docId = '${userId}_${personaId}';
      final doc =
          await FirebaseHelper.userPersonaRelationships.doc(docId).get();

      if (doc.exists) {
        // 새로운 likes 필드 우선, 없으면 기존 relationshipScore 사용
        final likes =
            doc.data()?['likes'] ?? doc.data()?['relationshipScore'] ?? 0;
        // 캐시 업데이트
        _updateCache(userId, personaId, likes);
        return likes;
      }
      return 0;
    }, defaultValue: 0);

    return result ?? 0;
  }

  /// 💾 캐시된 Like 조회 (즉시 반환)
  int getCachedLikes({
    required String userId,
    required String personaId,
  }) {
    final cacheKey = '${userId}_${personaId}';

    // 캐시 확인
    if (_likesCache.containsKey(cacheKey)) {
      final timestamp = _cacheTimestamps[cacheKey];
      if (timestamp != null &&
          DateTime.now().difference(timestamp) < _cacheTTL) {
        // 캐시가 유효한 경우
        return _likesCache[cacheKey]!;
      }
    }

    // 캐시가 없거나 만료된 경우, 백그라운드에서 업데이트
    _refreshCacheInBackground(userId, personaId);

    // 일단 캐시된 값이나 0 반환
    return _likesCache[cacheKey] ?? 0;
  }

  /// 🔄 백그라운드에서 캐시 새로고침
  void _refreshCacheInBackground(String userId, String personaId) {
    // 비동기로 최신 값 가져오기
    getLikes(userId: userId, personaId: personaId).then((likes) {
      _updateCache(userId, personaId, likes);
    }).catchError((error) {
      debugPrint('Error refreshing likes cache: $error');
    });
  }

  /// 📝 캐시 업데이트
  void _updateCache(String userId, String personaId, int likes) {
    final cacheKey = '${userId}_${personaId}';
    _likesCache[cacheKey] = likes;
    _cacheTimestamps[cacheKey] = DateTime.now();
  }

  /// 🔄 모든 페르소나의 Like 프리로드
  Future<void> preloadLikes({
    required String userId,
    required List<String> personaIds,
  }) async {
    // 병렬로 모든 like score 로드
    final futures = personaIds
        .map((personaId) => getLikes(userId: userId, personaId: personaId));

    await Future.wait(futures);
  }

  /// 🗑️ 캐시 클리어
  void clearCache() {
    _likesCache.clear();
    _cacheTimestamps.clear();
  }

  /// 📊 모든 페르소나와의 Like 조회
  Future<Map<String, int>> getAllLikes(String userId) async {
    final result = await executeSafely<Map<String, int>>(() async {
      final snapshot = await FirebaseHelper.userPersonaRelationships
          .where('userId', isEqualTo: userId)
          .get();

      final likes = <String, int>{};
      for (final doc in snapshot.docs) {
        final data = doc.data();
        final personaId = data['personaId'] as String;
        // 새로운 likes 필드 우선, 없으면 기존 relationshipScore 사용
        final likeCount = data['likes'] ?? data['relationshipScore'] ?? 0;
        likes[personaId] = likeCount;
      }

      return likes;
    }, defaultValue: {});

    return result ?? {};
  }

  /// 📈 마일스톤 이력 조회
  Future<List<Map<String, dynamic>>> getMilestoneHistory({
    required String userId,
    required String personaId,
    int limit = 10,
  }) async {
    final result = await executeSafely<List<Map<String, dynamic>>>(() async {
      final snapshot = await FirebaseFirestore.instance
          .collection('milestone_history')
          .where('userId', isEqualTo: userId)
          .where('personaId', isEqualTo: personaId)
          .orderBy('timestamp', descending: true)
          .limit(limit)
          .get();

      return snapshot.docs.map((doc) => doc.data()).toList();
    }, defaultValue: []);

    return result ?? [];
  }

  /// 오늘의 통계 가져오기
  DailyStats? getDailyStats(String userId, String personaId) {
    return _dailyStats['${userId}_${personaId}'];
  }
  
  /// 경고 시스템 리셋 (사과 등의 긍정적 행동 시)
  void resetWarnings(String userId, String personaId) {
    final personaKey = '${userId}_${personaId}';
    _warningCounts[personaKey] = 0;
    _lastWarningTime.remove(personaKey);
    debugPrint('💚 Warnings reset for persona: $personaId');
  }
  
  /// 사과 감지 및 관계 회복
  bool detectApology(String message) {
    final apologyWords = [
      '미안', '죄송', '잘못', '실수', '사과',
      'sorry', '미안해', '죄송해', '잘못했',
      '미안하다', '죄송하다', '반성', '후회'
    ];
    
    final lowerMessage = message.toLowerCase();
    return apologyWords.any((word) => lowerMessage.contains(word));
  }
  
  /// 감정 상태 업데이트 (시간 기반 회복 포함)
  void _updateEmotionalState(
    String userId, 
    String personaId, 
    PersonaEmotionalState newState,
    {Duration? recoveryTime}
  ) {
    final personaKey = '${userId}_${personaId}';
    final now = DateTime.now();
    
    // 현재 상태 확인 및 자동 회복 체크
    if (_emotionalStates.containsKey(personaKey)) {
      final currentState = _emotionalStates[personaKey]!;
      if (currentState.recoveryTime != null && 
          now.isAfter(currentState.recoveryTime!)) {
        // 회복 시간이 지났으면 normal로 자동 회복
        _emotionalStates[personaKey] = EmotionalStateInfo(
          state: PersonaEmotionalState.normal,
          startTime: now,
          recoveryTime: null,
        );
        debugPrint('💚 Emotional state auto-recovered for $personaId');
      }
    }
    
    // 새로운 상태 설정
    _emotionalStates[personaKey] = EmotionalStateInfo(
      state: newState,
      startTime: now,
      recoveryTime: recoveryTime != null ? now.add(recoveryTime) : null,
    );
    
    debugPrint('😔 Emotional state updated for $personaId: $newState');
  }
  
  /// 현재 감정 상태 가져오기
  PersonaEmotionalState getEmotionalState(String userId, String personaId) {
    final personaKey = '${userId}_${personaId}';
    
    if (_emotionalStates.containsKey(personaKey)) {
      final stateInfo = _emotionalStates[personaKey]!;
      final now = DateTime.now();
      
      // 회복 시간 체크
      if (stateInfo.recoveryTime != null && 
          now.isAfter(stateInfo.recoveryTime!)) {
        // 회복됨
        _emotionalStates[personaKey] = EmotionalStateInfo(
          state: PersonaEmotionalState.normal,
          startTime: now,
          recoveryTime: null,
        );
        return PersonaEmotionalState.normal;
      }
      
      return stateInfo.state;
    }
    
    return PersonaEmotionalState.normal;
  }
  
  /// 감정 상태 정보 가져오기 (회복 시간 포함)
  EmotionalStateInfo? getEmotionalStateInfo(String userId, String personaId) {
    final personaKey = '${userId}_${personaId}';
    
    if (_emotionalStates.containsKey(personaKey)) {
      final stateInfo = _emotionalStates[personaKey]!;
      final now = DateTime.now();
      
      // 회복 시간 체크
      if (stateInfo.recoveryTime != null && 
          now.isAfter(stateInfo.recoveryTime!)) {
        // 회복됨
        final normalState = EmotionalStateInfo(
          state: PersonaEmotionalState.normal,
          startTime: now,
          recoveryTime: null,
        );
        _emotionalStates[personaKey] = normalState;
        return normalState;
      }
      
      return stateInfo;
    }
    
    return null;
  }
  
  /// 감정 상태 리셋 (관계 개선 시)
  void resetEmotionalState(String userId, String personaId) {
    final personaKey = '${userId}_${personaId}';
    _emotionalStates[personaKey] = EmotionalStateInfo(
      state: PersonaEmotionalState.normal,
      startTime: DateTime.now(),
      recoveryTime: null,
    );
    debugPrint('💚 Emotional state reset for $personaId');
  }

  /// 🎯 대화 주제별 가중치
  double _getTopicMultiplier(String userMessage, List<Message> chatHistory) {
    // 깊은 대화 주제
    final deepTopics = ['꿈', '목표', '고민', '추억', '가족', '사랑', '미래', '과거', '감정'];
    final hobbyTopics = ['취미', '좋아하는', '관심', '재밌는', '즐기는'];

    // 메시지와 최근 대화에서 주제 확인
    final hasDeepTopic = deepTopics.any((t) => userMessage.contains(t));
    final hasHobbyTopic = hobbyTopics.any((t) => userMessage.contains(t));

    // 최근 대화 맥락 확인
    final recentMessages = chatHistory.take(5).toList();
    final contextIsDeep =
        recentMessages.any((m) => deepTopics.any((t) => m.content.contains(t)));

    if (hasDeepTopic || contextIsDeep) {
      return 1.5; // 깊은 대화 50% 보너스
    } else if (hasHobbyTopic) {
      return 1.3; // 취미/관심사 30% 보너스
    }

    return 1.0; // 일상 대화 기본 배율
  }

  /// 🎯 관계 발전 단계별 차별화
  double _getRelationshipStageMultiplier(int currentLikes) {
    if (currentLikes < 1000) {
      // 초기 단계: 기본 배율
      return 1.0;
    } else if (currentLikes < 5000) {
      // 친밀 단계: 품질 가중치 증가, 기본 부여율 감소
      return 0.8;
    } else if (currentLikes < 20000) {
      // 깊은 관계: 품질이 더 중요해짐
      return 0.6;
    } else {
      // 특별한 관계: 품질 중심
      return 0.4;
    }
  }

  /// 🎯 특별한 순간 보너스
  int _detectSpecialMomentBonus(String userMessage, String aiResponse,
      List<Message> chatHistory, int currentLikes) {
    // 첫 고민 상담
    if ((userMessage.contains('고민') || userMessage.contains('걱정')) &&
        !chatHistory
            .any((m) => m.content.contains('고민') || m.content.contains('걱정'))) {
      debugPrint('💝 특별한 순간: 첫 고민 상담 (+50)');
      return 50;
    }

    // 첫 꿈/목표 공유
    if ((userMessage.contains('꿈') || userMessage.contains('목표')) &&
        !chatHistory
            .any((m) => m.content.contains('꿈') || m.content.contains('목표'))) {
      debugPrint('💝 특별한 순간: 첫 꿈 공유 (+30)');
      return 30;
    }

    // 서로의 추억 공유
    if (userMessage.contains('추억') && aiResponse.contains('나도')) {
      debugPrint('💝 특별한 순간: 추억 공유 (+40)');
      return 40;
    }

    // 관계 마일스톤 직전
    if (currentLikes >= 950 && currentLikes < 1000) {
      debugPrint('💝 특별한 순간: 1000 Like 달성 임박 (+50)');
      return 50;
    } else if (currentLikes >= 9900 && currentLikes < 10000) {
      debugPrint('💝 특별한 순간: 10000 Like 달성 임박 (+100)');
      return 100;
    }

    return 0;
  }

  /// 🎯 향상된 품질 보너스 계산
  int _calculateEnhancedQualityBonus(
      String message, DateTime? lastMessageTime, double conversationQuality) {
    int bonus = 0;

    // 기존 품질 보너스
    bonus += QualityBasedLikes.calculateQualityBonus(message, lastMessageTime);

    // 대화 품질 점수 반영 (0-100)
    if (conversationQuality > 80) {
      bonus += 10; // 매우 높은 품질
    } else if (conversationQuality > 60) {
      bonus += 5; // 높은 품질
    } else if (conversationQuality < 30) {
      bonus -= 5; // 낮은 품질
    }

    return bonus;
  }

  /// 🎯 관계 단계별 Like 제한
  int _applyRelationshipStageLimits(int likes, int currentLikes) {
    // 관계 단계에 따른 최대 증가량 제한
    if (currentLikes >= 20000) {
      // 특별한 관계: 최대 50 Like
      return min(likes, 50);
    } else if (currentLikes >= 5000) {
      // 깊은 관계: 최대 70 Like
      return min(likes, 70);
    } else if (currentLikes >= 1000) {
      // 친밀한 관계: 최대 100 Like
      return min(likes, 100);
    }

    // 초기 관계: 제한 없음
    return likes;
  }

  // 호환성을 위한 기존 메서드들 추가

  /// 기존 관계 점수 조회 (호환성)
  Future<int> getRelationshipScore({
    required String userId,
    required String personaId,
  }) async {
    // 새로운 Like 시스템으로 리다이렉트
    return await getLikes(userId: userId, personaId: personaId);
  }

  /// 기존 관계 점수 업데이트 (호환성)
  Future<void> updateRelationshipScore({
    required String userId,
    required String personaId,
    required int scoreChange,
    required int currentScore,
  }) async {
    // 새로운 Like 시스템으로 리다이렉트
    await updateLikes(
      userId: userId,
      personaId: personaId,
      likeChange: scoreChange,
      currentLikes: currentScore,
    );
  }

  /// 기존 감정에 따른 점수 변화 계산 (호환성)
  int calculateScoreChange({
    required EmotionType emotion,
    required String userMessage,
    required Persona persona,
    required List<Message> chatHistory,
    required int currentScore,
  }) {
    // 새로운 Like 시스템의 기본 계산 로직 사용
    final baseLikes = _calculateBaseLikes(emotion, userMessage, persona);

    // 부정적 행동 체크
    final negativityLevel =
        _analyzeNegativity(userMessage, currentScore, chatHistory);
    if (negativityLevel > 0) {
      switch (negativityLevel) {
        case 3:
          return -currentScore; // 즉시 이별 (0으로 리셋)
        case 2:
          return -(_random.nextInt(500) + 500); // -500~-1000
        case 1:
          return -(_random.nextInt(150) + 50); // -50~-200
      }
    }

    // 70% 확률로 변화 (기존 로직 호환)
    if (_random.nextDouble() > 0.7) {
      return 0;
    }

    return baseLikes;
  }
}

/// Like 계산 결과
class LikeCalculationResult {
  final int likeChange;
  final String reason;
  final String? message;
  final Duration? cooldownRemaining;
  final int? qualityBonus;
  final double? fatigueMultiplier;
  final bool isBreakup;
  final int? specialBonus;
  final bool isWarning;
  final PersonaEmotionalState? emotionalState;
  final int? dailyRemaining;
  final bool? specialMoment;

  LikeCalculationResult({
    required this.likeChange,
    required this.reason,
    this.message,
    this.cooldownRemaining,
    this.qualityBonus,
    this.fatigueMultiplier,
    this.isBreakup = false,
    this.specialBonus,
    this.isWarning = false,
    this.emotionalState,
    this.dailyRemaining,
    this.specialMoment,
  });
}

/// 관계 시각 정보
class RelationshipVisualInfo {
  final int likes;
  final Color color;
  final Widget badge;
  final Widget heart;
  final String formattedLikes;
  final int? milestone;
  final double milestoneProgress;

  RelationshipVisualInfo({
    required this.likes,
    required this.color,
    required this.badge,
    required this.heart,
    required this.formattedLikes,
    this.milestone,
    required this.milestoneProgress,
  });
}

/// 일일 통계
class DailyStats {
  DateTime date = DateTime.now();
  int todayLikes = 0;
  int todayMessages = 0;
  int recentMessages = 0;
  int qualityBonus = 0;
  int eventBonus = 0;
  int streakDays = 1;
  DateTime lastResetTime = DateTime.now();

  void reset() {
    todayLikes = 0;
    todayMessages = 0;
    recentMessages = 0;
    qualityBonus = 0;
    eventBonus = 0;
  }
}

// 호환성을 위한 기존 메서드들 추가 (RelationScoreService 클래스 내부에 추가해야 함)
