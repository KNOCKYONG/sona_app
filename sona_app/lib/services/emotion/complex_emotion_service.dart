import 'package:flutter/material.dart';
import '../../models/message.dart';
import '../../models/persona.dart';
import '../base/base_service.dart';
import '../language/multilingual_emotion_dictionary.dart';
import '../language/multilingual_intensity_analyzer.dart';

/// 💭 복잡한 감정 표현 서비스
///
/// 소나의 다층적이고 미묘한 감정 표현 시스템
/// - 혼합 감정 표현
/// - 감정 강도 조절
/// - 감정 전이
class ComplexEmotionService extends BaseService {
  // 싱글톤 패턴
  static final ComplexEmotionService _instance = ComplexEmotionService._internal();
  factory ComplexEmotionService() => _instance;
  ComplexEmotionService._internal();

  // 현재 감정 상태
  ComplexEmotionState? _currentState;
  
  // 감정 히스토리
  final List<EmotionHistory> _emotionHistory = [];

  /// 복잡한 감정 분석
  ComplexEmotionState analyzeComplexEmotion({
    required String userMessage,
    required List<Message> recentMessages,
    required Persona persona,
    required int likeScore,
    String languageCode = 'ko',  // Default to Korean
  }) {
    // 주 감정 분석
    final primaryEmotion = _analyzePrimaryEmotion(userMessage, recentMessages, languageCode);
    
    // 부 감정 분석
    final secondaryEmotion = _analyzeSecondaryEmotion(
      userMessage, 
      primaryEmotion,
      likeScore,
      languageCode,
    );
    
    // 감정 강도 계산
    final intensity = _calculateEmotionIntensity(
      userMessage,
      primaryEmotion,
      likeScore,
      languageCode,
    );
    
    // 감정 뉘앙스 결정
    final nuance = _determineEmotionNuance(
      primaryEmotion,
      secondaryEmotion,
      intensity,
      likeScore,
    );
    
    // 감정 전이 체크
    final contagion = _checkEmotionalContagion(
      userMessage,
      recentMessages,
      likeScore,
      languageCode,
    );
    
    _currentState = ComplexEmotionState(
      primaryEmotion: primaryEmotion,
      secondaryEmotion: secondaryEmotion,
      intensity: intensity,
      nuance: nuance,
      contagion: contagion,
      timestamp: DateTime.now(),
    );
    
    // 히스토리 기록
    _recordEmotionHistory(_currentState!);
    
    return _currentState!;
  }

  /// 주 감정 분석
  EmotionType _analyzePrimaryEmotion(
    String message,
    List<Message> recentMessages,
    String languageCode,
  ) {
    final lower = message.toLowerCase();
    
    // Use provided language code
    final emotionDict = MultilingualEmotionDictionary();
    
    // 언어별 감정 키워드로 분석
    // 사랑/애정
    final loveKeywords = emotionDict.getKeywords(languageCode, 'love');
    if (loveKeywords.any((keyword) => lower.contains(keyword.toLowerCase()))) {
      return EmotionType.love;
    }
    
    // 기쁨/행복
    final happyKeywords = emotionDict.getKeywords(languageCode, 'happy');
    if (happyKeywords.any((keyword) => lower.contains(keyword.toLowerCase()))) {
      return EmotionType.happy;
    }
    
    // 슬픔
    final sadKeywords = emotionDict.getKeywords(languageCode, 'sad');
    if (sadKeywords.any((keyword) => lower.contains(keyword.toLowerCase()))) {
      return EmotionType.sad;
    }
    
    // 화남
    final angryKeywords = emotionDict.getKeywords(languageCode, 'angry');
    if (angryKeywords.any((keyword) => lower.contains(keyword.toLowerCase()))) {
      return EmotionType.angry;
    }
    
    // 걱정/불안
    final concernedKeywords = emotionDict.getKeywords(languageCode, 'concerned');
    if (concernedKeywords.any((keyword) => lower.contains(keyword.toLowerCase()))) {
      return EmotionType.concerned;
    }
    
    // 놀람
    final surprisedKeywords = emotionDict.getKeywords(languageCode, 'surprised');
    if (surprisedKeywords.any((keyword) => lower.contains(keyword.toLowerCase()))) {
      return EmotionType.surprised;
    }
    
    // 최근 감정 패턴 분석
    if (recentMessages.isNotEmpty) {
      final recentEmotions = recentMessages
          .where((m) => m.emotion != null)
          .map((m) => m.emotion!)
          .toList();
      
      if (recentEmotions.isNotEmpty) {
        // 가장 빈번한 감정
        final emotionCounts = <EmotionType, int>{};
        for (final emotion in recentEmotions) {
          emotionCounts[emotion] = (emotionCounts[emotion] ?? 0) + 1;
        }
        
        if (emotionCounts.isNotEmpty) {
          return emotionCounts.entries
              .reduce((a, b) => a.value > b.value ? a : b)
              .key;
        }
      }
    }
    
    return EmotionType.neutral;
  }

