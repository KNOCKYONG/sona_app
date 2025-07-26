# SONA - 감정 기반 AI 페르소나 대화 앱

SONA는 ChatGPT 기반의 AI 페르소나와 자연스러운 대화를 나눌 수 있는 Flutter 앱입니다.

## 🚀 시작하기

### 1. 환경 변수 설정

보안을 위해 API 키는 환경 변수로 관리됩니다.

1. `.env.example` 파일을 `.env`로 복사:
   ```bash
   cp .env.example .env
   ```

2. `.env` 파일을 열고 실제 API 키로 변경:
   ```env
   # OpenAI API 키 (https://platform.openai.com에서 발급)
   OPENAI_API_KEY=your_actual_openai_api_key_here
   ```

### 2. 의존성 설치

```bash
flutter pub get
```

### 3. 앱 실행

```bash
flutter run
```

## 🔐 보안 주의사항

- `.env` 파일은 Git에 커밋되지 않습니다 (`.gitignore`에 포함)
- 실제 API 키를 소스코드에 직접 넣지 마세요
- `.env.example`은 템플릿용이므로 실제 값을 넣지 마세요

## 📁 프로젝트 구조

```
lib/
├── models/          # 데이터 모델
├── screens/         # UI 화면
├── services/        # 비즈니스 로직
├── widgets/         # 재사용 위젯
└── main.dart        # 앱 진입점
```

## 🔑 OpenAI API 키 발급

1. [platform.openai.com](https://platform.openai.com) 방문
2. 계정 생성/로그인
3. API Keys 메뉴에서 새 키 생성
4. 생성된 키를 `.env` 파일에 추가

## 🛠️ 개발 환경

- Flutter 3.0.0+
- Dart 2.19.0+
- Firebase (인증 및 데이터베이스)

## 📱 주요 기능

- 🤖 ChatGPT 기반 자연스러운 AI 대화
- 👥 다양한 페르소나 캐릭터
- 💕 관계 단계별 감정 표현
- 🔒 Firebase 인증
- 💾 대화 히스토리 저장