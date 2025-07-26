# Firebase Authentication 설정 가이드

## 현재 오류
```
[firebase_auth/configuration-not-found] Error
```

이 오류는 Firebase Authentication이 활성화되지 않았거나 제대로 설정되지 않았을 때 발생합니다.

## 해결 방법

### 1. Firebase Console에 로그인
https://console.firebase.google.com/

### 2. 프로젝트 선택
프로젝트 ID: **sona-app-89598**

### 3. Authentication 활성화

1. 왼쪽 메뉴에서 **Build** → **Authentication** 클릭
2. **Get started** 버튼 클릭 (처음인 경우)
3. **Sign-in method** 탭으로 이동

### 4. 인증 방법 활성화

#### Anonymous 인증 (튜토리얼 모드용)
1. **Anonymous** 클릭
2. **Enable** 토글 ON
3. **Save** 클릭

#### Email/Password 인증
1. **Email/Password** 클릭
2. **Enable** 토글 ON
3. **Save** 클릭

#### Google 인증 (선택사항)
1. **Google** 클릭
2. **Enable** 토글 ON
3. **Project support email** 입력
4. **Save** 클릭

### 5. 설정 확인

Authentication이 활성화되면:
- Sign-in method 탭에 활성화된 방법들이 표시됩니다
- Users 탭이 활성화됩니다

### 6. 앱에서 테스트

1. 브라우저 캐시 지우기 (Ctrl+Shift+Delete)
2. 페이지 새로고침 (Ctrl+F5)
3. http://localhost:5004 에서 다시 테스트

## 추가 확인 사항

### API 키 확인
현재 사용 중인 API 키: `AIzaSyBDAB8M2j6qL5V0Emg7WeIy3PionY5aKeQ`

Firebase Console → Project settings → General에서 Web API Key 확인

### Authorized domains
Authentication → Settings → Authorized domains에서 `localhost`가 포함되어 있는지 확인

## 여전히 문제가 있다면

1. Firebase Console에서 프로젝트가 올바른지 확인
2. 브라우저 개발자 도구 → Network 탭에서 실패한 요청의 상세 내용 확인
3. Firebase Authentication이 정상적으로 초기화되었는지 확인