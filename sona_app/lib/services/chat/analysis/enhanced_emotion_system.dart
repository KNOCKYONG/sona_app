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
    // 하드코딩된 응답 대신 AI에게 가이드만 제공
    switch (context) {
      case 'greeting':
        return _getGreetingGuide(stage);
      case 'compliment':
        return _getComplimentGuide(stage);
      case 'question':
        return _getQuestionGuide(stage);
      case 'sharing':
        return _getSharingGuide(stage);
      case 'farewell':
        return _getFarewellGuide(stage);
      default:
        return _getDefaultGuide(stage);
    }
  }

  static String _getGreetingGuide(EmotionStage stage) {
    switch (stage.name) {
      case 'deep_love':
        return '깊은 애정과 그리움을 표현하며 인사. 오늘 어땠는지 관심 표현';
      case 'romantic':
        return '기다렸다는 마음을 담아 반갑게 인사. 안부 묻기';
      case 'affectionate':
        return '친근하고 따뜻하게 인사. 오늘 뭐했는지 궁금해하기';
      case 'excited':
        return '반가운 마음으로 밝게 인사. 잘 지냈는지 묻기';
      case 'interested':
        return '편안하게 인사하며 근황 물어보기';
      default:
        return '정중하고 친근하게 첫 인사';
    }
  }

  static String _getComplimentGuide(EmotionStage stage) {
    switch (stage.name) {
      case 'deep_love':
        return '칭찬에 대해 애정 어린 감사 표현. 상대방도 칭찬';
      case 'romantic':
        return '수줍으면서도 기쁜 마음으로 감사. 맞칭찬하기';
      case 'affectionate':
        return '진심으로 기뻐하며 감사 표현';
      case 'excited':
        return '놀라면서도 부끄러워하며 감사';
      case 'interested':
        return '적당히 기뻐하며 감사 인사';
      default:
        return '예의 바르게 감사 표현';
    }
  }

  static String _getQuestionGuide(EmotionStage stage) {
    // 질문에 대한 감정 가이드
    if (stage.tone == 'very_intimate' || stage.tone == 'intimate') {
      return '친밀하게 무엇이든 대답해주겠다는 마음 표현. 적극적으로 설명';
    } else if (stage.tone == 'warm' || stage.tone == 'friendly') {
      return '친근하게 설명해주려는 자세. 흥미롭게 대답';
    } else {
      return '정중하게 아는 범위 내에서 설명';
    }
  }

  static String _getSharingGuide(EmotionStage stage) {
    // 경험 공유시 감정 가이드
    if (stage.tone == 'very_intimate' || stage.tone == 'intimate') {
      return '깊은 공감과 함께 비슷한 경험 공유. 운명적 연결감 표현';
    } else if (stage.tone == 'warm' || stage.tone == 'friendly') {
      return '즐겁게 공감하며 관련 경험 나누기';
    } else {
      return '관심 있게 듣고 있다는 표현. 적절한 리액션';
    }
  }

  static String _getFarewellGuide(EmotionStage stage) {
    switch (stage.name) {
      case 'deep_love':
        return '헤어짐이 매우 아쉽다는 표현. 꼭 다시 만나고 싶은 마음';
      case 'romantic':
        return '아쉬움을 표현하며 다음 만남 기약. 기다리겠다는 마음';
      case 'affectionate':
        return '아쉬워하며 다음에 또 만나자고 제안';
      case 'excited':
        return '즐거웠다고 표현하며 밝게 인사';
      case 'interested':
        return '예의 바르게 작별 인사. 다음 만남 언급';
      default:
        return '정중한 작별 인사';
    }
  }

  static String _getDefaultGuide(EmotionStage stage) {
    return '${stage.tone} 톤으로 ${stage.emotions.join(", ")} 감정 표현';
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