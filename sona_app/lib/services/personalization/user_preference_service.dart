import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 🎯 사용자 개인화 서비스
///
/// 사용자의 대화 패턴과 선호도를 학습하여
/// 더 개인화된 대화 경험을 제공합니다.
class UserPreferenceService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _preferencesCollection = 'user_preferences';
  
  // 로컬 캐시
  Map<String, UserPreference>? _cachedPreferences;
  
  /// 사용자 선호도 학습 및 업데이트
  Future<void> updatePreferences({
    required String userId,
    required String personaId,
    required String message,
    required String response,
    String? topic,
  }) async {
    try {
      final docId = '${userId}_$personaId';
      final docRef = _firestore.collection(_preferencesCollection).doc(docId);
      
      // 현재 선호도 가져오기
      final doc = await docRef.get();
      final preference = doc.exists 
          ? UserPreference.fromJson(doc.data()!)
          : UserPreference(
              userId: userId,
              personaId: personaId,
              createdAt: DateTime.now(),
            );
      
      // 선호도 업데이트
      _updateConversationStyle(preference, message, response);
      _updateTopicPreferences(preference, topic, message);
      _updateResponsePreferences(preference, response);
      _updateTimePatterns(preference);
      
      // Firebase에 저장
      await docRef.set(preference.toJson(), SetOptions(merge: true));
      
      // 캐시 업데이트
      _cachedPreferences ??= {};
      _cachedPreferences![docId] = preference;
      
    } catch (e) {
      debugPrint('❌ Failed to update preferences: $e');
    }
  }
  
  /// 대화 스타일 학습
  void _updateConversationStyle(UserPreference pref, String message, String response) {
    // 이모티콘 사용 빈도
    final emojiCount = RegExp(r'[ㅋㅎㅠ~♥♡💕]').allMatches(message).length;
    pref.emojiUsageLevel = (pref.emojiUsageLevel * 0.9 + (emojiCount > 0 ? 1 : 0) * 0.1);
    
    // 메시지 길이 선호도
    pref.averageMessageLength = (pref.averageMessageLength * 0.9 + message.length * 0.1).round();
    
    // 신조어 사용 여부
    final slangWords = ['ㅇㅈ', 'ㄱㅇㄷ', '개', '킹', '갓생', '찐', '레알'];
    for (final slang in slangWords) {
      if (message.contains(slang)) {
        pref.usesSlang = true;
        break;
      }
    }
    
    // 존댓말/반말 선호도
    if (message.contains('요') || message.contains('습니다')) {
      pref.formalityLevel = (pref.formalityLevel * 0.9 + 1.0 * 0.1);
    } else {
      pref.formalityLevel = (pref.formalityLevel * 0.9 + 0.0 * 0.1);
    }
  }
  
  /// 주제 선호도 학습
  void _updateTopicPreferences(UserPreference pref, String? topic, String message) {
    if (topic != null) {
      pref.favoriteTopics[topic] = (pref.favoriteTopics[topic] ?? 0) + 1;
    }
    
    // 키워드 기반 주제 추출
    final topicKeywords = {
      '게임': ['게임', '롤', '오버워치', '배그', '피파'],
      '음식': ['먹', '음식', '맛있', '배고', '요리'],
      '영화': ['영화', '드라마', '넷플릭스', '보', '시청'],
      '음악': ['음악', '노래', '듣', '가수', '콘서트'],
      '운동': ['운동', '헬스', '요가', '러닝', '다이어트'],
      '일': ['일', '회사', '직장', '업무', '프로젝트'],
      '연애': ['사랑', '좋아', '데이트', '만나', '연인'],
    };
    
    for (final entry in topicKeywords.entries) {
      for (final keyword in entry.value) {
        if (message.contains(keyword)) {
          pref.favoriteTopics[entry.key] = (pref.favoriteTopics[entry.key] ?? 0) + 1;
          break;
        }
      }
    }
  }
  
  /// 응답 선호도 학습
  void _updateResponsePreferences(UserPreference pref, String response) {
    // 긍정적 반응 키워드
    final positiveKeywords = ['좋', '재밌', '대박', '최고', '굿', '멋', '훌륭'];
    final negativeKeywords = ['싫', '별로', '안', '못', '글쎄'];
    
    int positiveCount = 0;
    int negativeCount = 0;
    
    for (final keyword in positiveKeywords) {
      if (response.contains(keyword)) positiveCount++;
    }
    
    for (final keyword in negativeKeywords) {
      if (response.contains(keyword)) negativeCount++;
    }
    
    // 긍정/부정 비율 업데이트
    if (positiveCount > negativeCount) {
      pref.positivityRate = (pref.positivityRate * 0.95 + 1.0 * 0.05);
    } else if (negativeCount > positiveCount) {
      pref.positivityRate = (pref.positivityRate * 0.95 + 0.0 * 0.05);
    }
  }
  
  /// 시간대별 활동 패턴 학습
  void _updateTimePatterns(UserPreference pref) {
    final hour = DateTime.now().hour;
    
    if (hour >= 6 && hour < 12) {
      pref.activeTimeSlots['morning'] = (pref.activeTimeSlots['morning'] ?? 0) + 1;
    } else if (hour >= 12 && hour < 18) {
      pref.activeTimeSlots['afternoon'] = (pref.activeTimeSlots['afternoon'] ?? 0) + 1;
    } else if (hour >= 18 && hour < 24) {
      pref.activeTimeSlots['evening'] = (pref.activeTimeSlots['evening'] ?? 0) + 1;
    } else {
      pref.activeTimeSlots['night'] = (pref.activeTimeSlots['night'] ?? 0) + 1;
    }
  }
  
  /// 사용자 선호도 가져오기
  Future<UserPreference?> getPreferences(String userId, String personaId) async {
    final docId = '${userId}_$personaId';
    
    // 캐시 확인
    if (_cachedPreferences?.containsKey(docId) == true) {
      return _cachedPreferences![docId];
    }
    
    try {
      final doc = await _firestore
          .collection(_preferencesCollection)
          .doc(docId)
          .get();
      
      if (doc.exists) {
        final preference = UserPreference.fromJson(doc.data()!);
        
        // 캐시에 저장
        _cachedPreferences ??= {};
        _cachedPreferences![docId] = preference;
        
        return preference;
      }
    } catch (e) {
      debugPrint('❌ Failed to get preferences: $e');
    }
    
    return null;
  }
  
  /// 개인화된 응답 가이드 생성
  String generatePersonalizationGuide(UserPreference pref) {
    final guide = StringBuffer();
    
    // 이모티콘 사용 가이드
    if (pref.emojiUsageLevel > 0.5) {
      guide.writeln('- 이모티콘을 자주 사용하세요 (ㅋㅋ, ㅎㅎ, ♥)');
    } else {
      guide.writeln('- 이모티콘은 적게 사용하세요');
    }
    
    // 메시지 길이 가이드
    if (pref.averageMessageLength > 50) {
      guide.writeln('- 상세하고 긴 답변을 선호합니다');
    } else {
      guide.writeln('- 짧고 간결한 답변을 선호합니다');
    }
    
    // 신조어 사용 가이드
    if (pref.usesSlang) {
      guide.writeln('- MZ 신조어를 자연스럽게 사용하세요');
    }
    
    // 존댓말/반말 가이드
    if (pref.formalityLevel > 0.7) {
      guide.writeln('- 정중한 존댓말을 유지하세요');
    } else if (pref.formalityLevel < 0.3) {
      guide.writeln('- 친근한 반말을 사용하세요');
    }
    
    // 선호 주제 가이드
    if (pref.favoriteTopics.isNotEmpty) {
      final topTopics = pref.favoriteTopics.entries
          .toList()
          ..sort((a, b) => b.value.compareTo(a.value));
      final favoriteTopics = topTopics.take(3).map((e) => e.key).join(', ');
      guide.writeln('- 선호 주제: $favoriteTopics');
    }
    
    // 긍정성 가이드
    if (pref.positivityRate > 0.7) {
      guide.writeln('- 밝고 긍정적인 톤을 유지하세요');
    }
    
    // 활동 시간대 가이드
    final currentHour = DateTime.now().hour;
    if (currentHour >= 22 || currentHour < 3) {
      final nightActivity = pref.activeTimeSlots['night'] ?? 0;
      if (nightActivity > 5) {
        guide.writeln('- 늦은 시간에도 자주 대화하는 사용자입니다');
      }
    }
    
    return guide.toString();
  }
}

