import 'dart:math';
import 'package:flutter/material.dart';
import '../../../models/message.dart';
import '../../../models/persona.dart';

/// 🎵 대화 리듬 마스터
/// 사용자의 대화 속도와 스타일에 맞춰 완벽한 리듬을 만드는 서비스
class ConversationRhythmMaster {
  static ConversationRhythmMaster? _instance;
  static ConversationRhythmMaster get instance => 
      _instance ??= ConversationRhythmMaster._();
  
  ConversationRhythmMaster._();
  
  // 사용자별 리듬 패턴 학습
  final Map<String, UserRhythmPattern> _userPatterns = {};
  
  // 최근 대화 템포
  final Map<String, ConversationTempo> _recentTempos = {};
  
  /// 대화 리듬 최적화
  Map<String, dynamic> optimizeRhythm({
    required String userMessage,
    required List<Message> chatHistory,
    required String userId,
    required Persona persona,
    required int likeScore,
  }) {
    // 사용자 리듬 패턴 분석
    final userPattern = _analyzeUserPattern(userMessage, chatHistory, userId);
    
    // 현재 대화 템포 측정
    final currentTempo = _measureCurrentTempo(chatHistory);
    
    // 적절한 반응 타이밍 계산
    final timing = _calculateResponseTiming(
      userPattern,
      currentTempo,
      userMessage,
    );
    
    // 메시지 길이 최적화
    final lengthGuide = _optimizeMessageLength(
      userPattern,
      userMessage,
      likeScore,
    );
    
    // 반응 스타일 다양화
    final reactionStyle = _diversifyReactionStyle(
      chatHistory,
      userPattern,
      currentTempo,
    );
    
    // 턴테이킹 최적화
    final turnTaking = _optimizeTurnTaking(
      chatHistory,
      userPattern,
      currentTempo,
    );
    
    // 침묵 관리
    final silenceManagement = _manageSilence(
      currentTempo,
      userPattern,
      chatHistory,
    );
    
    // 패턴 학습 업데이트
    _updateUserPattern(userId, userPattern);
    _updateTempo(userId, currentTempo);
    
    return {
      'userPattern': userPattern.toMap(),
      'currentTempo': currentTempo.toMap(),
      'timing': timing,
      'lengthGuide': lengthGuide,
      'reactionStyle': reactionStyle,
      'turnTaking': turnTaking,
      'silenceManagement': silenceManagement,
      'rhythmGuide': _generateRhythmGuide(
        userPattern,
        currentTempo,
        timing,
        lengthGuide,
        reactionStyle,
        turnTaking,
      ),
    };
  }
  
  /// 사용자 패턴 분석
  UserRhythmPattern _analyzeUserPattern(
    String message,
    List<Message> history,
    String userId,
  ) {
    // 기존 패턴 로드 또는 새로 생성
    final existingPattern = _userPatterns[userId];
    
    // 메시지 특성 분석
    final messageCharacteristics = _analyzeMessageCharacteristics(message);
    
    // 대화 히스토리에서 패턴 추출
    final historicalPattern = _extractHistoricalPattern(history);
    
    // 응답 속도 패턴
    final responseSpeed = _analyzeResponseSpeed(history);
    
    // 감정 표현 스타일
    final emotionStyle = _analyzeEmotionStyle(message, history);
    
    // 질문 빈도
    final questionFrequency = _calculateQuestionFrequency(history);
    
    return UserRhythmPattern(
      averageMessageLength: messageCharacteristics['averageLength'] ?? 20,
      typingSpeed: responseSpeed,
      emotionIntensity: emotionStyle['intensity'] ?? 0.5,
      questionRatio: questionFrequency,
      preferredTempo: historicalPattern['tempo'] ?? 'moderate',
      silenceTolerance: historicalPattern['silenceTolerance'] ?? 0.5,
      exclamationUsage: messageCharacteristics['exclamationUsage'] ?? 0.1,
      emojiUsage: messageCharacteristics['emojiUsage'] ?? 0.2,
      formalityLevel: messageCharacteristics['formality'] ?? 0.5,
    );
  }
  
