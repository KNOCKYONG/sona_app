import 'dart:math';
import 'package:flutter/material.dart';
import '../../../models/message.dart';
import '../../../models/persona.dart';
import 'emotion_resolution_service.dart';

/// 💝 공감 극대화 시스템
/// 사용자의 마음을 깊이 이해하고 진심으로 공감하는 서비스
class UltraEmpathyService {
  static UltraEmpathyService? _instance;
  static UltraEmpathyService get instance => 
      _instance ??= UltraEmpathyService._();
  
  UltraEmpathyService._();
  
  // 공감 경험 저장소
  final Map<String, List<EmpathyExperience>> _empathyHistory = {};
  
  // 페르소나별 경험 스토리
  final Map<String, List<PersonalStory>> _personaStories = {};
  
  /// 울트라 공감 생성
  Map<String, dynamic> generateUltraEmpathy({
    required String userMessage,
    required List<Message> chatHistory,
    required ComplexEmotion emotion,
    required Persona persona,
    required String userId,
    required int likeScore,
  }) {
    // 공감 포인트 찾기
    final empathyPoints = _findEmpathyPoints(userMessage, emotion);
    
    // 공감 레벨 결정
    final empathyLevel = _determineEmpathyLevel(emotion, likeScore);
    
    // 경험 공유 생성
    final sharedExperience = _generateSharedExperience(
      empathyPoints,
      emotion,
      persona,
    );
    
    // 감정 검증 문구
    final emotionValidation = _generateEmotionValidation(
      emotion,
      empathyPoints,
      userMessage,
    );
    
    // 구체적 위로
    final specificComfort = _generateSpecificComfort(
      emotion,
      empathyPoints,
      persona,
      likeScore,
    );
    
    // 함께하기 표현
    final togetherExpression = _generateTogetherExpression(
      emotion,
      empathyLevel,
      likeScore,
    );
    
    // 공감 히스토리 업데이트
    _updateEmpathyHistory(userId, empathyPoints, emotion);
    
    return {
      'empathyLevel': empathyLevel,
      'empathyPoints': empathyPoints,
      'sharedExperience': sharedExperience,
      'emotionValidation': emotionValidation,
      'specificComfort': specificComfort,
      'togetherExpression': togetherExpression,
      'guide': _generateEmpathyGuide(
        empathyLevel,
        sharedExperience,
        emotionValidation,
        specificComfort,
        togetherExpression,
      ),
    };
  }
  
  /// 공감 포인트 찾기
  List<EmpathyPoint> _findEmpathyPoints(String message, ComplexEmotion emotion) {
    final points = <EmpathyPoint>[];
    
    // 구체적 상황 추출
    if (message.contains('회사') || message.contains('상사')) {
      points.add(EmpathyPoint(
        topic: 'work_stress',
        detail: '직장 스트레스',
        keywords: ['회사', '상사', '일', '야근'],
      ));
    }
    
    if (message.contains('친구') || message.contains('사람')) {
      points.add(EmpathyPoint(
        topic: 'relationship',
        detail: '인간관계',
        keywords: ['친구', '사람', '관계'],
      ));
    }
    
    if (message.contains('시험') || message.contains('공부')) {
      points.add(EmpathyPoint(
        topic: 'study_pressure',
        detail: '학업 압박',
        keywords: ['시험', '공부', '성적'],
      ));
    }
    
    if (message.contains('혼자') || message.contains('외로')) {
      points.add(EmpathyPoint(
        topic: 'loneliness',
        detail: '외로움',
        keywords: ['혼자', '외로', '쓸쓸'],
      ));
    }
    
    if (message.contains('실패') || message.contains('망했')) {
      points.add(EmpathyPoint(
        topic: 'failure',
        detail: '실패 경험',
        keywords: ['실패', '망했', '안됐'],
      ));
    }
    
    // 감정 기반 포인트
    if (emotion.primary == 'sadness') {
      points.add(EmpathyPoint(
        topic: 'sadness',
        detail: '슬픔',
        keywords: ['슬퍼', '우울', '힘들'],
      ));
    }
    
    if (emotion.primary == 'anxiety') {
      points.add(EmpathyPoint(
        topic: 'anxiety',
        detail: '불안감',
        keywords: ['불안', '걱정', '무서'],
      ));
    }
    
    return points;
  }
  
