import 'dart:math';
import 'package:flutter/material.dart';
import '../../../models/message.dart';
import '../../../models/persona.dart';

/// 🧠 연관 기억 네트워크
/// 대화 내용을 연결하여 맥락있는 기억을 형성하는 서비스
class MemoryNetworkService {
  static MemoryNetworkService? _instance;
  static MemoryNetworkService get instance => 
      _instance ??= MemoryNetworkService._();
  
  MemoryNetworkService._();
  
  // 사용자별 기억 네트워크
  final Map<String, MemoryNetwork> _userNetworks = {};
  
  // 임시 작업 기억
  final Map<String, WorkingMemory> _workingMemories = {};
  
  /// 기억 네트워크 활성화
  Map<String, dynamic> activateMemory({
    required String userMessage,
    required List<Message> chatHistory,
    required String userId,
    required Persona persona,
    required int likeScore,
  }) {
    // 기억 네트워크 로드 또는 생성
    final network = _getOrCreateNetwork(userId);
    
    // 현재 맥락 분석
    final currentContext = _analyzeCurrentContext(userMessage, chatHistory);
    
    // 연관 기억 검색
    final associatedMemories = _searchAssociatedMemories(
      network,
      currentContext,
      userMessage,
    );
    
    // 작업 기억 업데이트
    final workingMemory = _updateWorkingMemory(
      userId,
      currentContext,
      associatedMemories,
    );
    
    // 기억 연결 생성
    final connections = _createMemoryConnections(
      currentContext,
      associatedMemories,
      network,
    );
    
    // 기억 강화
    _reinforceMemories(network, associatedMemories, likeScore);
    
    // 새 기억 저장
    _storeNewMemory(network, currentContext, userMessage);
    
    // 기억 기반 통찰
    final insights = _generateMemoryInsights(
      associatedMemories,
      connections,
      workingMemory,
    );
    
    // 기억 가이드 생성
    final memoryGuide = _generateMemoryGuide(
      associatedMemories,
      connections,
      insights,
      workingMemory,
    );
    
    return {
      'associatedMemories': associatedMemories.map((m) => m.toMap()).toList(),
      'connections': connections.map((c) => c.toMap()).toList(),
      'workingMemory': workingMemory.toMap(),
      'insights': insights,
      'memoryGuide': memoryGuide,
      'hasRelevantMemory': associatedMemories.isNotEmpty,
    };
  }
  
  /// 네트워크 가져오기 또는 생성
  MemoryNetwork _getOrCreateNetwork(String userId) {
    return _userNetworks[userId] ??= MemoryNetwork(userId: userId);
  }
  
  /// 현재 맥락 분석
  MemoryContext _analyzeCurrentContext(String message, List<Message> history) {
    // 주요 키워드 추출
    final keywords = _extractKeywords(message);
    
    // 주제 분류
    final topic = _classifyTopic(message, keywords);
    
    // 감정 톤
    final emotionalTone = _detectEmotionalTone(message);
    
    // 시간 참조
    final temporalReference = _detectTemporalReference(message);
    
    // 인물/장소 참조
    final entities = _extractEntities(message);
    
    // 의도 파악
    final intent = _detectIntent(message);
    
    return MemoryContext(
      keywords: keywords,
      topic: topic,
      emotionalTone: emotionalTone,
      temporalReference: temporalReference,
      entities: entities,
      intent: intent,
      timestamp: DateTime.now(),
      originalMessage: message,
    );
  }
  
  /// 연관 기억 검색
  List<MemoryNode> _searchAssociatedMemories(
    MemoryNetwork network,
    MemoryContext context,
    String message,
  ) {
    final memories = <MemoryNode>[];
    
    // 키워드 기반 검색
    for (final keyword in context.keywords) {
      memories.addAll(network.searchByKeyword(keyword));
    }
    
    // 주제 기반 검색
    memories.addAll(network.searchByTopic(context.topic));
    
    // 감정 기반 검색
    if (context.emotionalTone != 'neutral') {
      memories.addAll(network.searchByEmotion(context.emotionalTone));
    }
    
    // 시간 기반 검색
    if (context.temporalReference != null) {
      memories.addAll(network.searchByTime(context.temporalReference!));
    }
    
    // 중복 제거 및 관련성 점수 계산
    final uniqueMemories = <String, MemoryNode>{};
    for (final memory in memories) {
      final score = _calculateRelevanceScore(memory, context, message);
      memory.relevanceScore = score;
      
      if (!uniqueMemories.containsKey(memory.id) || 
          uniqueMemories[memory.id]!.relevanceScore < score) {
        uniqueMemories[memory.id] = memory;
      }
    }
    
    // 관련성 순으로 정렬 (상위 5개만)
    final sorted = uniqueMemories.values.toList()
      ..sort((a, b) => b.relevanceScore.compareTo(a.relevanceScore));
    
    return sorted.take(5).toList();
  }
  