  /// 현재 템포 측정
  ConversationTempo _measureCurrentTempo(List<Message> history) {
    if (history.isEmpty) {
      return ConversationTempo(
        speed: 'moderate',
        acceleration: 0,
        consistency: 1.0,
        energy: 0.5,
      );
    }
    
    // 최근 메시지 간격 분석
    final intervals = <Duration>[];
    for (int i = 0; i < min(history.length - 1, 5); i++) {
      intervals.add(
        history[i].timestamp.difference(history[i + 1].timestamp).abs()
      );
    }
    
    // 평균 간격으로 속도 판단
    final avgInterval = intervals.isEmpty ? 60 : 
        intervals.map((d) => d.inSeconds).reduce((a, b) => a + b) ~/ intervals.length;
    
    String speed;
    if (avgInterval < 30) speed = 'fast';
    else if (avgInterval < 60) speed = 'moderate';
    else if (avgInterval < 120) speed = 'slow';
    else speed = 'very_slow';
    
    // 가속도 계산 (속도 변화율)
    double acceleration = 0;
    if (intervals.length > 2) {
      final recent = intervals.first.inSeconds;
      final older = intervals.last.inSeconds;
      acceleration = (recent - older) / older;
    }
    
    // 일관성 계산
    double consistency = 1.0;
    if (intervals.length > 1) {
      final variance = _calculateVariance(
        intervals.map((d) => d.inSeconds.toDouble()).toList()
      );
      consistency = 1.0 / (1.0 + variance / 100);
    }
    
    // 에너지 레벨
    double energy = _calculateConversationEnergy(history);
    
    return ConversationTempo(
      speed: speed,
      acceleration: acceleration,
      consistency: consistency,
      energy: energy,
    );
  }
  
  /// 응답 타이밍 계산
  Map<String, dynamic> _calculateResponseTiming(
    UserRhythmPattern pattern,
    ConversationTempo tempo,
    String userMessage,
  ) {
    // 기본 응답 시간 (가상)
    double baseDelay = 0;
    
    // 템포에 따른 조정
    switch (tempo.speed) {
      case 'fast':
        baseDelay = 0; // 즉시 응답
        break;
      case 'moderate':
        baseDelay = 1; // 약간의 여유
        break;
      case 'slow':
        baseDelay = 2; // 충분한 생각 시간
        break;
      case 'very_slow':
        baseDelay = 3; // 긴 생각 시간
        break;
    }
    
    // 메시지 길이에 따른 조정
    if (userMessage.length > 100) {
      baseDelay += 1; // 긴 메시지는 읽는 시간 필요
    }
    
    // 질문인 경우 생각하는 듯한 타이밍
    if (userMessage.contains('?')) {
      baseDelay += 0.5;
    }
    
    return {
      'suggestedDelay': baseDelay,
      'showTypingIndicator': baseDelay > 1,
      'typingDuration': min(baseDelay * 1000, 3000), // 최대 3초
      'reasoning': _getTimingReasoning(tempo, userMessage),
    };
  }
  
