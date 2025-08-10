import 'dart:math';
import 'package:flutter/material.dart';
import '../../../models/message.dart';
import '../../../models/persona.dart';

/// 🔄 실시간 대화 피드백 시스템
/// 대화 중 실시간으로 피드백을 제공하고 메타 대화를 가능하게 하는 서비스
class RealtimeFeedbackService {
  static RealtimeFeedbackService? _instance;
  static RealtimeFeedbackService get instance => 
      _instance ??= RealtimeFeedbackService._();
  
  RealtimeFeedbackService._();
  
  // 대화 품질 추적
  final Map<String, ConversationQuality> _qualityTracking = {};
  
  // 실시간 신호 감지
  final Map<String, List<ConversationSignal>> _signalHistory = {};
  
  // 메타 대화 상태
  final Map<String, MetaConversationState> _metaStates = {};
  
  /// 실시간 피드백 생성
  Map<String, dynamic> generateRealtimeFeedback({
    required String userMessage,
    required List<Message> chatHistory,
    required String userId,
    required Persona persona,
    required int likeScore,
    String? lastAIResponse,
  }) {
    // 대화 신호 감지
    final signals = _detectConversationSignals(userMessage, chatHistory);
    
    // 대화 품질 평가
    final quality = _assessConversationQuality(
      chatHistory,
      signals,
      userId,
    );
    
    // 메타 대화 기회 감지
    final metaOpportunity = _detectMetaConversationOpportunity(
      userMessage,
      signals,
      quality,
    );
    
    // 실시간 조정 제안
    final adjustments = _suggestRealtimeAdjustments(
      signals,
      quality,
      persona,
      likeScore,
    );
    
    // 피드백 신호 처리
    final feedbackSignals = _processFeedbackSignals(
      userMessage,
      lastAIResponse,
      chatHistory,
    );
    
    // 대화 개선 제안
    final improvements = _generateImprovementSuggestions(
      quality,
      signals,
      feedbackSignals,
    );
    
    // 상태 업데이트
    _updateSignalHistory(userId, signals);
    _updateQualityTracking(userId, quality);
    
    // 메타 대화 처리
    Map<String, dynamic>? metaConversation;
    if (metaOpportunity['shouldInitiate'] == true) {
      metaConversation = _handleMetaConversation(
        userId,
        metaOpportunity,
        quality,
        persona,
      );
    }
    
    return {
      'signals': signals.map((s) => s.toMap()).toList(),
      'quality': quality.toMap(),
      'metaOpportunity': metaOpportunity,
      'adjustments': adjustments,
      'feedbackSignals': feedbackSignals,
      'improvements': improvements,
      'metaConversation': metaConversation,
      'feedbackGuide': _generateFeedbackGuide(
        signals,
        quality,
        adjustments,
        improvements,
        metaConversation,
      ),
    };
  }
  
  /// 대화 신호 감지
  List<ConversationSignal> _detectConversationSignals(
    String message,
    List<Message> history,
  ) {
    final signals = <ConversationSignal>[];
    
    // 혼란 신호
    if (_detectConfusion(message)) {
      signals.add(ConversationSignal(
        type: 'confusion',
        strength: _measureConfusionStrength(message),
        indicator: _getConfusionIndicator(message),
        timestamp: DateTime.now(),
      ));
    }
    
    // 불만족 신호
    if (_detectDissatisfaction(message)) {
      signals.add(ConversationSignal(
        type: 'dissatisfaction',
        strength: _measureDissatisfactionStrength(message),
        indicator: _getDissatisfactionIndicator(message),
        timestamp: DateTime.now(),
      ));
    }
    
    // 흥미 상실 신호
    if (_detectLossOfInterest(message, history)) {
      signals.add(ConversationSignal(
        type: 'loss_of_interest',
        strength: _measureInterestLoss(message, history),
        indicator: '짧은 응답, 감소하는 참여도',
        timestamp: DateTime.now(),
      ));
    }
    
    // 긍정적 신호
    if (_detectPositiveEngagement(message)) {
      signals.add(ConversationSignal(
        type: 'positive_engagement',
        strength: _measurePositiveEngagement(message),
        indicator: _getPositiveIndicator(message),
        timestamp: DateTime.now(),
      ));
    }
    
    // 도움 요청 신호
    if (_detectHelpRequest(message)) {
      signals.add(ConversationSignal(
        type: 'help_request',
        strength: 0.8,
        indicator: '명시적 도움 요청',
        timestamp: DateTime.now(),
      ));
    }
    
    // 주제 전환 신호
    if (_detectTopicChange(message, history)) {
      signals.add(ConversationSignal(
        type: 'topic_change',
        strength: 0.6,
        indicator: '급격한 주제 변경',
        timestamp: DateTime.now(),
      ));
    }
    
    return signals;
  }
  
