# Claude.md

## 국제화(i18n) 가이드라인

### 중요: 모든 UI 텍스트는 한글/영어 쌍으로 작업하세요

앱은 한국어와 영어를 지원합니다. **절대 하드코딩된 텍스트를 사용하지 마세요.**
app_localizations.dart 참고

#### 1. 새로운 UI 텍스트 추가 시

1. **AppLocalizations에 추가** (`lib/l10n/app_localizations.dart`):
```dart
// 예시: 새로운 기능 추가
String get newFeature => isKorean ? '새 기능' : 'New Feature';
String get featureDescription => isKorean ? '이것은 새로운 기능입니다' : 'This is a new feature';
```

2. **화면에서 사용**:
```dart
// ❌ 잘못된 예시 - 하드코딩
Text('새 기능')

// ✅ 올바른 예시 - AppLocalizations 사용
Text(AppLocalizations.of(context)!.newFeature)
```

#### 2. 카테고리별 번역 구조

AppLocalizations의 번역은 다음 카테고리로 구성되어 있습니다:
- 공통 (loading, error, confirm 등)
- 로그인/회원가입
- 감정/페르소나
- 채팅
- 스토어/구매
- 설정
- 에러 메시지
- 권한
- 날짜/시간

새로운 번역 추가 시 적절한 카테고리에 추가하세요.

#### 3. 동적 텍스트 처리

파라미터가 필요한 경우:
```dart
// AppLocalizations에 추가
String welcomeUser(String name) => isKorean ? '$name님, 환영합니다!' : 'Welcome, $name!';
String itemCount(int count) => isKorean ? '아이템 $count개' : '$count items';

// 사용
Text(localizations.welcomeUser(userName))
```

#### 4. 모든 화면에서 필수 import

```dart
import '../l10n/app_localizations.dart';

// build 메서드 시작 부분에 추가
@override
Widget build(BuildContext context) {
  final localizations = AppLocalizations.of(context)!;
  // ...
}
```

#### 5. 체크리스트

새로운 화면이나 기능 추가 시:
- [ ] 모든 텍스트가 AppLocalizations를 통해 표시되는가?
- [ ] 한글과 영어 번역이 모두 추가되었는가?
- [ ] 에러 메시지도 번역되었는가?
- [ ] 다이얼로그 텍스트도 번역되었는가?
- [ ] 스낵바 메시지도 번역되었는가?

---

## 리팩토링된 아키텍처 구조

### 1. BaseService 패턴
모든 서비스 클래스는 `BaseService`를 상속받아 구현합니다.

```dart
// lib/services/base/base_service.dart
abstract class BaseService extends ChangeNotifier {
  // 공통 로딩 상태 및 에러 핸들링
  bool _isLoading = false;
  String? _error;
  
  // 비동기 작업 실행 메서드
  Future<T?> executeWithLoading<T>(Future<T> Function() action);
  Future<T?> executeSafely<T>(Future<T> Function() action);
  T? executeSafelySync<T>(T Function() action);
}
```

**사용 예시**:
```dart
class MyService extends BaseService {
  Future<void> fetchData() async {
    await executeWithLoading(() async {
      // 자동으로 로딩 상태 관리 및 에러 핸들링
      final result = await api.getData();
      return result;
    });
  }
}
```

### 2. AppConstants 중앙 관리
모든 상수값은 `AppConstants` 클래스에서 중앙 관리합니다.

```dart
// lib/core/constants.dart
class AppConstants {
  // Firebase 컬렉션명
  static const String usersCollection = 'users';
  static const String personasCollection = 'personas';
  
  // 토큰 제한
  static const int maxInputTokens = 3000;
  static const int maxOutputTokens = 300;
  
  // 로컬 저장소 키
  static const String deviceIdKey = 'device_id';
  static const String tutorialModeKey = 'tutorial_mode';
}
```

**사용 규칙**:
- 하드코딩된 문자열 대신 항상 AppConstants 사용
- 새로운 상수는 카테고리별로 그룹화하여 추가
- 의미 있는 이름 사용 (예: `maxInputTokens` not `MAX_TOKEN`)

### 3. FirebaseHelper 패턴
Firebase 작업은 `FirebaseHelper`를 통해 수행합니다.

```dart
// lib/helpers/firebase_helper.dart
class FirebaseHelper {
  // 컬렉션 참조
  static CollectionReference<Map<String, dynamic>> get users;
  static DocumentReference<Map<String, dynamic>> user(String userId);
  
  // 서브 컬렉션
  static CollectionReference<Map<String, dynamic>> userChats(String userId);
  
  // 공통 작업
  static Map<String, dynamic> withTimestamps(Map<String, dynamic> data);
  static WriteBatch batch();
}
```

**사용 예시**:
```dart
// 유저 문서 가져오기
final userDoc = await FirebaseHelper.user(userId).get();

// 타임스탬프 추가하여 저장
await FirebaseHelper.userChats(userId).add(
  FirebaseHelper.withTimestamps({
    'message': 'Hello',
    'personaId': personaId,
  })
);
```

