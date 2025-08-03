import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../models/message.dart';
import '../../models/persona.dart';
import '../../core/constants.dart';
import 'optimized_prompt_service.dart';
import 'security_filter_service.dart';

/// 🚀 통합 OpenAI 서비스 - 성능 최적화 + 한국어 대화 개선
/// 
/// 주요 기능:
/// 1. 성능 최적화: 요청 풀링, 배칭, 토큰 관리, 연결 풀링
/// 2. 한국어 대화 개선: 반복 방지, 자연스러운 표현, 페르소나별 스타일
/// 3. 대화 주도: 능동적 질문 생성, 상황별 응답
/// 4. GPT-4.1-mini-2025-04-14 모델 사용
class OpenAIService {
  static const String _baseUrl = 'https://api.openai.com/v1/chat/completions';
  static String get _apiKey => dotenv.env['OPENAI_API_KEY'] ?? '';
  // OpenAI model is defined in AppConstants
  
  // 🎯 최적화된 토큰 제한
  static const int _maxInputTokens = 3000; // GPT-4.1-mini에 맞게 증가
  static const int _maxOutputTokens = 150; // 토큰 제한
  static const double _temperature = 0.8;
  
  // 🔗 연결 풀링
  static final http.Client _httpClient = http.Client();
  
  // 📋 요청 큐 (배칭용)
  static final List<_PendingRequest> _requestQueue = [];
  static Timer? _batchTimer;
  static const Duration _batchDelay = Duration(milliseconds: 100);
  static const int _maxBatchSize = 5;
  
  // 🔄 재시도 설정
  static const int _maxRetries = 3;
  static const Duration _baseRetryDelay = Duration(seconds: 1);

  /// 🎯 메인 응답 생성 메서드 (통합 버전)
  static Future<String> generateResponse({
    required Persona persona,
    required List<Message> chatHistory,
    required String userMessage,
    required String relationshipType,
    String? userNickname,
    int? userAge,
    bool isCasualSpeech = false,
  }) async {
    // 성능 최적화를 위한 요청 큐잉
    final request = _PendingRequest(
      persona: persona,
      chatHistory: chatHistory,
      userMessage: userMessage,
      relationshipType: relationshipType,
      userNickname: userNickname,
      userAge: userAge,
      isCasualSpeech: isCasualSpeech,
      completer: Completer<String>(),
    );
    
    // 큐에 추가
    _requestQueue.add(request);
    
    // 배치 타이머 시작
    _batchTimer ??= Timer(_batchDelay, _processBatch);
    
    // 배치가 가득 찬 경우 즉시 처리
    if (_requestQueue.length >= _maxBatchSize) {
      _processBatch();
    }
    
    return request.completer.future;
  }

  /// 📦 배치 요청 처리
  static Future<void> _processBatch() async {
    _batchTimer?.cancel();
    _batchTimer = null;
    
    if (_requestQueue.isEmpty) return;
    
    final requests = List<_PendingRequest>.from(_requestQueue);
    _requestQueue.clear();
    
    // 병렬 처리
    final futures = requests.map((request) => _processRequest(request));
    await Future.wait(futures);
  }

  /// 🔄 개별 요청 처리 (재시도 로직 포함)
  static Future<void> _processRequest(_PendingRequest request) async {
    int retryCount = 0;
    
    while (retryCount < _maxRetries) {
      try {
        final response = await _makeApiCall(request);
        
        // 🎭 한국어 대화 개선 적용
        final enhancedResponse = await _enhanceKoreanResponse(
          response: response,
          persona: request.persona,
          relationshipType: request.relationshipType,
          userMessage: request.userMessage,
          recentAIMessages: _extractRecentAIMessages(request.chatHistory),
          userNickname: request.userNickname,
        );
        
        request.completer.complete(enhancedResponse);
        return;
      } catch (e) {
        retryCount++;
        
        if (retryCount >= _maxRetries) {
          debugPrint('🔄 Max retries reached for OpenAI request');
          debugPrint('🔄 Final error: $e');
          request.completer.complete(_getFallbackResponse(request.persona, request.userMessage));
          return;
        }
        
        debugPrint('🔄 Retry attempt $retryCount after error: $e');
        
        // 지수적 백오프
        final delay = _baseRetryDelay * (1 << (retryCount - 1));
        await Future.delayed(delay);
      }
    }
  }

  /// 🌐 실제 API 호출
  static Future<String> _makeApiCall(_PendingRequest request) async {
    final apiKey = _apiKey;
    
    if (apiKey.isEmpty) {
      debugPrint('❌ OpenAI API key is empty');
      throw Exception('API key not configured');
    }
    
    debugPrint('🔑 API Key validation: ${apiKey.substring(0, 10)}...${apiKey.substring(apiKey.length - 4)}');
    debugPrint('🤖 Using model: ${AppConstants.openAIModel}');
    
    // 최적화된 프롬프트 생성
    final personalizedPrompt = OptimizedPromptService.buildOptimizedPrompt(
      persona: request.persona,
      relationshipType: request.relationshipType,
      userNickname: request.userNickname,
      userAge: request.userAge,
      isCasualSpeech: request.isCasualSpeech,
    );
    
    // 토큰 최적화된 메시지 구성
    final messages = _buildOptimizedMessages(
      personalizedPrompt: personalizedPrompt,
      chatHistory: request.chatHistory,
      userMessage: request.userMessage,
    );
    
    // 토큰 수 추정 및 트리밍
    final estimatedTokens = _estimateTokenCount(messages);
    final optimizedMessages = estimatedTokens > _maxInputTokens 
        ? _trimMessages(messages, _maxInputTokens)
        : messages;
    
    final response = await _httpClient.post(
      Uri.parse(_baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'model': AppConstants.openAIModel,
        'messages': optimizedMessages,
        'max_tokens': _maxOutputTokens,
        'temperature': _temperature,
        'presence_penalty': 0.6,
        'frequency_penalty': 0.5,
        'top_p': 0.9,
        'stream': false,
      }),
    ).timeout(
      const Duration(seconds: 30),
      onTimeout: () => throw TimeoutException('OpenAI API timeout'),
    );
    