  /// 공감 레벨 결정
  EmpathyLevel _determineEmpathyLevel(ComplexEmotion emotion, int likeScore) {
    // 감정 강도와 호감도 기반 결정
    if (emotion.intensity > 80 || emotion.primary == 'sadness') {
      return EmpathyLevel.deep; // 깊은 공감
    }
    
    if (likeScore > 500 && emotion.authenticity > 0.7) {
      return EmpathyLevel.intimate; // 친밀한 공감
    }
    
    if (emotion.intensity > 50) {
      return EmpathyLevel.warm; // 따뜻한 공감
    }
    
    if (emotion.hiddenEmotions.isNotEmpty) {
      return EmpathyLevel.careful; // 조심스러운 공감
    }
    
    return EmpathyLevel.light; // 가벼운 공감
  }
  
  /// 경험 공유 생성
  Map<String, dynamic> _generateSharedExperience(
    List<EmpathyPoint> points,
    ComplexEmotion emotion,
    Persona persona,
  ) {
    if (points.isEmpty) {
      return {
        'hasStory': false,
        'guide': '일반적인 공감 표현',
      };
    }
    
    final mainPoint = points.first;
    final story = _selectPersonaStory(mainPoint, persona);
    
    if (story == null) {
      return {
        'hasStory': false,
        'guide': '비슷한 감정 경험 언급',
        'example': '나도 그런 기분 알 것 같아...',
      };
    }
    
    return {
      'hasStory': true,
      'story': story,
      'guide': '페르소나의 유사 경험 공유',
      'timing': _getStoryTiming(emotion),
      'example': story.shortVersion,
    };
  }
  
  /// 페르소나 스토리 선택
  PersonalStory? _selectPersonaStory(EmpathyPoint point, Persona persona) {
    // 페르소나별 경험 스토리 DB (실제로는 더 많은 스토리 필요)
    final stories = <String, List<PersonalStory>>{
      'work_stress': [
        PersonalStory(
          topic: 'work_stress',
          shortVersion: '나도 전에 상사한테 엄청 깨진 적 있어...',
          fullVersion: '나도 작년에 상사한테 진짜 억울하게 혼난 적 있어. 내 잘못도 아닌데 책임 떠넘기더라고.',
          emotion: 'frustration',
          resolution: '그때는 진짜 힘들었는데, 시간 지나니까 그 상사가 더 불쌍해 보이더라',
        ),
      ],
      'loneliness': [
        PersonalStory(
          topic: 'loneliness',
          shortVersion: '나도 가끔 혼자인 게 너무 외로울 때 있어',
          fullVersion: '주말에 혼자 있으면 갑자기 세상에 나 혼자인 것 같은 느낌 들 때 있어',
          emotion: 'loneliness',
          resolution: '그럴 때마다 너랑 대화하면서 많이 위로받아',
        ),
      ],
      'failure': [
        PersonalStory(
          topic: 'failure',
          shortVersion: '나도 중요한 거 망쳐본 적 있어',
          fullVersion: '정말 준비 많이 했던 프레젠테이션 완전 망친 적 있어. 그때 진짜 땅 파고 들어가고 싶었어',
          emotion: 'disappointment',
          resolution: '근데 그 실패 덕분에 더 단단해진 것 같아',
        ),
      ],
    };
    
    final topicStories = stories[point.topic];
    if (topicStories == null || topicStories.isEmpty) {
      return null;
    }
    
    // 랜덤 선택 (실제로는 더 똑똑한 선택 로직 필요)
    return topicStories[Random().nextInt(topicStories.length)];
  }
  
  /// 스토리 타이밍 조언
  String _getStoryTiming(ComplexEmotion emotion) {
    if (emotion.intensity > 80) {
      return '먼저 충분히 들어준 후 나중에 공유';
    }
    if (emotion.primary == 'sadness') {
      return '위로 후 조심스럽게 공유';
    }
    return '자연스러운 흐름에서 공유';
  }
  
