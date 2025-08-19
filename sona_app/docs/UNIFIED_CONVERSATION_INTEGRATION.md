# 🎯 통합 대화 시스템 (Unified Conversation System) 통합 가이드

## 📋 개요

OpenAI API의 대화 상태 관리와 기존 SONA 앱의 여러 대화 서비스들을 완벽하게 통합한 시스템입니다.

## 🏗️ 시스템 아키텍처

### 핵심 컴포넌트

1. **UnifiedConversationSystem** (`lib/services/chat/core/unified_conversation_system.dart`)
   - 모든 대화 서비스를 통합하는 중앙 시스템
   - 세션 관리 및 컨텍스트 구성
   - 30일 상태 보존

2. **ConversationStateManager** (`lib/services/chat/core/conversation_state_manager.dart`)
   - OpenAI API 권장 사항에 따른 상태 관리
   - 대화방별 고유 상태 유지
   - 메타데이터 추적

3. **OptimizedContextManager** (`lib/services/chat/core/optimized_context_manager.dart`)
   - 토큰 최적화된 메시지 선택
   - 중요도 기반 우선순위
   - 컨텍스트 연속성 보장

### 통합된 서비스들

- **ConversationMemoryService**: 중요 대화 추출 및 장기 기억
- **ConversationContextManager**: 사용자 지식 및 맥락 추적
- **ConversationContinuityService**: 대화 흐름 유지
- **MemoryNetworkService**: 연관 기억 네트워크
- **ChatOrchestrator**: 전체 대화 플로우 조정

## 🔄 통합 플로우

### 1. 대화 시작
```dart
// ChatOrchestrator.generateResponse()에서
final conversationId = '${userId}_${completePersona.id}';

// 통합 컨텍스트 구성
final unifiedContext = await _unifiedSystem.buildUnifiedContext(
  conversationId: conversationId,
  userId: userId,
  personaId: completePersona.id,
  userMessage: userMessage,
  fullHistory: chatHistory,
  persona: completePersona,
);
```

### 2. OpenAI API 호출
```dart
// 컨텍스트 품질이 좋으면 상태 요약 추가
if (unifiedContext['contextQuality'] > 0.6) {
  final stateSummary = unifiedContext['state']['summary'];
  contextHint = '$contextHint\n\n## 📊 대화 상태:\n$stateSummary';
}

// API 호출 시 conversationId와 userId 전달
final rawResponse = await OpenAIService.generateResponse(
  persona: completePersona,
  chatHistory: chatHistory,
  userMessage: userMessage,
  conversationId: conversationId,  // 대화방 ID
  userId: userId,                   // 사용자 ID
  // ... 기타 파라미터
);
```

### 3. 대화 상태 업데이트
```dart
// 응답 생성 후 상태 업데이트
await _unifiedSystem.updateConversationState(
  conversationId: conversationId,
  userId: userId,
  personaId: completePersona.id,
  userMessage: userMsg,
  aiResponse: aiMsg,
  fullHistory: [...chatHistory, userMsg, aiMsg],
);
```

## 📊 통합 컨텍스트 구조

```json
{
  "conversationId": "user123_persona456",
  "state": {
    "messageCount": 42,
    "relationshipLevel": 75,
    "topics": ["날씨", "음식", "취미"],
    "emotionHistory": ["happy", "excited", "neutral"],
    "averageResponseTime": 2.5,
    "summary": "대화 상태 요약..."
  },
  "optimizedMessages": [
    // 최적화된 메시지 목록
  ],
  "memories": [
    // 중요 메모리 목록
  ],
  "userKnowledge": {
    "schedule": {},
    "preferences": {},
    "personalInfo": {},
    "recentTopics": {},
    "sharedActivities": [],
    "implicitSignals": {},
    "moodIndicators": []
  },
  "continuity": {
    "unansweredQuestions": [],
    "topicContinuity": {},
    "strategy": {}
  },
  "relatedMemories": [
    // 연관 기억 목록
  ],
  "contextQuality": 0.85  // 0.0 ~ 1.0
}
```

