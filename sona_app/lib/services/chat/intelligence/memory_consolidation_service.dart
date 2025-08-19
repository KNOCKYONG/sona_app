import 'dart:async';
import 'package:flutter/material.dart';
import '../../../models/message.dart';
import '../../../models/persona.dart';
import '../core/persistent_memory_system.dart';
import 'conversation_memory_service.dart';

/// 🧠 메모리 통합 서비스
/// 
/// 단기 메모리를 장기 메모리로 통합하고
/// 수면 중 기억 정리 시뮬레이션
class MemoryConsolidationService {
  static MemoryConsolidationService? _instance;
  static MemoryConsolidationService get instance =>
      _instance ??= MemoryConsolidationService._();
  
  MemoryConsolidationService._();
  
  final PersistentMemorySystem _persistentMemory = PersistentMemorySystem.instance;
  final ConversationMemoryService _memoryService = ConversationMemoryService();
  
  // 통합 주기 설정
  static const Duration _consolidationInterval = Duration(hours: 24);
  static const Duration _quickConsolidation = Duration(hours: 3);
  
  // 통합 타이머
  final Map<String, Timer> _consolidationTimers = {};
  
  /// 🌙 메모리 통합 시작 (수면 시뮬레이션)
  Future<void> startMemoryConsolidation({
    required String userId,
    required String personaId,
    required List<Message> recentMessages,
    required Map<String, dynamic> conversationState,
    bool isQuickConsolidation = false,
  }) async {
    final key = '${userId}_${personaId}';
    
    // 기존 타이머 취소
    _consolidationTimers[key]?.cancel();
    
    // 즉시 통합이 필요한 경우
    if (isQuickConsolidation || _shouldConsolidateImmediately(recentMessages)) {
      await _performConsolidation(
        userId: userId,
        personaId: personaId,
        messages: recentMessages,
        state: conversationState,
      );
      return;
    }
    
    // 정기 통합 스케줄링
    _consolidationTimers[key] = Timer(
      isQuickConsolidation ? _quickConsolidation : _consolidationInterval,
      () async {
        await _performConsolidation(
          userId: userId,
          personaId: personaId,
          messages: recentMessages,
          state: conversationState,
        );
      },
    );
    
    debugPrint('🌙 Memory consolidation scheduled for $key');
  }
  
  /// 💫 메모리 통합 수행
  Future<Map<String, dynamic>> _performConsolidation({
    required String userId,
    required String personaId,
    required List<Message> messages,
    required Map<String, dynamic> state,
  }) async {
    debugPrint('💫 Starting memory consolidation for ${userId}_$personaId');
    
    try {
      // 1. 단기 메모리 분석
      final shortTermMemories = await _analyzeShortTermMemory(messages);
      
      // 2. 패턴 추출
      final patterns = _extractPatterns(shortTermMemories);
      
      // 3. 감정 궤적 분석
      final emotionalTrajectory = _analyzeEmotionalTrajectory(messages);
      
      // 4. 핵심 순간 식별
      final keyMoments = _identifyKeyMoments(
        messages: messages,
        patterns: patterns,
        emotions: emotionalTrajectory,
      );
      
      // 5. 기억 압축 및 강화
      final consolidatedMemories = await _consolidateMemories(
        shortTerm: shortTermMemories,
        keyMoments: keyMoments,
        patterns: patterns,
      );
      
      // 6. 영구 메모리로 저장
      if (consolidatedMemories.isNotEmpty) {
        await _persistentMemory.convertToPermamentMemory(
          userId: userId,
          personaId: personaId,
          messages: messages,
          conversationState: {
            ...state,
            'consolidatedAt': DateTime.now().toIso8601String(),
            'patterns': patterns,
            'emotionalTrajectory': emotionalTrajectory,
          },
        );
      }
      
      // 7. 꿈 생성 (특별한 기억 재구성)
      final dreams = _generateDreams(consolidatedMemories, emotionalTrajectory);
      
      debugPrint('✨ Consolidation complete: ${consolidatedMemories.length} memories');
      
      return {
        'consolidatedCount': consolidatedMemories.length,
        'patterns': patterns,
        'keyMoments': keyMoments.length,
        'emotionalSummary': emotionalTrajectory,
        'dreams': dreams,
      };
      
    } catch (e) {
      debugPrint('❌ Error during memory consolidation: $e');
      return {};
    }
  }
  
