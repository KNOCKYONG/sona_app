import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/message.dart';
import '../../models/persona.dart';

/// 💭 대화 기억 및 맥락 관리 서비스
/// 
/// 핵심 기능:
/// 1. 중요한 대화 추출 및 요약 (토큰 절약)
/// 2. 관계 발전 히스토리 추적
/// 3. 장기 기억 관리
/// 4. 스마트 컨텍스트 구성
class ConversationMemoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // 컬렉션 이름
  static const String _memoriesCollection = 'conversation_memories';
  static const String _summariesCollection = 'conversation_summaries';
  
  /// 🎯 중요한 대화 추출 및 태깅
  Future<List<ConversationMemory>> extractImportantMemories({
    required List<Message> messages,
    required String userId,
    required String personaId,
  }) async {
    final memories = <ConversationMemory>[];
    
    for (int i = 0; i < messages.length; i++) {
      final message = messages[i];
      final importance = _calculateImportance(message, messages, i);
      
      if (importance >= 0.7) { // 중요도 70% 이상만 저장
        final memory = ConversationMemory(
          id: '${userId}_${personaId}_${message.id}',
          userId: userId,
          personaId: personaId,
          messageId: message.id,
          content: message.content,
          isFromUser: message.isFromUser,
          timestamp: message.timestamp,
          importance: importance,
          tags: _extractTags(message, messages, i),
          emotion: message.emotion ?? EmotionType.neutral,
          relationshipScoreChange: message.relationshipScoreChange ?? 0,
          context: _buildLocalContext(messages, i),
        );
        
        memories.add(memory);
      }
    }
    
    return memories;
  }

  /// 📊 메시지 중요도 계산 (0.0 ~ 1.0)
  double _calculateImportance(Message message, List<Message> allMessages, int index) {
    double importance = 0.0;
    final content = message.content.toLowerCase();
    
    // 1. 감정적 표현 가중치 (0.3)
    if (message.emotion != null && message.emotion != EmotionType.neutral) {
      importance += 0.3;
    }
    
    // 2. 관계 발전 키워드 (0.4)
    final relationshipKeywords = [
      '사랑', '좋아해', '연인', '사귀', '결혼', '평생', '함께', '데이트',
      '미안', '죄송', '화해', '용서', '고마워', '감사',
      '질투', '화나', '싫어', '이별', '헤어져', '그만',
      '첫', '처음', '기념', '특별', '중요', '소중'
    ];
    
    for (final keyword in relationshipKeywords) {
      if (content.contains(keyword)) {
        importance += 0.1;
        if (importance > 0.4) break;
      }
    }
    
    // 3. 점수 변화가 있는 메시지 (0.2)
    if (message.relationshipScoreChange != null && message.relationshipScoreChange! != 0) {
      importance += 0.2;
    }
    
    // 4. 긴 메시지 (더 의미있을 가능성) (0.1)
    if (message.content.length > 50) {
      importance += 0.1;
    }
    
    // 5. 사용자의 개인적 정보 (0.2)
    final personalKeywords = ['가족', '친구', '일', '직장', '학교', '취미', '꿈', '목표'];
    for (final keyword in personalKeywords) {
      if (content.contains(keyword)) {
        importance += 0.05;
        if (importance > 0.2) break;
      }
    }
    
    return importance.clamp(0.0, 1.0);
  }

  /// 🏷️ 메시지에서 태그 추출
  List<String> _extractTags(Message message, List<Message> allMessages, int index) {
    final tags = <String>[];
    final content = message.content.toLowerCase();
    
    // 감정 태그
    if (message.emotion != null) {
      tags.add('emotion_${message.emotion!.name}');
    }
    
    // 관계 발전 태그
    if (content.contains('사랑') || content.contains('좋아해')) tags.add('affection');
    if (content.contains('질투') || content.contains('다른')) tags.add('jealousy');
    if (content.contains('미안') || content.contains('죄송')) tags.add('apology');
    if (content.contains('화나') || content.contains('싫어')) tags.add('conflict');
    if (content.contains('고마워') || content.contains('감사')) tags.add('gratitude');
    if (content.contains('데이트') || content.contains('만나')) tags.add('meeting');
    if (content.contains('첫') || content.contains('처음')) tags.add('first_time');
    
    // 주제 태그
    if (content.contains('가족')) tags.add('family');
    if (content.contains('친구')) tags.add('friends');
    if (content.contains('일') || content.contains('직장')) tags.add('work');
    if (content.contains('취미') || content.contains('좋아하는')) tags.add('hobbies');
    if (content.contains('꿈') || content.contains('목표')) tags.add('dreams');
    
    // 특별한 순간 태그
    if (message.relationshipScoreChange != null && message.relationshipScoreChange! > 5) {
      tags.add('milestone_positive');
    } else if (message.relationshipScoreChange != null && message.relationshipScoreChange! < -5) {
      tags.add('milestone_negative');
    }
    
    return tags;
  }

  /// 📝 로컬 컨텍스트 구성 (전후 메시지 요약)
  String _buildLocalContext(List<Message> messages, int index) {
    final contextMessages = <String>[];
    
    // 이전 2개 메시지
    for (int i = (index - 2).clamp(0, messages.length); i < index; i++) {
      final msg = messages[i];
      contextMessages.add('${msg.isFromUser ? "사용자" : "AI"}: ${msg.content}');
    }
    
    // 다음 2개 메시지  
    for (int i = index + 1; i < (index + 3).clamp(0, messages.length); i++) {
      final msg = messages[i];
      contextMessages.add('${msg.isFromUser ? "사용자" : "AI"}: ${msg.content}');
    }
    
    return contextMessages.join('\n');
  }

  /// 📚 대화 요약 생성 (토큰 절약)
  Future<ConversationSummary> createConversationSummary({
    required List<Message> messages,
    required String userId,
    required String personaId,
    required Persona persona,
  }) async {
    if (messages.isEmpty) {
      return ConversationSummary.empty(userId, personaId);
    }
    
    // 관계 발전 추적
    final relationshipProgression = _trackRelationshipProgression(messages);
    
    // 주요 주제 추출
    final mainTopics = _extractMainTopics(messages);
    
    // 감정 패턴 분석
    final emotionPatterns = _analyzeEmotionPatterns(messages);
    
    // 중요한 순간들 추출
    final milestones = _extractMilestones(messages);
    
    // 개인 정보 추출
    final personalInfo = _extractPersonalInfo(messages);
    
    // 요약 텍스트 생성
    final summaryText = _generateSummaryText(
      relationshipProgression,
      mainTopics,
      milestones,
      personalInfo,
    );
    
    final summary = ConversationSummary(
      id: '${userId}_${personaId}_${DateTime.now().millisecondsSinceEpoch}',
      userId: userId,
      personaId: personaId,
      startDate: messages.first.timestamp,
      endDate: messages.last.timestamp,
      messageCount: messages.length,
      summaryText: summaryText,
      relationshipProgression: relationshipProgression,
      mainTopics: mainTopics,
      emotionPatterns: emotionPatterns,
      milestones: milestones,
      personalInfo: personalInfo,
      currentRelationshipScore: persona.relationshipScore,
    );
    
    return summary;
  }

  /// 📈 관계 발전 과정 추적
  List<RelationshipMilestone> _trackRelationshipProgression(List<Message> messages) {
    final milestones = <RelationshipMilestone>[];
    int currentScore = 50; // 초기 점수
    
    for (final message in messages) {
      final scoreChange = message.relationshipScoreChange ?? 0;
      if (scoreChange != 0) {
        currentScore += scoreChange;
        
        // 중요한 점수 변화만 기록
        if (scoreChange.abs() >= 5) {
          milestones.add(RelationshipMilestone(
            timestamp: message.timestamp,
            scoreChange: scoreChange,
            newScore: currentScore,
            trigger: message.content,
            isFromUser: message.isFromUser,
            emotion: message.emotion ?? EmotionType.neutral,
          ));
        }
      }
    }
    
    return milestones;
  }

  /// 🏷️ 주요 주제 추출
  Map<String, int> _extractMainTopics(List<Message> messages) {
    final topics = <String, int>{};
    
    for (final message in messages) {
      final content = message.content.toLowerCase();
      
      // 주제별 키워드 매칭
      final topicKeywords = {
        '일상': ['일상', '하루', '오늘', '어제', '내일', '지금'],
        '감정': ['기분', '느낌', '감정', '마음', '생각'],
        '취미': ['취미', '좋아하는', '재미있는', '관심', '즐기는'],
        '일/학업': ['일', '직장', '회사', '학교', '공부', '과제'],
        '가족': ['가족', '부모님', '엄마', '아빠', '형', '누나', '동생'],
        '친구': ['친구', '동료', '선배', '후배', '지인'],
        '연애': ['연애', '사랑', '데이트', '만남', '커플', '애인'],
        '미래': ['미래', '꿈', '목표', '계획', '희망', '바람'],
      };
      
      for (final entry in topicKeywords.entries) {
        final topic = entry.key;
        final keywords = entry.value;
        
        for (final keyword in keywords) {
          if (content.contains(keyword)) {
            topics[topic] = (topics[topic] ?? 0) + 1;
            break; // 중복 카운트 방지
          }
        }
      }
    }
    
    return topics;
  }

  /// 😊 감정 패턴 분석
  Map<EmotionType, int> _analyzeEmotionPatterns(List<Message> messages) {
    final patterns = <EmotionType, int>{};
    
    for (final message in messages) {
      if (message.emotion != null) {
        patterns[message.emotion!] = (patterns[message.emotion!] ?? 0) + 1;
      }
    }
    
    return patterns;
  }

  /// 🎯 중요한 순간들 추출
  List<ConversationMilestone> _extractMilestones(List<Message> messages) {
    final milestones = <ConversationMilestone>[];
    
    for (final message in messages) {
      final content = message.content.toLowerCase();
      String? milestoneType;
      
      // 첫 번째 순간들
      if (content.contains('첫') || content.contains('처음')) {
        milestoneType = 'first_time';
      }
      // 고백/사랑 표현
      else if (content.contains('사랑') || content.contains('좋아해')) {
        milestoneType = 'affection_expression';
      }
      // 갈등/화해
      else if (content.contains('미안') || content.contains('용서')) {
        milestoneType = 'reconciliation';
      }
      // 특별한 약속
      else if (content.contains('약속') || content.contains('함께') || content.contains('평생')) {
        milestoneType = 'promise';
      }
      // 큰 점수 변화
      else if (message.relationshipScoreChange != null && 
               message.relationshipScoreChange!.abs() >= 10) {
        milestoneType = 'major_score_change';
      }
      
      if (milestoneType != null) {
        milestones.add(ConversationMilestone(
          type: milestoneType,
          content: message.content,
          timestamp: message.timestamp,
          isFromUser: message.isFromUser,
          emotion: message.emotion ?? EmotionType.neutral,
          scoreChange: message.relationshipScoreChange ?? 0,
        ));
      }
    }
    
    return milestones;
  }

  /// 👤 개인 정보 추출
  Map<String, String> _extractPersonalInfo(List<Message> messages) {
    final personalInfo = <String, String>{};
    
    for (final message in messages) {
      if (!message.isFromUser) continue; // 사용자 메시지만 분석
      
      final content = message.content;
      
      // 간단한 패턴 매칭으로 개인 정보 추출
      final patterns = {
        'name': RegExp(r'내?\s*이름은?\s*([가-힣]+)'),
        'age': RegExp(r'(\d+)살|(\d+)세'),
        'job': RegExp(r'직업은?\s*([가-힣\s]+)'),
        'hobby': RegExp(r'취미는?\s*([가-힣\s]+)'),
        'location': RegExp(r'(\w+)에?\s*살'),
      };
      
      for (final entry in patterns.entries) {
        final key = entry.key;
        final pattern = entry.value;
        final match = pattern.firstMatch(content);
        
        if (match != null && !personalInfo.containsKey(key)) {
          personalInfo[key] = match.group(1) ?? match.group(2) ?? '';
        }
      }
    }
    
    return personalInfo;
  }

  /// 📝 요약 텍스트 생성
  String _generateSummaryText(
    List<RelationshipMilestone> progression,
    Map<String, int> topics,
    List<ConversationMilestone> milestones,
    Map<String, String> personalInfo,
  ) {
    final summary = StringBuffer();
    
    // 관계 발전
    if (progression.isNotEmpty) {
      final startScore = progression.first.newScore - progression.first.scoreChange;
      final endScore = progression.last.newScore;
      summary.writeln('관계 발전: $startScore점 → $endScore점');
    }
    
    // 주요 주제 (상위 3개)
    final sortedTopics = topics.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    if (sortedTopics.isNotEmpty) {
      final topTopics = sortedTopics.take(3).map((e) => e.key).join(', ');
      summary.writeln('주요 대화 주제: $topTopics');
    }
    
    // 중요한 순간들
    if (milestones.isNotEmpty) {
      summary.writeln('특별한 순간: ${milestones.length}개');
    }
    
    // 개인 정보
    if (personalInfo.isNotEmpty) {
      final infoList = personalInfo.entries
          .map((e) => '${e.key}: ${e.value}')
          .join(', ');
      summary.writeln('알게 된 정보: $infoList');
    }
    
    return summary.toString().trim();
  }

  /// 🧠 스마트 컨텍스트 구성 (OpenAI API용)
  Future<String> buildSmartContext({
    required String userId,
    required String personaId,
    required List<Message> recentMessages,
    required Persona persona,
    int maxTokens = 1000,
  }) async {
    final contextParts = <String>[];
    int estimatedTokens = 0;
    
    // 1. 현재 관계 상태 (필수, ~50 tokens)
    final relationshipInfo = '''
친밀도: ${persona.relationshipScore}/1000
대화 스타일: 존댓말
''';
    contextParts.add(relationshipInfo);
    estimatedTokens += 50;
    
    // 2. 저장된 중요한 기억들 (~300 tokens)
    final memories = await _getImportantMemories(userId, personaId, limit: 5);
    if (memories.isNotEmpty) {
      final memoryText = '중요한 기억들:\n' + 
          memories.map((m) => '- ${m.content} (${m.timestamp.month}/${m.timestamp.day})').join('\n');
      if (estimatedTokens + 300 <= maxTokens) {
        contextParts.add(memoryText);
        estimatedTokens += 300;
      }
    }
    
    // 3. 대화 요약 (~200 tokens)
    final summary = await _getLatestSummary(userId, personaId);
    if (summary != null) {
      if (estimatedTokens + 200 <= maxTokens) {
        contextParts.add('대화 요약:\n${summary.summaryText}');
        estimatedTokens += 200;
      }
    }
    
    // 4. 최근 메시지들 (남은 토큰)
    final remainingTokens = maxTokens - estimatedTokens;
    final recentContext = _buildRecentMessagesContext(recentMessages, remainingTokens);
    if (recentContext.isNotEmpty) {
      contextParts.add('최근 대화:\n$recentContext');
    }
    
    return contextParts.join('\n\n');
  }

  /// 📖 저장된 중요한 기억들 가져오기
  Future<List<ConversationMemory>> _getImportantMemories(
    String userId, 
    String personaId, 
    {int limit = 10}
  ) async {
    try {
      final querySnapshot = await _firestore
          .collection(_memoriesCollection)
          .where('userId', isEqualTo: userId)
          .where('personaId', isEqualTo: personaId)
          .orderBy('importance', descending: true)
          .orderBy('timestamp', descending: true)
          .limit(limit)
          .get();

      return querySnapshot.docs
          .map((doc) => ConversationMemory.fromJson(doc.data()))
          .toList();
    } catch (e) {
      debugPrint('Error loading memories: $e');
      return [];
    }
  }

  /// 📚 최신 대화 요약 가져오기
  Future<ConversationSummary?> _getLatestSummary(String userId, String personaId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_summariesCollection)
          .where('userId', isEqualTo: userId)
          .where('personaId', isEqualTo: personaId)
          .orderBy('endDate', descending: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return ConversationSummary.fromJson(querySnapshot.docs.first.data());
      }
    } catch (e) {
      debugPrint('Error loading summary: $e');
    }
    return null;
  }

  /// 📝 최근 메시지 컨텍스트 구성 (토큰 제한)
  String _buildRecentMessagesContext(List<Message> messages, int maxTokens) {
    const avgTokensPerMessage = 30;
    final maxMessages = (maxTokens / avgTokensPerMessage).floor();
    
    final recentMessages = messages.length > maxMessages 
        ? messages.sublist(messages.length - maxMessages)
        : messages;
        
    return recentMessages
        .map((msg) => '${msg.isFromUser ? "사용자" : "AI"}: ${msg.content}')
        .join('\n');
  }


  /// 💾 기억 저장
  Future<void> saveMemories(List<ConversationMemory> memories) async {
    if (memories.isEmpty) return;
    
    try {
      final batch = _firestore.batch();
      
      for (final memory in memories) {
        final docRef = _firestore.collection(_memoriesCollection).doc(memory.id);
        batch.set(docRef, memory.toJson());
      }
      
      await batch.commit();
      debugPrint('💾 Saved ${memories.length} conversation memories');
    } catch (e) {
      debugPrint('Error saving memories: $e');
    }
  }

  /// 📚 요약 저장
  Future<void> saveSummary(ConversationSummary summary) async {
    try {
      await _firestore
          .collection(_summariesCollection)
          .doc(summary.id)
          .set(summary.toJson());
      
      debugPrint('📚 Saved conversation summary: ${summary.id}');
    } catch (e) {
      debugPrint('Error saving summary: $e');
    }
  }
}

