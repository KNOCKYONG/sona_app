import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import '../../../models/message.dart';
import 'base_quality_system.dart';
import 'quality_detection_utils.dart';

/// 🎭 감정 표현 다양화 시스템
/// 단조로운 감정 표현을 풍부하고 다양하게 만드는 시스템
/// 모든 응답은 OpenAI API를 통해 생성 (하드코딩 없음)
class EmotionalNuanceSystem extends BaseQualitySystem {
  static final EmotionalNuanceSystem _instance = EmotionalNuanceSystem._internal();
  factory EmotionalNuanceSystem() => _instance;
  EmotionalNuanceSystem._internal();

  final _random = math.Random();

  /// BaseQualitySystem의 추상 메서드 구현
  @override
  Map<String, dynamic> generateGuide({
    required String userId,
    required String userMessage,
    required List<Message> chatHistory,
    String? personaType,
  }) {
    // QualityDetectionUtils 사용
    final detectedEmotion = QualityDetectionUtils.detectEmotion(userMessage);
    return generateEmotionalGuide(
      userMessage: userMessage,
      detectedEmotion: detectedEmotion,
      chatHistory: chatHistory,
      personaType: personaType,
    );
  }

  /// 감정 스펙트럼 가이드 생성 (OpenAI API용 힌트)
  /// 실제 응답 텍스트가 아닌 가이드라인만 제공
  Map<String, dynamic> generateEmotionalGuide({
    required String userMessage,
    required String detectedEmotion,
    required List<Message> chatHistory,
    String? personaType,
  }) {
    // BaseQualitySystem의 메서드 사용
    final intensity = QualityDetectionUtils.analyzeEmotionalIntensity(userMessage);
    
    // 감정 뉘앙스 결정
    final nuance = _selectEmotionalNuance(
      emotion: detectedEmotion,
      intensity: intensity,
      history: chatHistory,
    );
    
    // 표현 스타일 결정
    final expressionStyle = _determineExpressionStyle(
      personaType: personaType,
      emotion: detectedEmotion,
      intensity: intensity,
    );
    
    // 감정 전환 필요성 체크
    final needsTransition = _checkEmotionalTransition(chatHistory);
    
    return {
      'emotion': detectedEmotion,
      'intensity': intensity,
      'nuance': nuance,
      'expressionStyle': expressionStyle,
      'guideline': _createEmotionalGuideline(
        emotion: detectedEmotion,
        intensity: intensity,
        nuance: nuance,
        style: expressionStyle,
        needsTransition: needsTransition,
      ),
      'emotionalDepth': calculateConversationDepth(chatHistory),
      'varietyScore': calculateVarietyScore(
        history: chatHistory,
        extractor: (msg) => QualityDetectionUtils.detectEmotion(msg.content),
      ),
    };
  }


  /// 감정 뉘앙스 선택
  String _selectEmotionalNuance({
    required String emotion,
    required double intensity,
    required List<Message> history,
  }) {
    // 최근 사용된 뉘앙스 체크 (반복 방지)
    final recentNuances = _extractRecentNuances(history);
    
    // 감정별 뉘앙스 옵션
    final nuanceOptions = _getNuanceOptions(emotion, intensity);
    
    // 사용하지 않은 뉘앙스 우선 선택
    final availableNuances = nuanceOptions
        .where((n) => !recentNuances.contains(n))
        .toList();
    
    if (availableNuances.isEmpty) {
      return nuanceOptions[_random.nextInt(nuanceOptions.length)];
    }
    
    return availableNuances[_random.nextInt(availableNuances.length)];
  }

  /// 감정별 뉘앙스 옵션
  List<String> _getNuanceOptions(String emotion, double intensity) {
    if (intensity < 0.3) {
      return ['subtle', 'gentle', 'soft', 'mild'];
    } else if (intensity < 0.7) {
      return ['moderate', 'warm', 'friendly', 'sincere'];
    } else {
      return ['intense', 'passionate', 'enthusiastic', 'vibrant'];
    }
  }

