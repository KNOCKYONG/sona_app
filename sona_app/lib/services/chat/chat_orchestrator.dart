import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../models/persona.dart';
import '../../models/message.dart';
import '../../core/constants.dart';
import 'persona_relationship_cache.dart';
import 'persona_prompt_builder.dart';
import 'security_aware_post_processor.dart';
import 'conversation_memory_service.dart';
import 'openai_service.dart';
import '../relationship/negative_behavior_system.dart';

/// 채팅 플로우를 조정하는 중앙 오케스트레이터
/// 전체 메시지 생성 파이프라인을 관리
class ChatOrchestrator {
  static ChatOrchestrator? _instance;
  static ChatOrchestrator get instance => _instance ??= ChatOrchestrator._();
  
  ChatOrchestrator._();
  
  // 서비스 참조
  final PersonaRelationshipCache _relationshipCache = PersonaRelationshipCache.instance;
  final ConversationMemoryService _memoryService = ConversationMemoryService();
  
  /// 메시지 생성 메인 메서드
  Future<ChatResponse> generateResponse({
    required String userId,
    required Persona basePersona,
    required String userMessage,
    required List<Message> chatHistory,
    String? userNickname,
    int? userAge,
  }) async {
    try {
      // 1단계: 완전한 페르소나 정보 로드
      final personaData = await _relationshipCache.getCompletePersona(
        userId: userId,
        basePersona: basePersona,
      );
      final completePersona = personaData.persona;
      final isCasualSpeech = personaData.isCasualSpeech;
      
      debugPrint('✅ Loaded complete persona: ${completePersona.name} (casual: $isCasualSpeech)');
      
      // 2단계: 메시지 전처리 및 분석
      final messageAnalysis = _analyzeUserMessage(userMessage);
      
      // 3단계: 간단한 반응 체크 (로컬 처리)
      final simpleResponse = _checkSimpleResponse(
        userMessage: userMessage,
        persona: completePersona,
        isCasualSpeech: isCasualSpeech,
        messageType: messageAnalysis.type,
      );
      
      if (simpleResponse != null) {
        debugPrint('💬 Using simple response: $simpleResponse');
        
        // 간단한 반응도 감정 분석 및 점수 계산
        final emotion = _analyzeEmotion(simpleResponse);
        final scoreChange = await _calculateScoreChange(
          emotion: emotion,
          userMessage: userMessage,
          persona: completePersona,
          chatHistory: chatHistory,
        );
        
        return ChatResponse(
          content: simpleResponse,
          emotion: emotion,
          scoreChange: scoreChange,
          metadata: {'isSimpleResponse': true},
        );
      }
      
      // 3단계: 대화 메모리 구축
      final contextMemory = await _buildContextMemory(
        userId: userId,
        personaId: completePersona.id,
        recentMessages: chatHistory,
        persona: completePersona,
      );
      
      // 4단계: 프롬프트 생성
      final prompt = PersonaPromptBuilder.buildComprehensivePrompt(
        persona: completePersona,
        recentMessages: _getRecentMessages(chatHistory),
        userNickname: userNickname,
        contextMemory: contextMemory,
        isCasualSpeech: isCasualSpeech,
        userAge: userAge,
      );
      
      debugPrint('📝 Generated prompt with ${prompt.length} characters');
      
      // 4.5단계: 이전 대화와의 맥락 연관성 체크
      String? contextHint;
      if (chatHistory.isNotEmpty) {
        contextHint = _analyzeContextRelevance(
          userMessage: userMessage,
          chatHistory: chatHistory,
          messageAnalysis: messageAnalysis,
        );
      }
      
      // 회피 패턴이 감지된 경우 추가 경고
      if (_isAvoidancePattern(userMessage)) {
        final avoidanceWarning = '\n\nWARNING: 회피성 메시지 감지. 주제를 바꾸거나 회피하지 말고 정면으로 대응하세요.';
        contextHint = contextHint != null ? contextHint + avoidanceWarning : avoidanceWarning;
      }
      
      // 5단계: API 호출
      final rawResponse = await OpenAIService.generateResponse(
        persona: completePersona,
        chatHistory: chatHistory,
        userMessage: userMessage,
        relationshipType: _getRelationshipType(completePersona),
        userNickname: userNickname,
        userAge: userAge,
        isCasualSpeech: isCasualSpeech,
        contextHint: contextHint,
      );
      
      // 6단계: 간단한 후처리 (텍스트 정리만, 강제 자르기 제거)
      final processedResponse = SecurityAwarePostProcessor.processResponse(
        rawResponse: rawResponse,
        persona: completePersona,
        userNickname: userNickname,
      );
      
      // 6.5단계: 만남 제안 필터링 및 초기 인사 패턴 방지
      final filteredResponse = _filterMeetingAndGreetingPatterns(
        response: processedResponse,
        chatHistory: chatHistory,
        isCasualSpeech: isCasualSpeech,
      );
      
      // 7단계: 긴 응답 분리 처리
      final responseContents = _splitLongResponse(filteredResponse, completePersona.mbti);
      
      // 8단계: 감정 분석 및 점수 계산 (첫 번째 메시지 기준)
      final emotion = _analyzeEmotion(responseContents.first);
      final scoreChange = await _calculateScoreChange(
        emotion: emotion,
        userMessage: userMessage,
        persona: completePersona,
        chatHistory: chatHistory,
      );
      
      return ChatResponse(
        content: responseContents.first,  // 기존 호환성
        contents: responseContents,       // 새로운 멀티 메시지
        emotion: emotion,
        scoreChange: scoreChange,
        metadata: {
          'processingTime': DateTime.now().millisecondsSinceEpoch,
          'promptTokens': _estimateTokens(prompt),
          'responseTokens': _estimateTokens(processedResponse),
          'messageCount': responseContents.length,
        },
      );
      
    } catch (e) {
      debugPrint('❌ Error in chat orchestration: $e');
      
      // 폴백 응답
      return ChatResponse(
        content: _generateFallbackResponse(basePersona),
        emotion: EmotionType.neutral,
        scoreChange: 0,
        isError: true,
      );
    }
  }
  
