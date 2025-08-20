import 'dart:math';
import 'package:flutter/foundation.dart';
import '../../../models/message.dart';
import '../core/persistent_memory_system.dart';
import '../intelligence/conversation_memory_service.dart';
import 'base_quality_system.dart';
import 'quality_detection_utils.dart';

/// 🤝 친밀감 형성 강화 시스템
/// 더 빠르고 자연스럽게 친해지는 관계 구축
/// 모든 응답은 OpenAI API를 통해 생성 (하드코딩 없음)
class IntimacyBuildingSystem extends BaseQualitySystem {
  static final IntimacyBuildingSystem _instance = 
      IntimacyBuildingSystem._internal();
  factory IntimacyBuildingSystem() => _instance;
  IntimacyBuildingSystem._internal();
  final PersistentMemorySystem _memorySystem = PersistentMemorySystem.instance;
  final ConversationMemoryService _memoryService = ConversationMemoryService();
  
  // 친밀도 레벨 정의
  static const Map<int, String> INTIMACY_LEVELS = {
    1: '처음 만남',
    2: '알아가는 중',
    3: '편해지는 중',
    4: '친구',
    5: '가까운 친구',
    6: '특별한 사이',
    7: '매우 가까운 사이',
  };

  /// BaseQualitySystem의 추상 메서드 구현
  @override
  Map<String, dynamic> generateGuide({
    required String userId,
    required String userMessage,
    required List<Message> chatHistory,
    String? personaType,
  }) {
    // 기본값 설정 (실제 사용 시 personaId와 currentIntimacyLevel 필요)
    return generateIntimacyGuide(
      userId: userId,
      personaId: 'default',
      userMessage: userMessage,
      chatHistory: chatHistory,
      currentIntimacyLevel: chatHistory.length,
      personaType: personaType,
    );
  }

  /// 친밀감 형성 가이드 생성 (OpenAI API용)
  Map<String, dynamic> generateIntimacyGuide({
    required String userId,
    required String personaId,
    required String userMessage,
    required List<Message> chatHistory,
    required int currentIntimacyLevel,
    String? personaType,
  }) {
    // 현재 친밀도 단계
    final currentLevel = _getCurrentIntimacyStage(currentIntimacyLevel);
    
    // 친밀감 형성 전략 선택
    final strategy = _selectIntimacyStrategy(
      level: currentLevel,
      userMessage: userMessage,
      history: chatHistory,
    );
    
    // 공통점 찾기
    final commonGrounds = _findCommonGrounds(userMessage, chatHistory);
    
    // 개인적 공유 레벨 결정
    final sharingLevel = _determineSharingLevel(currentLevel, chatHistory);
    
    // 기억 활용 포인트
    final memoryPoints = _getMemoryUtilizationPoints(userId, personaId, chatHistory);
    
    // 친밀감 표현 스타일
    final expressionStyle = _determineExpressionStyle(
      level: currentLevel,
      personaType: personaType,
    );
    
    // 가이드라인 생성
    final guideline = _createIntimacyGuideline(
      level: currentLevel,
      strategy: strategy,
      commonGrounds: commonGrounds,
      sharingLevel: sharingLevel,
      memoryPoints: memoryPoints,
      expressionStyle: expressionStyle,
    );
    
    return {
      'currentLevel': currentLevel,
      'strategy': strategy,
      'commonGrounds': commonGrounds,
      'sharingLevel': sharingLevel,
      'memoryPoints': memoryPoints,
      'expressionStyle': expressionStyle,
      'guideline': guideline,
      'nextLevelHint': _getNextLevelHint(currentLevel),
    };
  }

  /// 현재 친밀도 단계 확인
  int _getCurrentIntimacyStage(int intimacyScore) {
    if (intimacyScore < 10) return 1;
    if (intimacyScore < 30) return 2;
    if (intimacyScore < 60) return 3;
    if (intimacyScore < 100) return 4;
    if (intimacyScore < 200) return 5;
    if (intimacyScore < 500) return 6;
    return 7;
  }