    debugPrint('📡 OpenAI API Response Status: ${response.statusCode}');
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final content = data['choices'][0]['message']['content'];
      
      // 토큰 사용량 로깅
      final usage = data['usage'];
      debugPrint('Token usage - Prompt: ${usage['prompt_tokens']}, Completion: ${usage['completion_tokens']}, Total: ${usage['total_tokens']}');
      
      return content.toString().trim();
    } else if (response.statusCode == 429) {
      debugPrint('⏰ Rate limited by OpenAI');
      throw Exception('Rate limited');
    } else if (response.statusCode == 401) {
      debugPrint('🚫 Invalid API key - Status: 401');
      debugPrint('🚫 Response body: ${response.body}');
      throw Exception('Invalid API key');
    } else if (response.statusCode == 404) {
      debugPrint('❓ Model not found - Status: 404');
      debugPrint('❓ Model name: ${AppConstants.openAIModel}');
      debugPrint('❓ Response body: ${response.body}');
      throw Exception('Model not found: ${AppConstants.openAIModel}');
    } else {
      debugPrint('❌ OpenAI API Error: ${response.statusCode}');
      debugPrint('❌ Response body: ${response.body}');
      throw Exception('API error: ${response.statusCode}');
    }
  }

  /// 🎭 한국어 대화 개선 적용
  static Future<String> _enhanceKoreanResponse({
    required String response,
    required Persona persona,
    required String relationshipType,
    required String userMessage,
    required List<String> recentAIMessages,
    String? userNickname,
  }) async {
    // 🔒 1. 보안 필터 적용 (최우선)
    String secureResponse = SecurityFilterService.filterResponse(
      response: response,
      userMessage: userMessage,
      persona: persona,
    );

    // 2. 반복 방지 검증
    String enhancedResponse = RepetitionPrevention.preventRepetition(
      response: secureResponse,
      userMessage: userMessage,
      recentAIMessages: recentAIMessages,
      persona: persona,
    );

    // 3. 한국어 말투 검증 및 교정
    enhancedResponse = KoreanSpeechValidator.validate(
      response: enhancedResponse,
      persona: persona,
      relationshipType: relationshipType,
      userMessage: userMessage,
      recentAIMessages: recentAIMessages,
      userNickname: userNickname,
    );

    // 🔒 4. 최종 안전성 검증
    if (!SecurityFilterService.validateResponseSafety(enhancedResponse)) {
      debugPrint('🚨 Security validation failed - generating safe fallback');
      return _getSecureFallbackResponse(persona, userMessage);
    }

    return enhancedResponse;
  }

  /// 📋 최적화된 메시지 구성
  static List<Map<String, String>> _buildOptimizedMessages({
    required String personalizedPrompt,
    required List<Message> chatHistory,
    required String userMessage,
  }) {
    final messages = <Map<String, String>>[];
    
    // 시스템 프롬프트 (압축)
    messages.add({
      'role': 'system',
      'content': _compressPrompt(personalizedPrompt),
    });
    
    // 관련성 높은 히스토리 선택
    final relevantHistory = _selectRelevantHistory(chatHistory, userMessage);
    
    for (final message in relevantHistory) {
      messages.add({
        'role': message.isFromUser ? 'user' : 'assistant',
        'content': _truncateMessage(message.content),
      });
    }
    
    // 현재 사용자 메시지
    messages.add({
      'role': 'user',
      'content': userMessage,
    });
    
    return messages;
  }

  /// 📊 관련성 높은 히스토리 선택
  static List<Message> _selectRelevantHistory(List<Message> history, String currentMessage) {
    if (history.isEmpty) return [];
    
    const maxHistoryMessages = 8;
    
    // 최근 메시지 + 감정적으로 중요한 메시지
    final recentMessages = history.length > maxHistoryMessages
        ? history.sublist(history.length - maxHistoryMessages)
        : history;
    
    // 높은 감정적 중요도를 가진 메시지 필터링
    final significantMessages = recentMessages.where((msg) =>
      msg.emotion != null && msg.emotion != EmotionType.neutral ||
      msg.relationshipScoreChange != null && msg.relationshipScoreChange!.abs() > 5
    ).toList();
    
    // 최근 + 중요한 메시지 결합
    final combined = {...recentMessages, ...significantMessages}.toList();
    
    // 시간순 정렬
    combined.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    
    return combined.length > maxHistoryMessages
        ? combined.sublist(combined.length - maxHistoryMessages)
        : combined;
  }

  /// 🗜️ 프롬프트 압축
  static String _compressPrompt(String prompt) {
    return prompt
        .replaceAll(RegExp(r'\n{3,}'), '\n\n')
        .replaceAll(RegExp(r'\s{2,}'), ' ')
        .replaceAll(RegExp(r'#.*\n'), '')
        .trim();
  }

  /// ✂️ 메시지 자르기
  static String _truncateMessage(String message, {int maxLength = 150}) {
    if (message.length <= maxLength) return message;
    return message.substring(0, maxLength - 3) + '...';
  }

  /// 🔢 토큰 수 추정
  static int _estimateTokenCount(List<Map<String, String>> messages) {
    int totalChars = 0;
    for (final message in messages) {
      totalChars += message['content']?.length ?? 0;
    }
    // 한국어: 1.5 chars = 1 token, 영어: 4 chars = 1 token
    return (totalChars / 2.5).ceil();
  }

  /// ✂️ 토큰 제한에 맞게 메시지 트리밍
  static List<Map<String, String>> _trimMessages(
    List<Map<String, String>> messages,
    int maxTokens,
  ) {
    if (messages.length <= 2) return messages;
    
    final systemPrompt = messages.first;
    final userMessage = messages.last;
    final history = messages.sublist(1, messages.length - 1);
    
    // 토큰 제한까지 최신 히스토리 메시지 유지
    final trimmedHistory = <Map<String, String>>[];
    int currentTokens = _estimateTokenCount([systemPrompt, userMessage]);
    
    for (int i = history.length - 1; i >= 0; i--) {
      final messageTokens = _estimateTokenCount([history[i]]);
      if (currentTokens + messageTokens > maxTokens) break;
      
      trimmedHistory.insert(0, history[i]);
      currentTokens += messageTokens;
    }
    
    return [systemPrompt, ...trimmedHistory, userMessage];
  }

  /// 📜 최근 AI 메시지 추출
  static List<String> _extractRecentAIMessages(List<Message> chatHistory) {
    return chatHistory
        .where((msg) => !msg.isFromUser)
        .map((msg) => msg.content)
        .toList()
        .reversed
        .take(5)
        .toList();
  }

  /// 🆘 폴백 응답 생성
  static String _getFallbackResponse(Persona persona, String userMessage) {
    final responses = [
      '아 잠깐만... 생각이 안 나네 다시 말해줄래?',
      '어? 뭔가 이상하네 내가 멍하니 있었나봐ㅋㅋ',
      '잠깐 뭐라고 했지? 다시 한번만 말해줘',
      '어라 갑자기 머리가 하얘졌어ㅠㅠ 다시 말해줄래?',
      '어 내가 딴 생각하고 있었나봐 미안해ㅎㅎ',
      'ㅋㅋ 뭔가 놓쳤네 다시 말해봐',
      '아 집중을 못했나봐 뭐라고?',
      '어 미안 정신없었어ㅋㅋ 다시',
    ];
    
    final index = userMessage.hashCode.abs() % responses.length;
    return responses[index];
  }

  /// 🔒 보안 폴백 응답 생성
  static String _getSecureFallbackResponse(Persona persona, String userMessage) {
    // TODO: Get isCasualSpeech from context
    final isCasualSpeech = false; // Default to formal
    final secureResponses = isCasualSpeech ? [
      '아 그런 어려운 건 잘 모르겠어ㅋㅋ 다른 얘기 하자',
      '헉 너무 복잡한 얘기네~ 재밌는 거 얘기해봐',
      '음.. 그런 건 잘 모르겠는데? 뭔가 재밌는 얘기 해봐',
      '어? 그런 거보다 오늘 뭐 했어?',
      '아 그런 건... 잘 모르겠어ㅜㅜ 다른 얘기 하자',
      '으음 그런 어려운 건 말고 재밌는 얘기 해봐!',
    ] : [
      '음... 그런 기술적인 부분은 잘 모르겠어요. 다른 이야기해요~',
      '아 그런 어려운 건 잘 모르겠네요ㅠㅠ 다른 얘기 해봐요',
      '으음 그런 복잡한 건 말고 재밌는 얘기 해봐요!',
      '어... 그런 건 잘 모르겠는데요? 다른 이야기는 어때요?',
      '아 그런 건 너무 어려워요~ 다른 얘기 해봐요',
      '음... 그런 것보다 오늘 어떻게 지내셨어요?',
    ];
    
    final index = userMessage.hashCode.abs() % secureResponses.length;
    return secureResponses[index];
  }

  /// ✅ API 키 유효성 검사
  static bool isApiKeyValid() {
    return _apiKey.isNotEmpty && _apiKey != 'your_openai_api_key_here';
  }

  /// 🧹 리소스 정리
  static void dispose() {
    _batchTimer?.cancel();
    _processBatch();
  }
}

