# 🗺️ SONA 앱 언어별 구현 로드맵

## 📊 현재 상태
- ✅ **한국어 (ko-KR)**: 100% 완료
- ✅ **영어 (en-US)**: 100% 완료
- ⏳ **일본어 (ja-JP)**: 0% (계획 중)
- ⏳ **중국어 간체 (zh-CN)**: 0% (계획 중)
- ⏳ **스페인어 (es-ES)**: 0% (계획 중)

---

## 🇯🇵 일본어 구현 계획

### Phase 1: 기본 설정 (1주차)
- [ ] `app_ja.arb` 파일 생성
- [ ] 핵심 UI 문자열 번역 (100개)
  - [ ] 공통 버튼/라벨
  - [ ] 네비게이션 메뉴
  - [ ] 에러 메시지
- [ ] 날짜/시간 포맷 설정
  ```dart
  // 일본어 날짜 형식
  DateFormat('yyyy年MM月dd日', 'ja')
  ```

### Phase 2: 주요 화면 (2주차)
- [ ] 온보딩/로그인 화면
- [ ] 홈 화면
- [ ] 채팅 화면
- [ ] 프로필 화면
- [ ] 설정 화면

### Phase 3: 문화적 요소 (3주차)
- [ ] 경어 레벨 적용 (입니다/입니다체)
- [ ] 이모지 문화 차이 반영
- [ ] 일본 특화 기능 추가
  - [ ] 라인 연동
  - [ ] 일본 결제 시스템

### 특별 고려사항
```dart
// 일본어 특수 처리
class JapaneseHelper {
  // 히라가나/가타카나 변환
  static String toHiragana(String text) { /*...*/ }
  
  // 경어 레벨
  static String applyPoliteness(String text, PolitenessLevel level) {
    switch(level) {
      case PolitenessLevel.casual: return text;
      case PolitenessLevel.polite: return '$textです';
      case PolitenessLevel.formal: return '$textでございます';
    }
  }
}
```

---

## 🇨🇳 중국어 간체 구현 계획

### Phase 1: 기본 설정 (1주차)
- [ ] `app_zh.arb` 파일 생성
- [ ] 간체/번체 선택 옵션
- [ ] 핵심 UI 문자열 번역
- [ ] 중국식 날짜 포맷

### Phase 2: 주요 화면 (2주차)
- [ ] 모든 주요 화면 번역
- [ ] 중국 특화 용어 적용
- [ ] 숫자 표기법 (万, 亿)

### Phase 3: 현지화 (3주차)
- [ ] WeChat 연동
- [ ] Alipay/WeChat Pay 결제
- [ ] 중국 서버 리전 설정

### 특별 고려사항
```dart
// 중국어 숫자 포맷
String formatChineseNumber(int number) {
  if (number >= 100000000) {
    return '${(number / 100000000).toStringAsFixed(1)}亿';
  } else if (number >= 10000) {
    return '${(number / 10000).toStringAsFixed(1)}万';
  }
  return number.toString();
}
```

---

## 🇪🇸 스페인어 구현 계획

### Phase 1: 기본 설정 (1주차)
- [ ] `app_es.arb` 파일 생성
- [ ] 지역별 변형 고려 (ES/MX/AR)
- [ ] 성별에 따른 형용사 변화

### Phase 2: 주요 화면 (2주차)
- [ ] 모든 화면 번역
- [ ] 라틴 문화 요소 반영
- [ ] 날짜/시간 형식

### Phase 3: 현지화 (3주차)
- [ ] WhatsApp 연동
- [ ] 현지 결제 방식
- [ ] 지역별 슬랭/표현

---

## 🛠️ 구현 자동화 도구

