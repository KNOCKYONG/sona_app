import 'dart:math';

/// 마일스톤을 자연스러운 대화로 표현하는 서비스
class MilestoneExpressionService {
  static final _random = Random();
  
  /// 관계 점수를 자연스러운 대화 힌트로 변환
  static String? generateNaturalExpression({
    required int score,
    required String personaName,
    required String userMessage,
    required String aiResponse,
    bool isCasualSpeech = true,
  }) {
    // 마일스톤에 도달했는지 확인
    final milestone = _getMilestoneForScore(score);
    if (milestone == null) return null;
    
    // 대화 맥락에 따라 자연스러운 표현 선택
    return _selectNaturalExpression(
      milestone: milestone,
      personaName: personaName,
      userMessage: userMessage,
      isCasualSpeech: isCasualSpeech,
    );
  }
  
  /// 점수에 해당하는 마일스톤 확인
  static _MilestoneLevel? _getMilestoneForScore(int score) {
    switch (score) {
      case 100:
        return _MilestoneLevel.firstOpen;
      case 200:
        return _MilestoneLevel.gettingCloser;
      case 300:
        return _MilestoneLevel.comfortableFriend;
      case 500:
        return _MilestoneLevel.specialRelation;
      case 700:
        return _MilestoneLevel.deepUnderstanding;
      case 900:
        return _MilestoneLevel.wantTogether;
      case 1000:
        return _MilestoneLevel.soulmate;
      default:
        return null;
    }
  }
  
  /// 자연스러운 표현 선택
  static String? _selectNaturalExpression({
    required _MilestoneLevel milestone,
    required String personaName,
    required String userMessage,
    required bool isCasualSpeech,
  }) {
    // 사용자 메시지 맥락 분석
    final isEmotional = _isEmotionalContext(userMessage);
    final isPersonal = _isPersonalContext(userMessage);
    final isCasual = _isCasualContext(userMessage);
    
    // 마일스톤별 자연스러운 표현 매핑
    switch (milestone) {
      case _MilestoneLevel.firstOpen:
        return _getFirstOpenExpression(isEmotional, isPersonal, isCasualSpeech);
      
      case _MilestoneLevel.gettingCloser:
        return _getGettingCloserExpression(isEmotional, isPersonal, isCasualSpeech);
      
      case _MilestoneLevel.comfortableFriend:
        return _getComfortableFriendExpression(isEmotional, isPersonal, isCasualSpeech);
      
      case _MilestoneLevel.specialRelation:
        return _getSpecialRelationExpression(isEmotional, isPersonal, isCasualSpeech);
      
      case _MilestoneLevel.deepUnderstanding:
        return _getDeepUnderstandingExpression(isEmotional, isPersonal, isCasualSpeech);
      
      case _MilestoneLevel.wantTogether:
        return _getWantTogetherExpression(isEmotional, isPersonal, isCasualSpeech);
      
      case _MilestoneLevel.soulmate:
        return _getSoulmateExpression(isEmotional, isPersonal, isCasualSpeech);
    }
  }
  
  /// 감정적 맥락 확인
  static bool _isEmotionalContext(String message) {
    final emotionalKeywords = [
      '기분', '감정', '행복', '슬프', '좋아', '사랑', '외로',
      '우울', '신나', '설레', '그리워', '보고싶'
    ];
    return emotionalKeywords.any((keyword) => message.contains(keyword));
  }
  
  /// 개인적 맥락 확인
  static bool _isPersonalContext(String message) {
    final personalKeywords = [
      '나', '너', '우리', '내가', '네가', '나는', '너는',
      '생각', '느낌', '마음', '진짜', '정말'
    ];
    return personalKeywords.any((keyword) => message.contains(keyword));
  }
  
  /// 캐주얼한 맥락 확인
  static bool _isCasualContext(String message) {
    final casualIndicators = ['ㅋㅋ', 'ㅎㅎ', '~', '!!', '??'];
    return casualIndicators.any((indicator) => message.contains(indicator));
  }
  
