import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../models/message.dart';
import '../../../models/persona.dart';
import '../../../core/constants.dart';
import '../prompts/unified_prompt_service.dart';
import '../analysis/pattern_analyzer_service.dart';
import '../analysis/advanced_pattern_analyzer.dart';
import '../utils/persona_relationship_cache.dart';

/// 🚀 OpenAI Conversations/Responses API 서비스
/// 
/// 새로운 API를 활용한 최적화된 대화 관리:
/// - Conversations API: 대화 상태 자동 관리
/// - Responses API: 대화 컨텍스트 체이닝
/// - 서버 측 대화 히스토리 관리
/// - 30일 자동 보존
class ConversationsService {
  static const String _baseUrl = 'https://api.openai.com';
  static String get _apiKey => AppConstants.openAIKey;
  
  // API 엔드포인트
  static const String _conversationsEndpoint = '/v1/conversations';
  static const String _responsesEndpoint = '/v1/responses';
  
  // 토큰 제한 설정
  static const int _maxInputTokens = 4200;
  static const int _maxOutputTokens = 250;
  static const int _maxTranslationTokens = 500;
  
  // API 파라미터 최적화 (일관성 향상을 위해 조정)
  static const double _temperature = 0.75;  // 0.85 -> 0.75 (일관성 향상)
  static const double _presencePenalty = 0.4;  // 0.3 -> 0.4 (반복 감소)
  static const double _frequencyPenalty = 0.25;  // 0.2 -> 0.25 (다양성 유지)
  static const double _topP = 0.92;  // 0.95 -> 0.92 (예측 가능성 향상)
  
  // 연결 풀링
  static final http.Client _httpClient = http.Client();
  
  // 대화 ID 캐시 (userId_personaId -> conversationId)
  static final Map<String, String> _conversationCache = {};
  
  // 마지막 응답 ID 캐시 (conversationId -> responseId)
  static final Map<String, String> _lastResponseCache = {};
  
  /// 🎯 대화 생성 또는 가져오기
  static Future<String> getOrCreateConversation({
    required String userId,
    required String personaId,
    Map<String, dynamic>? metadata,
  }) async {
    final cacheKey = '${userId}_$personaId';
    
    // 캐시 확인
    if (_conversationCache.containsKey(cacheKey)) {
      debugPrint('📦 Using cached conversation: ${_conversationCache[cacheKey]}');
      return _conversationCache[cacheKey]!;
    }
    
    try {
      // 새 대화 생성
      final response = await _httpClient.post(
        Uri.parse('$_baseUrl$_conversationsEndpoint'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'metadata': {
            'user_id': userId,
            'persona_id': personaId,
            ...?metadata,
          },
        }),
      );
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final conversationId = data['id'];
        
        // 캐시 저장
        _conversationCache[cacheKey] = conversationId;
        
        debugPrint('✅ Created new conversation: $conversationId');
        return conversationId;
      } else {
        throw Exception('Failed to create conversation: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('❌ Error creating conversation: $e');
      // 폴백: 로컬 ID 생성
      final fallbackId = 'local_${DateTime.now().millisecondsSinceEpoch}';
      _conversationCache[cacheKey] = fallbackId;
      return fallbackId;
    }
  }
  
