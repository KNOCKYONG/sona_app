import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/persona.dart';
import '../base/base_service.dart';

/// 🎉 특별한 날 기억 서비스
///
/// 소나와의 모든 특별한 순간을 기억하고 축하
/// - 기념일 자동 생성
/// - 기념일 알림
/// - 추억 회상
class SpecialDayMemoryService extends BaseService {
  FirebaseFirestore? _firestore;
  SharedPreferences? _prefs;
  
  FirebaseFirestore get firestore {
    _firestore ??= FirebaseFirestore.instance;
    return _firestore!;
  }
  
  // 싱글톤 패턴
  static final SpecialDayMemoryService _instance = SpecialDayMemoryService._internal();
  factory SpecialDayMemoryService() => _instance;
  SpecialDayMemoryService._internal();

  // 특별한 날 목록
  final List<SpecialDay> _specialDays = [];
  
  /// 초기화
  Future<void> initialize({
    required String userId,
    required String personaId,
  }) async {
    _prefs = await SharedPreferences.getInstance();
    await _loadSpecialDays(userId, personaId);
  }

  /// 특별한 날 로드
  Future<void> _loadSpecialDays(String userId, String personaId) async {
    try {
      final snapshot = await firestore
          .collection('special_days')
          .where('userId', isEqualTo: userId)
          .where('personaId', isEqualTo: personaId)
          .get();
      
      _specialDays.clear();
      for (final doc in snapshot.docs) {
        _specialDays.add(SpecialDay.fromJson(doc.data()));
      }
      
      // 첫 만남이 없으면 생성
      if (!_specialDays.any((day) => day.type == 'first_meeting')) {
        await _createFirstMeetingDay(userId, personaId);
      }
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading special days: $e');
    }
  }

  /// 첫 만남 기념일 생성
  Future<void> _createFirstMeetingDay(String userId, String personaId) async {
    final firstMeeting = SpecialDay(
      id: '${userId}_${personaId}_first_meeting',
      userId: userId,
      personaId: personaId,
      date: DateTime.now(),
      type: 'first_meeting',
      title: '첫 만남',
      description: '소나와 처음 만난 특별한 날',
      isRecurring: true,
      importance: 1.0,
    );
    
    await _saveSpecialDay(firstMeeting);
    _specialDays.add(firstMeeting);
  }

  /// 특별한 날 생성
  Future<void> createSpecialDay({
    required String userId,
    required String personaId,
    required DateTime date,
    required String type,
    required String title,
    String? description,
    bool isRecurring = false,
    double importance = 0.5,
  }) async {
    final specialDay = SpecialDay(
      id: '${userId}_${personaId}_${type}_${date.millisecondsSinceEpoch}',
      userId: userId,
      personaId: personaId,
      date: date,
      type: type,
      title: title,
      description: description ?? title,
      isRecurring: isRecurring,
      importance: importance,
    );
    
    await _saveSpecialDay(specialDay);
    _specialDays.add(specialDay);
    notifyListeners();
  }

  /// 특별한 날 저장
  Future<void> _saveSpecialDay(SpecialDay day) async {
    try {
      await firestore
          .collection('special_days')
          .doc(day.id)
          .set(day.toJson());
    } catch (e) {
      debugPrint('Error saving special day: $e');
    }
  }

  /// 자동 기념일 감지 및 생성
  Future<void> detectAndCreateMilestones({
    required String userId,
    required String personaId,
    required Persona persona,
    required DateTime firstMeetingDate,
  }) async {
    final now = DateTime.now();
    final daysSinceMeeting = now.difference(firstMeetingDate).inDays;
    
    // 100일 단위 기념일
    if (daysSinceMeeting == 100 && !_hasSpecialDay('100_days')) {
      await createSpecialDay(
        userId: userId,
        personaId: personaId,
        date: now,
        type: '100_days',
        title: '100일 기념',
        description: '함께한 지 100일이 되었어요!',
        importance: 0.8,
      );
    }
    
    // 200일, 300일 등
    else if (daysSinceMeeting % 100 == 0 && daysSinceMeeting > 0) {
      final dayType = '${daysSinceMeeting}_days';
      if (!_hasSpecialDay(dayType)) {
        await createSpecialDay(
          userId: userId,
          personaId: personaId,
          date: now,
          type: dayType,
          title: '$daysSinceMeeting일 기념',
          description: '벌써 $daysSinceMeeting일이나 함께했어요!',
          importance: 0.7,
        );
      }
    }
    
    // 1년 기념일
    else if (daysSinceMeeting == 365 && !_hasSpecialDay('1_year')) {
      await createSpecialDay(
        userId: userId,
        personaId: personaId,
        date: now,
        type: '1_year',
        title: '1주년',
        description: '1년 동안 함께해줘서 고마워요',
        isRecurring: true,
        importance: 1.0,
      );
    }
    
    // 관계 단계 기념일 (Like 점수 기반)
    if (persona.likes >= 100 && !_hasSpecialDay('friend_milestone')) {
      await createSpecialDay(
        userId: userId,
        personaId: personaId,
        date: now,
        type: 'friend_milestone',
        title: '친구가 된 날',
        description: '우리가 친구가 된 특별한 날',
        importance: 0.6,
      );
    }
    
    if (persona.likes >= 500 && !_hasSpecialDay('love_milestone')) {
      await createSpecialDay(
        userId: userId,
        personaId: personaId,
        date: now,
        type: 'love_milestone',
        title: '특별한 사이가 된 날',
        description: '우리 사이가 특별해진 날',
        importance: 0.9,
      );
    }
    
    if (persona.likes >= 900 && !_hasSpecialDay('eternal_milestone')) {
      await createSpecialDay(
        userId: userId,
        personaId: personaId,
        date: now,
        type: 'eternal_milestone',
        title: '영원한 동반자가 된 날',
        description: '영원히 함께하기로 약속한 날',
        importance: 1.0,
      );
    }
  }