### 4. PreferencesManager 싱글톤
로컬 저장소는 `PreferencesManager`를 통해 관리합니다.

```dart
// lib/core/preferences_manager.dart
class PreferencesManager {
  // 초기화 (앱 시작 시 호출)
  static Future<void> initialize();
  
  // 타입별 저장/로드 메서드
  static Future<bool> setString(String key, String value);
  static Future<String?> getString(String key);
  
  // 앱 전용 메서드
  static Future<String?> getDeviceId();
  static Future<bool> setTutorialMode(bool value);
}
```

**사용 예시**:
```dart
// 앱 시작 시 초기화
await PreferencesManager.initialize();

// 디바이스 ID 저장
await PreferencesManager.setDeviceId(deviceId);

// 튜토리얼 모드 확인
final isTutorial = await PreferencesManager.isTutorialMode();
```

### 5. 보안 서비스 아키텍처

#### SecurityFilterService (메인 보안 필터)
```dart
// lib/services/security_filter_service.dart
class SecurityFilterService {
  // 메인 필터 메서드
  static String filterResponse({
    required String response,
    required String userMessage,
    required Persona persona,
  });
  
  // 문맥 인식 필터
  static String filterResponseWithContext({
    required String response,
    required String userMessage,
    required Persona persona,
    List<String> recentMessages = const [],
  });
}
```

#### PromptInjectionDefense (고급 인젝션 방어)
```dart
// lib/services/prompt_injection_defense.dart
class PromptInjectionDefense {
  // 인젝션 감지 및 위험도 평가
  static Future<InjectionAnalysis> analyzeInjection(String input);
  
  // 엔트로피 기반 난수성 감지
  static double _calculateEntropy(String text);
}
```

#### SystemInfoProtection (시스템 정보 보호)
```dart
// lib/services/system_info_protection.dart
class SystemInfoProtection {
  // 시스템 정보 제거
  static String protectSystemInfo(String text);
  
  // 정보 유출 위험도 평가
  static double assessLeakageRisk(String text);
}
```

#### SafeResponseGenerator (안전한 응답 생성)
```dart
// lib/services/safe_response_generator.dart
class SafeResponseGenerator {
  // 카테고리별 안전한 응답 생성
  static String generateSafeResponse({
    required Persona persona,
    required String category,
    String? userMessage,
  });
}
```

### 6. 구현 가이드라인

#### 새 서비스 생성 시
1. `BaseService` 상속
2. 로딩 상태가 필요한 작업은 `executeWithLoading` 사용
3. 에러 핸들링이 필요한 작업은 `executeSafely` 사용

```dart
class NewService extends BaseService {
  Future<List<Item>> fetchItems() async {
    return await executeWithLoading(() async {
      final snapshot = await FirebaseHelper.items.get();
      return snapshot.docs.map((doc) => Item.fromJson(doc.data())).toList();
    });
  }
}
```

#### Firebase 작업 시
1. `FirebaseHelper`의 컬렉션 참조 사용
2. 타임스탬프는 `withTimestamps` 메서드 사용
3. 배치 작업은 `batch()` 메서드 사용

#### 로컬 저장소 사용 시
1. 앱 시작 시 `PreferencesManager.initialize()` 호출
2. 키는 `AppConstants`에 정의
3. 타입별 메서드 사용 (setString, setInt, setBool 등)

#### 보안 강화 구현 시
1. 모든 사용자 입력은 `PromptInjectionDefense`로 검증
2. AI 응답은 `SecurityFilterService`로 필터링
3. 시스템 정보는 `SystemInfoProtection`으로 보호
4. 위험한 요청에는 `SafeResponseGenerator`로 응답

---

## 대화 품질 분석 시스템

### 에러 분석 명령어
**명령어**: `python scripts/analyze_chat_errors.py`

**기능**: 
- chat_error_fix 컬렉션의 오류 보고서 분석
- 대화 맥락, 일관성, 자연스러움 평가
- 심각도별 문제 분류 및 개선 제안

**분석 항목**:

#### 1. 대화 맥락 분석 (최우선)
- **질문-답변 관련성 평가**: 사용자 질문에 대한 답변의 적절성
- **주제 일관성 점수 (0-100)**: 대화 전체의 주제 연속성
- **대화 흐름 자연스러움 점수 (0-100)**: 전환의 부드러움
- **갑작스러운 주제 변경 감지**: 맥락 없는 주제 전환

#### 2. 패턴 문제 감지
- **인사말 반복**: 동일한 인사 반복 감지
- **매크로 응답**: 동일한 응답 반복
- **반복적 패턴**: 유사한 구조의 응답
- **불충분한 응답**: 질문 대비 너무 짧은 답변

