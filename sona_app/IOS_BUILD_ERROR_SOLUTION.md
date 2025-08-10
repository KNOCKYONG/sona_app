# iOS 빌드 오류 해결 가이드

## 발생한 오류들과 원인

### 1. AppIcon 경고
**오류**: "The app icon set 'AppIcon' has 6 unassigned children"
**원인**: Xcode가 AppIcon.appiconset에서 일부 아이콘 크기를 찾지 못함

### 2. permission_handler_apple 헤더 파일 누락
**오류**: "No such file or directory" for permission_handler_apple headers
**원인**: pub 캐시가 손상되었거나 불완전한 설치

### 3. Pods Run Script 경고
**오류**: "Run script build phase 'Create Symlinks to Header Folders' will be run during every build"
**원인**: CocoaPods의 일반적인 경고로 실제 빌드에는 영향 없음

## Step-by-Step 해결 방법

### 1단계: Flutter 환경 정리
```bash
# Flutter 캐시 정리
flutter clean

# pub 캐시 정리
flutter pub cache repair

# 의존성 재설치
flutter pub get
```

### 2단계: iOS 관련 파일 정리
```bash
# iOS 디렉토리로 이동
cd ios

# Pods 및 관련 파일 삭제
rm -rf Pods
rm -rf Podfile.lock
rm -rf .symlinks
rm -rf Flutter/Flutter.framework
rm -rf Flutter/Flutter.podspec

# DerivedData 삭제 (Xcode 캐시)
rm -rf ~/Library/Developer/Xcode/DerivedData
```

### 3단계: Pod 재설치
```bash
# iOS 디렉토리에서
pod deintegrate
pod cache clean --all
pod install --repo-update
```

### 4단계: permission_handler 문제 해결
```bash
# 특정 패키지 캐시 삭제
rm -rf ~/.pub-cache/hosted/pub.dev/permission_handler*

# Flutter 프로젝트 루트에서
flutter pub get
```

### 5단계: Xcode에서 직접 수정

#### AppIcon 경고 해결:
1. Xcode에서 `Runner.xcworkspace` 열기
2. Runner > Assets.xcassets > AppIcon 선택
3. 누락된 아이콘 크기 확인 및 추가
4. 또는 `flutter pub run flutter_launcher_icons` 실행

#### Run Script 경고 해결 (선택사항):
1. Pods 프로젝트 선택
2. Build Phases 탭
3. "Create Symlinks to Header Folders" 스크립트 찾기
4. "Based on dependency analysis" 체크 해제

## 예방 방법

### 1. 정기적인 캐시 정리
```bash
# 주기적으로 실행
flutter clean
flutter pub cache repair
```

### 2. iOS 빌드 전 체크리스트
- [ ] Flutter 버전 확인: `flutter doctor`
- [ ] CocoaPods 업데이트: `sudo gem install cocoapods`
- [ ] Xcode 업데이트 확인
- [ ] iOS Deployment Target 확인 (현재: iOS 13.0)

### 3. 빌드 스크립트 사용
```bash
#!/bin/bash
# build_ios_clean.sh

echo "🧹 Cleaning Flutter project..."
flutter clean

echo "📦 Getting dependencies..."
flutter pub get

echo "🍎 Cleaning iOS build..."
cd ios
rm -rf Pods Podfile.lock
pod install --repo-update
cd ..

echo "🏗️ Building iOS..."
flutter build ios --release

echo "✅ Build complete!"
```

## 문제가 지속될 경우

1. **Flutter 재설치**
   ```bash
   flutter channel stable
   flutter upgrade --force
   ```

2. **Xcode 설정 초기화**
   - Xcode > Preferences > Locations > Derived Data > Delete
   - Xcode 재시작

3. **프로젝트 재생성** (최후의 수단)
   - 새 Flutter 프로젝트 생성
   - 소스 코드와 assets만 복사
   - 의존성 재설치

## 추가 팁

- iOS 빌드는 macOS에서만 가능
- Xcode 최신 버전 유지 권장
- CocoaPods 1.12.0 이상 사용 권장
- Flutter와 Dart SDK 버전 호환성 확인

## 관련 명령어 모음
```bash
# Flutter 상태 확인
flutter doctor -v

# iOS 시뮬레이터 목록
xcrun simctl list devices

# 특정 시뮬레이터에서 실행
flutter run -d "iPhone 15 Pro"

# 릴리즈 빌드
flutter build ios --release

# 번들 ID 확인
grep PRODUCT_BUNDLE_IDENTIFIER ios/Runner.xcodeproj/project.pbxproj
```