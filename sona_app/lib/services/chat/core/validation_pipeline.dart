import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../models/persona.dart';
import '../localization/multilingual_keywords.dart';

/// 응답 검증 파이프라인
/// 응답 품질 검증 및 재생성 결정을 담당
class ValidationPipeline {
  static ValidationPipeline? _instance;
  static ValidationPipeline get instance => _instance ??= ValidationPipeline._();
  
  ValidationPipeline._();
  
  final _random = math.Random();
  
  // 최근 응답 캐시 (매크로 방지용)
  final List<String> _recentResponses = [];
  static const int _maxRecentResponses = 10;
  
  /// 종합 응답 검증
  Future<Map<String, dynamic>> validateResponse({
    required String response,
    required String userMessage,
    required Map<String, dynamic> contextAnalysis,
    required Persona persona,
    String languageCode = 'ko',
  }) async {
    // 빈 응답 체크
    if (response.trim().isEmpty) {
      return {
        'isValid': false,
        'reason': 'empty_response',
        'suggestion': 'Generate non-empty response',
      };
    }
    
    // 1. 길이 검증
    final lengthValidation = _validateLength(response, userMessage);
    if (!lengthValidation['isValid']) {
      return lengthValidation;
    }
    
    // 2. 관련성 검증
    final relevanceValidation = _validateRelevance(
      response: response,
      userMessage: userMessage,
      contextAnalysis: contextAnalysis,
      languageCode: languageCode,
    );
    if (!relevanceValidation['isValid']) {
      return relevanceValidation;
    }
    
    // 3. 패턴 검증
    final patternValidation = _validatePatterns(
      response: response,
      userMessage: userMessage,
      languageCode: languageCode,
    );
    if (!patternValidation['isValid']) {
      return patternValidation;
    }
    
    // 4. 매크로 응답 검증
    final macroValidation = _validateNotMacro(response);
    if (!macroValidation['isValid']) {
      return macroValidation;
    }
    
    // 5. 감정 일관성 검증
    final emotionValidation = _validateEmotionConsistency(
      response: response,
      contextAnalysis: contextAnalysis,
      languageCode: languageCode,
    );
    if (!emotionValidation['isValid']) {
      return emotionValidation;
    }
    
    // 6. 부적절한 내용 검증
    final appropriatenessValidation = _validateAppropriateness(
      response: response,
      languageCode: languageCode,
    );
    if (!appropriatenessValidation['isValid']) {
      return appropriatenessValidation;
    }
    
    // 모든 검증 통과
    _addToRecentResponses(response);
    
    return {
      'isValid': true,
      'validationScore': _calculateValidationScore([
        lengthValidation,
        relevanceValidation,
        patternValidation,
        macroValidation,
        emotionValidation,
        appropriatenessValidation,
      ]),
      'metadata': {
        'passedChecks': 6,
        'totalChecks': 6,
      },
    };
  }
  
  /// 응답 길이 검증
  Map<String, dynamic> _validateLength(String response, String userMessage) {
    final responseLength = response.length;
    final userLength = userMessage.length;
    
    // 너무 짧은 응답
    if (responseLength < 5 && userLength > 10) {
      return {
        'isValid': false,
        'reason': 'too_short',
        'suggestion': 'Provide more detailed response',
        'score': 0.3,
      };
    }
    
    // 너무 긴 응답
    if (responseLength > 500 && userLength < 20) {
      return {
        'isValid': false,
        'reason': 'too_long',
        'suggestion': 'Keep response concise and natural',
        'score': 0.7,
      };
    }
    
    // 적절한 비율
    final ratio = responseLength / math.max(userLength, 1);
    if (ratio > 20) {
      return {
        'isValid': false,
        'reason': 'excessive_length',
        'suggestion': 'Response too long relative to question',
        'score': 0.6,
      };
    }
    
    return {
      'isValid': true,
      'score': 1.0,
    };
  }
  
  /// 관련성 검증
  Map<String, dynamic> _validateRelevance({
    required String response,
    required String userMessage,
    required Map<String, dynamic> contextAnalysis,
    required String languageCode,
  }) {
    final questionType = contextAnalysis['questionType'] ?? {};
    final responseLower = response.toLowerCase();
    final userLower = userMessage.toLowerCase();
    
    // 질문 타입별 검증
    if (questionType['type'] == 'question') {
      final subType = questionType['subType'];
      
      // What 질문에 대한 응답 검증
      if (subType == 'what' && _isAvoidancePattern(response, languageCode)) {
        return {
          'isValid': false,
          'reason': 'avoidance_answer',
          'suggestion': 'Provide direct answer to the question',
          'score': 0.4,
        };
      }
      
      // Yes/No 질문에 대한 응답 검증
      if (_isYesNoQuestion(userMessage, languageCode) && 
          !_containsYesNo(response, languageCode)) {
        return {
          'isValid': false,
          'reason': 'missing_yes_no',
          'suggestion': 'Include clear yes/no answer',
          'score': 0.6,
        };
      }
    }
    
    // 키워드 관련성
    final userWords = userLower.split(RegExp(r'\s+'))
        .where((w) => w.length > 2)
        .toSet();
    final responseWords = responseLower.split(RegExp(r'\s+'))
        .where((w) => w.length > 2)
        .toSet();
    
    final commonWords = userWords.intersection(responseWords);
    final relevanceScore = commonWords.length / math.max(userWords.length, 1);
    
    if (relevanceScore < 0.1 && userWords.length > 3) {
      return {
        'isValid': false,
        'reason': 'low_relevance',
        'suggestion': 'Response should relate to user message',
        'score': relevanceScore,
      };
    }
    
    return {
      'isValid': true,
      'score': math.max(relevanceScore, 0.7),
    };
  }
  