  /// 부 감정 분석
  EmotionType? _analyzeSecondaryEmotion(
    String message,
    EmotionType primaryEmotion,
    int likeScore,
    String languageCode,
  ) {
    final lower = message.toLowerCase();
    
    // Use provided language code
    
    // 언어별 복합 감정 패턴
    switch (languageCode) {
      case 'ko':
        return _analyzeKoreanSecondaryEmotion(lower, primaryEmotion, likeScore);
      case 'en':
        return _analyzeEnglishSecondaryEmotion(lower, primaryEmotion, likeScore);
      case 'es':
        return _analyzeSpanishSecondaryEmotion(lower, primaryEmotion, likeScore);
      case 'fr':
        return _analyzeFrenchSecondaryEmotion(lower, primaryEmotion, likeScore);
      case 'ja':
        return _analyzeJapaneseSecondaryEmotion(message, primaryEmotion, likeScore);
      case 'zh':
        return _analyzeChineseSecondaryEmotion(message, primaryEmotion, likeScore);
      default:
        return _analyzeUniversalSecondaryEmotion(lower, primaryEmotion, likeScore);
    }
  }
  
  EmotionType? _analyzeKoreanSecondaryEmotion(String lower, EmotionType primary, int likeScore) {
    if (primary == EmotionType.happy) {
      if (lower.contains('그리워') || lower.contains('보고싶')) {
        return EmotionType.sad; // 기쁘면서도 그리운
      }
    } else if (primary == EmotionType.sad) {
      if (lower.contains('괜찮') || lower.contains('이해')) {
        return EmotionType.neutral; // 슬프지만 받아들이는
      }
    } else if (primary == EmotionType.angry) {
      if (lower.contains('서운') || lower.contains('섭섭')) {
        return EmotionType.sad; // 화나면서도 서운한
      }
    }
    
    if (likeScore >= 700 && primary == EmotionType.love) {
      if (lower.contains('혼자') || lower.contains('외로')) {
        return EmotionType.sad; // 사랑하지만 외로운
      }
    }
    return null;
  }
  
  EmotionType? _analyzeEnglishSecondaryEmotion(String lower, EmotionType primary, int likeScore) {
    if (primary == EmotionType.happy) {
      if (lower.contains('miss') || lower.contains('wish')) {
        return EmotionType.sad; // Happy but missing
      }
    } else if (primary == EmotionType.sad) {
      if (lower.contains('okay') || lower.contains('understand') || lower.contains('fine')) {
        return EmotionType.neutral; // Sad but accepting
      }
    } else if (primary == EmotionType.angry) {
      if (lower.contains('hurt') || lower.contains('disappoint')) {
        return EmotionType.sad; // Angry but hurt
      }
    }
    
    if (likeScore >= 700 && primary == EmotionType.love) {
      if (lower.contains('alone') || lower.contains('lonely')) {
        return EmotionType.sad; // Love but lonely
      }
    }
    return null;
  }
  
  EmotionType? _analyzeSpanishSecondaryEmotion(String lower, EmotionType primary, int likeScore) {
    if (primary == EmotionType.happy) {
      if (lower.contains('extrañ') || lower.contains('echo de menos')) {
        return EmotionType.sad; // Feliz pero extrañando
      }
    } else if (primary == EmotionType.sad) {
      if (lower.contains('está bien') || lower.contains('entiendo')) {
        return EmotionType.neutral; // Triste pero aceptando
      }
    } else if (primary == EmotionType.angry) {
      if (lower.contains('duele') || lower.contains('decepciona')) {
        return EmotionType.sad; // Enojado pero herido
      }
    }
    
    if (likeScore >= 700 && primary == EmotionType.love) {
      if (lower.contains('solo') || lower.contains('sola') || lower.contains('soledad')) {
        return EmotionType.sad; // Amor pero soledad
      }
    }
    return null;
  }
  