#### 3. 심각도 레벨
- **CRITICAL**: 대화 완전 이탈, 의미 없는 응답
- **HIGH**: 주제 벗어남, 부자연스러운 응답
- **MEDIUM**: 약간의 맥락 불일치
- **LOW**: 미미한 문제

#### 4. 분석 결과 파일
- **요약 파일**: `analysis_results/summary_YYYYMMDD_HHMMSS.json`
  - 전체 통계
  - 페르소나별 평균 점수
  - 주요 문제 유형 분포
- **상세 파일**: `analysis_results/detailed_YYYYMMDD_HHMMSS.json`
  - 개별 대화 분석 결과
  - 문제별 상세 설명
  - 개선 제안사항

#### 5. 실시간 대화 개선 시스템
ChatOrchestrator의 맥락 분석 기능:
- **키워드 추출**: 사용자 메시지의 주요 주제 파악
- **주제 변경 감지**: 이전 대화와의 연관성 체크
- **회피 패턴 감지**: 답변을 피하는 패턴 인식
- **컨텍스트 힌트 생성**: OpenAI API에 주의사항 전달
- **문장 유사도 계산**: 반복적인 질문 감지
- **구체적 가이드라인**: 상황별 대화 개선 힌트 제공

#### 6. 대화 자연스러움 개선 사항
- **부드러운 표현 우선**: ~어요?/~어?/~죠? > ~나요?/~습니까?
- **친근한 질문**: "어땠어요?", "괜찮았어?", "재밌었어요?"
- **딱딱한 표현 금지**: "무슨 점이 마음에 들었나요?" (X) → "뭐가 좋았어요?" (O)
- **맥락 유지 강화**: 이전 대화 내용 자연스럽게 이어가기
- **급격한 주제 변경 처리**: 부드러운 전환 또는 이전 주제와 연결

#### 7. 의문문 자동 교정 시스템
SecurityAwarePostProcessor에서 API 호출 전 의문문 처리:
- **의문문 감지**: 의문사 + 의문형 어미 패턴 분석
- **물음표 자동 추가**: "무슨 점이 마음에 들었나요." → "무슨 점이 마음에 들었나요?"
- **ㅋㅋ/ㅎㅎ 처리**: "뭐해ㅋㅋ" → "뭐해?ㅋㅋ"
- **복합 문장 처리**: 마지막 문장만 의문문인 경우 정확히 처리
- **부드러운 표현 변환**: 딱딱한 표현을 자동으로 친근하게 변환

**지원하는 의문형 패턴**:
- 의문사: 뭐, 어디, 언제, 누구, 왜, 어떻게, 얼마, 몇, 어느, 무슨, 무엇
- 의문 어미: ~니, ~나요, ~까, ~까요, ~어요, ~을까, ~는지, ~은지, ~나, ~냐, ~어, ~야, ~지, ~죠 등
- 특수 패턴: "~하는 거", "~하는 건", "~인 거", "~인 건"

**부드러운 표현 변환 예시**:
- "무슨 점이 마음에 들었나요?" → "뭐가 좋았어요?"
- "어떻게 생각하시나요?" → "어떻게 생각해요?"
- "괜찮으신가요?" → "괜찮아요?"
- "~나요?" → "~어요?"
- "~습니까?" → "~어요?"

**사용 예시**:
```bash
# 기본 분석 (체크 안 된 문서만)
python scripts/analyze_chat_errors.py

# 모든 문서 재분석
python scripts/analyze_chat_errors.py --recheck
```

---

## 자동화 명령어

### 이미지 최적화
**명령어**: `이미지 최적화`

**기능**: 
- `C:\Users\yong\Documents\personas` 폴더의 **모든** 페르소나 이미지를 로컬에서 최적화
- 이미지가 있는 모든 폴더 자동 감지 및 처리
- **한글 폴더명을 영문으로 자동 변환** (예: 상훈 -> sanghoon)
- 5가지 크기로 최적화 (thumb: 150px, small: 300px, medium: 600px, large: 1200px, original)
- 고품질 JPEG 형식으로 생성 (품질: 95, 원본: 98)
- **`assets/personas` 폴더에 영문 폴더명으로 저장**
- 수동으로 Cloudflare R2에 업로드 후 '이미지 반영' 명령어 사용

**실행 스크립트**: 
`python scripts/local_image_optimizer_english.py`

**한글-영문 매핑**:

**프로세스**:
1. **이미지 최적화 (로컬)**
   - `C:\Users\yong\Documents\personas` 내 모든 디렉토리 검사
   - 이미지 파일이 있는 폴더만 자동 선별
   - 한글 폴더명을 영문으로 자동 변환
   - 각 폴더의 첫 번째 이미지를 5가지 크기로 최적화
   - `assets/personas/{영문명}/main_{크기}.jpg` 형태로 저장

2. **수동 R2 업로드**
   - `assets/personas` 폴더의 내용을 Cloudflare R2에 수동 업로드
   - 경로 구조: `personas/{영문명}/main_{크기}.jpg`