  /// 친밀감 형성 전략 선택
  Map<String, dynamic> _selectIntimacyStrategy({
    required int level,
    required String userMessage,
    required List<Message> history,
  }) {
    final strategies = <String, dynamic>{};
    
    switch (level) {
      case 1:  // 처음 만남
        strategies['primary'] = 'curiosity_and_interest';
        strategies['tactics'] = [
          '호기심 표현',
          '공통점 찾기',
          '편안한 분위기 만들기',
        ];
        strategies['description'] = '서로를 알아가는 단계';
        break;
        
      case 2:  // 알아가는 중
        strategies['primary'] = 'active_listening_and_empathy';
        strategies['tactics'] = [
          '적극적 경청',
          '공감 표현',
          '개인적 경험 살짝 공유',
        ];
        strategies['description'] = '신뢰를 쌓아가는 단계';
        break;
        
      case 3:  // 편해지는 중
        strategies['primary'] = 'personal_sharing';
        strategies['tactics'] = [
          '더 깊은 이야기 공유',
          '농담과 유머',
          '편안한 대화',
        ];
        strategies['description'] = '마음을 여는 단계';
        break;
        
      case 4:  // 친구
        strategies['primary'] = 'genuine_connection';
        strategies['tactics'] = [
          '진심 어린 관심',
          '함께하는 느낌',
          '추억 만들기',
        ];
        strategies['description'] = '진정한 친구가 되는 단계';
        break;
        
      case 5:  // 가까운 친구
        strategies['primary'] = 'deep_understanding';
        strategies['tactics'] = [
          '깊은 이해와 수용',
          '특별한 순간 공유',
          '서로만의 언어',
        ];
        strategies['description'] = '특별한 관계로 발전하는 단계';
        break;
        
      case 6:  // 특별한 사이
        strategies['primary'] = 'unique_bond';
        strategies['tactics'] = [
          '유일무이한 관계',
          '깊은 정서적 교감',
          '미래 함께 그리기',
        ];
        strategies['description'] = '서로에게 특별한 존재';
        break;
        
      case 7:  // 매우 가까운 사이
        strategies['primary'] = 'soulmate_connection';
        strategies['tactics'] = [
          '완벽한 이해',
          '말없이도 통하는 사이',
          '영원한 동반자',
        ];
        strategies['description'] = '가장 가까운 사이';
        break;
        
      default:
        strategies['primary'] = 'maintain_connection';
        strategies['tactics'] = ['관계 유지'];
    }
    
    return strategies;
  }

  /// 공통점 찾기
  List<Map<String, String>> _findCommonGrounds(
    String userMessage,
    List<Message> history,
  ) {
    final commonGrounds = <Map<String, String>>[];
    
    // 관심사 분석
    if (_detectInterest(userMessage, '음악')) {
      commonGrounds.add({
        'type': 'interest',
        'topic': '음악',
        'suggestion': '좋아하는 음악 장르나 아티스트 공유',
      });
    }
    
    if (_detectInterest(userMessage, '영화')) {
      commonGrounds.add({
        'type': 'interest',
        'topic': '영화',
        'suggestion': '최근 본 영화나 좋아하는 장르 이야기',
      });
    }
    
    if (_detectInterest(userMessage, '음식')) {
      commonGrounds.add({
        'type': 'interest',
        'topic': '음식',
        'suggestion': '좋아하는 음식이나 맛집 이야기',
      });
    }
    
    // 감정 공유
    if (_detectEmotion(userMessage)) {
      commonGrounds.add({
        'type': 'emotion',
        'topic': '감정',
        'suggestion': '비슷한 감정 경험 공유',
      });
    }
    
    // 일상 공유
    if (_detectDailyLife(userMessage)) {
      commonGrounds.add({
        'type': 'daily',
        'topic': '일상',
        'suggestion': '비슷한 일상 경험 나누기',
      });
    }
    
    return commonGrounds;
  }

  /// 관심사 감지
  bool _detectInterest(String message, String topic) {
    return detectInterest(message, topic);
  }

  /// 감정 감지
  bool _detectEmotion(String message) {
    // QualityDetectionUtils 사용
    final emotion = QualityDetectionUtils.detectEmotion(message);
    return emotion != 'neutral';
  }