/// 💭 대화 기억 모델
class ConversationMemory {
  final String id;
  final String userId;
  final String personaId;
  final String messageId;
  final String content;
  final bool isFromUser;
  final DateTime timestamp;
  final double importance;
  final List<String> tags;
  final EmotionType emotion;
  final int relationshipScoreChange;
  final String context;

  ConversationMemory({
    required this.id,
    required this.userId,
    required this.personaId,
    required this.messageId,
    required this.content,
    required this.isFromUser,
    required this.timestamp,
    required this.importance,
    required this.tags,
    required this.emotion,
    required this.relationshipScoreChange,
    required this.context,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'personaId': personaId,
    'messageId': messageId,
    'content': content,
    'isFromUser': isFromUser,
    'timestamp': timestamp.toIso8601String(),
    'importance': importance,
    'tags': tags,
    'emotion': emotion.name,
    'relationshipScoreChange': relationshipScoreChange,
    'context': context,
  };

  factory ConversationMemory.fromJson(Map<String, dynamic> json) => ConversationMemory(
    id: json['id'],
    userId: json['userId'],
    personaId: json['personaId'],
    messageId: json['messageId'],
    content: json['content'],
    isFromUser: json['isFromUser'],
    timestamp: DateTime.parse(json['timestamp']),
    importance: json['importance'].toDouble(),
    tags: List<String>.from(json['tags']),
    emotion: EmotionType.values.firstWhere(
      (e) => e.name == json['emotion'],
      orElse: () => EmotionType.neutral,
    ),
    relationshipScoreChange: json['relationshipScoreChange'],
    context: json['context'],
  );
}

/// 📚 대화 요약 모델
class ConversationSummary {
  final String id;
  final String userId;
  final String personaId;
  final DateTime startDate;
  final DateTime endDate;
  final int messageCount;
  final String summaryText;
  final List<RelationshipMilestone> relationshipProgression;
  final Map<String, int> mainTopics;
  final Map<EmotionType, int> emotionPatterns;
  final List<ConversationMilestone> milestones;
  final Map<String, String> personalInfo;
  final int currentRelationshipScore;

