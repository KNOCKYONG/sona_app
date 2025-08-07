import 'package:cloud_firestore/cloud_firestore.dart';
import 'message.dart';

/// 채팅 오류 리포트 모델
class ChatErrorReport {
  final String errorKey;
  final String userId;
  final String personaId;
  final String personaName;
  final List<Message> recentChats;
  final DateTime createdAt;
  final String? userMessage; // 사용자가 추가로 입력한 메시지
  final String deviceInfo;
  final String appVersion;
  final String? errorType; // 에러 타입 (api_error, timeout, rate_limit 등)
  final String? errorMessage; // 구체적인 에러 메시지
  final String? stackTrace; // 스택 트레이스 (일부)
  final Map<String, dynamic>? metadata; // 추가 메타데이터
  final int occurrenceCount; // 발생 횟수
  final DateTime? firstOccurred; // 최초 발생 시간
  final DateTime? lastOccurred; // 마지막 발생 시간
  final String? errorHash; // 중복 체크용 해시

  ChatErrorReport({
    required this.errorKey,
    required this.userId,
    required this.personaId,
    required this.personaName,
    required this.recentChats,
    required this.createdAt,
    this.userMessage,
    required this.deviceInfo,
    required this.appVersion,
    this.errorType,
    this.errorMessage,
    this.stackTrace,
    this.metadata,
    this.occurrenceCount = 1,
    this.firstOccurred,
    this.lastOccurred,
    this.errorHash,
  });

  /// Firestore에 저장하기 위한 Map 변환
  Map<String, dynamic> toMap() {
    return {
      'error_key': errorKey,
      'user': userId,
      'persona': personaId,
      'persona_name': personaName,
      'chat': recentChats
          .map((msg) => {
                'content': msg.content,
                'isFromUser': msg.isFromUser,
                'timestamp': Timestamp.fromDate(msg.timestamp),
                'personaId': msg.personaId,
                'emotion': msg.emotion?.name,
              })
          .toList(),
      'created_at': Timestamp.fromDate(createdAt),
      'user_message': userMessage,
      'device_info': deviceInfo,
      'app_version': appVersion,
      'error_type': errorType,
      'error_message': errorMessage,
      'stack_trace': stackTrace,
      'metadata': metadata,
      'occurrence_count': occurrenceCount,
      'first_occurred':
          firstOccurred != null ? Timestamp.fromDate(firstOccurred!) : null,
      'last_occurred':
          lastOccurred != null ? Timestamp.fromDate(lastOccurred!) : null,
      'error_hash': errorHash,
    };
  }

  /// Firestore 문서에서 모델 생성
  factory ChatErrorReport.fromMap(Map<String, dynamic> map) {
    return ChatErrorReport(
      errorKey: map['error_key'] ?? '',
      userId: map['user'] ?? '',
      personaId: map['persona'] ?? '',
      personaName: map['persona_name'] ?? '',
      recentChats: (map['chat'] as List<dynamic>?)
              ?.map((chat) => Message(
                    id: '', // ID는 여기서는 필요 없음
                    content: chat['content'] ?? '',
                    isFromUser: chat['isFromUser'] ?? false,
                    timestamp: (chat['timestamp'] as Timestamp).toDate(),
                    personaId: chat['personaId'] ?? '',
                    emotion: chat['emotion'] ?? 'neutral',
                    type: MessageType.text,
                  ))
              .toList() ??
          [],
      createdAt: (map['created_at'] as Timestamp).toDate(),
      userMessage: map['user_message'],
      deviceInfo: map['device_info'] ?? '',
      appVersion: map['app_version'] ?? '',
      errorType: map['error_type'],
      errorMessage: map['error_message'],
      stackTrace: map['stack_trace'],
      metadata: map['metadata'] != null
          ? Map<String, dynamic>.from(map['metadata'])
          : null,
      occurrenceCount: map['occurrence_count'] ?? 1,
      firstOccurred: map['first_occurred'] != null
          ? (map['first_occurred'] as Timestamp).toDate()
          : null,
      lastOccurred: map['last_occurred'] != null
          ? (map['last_occurred'] as Timestamp).toDate()
          : null,
      errorHash: map['error_hash'],
    );
  }

  /// 고유한 에러 키 생성
  static String generateErrorKey() {
    final now = DateTime.now();
    final timestamp = now.millisecondsSinceEpoch;
    final random = timestamp % 10000; // 마지막 4자리
    return 'ERR${timestamp}_$random';
  }

  /// 에러 해시 생성 (중복 체크용)
  static String generateErrorHash({
    required String userId,
    required String personaId,
    required String errorType,
    required DateTime timestamp,
  }) {
    // 5분 단위로 그룹화
    final timeSlot = timestamp.millisecondsSinceEpoch ~/ (5 * 60 * 1000);
    return '${userId}_${personaId}_${errorType}_$timeSlot';
  }
}
