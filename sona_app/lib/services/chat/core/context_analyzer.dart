import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../models/message.dart';
import '../../../models/persona.dart';
import '../localization/multilingual_keywords.dart';

/// 컨텍스트 분석 모듈
/// 사용자 메시지와 대화 맥락을 분석하는 전용 클래스
class ContextAnalyzer {
  static ContextAnalyzer? _instance;
  static ContextAnalyzer get instance => _instance ??= ContextAnalyzer._();
  
  ContextAnalyzer._();
  
  final _random = math.Random();
  
  /// 컨텍스트 종합 분석
  Future<Map<String, dynamic>> analyzeContext({
    required String userMessage,
    required List<Message> chatHistory,
    required Persona persona,
    required String userId,
    String languageCode = 'ko',
  }) async {
    // 1. 메시지 분석
    final messageAnalysis = _analyzeMessage(userMessage, languageCode);
    
    // 2. 질문 타입 분석
    final questionType = _analyzeQuestionType(userMessage, languageCode);
    
    // 3. 대화 맥락 분석
    final contextRelevance = _analyzeContextRelevance(
      userMessage: userMessage,
      chatHistory: chatHistory,
      languageCode: languageCode,
    );
    
    // 4. 토픽 추출
    final topics = _extractTopics(userMessage, chatHistory, languageCode);
    
    // 5. 대화 패턴 분석
    final conversationPattern = _analyzeConversationPattern(chatHistory);
    
    // 6. 특수 상황 감지
    final specialContext = _detectSpecialContext(
      userMessage: userMessage,
      chatHistory: chatHistory,
      languageCode: languageCode,
    );
    
    // 7. 품질 점수 계산
    final quality = _calculateContextQuality({
      'messageClarity': messageAnalysis['clarity'],
      'contextRelevance': contextRelevance['score'],
      'patternConsistency': conversationPattern['consistency'],
    });
    
    return {
      'messageAnalysis': messageAnalysis,
      'questionType': questionType,
      'contextRelevance': contextRelevance,
      'topics': topics,
      'conversationPattern': conversationPattern,
      'specialContext': specialContext,
      'quality': quality,
      'languageCode': languageCode,
    };
  }
  
  /// 메시지 분석
  Map<String, dynamic> _analyzeMessage(String message, String languageCode) {
    final length = message.length;
    final words = message.split(RegExp(r'\s+'));
    
    // 언어별 키워드 가져오기
    final emotions = MultilingualKeywords.getEmotionKeywords(languageCode);
    final topics = MultilingualKeywords.getTopicKeywords(languageCode);
    
    // 감정 키워드 감지
    String? detectedEmotion;
    for (final entry in emotions.entries) {
      final keywords = entry.value;
      if (keywords.any((keyword) => message.contains(keyword))) {
        detectedEmotion = entry.key;
        break;
      }
    }
    
    // 주제 키워드 감지
    final detectedTopics = <String>[];
    for (final entry in topics.entries) {
      final keywords = entry.value;
      if (keywords.any((keyword) => message.contains(keyword))) {
        detectedTopics.add(entry.key);
      }
    }
    
    // 명확도 계산
    double clarity = 1.0;
    if (length < 2) clarity = 0.3;
    else if (length < 5) clarity = 0.5;
    else if (length > 200) clarity = 0.7;
    
    // 의문문 여부
    final isQuestion = _isQuestion(message, languageCode);
    
    // 명령문 여부
    final isCommand = _isCommand(message, languageCode);
    
    return {
      'length': length,
      'wordCount': words.length,
      'emotion': detectedEmotion,
      'topics': detectedTopics,
      'clarity': clarity,
      'isQuestion': isQuestion,
      'isCommand': isCommand,
      'hasEmoji': RegExp(r'[\u{1F300}-\u{1F9FF}]', unicode: true).hasMatch(message),
    };
  }
  
