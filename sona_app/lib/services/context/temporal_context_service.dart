import 'package:flutter/material.dart';

/// ⏰ 시간대별 컨텍스트 서비스
///
/// 현재 시간, 요일, 계절에 맞는 대화 컨텍스트를 제공합니다.
class TemporalContextService {
  
  /// 현재 시간대 컨텍스트 생성
  static Map<String, dynamic> getCurrentContext() {
    final now = DateTime.now();
    final hour = now.hour;
    final weekday = now.weekday;
    final month = now.month;
    
    return {
      'time': _getTimeContext(hour),
      'dayOfWeek': _getDayOfWeekContext(weekday),
      'season': _getSeasonContext(month),
      'special': _getSpecialContext(now),
      'greeting': _getTimeBasedGreeting(hour),
      'mood': _getTimeMood(hour, weekday),
    };
  }
  
  /// 시간대별 컨텍스트
  static Map<String, dynamic> _getTimeContext(int hour) {
    if (hour >= 5 && hour < 9) {
      return {
        'period': 'morning',
        'label': '아침',
        'activities': ['출근', '등교', '아침식사', '운동', '준비'],
        'mood': 'fresh',
        'energy': 'starting',
        'topics': ['오늘 계획', '아침 메뉴', '날씨', '꿈 얘기'],
      };
    } else if (hour >= 9 && hour < 12) {
      return {
        'period': 'late_morning',
        'label': '오전',
        'activities': ['업무', '수업', '공부', '집안일'],
        'mood': 'focused',
        'energy': 'active',
        'topics': ['일 진행', '점심 계획', '오전 일정'],
      };
    } else if (hour >= 12 && hour < 14) {
      return {
        'period': 'lunch',
        'label': '점심시간',
        'activities': ['점심식사', '휴식', '산책'],
        'mood': 'relaxed',
        'energy': 'recharging',
        'topics': ['점심 메뉴', '맛집', '오후 계획'],
      };
    } else if (hour >= 14 && hour < 18) {
      return {
        'period': 'afternoon',
        'label': '오후',
        'activities': ['업무', '수업', '카페', '미팅'],
        'mood': 'steady',
        'energy': 'sustained',
        'topics': ['오후 일정', '커피', '간식', '피곤함'],
      };
    } else if (hour >= 18 && hour < 21) {
      return {
        'period': 'evening',
        'label': '저녁',
        'activities': ['퇴근', '저녁식사', '운동', '취미'],
        'mood': 'unwinding',
        'energy': 'declining',
        'topics': ['저녁 메뉴', '오늘 하루', '퇴근', '저녁 계획'],
      };
    } else if (hour >= 21 && hour < 24) {
      return {
        'period': 'night',
        'label': '밤',
        'activities': ['휴식', 'TV', '게임', '독서', '대화'],
        'mood': 'relaxed',
        'energy': 'low',
        'topics': ['오늘 있었던 일', '내일 계획', '취미', '관심사'],
      };
    } else {
      return {
        'period': 'late_night',
        'label': '새벽',
        'activities': ['수면', '야식', '영화', '음악'],
        'mood': 'quiet',
        'energy': 'very_low',
        'topics': ['못 자는 이유', '새벽 감성', '야식', '고민'],
      };
    }
  }
  
