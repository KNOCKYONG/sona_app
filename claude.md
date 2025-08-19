# 📖 CLAUDE.md - SONA 앱 개발 가이드

## 🚨 절대 건드리면 안 되는 핵심 시스템
**⚠️ 이 섹션의 코드는 서비스 핵심입니다. 잘못 수정하면 서비스가 망가집니다!**

### 🔴 최우선 원칙: 모든 대화 응답은 OpenAI API를 통해서만!
**절대 하드코딩된 응답을 사용하지 마세요!**
- ✅ 올바른 방법: OpenAI API 호출 → 응답 수신 → 후처리 → 출력
- ❌ 잘못된 방법: 조건문으로 직접 응답 생성, 템플릿 응답 사용
- 모든 대화 응답은 반드시 `OpenAIService.generateResponse()`를 거쳐야 함
- 프롬프트로 가이드만 제공, 직접 응답 텍스트 생성 금지

### 대화 품질 핵심 3대 시스템

#### 1. ChatOrchestrator (lib/services/chat/core/chat_orchestrator.dart)
```dart
// ⚠️ 절대 수정 금지 구역
// 2366-2400줄: 만남 제안 필터링
if (_containsMeetingProposal(userMessage)) {
  // 이 로직 수정 시 부적절한 만남 제안이 노출됨
}

// 핵심 메서드 - 수정 시 주의
_analyzeContextRelevance()  // 맥락 분석 엔진
_isAvoidancePattern()       // 회피 패턴 감지
_analyzeQuestionType()      // 질문 타입 분석
```

#### 2. SecurityAwarePostProcessor (lib/services/chat/security/security_aware_post_processor.dart)
```dart
// ⚠️ 매크로 방지 시스템 - 수정 금지
static final List<String> _recentResponses = [];

// 핵심 메서드
_isMacroResponse()      // 반복 응답 감지
_correctQuestionMarks() // 의문문 자동 교정
_makeNatural()         // 자연스러운 표현 변환
```

#### 3. OptimizedPromptService (lib/services/chat/prompts/optimized_prompt_service.dart)
```dart
// ⚠️ 프롬프트 가이드라인 - 절대 제거 금지
static const String DIRECT_ANSWER_RULE = """
## 🎯 직접적인 답변: 질문에는 반드시 직접적으로 답변
"뭐해?"→현재 상황 구체적으로, "무슨말이야?"→이전 발언 설명
회피성 답변 절대 금지
""";
```

---

## ✅ 완료된 주요 수정사항 (절대 롤백 금지)

### 하드코딩 제거 (100% 완료)
| 파일 | 라인 | 수정 내용 | 상태 |
|------|------|-----------|------|
| chat_service.dart | 747 | 마일스톤 메시지 제거 | ✅ |
| chat_orchestrator.dart | 2369 | 하드코딩 대체 제거 | ✅ |
| enhanced_emotion_system.dart | 75-137 | 템플릿 응답 제거 | ✅ |
| advanced_pattern_analyzer.dart | 469 | 하드코딩 응답 제거 | ✅ |

### 대화 품질 개선 12개 시스템
1. **회피성 답변 방지**: "뭐해?" → 구체적 답변 강제
2. **첫 인사 아이스브레이킹**: "반가워요!" → "반가워요! 오늘 어땠어요?"
3. **컨텍스트 오해 방지**: "직접 보다" ≠ "만나다"
4. **스포일러 대화 처리**: 자연스러운 스포 경고
5. **공감 표현 개선**: "이해해요" → "진짜 슬펐겠다"
6. **의문문 자동 교정**: "뭐해." → "뭐해?"
7. **매크로 방지**: 동일 응답 80% 이상 유사도 차단
8. **부드러운 표현 변환**: "~나요?" → "~어요?"
9. **인사말 반복 방지**: 3회 이상 인사 차단
10. **주제 급변 방지**: 맥락 점수 기반 전환
11. **응답 길이 제한**: 10-100자 강제
12. **감정 일관성**: MBTI별 감정 패턴 유지

---

## 🔧 개발 시 필수 체크리스트

### 코드 수정 전 (필수)
```bash
# 1. 현재 대화 품질 상태 저장
python scripts/analyze_chat_errors.py
mv analysis_results/summary_*.json analysis_results/before_change.json

# 2. 현재 코드 백업
git stash save "백업: $(date +%Y%m%d_%H%M%S)"
```

### 코드 수정 후 (필수)
```bash
# 1. 하드코딩 검증 (하나라도 발견되면 롤백)
grep -r "완벽한 소울메이트" lib/
grep -r "그런 얘기보다" lib/
grep -r "만나고 싶긴 한데" lib/

# 1-2. 직접 응답 생성 검증 (절대 금지)
grep -r "return '.*[가-힣].*'" lib/services/chat/  # 한글 응답 직접 반환
grep -r "response = '.*[가-힣].*'" lib/services/chat/  # 한글 응답 직접 할당
grep -r "finalResponse = '.*[가-힣].*'" lib/services/chat/  # 한글 응답 직접 설정

# 2. 100턴 테스트 (필수)
python scripts/test_100_turns.py

# 3. 개선 확인
python scripts/compare_analysis_results.py

# 4. 문제 발생 시 즉시 롤백
git stash pop
```