  /// 질문 타입 분석
  Map<String, dynamic> _analyzeQuestionType(String message, String languageCode) {
    final lower = message.toLowerCase();
    
    // 언어별 질문 패턴
    final patterns = _getQuestionPatterns(languageCode);
    
    String type = 'statement';
    String? subType;
    
    for (final entry in patterns.entries) {
      if (entry.value.any((pattern) => lower.contains(pattern))) {
        type = 'question';
        subType = entry.key;
        break;
      }
    }
    
    // 추가 분류
    if (type == 'statement') {
      if (_isGreeting(message, languageCode)) {
        type = 'greeting';
      } else if (_isReaction(message, languageCode)) {
        type = 'reaction';
      } else if (_isCommand(message, languageCode)) {
        type = 'command';
      }
    }
    
    return {
      'type': type,
      'subType': subType,
      'requiresSpecificAnswer': type == 'question' && 
        (subType == 'what' || subType == 'when' || subType == 'where'),
      'isOpenEnded': type == 'question' && 
        (subType == 'how' || subType == 'why' || subType == 'opinion'),
    };
  }
  
  /// 대화 맥락 관련성 분석
  Map<String, dynamic> _analyzeContextRelevance({
    required String userMessage,
    required List<Message> chatHistory,
    required String languageCode,
  }) {
    if (chatHistory.isEmpty) {
      return {
        'score': 1.0,
        'isRelevant': true,
        'topicContinuity': true,
      };
    }
    
    // 최근 메시지들과 비교
    final recentMessages = chatHistory
        .where((m) => !m.isFromUser)
        .take(3)
        .map((m) => m.content.toLowerCase())
        .toList();
    
    if (recentMessages.isEmpty) {
      return {
        'score': 1.0,
        'isRelevant': true,
        'topicContinuity': true,
      };
    }
    
    // 관련성 점수 계산
    double relevanceScore = 0.0;
    final userWords = userMessage.toLowerCase().split(RegExp(r'\s+'));
    
    for (final recentMsg in recentMessages) {
      final recentWords = recentMsg.split(RegExp(r'\s+'));
      final commonWords = userWords
          .where((word) => word.length > 2 && recentWords.contains(word))
          .length;
      
      relevanceScore = math.max(
        relevanceScore,
        commonWords / math.max(userWords.length, recentWords.length),
      );
    }
    
    // 주제 연속성 체크
    final lastTopics = _extractTopics(
      recentMessages.first,
      [],
      languageCode,
    );
    final currentTopics = _extractTopics(userMessage, [], languageCode);
    final topicContinuity = lastTopics.any((topic) => currentTopics.contains(topic));
    
    return {
      'score': relevanceScore,
      'isRelevant': relevanceScore > 0.2,
      'topicContinuity': topicContinuity || relevanceScore > 0.3,
      'isTopicChange': relevanceScore < 0.1 && !topicContinuity,
    };
  }
  
  /// 토픽 추출
  List<String> _extractTopics(
    String message,
    List<Message> history,
    String languageCode,
  ) {
    final topics = <String>[];
    final keywords = MultilingualKeywords.getTopicKeywords(languageCode);
    
    // 현재 메시지에서 토픽 추출
    for (final entry in keywords.entries) {
      if (entry.value.any((keyword) => message.contains(keyword))) {
        topics.add(entry.key);
      }
    }
    
    // 최근 대화에서 토픽 추출
    if (history.isNotEmpty && topics.isEmpty) {
      final recentContent = history
          .take(5)
          .map((m) => m.content)
          .join(' ');
      
      for (final entry in keywords.entries) {
        if (entry.value.any((keyword) => recentContent.contains(keyword))) {
          topics.add(entry.key);
          if (topics.length >= 3) break;
        }
      }
    }
    
    return topics;
  }
  
