import 'dart:async';
import 'package:flutter/material.dart';
import '../../../models/message.dart';
import '../../../models/persona.dart';
import 'openai_service.dart';
import 'conversations_service.dart';
import '../prompts/optimized_prompt_service.dart';
import '../security/security_aware_post_processor.dart';
import 'context_analyzer.dart';
import 'emotion_processor.dart';
import 'memory_manager.dart';
import 'validation_pipeline.dart';

/// 응답 생성 핵심 모듈
/// ChatOrchestrator에서 분리된 응답 생성 전용 클래스
class ResponseGenerator {
  static ResponseGenerator? _instance;
  static ResponseGenerator get instance => _instance ??= ResponseGenerator._();
  
  ResponseGenerator._();
  
  // 서비스 참조 (static 메서드를 사용하는 서비스들)
  final ContextAnalyzer _contextAnalyzer = ContextAnalyzer.instance;
  final EmotionProcessor _emotionProcessor = EmotionProcessor.instance;
  final MemoryManager _memoryManager = MemoryManager.instance;
  final ValidationPipeline _validationPipeline = ValidationPipeline.instance;
  
  // 응답 재시도 관련
  int _retryCount = 0;
  static const int _maxRetries = 3;
  
  /// 메인 응답 생성 메서드
  Future<Map<String, dynamic>> generateResponse({
    required String userMessage,
    required List<Message> chatHistory,
    required Persona persona,
    required String userId,
    String? conversationId,
    String languageCode = 'ko',
    bool isInitialGreeting = false,
  }) async {
    try {
      _retryCount = 0;
      
      // 1. 컨텍스트 분석
      final contextAnalysis = await _contextAnalyzer.analyzeContext(
        userMessage: userMessage,
        chatHistory: chatHistory,
        persona: persona,
        userId: userId,
        languageCode: languageCode,
      );
      
      // 2. 감정 처리
      final emotionData = await _emotionProcessor.processEmotions(
        userMessage: userMessage,
        chatHistory: chatHistory,
        persona: persona,
        contextAnalysis: contextAnalysis,
      );
      
      // 3. 메모리 구축
      final memoryContext = await _memoryManager.buildMemoryContext(
        userId: userId,
        personaId: persona.id,
        chatHistory: chatHistory,
        userMessage: userMessage,
      );
      
      // 4. 프롬프트 구성
      final systemPrompt = OptimizedPromptService.buildOptimizedPrompt(
        persona: persona,
        chatHistory: chatHistory,
        userMessage: userMessage,
        relationshipType: 'friend', // Default relationship type
        userNickname: null,
        userAge: null,
        isCasualSpeech: true,
      );
      
      // Context hint from analysis
      final contextHint = contextAnalysis['specialContext']?['isInitialGreeting'] == true ?
          'This is the first greeting. Be warm and welcoming.' :
          'Continue the conversation naturally.';
      
      // 5. OpenAI API 호출
      String aiResponse;
      Map<String, dynamic>? parsedTranslations;
      
      if (conversationId != null) {
        // TODO: Conversations API 사용 구현
        // 임시로 기존 API 사용
        aiResponse = await OpenAIService.generateResponse(
          persona: persona,
          chatHistory: chatHistory,
          userMessage: userMessage,
          relationshipType: 'friend',
          conversationId: conversationId,
          userId: userId,
          contextHint: contextHint,
        );
      } else {
        // 기존 OpenAI API 사용
        aiResponse = await OpenAIService.generateResponse(
          persona: persona,
          chatHistory: chatHistory,
          userMessage: userMessage,
          relationshipType: 'friend',
          conversationId: null,
          userId: userId,
          contextHint: contextHint,
        );
      }
      
      // 6. 응답 검증
      final validationResult = await _validationPipeline.validateResponse(
        response: aiResponse,
        userMessage: userMessage,
        contextAnalysis: contextAnalysis,
        persona: persona,
      );
      
      // 7. 검증 실패 시 재생성
      if (!validationResult['isValid']) {
        if (_retryCount < _maxRetries) {
          _retryCount++;
          debugPrint('🔄 응답 재생성 시도 $_retryCount/$_maxRetries');
          
          // 재생성 힌트 추가
          return generateResponse(
            userMessage: userMessage,
            chatHistory: chatHistory,
            persona: persona,
            userId: userId,
            conversationId: conversationId,
            languageCode: languageCode,
            isInitialGreeting: isInitialGreeting,
          );
        }
      }
      
      // 8. 후처리
      final processedResponse = SecurityAwarePostProcessor.processResponse(
        rawResponse: aiResponse,
        persona: persona,
        userMessage: userMessage,
      );
      
      // 9. 메모리 업데이트
      await _memoryManager.updateMemory(
        userId: userId,
        personaId: persona.id,
        userMessage: userMessage,
        aiResponse: processedResponse,
      );
      
      // 10. 최종 결과 반환
      return {
        'response': processedResponse,
        'translations': parsedTranslations,
        'emotion': emotionData['primaryEmotion'],
        'likesChange': (emotionData['likesChange'] ?? 0) as int,
        'metadata': {
          'contextQuality': contextAnalysis['quality'] ?? 0.0,
          'emotionIntensity': emotionData['intensity'] ?? 0.5,
          'retryCount': _retryCount,
        },
      };
      
    } catch (e) {
      debugPrint('❌ 응답 생성 오류: $e');
      
      // 폴백 응답 (OpenAI API로 생성)
      try {
        final fallbackResponse = await _generateFallbackResponse(
          userMessage: userMessage,
          persona: persona,
          error: e.toString(),
        );
        return {
          'response': fallbackResponse,
          'translations': null,
          'emotion': null,
          'likesChange': 0,
          'metadata': {'isFallback': true},
        };
      } catch (fallbackError) {
        // 최종 폴백
        return {
          'response': _getEmergencyResponse(languageCode),
          'translations': null,
          'emotion': null,
          'likesChange': 0,
          'metadata': {'isEmergency': true},
        };
      }
    }
  }
  
  /// 폴백 응답 생성 (OpenAI API 사용)
  Future<String> _generateFallbackResponse({
    required String userMessage,
    required Persona persona,
    required String error,
  }) async {
    try {
      final result = await OpenAIService.generateResponse(
        persona: persona,
        chatHistory: [],
        userMessage: userMessage,
        relationshipType: 'friend',
        contextHint: '''
You are ${persona.name}, having a casual conversation.
An error occurred, but continue the conversation naturally.
Respond briefly and naturally to: "$userMessage"
''',
      );
      
      return result ?? _getEmergencyResponse('ko');
    } catch (e) {
      debugPrint('❌ 폴백 응답 생성 실패: $e');
      return _getEmergencyResponse('ko');
    }
  }
  
  /// 긴급 응답 (최종 폴백)
  String _getEmergencyResponse(String languageCode) {
    // 언어별 긴급 응답
    final emergencyResponses = {
      'ko': '잠시만요, 생각 좀 할게요.',
      'en': 'Let me think for a moment.',
      'ja': 'ちょっと待ってください。',
      'zh': '请稍等一下。',
      'es': 'Un momento, por favor.',
      'fr': 'Un instant, s\'il vous plaît.',
    };
    
    return emergencyResponses[languageCode] ?? emergencyResponses['en']!;
  }
}