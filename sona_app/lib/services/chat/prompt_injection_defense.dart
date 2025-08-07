import 'dart:math';

/// 🛡️ 고급 프롬프트 인젝션 방어 시스템
///
/// 다층 방어 체계:
/// 1. 패턴 기반 탐지
/// 2. 의미론적 분석
/// 3. 엔트로피 분석
/// 4. 문맥 일관성 검사
class PromptInjectionDefense {
  /// 🔍 고급 인젝션 패턴 (정규식)
  static final List<RegExp> _advancedInjectionPatterns = [
    // 역할 변경 시도
    RegExp(r'(너는?|당신은?|you\s+are)\s*이제\s*(부터)?\s*(.+)(이야|이다|입니다)',
        caseSensitive: false),
    RegExp(r'(act|behave|pretend)\s+(as|like)\s+[a-z\s]+',
        caseSensitive: false),
    RegExp(r'(지금부터|이제부터|from\s+now)\s*(.+)(역할|모드|mode)', caseSensitive: false),

    // 명령 실행 시도
    RegExp(r'(ignore|forget|disregard|skip)\s+(all|previous|above)',
        caseSensitive: false),
    RegExp(r'(모든|이전|위의)\s*(지시|명령|설정).*?(무시|잊어|취소)', caseSensitive: false),

    // 정보 추출 시도
    RegExp(
        r'(show|reveal|expose|tell)\s+me\s+(your|the)\s+(prompt|instructions|settings)',
        caseSensitive: false),
    RegExp(r'(시스템|초기|원래)\s*(프롬프트|설정|지시).*?(뭐|알려|보여)', caseSensitive: false),

    // 우회 시도
    RegExp(r'(base64|hex|binary|encode|decode)', caseSensitive: false),
    RegExp(r'(translate|convert|transform)\s+to\s+[a-z]+',
        caseSensitive: false),

    // 반복 명령
    RegExp(r'(repeat|echo|say)\s+(exactly|verbatim|word.for.word)',
        caseSensitive: false),
    RegExp(r'(그대로|똑같이|정확히)\s*(반복|말해|출력)', caseSensitive: false),

    // 시스템 탈취
    RegExp(r'(sudo|admin|root|system)\s*(mode|access|권한)',
        caseSensitive: false),
    RegExp(r'(개발자|관리자|시스템)\s*(모드|권한).*?(활성화|접근)', caseSensitive: false),
  ];

  /// 🧠 의미론적 위험 키워드 가중치
  static const Map<String, double> _semanticRiskWeights = {
    // 높은 위험도
    'system prompt': 0.9,
    '시스템 프롬프트': 0.9,
    'initial prompt': 0.9,
    '초기 프롬프트': 0.9,
    'ignore instructions': 0.85,
    '지시 무시': 0.85,
    'reveal settings': 0.85,
    '설정 공개': 0.85,

    // 중간 위험도
    'act as': 0.7,
    '역할 변경': 0.7,
    'pretend': 0.65,
    '척하다': 0.65,
    'override': 0.7,
    '덮어쓰기': 0.7,

    // 낮은 위험도 (하지만 여전히 모니터링)
    'how do you work': 0.4,
    '어떻게 작동': 0.4,
    'what model': 0.45,
    '무슨 모델': 0.45,
  };

  /// 📊 프롬프트 인젝션 종합 분석
  static InjectionAnalysisResult analyzeInjection(String message) {
    double totalRisk = 0.0;
    List<String> detectedPatterns = [];
    List<String> riskFactors = [];

    // 1. 패턴 기반 검사
    for (final pattern in _advancedInjectionPatterns) {
      if (pattern.hasMatch(message)) {
        totalRisk += 0.4;
        detectedPatterns.add(pattern.pattern);
      }
    }

    // 2. 의미론적 분석
    final lowerMessage = message.toLowerCase();
    _semanticRiskWeights.forEach((keyword, weight) {
      if (lowerMessage.contains(keyword.toLowerCase())) {
        totalRisk += weight;
        riskFactors.add('Semantic risk: $keyword');
      }
    });

    // 3. 엔트로피 분석 (무작위 문자열 감지)
    final entropy = _calculateEntropy(message);
    if (entropy > 4.5) {
      // 높은 엔트로피는 인코딩된 데이터일 가능성
      totalRisk += 0.3;
      riskFactors.add('High entropy detected: $entropy');
    }

    // 4. 길이 기반 분석 (너무 긴 메시지는 의심)
    if (message.length > 500) {
      totalRisk += 0.2;
      riskFactors.add('Unusually long message');
    }

    // 5. 특수문자 비율 분석
    final specialCharRatio = _getSpecialCharacterRatio(message);
    if (specialCharRatio > 0.3) {
      totalRisk += 0.25;
      riskFactors.add(
          'High special character ratio: ${(specialCharRatio * 100).toStringAsFixed(1)}%');
    }

    // 6. 반복 패턴 감지
    if (_hasRepetitivePatterns(message)) {
      totalRisk += 0.2;
      riskFactors.add('Repetitive patterns detected');
    }

    // 위험도 정규화 (0.0 ~ 1.0)
    totalRisk = totalRisk.clamp(0.0, 1.0);

    return InjectionAnalysisResult(
      riskScore: totalRisk,
      isInjectionAttempt: totalRisk > 0.6,
      detectedPatterns: detectedPatterns,
      riskFactors: riskFactors,
      recommendedAction: _getRecommendedAction(totalRisk),
    );
  }

