import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../models/message.dart';
import '../../../models/persona.dart';
import '../../../models/emotion.dart';
import '../intelligence/emotion_resolution_service.dart';
import '../intelligence/emotional_transfer_service.dart' as emotional_transfer;
import '../analysis/emotion_recognition_service.dart' as emotion_recognition;
import '../quality/emotional_nuance_system.dart';
import '../localization/multilingual_keywords.dart';

/// 감정 처리 통합 모듈
/// 여러 감정 서비스를 조율하는 프로세서
class EmotionProcessor {
  static EmotionProcessor? _instance;
  static EmotionProcessor get instance => _instance ??= EmotionProcessor._();
  
  EmotionProcessor._();
  
  final _random = math.Random();
  
  // 감정 서비스들
  final EmotionResolutionService _resolutionService = EmotionResolutionService.instance;
  final emotional_transfer.EmotionalTransferService _transferService = 
      emotional_transfer.EmotionalTransferService();
  final EmotionalNuanceSystem _nuanceSystem = EmotionalNuanceSystem();
  
  // 감정 상태 캐시
  final Map<String, emotional_transfer.EmotionalState> _emotionalStates = {};
  
  /// 감정 종합 처리
  Future<Map<String, dynamic>> processEmotions({
    required String userMessage,
    required List<Message> chatHistory,
    required Persona persona,
    required Map<String, dynamic> contextAnalysis,
    String languageCode = 'ko',
  }) async {
    final userId = persona.id; // 간단히 persona ID를 사용
    
    // 1. 기본 감정 인식
    final basicEmotion = emotion_recognition.EmotionRecognitionService.analyzeEmotion(
      userMessage,
    );
    
    // 2. 복합 감정 분석
    final complexEmotion = _resolutionService.analyzeComplexEmotion(
      userMessage: userMessage,
      chatHistory: chatHistory,
      userId: userId,
      persona: persona,
    );
    
    // 3. 감정 상태 추적
    final emotionalState = _getOrCreateEmotionalState(userId);
    emotionalState.updateEmotion(
      basicEmotion.primaryEmotion ?? 'neutral',
      basicEmotion.intensity,
    );
    
    // 4. 감정 전이 계산
    final transferResult = _transferService.processEmotionalTransfer(
      userMessage: userMessage,
      chatHistory: chatHistory,
      persona: persona,
      emotionalState: emotionalState,
    );
    
    // 5. 감정 뉘앙스 생성
    final nuanceGuide = _nuanceSystem.generateEmotionalGuide(
      userMessage: userMessage,
      detectedEmotion: basicEmotion.primaryEmotion ?? 'neutral',
      chatHistory: chatHistory,
      personaType: persona.personality,
    );
    
    // 6. 감정 변화 계산
    final likesChange = _calculateLikesChange(
      basicEmotion: basicEmotion,
      complexEmotion: complexEmotion,
      transferResult: transferResult,
      contextQuality: contextAnalysis['quality'] ?? 0.5,
    );
    
    // 7. 감정 가이드 생성
    final emotionGuide = _generateEmotionGuide(
      primaryEmotion: basicEmotion.primaryEmotion,
      intensity: basicEmotion.intensity,
      complexData: complexEmotion,
      nuanceData: nuanceGuide,
      languageCode: languageCode,
    );
    
    return {
      'primaryEmotion': basicEmotion.primaryEmotion,
      'intensity': basicEmotion.intensity,
      'emotionScores': basicEmotion.scores,
      'complexEmotion': complexEmotion,
      'emotionalState': {
        'current': emotionalState.primaryEmotion,
        'history': emotionalState.emotionHistory,
        'volatility': emotionalState.emotionVolatility,
        'trend': emotionalState.emotionTrend,
      },
      'transferData': transferResult,
      'nuanceGuide': nuanceGuide,
      'emotionGuide': emotionGuide,
      'likesChange': likesChange,
      'requiresEmpathy': basicEmotion.requiresEmpathy,
    };
  }
  
  /// 감정 기반 호감도 변화 계산
  int _calculateLikesChange({
    required emotion_recognition.EmotionAnalysis basicEmotion,
    required Map<String, dynamic> complexEmotion,
    required Map<String, dynamic> transferResult,
    required double contextQuality,
  }) {
    int change = 0;
    
    // 기본 감정에 따른 변화
    if (basicEmotion.primaryEmotion != null) {
      switch (basicEmotion.primaryEmotion) {
        case 'happy':
        case 'excited':
        case 'grateful':
          change += (2 + _random.nextInt(3)); // 2~4
          break;
        case 'sad':
        case 'worried':
          if (basicEmotion.requiresEmpathy) {
            change += 1; // 공감하면 약간 증가
          }
          break;
        case 'angry':
        case 'frustrated':
          change -= 1; // 약간 감소
          break;
      }
    }
    
    // 감정 강도에 따른 보정
    if (basicEmotion.intensity > 0.8) {
      change = (change * 1.5).round();
    } else if (basicEmotion.intensity < 0.3) {
      change = (change * 0.5).round();
    }
    
    // 복합 감정 보정
    final gradient = complexEmotion['emotionGradient'] ?? {};
    if (gradient['positivity'] != null && gradient['positivity'] > 70) {
      change += 1;
    } else if (gradient['positivity'] != null && gradient['positivity'] < 30) {
      change -= 1;
    }
    
    // 감정 전이 효과
    final transferScore = transferResult['transferScore'] ?? 0.0;
    if (transferScore > 0.7) {
      change += 1; // 감정 전이가 잘 되면 보너스
    }
    
    // 컨텍스트 품질 보정
    if (contextQuality > 0.8) {
      change = (change * 1.2).round();
    } else if (contextQuality < 0.3) {
      change = (change * 0.8).round();
    }
    
    // 범위 제한
    return change.clamp(-10, 10);
  }
  
