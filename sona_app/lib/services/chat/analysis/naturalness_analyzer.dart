import 'package:flutter/foundation.dart';
import '../../../models/message.dart';
import 'dart:math' as math;

/// 대화 자연스러움 분석 및 개선 시스템
class NaturalnessAnalyzer {
  static final NaturalnessAnalyzer _instance = NaturalnessAnalyzer._internal();
  factory NaturalnessAnalyzer() => _instance;
  NaturalnessAnalyzer._internal();

  /// 자연스러움 점수 계산 (0.0 ~ 1.0)
  double calculateNaturalnessScore({
    required String userMessage,
    required String aiResponse,
    required List<Message> chatHistory,
  }) {
    double score = 0.0;
    
    // 1. 길이 적절성 (20%)
    score += _evaluateLengthAppropriateness(userMessage, aiResponse) * 0.2;
    
    // 2. 감정 일치도 (15%)
    score += _evaluateEmotionalAlignment(userMessage, aiResponse) * 0.15;
    
    // 3. 주제 연관성 (20%)
    score += _evaluateTopicRelevance(userMessage, aiResponse, chatHistory) * 0.2;
    
    // 4. 대화 흐름 (15%)
    score += _evaluateConversationFlow(chatHistory, aiResponse) * 0.15;
    
    // 5. 자연스러운 표현 (10%)
    score += _evaluateNaturalExpression(aiResponse) * 0.1;
    
    // 6. 개성 표현 (10%)
    score += _evaluatePersonalityExpression(aiResponse) * 0.1;
    
    // 7. 타이밍 적절성 (10%)
    score += _evaluateTimingAppropriateness(userMessage, aiResponse) * 0.1;
    
    return math.min(1.0, math.max(0.0, score));
  }

  /// 길이 적절성 평가
  double _evaluateLengthAppropriateness(String userMessage, String aiResponse) {
    final userLength = userMessage.length;
    final aiLength = aiResponse.length;
    
    // 이상적인 비율: 사용자 메시지의 0.8~1.5배
    final ratio = aiLength / math.max(1, userLength);
    
    if (ratio >= 0.8 && ratio <= 1.5) {
      return 1.0; // 완벽한 비율
    } else if (ratio >= 0.5 && ratio <= 2.0) {
      return 0.7; // 적절한 비율
    } else if (ratio >= 0.3 && ratio <= 3.0) {
      return 0.4; // 약간 부적절
    } else {
      return 0.1; // 매우 부적절
    }
  }

  /// 감정 일치도 평가
  double _evaluateEmotionalAlignment(String userMessage, String aiResponse) {
    // 사용자 감정 분석
    final userEmotion = _detectEmotion(userMessage);
    final aiEmotion = _detectEmotion(aiResponse);
    
    // 감정 매칭 매트릭스
    final emotionMatch = {
      'happy': {'happy': 1.0, 'neutral': 0.6, 'sad': 0.2, 'angry': 0.1},
      'sad': {'sad': 0.8, 'empathy': 1.0, 'neutral': 0.5, 'happy': 0.3},
      'angry': {'empathy': 0.9, 'neutral': 0.6, 'angry': 0.4, 'happy': 0.2},
      'neutral': {'neutral': 1.0, 'happy': 0.7, 'empathy': 0.6, 'sad': 0.4},
      'question': {'answer': 1.0, 'neutral': 0.6, 'question': 0.8},
    };
    
    return emotionMatch[userEmotion]?[aiEmotion] ?? 0.5;
  }

  /// 주제 연관성 평가
  double _evaluateTopicRelevance(
    String userMessage,
    String aiResponse,
    List<Message> chatHistory,
  ) {
    // 키워드 추출
    final userKeywords = _extractKeywords(userMessage);
    final aiKeywords = _extractKeywords(aiResponse);
    
    if (userKeywords.isEmpty || aiKeywords.isEmpty) {
      return 0.5; // 키워드가 없으면 중립 점수
    }
    
    // 공통 키워드 비율
    final commonKeywords = userKeywords.where((k) => aiKeywords.contains(k)).length;
    final relevance = commonKeywords / math.max(userKeywords.length, aiKeywords.length);
    
    // 최근 대화 맥락 고려
    if (chatHistory.length > 2) {
      final recentTopics = _getRecentTopics(chatHistory);
      final contextBonus = aiKeywords.any((k) => recentTopics.contains(k)) ? 0.2 : 0.0;
      return math.min(1.0, relevance + contextBonus);
    }
    
    return relevance;
  }