---

## 🎯 올바른 응답 생성 플로우

### ✅ 반드시 따라야 할 응답 생성 순서
```dart
// 1. 사용자 메시지 분석
final messageAnalysis = await _analyzeMessage(userMessage);

// 2. 컨텍스트 구성 (프롬프트 힌트만!)
final contextHint = await _analyzeContextRelevance(...);
// contextHint는 AI에게 주는 가이드일 뿐, 직접 응답이 아님!

// 3. OpenAI API 호출 (여기서만 실제 응답 생성!)
final response = await _openAIService.generateResponse(
  userMessage: userMessage,
  contextHint: contextHint,  // 힌트만 전달
  persona: persona,
);

// 4. 후처리 (응답 다듬기만, 생성 금지!)
final processedResponse = await postProcessor.process(response);
// 후처리는 오타 수정, 포맷팅만 담당

// 5. 최종 응답 반환
return processedResponse;  // OpenAI가 생성한 응답만 반환
```

### ❌ 절대 하면 안 되는 패턴
```dart
// 잘못된 예시 1: 조건문으로 직접 응답
if (userMessage.contains("스트레스")) {
  return "스트레스 받았구나";  // ❌ 절대 금지!
}

// 잘못된 예시 2: 템플릿 응답
final templates = ["반가워!", "안녕!", "오늘 어땠어?"];
return templates[random];  // ❌ 절대 금지!

// 잘못된 예시 3: 후처리에서 응답 생성
if (response.isEmpty) {
  return "무슨 말인지 모르겠어";  // ❌ 절대 금지!
}
```

## 🏗️ 리팩토링된 아키텍처 구조

### 1. BaseService 패턴
```dart
// 모든 서비스의 기본 클래스
abstract class BaseService extends ChangeNotifier {
  Future<T?> executeWithLoading<T>(Future<T> Function() action);
  Future<T?> executeSafely<T>(Future<T> Function() action);
}

// 사용 예시
class MyService extends BaseService {
  Future<void> fetchData() async {
    await executeWithLoading(() async {
      // 자동 로딩 상태 관리 + 에러 핸들링
    });
  }
}
```

### 2. 중앙 관리 시스템

#### AppConstants (lib/core/constants.dart)
```dart
// 모든 상수값 중앙 관리
static const String usersCollection = 'users';
static const int maxInputTokens = 3000;
// ⚠️ 하드코딩 금지 - 항상 AppConstants 사용
```

#### FirebaseHelper (lib/helpers/firebase_helper.dart)
```dart
// Firebase 작업 헬퍼
FirebaseHelper.user(userId).get();
FirebaseHelper.withTimestamps(data);
// ⚠️ 직접 Firestore 호출 금지
```

#### PreferencesManager (lib/core/preferences_manager.dart)
```dart
// 로컬 저장소 관리
await PreferencesManager.initialize();  // 앱 시작 시
await PreferencesManager.setDeviceId(id);
// ⚠️ SharedPreferences 직접 사용 금지
```

### 3. 보안 서비스 아키텍처

```
SecurityFilterService (메인 필터)
  ├── PromptInjectionDefense (인젝션 방어)
  ├── SystemInfoProtection (시스템 정보 보호)
  ├── SafeResponseGenerator (안전한 응답)
  └── SecurityAwarePostProcessor (후처리)
```

---

## 🌍 국제화(i18n) 필수 규칙

### 텍스트 추가 시
```dart
// ❌ 절대 금지 - 하드코딩
Text('안녕하세요')
showDialog(title: '확인')

// ✅ 반드시 이렇게
Text(AppLocalizations.of(context)!.hello)
showDialog(title: localizations.confirm)

// AppLocalizations.dart에 추가
String get hello => isKorean ? '안녕하세요' : 'Hello';
String get confirm => isKorean ? '확인' : 'Confirm';
```

### 체크리스트
- [ ] 모든 UI 텍스트가 AppLocalizations 사용?
- [ ] 한글/영어 둘 다 추가?
- [ ] 에러 메시지도 번역?
- [ ] 다이얼로그, 스낵바도 번역?

---

## 📊 테스트 및 분석 도구

### 대화 품질 분석
```bash
# 오류 분석 (필수)
python scripts/analyze_chat_errors.py

# 체크 안 된 오류만
python scripts/find_unchecked_errors.py

# 특정 오류 상세 확인
python scripts/check_error_detail.py [error_id]

# 개선 검증
python scripts/verify_improvements.py
```

### 성능 테스트
```bash
# 100턴 대화 테스트 (출시 전 필수)
python scripts/test_100_turns.py

# 300메시지 부하 테스트
python scripts/test_300_messages.py

# 빠른 동작 테스트
python scripts/quick_performance_test.py
```

