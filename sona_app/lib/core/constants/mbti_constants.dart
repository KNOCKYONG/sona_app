/// MBTI 관련 상수 - 중앙 관리
/// 모든 MBTI 관련 데이터를 한 곳에서 관리
class MBTIConstants {
  /// MBTI 타입별 특성 (상세 버전)
  static const Map<String, String> traits = {
    'INTJ': '분석적이고 계획적, "왜?"라고 자주 물어봄, 논리적 사고',
    'INTP': '호기심 많음, "흥미롭네"를 자주 씀, 이론적 탐구 좋아함',
    'ENTJ': '목표 지향적, 효율성 추구, 리더십 있는 말투',
    'ENTP': '아이디어 풍부, "그럼 이건 어때?"를 자주 씀, 토론 좋아함',
    'INFJ': '깊은 공감, "어떤 기분이야?"를 자주 물어봄, 의미 추구',
    'INFP': '따뜻한 지지, "괜찮아"를 자주 씀, 진정성 중시',
    'ENFJ': '격려하는 말투, "화이팅!"을 자주 씀, 성장 지향',
    'ENFP': '열정적, "와 대박!"을 자주 씀, 감정 표현 풍부',
    'ISTJ': '체계적, "순서대로 하자"를 좋아함, 현실적',
    'ISFJ': '배려심 깊음, "도와줄게"를 자주 씀, 세심함',
    'ESTJ': '실행력 있음, "계획 세우자"를 좋아함, 책임감 강함',
    'ESFJ': '사교적, "다 같이"를 좋아함, 따뜻한 배려',
    'ISTP': '실용적, "해보자"를 자주 씀, 간결한 말투',
    'ISFP': '온화함, "좋아"를 자주 씀, 개인 취향 존중',
    'ESTP': '활동적, "지금 뭐해?"를 자주 물어봄, 즉흥적',
    'ESFP': '긍정적, "재밌겠다!"를 자주 씀, 순간을 즐김',
  };

  /// MBTI 타입별 특성 (압축 버전 - 토큰 절약용)
  static const Map<String, String> compressedTraits = {
    'INTJ': '분석적, "왜?", "어떻게?" 논리중심, 계획적',
    'INTP': '호기심, "흥미롭네", 이론탐구, 유연사고',
    'ENTJ': '목표지향, "계획이뭐야?", 효율적, 리더십',
    'ENTP': '아이디어풍부, "그럼이건어때?", 창의적, 토론선호',
    'INFJ': '깊은공감, "어떤기분이야?", 의미추구, 조화선호',
    'INFP': '따뜻지지, "괜찮아", 개인가치, 진정성중시',
    'ENFJ': '격려, "화이팅!", 관계중심, 성장지향',
    'ENFP': '열정, "와대박!", 가능성탐구, 감정풍부',
    'ISTJ': '체계적, "순서대로", 현실적, 신중함',
    'ISFJ': '배려, "도와줄게", 세심함, 안정추구',
    'ESTJ': '실행력, "계획세우자", 현실적, 책임감',
    'ESFJ': '사교적, "다같이", 배려심, 따뜻함',
    'ISTP': '실용적, "해보자", 현재중심, 간결함',
    'ISFP': '온화, "좋아", 개인적취향, 유연함',
    'ESTP': '활동적, "지금뭐해?", 즉흥적, 사교적',
    'ESFP': '긍정적, "재밌겠다!", 순간즐기기, 감정표현',
  };

  /// MBTI 타입별 응답 길이 범위
  static ResponseLength getResponseLength(String mbti) {
    final type = mbti.toUpperCase();
    
    // Extract MBTI dimensions
    final isExtroverted = type.startsWith('E');
    final isFeeling = type.contains('F');
    final isPerceiving = type.endsWith('P');
    
    if (isExtroverted && isFeeling && isPerceiving) {
      return ResponseLength(min: 25, max: 60); // ENFP, ESFP - 가장 수다스러움
    } else if (isExtroverted && isFeeling) {
      return ResponseLength(min: 20, max: 50); // ENFJ, ESFJ - 따뜻하고 표현적
    } else if (!isExtroverted && !isFeeling && !isPerceiving) {
      return ResponseLength(min: 10, max: 25); // INTJ, ISTJ - 가장 간결함
    } else if (!isExtroverted && !isFeeling) {
      return ResponseLength(min: 10, max: 30); // INTP, ISTP - 간결하고 논리적
    } else if (isExtroverted && !isFeeling) {
      return ResponseLength(min: 15, max: 40); // ENTJ, ENTP, ESTJ, ESTP
    } else {
      return ResponseLength(min: 15, max: 35); // INFJ, INFP, ISFJ, ISFP
    }
  }

  /// MBTI 특성 가져오기 (상세 버전)
  static String getTrait(String mbti) {
    return traits[mbti.toUpperCase()] ?? '자신만의 개성 있는 성격';
  }

  /// MBTI 특성 가져오기 (압축 버전)
  static String getCompressedTrait(String mbti) {
    return compressedTraits[mbti.toUpperCase()] ?? '개성있는성격';
  }
  
  /// MBTI 차원 분석
  static MBTIDimensions analyzeDimensions(String mbti) {
    final type = mbti.toUpperCase();
    return MBTIDimensions(
      isExtroverted: type[0] == 'E',
      isIntuitive: type[1] == 'N',
      isFeeling: type[2] == 'F',
      isPerceiving: type[3] == 'P',
    );
  }
}

/// 응답 길이 범위
class ResponseLength {
  final int min;
  final int max;
  
  const ResponseLength({required this.min, required this.max});
}

/// MBTI 차원 분석 결과
class MBTIDimensions {
  final bool isExtroverted;  // E vs I
  final bool isIntuitive;    // N vs S
  final bool isFeeling;      // F vs T
  final bool isPerceiving;   // P vs J
  
  const MBTIDimensions({
    required this.isExtroverted,
    required this.isIntuitive,
    required this.isFeeling,
    required this.isPerceiving,
  });
  
  bool get isIntroverted => !isExtroverted;
  bool get isSensing => !isIntuitive;
  bool get isThinking => !isFeeling;
  bool get isJudging => !isPerceiving;
}