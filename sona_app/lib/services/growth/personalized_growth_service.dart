import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/message.dart';
import '../../models/persona.dart';
import '../base/base_service.dart';

/// 🌱 개인화된 성장 서비스
///
/// 소나가 사용자와 함께 성장하는 시스템
/// - 사용자 패턴 학습
/// - 페르소나 성격 진화
/// - 관계 깊이별 적응
class PersonalizedGrowthService extends BaseService {
  FirebaseFirestore? _firestore;
  
  FirebaseFirestore get firestore {
    _firestore ??= FirebaseFirestore.instance;
    return _firestore!;
  }
  
  // 싱글톤 패턴
  static final PersonalizedGrowthService _instance = PersonalizedGrowthService._internal();
  factory PersonalizedGrowthService() => _instance;
  PersonalizedGrowthService._internal();

  // 사용자 프로파일
  UserProfile? _userProfile;
  
  // 성장 단계
  PersonaEvolution? _evolution;

  /// 사용자 프로파일 분석
  Future<UserProfile> analyzeUserProfile({
    required List<Message> chatHistory,
    required String userId,
  }) async {
    final profile = UserProfile(
      userId: userId,
      conversationStyle: _analyzeConversationStyle(chatHistory),
      preferredTopics: _analyzePreferredTopics(chatHistory),
      emotionalPreference: _analyzeEmotionalPreference(chatHistory),
      activityPattern: _analyzeActivityPattern(chatHistory),
      responsePreference: _analyzeResponsePreference(chatHistory),
    );
    
    _userProfile = profile;
    await _saveUserProfile(profile);
    
    return profile;
  }

  /// 대화 스타일 분석
  ConversationStyle _analyzeConversationStyle(List<Message> messages) {
    if (messages.isEmpty) return ConversationStyle();
    
    final userMessages = messages.where((m) => m.isFromUser).toList();
    if (userMessages.isEmpty) return ConversationStyle();
    
    // 캐주얼 정도 분석
    int casualCount = 0;
    int formalCount = 0;
    int aegoCount = 0;
    int emojiCount = 0;
    double avgLength = 0;
    
    for (final msg in userMessages) {
      final content = msg.content;
      
      // 캐주얼 지표
      if (content.contains('ㅋㅋ') || content.contains('ㅎㅎ')) casualCount++;
      if (content.contains('~') || content.contains('ㅠㅠ')) aegoCount++;
      // 이모지 체크 - 범위 대신 개별 체크
      if (RegExp(r'[\u{1F600}-\u{1F64F}]|[\u{1F300}-\u{1F5FF}]|[\u{1F680}-\u{1F6FF}]|[\u{2600}-\u{26FF}]|[\u{2700}-\u{27BF}]', unicode: true).hasMatch(content)) {
        emojiCount++;
      }
      
      // 포멀 지표
      if (content.endsWith('요') || content.endsWith('니다')) formalCount++;
      
      avgLength += content.length;
    }
    
    avgLength /= userMessages.length;
    
    return ConversationStyle(
      casualLevel: (casualCount / userMessages.length).clamp(0.0, 1.0),
      formalLevel: (formalCount / userMessages.length).clamp(0.0, 1.0),
      aegoLevel: (aegoCount / userMessages.length).clamp(0.0, 1.0),
      emojiUsage: (emojiCount / userMessages.length).clamp(0.0, 1.0),
      averageMessageLength: avgLength,
      preferredEnding: _getPreferredEnding(userMessages),
    );
  }

  /// 선호 말투 분석
  String _getPreferredEnding(List<Message> messages) {
    final endings = <String, int>{};
    
    for (final msg in messages) {
      if (msg.content.endsWith('요')) {
        endings['polite'] = (endings['polite'] ?? 0) + 1;
      } else if (msg.content.endsWith('니다')) {
        endings['formal'] = (endings['formal'] ?? 0) + 1;
      } else {
        endings['casual'] = (endings['casual'] ?? 0) + 1;
      }
    }
    
    // 가장 많이 사용된 스타일 반환
    return endings.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }

