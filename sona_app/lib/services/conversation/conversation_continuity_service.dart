import 'package:flutter/material.dart';
import '../../models/message.dart';

/// 답변받지 못한 질문
class UnansweredQuestion {
  final String question;
  final DateTime timestamp;
  final String topic;
  final int importance; // 1-5
  
  UnansweredQuestion({
    required this.question,
    required this.timestamp,
    required this.topic,
    this.importance = 3,
  });
}

/// 대화 주제
class ConversationTopic {
  final String topic;
  final DateTime timestamp;
  final int messageCount;
  final double engagementScore; // 0.0-1.0
  
  ConversationTopic({
    required this.topic,
    required this.timestamp,
    required this.messageCount,
    required this.engagementScore,
  });
}

/// 사용자 관심사
class UserInterests {
  final Map<String, int> topicFrequency; // 주제별 언급 횟수
  final List<String> favoriteTopics;
  final List<String> recentTopics;
  final DateTime lastUpdated;
  
  UserInterests({
    required this.topicFrequency,
    required this.favoriteTopics,
    required this.recentTopics,
    required this.lastUpdated,
  });
}

/// 💬 대화 지속성 강화 서비스
///
/// 자연스러운 대화 흐름을 유지하고 대화가 끊기지 않도록 지원합니다.
class ConversationContinuityService {
  
  // 답변받지 못한 질문들 저장
  static final Map<String, List<UnansweredQuestion>> _unansweredQuestions = {};
  
  // 대화 주제 히스토리
  static final Map<String, List<ConversationTopic>> _topicHistory = {};
  
  // 사용자 관심사
  static final Map<String, UserInterests> _userInterests = {};
  
  
  /// 대화 분석 및 지속성 가이드 생성
  static Map<String, dynamic> analyzeContinuity({
    required String userId,
    required String personaId,
    required String userMessage,
    required List<Message> chatHistory,
  }) {
    final key = '${userId}_$personaId';
    
    // 1. 답변받지 못한 질문 체크
    final unansweredQuestions = _checkUnansweredQuestions(key, userMessage, chatHistory);
    
    // 2. 주제 연속성 분석
    final topicContinuity = _analyzeTopicContinuity(key, userMessage, chatHistory);
    
    // 3. 관심사 업데이트
    _updateUserInterests(key, userMessage);
    
    // 4. 대화 이어가기 전략 생성
    final continuationStrategy = _generateContinuationStrategy(
      userMessage: userMessage,
      chatHistory: chatHistory,
      unansweredQuestions: unansweredQuestions,
      topicContinuity: topicContinuity,
    );
    
    return {
      'unansweredQuestions': unansweredQuestions,
      'topicContinuity': topicContinuity,
      'userInterests': _userInterests[key],
      'strategy': continuationStrategy,
    };
  }
  
  /// 답변받지 못한 질문 확인
  static List<UnansweredQuestion> _checkUnansweredQuestions(
    String key,
    String userMessage,
    List<Message> chatHistory,
  ) {
    // 기존 질문 목록 가져오기
    final questions = _unansweredQuestions[key] ?? [];
    
    // 현재 메시지가 이전 질문에 대한 답변인지 확인
    if (questions.isNotEmpty) {
      final answeredQuestions = <UnansweredQuestion>[];
      
      for (final question in questions) {
        if (_isAnswerToQuestion(userMessage, question.question)) {
          answeredQuestions.add(question);
        }
      }
      
      // 답변된 질문 제거
      questions.removeWhere((q) => answeredQuestions.contains(q));
    }
    
    // 24시간 이상 지난 질문 제거
    questions.removeWhere((q) => 
      DateTime.now().difference(q.timestamp).inHours > 24
    );
    
    _unansweredQuestions[key] = questions;
    return questions;
  }
  
  /// 질문에 대한 답변인지 확인
  static bool _isAnswerToQuestion(String message, String question) {
    // 간단한 휴리스틱
    final keywords = _extractKeywords(question);
    int matchCount = 0;
    
    for (final keyword in keywords) {
      if (message.contains(keyword)) matchCount++;
    }
    
    return matchCount >= keywords.length / 2;
  }
  
  /// 주제 연속성 분석
  static Map<String, dynamic> _analyzeTopicContinuity(
    String key,
    String userMessage,
    List<Message> chatHistory,
  ) {
    final currentTopic = _extractTopic(userMessage);
    final history = _topicHistory[key] ?? [];
    
    // 최근 주제와의 연관성
    double continuityScore = 0.0;
    String? previousTopic;
    
    if (history.isNotEmpty) {
      previousTopic = history.last.topic;
      continuityScore = _calculateTopicSimilarity(currentTopic, previousTopic);
    }
    
    // 주제 히스토리 업데이트
    history.add(ConversationTopic(
      topic: currentTopic,
      timestamp: DateTime.now(),
      messageCount: 1,
      engagementScore: _calculateEngagement(userMessage),
    ));
    
    // 최대 20개 주제만 유지
    if (history.length > 20) {
      history.removeAt(0);
    }
    
    _topicHistory[key] = history;
    
    return {
      'currentTopic': currentTopic,
      'previousTopic': previousTopic,
      'continuityScore': continuityScore,
      'isTopicChange': continuityScore < 0.3,
      'topicHistory': history.map((t) => t.topic).toList(),
    };
  }
  
