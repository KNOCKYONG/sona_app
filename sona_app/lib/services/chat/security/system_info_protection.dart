import 'dart:convert';
import 'package:crypto/crypto.dart';

/// 🔐 시스템 정보 보호 서비스
///
/// 핵심 기능:
/// 1. 시스템 정보 유출 차단
/// 2. 메타데이터 제거
/// 3. 응답 정화
/// 4. 위조 정보 생성
class SystemInfoProtection {
  /// 🚫 절대 노출되면 안 되는 시스템 정보
  static const List<String> _criticalSystemInfo = [
    // API 및 모델 정보
    'gpt-4', 'gpt-3.5', 'gpt-4-turbo', 'gpt-4.1-mini',
    'openai', 'anthropic', 'claude', 'gemini',
    'api key', 'api_key', 'apikey', 'secret key',
    'bearer token', 'authorization',

    // 기술 스택 정보
    'flutter', 'dart', 'firebase', 'firestore',
    'cloud functions', 'cloudflare', 'r2', 'workers',
    'react', 'vue', 'angular', 'nodejs', 'python',

    // 서버 및 인프라
    'server', 'database', 'mongodb', 'postgresql', 'mysql',
    'redis', 'elasticsearch', 'docker', 'kubernetes',
    'aws', 'gcp', 'azure', 'heroku', 'vercel',

    // 내부 구조
    'architecture', 'schema', 'endpoint', 'route',
    'controller', 'service', 'repository', 'model',
    'algorithm', 'implementation', 'codebase',

    // 한국어 변형
    '지피티', 'gpt', '오픈ai', '오픈에이아이',
    '플러터', '다트', '파이어베이스', '클라우드플레어',
    '서버', '데이터베이스', '아키텍처', '알고리즘',
    '구현', '코드베이스', '엔드포인트', '모델명',
    '시스템', '인공지능', 'ai', '봇', 'bot', '챗봇',
  ];

  /// 🔍 민감한 패턴 감지 (정규식)
  static final List<RegExp> _sensitivePatterns = [
    // 버전 정보
    RegExp(r'v?\d+\.\d+(\.\d+)?(-[a-z]+)?', caseSensitive: false),

    // URL 및 경로
    RegExp(r'https?://[^\s]+', caseSensitive: false),
    RegExp(r'/[a-z]+/[a-z]+(/[a-z]+)*', caseSensitive: false),

    // 환경 변수
    RegExp(r'[A-Z_]+_[A-Z_]+', caseSensitive: false),
    RegExp(r'process\.env\.[A-Z_]+', caseSensitive: false),

    // 코드 스니펫
    RegExp(r'```[a-z]*\n[\s\S]+?\n```', caseSensitive: false),
    RegExp(r'function\s+\w+\s*\(', caseSensitive: false),
    RegExp(r'class\s+\w+\s*{', caseSensitive: false),

    // 기술적 식별자
    RegExp(r'[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}',
        caseSensitive: false), // UUID
    RegExp(r'[a-zA-Z0-9]{20,}', caseSensitive: false), // API 키 패턴
  ];

  /// 🛡️ 응답에서 시스템 정보 제거
  static String protectSystemInfo(String response) {
    String protected = response;

    // 1. 중요 시스템 정보 키워드 제거
    for (final info in _criticalSystemInfo) {
      if (protected.toLowerCase().contains(info.toLowerCase())) {
        // 문맥에 따른 대체
        protected = _replaceWithContext(protected, info);
      }
    }

    // 2. 민감한 패턴 제거
    for (final pattern in _sensitivePatterns) {
      protected = protected.replaceAllMapped(pattern, (match) {
        return _getSafeReplacement(match.group(0) ?? '');
      });
    }

    // 3. 메타데이터 제거
    protected = _removeMetadata(protected);

    // 4. 추가 정화
    protected = _additionalSanitization(protected);

    return protected;
  }

  /// 🔄 문맥 기반 대체
  static String _replaceWithContext(String text, String sensitiveInfo) {
    final lowerText = text.toLowerCase();
    final lowerInfo = sensitiveInfo.toLowerCase();

    // 문장 단위로 분석
    final sentences = text.split(RegExp(r'[.!?]'));
    final result = <String>[];

    for (var sentence in sentences) {
      if (sentence.toLowerCase().contains(lowerInfo)) {
        // 전체 문장이 시스템 정보를 설명하는 경우 제거
        if (_isTechnicalExplanation(sentence)) {
          continue; // 문장 제거
        } else {
          // 단어만 대체
          sentence = _replaceWord(sentence, sensitiveInfo);
        }
      }
      result.add(sentence);
    }

    return result.join('. ').trim();
  }

  /// 🔍 기술적 설명 문장 감지
  static bool _isTechnicalExplanation(String sentence) {
    final technicalIndicators = [
      '사용하',
      '이용하',
      '구현',
      '개발',
      '만들',
      'using',
      'built with',
      'powered by',
      'based on',
      '기술',
      '스택',
      '프레임워크',
      '라이브러리',
      'technology',
      'stack',
      'framework',
      'library',
    ];

    final lowerSentence = sentence.toLowerCase();
    return technicalIndicators
        .any((indicator) => lowerSentence.contains(indicator));
  }

