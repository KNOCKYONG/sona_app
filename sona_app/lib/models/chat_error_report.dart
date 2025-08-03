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
  });

  /// Firestore에 저장하기 위한 Map 변환
  Map<String, dynamic> toMap() {
    return {
      'error_key': errorKey,
      'user': userId,
      'persona': personaId,
      'persona_name': personaName,
      'chat': recentChats.map((msg) => {
        'content': msg.content,
        'isFromUser': msg.isFromUser,
        'timestamp': msg.timestamp,
        'personaId': msg.personaId,
        'emotion': msg.emotion,
      }).toList(),
      'created_at': Timestamp.fromDate(createdAt),
      'user_message': userMessage,
      'device_info': deviceInfo,
      'app_version': appVersion,
    };
  }

  /// Firestore 문서에서 모델 생성
  factory ChatErrorReport.fromMap(Map<String, dynamic> map) {
    return ChatErrorReport(
      errorKey: map['error_key'] ?? '',
      userId: map['user'] ?? '',
      personaId: map['persona'] ?? '',
      personaName: map['persona_name'] ?? '',
      recentChats: (map['chat'] as List<dynamic>?)?.map((chat) => 
        Message(
          id: '', // ID는 여기서는 필요 없음
          content: chat['content'] ?? '',
          isFromUser: chat['isFromUser'] ?? false,
          timestamp: (chat['timestamp'] as Timestamp).toDate(),
          personaId: chat['personaId'] ?? '',
          emotion: chat['emotion'] ?? 'neutral',
          messageType: MessageType.text,
        )
      ).toList() ?? [],
      createdAt: (map['created_at'] as Timestamp).toDate(),
      userMessage: map['user_message'],
      deviceInfo: map['device_info'] ?? '',
      appVersion: map['app_version'] ?? '',
    );
  }

  /// 고유한 에러 키 생성
  static String generateErrorKey() {
    final now = DateTime.now();
    final timestamp = now.millisecondsSinceEpoch;
    final random = timestamp % 10000; // 마지막 4자리
    return 'ERR${timestamp}_$random';
  }
}