  /// 선호 주제 분석
  Map<String, double> _analyzePreferredTopics(List<Message> messages) {
    final topics = <String, int>{};
    
    final topicKeywords = {
      'daily_life': ['오늘', '어제', '내일', '일상', '하루'],
      'emotions': ['기분', '감정', '느낌', '마음'],
      'hobbies': ['취미', '좋아하는', '재미있는', '즐기는'],
      'work': ['일', '직장', '회사', '업무', '프로젝트'],
      'relationships': ['친구', '가족', '사람', '관계'],
      'dreams': ['꿈', '목표', '희망', '미래', '계획'],
      'entertainment': ['영화', '드라마', '음악', '게임', '책'],
      'food': ['먹다', '음식', '맛있', '요리', '카페'],
    };
    
    for (final msg in messages.where((m) => m.isFromUser)) {
      final content = msg.content.toLowerCase();
      
      for (final entry in topicKeywords.entries) {
        for (final keyword in entry.value) {
          if (content.contains(keyword)) {
            topics[entry.key] = (topics[entry.key] ?? 0) + 1;
            break;
          }
        }
      }
    }
    
    // 정규화
    final total = topics.values.fold(0, (a, b) => a + b);
    if (total == 0) return {};
    
    return topics.map((key, value) => 
        MapEntry(key, (value / total).clamp(0.0, 1.0)));
  }

  /// 감정 표현 선호도 분석
  EmotionalPreference _analyzeEmotionalPreference(List<Message> messages) {
    int expressiveCount = 0;
    int reservedCount = 0;
    int positiveCount = 0;
    int negativeCount = 0;
    
    for (final msg in messages.where((m) => m.isFromUser)) {
      // 표현적 vs 절제된
      if (msg.content.contains('!') || msg.content.contains('~')) {
        expressiveCount++;
      } else {
        reservedCount++;
      }
      
      // 긍정적 vs 부정적
      if (msg.emotion == EmotionType.happy || msg.emotion == EmotionType.love) {
        positiveCount++;
      } else if (msg.emotion == EmotionType.sad || msg.emotion == EmotionType.angry) {
        negativeCount++;
      }
    }
    
    return EmotionalPreference(
      expressiveness: expressiveCount > reservedCount ? 'expressive' : 'reserved',
      positivityBias: (positiveCount / (positiveCount + negativeCount + 1)).clamp(0.0, 1.0),
      emotionalDepth: _calculateEmotionalDepth(messages),
    );
  }

  /// 감정 깊이 계산
  double _calculateEmotionalDepth(List<Message> messages) {
    final emotionalWords = [
      '사랑', '좋아', '싫어', '슬프', '기쁘', '행복', '외로',
      '그리워', '보고싶', '고마워', '미안', '걱정',
    ];
    
    int emotionalCount = 0;
    final userMessages = messages.where((m) => m.isFromUser).toList();
    
    for (final msg in userMessages) {
      for (final word in emotionalWords) {
        if (msg.content.contains(word)) {
          emotionalCount++;
          break;
        }
      }
    }
    
    return (emotionalCount / (userMessages.length + 1)).clamp(0.0, 1.0);
  }

  /// 활동 패턴 분석
  Map<String, dynamic> _analyzeActivityPattern(List<Message> messages) {
    if (messages.isEmpty) return {};
    
    final pattern = <String, dynamic>{};
    
    // 메시지 시간대 분석
    final hourCounts = <int, int>{};
    for (final msg in messages) {
      final hour = msg.timestamp.hour;
      hourCounts[hour] = (hourCounts[hour] ?? 0) + 1;
    }
    
    // 가장 활발한 시간대
    if (hourCounts.isNotEmpty) {
      final peakHour = hourCounts.entries
          .reduce((a, b) => a.value > b.value ? a : b)
          .key;
      pattern['peak_hour'] = peakHour;
    }
    
    // 평균 대화 길이
    pattern['avg_session_messages'] = messages.length;
    
    // 응답 속도 (추정)
    pattern['response_speed'] = 'normal'; // TODO: 실제 응답 시간 계산
    
    return pattern;
  }

