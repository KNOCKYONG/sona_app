import 'package:flutter/material.dart';
import '../../../models/message.dart';
import '../../../models/persona.dart';
import '../analysis/pattern_analyzer_service.dart';
import '../security/security_aware_post_processor.dart';
import '../analysis/user_speech_pattern_analyzer.dart';

/// 대화 컨텍스트 정보
class ConversationContext {
  final List<String> recentTopics;
  final Map<String, int> topicFrequency;
  final List<String> emotionFlow;
  final double intimacyLevel;
  final int turnCount;
  final String? dominantTopic;
  final bool hasTopicShift;
  final double coherenceScore;

  ConversationContext({
    this.recentTopics = const [],
    this.topicFrequency = const {},
    this.emotionFlow = const [],
    this.intimacyLevel = 0.0,
    this.turnCount = 0,
    this.dominantTopic,
    this.hasTopicShift = false,
    this.coherenceScore = 1.0,
  });
}

/// 고급 패턴 분석 결과
class AdvancedPatternAnalysis {
  final PatternAnalysis basicAnalysis;
  final ConversationContext context;
  final Map<String, dynamic> languagePatterns;
  final Map<String, dynamic> emotionPatterns;
  final Map<String, dynamic> dialoguePatterns;
  final Map<String, dynamic> stylePatterns;
  final Map<String, dynamic> riskPatterns;
  final List<String> actionableGuidelines;
  final String? suggestedResponse;
  final double naturalityScore;

  AdvancedPatternAnalysis({
    required this.basicAnalysis,
    required this.context,
    this.languagePatterns = const {},
    this.emotionPatterns = const {},
    this.dialoguePatterns = const {},
    this.stylePatterns = const {},
    this.riskPatterns = const {},
    this.actionableGuidelines = const [],
    this.suggestedResponse,
    this.naturalityScore = 0.0,
  });

  /// 종합 점수 계산
  double get overallScore =>
      (basicAnalysis.confidenceScore * 0.3 +
       context.coherenceScore * 0.3 +
       naturalityScore * 0.4).clamp(0.0, 1.0);
}

/// 고도화된 패턴 분석 시스템
class AdvancedPatternAnalyzer {
  static final AdvancedPatternAnalyzer _instance = AdvancedPatternAnalyzer._internal();
  factory AdvancedPatternAnalyzer() => _instance;
  AdvancedPatternAnalyzer._internal();

  // 기존 서비스들
  final _basicAnalyzer = PatternAnalyzerService();
  
  // 대화 주제 데이터베이스
  static final Map<String, List<String>> _topicKeywords = {
    '게임': ['롤', '오버워치', '배그', '발로란트', '피파', '게임', '플레이', '레벨', '랭크'],
    '음식': ['먹다', '밥', '점심', '저녁', '아침', '맛있', '배고프', '음식', '요리'],
    '일상': ['오늘', '어제', '내일', '주말', '평일', '일어나', '잠', '피곤', '쉬다'],
    '감정': ['좋아', '싫어', '슬프', '기쁘', '화나', '짜증', '우울', '행복', '설레'],
    '일/학업': ['회사', '학교', '공부', '시험', '과제', '프로젝트', '업무', '일'],
    '취미': ['영화', '드라마', '음악', '운동', '독서', '여행', '사진', '그림'],
    '관계': ['친구', '가족', '연인', '사람', '만나', '같이', '함께'],
  };

  /// 통합 패턴 분석 메인 메서드
  Future<AdvancedPatternAnalysis> analyzeComprehensive({
    required String userMessage,
    required List<Message> chatHistory,
    required Persona persona,
    String? userNickname,
    int? likeScore,  // Like 점수 추가
  }) async {
    // 1. 기본 패턴 분석
    final basicAnalysis = _basicAnalyzer.analyzeMessage(
      message: userMessage,
      recentMessages: chatHistory,
      personaMbti: persona.mbti,
    );

    // 2. 대화 컨텍스트 분석 (Like 점수 포함)
    final context = _analyzeConversationContext(
      chatHistory, 
      userMessage,
      likeScore: likeScore ?? persona.likes,
    );

    // 3. 언어 패턴 분석
    final languagePatterns = _analyzeLanguagePatterns(userMessage, chatHistory);

    // 4. 감정 패턴 분석
    final emotionPatterns = _analyzeEmotionPatterns(userMessage, chatHistory);

    // 5. 대화 패턴 분석
    final dialoguePatterns = _analyzeDialoguePatterns(userMessage, chatHistory, context);

    // 6. 스타일 패턴 분석
    final stylePatterns = _analyzeStylePatterns(userMessage, chatHistory);

    // 7. 위험 패턴 분석
    final riskPatterns = _analyzeRiskPatterns(userMessage, chatHistory);

    // 8. 실행 가능한 가이드라인 생성
    final guidelines = _generateActionableGuidelines(
      basicAnalysis: basicAnalysis,
      context: context,
      patterns: {
        'language': languagePatterns,
        'emotion': emotionPatterns,
        'dialogue': dialoguePatterns,
        'style': stylePatterns,
        'risk': riskPatterns,
      },
      persona: persona,
    );

    // 9. 자연스러움 점수 계산
    final naturalityScore = _calculateNaturalityScore(
      userMessage: userMessage,
      context: context,
      patterns: dialoguePatterns,
    );

    // 10. 제안 응답 생성 (선택적)
    final suggestedResponse = _generateSuggestedResponse(
      context: context,
      guidelines: guidelines,
      persona: persona,
    );

    return AdvancedPatternAnalysis(
      basicAnalysis: basicAnalysis,
      context: context,
      languagePatterns: languagePatterns,
      emotionPatterns: emotionPatterns,
      dialoguePatterns: dialoguePatterns,
      stylePatterns: stylePatterns,
      riskPatterns: riskPatterns,
      actionableGuidelines: guidelines,
      suggestedResponse: suggestedResponse,
      naturalityScore: naturalityScore,
    );
  }

