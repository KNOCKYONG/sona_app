/// 📝 Chat Patterns - 하드코딩 제거를 위한 패턴 상수
/// 
/// 모든 대화 관련 패턴을 중앙 관리
/// 실제 텍스트는 OpenAI API가 생성, 여기서는 패턴만 정의
class ChatPatterns {
  // 생성자 방지
  ChatPatterns._();

  /// 🔍 관계 상태 패턴
  static const Map<String, dynamic> relationshipPatterns = {
    'perfect_love': {
      'min_likes': 900,
      'pattern_key': 'relationship_perfect_love',
      'emotion_level': 'deep_love',
      'context_hint': '깊은 사랑과 헌신을 나타내는 관계'
    },
    'lovers': {
      'min_likes': 600,
      'pattern_key': 'relationship_lovers',
      'emotion_level': 'romantic',
      'context_hint': '연인 관계, 로맨틱한 감정'
    },
    'dating': {
      'min_likes': 200,
      'pattern_key': 'relationship_dating',
      'emotion_level': 'affectionate',
      'context_hint': '썸타는 관계, 호감 단계'
    },
    'friends': {
      'min_likes': 0,
      'pattern_key': 'relationship_friends',
      'emotion_level': 'friendly',
      'context_hint': '친구 관계, 편안한 대화'
    },
  };

  /// 💕 감정 표현 패턴
  static const Map<String, dynamic> emotionExpressionPatterns = {
    'deep_love': {
      'emotion_keys': [
        'love_expression_deep',
        'missing_expression_intense',
        'caring_expression_devoted',
        'forever_expression'
      ],
      'tone': 'very_intimate',
      'context_hint': '깊은 애정과 헌신적인 감정 표현'
    },
    'romantic': {
      'emotion_keys': [
        'love_expression_soft',
        'missing_expression_normal',
        'happy_expression_together',
        'special_expression'
      ],
      'tone': 'intimate',
      'context_hint': '로맨틱하고 부드러운 감정 표현'
    },
    'affectionate': {
      'emotion_keys': [
        'like_expression_strong',
        'fun_expression',
        'continue_talking_expression',
        'getting_close_expression'
      ],
      'tone': 'warm',
      'context_hint': '따뜻하고 친근한 감정 표현'
    },
    'excited': {
      'emotion_keys': [
        'fun_expression',
        'like_expression',
        'curious_expression',
        'match_well_expression'
      ],
      'tone': 'friendly',
      'context_hint': '즐겁고 활발한 감정 표현'
    },
    'interested': {
      'emotion_keys': [
        'curious_expression',
        'tell_more_expression',
        'interesting_expression',
        'seems_good_expression'
      ],
      'tone': 'casual_friendly',
      'context_hint': '관심과 호기심을 나타내는 표현'
    },
    'neutral': {
      'emotion_keys': [
        'i_see_expression',
        'interesting_expression',
        'want_to_know_expression',
        'first_time_expression'
      ],
      'tone': 'polite',
      'context_hint': '중립적이고 정중한 표현'
    }
  };

  /// 🗣️ 상황별 대화 패턴
  static const Map<String, dynamic> contextualPatterns = {
    'greeting': {
      'patterns': {
        'deep_love': 'greeting_deep_affection',
        'romantic': 'greeting_waited',
        'affectionate': 'greeting_warm',
        'excited': 'greeting_bright',
        'interested': 'greeting_comfortable',
        'neutral': 'greeting_polite'
      },
      'context_hint': '관계 수준에 맞는 인사말'
    },
    'compliment_response': {
      'patterns': {
        'deep_love': 'compliment_loving_thanks',
        'romantic': 'compliment_shy_happy',
        'affectionate': 'compliment_sincere_joy',
        'excited': 'compliment_surprised_shy',
        'interested': 'compliment_moderate_thanks',
        'neutral': 'compliment_polite_thanks'
      },
      'context_hint': '칭찬에 대한 반응'
    },
    'farewell': {
      'patterns': {
        'deep_love': 'farewell_very_sad',
        'romantic': 'farewell_sad_promise',
        'affectionate': 'farewell_sad_next_time',
        'excited': 'farewell_enjoyed',
        'interested': 'farewell_polite_next',
        'neutral': 'farewell_polite'
      },
      'context_hint': '작별 인사'
    }
  };

  /// 👨‍💼 전문 직업별 가이드 패턴
  static const Map<String, String> professionalPatterns = {
    'developer': 'professional_developer_guide',
    'designer': 'professional_designer_guide',
    'teacher': 'professional_teacher_guide',
    'healthcare': 'professional_healthcare_guide',
    'default': 'professional_default_guide'
  };

  /// 🗺️ 지역 방언 패턴
  static const Map<String, String> dialectPatterns = {
    'busan': 'dialect_busan_pattern',
    'jeolla': 'dialect_jeolla_pattern',
    'gyeongsang': 'dialect_gyeongsang_pattern',
    'seoul': 'dialect_seoul_pattern',
    'default': 'dialect_standard_pattern'
  };

  /// 🔧 유틸리티 메서드
  
  /// 관계 패턴 가져오기
  static Map<String, dynamic>? getRelationshipPattern(int likes) {
    for (final pattern in relationshipPatterns.values) {
      if (likes >= pattern['min_likes']) {
        return pattern;
      }
    }
    return relationshipPatterns['friends'];
  }

  /// 감정 표현 패턴 가져오기
  static Map<String, dynamic>? getEmotionPattern(String emotionLevel) {
    return emotionExpressionPatterns[emotionLevel];
  }

  /// 상황별 패턴 가져오기
  static String? getContextualPattern(String context, String emotionLevel) {
    final contextPattern = contextualPatterns[context];
    if (contextPattern != null && contextPattern['patterns'] is Map) {
      return contextPattern['patterns'][emotionLevel];
    }
    return null;
  }

  /// OpenAI 프롬프트용 힌트 생성
  static String generatePromptHint({
    required int likes,
    required String context,
    String? profession,
    String? dialect,
  }) {
    final relationship = getRelationshipPattern(likes);
    final emotionLevel = relationship?['emotion_level'] ?? 'neutral';
    final emotionPattern = getEmotionPattern(emotionLevel);
    final contextPattern = getContextualPattern(context, emotionLevel);
    
    String hint = '''
[패턴 가이드]
관계: ${relationship?['context_hint'] ?? '일반적인 관계'}
감정 수준: ${emotionPattern?['context_hint'] ?? '중립적 감정'}
톤: ${emotionPattern?['tone'] ?? 'polite'}
''';

    if (contextPattern != null) {
      hint += '상황 패턴: $contextPattern\n';
    }

    if (profession != null && professionalPatterns.containsKey(profession)) {
      hint += '직업 특성: ${professionalPatterns[profession]}\n';
    }

    if (dialect != null && dialectPatterns.containsKey(dialect)) {
      hint += '방언 패턴: ${dialectPatterns[dialect]}\n';
    }

    return hint;
  }
}