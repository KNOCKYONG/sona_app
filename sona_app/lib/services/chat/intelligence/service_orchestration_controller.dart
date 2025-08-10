import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../intelligence/conversation_context_manager.dart';
import '../../../models/message.dart';


class ServiceCallHistory {
  final String serviceName;
  final List<DateTime> callTimes = [];
  final Map<String, dynamic> lastContext = {};
  
  ServiceCallHistory(this.serviceName);
  
  bool wasRecentlyCalled({Duration within = const Duration(minutes: 5)}) {
    if (callTimes.isEmpty) return false;
    return DateTime.now().difference(callTimes.last) < within;
  }
  
  void recordCall(Map<String, dynamic> context) {
    callTimes.add(DateTime.now());
    lastContext.clear();
    lastContext.addAll(context);
    
    // 오래된 기록 제거 (최대 10개 유지)
    if (callTimes.length > 10) {
      callTimes.removeAt(0);
    }
  }
}

/// 서비스 오케스트레이션 컨트롤러
/// 각 서비스가 언제 호출되어야 하는지 지능적으로 결정
class ServiceOrchestrationController {
  static ServiceOrchestrationController? _instance;
  static ServiceOrchestrationController get instance => 
      _instance ??= ServiceOrchestrationController._();
  
  ServiceOrchestrationController._();
  
  // 동시 활성화 가능한 최대 서비스 수
  static const int maxActiveServices = 3;
  
  // 서비스별 토큰 예상 사용량 (추정치)
  static const Map<String, int> serviceTokenEstimates = {
    'weather': 150,
    'emotion': 200,
    'memory': 300,
    'dailyCare': 100,
    'interest': 250,
    'continuity': 150,
    'speechPattern': 100,
    'temporalContext': 80,
  };
  
  // 현재 활성화된 서비스 추적
  final Set<String> _activeServices = {};
  
  // 서비스 호출 이력 (세션 동안 유지)
  final Map<String, ServiceCallHistory> _serviceHistory = {};
  
  /// 서비스 호출 이력
  
  /// 현재 토큰 사용량 예측
  int estimateCurrentTokenUsage() {
    int total = 0;
    for (final service in _activeServices) {
      total += serviceTokenEstimates[service] ?? 0;
    }
    return total;
  }
  
  /// 서비스 우선순위 계산
  Map<String, double> calculateServicePriorities({
    required String userMessage,
    required List<Message> chatHistory,
    required UserKnowledge? knowledge,
  }) {
    final priorities = <String, double>{};
    
    // 날씨: 시간대와 키워드 기반
    final hour = DateTime.now().hour;
    final weatherScore = _calculateWeatherPriority(userMessage, hour);
    priorities['weather'] = weatherScore;
    
    // 감정: 감정 표현 강도 기반
    final emotionScore = _calculateEmotionPriority(userMessage);
    priorities['emotion'] = emotionScore;
    
    // 메모리: 관계 깊이 기반
    final memoryScore = chatHistory.length > 10 ? 0.3 : 0.1;
    priorities['memory'] = memoryScore;
    
    // 일상 케어: 시간대 기반
    final careScore = _calculateDailyCareePriority(hour);
    priorities['dailyCare'] = careScore;
    
    // 관심사: 키워드 매칭
    final interestScore = _calculateInterestPriority(userMessage);
    priorities['interest'] = interestScore;
    
    // 대화 지속성: 항상 중요
    priorities['continuity'] = 0.8;
    
    return priorities;
  }
  
  double _calculateWeatherPriority(String message, int hour) {
    final weatherKeywords = ['날씨', '더워', '추워', '비', '눈'];
    final hasKeyword = weatherKeywords.any((k) => message.contains(k));
    final isMorning = hour >= 6 && hour < 10;
    
    if (hasKeyword) return 0.9;
    if (isMorning) return 0.4;
    return 0.1;
  }
  
  double _calculateEmotionPriority(String message) {
    final emotionKeywords = ['기분', '화나', '슬퍼', '우울', '행복'];
    final strongEmotions = ['너무', '진짜', '완전', '대박'];
    
    if (strongEmotions.any((k) => message.contains(k))) return 0.8;
    if (emotionKeywords.any((k) => message.contains(k))) return 0.6;
    return 0.2;
  }
  
  double _calculateDailyCareePriority(int hour) {
    if (hour >= 7 && hour < 9) return 0.5; // 아침
    if (hour >= 11 && hour < 13) return 0.5; // 점심
    if (hour >= 18 && hour < 20) return 0.5; // 저녁
    if (hour >= 22 && hour < 24) return 0.4; // 밤
    return 0.1;
  }
  