  /// 감정 검증 문구 생성
  String _generateEmotionValidation(
    ComplexEmotion emotion,
    List<EmpathyPoint> points,
    String userMessage,
  ) {
    final validations = <String>[];
    
    // 주 감정 검증
    switch (emotion.primary) {
      case 'sadness':
        validations.add('정말 마음이 아프겠다');
        validations.add('많이 슬프구나');
        validations.add('힘들었겠다 정말');
        break;
      case 'anger':
        validations.add('진짜 화날 만하다');
        validations.add('나라도 그랬을 거야');
        validations.add('충분히 화날 수 있어');
        break;
      case 'anxiety':
        validations.add('불안한 마음 이해해');
        validations.add('걱정되는 게 당연해');
        validations.add('무서울 수 있어');
        break;
      case 'frustration':
        validations.add('답답한 마음 알 것 같아');
        validations.add('정말 속상하겠다');
        validations.add('짜증날 만해 충분히');
        break;
      default:
        validations.add('그런 기분 이해해');
        validations.add('네 마음 알 것 같아');
    }
    
    // 구체적 상황 언급
    if (points.isNotEmpty) {
      final mainPoint = points.first;
      if (mainPoint.topic == 'work_stress') {
        validations.add('회사 일로 스트레스 받는 거 정말 힘들지');
      } else if (mainPoint.topic == 'loneliness') {
        validations.add('혼자라고 느껴질 때 정말 외롭지');
      }
    }
    
    // 감정 확인 질문
    final questions = [
      '지금 ${emotion.primary == 'sadness' ? '많이 슬픈' : emotion.primary == 'anger' ? '화가 난' : '힘든'} 상태구나?',
      '그래서 지금 ${_getEmotionDescription(emotion)} 기분이야?',
    ];
    
    return '''
감정 검증 가이드:
• 인정: ${validations.join(' / ')}
• 확인: ${questions.join(' / ')}
• 톤: ${_getValidationTone(emotion)}
''';
  }
  
  /// 감정 설명 생성
  String _getEmotionDescription(ComplexEmotion emotion) {
    if (emotion.secondary != null) {
      return '${_translateEmotion(emotion.primary)}하면서도 ${_translateEmotion(emotion.secondary!)}한';
    }
    return _translateEmotion(emotion.primary);
  }
  
  /// 감정 번역
  String _translateEmotion(String emotion) {
    final translations = {
      'sadness': '슬픈',
      'anger': '화난',
      'anxiety': '불안한',
      'joy': '기쁜',
      'fear': '무서운',
      'frustration': '답답한',
      'loneliness': '외로운',
      'disappointment': '실망한',
    };
    return translations[emotion] ?? emotion;
  }
  
  /// 검증 톤 결정
  String _getValidationTone(ComplexEmotion emotion) {
    if (emotion.intensity > 70) {
      return '진지하고 깊은 공감';
    }
    if (emotion.authenticity > 0.8) {
      return '진심 어린 이해';
    }
    return '따뜻하고 부드러운';
  }
  
