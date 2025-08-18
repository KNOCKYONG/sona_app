import 'dart:collection';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// 사용자별 선호 패턴 학습 시스템
/// 실시간으로 사용자의 대화 패턴을 학습하고 적응
class UserPreferenceLearning {
  static final UserPreferenceLearning _instance = UserPreferenceLearning._internal();
  factory UserPreferenceLearning() => _instance;
  UserPreferenceLearning._internal();

  // 사용자별 학습 데이터
  final Map<String, UserPreferenceProfile> _userProfiles = {};
  
  // 학습 설정
  static const int _minDataPoints = 5;  // 최소 학습 데이터 포인트
  static const double _learningRate = 0.1;  // 학습률
  static const int _maxHistorySize = 100;  // 최대 히스토리 크기
  
  /// 사용자 프로필 가져오기 (없으면 생성)
  UserPreferenceProfile getUserProfile(String userId) {
    return _userProfiles.putIfAbsent(
      userId,
      () => UserPreferenceProfile(userId),
    );
  }

  /// 대화 패턴 학습
  Future<void> learnFromConversation({
    required String userId,
    required String userMessage,
    required String aiResponse,
    required double userSatisfaction,  // 0.0 ~ 1.0
    Map<String, dynamic>? context,
  }) async {
    final profile = getUserProfile(userId);
    
    // 1. 메시지 패턴 분석
    final messagePattern = _analyzeMessagePattern(userMessage);
    final responsePattern = _analyzeResponsePattern(aiResponse);
    
    // 2. 시간 패턴 분석
    final timePattern = _analyzeTimePattern();
    
    // 3. 감정 패턴 분석
    final emotionPattern = _analyzeEmotionPattern(userMessage);
    
    // 4. 선호도 업데이트
    profile.updatePreferences(
      messagePattern: messagePattern,
      responsePattern: responsePattern,
      satisfaction: userSatisfaction,
      timePattern: timePattern,
      emotionPattern: emotionPattern,
    );
    
    // 5. 컨텍스트 학습
    if (context != null) {
      profile.learnContext(context);
    }
    
    // 6. 대화 히스토리 저장
    profile.addToHistory(
      userMessage: userMessage,
      aiResponse: aiResponse,
      satisfaction: userSatisfaction,
    );
    
    // 7. 패턴 예측 모델 업데이트
    await _updatePredictionModel(profile);
    
    debugPrint('🧠 Learning from conversation for user: $userId');
    debugPrint('  - Message pattern: $messagePattern');
    debugPrint('  - Satisfaction: $userSatisfaction');
  }

  /// 사용자 선호 기반 응답 조정
  Map<String, dynamic> adjustResponseForUser({
    required String userId,
    required String basePrompt,
    required String userMessage,
  }) {
    final profile = getUserProfile(userId);
    
    if (!profile.hasEnoughData()) {
      return {
        'adjustedPrompt': basePrompt,
        'preferences': {},
        'confidence': 0.0,
      };
    }
    
    // 1. 선호 응답 길이 예측
    final preferredLength = profile.getPreferredResponseLength();
    
    // 2. 선호 감정 톤 예측
    final preferredTone = profile.getPreferredEmotionalTone();
    
    // 3. 선호 대화 스타일 예측
    final preferredStyle = profile.getPreferredConversationStyle();
    
    // 4. 관심 주제 예측
    final topicInterests = profile.getTopicInterests();
    
    // 5. 시간대별 선호 패턴
    final timePreference = profile.getTimeBasedPreference();
    
    // 프롬프트 조정
    String adjustedPrompt = basePrompt;
    
    // 응답 길이 조정
    if (preferredLength != null) {
      adjustedPrompt += '\n응답 길이: ${preferredLength['description']}';
    }
    
    // 감정 톤 조정
    if (preferredTone != null) {
      adjustedPrompt += '\n감정 톤: ${preferredTone['description']}';
    }
    
    // 대화 스타일 조정
    if (preferredStyle != null) {
      adjustedPrompt += '\n대화 스타일: ${preferredStyle['description']}';
    }
    
    // 관심 주제 반영
    if (topicInterests.isNotEmpty) {
      adjustedPrompt += '\n관심 주제: ${topicInterests.join(', ')}';
    }
    
    return {
      'adjustedPrompt': adjustedPrompt,
      'preferences': {
        'length': preferredLength,
        'tone': preferredTone,
        'style': preferredStyle,
        'topics': topicInterests,
        'timePreference': timePreference,
      },
      'confidence': profile.getConfidenceScore(),
    };
  }

