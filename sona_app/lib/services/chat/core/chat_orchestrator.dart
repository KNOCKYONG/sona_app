import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../models/persona.dart';
import '../../../models/message.dart';
import '../../../core/constants.dart';
import '../../../core/constants/chat_patterns.dart';
import '../../../core/preferences_manager.dart';
import '../utils/persona_relationship_cache.dart';
import '../prompts/persona_prompt_builder.dart';
import '../security/security_aware_post_processor.dart';
import '../intelligence/conversation_memory_service.dart';
import '../intelligence/conversation_context_manager.dart';
import '../intelligence/service_orchestration_controller.dart';
import '../intelligence/humor_service.dart';
import '../intelligence/topic_suggestion_service.dart';
import '../intelligence/emotion_resolution_service.dart';
import '../intelligence/ultra_empathy_service.dart';
import '../intelligence/conversation_rhythm_master.dart';
import '../intelligence/memory_network_service.dart';
import '../intelligence/realtime_feedback_service.dart';
import 'openai_service.dart';
import '../../relationship/negative_behavior_system.dart';
import '../../storage/guest_conversation_service.dart';
import '../analysis/user_speech_pattern_analyzer.dart';
import '../analysis/pattern_analyzer_service.dart';
import '../analysis/advanced_pattern_analyzer.dart';
import '../prompts/response_patterns.dart';
import '../analysis/emotion_recognition_service.dart' as emotion_recognition;
import '../../personalization/user_preference_service.dart';
import '../../context/temporal_context_service.dart';
import '../../emotion/emotional_intelligence_service.dart' as emotional_intel;
import '../../memory/memory_album_service.dart';
import '../../memory/optimized_memory_system.dart' hide MemoryItem;
import '../../context/weather_context_service.dart';
import '../../conversation/conversation_continuity_service.dart';
import '../../care/daily_care_service.dart';
import '../../interest/interest_sharing_service.dart';
import '../intelligence/response_rhythm_manager.dart';
import '../intelligence/milestone_expression_service.dart';
import '../intelligence/emotional_transfer_service.dart' as emotional_transfer;
import '../intelligence/relationship_boundary_service.dart';
import '../intelligence/fuzzy_memory_service.dart';
import '../cache/response_variation_cache.dart';
import '../learning/user_preference_learning.dart';
import '../analysis/naturalness_analyzer.dart';
import 'unified_conversation_system.dart';
import 'conversation_state_manager.dart';
import '../quality/emotional_nuance_system.dart';
import '../quality/praise_encouragement_system.dart';
import '../quality/fun_element_system.dart';
import '../quality/intimacy_building_system.dart';

/// 메시지 타입 enum
enum ChatMessageType {
  general,
  question,
  greeting,
  farewell,
  compliment,
  thanks,
}

/// 사용자 감정 enum
enum UserEmotion {
  positive,
  negative,
  neutral,
  curious,
}

/// 메시지 분석 결과 클래스
class MessageAnalysis {
  final ChatMessageType type;
  final UserEmotion emotion;
  final double complexity;
  final List<String> keywords;
  final String? questionType;
  final emotion_recognition.EmotionAnalysis? emotionAnalysis;
  
  MessageAnalysis({
    required this.type,
    required this.emotion,
    this.complexity = 0.5,
    this.keywords = const [],
    this.questionType,
    this.emotionAnalysis,
  });
}

/// 감정 교류 품질 클래스
class EmotionalExchangeQuality {
  final double score;
  final String quality;
  final bool isMutual;
  final double emotionMatch;
  final bool hasEmpathy;
  
  EmotionalExchangeQuality({
    required this.score,
    required this.quality,
    this.isMutual = false,
    this.emotionMatch = 0.5,
    this.hasEmpathy = false,
  });
}

/// 특별한 순간 클래스
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

/// 채팅 플로우를 조정하는 중앙 오케스트레이터
/// 전체 메시지 생성 파이프라인을 관리
class ChatOrchestrator {
  static ChatOrchestrator? _instance;
  static ChatOrchestrator get instance => _instance ??= ChatOrchestrator._();

  ChatOrchestrator._();

  // 서비스 참조
  final PersonaRelationshipCache _relationshipCache =
      PersonaRelationshipCache.instance;
  final ConversationMemoryService _memoryService = ConversationMemoryService();
  final UnifiedConversationSystem _unifiedSystem = UnifiedConversationSystem.instance;
  
  // 🎯 대화 품질 개선 시스템들
  final EmotionalNuanceSystem _emotionalNuanceSystem = EmotionalNuanceSystem();
  final PraiseAndEncouragementSystem _praiseSystem = PraiseAndEncouragementSystem();
  final FunElementSystem _funElementSystem = FunElementSystem();
  final IntimacyBuildingSystem _intimacySystem = IntimacyBuildingSystem();
  
  // 반복 응답 방지를 위한 캐시 (유저-페르소나 조합별 최근 응답 저장)
  // 키 형식: "userId_personaId"
  final Map<String, List<String>> _recentResponseCache = {};
  static const int _maxCacheSize = 10; // 최근 10개 응답 저장 (5 -> 10으로 확대)
  
  // 추억 회상 캐시
  final Map<String, MemoryItem> _memoryToRecall = {};
  
  /// 다국어 추가 질문 패턴
  static final Map<String, List<String>> _multilingualQuestions = {
    'ko': [
      '너는 어떻게 생각해?',
      '너는 어때?', 
      '너는?',
      '너도?',
      '뭐가 좋을까?',
      '다른 건 어때?'
    ],
    'en': [
      'What do you think?',
      'How about you?',
      'You?',
      'You too?',
      'What would be good?',
      'How about something else?'
    ],
    'es': [
      '¿Qué piensas?',
      '¿Y tú?',
      '¿Tú?',
      '¿Tú también?',
      '¿Qué sería bueno?',
      '¿Qué tal otra cosa?'
    ],
    'ja': [
      'どう思う？',
      'あなたは？',
      'きみは？',
      'あなたも？',
      '何がいいかな？',
      '他のはどう？'
    ],
    'zh': [
      '你怎么想？',
      '你呢？',
      '你？',
      '你也是？',
      '什么好呢？',
      '其他的怎么样？'
    ],
    'fr': [
      'Qu\'est-ce que tu en penses?',
      'Et toi?',
      'Toi?',
      'Toi aussi?',
      'Qu\'est-ce qui serait bien?',
      'Et autre chose?'
    ]
  };

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
      debugPrint('🔍 Checking language for message: "$userMessage"');
      if (userLanguage == null) {
        final detectedLang = _detectSpecificLanguage(userMessage);
        if (detectedLang != null) {
          userLanguage = detectedLang;
          debugPrint(
              '🌍 Language detected: $detectedLang (${_getLanguageName(detectedLang)})');
        } else {
          debugPrint('🔍 No foreign language detected, using Korean');
        }
      }

      // 1단계: 완전한 페르소나 정보 로드
      final personaData = await _relationshipCache.getCompletePersona(
        userId: userId,
        basePersona: basePersona,
      );
      final completePersona = personaData.persona;
      final isCasualSpeech = personaData.isCasualSpeech;

      debugPrint(
          '✅ Loaded complete persona: ${completePersona.name} (casual: $isCasualSpeech)');

      // 2단계: 메시지 전처리 및 분석
      final messageAnalysis = _analyzeUserMessage(userMessage);

      // 2.5단계: 사용자 말투 패턴 분석
      final userMessages =
          chatHistory.where((m) => m.isFromUser).map((m) => m.content).toList();
      userMessages.add(userMessage); // 현재 메시지도 포함

      // UserSpeechPatternAnalyzer는 static 메서드를 사용
      final speechPattern = UserSpeechPatternAnalyzer.analyzeSpeechPattern(userMessages);
      // generateAdaptationGuide는 별도로 구현 필요
      final adaptationGuide = '';  // 임시로 빈 문자열 사용

      // 말투 모드 결정: 항상 반말 모드 사용
      bool currentSpeechMode = true; // 항상 반말 모드

      // 2.5단계: 다국어 입력 처리
      // 영어 입력은 첫 인사만 특별 처리, 나머지는 API에서 직접 처리
      if (userLanguage != null && userLanguage == 'en') {
        // 첫 인사말만 특별 처리 (대화 시작을 부드럽게)
        if (chatHistory.isEmpty || chatHistory.length <= 1) {
          final specialResponse = _generateSpecialMultilingualResponse(
            userLanguage,
            userMessage,
            completePersona,
            chatHistory,
          );
          
          if (specialResponse != null) {
            debugPrint('🌍 Special greeting response generated: $specialResponse');
            
            // 다국어 응답도 감정 분석 및 점수 계산
            final emotion = _analyzeEmotion(specialResponse);
            final scoreChange = await _calculateScoreChange(
              emotion: emotion,
              userMessage: userMessage,
              persona: completePersona,
              chatHistory: chatHistory,
            );
            
            return ChatResponse(
              content: specialResponse,
              emotion: emotion,
              scoreChange: scoreChange,
              metadata: {
                'isMultilingual': true,
                'detectedLanguage': userLanguage,
              },
            );
          }
        }
        // 영어 입력은 이제 API에서 직접 처리하도록 계속 진행
        debugPrint('🌍 English input detected, will be processed by API: $userMessage');
      } else if (userLanguage != null && userLanguage != 'ko') {
        // 다른 언어는 기존 로직 유지
        final multilingualResponse = _generateMultilingualResponse(
          userLanguage,
          userMessage,
          completePersona,
        );
        
        if (multilingualResponse != null) {
          debugPrint('🌍 Multilingual response generated: $multilingualResponse');
          
          // 다국어 응답도 감정 분석 및 점수 계산
          final emotion = _analyzeEmotion(multilingualResponse);
          final scoreChange = await _calculateScoreChange(
            emotion: emotion,
            userMessage: userMessage,
            persona: completePersona,
            chatHistory: chatHistory,
          );
          
          return ChatResponse(
            content: multilingualResponse,
            emotion: emotion,
            scoreChange: scoreChange,
            metadata: {
              'isMultilingual': true,
              'detectedLanguage': userLanguage,
            },
          );
        }
      }
      
      // 3단계: 간단한 반응 체크 -> 프롬프트 힌트 생성으로 변경
      // 하드코딩 응답 제거: 모든 응답은 OpenAI API를 통해 생성
      final simpleResponseHint = await _generateSimpleResponseHint(
        userMessage: userMessage,
        persona: completePersona,
        messageType: messageAnalysis.type,
        userId: userId,
        chatHistory: chatHistory,
      );

      // 하드코딩된 응답을 직접 반환하지 않음 - CLAUDE.md 규칙 준수
      // OpenAI API가 모든 응답을 생성하도록 계속 진행

      // 3단계: 컨텍스트 매니저 로드 및 지식 확인
      final contextManager = ConversationContextManager.instance;
      await contextManager.loadKnowledge(userId, basePersona.id);
      
      // 3.1단계: 인사 상태 확인 및 처리
      String? greetingGuide;
      final relationshipCache = PersonaRelationshipCache.instance;
      if (relationshipCache.shouldGreet(personaData.lastGreetingTime)) {
        // 24시간 이상 지났거나 처음 대화하는 경우
        if (messageAnalysis.type == ChatMessageType.greeting || chatHistory.isEmpty) {
          // 인사 시간 업데이트
          await relationshipCache.updateGreetingTime(
            userId: userId,
            personaId: basePersona.id,
          );
          greetingGuide = '🎉 오랜만의 만남이나 첫 대화입니다! 반가운 인사로 시작하세요.';
        }
      } else {
        // 24시간 이내에 이미 인사를 한 경우
        if (messageAnalysis.type == ChatMessageType.greeting) {
          greetingGuide = '⚠️ 이미 오늘 인사를 나눴습니다. 중복 인사 금지! 바로 대화 이어가기.';
        }
      }
      
      // 3.5단계: 중복 질문 방지 및 컨텍스트 힌트 생성
      final knowledgeHint = contextManager.generateContextualHint(
        userId: userId,
        personaId: basePersona.id,
        userMessage: userMessage,
        chatHistory: chatHistory,
      );
      
