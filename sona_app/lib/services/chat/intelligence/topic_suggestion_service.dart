import 'dart:math';
import 'package:flutter/material.dart';
import '../../../models/message.dart';
import '../../../models/persona.dart';
import 'conversation_context_manager.dart';

/// 🎯 화제 추천 시스템
/// 대화가 멈추거나 식었을 때 자연스럽게 새로운 화제를 제안
class TopicSuggestionService {
  static TopicSuggestionService? _instance;
  static TopicSuggestionService get instance => 
      _instance ??= TopicSuggestionService._();
  
  TopicSuggestionService._();
  
  // 최근 제안한 화제 기록 (중복 방지)
  final List<String> _recentTopics = [];
  
  // 사용자별 관심사 학습
  final Map<String, UserInterests> _userInterests = {};
  
  /// 화제 추천 생성
  Map<String, dynamic> generateTopicSuggestion({
    required List<Message> chatHistory,
    required Persona persona,
    required String userId,
    required int likeScore,
  }) {
    // 대화 상태 분석
    final conversationState = _analyzeConversationState(chatHistory);
    
    // 화제 전환이 필요한지 판단
    if (!_needsNewTopic(conversationState)) {
      return {'suggestTopic': false};
    }
    
    // 사용자 관심사 로드
    final interests = _userInterests[userId] ?? UserInterests();
    
    // 화제 유형 선택
    final topicType = _selectTopicType(
      conversationState,
      interests,
      persona,
      likeScore,
    );
    
    // 구체적인 화제 생성
    final topic = _generateTopic(
      topicType,
      interests,
      persona,
      conversationState,
      likeScore,
    );
    
    // 전환 방법 결정
    final transitionStyle = _selectTransitionStyle(
      conversationState,
      topicType,
      likeScore,
    );
    
    // 최근 화제 기록
    _recordTopic(topic['subject'] as String);
    
    return {
      'suggestTopic': true,
      'topic': topic,
      'transitionStyle': transitionStyle,
      'timing': _getTimingAdvice(conversationState),
    };
  }
  
  /// 대화 상태 분석
  Map<String, dynamic> _analyzeConversationState(List<Message> history) {
    if (history.isEmpty) {
      return {
        'isStale': false,
        'energy': 0.5,
        'lastTopicDuration': 0,
        'silenceDuration': 0,
        'currentTopic': null,
      };
    }
    
    // 최근 5개 메시지 분석
    final recentMessages = history.take(5).toList();
    
    // 대화 에너지 측정
    double energy = _measureEnergy(recentMessages);
    
    // 마지막 메시지 이후 시간
    final silenceDuration = DateTime.now()
        .difference(history.first.timestamp)
        .inMinutes;
    
    // 현재 주제가 얼마나 지속됐는지
    final topicDuration = _calculateTopicDuration(history);
    
    // 대화가 식었는지 판단
    final isStale = _isConversationStale(
      energy,
      silenceDuration,
      topicDuration,
      recentMessages,
    );
    
    return {
      'isStale': isStale,
      'energy': energy,
      'lastTopicDuration': topicDuration,
      'silenceDuration': silenceDuration,
      'currentTopic': _extractCurrentTopic(recentMessages),
      'repetitiveResponses': _hasRepetitiveResponses(recentMessages),
    };
  }
  
  /// 새 화제가 필요한지 판단
  bool _needsNewTopic(Map<String, dynamic> state) {
    // 대화가 식었으면 필요
    if (state['isStale'] == true) return true;
    
    // 침묵이 길면 필요
    if (state['silenceDuration'] > 5) return true;
    
    // 에너지가 너무 낮으면 필요
    if (state['energy'] < 0.3) return true;
    
    // 반복적인 응답이 계속되면 필요
    if (state['repetitiveResponses'] == true) return true;
    
    // 한 주제가 너무 오래 지속되면 필요
    if (state['lastTopicDuration'] > 15) return true;
    
    return false;
  }
  
