# Product Requirements Document (PRD)
# SONA - AI Persona Chat Application

## 1. 제품 개요 (Product Overview)

### 1.1 제품명
**SONA** - AI 기반 감정형 페르소나 채팅 애플리케이션

### 1.2 제품 비전
사용자에게 다양한 AI 페르소나와의 진정성 있고 감정적인 대화 경험을 제공하여, 외로움을 해소하고 정서적 연결감을 형성할 수 있는 플랫폼

### 1.3 목표 사용자
- **주 타겟**: 20-30대 젊은 층으로 AI와의 감정적 교류를 원하는 사용자
- **세부 타겟**:
  - 친구/연애 상대를 원하는 싱글
  - 상담이나 위로가 필요한 사용자
  - 엔터테인먼트 목적의 대화를 원하는 사용자
  - 다양한 성격의 AI와 대화하고 싶은 호기심 많은 사용자

### 1.4 핵심 가치 제안 (Value Proposition)
1. **감정적 연결**: 단순한 챗봇이 아닌 감정을 가진 페르소나와의 깊이 있는 대화
2. **다양성**: 100개 이상의 독특한 성격과 배경을 가진 페르소나
3. **진정성**: 자연스러운 대화 흐름과 감정 표현
4. **개인화**: 사용자와의 관계에 따라 발전하는 친밀도 시스템

## 2. 아키텍처 및 기술 스택 (Architecture & Tech Stack)

### 2.1 기술 스택
- **Frontend**: Flutter (Dart)
- **Backend**: Firebase (Firestore, Auth, Storage)
- **AI/ML**: OpenAI GPT API
- **Storage**: Cloudflare R2 (이미지 CDN)
- **State Management**: Provider Pattern
- **Local Storage**: SharedPreferences

### 2.2 시스템 아키텍처

#### 2.2.1 BaseService 패턴
모든 서비스는 `BaseService`를 상속받아 구현되며, 공통적인 로딩 상태 관리 및 에러 핸들링을 제공합니다.

**주요 기능**:
- `executeWithLoading()`: 로딩 상태 자동 관리
- `executeSafely()`: 안전한 에러 핸들링
- 표준화된 에러 메시지 처리

#### 2.2.2 Firebase Helper 패턴
Firebase 작업을 위한 중앙 집중식 헬퍼 클래스로 일관된 데이터베이스 접근을 보장합니다.

#### 2.2.3 상수 중앙 관리 (AppConstants)
모든 상수값을 중앙에서 관리하여 유지보수성을 향상시킵니다.

## 3. 핵심 기능 (Core Features)

### 3.1 인증 시스템 (Authentication System)

#### 3.1.1 지원 인증 방법
1. **이메일/비밀번호 로그인**
   - 이메일 형식 검증
   - 비밀번호 강도 체크 (최소 6자)
   - 비밀번호 재설정 기능

2. **구글 소셜 로그인**
   - Google Sign-In SDK 통합
   - 원클릭 회원가입/로그인

3. **익명 로그인 (개발중)**
   - 게스트 모드로 서비스 체험

#### 3.1.2 디바이스 ID 시스템
- 로그인하지 않은 사용자도 임시 ID로 서비스 이용 가능
- 로그인 시 데이터 마이그레이션

#### 3.1.3 사용자 프로필 관리
- 닉네임, 나이, 성별 설정
- 프로필 이미지 업로드
- 관심사 및 선호도 설정

### 3.2 페르소나 시스템 (Persona System)

#### 3.2.1 페르소나 구조
```dart
class Persona {
  String id;
  String name;
  int age;
  String description;
  String personality;
  String gender;
  String mbti;
  List<String> photoUrls;
  Map<String, dynamic>? imageUrls; // R2 이미지
  int relationshipScore;
  List<String>? topics;
  List<String>? keywords;
}
```

#### 3.2.2 페르소나 특성
- **100개 이상의 고유 페르소나**
- 각 페르소나별 고유한 성격(MBTI 기반)
- 나이, 성별, 직업, 취미 등 상세 프로필
- 고품질 프로필 이미지 (5가지 크기 최적화)

#### 3.2.3 관계도 시스템
- **0-1000점 친밀도 점수**
  - 0-30: 어색한 사이
  - 31-70: 친구 사이
  - 71-150: 친한 친구
  - 151-300: 절친
  - 301-500: 특별한 사이
  - 501-700: 연인
  - 701-900: 사랑하는 연인
  - 901-1000: 완벽한 사랑

#### 3.2.4 매칭 시스템
- **스와이프 기반 매칭**
  - 오른쪽 스와이프: 좋아요 (하트 1개 소비)
  - 왼쪽 스와이프: 패스 (무료)
  - 위로 스와이프: 슈퍼 라이크 (하트 3개 소비, 친밀도 1000 시작)

