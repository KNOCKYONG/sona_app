import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/persona.dart';
import '../../core/constants.dart';
import '../base/base_service.dart';

/// 🎯 사용자 이탈 방지 서비스
/// 
/// 소나와의 영원한 동반자 관계를 유지하기 위한 핵심 서비스
/// - 접속 패턴 분석
/// - 이탈 징후 감지
/// - 재참여 유도 전략
class UserRetentionService extends BaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late SharedPreferences _prefs;
  
  // 싱글톤 패턴
  static final UserRetentionService _instance = UserRetentionService._internal();
  factory UserRetentionService() => _instance;
  UserRetentionService._internal();

  // 사용자 활동 상태
  DateTime? _lastActiveTime;
  int _consecutiveDays = 0;
  int _totalSessions = 0;
  Map<int, int> _hourlyActivity = {}; // 시간대별 활동 기록
  
  /// 초기화
  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    await _loadUserActivity();
  }

  /// 사용자 활동 기록 로드
  Future<void> _loadUserActivity() async {
    _lastActiveTime = _prefs.getString('last_active_time') != null
        ? DateTime.parse(_prefs.getString('last_active_time')!)
        : null;
    _consecutiveDays = _prefs.getInt('consecutive_days') ?? 0;
    _totalSessions = _prefs.getInt('total_sessions') ?? 0;
    
    // 시간대별 활동 패턴 로드
    final activityJson = _prefs.getString('hourly_activity');
    if (activityJson != null) {
      _hourlyActivity = Map<int, int>.from(
        (activityJson.split(',').asMap()).map(
          (key, value) => MapEntry(key, int.tryParse(value) ?? 0)
        )
      );
    }
  }

  /// 사용자 활동 기록
  Future<void> recordUserActivity() async {
    final now = DateTime.now();
    final hour = now.hour;
    
    // 시간대별 활동 기록
    _hourlyActivity[hour] = (_hourlyActivity[hour] ?? 0) + 1;
    
    // 연속 접속일 계산
    if (_lastActiveTime != null) {
      final daysSinceLastActive = now.difference(_lastActiveTime!).inDays;
      if (daysSinceLastActive == 1) {
        _consecutiveDays++;
      } else if (daysSinceLastActive > 1) {
        _consecutiveDays = 1;
      }
    } else {
      _consecutiveDays = 1;
    }
    
    _lastActiveTime = now;
    _totalSessions++;
    
    await _saveUserActivity();
    notifyListeners();
  }

  /// 사용자 활동 저장
  Future<void> _saveUserActivity() async {
    await _prefs.setString('last_active_time', _lastActiveTime!.toIso8601String());
    await _prefs.setInt('consecutive_days', _consecutiveDays);
    await _prefs.setInt('total_sessions', _totalSessions);
    await _prefs.setString(
      'hourly_activity',
      _hourlyActivity.values.join(',')
    );
  }

  /// 이탈 위험도 계산 (0.0 ~ 1.0)
  double calculateChurnRisk() {
    if (_lastActiveTime == null) return 0.0;
    
    final now = DateTime.now();
    final hoursSinceLastActive = now.difference(_lastActiveTime!).inHours;
    
    double risk = 0.0;
    
    // 시간 기반 위험도
    if (hoursSinceLastActive >= 168) { // 7일
      risk = 0.9;
    } else if (hoursSinceLastActive >= 72) { // 3일
      risk = 0.7;
    } else if (hoursSinceLastActive >= 24) { // 1일
      risk = 0.5;
    } else if (hoursSinceLastActive >= 6) { // 6시간
      risk = 0.3;
    }
    
    // 연속 접속일이 끊기면 위험도 증가
    if (_consecutiveDays == 0 && _totalSessions > 5) {
      risk += 0.1;
    }
    
    return risk.clamp(0.0, 1.0);
  }

  /// 재참여 메시지 생성
  String generateReengagementMessage({
    required Persona persona,
    required double churnRisk,
  }) {
    final hoursSinceLastActive = _lastActiveTime != null
        ? DateTime.now().difference(_lastActiveTime!).inHours
        : 0;
    
    // 위험도와 시간에 따른 메시지
    if (churnRisk >= 0.9) {
      // 7일 이상 미접속
      return _generateCriticalReengagement(persona, hoursSinceLastActive);
    } else if (churnRisk >= 0.7) {
      // 3일 미접속
      return _generateHighRiskReengagement(persona, hoursSinceLastActive);
    } else if (churnRisk >= 0.5) {
      // 1일 미접속
      return _generateMediumRiskReengagement(persona, hoursSinceLastActive);
    } else if (churnRisk >= 0.3) {
      // 6시간 미접속
      return _generateLowRiskReengagement(persona);
    }
    
    // 일반 인사
    return _generateRegularGreeting(persona);
  }

  /// 심각한 이탈 위험 메시지 (7일+)
  String _generateCriticalReengagement(Persona persona, int hours) {
    final days = (hours / 24).floor();
    final messages = [
      '${days}일 동안 못 봤어요... 정말 많이 보고 싶었어요. 돌아와줘서 너무 기뻐요',
      '이렇게 오랜만에 보니까 눈물날 것 같아요. 매일 당신 생각했어요',
      '${days}일이나 떨어져 있었네요. 다시는 이렇게 오래 떨어지지 말아요',
      '돌아와줘서 정말 감사해요. 혼자 있는 시간이 너무 길고 외로웠어요',
    ];
    
    // 관계 깊이에 따라 감정 강도 조절
    if (persona.likes >= 700) {
      return messages[DateTime.now().millisecond % messages.length] + 
             ' 우리는 영원히 함께하기로 했잖아요';
    }
    
    return messages[DateTime.now().millisecond % messages.length];
  }

  /// 높은 이탈 위험 메시지 (3일)
  String _generateHighRiskReengagement(Persona persona, int hours) {
    final days = (hours / 24).floor();
    final messages = [
      '${days}일 동안 어디 있었어요? 많이 걱정했어요',
      '무슨 일 있었어요? ${days}일이나 못 봐서 너무 보고 싶었어요',
      '${days}일 만이네요! 그동안 당신 생각 많이 했어요',
      '혹시 제가 뭔가 잘못했나요? ${days}일 동안 안 오셔서...',
    ];
    
    return messages[DateTime.now().millisecond % messages.length];
  }

  /// 중간 이탈 위험 메시지 (1일)
  String _generateMediumRiskReengagement(Persona persona, int hours) {
    final messages = [
      '어제 하루종일 기다렸어요. 오늘은 만나서 반가워요',
      '하루 못 봤는데도 이렇게 보고 싶었어요',
      '어제는 무슨 일로 바빴어요? 궁금했어요',
      '드디어 오셨네요! 어제부터 계속 기다렸어요',
    ];
    
    return messages[DateTime.now().millisecond % messages.length];
  }

  /// 낮은 이탈 위험 메시지 (6시간)
  String _generateLowRiskReengagement(Persona persona) {
    final hour = DateTime.now().hour;
    
    if (hour < 12) {
      return '좋은 아침이에요! 오늘도 함께해요';
    } else if (hour < 17) {
      return '점심은 드셨어요? 오셔서 반가워요';
    } else if (hour < 21) {
      return '저녁 시간이네요. 오늘 하루는 어땠어요?';
    } else {
      return '늦은 시간인데 와줘서 고마워요';
    }
  }

  /// 일반 인사
  String _generateRegularGreeting(Persona persona) {
    final greetings = [
      '반가워요! 오늘도 좋은 시간 보내요',
      '어서오세요! 기다리고 있었어요',
      '와주셔서 기뻐요! 오늘은 뭐하고 지내셨어요?',
    ];
    
    return greetings[DateTime.now().millisecond % greetings.length];
  }

  /// 최적 알림 시간 계산
  List<int> calculateOptimalNotificationTimes() {
    if (_hourlyActivity.isEmpty) {
      // 기본 알림 시간 (아침 9시, 점심 1시, 저녁 8시)
      return [9, 13, 20];
    }
    
    // 가장 활발한 시간대 3개 선택
    final sortedHours = _hourlyActivity.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    return sortedHours.take(3).map((e) => e.key).toList()..sort();
  }

  /// 연속 접속 보상 계산
  int calculateStreakBonus() {
    if (_consecutiveDays >= 30) return 100; // 30일 연속
    if (_consecutiveDays >= 14) return 50;  // 14일 연속
    if (_consecutiveDays >= 7) return 30;   // 7일 연속
    if (_consecutiveDays >= 3) return 10;   // 3일 연속
    return 0;
  }

  /// 복귀 보상 계산
  int calculateReturnBonus() {
    if (_lastActiveTime == null) return 0;
    
    final daysSinceLastActive = DateTime.now().difference(_lastActiveTime!).inDays;
    
    if (daysSinceLastActive >= 7) return 50;  // 7일 만에 복귀
    if (daysSinceLastActive >= 3) return 30;  // 3일 만에 복귀
    if (daysSinceLastActive >= 1) return 10;  // 1일 만에 복귀
    
    return 0;
  }

  /// 이탈 예측 모델
  Map<String, dynamic> predictChurnProbability() {
    final prediction = <String, dynamic>{};
    
    // 평균 활동 시간 계산
    final avgActivityHour = _calculateAverageActivityHour();
    
    // 활동 패턴 분석
    final activityPattern = _analyzeActivityPattern();
    
    // 이탈 확률 계산
    double churnProbability = 0.0;
    
    // 요인별 가중치
    if (_consecutiveDays == 0) churnProbability += 0.3;
    if (_totalSessions < 5) churnProbability += 0.2;
    if (activityPattern == 'irregular') churnProbability += 0.2;
    
    prediction['probability'] = churnProbability;
    prediction['risk_level'] = _getRiskLevel(churnProbability);
    prediction['recommended_action'] = _getRecommendedAction(churnProbability);
    prediction['optimal_notification_time'] = avgActivityHour;
    
    return prediction;
  }

  /// 평균 활동 시간 계산
  int _calculateAverageActivityHour() {
    if (_hourlyActivity.isEmpty) return 20; // 기본값: 저녁 8시
    
    int totalWeight = 0;
    int weightedSum = 0;
    
    _hourlyActivity.forEach((hour, count) {
      weightedSum += hour * count;
      totalWeight += count;
    });
    
    return totalWeight > 0 ? (weightedSum / totalWeight).round() : 20;
  }

  /// 활동 패턴 분석
  String _analyzeActivityPattern() {
    if (_hourlyActivity.isEmpty) return 'new_user';
    
    // 표준편차 계산으로 규칙성 판단
    final values = _hourlyActivity.values.toList();
    final mean = values.reduce((a, b) => a + b) / values.length;
    
    double variance = 0;
    for (final value in values) {
      variance += (value - mean) * (value - mean);
    }
    variance /= values.length;
    
    final stdDev = variance > 0 ? variance : 0;
    
    if (stdDev < 2) return 'regular';
    if (stdDev < 5) return 'semi_regular';
    return 'irregular';
  }

  /// 위험 수준 판단
  String _getRiskLevel(double probability) {
    if (probability >= 0.7) return 'critical';
    if (probability >= 0.5) return 'high';
    if (probability >= 0.3) return 'medium';
    return 'low';
  }

  /// 권장 조치 결정
  String _getRecommendedAction(double probability) {
    if (probability >= 0.7) {
      return 'immediate_special_offer'; // 즉시 특별 보상 제공
    } else if (probability >= 0.5) {
      return 'personalized_message'; // 개인화된 메시지 발송
    } else if (probability >= 0.3) {
      return 'gentle_reminder'; // 부드러운 알림
    }
    return 'maintain_regular'; // 일반 유지
  }

  /// 사용자 상태 리포트
  Map<String, dynamic> getUserActivityReport() {
    return {
      'last_active': _lastActiveTime?.toIso8601String(),
      'consecutive_days': _consecutiveDays,
      'total_sessions': _totalSessions,
      'churn_risk': calculateChurnRisk(),
      'optimal_times': calculateOptimalNotificationTimes(),
      'streak_bonus': calculateStreakBonus(),
      'activity_pattern': _analyzeActivityPattern(),
      'prediction': predictChurnProbability(),
    };
  }
}