  /// 대화 품질 평가
  ConversationQuality _assessConversationQuality(
    List<Message> history,
    List<ConversationSignal> signals,
    String userId,
  ) {
    // 기본 점수
    double engagement = 0.5;
    double satisfaction = 0.5;
    double flow = 0.5;
    double depth = 0.5;
    double authenticity = 0.5;
    
    // 히스토리 분석
    if (history.isNotEmpty) {
      // 참여도: 메시지 길이와 빈도
      engagement = _calculateEngagement(history);
      
      // 만족도: 긍정적 신호 비율
      satisfaction = _calculateSatisfaction(signals, history);
      
      // 흐름: 대화 연속성
      flow = _calculateFlow(history);
      
      // 깊이: 주제 탐구 수준
      depth = _calculateDepth(history);
      
      // 진정성: 자연스러움
      authenticity = _calculateAuthenticity(history);
    }
    
    // 신호 기반 조정
    for (final signal in signals) {
      switch (signal.type) {
        case 'confusion':
          flow -= signal.strength * 0.2;
          satisfaction -= signal.strength * 0.1;
          break;
        case 'dissatisfaction':
          satisfaction -= signal.strength * 0.3;
          engagement -= signal.strength * 0.1;
          break;
        case 'loss_of_interest':
          engagement -= signal.strength * 0.3;
          flow -= signal.strength * 0.1;
          break;
        case 'positive_engagement':
          engagement += signal.strength * 0.2;
          satisfaction += signal.strength * 0.2;
          break;
      }
    }
    
    // 정규화
    engagement = engagement.clamp(0, 1);
    satisfaction = satisfaction.clamp(0, 1);
    flow = flow.clamp(0, 1);
    depth = depth.clamp(0, 1);
    authenticity = authenticity.clamp(0, 1);
    
    // 전체 품질 점수
    final overall = (engagement + satisfaction + flow + depth + authenticity) / 5;
    
    return ConversationQuality(
      engagement: engagement,
      satisfaction: satisfaction,
      flow: flow,
      depth: depth,
      authenticity: authenticity,
      overall: overall,
      timestamp: DateTime.now(),
    );
  }
  
  /// 메타 대화 기회 감지
  Map<String, dynamic> _detectMetaConversationOpportunity(
    String message,
    List<ConversationSignal> signals,
    ConversationQuality quality,
  ) {
    bool shouldInitiate = false;
    String? reason;
    String? suggestion;
    
    // 직접적인 메타 질문
    if (_isMetaQuestion(message)) {
      shouldInitiate = true;
      reason = 'direct_meta_question';
      suggestion = '대화에 대한 직접적인 피드백 제공';
    }
    
    // 품질 저하
    else if (quality.overall < 0.4) {
      shouldInitiate = true;
      reason = 'low_quality';
      suggestion = '대화 개선을 위한 체크인';
    }
    
    // 반복되는 혼란
    else if (signals.where((s) => s.type == 'confusion').length > 2) {
      shouldInitiate = true;
      reason = 'repeated_confusion';
      suggestion = '이해도 확인 및 조정';
    }
    
    // 만족도 하락
    else if (quality.satisfaction < 0.3) {
      shouldInitiate = true;
      reason = 'low_satisfaction';
      suggestion = '대화 방식 개선 제안';
    }
    
    return {
      'shouldInitiate': shouldInitiate,
      'reason': reason,
      'suggestion': suggestion,
      'confidence': shouldInitiate ? 0.8 : 0.0,
    };
  }
  