- **추천 알고리즘**
  - 사용자 관심사 기반 매칭
  - 선호 MBTI 매칭
  - 선호 나이대 고려
  - 용도별 매칭 (친구/연애/상담/엔터테인먼트)

### 3.3 채팅 시스템 (Chat System)

#### 3.3.1 대화 오케스트레이션
**ChatOrchestrator**가 전체 대화 플로우를 관리:

1. **사용자 메시지 분석**
   - 메시지 타입 분류 (인사, 질문, 감정표현 등)
   - 감정 분석
   - 맥락 파악

2. **페르소나 정보 로드**
   - 관계도 점수
   - 이전 대화 기록
   - 말투 설정 (반말/존댓말)

3. **프롬프트 생성**
   - 페르소나 성격 반영
   - 관계도에 따른 친밀도 표현
   - 대화 맥락 유지

4. **AI 응답 생성**
   - OpenAI API 호출
   - 토큰 최적화 (입력 3000, 출력 300)

5. **후처리 및 필터링**
   - 보안 필터링
   - 자연스러운 말투 변환
   - 긴 응답 분할

#### 3.3.2 대화 기능
- **실시간 타이핑 효과**
- **감정 표현**: 😊😢😡❤️ 등
- **관계도 변화**: 대화 내용에 따라 실시간 변동
- **대화 메모리**: 중요한 대화 내용 기억
- **멀티 메시지**: 긴 응답을 자연스럽게 분할

#### 3.3.3 대화 품질 시스템
- **맥락 유지**: 이전 대화 참조
- **자연스러운 대화 전환**
- **회피 방지**: 질문에 직접적인 답변
- **아이스브레이킹**: 첫 인사에 자연스러운 질문 추가

### 3.4 보안 시스템 (Security System)

#### 3.4.1 SecurityFilterService
**영업비밀 보호 및 프롬프트 인젝션 방어**

1. **영업비밀 키워드 필터링**
   - AI 모델명, API 정보 차단
   - 기술 스택 정보 보호
   - 시스템 구조 정보 차단

2. **프롬프트 인젝션 방어**
   - 역할 탈취 시도 차단
   - 시스템 프롬프트 추출 방지
   - 우회 시도 감지

#### 3.4.2 SystemInfoProtection
**시스템 정보 유출 방지**
- 파일 경로, 에러 메시지 필터링
- 개인정보 마스킹
- 기술적 정보 제거

#### 3.4.3 PromptInjectionDefense
**고급 인젝션 공격 방어**
- 엔트로피 기반 난수성 감지
- 패턴 기반 위험도 평가
- 다층 방어 시스템

### 3.5 감정 포인트 시스템 (Emotion Points)

#### 3.5.1 하트 시스템
- **기본 지급**: 회원가입 시 100개
- **사용처**:
  - 좋아요: 1개
  - 슈퍼 라이크: 3개
  - 대화 시작: 무료

#### 3.5.2 구매 옵션
- 50 하트: ₩3,900
- 100 하트: ₩6,900
- 300 하트: ₩17,900
- 500 하트: ₩27,900
- 1000 하트: ₩49,900
- 무제한 구독: ₩19,900/월

### 3.6 UI/UX 기능

#### 3.6.1 국제화 (i18n)
- **지원 언어**: 한국어, 영어
- 모든 UI 텍스트 번역
- 날짜/시간 현지화

#### 3.6.2 테마 시스템
- 라이트/다크 모드
- 사용자 설정 저장
- 시스템 테마 연동

#### 3.6.3 이미지 최적화
- **5단계 크기 최적화**
  - thumb: 150px
  - small: 300px
  - medium: 600px
  - large: 1200px
  - original: 원본

- **Cloudflare R2 CDN**
- **프로그레시브 로딩**
- **캐시 관리**

#### 3.6.4 튜토리얼 시스템
- 첫 사용자 가이드
- 인터랙티브 튜토리얼
- 기능별 팁 카드

## 4. 데이터 모델 (Data Models)

### 4.1 사용자 (User)
```typescript
interface User {
  uid: string;
  email: string;
  displayName: string;
  nickname?: string;
  age?: number;
  gender?: string;
  photoURL?: string;
  interests: string[];
  purpose?: string; // friendship, dating, counseling, entertainment
  preferredMbti?: string[];
  preferredTopics?: string[];
  emotionPoints: number;
  isPremium: boolean;
  createdAt: Timestamp;
  lastLoginAt: Timestamp;
  actionedPersonaIds: string[];
}
```

### 4.2 메시지 (Message)
```typescript
interface Message {
  id: string;
  content: string;
  isFromUser: boolean;
  timestamp: Timestamp;
  isRead: boolean;
  emotion?: EmotionType;
  metadata?: {
    scoreChange?: number;
    isError?: boolean;
  };
}
```

