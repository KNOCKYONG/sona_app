import 'dart:math';
import 'package:flutter/foundation.dart';
import '../../../models/message.dart';

/// 🎯 대화 품질 시스템 공통 기반 클래스
/// 모든 품질 개선 시스템이 공유하는 기능을 통합
/// 코드 중복 제거 및 일관성 향상
abstract class BaseQualitySystem {
  @protected
  final Random random = Random();
  
  // 사용자별 이력 관리
  @protected
  final Map<String, List<String>> historyMap = {};
  
  @protected
  final Map<String, DateTime> lastUpdateTime = {};
  
  /// 공통 가이드라인 포맷팅
  @protected
  String formatGuideline({
    required String icon,
    required String title,
    required Map<String, dynamic> sections,
  }) {
    final buffer = StringBuffer();
    
    buffer.writeln('$icon $title:');
    
    sections.forEach((key, value) {
      if (value is String) {
        buffer.writeln('- $key: $value');
      } else if (value is List) {
        buffer.writeln('\n$key:');
        for (final item in value) {
          buffer.writeln('- $item');
        }
      } else if (value is Map) {
        buffer.writeln('\n$key:');
        value.forEach((subKey, subValue) {
          buffer.writeln('- $subKey: $subValue');
        });
      }
    });
    
    return buffer.toString();
  }
  
  /// 공통 강도/레벨 계산
  @protected
  double calculateIntensity({
    required String message,
    List<String>? indicators,
    double baseIntensity = 0.3,
  }) {
    double intensity = baseIntensity;
    
    // 느낌표 개수
    final exclamationCount = '!'.allMatches(message).length;
    intensity += exclamationCount * 0.1;
    
    // 이모티콘 사용
    if (RegExp(r'[ㅋㅎㅠㅜ]').hasMatch(message)) {
      intensity += 0.2;
    }
    
    // 반복 표현
    if (RegExp(r'(.)\1{2,}').hasMatch(message)) {
      intensity += 0.2;
    }
    
    // 커스텀 지표
    if (indicators != null) {
      for (final indicator in indicators) {
        if (message.contains(indicator)) {
          intensity += 0.1;
        }
      }
    }
    
    return intensity.clamp(0.0, 1.0);
  }
  
  /// 공통 패턴 감지
  @protected
  bool detectPattern({
    required String message,
    required List<String> patterns,
  }) {
    return patterns.any((pattern) => message.contains(pattern));
  }
  
  /// 감정 감지 (공통)
  @protected
  String detectEmotion(String message) {
    if (RegExp(r'[ㅋㅎ]|재밌|웃긴|좋아').hasMatch(message)) return 'joy';
    if (RegExp(r'[ㅠㅜ]|슬프|우울|힘들').hasMatch(message)) return 'sadness';
    if (RegExp(r'그렇구나|이해해|공감').hasMatch(message)) return 'empathy';
    if (RegExp(r'\?|궁금|뭐|어떻게').hasMatch(message)) return 'curiosity';
    if (RegExp(r'[!]{2,}|대박|헐|와').hasMatch(message)) return 'surprise';
    if (RegExp(r'화나|짜증|싫어').hasMatch(message)) return 'anger';
    if (RegExp(r'불안|걱정|무서').hasMatch(message)) return 'anxiety';
    return 'neutral';
  }
  
  /// 긍정적 분위기 감지 (공통)
  @protected
  bool detectPositiveMood(String message) {
    final positiveWords = ['좋아', 'ㅋㅋ', 'ㅎㅎ', '재밌', '웃긴', '최고', '굿'];
    return detectPattern(message: message, patterns: positiveWords);
  }
  
  /// 부정적 분위기 감지 (공통)
  @protected
  bool detectNegativeMood(String message) {
    final negativeWords = ['싫어', '짜증', '화나', '우울', '슬프', '힘들', '지쳐'];
    return detectPattern(message: message, patterns: negativeWords);
  }
  
  /// 지루함 감지 (공통)
  @protected
  bool detectBoredom(String message) {
    final boredomWords = ['심심', '지루', '재미없', '뭐하지', '할거없'];
    return detectPattern(message: message, patterns: boredomWords);
  }
  