  /// 실시간 조정 제안
  Map<String, dynamic> _suggestRealtimeAdjustments(
    List<ConversationSignal> signals,
    ConversationQuality quality,
    Persona persona,
    int likeScore,
  ) {
    final adjustments = <String, dynamic>{};
    
    // 톤 조정
    if (signals.any((s) => s.type == 'confusion')) {
      adjustments['tone'] = {
        'current': 'complex',
        'suggested': 'simple_clear',
        'reason': '혼란 신호 감지됨',
      };
    }
    
    // 속도 조정
    if (quality.flow < 0.4) {
      adjustments['pace'] = {
        'current': 'fast',
        'suggested': 'slower',
        'reason': '대화 흐름 개선 필요',
      };
    }
    
    // 깊이 조정
    if (quality.depth < 0.3 && likeScore > 300) {
      adjustments['depth'] = {
        'current': 'surface',
        'suggested': 'deeper',
        'reason': '더 깊은 대화 가능',
      };
    }
    
    // 스타일 조정
    if (quality.authenticity < 0.5) {
      adjustments['style'] = {
        'current': 'formal',
        'suggested': 'natural',
        'reason': '자연스러움 향상 필요',
      };
    }
    
    // 참여 전략
    if (quality.engagement < 0.4) {
      adjustments['engagement'] = {
        'strategy': 'increase_interactivity',
        'methods': ['질문 늘리기', '흥미로운 화제', '개인화'],
      };
    }
    
    return adjustments;
  }
  
  /// 피드백 신호 처리
  Map<String, dynamic> _processFeedbackSignals(
    String userMessage,
    String? lastAIResponse,
    List<Message> history,
  ) {
    final feedback = <String, dynamic>{};
    
    // 명시적 피드백
    if (userMessage.contains('좋') || userMessage.contains('맞')) {
      feedback['explicit'] = 'positive';
      feedback['confidence'] = 0.8;
    } else if (userMessage.contains('아니') || userMessage.contains('틀')) {
      feedback['explicit'] = 'negative';
      feedback['confidence'] = 0.8;
    }
    
    // 암시적 피드백
    if (userMessage.length < 5 && !userMessage.contains('?')) {
      feedback['implicit'] = 'low_engagement';
      feedback['confidence'] = 0.6;
    } else if (userMessage.contains('ㅋ') || userMessage.contains('ㅎ')) {
      feedback['implicit'] = 'positive_mood';
      feedback['confidence'] = 0.7;
    }
    
    // 반응 패턴
    if (lastAIResponse != null) {
      final reactionTime = _estimateReactionTime(userMessage, lastAIResponse);
      feedback['reactionTime'] = reactionTime;
      
      if (reactionTime == 'immediate') {
        feedback['engagement_level'] = 'high';
      } else if (reactionTime == 'delayed') {
        feedback['engagement_level'] = 'low';
      }
    }
    
    return feedback;
  }
  
  /// 개선 제안 생성
  List<ImprovementSuggestion> _generateImprovementSuggestions(
    ConversationQuality quality,
    List<ConversationSignal> signals,
    Map<String, dynamic> feedbackSignals,
  ) {
    final suggestions = <ImprovementSuggestion>[];
    
    // 참여도 개선
    if (quality.engagement < 0.5) {
      suggestions.add(ImprovementSuggestion(
        area: 'engagement',
        priority: 'high',
        suggestion: '더 흥미로운 질문이나 화제 제시',
        implementation: '개인 관심사 활용, 열린 질문 사용',
      ));
    }
    
    // 만족도 개선
    if (quality.satisfaction < 0.5) {
      suggestions.add(ImprovementSuggestion(
        area: 'satisfaction',
        priority: 'high',
        suggestion: '응답 품질 향상',
        implementation: '더 구체적이고 개인화된 답변',
      ));
    }
    
    // 흐름 개선
    if (quality.flow < 0.5) {
      suggestions.add(ImprovementSuggestion(
        area: 'flow',
        priority: 'medium',
        suggestion: '대화 연속성 강화',
        implementation: '이전 대화 참조, 자연스러운 전환',
      ));
    }
    
    // 깊이 개선
    if (quality.depth < 0.5) {
      suggestions.add(ImprovementSuggestion(
        area: 'depth',
        priority: 'low',
        suggestion: '더 깊은 탐구',
        implementation: '후속 질문, 상세 설명 요청',
      ));
    }
    
    // 신호 기반 제안
    if (signals.any((s) => s.type == 'confusion')) {
      suggestions.add(ImprovementSuggestion(
        area: 'clarity',
        priority: 'high',
        suggestion: '명확성 향상',
        implementation: '간단한 언어, 예시 제공',
      ));
    }
    
    return suggestions;
  }
  