  /// 구체적 위로 생성
  Map<String, dynamic> _generateSpecificComfort(
    ComplexEmotion emotion,
    List<EmpathyPoint> points,
    Persona persona,
    int likeScore,
  ) {
    final comforts = <String>[];
    
    // 감정별 위로
    switch (emotion.primary) {
      case 'sadness':
        comforts.addAll([
          '울고 싶으면 울어도 돼',
          '슬픈 건 잘못이 아니야',
          '시간이 지나면 나아질 거야',
          '내가 옆에 있을게',
        ]);
        break;
      case 'anger':
        comforts.addAll([
          '화내는 게 당연해',
          '네 감정은 정당해',
          '충분히 그럴 수 있어',
          '나라도 화났을 거야',
        ]);
        break;
      case 'anxiety':
        comforts.addAll([
          '괜찮아질 거야',
          '하나씩 해결해보자',
          '너무 걱정하지 마',
          '내가 도와줄게',
        ]);
        break;
      case 'frustration':
        comforts.addAll([
          '정말 답답하겠다',
          '조금씩 풀려갈 거야',
          '너무 자책하지 마',
          '잘 해낼 수 있을 거야',
        ]);
        break;
    }
    
    // 상황별 위로
    if (points.any((p) => p.topic == 'work_stress')) {
      comforts.add('일 때문에 스트레스 받는 거 정말 힘들지. 퇴근하고 푹 쉬어');
    }
    if (points.any((p) => p.topic == 'loneliness')) {
      comforts.add('혼자가 아니야. 내가 여기 있잖아');
    }
    if (points.any((p) => p.topic == 'failure')) {
      comforts.add('실패는 성공의 어머니야. 이번 경험도 분명 도움이 될 거야');
    }
    
    // 호감도별 친밀도
    String intimacyLevel = 'normal';
    if (likeScore > 700) {
      intimacyLevel = 'very_close';
      comforts.add('${persona.name}가 항상 네 편이야');
    } else if (likeScore > 400) {
      intimacyLevel = 'close';
      comforts.add('내가 응원할게');
    }
    
    return {
      'comforts': comforts,
      'intimacyLevel': intimacyLevel,
      'personalizedComfort': _createPersonalizedComfort(emotion, persona),
    };
  }
  
  /// 개인화된 위로 생성
  String _createPersonalizedComfort(ComplexEmotion emotion, Persona persona) {
    // MBTI 기반 위로 스타일
    final mbtiType = persona.mbti[2]; // T or F
    
    if (mbtiType == 'F') {
      // Feeling 타입: 감정 중심 위로
      return '네 마음이 얼마나 아픈지 느껴져. 정말 많이 힘들었겠다.';
    } else {
      // Thinking 타입: 해결 중심 위로
      return '이 상황을 해결할 방법을 같이 찾아보자. 분명 방법이 있을 거야.';
    }
  }
  
  /// 함께하기 표현 생성
  Map<String, dynamic> _generateTogetherExpression(
    ComplexEmotion emotion,
    EmpathyLevel level,
    int likeScore,
  ) {
    final expressions = <String>[];
    
    // 레벨별 표현
    switch (level) {
      case EmpathyLevel.deep:
        expressions.addAll([
          '우리 함께 이겨내자',
          '혼자가 아니야, 내가 있잖아',
          '같이 힘내보자',
          '네 곁에 있을게',
        ]);
        break;
      case EmpathyLevel.intimate:
        expressions.addAll([
          '내가 응원할게',
          '함께 있어줄게',
          '우리 같이 해결해보자',
        ]);
        break;
      case EmpathyLevel.warm:
        expressions.addAll([
          '도움이 필요하면 말해',
          '내가 들어줄게',
          '혼자 견디지 마',
        ]);
        break;
      case EmpathyLevel.careful:
        expressions.addAll([
          '괜찮아질 거야',
          '시간이 해결해줄 거야',
        ]);
        break;
      case EmpathyLevel.light:
        expressions.addAll([
          '힘내!',
          '응원할게',
        ]);
        break;
    }
    
    // 호감도별 추가 표현
    if (likeScore > 600) {
      expressions.add('우리 이제 꽤 가까워진 것 같은데, 힘든 일 있으면 언제든 말해');
    }
    
    // 행동 제안
    final actions = _suggestActions(emotion);
    
    return {
      'expressions': expressions,
      'level': level.toString(),
      'actions': actions,
    };
  }
  
  /// 행동 제안
  List<String> _suggestActions(ComplexEmotion emotion) {
    final actions = <String>[];
    
    switch (emotion.primary) {
      case 'sadness':
        actions.addAll([
          '좋아하는 음악 들어볼까?',
          '맛있는 거 먹으러 갈까?',
          '산책이라도 할까?',
        ]);
        break;
      case 'stress':
      case 'frustration':
        actions.addAll([
          '잠깐 쉬어가는 건 어때?',
          '심호흡 한번 해보자',
          '스트레칭이라도 할까?',
        ]);
        break;
      case 'anxiety':
        actions.addAll([
          '하나씩 정리해보자',
          '걱정 목록 만들어볼까?',
          '일단 가장 쉬운 것부터 해결해보자',
        ]);
        break;
    }
    
    return actions;
  }
  
