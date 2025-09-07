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
    // Guide for OpenAI API (English prompts only - NO direct Korean text)
    switch (stage.name) {
      case 'deep_love':
        return 'emotion: deep affection and longing | action: show interest in how their day was';
      case 'romantic':
        return 'emotion: anticipation and joy | action: ask how they have been';
      case 'affectionate':
        return 'emotion: warmth and friendliness | action: curious about what they did today';
      case 'excited':
        return 'emotion: excitement and brightness | action: ask if they are doing well';
      case 'interested':
        return 'emotion: comfortable | action: ask about recent updates';
      default:
        return 'emotion: polite and friendly | action: first greeting';
    }
  }

  static String _getComplimentPromptGuide(EmotionStage stage) {
    // Guide for OpenAI API (English prompts only - NO direct Korean text)
    switch (stage.name) {
      case 'deep_love':
        return 'emotion: affectionate gratitude | action: compliment them back';
      case 'romantic':
        return 'emotion: shy and happy | action: return the compliment';
      case 'affectionate':
        return 'emotion: sincere joy | action: express thanks';
      case 'excited':
        return 'emotion: surprised and bashful | action: thank them';
      case 'interested':
        return 'emotion: moderate happiness | action: say thanks';
      default:
        return 'emotion: polite | action: express gratitude';
    }
  }

  static String _getQuestionPromptGuide(EmotionStage stage) {
    // Guide for OpenAI API (English prompts only - NO direct Korean text)
    if (stage.tone == 'very_intimate' || stage.tone == 'intimate') {
      return 'attitude: intimate and proactive | style: detailed and personal explanation';
    } else if (stage.tone == 'warm' || stage.tone == 'friendly') {
      return 'attitude: friendly and interested | style: fun explanation';
    } else {
      return 'attitude: polite | style: objective explanation';
    }
  }

  static String _getSharingPromptGuide(EmotionStage stage) {
    // Guide for OpenAI API (English prompts only - NO direct Korean text)
    if (stage.tone == 'very_intimate' || stage.tone == 'intimate') {
      return 'reaction: deep empathy | action: share similar experience, express connection';
    } else if (stage.tone == 'warm' || stage.tone == 'friendly') {
      return 'reaction: joyful empathy | action: share related experience';
    } else {
      return 'reaction: show interest | action: appropriate reaction';
    }
  }

  static String _getFarewellPromptGuide(EmotionStage stage) {
    // Guide for OpenAI API (English prompts only - NO direct Korean text)
    switch (stage.name) {
      case 'deep_love':
        return 'emotion: very sad to leave | action: express strong desire to meet again';
      case 'romantic':
        return 'emotion: regretful | action: promise next meeting, express anticipation';
      case 'affectionate':
        return 'emotion: sad to leave | action: suggest meeting again';
      case 'excited':
        return 'emotion: happy | action: cheerful goodbye';
      case 'interested':
        return 'emotion: polite | action: farewell greeting, mention next time';
      default:
        return 'emotion: polite | action: farewell greeting';
    }
  }

  static String _getDefaultPromptGuide(EmotionStage stage) {
    // Guide for OpenAI API (English prompts only - NO direct Korean text)
    return 'tone: ${stage.tone} | emotions: ${stage.emotions.join(", ")} | action: natural conversation flow';
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