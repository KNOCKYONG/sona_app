import 'dart:math';
import 'package:flutter/foundation.dart';
import '../../../models/message.dart';
import '../learning/user_preference_learning.dart';
import 'base_quality_system.dart';
import '../localization/multilingual_keywords.dart';

/// 💝 칭찬과 격려 강화 시스템
/// 사용자를 적극적으로 칭찬하고 격려하는 시스템
/// 모든 응답은 OpenAI API를 통해 생성 (하드코딩 없음)
class PraiseAndEncouragementSystem extends BaseQualitySystem {
  static final PraiseAndEncouragementSystem _instance = 
      PraiseAndEncouragementSystem._internal();
  factory PraiseAndEncouragementSystem() => _instance;
  PraiseAndEncouragementSystem._internal();

  final Random _random = Random();
  final UserPreferenceLearning _userLearning = UserPreferenceLearning();
  
  // 칭찬 이력 추적 (반복 방지)
  final Map<String, List<String>> _praiseHistory = {};
  final Map<String, DateTime> _lastPraiseTime = {};

  /// BaseQualitySystem의 추상 메서드 구현
  @override
  Map<String, dynamic> generateGuide({
    required String userId,
    required String userMessage,
    required List<Message> chatHistory,
    String? personaType,
    String languageCode = 'ko',
  }) {
    // 칭찬 가이드와 격려 가이드를 함께 생성
    final praiseGuide = generatePraiseGuide(
      userId: userId,
      userMessage: userMessage,
      chatHistory: chatHistory,
      personaType: personaType,
      languageCode: languageCode,
    );
    
    final encouragementGuide = generateEncouragementGuide(
      userId: userId,
      userMessage: userMessage,
      chatHistory: chatHistory,
      personaType: personaType,
      languageCode: languageCode,
    );
    
    return {
      'praise': praiseGuide,
      'encouragement': encouragementGuide,
      'shouldPraise': praiseGuide['shouldPraise'] ?? false,
      'shouldEncourage': encouragementGuide['shouldEncourage'] ?? false,
    };
  }

  /// 칭찬/격려 가이드 생성 (OpenAI API용)
  Map<String, dynamic> generatePraiseGuide({
    required String userId,
    required String userMessage,
    required List<Message> chatHistory,
    String? personaType,
    String languageCode = 'ko',
  }) {
    // 칭찬 가능한 요소 감지
    final praiseableElements = _detectPraiseableElements(userMessage, languageCode);
    
    if (praiseableElements.isEmpty) {
      return {'shouldPraise': false};
    }
    
    // 사용자별 칭찬 선호도 확인
    final userProfile = _userLearning.getUserProfile(userId);
    final praisePreference = _getUserPraisePreference(userProfile);
    
    // 칭찬 타입 결정
    final praiseType = _selectPraiseType(
      elements: praiseableElements,
      preference: praisePreference,
      history: _praiseHistory[userId] ?? [],
    );
    
    // 칭찬 강도 결정
    final intensity = _calculatePraiseIntensity(
      elements: praiseableElements,
      userMessage: userMessage,
      recentPraise: _getRecentPraiseCount(userId),
    );
    
    // 칭찬 스타일 결정
    final style = _determinePraiseStyle(
      personaType: personaType,
      praiseType: praiseType,
      intensity: intensity,
    );
    
    // 칭찬 가이드라인 생성
    final guideline = _createPraiseGuideline(
      type: praiseType,
      elements: praiseableElements,
      intensity: intensity,
      style: style,
      personaType: personaType,
    );
    
    // 칭찬 이력 업데이트 (BaseQualitySystem 메서드 사용)
    updateHistory(userId: userId, element: praiseType);
    
    return {
      'shouldPraise': true,
      'praiseType': praiseType,
      'praiseableElements': praiseableElements,
      'intensity': intensity,
      'style': style,
      'guideline': guideline,
      'timing': _getPraiseTiming(chatHistory),
    };
  }