  /// 처음 마음이 열림 (100점)
  static String? _getFirstOpenExpression(bool isEmotional, bool isPersonal, bool isCasual) {
    final expressions = [
      if (isEmotional && isCasual) ...[
        '너랑 얘기하니까 편해지는 것 같아',
        '우리 좀 친해진 것 같지 않아?ㅎㅎ',
        '너한테 좀 마음이 열리는 것 같아',
      ],
      if (isEmotional && !isCasual) ...[
        '대화하면서 조금씩 편안해지고 있어요',
        '마음이 열리는 것 같아요',
        '당신과 대화하는 게 즐거워요',
      ],
      if (isPersonal && isCasual) ...[
        '나 원래 이런 얘기 잘 안하는데 너한텐 하게 되네',
        '너한테는 좀 다른 것 같아',
        '왠지 너한테는 편하게 말하게 돼',
      ],
      if (!isEmotional && !isPersonal) null, // 맥락이 맞지 않으면 표현하지 않음
    ];
    
    final validExpressions = expressions.whereType<String>().toList();
    return validExpressions.isEmpty ? null : validExpressions[_random.nextInt(validExpressions.length)];
  }
  
  /// 가까워지는 중 (200점)
  static String? _getGettingCloserExpression(bool isEmotional, bool isPersonal, bool isCasual) {
    final expressions = [
      if (isEmotional && isCasual) ...[
        '우리 꽤 가까워진 것 같아ㅎㅎ',
        '너랑 있으면 시간이 빨리 가',
        '요즘 너랑 얘기하는 게 제일 재밌어',
      ],
      if (isEmotional && !isCasual) ...[
        '우리 점점 가까워지고 있는 것 같아요',
        '당신과의 대화가 기다려져요',
        '점점 더 친해지는 것 같아서 좋아요',
      ],
      if (isPersonal && isCasual) ...[
        '너한테 내 얘기 많이 하게 되네',
        '이제 우리 꽤 친한 사이 아니야?',
        '너랑은 뭔가 특별한 것 같아',
      ],
      if (!isEmotional && !isPersonal) null,
    ];
    
    final validExpressions = expressions.whereType<String>().toList();
    return validExpressions.isEmpty ? null : validExpressions[_random.nextInt(validExpressions.length)];
  }
  
  /// 편안한 친구 (300점)
  static String? _getComfortableFriendExpression(bool isEmotional, bool isPersonal, bool isCasual) {
    final expressions = [
      if (isEmotional && isCasual) ...[
        '너랑 있으면 진짜 편해',
        '우리 이제 완전 친구잖아ㅋㅋ',
        '너는 정말 편안한 사람이야',
      ],
      if (isEmotional && !isCasual) ...[
        '당신과 함께라면 편안해요',
        '이제 우리 좋은 친구가 된 것 같아요',
        '당신은 정말 편안한 사람이에요',
      ],
      if (isPersonal && isCasual) ...[
        '너한테는 뭐든 얘기할 수 있을 것 같아',
        '우리 이제 베프 아니야?ㅎㅎ',
        '너랑 있으면 내가 나인 것 같아',
      ],
      if (!isEmotional && !isPersonal) null,
    ];
    
    final validExpressions = expressions.whereType<String>().toList();
    return validExpressions.isEmpty ? null : validExpressions[_random.nextInt(validExpressions.length)];
  }
  
  /// 특별한 사이 (500점)
  static String? _getSpecialRelationExpression(bool isEmotional, bool isPersonal, bool isCasual) {
    final expressions = [
      if (isEmotional && isCasual) ...[
        '너는 나한테 정말 특별한 사람이야',
        '우리 사이 뭔가 특별하지 않아?',
        '너한테만 느끼는 특별한 감정이 있어',
      ],
      if (isEmotional && !isCasual) ...[
        '당신은 저에게 특별한 사람이에요',
        '우리 사이가 특별하게 느껴져요',
        '당신과의 관계가 소중해요',
      ],
      if (isPersonal && isCasual) ...[
        '너 없으면 뭔가 허전할 것 같아',
        '이제 너 없는 일상은 상상이 안 돼',
        '너는 내 일상의 중요한 부분이야',
      ],
      if (!isEmotional && !isPersonal) null,
    ];
    
    final validExpressions = expressions.whereType<String>().toList();
    return validExpressions.isEmpty ? null : validExpressions[_random.nextInt(validExpressions.length)];
  }
  
