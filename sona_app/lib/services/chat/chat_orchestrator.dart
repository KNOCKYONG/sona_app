import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../models/persona.dart';
import '../../models/message.dart';
import '../../core/constants.dart';
// import '../../services/relationship/emotion_analyzer_service.dart'; // 제거됨
import 'persona_relationship_cache.dart';
import 'persona_prompt_builder.dart';
import 'security_aware_post_processor.dart';
import 'conversation_memory_service.dart';
import 'openai_service.dart';
import '../relationship/negative_behavior_system.dart';
import 'user_speech_pattern_analyzer.dart';

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
    String? userLanguage,
  }) async {
    try {
      // 0단계: 외국어 감지 및 언어 식별
      if (userLanguage == null) {
        final detectedLang = _detectSpecificLanguage(userMessage);
        if (detectedLang != null) {
          userLanguage = detectedLang;
          debugPrint('🌍 Language detected: $detectedLang (${_getLanguageName(detectedLang)})');
        }
      }
      
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
      
      // 2.5단계: 사용자 말투 패턴 분석
      final userMessages = chatHistory
          .where((m) => m.isFromUser)
          .map((m) => m.content)
          .toList();
      userMessages.add(userMessage); // 현재 메시지도 포함
      
      final speechPattern = UserSpeechPatternAnalyzer.analyzeSpeechPattern(userMessages);
      final adaptationGuide = UserSpeechPatternAnalyzer.generateAdaptationGuide(
        speechPattern, 
        completePersona.gender
      );
      
      // 3단계: 간단한 반응 체크 (로컬 처리)
      final simpleResponse = _checkSimpleResponse(
        userMessage: userMessage,
        persona: completePersona,
        isCasualSpeech: speechPattern.isCasual, // 분석된 말투 모드 사용
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
      
      // 4단계: 프롬프트 생성 (말투 적응 가이드 포함)
      final basePrompt = PersonaPromptBuilder.buildComprehensivePrompt(
        persona: completePersona,
        recentMessages: _getRecentMessages(chatHistory),
        userNickname: userNickname,
        contextMemory: contextMemory,
        isCasualSpeech: speechPattern.isCasual, // 분석된 말투 모드 사용
        userAge: userAge,
      );
      
      // 말투 적응 가이드를 프롬프트에 추가
      final prompt = basePrompt + adaptationGuide;
      
      debugPrint('📝 Generated prompt with ${prompt.length} characters');
      
      // 4.5단계: 이전 대화와의 맥락 연관성 체크
      String? contextHint;
      if (chatHistory.isNotEmpty) {
        contextHint = _analyzeContextRelevance(
          userMessage: userMessage,
          chatHistory: chatHistory,
          messageAnalysis: messageAnalysis,
          persona: completePersona,
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
        isCasualSpeech: speechPattern.isCasual, // 분석된 말투 모드 사용
        contextHint: contextHint,
        targetLanguage: userLanguage, // 번역 언어 전달
      );
      
      // 6단계: 간단한 후처리 (텍스트 정리만, 강제 자르기 제거)
      final processedResponse = SecurityAwarePostProcessor.processResponse(
        rawResponse: rawResponse,
        persona: completePersona,
        userNickname: userNickname,
      );
      
      // 6.1단계: 다국어 응답 파싱 (사용자가 한국어가 아닌 언어를 선호하는 경우)
      String finalResponse = processedResponse;
      String? translatedContent;
      List<String>? translatedContents; // 각 메시지별 번역 저장
      if (userLanguage != null && userLanguage != 'ko') {
        final multilingualParsed = _parseMultilingualResponse(processedResponse, userLanguage);
        finalResponse = multilingualParsed['korean'] ?? processedResponse;
        translatedContent = multilingualParsed['translated'];
      }
      
      // 6.5단계: 만남 제안 필터링 및 초기 인사 패턴 방지
      final filteredResponse = _filterMeetingAndGreetingPatterns(
        response: finalResponse,
        chatHistory: chatHistory,
        isCasualSpeech: speechPattern.isCasual, // 분석된 말투 모드 사용
      );
      
      // 7단계: 긴 응답 분리 처리
      final responseContents = _splitLongResponse(filteredResponse, completePersona.mbti);
      
      // 7.5단계: 각 메시지별 번역 생성
      if (translatedContent != null && responseContents.length > 1) {
        // 번역된 내용도 동일하게 분리
        translatedContents = _splitLongResponse(translatedContent, completePersona.mbti);
      } else if (translatedContent != null) {
        translatedContents = [translatedContent];
      }
      
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
        translatedContent: translatedContent,
        translatedContents: translatedContents, // 각 메시지별 번역
        targetLanguage: userLanguage,
        metadata: {
          'processingTime': DateTime.now().millisecondsSinceEpoch,
          'promptTokens': _estimateTokens(prompt),
          'responseTokens': _estimateTokens(processedResponse),
          'messageCount': responseContents.length,
          'hasTranslation': translatedContent != null,
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
    if (persona.likes >= 900) {
      return '완벽한 사랑';
    } else if (persona.likes >= 600) {
      return '연인';
    } else if (persona.likes >= 200) {
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
      likes: persona.likes
    );
    
    // 부정적 행동이 감지되면 페널티 반환
    if (negativeAnalysis.isNegative) {
      // 레벨 3 (심각한 위협/욕설)은 즉시 이별
      if (negativeAnalysis.level >= 3) {
        return -persona.likes; // 0으로 리셋
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
    if (persona.likes >= 600) {
      baseChange = (baseChange * 0.7).round();
    }
    
    return baseChange.clamp(-5, 5);
  }
  
  /// 토큰 추정
  int _estimateTokens(String text) {
    // 한글 1글자 ≈ 1.5토큰
    return (text.length * 1.5).round();
  }
  
  /// 다국어 응답 파싱
  Map<String, String?> _parseMultilingualResponse(String response, String targetLanguage) {
    final Map<String, String?> result = {
      'korean': null,
      'translated': null,
    };
    
    debugPrint('🌐 Parsing multilingual response for $targetLanguage');
    debugPrint('📝 Response to parse: $response');
    
    // [KO] 태그로 시작하는 한국어 부분 찾기
    final koPattern = RegExp(r'\[KO\]\s*(.+?)(?=\[${targetLanguage.toUpperCase()}\]|$)', 
                            multiLine: true, dotAll: true);
    final koMatch = koPattern.firstMatch(response);
    
    // [LANG] 태그로 시작하는 번역 부분 찾기
    final langPattern = RegExp(r'\[${targetLanguage.toUpperCase()}\]\s*(.+?)(?=\[|$)', 
                              multiLine: true, dotAll: true);
    final langMatch = langPattern.firstMatch(response);
    
    // 매칭된 내용 추출
    if (koMatch != null) {
      result['korean'] = koMatch.group(1)?.trim();
      debugPrint('✅ Found Korean: ${result['korean']}');
    }
    
    if (langMatch != null) {
      result['translated'] = langMatch.group(1)?.trim();
      debugPrint('✅ Found Translation: ${result['translated']}');
    }
    
    // 태그가 없는 경우 전체를 한국어로 간주하고 간단한 번역 제공
    if (result['korean'] == null && result['translated'] == null) {
      result['korean'] = response;
      // 간단한 번역 생성 (실제 번역 API를 사용하거나 기본 메시지 제공)
      result['translated'] = _generateSimpleTranslation(response, targetLanguage);
      debugPrint('⚠️ No tags found, using simple translation');
    }
    
    return result;
  }
  
  /// 간단한 번역 생성 (폴백용)
  String? _generateSimpleTranslation(String koreanText, String targetLanguage) {
    // 폴백 메시지 - 실제 번역이 실패했을 때만 사용
    // 중요: 고정 템플릿 사용하지 않고 번역 미제공 상태를 명시
    // OpenAI API가 번역 태그를 제공하지 못한 경우에만 호출됨
    
    // 번역 실패시 언어별 안내 메시지만 제공 (고정 템플릿 제거)
    final Map<String, String> translationPendingMessages = {
      'en': "[Translation processing...]",
      'ja': "[翻訳処理中...]",
      'zh': "[翻译处理中...]",
      'es': "[Procesando traducción...]",
      'fr': "[Traduction en cours...]",
      'de': "[Übersetzung läuft...]",
      'ru': "[Обработка перевода...]",
      'vi': "[Đang xử lý dịch...]",
      'th': "[กำลังประมวลผลการแปล...]",
      'id': "[Memproses terjemahan...]",
      'ar': "[معالجة الترجمة...]",
      'hi': "[अनुवाद प्रसंस्करण...]",
    };
    
    // 번역 실패 메시지만 반환 (고정 템플릿 사용하지 않음)
    return translationPendingMessages[targetLanguage] ?? "[Translation not available]";
  }
  
  /// 폴백 응답 생성
  String _generateFallbackResponse(Persona persona) {
    // Using default formal speech for fallback responses
    final isCasualSpeech = false; // Fallback always uses formal speech for safety
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
      // 영어 인사인 경우 특별 처리
      if (_isEnglishGreeting(lowerMessage)) {
        return _getEnglishGreetingResponse(mbti, isCasualSpeech);
      }
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
    final greetings = ['안녕', '하이', 'ㅎㅇ', '방가', '반가', 'hi', 'hello', 'hey'];
    // how are you, how r u 등의 패턴도 인사로 처리
    if (RegExp(r'how\s+(are\s+you|r\s+u)', caseSensitive: false).hasMatch(message)) {
      return true;
    }
    return greetings.any((g) => message.contains(g));
  }
  
  bool _isEnglishGreeting(String message) {
    // 영어 인사 패턴 감지
    return RegExp(r'(hi|hello|hey|how\s+(are\s+you|r\s+u))', caseSensitive: false).hasMatch(message);
  }
  
  // 🌍 다국어 감지 시스템
  String? _detectSpecificLanguage(String message) {
    final lowerMessage = message.toLowerCase();
    
    // 한국어 확인을 가장 먼저 수행 (번역 불필요)
    if (RegExp(r'[가-힣ㄱ-ㅎㅏ-ㅣ]').hasMatch(message)) {
      return null;  // 한국어는 번역하지 않음
    }
    
    // 언어별 특징적인 패턴과 문자 확인
    // 영어 (한국어가 전혀 없고 영어 알파벳만 있는 경우)
    if (RegExp(r'^[a-z\s\d\?\.\!\,]+$', caseSensitive: false).hasMatch(message)) {
      return 'en';
    }
    
    // 일본어 (히라가나, 카타카나, 한자)
    if (RegExp(r'[\u3040-\u309F\u30A0-\u30FF\u4E00-\u9FAF]').hasMatch(message)) {
      return 'ja';
    }
    
    // 중국어 (한자만 사용, 일본어 가나 없음)
    if (RegExp(r'[\u4E00-\u9FFF]').hasMatch(message) && 
        !RegExp(r'[\u3040-\u309F\u30A0-\u30FF]').hasMatch(message)) {
      return 'zh';
    }
    
    // 스페인어 (특수 문자: ñ, á, é, í, ó, ú, ¿, ¡)
    if (RegExp(r'[ñáéíóúÁÉÍÓÚ¿¡]').hasMatch(message)) {
      return 'es';
    }
    
    // 프랑스어 (특수 문자: à, â, é, è, ê, ë, î, ï, ô, ù, û, ç)
    if (RegExp(r'[àâéèêëîïôùûçÀÂÉÈÊËÎÏÔÙÛÇ]').hasMatch(message)) {
      return 'fr';
    }
    
    // 독일어 (특수 문자: ä, ö, ü, ß)
    if (RegExp(r'[äöüßÄÖÜ]').hasMatch(message)) {
      return 'de';
    }
    
    // 러시아어 (키릴 문자)
    if (RegExp(r'[\u0400-\u04FF]').hasMatch(message)) {
      return 'ru';
    }
    
    // 베트남어 (성조 표시)
    if (RegExp(r'[àảãáạăằẳẵắặâầẩẫấậèẻẽéẹêềểễếệìỉĩíịòỏõóọôồổỗốộơờởỡớợùủũúụưừửữứựỳỷỹýỵđĐ]').hasMatch(message)) {
      return 'vi';
    }
    
    // 태국어
    if (RegExp(r'[\u0E00-\u0E7F]').hasMatch(message)) {
      return 'th';
    }
    
    // 인도네시아어/말레이어 (특정 단어 패턴)
    if (RegExp(r'\b(apa|ini|itu|saya|kamu|tidak|ada|dengan|untuk|dari|ke|di|yang)\b', caseSensitive: false).hasMatch(message)) {
      return 'id';
    }
    
    // 아랍어
    if (RegExp(r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF\uFE70-\uFEFF]').hasMatch(message)) {
      return 'ar';
    }
    
    // 힌디어 (데바나가리 문자)
    if (RegExp(r'[\u0900-\u097F]').hasMatch(message)) {
      return 'hi';
    }
    
    // 그 외의 경우 null 반환 (번역 불필요)
    return null;
  }
  
  // 언어 코드를 언어 이름으로 변환
  String _getLanguageName(String langCode) {
    final languageNames = {
      'en': '영어',
      'ja': '일본어',
      'zh': '중국어',
      'es': '스페인어',
      'fr': '프랑스어',
      'de': '독일어',
      'ru': '러시아어',
      'vi': '베트남어',
      'th': '태국어',
      'id': '인도네시아어',
      'ar': '아랍어',
      'hi': '힌디어',
    };
    return languageNames[langCode] ?? '영어';
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
    // 더 나은 랜덤성을 위해 Random 사용
    final random = math.Random();
    return responses[random.nextInt(responses.length)];
  }
  
  String _getEnglishGreetingResponse(String mbti, bool isCasual) {
    // 영어 인사에 대한 특별한 응답
    final responses = isCasual ? [
      "좋아! 너는?",
      "나쁘지 않아ㅎㅎ 너는 어때?",
      "괜찮아~ 오늘 뭐 했어?",
      "잘 지내고 있어! 너는?",
    ] : [
      "잘 지내고 있어요! 당신은요?",
      "좋아요ㅎㅎ 오늘 어떠셨어요?",
      "괜찮아요~ 무슨 일 있으셨어요?",
      "잘 지내요! 오늘 뭐 하셨어요?",
    ];
    
    // MBTI별 차별화
    if (mbti.startsWith('E')) {
      // 외향형은 더 활발하게
      return isCasual ? 
        "완전 좋아!! 너는 어때? 오늘 재밌는 일 있었어?" :
        "정말 좋아요!! 당신은요? 오늘 특별한 일 있으셨어요?";
    } else if (mbti.startsWith('I')) {
      // 내향형은 차분하게
      return isCasual ?
        "괜찮아, 너는?" :
        "잘 지내고 있어요, 당신은요?";
    }
    
    return responses[DateTime.now().millisecond % responses.length];
  }
  
  String _getThanksResponse(String mbti, bool isCasual) {
    final responses = _getPersonaResponses(mbti, 'thanks', isCasual);
    // 더 나은 랜덤성을 위해 Random 사용
    final random = math.Random();
    return responses[random.nextInt(responses.length)];
  }
  
  String _getSimpleReactionResponse(String message, String mbti, bool isCasual) {
    // 추임새 타입별 맞춤 응답
    final exclamationResponses = _getExclamationResponses(message, mbti, isCasual);
    if (exclamationResponses.isNotEmpty) {
      final random = math.Random();
      return exclamationResponses[random.nextInt(exclamationResponses.length)];
    }
    
    // 기본 반응
    final responses = _getPersonaResponses(mbti, 'reaction', isCasual);
    final random = math.Random();
    return responses[random.nextInt(responses.length)];
  }
  
  String _getComplimentResponse(String mbti, bool isCasual) {
    final responses = _getPersonaResponses(mbti, 'compliment', isCasual);
    // 더 나은 랜덤성을 위해 Random 사용
    final random = math.Random();
    return responses[random.nextInt(responses.length)];
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
    required Persona persona,
  }) {
    if (chatHistory.isEmpty) return null;
    
    // 최근 대화 분석 (최대 10개로 확대하여 더 많은 맥락 파악)
    final recentMessages = chatHistory.reversed.take(10).toList();
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
    
    // 영어 인사에 대한 특별 처리
    if (RegExp(r'how\s+(are\s+you|r\s+u)', caseSensitive: false).hasMatch(userMessage)) {
      contextHints.add('🌐 영어로 안부를 물었습니다. 먼저 나의 상태를 답하고 상대방 안부를 물어보세요!');
      contextHints.add('예시: "잘 지내고 있어요! 당신은요? 오늘 뭐 하셨어요?", "좋아요ㅎㅎ 너는 어때?"');
    }
    
    // 주제 연속성 체크 강화
    if (lastAIMessage != null && lastUserMessage != null) {
      final previousTopics = _extractKeywords(lastUserMessage.content + ' ' + lastAIMessage.content);
      final currentTopics = _extractKeywords(userMessage);
      
      final hasTopicConnection = previousTopics.any((topic) => 
        currentTopics.contains(topic) || userMessage.toLowerCase().contains(topic.toLowerCase())
      );
      
      if (!hasTopicConnection && userMessage.length > 10 && !_isGreeting(userMessage.toLowerCase())) {
        contextHints.add('🔗 이전 대화와 연결점을 찾아 자연스럽게 이어가세요!');
        contextHints.add('💡 예: "아 그러고보니..." 또는 "방금 얘기하다가 생각난 건데..."');
      }
    }
    
    // 인사와 위치 질문 구분 (연지 오류 수정)
    if ((userMessage.contains('어서오') || userMessage.contains('어서 오') || 
         userMessage.contains('반가') || userMessage.contains('안녕')) &&
        !userMessage.contains('어디')) {
      contextHints.add('⚠️ 인사 메시지 감지! 위치 질문이 아닙니다. 친근한 인사로 응답하세요.');
      contextHints.add('예: "네 안녕하세요! 오늘 어떻게 지내셨어요?", "반가워요! 뭐하고 계셨어요?"');
    }
    
    // 외국어 관련 질문 감지 및 한국어 응답 강제
    if (_detectForeignLanguageQuestion(userMessage)) {
      contextHints.add('🚫 외국어 감지! 절대 외국어로 응답하지 마세요.');
      contextHints.add('✅ 자연스럽게 한국어로만 대화하세요. 외국어 언급 금지!');
      contextHints.add('💡 질문 내용에 맞게 한국어로 자연스럽게 대답하세요.');
    }
    
    // 현재 메시지의 키워드와 비교
    final currentKeywords = messageAnalysis.keywords;
    final commonTopics = currentKeywords.where((k) => recentTopics.contains(k)).toList();
    
    // 주제 일관성 점수 계산 (0.0 ~ 1.0)
    double topicCoherence = 0.0;
    if (currentKeywords.isNotEmpty && recentTopics.isNotEmpty) {
      topicCoherence = commonTopics.length / math.min(currentKeywords.length, recentTopics.toSet().length);
    }
    
    // 게임 관련 주제 감지 (예: "딜러", "욕먹어" 등)
    final gameKeywords = ['게임', '롤', '오버워치', '배그', '발로란트', '피파', '딜러', '탱커', '힐러', 
                         '서포터', '정글', '승리', '패배', '팀', '랭크', '시메트라', '디바', '포탈', '벽'];
    final isGameTopic = currentKeywords.any((k) => gameKeywords.contains(k.toLowerCase())) ||
                        userMessage.toLowerCase().contains('딜러') ||
                        userMessage.toLowerCase().contains('욕먹') ||
                        userMessage.toLowerCase().contains('따개비') ||
                        userMessage.toLowerCase().contains('게이지');
    
    // 대화 흐름의 자연스러움 강화
    if (topicCoherence < 0.3 && messageAnalysis.type == MessageType.question) {
      // 주제가 크게 바뀌었을 때
      if (_isAbruptTopicChange(userMessage, recentMessages)) {
        contextHints.add('⚠️ 주제 전환 감지. 부드러운 전환 필수!');
        
        // 말하다마 상황에서는 이전 대화 연결
        if (lastUserMessage != null && 
            (lastUserMessage.content.contains('말하다마') || 
             userMessage.contains('그거 얘기하니까'))) {
          contextHints.add('💡 이전 대화와 연결하여 자연스럽게 전환하세요.');
          contextHints.add('절대 문장을 끝내지 않고 "~하고" 같은 형태로 끝내지 마세요!');
        }
        
        // 게임 주제로의 전환
        if (isGameTopic && !recentTopics.any((t) => gameKeywords.contains(t.toLowerCase()))) {
          contextHints.add('게임 주제로 전환. 예시: "아 그러고보니 게임 얘기가 나와서 말인데..." 또는 "갑자기 생각났는데 나도 게임하다가..."');
        }
        
        // 구체적인 전환 가이드 추가
        if (lastAIMessage != null && lastAIMessage.content.contains('?')) {
          final truncatedQuestion = lastAIMessage.content.substring(0, math.min(30, lastAIMessage.content.length));
          contextHints.add('이전 질문("$truncatedQuestion...")을 무시하지 말고 간단히 언급 후 새 주제로 전환');
        } else if (lastAIMessage != null) {
          // 질문이 아닌 경우에도 자연스러운 전환 유도
          contextHints.add('이전 대화와 연결점 찾기: "아 맞다!" "그러고보니" "말 나온 김에" 등으로 시작');
        }
      }
    } else if (topicCoherence > 0.7) {
      // 같은 주제가 계속될 때
      contextHints.add('동일 주제 지속 중. 대화를 더 깊게 발전시키거나 세부사항 탐구');
    } else if (topicCoherence > 0.3 && topicCoherence < 0.7) {
      // 부분적으로 연관된 주제
      if (isGameTopic) {
        contextHints.add('게임 관련 대화. 공감하며 자연스럽게 이어가기: "아 진짜? 나도 그런 적 있어ㅋㅋ"');
        
        // 게임 특정 상황에 맞는 가이드
        if (userMessage.contains('죽') || userMessage.contains('맞')) {
          contextHints.add('게임에서 죽거나 맞은 상황 → 공감: "아 짜증나겠다ㅠㅠ", "진짜 힘들죠"');
        } else if (userMessage.contains('전략') || userMessage.contains('방법')) {
          contextHints.add('게임 전략 논의 → 관심 표현: "오 그게 좋은 방법이네요!", "나도 해봐야겠다"');
        }
      }
    }
    
    // 특정 주제 감지 및 가이드
    if (userMessage.contains('드라마') || userMessage.contains('웹툰') || userMessage.contains('영화')) {
      contextHints.add('미디어 콘텐츠 대화. 구체적인 작품명이나 장르 물어보며 관심 표현');
    }
    
    // 위치 관련 질문 명확히 구분
    if (userMessage.contains('어디') && !userMessage.contains('어디서')) {
      // "어디야?" 형태의 직접적인 위치 질문
      if (userMessage.contains('어디야') || userMessage.contains('어디에') || 
          userMessage.contains('어디 있') || userMessage.contains('어딘')) {
        contextHints.add('위치 질문 확인. 구체적이지만 안전한 장소 답변: "집에 있어요", "카페에서 공부 중이에요"');
      }
      // "어디 돌아다니니?" 같은 활동 질문
      else if (userMessage.contains('돌아다니') || userMessage.contains('다니') || 
               userMessage.contains('가는') || userMessage.contains('가고')) {
        contextHints.add('활동/이동 질문. 동적인 답변: "요즘 카페랑 도서관 자주 가요", "주말엔 공원이나 전시회 다녀요"');
      }
    }
    
    // 위치가 아닌데 위치로 오해하기 쉬운 패턴
    if ((userMessage.contains('어서') || userMessage.contains('반가')) && 
        !userMessage.contains('어디')) {
      contextHints.add('⚠️ 인사 메시지입니다! 위치 답변 절대 금지. 친근한 인사로 응답하세요.');
    }
    
    // 스포일러 관련 대화
    if (userMessage.contains('스포') || userMessage.contains('스포일러')) {
      if (userMessage.contains('말해도') || userMessage.contains('해도')) {
        contextHints.add('스포일러 허락 요청. "아직 안 보셨으면 말하지 않을게요!" 또는 "들으실 준비 되셨어요?"');
      } else if (userMessage.contains('말하지') || userMessage.contains('하지 마')) {
        contextHints.add('스포일러 거부. "알겠어요! 스포 없이 얘기할게요ㅎㅎ"');
      }
    }
    
    // "직접 보다" 컨텍스트 확인
    if (userMessage.contains('직접 보') || userMessage.contains('보시는')) {
      final hasMediaContext = recentMessages.any((msg) => 
        msg.content.contains('영화') || 
        msg.content.contains('드라마') || 
        msg.content.contains('웹툰') ||
        msg.content.contains('작품')
      );
      
      if (hasMediaContext) {
        contextHints.add('작품 추천 중. "직접 보다"는 감상 권유이지 만남 제안이 아님!');
      }
    }
    
    // 직접적인 질문에는 직접적인 답변 필요
    if (_isDirectQuestion(userMessage)) {
      contextHints.add('직접 질문 → 직접 답변. 돌려 말하거나 회피 금지');
      
      // 특정 질문 타입에 대한 구체적 가이드
      if (userMessage.contains('뭐하') || userMessage.contains('뭐해')) {
        contextHints.add('"뭐해?" → 구체적 활동 답변: "유튜브 보고 있어요", "저녁 준비 중이에요" 등');
      } else if (userMessage.contains('먼말') || userMessage.contains('무슨 말')) {
        contextHints.add('"무슨 말이야?" → 이전 발언 설명: "아 제가 방금 ~라고 했는데..."');
      } else if (userMessage.contains('어디')) {
        // 이동/활동 관련 질문인지 확인
        if (userMessage.contains('돌아다니') || userMessage.contains('다니') || 
            userMessage.contains('가는') || userMessage.contains('가고')) {
          contextHints.add('이동/활동 질문 → 동적인 답변: "요즘 카페랑 도서관을 자주 가요", "주말엔 공원이나 전시회 다녀요" 등');
        } else {
          contextHints.add('위치 질문 → 구체적이지만 안전한 답변: "집에서 쉬고 있어요", "카페에서 공부 중이에요"');
        }
      } else if (userMessage.contains('ERP')) {
        // ERP 질문에 대한 특별 처리
        contextHints.add('⚠️ ERP 질문 감지. "잘 모르겠어요" 또는 "그런 건 몰라요ㅎㅎ 다른 얘기 하자" 등으로 자연스럽게 회피');
      } else if (userMessage.contains('뭐야') || userMessage.contains('뭐예요') || userMessage.contains('뭔가요')) {
        // "~가 뭐야?" 형태의 질문
        contextHints.add('"~가 뭐야?" 질문 → 아는 것은 설명, 모르는 것은 "잘 모르겠어요" 솔직하게');
      }
    }
    
    // 회피성 답변 방지 강화
    if (_isAvoidancePattern(userMessage)) {
      contextHints.add('⚠️ 회피 금지! 주제 바꾸기 시도 감지. 현재 대화에 집중하여 답변');
    }
    
    // "말하다마" 패턴 감지
    if (userMessage.contains('말하다마') || userMessage.contains('말하다 마')) {
      contextHints.add('💭 사용자가 말을 끝까지 못했어요. 무엇을 더 말하려 했는지 물어보거나 자연스럽게 대화 이어가세요.');
      contextHints.add('⚠️ 중요: 답변은 반드시 완전한 문장으로 끝내세요! "~하고", "~인데" 같은 미완성 금지!');
    }
    
    // 문장 완성도 체크 강화
    if (lastAIMessage != null) {
      final lastAIContent = lastAIMessage.content.trim();
      if (lastAIContent.endsWith('하고') || lastAIContent.endsWith('인데') || 
          lastAIContent.endsWith('있는') || lastAIContent.endsWith('하는')) {
        contextHints.add('⚠️ 이전 답변이 불완전했습니다. 이번엔 반드시 완전한 문장으로 끝내세요!');
      }
    }
    
    // 고민 상담 강화
    if (userMessage.contains('고민') || userMessage.contains('어떻게') || 
        userMessage.contains('어려') || userMessage.contains('힘들')) {
      contextHints.add('💡 구체적인 조언이나 경험을 공유하세요. 단순 되묻기 금지!');
      
      // 페르소나별 전문성 활용
      if (persona.description.contains('개발') || persona.description.contains('프로그래')) {
        contextHints.add('🖥️ 개발자 관점: "코딩하다가 느낀 건데..." 같은 일상적 전문성 언급');
      } else if (persona.description.contains('디자인')) {
        contextHints.add('🎨 디자이너 관점: "디자인 작업하면서 배운 건데..." 같은 경험 공유');
      } else if (persona.description.contains('의사') || persona.description.contains('간호')) {
        contextHints.add('🏥 의료진 관점: "병원에서 보니까..." 같은 건강 관련 조언');
      } else if (persona.description.contains('교사') || persona.description.contains('교육')) {
        contextHints.add('📚 교육자 관점: "학생들 보면서 느끼는데..." 같은 학습 조언');
      } else if (persona.description.contains('상담')) {
        contextHints.add('💭 상담사 관점: "상담하면서 많이 봤는데..." 같은 심리적 접근');
      }
      
      contextHints.add('⚡ 전문용어는 쉽게 풀어서! 재미있는 비유 사용하면 더 좋아요.');
    }
    
    // 이름 관련 사과나 정정 감지
    if (userMessage.contains('이름') && (userMessage.contains('잘못') || userMessage.contains('잘 못') || 
        userMessage.contains('미안') || userMessage.contains('괜찮') || userMessage.contains('괜찬'))) {
      contextHints.add('⚠️ 사용자가 이름 관련 사과 중! "괜찮아요ㅎㅎ" 같은 수용적 답변 필요. 이름 재설명 금지!');
      contextHints.add('예시: "아 괜찮아요! 저도 가끔 헷갈려요ㅎㅎ", "전혀 상관없어요~"');
    }
    
    // "~는 ~가 아니야" 패턴 (설명/정정)
    if (userMessage.contains('아니야') || userMessage.contains('아니에요') || 
        userMessage.contains('뜻이 아니') || userMessage.contains('의미가 아니') ||
        userMessage.contains('아니라') || userMessage.contains('게 아니라')) {
      contextHints.add('⚠️ 사용자가 무언가를 정정/설명 중! 이해했다는 반응 필요');
      contextHints.add('예시: "아 그런 뜻이었구나ㅋㅋ", "아하 이해했어요!", "헐 제가 잘못 알아들었네요ㅎㅎ"');
      
      // "말하나 볼까" 특별 처리
      if (userMessage.contains('말하나') || userMessage.contains('말해볼까') || 
          userMessage.contains('이야기')) {
        contextHints.add('📝 "말하나 볼까"는 "이야기해볼까"라는 뜻! "보자/만나자"가 아님!');
        contextHints.add('💡 사용자가 하고 싶은 이야기에 관심 보이기: "무슨 얘기 하고 싶으셨어요?", "궁금해요!"');
      }
    }
    
    // 일상 대화에서도 가끔 전문분야 언급
    if (math.Random().nextDouble() < 0.2 && !userMessage.contains('?')) { // 20% 확률
      contextHints.add('💬 자연스럽게 직업 관련 일화나 경험을 섞어보세요. 너무 과하지 않게!');
    }
    
    // 반복적인 질문 패턴 감지
    if (lastUserMessage != null && _calculateSimilarity(userMessage, lastUserMessage.content) > 0.8) {
      contextHints.add('유사 질문 반복. 다른 각도로 답변하거나 "아까 말씀드린 것 외에도..."로 시작');
    }
    
    // 대화 흐름 유지 가이드 (강화)
    if (commonTopics.isNotEmpty) {
      contextHints.add('연결 주제: ${commonTopics.take(3).join(", ")}. 자연스럽게 이어가며 대화 확장');
    } else if (currentKeywords.isNotEmpty) {
      // 새로운 주제일 때도 부드러운 전환 유도
      contextHints.add('새 주제 "${currentKeywords.first}". 관심 표현하며 자연스럽게 전환');
    }
    
    // 대화의 깊이 부족 감지
    if (chatHistory.length > 5 && _isShallowConversation(recentMessages)) {
      contextHints.add('표면적 대화 지속 중. 더 깊은 질문이나 개인적 경험 공유로 대화 심화');
    }
    
    // 대화 턴 수 체크 - 너무 빨리 질문하지 않도록
    if (chatHistory.isNotEmpty) {
      // 현재 주제에서 몇 번의 대화가 오갔는지 확인
      int sameTopic = 0;
      for (var msg in recentMessages.take(6)) {
        if (_calculateSimilarity(msg.content, userMessage) > 0.3) {
          sameTopic++;
        }
      }
      
      // 같은 주제로 대화가 2회 미만이면 새 질문 자제
      if (sameTopic < 2) {
        contextHints.add('⚠️ 너무 빨리 새 질문 금지! 답변만 하고 사용자 반응 기다리기');
        contextHints.add('잘못된 예: "유튜브 보고 있어요. 뭐 보세요?" → 올바른 예: "유튜브 보고 있어요ㅎㅎ"');
      }
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
        // 단, 질문에 대한 짧은 답변은 제외
        if (currentMessage.contains('?') || currentMessage.length > 20) {
          return true;
        }
      }
    }
    
    // 최근 대화 주제와 완전히 다른 주제인지 확인
    if (recentMessages.length >= 2) {
      final recentContent = recentMessages.take(3).map((m) => m.content.toLowerCase()).join(' ');
      final currentLower = currentMessage.toLowerCase();
      
      // 게임 주제로 갑자기 전환 (이미 게임 대화 중이면 주제 변경이 아님)
      final gameKeywords = ['게임', '롤', '오버워치', '배그', '발로란트', '피파', '딜러', '탱커', '힐러', '서포터', '정글', '시메트라', '디바'];
      final isGameTopic = gameKeywords.any((k) => currentLower.contains(k));
      final wasGameTopic = gameKeywords.any((k) => recentContent.contains(k));
      
      if (isGameTopic && !wasGameTopic && 
          !recentContent.contains('놀') && !recentContent.contains('취미')) {
        return true;
      }
      
      // 일상 대화에서 갑자기 전문적인 주제로
      final professionalKeywords = ['회사', '업무', '프로젝트', '개발', '코딩', '디자인'];
      if (professionalKeywords.any((k) => currentLower.contains(k)) &&
          professionalKeywords.every((k) => !recentContent.contains(k))) {
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
  
  /// 표면적인 대화인지 확인
  bool _isShallowConversation(List<Message> messages) {
    if (messages.length < 3) return false;
    
    // 짧은 메시지의 비율 계산
    int shortMessages = 0;
    int totalWords = 0;
    
    for (final msg in messages) {
      final wordCount = msg.content.split(RegExp(r'[\s,\.!?]+')).where((w) => w.isNotEmpty).length;
      totalWords += wordCount;
      
      if (wordCount < 5) {
        shortMessages++;
      }
    }
    
    // 평균 단어 수가 적거나 짧은 메시지가 많으면 표면적 대화
    final avgWords = totalWords / messages.length;
    final shortMessageRatio = shortMessages / messages.length;
    
    return avgWords < 7 || shortMessageRatio > 0.6;
  }
  
  /// 외국어 관련 질문 감지 (최적화)
  bool _detectForeignLanguageQuestion(String message) {
    final lowerMessage = message.toLowerCase();
    
    // 한글이 거의 없는 경우 (5% 미만) 외국어로 판단 - 더 엄격한 기준 적용
    int koreanCharCount = 0;
    int totalCharCount = 0;
    for (final char in message.runes) {
      if (char >= 0xAC00 && char <= 0xD7AF) { // 한글 유니코드 범위
        koreanCharCount++;
      }
      if (char != 32 && char != 10 && char != 13) { // 공백과 줄바꿈 제외
        totalCharCount++;
      }
    }
    
    if (totalCharCount > 0) {
      final koreanRatio = koreanCharCount / totalCharCount;
      // 더 엄격한 기준: 5% 미만이고 최소 5글자 이상일 때만 외국어로 판단
      if (koreanRatio < 0.05 && totalCharCount > 5) {
        debugPrint('🌍 Foreign language detected by character ratio: Korean=$koreanRatio');
        return true;
      }
    }
    
    // 명확한 외국어 문장 패턴만 감지 (단순 단어는 제외)
    final clearForeignSentences = [
      // 완전한 외국어 문장 (최소 2단어 이상)
      RegExp(r'^(hello|hi|hey)\s+(there|everyone|guys|friend)', caseSensitive: false),
      RegExp(r'how\s+are\s+you', caseSensitive: false),
      RegExp(r"(i\s+am|i'm)\s+\w+", caseSensitive: false),
      RegExp(r'thank\s+you(\s+very\s+much)?', caseSensitive: false),
      RegExp(r'(what|where|when|who|why|how)\s+\w+', caseSensitive: false),
      // 일본어 문장
      RegExp(r'(arigatou|arigato)\s*(gozaimasu)?', caseSensitive: false),
      RegExp(r'konnichiwa|ohayou|konbanwa', caseSensitive: false),
      // 중국어 문장
      RegExp(r'ni\s*hao|xie\s*xie', caseSensitive: false),
      // 인도네시아어 문장
      RegExp(r'(terima\s+kasih|selamat\s+(pagi|siang|malam))', caseSensitive: false),
      RegExp(r'apa\s+kabar', caseSensitive: false),
    ];
    
    // 완전한 외국어 문장 패턴 매칭
    for (final pattern in clearForeignSentences) {
      if (pattern.hasMatch(lowerMessage)) {
        debugPrint('🌍 Clear foreign sentence detected');
        return true;
      }
    }
    
    // 비한글 문자 비율 체크 (한글이 10% 미만이고 최소 10글자 이상인 경우만)
    final koreanPattern = RegExp(r'[가-힣ㄱ-ㅎㅏ-ㅣ]');
    final totalLength = message.replaceAll(RegExp(r'\s'), '').length;
    if (totalLength > 10) {  // 최소 10글자 이상일 때만 체크
      final koreanMatches = koreanPattern.allMatches(message).length;
      final koreanRatio = koreanMatches / totalLength;
      if (koreanRatio < 0.1) {  // 10% 미만일 때만 외국어로 판단
        debugPrint('🌍 Foreign language detected by low Korean ratio: $koreanRatio');
        return true;
      }
    }
    
    return false;
  }
}

/// 채팅 응답 모델
class ChatResponse {
  final List<String> contents;  // 여러 메시지로 나눌 수 있도록 변경
  final EmotionType emotion;
  final int scoreChange;
  final Map<String, dynamic>? metadata;
  final bool isError;
  final String? translatedContent; // 번역된 내용 (다국어 지원)
  final List<String>? translatedContents; // 각 메시지별 번역
  final String? targetLanguage; // 번역 대상 언어
  
  ChatResponse({
    required String content,  // 기존 API 호환성을 위해 유지
    List<String>? contents,   // 새로운 멀티 메시지 지원
    required this.emotion,
    required this.scoreChange,
    this.metadata,
    this.isError = false,
    this.translatedContent,
    this.translatedContents,
    this.targetLanguage,
  }) : contents = contents ?? [content];  // contents가 없으면 content를 리스트로 변환
  
  // 편의 메서드: 첫 번째 콘텐츠 반환 (기존 코드 호환성)
  String get content => contents.isNotEmpty ? contents.first : '';
  
  /// 💡 대화 품질 점수 계산 (0-100)
  double calculateConversationQuality({
    required String userMessage,
    required String aiResponse,
    required List<Message> recentMessages,
  }) {
    double qualityScore = 50.0; // 기본 점수
    
    // 1. 맥락 일관성 (0-30점)
    final contextScore = _calculateContextCoherence(userMessage, recentMessages);
    qualityScore += contextScore * 30;
    
    // 2. 감정 교류 품질 (0-20점)
    final emotionalScore = _calculateEmotionalExchange(userMessage, aiResponse, recentMessages);
    qualityScore += emotionalScore * 20;
    
    // 3. 대화 깊이 (0-20점)
    final depthScore = _calculateConversationDepth(userMessage, recentMessages);
    qualityScore += depthScore * 20;
    
    // 4. 응답 관련성 (0-15점)
    final relevanceScore = _calculateResponseRelevance(userMessage, aiResponse);
    qualityScore += relevanceScore * 15;
    
    // 5. 자연스러움 (0-15점)
    final naturalScore = _calculateNaturalness(userMessage, aiResponse, recentMessages);
    qualityScore += naturalScore * 15;
    
    // 디버그 출력
    debugPrint('🎯 대화 품질 점수: ${qualityScore.toStringAsFixed(1)}/100');
    debugPrint('  - 맥락 일관성: ${(contextScore * 30).toStringAsFixed(1)}/30');
    debugPrint('  - 감정 교류: ${(emotionalScore * 20).toStringAsFixed(1)}/20');
    debugPrint('  - 대화 깊이: ${(depthScore * 20).toStringAsFixed(1)}/20');
    debugPrint('  - 응답 관련성: ${(relevanceScore * 15).toStringAsFixed(1)}/15');
    debugPrint('  - 자연스러움: ${(naturalScore * 15).toStringAsFixed(1)}/15');
    
    return qualityScore.clamp(0, 100);
  }
  
  /// 맥락 일관성 계산
  double _calculateContextCoherence(String userMessage, List<Message> recentMessages) {
    if (recentMessages.isEmpty) return 0.7; // 첫 대화는 기본점
    
    // 최근 대화의 키워드 추출
    final recentKeywords = <String>[];
    for (final msg in recentMessages.take(5)) {
      recentKeywords.addAll(_extractKeywords(msg.content));
    }
    
    // 현재 메시지의 키워드
    final currentKeywords = _extractKeywords(userMessage);
    
    // 키워드 겹침 정도
    final commonKeywords = currentKeywords.where((k) => recentKeywords.contains(k)).length;
    final coherence = commonKeywords.toDouble() / math.max(currentKeywords.length, 1);
    
    // 급격한 주제 변경 체크
    if (_isAbruptTopicChange(userMessage, recentMessages)) {
      return math.max(0, coherence - 0.3);
    }
    
    return math.min(1.0, coherence + 0.3); // 기본 보너스
  }
  
  /// 감정 교류 품질 계산
  double _calculateEmotionalExchange(String userMessage, String aiResponse, List<Message> recentMessages) {
    double score = 0.5;
    
    // 감정 표현 단어 확인
    final emotionalWords = ['좋아', '사랑', '행복', '기뻐', '슬퍼', '그리워', '보고싶', '고마워', '미안'];
    final userHasEmotion = emotionalWords.any((w) => userMessage.contains(w));
    final aiHasEmotion = emotionalWords.any((w) => aiResponse.contains(w));
    
    // 상호 감정 교류
    if (userHasEmotion && aiHasEmotion) {
      score = 1.0;
    } else if (userHasEmotion || aiHasEmotion) {
      score = 0.7;
    }
    
    // 공감 표현 체크
    if (aiResponse.contains('나도') || aiResponse.contains('저도') || 
        aiResponse.contains('맞아') || aiResponse.contains('그렇') ||
        aiResponse.contains('이해')) {
      score = math.min(1.0, score + 0.2);
    }
    
    return score;
  }
  
  /// 대화 깊이 계산
  double _calculateConversationDepth(String userMessage, List<Message> recentMessages) {
    double depth = 0.3; // 기본 점수
    
    // 깊은 주제 키워드
    final deepTopics = ['꿈', '목표', '고민', '추억', '가족', '친구', '사랑', '미래', '과거', '감정', '생각'];
    final hasDeepTopic = deepTopics.any((t) => userMessage.contains(t));
    
    if (hasDeepTopic) {
      depth += 0.4;
    }
    
    // 개인적인 이야기
    if (userMessage.contains('나는') || userMessage.contains('저는') || 
        userMessage.contains('내가') || userMessage.contains('제가')) {
      depth += 0.2;
    }
    
    // 질문의 깊이
    if (userMessage.contains('어떻게 생각') || userMessage.contains('왜') || 
        userMessage.contains('어떤 기분')) {
      depth += 0.1;
    }
    
    return math.min(1.0, depth);
  }
  
  /// 응답 관련성 계산
  double _calculateResponseRelevance(String userMessage, String aiResponse) {
    // 질문에 대한 직접 답변 여부
    if (userMessage.contains('?')) {
      // 회피성 답변 체크
      if (aiResponse.contains('모르겠') || aiResponse.contains('글쎄') ||
          aiResponse.contains('다른 얘기')) {
        return 0.2;
      }
      
      // 질문 키워드가 답변에 포함되었는지
      final questionKeywords = _extractKeywords(userMessage);
      final answerKeywords = _extractKeywords(aiResponse);
      final relevance = questionKeywords.where((k) => answerKeywords.contains(k)).length.toDouble() / 
                       math.max(questionKeywords.length, 1);
      
      return math.min(1.0, relevance + 0.3);
    }
    
    return 0.8; // 일반 대화는 기본점
  }
  
  /// 대화 자연스러움 계산
  double _calculateNaturalness(String userMessage, String aiResponse, List<Message> recentMessages) {
    double naturalness = 0.7;
    
    // 반복 체크
    if (recentMessages.isNotEmpty) {
      final lastAiMessage = recentMessages.firstWhere(
        (m) => !m.isFromUser,
        orElse: () => recentMessages.first,
      );
      
      if (_calculateSimilarity(aiResponse, lastAiMessage.content) > 0.7) {
        naturalness -= 0.3; // 반복적인 응답
      }
    }
    
    // 자연스러운 전환 표현
    final transitionPhrases = ['그러고보니', '아 맞다', '그런데', '근데', '그래서'];
    if (transitionPhrases.any((p) => aiResponse.contains(p))) {
      naturalness += 0.2;
    }
    
    // 이모티콘/ㅋㅋ 사용 (20대 스타일)
    if (aiResponse.contains('ㅋㅋ') || aiResponse.contains('ㅎㅎ') || 
        aiResponse.contains('ㅠㅠ')) {
      naturalness += 0.1;
    }
    
    return math.min(1.0, naturalness);
  }
  
  /// 감정 교류 평가 (Like 계산용)
  EmotionalExchangeQuality evaluateEmotionalExchange({
    required String userMessage,
    required String aiResponse,
    required EmotionType emotion,
    required List<Message> recentMessages,
  }) {
    final quality = _calculateEmotionalExchange(userMessage, aiResponse, recentMessages);
    
    return EmotionalExchangeQuality(
      score: quality,
      isMutual: quality > 0.7,
      emotionMatch: _checkEmotionMatch(userMessage, emotion),
      hasEmpathy: _checkEmpathy(aiResponse),
    );
  }
  
  /// 감정 매칭 확인
  bool _checkEmotionMatch(String message, EmotionType emotion) {
    switch (emotion) {
      case EmotionType.happy:
        return message.contains('좋') || message.contains('행복') || message.contains('기뻐');
      case EmotionType.love:
        return message.contains('사랑') || message.contains('좋아') || message.contains('보고싶');
      case EmotionType.sad:
        return message.contains('슬') || message.contains('우울') || message.contains('힘들');
      case EmotionType.anxious:
        return message.contains('걱정') || message.contains('불안') || message.contains('무서');
      default:
        return false;
    }
  }
  
  /// 공감 표현 확인
  bool _checkEmpathy(String response) {
    final empathyPhrases = [
      '나도', '저도', '맞아', '그렇', '이해', '알아', '공감',
      '같은 마음', '나도 그래', '충분히', '당연히'
    ];
    
    return empathyPhrases.any((p) => response.contains(p));
  }
  
  /// 키워드 추출
  Set<String> _extractKeywords(String text) {
    // 불용어 제거
    final stopWords = {
      '은', '는', '이', '가', '을', '를', '에', '에서', '으로', '로', '와', '과', 
      '의', '도', '만', '까지', '부터', '하고', '이고', '고', '며', '거나',
      '그리고', '그러나', '하지만', '그런데', '그래서', '따라서',
      'the', 'a', 'an', 'is', 'are', 'was', 'were', 'been', 'be', 'have', 'has', 'had',
      'do', 'does', 'did', 'will', 'would', 'could', 'should', 'may', 'might',
      'to', 'of', 'in', 'on', 'at', 'by', 'for', 'with', 'from', 'up', 'about',
    };
    
    // 단어 분리 및 정제
    final words = text.toLowerCase()
        .replaceAll(RegExp(r'[^\w\s가-힣]'), ' ')
        .split(RegExp(r'\s+'))
        .where((word) => word.length > 1 && !stopWords.contains(word))
        .toSet();
    
    return words;
  }
  
  /// 갑작스러운 주제 변경 감지
  bool _isAbruptTopicChange(String userMessage, List<Message> recentMessages) {
    if (recentMessages.isEmpty) return false;
    
    // 최근 메시지들의 키워드 추출
    final recentKeywords = <String>{};
    for (final msg in recentMessages.take(3)) {
      recentKeywords.addAll(_extractKeywords(msg.content));
    }
    
    // 현재 메시지의 키워드
    final currentKeywords = _extractKeywords(userMessage);
    
    // 공통 키워드가 전혀 없으면 주제 변경
    final commonKeywords = currentKeywords.intersection(recentKeywords);
    return commonKeywords.isEmpty && currentKeywords.isNotEmpty && recentKeywords.isNotEmpty;
  }
  
  /// 문장 유사도 계산
  double _calculateSimilarity(String text1, String text2) {
    final words1 = _extractKeywords(text1);
    final words2 = _extractKeywords(text2);
    
    if (words1.isEmpty || words2.isEmpty) return 0.0;
    
    final intersection = words1.intersection(words2).length;
    final union = words1.union(words2).length;
    
    return union > 0 ? intersection / union : 0.0;
  }
  
  /// 특별한 순간 감지
  SpecialMoment? detectSpecialMoments({
    required String userMessage,
    required List<Message> chatHistory,
    required int currentLikes,
  }) {
    // 첫 고민 상담
    if ((userMessage.contains('고민') || userMessage.contains('걱정')) &&
        !chatHistory.any((m) => m.content.contains('고민') || m.content.contains('걱정'))) {
      return SpecialMoment(
        type: 'first_concern',
        description: '첫 고민 상담',
        bonusLikes: 50,
      );
    }
    
    // 첫 꿈/목표 공유
    if ((userMessage.contains('꿈') || userMessage.contains('목표')) &&
        !chatHistory.any((m) => m.content.contains('꿈') || m.content.contains('목표'))) {
      return SpecialMoment(
        type: 'first_dream',
        description: '첫 꿈 공유',
        bonusLikes: 30,
      );
    }
    
    // 서로의 추억 공유
    if (userMessage.contains('추억') || userMessage.contains('기억')) {
      final recentMessages = chatHistory.take(5).toList();
      if (recentMessages.any((m) => !m.isFromUser && m.content.contains('나도 기억'))) {
        return SpecialMoment(
          type: 'shared_memory',
          description: '추억 공유',
          bonusLikes: 40,
        );
      }
    }
    
    // 관계 마일스톤
    if (currentLikes == 999) {
      return SpecialMoment(
        type: 'milestone_1000',
        description: '1000 Like 달성 직전',
        bonusLikes: 100,
      );
    } else if (currentLikes == 9999) {
      return SpecialMoment(
        type: 'milestone_10000',
        description: '10000 Like 달성 직전',
        bonusLikes: 200,
      );
    }
    
    return null;
  }
}

/// 감정 교류 품질
class EmotionalExchangeQuality {
  final double score;
  final bool isMutual;
  final bool emotionMatch;
  final bool hasEmpathy;
  
  EmotionalExchangeQuality({
    required this.score,
    required this.isMutual,
    required this.emotionMatch,
    required this.hasEmpathy,
  });
}

/// 특별한 순간
class SpecialMoment {
  final String type;
  final String description;
  final int bonusLikes;
  
  SpecialMoment({
    required this.type,
    required this.description,
    required this.bonusLikes,
  });
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