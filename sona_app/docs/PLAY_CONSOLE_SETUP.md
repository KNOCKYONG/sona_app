# Google Play Console 인앱 결제 설정 가이드

## 1. 사전 준비 사항

### 1.1 Google Play Console 계정
- Google Play Developer 계정 필요 ($25 일회성 등록비)
- https://play.google.com/console 에서 가입

### 1.2 앱 업로드
- 앱이 최소 한 번은 Play Console에 업로드되어야 함
- 내부 테스트 트랙으로 업로드 가능

## 2. 앱 서명 설정

### 2.1 키스토어 생성
```bash
# 키스토어 생성 (한 번만 실행)
keytool -genkey -v -keystore ~/teamsona-chatapp-release.keystore \
  -alias teamsona-chatapp \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000
```

### 2.2 key.properties 파일 생성
`android/key.properties` 파일 생성:
```properties
storePassword=<비밀번호>
keyPassword=<비밀번호>
keyAlias=teamsona-chatapp
storeFile=/Users/<사용자명>/teamsona-chatapp-release.keystore
```

### 2.3 build.gradle 설정
`android/app/build.gradle.kts`에 서명 설정 추가:

```kotlin
// 파일 상단에 추가
import java.util.Properties

// android 블록 전에 추가
val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties()
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(keystorePropertiesFile.inputStream())
}

android {
    // ... 기존 설정 ...
    
    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String
            keyPassword = keystoreProperties["keyPassword"] as String
            storeFile = file(keystoreProperties["storeFile"] as String)
            storePassword = keystoreProperties["storePassword"] as String
        }
    }
    
    buildTypes {
        release {
            isMinifyEnabled = true
            signingConfig = signingConfigs.getByName("release")
        }
    }
}
```

## 3. Play Console 설정

### 3.1 앱 생성
1. Play Console에서 "앱 만들기" 클릭
2. 앱 이름: SONA
3. 기본 언어: 한국어
4. 앱 또는 게임: 앱
5. 무료 또는 유료: 무료

### 3.2 앱 설정 완료
- 앱 콘텐츠 정보 입력
- 콘텐츠 등급 설정
- 타겟 연령층 설정
- 데이터 보안 설정

### 3.3 내부 테스트 트랙에 앱 업로드
```bash
# 릴리즈 빌드 생성
flutter build appbundle --release

# 생성된 파일 위치
# build/app/outputs/bundle/release/app-release.aab
```

Play Console에서:
1. "출시" → "테스트" → "내부 테스트"
2. "새 버전 만들기"
3. App Bundle 업로드
4. 버전 이름과 출시 노트 입력
5. "검토" → "내부 테스트 트랙으로 출시 시작"

## 4. 인앱 상품 설정

### 4.1 상품 생성
Play Console에서 "수익 창출" → "제품" → "인앱 상품":

#### 소모성 상품 (하트)
1. **하트 10개**
   - 상품 ID: `com.nohbrother.teamsona.chatapp.hearts_10`
   - 이름: 하트 10개
   - 설명: 매칭과 채팅에 사용할 수 있는 하트 10개
   - 가격: ₩1,100

2. **하트 30개**
   - 상품 ID: `com.nohbrother.teamsona.chatapp.hearts_30`
   - 이름: 하트 30개
   - 설명: 매칭과 채팅에 사용할 수 있는 하트 30개
   - 가격: ₩3,300

3. **하트 50개**
   - 상품 ID: `com.nohbrother.teamsona.chatapp.hearts_50`
   - 이름: 하트 50개
   - 설명: 매칭과 채팅에 사용할 수 있는 하트 50개
   - 가격: ₩5,500

#### 구독 상품 (프리미엄)
"수익 창출" → "제품" → "구독":

1. **프리미엄 1개월**
   - 상품 ID: `com.nohbrother.teamsona.chatapp.premium_1month`
   - 이름: SONA 프리미엄 1개월
   - 설명: 무제한 매칭, 광고 제거
   - 결제 주기: 1개월
   - 가격: ₩4,400

2. **프리미엄 3개월**
   - 상품 ID: `com.nohbrother.teamsona.chatapp.premium_3months`
   - 이름: SONA 프리미엄 3개월
   - 설명: 무제한 매칭, 광고 제거 (20% 할인)
   - 결제 주기: 3개월
   - 가격: ₩11,000

3. **프리미엄 6개월**
   - 상품 ID: `com.nohbrother.teamsona.chatapp.premium_6months`
   - 이름: SONA 프리미엄 6개월
   - 설명: 무제한 매칭, 광고 제거 (30% 할인)
   - 결제 주기: 6개월
   - 가격: ₩19,900

### 4.2 상품 활성화
각 상품 생성 후:
1. "활성화" 버튼 클릭
2. 국가별 가격 설정
3. 저장

## 5. 테스트 설정

### 5.1 라이선스 테스터 추가
1. Play Console → "설정" → "라이선스 테스트"
2. 테스터 이메일 주소 추가
3. 라이선스 응답: "LICENSED" 선택

### 5.2 내부 테스트 그룹 설정
1. "출시" → "테스트" → "내부 테스트"
2. "테스터" 탭
3. "이메일 목록 만들기 또는 선택"
4. 테스터 이메일 추가
5. "변경사항 저장"

### 5.3 테스트 링크 공유
1. 내부 테스트 페이지에서 "테스터" 탭
2. "링크 복사" 클릭
3. 테스터에게 링크 공유

## 6. 테스트 방법

### 6.1 테스터 설정
1. 테스트 기기에서 테스터 Google 계정으로 로그인
2. Play Store 앱에서 동일 계정 로그인
3. 공유받은 테스트 링크 접속
4. "테스터 되기" 수락

### 6.2 앱 설치
1. Play Store에서 SONA 검색 (내부 테스트 버전)
2. 설치

### 6.3 구매 테스트
- 테스트 계정으로는 실제 결제 없이 구매 가능
- 구매 완료 후 "테스트 카드로 결제됨" 메시지 표시

## 7. 실제 환경 전환

### 7.1 MockPurchaseService 비활성화
`lib/main.dart`에서:
```dart
// 프로덕션 빌드 시 실제 서비스 사용하도록 변경
ChangeNotifierProvider<PurchaseService>(
  create: (_) => PurchaseService(), // MockPurchaseService 제거
),
```

### 7.2 ProGuard 규칙 추가
`android/app/proguard-rules.pro`:
```
-keep class com.android.billingclient.** { *; }
-keep class com.google.android.gms.** { *; }
```

### 7.3 릴리즈 빌드
```bash
flutter build appbundle --release
```

## 8. 문제 해결

### 8.1 "상품을 찾을 수 없음" 오류
- 상품 ID가 정확한지 확인
- 상품이 활성화되었는지 확인
- 앱이 Play Console에 업로드되었는지 확인

### 8.2 "이 버전의 앱은 결제를 지원하지 않음" 오류
- 앱 서명이 Play Console과 일치하는지 확인
- 테스트 트랙에 업로드된 버전인지 확인

### 8.3 테스트 구매가 실제 결제로 처리됨
- 라이선스 테스터로 등록되었는지 확인
- Play Store에 로그인한 계정 확인

## 9. 수익 보고서
Play Console → "수익 창출" → "수익 보고서"에서 확인 가능

## 10. 주의 사항
- 구독 상품은 자동 갱신됨
- 환불 정책 준수 필요
- 세금 설정 필요 (Play Console → "수익 창출" → "세금 설정")