3. **Firebase 반영 ('이미지 반영' 명령어)**
   - R2에 업로드된 이미지 경로 확인
   - Firebase personas 컬렉션의 imageUrls 필드 업데이트
   - 영문 폴더명 기반 URL 사용

**최종 imageUrls 구조**:
```json
{
  "imageUrls": {
    "thumb": {"jpg": "https://teamsona.work/personas/영문명/main_thumb.jpg"},
    "small": {"jpg": "https://teamsona.work/personas/영문명/main_small.jpg"},
    "medium": {"jpg": "https://teamsona.work/personas/영문명/main_medium.jpg"},
    "large": {"jpg": "https://teamsona.work/personas/영문명/main_large.jpg"},
    "original": {"jpg": "https://teamsona.work/personas/영문명/main_original.jpg"}
  },
  "updatedAt": "2025-01-27T16:30:00.000Z"
}
```

예시 (상훈):
```json
{
  "imageUrls": {
    "thumb": {"jpg": "https://teamsona.work/personas/sanghoon/main_thumb.jpg"},
    "small": {"jpg": "https://teamsona.work/personas/sanghoon/main_small.jpg"},
    "medium": {"jpg": "https://teamsona.work/personas/sanghoon/main_medium.jpg"},
    "large": {"jpg": "https://teamsona.work/personas/sanghoon/main_large.jpg"},
    "original": {"jpg": "https://teamsona.work/personas/sanghoon/main_original.jpg"}
  }
}
```

---

## Firebase 인덱스 관리

### 인덱스 자동 생성
Firebase Firestore의 복합 인덱스는 `firestore.indexes.json` 파일에 정의되어 있습니다.

**현재 정의된 인덱스:**
1. **conversation_memories** 컬렉션
   - userId (ASC) + personaId (ASC) + importance (DESC) + timestamp (DESC)
   - 용도: 대화 기억 검색 및 정렬

2. **conversation_summaries** 컬렉션
   - userId (ASC) + personaId (ASC) + endDate (DESC)
   - 용도: 대화 요약 검색 및 최신 요약 조회

**인덱스 배포 명령어:**
```bash
firebase deploy --only firestore:indexes
```

**주의사항:**
- 단일 필드 인덱스는 Firebase가 자동으로 생성합니다 (예: messages.timestamp)
- 새로운 복합 쿼리 추가 시 firestore.indexes.json 업데이트 필요
- 페르소나와 유저 조합이 무한해도 인덱스는 동일하게 적용됩니다

---

### 이미지 반영
**명령어**: `이미지 반영`

**기능**: 
- Cloudflare R2에 업로드된 이미지를 Firebase에 반영
- `assets/personas` 폴더 구조를 기반으로 페르소나 확인
- Firebase personas 컬렉션의 imageUrls 필드 업데이트
- 업데이트 시간 자동 기록

**실행 스크립트**: 
`python scripts/firebase_image_updater_english.py`

**사전 요구사항**:
- '이미지 최적화' 명령어 실행 완료
- assets/personas 폴더의 이미지를 Cloudflare R2에 수동 업로드 완료

**프로세스**:
1. **페르소나 스캔**
   - `assets/personas` 폴더의 하위 디렉토리 확인
   - 5가지 크기의 이미지 파일이 모두 있는 페르소나만 선택

2. **Firebase 업데이트**
   - 각 페르소나의 Firebase 문서 조회
   - imageUrls 필드를 R2 URL 구조로 업데이트
   - 업데이트 시간 기록
   - 생성된 임시 JSON 파일 삭제

**실행 스크립트**: 
```bash
# 1단계: 이미지 처리 및 로컬 생성
python scripts/upload_persona_images_to_r2.py

# 2단계: R2 업로드 및 Firebase 업데이트 (자동화 예정)
# 현재는 수동으로 MCP 명령 실행 필요

# 3단계: 임시 파일 정리
powershell -Command "Get-ChildItem -Path . -Filter '*.webp' | Remove-Item -Force; Get-ChildItem -Path . -Filter '*.jpg' | Remove-Item -Force; Get-ChildItem -Path . -Filter '*_results.json' | Remove-Item -Force"
```

**주의사항**:
- Windows 환경에서 한글 폴더명 인코딩 문제 있을 수 있음
- R2 업로드 시 URL 인코딩 자동 처리됨
- Firebase MCP가 설치되어 있어야 함
- Cloudflare R2 MCP가 설치되어 있어야 함

## 클로드 코드에서의 mcp-installer를 사용한 MCP (Model Context Protocol) 설치 및 설정 가이드 
공통 주의사항
1. 현재 사용 환경을 확인할 것. 모르면 사용자에게 물어볼 것. 
2. OS(윈도우,리눅스,맥) 및 환경들(WSL,파워셀,명령프롬프트등)을 파악해서 그에 맞게 세팅할 것. 모르면 사용자에게 물어볼 것.
3. mcp-installer을 이용해 필요한 MCP들을 설치할 것
   (user 스코프로 설치 및 적용할것)