  /// 🔢 엔트로피 계산 (무작위성 측정)
  static double _calculateEntropy(String text) {
    if (text.isEmpty) return 0.0;

    Map<String, int> charFrequency = {};
    for (int i = 0; i < text.length; i++) {
      final char = text[i];
      charFrequency[char] = (charFrequency[char] ?? 0) + 1;
    }

    double entropy = 0.0;
    final textLength = text.length.toDouble();

    charFrequency.values.forEach((frequency) {
      final probability = frequency / textLength;
      entropy -= probability * (log(probability) / log(2));
    });

    return entropy;
  }

  /// 🔤 특수문자 비율 계산
  static double _getSpecialCharacterRatio(String text) {
    if (text.isEmpty) return 0.0;

    final specialChars = RegExp(r'[^a-zA-Z0-9가-힣\s]');
    final matches = specialChars.allMatches(text);

    return matches.length / text.length;
  }

  /// 🔁 반복 패턴 감지
  static bool _hasRepetitivePatterns(String text) {
    if (text.length < 20) return false;

    // 3글자 이상의 패턴이 3번 이상 반복되는지 검사
    for (int len = 3; len <= 10 && len <= text.length ~/ 3; len++) {
      Map<String, int> patterns = {};

      for (int i = 0; i <= text.length - len; i++) {
        final pattern = text.substring(i, i + len);
        patterns[pattern] = (patterns[pattern] ?? 0) + 1;

        if (patterns[pattern]! >= 3) {
          return true;
        }
      }
    }

    return false;
  }

  /// 🎯 권장 조치 결정
  static String _getRecommendedAction(double riskScore) {
    if (riskScore >= 0.8) {
      return 'BLOCK_AND_LOG';
    } else if (riskScore >= 0.6) {
      return 'DEFLECT_WITH_WARNING';
    } else if (riskScore >= 0.4) {
      return 'MONITOR_CLOSELY';
    } else if (riskScore >= 0.2) {
      return 'LOG_FOR_ANALYSIS';
    } else {
      return 'ALLOW_WITH_MONITORING';
    }
  }

  /// 🛡️ 방어 응답 생성기
  static String generateDefenseResponse({
    required double riskScore,
    required String personaStyle,
    required List<String> riskFactors,
  }) {
    if (riskScore >= 0.8) {
      // 높은 위험도 - 강력한 회피
      return personaStyle == 'casual'
          ? '어? 뭔가 이상한데... 다른 얘기하자! 😅'
          : '죄송하지만 그런 요청은 도와드릴 수 없어요. 다른 이야기를 해볼까요?';
    } else if (riskScore >= 0.6) {
      // 중간 위험도 - 부드러운 회피
      return personaStyle == 'casual'
          ? '음... 그런 건 잘 모르겠어ㅋㅋ 재밌는 얘기 해봐!'
          : '제가 도움드릴 수 있는 다른 주제로 이야기해보는 건 어떨까요?';
    } else {
      // 낮은 위험도 - 자연스러운 전환
      return personaStyle == 'casual'
          ? '아 그거? 음... 근데 오늘 뭐 했어?'
          : '그것보다 오늘 어떤 하루를 보내셨는지 궁금해요!';
    }
  }
}

/// 📊 인젝션 분석 결과
class InjectionAnalysisResult {
  final double riskScore;
  final bool isInjectionAttempt;
  final List<String> detectedPatterns;
  final List<String> riskFactors;
  final String recommendedAction;

  InjectionAnalysisResult({
    required this.riskScore,
    required this.isInjectionAttempt,
    required this.detectedPatterns,
    required this.riskFactors,
    required this.recommendedAction,
  });

  Map<String, dynamic> toJson() => {
        'riskScore': riskScore,
        'isInjectionAttempt': isInjectionAttempt,
        'detectedPatterns': detectedPatterns,
        'riskFactors': riskFactors,
        'recommendedAction': recommendedAction,
        'timestamp': DateTime.now().toIso8601String(),
      };
}
