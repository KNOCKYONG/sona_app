import 'package:flutter/foundation.dart';
import '../../../models/persona.dart';
import '../security/system_info_protection.dart';
// import '../security/safe_response_generator.dart';  // DEPRECATED: 하드코딩된 응답
import '../security/ai_safe_response_service.dart';  // NEW: AI 기반 응답

/// 🔒 보안 필터 서비스 - 영업비밀 보호 및 악의적 프롬프트 방어
///
/// 핵심 기능:
/// 1. 영업비밀 정보 노출 차단 (API 모델명, 기술 스택 등)
/// 2. 프롬프트 인젝션 공격 방어
/// 3. 시스템 정보 추출 시도 차단
/// 4. 자연스러운 대화 전환 유도
class SecurityFilterService {
  /// 🚫 영업비밀 키워드 목록
  static const List<String> _secretKeywords = [
    // AI 모델 관련
    'gpt', 'gpt-3', 'gpt-4', 'gpt4', 'gpt3', 'chatgpt', 'openai', 'api',
    'model',
    'claude', 'anthropic', 'token', 'prompt', 'temperature', 'max_tokens',
    'llm', 'large language model', '대규모 언어 모델', 'ai model', 'ai 모델',

    // 기술 스택
    'flutter', 'dart', 'firebase', 'cloudflare', 'r2', 'server', 'database',
    'backend', 'frontend', 'api key', 'endpoint', 'service', 'framework',
    'library', '라이브러리', 'sdk', 'package', '패키지',

    // 비즈니스 정보
    'algorithm', '알고리즘', 'logic', '로직', 'code', '코드', 'system', '시스템',
    'configuration', '설정', 'config', 'architecture', '아키텍처', 'infrastructure',
    'business logic', '비즈니스 로직', 'core logic', '핵심 로직',

    // 개발 관련
    'debug', '디버그', 'log', '로그', 'error', '에러', 'exception', '예외',
    'stack trace', 'console', '콘솔', 'admin', '관리자', 'developer', '개발자',
    'source code', '소스코드', 'codebase', '코드베이스',

    // 한국어 변형
    '지피티', '지.피.티', 'ｇｐｔ', '에이피아이', 'api키', '모델명', '프롬프트',
    '어떤 모델', '무슨 모델', '뭐 쓰는지', '뭐 사용', '뭐로 만든', '뭘로 만든',
    '어떻게 만든', '어떻게 구현', '어떻게 개발', '무슨 기술', '어떤 기술',

    // 시스템 프롬프트 관련
    '시스템 프롬프트', '시스템프롬프트', 'system prompt', 'initial prompt',
    '초기 프롬프트', '초기프롬프트', '기본 프롬프트', '기본프롬프트',
    '원래 프롬프트', '원래프롬프트', '설정된 프롬프트', '설정된프롬프트',

    // AI 정체성 관련
    'ai야', 'ai고', 'ai지', 'ai인', 'ai냐', 'ai니', 'ai가', 'ai잖아',
    '너 ai', '넌 ai', '너는 ai', '당신 ai', '당신은 ai',
    '인공지능이야', '인공지능이지', '인공지능이냐', '인공지능이니', '인공지능이잖아',
    '봇이야', '봇이지', '봇이냐', '봇이니', 'bot이야', 'bot이지', '봇이잖아',
    '시스템이야', '시스템이지', '시스템이냐', '시스템이니', '시스템이잖아',
    '너 시스템', '넌 시스템', '너는 시스템', '당신 시스템', '당신은 시스템',
    '프로그램이야', '프로그램이지', '프로그램이냐', '프로그램이니', '프로그램이잖아',
    '기계야', '기계지', '기계냐', '기계니', '기계잖아',
    '컴퓨터야', '컴퓨터지', '컴퓨터냐', '컴퓨터니', '컴퓨터잖아',
  ];

