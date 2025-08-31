# 📌 SONA 앱 다국어(i18n) 구현 가이드

## 🎯 목적
SONA 앱의 다국어 지원을 체계적으로 구현하고 관리하기 위한 완벽한 가이드

---

## 📂 현재 구조

### ARB 파일 위치
```
sona_app/lib/l10n/
├── app_ko.arb    # 한국어 번역 (507개 문자열 + 26개 파라미터)
├── app_en.arb    # 영어 번역 (507개 문자열 + 26개 파라미터)
└── app_localizations.dart  # 로컬라이제이션 클래스
```

### 핵심 클래스
- **AppLocalizations**: ARB 파일에서 번역 로드
- **LocaleService**: 언어 설정 관리 (Provider 패턴)
- **LocalizationsDelegate**: Flutter 로컬라이제이션 위임

---

## 🔧 개발자 가이드

### 1️⃣ 새로운 텍스트 추가하기

#### 단순 문자열
```dart
// 1. ARB 파일에 추가
// app_ko.arb
{
  "newFeature": "새로운 기능",
  "@newFeature": {
    "description": "New feature button label"
  }
}

// app_en.arb
{
  "newFeature": "New Feature",
  "@newFeature": {
    "description": "New feature button label"
  }
}

// 2. AppLocalizations에 getter 추가
String get newFeature => getString('newFeature');

// 3. UI에서 사용
Text(AppLocalizations.of(context)!.newFeature)
```

#### 파라미터가 있는 문자열
```dart
// 1. ARB 파일에 플레이스홀더와 함께 추가
// app_ko.arb
{
  "welcomeUser": "{name}님, 환영합니다!",
  "@welcomeUser": {
    "description": "Welcome message with user name",
    "placeholders": {
      "name": {"type": "String"}
    }
  }
}

// app_en.arb
{
  "welcomeUser": "Welcome, {name}!",
  "@welcomeUser": {
    "description": "Welcome message with user name",
    "placeholders": {
      "name": {"type": "String"}
    }
  }
}

// 2. AppLocalizations에 메서드 추가
String welcomeUser(String name) => 
    _formatString('welcomeUser', {'name': name});

// 3. UI에서 사용
Text(localizations.welcomeUser(user.nickname))
```

### 2️⃣ 언어별 조건 처리

#### ❌ 잘못된 방법 (더 이상 사용하지 마세요)
```dart
// isKorean은 deprecated입니다!
if (localizations.isKorean) {
  // 한국어 처리
}
```

#### ✅ 올바른 방법
```dart
final locale = AppLocalizations.of(context)!.locale;
if (locale.languageCode == 'ko') {
  // 한국어 처리
} else if (locale.languageCode == 'en') {
  // 영어 처리
}
```

### 3️⃣ 날짜/시간 포맷팅
```dart
String formatDate(DateTime date) {
  final locale = AppLocalizations.of(context)!.locale;
  
  if (locale.languageCode == 'ko') {
    return DateFormat('yyyy년 MM월 dd일').format(date);
  } else {
    return DateFormat('MMM dd, yyyy').format(date);
  }
}
```

### 4️⃣ 숫자/통화 포맷팅
```dart
String formatCurrency(int amount) {
  final locale = AppLocalizations.of(context)!.locale;
  
  if (locale.languageCode == 'ko') {
    final formatter = NumberFormat.currency(
      locale: 'ko_KR',
      symbol: '₩',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  } else {
    final formatter = NumberFormat.currency(
      locale: 'en_US',
      symbol: '\$',
      decimalDigits: 2,
    );
    return formatter.format(amount / 1300); // 환율 적용
  }
}
```

---

## 🌍 새로운 언어 추가하기

### 1단계: ARB 파일 생성
```bash
# 예: 일본어 추가
cp lib/l10n/app_en.arb lib/l10n/app_ja.arb
```

### 2단계: ARB 파일 번역
```json
// app_ja.arb
{
  "@@locale": "ja",
  "appName": "SONA",
  "loading": "読み込み中...",
  "error": "エラー",
  // ... 모든 키 번역
}
```

### 3단계: AppLocalizations 수정
```dart
// supportedLocales에 추가
static const List<Locale> supportedLocales = [
  Locale('en', 'US'),
  Locale('ko', 'KR'),
  Locale('ja', 'JP'), // 새로 추가
];

// LocalizationsDelegate에서 지원
@override
bool isSupported(Locale locale) {
  return ['en', 'ko', 'ja'].contains(locale.languageCode);
}
```

### 4단계: 언어 선택 UI 업데이트
`language_settings_screen.dart`에 새 언어 버튼 추가

---

## 📋 체크리스트

### 텍스트 추가 시
- [ ] app_ko.arb에 한국어 추가
- [ ] app_en.arb에 영어 추가
- [ ] @metadata 설명 추가
- [ ] AppLocalizations에 getter/메서드 추가
- [ ] UI 코드에서 하드코딩 대신 localizations 사용