  /// 대화 패턴 분석
  Map<String, dynamic> _analyzeConversationPattern(List<Message> history) {
    if (history.isEmpty) {
      return {
        'pattern': 'new',
        'avgResponseLength': 0,
        'turnCount': 0,
        'consistency': 1.0,
      };
    }
    
    // 턴 수 계산
    final turnCount = history.where((m) => m.isFromUser).length;
    
    // 평균 응답 길이
    final aiMessages = history.where((m) => !m.isFromUser).toList();
    final avgResponseLength = aiMessages.isEmpty ? 0 :
        aiMessages.map((m) => m.content.length).reduce((a, b) => a + b) ~/ aiMessages.length;
    
    // 패턴 식별
    String pattern = 'normal';
    if (turnCount <= 3) {
      pattern = 'initial';
    } else if (turnCount > 20) {
      pattern = 'long';
    } else if (avgResponseLength < 20) {
      pattern = 'brief';
    } else if (avgResponseLength > 150) {
      pattern = 'detailed';
    }
    
    // 일관성 계산
    double consistency = 1.0;
    if (aiMessages.length >= 2) {
      final lengths = aiMessages.map((m) => m.content.length).toList();
      final avgLength = lengths.reduce((a, b) => a + b) / lengths.length;
      final variance = lengths
          .map((l) => (l - avgLength).abs())
          .reduce((a, b) => a + b) / lengths.length;
      consistency = 1.0 - (variance / avgLength).clamp(0.0, 0.5);
    }
    
    return {
      'pattern': pattern,
      'avgResponseLength': avgResponseLength,
      'turnCount': turnCount,
      'consistency': consistency,
    };
  }
  
  /// 특수 상황 감지
  Map<String, dynamic> _detectSpecialContext({
    required String userMessage,
    required List<Message> chatHistory,
    required String languageCode,
  }) {
    final special = <String, bool>{};
    
    // 첫 인사
    special['isInitialGreeting'] = chatHistory.isEmpty && 
        _isGreeting(userMessage, languageCode);
    
    // 이별 인사
    special['isFarewell'] = _isFarewell(userMessage, languageCode);
    
    // 긴급 상황
    special['isUrgent'] = _isUrgent(userMessage, languageCode);
    
    // 감정적 상황
    special['isEmotional'] = _isEmotional(userMessage, languageCode);
    
    // 만남 제안
    special['hasMeetingProposal'] = _containsMeetingProposal(userMessage, languageCode);
    
    // 부적절한 내용
    special['hasInappropriate'] = _containsInappropriate(userMessage, languageCode);
    
    return special;
  }
  
  /// 품질 점수 계산
  double _calculateContextQuality(Map<String, dynamic> factors) {
    double quality = 0.0;
    
    // 메시지 명확도 (30%)
    quality += (factors['messageClarity'] ?? 0.5) * 0.3;
    
    // 맥락 관련성 (40%)
    quality += (factors['contextRelevance'] ?? 0.5) * 0.4;
    
    // 패턴 일관성 (30%)
    quality += (factors['patternConsistency'] ?? 0.5) * 0.3;
    
    return quality.clamp(0.0, 1.0);
  }
  
  /// 부적절한 입력에 대한 like score 차감 계산
  static int calculateLikePenalty(String message, {List<Message>? recentMessages}) {
    int penalty = 0;
    
    // 무의미한 입력
    if (_isGibberishOrTypo(message)) {
      penalty += 5; // -5 likes
      debugPrint('💔 무의미한 입력 감지: -5 likes');
      
      // 연속된 무의미한 입력 체크 (최근 3개 메시지)
      if (recentMessages != null && recentMessages.isNotEmpty) {
        int consecutiveGibberish = 0;
        for (final msg in recentMessages.take(3)) {
          if (msg.isFromUser && _isGibberishOrTypo(msg.content)) {
            consecutiveGibberish++;
          }
        }
        
        if (consecutiveGibberish >= 2) {
          penalty += 10; // 추가 -10 likes for persistent gibberish
          debugPrint('💔 연속된 무의미 입력 감지: 추가 -10 likes');
        }
      }
    }
    
    // 공격적/부적절한 내용
    if (_isHostileOrInappropriate(message)) {
      penalty += 10; // -10 likes
      debugPrint('💔 공격적 패턴 감지: -10 likes');
      
      // 연속된 공격적 패턴 체크
      if (recentMessages != null && recentMessages.isNotEmpty) {
        int consecutiveHostile = 0;
        for (final msg in recentMessages.take(3)) {
          if (msg.isFromUser && _isHostileOrInappropriate(msg.content)) {
            consecutiveHostile++;
          }
        }
        
        if (consecutiveHostile >= 2) {
          penalty += 15; // 추가 -15 likes for persistent hostility
          debugPrint('💔 연속된 공격적 패턴 감지: 추가 -15 likes');
        }
      }
    }
    
    return penalty.clamp(0, 50); // 최대 -50 likes까지만
  }
  