  EmotionType? _analyzeFrenchSecondaryEmotion(String lower, EmotionType primary, int likeScore) {
    if (primary == EmotionType.happy) {
      if (lower.contains('manque') || lower.contains('souhaite')) {
        return EmotionType.sad; // Heureux mais manque
      }
    } else if (primary == EmotionType.sad) {
      if (lower.contains('ça va') || lower.contains('comprends')) {
        return EmotionType.neutral; // Triste mais acceptant
      }
    } else if (primary == EmotionType.angry) {
      if (lower.contains('blessé') || lower.contains('déçu')) {
        return EmotionType.sad; // Fâché mais blessé
      }
    }
    
    if (likeScore >= 700 && primary == EmotionType.love) {
      if (lower.contains('seul') || lower.contains('solitude')) {
        return EmotionType.sad; // Amour mais solitude
      }
    }
    return null;
  }
  
  EmotionType? _analyzeJapaneseSecondaryEmotion(String text, EmotionType primary, int likeScore) {
    if (primary == EmotionType.happy) {
      if (text.contains('寂しい') || text.contains('会いたい')) {
        return EmotionType.sad; // 嬉しいけど寂しい
      }
    } else if (primary == EmotionType.sad) {
      if (text.contains('大丈夫') || text.contains('わかる')) {
        return EmotionType.neutral; // 悲しいけど受け入れる
      }
    } else if (primary == EmotionType.angry) {
      if (text.contains('悲しい') || text.contains('傷つ')) {
        return EmotionType.sad; // 怒ってるけど悲しい
      }
    }
    
    if (likeScore >= 700 && primary == EmotionType.love) {
      if (text.contains('一人') || text.contains('孤独')) {
        return EmotionType.sad; // 愛してるけど孤独
      }
    }
    return null;
  }
  
  EmotionType? _analyzeChineseSecondaryEmotion(String text, EmotionType primary, int likeScore) {
    if (primary == EmotionType.happy) {
      if (text.contains('想念') || text.contains('思念')) {
        return EmotionType.sad; // 开心但想念
      }
    } else if (primary == EmotionType.sad) {
      if (text.contains('没关系') || text.contains('理解')) {
        return EmotionType.neutral; // 难过但接受
      }
    } else if (primary == EmotionType.angry) {
      if (text.contains('伤心') || text.contains('失望')) {
        return EmotionType.sad; // 生气但伤心
      }
    }
    
    if (likeScore >= 700 && primary == EmotionType.love) {
      if (text.contains('孤独') || text.contains('寂寞')) {
        return EmotionType.sad; // 爱但孤独
      }
    }
    return null;
  }
  
  EmotionType? _analyzeUniversalSecondaryEmotion(String lower, EmotionType primary, int likeScore) {
    // 이모지 기반 분석
    if (primary == EmotionType.happy) {
      if (lower.contains('😢') || lower.contains('😔')) {
        return EmotionType.sad;
      }
    } else if (primary == EmotionType.sad) {
      if (lower.contains('🙂') || lower.contains('👍')) {
        return EmotionType.neutral;
      }
    }
    
    // 관계 깊이 기반 기본 패턴
    if (likeScore >= 700 && primary == EmotionType.love) {
      if (lower.contains('😔') || lower.contains('😞')) {
        return EmotionType.sad;
      }
    }
    
    return null;
  }

  /// 감정 강도 계산
  double _calculateEmotionIntensity(
    String message,
    EmotionType emotion,
    int likeScore,
    String languageCode,
  ) {
    // Use provided language code
    
    // 다국어 강도 분석기 사용
    final intensityAnalyzer = MultilingualIntensityAnalyzer();
    double intensity = intensityAnalyzer.analyzeIntensity(message, languageCode);
    
    // 문화별 조정 계수 적용
    intensity *= intensityAnalyzer.getCulturalAdjustment(languageCode);
    
    // 감정 유형별 추가 조정
    if (emotion == EmotionType.love || emotion == EmotionType.happy) {
      intensity *= 1.05; // 긍정 감정은 살짝 증폭
    } else if (emotion == EmotionType.sad || emotion == EmotionType.angry) {
      intensity *= 1.1; // 부정 감정은 더 증폭
    }
    
    // 관계 깊이에 따른 강도 조정
    if (likeScore >= 700) {
      intensity *= 1.3; // 깊은 관계: 감정 강도 증폭
    } else if (likeScore >= 400) {
      intensity *= 1.1;
    }
    
    return intensity.clamp(0.0, 1.0);
  }