  /// 메시지 패턴 분석
  Map<String, dynamic> _analyzeMessagePattern(String message) {
    return {
      'length': message.length,
      'hasQuestion': message.contains('?'),
      'hasEmoji': RegExp(r'[ㅋㅎㅠㅜ~♥♡💕😊😭]').hasMatch(message),
      'wordCount': message.split(' ').length,
      'exclamation': message.contains('!'),
      'formal': _isFormalStyle(message),
    };
  }

  /// 응답 패턴 분석
  Map<String, dynamic> _analyzeResponsePattern(String response) {
    return {
      'length': response.length,
      'emojiCount': RegExp(r'[ㅋㅎㅠㅜ~♥♡💕😊😭]').allMatches(response).length,
      'questionCount': '?'.allMatches(response).length,
      'wordCount': response.split(' ').length,
      'hasEmpathy': _hasEmpathyExpression(response),
      'hasSuggestion': _hasSuggestion(response),
    };
  }

  /// 시간 패턴 분석
  Map<String, dynamic> _analyzeTimePattern() {
    final now = DateTime.now();
    return {
      'hour': now.hour,
      'dayOfWeek': now.weekday,
      'isWeekend': now.weekday >= 6,
      'timeOfDay': _getTimeOfDay(now.hour),
    };
  }

  /// 감정 패턴 분석
  Map<String, dynamic> _analyzeEmotionPattern(String message) {
    return {
      'positive': _hasPositiveEmotion(message),
      'negative': _hasNegativeEmotion(message),
      'neutral': !_hasPositiveEmotion(message) && !_hasNegativeEmotion(message),
      'excited': message.contains('!!') || message.contains('ㅋㅋ'),
      'sad': message.contains('ㅠㅠ') || message.contains('ㅜㅜ'),
    };
  }

  /// 예측 모델 업데이트
  Future<void> _updatePredictionModel(UserPreferenceProfile profile) async {
    // 패턴 분석 및 모델 업데이트
    profile.updatePredictionModel();
    
    // Firestore에 학습 데이터 저장 (선택적)
    if (profile.shouldSaveToCloud()) {
      try {
        await FirebaseFirestore.instance
            .collection('user_preferences')
            .doc(profile.userId)
            .set(profile.toJson(), SetOptions(merge: true));
      } catch (e) {
        debugPrint('Failed to save learning data: $e');
      }
    }
  }

  // 헬퍼 메서드들
  bool _isFormalStyle(String message) {
    return message.contains('습니다') || 
           message.contains('합니다') || 
           message.contains('요');
  }

  bool _hasEmpathyExpression(String response) {
    final empathyWords = ['이해해', '공감', '그렇구나', '힘들겠', '괜찮아'];
    return empathyWords.any((word) => response.contains(word));
  }

  bool _hasSuggestion(String response) {
    final suggestionWords = ['어때', '해보', '하자', '할까', '어떻게'];
    return suggestionWords.any((word) => response.contains(word));
  }

  String _getTimeOfDay(int hour) {
    if (hour >= 5 && hour < 12) return 'morning';
    if (hour >= 12 && hour < 17) return 'afternoon';
    if (hour >= 17 && hour < 21) return 'evening';
    return 'night';
  }

  bool _hasPositiveEmotion(String message) {
    final positiveWords = ['좋', '행복', '기뻐', '재밌', '웃', '신나', '최고'];
    return positiveWords.any((word) => message.contains(word));
  }

