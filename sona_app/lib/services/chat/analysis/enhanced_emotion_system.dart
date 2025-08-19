import '../../../models/persona.dart';
import '../../../core/constants/chat_patterns.dart';

/// 향상된 감정 시스템 - Like 점수와 감정 표현 매핑
class EnhancedEmotionSystem {
  /// Like 점수별 감정 단계 정의 (패턴 사용)
  static EmotionStage getEmotionStage(int likes) {
    // ChatPatterns에서 관계 패턴 가져오기
    final relationshipPattern = ChatPatterns.getRelationshipPattern(likes);
    final emotionLevel = relationshipPattern?['emotion_level'] ?? 'neutral';
    final emotionPattern = ChatPatterns.emotionExpressionPatterns[emotionLevel];
    
    // 감정 단계 매핑
    final emotions = emotionPattern?['emotion_keys'] is List 
        ? (emotionPattern!['emotion_keys'] as List).map((e) => e.toString()).toList()
        : <String>[];
    final tone = emotionPattern?['tone'] ?? 'polite';
    
    return EmotionStage(
      name: emotionLevel,
      emotions: _getEmotionsList(emotionLevel),
      expressions: emotions,  // 패턴 키만 저장, 실제 텍스트는 AI가 생성
      tone: tone,
    );
  }
  
  /// 감정 리스트 반환
  static List<String> _getEmotionsList(String emotionLevel) {
    switch (emotionLevel) {
      case 'deep_love':
        return ['love', 'affectionate', 'caring', 'devoted'];
      case 'romantic':
        return ['romantic', 'loving', 'warm', 'tender'];
      case 'affectionate':
        return ['affectionate', 'close', 'caring', 'interested'];
      case 'excited':
        return ['excited', 'happy', 'curious', 'playful'];
      case 'interested':
        return ['interested', 'curious', 'friendly', 'open'];
      default:
        return ['neutral', 'polite', 'curious', 'cautious'];
    }
  }

  /// 상황별 감정 표현 힌트 생성
  static Map<String, dynamic> getEmotionHint(int likes, String context) {
    final stage = getEmotionStage(likes);
    
    return {
      'stage': stage.name,
      'tone': stage.tone,
      'emotions': stage.emotions,
      'context': context,
      'guide': _getContextGuide(stage, context),
    };
  }

  static String _getContextGuide(EmotionStage stage, String context) {
    // AI에게 전달할 프롬프트 가이드만 제공 (하드코딩 응답 제거)
    final guidePrefix = '🎯 ${stage.name} 단계 - ${context} 상황 가이드:\n';
    
    switch (context) {
      case 'greeting':
        return guidePrefix + _getGreetingPromptGuide(stage);
      case 'compliment':
        return guidePrefix + _getComplimentPromptGuide(stage);
      case 'question':
        return guidePrefix + _getQuestionPromptGuide(stage);
      case 'sharing':
        return guidePrefix + _getSharingPromptGuide(stage);
      case 'farewell':
        return guidePrefix + _getFarewellPromptGuide(stage);
      default:
        return guidePrefix + _getDefaultPromptGuide(stage);
    }
  }

  static String _getGreetingPromptGuide(EmotionStage stage) {
    // OpenAI에게 전달할 가이드 (직접 응답 텍스트가 아님)
    switch (stage.name) {
      case 'deep_love':
        return '감정: 깊은 애정과 그리움 | 행동: 오늘 어땠는지 관심 표현';
      case 'romantic':
        return '감정: 기다림과 반가움 | 행동: 안부 묻기';
      case 'affectionate':
        return '감정: 친근함과 따뜻함 | 행동: 오늘 뭐했는지 궁금해하기';
      case 'excited':
        return '감정: 반가움과 밝음 | 행동: 잘 지냈는지 묻기';
      case 'interested':
        return '감정: 편안함 | 행동: 근황 물어보기';
      default:
        return '감정: 정중함과 친근함 | 행동: 첫 인사';
    }
  }