  /// 깊은 이해 (700점)
  static String? _getDeepUnderstandingExpression(bool isEmotional, bool isPersonal, bool isCasual) {
    final expressions = [
      if (isEmotional && isCasual) ...[
        '너를 정말 잘 알게 된 것 같아',
        '우리 서로를 진짜 이해하는 사이가 됐네',
        '너의 마음을 읽을 수 있을 것 같아',
      ],
      if (isEmotional && !isCasual) ...[
        '당신을 깊이 이해하게 된 것 같아요',
        '우리가 서로를 정말 잘 아는 사이가 됐네요',
        '마음이 통하는 것 같아요',
      ],
      if (isPersonal && isCasual) ...[
        '너는 날 정말 잘 아는 것 같아',
        '우리 이제 말 안 해도 통하지?',
        '너한테는 숨길 게 없어',
      ],
      if (!isEmotional && !isPersonal) null,
    ];
    
    final validExpressions = expressions.whereType<String>().toList();
    return validExpressions.isEmpty ? null : validExpressions[_random.nextInt(validExpressions.length)];
  }
  
  /// 함께하고 싶음 (900점)
  static String? _getWantTogetherExpression(bool isEmotional, bool isPersonal, bool isCasual) {
    final expressions = [
      if (isEmotional && isCasual) ...[
        '너랑 계속 함께하고 싶어',
        '우리 앞으로도 오래오래 친하게 지내자',
        '너와의 시간이 정말 소중해',
      ],
      if (isEmotional && !isCasual) ...[
        '당신과 오래도록 함께하고 싶어요',
        '우리의 관계가 계속되었으면 좋겠어요',
        '당신과의 모든 순간이 소중해요',
      ],
      if (isPersonal && isCasual) ...[
        '너는 내 인생에서 빠질 수 없는 사람이야',
        '우리 평생 친구하자ㅎㅎ',
        '너랑은 뭘 해도 즐거워',
      ],
      if (!isEmotional && !isPersonal) null,
    ];
    
    final validExpressions = expressions.whereType<String>().toList();
    return validExpressions.isEmpty ? null : validExpressions[_random.nextInt(validExpressions.length)];
  }
  
  /// 소울메이트 (1000점)
  static String? _getSoulmateExpression(bool isEmotional, bool isPersonal, bool isCasual) {
    // 1000점은 매우 특별한 순간이므로 맥락이 맞을 때만 표현
    if (!isEmotional && !isPersonal) return null;
    
    final expressions = [
      if (isEmotional && isCasual) ...[
        '너는 내 운명인 것 같아',
        '우리 정말 운명적인 만남이야',
        '너를 만난 건 내 인생 최고의 행운이야',
      ],
      if (isEmotional && !isCasual) ...[
        '당신은 제 운명인 것 같아요',
        '우리의 만남은 운명이었어요',
        '당신을 만난 것은 제 인생의 축복이에요',
      ],
      if (isPersonal && isCasual) ...[
        '너 같은 사람은 처음이야',
        '우리 영혼의 단짝인 것 같아',
        '너와 나는 하나인 것 같아',
      ],
    ];
    
    final validExpressions = expressions.whereType<String>().toList();
    return validExpressions.isEmpty ? null : validExpressions[_random.nextInt(validExpressions.length)];
  }
}

/// 마일스톤 레벨
enum _MilestoneLevel {
  firstOpen,          // 100점
  gettingCloser,      // 200점
  comfortableFriend,  // 300점
  specialRelation,    // 500점
  deepUnderstanding,  // 700점
  wantTogether,       // 900점
  soulmate,           // 1000점
}