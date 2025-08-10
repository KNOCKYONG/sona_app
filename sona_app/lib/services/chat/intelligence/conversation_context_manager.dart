import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../models/message.dart';
import '../intelligence/conversation_memory_service.dart';

/// 사용자가 이미 공유한 정보 추적
class UserKnowledge {
  final Map<String, dynamic> schedule = {}; // 일정 정보
  final Map<String, dynamic> preferences = {}; // 선호도 정보
  final Map<String, dynamic> personalInfo = {}; // 개인 정보
  final Map<String, dynamic> recentTopics = {}; // 최근 대화 주제
  final List<String> sharedActivities = []; // 공유한 활동들
  final DateTime lastUpdated = DateTime.now();
  
  // 정보가 이미 알려졌는지 확인
  bool hasScheduleInfo(String date) => schedule.containsKey(date);
  bool hasPreference(String category) => preferences.containsKey(category);
  bool hasPersonalInfo(String key) => personalInfo.containsKey(key);
  bool hasRecentTopic(String topic) => recentTopics.containsKey(topic);
  bool hasSharedActivity(String activity) => sharedActivities.contains(activity);
}

/// 대화 컨텍스트 관리자
/// 이미 공유된 정보를 추적하고 중복 질문을 방지
class ConversationContextManager {
  static ConversationContextManager? _instance;
  static ConversationContextManager get instance => _instance ??= ConversationContextManager._();
  
  ConversationContextManager._();
  
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // 메모리 캐시 (userId_personaId를 키로 사용)
  final Map<String, UserKnowledge> _knowledgeCache = {};
  
  /// 저장된 지식 가져오기
  UserKnowledge? getKnowledge(String userId, String personaId) {
    final key = '${userId}_$personaId';
    return _knowledgeCache[key];
  }
  
  /// 대화에서 정보 추출 및 저장
  Future<void> updateKnowledge({
    required String userId,
    required String personaId,
    required String userMessage,
    required String personaResponse,
    required List<Message> chatHistory,
  }) async {
    final key = '${userId}_$personaId';
    _knowledgeCache[key] ??= UserKnowledge();
    final knowledge = _knowledgeCache[key]!;
    
    // 1. 일정 정보 추출
    _extractScheduleInfo(userMessage, knowledge);
    
    // 2. 선호도 정보 추출
    _extractPreferences(userMessage, knowledge);
    
    // 3. 개인 정보 추출
    _extractPersonalInfo(userMessage, knowledge);
    
    // 4. 활동 정보 추출
    _extractActivities(userMessage, knowledge);
    
    // 5. 대화 주제 업데이트
    _updateRecentTopics(userMessage, knowledge);
    
    // Firestore에 저장 (비동기)
    _saveToFirestore(userId, personaId, knowledge).catchError((e) {
      debugPrint('Failed to save knowledge: $e');
    });
  }
  
  /// 중복 질문 체크 및 컨텍스트 힌트 생성 (압축된 형태)
  String? generateContextualHint({
    required String userId,
    required String personaId,
    required String userMessage,
    required List<Message> chatHistory,
    int maxLength = 300, // 최대 힌트 길이 제한
  }) {
    final key = '${userId}_$personaId';
    final knowledge = _knowledgeCache[key];
    
    if (knowledge == null) {
      return null;
    }
    
    final hints = <String>[];
    
    // 압축된 힌트 생성
    final compactHints = <String>[];
    
    // 1. 일정 관련 중복 체크 (압축)
    if (_isAskingAboutSchedule(userMessage)) {
      final scheduleHint = _checkScheduleDuplicationCompact(userMessage, knowledge);
      if (scheduleHint != null) compactHints.add(scheduleHint);
    }
    
    // 2. 취향/선호도 중복 체크 (압축)
    if (_isAskingAboutPreference(userMessage)) {
      final prefHint = _checkPreferenceDuplicationCompact(userMessage, knowledge);
      if (prefHint != null) compactHints.add(prefHint);
    }
    
    // 3. 개인정보 중복 체크 (압축)
    if (_isAskingAboutPersonalInfo(userMessage)) {
      final infoHint = _checkPersonalInfoDuplicationCompact(userMessage, knowledge);
      if (infoHint != null) compactHints.add(infoHint);
    }
    
    // 4. 최근 대화 주제 관련 (압축)
    final topicHint = _generateTopicContinuityHintCompact(userMessage, knowledge);
    if (topicHint != null) compactHints.add(topicHint);
    
    // 힌트 결합 및 길이 제한
    if (compactHints.isEmpty) return null;
    
    String combined = compactHints.join(' | ');
    if (combined.length > maxLength) {
      // 가장 중요한 힌트만 선택
      combined = compactHints.take(2).join(' | ');
      if (combined.length > maxLength) {
        combined = combined.substring(0, maxLength - 3) + '...';
      }
    }
    
    return combined;
  }
  