  double _calculateInterestPriority(String message) {
    final interestKeywords = ['취미', '좋아하', '관심', '재밌', '영화', '음악'];
    final hasKeyword = interestKeywords.any((k) => message.contains(k));
    return hasKeyword ? 0.7 : 0.2;
  }
  
  /// 날씨 서비스 호출 여부 결정
  Future<bool> shouldCallWeatherService({
    required String userMessage,
    required List<Message> chatHistory,
    required UserKnowledge? knowledge,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    if (!(prefs.getBool('weather_context_enabled') ?? true)) {
      return false;
    }
    
    // 날씨 관련 키워드
    final weatherKeywords = ['날씨', '더워', '추워', '비', '눈', '맑', '흐림', 
                            '춥', '덥', '우산', '바람', '온도', '기온'];
    final hasWeatherTopic = weatherKeywords.any((keyword) => 
        userMessage.contains(keyword));
    
    // 아침 인사일 때 (아침 6-10시)
    final hour = DateTime.now().hour;
    final isMorningGreeting = hour >= 6 && hour < 10 && 
        (userMessage.contains('안녕') || userMessage.contains('하이'));
    
    // 날씨 서비스 호출 이력 확인
    final weatherHistory = _getServiceHistory('weather');
    
    // 최근 5분 이내에 호출했으면 스킵 (날씨는 자주 변하지 않음)
    if (weatherHistory.wasRecentlyCalled(within: Duration(minutes: 5))) {
      debugPrint('⏭️ Weather service was recently called, skipping');
      return false;
    }
    
    // 이미 날씨 얘기를 했는지 확인
    if (knowledge != null && knowledge.recentTopics.containsKey('날씨')) {
      final weatherTopic = knowledge.recentTopics['날씨'];
      final lastMentionedObj = weatherTopic['lastMentioned'];
      
      DateTime? lastMentioned;
      if (lastMentionedObj is DateTime) {
        lastMentioned = lastMentionedObj;
      } else if (lastMentionedObj != null) {
        try {
          lastMentioned = (lastMentionedObj as dynamic).toDate();
        } catch (e) {
          lastMentioned = null;
        }
      }
      
      if (lastMentioned != null && 
          DateTime.now().difference(lastMentioned).inMinutes < 30) {
        debugPrint('💭 Weather was recently discussed, skipping API call');
        return false;
      }
    }
    
    // 서비스 수 제한 체크
    if (_activeServices.length >= maxActiveServices && !_activeServices.contains('weather')) {
      debugPrint('⚠️ Service limit reached, skipping weather service');
      return false;
    }
    
    // 토큰 예산 체크
    final currentUsage = estimateCurrentTokenUsage();
    if (currentUsage + serviceTokenEstimates['weather']! > 2500) {
      debugPrint('⚠️ Token budget exceeded, skipping weather service');
      return false;
    }
    
    final shouldCall = hasWeatherTopic || isMorningGreeting;
    
    if (shouldCall) {
      weatherHistory.recordCall({'trigger': hasWeatherTopic ? 'keyword' : 'morning'});
      _activeServices.add('weather');
    }
    
    return shouldCall;
  }
  
  /// 감정 분석 서비스 호출 여부 결정
  Future<bool> shouldCallEmotionService({
    required String userMessage,
    required List<Message> chatHistory,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    if (!(prefs.getBool('emotion_analysis_enabled') ?? true)) {
      return false;
    }
    
    // 감정 표현 키워드
    final emotionKeywords = ['기분', '화나', '슬퍼', '우울', '행복', '즐거', 
                            '짜증', '스트레스', '힘들', '피곤', '외로'];
    final hasEmotionTopic = emotionKeywords.any((keyword) => 
        userMessage.contains(keyword));
    
    // 감정 서비스 호출 이력
    final emotionHistory = _getServiceHistory('emotion');
    
    // 최근 3분 이내에 호출했으면 스킵
    if (emotionHistory.wasRecentlyCalled(within: Duration(minutes: 3))) {
      return false;
    }
    
    // 감정 변화가 큰 경우나 직접적인 감정 표현이 있을 때만
    final shouldCall = hasEmotionTopic || 
        _hasSignificantEmotionalChange(userMessage, chatHistory);
    
    if (shouldCall) {
      emotionHistory.recordCall({'hasKeyword': hasEmotionTopic});
    }
    
    return shouldCall;
  }
  
  /// 추억 회상 서비스 호출 여부 결정
  Future<bool> shouldCallMemoryAlbum({
    required List<Message> chatHistory,
    required int relationshipScore,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    if (!(prefs.getBool('memory_album_enabled') ?? true)) {
      return false;
    }
    
    // 관계 점수가 충분히 높고
    if (relationshipScore < 200) {
      return false; // 너무 초기 단계에는 추억이 없음
    }
    
    // 대화가 충분히 진행되었고
    if (chatHistory.length < 10) {
      return false; // 대화 초반에는 추억 회상 안함
    }
    
    // 추억 서비스 호출 이력
    final memoryHistory = _getServiceHistory('memory');
    
    // 최근 10분 이내에 호출했으면 스킵
    if (memoryHistory.wasRecentlyCalled(within: Duration(minutes: 10))) {
      return false;
    }
    
    // 10% 확률로 랜덤 추억 회상 (너무 자주 하면 부자연스러움)
    final shouldCall = DateTime.now().millisecond % 10 == 0;
    
    if (shouldCall) {
      memoryHistory.recordCall({'score': relationshipScore});
    }
    
    return shouldCall;
  }
  
  /// 일상 케어 서비스 호출 여부 결정
  Future<bool> shouldCallDailyCare({
    required String userMessage,
    required DateTime currentTime,
    required UserKnowledge? knowledge,
    DateTime? personaMatchedAt,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    if (!(prefs.getBool('daily_care_enabled') ?? true)) {
      return false;
    }
    
    // 대화 시작한지 최소 24시간이 지나야 일상 케어 메시지 활성화
    if (personaMatchedAt != null) {
      final hoursSinceMatch = DateTime.now().difference(personaMatchedAt).inHours;
      if (hoursSinceMatch < 24) {
        return false;
      }
    }
    
    final hour = currentTime.hour;
    
    // 케어 서비스 호출 이력
    final careHistory = _getServiceHistory('dailyCare');
    
    // 최근 30분 이내에 호출했으면 스킵
    if (careHistory.wasRecentlyCalled(within: Duration(minutes: 30))) {
      return false;
    }
    
    // 특정 시간대에만 활성화
    bool shouldCall = false;
    
    // 아침 (7-9시): 아침 식사, 출근/등교 관련
    if (hour >= 7 && hour < 9) {
      if (!_hasRecentlyCaredAbout('morning', knowledge)) {
        shouldCall = true;
      }
    }
    // 점심 (11-13시): 점심 식사 관련
    else if (hour >= 11 && hour < 13) {
      if (!_hasRecentlyCaredAbout('lunch', knowledge)) {
        shouldCall = true;
      }
    }
    // 저녁 (18-20시): 퇴근, 저녁 식사 관련
    else if (hour >= 18 && hour < 20) {
      if (!_hasRecentlyCaredAbout('evening', knowledge)) {
        shouldCall = true;
      }
    }
    // 밤 (22-24시): 수면, 내일 준비 관련
    else if (hour >= 22 && hour < 24) {
      if (!_hasRecentlyCaredAbout('night', knowledge)) {
        shouldCall = true;
      }
    }
    
    if (shouldCall) {
      careHistory.recordCall({'time': hour});
    }
    
    return shouldCall;
  }
  
  /// 관심사 공유 서비스 호출 여부 결정
  Future<bool> shouldCallInterestSharing({
    required String userMessage,
    required UserKnowledge? knowledge,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    if (!(prefs.getBool('interest_sharing_enabled') ?? true)) {
      return false;
    }
    
    // 취미/관심사 키워드
    final interestKeywords = ['취미', '좋아하', '관심', '재밌', '즐기', 
                             '영화', '음악', '운동', '게임', '책'];
    final hasInterestTopic = interestKeywords.any((keyword) => 
        userMessage.contains(keyword));
    
    // 관심사 서비스 호출 이력
    final interestHistory = _getServiceHistory('interest');
    
    // 최근 15분 이내에 호출했으면 스킵
    if (interestHistory.wasRecentlyCalled(within: Duration(minutes: 15))) {
      return false;
    }
    
    // 이미 비슷한 관심사를 공유했는지 확인
    if (knowledge != null && hasInterestTopic) {
      for (final keyword in interestKeywords) {
        if (userMessage.contains(keyword) && 
            knowledge.preferences.containsKey(keyword)) {
          debugPrint('💭 Already know about this interest: $keyword');
          return false; // 이미 알고 있는 관심사
        }
      }
    }
    
    final shouldCall = hasInterestTopic;
    
    if (shouldCall) {
      interestHistory.recordCall({'topic': userMessage});
    }
    
    return shouldCall;
  }
  
  /// 대화 지속성 서비스 호출 여부 결정
  Future<bool> shouldCallContinuityService({
    required List<Message> chatHistory,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    if (!(prefs.getBool('conversation_continuity_enabled') ?? true)) {
      return false;
    }
    
    // 대화가 너무 짧으면 스킵
    if (chatHistory.length < 5) {
      return false;
    }
    
    // 지속성 서비스 호출 이력
    final continuityHistory = _getServiceHistory('continuity');
    
    // 최근 2분 이내에 호출했으면 스킵
    if (continuityHistory.wasRecentlyCalled(within: Duration(minutes: 2))) {
      return false;
    }
    
    // 항상 호출 (대화 연속성은 중요)
    continuityHistory.recordCall({'messageCount': chatHistory.length});
    
    return true;
  }
  
  /// 서비스 호출 이력 가져오기
  ServiceCallHistory _getServiceHistory(String serviceName) {
    return _serviceHistory.putIfAbsent(
      serviceName, 
      () => ServiceCallHistory(serviceName)
    );
  }
  
  /// 최근에 특정 주제로 케어했는지 확인
  bool _hasRecentlyCaredAbout(String topic, 
      UserKnowledge? knowledge) {
    if (knowledge == null) return false;
    
    final careTopics = {
      'morning': ['아침', '출근', '등교'],
      'lunch': ['점심', '밥'],
      'evening': ['저녁', '퇴근'],
      'night': ['잠', '수면', '내일'],
    };
    
    final keywords = careTopics[topic] ?? [];
    for (final keyword in keywords) {
      if (knowledge.recentTopics.containsKey(keyword)) {
        final lastMentionedObj = knowledge.recentTopics[keyword]['lastMentioned'];
        
        DateTime? lastMentioned;
        if (lastMentionedObj is DateTime) {
          lastMentioned = lastMentionedObj;
        } else if (lastMentionedObj != null) {
          try {
            lastMentioned = (lastMentionedObj as dynamic).toDate();
          } catch (e) {
            lastMentioned = null;
          }
        }
        
        if (lastMentioned != null && 
            DateTime.now().difference(lastMentioned).inMinutes < 30) {
          return true;
        }
      }
    }
    
    return false;
  }
  
  /// 감정 변화가 큰지 확인
  bool _hasSignificantEmotionalChange(String userMessage, List<Message> chatHistory) {
    // 감정 변화 감지 로직
    final strongEmotions = ['너무', '진짜', '완전', '대박', '최악', '최고'];
    final hasStrongEmotion = strongEmotions.any((word) => userMessage.contains(word));
    
    // 느낌표나 물음표가 많은 경우
    final exclamationCount = '!'.allMatches(userMessage).length;
    final questionCount = '?'.allMatches(userMessage).length;
    
    return hasStrongEmotion || exclamationCount >= 2 || questionCount >= 2;
  }
  
  /// 서비스 호출 통계 리셋 (세션 종료 시)
  void resetStatistics() {
    _serviceHistory.clear();
    _activeServices.clear();
  }
  
  /// 서비스 호출 완료 후 정리
  void completeServiceCall(String serviceName) {
    _activeServices.remove(serviceName);
    debugPrint('✅ Service completed: $serviceName, Active: $_activeServices');
  }
  
  /// 최적화된 서비스 선택
  Future<List<String>> selectOptimalServices({
    required String userMessage,
    required List<Message> chatHistory,
    required UserKnowledge? knowledge,
  }) async {
    final priorities = calculateServicePriorities(
      userMessage: userMessage,
      chatHistory: chatHistory,
      knowledge: knowledge,
    );
    
    // 우선순위 정렬
    final sorted = priorities.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    final selected = <String>[];
    int tokenBudget = 0;
    
    for (final entry in sorted) {
      final service = entry.key;
      final priority = entry.value;
      
      // 우선순위가 너무 낮으면 스킵
      if (priority < 0.3) continue;
      
      final tokenCost = serviceTokenEstimates[service] ?? 0;
      
      // 토큰 예산 체크 (최대 800 토큰)
      if (tokenBudget + tokenCost <= 800 && selected.length < maxActiveServices) {
        selected.add(service);
        tokenBudget += tokenCost;
        _activeServices.add(service);
      }
    }
    
    debugPrint('📊 Selected services: $selected (${tokenBudget} tokens)');
    return selected;
  }
  
  /// 디버그용 통계 출력
  void printStatistics() {
    debugPrint('=== Service Call Statistics ===');
    for (final entry in _serviceHistory.entries) {
      final history = entry.value;
      debugPrint('${entry.key}: ${history.callTimes.length} calls');
      if (history.callTimes.isNotEmpty) {
        debugPrint('  Last called: ${history.callTimes.last}');
      }
    }
  }
}