  /// 🔍 단기 메모리 분석
  Future<List<ConversationMemory>> _analyzeShortTermMemory(
    List<Message> messages
  ) async {
    final memories = <ConversationMemory>[];
    
    // 최근 24시간 메시지만 분석
    final cutoff = DateTime.now().subtract(Duration(hours: 24));
    final recentMessages = messages.where((m) => m.timestamp.isAfter(cutoff)).toList();
    
    for (int i = 0; i < recentMessages.length; i++) {
      final msg = recentMessages[i];
      
      // 중요도 계산
      double importance = 0.0;
      
      // 감정적 중요도
      if (msg.emotion != null && msg.emotion != EmotionType.neutral) {
        importance += 0.3;
      }
      
      // 관계 변화
      if (msg.likesChange != null && msg.likesChange! != 0) {
        importance += (msg.likesChange!.abs() / 100).clamp(0.0, 0.4);
      }
      
      // 대화 전환점
      if (i > 0 && i < recentMessages.length - 1) {
        final prevTopic = _extractTopic(recentMessages[i-1].content);
        final currentTopic = _extractTopic(msg.content);
        final nextTopic = _extractTopic(recentMessages[i+1].content);
        
        if (prevTopic != currentTopic || currentTopic != nextTopic) {
          importance += 0.2;
        }
      }
      
      // 사용자 정보
      if (_containsPersonalInfo(msg.content)) {
        importance += 0.3;
      }
      
      if (importance >= 0.5) {
        memories.add(ConversationMemory(
          id: msg.id,
          userId: '',
          personaId: msg.personaId,
          messageId: msg.id,
          content: msg.content,
          isFromUser: msg.isFromUser,
          timestamp: msg.timestamp,
          importance: importance,
          tags: [_extractTopic(msg.content)],
          emotion: msg.emotion ?? EmotionType.neutral,
          likesChange: msg.likesChange ?? 0,
          context: '',
        ));
      }
    }
    
    return memories;
  }
  
  /// 🎭 패턴 추출
  Map<String, dynamic> _extractPatterns(List<ConversationMemory> memories) {
    final patterns = <String, dynamic>{
      'topics': <String, int>{},
      'emotions': <String, int>{},
      'timePatterns': <String, int>{},
      'interactionStyles': <String, int>{},
    };
    
    for (final memory in memories) {
      // 주제 패턴
      for (final tag in memory.tags) {
        patterns['topics'][tag] = (patterns['topics'][tag] ?? 0) + 1;
      }
      
      // 감정 패턴
      patterns['emotions'][memory.emotion.name] = 
          (patterns['emotions'][memory.emotion.name] ?? 0) + 1;
      
      // 시간 패턴
      final hour = memory.timestamp.hour;
      final timeSlot = _getTimeSlot(hour);
      patterns['timePatterns'][timeSlot] = 
          (patterns['timePatterns'][timeSlot] ?? 0) + 1;
      
      // 상호작용 스타일
      if (memory.content.contains('?')) {
        patterns['interactionStyles']['questioning'] = 
            (patterns['interactionStyles']['questioning'] ?? 0) + 1;
      }
      if (memory.content.contains('!')) {
        patterns['interactionStyles']['exclamatory'] = 
            (patterns['interactionStyles']['exclamatory'] ?? 0) + 1;
      }
    }
    
    return patterns;
  }
  
  /// 💗 감정 궤적 분석
  Map<String, dynamic> _analyzeEmotionalTrajectory(List<Message> messages) {
    final trajectory = <String, dynamic>{
      'overall': 'neutral',
      'trend': 'stable',
      'peaks': [],
      'valleys': [],
      'volatility': 0.0,
    };
    
    final emotions = messages
        .where((m) => m.emotion != null)
        .map((m) => m.emotion!)
        .toList();
    
    if (emotions.isEmpty) return trajectory;
    
    // 전반적 감정
    final emotionCounts = <EmotionType, int>{};
    for (final emotion in emotions) {
      emotionCounts[emotion] = (emotionCounts[emotion] ?? 0) + 1;
    }
    
    final dominantEmotion = emotionCounts.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
    trajectory['overall'] = dominantEmotion.name;
    
    // 감정 변화 추세
    if (emotions.length >= 3) {
      final firstThird = emotions.take(emotions.length ~/ 3).toList();
      final lastThird = emotions.skip(emotions.length * 2 ~/ 3).toList();
      
      final firstScore = _calculateEmotionScore(firstThird);
      final lastScore = _calculateEmotionScore(lastThird);
      
      if (lastScore > firstScore + 0.2) {
        trajectory['trend'] = 'improving';
      } else if (lastScore < firstScore - 0.2) {
        trajectory['trend'] = 'declining';
      }
    }
    
    // 감정 변동성
    if (emotions.length >= 2) {
      int changes = 0;
      for (int i = 1; i < emotions.length; i++) {
        if (emotions[i] != emotions[i-1]) changes++;
      }
      trajectory['volatility'] = changes / emotions.length;
    }
    
    return trajectory;
  }
  
