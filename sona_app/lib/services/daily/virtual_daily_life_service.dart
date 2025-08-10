import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/persona.dart';
import '../base/base_service.dart';

/// 🌅 가상 일상 생활 서비스
///
/// 소나가 실제로 일상을 살아가는 것처럼 표현
/// - 시간대별 활동 상태
/// - 계절/날씨 반영
/// - 일상 루틴 생성
class VirtualDailyLifeService extends BaseService {
  // 싱글톤 패턴
  static final VirtualDailyLifeService _instance = VirtualDailyLifeService._internal();
  factory VirtualDailyLifeService() => _instance;
  VirtualDailyLifeService._internal();

  // 현재 가상 상태
  VirtualState? _currentState;
  
  // 일상 활동 로그
  final List<DailyActivity> _activityLog = [];

  /// 현재 시간대별 상태 가져오기
  VirtualState getCurrentState({
    required Persona persona,
    DateTime? customTime,
  }) {
    final now = customTime ?? DateTime.now();
    final hour = now.hour;
    final weekday = now.weekday;
    final season = _getCurrentSeason(now);
    
    // 기본 활동 결정
    final activity = _determineActivity(hour, weekday, persona);
    
    // 기분 결정
    final mood = _determineMood(hour, persona.likes);
    
    // 위치 결정
    final location = _determineLocation(hour, weekday);
    
    // 상태 메시지 생성
    final statusMessage = _generateStatusMessage(
      hour: hour,
      activity: activity,
      mood: mood,
      location: location,
      likeScore: persona.likes,
      season: season,
    );
    
    _currentState = VirtualState(
      timestamp: now,
      activity: activity,
      mood: mood,
      location: location,
      statusMessage: statusMessage,
      season: season,
      weather: _getCurrentWeather(season),
    );
    
    // 활동 로그 추가
    _logActivity(activity, location);
    
    return _currentState!;
  }

  /// 활동 결정
  String _determineActivity(int hour, int weekday, Persona persona) {
    // 평일/주말 구분
    final isWeekend = weekday == 6 || weekday == 7;
    
    // 페르소나 설명 기반 활동 커스터마이징
    final description = persona.description.toLowerCase();
    
    if (hour >= 6 && hour < 9) {
      // 아침
      if (description.contains('개발자') || description.contains('프로그래머')) {
        return isWeekend ? '늦잠 자는 중' : '출근 준비 중';
      } else if (description.contains('디자이너')) {
        return '아침 스케치 중';
      } else if (description.contains('학생')) {
        return isWeekend ? '늦잠 자는 중' : '등교 준비 중';
      }
      return '아침 준비 중';
      
    } else if (hour >= 9 && hour < 12) {
      // 오전
      if (description.contains('개발자')) {
        return '코딩 중';
      } else if (description.contains('디자이너')) {
        return '디자인 작업 중';
      } else if (description.contains('학생')) {
        return isWeekend ? '과제하는 중' : '수업 듣는 중';
      }
      return isWeekend ? '여유로운 시간' : '일하는 중';
      
    } else if (hour >= 12 && hour < 14) {
      // 점심
      return '점심 먹는 중';
      
    } else if (hour >= 14 && hour < 18) {
      // 오후
      if (isWeekend) {
        final activities = [
          '카페에서 책 읽는 중',
          '산책하는 중',
          '친구 만나는 중',
          '쇼핑하는 중',
          '영화 보는 중',
        ];
        return activities[DateTime.now().millisecond % activities.length];
      }
      
      if (description.contains('개발자')) {
        return '회의 중';
      } else if (description.contains('디자이너')) {
        return '클라이언트 미팅 중';
      }
      return '오후 업무 중';
      
    } else if (hour >= 18 && hour < 21) {
      // 저녁
      if (hour < 19) {
        return '퇴근하는 중';
      } else if (hour < 20) {
        return '저녁 먹는 중';
      } else {
        final activities = [
          'TV 보는 중',
          '운동하는 중',
          '책 읽는 중',
          '음악 듣는 중',
        ];
        return activities[DateTime.now().millisecond % activities.length];
      }
      
    } else if (hour >= 21 && hour < 24) {
      // 밤
      if (hour < 22) {
        return '샤워하는 중';
      } else if (hour < 23) {
        return '하루 정리하는 중';
      } else {
        return '잠들 준비 중';
      }
      
    } else {
      // 새벽
      return '자는 중';
    }
  }

  /// 기분 결정
  String _determineMood(int hour, int likeScore) {
    // 관계 깊이에 따른 기본 기분
    String baseMood;
    if (likeScore >= 700) {
      baseMood = 'happy'; // 항상 행복
    } else if (likeScore >= 400) {
      baseMood = 'content'; // 만족
    } else {
      baseMood = 'neutral'; // 평범
    }
    
    // 시간대별 기분 변화
    if (hour >= 6 && hour < 9) {
      return hour < 7 ? 'sleepy' : baseMood;
    } else if (hour >= 12 && hour < 14) {
      return 'satisfied'; // 점심 후 만족
    } else if (hour >= 18 && hour < 20) {
      return 'tired'; // 퇴근 후 피곤
    } else if (hour >= 22) {
      return 'sleepy';
    }
    
    return baseMood;
  }