  /// 작업 기억 업데이트
  WorkingMemory _updateWorkingMemory(
    String userId,
    MemoryContext context,
    List<MemoryNode> associatedMemories,
  ) {
    _workingMemories[userId] ??= WorkingMemory();
    final memory = _workingMemories[userId]!;
    
    // 현재 맥락 추가
    memory.addContext(context);
    
    // 연관 기억 추가
    for (final associated in associatedMemories) {
      memory.addAssociation(associated);
    }
    
    // 오래된 항목 제거
    memory.cleanup();
    
    return memory;
  }
  
  /// 기억 연결 생성
  List<MemoryConnection> _createMemoryConnections(
    MemoryContext current,
    List<MemoryNode> associated,
    MemoryNetwork network,
  ) {
    final connections = <MemoryConnection>[];
    
    // 현재 맥락과 연관 기억 연결
    for (final memory in associated) {
      final connection = MemoryConnection(
        fromId: 'current',
        toId: memory.id,
        type: _determineConnectionType(current, memory),
        strength: memory.relevanceScore,
        reason: _explainConnection(current, memory),
      );
      connections.add(connection);
      
      // 네트워크에 연결 저장
      network.addConnection(connection);
    }
    
    // 연관 기억들 간의 연결 찾기
    for (int i = 0; i < associated.length - 1; i++) {
      for (int j = i + 1; j < associated.length; j++) {
        final similarity = _calculateSimilarity(associated[i], associated[j]);
        if (similarity > 0.5) {
          connections.add(MemoryConnection(
            fromId: associated[i].id,
            toId: associated[j].id,
            type: 'related',
            strength: similarity,
            reason: '유사한 맥락',
          ));
        }
      }
    }
    
    return connections;
  }
  
  /// 기억 강화
  void _reinforceMemories(
    MemoryNetwork network,
    List<MemoryNode> memories,
    int likeScore,
  ) {
    // 호감도에 따른 강화 계수
    final reinforcementFactor = 1.0 + (likeScore / 1000);
    
    for (final memory in memories) {
      // 접근 횟수 증가
      memory.accessCount++;
      
      // 중요도 강화
      memory.importance *= reinforcementFactor;
      memory.importance = memory.importance.clamp(0, 10);
      
      // 마지막 접근 시간 업데이트
      memory.lastAccessed = DateTime.now();
      
      // 네트워크에 업데이트
      network.updateMemory(memory);
    }
  }
  
  /// 새 기억 저장
  void _storeNewMemory(
    MemoryNetwork network,
    MemoryContext context,
    String message,
  ) {
    final memory = MemoryNode(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: message,
      context: context,
      importance: _calculateInitialImportance(context, message),
      createdAt: DateTime.now(),
      lastAccessed: DateTime.now(),
      accessCount: 1,
      emotionalValence: _calculateEmotionalValence(context.emotionalTone),
    );
    
    network.addMemory(memory);
  }
  