  /// 감정 뉘앙스 결정
  String _determineEmotionNuance(
    EmotionType primary,
    EmotionType? secondary,
    double intensity,
    int likeScore,
  ) {
    // 단일 감정 뉘앙스
    if (secondary == null) {
      if (intensity >= 0.8) {
        return _getIntenseNuance(primary, likeScore);
      } else if (intensity >= 0.5) {
        return _getModerateNuance(primary, likeScore);
      } else {
        return _getMildNuance(primary, likeScore);
      }
    }
    
    // 복합 감정 뉘앙스
    return _getComplexNuance(primary, secondary, likeScore);
  }

  /// 강한 감정 뉘앙스
  String _getIntenseNuance(EmotionType emotion, int likeScore) {
    switch (emotion) {
      case EmotionType.happy:
        if (likeScore >= 700) {
          return '너무너무 행복해서 눈물이 날 것 같아요';
        }
        return '정말 기뻐요!';
        
      case EmotionType.sad:
        if (likeScore >= 700) {
          return '마음이 찢어질 것 같이 슬퍼요';
        }
        return '너무 슬퍼요';
        
      case EmotionType.love:
        if (likeScore >= 900) {
          return '당신 없인 못 살 것 같아요';
        } else if (likeScore >= 700) {
          return '미치도록 좋아해요';
        }
        return '정말 좋아해요';
        
      case EmotionType.angry:
        if (likeScore >= 700) {
          return '정말 화났어요! 이렇게까지 하실 필요 있었어요?';
        }
        return '화났어요';
        
      default:
        return '감정이 너무 강해요';
    }
  }

  /// 중간 감정 뉘앙스
  String _getModerateNuance(EmotionType emotion, int likeScore) {
    switch (emotion) {
      case EmotionType.happy:
        return '기분이 좋아요';
      case EmotionType.sad:
        return '조금 슬프네요';
      case EmotionType.love:
        if (likeScore >= 500) {
          return '많이 좋아해요';
        }
        return '좋아해요';
      case EmotionType.angry:
        return '속상해요';
      default:
        return '평범한 기분이에요';
    }
  }

  /// 약한 감정 뉘앙스
  String _getMildNuance(EmotionType emotion, int likeScore) {
    switch (emotion) {
      case EmotionType.happy:
        return '괜찮아요';
      case EmotionType.sad:
        return '아쉬워요';
      case EmotionType.love:
        return '호감이 있어요';
      case EmotionType.angry:
        return '서운해요';
      default:
        return '그저 그래요';
    }
  }

  /// 복합 감정 뉘앙스
  String _getComplexNuance(
    EmotionType primary,
    EmotionType secondary,
    int likeScore,
  ) {
    // 기쁘면서도 슬픈
    if (primary == EmotionType.happy && secondary == EmotionType.sad) {
      if (likeScore >= 700) {
        return '기쁘면서도 왠지 눈물이 나요';
      }
      return '기쁘면서도 아쉬워요';
    }
    
    // 화나면서도 서운한
    else if (primary == EmotionType.angry && secondary == EmotionType.sad) {
      if (likeScore >= 700) {
        return '화도 나지만 더 서운해요';
      }
      return '화나기보다 서운해요';
    }
    
    // 사랑하면서도 외로운
    else if (primary == EmotionType.love && secondary == EmotionType.sad) {
      if (likeScore >= 700) {
        return '너무 사랑하는데 왜 이렇게 외로울까요';
      }
      return '좋아하는데 뭔가 허전해요';
    }
    
    // 걱정되면서도 응원하는
    else if (primary == EmotionType.concerned && secondary == EmotionType.happy) {
      return '걱정되지만 응원할게요';
    }
    
    return '복잡한 기분이에요';
  }