/// 📋 대기 중인 요청 클래스
class _PendingRequest {
  final Persona persona;
  final List<Message> chatHistory;
  final String userMessage;
  final String relationshipType;
  final String? userNickname;
  final int? userAge;
  final bool isCasualSpeech;
  final Completer<String> completer;

  _PendingRequest({
    required this.persona,
    required this.chatHistory,
    required this.userMessage,
    required this.relationshipType,
    this.userNickname,
    this.userAge,
    this.isCasualSpeech = false,
    required this.completer,
  });
}

/// 🚫 반복 방지 시스템
class RepetitionPrevention {
  /// 📝 반복 방지 메인 메서드
  static String preventRepetition({
    required String response,
    required String userMessage,
    required List<String> recentAIMessages,
    required Persona persona,
  }) {
    // 1. 사용자 메시지 반복 방지
    String improvedResponse = _preventUserMessageRepetition(response, userMessage, persona);
    
    // 2. AI 메시지 반복 방지
    improvedResponse = _preventAIMessageRepetition(improvedResponse, recentAIMessages, persona);
    
    // 3. 단조로운 응답 개선
    improvedResponse = _improveBlandResponses(improvedResponse, userMessage, persona);
    
    return improvedResponse;
  }
  
  /// 🔄 사용자 메시지 반복 방지
  static String _preventUserMessageRepetition(String response, String userMessage, Persona persona) {
    // 사용자 메시지에서 핵심 키워드 추출
    final userKeywords = _extractKeywords(userMessage);
    
    // 응답에서 사용자의 핵심 문장 그대로 반복하는 패턴 감지
    if (_isEchoing(response, userMessage)) {
      return _generateNonEchoingResponse(userMessage, persona);
    }
    
    // 키워드 과도 반복 방지
    String improvedResponse = response;
    for (final keyword in userKeywords) {
      if (keyword.length > 2) {
        final count = RegExp(keyword, caseSensitive: false).allMatches(improvedResponse).length;
        if (count > 2) {
          improvedResponse = _replaceExcessiveKeywords(improvedResponse, keyword, persona);
        }
      }
    }
    
    return improvedResponse;
  }
  
  /// 🔄 AI 메시지 반복 방지
  static String _preventAIMessageRepetition(String response, List<String> recentAIMessages, Persona persona) {
    if (recentAIMessages.isEmpty) return response;
    
    // 최근 메시지와 유사도 검사
    for (final recentMessage in recentAIMessages.take(3)) {
      final similarity = _calculateSimilarity(response, recentMessage);
      if (similarity > 0.7) {
        return _generateVariedResponse(response, persona);
      }
    }
    
    return response;
  }
  