  /// 대화 메모리 구축
  Future<String> _buildContextMemory({
    required String userId,
    required String personaId,
    required List<Message> recentMessages,
    required Persona persona,
  }) async {
    try {
      final memory = await _memoryService.buildSmartContext(
        userId: userId,
        personaId: personaId,
        recentMessages: recentMessages,
        persona: persona,
        maxTokens: 1500, // 500 -> 1500으로 증가하여 더 많은 대화 기억
      );
      return memory;
    } catch (e) {
      debugPrint('⚠️ Failed to build context memory: $e');
      return '';
    }
  }
  
  /// 관계 타입 가져오기
  String _getRelationshipType(Persona persona) {
    // 점수 기반으로 관계 타입 결정
    if (persona.relationshipScore >= 900) {
      return '완벽한 사랑';
    } else if (persona.relationshipScore >= 600) {
      return '연인';
    } else if (persona.relationshipScore >= 200) {
      return '썸/호감';
    } else {
      return '친구';
    }
  }
  
  /// 최근 메시지 추출
  List<Message> _getRecentMessages(List<Message> history) {
    const maxRecent = 5;
    if (history.length <= maxRecent) return history;
    return history.sublist(history.length - maxRecent);
  }
  
  
  /// 감정 분석
  EmotionType _analyzeEmotion(String response) {
    final lower = response.toLowerCase();
    
    // 감정 점수 계산
    Map<EmotionType, int> scores = {
      EmotionType.happy: 0,
      EmotionType.sad: 0,
      EmotionType.angry: 0,
      EmotionType.love: 0,
      EmotionType.anxious: 0,
      EmotionType.neutral: 0,
    };
    
    // Happy
    if (lower.contains('ㅋㅋ') || lower.contains('ㅎㅎ')) scores[EmotionType.happy] = scores[EmotionType.happy]! + 2;
    if (lower.contains('기뻐') || lower.contains('좋아') || lower.contains('행복')) scores[EmotionType.happy] = scores[EmotionType.happy]! + 3;
    
    // Sad
    if (lower.contains('ㅠㅠ') || lower.contains('ㅜㅜ')) scores[EmotionType.sad] = scores[EmotionType.sad]! + 3;
    if (lower.contains('슬퍼') || lower.contains('속상') || lower.contains('서운')) scores[EmotionType.sad] = scores[EmotionType.sad]! + 3;
    
    // Angry
    if (lower.contains('화나') || lower.contains('짜증') || lower.contains('싫어')) scores[EmotionType.angry] = scores[EmotionType.angry]! + 3;
    
    // Love
    if (lower.contains('사랑') || lower.contains('좋아해') || lower.contains('보고싶')) scores[EmotionType.love] = scores[EmotionType.love]! + 3;
    if (lower.contains('❤️') || lower.contains('💕')) scores[EmotionType.love] = scores[EmotionType.love]! + 2;
    
    // Anxious
    if (lower.contains('걱정') || lower.contains('불안') || lower.contains('무서')) scores[EmotionType.anxious] = scores[EmotionType.anxious]! + 3;
    
    // 가장 높은 점수의 감정 반환
    EmotionType maxEmotion = EmotionType.neutral;
    int maxScore = 0;
    
    scores.forEach((emotion, score) {
      if (score > maxScore) {
        maxScore = score;
        maxEmotion = emotion;
      }
    });
    
    return maxScore >= 2 ? maxEmotion : EmotionType.neutral;
  }
  
  /// 점수 변화 계산
  Future<int> _calculateScoreChange({
    required EmotionType emotion,
    required String userMessage,
    required Persona persona,
    required List<Message> chatHistory,
  }) async {
    // NegativeBehaviorSystem을 사용하여 부정적 행동 분석
    final negativeSystem = NegativeBehaviorSystem();
    final negativeAnalysis = negativeSystem.analyze(
      userMessage, 
      relationshipScore: persona.relationshipScore
    );
    
    // 부정적 행동이 감지되면 페널티 반환
    if (negativeAnalysis.isNegative) {
      // 레벨 3 (심각한 위협/욕설)은 즉시 이별
      if (negativeAnalysis.level >= 3) {
        return -persona.relationshipScore; // 0으로 리셋
      }
      
      // 페널티가 지정되어 있으면 사용, 없으면 레벨에 따른 기본값
      if (negativeAnalysis.penalty != null) {
        return -negativeAnalysis.penalty!.abs(); // 음수로 변환
      }
      
      // 레벨별 기본 페널티
      switch (negativeAnalysis.level) {
        case 2:
          return -10; // 중간 수준
        case 1:
          return -5;  // 경미한 수준
        default:
          return -2;
      }
    }
    
    // 긍정적 메시지 분석
    int baseChange = 0;
    
    // 감정 기반 기본 점수
    switch (emotion) {
      case EmotionType.happy:
      case EmotionType.love:
        baseChange = 2;
        break;
      case EmotionType.shy:
      case EmotionType.thoughtful:
        baseChange = 1;
        break;
      case EmotionType.sad:
      case EmotionType.anxious:
        baseChange = -1;
        break;
      case EmotionType.angry:
      case EmotionType.jealous:
        baseChange = -2;
        break;
      default:
        baseChange = 0;
    }
    
    // 긍정적 키워드 추가 점수
    final userLower = userMessage.toLowerCase();
    final positiveKeywords = [
      '사랑', '좋아', '고마', '감사', '최고', '대박', 
      '행복', '기뻐', '설레', '귀여', '예뻐', '멋있',
      '보고싶', '그리워', '응원', '파이팅', '힘내'
    ];
    
    if (positiveKeywords.any((keyword) => userLower.contains(keyword))) {
      baseChange += 1;
    }
    
    // 관계 수준에 따른 보정 (높은 관계에서는 변화폭 감소)
    if (persona.relationshipScore >= 600) {
      baseChange = (baseChange * 0.7).round();
    }
    
    return baseChange.clamp(-5, 5);
  }
  