  /// 사용자 관심사 업데이트
  static void _updateUserInterests(String key, String userMessage) {
    final interests = _userInterests[key] ?? UserInterests(
      topicFrequency: {},
      favoriteTopics: [],
      recentTopics: [],
      lastUpdated: DateTime.now(),
    );
    
    // 주제 추출
    final topic = _extractTopic(userMessage);
    final keywords = _extractKeywords(userMessage);
    
    // 주제 빈도 업데이트
    final frequency = Map<String, int>.from(interests.topicFrequency);
    frequency[topic] = (frequency[topic] ?? 0) + 1;
    
    for (final keyword in keywords) {
      frequency[keyword] = (frequency[keyword] ?? 0) + 1;
    }
    
    // 상위 5개 즐겨찾기 주제
    final sortedTopics = frequency.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final favoriteTopics = sortedTopics.take(5).map((e) => e.key).toList();
    
    // 최근 주제 업데이트
    final recentTopics = [topic, ...interests.recentTopics];
    if (recentTopics.length > 10) {
      recentTopics.removeLast();
    }
    
    _userInterests[key] = UserInterests(
      topicFrequency: frequency,
      favoriteTopics: favoriteTopics,
      recentTopics: recentTopics,
      lastUpdated: DateTime.now(),
    );
  }
  
  /// 대화 이어가기 전략 생성
  static Map<String, dynamic> _generateContinuationStrategy({
    required String userMessage,
    required List<Message> chatHistory,
    required List<UnansweredQuestion> unansweredQuestions,
    required Map<String, dynamic> topicContinuity,
  }) {
    final strategies = <String>[];
    final followUpQuestions = <String>[];
    
    // 1. 단답형 응답 감지
    if (_isShortResponse(userMessage)) {
      strategies.add('short_response_expansion');
      followUpQuestions.addAll([
        '더 자세히 얘기해줄래?',
        '어떤 부분이 그랬어?',
        '왜 그런 것 같아?',
        '그래서 기분이 어때?',
      ]);
    }
    
    // 2. 주제 변경 감지
    if (topicContinuity['isTopicChange'] == true) {
      strategies.add('smooth_topic_transition');
      if (topicContinuity['previousTopic'] != null) {
        followUpQuestions.add('아 맞다, 아까 ${topicContinuity['previousTopic']} 얘기하다가 생각났는데...');
      }
    }
    
    // 3. 답변받지 못한 질문이 있는 경우
    if (unansweredQuestions.isNotEmpty && chatHistory.length > 5) {
      final oldestQuestion = unansweredQuestions.first;
      strategies.add('recall_unanswered');
      followUpQuestions.add('아 참, 아까 물어본 거 있잖아... ${oldestQuestion.question}');
    }
    
    // 4. 대화가 끝날 것 같은 신호
    if (_isConversationEnding(userMessage)) {
      strategies.add('prevent_ending');
      followUpQuestions.addAll([
        '오늘 뭐 재밌는 일 없었어?',
        '저녁은 뭐 먹을 거야?',
        '내일 계획 있어?',
        '요즘 뭐하고 지내?',
      ]);
    }
    
    return {
      'strategies': strategies,
      'followUpQuestions': followUpQuestions,
      'shouldAskQuestion': followUpQuestions.isNotEmpty,
      'questionPriority': _calculateQuestionPriority(userMessage, chatHistory),
    };
  }
  
  /// 주제 추출
  static String _extractTopic(String message) {
    // 간단한 주제 분류
    final topics = {
      '일상': ['아침', '점심', '저녁', '오늘', '어제', '내일', '주말'],
      '음식': ['먹', '밥', '맛있', '배고', '음식', '요리', '카페'],
      '감정': ['기분', '행복', '슬', '화나', '짜증', '좋', '싫'],
      '일/학교': ['일', '회사', '학교', '공부', '시험', '과제', '프로젝트'],
      '취미': ['게임', '영화', '드라마', '음악', '운동', '책', '여행'],
      '날씨': ['날씨', '비', '눈', '춥', '덥', '바람', '맑'],
      '관계': ['친구', '가족', '연애', '사람', '만나', '약속'],
    };
    
    for (final entry in topics.entries) {
      for (final keyword in entry.value) {
        if (message.contains(keyword)) {
          return entry.key;
        }
      }
    }
    
    return '일상';
  }
  
  /// 키워드 추출
  static List<String> _extractKeywords(String message) {
    // 명사와 주요 동사 추출 (간단한 버전)
    final keywords = <String>[];
    final words = message.split(RegExp(r'[\s,.!?~]'));
    
    for (final word in words) {
      if (word.length >= 2 && !_isStopWord(word)) {
        keywords.add(word);
      }
    }
    
    return keywords.take(5).toList();
  }
  
