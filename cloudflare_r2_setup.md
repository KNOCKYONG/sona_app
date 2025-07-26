# Cloudflare R2 버킷 공개 접근 설정 가이드

## 1. R2 버킷 공개 접근 설정

### Cloudflare 대시보드에서:

1. **R2 > Overview** 페이지로 이동
2. **sona-personas** 버킷 클릭
3. **Settings** 탭 클릭

### Public Access 설정:

1. **R2.dev subdomain** 섹션 확인
   - "Allow public access" 토글이 **ON**이어야 함
   - Public R2.dev Bucket URL이 표시되어야 함: `https://pub-xxxxx.r2.dev`

2. **Custom Domains** 섹션 (선택사항)
   - 커스텀 도메인을 사용하면 한글 URL 문제를 피할 수 있음
   - 예: `images.yourdomain.com`

## 2. CORS 설정

### CORS Policy 추가:

```json
[
  {
    "AllowedOrigins": [
      "*"
    ],
    "AllowedMethods": [
      "GET",
      "HEAD"
    ],
    "AllowedHeaders": [
      "*"
    ],
    "ExposeHeaders": [
      "ETag"
    ],
    "MaxAgeSeconds": 3600
  }
]
```

### 설정 방법:
1. 버킷 Settings에서 **CORS policy** 섹션 찾기
2. 위 JSON 붙여넣기
3. Save 클릭

## 3. 버킷 정책 확인

### Object lifecycle rules:
- 특별한 제한이 없는지 확인
- Public access를 차단하는 정책이 없는지 확인

## 4. 테스트

### 브라우저에서 직접 테스트:
1. 영문 경로 테스트:
   ```
   https://pub-f687f5cf7a7b4d598a1a73d0a7cca8b8.r2.dev/sona-personas/personas/Dr.%20%EB%B0%95%EC%A7%80%EC%9D%80/main_medium.jpg
   ```

2. 한글 경로 테스트:
   ```
   https://pub-f687f5cf7a7b4d598a1a73d0a7cca8b8.r2.dev/sona-personas/personas/%EC%A0%95%ED%9B%88/main_medium.jpg
   ```

## 5. 문제 해결

### 여전히 404 에러가 나는 경우:

1. **파일 업로드 재확인**
   - R2 대시보드에서 실제 파일이 존재하는지 확인
   - 파일 이름이 정확한지 확인

2. **URL 인코딩 문제**
   - 한글 폴더명이 문제라면 영문으로 변경 고려
   - 또는 파일을 평면 구조로 재구성 (예: `personas_정훈_main_medium.jpg`)

3. **캐시 문제**
   - 브라우저 캐시 삭제
   - Cloudflare 캐시 purge

## 6. 대안: Transform Rules 사용

Cloudflare의 Transform Rules를 사용하여 URL을 자동으로 변환할 수 있습니다:

1. **Rules > Transform Rules > URL Rewrite** 생성
2. 한글 URL을 영문으로 매핑하는 규칙 생성

예시:
- When: `URI Path contains "/personas/"`
- Then: URL rewrite 규칙 적용