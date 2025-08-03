import 'dart:async';
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
        isCasualSpeech: isCasualSpeech,
        userAge: userAge,
      );
      
      debugPrint('📝 Generated prompt with ${prompt.length} characters');
      
      // 4단계: API 호출
      final rawResponse = await OpenAIService.generateResponse(
        persona: completePersona,
        chatHistory: chatHistory,
        userMessage: userMessage,
        relationshipType: _getRelationshipType(completePersona),
        userNickname: userNickname,
        userAge: userAge,
        isCasualSpeech: isCasualSpeech,
      );
      
      // 5단계: 통합 후처리 (필요한 경우만)
      // OpenAIService에서 이미 보안 필터링을 하므로 추가 필터링이 필요한 경우만 수행
      final processedResponse = rawResponse;
      
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