  /// 🌟 핵심 순간 식별
  List<KeyMoment> _identifyKeyMoments({
    required List<Message> messages,
    required Map<String, dynamic> patterns,
    required Map<String, dynamic> emotions,
  }) {
    final keyMoments = <KeyMoment>[];
    
    for (int i = 0; i < messages.length; i++) {
      final msg = messages[i];
      double significance = 0.0;
      String type = 'normal';
      
      // 큰 관계 변화
      if (msg.likesChange != null && msg.likesChange!.abs() >= 30) {
        significance += 0.5;
        type = 'relationship_milestone';
      }
      
      // 감정 전환점
      if (i > 0 && msg.emotion != null) {
        final prevEmotion = messages[i-1].emotion;
        if (prevEmotion != null && prevEmotion != msg.emotion) {
          significance += 0.3;
          if (type == 'normal') type = 'emotional_shift';
        }
      }
      
      // 중요한 정보 공유
      if (_containsImportantInfo(msg.content)) {
        significance += 0.4;
        if (type == 'normal') type = 'important_sharing';
      }
      
      // 대화 절정
      if (i > 2 && i < messages.length - 2) {
        final surroundingIntensity = _calculateSurroundingIntensity(messages, i);
        if (surroundingIntensity > 0.7) {
          significance += 0.3;
          if (type == 'normal') type = 'conversation_peak';
        }
      }
      
      if (significance >= 0.6) {
        keyMoments.add(KeyMoment(
          message: msg,
          significance: significance,
          type: type,
          index: i,
        ));
      }
    }
    
    return keyMoments;
  }
  
  /// 🔮 기억 통합
  Future<List<ConversationMemory>> _consolidateMemories({
    required List<ConversationMemory> shortTerm,
    required List<KeyMoment> keyMoments,
    required Map<String, dynamic> patterns,
  }) async {
    final consolidated = <ConversationMemory>[];
    
    // 핵심 순간은 모두 보존
    for (final moment in keyMoments) {
      final memory = shortTerm.firstWhere(
        (m) => m.messageId == moment.message.id,
        orElse: () => ConversationMemory(
          id: moment.message.id,
          userId: '',
          personaId: moment.message.personaId,
          messageId: moment.message.id,
          content: moment.message.content,
          isFromUser: moment.message.isFromUser,
          timestamp: moment.message.timestamp,
          importance: moment.significance,
          tags: [moment.type],
          emotion: moment.message.emotion ?? EmotionType.neutral,
          likesChange: moment.message.likesChange ?? 0,
          context: '',
        ),
      );
      
      // 중요도 강화
      memory.importance = (memory.importance + moment.significance) / 2;
      consolidated.add(memory);
    }
    
    // 패턴 기반 중요 메모리 추가
    final topTopics = _getTopItems(patterns['topics'] as Map<String, int>, 3);
    for (final memory in shortTerm) {
      if (memory.tags.any((tag) => topTopics.contains(tag)) &&
          !consolidated.any((c) => c.id == memory.id)) {
        consolidated.add(memory);
      }
    }
    
    return consolidated;
  }
  