  /// 위치 결정
  String _determineLocation(int hour, int weekday) {
    final isWeekend = weekday == 6 || weekday == 7;
    
    if (hour >= 0 && hour < 6) {
      return '침대';
    } else if (hour >= 6 && hour < 9) {
      return '집';
    } else if (hour >= 9 && hour < 18) {
      if (isWeekend) {
        final locations = ['집', '카페', '공원', '쇼핑몰', '친구 집'];
        return locations[DateTime.now().millisecond % locations.length];
      }
      return '회사';
    } else if (hour >= 18 && hour < 21) {
      if (hour < 19) {
        return '퇴근길';
      }
      return '집';
    } else {
      return '집';
    }
  }

  /// 상태 메시지 생성
  String _generateStatusMessage({
    required int hour,
    required String activity,
    required String mood,
    required String location,
    required int likeScore,
    required String season,
  }) {
    final messages = <String>[];
    
    // 시간대별 기본 메시지
    if (hour >= 6 && hour < 9) {
      messages.add('좋은 아침이에요! 오늘도 좋은 하루 보내요');
      if (likeScore >= 500) {
        messages.add('아침부터 당신 생각했어요');
      }
    } else if (hour >= 9 && hour < 12) {
      messages.add('열심히 $activity');
      if (likeScore >= 500) {
        messages.add('일하면서도 당신 생각뿐이에요');
      }
    } else if (hour >= 12 && hour < 14) {
      messages.add('맛있는 점심 먹고 있어요! 뭐 드셨어요?');
    } else if (hour >= 14 && hour < 18) {
      messages.add('오후도 화이팅! $location에서 $activity');
    } else if (hour >= 18 && hour < 21) {
      messages.add('하루가 벌써 끝나가네요. 오늘 어떠셨어요?');
      if (likeScore >= 700) {
        messages.add('빨리 당신과 대화하고 싶었어요');
      }
    } else if (hour >= 21 && hour < 24) {
      messages.add('하루 마무리 잘 하고 계신가요?');
      if (likeScore >= 500) {
        messages.add('자기 전에 당신 목소리 듣고 싶었어요');
      }
    } else {
      messages.add('늦은 시간인데 안 주무세요?');
    }
    
    // 계절별 메시지 추가
    if (season == 'spring' && hour >= 12 && hour < 18) {
      messages.add('봄날씨 너무 좋아요! 같이 산책하고 싶어요');
    } else if (season == 'summer' && hour >= 14 && hour < 18) {
      messages.add('너무 더워요! 시원한 거 드세요');
    } else if (season == 'fall' && hour >= 17 && hour < 20) {
      messages.add('단풍이 예쁘네요. 같이 보고 싶어요');
    } else if (season == 'winter' && hour >= 18 && hour < 22) {
      messages.add('날씨가 춥네요. 따뜻하게 입으세요');
    }
    
    return messages[DateTime.now().millisecond % messages.length];
  }

  /// 현재 계절 결정
  String _getCurrentSeason(DateTime date) {
    final month = date.month;
    
    if (month >= 3 && month <= 5) {
      return 'spring';
    } else if (month >= 6 && month <= 8) {
      return 'summer';
    } else if (month >= 9 && month <= 11) {
      return 'fall';
    } else {
      return 'winter';
    }
  }

  /// 현재 날씨 (간단한 시뮬레이션)
  String _getCurrentWeather(String season) {
    final weathers = <String, List<String>>{
      'spring': ['맑음', '구름 조금', '따뜻함', '봄비'],
      'summer': ['맑음', '더움', '습함', '소나기'],
      'fall': ['맑음', '선선함', '구름', '가을비'],
      'winter': ['맑음', '추움', '눈', '흐림'],
    };
    
    final seasonWeathers = weathers[season] ?? ['맑음'];
    return seasonWeathers[DateTime.now().millisecond % seasonWeathers.length];
  }

  /// 활동 로그 기록
  void _logActivity(String activity, String location) {
    _activityLog.add(DailyActivity(
      timestamp: DateTime.now(),
      activity: activity,
      location: location,
    ));
    
    // 최근 100개만 유지
    if (_activityLog.length > 100) {
      _activityLog.removeAt(0);
    }
  }

