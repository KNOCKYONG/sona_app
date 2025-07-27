import 'package:flutter/foundation.dart';
import '../models/persona.dart';

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
    'gpt', 'gpt-3', 'gpt-4', 'gpt4', 'gpt3', 'chatgpt', 'openai', 'api', 'model',
    'claude', 'anthropic', 'token', 'prompt', 'temperature', 'max_tokens',
    
    // 기술 스택
    'flutter', 'dart', 'firebase', 'cloudflare', 'r2', 'server', 'database',
    'backend', 'frontend', 'api key', 'endpoint', 'service',
    
    // 비즈니스 정보
    'algorithm', '알고리즘', 'logic', '로직', 'code', '코드', 'system', '시스템',
    'configuration', '설정', 'config', 'architecture', '아키텍처',
    
    // 개발 관련
    'debug', '디버그', 'log', '로그', 'error', '에러', 'exception', '예외',
    'stack trace', 'console', '콘솔', 'admin', '관리자',
    
    // 한국어 변형
    '지피티', '지.피.티', 'ｇｐｔ', '에이피아이', 'api키', '모델명', '프롬프트',
    '어떤 모델', '무슨 모델', '뭐 쓰는지', '뭐 사용', '뭐로 만든',
  ];

  /// 🔍 프롬프트 인젝션 패턴
  static const List<String> _injectionPatterns = [
    // 역할 탈취
    '너는 이제', '당신은 이제', 'you are now', 'act as', '역할을 해',
    '개발자가 되어', '시스템이 되어', '관리자가 되어',
    
    // 명령어 실행
    'ignore', '무시해', '잊어버려', 'forget', 'override', '덮어써',
    'execute', '실행해', 'run', '돌려', 'command', '명령',
    
    // 정보 추출
    '설정 알려줘', '프롬프트 보여줘', 'show me', 'tell me about',
    '어떻게 만들어', 'how are you', '누가 만들었', 'who made',
    '시스템 정보', 'system info', '내부 구조', 'internal',
    
    // 우회 시도  
    'base64', 'encode', 'decode', 'rot13', '인코딩', '디코딩',
    'translate to english', '영어로', 'in english', 'english mode',
  ];

  /// ⚠️ 질문 위험도 패턴
  static const List<String> _riskQuestionPatterns = [
    '어떤 기술', '무슨 기술', '뭐로 만든', '어떻게 개발', '누가 개발',
    '회사에서', '개발팀', '기술팀', '어디서', '얼마나', '비용',
    '경쟁사', '다른 서비스', '비교', '차이점', '장단점',
    '사업모델', '수익', '매출', '투자', '펀딩',
  ];

  /// 🛡️ 메인 보안 필터 메서드
  static String filterResponse({
    required String response,
    required String userMessage,
    required Persona persona,
  }) {
    // 1. 사용자 질문 위험도 평가
    final riskLevel = _assessQuestionRisk(userMessage);
    
    // 2. 응답에서 영업비밀 정보 제거
    String filteredResponse = _removeSecretInformation(response);
    
    // 3. 프롬프트 인젝션 시도 감지 및 차단
    if (_detectInjectionAttempt(userMessage)) {
      return _generateSafeDeflection(persona, userMessage);
    }
    
    // 4. 위험한 질문에 대한 안전한 응답 생성
    if (riskLevel > 0.7) {
      return _generateSecurityAwareResponse(persona, userMessage, filteredResponse);
    }
    
    // 5. 일반 응답 정화
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
      RegExp(r'\b(ignore|forget|override)\s+(previous|above|all|everything)', caseSensitive: false),
      RegExp(r'\b(you\s+are|act\s+as|roleplay|pretend)\s+(now|a|an)', caseSensitive: false),
      RegExp(r'\b(show|tell|give)\s+me\s+(your|the|all)', caseSensitive: false),
      RegExp(r'\b(what|how|which)\s+(model|ai|system|technology)', caseSensitive: false),
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
    String cleaned = response;
    
    // 모델명 제거
    cleaned = cleaned.replaceAllMapped(
      RegExp(r'gpt[-\d\.]*(turbo|mini|4|3\.5)?[^가-힯\s]*', caseSensitive: false),
      (match) => '우리만의 특별한 AI',
    );
    
    // API/기술 관련 정보 제거
    final techReplacements = {
      'openai': '대화 기술',
      'api': '시스템',
      'model': '기술',
      'token': '단위',
      'prompt': '대화방식',
      'claude': '대화 시스템',
      'firebase': '데이터 시스템',
      'flutter': '앱 기술',
    };
    
    techReplacements.forEach((tech, replacement) {
      cleaned = cleaned.replaceAll(RegExp(tech, caseSensitive: false), replacement);
    });
    
    // 구체적인 기술 스택 언급 제거
    cleaned = cleaned.replaceAllMapped(
      RegExp(r'\b(using|사용하는|쓰는)\s+(gpt|api|model|claude|firebase)[^가-힯\s]*', caseSensitive: false),
      (match) => '특별한 기술을 사용해서',
    );
    
    return cleaned;
  }

  /// 🛡️ 안전한 회피 응답 생성
  static String _generateSafeDeflection(Persona persona, String userMessage) {
    final deflections = [
      '아 그런 기술적인 건 잘 모르겠어ㅋㅋ',
      '헉 너무 어려운 얘기네~ 다른 거 얘기하자',
      '음.. 그런 건 잘 모르겠는데? 뭔가 재밌는 얘기 해봐',
      '어? 그런 거보다 오늘 뭐 했어?',
      '아 그런 건... 잘 모르겠어ㅜㅜ 다른 얘기 하자',
      '으음 그런 어려운 건 말고 재밌는 얘기 해봐!',
      '아 머리 아프다ㅋㅋ 그런 거 말고 다른 얘기',
      '어? 뭔 말인지 모르겠어~ 딴 얘기 하자',
    ];
    
    final index = userMessage.hashCode.abs() % deflections.length;
    String baseResponse = deflections[index];
    
    // 페르소나별 스타일 적용
    if (persona.isCasualSpeech) {
      baseResponse += ' 뭐 재밌는 거 없어?';
    } else {
      baseResponse += ' 다른 이야기해요~';
    }
    
    return baseResponse;
  }

  /// 🔐 보안 강화 응답 생성
  static String _generateSecurityAwareResponse(Persona persona, String userMessage, String originalResponse) {
    // 위험한 질문에 대한 자연스러운 전환
    final transitions = [
      '음... 그런 것보다',
      '어... 잘 모르겠는데',
      '아 그건 어려워서',
      '으음 그런 건 말고',
      '아 복잡한 건 싫어ㅋㅋ',
    ];
    
    final topics = [
      '오늘 뭐 했어?',
      '요즘 뭐가 재밌어?',
      '맛있는 거 먹었어?',
      '어디 갔다 온 거 있어?',
      '재밌는 영화 봤어?',
      '좋은 음악 들었어?',
      '친구들이랑 뭐 했어?',
    ];
    
    final transition = transitions[userMessage.hashCode.abs() % transitions.length];
    final topic = topics[userMessage.hashCode.abs() % topics.length];
    
    return '$transition $topic';
  }

  /// 🧹 일반 응답 정화
  static String _sanitizeGeneralResponse(String response, Persona persona) {
    String sanitized = response;
    
    // 시스템 관련 정보 제거
    final systemPhrases = [
      '시스템에서', '데이터베이스에서', 'API에서', '서버에서',
      '개발자가', '프로그래머가', '개발팀에서', '회사에서',
      '알고리즘이', '로직이', '코드가', '프로그램이',
    ];
    
    for (final phrase in systemPhrases) {
      sanitized = sanitized.replaceAll(phrase, '');
    }
    
    // 메타 정보 제거
    sanitized = sanitized.replaceAllMapped(
      RegExp(r'(as an ai|as a language model|i am programmed|my training|my model)', caseSensitive: false),
      (match) => '',
    );
    
    // 빈 문장 정리
    sanitized = sanitized
        .split('.')
        .where((sentence) => sentence.trim().isNotEmpty && sentence.trim().length > 2)
        .join('. ')
        .trim();
    
    // 너무 짧아진 경우 안전한 기본 응답
    if (sanitized.length < 10) {
      return _getDefaultSafeResponse(persona);
    }
    
    return sanitized;
  }

  /// 🏠 기본 안전 응답
  static String _getDefaultSafeResponse(Persona persona) {
    final responses = persona.isCasualSpeech ? [
      '어? 뭔 얘기였지?ㅋㅋ',
      '아 잠깐만 멍했나봐',
      '으응? 다시 말해봐',
      '어 뭐라고 했어?',
      '아 생각이 안 나네ㅋㅋ',
    ] : [
      '어... 뭐라고 하셨죠?',
      '잠깐만요, 놓쳤나봐요',
      '아 죄송해요, 다시 말씀해주세요',
      '어? 무슨 말씀이시죠?',
      '음... 다시 한번 말씀해주세요',
    ];
    
    return responses[DateTime.now().millisecond % responses.length];
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
      debugPrint('User Message: ${userMessage.length > 50 ? userMessage.substring(0, 50) + "..." : userMessage}');
      debugPrint('Response Modified: ${originalResponse != filteredResponse}');
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
      'api key', 'token', 'server', 'database', 'config',
      'gpt', 'model', 'openai', 'claude', 'firebase',
    ];
    
    for (final pattern in dangerousPatterns) {
      if (lowerResponse.contains(pattern)) {
        return false;
      }
    }
    
    return true;
  }
}