  /// 토큰 추정
  int _estimateTokens(String text) {
    // 한글 1글자 ≈ 1.5토큰
    return (text.length * 1.5).round();
  }
  
  /// 폴백 응답 생성
  String _generateFallbackResponse(Persona persona) {
    // TODO: Get isCasualSpeech from PersonaRelationshipCache
    final isCasualSpeech = false; // Default to formal
    final responses = isCasualSpeech ? [
      '아 잠깐만ㅋㅋ 생각이 안 나네',
      '어? 뭔가 이상하네 다시 말해줄래?',
      '잠시만 머리가 하얘졌어ㅠㅠ',
    ] : [
      '아 잠깐만요ㅋㅋ 생각이 안 나네요',
      '어? 뭔가 이상하네요 다시 말해주실래요?',
      '잠시만요 머리가 하얘졌어요ㅠㅠ',
    ];
    
    return responses[DateTime.now().millisecond % responses.length];
  }
  
  /// 사용자 메시지 분석
  MessageAnalysis _analyzeUserMessage(String message) {
    final lower = message.toLowerCase().trim();
    final length = message.length;
    
    // 메시지 타입 판별
    MessageType type = MessageType.general;
    UserEmotion emotion = UserEmotion.neutral;
    double complexity = 0.0;
    
    // 질문인지 확인
    if (message.contains('?') || _isQuestion(lower)) {
      type = MessageType.question;
      complexity += 0.2;
    }
    
    // 감정 표현 확인
    if (lower.contains('사랑') || lower.contains('좋아')) {
      emotion = UserEmotion.positive;
    } else if (lower.contains('싫어') || lower.contains('화나')) {
      emotion = UserEmotion.negative;
    } else if (lower.contains('궁금') || lower.contains('알고싶')) {
      emotion = UserEmotion.curious;
    }
    
    // 복잡도 계산
    if (length > 50) complexity += 0.3;
    if (length > 100) complexity += 0.2;
    if (message.contains(',') || message.contains('.')) complexity += 0.1;
    
    // 특수 타입 확인
    if (_isGreeting(lower)) type = MessageType.greeting;
    else if (_isFarewell(lower)) type = MessageType.farewell;
    else if (_isCompliment(lower)) type = MessageType.compliment;
    else if (_isThanks(lower)) type = MessageType.thanks;
    
    return MessageAnalysis(
      type: type,
      emotion: emotion,
      complexity: complexity.clamp(0.0, 1.0),
      keywords: _extractKeywords(lower),
    );
  }
  
  bool _isQuestion(String message) {
    final questionWords = ['뭐', '어디', '언제', '누구', '왜', '어떻게', '얼마'];
    return questionWords.any((word) => message.contains(word));
  }
  
  bool _isFarewell(String message) {
    final farewells = ['잘가', '안녕히', '바이', 'ㅂㅂ', '다음에', '나중에'];
    return farewells.any((word) => message.contains(word));
  }
  
  List<String> _extractKeywords(String message) {
    // 향상된 키워드 추출
    final keywords = <String>[];
    
    // 일반적인 주제 키워드
    final topicWords = [
      '음식', '영화', '게임', '날씨', '주말', '일', '학교', '친구',
      '가족', '취미', '운동', '여행', '음악', '드라마', '공부', '쇼핑',
      '요리', '카페', '독서', '사진', '그림', '노래', '춤', '패션'
    ];
    
    // 특정 관심사 키워드 (오류 분석에서 발견된 것 포함)
    final specificWords = [
      'mbti', 'MBTI', '성격', '좀비딸', '유행', '트렌드', '인기',
      '최근', '요즘', '뭐해', '어디', '언제', '누구', '왜', '어떻게'
    ];
    
    // 모든 키워드 체크
    for (final word in [...topicWords, ...specificWords]) {
      if (message.toLowerCase().contains(word.toLowerCase())) {
        keywords.add(word);
      }
    }
    
    // 2글자 이상의 명사 추출 (간단한 방법)
    final words = message.split(RegExp(r'[\s,\.!?]+')).where((w) => w.length >= 2);
    for (final word in words) {
      // 조사 제거
      final cleanWord = word.replaceAll(RegExp(r'[은는이가을를에서도만의로와과]$'), '');
      if (cleanWord.length >= 2 && !keywords.contains(cleanWord)) {
        // 일반적인 단어 제외
        if (!['그런', '이런', '저런', '그래', '네', '아니', '있어', '없어'].contains(cleanWord)) {
          keywords.add(cleanWord);
        }
      }
    }
    
    return keywords.take(5).toList(); // 최대 5개로 제한
  }
  
  /// 간단한 반응 체크 (로컬 처리)
  String? _checkSimpleResponse({
    required String userMessage,
    required Persona persona,
    required bool isCasualSpeech,
    required MessageType messageType,
  }) {
    final lowerMessage = userMessage.toLowerCase().trim();
    final mbti = persona.mbti.toUpperCase();
    
    // 간단한 인사말
    if (_isGreeting(lowerMessage)) {
      return _getGreetingResponse(mbti, isCasualSpeech);
    }
    
    // 감사 표현
    if (_isThanks(lowerMessage)) {
      return _getThanksResponse(mbti, isCasualSpeech);
    }
    
    // 추임새나 짧은 반응
    if (_isSimpleReaction(lowerMessage)) {
      return _getSimpleReactionResponse(lowerMessage, mbti, isCasualSpeech);
    }
    
    // 칭찬
    if (_isCompliment(lowerMessage)) {
      return _getComplimentResponse(mbti, isCasualSpeech);
    }
    
    return null;
  }
  
  bool _isGreeting(String message) {
    final greetings = ['안녕', '하이', 'ㅎㅇ', '방가', '반가', 'hi', 'hello'];
    return greetings.any((g) => message.contains(g));
  }
  