  bool _hasNegativeEmotion(String message) {
    final negativeWords = ['싫', '슬프', '우울', '힘들', '지치', '짜증', '화나'];
    return negativeWords.any((word) => message.contains(word));
  }

  /// 학습 데이터 초기화
  void clearUserData(String userId) {
    _userProfiles.remove(userId);
  }

  /// 전체 초기화
  void clearAllData() {
    _userProfiles.clear();
  }
}

/// 사용자 선호 프로필
class UserPreferenceProfile {
  final String userId;
  final LinkedHashMap<String, dynamic> conversationHistory = LinkedHashMap();
  final Map<String, double> responsePreferences = {};
  final Map<String, int> topicFrequency = {};
  final Map<String, double> emotionalPatterns = {};
  final Map<int, double> timePatterns = {};  // hour -> preference score
  
  // 학습 통계
  int totalConversations = 0;
  double averageSatisfaction = 0.0;
  DateTime? lastInteraction;
  
  // 예측 모델 파라미터
  Map<String, double> modelWeights = {
    'lengthPreference': 0.5,  // 0: short, 1: long
    'emotionalTone': 0.5,     // 0: casual, 1: empathetic
    'conversationStyle': 0.5,  // 0: question, 1: statement
    'emojiUsage': 0.5,        // 0: minimal, 1: frequent
  };

  UserPreferenceProfile(this.userId);

  /// 선호도 업데이트
  void updatePreferences({
    required Map<String, dynamic> messagePattern,
    required Map<String, dynamic> responsePattern,
    required double satisfaction,
    required Map<String, dynamic> timePattern,
    required Map<String, dynamic> emotionPattern,
  }) {
    totalConversations++;
    
    // 만족도 가중 평균 업데이트
    averageSatisfaction = 
        (averageSatisfaction * (totalConversations - 1) + satisfaction) / totalConversations;
    
    // 시간 패턴 학습
    final hour = timePattern['hour'] as int;
    timePatterns[hour] = (timePatterns[hour] ?? 0.5) * 0.9 + satisfaction * 0.1;
    
    // 감정 패턴 학습
    emotionPattern.forEach((key, value) {
      if (value == true) {
        emotionalPatterns[key] = (emotionalPatterns[key] ?? 0.0) + 1;
      }
    });
    
    // 모델 가중치 업데이트 (gradient descent)
    _updateModelWeights(messagePattern, responsePattern, satisfaction);
    
    lastInteraction = DateTime.now();
  }

  /// 컨텍스트 학습
  void learnContext(Map<String, dynamic> context) {
    context.forEach((key, value) {
      if (value is String) {
        topicFrequency[value] = (topicFrequency[value] ?? 0) + 1;
      }
    });
  }

  /// 대화 히스토리 추가
  void addToHistory({
    required String userMessage,
    required String aiResponse,
    required double satisfaction,
  }) {
    final entry = {
      'timestamp': DateTime.now().toIso8601String(),
      'userMessage': userMessage,
      'aiResponse': aiResponse,
      'satisfaction': satisfaction,
    };
    
    conversationHistory[DateTime.now().toIso8601String()] = entry;
    
    // 크기 제한
    if (conversationHistory.length > 100) {
      conversationHistory.remove(conversationHistory.keys.first);
    }
  }

  /// 모델 가중치 업데이트
  void _updateModelWeights(
    Map<String, dynamic> messagePattern,
    Map<String, dynamic> responsePattern,
    double satisfaction,
  ) {
    const learningRate = 0.05;
    
    // 길이 선호도 학습
    if (responsePattern['length'] != null) {
      final normalizedLength = min(1.0, (responsePattern['length'] as num).toDouble() / 200.0);
      final error = satisfaction - 0.5;
      modelWeights['lengthPreference'] = modelWeights['lengthPreference']! + 
          learningRate * error * normalizedLength;
    }
    
    // 이모지 사용 선호도 학습
    if (responsePattern['emojiCount'] != null) {
      final normalizedEmoji = min(1.0, (responsePattern['emojiCount'] as num).toDouble() / 5.0);
      final error = satisfaction - 0.5;
      modelWeights['emojiUsage'] = modelWeights['emojiUsage']! + 
          learningRate * error * normalizedEmoji;
    }
    
    // 가중치 정규화 (0.0 ~ 1.0)
    modelWeights.forEach((key, value) {
      modelWeights[key] = max(0.0, min(1.0, value));
    });
  }

