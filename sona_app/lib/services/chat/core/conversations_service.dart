import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
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

/// 🚀 OpenAI Chat Completions API 서비스
/// 
/// Chat Completions API를 활용한 최적화된 대화 관리:
/// - 표준 Chat Completions API 사용 (Conversations/Responses API 출시 대기중)
/// - 로컬 대화 상태 관리 및 캐싱
/// - 언어 자동 감지 및 번역 지원
/// - 토큰 최적화 및 컨텍스트 관리
class ConversationsService {
  static const String _baseUrl = 'https://api.openai.com';
  static String get _apiKey => AppConstants.openAIKey;
  
  // API 엔드포인트
  // Note: OpenAI doesn't have Conversations/Responses API yet, using Chat Completions
  static const String _conversationsEndpoint = '/v1/chat/completions';  // Fallback to chat API
  static const String _responsesEndpoint = '/v1/chat/completions';      // Use standard chat API
  
  // 토큰 제한 설정 (4000 토큰 충분히 활용)
  static const int _maxInputTokens = 4000;  // 4200 중 4000 활용
  static const int _maxOutputTokens = 250;
  static const int _maxTranslationTokens = 500;
  
  // 토큰 할당 전략 (조정됨)
  static const int _systemPromptTokens = 2500;  // 프롬프트 증가 (언어 감지 포함)
  static const int _historyTokens = 1300;       // 10-15턴 대화로 감소
  static const int _userMessageTokens = 200;    // 현재 메시지
  
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
  
  /// 🔧 토큰 추정 함수 (한글/영어 고려)
  static int _estimateTokens(String text) {
    if (text.isEmpty) return 0;
    
    // 한글: 평균 2-3자 = 1토큰, 영어: 평균 4자 = 1토큰
    final koreanChars = RegExp(r'[가-힣]').allMatches(text).length;
    final englishChars = RegExp(r'[a-zA-Z]').allMatches(text).length;
    final otherChars = text.length - koreanChars - englishChars;
    
    // 보수적으로 계산 (약간 여유 둠)
    return ((koreanChars / 2.3) + (englishChars / 3.8) + (otherChars / 4)).ceil();
  }
  
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
  
