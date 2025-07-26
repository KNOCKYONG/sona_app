# Persona Image Processor and Uploader (MCP Version)

이 스크립트는 페르소나 이미지를 최적화하고 Claude Code MCP를 통해 Cloudflare R2 Storage에 업로드한 후, Firebase personas 컬렉션을 업데이트합니다.

## 기능

1. **이미지 최적화**: 각 페르소나 이미지를 여러 크기로 리사이즈 (thumb, small, medium, large, original)
2. **다중 포맷 지원**: WebP와 JPEG 형식으로 저장
3. **MCP R2 업로드**: Claude Code MCP Cloudflare를 통해 R2에 업로드
4. **MCP Firebase 업데이트**: MCP Firebase를 통해 personas 컬렉션 업데이트
5. **자동 정리**: 폴더가 없는 페르소나의 imageUrls 필드 값 삭제

## 설치

```bash
pip install pillow
```

Note: firebase-admin과 boto3는 더 이상 필요하지 않습니다 (MCP 사용)

## 설정

1. **Cloudflare R2 설정**:
   - Claude Code MCP Cloudflare 설정 필요
   - R2 버킷은 공개 액세스 가능하도록 설정 필요

2. **Firebase 설정**:
   - Claude Code MCP Firebase 설정 필요
   - 별도 인증 파일 불필요

## 사용법

### 방법 1: Claude Code 환경에서 직접 실행

```bash
# 기본 사용 (기본 경로 사용)
python scripts/process_and_upload_personas.py

# 사용자 정의 경로 지정
python scripts/process_and_upload_personas.py --source "C:\custom\path\personas"
```

### 방법 2: 2단계 프로세스 (이미지 처리 + MCP 업로드)

1. 이미지 처리:
```bash
python scripts/process_and_upload_personas.py > results.json
```

2. MCP 업로드 (Claude Code에서):
```bash
python scripts/persona_mcp_uploader.py "$(cat results.json)"
```

## 폴더 구조

```
C:\Users\yong\Documents\personas\
├── 윤미\
│   ├── 윤미1.png
│   └── 윤미2.png
├── 예슬\
│   ├── 예슬1.png
│   └── 예슬2.png
└── ...
```

## 출력 구조 (R2 Storage)

```
sona-personas/
├── personas/
│   ├── 윤미/
│   │   ├── main_thumb.webp
│   │   ├── main_thumb.jpg
│   │   ├── main_small.webp
│   │   ├── main_small.jpg
│   │   ├── main_medium.webp
│   │   ├── main_medium.jpg
│   │   ├── main_large.webp
│   │   ├── main_large.jpg
│   │   └── main_original.webp
│   └── ...
```

## Firebase imageUrls 구조

```json
{
  "imageUrls": {
    "thumb": {
      "webp": "https://pub-xxx.r2.dev/sona-personas/personas/윤미/main_thumb.webp",
      "jpg": "https://pub-xxx.r2.dev/sona-personas/personas/윤미/main_thumb.jpg"
    },
    "small": {
      "webp": "https://pub-xxx.r2.dev/sona-personas/personas/윤미/main_small.webp",
      "jpg": "https://pub-xxx.r2.dev/sona-personas/personas/윤미/main_small.jpg"
    },
    "medium": {
      "webp": "https://pub-xxx.r2.dev/sona-personas/personas/윤미/main_medium.webp",
      "jpg": "https://pub-xxx.r2.dev/sona-personas/personas/윤미/main_medium.jpg"
    },
    "large": {
      "webp": "https://pub-xxx.r2.dev/sona-personas/personas/윤미/main_large.webp",
      "jpg": "https://pub-xxx.r2.dev/sona-personas/personas/윤미/main_large.jpg"
    },
    "original": {
      "webp": "https://pub-xxx.r2.dev/sona-personas/personas/윤미/main_original.webp"
    }
  }
}
```