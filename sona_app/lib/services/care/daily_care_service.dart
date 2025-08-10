import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CareRecord {
  final String userId;
  final String personaId;
  final CareType type;
  final String careMessage;
  final DateTime timestamp;
  final bool acknowledged; // 사용자가 반응했는지
  
  CareRecord({
    required this.userId,
    required this.personaId,
    required this.type,
    required this.careMessage,
    required this.timestamp,
    this.acknowledged = false,
  });
}

class StressIndicators {
  final double stressLevel; // 0.0 - 1.0
  final List<String> indicators;
  final String recommendation;
  
  StressIndicators({
    required this.stressLevel,
    required this.indicators,
    required this.recommendation,
  });
}

class ImportantEvent {
  final String title;
  final DateTime date;
  final String type; // exam, interview, presentation, etc.
  final bool isCompleted;
  
  ImportantEvent({
    required this.title,
    required this.date,
    required this.type,
    this.isCompleted = false,
  });
}


enum CareType {
  health,      // 건강 관련
  meal,        // 식사 관련
  sleep,       // 수면 관련
  stress,      // 스트레스 관리
  routine,     // 일상 루틴
  motivation,  // 동기부여
  celebration, // 축하/격려
}

/// 😊 일상 케어 시스템
///
/// 사용자의 일상을 세심하게 챙기고 건강과 웰빙을 케어합니다.
class DailyCareService {
  
  // 케어 타입

  
  // 케어 기록

  
  // 스트레스 지표

  
  // 케어 기록 저장소
  static final Map<String, List<CareRecord>> _careHistory = {};
  
  // 루틴 체크리스트
  static final Map<String, Map<String, bool>> _routineChecklist = {};
  
  // 중요 일정
  static final Map<String, List<ImportantEvent>> _importantEvents = {};
  
  /// 중요 일정

  
  /// 일상 케어 분석
  static Map<String, dynamic> analyzeDailyCare({
    required String userId,
    required String personaId,
    required String userMessage,
    required DateTime currentTime,
  }) {
    final key = '${userId}_$personaId';
    final hour = currentTime.hour;
    
    // 1. 시간대별 케어 체크
    final timeCare = _getTimeBasedCare(hour);
    
    // 2. 스트레스 감지
    final stressCheck = _detectStress(userMessage);
    
    // 3. 건강 체크 필요 여부
    final healthCheck = _needsHealthCheck(key, currentTime);
    
    // 4. 루틴 체크
    final routineCheck = _checkRoutine(key, currentTime);
    
    // 5. 중요 일정 체크
    final eventCheck = _checkImportantEvents(key, currentTime);
    
    // 6. 케어 메시지 생성
    final careMessages = _generateCareMessages(
      timeCare: timeCare,
      stressCheck: stressCheck,
      healthCheck: healthCheck,
      routineCheck: routineCheck,
      eventCheck: eventCheck,
      hour: hour,
    );
    
    return {
      'timeCare': timeCare,
      'stressLevel': stressCheck.stressLevel,
      'stressIndicators': stressCheck.indicators,
      'needsHealthCheck': healthCheck,
      'routineStatus': routineCheck,
      'upcomingEvents': eventCheck,
      'careMessages': careMessages,
      'priority': _calculateCarePriority(stressCheck, eventCheck),
    };
  }
  