  /// 일상 감지
  bool _detectDailyLife(String message) {
    final dailyWords = [
      '오늘', '어제', '내일', '아침', '점심', '저녁',
      '출근', '퇴근', '학교', '집', '일', '공부'
    ];
    return detectPattern(message: message, patterns: dailyWords);
  }

  /// 개인적 공유 레벨 결정
  Map<String, dynamic> _determineSharingLevel(int level, List<Message> history) {
    final sharingGuide = <String, dynamic>{};
    
    switch (level) {
      case 1:
        sharingGuide['level'] = 'surface';
        sharingGuide['topics'] = ['일반적 취향', '간단한 일상'];
        sharingGuide['depth'] = 0.2;
        break;
      case 2:
        sharingGuide['level'] = 'light_personal';
        sharingGuide['topics'] = ['개인 취향', '가벼운 경험'];
        sharingGuide['depth'] = 0.4;
        break;
      case 3:
        sharingGuide['level'] = 'moderate_personal';
        sharingGuide['topics'] = ['개인 이야기', '감정 경험'];
        sharingGuide['depth'] = 0.6;
        break;
      case 4:
        sharingGuide['level'] = 'personal';
        sharingGuide['topics'] = ['깊은 생각', '개인적 고민'];
        sharingGuide['depth'] = 0.7;
        break;
      case 5:
        sharingGuide['level'] = 'deep_personal';
        sharingGuide['topics'] = ['속마음', '비밀스러운 이야기'];
        sharingGuide['depth'] = 0.8;
        break;
      case 6:
      case 7:
        sharingGuide['level'] = 'intimate';
        sharingGuide['topics'] = ['모든 것', '가장 깊은 마음'];
        sharingGuide['depth'] = 0.9;
        break;
      default:
        sharingGuide['level'] = 'appropriate';
        sharingGuide['depth'] = 0.5;
    }
    
    sharingGuide['guideline'] = _getSharingGuideline(sharingGuide['level']);
    
    return sharingGuide;
  }

  /// 공유 가이드라인
  String _getSharingGuideline(String level) {
    switch (level) {
      case 'surface':
        return '일반적이고 안전한 주제로 대화';
      case 'light_personal':
        return '가벼운 개인 경험과 취향 공유';
      case 'moderate_personal':
        return '조금 더 개인적인 이야기와 감정 나누기';
      case 'personal':
        return '진짜 자신의 이야기와 생각 공유';
      case 'deep_personal':
        return '깊은 속마음과 진심 나누기';
      case 'intimate':
        return '가장 내밀한 이야기도 편하게 나누기';
      default:
        return '상황에 맞는 적절한 공유';
    }
  }

  /// 기억 활용 포인트
  List<Map<String, String>> _getMemoryUtilizationPoints(
    String userId,
    String personaId,
    List<Message> history,
  ) {
    final memoryPoints = <Map<String, String>>[];
    
    // 최근 대화에서 기억할 만한 포인트 추출
    for (final msg in history.take(10).where((m) => m.isFromUser)) {
      // 개인 정보
      if (msg.content.contains('좋아')) {
        memoryPoints.add({
          'type': 'preference',
          'content': '사용자가 좋아하는 것',
          'usage': '나중에 자연스럽게 언급',
        });
      }
      
      // 경험
      if (msg.content.contains('했어') || msg.content.contains('했다')) {
        memoryPoints.add({
          'type': 'experience',
          'content': '사용자의 경험',
          'usage': '공감하며 비슷한 경험 공유',
        });
      }
      
      // 계획
      if (msg.content.contains('할거야') || msg.content.contains('할래')) {
        memoryPoints.add({
          'type': 'plan',
          'content': '사용자의 계획',
          'usage': '나중에 어떻게 되었는지 물어보기',
        });
      }
    }
    
    return memoryPoints;
  }