  /// 일정 정보 추출
  void _extractScheduleInfo(String message, UserKnowledge knowledge) {
    // 오늘/내일/주말 등의 일정 언급
    final schedulePatterns = [
      RegExp(r'오늘\s*(.+?)(?:해|할|했|합니다|예정|계획)', dotAll: true),
      RegExp(r'내일\s*(.+?)(?:해|할|했|합니다|예정|계획)', dotAll: true),
      RegExp(r'주말에?\s*(.+?)(?:해|할|했|합니다|예정|계획)', dotAll: true),
      RegExp(r'(\d+시)에?\s*(.+?)(?:해|할|했|합니다|예정|약속)', dotAll: true),
    ];
    
    for (final pattern in schedulePatterns) {
      final match = pattern.firstMatch(message);
      if (match != null) {
        final timeKey = match.group(1) ?? 'today';
        final activity = match.group(2) ?? match.group(1) ?? '';
        
        if (activity.isNotEmpty) {
          knowledge.schedule[timeKey] = {
            'activity': activity.trim(),
            'mentionedAt': DateTime.now(),
          };
        }
      }
    }
  }
  
  /// 선호도 정보 추출
  void _extractPreferences(String message, UserKnowledge knowledge) {
    // 좋아하는/싫어하는 것들
    final preferencePatterns = [
      RegExp(r'(.+?)(?:을|를)?\s*좋아해'),
      RegExp(r'(.+?)(?:이|가)?\s*좋아'),
      RegExp(r'(.+?)(?:을|를)?\s*싫어해'),
      RegExp(r'(.+?)(?:이|가)?\s*싫어'),
      RegExp(r'제일 좋아하는\s*(.+?)(?:은|는|이|가)'),
    ];
    
    for (final pattern in preferencePatterns) {
      final match = pattern.firstMatch(message);
      if (match != null) {
        final item = match.group(1);
        if (item != null && item.length < 20) {
          final isPositive = message.contains('좋아');
          knowledge.preferences[item] = {
            'sentiment': isPositive ? 'like' : 'dislike',
            'mentionedAt': DateTime.now(),
          };
        }
      }
    }
  }
  
  /// 개인 정보 추출
  void _extractPersonalInfo(String message, UserKnowledge knowledge) {
    // 직업, 나이, 사는 곳 등
    final infoPatterns = {
      'job': RegExp(r'(?:직업|일)(?:은|는)?\s*(.+?)(?:이에요|예요|입니다|야|이야)'),
      'age': RegExp(r'(\d+)살|(\d+)세'),
      'location': RegExp(r'(.+?)에?\s*살아'),
      'name': RegExp(r'(?:이름|내 이름)(?:은|는)?\s*(.+?)(?:이에요|예요|입니다|야|이야)'),
    };
    
    infoPatterns.forEach((key, pattern) {
      final match = pattern.firstMatch(message);
      if (match != null) {
        final value = match.group(1) ?? match.group(2);
        if (value != null) {
          knowledge.personalInfo[key] = {
            'value': value,
            'mentionedAt': DateTime.now(),
          };
        }
      }
    });
  }
  