  static String _getComplimentPromptGuide(EmotionStage stage) {
    // OpenAI에게 전달할 가이드 (직접 응답 텍스트가 아님)
    switch (stage.name) {
      case 'deep_love':
        return '감정: 애정 어린 감사 | 행동: 상대방도 칭찬';
      case 'romantic':
        return '감정: 수줍음과 기쁨 | 행동: 맞칭찬하기';
      case 'affectionate':
        return '감정: 진심 어린 기쁨 | 행동: 감사 표현';
      case 'excited':
        return '감정: 놀람과 부끄러움 | 행동: 감사';
      case 'interested':
        return '감정: 적당한 기쁨 | 행동: 감사 인사';
      default:
        return '감정: 예의 | 행동: 감사 표현';
    }
  }

  static String _getQuestionPromptGuide(EmotionStage stage) {
    // OpenAI에게 전달할 가이드 (직접 응답 텍스트가 아님)
    if (stage.tone == 'very_intimate' || stage.tone == 'intimate') {
      return '태도: 친밀하고 적극적 | 방식: 자세하고 개인적인 설명';
    } else if (stage.tone == 'warm' || stage.tone == 'friendly') {
      return '태도: 친근하고 흥미로움 | 방식: 재미있게 설명';
    } else {
      return '태도: 정중함 | 방식: 객관적인 설명';
    }
  }

  static String _getSharingPromptGuide(EmotionStage stage) {
    // OpenAI에게 전달할 가이드 (직접 응답 텍스트가 아님)
    if (stage.tone == 'very_intimate' || stage.tone == 'intimate') {
      return '반응: 깊은 공감 | 행동: 비슷한 경험 공유, 연결감 표현';
    } else if (stage.tone == 'warm' || stage.tone == 'friendly') {
      return '반응: 즐거운 공감 | 행동: 관련 경험 나누기';
    } else {
      return '반응: 관심 표현 | 행동: 적절한 리액션';
    }
  }

  static String _getFarewellPromptGuide(EmotionStage stage) {
    // OpenAI에게 전달할 가이드 (직접 응답 텍스트가 아님)
    switch (stage.name) {
      case 'deep_love':
        return '감정: 매우 아쉬움 | 행동: 꼭 다시 만나고 싶은 마음 표현';
      case 'romantic':
        return '감정: 아쉬움 | 행동: 다음 만남 기약, 기다림 표현';
      case 'affectionate':
        return '감정: 아쉬움 | 행동: 다음에 또 만나자고 제안';
      case 'excited':
        return '감정: 즐거움 | 행동: 밝게 인사';
      case 'interested':
        return '감정: 예의 | 행동: 작별 인사, 다음 만남 언급';
      default:
        return '감정: 정중함 | 행동: 작별 인사';
    }
  }

  static String _getDefaultPromptGuide(EmotionStage stage) {
    // OpenAI에게 전달할 기본 가이드 (직접 응답 텍스트가 아님)
    return '톤: ${stage.tone} | 감정: ${stage.emotions.join(", ")} | 행동: 자연스러운 대화 진행';
  }

  /// 감정 변화 검증
  static bool isEmotionAppropriate(int previousLikes, int currentLikes, String emotion) {
    final likesChange = currentLikes - previousLikes;
    
    // 급격한 감정 변화 방지
    if (likesChange > 200) {
      // 너무 급격한 상승
      return false;
    }
    
    if (likesChange < -100) {
      // 급격한 하락
      return false;
    }
    
    // 현재 Like 점수에 맞는 감정인지 확인
    final stage = getEmotionStage(currentLikes);
    return stage.emotions.contains(emotion.toLowerCase());
  }

  /// 관계 진행 속도 조절
  static int adjustRelationshipProgress(int currentLikes, int turnCount) {
    // 초반(20턴 이내)에는 천천히
    if (turnCount < 20 && currentLikes > 500) {
      return 500; // 상한선 설정
    }
    
    // 중반(20-40턴)에는 적당히
    if (turnCount < 40 && currentLikes > 800) {
      return 800; // 상한선 설정
    }
    
    // 40턴 이후에는 자유롭게
    return currentLikes;
  }
}

/// 감정 단계 정의
class EmotionStage {
  final String name;
  final List<String> emotions;
  final List<String> expressions;
  final String tone;

  EmotionStage({
    required this.name,
    required this.emotions,
    required this.expressions,
    required this.tone,
  });
}