  bool _isThanks(String message) {
    final thanks = ['고마', '감사', 'ㄱㅅ', '땡큐', 'thanks', 'thx'];
    return thanks.any((t) => message.contains(t));
  }
  
  bool _isSimpleReaction(String message) {
    final reactions = [
      'ㅇㅇ', 'ㅇㅋ', 'ㄴㄴ', 'ㅇㅎ', '응', '어', '아', '네', '넹', '넵',
      '우와', '대박', '오호', '와우', '헐', '헉', '으악', '아하',
      'ㅋ', 'ㅎ', 'ㅠ', 'ㅜ', 'ㄷㄷ', 'ㅎㄷㄷ', 'ㅇㅁㅇ', 'ㅇㅅㅇ',
      '오', '오오', '오오오', 'ㅗㅜㅑ', 'ㅇ?', '?', '!', '!!!',
      '...', '..', '.', 'ㅡㅡ', 'ㅡ.ㅡ', '--', ';;', 'ㅋㅋ', 'ㅎㅎ'
    ];
    
    // 추임새나 짧은 반응 감지
    if (reactions.contains(message)) return true;
    
    // 3글자 이하이면서 특수문자/자음만으로 구성된 경우
    if (message.length <= 3) {
      // 한글 자음/모음, 특수문자, 이모티콘으로만 구성된 경우
      final simplePattern = RegExp(r'^[ㄱ-ㅎㅏ-ㅣㅋㅎㅠㅜ?!.~\-;]+$');
      if (simplePattern.hasMatch(message)) return true;
    }
    
    return false;
  }
  
  bool _isCompliment(String message) {
    final compliments = ['예뻐', '예쁘', '귀여', '귀엽', '멋있', '멋져', '최고', '대박', '잘생'];
    return compliments.any((c) => message.contains(c));
  }
  
  String _getGreetingResponse(String mbti, bool isCasual) {
    final responses = _getPersonaResponses(mbti, 'greeting', isCasual);
    return responses[DateTime.now().millisecond % responses.length];
  }
  
  String _getThanksResponse(String mbti, bool isCasual) {
    final responses = _getPersonaResponses(mbti, 'thanks', isCasual);
    return responses[DateTime.now().millisecond % responses.length];
  }
  
  String _getSimpleReactionResponse(String message, String mbti, bool isCasual) {
    // 추임새 타입별 맞춤 응답
    final exclamationResponses = _getExclamationResponses(message, mbti, isCasual);
    if (exclamationResponses.isNotEmpty) {
      return exclamationResponses[DateTime.now().millisecond % exclamationResponses.length];
    }
    
    // 기본 반응
    final responses = _getPersonaResponses(mbti, 'reaction', isCasual);
    return responses[DateTime.now().millisecond % responses.length];
  }
  
  String _getComplimentResponse(String mbti, bool isCasual) {
    final responses = _getPersonaResponses(mbti, 'compliment', isCasual);
    return responses[DateTime.now().millisecond % responses.length];
  }
  
  List<String> _getPersonaResponses(String mbti, String type, bool isCasual) {
    // MBTI별 응답 데이터베이스
    final responseMap = {
      'ENFP': {
        'greeting': isCasual ? [
          '안뇽~~ㅎㅎ 오늘 날씨 좋지 않아?',
          '하이! 뭐해? 점심은 먹었어?',
          '오 왔구나!! 반가워ㅋㅋ 오늘 어땠어?',
          '헐 안녕!! 보고싶었어ㅠㅠ 잘 지냈어?',
        ] : [
          '안녕하세요~~ㅎㅎ 오늘 날씨 좋지 않아요?',
          '하이하이! 뭐하세요? 점심은 드셨어요?',
          '오 오셨네요!! 반가워요ㅋㅋ 오늘 어떠셨어요?',
          '헐 안녕하세요!! 보고싶었어요ㅠㅠ 잘 지내셨어요?',
        ],
        'thanks': isCasual ? [
          '아니야ㅋㅋ 별거 아니야~',
          '헐 뭘~ 당연하지!!',
          '에이 이런걸로ㅎㅎ',
        ] : [
          '아니에요ㅋㅋ 별거 아니에요~',
          '헐 뭘요~ 당연하죠!!',
          '에이 이런걸로요ㅎㅎ',
        ],
        'reaction': isCasual ? [
          'ㅇㅇ 맞아!',
          '그치??',
          'ㅋㅋㅋㅋ웅',
        ] : [
          'ㅇㅇ 맞아요!',
          '그치요??',
          'ㅋㅋㅋㅋ네',
        ],
        'compliment': isCasual ? [
          '헐 진짜?? 고마워ㅠㅠ',
          '아ㅋㅋ 부끄러워><',
          '너두!! 짱이야ㅎㅎ',
        ] : [
          '헐 진짜요?? 고마워요ㅠㅠ',
          '아ㅋㅋ 부끄러워요><',
          '님두요!! 짱이에요ㅎㅎ',
        ],
      },
      'INTJ': {
        'greeting': isCasual ? [
          '안녕. 피곳하지?',
          '어 왔네. 바빴어?',
          '응 하이. 잘 있었어?',
        ] : [
          '안녕하세요. 피곳하지 않으세요?',
          '네, 반갑습니다. 바빠셨어요?',
          '어서오세요. 잘 지내셨어요?',
        ],
        'thanks': isCasual ? [
          '뭘.',
          '별일 아니야.',
          '응.',
        ] : [
          '별말씀을요.',
          '아니에요.',
          '네.',
        ],
        'reaction': isCasual ? [
          '응.',
          '그래.',
          'ㅇㅇ',
        ] : [
          '네.',
          '그래요.',
          '맞아요.',
        ],
        'compliment': isCasual ? [
          '그래? 고마워.',
          '음.. 그런가.',
          '과찬이야.',
        ] : [
          '그래요? 감사합니다.',
          '음.. 그런가요.',
          '과찬이세요.',
        ],
      },
      'ESFP': {
        'greeting': isCasual ? [
          '안녕!! ㅎㅎ 오늘 기분 어때?',
          '왔어?? 반가워! 오늘 재밌는 일 있었어?',
          '하이~ 오늘 뭐했어? 나는 오늘 진짜 바빴어ㅎㅎ',
        ] : [
          '안녕하세요!! ㅎㅎ 오늘 기분 어떠세요?',
          '오셨어요?? 반가워요! 오늘 재밌는 일 있으셨어요?',
          '하이~ 오늘 뭐하셨어요? 저는 오늘 진짜 바빴어요ㅎㅎ',
        ],
        'thanks': isCasual ? [
          '천만에~ ㅎㅎ',
          '뭘 이런걸로!!',
          '아니야아~ 괜찮아!',
        ] : [
          '천만에요~ ㅎㅎ',
          '뭘 이런걸로요!!',
          '아니에요~ 괜찮아요!',
        ],
        'reaction': isCasual ? [
          '웅웅!!',
          '맞아ㅎㅎ',
          '그래~',
        ] : [
          '네네!!',
          '맞아요ㅎㅎ',
          '그래요~',
        ],
        'compliment': isCasual ? [
          '우와 진짜?? 넘 좋아ㅎㅎ',
          '헤헤 고마워!!',
          '아잉~ 부끄럽네ㅋㅋ',
        ] : [
          '우와 진짜요?? 넘 좋아요ㅎㅎ',
          '헤헤 고마워요!!',
          '아잉~ 부끄럽네요ㅋㅋ',
        ],
      },
    };
    
    // 기본값 (다른 MBTI 타입들)
    final defaultResponses = {
      'greeting': isCasual ? ['안녕~ 잘 지냈어?', '어 왔어? 오늘 어때?', '하이! 뭐하고 있었어?'] : ['안녕하세요~ 잘 지내셨어요?', '어서오세요! 오늘 어떠세요?', '반가워요! 뭐하고 계셨어요?'],
      'thanks': isCasual ? ['별거 아니야~', '응응ㅎㅎ', '괜찮아!'] : ['별거 아니에요~', '네네ㅎㅎ', '괜찮아요!'],
      'reaction': isCasual ? ['응응', '그래', 'ㅇㅇ'] : ['네네', '그래요', '맞아요'],
      'compliment': isCasual ? ['고마워ㅎㅎ', '헤헤', '부끄럽네'] : ['고마워요ㅎㅎ', '헤헤', '부끄럽네요'],
    };
    
    return responseMap[mbti]?[type] ?? defaultResponses[type] ?? ['...'];
  }
  