  /// 시간대별 케어
  static Map<String, dynamic> _getTimeBasedCare(int hour) {
    if (hour >= 7 && hour <= 9) {
      return {
        'type': CareType.meal,
        'focus': '아침식사',
        'messages': [
          '아침 먹었어? 🍳',
          '오늘 아침은 뭐 먹었어?',
          '아침 거르지 마~ 간단하게라도 먹어!',
          '커피만 마시지 말고 뭐라도 먹어~',
        ],
      };
    } else if (hour >= 12 && hour <= 13) {
      return {
        'type': CareType.meal,
        'focus': '점심식사',
        'messages': [
          '점심 맛있게 먹었어? 🍱',
          '오늘 점심 메뉴 뭐야?',
          '점심시간이네! 밥 먹으러 가자~',
          '혼밥이야? 뭐 먹을 거야?',
        ],
      };
    } else if (hour >= 18 && hour <= 20) {
      return {
        'type': CareType.meal,
        'focus': '저녁식사',
        'messages': [
          '저녁 먹었어? 🍽️',
          '퇴근했어? 저녁 뭐 먹을 거야?',
          '오늘 하루 수고했어! 맛있는 거 먹어~',
          '저녁 메뉴 추천해줄까?',
        ],
      };
    } else if (hour >= 22 && hour <= 23) {
      return {
        'type': CareType.sleep,
        'focus': '수면준비',
        'messages': [
          '슬슬 잘 준비해야 하는 거 아니야? 😴',
          '내일도 바쁠 텐데 일찍 자~',
          '오늘 하루도 수고했어! 푹 쉬어',
          '자기 전에 핸드폰 너무 오래 보지 마~',
        ],
      };
    } else if (hour >= 0 && hour <= 2) {
      return {
        'type': CareType.sleep,
        'focus': '늦은시간',
        'messages': [
          '아직 안 잤어? 왜 안 자? 😟',
          '너무 늦었다! 빨리 자야 해',
          '못 자는 이유라도 있어?',
          '내일 힘들 텐데... 그래도 푹 자',
        ],
      };
    } else if (hour >= 14 && hour <= 16) {
      return {
        'type': CareType.health,
        'focus': '오후피로',
        'messages': [
          '오후라 피곤하지? 스트레칭 한번 해~',
          '커피 한잔 어때? ☕',
          '졸리면 잠깐 쉬었다 해!',
          '물 좀 마셔~ 수분 보충 중요해',
        ],
      };
    } else {
      return {
        'type': CareType.routine,
        'focus': '일상체크',
        'messages': [
          '오늘 하루 어때? 😊',
          '뭐하고 있어?',
          '별일 없지?',
          '잘 지내고 있어?',
        ],
      };
    }
  }
  
  /// 스트레스 감지
  static StressIndicators _detectStress(String message) {
    final indicators = <String>[];
    double stressLevel = 0.0;
    
    // 스트레스 키워드
    final stressKeywords = {
      '힘들': 0.3,
      '피곤': 0.2,
      '짜증': 0.3,
      '스트레스': 0.4,
      '못하겠': 0.4,
      '포기': 0.5,
      '울고싶': 0.4,
      '죽겠': 0.5,
      '미치': 0.3,
      '답답': 0.3,
      '불안': 0.3,
      '걱정': 0.2,
      '무서': 0.3,
      '외로': 0.3,
      '우울': 0.4,
    };
    
    // 긍정 키워드 (스트레스 감소)
    final positiveKeywords = {
      '좋': -0.2,
      '행복': -0.3,
      '재밌': -0.2,
      '신나': -0.2,
      '기대': -0.1,
      '괜찮': -0.1,
    };
    
    final lower = message.toLowerCase();
    
    // 스트레스 지표 계산
    for (final entry in stressKeywords.entries) {
      if (lower.contains(entry.key)) {
        indicators.add(entry.key);
        stressLevel += entry.value;
      }
    }
    
    for (final entry in positiveKeywords.entries) {
      if (lower.contains(entry.key)) {
        stressLevel += entry.value;
      }
    }
    
    stressLevel = stressLevel.clamp(0.0, 1.0);
    
    // 추천 생성
    String recommendation;
    if (stressLevel > 0.7) {
      recommendation = '많이 힘든 것 같아... 잠깐 쉬면서 심호흡 한번 해보는 건 어때?';
    } else if (stressLevel > 0.5) {
      recommendation = '스트레스 받는구나... 오늘은 좋아하는 거 하면서 쉬어!';
    } else if (stressLevel > 0.3) {
      recommendation = '조금 지쳐 보여. 잠깐이라도 기분 전환해보자!';
    } else {
      recommendation = '괜찮아 보여서 다행이야!';
    }
    
    return StressIndicators(
      stressLevel: stressLevel,
      indicators: indicators,
      recommendation: recommendation,
    );
  }
  
