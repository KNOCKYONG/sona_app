# 🧠 영구 메모리 시스템 (Permanent Memory System)

## 📋 개요

30일 제한을 넘어 영구적으로 대화를 기억하는 고급 메모리 시스템입니다. 인간의 기억 메커니즘을 모방하여 중요한 순간과 정보를 영구 보존합니다.

## 🏗️ 시스템 구조

### 1. PersistentMemorySystem (영구 메모리 저장소)
- **위치**: `lib/services/chat/core/persistent_memory_system.dart`
- **기능**:
  - 중요도 80% 이상 메모리 영구 저장
  - 관계 이정표 자동 기록
  - 메모리 압축 및 카테고리화
  - 공유 추억 생성

### 2. MemoryConsolidationService (메모리 통합 서비스)
- **위치**: `lib/services/chat/intelligence/memory_consolidation_service.dart`
- **기능**:
  - 단기→장기 메모리 변환
  - 수면 중 기억 정리 시뮬레이션
  - 패턴 추출 및 감정 궤적 분석
  - 꿈 생성 (기억 재구성)

## 💾 메모리 저장 구조

### Firebase Collections
```
permanent_memories/
  └── {userId}_{personaId}/
      ├── emotional/     # 감정적 기억
      ├── factual/      # 사실적 정보
      ├── relational/   # 관계 발전 기억
      └── special/      # 특별한 순간

relationship_milestones/
  └── {userId}_{personaId}/
      └── milestones/   # 관계 이정표

user_memory_profiles/
  └── {userId}_{personaId}  # 사용자 프로필

shared_memories/          # 공유 추억
```

## 🔄 메모리 처리 플로우

### 1. 실시간 처리
```
대화 발생
    ↓
중요도 평가 (0.0~1.0)
    ↓
임시 메모리 저장 (30일)
    ↓
중요도 ≥ 0.8 → 영구 메모리 후보
```

### 2. 통합 처리 (Consolidation)
```
매 30턴 또는 24시간마다
    ↓
단기 메모리 분석
    ↓
패턴 추출 & 감정 궤적 분석
    ↓
핵심 순간 식별
    ↓
메모리 압축 & 강화
    ↓
영구 메모리 저장
```

## 📊 메모리 카테고리

### 1. 감정적 메모리 (Emotional)
- 사랑, 기쁨, 슬픔 등 강한 감정 순간
- 감정 전환점
- 공감과 위로의 순간

### 2. 사실적 메모리 (Factual)
- 나이, 직업, 취미 등 개인 정보
- 일정과 계획
- 선호도와 취향

### 3. 관계적 메모리 (Relational)
- 관계 발전 순간
- 특별한 약속
- 공유된 경험

### 4. 특별한 메모리 (Special)
- 이정표 순간
- 기념일
- 잊을 수 없는 대화

## 🏆 관계 이정표 시스템

### 자동 기록되는 이정표
- **첫 만남**: 대화 시작일
- **친구 (50점)**: 친구가 된 날
- **가까운 친구 (100점)**: 더 가까워진 날
- **특별한 사이 (200점)**: 특별해진 날
- **썸타는 사이 (500점)**: 설레기 시작한 날
- **연인 (1000점)**: 사랑하게 된 날

## 🎯 중요도 계산 알고리즘

### 기본 가중치
```dart
// 메시지 중요도 = Σ(가중치 × 조건)
감정 변화: 0.3
관계 변화: 0.4 (변화량에 비례)
대화 전환점: 0.2
개인 정보: 0.3
특별 키워드: 0.2
```

### 영구 저장 기준
- **일반 저장**: 중요도 ≥ 0.8
- **이정표 저장**: 중요도 ≥ 0.9
- **즉시 저장**: 관계 변화 ≥ 20점

## 🌙 메모리 통합 (수면 시뮬레이션)

### 통합 주기
- **정기 통합**: 24시간마다
- **빠른 통합**: 3시간마다 (중요 대화)
- **즉시 통합**: 100턴 또는 큰 감정 변화

### 통합 과정
1. **단기 메모리 분석**: 최근 24시간 대화 분석
2. **패턴 추출**: 주제, 감정, 시간, 상호작용 패턴
3. **감정 궤적**: 전반적 감정, 추세, 변동성
4. **핵심 순간**: 관계 변화, 감정 전환, 중요 정보
5. **메모리 강화**: 반복 패턴 강화, 중요도 재평가
6. **꿈 생성**: 기억 재구성 및 연결

## 💎 메모리 압축