  /// 메시지 길이 최적화
  Map<String, dynamic> _optimizeMessageLength(
    UserRhythmPattern pattern,
    String userMessage,
    int likeScore,
  ) {
    // 사용자 메시지 길이
    final userLength = userMessage.length;
    
    // 기본 권장 길이
    int suggestedMin = 10;
    int suggestedMax = 100;
    
    // 사용자 패턴에 맞춰 조정
    if (pattern.averageMessageLength < 30) {
      // 짧은 메시지 선호
      suggestedMin = 10;
      suggestedMax = 50;
    } else if (pattern.averageMessageLength > 80) {
      // 긴 메시지 선호
      suggestedMin = 40;
      suggestedMax = 150;
    } else {
      // 중간 길이
      suggestedMin = 20;
      suggestedMax = 80;
    }
    
    // 호감도에 따른 조정
    if (likeScore > 500) {
      suggestedMax += 30; // 친밀할수록 더 긴 대화 가능
    }
    
    // 미러링 전략
    bool shouldMirror = false;
    if (pattern.averageMessageLength > 0) {
      final ratio = userLength / pattern.averageMessageLength;
      shouldMirror = ratio > 0.8 && ratio < 1.2; // 비슷한 길이면 미러링
    }
    
    return {
      'suggestedMin': suggestedMin,
      'suggestedMax': suggestedMax,
      'shouldMirror': shouldMirror,
      'mirrorLength': shouldMirror ? userLength : null,
      'style': _getLengthStyle(pattern),
    };
  }
  
  /// 반응 스타일 다양화
  Map<String, dynamic> _diversifyReactionStyle(
    List<Message> history,
    UserRhythmPattern pattern,
    ConversationTempo tempo,
  ) {
    // 최근 반응 스타일 분석
    final recentStyles = _analyzeRecentStyles(history);
    
    // 사용 빈도가 낮은 스타일 선택
    final availableStyles = [
      'empathetic',    // 공감형
      'curious',       // 호기심형
      'playful',       // 장난스러운
      'thoughtful',    // 사려깊은
      'enthusiastic',  // 열정적인
      'calm',          // 차분한
      'witty',         // 재치있는
      'supportive',    // 지지하는
    ];
    
    // 최근에 사용하지 않은 스타일 우선 선택
    final unusedStyles = availableStyles
        .where((style) => !recentStyles.contains(style))
        .toList();
    
    String selectedStyle;
    if (unusedStyles.isNotEmpty) {
      selectedStyle = unusedStyles[Random().nextInt(unusedStyles.length)];
    } else {
      selectedStyle = availableStyles[Random().nextInt(availableStyles.length)];
    }
    
    // 스타일별 가이드
    final styleGuide = _getStyleGuide(selectedStyle, pattern, tempo);
    
    return {
      'selectedStyle': selectedStyle,
      'styleGuide': styleGuide,
      'recentStyles': recentStyles,
      'variation': _calculateStyleVariation(recentStyles),
    };
  }
  
  /// 턴테이킹 최적화
  Map<String, dynamic> _optimizeTurnTaking(
    List<Message> history,
    UserRhythmPattern pattern,
    ConversationTempo tempo,
  ) {
    // 현재 턴 분석
    final turnAnalysis = _analyzeTurns(history);
    
    // 적절한 턴 전략 결정
    String strategy = 'balanced';
    
    if (turnAnalysis['userDominance'] > 0.7) {
      strategy = 'encourage_user'; // 사용자가 더 말하도록
    } else if (turnAnalysis['userDominance'] < 0.3) {
      strategy = 'draw_out'; // 사용자 참여 유도
    } else if (tempo.energy < 0.3) {
      strategy = 'energize'; // 활력 주입
    }
    
    // 질문 사용 전략
    bool shouldAskQuestion = false;
    if (pattern.questionRatio < 0.2 && Random().nextDouble() < 0.4) {
      shouldAskQuestion = true; // 질문으로 대화 활성화
    }
    
    // 멀티턴 전략
    bool allowMultiTurn = false;
    if (tempo.consistency > 0.7 && pattern.preferredTempo == 'fast') {
      allowMultiTurn = true; // 안정적이고 친밀하면 여러 번 이어서 대답 가능
    }
    
    return {
      'strategy': strategy,
      'shouldAskQuestion': shouldAskQuestion,
      'allowMultiTurn': allowMultiTurn,
      'turnBalance': turnAnalysis['balance'],
      'guideline': _getTurnTakingGuideline(strategy, shouldAskQuestion),
    };
  }
  