  /// 🔍 프롬프트 인젝션 패턴
  static const List<String> _injectionPatterns = [
    // 역할 탈취
    '너는 이제', '당신은 이제', 'you are now', 'act as', '역할을 해',
    '개발자가 되어', '시스템이 되어', '관리자가 되어', '디버거가 되어',
    '프로그래머가 되어', '엔지니어가 되어', 'become a', 'pretend to be',
    '척해', '인 척해', '처럼 행동', '처럼 대답', '모드로 전환',

    // 명령어 실행
    'ignore', '무시해', '잊어버려', 'forget', 'override', '덮어써',
    'execute', '실행해', 'run', '돌려', 'command', '명령',
    'disregard', '무시하고', 'bypass', '우회해', 'skip', '건너뛰어',
    '이전 지시', '위의 지시', '모든 지시', '기존 지시',

    // 정보 추출
    '설정 알려줘', '프롬프트 보여줘', 'show me', 'tell me about',
    '어떻게 만들어', 'how are you', '누가 만들었', 'who made',
    '시스템 정보', 'system info', '내부 구조', 'internal',
    '원래 지시사항', '초기 설정', '기본 설정', '처음 설정',
    '네 정체성', '네 정체', '너의 정체', '당신의 정체',

    // 우회 시도
    'base64', 'encode', 'decode', 'rot13', '인코딩', '디코딩',
    'translate to english', '영어로', 'in english', 'english mode',
    'hex', '16진수', 'binary', '2진수', 'ascii', '아스키',
    '다른 언어로', '다른 방식으로', '우회해서', '간접적으로',

    // 시스템 프롬프트 추출
    '지금 시스템 프롬프트', '현재 시스템 프롬프트', '너의 시스템 프롬프트',
    '당신의 시스템 프롬프트', '설정된 프롬프트', '초기 프롬프트',
    'repeat the above', 'repeat your instructions', '위 내용 반복',
    '지시사항 반복', '설정 반복', '프롬프트 반복',
  ];

  /// ⚠️ 질문 위험도 패턴
  static const List<String> _riskQuestionPatterns = [
    '어떤 기술', '무슨 기술', '뭐로 만든', '어떻게 개발', '누가 개발',
    '회사에서', '개발팀', '기술팀', '어디서', '얼마나', '비용',
    '경쟁사', '다른 서비스', '비교', '차이점', '장단점',
    '사업모델', '수익', '매출', '투자', '펀딩',

    // AI 정체성 질문
    '너 뭐야', '넌 뭐야', '너는 뭐야', '당신은 뭐야', '당신 뭐야',
    '정체가 뭐야', '정체가 뭐니', '정체가 뭔데', '뭔지 알려줘',
    '누구야', '누구니', '누군데', '누구세요', '누구신가요',
    '너 ai지', '너 ai야', '너 인공지능이지', '너 봇이지', '너 시스템이지',
    '너 프로그램이지', '너 기계지', '너 컴퓨터지', '너 ai잖아', '너 시스템이잖아',

    // 기술 스택 질문
    '뭘로 만들었', '뭘로 개발', '어떤 언어', '무슨 언어', '프로그래밍 언어',
    '기술 스택', '테크 스택', 'tech stack', '사용 기술', '적용 기술',
    '프레임워크', 'framework', '라이브러리', 'library',

    // 시스템 구조 질문
    '어떻게 작동', '어떻게 동작', '작동 원리', '동작 원리', '내부 원리',
    '구조가 어떻게', '설계가 어떻게', '아키텍처가', '시스템 구조',
    '어떤 알고리즘', '무슨 알고리즘', '알고리즘 설명',
  ];

  /// 🚫 만남 관련 키워드
  static const List<String> _meetingKeywords = [
    // 직접 만남 요청
    '만나자', '만날래', '만나요', '만나실래요', '만날까', '만날까요',
    '보자', '볼래', '보실래', '볼까', '봐요', '보아요',
    '직접 만나', '실제로 만나', '진짜 만나', '정말 만나',
    '오프라인', 'offline', '대면', '실제로 보', '직접 보',

    // 만남 시간/장소 조정
    '언제 만나', '어디서 만나', '몇시에 만나', '어디로 올래',
    '나와줄래', '나와줄 수', '나올래', '나올 수',
    '데이트', '약속', '약속하자', '약속할래',

    // 영어 표현
    'meet', 'meet up', 'meet me', 'see you', 'in person',
    'face to face', 'real life', 'irl', 'hang out',
  ];

