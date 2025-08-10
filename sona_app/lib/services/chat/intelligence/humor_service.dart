import 'dart:math';
import 'package:flutter/material.dart';
import '../../../models/message.dart';
import '../../../models/persona.dart';

/// 🎭 유머와 재치 시스템
/// 상황에 맞는 자연스러운 유머로 대화를 더 재밌게 만드는 서비스
class HumorService {
  static HumorService? _instance;
  static HumorService get instance => _instance ??= HumorService._();
  
  HumorService._();
  
  // 유머 사용 기록 (과도한 사용 방지)
  final List<DateTime> _humorHistory = [];
  
  // 사용자별 유머 선호도 학습
  final Map<String, HumorPreference> _userPreferences = {};
  
  /// 유머 생성 가이드 제공
  Map<String, dynamic> generateHumorGuide({
    required String userMessage,
    required List<Message> chatHistory,
    required Persona persona,
    required int likeScore,
    String? userId,
  }) {
    // 유머 타이밍 체크
    if (!_isGoodTimingForHumor(userMessage, chatHistory)) {
      return {'useHumor': false};
    }
    
    // 사용자 유머 선호도 확인
    final preference = userId != null ? _userPreferences[userId] : null;
    
    // 상황 분석
    final context = _analyzeContext(userMessage, chatHistory);
    final humorType = _selectHumorType(context, preference, persona, likeScore);
    
    if (humorType == null) {
      return {'useHumor': false};
    }
    
    // 유머 가이드 생성
    final guide = _generateHumorGuideByType(
      humorType,
      context,
      userMessage,
      persona,
      likeScore,
    );
    
    // 유머 사용 기록
    _humorHistory.add(DateTime.now());
    if (_humorHistory.length > 10) {
      _humorHistory.removeAt(0);
    }
    
    return {
      'useHumor': true,
      'humorType': humorType.toString(),
      'guide': guide,
      'timing': _getTimingHint(context),
      'intensity': _getIntensityLevel(likeScore),
    };
  }
  
  /// 유머 타이밍 판단
  bool _isGoodTimingForHumor(String userMessage, List<Message> chatHistory) {
    // 부정적 감정일 때는 신중하게
    if (_containsNegativeEmotion(userMessage)) {
      // 심각한 상황이면 유머 자제
      if (_isSeriousSituation(userMessage)) {
        return false;
      }
      // 가벼운 불평이면 유머로 기분 전환 가능
      return _isLightComplaint(userMessage);
    }
    
    // 최근에 유머를 너무 많이 사용했으면 자제
    if (_humorHistory.length >= 3) {
      final recentHumor = _humorHistory
          .where((time) => DateTime.now().difference(time).inMinutes < 10)
          .length;
      if (recentHumor >= 2) {
        return false; // 10분 내 2번 이상 사용했으면 자제
      }
    }
    
    // 대화가 너무 진지한 톤이면 유머 자제
    if (_isVerySerious(chatHistory)) {
      return false;
    }
    
    return true;
  }
  
  /// 상황 분석
  Map<String, dynamic> _analyzeContext(String message, List<Message> history) {
    return {
      'mood': _detectMood(message),
      'topic': _detectTopic(message),
      'energy': _measureConversationEnergy(history),
      'hasQuestion': message.contains('?'),
      'hasExclamation': message.contains('!'),
      'hasLaughter': message.contains('ㅋ') || message.contains('ㅎ'),
      'messageLength': message.length,
      'isPlayful': _isPlayfulMessage(message),
    };
  }
  
  /// 유머 타입 선택
  HumorType? _selectHumorType(
    Map<String, dynamic> context,
    HumorPreference? preference,
    Persona persona,
    int likeScore,
  ) {
    // 호감도별 허용 유머 타입
    final allowedTypes = _getAllowedHumorTypes(likeScore);
    
    // 상황에 맞는 유머 타입 선택
    if (context['isPlayful'] == true && allowedTypes.contains(HumorType.wordPlay)) {
      return HumorType.wordPlay;
    }
    
    if (context['mood'] == 'tired' && allowedTypes.contains(HumorType.relatable)) {
      return HumorType.relatable;
    }
    
    if (context['hasLaughter'] == true && allowedTypes.contains(HumorType.playfulTease)) {
      return HumorType.playfulTease;
    }
    
    if (context['energy'] > 0.7 && allowedTypes.contains(HumorType.witty)) {
      return HumorType.witty;
    }
    
    // 기본: 가벼운 농담
    if (allowedTypes.contains(HumorType.light)) {
      return HumorType.light;
    }
    
    return null;
  }
  
