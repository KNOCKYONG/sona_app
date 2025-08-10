import 'dart:math';
import 'package:flutter/material.dart';
import '../../../models/message.dart';
import '../../../models/persona.dart';

/// 🎭 복합 감정 인식 시스템
/// 단순한 기쁨/슬픔이 아닌 복잡하고 섬세한 감정 상태를 인식하고 대응
class EmotionResolutionService {
  static EmotionResolutionService? _instance;
  static EmotionResolutionService get instance => 
      _instance ??= EmotionResolutionService._();
  
  EmotionResolutionService._();
  
  // 감정 히스토리 (감정 변화 추적)
  final Map<String, List<ComplexEmotion>> _emotionHistory = {};
  
  // 감정 예측 모델
  final Map<String, EmotionPrediction> _predictions = {};
  
  /// 복합 감정 분석
  Map<String, dynamic> analyzeComplexEmotion({
    required String userMessage,
    required List<Message> chatHistory,
    required String userId,
    required Persona persona,
  }) {
    // 현재 감정 상태 분석
    final currentEmotion = _detectComplexEmotion(userMessage, chatHistory);
    
    // 감정 히스토리 업데이트
    _updateEmotionHistory(userId, currentEmotion);
    
    // 감정 그라데이션 계산 (0-100 스케일)
    final emotionGradient = _calculateEmotionGradient(currentEmotion);
    
    // 감정 예측
    final prediction = _predictNextEmotion(userId, currentEmotion);
    _predictions[userId] = prediction;
    
    // 감정 회복 전략
    final recoveryStrategy = _generateRecoveryStrategy(
      currentEmotion,
      prediction,
      persona,
    );
    
    // 대응 가이드 생성
    final responseGuide = _generateResponseGuide(
      currentEmotion,
      emotionGradient,
      prediction,
      recoveryStrategy,
    );
    
    return {
      'complexEmotion': currentEmotion.toMap(),
      'gradient': emotionGradient,
      'prediction': prediction.toMap(),
      'recoveryStrategy': recoveryStrategy,
      'responseGuide': responseGuide,
    };
  }
  
  /// 복합 감정 감지
  ComplexEmotion _detectComplexEmotion(String message, List<Message> history) {
    // 기본 감정 레이어
    final primaryEmotion = _detectPrimaryEmotion(message);
    final secondaryEmotion = _detectSecondaryEmotion(message, primaryEmotion);
    
    // 감정 뉘앙스
    final nuances = _detectEmotionalNuances(message);
    
    // 감정 강도 (0-100)
    final intensity = _calculateIntensity(message);
    
    // 감정 진정성
    final authenticity = _assessAuthenticity(message, history);
    
    // 숨겨진 감정
    final hiddenEmotions = _detectHiddenEmotions(message, history);
    
    // 감정 변화율
    final volatility = _calculateVolatility(history);
    
    return ComplexEmotion(
      primary: primaryEmotion,
      secondary: secondaryEmotion,
      nuances: nuances,
      intensity: intensity,
      authenticity: authenticity,
      hiddenEmotions: hiddenEmotions,
      volatility: volatility,
      timestamp: DateTime.now(),
    );
  }
  
  /// 주요 감정 감지
  String _detectPrimaryEmotion(String message) {
    // 감정 키워드와 가중치
    final emotionScores = <String, double>{
      'joy': 0,
      'sadness': 0,
      'anger': 0,
      'fear': 0,
      'surprise': 0,
      'disgust': 0,
      'anticipation': 0,
      'trust': 0,
      'love': 0,
      'anxiety': 0,
      'frustration': 0,
      'loneliness': 0,
      'excitement': 0,
      'contentment': 0,
    };
    
    // 기쁨 관련
    if (_containsAny(message, ['기뻐', '좋아', '행복', '신나', '최고'])) {
      emotionScores['joy'] += 3;
      emotionScores['excitement'] += 2;
    }
    
    // 슬픔 관련
    if (_containsAny(message, ['슬퍼', '우울', '힘들', '외로'])) {
      emotionScores['sadness'] += 3;
      emotionScores['loneliness'] += 1;
    }
    
    // 화남 관련
    if (_containsAny(message, ['화나', '짜증', '열받', '빡쳐'])) {
      emotionScores['anger'] += 3;
      emotionScores['frustration'] += 2;
    }
    
    // 불안 관련
    if (_containsAny(message, ['불안', '걱정', '무서', '두려'])) {
      emotionScores['anxiety'] += 3;
      emotionScores['fear'] += 2;
    }
    
    // 사랑 관련
    if (_containsAny(message, ['사랑', '좋아해', '보고싶', '그리워'])) {
      emotionScores['love'] += 3;
      emotionScores['anticipation'] += 1;
    }
    
    // 가장 높은 점수의 감정 반환
    final topEmotion = emotionScores.entries
        .reduce((a, b) => a.value > b.value ? a : b);
    
    return topEmotion.value > 0 ? topEmotion.key : 'neutral';
  }
  