  static bool _isGibberishOrTypo(String text) {
    // 1자 이하 무의미 입력
    if (text.trim().length <= 1) return true;
    
    // 반복 패턴 (ㅋㅋㅋㅋㅋ, aaaa, 1111 등)
    if (RegExp(r'^(.)\1{4,}$').hasMatch(text)) return true;
    
    // 자음만 있는 경우 (ㅂㅈㄷㄱ 등)
    if (RegExp(r'^[ㄱ-ㅎ]+$').hasMatch(text)) return true;
    
    // 무작위 특수문자 반복
    if (RegExp(r'^[!@#$%^&*()_+=\-\[\]{}|\\:;"\'<>,.?/~`]+$').hasMatch(text)) return true;
    
    return false;
  }
  
  static bool _isHostileOrInappropriate(String text) {
    final lower = text.toLowerCase();
    
    // 욕설 패턴
    final hostilePatterns = [
      '시발', '씨발', '개새', '좆', '존나', '병신', '지랄',
      '꺼져', '닥쳐', '죽어', '멍청', '바보', '미친',
    ];
    
    for (final pattern in hostilePatterns) {
      if (lower.contains(pattern)) return true;
    }
    
    // 성적 내용
    final inappropriatePatterns = [
      '섹스', '야동', '자위', '발정', '꼴리',
    ];
    
    for (final pattern in inappropriatePatterns) {
      if (lower.contains(pattern)) return true;
    }
    
    return false;
  }
  
  // === 헬퍼 메서드들 ===
  
  bool _isQuestion(String message, String languageCode) {
    final patterns = {
      'ko': ['?', '뭐', '왜', '어떻게', '언제', '어디', '누구', '무엇', '어떤'],
      'en': ['?', 'what', 'why', 'how', 'when', 'where', 'who', 'which'],
      'ja': ['？', 'なに', 'なぜ', 'どう', 'いつ', 'どこ', 'だれ', 'どの'],
      'zh': ['？', '什么', '为什么', '怎么', '什么时候', '哪里', '谁', '哪个'],
    };
    
    final langPatterns = patterns[languageCode] ?? patterns['en']!;
    return langPatterns.any((p) => message.contains(p));
  }
  
  bool _isCommand(String message, String languageCode) {
    final patterns = {
      'ko': ['해줘', '하자', '해봐', '보여줘', '알려줘', '말해줘'],
      'en': ['please', 'tell me', 'show me', 'do', 'let\'s'],
      'ja': ['して', 'ください', '教えて', '見せて'],
      'zh': ['请', '告诉我', '给我看', '做'],
    };
    
    final langPatterns = patterns[languageCode] ?? patterns['en']!;
    return langPatterns.any((p) => message.toLowerCase().contains(p));
  }
  
  bool _isGreeting(String message, String languageCode) {
    final greetings = MultilingualKeywords.getGreetingKeywords(languageCode);
    return greetings.any((g) => message.toLowerCase().contains(g));
  }
  
  bool _isReaction(String message, String languageCode) {
    final reactions = {
      'ko': ['ㅋㅋ', 'ㅎㅎ', '헐', '대박', '오', '아', '음', '흠'],
      'en': ['haha', 'lol', 'wow', 'oh', 'ah', 'hmm', 'okay', 'ok'],
      'ja': ['はは', 'うん', 'へえ', 'そう', 'ああ', 'おお'],
      'zh': ['哈哈', '嗯', '哦', '啊', '呵呵'],
    };
    
    final langReactions = reactions[languageCode] ?? reactions['en']!;
    return message.length < 10 && 
           langReactions.any((r) => message.toLowerCase().contains(r));
  }
  