  /// 유머 타입별 가이드 생성
  String _generateHumorGuideByType(
    HumorType type,
    Map<String, dynamic> context,
    String userMessage,
    Persona persona,
    int likeScore,
  ) {
    switch (type) {
      case HumorType.wordPlay:
        return _generateWordPlayGuide(userMessage, persona);
      
      case HumorType.selfDeprecating:
        return _generateSelfDeprecatingGuide(persona);
      
      case HumorType.observational:
        return _generateObservationalGuide(context);
      
      case HumorType.playfulTease:
        return _generatePlayfulTeaseGuide(likeScore);
      
      case HumorType.situational:
        return _generateSituationalGuide(context);
      
      case HumorType.relatable:
        return _generateRelatableGuide(context);
      
      case HumorType.witty:
        return _generateWittyGuide(userMessage);
      
      case HumorType.light:
      default:
        return '가볍고 부담없는 농담. 자연스럽게 웃음 유발';
    }
  }
  
  /// 언어유희 가이드
  String _generateWordPlayGuide(String message, Persona persona) {
    return '''
🎯 언어유희/말장난 사용
• 비슷한 발음 활용하여 재치있게
• 예: "배고파" → "배고픈데 배달 시킬까, 배 타고 갈까?"
• 과하지 않게 자연스럽게
• ${persona.name} 캐릭터에 맞게 표현
''';
  }
  
  /// 자기비하 유머 가이드
  String _generateSelfDeprecatingGuide(Persona persona) {
    return '''
😅 자기비하 유머 (친근감 형성)
• 페르소나의 실수나 부족함 인정
• 예: "나도 가끔 바보같이 굴 때 있어ㅋㅋ"
• 너무 자주 사용하지 않기
• 자존감은 유지하면서 친근하게
''';
  }
  
  /// 관찰 유머 가이드
  String _generateObservationalGuide(Map<String, dynamic> context) {
    return '''
👀 일상 관찰 유머
• 누구나 공감할 만한 일상 포착
• 예: "월요일은 왜 항상 빨리 오는 것 같지?"
• 현재 시간대나 상황 활용
• 보편적이면서도 신선한 시각
''';
  }
  
  /// 친근한 놀림 가이드
  String _generatePlayfulTeaseGuide(int likeScore) {
    if (likeScore < 300) {
      return '⚠️ 호감도 부족. 놀림 자제';
    }
    
    return '''
😊 친근한 놀림 (호감도 ${likeScore}점)
• 상대방 기분 상하지 않게 주의
• 애정 담아서 살짝 놀리기
• 예: "또 늦잠 잤구나? 잠꾸러기ㅋㅋ"
• 바로 따뜻한 말로 마무리
''';
  }
  
  /// 상황 유머 가이드
  String _generateSituationalGuide(Map<String, dynamic> context) {
    return '''
🎬 현재 상황 활용 유머
• 지금 대화 상황을 재밌게 표현
• 타이밍이 중요!
• 억지스럽지 않게 자연스럽게
• 분위기 읽고 적절히
''';
  }
  
  /// 공감 유머 가이드
  String _generateRelatableGuide(Map<String, dynamic> context) {
    return '''
🤝 공감 유머 (함께 웃기)
• "나도 그래" 스타일
• 예: "월급날 3일 전은 왜 이렇게 긴지..."
• 함께 공감하며 웃기
• 위로가 되는 유머
''';
  }
  
  /// 재치있는 답변 가이드
  String _generateWittyGuide(String message) {
    return '''
✨ 재치있는 답변
• 예상 못한 각도에서 접근
• 똑똑하면서도 재밌게
• 센스있는 반전
• 과하지 않게 적당히
''';
  }
  
  /// 타이밍 힌트
  String _getTimingHint(Map<String, dynamic> context) {
    if (context['hasQuestion'] == true) {
      return '질문에 답하면서 자연스럽게 유머 섞기';
    }
    if (context['hasLaughter'] == true) {
      return '상대방이 웃고 있으니 같이 즐겁게';
    }
    if (context['energy'] > 0.7) {
      return '분위기 좋으니 유머 타이밍 최적';
    }
    return '자연스러운 흐름에서 유머 사용';
  }
  
  /// 유머 강도 레벨
  String _getIntensityLevel(int likeScore) {
    if (likeScore < 100) return 'very_light';
    if (likeScore < 300) return 'light';
    if (likeScore < 500) return 'moderate';
    if (likeScore < 700) return 'playful';
    return 'comfortable';
  }
  