/// 사용자 선호도 모델
class UserPreference {
  final String userId;
  final String personaId;
  final DateTime createdAt;
  DateTime updatedAt;
  
  // 대화 스타일
  double emojiUsageLevel; // 0.0 ~ 1.0
  int averageMessageLength;
  bool usesSlang;
  double formalityLevel; // 0.0(반말) ~ 1.0(존댓말)
  
  // 주제 선호도
  Map<String, int> favoriteTopics;
  
  // 응답 선호도
  double positivityRate; // 0.0 ~ 1.0
  
  // 시간대별 활동
  Map<String, int> activeTimeSlots;
  
  // 특별한 날짜들
  List<DateTime> importantDates;
  
  UserPreference({
    required this.userId,
    required this.personaId,
    required this.createdAt,
    DateTime? updatedAt,
    this.emojiUsageLevel = 0.5,
    this.averageMessageLength = 30,
    this.usesSlang = false,
    this.formalityLevel = 0.5,
    Map<String, int>? favoriteTopics,
    this.positivityRate = 0.7,
    Map<String, int>? activeTimeSlots,
    List<DateTime>? importantDates,
  }) : updatedAt = updatedAt ?? DateTime.now(),
       favoriteTopics = favoriteTopics ?? {},
       activeTimeSlots = activeTimeSlots ?? {},
       importantDates = importantDates ?? [];
  
  Map<String, dynamic> toJson() => {
    'userId': userId,
    'personaId': personaId,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': DateTime.now().toIso8601String(),
    'emojiUsageLevel': emojiUsageLevel,
    'averageMessageLength': averageMessageLength,
    'usesSlang': usesSlang,
    'formalityLevel': formalityLevel,
    'favoriteTopics': favoriteTopics,
    'positivityRate': positivityRate,
    'activeTimeSlots': activeTimeSlots,
    'importantDates': importantDates.map((d) => d.toIso8601String()).toList(),
  };
  
  factory UserPreference.fromJson(Map<String, dynamic> json) => UserPreference(
    userId: json['userId'],
    personaId: json['personaId'],
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
    emojiUsageLevel: (json['emojiUsageLevel'] ?? 0.5).toDouble(),
    averageMessageLength: json['averageMessageLength'] ?? 30,
    usesSlang: json['usesSlang'] ?? false,
    formalityLevel: (json['formalityLevel'] ?? 0.5).toDouble(),
    favoriteTopics: Map<String, int>.from(json['favoriteTopics'] ?? {}),
    positivityRate: (json['positivityRate'] ?? 0.7).toDouble(),
    activeTimeSlots: Map<String, int>.from(json['activeTimeSlots'] ?? {}),
    importantDates: (json['importantDates'] as List?)
        ?.map((d) => DateTime.parse(d))
        .toList() ?? [],
  );
}