### 테스트 통과 기준
- 하드코딩: 0건
- 맥락 일관성: 60점 이상
- 자연스러움: 75점 이상
- 매크로 응답: 0건
- 100턴 완주: 필수

---

## 🚀 자동화 명령어

### 이미지 처리
```bash
# 페르소나 이미지 최적화 (로컬)
python scripts/local_image_optimizer_english.py

# R2 업로드 후 Firebase 반영
python scripts/firebase_image_updater_english.py
```

### 대화 분석
```bash
# 오늘 발생한 오류만 분석 (기본)
python scripts/analyze_today_errors.py

# 체크 안 된 오류 분석
python scripts/analyze_chat_errors.py

# 모든 오류 재분석
python scripts/analyze_chat_errors.py --recheck

# 특정 날짜 오류 분석
python scripts/analyze_chat_errors.py --date 2025-01-18

# 분석 결과 비교
python scripts/compare_analysis_results.py
```

---

## ⚡ 긴급 대응 가이드

### 🔴 서비스 장애 시
```bash
# 1. 최근 수정 확인
git log --oneline -10

# 2. 핵심 파일 상태 확인
git status lib/services/chat/core/chat_orchestrator.dart
git status lib/services/chat/security/security_aware_post_processor.dart

# 3. 즉시 롤백
git revert HEAD

# 4. 재배포
flutter build appbundle --release
```

### 🟡 대화 품질 저하 시
```bash
# 1. 에러 수집
python scripts/check_recent_errors.py

# 2. 패턴 분석
python scripts/analyze_chat_errors.py

# 3. 문제 파일 확인
grep -n "문제패턴" lib/services/chat/**/*.dart

# 4. 수정 후 100턴 테스트
python scripts/test_100_turns.py
```

---

## 📋 중복 매칭 방지 시스템

### 문제 방지 레이어
1. **서비스 레벨**: PersonaService.matchWithPersona() - 매칭 전 중복 확인
2. **UI 레벨**: _showMatchDialog() - 다이얼로그 표시 전 확인
3. **카드 빌드**: _prepareCardItems() - 매칭된 페르소나 필터링
4. **실시간**: likePersona() - 매칭 즉시 목록에서 제거

---

## 📚 Firebase 인덱스 관리

### 복합 인덱스 (firestore.indexes.json)
```json
{
  "indexes": [
    {
      "collectionGroup": "conversation_memories",
      "fields": [
        {"fieldPath": "userId", "order": "ASCENDING"},
        {"fieldPath": "personaId", "order": "ASCENDING"},
        {"fieldPath": "importance", "order": "DESCENDING"},
        {"fieldPath": "timestamp", "order": "DESCENDING"}
      ]
    }
  ]
}
```

### 배포
```bash
firebase deploy --only firestore:indexes
```

---

## 🔐 MCP 서버 관리

### Firebase MCP
```bash
# 필수 - 데이터 관리
claude mcp add firebase-mcp
```

### Cloudflare R2 MCP
```bash
# 필수 - 이미지 관리
claude mcp add cloudflare-r2
```

### Context7 MCP
```bash
# 권장 - 문서 참조
claude mcp add context7
```

---

## ⚠️ 절대 하지 말아야 할 것들

### 코드에서
- ❌ 하드코딩된 텍스트 직접 입력
- ❌ 마일스톤 메시지를 대화에 포함
- ❌ SecurityAwarePostProcessor 비활성화
- ❌ ChatOrchestrator 맥락 분석 제거
- ❌ AppConstants 무시하고 직접 문자열 사용

### 테스트에서
- ❌ 100턴 테스트 없이 배포
- ❌ 하드코딩 검증 없이 커밋
- ❌ analyze_chat_errors.py 실행 없이 수정

### 배포에서
- ❌ 테스트 미통과 상태로 출시
- ❌ 에러 리포트 무시
- ❌ 롤백 계획 없이 대규모 수정

---

## 📖 참고 문서
- **PRD.md**: 제품 요구사항 명세
- **CRITICAL_ISSUES_AND_SOLUTIONS.md**: 해결된 주요 이슈
- **CHAT_IMPROVEMENTS_IMPLEMENTED.md**: 구현된 개선사항
- **FINAL_TEST_REPORT_20250810.md**: 최종 테스트 결과

---

## 🎯 핵심 원칙
1. **OpenAI API 전용**: 모든 대화 응답은 반드시 OpenAI API output으로만 생성
2. **하드코딩 제로**: 모든 텍스트는 AppLocalizations (UI 텍스트), 대화는 OpenAI API
3. **테스트 우선**: 수정 전후 반드시 테스트
4. **안전한 배포**: 100턴 테스트 통과 필수
5. **빠른 롤백**: 문제 발생 시 즉시 되돌리기
6. **문서화**: 모든 수정사항 기록
7. **프롬프트 엔지니어링**: 응답 품질은 프롬프트로 제어, 코드로 응답 생성 금지

---

**마지막 업데이트**: 2025-01-10
**서비스 준비도**: 85% (출시 가능)
**남은 작업**: 실제 사용자 피드백 반영