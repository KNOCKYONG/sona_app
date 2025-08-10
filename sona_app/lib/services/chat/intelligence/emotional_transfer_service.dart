import 'package:flutter/material.dart';
import '../../../models/message.dart';
import '../../../models/persona.dart';

/// 감정 상태 추적
class EmotionalState {
  String primaryEmotion = 'neutral';
  double intensity = 0.5; // 0.0 ~ 1.0
  List<String> emotionHistory = [];
  DateTime lastUpdated = DateTime.now();
  Map<String, int> emotionFrequency = {};
  
  void updateEmotion(String emotion, double newIntensity) {
    primaryEmotion = emotion;
    intensity = newIntensity;
    lastUpdated = DateTime.now();
    
    // 히스토리 업데이트
    emotionHistory.add(emotion);
    if (emotionHistory.length > 10) {
      emotionHistory.removeAt(0);
    }
    
    // 빈도 업데이트
    emotionFrequency[emotion] = (emotionFrequency[emotion] ?? 0) + 1;
  }
  
  String getDominantEmotion() {
    if (emotionFrequency.isEmpty) return 'neutral';
    
    return emotionFrequency.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }
}

/// 감정 전이 서비스
/// 사용자의 감정을 자연스럽게 미러링하고 공감
class EmotionalTransferService {
  static EmotionalTransferService? _instance;
  static EmotionalTransferService get instance => 
      _instance ??= EmotionalTransferService._();
  
  EmotionalTransferService._();
  
  // 감정 전이 히스토리
  final Map<String, EmotionalState> _emotionalStateCache = {};
  
  /// 감정 전이 분석 및 미러링 가이드 생성
  String generateEmotionalMirrorGuide({
    required String userId,
    required String personaId,
    required String userMessage,
    required List<Message> chatHistory,
    required Persona persona,
  }) {
    final key = '${userId}_$personaId';
    _emotionalStateCache[key] ??= EmotionalState();
    final emotionalState = _emotionalStateCache[key]!;
    
    // 현재 메시지의 감정 분석
    final currentEmotion = _analyzeEmotion(userMessage);
    final intensity = _calculateIntensity(userMessage);
    
    // 감정 상태 업데이트
    emotionalState.updateEmotion(currentEmotion.emotion, intensity);
    
    // 미러링 가이드 생성
    final guide = StringBuffer();
    
    // 1. 기본 감정 미러링
    final mirrorLevel = _determineMirrorLevel(intensity, persona.mbti);
    guide.writeln('🪞 감정 미러링: ${currentEmotion.emotion} (${mirrorLevel})');
    
    // 2. 감정 전이 표현
    final transferExpression = _generateTransferExpression(
      currentEmotion,
      intensity,
      mirrorLevel,
    );
    if (transferExpression.isNotEmpty) {
      guide.writeln('💭 $transferExpression');
    }
    
    // 3. 감정 변화 대응
    if (_hasEmotionalShift(emotionalState)) {
      final shiftResponse = _generateShiftResponse(emotionalState);
      guide.writeln('🔄 $shiftResponse');
    }
    
    // 4. 감정 강도별 대응
    final intensityGuide = _generateIntensityGuide(intensity);
    guide.writeln('📊 $intensityGuide');
    
    // 5. MBTI별 감정 표현 스타일
    final mbtiStyle = _getMbtiEmotionalStyle(persona.mbti, currentEmotion.emotion);
    if (mbtiStyle.isNotEmpty) {
      guide.writeln('🧬 $mbtiStyle');
    }
    
    return guide.toString().trim();
  }
  
  /// 감정 분석
  EmotionAnalysis _analyzeEmotion(String message) {
    // 긍정 감정
    if (_containsAny(message, ['행복', '기쁘', '좋', '최고', '대박', '신나'])) {
      return EmotionAnalysis('joy', ['😊', '😄', 'ㅎㅎ']);
    }
    
    // 부정 감정
    if (_containsAny(message, ['슬프', '우울', '힘들', '아프', '외로'])) {
      return EmotionAnalysis('sadness', ['😢', '😔', 'ㅠㅠ']);
    }
    
    if (_containsAny(message, ['화나', '짜증', '답답', '열받'])) {
      return EmotionAnalysis('anger', ['😤', '😠']);
    }
    
    if (_containsAny(message, ['무서', '두려', '불안', '걱정'])) {
      return EmotionAnalysis('fear', ['😰', '😟']);
    }
    
    // 놀람
    if (_containsAny(message, ['놀라', '대박', '헐', '와', '진짜'])) {
      return EmotionAnalysis('surprise', ['😲', '😮', '!!']);
    }
    
    // 피곤/지침
    if (_containsAny(message, ['피곤', '졸려', '지쳐', '힘들'])) {
      return EmotionAnalysis('tired', ['😴', '😪']);
    }
    
    // 중립
    return EmotionAnalysis('neutral', ['🙂']);
  }
  
  /// 감정 강도 계산
  double _calculateIntensity(String message) {
    double intensity = 0.5; // 기본값
    
    // 강조 표현
    if (_containsAny(message, ['너무', '진짜', '완전', '정말', '매우'])) {
      intensity += 0.2;
    }
    
    // 느낌표
    final exclamationCount = '!'.allMatches(message).length;
    intensity += exclamationCount * 0.1;
    
    // 이모지
    final emojiPattern = RegExp(r'[\u{1F300}-\u{1F9FF}]', unicode: true);
    if (emojiPattern.hasMatch(message)) {
      intensity += 0.1;
    }
    
    // ㅋㅋ, ㅎㅎ, ㅠㅠ 등
    if (message.contains('ㅋㅋ') || message.contains('ㅎㅎ')) {
      intensity += 0.1;
    }
    if (message.contains('ㅠㅠ') || message.contains('ㅜㅜ')) {
      intensity += 0.15;
    }
    
    return intensity.clamp(0.0, 1.0);
  }
  