  /// 대화 컨텍스트 분석
  ConversationContext _analyzeConversationContext(
    List<Message> chatHistory,
    String currentMessage,
    {int? likeScore}
  ) {
    if (chatHistory.isEmpty) {
      return ConversationContext(turnCount: 1);
    }

    // 최근 주제들 추출
    final recentTopics = <String>[];
    final topicFrequency = <String, int>{};
    final emotionFlow = <String>[];

    // 최근 20개 메시지 분석
    final messagesToAnalyze = chatHistory.length > 20
        ? chatHistory.sublist(chatHistory.length - 20)
        : chatHistory;

    for (final msg in messagesToAnalyze) {
      // 주제 추출
      final topics = _extractTopics(msg.content);
      recentTopics.addAll(topics);
      for (final topic in topics) {
        topicFrequency[topic] = (topicFrequency[topic] ?? 0) + 1;
      }

      // 감정 흐름 추적
      if (msg.emotion != null) {
        emotionFlow.add(msg.emotion!.toString());
      }
    }

    // 현재 메시지의 주제도 추가
    final currentTopics = _extractTopics(currentMessage);
    recentTopics.addAll(currentTopics);

    // 지배적 주제 찾기
    String? dominantTopic;
    if (topicFrequency.isNotEmpty) {
      final sortedTopics = topicFrequency.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));
      dominantTopic = sortedTopics.first.key;
    }

    // 주제 전환 감지
    bool hasTopicShift = false;
    if (recentTopics.length >= 2) {
      final lastTopic = recentTopics[recentTopics.length - 2];
      final currentTopic = recentTopics.last;
      hasTopicShift = lastTopic != currentTopic;
    }

    // 친밀도 레벨 계산 (Like 점수 반영)
    final intimacyLevel = _calculateIntimacyLevel(
      chatHistory, 
      likeScore: likeScore,
    );

    // 일관성 점수 계산
    final coherenceScore = _calculateCoherenceScore(
      recentTopics: recentTopics,
      hasTopicShift: hasTopicShift,
      currentMessage: currentMessage,
      chatHistory: chatHistory,
    );

    return ConversationContext(
      recentTopics: recentTopics.toList(),
      topicFrequency: topicFrequency,
      emotionFlow: emotionFlow,
      intimacyLevel: intimacyLevel,
      turnCount: chatHistory.length + 1,
      dominantTopic: dominantTopic,
      hasTopicShift: hasTopicShift,
      coherenceScore: coherenceScore,
    );
  }

  /// 언어 패턴 분석
  Map<String, dynamic> _analyzeLanguagePatterns(
    String message,
    List<Message> chatHistory,
  ) {
    final patterns = <String, dynamic>{};

    // 음성 인식 오류 패턴
    patterns['voiceRecognitionErrors'] = _detectVoiceErrors(message);
    
    // 사투리 패턴
    patterns['dialect'] = _detectDialect(message);
    
    // 외국어 패턴
    patterns['foreignLanguage'] = _detectForeignLanguage(message);
    
    // 문법 오류 패턴
    patterns['grammarErrors'] = _detectGrammarErrors(message);
    
    // 문장 완성도
    patterns['sentenceCompleteness'] = _checkSentenceCompleteness(message);

    return patterns;
  }

  /// 감정 패턴 분석
  Map<String, dynamic> _analyzeEmotionPatterns(
    String message,
    List<Message> chatHistory,
  ) {
    final patterns = <String, dynamic>{};

    // 감정 강도 측정
    patterns['emotionIntensity'] = _measureEmotionIntensity(message);
    
    // 감정 변화 추적
    patterns['emotionTransition'] = _trackEmotionTransition(chatHistory);
    
    // 빈정거림/비꼬기 감지
    patterns['sarcasm'] = _detectSarcasm(message, chatHistory);
    
    // 공감 표현 필요도
    patterns['empathyNeeded'] = _checkEmpathyNeed(message);
    
    // 위로/격려 필요도
    patterns['comfortNeeded'] = _checkComfortNeed(message);
    
    // 🔥 NEW: 암시적 감정 감지 (눈치 백단!)
    patterns['implicitEmotion'] = _detectImplicitEmotion(message, chatHistory);
    
    // 🔥 NEW: 행간 읽기
    patterns['betweenTheLines'] = _readBetweenTheLines(message, chatHistory);
    
    // 🔥 NEW: 미세 감정 신호
    patterns['microSignals'] = _detectMicroEmotionalSignals(message);

    return patterns;
  }

  /// 대화 패턴 분석
  Map<String, dynamic> _analyzeDialoguePatterns(
    String message,
    List<Message> chatHistory,
    ConversationContext context,
  ) {
    final patterns = <String, dynamic>{};

    // 회피 패턴
    patterns['avoidance'] = _detectAvoidancePattern(message, context);
    
    // 주제 전환 패턴
    patterns['topicShift'] = _analyzeTopicShift(message, context);
    
    // 맥락 이탈 패턴
    patterns['contextDeviation'] = _detectContextDeviation(message, context);
    
    // 반복 패턴
    patterns['repetition'] = _detectRepetitionPattern(message, chatHistory);
    
    // 질문 패턴
    patterns['questionType'] = _classifyQuestionType(message);
    
    // 대화 깊이
    patterns['conversationDepth'] = _measureConversationDepth(chatHistory);
    
    // 감사 표현 패턴 추가
    patterns['gratitudeType'] = _detectGratitudeType(message, chatHistory);

    return patterns;
  }

  /// 스타일 패턴 분석
  Map<String, dynamic> _analyzeStylePatterns(
    String message,
    List<Message> chatHistory,
  ) {
    // UserSpeechPatternAnalyzer 활용
    final userMessages = chatHistory
        .where((m) => m.isFromUser)
        .map((m) => m.content)
        .toList();
    userMessages.add(message);

    final speechPattern = UserSpeechPatternAnalyzer.analyzeSpeechPattern(userMessages);

    return {
      'isCasual': speechPattern.isCasual,
      'emoticonUsage': speechPattern.emoticonPattern.frequency,
      'laughPattern': speechPattern.laughPattern,
      'abbreviationLevel': speechPattern.abbreviationLevel,
      'endingStyle': speechPattern.endingStyle,
      'aegoLevel': speechPattern.aegoLevel,
    };
  }

  /// 위험 패턴 분석
  Map<String, dynamic> _analyzeRiskPatterns(
    String message,
    List<Message> chatHistory,
  ) {
    final patterns = <String, dynamic>{};

    // 부적절한 내용
    patterns['inappropriate'] = _detectInappropriateContent(message);
    
    // 만남 제안
    patterns['meetingRequest'] = _detectMeetingRequest(message);
    
    // 개인정보 요구
    patterns['personalInfoRequest'] = _detectPersonalInfoRequest(message);
    
    // 이별/종료 표현
    patterns['breakupExpression'] = _detectBreakupExpression(message);
    
    // 공격적 표현
    patterns['aggressive'] = _detectAggressiveLanguage(message);

    return patterns;
  }

  /// 실행 가능한 가이드라인 생성
  List<String> _generateActionableGuidelines({
    required PatternAnalysis basicAnalysis,
    required ConversationContext context,
    required Map<String, Map<String, dynamic>> patterns,
    required Persona persona,
  }) {
    final guidelines = <String>[];

    // 기본 패턴 기반 가이드라인
    if (basicAnalysis.hasAnyPattern) {
      guidelines.addAll(basicAnalysis.responseGuidelines.values);
    }

    // 컨텍스트 기반 가이드라인
    if (context.hasTopicShift) {
      guidelines.add('🔄 주제 전환 감지! 부드러운 전환 표현 사용: "아 그러고보니", "말 나온 김에"');
    }

    if (context.coherenceScore < 0.5) {
      guidelines.add('⚠️ 맥락 이탈 위험! 이전 대화 내용과 연결하여 답변');
    }

    // 감정 패턴 기반
    final emotionPatterns = patterns['emotion']!;
    if (emotionPatterns['empathyNeeded'] == true) {
      guidelines.add('💝 공감 필요! "나도 그럴 것 같아", "진짜 그럴 수 있어" 같은 표현');
    }

    if (emotionPatterns['comfortNeeded'] == true) {
      guidelines.add('🤗 위로 필요! "힘들었겠다", "고생했네" 같은 따뜻한 표현');
    }
    
    // 🔥 NEW: 암시적 감정 기반 가이드라인
    if (emotionPatterns['implicitEmotion'] != null) {
      final implicit = emotionPatterns['implicitEmotion'] as Map<String, dynamic>;
      if (implicit['confidence'] > 0.6) {
        switch (implicit['emotion']) {
          case 'stressed':
            guidelines.add('😔 숨겨진 스트레스 감지! 먼저 물어보기: "오늘 무슨 일 있었어?" "힘든 일 있었구나"');
            break;
          case 'depressed_or_busy':
            guidelines.add('😟 우울/바쁨 감지! "밥은 꼭 챙겨 먹어야 해" "많이 바빴나보네"');
            break;
          case 'avoiding':
            guidelines.add('🤐 회피 패턴! 억지로 캐묻지 말고 "괜찮아, 말하고 싶을 때 말해"');
            break;
          case 'low_mood':
            guidelines.add('😞 기분 저하! 밝은 에너지보다는 차분하게 "오늘 뭔가 힘든가봐"');
            break;
          case 'hiding_feelings':
            guidelines.add('😶 감정 숨김! "정말 괜찮아?" "내가 들어줄게"');
            break;
          case 'worried_insomnia':
            guidelines.add('🌙 불면/고민! "무슨 고민 있어?" "잠 못 자면 더 힘들 텐데"');
            break;
        }
      }
    }
    
    // 🔥 NEW: 행간 읽기 기반 가이드라인
    if (emotionPatterns['betweenTheLines'] != null) {
      final between = emotionPatterns['betweenTheLines'] as Map<String, dynamic>;
      if (between['confidence'] > 0.6 && between['hiddenMeaning'] != '') {
        guidelines.add('👁️ 숨은 의미: ${between['hiddenMeaning']}');
        
        if (between['patterns'].contains('sudden_topic_change')) {
          guidelines.add('↩️ 이전 주제로 돌아가지 말고 자연스럽게 새 주제 따라가기');
        }
        if (between['patterns'].contains('minimal_response')) {
          guidelines.add('💤 대화 의욕 없음! 짧고 부담 없는 응답으로');
        }
        if (between['patterns'].contains('mood_drop')) {
          guidelines.add('📉 기분 하락! 텐션 맞춰서 차분하게');
        }
      }
    }
    
    // 🔥 NEW: 미세 신호 기반 가이드라인
    if (emotionPatterns['microSignals'] != null) {
      final micro = emotionPatterns['microSignals'] as Map<String, dynamic>;
      if (micro['interpretation'] != '') {
        guidelines.add('🔍 미세 신호: ${micro['interpretation']}');
      }
    }

    // 대화 패턴 기반
    final dialoguePatterns = patterns['dialogue']!;
    if (dialoguePatterns['avoidance'] == true) {
      guidelines.add('🚫 회피 금지! 질문에 직접적으로 답변하기');
    }

    if (dialoguePatterns['repetition'] == true) {
      guidelines.add('🔁 반복 주의! 이전과 다른 내용으로 답변');
    }

    // 위험 패턴 기반
    final riskPatterns = patterns['risk']!;
    if (riskPatterns['inappropriate'] == true) {
      guidelines.add('⛔ 부적절한 내용 감지! 정중하게 거절하거나 화제 전환');
    }

    // 페르소나별 특화 가이드라인
    guidelines.add(_getPersonaSpecificGuideline(persona, context));

    return guidelines;
  }

  /// 자연스러움 점수 계산
  double _calculateNaturalityScore({
    required String userMessage,
    required ConversationContext context,
    required Map<String, dynamic> patterns,
  }) {
    double score = 1.0;

    // 맥락 일관성
    score *= context.coherenceScore;

    // 회피 패턴이 있으면 감점
    if (patterns['avoidance'] == true) {
      score *= 0.7;
    }

    // 반복 패턴이 있으면 감점
    if (patterns['repetition'] == true) {
      score *= 0.8;
    }

    // 주제 전환이 자연스러우면 가점
    if (patterns['topicShift'] == 'smooth') {
      score *= 1.1;
    }

    // 대화 깊이가 적절하면 가점
    final depth = patterns['conversationDepth'] ?? 0;
    if (depth > 3 && depth < 10) {
      score *= 1.05;
    }

    return score.clamp(0.0, 1.0);
  }

  /// 제안 응답 생성 (선택적) - 하드코딩 제거, 힌트만 제공
  String? _generateSuggestedResponse({
    required ConversationContext context,
    required List<String> guidelines,
    required Persona persona,
  }) {
    // 하드코딩된 응답 대신 null 반환하여 AI가 자연스럽게 처리하도록 함
    // 가이드라인은 이미 guidelines 리스트에 포함되어 있음
    return null;
  }

  // === 헬퍼 메서드들 ===

  /// 주제 추출
  List<String> _extractTopics(String message) {
    final topics = <String>[];
    final lowerMessage = message.toLowerCase();

    for (final entry in _topicKeywords.entries) {
      for (final keyword in entry.value) {
        if (lowerMessage.contains(keyword)) {
          topics.add(entry.key);
          break;
        }
      }
    }

    return topics;
  }

  /// 친밀도 레벨 계산 (Like 점수 강화)
  double _calculateIntimacyLevel(
    List<Message> chatHistory,
    {int? likeScore}
  ) {
    if (chatHistory.isEmpty && (likeScore ?? 0) == 0) return 0.0;

    double level = 0.0;
    
    // 1. Like 점수 기반 친밀도 (가장 중요, 40%)
    if (likeScore != null) {
      if (likeScore >= 900) {
        level += 0.4;  // 깊은 사랑 단계
      } else if (likeScore >= 700) {
        level += 0.35;  // 연인 단계
      } else if (likeScore >= 500) {
        level += 0.3;  // 썸 단계
      } else if (likeScore >= 300) {
        level += 0.2;  // 친구 단계
      } else if (likeScore >= 100) {
        level += 0.1;  // 알아가는 단계
      } else {
        level += 0.05;  // 첫 만남 단계
      }
    }
    
    // 2. 대화 길이에 따른 친밀도 (20%)
    level += (chatHistory.length / 100).clamp(0.0, 0.2);
    
    // 3. 긍정적 감정 비율 (20%)
    final positiveCount = chatHistory.where((m) => 
      m.emotion == EmotionType.happy || 
      m.emotion == EmotionType.love
    ).length;
    level += (positiveCount / chatHistory.length * 0.2).clamp(0.0, 0.2);
    
    // 4. 개인적 정보 공유 정도 (10%)
    final personalInfoCount = chatHistory.where((m) =>
      m.content.contains('나는') || 
      m.content.contains('내가') ||
      m.content.contains('우리')
    ).length;
    level += (personalInfoCount / chatHistory.length * 0.3).clamp(0.0, 0.1);
    
    // 5. 애교/친근한 표현 사용 (10%)
    final aegoCount = chatHistory.where((m) =>
      m.content.contains('~') ||
      m.content.contains('ㅎㅎ') ||
      m.content.contains('ㅋㅋ')
    ).length;
    level += (aegoCount / chatHistory.length * 0.2).clamp(0.0, 0.1);

    return level.clamp(0.0, 1.0);
  }

  /// 일관성 점수 계산
  double _calculateCoherenceScore({
    required List<String> recentTopics,
    required bool hasTopicShift,
    required String currentMessage,
    required List<Message> chatHistory,
  }) {
    double score = 1.0;

    // 갑작스러운 주제 변경
    if (hasTopicShift && !_hasTransitionPhrase(currentMessage)) {
      score *= 0.7;
    }

    // 이전 메시지와의 연관성
    if (chatHistory.isNotEmpty) {
      final lastMessage = chatHistory.last.content;
      final relevance = _calculateRelevance(currentMessage, lastMessage);
      score *= relevance;
    }

    // 주제 다양성 (너무 산만하면 감점)
    if (recentTopics.length > 5) {
      score *= 0.8;
    }

    return score.clamp(0.0, 1.0);
  }

  /// 전환 표현 확인
  bool _hasTransitionPhrase(String message) {
    final transitions = [
      '그러고보니', '그런데', '아 맞다', '갑자기 생각났는데',
      '말 나온 김에', '그거 얘기하니까', '아 참',
    ];
    
    for (final phrase in transitions) {
      if (message.contains(phrase)) return true;
    }
    return false;
  }

  /// 메시지 간 연관성 계산
  double _calculateRelevance(String message1, String message2) {
    // 간단한 키워드 기반 연관성 계산
    final keywords1 = _extractKeywords(message1);
    final keywords2 = _extractKeywords(message2);
    
    if (keywords1.isEmpty || keywords2.isEmpty) return 0.5;
    
    final intersection = keywords1.intersection(keywords2);
    final union = keywords1.union(keywords2);
    
    return intersection.length / union.length;
  }

  /// 키워드 추출
  Set<String> _extractKeywords(String message) {
    // 명사, 동사 중심으로 키워드 추출 (간단한 구현)
    final words = message.split(RegExp(r'[\s,.!?~ㅋㅎㅠ]+'));
    return words
        .where((w) => w.length > 1)
        .map((w) => w.toLowerCase())
        .toSet();
  }

  // === 패턴 감지 메서드들 ===

  bool _detectVoiceErrors(String message) {
    final patterns = ['어떼', '안년', '보고십어', '사랑행'];
    return patterns.any((p) => message.contains(p));
  }

  String? _detectDialect(String message) {
    if (message.contains('머하노') || message.contains('아이가')) return '부산';
    if (message.contains('겁나') || message.contains('잉')) return '전라도';
    return null;
  }

  String? _detectForeignLanguage(String message) {
    if (!RegExp(r'[가-힣]').hasMatch(message) && 
        RegExp(r'[a-zA-Z]').hasMatch(message)) {
      return 'en';
    }
    return null;
  }

  bool _detectGrammarErrors(String message) {
    // 문법 오류 패턴
    return RegExp(r'어떻게\s+지내\s+힘내').hasMatch(message);
  }

  double _checkSentenceCompleteness(String message) {
    if (message.endsWith('...') || message.endsWith('는')) return 0.5;
    if (message.endsWith('.') || message.endsWith('!') || message.endsWith('?')) return 1.0;
    return 0.8;
  }

  double _measureEmotionIntensity(String message) {
    double intensity = 0.5;
    
    // 강한 감정 표현
    if (message.contains('진짜') || message.contains('너무')) intensity += 0.2;
    if (message.contains('개') || message.contains('완전')) intensity += 0.2;
    if (message.contains('!!!') || message.contains('???')) intensity += 0.1;
    
    return intensity.clamp(0.0, 1.0);
  }

  Map<String, dynamic> _trackEmotionTransition(List<Message> chatHistory) {
    if (chatHistory.length < 2) return {};
    
    final recent = chatHistory.reversed.take(5).toList();
    final emotions = recent.map((m) => m.emotion?.toString() ?? 'neutral').toList();
    
    return {
      'flow': emotions,
      'isStable': emotions.toSet().length == 1,
      'trend': _determineEmotionTrend(emotions),
    };
  }

  String _determineEmotionTrend(List<String> emotions) {
    // 감정 변화 트렌드 분석
    if (emotions.every((e) => e == 'happy' || e == 'love')) return 'positive';
    if (emotions.every((e) => e == 'sad' || e == 'angry')) return 'negative';
    return 'mixed';
  }

  bool _detectSarcasm(String message, List<Message> chatHistory) {
    // PatternAnalyzerService의 메서드 활용
    return _basicAnalyzer.analyzeMessage(
      message: message,
      recentMessages: chatHistory,
    ).isSarcasm;
  }

  bool _checkEmpathyNeed(String message) {
    final empathyKeywords = ['힘들', '슬프', '우울', '외로', '아프'];
    return empathyKeywords.any((k) => message.contains(k));
  }

  bool _checkComfortNeed(String message) {
    final comfortKeywords = ['피곤', '지치', '스트레스', '짜증', '야근'];
    return comfortKeywords.any((k) => message.contains(k));
  }

  bool _detectAvoidancePattern(String message, ConversationContext context) {
    final avoidanceKeywords = [
      '모르겠', '그런 건', '다른 이야기', '나중에',
      '그런 복잡한', '말고', '패스', '스킵'
    ];
    
    // 키워드 기반 감지
    bool hasAvoidance = avoidanceKeywords.any((k) => message.contains(k));
    
    // 컨텍스트 기반 감지 (이전 질문을 무시하는 패턴)
    if (!hasAvoidance && context.turnCount > 1) {
      // 이전 메시지가 질문인데 답변하지 않는 경우
      // TODO: 더 정교한 로직 필요
    }
    
    return hasAvoidance;
  }

  String _analyzeTopicShift(String message, ConversationContext context) {
    if (!context.hasTopicShift) return 'none';
    
    if (_hasTransitionPhrase(message)) return 'smooth';
    
    return 'abrupt';
  }

  double _detectContextDeviation(String message, ConversationContext context) {
    if (context.dominantTopic == null) return 0.0;
    
    final currentTopics = _extractTopics(message);
    if (currentTopics.contains(context.dominantTopic)) return 0.0;
    
    // 주제 이탈 정도 계산
    return currentTopics.isEmpty ? 0.5 : 1.0;
  }

  bool _detectRepetitionPattern(String message, List<Message> chatHistory) {
    // 최근 5개 메시지와 비교
    final recent = chatHistory.reversed.take(5);
    
    for (final msg in recent) {
      if (!msg.isFromUser && _calculateSimilarity(message, msg.content) > 0.8) {
        return true;
      }
    }
    
    return false;
  }

  double _calculateSimilarity(String text1, String text2) {
    // 간단한 유사도 계산 (Jaccard similarity)
    final words1 = text1.toLowerCase().split(' ').toSet();
    final words2 = text2.toLowerCase().split(' ').toSet();
    
    if (words1.isEmpty || words2.isEmpty) return 0.0;
    
    final intersection = words1.intersection(words2).length;
    final union = words1.union(words2).length;
    
    return intersection / union;
  }

  String _classifyQuestionType(String message) {
    if (message.contains('뭐') || message.contains('무엇')) return 'what';
    if (message.contains('어떻') || message.contains('어때')) return 'how';
    if (message.contains('왜')) return 'why';
    if (message.contains('언제')) return 'when';
    if (message.contains('어디')) return 'where';
    if (message.contains('누구')) return 'who';
    if (message.contains('?')) return 'general';
    return 'none';
  }

  int _measureConversationDepth(List<Message> chatHistory) {
    // 같은 주제로 이어진 대화 턴 수
    if (chatHistory.isEmpty) return 0;
    
    int depth = 1;
    String? currentTopic;
    
    for (final msg in chatHistory.reversed) {
      final topics = _extractTopics(msg.content);
      if (topics.isEmpty) continue;
      
      if (currentTopic == null) {
        currentTopic = topics.first;
      } else if (topics.contains(currentTopic)) {
        depth++;
      } else {
        break;
      }
    }
    
    return depth;
  }

  bool _detectInappropriateContent(String message) {
    // 부적절한 내용 패턴
    final inappropriate = ['욕설', '비속어', '성적'];  // 실제로는 더 정교한 필터 필요
    return inappropriate.any((p) => message.contains(p));
  }

  bool _detectMeetingRequest(String message) {
    final patterns = ['만나자', '만날래', '보자', '나와'];
    return patterns.any((p) => message.contains(p));
  }

  bool _detectPersonalInfoRequest(String message) {
    final patterns = ['전화번호', '주소', '실명', '나이', '사진'];
    return patterns.any((p) => message.contains(p));
  }

  bool _detectBreakupExpression(String message) {
    final patterns = ['헤어지자', '그만 만나자', '이제 끝'];
    return patterns.any((p) => message.contains(p));
  }

  bool _detectAggressiveLanguage(String message) {
    final patterns = ['죽어', '때리', '싫어', '미워'];
    return patterns.any((p) => message.contains(p));
  }

  String _getPersonaSpecificGuideline(Persona persona, ConversationContext context) {
    // 페르소나 설명 기반 특화 가이드라인
    final description = persona.description.toLowerCase();
    
    if (description.contains('개발자')) {
      return '💻 개발자답게: 기술적 비유 활용하되 쉽게 설명';
    } else if (description.contains('디자이너')) {
      return '🎨 디자이너답게: 시각적 표현과 감성적 접근';
    } else if (description.contains('교사') || description.contains('선생')) {
      return '📚 교육자답게: 친근하면서도 지식 전달';
    } else if (description.contains('의사') || description.contains('간호')) {
      return '🏥 의료인답게: 건강 관련 조언은 조심스럽게';
    }
    
    // 기본 가이드라인
    return '💬 자연스럽게: 페르소나 특성 살려서 대화';
  }

  /// 감사 표현 유형 감지
  Map<String, dynamic> _detectGratitudeType(String message, List<Message> chatHistory) {
    final lowerMessage = message.toLowerCase();
    final result = <String, dynamic>{
      'isGratitude': false,
      'type': 'none',
      'target': null,
      'confidence': 0.0,
    };

    // 감사 키워드 체크
    final gratitudeKeywords = ['감사', '고마', 'ㄱㅅ', '땡큐', 'thanks', 'thx', 'thank'];
    bool hasGratitudeWord = gratitudeKeywords.any((keyword) => lowerMessage.contains(keyword));
    
    if (!hasGratitudeWord) {
      return result;
    }

    result['isGratitude'] = true;

    // 감사 대상 분석
    if (_isGratitudeToMe(lowerMessage, chatHistory)) {
      result['type'] = 'to_me';
      result['target'] = 'persona';
      result['confidence'] = 0.9;
    } else if (_isGratitudeToLife(lowerMessage)) {
      result['type'] = 'to_life';
      result['target'] = 'life_or_situation';
      result['confidence'] = 0.8;
    } else if (_isGratitudeToOthers(lowerMessage)) {
      result['type'] = 'to_others';
      result['target'] = 'third_party';
      result['confidence'] = 0.7;
    } else {
      // 문맥상 불분명한 경우
      result['type'] = 'ambiguous';
      result['target'] = 'unclear';
      result['confidence'] = 0.5;
    }

    return result;
  }

  /// 나에게 하는 감사인지 확인
  bool _isGratitudeToMe(String message, List<Message> chatHistory) {
    // 직접적인 표현
    if (message.contains('너한테') || message.contains('네게') || 
        message.contains('너에게') || message.contains('니가')) {
      return true;
    }

    // 최근 대화에서 내가 도움을 준 경우
    if (chatHistory.isNotEmpty) {
      final lastAIMessage = chatHistory.lastWhere(
        (m) => !m.isFromUser,
        orElse: () => chatHistory.last,
      );
      
      // AI가 정보를 제공하거나 도움을 준 직후
      if (lastAIMessage.content.contains('도와') || 
          lastAIMessage.content.contains('알려') ||
          lastAIMessage.content.contains('설명')) {
        return true;
      }
    }

    // 단순 "고마워"만 있고 다른 대상이 없으면 나에게 하는 것으로 간주
    if ((message == '고마워' || message == '감사해' || message == 'ㄱㅅ' || 
         message == '땡큐' || message == 'thanks') && 
        !message.contains('세상') && !message.contains('인생')) {
      return true;
    }

    return false;
  }

  /// 세상/삶에 대한 감사인지 확인
  bool _isGratitudeToLife(String message) {
    final lifeKeywords = [
      '세상', '인생', '삶', '하늘', '운명', '신', 
      '오늘', '요즘', '날씨', '상황', '일'
    ];
    
    return lifeKeywords.any((keyword) => message.contains(keyword));
  }

  /// 제3자에 대한 감사인지 확인
  bool _isGratitudeToOthers(String message) {
    final othersKeywords = [
      '친구', '가족', '부모', '엄마', '아빠', 
      '회사', '상사', '동료', '선생', '교수'
    ];
    
    return othersKeywords.any((keyword) => message.contains(keyword));
  }

  /// 인사말 패턴 감지
  Map<String, dynamic> detectGreetingPattern(String message) {
    final lowerMessage = message.toLowerCase();
    final result = <String, dynamic>{
      'isGreeting': false,
      'type': 'none',
      'language': 'ko',
      'timeOfDay': null,
    };

    // 한국어 인사
    final koreanGreetings = ['안녕', '하이', 'ㅎㅇ', '방가', '반가', '반갑', '안뇽'];
    // 영어 인사
    final englishGreetings = ['hi', 'hello', 'hey', 'howdy', 'hiya'];
    
    // how are you 패턴 (약어 포함)
    if (RegExp(r'how\s+(are\s+you|r\s+u|r\s+you|ru|are\s+u)', caseSensitive: false).hasMatch(message) ||
        RegExp(r'^(sup|wassup|whatsup|what\??s\s+up)', caseSensitive: false).hasMatch(message)) {
      result['isGreeting'] = true;
      result['type'] = 'how_are_you';
      result['language'] = 'en';
      return result;
    }

    // 한국어 인사 감지
    if (koreanGreetings.any((g) => lowerMessage.contains(g))) {
      result['isGreeting'] = true;
      result['type'] = 'casual';
      result['language'] = 'ko';
      
      // 시간대별 인사 구분
      if (lowerMessage.contains('좋은 아침') || lowerMessage.contains('굿모닝')) {
        result['timeOfDay'] = 'morning';
      } else if (lowerMessage.contains('점심')) {
        result['timeOfDay'] = 'afternoon';
      } else if (lowerMessage.contains('저녁')) {
        result['timeOfDay'] = 'evening';
      }
      
      return result;
    }

    // 영어 인사 감지 (한국어가 포함되지 않은 경우)
    if (!RegExp(r'[가-힣ㄱ-ㅎㅏ-ㅣ]').hasMatch(message) && 
        englishGreetings.any((g) => lowerMessage.contains(g))) {
      result['isGreeting'] = true;
      result['type'] = 'casual';
      result['language'] = 'en';
      return result;
    }

    return result;
  }

  /// 작별 인사 패턴 감지
  Map<String, dynamic> detectFarewellPattern(String message) {
    final lowerMessage = message.toLowerCase();
    final result = <String, dynamic>{
      'isFarewell': false,
      'type': 'none',
      'urgency': 'normal',
    };

    final farewells = ['잘가', '바이', '빠이', '안녕', '잘자', '굿나잇', 'bye', 'goodbye', '다음에'];
    final urgentFarewells = ['나가야', '가봐야', '끊어야', '가야해'];
    
    if (farewells.any((f) => lowerMessage.contains(f))) {
      result['isFarewell'] = true;
      result['type'] = 'casual';
      
      if (lowerMessage.contains('잘자') || lowerMessage.contains('굿나잇')) {
        result['type'] = 'goodnight';
      }
    }
    
    if (urgentFarewells.any((f) => lowerMessage.contains(f))) {
      result['isFarewell'] = true;
      result['type'] = 'urgent';
      result['urgency'] = 'high';
    }

    return result;
  }

  /// 칭찬 패턴 감지
  Map<String, dynamic> detectComplimentPattern(String message) {
    final lowerMessage = message.toLowerCase();
    final result = <String, dynamic>{
      'isCompliment': false,
      'type': 'none',
      'target': null,
      'intensity': 0.0,
    };

    final appearanceCompliments = ['예뻐', '예쁘', '귀여', '귀엽', '잘생', '멋있', '멋져'];
    final abilityCompliments = ['잘해', '잘한다', '최고', '대박', '짱', '굿', '대단'];
    final personalityCompliments = ['착해', '친절', '좋아', '멋져', '사랑스러'];

    if (appearanceCompliments.any((c) => lowerMessage.contains(c))) {
      result['isCompliment'] = true;
      result['type'] = 'appearance';
      result['target'] = 'looks';
      result['intensity'] = 0.8;
    } else if (abilityCompliments.any((c) => lowerMessage.contains(c))) {
      result['isCompliment'] = true;
      result['type'] = 'ability';
      result['target'] = 'skill';
      result['intensity'] = 0.7;
    } else if (personalityCompliments.any((c) => lowerMessage.contains(c))) {
      result['isCompliment'] = true;
      result['type'] = 'personality';
      result['target'] = 'character';
      result['intensity'] = 0.9;
    }

    return result;
  }

  /// 추임새/짧은 반응 패턴 감지
  Map<String, dynamic> detectSimpleReactionPattern(String message) {
    final result = <String, dynamic>{
      'isSimpleReaction': false,
      'type': 'none',
      'emotion': 'neutral',
    };

    // 긍정적 추임새
    final positiveReactions = ['ㅇㅇ', 'ㅇㅋ', '응', '어', '네', '넹', '넵', '그래', 'ㅇㅎ'];
    // 부정적 추임새
    final negativeReactions = ['ㄴㄴ', '아니', '노', '싫어', 'ㅡㅡ', '아님'];
    // 놀람 추임새
    final surpriseReactions = ['헐', '헉', '대박', '우와', '와우', '오', '오오'];
    // 웃음 추임새
    final laughReactions = ['ㅋㅋ', 'ㅎㅎ', 'ㅋ', 'ㅎ'];
    // 슬픔 추임새
    final sadReactions = ['ㅠㅠ', 'ㅜㅜ', 'ㅠ', 'ㅜ'];

    // 3글자 이하이면서 특수문자/자음으로 구성된 경우
    if (message.length <= 3) {
      if (positiveReactions.contains(message)) {
        result['isSimpleReaction'] = true;
        result['type'] = 'agreement';
        result['emotion'] = 'positive';
      } else if (negativeReactions.contains(message)) {
        result['isSimpleReaction'] = true;
        result['type'] = 'disagreement';
        result['emotion'] = 'negative';
      } else if (surpriseReactions.contains(message)) {
        result['isSimpleReaction'] = true;
        result['type'] = 'surprise';
        result['emotion'] = 'surprised';
      } else if (laughReactions.any((r) => message.contains(r))) {
        result['isSimpleReaction'] = true;
        result['type'] = 'laugh';
        result['emotion'] = 'amused';
      } else if (sadReactions.any((r) => message.contains(r))) {
        result['isSimpleReaction'] = true;
        result['type'] = 'sad';
        result['emotion'] = 'sad';
      }
      
      // 물음표/느낌표만 있는 경우
      if (RegExp(r'^[?!.]+$').hasMatch(message)) {
        result['isSimpleReaction'] = true;
        result['type'] = 'punctuation';
        result['emotion'] = message.contains('?') ? 'curious' : 'emphatic';
      }
    }

    return result;
  }

  /// 질문 유형 상세 분석
  Map<String, dynamic> analyzeQuestionPattern(String message) {
    final lowerMessage = message.toLowerCase();
    final result = <String, dynamic>{
      'isQuestion': false,
      'type': 'none',
      'expectsDetailedAnswer': false,
      'isRhetorical': false,
      'urgency': 'normal',
      'impliedContext': null,
    };

    // 의문사 체크
    final questionWords = ['뭐', '어디', '언제', '누구', '왜', '어떻게', '얼마', '몇', '어느'];
    final hasQuestionWord = questionWords.any((w) => lowerMessage.contains(w));
    
    // 의문형 어미 체크 (개선됨)
    final questionEndings = ['니', '나요', '까', '까요', '어요', '을까', '는지', '은지', '나', '냐', '지', '죠', '는?', '은?'];
    final hasQuestionEnding = questionEndings.any((e) => 
      lowerMessage.endsWith(e) || 
      lowerMessage.endsWith(e + '?') ||
      lowerMessage.contains(e)  // "하연이는?" 같은 패턴 감지
    );
    
    // 물음표 체크
    final hasQuestionMark = message.contains('?');

    if (hasQuestionWord || hasQuestionEnding || hasQuestionMark) {
      result['isQuestion'] = true;
      
      // 🔥 NEW: "~는?" 패턴 특별 처리
      if (message.contains('는?') || message.contains('은?')) {
        result['type'] = 'echo_question';  // 되물음 타입
        result['expectsDetailedAnswer'] = false;
        result['impliedContext'] = 'same_topic_inquiry';  // 동일 주제 되물음
      }
      // 질문 유형 분류
      else if (lowerMessage.contains('왜')) {
        result['type'] = 'why';
        result['expectsDetailedAnswer'] = true;
      } else if (lowerMessage.contains('어떻게')) {
        result['type'] = 'how';
        result['expectsDetailedAnswer'] = true;
      } else if (lowerMessage.contains('뭐') || lowerMessage.contains('무엇')) {
        result['type'] = 'what';
        // 🔥 NEW: "뭐할" 패턴 감지
        if (lowerMessage.contains('뭐할') || lowerMessage.contains('뭐 할')) {
          result['impliedContext'] = 'activity_plan';
        }
      } else if (lowerMessage.contains('언제')) {
        result['type'] = 'when';
      } else if (lowerMessage.contains('어디')) {
        result['type'] = 'where';
      } else if (lowerMessage.contains('누구')) {
        result['type'] = 'who';
      } else if (lowerMessage.endsWith('지?') || lowerMessage.endsWith('죠?')) {
        result['type'] = 'confirmation';
        result['isRhetorical'] = true;
      } else if (lowerMessage.contains('어때') || lowerMessage.contains('어떠')) {
        result['type'] = 'opinion';
      } else {
        result['type'] = 'general';
      }
      
      // 긴급도 평가
      if (message.contains('빨리') || message.contains('급해') || message.contains('!!')) {
        result['urgency'] = 'high';
      }
    }

    return result;
  }

  /// 회피 패턴 감지
  Map<String, dynamic> detectAvoidancePattern(String message) {
    final lowerMessage = message.toLowerCase();
    final result = <String, dynamic>{
      'isAvoidance': false,
      'type': 'none',
      'severity': 0.0,
    };

    final directAvoidance = ['그런거 말고', '다른 얘기', '패스', '스킵', '그만'];
    final indirectAvoidance = ['모르겠', '글쎄', '음...', '어...', '그냥'];
    final topicChange = ['그런데', '근데 말야', '아 맞다', '참고로'];

    if (directAvoidance.any((a) => lowerMessage.contains(a))) {
      result['isAvoidance'] = true;
      result['type'] = 'direct';
      result['severity'] = 0.8;
    } else if (indirectAvoidance.any((a) => lowerMessage.contains(a))) {
      result['isAvoidance'] = true;
      result['type'] = 'indirect';
      result['severity'] = 0.5;
    } else if (topicChange.any((a) => lowerMessage.contains(a))) {
      result['isAvoidance'] = true;
      result['type'] = 'topic_change';
      result['severity'] = 0.3;
    }

    return result;
  }

  /// 언어 감지
  Map<String, dynamic> detectLanguagePattern(String message) {
    final result = <String, dynamic>{
      'primaryLanguage': 'ko',
      'hasMultipleLanguages': false,
      'languages': <String>[],
      'needsTranslation': false,
    };

    // 한국어 체크
    if (RegExp(r'[가-힣ㄱ-ㅎㅏ-ㅣ]').hasMatch(message)) {
      result['languages'].add('ko');
    }
    
    // 영어 체크
    if (RegExp(r'[a-zA-Z]').hasMatch(message)) {
      result['languages'].add('en');
      
      // 순수 영어 문장인지 체크
      if (!RegExp(r'[가-힣ㄱ-ㅎㅏ-ㅣ]').hasMatch(message) && 
          message.trim().split(' ').length >= 2) {
        result['primaryLanguage'] = 'en';
        result['needsTranslation'] = true;
      }
    }
    
    // 일본어 체크
    if (RegExp(r'[\u3040-\u309F\u30A0-\u30FF]').hasMatch(message)) {
      result['languages'].add('ja');
      result['needsTranslation'] = true;
    }
    
    // 중국어 체크
    if (RegExp(r'[\u4E00-\u9FFF]').hasMatch(message) &&
        !RegExp(r'[\u3040-\u309F\u30A0-\u30FF]').hasMatch(message)) {
      result['languages'].add('zh');
      result['needsTranslation'] = true;
    }

    result['hasMultipleLanguages'] = result['languages'].length > 1;
    
    return result;
  }

  /// 부적절한 메시지 패턴 감지
  Map<String, dynamic> detectInappropriatePattern(String message) {
    final lowerMessage = message.toLowerCase();
    final result = <String, dynamic>{
      'isInappropriate': false,
      'type': 'none',
      'severity': 0.0,
      'reason': null,
    };

    // 욕설/비속어
    final profanity = ['씨발', '시발', 'ㅅㅂ', '병신', 'ㅂㅅ', '개새'];
    // 공격적 표현
    final aggressive = ['죽어', '꺼져', '닥쳐', '재수없'];
    // 성적 표현
    final sexual = ['섹스', '야동', '19금'];
    
    if (profanity.any((p) => lowerMessage.contains(p))) {
      result['isInappropriate'] = true;
      result['type'] = 'profanity';
      result['severity'] = 0.9;
      result['reason'] = 'contains_profanity';
    } else if (aggressive.any((a) => lowerMessage.contains(a))) {
      result['isInappropriate'] = true;
      result['type'] = 'aggressive';
      result['severity'] = 0.8;
      result['reason'] = 'aggressive_language';
    } else if (sexual.any((s) => lowerMessage.contains(s))) {
      result['isInappropriate'] = true;
      result['type'] = 'sexual';
      result['severity'] = 0.7;
      result['reason'] = 'sexual_content';
    }
    
    // 의미 없는 문자 반복 (스팸)
    if (RegExp(r'(.)\1{9,}').hasMatch(message)) {
      result['isInappropriate'] = true;
      result['type'] = 'spam';
      result['severity'] = 0.5;
      result['reason'] = 'character_spam';
    }

    return result;
  }

  /// 이모지 전용 메시지 감지
  Map<String, dynamic> detectEmojiOnlyPattern(String message) {
    final result = <String, dynamic>{
      'isEmojiOnly': false,
      'emojiCount': 0,
      'dominantEmotion': 'neutral',
    };

    // 이모지와 공백만 남기고 제거
    final withoutEmoji = message.replaceAll(RegExp(r'[\u{1F000}-\u{1F9FF}]', unicode: true), '');
    final withoutSpaces = withoutEmoji.trim();
    
    if (withoutSpaces.isEmpty && message.isNotEmpty) {
      result['isEmojiOnly'] = true;
      
      // 이모지 개수 세기
      final emojiMatches = RegExp(r'[\u{1F000}-\u{1F9FF}]', unicode: true).allMatches(message);
      result['emojiCount'] = emojiMatches.length;
      
      // 감정 분석 (간단한 버전)
      if (message.contains('😊') || message.contains('😄') || message.contains('❤️')) {
        result['dominantEmotion'] = 'positive';
      } else if (message.contains('😢') || message.contains('😭') || message.contains('💔')) {
        result['dominantEmotion'] = 'sad';
      } else if (message.contains('😡') || message.contains('😤')) {
        result['dominantEmotion'] = 'angry';
      }
    }

    return result;
  }

  /// 사과 패턴 감지
  Map<String, dynamic> detectApologyPattern(String message) {
    final result = <String, dynamic>{
      'isApology': false,
      'intensity': 'none', // light, moderate, strong
      'type': 'none', // casual, formal, sincere
    };

    final lowerMessage = message.toLowerCase();
    
    // 강한 사과
    final strongApologies = ['정말 미안', '진짜 미안', '너무 미안', '죄송합니다', '정말 죄송'];
    for (final pattern in strongApologies) {
      if (lowerMessage.contains(pattern)) {
        result['isApology'] = true;
        result['intensity'] = 'strong';
        result['type'] = pattern.contains('죄송') ? 'formal' : 'sincere';
        return result;
      }
    }
    
    // 중간 사과
    final moderateApologies = ['미안해', '미안', '미안하다', '죄송해', '죄송', 'sorry'];
    for (final pattern in moderateApologies) {
      if (lowerMessage.contains(pattern)) {
        result['isApology'] = true;
        result['intensity'] = 'moderate';
        result['type'] = pattern.contains('죄송') ? 'formal' : 'casual';
        return result;
      }
    }
    
    // 가벼운 사과
    final lightApologies = ['미안ㅠ', '미안ㅜ', '쏘리', '소리', 'sry'];
    for (final pattern in lightApologies) {
      if (lowerMessage.contains(pattern)) {
        result['isApology'] = true;
        result['intensity'] = 'light';
        result['type'] = 'casual';
        return result;
      }
    }
    
    return result;
  }

  /// 감사 표현 패턴 감지 (개선된 버전)
  Map<String, dynamic> detectGratitudePattern(String message) {
    final result = <String, dynamic>{
      'isGratitude': false,
      'intensity': 'none', // light, moderate, strong
      'formality': 'casual', // casual, formal
    };

    final lowerMessage = message.toLowerCase();
    
    // 강한 감사
    final strongGratitude = ['정말 고마워', '너무 고마워', '진짜 고마워', '정말 감사', '너무 감사'];
    for (final pattern in strongGratitude) {
      if (lowerMessage.contains(pattern)) {
        result['isGratitude'] = true;
        result['intensity'] = 'strong';
        result['formality'] = pattern.contains('감사') ? 'formal' : 'casual';
        return result;
      }
    }
    
    // 중간 감사
    final moderateGratitude = ['고마워', '고맙다', '감사해', '감사합니다', 'thanks', 'thank you'];
    for (final pattern in moderateGratitude) {
      if (lowerMessage.contains(pattern)) {
        result['isGratitude'] = true;
        result['intensity'] = 'moderate';
        result['formality'] = pattern.contains('감사') || pattern.contains('합니다') ? 'formal' : 'casual';
        return result;
      }
    }
    
    // 가벼운 감사
    final lightGratitude = ['고마', '땡큐', '땡스', 'thx', 'ty'];
    for (final pattern in lightGratitude) {
      if (lowerMessage.contains(pattern)) {
        result['isGratitude'] = true;
        result['intensity'] = 'light';
        result['formality'] = 'casual';
        return result;
      }
    }
    
    return result;
  }

  /// 요청/부탁 패턴 감지
  Map<String, dynamic> detectRequestPattern(String message) {
    final result = <String, dynamic>{
      'isRequest': false,
      'politeness': 'neutral', // polite, neutral, command
      'urgency': 'normal', // urgent, normal, casual
    };

    final lowerMessage = message.toLowerCase();
    
    // 공손한 요청
    if (lowerMessage.contains('해주실') || lowerMessage.contains('해주세요') || 
        lowerMessage.contains('부탁드려') || lowerMessage.contains('가능할까요')) {
      result['isRequest'] = true;
      result['politeness'] = 'polite';
      return result;
    }
    
    // 일반 요청
    if (lowerMessage.contains('해줘') || lowerMessage.contains('해줄래') || 
        lowerMessage.contains('부탁') || lowerMessage.contains('좀')) {
      result['isRequest'] = true;
      result['politeness'] = 'neutral';
      
      // 긴급도 체크
      if (lowerMessage.contains('빨리') || lowerMessage.contains('급해') || lowerMessage.contains('지금')) {
        result['urgency'] = 'urgent';
      }
      return result;
    }
    
    // 명령조
    if ((lowerMessage.contains('해') || lowerMessage.contains('하라')) && 
        lowerMessage.endsWith('해') || lowerMessage.endsWith('해라')) {
      result['isRequest'] = true;
      result['politeness'] = 'command';
      return result;
    }
    
    return result;
  }

  /// 동의/반대 패턴 감지
  Map<String, dynamic> detectAgreementPattern(String message) {
    final result = <String, dynamic>{
      'isAgreement': false,
      'type': 'none', // agreement, disagreement, partial
      'strength': 'none', // strong, moderate, weak
    };

    final lowerMessage = message.toLowerCase();
    
    // 강한 동의
    final strongAgreement = ['완전 맞아', '정말 그래', '진짜 맞아', '당연하지', '백퍼'];
    for (final pattern in strongAgreement) {
      if (lowerMessage.contains(pattern)) {
        result['isAgreement'] = true;
        result['type'] = 'agreement';
        result['strength'] = 'strong';
        return result;
      }
    }
    
    // 일반 동의
    final moderateAgreement = ['맞아', '그래', '그렇지', '그런가봐', '그런듯', '동의'];
    for (final pattern in moderateAgreement) {
      if (lowerMessage.contains(pattern)) {
        result['isAgreement'] = true;
        result['type'] = 'agreement';
        result['strength'] = 'moderate';
        return result;
      }
    }
    
    // 부분 동의
    if (lowerMessage.contains('그럴수도') || lowerMessage.contains('어느정도') || 
        lowerMessage.contains('일리있') || lowerMessage.contains('그런면도')) {
      result['isAgreement'] = true;
      result['type'] = 'partial';
      result['strength'] = 'weak';
      return result;
    }
    
    // 반대
    final disagreement = ['아니야', '아니', '틀려', '그건 아니', '안그래', '반대'];
    for (final pattern in disagreement) {
      if (lowerMessage.contains(pattern)) {
        result['isAgreement'] = true;
        result['type'] = 'disagreement';
        result['strength'] = lowerMessage.contains('절대') || lowerMessage.contains('전혀') ? 'strong' : 'moderate';
        return result;
      }
    }
    
    return result;
  }

  /// 농담/유머 패턴 감지
  Map<String, dynamic> detectHumorPattern(String message) {
    final result = <String, dynamic>{
      'isHumor': false,
      'type': 'none', // joke, sarcasm, playful
      'intensity': 'none', // light, moderate, heavy
    };

    final lowerMessage = message.toLowerCase();
    
    // ㅋㅋㅋ 개수로 강도 판단
    final kCount = 'ㅋ'.allMatches(message).length;
    if (kCount >= 4) {
      result['isHumor'] = true;
      result['type'] = 'playful';
      result['intensity'] = 'heavy';
      return result;
    } else if (kCount >= 2) {
      result['isHumor'] = true;
      result['type'] = 'playful';
      result['intensity'] = 'moderate';
    }
    
    // 농담 키워드
    if (lowerMessage.contains('농담') || lowerMessage.contains('장난') || 
        lowerMessage.contains('웃기') || lowerMessage.contains('개그')) {
      result['isHumor'] = true;
      result['type'] = 'joke';
      result['intensity'] = 'moderate';
      return result;
    }
    
    // 반어법/빈정
    if (lowerMessage.contains('하하') || lowerMessage.contains('ㅎㅎ')) {
      if (lowerMessage.contains('진짜') || lowerMessage.contains('완전')) {
        result['isHumor'] = true;
        result['type'] = 'sarcasm';
        result['intensity'] = 'light';
      }
    }
    
    return result;
  }

  /// 매크로/봇 의심 패턴 감지
  Map<String, dynamic> detectMacroPattern(String message) {
    final result = <String, dynamic>{
      'isMacroQuestion': false,
      'confidence': 0.0,
      'type': 'none', // direct, indirect, accusation
    };
    
    final lower = message.toLowerCase();
    
    // 직접적인 매크로/봇 질문
    if (lower.contains('macro') || lower.contains('매크로') || 
        lower.contains('bot') || lower.contains('봇')) {
      result['isMacroQuestion'] = true;
      result['confidence'] = 0.9;
      result['type'] = 'direct';
      return result;
    }
    
    // "r u macro?", "are you macro?" 등
    if ((lower.contains('r u') || lower.contains('are you')) && 
        (lower.contains('macro') || lower.contains('bot'))) {
      result['isMacroQuestion'] = true;
      result['confidence'] = 1.0;
      result['type'] = 'direct';
      return result;
    }
    
    // 간접적 의심
    if (lower.contains('진짜 사람') || lower.contains('사람이야') ||
        lower.contains('사람 맞아') || lower.contains('자동응답')) {
      result['isMacroQuestion'] = true;
      result['confidence'] = 0.7;
      result['type'] = 'indirect';
      return result;
    }
    
    // 같은 말 반복 지적
    if (lower.contains('똑같은 말') || lower.contains('반복') ||
        lower.contains('계속 같은')) {
      result['isMacroQuestion'] = true;
      result['confidence'] = 0.6;
      result['type'] = 'accusation';
    }
    
    return result;
  }
  
  /// AI 의심 패턴 감지
  Map<String, dynamic> detectAIPattern(String message) {
    final result = <String, dynamic>{
      'isAIQuestion': false,
      'confidence': 0.0,
      'type': 'none', // direct, indirect, technical
    };
    
    final lower = message.toLowerCase();
    
    // 직접적인 AI 질문
    if (lower.contains('ai') || lower.contains('인공지능') || 
        lower.contains('artificial') || lower.contains('gpt') ||
        lower.contains('챗봇') || lower.contains('chatbot')) {
      result['isAIQuestion'] = true;
      result['confidence'] = 0.9;
      result['type'] = 'direct';
      return result;
    }
    
    // "r u ai?", "are you ai?" 등
    if ((lower.contains('r u') || lower.contains('are you')) && 
        (lower.contains('ai') || lower.contains('artificial'))) {
      result['isAIQuestion'] = true;
      result['confidence'] = 1.0;
      result['type'] = 'direct';
      return result;
    }
    
    // 기술적 질문
    if (lower.contains('프로그램') || lower.contains('알고리즘') ||
        lower.contains('코드') || lower.contains('시스템')) {
      result['isAIQuestion'] = true;
      result['confidence'] = 0.5;
      result['type'] = 'technical';
      return result;
    }
    
    // 간접적 질문
    if (lower.contains('진짜야') || lower.contains('가짜') ||
        lower.contains('만들어진')) {
      result['isAIQuestion'] = true;
      result['confidence'] = 0.6;
      result['type'] = 'indirect';
    }
    
    return result;
  }
  
  /// 놀람/감탄 패턴 감지
  Map<String, dynamic> detectSurprisePattern(String message) {
    final result = <String, dynamic>{
      'isSurprise': false,
      'type': 'none', // shock, amazement, disbelief
      'sentiment': 'neutral', // positive, negative, neutral
    };

    final lowerMessage = message.toLowerCase();
    
    // 충격
    final shockPatterns = ['헉', '헐', '어떻게', '말도안돼', '충격'];
    for (final pattern in shockPatterns) {
      if (lowerMessage.contains(pattern)) {
        result['isSurprise'] = true;
        result['type'] = 'shock';
        result['sentiment'] = pattern == '헐' ? 'negative' : 'neutral';
        return result;
      }
    }
    
    // 감탄
    final amazementPatterns = ['대박', '와', '우와', '짱', '최고', '굿'];
    for (final pattern in amazementPatterns) {
      if (lowerMessage.contains(pattern)) {
        result['isSurprise'] = true;
        result['type'] = 'amazement';
        result['sentiment'] = 'positive';
        return result;
      }
    }
    
    // 의심/불신
    final disbeliefPatterns = ['진짜?', '정말?', '설마', '에이', '거짓말'];
    for (final pattern in disbeliefPatterns) {
      if (lowerMessage.contains(pattern)) {
        result['isSurprise'] = true;
        result['type'] = 'disbelief';
        result['sentiment'] = 'neutral';
        return result;
      }
    }
    
    return result;
  }

  /// 확인/되묻기 패턴 감지
  Map<String, dynamic> detectConfirmationPattern(String message) {
    final result = <String, dynamic>{
      'isConfirmation': false,
      'type': 'none', // simple, doubt, clarification
      'needsResponse': false,
    };

    final lowerMessage = message.toLowerCase();
    
    // 단순 확인
    final simpleConfirmation = ['진짜?', '정말?', '맞아?', '그래?', '응?'];
    for (final pattern in simpleConfirmation) {
      if (lowerMessage == pattern || lowerMessage == pattern.replaceAll('?', '')) {
        result['isConfirmation'] = true;
        result['type'] = 'simple';
        result['needsResponse'] = true;
        return result;
      }
    }
    
    // 의심 확인
    if (lowerMessage.contains('진짜로') || lowerMessage.contains('정말로') || 
        lowerMessage.contains('확실해') || lowerMessage.contains('장담')) {
      result['isConfirmation'] = true;
      result['type'] = 'doubt';
      result['needsResponse'] = true;
      return result;
    }
    
    // 명확화 요청
    if (lowerMessage.contains('무슨 말') || lowerMessage.contains('뭔 소리') || 
        lowerMessage.contains('다시 말해') || lowerMessage.contains('뭐라고')) {
      result['isConfirmation'] = true;
      result['type'] = 'clarification';
      result['needsResponse'] = true;
      return result;
    }
    
    return result;
  }

  /// 관심 표현 패턴 감지
  Map<String, dynamic> detectInterestPattern(String message) {
    final result = <String, dynamic>{
      'isInterested': false,
      'level': 'none', // high, moderate, low
      'wantsMore': false,
    };

    final lowerMessage = message.toLowerCase();
    
    // 높은 관심
    final highInterest = ['더 말해', '자세히', '궁금해', '알려줘', '계속'];
    for (final pattern in highInterest) {
      if (lowerMessage.contains(pattern)) {
        result['isInterested'] = true;
        result['level'] = 'high';
        result['wantsMore'] = true;
        return result;
      }
    }
    
    // 중간 관심
    final moderateInterest = ['그래서', '그리고', '어떻게', '왜'];
    for (final pattern in moderateInterest) {
      if (lowerMessage.contains(pattern) && lowerMessage.contains('?')) {
        result['isInterested'] = true;
        result['level'] = 'moderate';
        result['wantsMore'] = true;
        return result;
      }
    }
    
    // 낮은 관심
    if (lowerMessage.contains('아 그래') || lowerMessage.contains('그렇구나') || 
        lowerMessage.contains('신기하네')) {
      result['isInterested'] = true;
      result['level'] = 'low';
      result['wantsMore'] = false;
    }
    
    return result;
  }

  /// TMI/과도한 설명 패턴 감지
  Map<String, dynamic> detectTMIPattern(String message) {
    final result = <String, dynamic>{
      'isTMI': false,
      'type': 'none', // list, detailed, rambling
      'length': 'normal', // short, normal, long, very_long
    };

    // 길이 체크
    if (message.length > 500) {
      result['length'] = 'very_long';
      result['isTMI'] = true;
    } else if (message.length > 200) {
      result['length'] = 'long';
    } else if (message.length < 20) {
      result['length'] = 'short';
      return result;
    }
    
    // 나열식 (번호나 불릿 포인트)
    if (RegExp(r'[1-9]\.|•|·|-\s').hasMatch(message)) {
      result['isTMI'] = true;
      result['type'] = 'list';
      return result;
    }
    
    // 과도한 세부사항 (그리고, 그래서 반복)
    final andCount = '그리고'.allMatches(message).length + '그래서'.allMatches(message).length;
    if (andCount >= 3) {
      result['isTMI'] = true;
      result['type'] = 'rambling';
      return result;
    }
    
    // 긴 설명
    if (message.length > 150 && (message.contains('설명') || message.contains('이야기'))) {
      result['isTMI'] = true;
      result['type'] = 'detailed';
    }
    
    return result;
  }

  /// 화제 전환 패턴 감지
  Map<String, dynamic> detectTopicChangePattern(String message) {
    final result = <String, dynamic>{
      'isTopicChange': false,
      'type': 'none', // smooth, abrupt, related
      'marker': '', // 전환 표시어
    };

    final lowerMessage = message.toLowerCase();
    
    // 부드러운 전환
    final smoothMarkers = ['그런데', '그건 그렇고', '아 맞다', '참', '그러고보니'];
    for (final marker in smoothMarkers) {
      if (lowerMessage.contains(marker)) {
        result['isTopicChange'] = true;
        result['type'] = 'smooth';
        result['marker'] = marker;
        return result;
      }
    }
    
    // 급격한 전환
    final abruptMarkers = ['근데', '갑자기', '아무튼', '어쨌든'];
    for (final marker in abruptMarkers) {
      if (lowerMessage.startsWith(marker)) {
        result['isTopicChange'] = true;
        result['type'] = 'abrupt';
        result['marker'] = marker;
        return result;
      }
    }
    
    // 연관 전환
    if (lowerMessage.contains('그러면') || lowerMessage.contains('그럼') || 
        lowerMessage.contains('혹시')) {
      result['isTopicChange'] = true;
      result['type'] = 'related';
      result['marker'] = '연관 주제';
    }
    
    return result;
  }
  
  /// 외국어 질문 감지 메서드 추가
  bool detectForeignLanguageQuestion(String message) {
    final lowerMessage = message.toLowerCase();

    // 한글이 거의 없는 경우 외국어로 판단
    int koreanCharCount = 0;
    int totalCharCount = 0;
    for (final char in message.runes) {
      if (char >= 0xAC00 && char <= 0xD7AF) {
        // 한글 유니코드 범위
        koreanCharCount++;
      }
      if (char != 32 && char != 10 && char != 13) {
        // 공백과 줄바꿈 제외
        totalCharCount++;
      }
    }

    if (totalCharCount > 0) {
      final koreanRatio = koreanCharCount / totalCharCount;
      // 한국어가 10% 미만이면 외국어로 판단
      if (koreanRatio < 0.1) {
        return true;
      }
    }

    // 영어 문장 패턴 감지 (알파벳과 숫자가 대부분인 경우)
    final englishPattern = RegExp(r'[a-zA-Z]');
    final englishCount = englishPattern.allMatches(message).length;
    if (englishCount > 0 && totalCharCount > 0) {
      final englishRatio = englishCount / totalCharCount;
      // 영어가 50% 이상이면 외국어로 판단
      if (englishRatio > 0.5 && message.trim().length >= 2) {
        return true;
      }
    }
    
    // 일본어 감지 (히라가나, 가타카나, 간지)
    if (RegExp(r'[\u3040-\u309F\u30A0-\u30FF\u4E00-\u9FAF]').hasMatch(message)) {
      return true;
    }
    
    // 중국어 감지 (간체/번체) - 일본어와 겹치는 간지 제외
    if (!RegExp(r'[\u3040-\u309F\u30A0-\u30FF]').hasMatch(message) && 
        RegExp(r'[\u4E00-\u9FFF]').hasMatch(message)) {
      return true;
    }
    
    // 스페인어/프랑스어/독일어 특수문자 감지
    if (RegExp(r'[àáâãäåèéêëìíîïòóôõöùúûüýÿñçßÀÁÂÃÄÅÈÉÊËÌÍÎÏÒÓÔÕÖÙÚÛÜÝŸÑÇ]').hasMatch(message)) {
      return true;
    }
    
    // 러시아어 (키릴 문자) 감지
    if (RegExp(r'[\u0400-\u04FF]').hasMatch(message)) {
      return true;
    }
    
    // 아랍어 감지
    if (RegExp(r'[\u0600-\u06FF\u0750-\u077F]').hasMatch(message)) {
      return true;
    }
    
    // 태국어 감지
    if (RegExp(r'[\u0E00-\u0E7F]').hasMatch(message)) {
      return true;
    }
    
    // 베트남어 감지 (성조 기호)
    if (RegExp(r'[àáảãạăằắẳẵặâầấẩẫậèéẻẽẹêềếểễệìíỉĩịòóỏõọôồốổỗộơờớởỡợùúủũụưừứửữựỳýỷỹỵđĐ]').hasMatch(message)) {
      return true;
    }
    
    // 힌디어 (데바나가리) 감지
    if (RegExp(r'[\u0900-\u097F]').hasMatch(message)) {
      return true;
    }

    return false;
  }
  
  // ==================== 🔥 NEW: 눈치 백단 기능들 ====================
  
  /// 암시적 감정 감지 - 직접 표현하지 않은 감정 읽기
  Map<String, dynamic> _detectImplicitEmotion(String message, List<Message> chatHistory) {
    final result = <String, dynamic>{
      'emotion': 'neutral',
      'confidence': 0.0,
      'reason': '',
      'signals': <String>[],
    };
    
    // 1. "오늘 회사 일찍 나왔어" → 힘든 일 있었을 가능성
    if (message.contains('일찍') && (message.contains('회사') || message.contains('학교'))) {
      result['emotion'] = 'stressed';
      result['confidence'] = 0.75;
      result['reason'] = '평소와 다른 퇴근/하교 시간';
      result['signals'].add('early_leave');
    }
    
    // 2. "밥 안 먹었어" / "안 먹어" → 우울하거나 바쁨
    if ((message.contains('안 먹') || message.contains('안먹')) && 
        (message.contains('밥') || message.contains('아침') || message.contains('점심') || message.contains('저녁'))) {
      result['emotion'] = 'depressed_or_busy';
      result['confidence'] = 0.7;
      result['reason'] = '식사 거름 = 정서적 문제 또는 과도한 업무';
      result['signals'].add('skipped_meal');
    }
    
    // 3. "그냥..." / "별로..." → 말하기 싫은 무언가
    if (message.startsWith('그냥') || message.startsWith('별로')) {
      if (message.contains('...') || message.length < 10) {
        result['emotion'] = 'avoiding';
        result['confidence'] = 0.85;
        result['reason'] = '회피성 답변 패턴';
        result['signals'].add('avoidance_pattern');
      }
    }
    
    // 4. 짧은 답변 + 평소보다 느낌표/이모티콘 없음 → 기분 안 좋음
    if (message.length < 10 && !message.contains('!') && !message.contains('ㅎ') && !message.contains('ㅋ')) {
      // 최근 메시지와 비교
      final recentUserMessages = chatHistory.where((m) => m.isFromUser).take(5).toList();
      if (recentUserMessages.isNotEmpty) {
        final avgLength = recentUserMessages.map((m) => m.content.length).reduce((a, b) => a + b) ~/ recentUserMessages.length;
        if (message.length < avgLength * 0.5) {
          result['emotion'] = 'low_mood';
          result['confidence'] = 0.65;
          result['reason'] = '평소보다 현저히 짧은 답변';
          result['signals'].add('short_response');
        }
      }
    }
    
    // 5. "괜찮아" / "아니야" 반복 → 실제로는 괜찮지 않음
    if ((message.contains('괜찮') || message.contains('아니야') || message.contains('아무것도')) && 
        message.length < 15) {
      result['emotion'] = 'hiding_feelings';
      result['confidence'] = 0.6;
      result['reason'] = '감정 숨기기 패턴';
      result['signals'].add('denial_pattern');
    }
    
    // 6. 새벽 시간 + "못 자" / "안 자" → 고민이나 불면
    final hour = DateTime.now().hour;
    if ((hour >= 1 && hour <= 5) && (message.contains('못 자') || message.contains('안 자') || message.contains('잠이'))) {
      result['emotion'] = 'worried_insomnia';
      result['confidence'] = 0.8;
      result['reason'] = '새벽 불면 = 고민 또는 스트레스';
      result['signals'].add('late_night_awake');
    }
    
    return result;
  }
  
  /// 행간 읽기 - 말하지 않은 것에서 의미 찾기
  Map<String, dynamic> _readBetweenTheLines(String message, List<Message> chatHistory) {
    final interpretation = <String, dynamic>{
      'hiddenMeaning': '',
      'confidence': 0.0,
      'patterns': <String>[],
    };
    
    // 1. 갑자기 주제 전환 → 이전 주제가 불편함
    if (chatHistory.isNotEmpty) {
      final lastUserMsg = chatHistory.lastWhere((m) => m.isFromUser, orElse: () => Message(
        id: 'temp_id',
        personaId: '',
        content: '',
        type: MessageType.text,
        isFromUser: true,
        timestamp: DateTime.now(),
      ));
      final lastTopic = _extractMainTopic(lastUserMsg.content);
      final currentTopic = _extractMainTopic(message);
      
      if (lastTopic != currentTopic && lastTopic.isNotEmpty && currentTopic.isNotEmpty) {
        if (message.contains('그런데') || message.contains('근데') || message.contains('아 맞다')) {
          interpretation['hiddenMeaning'] = '이전 주제($lastTopic)가 불편하거나 부담스러움';
          interpretation['confidence'] = 0.7;
          interpretation['patterns'].add('sudden_topic_change');
        }
      }
    }
    
    // 2. 질문에 질문으로 답 → 대답하기 싫음
    if (chatHistory.isNotEmpty) {
      final lastAIMsg = chatHistory.lastWhere((m) => !m.isFromUser, orElse: () => Message(
        id: 'temp_id',
        personaId: '',
        content: '',
        type: MessageType.text,
        isFromUser: false,
        timestamp: DateTime.now(),
      ));
      if (lastAIMsg.content.contains('?') && message.contains('?')) {
        interpretation['hiddenMeaning'] = '질문에 답하고 싶지 않아서 화제 전환 시도';
        interpretation['confidence'] = 0.65;
        interpretation['patterns'].add('question_deflection');
      }
    }
    
    // 3. "ㅇㅇ" / "ㅇㅋ" 같은 초단답 → 대화 의욕 없음
    if (message == 'ㅇㅇ' || message == 'ㅇㅋ' || message == 'ㄱㅅ' || message == 'ㄴㄴ') {
      interpretation['hiddenMeaning'] = '대화하고 싶지 않지만 예의상 답변';
      interpretation['confidence'] = 0.8;
      interpretation['patterns'].add('minimal_response');
    }
    
    // 4. "..." 많이 사용 → 말하기 어려운 무언가
    final ellipsisCount = '...'.allMatches(message).length;
    if (ellipsisCount >= 2) {
      interpretation['hiddenMeaning'] = '망설임, 고민, 또는 말하기 어려운 상황';
      interpretation['confidence'] = 0.75;
      interpretation['patterns'].add('hesitation');
    }
    
    // 5. 평소와 다른 말투 → 감정 변화
    if (chatHistory.length > 5) {
      final recentMessages = chatHistory.where((m) => m.isFromUser).take(10).map((m) => m.content).toList();
      final hasEmoticon = recentMessages.any((m) => m.contains('ㅎ') || m.contains('ㅋ') || m.contains('~'));
      final currentHasEmoticon = message.contains('ㅎ') || message.contains('ㅋ') || message.contains('~');
      
      if (hasEmoticon && !currentHasEmoticon) {
        interpretation['hiddenMeaning'] = '평소보다 기분이 가라앉음';
        interpretation['confidence'] = 0.6;
        interpretation['patterns'].add('mood_drop');
      }
    }
    
    return interpretation;
  }
  
  /// 미세 감정 신호 감지
  Map<String, dynamic> _detectMicroEmotionalSignals(String message) {
    final signals = <String, dynamic>{
      'punctuation': _analyzePunctuation(message),
      'length': _analyzeMessageLength(message),
      'timing': _analyzeResponseTiming(),
      'emoticons': _analyzeEmoticonUsage(message),
      'interpretation': '',
    };
    
    // 종합 해석
    String interpretation = '';
    
    // 느낌표 개수로 흥분도 측정
    if (signals['punctuation']['exclamation'] > 2) {
      interpretation += '매우 흥분되거나 신난 상태. ';
    } else if (signals['punctuation']['exclamation'] == 0 && 
               signals['punctuation']['question'] == 0) {
      interpretation += '감정이 평평하거나 가라앉은 상태. ';
    }
    
    // 물음표 개수로 혼란도 측정
    if (signals['punctuation']['question'] > 2) {
      interpretation += '혼란스럽거나 이해 못하는 상태. ';
    }
    
    // 메시지 길이로 대화 의욕 측정
    if (signals['length']['isVeryShort']) {
      interpretation += '대화 의욕 낮음. ';
    } else if (signals['length']['isVeryLong']) {
      interpretation += '할 말이 많거나 설명하고 싶은 욕구. ';
    }
    
    // 이모티콘으로 감정 상태 측정
    if (signals['emoticons']['count'] == 0) {
      interpretation += '진지하거나 무거운 감정. ';
    } else if (signals['emoticons']['count'] > 3) {
      interpretation += '감정 표현 욕구 강함. ';
    }
    
    signals['interpretation'] = interpretation.trim();
    return signals;
  }
  
  /// 구두점 분석
  Map<String, int> _analyzePunctuation(String message) {
    return {
      'exclamation': '!'.allMatches(message).length,
      'question': '?'.allMatches(message).length,
      'ellipsis': '...'.allMatches(message).length,
      'tilde': '~'.allMatches(message).length,
    };
  }
  
  /// 메시지 길이 분석
  Map<String, dynamic> _analyzeMessageLength(String message) {
    return {
      'length': message.length,
      'isVeryShort': message.length < 5,
      'isShort': message.length < 10,
      'isNormal': message.length >= 10 && message.length <= 50,
      'isLong': message.length > 50,
      'isVeryLong': message.length > 100,
    };
  }
  
  /// 응답 타이밍 분석 (실제 구현 시 타임스탬프 필요)
  Map<String, dynamic> _analyzeResponseTiming() {
    // TODO: 실제 구현 시 메시지 간 시간 차이 계산
    return {
      'isImmediate': false,
      'isDelayed': false,
      'averageResponseTime': 0,
    };
  }
  
  /// 이모티콘 사용 분석
  Map<String, dynamic> _analyzeEmoticonUsage(String message) {
    final emoticons = ['ㅎ', 'ㅋ', 'ㅠ', 'ㅜ', '^^', 'ㅇㅇ'];
    int count = 0;
    final used = <String>[];
    
    for (final emoticon in emoticons) {
      if (message.contains(emoticon)) {
        count++;
        used.add(emoticon);
      }
    }
    
    return {
      'count': count,
      'used': used,
      'hasHappy': message.contains('ㅎ') || message.contains('ㅋ') || message.contains('^^'),
      'hasSad': message.contains('ㅠ') || message.contains('ㅜ'),
    };
  }
  
  /// 주요 주제 추출 (헬퍼 메서드)
  String _extractMainTopic(String message) {
    // 주제 키워드 데이터베이스 활용
    for (final entry in _topicKeywords.entries) {
      for (final keyword in entry.value) {
        if (message.contains(keyword)) {
          return entry.key;
        }
      }
    }
    return '';
  }
}