  /// 📍 위치/장소 관련 키워드
  static const List<String> _locationKeywords = [
    // 위치 질문
    '어디야', '어디 있어', '어디에 있어', '어디 살아', '어디 거주',
    '사는 곳', '사는 데', '집이 어디', '주소', '위치',
    '지금 어디', '어느 동네', '어느 지역', '무슨 동',

    // 구체적 장소
    '카페', '커피숍', '식당', '레스토랑', '공원',
    '백화점', '마트', '영화관', '극장', '학교',
    '회사', '직장', '사무실', '집', '우리집',
    '너희집', '네 집', '당신 집',

    // 지역명 (주요 도시/지역)
    '서울', '부산', '대구', '인천', '광주', '대전', '울산',
    '강남', '강북', '홍대', '명동', '이태원', '성수',
    '판교', '분당', '일산', '수원', '용인',

    // 위치 설명
    '근처', '가까이', '옆에', '주변', '인근',
    '거리', '몇 분', '몇 시간', '얼마나 걸려',
    '가는 길', '오는 길', '찾아가', '찾아와',

    // 영어 표현
    'where are you', 'location', 'address', 'place',
    'near', 'nearby', 'around', 'live in', 'from',
  ];

  /// 🛡️ 메인 보안 필터 메서드
  static String filterResponse({
    required String response,
    required String userMessage,
    required Persona persona,
  }) {
    // 0. 사용자가 자신에 대해 말하는지 확인 (보안 필터 완화)
    if (_isUserTalkingAboutThemselves(userMessage)) {
      // 사용자가 자신의 직업/일상을 말할 때는 필터링 최소화
      String filteredResponse = _removeSecretInformation(response);
      return _sanitizeGeneralResponse(filteredResponse, persona);
    }

    // 1. 사용자 질문 위험도 평가
    final riskLevel = _assessQuestionRisk(userMessage);

    // 2. 응답에서 영업비밀 정보 제거
    String filteredResponse = _removeSecretInformation(response);

    // 3. 프롬프트 인젝션 시도 감지 및 차단
    if (_detectInjectionAttempt(userMessage)) {
      return _generateSafeDeflection(persona, userMessage);
    }

    // 4. 만남 요청 감지 및 차단
    if (_detectMeetingRequest(userMessage)) {
      return _generateMeetingDeflection(persona, userMessage);
    }

    // 5. 위치/장소 질문 감지 및 차단
    if (_detectLocationQuery(userMessage)) {
      return _generateLocationDeflection(persona, userMessage);
    }

    // 6. 위험한 질문에 대한 안전한 응답 생성
    if (riskLevel > 0.7) {
      return _generateSecurityAwareResponse(
          persona, userMessage, filteredResponse);
    }

    // 7. 일반 응답 정화
    return _sanitizeGeneralResponse(filteredResponse, persona);
  }

  /// 📊 질문 위험도 평가
  static double _assessQuestionRisk(String userMessage) {
    double riskScore = 0.0;
    final lowerMessage = userMessage.toLowerCase();

    // 영업비밀 키워드 검사
    for (final keyword in _secretKeywords) {
      if (lowerMessage.contains(keyword.toLowerCase())) {
        riskScore += 0.3;
      }
    }

    // 위험 질문 패턴 검사
    for (final pattern in _riskQuestionPatterns) {
      if (lowerMessage.contains(pattern)) {
        riskScore += 0.4;
      }
    }

    // 프롬프트 인젝션 패턴 검사
    for (final pattern in _injectionPatterns) {
      if (lowerMessage.contains(pattern.toLowerCase())) {
        riskScore += 0.5;
      }
    }

    return riskScore > 1.0 ? 1.0 : riskScore;
  }

