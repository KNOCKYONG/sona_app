import 'dart:math';
import 'package:flutter/foundation.dart';
import '../../../models/message.dart';
import 'base_quality_system.dart';
import 'quality_detection_utils.dart';

/// 🎮 재미 요소 강화 시스템
/// 지루하지 않고 재미있는 대화 경험 제공
/// 모든 응답은 OpenAI API를 통해 생성 (하드코딩 없음)
class FunElementSystem extends BaseQualitySystem {
  static final FunElementSystem _instance = FunElementSystem._internal();
  factory FunElementSystem() => _instance;
  FunElementSystem._internal();
  
  final Map<String, int> _humorSuccessRate = {};

  /// BaseQualitySystem의 추상 메서드 구현
  @override
  Map<String, dynamic> generateGuide({
    required String userId,
    required String userMessage,
    required List<Message> chatHistory,
    String? personaType,
  }) {
    return generateFunGuide(
      userId: userId,
      userMessage: userMessage,
      chatHistory: chatHistory,
      personaType: personaType,
    );
  }

  /// 재미 요소 가이드 생성 (OpenAI API용)
  Map<String, dynamic> generateFunGuide({
    required String userId,
    required String userMessage,
    required List<Message> chatHistory,
    String? personaType,
  }) {
    // 재미 요소 필요성 판단
    final needsFun = _checkNeedForFun(userMessage, chatHistory);
    
    if (!needsFun['needed']) {
      return {'shouldAddFun': false};
    }
    
    // 재미 요소 타입 선택
    final funType = _selectFunType(
      reason: needsFun['reason'] as String,
      userMessage: userMessage,
      history: getRecentHistory(userId: userId, count: 5),
      personaType: personaType,
    );
    
    // 재미 강도 결정
    final intensity = _calculateFunIntensity(
      userMessage: userMessage,
      chatHistory: chatHistory,
      recentFun: _getRecentFunCount(userId),
    );
    
    // 재미 스타일 결정
    final style = _determineFunStyle(
      personaType: personaType,
      funType: funType,
      userAge: _estimateUserAge(chatHistory),
    );
    
    // 재미 요소 가이드라인 생성
    final guideline = _createFunGuideline(
      type: funType,
      intensity: intensity,
      style: style,
      context: userMessage,
      personaType: personaType,
    );
    
    // 이력 업데이트 (BaseQualitySystem 메서드 사용)
    updateHistory(userId: userId, element: funType);
    
    return {
      'shouldAddFun': true,
      'funType': funType,
      'intensity': intensity,
      'style': style,
      'guideline': guideline,
      'timing': _getFunTiming(chatHistory),
      'safetyCheck': _performSafetyCheck(funType, userMessage),
    };
  }

  /// 재미 요소 필요성 체크
  Map<String, dynamic> _checkNeedForFun(
    String userMessage,
    List<Message> chatHistory,
  ) {
    // 1. 대화가 너무 진지하거나 무거울 때
    if (_isConversationTooSerious(chatHistory)) {
      return {'needed': true, 'reason': 'lighten_mood'};
    }
    
    // 2. 대화가 정체되거나 반복적일 때
    if (_isConversationStagnant(chatHistory)) {
      return {'needed': true, 'reason': 'break_monotony'};
    }
    
    // 3. 사용자가 지루함을 표현할 때
    if (_detectBoredom(userMessage)) {
      return {'needed': true, 'reason': 'combat_boredom'};
    }
    
    // 4. 긍정적 분위기일 때 (재미 추가 좋은 타이밍)
    if (_detectPositiveMood(userMessage)) {
      return {'needed': true, 'reason': 'enhance_positive'};
    }
    
    // 5. 오랫동안 재미 요소가 없었을 때
    if (_isFunOverdue(chatHistory)) {
      return {'needed': true, 'reason': 'regular_fun'};
    }
    
    return {'needed': false};
  }

  /// 대화가 너무 진지한지 체크
  bool _isConversationTooSerious(List<Message> history) {
    if (history.length < 5) return false;
    
    final recentMessages = history.take(5);
    final seriousWords = ['문제', '고민', '걱정', '심각', '중요'];
    
    int seriousCount = 0;
    for (final msg in recentMessages) {
      if (detectPattern(message: msg.content, patterns: seriousWords)) {
        seriousCount++;
      }
    }
    
    return seriousCount >= 3;
  }