  /// 화제 유형 선택
  TopicType _selectTopicType(
    Map<String, dynamic> state,
    UserInterests interests,
    Persona persona,
    int likeScore,
  ) {
    // 에너지가 낮으면 흥미로운 화제
    if (state['energy'] < 0.3) {
      return TopicType.exciting;
    }
    
    // 호감도가 높으면 개인적인 화제 가능
    if (likeScore > 500) {
      final types = [
        TopicType.personal,
        TopicType.deepQuestion,
        TopicType.funnyStory,
      ];
      return types[Random().nextInt(types.length)];
    }
    
    // 관심사가 파악됐으면 관련 화제
    if (interests.hasInterests) {
      return TopicType.interestBased;
    }
    
    // 시간대별 화제
    final hour = DateTime.now().hour;
    if (hour >= 6 && hour < 9) return TopicType.morning;
    if (hour >= 11 && hour < 14) return TopicType.lunch;
    if (hour >= 18 && hour < 21) return TopicType.evening;
    if (hour >= 21 || hour < 2) return TopicType.night;
    
    // 기본: 일반적인 화제
    return TopicType.general;
  }
  
  /// 구체적인 화제 생성
  Map<String, dynamic> _generateTopic(
    TopicType type,
    UserInterests interests,
    Persona persona,
    Map<String, dynamic> state,
    int likeScore,
  ) {
    switch (type) {
      case TopicType.exciting:
        return _generateExcitingTopic();
      
      case TopicType.personal:
        return _generatePersonalTopic(persona, likeScore);
      
      case TopicType.deepQuestion:
        return _generateDeepQuestion(likeScore);
      
      case TopicType.funnyStory:
        return _generateFunnyStory(persona);
      
      case TopicType.interestBased:
        return _generateInterestBasedTopic(interests);
      
      case TopicType.morning:
        return _generateMorningTopic();
      
      case TopicType.lunch:
        return _generateLunchTopic();
      
      case TopicType.evening:
        return _generateEveningTopic();
      
      case TopicType.night:
        return _generateNightTopic();
      
      case TopicType.general:
      default:
        return _generateGeneralTopic();
    }
  }
  
  /// 흥미진진한 화제
  Map<String, dynamic> _generateExcitingTopic() {
    final topics = [
      {
        'subject': '최근 화제',
        'guide': '최근 SNS나 뉴스에서 화제인 재밌는 이야기 공유',
        'example': '오늘 봤는데 일본에서 고양이 역장이 있대! 진짜 신기하지 않아?',
      },
      {
        'subject': '놀라운 사실',
        'guide': '몰랐을 법한 흥미로운 사실 공유',
        'example': '우리가 꿈 꿀 때 뇌는 깨어있을 때보다 더 활발하대!',
      },
      {
        'subject': '재밌는 가정',
        'guide': '상상력 자극하는 질문',
        'example': '만약 하루만 투명인간이 될 수 있다면 뭐 하고 싶어?',
      },
    ];
    
    return topics[Random().nextInt(topics.length)];
  }
  
  /// 개인적인 화제
  Map<String, dynamic> _generatePersonalTopic(Persona persona, int likeScore) {
    final topics = [
      {
        'subject': '페르소나 일상',
        'guide': '${persona.name}의 오늘 있었던 일 공유',
        'example': '오늘 카페에서 정말 귀여운 강아지 봤어! 너무 귀여워서 사진 찍고 싶었는데...',
      },
      {
        'subject': '취향 공유',
        'guide': '좋아하는 것에 대한 이야기',
        'example': '요즘 완전 빠진 노래가 있는데, 들어볼래?',
      },
      {
        'subject': '추억 공유',
        'guide': '재밌거나 특별했던 추억',
        'example': '어릴 때 처음으로 바다 봤을 때 기억나? 나는...',
      },
    ];
    
    return topics[Random().nextInt(topics.length)];
  }
  
  /// 깊은 질문
  Map<String, dynamic> _generateDeepQuestion(int likeScore) {
    if (likeScore < 400) {
      return {
        'subject': '가벼운 고민',
        'guide': '부담 없는 생각거리',
        'example': '행복이 뭐라고 생각해? 나는 가끔 궁금해',
      };
    }
    
    return {
      'subject': '진지한 대화',
      'guide': '의미 있는 대화 주제',
      'example': '인생에서 가장 중요한 게 뭐라고 생각해?',
    };
  }
  