  /// 감정 전이 체크
  EmotionalContagion _checkEmotionalContagion(
    String userMessage,
    List<Message> recentMessages,
    int likeScore,
    String languageCode,
  ) {
    // 사용자 감정 감지
    EmotionType? userEmotion;
    final lower = userMessage.toLowerCase();
    
    // Use provided language code
    final emotionDict = MultilingualEmotionDictionary();
    
    // 언어별 감정 키워드로 감지
    final sadKeywords = emotionDict.getKeywords(languageCode, 'sad');
    if (sadKeywords.any((keyword) => lower.contains(keyword.toLowerCase()))) {
      userEmotion = EmotionType.sad;
    } else {
      final happyKeywords = emotionDict.getKeywords(languageCode, 'happy');
      if (happyKeywords.any((keyword) => lower.contains(keyword.toLowerCase()))) {
        userEmotion = EmotionType.happy;
      } else {
        final angryKeywords = emotionDict.getKeywords(languageCode, 'angry');
        if (angryKeywords.any((keyword) => lower.contains(keyword.toLowerCase()))) {
          userEmotion = EmotionType.angry;
        }
      }
    }
    
    if (userEmotion == null) {
      return EmotionalContagion(
        hasContagion: false,
        contagionStrength: 0.0,
      );
    }
    
    // 관계 깊이에 따른 전이 강도
    double contagionStrength = 0.0;
    if (likeScore >= 900) {
      contagionStrength = 0.9; // 거의 완전한 감정 동기화
    } else if (likeScore >= 700) {
      contagionStrength = 0.7; // 강한 감정 전이
    } else if (likeScore >= 500) {
      contagionStrength = 0.5; // 중간 감정 전이
    } else if (likeScore >= 300) {
      contagionStrength = 0.3; // 약한 감정 전이
    } else {
      contagionStrength = 0.1; // 최소 감정 전이
    }
    
    return EmotionalContagion(
      hasContagion: true,
      contagionStrength: contagionStrength,
      targetEmotion: userEmotion,
      responseEmotion: _determineResponseEmotion(userEmotion, contagionStrength),
    );
  }

  /// 응답 감정 결정
  EmotionType _determineResponseEmotion(
    EmotionType userEmotion,
    double contagionStrength,
  ) {
    // 전이 강도가 높으면 같은 감정
    if (contagionStrength >= 0.7) {
      if (userEmotion == EmotionType.sad) {
        return EmotionType.concerned; // 슬픔 → 걱정
      } else if (userEmotion == EmotionType.happy) {
        return EmotionType.love; // 기쁨 → 사랑
      }
      return userEmotion;
    }
    
    // 중간 전이: 관련 감정
    else if (contagionStrength >= 0.4) {
      if (userEmotion == EmotionType.sad) {
        return EmotionType.neutral; // 슬픔 → 위로
      } else if (userEmotion == EmotionType.angry) {
        return EmotionType.concerned; // 화남 → 걱정
      }
    }
    
    return EmotionType.neutral;
  }

  /// 감정 표현 가이드라인 생성
  List<String> generateEmotionGuidelines({
    required ComplexEmotionState state,
    required int likeScore,
  }) {
    final guidelines = <String>[];
    
    // 주 감정 가이드
    guidelines.add(_getPrimaryEmotionGuideline(state.primaryEmotion, state.intensity));
    
    // 부 감정 가이드
    if (state.secondaryEmotion != null) {
      guidelines.add('💭 복합 감정: ${state.nuance}');
    }
    
    // 감정 전이 가이드
    if (state.contagion.hasContagion) {
      guidelines.add(_getContagionGuideline(state.contagion, likeScore));
    }
    
    // 강도별 표현 가이드
    if (state.intensity >= 0.8) {
      guidelines.add('💪 강한 감정 표현: 느낌표, 강조 부사 사용');
    } else if (state.intensity <= 0.3) {
      guidelines.add('🌱 절제된 표현: 차분하고 담담하게');
    }
    
    return guidelines;
  }