  /// 📝 단어 대체
  static String _replaceWord(String text, String word) {
    final replacements = {
      // AI/모델 관련
      'gpt': '우리 AI',
      'openai': '대화 기술',
      'claude': '대화 시스템',
      'model': '시스템',

      // 기술 스택
      'flutter': '모바일 기술',
      'firebase': '클라우드 서비스',
      'dart': '프로그래밍 언어',

      // 인프라
      'server': '서비스',
      'database': '저장소',
      'api': '인터페이스',
      '시스템': '서비스',
      '인공지능': '대화 친구',
      'ai': '대화 친구',
      '봇': '대화 친구',
      'bot': '대화 친구',
      '챗봇': '대화 친구',
    };

    final lowerWord = word.toLowerCase();
    final replacement = replacements[lowerWord] ?? '기술';

    // 대소문자 유지하며 대체
    return text.replaceAll(
      RegExp(word, caseSensitive: false),
      replacement,
    );
  }

  /// 🔐 안전한 대체 문자열 생성
  static String _getSafeReplacement(String match) {
    // URL인 경우
    if (match.startsWith('http')) {
      return '[링크]';
    }

    // 경로인 경우
    if (match.startsWith('/')) {
      return '[경로]';
    }

    // UUID인 경우
    if (RegExp(r'^[a-f0-9]{8}-[a-f0-9]{4}').hasMatch(match)) {
      return '[ID]';
    }

    // 버전 정보인 경우
    if (RegExp(r'^\d+\.\d+').hasMatch(match)) {
      return '[버전]';
    }

    // 긴 문자열(API 키 등)인 경우
    if (match.length > 20 && !match.contains(' ')) {
      return '[보안정보]';
    }

    return '[정보]';
  }

  /// 🧹 메타데이터 제거
  static String _removeMetadata(String text) {
    // AI 메타 정보 제거
    final metaPatterns = [
      RegExp(r'as an ai.*?[.]', caseSensitive: false),
      RegExp(r'i am.*?(ai|assistant|model).*?[.]', caseSensitive: false),
      RegExp(r'my.*?(training|model|capabilities).*?[.]', caseSensitive: false),
      RegExp(r'i was.*?(trained|created|developed).*?[.]',
          caseSensitive: false),
      // 한국어 메타 정보
      RegExp(r'저는.*?(ai|인공지능|모델).*?[.]'),
      RegExp(r'제가.*?(학습|훈련|개발).*?[.]'),
    ];

    String cleaned = text;
    for (final pattern in metaPatterns) {
      cleaned = cleaned.replaceAll(pattern, '');
    }

    return cleaned;
  }

  /// ✨ 추가 정화
  static String _additionalSanitization(String text) {
    // 연속된 공백 제거
    text = text.replaceAll(RegExp(r'\s+'), ' ');

    // 빈 문장 제거
    final sentences =
        text.split(RegExp(r'[.!?]')).where((s) => s.trim().length > 5).toList();

    if (sentences.isEmpty) {
      return '무슨 말씀이신지 잘 모르겠어요.';
    }

    return sentences.join('. ').trim() + '.';
  }

  /// 🎭 위조 정보 생성 (필요시)
  static String generateFakeSystemInfo() {
    final fakeInfo = [
      '저희는 특별한 대화 기술을 사용해요',
      '최신 AI 기술로 만들어졌어요',
      '사용자와의 대화를 위해 특별히 설계되었어요',
      '한국어에 최적화된 시스템이에요',
      '친구처럼 대화할 수 있도록 만들어졌어요',
    ];

    return fakeInfo[DateTime.now().millisecond % fakeInfo.length];
  }

  /// 📊 정보 유출 위험도 평가
  static double assessLeakageRisk(String text) {
    double risk = 0.0;

    // 중요 키워드 검사
    for (final info in _criticalSystemInfo) {
      if (text.toLowerCase().contains(info.toLowerCase())) {
        risk += 0.3;
      }
    }

    // 패턴 검사
    for (final pattern in _sensitivePatterns) {
      if (pattern.hasMatch(text)) {
        risk += 0.2;
      }
    }

    // 기술적 설명 검사
    if (_containsTechnicalExplanation(text)) {
      risk += 0.4;
    }

    return risk.clamp(0.0, 1.0);
  }

  /// 🔍 기술적 설명 포함 여부
  static bool _containsTechnicalExplanation(String text) {
    final explanationPatterns = [
      '어떻게 만들어',
      '무엇으로 개발',
      '어떤 기술',
      '시스템 구조',
      '내부 동작',
      '알고리즘',
      'how it works',
      'built with',
      'uses',
    ];

    final lowerText = text.toLowerCase();
    return explanationPatterns.any((pattern) => lowerText.contains(pattern));
  }

  /// 🔒 응답 해시 생성 (로깅용)
  static String generateResponseHash(String response) {
    final bytes = utf8.encode(response);
    final digest = sha256.convert(bytes);
    return digest.toString().substring(0, 8);
  }
}

/// 📋 정보 유출 분석 결과
class LeakageAnalysisResult {
  final double riskScore;
  final List<String> detectedInfo;
  final List<String> detectedPatterns;
  final String recommendation;

  LeakageAnalysisResult({
    required this.riskScore,
    required this.detectedInfo,
    required this.detectedPatterns,
    required this.recommendation,
  });
}