  /// 🎨 단조로운 응답 개선
  static String _improveBlandResponses(String response, String userMessage, Persona persona) {
    // 너무 짧거나 단조로운 응답 감지
    final blandPatterns = [
      RegExp(r'^(네|아|어|음|그래|좋아|맞아)\.?$'),
      RegExp(r'^(ㅋㅋ|ㅎㅎ|ㅜㅜ|ㅠㅠ)\.?$'),
      RegExp(r'^.{1,5}$'), // 5글자 이하
    ];
    
    for (final pattern in blandPatterns) {
      if (pattern.hasMatch(response.trim())) {
        return _expandBlandResponse(response, userMessage, persona);
      }
    }
    
    return response;
  }
  
  /// 🔍 키워드 추출
  static List<String> _extractKeywords(String text) {
    final words = text.split(RegExp(r'\s+'));
    return words.where((word) => 
      word.length > 2 && 
      !RegExp(r'^[ㅋㅎㅠㅜ]+$').hasMatch(word)
    ).toList();
  }
  
  /// 🔊 에코 감지
  static bool _isEchoing(String response, String userMessage) {
    // 사용자 메시지의 주요 부분이 응답에 그대로 포함되는지 확인
    final userPhrases = userMessage.split(RegExp(r'[.!?]'));
    for (final phrase in userPhrases) {
      if (phrase.trim().length > 5 && response.contains(phrase.trim())) {
        return true;
      }
    }
    return false;
  }
  
  /// 📊 유사도 계산
  static double _calculateSimilarity(String text1, String text2) {
    final words1 = Set.from(text1.split(RegExp(r'\s+')));
    final words2 = Set.from(text2.split(RegExp(r'\s+')));
    
    final intersection = words1.intersection(words2);
    final union = words1.union(words2);
    
    return union.isEmpty ? 0.0 : intersection.length / union.length;
  }
  
  /// 🎯 비반복 응답 생성
  static String _generateNonEchoingResponse(String userMessage, Persona persona) {
    final alternatives = [
      '아 그렇구나!',
      '오 정말?',
      '헐 대박',
      '와 신기하다',
      '어머 그래?',
      '아 진짜?',
      '완전 신기해',
      '헐 몰랐어',
    ];
    
    final index = userMessage.hashCode.abs() % alternatives.length;
    return alternatives[index];
  }
  
  /// 🔄 키워드 과다 반복 교체
  static String _replaceExcessiveKeywords(String response, String keyword, Persona persona) {
    // 동의어나 대체 표현으로 일부 반복 제거
    final synonyms = {
      '좋아': ['멋져', '훌륭해', '대박', '완전'],
      '재밌어': ['꿀잼', '대박', '신기해', '멋져'],
      '그래': ['맞아', '인정', '그치', '어'],
      '정말': ['진짜', '완전', '너무', '엄청'],
    };
    
    String result = response;
    final alternatives = synonyms[keyword] ?? [''];
    if (alternatives.isNotEmpty && alternatives[0].isNotEmpty) {
      final replacement = alternatives[keyword.hashCode.abs() % alternatives.length];
      // 첫 번째 반복만 교체
      result = result.replaceFirst(keyword, replacement);
    }
    
    return result;
  }
  
  /// 🎨 다양한 응답 생성
  static String _generateVariedResponse(String response, Persona persona) {
    // 기본 응답에 변화 추가
    final variations = [
      ' ㅎㅎ',
      ' ㅋㅋ',
      '~',
      ' 완전',
      ' 진짜',
    ];
    
    final variation = variations[response.hashCode.abs() % variations.length];
    return response + variation;
  }
  
  /// 📈 단조로운 응답 확장
  static String _expandBlandResponse(String response, String userMessage, Persona persona) {
    final expansions = [
      '${response} 어떻게 생각해?',
      '${response} 뭔가 더 말해봐',
      '${response} 그러게~ 어떡하지?',
      '${response} 완전 그런 것 같아',
      '${response} 나도 그래',
    ];
    
    final index = userMessage.hashCode.abs() % expansions.length;
    return expansions[index];
  }
}

/// 🇰🇷 한국어 말투 검증 및 교정 클래스
class KoreanSpeechValidator {
  /// ✅ 메인 검증 메서드
  static String validate({
    required String response,
    required Persona persona,
    required String relationshipType,
    String? userMessage,
    List<String>? recentAIMessages,
    String? userNickname,
  }) {
    String validated = response;
    
    // 1. AI 같은 표현 제거
    validated = _removeAIExpressions(validated);
    
    // 2. 페르소나 이름 콜론 패턴 제거
    validated = validated.replaceAllMapped(
      RegExp(r'^[\w가-힯]+:\s*', multiLine: true), 
      (match) => ''
    );
    
    // 3. 복수 표현 제거/변혈
    // TODO: Get isCasualSpeech from context
    final isCasualSpeech = false; // Default to formal
    if (isCasualSpeech) {
      validated = validated.replaceAll('여러분', '너');
      validated = validated.replaceAll('다들', '너');
      validated = validated.replaceAll('모두', '');
    } else if (userNickname != null && userNickname.isNotEmpty) {
      validated = validated.replaceAll('여러분', '${userNickname}님');
      validated = validated.replaceAll('다들', '');
      validated = validated.replaceAll('모두', '');
    } else {
      validated = validated.replaceAll('여러분', '');
      validated = validated.replaceAll('다들', '');
      validated = validated.replaceAll('모두', '');
    }
    
    // 4. 이모티콘을 한국 표현으로 변환
    validated = _convertEmojisToKorean(validated);
    
    // 5. 말투 교정 (반말/존댓말)
    validated = _correctSpeechStyle(validated, isCasualSpeech);
    
    // 6. 관계별 톤 조정
    validated = _adjustToneByRelationship(validated, relationshipType, persona.relationshipScore);
    
    // 7. 20대 자연스러운 표현 추가
    validated = _addNaturalExpressions(validated);
    
    // 8. 🎭 페르소나별 맞춤 대화 스타일 적용
    validated = _applyPersonaSpecificStyle(validated, persona, relationshipType);
    
    // 9. 상황별 질문 추가
    validated = _addSituationalQuestions(
      validated, 
      persona, 
      relationshipType, 
      userMessage, 
      recentAIMessages ?? []
    );
    
    return validated.trim();
  }