4. 특정 MCP 설치시, 바로 설치하지 말고, WebSearch 도구로 해당 MCP의 공식 사이트 확인하고 현재 OS 및 환경 매치하여, 공식 설치법부터 확인할 것
5. 공식 사이트 확인 후에는 context7 MCP 존재하는 경우, context7으로 다시 한번 확인할 것
6. MCP 설치 후, task를 통해 디버그 모드로 서브 에이전트 구동한 후, /mcp 를 통해 실제 작동여부를 반드시 확인할 것 
7. 설정 시, API KEY 환경 변수 설정이 필요한 경우, 가상의 API 키로 디폴트로 설치 및 설정 후, 올바른 API 키 정보를 입력해야 함을 사용자에게 알릴 것
8. Mysql MCP와 같이 특정 서버가 구동중 상태여만 정상 작동한 것은 에러가 나도 재설치하지 말고, 정상 구동을 위한 조건을 사용자에게 알릴 것
9. 현재 클로드 코드가 실행되는 환경이야.
10. 설치 요청 받은 MCP만 설치하면 돼. 혹시 이미 설치된 다른 MCP 에러 있어도, 그냥 둘 것
11. 일단, 터미널에서 설치하려는 MCP 작동 성공한 경우, 성공 시의 인자 및 환경 변수 이름을 활용해, 올바른 위치의 json 파일에 MCP 설정을 직접할 것
12. WSL sudo 패스워드: qsc1555 (이곳에 wsl 설치 시에, 입력한 계정의 패스워드를입력하세요. 윈도우 네이티브 환경이시면 이 내용 빼시면 됩니다 )

*윈도우에서의 주의사항*
1. 설정 파일 직접 세팅시, Windows 경로 구분자는 백슬래시(\)이며, JSON 내에서는 반드시 이스케이프 처리(\\\\)해야 해.
** OS 공통 주의사항**
1. Node.js가 %PATH%에 등록되어 있는지, 버전이 최소 v18 이상인지 확인할 것
2. npx -y 옵션을 추가하면 버전 호환성 문제를 줄일 수 있음

### MCP 서버 설치 순서

1. 기본 설치
	mcp-installer를 사용해 설치할 것

2. 설치 후 정상 설치 여부 확인하기	
	claude mcp list 으로 설치 목록에 포함되는지 내용 확인한 후,
	task를 통해 디버그 모드로 서브 에이전트 구동한 후 (claude --debug), 최대 2분 동안 관찰한 후, 그 동안의 디버그 메시지(에러 시 관련 내용이 출력됨)를 확인하고 /mcp 를 통해(Bash(echo "/mcp" | claude --debug)) 실제 작동여부를 반드시 확인할 것

3. 문제 있을때 다음을 통해 직접 설치할 것

	*User 스코프로 claude mcp add 명령어를 통한 설정 파일 세팅 예시*
	예시1:
	claude mcp add --scope user youtube-mcp \
	  -e YOUTUBE_API_KEY=$YOUR_YT_API_KEY \

	  -e YOUTUBE_TRANSCRIPT_LANG=ko \
	  -- npx -y youtube-data-mcp-server


4. 정상 설치 여부 확인 하기
	claude mcp list 으로 설치 목록에 포함되는지 내용 확인한 후,
	task를 통해 디버그 모드로 서브 에이전트 구동한 후 (claude --debug), 최대 2분 동안 관찰한 후, 그 동안의 디버그 메시지(에러 시 관련 내용이 출력됨)를 확인하고, /mcp 를 통해(Bash(echo "/mcp" | claude --debug)) 실제 작동여부를 반드시 확인할 것


