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
    
    // 부정적 행동 체크 (관계 점수 및 게임 컨텍스트 고려)
    final negativityLevel = _analyzeNegativity(userMessage, currentLikes, chatHistory);
    if (negativityLevel > 0) {
      return _handleNegativeBehavior(negativityLevel, currentLikes, personaKey, persona, userMessage, chatHistory);
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
      specialBonus = _detectSpecialMomentBonus(userMessage, aiResponse, chatHistory, currentLikes);
    }
    
    // 품질 보너스 (개선된 버전)
    final qualityBonus = _calculateEnhancedQualityBonus(
      userMessage, 
      lastMessageTime,
      conversationQuality ?? 50.0
    );
    
    // 연속 대화 페널티
    final consecutivePenalty = _cooldown.getConsecutivePenalty(stats.recentMessages);
    
    // 최종 Like 계산
    int finalLikes = (baseLikes * dynamicMultiplier * (1 + qualityBonus * 0.1) * fatigueMultiplier * (1 - consecutivePenalty / 100)).round();
    finalLikes += specialBonus;
    
    // 관계 단계에 따른 최소/최대값 제한
    finalLikes = _applyRelationshipStageLimits(finalLikes, currentLikes);
    
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
      specialBonus: specialBonus,
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
  
  /// 🚨 부정적 행동 분석 시스템 (관계 점수 및 게임 컨텍스트 고려)
  int _analyzeNegativity(String message, int currentLikes, List<Message> chatHistory) {
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
  
  /// 💔 부정적 행동 처리
  LikeCalculationResult _handleNegativeBehavior(
    int level, 
    int currentLikes, 
    String personaKey,
    Persona persona,
    String userMessage,
    List<Message> chatHistory,
  ) {
    // 최근 메시지 추출
    final recentMessages = chatHistory.take(5).map((m) => m.content).toList();
    
    // NegativeBehaviorSystem을 사용하여 상세 분석
    final analysis = NegativeBehaviorSystem().analyze(
      userMessage,
      likes: currentLikes,
      recentMessages: recentMessages,
    );
    
    // 페르소나 반응 생성
    final response = NegativeBehaviorSystem().generateResponse(
      analysis, 
      persona,
      likes: currentLikes
    );
    
    switch (level) {
      case 3: // 심각한 협박/욕설 - 즉시 이별
        return LikeCalculationResult(
          likeChange: -currentLikes, // 0으로 리셋
          reason: 'breakup',
          message: response.isNotEmpty ? response : '더 이상 만나고 싶지 않아요. 안녕...',
          isBreakup: true,
        );
        
      case 2: // 중간 수준 욕설
        final penalty = analysis.penalty ?? -(_random.nextInt(500) + 500); // -500~-1000
        return LikeCalculationResult(
          likeChange: penalty,
          reason: 'severe_negativity',
          message: response.isNotEmpty ? response : '그런 말은 너무 상처예요... 😢',
          isWarning: analysis.isWarning,
        );
        
      case 1: // 경미한 비난 또는 추임새 욕설
        final penalty = analysis.penalty ?? -(_random.nextInt(150) + 50); // -50~-200
        return LikeCalculationResult(
          likeChange: -penalty, // 음수로 변환
          reason: analysis.category == 'casual_swear' ? 'casual_swear' : 'mild_negativity',
          message: response.isNotEmpty ? response : '그렇게 말하면 기분이 안 좋아요...',
          isWarning: analysis.isWarning,
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
    final contextIsDeep = recentMessages.any((m) => 
      deepTopics.any((t) => m.content.contains(t))
    );
    
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
  int _detectSpecialMomentBonus(String userMessage, String aiResponse, List<Message> chatHistory, int currentLikes) {
    // 첫 고민 상담
    if ((userMessage.contains('고민') || userMessage.contains('걱정')) &&
        !chatHistory.any((m) => m.content.contains('고민') || m.content.contains('걱정'))) {
      debugPrint('💝 특별한 순간: 첫 고민 상담 (+50)');
      return 50;
    }
    
    // 첫 꿈/목표 공유
    if ((userMessage.contains('꿈') || userMessage.contains('목표')) &&
        !chatHistory.any((m) => m.content.contains('꿈') || m.content.contains('목표'))) {
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
  int _calculateEnhancedQualityBonus(String message, DateTime? lastMessageTime, double conversationQuality) {
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
    final negativityLevel = _analyzeNegativity(userMessage, currentScore, chatHistory);
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