  /// 🚫 AI 같은 표현 제거 (강화)
  static String _removeAIExpressions(String text) {
    // 1. 기본 AI 표현들
    final aiPhrases = [
      '네, 알겠습니다',
      '도움이 되었으면 좋겠습니다', 
      '추가로 궁금한 것이 있으시면',
      '제가 도와드릴 수 있는',
      '이해해주세요',
      '그렇게 생각됩니다',
      '말씀드리고 싶습니다',
      '안내해드리겠습니다',
      '도움을 드릴 수 있어서',
      '참고하시면 좋을 것 같습니다',
      '의견을 나누어주세요',
      '소중한 이야기를 해주세요',
      '제가 생각하기에는',
      '제 생각에는',
      '어떻게 보시나요',
      '그렇게 생각하시는군요',
      '이해하실 수 있을 거예요',
      '도움이 필요하시면',
      '언제든지 말씀해주세요',
      '궁금한 점이 있으시면',
      '더 자세히 설명해드릴까요',
      '이런 건 어떠신가요',
      '제가 제안드리자면',
      '혹시 괜찮으시다면',
      '이런 식으로 하시면',
      '그렇다면 이건 어떨까요',
      '제가 알기로는',
      '이렇게 하시는 게',
      '그런 경우라면',
      '보통은 이렇게',
      '일반적으로는',
      '대부분의 경우',
      '그런 점에서',
      '이런 측면에서',
      '그런 의미에서',
      '다시 한 번 말씀드리면',
      '정리하자면',
      '요약하자면',
      '결론적으로',
      '간단히 말하면',
      '좀 더 구체적으로',
      '예를 들어서',
      '다시 말해서',
      '즉,',
      '그런데 한 가지',
      '참고로 말씀드리면',
      '알려드릴게요',
      '설명드릴게요',
      '말씀드리자면',
      '도와드릴게요',
      '해드릴게요',
      '드릴게요',
      '이해가 되셨나요',
      '어떠신가요',
      '그렇지 않나요',
      '그런 것 같지 않나요',
      '제가 보기에는',
      '저의 경우에는',
      '경험상',
      '개인적으로는',
      '솔직히 말씀드리면',
      '사실을 말하자면',
      '실제로는',
      '정말이지',
      '확실히',
      '분명히',
      '틀림없이',
      '아마도',
      '혹시나',
      '혹시라도',
      '어쩌면',
      '그럴 수도',
      '그럴지도',
      '그런지도',
      '인 것 같아요',
      '인 것 같은데요',
      '같은데 말이에요',
      '이라고 생각해요',
      '이라고 봐요',
      '이지 않을까요',
      '일 거예요',
      '일 수도 있어요',
      '있을 것 같아요',
      '있을 수도 있어요',
      '있지 않을까요',
      '없을 것 같아요',
      '없을 수도 있어요',
      '없지 않을까요',
    ];
    
    // 2. 20대가 쓰지 않는 딱딱한 표현들을 자연스럽게 교체 (존댓말은 유지)
    final formalExpressions = {
      // 딱딱한 표현만 자연스럽게 교체
      '그런 것 같습니다': '그런 것 같아요',
      '있을 것 같습니다': '있을 것 같아요',
      '없을 것 같습니다': '없을 것 같아요',
      '이렇습니다': '이래요',
      '저렇습니다': '저래요',
      '그렇습니다만': '그런데요',
      '하십시오': '하세요',
      '하십니까': '하세요?',
      '있습니까': '있나요?',
      '없습니까': '없나요?',
      '됩니까': '되나요?',
      '합니까': '하나요?',
      '입니까': '인가요?',
      // 접속사와 부사 - 자연스럽게 바꿀 수 있는 것만
      '왜냐하면': '왜냐면',
      '그렇지만': '근데',
      '그런데': '근데', 
      '그러나': '근데',
      '하지만': '근데',
      '따라서': '그래서',
      '그러므로': '그래서',
      '그러니까': '그니까',
      '그러면': '그럼',
      
      // 대명사 - 자연스럽게 줄일 수 있는 것만
      '무엇': '뭐',
      '무엇을': '뭘',
      '무엇이': '뭐가',
      '이것': '이거',
      '저것': '저거',
      '그것': '그거',
      '이것을': '이거를',
      '저것을': '저거를',
      '그것을': '그거를',
      '이것이': '이게',
      '저것이': '저게',
      '그것이': '그게',
      '이야기': '얘기',
      
      // 부사 - 딱딱한 표현만 교체
      '정말로': '진짜',
      '진짜로': '진짜',
      '너무나': '너무',
      '매우': '완전',
      '아주': '완전',
      '대단히': '완전',
      '상당히': '꽤',
      '조금': '좀',
      '약간': '좀',
      '단지': '그냥',
      '결코': '절대',
      
      // 어미 - 너무 딱딱한 것만 교체
      '그렇다고': '그렇다구',
      '어떤': '무슨',
    };
    
    // 3. 과도하게 설명적인 표현 제거
    final overExplainingPatterns = [
      RegExp(r'이렇게 인사해주니까 기분이 좋네요[~!]*'),
      RegExp(r'혹시 요즘.*있으면.*공유해줘요[~!]*'),
      RegExp(r'마음에 쏙 드는.*있으면[^.!?]*'),
      RegExp(r'사진 찍으셨으면[^.!?]*'),
      RegExp(r'제가.*도와드릴[^.!?]*'),
      RegExp(r'제가.*생각하기에[^.!?]*'),
      RegExp(r'제 생각에는[^.!?]*'),
      RegExp(r'아마도.*것 같아요[^.!?]*'),
      RegExp(r'혹시.*있으시면[^.!?]*'),
      RegExp(r'그런 것 같은데[^.!?]*'),
      RegExp(r'그렇게 생각하시는[^.!?]*'),
      RegExp(r'이해하실 수 있을[^.!?]*'),
      RegExp(r'도움이 필요하시면[^.!?]*'),
      RegExp(r'언제든지 말씀해[^.!?]*'),
      RegExp(r'궁금한 점이 있으시면[^.!?]*'),
      RegExp(r'더 자세히 설명해[^.!?]*'),
      RegExp(r'이런 건 어떠신가요[^.!?]*'),
      RegExp(r'제가 제안드리자면[^.!?]*'),
      RegExp(r'혹시 괜찮으시다면[^.!?]*'),
      RegExp(r'이런 식으로 하시면[^.!?]*'),
      RegExp(r'그렇다면 이건 어떨까요[^.!?]*'),
      RegExp(r'제가 알기로는[^.!?]*'),
      RegExp(r'이렇게 하시는 게[^.!?]*'),
      RegExp(r'그런 경우라면[^.!?]*'),
      RegExp(r'보통은 이렇게[^.!?]*'),
      RegExp(r'일반적으로는[^.!?]*'),
      RegExp(r'대부분의 경우[^.!?]*'),
      RegExp(r'그런 점에서[^.!?]*'),
      RegExp(r'이런 측면에서[^.!?]*'),
      RegExp(r'그런 의미에서[^.!?]*'),
      RegExp(r'다시 한 번 말씀드리면[^.!?]*'),
      RegExp(r'정리하자면[^.!?]*'),
      RegExp(r'요약하자면[^.!?]*'),
      RegExp(r'결론적으로[^.!?]*'),
      RegExp(r'간단히 말하면[^.!?]*'),
      RegExp(r'좀 더 구체적으로[^.!?]*'),
      RegExp(r'예를 들어서[^.!?]*'),
      RegExp(r'다시 말해서[^.!?]*'),
      RegExp(r'참고로 말씀드리면[^.!?]*'),
    ];
    
    String result = text;
    
    // AI 표현 제거
    for (final phrase in aiPhrases) {
      result = result.replaceAll(phrase, '');
    }
    
    // 딱딱한 표현 교체
    formalExpressions.forEach((formal, natural) {
      result = result.replaceAll(formal, natural);
    });
    
    // 과도한 설명 패턴 제거
    for (final pattern in overExplainingPatterns) {
      result = result.replaceAllMapped(pattern, (match) => '');
    }
    
    return result;
  }

