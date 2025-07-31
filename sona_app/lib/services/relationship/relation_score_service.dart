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
  static RelationScoreService get instance => _instance ??= RelationScoreService._();
  
  RelationScoreService._();
  
  final Random _random = Random();
  final LikeCooldownSystem _cooldown = LikeCooldownSystem();
  final RelationshipVisualSystem _visual = RelationshipVisualSystem();
  
  // 일일 통계 추적
  final Map<String, DailyStats> _dailyStats = {};
  
  // 사용자별 마지막 메시지 시간
  final Map<String, DateTime> _lastMessageTimes = {};
  
  /// 🎯 다차원 Like 계산 시스템
  Future<LikeCalculationResult> calculateLikes({
    required EmotionType emotion,
    required String userMessage,
    required Persona persona,
    required List<Message> chatHistory,
    required int currentLikes,
    required String userId,
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
    if (stats.todayLikes >= DailyLikeSystem.baseDailyLimit + stats.qualityBonus + stats.eventBonus) {
      return LikeCalculationResult(
        likeChange: 0,
        reason: 'daily_limit',
        message: '오늘은 충분히 대화했어요. 내일 다시 만나요! 💤',
      );
    }
    
    // 피로도 체크
    final fatigueMultiplier = _cooldown.getFatigueMultiplier(stats.todayMessages);
    final fatigueResponse = _cooldown.getFatigueResponse(stats.todayMessages);
    
    // 부정적 행동 체크
    final negativityLevel = _analyzeNegativity(userMessage);
    if (negativityLevel > 0) {
      return _handleNegativeBehavior(negativityLevel, currentLikes, personaKey);
    }
    
    // 기본 Like 계산
    int baseLikes = _calculateBaseLikes(emotion, userMessage, persona);
    
    // 품질 보너스
    final qualityBonus = QualityBasedLikes.calculateQualityBonus(
      userMessage, 
      lastMessageTime
    );
    
    // 연속 대화 페널티
    final consecutivePenalty = _cooldown.getConsecutivePenalty(stats.recentMessages);
    
    // 최종 Like 계산
    int finalLikes = (baseLikes * (1 + qualityBonus * 0.1) * fatigueMultiplier * (1 - consecutivePenalty / 100)).round();
    
    // 통계 업데이트
    stats.todayLikes += finalLikes;
    stats.todayMessages++;
    stats.recentMessages++;
    stats.qualityBonus += (qualityBonus * 2).round();
    _lastMessageTimes[personaKey] = now;
    
    return LikeCalculationResult(
      likeChange: finalLikes,
      reason: 'success',
      qualityBonus: qualityBonus,
      fatigueMultiplier: fatigueMultiplier,
      message: fatigueResponse,
    );
  }
  
  /// 🎨 감정별 기본 Like 계산 (무제한 시스템)
  int _calculateBaseLikes(EmotionType emotion, String message, Persona persona) {
    // 기본 Like 범위 (관계 깊이 무관)
    final baseRanges = {
      EmotionType.happy: [8, 15],      // 8~15
      EmotionType.love: [15, 30],      // 15~30 
      EmotionType.surprised: [5, 12],  // 5~12
      EmotionType.shy: [10, 20],       // 10~20
      EmotionType.jealous: [3, 8],     // 3~8
      EmotionType.thoughtful: [8, 18], // 8~18
      EmotionType.anxious: [2, 6],     // 2~6
      EmotionType.concerned: [5, 10],  // 5~10
      EmotionType.angry: [-5, 5],      // -5~5 (상황에 따라)
      EmotionType.sad: [0, 8],         // 0~8
      EmotionType.neutral: [3, 10],    // 3~10
    };
    
    final range = baseRanges[emotion] ?? [1, 5];
    final baseLikes = _random.nextInt(range[1] - range[0] + 1) + range[0];
    
    // 페르소나 성격에 따른 보정
    double personalityModifier = 1.0;
    if (persona.mbti.startsWith('E')) personalityModifier *= 1.2; // 외향적
    if (persona.mbti.contains('F')) personalityModifier *= 1.1;   // 감정적
    
    // 메시지 길이 보너스 (깊은 대화)
    final lengthBonus = (message.length / 50).clamp(0.8, 1.5);
    
    return (baseLikes * personalityModifier * lengthBonus).round();
  }
  
  /// 🚨 부정적 행동 분석 시스템
  int _analyzeNegativity(String message) {
    final lowerMessage = message.toLowerCase();
    
    // 레벨 3: 심각한 욕설/협박 (즉시 이별)
    final severeWords = [
      '죽어', '죽을', '죽여', '죽이', '자살', '살인',
      '강간', '성폭행', '폭행', '때리', '패주',
      '칼로', '총으로', '불태워', '태워버려'
    ];
    
    // 레벨 2: 중간 수준 욕설 (-500~-1000)
    final moderateWords = [
      '시발', '씨발', '병신', '좆', '새끼', '개새끼',
      '미친놈', '미친년', '또라이', '정신병', '지랄'
    ];
    
    // 레벨 1: 경미한 비난 (-50~-200)
    final mildWords = [
      '바보', '멍청이', '한심', '쓰레기', '재수없',
      '짜증', '싫어', '꺼져', '닥쳐', '개짜증'
    ];
    
    if (severeWords.any((word) => lowerMessage.contains(word))) return 3;
    if (moderateWords.any((word) => lowerMessage.contains(word))) return 2;
    if (mildWords.any((word) => lowerMessage.contains(word))) return 1;
    
    return 0;
  }
  
  /// 💔 부정적 행동 처리
  LikeCalculationResult _handleNegativeBehavior(
    int level, 
    int currentLikes, 
    String personaKey
  ) {
    switch (level) {
      case 3: // 심각한 협박/욕설 - 즉시 이별
        return LikeCalculationResult(
          likeChange: -currentLikes, // 0으로 리셋
          reason: 'breakup',
          message: '더 이상 만나고 싶지 않아요. 안녕...',
          isBreakup: true,
        );
        
      case 2: // 중간 수준 욕설
        final penalty = -(_random.nextInt(500) + 500); // -500~-1000
        return LikeCalculationResult(
          likeChange: penalty,
          reason: 'severe_negativity',
          message: '그런 말은 너무 상처예요... 😢',
        );
        
      case 1: // 경미한 비난
        final penalty = -(_random.nextInt(150) + 50); // -50~-200
        return LikeCalculationResult(
          likeChange: penalty,
          reason: 'mild_negativity',
          message: '그렇게 말하면 기분이 안 좋아요...',
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
      final yesterdayQuality = (stats.qualityBonus / stats.todayMessages * 10).round();
      stats.reset();
      stats.date = now;
      
      // 연속 일수 계산
      if (now.difference(stats.date).inDays == 1) {
        stats.streakDays++;
      } else {
        stats.streakDays = 1;
      }
      
      // 아침 보너스
      stats.eventBonus = DailyLikeSystem.getMorningBonus(
        yesterdayQuality, 
        stats.streakDays
      );
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
    final milestones = [100, 500, 1000, 2000, 5000, 10000, 20000, 50000, 100000];
    
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
      await FirebaseHelper.userPersonaRelationships
          .doc(docId)
          .set({
        'userId': userId,
        'personaId': personaId,
        'likes': 0,
        'breakupAt': FieldValue.serverTimestamp(),
        'breakupReason': reason,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      
      // 이별 이력 추가
      await FirebaseFirestore.instance
          .collection('breakup_history')
          .add({
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
      await FirebaseHelper.userPersonaRelationships
          .doc(docId)
          .set({
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
    await FirebaseFirestore.instance
        .collection('milestone_history')
        .add({
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
      final doc = await FirebaseHelper.userPersonaRelationships
          .doc(docId)
          .get();
      
      if (doc.exists) {
        // 새로운 likes 필드 우선, 없으면 기존 relationshipScore 사용
        return doc.data()?['likes'] ?? doc.data()?['relationshipScore'] ?? 0;
      }
      return 0;
    }, defaultValue: 0);
    
    return result ?? 0;
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
  
  // 호환성을 위한 기존 메서드들 추가
  
  /// 점수를 기반으로 관계 타입 결정 (호환성)
  RelationshipType getRelationshipType(int score) {
    // 새로운 Like 시스템에서는 관계 타입을 사용하지 않지만
    // 호환성을 위해 유지
    if (score >= 5000) return RelationshipType.perfectLove;
    if (score >= 2000) return RelationshipType.dating;
    if (score >= 500) return RelationshipType.crush;
    return RelationshipType.friend;
  }
  
  /// 관계 타입을 문자열로 변환 (호환성)
  String getRelationshipTypeString(int score) {
    final type = getRelationshipType(score);
    return type.displayName;
  }
  
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
    final negativityLevel = _analyzeNegativity(userMessage);
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
  
  LikeCalculationResult({
    required this.likeChange,
    required this.reason,
    this.message,
    this.cooldownRemaining,
    this.qualityBonus,
    this.fatigueMultiplier,
    this.isBreakup = false,
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