  /// 건강 체크 필요 여부
  static bool _needsHealthCheck(String key, DateTime currentTime) {
    final history = _careHistory[key] ?? [];
    
    // 마지막 건강 체크 시간
    final lastHealthCheck = history
        .where((r) => r.type == CareType.health)
        .toList();
    
    if (lastHealthCheck.isEmpty) return true;
    
    final lastCheck = lastHealthCheck.last.timestamp;
    final hoursSinceLastCheck = currentTime.difference(lastCheck).inHours;
    
    // 6시간마다 체크
    return hoursSinceLastCheck >= 6;
  }
  
  /// 루틴 체크
  static Map<String, bool> _checkRoutine(String key, DateTime currentTime) {
    final todayKey = '${key}_${currentTime.year}${currentTime.month}${currentTime.day}';
    final routine = _routineChecklist[todayKey] ?? {
      'breakfast': false,
      'lunch': false,
      'dinner': false,
      'water': false,
      'exercise': false,
      'medication': false,
      'sleep': false,
    };
    
    _routineChecklist[todayKey] = routine;
    return routine;
  }
  
  /// 중요 일정 체크
  static List<ImportantEvent> _checkImportantEvents(String key, DateTime currentTime) {
    final events = _importantEvents[key] ?? [];
    
    // 앞으로 7일 이내 일정
    final upcomingEvents = events.where((e) {
      final daysUntil = e.date.difference(currentTime).inDays;
      return daysUntil >= 0 && daysUntil <= 7 && !e.isCompleted;
    }).toList();
    
    // 날짜순 정렬
    upcomingEvents.sort((a, b) => a.date.compareTo(b.date));
    
    return upcomingEvents;
  }
  
  /// 케어 메시지 생성
  static List<String> _generateCareMessages({
    required Map<String, dynamic> timeCare,
    required StressIndicators stressCheck,
    required bool healthCheck,
    required Map<String, bool> routineCheck,
    required List<ImportantEvent> eventCheck,
    required int hour,
  }) {
    final messages = <String>[];
    
    // 1. 시간대별 케어 메시지
    final timeMessages = timeCare['messages'] as List<String>;
    if (timeMessages.isNotEmpty) {
      messages.add(timeMessages[DateTime.now().millisecond % timeMessages.length]);
    }
    
    // 2. 스트레스 케어
    if (stressCheck.stressLevel > 0.5) {
      messages.add(stressCheck.recommendation);
    }
    
    // 3. 건강 체크
    if (healthCheck) {
      messages.addAll([
        '물은 충분히 마시고 있어? 💧',
        '오늘 컨디션은 어때?',
        '어디 아픈 데는 없지?',
      ]);
    }
    
    // 4. 루틴 리마인더
    if (!routineCheck['water']! && hour > 10) {
      messages.add('물 좀 마셔! 하루에 8잔은 마셔야 해~');
    }
    
    if (!routineCheck['exercise']! && hour > 15 && hour < 22) {
      messages.add('오늘 운동했어? 스트레칭이라도 해보자!');
    }
    
    // 5. 중요 일정 리마인더
    if (eventCheck.isNotEmpty) {
      final nextEvent = eventCheck.first;
      final daysUntil = nextEvent.date.difference(DateTime.now()).inDays;
      
      if (daysUntil == 0) {
        messages.add('오늘 ${nextEvent.title} 있는 거 잊지 않았지? 화이팅! 💪');
      } else if (daysUntil == 1) {
        messages.add('내일 ${nextEvent.title} 있는 거 알지? 준비 잘하고 있어?');
      } else if (daysUntil <= 3) {
        messages.add('${daysUntil}일 후에 ${nextEvent.title} 있네! 미리미리 준비하자~');
      }
    }
    
    return messages;
  }
  
