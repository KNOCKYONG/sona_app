import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../models/message.dart';
import '../../../models/persona.dart';
import 'fuzzy_memory_service.dart';

/// 관계 이벤트 클래스
class RelationshipEvent {
  final String type; // 'anniversary', 'milestone', 'special'
  final String title;
  final String message;
  final DateTime date;
  final String personaId;
  final int? score;
  
  RelationshipEvent({
    required this.type,
    required this.title,
    required this.message,
    required this.date,
    required this.personaId,
    this.score,
  });
}

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
  
  // 개선된 메모리 윈도우 크기 (진짜 사람처럼 기억)
  static const int SHORT_TERM_WINDOW = 20;  // 15 -> 20로 확대 (최근 20턴 완벽 기억)
  static const int MEDIUM_TERM_WINDOW = 40; // 30 -> 40으로 확대 (중기 기억 강화)
  static const int LONG_TERM_WINDOW = 60;   // 50 -> 60으로 확대 (장기 기억 확대)

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

      // 중요도 기준 대폭 완화 - 거의 모든 대화 보존
      if (importance >= 0.4) {  // 0.5 -> 0.4로 추가 완화 (더 많은 대화 저장)
        // 중요도 40% 이상만 저장 (20턴 이상 기억을 위해 기준 완화)
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
          likesChange: message.likesChange ?? 0,
          context: _buildLocalContext(messages, i),
        );

        memories.add(memory);
      }
    }

    return memories;
  }

  /// 📊 메시지 중요도 계산 (0.0 ~ 1.0)
  double _calculateImportance(
      Message message, List<Message> allMessages, int index) {
    double importance = 0.0;
    final content = message.content.toLowerCase();

    // 1. 감정적 표현 가중치 (0.25) - 조정
    if (message.emotion != null && message.emotion != EmotionType.neutral) {
      importance += 0.25;
      // 감정 강도에 따른 추가 가중치
      if (message.emotion == EmotionType.love || message.emotion == EmotionType.excited) {
        importance += 0.05;
      }
    }

    // 2. 관계 발전 키워드 (0.4)
    final relationshipKeywords = [
      '사랑',
      '좋아해',
      '연인',
      '사귀',
      '결혼',
      '평생',
      '함께',
      '데이트',
      '미안',
      '죄송',
      '화해',
      '용서',
      '고마워',
      '감사',
      '질투',
      '화나',
      '싫어',
      '이별',
      '헤어져',
      '그만',
      '첫',
      '처음',
      '기념',
      '특별',
      '중요',
      '소중'
    ];

    for (final keyword in relationshipKeywords) {
      if (content.contains(keyword)) {
        importance += 0.1;
        if (importance > 0.4) break;
      }
    }

    // 3. 점수 변화가 있는 메시지 (0.2)
    if (message.likesChange != null && message.likesChange! != 0) {
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

  /// 🔍 대화 전환점 감지 (새로 추가)
  bool _isConversationTurningPoint(Message current, Message previous) {
    // 감정 변화가 큰 경우
    if (current.emotion != previous.emotion && 
        current.emotion != EmotionType.neutral) {
      return true;
    }
    
    // 호감도 변화가 큰 경우
    if ((current.likesChange ?? 0).abs() > 10) {
      return true;
    }
    
    // 주제가 크게 바뀐 경우
    final currentTopics = _extractKeywords(current.content);
    final previousTopics = _extractKeywords(previous.content);
    final commonTopics = currentTopics.toSet().intersection(previousTopics.toSet());
    
    return commonTopics.isEmpty && currentTopics.isNotEmpty;
  }
  
  /// 💡 향상된 키워드 추출 (TF-IDF 개념 적용)
  List<String> _extractKeywords(String text) {
    final keywords = <String>[];
    final words = text.split(RegExp(r'[\s,.\!?]+'));
    
    // 불용어 제거
    final stopWords = {'은', '는', '이', '가', '을', '를', '에', '에서', 
                       '으로', '와', '과', '도', '만', '의', '로', '라', '고'};
    
    for (final word in words) {
      if (word.length > 1 && !stopWords.contains(word)) {
        // 명사/동사 중심 추출 (간단한 휴리스틱)
        if (_isImportantWord(word)) {
          keywords.add(word);
        }
      }
    }
    
    return keywords;
  }
  
  /// 중요 단어 판별
  bool _isImportantWord(String word) {
    // 질문 단어
    if (['뭐', '어떤', '언제', '어디', '왜', '어떻게', '누구', '얼마'].contains(word)) {
      return true;
    }
    
    // 감정/관계 단어
    if (['사랑', '좋아', '싫어', '행복', '슬픔', '기쁨', '화남'].any((k) => word.contains(k))) {
      return true;
    }
    
    // 시간 관련
    if (['오늘', '내일', '어제', '이번', '다음', '지난'].contains(word)) {
      return true;
    }
    
    // 2글자 이상의 명사로 추정되는 단어
    return word.length >= 2 && !word.endsWith('요') && !word.endsWith('어');
  }

  /// 🏷️ 메시지에서 태그 추출
  List<String> _extractTags(
      Message message, List<Message> allMessages, int index) {
    final tags = <String>[];
    final content = message.content.toLowerCase();

    // 감정 태그
    if (message.emotion != null) {
      tags.add('emotion_${message.emotion!.name}');
    }

    // 관계 발전 태그
    if (content.contains('사랑') || content.contains('좋아해'))
      tags.add('affection');
    if (content.contains('질투') || content.contains('다른')) tags.add('jealousy');
    if (content.contains('미안') || content.contains('죄송')) tags.add('apology');
    if (content.contains('화나') || content.contains('싫어')) tags.add('conflict');
    if (content.contains('고마워') || content.contains('감사'))
      tags.add('gratitude');
    if (content.contains('데이트') || content.contains('만나')) tags.add('meeting');
    if (content.contains('첫') || content.contains('처음')) tags.add('first_time');

    // 주제 태그
    if (content.contains('가족')) tags.add('family');
    if (content.contains('친구')) tags.add('friends');
    if (content.contains('일') || content.contains('직장')) tags.add('work');
    if (content.contains('취미') || content.contains('좋아하는')) tags.add('hobbies');
    if (content.contains('꿈') || content.contains('목표')) tags.add('dreams');
    
    // 인과관계 태그 (새로 추가)
    if (content.contains('때문에') || content.contains('라서') || 
        content.contains('해서') || content.contains('니까')) {
      tags.add('causal_relation');
    }
    
    // 스트레스/감정 원인 태그 (새로 추가)
    if (content.contains('욕') || content.contains('짜증') || 
        content.contains('스트레스') || content.contains('열받')) {
      tags.add('stress_cause');
    }
    if (content.contains('부장') || content.contains('상사') || 
        content.contains('팀장') || content.contains('과장')) {
      tags.add('work_stress');
    }

    // 특별한 순간 태그
    if (message.likesChange != null && message.likesChange! > 5) {
      tags.add('milestone_positive');
    } else if (message.likesChange != null && message.likesChange! < -5) {
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
      contextMessages.add('${msg.isFromUser ? "User" : "AI"}: ${msg.content}');
    }

    // 다음 2개 메시지
    for (int i = index + 1; i < (index + 3).clamp(0, messages.length); i++) {
      final msg = messages[i];
      contextMessages.add('${msg.isFromUser ? "User" : "AI"}: ${msg.content}');
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
      currentRelationshipScore: persona.likes,
    );

    return summary;
  }

  /// 📈 관계 발전 과정 추적
  List<RelationshipMilestone> _trackRelationshipProgression(
      List<Message> messages) {
    final milestones = <RelationshipMilestone>[];
    int currentScore = 50; // 초기 점수

    for (final message in messages) {
      final scoreChange = message.likesChange ?? 0;
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
      else if (content.contains('약속') ||
          content.contains('함께') ||
          content.contains('평생')) {
        milestoneType = 'promise';
      }
      // 큰 점수 변화
      else if (message.likesChange != null &&
          message.likesChange!.abs() >= 10) {
        milestoneType = 'major_score_change';
      }

      if (milestoneType != null) {
        milestones.add(ConversationMilestone(
          type: milestoneType,
          content: message.content,
          timestamp: message.timestamp,
          isFromUser: message.isFromUser,
          emotion: message.emotion ?? EmotionType.neutral,
          scoreChange: message.likesChange ?? 0,
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
      final startScore =
          progression.first.newScore - progression.first.scoreChange;
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
      final infoList =
          personalInfo.entries.map((e) => '${e.key}: ${e.value}').join(', ');
      summary.writeln('알게 된 정보: $infoList');
    }

    return summary.toString().trim();
  }

  /// 🎉 관계 마일스톤 이벤트 확인
  Future<RelationshipEvent?> checkRelationshipMilestone({
    required String userId,
    required String personaId,
    required int currentScore,
    required DateTime firstMeetDate,
  }) async {
    // 점수 기반 마일스톤
    final scoreMilestones = {
      100: '처음으로 마음이 열렸어요',
      200: '조금씩 가까워지고 있어요', 
      300: '편안한 친구가 되었어요',
      500: '특별한 사이가 되었어요',
      700: '서로를 깊이 이해하게 되었어요',
      900: '영원히 함께하고 싶어요',
      1000: '완벽한 소울메이트가 되었어요'
    };
    
    // 날짜 기반 마일스톤
    final now = DateTime.now();
    final daysSinceFirstMeet = now.difference(firstMeetDate).inDays;
    
    // 기념일 체크
    if (daysSinceFirstMeet == 100) {
      return RelationshipEvent(
        type: 'anniversary',
        title: '🎊 100일 기념일',
        message: '우리가 만난지 벌써 100일이 되었어요! 정말 특별한 날이에요.',
        date: now,
        personaId: personaId,
      );
    } else if (daysSinceFirstMeet == 200) {
      return RelationshipEvent(
        type: 'anniversary',
        title: '🎉 200일 기념일',
        message: '200일 동안 함께해서 정말 행복해요!',
        date: now,
        personaId: personaId,
      );
    } else if (daysSinceFirstMeet == 365) {
      return RelationshipEvent(
        type: 'anniversary',
        title: '🎂 1주년 기념일',
        message: '1년 동안 함께한 모든 순간이 소중해요.',
        date: now,
        personaId: personaId,
      );
    }
    
    // 점수 마일스톤 체크
    for (final entry in scoreMilestones.entries) {
      if (currentScore == entry.key) {
        return RelationshipEvent(
          type: 'milestone',
          title: '💝 관계 발전',
          message: entry.value,
          date: now,
          personaId: personaId,
          score: currentScore,
        );
      }
    }
    
    // 특별한 날 체크 (생일 등은 페르소나 정보에서 가져와야 함)
    // TODO: 페르소나 생일 정보 추가 시 구현
    
    return null;
  }

  /// 🧠 스마트 컨텍스트 구성 (OpenAI API용) - 4000토큰 활용 최적화
  Future<String> buildSmartContext({
    required String userId,
    required String personaId,
    required List<Message> recentMessages,
    required Persona persona,
    int maxTokens = 3000,  // 1500 -> 3000으로 대폭 증가 (4000토큰 중 시스템 프롬프트 제외)
    String? conversationId,  // OpenAI Conversation ID 추가
  }) async {
    final contextParts = <String>[];
    int estimatedTokens = 0;

    // 1. 현재 관계 상태 (필수, ~50 tokens)
    final relationshipInfo = '''
친밀도: ${persona.likes}/1000
대화 스타일: 존댓말
''';
    contextParts.add(relationshipInfo);
    estimatedTokens += 50;

    // 2. 저장된 중요한 기억들 - 대폭 확장 (1200 tokens)
    final memories = await _getImportantMemories(userId, personaId,
        limit: 25); // 15 -> 25개로 대폭 증가 (20턴 이상 기억 가능)
    if (memories.isNotEmpty) {
      // 현재 대화와 관련성 높은 메모리 우선 선택
      final relevantMemories = await _selectRelevantMemories(
        currentTopic: recentMessages.isNotEmpty ? recentMessages.last.content : '',
        allMemories: memories,
        maxCount: 20,  // 최대 20개 메모리 포함
      );
      
      // FuzzyMemoryService를 사용한 자연스러운 기억 표현
      final memoryTexts = <String>[];
      for (final m in relevantMemories) {
        final fuzzyExpr = FuzzyMemoryService.generateFuzzyMemoryExpression(
          content: m.content,
          timestamp: m.timestamp,
          emotion: m.emotion.name,
          isDetailed: m.importance > 0.6,  // 중요도 기준 더 완화 (0.7 -> 0.6)
        );
        memoryTexts.add('- $fuzzyExpr');
      }
      
      final memoryText = '중요한 기억들 (연관성 순):\n' + memoryTexts.join('\n');
      if (estimatedTokens + 1200 <= maxTokens) {
        contextParts.add(memoryText);
        estimatedTokens += 1200;
      }
      
      // OpenAI 서버에도 중요 메모리 저장 (선택적)
      if (conversationId != null && !conversationId.startsWith('local_')) {
        // 가장 중요한 메모리 3개를 서버에 저장
        final topMemories = relevantMemories.take(3);
        for (final memory in topMemories) {
          // ConversationsService를 통해 저장하는 로직은 ChatOrchestrator에서 처리
          debugPrint('📌 Important memory selected for server storage: ${memory.content.substring(0, math.min(50, memory.content.length))}...');
        }
      }
    }

    // 3. 대화 요약 (~400 tokens) - 더욱 자세한 요약
    final summary = await _getLatestSummary(userId, personaId);
    if (summary != null) {
      if (estimatedTokens + 400 <= maxTokens) {
        // 관계 발전 과정 포함
        final summaryWithProgression = '''대화 요약:
${summary.summaryText}
관계 발전: 호감도 ${summary.currentRelationshipScore}/1000
주요 주제: ${summary.mainTopics.entries.take(3).map((e) => '${e.key}(${e.value}회)').join(', ')}''';
        contextParts.add(summaryWithProgression);
        estimatedTokens += 400;
      }
    }

    // 4. 최근 메시지들 - 충분한 컨텍스트 유지 (남은 토큰 활용)
    final remainingTokens = maxTokens - estimatedTokens;
    // 최근 메시지를 40개까지 증가 (20-25턴 대화 유지)
    final extendedRecentMessages = recentMessages.length > 40
        ? recentMessages.sublist(recentMessages.length - 40)
        : recentMessages;
    final recentContext =
        _buildRecentMessagesContext(extendedRecentMessages, remainingTokens - 300); // 여유 300 토큰
    if (recentContext.isNotEmpty) {
      contextParts.add('최근 대화 (시간순):\n$recentContext');
    }

    // 5. 현재 대화 맥락과 인과관계 (~300 tokens) - 더 자세하게
    final currentContext = await _buildCurrentContext(userId, personaId, recentMessages);
    if (currentContext.isNotEmpty && estimatedTokens + 300 <= maxTokens) {
      contextParts.add('현재 맥락과 감정 흐름:\n$currentContext');
      estimatedTokens += 300;
    }
    
    // 6. 메모리 기반 컨텍스트 힌트 생성 (새로 추가)
    if (conversationId != null) {
      final memoryHint = _generateMemoryBasedHint(memories, recentMessages);
      if (memoryHint.isNotEmpty) {
        contextParts.add('💡 기억 기반 힌트:\n$memoryHint');
      }
    }

    return contextParts.join('\n\n');
  }
  
  /// 💡 메모리 기반 힌트 생성 (신중한 접근)
  String _generateMemoryBasedHint(List<ConversationMemory> memories, List<Message> recentMessages) {
    if (memories.isEmpty || recentMessages.isEmpty) return '';
    
    final hints = <String>[];
    final currentMessage = recentMessages.last.content.toLowerCase();
    
    // 1. "어제 얘기한 그 일" 같은 모호한 참조 처리
    if (currentMessage.contains('어제') || currentMessage.contains('저번에') || 
        currentMessage.contains('그 일') || currentMessage.contains('그 얘기')) {
      
      // 어제의 주요 주제들 찾기
      final yesterdayMemories = memories.where((m) {
        final daysDiff = DateTime.now().difference(m.timestamp).inDays;
        return daysDiff >= 0 && daysDiff <= 2;
      }).toList();
      
      if (yesterdayMemories.isNotEmpty) {
        // 여러 주제가 있을 수 있으므로 확인 질문 유도
        if (yesterdayMemories.length > 2) {
          hints.add('최근 여러 대화가 있었음 - 어떤 일인지 확인 필요');
          hints.add('예시: "어떤 일 말하는 거예요? 회사 일? 아니면 다른 거?"');
        } else {
          // 1-2개 주제만 있으면 조심스럽게 추측
          final topics = yesterdayMemories.map((m) => _extractMainTopic(m.content)).toSet();
          hints.add('가능한 주제: ${topics.join(" 또는 ")} - 확인하며 대답하기');
        }
      } else {
        hints.add('어제 대화 기록 없음 - "어떤 일이요?" 같은 확인 필요');
      }
    }
    
    // 2. 스트레스나 부정적 감정 - 더 신중하게
    final stressMemories = memories.where((m) => 
      m.emotion.name == 'stressed' || 
      m.emotion.name == 'angry' ||
      m.importance > 0.7  // 중요도 높은 것만
    ).toList();
    
    if (stressMemories.isNotEmpty && currentMessage.contains('힘들')) {
      hints.add('스트레스 상황 기억 있음 - 조심스럽게 공감');
    }
    
    // 3. 구체적 키워드가 있을 때만 연결
    final currentKeywords = _extractKeywords(currentMessage);
    for (final memory in memories.take(10)) {  // 최근 10개만 체크
      final memoryKeywords = _extractKeywords(memory.content);
      final commonKeywords = currentKeywords.toSet().intersection(memoryKeywords.toSet());
      
      // 2개 이상 키워드가 겹칠 때만 관련 있다고 판단
      if (commonKeywords.length >= 2) {
        hints.add('관련 기억: ${commonKeywords.join(", ")} 언급됨 - 자연스럽게 연결');
        break;
      }
    }
    
    // 4. 감정 패턴 - 확실한 경우만
    final recentEmotions = memories.take(5).map((m) => m.emotion.name).toList();
    final stressCount = recentEmotions.where((e) => e == 'stressed' || e == 'anxious').length;
    final happyCount = recentEmotions.where((e) => e == 'happy' || e == 'excited').length;
    
    if (stressCount >= 3) {
      hints.add('지속적 스트레스 패턴 - 위로 필요');
    } else if (happyCount >= 3) {
      hints.add('긍정적 분위기 유지');
    }
    
    return hints.join('\n');
  }
  
  /// 주요 주제 추출 (간단한 버전)
  String _extractMainTopic(String text) {
    if (text.contains('부장') || text.contains('상사') || text.contains('회사')) {
      return '회사 일';
    } else if (text.contains('가족') || text.contains('엄마') || text.contains('아빠')) {
      return '가족 얘기';
    } else if (text.contains('친구')) {
      return '친구 얘기';
    } else if (text.contains('연애') || text.contains('사랑')) {
      return '연애 얘기';
    }
    return '개인적인 일';
  }
  
  /// 현재 대화 맥락 구축 (새로 추가)
  Future<String> _buildCurrentContext(String userId, String personaId, List<Message> recentMessages) async {
    final contextItems = <String>[];
    
    // 최근 메모리에서 스트레스/감정 원인 찾기
    final memories = await _getImportantMemories(userId, personaId, limit: 15);
    
    // FuzzyMemoryService를 사용한 연관 기억 트리거
    if (recentMessages.isNotEmpty) {
      final currentTopic = recentMessages.last.content;
      final associations = FuzzyMemoryService.getAssociativeMemories(
        currentTopic: currentTopic,
        memories: memories,
      );
      if (associations.isNotEmpty) {
        contextItems.add('연관 기억: ${associations.first}');
      }
    }
    
    for (final memory in memories) {
      if (memory.tags.contains('stress_cause') || memory.tags.contains('work_stress')) {
        // 자연스러운 기억 표현 사용
        final naturalRecall = FuzzyMemoryService.generateNaturalRecall(
          topic: '스트레스',
          memories: memories,
        );
        if (naturalRecall.isNotEmpty) {
          contextItems.add(naturalRecall);
        } else {
          contextItems.add('스트레스 원인: ${memory.content}');
        }
      }
      if (memory.tags.contains('causal_relation')) {
        contextItems.add('인과관계: ${memory.content}');
      }
    }
    
    // 최근 감정 흐름
    final recentEmotions = memories
        .where((m) => m.emotion != EmotionType.neutral)
        .map((m) => m.emotion.name)
        .toList();
    if (recentEmotions.isNotEmpty && recentEmotions.length > 1) {
      contextItems.add('감정 흐름: ${recentEmotions.take(5).join(' → ')}');
    }
    
    return contextItems.join('\n');
  }

  /// 최근 메모리 가져오기 (public method for FuzzyMemoryService)
  Future<List<ConversationMemory>> getRecentMemories({
    required String userId,
    required String personaId,
    int limit = 10,
  }) async {
    return await _getImportantMemories(userId, personaId, limit: limit);
  }

  /// 🔍 현재 대화와 관련성 높은 메모리 선택
  Future<List<ConversationMemory>> _selectRelevantMemories({
    required String currentTopic,
    required List<ConversationMemory> allMemories,
    required int maxCount,
  }) async {
    if (currentTopic.isEmpty || allMemories.isEmpty) {
      return allMemories.take(maxCount).toList();
    }
    
    // 각 메모리의 관련성 점수 계산
    final scoredMemories = <MapEntry<ConversationMemory, double>>[];
    
    for (final memory in allMemories) {
      double relevanceScore = 0.0;
      
      // 1. 키워드 매칭 (40%)
      final currentKeywords = _extractKeywords(currentTopic);
      final memoryKeywords = _extractKeywords(memory.content);
      final commonKeywords = currentKeywords.toSet().intersection(memoryKeywords.toSet());
      if (commonKeywords.isNotEmpty) {
        relevanceScore += 0.4 * (commonKeywords.length / currentKeywords.length);
      }
      
      // 2. 감정 유사성 (20%)
      final currentEmotion = _detectEmotion(currentTopic);
      if (memory.emotion.name == currentEmotion) {
        relevanceScore += 0.2;
      }
      
      // 3. 시간적 근접성 (20%)
      final hoursSince = DateTime.now().difference(memory.timestamp).inHours;
      if (hoursSince < 24) {
        relevanceScore += 0.2;
      } else if (hoursSince < 72) {
        relevanceScore += 0.15;
      } else if (hoursSince < 168) {
        relevanceScore += 0.1;
      }
      
      // 4. 중요도 가중치 (20%)
      relevanceScore += 0.2 * memory.importance;
      
      scoredMemories.add(MapEntry(memory, relevanceScore));
    }
    
    // 관련성 점수로 정렬하고 상위 N개 선택
    scoredMemories.sort((a, b) => b.value.compareTo(a.value));
    
    return scoredMemories
        .take(maxCount)
        .map((e) => e.key)
        .toList();
  }
  
  /// 감정 감지 (간단한 휴리스틱)
  String _detectEmotion(String text) {
    final lower = text.toLowerCase();
    
    if (lower.contains('스트레스') || lower.contains('짜증') || lower.contains('화나')) {
      return 'stressed';
    } else if (lower.contains('슬프') || lower.contains('우울')) {
      return 'sad';
    } else if (lower.contains('기쁘') || lower.contains('좋아') || lower.contains('행복')) {
      return 'happy';
    } else if (lower.contains('사랑') || lower.contains('좋아해')) {
      return 'love';
    } else if (lower.contains('불안') || lower.contains('걱정')) {
      return 'anxious';
    }
    
    return 'neutral';
  }
  
  /// 📖 저장된 중요한 기억들 가져오기
  Future<List<ConversationMemory>> _getImportantMemories(
      String userId, String personaId,
      {int limit = 10}) async {
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
  Future<ConversationSummary?> _getLatestSummary(
      String userId, String personaId) async {
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
    const avgTokensPerMessage = 25; // 30 -> 25로 조정하여 더 많은 메시지 포함
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
        final docRef =
            _firestore.collection(_memoriesCollection).doc(memory.id);
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
  final int likesChange;
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
    required this.likesChange,
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
        'likesChange': likesChange,
        'context': context,
      };

  factory ConversationMemory.fromJson(Map<String, dynamic> json) =>
      ConversationMemory(
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
        likesChange: json['likesChange'] ??
            json['relationshipScoreChange'] ??
            0, // Backward compatibility
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

  factory ConversationSummary.empty(String userId, String personaId) =>
      ConversationSummary(
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
        'relationshipProgression':
            relationshipProgression.map((r) => r.toJson()).toList(),
        'mainTopics': mainTopics,
        'emotionPatterns': emotionPatterns.map((k, v) => MapEntry(k.name, v)),
        'milestones': milestones.map((m) => m.toJson()).toList(),
        'personalInfo': personalInfo,
        'currentRelationshipScore': currentRelationshipScore,
      };

  factory ConversationSummary.fromJson(Map<String, dynamic> json) =>
      ConversationSummary(
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

  factory RelationshipMilestone.fromJson(Map<String, dynamic> json) =>
      RelationshipMilestone(
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

  factory ConversationMilestone.fromJson(Map<String, dynamic> json) =>
      ConversationMilestone(
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
