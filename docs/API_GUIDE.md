# 소나앱 API 가이드

## 🎯 주요 서비스 사용법

### ChatService - 채팅 메인 서비스

```dart
// 초기화
final chatService = context.read<ChatService>();

// 메시지 전송
await chatService.sendMessage(
  userId: 'user123',
  personaId: 'persona456',
  message: '안녕하세요!',
  persona: personaObject,
);

// 대화 내역 로드
final messages = await chatService.getMessages(
  userId: 'user123',
  personaId: 'persona456',
);

// 대화 삭제
await chatService.deleteChat(
  userId: 'user123',
  personaId: 'persona456',
);
```

### ChatOrchestrator - 고급 채팅 제어

```dart
// 싱글톤 인스턴스
final orchestrator = ChatOrchestrator.instance;

// 메시지 생성 (내부 API)
final response = await orchestrator.generateResponse(
  userId: userId,
  persona: persona,
  userMessage: message,
  chatHistory: history,
  customPrompt: null, // 선택적
);
```

### 보안 서비스

```dart
// 보안 필터링
final filtered = SecurityFilterService.filterResponse(
  response: aiResponse,
  userMessage: userInput,
  persona: persona,
);

// 프롬프트 인젝션 검사
final analysis = await PromptInjectionDefense.analyzeInjection(input);
if (analysis.isHighRisk) {
  // 위험한 입력 처리
}

// 시스템 정보 보호
final protected = SystemInfoProtection.protectSystemInfo(text);
```

### 지능형 서비스

#### ConversationContextManager - 대화 컨텍스트

```dart
final contextManager = ConversationContextManager.instance;

// 지식 로드
await contextManager.loadKnowledge(userId, personaId);

// 지식 업데이트
await contextManager.updateKnowledge(
  userId: userId,
  personaId: personaId,
  userMessage: userMessage,
  personaResponse: response,
  chatHistory: history,
);

// 컨텍스트 힌트 생성
final hint = contextManager.generateContextualHint(
  userId: userId,
  personaId: personaId,
  userMessage: message,
  chatHistory: history,
  maxLength: 300, // 압축 모드
);
```

#### ServiceOrchestrationController - 서비스 제어

```dart
final controller = ServiceOrchestrationController.instance;

// 최적 서비스 선택 (토큰 예산 고려)
final services = await controller.selectOptimalServices(
  userMessage: message,
  chatHistory: history,
  knowledge: knowledge,
);

// 서비스 우선순위 계산
final priorities = controller.calculateServicePriorities(
  userMessage: message,
  chatHistory: history,
  knowledge: knowledge,
);

// 토큰 사용량 예측
final tokens = controller.estimateCurrentTokenUsage();
```

#### ResponseRhythmManager - 대화 리듬

```dart
final rhythmManager = ResponseRhythmManager.instance;

// 리듬 가이드 생성
final guide = rhythmManager.generateRhythmGuide(
  userId: userId,
  personaId: personaId,
  userMessage: message,
  chatHistory: history,
  persona: persona,
);

// 리듬 리셋
rhythmManager.resetRhythm(userId, personaId);
```

#### EmotionalTransferService - 감정 미러링

```dart
final emotionalService = EmotionalTransferService.instance;

// 감정 미러링 가이드
final guide = emotionalService.generateEmotionalMirrorGuide(
  userId: userId,
  personaId: personaId,
  userMessage: message,
  chatHistory: history,
  persona: persona,
);

// 감정 상태 리셋
emotionalService.resetEmotionalState(userId, personaId);
```

#### RelationshipBoundaryService - 관계 경계

```dart
final boundaryService = RelationshipBoundaryService.instance;

// 관계 경계 가이드
final guide = boundaryService.generateBoundaryGuide(
  userId: userId,
  personaId: personaId,
  userMessage: message,
  chatHistory: history,
  persona: persona,
  relationshipScore: score,
);

// 관계 발전 속도 체크
final shouldSlow = boundaryService.shouldSlowDown(userId, personaId);
```

### 분석 서비스

#### UserSpeechPatternAnalyzer - 언어 패턴

```dart
final analyzer = UserSpeechPatternAnalyzer();

// 메시지 분석
analyzer.analyzeMessage(userMessage);

// 적응 가이드 생성 (이모지 미러링 포함)
final guide = analyzer.generateAdaptationGuide(
  currentMessage: userMessage,
);

// 통계 확인
analyzer.printStatistics();
```

