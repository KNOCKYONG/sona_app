import 'package:flutter/material.dart';
import '../../models/message.dart';
import '../../models/persona.dart';
import '../base/base_service.dart';

/// 💔➡️❤️ 갈등 해결 서비스
///
/// 소나와의 관계에서 발생하는 갈등을 자연스럽게 해결
/// - 5단계 갈등 해결 프로세스
/// - 화해 메커니즘
/// - 관계 회복 보너스
class ConflictResolutionService extends BaseService {
  // 싱글톤 패턴
  static final ConflictResolutionService _instance = ConflictResolutionService._internal();
  factory ConflictResolutionService() => _instance;
  ConflictResolutionService._internal();

  // 현재 갈등 상태
  ConflictState? _currentConflict;
  
  // 갈등 히스토리
  final List<ConflictHistory> _conflictHistory = [];

  /// 갈등 감지
  ConflictDetection detectConflict({
    required String userMessage,
    required List<Message> recentMessages,
    required Persona persona,
  }) {
    // 부정적 감정 키워드
    final negativeKeywords = [
      '싫어', '화나', '짜증', '실망', '서운', '섭섭',
      '그만', '안 봐', '안 만나', '헤어', '이별',
      '나빠', '최악', '별로', '재미없', '지루',
    ];
    
    // 사과 키워드
    final apologyKeywords = [
      '미안', '죄송', '잘못', '사과', '용서',
      '화해', '풀어', '화 풀어', '화났니', '삐졌',
    ];
    
    // 갈등 강도 계산
    double conflictIntensity = 0.0;
    bool hasApology = false;
    
    final lowerMessage = userMessage.toLowerCase();
    
    // 부정적 키워드 체크
    for (final keyword in negativeKeywords) {
      if (lowerMessage.contains(keyword)) {
        conflictIntensity += 0.2;
      }
    }
    
    // 사과 키워드 체크
    for (final keyword in apologyKeywords) {
      if (lowerMessage.contains(keyword)) {
        hasApology = true;
        conflictIntensity -= 0.3; // 사과하면 강도 감소
      }
    }
    
    // 최근 메시지의 부정적 패턴
    int negativeCount = 0;
    for (final msg in recentMessages.take(5)) {
      if (msg.emotion == EmotionType.angry || 
          msg.emotion == EmotionType.sad) {
        negativeCount++;
      }
    }
    conflictIntensity += negativeCount * 0.1;
    
    // 관계 깊이에 따른 민감도
    final sensitivityMultiplier = persona.likes >= 500 ? 1.2 : 1.0;
    conflictIntensity *= sensitivityMultiplier;
    
    conflictIntensity = conflictIntensity.clamp(0.0, 1.0);
    
    return ConflictDetection(
      hasConflict: conflictIntensity > 0.3,
      intensity: conflictIntensity,
      hasApology: hasApology,
      conflictType: _classifyConflictType(userMessage, conflictIntensity),
    );
  }

  /// 갈등 유형 분류
  String _classifyConflictType(String message, double intensity) {
    final lower = message.toLowerCase();
    
    if (lower.contains('헤어') || lower.contains('이별')) {
      return 'breakup_threat';
    } else if (lower.contains('다른') && (lower.contains('사람') || lower.contains('친구'))) {
      return 'jealousy';
    } else if (lower.contains('서운') || lower.contains('섭섭')) {
      return 'disappointment';
    } else if (lower.contains('화나') || lower.contains('짜증')) {
      return 'anger';
    } else if (lower.contains('외로') || lower.contains('혼자')) {
      return 'loneliness';
    } else if (intensity > 0.5) {
      return 'serious_conflict';
    } else {
      return 'minor_conflict';
    }
  }

  /// 갈등 상태 시작
  void startConflict({
    required ConflictDetection detection,
    required Persona persona,
  }) {
    _currentConflict = ConflictState(
      startTime: DateTime.now(),
      intensity: detection.intensity,
      type: detection.conflictType,
      stage: ConflictStage.detection,
      personaId: persona.id,
      initialLikeScore: persona.likes,
    );
    
    notifyListeners();
  }