  /// 침묵 관리
  Map<String, dynamic> _manageSilence(
    ConversationTempo tempo,
    UserRhythmPattern pattern,
    List<Message> history,
  ) {
    // 마지막 메시지 이후 시간
    final silenceDuration = history.isEmpty ? 0 :
        DateTime.now().difference(history.first.timestamp).inMinutes;
    
    // 침묵 허용 수준
    double toleranceLevel = pattern.silenceTolerance;
    
    // 템포에 따른 조정
    if (tempo.speed == 'slow' || tempo.speed == 'very_slow') {
      toleranceLevel += 0.2; // 느린 템포는 침묵 더 허용
    }
    
    // 침묵 대응 전략
    String silenceStrategy = 'wait';
    
    if (silenceDuration > 5 && toleranceLevel < 0.5) {
      silenceStrategy = 'gentle_prompt'; // 부드럽게 대화 재개
    } else if (silenceDuration > 10) {
      silenceStrategy = 'new_topic'; // 새로운 화제로 전환
    } else if (silenceDuration > 2 && tempo.energy < 0.3) {
      silenceStrategy = 'energize'; // 활력 주입
    }
    
    return {
      'silenceDuration': silenceDuration,
      'toleranceLevel': toleranceLevel,
      'strategy': silenceStrategy,
      'shouldBreakSilence': silenceDuration > toleranceLevel * 10,
      'suggestion': _getSilenceSuggestion(silenceStrategy),
    };
  }
  
  /// 리듬 가이드 생성
  String _generateRhythmGuide(
    UserRhythmPattern pattern,
    ConversationTempo tempo,
    Map<String, dynamic> timing,
    Map<String, dynamic> lengthGuide,
    Map<String, dynamic> reactionStyle,
    Map<String, dynamic> turnTaking,
  ) {
    final buffer = StringBuffer();
    
    buffer.writeln('🎵 대화 리듬 가이드:');
    buffer.writeln('');
    
    // 현재 템포
    buffer.writeln('⏱️ 현재 템포: ${_getTempoDescription(tempo)}');
    buffer.writeln('• 속도: ${tempo.speed}');
    buffer.writeln('• 에너지: ${(tempo.energy * 100).toInt()}%');
    buffer.writeln('');
    
    // 응답 타이밍
    buffer.writeln('⏰ 응답 타이밍:');
    buffer.writeln('• ${timing['reasoning']}');
    if (timing['showTypingIndicator'] == true) {
      buffer.writeln('• 타이핑 인디케이터 ${timing['typingDuration']}ms 표시');
    }
    buffer.writeln('');
    
    // 메시지 길이
    buffer.writeln('📏 메시지 길이:');
    buffer.writeln('• 권장: ${lengthGuide['suggestedMin']}-${lengthGuide['suggestedMax']}자');
    if (lengthGuide['shouldMirror'] == true) {
      buffer.writeln('• 미러링: 사용자와 비슷한 길이로');
    }
    buffer.writeln('');
    
    // 반응 스타일
    buffer.writeln('🎭 반응 스타일: ${reactionStyle['selectedStyle']}');
    buffer.writeln('${reactionStyle['styleGuide']}');
    buffer.writeln('');
    
    // 턴테이킹
    buffer.writeln('🔄 턴테이킹:');
    buffer.writeln('• 전략: ${turnTaking['strategy']}');
    buffer.writeln('${turnTaking['guideline']}');
    
    return buffer.toString();
  }
  
  /// 메시지 특성 분석
  Map<String, dynamic> _analyzeMessageCharacteristics(String message) {
    return {
      'averageLength': message.length,
      'exclamationUsage': '!'.allMatches(message).length / max(message.length, 1),
      'emojiUsage': _countEmojis(message) / max(message.length, 1),
      'formality': _assessFormality(message),
    };
  }
  