  /// 기억 기반 통찰 생성
  Map<String, dynamic> _generateMemoryInsights(
    List<MemoryNode> memories,
    List<MemoryConnection> connections,
    WorkingMemory workingMemory,
  ) {
    final insights = <String, dynamic>{};
    
    // 패턴 인식
    final patterns = _recognizePatterns(memories);
    if (patterns.isNotEmpty) {
      insights['patterns'] = patterns;
    }
    
    // 감정 변화 추적
    final emotionalJourney = _trackEmotionalJourney(memories);
    if (emotionalJourney.isNotEmpty) {
      insights['emotionalJourney'] = emotionalJourney;
    }
    
    // 반복되는 주제
    final recurringTopics = _findRecurringTopics(memories);
    if (recurringTopics.isNotEmpty) {
      insights['recurringTopics'] = recurringTopics;
    }
    
    // 시간적 연결
    final temporalLinks = _findTemporalLinks(memories);
    if (temporalLinks.isNotEmpty) {
      insights['temporalLinks'] = temporalLinks;
    }
    
    // 중요한 전환점
    final turningPoints = _identifyTurningPoints(workingMemory);
    if (turningPoints.isNotEmpty) {
      insights['turningPoints'] = turningPoints;
    }
    
    return insights;
  }
  
  /// 기억 가이드 생성
  String _generateMemoryGuide(
    List<MemoryNode> memories,
    List<MemoryConnection> connections,
    Map<String, dynamic> insights,
    WorkingMemory workingMemory,
  ) {
    final buffer = StringBuffer();
    
    buffer.writeln('🧠 기억 네트워크 가이드:');
    buffer.writeln('');
    
    // 연관 기억
    if (memories.isNotEmpty) {
      buffer.writeln('📚 연관된 기억 (${memories.length}개):');
      for (final memory in memories.take(3)) {
        buffer.writeln('• ${_summarizeMemory(memory)}');
        buffer.writeln('  관련성: ${(memory.relevanceScore * 100).toInt()}%');
      }
      buffer.writeln('');
    }
    
    // 기억 연결
    if (connections.isNotEmpty) {
      buffer.writeln('🔗 기억 연결:');
      for (final connection in connections.take(3)) {
        buffer.writeln('• ${connection.reason} (강도: ${(connection.strength * 100).toInt()}%)');
      }
      buffer.writeln('');
    }
    
    // 통찰
    if (insights.isNotEmpty) {
      buffer.writeln('💡 기억 기반 통찰:');
      
      if (insights.containsKey('patterns')) {
        buffer.writeln('• 패턴: ${insights['patterns'].join(', ')}');
      }
      
      if (insights.containsKey('recurringTopics')) {
        buffer.writeln('• 자주 나오는 주제: ${insights['recurringTopics'].join(', ')}');
      }
      
      if (insights.containsKey('emotionalJourney')) {
        buffer.writeln('• 감정 변화: ${insights['emotionalJourney']}');
      }
      buffer.writeln('');
    }
    
    // 작업 기억 상태
    buffer.writeln('🎯 현재 맥락:');
    buffer.writeln('• 활성 주제: ${workingMemory.getActiveTopics().join(', ')}');
    buffer.writeln('• 최근 감정: ${workingMemory.getRecentEmotions().join(' → ')}');
    
    return buffer.toString();
  }
  
  /// 키워드 추출
  List<String> _extractKeywords(String message) {
    final keywords = <String>[];
    
    // 명사 패턴 (간단한 예시)
    final nouns = ['영화', '음악', '게임', '일', '학교', '친구', '가족', '음식', '여행', '책'];
    for (final noun in nouns) {
      if (message.contains(noun)) {
        keywords.add(noun);
      }
    }
    
    // 중요 동사
    final verbs = ['좋아', '싫어', '했어', '갔어', '봤어', '먹었어', '만났어'];
    for (final verb in verbs) {
      if (message.contains(verb)) {
        keywords.add(verb);
      }
    }
    
    return keywords;
  }
  
  /// 주제 분류
  String _classifyTopic(String message, List<String> keywords) {
    // 간단한 주제 분류
    if (keywords.contains('영화') || keywords.contains('드라마')) return 'entertainment';
    if (keywords.contains('일') || keywords.contains('회사')) return 'work';
    if (keywords.contains('음식') || keywords.contains('먹')) return 'food';
    if (keywords.contains('친구') || keywords.contains('가족')) return 'relationships';
    if (keywords.contains('게임') || keywords.contains('놀')) return 'leisure';
    return 'general';
  }
  
  /// 감정 톤 감지
  String _detectEmotionalTone(String message) {
    if (message.contains('좋') || message.contains('행복')) return 'positive';
    if (message.contains('슬') || message.contains('우울')) return 'sad';
    if (message.contains('화') || message.contains('짜증')) return 'angry';
    if (message.contains('무서') || message.contains('불안')) return 'anxious';
    return 'neutral';
  }
  