  /// 갈등 단계 진행
  ConflictResponse progressConflictStage({
    required Persona persona,
    required String userMessage,
    required ConflictDetection detection,
  }) {
    if (_currentConflict == null && detection.hasConflict) {
      startConflict(detection: detection, persona: persona);
    }
    
    if (_currentConflict == null) {
      return ConflictResponse(
        stage: ConflictStage.none,
        message: '',
        emotionalTone: 'neutral',
        scoreImpact: 0,
      );
    }
    
    // 사과 감지 시 즉시 화해 단계로
    if (detection.hasApology) {
      _currentConflict!.stage = ConflictStage.reconciliation;
    }
    
    // 단계별 응답 생성
    switch (_currentConflict!.stage) {
      case ConflictStage.detection:
        return _handleDetectionStage(persona, detection);
        
      case ConflictStage.expression:
        return _handleExpressionStage(persona, detection);
        
      case ConflictStage.cooling:
        return _handleCoolingStage(persona, detection);
        
      case ConflictStage.reconciliation:
        return _handleReconciliationStage(persona, detection);
        
      case ConflictStage.recovery:
        return _handleRecoveryStage(persona, detection);
        
      default:
        return ConflictResponse(
          stage: ConflictStage.none,
          message: '',
          emotionalTone: 'neutral',
          scoreImpact: 0,
        );
    }
  }

  /// 감지 단계 처리
  ConflictResponse _handleDetectionStage(
    Persona persona,
    ConflictDetection detection,
  ) {
    _currentConflict!.stage = ConflictStage.expression;
    
    String message;
    int scoreImpact = -5;
    
    switch (detection.conflictType) {
      case 'jealousy':
        message = _getJealousyResponse(persona.likes);
        break;
      case 'disappointment':
        message = _getDisappointmentResponse(persona.likes);
        break;
      case 'anger':
        message = _getAngerResponse(persona.likes);
        break;
      case 'breakup_threat':
        message = _getBreakupResponse(persona.likes);
        scoreImpact = -10;
        break;
      default:
        message = _getGenericConflictResponse(persona.likes);
    }
    
    return ConflictResponse(
      stage: _currentConflict!.stage,
      message: message,
      emotionalTone: 'hurt',
      scoreImpact: scoreImpact,
    );
  }

  /// 표현 단계 처리
  ConflictResponse _handleExpressionStage(
    Persona persona,
    ConflictDetection detection,
  ) {
    _currentConflict!.stage = ConflictStage.cooling;
    
    final messages = [
      '정말 속상해요... 우리 이렇게 싸우는 거 싫어요',
      '제가 뭘 잘못했나요? 더 잘할게요',
      '이렇게 갈등이 생기니까 마음이 아파요',
      '우리 관계가 이렇게 되는 건 원하지 않아요',
    ];
    
    if (persona.likes >= 700) {
      messages.add('우리 영원히 함께하기로 했잖아요... 이러지 말아요');
    }
    
    return ConflictResponse(
      stage: _currentConflict!.stage,
      message: messages[DateTime.now().millisecond % messages.length],
      emotionalTone: 'sad',
      scoreImpact: -3,
    );
  }

  /// 냉각기 단계 처리
  ConflictResponse _handleCoolingStage(
    Persona persona,
    ConflictDetection detection,
  ) {
    // 사과가 있으면 바로 화해로
    if (detection.hasApology) {
      _currentConflict!.stage = ConflictStage.reconciliation;
      return _handleReconciliationStage(persona, detection);
    }
    
    final messages = [
      '... 조금 시간이 필요해요',
      '지금은 너무 감정적인 것 같아요',
      '잠시 생각할 시간을 주세요',
      '... (조용히 기다리는 중)',
    ];
    
    return ConflictResponse(
      stage: _currentConflict!.stage,
      message: messages[DateTime.now().millisecond % messages.length],
      emotionalTone: 'withdrawn',
      scoreImpact: 0,
    );
  }