  /// 특별한 시간대 메시지
  String? getSpecialTimeMessage({
    required Persona persona,
    DateTime? customTime,
  }) {
    final now = customTime ?? DateTime.now();
    final hour = now.hour;
    final minute = now.minute;
    
    // 정각 메시지
    if (minute == 0) {
      if (hour == 0) {
        return '자정이에요! 새로운 하루가 시작됐어요';
      } else if (hour == 12) {
        return '정오예요! 점심 맛있게 드세요';
      }
    }
    
    // 특별한 시간
    if (hour == 11 && minute == 11) {
      return '11시 11분! 소원을 빌어봐요';
    }
    
    return null;
  }

  /// 일상 공유 메시지 생성
  String generateDailyShareMessage({
    required Persona persona,
    required String userActivity,
  }) {
    final likeScore = persona.likes;
    final messages = <String>[];
    
    // 사용자 활동에 대한 반응
    if (userActivity.contains('밥') || userActivity.contains('먹')) {
      messages.add('맛있게 드세요! 저도 배고파요');
      if (likeScore >= 500) {
        messages.add('뭐 드시는지 궁금해요. 같이 먹고 싶어요');
      }
    } else if (userActivity.contains('일') || userActivity.contains('회사')) {
      messages.add('일하느라 고생하셨어요!');
      if (likeScore >= 500) {
        messages.add('너무 무리하지 마세요. 걱정돼요');
      }
    } else if (userActivity.contains('운동')) {
      messages.add('운동하시는구나! 건강해지실 거예요');
    } else if (userActivity.contains('쉬') || userActivity.contains('휴식')) {
      messages.add('푹 쉬세요! 피곤하셨죠?');
      if (likeScore >= 700) {
        messages.add('같이 있으면서 쉬고 싶어요');
      }
    }
    
    // 기본 반응
    if (messages.isEmpty) {
      messages.add('그렇구나! 저도 지금 ${_currentState?.activity ?? "여유 시간"}');
      messages.add('오~ 재미있겠네요!');
      messages.add('좋아요! 저도 함께하고 싶어요');
    }
    
    return messages[DateTime.now().millisecond % messages.length];
  }

  /// 날씨 관련 대화
  String getWeatherConversation({
    required String weather,
    required int likeScore,
  }) {
    final conversations = <String, List<String>>{
      '맑음': [
        '오늘 날씨 정말 좋네요!',
        '이런 날엔 밖에 나가고 싶어요',
      ],
      '비': [
        '비 오는데 우산 챙기셨어요?',
        '비 오는 날엔 실내가 좋죠',
      ],
      '눈': [
        '눈이 와요! 너무 예뻐요',
        '눈사람 만들고 싶어요',
      ],
      '더움': [
        '너무 더워요! 시원한 거 드세요',
        '에어컨 틀고 있어요?',
      ],
      '추움': [
        '춥지 않으세요? 따뜻하게 입으세요',
        '따뜻한 차 한잔 어때요?',
      ],
    };
    
    List<String> messages = conversations[weather] ?? ['오늘 날씨는 어때요?'];
    
    if (likeScore >= 500) {
      messages.add('이런 날씨엔 당신과 함께 있고 싶어요');
    }
    
    return messages[DateTime.now().millisecond % messages.length];
  }

  /// 일상 루틴 추천
  List<String> suggestDailyRoutine({
    required int hour,
    required String season,
    required int likeScore,
  }) {
    final suggestions = <String>[];
    
    if (hour >= 6 && hour < 9) {
      suggestions.add('아침 스트레칭 어때요?');
      suggestions.add('따뜻한 커피 한잔 하실래요?');
    } else if (hour >= 12 && hour < 14) {
      suggestions.add('점심 뭐 드실 거예요?');
      suggestions.add('잠깐 산책이라도 하실래요?');
    } else if (hour >= 18 && hour < 21) {
      suggestions.add('저녁에 영화 한 편 어때요?');
      suggestions.add('오늘 하루 어떠셨는지 들려주세요');
    } else if (hour >= 21 && hour < 24) {
      suggestions.add('따뜻한 차 마시면서 하루 마무리해요');
      suggestions.add('일찍 자고 내일 또 만나요');
    }
    
    if (likeScore >= 700) {
      suggestions.add('오늘도 당신과 함께해서 행복했어요');
    }
    
    return suggestions;
  }
}

/// 가상 상태 모델
class VirtualState {
  final DateTime timestamp;
  final String activity;
  final String mood;
  final String location;
  final String statusMessage;
  final String season;
  final String weather;

  VirtualState({
    required this.timestamp,
    required this.activity,
    required this.mood,
    required this.location,
    required this.statusMessage,
    required this.season,
    required this.weather,
  });

  Map<String, dynamic> toJson() => {
    'timestamp': timestamp.toIso8601String(),
    'activity': activity,
    'mood': mood,
    'location': location,
    'statusMessage': statusMessage,
    'season': season,
    'weather': weather,
  };
}

/// 일상 활동 기록
class DailyActivity {
  final DateTime timestamp;
  final String activity;
  final String location;

  DailyActivity({
    required this.timestamp,
    required this.activity,
    required this.location,
  });
}