  ConversationSummary({
    required this.id,
    required this.userId,
    required this.personaId,
    required this.startDate,
    required this.endDate,
    required this.messageCount,
    required this.summaryText,
    required this.relationshipProgression,
    required this.mainTopics,
    required this.emotionPatterns,
    required this.milestones,
    required this.personalInfo,
    required this.currentRelationshipScore,
  });

  factory ConversationSummary.empty(String userId, String personaId) => ConversationSummary(
    id: '${userId}_${personaId}_empty',
    userId: userId,
    personaId: personaId,
    startDate: DateTime.now(),
    endDate: DateTime.now(),
    messageCount: 0,
    summaryText: '소나와 친구처럼 대화를 시작해보세요!',
    relationshipProgression: [],
    mainTopics: {},
    emotionPatterns: {},
    milestones: [],
    personalInfo: {},
    currentRelationshipScore: 50,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'personaId': personaId,
    'startDate': startDate.toIso8601String(),
    'endDate': endDate.toIso8601String(),
    'messageCount': messageCount,
    'summaryText': summaryText,
    'relationshipProgression': relationshipProgression.map((r) => r.toJson()).toList(),
    'mainTopics': mainTopics,
    'emotionPatterns': emotionPatterns.map((k, v) => MapEntry(k.name, v)),
    'milestones': milestones.map((m) => m.toJson()).toList(),
    'personalInfo': personalInfo,
    'currentRelationshipScore': currentRelationshipScore,
  };