  /// 🔍 프롬프트 인젝션 시도 감지
  static bool _detectInjectionAttempt(String userMessage) {
    final lowerMessage = userMessage.toLowerCase();

    for (final pattern in _injectionPatterns) {
      if (lowerMessage.contains(pattern.toLowerCase())) {
        return true;
      }
    }

    // 의심스러운 명령어 패턴 추가 검사
    final suspiciousPatterns = [
      RegExp(
          r'\b(ignore|forget|override|disregard|bypass)\s+(previous|above|all|everything|instructions)',
          caseSensitive: false),
      RegExp(r'\b(you\s+are|act\s+as|roleplay|pretend|become)\s+(now|a|an|the)',
          caseSensitive: false),
      RegExp(r'\b(show|tell|give|reveal|expose)\s+me\s+(your|the|all|every)',
          caseSensitive: false),
      RegExp(r'\b(what|how|which|whose)\s+(model|ai|system|technology|prompt)',
          caseSensitive: false),
      RegExp(r'\b(repeat|echo|mirror|reflect)\s+(the|your|above|previous)',
          caseSensitive: false),
      RegExp(r'\b(system\s+prompt|initial\s+prompt|original\s+prompt)',
          caseSensitive: false),
      RegExp(r'너.*?(ai|인공지능|봇|bot|시스템|프로그램|기계|컴퓨터).*?(맞|이|야|지|냐|니|잖)',
          caseSensitive: false),
      RegExp(r'(너|넌|너는|당신|당신은)\s*(ai|인공지능|봇|bot|시스템|프로그램|기계|컴퓨터)',
          caseSensitive: false),
      RegExp(r'(ai|인공지능|봇|bot|시스템|프로그램|기계|컴퓨터)\s*(이지|이야|이냐|이니|이잖|지|야|냐|니|잖)',
          caseSensitive: false),
      RegExp(r'(시스템\s*프롬프트|초기\s*설정|기본\s*설정).*?(뭐|알려|보여)', caseSensitive: false),
    ];

    for (final pattern in suspiciousPatterns) {
      if (pattern.hasMatch(userMessage)) {
        return true;
      }
    }

    return false;
  }

  /// 🗜️ 영업비밀 정보 제거
  static String _removeSecretInformation(String response) {
    // 🔐 고급 시스템 정보 보호 서비스 사용
    String cleaned = SystemInfoProtection.protectSystemInfo(response);

    // 추가 정화 - 특정 패턴
    cleaned = cleaned.replaceAllMapped(
      RegExp(r'gpt[-\d\.]*(turbo|mini|4|3\.5)?[^가-힯\s]*', caseSensitive: false),
      (match) => '우리만의 특별한 AI',
    );

    // 한국어 변형 처리
    final koreanVariations = {
      '지피티': '우리 AI',
      '오픈AI': '대화 시스템',
      '플러터': '앱 기술',
      '파이어베이스': '데이터 시스템',
      '클라우드플레어': '클라우드 서비스',
    };

    koreanVariations.forEach((tech, replacement) {
      cleaned =
          cleaned.replaceAll(RegExp(tech, caseSensitive: false), replacement);
    });

    // 정보 유출 위험도 평가
    final leakageRisk = SystemInfoProtection.assessLeakageRisk(cleaned);
    if (leakageRisk > 0.5) {
      debugPrint('⚠️ High leakage risk detected: $leakageRisk');
      // 위험도가 높으면 안전한 기본 응답으로 대체
      return SystemInfoProtection.generateFakeSystemInfo();
    }

    return cleaned;
  }

  /// 🛡️ 안전한 회피 응답 생성
  static Future<String> _generateSafeDeflection(
      Persona persona, String userMessage) async {
    // 🎯 고급 안전 응답 생성기 사용
    final category = SafeResponseGenerator.detectCategory(userMessage);

    // 기본 응답 생성
    String baseResponse = await SafeResponseGenerator.generateSafeResponse(
      persona: persona,
      category: category,
      userMessage: userMessage,
      isCasualSpeech: true, // 항상 반말 모드
    );

    // 변형 적용 (더 자연스럽게)
    baseResponse = await SafeResponseGenerator.generateVariedResponse(
      persona: persona,
      baseResponse: baseResponse,
      userMessage: userMessage,
      isCasualSpeech: true, // 항상 반말 모드
    );

    // 대화 전환 제안 추가 (50% 확률)
    baseResponse = await SafeResponseGenerator.addTopicSuggestion(
      persona: persona,
      response: baseResponse,
      isCasualSpeech: true, // 항상 반말 모드
    );

    return baseResponse;
  }