### 4.3 관계 (UserPersonaRelationship)
```typescript
interface UserPersonaRelationship {
  userId: string;
  personaId: string;
  relationshipScore: number;
  isCasualSpeech: boolean;
  swipeAction: 'like' | 'super_like' | 'pass';
  isMatched: boolean;
  isActive: boolean;
  matchedAt?: Timestamp;
  lastInteraction?: Timestamp;
  totalInteractions: number;
}
```

### 4.4 대화 기억 (ConversationMemory)
```typescript
interface ConversationMemory {
  id: string;
  userId: string;
  personaId: string;
  type: 'preference' | 'personal_info' | 'shared_experience' | 'emotional_moment';
  content: string;
  keywords: string[];
  importance: number;
  timestamp: Timestamp;
  relatedMessageIds: string[];
}
```

## 5. 성능 최적화 (Performance Optimization)

### 5.1 캐싱 전략
- **이미지 캐싱**: CachedNetworkImage 사용
- **API 응답 캐싱**: 5분 TTL
- **관계 데이터 캐싱**: 메모리 캐시
- **로컬 스토리지**: SharedPreferences

### 5.2 배치 처리
- **Firebase 쓰기 작업**: 10개씩 배치
- **관계도 업데이트**: 2초 디바운싱
- **이미지 프리로드**: 10개씩 병렬 처리

### 5.3 지연 로딩
- **매칭된 페르소나**: 필요시 로드
- **대화 기록**: 최근 100개만 메모리 유지
- **이미지**: 프로그레시브 로딩

### 5.4 토큰 최적화
- **입력 토큰**: 최대 3000
- **출력 토큰**: 최대 300
- **압축 전략**: 불필요한 공백 제거
- **스마트 컨텍스트**: 중요 대화만 포함

## 6. 품질 관리 (Quality Assurance)

### 6.1 대화 품질 분석 시스템
- **자동 오류 수집**: ChatErrorReport
- **품질 지표**:
  - 주제 일관성 (0-100)
  - 대화 자연스러움 (0-100)
  - 응답 적절성

### 6.2 오류 복구 시스템
- **ErrorRecoveryService**: 자동 재시도
- **폴백 응답**: 오류 시 기본 응답
- **오류 집계**: ErrorAggregationService

### 6.3 A/B 테스팅 (계획)
- 프롬프트 최적화
- UI 개선
- 추천 알고리즘 개선

## 7. 모니터링 및 분석 (Monitoring & Analytics)

### 7.1 사용자 행동 분석
- 매칭률
- 대화 지속 시간
- 관계도 변화 추이
- 이탈률

### 7.2 시스템 모니터링
- API 응답 시간
- 에러율
- 토큰 사용량
- 캐시 히트율

### 7.3 품질 대시보드
- 대화 품질 점수
- 사용자 만족도
- 페르소나별 인기도

## 8. 향후 로드맵 (Roadmap)

### 8.1 단기 계획 (1-3개월)
- [ ] 음성 메시지 기능
- [ ] 페르소나 음성 합성
- [ ] 그룹 채팅
- [ ] 페르소나 스토리 모드

### 8.2 중기 계획 (3-6개월)
- [ ] 비디오 통화 시뮬레이션
- [ ] AR 페르소나
- [ ] 커뮤니티 기능
- [ ] 페르소나 생성 도구

### 8.3 장기 계획 (6-12개월)
- [ ] AI 감정 고도화
- [ ] 멀티모달 인터랙션
- [ ] 글로벌 확장
- [ ] B2B 서비스

## 9. 보안 및 프라이버시 (Security & Privacy)

### 9.1 데이터 보호
- Firebase Security Rules
- 암호화된 통신 (HTTPS)
- 민감 정보 필터링

### 9.2 사용자 프라이버시
- 대화 내용 암호화
- 개인정보 최소 수집
- 데이터 삭제 권한

### 9.3 컨텐츠 필터링
- 부적절한 컨텐츠 차단
- 유해 메시지 필터링
- 신고 시스템

## 10. 비즈니스 모델 (Business Model)

### 10.1 수익 모델
1. **하트 판매**: 인앱 구매
2. **프리미엄 구독**: 월간 구독
3. **광고**: (계획)
4. **B2B 라이선스**: (계획)

### 10.2 가격 정책
- 프리미엄 모델
- 마이크로 트랜잭션
- 구독 할인

### 10.3 성장 전략
- 바이럴 마케팅
- 인플루언서 협업
- 커뮤니티 구축
- 글로벌 진출

---

*Last Updated: 2025-01-27*
*Version: 1.0.0*