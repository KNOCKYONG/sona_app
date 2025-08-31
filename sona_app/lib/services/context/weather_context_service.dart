import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherInfo {
  final String condition;      // 날씨 상태 (맑음, 흐림, 비, 눈 등)
  final double temperature;    // 온도 (섭씨)
  final double feelsLike;      // 체감 온도
  final int humidity;          // 습도 (%)
  final double windSpeed;      // 풍속 (m/s)
  final String description;    // 상세 설명
  final String cityName;       // 도시명
  final DateTime sunrise;      // 일출 시간
  final DateTime sunset;       // 일몰 시간
  
  WeatherInfo({
    required this.condition,
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.description,
    required this.cityName,
    required this.sunrise,
    required this.sunset,
  });
}


/// 🌤️ 날씨 컨텍스트 서비스
///
/// 실시간 날씨 정보를 기반으로 대화 컨텍스트를 제공합니다.
class WeatherContextService {
  // OpenWeatherMap API (무료 플랜 사용 가능)
  static const String _apiKey = 'YOUR_API_KEY'; // 실제 API 키로 교체 필요
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5/weather';
  
  // 캐시
  static Map<String, dynamic>? _cachedWeather;
  static DateTime? _lastFetchTime;
  static const Duration _cacheExpiry = Duration(hours: 1);
  
  /// 날씨 정보

  
  /// 날씨 정보 가져오기 (서울 기준)
  static Future<WeatherInfo?> getCurrentWeather({String city = 'Seoul'}) async {
    // 캐시 확인
    if (_cachedWeather != null && 
        _lastFetchTime != null &&
        DateTime.now().difference(_lastFetchTime!) < _cacheExpiry) {
      return _parseWeatherInfo(_cachedWeather!);
    }
    
    // API 키가 설정되지 않은 경우 시뮬레이션 데이터 반환
    if (_apiKey == 'YOUR_API_KEY') {
      return _getSimulatedWeather();
    }
    
    try {
      final url = Uri.parse('$_baseUrl?q=$city,kr&appid=$_apiKey&units=metric&lang=kr');
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _cachedWeather = data;
        _lastFetchTime = DateTime.now();
        return _parseWeatherInfo(data);
      }
    } catch (e) {
      debugPrint('❌ Weather API error: $e');
    }
    