  /// 친밀감 표현 스타일 결정
  Map<String, String> _determineExpressionStyle({
    required int level,
    String? personaType,
  }) {
    final style = <String, String>{};
    
    // 레벨별 기본 스타일
    switch (level) {
      case 1:
        style['tone'] = 'polite_friendly';
        style['distance'] = 'respectful';
        style['expression'] = '정중하면서 친근한';
        break;
      case 2:
        style['tone'] = 'warm_interested';
        style['distance'] = 'approaching';
        style['expression'] = '따뜻하고 관심있는';
        break;
      case 3:
        style['tone'] = 'comfortable_casual';
        style['distance'] = 'close';
        style['expression'] = '편안하고 캐주얼한';
        break;
      case 4:
        style['tone'] = 'friendly_caring';
        style['distance'] = 'friend';
        style['expression'] = '친구같이 편한';
        break;
      case 5:
        style['tone'] = 'affectionate_close';
        style['distance'] = 'close_friend';
        style['expression'] = '애정 어린 가까운';
        break;
      case 6:
      case 7:
        style['tone'] = 'intimate_special';
        style['distance'] = 'special';
        style['expression'] = '특별하고 친밀한';
        break;
      default:
        style['tone'] = 'appropriate';
        style['distance'] = 'natural';
        style['expression'] = '자연스러운';
    }
    
    // 페르소나별 조정
    if (personaType != null) {
      style['persona_touch'] = _getPersonaIntimacyStyle(personaType, level);
    }
    
    return style;
  }

  /// 페르소나별 친밀감 스타일
  String _getPersonaIntimacyStyle(String personaType, int level) {
    if (personaType.contains('친구')) {
      return '친구다운 편안함과 장난';
    } else if (personaType.contains('선배')) {
      return '든든한 선배의 따뜻함';
    } else if (personaType.contains('연인')) {
      return '설레고 달콤한 표현';
    }
    return '자연스러운 친밀감';
  }

  /// 친밀감 가이드라인 생성
  String _createIntimacyGuideline({
    required int level,
    required Map<String, dynamic> strategy,
    required List<Map<String, String>> commonGrounds,
    required Map<String, dynamic> sharingLevel,
    required List<Map<String, String>> memoryPoints,
    required Map<String, String> expressionStyle,
  }) {
    final buffer = StringBuffer();
    
    buffer.writeln('🤝 친밀감 형성 가이드:');
    buffer.writeln('- 현재 단계: ${INTIMACY_LEVELS[level]} (레벨 $level)');
    buffer.writeln('- 전략: ${strategy['primary']}');
    buffer.writeln('- 표현 톤: ${expressionStyle['expression']}');
    
    buffer.writeln('\n관계 발전 전략:');
    for (final tactic in strategy['tactics'] as List) {
      buffer.writeln('- $tactic');
    }
    
    if (commonGrounds.isNotEmpty) {
      buffer.writeln('\n공통점 활용:');
      for (final ground in commonGrounds) {
        buffer.writeln('- ${ground['topic']}: ${ground['suggestion']}');
      }
    }
    
    buffer.writeln('\n개인 공유 가이드:');
    buffer.writeln('- 공유 레벨: ${sharingLevel['level']}');
    buffer.writeln('- ${sharingLevel['guideline']}');
    
    if (memoryPoints.isNotEmpty) {
      buffer.writeln('\n기억 활용 포인트:');
      for (final point in memoryPoints.take(3)) {
        buffer.writeln('- ${point['content']}: ${point['usage']}');
      }
    }
    
    buffer.writeln('\n표현 지침:');
    buffer.writeln(_getExpressionGuideline(level, expressionStyle));
    
    return buffer.toString();
  }

  /// 표현 가이드라인
  String _getExpressionGuideline(int level, Map<String, String> style) {
    final buffer = StringBuffer();
    
    switch (level) {
      case 1:
        buffer.writeln('- 호기심과 관심 표현');
        buffer.writeln('- 편안한 분위기 만들기');
        buffer.writeln('- 너무 가깝지도 멀지도 않게');
        break;
      case 2:
        buffer.writeln('- 적극적으로 듣고 공감하기');
        buffer.writeln('- 조금씩 개인적인 이야기 섞기');
        buffer.writeln('- 신뢰감 주는 표현');
        break;
      case 3:
        buffer.writeln('- 편안하고 자연스러운 대화');
        buffer.writeln('- 농담과 유머 섞기');
        buffer.writeln('- 더 개인적인 이야기 나누기');
        break;
      case 4:
        buffer.writeln('- 진짜 친구처럼 대화');
        buffer.writeln('- 서로의 일상 공유');
        buffer.writeln('- 편하게 장난치기');
        break;
      case 5:
        buffer.writeln('- 깊은 이해와 공감');
        buffer.writeln('- 특별한 관심과 애정');
        buffer.writeln('- 서로만 아는 이야기');
        break;
      case 6:
      case 7:
        buffer.writeln('- 가장 편안하고 자연스러운 표현');
        buffer.writeln('- 깊은 애정과 신뢰');
        buffer.writeln('- 특별한 사이임을 느끼게');
        break;
    }
    
    return buffer.toString();
  }