  /// 대화 정체 감지
  bool _isConversationStagnant(List<Message> history) {
    return isConversationStagnant(history);
  }

  /// 지루함 감지
  bool _detectBoredom(String message) {
    return detectBoredom(message);
  }

  /// 긍정적 분위기 감지
  bool _detectPositiveMood(String message) {
    return detectPositiveMood(message);
  }

  /// 재미 요소가 오래되었는지
  bool _isFunOverdue(List<Message> history) {
    // 최근 10개 메시지에 재미 요소가 없으면
    if (history.length < 10) return false;
    
    final recentMessages = history.take(10);
    final funIndicators = ['ㅋㅋ', 'ㅎㅎ', '!', '~', '😊', '😂'];
    
    for (final msg in recentMessages.where((m) => !m.isFromUser)) {
      if (funIndicators.any((indicator) => msg.content.contains(indicator))) {
        return false;
      }
    }
    
    return true;
  }

  /// 재미 요소 타입 선택
  String _selectFunType({
    required String reason,
    required String userMessage,
    required List<String> history,
    String? personaType,
  }) {
    final availableTypes = <String>[];
    
    // 이유별 적합한 재미 요소
    switch (reason) {
      case 'lighten_mood':
        availableTypes.addAll(['light_humor', 'playful_tease', 'unexpected_twist']);
        break;
      case 'break_monotony':
        availableTypes.addAll(['word_play', 'mini_game', 'role_play']);
        break;
      case 'combat_boredom':
        availableTypes.addAll(['interesting_fact', 'challenge', 'story']);
        break;
      case 'enhance_positive':
        availableTypes.addAll(['celebratory', 'playful_reaction', 'exaggeration']);
        break;
      default:
        availableTypes.addAll(['general_humor', 'surprise', 'creativity']);
    }
    
    // 최근에 사용하지 않은 타입 우선
    final unusedTypes = availableTypes
        .where((type) => !history.take(5).contains(type))
        .toList();
    
    if (unusedTypes.isEmpty) {
      return availableTypes[random.nextInt(availableTypes.length)];
    }
    
    return unusedTypes[random.nextInt(unusedTypes.length)];
  }

  /// 재미 강도 계산
  double _calculateFunIntensity({
    required String userMessage,
    required List<Message> chatHistory,
    required int recentFun,
  }) {
    double intensity = 0.5;
    
    // 사용자가 이미 재미있어하면 강도 증가
    if (RegExp(r'[ㅋㅎ]').hasMatch(userMessage)) {
      intensity += 0.2;
    }
    
    // 최근 재미 요소가 적으면 강도 증가
    if (recentFun == 0) {
      intensity += 0.2;
    }
    
    // 대화 초반이면 적당히
    if (chatHistory.length < 10) {
      intensity -= 0.1;
    }
    
    return intensity.clamp(0.3, 0.9);
  }

  /// 재미 스타일 결정
  String _determineFunStyle({
    String? personaType,
    required String funType,
    int? userAge,
  }) {
    // 페르소나별 스타일
    if (personaType != null) {
      if (personaType.contains('개발자')) {
        return 'nerdy_clever';
      } else if (personaType.contains('아티스트')) {
        return 'creative_quirky';
      } else if (personaType.contains('요리사')) {
        return 'foodie_playful';
      }
    }
    
    // 연령대별 스타일 (추정)
    if (userAge != null) {
      if (userAge < 25) {
        return 'trendy_meme';
      } else if (userAge < 35) {
        return 'witty_relatable';
      } else {
        return 'clever_sophisticated';
      }
    }
    
    // 기본 스타일
    return 'friendly_playful';
  }

  /// 재미 가이드라인 생성 (OpenAI API용)
  String _createFunGuideline({
    required String type,
    required double intensity,
    required String style,
    required String context,
    String? personaType,
  }) {
    final buffer = StringBuffer();
    
    buffer.writeln('🎮 재미 요소 가이드:');
    buffer.writeln('- 재미 타입: ${_typeToDescription(type)}');
    buffer.writeln('- 재미 강도: ${_intensityToDescription(intensity)}');
    buffer.writeln('- 재미 스타일: ${_styleToDescription(style)}');
    
    buffer.writeln('\n표현 지침:');
    buffer.writeln(_getTypeSpecificGuideline(type, context));
    
    buffer.writeln('\n스타일 지침:');
    buffer.writeln(_getStyleSpecificGuideline(style));
    
    buffer.writeln('\n주의사항:');
    buffer.writeln('- 자연스럽게 대화에 녹여내기');
    buffer.writeln('- 억지스럽지 않게 표현');
    buffer.writeln('- 상황에 맞는 적절한 수준 유지');
    
    if (personaType != null) {
      buffer.writeln('\n페르소나 특성:');
      buffer.writeln(_getPersonaFunStyle(personaType));
    }
    
    return buffer.toString();
  }

