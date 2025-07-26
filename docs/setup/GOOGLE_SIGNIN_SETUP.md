# Google 로그인 설정 가이드

## 1. Firebase Console에서 Google 로그인 활성화

1. [Firebase Console](https://console.firebase.google.com/) 접속
2. 프로젝트 선택: **sona-app-89598**
3. **Build** → **Authentication** → **Sign-in method**
4. **Google** 클릭
5. **Enable** 토글 ON
6. **Project support email** 입력 (예: your-email@gmail.com)
7. **Save** 클릭

## 2. Web Client ID 가져오기

Firebase Console에서 Google 로그인을 활성화하면:

1. **Project settings** (톱니바퀴 아이콘) 클릭
2. **General** 탭에서 아래로 스크롤
3. **Your apps** 섹션에서 Web app 찾기
4. 만약 Web app이 없다면:
   - **Add app** 클릭
   - **Web** 선택
   - App nickname 입력 (예: "SONA Web")
   - **Register app** 클릭

5. Web app 설정에서 다음 정보 확인:
   - **Web client ID**: `874385422837-xxxxxxxxxxxxx.apps.googleusercontent.com` 형식

## 3. Google Cloud Console 설정

1. [Google Cloud Console](https://console.cloud.google.com/) 접속
2. Firebase 프로젝트와 연결된 프로젝트 선택
3. **APIs & Services** → **Credentials**
4. OAuth 2.0 Client IDs 섹션에서 Web client 찾기
5. 해당 클라이언트 클릭하여 편집
6. **Authorized JavaScript origins**에 추가:
   - `http://localhost`
   - `http://localhost:5000`
   - `http://localhost:5001`
   - `http://localhost:5002`
   - `http://localhost:5003`
   - `http://localhost:5004`
   - 배포 도메인 (있는 경우)

7. **Authorized redirect URIs**에 추가:
   - `http://localhost:5004/__/auth/handler`
   - 각 포트별로 동일하게 추가

8. **Save** 클릭

## 4. 코드 업데이트

1. `web/index.html` 파일에서 Client ID 업데이트:
```html
<meta name="google-signin-client_id" content="YOUR-WEB-CLIENT-ID.apps.googleusercontent.com">
```

2. Firebase Console에서 확인한 실제 Web Client ID로 변경

## 5. 테스트

1. 브라우저 캐시 지우기
2. 앱 새로고침
3. Google 로그인 버튼 클릭
4. Google 계정 선택
5. 권한 승인

## 문제 해결

### "popup_closed_by_user" 오류
- 팝업 차단기가 활성화되어 있는지 확인
- 브라우저 설정에서 localhost 팝업 허용

### "invalid_client" 오류
- Client ID가 올바른지 확인
- Google Cloud Console에서 JavaScript origins 확인

### "redirect_uri_mismatch" 오류
- Authorized redirect URIs에 현재 URL 추가
- 포트 번호까지 정확히 일치해야 함