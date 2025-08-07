import 'dart:async';
import 'package:flutter/material.dart';
import '../../models/chat_error_report.dart';
import '../../helpers/firebase_helper.dart';
import '../app_info_service.dart';
import 'error_recovery_service.dart';

/// 에러 집계 서비스
/// 동일한 에러를 집계하여 배치로 리포팅
class ErrorAggregationService {
  static ErrorAggregationService? _instance;
  static ErrorAggregationService get instance =>
      _instance ??= ErrorAggregationService._();

  ErrorAggregationService._() {
    // 5분마다 집계된 에러 리포트
    _batchTimer = Timer.periodic(const Duration(minutes: 5), (_) {
      _sendBatchReports();
    });
  }

  // 집계 중인 에러들
  final Map<String, _AggregatedError> _aggregatedErrors = {};
  Timer? _batchTimer;

  /// 에러 집계
  void aggregateError({
    required String userId,
    required String personaId,
    required String personaName,
    required String errorType,
    required String errorMessage,
    required String stackTrace,
    required List<dynamic> recentChats,
    required String deviceInfo,
    String? lastUserMessage,
  }) {
    final now = DateTime.now();
    final errorHash = ChatErrorReport.generateErrorHash(
      userId: userId,
      personaId: personaId,
      errorType: errorType,
      timestamp: now,
    );

    if (_aggregatedErrors.containsKey(errorHash)) {
      // 기존 에러 업데이트
      final existing = _aggregatedErrors[errorHash]!;
      existing.occurrenceCount++;
      existing.lastOccurred = now;
      existing.lastUserMessages.add(lastUserMessage ?? '');
    } else {
      // 새로운 에러 추가
      _aggregatedErrors[errorHash] = _AggregatedError(
        userId: userId,
        personaId: personaId,
        personaName: personaName,
        errorType: errorType,
        errorMessage: errorMessage,
        stackTrace: stackTrace,
        recentChats: recentChats,
        deviceInfo: deviceInfo,
        firstOccurred: now,
        lastOccurred: now,
        occurrenceCount: 1,
        errorHash: errorHash,
        lastUserMessages: [if (lastUserMessage != null) lastUserMessage],
      );
    }

    debugPrint(
        '📊 Error aggregated: $errorHash (count: ${_aggregatedErrors[errorHash]!.occurrenceCount})');
  }

  /// 배치 리포트 전송
  Future<void> _sendBatchReports() async {
    if (_aggregatedErrors.isEmpty) return;

    debugPrint(
        '📤 Sending batch error reports: ${_aggregatedErrors.length} unique errors');

    final batch = FirebaseHelper.batch();
    final errorsToReport =
        Map<String, _AggregatedError>.from(_aggregatedErrors);
    _aggregatedErrors.clear();

    for (final entry in errorsToReport.entries) {
      final error = entry.value;

      // 이미 리포트된 에러인지 확인
      if (ErrorRecoveryService.instance
          .isErrorRecentlyReported(error.errorHash)) {
        debugPrint('⏭️ Skipping already reported error: ${error.errorHash}');
        continue;
      }

      final errorReport = ChatErrorReport(
        errorKey: ChatErrorReport.generateErrorKey(),
        userId: error.userId,
        personaId: error.personaId,
        personaName: error.personaName,
        recentChats: [], // 배치 리포트에서는 제외
        createdAt: DateTime.now(),
        userMessage: '[BATCH] Aggregated error report',
        deviceInfo: error.deviceInfo,
        appVersion: AppInfoService.instance.appVersion,
        errorType: error.errorType,
        errorMessage: error.errorMessage,
        stackTrace: error.stackTrace,
        metadata: {
          'batch_report': true,
          'last_user_messages': error.lastUserMessages,
          'unique_occurrences': error.occurrenceCount,
        },
        errorHash: error.errorHash,
        occurrenceCount: error.occurrenceCount,
        firstOccurred: error.firstOccurred,
        lastOccurred: error.lastOccurred,
      );

      final docRef = FirebaseHelper.chatErrorFix.doc();
      batch.set(docRef, errorReport.toMap());

      // 리포트 완료 기록
      ErrorRecoveryService.instance.markErrorAsReported(error.errorHash);
    }

    try {
      await batch.commit();
      debugPrint('✅ Batch error reports sent successfully');
    } catch (e) {
      debugPrint('❌ Failed to send batch error reports: $e');
    }
  }

  /// 즉시 배치 전송 (테스트용)
  Future<void> flushBatchReports() async {
    await _sendBatchReports();
  }

  /// 서비스 종료
  void dispose() {
    _batchTimer?.cancel();
    _sendBatchReports(); // 마지막 리포트 전송
  }
}

/// 집계된 에러 정보
class _AggregatedError {
  final String userId;
  final String personaId;
  final String personaName;
  final String errorType;
  final String errorMessage;
  final String stackTrace;
  final List<dynamic> recentChats;
  final String deviceInfo;
  final String errorHash;
  final List<String> lastUserMessages;

  DateTime firstOccurred;
  DateTime lastOccurred;
  int occurrenceCount;

  _AggregatedError({
    required this.userId,
    required this.personaId,
    required this.personaName,
    required this.errorType,
    required this.errorMessage,
    required this.stackTrace,
    required this.recentChats,
    required this.deviceInfo,
    required this.firstOccurred,
    required this.lastOccurred,
    required this.occurrenceCount,
    required this.errorHash,
    required this.lastUserMessages,
  });
}