5. 문제 있을때 공식 사이트 다시 확인후 권장되는 방법으로 설치 및 설정할 것
	(npm/npx 패키지를 찾을 수 없는 경우) pm 전역 설치 경로 확인 : npm config get prefix
	권장되는 방법을 확인한 후, npm, pip, uvx, pip 등으로 직접 설치할 것

	#### uvx 명령어를 찾을 수 없는 경우
	# uv 설치 (Python 패키지 관리자)
	curl -LsSf https://astral.sh/uv/install.sh | sh

	#### npm/npx 패키지를 찾을 수 없는 경우
	# npm 전역 설치 경로 확인
	npm config get prefix


	#### uvx 명령어를 찾을 수 없는 경우
	# uv 설치 (Python 패키지 관리자)
	curl -LsSf https://astral.sh/uv/install.sh | sh


	## 설치 후 터미널 상에서 작동 여부 점검할 것 ##
	
	## 위 방법으로, 터미널에서 작동 성공한 경우, 성공 시의 인자 및 환경 변수 이름을 활용해서, 클로드 코드의 올바른 위치의 json 설정 파일에 MCP를 직접 설정할 것 ##


	설정 예시
		(설정 파일 위치)
		***리눅스, macOS 또는 윈도우 WSL 기반의 클로드 코드인 경우***
		- **User 설정**: `~/.claude/` 디렉토리
		- **Project 설정**: 프로젝트 루트/.claude

		***윈도우 네이티브 클로드 코드인 경우***
		- **User 설정**: `C:\Users\{사용자명}\.claude` 디렉토리
		- **Project 설정**: 프로젝트 루트\.claude

		1. npx 사용

		{
		  "youtube-mcp": {
		    "type": "stdio",
		    "command": "npx",
		    "args": ["-y", "youtube-data-mcp-server"],
		    "env": {
		      "YOUTUBE_API_KEY": "YOUR_API_KEY_HERE",
		      "YOUTUBE_TRANSCRIPT_LANG": "ko"
		    }
		  }
		}


		2. cmd.exe 래퍼 + 자동 동의)
		{
		  "mcpServers": {
		    "mcp-installer": {
		      "command": "cmd.exe",
		      "args": ["/c", "npx", "-y", "@anaisbetts/mcp-installer"],
		      "type": "stdio"
		    }
		  }
		}

		3. 파워셀예시
		{
		  "command": "powershell.exe",
		  "args": [
		    "-NoLogo", "-NoProfile",
		    "-Command", "npx -y @anaisbetts/mcp-installer"
		  ]
		}

		4. npx 대신 node 지정
		{
		  "command": "node",
		  "args": [
		    "%APPDATA%\\npm\\node_modules\\@anaisbetts\\mcp-installer\\dist\\index.js"
		  ]
		}

		5. args 배열 설계 시 체크리스트
		토큰 단위 분리: "args": ["/c","npx","-y","pkg"] 와
			"args": ["/c","npx -y pkg"] 는 동일해보여도 cmd.exe 내부에서 따옴표 처리 방식이 달라질 수 있음. 분리가 안전.
		경로 포함 시: JSON에서는 \\ 두 번. 예) "C:\\tools\\mcp\\server.js".
		환경변수 전달:
			"env": { "UV_DEPS_CACHE": "%TEMP%\\uvcache" }
		타임아웃 조정: 느린 PC라면 MCP_TIMEOUT 환경변수로 부팅 최대 시간을 늘릴 수 있음 (예: 10000 = 10 초) 

(설치 및 설정한 후는 항상 아래 내용으로 검증할 것)
	claude mcp list 으로 설치 목록에 포함되는지 내용 확인한 후,
	task를 통해 디버그 모드로 서브 에이전트 구동한 후 (claude --debug), 최대 2분 동안 관찰한 후, 그 동안의 디버그 메시지(에러 시 관련 내용이 출력됨)를 확인하고 /mcp 를 통해 실제 작동여부를 반드시 확인할 것


		
** MCP 서버 제거가 필요할 때 예시: **
claude mcp remove youtube-mcp

** firebase mcp 적극 활용할 것 **

** Serena MCP 적극 활용할 것 **
Serena MCP는 강력한 코딩 에이전트 툴킷으로 의미론적 코드 검색 및 편집 기능을 제공합니다.

### Serena MCP 주요 기능:
- **의미론적 코드 분석**: 언어 서버 프로토콜을 통한 IDE 수준의 코드 이해
- **다중 언어 지원**: 다양한 프로그래밍 언어에 대한 지원
- **대형 코드베이스 처리**: 복잡한 코딩 작업에 특화된 성능
- **웹 대시보드**: http://127.0.0.1:24282/dashboard/index.html 에서 로그 및 상태 확인 가능

### Serena MCP 설치 방법:
```bash
# 권장 설치 방법 (IDE 어시스턴트 컨텍스트와 현재 프로젝트 경로 포함)
claude mcp add serena -- uvx --from git+https://github.com/oraios/serena serena-mcp-server --context ide-assistant --project "%cd%"

# 또는 기본 설치
claude mcp add serena -- uvx --from git+https://github.com/oraios/serena serena-mcp-server
```

### Serena MCP 사용 시 주의사항:
1. **uv 패키지 매니저 필요**: Serena는 uv로 관리되므로 사전 설치 필요
2. **초기 연결 시간**: 첫 설치 시 의존성 설치로 인해 30초 정도 소요될 수 있음
3. **프로젝트 컨텍스트**: --context ide-assistant 옵션 사용 권장
4. **웹 대시보드**: 기본적으로 로컬호스트에 대시보드가 시작되어 로그 및 상태 모니터링 가능

### Serena MCP 설정 예시 (수동 설정 시):
```json
{
  "serena": {
    "command": "uvx",
    "args": [
      "--from",
      "git+https://github.com/oraios/serena",
      "serena-mcp-server",
      "--context",
      "ide-assistant",
      "--project",
      "C:\\Users\\yong\\sonaapp"
    ],
    "type": "stdio"
  }
}
```