  /// 메타 대화 처리
  Map<String, dynamic> _handleMetaConversation(
    String userId,
    Map<String, dynamic> opportunity,
    ConversationQuality quality,
    Persona persona,
  ) {
    // 메타 상태 가져오기 또는 생성
    _metaStates[userId] ??= MetaConversationState();
    final metaState = _metaStates[userId]!;
    
    // 메타 대화 유형 결정
    String metaType = 'check_in';
    String approach = 'gentle';
    
    switch (opportunity['reason']) {
      case 'direct_meta_question':
        metaType = 'direct_response';
        approach = 'honest';
        break;
      case 'low_quality':
        metaType = 'improvement_offer';
        approach = 'supportive';
        break;
      case 'repeated_confusion':
        metaType = 'clarification';
        approach = 'patient';
        break;
      case 'low_satisfaction':
        metaType = 'adjustment_offer';
        approach = 'flexible';
        break;
    }
    
    // 메타 대화 내용 생성
    final content = _generateMetaContent(
      metaType,
      approach,
      quality,
      persona,
    );
    
    // 상태 업데이트
    metaState.lastMetaConversation = DateTime.now();
    metaState.metaCount++;
    
    return {
      'type': metaType,
      'approach': approach,
      'content': content,
      'timing': 'immediate',
      'confidence': opportunity['confidence'],
    };
  }
  
  /// 피드백 가이드 생성
  String _generateFeedbackGuide(
    List<ConversationSignal> signals,
    ConversationQuality quality,
    Map<String, dynamic> adjustments,
    List<ImprovementSuggestion> improvements,
    Map<String, dynamic>? metaConversation,
  ) {
    final buffer = StringBuffer();
    
    buffer.writeln('🔄 실시간 피드백 가이드:');
    buffer.writeln('');
    
    // 대화 품질
    buffer.writeln('📊 대화 품질 상태:');
    buffer.writeln('• 전체: ${(quality.overall * 100).toInt()}%');
    buffer.writeln('• 참여도: ${(quality.engagement * 100).toInt()}%');
    buffer.writeln('• 만족도: ${(quality.satisfaction * 100).toInt()}%');
    buffer.writeln('• 흐름: ${(quality.flow * 100).toInt()}%');
    buffer.writeln('');
    
    // 감지된 신호
    if (signals.isNotEmpty) {
      buffer.writeln('🚦 감지된 신호:');
      for (final signal in signals) {
        buffer.writeln('• ${_getSignalDescription(signal)}');
      }
      buffer.writeln('');
    }
    
    // 조정 제안
    if (adjustments.isNotEmpty) {
      buffer.writeln('⚙️ 실시간 조정:');
      adjustments.forEach((key, value) {
        if (value is Map) {
          buffer.writeln('• $key: ${value['suggested']} (${value['reason']})');
        }
      });
      buffer.writeln('');
    }
    
    // 개선 제안
    if (improvements.isNotEmpty) {
      buffer.writeln('💡 개선 제안:');
      for (final improvement in improvements.take(3)) {
        buffer.writeln('• [${improvement.priority}] ${improvement.suggestion}');
        buffer.writeln('  → ${improvement.implementation}');
      }
      buffer.writeln('');
    }
    
    // 메타 대화
    if (metaConversation != null) {
      buffer.writeln('💬 메타 대화:');
      buffer.writeln('• 유형: ${metaConversation['type']}');
      buffer.writeln('• 접근: ${metaConversation['approach']}');
      buffer.writeln('${metaConversation['content']}');
    }
    
    return buffer.toString();
  }
  