#### EmotionRecognitionService - 감정 인식

```dart
// 감정 분석
final emotion = EmotionRecognitionService.analyzeEmotion(message);

// 감정 강도
final intensity = EmotionRecognitionService.calculateIntensity(message);

// 감정 변화 감지
final hasShift = EmotionRecognitionService.detectEmotionalShift(
  currentEmotion,
  previousEmotion,
);
```

### 프롬프트 서비스

#### PersonaPromptBuilder - 페르소나 프롬프트

```dart
// 시스템 프롬프트 생성
final systemPrompt = PersonaPromptBuilder.buildSystemPrompt(
  persona: persona,
  customInstructions: null,
);

// 성격 프롬프트
final personalityPrompt = PersonaPromptBuilder.buildPersonalityPrompt(
  persona: persona,
);

// 관계 프롬프트
final relationshipPrompt = PersonaPromptBuilder.buildRelationshipPrompt(
  messageCount: count,
  lastInteraction: date,
);
```

#### OptimizedPromptService - 최적화 프롬프트

```dart
// 프롬프트 최적화
final optimized = OptimizedPromptService.optimizePrompt(
  basePrompt: prompt,
  contextHint: hint,
  speechMode: true, // 반말 모드
);

// 컨텍스트 통합
final combined = OptimizedPromptService.combineContext(
  systemPrompt: system,
  contextHint: context,
  adaptationGuide: guide,
);
```

## 🔧 유틸리티

### PersonaRelationshipCache - 관계 캐시

```dart
final cache = PersonaRelationshipCache.instance;

// 관계 정보 캐시
cache.cacheRelationship(userId, personaId, relationship);

// 캐시 조회
final cached = cache.getRelationship(userId, personaId);

// 캐시 클리어
cache.clearCache();
```

### ErrorRecoveryService - 에러 복구

```dart
// 에러 복구 시도
final recovered = await ErrorRecoveryService.recover(
  error: exception,
  context: errorContext,
);

// 폴백 응답 생성
final fallback = ErrorRecoveryService.generateFallback(
  persona: persona,
  errorType: 'network',
);
```

## 📊 토큰 관리

### 토큰 예산
```dart
// 서비스별 토큰 예상치
const serviceTokens = {
  'weather': 150,
  'emotion': 200,
  'memory': 300,
  'dailyCare': 100,
  'interest': 250,
  'continuity': 150,
};

// 최대 동시 서비스: 3개
// 총 토큰 예산: 800
```

### 토큰 최적화
```dart
// 압축 모드 활성화
contextManager.generateContextualHint(
  // ...
  maxLength: 300, // 힌트 압축
);

// 서비스 우선순위 기반 선택
controller.selectOptimalServices(
  // 자동으로 토큰 예산 내 선택
);
```

## 🚨 에러 처리

### 공통 에러 패턴
```dart
try {
  final result = await service.operation();
} on FirebaseException catch (e) {
  // Firebase 에러 처리
  debugPrint('Firebase error: ${e.message}');
} on OpenAIException catch (e) {
  // OpenAI API 에러
  if (e.isTokenLimit) {
    // 토큰 초과 처리
  }
} catch (e) {
  // 일반 에러
  final fallback = ErrorRecoveryService.generateFallback(
    persona: persona,
    errorType: 'unknown',
  );
}
```

### BaseService 패턴
```dart
class MyService extends BaseService {
  Future<void> operation() async {
    // 자동 로딩 상태 관리
    await executeWithLoading(() async {
      // 작업 수행
    });
    
    // 안전한 실행
    await executeSafely(() async {
      // 에러 자동 처리
    });
  }
}
```

## 🔍 디버깅

### 디버그 정보 출력
```dart
// 각 서비스별 디버그 메서드
rhythmManager.printDebugInfo(userId, personaId);
emotionalService.printDebugInfo(userId, personaId);
boundaryService.printDebugInfo(userId, personaId);
orchestrator.printStatistics();

// 토큰 사용량 확인
final tokens = controller.estimateCurrentTokenUsage();
debugPrint('Current token usage: $tokens');
```

### 서비스 통계
```dart
// 서비스 호출 통계
controller.printStatistics();

// 언어 패턴 통계
analyzer.printStatistics();

// 캐시 상태
cache.printCacheStatus();
```