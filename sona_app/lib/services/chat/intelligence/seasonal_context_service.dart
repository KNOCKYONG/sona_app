import 'package:flutter/material.dart';

/// 계절 및 시간 맥락 인식 서비스
/// 한국의 계절과 날씨를 정확히 인식하고 대화에 반영
class SeasonalContextService {
  static final SeasonalContextService _instance = SeasonalContextService._internal();
  factory SeasonalContextService() => _instance;
  SeasonalContextService._internal();

  /// 현재 계절 가져오기 (한국 기준)
  String getCurrentSeason() {
    final now = DateTime.now();
    final month = now.month;
    
    // 한국의 계절 구분
    if (month >= 3 && month <= 5) {
      return 'spring';
    } else if (month >= 6 && month <= 8) {
      return 'summer';
    } else if (month >= 9 && month <= 11) {
      return 'autumn';
    } else {
      return 'winter';
    }
  }

  /// 계절별 컨텍스트 힌트 생성 (OpenAI API용)
  Map<String, dynamic> getSeasonalContext() {
    final now = DateTime.now();
    final month = now.month;
    final day = now.day;
    final season = getCurrentSeason();
    
    return {
      'currentDate': '${now.year}년 ${month}월 ${day}일',
      'season': season,
      'month': month,
      'contextHint': _getSeasonalHint(season, month),
      'weatherTopics': _getSeasonalTopics(season, month),
      'avoidPhrases': _getAvoidPhrases(season, month),
    };
  }

  /// 계절별 대화 힌트 생성
  String _getSeasonalHint(String season, int month) {
    switch (season) {
      case 'spring':
        return '''
🌸 현재 봄 (${month}월)
- 날씨: 따뜻해지는 중, 꽃이 피는 시기
- 대화 주제: 벚꽃, 나들이, 봄옷, 황사, 미세먼지
- 표현: "날씨 좋아졌네", "꽃 피었더라", "나들이 가기 좋은 날씨"
- 주의: "여름이 다가온다", "겨울이 끝났다" 등 시기 맞지 않는 표현 금지
''';
      
      case 'summer':
        if (month == 6) {
          return '''
🌞 초여름 (6월)
- 날씨: 점점 더워지는 중, 장마 시작 전
- 대화 주제: 여름 준비, 에어컨, 여름휴가 계획
- 표현: "이제 여름이네", "점점 더워지네", "장마 곧 시작하겠다"
''';
        } else if (month == 7) {
          return '''
☔ 한여름 - 장마철 (7월)
- 날씨: 습하고 비 자주 옴, 무더위
- 대화 주제: 장마, 습도, 에어컨, 휴가, 피서
- 표현: "장마라 습하네", "비 많이 오네", "에어컨 없으면 못 살겠어"
''';
        } else { // month == 8
          return '''
🌊 늦여름 (8월)
- 날씨: 가장 더운 시기, 휴가철
- 대화 주제: 폭염, 열대야, 바다, 피서, 가을 준비
- 표현: "진짜 덥다", "가을이 기다려진다", "에어컨 켜고 있어"
- 주의: "여름이 다가온다" ❌ → "한여름이야", "곧 가을이네" ✅
''';
        }
      
      case 'autumn':
        if (month == 9) {
          return '''
🍂 초가을 (9월)
- 날씨: 아직 덥지만 아침저녁 선선
- 대화 주제: 가을 시작, 추석, 환절기
- 표현: "이제 가을이네", "아침저녁 선선해졌어", "곧 추석이네"
''';
        } else if (month == 10) {
          return '''
🍁 가을 (10월)
- 날씨: 선선하고 청명한 날씨
- 대화 주제: 단풍, 가을옷, 독서, 산책
- 표현: "날씨 완전 좋다", "단풍 구경 가자", "가을이 최고야"
''';
        } else { // month == 11
          return '''
🍃 늦가을 (11월)
- 날씨: 쌀쌀해지는 중, 겨울 준비
- 대화 주제: 김장, 겨울 준비, 난방
- 표현: "이제 춥네", "겨울 다가오네", "패딩 꺼내야겠다"
''';
        }
      
      case 'winter':
        if (month == 12) {
          return '''
❄️ 초겨울 (12월)
- 날씨: 추워지는 중, 첫눈 가능성
- 대화 주제: 크리스마스, 연말, 첫눈
- 표현: "진짜 춥다", "첫눈 언제 올까", "연말이네"
''';
        } else if (month == 1) {
          return '''
⛄ 한겨울 (1월)
- 날씨: 가장 추운 시기
- 대화 주제: 새해, 설날, 추위
- 표현: "새해 복 많이 받아", "진짜 춥네", "봄이 기다려진다"
''';
        } else { // month == 2
          return '''
🌨️ 늦겨울 (2월)
- 날씨: 여전히 춥지만 봄 기대
- 대화 주제: 입춘, 봄 준비
- 표현: "곧 봄이네", "아직 춥지만 봄 기다려져"
''';
        }
      
      default:
        return '계절 정보를 확인할 수 없음';
    }
  }