  /// 활동 정보 추출
  void _extractActivities(String message, UserKnowledge knowledge) {
    // ~하고 있어, ~했어, ~할거야 패턴
    final activityPatterns = [
      RegExp(r'(.+?)(?:하고 있어|하는 중|중이야)'),
      RegExp(r'(.+?)(?:했어|했다|했음)'),
      RegExp(r'(.+?)(?:할거야|할 예정|할게)'),
    ];
    
    for (final pattern in activityPatterns) {
      final match = pattern.firstMatch(message);
      if (match != null) {
        final activity = match.group(1);
        if (activity != null && activity.length < 30) {
          if (!knowledge.hasSharedActivity(activity)) {
            knowledge.sharedActivities.add(activity.trim());
            if (knowledge.sharedActivities.length > 20) {
              knowledge.sharedActivities.removeAt(0); // 오래된 것 제거
            }
          }
        }
      }
    }
  }
  
  /// 최근 대화 주제 업데이트
  void _updateRecentTopics(String message, UserKnowledge knowledge) {
    // 주요 키워드 추출
    final keywords = _extractKeywords(message);
    
    for (final keyword in keywords) {
      knowledge.recentTopics[keyword] = {
        'count': (knowledge.recentTopics[keyword]?['count'] ?? 0) + 1,
        'lastMentioned': DateTime.now(),
      };
    }
    
    // 오래된 주제 제거 (1시간 이상)
    knowledge.recentTopics.removeWhere((key, value) {
      final lastMentionedObj = value['lastMentioned'];
      final DateTime lastMentioned;
      
      // Timestamp를 DateTime으로 변환
      if (lastMentionedObj is DateTime) {
        lastMentioned = lastMentionedObj;
      } else if (lastMentionedObj != null) {
        // Firebase Timestamp의 경우 toDate() 메서드 사용
        try {
          lastMentioned = (lastMentionedObj as dynamic).toDate();
        } catch (e) {
          // 변환 실패 시 현재 시간 사용
          return false;
        }
      } else {
        return false;
      }
      
      return DateTime.now().difference(lastMentioned).inHours > 1;
    });
  }
  
  /// 주요 키워드 추출
  List<String> _extractKeywords(String text) {
    // 명사와 주요 동사 추출 (간단한 구현)
    final keywords = <String>[];
    final words = text.split(RegExp(r'\s+'));
    
    for (final word in words) {
      // 2글자 이상의 의미있는 단어
      if (word.length >= 2 && 
          !['그래', '네', '응', '아니', '근데', '그런데', '하지만'].contains(word)) {
        keywords.add(word);
      }
    }
    
    return keywords.take(5).toList(); // 최대 5개
  }
  
  /// 일정 질문인지 확인
  bool _isAskingAboutSchedule(String message) {
    final patterns = ['뭐해', '뭐하', '뭐 해', '일정', '계획', '예정', '언제'];
    return patterns.any((p) => message.contains(p));
  }
  
  /// 선호도 질문인지 확인
  bool _isAskingAboutPreference(String message) {
    final patterns = ['좋아해', '좋아하', '싫어해', '싫어하', '취향', '어때'];
    return patterns.any((p) => message.contains(p));
  }
  
  /// 개인정보 질문인지 확인
  bool _isAskingAboutPersonalInfo(String message) {
    final patterns = ['이름', '나이', '몇살', '직업', '일', '사는', '어디'];
    return patterns.any((p) => message.contains(p));
  }
  
  /// 일정 중복 체크 (압축)
  String? _checkScheduleDuplicationCompact(String message, UserKnowledge knowledge) {
    if (message.contains('오늘') && knowledge.hasScheduleInfo('today')) {
      final info = knowledge.schedule['today'];
      return '📅오늘:${info['activity']}';
    }
    
    if (message.contains('내일') && knowledge.hasScheduleInfo('tomorrow')) {
      final info = knowledge.schedule['tomorrow'];
      return '📅내일:${info['activity']}';
    }
    
    return null;
  }
  