  /// 시간 참조 감지
  String? _detectTemporalReference(String message) {
    if (message.contains('어제')) return 'yesterday';
    if (message.contains('오늘')) return 'today';
    if (message.contains('내일')) return 'tomorrow';
    if (message.contains('저번') || message.contains('지난')) return 'past';
    if (message.contains('다음')) return 'future';
    return null;
  }
  
  /// 개체 추출
  Map<String, List<String>> _extractEntities(String message) {
    final entities = <String, List<String>>{};
    
    // 사람 (간단한 패턴)
    final people = <String>[];
    if (message.contains('친구')) people.add('친구');
    if (message.contains('엄마') || message.contains('아빠')) people.add('가족');
    if (people.isNotEmpty) entities['people'] = people;
    
    // 장소
    final places = <String>[];
    if (message.contains('집')) places.add('집');
    if (message.contains('회사') || message.contains('학교')) places.add('직장/학교');
    if (places.isNotEmpty) entities['places'] = places;
    
    return entities;
  }
  
  /// 의도 파악
  String _detectIntent(String message) {
    if (message.contains('?')) return 'question';
    if (message.contains('해줘') || message.contains('하자')) return 'request';
    if (message.contains('었어') || message.contains('았어')) return 'sharing';
    if (message.contains('싶어') || message.contains('려고')) return 'intention';
    return 'statement';
  }
  
  /// 관련성 점수 계산
  double _calculateRelevanceScore(
    MemoryNode memory,
    MemoryContext context,
    String message,
  ) {
    double score = 0;
    
    // 키워드 일치
    for (final keyword in context.keywords) {
      if (memory.context.keywords.contains(keyword)) {
        score += 0.2;
      }
    }
    
    // 주제 일치
    if (memory.context.topic == context.topic) {
      score += 0.3;
    }
    
    // 감정 유사성
    if (memory.context.emotionalTone == context.emotionalTone) {
      score += 0.2;
    }
    
    // 시간 근접성 (최근일수록 높은 점수)
    final daysDiff = DateTime.now().difference(memory.createdAt).inDays;
    if (daysDiff < 1) score += 0.2;
    else if (daysDiff < 7) score += 0.1;
    
    // 중요도 가중치
    score *= (1 + memory.importance / 10);
    
    return score.clamp(0, 1);
  }
  
  /// 연결 타입 결정
  String _determineConnectionType(MemoryContext current, MemoryNode memory) {
    if (current.topic == memory.context.topic) return 'same_topic';
    if (current.emotionalTone == memory.context.emotionalTone) return 'same_emotion';
    if (current.temporalReference != null && 
        current.temporalReference == memory.context.temporalReference) {
      return 'temporal';
    }
    return 'associative';
  }
  
  /// 연결 설명
  String _explainConnection(MemoryContext current, MemoryNode memory) {
    if (current.topic == memory.context.topic) {
      return '같은 주제 (${current.topic})';
    }
    if (current.emotionalTone == memory.context.emotionalTone) {
      return '비슷한 감정 (${current.emotionalTone})';
    }
    
    // 공통 키워드 찾기
    final commonKeywords = current.keywords
        .where((k) => memory.context.keywords.contains(k))
        .toList();
    if (commonKeywords.isNotEmpty) {
      return '관련 키워드: ${commonKeywords.join(', ')}';
    }
    
    return '연관된 맥락';
  }
  
  /// 유사도 계산
  double _calculateSimilarity(MemoryNode m1, MemoryNode m2) {
    double similarity = 0;
    
    // 주제 유사도
    if (m1.context.topic == m2.context.topic) similarity += 0.3;
    
    // 키워드 유사도
    final commonKeywords = m1.context.keywords
        .where((k) => m2.context.keywords.contains(k))
        .length;
    similarity += commonKeywords * 0.1;
    
    // 감정 유사도
    if (m1.context.emotionalTone == m2.context.emotionalTone) similarity += 0.2;
    
    return similarity.clamp(0, 1);
  }
  
