# ChatService 리팩토링 계획

## 현재 상황 분석
- **파일 크기**: 4,167 라인 (너무 거대함)
- **책임**: 15개 이상의 서로 다른 책임
- **복잡도**: 매우 높음
- **유지보수성**: 낮음

## 모듈 분리 계획

### 1. 메시지 관리 모듈 (`message_manager.dart`)
**책임**: 메시지 CRUD 작업
```dart
class MessageManager {
  // 메시지 로드/저장
  Future<List<Message>> loadMessages(String personaId);
  Future<void> saveMessage(Message message);
  Future<void> markAsRead(String personaId, List<Message> messages);
  
  // 메시지 페이지네이션
  Future<void> loadMoreMessages(String userId, String personaId);
  bool hasMoreMessages(String personaId);
  
  // 메시지 관리
  void clearMessages();
  List<Message> getMessages(String personaId);
}
```

### 2. AI 응답 처리 모듈 (`ai_response_handler.dart`)
**책임**: AI 응답 생성 및 처리
```dart
class AIResponseHandler {
  // AI 응답 생성
  Future<String> generateResponse(String userId, Persona persona, String message);
  Future<void> processDelayedResponse(String userId, Persona persona);
  
  // 타이핑 인디케이터
  bool isPersonaTyping(String personaId);
  void setTypingStatus(String personaId, bool isTyping);
  
  // 응답 큐 관리
  void queueMessageForDelayedResponse(QueuedMessage message);
}
```

### 3. Firebase 동기화 모듈 (`firebase_sync_service.dart`)
**책임**: Firebase와의 데이터 동기화
```dart
class FirebaseSyncService {
  // 배치 쓰기
  Future<void> processBatchWrite(List<PendingMessage> messages);
  
  // Firebase 읽기/쓰기
  Future<List<Message>> loadFromFirebase(String userId, String personaId);
  Future<void> saveToFirebase(String userId, String personaId, Message message);
  
  // 실시간 동기화
  Stream<List<Message>> syncMessages(String userId, String personaId);
}
```

### 4. 캐시 관리 모듈 (`chat_cache_manager.dart`)
**책임**: 응답 및 데이터 캐싱
```dart
class ChatCacheManager {
  // 응답 캐시
  String? getCachedResponse(String key);
  void addToCache(String key, CachedResponse response);
  void clearCache();
  
  // 메모리 관리
  void cleanupOldCache();
  int getCacheSize();
}
```

### 5. 대화 메모리 모듈 (`conversation_memory_handler.dart`)
**책임**: 대화 메모리 및 요약 관리
```dart
class ConversationMemoryHandler {
  // 메모리 관리
  Future<void> preloadMemory(String userId, String personaId);
  Future<void> createSummary(String userId, String personaId, List<Message> messages);
  
  // 컨텍스트 빌드
  Future<String> buildContext(List<Message> messages, Persona persona);
}
```

### 6. 에러 처리 모듈 (`chat_error_handler.dart`)
**책임**: 에러 처리 및 리포팅
```dart
class ChatErrorHandler {
  // 에러 리포팅
  Future<void> sendErrorReport(ChatErrorReport report);
  Future<void> sendAutomaticErrorReport(Map<String, dynamic> errorData);
  
  // 에러 복구
  Future<bool> retryMessage(String messageId);
  String getFallbackResponse(Persona persona);
}
```

### 7. 튜토리얼 처리 모듈 (`tutorial_handler.dart`)
**책임**: 튜토리얼 관련 기능
```dart
class TutorialHandler {
  // 튜토리얼 메시지
  Future<void> addTutorialMessage(Message message);
  Future<int> getTutorialMessageCount();
  
  // 튜토리얼 점수
  void updateTutorialPersonaScore(Persona persona, int scoreChange);
}
```

### 8. 메시지 분할 모듈 (`message_splitter.dart`)
**책임**: 긴 메시지 분할 처리
```dart
class MessageSplitter {
  // 메시지 분할
  List<String> splitMessageContent(String content, {bool isExpert = false});
  List<String> splitIntoSentences(String text);
  bool shouldCombineSentences(String first, String second);
  
  // 문장 완성 체크
  bool isIncompleteSentence(String text);
}
```

### 9. 감정 분석 모듈 (`emotion_analyzer.dart`)
**책임**: 메시지 감정 분석
```dart
class EmotionAnalyzer {
  // 감정 분석
  Map<EmotionType, double> analyzeEmotions(String message);
  EmotionType getDominantEmotion(String message);
  
  // 무례함 체크
  RudeMessageCheck checkRudeMessage(String message);
}
```

### 10. 메인 ChatService 리팩토링
**책임**: 코디네이터 역할
```dart
class ChatService extends BaseService {
  // 의존성 주입
  final MessageManager _messageManager;
  final AIResponseHandler _aiHandler;
  final FirebaseSyncService _firebaseSync;
  final ChatCacheManager _cacheManager;
  final ConversationMemoryHandler _memoryHandler;
  final ChatErrorHandler _errorHandler;
  final TutorialHandler _tutorialHandler;
  final MessageSplitter _messageSplitter;
  final EmotionAnalyzer _emotionAnalyzer;
  
  // 퍼사드 메서드들 (기존 API 유지)
  Future<bool> sendMessage({...}) {
    // 각 모듈 조합하여 처리
  }
  
  Future<void> loadChatHistory(...) {
    // 각 모듈 조합하여 처리
  }
}
```

## 구현 순서

### Phase 1: 기초 모듈 분리 (우선순위 높음)
1. `message_manager.dart` - 메시지 관리
2. `chat_cache_manager.dart` - 캐시 관리
3. `message_splitter.dart` - 메시지 분할

### Phase 2: 핵심 기능 분리
4. `ai_response_handler.dart` - AI 응답 처리
5. `firebase_sync_service.dart` - Firebase 동기화
6. `conversation_memory_handler.dart` - 대화 메모리

### Phase 3: 부가 기능 분리
7. `chat_error_handler.dart` - 에러 처리
8. `tutorial_handler.dart` - 튜토리얼
9. `emotion_analyzer.dart` - 감정 분석

### Phase 4: 통합 및 최적화
10. 메인 `ChatService` 리팩토링
11. 의존성 주입 패턴 적용
12. 테스트 작성

## 예상 효과

### 코드 품질 개선
- **파일 크기**: 4,167줄 → 각 모듈 200-400줄
- **단일 책임 원칙**: 각 모듈이 하나의 책임만 가짐
- **테스트 가능성**: 각 모듈 독립적 테스트 가능
- **유지보수성**: 50% 이상 향상

### 성능 개선
- **메모리 사용**: 모듈화로 필요한 부분만 로드
- **처리 속도**: 병렬 처리 가능한 부분 분리
- **캐싱 효율**: 전용 캐시 매니저로 최적화

### 개발 생산성
- **디버깅**: 문제 영역 빠르게 파악
- **기능 추가**: 해당 모듈만 수정
- **협업**: 모듈별 독립 작업 가능

## 주의사항

1. **기존 API 호환성 유지**: 외부에서 사용하는 메서드는 그대로 유지
2. **점진적 마이그레이션**: 한 번에 모든 것을 바꾸지 않고 단계적으로
3. **테스트 우선**: 각 모듈 분리 시 테스트 작성
4. **문서화**: 각 모듈의 책임과 인터페이스 명확히 문서화

---

**작성일**: 2025-01-10
**예상 작업 시간**: 각 모듈 2-4시간, 총 20-30시간
**위험도**: 중간 (기존 API 유지로 안전성 확보)