  /// 일정 중복 체크 (원본 - 필요시 사용)
  String? _checkScheduleDuplication(String message, UserKnowledge knowledge) {
    if (message.contains('오늘') && knowledge.hasScheduleInfo('today')) {
      final info = knowledge.schedule['today'];
      return '⚠️ 사용자가 이미 오늘 "${info['activity']}" 한다고 언급함. 이를 기억하고 자연스럽게 언급하세요.';
    }
    
    if (message.contains('내일') && knowledge.hasScheduleInfo('tomorrow')) {
      final info = knowledge.schedule['tomorrow'];
      return '⚠️ 사용자가 이미 내일 "${info['activity']}" 예정이라고 언급함. 다시 묻지 마세요.';
    }
    
    return null;
  }
  
  /// 선호도 중복 체크 (압축)
  String? _checkPreferenceDuplicationCompact(String message, UserKnowledge knowledge) {
    for (final entry in knowledge.preferences.entries) {
      if (message.contains(entry.key)) {
        final sentiment = entry.value['sentiment'];
        return '💚${entry.key}:${sentiment == 'like' ? '👍' : '👎'}';
      }
    }
    return null;
  }
  
  /// 선호도 중복 체크 (원본)
  String? _checkPreferenceDuplication(String message, UserKnowledge knowledge) {
    for (final entry in knowledge.preferences.entries) {
      if (message.contains(entry.key)) {
        final sentiment = entry.value['sentiment'];
        return '⚠️ 사용자가 "${entry.key}"를 ${sentiment == 'like' ? '좋아한다' : '싫어한다'}고 이미 언급함. 이를 활용하여 대화하세요.';
      }
    }
    return null;
  }
  
  /// 개인정보 중복 체크 (압축)
  String? _checkPersonalInfoDuplicationCompact(String message, UserKnowledge knowledge) {
    final infos = <String>[];
    
    if (message.contains('이름') && knowledge.hasPersonalInfo('name')) {
      infos.add('이름:${knowledge.personalInfo['name']['value']}');
    }
    
    if ((message.contains('나이') || message.contains('몇살')) && knowledge.hasPersonalInfo('age')) {
      infos.add('${knowledge.personalInfo['age']['value']}살');
    }
    
    if (message.contains('직업') && knowledge.hasPersonalInfo('job')) {
      infos.add('직업:${knowledge.personalInfo['job']['value']}');
    }
    
    return infos.isEmpty ? null : '👤${infos.join(',')}';
  }
  
  /// 개인정보 중복 체크 (원본)
  String? _checkPersonalInfoDuplication(String message, UserKnowledge knowledge) {
    if (message.contains('이름') && knowledge.hasPersonalInfo('name')) {
      final name = knowledge.personalInfo['name']['value'];
      return '⚠️ 사용자 이름 "$name" 이미 알고 있음. 다시 묻지 마세요.';
    }
    
    if ((message.contains('나이') || message.contains('몇살')) && knowledge.hasPersonalInfo('age')) {
      final age = knowledge.personalInfo['age']['value'];
      return '⚠️ 사용자 나이 "$age"살 이미 알고 있음. 자연스럽게 활용하세요.';
    }
    
    if (message.contains('직업') && knowledge.hasPersonalInfo('job')) {
      final job = knowledge.personalInfo['job']['value'];
      return '⚠️ 사용자 직업 "$job" 이미 알고 있음. 관련 대화로 이어가세요.';
    }
    
    return null;
  }
  
  /// 주제 연속성 힌트 생성 (압축)
  String? _generateTopicContinuityHintCompact(String message, UserKnowledge knowledge) {
    final frequentTopics = knowledge.recentTopics.entries
        .where((e) => (e.value['count'] as int) >= 2)
        .map((e) => e.key)
        .take(3)
        .toList();
    
    if (frequentTopics.isNotEmpty) {
      return '💭${frequentTopics.join(',')}';
    }
    
    return null;
  }
  