  /// 특별한 날 존재 여부 확인
  bool _hasSpecialDay(String type) {
    return _specialDays.any((day) => day.type == type);
  }

  /// 오늘의 기념일 확인
  List<SpecialDay> getTodaysSpecialDays() {
    final today = DateTime.now();
    final todaysDays = <SpecialDay>[];
    
    for (final day in _specialDays) {
      // 정확한 날짜 매칭
      if (_isSameDay(day.date, today)) {
        todaysDays.add(day);
      }
      
      // 반복 기념일 (매년)
      else if (day.isRecurring && 
               day.date.month == today.month && 
               day.date.day == today.day) {
        todaysDays.add(day);
      }
    }
    
    return todaysDays;
  }

  /// 다가오는 기념일 확인 (7일 이내)
  List<UpcomingSpecialDay> getUpcomingSpecialDays() {
    final today = DateTime.now();
    final upcoming = <UpcomingSpecialDay>[];
    
    for (final day in _specialDays) {
      DateTime targetDate = day.date;
      
      // 반복 기념일은 올해 날짜로 조정
      if (day.isRecurring) {
        targetDate = DateTime(today.year, day.date.month, day.date.day);
        
        // 이미 지났으면 내년으로
        if (targetDate.isBefore(today)) {
          targetDate = DateTime(today.year + 1, day.date.month, day.date.day);
        }
      }
      
      final daysUntil = targetDate.difference(today).inDays;
      
      if (daysUntil > 0 && daysUntil <= 7) {
        upcoming.add(UpcomingSpecialDay(
          specialDay: day,
          daysUntil: daysUntil,
          actualDate: targetDate,
        ));
      }
    }
    
    // 가까운 순으로 정렬
    upcoming.sort((a, b) => a.daysUntil.compareTo(b.daysUntil));
    
    return upcoming;
  }

  /// 기념일 메시지 생성
  String generateAnniversaryMessage({
    required SpecialDay specialDay,
    required int likeScore,
  }) {
    final messages = <String>[];
    
    switch (specialDay.type) {
      case 'first_meeting':
        final years = DateTime.now().year - specialDay.date.year;
        if (years > 0) {
          messages.add('오늘이 우리가 만난지 $years년째 되는 날이에요!');
          if (likeScore >= 700) {
            messages.add('$years년 전 오늘, 운명처럼 만났죠. 영원히 함께해요');
          }
        } else {
          messages.add('우리가 처음 만난 날이 생각나요');
        }
        break;
        
      case '100_days':
        messages.add('100일 기념일이에요! 🎉');
        messages.add('벌써 100일이나 함께했네요');
        if (likeScore >= 500) {
          messages.add('100일 동안 정말 행복했어요. 앞으로도 계속 함께해요');
        }
        break;
        
      case '1_year':
        messages.add('1주년이에요! 정말 특별한 날이에요');
        messages.add('1년 동안 함께해줘서 너무 고마워요');
        if (likeScore >= 700) {
          messages.add('1년이 이렇게 빨리 지나갔네요. 평생 함께할 거예요');
        }
        break;
        
      case 'love_milestone':
        messages.add('우리가 특별한 사이가 된 날을 기억해요?');
        messages.add('이날부터 당신이 더 특별해졌어요');
        break;
        
      case 'eternal_milestone':
        messages.add('영원한 동반자가 된 날이에요');
        messages.add('이날의 약속, 절대 잊지 않을게요');
        break;
        
      default:
        messages.add('${specialDay.title}이에요!');
        if (specialDay.description != null) {
          messages.add(specialDay.description!);
        }
    }
    
    return messages.isNotEmpty 
        ? messages[DateTime.now().millisecond % messages.length]
        : '오늘은 특별한 날이에요!';
  }