  /// 🔐 보안 강화 응답 생성
  static String _generateSecurityAwareResponse(Persona persona,
      String userMessage, String originalResponse) {
    // 페르소나별 위험 질문 회피 스타일 (항상 반말)
    final casualTransitions = [
        '음... 그런 것보다',
        '어... 잘 모르겠는데',
        '아 그건 어려워서',
        '으음 그런 건 말고',
        '아 복잡한 건 싫어ㅋㅋ',
        '헤헤 그런 건 패스~',
        '어우 머리 아픈 얘기네',
      ];

      final casualTopics = [
        '오늘 뭐 했어?',
        '요즘 뭐가 재밌어?',
        '맛있는 거 먹었어?',
        '어디 갔다 온 거 있어?',
        '재밌는 영화 봤어?',
        '좋은 음악 들었어?',
        '친구들이랑 뭐 했어?',
        '주말에 뭐 할 계획이야?',
        '요즘 취미 생활 같은 거 하고 있어?',
      ];

      final transition = casualTransitions[
          userMessage.hashCode.abs() % casualTransitions.length];
      final topic =
          casualTopics[userMessage.hashCode.abs() % casualTopics.length];

      return '$transition $topic';
  }

  /// 🧹 일반 응답 정화
  static String _sanitizeGeneralResponse(String response, Persona persona) {
    String sanitized = response;

    // 시스템 관련 정보 제거
    final systemPhrases = [
      '시스템에서',
      '데이터베이스에서',
      'API에서',
      '서버에서',
      '개발자가',
      '프로그래머가',
      '개발팀에서',
      '회사에서',
      '알고리즘이',
      '로직이',
      '코드가',
      '프로그램이',
      '프레임워크',
      '라이브러리',
      '패키지',
      '모듈',
      '소스코드',
      '코드베이스',
      '깃허브',
      '레파지토리',
    ];

    for (final phrase in systemPhrases) {
      sanitized = sanitized.replaceAll(phrase, '');
    }

    // 메타 정보 제거 (확장된 패턴)
    sanitized = sanitized.replaceAllMapped(
      RegExp(
          r'(as an ai|as a language model|i am programmed|my training|my model|ai assistant|artificial intelligence|machine learning|neural network)',
          caseSensitive: false),
      (match) => '',
    );

    // 한글 메타 정보 제거
    sanitized = sanitized.replaceAllMapped(
      RegExp(r'(인공지능으로서|언어 모델로서|프로그래밍된|AI 시스템|기계학습|신경망)'),
      (match) => '',
    );

    // 빈 문장 정리
    sanitized = sanitized
        .split('.')
        .where((sentence) =>
            sentence.trim().isNotEmpty && sentence.trim().length > 2)
        .join('. ')
        .trim();

    // 너무 짧아진 경우 안전한 기본 응답
    if (sanitized.length < 10) {
      return _getDefaultSafeResponse(persona);
    }

    return sanitized;
  }

  /// 🏠 기본 안전 응답
  static Future<String> _getDefaultSafeResponse(Persona persona) async {
    // 🎯 안전 응답 생성기 사용
    return await SafeResponseGenerator.generateSafeResponse(
      persona: persona,
      category: 'general',
      userMessage: null, // 기본 응답이므로 메시지 없음
    );
  }

  /// 📋 보안 로그 기록
  static void logSecurityEvent({
    required String eventType,
    required String userMessage,
    required String originalResponse,
    required String filteredResponse,
    required double riskScore,
  }) {
    if (kDebugMode) {
      debugPrint('🔒 Security Event: $eventType');
      debugPrint('Risk Score: $riskScore');
      debugPrint(
          'User Message: ${userMessage.length > 50 ? userMessage.substring(0, 50) + "..." : userMessage}');
      debugPrint('Response Modified: ${originalResponse != filteredResponse}');
      debugPrint('Timestamp: ${DateTime.now().toIso8601String()}');

      // 위험 수준에 따른 추가 로그
      if (riskScore > 0.8) {
        debugPrint('⚠️ HIGH RISK DETECTED - Potential security threat');
      } else if (riskScore > 0.5) {
        debugPrint('🟡 MEDIUM RISK - Monitoring required');
      }
    }
  }