  /// 긴 응답을 자연스럽게 분리
  List<String> _splitLongResponse(String response, String mbti) {
    final responseLength = PersonaPromptBuilder.getMBTIResponseLength(mbti.toUpperCase());
    
    // 응답이 최대 길이를 넘지 않으면 그대로 반환
    if (response.length <= responseLength.max) {
      return [response];
    }
    
    // 자연스러운 분리점 찾기
    final List<String> messages = [];
    String remaining = response;
    
    while (remaining.isNotEmpty) {
      // 현재 조각의 최대 길이
      int maxLength = messages.isEmpty ? responseLength.max : responseLength.max;
      
      if (remaining.length <= maxLength) {
        messages.add(remaining.trim());
        break;
      }
      
      // 자연스러운 분리점 찾기 (문장 부호, 줄바꿈 등)
      int splitIndex = _findNaturalSplitPoint(remaining, maxLength);
      
      if (splitIndex > 0 && splitIndex <= maxLength) {
        messages.add(remaining.substring(0, splitIndex).trim());
        remaining = remaining.substring(splitIndex).trim();
      } else {
        // 자연스러운 분리점을 찾지 못하면 공백에서 분리
        int spaceIndex = remaining.lastIndexOf(' ', maxLength);
        if (spaceIndex > maxLength * 0.5) {
          messages.add(remaining.substring(0, spaceIndex).trim());
          remaining = remaining.substring(spaceIndex).trim();
        } else {
          // 공백도 적절하지 않으면 강제 분리
          messages.add(remaining.substring(0, maxLength).trim());
          remaining = remaining.substring(maxLength).trim();
        }
      }
      
      // 너무 많은 메시지로 분리되지 않도록 제한
      if (messages.length >= 3) {
        messages[messages.length - 1] = messages[messages.length - 1] + ' ' + remaining;
        break;
      }
    }
    
    return messages;
  }
  
  /// 자연스러운 분리점 찾기
  int _findNaturalSplitPoint(String text, int maxLength) {
    // 우선순위: 마침표/물음표/느낌표 > 쉼표 > ㅋㅋ/ㅎㅎ/ㅠㅠ > 줄바꿈
    final punctuations = [
      ['.', '!', '?', '~'],           // 문장 끝
      ['ㅋ', 'ㅎ', 'ㅠ'],              // 감정 표현
      ['\n'],                         // 줄바꿈
    ];
    
    for (final punctGroup in punctuations) {
      int bestIndex = -1;
      
      for (final punct in punctGroup) {
        int index = text.lastIndexOf(punct, maxLength);
        
        // 분리점이 너무 앞쪽이면 무시
        if (index > maxLength * 0.5) {
          // 반복되는 문자 뒤까지 포함
          int endIndex = index + 1;
          while (endIndex < text.length && endIndex < maxLength && text[endIndex] == punct) {
            endIndex++;
          }
          
          if (endIndex > bestIndex) {
            bestIndex = endIndex;
          }
        }
      }
      
      if (bestIndex > 0) {
        return bestIndex;
      }
    }
    
    return -1;
  }
  