  /// 📝 대화 아이템 추가 (Items API)
  static Future<bool> addConversationItems({
    required String conversationId,
    required List<Map<String, dynamic>> items,
  }) async {
    try {
      final response = await _httpClient.post(
        Uri.parse('$_baseUrl$_conversationsEndpoint/$conversationId/items'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({'items': items}),
      );
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('✅ Added ${items.length} items to conversation');
        return true;
      } else {
        debugPrint('❌ Failed to add items: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      debugPrint('❌ Error adding conversation items: $e');
      return false;
    }
  }
  
  /// 📖 대화 히스토리 가져오기 (Items API)
  static Future<List<dynamic>> getConversationHistory({
    required String conversationId,
    int limit = 30,
    String? after,
  }) async {
    try {
      var url = '$_baseUrl$_conversationsEndpoint/$conversationId/items?limit=$limit';
      if (after != null) url += '&after=$after';
      
      final response = await _httpClient.get(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer $_apiKey'},
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        debugPrint('📚 Retrieved ${data['data']?.length ?? 0} conversation items');
        return data['data'] ?? [];
      } else {
        debugPrint('❌ Failed to get history: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      debugPrint('❌ Error getting conversation history: $e');
      return [];
    }
  }
  
  /// 🗑️ 대화 아이템 삭제 (Items API)
  static Future<bool> deleteConversationItem({
    required String conversationId,
    required String itemId,
  }) async {
    try {
      final response = await _httpClient.delete(
        Uri.parse('$_baseUrl$_conversationsEndpoint/$conversationId/items/$itemId'),
        headers: {'Authorization': 'Bearer $_apiKey'},
      );
      
      if (response.statusCode == 200) {
        debugPrint('✅ Deleted item: $itemId');
        return true;
      } else {
        debugPrint('❌ Failed to delete item: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      debugPrint('❌ Error deleting conversation item: $e');
      return false;
    }
  }
  
  /// 🔄 대화 메타데이터 업데이트
  static Future<bool> updateConversationMetadata({
    required String conversationId,
    required Map<String, dynamic> metadata,
  }) async {
    try {
      final response = await _httpClient.post(
        Uri.parse('$_baseUrl$_conversationsEndpoint/$conversationId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({'metadata': metadata}),
      );
      
      if (response.statusCode == 200) {
        debugPrint('✅ Updated conversation metadata');
        return true;
      } else {
        debugPrint('❌ Failed to update metadata: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      debugPrint('❌ Error updating metadata: $e');
      return false;
    }
  }
  
  /// 🧠 메모리를 시스템 메시지로 저장 (Items API)
  static Future<bool> saveMemoryAsSystemMessage({
    required String conversationId,
    required String memoryContent,
    required double importance,
    String? emotion,
    List<String>? tags,
  }) async {
    try {
      // 메모리를 시스템 메시지 형식으로 구성
      final memoryMessage = '''[MEMORY]
중요도: ${(importance * 100).toStringAsFixed(0)}%
${emotion != null ? '감정: $emotion' : ''}
${tags != null && tags.isNotEmpty ? '태그: ${tags.join(', ')}' : ''}
내용: $memoryContent''';
      
      final response = await _httpClient.post(
        Uri.parse('$_baseUrl$_conversationsEndpoint/$conversationId/items'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'items': [{
            'type': 'message',
            'role': 'system',
            'content': memoryMessage,
          }]
        }),
      );
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('🧠 Saved memory to conversation: ${memoryContent.substring(0, math.min(50, memoryContent.length))}...');
        return true;
      } else {
        debugPrint('❌ Failed to save memory: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      debugPrint('❌ Error saving memory: $e');
      return false;
    }
  }
  
  /// 🎯 메인 응답 생성 메서드 (Chat Completions API 사용)
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
    String? systemLanguage,  // 시스템 언어 추가
    String? previousResponseId,
    bool storeResponse = true,
  }) async {
    try {
      // 1. 대화 ID 생성 (로컬용)
      conversationId ??= '${userId}_${persona.id}';
      
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
        languageCode: targetLanguage == 'auto' ? 'auto' : (systemLanguage ?? targetLanguage ?? 'ko'),
        systemLanguage: systemLanguage,
      );
      
      // 5. 입력 메시지 구성
      final inputMessages = _buildInputMessages(
        systemPrompt: prompt,
        userMessage: userMessage,
        recentMessages: recentMessages,
      );
      
      // 🔍 디버그: 프롬프트 확인
      debugPrint('🎯 System Prompt Length: ${prompt.length} chars');
      debugPrint('🎯 Has language detection prompt: ${prompt.toUpperCase().contains('LANGUAGE DETECTION') || prompt.contains('FIRST PRIORITY')}');
      debugPrint('🎯 Has [KO] tag instruction: ${prompt.contains('[KO]')}');
      debugPrint('🎯 Target Language: $targetLanguage');
      debugPrint('🎯 Language code passed: ${targetLanguage == 'auto' ? 'auto' : (systemLanguage ?? targetLanguage ?? 'ko')}');
      debugPrint('🎯 User Message: $userMessage');
      
      // 프롬프트 내용 일부 확인
      if (prompt.toUpperCase().contains('LANGUAGE DETECTION') || prompt.contains('FIRST PRIORITY')) {
        debugPrint('✅ Language detection section found in prompt');
        // Show first 500 chars to verify it's at the top
        debugPrint('📝 Prompt start: ${prompt.substring(0, prompt.length > 500 ? 500 : prompt.length)}...');
      } else {
        debugPrint('❌ Language detection section NOT found in prompt');
        debugPrint('🔍 Checking languageCode condition: ${targetLanguage == 'auto' ? 'auto' : (systemLanguage ?? targetLanguage ?? 'ko')}');
        // Show first 500 chars to debug why it's missing
        debugPrint('📝 Prompt start: ${prompt.substring(0, prompt.length > 500 ? 500 : prompt.length)}...');
      }
      
      // 6. 반복 억제를 위한 logit_bias 생성
      // Responses API doesn't support logit_bias parameter
      // final logitBias = _buildLogitBias(recentMessages);
      
      // 7. API 호출 (Chat Completions API 형식)
      final Map<String, dynamic> requestBody = {
        'model': AppConstants.openAIModel,
        'messages': inputMessages,  // 'input' -> 'messages' for Chat API
        'max_tokens': (targetLanguage != null && targetLanguage != 'ko')
            ? _maxTranslationTokens 
            : _maxOutputTokens,
        'temperature': _temperature,
        'top_p': _topP,
        // Chat Completions API에서 지원하는 파라미터들
        'presence_penalty': _presencePenalty,
        'frequency_penalty': _frequencyPenalty,
      };
      
      // 🔍 디버그: Request 확인
      debugPrint('📤 Sending to Chat Completions API:');
      debugPrint('  - Model: ${requestBody['model']}');
      debugPrint('  - Max Tokens: ${requestBody['max_tokens']}');
      debugPrint('  - Temperature: ${requestBody['temperature']}');
      debugPrint('  - Messages count: ${inputMessages.length}');
      debugPrint('  - System prompt has language detection: ${(inputMessages[0]['content']?.toUpperCase().contains('LANGUAGE DETECTION') ?? false) || (inputMessages[0]['content']?.contains('FIRST PRIORITY') ?? false)}');
      
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
      
      debugPrint('📡 Chat Completions API Status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Chat Completions API response format
        final responseId = data['id'] ?? '';
        final choices = data['choices'] ?? [];
        final outputText = choices.isNotEmpty 
            ? choices[0]['message']['content'] ?? ''
            : '';
        
        // 응답 ID 캐시
        if (responseId.isNotEmpty) {
          _lastResponseCache[conversationId] = responseId;
        }
        
        // 토큰 사용량 로깅
        final usage = data['usage'];
        if (usage != null) {
          debugPrint('Token usage - Input: ${usage['prompt_tokens']}, '
                    'Output: ${usage['completion_tokens']}, '
                    'Total: ${usage['total_tokens']}');
        }
        
        // 🔍 디버그: 응답 내용 확인
        debugPrint('🎯 Chat Completions API Success:');
        debugPrint('  Response ID: $responseId');
        debugPrint('  Output Text: $outputText');
        debugPrint('  Has [VI] tag: ${outputText.contains('[VI]')}');
        debugPrint('  Has [KO] tag: ${outputText.contains('[KO]')}');
        
        return ResponseResult(
          content: outputText.toString().trim(),
          responseId: responseId,
          conversationId: conversationId,
          tokenUsage: usage,
        );
      } else {
        // 상세한 에러 로깅
        debugPrint('❌ Chat Completions API Error: ${response.statusCode}');
        debugPrint('❌ Error Body: ${response.body}');
        
        // API 에러 분석
        try {
          final errorData = jsonDecode(response.body);
          if (errorData['error'] != null) {
            final error = errorData['error'];
            debugPrint('❌ Error Type: ${error['type']}');
            debugPrint('❌ Error Message: ${error['message']}');
            debugPrint('❌ Error Code: ${error['code']}');
            
            // Request body 디버깅을 위해 일부 표시
            debugPrint('📤 Request had:');
            debugPrint('  - Model: ${requestBody['model']}');
            debugPrint('  - Store: ${requestBody['store']}');
            debugPrint('  - Has conversation: ${requestBody.containsKey('conversation')}');
            debugPrint('  - Has previous_response_id: ${requestBody.containsKey('previous_response_id')}');
            if (requestBody.containsKey('conversation')) {
              debugPrint('  - Conversation ID: ${requestBody['conversation']}');
            }
            if (requestBody.containsKey('previous_response_id')) {
              debugPrint('  - Previous Response ID: ${requestBody['previous_response_id']}');
            }
          }
        } catch (e) {
          debugPrint('❌ Could not parse error response: $e');
        }
        
        throw Exception('API error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      debugPrint('❌ Error generating response: $e');
      rethrow;
    }
  }
  
  /// 🔧 입력 메시지 구성 (4000 토큰 충분히 활용)
  static List<Map<String, String>> _buildInputMessages({
    required String systemPrompt,
    required String userMessage,
    List<Message>? recentMessages,
  }) {
    final messages = <Map<String, String>>[];
    int currentTokens = 0;
    
    // 1. 시스템 프롬프트 (1800 토큰까지 허용)
    final systemTokens = _estimateTokens(systemPrompt);
    if (systemTokens > _systemPromptTokens) {
      debugPrint('⚠️ System prompt exceeds limit: $systemTokens tokens');
    }
    messages.add({
      'role': 'system',
      'content': systemPrompt,
    });
    currentTokens += systemTokens;
    
    // 2. 사용자 메시지 토큰 계산
    final userTokens = _estimateTokens(userMessage);
    currentTokens += userTokens;
    
    // 3. 대화 히스토리 (2000 토큰 충분히 활용)
    if (recentMessages != null && recentMessages.isNotEmpty) {
      final historyMessages = <Map<String, String>>[];
      int historyTokens = 0;
      final maxHistoryTokens = _maxInputTokens - currentTokens - 200; // 여유 200
      
      // 최근 메시지부터 역순으로 추가 (최대한 많이 포함)
      for (final msg in recentMessages.reversed) {
        final msgTokens = _estimateTokens(msg.content);
        
        // 토큰 한계에 도달하면 중지
        if (historyTokens + msgTokens > maxHistoryTokens && historyMessages.length >= 10) {
          // 최소 10개는 보장
          break;
        }
        
        historyMessages.insert(0, {
          'role': msg.isFromUser ? 'user' : 'assistant',
          'content': msg.content,
        });
        historyTokens += msgTokens;
      }
      
      // 대화 히스토리 추가
      messages.addAll(historyMessages);
      currentTokens += historyTokens;
      
      debugPrint('📊 History: ${historyMessages.length} messages, $historyTokens tokens');
    }
    
    // 4. 현재 사용자 메시지 추가
    messages.add({
      'role': 'user',
      'content': userMessage,
    });
    
    debugPrint('📊 Total input: $currentTokens tokens / $_maxInputTokens');
    debugPrint('📊 Messages: System(1) + History(${messages.length - 2}) + User(1)');
    
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
  
  /// 📊 대화 히스토리 가져오기 (상세 버전)
  static Future<List<Map<String, dynamic>>> getConversationHistoryDetailed({
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