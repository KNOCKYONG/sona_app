import 'dart:async';
import 'package:flutter/material.dart';
import '../../models/persona.dart';
import '../../models/message.dart';

/// 채팅 에러 복구 서비스
/// 특정 페르소나의 반복적인 에러를 감지하고 복구 전략 제공
class ErrorRecoveryService {
  static ErrorRecoveryService? _instance;
  static ErrorRecoveryService get instance =>
      _instance ??= ErrorRecoveryService._();

  ErrorRecoveryService._() {
    // 5분마다 오래된 해시 정리
    _cleanupTimer = Timer.periodic(const Duration(minutes: 5), (_) {
      _cleanupOldHashes();
    });
  }

  // 페르소나별 에러 카운트 추적
  final Map<String, _ErrorTracker> _errorTrackers = {};

  // 최근 리포트된 에러 해시 (30분간 유지)
  final Set<String> _recentErrorHashes = {};
  final Map<String, DateTime> _hashTimestamps = {};
  Timer? _cleanupTimer;

  /// 에러 발생 추적
  void trackError({
    required String personaId,
    required String errorType,
    required String errorMessage,
  }) {
    final tracker = _errorTrackers[personaId] ??= _ErrorTracker();
    tracker.addError(errorType, errorMessage);

    debugPrint(
        '📊 Error tracked for persona $personaId: $errorType (total: ${tracker.totalErrors})');
  }

  /// 복구 전략 가져오기
  RecoveryStrategy? getRecoveryStrategy(String personaId) {
    final tracker = _errorTrackers[personaId];
    if (tracker == null || tracker.totalErrors < 3) {
      return null; // 3회 미만은 복구 전략 불필요
    }

    // 에러 패턴 분석
    final mostCommonError = tracker.getMostCommonError();

    switch (mostCommonError) {
      case 'timeout':
        return RecoveryStrategy(
          type: RecoveryType.simplifyPrompt,
          message: '응답 시간이 초과되었습니다. 더 간단한 질문으로 시도해보세요.',
          actions: [
            '짧은 문장으로 질문하기',
            '한 번에 하나의 주제만 다루기',
            '복잡한 요청 피하기',
          ],
        );

      case 'rate_limit':
        return RecoveryStrategy(
          type: RecoveryType.cooldown,
          message: '잠시 후 다시 시도해주세요.',
          actions: [
            '1-2분 후 재시도',
            '메시지 간격 늘리기',
          ],
        );

      case 'api_key_error':
      case 'auth_error':
        return RecoveryStrategy(
          type: RecoveryType.systemError,
          message: '시스템 오류가 발생했습니다. 관리자에게 문의해주세요.',
          actions: [
            '앱 재시작 시도',
            '인터넷 연결 확인',
          ],
        );

      case 'server_error':
        return RecoveryStrategy(
          type: RecoveryType.retry,
          message: '서버에 일시적인 문제가 있습니다.',
          actions: [
            '잠시 후 재시도',
            '다른 페르소나와 대화해보기',
          ],
        );

      default:
        return RecoveryStrategy(
          type: RecoveryType.generic,
          message: '대화 중 오류가 발생했습니다.',
          actions: [
            '메시지를 다시 보내보기',
            '앱을 재시작해보기',
            '인터넷 연결 확인하기',
          ],
        );
    }
  }

  /// 페르소나의 에러 상태 확인
  bool isPersonaProblematic(String personaId) {
    final tracker = _errorTrackers[personaId];
    if (tracker == null) return false;

    // 최근 10분 내 5회 이상 에러 발생
    final recentErrors = tracker.getRecentErrorCount(Duration(minutes: 10));
    return recentErrors >= 5;
  }

  /// 에러 기록 초기화
  void clearErrors(String personaId) {
    _errorTrackers.remove(personaId);
  }

  /// 에러가 이미 리포트되었는지 확인
  bool isErrorRecentlyReported(String errorHash) {
    return _recentErrorHashes.contains(errorHash);
  }

  /// 에러 리포트 기록
  void markErrorAsReported(String errorHash) {
    _recentErrorHashes.add(errorHash);
    _hashTimestamps[errorHash] = DateTime.now();
  }

  /// 오래된 해시 정리
  void _cleanupOldHashes() {
    final now = DateTime.now();
    final cutoff = now.subtract(const Duration(minutes: 30));

    final hashesToRemove = <String>[];
    _hashTimestamps.forEach((hash, timestamp) {
      if (timestamp.isBefore(cutoff)) {
        hashesToRemove.add(hash);
      }
    });

    for (final hash in hashesToRemove) {
      _recentErrorHashes.remove(hash);
      _hashTimestamps.remove(hash);
    }

    if (hashesToRemove.isNotEmpty) {
      debugPrint('🧹 Cleaned up ${hashesToRemove.length} old error hashes');
    }
  }

  /// 서비스 종료 시 호출
  void dispose() {
    _cleanupTimer?.cancel();
  }
}

/// 에러 추적기
class _ErrorTracker {
  final List<_ErrorRecord> _errors = [];

  void addError(String type, String message) {
    _errors.add(_ErrorRecord(
      type: type,
      message: message,
      timestamp: DateTime.now(),
    ));

    // 오래된 에러 제거 (24시간 이상)
    _errors.removeWhere(
        (e) => DateTime.now().difference(e.timestamp) > Duration(hours: 24));
  }

  int get totalErrors => _errors.length;

  String getMostCommonError() {
    if (_errors.isEmpty) return 'unknown';

    final errorCounts = <String, int>{};
    for (final error in _errors) {
      errorCounts[error.type] = (errorCounts[error.type] ?? 0) + 1;
    }

    return errorCounts.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }

  int getRecentErrorCount(Duration duration) {
    final cutoff = DateTime.now().subtract(duration);
    return _errors.where((e) => e.timestamp.isAfter(cutoff)).length;
  }
}

/// 에러 기록
class _ErrorRecord {
  final String type;
  final String message;
  final DateTime timestamp;

  _ErrorRecord({
    required this.type,
    required this.message,
    required this.timestamp,
  });
}

/// 복구 전략
class RecoveryStrategy {
  final RecoveryType type;
  final String message;
  final List<String> actions;

  RecoveryStrategy({
    required this.type,
    required this.message,
    required this.actions,
  });
}

/// 복구 타입
enum RecoveryType {
  simplifyPrompt, // 프롬프트 단순화
  cooldown, // 대기 시간 필요
  systemError, // 시스템 에러
  retry, // 재시도
  generic, // 일반적인 복구
}