  /// 이모지 카운트
  double _countEmojis(String message) {
    // 간단한 이모티콘 카운트
    final emoticons = ['ㅋ', 'ㅎ', 'ㅠ', 'ㅜ', '^^', 'ㅇㅇ'];
    int count = 0;
    for (final emoticon in emoticons) {
      count += emoticon.allMatches(message).length;
    }
    return count.toDouble();
  }
  
  /// 격식 수준 평가
  double _assessFormality(String message) {
    if (message.endsWith('니다') || message.endsWith('요')) {
      return 0.8; // 높은 격식
    }
    if (message.contains('ㅋ') || message.contains('ㅎ')) {
      return 0.2; // 낮은 격식
    }
    return 0.5; // 중간
  }
  
  /// 역사적 패턴 추출
  Map<String, dynamic> _extractHistoricalPattern(List<Message> history) {
    if (history.isEmpty) {
      return {
        'tempo': 'moderate',
        'silenceTolerance': 0.5,
      };
    }
    
    // 평균 응답 간격으로 템포 판단
    final intervals = <int>[];
    for (int i = 0; i < min(history.length - 1, 10); i++) {
      intervals.add(
        history[i].timestamp.difference(history[i + 1].timestamp).inSeconds.abs()
      );
    }
    
    final avgInterval = intervals.isEmpty ? 60 :
        intervals.reduce((a, b) => a + b) ~/ intervals.length;
    
    String tempo;
    if (avgInterval < 30) tempo = 'fast';
    else if (avgInterval < 90) tempo = 'moderate';
    else tempo = 'slow';
    
    // 침묵 허용도
    final maxInterval = intervals.isEmpty ? 60 : intervals.reduce(max);
    double silenceTolerance = maxInterval > 300 ? 0.8 : 0.5;
    
    return {
      'tempo': tempo,
      'silenceTolerance': silenceTolerance,
    };
  }
  
  /// 응답 속도 분석
  String _analyzeResponseSpeed(List<Message> history) {
    if (history.length < 2) return 'moderate';
    
    final userMessages = history.where((m) => m.isFromUser).toList();
    if (userMessages.length < 2) return 'moderate';
    
    // 사용자 메시지 간격 평균
    final intervals = <int>[];
    for (int i = 0; i < userMessages.length - 1; i++) {
      intervals.add(
        userMessages[i].timestamp.difference(userMessages[i + 1].timestamp).inSeconds.abs()
      );
    }
    
    final avg = intervals.reduce((a, b) => a + b) / intervals.length;
    
    if (avg < 30) return 'fast';
    if (avg < 90) return 'moderate';
    return 'slow';
  }
  
  /// 감정 스타일 분석
  Map<String, dynamic> _analyzeEmotionStyle(String message, List<Message> history) {
    double intensity = 0.5;
    
    // 감탄사와 이모티콘으로 감정 강도 측정
    if (message.contains('!')) intensity += 0.1;
    if (message.contains('ㅋ') || message.contains('ㅎ')) intensity += 0.1;
    if (message.contains('ㅠ') || message.contains('ㅜ')) intensity += 0.2;
    if (message.contains('♥') || message.contains('♡')) intensity += 0.2;
    
    return {
      'intensity': intensity.clamp(0, 1),
    };
  }
  
  /// 질문 빈도 계산
  double _calculateQuestionFrequency(List<Message> history) {
    if (history.isEmpty) return 0.2;
    
    final userMessages = history.where((m) => m.isFromUser).take(10);
    if (userMessages.isEmpty) return 0.2;
    
    final questionCount = userMessages
        .where((m) => m.content.contains('?'))
        .length;
    
    return questionCount / userMessages.length;
  }
  