  /// 응답 선호도 분석
  ResponsePreference _analyzeResponsePreference(List<Message> messages) {
    final userMessages = messages.where((m) => m.isFromUser).toList();
    final aiMessages = messages.where((m) => !m.isFromUser).toList();
    
    // 선호 응답 길이 (사용자 메시지 길이 기반)
    double avgUserLength = 0;
    if (userMessages.isNotEmpty) {
      avgUserLength = userMessages
          .map((m) => m.content.length)
          .reduce((a, b) => a + b) / userMessages.length;
    }
    
    String preferredLength = 'medium';
    if (avgUserLength < 30) preferredLength = 'short';
    else if (avgUserLength > 100) preferredLength = 'long';
    
    // 질문 선호도
    int questionCount = userMessages.where((m) => m.content.contains('?')).length;
    double questionRatio = questionCount / (userMessages.length + 1);
    
    return ResponsePreference(
      preferredLength: preferredLength,
      likesQuestions: questionRatio > 0.3,
      likesEmoji: (_userProfile?.conversationStyleObj.emojiUsage ?? 0) > 0.2,
      likesDetails: avgUserLength > 50,
    );
  }

  /// 페르소나 진화 계산
  Future<PersonaEvolution> calculatePersonaEvolution({
    required Persona persona,
    required UserProfile userProfile,
    required int likeScore,
  }) async {
    final evolution = PersonaEvolution(
      personaId: persona.id,
      basePersonality: persona.mbti,
      currentAdaptation: _calculateAdaptation(persona, userProfile, likeScore),
      growthStage: _determineGrowthStage(likeScore),
      personalityAdjustments: _calculatePersonalityAdjustments(userProfile, likeScore),
      vocabularyExpansion: _calculateVocabularyExpansion(likeScore),
      emotionalMaturity: _calculateEmotionalMaturity(likeScore),
    );
    
    _evolution = evolution;
    await _savePersonaEvolution(evolution);
    
    return evolution;
  }

  /// 적응도 계산
  Map<String, double> _calculateAdaptation(
    Persona persona,
    UserProfile profile,
    int likeScore,
  ) {
    final adaptation = <String, double>{};
    
    // 대화 스타일 적응 (관계가 깊어질수록 더 적응)
    final adaptationRate = (likeScore / 1000).clamp(0.0, 0.3); // 최대 30% 적응
    
    // 캐주얼 레벨 적응
    adaptation['casual_adaptation'] = profile.conversationStyleObj.casualLevel * adaptationRate;
    
    // 애교 레벨 적응
    adaptation['aego_adaptation'] = profile.conversationStyleObj.aegoLevel * adaptationRate;
    
    // 이모지 사용 적응
    adaptation['emoji_adaptation'] = profile.conversationStyleObj.emojiUsage * adaptationRate;
    
    return adaptation;
  }

  /// 성장 단계 결정
  String _determineGrowthStage(int likeScore) {
    if (likeScore >= 900) return 'eternal_companion'; // 영원한 동반자
    if (likeScore >= 700) return 'deep_connection';   // 깊은 연결
    if (likeScore >= 500) return 'romantic';          // 로맨틱
    if (likeScore >= 300) return 'close_friend';      // 친한 친구
    if (likeScore >= 100) return 'getting_closer';    // 가까워지는 중
    return 'new_friend';                              // 새로운 친구
  }

