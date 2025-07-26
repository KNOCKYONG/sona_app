# Firebase 익명 로그인 활성화 가이드

## 현재 오류
```
[firebase_auth/admin-restricted-operation] This operation is restricted to administrators only.
```

이 오류는 Firebase Console에서 익명 인증(Anonymous Authentication)이 비활성화되어 있을 때 발생합니다.

## 해결 방법

### 1. Firebase Console 접속
1. https://console.firebase.google.com/ 접속
2. 프로젝트 선택: **sona-app-89598**

### 2. Authentication 설정으로 이동
1. 왼쪽 메뉴에서 **Build** → **Authentication** 클릭
2. 상단 탭에서 **Sign-in method** 선택

### 3. 익명 인증 활성화
1. **Anonymous** 항목 찾기
2. **Anonymous** 클릭
3. **Enable** 스위치를 ON으로 변경
4. **Save** 버튼 클릭

### 4. 확인
- Sign-in method 목록에서 Anonymous가 "Enabled" 상태인지 확인
- Status 열에 초록색 체크 표시가 있어야 함

## 활성화 후 테스트

1. 브라우저 캐시 지우기 (Ctrl+Shift+Delete)
2. 페이지 새로고침 (Ctrl+F5)
3. "로그인 없이 둘러보기" 버튼 클릭
4. 정상적으로 튜토리얼 모드로 진입되는지 확인

## 추가 확인 사항

### 현재 활성화된 인증 방법 확인
Firebase Console에서 다음 인증 방법들이 활성화되어 있는지 확인:
- ✅ Google (이미 활성화됨)
- ❌ Anonymous (활성화 필요)
- Email/Password (선택사항)

### 보안 고려사항
익명 인증을 활성화하면:
- 사용자가 로그인 없이 앱을 사용할 수 있음
- 나중에 Google 계정으로 전환 가능
- 익명 사용자 데이터는 제한적으로만 저장됨

## 문제가 지속되는 경우

1. Firebase 프로젝트 ID가 올바른지 확인
2. Firebase Configuration이 최신인지 확인
3. 브라우저 콘솔에서 추가 에러 메시지 확인