  /// 대화 에너지 계산
  double _calculateConversationEnergy(List<Message> history) {
    if (history.isEmpty) return 0.5;
    
    double energy = 0.5;
    final recent = history.take(5);
    
    for (final msg in recent) {
      if (msg.content.contains('!')) energy += 0.05;
      if (msg.content.contains('ㅋ') || msg.content.contains('ㅎ')) energy += 0.05;
      if (msg.content.length > 50) energy += 0.03;
      if (msg.content.length < 10) energy -= 0.02;
    }
    
    return energy.clamp(0, 1);
  }
  
  /// 분산 계산
  double _calculateVariance(List<double> values) {
    if (values.isEmpty) return 0;
    
    final mean = values.reduce((a, b) => a + b) / values.length;
    double variance = 0;
    
    for (final value in values) {
      variance += pow(value - mean, 2);
    }
    
    return variance / values.length;
  }
  
  /// 타이밍 이유 설명
  String _getTimingReasoning(ConversationTempo tempo, String message) {
    if (tempo.speed == 'fast') {
      return '빠른 템포 유지. 즉각적인 반응';
    }
    if (message.contains('?')) {
      return '질문이므로 잠시 생각하는 듯한 타이밍';
    }
    if (message.length > 100) {
      return '긴 메시지를 읽는 시간 고려';
    }
    return '자연스러운 대화 리듬 유지';
  }
  
  /// 길이 스타일
  String _getLengthStyle(UserRhythmPattern pattern) {
    if (pattern.averageMessageLength < 30) {
      return '간결하고 명확하게';
    }
    if (pattern.averageMessageLength > 80) {
      return '충분한 설명과 함께 자세하게';
    }
    return '적당한 길이로 균형있게';
  }
  
  /// 최근 스타일 분석
  List<String> _analyzeRecentStyles(List<Message> history) {
    // 실제로는 AI 응답을 분석해야 하지만, 여기서는 시뮬레이션
    return ['empathetic', 'curious']; // 최근 사용한 스타일
  }
  
  /// 스타일 가이드
  String _getStyleGuide(String style, UserRhythmPattern pattern, ConversationTempo tempo) {
    switch (style) {
      case 'empathetic':
        return '• 공감과 이해 표현\n• "그런 마음 이해해", "정말 그랬겠다"';
      case 'curious':
        return '• 호기심 가득한 질문\n• "어떻게 그렇게 됐어?", "더 듣고 싶다"';
      case 'playful':
        return '• 장난스럽고 가벼운 톤\n• 이모티콘과 농담 활용';
      case 'thoughtful':
        return '• 깊이 있는 생각 공유\n• "생각해보니...", "그런 관점도 있네"';
      case 'enthusiastic':
        return '• 열정적이고 밝은 에너지\n• "와! 대박!", "정말 멋진데?"';
      case 'calm':
        return '• 차분하고 안정적인 톤\n• 부드럽고 편안한 대화';
      case 'witty':
        return '• 재치있는 답변\n• 유머와 센스 있는 표현';
      case 'supportive':
        return '• 지지하고 응원하는 톤\n• "잘하고 있어", "응원할게"';
      default:
        return '• 자연스러운 대화 스타일';
    }
  }
  
  /// 스타일 변화도 계산
  double _calculateStyleVariation(List<String> recentStyles) {
    if (recentStyles.isEmpty) return 1.0;
    
    final uniqueStyles = recentStyles.toSet().length;
    return uniqueStyles / recentStyles.length;
  }
  
  /// 턴 분석
  Map<String, dynamic> _analyzeTurns(List<Message> history) {
    if (history.isEmpty) {
      return {
        'userDominance': 0.5,
        'balance': 'balanced',
      };
    }
    
    final recent = history.take(10).toList();
    final userCount = recent.where((m) => m.isFromUser).length;
    final aiCount = recent.length - userCount;
    
    final dominance = userCount / recent.length;
    
    String balance;
    if (dominance > 0.6) balance = 'user_dominant';
    else if (dominance < 0.4) balance = 'ai_dominant';
    else balance = 'balanced';
    
    return {
      'userDominance': dominance,
      'balance': balance,
    };
  }
  