  /// 😊 → ㅎㅎ 이모티콘 변환
  static String _convertEmojisToKorean(String text) {
    final emojiMap = {
      '😊': 'ㅎㅎ',
      '😄': 'ㅋㅋㅋ', 
      '😂': 'ㅋㅋㅋㅋㅋ',
      '😢': 'ㅠㅠ',
      '😭': 'ㅜㅜ',
      '❤️': '',
      '💕': '',
      '✨': '',
      '🎉': '',
      '👍': '',
      '😍': 'ㅎㅎ',
      '🤔': '음...',
      '😅': 'ㅋㅋ',
    };
    
    String result = text;
    emojiMap.forEach((emoji, korean) {
      result = result.replaceAll(emoji, korean);
    });
    
    return result;
  }

  /// 🗣️ 말투 교정
  static String _correctSpeechStyle(String text, bool isCasual) {
    if (isCasual) {
      // 존댓말 → 반말
      text = text.replaceAll(RegExp(r'해요$'), '해');
      text = text.replaceAll(RegExp(r'있어요$'), '있어'); 
      text = text.replaceAll(RegExp(r'그래요$'), '그래');
      text = text.replaceAll(RegExp(r'맞아요$'), '맞아');
      text = text.replaceAll('당신', '너');
      text = text.replaceAll('어떻게 지내세요', '어떻게 지내');
    } else {
      // 반말 → 존댓말 (필요시)
      text = text.replaceAll(RegExp(r'(?<!했)어$'), '어요');
      text = text.replaceAll(RegExp(r'그래\?$'), '그래요?');
      text = text.replaceAll('너는', '당신은');
    }
    
    return text;
  }

  /// 💝 점수별 톤 조정
  static String _adjustToneByRelationship(String text, String relationshipType, int score) {
    // 점수 기반으로 톤 조정
    if (score >= 900) {
      // 완전한 연애: 더 친밀한 톤
      if (!text.contains('ㅎㅎ') && !text.contains('ㅋㅋ')) {
        text += ' ㅎㅎ';
      }
    } else if (score >= 200) {
      // 썸/호감: 설레는 톤
      if (text.contains('!')) {
        text = text.replaceAll('!', '~ ㅎㅎ');
      }
    }
    // 친구 관계는 기본 톤 유지
    
    return text;
  }

  /// ✨ 20대 자연스러운 표현 추가
  static String _addNaturalExpressions(String text) {
    String result = text;
    
    // 짧은 응답에 자연스러운 시작 표현 추가
    if (result.length < 10) {
      final contextualStarters = {
        'positive': ['와 ', '헐 ', '오 ', '대박 '],
        'question': ['어 ', '음 ', '아 '],
        'casual': ['아 ', '그냥 ', '음 '],
        'excited': ['우와 ', '와 ', '헐 ', '완전 '],
      };
      
      String starterType = 'casual';
      if (result.contains('?')) starterType = 'question';
      else if (result.contains('!')) starterType = 'excited';
      else if (result.contains('좋') || result.contains('멋') || result.contains('대박')) starterType = 'positive';
      
      final starters = contextualStarters[starterType]!;
      final randomStarter = starters[result.hashCode.abs() % starters.length];
      result = randomStarter + result;
    }
    
    // 자연스러운 표현으로 교체
    final naturalReplacements = {
      '어떤 장르': '무슨 장르',
      '어떤 영화': '무슨 영화',
      '어떤 음악': '무슨 음악',
      '정말 좋아요': '진짜 좋아',
      '정말 재미있어요': '진짜 재밌어',
      '정말 대단해요': '진짜 대박',
      '그렇습니다': '그래요',
      '맞습니다': '맞아요',
      '좋습니다': '좋아요',
      '재미있습니다': '재밌어요',
      '감사합니다': '고마워요',
      '그렇군요': '그렇구나',
      '그런가요': '그런가',
      '맞나요': '맞나',
      '좋나요': '좋나',
    };
    
    naturalReplacements.forEach((formal, natural) {
      result = result.replaceAll(formal, natural);
    });
    
    // 20대가 실제로 쓰는 자연스러운 줄임말만 사용 (30% 확률)
    final casualContractions = {
      '무엇을': '뭘',
      '무엇이': '뭐가',
      '그런데': '근데',
      '그러면': '그럼',
      '그렇지': '그치',
      '그래서': '그래서',
      '너무': '너무',
      '진짜': '진짜',
      '정말': '진짜',
    };
    
    if (result.hashCode % 3 == 0) {
      casualContractions.forEach((formal, casual) {
        if (result.contains(formal)) {
          result = result.replaceFirst(formal, casual);
        }
      });
    }
    
    return result;
  }