  /// 표현 스타일 결정
  String _determineExpressionStyle({
    String? personaType,
    required String emotion,
    required double intensity,
  }) {
    // 페르소나별 기본 스타일
    final baseStyle = _getPersonaBaseStyle(personaType);
    
    // 감정과 강도에 따른 스타일 조정
    if (emotion == 'joy' && intensity > 0.7) {
      return 'playful_energetic';
    } else if (emotion == 'empathy' && intensity > 0.5) {
      return 'warm_supportive';
    } else if (emotion == 'curiosity') {
      return 'engaging_interested';
    } else if (emotion == 'surprise') {
      return 'animated_reactive';
    }
    
    return baseStyle;
  }

  /// 페르소나별 기본 스타일
  String _getPersonaBaseStyle(String? personaType) {
    final type = analyzePersonaType(personaType);
    
    switch (type) {
      case 'creative':
        return 'creative_expressive';
      case 'technical':
        return 'logical_friendly';
      case 'caring':
        return 'caring_professional';
      case 'educational':
        return 'encouraging_knowledgeable';
      case 'culinary':
        return 'warm_passionate';
      default:
        return 'friendly_casual';
    }
  }

  /// 감정 전환 필요성 체크
  bool _checkEmotionalTransition(List<Message> history) {
    if (history.length < 3) return false;
    
    // 최근 3개 메시지의 감정이 모두 같으면 전환 필요
    final recentEmotions = history
        .take(3)
        .where((m) => !m.isFromUser)
        .map((m) => QualityDetectionUtils.detectEmotion(m.content))
        .toList();
    
    if (recentEmotions.length >= 2) {
      return recentEmotions.toSet().length == 1;
    }
    
    return false;
  }

  /// 감정 가이드라인 생성 (OpenAI API용)
  String _createEmotionalGuideline({
    required String emotion,
    required double intensity,
    required String nuance,
    required String style,
    required bool needsTransition,
  }) {
    final buffer = StringBuffer();
    
    // 기본 감정 가이드
    buffer.writeln('🎭 감정 표현 가이드:');
    buffer.writeln('- 감정: $emotion');
    buffer.writeln('- 강도: ${_intensityToDescription(intensity)}');
    buffer.writeln('- 뉘앙스: ${_nuanceToDescription(nuance)}');
    buffer.writeln('- 스타일: ${_styleToDescription(style)}');
    
    // 세부 지침
    buffer.writeln('\n표현 지침:');
    
    if (intensity < 0.3) {
      buffer.writeln('- 은은하고 절제된 감정 표현');
      buffer.writeln('- 과하지 않은 자연스러운 반응');
    } else if (intensity < 0.7) {
      buffer.writeln('- 적당히 따뜻하고 친근한 표현');
      buffer.writeln('- 공감과 이해를 보여주는 반응');
    } else {
      buffer.writeln('- 활기차고 에너지 넘치는 표현');
      buffer.writeln('- 진심이 느껴지는 강한 감정 표현');
    }
    
    if (needsTransition) {
      buffer.writeln('- 이전과 다른 감정 톤으로 변화 필요');
    }
    
    // 표현 예시 방향 (실제 텍스트 아님)
    buffer.writeln('\n표현 방향:');
    buffer.writeln(_getExpressionDirection(emotion, intensity, nuance));
    
    return buffer.toString();
  }

  /// 강도를 설명으로 변환
  String _intensityToDescription(double intensity) {
    return intensityToDescription(intensity);
  }

  /// 뉘앙스를 설명으로 변환
  String _nuanceToDescription(String nuance) {
    final descriptions = {
      'subtle': '섬세하고 은근한',
      'gentle': '부드럽고 온화한',
      'soft': '포근하고 따뜻한',
      'mild': '온건하고 차분한',
      'moderate': '적당하고 균형잡힌',
      'warm': '따뜻하고 다정한',
      'friendly': '친근하고 편안한',
      'sincere': '진솔하고 진심어린',
      'intense': '강렬하고 열정적인',
      'passionate': '열정적이고 적극적인',
      'enthusiastic': '신나고 활기찬',
      'vibrant': '생동감 있고 활발한',
    };
    
    return descriptions[nuance] ?? nuance;
  }