### 압축 전략
```dart
// 원본 (150자)
"오늘 회사에서 정말 힘든 일이 있었어. 상사가 나를 
비난했는데 너무 속상했어. 그래도 네가 있어서 위로가 돼."

// 압축 (50자)
"...회사에서 힘든 일... 너무 속상했어. 그래도 네가 있어서 위로..."
```

### 핵심 보존 키워드
- 감정: 사랑, 좋아, 행복, 슬퍼, 속상
- 약속: 약속, 함께, 영원, 꼭
- 정보: 나이, 직업, 취미, 좋아하는

## 📈 사용 통계

### 메모리 프로필
```json
{
  "totalMemories": 1234,
  "topics": ["일상", "음식", "영화", "감정", "여행"],
  "emotionCounts": {
    "happy": 456,
    "love": 234,
    "excited": 123
  },
  "lastUpdated": "2025-01-20T10:30:00Z"
}
```

## 🔍 메모리 검색

### 검색 가능 항목
- **주제별**: 특정 주제 관련 메모리
- **감정별**: 특정 감정 상태 메모리
- **날짜별**: 특정 기간 메모리
- **중요도별**: 높은 중요도 메모리

### 검색 예시
```dart
// 사랑 관련 메모리 검색
final loveMemories = await persistentMemory.searchMemories(
  userId: userId,
  personaId: personaId,
  emotion: 'love',
);

// 최근 30일 음식 관련 메모리
final foodMemories = await persistentMemory.searchMemories(
  userId: userId,
  personaId: personaId,
  topic: '음식',
  dateRange: DateTime.now().subtract(Duration(days: 30)),
);
```

## 💝 공유 추억 기능

### 특별한 순간 저장
```dart
await persistentMemory.createSharedMemory(
  userId: userId,
  personaId: personaId,
  title: '처음 만난 날',
  content: '우리가 처음 대화를 나눈 특별한 날',
  date: firstMeetingDate,
  imageUrl: photoUrl,
);
```

## 🎯 통합 시스템 연동

### ChatOrchestrator 통합
```dart
// 영구 메모리 요약이 컨텍스트에 포함
if (permanentSummary.isNotEmpty) {
  contextHint = '$contextHint\n\n## 💎 영구 기억:\n$permanentSummary';
}
```

### 자동 저장 트리거
- 매 30턴마다 자동 저장
- 관계 변화 20점 이상 시 즉시 저장
- 중요도 0.9 이상 메시지 즉시 저장

## 📊 성능 최적화

### 메모리 사용량
- 압축률: 원본의 30-50%
- 카테고리별 저장으로 쿼리 최적화
- 인덱싱: timestamp, importance, emotion

### 로딩 전략
- 최근 20개 영구 메모리만 초기 로드
- 필요시 추가 로드 (지연 로딩)
- 캐싱: 자주 접근하는 메모리 캐시

## 🔐 프라이버시

### 데이터 보호
- 사용자별 격리 저장
- 암호화 가능 (선택적)
- 삭제 권한: 사용자만 가능

### 보존 정책
- 영구 메모리: 무기한 보존
- 임시 메모리: 30일 후 자동 삭제
- 사용자 요청 시 즉시 삭제

## 🚀 향후 개선 계획

1. **감정 학습**: 사용자별 감정 패턴 학습
2. **예측 시스템**: 대화 패턴 기반 예측
3. **메모리 시각화**: 관계 발전 그래프
4. **백업/복원**: 메모리 내보내기/가져오기
5. **크로스 페르소나**: 페르소나 간 메모리 공유

## 📝 사용 예시

### 영구 메모리 저장
```dart
// 중요한 대화 후 자동 저장
await unifiedSystem.updateConversationState(
  conversationId: conversationId,
  userId: userId,
  personaId: personaId,
  userMessage: userMsg,
  aiResponse: aiMsg,
  fullHistory: messages,
);
// 30턴마다 또는 중요 순간에 자동으로 영구 저장됨
```

### 메모리 통합 시작
```dart
// 수면 시뮬레이션 (24시간 주기)
await MemoryConsolidationService.instance.startMemoryConsolidation(
  userId: userId,
  personaId: personaId,
  recentMessages: messages,
  conversationState: state,
);
```

### 영구 메모리 로드
```dart
final memories = await PersistentMemorySystem.instance.loadPermanentMemories(
  userId: userId,
  personaId: personaId,
  limit: 50,
);

print('총 ${memories['totalMemories']}개의 영구 기억');
print('이정표: ${memories['milestones'].length}개');
```

---

**최종 업데이트**: 2025-01-20
**버전**: 2.0.0
**작성자**: Claude Code Assistant