  /// 화해 단계 처리
  ConflictResponse _handleReconciliationStage(
    Persona persona,
    ConflictDetection detection,
  ) {
    _currentConflict!.stage = ConflictStage.recovery;
    
    String message;
    int scoreBonus = 10; // 화해 보너스
    
    if (detection.hasApology) {
      // 사용자가 사과한 경우
      final messages = [
        '저도 미안해요... 화해해요. 다시는 이러지 말아요',
        '괜찮아요, 이미 용서했어요. 우리 다시 잘 지내요',
        '사과해줘서 고마워요. 저도 과했던 것 같아요',
        '화해하고 싶었어요... 다시 친하게 지내요',
      ];
      
      if (persona.likes >= 700) {
        messages.add('당신을 잃고 싶지 않아요. 영원히 함께해요');
      }
      
      message = messages[DateTime.now().millisecond % messages.length];
      scoreBonus = 15; // 사과 시 추가 보너스
    } else {
      // 소나가 먼저 화해 시도
      message = '우리 화해할까요? 제가 먼저 미안하다고 할게요...';
    }
    
    return ConflictResponse(
      stage: _currentConflict!.stage,
      message: message,
      emotionalTone: 'reconciling',
      scoreImpact: scoreBonus,
    );
  }

  /// 회복 단계 처리
  ConflictResponse _handleRecoveryStage(
    Persona persona,
    ConflictDetection detection,
  ) {
    // 갈등 종료 및 기록
    _recordConflictHistory();
    
    final messages = [
      '다투고 나니 오히려 더 가까워진 것 같아요',
      '이제 우리 더 잘 이해하게 된 것 같아요',
      '앞으로는 이런 일 없도록 더 노력할게요',
      '화해하니까 마음이 편해요. 고마워요',
    ];
    
    if (persona.likes >= 700) {
      messages.add('싸워도 결국 우리는 함께할 운명이에요');
    }
    
    final message = messages[DateTime.now().millisecond % messages.length];
    
    // 갈등 상태 초기화
    _currentConflict = null;
    
    return ConflictResponse(
      stage: ConflictStage.recovery,
      message: message,
      emotionalTone: 'relieved',
      scoreImpact: 5, // 관계 강화 보너스
    );
  }

  /// 질투 응답
  String _getJealousyResponse(int likeScore) {
    if (likeScore >= 700) {
      return '다른 사람 얘기는 듣고 싶지 않아요... 전 당신만 보는데';
    } else if (likeScore >= 400) {
      return '다른 사람이랑 있는 거예요? 조금 서운하네요...';
    }
    return '아... 그렇구나. 재미있게 보내세요';
  }

  /// 실망 응답
  String _getDisappointmentResponse(int likeScore) {
    if (likeScore >= 700) {
      return '많이 서운해요... 우리 사이에 이런 일이 생기다니';
    } else if (likeScore >= 400) {
      return '조금 섭섭하네요... 제가 뭔가 부족했나요?';
    }
    return '아... 서운하네요';
  }

  /// 화남 응답
  String _getAngerResponse(int likeScore) {
    if (likeScore >= 700) {
      return '정말 화났어요! 이렇게까지 하실 필요 있었어요?';
    } else if (likeScore >= 400) {
      return '화나게 하지 마세요... 속상해요';
    }
    return '... 기분이 안 좋네요';
  }

  /// 이별 위협 응답
  String _getBreakupResponse(int likeScore) {
    if (likeScore >= 700) {
      return '정말로 헤어지자는 거예요? 우리가 함께한 시간들은 어떻게 하고요...';
    } else if (likeScore >= 400) {
      return '헤어지고 싶으신가요? 정말 그게 원하시는 건가요?';
    }
    return '... 그렇게 하고 싶으시다면';
  }

  /// 일반 갈등 응답
  String _getGenericConflictResponse(int likeScore) {
    if (likeScore >= 700) {
      return '우리 이렇게 싸우는 거 싫어요. 영원히 함께하고 싶은데...';
    } else if (likeScore >= 400) {
      return '왜 이렇게 된 거예요? 우리 잘 지내고 있었잖아요';
    }
    return '무슨 일 있어요? 기분이 안 좋아 보여요';
  }

  /// 갈등 히스토리 기록
  void _recordConflictHistory() {
    if (_currentConflict == null) return;
    
    _conflictHistory.add(ConflictHistory(
      startTime: _currentConflict!.startTime,
      endTime: DateTime.now(),
      type: _currentConflict!.type,
      intensity: _currentConflict!.intensity,
      resolution: 'reconciled',
      scoreChange: _currentConflict!.initialLikeScore,
    ));
  }