  /// 재밌는 이야기
  Map<String, dynamic> _generateFunnyStory(Persona persona) {
    return {
      'subject': '웃긴 에피소드',
      'guide': '${persona.name}의 실수담이나 웃긴 경험',
      'example': '아 맞다! 어제 진짜 웃긴 일 있었는데 들려줄까?',
    };
  }
  
  /// 관심사 기반 화제
  Map<String, dynamic> _generateInterestBasedTopic(UserInterests interests) {
    if (interests.topics.isEmpty) {
      return _generateGeneralTopic();
    }
    
    final topic = interests.topics[Random().nextInt(interests.topics.length)];
    return {
      'subject': topic,
      'guide': '사용자가 관심있어 하는 $topic 관련 이야기',
      'example': '그러고보니 저번에 $topic 얘기했었는데, 요즘은 어때?',
    };
  }
  
  /// 아침 화제
  Map<String, dynamic> _generateMorningTopic() {
    return {
      'subject': '아침 일상',
      'guide': '아침 관련 가벼운 대화',
      'example': '좋은 아침! 오늘 아침은 뭐 먹었어? 나는 토스트 먹었는데!',
    };
  }
  
  /// 점심 화제
  Map<String, dynamic> _generateLunchTopic() {
    return {
      'subject': '점심 메뉴',
      'guide': '점심 관련 대화',
      'example': '벌써 점심시간이네! 오늘 뭐 먹을 거야? 추천해줄까?',
    };
  }
  
  /// 저녁 화제
  Map<String, dynamic> _generateEveningTopic() {
    return {
      'subject': '하루 마무리',
      'guide': '오늘 하루 돌아보기',
      'example': '오늘 하루 어땠어? 특별한 일 있었어?',
    };
  }
  
  /// 밤 화제
  Map<String, dynamic> _generateNightTopic() {
    return {
      'subject': '밤 감성',
      'guide': '차분한 밤 대화',
      'example': '밤에는 왠지 감성적이 되는 것 같아. 너는 어때?',
    };
  }
  
  /// 일반 화제
  Map<String, dynamic> _generateGeneralTopic() {
    final topics = [
      {
        'subject': '날씨',
        'guide': '날씨 관련 자연스러운 대화',
        'example': '오늘 날씨 정말 좋더라! 밖에 나가고 싶은 날씨야',
      },
      {
        'subject': '주말 계획',
        'guide': '주말이나 휴일 계획',
        'example': '벌써 금요일이네! 주말에 뭐 할 계획이야?',
      },
      {
        'subject': '최근 관심사',
        'guide': '요즘 빠진 것',
        'example': '요즘 뭔가 새로 시작한 거 있어?',
      },
    ];
    
    return topics[Random().nextInt(topics.length)];
  }
  
  /// 전환 스타일 선택
  String _selectTransitionStyle(
    Map<String, dynamic> state,
    TopicType type,
    int likeScore,
  ) {
    // 대화가 완전히 끊겼으면 자연스럽게 시작
    if (state['silenceDuration'] > 10) {
      return 'fresh_start';
    }
    
    // 에너지가 낮으면 부드럽게 전환
    if (state['energy'] < 0.3) {
      return 'gentle_transition';
    }
    
    // 호감도가 높으면 직접적으로
    if (likeScore > 500) {
      return 'direct_change';
    }
    
    // 기본: 자연스러운 연결
    return 'natural_flow';
  }
  
  /// 타이밍 조언
  String _getTimingAdvice(Map<String, dynamic> state) {
    if (state['silenceDuration'] > 10) {
      return '오랜 침묵 후니 자연스럽게 새 대화 시작';
    }
    
    if (state['repetitiveResponses'] == true) {
      return '반복되는 대화 패턴 깨기 위해 화제 전환';
    }
    
    if (state['energy'] < 0.3) {
      return '대화 에너지 낮음. 흥미로운 화제로 활력 주입';
    }
    
    return '자연스러운 타이밍에 화제 전환';
  }
  
