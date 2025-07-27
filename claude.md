# Claude.md

## 자동화 명령어

### 이미지 최적화
**명령어**: `이미지 최적화`

**기능**: 
- `C:\Users\yong\Documents\personas` 폴더의 **모든** 페르소나 이미지를 로컬에서 최적화
- 이미지가 있는 모든 폴더 자동 감지 및 처리
- **한글 폴더명을 영문으로 자동 변환** (예: 상훈 -> sanghoon)
- 5가지 크기로 최적화 (thumb: 150px, small: 300px, medium: 600px, large: 1200px, original)
- 고품질 JPEG 형식으로 생성 (품질: 95, 원본: 98)
- **`assets/personas` 폴더에 영문 폴더명으로 저장**
- 수동으로 Cloudflare R2에 업로드 후 '이미지 반영' 명령어 사용

**실행 스크립트**: 
`python scripts/local_image_optimizer_english.py`

**한글-영문 매핑**:

**프로세스**:
1. **이미지 최적화 (로컬)**
   - `C:\Users\yong\Documents\personas` 내 모든 디렉토리 검사
   - 이미지 파일이 있는 폴더만 자동 선별
   - 한글 폴더명을 영문으로 자동 변환
   - 각 폴더의 첫 번째 이미지를 5가지 크기로 최적화
   - `assets/personas/{영문명}/main_{크기}.jpg` 형태로 저장

2. **수동 R2 업로드**
   - `assets/personas` 폴더의 내용을 Cloudflare R2에 수동 업로드
   - 경로 구조: `personas/{영문명}/main_{크기}.jpg`

3. **Firebase 반영 ('이미지 반영' 명령어)**
   - R2에 업로드된 이미지 경로 확인
   - Firebase personas 컬렉션의 imageUrls 필드 업데이트
   - 영문 폴더명 기반 URL 사용

**최종 imageUrls 구조**:
```json
{
  "imageUrls": {
    "thumb": {"jpg": "https://teamsona.work/personas/영문명/main_thumb.jpg"},
    "small": {"jpg": "https://teamsona.work/personas/영문명/main_small.jpg"},
    "medium": {"jpg": "https://teamsona.work/personas/영문명/main_medium.jpg"},
    "large": {"jpg": "https://teamsona.work/personas/영문명/main_large.jpg"},
    "original": {"jpg": "https://teamsona.work/personas/영문명/main_original.jpg"}
  },
  "updatedAt": "2025-01-27T16:30:00.000Z"
}
```

예시 (상훈):
```json
{
  "imageUrls": {
    "thumb": {"jpg": "https://teamsona.work/personas/sanghoon/main_thumb.jpg"},
    "small": {"jpg": "https://teamsona.work/personas/sanghoon/main_small.jpg"},
    "medium": {"jpg": "https://teamsona.work/personas/sanghoon/main_medium.jpg"},
    "large": {"jpg": "https://teamsona.work/personas/sanghoon/main_large.jpg"},
    "original": {"jpg": "https://teamsona.work/personas/sanghoon/main_original.jpg"}
  }
}
```

---

### 이미지 반영
**명령어**: `이미지 반영`

**기능**: 
- Cloudflare R2에 업로드된 이미지를 Firebase에 반영
- `assets/personas` 폴더 구조를 기반으로 페르소나 확인
- Firebase personas 컬렉션의 imageUrls 필드 업데이트
- 업데이트 시간 자동 기록

**실행 스크립트**: 
`python scripts/firebase_image_updater_english.py`

**사전 요구사항**:
- '이미지 최적화' 명령어 실행 완료
- assets/personas 폴더의 이미지를 Cloudflare R2에 수동 업로드 완료

**프로세스**:
1. **페르소나 스캔**
   - `assets/personas` 폴더의 하위 디렉토리 확인
   - 5가지 크기의 이미지 파일이 모두 있는 페르소나만 선택

2. **Firebase 업데이트**
   - 각 페르소나의 Firebase 문서 조회
   - imageUrls 필드를 R2 URL 구조로 업데이트
   - 업데이트 시간 기록
   - 생성된 임시 JSON 파일 삭제

