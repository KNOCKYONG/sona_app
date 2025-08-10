# 소나앱 아키텍처 문서

## 📁 프로젝트 구조

```
sona_app/
├── lib/
│   ├── core/                      # 핵심 기능
│   │   ├── constants.dart         # 앱 전역 상수
│   │   └── preferences_manager.dart # 로컬 저장소 관리
│   │
│   ├── models/                    # 데이터 모델
│   │   ├── persona.dart          # 페르소나 모델
│   │   ├── message.dart          # 메시지 모델
│   │   └── user.dart             # 사용자 모델
│   │
│   ├── services/                  # 비즈니스 로직
│   │   ├── auth/                 # 인증 서비스
│   │   ├── chat/                 # 채팅 서비스 (구조화됨)
│   │   │   ├── core/            # 핵심 채팅 서비스
│   │   │   ├── security/        # 보안 관련
│   │   │   ├── intelligence/    # AI 지능 향상
│   │   │   ├── analysis/        # 분석 서비스
│   │   │   ├── prompts/         # 프롬프트 관련
│   │   │   └── utils/           # 유틸리티
│   │   ├── persona/              # 페르소나 관리
│   │   ├── purchase/             # 구매 관련
│   │   └── storage/              # 저장소 관리
│   │
│   ├── screens/                   # UI 화면
│   ├── widgets/                   # 재사용 위젯
│   ├── theme/                     # 테마 설정
│   └── l10n/                      # 국제화 (한국어/영어)
```

## 🏗️ 아키텍처 패턴

### 1. BaseService 패턴
모든 서비스는 `BaseService`를 상속받아 공통 기능 구현:
- 로딩 상태 관리
- 에러 핸들링
- 비동기 작업 실행

### 2. 싱글톤 패턴
주요 서비스들은 싱글톤으로 구현:
- `PreferencesManager` - 로컬 저장소
- `ChatOrchestrator` - 채팅 플로우 관리
- 각종 Manager 클래스들

### 3. Provider 패턴
상태 관리를 위해 Provider 사용:
- `AuthService`
- `UserService`
- `PersonaService`
- `ChatService`

## 💬 채팅 시스템 아키텍처

### Core Services (핵심)
- **ChatOrchestrator**: 전체 채팅 플로우 조정
- **ChatService**: 채팅 기능 메인 서비스
- **OpenAIService**: OpenAI API 통신

### Security Layer (보안)
- **SecurityFilterService**: 응답 필터링
- **PromptInjectionDefense**: 프롬프트 인젝션 방어
- **SystemInfoProtection**: 시스템 정보 보호
- **SafeResponseGenerator**: 안전한 응답 생성
- **SecurityAwarePostProcessor**: 보안 후처리

### Intelligence Layer (지능)
- **ConversationContextManager**: 대화 컨텍스트 관리
- **ConversationMemoryService**: 대화 기억 관리
- **ServiceOrchestrationController**: 서비스 우선순위 제어
- **ResponseRhythmManager**: 대화 리듬 관리
- **EmotionalTransferService**: 감정 미러링
- **RelationshipBoundaryService**: 관계 경계 관리

### Analysis Layer (분석)
- **PatternAnalyzerService**: 패턴 분석
- **AdvancedPatternAnalyzer**: 고급 패턴 분석
- **EmotionRecognitionService**: 감정 인식
- **EnhancedEmotionSystem**: 향상된 감정 시스템
- **UserSpeechPatternAnalyzer**: 사용자 언어 패턴 분석

### Prompts Layer (프롬프트)
- **PersonaPromptBuilder**: 페르소나 프롬프트 생성
- **OptimizedPromptService**: 최적화된 프롬프트
- **ResponsePatterns**: 응답 패턴 관리

### Utils Layer (유틸리티)
- **PersonaRelationshipCache**: 관계 캐시
- **ErrorRecoveryService**: 에러 복구
- **ErrorAggregationService**: 에러 집계
- **NaturalAIService**: 자연스러운 AI 응답

## 🔄 메시지 처리 플로우

1. **사용자 입력** → ChatService
2. **전처리** → 보안 필터링, 패턴 분석
3. **컨텍스트 준비** → 기억, 관계, 감정 상태 로드
4. **서비스 선택** → 토큰 예산 내 최적 서비스 3개 선택
5. **프롬프트 생성** → 페르소나별 최적화된 프롬프트
6. **OpenAI API 호출** → GPT-4 모델
7. **후처리** → 보안 필터, 자연스러운 표현 변환
8. **응답 전달** → 사용자에게 표시

## 🚀 성능 최적화

### 토큰 관리
- 입력: 최대 3000 토큰
- 출력: 최대 200 토큰 (번역 시 500)
- 서비스당 토큰 예산 관리
- 압축된 힌트 사용으로 50-70% 절감

### 캐싱 전략
- 페르소나 관계 캐시
- 대화 컨텍스트 캐시
- 감정 상태 캐시
- 서비스 응답 캐시

### 병렬 처리
- 독립적인 서비스 병렬 실행
- 배치 도구 호출
- 비동기 Firebase 작업

## 🔐 보안 기능

### 다층 방어
1. **입력 검증**: 프롬프트 인젝션 감지
2. **출력 필터링**: 민감 정보 제거
3. **시스템 보호**: 내부 정보 차단
4. **안전 응답**: 위험 상황 시 대체 응답

### 프라이버시
- 개인정보 자동 마스킹
- 대화 내용 암호화
- 사용자별 격리

## 🌏 국제화 (i18n)

### 지원 언어
- 한국어 (기본)
- 영어

### 구현 방식
- `AppLocalizations` 클래스
- 동적 언어 전환
- 모든 UI 텍스트 현지화

## 📊 모니터링

### 품질 메트릭
- 대화 맥락 점수 (0-100)
- 자연스러움 점수 (0-100)
- 감정 일치도
- 응답 시간

### 에러 추적
- Firebase Crashlytics
- 에러 집계 서비스
- 자동 복구 메커니즘

## 🔧 개발 가이드

### 새 서비스 추가
1. `BaseService` 상속
2. 적절한 디렉토리에 위치
3. ChatOrchestrator에 통합
4. 토큰 예산 설정

### 테스팅
- 단위 테스트: 각 서비스별
- 통합 테스트: 전체 플로우
- 성능 테스트: 토큰 사용량

### 디버깅
- 각 서비스별 `printDebugInfo()` 메서드
- 토큰 사용량 모니터링
- 서비스 호출 통계