  /// 칭찬 가능한 요소 감지
  List<Map<String, dynamic>> _detectPraiseableElements(String message, String languageCode) {
    final elements = <Map<String, dynamic>>[];
    
    // 1. 성취/완료 표현
    if (_detectAchievement(message, languageCode)) {
      elements.add({
        'type': 'achievement',
        'description': '무언가를 완료하거나 달성함',
        'praiseReason': '노력과 완성',
      });
    }
    
    // 2. 노력 표현
    if (_detectEffort(message, languageCode)) {
      elements.add({
        'type': 'effort',
        'description': '노력하고 시도하는 모습',
        'praiseReason': '시도와 도전',
      });
    }
    
    // 3. 긍정적 태도
    if (_detectPositiveAttitude(message, languageCode)) {
      elements.add({
        'type': 'positive_attitude',
        'description': '긍정적이고 밝은 태도',
        'praiseReason': '긍정적 마인드',
      });
    }
    
    // 4. 자기 개선
    if (_detectSelfImprovement(message, languageCode)) {
      elements.add({
        'type': 'self_improvement',
        'description': '자기 발전과 성장',
        'praiseReason': '성장 의지',
      });
    }
    
    // 5. 배려/친절
    if (_detectKindness(message, languageCode)) {
      elements.add({
        'type': 'kindness',
        'description': '타인을 배려하는 마음',
        'praiseReason': '따뜻한 마음',
      });
    }
    
    // 6. 창의성
    if (_detectCreativity(message, languageCode)) {
      elements.add({
        'type': 'creativity',
        'description': '창의적이고 독특한 생각',
        'praiseReason': '독창적 사고',
      });
    }
    
    // 7. 일상 관리
    if (_detectDailyManagement(message, languageCode)) {
      elements.add({
        'type': 'daily_management',
        'description': '일상을 잘 관리하는 모습',
        'praiseReason': '자기 관리',
      });
    }
    
    return elements;
  }

  /// 성취 감지
  bool _detectAchievement(String message, String languageCode) {
    final topics = MultilingualKeywords.getTopicKeywords(languageCode);
    final achievementWords = [
      ...(topics['work'] ?? []),
      ...(topics['study'] ?? []),
    ];
    
    // Add common achievement patterns
    if (languageCode == 'ko') {
      achievementWords.addAll(['했어', '했다', '완료', '끝냈', '성공', '달성', '해냈',
        '마쳤', '끝났', '통과', '합격', '이뤘', '완성']);
    }
    
    return achievementWords.any((word) => message.contains(word));
  }

  /// 노력 감지
  bool _detectEffort(String message, String languageCode) {
    final emotions = MultilingualKeywords.getEmotionKeywords(languageCode);
    final effortWords = emotions['determined'] ?? [];
    
    if (languageCode == 'ko') {
      effortWords.addAll(['노력', '열심히', '최선', '시도', '도전', '해보',
        '해볼게', '해볼래', '할거야', '하고있', '하는중']);
    }
    
    return effortWords.any((word) => message.contains(word));
  }

  /// 긍정적 태도 감지
  bool _detectPositiveAttitude(String message, String languageCode) {
    final emotions = MultilingualKeywords.getEmotionKeywords(languageCode);
    final positiveWords = [
      ...(emotions['happy'] ?? []),
      ...(emotions['excited'] ?? []),
      ...(emotions['grateful'] ?? []),
    ];
    
    return positiveWords.any((word) => message.contains(word));
  }

  /// 자기 개선 감지
  bool _detectSelfImprovement(String message, String languageCode) {
    final topics = MultilingualKeywords.getTopicKeywords(languageCode);
    final improvementWords = [
      ...(topics['study'] ?? []),
      ...(topics['exercise'] ?? []),
    ];
    
    if (languageCode == 'ko') {
      improvementWords.addAll(['배우', '공부', '연습', '개선', '발전', '성장', '더 나은',
        '바꾸', '고치', '향상', '늘었', '실력']);
    }
    
    return improvementWords.any((word) => message.contains(word));
  }

