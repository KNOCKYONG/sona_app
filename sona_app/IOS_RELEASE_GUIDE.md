# 📱 SONA iOS 출시 가이드

## ✅ 완료된 iOS 설정

### 1. **Bundle Identifier 통일**
- ✅ `com.sona.app`으로 Android와 통일
- ✅ Info.plist 및 project.pbxproj 수정 완료

### 2. **iOS 최소 버전**
- ✅ iOS 13.0으로 설정 (Firebase 최신 버전 요구사항 충족)
- ✅ Podfile 및 project.pbxproj에 반영

### 3. **Firebase 설정**
- ✅ Podfile 생성 완료
- ✅ GoogleService-Info.plist 템플릿 생성
- ⚠️ **중요**: Firebase Console에서 실제 iOS 앱 설정 후 GoogleService-Info.plist 교체 필요

### 4. **화면 방향 설정**
- ✅ Portrait 전용으로 설정
- ✅ iPad는 Portrait + UpsideDown 지원

### 5. **권한 설명**
- ✅ 카메라 사용 권한
- ✅ 사진 라이브러리 접근 권한
- ✅ 알림 권한
- ✅ 모든 권한 설명 한국어로 작성

## 🚀 iOS 출시를 위한 남은 작업

### 1. **Firebase 실제 설정**
```bash
# Firebase Console에서:
1. https://console.firebase.google.com 접속
2. 프로젝트 선택
3. iOS 앱 추가 (Bundle ID: com.sona.app)
4. GoogleService-Info.plist 다운로드
5. ios/Runner/GoogleService-Info.plist 교체
```

### 2. **Apple Developer 설정**
```bash
# Apple Developer 계정 필요:
1. https://developer.apple.com 가입
2. App Store Connect에서 앱 생성
3. Bundle ID: com.sona.app 등록
```

### 3. **Xcode 설정**
```bash
# Xcode에서 설정:
1. ios/Runner.xcworkspace 열기
2. Runner 타겟 선택
3. Signing & Capabilities 탭
4. Team 선택 (Apple Developer 계정)
5. Automatically manage signing 체크
```

### 4. **빌드 및 테스트**
```bash
# 빌드 스크립트 실행
cd sona_app
./build_ios.sh

# 또는 수동으로:
flutter clean
flutter pub get
cd ios
pod install
cd ..
flutter build ios --release
```

### 5. **App Store Connect 제출**

#### **필요한 스크린샷**
- iPhone 6.7" (1290 × 2796 px)
- iPhone 6.5" (1284 × 2778 px 또는 1242 × 2688 px)
- iPhone 5.5" (1242 × 2208 px)
- iPad Pro 12.9" (2048 × 2732 px) - 선택사항

#### **앱 정보**
```
앱 이름: SONA
부제: AI 페르소나와의 특별한 대화
카테고리: 소셜 네트워킹
연령 등급: 4+
```

#### **앱 설명 (한국어)**
```
SONA는 AI 페르소나와 감정적 교류를 나누는 혁신적인 대화 매칭 앱입니다.

주요 기능:
• 다양한 AI 페르소나와의 자연스러운 대화
• 개인 맞춤형 매칭 시스템
• 감정 기반 대화 분석
• 안전한 프라이버시 보호

SONA와 함께 새로운 형태의 소통을 경험해보세요.
```

#### **앱 설명 (영어)**
```
SONA is an innovative conversation matching app for emotional exchanges with AI personas.

Key Features:
• Natural conversations with diverse AI personas
• Personalized matching system
• Emotion-based conversation analysis
• Secure privacy protection

Experience a new form of communication with SONA.
```

### 6. **테스트 체크리스트**

#### **기능 테스트**
- [ ] Google 로그인
- [ ] 페르소나 매칭
- [ ] 채팅 기능
- [ ] 이미지 업로드
- [ ] 알림 기능
- [ ] 다국어 지원 (한국어/영어)

#### **디바이스 테스트**
- [ ] iPhone 15 Pro
- [ ] iPhone 14
- [ ] iPhone 13 mini
- [ ] iPhone SE
- [ ] iPad (선택사항)

#### **iOS 버전 테스트**
- [ ] iOS 17.x
- [ ] iOS 16.x
- [ ] iOS 15.x
- [ ] iOS 13.x (최소 지원)

## 📋 제출 전 최종 체크리스트

### **필수 확인 사항**
- [ ] GoogleService-Info.plist 실제 파일로 교체
- [ ] Bundle ID 확인 (com.sona.app)
- [ ] 버전 번호 확인 (pubspec.yaml)
- [ ] 팀 및 코드 서명 설정
- [ ] 아카이브 생성 및 유효성 검사
- [ ] 스크린샷 준비 (모든 크기)
- [ ] 앱 설명 준비 (한국어/영어)
- [ ] 개인정보 처리방침 URL
- [ ] 지원 URL

### **App Store 심사 대비**
- [ ] 테스트 계정 준비
- [ ] 심사 노트 작성
- [ ] 연락처 정보 입력
- [ ] IDFA 사용 여부 확인 (미사용)

## 🔧 문제 해결

### **CocoaPods 관련 문제**
```bash
# Pod 캐시 정리
cd ios
pod cache clean --all
pod deintegrate
pod install
```

### **빌드 실패 시**
```bash
# Flutter 캐시 정리
flutter clean
flutter pub get
rm -rf ios/Pods
rm ios/Podfile.lock
cd ios && pod install
```

### **코드 서명 문제**
1. Xcode에서 Automatically manage signing 해제
2. 수동으로 Provisioning Profile 선택
3. 다시 Automatically manage signing 활성화

## 📞 지원

문제 발생 시:
- Flutter 이슈: https://github.com/flutter/flutter/issues
- Firebase 이슈: https://firebase.google.com/support
- Apple Developer 지원: https://developer.apple.com/support

---

**마지막 업데이트**: 2025년 1월 27일
**상태**: iOS 출시 준비 완료 (Firebase 실제 설정 필요)