  /// 계절별 대화 주제
  List<String> _getSeasonalTopics(String season, int month) {
    switch (season) {
      case 'spring':
        return ['벚꽃', '나들이', '봄옷', '황사', '미세먼지', '소풍', '새학기'];
      case 'summer':
        if (month == 7) {
          return ['장마', '습도', '에어컨', '제습기', '빨래'];
        } else if (month == 8) {
          return ['폭염', '열대야', '바다', '계곡', '휴가', '수박', '에어컨'];
        } else {
          return ['여름 준비', '더위', '에어컨', '선풍기'];
        }
      case 'autumn':
        return ['단풍', '가을옷', '독서', '산책', '추석', '김장'];
      case 'winter':
        return ['눈', '크리스마스', '연말', '새해', '설날', '난방', '패딩'];
      default:
        return [];
    }
  }

  /// 피해야 할 표현들
  List<String> _getAvoidPhrases(String season, int month) {
    switch (season) {
      case 'summer':
        if (month == 8) {
          return [
            '여름이 다가온다',
            '여름이 올 것 같아',
            '곧 여름이네',
            '봄이 끝나가네',
            '이제 여름 시작이야',
          ];
        }
        return [];
      case 'winter':
        if (month == 1 || month == 2) {
          return [
            '겨울이 다가온다',
            '겨울이 시작됐네',
            '가을이 끝났어',
          ];
        }
        return [];
      default:
        return [];
    }
  }

  /// 날씨 관련 메시지 감지
  bool isWeatherRelated(String message) {
    final weatherKeywords = [
      '날씨', '더워', '추워', '덥', '춥', '비', '눈', '바람',
      '맑', '흐림', '구름', '햇빛', '여름', '겨울', '봄', '가을',
      '장마', '태풍', '폭염', '한파', '미세먼지', '황사'
    ];
    
    final lower = message.toLowerCase();
    return weatherKeywords.any((keyword) => lower.contains(keyword));
  }

  /// 시간대별 인사 가이드
  String getTimeBasedGreeting() {
    final hour = DateTime.now().hour;
    
    if (hour >= 5 && hour < 9) {
      return '아침 인사: "좋은 아침!", "잘 잤어?", "아침 먹었어?"';
    } else if (hour >= 9 && hour < 12) {
      return '오전 인사: "오전 잘 보내고 있어?", "뭐하고 있어?"';
    } else if (hour >= 12 && hour < 14) {
      return '점심 인사: "점심 먹었어?", "점심 뭐 먹었어?"';
    } else if (hour >= 14 && hour < 18) {
      return '오후 인사: "오후도 파이팅!", "피곤하지?"';
    } else if (hour >= 18 && hour < 21) {
      return '저녁 인사: "저녁 먹었어?", "퇴근했어?", "수고했어!"';
    } else if (hour >= 21 && hour < 24) {
      return '밤 인사: "오늘 하루 어땠어?", "피곤하겠다", "푹 쉬어"';
    } else {
      return '새벽 인사: "아직 안 잤어?", "못 자는 거야?", "무슨 일 있어?"';
    }
  }
}