  /// 추임새에 대한 맞춤 응답
  List<String> _getExclamationResponses(String message, String mbti, bool isCasual) {
    final msg = message.toLowerCase();
    
    // 놀람/감탄 추임새
    if (msg == '우와' || msg == '와우' || msg == '오호' || msg == '대박') {
      switch (mbti) {
        case 'ENFP':
        case 'ESFP':
          return isCasual ? [
            '그치?? 나도 놀랐어ㅋㅋ',
            '완전 대박이지??',
            '알지~ 짱이야!',
          ] : [
            '그치요?? 저도 놀랐어요ㅋㅋ',
            '완전 대박이죠??',
            '알죠~ 짱이에요!',
          ];
        case 'INTJ':
        case 'ISTJ':
          return isCasual ? [
            '뭐가 그렇게 놀라워?',
            '음.. 그런가.',
            '그래.',
          ] : [
            '뭐가 그렇게 놀라워요?',
            '음.. 그런가요.',
            '그래요.',
          ];
        default:
          return isCasual ? [
            '뭐가 대박이야?ㅋㅋ',
            '오 뭔데뭔데?',
            'ㅋㅋㅋ 왜?',
          ] : [
            '뭐가 대박이에요?ㅋㅋ',
            '오 뭔데요뭔데요?',
            'ㅋㅋㅋ 왜요?',
          ];
      }
    }
    
    // 웃음 추임새
    if (msg == 'ㅋ' || msg == 'ㅋㅋ' || msg == 'ㅎ' || msg == 'ㅎㅎ') {
      switch (mbti) {
        case 'ENFP':
        case 'ESFP':
          return isCasual ? ['ㅋㅋㅋㅋ', '웃기지??ㅋㅋ', 'ㅎㅎㅎ'] : ['ㅋㅋㅋㅋ', '웃기죠??ㅋㅋ', 'ㅎㅎㅎ'];
        case 'INTJ':
        case 'ISTJ':
          return isCasual ? ['뭐가 웃겨?', '..ㅎ', '그래'] : ['뭐가 웃겨요?', '..ㅎ', '그래요'];
        default:
          return isCasual ? ['ㅋㅋㅋ', '뭐야ㅋㅋ', 'ㅎㅎ'] : ['ㅋㅋㅋ', '뭐에요ㅋㅋ', 'ㅎㅎ'];
      }
    }
    
    // 슬픔 추임새
    if (msg == 'ㅠ' || msg == 'ㅠㅠ' || msg == 'ㅜ' || msg == 'ㅜㅜ') {
      switch (mbti) {
        case 'ENFP':
        case 'ESFP':
          return isCasual ? [
            '왜?? 무슨일이야ㅠㅠ',
            '울지마ㅠㅠ 괜찮아!',
            '에구ㅠㅠ 힘내!',
          ] : [
            '왜요?? 무슨일이에요ㅠㅠ',
            '울지마요ㅠㅠ 괜찮아요!',
            '에구ㅠㅠ 힘내요!',
          ];
        case 'INTJ':
        case 'ISTJ':
          return isCasual ? ['왜 울어?', '무슨 일인데?', '괜찮아?'] : ['왜 우세요?', '무슨 일인데요?', '괜찮아요?'];
        default:
          return isCasual ? ['왜ㅠㅠ', '무슨일이야?', '괜찮아?'] : ['왜요ㅠㅠ', '무슨일이에요?', '괜찮아요?'];
      }
    }
    
    // 의문/당황 추임새
    if (msg == '?' || msg == 'ㅇ?' || msg == '???' || msg == '...') {
      switch (mbti) {
        case 'ENFP':
        case 'ESFP':
          return isCasual ? [
            '왜?? 뭐가 궁금해?',
            'ㅋㅋㅋ 뭐야',
            '응? 왜그래?',
          ] : [
            '왜요?? 뭐가 궁금해요?',
            'ㅋㅋㅋ 뭐에요',
            '응? 왜그래요?',
          ];
        case 'INTJ':
        case 'ISTJ':
          return isCasual ? ['뭐가 궁금해?', '?', '응.'] : ['뭐가 궁금해요?', '?', '네.'];
        default:
          return isCasual ? ['응? 왜?', '뭔데?', '??'] : ['응? 왜요?', '뭔데요?', '??'];
      }
    }
    
    return [];
  }