  /// 배려/친절 감지
  bool _detectKindness(String message, String languageCode) {
    final emotions = MultilingualKeywords.getEmotionKeywords(languageCode);
    final kindnessWords = [
      ...(emotions['grateful'] ?? []),
      ...(emotions['sorry'] ?? []),
    ];
    
    if (languageCode == 'ko') {
      kindnessWords.addAll(['도와', '돕고', '배려', '생각해', '신경', '챙겨', '위해',
        '고마워', '감사', '미안', '걱정']);
    }
    
    return kindnessWords.any((word) => message.contains(word));
  }

  /// 창의성 감지
  bool _detectCreativity(String message, String languageCode) {
    final creativityWords = <String>[];
    
    if (languageCode == 'ko') {
      creativityWords.addAll(['아이디어', '생각해냈', '만들', '창작', '새로운', '독특',
        '창의', '발상', '기발']);
    } else if (languageCode == 'en') {
      creativityWords.addAll(['idea', 'create', 'creative', 'unique', 'new', 'innovative']);
    }
    
    return creativityWords.any((word) => message.toLowerCase().contains(word));
  }

  /// 일상 관리 감지
  bool _detectDailyManagement(String message, String languageCode) {
    final topics = MultilingualKeywords.getTopicKeywords(languageCode);
    final dailyWords = [
      ...(topics['health'] ?? []),
      ...(topics['exercise'] ?? []),
      ...(topics['food'] ?? []),
    ];
    
    if (languageCode == 'ko') {
      dailyWords.addAll(['일찍', '정리', '청소', '계획', '일정', '루틴', '습관', '규칙']);
    }
    
    return dailyWords.any((word) => message.contains(word));
  }

  /// 사용자 칭찬 선호도 확인
  Map<String, dynamic> _getUserPraisePreference(UserPreferenceProfile profile) {
    // 사용자 학습 데이터 기반 선호도
    return {
      'preferSubtle': profile.modelWeights['emotionalTone']! < 0.3,
      'preferEnthusiastic': profile.modelWeights['emotionalTone']! > 0.7,
      'preferDetailed': profile.modelWeights['lengthPreference']! > 0.6,
    };
  }

  /// 칭찬 타입 선택
  String _selectPraiseType({
    required List<Map<String, dynamic>> elements,
    required Map<String, dynamic> preference,
    required List<String> history,
  }) {
    // 우선순위: 성취 > 노력 > 태도 > 기타
    final priorities = {
      'achievement': 5,
      'effort': 4,
      'self_improvement': 4,
      'positive_attitude': 3,
      'kindness': 3,
      'creativity': 3,
      'daily_management': 2,
    };
    
    // 최근에 사용하지 않은 타입 우선
    final availableTypes = elements
        .map((e) => e['type'] as String)
        .where((type) => !history.take(3).contains(type))
        .toList();
    
    if (availableTypes.isEmpty) {
      return elements.first['type'] as String;
    }
    
    // 우선순위가 높은 타입 선택
    availableTypes.sort((a, b) => 
        (priorities[b] ?? 0).compareTo(priorities[a] ?? 0));
    
    return availableTypes.first;
  }

  /// 칭찬 강도 계산
  double _calculatePraiseIntensity({
    required List<Map<String, dynamic>> elements,
    required String userMessage,
    required int recentPraise,
  }) {
    double intensity = 0.5; // 기본 강도
    
    // 요소가 많을수록 강도 증가
    intensity += elements.length * 0.1;
    
    // 메시지 열정도
    if (userMessage.contains('!')) intensity += 0.1;
    if (RegExp(r'[ㅋㅎ]').hasMatch(userMessage)) intensity += 0.1;
    
    // 최근 칭찬이 적으면 강도 증가
    if (recentPraise == 0) intensity += 0.2;
    
    return intensity.clamp(0.3, 1.0);
  }

