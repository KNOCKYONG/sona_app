# Firebase 스키마 업데이트 가이드

## 변경 사항 요약

### 1. user_persona_relationships 컬렉션
**변경 내용**: 
- `relationshipScore` (기존) → `likes` (신규)
- 무제한 Like 시스템으로 전환 (기존 1000점 제한 제거)

**새로운 필드**:
```javascript
{
  userId: string,
  personaId: string,
  likes: number, // 기존 relationshipScore 대체
  breakupAt: timestamp, // 이별 시 추가
  breakupReason: string, // 이별 사유
  updatedAt: timestamp,
  migratedAt: timestamp // 마이그레이션 시점
}
```

### 2. messages 컬렉션
**변경 내용**:
- `scoreChange` → `likeChange` (선택적)

### 3. 새로운 컬렉션

#### milestone_history
마일스톤 달성 이력 저장
```javascript
{
  userId: string,
  personaId: string,
  likes: number,
  message: string, // 예: "첫 100 Like 달성! 🎉"
  timestamp: timestamp
}
```

#### breakup_history
이별 이력 저장
```javascript
{
  userId: string,
  personaId: string,
  reason: string, // violence, sexual, hate, repetitive_negativity, mutual
  timestamp: timestamp
}
```

## Firebase 인덱스 설정

Firebase Console에서 다음 인덱스를 생성해야 합니다:

1. **milestone_history**
   - Collection: `milestone_history`
   - Fields: 
     - userId (Ascending)
     - personaId (Ascending) 
     - timestamp (Descending)

2. **breakup_history**
   - Collection: `breakup_history`
   - Fields:
     - userId (Ascending)
     - personaId (Ascending)
     - timestamp (Descending)

3. **user_persona_relationships** (업데이트)
   - Collection: `user_persona_relationships`
   - Fields:
     - userId (Ascending)
     - likes (Descending)

## 마이그레이션 실행

1. Firebase 프로젝트 백업
2. 마이그레이션 스크립트 실행:
   ```bash
   dart run scripts/migrate_to_likes_system.dart
   ```

3. Firebase Console에서 인덱스 생성

4. 보안 규칙 업데이트:
   ```bash
   firebase deploy --only firestore:rules
   ```

## 주의사항

1. **백업 필수**: 마이그레이션 전 반드시 데이터 백업
2. **점진적 배포**: 테스트 환경에서 먼저 테스트
3. **모니터링**: 마이그레이션 후 에러 로그 모니터링
4. **롤백 계획**: 문제 발생 시 롤백 절차 준비

## 앱 업데이트 체크리스트

- [x] RelationScoreService 새로운 Like 시스템으로 업데이트
- [x] UI 컴포넌트에서 한글 관계 표시 제거
- [x] 시각적 요소 (색상, 뱃지, 링) 적용
- [x] ChatService에서 새 Like 시스템 사용
- [x] 부정적 행동 감지 및 이별 시스템 구현
- [x] Firebase 스키마 마이그레이션 스크립트 작성
- [x] 보안 규칙 업데이트

## 롤백 절차

문제 발생 시:
1. 앱을 이전 버전으로 되돌리기
2. Firebase 보안 규칙을 이전 버전으로 복원
3. 필요시 역마이그레이션 스크립트 실행