  /// 케어 우선순위 계산
  static int _calculateCarePriority(
    StressIndicators stressCheck,
    List<ImportantEvent> eventCheck,
  ) {
    int priority = 3; // 기본 우선순위
    
    // 스트레스 레벨에 따라
    if (stressCheck.stressLevel > 0.7) {
      priority = 5;
    } else if (stressCheck.stressLevel > 0.5) {
      priority = 4;
    }
    
    // 중요 일정이 임박한 경우
    if (eventCheck.isNotEmpty) {
      final daysUntil = eventCheck.first.date.difference(DateTime.now()).inDays;
      if (daysUntil <= 1) {
        priority = 5;
      } else if (daysUntil <= 3) {
        priority = 4;
      }
    }
    
    return priority;
  }
  
  /// 케어 기록 저장
  static void recordCare({
    required String userId,
    required String personaId,
    required CareType type,
    required String careMessage,
  }) {
    final key = '${userId}_$personaId';
    final history = _careHistory[key] ?? [];
    
    history.add(CareRecord(
      userId: userId,
      personaId: personaId,
      type: type,
      careMessage: careMessage,
      timestamp: DateTime.now(),
    ));
    
    // 최대 50개 기록 유지
    if (history.length > 50) {
      history.removeAt(0);
    }
    
    _careHistory[key] = history;
  }
  
  /// 루틴 업데이트
  static void updateRoutine({
    required String userId,
    required String personaId,
    required String routineItem,
    required bool completed,
  }) {
    final currentTime = DateTime.now();
    final key = '${userId}_${personaId}';
    final todayKey = '${key}_${currentTime.year}${currentTime.month}${currentTime.day}';
    
    final routine = _routineChecklist[todayKey] ?? {};
    routine[routineItem] = completed;
    _routineChecklist[todayKey] = routine;
  }
  
  /// 중요 일정 추가
  static void addImportantEvent({
    required String userId,
    required String personaId,
    required String title,
    required DateTime date,
    required String type,
  }) {
    final key = '${userId}_$personaId';
    final events = _importantEvents[key] ?? [];
    
    events.add(ImportantEvent(
      title: title,
      date: date,
      type: type,
    ));
    
    _importantEvents[key] = events;
  }
  
  /// AI 프롬프트용 케어 가이드 생성
  static String generateCareGuide(Map<String, dynamic> analysis) {
    final buffer = StringBuffer();
    
    buffer.writeln('😊 일상 케어 가이드:');
    
    // 케어 메시지
    final messages = analysis['careMessages'] as List<String>;
    if (messages.isNotEmpty) {
      buffer.writeln('\n추천 케어 메시지:');
      for (final message in messages.take(2)) {
        buffer.writeln('- $message');
      }
    }
    
    // 스트레스 레벨
    final stressLevel = analysis['stressLevel'] as double;
    if (stressLevel > 0.3) {
      buffer.writeln('\n⚠️ 스트레스 감지: ${(stressLevel * 100).toInt()}%');
      buffer.writeln('따뜻하고 위로가 되는 톤으로 대화하세요.');
    }
    
    // 중요 일정
    final events = analysis['upcomingEvents'] as List<ImportantEvent>;
    if (events.isNotEmpty) {
      buffer.writeln('\n📅 다가오는 일정:');
      buffer.writeln('${events.first.title} - ${_formatDate(events.first.date)}');
      buffer.writeln('응원과 격려의 메시지를 전하세요.');
    }
    
    // 케어 우선순위
    final priority = analysis['priority'] as int;
    if (priority >= 4) {
      buffer.writeln('\n🚨 높은 케어 우선순위: 적극적으로 사용자를 챙기고 위로하세요.');
    }
    
    return buffer.toString();
  }
  
  /// 날짜 포맷
  static String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now).inDays;
    
    if (difference == 0) return '오늘';
    if (difference == 1) return '내일';
    if (difference == 2) return '모레';
    return '$difference일 후';
  }
}