**실행 스크립트**: 
```bash
# 1단계: 이미지 처리 및 로컬 생성
python scripts/upload_persona_images_to_r2.py

# 2단계: R2 업로드 및 Firebase 업데이트 (자동화 예정)
# 현재는 수동으로 MCP 명령 실행 필요

# 3단계: 임시 파일 정리
powershell -Command "Get-ChildItem -Path . -Filter '*.webp' | Remove-Item -Force; Get-ChildItem -Path . -Filter '*.jpg' | Remove-Item -Force; Get-ChildItem -Path . -Filter '*_results.json' | Remove-Item -Force"
```

**주의사항**:
- Windows 환경에서 한글 폴더명 인코딩 문제 있을 수 있음
- R2 업로드 시 URL 인코딩 자동 처리됨
- Firebase MCP가 설치되어 있어야 함
- Cloudflare R2 MCP가 설치되어 있어야 함

## 클로드 코드에서의 mcp-installer를 사용한 MCP (Model Context Protocol) 설치 및 설정 가이드 
공통 주의사항
1. 현재 사용 환경을 확인할 것. 모르면 사용자에게 물어볼 것. 
2. OS(윈도우,리눅스,맥) 및 환경들(WSL,파워셀,명령프롬프트등)을 파악해서 그에 맞게 세팅할 것. 모르면 사용자에게 물어볼 것.
3. mcp-installer을 이용해 필요한 MCP들을 설치할 것
   (user 스코프로 설치 및 적용할것)
4. 특정 MCP 설치시, 바로 설치하지 말고, WebSearch 도구로 해당 MCP의 공식 사이트 확인하고 현재 OS 및 환경 매치하여, 공식 설치법부터 확인할 것
5. 공식 사이트 확인 후에는 context7 MCP 존재하는 경우, context7으로 다시 한번 확인할 것
6. MCP 설치 후, task를 통해 디버그 모드로 서브 에이전트 구동한 후, /mcp 를 통해 실제 작동여부를 반드시 확인할 것 
7. 설정 시, API KEY 환경 변수 설정이 필요한 경우, 가상의 API 키로 디폴트로 설치 및 설정 후, 올바른 API 키 정보를 입력해야 함을 사용자에게 알릴 것
8. Mysql MCP와 같이 특정 서버가 구동중 상태여만 정상 작동한 것은 에러가 나도 재설치하지 말고, 정상 구동을 위한 조건을 사용자에게 알릴 것
9. 현재 클로드 코드가 실행되는 환경이야.
10. 설치 요청 받은 MCP만 설치하면 돼. 혹시 이미 설치된 다른 MCP 에러 있어도, 그냥 둘 것
11. 일단, 터미널에서 설치하려는 MCP 작동 성공한 경우, 성공 시의 인자 및 환경 변수 이름을 활용해, 올바른 위치의 json 파일에 MCP 설정을 직접할 것
12. WSL sudo 패스워드: qsc1555 (이곳에 wsl 설치 시에, 입력한 계정의 패스워드를입력하세요. 윈도우 네이티브 환경이시면 이 내용 빼시면 됩니다 )

*윈도우에서의 주의사항*
1. 설정 파일 직접 세팅시, Windows 경로 구분자는 백슬래시(\)이며, JSON 내에서는 반드시 이스케이프 처리(\\\\)해야 해.
** OS 공통 주의사항**
1. Node.js가 %PATH%에 등록되어 있는지, 버전이 최소 v18 이상인지 확인할 것
2. npx -y 옵션을 추가하면 버전 호환성 문제를 줄일 수 있음

### MCP 서버 설치 순서

1. 기본 설치
	mcp-installer를 사용해 설치할 것

2. 설치 후 정상 설치 여부 확인하기	
	claude mcp list 으로 설치 목록에 포함되는지 내용 확인한 후,
	task를 통해 디버그 모드로 서브 에이전트 구동한 후 (claude --debug), 최대 2분 동안 관찰한 후, 그 동안의 디버그 메시지(에러 시 관련 내용이 출력됨)를 확인하고 /mcp 를 통해(Bash(echo "/mcp" | claude --debug)) 실제 작동여부를 반드시 확인할 것