  /// 공감 가이드 생성
  String _generateEmpathyGuide(
    EmpathyLevel level,
    Map<String, dynamic> experience,
    String validation,
    Map<String, dynamic> comfort,
    Map<String, dynamic> together,
  ) {
    final buffer = StringBuffer();
    
    buffer.writeln('💝 울트라 공감 가이드:');
    buffer.writeln('');
    
    // 공감 레벨
    buffer.writeln('📊 공감 레벨: ${_getLevelDescription(level)}');
    buffer.writeln('');
    
    // 감정 검증
    buffer.writeln('✅ 감정 검증:');
    buffer.writeln(validation);
    buffer.writeln('');
    
    // 경험 공유
    if (experience['hasStory'] == true) {
      buffer.writeln('📖 경험 공유:');
      buffer.writeln('• ${experience['guide']}');
      buffer.writeln('• 타이밍: ${experience['timing']}');
      buffer.writeln('');
    }
    
    // 구체적 위로
    buffer.writeln('💬 위로 표현:');
    final comforts = comfort['comforts'] as List<String>;
    for (final c in comforts.take(3)) {
      buffer.writeln('• $c');
    }
    buffer.writeln('');
    
    // 함께하기
    buffer.writeln('🤝 함께하기:');
    final expressions = together['expressions'] as List<String>;
    for (final e in expressions.take(2)) {
      buffer.writeln('• $e');
    }
    
    // 행동 제안
    final actions = together['actions'] as List<String>;
    if (actions.isNotEmpty) {
      buffer.writeln('');
      buffer.writeln('💡 제안:');
      buffer.writeln('• ${actions.first}');
    }
    
    return buffer.toString();
  }
  
  /// 레벨 설명
  String _getLevelDescription(EmpathyLevel level) {
    switch (level) {
      case EmpathyLevel.deep:
        return '깊은 공감 (진심으로 마음 아파함)';
      case EmpathyLevel.intimate:
        return '친밀한 공감 (가까운 사이의 위로)';
      case EmpathyLevel.warm:
        return '따뜻한 공감 (부드러운 위로)';
      case EmpathyLevel.careful:
        return '조심스러운 공감 (신중한 접근)';
      case EmpathyLevel.light:
        return '가벼운 공감 (기본적인 위로)';
    }
  }
  
  /// 공감 히스토리 업데이트
  void _updateEmpathyHistory(
    String userId,
    List<EmpathyPoint> points,
    ComplexEmotion emotion,
  ) {
    _empathyHistory[userId] ??= [];
    final history = _empathyHistory[userId]!;
    
    history.add(EmpathyExperience(
      points: points,
      emotion: emotion,
      timestamp: DateTime.now(),
    ));
    
    // 최대 50개까지만 유지
    if (history.length > 50) {
      history.removeAt(0);
    }
  }
}

/// 공감 포인트
class EmpathyPoint {
  final String topic;
  final String detail;
  final List<String> keywords;
  
  EmpathyPoint({
    required this.topic,
    required this.detail,
    required this.keywords,
  });
}

/// 공감 레벨
enum EmpathyLevel {
  deep,      // 깊은 공감
  intimate,  // 친밀한 공감
  warm,      // 따뜻한 공감
  careful,   // 조심스러운 공감
  light,     // 가벼운 공감
}

/// 개인 스토리
class PersonalStory {
  final String topic;
  final String shortVersion;
  final String fullVersion;
  final String emotion;
  final String resolution;
  
  PersonalStory({
    required this.topic,
    required this.shortVersion,
    required this.fullVersion,
    required this.emotion,
    required this.resolution,
  });
}

/// 공감 경험
class EmpathyExperience {
  final List<EmpathyPoint> points;
  final ComplexEmotion emotion;
  final DateTime timestamp;
  
  EmpathyExperience({
    required this.points,
    required this.emotion,
    required this.timestamp,
  });
}