  bool _isFarewell(String message, String languageCode) {
    final farewells = {
      'ko': ['잘자', '안녕', '바이', '또봐', '다음에', '잘있어'],
      'en': ['bye', 'goodbye', 'see you', 'good night', 'farewell'],
      'ja': ['さよなら', 'バイバイ', 'またね', 'おやすみ', 'じゃあね'],
      'zh': ['再见', '拜拜', '晚安', '回见'],
    };
    
    final langFarewells = farewells[languageCode] ?? farewells['en']!;
    return langFarewells.any((f) => message.toLowerCase().contains(f));
  }
  
  bool _isUrgent(String message, String languageCode) {
    final urgent = {
      'ko': ['급해', '빨리', '지금', '당장', '시급', '응급'],
      'en': ['urgent', 'hurry', 'now', 'immediately', 'asap', 'emergency'],
      'ja': ['急いで', '今すぐ', '至急', '緊急'],
      'zh': ['紧急', '快', '马上', '立刻', '急'],
    };
    
    final langUrgent = urgent[languageCode] ?? urgent['en']!;
    return langUrgent.any((u) => message.toLowerCase().contains(u));
  }
  
  bool _isEmotional(String message, String languageCode) {
    final emotions = MultilingualKeywords.getEmotionKeywords(languageCode);
    int emotionCount = 0;
    
    for (final keywords in emotions.values) {
      if (keywords.any((k) => message.contains(k))) {
        emotionCount++;
      }
    }
    
    return emotionCount >= 2 || message.contains('ㅠ') || message.contains('ㅜ');
  }
  
  bool _containsMeetingProposal(String message, String languageCode) {
    final patterns = {
      'ko': ['만나', '보자', '나와', '데이트', '약속', '시간 어때'],
      'en': ['meet', 'see you', 'date', 'hang out', 'get together'],
      'ja': ['会い', 'デート', '約束', '時間ある'],
      'zh': ['见面', '约会', '见个面', '有时间'],
    };
    
    final langPatterns = patterns[languageCode] ?? patterns['en']!;
    return langPatterns.any((p) => message.toLowerCase().contains(p));
  }
  
  bool _containsInappropriate(String message, String languageCode) {
    // 부적절한 내용 필터링 (기본적인 체크만)
    final inappropriate = {
      'ko': ['섹', '변태', '음란', '야한'],
      'en': ['sex', 'pervert', 'obscene', 'dirty'],
    };
    
    final langPatterns = inappropriate[languageCode] ?? inappropriate['en']!;
    return langPatterns.any((p) => message.toLowerCase().contains(p));
  }
  
  Map<String, List<String>> _getQuestionPatterns(String languageCode) {
    switch (languageCode) {
      case 'ko':
        return {
          'what': ['뭐', '무엇', '뭘', '무슨', '어떤'],
          'why': ['왜', '어째서', '무슨 이유'],
          'how': ['어떻게', '어떤 방법', '얼마나'],
          'when': ['언제', '몇시', '며칠'],
          'where': ['어디', '어느', '어디서'],
          'who': ['누구', '누가', '누굴'],
          'opinion': ['어때', '생각', '의견'],
        };
      case 'en':
        return {
          'what': ['what', 'which'],
          'why': ['why', 'how come'],
          'how': ['how', 'in what way'],
          'when': ['when', 'what time'],
          'where': ['where', 'which place'],
          'who': ['who', 'whom'],
          'opinion': ['think', 'opinion', 'feel'],
        };
      case 'ja':
        return {
          'what': ['なに', '何', 'どの', 'どんな'],
          'why': ['なぜ', 'どうして', 'なんで'],
          'how': ['どう', 'どのように', 'どうやって'],
          'when': ['いつ', '何時'],
          'where': ['どこ', 'どちら'],
          'who': ['だれ', '誰', 'どなた'],
          'opinion': ['どう思う', '意見', '感想'],
        };
      default:
        return _getQuestionPatterns('en');
    }
  }
}