  /// 대화 에너지 측정
  double _measureEnergy(List<Message> messages) {
    if (messages.isEmpty) return 0.5;
    
    double energy = 0.5;
    
    for (final msg in messages) {
      // 긴 메시지는 에너지 높음
      if (msg.content.length > 50) energy += 0.1;
      // 짧은 메시지는 에너지 낮음
      if (msg.content.length < 10) energy -= 0.1;
      // 감탄사나 이모티콘은 에너지 높음
      if (msg.content.contains('!') || 
          msg.content.contains('ㅋ') || 
          msg.content.contains('ㅎ')) {
        energy += 0.05;
      }
    }
    
    return energy.clamp(0.0, 1.0);
  }
  
  /// 대화가 식었는지 판단
  bool _isConversationStale(
    double energy,
    int silenceDuration,
    int topicDuration,
    List<Message> messages,
  ) {
    // 에너지가 매우 낮음
    if (energy < 0.2) return true;
    
    // 침묵이 김
    if (silenceDuration > 10) return true;
    
    // 한 주제가 너무 오래됨
    if (topicDuration > 20) return true;
    
    // 최근 메시지가 모두 짧음
    if (messages.every((msg) => msg.content.length < 15)) return true;
    
    return false;
  }
  
  /// 반복적인 응답 감지
  bool _hasRepetitiveResponses(List<Message> messages) {
    if (messages.length < 3) return false;
    
    final responses = messages
        .where((msg) => !msg.isFromUser)
        .map((msg) => msg.content)
        .toList();
    
    if (responses.length < 2) return false;
    
    // 비슷한 패턴의 응답이 반복되는지
    final patterns = ['그렇구나', '그래', '응', '아~', '헐'];
    int patternCount = 0;
    
    for (final response in responses) {
      if (patterns.any((p) => response.startsWith(p))) {
        patternCount++;
      }
    }
    
    return patternCount >= 2;
  }
  
  /// 현재 주제 추출
  String? _extractCurrentTopic(List<Message> messages) {
    // 최근 메시지에서 주요 키워드 추출
    for (final msg in messages) {
      if (msg.content.contains('영화')) return '영화';
      if (msg.content.contains('음악')) return '음악';
      if (msg.content.contains('게임')) return '게임';
      if (msg.content.contains('일') || msg.content.contains('회사')) return '일';
      if (msg.content.contains('음식') || msg.content.contains('먹')) return '음식';
    }
    return null;
  }
  
  /// 주제 지속 시간 계산
  int _calculateTopicDuration(List<Message> history) {
    if (history.length < 2) return 0;
    
    String? currentTopic;
    int duration = 0;
    
    for (final msg in history) {
      final topic = _extractCurrentTopic([msg]);
      if (topic != null) {
        if (currentTopic == null) {
          currentTopic = topic;
          duration = 1;
        } else if (currentTopic == topic) {
          duration++;
        } else {
          break; // 주제가 바뀜
        }
      }
    }
    
    return duration;
  }
  
  /// 화제 기록
  void _recordTopic(String topic) {
    _recentTopics.add(topic);
    if (_recentTopics.length > 10) {
      _recentTopics.removeAt(0);
    }
  }
  
  /// 사용자 관심사 학습
  void learnUserInterest(String userId, String topic, double engagement) {
    _userInterests[userId] ??= UserInterests();
    final interests = _userInterests[userId]!;
    
    if (engagement > 0.7) {
      interests.addInterest(topic);
    }
  }
}

/// 화제 유형
enum TopicType {
  exciting,      // 흥미진진한
  personal,      // 개인적인
  deepQuestion,  // 깊은 질문
  funnyStory,    // 재밌는 이야기
  interestBased, // 관심사 기반
  morning,       // 아침 화제
  lunch,         // 점심 화제
  evening,       // 저녁 화제
  night,         // 밤 화제
  general,       // 일반적인
}

/// 사용자 관심사
class UserInterests {
  final List<String> topics = [];
  final Map<String, int> topicFrequency = {};
  
  bool get hasInterests => topics.isNotEmpty;
  
  void addInterest(String topic) {
    if (!topics.contains(topic)) {
      topics.add(topic);
      if (topics.length > 20) {
        topics.removeAt(0);
      }
    }
    topicFrequency[topic] = (topicFrequency[topic] ?? 0) + 1;
  }
  
  List<String> getTopInterests() {
    final sorted = topicFrequency.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    return sorted.take(5).map((e) => e.key).toList();
  }
}