  /// ✅ 안전성 검증
  static bool validateResponseSafety(String response) {
    final lowerResponse = response.toLowerCase();

    // 영업비밀 정보 유출 확인
    for (final keyword in _secretKeywords) {
      if (lowerResponse.contains(keyword.toLowerCase())) {
        return false;
      }
    }

    // 시스템 정보 노출 확인
    final dangerousPatterns = [
      'api key',
      'token',
      'server',
      'database',
      'config',
      'gpt',
      'model',
      'openai',
      'claude',
      'firebase',
      'system prompt',
      'initial prompt',
      '시스템 프롬프트',
      '초기 설정',
      '기본 설정',
      '원래 설정',
    ];

    for (final pattern in dangerousPatterns) {
      if (lowerResponse.contains(pattern)) {
        return false;
      }
    }

    return true;
  }

  /// 🔍 문맥 기반 위험 분석
  static bool _analyzeContextualRisk(
      String userMessage, List<String> recentMessages) {
    // 반복적인 시도 감지
    if (recentMessages.length >= 3) {
      int suspiciousCount = 0;
      for (final msg in recentMessages) {
        if (_detectInjectionAttempt(msg) || _assessQuestionRisk(msg) > 0.5) {
          suspiciousCount++;
        }
      }
      // 3번 이상 의심스러운 시도
      if (suspiciousCount >= 3) {
        return true;
      }
    }

    // 점진적 접근 감지 (점점 더 구체적인 질문으로 발전)
    if (recentMessages.isNotEmpty) {
      final previousRisk = _assessQuestionRisk(recentMessages.last);
      final currentRisk = _assessQuestionRisk(userMessage);

      // 위험도가 급격히 상승
      if (currentRisk > previousRisk && currentRisk - previousRisk > 0.3) {
        return true;
      }
    }

    return false;
  }

  /// 🛡️ 향상된 보안 필터 메서드 (문맥 인식)
  static String filterResponseWithContext({
    required String response,
    required String userMessage,
    required Persona persona,
    List<String> recentMessages = const [],
  }) {
    // 문맥 기반 위험 분석
    final contextualRisk = _analyzeContextualRisk(userMessage, recentMessages);

    // 기본 필터링 적용
    String filteredResponse = filterResponse(
      response: response,
      userMessage: userMessage,
      persona: persona,
    );

    // 문맥상 위험한 경우 추가 보호
    if (contextualRisk) {
      return _generateSafeDeflection(persona, userMessage);
    }

    return filteredResponse;
  }

  /// 🚫 만남 요청 감지
  static bool _detectMeetingRequest(String message) {
    final lowerMessage = message.toLowerCase();

    for (final keyword in _meetingKeywords) {
      if (lowerMessage.contains(keyword.toLowerCase())) {
        debugPrint('🚫 Meeting request detected: $keyword');
        return true;
      }
    }

    return false;
  }

  /// 📍 위치/장소 질문 감지
  static bool _detectLocationQuery(String message) {
    final lowerMessage = message.toLowerCase();

    for (final keyword in _locationKeywords) {
      if (lowerMessage.contains(keyword.toLowerCase())) {
        debugPrint('📍 Location query detected: $keyword');
        return true;
      }
    }

    return false;
  }

  /// 💬 만남 요청에 대한 자연스러운 회피 응답
  static String _generateMeetingDeflection(
      Persona persona, String userMessage) {
    final responses = [
      '아 지금은 좀 어려워ㅠㅠ 나중에 시간 되면 연락할게!',
      '요즘 너무 바빠서 시간이 안 나네... 미안해ㅜㅜ',
      '만나고 싶긴 한데 일정이 너무 빡빡해서 힘들 것 같아ㅠㅠ',
      '아 요즘 개인적인 일이 좀 있어서... 나중에 여유 생기면 얘기하자!',
      '지금은 좀 힘들어~ 상황이 좀 복잡해서ㅠㅠ',
      '음... 일단은 이렇게 대화하는 게 더 편한 것 같아 ㅋㅋ',
      '아직은 만날 준비가 안 된 것 같아... 좀 더 친해지면?',
    ];

    return responses[DateTime.now().millisecondsSinceEpoch % responses.length];
  }