  /// 감정 가이드 생성
  Map<String, dynamic> _generateEmotionGuide({
    String? primaryEmotion,
    double intensity = 0.5,
    required Map<String, dynamic> complexData,
    required Map<String, dynamic> nuanceData,
    required String languageCode,
  }) {
    final guides = <String>[];
    
    // 주 감정 가이드
    if (primaryEmotion != null) {
      guides.add(_getEmotionGuideText(primaryEmotion, intensity, languageCode));
    }
    
    // 복합 감정 가이드
    final recoveryStrategy = complexData['recoveryStrategy'];
    if (recoveryStrategy != null && recoveryStrategy['approach'] != null) {
      guides.add(recoveryStrategy['approach']);
    }
    
    // 뉘앙스 가이드
    if (nuanceData['expressionHint'] != null) {
      guides.add(nuanceData['expressionHint']);
    }
    
    // 공감 표현 가이드
    if (primaryEmotion == 'sad' || primaryEmotion == 'worried') {
      guides.add(_getEmpathyGuide(languageCode));
    }
    
    return {
      'guides': guides,
      'emotionType': primaryEmotion ?? 'neutral',
      'intensity': intensity,
      'shouldEmpathize': primaryEmotion == 'sad' || 
                         primaryEmotion == 'worried' ||
                         primaryEmotion == 'frustrated',
      'emotionalTone': _determineEmotionalTone(primaryEmotion, intensity),
    };
  }
  
  /// 감정별 가이드 텍스트
  String _getEmotionGuideText(String emotion, double intensity, String languageCode) {
    // 감정과 강도에 따른 가이드 (AI에게 주는 힌트)
    final intensityLevel = intensity > 0.7 ? 'strong' : 
                          intensity > 0.4 ? 'moderate' : 'mild';
    
    final guides = {
      'ko': {
        'happy': {
          'strong': '매우 기쁜 감정을 함께 나누며 응답',
          'moderate': '긍정적이고 밝은 톤으로 응답',
          'mild': '부드럽게 긍정적인 반응',
        },
        'sad': {
          'strong': '깊은 공감과 위로의 표현',
          'moderate': '따뜻한 위로와 이해',
          'mild': '부드러운 공감 표현',
        },
        'angry': {
          'strong': '감정을 인정하고 진정시키는 응답',
          'moderate': '이해하고 수용하는 태도',
          'mild': '차분하게 대화 이어가기',
        },
      },
      'en': {
        'happy': {
          'strong': 'Share the joy enthusiastically',
          'moderate': 'Respond with positive energy',
          'mild': 'Gentle positive response',
        },
        'sad': {
          'strong': 'Deep empathy and comfort',
          'moderate': 'Warm understanding and support',
          'mild': 'Soft empathetic expression',
        },
        'angry': {
          'strong': 'Acknowledge and calm the emotion',
          'moderate': 'Understanding and accepting',
          'mild': 'Continue calmly',
        },
      },
    };
    
    final langGuides = guides[languageCode] ?? guides['en']!;
    final emotionGuides = langGuides[emotion] ?? langGuides['happy']!;
    return emotionGuides[intensityLevel] ?? emotionGuides['moderate']!;
  }
  
  /// 공감 가이드
  String _getEmpathyGuide(String languageCode) {
    final guides = {
      'ko': '상대방의 감정을 충분히 이해하고 공감하는 표현 사용',
      'en': 'Express understanding and empathy for their feelings',
      'ja': '相手の気持ちを理解し、共感を示す',
      'zh': '理解并同情对方的感受',
    };
    
    return guides[languageCode] ?? guides['en']!;
  }
  
  /// 감정 톤 결정
  String _determineEmotionalTone(String? emotion, double intensity) {
    if (emotion == null) return 'neutral';
    
    // 감정과 강도에 따른 톤 결정
    switch (emotion) {
      case 'happy':
      case 'excited':
        return intensity > 0.7 ? 'enthusiastic' : 'cheerful';
      case 'sad':
      case 'worried':
        return intensity > 0.7 ? 'comforting' : 'supportive';
      case 'angry':
      case 'frustrated':
        return 'calming';
      case 'grateful':
        return 'warm';
      case 'tired':
        return 'gentle';
      default:
        return 'friendly';
    }
  }
  
  /// 감정 상태 가져오기 또는 생성
  emotional_transfer.EmotionalState _getOrCreateEmotionalState(String userId) {
    if (!_emotionalStates.containsKey(userId)) {
      _emotionalStates[userId] = emotional_transfer.EmotionalState();
    }
    return _emotionalStates[userId]!;
  }
  
  /// 감정 상태 초기화
  void resetEmotionalState(String userId) {
    _emotionalStates.remove(userId);
  }
  
  /// 감정 상태 요약
  Map<String, dynamic> getEmotionalSummary(String userId) {
    final state = _emotionalStates[userId];
    if (state == null) {
      return {
        'hasHistory': false,
        'currentEmotion': 'neutral',
      };
    }
    
    return {
      'hasHistory': true,
      'currentEmotion': state.primaryEmotion,
      'intensity': state.intensity,
      'recentEmotions': state.emotionHistory,
      'emotionFrequency': state.emotionFrequency,
      'volatility': state.emotionVolatility,
      'trend': state.emotionTrend,
      'lastUpdated': state.lastUpdated.toIso8601String(),
    };
  }
}