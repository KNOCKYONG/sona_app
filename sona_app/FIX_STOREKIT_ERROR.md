# StoreKit Configuration 오류 해결 가이드

## 문제 원인
TestFlight에서 StoreKit Configuration 파일을 찾고 있는데, 이 파일은 **개발/테스트 전용**입니다.
프로덕션(TestFlight/App Store)에서는 실제 App Store Connect 설정을 사용해야 합니다.

## 해결 방법

### 방법 1: Xcode에서 StoreKit Configuration 비활성화 (권장)

1. **Xcode 열기**
   ```bash
   open ios/Runner.xcworkspace
   ```

2. **Scheme 설정 변경**
   - 상단 툴바에서 Scheme 선택 (Runner 옆 드롭다운)
   - Edit Scheme... 선택
   - Run 탭 > Options
   - **StoreKit Configuration**: `None` 선택
   - Archive 탭 > Options  
   - **StoreKit Configuration**: `None` 선택

3. **프로젝트 설정 확인**
   - Runner 타겟 선택
   - Signing & Capabilities 탭
   - In-App Purchase capability가 추가되어 있는지 확인
   - 없다면 + Capability > In-App Purchase 추가

### 방법 2: StoreKit Configuration 파일 제거

```bash
# StoreKit 테스트 파일 제거
rm ios/Runner/StoreKitTestConfiguration.storekit
```

### 방법 3: 조건부 설정 (고급)

Purchase Service에서 환경별 처리:

```dart
// lib/services/purchase/purchase_service.dart
Future<void> initializePurchases() async {
  // TestFlight/Production에서는 실제 상품 ID 사용
  final bool isTestFlight = await _isTestFlightBuild();
  
  if (isTestFlight || kReleaseMode) {
    // 프로덕션 환경 - 실제 App Store Connect 상품 사용
    await InAppPurchase.instance.isAvailable();
  } else {
    // 개발 환경 - StoreKit Configuration 사용 가능
  }
}
```

## App Store Connect 설정 확인

1. **App Store Connect 접속**
   - https://appstoreconnect.apple.com
   - My Apps > SONA 선택

2. **In-App Purchase 상품 확인**
   - Features > In-App Purchases
   - 다음 상품들이 등록되어 있어야 함:
     - `com.nohbrother.teamsona.chatapp.hearts_10`
     - `com.nohbrother.teamsona.chatapp.hearts_30`
     - `com.nohbrother.teamsona.chatapp.hearts_50`

3. **상품 상태 확인**
   - 각 상품이 "Ready to Submit" 또는 "Approved" 상태여야 함
   - "Missing Metadata"인 경우 필수 정보 입력

## 테스트 방법

### TestFlight에서 테스트
1. TestFlight 빌드 업로드
2. 테스터 추가 (Sandbox 계정)
3. 앱 설치 후 구매 테스트
4. **중요**: TestFlight에서는 실제 결제되지 않음

### Sandbox 테스트 계정
1. App Store Connect > Users and Access
2. Sandbox > Testers
3. 테스트 계정 생성
4. 디바이스 설정 > App Store > Sandbox Account 로그인

## 체크리스트

- [ ] Xcode Scheme에서 StoreKit Configuration 제거
- [ ] In-App Purchase capability 추가
- [ ] App Store Connect에 상품 등록
- [ ] 상품 메타데이터 완성
- [ ] Sandbox 테스터 계정 생성
- [ ] Archive 생성 시 StoreKit Configuration 비활성화

## 일반적인 오류

### "Store connection error"
- 원인: StoreKit Configuration이 프로덕션에서 활성화됨
- 해결: Scheme 설정에서 비활성화

### "Product not found"
- 원인: App Store Connect에 상품 미등록
- 해결: 상품 등록 및 메타데이터 완성

### "Cannot connect to iTunes Store"
- 원인: Bundle ID 불일치
- 해결: Bundle ID 확인 (com.nohbrother.teamsona.chatapp)

## 다음 단계

1. Xcode에서 StoreKit Configuration 비활성화
2. Clean Build Folder (Cmd+Shift+K)
3. 새 Archive 생성
4. TestFlight 업로드
5. 테스트 진행