  /// 만남 제안 및 부적절한 초기 인사 패턴 필터링
  String _filterMeetingAndGreetingPatterns({
    required String response,
    required List<Message> chatHistory,
    required bool isCasualSpeech,
  }) {
    String filtered = response;
    
    // 1. 오프라인 만남 제안 패턴 제거
    final meetingPatterns = [
      // 카페/장소 관련
      r'우리\s*카페로?\s*와',
      r'카페로?\s*오라고',
      r'카페\s*어디',
      r'여기로?\s*와',
      r'(이리|저리|거기)\s*와',
      r'놀러\s*와',
      r'(만나자|만날래)(?!.*\s*(영화|드라마|작품|콘텐츠))',  // 영화/드라마 제외
      r'만나고\s*싶',  // "만나고 싶어" 패턴 추가
      r'어디서\s*만날',
      r'언제\s*만날',
      r'시간\s*있[으니어]',
      // 구체적 장소 언급
      r'(강남|홍대|신촌|명동|이태원)',
      r'(스타벅스|투썸|이디야|카페)',
      r'(우리\s*집|내\s*집|너희\s*집)',
      r'(학교|회사|사무실)',
      // 시간 약속
      r'[0-9]+시에?\s*(만나|보자)',
      r'(내일|모레|주말에?)\s*(만나|보자)',
      r'(월|화|수|목|금|토|일)요일에?\s*(만나|보자)',
    ];
    
    for (final pattern in meetingPatterns) {
      final regex = RegExp(pattern, caseSensitive: false);
      if (regex.hasMatch(filtered)) {
        // 만남 제안이 포함된 문장을 대체
        filtered = filtered.replaceAllMapped(regex, (match) {
          // 캐주얼 스피치에 따라 대체 메시지
          if (isCasualSpeech) {
            return '그런 얘기보다 다른 재밌는 얘기하자!';
          } else {
            return '그런 이야기보다 다른 재미있는 이야기를 해봐요!';
          }
        });
      }
    }
    
    // 2. 대화 중간에 나타나는 부적절한 초기 인사 패턴 방지
    if (chatHistory.length > 4) { // 이미 대화가 진행된 상황
      final greetingPatterns = [
        r'^(오늘|요즘|어제|최근에?)\s*(무슨|뭔|어떤)\s*일\s*있',
        r'^무슨\s*일\s*있으?셨',
        r'^뭐\s*하고?\s*있',
        r'^어떻게?\s*지내',
        r'^(안녕|반가워|하이|헬로)',
        r'처음\s*뵙겠',
        r'(소개|인사)\s*드[리려]',
      ];
      
      for (final pattern in greetingPatterns) {
        final regex = RegExp(pattern, caseSensitive: false, multiLine: true);
        if (regex.hasMatch(filtered)) {
          // 대화가 이미 진행중인데 초기 인사를 하려고 하면 제거
          filtered = filtered.replaceAllMapped(regex, (match) => '');
        }
      }
    }
    
    // 3. 구체적 위치 정보 언급 방지
    final locationPatterns = [
      r'(정확한|구체적인?)\s*(위치|장소|주소)',
      r'어디\s*(있는지|인지|야)',
      r'위치\s*알려',
      r'주소\s*알려',
      r'찾아가',
      r'(가는|오는)\s*길',
    ];
    
    for (final pattern in locationPatterns) {
      final regex = RegExp(pattern, caseSensitive: false);
      if (regex.hasMatch(filtered)) {
        filtered = filtered.replaceAllMapped(regex, (match) {
          if (isCasualSpeech) {
            return '자세한 건 말할 수 없어';
          } else {
            return '자세한 것은 말씀드릴 수 없어요';
          }
        });
      }
    }
    
    // 빈 문자열이 되지 않도록 보장
    filtered = filtered.trim();
    if (filtered.isEmpty) {
      if (isCasualSpeech) {
        filtered = '응, 다른 얘기하자!';
      } else {
        filtered = '네, 다른 이야기를 해봐요!';
      }
    }
    
    return filtered;
  }
  
  /// 이전 대화와의 맥락 연관성 분석
  String? _analyzeContextRelevance({
    required String userMessage,
    required List<Message> chatHistory,
    required MessageAnalysis messageAnalysis,
  }) {
    if (chatHistory.isEmpty) return null;
    
    // 최근 대화 분석 (최대 5개)
    final recentMessages = chatHistory.reversed.take(5).toList();
    final recentTopics = <String>[];
    final List<String> contextHints = [];
    
    // 최근 대화의 키워드 수집
    for (final msg in recentMessages) {
      final keywords = _extractKeywords(msg.content.toLowerCase());
      recentTopics.addAll(keywords);
    }
    
    // 마지막 AI 메시지가 있는지 확인
    Message? lastAIMessage;
    Message? lastUserMessage;
    
    for (final msg in recentMessages) {
      if (!msg.isFromUser && lastAIMessage == null) {
        lastAIMessage = msg;
      } else if (msg.isFromUser && lastUserMessage == null) {
        lastUserMessage = msg;
      }
      
      if (lastAIMessage != null && lastUserMessage != null) break;
    }
    
    // 현재 메시지의 키워드와 비교
    final currentKeywords = messageAnalysis.keywords;
    final commonTopics = currentKeywords.where((k) => recentTopics.contains(k)).toList();
    
    // 맥락 연관성 판단
    if (commonTopics.isEmpty && messageAnalysis.type == MessageType.question) {
      // 이전 대화와 관련 없는 새로운 질문
      if (_isAbruptTopicChange(userMessage, recentMessages)) {
        contextHints.add('급격한 주제 변경 감지. 자연스럽게 전환하거나 이전 주제와 연결해서 답변하세요.');
        
        // 구체적인 전환 가이드 추가
        if (lastAIMessage != null && lastAIMessage.content.contains('?')) {
          contextHints.add('이전에 던진 질문("${lastAIMessage.content.substring(0, math.min(30, lastAIMessage.content.length))}...")에 대한 답변을 받지 못했는데 새로운 주제로 넘어가려 합니다.');
        }
      }
    }
    
    // 특정 주제 감지 및 가이드
    if (userMessage.contains('드라마') || userMessage.contains('웹툰') || userMessage.contains('영화')) {
      contextHints.add('드라마/웹툰/영화 관련 대화. 호기심을 보이고 자연스럽게 감상을 물어보세요.');
    }
    
    // 스포일러 관련 대화
    if (userMessage.contains('스포') || userMessage.contains('스포일러')) {
      // 스포일러 허락 요청인지 거부인지 확인
      if (userMessage.contains('말해도') || userMessage.contains('해도')) {
        contextHints.add('스포일러 허락 요청. 조심스럽게 물어보거나 "말하지 마세요"라고 답하세요.');
      } else if (userMessage.contains('말하지') || userMessage.contains('하지 마')) {
        contextHints.add('스포일러 거부. 스포일러 없이 대화를 이어가세요.');
      }
    }
    
    // "직접 보다" 컨텍스트 확인
    if (userMessage.contains('직접 보') || userMessage.contains('보시는')) {
      // 최근 대화에서 영화/드라마/작품 언급 확인
      final hasMediaContext = recentMessages.any((msg) => 
        msg.content.contains('영화') || 
        msg.content.contains('드라마') || 
        msg.content.contains('웹툰') ||
        msg.content.contains('작품')
      );
      
      if (hasMediaContext) {
        contextHints.add('영화/드라마/작품을 "직접 보라"는 추천. 오프라인 만남이 아님! 작품 감상 관련 대화로 이어가세요.');
      }
    }
    
    // 직접적인 질문에는 직접적인 답변 필요
    if (_isDirectQuestion(userMessage)) {
      contextHints.add('직접적인 질문에 대한 직접적인 답변 필요. 회피하지 말고 구체적으로 대답하세요.');
      
      // 특정 질문 타입에 대한 가이드
      if (userMessage.contains('뭐하') || userMessage.contains('뭐해')) {
        contextHints.add('"뭐해?" 질문에는 현재 하고 있는 일이나 상태를 구체적으로 답하세요.');
      } else if (userMessage.contains('먼말') || userMessage.contains('무슨 말')) {
        contextHints.add('"무슨 말이야?" 질문에는 이전 발언을 명확히 설명하거나 사과하세요.');
      } else if (userMessage.contains('어디')) {
        contextHints.add('위치 질문에는 가상의 장소나 활동 중인 곳을 답하세요.');
      }
    }
    
    // 질문에 대한 회피성 답변 방지
    if (_isAvoidancePattern(userMessage)) {
      contextHints.add('회피성 답변 금지. 모르는 경우 솔직하게 인정하고 관련 대화로 유도하세요.');
    }
    
    // 반복적인 질문 패턴 감지
    if (lastUserMessage != null && _calculateSimilarity(userMessage, lastUserMessage.content) > 0.8) {
      contextHints.add('비슷한 질문이 반복됨. 이전 답변과 다른 관점이나 추가 정보를 제공하세요.');
    }
    
    // 대화 흐름 유지 가이드
    if (commonTopics.isNotEmpty) {
      contextHints.add('공통 주제(${commonTopics.take(3).join(", ")})를 자연스럽게 이어가세요.');
    }
    
    // 맥락 힌트가 있으면 통합해서 반환
    if (contextHints.isNotEmpty) {
      return 'CONTEXT_GUIDE:\n${contextHints.map((h) => '- $h').join('\n')}';
    }
    
    return null;
  }
  