  /// 예측 모델 업데이트
  void updatePredictionModel() {
    // 복잡한 패턴 분석 및 예측 모델 업데이트
    // 실제로는 더 정교한 ML 알고리즘 사용 가능
  }

  /// 충분한 데이터 여부
  bool hasEnoughData() {
    return totalConversations >= 5;
  }

  /// 선호 응답 길이
  Map<String, dynamic>? getPreferredResponseLength() {
    if (!hasEnoughData()) return null;
    
    final preference = modelWeights['lengthPreference']!;
    if (preference < 0.3) {
      return {'type': 'short', 'description': '짧고 간결한 응답'};
    } else if (preference > 0.7) {
      return {'type': 'long', 'description': '자세하고 풍부한 응답'};
    } else {
      return {'type': 'medium', 'description': '적당한 길이의 응답'};
    }
  }

  /// 선호 감정 톤
  Map<String, dynamic>? getPreferredEmotionalTone() {
    if (!hasEnoughData()) return null;
    
    final preference = modelWeights['emotionalTone']!;
    if (preference < 0.3) {
      return {'type': 'casual', 'description': '캐주얼하고 가벼운 톤'};
    } else if (preference > 0.7) {
      return {'type': 'empathetic', 'description': '공감적이고 따뜻한 톤'};
    } else {
      return {'type': 'balanced', 'description': '균형잡힌 톤'};
    }
  }

  /// 선호 대화 스타일
  Map<String, dynamic>? getPreferredConversationStyle() {
    if (!hasEnoughData()) return null;
    
    final preference = modelWeights['conversationStyle']!;
    if (preference < 0.3) {
      return {'type': 'questioning', 'description': '질문을 많이 하는 스타일'};
    } else if (preference > 0.7) {
      return {'type': 'sharing', 'description': '경험을 공유하는 스타일'};
    } else {
      return {'type': 'mixed', 'description': '질문과 공유를 섞는 스타일'};
    }
  }

  /// 관심 주제
  List<String> getTopicInterests() {
    if (topicFrequency.isEmpty) return [];
    
    // 상위 5개 주제 반환
    final sorted = topicFrequency.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    return sorted.take(5).map((e) => e.key).toList();
  }

  /// 시간대별 선호도
  Map<String, dynamic>? getTimeBasedPreference() {
    if (timePatterns.isEmpty) return null;
    
    final currentHour = DateTime.now().hour;
    final preference = timePatterns[currentHour] ?? 0.5;
    
    return {
      'hour': currentHour,
      'preference': preference,
      'isActive': preference > 0.6,
    };
  }

  /// 신뢰도 점수
  double getConfidenceScore() {
    if (totalConversations < 5) return 0.0;
    if (totalConversations < 10) return 0.3;
    if (totalConversations < 20) return 0.6;
    if (totalConversations < 50) return 0.8;
    return min(0.95, 0.8 + (totalConversations - 50) * 0.001);
  }

  /// 클라우드 저장 여부
  bool shouldSaveToCloud() {
    // 10회 대화마다 또는 마지막 저장 후 1시간 경과 시
    return totalConversations % 10 == 0;
  }

  /// JSON 변환
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'totalConversations': totalConversations,
      'averageSatisfaction': averageSatisfaction,
      'lastInteraction': lastInteraction?.toIso8601String(),
      'modelWeights': modelWeights,
      'topicFrequency': topicFrequency,
      'emotionalPatterns': emotionalPatterns,
      'timePatterns': timePatterns.map((k, v) => MapEntry(k.toString(), v)),
    };
  }
}