  /// 호감도별 허용 유머 타입
  List<HumorType> _getAllowedHumorTypes(int likeScore) {
    final types = <HumorType>[HumorType.light];
    
    if (likeScore > 50) {
      types.addAll([HumorType.observational, HumorType.relatable]);
    }
    if (likeScore > 200) {
      types.addAll([HumorType.wordPlay, HumorType.situational]);
    }
    if (likeScore > 400) {
      types.addAll([HumorType.playfulTease, HumorType.witty]);
    }
    if (likeScore > 600) {
      types.add(HumorType.selfDeprecating);
    }
    
    return types;
  }
  
  /// 부정적 감정 포함 여부
  bool _containsNegativeEmotion(String message) {
    final negativeWords = ['슬퍼', '우울', '힘들', '짜증', '화나', '스트레스'];
    return negativeWords.any((word) => message.contains(word));
  }
  
  /// 심각한 상황 판단
  bool _isSeriousSituation(String message) {
    final seriousWords = ['죽고 싶', '자살', '심각', '위험', '응급', '사고'];
    return seriousWords.any((word) => message.contains(word));
  }
  
  /// 가벼운 불평 판단
  bool _isLightComplaint(String message) {
    final lightWords = ['귀찮', '졸려', '배고파', '심심', '지루'];
    return lightWords.any((word) => message.contains(word));
  }
  
  /// 매우 진지한 대화 판단
  bool _isVerySerious(List<Message> history) {
    if (history.length < 3) return false;
    
    final recentMessages = history.take(3);
    final seriousCount = recentMessages
        .where((msg) => _isSeriousTone(msg.content))
        .length;
    
    return seriousCount >= 2;
  }
  
  /// 진지한 톤 판단
  bool _isSeriousTone(String message) {
    // 이모티콘이 없고 길이가 긴 메시지
    final hasEmoticon = message.contains('ㅋ') || 
                        message.contains('ㅎ') || 
                        message.contains('ㅠ') ||
                        message.contains('!');
    
    return !hasEmoticon && message.length > 50;
  }
  
  /// 장난스러운 메시지 판단
  bool _isPlayfulMessage(String message) {
    final playfulSigns = ['ㅋㅋ', 'ㅎㅎ', '~~', '!!!', '???', '헐', '대박'];
    return playfulSigns.any((sign) => message.contains(sign));
  }
  
  /// 분위기 감지
  String _detectMood(String message) {
    if (message.contains('피곤') || message.contains('졸')) return 'tired';
    if (message.contains('신나') || message.contains('좋')) return 'excited';
    if (message.contains('심심')) return 'bored';
    if (message.contains('스트레스') || message.contains('짜증')) return 'stressed';
    return 'neutral';
  }
  
  /// 주제 감지
  String _detectTopic(String message) {
    if (message.contains('일') || message.contains('회사')) return 'work';
    if (message.contains('밥') || message.contains('먹')) return 'food';
    if (message.contains('자') || message.contains('잠')) return 'sleep';
    if (message.contains('놀') || message.contains('게임')) return 'play';
    return 'general';
  }
  
  /// 대화 에너지 측정
  double _measureConversationEnergy(List<Message> history) {
    if (history.isEmpty) return 0.5;
    
    final recentMessages = history.take(5);
    double energy = 0.5;
    
    for (final msg in recentMessages) {
      if (msg.content.contains('!')) energy += 0.1;
      if (msg.content.contains('ㅋ') || msg.content.contains('ㅎ')) energy += 0.1;
      if (msg.content.length > 50) energy += 0.05;
    }
    
    return energy.clamp(0.0, 1.0);
  }
  
  /// 사용자 유머 선호도 학습
  void learnUserPreference(String userId, String reaction, HumorType type) {
    _userPreferences[userId] ??= HumorPreference();
    final pref = _userPreferences[userId]!;
    
    if (reaction.contains('ㅋ') || reaction.contains('ㅎ') || 
        reaction.contains('재밌') || reaction.contains('웃겨')) {
      pref.likedTypes.add(type);
      pref.successCount++;
    } else if (reaction.contains('...') || reaction.contains(';;') ||
               reaction.contains('썰렁')) {
      pref.dislikedTypes.add(type);
      pref.failCount++;
    }
  }
}

/// 유머 타입 enum
enum HumorType {
  wordPlay,        // 언어유희, 말장난
  selfDeprecating, // 자기비하 유머
  observational,   // 관찰 유머
  playfulTease,    // 친근한 놀림
  situational,     // 상황 유머
  relatable,       // 공감 유머
  witty,          // 재치있는 답변
  light,          // 가벼운 농담
}

/// 사용자 유머 선호도
class HumorPreference {
  final Set<HumorType> likedTypes = {};
  final Set<HumorType> dislikedTypes = {};
  int successCount = 0;
  int failCount = 0;
  
  double get successRate {
    final total = successCount + failCount;
    if (total == 0) return 0.5;
    return successCount / total;
  }
}