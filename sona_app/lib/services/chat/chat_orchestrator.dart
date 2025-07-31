import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../models/persona.dart';
import '../../models/message.dart';
import '../../core/constants.dart';
import 'persona_relationship_cache.dart';
import 'persona_prompt_builder.dart';
import 'security_aware_post_processor.dart';
import 'conversation_memory_service.dart';
import 'openai_service.dart';

/// 채팅 플로우를 조정하는 중앙 오케스트레이터
/// 전체 메시지 생성 파이프라인을 관리
class ChatOrchestrator {
  static ChatOrchestrator? _instance;
  static ChatOrchestrator get instance => _instance ??= ChatOrchestrator._();
  
  ChatOrchestrator._();
  
  // 서비스 참조
  final PersonaRelationshipCache _relationshipCache = PersonaRelationshipCache.instance;
  final ConversationMemoryService _memoryService = ConversationMemoryService();
  
  // API 설정
  static String get _apiKey => dotenv.env['OPENAI_API_KEY'] ?? '';
  static const String _baseUrl = 'https://api.openai.com/v1/chat/completions';
  static const String _model = 'gpt-4o-mini-2025-04-14';
  
  // HTTP 클라이언트
  final http.Client _httpClient = http.Client();
  
  /// 메시지 생성 메인 메서드
  Future<ChatResponse> generateResponse({
    required String userId,
    required Persona basePersona,
    required String userMessage,
    required List<Message> chatHistory,
    String? userNickname,
  }) async {
    try {
      // 1단계: 완전한 페르소나 정보 로드
      final completePersona = await _relationshipCache.getCompletePersona(
        userId: userId,
        basePersona: basePersona,
      );
      
      debugPrint('✅ Loaded complete persona: ${completePersona.name} (casual: ${completePersona.isCasualSpeech})');
      
      // 2단계: 대화 메모리 구축
      final contextMemory = await _buildContextMemory(
        userId: userId,
        personaId: completePersona.id,
        recentMessages: chatHistory,
        persona: completePersona,
      );
      
      // 3단계: 프롬프트 생성
      final prompt = PersonaPromptBuilder.buildComprehensivePrompt(
        persona: completePersona,
        recentMessages: _getRecentMessages(chatHistory),
        userNickname: userNickname,
        contextMemory: contextMemory,
      );
      
      debugPrint('📝 Generated prompt with ${prompt.length} characters');
      
      // 4단계: API 호출
      final rawResponse = await _callOpenAI(
        prompt: prompt,
        userMessage: userMessage,
      );
      
      // 5단계: 통합 후처리
      final processedResponse = await SecurityAwarePostProcessor.processResponse(
        rawResponse: rawResponse,
        userMessage: userMessage,
        persona: completePersona,
        recentAIMessages: _extractRecentAIMessages(chatHistory),
        userNickname: userNickname,
      );
      
      // 6단계: 감정 분석 및 점수 계산
      final emotion = _analyzeEmotion(processedResponse);
      final scoreChange = await _calculateScoreChange(
        emotion: emotion,
        userMessage: userMessage,
        persona: completePersona,
        chatHistory: chatHistory,
      );
      
      return ChatResponse(
        content: processedResponse,
        emotion: emotion,
        scoreChange: scoreChange,
        metadata: {
          'processingTime': DateTime.now().millisecondsSinceEpoch,
          'promptTokens': _estimateTokens(prompt),
          'responseTokens': _estimateTokens(processedResponse),
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
        maxTokens: 500,
      );
      return memory;
    } catch (e) {
      debugPrint('⚠️ Failed to build context memory: $e');
      return '';
    }
  }
  
  /// OpenAI API 호출
  Future<String> _callOpenAI({
    required String prompt,
    required String userMessage,
  }) async {
    final apiKey = _apiKey;
    debugPrint('🔑 API Key loaded: ${apiKey.isNotEmpty ? "Yes (${apiKey.substring(0, 10)}...)" : "No"}');
    
    if (apiKey.isEmpty) {
      debugPrint('❌ API Key is empty!');
      throw Exception('OpenAI API key not configured');
    }
    
    final messages = [
      {
        'role': 'system',
        'content': prompt,
      },
      {
        'role': 'user',
        'content': userMessage,
      },
    ];
    
    debugPrint('🌐 Calling OpenAI API...');
    debugPrint('📝 Model: $_model');
    debugPrint('💬 User message: ${userMessage.substring(0, userMessage.length > 50 ? 50 : userMessage.length)}...');
    
    final response = await _httpClient.post(
      Uri.parse(_baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'model': _model,
        'messages': messages,
        'max_tokens': AppConstants.maxOutputTokens,
        'temperature': 0.85,
        'presence_penalty': 0.6,
        'frequency_penalty': 0.5,
        'top_p': 0.9,
      }),
    ).timeout(
      const Duration(seconds: 30),
      onTimeout: () => throw TimeoutException('API timeout'),
    );
    
    debugPrint('📨 Response status: ${response.statusCode}');
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      debugPrint('✅ API call successful');
      return data['choices'][0]['message']['content'].toString().trim();
    } else {
      debugPrint('❌ API error: ${response.statusCode}');
      debugPrint('📄 Response body: ${response.body}');
      throw Exception('API error: ${response.statusCode} - ${response.body}');
    }
  }
  
  /// 최근 메시지 추출
  List<Message> _getRecentMessages(List<Message> history) {
    const maxRecent = 5;
    if (history.length <= maxRecent) return history;
    return history.sublist(history.length - maxRecent);
  }
  
  /// 최근 AI 메시지 추출
  List<String> _extractRecentAIMessages(List<Message> history) {
    return history
        .where((m) => !m.isFromUser)
        .take(3)
        .map((m) => m.content)
        .toList();
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
    // 간단한 점수 계산 로직
    int baseChange = 0;
    
    switch (emotion) {
      case EmotionType.happy:
      case EmotionType.love:
        baseChange = 2;
        break;
      case EmotionType.sad:
      case EmotionType.anxious:
        baseChange = -1;
        break;
      case EmotionType.angry:
        baseChange = -2;
        break;
      default:
        baseChange = 0;
    }
    
    // 사용자 메시지 긍정/부정 분석
    final userLower = userMessage.toLowerCase();
    if (userLower.contains('사랑') || userLower.contains('좋아') || userLower.contains('고마')) {
      baseChange += 1;
    } else if (userLower.contains('싫어') || userLower.contains('짜증') || userLower.contains('바보')) {
      baseChange -= 2;
    }
    
    // 관계 수준에 따른 보정
    if (persona.currentRelationship == RelationshipType.dating || 
        persona.currentRelationship == RelationshipType.perfectLove) {
      baseChange = (baseChange * 0.7).round(); // 높은 관계에서는 변화폭 감소
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
    final responses = persona.isCasualSpeech ? [
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
  
  void dispose() {
    _httpClient.close();
  }
}

/// 채팅 응답 모델
class ChatResponse {
  final String content;
  final EmotionType emotion;
  final int scoreChange;
  final Map<String, dynamic>? metadata;
  final bool isError;
  
  ChatResponse({
    required this.content,
    required this.emotion,
    required this.scoreChange,
    this.metadata,
    this.isError = false,
  });
}