### 새 화면 개발 시
- [ ] 모든 UI 텍스트를 AppLocalizations 사용
- [ ] 날짜/시간 포맷 로케일 대응
- [ ] 숫자/통화 포맷 로케일 대응
- [ ] 이미지/아이콘의 문화적 적절성 검토

### 코드 리뷰 시
- [ ] 하드코딩된 텍스트 없는지 확인
- [ ] isKorean 사용하지 않는지 확인
- [ ] 모든 사용자 대면 텍스트가 번역되었는지 확인

---

## 🚫 피해야 할 패턴

### 1. 하드코딩된 텍스트
```dart
// ❌ 잘못된 예
Text('안녕하세요')
showDialog(title: 'Error')

// ✅ 올바른 예
Text(localizations.hello)
showDialog(title: localizations.error)
```

### 2. 조건부 텍스트
```dart
// ❌ 잘못된 예
Text(isKorean ? '설정' : 'Settings')

// ✅ 올바른 예
Text(localizations.settings)
```

### 3. 연결된 문자열
```dart
// ❌ 잘못된 예
Text('${user.name}님 안녕하세요')

// ✅ 올바른 예 (파라미터 사용)
Text(localizations.greetingWithName(user.name))
```

---

## 🛠️ 유용한 스크립트

### ARB 파일 검증
```python
# scripts/validate_arb.py
import json

def validate_arb_consistency():
    with open('lib/l10n/app_ko.arb') as f:
        ko = json.load(f)
    with open('lib/l10n/app_en.arb') as f:
        en = json.load(f)
    
    ko_keys = set(k for k in ko.keys() if not k.startswith('@'))
    en_keys = set(k for k in en.keys() if not k.startswith('@'))
    
    missing_in_en = ko_keys - en_keys
    missing_in_ko = en_keys - ko_keys
    
    if missing_in_en:
        print(f"영어에 없는 키: {missing_in_en}")
    if missing_in_ko:
        print(f"한국어에 없는 키: {missing_in_ko}")
```

### 하드코딩 검색
```bash
# 하드코딩된 한글 찾기
grep -r '"[가-힣]' lib/ --include="*.dart" | grep -v "app_localizations"

# 하드코딩된 영어 UI 텍스트 찾기 (주의: 주석 제외 필요)
grep -r "Text('[A-Z]" lib/ --include="*.dart"
```

---

## 📊 현재 진행 상황

### 완료된 작업 ✅
- [x] ARB 파일 생성 (한국어, 영어)
- [x] AppLocalizations 리팩토링
- [x] isKorean 로직 제거
- [x] 507개 단순 문자열 마이그레이션
- [x] 26개 파라미터 메서드 구현
- [x] UI 파일 업데이트 (5개 화면)

### 추가 필요 작업 📝
- [ ] 일본어 지원 추가
- [ ] 중국어 지원 추가
- [ ] RTL 언어 지원 (아랍어 등)
- [ ] 번역 품질 검증
- [ ] 자동화 테스트 추가

---

## 🔍 문제 해결

### ARB 파일이 로드되지 않을 때
1. `flutter clean` 실행
2. `flutter pub get` 실행
3. ARB 파일 인코딩이 UTF-8인지 확인
4. JSON 문법 오류 확인

### 번역이 표시되지 않을 때
1. AppLocalizations에 getter/메서드 추가했는지 확인
2. BuildContext가 올바른지 확인
3. LocaleService Provider가 상위에 있는지 확인

### 언어 변경이 반영되지 않을 때
1. LocaleService.setLocale() 호출 확인
2. MaterialApp의 locale 속성 바인딩 확인
3. 위젯 리빌드 트리거 확인

---

## 📚 참고 자료

- [Flutter 공식 i18n 가이드](https://docs.flutter.dev/development/accessibility-and-localization/internationalization)
- [ARB 파일 형식 명세](https://github.com/google/app-resource-bundle)
- [Intl 패키지 문서](https://pub.dev/packages/intl)

---

## 💡 프로 팁

1. **번역 키 네이밍**: 의미를 명확히 하는 키 사용
   - ❌ `btn1`, `msg2`
   - ✅ `loginButton`, `welcomeMessage`

2. **컨텍스트 제공**: @metadata에 충분한 설명 추가
   ```json
   "@loginButton": {
     "description": "Button to submit login form on login screen"
   }
   ```

3. **플레이스홀더 타입 명시**: 타입 안전성 향상
   ```json
   "placeholders": {
     "count": {"type": "int"},
     "name": {"type": "String"}
   }
   ```

4. **언어별 복수형 처리**: Intl.plural 사용
   ```dart
   String itemCount(int count) => Intl.plural(
     count,
     zero: '아이템 없음',
     one: '아이템 1개',
     other: '아이템 $count개',
     locale: locale.toString(),
   );
   ```

---

## 📞 지원 및 문의

다국어 구현 관련 질문이나 이슈가 있으시면:
1. 이 문서를 먼저 확인
2. `scripts/validate_arb.py` 실행하여 일관성 체크
3. 팀 리더에게 문의

---

**마지막 업데이트**: 2025-01-10
**다음 업데이트 예정**: 새 언어 추가 시