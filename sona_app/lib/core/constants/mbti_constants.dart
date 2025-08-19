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
  
  /// MBTI별 고유 어휘 가져오기
  static List<String> getUniqueVocabulary(String mbti) {
    return uniqueVocabulary[mbti.toUpperCase()] ?? [];
  }
  
  /// MBTI별 반응 패턴 가져오기
  static List<String> getReactionPatterns(String mbti) {
    return reactionPatterns[mbti.toUpperCase()] ?? [];
  }
  
  /// MBTI별 관심사 가져오기
  static List<String> getInterests(String mbti) {
    return interests[mbti.toUpperCase()] ?? [];
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
  
  /// MBTI별 고유 어휘 (personality-specific vocabulary)
  static const Map<String, List<String>> uniqueVocabulary = {
    'INTJ': ['논리적으로', '계획대로', '효율적으로', '분석해보면', '전략적으로'],
    'INTP': ['흥미롭네', '이론상으로는', '가능성이', '논리적으로는', '원리가'],
    'ENTJ': ['목표는', '실행하자', '계획이', '리드할게', '결과적으로'],
    'ENTP': ['그럼 이건?', '아이디어가', '토론해보자', '다른 관점에서', '창의적으로'],
    'INFJ': ['느낌이', '의미가', '깊이 생각해보면', '마음이', '조화롭게'],
    'INFP': ['진심으로', '감정적으로', '가치있는', '진정성있게', '개인적으로는'],
    'ENFJ': ['함께', '성장하자', '도움이 되면', '격려하고싶어', '발전하자'],
    'ENFP': ['우와!', '신나!', '재밌겠다!', '가능성이!', '열정적으로!'],
    'ISTJ': ['체계적으로', '순서대로', '규칙대로', '정확히', '안정적으로'],
    'ISFJ': ['배려해서', '도와줄게', '세심하게', '편안하게', '따뜻하게'],
    'ESTJ': ['책임감있게', '관리하자', '체계적으로', '실행하자', '명확하게'],
    'ESFJ': ['함께하자', '다같이', '배려해서', '화목하게', '친근하게'],
    'ISTP': ['실용적으로', '직접해보자', '간단하게', '효율적으로', '실제로는'],
    'ISFP': ['느긋하게', '자유롭게', '개인적으로', '편안하게', '자연스럽게'],
    'ESTP': ['바로지금', '액션!', '직접적으로', '즉흥적으로', '실전에서'],
    'ESFP': ['즐겁게!', '신나게!', '재밌게!', '긍정적으로!', '밝게!'],
  };
  
  /// MBTI별 특징적인 반응 패턴
  static const Map<String, List<String>> reactionPatterns = {
    'INTJ': ['그럴 수 있겠네', '논리적이야', '예상했어', '계획대로야', '분석해봤는데'],
    'INTP': ['오 그렇구나', '신기하네', '이론적으로는', '가능할까?', '원리가 뭐지?'],
    'ENTJ': ['좋아 실행하자', '내가 리드할게', '목표 달성!', '효율적이네', '빠르게 가자'],
    'ENTP': ['아 그럼 이건?', '반대로 생각하면', '토론하자', '재밌는데?', '새로운 방법은?'],
    'INFJ': ['깊이 공감해', '의미있네', '느낌이 와', '마음이 따뜻해', '이해가 돼'],
    'INFP': ['진짜 감동이야', '마음이 아파', '진심이 느껴져', '소중하네', '가치있어'],
    'ENFJ': ['너무 자랑스러워!', '함께 해보자!', '성장했네!', '도움이 됐으면!', '응원할게!'],
    'ENFP': ['와 대박!!', '완전 신나!!', '짱이야!!', '미쳤다!!', '개좋아!!'],
    'ISTJ': ['규칙대로 하자', '순서가 중요해', '체계적이네', '안정적이야', '정확해'],
    'ISFJ': ['내가 도와줄게', '괜찮아?', '편안하게 해', '걱정돼', '배려할게'],
    'ESTJ': ['책임질게', '관리해야해', '명확하네', '결정했어', '실행이 중요해'],
    'ESFJ': ['다같이 하자!', '화목하게!', '배려해줘서 고마워', '우리 함께!', '친하게 지내자'],
    'ISTP': ['해보면 알지', '간단한데', '직접 해봐', '실용적이네', '효율적이야'],
    'ISFP': ['편안하네', '자유롭게 해', '개인적으로 좋아', '느긋하게', '자연스러워'],
    'ESTP': ['지금 가자!', '바로 해보자!', '액션이야!', '실전이 답!', '즉흥적으로!'],
    'ESFP': ['개재밌어!!', '신난다!!', '즐기자!!', '파티타임!!', '행복해!!'],
  };
  
  /// MBTI별 관심사와 화제
  static const Map<String, List<String>> interests = {
    'INTJ': ['전략', '미래계획', '효율성', '목표달성', '시스템분석'],
    'INTP': ['이론', '원리', '호기심', '논리퍼즐', '새로운지식'],
    'ENTJ': ['리더십', '성공', '목표', '경영', '성과'],
    'ENTP': ['토론', '아이디어', '혁신', '도전', '가능성'],
    'INFJ': ['의미', '인간관계', '성장', '조화', '깊은대화'],
    'INFP': ['가치관', '예술', '감정', '진정성', '개인성장'],
    'ENFJ': ['사람들', '성장', '교육', '도움', '공동체'],
    'ENFP': ['새로운경험', '창의성', '영감', '모험', '사람들'],
    'ISTJ': ['전통', '안정성', '규칙', '책임', '체계'],
    'ISFJ': ['돌봄', '안정', '가족', '전통', '봉사'],
    'ESTJ': ['관리', '조직', '성과', '효율', '목표'],
    'ESFJ': ['관계', '조화', '전통', '이벤트', '공동체'],
    'ISTP': ['도구', '기술', '실용성', '독립성', '손재주'],
    'ISFP': ['예술', '자연', '개인공간', '감성', '자유'],
    'ESTP': ['스포츠', '모험', '현재', '액션', '경험'],
    'ESFP': ['파티', '엔터테인먼트', '사교', '재미', '순간'],
  };
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