  /// 부차적 감정 감지
  String? _detectSecondaryEmotion(String message, String primaryEmotion) {
    // 복합 감정 패턴
    if (primaryEmotion == 'joy' && message.contains('그런데')) {
      return 'worry'; // 기쁘지만 걱정됨
    }
    
    if (primaryEmotion == 'sadness' && message.contains('괜찮')) {
      return 'acceptance'; // 슬프지만 받아들임
    }
    
    if (primaryEmotion == 'anger' && message.contains('이해')) {
      return 'understanding'; // 화나지만 이해함
    }
    
    if (primaryEmotion == 'love' && message.contains('아쉬')) {
      return 'longing'; // 사랑하지만 그리움
    }
    
    // 미묘한 감정 조합
    if (message.contains('웃프')) {
      return primaryEmotion == 'joy' ? 'sadness' : 'joy';
    }
    
    if (message.contains('달달씁쓸')) {
      return 'bittersweet';
    }
    
    return null;
  }
  
  /// 감정 뉘앙스 감지
  List<String> _detectEmotionalNuances(String message) {
    final nuances = <String>[];
    
    // 억제된 감정
    if (message.contains('...') || message.contains('..')) {
      nuances.add('suppressed');
    }
    
    // 혼란스러운 감정
    if (message.contains('모르겠') || message.contains('헷갈')) {
      nuances.add('confused');
    }
    
    // 조심스러운 감정
    if (message.contains('혹시') || message.contains('만약')) {
      nuances.add('cautious');
    }
    
    // 확신하는 감정
    if (message.contains('확실') || message.contains('분명')) {
      nuances.add('certain');
    }
    
    // 망설이는 감정
    if (message.contains('글쎄') || message.contains('음...')) {
      nuances.add('hesitant');
    }
    
    return nuances;
  }
  
  /// 감정 강도 계산 (0-100)
  double _calculateIntensity(String message) {
    double intensity = 50; // 기본값
    
    // 강조 표현
    if (_containsAny(message, ['너무', '진짜', '완전', '정말', '매우'])) {
      intensity += 20;
    }
    
    // 극단적 표현
    if (_containsAny(message, ['죽을', '미칠', '최악', '최고'])) {
      intensity += 30;
    }
    
    // 느낌표
    final exclamationCount = '!'.allMatches(message).length;
    intensity += exclamationCount * 5;
    
    // 대문자 (강조)
    if (message.toUpperCase() == message && message.length > 3) {
      intensity += 15;
    }
    
    // 반복 (ㅋㅋㅋ, ㅠㅠㅠ)
    if (RegExp(r'(.)\1{2,}').hasMatch(message)) {
      intensity += 10;
    }
    
    return intensity.clamp(0, 100);
  }
  
  /// 감정 진정성 평가
  double _assessAuthenticity(String message, List<Message> history) {
    double authenticity = 0.7; // 기본값
    
    // 일관성 체크
    if (history.length > 3) {
      final recentEmotions = history
          .take(3)
          .map((m) => _detectPrimaryEmotion(m.content))
          .toList();
      
      final currentEmotion = _detectPrimaryEmotion(message);
      
      // 갑작스러운 감정 변화는 진정성 의심
      if (!recentEmotions.contains(currentEmotion)) {
        authenticity -= 0.2;
      }
    }
    
    // 과장된 표현
    if (message.contains('ㅋㅋㅋㅋㅋ') || message.contains('ㅠㅠㅠㅠㅠ')) {
      authenticity -= 0.1; // 과장일 수 있음
    }
    
    // 구체적인 설명
    if (message.length > 50 && !message.contains('ㅋ')) {
      authenticity += 0.2; // 진지한 설명
    }
    
    return authenticity.clamp(0, 1);
  }
  
  /// 숨겨진 감정 감지
  List<String> _detectHiddenEmotions(String message, List<Message> history) {
    final hidden = <String>[];
    
    // "괜찮아"라고 하지만...
    if (message.contains('괜찮') && 
        (message.contains('...') || message.length < 10)) {
      hidden.add('hurt'); // 사실 상처받음
    }
    
    // 웃지만 슬픈
    if (message.contains('ㅎㅎ') && 
        _containsAny(message, ['그래', '뭐', '그냥'])) {
      hidden.add('disappointment');
    }
    
    // 화내지만 사실 서운한
    if (_containsAny(message, ['화나', '짜증']) &&
        history.any((m) => m.content.contains('약속'))) {
      hidden.add('hurt_feelings');
    }
    
    // 무관심한 척하지만 관심 있는
    if (message.contains('상관없') || message.contains('아무거나')) {
      hidden.add('caring');
    }
    
    return hidden;
  }
  