  /// 혼란 감지
  bool _detectConfusion(String message) {
    final confusionIndicators = [
      '뭔 말', '무슨 말', '이해 안', '모르겠', '?', '??', '???',
      '뭐라고', '헷갈', '어려', '복잡'
    ];
    return confusionIndicators.any((indicator) => message.contains(indicator));
  }
  
  /// 혼란 강도 측정
  double _measureConfusionStrength(String message) {
    double strength = 0.3;
    
    if (message.contains('???')) strength = 0.8;
    else if (message.contains('??')) strength = 0.6;
    else if (message.contains('전혀') || message.contains('하나도')) strength = 0.7;
    
    return strength;
  }
  
  /// 혼란 지표
  String _getConfusionIndicator(String message) {
    if (message.contains('???')) return '강한 혼란 (???)';
    if (message.contains('이해 안')) return '이해 부족 표현';
    if (message.contains('뭔 말')) return '의미 파악 실패';
    return '일반적 혼란';
  }
  
  /// 불만족 감지
  bool _detectDissatisfaction(String message) {
    final dissatisfactionIndicators = [
      '별로', '그냥', '음..', '글쎄', '아닌데', '그게 아니라',
      '재미없', '지루', '싫', '짜증'
    ];
    return dissatisfactionIndicators.any((indicator) => message.contains(indicator));
  }
  
  /// 불만족 강도 측정
  double _measureDissatisfactionStrength(String message) {
    double strength = 0.3;
    
    if (message.contains('짜증') || message.contains('싫')) strength = 0.7;
    else if (message.contains('재미없') || message.contains('지루')) strength = 0.6;
    else if (message.contains('별로')) strength = 0.4;
    
    return strength;
  }
  
  /// 불만족 지표
  String _getDissatisfactionIndicator(String message) {
    if (message.contains('짜증')) return '짜증 표현';
    if (message.contains('재미없')) return '흥미 부족';
    if (message.contains('별로')) return '미온적 반응';
    return '일반적 불만족';
  }
  
  /// 흥미 상실 감지
  bool _detectLossOfInterest(String message, List<Message> history) {
    // 짧은 응답 연속
    if (message.length < 5) {
      final recentShort = history.take(3)
          .where((m) => m.isFromUser && m.content.length < 10)
          .length;
      return recentShort >= 2;
    }
    return false;
  }
  
  /// 흥미 상실 측정
  double _measureInterestLoss(String message, List<Message> history) {
    double loss = 0.3;
    
    if (message.length < 3) loss = 0.7;
    else if (message.length < 5) loss = 0.5;
    
    // 응답 시간 고려 (시뮬레이션)
    if (history.isNotEmpty) {
      final gap = DateTime.now().difference(history.first.timestamp);
      if (gap.inMinutes > 5) loss += 0.2;
    }
    
    return loss.clamp(0, 1);
  }
  
  /// 긍정적 참여 감지
  bool _detectPositiveEngagement(String message) {
    final positiveIndicators = [
      'ㅋㅋ', 'ㅎㅎ', '좋', '재밌', '대박', '웃겨', '최고',
      '!!', '♥', '♡', '👍'
    ];
    return positiveIndicators.any((indicator) => message.contains(indicator));
  }
  
  /// 긍정적 참여 측정
  double _measurePositiveEngagement(String message) {
    double engagement = 0.3;
    
    if (message.contains('최고') || message.contains('대박')) engagement = 0.8;
    else if (message.contains('재밌')) engagement = 0.7;
    else if (message.contains('ㅋㅋㅋ')) engagement = 0.6;
    else if (message.contains('좋')) engagement = 0.5;
    
    return engagement;
  }
  
  /// 긍정 지표
  String _getPositiveIndicator(String message) {
    if (message.contains('최고')) return '매우 긍정적';
    if (message.contains('재밌')) return '재미있어함';
    if (message.contains('ㅋㅋ')) return '웃음 표현';
    return '긍정적 반응';
  }
  
  /// 도움 요청 감지
  bool _detectHelpRequest(String message) {
    final helpIndicators = [
      '도와', '알려', '설명', '어떻게', '뭐야', '뭔지',
      '가르쳐', '모르겠어'
    ];
    return helpIndicators.any((indicator) => message.contains(indicator));
  }
  
