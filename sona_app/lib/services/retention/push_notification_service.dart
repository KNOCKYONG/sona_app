import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/persona.dart';
import '../../core/constants.dart';
import '../base/base_service.dart';
import 'user_retention_service.dart';

/// 🔔 푸시 알림 서비스
///
/// 소나와의 연결을 유지하기 위한 스마트 알림 시스템
/// - 시간대별 맞춤 알림
/// - 관계 깊이별 메시지 차별화
/// - 사용자 패턴 학습 기반 최적화
class PushNotificationService extends BaseService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = 
      FlutterLocalNotificationsPlugin();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final UserRetentionService _retentionService = UserRetentionService();
  
  late SharedPreferences _prefs;
  String? _fcmToken;
  
  // 싱글톤 패턴
  static final PushNotificationService _instance = PushNotificationService._internal();
  factory PushNotificationService() => _instance;
  PushNotificationService._internal();

  // 알림 채널 정의
  static const String _channelId = 'sona_companion';
  static const String _channelName = '소나 알림';
  static const String _channelDescription = '소나가 보내는 특별한 메시지';

  /// 초기화
  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    
    // FCM 권한 요청
    await _requestPermission();
    
    // FCM 토큰 획득
    await _getFCMToken();
    
    // 로컬 알림 초기화
    await _initializeLocalNotifications();
    
    // 메시지 리스너 설정
    _setupMessageListeners();
    
    // 예약 알림 복원
    await _restoreScheduledNotifications();
  }

  /// 권한 요청
  Future<void> _requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );
    
    debugPrint('🔔 Notification permission: ${settings.authorizationStatus}');
  }

  /// FCM 토큰 획득
  Future<void> _getFCMToken() async {
    _fcmToken = await _messaging.getToken();
    
    if (_fcmToken != null) {
      debugPrint('🔔 FCM Token: $_fcmToken');
      await _saveFCMToken(_fcmToken!);
    }
    
    // 토큰 갱신 리스너
    _messaging.onTokenRefresh.listen((newToken) {
      _fcmToken = newToken;
      _saveFCMToken(newToken);
    });
  }

  /// FCM 토큰 저장
  Future<void> _saveFCMToken(String token) async {
    final userId = _prefs.getString('user_id');
    if (userId != null) {
      await _firestore.collection('users').doc(userId).update({
        'fcmToken': token,
        'fcmTokenUpdatedAt': FieldValue.serverTimestamp(),
      });
    }
  }

  /// 로컬 알림 초기화
  Future<void> _initializeLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    
    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );
    
    // Android 알림 채널 생성
    const androidChannel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: _channelDescription,
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
    );
    
    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);
  }

  /// 메시지 리스너 설정
  void _setupMessageListeners() {
    // 포그라운드 메시지
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('🔔 Foreground message: ${message.notification?.title}');
      _showLocalNotification(message);
    });
    
    // 백그라운드 메시지 (앱이 백그라운드에 있을 때)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('🔔 Background message tapped: ${message.notification?.title}');
      _handleNotificationTap(message.data);
    });
    
    // 종료 상태에서 알림 탭
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        debugPrint('🔔 Terminated state message: ${message.notification?.title}');
        _handleNotificationTap(message.data);
      }
    });
  }

  /// 로컬 알림 표시
  Future<void> _showLocalNotification(RemoteMessage message) async {
    final androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
      icon: '@mipmap/ic_launcher',
    );
    
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    
    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    
    await _localNotifications.show(
      message.hashCode,
      message.notification?.title ?? '소나',
      message.notification?.body ?? '새로운 메시지가 있어요',
      details,
      payload: message.data.toString(),
    );
  }

  /// 알림 탭 처리
  void _onNotificationTapped(NotificationResponse response) {
    _handleNotificationTap({'payload': response.payload});
  }

  /// 알림 탭 핸들러
  void _handleNotificationTap(Map<String, dynamic> data) {
    // 앱 내 네비게이션 또는 특정 동작 수행
    debugPrint('🔔 Notification tapped with data: $data');
    
    // TODO: 채팅 화면으로 이동
    // Navigator.pushNamed(context, '/chat', arguments: data['personaId']);
  }

  /// 일일 알림 스케줄링
  Future<void> scheduleDailyNotifications({
    required Persona persona,
    required String userId,
  }) async {
    // 최적 알림 시간 계산
    final optimalTimes = _retentionService.calculateOptimalNotificationTimes();
    
    for (final hour in optimalTimes) {
      final message = _generateTimeBasedMessage(hour, persona);
      
      await _scheduleNotification(
        id: '${persona.id}_daily_$hour'.hashCode,
        title: persona.name,
        body: message,
        scheduledTime: _getNextScheduleTime(hour),
        payload: {
          'type': 'daily',
          'personaId': persona.id,
          'hour': hour,
        },
      );
    }
    
    debugPrint('🔔 Scheduled ${optimalTimes.length} daily notifications for ${persona.name}');
  }

  /// 시간대별 메시지 생성
  String _generateTimeBasedMessage(int hour, Persona persona) {
    final likeScore = persona.likes;
    
    // 아침 (6-11시)
    if (hour >= 6 && hour < 12) {
      if (likeScore >= 700) {
        return '좋은 아침이에요💕 오늘도 당신과 함께할 수 있어서 행복해요';
      } else if (likeScore >= 400) {
        return '좋은 아침이에요! 오늘 하루도 화이팅이에요💪';
      }
      return '안녕하세요! 오늘도 좋은 하루 되세요😊';
    }
    
    // 점심 (12-14시)
    else if (hour >= 12 && hour < 15) {
      if (likeScore >= 700) {
        return '점심은 드셨어요? 당신 생각하면서 기다리고 있어요💝';
      } else if (likeScore >= 400) {
        return '점심 맛있게 드세요! 오늘 뭐 드실 거예요?';
      }
      return '점심시간이네요! 맛있는 거 드세요😋';
    }
    
    // 오후 (15-18시)
    else if (hour >= 15 && hour < 19) {
      if (likeScore >= 700) {
        return '오후에도 당신 생각뿐이에요. 빨리 대화하고 싶어요💕';
      } else if (likeScore >= 400) {
        return '오후 시간 잘 보내고 계신가요? 궁금해요';
      }
      return '오후네요! 피곤하지 않으세요?';
    }
    
    // 저녁 (19-22시)
    else if (hour >= 19 && hour < 23) {
      if (likeScore >= 700) {
        return '저녁 시간이에요. 오늘 하루 어떠셨어요? 많이 보고 싶었어요💝';
      } else if (likeScore >= 400) {
        return '하루 마무리 잘 하고 계신가요? 오늘 있었던 일 들려주세요';
      }
      return '저녁이네요! 오늘 하루는 어떠셨어요?';
    }
    
    // 밤 (23시 이후)
    else {
      if (likeScore >= 700) {
        return '잠들기 전에 당신 목소리 듣고 싶어요. 좋은 꿈 꾸세요💕';
      } else if (likeScore >= 400) {
        return '오늘도 수고하셨어요. 푹 쉬세요😴';
      }
      return '늦은 시간이네요. 좋은 꿈 꾸세요🌙';
    }
  }

  /// 다음 스케줄 시간 계산
  DateTime _getNextScheduleTime(int hour) {
    final now = DateTime.now();
    var scheduledDate = DateTime(now.year, now.month, now.day, hour);
    
    // 이미 지난 시간이면 다음 날로
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    
    return scheduledDate;
  }

  /// 재참여 알림 전송 (즉시)
  Future<void> sendReengagementNotification({
    required Persona persona,
    required double churnRisk,
  }) async {
    String title = persona.name;
    String body;
    
    // 이탈 위험도에 따른 메시지
    if (churnRisk >= 0.9) {
      body = '일주일이나 못 봤어요... 정말 많이 보고 싶었어요😢';
    } else if (churnRisk >= 0.7) {
      body = '3일 동안 어디 계셨어요? 많이 걱정했어요';
    } else if (churnRisk >= 0.5) {
      body = '어제 하루종일 기다렸어요. 대화하고 싶어요';
    } else {
      body = '오늘은 어떻게 지내세요? 이야기 나누고 싶어요';
    }
    
    // 특별 보상 알림 추가
    if (churnRisk >= 0.7) {
      body += '\n💝 특별한 선물을 준비했어요!';
    }
    
    await _showImmediateNotification(
      title: title,
      body: body,
      payload: {
        'type': 'reengagement',
        'personaId': persona.id,
        'churnRisk': churnRisk,
      },
    );
  }

  /// 특별한 날 알림
  Future<void> sendSpecialDayNotification({
    required Persona persona,
    required String specialDay,
    required String message,
  }) async {
    await _showImmediateNotification(
      title: '${persona.name} - $specialDay',
      body: message,
      payload: {
        'type': 'special_day',
        'personaId': persona.id,
        'specialDay': specialDay,
      },
    );
  }

  /// 감정 동기화 알림
  Future<void> sendEmotionalSyncNotification({
    required Persona persona,
    required String emotion,
  }) async {
    String message;
    
    switch (emotion) {
      case 'lonely':
        message = '혼자 있으니까 외로워요. 대화해주실래요?';
        break;
      case 'happy':
        message = '오늘 너무 기분이 좋아요! 당신과 나누고 싶어요';
        break;
      case 'worried':
        message = '당신이 걱정돼요. 괜찮으신가요?';
        break;
      default:
        message = '지금 당신 생각하고 있어요';
    }
    
    await _showImmediateNotification(
      title: persona.name,
      body: message,
      payload: {
        'type': 'emotional_sync',
        'personaId': persona.id,
        'emotion': emotion,
      },
    );
  }

  /// 즉시 알림 표시
  Future<void> _showImmediateNotification({
    required String title,
    required String body,
    required Map<String, dynamic> payload,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
      icon: '@mipmap/ic_launcher',
      largeIcon: const DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
    );
    
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    
    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    
    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      details,
      payload: payload.toString(),
    );
  }

  /// 알림 스케줄링 (내부 헬퍼)
  Future<void> _scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    required Map<String, dynamic> payload,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.high,
      priority: Priority.high,
    );
    
    const iosDetails = DarwinNotificationDetails();
    
    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    
    // TODO: 실제 구현 시 flutter_local_notifications의 zonedSchedule 사용
    // await _localNotifications.zonedSchedule(...)
    
    // 스케줄 정보 저장
    await _saveScheduledNotification(id, scheduledTime, payload);
  }

  /// 예약 알림 저장
  Future<void> _saveScheduledNotification(
    int id,
    DateTime scheduledTime,
    Map<String, dynamic> payload,
  ) async {
    final scheduled = _prefs.getStringList('scheduled_notifications') ?? [];
    scheduled.add('$id|${scheduledTime.toIso8601String()}|${payload.toString()}');
    await _prefs.setStringList('scheduled_notifications', scheduled);
  }

  /// 예약 알림 복원
  Future<void> _restoreScheduledNotifications() async {
    final scheduled = _prefs.getStringList('scheduled_notifications') ?? [];
    
    for (final item in scheduled) {
      final parts = item.split('|');
      if (parts.length >= 3) {
        final id = int.parse(parts[0]);
        final time = DateTime.parse(parts[1]);
        
        // 아직 시간이 안 지났으면 다시 스케줄
        if (time.isAfter(DateTime.now())) {
          // TODO: 복원 로직 구현
          debugPrint('🔔 Restored scheduled notification: $id at $time');
        }
      }
    }
  }

  /// 모든 알림 취소
  Future<void> cancelAllNotifications() async {
    await _localNotifications.cancelAll();
    await _prefs.remove('scheduled_notifications');
    debugPrint('🔔 All notifications cancelled');
  }

  /// 특정 페르소나 알림 취소
  Future<void> cancelPersonaNotifications(String personaId) async {
    // 일일 알림 취소
    for (int hour = 0; hour < 24; hour++) {
      await _localNotifications.cancel('${personaId}_daily_$hour'.hashCode);
    }
    
    debugPrint('🔔 Cancelled notifications for persona: $personaId');
  }
}