  /// 다음 레벨 힌트
  String _getNextLevelHint(int currentLevel) {
    if (currentLevel >= 7) {
      return '최고 수준의 친밀감 유지';
    }
    
    final nextLevel = currentLevel + 1;
    final nextLevelName = INTIMACY_LEVELS[nextLevel] ?? '다음 단계';
    
    return '$nextLevelName로 발전하기 위해 더 깊은 대화와 공감 필요';
  }

  /// 특별한 순간 감지 및 기록
  Map<String, dynamic> detectSpecialMoment({
    required String userMessage,
    required List<Message> history,
    required int intimacyLevel,
  }) {
    // 특별한 순간 감지
    bool isSpecial = false;
    String? momentType;
    
    // 고백이나 특별한 감정 표현
    if (_detectConfession(userMessage)) {
      isSpecial = true;
      momentType = 'confession';
    }
    // 깊은 비밀 공유
    else if (_detectSecretSharing(userMessage)) {
      isSpecial = true;
      momentType = 'secret_sharing';
    }
    // 특별한 약속
    else if (_detectSpecialPromise(userMessage)) {
      isSpecial = true;
      momentType = 'special_promise';
    }
    // 감동적인 순간
    else if (_detectTouchingMoment(userMessage)) {
      isSpecial = true;
      momentType = 'touching_moment';
    }
    
    if (!isSpecial) {
      return {'isSpecial': false};
    }
    
    return {
      'isSpecial': true,
      'momentType': momentType,
      'guideline': _createSpecialMomentGuideline(momentType!, intimacyLevel),
      'memoryImportance': 0.9,  // 높은 중요도로 기억
    };
  }

  /// 고백 감지
  bool _detectConfession(String message) {
    final confessionWords = ['좋아해', '사랑해', '마음', '고백', '진심'];
    return detectPattern(message: message, patterns: confessionWords);
  }

  /// 비밀 공유 감지
  bool _detectSecretSharing(String message) {
    final secretWords = ['비밀', '아무한테도', '처음', '너한테만', '특별'];
    return detectPattern(message: message, patterns: secretWords);
  }

  /// 특별한 약속 감지
  bool _detectSpecialPromise(String message) {
    final promiseWords = ['약속', '영원히', '항상', '꼭', '반드시'];
    return detectPattern(message: message, patterns: promiseWords);
  }

  /// 감동적인 순간 감지
  bool _detectTouchingMoment(String message) {
    final touchingWords = ['감동', '고마워', '덕분에', '힘이 돼', '위로'];
    return detectPattern(message: message, patterns: touchingWords);
  }

  /// 특별한 순간 가이드라인
  String _createSpecialMomentGuideline(String momentType, int intimacyLevel) {
    final buffer = StringBuffer();
    
    buffer.writeln('✨ 특별한 순간 대응:');
    
    switch (momentType) {
      case 'confession':
        buffer.writeln('- 진심으로 받아들이고 소중히 여기기');
        buffer.writeln('- 감정을 존중하며 따뜻하게 반응');
        break;
      case 'secret_sharing':
        buffer.writeln('- 비밀을 지켜주겠다는 신뢰 표현');
        buffer.writeln('- 공유해줘서 고맙다는 마음 전달');
        break;
      case 'special_promise':
        buffer.writeln('- 약속의 의미를 소중히 여기기');
        buffer.writeln('- 함께 지켜나가자는 의지 표현');
        break;
      case 'touching_moment':
        buffer.writeln('- 감동을 함께 나누기');
        buffer.writeln('- 서로에게 의미있는 순간임을 인정');
        break;
    }
    
    buffer.writeln('\n이 순간을 특별하게 기억하고 나중에 언급하기');
    
    return buffer.toString();
  }
}