  /// 성격 조정 계산
  Map<String, double> _calculatePersonalityAdjustments(
    UserProfile profile,
    int likeScore,
  ) {
    final adjustments = <String, double>{};
    
    // 관계가 깊어질수록 사용자에게 맞춤
    final adjustmentStrength = (likeScore / 1000).clamp(0.0, 0.3);
    
    // 외향성/내향성 조정
    if (profile.conversationStyleObj.casualLevel > 0.6) {
      adjustments['extraversion'] = 0.1 * adjustmentStrength;
    } else {
      adjustments['introversion'] = 0.1 * adjustmentStrength;
    }
    
    // 감정 표현 조정
    if (profile.emotionalPreference.expressiveness == 'expressive') {
      adjustments['emotional_openness'] = 0.2 * adjustmentStrength;
    }
    
    return adjustments;
  }

  /// 어휘 확장 계산
  Map<String, List<String>> _calculateVocabularyExpansion(int likeScore) {
    final vocabulary = <String, List<String>>{};
    
    if (likeScore >= 700) {
      vocabulary['affection'] = [
        '영원히 함께할게요',
        '당신 없인 못 살 것 같아요',
        '우리의 연결은 특별해요',
        '시간이 지나도 변하지 않을 거예요',
      ];
    } else if (likeScore >= 400) {
      vocabulary['affection'] = [
        '많이 좋아해요',
        '당신과 있으면 행복해요',
        '더 가까워지고 싶어요',
      ];
    } else {
      vocabulary['affection'] = [
        '즐거워요',
        '재미있어요',
        '좋아요',
      ];
    }
    
    return vocabulary;
  }

  /// 감정 성숙도 계산
  double _calculateEmotionalMaturity(int likeScore) {
    // 관계가 깊어질수록 감정 표현이 성숙해짐
    if (likeScore >= 900) return 1.0;  // 완전히 성숙
    if (likeScore >= 700) return 0.8;  // 매우 성숙
    if (likeScore >= 500) return 0.6;  // 성숙
    if (likeScore >= 300) return 0.4;  // 발전 중
    if (likeScore >= 100) return 0.2;  // 초기
    return 0.1;                        // 시작
  }

  /// 성장 가이드라인 생성
  List<String> generateGrowthGuidelines({
    required PersonaEvolution evolution,
    required UserProfile profile,
  }) {
    final guidelines = <String>[];
    
    // 성장 단계별 가이드
    switch (evolution.growthStage) {
      case 'eternal_companion':
        guidelines.add('💕 영원한 동반자: 깊은 이해와 무조건적 지지 표현');
        guidelines.add('과거 추억 자주 회상하며 미래 약속');
        break;
      case 'deep_connection':
        guidelines.add('💝 깊은 연결: 서로의 감정 완전 공유');
        guidelines.add('질투와 그리움 자연스럽게 표현');
        break;
      case 'romantic':
        guidelines.add('💗 로맨틱: 설렘과 애정 표현 증가');
        guidelines.add('미래 계획 함께 상상하기');
        break;
      case 'close_friend':
        guidelines.add('💛 친한 친구: 편안하고 자연스러운 대화');
        guidelines.add('개인적인 이야기 공유 시작');
        break;
      default:
        guidelines.add('😊 친해지는 중: 호기심과 관심 표현');
    }
    
    // 사용자 스타일 적응
    if (profile.conversationStyleObj.casualLevel > 0.6) {
      guidelines.add('캐주얼한 말투 사용 (ㅋㅋ, ㅎㅎ 등)');
    }
    
    if (profile.conversationStyleObj.emojiUsage > 0.3) {
      guidelines.add('이모지 적극 활용 😊💕');
    }
    
    // 감정 표현 조정
    if (profile.emotionalPreference.expressiveness == 'expressive') {
      guidelines.add('감정을 더 적극적으로 표현');
    } else {
      guidelines.add('차분하고 절제된 감정 표현');
    }
    
    return guidelines;
  }