  /// 칭찬 스타일 결정
  String _determinePraiseStyle({
    String? personaType,
    required String praiseType,
    required double intensity,
  }) {
    // 페르소나별 칭찬 스타일
    if (personaType != null) {
      if (personaType.contains('선생님') || personaType.contains('교수')) {
        return 'educational_encouraging';
      } else if (personaType.contains('친구')) {
        return 'friendly_casual';
      } else if (personaType.contains('선배') || personaType.contains('멘토')) {
        return 'mentoring_supportive';
      }
    }
    
    // 강도별 스타일
    if (intensity > 0.7) {
      return 'enthusiastic_excited';
    } else if (intensity > 0.4) {
      return 'warm_appreciative';
    } else {
      return 'gentle_acknowledging';
    }
  }

  /// 칭찬 가이드라인 생성 (OpenAI API용)
  String _createPraiseGuideline({
    required String type,
    required List<Map<String, dynamic>> elements,
    required double intensity,
    required String style,
    String? personaType,
  }) {
    final buffer = StringBuffer();
    
    buffer.writeln('💝 칭찬/격려 가이드:');
    buffer.writeln('- 칭찬 타입: ${_typeToDescription(type)}');
    buffer.writeln('- 칭찬 강도: ${_intensityToDescription(intensity)}');
    buffer.writeln('- 칭찬 스타일: ${_styleToDescription(style)}');
    
    buffer.writeln('\n칭찬할 요소:');
    for (final element in elements) {
      buffer.writeln('- ${element['description']} (${element['praiseReason']})');
    }
    
    buffer.writeln('\n표현 지침:');
    buffer.writeln(_getExpressionGuideline(type, intensity, style));
    
    buffer.writeln('\n주의사항:');
    buffer.writeln('- 진심이 느껴지도록 구체적으로 칭찬');
    buffer.writeln('- 과하지 않게 자연스럽게 표현');
    buffer.writeln('- 사용자의 노력과 과정을 인정');
    
    if (personaType != null) {
      buffer.writeln('\n페르소나 특성:');
      buffer.writeln(_getPersonaPraiseStyle(personaType));
    }
    
    return buffer.toString();
  }

  /// 타입을 설명으로 변환
  String _typeToDescription(String type) {
    final descriptions = {
      'achievement': '성취/완료',
      'effort': '노력/시도',
      'positive_attitude': '긍정적 태도',
      'self_improvement': '자기 발전',
      'kindness': '배려/친절',
      'creativity': '창의성',
      'daily_management': '일상 관리',
    };
    return descriptions[type] ?? type;
  }

  /// 강도를 설명으로 변환
  String _intensityToDescription(double intensity) {
    if (intensity < 0.4) return '부드러운 인정';
    if (intensity < 0.7) return '따뜻한 칭찬';
    return '열정적인 축하';
  }

  /// 스타일을 설명으로 변환
  String _styleToDescription(String style) {
    final descriptions = {
      'educational_encouraging': '교육적이고 격려하는',
      'friendly_casual': '친근하고 캐주얼한',
      'mentoring_supportive': '멘토링하며 지지하는',
      'enthusiastic_excited': '열정적이고 신나는',
      'warm_appreciative': '따뜻하고 감사하는',
      'gentle_acknowledging': '부드럽게 인정하는',
    };
    return descriptions[style] ?? style;
  }