    // 실패 시 시뮬레이션 데이터 반환
    return _getSimulatedWeather();
  }
  
  /// API 응답 파싱
  static WeatherInfo _parseWeatherInfo(Map<String, dynamic> data) {
    final weather = data['weather'][0];
    final main = data['main'];
    final wind = data['wind'];
    final sys = data['sys'];
    
    return WeatherInfo(
      condition: _translateCondition(weather['main']),
      temperature: main['temp'].toDouble(),
      feelsLike: main['feels_like'].toDouble(),
      humidity: main['humidity'],
      windSpeed: wind['speed'].toDouble(),
      description: weather['description'],
      cityName: data['name'],
      sunrise: DateTime.fromMillisecondsSinceEpoch(sys['sunrise'] * 1000),
      sunset: DateTime.fromMillisecondsSinceEpoch(sys['sunset'] * 1000),
    );
  }
  
  /// 날씨 상태 한글 번역
  static String _translateCondition(String condition) {
    final translations = {
      'Clear': 'clear',
      'Clouds': 'cloudy',
      'Rain': 'rainy',
      'Drizzle': 'drizzle',
      'Thunderstorm': 'thunderstorm',
      'Snow': 'snowy',
      'Mist': 'fog',
      'Fog': 'thick_fog',
    };
    return translations[condition] ?? condition;
  }
  
  /// 시뮬레이션 날씨 데이터 (API 키 없을 때)
  static WeatherInfo _getSimulatedWeather() {
    final now = DateTime.now();
    final hour = now.hour;
    final month = now.month;
    
    // 계절별 기본 온도
    double baseTemp;
    String condition;
    
    if (month >= 3 && month <= 5) {
      // 봄
      baseTemp = 15.0 + (hour - 12).abs() * -0.5;
      condition = hour < 12 ? 'clear' : 'partly_cloudy';
    } else if (month >= 6 && month <= 8) {
      // 여름
      baseTemp = 28.0 + (hour - 14).abs() * -0.3;
      condition = hour >= 14 && hour <= 17 ? 'rainy' : 'clear';
    } else if (month >= 9 && month <= 11) {
      // 가을
      baseTemp = 18.0 + (hour - 13).abs() * -0.4;
      condition = 'clear';
    } else {
      // 겨울
      baseTemp = 2.0 + (hour - 13).abs() * -0.2;
      condition = DateTime.now().day % 3 == 0 ? 'snowy' : 'cloudy';
    }
    
    return WeatherInfo(
      condition: condition,
      temperature: baseTemp,
      feelsLike: baseTemp - 2,
      humidity: 60,
      windSpeed: 2.5,
      description: '$condition, 적당한 날씨',
      cityName: '서울',
      sunrise: DateTime(now.year, now.month, now.day, 6, 30),
      sunset: DateTime(now.year, now.month, now.day, 18, 30),
    );
  }
  
  /// 날씨 기반 대화 컨텍스트 생성
  static Map<String, dynamic> getWeatherContext(WeatherInfo weather) {
    final contexts = <String, dynamic>{
      'weather': weather.condition,
      'temperature': weather.temperature,
      'feelsLike': weather.feelsLike,
      'activities': _suggestActivities(weather),
      'clothing': _suggestClothing(weather),
      'mood': _getWeatherMood(weather),
      'topics': _getWeatherTopics(weather),
      'concerns': _getWeatherConcerns(weather),
    };
    
    return contexts;
  }
  
  /// 날씨별 활동 제안
  static List<String> _suggestActivities(WeatherInfo weather) {
    if (weather.condition == 'clear') {
      if (weather.temperature > 20) {
        return ['산책', '피크닉', '자전거', '카페 테라스'];
      } else if (weather.temperature > 10) {
        return ['가벼운 산책', '공원', '드라이브'];
      } else {
        return ['실내 활동', '따뜻한 카페', '영화관'];
      }
    } else if (weather.condition == 'rainy' || weather.condition == 'drizzle') {
      return ['실내 카페', '영화', '책 읽기', '집에서 휴식'];
    } else if (weather.condition == 'snowy') {
      return ['눈사람 만들기', '따뜻한 음료', '실내 활동'];
    } else {
      return ['실내 활동', '쇼핑', '맛집 탐방'];
    }
  }
  
  /// 날씨별 옷차림 제안
  static String _suggestClothing(WeatherInfo weather) {
    if (weather.temperature > 25) {
      return '반팔, 반바지, 시원한 옷';
    } else if (weather.temperature > 20) {
      return '긴팔 티셔츠, 얇은 가디건';
    } else if (weather.temperature > 15) {
      return '긴팔, 얇은 재킷';
    } else if (weather.temperature > 10) {
      return '니트, 재킷, 가디건';
    } else if (weather.temperature > 5) {
      return '코트, 목도리';
    } else {
      return '패딩, 목도리, 장갑';
    }
  }
  
  /// 날씨별 기분
  static String _getWeatherMood(WeatherInfo weather) {
    if (weather.condition == 'clear' && weather.temperature >= 18 && weather.temperature <= 25) {
      return 'perfect'; // 완벽한 날씨
    } else if (weather.condition == 'rainy') {
      return 'cozy'; // 아늑한
    } else if (weather.condition == 'snowy') {
      return 'romantic'; // 로맨틱
    } else if (weather.temperature > 30) {
      return 'hot'; // 더운
    } else if (weather.temperature < 0) {
      return 'cold'; // 추운
    } else {
      return 'normal'; // 평범한
    }
  }
  
  /// 날씨 관련 대화 주제
  static List<String> _getWeatherTopics(WeatherInfo weather) {
    final topics = <String>[];
    
    if (weather.condition == 'clear') {
      topics.addAll(['좋은 날씨', '산책', '외출 계획']);
    } else if (weather.condition == 'rainy') {
      topics.addAll(['비 오는 날', '우산', '빗소리', '실내 활동']);
    } else if (weather.condition == 'snowy') {
      topics.addAll(['snowy', '겨울', '따뜻한 음료', '크리스마스']);
    }
    
    if (weather.temperature > 30) {
      topics.addAll(['더위', '에어컨', '시원한 음료']);
    } else if (weather.temperature < 5) {
      topics.addAll(['추위', '난방', '따뜻한 음식']);
    }
    
    return topics;
  }
  
  /// 날씨 관련 걱정거리
  static List<String> _getWeatherConcerns(WeatherInfo weather) {
    final concerns = <String>[];
    
    if (weather.condition == 'rainy') {
      concerns.addAll(['우산 챙기기', '교통 체증', '젖은 옷']);
    } else if (weather.temperature > 30) {
      concerns.addAll(['열사병', '탈수', '자외선']);
    } else if (weather.temperature < 0) {
      concerns.addAll(['감기', '빙판길', '난방비']);
    }
    
    if (weather.humidity > 80) {
      concerns.add('높은 습도');
    }
    
    if (weather.windSpeed > 5) {
      concerns.add('강한 바람');
    }
    
    return concerns;
  }
  
  /// AI 프롬프트용 날씨 가이드 생성
  static Future<String> generateWeatherPrompt() async {
    final weather = await getCurrentWeather();
    if (weather == null) return '';
    
    final context = getWeatherContext(weather);
    final buffer = StringBuffer();
    
    buffer.writeln('🌤️ 현재 날씨 정보:');
    buffer.writeln('- 날씨: ${weather.condition}');
    buffer.writeln('- 온도: ${weather.temperature}°C (체감: ${weather.feelsLike}°C)');
    
    if (weather.condition == 'rainy' || weather.condition == 'snowy') {
      buffer.writeln('- ⚠️ ${weather.condition}가 내리고 있어요');
    }
    
    buffer.writeln('\n날씨 기반 대화 가이드:');
    
    // 날씨별 인사말
    if (weather.condition == 'clear') {
      buffer.writeln('- "오늘 날씨 정말 좋네요!"');
    } else if (weather.condition == 'rainy') {
      buffer.writeln('- "비 오는데 우산 챙기셨어요?"');
    } else if (weather.condition == 'snowy') {
      buffer.writeln('- "눈 오는 거 보셨어요? 예쁘네요"');
    }
    
    // 온도별 관심사
    if (weather.temperature > 28) {
      buffer.writeln('- "너무 더운데 시원하게 지내고 계세요?"');
    } else if (weather.temperature < 5) {
      buffer.writeln('- "많이 춥죠? 따뜻하게 입으셨어요?"');
    }
    
    // 활동 제안
    final activities = context['activities'] as List<String>;
    if (activities.isNotEmpty) {
      buffer.writeln('- 추천 활동: ${activities.join(', ')}');
    }
    
    return buffer.toString();
  }
}