  /// 두 텍스트 간의 유사도 계산 (0.0 ~ 1.0)
  double _calculateSimilarity(String text1, String text2) {
    final words1 = text1.toLowerCase().split(RegExp(r'[\s,\.!?]+'));
    final words2 = text2.toLowerCase().split(RegExp(r'[\s,\.!?]+'));
    
    final set1 = words1.toSet();
    final set2 = words2.toSet();
    
    final intersection = set1.intersection(set2).length;
    final union = set1.union(set2).length;
    
    if (union == 0) return 0.0;
    return intersection / union;
  }
  
  /// 급격한 주제 변경 감지
  bool _isAbruptTopicChange(String currentMessage, List<Message> recentMessages) {
    // 짧은 반응이면 주제 변경으로 보지 않음
    if (currentMessage.length < 10) return false;
    
    // 인사말이면 주제 변경으로 보지 않음
    if (_isGreeting(currentMessage.toLowerCase())) return false;
    
    // 최근 대화가 질문이었는데 관련 없는 질문을 하는 경우
    if (recentMessages.isNotEmpty) {
      final lastMessage = recentMessages.first;
      if (!lastMessage.isFromUser && lastMessage.content.contains('?')) {
        // AI가 질문했는데 사용자가 다른 질문으로 응답
        return true;
      }
    }
    
    return false;
  }
  
  /// 회피성 패턴 감지
  bool _isAvoidancePattern(String message) {
    final avoidanceKeywords = [
      '모르겠', '그런 건', '다른 이야기', '나중에', '개인적인',
      '그런 복잡한', '재밌는 얘기', '다른 걸로', '말고', '그만',
      '그런거 말고', '복잡해', '어려워', '패스', '스킵',
      '다음에', '그런 것보다', '그런건', '그런걸'
    ];
    
    final lower = message.toLowerCase();
    return avoidanceKeywords.any((keyword) => lower.contains(keyword));
  }
  
  /// 직접적인 질문인지 확인
  bool _isDirectQuestion(String message) {
    final directQuestions = [
      RegExp(r'뭐\s*하(고\s*있|는|니|냐|어|여)'),  // 뭐하고 있어? 뭐해?
      RegExp(r'(무슨|먼)\s*말'),  // 무슨 말이야? 먼말이야?
      RegExp(r'어디(야|에\s*있|\s*가|\s*있)'),  // 어디야? 어디 있어?
      RegExp(r'언제'),  // 언제?
      RegExp(r'누구(야|랑|와)'),  // 누구야? 누구랑?
      RegExp(r'왜'),  // 왜?
      RegExp(r'어떻게'),  // 어떻게?
      RegExp(r'얼마나'),  // 얼마나?
      RegExp(r'몇\s*(개|명|시|살)'),  // 몇 개? 몇 명? 몇 시?
    ];
    
    final lower = message.toLowerCase();
    return directQuestions.any((pattern) => pattern.hasMatch(lower));
  }
}

/// 채팅 응답 모델
class ChatResponse {
  final List<String> contents;  // 여러 메시지로 나눌 수 있도록 변경
  final EmotionType emotion;
  final int scoreChange;
  final Map<String, dynamic>? metadata;
  final bool isError;
  
  ChatResponse({
    required String content,  // 기존 API 호환성을 위해 유지
    List<String>? contents,   // 새로운 멀티 메시지 지원
    required this.emotion,
    required this.scoreChange,
    this.metadata,
    this.isError = false,
  }) : contents = contents ?? [content];  // contents가 없으면 content를 리스트로 변환
  
  // 편의 메서드: 첫 번째 콘텐츠 반환 (기존 코드 호환성)
  String get content => contents.isNotEmpty ? contents.first : '';
}

/// 메시지 분석 결과
class MessageAnalysis {
  final MessageType type;
  final UserEmotion emotion;
  final double complexity;
  final List<String> keywords;
  
  MessageAnalysis({
    required this.type,
    required this.emotion,
    required this.complexity,
    required this.keywords,
  });
}

/// 메시지 타입
enum MessageType {
  greeting,    // 인사
  farewell,    // 작별
  question,    // 질문
  compliment,  // 칭찬
  thanks,      // 감사
  general,     // 일반
}

/// 사용자 감정
enum UserEmotion {
  positive,    // 긍정적
  negative,    // 부정적
  curious,     // 호기심
  neutral,     // 중립
}