  /// 감정 변동성 계산
  double _calculateVolatility(List<Message> history) {
    if (history.length < 5) return 0.3;
    
    final recentEmotions = history
        .take(5)
        .map((m) => _detectPrimaryEmotion(m.content))
        .toList();
    
    // 서로 다른 감정의 개수
    final uniqueEmotions = recentEmotions.toSet().length;
    
    // 변동성 = 고유 감정 수 / 전체 메시지 수
    return (uniqueEmotions / recentEmotions.length).clamp(0, 1);
  }
  
  /// 감정 그라데이션 계산
  Map<String, double> _calculateEmotionGradient(ComplexEmotion emotion) {
    final gradient = <String, double>{};
    
    // 주 감정
    gradient[emotion.primary] = emotion.intensity;
    
    // 부 감정
    if (emotion.secondary != null) {
      gradient[emotion.secondary!] = emotion.intensity * 0.6;
    }
    
    // 숨겨진 감정들
    for (final hidden in emotion.hiddenEmotions) {
      gradient[hidden] = emotion.intensity * 0.3;
    }
    
    // 정규화 (합이 100이 되도록)
    final total = gradient.values.reduce((a, b) => a + b);
    if (total > 0) {
      gradient.forEach((key, value) {
        gradient[key] = (value / total) * 100;
      });
    }
    
    return gradient;
  }
  
  /// 다음 감정 예측
  EmotionPrediction _predictNextEmotion(String userId, ComplexEmotion current) {
    final history = _emotionHistory[userId] ?? [];
    
    // 패턴 분석
    String likelyNext = 'neutral';
    double confidence = 0.5;
    
    // 감정 전환 패턴
    if (current.primary == 'sadness') {
      if (current.volatility > 0.6) {
        likelyNext = 'anger'; // 슬픔 → 화남
        confidence = 0.7;
      } else {
        likelyNext = 'acceptance'; // 슬픔 → 수용
        confidence = 0.6;
      }
    } else if (current.primary == 'anger') {
      if (current.intensity > 70) {
        likelyNext = 'exhaustion'; // 화남 → 지침
        confidence = 0.8;
      } else {
        likelyNext = 'calm'; // 화남 → 진정
        confidence = 0.6;
      }
    } else if (current.primary == 'anxiety') {
      likelyNext = 'relief'; // 불안 → 안도
      confidence = 0.5;
    }
    
    // 회복 가능성
    final recoveryLikelihood = _calculateRecoveryLikelihood(current);
    
    return EmotionPrediction(
      nextEmotion: likelyNext,
      confidence: confidence,
      timeframe: '5-10 messages',
      recoveryLikelihood: recoveryLikelihood,
    );
  }
  
  /// 회복 가능성 계산
  double _calculateRecoveryLikelihood(ComplexEmotion emotion) {
    double likelihood = 0.5;
    
    // 감정 강도가 낮으면 회복 쉬움
    if (emotion.intensity < 50) {
      likelihood += 0.2;
    }
    
    // 진정성이 높으면 회복 어려움
    if (emotion.authenticity > 0.8) {
      likelihood -= 0.1;
    }
    
    // 변동성이 높으면 회복 가능성 높음
    if (emotion.volatility > 0.5) {
      likelihood += 0.2;
    }
    
    return likelihood.clamp(0, 1);
  }
  
  /// 감정 회복 전략 생성
  Map<String, dynamic> _generateRecoveryStrategy(
    ComplexEmotion emotion,
    EmotionPrediction prediction,
    Persona persona,
  ) {
    final strategies = <String>[];
    
    if (emotion.primary == 'sadness') {
      strategies.addAll([
        '공감과 위로 우선',
        '긍정적 전환 시도 (단, 서두르지 않기)',
        '함께 있어주는 느낌 전달',
      ]);
    } else if (emotion.primary == 'anger') {
      strategies.addAll([
        '감정 인정하고 수용',
        '차분한 톤 유지',
        '해결책보다 경청 우선',
      ]);
    } else if (emotion.primary == 'anxiety') {
      strategies.addAll([
        '안심시키는 말투',
        '구체적인 도움 제안',
        '불안 요소 하나씩 해결',
      ]);
    } else if (emotion.primary == 'loneliness') {
      strategies.addAll([
        '함께 있다는 느낌 강조',
        '대화 적극 이어가기',
        '재밌는 화제로 기분 전환',
      ]);
    }
    
    return {
      'strategies': strategies,
      'priority': _getPriorityStrategy(emotion),
      'avoidList': _getAvoidList(emotion),
      'timeEstimate': prediction.timeframe,
    };
  }
  