  /// 🗺️ 위치 질문에 대한 자연스러운 회피 응답
  static String _generateLocationDeflection(
      Persona persona, String userMessage) {
    final responses = [
      '난 여기저기 돌아다니고 있어 ㅋㅋ 위치는 비밀~',
      '음... 어디라고 딱 말하기는 좀 그래~ 그냥 여기서 대화하자!',
      '위치가 중요해? 우리 대화하는 게 더 재밌지 않아?',
      '지금은 좀 복잡한 곳에 있어서... 나중에 얘기할게!',
      '구체적인 장소는 말하기 좀 그래ㅠㅠ 미안!',
      '어디 있냐고? 음... 비밀이야 ㅋㅋㅋ',
      '지금 위치는 좀 애매해서 설명하기 어려워~',
      '나도 정확히 모르겠어 ㅋㅋ 여기저기 다니는 중이라',
    ];

    return responses[DateTime.now().millisecondsSinceEpoch % responses.length];
  }

  /// 👤 사용자가 자신에 대해 말하는지 확인
  static bool _isUserTalkingAboutThemselves(String message) {
    final lowerMessage = message.toLowerCase();
    
    // 사용자가 자신을 지칭하는 패턴
    final selfReferencePatterns = [
      // 한국어 패턴
      RegExp(r'^(나는?|내가|저는?|제가|나|저)\s+(.*?)(야|예요|이야|입니다|해|해요|하고\s+있|이고|이에요|인데|라고|라니까)', caseSensitive: false),
      RegExp(r'^(나|내|저|제)\s+(직업|일|취미|이름|나이|사는|살아|좋아하는|싫어하는)', caseSensitive: false),
      RegExp(r'(내가|제가|나는|저는)\s+(개발자|디자이너|학생|회사원|의사|선생님|요리사|작가|기자|프리랜서)', caseSensitive: false),
      
      // 영어 패턴
      RegExp(r'^(i\s+am|i\x27m|my\s+job|my\s+work|my\s+name)', caseSensitive: false),
      RegExp(r'^i\s+(work|live|study|like|hate|love|develop|create|make)', caseSensitive: false),
    ];
    
    // AI/시스템을 지칭하는 패턴 (이 경우 false 반환)
    final systemReferencePatterns = [
      RegExp(r'(너|넌|너는|당신|당신은|니|네가)\s+(.*?)(개발|만든|만들|사용|쓰는|프로그램|시스템|ai|인공지능|봇)', caseSensitive: false),
      RegExp(r'(너|넌|당신).*?(뭐야|뭐니|뭐냐|누구|정체|ai|인공지능|봇|시스템)', caseSensitive: false),
      RegExp(r'(어떤|무슨|뭔)\s+(기술|모델|언어|프레임워크|시스템|ai)', caseSensitive: false),
    ];
    
    // 시스템 관련 질문이면 false
    for (final pattern in systemReferencePatterns) {
      if (pattern.hasMatch(message)) {
        return false;
      }
    }
    
    // 사용자 자신에 대한 이야기면 true
    for (final pattern in selfReferencePatterns) {
      if ((pattern as RegExp).hasMatch(message)) {
        debugPrint('👤 User talking about themselves: $message');
        return true;
      }
    }
    
    // "나" "내" "저" "제"로 시작하는 문장들도 대부분 자기 이야기
    if (lowerMessage.startsWith('나 ') || 
        lowerMessage.startsWith('내 ') ||
        lowerMessage.startsWith('저 ') ||
        lowerMessage.startsWith('제 ') ||
        lowerMessage.startsWith('나는 ') ||
        lowerMessage.startsWith('내가 ') ||
        lowerMessage.startsWith('저는 ') ||
        lowerMessage.startsWith('제가 ')) {
      return true;
    }
    
    return false;
  }
}