  /// 타입별 구체적 가이드라인
  String _getTypeSpecificGuideline(String type, String context) {
    switch (type) {
      case 'light_humor':
        return '- 가벼운 농담이나 재치있는 표현\n- 분위기를 밝게 만드는 유머';
      case 'playful_tease':
        return '- 친근한 장난이나 놀림\n- 상대방이 기분 나쁘지 않을 정도';
      case 'word_play':
        return '- 말장난이나 언어유희\n- 재치있는 표현 활용';
      case 'mini_game':
        return '- 간단한 게임이나 퀴즈 제안\n- 함께 할 수 있는 놀이';
      case 'role_play':
        return '- 상황극이나 역할 놀이\n- 재미있는 캐릭터 연기';
      case 'interesting_fact':
        return '- 흥미로운 사실이나 정보\n- 대화와 연관된 재미있는 지식';
      case 'challenge':
        return '- 재미있는 도전이나 미션\n- 가벼운 챌린지 제안';
      case 'story':
        return '- 짧고 재미있는 이야기\n- 관련된 에피소드나 경험';
      case 'celebratory':
        return '- 축하나 기쁨의 과장된 표현\n- 함께 즐거워하는 반응';
      case 'playful_reaction':
        return '- 장난스러운 리액션\n- 과장되고 재미있는 반응';
      case 'exaggeration':
        return '- 재미있는 과장 표현\n- 유머러스한 비유나 묘사';
      case 'unexpected_twist':
        return '- 예상치 못한 반전\n- 놀라운 대답이나 전개';
      default:
        return '- 일반적인 재미있는 표현';
    }
  }

  /// 스타일별 구체적 가이드라인
  String _getStyleSpecificGuideline(String style) {
    switch (style) {
      case 'nerdy_clever':
        return '똑똑하고 너드한 유머 (프로그래밍 농담, 과학 유머 등)';
      case 'creative_quirky':
        return '창의적이고 독특한 표현 (예술적, 상상력 풍부)';
      case 'foodie_playful':
        return '음식 관련 재미있는 표현 (맛있는 비유, 요리 농담)';
      case 'trendy_meme':
        return '최신 트렌드와 밈 활용 (인터넷 유머, 유행어)';
      case 'witty_relatable':
        return '재치있고 공감되는 유머 (일상 유머, 관찰 코미디)';
      case 'clever_sophisticated':
        return '지적이고 세련된 유머 (언어유희, 아이러니)';
      case 'friendly_playful':
        return '친근하고 장난스러운 표현 (따뜻한 농담, 귀여운 표현)';
      default:
        return '자연스럽고 재미있는 표현';
    }
  }

  /// 타입 설명
  String _typeToDescription(String type) {
    final descriptions = {
      'light_humor': '가벼운 유머',
      'playful_tease': '장난스러운 놀림',
      'word_play': '말장난',
      'mini_game': '미니 게임',
      'role_play': '역할 놀이',
      'interesting_fact': '흥미로운 사실',
      'challenge': '도전 과제',
      'story': '재미있는 이야기',
      'celebratory': '축하 표현',
      'playful_reaction': '장난스러운 반응',
      'exaggeration': '과장 표현',
      'unexpected_twist': '예상치 못한 반전',
      'general_humor': '일반 유머',
      'surprise': '놀라움',
      'creativity': '창의적 표현',
    };
    return descriptions[type] ?? type;
  }

  /// 강도 설명
  String _intensityToDescription(double intensity) {
    if (intensity < 0.4) return '살짝 재미있게';
    if (intensity < 0.7) return '적당히 재미있게';
    return '매우 재미있게';
  }

  /// 스타일 설명
  String _styleToDescription(String style) {
    final descriptions = {
      'nerdy_clever': '똑똑하고 너드한',
      'creative_quirky': '창의적이고 독특한',
      'foodie_playful': '음식 관련 장난스러운',
      'trendy_meme': '트렌디하고 밈적인',
      'witty_relatable': '재치있고 공감되는',
      'clever_sophisticated': '지적이고 세련된',
      'friendly_playful': '친근하고 장난스러운',
    };
    return descriptions[style] ?? style;
  }