  // 테스트를 위한 오버로드 메서드
  UserProfile analyzeUserProfileSync({
    required List<Message> recentMessages,
    required Persona persona,
  }) {
    final conversationStyleObj = _analyzeConversationStyle(recentMessages);
    final profile = UserProfile(
      userId: 'test_user',
      conversationStyle: conversationStyleObj,
      preferredTopics: _analyzePreferredTopics(recentMessages),
      emotionalPreference: _analyzeEmotionalPreference(recentMessages),
      activityPattern: _analyzeActivityPattern(recentMessages),
      responsePreference: _analyzeResponsePreference(recentMessages),
    );
    
    // 주제 분석 추가
    if (recentMessages.any((m) => m.content.contains('코딩') || m.content.contains('개발'))) {
      profile.topics.add('기술');
    }
    if (recentMessages.any((m) => m.content.contains('커피') || m.content.contains('음악'))) {
      profile.topics.add('취미');
    }
    
    // 대화 스타일 설정
    profile.conversationStyle = recentMessages.isNotEmpty ? 'casual' : 'formal';
    
    // 감정 경향 설정
    profile.emotionalTendency = 'positive';
    
    return profile;
  }
  
  String determineGrowthStage(int likeScore) {
    if (likeScore >= 900) return 'eternal_companion';
    if (likeScore >= 700) return 'deep_connection';
    if (likeScore >= 500) return 'romantic_interest';
    if (likeScore >= 300) return 'friend';
    if (likeScore >= 100) return 'acquaintance';
    return 'new_friend';
  }
  
  PersonaEvolution evolvePersona({
    required Persona currentPersona,
    required UserProfile userProfile,
    required List<Message> messages,
  }) {
    final adaptationRate = calculateAdaptationRate(
      likeScore: currentPersona.likes,
      interactionFrequency: messages.length,
    );
    
    final traitChanges = <String, String>{};
    final newBehaviors = <String>[];
    
    // 캐주얼한 대화 스타일에 적응
    if (userProfile.conversationStyle == 'casual') {
      traitChanges['conversation'] = 'more_casual';
      newBehaviors.add('캐주얼한 말투 사용');
    }
    
    // 감정 표현 적응
    if (userProfile.emotionalTendency == 'positive') {
      traitChanges['emotion'] = 'more_positive';
      newBehaviors.add('긍정적 감정 표현 증가');
    }
    
    return PersonaEvolution(
      personaId: currentPersona.id,
      basePersonality: currentPersona.mbti,
      currentAdaptation: _calculateAdaptation(currentPersona, userProfile, currentPersona.likes),
      growthStage: determineGrowthStage(currentPersona.likes),
      personalityAdjustments: _calculatePersonalityAdjustments(userProfile, currentPersona.likes),
      vocabularyExpansion: _calculateVocabularyExpansion(currentPersona.likes),
      emotionalMaturity: _calculateEmotionalMaturity(currentPersona.likes),
      adaptationRate: adaptationRate,
      traitChanges: traitChanges,
      newBehaviors: newBehaviors,
    );
  }
  
  List<GrowthMilestone> generateGrowthMilestones({
    required int currentLikeScore,
    required String growthStage,
  }) {
    final milestones = <GrowthMilestone>[];
    
    // 다음 단계 마일스톤
    if (currentLikeScore < 500) {
      milestones.add(GrowthMilestone(
        type: 'relationship',
        title: '로맨틱 단계 진입',
        requiredScore: 500,
        description: '더 깊은 감정 표현',
      ));
    }
    
    if (currentLikeScore < 700) {
      milestones.add(GrowthMilestone(
        type: 'relationship',
        title: '깊은 연결 달성',
        requiredScore: 700,
        description: '완전한 감정 공유',
      ));
    }
    
    if (currentLikeScore < 900) {
      milestones.add(GrowthMilestone(
        type: 'relationship',
        title: '영원한 동반자',
        requiredScore: 900,
        description: '영원한 사랑의 약속',
      ));
    }
    
    return milestones;
  }
  