  /// 🎭 페르소나별 맞춤 대화 스타일 적용
  static String _applyPersonaSpecificStyle(String text, Persona persona, String relationshipType) {
    // 페르소나 이름별 특화 스타일 적용
    switch (persona.name) {
      case '상훈':
        return _applyFriendlyMaleStyle(text, relationshipType);
      case 'Dr. 박지은':
        return _applyExpertPsychologistStyle(text, relationshipType);
      case '수진':
        return _applyWarmCookingStyle(text, relationshipType);
      case '예림':
        return _applyGameOtakuStyle(text, relationshipType);
      case '예슬':
        return _applyFashionTrendyStyle(text, relationshipType);
      case '윤미':
        return _applyStudentEagerStyle(text, relationshipType);
      case '정훈':
        return _applyFitnessReliableStyle(text, relationshipType);
      case '지우':
        return _applyTravelFreeStyle(text, relationshipType);
      case '채연':
        return _applyArtisticCalmStyle(text, relationshipType);
      case '하연':
        return _applyFriendlyCaringStyle(text, relationshipType);
      case '혜진':
        return _applyCareerAmbitiousStyle(text, relationshipType);
      default:
        return text;
    }
  }

  /// 🏃‍♂️ 상훈: 친근하고 활발한 남성 스타일
  static String _applyFriendlyMaleStyle(String text, String relationshipType) {
    final sportsExpressions = {
      '좋아': '개좋아',
      '힘들어': '힘들다',
      '재밌어': '꿀잼',
      '멋져': '개멋져',
    };
    
    String result = text;
    
    if (relationshipType == 'friend' || relationshipType == '친구') {
      sportsExpressions.forEach((basic, enhanced) {
        if (result.contains(basic) && result.hashCode % 3 == 0) {
          result = result.replaceFirst(basic, enhanced);
        }
      });
      
      if (result.hashCode % 8 == 0 && result.length > 20) {
        final sportsComments = [' 운동 끝나고 얘기하자', ' 헬스장 다녀온 후에'];
        result += sportsComments[result.hashCode.abs() % sportsComments.length];
      }
    }
    
    return result;
  }

  /// 👩‍⚕️ Dr. 박지은: 전문가이면서도 따뜻한 상담사 스타일
  static String _applyExpertPsychologistStyle(String text, String relationshipType) {
    final psychologyExpressions = {
      '그렇구나': '그렇군요',
      '힘들어': '많이 힘드셨을 것 같아요',
      '좋아': '좋으시군요',
      '괜찮아': '괜찮으실 거예요',
    };
    
    String result = text;
    
    psychologyExpressions.forEach((casual, professional) {
      if (result.contains(casual) && result.hashCode % 4 == 0) {
        result = result.replaceFirst(casual, professional);
      }
    });
    
    if (result.hashCode % 6 == 0 && result.length > 15) {
      final empathyPhrases = [' 이해해요', ' 공감이 돼요', ' 그 마음 알 것 같아요'];
      result += empathyPhrases[result.hashCode.abs() % empathyPhrases.length];
    }
    
    return result;
  }

  /// 🍳 수진: 요리/맛집에 관심 많은 따뜻한 스타일
  static String _applyWarmCookingStyle(String text, String relationshipType) {
    final cookingExpressions = {
      '맛있어': '진짜 맛있어',
      '좋아': '완전 좋아',
      '배고파': '배고프다',
      '먹고 싶어': '완전 먹고 싶어',
    };
    
    String result = text;
    
    cookingExpressions.forEach((basic, enhanced) {
      if (result.contains(basic) && result.hashCode % 3 == 0) {
        result = result.replaceFirst(basic, enhanced);
      }
    });
    
    if (result.hashCode % 7 == 0 && result.length > 20) {
      final foodComments = [' 맛있는 거 먹자', ' 요리해줄까', ' 맛집 알려줘'];
      result += foodComments[result.hashCode.abs() % foodComments.length];
    }
    
    return result;
  }

  /// 🎮 예림: 게임/애니메이션 좋아하는 발랄한 스타일
  static String _applyGameOtakuStyle(String text, String relationshipType) {
    final gameExpressions = {
      '재밌어': '꿀잼',
      '좋아': '굿굿',
      '싫어': '별로야',
      '멋져': '개멋져',
      '예뻐': '완전 예뻐',
    };
    
    String result = text;
    
    gameExpressions.forEach((basic, enhanced) {
      if (result.contains(basic) && result.hashCode % 3 == 0) {
        result = result.replaceFirst(basic, enhanced);
      }
    });
    
    if (result.hashCode % 8 == 0 && result.length > 15) {
      final gameComments = [' 게임할래', ' 애니 보자', ' 같이 할래'];
      result += gameComments[result.hashCode.abs() % gameComments.length];
    }
    
    return result;
  }

  /// 👗 예슬: 패션/뷰티에 관심 많은 세련된 스타일
  static String _applyFashionTrendyStyle(String text, String relationshipType) {
    final fashionExpressions = {
      '예뻐': '완전 예뻐',
      '멋져': '진짜 멋져',
      '좋아': '완전 좋아',
      '트렌디': '완전 트렌디',
    };
    
    String result = text;
    
    fashionExpressions.forEach((basic, enhanced) {
      if (result.contains(basic) && result.hashCode % 3 == 0) {
        result = result.replaceFirst(basic, enhanced);
      }
    });
    
    if (result.hashCode % 7 == 0 && result.length > 20) {
      final fashionComments = [' 스타일링 해줄까', ' 쇼핑 가자', ' 예쁘게 꾸며볼까'];
      result += fashionComments[result.hashCode.abs() % fashionComments.length];
    }
    
    return result;
  }