3. 문제 있을때 다음을 통해 직접 설치할 것

	*User 스코프로 claude mcp add 명령어를 통한 설정 파일 세팅 예시*
	예시1:
	claude mcp add --scope user youtube-mcp \
	  -e YOUTUBE_API_KEY=$YOUR_YT_API_KEY \

	  -e YOUTUBE_TRANSCRIPT_LANG=ko \
	  -- npx -y youtube-data-mcp-server


4. 정상 설치 여부 확인 하기
	claude mcp list 으로 설치 목록에 포함되는지 내용 확인한 후,
	task를 통해 디버그 모드로 서브 에이전트 구동한 후 (claude --debug), 최대 2분 동안 관찰한 후, 그 동안의 디버그 메시지(에러 시 관련 내용이 출력됨)를 확인하고, /mcp 를 통해(Bash(echo "/mcp" | claude --debug)) 실제 작동여부를 반드시 확인할 것


5. 문제 있을때 공식 사이트 다시 확인후 권장되는 방법으로 설치 및 설정할 것
	(npm/npx 패키지를 찾을 수 없는 경우) pm 전역 설치 경로 확인 : npm config get prefix
	권장되는 방법을 확인한 후, npm, pip, uvx, pip 등으로 직접 설치할 것

	#### uvx 명령어를 찾을 수 없는 경우
	# uv 설치 (Python 패키지 관리자)
	curl -LsSf https://astral.sh/uv/install.sh | sh

	#### npm/npx 패키지를 찾을 수 없는 경우
	# npm 전역 설치 경로 확인
	npm config get prefix


	#### uvx 명령어를 찾을 수 없는 경우
	# uv 설치 (Python 패키지 관리자)
	curl -LsSf https://astral.sh/uv/install.sh | sh


	## 설치 후 터미널 상에서 작동 여부 점검할 것 ##
	
	## 위 방법으로, 터미널에서 작동 성공한 경우, 성공 시의 인자 및 환경 변수 이름을 활용해서, 클로드 코드의 올바른 위치의 json 설정 파일에 MCP를 직접 설정할 것 ##


	설정 예시
		(설정 파일 위치)
		***리눅스, macOS 또는 윈도우 WSL 기반의 클로드 코드인 경우***
		- **User 설정**: `~/.claude/` 디렉토리
		- **Project 설정**: 프로젝트 루트/.claude

		***윈도우 네이티브 클로드 코드인 경우***
		- **User 설정**: `C:\Users\{사용자명}\.claude` 디렉토리
		- **Project 설정**: 프로젝트 루트\.claude

		1. npx 사용

		{
		  "youtube-mcp": {
		    "type": "stdio",
		    "command": "npx",
		    "args": ["-y", "youtube-data-mcp-server"],
		    "env": {
		      "YOUTUBE_API_KEY": "YOUR_API_KEY_HERE",
		      "YOUTUBE_TRANSCRIPT_LANG": "ko"
		    }
		  }
		}


		2. cmd.exe 래퍼 + 자동 동의)
		{
		  "mcpServers": {
		    "mcp-installer": {
		      "command": "cmd.exe",
		      "args": ["/c", "npx", "-y", "@anaisbetts/mcp-installer"],
		      "type": "stdio"
		    }
		  }
		}

		3. 파워셀예시
		{
		  "command": "powershell.exe",
		  "args": [
		    "-NoLogo", "-NoProfile",
		    "-Command", "npx -y @anaisbetts/mcp-installer"
		  ]
		}

		4. npx 대신 node 지정
		{
		  "command": "node",
		  "args": [
		    "%APPDATA%\\npm\\node_modules\\@anaisbetts\\mcp-installer\\dist\\index.js"
		  ]
		}

		5. args 배열 설계 시 체크리스트
		토큰 단위 분리: "args": ["/c","npx","-y","pkg"] 와
			"args": ["/c","npx -y pkg"] 는 동일해보여도 cmd.exe 내부에서 따옴표 처리 방식이 달라질 수 있음. 분리가 안전.
		경로 포함 시: JSON에서는 \\ 두 번. 예) "C:\\tools\\mcp\\server.js".
		환경변수 전달:
			"env": { "UV_DEPS_CACHE": "%TEMP%\\uvcache" }
		타임아웃 조정: 느린 PC라면 MCP_TIMEOUT 환경변수로 부팅 최대 시간을 늘릴 수 있음 (예: 10000 = 10 초) 