  /// 불용어 체크
  static bool _isStopWord(String word) {
    final stopWords = [
      '나', '너', '우리', '저', '이', '그', '저것', '것',
      '을', '를', '이', '가', '은', '는', '의', '에', '에서',
      '으로', '로', '와', '과', '하고', '이고', '고',
      '아', '야', '어', '여', '네', '응', '어',
    ];
    return stopWords.contains(word);
  }
  
  /// 주제 유사도 계산
  static double _calculateTopicSimilarity(String topic1, String topic2) {
    if (topic1 == topic2) return 1.0;
    
    // 관련 주제 매핑
    final relatedTopics = {
      '일상': ['날씨', '음식'],
      '음식': ['일상', '감정'],
      '감정': ['일상', '관계'],
      '일/학교': ['일상', '감정'],
      '취미': ['감정', '일상'],
      '날씨': ['일상', '감정'],
      '관계': ['감정', '일상'],
    };
    
    final related = relatedTopics[topic1] ?? [];
    if (related.contains(topic2)) return 0.6;
    
    return 0.2;
  }
  
  /// 참여도 계산
  static double _calculateEngagement(String message) {
    double score = 0.5;
    
    // 길이
    if (message.length > 50) score += 0.2;
    if (message.length > 100) score += 0.1;
    
    // 감정 표현
    if (message.contains('!')) score += 0.1;
    if (message.contains('?')) score += 0.1;
    if (RegExp(r'[ㅋㅎ]{2,}').hasMatch(message)) score += 0.1;
    
    return score.clamp(0.0, 1.0);
  }
  
  /// 짧은 응답 감지
  static bool _isShortResponse(String message) {
    return message.length < 10 && 
           !message.contains('?') && 
           !message.contains('!');
  }
  
  /// 대화 종료 신호 감지
  static bool _isConversationEnding(String message) {
    final endingSignals = [
      '잘자', '굿나잇', '자야', '자러',
      '바빠', '가야', '끊어', '그만',
      '안녕', '빠이', '바이', '내일',
      '나중에', '다음에',
    ];
    
    final lower = message.toLowerCase();
    return endingSignals.any((signal) => lower.contains(signal));
  }
  
  /// 질문 우선순위 계산
  static int _calculateQuestionPriority(String userMessage, List<Message> chatHistory) {
    // 1-5 scale
    int priority = 3;
    
    // 짧은 응답이면 우선순위 높임
    if (_isShortResponse(userMessage)) priority += 1;
    
    // 대화가 10개 이상이면 우선순위 낮춤
    if (chatHistory.length > 10) priority -= 1;
    
    // 질문이 포함되어 있으면 우선순위 낮춤
    if (userMessage.contains('?')) priority -= 1;
    
    return priority.clamp(1, 5);
  }
  
  /// 질문 저장
  static void saveQuestion({
    required String userId,
    required String personaId,
    required String question,
    required String topic,
    int importance = 3,
  }) {
    final key = '${userId}_$personaId';
    final questions = _unansweredQuestions[key] ?? [];
    
    questions.add(UnansweredQuestion(
      question: question,
      timestamp: DateTime.now(),
      topic: topic,
      importance: importance,
    ));
    
    // 최대 10개만 유지
    if (questions.length > 10) {
      questions.removeAt(0);
    }
    
    _unansweredQuestions[key] = questions;
  }
  
  /// AI 프롬프트용 가이드 생성
  static String generateContinuityGuide(Map<String, dynamic> analysis) {
    final buffer = StringBuffer();
    
    buffer.writeln('💬 대화 지속성 가이드:');
    
    // 전략
    final strategies = analysis['strategy']['strategies'] as List;
    if (strategies.isNotEmpty) {
      buffer.writeln('\n전략:');
      for (final strategy in strategies) {
        buffer.writeln('- ${_getStrategyDescription(strategy)}');
      }
    }
    
    // 추천 질문
    final questions = analysis['strategy']['followUpQuestions'] as List;
    if (questions.isNotEmpty) {
      buffer.writeln('\n추천 후속 질문:');
      for (final question in questions.take(3)) {
        buffer.writeln('- $question');
      }
    }
    
    // 관심사
    final interests = analysis['userInterests'] as UserInterests?;
    if (interests != null && interests.favoriteTopics.isNotEmpty) {
      buffer.writeln('\n사용자 관심사: ${interests.favoriteTopics.take(3).join(', ')}');
    }
    
    // 답변받지 못한 질문
    final unanswered = analysis['unansweredQuestions'] as List<UnansweredQuestion>;
    if (unanswered.isNotEmpty) {
      buffer.writeln('\n이전에 물어본 질문 (답변 대기중):');
      buffer.writeln('- ${unanswered.first.question}');
    }
    
    return buffer.toString();
  }
  
  /// 전략 설명
  static String _getStrategyDescription(String strategy) {
    final descriptions = {
      'short_response_expansion': '짧은 답변이므로 추가 질문으로 대화 확장',
      'smooth_topic_transition': '주제가 바뀌었으니 자연스럽게 연결',
      'recall_unanswered': '이전 질문을 자연스럽게 다시 언급',
      'prevent_ending': '대화가 끝날 것 같으니 새로운 화제 제시',
    };
    return descriptions[strategy] ?? strategy;
  }
}