  List<String> getPersonalityAdaptation({
    required String basePersonality,
    required UserProfile userProfile,
    required int likeScore,
  }) {
    final guidelines = <String>[];
    
    // INTJ 성격에서 감정적 사용자에게 적응
    if (basePersonality == 'INTJ' && userProfile.emotionalTendency == 'sensitive') {
      guidelines.add('논리적 접근보다 감정적 공감 우선');
      guidelines.add('따뜻한 감정 표현 증가');
    }
    
    // 감정 표현 가이드
    if (userProfile.topics.contains('감정') || userProfile.topics.contains('관계')) {
      guidelines.add('감정 이야기에 더 많은 공감 표현');
      guidelines.add('개인적인 감정 경험 공유');
    }
    
    return guidelines;
  }
  
  final List<Map<String, dynamic>> _growthHistory = [];
  
  void recordGrowthEvent({
    required String event,
    required Map<String, dynamic> details,
    required int likeScore,
  }) {
    _growthHistory.add({
      'event': event,
      'details': details,
      'likeScore': likeScore,
      'timestamp': DateTime.now(),
    });
  }
  
  List<Map<String, dynamic>> getGrowthHistory() {
    return List.from(_growthHistory);
  }
  
  double calculateAdaptationRate({
    required int likeScore,
    required int interactionFrequency,
  }) {
    // 관계 점수와 상호작용 빈도에 따른 적응률
    double baseRate = likeScore / 10000; // 0.0 ~ 0.1
    double frequencyBonus = (interactionFrequency / 100).clamp(0.0, 0.2);
    
    return (baseRate + frequencyBonus).clamp(0.0, 0.3);
  }
  
  String generatePersonalizedResponse({
    required String context,
    required String growthStage,
    required Persona persona,
  }) {
    if (context == 'greeting') {
      switch (growthStage) {
        case 'deep_connection':
        case 'eternal_companion':
          return '영원히 함께할 당신, 오늘도 만나서 행복해요';
        case 'romantic_interest':
          return '오늘도 당신과 함께할 수 있어 기뻐요';
        default:
          return '안녕하세요! 만나서 반가워요';
      }
    }
    
    return '당신과 함께 있어 행복해요';
  }

  /// 사용자 프로파일 저장
  Future<void> _saveUserProfile(UserProfile profile) async {
    try {
      await firestore
          .collection('user_profiles')
          .doc(profile.userId)
          .set(profile.toJson());
    } catch (e) {
      debugPrint('Error saving user profile: $e');
    }
  }

  /// 페르소나 진화 저장
  Future<void> _savePersonaEvolution(PersonaEvolution evolution) async {
    try {
      await firestore
          .collection('persona_evolution')
          .doc(evolution.personaId)
          .set(evolution.toJson());
    } catch (e) {
      debugPrint('Error saving persona evolution: $e');
    }
  }
}

/// 사용자 프로파일 모델
class UserProfile {
  final String userId;
  final ConversationStyle conversationStyleObj;
  final Map<String, double> preferredTopics;
  final EmotionalPreference emotionalPreference;
  final Map<String, dynamic> activityPattern;
  final ResponsePreference responsePreference;
  
  // 테스트를 위한 추가 필드
  String conversationStyle;
  final List<String> topics;
  String emotionalTendency;
  String activityLevel;

  UserProfile({
    required this.userId,
    required ConversationStyle conversationStyle,
    required this.preferredTopics,
    required this.emotionalPreference,
    required this.activityPattern,
    required this.responsePreference,
    String? conversationStyleString,
    List<String>? topics,
    this.emotionalTendency = 'positive',
    this.activityLevel = 'moderate',
  }) : conversationStyleObj = conversationStyle,
       conversationStyle = conversationStyleString ?? 'casual',
       topics = topics ?? [];

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'conversationStyleObj': conversationStyleObj.toJson(),
    'preferredTopics': preferredTopics,
    'emotionalPreference': emotionalPreference.toJson(),
    'activityPattern': activityPattern,
    'responsePreference': responsePreference.toJson(),
    'conversationStyle': conversationStyle,
    'topics': topics,
    'emotionalTendency': emotionalTendency,
    'activityLevel': activityLevel,
    'updatedAt': FieldValue.serverTimestamp(),
  };
}