  /// 대화 흐름 평가
  double _evaluateConversationFlow(List<Message> chatHistory, String aiResponse) {
    if (chatHistory.isEmpty) return 0.7; // 첫 대화는 기본 점수
    
    // 최근 메시지들과의 연속성 확인
    final recentMessages = chatHistory.take(3).toList();
    
    // 반복 체크
    for (final msg in recentMessages) {
      if (!msg.isFromUser && _calculateSimilarity(msg.content, aiResponse) > 0.8) {
        return 0.2; // 반복된 응답
      }
    }
    
    // 주제 전환 부드러움
    if (recentMessages.isNotEmpty) {
      final lastMessage = recentMessages.first;
      if (!lastMessage.isFromUser) {
        // AI의 이전 메시지와 연결성
        if (_hasTransitionMarker(aiResponse)) {
          return 0.9; // 부드러운 전환
        }
      }
    }
    
    return 0.7; // 기본 흐름
  }

  /// 자연스러운 표현 평가
  double _evaluateNaturalExpression(String response) {
    double score = 0.7; // 기본 점수
    
    // 긍정 요소
    if (RegExp(r'[ㅋㅎㅠㅜ~!?♥♡]').hasMatch(response)) {
      score += 0.1; // 이모티콘 사용
    }
    
    if (_hasNaturalMarkers(response)) {
      score += 0.1; // 자연스러운 표현
    }
    
    if (_hasVariedSentenceStructure(response)) {
      score += 0.1; // 다양한 문장 구조
    }
    
    // 부정 요소
    if (_hasRoboticPatterns(response)) {
      score -= 0.3; // 기계적 패턴
    }
    
    if (_hasFormalLanguage(response)) {
      score -= 0.2; // 너무 격식체
    }
    
    return math.min(1.0, math.max(0.0, score));
  }

  /// 개성 표현 평가
  double _evaluatePersonalityExpression(String response) {
    double score = 0.5; // 기본 점수
    
    // 개성 요소들
    final personalityMarkers = {
      'playful': ['ㅋㅋ', 'ㅎㅎ', '헐', '대박', '진짜'],
      'caring': ['괜찮아', '힘내', '응원', '위로', '걱정'],
      'curious': ['궁금', '왜', '어떻게', '뭐', '언제'],
      'enthusiastic': ['!!', '완전', '엄청', '너무', '최고'],
    };
    
    int markerCount = 0;
    personalityMarkers.forEach((type, markers) {
      if (markers.any((m) => response.contains(m))) {
        markerCount++;
      }
    });
    
    // 개성 표현이 많을수록 높은 점수
    score += (markerCount * 0.15);
    
    return math.min(1.0, score);
  }

  /// 타이밍 적절성 평가
  double _evaluateTimingAppropriateness(String userMessage, String aiResponse) {
    // 질문에 대한 즉답 여부
    if (_isQuestion(userMessage)) {
      if (_hasAnswer(aiResponse)) {
        return 1.0; // 질문에 답변
      } else if (_hasQuestionBack(aiResponse)) {
        return 0.7; // 되물음
      } else {
        return 0.3; // 답변 회피
      }
    }
    
    // 감정 표현에 대한 반응
    if (_hasEmotionalExpression(userMessage)) {
      if (_hasEmpathy(aiResponse)) {
        return 1.0; // 공감 표현
      } else {
        return 0.5; // 공감 부족
      }
    }
    
    return 0.7; // 기본 점수
  }

  // === 헬퍼 메서드들 ===

