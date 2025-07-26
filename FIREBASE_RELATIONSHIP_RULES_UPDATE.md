# 🔧 Firebase 친밀도 시스템 Security Rules 업데이트 가이드

## ✅ **적용해야 할 업데이트**

친밀도 시스템이 정상 작동하려면 Firebase Console에서 Firestore Security Rules를 업데이트해야 합니다.

## 📋 **업데이트 단계**

### 1. Firebase Console 접속
1. [Firebase Console](https://console.firebase.google.com/) 접속
2. 프로젝트 선택
3. 왼쪽 메뉴에서 **"Firestore Database"** 클릭

### 2. Security Rules 탭 이동
1. 상단의 **"규칙(Rules)"** 탭 클릭
2. 현재 규칙 확인

### 3. 새로운 규칙 적용
다음 규칙을 복사해서 붙여넣기:

```javascript
rules_version = '2';

service cloud.firestore {
  match /databases/{database}/documents {
    // 🔧 공개 접근 가능한 페르소나 컬렉션 (읽기 전용)
    match /personas/{document} {
      allow read: if true;
      allow write: if request.auth != null;
    }
    
    // 🔧 NEW: 사용자-페르소나 관계 컬렉션 (친밀도 저장)
    match /user_persona_relationships/{document} {
      allow read, write: if true; // 튜토리얼 모드를 위한 공개 접근
    }
    
    // 인증된 사용자의 개인 데이터
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
      
      // 사용자의 채팅 데이터
      match /chats/{chatId} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
        
        match /messages/{messageId} {
          allow read, write: if request.auth != null && request.auth.uid == userId;
        }
      }
      
      // 사용자의 매칭 데이터
      match /matches/{matchId} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
      
      // 사용자의 스와이프 기록
      match /swipes/{document} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
    }
    
    // 기타 모든 문서는 인증 필요
    match /{document=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

### 4. 규칙 게시
1. **"게시(Publish)"** 버튼 클릭
2. 확인 다이얼로그에서 **"게시"** 클릭
3. 업데이트 완료 확인

## 🎯 **주요 변경사항**

### ✅ 추가된 규칙
```javascript
// 🔧 NEW: 사용자-페르소나 관계 컬렉션 (친밀도 저장)
match /user_persona_relationships/{document} {
  allow read, write: if true; // 튜토리얼 모드를 위한 공개 접근
}
```

### 📊 **컬렉션 구조**
친밀도 시스템에서 사용하는 `user_persona_relationships` 컬렉션 구조:

```javascript
// 문서 ID: {userId}_{personaId}
{
  userId: "tutorial_user",
  personaId: "persona_001",
  relationshipScore: 75,
  relationshipType: "friend",
  relationshipDisplayName: "친구",
  isMatched: true,
  isActive: true,
  personaName: "예슬",
  personaAge: 22,
  personaPhotoUrl: "https://...",
  lastInteraction: Timestamp,
  totalInteractions: 5,
  createdAt: Timestamp,
  updatedAt: Timestamp
}
```

## ⚠️ **중요 사항**

1. **튜토리얼 모드 지원**: `allow read, write: if true`로 설정하여 익명 사용자도 접근 가능
2. **보안**: 실제 운영 환경에서는 더 엄격한 규칙 적용 권장
3. **권한 전파**: 규칙 업데이트 후 약 1-2분 후에 적용됨

## 🔍 **테스트 방법**

규칙 업데이트 후:
1. 앱에서 페르소나 매칭
2. 채팅으로 이동
3. 메시지 전송
4. 콘솔에서 친밀도 업데이트 로그 확인:
   ```
   🔄 Starting relationship score update: personaId=persona_001, change=3, userId=tutorial_user
   📊 Score calculation: 50 + 3 = 53 (친구)
   ✅ Updated current persona: 예슬 → 53
   ```

## ❌ **문제 해결**

### "permission-denied" 오류가 계속 발생하는 경우:
1. Firebase Console에서 규칙이 정상 적용되었는지 확인
2. 브라우저 캐시 비우기
3. 앱 재시작
4. 1-2분 대기 후 재시도

### 친밀도가 업데이트되지 않는 경우:
1. 콘솔 로그에서 `📊 Processing relationship score change` 메시지 확인
2. PersonaService와 ChatService 연동 상태 확인
3. 튜토리얼 모드인지 확인

## ✅ **완료 확인**

규칙 업데이트가 성공적으로 완료되면:
- ✅ "Error loading relationship: permission-denied" 오류 사라짐
- ✅ 채팅에서 친밀도 변화 정상 작동
- ✅ Firebase Console에서 `user_persona_relationships` 컬렉션 데이터 확인 가능 