  /// 관심사 감지 (공통)
  @protected
  bool detectInterest(String message, String topic) {
    final topicWords = {
      '음악': ['음악', '노래', '가수', '콘서트', '앨범', '플레이리스트'],
      '영화': ['영화', '드라마', '넷플릭스', '시리즈', '배우', '감독'],
      '음식': ['음식', '맛집', '요리', '먹', '배달', '카페'],
      '운동': ['운동', '헬스', '요가', '러닝', '산책', '다이어트'],
      '여행': ['여행', '여행지', '해외', '국내', '휴가', '관광'],
      '게임': ['게임', '플레이', '스팀', '롤', '오버워치', '배그'],
      '책': ['책', '독서', '소설', '에세이', '작가', '베스트셀러'],
    };
    
    final words = topicWords[topic] ?? [];
    return detectPattern(message: message, patterns: words);
  }
  
  /// 이력 업데이트 (공통)
  @protected
  void updateHistory({
    required String userId,
    required String element,
    int maxHistory = 10,
  }) {
    historyMap[userId] ??= [];
    historyMap[userId]!.add(element);
    
    // 최대 개수 유지
    if (historyMap[userId]!.length > maxHistory) {
      historyMap[userId]!.removeAt(0);
    }
    
    lastUpdateTime[userId] = DateTime.now();
  }
  
  /// 최근 이력 가져오기 (공통)
  @protected
  List<String> getRecentHistory({
    required String userId,
    int count = 5,
  }) {
    final history = historyMap[userId] ?? [];
    if (history.length <= count) return history;
    return history.sublist(history.length - count);
  }
  
  /// 최근 사용 시간 체크 (공통)
  @protected
  bool isRecentlyUsed({
    required String userId,
    Duration threshold = const Duration(minutes: 10),
  }) {
    final lastTime = lastUpdateTime[userId];
    if (lastTime == null) return false;
    
    return DateTime.now().difference(lastTime) < threshold;
  }
  
  /// 대화 정체 감지 (공통)
  @protected
  bool isConversationStagnant(List<Message> history) {
    if (history.length < 4) return false;
    
    // 최근 4개 메시지의 길이 분석
    final recentMessages = history.take(4).map((m) => m.content.length).toList();
    final avgLength = recentMessages.reduce((a, b) => a + b) / recentMessages.length;
    
    // 모든 메시지 길이가 비슷하면 정체
    final variance = recentMessages
        .map((l) => (l - avgLength).abs())
        .reduce((a, b) => a + b);
    
    return variance < 20;
  }
  
  /// 대화 깊이 계산 (공통)
  @protected
  double calculateConversationDepth(List<Message> history) {
    // 대화가 깊어질수록 1.0에 가까워짐
    return (history.length / 20.0).clamp(0.0, 1.0);
  }
  
  /// 다양성 점수 계산 (공통)
  @protected
  double calculateVarietyScore({
    required List<Message> history,
    required String Function(Message) extractor,
  }) {
    if (history.length < 5) return 1.0;
    
    // 최근 10개 메시지의 다양성 체크
    final recentItems = history
        .take(10)
        .where((m) => !m.isFromUser)
        .map(extractor)
        .toSet();
    
    return recentItems.length / 10.0;
  }
  
  /// 강도 설명 변환 (공통)
  @protected
  String intensityToDescription(double intensity) {
    if (intensity < 0.3) return '낮음 (은은한)';
    if (intensity < 0.7) return '중간 (적당한)';
    return '높음 (강렬한)';
  }
  
  /// 페르소나 타입 분석 (공통)
  @protected
  String analyzePersonaType(String? personaType) {
    if (personaType == null) return 'default';
    
    if (personaType.contains('아티스트') || personaType.contains('디자이너')) {
      return 'creative';
    } else if (personaType.contains('개발자') || personaType.contains('엔지니어')) {
      return 'technical';
    } else if (personaType.contains('의사') || personaType.contains('간호사')) {
      return 'caring';
    } else if (personaType.contains('선생님') || personaType.contains('교수')) {
      return 'educational';
    } else if (personaType.contains('요리사') || personaType.contains('바리스타')) {
      return 'culinary';
    } else if (personaType.contains('친구')) {
      return 'friendly';
    }
    
    return 'default';
  }
  
  /// 추상 메서드 - 각 시스템에서 구현 필요
  Map<String, dynamic> generateGuide({
    required String userId,
    required String userMessage,
    required List<Message> chatHistory,
    String? personaType,
  });
}