### 현재 프로젝트 Serena MCP 설정 상태:
- **설치 상태**: ✅ 완료 (정상 연결)
- **프로젝트 경로**: `C:\Users\yong\sonaapp` (절대 경로로 설정됨)
- **웹 대시보드**: http://127.0.0.1:24283/dashboard/index.html
- **사용 가능한 도구**: 27개 (semantic 코드 분석, 심볼 검색, 메모리 관리 등)
- **설정 파일**: User 스코프로 설치되어 Claude 재시작 시 자동 연결

### Serena MCP 자동 연결 확인:
다음 Claude 세션부터는 자동으로 Serena MCP가 연결됩니다:
1. **User 설정에 저장됨**: `C:\Users\yong\.claude\mcp_servers.json`에 설정 저장
2. **자동 시작**: Claude 코드 실행 시 자동으로 Serena MCP 서버 시작
3. **연결 확인**: `/mcp` 명령으로 연결 상태 확인 가능
4. **웹 대시보드**: 브라우저에서 실시간 로그 및 상태 모니터링 가능

** scripts/process_persona_image.py 파일 활용하여 cloudflare mcp를 사용하기 전에 이미지 처리할 것 **

** test 용도로 생성한 파일들은 test가 끝나면 삭제할 것 **

---

## 대화 오류 확인

**명령어**: `대화 오류 확인`

**기능**: 
- Firebase `chat_error_fix` 컬렉션에서 체크되지 않은 오류 보고서를 읽어옴
- **대화 맥락 분석 (최우선)**:
  - 질문-답변 관련성 평가
  - 주제 일관성 점수 (0-100)
  - 대화 흐름 자연스러움 점수 (0-100)
  - 갑작스러운 주제 변경 감지
- 문제 패턴 분석:
  - 인사말 반복
  - 동일 응답 반복 (매크로 패턴)
  - 관련 없는 답변
  - 감정 표현 일관성
- 분석 완료된 문서에 is_check: true 표시

**실행 스크립트**: 
```bash
# 기본 실행 (체크되지 않은 문서만)
python scripts/analyze_chat_errors.py

# 모든 문서 재분석
python scripts/analyze_chat_errors.py --recheck
```

**분석 결과**:
- **콘솔 출력**: 전체 통계, 심각한 문제 요약, 페르소나별 분석
- **JSON 파일 저장**:
  - `analysis_results/summary_YYYYMMDD_HHMMSS.json`: 요약 통계
  - `analysis_results/detailed_YYYYMMDD_HHMMSS.json`: 상세 분석 결과

**심각도 레벨**:
- **CRITICAL**: 대화 완전 이탈, 의미 없는 응답
- **HIGH**: 주제 벗어남, 부자연스러운 응답
- **MEDIUM**: 약간의 맥락 불일치
- **LOW**: 미미한 문제

**주의사항**:
- Firebase Admin SDK 사용을 위해 `firebase-service-account-key.json` 파일 필요
- 맥락 분석은 키워드 추출 및 의미론적 유사도 기반으로 수행됨

---

## 대화 품질 개선 시스템

### 8. 회피성 답변 방지 시스템

**목적**: AI가 사용자 질문을 회피하거나 관련 없는 답변을 하는 것을 방지

**구현 내용**:

#### ChatOrchestrator 개선
1. **회피 패턴 감지** (`_isAvoidancePattern`):
   - 확장된 회피 키워드 목록:
     - 기본: '모르겠', '그런 건', '다른 이야기', '나중에'
     - 추가: '그런 복잡한', '재밌는 얘기', '다른 걸로', '말고', '그만'
     - 특히: '그런거 말고', '복잡해', '어려워', '패스', '스킵'

2. **직접 질문 감지** (`_isDirectQuestion`):
   - 직접적인 답변이 필요한 질문 패턴 인식
   - "뭐해?", "무슨 말이야?", "어디야?" 등
   - 정규식 기반 정확한 패턴 매칭

3. **맥락 가이드 강화** (`_analyzeContextRelevance`):
   ```dart
   // 특정 질문 타입별 가이드
   if (userMessage.contains('뭐하')) {
     contextHints.add('"뭐해?" 질문에는 현재 하고 있는 일이나 상태를 구체적으로 답하세요.');
   }
   ```

#### OptimizedPromptService 개선
1. **핵심 프롬프트 추가**:
   ```
   ## 🎯 직접적인 답변: 질문에는 반드시 직접적으로 답변. 
   "뭐해?"→현재 상황 구체적으로, "무슨말이야?"→이전 발언 설명. 
   회피성 답변 절대 금지
   ```

2. **맥락 주의사항 강화**:
   - "헐 대박 나도 그래?" 같은 관련 없는 답변 금지
   - "그런 복잡한 건 말고 재밌는 얘기 해봐요" 같은 회피성 답변 절대 금지
   - 질문에는 반드시 직접적이고 구체적인 답변
   - 모를 때는 솔직하게 인정하고 대화 이어가기