## 🎯 주요 기능

### 1. 세션 관리
- 대화방별 고유 세션 생성 및 복원
- 24시간 이상 미사용 세션 자동 정리
- 세션별 통계 추적

### 2. 컨텍스트 최적화
- 메시지 우선순위 기반 선택
- 토큰 제한 내 최대 정보 보존
- 중요도 가중치:
  - 감정 변화: 0.9
  - 관계 변화: 0.85
  - 사용자 정보: 0.8
  - 주제 시작: 0.75
  - 질문/답변: 0.7/0.65

### 3. 메모리 시스템
- 중요 대화 자동 추출
- 장기/단기 메모리 분리
- 연관 기억 네트워크 구성

### 4. 대화 연속성
- 답변받지 못한 질문 추적
- 주제 전환 자연스럽게 처리
- 사용자 관심사 업데이트

## 🔧 설정 및 사용

### 초기화
```dart
// 앱 시작 시
final unifiedSystem = UnifiedConversationSystem.instance;
```

### 세션 생성
```dart
final session = await unifiedSystem.getOrCreateSession(
  conversationId: conversationId,
  userId: userId,
  personaId: personaId,
  persona: persona,
);
```

### 시스템 상태 확인
```dart
final status = unifiedSystem.getSystemStatus();
print('활성 세션: ${status['activeSessions']}');
print('컨텍스트 품질: ${status['contextQuality']}');
print('메모리 사용량: ${status['memoryUsage']}MB');
```

## 📈 성능 최적화

### 토큰 관리
- 입력 토큰: 3000 (복원됨)
- 출력 토큰: 200
- 번역 토큰: 500
- 컨텍스트 압축으로 효율성 유지

### 캐싱 전략
- 세션별 상태 캐싱
- 최근 응답 캐싱
- 메모리 네트워크 캐싱

### 병렬 처리
- 독립적인 서비스 호출 병렬화
- 배치 Firebase 작업
- 비동기 상태 업데이트

## 🎨 OpenAI API 파라미터

```dart
'temperature': 0.85,         // 자연스러운 응답
'presence_penalty': 0.3,     // 새로운 주제 유도
'frequency_penalty': 0.2,    // 반복 억제
'top_p': 0.95,              // 다양성 제어
'n': 1,                     // 응답 개수
'stream': false,            // 스트리밍 비활성화
'user': persona.id,         // 사용자 식별
```

## 🚀 향후 개선 사항

1. **실시간 동기화**: WebSocket을 통한 실시간 상태 동기화
2. **분산 캐싱**: Redis 등을 활용한 분산 캐시
3. **ML 기반 최적화**: 사용자별 맞춤 컨텍스트 선택
4. **다중 세션 지원**: 그룹 채팅 지원
5. **백업 및 복원**: 대화 히스토리 백업/복원 기능

## 📝 주의사항

1. **Firebase 의존성**: ConversationMemoryService가 Firebase를 사용하므로 초기화 필요
2. **메모리 관리**: 장시간 실행 시 세션 정리 필요
3. **토큰 제한**: OpenAI API 토큰 제한 준수
4. **동시성**: 동일 대화방 동시 접근 시 상태 충돌 가능

## 🔍 디버깅

### 로그 확인
```dart
debugPrint('🎯 Initializing conversation session: $conversationId');
debugPrint('📊 Context quality: ${context['contextQuality']}');
debugPrint('🧹 Cleaning up idle session: $key');
```

### 상태 검증
```dart
// 대화 상태 요약 확인
final summary = ConversationStateManager.generateContextSummary(conversationId);

// 세션 상태 확인
final session = _sessions[conversationId];
print('Turn count: ${session.turnCount}');
print('Context quality: ${session.contextQuality}');
```

---

**최종 업데이트**: 2025-01-20
**버전**: 1.0.0
**작성자**: Claude Code Assistant