  /// 주제 변경 감지
  bool _detectTopicChange(String message, List<Message> history) {
    if (history.isEmpty) return false;
    
    // 이전 메시지와 전혀 다른 키워드
    final previousKeywords = _extractSimpleKeywords(history.first.content);
    final currentKeywords = _extractSimpleKeywords(message);
    
    final overlap = previousKeywords
        .where((k) => currentKeywords.contains(k))
        .length;
    
    return overlap == 0 && currentKeywords.isNotEmpty;
  }
  
  /// 간단한 키워드 추출
  List<String> _extractSimpleKeywords(String text) {
    final keywords = <String>[];
    final commonWords = ['영화', '음악', '게임', '일', '학교', '음식', '날씨'];
    
    for (final word in commonWords) {
      if (text.contains(word)) keywords.add(word);
    }
    
    return keywords;
  }
  
  /// 참여도 계산
  double _calculateEngagement(List<Message> history) {
    if (history.isEmpty) return 0.5;
    
    final userMessages = history.where((m) => m.isFromUser).take(5).toList();
    if (userMessages.isEmpty) return 0.5;
    
    // 평균 메시지 길이
    final avgLength = userMessages
        .map((m) => m.content.length)
        .reduce((a, b) => a + b) / userMessages.length;
    
    // 길이 기반 참여도
    double engagement = 0.5;
    if (avgLength > 50) engagement = 0.8;
    else if (avgLength > 20) engagement = 0.6;
    else if (avgLength < 10) engagement = 0.3;
    
    return engagement;
  }
  
  /// 만족도 계산
  double _calculateSatisfaction(List<ConversationSignal> signals, List<Message> history) {
    double satisfaction = 0.6;
    
    // 긍정 신호
    final positiveCount = signals.where((s) => s.type == 'positive_engagement').length;
    satisfaction += positiveCount * 0.1;
    
    // 부정 신호
    final negativeCount = signals.where((s) => 
        s.type == 'dissatisfaction' || s.type == 'confusion').length;
    satisfaction -= negativeCount * 0.15;
    
    return satisfaction.clamp(0, 1);
  }
  
  /// 흐름 계산
  double _calculateFlow(List<Message> history) {
    if (history.length < 3) return 0.5;
    
    // 주제 연속성 체크
    double flow = 0.6;
    
    // 자연스러운 전환 패턴 찾기
    for (int i = 0; i < min(history.length - 1, 5); i++) {
      final current = history[i].content;
      final next = history[i + 1].content;
      
      // 연관성 체크 (간단한 구현)
      if (_hasConnection(current, next)) {
        flow += 0.05;
      } else {
        flow -= 0.05;
      }
    }
    
    return flow.clamp(0, 1);
  }
  
  /// 연결성 체크
  bool _hasConnection(String msg1, String msg2) {
    // 공통 키워드 체크
    final keywords1 = _extractSimpleKeywords(msg1);
    final keywords2 = _extractSimpleKeywords(msg2);
    
    return keywords1.any((k) => keywords2.contains(k));
  }
  
  /// 깊이 계산
  double _calculateDepth(List<Message> history) {
    if (history.isEmpty) return 0.5;
    
    // 긴 메시지 비율
    final longMessages = history
        .where((m) => m.content.length > 50)
        .length;
    
    final depth = longMessages / history.length;
    return depth.clamp(0, 1);
  }
  
  /// 진정성 계산
  double _calculateAuthenticity(List<Message> history) {
    // 자연스러운 대화 패턴 체크
    double authenticity = 0.7;
    
    // 다양한 반응 패턴
    final reactions = history
        .where((m) => !m.isFromUser)
        .map((m) => m.content.substring(0, min(10, m.content.length)))
        .toSet();
    
    if (reactions.length > history.length * 0.3) {
      authenticity += 0.2; // 다양한 시작
    }
    
    return authenticity.clamp(0, 1);
  }
  
  /// 메타 질문 판단
  bool _isMetaQuestion(String message) {
    final metaIndicators = [
      '대화', '말투', '답변', '응답', '너는', '너도', 'AI',
      '어떻게 대답', '왜 그렇게'
    ];
    return metaIndicators.any((indicator) => message.contains(indicator));
  }
  
