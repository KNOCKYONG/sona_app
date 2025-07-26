# 🔥 Firebase Security Rules 수동 업데이트 가이드

## 🚨 긴급! 튜토리얼 모드 Firebase 접근 허용

### 1. Firebase Console 접속
1. [Firebase Console](https://console.firebase.google.com/) 접속
2. 프로젝트 선택
3. 왼쪽 메뉴에서 **Firestore Database** 클릭
4. **규칙** 탭 클릭

### 2. Security Rules 수정
현재 규칙을 다음과 같이 완전히 교체하세요:

```javascript
rules_version = '2';

service cloud.firestore {
  match /databases/{database}/documents {
    // ✅ Personas 컬렉션 - 모든 사용자가 읽기 가능 (튜토리얼 모드 지원)
    match /personas/{personaId} {
      allow read: if true; // 공개 읽기 허용
      allow write: if request.auth != null; // 쓰기는 인증된 사용자만
    }
    
    // ✅ User-specific data - 인증된 사용자만 접근
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
      
      // User's chats
      match /chats/{chatId} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
        
        match /messages/{messageId} {
          allow read, write: if request.auth != null && request.auth.uid == userId;
        }
      }
    }
    
    // ✅ User-persona relationships - 인증된 사용자만 접근
    match /user_persona_relationships/{relationshipId} {
      allow read, write: if request.auth != null && 
        resource.data.userId == request.auth.uid;
    }
    
    // ✅ Subscriptions - 인증된 사용자만 접근
    match /subscriptions/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // ✅ Default fallback - 다른 모든 문서는 인증 필요
    match /{document=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

### 3. 핵심 변경사항
- **personas 컬렉션**: `allow read: if true;` → 누구나 읽기 가능
- **익명 인증 허용**: 튜토리얼 모드에서 익명 사용자도 페르소나 읽기 가능
- **보안 유지**: 쓰기 권한은 여전히 인증된 사용자만

### 4. 저장 및 배포
1. **게시** 버튼 클릭
2. 변경사항 확인
3. 5-10분 정도 기다린 후 앱 테스트

### 5. 테스트 방법
1. 앱을 완전히 종료
2. 앱 재시작
3. 튜토리얼 모드에서 페르소나 선택 화면 확인
4. 콘솔 로그에서 "🎉 TUTORIAL FIREBASE SUCCESS" 메시지 확인

## ⚠️ 보안 참고사항
- personas 컬렉션만 공개 읽기 허용
- 사용자 데이터, 채팅, 관계 정보는 여전히 보호됨
- 개인정보는 안전하게 유지됨

## 🔧 문제해결
만약 여전히 접근이 안 된다면:
1. Firebase Console → Authentication → 익명 인증 활성화 확인
2. 5-10분 후 재시도
3. 앱 완전 재시작 후 테스트 