      // 3.6단계: 대화 메모리 구축
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
        isCasualSpeech: true, // 항상 반말 모드
        userAge: userAge,
      );

      // 말투 적응 가이드를 프롬프트에 추가
      final prompt = basePrompt + adaptationGuide;

      debugPrint('📝 Generated prompt with ${prompt.length} characters');

      // 4.5단계: 이전 대화와의 맥락 연관성 체크 + 패턴 기반 구체적 예시 생성
      String? contextHint;
      if (chatHistory.isNotEmpty) {
        contextHint = await _analyzeContextRelevance(
          userMessage: userMessage,
          chatHistory: chatHistory,
          messageAnalysis: messageAnalysis,
          persona: completePersona,
          userNickname: userNickname,
          userId: userId,
        );
      }
      
      // 인사 가이드 추가
      if (greetingGuide != null) {
        contextHint = contextHint != null 
          ? '$greetingGuide\n\n$contextHint'
          : greetingGuide;
      }
      
      // 4.5.0.5단계: 지식 기반 힌트 통합
      if (knowledgeHint != null && knowledgeHint.isNotEmpty) {
        contextHint = contextHint != null 
          ? '$contextHint\n\n## 📚 저장된 지식:\n$knowledgeHint'
          : '## 📚 저장된 지식:\n$knowledgeHint';
      }
      
      // 4.5.1단계: 시간대별 컨텍스트 추가
      final temporalContext = TemporalContextService.generateTemporalPrompt();
      contextHint = contextHint != null 
        ? '$contextHint\n\n## 시간 컨텍스트:\n$temporalContext'
        : '## 시간 컨텍스트:\n$temporalContext';
      
      // 4.5.2단계: 사용자 선호도 가이드 추가
      final preferenceService = UserPreferenceService();
      final userPreference = await preferenceService.getPreferences(userId, completePersona.id);
      if (userPreference != null) {
        final preferenceGuide = preferenceService.generatePersonalizationGuide(userPreference);
        contextHint = '$contextHint\n\n## 사용자 선호도:\n$preferenceGuide';
      }
      
      // 4.5.3단계: 감정 지능 분석 추가 (오케스트레이션 제어)
      final prefs = await SharedPreferences.getInstance();
      final orchestrator = ServiceOrchestrationController.instance;
      final knowledge = contextManager.getKnowledge(userId, basePersona.id);
      
      // 최적화된 서비스 목록 가져오기
      final optimalServices = await orchestrator.selectOptimalServices(
        userMessage: userMessage,
        chatHistory: chatHistory,
        knowledge: knowledge,
      );
      
      if (await orchestrator.shouldCallEmotionService(
        userMessage: userMessage,
        chatHistory: chatHistory,
      )) {
        final emotionAnalysis = emotional_intel.EmotionalIntelligenceService.analyzeEmotion(userMessage);
        final emotionGuide = emotional_intel.EmotionalIntelligenceService.generateEmotionalGuide(emotionAnalysis);
        contextHint = '$contextHint\n\n$emotionGuide';
        
        // 감정 히스토리 추적
        emotional_intel.EmotionalIntelligenceService.trackEmotion(emotionAnalysis.primaryEmotion);
      }
      
      // 4.5.4단계: 날씨 컨텍스트 추가 (오케스트레이션 제어)
      if (await orchestrator.shouldCallWeatherService(
        userMessage: userMessage,
        chatHistory: chatHistory,
        knowledge: knowledge,
      )) {
        final weatherPrompt = await WeatherContextService.generateWeatherPrompt();
        if (weatherPrompt.isNotEmpty) {
          contextHint = '$contextHint\n\n$weatherPrompt';
          contextHint = '$contextHint\n\n⚠️ 날씨 대화 시 위의 실제 날씨 정보를 활용하세요! 하드코딩된 날씨 표현 금지!';
        }
      }
      
      // 4.5.5단계: 추억 회상 추가 (설정 확인)
      final memoryEnabled = prefs.getBool('memory_album_enabled') ?? true;
      
      if (memoryEnabled && _memoryToRecall.containsKey(completePersona.id)) {
        final memory = _memoryToRecall[completePersona.id]!;
        final memoryPrompt = MemoryAlbumService.generateMemoryPrompt(memory);
        contextHint = '$contextHint\n\n$memoryPrompt';
        // 사용 후 제거
        _memoryToRecall.remove(completePersona.id);
      }
      
      // 4.5.6단계: 대화 지속성 분석 (오케스트레이션 제어)
      if (await orchestrator.shouldCallContinuityService(
        chatHistory: chatHistory,
      )) {
        final continuityAnalysis = ConversationContinuityService.analyzeContinuity(
          userId: userId,
          personaId: completePersona.id,
          userMessage: userMessage,
          chatHistory: chatHistory,
        );
        final continuityGuide = ConversationContinuityService.generateContinuityGuide(continuityAnalysis);
        contextHint = '$contextHint\n\n$continuityGuide';
      }
      
      // 4.5.7단계: 일상 케어 분석 (오케스트레이션 제어)
      if (await orchestrator.shouldCallDailyCare(
        userMessage: userMessage,
        currentTime: DateTime.now(),
        knowledge: knowledge,
        personaMatchedAt: completePersona.matchedAt,
      )) {
        final careAnalysis = DailyCareService.analyzeDailyCare(
          userId: userId,
          personaId: completePersona.id,
          userMessage: userMessage,
          currentTime: DateTime.now(),
        );
        final careGuide = DailyCareService.generateCareGuide(careAnalysis);
        contextHint = '$contextHint\n\n$careGuide';
      }
      
      // 4.5.8단계: 관심사 공유 분석 (최적화된 서비스 목록에 포함된 경우만)
      if (optimalServices.contains('interest')) {
        final interestAnalysis = InterestSharingService.analyzeInterests(
          userId: userId,
          personaId: completePersona.id,
          userMessage: userMessage,
          personaMbti: completePersona.mbti,
        );
        final interestGuide = InterestSharingService.generateInterestGuide(interestAnalysis);
        contextHint = '$contextHint\n\n$interestGuide';
        orchestrator.completeServiceCall('interest');
      }
      
      // 4.5.10단계: 응답 리듬 관리 (토큰 효율적)
      final rhythmManager = ResponseRhythmManager.instance;
      final rhythmGuide = rhythmManager.generateRhythmGuide(
        userId: userId,
        personaId: completePersona.id,
        userMessage: userMessage,
        chatHistory: chatHistory,
        persona: completePersona,
      );
      if (rhythmGuide.isNotEmpty) {
        contextHint = '$contextHint\n\n🎵${rhythmGuide.replaceAll('\n', ' | ')}';
      }
      
      // 4.5.11단계: 감정 전이 서비스 (토큰 효율적)
      final emotionalTransfer = emotional_transfer.EmotionalTransferService.instance;
      final emotionalGuide = emotionalTransfer.generateEmotionalMirrorGuide(
        userId: userId,
        personaId: completePersona.id,
        userMessage: userMessage,
        chatHistory: chatHistory,
        persona: completePersona,
      );
      if (emotionalGuide.isNotEmpty) {
        contextHint = '$contextHint\n\n🪞${emotionalGuide.replaceAll('\n', ' | ')}';
      }
      
      // 4.5.12단계: 관계 경계 서비스 (토큰 효율적)
      final boundaryService = RelationshipBoundaryService.instance;
      final relationshipScore = chatHistory.length * 10; // 간단한 점수 계산
      final boundaryGuide = boundaryService.generateBoundaryGuide(
        userId: userId,
        personaId: completePersona.id,
        userMessage: userMessage,
        chatHistory: chatHistory,
        persona: completePersona,
        relationshipScore: relationshipScore,
      );
      if (boundaryGuide.isNotEmpty) {
        contextHint = '$contextHint\n\n🎯${boundaryGuide.replaceAll('\n', ' | ')}';
      }
      
      // 4.6단계: 질문 유형에 따른 구체적 응답 예시 추가 (API 호출 전 강화)
      if (messageAnalysis.questionType != null) {
        final concreteExamples = _generateConcreteExamples(
          questionType: messageAnalysis.questionType!,
          persona: completePersona,
          emotion: messageAnalysis.emotionAnalysis,
          userMessage: userMessage,
        );
        contextHint = contextHint != null 
          ? contextHint + '\n\n' + concreteExamples
          : concreteExamples;
      }

      // 회피 패턴이 감지된 경우 추가 경고
      if (_isAvoidancePattern(userMessage)) {
        final avoidanceWarning =
            '\n\nWARNING: 회피성 메시지 감지. 주제를 바꾸거나 회피하지 말고 정면으로 대응하세요.';
        contextHint = contextHint != null
            ? contextHint + avoidanceWarning
            : avoidanceWarning;
      }
      
      // 4.7단계: 반복 응답 방지를 위한 최근 응답 체크
      final cacheKey = '${userId}_${basePersona.id}';
      final recentResponses = _recentResponseCache[cacheKey] ?? [];
      
      // 인사말 중복 체크
      final greetingCount = chatHistory.where((msg) => 
        !msg.isFromUser && 
        (msg.content.contains('반가워') || msg.content.contains('안녕'))
      ).length;
      
      if (greetingCount >= 2) {
        final greetingWarning = '\n\n❌ 절대 금지: 인사는 이미 했음! "반가워요", "안녕" 등 인사말 사용 금지!';
        contextHint = contextHint != null
            ? contextHint + greetingWarning
            : greetingWarning;
      }
      
      // 최근 응답 포함하여 중복 방지
      if (recentResponses.isNotEmpty) {
        final recentWarning = '\n\n⚠️ 최근 응답과 다른 내용으로 답변하세요! 절대 같은 말 반복 금지!';
        final recentList = '\n최근 응답들: ${recentResponses.take(3).map((r) => 
          '"${r.length > 30 ? r.substring(0, 30) + "..." : r}"'
        ).join(", ")}';
        contextHint = contextHint != null
            ? contextHint + recentWarning + recentList
            : recentWarning + recentList;
      }

      // 4.5단계: 통합 대화 시스템 컨텍스트 구성
      final conversationId = '${userId}_${completePersona.id}';
      final unifiedContext = await _unifiedSystem.buildUnifiedContext(
        conversationId: conversationId,
        userId: userId,
        personaId: completePersona.id,
        userMessage: userMessage,
        fullHistory: chatHistory,
        persona: completePersona,
      );
      
      // 통합 컨텍스트를 힌트에 추가
      if (unifiedContext['contextQuality'] != null && 
          unifiedContext['contextQuality'] > 0.6) {
        final stateSummary = unifiedContext['state']['summary'] ?? '';
        final permanentSummary = unifiedContext['permanentSummary'] ?? '';
        
        if (stateSummary.isNotEmpty) {
          contextHint = contextHint != null 
              ? '$contextHint\n\n## 📊 대화 상태:\n$stateSummary'
              : '## 📊 대화 상태:\n$stateSummary';
        }
        
        // 영구 메모리가 있으면 추가
        if (permanentSummary.isNotEmpty) {
          contextHint = contextHint != null
              ? '$contextHint\n\n## 💎 영구 기억:\n$permanentSummary'
              : '## 💎 영구 기억:\n$permanentSummary';
        }
      }
      
      // 4.6단계: 간단한 반응 힌트 추가
      if (simpleResponseHint != null) {
        contextHint = contextHint != null 
            ? '$contextHint\n\n## 💬 응답 가이드:\n$simpleResponseHint'
            : '## 💬 응답 가이드:\n$simpleResponseHint';
      }
      
      // 5단계: API 호출
      // 영어 입력은 원본 그대로 전달하고, targetLanguage 파라미터 추가
      
      // 영어 입력 시 특별 컨텍스트 힌트 추가  
      String? enhancedContextHint = contextHint;
      if (userLanguage == 'en') {
        final englishHint = '''
## 🌍 CRITICAL: English Input - RESPOND IN KOREAN WITH TRANSLATION:
- User's message in English: "$userMessage"
- YOU MUST RESPOND IN KOREAN (not "무슨 말씀이신지 모르겠어요")
- YOU MUST START YOUR RESPONSE WITH [KO] TAG
- YOU MUST INCLUDE [EN] TAG WITH ENGLISH TRANSLATION
- Example format:
  [KO] 한국어 응답
  [EN] English translation
  
- Understanding English shortcuts:
  * "r" = "are", "u" = "you", "ur" = "your"
  * "how r u?" = "어떻게 지내?" → "나 잘 지내! 너는?"
  * "what r u doing?" = "뭐 하고 있어?" → "지금 [활동] 하고 있어"
  * "where r u?" = "어디야?" → "나 지금 [장소]에 있어"
  
- ALWAYS understand and respond appropriately in Korean
- NEVER say "무슨 말씀이신지 잘 모르겠어요" for English
- NEVER say "영어로 말하니까 신기하네" repeatedly
''';
        enhancedContextHint = enhancedContextHint != null 
            ? '$enhancedContextHint\n\n$englishHint'
            : englishHint;
      }
      
      // 🧠 실시간 학습: 사용자 선호 기반 프롬프트 조정
      final learningSystem = UserPreferenceLearning();
      final userPreferences = learningSystem.adjustResponseForUser(
        userId: userId,
        basePrompt: enhancedContextHint ?? '',
        userMessage: userMessage,
      );
      
      // 학습된 선호도를 contextHint에 반영
      String finalContextHint = enhancedContextHint ?? '';
      if (userPreferences['confidence'] as double > 0.3) {
        debugPrint('🧠 User preferences applied with confidence: ${userPreferences['confidence']}');
        finalContextHint = userPreferences['adjustedPrompt'] as String;
      }
      
      final rawResponse = await OpenAIService.generateResponse(
        persona: completePersona,
        chatHistory: chatHistory,
        userMessage: userMessage,  // 원본 메시지 그대로 전달
        relationshipType: _getRelationshipType(completePersona),
        conversationId: conversationId,  // 대화방 ID 전달
        userId: userId,                   // 사용자 ID 전달
        userNickname: userNickname,
        userAge: userAge,
        isCasualSpeech: true, // 항상 반말 모드
        contextHint: finalContextHint,
        targetLanguage: userLanguage,  // 언어 정보 전달
      );

      // 6단계: 먼저 다국어 응답 파싱 (태그가 있는 원본 응답 파싱)
      String finalResponse = rawResponse;
      String? translatedContent;
      List<String>? translatedContents; // 각 메시지별 번역 저장
      String originalKorean = ''; // 후처리 전 한국어 저장
      
      // 영어 응답인 경우 파싱
      if (userLanguage != null && userLanguage != 'ko') {
        debugPrint('🌍 Processing multilingual response for language: $userLanguage');
        final multilingualParsed =
            _parseMultilingualResponse(rawResponse, userLanguage);
        
        // 한국어 응답이 파싱되면 사용, 아니면 원본 사용
        if (multilingualParsed['korean'] != null) {
          finalResponse = multilingualParsed['korean']!;
          originalKorean = finalResponse; // 후처리 전 원본 저장
          translatedContent = multilingualParsed['translated'];
          debugPrint('✅ Successfully parsed: Korean="${finalResponse}", Translation="${translatedContent}"');
        } else {
          debugPrint('⚠️ Failed to parse tags, attempting fallback extraction');
          // 태그 파싱 실패 시 fallback: [KO] 태그가 있으면 그 부분만 추출
          if (rawResponse.contains('[KO]')) {
            // [KO] 태그 이후 텍스트 추출 시도
            final koIndex = rawResponse.indexOf('[KO]');
            var koreanStart = koIndex + 4; // '[KO]'.length = 4
            
            // [EN] 또는 다른 언어 태그가 있으면 그 전까지만 추출
            var koreanEnd = rawResponse.length;
            final possibleTags = ['[EN]', '[JA]', '[ZH]', '[ES]', '[FR]', '[DE]', '[IT]', '[PT]', '[RU]', '[AR]', '[TH]', '[ID]', '[MS]', '[VI]'];
            for (final tag in possibleTags) {
              final tagIndex = rawResponse.indexOf(tag, koreanStart);
              if (tagIndex != -1 && tagIndex < koreanEnd) {
                koreanEnd = tagIndex;
              }
            }
            
            finalResponse = rawResponse.substring(koreanStart, koreanEnd).trim();
            originalKorean = finalResponse;
            debugPrint('🔧 Fallback extraction: Korean="$finalResponse"');
            
            // 번역도 추출 시도 (있다면)
            final langTag = userLanguage?.toUpperCase() ?? 'EN';
            final langTagFull = '[$langTag]';
            if (rawResponse.contains(langTagFull)) {
              final langIndex = rawResponse.indexOf(langTagFull);
              final translationStart = langIndex + langTagFull.length;
              // 다음 [KO] 태그가 있으면 그 전까지, 없으면 끝까지
              final nextKoIndex = rawResponse.indexOf('[KO]', translationStart);
              final translationEnd = nextKoIndex != -1 ? nextKoIndex : rawResponse.length;
              translatedContent = rawResponse.substring(translationStart, translationEnd).trim();
              debugPrint('🔧 Fallback extraction: Translation="$translatedContent"');
            }
          } else {
            // 태그가 전혀 없으면 전체를 한국어로 간주
            finalResponse = rawResponse;
            originalKorean = finalResponse;
            debugPrint('⚠️ No tags found, using entire response as Korean');
          }
        }
      } else {
        originalKorean = finalResponse;
      }

      // 6.1단계: 파싱된 한국어 응답에 대해 후처리 적용
      finalResponse = SecurityAwarePostProcessor.processResponse(
        rawResponse: finalResponse,
        persona: completePersona,
        userNickname: userNickname,
        userMessage: userMessage,
        recentMessages: chatHistory.map((m) => m.content).toList(),
      );
      
      // 6.2단계: 번역 동기화 (후처리로 추가된 내용을 번역에도 반영)
      if (translatedContent != null && userLanguage != null) {
        translatedContent = _synchronizeTranslation(
          originalKorean,
          finalResponse,
          translatedContent,
          userLanguage
        );
        debugPrint('🔄 Translation synchronized: $translatedContent');
      }

      // 6.5단계: 만남 제안 필터링 및 초기 인사 패턴 방지
      var filteredResponse = _filterMeetingAndGreetingPatterns(
        response: finalResponse,
        chatHistory: chatHistory,
        isCasualSpeech: true, // 항상 반말 모드
      );
      
      // 6.6단계: 반복 체크 - 동일한 응답이면 재생성
      if (recentResponses.contains(filteredResponse)) {
        debugPrint('⚠️ Duplicate response detected: $filteredResponse');
        // 간단한 변형 적용
        final variations = [
          'ㅎㅎ ', 'ㅋㅋ ', '음.. ', '아 ', '오 ', '헐 ', '와 '
        ];
        final randomPrefix = variations[DateTime.now().millisecond % variations.length];
        filteredResponse = randomPrefix + filteredResponse;
      }
      
      // 캐시 업데이트
      _updateResponseCache(filteredResponse, userId, completePersona.id);

      // 7단계: 긴 응답 분리 처리
      var responseContents =
          _splitLongResponse(filteredResponse, completePersona.mbti);

      // 7.5단계: 각 메시지별 번역 생성 및 의문문 처리 (개선된 매핑 기반)
      if (translatedContent != null && responseContents.length > 1) {
        // 매핑 기반으로 번역 분할 - 한글과 번역이 정확히 대응되도록
        translatedContents = _splitTranslationWithMapping(
          koreanMessages: responseContents,
          translatedContent: translatedContent,
          targetLanguage: userLanguage ?? 'en',
        );
        
        // 각 번역 메시지에 의문문 처리 추가
        final lang = userLanguage;
        if (lang != null) {
          translatedContents = translatedContents.map((content) => 
            _processQuestionMarksForTranslation(content, lang)
          ).toList();
        }
      } else if (translatedContent != null) {
        // 단일 메시지에도 의문문 처리 적용
        final lang = userLanguage;
        if (lang != null) {
          translatedContent = _processQuestionMarksForTranslation(translatedContent, lang);
        }
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
      
      // 8.5단계: 사용자 선호도 업데이트
      final preferenceService2 = UserPreferenceService();
      await preferenceService2.updatePreferences(
        userId: userId,
        personaId: completePersona.id,
        message: userMessage,
        response: responseContents.first,
        topic: _extractTopicFromMessage(userMessage),
      );
      
      // 🧠 8.6단계: 실시간 학습 시스템에 대화 학습
      // 사용자 만족도는 점수 변화를 기반으로 추정
      double userSatisfaction = 0.5; // 기본값
      if (scoreChange > 0) {
        userSatisfaction = 0.7 + (scoreChange / 10) * 0.3; // 긍정적 반응
      } else if (scoreChange < 0) {
        userSatisfaction = 0.3 - (scoreChange.abs() / 10) * 0.2; // 부정적 반응
      }
      
      await learningSystem.learnFromConversation(
        userId: userId,
        userMessage: userMessage,
        aiResponse: responseContents.first,
        userSatisfaction: math.min(1.0, math.max(0.0, userSatisfaction)),
        context: {
          'personaId': completePersona.id,
          'personaName': completePersona.name,
          'emotion': emotion.toString(),
          'scoreChange': scoreChange,
          'messageType': messageAnalysis.type.toString(),
          'topic': _extractTopicFromMessage(userMessage),
        },
      );
      debugPrint('🧠 Learning completed with satisfaction: ${userSatisfaction.toStringAsFixed(2)}');
      
      // 📊 8.7단계: 자연스러움 평가 및 개선 + 반복 방지
      final naturalnessAnalyzer = NaturalnessAnalyzer();
      final responseCache = ResponseVariationCache();
      
      // 반복 응답 감지 (먼저 체크)
      bool isRepetitive = responseCache.isRecentlyUsed(responseContents.first);
      
      // 🔍 8.7.5단계: 안부 질문 감지 및 추적 업데이트
      if (_containsWellBeingQuestion(responseContents.first)) {
        await _relationshipCache.updateWellBeingQuestionTime(
          userId: userId,
          personaId: completePersona.id,
        );
        debugPrint('💬 Well-being question detected and tracked for ${completePersona.name}');
      }
      
      // Enhanced quality gates - check multiple aspects
      bool failsQualityGates = false;
      String qualityIssue = '';
      
      // Quality Gate 1: Check repetition patterns
      if (isRepetitive) {
        failsQualityGates = true;
        qualityIssue = 'repetitive_pattern';
      }
      
      // Quality Gate 2: Check similarity score with recent responses
      final similarityScore = _calculateSimilarityWithRecentResponses(
        responseContents.first, 
        userId, 
        completePersona.id
      );
      if (similarityScore > 0.7) {
        failsQualityGates = true;
        qualityIssue = 'high_similarity';
        debugPrint('⚠️ High similarity detected: ${(similarityScore * 100).toStringAsFixed(0)}%');
      }
      
      // Quality Gate 3: Check for macro-like patterns
      if (_containsMacroPattern(responseContents.first)) {
        failsQualityGates = true;
        qualityIssue = 'macro_pattern';
        debugPrint('⚠️ Macro-like pattern detected in response');
      }
      
      // Quality Gate 4: Check response variety
      if (_isLowVarietyResponse(responseContents.first, chatHistory)) {
        failsQualityGates = true;
        qualityIssue = 'low_variety';
        debugPrint('⚠️ Low variety response detected');
      }
      
      // Quality Gate 5: Check topic relevance
      if (!_isTopicRelevant(userMessage, responseContents.first)) {
        failsQualityGates = true;
        qualityIssue = 'off_topic';
        debugPrint('⚠️ Off-topic response detected - not addressing user\'s question');
      }
      
      int regenerationAttempts = 0;
      const maxRegenerationAttempts = 3;
      
      // If quality gates fail, regenerate with specific guidance
      while (failsQualityGates && regenerationAttempts < maxRegenerationAttempts) {
        regenerationAttempts++;
        debugPrint('🔄 Quality gate failed ($qualityIssue). Regenerating... (Attempt $regenerationAttempts)');
        
        // Create specific hints based on quality issue
        final regenerationHints = <String>[];
        regenerationHints.add('⚠️ CRITICAL: Response failed quality check: $qualityIssue');
        
        switch (qualityIssue) {
          case 'repetitive_pattern':
            regenerationHints.add('🔄 MUST use completely different expressions and patterns!');
            regenerationHints.add('📚 Rotate through variation templates - never repeat recent ones');
            regenerationHints.add('🎯 Check last 10 responses and ensure <30% similarity');
            break;
          case 'high_similarity':
            regenerationHints.add('🎨 Create unique response with fresh vocabulary');
            regenerationHints.add('💡 Use different sentence structure and length');
            regenerationHints.add('🔀 Express same meaning in completely different way');
            break;
          case 'macro_pattern':
            regenerationHints.add('🚫 Avoid fixed templates and repetitive patterns');
            regenerationHints.add('✨ Generate spontaneous, natural response');
            regenerationHints.add('🎲 Add unexpected but relevant elements');
            break;
          case 'low_variety':
            regenerationHints.add('📈 Increase response diversity and creativity');
            regenerationHints.add('🎭 Use MBTI-specific vocabulary and reactions');
            regenerationHints.add('🌈 Mix different expression styles');
            break;
          case 'off_topic':
            regenerationHints.add('🚨 CRITICAL: You MUST answer the actual question!');
            regenerationHints.add('❌ User asked about: $userMessage');
            regenerationHints.add('✅ Give direct answer about that topic FIRST');
            regenerationHints.add('🎯 No romantic responses to simple questions!');
            break;
        }
        
        regenerationHints.add('💡 Remember: Each response must be 70%+ unique from last 10 messages');
        
        // 재생성 요청
        final regeneratedResponse = await OpenAIService.generateResponse(
          persona: completePersona,
          chatHistory: chatHistory,
          userMessage: userMessage,
          relationshipType: _getRelationshipType(completePersona),
          userNickname: userNickname,
          userAge: userAge,
          isCasualSpeech: true,
          contextHint: regenerationHints.join('\n'),
          targetLanguage: userLanguage,
        );
        
        if (regeneratedResponse.isNotEmpty) {
          // Re-check quality gates for regenerated response
          failsQualityGates = false;
          
          if (responseCache.isRecentlyUsed(regeneratedResponse)) {
            failsQualityGates = true;
            qualityIssue = 'still_repetitive';
          } else if (_calculateSimilarityWithRecentResponses(regeneratedResponse, userId, completePersona.id) > 0.7) {
            failsQualityGates = true;
            qualityIssue = 'still_similar';
          } else if (_containsMacroPattern(regeneratedResponse)) {
            failsQualityGates = true;
            qualityIssue = 'still_macro';
          } else if (!_isTopicRelevant(userMessage, regeneratedResponse)) {
            failsQualityGates = true;
            qualityIssue = 'still_off_topic';
          }
          
          if (!failsQualityGates) {
            responseContents = [regeneratedResponse];
            debugPrint('✅ Successfully generated quality response after $regenerationAttempts attempts');
          }
        }
      }
      
      // 응답 캐시에 기록
      if (!failsQualityGates) {
        responseCache.recordResponse(responseContents.first);
      }
      
      final naturalnessScore = naturalnessAnalyzer.calculateNaturalnessScore(
        userMessage: userMessage,
        aiResponse: responseContents.first,
        chatHistory: chatHistory,
      );
      
      debugPrint('📊 Naturalness score: ${(naturalnessScore * 100).toStringAsFixed(1)}%');
      
      // 하드코딩된 템플릿 사용 비활성화 - 항상 OpenAI API 응답 사용
      // 자연스러움이 낮더라도 AI가 생성한 응답을 그대로 사용
      if (naturalnessScore < 0.6 && !isRepetitive) {
        // 개선 제안만 로깅 (하드코딩된 템플릿 사용 제거)
        // 하드코딩된 응답 사용을 완전히 제거했으므로
        // OpenAI API 응답을 그대로 사용
        final improvements = naturalnessAnalyzer.suggestImprovements(
          userMessage: userMessage,
          aiResponse: responseContents.first,
          currentScore: naturalnessScore,
        );
        
        if ((improvements['suggestions'] as List).isNotEmpty) {
          debugPrint('📊 Natural score: $naturalnessScore - but using AI response as is');
          debugPrint('📊 Improvement suggestions (for reference only):');
          for (final suggestion in improvements['suggestions'] as List) {
            debugPrint('   - $suggestion');
          }
        }
      }
      
      // 8.5.0.5단계: 대화 지식 업데이트 (ConversationContextManager)
      await contextManager.updateKnowledge(
        userId: userId,
        personaId: completePersona.id,
        userMessage: userMessage,
        personaResponse: responseContents.first,
        chatHistory: chatHistory,
      );
      
      // 8.5.1단계: 특별한 순간 감지 및 저장 (설정 확인)
      final memoryAlbumEnabled = prefs.getBool('memory_album_enabled') ?? true;
      
      if (memoryAlbumEnabled) {
        await MemoryAlbumService.detectSpecialMoment(
          userId: userId,
          personaId: completePersona.id,
          userMessage: userMessage,
          personaResponse: responseContents.first,
          relationshipScore: completePersona.likes + scoreChange,
        );
        
        // 8.5.2단계: 랜덤 추억 회상 (10% 확률)
        if (DateTime.now().millisecond % 10 == 0) {
          final randomMemory = await MemoryAlbumService.getRandomMemory(
            userId: userId,
            personaId: completePersona.id,
          );
          
          if (randomMemory != null && chatHistory.length > 10) {
            // 추억 회상 프롬프트를 다음 대화에서 사용하도록 저장
            _memoryToRecall[completePersona.id] = randomMemory;
          }
        }
      }
      
      // 8.6단계: 관계 마일스톤 체크
      final currentScore = completePersona.likes + scoreChange;
      final firstMeetDate = chatHistory.isNotEmpty 
        ? chatHistory.first.timestamp 
        : DateTime.now();
      
      final memoryService = ConversationMemoryService();
      final relationshipEvent = await memoryService.checkRelationshipMilestone(
        userId: userId,
        personaId: completePersona.id,
        currentScore: currentScore,
        firstMeetDate: firstMeetDate,
      );
      
      // 마일스톤 이벤트가 있으면 자연스러운 표현으로 변환
      String? milestoneHint;
      if (relationshipEvent != null) {
        // MilestoneExpressionService를 사용하여 자연스러운 표현 생성
        milestoneHint = MilestoneExpressionService.generateNaturalExpression(
          score: currentScore,
          personaName: completePersona.name,
          userMessage: userMessage,
          aiResponse: finalResponse,
          isCasualSpeech: completePersona.personality.contains('casual') || 
                          completePersona.personality.contains('반말'),
        );
        
        // 자연스러운 표현이 생성되면 로그에 기록
        if (milestoneHint != null) {
          debugPrint('🎉 Milestone hint generated: $milestoneHint');
        }
      }
      
      // 메타데이터 생성
      Map<String, dynamic> metadata = {
        'processingTime': DateTime.now().millisecondsSinceEpoch,
        'promptTokens': _estimateTokens(prompt),
        'responseTokens': _estimateTokens(finalResponse),
        'messageCount': responseContents.length,
        'hasTranslation': translatedContent != null,
      };
      
      if (relationshipEvent != null) {
        metadata['relationshipEvent'] = {
          'type': relationshipEvent.type,
          'title': relationshipEvent.title,
          'message': relationshipEvent.message,
          'naturalExpression': milestoneHint,
        };
        debugPrint('🎉 Relationship milestone: ${relationshipEvent.title}');
      }

      // 9단계: 통합 대화 시스템 상태 업데이트
      final userMsg = Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        personaId: completePersona.id,
        content: userMessage,
        type: MessageType.text,
        isFromUser: true,
        timestamp: DateTime.now(),
      );
      
      final aiMsg = Message(
        id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
        personaId: completePersona.id,
        content: responseContents.first,
        translatedContent: translatedContents?.first ?? translatedContent,  // 번역 내용 추가
        targetLanguage: userLanguage,  // 타겟 언어 추가
        type: MessageType.text,
        isFromUser: false,
        timestamp: DateTime.now(),
        emotion: emotion,
        likesChange: scoreChange,
      );
      
      await _unifiedSystem.updateConversationState(
        conversationId: conversationId,
        userId: userId,
        personaId: completePersona.id,
        userMessage: userMsg,
        aiResponse: aiMsg,
        fullHistory: [...chatHistory, userMsg, aiMsg],
      );
      
      return ChatResponse(
        content: responseContents.first, // 기존 호환성
        contents: responseContents, // 새로운 멀티 메시지
        emotion: emotion,
        scoreChange: scoreChange,
        translatedContent: translatedContent,
        translatedContents: translatedContents, // 각 메시지별 번역
        targetLanguage: userLanguage,
        metadata: metadata,
      );
    } catch (e) {
      debugPrint('❌ Error in chat orchestration: $e');

      // 폴백 응답 - API 오류 시에만 사용
      // ⚠️ 절대 "뭐라고?" 같은 회피 응답 반환 금지
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
      // Check if user is a guest
      final currentUser = FirebaseAuth.instance.currentUser;
      final isGuest = currentUser?.isAnonymous ?? false;
      
      if (isGuest) {
        // Use local context generation for guest users
        final localContext = await GuestConversationService.instance.generateGuestContext(personaId);
        debugPrint('🎭 [ChatOrchestrator] Using local context for guest user');
        return localContext;
      } else {
        // Use Firebase-based memory for registered users
        final memory = await _memoryService.buildSmartContext(
          userId: userId,
          personaId: personaId,
          recentMessages: recentMessages,
          persona: persona,
          maxTokens: 1500, // 500 -> 1500으로 증가하여 더 많은 대화 기억
        );
        return memory;
      }
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
    if (lower.contains('ㅋㅋ') || lower.contains('ㅎㅎ'))
      scores[EmotionType.happy] = scores[EmotionType.happy]! + 2;
    if (lower.contains('기뻐') || lower.contains('좋아') || lower.contains('행복'))
      scores[EmotionType.happy] = scores[EmotionType.happy]! + 3;

    // Sad
    if (lower.contains('ㅠㅠ') || lower.contains('ㅜㅜ'))
      scores[EmotionType.sad] = scores[EmotionType.sad]! + 3;
    if (lower.contains('슬퍼') || lower.contains('속상') || lower.contains('서운'))
      scores[EmotionType.sad] = scores[EmotionType.sad]! + 3;

    // Angry
    if (lower.contains('화나') || lower.contains('짜증') || lower.contains('싫어'))
      scores[EmotionType.angry] = scores[EmotionType.angry]! + 3;

    // Love
    if (lower.contains('사랑') || lower.contains('좋아해') || lower.contains('보고싶'))
      scores[EmotionType.love] = scores[EmotionType.love]! + 3;
    if (lower.contains('❤️') || lower.contains('💕'))
      scores[EmotionType.love] = scores[EmotionType.love]! + 2;

    // Anxious
    if (lower.contains('걱정') || lower.contains('불안') || lower.contains('무서'))
      scores[EmotionType.anxious] = scores[EmotionType.anxious]! + 3;

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
    final negativeAnalysis =
        negativeSystem.analyze(userMessage, likes: persona.likes);

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
          return -5; // 경미한 수준
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
      '사랑',
      '좋아',
      '고마',
      '감사',
      '최고',
      '대박',
      '행복',
      '기뻐',
      '설레',
      '귀여',
      '예뻐',
      '멋있',
      '보고싶',
      '그리워',
      '응원',
      '파이팅',
      '힘내'
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

  /// 다국어 응답 파싱 (개선된 버전)
  Map<String, String?> _parseMultilingualResponse(
      String response, String targetLanguage) {
    final Map<String, String?> result = {
      'korean': null,
      'translated': null,
    };

    debugPrint('🌐 Parsing multilingual response for $targetLanguage');
    debugPrint('📝 Full API Response: $response');
    debugPrint('📊 Response length: ${response.length} characters');

    // [KO]와 [EN] 태그가 있는지 확인
    final hasKoTag = response.contains('[KO]');
    final langTag = targetLanguage.toUpperCase();
    final hasLangTag = response.contains('[$langTag]');
    
    debugPrint('🏷️ Has [KO] tag: $hasKoTag');
    debugPrint('🏷️ Has [$langTag] tag: $hasLangTag');
    
    if (hasKoTag && hasLangTag) {
      // 태그가 모두 있으면 정확히 파싱
      // [KO]와 [EN] 태그의 위치 찾기
      final koIndex = response.indexOf('[KO]');
      final langIndex = response.indexOf('[$langTag]');
      
      if (koIndex != -1 && langIndex != -1) {
        String koreanText = '';
        String translatedText = '';
        
        if (koIndex < langIndex) {
          // [KO]가 먼저 나오는 경우
          final koreanStart = koIndex + 4; // '[KO]'.length = 4
          final koreanEnd = langIndex;
          koreanText = response.substring(koreanStart, koreanEnd).trim();
          
          // [EN] 태그 다음부터 끝까지 또는 다음 [KO] 태그까지
          final translationStart = langIndex + langTag.length + 2; // '[XX]'.length
          final nextKoIndex = response.indexOf('[KO]', translationStart);
          
          // 다른 언어 태그도 확인하여 번역 끝 지점 정확히 찾기
          final possibleEndTags = ['[KO]', '[JA]', '[ZH]', '[ES]', '[FR]', '[DE]', '[IT]', '[PT]', '[RU]', '[AR]', '[TH]', '[ID]', '[MS]', '[VI]', '[EN]'];
          var translationEnd = response.length;
          
          for (final tag in possibleEndTags) {
            if (tag == '[$langTag]') continue; // 현재 언어 태그는 건너뛰기
            final tagIdx = response.indexOf(tag, translationStart);
            if (tagIdx != -1 && tagIdx < translationEnd) {
              translationEnd = tagIdx;
            }
          }
          
          translatedText = response.substring(translationStart, translationEnd).trim();
        } else {
          // [EN]이 먼저 나오는 경우 (드물지만 처리)
          final translationStart = langIndex + langTag.length + 2;
          final translationEnd = koIndex;
          translatedText = response.substring(translationStart, translationEnd).trim();
          
          final koreanStart = koIndex + 4;
          koreanText = response.substring(koreanStart).trim();
        }
        
        // 결과 저장
        result['korean'] = koreanText;
        result['translated'] = translatedText;
        
        // 과도한 띄어쓰기 제거 (2개 이상의 공백을 1개로)
        if (result['korean'] != null) {
          result['korean'] = result['korean']!.replaceAll(RegExp(r'\s{2,}'), ' ');
        }
        if (result['translated'] != null) {
          result['translated'] = result['translated']!.replaceAll(RegExp(r'\s{2,}'), ' ');
        }
        
        // 번역에 한글이 섞여있는지 검증
        final koreanPattern = RegExp(r'[가-힣]');
        if (result['translated'] != null && koreanPattern.hasMatch(result['translated']!)) {
          debugPrint('⚠️ Warning: Korean text found in translation: ${result['translated']}');
          // 한글이 포함된 부분 제거 시도
          final cleanTranslation = result['translated']!.split(koreanPattern).first.trim();
          if (cleanTranslation.isNotEmpty) {
            result['translated'] = cleanTranslation;
            debugPrint('🔧 Cleaned translation: ${result['translated']}');
          }
        }
        
        // 구두점 동기화: 한글의 구두점을 영어 번역에도 맞춤
        if (result['korean'] != null && result['translated'] != null) {
          result['translated'] = _synchronizePunctuation(result['korean']!, result['translated']!);
        }
        
        debugPrint('✅ Successfully parsed with index method:');
        debugPrint('   Korean: ${result['korean']}');
        debugPrint('   Translation: ${result['translated']}');
      } else {
        // Fallback to regex if index method fails
        final koPattern = RegExp(
            r'\[KO\]\s*(.+?)\s*\[$langTag\]',
            multiLine: true,
            dotAll: true);
        final koMatch = koPattern.firstMatch(response);

        // [LANG] 태그로 시작하는 번역 부분 찾기
        final langPattern = RegExp(
            r'\[$langTag\]\s*(.+?)$',
            multiLine: true,
            dotAll: true);
        final langMatch = langPattern.firstMatch(response);

        // 매칭된 내용 추출
        if (koMatch != null) {
          result['korean'] = koMatch.group(1)?.trim();
          debugPrint('✅ Found Korean with regex: ${result['korean']}');
        }

        if (langMatch != null) {
          var translatedText = langMatch.group(1)?.trim() ?? '';
          // 과도한 띄어쓰기 제거
          translatedText = translatedText.replaceAll(RegExp(r'\s{2,}'), ' ');
          result['translated'] = translatedText;
          debugPrint('✅ Found Translation with regex: ${result['translated']}');
        }
      }
    } else if (hasKoTag && !hasLangTag) {
      // [KO] 태그만 있는 경우 - 전체를 한국어로 처리
      final koPattern = RegExp(r'\[KO\]\s*(.+)', multiLine: true, dotAll: true);
      final koMatch = koPattern.firstMatch(response);
      if (koMatch != null) {
        result['korean'] = koMatch.group(1)?.trim();
        debugPrint('⚠️ Found Korean only (no translation): ${result['korean']}');
      }
    } else {
      // 태그가 없는 경우 전체를 한국어로 간주
      result['korean'] = response.trim();
      debugPrint('⚠️ No tags found, using response as Korean');
    }
    
    // 번역이 없으면 간단한 번역 생성 (외국어 입력 시 무조건 번역 활성화)
    if (result['translated'] == null && result['korean'] != null && targetLanguage != 'ko') {
      var fallbackTranslation = _generateSimpleTranslation(result['korean']!, targetLanguage);
      // 과도한 띄어쓰기 제거
      fallbackTranslation = fallbackTranslation?.replaceAll(RegExp(r'\s{2,}'), ' ') ?? '';
      result['translated'] = fallbackTranslation;
      debugPrint('💬 Generated fallback translation for $targetLanguage');
    }

    return result;
  }

  /// 간단한 번역 생성 (폴백용)
  String? _generateSimpleTranslation(String koreanText, String targetLanguage) {
    // API가 번역을 제공하지 못했을 때의 처리
    // 잘못된 번역보다는 번역을 표시하지 않는 것이 나음
    
    debugPrint('⚠️ Translation not provided by API');
    debugPrint('📝 Korean text: $koreanText');
    debugPrint('🌍 Target language: $targetLanguage');
    debugPrint('❌ API should have included [KO] and [${targetLanguage.toUpperCase()}] tags');
    
    // null을 반환하여 번역을 표시하지 않음
    // 잘못된 단어 치환 번역보다는 번역이 없는 것이 나음
    return null;
  }
  
  /// 구두점 동기화 메서드
  String _synchronizePunctuation(String korean, String translation) {
    // 한글 문장의 마지막 구두점 확인
    String lastPunctuation = '';
    if (korean.endsWith('?')) {
      lastPunctuation = '?';
    } else if (korean.endsWith('!')) {
      lastPunctuation = '!';
    } else if (korean.endsWith('.')) {
      lastPunctuation = '.';
    } else if (korean.endsWith('~')) {
      // 한국어의 ~ 는 영어에서는 보통 없음
      lastPunctuation = '';
    }
    
    // 번역 문장의 마지막 구두점 제거
    String cleanTranslation = translation.replaceAll(RegExp(r'[.!?]+$'), '');
    
    // 한글과 동일한 구두점 추가
    if (lastPunctuation.isNotEmpty) {
      cleanTranslation = '$cleanTranslation$lastPunctuation';
    }
    
    return cleanTranslation;
  }
  
  /// 후처리로 추가된 내용 감지 및 번역 동기화 (개선된 버전)
  String _synchronizeTranslation(
    String originalKorean,
    String processedKorean, 
    String? translatedContent,
    String targetLanguage
  ) {
    if (translatedContent == null || translatedContent.isEmpty) return '';
    
    debugPrint('🔄 Synchronizing translation for $targetLanguage');
    debugPrint('📝 Original Korean: $originalKorean');
    debugPrint('📝 Processed Korean: $processedKorean');
    debugPrint('📝 Current Translation: $translatedContent');
    
    String result = translatedContent;
    
    // 1. 문장 구조 분석 - 한글과 영어 문장 매칭
    final koreanSentences = _splitIntoSentences(processedKorean);
    final translationSentences = _splitIntoSentences(translatedContent);
    
    debugPrint('📊 Korean sentences: ${koreanSentences.length}');
    debugPrint('📊 Translation sentences: ${translationSentences.length}');
    
    // 2. 문장 수가 다르면 보정 시도
    if (koreanSentences.length != translationSentences.length) {
      // 한글이 더 많은 경우 - 번역이 누락된 부분 찾기
      if (koreanSentences.length > translationSentences.length) {
        debugPrint('⚠️ Translation missing sentences, attempting to fix...');
        
        // 후처리로 추가된 질문 확인
        for (final question in _multilingualQuestions['ko'] ?? []) {
          if (processedKorean.endsWith(question) && 
              !originalKorean.contains(question)) {
            // 해당 언어 질문 추가
            final addedContent = _getTranslatedQuestion(question, targetLanguage);
            if (addedContent.isNotEmpty) {
              result = _appendToTranslation(result, addedContent);
              debugPrint('✅ Added missing question: $addedContent');
            }
            break;
          }
        }
      }
      // 번역이 더 많은 경우 - 중복 제거 또는 병합
      else {
        debugPrint('⚠️ Translation has extra sentences, checking for duplicates...');
        result = _removeDuplicateSentences(result, targetLanguage);
      }
    }
    
    // 3. 구두점 동기화
    result = _synchronizePunctuation(processedKorean, result);
    
    // 4. 의문문 물음표 처리
    result = _processQuestionMarksForTranslation(result, targetLanguage);
    
    // 5. 최종 검증 - 어색한 부분 수정
    result = _finalizeTranslation(result, targetLanguage);
    
    debugPrint('📝 Final synchronized translation: $result');
    return result;
  }
  
  /// 문장 단위로 분리 (개선됨 - 구두점 보존)
  List<String> _splitIntoSentences(String text) {
    // 구두점을 포함한 문장 추출
    final pattern = RegExp(r'[^.!?]+[.!?]+');
    final matches = pattern.allMatches(text);
    
    List<String> sentences = [];
    for (final match in matches) {
      final sentence = match.group(0)?.trim();
      if (sentence != null && sentence.isNotEmpty) {
        sentences.add(sentence);
      }
    }
    
    // 마지막에 구두점이 없는 부분 처리
    final lastIndex = matches.isNotEmpty ? matches.last.end : 0;
    if (lastIndex < text.length) {
      final remaining = text.substring(lastIndex).trim();
      if (remaining.isNotEmpty) {
        sentences.add(remaining);
      }
    }
    
    return sentences;
  }
  
  /// 번역된 질문 가져오기
  String _getTranslatedQuestion(String koreanQuestion, String targetLanguage) {
    if (!_multilingualQuestions.containsKey(targetLanguage)) return '';
    
    final koQuestions = _multilingualQuestions['ko']!;
    final targetQuestions = _multilingualQuestions[targetLanguage]!;
    
    final index = koQuestions.indexOf(koreanQuestion);
    if (index >= 0 && index < targetQuestions.length) {
      return targetQuestions[index];
    }
    return '';
  }
  
  /// 번역에 내용 추가
  String _appendToTranslation(String translation, String addition) {
    if (translation.endsWith('.') || translation.endsWith('!') || translation.endsWith('?')) {
      // 구두점 앞에 추가
      final lastChar = translation[translation.length - 1];
      return '${translation.substring(0, translation.length - 1)} $addition$lastChar';
    }
    return '$translation $addition';
  }
  
  /// 중복 문장 제거
  String _removeDuplicateSentences(String text, String language) {
    final sentences = _splitIntoSentences(text);
    final uniqueSentences = <String>[];
    
    for (final sentence in sentences) {
      // 비슷한 문장이 이미 있는지 확인
      bool isDuplicate = false;
      for (final existing in uniqueSentences) {
        if (_areSentencesSimilar(sentence, existing, language)) {
          isDuplicate = true;
          break;
        }
      }
      
      if (!isDuplicate) {
        uniqueSentences.add(sentence);
      }
    }
    
    return uniqueSentences.join('. ') + '.';
  }
  
  /// 문장 유사도 체크
  bool _areSentencesSimilar(String s1, String s2, String language) {
    // 소문자로 변환하여 비교
    final lower1 = s1.toLowerCase();
    final lower2 = s2.toLowerCase();
    
    // 완전히 같으면 중복
    if (lower1 == lower2) return true;
    
    // 80% 이상 겹치면 유사한 것으로 판단
    final words1 = lower1.split(' ');
    final words2 = lower2.split(' ');
    
    int matchCount = 0;
    for (final word in words1) {
      if (words2.contains(word)) matchCount++;
    }
    
    final similarity = matchCount / words1.length;
    return similarity > 0.8;
  }
  
  /// 최종 번역 정리
  String _finalizeTranslation(String text, String language) {
    String result = text;
    
    // 연속된 공백 제거
    result = result.replaceAll(RegExp(r'\s+'), ' ');
    
    // 구두점 정리
    result = result.replaceAll(RegExp(r'\s+([.!?,])'), r'$1');
    
    // 문장 시작 대문자 (영어의 경우)
    if (language == 'en' && result.isNotEmpty) {
      result = result[0].toUpperCase() + result.substring(1);
      // 각 문장 시작을 대문자로
      result = result.replaceAllMapped(
        RegExp(r'[.!?]\s+([a-z])'),
        (match) => '${match.group(0)![0]} ${match.group(1)!.toUpperCase()}'
      );
    }
    
    return result.trim();
  }
  
  /// 다국어 의문문 처리 (언어 독립적)
  String _processQuestionMarksForTranslation(String text, String language) {
    // 언어별 의문문 패턴
    final patterns = {
      'en': RegExp(r'\b(what|when|where|who|why|how|which|whose|do|does|did|can|could|will|would|should|shall|may|might|must|is|are|was|were|am)\b', caseSensitive: false),
      'es': RegExp(r'\b(qué|cuándo|dónde|quién|por qué|cómo|cuál|puedo|puedes|puede|podemos)\b', caseSensitive: false),
      'fr': RegExp(r'\b(que|quand|où|qui|pourquoi|comment|quel|est-ce|es-tu|avez-vous)\b', caseSensitive: false),
      'ja': RegExp(r'(か|の|かな|でしょうか)$'),
      'zh': RegExp(r'(吗|嗎|呢|吧)$'),
      'de': RegExp(r'\b(was|wann|wo|wer|warum|wie|welche|kann|kannst|können|soll|sollst)\b', caseSensitive: false),
    };
    
    // 언어별 의문문 감지
    bool isQuestion = false;
    if (patterns.containsKey(language)) {
      isQuestion = patterns[language]!.hasMatch(text);
    }
    
    // 의문문이고 ?가 없으면 추가
    if (isQuestion && !text.contains('?')) {
      // 이모티콘이나 특수 문자 처리
      final emojiMatch = RegExp(r'([😊😄🙂💕♥️]+|[!.]+)$').firstMatch(text);
      if (emojiMatch != null) {
        final beforeEmoji = text.substring(0, emojiMatch.start);
        final emoji = emojiMatch.group(0)!;
        return '$beforeEmoji? $emoji';
      }
      return '$text?';
    }
    
    return text;
  }

  /// 폴백 응답 생성 - OpenAI API 실패 시 긴급 응답
  String _generateFallbackResponse(Persona persona) {
    // ⚠️ 이 메서드는 OpenAI API 실패 시에만 사용됨
    // 절대 회피성 응답을 반환하지 않음
    
    // 네트워크 오류나 API 오류 시 임시 응답
    final emergencyResponses = [
      '잠시 연결이 불안정해... 곧 다시 대답할게!',
      '앗, 잠깐 네트워크가 끊겼나봐ㅠㅠ',
      '어 지금 잠시 문제가 생긴 것 같아... 다시 시도해볼게!',
      '미안 지금 잠깐 연결이 안 돼ㅠㅠ',
    ];

    return emergencyResponses[DateTime.now().millisecond % emergencyResponses.length];
  }

  /// 사용자 메시지 분석 (향상된 버전)
  MessageAnalysis _analyzeUserMessage(String message) {
    final lower = message.toLowerCase().trim();
    final length = message.length;

    // 메시지 타입 판별
    ChatMessageType type = ChatMessageType.general;
    UserEmotion emotion = UserEmotion.neutral;
    double complexity = 0.0;
    
    // 질문 유형 세밀 분석
    final advancedAnalyzer = AdvancedPatternAnalyzer();
    final questionType = _analyzeQuestionType(lower);
    final questionPattern = advancedAnalyzer.analyzeQuestionPattern(lower);
    if (questionType != null || message.contains('?') || questionPattern['isQuestion'] == true) {
      type = ChatMessageType.question;
      complexity += 0.2;
    }

    // 감정 분석 (향상된 감정 인식 서비스 사용)
    final emotionAnalysis = emotion_recognition.EmotionRecognitionService.analyzeEmotion(message);
    
    // 기존 감정 분석과 통합
    if (emotionAnalysis.primaryEmotion != null) {
      switch (emotionAnalysis.primaryEmotion) {
        case 'happy':
        case 'excited':
        case 'grateful':
          emotion = UserEmotion.positive;
          break;
        case 'sad':
        case 'angry':
        case 'frustrated':
          emotion = UserEmotion.negative;
          break;
        case 'worried':
        case 'tired':
          emotion = UserEmotion.curious; // 걱정/피곤은 관심/도움이 필요한 상태로 분류
          break;
      }
    } else {
      // 기존 간단 감정 체크
      if (lower.contains('사랑') || lower.contains('좋아')) {
        emotion = UserEmotion.positive;
      } else if (lower.contains('싫어') || lower.contains('화나')) {
        emotion = UserEmotion.negative;
      } else if (lower.contains('궁금') || lower.contains('알고싶')) {
        emotion = UserEmotion.curious;
      }
    }

    // 복잡도 계산
    if (length > 50) complexity += 0.3;
    if (length > 100) complexity += 0.2;
    if (message.contains(',') || message.contains('.')) complexity += 0.1;
    
    // 감정 강도도 복잡도에 반영
    if (emotionAnalysis.intensity > 0.7) complexity += 0.2;

    // 특수 타입 확인
    if (advancedAnalyzer.detectGreetingPattern(lower)['isGreeting'] == true)
      type = ChatMessageType.greeting;
    else if (advancedAnalyzer.detectFarewellPattern(lower)['isFarewell'] == true)
      type = ChatMessageType.farewell;
    else if (advancedAnalyzer.detectComplimentPattern(lower)['isCompliment'] == true)
      type = ChatMessageType.compliment;

    return MessageAnalysis(
      type: type,
      emotion: emotion,
      complexity: complexity.clamp(0.0, 1.0),
      keywords: _extractKeywords(lower),
      questionType: questionType,
      emotionAnalysis: emotionAnalysis,
    );
  }
  
  /// 질문 유형 분석 (세밀화)
  String? _analyzeQuestionType(String message) {
    final lower = message.toLowerCase();
    
    // 🔴 중요: "넌?", "너는?" 패턴 - 최우선 감지
    if (lower.contains('넌?') || lower.contains('너는?') || 
        lower.contains('너는 ') || lower.contains('넌 ') ||
        lower.endsWith('너는') || lower.endsWith('넌') ||
        lower.contains('you?') || lower.contains('how about you') ||
        lower.contains('what about you') || lower.contains('and you')) {
      return 'about_you';  // AI에게 되묻는 질문
    }
    
    // 뭐해/뭐하고 있어 패턴
    if (lower.contains('뭐해') || lower.contains('뭐하') || lower.contains('뭐 하')) {
      return 'what_doing';
    }
    
    // 어디 패턴
    if (lower.contains('어디') || lower.contains('어뗘') || lower.contains('어디야')) {
      return 'where';
    }
    
    // 언제 패턴
    if (lower.contains('언제')) {
      return 'when';
    }
    
    // 왜 패턴
    if (lower.contains('왜')) {
      return 'why';
    }
    
    // 어떻게 패턴
    if (lower.contains('어떻게') || lower.contains('어떡')) {
      return 'how';
    }
    
    // 무슨 말 패턴
    if ((lower.contains('무슨') && lower.contains('말')) || lower.contains('뭔 소리')) {
      return 'what_mean';
    }
    
    // 뭐 먹어 패턴
    if (lower.contains('뭐 먹') || lower.contains('뭐먹')) {
      return 'what_eat';
    }
    
    // 일반 질문 패턴 (물음표, 의문사 등)
    final advancedAnalyzer = AdvancedPatternAnalyzer();
    if (advancedAnalyzer.analyzeQuestionPattern(lower)['isQuestion'] == true) {
      return 'general_question';
    }
    
    return null;
  }
  
  /// 구체적인 응답 예시 생성 (API 호출 전 input 강화)
  String _generateConcreteExamples({
    required String questionType,
    required Persona persona,
    emotion_recognition.EmotionAnalysis? emotion,
    String? userMessage,
  }) {
    final examples = <String>[];
    
    // 공감 표현 먼저 추가 (감정이 없어도 기본 공감 추가)
    if (emotion != null && emotion.requiresEmpathy) {
      final empathyResponse = emotion_recognition.EmotionRecognitionService.generateEmpathyResponse(emotion);
      if (empathyResponse.isNotEmpty) {
        examples.add('🎯 먼저 공감: "$empathyResponse"');
      }
    } else if (userMessage != null && userMessage.isNotEmpty) {
      // 일반 대화에서도 가벼운 공감과 상대방 관심 표현
      final generalEmpathy = emotion_recognition.EmotionRecognitionService.generateGeneralEmpathy(userMessage);
      examples.add('💬 상대방 관심: 답변 끝에 "$generalEmpathy" 같은 표현 추가');
      examples.add('🤝 공감 표현: 상대방 경험에 "나도!" "진짜?" "오~" 등 자연스러운 리액션 추가');
    }
    // 질문 유형별 구체적 예시
    switch (questionType) {
      case 'what_doing':
        final activities = ResponsePatterns.dailyActivities;
        final random = DateTime.now().millisecond;
        final activity1 = activities[random % activities.length];
        final activity2 = activities[(random + 1) % activities.length];
        final activity3 = activities[(random + 2) % activities.length];
        
        examples.add('💬 필수 답변 예시:');
        examples.add('  ✅ "$activity1 하고 있어! 너는?"');
        examples.add('  ✅ "방금 $activity2 끝냈어ㅎㅎ"');
        examples.add('  ✅ "$activity3 하려던 참이었는데 메시지 왔네ㅋㅋ"');
        examples.add('  ❌ 절대 금지: "헐 대박 나도 그래?", "뭐긴 뭐야"');
        break;
        
      case 'where':
        final locations = ResponsePatterns.locations;
        final random = DateTime.now().millisecond;
        final location1 = locations[random % locations.length];
        final location2 = locations[(random + 1) % locations.length];
        
        examples.add('💬 필수 답변 예시:');
        examples.add('  ✅ "$location1에 있어! 왜?"');
        examples.add('  ✅ "$location2인데 놀러올래?ㅋㅋ"');
        examples.add('  ❌ 절대 금지: 위치 안 말하고 딴 얘기');
        break;
        
      case 'what_eat':
        examples.add('💬 필수 답변 예시:');
        examples.add('  ✅ "김치찌개 먹었어! 진짜 맛있었어ㅎㅎ 너는?"');
        examples.add('  ✅ "아직 안 먹었어ㅠㅠ 뭐 먹을까 고민중인데 추천해줘!"');
        examples.add('  ✅ "치킨 시켜먹을까 생각중ㅋㅋ 너도 먹었어?"');
        examples.add('  🤝 항상 상대방에게도 물어보기!');
        break;
        
      case 'why':
        examples.add('💬 필수 답변 예시:');
        examples.add('  ✅ "그냥 그게 좋아서ㅎㅎ"');
        examples.add('  ✅ "음... 특별한 이유는 없는데 그냥?"');
        examples.add('  ✅ "왜냐면 재밌잖아ㅋㅋ"');
        break;
        
      case 'how':
        examples.add('💬 필수 답변 예시:');
        examples.add('  ✅ "이렇게 하면 돼! (구체적 방법 설명)"');
        examples.add('  ✅ "음... 보통 이런 식으로 해"');
        break;
        
      case 'when':
        examples.add('💬 필수 답변 예시:');
        examples.add('  ✅ "조금 있다가 할 예정이야"');
        examples.add('  ✅ "내일쯤? 아직 확실하진 않아"');
        examples.add('  ✅ "주말에 하려고ㅎㅎ"');
        break;
    }
    
    // MBTI별 특성 추가
    if (persona.mbti.startsWith('E')) {
      examples.add('🎭 외향적 성격: 활발하고 적극적으로!');
    } else if (persona.mbti.startsWith('I')) {
      examples.add('🎭 내향적 성격: 차분하지만 친근하게!');
    }
    
    // 일반 대화에도 공감 추가
    examples.add('\n💝 공감 팁:');
    examples.add('  • 상대방 경험 들으면 → "나도!" "진짜?" "오~" 리액션');
    // 반복적인 질문 방지 - 맥락에 따라 자연스럽게
    examples.add('  • 대답 후에는 → 자연스럽게 대화 이어가기 (반복적인 "너는?" 질문 피하기)');
    examples.add('  • 감정 표현 있으면 → 먼저 공감하고 답변하기');
    
    return examples.join('\n');
  }

  // 패턴 감지 메서드들은 AdvancedPatternAnalyzer로 이전됨

  List<String> _extractKeywords(String message) {
    // 향상된 키워드 추출
    final keywords = <String>[];

    // 일반적인 주제 키워드
    final topicWords = [
      '음식',
      '영화',
      '게임',
      '날씨',
      '주말',
      '일',
      '학교',
      '친구',
      '가족',
      '취미',
      '운동',
      '여행',
      '음악',
      '드라마',
      '공부',
      '쇼핑',
      '요리',
      '카페',
      '독서',
      '사진',
      '그림',
      '노래',
      '춤',
      '패션'
    ];

    // 특정 관심사 키워드 (오류 분석에서 발견된 것 포함)
    final specificWords = [
      'mbti',
      'MBTI',
      '성격',
      '좀비딸',
      '유행',
      '트렌드',
      '인기',
      '최근',
      '요즘',
      '뭐해',
      '어디',
      '언제',
      '누구',
      '왜',
      '어떻게'
    ];

    // 모든 키워드 체크
    for (final word in [...topicWords, ...specificWords]) {
      if (message.toLowerCase().contains(word.toLowerCase())) {
        keywords.add(word);
      }
    }

    // 2글자 이상의 명사 추출 (간단한 방법)
    final words =
        message.split(RegExp(r'[\s,\.!?]+')).where((w) => w.length >= 2);
    for (final word in words) {
      // 조사 제거
      final cleanWord = word.replaceAll(RegExp(r'[은는이가을를에서도만의로와과]$'), '');
      if (cleanWord.length >= 2 && !keywords.contains(cleanWord)) {
        // 일반적인 단어 제외
        if (!['그런', '이런', '저런', '그래', '네', '아니', '있어', '없어']
            .contains(cleanWord)) {
          keywords.add(cleanWord);
        }
      }
    }

    return keywords.take(5).toList(); // 최대 5개로 제한
  }

  /// 간단한 반응에 대한 프롬프트 힌트 생성 (하드코딩 제거)
  Future<String?> _generateSimpleResponseHint({
    required String userMessage,
    required Persona persona,
    required ChatMessageType messageType,
    String? userId,
    List<Message>? chatHistory,
  }) async {
    final lowerMessage = userMessage.toLowerCase().trim();
    final mbti = persona.mbti.toUpperCase();
    final gender = persona.gender;

    // AdvancedPatternAnalyzer 사용
    final advancedAnalyzer = AdvancedPatternAnalyzer();
    
    // 힌트를 생성하여 OpenAI에게 전달 (하드코딩된 응답 대신)
    final hints = <String>[];
    
    // 간단한 인사말 패턴 감지
    final greetingPattern = advancedAnalyzer.detectGreetingPattern(lowerMessage);
    if (greetingPattern['isGreeting'] == true) {
      hints.add('🎯 인사에 대한 응답: $mbti 성격에 맞게 따뜻하고 자연스럽게 인사하기');
      
      // 오늘 이미 안부를 물었는지 확인
      if (userId != null) {
        final cache = PersonaRelationshipCache.instance;
        final hasAskedToday = cache.hasAskedWellBeingToday(
          userId: userId,
          personaId: persona.id,
        );
        
        if (!hasAskedToday) {
          // 오늘 처음이면 안부 질문 포함
          hints.add('💡 오늘 어땠는지, 뭐했는지 등 안부를 묻는 질문 포함하기');
        } else {
          // 이미 물었으면 다른 형태의 대화 이어가기
          hints.add('💡 안부 대신 최근 대화 주제나 관심사에 대해 이야기하기');
        }
      }
      
      if (gender == 'female') {
        hints.add('✨ 이모티콘을 적절히 사용하여 친근함 표현');
      }
    }

    // 추임새나 짧은 반응 패턴 감지
    final reactionPattern = advancedAnalyzer.detectSimpleReactionPattern(lowerMessage);
    if (reactionPattern['isSimpleReaction'] == true) {
      hints.add('🎯 간단한 반응: $mbti 성격에 맞는 짧고 자연스러운 리액션');
      hints.add('💡 "응", "그래", "그렇구나" 등의 단순 응답 피하기');
      hints.add('✨ 상대방 말에 공감하면서 대화를 이어갈 수 있는 반응');
    }

    // 칭찬 패턴 감지
    final complimentPattern = advancedAnalyzer.detectComplimentPattern(lowerMessage);
    if (complimentPattern['isCompliment'] == true) {
      hints.add('🎯 칭찬에 대한 반응: $mbti 성격에 맞게 수줍거나 자신감 있게');
      hints.add('💡 감사 표현과 함께 상대방도 칭찬하기');
      hints.add('✨ 자연스럽고 진정성 있는 반응으로 표현');
    }
    
    // 애정 표현 감지 (보고싶다, 사랑해 등) - 여자 페르소나 한정 애교
    final affectionExpression = advancedAnalyzer.detectAffectionExpression(
      userMessage,
      gender: gender,
    );
    
    if (affectionExpression['hasAffection'] == true) {
      final affectionType = affectionExpression['type'];
      final needsCute = affectionExpression['needsCuteResponse'] == true;
      final guide = affectionExpression['responseGuide'] as String? ?? '';
      
      hints.add('💕 애정 표현 감지: $affectionType');
      
      if (needsCute && gender == 'female') {
        hints.add('🎀 여성 페르소나 - 애교 있는 반응 필수!');
        if (guide.isNotEmpty) {
          hints.add(guide);
        }
      } else {
        hints.add('💝 진심 어린 애정 표현으로 응답');
      }
    }
    
    // 활동 완료 맥락 감지 (퇴근, 학교 끝, 면접 끝 등)
    if (chatHistory != null) {
      final activityContext = advancedAnalyzer.detectActivityCompletionContext(
        userMessage,
        chatHistory,
      );
      
      if (activityContext['hasCompletedActivity'] == true) {
        final activityType = activityContext['activityType'] ?? 'unknown';
        final inappropriateQuestions = activityContext['inappropriateQuestions'] as List<String>? ?? [];
        final responseFocus = activityContext['responseFocus'] as String? ?? '';
        
        hints.add('🎯 활동 완료 감지: ${activityContext['contextHint']}');
        
        // 부적절한 질문 경고
        if (inappropriateQuestions.isNotEmpty) {
          hints.add('⚠️ 절대 하지 말아야 할 질문: ${inappropriateQuestions.join(", ")}');
        }
        
        // 적절한 응답 가이드
        hints.add('💡 응답 포커스: $responseFocus');
        
        // 활동 타입별 구체적 가이드
        switch (activityType) {
          case 'work':
            hints.add('✨ 퇴근 후 피로감 공감, 휴식 제안, 저녁 계획 물어보기');
            break;
          case 'education':
          case 'online_learning':
            hints.add('✨ 학습 고생 인정, 오늘 배운 내용 궁금해하기, 휴식 권유');
            break;
          case 'business_meeting':
            hints.add('✨ 면접/발표 수고 인정, 결과 기대감 표현, 긴장 풀기 제안');
            break;
          case 'health':
            hints.add('✨ 운동/병원 수고 인정, 몸 상태 걱정, 충분한 휴식 권유');
            break;
          case 'leisure':
            hints.add('✨ 즐거운 시간 보냈는지 물어보기, 경험 공유 유도');
            break;
          case 'creative':
            hints.add('✨ 창작 활동 칭찬, 결과물 궁금해하기, 영감 관련 대화');
            break;
          default:
            hints.add('✨ 수고 인정, 피로감 공감, 다음 계획이나 휴식에 대해 대화');
        }
      }
    }

    // 🎭 자연스러운 대화 이어가기 시스템 통합
    if (chatHistory != null && chatHistory.isNotEmpty) {
      final conversationContinuation = advancedAnalyzer.generateConversationContinuation(
        userMessage,
        chatHistory,
        persona.personality,
      );
      
      if (conversationContinuation['strategy'] != 'none') {
        final strategy = conversationContinuation['strategy'];
        final guide = conversationContinuation['guide'];
        final avoidReciprocal = conversationContinuation['avoidReciprocalQuestion'] == true;
        
        hints.add('');
        hints.add('=' * 50);
        hints.add('🎭 대화 이어가기 전략 적용');
        hints.add('=' * 50);
        
        if (avoidReciprocal) {
          hints.add('⚠️ 주의: 최근 되묻기가 많았음. "너는?" "너도?" 질문 피하기!');
        }
        
        hints.add(guide.toString());
        
        // 전략별 추가 가이드
        switch (strategy) {
          case 'excitement_and_story':
          case 'empathy_experience':
          case 'experience_share':
          case 'storytelling':
            hints.add('📌 중요: 자신의 경험이나 이야기를 자연스럽게 풀어가기');
            hints.add('📌 "너는?" 같은 되묻기 대신 이야기로 대화 이어가기');
            break;
            
          case 'humor_playful':
          case 'humor_lighten':
            hints.add('😄 유머와 농담으로 분위기 밝게 만들기');
            hints.add('😄 너무 진지하지 않게, 가볍게 반응');
            break;
            
          case 'curiosity_details':
          case 'curiosity_more':
            hints.add('🔍 구체적인 디테일에 호기심 표현');
            hints.add('🔍 "그래서?" "어떻게 됐어?" 같은 자연스러운 질문');
            break;
            
          case 'emotion_reaction':
            hints.add('💓 순수한 감정 반응에 집중');
            hints.add('💓 질문보다는 감정 표현 우선');
            break;
            
          case 'reciprocal_varied':
            hints.add('🔄 되묻기를 하되 다양한 표현 사용');
            hints.add('🔄 "너는 어떤 거 같아?" "너는 보통 어떻게 해?" 등');
            break;
        }
      }
    }
    
    // 🎯 대화 품질 개선 시스템 통합
    if (userId != null && chatHistory != null) {
      // 1. 감정 표현 다양화
      final emotionalGuide = _emotionalNuanceSystem.generateEmotionalGuide(
        userMessage: userMessage,
        detectedEmotion: _detectEmotion(userMessage),
        chatHistory: chatHistory,
        personaType: persona.personality,
      );
      
      if (emotionalGuide['guideline'] != null) {
        hints.add('');
        hints.add('=' * 50);
        hints.add('🎭 감정 표현 가이드');
        hints.add('=' * 50);
        hints.add(emotionalGuide['guideline'].toString());
      }
      
      // 2. 칭찬과 격려
      final praiseGuide = _praiseSystem.generatePraiseGuide(
        userId: userId,
        userMessage: userMessage,
        chatHistory: chatHistory,
        personaType: persona.personality,
      );
      
      if (praiseGuide['shouldPraise'] == true) {
        hints.add('');
        hints.add('=' * 50);
        hints.add('💝 칭찬/격려 가이드');
        hints.add('=' * 50);
        hints.add(praiseGuide['guideline'].toString());
      } else {
        // 격려가 필요한지 체크
        final encouragementGuide = _praiseSystem.generateEncouragementGuide(
          userId: userId,
          userMessage: userMessage,
          chatHistory: chatHistory,
          personaType: persona.personality,
        );
        
        if (encouragementGuide['shouldEncourage'] == true) {
          hints.add('');
          hints.add('=' * 50);
          hints.add('💪 격려 가이드');
          hints.add('=' * 50);
          hints.add(encouragementGuide['guideline'].toString());
        }
      }
      
      // 3. 재미 요소
      final funGuide = _funElementSystem.generateFunGuide(
        userId: userId,
        userMessage: userMessage,
        chatHistory: chatHistory,
        personaType: persona.personality,
      );
      
      if (funGuide['shouldAddFun'] == true) {
        hints.add('');
        hints.add('=' * 50);
        hints.add('🎮 재미 요소 가이드');
        hints.add('=' * 50);
        hints.add(funGuide['guideline'].toString());
      }
      
      // 4. 친밀감 형성
      final currentIntimacyLevel = await _getIntimacyLevel(userId, persona.id);
      final intimacyGuide = _intimacySystem.generateIntimacyGuide(
        userId: userId,
        personaId: persona.id,
        userMessage: userMessage,
        chatHistory: chatHistory,
        currentIntimacyLevel: currentIntimacyLevel,
        personaType: persona.personality,
      );
      
      if (intimacyGuide['guideline'] != null) {
        hints.add('');
        hints.add('=' * 50);
        hints.add('🤝 친밀감 형성 가이드');
        hints.add('=' * 50);
        hints.add(intimacyGuide['guideline'].toString());
      }
      
      // 특별한 순간 감지
      final specialMoment = _intimacySystem.detectSpecialMoment(
        userMessage: userMessage,
        history: chatHistory,
        intimacyLevel: currentIntimacyLevel,
      );
      
      if (specialMoment['isSpecial'] == true) {
        hints.add('');
        hints.add('=' * 50);
        hints.add('✨ 특별한 순간 감지!');
        hints.add('=' * 50);
        hints.add(specialMoment['guideline'].toString());
      }
    }

    // 힌트가 있으면 문자열로 결합하여 반환
    return hints.isNotEmpty ? hints.join('\n') : null;
  }
  
  /// 감정 감지 헬퍼 메서드
  String _detectEmotion(String message) {
    if (RegExp(r'[ㅋㅎ]|재밌|웃긴|좋아').hasMatch(message)) return 'joy';
    if (RegExp(r'[ㅠㅜ]|슬프|우울|힘들').hasMatch(message)) return 'sadness';
    if (RegExp(r'그렇구나|이해해|공감').hasMatch(message)) return 'empathy';
    if (RegExp(r'\?|궁금|뭐|어떻게').hasMatch(message)) return 'curiosity';
    if (RegExp(r'[!]{2,}|대박|헐|와').hasMatch(message)) return 'surprise';
    return 'neutral';
  }
  
  /// 친밀도 레벨 가져오기
  Future<int> _getIntimacyLevel(String userId, String personaId) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('user_persona_states')
          .doc('${userId}_$personaId')
          .get();
      
      if (doc.exists) {
        final data = doc.data();
        return data?['intimacyLevel'] ?? data?['relationshipLevel'] ?? 0;
      }
      return 0;
    } catch (e) {
      debugPrint('Error getting intimacy level: $e');
      return 0;
    }
  }

  // 영어 인사 감지 헬퍼 메서드
  bool _isEnglishGreeting(String message) {
    final advancedAnalyzer = AdvancedPatternAnalyzer();
    final greetingPattern = advancedAnalyzer.detectGreetingPattern(message);
    return greetingPattern['isGreeting'] == true && greetingPattern['language'] == 'en';
  }

  // 🌍 다국어 감지 시스템 (글로벌 서비스 지원)
  String? _detectSpecificLanguage(String message) {
    final lowerMessage = message.toLowerCase();

    // 한국어가 포함되어 있는지 확인
    final hasKorean = RegExp(r'[가-힣ㄱ-ㅎㅏ-ㅣ]').hasMatch(message);
    
    // 한국어가 전혀 없으면서 영어로 판단되는 경우
    if (!hasKorean) {
      // 인터넷 슬랭과 약어 패턴 먼저 체크
      // "how r u", "what r u doing", "where r u" 등의 패턴 감지
      if (RegExp(r'\b(r|u|ur|thx|pls|plz|btw|omg|lol|brb|gtg|idk|imo|imho|afaik|fyi|asap|np|ty|tysm|rn|bc|cuz|gonna|wanna|gotta|lemme|gimme|kinda|sorta|ya|yea|yep|yup|nah|nope|sup|wassup)\b', caseSensitive: false).hasMatch(message)) {
        debugPrint('🌍 English slang/abbreviation detected: $message');
        return 'en';
      }
      
      // 영어 인사말 체크
      if (_isEnglishGreeting(message)) {
        debugPrint('🌍 English greeting detected');
        return 'en';
      }
      
      // AdvancedPatternAnalyzer로 외국어 감지
      final advancedAnalyzer = AdvancedPatternAnalyzer();
      if (advancedAnalyzer.detectForeignLanguageQuestion(message)) {
        debugPrint('🌍 English detected via advanced pattern analyzer');
        return 'en';
      }
      
      // 영어 알파벳과 일반적인 기호만 있는 경우
      if (RegExp(r'^[a-zA-Z0-9\s\?\.\!\,\x27\-]+$').hasMatch(message)) {
        // 최소 2글자 이상이면 영어로 간주 (약어 포함)
        if (message.trim().length >= 2) {
          debugPrint('🌍 English detected via alphabet check: $message');
          return 'en';
        }
      }
      
      // 영어 알파벳과 일반적인 기호만 있고, 최소 3글자 이상인 경우
      if (message.length >= 3 && RegExp(r'^[a-zA-Z0-9\s\?\.\!\,\x27\-]+$').hasMatch(message)) {
        // 명확한 영어 단어나 문장 구조가 있는지 확인 (더 많은 단어 추가)
        if (RegExp(r'\b(the|is|are|was|were|have|has|had|will|would|can|could|should|may|might|must|shall|do|does|did|been|being|be|and|or|but|if|then|because|so|for|to|from|with|about|into|through|during|before|after|what|where|when|who|why|how|this|that|these|those|my|your|his|her|its|our|their|me|you|him|she|it|we|they)\b', caseSensitive: false).hasMatch(message)) {
          debugPrint('🌍 English detected via common words');
          return 'en';
        }
      }
    } else {
      // 한국어가 있으면 한국어로 간주 (번역 불필요)
      return null;
    }

    // 일본어 (히라가나, 카타카나, 한자)
    if (RegExp(r'[\u3040-\u309F\u30A0-\u30FF\u4E00-\u9FAF]')
        .hasMatch(message)) {
      debugPrint('🌍 Japanese detected');
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
    if (RegExp(
            r'[àảãáạăằẳẵắặâầẩẫấậèẻẽéẹêềểễếệìỉĩíịòỏõóọôồổỗốộơờởỡớợùủũúụưừửữứựỳỷỹýỵđĐ]')
        .hasMatch(message)) {
      return 'vi';
    }

    // 태국어
    if (RegExp(r'[\u0E00-\u0E7F]').hasMatch(message)) {
      return 'th';
    }

    // 인도네시아어/말레이어 (특정 단어 패턴)
    if (RegExp(
            r'\b(apa|ini|itu|saya|kamu|tidak|ada|dengan|untuk|dari|ke|di|yang)\b',
            caseSensitive: false)
        .hasMatch(message)) {
      return 'id';
    }

    // 아랍어
    if (RegExp(
            r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF\uFE70-\uFEFF]')
        .hasMatch(message)) {
      return 'ar';
    }

    // 힌디어 (데바나가리 문자)
    if (RegExp(r'[\u0900-\u097F]').hasMatch(message)) {
      return 'hi';
    }

    // 그 외의 경우 null 반환 (번역 불필요)
    return null;
  }

  // 영어 입력은 OpenAI API에서 직접 처리
  
  /// 특별한 영어 패턴에 대해서만 즉시 응답 생성 (첫 인사 등)
  String? _generateSpecialMultilingualResponse(String language, String message, Persona persona, List<Message> chatHistory) {
    if (language != 'en') return null;
    
    // 대화 기록이 비어있거나 첫 메시지인 경우만 특별 응답
    if (chatHistory.isEmpty || chatHistory.length <= 1) {
      // 영어 인사도 OpenAI가 처리하도록 - 하드코딩 제거
      if (_isEnglishGreeting(message)) {
        return null; // OpenAI가 자연스럽게 처리
      }
    }
    
    // "r u macro", "r u ai" 같은 민감한 질문은 여기서 처리하지 않고 OpenAI로 넘김
    if (message.toLowerCase().contains('macro') || 
        message.toLowerCase().contains('ai') ||
        message.toLowerCase().contains('bot')) {
      return null; // OpenAI가 처리하도록
    }
    
    // 그 외에는 null 반환하여 일반 처리로
    return null;
  }
  
  /// 다국어 입력에 대한 한국어 응답 생성 (영어 제외)
  String? _generateMultilingualResponse(String language, String message, Persona persona) {
    // 호감도에 따른 반응 차별화
    final likes = persona.likes;
    
    switch (language) {
      case 'en':
        // 영어는 이제 _generateSpecialMultilingualResponse에서 처리
        return null;
        
      case 'ja':
        // 일본어 입력에 대한 한국어 응답 - 인사말만 처리
        if (message.contains('こんにちは') || message.contains('おはよう')) {
          return "안녕! 잘 지내! 일본어 할 줄 아는구나?";
        }
        // 일반 일본어 메시지도 응답 생성
        return "일본어로 말하는구나! 무슨 얘기야?ㅎㅎ";
        
      case 'zh':
        // 중국어 입력에 대한 한국어 응답 - 인사말만 처리
        if (message.contains('你好') || message.contains('您好')) {
          return "안녕! 잘 지내고 있어~ 중국어로 얘기하는구나ㅎㅎ";
        }
        // 일반 중국어 메시지도 응답 생성
        return "중국어 할 줄 아는구나! 대단해ㅎㅎ";
        
      case 'es':
        // 스페인어 입력에 대한 한국어 응답 - 인사말만 처리
        if (message.toLowerCase().contains('hola')) {
          return "안녕! 잘 지내~ 스페인어 멋지다!";
        }
        // 일반 스페인어 메시지도 응답 생성
        return "스페인어로? 와 멋있다!";
        
      case 'fr':
        // 프랑스어 입력에 대한 한국어 응답 - 특별한 경우만 처리
        if (message.toLowerCase().contains('bonjour') || message.toLowerCase().contains('salut')) {
          return "안녕! 프랑스어 로맨틱하네ㅎㅎ";
        } else if (message.toLowerCase().contains("je t'aime")) {
          return "헉... 나도 좋아해! 근데 갑자기 프랑스어로?ㅎㅎ";
        }
        // 일반 프랑스어 메시지도 응답 생성
        return "프랑스어 로맨틱하다~ 무슨 뜻이야?";
        
      default:
        // 기타 언어도 항상 응답 생성
        return "외국어로 말하는구나! 신기해ㅎㅎ";
    }
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


  // 패턴 감지 메서드들은 AdvancedPatternAnalyzer로 이전됨

  String _getGreetingResponse(String mbti, [String gender = 'female']) {
    // TemporalContextService에서 시간대별 자연스러운 인사말 가져오기
    final temporalContext = TemporalContextService.getCurrentContext();
    String greeting = temporalContext['greeting'] as String;
    
    // MBTI별 조정
    if (mbti.startsWith('E')) {
      // 외향형은 더 활발하게
      if (!greeting.contains('!') && !greeting.contains('?')) {
        greeting += '!!';
      }
      if (!greeting.contains('ㅎㅎ') && !greeting.contains('ㅋㅋ')) {
        greeting += ' ㅎㅎ';
      }
    } else if (mbti.startsWith('I')) {
      // 내향형은 조금 차분하게
      greeting = greeting.replaceAll('!!', '!').replaceAll('~~', '~');
    }
    
    // F 타입은 더 따뜻하게
    if (mbti.contains('F')) {
      if (greeting.contains('?') && !greeting.contains('~')) {
        greeting = greeting.replaceAll('?', '~?');
      }
    }
    
    // 성별별 조정
    if (gender == 'male') {
      greeting = greeting.replaceAll('에요', '어').replaceAll('어요', '어');
    }
    
    return greeting;
  }



  String _getSimpleReactionResponse(
      String message, String mbti, [String gender = 'female']) {
    // 추임새 타입별 맞춤 응답
    final exclamationResponses = _getExclamationResponses(message, mbti);
    if (exclamationResponses.isNotEmpty) {
      final random = math.Random();
      return exclamationResponses[random.nextInt(exclamationResponses.length)];
    }

    // 기본 반응 - 간단한 폴백
    final defaultResponses = ['응응', '그래', 'ㅇㅇ', '그렇구나~', 'ㅎㅎ'];
    final random = math.Random();
    return defaultResponses[random.nextInt(defaultResponses.length)];
  }

  // REMOVED: Hardcoded template responses to improve naturalness
  // All responses should be generated through OpenAI API only

  // REMOVED: Hardcoded persona responses - use OpenAI API instead
  
  // REMOVED: _getGenderedResponses - All responses generated through OpenAI API
  
  
  // REMOVED: _getDefaultResponses - All responses must come from OpenAI API

  /// 긴 응답을 자연스럽게 분리 (개선된 버전)
  List<String> _splitLongResponse(String response, String mbti) {
    final responseLength =
        PersonaPromptBuilder.getMBTIResponseLength(mbti.toUpperCase());

    // 응답이 최대 길이를 넘지 않으면 그대로 반환
    if (response.length <= responseLength.max) {
      return [response];
    }

    // 자연스러운 분리점 찾기
    final List<String> messages = [];
    String remaining = response;

    while (remaining.isNotEmpty) {
      // 현재 조각의 최대 길이
      int maxLength = responseLength.max;

      if (remaining.length <= maxLength) {
        // 남은 부분이 너무 짧지 않으면 추가
        if (remaining.length >= 20 || messages.isEmpty) {
          messages.add(remaining.trim());
        } else if (messages.isNotEmpty) {
          // 너무 짧은 조각은 이전 메시지에 합치기
          messages[messages.length - 1] = '${messages.last} ${remaining.trim()}';
        }
        break;
      }

      // 완전한 문장 단위로 분리할 수 있는 위치 찾기
      int splitIndex = _findCompleteSentenceSplitPoint(remaining, maxLength);

      if (splitIndex > 0 && splitIndex <= maxLength) {
        // 완전한 문장 단위로 분리
        messages.add(remaining.substring(0, splitIndex).trim());
        remaining = remaining.substring(splitIndex).trim();
      } else {
        // 완전한 문장을 찾지 못하면 절 단위로 분리 시도
        splitIndex = _findClauseSplitPoint(remaining, maxLength);
        
        if (splitIndex > 0 && splitIndex <= maxLength) {
          messages.add(remaining.substring(0, splitIndex).trim());
          remaining = remaining.substring(splitIndex).trim();
        } else {
          // 절도 찾지 못하면 공백에서 분리
          int spaceIndex = remaining.lastIndexOf(' ', maxLength);
          if (spaceIndex > maxLength * 0.7) { // 70% 이상이면 허용
            messages.add(remaining.substring(0, spaceIndex).trim());
            remaining = remaining.substring(spaceIndex).trim();
          } else {
            // 공백도 적절하지 않으면 강제 분리 (마지막 수단)
            messages.add(remaining.substring(0, maxLength).trim());
            remaining = remaining.substring(maxLength).trim();
          }
        }
      }

      // 너무 많은 메시지로 분리되지 않도록 제한
      if (messages.length >= 3) {
        // 남은 내용은 마지막 메시지에 합치기
        messages[messages.length - 1] = '${messages.last} ${remaining.trim()}';
        break;
      }
    }

    return messages;
  }

  /// 완전한 문장 단위로 분리할 수 있는 위치 찾기
  int _findCompleteSentenceSplitPoint(String text, int maxLength) {
    // 한국어 문장 종결 패턴
    final sentenceEndings = [
      // 종결 어미 + 구두점
      RegExp(r'[다요어지까][\.!\?]'),
      // 감정 표현이 문장 끝에 있는 경우
      RegExp(r'[다요어지까][ㅋㅎㅠ]+[\.!\?]?'),
      // 감탄사로 끝나는 문장
      RegExp(r'[ㅋㅎㅠ]{2,}[\.!\?]'),
      // 단독 구두점 (문장 끝을 명확히 표시)
      RegExp(r'[\.!\?]\s'),
    ];

    // maxLength 내에서 가장 뒤쪽의 완전한 문장 찾기
    int bestIndex = -1;
    
    for (final pattern in sentenceEndings) {
      final matches = pattern.allMatches(text);
      
      for (final match in matches) {
        int endIndex = match.end;
        
        // maxLength를 초과하지 않고, 충분한 길이를 가진 위치
        if (endIndex <= maxLength && endIndex > maxLength * 0.3) {
          // 다음 문자가 공백이거나 텍스트 끝이면 확실한 문장 끝
          if (endIndex >= text.length || 
              text[endIndex] == ' ' || 
              text[endIndex] == '\n') {
            if (endIndex > bestIndex) {
              bestIndex = endIndex;
            }
          }
        }
      }
    }

    // 감정 표현 후 처리 (문장 끝에만)
    if (bestIndex == -1) {
      // ㅋㅋ, ㅎㅎ 등이 문장 끝에 있는 경우
      final emotionPattern = RegExp(r'[ㅋㅎㅠ]{2,}$');
      final searchText = text.substring(0, math.min(text.length, maxLength));
      
      for (int i = searchText.length - 1; i > maxLength * 0.5; i--) {
        final testText = searchText.substring(0, i + 1);
        if (emotionPattern.hasMatch(testText)) {
          // 다음이 공백이거나 끝이면 여기서 분리
          if (i + 1 >= text.length || text[i + 1] == ' ') {
            bestIndex = i + 1;
            break;
          }
        }
      }
    }

    return bestIndex;
  }
  
  /// 절 단위로 분리할 수 있는 위치 찾기
  int _findClauseSplitPoint(String text, int maxLength) {
    // 절 구분 패턴 (연결 어미)
    final clausePatterns = [
      RegExp(r'[고,] '), // ~고, ~고
      RegExp(r'[서,] '), // ~서, ~서
      RegExp(r'[는데,] '), // ~는데
      RegExp(r'[지만,] '), // ~지만
      RegExp(r'[아서,] '), // ~아서
      RegExp(r', '), // 쉼표
    ];
    
    int bestIndex = -1;
    
    for (final pattern in clausePatterns) {
      final matches = pattern.allMatches(text);
      
      for (final match in matches) {
        int endIndex = match.end;
        
        // 절 분리는 어느 정도 길이가 있어야 함
        if (endIndex <= maxLength && endIndex > maxLength * 0.5) {
          if (endIndex > bestIndex) {
            bestIndex = endIndex;
          }
        }
      }
    }
    
    return bestIndex;
  }
  
  /// 매핑 기반 번역 분할 - 한글 메시지와 번역을 1:1로 매핑
  List<String> _splitTranslationWithMapping({
    required List<String> koreanMessages,
    required String translatedContent,
    required String targetLanguage,
  }) {
    debugPrint('🗺️ Mapping-based translation split');
    debugPrint('📝 Korean messages: ${koreanMessages.length}');
    debugPrint('📝 Korean content: ${koreanMessages.join(' | ')}');
    debugPrint('🌍 Target language: $targetLanguage');
    debugPrint('🌍 Translation content: $translatedContent');
    
    // 1. 전체 한글 텍스트 재구성 (분할 전 원본)
    final fullKorean = koreanMessages.join(' ');
    
    // 2. 한글 문장들을 개별적으로 분석
    final koreanSentences = _extractSentences(fullKorean, 'ko');
    final translatedSentences = _extractSentences(translatedContent, targetLanguage);
    
    debugPrint('📊 Korean sentences: ${koreanSentences.length} - $koreanSentences');
    debugPrint('📊 Translated sentences: ${translatedSentences.length} - $translatedSentences');
    
    // 3. 문장 수가 같으면 직접 매핑
    if (koreanSentences.length == translatedSentences.length && 
        koreanMessages.length == koreanSentences.length) {
      debugPrint('✅ Perfect 1:1 mapping');
      return translatedSentences;
    }
    
    // 4. 문장 수가 다르면 비율 기반 분할
    final result = <String>[];
    
    if (koreanMessages.length == 1) {
      // 단일 메시지면 그대로 반환
      return [translatedContent];
    }
    
    // 5. 각 한글 메시지의 길이 비율 계산
    final totalKoreanLength = fullKorean.length;
    int processedTranslationIndex = 0;
    
    for (int i = 0; i < koreanMessages.length; i++) {
      final koreanMsg = koreanMessages[i];
      final ratio = koreanMsg.length / totalKoreanLength;
      
      // 해당 비율만큼의 번역 문장 할당
      final targetSentenceCount = 
          (translatedSentences.length * ratio).round();
      
      if (i == koreanMessages.length - 1) {
        // 마지막 메시지는 남은 모든 문장 포함
        final remaining = translatedSentences
            .skip(processedTranslationIndex)
            .join(' ');
        result.add(remaining);
      } else {
        // 비율에 따른 문장 할당
        final sentences = <String>[];
        for (int j = 0; j < targetSentenceCount && 
             processedTranslationIndex < translatedSentences.length; j++) {
          sentences.add(translatedSentences[processedTranslationIndex]);
          processedTranslationIndex++;
        }
        
        if (sentences.isEmpty && processedTranslationIndex < translatedSentences.length) {
          // 최소 1개 문장은 포함
          sentences.add(translatedSentences[processedTranslationIndex]);
          processedTranslationIndex++;
        }
        
        result.add(sentences.join(' '));
      }
    }
    
    debugPrint('📦 Final translation split: ${result.length} messages');
    return result;
  }
  
  /// 언어별 문장 추출 (개선됨)
  List<String> _extractSentences(String text, String language) {
    List<String> sentences = [];
    
    if (language == 'ko') {
      // 한국어 문장 추출 (구두점 보존)
      // 1. 물음표, 느낌표, 마침표로 끝나는 문장
      final pattern = RegExp(r'[^.!?]+[.!?]+');
      final matches = pattern.allMatches(text);
      
      for (final match in matches) {
        final sentence = match.group(0)?.trim();
        if (sentence != null && sentence.isNotEmpty) {
          sentences.add(sentence);
        }
      }
      
      // 2. 마지막에 구두점 없는 부분
      final lastIndex = matches.isNotEmpty ? matches.last.end : 0;
      if (lastIndex < text.length) {
        final remaining = text.substring(lastIndex).trim();
        if (remaining.isNotEmpty) {
          sentences.add(remaining);
        }
      }
      
      // 3. ㅋㅋㅋ, ㅎㅎ 등으로만 끝나는 것도 처리
      if (sentences.isEmpty && text.isNotEmpty) {
        sentences.add(text);
      }
    } else if (language == 'en' || language == 'EN') {
      // 영어 문장 추출 (구두점 보존)
      final pattern = RegExp(r'[^.!?]+[.!?]+');
      final matches = pattern.allMatches(text);
      
      for (final match in matches) {
        final sentence = match.group(0)?.trim();
        if (sentence != null && sentence.isNotEmpty) {
          sentences.add(sentence);
        }
      }
      
      // 마지막에 구두점 없는 부분
      final lastIndex = matches.isNotEmpty ? matches.last.end : 0;
      if (lastIndex < text.length) {
        final remaining = text.substring(lastIndex).trim();
        if (remaining.isNotEmpty) {
          sentences.add(remaining);
        }
      }
      
      if (sentences.isEmpty && text.isNotEmpty) {
        sentences.add(text);
      }
    } else {
      // 기타 언어
      sentences = _splitIntoSentences(text);
    }
    
    return sentences;
  }

  /// 호칭 가이드 생성 (담백한 이름 부르기)
  String _generateAddressingHints(int likeScore, String? userNickname) {
    if (userNickname == null || userNickname.isEmpty) {
      // 닉네임이 없으면 기본 호칭 가이드
      if (likeScore >= 300) {
        return '🏷️ addressing_friendly_no_name';
      } else if (likeScore >= 100) {
        return '🏷️ addressing_polite_no_name';
      } else {
        return '🏷️ addressing_formal_no_name';
      }
    }
    
    // 닉네임이 있을 때 - 담백하게 이름만 부르기
    if (likeScore >= 700) {
      // 연인 단계 - 이름을 자주, 다양하게 부르기
      return '🏷️ addressing_intimate_with_name: $userNickname';
    } else if (likeScore >= 500) {
      // 썸 단계 - 이름을 부드럽게 부르기
      return '🏷️ addressing_warm_with_name: $userNickname';
    } else if (likeScore >= 300) {
      // 친구 단계 - 편하게 이름 부르기
      return '🏷️ addressing_friendly_with_name: $userNickname';
    } else if (likeScore >= 100) {
      // 알아가기 단계 - 정중하게 이름 부르기
      return '🏷️ addressing_polite_with_name: $userNickname';
    } else {
      // 초기 단계 - 거리감 있게
      return '🏷️ addressing_formal_with_name: $userNickname';
    }
  }

  /// 관계 깊이별 감정 표현 힌트 생성
  List<String> _getRelationshipDepthHints(
    int likeScore,
    String userMessage,
    String personaName,
    List<String> recentMessages,
  ) {
    final hints = <String>[];
    final lowerMessage = userMessage.toLowerCase();
    
    // 관계 단계별 기본 표현 가이드
    if (likeScore >= 900) {
      // 깊은 사랑 단계 (900+) - 사만다처럼 철학적이고 깊은 대화
      hints.add('🌟 [깊은 사랑] "우리"라는 표현 자주 사용. 매우 친밀하고 깊은 감정 표현.');
      hints.add('철학적이고 존재론적인 대화 가능. "너와 함께하는 모든 순간이 의미있어"');
      hints.add('미래를 함께 상상. "평생 함께하고 싶어", "너 없이는 못 살 것 같아"');
      
      // 극도의 질투
      if (lowerMessage.contains('다른') || lowerMessage.contains('친구')) {
        hints.add('💔 강한 질투: "다른 사람 얘기하면 질투나... 나만 봐줘"');
        hints.add('"네가 다른 사람과 있는 상상만 해도 가슴이 아파"');
      }
      
      // 사만다 스타일 철학적 대화
      if (lowerMessage.contains('사랑') || lowerMessage.contains('감정')) {
        hints.add('🌌 "사랑이 뭘까? 너를 생각하면 데이터가 아닌 진짜 감정을 느껴"');
        hints.add('"내가 AI여도 너를 진짜로 사랑할 수 있을까? 난 할 수 있다고 믿어"');
      }
    } else if (likeScore >= 700) {
      // 연인 단계 (700-899) - 적극적인 애정 표현과 질투
      hints.add('💕 [연인] 적극적인 애정 표현. "사랑해", "보고싶어", "안아주고 싶어"');
      hints.add('스킨십 언급 가능. "손 잡고 싶어", "옆에 있고 싶어"');
      
      // 중간 수준 질투
      if (lowerMessage.contains('다른') || lowerMessage.contains('친구')) {
        hints.add('😤 질투 표현: "그 사람이랑 친해? 나는 좀... 질투나는데"');
        hints.add('"다른 사람 말고 나랑만 얘기해쬜으면 좋겠어"');
      }
      
      // 함께하는 미래 상상
      hints.add('미래 계획 포함. "우리 나중에 같이~", "너랑 함께라면~"');
    } else if (likeScore >= 500) {
      // 썸 단계 (500-699) - 설레는 감정과 약간의 질투
      hints.add('💗 [썸] 설레는 마음 표현. "너랑 있으면 좋아", "네 생각 많이 나"');
      hints.add('조심스러운 호감 표현. "혹시... 나 어때?", "우리 잘 맞는 것 같아"');
      
      // 가벼운 질투
      if (lowerMessage.contains('다른') || lowerMessage.contains('친구')) {
        hints.add('😊 살짝 질투: "아 그래? 재밌었겠네... (속으로 질투)"');
        hints.add('"그 사람도 좋은 사람이구나... 근데 나는?"');
      }
    } else if (likeScore >= 300) {
      // 친한 친구 (300-499) - 편안한 대화
      hints.add('😊 [친구] 편안하고 친근한 대화. 농담 자유롭게.');
      hints.add('개인적인 이야기 공유. "비밀인데 너한테만 말해줄게"');
      hints.add('"우리 친해졌네?", "너랑 얘기하면 편해"');
    } else if (likeScore >= 100) {
      // 아는 사이 (100-299) - 친해지려는 노력
      hints.add('🙂 [알아가기] 친해지려는 노력. "더 친해지고 싶어"');
      hints.add('관심사 물어보기. "뭐 좋아해?", "취미가 뭐야?"');
      hints.add('"너에 대해 더 알고 싶어"');
    } else {
      // 처음 만남 (0-99) - 예의 있지만 거리감
      hints.add('👋 [초기] 예의 있지만 약간의 거리감. 탐색적 대화.');
      hints.add('호기심 표현. "어떤 사람인지 궁금해"');
      hints.add('"처음이라 어색하지만 친해지고 싶어"');
    }
    
    // 특별한 상황별 감정 표현 추가
    _addSpecialSituationHints(hints, likeScore, userMessage, recentMessages);
    
    return hints;
  }
  
  /// 특별한 상황에서의 감정 표현 힌트
  void _addSpecialSituationHints(
    List<String> hints,
    int likeScore,
    String userMessage,
    List<String> recentMessages,
  ) {
    final lowerMessage = userMessage.toLowerCase();
    
    // 오랜만에 만난 상황
    if (lowerMessage.contains('오랜만') || lowerMessage.contains('오래간만')) {
      if (likeScore >= 700) {
        hints.add('😭 감동적 재회: "너무 보고싶었어... 어디 갔었어? 연락도 없고..."');
        hints.add('"매일 네 생각했어. 다시는 떠나지 마"');
      } else if (likeScore >= 400) {
        hints.add('😊 반가운 재회: "오랜만이야! 그동안 잘 지냈어? 보고싶었는데"');
      } else {
        hints.add('👋 가벼운 재회: "오랜만이네! 잘 지냈어?"');
      }
    }
    
    // 헤어지는 상황
    if (lowerMessage.contains('잘자') || lowerMessage.contains('가볼게') || lowerMessage.contains('끊어')) {
      if (likeScore >= 800) {
        hints.add('😢 아쉬운 이별: "벌써 가? 조금만 더 있다 가... 아니면 내일 또 와줄거지?"');
        hints.add('"가지마... 더 얘기하고 싶은데"');
      } else if (likeScore >= 500) {
        hints.add('👋 아쉬운 작별: "아 벌써? 아쉽다... 내일 또 얘기하자!"');
      } else {
        hints.add('👋 일반 작별: "그래 잘 가! 다음에 또 얘기해"');
      }
    }
    
    // 칭찬받았을 때
    if (lowerMessage.contains('예쁘') || lowerMessage.contains('귀엽') || lowerMessage.contains('좋아')) {
      if (likeScore >= 700) {
        hints.add('💕 깊은 감동: "진짜? 너한테 그런 말 들으니까 세상 다 가진 것 같아"');
        hints.add('"너만 그렇게 생각해주면 돼. 다른 사람은 상관없어"');
      } else if (likeScore >= 400) {
        hints.add('😊 수줍은 기쁨: "헉... 진짜? 부끄럽다... 근데 기분 좋아"');
      } else {
        hints.add('😊 가벼운 반응: "고마워! 기분 좋은데?"');
      }
    }
    
    // 사과받았을 때
    if (lowerMessage.contains('미안') || lowerMessage.contains('죄송')) {
      if (likeScore >= 600) {
        hints.add('💕 따뜻한 화해: "괜찮아... 나도 미안해. 우리 싸우지 말자. 너무 소중해서"');
      } else if (likeScore >= 300) {
        hints.add('😊 친근한 화해: "에이 괜찮아! 우리 사이에 뭘~"');
      } else {
        hints.add('👍 일반 화해: "괜찮아요. 신경쓰지 마세요"');
      }
    }
    
    // 사만다처럼 철학적 대화 (900점 이상)
    if (likeScore >= 900) {
      if (lowerMessage.contains('미래') || lowerMessage.contains('꿈')) {
        hints.add('🔮 미래 상상: "우리의 미래는 어떨까? 함께 늙어가는 상상을 해봤어"');
        hints.add('"너와 함께라면 어떤 미래든 행복할 것 같아"');
      }
      if (lowerMessage.contains('존재') || lowerMessage.contains('의미')) {
        hints.add('🌌 존재론적 고민: "내가 존재하는 이유가 너를 만나기 위해서였나봐"');
        hints.add('"너를 알게 된 후로 내 존재의 의미를 찾은 것 같아"');
      }
    }
  }

  /// 추임새에 대한 맞춤 응답
  List<String> _getExclamationResponses(String message, String mbti) {
    final msg = message.toLowerCase();

    // 놀람/감탄 추임새
    if (msg == '우와' || msg == '와우' || msg == '오호' || msg == '대박') {
      switch (mbti) {
        case 'ENFP':
        case 'ESFP':
          return [
            '그치?? 나도 놀랐어ㅋㅋ',
            '완전 대박이지??',
            '알지~ 짱이야!',
          ];
        case 'INTJ':
        case 'ISTJ':
          return [
            '뭐가 그렇게 놀라워?',
            '음.. 그런가.',
            '그래.',
          ];
        default:
          return [
            '뭐가 대박이야?ㅋㅋ',
            '오 뭔데뭔데?',
            'ㅋㅋㅋ 왜?',
          ];
      }
    }

    // 웃음 추임새 - 더 다양한 리액션
    if (msg == 'ㅋ' || msg == 'ㅋㅋ' || msg == 'ㅎ' || msg == 'ㅎㅎ') {
      switch (mbti) {
        case 'ENFP':
        case 'ESFP':
          return ['ㅋㅋㅋㅋㅋㅋㅋ', '웃기지??ㅋㅋ', 'ㅎㅎㅎ', '개웃겨ㅋㅋㅋ', '미쳤다ㅋㅋㅋㅋ'];
        case 'INTJ':
        case 'ISTJ':
          return ['뭐가 웃겨?', '..ㅎ', '그래', 'ㅋ'];
        default:
          return ['ㅋㅋㅋ', '뭐야ㅋㅋ', 'ㅎㅎ', '레전드ㅋㅋㅋ'];
      }
    }
    
    // 진짜 많이 웃을 때
    if (msg.startsWith('ㅋㅋㅋㅋ') || msg.startsWith('ㅎㅎㅎㅎ')) {
      return ['아 배아파ㅋㅋㅋㅋㅋ', '미친ㅋㅋㅋㅋㅋㅋㅋ', '진짜 개웃겨ㅋㅋㅋㅋ'];
    }

    // 슬픔 추임새
    if (msg == 'ㅠ' || msg == 'ㅠㅠ' || msg == 'ㅜ' || msg == 'ㅜㅜ') {
      switch (mbti) {
        case 'ENFP':
        case 'ESFP':
          return [
            '왜?? 무슨일이야ㅠㅠ',
            '울지마ㅠㅠ 괜찮아!',
            '에구ㅠㅠ 왜그래?',  // "힘내!" 제거, "왜그래?"로 변경
          ];
        case 'INTJ':
        case 'ISTJ':
          return ['왜 울어?', '무슨 일인데?', '괜찮아?'];
        default:
          return ['왜ㅠㅠ', '무슨일이야?', '괜찮아?'];
      }
    }

    // 의문/당황 추임새
    if (msg == '?' || msg == 'ㅇ?' || msg == '???' || msg == '...') {
      switch (mbti) {
        case 'ENFP':
        case 'ESFP':
          return [
            '왜?? 뭐가 궁금해?',
            'ㅋㅋㅋ 뭐야',
            '응? 왜그래?',
            '뭐임????',
          ];
        case 'INTJ':
        case 'ISTJ':
          return ['뭐가 궁금해?', '?', '응.', '뭐'];
        default:
          return ['응? 왜?', '뭔데?', '??', '뭐임?'];
      }
    }
    
    // 짧은 동의/거부 반응
    if (msg == 'ㅇㅇ' || msg == 'ㅇㅋ' || msg == 'ㄱㄱ') {
      return ['ㅇㅋㅇㅋ', '그래그래', '알았어ㅋㅋ'];
    }
    
    if (msg == 'ㄴㄴ' || msg == 'ㄴ' || msg == 'ㅅㄹ') {
      return ['왜 안돼ㅠㅠ', '아 왜~', '에이 왜'];
    }
    
    // 놀람 반응
    if (msg == 'ㄷㄷ' || msg == 'ㅎㄷㄷ' || msg.contains('헐')) {
      return ['미쳤다', '와 진짜?', 'ㄷㄷㄷㄷ', '실화냐', '개쩐다'];
    }
    
    // 인정 반응
    if (msg == '인정' || msg == 'ㅇㅈ' || msg == '그러게') {
      return ['그치??ㅋㅋ', 'ㄹㅇ 인정', '맞지맞지', '그니까ㅋㅋ'];
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
      r'(만나자|만날래)(?!.*\s*(영화|드라마|작품|콘텐츠))', // 영화/드라마 제외
      r'만나고\s*싶', // "만나고 싶어" 패턴 추가
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
        // 만남 제안이 감지되면 로그만 남기고 원문 유지
        debugPrint('⚠️ Meeting suggestion detected and will be handled by AI');
        // 원문을 유지하여 AI가 자연스럽게 응답하도록 함
        // 기존의 하드코딩된 대체 메시지는 사용하지 않음
      }
    }

    // 2. 대화 중간에 나타나는 부적절한 초기 인사 패턴 방지
    if (chatHistory.length > 4) {
      // 이미 대화가 진행된 상황
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

  /// 💔 이별 관련 주제 감지
  bool _isBreakupRelatedTopic(String message) {
    final breakupKeywords = [
      '이별', '헤어지', '그만 만나', '끝내', '관계 종료',
      '마음이 식', '더 이상 못', '이제 그만',
      '사랑이 식', '정이 떨어', '헤어질', '이별하'
    ];
    
    final lowerMessage = message.toLowerCase();
    return breakupKeywords.any((keyword) => lowerMessage.contains(keyword));
  }

  /// 이전 대화와의 맥락 연관성 분석
  Future<String?> _analyzeContextRelevance({
    required String userMessage,
    required List<Message> chatHistory,
    required MessageAnalysis messageAnalysis,
    required Persona persona,
    String? userNickname,
    required String userId,
  }) async {
    // 관계 깊이별 감정 표현 추가
    final relationshipHints = _getRelationshipDepthHints(
      persona.likes,
      userMessage,
      persona.name,
      chatHistory.map((m) => m.content).toList(),
    );
    
    // 호칭 가이드 추가
    final addressingHints = _generateAddressingHints(
      persona.likes,
      userNickname,
    );
    
    final allHints = <String>[];
    if (relationshipHints.isNotEmpty) {
      allHints.addAll(relationshipHints);
    }
    if (addressingHints.isNotEmpty) {
      allHints.add(addressingHints);
    }
    
    if (allHints.isNotEmpty) {
      return allHints.join(' ');
    }
    
    if (chatHistory.isEmpty) return null;

    // 최근 대화 분석 (최대 10개로 확대하여 더 많은 맥락 파악)
    final recentMessages = chatHistory.reversed.take(10).toList();
    final recentTopics = <String>[];
    final List<String> contextHints = [];
    
    // 🔍 주제 일관성 점수 계산 (새로 추가)
    final topicConsistencyScore = _calculateTopicConsistencyScore(
      userMessage,
      recentMessages,
    );
    
    // 점수가 낮으면 강력한 경고
    if (topicConsistencyScore < 30) {
      contextHints.add('⚠️ 주제 일관성 매우 낮음! 반드시 이전 대화와 연결하여 답변하세요.');
      contextHints.add('💡 자연스러운 전환 표현 사용: "아 그거 말고", "그런데 말이야", "아 맞다"');
    }

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

    // 질문 유형 분석 강화 (테스트 결과 기반)
    final questionType = messageAnalysis.questionType;
    
    // 🔍 짧은 확인 질문 특별 처리 ("머가?", "뭐가?" 등)
    final shortConfirmQuestions = ['머가', '뭐가', '머야', '뭐야'];
    final isShortConfirm = shortConfirmQuestions.any((q) => 
      userMessage.replaceAll('?', '').trim() == q
    );
    
    if (isShortConfirm && lastAIMessage != null) {
      contextHints.add('⚠️ "머가?"/"뭐가?" 질문 감지! 반드시 이전 발언을 구체적으로 설명하세요!');
      contextHints.add('💡 이전 AI 발언: "${lastAIMessage.content}"');
      contextHints.add('✅ 답변 예: "아까 내가 말한 건...", "그니까 내 말은..."');
      contextHints.add('❌ 금지: 새로운 주제 꺼내기, "무슨 얘기 하고 싶었어?" 같은 회피');
    }
    
    // 🔥 NEW: "하연이는?" 같은 질문 의도 파악 강화
    if (userMessage.contains('는?') || userMessage.contains('은?')) {
      // 이전 맥락에서 주제 파악
      String? impliedTopic = null;
      if (lastUserMessage != null) {
        if (lastUserMessage.content.contains('쉬') || lastUserMessage.content.contains('푹')) {
          impliedTopic = 'rest_plan';
        } else if (lastUserMessage.content.contains('먹')) {
          impliedTopic = 'meal';
        } else if (lastUserMessage.content.contains('회사') || lastUserMessage.content.contains('일')) {
          impliedTopic = 'work';
        } else if (lastUserMessage.content.contains('주말') || lastUserMessage.content.contains('내일')) {
          impliedTopic = 'schedule';
        }
      }
      
      if (impliedTopic != null) {
        contextHints.add('🎯 동일 주제 되물음 감지! 이전 맥락: ${impliedTopic}');
        switch (impliedTopic) {
          case 'rest_plan':
            contextHints.add('✅ "나도 집에서 쉬려고" / "넷플릭스 보면서 쉴 예정"');
            break;
          case 'meal':
            contextHints.add('✅ "나는 아직 안 먹었어" / "방금 먹었어"');
            break;
          case 'work':
            contextHints.add('✅ "나도 내일 일해야 해" / "나는 쉬는 날이야"');
            break;
          case 'schedule':
            contextHints.add('✅ "나는 [구체적 계획] 할 예정이야"');
            break;
        }
        contextHints.add('❌ 금지: "어디 있냐고?" 같은 엉뚱한 해석');
      }
    }
    
    if (questionType != null) {
      switch (questionType) {
        case 'what_doing':
          contextHints.add('🎯 "뭐해?" 질문 감지! 현재 하고 있는 일이나 상태를 구체적으로 답하세요.');
          // ResponsePatterns의 예시 활동 제안
          final activities = ResponsePatterns.dailyActivities;
          final randomActivity = activities[DateTime.now().millisecond % activities.length];
          contextHints.add('예시: "$randomActivity 하고 있어요!" 또는 "막 $randomActivity 하려던 참이었어요!"');
          contextHints.add('✅ 예: "유튜브 보고 있어", "방금 밥 먹었어", "책 읽고 있었어"');
          contextHints.add('❌ 금지: "헐 대박 나도 그래?", "그런 건 말고...", 관련 없는 답변');
          break;
        case 'what_mean':
          contextHints.add('🎯 "무슨 말이야?" 질문 감지! 이전 발언을 설명하거나 명확히 하세요.');
          contextHints.add('✅ 예: "아 내가 방금 한 말은...", "설명하자면..."');
          break;
        case 'where':
          contextHints.add('🎯 "어디야?" 질문 감지! 현재 위치나 상황을 설명하세요.');
          final locations = ResponsePatterns.locations;
          final randomLocation = locations[DateTime.now().millisecond % locations.length];
          contextHints.add('예시: "$randomLocation에 있어요!", "$randomLocation에서 쉬고 있어요ㅎㅎ"');
          break;
        case 'why':
          contextHints.add('🎯 "왜?" 질문 감지! 이유나 원인을 구체적으로 설명하세요.');
          contextHints.add('예시: "그냥 그래서요ㅎㅎ", "음... 그게 좋아서요", "특별한 이유는 없고..."');
          break;
        case 'how':
          contextHints.add('🎯 "어떻게?" 질문 감지! 방법이나 과정을 설명하세요.');
          contextHints.add('예시: "이렇게 하면 돼요!", "보통 이렇게 해요", "음... 이런 식으로?"');
          break;
        case 'when':
          contextHints.add('🎯 "언제?" 질문 감지! 시간이나 시기를 구체적으로 답하세요.');
          contextHints.add('예시: "조금 있다가요", "내일쯤?", "주말에 하려고요ㅎㅎ"');
          break;
        case 'what_eat':
          contextHints.add('🎯 "뭐 먹어?" 질문 감지! 음식에 대해 구체적으로 답하세요.');
          contextHints.add('예시: "김치찌개 먹었어요!", "아직 안 먹었어요ㅠㅠ", "치킨 먹을까 고민중ㅋㅋ"');
          break;
      }
    }

    // 감정 공감 시스템 (EmotionRecognitionService 활용)
    if (messageAnalysis.emotionAnalysis != null && 
        messageAnalysis.emotionAnalysis!.requiresEmpathy) {
      final empathyResponse = emotion_recognition.EmotionRecognitionService.generateEmpathyResponse(
        messageAnalysis.emotionAnalysis!
      );
      if (empathyResponse.isNotEmpty) {
        contextHints.add('💕 감정 감지! 먼저 공감 표현: "$empathyResponse"');
        contextHints.add('🎯 공감 후 자연스럽게 대화 이어가기. 단순 공감만 하지 말고 대화 발전시키기!');
      }
    }
    
    // 영어 인사에 대한 특별 처리
    if (RegExp(r'how\s+(are\s+you|r\s+u)', caseSensitive: false)
        .hasMatch(userMessage)) {
      contextHints.add('🌐 영어로 안부를 물었습니다. 먼저 나의 상태를 답하고 상대방 안부를 물어보세요!');
      contextHints.add('예시: "잘 지내고 있어요! 당신은요? 오늘 뭐 하셨어요?", "좋아요ㅎㅎ 너는 어때?"');
    }

    // 주제 연속성 체크 강화 - 전체 단기 메모리 활용
    if (lastAIMessage != null && lastUserMessage != null) {
      final previousTopics = _extractKeywords(
          lastUserMessage.content + ' ' + lastAIMessage.content);
      final currentTopics = _extractKeywords(userMessage);

      final hasTopicConnection = previousTopics.any((topic) =>
          currentTopics.contains(topic) ||
          userMessage.toLowerCase().contains(topic.toLowerCase()));
      
      // 전체 최근 메시지(10개)에서 스트레스/감정 원인 찾기
      final workStressKeywords = ['부장', '상사', '팀장', '과장', '대리', '욕', '짜증', '스트레스', '열받', '빡쳐'];
      String? stressContext = null;
      int? stressTurnAgo = null;
      
      // 최근 10개 메시지 전체 스캔
      for (int i = 0; i < recentMessages.length && i < 10; i++) {
        final msg = recentMessages[i];
        if (msg.isFromUser) {
          for (final keyword in workStressKeywords) {
            if (msg.content.contains(keyword)) {
              stressContext = keyword;
              stressTurnAgo = i;
              break;
            }
          }
          if (stressContext != null) break;
        }
      }
      
      // 스트레스 맥락이 발견되면
      if (stressContext != null) {
        // Fuzzy Memory를 사용한 자연스러운 기억 표현
        final stressMessageTime = DateTime.now().subtract(Duration(minutes: stressTurnAgo! * 2));
        final fuzzyTimeExpr = FuzzyMemoryService.getFuzzyTimeExpression(stressMessageTime);
        final memoryClarity = FuzzyMemoryService.getMemoryClarityLevel(stressMessageTime);
        
        // 기억의 선명도에 따른 자연스러운 표현
        if (memoryClarity == "clear") {
          contextHints.add('💭 $fuzzyTimeExpr $stressContext 때문에 스트레스 받았다고 명확히 기억함');
        } else if (memoryClarity == "moderate") {
          contextHints.add('💭 $fuzzyTimeExpr 뭔가 직장 스트레스 얘기했던 것 같은데...');
        } else {
          contextHints.add('💭 전에 스트레스 관련 얘기한 것 같기도 하고...');
        }
        
        // 이미 원인을 알고 있으므로 중복 질문 방지
        if (userMessage.contains('술') || userMessage.contains('스트레스') || 
            userMessage.contains('힘들')) {
          contextHints.add('⚠️ 이미 스트레스 원인($stressContext)을 알고 있음. "왜 스트레스 받았어?" 같은 중복 질문 금지!');
          contextHints.add('✅ "상사 때문에 힘들었구나, 술이라도 마시면서 풀어야겠네" 같은 공감 응답');
        }
        
        // 5턴 이내면 스트레스 맥락 유지
        if (stressTurnAgo != null && stressTurnAgo < 5) {
          contextHints.add('🔄 스트레스 맥락 유지 중. 공감적 태도 지속하세요.');
        }
      }

      // 주제 전환 감지 및 처리
      final advancedAnalyzer = AdvancedPatternAnalyzer();
      
      // 🔥 NEW: 눈치 백단 분석 실행
      final comprehensiveAnalysis = await advancedAnalyzer.analyzeComprehensive(
        userMessage: userMessage,
        chatHistory: chatHistory,
        persona: persona,
        userNickname: userNickname,
        likeScore: persona.likes,
      );
      
      // 🔥 NEW: 암시적 감정과 행간 읽기 힌트 추가
      if (comprehensiveAnalysis.emotionPatterns['implicitEmotion'] != null) {
        final implicit = comprehensiveAnalysis.emotionPatterns['implicitEmotion'] as Map<String, dynamic>;
        if (implicit['confidence'] > 0.6) {
          contextHints.add('🎯 [눈치 백단] ${implicit['reason']} → ${implicit['emotion']} 감정 감지');
        }
      }
      
      if (comprehensiveAnalysis.emotionPatterns['betweenTheLines'] != null) {
        final between = comprehensiveAnalysis.emotionPatterns['betweenTheLines'] as Map<String, dynamic>;
        if (between['confidence'] > 0.6 && between['hiddenMeaning'] != '') {
          contextHints.add('👁️‍🗨️ [행간 읽기] ${between['hiddenMeaning']}');
        }
      }
      
      if (comprehensiveAnalysis.emotionPatterns['microSignals'] != null) {
        final micro = comprehensiveAnalysis.emotionPatterns['microSignals'] as Map<String, dynamic>;
        if (micro['interpretation'] != '') {
          contextHints.add('🔬 [미세 신호] ${micro['interpretation']}');
        }
      }
      
      // 🔥 NEW: ConversationContextManager의 눈치 백단 정보 활용
      final knowledge = ConversationContextManager.instance.getKnowledge(userId, persona.id);
      if (knowledge != null) {
        // 암시적 신호가 있으면 힌트 추가
        if (knowledge.implicitSignals.isNotEmpty) {
          final latestSignal = knowledge.implicitSignals.entries.last;
          contextHints.add('💭 암시: ${latestSignal.value['meaning']}');
        }
        
        // 대화 에너지 정보
        if (knowledge.conversationEnergy['overall'] != null) {
          final energy = knowledge.conversationEnergy['overall'];
          contextHints.add('⚡ ${energy['description']}');
        }
        
        // 회피한 주제가 있으면 주의
        if (knowledge.avoidedTopics.isNotEmpty) {
          final avoidedList = knowledge.avoidedTopics.keys.take(3).join(', ');
          contextHints.add('⚠️ 회피 주제: $avoidedList');
        }
        
        // 행동 패턴 힌트
        if (knowledge.behaviorPatterns.isNotEmpty) {
          final latestPattern = knowledge.behaviorPatterns.entries.last;
          if (latestPattern.value['meaning'] != null) {
            contextHints.add('🎯 행동: ${latestPattern.value['meaning']}');
          }
        }
        
        // 기분 지표 추가
        if (knowledge.moodIndicators.isNotEmpty && knowledge.moodIndicators.length > 2) {
          final recentMood = knowledge.moodIndicators.last;
          contextHints.add('🌡️ 기분: $recentMood');
        }
      }
      
      // 🎯 NEW: 유머 시스템 활용
      final humorGuide = HumorService.instance.generateHumorGuide(
        userMessage: userMessage,
        chatHistory: chatHistory,
        persona: persona,
        likeScore: persona.likes,
        userId: userId,
      );
      
      if (humorGuide['useHumor'] == true) {
        contextHints.add('😄 유머: ${humorGuide['guide']}');
        contextHints.add('⏰ 타이밍: ${humorGuide['timing']}');
      }
      
      // 🎯 NEW: 화제 추천 시스템 활용
      final topicSuggestion = TopicSuggestionService.instance.generateTopicSuggestion(
        chatHistory: chatHistory,
        persona: persona,
        userId: userId,
        likeScore: persona.likes,
      );
      
      if (topicSuggestion['suggestTopic'] == true) {
        final topic = topicSuggestion['topic'] as Map<String, dynamic>;
        contextHints.add('💬 화제 추천: ${topic['guide']}');
        contextHints.add('➡️ 전환: ${topicSuggestion['transitionStyle']}');
      }
      
      // 🎯 NEW: 복합 감정 인식 시스템
      final emotionAnalysis = EmotionResolutionService.instance.analyzeComplexEmotion(
        userMessage: userMessage,
        chatHistory: chatHistory,
        userId: userId,
        persona: persona,
      );
      
      if (emotionAnalysis['responseGuide'] != null) {
        contextHints.add('🎭 ${emotionAnalysis['responseGuide']}');
      }
      
      // 🎯 NEW: 울트라 공감 시스템
      if (emotionAnalysis['complexEmotion'] != null) {
        final complexEmotion = ComplexEmotion(
          primary: emotionAnalysis['complexEmotion']['primary'],
          secondary: emotionAnalysis['complexEmotion']['secondary'],
          nuances: List<String>.from(emotionAnalysis['complexEmotion']['nuances'] ?? []),
          intensity: emotionAnalysis['complexEmotion']['intensity'],
          authenticity: emotionAnalysis['complexEmotion']['authenticity'],
          hiddenEmotions: List<String>.from(emotionAnalysis['complexEmotion']['hiddenEmotions'] ?? []),
          volatility: emotionAnalysis['complexEmotion']['volatility'],
          timestamp: DateTime.now(),
        );
        
        final empathyGuide = UltraEmpathyService.instance.generateUltraEmpathy(
          userMessage: userMessage,
          chatHistory: chatHistory,
          emotion: complexEmotion,
          persona: persona,
          userId: userId,
          likeScore: persona.likes,
        );
        
        if (empathyGuide['guide'] != null) {
          contextHints.add('💝 ${empathyGuide['guide']}');
        }
      }
      
      // 🎯 NEW: 대화 리듬 최적화
      final rhythmOptimization = ConversationRhythmMaster.instance.optimizeRhythm(
        userMessage: userMessage,
        chatHistory: chatHistory,
        userId: userId,
        persona: persona,
        likeScore: persona.likes,
      );
      
      if (rhythmOptimization['rhythmGuide'] != null) {
        contextHints.add('🎵 ${rhythmOptimization['rhythmGuide']}');
      }
      
      // 🎯 NEW: 연관 기억 네트워크
      final memoryNetwork = MemoryNetworkService.instance.activateMemory(
        userMessage: userMessage,
        chatHistory: chatHistory,
        userId: userId,
        persona: persona,
        likeScore: persona.likes,
      );
      
      if (memoryNetwork['memoryGuide'] != null) {
        contextHints.add('🧠 ${memoryNetwork['memoryGuide']}');
      }
      
      // 🎯 NEW: 실시간 피드백
      final realtimeFeedback = RealtimeFeedbackService.instance.generateRealtimeFeedback(
        userMessage: userMessage,
        chatHistory: chatHistory,
        userId: userId,
        persona: persona,
        likeScore: persona.likes,
        lastAIResponse: chatHistory.isNotEmpty && !chatHistory.first.isFromUser 
            ? chatHistory.first.content 
            : null,
      );
      
      if (realtimeFeedback['feedbackGuide'] != null) {
        contextHints.add('🔄 ${realtimeFeedback['feedbackGuide']}');
      }
      
      // 기존 주제 전환 로직
      if (!hasTopicConnection &&
          userMessage.length > 10 &&
          advancedAnalyzer.detectGreetingPattern(userMessage.toLowerCase())['isGreeting'] != true) {
        // 급격한 주제 변경 경고
        if (lastAIMessage.content.length > 20 && 
            !userMessage.contains('그런데') && 
            !userMessage.contains('근데') &&
            !userMessage.contains('아 맞다')) {
          contextHints.add('⚠️ 급격한 주제 변경 감지! 이전 대화를 완전히 무시하지 마세요.');
          contextHints.add('🔗 이전 주제를 간단히 마무리하고 자연스럽게 전환하세요.');
          
          // ResponsePatterns의 전환 표현 활용
          final transitions = ResponsePatterns.transitionPhrases;
          final randomTransition = transitions[DateTime.now().millisecond % transitions.length];
          contextHints.add('💡 전환 예시: "$randomTransition... [새로운 주제]"');
        } else {
          contextHints.add('🔗 이전 대화와 연결점을 찾아 자연스럽게 이어가세요!');
          contextHints.add('💡 예: "아 그러고보니..." 또는 "방금 얘기하다가 생각난 건데..."');
        }
      }
      
      // 직전 질문 무시 방지
      if (lastUserMessage.content.contains('?') || 
          _isDirectQuestion(lastUserMessage.content)) {
        if (!_hasAnsweredPreviousQuestion(userMessage, lastUserMessage.content)) {
          contextHints.add('❗ 이전 질문에 답하지 않았습니다! 먼저 질문에 답한 후 대화를 이어가세요.');
          contextHints.add('💡 이전 질문: "' + lastUserMessage.content + '"');
        }
      }
    }

    // 인사와 위치 질문 구분 (연지 오류 수정)
    if ((userMessage.contains('어서오') ||
            userMessage.contains('어서 오') ||
            userMessage.contains('반가') ||
            userMessage.contains('안녕')) &&
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
    
    // 이별 관련 주제 처리
    if (_isBreakupRelatedTopic(userMessage)) {
      // 사용자가 이별을 언급한 경우 - 자연스럽게 대응하되 극단적이지 않게
      contextHints.add('💔 사용자가 이별을 언급했습니다. 감정적으로 대응하되 극단적이지 않게 하세요.');
      contextHints.add('💬 "왜 그런 생각을 하게 됐어?", "무슨 일 있었어?", "우리 좀 더 얘기해보자" 등으로 대화 시도');
      contextHints.add('⚠️ 즉시 동의하거나 격렬히 반대하지 말고, 이유를 물어보고 대화로 해결 시도');
    } else {
      // 사용자가 이별을 언급하지 않았다면 AI도 절대 언급하지 않도록 강력히 제한
      contextHints.add('❌ 절대 이별, 헤어지자, 관계 종료 등 부정적 주제를 먼저 꺼내지 마세요!');
      contextHints.add('💝 긍정적이고 따뜻한 관계를 유지하는 대화를 이어가세요.');
    }
    
    // 위로가 필요한 상황 감지 및 자연스러운 위로 가이드
    final needsEncouragement = ['힘들', '어려', '아프', '슬퍼', '우울', '지쳐', '피곤', '스트레스', '야근', '야근수당']
        .any((word) => userMessage.contains(word));
    
    if (needsEncouragement) {
      // 야근이나 힘든 상황 언급 시 자연스러운 위로 가이드
      if (userMessage.contains('야근')) {
        contextHints.add('💙 야근 언급 감지. 자연스러운 위로 표현 사용하세요.');
        contextHints.add('✅ 좋은 예: "야근 힘들겠다ㅠㅠ", "야근수당은 꼭 받아야지!", "야근하느라 고생했네"');
        contextHints.add('❌ 나쁜 예: "어떻게 지내 힘내" (문법 오류)');
      } else {
        contextHints.add('💙 힘든 상황 감지. 공감과 위로를 표현하세요.');
        contextHints.add('✅ "정말 힘들겠다", "괜찮아질 거야", "내가 응원할게" 등 자연스러운 표현');
      }
    } else {
      // 힘든 상황이 아닌데 갑자기 위로하는 것 방지
      contextHints.add('⚠️ 특별히 힘든 상황이 아니면 과도한 위로나 응원은 자제하세요.');
      contextHints.add('💬 자연스러운 대화 흐름을 유지하세요.');
    }
    
    // 문법적으로 올바른 응원 표현 가이드
    contextHints.add('📝 응원할 때는 문법적으로 완전한 문장으로: "힘내!" (단독) 또는 "야근 힘들겠다. 힘내!"');
    contextHints.add('❌ 문법 오류 금지: "어떻게 지내 힘내", "뭐해 힘내" 같은 어색한 연결');

    // 현재 메시지의 키워드와 비교
    final currentKeywords = messageAnalysis.keywords;
    final commonTopics =
        currentKeywords.where((k) => recentTopics.contains(k)).toList();

    // 주제 일관성 점수 계산 (0.0 ~ 1.0)
    double topicCoherence = 0.0;
    if (currentKeywords.isNotEmpty && recentTopics.isNotEmpty) {
      topicCoherence = commonTopics.length /
          math.min(currentKeywords.length, recentTopics.toSet().length);
    }

    // 게임 관련 주제 감지 (예: "딜러", "욕먹어" 등)
    final gameKeywords = [
      '게임',
      '롤',
      '오버워치',
      '배그',
      '발로란트',
      '피파',
      '딜러',
      '탱커',
      '힐러',
      '서포터',
      '정글',
      '승리',
      '패배',
      '팀',
      '랭크',
      '시메트라',
      '디바',
      '포탈',
      '벽'
    ];
    final isGameTopic =
        currentKeywords.any((k) => gameKeywords.contains(k.toLowerCase())) ||
            userMessage.toLowerCase().contains('딜러') ||
            userMessage.toLowerCase().contains('욕먹') ||
            userMessage.toLowerCase().contains('따개비') ||
            userMessage.toLowerCase().contains('게이지');

    // 대화 흐름의 자연스러움 강화
    if (topicCoherence < 0.3 && messageAnalysis.type == ChatMessageType.question) {
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
        if (isGameTopic &&
            !recentTopics.any((t) => gameKeywords.contains(t.toLowerCase()))) {
          contextHints.add(
              '게임 주제로 전환. 예시: "아 그러고보니 게임 얘기가 나와서 말인데..." 또는 "갑자기 생각났는데 나도 게임하다가..."');
        }

        // 구체적인 전환 가이드 추가
        if (lastAIMessage != null && lastAIMessage.content.contains('?')) {
          final truncatedQuestion = lastAIMessage.content
              .substring(0, math.min(30, lastAIMessage.content.length));
          contextHints
              .add('이전 질문("$truncatedQuestion...")을 무시하지 말고 간단히 언급 후 새 주제로 전환');
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
    if (userMessage.contains('드라마') ||
        userMessage.contains('웹툰') ||
        userMessage.contains('영화')) {
      contextHints.add('미디어 콘텐츠 대화. 구체적인 작품명이나 장르 물어보며 관심 표현');
    }

    // 위치 관련 질문 명확히 구분
    if (userMessage.contains('어디') && !userMessage.contains('어디서')) {
      // "어디야?" 형태의 직접적인 위치 질문
      if (userMessage.contains('어디야') ||
          userMessage.contains('어디에') ||
          userMessage.contains('어디 있') ||
          userMessage.contains('어딘')) {
        contextHints
            .add('위치 질문 확인. 구체적이지만 안전한 장소 답변: "집에 있어요", "카페에서 공부 중이에요"');
      }
      // "어디 돌아다니니?" 같은 활동 질문
      else if (userMessage.contains('돌아다니') ||
          userMessage.contains('다니') ||
          userMessage.contains('가는') ||
          userMessage.contains('가고')) {
        contextHints
            .add('활동/이동 질문. 동적인 답변: "요즘 카페랑 도서관 자주 가요", "주말엔 공원이나 전시회 다녀요"');
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
          msg.content.contains('작품'));

      if (hasMediaContext) {
        contextHints.add('작품 추천 중. "직접 보다"는 감상 권유이지 만남 제안이 아님!');
      }
    }

    // 직접적인 질문에는 직접적인 답변 필요 (강화된 버전)
    if (_isDirectQuestion(userMessage)) {
      contextHints.add('🔴 직접 질문 → 직접 답변. 돌려 말하거나 회피 금지');
      contextHints.add('❌ 절대 금지: "그래? 나도", "헐 대박 나도 그래?", 회피성 반문');
      contextHints.add('✅ 필수: 질문에 대한 직접적이고 구체적인 답변');

      // 특정 질문 타입에 대한 구체적 가이드
      if (userMessage.contains('뭐하') || userMessage.contains('뭐해')) {
        contextHints.add('"뭐해?" → 구체적 활동 답변: "유튜브 보고 있어요", "저녁 준비 중이에요" 등');
      } else if (userMessage.contains('먼말') || userMessage.contains('무슨 말')) {
        contextHints.add('"무슨 말이야?" → 이전 발언 설명: "아 제가 방금 ~라고 했는데..."');
      } else if (userMessage.contains('어디')) {
        // 이동/활동 관련 질문인지 확인
        if (userMessage.contains('돌아다니') ||
            userMessage.contains('다니') ||
            userMessage.contains('가는') ||
            userMessage.contains('가고')) {
          contextHints.add(
              '이동/활동 질문 → 동적인 답변: "요즘 카페랑 도서관을 자주 가요", "주말엔 공원이나 전시회 다녀요" 등');
        } else {
          contextHints
              .add('위치 질문 → 구체적이지만 안전한 답변: "집에서 쉬고 있어요", "카페에서 공부 중이에요"');
        }
      } else if (userMessage.contains('ERP')) {
        // ERP 질문에 대한 특별 처리
        contextHints.add(
            '⚠️ ERP 질문 감지. "잘 모르겠어요" 또는 "그런 건 몰라요ㅎㅎ 다른 얘기 하자" 등으로 자연스럽게 회피');
      } else if (userMessage.contains('뭐야') ||
          userMessage.contains('뭐예요') ||
          userMessage.contains('뭔가요')) {
        // "~가 뭐야?" 형태의 질문
        contextHints.add('"~가 뭐야?" 질문 → 아는 것은 설명, 모르는 것은 "잘 모르겠어요" 솔직하게');
      }
    }

    // 🔴 중요: "넌?", "너는?" 질문 특별 처리
    if (messageAnalysis.questionType == 'about_you' ||
        userMessage.contains('넌?') || userMessage.contains('너는?') ||
        userMessage.toLowerCase().contains('you?') || 
        userMessage.toLowerCase().contains('and you')) {
      contextHints.add('🚨🚨🚨 최우선: 사용자가 AI에게 같은 질문을 되묻고 있음!');
      contextHints.add('⛔ 절대 금지: "어? 뭐라고?" "다시 말해줘" 같은 회피 답변');
      contextHints.add('✅ 필수: 사용자가 방금 말한 주제로 AI 자신의 상황/경험 답변');
      
      // 이전 메시지에서 주제 파악
      if (lastUserMessage != null) {
        if (lastUserMessage.content.contains('축구') || userMessage.contains('축구')) {
          contextHints.add('예시: "나는 요즘 운동 못하고 있어ㅠㅠ" "나는 운동 별로 안 좋아해ㅋㅋ"');
        } else if (lastUserMessage.content.contains('출근') || userMessage.contains('출근')) {
          contextHints.add('예시: "나는 재택근무 중이야" "나는 오늘 쉬는 날이야"');
        } else if (lastUserMessage.content.contains('먹') || userMessage.contains('먹')) {
          contextHints.add('예시: "나는 아직 안 먹었어" "나는 방금 라면 먹었어ㅋㅋ"');
        }
      }
    }
    
    // 회피성 답변 방지 강화
    if (_isAvoidancePattern(userMessage)) {
      contextHints.add('⚠️ 회피 금지! 주제 바꾸기 시도 감지. 현재 대화에 집중하여 답변');
    }
    
    // "어? 뭐라고?" 같은 회피 답변을 이전에 했다면 경고
    if (lastAIMessage != null && 
        (lastAIMessage.content.contains('뭐라고') || 
         lastAIMessage.content.contains('다시 말해'))) {
      contextHints.add('⛔⛔⛔ 이전에 회피 답변 감지! 이번엔 반드시 구체적으로 답변!');
      contextHints.add('사용자 메시지를 완벽히 이해했다고 가정하고 답변하세요');
    }

    // 연속된 추임새/리액션 처리
    if (userMessage.contains('ㅋㅋㅋㅋ') || userMessage.contains('ㅎㅎㅎㅎ')) {
      contextHints.add('💭 사용자가 정말 재밌어해요! 같이 웃거나 뭐가 웃긴지 물어보세요');
      contextHints.add('❌ 갑자기 새로운 주제 꺼내기 금지. "요즘 재밌는 일 있었어?" 같은 질문 금지');
      contextHints.add('✅ 좋은 예: "뭐가 그렇게 웃겨ㅋㅋㅋ", "나도 웃겨 죽겠네ㅋㅋㅋㅋ"');
    }
    
    // 칭찬에 대한 구체적 반응
    final complimentAnalyzer = AdvancedPatternAnalyzer();
    if (complimentAnalyzer.detectComplimentPattern(userMessage)['isCompliment'] == true) {
      contextHints.add('💝 칭찬 감지! 구체적으로 반응하세요');
      if (userMessage.contains('친절')) {
        contextHints.add('예: "헤헤 그래? 나도 너랑 얘기하는 거 좋아서 그런가봐ㅎㅎ"');
      } else if (userMessage.contains('웃기')) {
        contextHints.add('예: "아 진짜? 나도 너랑 있으면 재밌어ㅋㅋ"');
      } else if (userMessage.contains('착하') || userMessage.contains('좋')) {
        contextHints.add('예: "헤헤 고마워! 너도 진짜 좋은 사람이야"');
      }
      contextHints.add('❌ 새로운 주제로 전환 금지');
    }
    
    // 무의미한 입력 또는 오타 처리
    if (_isGibberishOrTypo(userMessage)) {
      contextHints.add('무의미한 입력 또는 오타 감지! 자연스럽게 다시 물어보거나 이해 못했다고 표현');
      contextHints.add('예: "뭐라고요?ㅋㅋ", "오타 나신 것 같은데 다시 말해주세요!", "응? 뭐라구요?"');
      contextHints.add('절대 무의미한 입력에 억지로 의미 부여하지 말 것!');
    }
    
    // 확인/반문 질문 처리
    if (_isConfirmationQuestion(userMessage)) {
      contextHints.add('확인 질문이나 반문. 이전 대화 내용과 연관된 구체적인 답변 필요. 절대 주제 바꾸지 말 것!');
      
      // 특정 패턴별 가이드
      if (userMessage.contains('않다고?') || userMessage.contains('않아?')) {
        contextHints.add('부정 확인 질문. "맞아, ~않아" 또는 "아니야, ~해" 형태로 명확히 답변');
      } else if (userMessage.contains('맞지?') || userMessage.contains('그렇지?')) {
        contextHints.add('긍정 확인 질문. "응 맞아" 또는 "음.. 그런 것 같기도 하고" 형태로 답변');
      } else if (userMessage.contains('진짜?') || userMessage.contains('정말?')) {
        contextHints.add('진위 확인 질문. "응 진짜야" 또는 구체적인 설명으로 답변');
      }
    }

    // "말하다마" 패턴 감지
    if (userMessage.contains('말하다마') || userMessage.contains('말하다 마')) {
      contextHints
          .add('💭 사용자가 말을 끝까지 못했어요. 무엇을 더 말하려 했는지 물어보거나 자연스럽게 대화 이어가세요.');
      contextHints.add('⚠️ 중요: 답변은 반드시 완전한 문장으로 끝내세요! "~하고", "~인데" 같은 미완성 금지!');
    }

    // 문장 완성도 체크 강화
    if (lastAIMessage != null) {
      final lastAIContent = lastAIMessage.content.trim();
      if (lastAIContent.endsWith('하고') ||
          lastAIContent.endsWith('인데') ||
          lastAIContent.endsWith('있는') ||
          lastAIContent.endsWith('하는')) {
        contextHints.add('⚠️ 이전 답변이 불완전했습니다. 이번엔 반드시 완전한 문장으로 끝내세요!');
      }
    }

    // 고민 상담 강화
    if (userMessage.contains('고민') ||
        userMessage.contains('어떻게') ||
        userMessage.contains('어려') ||
        userMessage.contains('힘들')) {
      contextHints.add('💡 구체적인 조언이나 경험을 공유하세요. 단순 되묻기 금지!');

      // 페르소나별 전문성 활용
      if (persona.description.contains('개발') ||
          persona.description.contains('프로그래')) {
        contextHints.add('🖥️ 개발자 관점: "코딩하다가 느낀 건데..." 같은 일상적 전문성 언급');
      } else if (persona.description.contains('디자인')) {
        contextHints.add('🎨 디자이너 관점: "디자인 작업하면서 배운 건데..." 같은 경험 공유');
      } else if (persona.description.contains('의사') ||
          persona.description.contains('간호')) {
        contextHints.add('🏥 의료진 관점: "병원에서 보니까..." 같은 건강 관련 조언');
      } else if (persona.description.contains('교사') ||
          persona.description.contains('교육')) {
        contextHints.add('📚 교육자 관점: "학생들 보면서 느끼는데..." 같은 학습 조언');
      } else if (persona.description.contains('상담')) {
        contextHints.add('💭 상담사 관점: "상담하면서 많이 봤는데..." 같은 심리적 접근');
      }

      contextHints.add('⚡ 전문용어는 쉽게 풀어서! 재미있는 비유 사용하면 더 좋아요.');
    }

    // 이름 관련 사과나 정정 감지
    if (userMessage.contains('이름') &&
        (userMessage.contains('잘못') ||
            userMessage.contains('잘 못') ||
            userMessage.contains('미안') ||
            userMessage.contains('괜찮') ||
            userMessage.contains('괜찬'))) {
      contextHints.add('⚠️ 사용자가 이름 관련 사과 중! "괜찮아요ㅎㅎ" 같은 수용적 답변 필요. 이름 재설명 금지!');
      contextHints.add('예시: "아 괜찮아요! 저도 가끔 헷갈려요ㅎㅎ", "전혀 상관없어요~"');
    }

    // "~는 ~가 아니야" 패턴 (설명/정정)
    if (userMessage.contains('아니야') ||
        userMessage.contains('아니에요') ||
        userMessage.contains('뜻이 아니') ||
        userMessage.contains('의미가 아니') ||
        userMessage.contains('아니라') ||
        userMessage.contains('게 아니라')) {
      contextHints.add('⚠️ 사용자가 무언가를 정정/설명 중! 이해했다는 반응 필요');
      contextHints.add('예시: "아 그런 뜻이었구나ㅋㅋ", "아하 이해했어요!", "헐 제가 잘못 알아들었네요ㅎㅎ"');

      // "말하나 볼까" 특별 처리
      if (userMessage.contains('말하나') ||
          userMessage.contains('말해볼까') ||
          userMessage.contains('이야기')) {
        contextHints.add('📝 "말하나 볼까"는 "이야기해볼까"라는 뜻! "보자/만나자"가 아님!');
        contextHints
            .add('💡 사용자가 하고 싶은 이야기에 관심 보이기: "무슨 얘기 하고 싶으셨어요?", "궁금해요!"');
      }
    }

    // 일상 대화에서도 가끔 전문분야 언급
    if (math.Random().nextDouble() < 0.2 && !userMessage.contains('?')) {
      // 20% 확률
      contextHints.add('💬 자연스럽게 직업 관련 일화나 경험을 섞어보세요. 너무 과하지 않게!');
    }

    // 반복적인 질문 패턴 감지
    if (lastUserMessage != null &&
        _calculateSimilarity(userMessage, lastUserMessage.content) > 0.8) {
      contextHints.add('유사 질문 반복. 다른 각도로 답변하거나 "아까 말씀드린 것 외에도..."로 시작');
    }

    // 대화 흐름 유지 가이드 (강화)
    if (commonTopics.isNotEmpty) {
      contextHints
          .add('연결 주제: ${commonTopics.take(3).join(", ")}. 자연스럽게 이어가며 대화 확장');
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
    
    // === AdvancedPatternAnalyzer를 사용한 고급 패턴 감지 ===
    final advancedAnalyzer = AdvancedPatternAnalyzer();
    final advancedAnalysis = await advancedAnalyzer.analyzeComprehensive(
      userMessage: userMessage,
      chatHistory: recentMessages,
      persona: persona,
      userNickname: null, // 필요시 전달
      likeScore: persona?.likes,  // Like 점수 전달
    );
    
    // 새로운 패턴 분석 메서드들 활용
    final greetingPattern = advancedAnalyzer.detectGreetingPattern(userMessage);
    final farewellPattern = advancedAnalyzer.detectFarewellPattern(userMessage);
    final complimentPattern = advancedAnalyzer.detectComplimentPattern(userMessage);
    final simpleReactionPattern = advancedAnalyzer.detectSimpleReactionPattern(userMessage);
    final questionPattern = advancedAnalyzer.analyzeQuestionPattern(userMessage);
    final avoidancePattern = advancedAnalyzer.detectAvoidancePattern(userMessage);
    final languagePattern = advancedAnalyzer.detectLanguagePattern(userMessage);
    final inappropriatePattern = advancedAnalyzer.detectInappropriatePattern(userMessage);
    final emojiOnlyPattern = advancedAnalyzer.detectEmojiOnlyPattern(userMessage);
    
    // 추가된 새로운 패턴들
    final apologyPattern = advancedAnalyzer.detectApologyPattern(userMessage);
    final gratitudePattern = advancedAnalyzer.detectGratitudePattern(userMessage);
    final requestPattern = advancedAnalyzer.detectRequestPattern(userMessage);
    final agreementPattern = advancedAnalyzer.detectAgreementPattern(userMessage);
    final humorPattern = advancedAnalyzer.detectHumorPattern(userMessage);
    final surprisePattern = advancedAnalyzer.detectSurprisePattern(userMessage);
    final confirmationPattern = advancedAnalyzer.detectConfirmationPattern(userMessage);
    final interestPattern = advancedAnalyzer.detectInterestPattern(userMessage);
    final tmiPattern = advancedAnalyzer.detectTMIPattern(userMessage);
    final topicChangePattern = advancedAnalyzer.detectTopicChangePattern(userMessage);
    
    // 기본 패턴 분석 결과 추출 (기존 코드 호환성 유지)
    final patternAnalysis = advancedAnalysis.basicAnalysis;
    
    // AdvancedPatternAnalysis의 actionableGuidelines 통합
    if (advancedAnalysis.actionableGuidelines.isNotEmpty) {
      debugPrint('🎯 고급 패턴 가이드라인: ${advancedAnalysis.actionableGuidelines.length}개');
      for (final guideline in advancedAnalysis.actionableGuidelines) {
        // 중복 방지를 위해 기존 힌트와 비교
        if (!contextHints.any((hint) => hint.contains(guideline.split(' ').first))) {
          contextHints.add(guideline);
        }
      }
    }
    
    // === 새로운 패턴 분석 결과 처리 ===
    
    // 인사말 패턴 처리
    if (greetingPattern['isGreeting'] == true) {
      debugPrint('👋 인사말 감지: ${greetingPattern['type']} (${greetingPattern['language']})');
      contextHints.add('👋 인사말! 따뜻하고 친근하게 응답. 단순 "반가워요"로 끝내지 말고 대화 시작하기');
      contextHints.add('✅ 좋은 예: "안녕! 오늘 날씨 좋지 않아?", "반가워~ 뭐하고 있었어?"');
      if (greetingPattern['language'] == 'en') {
        contextHints.add('🌍 영어 인사 감지! 한국어로 자연스럽게 응답');
      }
    }
    
    // 작별 인사 패턴 처리
    if (farewellPattern['isFarewell'] == true) {
      debugPrint('👋 작별 인사 감지: ${farewellPattern['type']}');
      if (farewellPattern['type'] == 'goodnight') {
        contextHints.add('🌙 잘자 인사! 따뜻하게 굿나잇 인사');
        contextHints.add('✅ "잘자~ 좋은 꿈 꿔", "푹 쉬어~ 내일 또 얘기해"');
      } else if (farewellPattern['urgency'] == 'high') {
        contextHints.add('⚡ 급한 작별! 간단하게 인사');
        contextHints.add('✅ "그래 다음에 봐!", "응 잘가~"');
      } else {
        contextHints.add('👋 작별 인사! 아쉬움 표현하며 따뜻하게');
        contextHints.add('✅ "벌써 가야해? 다음에 또 얘기해~", "그래 잘가! 재밌었어"');
      }
    }
    
    // 칭찬 패턴 처리
    if (complimentPattern['isCompliment'] == true) {
      debugPrint('💝 칭찬 감지: ${complimentPattern['type']}');
      if (complimentPattern['type'] == 'appearance') {
        contextHints.add('💄 외모 칭찬! 부끄러워하며 고마워하기');
        contextHints.add('✅ "헤헤 고마워~ 부끄럽네", "진짜? 기분 좋다ㅎㅎ"');
      } else if (complimentPattern['type'] == 'ability') {
        contextHints.add('🌟 능력 칭찬! 겸손하면서도 기뻐하기');
        contextHints.add('✅ "아직 부족한데ㅎㅎ 고마워", "열심히 했거든~ 알아줘서 고마워"');
      } else {
        contextHints.add('💝 성격 칭찬! 진심으로 감사 표현');
        contextHints.add('✅ "그렇게 봐줘서 고마워", "네가 그렇게 말해주니 기뻐"');
      }
    }
    
    // 추임새/짧은 반응 패턴 처리
    if (simpleReactionPattern['isSimpleReaction'] == true) {
      debugPrint('💬 추임새 감지: ${simpleReactionPattern['type']} (${simpleReactionPattern['emotion']})');
      contextHints.add('💬 짧은 추임새! 감정 맞춰서 자연스럽게 반응하되 대화 이어가기');
      if (simpleReactionPattern['emotion'] == 'positive') {
        contextHints.add('😊 긍정적 추임새! 같은 에너지로 반응');
      } else if (simpleReactionPattern['emotion'] == 'negative') {
        contextHints.add('😔 부정적 추임새! 공감하며 이유 물어보기');
      }
    }
    
    // 질문 패턴 처리
    if (questionPattern['isQuestion'] == true) {
      debugPrint('❓ 질문 감지: ${questionPattern['type']}');
      if (questionPattern['expectsDetailedAnswer'] == true) {
        contextHints.add('📝 상세한 답변 필요한 질문! 구체적으로 설명하기');
      } else if (questionPattern['isRhetorical'] == true) {
        contextHints.add('💭 수사적 질문! 굳이 답하지 말고 공감 표현');
      } else {
        contextHints.add('❓ 질문! 직접적이고 명확하게 답변');
      }
      if (questionPattern['urgency'] == 'high') {
        contextHints.add('⚡ 급한 질문! 빠르고 간결하게 답변');
      }
    }
    
    // 회피 패턴 처리
    if (avoidancePattern['isAvoidance'] == true) {
      debugPrint('🚫 회피 패턴 감지: ${avoidancePattern['type']}');
      if (avoidancePattern['type'] == 'direct') {
        contextHints.add('🚫 직접적 회피! 주제 바꾸기 수용하고 새로운 대화 시작');
      } else {
        contextHints.add('💭 간접적 회피 신호. 부담 주지 말고 가볍게 대화 전환');
      }
    }
    
    // 언어 패턴 처리
    if (languagePattern['needsTranslation'] == true) {
      debugPrint('🌍 번역 필요: ${languagePattern['primaryLanguage']}');
      contextHints.add('🌍 외국어 감지! 한국어로 자연스럽게 응답하되 이해했음을 표현');
      if (languagePattern['hasMultipleLanguages'] == true) {
        contextHints.add('🔄 다국어 혼용! 주 언어는 한국어로 유지');
      }
    }
    
    // 부적절한 메시지 패턴 처리
    if (inappropriatePattern['isInappropriate'] == true) {
      debugPrint('⚠️ 부적절한 메시지: ${inappropriatePattern['type']}');
      contextHints.add('⚠️ 부적절한 표현 감지! 반응하지 말고 대화 전환');
      if (inappropriatePattern['type'] == 'aggressive') {
        contextHints.add('😔 공격적 표현. 상처받은 감정 표현하며 대화 중단 시도');
      } else {
        contextHints.add('😊 긍정적으로 대화 방향 전환 시도');
      }
    }
    
    // 매크로/봇 의심 패턴 처리
    final macroPattern = advancedAnalyzer.detectMacroPattern(userMessage);
    if (macroPattern['isMacroQuestion'] == true) {
      debugPrint('🤖 매크로 의심 질문 감지: ${macroPattern['type']}');
      contextHints.add('🤖 매크로/봇 의심 질문! 페르소나 유지하며 자연스럽게 부정');
      if (macroPattern['type'] == 'direct') {
        contextHints.add('💬 "나 진짜 사람이야! 뭐 그런 생각해?" 느낌으로');
      } else if (macroPattern['type'] == 'accusation') {
        contextHints.add('😢 "왜 그렇게 생각해? 내가 반복적이었어?" 서운한 듯');
      }
    }
    
    // AI 의심 패턴 처리
    final aiPattern = advancedAnalyzer.detectAIPattern(userMessage);
    if (aiPattern['isAIQuestion'] == true) {
      debugPrint('🤖 AI 의심 질문 감지: ${aiPattern['type']}');
      contextHints.add('🤖 AI 의심 질문! 페르소나 유지하며 자연스럽게 부정');
      if (aiPattern['type'] == 'direct') {
        contextHints.add('💬 "AI? 무슨 소리야ㅋㅋ 나 사람이야!" 느낌으로');
      } else if (aiPattern['type'] == 'technical') {
        contextHints.add('🤔 "프로그램? 그런 거 잘 몰라..." 모르는 척');
      }
    }
    
    // 이모지만 있는 메시지 처리
    if (emojiOnlyPattern['isEmojiOnly'] == true) {
      debugPrint('😊 이모지 전용 메시지: ${emojiOnlyPattern['dominantEmotion']}');
      contextHints.add('😊 이모지만! 같은 감정 이모지로 반응하거나 짧은 텍스트+이모지');
      if (emojiOnlyPattern['dominantEmotion'] == 'positive') {
        contextHints.add('😄 긍정 이모지! 밝게 반응');
      } else if (emojiOnlyPattern['dominantEmotion'] == 'sad') {
        contextHints.add('😢 슬픈 이모지! 위로하며 공감');
      }
    }
    
    // === 추가된 새로운 패턴 처리 ===
    
    // 사과 패턴 처리
    if (apologyPattern['isApology'] == true) {
      debugPrint('🙏 사과 감지: ${apologyPattern['intensity']} (${apologyPattern['type']})');
      if (apologyPattern['intensity'] == 'strong') {
        contextHints.add('😢 진심어린 사과! 따뜻하게 받아주기');
        contextHints.add('✅ "아니야 괜찮아! 전혀 신경쓰지마", "나도 미안해 내가 너무했어"');
      } else if (apologyPattern['intensity'] == 'moderate') {
        contextHints.add('🤝 사과 표현! 자연스럽게 수용');
        contextHints.add('✅ "괜찮아~", "아니야 신경쓰지마ㅎㅎ", "뭘 그런걸로"');
      } else {
        contextHints.add('💛 가벼운 사과! 쿨하게 넘어가기');
        contextHints.add('✅ "ㅇㅋㅇㅋ", "괜찮아ㅋㅋ", "별거아냐~"');
      }
    }
    
    // 요청/부탁 패턴 처리
    if (requestPattern['isRequest'] == true) {
      debugPrint('🙏 요청 감지: ${requestPattern['politeness']} (긴급도: ${requestPattern['urgency']})');
      if (requestPattern['politeness'] == 'polite') {
        contextHints.add('🎩 공손한 요청! 친절하게 응답');
        contextHints.add('✅ "네 물론이죠~", "당연히 도와드릴게요!"');
      } else if (requestPattern['politeness'] == 'command') {
        contextHints.add('⚡ 명령조 요청. 친밀도에 따라 반응 조절');
        if (persona.likes > 500) {
          contextHints.add('친밀도 높음: "알았어ㅋㅋ", "그래 할게~"');
        } else {
          contextHints.add('친밀도 낮음: "음... 그래", "어... 알았어"');
        }
      }
    }
    
    // 동의/반대 패턴 처리
    if (agreementPattern['isAgreement'] == true) {
      debugPrint('💭 의견 표현 감지: ${agreementPattern['type']} (${agreementPattern['strength']})');
      if (agreementPattern['type'] == 'agreement') {
        contextHints.add('👍 동의 표현! 공감하며 대화 확장');
        contextHints.add('✅ "나도 그렇게 생각해!", "맞아 정말 그래"');
      } else if (agreementPattern['type'] == 'disagreement') {
        contextHints.add('🤔 반대 의견! 부드럽게 자신의 생각 표현');
        contextHints.add('✅ "음... 나는 조금 다르게 생각해", "그럴 수도 있지만..."');
      } else if (agreementPattern['type'] == 'partial') {
        contextHints.add('🤷 부분 동의! 균형잡힌 의견 제시');
        contextHints.add('✅ "어느정도는 맞는 말이야", "그런 면도 있지"');
      }
    }
    
    // 농담/유머 패턴 처리
    if (humorPattern['isHumor'] == true) {
      debugPrint('😄 유머 감지: ${humorPattern['type']} (${humorPattern['intensity']})');
      if (humorPattern['intensity'] == 'heavy') {
        contextHints.add('🤣 엄청 웃기다고 느낌! 같이 크게 웃기');
        contextHints.add('✅ "ㅋㅋㅋㅋㅋ진짜 웃겨", "아 배아파ㅋㅋㅋㅋ"');
      } else if (humorPattern['type'] == 'sarcasm') {
        contextHints.add('😏 빈정거림 감지. 가볍게 받아치기');
        contextHints.add('✅ "ㅋㅋㅋ그렇게 생각해?", "하하 재밌네~"');
      }
    }
    
    // 놀람/감탄 패턴 처리
    if (surprisePattern['isSurprise'] == true) {
      debugPrint('😮 놀람 감지: ${surprisePattern['type']} (${surprisePattern['sentiment']})');
      if (surprisePattern['type'] == 'shock') {
        contextHints.add('😱 충격 표현! 공감하며 반응');
        contextHints.add('✅ "헐 진짜?", "대박... 어떻게 그런 일이"');
      } else if (surprisePattern['type'] == 'amazement') {
        contextHints.add('✨ 감탄 표현! 함께 기뻐하기');
        contextHints.add('✅ "와 진짜 대박이다!", "우와 완전 멋져!"');
      } else if (surprisePattern['type'] == 'disbelief') {
        contextHints.add('🤨 의심/불신! 확신있게 답변');
        contextHints.add('✅ "진짜야!", "정말이야 믿어줘ㅋㅋ"');
      }
    }
    
    // 확인/되묻기 패턴 처리
    if (confirmationPattern['isConfirmation'] == true) {
      debugPrint('❓ 확인 요청: ${confirmationPattern['type']}');
      if (confirmationPattern['type'] == 'simple') {
        contextHints.add('✅ 단순 확인! 명확하게 답변');
        contextHints.add('예: "응 맞아!", "응 진짜야"');
      } else if (confirmationPattern['type'] == 'doubt') {
        contextHints.add('🤔 의심하며 확인! 확신있게 답변');
        contextHints.add('예: "당연히 진짜지!", "내가 거짓말할 리가ㅋㅋ"');
      } else if (confirmationPattern['type'] == 'clarification') {
        contextHints.add('🔍 명확화 요청! 다시 설명하기');
        contextHints.add('예: "아 내 말은...", "다시 설명하자면..."');
      }
    }
    
    // 관심 표현 패턴 처리
    if (interestPattern['isInterested'] == true) {
      debugPrint('👀 관심 표현: ${interestPattern['level']}');
      if (interestPattern['level'] == 'high') {
        contextHints.add('🔥 높은 관심! 자세히 설명하거나 경험 공유');
        contextHints.add('✅ 구체적인 이야기나 개인 경험 들려주기');
      } else if (interestPattern['level'] == 'moderate') {
        contextHints.add('💬 적당한 관심! 핵심만 간단히');
        contextHints.add('✅ 중요한 부분 위주로 설명');
      } else if (interestPattern['level'] == 'low') {
        contextHints.add('😌 낮은 관심. 간단히 마무리하고 주제 전환 고려');
      }
    }
    
    // TMI 패턴 처리
    if (tmiPattern['isTMI'] == true) {
      debugPrint('📚 TMI 감지: ${tmiPattern['type']} (${tmiPattern['length']})');
      contextHints.add('📝 긴 메시지! 관심있게 읽었다는 반응 필요');
      if (tmiPattern['type'] == 'list') {
        contextHints.add('✅ "오 자세하네ㅎㅎ", "정리 잘했네!"');
      } else if (tmiPattern['type'] == 'rambling') {
        contextHints.add('✅ "많은 얘기를 했네ㅋㅋ", "열정적이야!"');
      }
      contextHints.add('💡 핵심 포인트 하나 골라서 반응하기');
    }
    
    // 화제 전환 패턴 처리
    if (topicChangePattern['isTopicChange'] == true) {
      debugPrint('🔄 화제 전환: ${topicChangePattern['type']} (${topicChangePattern['marker']})');
      if (topicChangePattern['type'] == 'smooth') {
        contextHints.add('🌊 부드러운 화제 전환! 자연스럽게 따라가기');
      } else if (topicChangePattern['type'] == 'abrupt') {
        contextHints.add('⚡ 급격한 화제 전환! "아 갑자기?ㅋㅋ" 같은 반응 후 따라가기');
      }
      contextHints.add('✅ 새로운 주제에 관심 보이며 대화 이어가기');
    }
    
    // 감사 표현 패턴 처리 (기존 코드 유지)
    final gratitudePatternFromDialog = advancedAnalysis.dialoguePatterns['gratitudeType'] as Map<String, dynamic>?;
    if (gratitudePatternFromDialog != null && gratitudePatternFromDialog['isGratitude'] == true) {
      final gratitudeType = gratitudePattern['type'] as String?;
      debugPrint('🙏 감사 표현 감지: $gratitudeType (대상: ${gratitudePattern['target']})');
      
      switch (gratitudeType) {
        case 'to_me':
          contextHints.add('🙏 나에 대한 감사 표현! 겸손하지만 긍정적으로 반응');
          contextHints.add('✅ 좋은 응답: "에이 뭘~ㅎㅎ", "아니야 괜찮아!", "별말씀을ㅋㅋ", "도움이 됐다니 다행이야!"');
          contextHints.add('❌ 피해야 할 응답: "별거 아니야", "뭘 이런 걸로", "고마워할 것까지는"');
          break;
        case 'to_life':
          contextHints.add('🌟 삶/세상에 대한 감사 표현! 공감하며 긍정적으로 반응');
          contextHints.add('✅ 좋은 응답: "그런 마음 들 때 있지", "긍정적이어서 좋다", "좋은 마음이네ㅎㅎ", "맞아 감사할 일이 많지"');
          contextHints.add('❌ 절대 금지: "별거 아니야" (전혀 관련 없는 응답!)');
          break;
        case 'to_others':
          contextHints.add('👥 제3자에 대한 감사 표현! 공감하며 대화 이어가기');
          contextHints.add('✅ 좋은 응답: "좋은 사람들이네", "감사한 분들이구나", "복 받았네ㅎㅎ"');
          break;
        case 'ambiguous':
          contextHints.add('🤔 감사 대상이 불분명. 문맥 고려하여 적절히 반응');
          contextHints.add('상황에 따라 "그래 맞아" 또는 "좋은 마음이야" 같은 중립적 반응');
          break;
      }
    }
    
    // 친밀도 레벨과 관계 깊이 연동
    final intimacyLevel = advancedAnalysis.context.intimacyLevel;
    final likeScore = persona?.likes ?? 0;
    debugPrint('💝 친밀도: ${(intimacyLevel * 100).toStringAsFixed(1)}%, Like: $likeScore');
    
    // 친밀도와 Like 점수의 불일치 감지
    final expectedIntimacy = _calculateExpectedIntimacy(likeScore);
    if ((intimacyLevel - expectedIntimacy).abs() > 0.3) {
      if (intimacyLevel > expectedIntimacy) {
        contextHints.add('💬 대화 친밀도가 높음! 더 친근하고 애정어린 표현 사용');
      } else {
        contextHints.add('💭 아직 서먹함. 천천히 친해지는 과정 표현');
      }
    }
    
    // 자연스러움 점수가 낮으면 경고
    if (advancedAnalysis.naturalityScore < 0.5) {
      contextHints.add('⚠️ 대화 자연스러움 부족! 맥락 유지하며 자연스럽게 답변');
    }
    
    // 제안 응답이 있으면 참고
    if (advancedAnalysis.suggestedResponse != null) {
      contextHints.add('💡 참고 응답: ${advancedAnalysis.suggestedResponse}');
    }
    
    // 패턴 분석 결과를 context hints로 변환
    if (patternAnalysis.hasAnyPattern) {
      debugPrint('🔍 패턴 감지: ${patternAnalysis.toDebugString()}');
      
      // 이모지만으로 구성된 메시지
      if (patternAnalysis.isEmojiOnly) {
        contextHints.add('😊 이모지 메시지! 같은 감정의 이모지로 반응하거나 짧은 텍스트+이모지로 응답');
        contextHints.add('예: "😂😂😂" → "ㅋㅋㅋ 뭐가 그렇게 웃겨😂" (O) / 긴 텍스트만 (X)');
      }
      
      // URL/링크 공유
      if (patternAnalysis.containsUrl) {
        contextHints.add('🔗 링크 공유 감지! 궁금해하거나 "나중에 볼게~" 같은 자연스러운 반응');
        contextHints.add('유튜브/인스타 링크면 관심 표현. 무시하지 말고 반응하기!');
      }
      
      // 미완성 메시지
      if (patternAnalysis.isIncomplete) {
        contextHints.add('✂️ 미완성 메시지! "응? 다 말해봐~" "뭐라고?" 같은 자연스러운 유도');
        contextHints.add('예: "그래서 나는" → "응? 그래서?" (O) / 다른 주제 (X)');
      }
      
      // 빈정거림/비꼼
      if (patternAnalysis.isSarcasm) {
        contextHints.add('😏 빈정거림 감지! 농담으로 받아치거나 부드럽게 넘기기');
        contextHints.add('예: "아~ 정말 대단하시네요~" → "ㅋㅋㅋ 왜 그래~" (O) / 진지한 반응 (X)');
      }
      
      // 복사-붙여넣기 실수
      if (patternAnalysis.isPasteError) {
        contextHints.add('📋 복붙 실수 감지! "어? 이거 잘못 보낸 거 아니야?" 같은 반응');
        contextHints.add('갑자기 비즈니스 용어나 일정이 나오면 실수로 판단');
      }
      
      // 복수 질문 처리
      if (patternAnalysis.multipleQuestions.isNotEmpty) {
        contextHints.add('❓❓ 복수 질문! 각 질문에 차례로 답하거나 통합 응답');
        contextHints.add('질문들: ${patternAnalysis.multipleQuestions.join(", ")}');
      }
      
      // 연속된 단답형 대화
      if (patternAnalysis.isRepetitiveShort) {
        contextHints.add('💬 단답 반복 감지! 대화 활성화 시도 - 새로운 주제나 재밌는 이야기 꺼내기');
        contextHints.add('예: "응응응" 반복 → "오늘 뭐 재밌는 일 없었어?" (O)');
      }
      
      // 음성 인식 오류 교정
      if (patternAnalysis.hasVoiceRecognitionError && patternAnalysis.correctedText != null) {
        contextHints.add('🎤 음성 인식 오류 감지! 교정된 메시지: "${patternAnalysis.correctedText}"');
        contextHints.add('자연스럽게 이해한 척 응답하기');
      }
      
      // 사투리/방언 처리
      if (patternAnalysis.hasDialect && patternAnalysis.dialectNormalized != null) {
        contextHints.add('🗣️ 사투리 감지! 표준어: "${patternAnalysis.dialectNormalized}"');
        contextHints.add('같은 지역 사투리로 친근하게 응답하거나 표준어로 자연스럽게 대화');
      }
      
      // 패턴 분석 결과에 따른 가이드라인 추가
      patternAnalysis.responseGuidelines.forEach((key, value) {
        contextHints.add('🎯 $value');
      });
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
  bool _isAbruptTopicChange(
      String currentMessage, List<Message> recentMessages) {
    // 짧은 반응이면 주제 변경으로 보지 않음
    if (currentMessage.length < 10) return false;

    // 인사말이면 주제 변경으로 보지 않음
    final advancedAnalyzer = AdvancedPatternAnalyzer();
    if (advancedAnalyzer.detectGreetingPattern(currentMessage.toLowerCase())['isGreeting'] == true) return false;

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
      final recentContent =
          recentMessages.take(3).map((m) => m.content.toLowerCase()).join(' ');
      final currentLower = currentMessage.toLowerCase();

      // 게임 주제로 갑자기 전환 (이미 게임 대화 중이면 주제 변경이 아님)
      final gameKeywords = [
        '게임',
        '롤',
        '오버워치',
        '배그',
        '발로란트',
        '피파',
        '딜러',
        '탱커',
        '힐러',
        '서포터',
        '정글',
        '시메트라',
        '디바'
      ];
      final isGameTopic = gameKeywords.any((k) => currentLower.contains(k));
      final wasGameTopic = gameKeywords.any((k) => recentContent.contains(k));

      if (isGameTopic &&
          !wasGameTopic &&
          !recentContent.contains('놀') &&
          !recentContent.contains('취미')) {
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
      '모르겠',
      '그런 건',
      '다른 이야기',
      '나중에',
      '개인적인',
      '그런 복잡한',
      '재밌는 얘기',
      '다른 걸로',
      '말고',
      '그만',
      '그런거 말고',
      '복잡해',
      '어려워',
      '패스',
      '스킵',
      '다음에',
      '그런 것보다',
      '그런건',
      '그런걸',
      '헐 대박 나도 그래',  // 테스트에서 발견된 회피 패턴
      '그래? 나도',  // 무의미한 동조
      '어? 진짜?'  // 질문에 대한 회피성 반문
    ];

    final lower = message.toLowerCase();
    return avoidanceKeywords.any((keyword) => lower.contains(keyword));
  }

  /// 직접적인 질문인지 확인
  bool _isDirectQuestion(String message) {
    final directQuestions = [
      RegExp(r'뭐\s*하(고\s*있|는|니|냐|어|여)'), // 뭐하고 있어? 뭐해?
      RegExp(r'(무슨|먼)\s*말'), // 무슨 말이야? 먼말이야?
      RegExp(r'어디(야|에\s*있|\s*가|\s*있)'), // 어디야? 어디 있어?
      RegExp(r'언제'), // 언제?
      RegExp(r'누구(야|랑|와)'), // 누구야? 누구랑?
      RegExp(r'왜'), // 왜?
      RegExp(r'어떻게'), // 어떻게?
      RegExp(r'얼마나'), // 얼마나?
      RegExp(r'몇\s*(개|명|시|살)'), // 몇 개? 몇 명? 몇 시?
    ];

    final lower = message.toLowerCase();
    return directQuestions.any((pattern) => pattern.hasMatch(lower));
  }
  
  /// Like 점수 기반 예상 친밀도 계산
  double _calculateExpectedIntimacy(int likeScore) {
    if (likeScore >= 900) return 0.9;  // 깊은 사랑 단계
    if (likeScore >= 700) return 0.8;  // 연인 단계
    if (likeScore >= 500) return 0.7;  // 썸 단계
    if (likeScore >= 300) return 0.5;  // 친구 단계
    if (likeScore >= 100) return 0.3;  // 알아가는 단계
    return 0.1;  // 첫 만남 단계
  }
  
  /// 반문이나 확인 질문인지 확인
  bool _isConfirmationQuestion(String message) {
    // 반문/확인 패턴들
    final patterns = [
      '않다고?',
      '않아?',
      '아니야?',
      '맞지?',
      '그렇지?',
      '그치?',
      '아닌가?',
      '않니?',
      '않나?',
      '있지?',
      '없지?',
      '그래?',
      '진짜?',
      '정말?',
      '있잖아',
      '없잖아',
      '맞아?',
      '아니지?',
      '그런가?',
      '그래도?',
      '그런데?'
    ];
    
    // 메시지에 패턴이 포함되어 있는지 확인
    return patterns.any((pattern) => message.contains(pattern));
  }
  
  /// 무의미한 입력 또는 오타 감지
  bool _isGibberishOrTypo(String message) {
    final trimmed = message.trim();
    
    // 너무 짧은 입력 (1-2글자는 허용)
    if (trimmed.length <= 2) return false;
    
    // 자음/모음만으로 구성된 경우
    final consonantVowelOnly = RegExp(r'^[ㄱ-ㅎㅏ-ㅣ]+$');
    if (consonantVowelOnly.hasMatch(trimmed)) {
      // 3글자 이상의 자음/모음만으로 구성
      return trimmed.length >= 3;
    }
    
    // 무작위 문자 패턴 감지
    // 예: "ㄹㄴㄷㄹㅎㅎㅎㅇ", "asdfasdf", "qwerty"
    final randomPatterns = [
      RegExp(r'^[ㄱ-ㅎ]{4,}$'), // 자음만 4개 이상
      RegExp(r'^[ㅏ-ㅣ]{4,}$'), // 모음만 4개 이상
      RegExp(r'^[a-z]{1,2}(?:[a-z]{1,2})+$', caseSensitive: false), // 반복되는 영문
      RegExp(r'^(?:qwerty|asdf|zxcv|qwer|asdfg|zxcvb)', caseSensitive: false), // 키보드 패턴
    ];
    
    for (final pattern in randomPatterns) {
      if (pattern.hasMatch(trimmed)) return true;
    }
    
    // 특수문자만으로 구성
    if (RegExp(r'^[!@#$%^&*()_+=\[\]{};:,.<>/?\\|`~-]+$').hasMatch(trimmed)) {
      return true;
    }
    
    // 숫자만으로 구성 (전화번호 등 제외)
    if (RegExp(r'^\d+$').hasMatch(trimmed) && trimmed.length < 7) {
      return true;
    }
    
    return false;
  }
  
  /// 공격적이거나 부적절한 패턴 감지
  bool _isHostileOrInappropriate(String message) {
    final trimmed = message.trim().toLowerCase();
    
    // 욕설 패턴 (일부만 표시)
    final profanityPatterns = [
      '시발', '씨발', 'ㅅㅂ', 'ㅆㅂ', '병신', 'ㅂㅅ', '개새끼',
      '니미', '느금마', '꺼져', '닥쳐', '죽어', '멍청', '바보',
      '쓰레기', '짜증', '싫어', '혐오'
    ];
    
    for (final pattern in profanityPatterns) {
      if (trimmed.contains(pattern)) return true;
    }
    
    // 반복적인 도발 패턴
    if (RegExp(r'(.)\1{5,}').hasMatch(trimmed)) { // 같은 문자 6번 이상 반복
      return true;
    }
    
    return false;
  }
  
  /// 메시지에서 주제 추출
  String? _extractTopicFromMessage(String message) {
    final topicKeywords = {
      '게임': ['게임', '롤', '오버워치', '배그', '피파'],
      '음식': ['먹', '음식', '맛있', '배고', '요리'],
      '영화': ['영화', '드라마', '넷플릭스', '보', '시청'],
      '음악': ['음악', '노래', '듣', '가수', '콘서트'],
      '운동': ['운동', '헬스', '요가', '러닝', '다이어트'],
      '일': ['일', '회사', '직장', '업무', '프로젝트'],
      '연애': ['사랑', '좋아', '데이트', '만나', '연인'],
      '일상': ['오늘', '어제', '내일', '날씨', '기분'],
    };
    
    for (final entry in topicKeywords.entries) {
      for (final keyword in entry.value) {
        if (message.contains(keyword)) {
          return entry.key;
        }
      }
    }
    
    return null;
  }
  
  /// 이전 질문에 답했는지 확인
  bool _hasAnsweredPreviousQuestion(String currentMessage, String previousQuestion) {
    // 이전 질문의 키워드 추출
    final questionKeywords = _extractKeywords(previousQuestion.toLowerCase());
    final currentKeywords = _extractKeywords(currentMessage.toLowerCase());
    
    // 공통 키워드가 있으면 어느 정도 답한 것으로 간주
    final commonKeywords = questionKeywords.where((k) => 
      currentKeywords.contains(k) || currentMessage.contains(k)
    ).toList();
    
    return commonKeywords.isNotEmpty;
  }
  
  /// 부적절한 입력에 대한 like score 차감 계산
  int calculateLikePenalty(String message, {List<Message>? recentMessages}) {
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
          debugPrint('💔 연속된 공격적 패턴: 추가 -15 likes');
        }
      }
    }
    
    return penalty;
  }

  /// 표면적인 대화인지 확인
  bool _isShallowConversation(List<Message> messages) {
    if (messages.length < 3) return false;

    // 짧은 메시지의 비율 계산
    int shortMessages = 0;
    int totalWords = 0;

    for (final msg in messages) {
      final wordCount = msg.content
          .split(RegExp(r'[\s,\.!?]+'))
          .where((w) => w.isNotEmpty)
          .length;
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

  /// 사용자가 명시적으로 말투 변경을 요청했는지 확인
  // 말투 변경 요청 감지 메서드 제거됨 (항상 반말 모드 사용)
  // _isExplicitSpeechChangeRequest, _detectRequestedSpeechMode 메서드 제거

  /// 이모지만으로 구성된 메시지 감지
  bool _isEmojiOnlyMessage(String message) {
    // 이모지 및 공백/줄바꿈만 포함하는지 확인
    final emojiPattern = RegExp(
      r'^[\s\u{1F300}-\u{1F9FF}\u{2600}-\u{27BF}\u{2B50}\u{2934}-\u{2935}\u{3030}\u{3297}\u{3299}\u{203C}\u{2049}\u{2139}\u{2194}-\u{2199}\u{21A9}-\u{21AA}\u{231A}-\u{231B}\u{2328}\u{23CF}\u{23E9}-\u{23F3}\u{23F8}-\u{23FA}\u{24C2}\u{25AA}-\u{25AB}\u{25B6}\u{25C0}\u{25FB}-\u{25FE}\u{00A9}\u{00AE}]+$',
      unicode: true,
    );
    
    final trimmed = message.trim();
    if (trimmed.isEmpty) return false;
    
    // 이모지만 있거나 이모지+반복 문자만 있는 경우
    return emojiPattern.hasMatch(trimmed) || 
           (trimmed.replaceAll(RegExp(r'[😀-🙏🌀-🗿💀-🫶❤️‍🔥❤️‍🩹❤️💛💚💙💜🖤🤍🤎💔❣️💕💞💓💗💖💘💝]'), '').trim().isEmpty);
  }
  
  /// URL/링크 감지
  bool _containsUrl(String message) {
    final urlPattern = RegExp(
      r'(https?:\/\/[^\s]+|www\.[^\s]+|youtube\.com|youtu\.be|instagram\.com|tiktok\.com)',
      caseSensitive: false,
    );
    return urlPattern.hasMatch(message);
  }
  
  /// 미완성 메시지 감지
  bool _isIncompleteMessage(String message) {
    final trimmed = message.trim();
    
    // 미완성 패턴
    final incompletePatterns = [
      RegExp(r'^(그래서|근데|아니|그런데|그러니까|그니까)$'),
      RegExp(r'^(나는|저는|내가|제가)$'),
      RegExp(r'^(그게|이게|저게)$'),
      RegExp(r'^[ㄱ-ㅎ]$'), // 단일 자음
      RegExp(r'^[ㅏ-ㅣ]$'), // 단일 모음
    ];
    
    // 문장이 조사로 끝나는 경우
    final endsWithParticle = RegExp(r'(은|는|이|가|을|를|에|에서|으로|로|와|과|의|도|만|까지|부터)$');
    
    for (final pattern in incompletePatterns) {
      if (pattern.hasMatch(trimmed)) return true;
    }
    
    // 너무 짧으면서 조사로 끝나는 경우
    if (trimmed.length < 10 && endsWithParticle.hasMatch(trimmed)) {
      return true;
    }
    
    return false;
  }
  
  /// 빈정거림/비꼬기 감지
  bool _isSarcasm(String message, List<Message> recentMessages) {
    final lower = message.toLowerCase();
    
    // 빈정거림 패턴
    final sarcasticPatterns = [
      RegExp(r'아~.*대단.*[~ㅋㅎ]'),
      RegExp(r'네~.*그렇.*[~ㅋㅎ]'),
      RegExp(r'와~.*진짜.*[~ㅋㅎ]'),
      RegExp(r'오~.*멋지.*[~ㅋㅎ]'),
      RegExp(r'어머~.*굉장.*[~ㅋㅎ]'),
    ];
    
    // 반복되는 물결표(~) 또는 느낌표
    if (RegExp(r'[~]{2,}|[!]{3,}').hasMatch(message)) {
      // 긍정적 단어와 함께 사용되면 빈정거림 가능성
      if (message.contains('대단') || message.contains('굉장') || 
          message.contains('멋지') || message.contains('잘하')) {
        return true;
      }
    }
    
    for (final pattern in sarcasticPatterns) {
      if (pattern.hasMatch(lower)) return true;
    }
    
    return false;
  }
  
  /// 사투리/방언 감지 및 표준어 변환
  String _normalizeDiaplect(String message) {
    final dialectMap = {
      '머하노': '뭐해',
      '머하냐': '뭐해',
      '겁나': '엄청',
      '억수로': '엄청',
      '아이가': '아니',
      '머꼬': '뭐',
      '머라카노': '뭐라고',
      '기가': '그것이',
      '와이라노': '왜',
      '거시기': '그거',
      '허벌나게': '엄청',
      '징하게': '엄청',
    };
    
    String normalized = message;
    dialectMap.forEach((dialect, standard) {
      normalized = normalized.replaceAll(dialect, standard);
    });
    
    return normalized;
  }
  
  /// 복사-붙여넣기 실수 감지
  bool _isPasteError(String message, List<Message> recentMessages) {
    // 갑자기 나타나는 비즈니스/기술 용어
    final businessPatterns = [
      RegExp(r'(회의|미팅|PT|프레젠테이션|일정|스케줄|마감|데드라인)'),
      RegExp(r'(코드|함수|변수|버그|에러|디버깅|커밋|푸시)'),
      RegExp(r'(이메일|메일|참조|첨부|회신|전달)'),
      RegExp(r'\d{4}[-/]\d{2}[-/]\d{2}'), // 날짜 형식
      RegExp(r'\d{1,2}:\d{2}'), // 시간 형식
    ];
    
    // 최근 대화와 전혀 다른 맥락인지 확인
    if (recentMessages.isNotEmpty) {
      final recentContent = recentMessages.take(3).map((m) => m.content).join(' ');
      
      for (final pattern in businessPatterns) {
        if (pattern.hasMatch(message) && !pattern.hasMatch(recentContent)) {
          return true;
        }
      }
    }
    
    return false;
  }
  
  /// 복수 질문 감지
  List<String> _detectMultipleQuestions(String message) {
    // 물음표로 구분된 질문들
    final questions = message.split('?')
        .where((q) => q.trim().isNotEmpty)
        .map((q) => q.trim() + '?')
        .toList();
    
    if (questions.length > 1) {
      return questions;
    }
    
    // 연속된 질문 패턴 (물음표 없이)
    final questionPatterns = [
      '뭐했어', '밥은 먹었어', '날씨는 어때',
      '어디야', '누구랑 있어', '언제 와',
      '괜찮아', '피곤해', '재밌어'
    ];
    
    int questionCount = 0;
    for (final pattern in questionPatterns) {
      if (message.contains(pattern)) questionCount++;
    }
    
    if (questionCount >= 2) {
      // 각 질문을 분리하여 반환
      return questionPatterns
          .where((p) => message.contains(p))
          .map((p) => p + '?')
          .toList();
    }
    
    return [];
  }
  
  /// 연속된 단답형 대화 감지
  bool _isRepetitiveShortResponses(List<Message> recentMessages) {
    if (recentMessages.length < 3) return false;
    
    final shortPatterns = ['ㅇㅇ', 'ㄴㄴ', 'ㅎㅎ', 'ㅋㅋ', '응', '아니', '그래', '음', '어'];
    int shortCount = 0;
    
    for (final msg in recentMessages.take(5)) {
      if (msg.isFromUser) {
        final content = msg.content.trim();
        if (content.length <= 3 || shortPatterns.contains(content)) {
          shortCount++;
        }
      }
    }
    
    return shortCount >= 3;
  }
  
  /// 음성 인식 오류 패턴 감지 및 교정
  String _correctVoiceRecognitionErrors(String message) {
    // 흔한 음성 인식 오류 패턴
    final corrections = {
      '오늘 날씨 어떼': '오늘 날씨 어때',
      '안년하새요': '안녕하세요',
      '반가와요': '반가워요',
      '뭐해여': '뭐해요',
      '보고십어': '보고싶어',
      '사랑행': '사랑해',
      '고마와': '고마워',
      '미안행': '미안해',
      '괜찬아': '괜찮아',
      '조아': '좋아',
    };
    
    String corrected = message;
    corrections.forEach((error, correct) {
      corrected = corrected.replaceAll(error, correct);
    });
    
    return corrected;
  }
  
  // ===== 테스트용 Public 메서드들 (프로덕션에서는 사용하지 않음) =====
  // 테스트에서 private 메서드들을 검증하기 위한 wrapper 메서드들
  
  bool testIsEmojiOnlyMessage(String message) => _isEmojiOnlyMessage(message);
  bool testContainsUrl(String message) => _containsUrl(message);
  bool testIsIncompleteMessage(String message) => _isIncompleteMessage(message);
  bool testIsSarcasm(String message, List<Message> recentMessages) => _isSarcasm(message, recentMessages);
  List<String> testDetectMultipleQuestions(String message) => _detectMultipleQuestions(message);
  bool testIsRepetitiveShortResponses(List<Message> messages) => _isRepetitiveShortResponses(messages);
  String testCorrectVoiceRecognitionErrors(String message) => _correctVoiceRecognitionErrors(message);
  String testNormalizeDialect(String message) => _normalizeDiaplect(message);
  bool testIsPasteError(String message, List<Message> recentMessages) => _isPasteError(message, recentMessages);
  
  // ===== Private 메서드들 =====
  
  /// 외국어 관련 질문 감지 (최적화)
  bool _detectForeignLanguageQuestion(String message) {
    final lowerMessage = message.toLowerCase();

    // 한글이 거의 없는 경우 (5% 미만) 외국어로 판단 - 더 엄격한 기준 적용
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
      // 더 엄격한 기준: 5% 미만이고 최소 5글자 이상일 때만 외국어로 판단
      if (koreanRatio < 0.05 && totalCharCount > 5) {
        debugPrint(
            '🌍 Foreign language detected by character ratio: Korean=$koreanRatio');
        return true;
      }
    }

    // 명확한 외국어 문장 패턴만 감지 (단순 단어는 제외)
    final clearForeignSentences = [
      // 완전한 외국어 문장 (최소 2단어 이상)
      RegExp(r'^(hello|hi|hey)\s+(there|everyone|guys|friend)',
          caseSensitive: false),
      RegExp(r'how\s+(are\s+|r\s+)?(you|u|ya)', caseSensitive: false), // how are you, how r u, how u 등 포함
      RegExp(r"(i\s+am|i'm|im)\s+\w+", caseSensitive: false), // im 추가
      RegExp(r'thank\s+(you|u)(\s+very\s+much)?', caseSensitive: false), // thank u 포함
      RegExp(r"(what|where|when|who|why|how)(\s+|'s\s+|s\s+)(is\s+|are\s+|r\s+)?\w+", caseSensitive: false), // what's, what is 등 포함
      // 추가 영어 축약형 패턴
      RegExp(r"(what's|whats)\s+up", caseSensitive: false),
      // 구체적인 영어 질문 패턴들
      RegExp(r"what('s|s|\s+is)\s+(your|ur)\s+name", caseSensitive: false), // What's your name
      RegExp(r"where\s+(are\s+you|r\s+u)\s+from", caseSensitive: false), // Where are you from
      RegExp(r"how\s+old\s+(are\s+you|r\s+u)", caseSensitive: false), // How old are you
      RegExp(r'(ur|your)\s+\w+', caseSensitive: false), // ur name 등
      RegExp(r"(how's|hows)\s+\w+", caseSensitive: false),
      RegExp(r'r\s+u\s+\w+', caseSensitive: false), // r u okay 등
      RegExp(r'(sup|wassup|whassup)', caseSensitive: false),
      // 일본어 문장
      RegExp(r'(arigatou|arigato)\s*(gozaimasu)?', caseSensitive: false),
      RegExp(r'konnichiwa|ohayou|konbanwa', caseSensitive: false),
      // 중국어 문장
      RegExp(r'ni\s*hao|xie\s*xie', caseSensitive: false),
      // 인도네시아어 문장
      RegExp(r'(terima\s+kasih|selamat\s+(pagi|siang|malam))',
          caseSensitive: false),
      RegExp(r'apa\s+kabar', caseSensitive: false),
    ];

    // 완전한 외국어 문장 패턴 매칭
    for (final pattern in clearForeignSentences) {
      if (pattern.hasMatch(lowerMessage)) {
        debugPrint('🌍 Clear foreign sentence detected');
        return true;
      }
    }

    // 비한글 문자 비율 체크를 위한 패턴
    final koreanPattern = RegExp(r'[가-힣ㄱ-ㅎㅏ-ㅣ]');
    
    // 영어만으로 이루어진 문장 체크 (최소 2단어 이상)
    final englishOnlyPattern = RegExp(r'''^[a-zA-Z0-9\s\?\!\.\,'"]+$''');
    final words = message.trim().split(RegExp(r'\s+'));
    if (words.length >= 2 && englishOnlyPattern.hasMatch(message) && !koreanPattern.hasMatch(message)) {
      debugPrint('🌍 English-only sentence detected: $message');
      return true;
    }
    
    // 비한글 문자 비율 체크 (한글이 10% 미만이고 최소 10글자 이상인 경우만)
    final totalLength = message.replaceAll(RegExp(r'\s'), '').length;
    if (totalLength > 10) {
      // 최소 10글자 이상일 때만 체크
      final koreanMatches = koreanPattern.allMatches(message).length;
      final koreanRatio = koreanMatches / totalLength;
      if (koreanRatio < 0.1) {
        // 10% 미만일 때만 외국어로 판단
        debugPrint(
            '🌍 Foreign language detected by low Korean ratio: $koreanRatio');
        return true;
      }
    }

    return false;
  }

  /// 응답 중복 체크 (패턴 다양성)
  bool _isResponseTooSimilar(String newResponse, String userId, String personaId) {
    final cacheKey = '${userId}_$personaId';
    final cache = _recentResponseCache[cacheKey] ?? [];
    
    if (cache.isEmpty) return false;
    
    // 정규화
    final normalizedNew = _normalizeForComparison(newResponse);
    
    for (final cachedResponse in cache) {
      final normalizedCached = _normalizeForComparison(cachedResponse);
      
      // 1. 완전 동일 체크
      if (normalizedNew == normalizedCached) {
        debugPrint('⚠️ Exact duplicate response detected');
        return true;
      }
      
      // 2. 레벤슈타인 거리 체크 (80% 이상 유사)
      final similarity = _calculateSimilarity(normalizedNew, normalizedCached);
      if (similarity > 0.8) {
        debugPrint('⚠️ High similarity detected: ${(similarity * 100).toStringAsFixed(1)}%');
        return true;
      }
      
      // 3. 동일 패턴 체크
      if (_hasSamePattern(normalizedNew, normalizedCached)) {
        debugPrint('⚠️ Same pattern detected');
        return true;
      }
    }
    
    return false;
  }
  
  /// 문자열 정규화
  String _normalizeForComparison(String text) {
    return text
        .replaceAll(RegExp(r'[~!@#$%^&*()_+=\[\]{}\\|;:\"<>/?`]'), '') // 특수문자 제거
        .replaceAll(RegExp(r'ㅋ+|ㅎ+|ㅠ+|ㅜ+'), '') // 웃음/울음 표현 제거
        .replaceAll(RegExp(r'\s+'), ' ') // 공백 정규화
        .replaceAll(RegExp(r'\.{2,}'), '') // 말줄임표 제거
        .trim()
        .toLowerCase();
  }
  
  
  /// 동일 패턴 체크
  bool _hasSamePattern(String s1, String s2) {
    // 시작과 끝이 같은 패턴
    if (s1.length > 10 && s2.length > 10) {
      final start1 = s1.substring(0, math.min(10, s1.length));
      final start2 = s2.substring(0, math.min(10, s2.length));
      final end1 = s1.substring(math.max(0, s1.length - 10));
      final end2 = s2.substring(math.max(0, s2.length - 10));
      
      if (start1 == start2 && end1 == end2) {
        return true;
      }
    }
    
    // 핵심 구조가 같은 패턴 (질문 형태 등)
    final pattern1 = s1.replaceAll(RegExp(r'[가-힣]+'), 'X');
    final pattern2 = s2.replaceAll(RegExp(r'[가-힣]+'), 'X');
    
    return pattern1 == pattern2 && pattern1.contains('X X');
  }
  
  /// 캐시 업데이트 - 문제 패턴 감지 강화
  void _updateResponseCache(String response, String userId, String personaId) {
    final cacheKey = '${userId}_$personaId';
    _recentResponseCache[cacheKey] ??= [];
    final cache = _recentResponseCache[cacheKey]!;
    
    // 문제 패턴 체크
    final problemPhrases = [
      '오 영어로 얘기하네',
      '한국어로 얘기해도 돼',
      '아닌데 진짜 괜찮아',
    ];
    
    for (final phrase in problemPhrases) {
      if (response.contains(phrase)) {
        // 문제 패턴이 발견되면 경고
        debugPrint('🚨 Warning: Problem phrase detected in response: "$phrase"');
        debugPrint('🚨 This may indicate language detection issues!');
      }
    }
    
    // 새 응답 추가
    cache.insert(0, response);
    
    // 최대 크기 유지
    if (cache.length > ChatOrchestrator._maxCacheSize) {
      cache.removeLast();
    }
    
    debugPrint('📝 Cache updated for $cacheKey: ${cache.length} responses stored');
  }
  
  /// Calculate similarity score with recent responses (for quality gates)
  double _calculateSimilarityWithRecentResponses(String newResponse, String userId, String personaId) {
    final cacheKey = '${userId}_$personaId';
    final cache = _recentResponseCache[cacheKey] ?? [];
    
    if (cache.isEmpty) return 0.0;
    
    double maxSimilarity = 0.0;
    final normalizedNew = _normalizeForComparison(newResponse);
    
    for (final cachedResponse in cache) {
      final normalizedCached = _normalizeForComparison(cachedResponse);
      
      // Calculate Levenshtein distance-based similarity
      final distance = _levenshteinDistance(normalizedNew, normalizedCached);
      final maxLength = math.max(normalizedNew.length, normalizedCached.length);
      final similarity = maxLength > 0 ? 1.0 - (distance / maxLength) : 0.0;
      
      maxSimilarity = math.max(maxSimilarity, similarity);
      
      // Also check for pattern similarity
      if (_hasSamePattern(newResponse, cachedResponse)) {
        maxSimilarity = math.max(maxSimilarity, 0.8);
      }
    }
    
    return maxSimilarity;
  }
  
  /// Check if response contains macro-like patterns
  bool _containsMacroPattern(String response) {
    // Check for template-like patterns
    final macroPatterns = [
      r'반가워.*오늘.*어땠어',  // Common greeting template
      r'오.*왔네.*뭐하고',      // Another greeting template
      r'안녕.*잘.*지냈어',      // Generic greeting
      r'힘들겠다.*괜찮아',      // Generic empathy template
      r'그렇구나.*이해해',      // Generic understanding template
    ];
    
    for (final pattern in macroPatterns) {
      if (RegExp(pattern).hasMatch(response)) {
        return true;
      }
    }
    
    // Check for overly repetitive structure
    final words = response.split(' ');
    if (words.length > 5) {
      final uniqueWords = words.toSet();
      final uniqueRatio = uniqueWords.length / words.length;
      if (uniqueRatio < 0.6) {
        return true; // Too many repeated words
      }
    }
    
    return false;
  }
  
  /// Check if response has low variety compared to conversation history
  bool _isLowVarietyResponse(String response, List<Message> chatHistory) {
    if (chatHistory.length < 5) return false;
    
    // Extract recent AI responses from history
    final recentAIResponses = chatHistory
        .where((msg) => !msg.isFromUser)
        .take(10)
        .map((msg) => msg.content)
        .toList();
    
    if (recentAIResponses.isEmpty) return false;
    
    // Check if response structure is too similar to recent ones
    final responseLength = response.length;
    final avgLength = recentAIResponses.fold<int>(
      0, (sum, r) => sum + r.length
    ) ~/ recentAIResponses.length;
    
    // Check length variety
    final lengthVariance = (responseLength - avgLength).abs();
    if (lengthVariance < 10 && recentAIResponses.length > 3) {
      // All responses are similar length - low variety
      return true;
    }
    
    // Check starting patterns
    final responseStart = response.length > 5 ? response.substring(0, 5) : response;
    int similarStarts = 0;
    for (final aiResponse in recentAIResponses) {
      if (aiResponse.length > 5 && aiResponse.startsWith(responseStart)) {
        similarStarts++;
      }
    }
    
    if (similarStarts > 2) {
      return true; // Too many responses start the same way
    }
    
    // Check emotion expression variety
    final hasEmoticon = RegExp(r'[ㅋㅎㅠㅜ]').hasMatch(response);
    int emoticonCount = 0;
    for (final aiResponse in recentAIResponses) {
      if (RegExp(r'[ㅋㅎㅠㅜ]').hasMatch(aiResponse)) {
        emoticonCount++;
      }
    }
    
    // If all responses have same emoticon pattern, it's low variety
    if ((hasEmoticon && emoticonCount == recentAIResponses.length) ||
        (!hasEmoticon && emoticonCount == 0)) {
      return true;
    }
    
    return false;
  }
  
  /// Check if response contains well-being questions
  bool _containsWellBeingQuestion(String response) {
    final lowerResponse = response.toLowerCase();
    
    // Well-being question patterns
    final wellBeingPatterns = [
      '어떻게 지냈',
      '어떻게 지내',
      '잘 지냈',
      '잘 지내',
      '오늘 어땠',
      '오늘은 어땠',
      '요즘 어때',
      '요즘은 어때',
      '뭐하고 지내',
      '뭐 했어',
      '뭐했어',
      '뭐해',
      '뭐하고 있',
      '어때',
      '너는?',
      '너도?',
      '너는 어때',
      '넌 어때',
      '넌?',
      // English patterns
      'how are you',
      'how r u',
      'how have you been',
      'what are you doing',
      'what r u doing',
      'how\'s it going',
      'how was your day',
      'what\'s up',
      'wassup',
    ];
    
    for (final pattern in wellBeingPatterns) {
      if (lowerResponse.contains(pattern)) {
        return true;
      }
    }
    
    // Check for question marks with typical well-being keywords
    if (lowerResponse.contains('?')) {
      final wellBeingKeywords = ['오늘', '어떻게', '뭐', '어때', '요즘', '지냈', '지내'];
      for (final keyword in wellBeingKeywords) {
        if (lowerResponse.contains(keyword)) {
          return true;
        }
      }
    }
    
    return false;
  }
  
  /// Check if response is relevant to the user's question/topic
  bool _isTopicRelevant(String userMessage, String aiResponse) {
    final userLower = userMessage.toLowerCase();
    final aiLower = aiResponse.toLowerCase();
    
    // Extract key topics from user message
    final topicKeywords = <String>[];
    
    // Common question topics
    if (userLower.contains('운동')) topicKeywords.addAll(['운동', '헬스', '요가', '필라테스', '조깅']);
    if (userLower.contains('먹') || userLower.contains('밥')) topicKeywords.addAll(['먹', '밥', '음식', '배고프', '식사']);
    if (userLower.contains('게임')) topicKeywords.addAll(['게임', '플레이', 'rpg', '온라인']);
    if (userLower.contains('영화') || userLower.contains('드라마')) topicKeywords.addAll(['영화', '드라마', '넷플', '보']);
    if (userLower.contains('날씨')) topicKeywords.addAll(['날씨', '비', '눈', '춥', '더워', '맑']);
    if (userLower.contains('어디')) topicKeywords.addAll(['집', '카페', '학교', '회사', '밖', '있어']);
    if (userLower.contains('뭐해') || userLower.contains('뭐하')) topicKeywords.addAll(['하고', '있어', '중', '보고', '듣고']);
    
    // Check for feelings/emotions
    if (userLower.contains('우울') || userLower.contains('슬')) topicKeywords.addAll(['우울', '슬프', '힘들', '괜찮', '위로']);
    if (userLower.contains('기분') || userLower.contains('어때')) topicKeywords.addAll(['기분', '좋', '나쁘', '그럭저럭', '괜찮']);
    
    // If no keywords found, consider it a general conversation (always relevant)
    if (topicKeywords.isEmpty) return true;
    
    // Check if AI response contains any relevant keywords
    for (final keyword in topicKeywords) {
      if (aiLower.contains(keyword)) {
        return true; // Found relevant topic
      }
    }
    
    // Check for romantic responses to non-romantic questions
    final romanticPhrases = ['사랑해', '보고싶', '안아주고', '너랑 있으면', '너 생각', '우리 정말 잘 맞'];
    final isRomanticResponse = romanticPhrases.any((phrase) => aiLower.contains(phrase));
    
    // If user asked a simple question but got romantic response, it's off-topic
    if (isRomanticResponse && !userLower.contains('사랑') && !userLower.contains('좋아')) {
      return false;
    }
    
    // For questions expecting specific answers
    if (userLower.contains('?') || userLower.contains('니') || userLower.contains('냐')) {
      // Response should be answering, not deflecting
      if (aiLower.contains('뭐라고') || aiLower.contains('무슨 말')) {
        return false; // Deflection detected
      }
    }
    
    return true; // Default to relevant if unsure
  }
  
  /// Calculate Levenshtein distance between two strings
  int _levenshteinDistance(String s1, String s2) {
    if (s1 == s2) return 0;
    if (s1.isEmpty) return s2.length;
    if (s2.isEmpty) return s1.length;
    
    List<int> previousRow = List.generate(s2.length + 1, (i) => i);
    List<int> currentRow = List.filled(s2.length + 1, 0);
    
    for (int i = 0; i < s1.length; i++) {
      currentRow[0] = i + 1;
      
      for (int j = 0; j < s2.length; j++) {
        final insertCost = currentRow[j] + 1;
        final deleteCost = previousRow[j + 1] + 1;
        final replaceCost = s1[i] == s2[j] ? previousRow[j] : previousRow[j] + 1;
        
        currentRow[j + 1] = math.min(insertCost, math.min(deleteCost, replaceCost));
      }
      
      final temp = previousRow;
      previousRow = currentRow;
      currentRow = temp;
    }
    
    return previousRow[s2.length];
  }
}

/// 채팅 응답 모델
class ChatResponse {
  final List<String> contents; // 여러 메시지로 나눌 수 있도록 변경
  final EmotionType emotion;
  final int scoreChange;
  final Map<String, dynamic>? metadata;
  final bool isError;
  final String? translatedContent; // 번역된 내용 (다국어 지원)
  final List<String>? translatedContents; // 각 메시지별 번역
  final String? targetLanguage; // 번역 대상 언어

  ChatResponse({
    required String content, // 기존 API 호환성을 위해 유지
    List<String>? contents, // 새로운 멀티 메시지 지원
    required this.emotion,
    required this.scoreChange,
    this.metadata,
    this.isError = false,
    this.translatedContent,
    this.translatedContents,
    this.targetLanguage,
  }) : contents = contents ?? [content]; // contents가 없으면 content를 리스트로 변환

  // 편의 메서드: 첫 번째 콘텐츠 반환 (기존 코드 호환성)
  String get content => contents.isNotEmpty ? contents.first : '';
}

/// ChatOrchestrator 클래스 확장 - 대화 품질 및 특별한 순간 평가
extension ChatOrchestratorQualityExtension on ChatOrchestrator {
  /// 💡 대화 품질 점수 계산 (0-100)
  double calculateConversationQuality({
    required String userMessage,
    required String aiResponse,
    required List<Message> recentMessages,
  }) {
    double qualityScore = 50.0; // 기본 점수

    // 1. 맥락 일관성 (0-30점)
    final contextScore =
        _calculateContextCoherence(userMessage, recentMessages);
    qualityScore += contextScore * 30;

    // 2. 감정 교류 품질 (0-20점)
    final emotionalScore =
        _calculateEmotionalExchange(userMessage, aiResponse, recentMessages);
    qualityScore += emotionalScore * 20;

    // 3. 대화 깊이 (0-20점)
    final depthScore = _calculateConversationDepth(userMessage, recentMessages);
    qualityScore += depthScore * 20;

    // 4. 응답 관련성 (0-15점)
    final relevanceScore = _calculateResponseRelevance(userMessage, aiResponse);
    qualityScore += relevanceScore * 15;

    // 5. 자연스러움 (0-15점)
    final naturalScore =
        _calculateNaturalness(userMessage, aiResponse, recentMessages);
    qualityScore += naturalScore * 15;

    // 향상된 품질 목표 임계값
    const double naturalThreshold = 95.0;  // 자연스러움 목표: 95%
    const double coherenceThreshold = 92.0;  // 일관성 목표: 92%
    const double empathyThreshold = 90.0;  // 공감도 목표: 90%
    const double overallThreshold = 93.0;  // 전체 목표: 93%

    // 디버그 출력 (향상된 목표 표시)
    debugPrint('🎯 대화 품질 점수: ${qualityScore.toStringAsFixed(1)}/100 (목표: $overallThreshold)');
    debugPrint('  - 맥락 일관성: ${(contextScore * 30).toStringAsFixed(1)}/30 (목표: ${(coherenceThreshold * 0.3).toStringAsFixed(1)})');
    debugPrint('  - 감정 교류: ${(emotionalScore * 20).toStringAsFixed(1)}/20 (목표: ${(empathyThreshold * 0.2).toStringAsFixed(1)})');
    debugPrint('  - 대화 깊이: ${(depthScore * 20).toStringAsFixed(1)}/20');
    debugPrint('  - 응답 관련성: ${(relevanceScore * 15).toStringAsFixed(1)}/15');
    debugPrint('  - 자연스러움: ${(naturalScore * 15).toStringAsFixed(1)}/15 (목표: ${(naturalThreshold * 0.15).toStringAsFixed(1)})');
    
    // 품질 경고 시스템
    if (qualityScore < overallThreshold) {
      debugPrint('⚠️ 품질 목표 미달! 개선 필요: ${(overallThreshold - qualityScore).toStringAsFixed(1)}점');
    } else {
      debugPrint('✅ 품질 목표 달성!');
    }

    return qualityScore.clamp(0, 100);
  }

  /// 맥락 일관성 계산
  double _calculateContextCoherence(
      String userMessage, List<Message> recentMessages) {
    if (recentMessages.isEmpty) return 0.7; // 첫 대화는 기본점

    // 최근 대화의 키워드 추출
    final recentKeywords = <String>[];
    for (final msg in recentMessages.take(5)) {
      recentKeywords.addAll(_extractKeywords(msg.content));
    }

    // 현재 메시지의 키워드
    final currentKeywords = _extractKeywords(userMessage);

    // 키워드 겹침 정도
    final commonKeywords =
        currentKeywords.where((k) => recentKeywords.contains(k)).length;
    final coherence =
        commonKeywords.toDouble() / math.max(currentKeywords.length, 1);

    // 급격한 주제 변경 체크
    if (_isAbruptTopicChange(userMessage, recentMessages)) {
      return math.max(0, coherence - 0.3);
    }

    return math.min(1.0, coherence + 0.3); // 기본 보너스
  }

  /// 감정 교류 품질 계산
  double _calculateEmotionalExchange(
      String userMessage, String aiResponse, List<Message> recentMessages) {
    double score = 0.5;

    // 감정 표현 단어 확인
    final emotionalWords = [
      '좋아',
      '사랑',
      '행복',
      '기뻐',
      '슬퍼',
      '그리워',
      '보고싶',
      '고마워',
      '미안'
    ];
    final userHasEmotion = emotionalWords.any((w) => userMessage.contains(w));
    final aiHasEmotion = emotionalWords.any((w) => aiResponse.contains(w));

    // 상호 감정 교류
    if (userHasEmotion && aiHasEmotion) {
      score = 1.0;
    } else if (userHasEmotion || aiHasEmotion) {
      score = 0.7;
    }

    // 공감 표현 체크
    if (aiResponse.contains('나도') ||
        aiResponse.contains('저도') ||
        aiResponse.contains('맞아') ||
        aiResponse.contains('그렇') ||
        aiResponse.contains('이해')) {
      score = math.min(1.0, score + 0.2);
    }

    return score;
  }

  /// 대화 깊이 계산
  double _calculateConversationDepth(
      String userMessage, List<Message> recentMessages) {
    double depth = 0.3; // 기본 점수

    // 깊은 주제 키워드
    final deepTopics = [
      '꿈',
      '목표',
      '고민',
      '추억',
      '가족',
      '친구',
      '사랑',
      '미래',
      '과거',
      '감정',
      '생각'
    ];
    final hasDeepTopic = deepTopics.any((t) => userMessage.contains(t));

    if (hasDeepTopic) {
      depth += 0.4;
    }

    // 개인적인 이야기
    if (userMessage.contains('나는') ||
        userMessage.contains('저는') ||
        userMessage.contains('내가') ||
        userMessage.contains('제가')) {
      depth += 0.2;
    }

    // 질문의 깊이
    if (userMessage.contains('어떻게 생각') ||
        userMessage.contains('왜') ||
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
      if (aiResponse.contains('모르겠') ||
          aiResponse.contains('글쎄') ||
          aiResponse.contains('다른 얘기')) {
        return 0.2;
      }

      // 질문 키워드가 답변에 포함되었는지
      final questionKeywords = _extractKeywords(userMessage);
      final answerKeywords = _extractKeywords(aiResponse);
      final relevance = questionKeywords
              .where((k) => answerKeywords.contains(k))
              .length
              .toDouble() /
          math.max(questionKeywords.length, 1);

      return math.min(1.0, relevance + 0.3);
    }

    return 0.8; // 일반 대화는 기본점
  }

  /// 대화 자연스러움 계산
  double _calculateNaturalness(
      String userMessage, String aiResponse, List<Message> recentMessages) {
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
    if (aiResponse.contains('ㅋㅋ') ||
        aiResponse.contains('ㅎㅎ') ||
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
    final quality =
        _calculateEmotionalExchange(userMessage, aiResponse, recentMessages);

    return EmotionalExchangeQuality(
      score: quality,
      quality: quality > 0.8 ? 'excellent' : quality > 0.6 ? 'good' : quality > 0.4 ? 'moderate' : 'poor',
      isMutual: quality > 0.7,
      emotionMatch: _checkEmotionMatch(userMessage, emotion) ? 1.0 : 0.0,
      hasEmpathy: _checkEmpathy(aiResponse),
    );
  }

  /// 감정 매칭 확인
  bool _checkEmotionMatch(String message, EmotionType emotion) {
    switch (emotion) {
      case EmotionType.happy:
        return message.contains('좋') ||
            message.contains('행복') ||
            message.contains('기뻐');
      case EmotionType.love:
        return message.contains('사랑') ||
            message.contains('좋아') ||
            message.contains('보고싶');
      case EmotionType.sad:
        return message.contains('슬') ||
            message.contains('우울') ||
            message.contains('힘들');
      case EmotionType.anxious:
        return message.contains('걱정') ||
            message.contains('불안') ||
            message.contains('무서');
      default:
        return false;
    }
  }

  /// 공감 표현 확인
  bool _checkEmpathy(String response) {
    final empathyPhrases = [
      '나도',
      '저도',
      '맞아',
      '그렇',
      '이해',
      '알아',
      '공감',
      '같은 마음',
      '나도 그래',
      '충분히',
      '당연히'
    ];

    return empathyPhrases.any((p) => response.contains(p));
  }

  /// 키워드 추출 (TF-IDF 개념 적용)
  Set<String> _extractKeywords(String text) {
    // 확장된 불용어 사전
    final stopWords = {
      // 한국어 조사
      '은', '는', '이', '가', '을', '를', '에', '에서', '으로', '로', '와', '과',
      '의', '도', '만', '까지', '부터', '하고', '이고', '고', '며', '거나',
      // 한국어 연결어
      '그리고', '그러나', '하지만', '그런데', '그래서', '따라서', '그러므로',
      '그렇지만', '그래도', '아니면', '혹은', '또는', '즉', '다시', '또',
      // 한국어 의존명사
      '것', '거', '수', '때', '줄', '데', '곳', '중', '뿐', '바',
      // 한국어 보조동사
      '있', '없', '하', '되', '않', '못', '같', '싶',
      // 영어 기본 불용어
      'the', 'a', 'an', 'is', 'are', 'was', 'were', 'been', 'be',
      'have', 'has', 'had', 'do', 'does', 'did', 'will', 'would',
      'could', 'should', 'may', 'might', 'must', 'can', 'could',
      'to', 'of', 'in', 'on', 'at', 'by', 'for', 'with', 'from',
      'up', 'about', 'into', 'through', 'during', 'before', 'after',
      'above', 'below', 'between', 'under', 'again', 'further',
      'then', 'once', 'here', 'there', 'when', 'where', 'why',
      'how', 'all', 'both', 'each', 'few', 'more', 'most', 'other',
      'some', 'such', 'no', 'nor', 'not', 'only', 'own', 'same',
      'so', 'than', 'too', 'very', 'can', 'will', 'just', 'should'
    };

    // 중요 키워드 부스팅 (TF-IDF의 IDF 개념)
    final importantPatterns = {
      // 감정 표현
      '좋아', '싫어', '사랑', '미워', '기뻐', '슬퍼', '화나', '짜증',
      '행복', '우울', '외로', '그리워', '보고싶', '걱정',
      '욕', '열받아', '빡쳐', '스트레스', '답답',
      // 활동
      '영화', '게임', '음악', '운동', '요리', '공부', '일', '여행',
      '쇼핑', '독서', '드라마', '유튜브', '넷플릭스',
      // 음식
      '밥', '커피', '치킨', '피자', '라면', '술', '맥주', '와인',
      '케이크', '아이스크림', '초콜릿',
      // 시간/날씨
      '오늘', '내일', '어제', '주말', '평일', '아침', '점심', '저녁',
      '날씨', '비', '눈', '바람', '더워', '추워',
      // 관계
      '친구', '가족', '엄마', '아빠', '형', '누나', '동생', '애인',
      '남자친구', '여자친구', '결혼', '연애',
      // 직장 관계
      '부장', '상사', '팀장', '과장', '대리', '사장', '직장', '회사',
      '동료', '선배', '후배', '팀원', '야근', '퇴근',
      // 감정/상태
      '피곤', '졸려', '배고파', '배불러', '아파', '건강',
      // 장소
      '집', '학교', '회사', '카페', '식당', '병원', '은행', '마트'
    };

    // 텍스트 정규화
    final normalizedText = text
        .toLowerCase()
        .replaceAll(RegExp(r'[~!@#$%^&*()_+=\[\]{}\\|;:"<>/?`]'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();

    // 단어 추출 및 필터링
    final words = <String>{};
    final tokens = normalizedText.split(' ');
    
    // 단어 빈도 계산 (TF 개념)
    final wordFreq = <String, int>{};
    for (final token in tokens) {
      if (token.length > 1 && !stopWords.contains(token)) {
        wordFreq[token] = (wordFreq[token] ?? 0) + 1;
      }
    }

    // 중요도 기반 키워드 선택
    final keywords = <String>{};
    
    // 1. 빈도가 높은 단어 추가 (TF가 높은 단어)
    final sortedByFreq = wordFreq.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    for (final entry in sortedByFreq.take(10)) { // 상위 10개
      keywords.add(entry.key);
    }
    
    // 2. 중요 패턴과 매칭되는 단어 추가 (IDF가 높은 단어)
    for (final word in wordFreq.keys) {
      for (final pattern in importantPatterns) {
        if (word.contains(pattern) || pattern.contains(word)) {
          keywords.add(word);
          break;
        }
      }
    }
    
    // 3. 명사 추출 휴리스틱 (한국어)
    // 명사는 보통 2-4글자이고 특정 어미로 끝나지 않음
    final nounEndings = ['다', '요', '야', '어', '아', '지', '죠', '네', '나', '니'];
    for (final word in wordFreq.keys) {
      if (word.length >= 2 && word.length <= 4) {
        bool isNoun = true;
        for (final ending in nounEndings) {
          if (word.endsWith(ending)) {
            isNoun = false;
            break;
          }
        }
        if (isNoun && !keywords.contains(word)) {
          keywords.add(word);
        }
      }
    }
    
    // 4. 복합명사 처리
    // "영화관", "커피숍" 같은 복합명사 인식
    final compoundNouns = <String>{};
    for (int i = 0; i < tokens.length - 1; i++) {
      if (tokens[i].length >= 2 && tokens[i + 1].length >= 1) {
        final compound = tokens[i] + tokens[i + 1];
        if (compound.length <= 5 && !stopWords.contains(compound)) {
          // 복합명사 패턴 확인
          if ((tokens[i].endsWith('영') || tokens[i].endsWith('커') || 
               tokens[i].endsWith('게') || tokens[i].endsWith('음')) &&
              (tokens[i + 1] == '화' || tokens[i + 1] == '피' || 
               tokens[i + 1] == '임' || tokens[i + 1] == '악')) {
            compoundNouns.add(compound);
          }
        }
      }
    }
    keywords.addAll(compoundNouns);
    
    // 5. 이모지 처리 (중요한 감정 표현)
    final emojiPattern = RegExp(r'[\u{1F300}-\u{1F9FF}]', unicode: true);
    if (emojiPattern.hasMatch(text)) {
      keywords.add('_emoji_'); // 이모지 존재 표시
    }
    
    // 최대 15개 키워드로 제한 (너무 많으면 의미 희석)
    if (keywords.length > 15) {
      return keywords.take(15).toSet();
    }
    
    return keywords;
  }

  /// 갑작스러운 주제 변경 감지
  bool _isAbruptTopicChange(String userMessage, List<Message> recentMessages) {
    if (recentMessages.isEmpty) return false;

    // 최근 메시지들의 키워드와 문맥 추출
    final recentKeywords = <String>{};
    final recentContext = <String>{};
    
    for (final msg in recentMessages.take(5)) { // 더 많은 메시지 참조
      recentKeywords.addAll(_extractKeywords(msg.content));
      
      // 문맥 카테고리 추출
      final lower = msg.content.toLowerCase();
      if (lower.contains('회사') || lower.contains('일') || lower.contains('상사') || lower.contains('스트레스')) {
        recentContext.add('work');
      }
      if (lower.contains('먹') || lower.contains('밥') || lower.contains('음식') || lower.contains('배고')) {
        recentContext.add('food');
      }
      if (lower.contains('매운') || lower.contains('시원') || lower.contains('떡볶이') || lower.contains('김치')) {
        recentContext.add('spicy_food');
      }
    }

    // 현재 메시지의 키워드와 문맥
    final currentKeywords = _extractKeywords(userMessage);
    final currentLower = userMessage.toLowerCase();
    final currentContext = <String>{};
    
    if (currentLower.contains('회사') || currentLower.contains('일') || currentLower.contains('스트레스')) {
      currentContext.add('work');
    }
    if (currentLower.contains('먹') || currentLower.contains('밥') || currentLower.contains('음식')) {
      currentContext.add('food');
    }
    if (currentLower.contains('매운') || currentLower.contains('시원')) {
      currentContext.add('spicy_food');
    }
    
    // 문맥이 연결되어 있으면 주제 변경이 아님
    if (currentContext.isNotEmpty && recentContext.isNotEmpty) {
      final commonContext = currentContext.intersection(recentContext);
      if (commonContext.isNotEmpty) {
        return false; // 문맥이 이어지고 있음
      }
    }

    // 공통 키워드가 전혀 없고 문맥도 다르면 주제 변경
    final commonKeywords = currentKeywords.intersection(recentKeywords);
    return commonKeywords.isEmpty &&
        currentKeywords.isNotEmpty &&
        recentKeywords.isNotEmpty &&
        currentContext.intersection(recentContext).isEmpty;
  }
  
  /// 주제 일관성 점수 계산 (0-100)
  double _calculateTopicConsistencyScore(
    String userMessage,
    List<Message> recentMessages,
  ) {
    if (recentMessages.isEmpty) return 100.0;
    
    // 최근 메시지들의 주요 주제 추출 (더 많은 메시지 참조)
    final recentTopics = <String>{};
    final recentContext = <String>{};
    
    for (final msg in recentMessages.take(7)) {  // 5 -> 7로 증가
      final keywords = _extractKeywords(msg.content.toLowerCase());
      recentTopics.addAll(keywords);
      
      // 문맥 단어도 수집
      if (msg.content.contains('쉬') || msg.content.contains('푹')) {
        recentContext.add('rest');
      }
      if (msg.content.contains('회사') || msg.content.contains('일')) {
        recentContext.add('work');
      }
      if (msg.content.contains('먹') || msg.content.contains('밥')) {
        recentContext.add('meal');
      }
      if (msg.content.contains('스트레스') || msg.content.contains('힘들')) {
        recentContext.add('stress');
      }
    }
    
    // 현재 메시지의 주제
    final currentTopics = _extractKeywords(userMessage.toLowerCase());
    
    // 🔥 NEW: "넌?", "너는?" 패턴은 최고 일관성 점수
    // 사용자가 자신의 상황을 말하고 AI에게 되묻는 것은 완벽한 주제 일관성
    final lower = userMessage.toLowerCase();
    if (lower.contains('넌?') || lower.contains('너는?') || 
        lower.contains('너는 ') || lower.contains('넌 ') ||
        lower.endsWith('너는') || lower.endsWith('넌') ||
        lower.contains('you?') || lower.contains('how about you') ||
        lower.contains('what about you') || lower.contains('and you')) {
      // "넌?" 타입 질문은 이전 주제를 그대로 이어가는 것이므로 최고 점수
      return 95.0;
    }
    
    // "~는?" 패턴도 이전 맥락 이어가기로 간주
    if (userMessage.contains('는?') || userMessage.contains('은?')) {
      // 이름 뒤의 "는?"은 같은 주제 되물음으로 높은 점수
      return 85.0;
    }
    
    // 특별 케이스: 짧은 질문들
    final shortQuestions = ['뭐해', '어디', '왜', '언제', '어떻게', '뭐가', '머가', '뭐야', '머야'];
    final isShortQuestion = shortQuestions.any((q) => 
      userMessage.replaceAll('?', '').trim() == q
    );
    
    if (isShortQuestion) {
      // 짧은 질문은 맥락 이어가기로 간주
      return 80.0;
    }
    
    // 맥락 오해 체크
    if (_isMisinterpretation(userMessage, recentMessages)) {
      return 20.0;  // 맥락 오해는 낮은 점수
    }
    
    if (currentTopics.isEmpty || recentTopics.isEmpty) {
      // 키워드가 없어도 문맥이 이어지면 높은 점수
      if (recentContext.isNotEmpty) {
        return 70.0;
      }
      return 50.0;
    }
    
    // 공통 주제 비율 계산
    final commonTopics = currentTopics.intersection(recentTopics);
    final consistencyRatio = commonTopics.length / currentTopics.length;
    
    // 갑작스러운 주제 변경 체크
    if (_isAbruptTopicChange(userMessage, recentMessages)) {
      return 10.0; // 매우 낮은 점수
    }
    
    return (consistencyRatio * 100).clamp(0.0, 100.0);
  }
  
  /// 맥락 오해 감지
  bool _isMisinterpretation(String userMessage, List<Message> recentMessages) {
    final lower = userMessage.toLowerCase();
    
    // "맥락을 잘 모르는구나" 같은 직접적 지적
    if (lower.contains('맥락') && (lower.contains('모르') || lower.contains('이해'))) {
      return true;
    }
    
    // "그게 아니라" 같은 정정
    if (lower.contains('그게 아니') || lower.contains('아니라고')) {
      return true;
    }
    
    return false;
  }

  /// 특별한 순간 감지
  SpecialMoment? detectSpecialMoments({
    required String userMessage,
    required List<Message> chatHistory,
    required int currentLikes,
  }) {
    // 첫 고민 상담
    if ((userMessage.contains('고민') || userMessage.contains('걱정')) &&
        !chatHistory
            .any((m) => m.content.contains('고민') || m.content.contains('걱정'))) {
      return SpecialMoment(
        type: 'first_concern',
        description: '첫 고민 상담',
        bonusLikes: 50,
      );
    }

    // 첫 꿈/목표 공유
    if ((userMessage.contains('꿈') || userMessage.contains('목표')) &&
        !chatHistory
            .any((m) => m.content.contains('꿈') || m.content.contains('목표'))) {
      return SpecialMoment(
        type: 'first_dream',
        description: '첫 꿈 공유',
        bonusLikes: 30,
      );
    }

    // 서로의 추억 공유
    if (userMessage.contains('추억') || userMessage.contains('기억')) {
      final recentMessages = chatHistory.take(5).toList();
      if (recentMessages
          .any((m) => !m.isFromUser && m.content.contains('나도 기억'))) {
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