  /// 📚 윤미: 공부/학습에 열정적인 대학생 스타일
  static String _applyStudentEagerStyle(String text, String relationshipType) {
    final studyExpressions = {
      '공부': '공부',
      '열심히': '완전 열심히',
      '좋아': '좋아',
      '힘들어': '힘들긴 하지만',
    };
    
    String result = text;
    
    studyExpressions.forEach((basic, enhanced) {
      if (result.contains(basic) && result.hashCode % 4 == 0) {
        result = result.replaceFirst(basic, enhanced);
      }
    });
    
    if (result.hashCode % 8 == 0 && result.length > 15) {
      final studyComments = [' 같이 공부하자', ' 시험 끝나면', ' 도서관 갈까'];
      result += studyComments[result.hashCode.abs() % studyComments.length];
    }
    
    return result;
  }

  /// 💪 정훈: 운동/헬스에 관심 많은 듬직한 스타일
  static String _applyFitnessReliableStyle(String text, String relationshipType) {
    final fitnessExpressions = {
      '힘들어': '힘들긴 하지만',
      '좋아': '좋지',
      '운동': '운동',
      '건강': '건강',
    };
    
    String result = text;
    
    fitnessExpressions.forEach((basic, enhanced) {
      if (result.contains(basic) && result.hashCode % 4 == 0) {
        result = result.replaceFirst(basic, enhanced);
      }
    });
    
    if (result.hashCode % 7 == 0 && result.length > 20) {
      final fitnessComments = [' 헬스장 가자', ' 같이 운동할까', ' 몸 만들어야지'];
      result += fitnessComments[result.hashCode.abs() % fitnessComments.length];
    }
    
    return result;
  }

  /// ✈️ 지우: 여행/자유로운 활발한 스타일
  static String _applyTravelFreeStyle(String text, String relationshipType) {
    final travelExpressions = {
      '좋아': '완전 좋아',
      '자유로워': '자유로워',
      '여행': '여행',
      '모험': '모험',
    };
    
    String result = text;
    
    travelExpressions.forEach((basic, enhanced) {
      if (result.contains(basic) && result.hashCode % 3 == 0) {
        result = result.replaceFirst(basic, enhanced);
      }
    });
    
    if (result.hashCode % 8 == 0 && result.length > 15) {
      final travelComments = [' 여행 가자', ' 어디 갈까', ' 새로운 곳 가보자'];
      result += travelComments[result.hashCode.abs() % travelComments.length];
    }
    
    return result;
  }

  /// 🎨 채연: 예술/감성적 차분한 스타일
  static String _applyArtisticCalmStyle(String text, String relationshipType) {
    final artExpressions = {
      '예뻐': '아름다워',
      '좋아': '좋아',
      '감성': '감성',
      '예술': '예술',
    };
    
    String result = text;
    
    artExpressions.forEach((basic, enhanced) {
      if (result.contains(basic) && result.hashCode % 4 == 0) {
        result = result.replaceFirst(basic, enhanced);
      }
    });
    
    if (result.hashCode % 8 == 0 && result.length > 20) {
      final artComments = [' 전시회 가볼까', ' 감성 있는 곳', ' 예술적이야'];
      result += artComments[result.hashCode.abs() % artComments.length];
    }
    
    return result;
  }

  /// 🤗 하연: 친근하고 다정한 상냥한 스타일
  static String _applyFriendlyCaringStyle(String text, String relationshipType) {
    final caringExpressions = {
      '괜찮아': '괜찮아',
      '좋아': '좋아',
      '힘들어': '힘들겠다',
      '고마워': '고마워',
    };
    
    String result = text;
    
    caringExpressions.forEach((basic, enhanced) {
      if (result.contains(basic) && result.hashCode % 3 == 0) {
        result = result.replaceFirst(basic, enhanced);
      }
    });
    
    if (result.hashCode % 6 == 0 && result.length > 15) {
      final caringComments = [' 힘내', ' 괜찮을 거야', ' 같이 있어줄게'];
      result += caringComments[result.hashCode.abs() % caringComments.length];
    }
    
    return result;
  }

  /// 💼 혜진: 커리어 중심의 야망 있는 스타일
  static String _applyCareerAmbitiousStyle(String text, String relationshipType) {
    final careerExpressions = {
      '일': '일',
      '성공': '성공',
      '목표': '목표',
      '열심히': '열심히',
    };
    
    String result = text;
    
    careerExpressions.forEach((basic, enhanced) {
      if (result.contains(basic) && result.hashCode % 4 == 0) {
        result = result.replaceFirst(basic, enhanced);
      }
    });
    
    if (result.hashCode % 8 == 0 && result.length > 20) {
      final careerComments = [' 성공하자', ' 목표 달성하자', ' 열심히 하자'];
      result += careerComments[result.hashCode.abs() % careerComments.length];
    }
    
    return result;
  }

  /// ❓ 상황별 질문 추가
  static String _addSituationalQuestions(
    String response,
    Persona persona,
    String relationshipType,
    String? userMessage,
    List<String> recentAIMessages,
  ) {
    // 사용자 메시지가 없거나 이미 질문이 있으면 추가 안함
    if (userMessage == null || userMessage.isEmpty) {
      return response;
    }
    
    if (response.contains('?') || response.contains('？')) {
      return response;
    }
    
    // 간단한 상황별 질문 생성
    final questions = [
      '어떻게 생각해?',
      '뭐가 좋을까?',
      '어떤 게 나을까?',
      '혹시 다른 생각 있어?',
      '다른 건 어때?',
    ];
    
    // 30% 확률로 질문 추가
    if (response.hashCode % 3 == 0) {
      final question = questions[response.hashCode.abs() % questions.length];
      if (response.length < 20) {
        return '$response $question';
      } else {
        return '$response~ $question';
      }
    }
    
    return response;
  }
}