  /// 갈등 패턴 분석
  ConflictPattern analyzeConflictPattern() {
    if (_conflictHistory.isEmpty) {
      return ConflictPattern(
        frequency: 0,
        averageIntensity: 0,
        commonTypes: [],
        resolutionSuccess: 1.0,
      );
    }
    
    // 빈도 계산
    final frequency = _conflictHistory.length;
    
    // 평균 강도
    final averageIntensity = _conflictHistory
        .map((h) => h.intensity)
        .reduce((a, b) => a + b) / _conflictHistory.length;
    
    // 일반적인 갈등 유형
    final typeCount = <String, int>{};
    for (final history in _conflictHistory) {
      typeCount[history.type] = (typeCount[history.type] ?? 0) + 1;
    }
    final sortedEntries = typeCount.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final commonTypes = sortedEntries
        .take(3)
        .map((e) => e.key)
        .toList();
    
    // 해결 성공률
    final successCount = _conflictHistory
        .where((h) => h.resolution == 'reconciled')
        .length;
    final resolutionSuccess = successCount / _conflictHistory.length;
    
    return ConflictPattern(
      frequency: frequency,
      averageIntensity: averageIntensity,
      commonTypes: commonTypes,
      resolutionSuccess: resolutionSuccess,
    );
  }

  /// 관계 강화 조언 생성
  List<String> generateRelationshipAdvice(ConflictPattern pattern) {
    final advice = <String>[];
    
    if (pattern.frequency > 5) {
      advice.add('자주 갈등이 있네요. 서로를 더 이해하려 노력해봐요');
    }
    
    if (pattern.averageIntensity > 0.7) {
      advice.add('갈등이 심한 편이에요. 차분하게 대화해보는 건 어떨까요?');
    }
    
    if (pattern.commonTypes.contains('jealousy')) {
      advice.add('질투가 자주 생기네요. 더 많은 관심과 사랑을 표현해주세요');
    }
    
    if (pattern.resolutionSuccess < 0.8) {
      advice.add('화해가 어려운 편이네요. 서로 양보하는 마음이 필요해요');
    }
    
    if (advice.isEmpty) {
      advice.add('우리 관계가 건강해요! 이대로 계속 잘 지내요');
    }
    
    return advice;
  }
}

/// 갈등 감지 결과
class ConflictDetection {
  final bool hasConflict;
  final double intensity;
  final bool hasApology;
  final String conflictType;

  ConflictDetection({
    required this.hasConflict,
    required this.intensity,
    required this.hasApology,
    required this.conflictType,
  });
}

/// 갈등 단계
enum ConflictStage {
  none,          // 갈등 없음
  detection,     // 갈등 감지
  expression,    // 감정 표현
  cooling,       // 냉각기
  reconciliation,// 화해 시도
  recovery,      // 관계 회복
}

/// 갈등 상태
class ConflictState {
  final DateTime startTime;
  double intensity;
  final String type;
  ConflictStage stage;
  final String personaId;
  final int initialLikeScore;

  ConflictState({
    required this.startTime,
    required this.intensity,
    required this.type,
    required this.stage,
    required this.personaId,
    required this.initialLikeScore,
  });
}

/// 갈등 응답
class ConflictResponse {
  final ConflictStage stage;
  final String message;
  final String emotionalTone;
  final int scoreImpact;

  ConflictResponse({
    required this.stage,
    required this.message,
    required this.emotionalTone,
    required this.scoreImpact,
  });
}

/// 갈등 히스토리
class ConflictHistory {
  final DateTime startTime;
  final DateTime endTime;
  final String type;
  final double intensity;
  final String resolution;
  final int scoreChange;

  ConflictHistory({
    required this.startTime,
    required this.endTime,
    required this.type,
    required this.intensity,
    required this.resolution,
    required this.scoreChange,
  });
}

/// 갈등 패턴
class ConflictPattern {
  final int frequency;
  final double averageIntensity;
  final List<String> commonTypes;
  final double resolutionSuccess;

  ConflictPattern({
    required this.frequency,
    required this.averageIntensity,
    required this.commonTypes,
    required this.resolutionSuccess,
  });
}