# 🌍 i18n 하드코딩 텍스트 감사 보고서

## 📋 개요
SONA 앱의 모든 하드코딩된 UI 텍스트를 식별하고 다국어 지원(i18n)을 위해 AppLocalizations로 전환이 필요한 항목들을 정리했습니다.

## 🔴 긴급 수정 필요 (하드코딩된 한글 텍스트)

### 1. **screens/error_dashboard_screen.dart**
- Line 338: `'에러 리포트가 없습니다.'`

### 2. **screens/admin_quality_dashboard_screen.dart**
- Line 289: `'최근 1시간 동안 품질 문제가 없습니다 ✅'`
- Line 362: `'데이터를 로딩 중입니다...'`
- Line 485: `'아직 품질 로그가 없습니다.'`

### 3. **screens/persona_selection_screen.dart**
- Line 1011, 1034: `'${persona.name}님과는 이미 대화중이에요!'`
- Line 1263, 1340: `'하트가 부족합니다.'`
- Line 1291, 1368: `'매칭에 실패했습니다.'`
- Line 1300, 1376: `'오류가 발생했습니다.'`

### 4. **screens/settings_screen.dart**
- Line 683: `'캐시 삭제 중 오류가 발생했습니다: $e'`

### 5. **screens/settings/blocked_personas_screen.dart**
- Line 83: `'${persona.personaName}의 차단을 해제하시겠습니까?'`
- Line 137: `'차단 해제에 실패했습니다'`
- Line 151: `'오류가 발생했습니다: $e'`

### 6. **utils/network_utils.dart**
- Line 34: `'인터넷 연결을 확인해주세요'`

### 7. **widgets/persona/optimized_persona_image.dart**
- Line 253: `'이미지가 없습니다'`

## 🟡 이모지만 있는 텍스트 (선택적 수정)

### 1. **screens/persona_selection_screen.dart**
- Line 1396: `'💖×5 '`
- Line 1400: `'💖×1 '`

### 2. **widgets/persona/persona_card.dart**
- Line 808: `'💕'`
- Line 818: `'💫'`

## ✅ 이미 국제화된 파일들
- **l10n/app_localizations.dart**: 현재 기본적인 번역이 구현되어 있음
- 대부분의 screens 파일들은 `AppLocalizations.of(context)!`를 사용 중

## 📝 수정 필요 항목 요약

### 필수 수정 (한글 하드코딩)
- **14개** 하드코딩된 한글 메시지
- **7개** 파일 수정 필요

### 선택적 수정 (이모지/기호)
- **4개** 이모지 텍스트
- **2개** 파일

## 🛠️ 수정 방법

### 1. AppLocalizations에 추가할 메서드들:

```dart
// app_localizations.dart에 추가

// Error Dashboard
String get noErrorReports => isKorean ? '에러 리포트가 없습니다.' : 'No error reports.';

// Admin Quality Dashboard  
String get noQualityIssues => isKorean ? '최근 1시간 동안 품질 문제가 없습니다 ✅' : 'No quality issues in the last hour ✅';
String get loadingData => isKorean ? '데이터를 로딩 중입니다...' : 'Loading data...';
String get noQualityLogs => isKorean ? '아직 품질 로그가 없습니다.' : 'No quality logs yet.';

// Persona Selection
String alreadyChattingWith(String name) => isKorean ? '$name님과는 이미 대화중이에요!' : 'Already chatting with $name!';
String get insufficientHearts => isKorean ? '하트가 부족합니다.' : 'Insufficient hearts.';
String get matchingFailed => isKorean ? '매칭에 실패했습니다.' : 'Matching failed.';
String get errorOccurred => isKorean ? '오류가 발생했습니다.' : 'An error occurred.';

// Settings
String cacheDeleteError(String error) => isKorean ? '캐시 삭제 중 오류가 발생했습니다: $error' : 'Error deleting cache: $error';

// Blocked Personas
String unblockPersonaConfirm(String name) => isKorean ? '$name의 차단을 해제하시겠습니까?' : 'Unblock $name?';
String get unblockFailed => isKorean ? '차단 해제에 실패했습니다' : 'Failed to unblock';
String errorWithMessage(String error) => isKorean ? '오류가 발생했습니다: $error' : 'Error occurred: $error';

// Network
String get checkInternetConnection => isKorean ? '인터넷 연결을 확인해주세요' : 'Please check your internet connection';

// Image
String get noImage => isKorean ? '이미지가 없습니다' : 'No image available';

// Hearts (optional)
String get fiveHearts => '💖×5';
String get oneHeart => '💖×1';
```

### 2. 각 파일에서 수정 예시:

```dart
// Before
Text('에러 리포트가 없습니다.')

// After  
Text(AppLocalizations.of(context)!.noErrorReports)
```

## 🎯 다음 단계

1. **AppLocalizations 클래스 업데이트**: 위의 모든 메서드 추가
2. **각 파일 수정**: 하드코딩된 텍스트를 AppLocalizations 호출로 변경
3. **테스트**: 한글/영어 모두 테스트
4. **검증**: 모든 UI 텍스트가 언어 설정에 따라 변경되는지 확인

## 📊 진행 상태
- [x] 하드코딩 텍스트 스캔 완료
- [ ] AppLocalizations 메서드 추가
- [ ] 각 파일 수정
- [ ] 테스트 및 검증

## 🔍 추가 확인 사항
- Date/Time 포맷팅
- 숫자 포맷팅  
- 통화 표시
- 복수형 처리 (필요한 경우)

---

**작성일**: 2025-01-30
**총 하드코딩 항목**: 18개 (필수 14개 + 선택 4개)
**영향 받는 파일**: 9개