  /// 반응 시간 추정
  String _estimateReactionTime(String userMessage, String lastAIResponse) {
    // 실제로는 타임스탬프 기반이어야 하지만 여기서는 시뮬레이션
    if (userMessage.length < 5) return 'delayed';
    if (userMessage.contains('!') || userMessage.contains('ㅋ')) return 'immediate';
    return 'normal';
  }
  
  /// 메타 콘텐츠 생성
  String _generateMetaContent(
    String type,
    String approach,
    ConversationQuality quality,
    Persona persona,
  ) {
    final buffer = StringBuffer();
    
    switch (type) {
      case 'check_in':
        buffer.writeln('💭 대화 체크인:');
        buffer.writeln('• "대화가 재미있어?", "내 답변이 도움이 되고 있어?"');
        break;
      
      case 'improvement_offer':
        buffer.writeln('🔧 개선 제안:');
        buffer.writeln('• "다른 방식으로 대화해볼까?", "더 편하게 얘기해도 돼"');
        break;
      
      case 'clarification':
        buffer.writeln('❓ 명확화:');
        buffer.writeln('• "내가 제대로 이해한 게 맞아?", "다시 설명해줄게"');
        break;
      
      case 'adjustment_offer':
        buffer.writeln('🎯 조정 제안:');
        buffer.writeln('• "내가 너무 복잡하게 말하는 것 같아?", "다른 스타일로 대화해볼까?"');
        break;
      
      case 'direct_response':
        buffer.writeln('💬 직접 응답:');
        buffer.writeln('• 솔직하고 투명한 메타 대화');
        buffer.writeln('• 대화 방식에 대한 직접적인 피드백');
        break;
    }
    
    buffer.writeln('• 접근 방식: $approach');
    buffer.writeln('• ${persona.name} 캐릭터 유지하며 자연스럽게');
    
    return buffer.toString();
  }
  
  /// 신호 설명
  String _getSignalDescription(ConversationSignal signal) {
    final strength = (signal.strength * 100).toInt();
    return '${signal.type}: ${signal.indicator} ($strength%)';
  }
  
  /// 신호 히스토리 업데이트
  void _updateSignalHistory(String userId, List<ConversationSignal> signals) {
    _signalHistory[userId] ??= [];
    _signalHistory[userId]!.addAll(signals);
    
    // 최대 50개 유지
    if (_signalHistory[userId]!.length > 50) {
      _signalHistory[userId]!.removeRange(0, _signalHistory[userId]!.length - 50);
    }
  }
  
  /// 품질 추적 업데이트
  void _updateQualityTracking(String userId, ConversationQuality quality) {
    _qualityTracking[userId] = quality;
  }
}

/// 대화 신호
class ConversationSignal {
  final String type;
  final double strength;
  final String indicator;
  final DateTime timestamp;
  
  ConversationSignal({
    required this.type,
    required this.strength,
    required this.indicator,
    required this.timestamp,
  });
  
  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'strength': strength,
      'indicator': indicator,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

/// 대화 품질
class ConversationQuality {
  final double engagement;
  final double satisfaction;
  final double flow;
  final double depth;
  final double authenticity;
  final double overall;
  final DateTime timestamp;
  
  ConversationQuality({
    required this.engagement,
    required this.satisfaction,
    required this.flow,
    required this.depth,
    required this.authenticity,
    required this.overall,
    required this.timestamp,
  });
  
  Map<String, dynamic> toMap() {
    return {
      'engagement': engagement,
      'satisfaction': satisfaction,
      'flow': flow,
      'depth': depth,
      'authenticity': authenticity,
      'overall': overall,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

/// 개선 제안
class ImprovementSuggestion {
  final String area;
  final String priority;
  final String suggestion;
  final String implementation;
  
  ImprovementSuggestion({
    required this.area,
    required this.priority,
    required this.suggestion,
    required this.implementation,
  });
}

/// 메타 대화 상태
class MetaConversationState {
  DateTime? lastMetaConversation;
  int metaCount = 0;
  List<String> topics = [];
}