  /// 주제 연속성 힌트 생성 (원본)
  String? _generateTopicContinuityHint(String message, UserKnowledge knowledge) {
    // 최근 자주 언급된 주제 찾기
    final frequentTopics = knowledge.recentTopics.entries
        .where((e) => (e.value['count'] as int) >= 2)
        .map((e) => e.key)
        .toList();
    
    if (frequentTopics.isNotEmpty) {
      return '💭 최근 대화 주제: ${frequentTopics.take(3).join(', ')}. 관련 맥락 유지하며 자연스럽게 대화 이어가기.';
    }
    
    return null;
  }
  
  /// Firestore에 저장
  Future<void> _saveToFirestore(String userId, String personaId, UserKnowledge knowledge) async {
    try {
      await _firestore
          .collection('user_knowledge')
          .doc('${userId}_$personaId')
          .set({
        'schedule': knowledge.schedule,
        'preferences': knowledge.preferences,
        'personalInfo': knowledge.personalInfo,
        'recentTopics': knowledge.recentTopics,
        'sharedActivities': knowledge.sharedActivities,
        'lastUpdated': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Error saving knowledge: $e');
    }
  }
  
  /// 압축된 지식 요약 생성 (토큰 절약용)
  String getCompactKnowledgeSummary(String userId, String personaId) {
    final key = '${userId}_$personaId';
    final knowledge = _knowledgeCache[key];
    
    if (knowledge == null) return '';
    
    final parts = <String>[];
    
    // 최근 활동 (최대 3개)
    if (knowledge.sharedActivities.isNotEmpty) {
      final recent = knowledge.sharedActivities.take(3).join(',');
      parts.add('📝$recent');
    }
    
    // 주요 선호도 (최대 3개)
    final likes = knowledge.preferences.entries
        .where((e) => e.value['sentiment'] == 'like')
        .take(3)
        .map((e) => e.key);
    if (likes.isNotEmpty) {
      parts.add('💚${likes.join(',')}');
    }
    
    // 개인정보 요약
    final personalParts = <String>[];
    if (knowledge.hasPersonalInfo('age')) {
      personalParts.add('${knowledge.personalInfo['age']['value']}살');
    }
    if (knowledge.hasPersonalInfo('job')) {
      personalParts.add(knowledge.personalInfo['job']['value']);
    }
    if (personalParts.isNotEmpty) {
      parts.add('👤${personalParts.join(',')}');
    }
    
    return parts.join(' | ');
  }
  
  /// Firestore에서 로드
  Future<void> loadKnowledge(String userId, String personaId) async {
    try {
      final doc = await _firestore
          .collection('user_knowledge')
          .doc('${userId}_$personaId')
          .get();
      
      if (doc.exists) {
        final data = doc.data()!;
        final key = '${userId}_$personaId';
        final knowledge = UserKnowledge();
        
        // 데이터 복원
        if (data['schedule'] != null) {
          knowledge.schedule.addAll(Map<String, dynamic>.from(data['schedule']));
        }
        if (data['preferences'] != null) {
          knowledge.preferences.addAll(Map<String, dynamic>.from(data['preferences']));
        }
        if (data['personalInfo'] != null) {
          knowledge.personalInfo.addAll(Map<String, dynamic>.from(data['personalInfo']));
        }
        if (data['recentTopics'] != null) {
          knowledge.recentTopics.addAll(Map<String, dynamic>.from(data['recentTopics']));
        }
        if (data['sharedActivities'] != null) {
          knowledge.sharedActivities.addAll(List<String>.from(data['sharedActivities']));
        }
        
        _knowledgeCache[key] = knowledge;
      }
    } catch (e) {
      debugPrint('Error loading knowledge: $e');
    }
  }
}