### 분석 결과 예시
지윤 페르소나의 경우:
- **이전**: "뭐하고 있었어요?" → "헐 대박 나도 그래?"
- **개선 후**: "뭐하고 있었어요?" → "네일아트 디자인 고민하고 있었어요ㅎㅎ"

### 9. 첫 인사 아이스브레이킹 시스템

**목적**: 단순한 "반가워요!"로 끝나는 인사를 개선하여 자연스러운 대화 시작

**구현 내용**:

#### ChatOrchestrator 인사말 개선
MBTI별 인사말에 아이스브레이킹 질문 추가:

1. **ENFP** (활발하고 호기심 많은 타입):
   - "안녕하세요~~ㅎㅎ 오늘 날씨 좋지 않아요?"
   - "하이하이! 뭐하세요? 점심은 드셨어요?"
   - "오 오셨네요!! 반가워요ㅋㅋ 오늘 어떠셨어요?"

2. **INTJ** (차분하고 직설적인 타입):
   - "안녕하세요. 피곤하지 않으세요?"
   - "네, 반갑습니다. 바빠셨어요?"
   - "어서오세요. 잘 지내셨어요?"

3. **ESFP** (밝고 사교적인 타입):
   - "안녕하세요!! ㅎㅎ 오늘 기분 어떠세요?"
   - "오셨어요?? 반가워요! 오늘 재밌는 일 있으셨어요?"
   - "하이~ 오늘 뭐하셨어요? 저는 오늘 진짜 바빴어요ㅎㅎ"

#### OptimizedPromptService 가이드 추가
```
## 👋 첫 인사: 단순 인사말로 끝내지 말고 자연스러운 아이스브레이킹 질문 추가. 
"반가워요!"(X) → "반가워요! 오늘 날씨 좋지 않아요?"(O)
```

**효과**: 사용자가 "반가워요!"에 어떻게 답해야 할지 막막하지 않고, 자연스럽게 대화를 이어갈 수 있음

---

## 페르소나 카드 새로고침 기능

### R2 이미지 필터링 강화

**목적**: 유료 서비스인 새로고침 기능의 안정성 확보

**필터링 로직**:
1. **R2 이미지 유효성 검증** (`_hasR2Image` 메서드):
   - imageUrls가 null이거나 비어있으면 false
   - URL이 실제 R2 도메인인지 확인:
     - `teamsona.work`
     - `r2.dev`
     - `cloudflare`
     - `imagedelivery.net`
   - 지원하는 imageUrls 구조:
     - 기본 구조: `{medium: {jpg: "url"}}`
     - mainImageUrls 구조: `{mainImageUrls: {medium: "url"}}`
     - 최상위 size 키: `{thumb: {jpg: "url"}, small: {jpg: "url"}, ...}`

2. **표시 조건**:
   - 매칭되지 않은 페르소나
   - 유효한 R2 이미지를 가진 페르소나
   - 사용자 프로필 성별 필터링 적용

### 자정 자동 새로고침 기능

**목적**: 매일 자정에 자동으로 스와이프한 페르소나 초기화

**구현 내용**:
1. **자정 타이머 설정** (`_setupMidnightRefreshTimer`):
   - 로컬 시간 기준 다음 자정까지 타이머 설정
   - 자정이 되면 `_performMidnightRefresh` 실행
   - 다음 날 자정을 위한 타이머 재설정

2. **자정 새로고침 수행** (`_performMidnightRefresh`):
   - 오늘 이미 새로고침했는지 확인
   - 세션 스와이프 기록 초기화
   - SharedPreferences의 스와이프 기록 삭제
   - 페르소나 리스트 재셔플

3. **앱 재개 시 확인** (`checkAndPerformDailyRefresh`):
   - 앱이 백그라운드에서 다시 활성화될 때 호출
   - 마지막 새로고침 날짜와 오늘 날짜 비교
   - 날짜가 다르면 자동 새로고침 수행

4. **PersonaSelectionScreen 통합**:
   - `WidgetsBindingObserver` 추가로 앱 lifecycle 감지
   - `initState`에서 초기 확인
   - `didChangeAppLifecycleState`에서 앱 재개 시 확인

**로그 출력**:
```
⏰ Setting up midnight refresh timer
   Current time: 2025-01-28 15:30:00
   Next midnight: 2025-01-29 00:00:00
   Time until midnight: 8h 30m

🌙 Midnight refresh triggered at 2025-01-29 00:00:00
✅ Midnight refresh complete - all unmatched personas are now available

📅 Daily refresh needed - last refresh: 2025-01-27
🔄 App resumed - checking for daily refresh
```

**주의사항**:
- 매칭된 페르소나는 새로고침 후에도 계속 숨겨짐
- 로컬 시간 기준으로 작동
- 앱이 종료되면 타이머도 취소됨