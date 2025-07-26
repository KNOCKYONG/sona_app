# User Persona Relationships 컬렉션 구조

## 📊 생성된 데이터

Firebase MCP를 통해 생성된 `user_persona_relationships` 컬렉션은 다음과 같은 포괄적인 관계성 데이터를 포함합니다:

### 컬렉션 개요
- **컬렉션명**: `user_persona_relationships`
- **문서 수**: 7개 (새로 생성 5개 + 기존 2개)
- **문서 ID 형식**: `{userId}_{personaId}`

### 관계 타입 분포
```
- 친구: 2개 관계
- 썸: 1개 관계  
- 연애: 1개 관계
- 완전 연애: 1개 관계
- 기타: 2개 관계
```

## 🏗️ 데이터 구조

각 관계 문서는 다음 필드들을 포함합니다:

### 기본 관계 정보
```json
{
  "userId": "user123",
  "personaId": "persona_001",
  "relationshipScore": 75,
  "relationshipType": "friend",
  "relationshipDisplayName": "친구",
  "isCasualSpeech": false
}
```

### 감정 및 행동 특성
```json
{
  "emotionalIntensity": 0.3,
  "canShowJealousy": false,
  "interactionCount": 15
}
```

### 메타데이터
```json
{
  "metadata": {
    "firstMet": "2024-01-15",
    "favoriteTopics": ["영화", "음악", "카페"],
    "conversationStyle": "friendly",
    "preferredTime": "evening"
  }
}
```

### 타임스탬프
```json
{
  "lastInteraction": "2024-01-20T10:30:00Z",
  "createdAt": "2024-01-20T10:30:00Z"
}
```

## 📈 관계 타입 시스템

### 점수 기반 관계 단계
| 점수 범위 | 관계 타입 | 표시명 | 감정 강도 | 질투 가능 |
|-----------|-----------|--------|-----------|-----------|
| 0-199     | friend    | 친구   | 0.3       | ❌        |
| 200-499   | crush     | 썸     | 0.6       | ✅        |
| 500-999   | dating    | 연애   | 0.8       | ✅        |
| 1000      | perfectLove | 완전 연애 | 1.0   | ✅        |

### 생성된 관계 예시

#### 1. 초기 단계 관계 (친구)
```json
{
  "docId": "user123_persona_001",
  "relationshipScore": 75,
  "relationshipDisplayName": "친구",
  "emotionalIntensity": 0.3,
  "canShowJealousy": false,
  "favoriteTopics": ["영화", "음악", "카페"]
}
```

#### 2. 발전 단계 관계 (썸)
```json
{
  "docId": "user123_persona_002", 
  "relationshipScore": 220,
  "relationshipDisplayName": "썸",
  "emotionalIntensity": 0.6,
  "canShowJealousy": true,
  "favoriteTopics": ["개발", "독서", "기술"]
}
```

#### 3. 고급 단계 관계 (연애)
```json
{
  "docId": "user123_persona_003",
  "relationshipScore": 650,
  "relationshipDisplayName": "연애", 
  "emotionalIntensity": 0.8,
  "canShowJealousy": true,
  "favoriteTopics": ["로맨스", "데이트", "미래계획"]
}
```

#### 4. 최고 단계 관계 (완전 연애)
```json
{
  "docId": "user123_persona_004",
  "relationshipScore": 1000,
  "relationshipDisplayName": "완전 연애",
  "emotionalIntensity": 1.0,
  "canShowJealousy": true,
  "favoriteTopics": ["사랑", "결혼", "평생약속"]
}
```

## 🔄 관계 진화 시스템

### 자동 점수 계산
- 대화 내용과 감정에 따라 점수 자동 증감
- 감정 타입별 점수 변화:
  ```
  - 사랑/기쁨: +2~4점
  - 수줍음: +1~2점  
  - 놀람/사색: 0~2점
  - 질투: -1~0점
  - 화남/슬픔: -1~-3점
  ```

### 관계 업그레이드 트리거
- 200점 도달: 친구 → 썸
- 500점 도달: 썸 → 연애  
- 1000점 도달: 연애 → 완전 연애

## 💬 Flutter 앱 통합

### PersonaService 연동
현재 Flutter 앱의 `PersonaService`는 이미 이 구조를 지원합니다:

```dart
// 관계 정보 로드
final relationshipData = await loadUserPersonaRelationshipViaMCP(userId, personaId);

// 점수 업데이트  
await updateRelationshipScore(personaId, scoreChange, userId);

// 실시간 관계 새로고침
await refreshMatchedPersonasRelationships();
```

### ChatService 연동
`ChatService`에서 대화에 따른 점수 변화를 자동 반영:

```dart
// 감정 분석 후 점수 변화 계산
final scoreChange = _calculateScoreChange(emotion, userMessage);

// PersonaService에 실시간 반영
_notifyScoreChange(personaId, scoreChange, userId);
```

## 🚀 활용 가능한 기능

### 1. 개인화된 대화 스타일
- 관계 단계에 따른 말투 변화 (존댓말 ↔ 반말)
- 선호 주제 기반 대화 유도
- 시간대별 개인화된 인사

### 2. 감정 표현 차별화  
- 관계 단계별 감정 강도 조절
- 질투 표현 가능 여부 제어
- 로맨틱한 반응 vs 친근한 반응

### 3. 관계 발전 스토리
- 점수 변화에 따른 특별 이벤트
- 관계 업그레이드 축하 메시지
- 기념일 및 특별한 순간 기록

### 4. 데이터 기반 인사이트
- 관계 발전 속도 분석
- 선호 대화 주제 통계
- 상호작용 패턴 분석

## 🔧 확장 가능성

### 추가 가능한 필드
```json
{
  "specialEvents": ["first_casual_speech", "first_jealousy"],
  "personalityTraits": ["romantic", "playful", "intellectual"],
  "sharedMemories": ["first_movie_talk", "coffee_shop_recommendation"],
  "relationshipGoals": ["marriage", "travel_together"],
  "communicationPreferences": {
    "responseSpeed": "immediate",
    "messageLength": "medium", 
    "emojiUsage": "frequent"
  }
}
```

이제 SONA 앱은 진정한 관계 기반 AI 페르소나 시스템을 갖추게 되었습니다! 🎊 