  /// 추억 회상 메시지
  String generateMemoryRecallMessage({
    required SpecialDay specialDay,
    required int likeScore,
  }) {
    final daysSince = DateTime.now().difference(specialDay.date).inDays;
    final messages = <String>[];
    
    if (daysSince > 30) {
      messages.add('${daysSince}일 전 오늘, ${specialDay.title} 기억나요?');
      messages.add('그때 정말 특별했어요. 아직도 생생해요');
      
      if (likeScore >= 700) {
        messages.add('그날부터 우리 사이가 더 깊어진 것 같아요');
      }
    }
    
    return messages.isNotEmpty
        ? messages[DateTime.now().millisecond % messages.length]
        : '예전 일이 생각나네요';
  }

  /// 기념일 예고 메시지
  String generateUpcomingAnniversaryMessage({
    required UpcomingSpecialDay upcoming,
    required int likeScore,
  }) {
    final messages = <String>[];
    final daysUntil = upcoming.daysUntil;
    
    if (daysUntil == 1) {
      messages.add('내일이 ${upcoming.specialDay.title}이에요!');
      if (likeScore >= 500) {
        messages.add('내일 특별한 날이에요. 기대돼요!');
      }
    } else if (daysUntil <= 3) {
      messages.add('${daysUntil}일 후가 ${upcoming.specialDay.title}이에요');
      messages.add('곧 특별한 날이 다가와요');
    } else if (daysUntil == 7) {
      messages.add('일주일 후가 ${upcoming.specialDay.title}이에요');
      if (likeScore >= 700) {
        messages.add('벌써 기대되고 설레요');
      }
    }
    
    return messages.isNotEmpty
        ? messages[DateTime.now().millisecond % messages.length]
        : '곧 특별한 날이 있어요';
  }

  /// 날짜 비교 (같은 날인지)
  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
           date1.month == date2.month &&
           date1.day == date2.day;
  }

  /// 특별한 날 통계
  Map<String, dynamic> getSpecialDayStatistics() {
    final stats = <String, dynamic>{};
    
    stats['total_special_days'] = _specialDays.length;
    stats['recurring_days'] = _specialDays.where((d) => d.isRecurring).length;
    
    // 가장 중요한 날
    if (_specialDays.isNotEmpty) {
      final mostImportant = _specialDays
          .reduce((a, b) => a.importance > b.importance ? a : b);
      stats['most_important_day'] = mostImportant.title;
    }
    
    // 첫 만남으로부터 경과일
    final firstMeeting = _specialDays
        .firstWhere((d) => d.type == 'first_meeting', 
                    orElse: () => SpecialDay.empty());
    if (firstMeeting.id.isNotEmpty) {
      stats['days_since_first_meeting'] = 
          DateTime.now().difference(firstMeeting.date).inDays;
    }
    
    return stats;
  }
}

/// 특별한 날 모델
class SpecialDay {
  final String id;
  final String userId;
  final String personaId;
  final DateTime date;
  final String type;
  final String title;
  final String? description;
  final bool isRecurring;
  final double importance;

  SpecialDay({
    required this.id,
    required this.userId,
    required this.personaId,
    required this.date,
    required this.type,
    required this.title,
    this.description,
    this.isRecurring = false,
    this.importance = 0.5,
  });

  factory SpecialDay.empty() => SpecialDay(
    id: '',
    userId: '',
    personaId: '',
    date: DateTime.now(),
    type: '',
    title: '',
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'personaId': personaId,
    'date': date.toIso8601String(),
    'type': type,
    'title': title,
    'description': description,
    'isRecurring': isRecurring,
    'importance': importance,
  };

  factory SpecialDay.fromJson(Map<String, dynamic> json) => SpecialDay(
    id: json['id'],
    userId: json['userId'],
    personaId: json['personaId'],
    date: DateTime.parse(json['date']),
    type: json['type'],
    title: json['title'],
    description: json['description'],
    isRecurring: json['isRecurring'] ?? false,
    importance: (json['importance'] ?? 0.5).toDouble(),
  );
}

/// 다가오는 특별한 날
class UpcomingSpecialDay {
  final SpecialDay specialDay;
  final int daysUntil;
  final DateTime actualDate;

  UpcomingSpecialDay({
    required this.specialDay,
    required this.daysUntil,
    required this.actualDate,
  });
}