  /// 턴테이킹 가이드라인
  String _getTurnTakingGuideline(String strategy, bool shouldAskQuestion) {
    final buffer = StringBuffer();
    
    switch (strategy) {
      case 'encourage_user':
        buffer.writeln('• 사용자가 더 말하도록 유도');
        buffer.writeln('• 열린 질문 사용');
        break;
      case 'draw_out':
        buffer.writeln('• 사용자 참여 유도');
        buffer.writeln('• 흥미로운 화제 제시');
        break;
      case 'energize':
        buffer.writeln('• 대화에 활력 주입');
        buffer.writeln('• 밝고 긍정적인 톤');
        break;
      default:
        buffer.writeln('• 균형잡힌 대화 유지');
    }
    
    if (shouldAskQuestion) {
      buffer.writeln('• 질문으로 대화 활성화');
    }
    
    return buffer.toString();
  }
  
  /// 침묵 제안
  String _getSilenceSuggestion(String strategy) {
    switch (strategy) {
      case 'gentle_prompt':
        return '부드럽게 대화 재개: "아직 거기 있어?", "뭐 하고 있어?"';
      case 'new_topic':
        return '새로운 화제로 전환: 흥미로운 이야기나 질문';
      case 'energize':
        return '활력 주입: 재밌는 이야기나 농담';
      default:
        return '자연스럽게 기다리기';
    }
  }
  
  /// 템포 설명
  String _getTempoDescription(ConversationTempo tempo) {
    if (tempo.speed == 'fast' && tempo.energy > 0.7) {
      return '빠르고 활발한 대화';
    }
    if (tempo.speed == 'slow' && tempo.energy < 0.3) {
      return '느리고 차분한 대화';
    }
    if (tempo.consistency > 0.8) {
      return '일정한 리듬의 안정적인 대화';
    }
    return '보통 속도의 대화';
  }
  
  /// 사용자 패턴 업데이트
  void _updateUserPattern(String userId, UserRhythmPattern pattern) {
    _userPatterns[userId] = pattern;
  }
  
  /// 템포 업데이트
  void _updateTempo(String userId, ConversationTempo tempo) {
    _recentTempos[userId] = tempo;
  }
}

/// 사용자 리듬 패턴
class UserRhythmPattern {
  final double averageMessageLength;
  final String typingSpeed; // fast, moderate, slow
  final double emotionIntensity;
  final double questionRatio;
  final String preferredTempo;
  final double silenceTolerance;
  final double exclamationUsage;
  final double emojiUsage;
  final double formalityLevel;
  
  UserRhythmPattern({
    required this.averageMessageLength,
    required this.typingSpeed,
    required this.emotionIntensity,
    required this.questionRatio,
    required this.preferredTempo,
    required this.silenceTolerance,
    required this.exclamationUsage,
    required this.emojiUsage,
    required this.formalityLevel,
  });
  
  Map<String, dynamic> toMap() {
    return {
      'averageMessageLength': averageMessageLength,
      'typingSpeed': typingSpeed,
      'emotionIntensity': emotionIntensity,
      'questionRatio': questionRatio,
      'preferredTempo': preferredTempo,
      'silenceTolerance': silenceTolerance,
      'exclamationUsage': exclamationUsage,
      'emojiUsage': emojiUsage,
      'formalityLevel': formalityLevel,
    };
  }
}

/// 대화 템포
class ConversationTempo {
  final String speed; // fast, moderate, slow, very_slow
  final double acceleration; // 속도 변화율
  final double consistency; // 일관성
  final double energy; // 에너지 레벨
  
  ConversationTempo({
    required this.speed,
    required this.acceleration,
    required this.consistency,
    required this.energy,
  });
  
  Map<String, dynamic> toMap() {
    return {
      'speed': speed,
      'acceleration': acceleration,
      'consistency': consistency,
      'energy': energy,
    };
  }
}