  String _detectEmotion(String message) {
    if (RegExp(r'[ㅠㅜ]|슬프|우울|힘들').hasMatch(message)) return 'sad';
    if (RegExp(r'[ㅋㅎ]|기뻐|좋아|행복').hasMatch(message)) return 'happy';
    if (RegExp(r'화나|짜증|싫어').hasMatch(message)) return 'angry';
    if (message.contains('?')) return 'question';
    return 'neutral';
  }

  List<String> _extractKeywords(String message) {
    // 간단한 키워드 추출 (명사, 동사 위주)
    final words = message.split(RegExp(r'\s+'));
    return words.where((w) => w.length > 1).toList();
  }

  List<String> _getRecentTopics(List<Message> history) {
    final topics = <String>[];
    for (final msg in history.take(5)) {
      topics.addAll(_extractKeywords(msg.content));
    }
    return topics.toSet().toList();
  }

  double _calculateSimilarity(String text1, String text2) {
    // 간단한 유사도 계산
    final words1 = text1.split(' ').toSet();
    final words2 = text2.split(' ').toSet();
    
    if (words1.isEmpty || words2.isEmpty) return 0.0;
    
    final intersection = words1.intersection(words2).length;
    final union = words1.union(words2).length;
    
    return intersection / union;
  }

  bool _hasTransitionMarker(String response) {
    final markers = ['그런데', '그러고보니', '아 맞다', '참', '그보다', '어쨌든'];
    return markers.any((m) => response.contains(m));
  }

  bool _hasNaturalMarkers(String response) {
    final markers = ['음', '아', '어', '그래서', '근데', '진짜', '정말'];
    return markers.any((m) => response.contains(m));
  }

  bool _hasVariedSentenceStructure(String response) {
    // 문장 끝이 다양한지 확인
    return response.contains('!') && response.contains('?') ||
           response.contains('~') && response.contains('.');
  }

  bool _hasRoboticPatterns(String response) {
    // 기계적 패턴
    final patterns = [
      '알겠습니다',
      '이해했습니다',
      '확인했습니다',
      '처리하겠습니다'
    ];
    return patterns.any((p) => response.contains(p));
  }

  bool _hasFormalLanguage(String response) {
    return response.contains('습니다') || 
           response.contains('합니다') ||
           response.contains('입니다');
  }

  bool _isQuestion(String message) {
    return message.contains('?') || 
           RegExp(r'뭐|왜|어떻게|언제|어디|누구').hasMatch(message);
  }

  bool _hasAnswer(String response) {
    // 답변 패턴 확인
    return !response.contains('?') || response.split('?').first.length > 10;
  }

  bool _hasQuestionBack(String response) {
    return response.contains('?');
  }

  bool _hasEmotionalExpression(String message) {
    return RegExp(r'[ㅠㅜㅋㅎ]|기뻐|슬퍼|화나|좋아|싫어').hasMatch(message);
  }

  bool _hasEmpathy(String response) {
    final empathyWords = ['괜찮아', '힘내', '이해해', '그렇구나', '속상', '기뻐'];
    return empathyWords.any((w) => response.contains(w));
  }

  /// 응답 개선 제안
  Map<String, dynamic> suggestImprovements({
    required String userMessage,
    required String aiResponse,
    required double currentScore,
  }) {
    final suggestions = <String>[];
    
    if (currentScore < 0.5) {
      suggestions.add('응답이 너무 짧거나 길어요. 사용자 메시지와 비슷한 길이로 맞춰주세요.');
    }
    
    if (!_hasEmpathy(aiResponse) && _hasEmotionalExpression(userMessage)) {
      suggestions.add('사용자의 감정에 공감하는 표현을 추가해주세요.');
    }
    
    if (_isQuestion(userMessage) && !_hasAnswer(aiResponse)) {
      suggestions.add('질문에 먼저 답변한 후 대화를 이어가세요.');
    }
    
    if (!RegExp(r'[ㅋㅎㅠㅜ~!?]').hasMatch(aiResponse)) {
      suggestions.add('이모티콘이나 감정 표현을 추가하면 더 자연스러워요.');
    }
    
    return {
      'score': currentScore,
      'suggestions': suggestions,
      'needsImprovement': currentScore < 0.6,
    };
  }
}