### 1. ARB 파일 생성기
```python
# scripts/create_new_language.py
import json
import sys

def create_arb_file(lang_code):
    # 영어 파일을 템플릿으로 사용
    with open('lib/l10n/app_en.arb', 'r', encoding='utf-8') as f:
        template = json.load(f)
    
    # locale 변경
    template['@@locale'] = lang_code
    
    # 새 파일 생성
    with open(f'lib/l10n/app_{lang_code}.arb', 'w', encoding='utf-8') as f:
        json.dump(template, f, ensure_ascii=False, indent=2)
    
    print(f"Created app_{lang_code}.arb")

if __name__ == "__main__":
    create_arb_file(sys.argv[1])
```

### 2. 번역 진행률 체커
```python
# scripts/check_translation_progress.py
import json
import glob

def check_progress():
    files = glob.glob('lib/l10n/app_*.arb')
    
    for file in files:
        with open(file, 'r', encoding='utf-8') as f:
            data = json.load(f)
        
        total = len([k for k in data.keys() if not k.startswith('@')])
        translated = len([v for k, v in data.items() 
                         if not k.startswith('@') and v and v != ''])
        
        percent = (translated / total) * 100 if total > 0 else 0
        lang = file.split('_')[-1].replace('.arb', '')
        
        print(f"{lang}: {percent:.1f}% ({translated}/{total})")

if __name__ == "__main__":
    check_progress()
```

### 3. 번역 검증기
```python
# scripts/validate_translations.py
def validate_placeholders(ko_text, other_text):
    """플레이스홀더 일치 확인"""
    import re
    ko_placeholders = re.findall(r'\{(\w+)\}', ko_text)
    other_placeholders = re.findall(r'\{(\w+)\}', other_text)
    
    return set(ko_placeholders) == set(other_placeholders)
```

---

## 📈 품질 관리

### 번역 품질 체크리스트
- [ ] 문법적 정확성
- [ ] 문화적 적절성
- [ ] 일관된 용어 사용
- [ ] 플레이스홀더 일치
- [ ] 문자 길이 (UI 깨짐 방지)

### A/B 테스트 계획
```dart
// 언어별 A/B 테스트
class LanguageABTest {
  static String getVariant(String key, String locale) {
    if (locale == 'ja' && key == 'welcomeMessage') {
      // 50% 확률로 다른 표현 테스트
      return Random().nextBool() 
        ? 'いらっしゃいませ' 
        : 'ようこそ';
    }
    return null;
  }
}
```

---

## 📅 전체 일정

### 2025년 1분기
- **1월**: 일본어 기본 구현
- **2월**: 일본어 테스트 및 수정
- **3월**: 일본 시장 출시

### 2025년 2분기
- **4월**: 중국어 기본 구현
- **5월**: 중국어 테스트 및 수정
- **6월**: 중국 시장 출시

### 2025년 3분기
- **7월**: 스페인어 구현
- **8월**: 기타 유럽 언어 검토
- **9월**: 글로벌 출시

---

## 🎯 KPI 및 목표

### 언어별 목표 사용자
- 일본어: 10만 명 (2025 Q2)
- 중국어: 50만 명 (2025 Q3)
- 스페인어: 5만 명 (2025 Q4)

### 성공 지표
- 번역 완성도: 95% 이상
- 사용자 만족도: 4.5/5 이상
- 언어 관련 버그: 월 10건 이하

---

## 🔗 관련 문서
- [I18N_IMPLEMENTATION_GUIDE.md](./I18N_IMPLEMENTATION_GUIDE.md) - 구현 가이드
- [i18n_refactoring_summary.md](./i18n_refactoring_summary.md) - 리팩토링 내역
- [i18n_hardcoded_text_audit.md](./i18n_hardcoded_text_audit.md) - 하드코딩 감사

---

## 💬 FAQ

### Q: 새 언어를 추가하는데 얼마나 걸리나요?
A: 기본 구현 1주, 전체 번역 2주, 테스트 1주 = 총 4주

### Q: 번역은 누가 하나요?
A: 전문 번역가 + 네이티브 검수자 + 내부 QA

### Q: RTL 언어 (아랍어 등)는 지원하나요?
A: 2025년 4분기 검토 예정

---

**작성일**: 2025-01-10
**다음 리뷰**: 2025-02-01