  /// 초기 중요도 계산
  double _calculateInitialImportance(MemoryContext context, String message) {
    double importance = 5.0; // 기본값
    
    // 감정이 강한 메시지
    if (context.emotionalTone != 'neutral') importance += 1;
    
    // 질문
    if (context.intent == 'question') importance += 0.5;
    
    // 긴 메시지
    if (message.length > 100) importance += 1;
    
    // 개체 포함
    if (context.entities.isNotEmpty) importance += 0.5;
    
    return importance.clamp(1, 10);
  }
  
  /// 감정 값 계산
  double _calculateEmotionalValence(String tone) {
    switch (tone) {
      case 'positive': return 1.0;
      case 'sad': return -0.5;
      case 'angry': return -0.8;
      case 'anxious': return -0.3;
      default: return 0;
    }
  }
  
  /// 패턴 인식
  List<String> _recognizePatterns(List<MemoryNode> memories) {
    final patterns = <String>[];
    
    // 반복되는 감정 패턴
    final emotions = memories.map((m) => m.context.emotionalTone).toList();
    if (emotions.where((e) => e == 'sad').length > 2) {
      patterns.add('반복되는 슬픔');
    }
    
    // 시간 패턴
    final times = memories.map((m) => m.createdAt.hour).toList();
    if (times.where((t) => t >= 22).length > 3) {
      patterns.add('늦은 밤 대화 선호');
    }
    
    return patterns;
  }
  
  /// 감정 여정 추적
  String _trackEmotionalJourney(List<MemoryNode> memories) {
    if (memories.isEmpty) return '';
    
    final emotions = memories
        .map((m) => m.context.emotionalTone)
        .where((e) => e != 'neutral')
        .toList();
    
    if (emotions.isEmpty) return '';
    
    return emotions.take(3).join(' → ');
  }
  
  /// 반복 주제 찾기
  List<String> _findRecurringTopics(List<MemoryNode> memories) {
    final topicCount = <String, int>{};
    
    for (final memory in memories) {
      topicCount[memory.context.topic] = 
          (topicCount[memory.context.topic] ?? 0) + 1;
    }
    
    return topicCount.entries
        .where((e) => e.value > 1)
        .map((e) => e.key)
        .toList();
  }
  
  /// 시간적 연결 찾기
  List<String> _findTemporalLinks(List<MemoryNode> memories) {
    final links = <String>[];
    
    // 시간 참조가 있는 기억들
    final temporal = memories
        .where((m) => m.context.temporalReference != null)
        .toList();
    
    if (temporal.length > 1) {
      links.add('시간적 연속성 발견');
    }
    
    return links;
  }
  
  /// 전환점 식별
  List<String> _identifyTurningPoints(WorkingMemory memory) {
    final points = <String>[];
    
    final emotions = memory.getRecentEmotions();
    if (emotions.length > 2) {
      // 감정 극적 변화
      if (emotions.contains('positive') && emotions.contains('sad')) {
        points.add('감정 전환점');
      }
    }
    
    return points;
  }
  
  /// 기억 요약
  String _summarizeMemory(MemoryNode memory) {
    final keywords = memory.context.keywords.take(2).join(', ');
    final emotion = memory.context.emotionalTone != 'neutral' 
        ? ' (${memory.context.emotionalTone})' 
        : '';
    return '$keywords 관련$emotion';
  }
}

/// 기억 네트워크
class MemoryNetwork {
  final String userId;
  final Map<String, MemoryNode> memories = {};
  final List<MemoryConnection> connections = [];
  
  MemoryNetwork({required this.userId});
  
  void addMemory(MemoryNode memory) {
    memories[memory.id] = memory;
    
    // 최대 100개 유지
    if (memories.length > 100) {
      // 가장 오래되고 중요도 낮은 것 제거
      final sorted = memories.values.toList()
        ..sort((a, b) {
          final importanceCompare = a.importance.compareTo(b.importance);
          if (importanceCompare != 0) return importanceCompare;
          return a.lastAccessed.compareTo(b.lastAccessed);
        });
      
      final toRemove = sorted.first;
      memories.remove(toRemove.id);
    }
  }
  
  void updateMemory(MemoryNode memory) {
    memories[memory.id] = memory;
  }
  