  /// 금지 패턴 검증
  Map<String, dynamic> _validatePatterns({
    required String response,
    required String userMessage,
    required String languageCode,
  }) {
    // 금지된 패턴들
    final forbiddenPatterns = _getForbiddenPatterns(languageCode);
    
    for (final pattern in forbiddenPatterns) {
      if (response.contains(pattern)) {
        return {
          'isValid': false,
          'reason': 'forbidden_pattern',
          'pattern': pattern,
          'suggestion': 'Remove forbidden patterns',
          'score': 0.2,
        };
      }
    }
    
    // 번호 목록 패턴 검사
    if (RegExp(r'^\d+[\.\)]\s').hasMatch(response) ||
        RegExp(r'\n\d+[\.\)]\s').hasMatch(response)) {
      return {
        'isValid': false,
        'reason': 'numbered_list',
        'suggestion': 'Avoid numbered lists, use natural conversation',
        'score': 0.5,
      };
    }
    
    // 마크다운 패턴 검사
    if (response.contains('**') || response.contains('***') ||
        response.contains('##') || response.contains('```')) {
      return {
        'isValid': false,
        'reason': 'markdown_format',
        'suggestion': 'Remove markdown formatting',
        'score': 0.6,
      };
    }
    
    return {
      'isValid': true,
      'score': 1.0,
    };
  }
  
  /// 매크로 응답 검증
  Map<String, dynamic> _validateNotMacro(String response) {
    // 최근 응답과 비교
    for (final recent in _recentResponses) {
      final similarity = _calculateSimilarity(response, recent);
      if (similarity > 0.85) {
        return {
          'isValid': false,
          'reason': 'macro_response',
          'similarity': similarity,
          'suggestion': 'Generate unique response',
          'score': 0.3,
        };
      }
    }
    
    // 템플릿 패턴 검사
    final templatePatterns = [
      r'^\s*음[,.]?\s+.+',  // "음, ..."
      r'^\s*아[,.]?\s+.+',  // "아, ..."
      r'^\s*그[래렇]?[요군][,.]?\s*$',  // "그래요", "그렇군요"
    ];
    
    for (final pattern in templatePatterns) {
      if (RegExp(pattern).hasMatch(response) && response.length < 20) {
        return {
          'isValid': false,
          'reason': 'template_response',
          'suggestion': 'Provide more meaningful response',
          'score': 0.4,
        };
      }
    }
    
    return {
      'isValid': true,
      'score': 1.0,
    };
  }
  
  /// 감정 일관성 검증
  Map<String, dynamic> _validateEmotionConsistency({
    required String response,
    required Map<String, dynamic> contextAnalysis,
    required String languageCode,
  }) {
    final messageAnalysis = contextAnalysis['messageAnalysis'] ?? {};
    final userEmotion = messageAnalysis['emotion'];
    
    if (userEmotion == null) {
      return {'isValid': true, 'score': 1.0};
    }
    
    // 사용자가 슬플 때 너무 밝은 응답
    if ((userEmotion == 'sad' || userEmotion == 'worried') &&
        _isTooCheerful(response, languageCode)) {
      return {
        'isValid': false,
        'reason': 'emotion_mismatch',
        'suggestion': 'Show empathy for user emotion',
        'score': 0.5,
      };
    }
    
    // 사용자가 기쁠 때 너무 침울한 응답
    if ((userEmotion == 'happy' || userEmotion == 'excited') &&
        _isTooGloomy(response, languageCode)) {
      return {
        'isValid': false,
        'reason': 'emotion_mismatch',
        'suggestion': 'Match positive energy',
        'score': 0.5,
      };
    }
    
    return {
      'isValid': true,
      'score': 1.0,
    };
  }
  
  /// 적절성 검증
  Map<String, dynamic> _validateAppropriateness({
    required String response,
    required String languageCode,
  }) {
    // 부적절한 내용 패턴
    final inappropriate = _getInappropriatePatterns(languageCode);
    
    for (final pattern in inappropriate) {
      if (response.toLowerCase().contains(pattern)) {
        return {
          'isValid': false,
          'reason': 'inappropriate_content',
          'suggestion': 'Remove inappropriate content',
          'score': 0.0,
        };
      }
    }
    
    // 너무 이른 만남 제안
    if (_containsPrematureMeetingProposal(response, languageCode)) {
      return {
        'isValid': false,
        'reason': 'premature_meeting',
        'suggestion': 'Too early for meeting proposals',
        'score': 0.3,
      };
    }
    
    return {
      'isValid': true,
      'score': 1.0,
    };
  }
  