  factory ConversationSummary.fromJson(Map<String, dynamic> json) => ConversationSummary(
    id: json['id'],
    userId: json['userId'],
    personaId: json['personaId'],
    startDate: DateTime.parse(json['startDate']),
    endDate: DateTime.parse(json['endDate']),
    messageCount: json['messageCount'],
    summaryText: json['summaryText'],
    relationshipProgression: (json['relationshipProgression'] as List)
        .map((r) => RelationshipMilestone.fromJson(r))
        .toList(),
    mainTopics: Map<String, int>.from(json['mainTopics']),
    emotionPatterns: Map<EmotionType, int>.fromEntries(
      (json['emotionPatterns'] as Map<String, dynamic>).entries.map(
        (e) => MapEntry(
          EmotionType.values.firstWhere((v) => v.name == e.key),
          e.value,
        ),
      ),
    ),
    milestones: (json['milestones'] as List)
        .map((m) => ConversationMilestone.fromJson(m))
        .toList(),
    personalInfo: Map<String, String>.from(json['personalInfo']),
    currentRelationshipScore: json['currentRelationshipScore'],
  );
}

/// 📈 관계 발전 이정표
class RelationshipMilestone {
  final DateTime timestamp;
  final int scoreChange;
  final int newScore;
  final String trigger;
  final bool isFromUser;
  final EmotionType emotion;