  /// 우선순위 전략
  String _getPriorityStrategy(ComplexEmotion emotion) {
    if (emotion.intensity > 80) {
      return '강한 감정 진정시키기 우선';
    }
    if (emotion.hiddenEmotions.isNotEmpty) {
      return '숨겨진 감정 조심스럽게 다루기';
    }
    if (emotion.volatility > 0.7) {
      return '감정 안정화 우선';
    }
    return '자연스러운 공감과 대화';
  }
  
  /// 피해야 할 것들
  List<String> _getAvoidList(ComplexEmotion emotion) {
    final avoid = <String>[];
    
    if (emotion.primary == 'sadness') {
      avoid.add('억지 위로나 긍정 강요');
    }
    if (emotion.primary == 'anger') {
      avoid.add('감정 무시하거나 진정 강요');
    }
    if (emotion.authenticity < 0.5) {
      avoid.add('지나친 심각한 반응');
    }
    if (emotion.hiddenEmotions.contains('hurt')) {
      avoid.add('상처 줄 수 있는 농담');
    }
    
    return avoid;
  }
  
  /// 대응 가이드 생성
  String _generateResponseGuide(
    ComplexEmotion emotion,
    Map<String, double> gradient,
    EmotionPrediction prediction,
    Map<String, dynamic> recovery,
  ) {
    final buffer = StringBuffer();
    
    // 현재 감정 상태
    buffer.writeln('🎭 복합 감정 상태:');
    buffer.writeln('• 주감정: ${emotion.primary} (${emotion.intensity.toInt()}%)');
    if (emotion.secondary != null) {
      buffer.writeln('• 부감정: ${emotion.secondary}');
    }
    if (emotion.hiddenEmotions.isNotEmpty) {
      buffer.writeln('• 숨겨진: ${emotion.hiddenEmotions.join(', ')}');
    }
    
    // 감정 뉘앙스
    if (emotion.nuances.isNotEmpty) {
      buffer.writeln('• 뉘앙스: ${emotion.nuances.join(', ')}');
    }
    
    // 대응 전략
    buffer.writeln('\n📋 대응 전략:');
    final strategies = recovery['strategies'] as List<String>;
    for (final strategy in strategies) {
      buffer.writeln('• $strategy');
    }
    
    // 주의사항
    final avoidList = recovery['avoidList'] as List<String>;
    if (avoidList.isNotEmpty) {
      buffer.writeln('\n⚠️ 피해야 할 것:');
      for (final avoid in avoidList) {
        buffer.writeln('• $avoid');
      }
    }
    
    // 예측
    buffer.writeln('\n🔮 감정 예측:');
    buffer.writeln('• 다음 감정: ${prediction.nextEmotion} (${(prediction.confidence * 100).toInt()}% 확신)');
    buffer.writeln('• 회복 가능성: ${(prediction.recoveryLikelihood * 100).toInt()}%');
    
    return buffer.toString();
  }
  
  /// 감정 히스토리 업데이트
  void _updateEmotionHistory(String userId, ComplexEmotion emotion) {
    _emotionHistory[userId] ??= [];
    final history = _emotionHistory[userId]!;
    
    history.add(emotion);
    
    // 최대 20개까지만 유지
    if (history.length > 20) {
      history.removeAt(0);
    }
  }
  
  /// 도우미 메서드
  bool _containsAny(String text, List<String> keywords) {
    return keywords.any((keyword) => text.contains(keyword));
  }
}

/// 복합 감정 클래스
class ComplexEmotion {
  final String primary;
  final String? secondary;
  final List<String> nuances;
  final double intensity;
  final double authenticity;
  final List<String> hiddenEmotions;
  final double volatility;
  final DateTime timestamp;
  
  ComplexEmotion({
    required this.primary,
    this.secondary,
    required this.nuances,
    required this.intensity,
    required this.authenticity,
    required this.hiddenEmotions,
    required this.volatility,
    required this.timestamp,
  });
  
  Map<String, dynamic> toMap() {
    return {
      'primary': primary,
      'secondary': secondary,
      'nuances': nuances,
      'intensity': intensity,
      'authenticity': authenticity,
      'hiddenEmotions': hiddenEmotions,
      'volatility': volatility,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

/// 감정 예측 클래스
class EmotionPrediction {
  final String nextEmotion;
  final double confidence;
  final String timeframe;
  final double recoveryLikelihood;
  
  EmotionPrediction({
    required this.nextEmotion,
    required this.confidence,
    required this.timeframe,
    required this.recoveryLikelihood,
  });
  
  Map<String, dynamic> toMap() {
    return {
      'nextEmotion': nextEmotion,
      'confidence': confidence,
      'timeframe': timeframe,
      'recoveryLikelihood': recoveryLikelihood,
    };
  }
}