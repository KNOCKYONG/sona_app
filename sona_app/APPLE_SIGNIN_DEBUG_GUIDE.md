# 🍎 Apple Sign-In 디버깅 가이드

## 🔍 현재 상황
- **에러**: `invalid-credential - Invalid OAuth response from apple.com`
- **Bundle ID**: `com.nohbrother.teamsona.chatapp`
- **Team ID**: `3VXN83XNN5`

## 📋 체크리스트

### ✅ 완료된 설정
1. ✅ Xcode에 Sign in with Apple capability 추가됨
2. ✅ Runner.entitlements에 `com.apple.developer.applesignin` 설정됨
3. ✅ Apple Developer Console에 Key 생성됨 (ID: `7D56F5DTN4`)
4. ✅ Flutter 코드에 Apple Sign-In 구현됨

### ⚠️ 확인 필요 사항

#### 1. Service ID 생성 확인
Apple Developer Console에서 **Service ID**가 생성되었는지 확인:
1. Identifiers → Services IDs 섹션 확인
2. 없다면 새로 생성:
   - Identifier: `com.nohbrother.teamsona.service` (App ID와 다르게)
   - Sign in with Apple 활성화
   - Return URL: `https://teamsona.firebaseapp.com/__/auth/handler`

#### 2. Firebase Console 설정 확인
Authentication → Sign-in method → Apple에서:
- **Services ID**: Service ID 입력 (App ID 아님!)
- **Team ID**: `3VXN83XNN5`
- **Key ID**: `7D56F5DTN4`  
- **Private key**: .p8 파일 전체 내용

## 🛠️ 디버깅 단계

### 1. 콘솔 로그 확인
앱을 실행하고 Apple 로그인 시도 후 다음 로그 확인:

```
🍎 [AuthService] Requesting Apple ID credential...
  - Generated nonce: [32자리 랜덤 문자열]
  - SHA256 nonce: [해시값]
🍎 [AuthService] Apple credential received:
  - identityToken: [토큰 일부]...
  - identityToken length: [길이]
  - authorizationCode: [코드 일부]...
  - userIdentifier: [사용자 ID]
  - email: [이메일 또는 null]
```

### 2. Firebase Auth 상태 로그
main.dart에 추가한 리스너에서 출력되는 로그 확인:

```
🔐 [Main] Auth State Changed:
  - User UID: [UID 또는 null]
  - Is Anonymous: [true/false]
  - Provider: [apple.com 등]
```

### 3. 에러 상세 정보
FirebaseAuthException 발생 시:

```
❌ [AuthService] Firebase Auth error during Apple Sign-In:
  - Error code: invalid-credential
  - Error message: [상세 메시지]
  ⚠️ This usually means:
    1. Service ID mismatch in Firebase Console
    2. Team ID is incorrect
    3. Key ID or Private Key is wrong
    4. OAuth redirect URL mismatch
```

## 🌐 네트워크 트래픽 분석

### Charles Proxy 또는 Proxyman 사용

1. **프록시 설정**
   - iOS 기기: Settings → Wi-Fi → HTTP Proxy → Manual
   - Server: Mac IP 주소
   - Port: 8888 (Charles) 또는 9090 (Proxyman)

2. **SSL 인증서 설치**
   - iOS 기기에서 `chls.pro/ssl` (Charles) 또는 `proxy.man/ssl` (Proxyman) 접속
   - 프로파일 설치
   - Settings → General → About → Certificate Trust Settings에서 활성화

3. **관찰할 요청**
   - `appleid.apple.com` - Apple 인증 요청
   - `firebaseapp.com/__/auth/handler` - Firebase 콜백
   - 요청/응답 헤더와 바디 확인

## 🔧 일반적인 문제 해결

### 1. "invalid-credential" 에러
**원인**: Firebase와 Apple Developer Console 설정 불일치

**해결**:
- Service ID가 정확한지 확인 (App ID와 다름)
- Team ID가 정확한지 확인
- Private Key(.p8)를 다시 복사/붙여넣기
- Return URL이 정확히 일치하는지 확인

### 2. Apple 로그인 창이 안 뜸
**원인**: 기기 설정 문제

**해결**:
- Settings → Sign in to your iPhone 확인
- Settings → Screen Time → Content & Privacy Restrictions → Sign in with Apple 허용
- 실제 기기 사용 (시뮬레이터 X)

### 3. 로그인 후 Firebase 인증 실패
**원인**: nonce 불일치 또는 토큰 만료

**해결**:
- nonce 생성/검증 로직 확인
- 시간 동기화 확인 (기기 시간 설정)

## 📝 추가 디버깅 팁

### Xcode Console 상세 로그
1. Product → Scheme → Edit Scheme
2. Run → Arguments → Environment Variables:
   - `CFNETWORK_DIAGNOSTICS` = `3`
   - `IDEPreferLogStreaming` = `YES`

### Firebase Console 확인
1. Firebase Console → Project Settings → General
   - Bundle ID 확인
2. Authentication → Users
   - 실패한 로그인 시도 확인
3. Authentication → Sign-in method → Apple
   - 모든 설정값 재확인

## 🚀 테스트 순서

1. **설정 확인**
   - Apple Developer Console에서 Service ID 확인
   - Firebase Console에서 설정값 확인

2. **코드 실행**
   - Xcode에서 실제 기기로 빌드
   - Console 로그 모니터링

3. **로그인 시도**
   - Apple 로그인 버튼 탭
   - Face ID/Touch ID 인증
   - 권한 허용

4. **로그 분석**
   - 어느 단계에서 실패하는지 확인
   - 에러 메시지 상세 분석

## 📞 추가 지원

문제가 계속되면 다음 정보와 함께 문의:
1. 전체 콘솔 로그
2. Firebase Console 설정 스크린샷
3. Apple Developer Console Service ID 설정 스크린샷
4. 네트워크 트래픽 캡처 (민감 정보 제거)