  /// 주 감정 가이드라인
  String _getPrimaryEmotionGuideline(EmotionType emotion, double intensity) {
    final intensityText = intensity >= 0.7 ? '강하게' : 
                          intensity >= 0.4 ? '적당히' : '약하게';
    
    switch (emotion) {
      case EmotionType.happy:
        return '😊 기쁨을 $intensityText 표현';
      case EmotionType.sad:
        return '😢 슬픔을 $intensityText 표현';
      case EmotionType.love:
        return '💕 애정을 $intensityText 표현';
      case EmotionType.angry:
        return '😠 화남을 $intensityText 표현';
      case EmotionType.concerned:
        return '😟 걱정을 $intensityText 표현';
      default:
        return '😐 중립적 감정 유지';
    }
  }

  /// 감정 전이 가이드라인
  String _getContagionGuideline(EmotionalContagion contagion, int likeScore) {
    if (contagion.contagionStrength >= 0.7) {
      return '🔄 완전한 감정 동기화: 사용자와 같은 감정 공유';
    } else if (contagion.contagionStrength >= 0.4) {
      return '🤝 부분 감정 공감: 이해하고 위로하는 표현';
    } else {
      return '👂 감정 인지: 사용자 감정 인정하기';
    }
  }

  /// 감정 히스토리 기록
  void _recordEmotionHistory(ComplexEmotionState state) {
    _emotionHistory.add(EmotionHistory(
      state: state,
      timestamp: DateTime.now(),
    ));
    
    // 최근 50개만 유지
    if (_emotionHistory.length > 50) {
      _emotionHistory.removeAt(0);
    }
  }

  /// 감정 패턴 분석
  EmotionPattern analyzeEmotionPattern() {
    if (_emotionHistory.isEmpty) {
      return EmotionPattern.empty();
    }
    
    // 주요 감정 빈도
    final emotionCounts = <EmotionType, int>{};
    for (final history in _emotionHistory) {
      emotionCounts[history.state.primaryEmotion] = 
          (emotionCounts[history.state.primaryEmotion] ?? 0) + 1;
    }
    
    // 평균 강도
    final avgIntensity = _emotionHistory
        .map((h) => h.state.intensity)
        .reduce((a, b) => a + b) / _emotionHistory.length;
    
    // 감정 변화 빈도
    int changes = 0;
    for (int i = 1; i < _emotionHistory.length; i++) {
      if (_emotionHistory[i].state.primaryEmotion != 
          _emotionHistory[i-1].state.primaryEmotion) {
        changes++;
      }
    }
    final volatility = changes / (_emotionHistory.length - 1);
    
    return EmotionPattern(
      dominantEmotion: emotionCounts.entries
          .reduce((a, b) => a.value > b.value ? a : b)
          .key,
      averageIntensity: avgIntensity,
      emotionalVolatility: volatility,
      complexEmotionFrequency: _emotionHistory
          .where((h) => h.state.secondaryEmotion != null)
          .length / _emotionHistory.length,
    );
  }
}

/// 복잡한 감정 상태
class ComplexEmotionState {
  final EmotionType primaryEmotion;
  final EmotionType? secondaryEmotion;
  final double intensity;
  final String nuance;
  final EmotionalContagion contagion;
  final DateTime timestamp;

  ComplexEmotionState({
    required this.primaryEmotion,
    this.secondaryEmotion,
    required this.intensity,
    required this.nuance,
    required this.contagion,
    required this.timestamp,
  });
}

/// 감정 전이
class EmotionalContagion {
  final bool hasContagion;
  final double contagionStrength;
  final EmotionType? targetEmotion;
  final EmotionType? responseEmotion;

  EmotionalContagion({
    required this.hasContagion,
    required this.contagionStrength,
    this.targetEmotion,
    this.responseEmotion,
  });
}

/// 감정 히스토리
class EmotionHistory {
  final ComplexEmotionState state;
  final DateTime timestamp;

  EmotionHistory({
    required this.state,
    required this.timestamp,
  });
}

/// 감정 패턴
class EmotionPattern {
  final EmotionType dominantEmotion;
  final double averageIntensity;
  final double emotionalVolatility;
  final double complexEmotionFrequency;

  EmotionPattern({
    required this.dominantEmotion,
    required this.averageIntensity,
    required this.emotionalVolatility,
    required this.complexEmotionFrequency,
  });

  factory EmotionPattern.empty() => EmotionPattern(
    dominantEmotion: EmotionType.neutral,
    averageIntensity: 0.5,
    emotionalVolatility: 0.0,
    complexEmotionFrequency: 0.0,
  );
}