  void addConnection(MemoryConnection connection) {
    connections.add(connection);
    
    // 최대 200개 연결 유지
    if (connections.length > 200) {
      connections.removeAt(0);
    }
  }
  
  List<MemoryNode> searchByKeyword(String keyword) {
    return memories.values
        .where((m) => m.context.keywords.contains(keyword))
        .toList();
  }
  
  List<MemoryNode> searchByTopic(String topic) {
    return memories.values
        .where((m) => m.context.topic == topic)
        .toList();
  }
  
  List<MemoryNode> searchByEmotion(String emotion) {
    return memories.values
        .where((m) => m.context.emotionalTone == emotion)
        .toList();
  }
  
  List<MemoryNode> searchByTime(String temporal) {
    return memories.values
        .where((m) => m.context.temporalReference == temporal)
        .toList();
  }
}

/// 기억 노드
class MemoryNode {
  final String id;
  final String content;
  final MemoryContext context;
  double importance;
  final DateTime createdAt;
  DateTime lastAccessed;
  int accessCount;
  final double emotionalValence;
  double relevanceScore = 0;
  
  MemoryNode({
    required this.id,
    required this.content,
    required this.context,
    required this.importance,
    required this.createdAt,
    required this.lastAccessed,
    required this.accessCount,
    required this.emotionalValence,
  });
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      'topic': context.topic,
      'emotion': context.emotionalTone,
      'importance': importance,
      'relevanceScore': relevanceScore,
      'accessCount': accessCount,
    };
  }
}

/// 기억 맥락
class MemoryContext {
  final List<String> keywords;
  final String topic;
  final String emotionalTone;
  final String? temporalReference;
  final Map<String, List<String>> entities;
  final String intent;
  final DateTime timestamp;
  final String originalMessage;
  
  MemoryContext({
    required this.keywords,
    required this.topic,
    required this.emotionalTone,
    this.temporalReference,
    required this.entities,
    required this.intent,
    required this.timestamp,
    required this.originalMessage,
  });
}

/// 기억 연결
class MemoryConnection {
  final String fromId;
  final String toId;
  final String type;
  final double strength;
  final String reason;
  
  MemoryConnection({
    required this.fromId,
    required this.toId,
    required this.type,
    required this.strength,
    required this.reason,
  });
  
  Map<String, dynamic> toMap() {
    return {
      'from': fromId,
      'to': toId,
      'type': type,
      'strength': strength,
      'reason': reason,
    };
  }
}

/// 작업 기억
class WorkingMemory {
  final List<MemoryContext> recentContexts = [];
  final List<MemoryNode> associations = [];
  final Map<String, int> topicFrequency = {};
  final List<String> emotionSequence = [];
  
  void addContext(MemoryContext context) {
    recentContexts.add(context);
    
    // 주제 빈도 업데이트
    topicFrequency[context.topic] = (topicFrequency[context.topic] ?? 0) + 1;
    
    // 감정 시퀀스 업데이트
    if (context.emotionalTone != 'neutral') {
      emotionSequence.add(context.emotionalTone);
      if (emotionSequence.length > 10) {
        emotionSequence.removeAt(0);
      }
    }
    
    // 최대 20개 컨텍스트 유지
    if (recentContexts.length > 20) {
      recentContexts.removeAt(0);
    }
  }
  
  void addAssociation(MemoryNode memory) {
    associations.add(memory);
    
    // 최대 10개 연관 유지
    if (associations.length > 10) {
      associations.removeAt(0);
    }
  }
  
  void cleanup() {
    // 30분 이상 지난 컨텍스트 제거
    final cutoff = DateTime.now().subtract(Duration(minutes: 30));
    recentContexts.removeWhere((c) => c.timestamp.isBefore(cutoff));
  }
  
  List<String> getActiveTopics() {
    return topicFrequency.entries
        .where((e) => e.value > 1)
        .map((e) => e.key)
        .toList();
  }
  
  List<String> getRecentEmotions() {
    return emotionSequence.take(3).toList();
  }
  
  Map<String, dynamic> toMap() {
    return {
      'activeTopics': getActiveTopics(),
      'recentEmotions': getRecentEmotions(),
      'contextCount': recentContexts.length,
      'associationCount': associations.length,
    };
  }
}