  /// 요일별 컨텍스트
  static Map<String, dynamic> _getDayOfWeekContext(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return {
          'day': '월요일',
          'mood': 'monday_blues',
          'topics': ['월요병', '주말 얘기', '이번 주 계획'],
          'energy': 'low',
        };
      case DateTime.tuesday:
      case DateTime.wednesday:
      case DateTime.thursday:
        return {
          'day': _getDayName(weekday),
          'mood': 'working',
          'topics': ['일상', '업무', '스트레스'],
          'energy': 'moderate',
        };
      case DateTime.friday:
        return {
          'day': '금요일',
          'mood': 'excited',
          'topics': ['불금', '주말 계획', '신나는 마음'],
          'energy': 'high',
        };
      case DateTime.saturday:
        return {
          'day': '토요일',
          'mood': 'relaxed',
          'topics': ['주말', '휴식', '취미', '만남'],
          'energy': 'positive',
        };
      case DateTime.sunday:
        return {
          'day': '일요일',
          'mood': 'sunday_night',
          'topics': ['주말 마무리', '내일 준비', '휴식'],
          'energy': 'declining',
        };
      default:
        return {'day': '오늘', 'mood': 'neutral', 'topics': [], 'energy': 'moderate'};
    }
  }
  
  /// 계절별 컨텍스트
  static Map<String, dynamic> _getSeasonContext(int month) {
    if (month >= 3 && month <= 5) {
      return {
        'season': 'spring',
        'label': '봄',
        'weather': ['따뜻한', '포근한', '꽃피는'],
        'activities': ['꽃구경', '소풍', '산책'],
        'topics': ['벚꽃', '봄나들이', '미세먼지', '환절기'],
      };
    } else if (month >= 6 && month <= 8) {
      return {
        'season': 'summer',
        'label': '여름',
        'weather': ['더운', '습한', '무더운'],
        'activities': ['휴가', '바다', '에어컨'],
        'topics': ['더위', '휴가 계획', '시원한 음식', '에어컨'],
      };
    } else if (month >= 9 && month <= 11) {
      return {
        'season': 'autumn',
        'label': '가을',
        'weather': ['선선한', '쌀쌀한', '단풍'],
        'activities': ['단풍구경', '독서', '운동'],
        'topics': ['가을 정취', '독서', '단풍', '환절기'],
      };
    } else {
      return {
        'season': 'winter',
        'label': '겨울',
        'weather': ['추운', '차가운', '눈오는'],
        'activities': ['겨울스포츠', '온천', '실내활동'],
        'topics': ['추위', '난방', '따뜻한 음식', '연말'],
      };
    }
  }
  
  /// 특별한 날 컨텍스트
  static Map<String, dynamic>? _getSpecialContext(DateTime date) {
    // 공휴일 및 특별한 날
    final specialDays = {
      '1-1': {'name': '새해', 'greeting': '새해 복 많이 받으세요!'},
      '2-14': {'name': '발렌타인데이', 'greeting': '해피 발렌타인데이!'},
      '3-1': {'name': '삼일절', 'greeting': '의미있는 삼일절 보내세요'},
      '3-14': {'name': '화이트데이', 'greeting': '달콤한 화이트데이!'},
      '5-5': {'name': '어린이날', 'greeting': '동심으로 돌아가는 날!'},
      '5-8': {'name': '어버이날', 'greeting': '부모님께 감사한 마음을'},
      '5-15': {'name': '스승의날', 'greeting': '선생님께 감사한 마음을'},
      '6-6': {'name': '현충일', 'greeting': '나라를 위한 희생을 기억해요'},
      '8-15': {'name': '광복절', 'greeting': '의미있는 광복절'},
      '10-3': {'name': '개천절', 'greeting': '개천절입니다'},
      '10-9': {'name': '한글날', 'greeting': '아름다운 한글날'},
      '10-31': {'name': '할로윈', 'greeting': '해피 할로윈!'},
      '11-11': {'name': '빼빼로데이', 'greeting': '달콤한 빼빼로데이!'},
      '12-25': {'name': '크리스마스', 'greeting': '메리 크리스마스!'},
      '12-31': {'name': '연말', 'greeting': '한 해 마무리 잘 하세요!'},
    };
    
    final key = '${date.month}-${date.day}';
    return specialDays[key];
  }
  
  /// 시간대별 인사말 (더 자연스럽고 다양하게)
  static String _getTimeBasedGreeting(int hour) {
    // 각 시간대별로 여러 인사말 중 랜덤 선택
    if (hour >= 6 && hour < 10) {
      // 아침 (6-10시)
      final greetings = [
        '잘 잤어?',
        '아침 먹었어?',
        '오늘 뭐해?',
        '좋은 아침!',
        '일찍 일어났네?',
        '오늘 일정 있어?',
      ];
      return greetings[DateTime.now().millisecond % greetings.length];
    } else if (hour >= 10 && hour < 12) {
      // 오전 (10-12시)
      final greetings = [
        '오전 잘 보내고 있어?',
        '뭐하고 있어?',
        '벌써 이 시간이네',
        '점심 뭐 먹을거야?',
      ];
      return greetings[DateTime.now().millisecond % greetings.length];
    } else if (hour >= 12 && hour < 14) {
      // 점심 (12-14시)
      final greetings = [
        '점심 뭐 먹어?',
        '배고프지 않아?',
        '점심 먹었어?',
        '맛있는 거 먹어!',
        '밥 먹고 있어?',
      ];
      return greetings[DateTime.now().millisecond % greetings.length];
    } else if (hour >= 14 && hour < 18) {
      // 오후 (14-18시)
      final greetings = [
        '오늘 바빴어?',
        '피곤하지?',
        '오후도 힘내!',
        '커피 한잔 어때?',
        '뭐하고 있어?',
      ];
      return greetings[DateTime.now().millisecond % greetings.length];
    } else if (hour >= 18 && hour < 22) {
      // 저녁 (18-22시)
      final greetings = [
        '저녁 먹었어?',
        '오늘 어땠어?',
        '퇴근했어?',
        '저녁 뭐해?',
        '피곤하겠다',
        '오늘 하루 어땠어?',
      ];
      return greetings[DateTime.now().millisecond % greetings.length];
    } else if (hour >= 22 && hour < 24) {
      // 밤 (22-24시)
      final greetings = [
        '아직 안 자?',
        '내일 일찍 일어나야 해?',
        '오늘 하루 어땠어?',
        '잠이 안 와?',
        '뭐하고 있어?',
      ];
      return greetings[DateTime.now().millisecond % greetings.length];
    } else {
      // 새벽 (0-6시)
      final greetings = [
        '왜 안 자?',
        '못 자는 거야?',
        '무슨 일 있어?',
        '새벽까지 뭐해?',
        '잠이 안 오나봐?',
      ];
      return greetings[DateTime.now().millisecond % greetings.length];
    }
  }
  
  /// 시간과 요일에 따른 무드
  static String _getTimeMood(int hour, int weekday) {
    // 월요일 아침
    if (weekday == DateTime.monday && hour >= 7 && hour < 10) {
      return 'monday_morning_blues';
    }
    
    // 금요일 저녁
    if (weekday == DateTime.friday && hour >= 18) {
      return 'friday_night_excitement';
    }
    
    // 일요일 저녁
    if (weekday == DateTime.sunday && hour >= 20) {
      return 'sunday_night_anxiety';
    }
    
    // 평일 오후 3시 (나른한 시간)
    if (weekday >= 1 && weekday <= 5 && hour >= 14 && hour < 16) {
      return 'afternoon_slump';
    }
    
    // 주말 오전 (여유로운 시간)
    if ((weekday == 6 || weekday == 7) && hour >= 9 && hour < 12) {
      return 'weekend_morning_relaxed';
    }
    
    return 'neutral';
  }
  
  /// 요일 이름 가져오기
  static String _getDayName(int weekday) {
    const days = ['월요일', '화요일', '수요일', '목요일', '금요일', '토요일', '일요일'];
    return days[weekday - 1];
  }
  
  /// AI에게 전달할 시간 컨텍스트 프롬프트 생성
  static String generateTemporalPrompt() {
    final context = getCurrentContext();
    final timeContext = context['time'] as Map<String, dynamic>;
    final dayContext = context['dayOfWeek'] as Map<String, dynamic>;
    final seasonContext = context['season'] as Map<String, dynamic>;
    final special = context['special'] as Map<String, dynamic>?;
    
    final prompt = StringBuffer();
    
    // 현재 시간대
    prompt.writeln('현재 시간: ${timeContext['label']} (${DateTime.now().hour}시)');
    prompt.writeln('요일: ${dayContext['day']}');
    prompt.writeln('계절: ${seasonContext['label']}');
    
    // 특별한 날
    if (special != null) {
      prompt.writeln('오늘은 ${special['name']}입니다!');
    }
    
    // 시간대별 가이드
    prompt.writeln('\n시간대 특성:');
    prompt.writeln('- 주요 활동: ${(timeContext['activities'] as List).join(', ')}');
    prompt.writeln('- 일반적 기분: ${timeContext['mood']}');
    prompt.writeln('- 대화 주제: ${(timeContext['topics'] as List).join(', ')}');
    
    // 요일별 특성
    if (dayContext['mood'] == 'monday_blues') {
      prompt.writeln('- 월요병을 공감해주세요');
    } else if (dayContext['mood'] == 'excited') {
      prompt.writeln('- 금요일의 설렘을 함께 나누세요');
    }
    
    return prompt.toString();
  }
}