  /// 🎯 메인 응답 생성 메서드 (Responses API 사용)
  static Future<ResponseResult> generateResponse({
    required Persona persona,
    required String userMessage,
    required String userId,
    String? conversationId,
    List<Message>? recentMessages,
    String? contextHint,
    String? userNickname,
    int? userAge,
    String? targetLanguage,
    String? previousResponseId,
    bool storeResponse = true,
  }) async {
    try {
      // 1. 대화 ID 확인 또는 생성
      conversationId ??= await getOrCreateConversation(
        userId: userId,
        personaId: persona.id,
      );
      
      // 2. 고급 패턴 분석
      final advancedAnalyzer = AdvancedPatternAnalyzer();
      final advancedAnalysis = await advancedAnalyzer.analyzeComprehensive(
        userMessage: userMessage,
        chatHistory: recentMessages ?? [],
        persona: persona,
        userNickname: userNickname,
        likeScore: persona.likes,
      );
      
      // 3. 컨텍스트 힌트 강화
      String? enhancedContextHint = contextHint;
      if (advancedAnalysis.actionableGuidelines.isNotEmpty) {
        final guidelines = advancedAnalysis.actionableGuidelines.join('\n');
        enhancedContextHint = enhancedContextHint != null
            ? '$enhancedContextHint\n\n## 🎯 실시간 가이드:\n$guidelines'
            : '## 🎯 실시간 가이드:\n$guidelines';
      }
      
      // 4. 프롬프트 생성
      final prompt = UnifiedPromptService.buildPrompt(
        persona: persona,
        relationshipType: _getRelationshipType(persona),
        recentMessages: recentMessages,
        userNickname: userNickname,
        userAge: userAge,
        isCasualSpeech: true,
        contextHint: enhancedContextHint,
        patternAnalysis: advancedAnalysis.basicAnalysis,
      );
      
      // 5. 입력 메시지 구성
      final inputMessages = _buildInputMessages(
        systemPrompt: prompt,
        userMessage: userMessage,
        recentMessages: recentMessages,
      );
      
      // 6. 반복 억제를 위한 logit_bias 생성
      final logitBias = _buildLogitBias(recentMessages);
      
      // 7. API 호출
      final requestBody = {
        'model': AppConstants.openAIModel,
        'input': inputMessages,
        'conversation': conversationId,
        'store': storeResponse,
        'max_completion_tokens': targetLanguage != null 
            ? _maxTranslationTokens 
            : _maxOutputTokens,
        'temperature': _temperature,
        'presence_penalty': _presencePenalty,
        'frequency_penalty': _frequencyPenalty,
        'top_p': _topP,
        
        // 🆕 고급 파라미터 활용
        'stop': [
          '\n\n\n',      // 과도한 줄바꿈 방지
          '[SYSTEM]',    // 시스템 메시지 유출 방지
          '###',         // 구분자 방지
          '```',         // 코드 블록 방지
        ],
        
        // 🆕 반복 패턴 억제
        if (logitBias.isNotEmpty) 'logit_bias': logitBias,
        
        // 🆕 이전 응답 체이닝
        if (previousResponseId != null) 
          'previous_response_id': previousResponseId
        else if (_lastResponseCache.containsKey(conversationId))
          'previous_response_id': _lastResponseCache[conversationId],
        
        // 🆕 개발 모드 재현성
        if (AppConstants.isDevelopment) 'seed': 42,
        
        // 🆕 다국어 처리 최적화
        if (targetLanguage != null && targetLanguage != 'ko')
          'response_format': {'type': 'json_object'},
      };
      
      final response = await _httpClient.post(
        Uri.parse('$_baseUrl$_responsesEndpoint'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode(requestBody),
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () => throw TimeoutException('OpenAI API timeout'),
      );
      
      debugPrint('📡 Responses API Status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final responseId = data['id'];
        final outputText = data['output_text'] ?? 
                          data['output']?[0]?['content'] ?? 
                          '';
        
        // 응답 ID 캐시
        _lastResponseCache[conversationId] = responseId;
        
        // 토큰 사용량 로깅
        final usage = data['usage'];
        if (usage != null) {
          debugPrint('Token usage - Input: ${usage['input_tokens']}, '
                    'Output: ${usage['output_tokens']}, '
                    'Total: ${usage['total_tokens']}');
        }
        
        return ResponseResult(
          content: outputText.toString().trim(),
          responseId: responseId,
          conversationId: conversationId,
          tokenUsage: usage,
        );
      } else {
        throw Exception('API error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      debugPrint('❌ Error generating response: $e');
      rethrow;
    }
  }
  
  /// 🔧 입력 메시지 구성
  static List<Map<String, String>> _buildInputMessages({
    required String systemPrompt,
    required String userMessage,
    List<Message>? recentMessages,
  }) {
    final messages = <Map<String, String>>[];
    
    // 시스템 프롬프트
    messages.add({
      'role': 'system',
      'content': systemPrompt,
    });
    
    // 최근 대화 (있을 경우)
    if (recentMessages != null && recentMessages.isNotEmpty) {
      // 최근 15개만 포함 (최적화)
      final relevantMessages = recentMessages.length > 15
          ? recentMessages.sublist(recentMessages.length - 15)
          : recentMessages;
      
      for (final msg in relevantMessages) {
        messages.add({
          'role': msg.isFromUser ? 'user' : 'assistant',
          'content': msg.content,
        });
      }
    }
    
    // 현재 사용자 메시지
    messages.add({
      'role': 'user',
      'content': userMessage,
    });
    
    return messages;
  }
  
  /// 🔧 Logit Bias 생성 (반복 억제 및 회피 방지 강화)
  static Map<String, double> _buildLogitBias(List<Message>? recentMessages) {
    final bias = <String, double>{};
    
    // 기본 억제 패턴 (회피성 답변 강화 억제)
    bias['31481'] = -50;  // "죄송합니다"
    bias['47991'] = -50;  // "모르겠어요"
    bias['23539'] = -50;  // "네?" (강화: -30 -> -50)
    bias['39439'] = -50;  // "어?" (강화: -30 -> -50)
    bias['35699'] = -40;  // "뭐라고"
    bias['41823'] = -40;  // "다시 말해"
    bias['28975'] = -40;  // "무슨 말"
    
    // 선호 패턴
    bias['33599'] = 5;    // "ㅋㅋ"
    bias['44239'] = 5;    // "ㅎㅎ"
    
    // 최근 메시지에서 반복된 패턴 억제
    if (recentMessages != null && recentMessages.isNotEmpty) {
      final recentAIMessages = recentMessages
          .where((m) => !m.isFromUser)
          .map((m) => m.content)
          .toList();
      
      // 자주 사용된 시작 패턴 억제
      for (final msg in recentAIMessages) {
        if (msg.startsWith('아')) bias['50793'] = -20;  // "아"로 시작
        if (msg.startsWith('그래')) bias['23887'] = -20;  // "그래"로 시작
        if (msg.startsWith('헐')) bias['52231'] = -20;  // "헐"로 시작
      }
    }
    
    return bias;
  }
  
  /// 🔧 관계 타입 결정
  static String _getRelationshipType(Persona persona) {
    if (persona.likes < 30) return 'acquaintance';
    if (persona.likes < 60) return 'friend';
    if (persona.likes < 80) return 'close_friend';
    return 'intimate';
  }
  
  /// 📊 대화 히스토리 가져오기
  static Future<List<Map<String, dynamic>>> getConversationHistory({
    required String conversationId,
    int? limit,
  }) async {
    try {
      final response = await _httpClient.get(
        Uri.parse('$_baseUrl$_conversationsEndpoint/$conversationId/items'
            '${limit != null ? '?limit=$limit' : ''}'),
        headers: {
          'Authorization': 'Bearer $_apiKey',
        },
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data['items'] ?? []);
      } else {
        throw Exception('Failed to get conversation history: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('❌ Error getting conversation history: $e');
      return [];
    }
  }
  
  /// 🗑️ 대화 삭제
  static Future<bool> deleteConversation(String conversationId) async {
    try {
      final response = await _httpClient.delete(
        Uri.parse('$_baseUrl$_conversationsEndpoint/$conversationId'),
        headers: {
          'Authorization': 'Bearer $_apiKey',
        },
      );
      
      if (response.statusCode == 200 || response.statusCode == 204) {
        // 캐시에서도 제거
        _conversationCache.removeWhere((key, value) => value == conversationId);
        _lastResponseCache.remove(conversationId);
        debugPrint('✅ Deleted conversation: $conversationId');
        return true;
      } else {
        debugPrint('❌ Failed to delete conversation: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      debugPrint('❌ Error deleting conversation: $e');
      return false;
    }
  }
  
  /// 🔄 캐시 초기화
  static void clearCache() {
    _conversationCache.clear();
    _lastResponseCache.clear();
    debugPrint('🧹 Cleared conversation caches');
  }
}

/// 응답 결과 클래스
class ResponseResult {
  final String content;
  final String responseId;
  final String conversationId;
  final Map<String, dynamic>? tokenUsage;
  
  ResponseResult({
    required this.content,
    required this.responseId,
    required this.conversationId,
    this.tokenUsage,
  });
}