  /// 미러링 레벨 결정
  String _determineMirrorLevel(double intensity, String mbti) {
    // F 타입은 더 강하게 미러링
    final isFeeler = mbti.contains('F');
    
    if (intensity > 0.7) {
      return isFeeler ? '강한 공감' : '적절한 공감';
    } else if (intensity > 0.4) {
      return '부드러운 공감';
    } else {
      return '가벼운 인정';
    }
  }
  
  /// 감정 전이 표현 생성
  String _generateTransferExpression(
    EmotionAnalysis emotion,
    double intensity,
    String mirrorLevel,
  ) {
    final expressions = <String, List<String>>{
      'joy': [
        '나도 기분 좋아지네',
        '듣는 나도 신나',
        '좋은 일이네!',
      ],
      'sadness': [
        '마음이 아프네',
        '나도 속상해',
        '힘들었겠다',
      ],
      'anger': [
        '정말 화나겠다',
        '나도 답답하네',
        '이해가 돼',
      ],
      'fear': [
        '걱정되겠다',
        '불안한 마음 이해해',
        '괜찮을 거야',
      ],
      'surprise': [
        '나도 놀랐어',
        '정말 대박이다',
        '믿기지 않아',
      ],
      'tired': [
        '정말 고생했네',
        '푹 쉬어야겠다',
        '수고했어',
      ],
    };
    
    final emotionExpressions = expressions[emotion.emotion] ?? [];
    if (emotionExpressions.isEmpty) return '';
    
    // 강도에 따라 표현 선택
    if (intensity > 0.7 && mirrorLevel == '강한 공감') {
      return '${emotionExpressions.first} 진짜...';
    } else if (intensity > 0.4) {
      final index = DateTime.now().millisecond % emotionExpressions.length;
      return emotionExpressions[index];
    }
    
    return '';
  }
  
  /// 감정 변화 감지
  bool _hasEmotionalShift(EmotionalState state) {
    if (state.emotionHistory.length < 2) return false;
    
    final recent = state.emotionHistory.last;
    final previous = state.emotionHistory[state.emotionHistory.length - 2];
    
    return recent != previous && recent != 'neutral';
  }
  
  /// 감정 변화 대응 생성
  String _generateShiftResponse(EmotionalState state) {
    final recent = state.emotionHistory.last;
    final previous = state.emotionHistory.isNotEmpty 
        ? state.emotionHistory[state.emotionHistory.length - 2]
        : 'neutral';
    
    // 부정 → 긍정
    if (_isNegative(previous) && _isPositive(recent)) {
      return '감정 전환: 기분이 나아진 것 같아 다행이야';
    }
    
    // 긍정 → 부정
    if (_isPositive(previous) && _isNegative(recent)) {
      return '감정 전환: 갑자기 기분이 안 좋아진 것 같네';
    }
    
    return '감정 변화 인지하고 자연스럽게 따라가기';
  }
  
  /// 감정 강도별 가이드
  String _generateIntensityGuide(double intensity) {
    if (intensity > 0.8) {
      return '강도: 매우 높음 - 적극적 공감과 지지';
    } else if (intensity > 0.6) {
      return '강도: 높음 - 충분한 공감 표현';
    } else if (intensity > 0.4) {
      return '강도: 보통 - 자연스러운 반응';
    } else {
      return '강도: 낮음 - 가벼운 인정';
    }
  }
  
  /// MBTI별 감정 표현 스타일
  String _getMbtiEmotionalStyle(String mbti, String emotion) {
    final typeIndicator = mbti[2]; // T or F
    
    if (typeIndicator == 'F') {
      // Feeling 타입
      return emotion == 'joy' ? '함께 기뻐하며 축하' :
             emotion == 'sadness' ? '깊은 공감과 위로' :
             emotion == 'anger' ? '감정 인정과 지지' :
             '따뜻한 감정 표현';
    } else {
      // Thinking 타입
      return emotion == 'joy' ? '논리적 축하와 인정' :
             emotion == 'sadness' ? '실용적 조언과 해결책' :
             emotion == 'anger' ? '원인 분석과 대안 제시' :
             '차분한 감정 인정';
    }
  }
  
  /// 헬퍼 메서드들
  bool _containsAny(String text, List<String> keywords) {
    return keywords.any((keyword) => text.contains(keyword));
  }
  
  bool _isPositive(String emotion) {
    return ['joy', 'surprise'].contains(emotion);
  }
  
  bool _isNegative(String emotion) {
    return ['sadness', 'anger', 'fear', 'tired'].contains(emotion);
  }
  
  /// 감정 상태 리셋
  void resetEmotionalState(String userId, String personaId) {
    final key = '${userId}_$personaId';
    _emotionalStateCache.remove(key);
  }
  
  /// 디버그 정보
  void printDebugInfo(String userId, String personaId) {
    final key = '${userId}_$personaId';
    final state = _emotionalStateCache[key];
    
    if (state != null) {
      debugPrint('=== Emotional Transfer Debug ===');
      debugPrint('Primary emotion: ${state.primaryEmotion}');
      debugPrint('Intensity: ${state.intensity}');
      debugPrint('Dominant: ${state.getDominantEmotion()}');
      debugPrint('History: ${state.emotionHistory}');
    }
  }
}

/// 감정 분석 결과
class EmotionAnalysis {
  final String emotion;
  final List<String> expressions;
  
  EmotionAnalysis(this.emotion, this.expressions);
}