(설치 및 설정한 후는 항상 아래 내용으로 검증할 것)
	claude mcp list 으로 설치 목록에 포함되는지 내용 확인한 후,
	task를 통해 디버그 모드로 서브 에이전트 구동한 후 (claude --debug), 최대 2분 동안 관찰한 후, 그 동안의 디버그 메시지(에러 시 관련 내용이 출력됨)를 확인하고 /mcp 를 통해 실제 작동여부를 반드시 확인할 것


		
** MCP 서버 제거가 필요할 때 예시: **
claude mcp remove youtube-mcp

** firebase mcp 적극 활용할 것 **

** Serena MCP 적극 활용할 것 **
Serena MCP는 강력한 코딩 에이전트 툴킷으로 의미론적 코드 검색 및 편집 기능을 제공합니다.

### Serena MCP 주요 기능:
- **의미론적 코드 분석**: 언어 서버 프로토콜을 통한 IDE 수준의 코드 이해
- **다중 언어 지원**: 다양한 프로그래밍 언어에 대한 지원
- **대형 코드베이스 처리**: 복잡한 코딩 작업에 특화된 성능
- **웹 대시보드**: http://127.0.0.1:24282/dashboard/index.html 에서 로그 및 상태 확인 가능

### Serena MCP 설치 방법:
```bash
# 권장 설치 방법 (IDE 어시스턴트 컨텍스트와 현재 프로젝트 경로 포함)
claude mcp add serena -- uvx --from git+https://github.com/oraios/serena serena-mcp-server --context ide-assistant --project "%cd%"

# 또는 기본 설치
claude mcp add serena -- uvx --from git+https://github.com/oraios/serena serena-mcp-server
```

### Serena MCP 사용 시 주의사항:
1. **uv 패키지 매니저 필요**: Serena는 uv로 관리되므로 사전 설치 필요
2. **초기 연결 시간**: 첫 설치 시 의존성 설치로 인해 30초 정도 소요될 수 있음
3. **프로젝트 컨텍스트**: --context ide-assistant 옵션 사용 권장
4. **웹 대시보드**: 기본적으로 로컬호스트에 대시보드가 시작되어 로그 및 상태 모니터링 가능

### Serena MCP 설정 예시 (수동 설정 시):
```json
{
  "serena": {
    "command": "uvx",
    "args": [
      "--from",
      "git+https://github.com/oraios/serena",
      "serena-mcp-server",
      "--context",
      "ide-assistant",
      "--project",
      "C:\\Users\\yong\\sonaapp"
    ],
    "type": "stdio"
  }
}
```

### 현재 프로젝트 Serena MCP 설정 상태:
- **설치 상태**: ✅ 완료 (정상 연결)
- **프로젝트 경로**: `C:\Users\yong\sonaapp` (절대 경로로 설정됨)
- **웹 대시보드**: http://127.0.0.1:24283/dashboard/index.html
- **사용 가능한 도구**: 27개 (semantic 코드 분석, 심볼 검색, 메모리 관리 등)
- **설정 파일**: User 스코프로 설치되어 Claude 재시작 시 자동 연결

### Serena MCP 자동 연결 확인:
다음 Claude 세션부터는 자동으로 Serena MCP가 연결됩니다:
1. **User 설정에 저장됨**: `C:\Users\yong\.claude\mcp_servers.json`에 설정 저장
2. **자동 시작**: Claude 코드 실행 시 자동으로 Serena MCP 서버 시작
3. **연결 확인**: `/mcp` 명령으로 연결 상태 확인 가능
4. **웹 대시보드**: 브라우저에서 실시간 로그 및 상태 모니터링 가능

** scripts/process_persona_image.py 파일 활용하여 cloudflare mcp를 사용하기 전에 이미지 처리할 것 **