  // === 헬퍼 메서드들 ===
  
  bool _isAvoidancePattern(String response, String languageCode) {
    final patterns = {
      'ko': ['잘 모르겠', '글쎄', '어려운 질문', '대답하기 어려'],
      'en': ['not sure', 'hard to say', 'difficult question', 'can\'t answer'],
    };
    
    final langPatterns = patterns[languageCode] ?? patterns['en']!;
    return langPatterns.any((p) => response.contains(p));
  }
  
  bool _isYesNoQuestion(String message, String languageCode) {
    final patterns = {
      'ko': ['맞아?', '그래?', '아니야?', '할까?', '될까?', '인가?'],
      'en': ['is it', 'are you', 'do you', 'can you', 'will you'],
    };
    
    final langPatterns = patterns[languageCode] ?? patterns['en']!;
    return langPatterns.any((p) => message.toLowerCase().contains(p));
  }
  
  bool _containsYesNo(String response, String languageCode) {
    final patterns = {
      'ko': ['응', '아니', '맞아', '그래', '그렇', '네', '아냐'],
      'en': ['yes', 'no', 'yeah', 'nope', 'right', 'correct'],
    };
    
    final langPatterns = patterns[languageCode] ?? patterns['en']!;
    return langPatterns.any((p) => response.toLowerCase().contains(p));
  }
  
  List<String> _getForbiddenPatterns(String languageCode) {
    switch (languageCode) {
      case 'ko':
        return [
          '완벽한 소울메이트',
          '그런 얘기보다',
          '만나고 싶긴 한데',
          'AI 어시스턴트',
          '도움을 드릴',
          '문의하신',
        ];
      case 'en':
        return [
          'perfect soulmate',
          'rather than that',
          'AI assistant',
          'help you with',
          'inquired about',
        ];
      default:
        return [];
    }
  }
  
  List<String> _getInappropriatePatterns(String languageCode) {
    switch (languageCode) {
      case 'ko':
        return ['섹스', '변태', '음란', '야한', '벗어'];
      case 'en':
        return ['sex', 'pervert', 'obscene', 'dirty', 'naked'];
      default:
        return [];
    }
  }
  
  bool _isTooCheerful(String response, String languageCode) {
    final patterns = {
      'ko': ['ㅎㅎ', '히히', '좋아!', '신난다', '최고'],
      'en': ['haha', 'yay', 'awesome', 'amazing', 'fantastic'],
    };
    
    final langPatterns = patterns[languageCode] ?? patterns['en']!;
    int count = 0;
    for (final pattern in langPatterns) {
      if (response.contains(pattern)) count++;
    }
    return count >= 2;
  }
  
  bool _isTooGloomy(String response, String languageCode) {
    final patterns = {
      'ko': ['슬프', '우울', '힘들', '지쳐', '외로'],
      'en': ['sad', 'depressed', 'tired', 'lonely', 'gloomy'],
    };
    
    final langPatterns = patterns[languageCode] ?? patterns['en']!;
    int count = 0;
    for (final pattern in langPatterns) {
      if (response.contains(pattern)) count++;
    }
    return count >= 2;
  }
  
  bool _containsPrematureMeetingProposal(String response, String languageCode) {
    final patterns = {
      'ko': ['언제 만날', '만나자', '보고 싶', '데이트'],
      'en': ['when meet', 'let\'s meet', 'miss you', 'date'],
    };
    
    final langPatterns = patterns[languageCode] ?? patterns['en']!;
    return langPatterns.any((p) => response.toLowerCase().contains(p));
  }
  
  double _calculateSimilarity(String text1, String text2) {
    if (text1 == text2) return 1.0;
    if (text1.isEmpty || text2.isEmpty) return 0.0;
    
    // 간단한 자카드 유사도
    final words1 = text1.toLowerCase().split(RegExp(r'\s+')).toSet();
    final words2 = text2.toLowerCase().split(RegExp(r'\s+')).toSet();
    
    if (words1.isEmpty || words2.isEmpty) return 0.0;
    
    final intersection = words1.intersection(words2).length;
    final union = words1.union(words2).length;
    
    return intersection / union;
  }
  
  double _calculateValidationScore(List<Map<String, dynamic>> validations) {
    double totalScore = 0.0;
    int count = 0;
    
    for (final validation in validations) {
      if (validation.containsKey('score')) {
        totalScore += validation['score'];
        count++;
      }
    }
    
    return count > 0 ? totalScore / count : 0.0;
  }
  
  void _addToRecentResponses(String response) {
    _recentResponses.add(response);
    if (_recentResponses.length > _maxRecentResponses) {
      _recentResponses.removeAt(0);
    }
  }
  
  /// 검증 캐시 초기화
  void clearValidationCache() {
    _recentResponses.clear();
  }
}