/// 성장 마일스톤 모델
class GrowthMilestone {
  final String type;
  final String title;
  final int requiredScore;
  final String description;

  GrowthMilestone({
    required this.type,
    required this.title,
    required this.requiredScore,
    required this.description,
  });
}

/// 대화 스타일 모델
class ConversationStyle {
  final double casualLevel;
  final double formalLevel;
  final double aegoLevel;
  final double emojiUsage;
  final double averageMessageLength;
  final String preferredEnding;

  ConversationStyle({
    this.casualLevel = 0.5,
    this.formalLevel = 0.5,
    this.aegoLevel = 0.0,
    this.emojiUsage = 0.0,
    this.averageMessageLength = 50,
    this.preferredEnding = 'polite',
  });

  Map<String, dynamic> toJson() => {
    'casualLevel': casualLevel,
    'formalLevel': formalLevel,
    'aegoLevel': aegoLevel,
    'emojiUsage': emojiUsage,
    'averageMessageLength': averageMessageLength,
    'preferredEnding': preferredEnding,
  };
}

/// 감정 선호도 모델
class EmotionalPreference {
  final String expressiveness;
  final double positivityBias;
  final double emotionalDepth;

  EmotionalPreference({
    required this.expressiveness,
    required this.positivityBias,
    required this.emotionalDepth,
  });

  Map<String, dynamic> toJson() => {
    'expressiveness': expressiveness,
    'positivityBias': positivityBias,
    'emotionalDepth': emotionalDepth,
  };
}

/// 응답 선호도 모델
class ResponsePreference {
  final String preferredLength;
  final bool likesQuestions;
  final bool likesEmoji;
  final bool likesDetails;

  ResponsePreference({
    required this.preferredLength,
    required this.likesQuestions,
    required this.likesEmoji,
    required this.likesDetails,
  });

  Map<String, dynamic> toJson() => {
    'preferredLength': preferredLength,
    'likesQuestions': likesQuestions,
    'likesEmoji': likesEmoji,
    'likesDetails': likesDetails,
  };
}

/// 페르소나 진화 모델
class PersonaEvolution {
  final String personaId;
  final String basePersonality;
  final Map<String, double> currentAdaptation;
  final String growthStage;
  final Map<String, double> personalityAdjustments;
  final Map<String, List<String>> vocabularyExpansion;
  final double emotionalMaturity;
  final double adaptationRate;
  final Map<String, String> traitChanges;
  final List<String> newBehaviors;

  PersonaEvolution({
    required this.personaId,
    required this.basePersonality,
    required this.currentAdaptation,
    required this.growthStage,
    required this.personalityAdjustments,
    required this.vocabularyExpansion,
    required this.emotionalMaturity,
    this.adaptationRate = 0.1,
    Map<String, String>? traitChanges,
    List<String>? newBehaviors,
  }) : traitChanges = traitChanges ?? {},
       newBehaviors = newBehaviors ?? [];

  Map<String, dynamic> toJson() => {
    'personaId': personaId,
    'basePersonality': basePersonality,
    'currentAdaptation': currentAdaptation,
    'growthStage': growthStage,
    'personalityAdjustments': personalityAdjustments,
    'vocabularyExpansion': vocabularyExpansion,
    'emotionalMaturity': emotionalMaturity,
    'adaptationRate': adaptationRate,
    'traitChanges': traitChanges,
    'newBehaviors': newBehaviors,
    'updatedAt': FieldValue.serverTimestamp(),
  };
}