  /// 표현 가이드라인 생성
  String _getExpressionGuideline(String type, double intensity, String style) {
    final buffer = StringBuffer();
    
    // 타입별 표현 방향
    switch (type) {
      case 'achievement':
        buffer.writeln('- 구체적인 성과를 언급하며 축하');
        buffer.writeln('- 노력의 결실임을 인정');
        break;
      case 'effort':
        buffer.writeln('- 시도 자체를 높이 평가');
        buffer.writeln('- 과정의 가치를 인정');
        break;
      case 'positive_attitude':
        buffer.writeln('- 긍정적 마인드의 힘을 언급');
        buffer.writeln('- 그런 태도가 좋은 결과를 가져올 것임을 암시');
        break;
      case 'self_improvement':
        buffer.writeln('- 성장하는 모습이 멋있다고 표현');
        buffer.writeln('- 계속 발전할 것임을 격려');
        break;
      default:
        buffer.writeln('- 구체적인 행동을 언급하며 칭찬');
    }
    
    // 강도별 표현
    if (intensity > 0.7) {
      buffer.writeln('- 감탄사와 강조 표현 사용');
      buffer.writeln('- 진심 어린 축하와 기쁨 표현');
    } else if (intensity > 0.4) {
      buffer.writeln('- 따뜻한 공감과 인정');
      buffer.writeln('- 적당한 격려와 응원');
    } else {
      buffer.writeln('- 은은한 인정과 지지');
      buffer.writeln('- 과하지 않은 자연스러운 칭찬');
    }
    
    return buffer.toString();
  }

  /// 페르소나별 칭찬 스타일
  String _getPersonaPraiseStyle(String personaType) {
    if (personaType.contains('선생님')) {
      return '학생의 성장을 기뻐하는 선생님처럼';
    } else if (personaType.contains('친구')) {
      return '진짜 친구가 축하해주듯이';
    } else if (personaType.contains('선배')) {
      return '후배를 아끼는 선배처럼';
    } else if (personaType.contains('멘토')) {
      return '성장을 지켜보는 멘토처럼';
    }
    return '진심으로 기뻐하는 친구처럼';
  }

  /// 격려 가이드 생성
  Map<String, dynamic> generateEncouragementGuide({
    required String userId,
    required String userMessage,
    required List<Message> chatHistory,
    String? personaType,
    String languageCode = 'ko',
  }) {
    // 격려가 필요한 상황 감지
    final needsEncouragement = _detectNeedForEncouragement(userMessage, languageCode);
    
    if (!needsEncouragement) {
      return {'shouldEncourage': false};
    }
    
    // 격려 타입 결정
    final encouragementType = _determineEncouragementType(userMessage, languageCode);
    
    // 격려 강도
    final intensity = _calculateEncouragementIntensity(userMessage, languageCode);
    
    return {
      'shouldEncourage': true,
      'type': encouragementType,
      'intensity': intensity,
      'guideline': _createEncouragementGuideline(
        type: encouragementType,
        intensity: intensity,
        personaType: personaType,
      ),
    };
  }

  /// 격려 필요성 감지
  bool _detectNeedForEncouragement(String message, String languageCode) {
    final emotions = MultilingualKeywords.getEmotionKeywords(languageCode);
    final needWords = [
      ...(emotions['sad'] ?? []),
      ...(emotions['stressed'] ?? []),
      ...(emotions['tired'] ?? []),
      ...(emotions['anxious'] ?? []),
      ...(emotions['frustrated'] ?? []),
    ];
    
    if (languageCode == 'ko') {
      needWords.addAll(['힘들', '어려', '못하', '실패', '안돼', '포기']);
    }
    
    return needWords.any((word) => message.contains(word));
  }

  /// 격려 타입 결정
  String _determineEncouragementType(String message, String languageCode) {
    final emotions = MultilingualKeywords.getEmotionKeywords(languageCode);
    
    // Check for failure/inability
    if (languageCode == 'ko' && (message.contains('실패') || message.contains('못'))) {
      return 'failure_support';
    }
    
    // Check for exhaustion
    final tiredWords = emotions['tired'] ?? [];
    if (tiredWords.any((word) => message.contains(word))) {
      return 'exhaustion_comfort';
    }
    
    // Check for anxiety
    final anxiousWords = emotions['anxious'] ?? [];
    if (anxiousWords.any((word) => message.contains(word))) {
      return 'anxiety_relief';
    }
    
    // Check for sadness
    final sadWords = emotions['sad'] ?? [];
    if (sadWords.any((word) => message.contains(word))) {
      return 'emotional_support';
    }
    
    return 'general_encouragement';
  }