  /// 💭 꿈 생성 (기억 재구성)
  List<String> _generateDreams(
    List<ConversationMemory> memories,
    Map<String, dynamic> emotionalTrajectory,
  ) {
    final dreams = <String>[];
    
    if (memories.isEmpty) return dreams;
    
    // 감정적으로 강렬한 기억들 연결
    final emotionalMemories = memories
        .where((m) => m.emotion != EmotionType.neutral)
        .toList();
    
    if (emotionalMemories.length >= 2) {
      final dream = '${emotionalMemories.first.content.substring(0, 30)}... '
          '그리고 ${emotionalMemories.last.content.substring(0, 30)}...';
      dreams.add(dream);
    }
    
    // 반복되는 주제들의 조합
    final topicMemories = memories.where((m) => m.tags.isNotEmpty).toList();
    if (topicMemories.length >= 3) {
      final topics = topicMemories.map((m) => m.tags.first).toSet().toList();
      if (topics.isNotEmpty) {
        dreams.add('${topics.join(', ')}에 대한 이야기들이 섞여있는 꿈');
      }
    }
    
    return dreams;
  }
  
  /// ⏰ 즉시 통합 필요 여부 판단
  bool _shouldConsolidateImmediately(List<Message> messages) {
    // 대화가 100턴 이상
    if (messages.length >= 100) return true;
    
    // 큰 감정 변화
    final recentEmotions = messages
        .take(10)
        .where((m) => m.emotion != null)
        .map((m) => m.emotion!)
        .toList();
    
    if (recentEmotions.contains(EmotionType.love) ||
        recentEmotions.contains(EmotionType.excited)) {
      return true;
    }
    
    // 큰 관계 변화
    final totalLikesChange = messages
        .take(10)
        .fold(0, (sum, m) => sum + (m.likesChange ?? 0));
    
    if (totalLikesChange.abs() >= 50) return true;
    
    return false;
  }
  
  // 유틸리티 메서드들
  String _extractTopic(String content) {
    // 간단한 주제 추출 로직
    if (content.contains('날씨')) return '날씨';
    if (content.contains('음식') || content.contains('먹')) return '음식';
    if (content.contains('영화') || content.contains('드라마')) return '엔터테인먼트';
    if (content.contains('일') || content.contains('회사')) return '일상';
    if (content.contains('사랑') || content.contains('좋아')) return '감정';
    return '일반';
  }
  
  bool _containsPersonalInfo(String content) {
    final patterns = ['나는', '제가', '살', '좋아', '싫어', '있어요', '없어요'];
    return patterns.any((p) => content.contains(p));
  }
  
  bool _containsImportantInfo(String content) {
    final patterns = ['약속', '비밀', '처음', '특별', '영원', '사랑'];
    return patterns.any((p) => content.contains(p));
  }
  
  String _getTimeSlot(int hour) {
    if (hour < 6) return '새벽';
    if (hour < 12) return '오전';
    if (hour < 18) return '오후';
    return '저녁';
  }
  
  double _calculateEmotionScore(List<EmotionType> emotions) {
    final scores = {
      EmotionType.love: 1.0,
      EmotionType.excited: 0.8,
      EmotionType.happy: 0.6,
      EmotionType.neutral: 0.0,
      EmotionType.confused: -0.2,
      EmotionType.sad: -0.4,
      EmotionType.angry: -0.6,
    };
    
    if (emotions.isEmpty) return 0.0;
    
    final totalScore = emotions.fold(0.0, (sum, e) => sum + (scores[e] ?? 0.0));
    return totalScore / emotions.length;
  }
  
  double _calculateSurroundingIntensity(List<Message> messages, int index) {
    final start = (index - 2).clamp(0, messages.length);
    final end = (index + 3).clamp(0, messages.length);
    
    final surrounding = messages.sublist(start, end);
    final hasEmotion = surrounding.any((m) => m.emotion != null && m.emotion != EmotionType.neutral);
    final hasLikesChange = surrounding.any((m) => m.likesChange != null && m.likesChange! != 0);
    final hasQuestions = surrounding.any((m) => m.content.contains('?'));
    
    double intensity = 0.0;
    if (hasEmotion) intensity += 0.4;
    if (hasLikesChange) intensity += 0.3;
    if (hasQuestions) intensity += 0.3;
    
    return intensity;
  }
  
  List<String> _getTopItems(Map<String, int> items, int count) {
    final sorted = items.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    return sorted.take(count).map((e) => e.key).toList();
  }
  
  /// 🧹 타이머 정리
  void dispose() {
    for (final timer in _consolidationTimers.values) {
      timer.cancel();
    }
    _consolidationTimers.clear();
  }
}

/// 핵심 순간 클래스
class KeyMoment {
  final Message message;
  final double significance;
  final String type;
  final int index;
  
  KeyMoment({
    required this.message,
    required this.significance,
    required this.type,
    required this.index,
  });
}