import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/persona.dart';

/// 🔍 품질 로깅 서비스
///
/// 모든 상담 세션의 품질 메트릭을 Firebase에 저장하여
/// 관리자 대시보드에서 실시간 모니터링할 수 있도록 함
class QualityLoggingService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// 상담 품질 메트릭 로깅
  static Future<void> logConsultationQuality({
    required String userId,
    required Persona persona,
    required String userMessage,
    required String aiResponse,
    required Map<String, dynamic> qualityMetrics,
    required bool isCrisisResponse,
    required bool requiresHumanReview,
  }) async {
    try {
      final logData = {
        // 기본 정보
        'timestamp': DateTime.now().toIso8601String(),
        'user_id': userId,
        'persona_id': persona.id,
        'persona_type': 'normal',
        'persona_name': persona.name,

        // 메시지 정보 (개인정보 보호를 위해 일부만)
        'user_message_length': userMessage.length,
        'user_message_preview': _sanitizeMessageForLogging(userMessage),
        'ai_response_length': aiResponse.length,
        'ai_response_preview': _sanitizeMessageForLogging(aiResponse),

        // 품질 메트릭
        'response_quality_score':
            qualityMetrics['response_quality_score'] ?? 0.0,
        'specificity_score': qualityMetrics['specificity_score'] ?? 0.0,
        'professional_tone_score':
            qualityMetrics['professional_tone_score'] ?? 0.0,
        'actionability_score': qualityMetrics['actionability_score'] ?? 0.0,

        // 상태 플래그
        'is_crisis_response': isCrisisResponse,
        'requires_human_review': requiresHumanReview,
        'is_paid_consultation': false,

        // 추가 컨텍스트
        'platform': kIsWeb ? 'web' : 'mobile',
        'session_type':
            userId.startsWith('tutorial') ? 'tutorial' : 'production',
      };

      // 로그를 Firebase에 저장
      await _firestore.collection('consultation_quality_logs').add(logData);

      // 낮은 품질의 응답인 경우 별도 알림 로그 생성
      if (qualityMetrics['response_quality_score'] < 0.6 ||
          requiresHumanReview) {
        await _logQualityAlert(logData, qualityMetrics);
      }

      debugPrint('✅ Quality metrics logged successfully');
    } catch (e) {
      // 로깅 실패가 사용자 경험에 영향을 주지 않도록 에러만 기록
      debugPrint('❌ Error logging quality metrics: $e');
    }
  }

  /// 위기 상황 감지 로깅
  static Future<void> logCrisisDetection({
    required String userId,
    required Persona persona,
    required String userMessage,
    required String crisisType,
    required String responseGiven,
  }) async {
    try {
      final logData = {
        'timestamp': DateTime.now().toIso8601String(),
        'user_id': userId,
        'persona_id': persona.id,
        'persona_name': persona.name,
        'crisis_type': crisisType,
        'user_message_preview': _sanitizeMessageForLogging(userMessage),
        'crisis_response_given': responseGiven,
        'requires_immediate_attention': true,
        'platform': kIsWeb ? 'web' : 'mobile',
      };

      // 위기 상황 전용 컬렉션에 저장
      await _firestore.collection('crisis_detection_logs').add(logData);

      debugPrint('🚨 Crisis detection logged successfully');
    } catch (e) {
      debugPrint('❌ Error logging crisis detection: $e');
    }
  }

  /// 품질 알림 로깅
  static Future<void> _logQualityAlert(
    Map<String, dynamic> originalLog,
    Map<String, dynamic> qualityMetrics,
  ) async {
    try {
      final alertData = {
        ...originalLog,
        'alert_type': 'low_quality_response',
        'alert_severity': _calculateAlertSeverity(qualityMetrics),
        'alert_reason': _generateAlertReason(qualityMetrics),
        'needs_immediate_review':
            qualityMetrics['response_quality_score'] < 0.4,
      };

      await _firestore.collection('quality_alerts').add(alertData);

      debugPrint('⚠️ Quality alert logged');
    } catch (e) {
      debugPrint('❌ Error logging quality alert: $e');
    }
  }

  /// 페르소나별 품질 통계 업데이트
  static Future<void> updatePersonaQualityStats({
    required String personaId,
    required String personaType,
    required double qualityScore,
    required bool isCrisisResponse,
  }) async {
    try {
      final statsRef =
          _firestore.collection('persona_quality_stats').doc(personaId);

      await _firestore.runTransaction((transaction) async {
        final doc = await transaction.get(statsRef);

        if (doc.exists) {
          final data = doc.data()!;
          final currentCount = data['total_responses'] as int;
          final currentQualitySum = data['quality_sum'] as double;
          final currentCrisisCount = data['crisis_responses'] as int;

          final newCount = currentCount + 1;
          final newQualitySum = currentQualitySum + qualityScore;
          final newCrisisCount =
              isCrisisResponse ? currentCrisisCount + 1 : currentCrisisCount;

          transaction.update(statsRef, {
            'total_responses': newCount,
            'quality_sum': newQualitySum,
            'average_quality': newQualitySum / newCount,
            'crisis_responses': newCrisisCount,
            'last_updated': DateTime.now().toIso8601String(),
          });
        } else {
          transaction.set(statsRef, {
            'persona_id': personaId,
            'persona_type': personaType,
            'total_responses': 1,
            'quality_sum': qualityScore,
            'average_quality': qualityScore,
            'crisis_responses': isCrisisResponse ? 1 : 0,
            'created_at': DateTime.now().toIso8601String(),
            'last_updated': DateTime.now().toIso8601String(),
          });
        }
      });

      debugPrint('📊 Persona quality stats updated for $personaId');
    } catch (e) {
      debugPrint('❌ Error updating persona quality stats: $e');
    }
  }

  /// 품질 트렌드 분석을 위한 일별 통계 업데이트
  static Future<void> updateDailyQualityStats({
    required double qualityScore,
    required String personaType,
    required bool isCrisisResponse,
  }) async {
    try {
      final today = DateTime.now();
      final dateKey =
          '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

      final dailyStatsRef =
          _firestore.collection('daily_quality_stats').doc(dateKey);

      await _firestore.runTransaction((transaction) async {
        final doc = await transaction.get(dailyStatsRef);

        if (doc.exists) {
          final data = doc.data()!;
          final responses = Map<String, dynamic>.from(data['responses'] ?? {});

          if (!responses.containsKey(personaType)) {
            responses[personaType] = {
              'count': 0,
              'quality_sum': 0.0,
              'crisis_count': 0,
            };
          }

          responses[personaType]['count'] += 1;
          responses[personaType]['quality_sum'] += qualityScore;
          if (isCrisisResponse) {
            responses[personaType]['crisis_count'] += 1;
          }

          transaction.update(dailyStatsRef, {
            'responses': responses,
            'total_responses': (data['total_responses'] as int) + 1,
            'last_updated': DateTime.now().toIso8601String(),
          });
        } else {
          transaction.set(dailyStatsRef, {
            'date': dateKey,
            'responses': {
              personaType: {
                'count': 1,
                'quality_sum': qualityScore,
                'crisis_count': isCrisisResponse ? 1 : 0,
              }
            },
            'total_responses': 1,
            'created_at': DateTime.now().toIso8601String(),
            'last_updated': DateTime.now().toIso8601String(),
          });
        }
      });

      debugPrint('📈 Daily quality stats updated');
    } catch (e) {
      debugPrint('❌ Error updating daily quality stats: $e');
    }
  }

  /// 개인정보 보호를 위한 메시지 sanitization
  static String _sanitizeMessageForLogging(String message) {
    // 메시지가 너무 길면 앞부분만 저장
    if (message.length > 100) {
      message = message.substring(0, 100) + '...';
    }

    // 개인정보가 포함될 수 있는 패턴 제거
    final patterns = [
      r'\d{3}-\d{4}-\d{4}', // 전화번호
      r'\d{6}-\d{7}', // 주민등록번호 일부
      r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}', // 이메일
      r'\d{4}-\d{4}-\d{4}-\d{4}', // 카드번호
    ];

    String sanitized = message;
    for (final pattern in patterns) {
      sanitized = sanitized.replaceAll(RegExp(pattern), '[REDACTED]');
    }

    return sanitized;
  }

  /// 알림 심각도 계산
  static String _calculateAlertSeverity(Map<String, dynamic> qualityMetrics) {
    final qualityScore = qualityMetrics['response_quality_score'] as double;

    if (qualityScore < 0.3) return 'critical';
    if (qualityScore < 0.5) return 'high';
    if (qualityScore < 0.7) return 'medium';
    return 'low';
  }

  /// 알림 사유 생성
  static String _generateAlertReason(Map<String, dynamic> qualityMetrics) {
    final List<String> reasons = [];

    final qualityScore = qualityMetrics['response_quality_score'] as double;
    final professionalScore =
        qualityMetrics['professional_tone_score'] as double;
    final specificityScore = qualityMetrics['specificity_score'] as double;
    final actionabilityScore = qualityMetrics['actionability_score'] as double;

    if (qualityScore < 0.6) {
      reasons.add('전체 품질 점수 낮음 (${(qualityScore * 100).toStringAsFixed(1)}%)');
    }

    if (professionalScore < 0.6) {
      reasons.add('전문성 부족 (${(professionalScore * 100).toStringAsFixed(1)}%)');
    }

    if (specificityScore < 0.6) {
      reasons.add('구체성 부족 (${(specificityScore * 100).toStringAsFixed(1)}%)');
    }

    if (actionabilityScore < 0.6) {
      reasons
          .add('실행가능성 부족 (${(actionabilityScore * 100).toStringAsFixed(1)}%)');
    }

    return reasons.join(', ');
  }

  /// 품질 로그 데이터 정리 (일정 기간 후 자동 삭제)
  static Future<void> cleanupOldLogs() async {
    try {
      final cutoffDate = DateTime.now().subtract(const Duration(days: 30));

      final oldLogsQuery = await _firestore
          .collection('consultation_quality_logs')
          .where('timestamp', isLessThan: cutoffDate.toIso8601String())
          .limit(100)
          .get();

      final batch = _firestore.batch();
      for (final doc in oldLogsQuery.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
      debugPrint('🗑️ Cleaned up ${oldLogsQuery.docs.length} old quality logs');
    } catch (e) {
      debugPrint('❌ Error cleaning up old logs: $e');
    }
  }
}