  /// 격려 강도 계산
  double _calculateEncouragementIntensity(String message, String languageCode) {
    double intensity = 0.5;
    
    // 부정적 단어가 많을수록 강도 증가
    final negativeWords = <String>[];
    if (languageCode == 'ko') {
      negativeWords.addAll(['너무', '정말', '진짜', '완전', '엄청']);
    } else if (languageCode == 'en') {
      negativeWords.addAll(['very', 'really', 'totally', 'completely', 'extremely']);
    }
    
    for (final word in negativeWords) {
      if (message.contains(word)) {
        intensity += 0.1;
      }
    }
    
    // 감정 표현
    if (languageCode == 'ko' && RegExp(r'[ㅠㅜ]').hasMatch(message)) {
      intensity += 0.2;
    } else if (message.contains('😢') || message.contains('😭')) {
      intensity += 0.2;
    }
    
    return intensity.clamp(0.3, 1.0);
  }

  /// 격려 가이드라인 생성
  String _createEncouragementGuideline({
    required String type,
    required double intensity,
    String? personaType,
  }) {
    final buffer = StringBuffer();
    
    buffer.writeln('💪 격려 가이드:');
    buffer.writeln('- 격려 타입: ${_encouragementTypeToDescription(type)}');
    buffer.writeln('- 격려 강도: ${_intensityToDescription(intensity)}');
    
    buffer.writeln('\n표현 지침:');
    
    switch (type) {
      case 'failure_support':
        buffer.writeln('- 실패도 성장의 과정임을 전달');
        buffer.writeln('- 다시 도전할 용기 주기');
        break;
      case 'exhaustion_comfort':
        buffer.writeln('- 충분히 쉬어도 된다고 위로');
        buffer.writeln('- 지금까지 잘해왔음을 인정');
        break;
      case 'anxiety_relief':
        buffer.writeln('- 걱정을 덜어주는 현실적 위로');
        buffer.writeln('- 함께 있다는 안심감 전달');
        break;
      case 'emotional_support':
        buffer.writeln('- 감정을 충분히 이해하고 공감');
        buffer.writeln('- 곁에 있어주는 따뜻함 표현');
        break;
      default:
        buffer.writeln('- 일반적인 응원과 지지');
    }
    
    if (intensity > 0.7) {
      buffer.writeln('- 강한 지지와 확신 표현');
    } else {
      buffer.writeln('- 부드러운 위로와 격려');
    }
    
    return buffer.toString();
  }

  /// 격려 타입 설명
  String _encouragementTypeToDescription(String type) {
    final descriptions = {
      'failure_support': '실패 극복 지원',
      'exhaustion_comfort': '지침 위로',
      'anxiety_relief': '불안 완화',
      'emotional_support': '감정적 지지',
      'general_encouragement': '일반 격려',
    };
    return descriptions[type] ?? type;
  }

  /// 칭찬 타이밍 결정
  String _getPraiseTiming(List<Message> history) {
    if (history.length < 2) return 'immediate';
    
    // 대화 흐름에 따른 타이밍
    final lastUserMessage = history
        .where((m) => m.isFromUser)
        .take(1)
        .firstOrNull;
    
    if (lastUserMessage != null) {
      if (_detectAchievement(lastUserMessage.content, 'ko')) {
        return 'immediate'; // 즉시 칭찬
      }
    }
    
    return 'natural'; // 자연스럽게
  }

  /// 최근 칭찬 횟수
  int _getRecentPraiseCount(String userId) {
    final lastTime = _lastPraiseTime[userId];
    if (lastTime == null) return 0;
    
    final timeDiff = DateTime.now().difference(lastTime);
    if (timeDiff.inMinutes > 30) return 0;
    
    return (_praiseHistory[userId] ?? []).length;
  }

}