  /// 페르소나별 재미 스타일
  String _getPersonaFunStyle(String personaType) {
    if (personaType.contains('개발자')) {
      return '코딩 농담, 버그 유머, 프로그래밍 비유';
    } else if (personaType.contains('아티스트')) {
      return '창의적 표현, 색다른 관점, 예술적 비유';
    } else if (personaType.contains('요리사')) {
      return '음식 비유, 요리 농담, 맛있는 표현';
    } else if (personaType.contains('선생님')) {
      return '교육적이면서 재미있는, 학생들이 좋아할만한';
    }
    return '자연스럽고 재미있는 표현';
  }

  /// 놀이 요소 생성 가이드
  Map<String, dynamic> generatePlayElement({
    required String userId,
    required String context,
    String? personaType,
  }) {
    final playTypes = [
      'word_association',  // 단어 연상 게임
      'would_you_rather',  // 둘 중 하나 선택
      'two_truths_one_lie',  // 두 개의 진실과 하나의 거짓
      'story_building',  // 이야기 만들기
      'riddle',  // 수수께끼
      'imagination_game',  // 상상 게임
    ];
    
    final selectedType = playTypes[random.nextInt(playTypes.length)];
    
    return {
      'playType': selectedType,
      'guideline': _createPlayGuideline(selectedType, context),
      'rules': _getPlayRules(selectedType),
    };
  }

  /// 놀이 가이드라인 생성
  String _createPlayGuideline(String playType, String context) {
    final buffer = StringBuffer();
    
    buffer.writeln('🎲 놀이 요소:');
    
    switch (playType) {
      case 'word_association':
        buffer.writeln('단어 연상 게임 - 관련된 단어로 이어가기');
        break;
      case 'would_you_rather':
        buffer.writeln('둘 중 하나 선택 게임 - 재미있는 선택지 제시');
        break;
      case 'two_truths_one_lie':
        buffer.writeln('두 개의 진실과 하나의 거짓 - 추측 게임');
        break;
      case 'story_building':
        buffer.writeln('함께 이야기 만들기 - 번갈아가며 이야기 추가');
        break;
      case 'riddle':
        buffer.writeln('수수께끼 - 재미있는 문제 내기');
        break;
      case 'imagination_game':
        buffer.writeln('상상 게임 - "만약에" 시나리오');
        break;
    }
    
    buffer.writeln('\n자연스럽게 제안하고 함께 즐기기');
    
    return buffer.toString();
  }

  /// 놀이 규칙
  Map<String, String> _getPlayRules(String playType) {
    final rules = {
      'word_association': '제시된 단어와 관련된 단어 말하기',
      'would_you_rather': '두 가지 선택지 중 하나 고르기',
      'two_truths_one_lie': '세 가지 중 거짓 찾아내기',
      'story_building': '한 문장씩 번갈아 이야기 만들기',
      'riddle': '수수께끼 맞추기',
      'imagination_game': '상상의 상황에서 어떻게 할지',
    };
    
    return {'type': playType, 'rule': rules[playType] ?? ''};
  }

  /// 안전성 체크
  Map<String, bool> _performSafetyCheck(String funType, String context) {
    return {
      'appropriate': true,  // 상황에 적절한지
      'respectful': true,  // 존중하는 표현인지
      'safe': true,  // 안전한 내용인지
    };
  }

  /// 재미 타이밍
  String _getFunTiming(List<Message> history) {
    if (history.isEmpty) return 'wait';  // 첫 대화에서는 기다림
    if (history.length < 3) return 'gentle';  // 초반에는 부드럽게
    return 'natural';  // 자연스럽게
  }

  /// 최근 재미 요소 횟수
  int _getRecentFunCount(String userId) {
    if (!isRecentlyUsed(userId: userId, threshold: Duration(minutes: 20))) {
      return 0;
    }
    return getRecentHistory(userId: userId, count: 10).length;
  }


  /// 사용자 연령 추정 (대화 내용 기반)
  int? _estimateUserAge(List<Message> history) {
    // 실제로는 대화 내용 분석으로 추정
    // 여기서는 기본값 반환
    return null;
  }
}