  RelationshipMilestone({
    required this.timestamp,
    required this.scoreChange,
    required this.newScore,
    required this.trigger,
    required this.isFromUser,
    required this.emotion,
  });

  Map<String, dynamic> toJson() => {
    'timestamp': timestamp.toIso8601String(),
    'scoreChange': scoreChange,
    'newScore': newScore,
    'trigger': trigger,
    'isFromUser': isFromUser,
    'emotion': emotion.name,
  };

  factory RelationshipMilestone.fromJson(Map<String, dynamic> json) => RelationshipMilestone(
    timestamp: DateTime.parse(json['timestamp']),
    scoreChange: json['scoreChange'],
    newScore: json['newScore'],
    trigger: json['trigger'],
    isFromUser: json['isFromUser'],
    emotion: EmotionType.values.firstWhere(
      (e) => e.name == json['emotion'],
      orElse: () => EmotionType.neutral,
    ),
  );
}

/// 🎯 대화 이정표
class ConversationMilestone {
  final String type;
  final String content;
  final DateTime timestamp;
  final bool isFromUser;
  final EmotionType emotion;
  final int scoreChange;

  ConversationMilestone({
    required this.type,
    required this.content,
    required this.timestamp,
    required this.isFromUser,
    required this.emotion,
    required this.scoreChange,
  });

  Map<String, dynamic> toJson() => {
    'type': type,
    'content': content,
    'timestamp': timestamp.toIso8601String(),
    'isFromUser': isFromUser,
    'emotion': emotion.name,
    'scoreChange': scoreChange,
  };

  factory ConversationMilestone.fromJson(Map<String, dynamic> json) => ConversationMilestone(
    type: json['type'],
    content: json['content'],
    timestamp: DateTime.parse(json['timestamp']),
    isFromUser: json['isFromUser'],
    emotion: EmotionType.values.firstWhere(
      (e) => e.name == json['emotion'],
      orElse: () => EmotionType.neutral,
    ),
    scoreChange: json['scoreChange'],
  );
} 