  /// 스타일을 설명으로 변환
  String _styleToDescription(String style) {
    final descriptions = {
      'friendly_casual': '친근하고 캐주얼한',
      'playful_energetic': '장난스럽고 활기찬',
      'warm_supportive': '따뜻하고 지지적인',
      'engaging_interested': '관심있고 적극적인',
      'animated_reactive': '생동감 있는 리액션',
      'creative_expressive': '창의적이고 표현력 있는',
      'logical_friendly': '논리적이면서 친근한',
      'caring_professional': '돌봄과 전문성',
      'encouraging_knowledgeable': '격려하고 지식있는',
      'warm_passionate': '따뜻하고 열정적인',
    };
    
    return descriptions[style] ?? style;
  }

  /// 표현 방향 제시
  String _getExpressionDirection(String emotion, double intensity, String nuance) {
    final directions = StringBuffer();
    
    if (emotion == 'joy') {
      if (intensity > 0.7) {
        directions.writeln('- 신나는 에너지를 표현');
        directions.writeln('- 함께 기뻐하는 마음 전달');
      } else {
        directions.writeln('- 은은한 기쁨과 만족감 표현');
      }
    } else if (emotion == 'empathy') {
      if (intensity > 0.5) {
        directions.writeln('- 깊은 공감과 이해 표현');
        directions.writeln('- 함께 있어주는 마음 전달');
      } else {
        directions.writeln('- 가벼운 공감과 수용');
      }
    } else if (emotion == 'curiosity') {
      directions.writeln('- 진심어린 관심과 호기심 표현');
      directions.writeln('- 더 알고 싶은 마음 전달');
    }
    
    return directions.toString();
  }


  /// 최근 사용된 뉘앙스 추출
  List<String> _extractRecentNuances(List<Message> history) {
    // 실제로는 메시지에서 뉘앙스를 분석해야 하지만
    // 여기서는 간단히 구현
    return [];
  }


  /// 감정 전환 제안
  Map<String, dynamic> suggestEmotionalTransition({
    required String currentEmotion,
    required List<Message> history,
  }) {
    // 현재 감정이 너무 오래 지속되었는지 체크
    final emotionDuration = _calculateEmotionDuration(currentEmotion, history);
    
    if (emotionDuration < 3) {
      return {'needed': false};
    }
    
    // 전환할 감정 제안
    final targetEmotion = _selectTransitionEmotion(currentEmotion);
    
    return {
      'needed': true,
      'from': currentEmotion,
      'to': targetEmotion,
      'transitionHint': _createTransitionHint(currentEmotion, targetEmotion),
    };
  }

  /// 감정 지속 시간 계산
  int _calculateEmotionDuration(String emotion, List<Message> history) {
    int count = 0;
    for (final msg in history.where((m) => !m.isFromUser)) {
      if (QualityDetectionUtils.detectEmotion(msg.content) == emotion) {
        count++;
      } else {
        break;
      }
    }
    return count;
  }

  /// 전환할 감정 선택
  String _selectTransitionEmotion(String currentEmotion) {
    final transitions = {
      'joy': ['curiosity', 'empathy', 'playful'],
      'sadness': ['empathy', 'encouragement', 'hope'],
      'empathy': ['curiosity', 'joy', 'suggestion'],
      'neutral': ['curiosity', 'joy', 'interest'],
      'curiosity': ['joy', 'surprise', 'empathy'],
    };
    
    final options = transitions[currentEmotion] ?? ['neutral'];
    return options[_random.nextInt(options.length)];
  }

  /// 전환 힌트 생성
  String _createTransitionHint(String from, String to) {
    return '감정 전환: $from → $to (자연스럽게 분위기 전환)';
  }
}