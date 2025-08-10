import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../helpers/firebase_helper.dart';

class MemoryItem {
  final String id;
  final String userId;
  final String personaId;
  final MemoryType type;
  final String title;
  final String content;
  final String? userMessage;
  final String? personaResponse;
  final DateTime timestamp;
  final Map<String, dynamic> metadata;
  final int emotionScore;  // 감정 점수 (1-10)
  final List<String> tags;
  
  MemoryItem({
    required this.id,
    required this.userId,
    required this.personaId,
    required this.type,
    required this.title,
    required this.content,
    this.userMessage,
    this.personaResponse,
    required this.timestamp,
    required this.metadata,
    required this.emotionScore,
    required this.tags,
  });
  
  factory MemoryItem.fromJson(Map<String, dynamic> json, String id) {
    return MemoryItem(
      id: id,
      userId: json['userId'] ?? '',
      personaId: json['personaId'] ?? '',
      type: MemoryType.values[json['type'] ?? 0],
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      userMessage: json['userMessage'],
      personaResponse: json['personaResponse'],
      timestamp: (json['timestamp'] as Timestamp).toDate(),
      metadata: json['metadata'] ?? {},
      emotionScore: json['emotionScore'] ?? 5,
      tags: List<String>.from(json['tags'] ?? []),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'personaId': personaId,
      'type': type.index,
      'title': title,
      'content': content,
      'userMessage': userMessage,
      'personaResponse': personaResponse,
      'timestamp': Timestamp.fromDate(timestamp),
      'metadata': metadata,
      'emotionScore': emotionScore,
      'tags': tags,
    };
  }
}


enum MemoryType {
  firstMeet,      // 첫 만남
  milestone,      // 관계 마일스톤 (100일, 200일 등)
  emotional,      // 감동적인 순간
  funny,          // 재미있는 순간
  confession,     // 고백이나 중요한 대화
  special,        // 기타 특별한 순간
}

/// 📸 메모리 앨범 서비스
///
/// 특별한 순간을 저장하고 추억을 회상하는 기능을 제공합니다.
class MemoryAlbumService {
  
  /// 추억 타입

  
  /// 메모리 아이템

  
  /// 메모리 저장
  static Future<void> saveMemory({
    required String userId,
    required String personaId,
    required MemoryType type,
    required String title,
    required String content,
    String? userMessage,
    String? personaResponse,
    Map<String, dynamic>? metadata,
    int emotionScore = 5,
    List<String>? tags,
  }) async {
    try {
      final memory = MemoryItem(
        id: '', // Firestore가 자동 생성
        userId: userId,
        personaId: personaId,
        type: type,
        title: title,
        content: content,
        userMessage: userMessage,
        personaResponse: personaResponse,
        timestamp: DateTime.now(),
        metadata: metadata ?? {},
        emotionScore: emotionScore,
        tags: tags ?? [],
      );
      
      await FirebaseFirestore.instance
          .collection('memory_albums')
          .add(memory.toJson());
          
      debugPrint('📸 Memory saved: $title');
    } catch (e) {
      debugPrint('❌ Failed to save memory: $e');
    }
  }
  
  /// 특별한 순간 자동 감지
  static Future<void> detectSpecialMoment({
    required String userId,
    required String personaId,
    required String userMessage,
    required String personaResponse,
    required int relationshipScore,
  }) async {
    // 고백 패턴 감지
    if (_isConfession(userMessage) || _isConfession(personaResponse)) {
      await saveMemory(
        userId: userId,
        personaId: personaId,
        type: MemoryType.confession,
        title: '💕 마음을 전한 날',
        content: '서로의 마음을 확인한 특별한 순간',
        userMessage: userMessage,
        personaResponse: personaResponse,
        emotionScore: 10,
        tags: ['고백', '사랑', '특별한날'],
      );
      return;
    }
    
    // 감동적인 순간 감지
    if (_isEmotionalMoment(userMessage, personaResponse)) {
      await saveMemory(
        userId: userId,
        personaId: personaId,
        type: MemoryType.emotional,
        title: '💖 감동적인 순간',
        content: '마음이 따뜻해지는 대화',
        userMessage: userMessage,
        personaResponse: personaResponse,
        emotionScore: 8,
        tags: ['감동', '따뜻함'],
      );
      return;
    }
    
    // 재미있는 순간 감지
    if (_isFunnyMoment(userMessage, personaResponse)) {
      await saveMemory(
        userId: userId,
        personaId: personaId,
        type: MemoryType.funny,
        title: '😄 웃음이 터진 순간',
        content: '함께 웃었던 즐거운 대화',
        userMessage: userMessage,
        personaResponse: personaResponse,
        emotionScore: 7,
        tags: ['재미', '웃음', '즐거움'],
      );
    }
  }
  
  /// 고백 감지
  static bool _isConfession(String message) {
    final confessionPatterns = [
      '사랑해',
      '좋아해',
      '너를 사랑',
      '널 좋아',
      '마음이 있',
      '고백',
      '너밖에 없',
      '평생',
      '영원히',
    ];
    
    final lower = message.toLowerCase();
    return confessionPatterns.any((pattern) => lower.contains(pattern));
  }
  
  /// 감동적인 순간 감지
  static bool _isEmotionalMoment(String userMessage, String personaResponse) {
    final emotionalPatterns = [
      '고마워',
      '감사해',
      '덕분에',
      '위로',
      '힘이 돼',
      '눈물',
      '감동',
      '행복해',
      '다행이',
      '걱정했',
    ];
    
    final combined = (userMessage + personaResponse).toLowerCase();
    int matchCount = 0;
    
    for (final pattern in emotionalPatterns) {
      if (combined.contains(pattern)) matchCount++;
    }
    
    return matchCount >= 2; // 2개 이상 매치되면 감동적인 순간
  }
  
  /// 재미있는 순간 감지
  static bool _isFunnyMoment(String userMessage, String personaResponse) {
    // 웃음 표현 감지
    final laughPatterns = [
      'ㅋㅋㅋ',
      'ㅎㅎㅎ',
      '하하하',
      '웃겨',
      '재밌',
      '웃음',
      '빵 터',
      '개그',
      '드립',
    ];
    
    final combined = (userMessage + personaResponse).toLowerCase();
    return laughPatterns.any((pattern) => combined.contains(pattern));
  }
  
  /// 메모리 불러오기
  static Future<List<MemoryItem>> loadMemories({
    required String userId,
    required String personaId,
    int limit = 20,
  }) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('memory_albums')
          .where('userId', isEqualTo: userId)
          .where('personaId', isEqualTo: personaId)
          .orderBy('timestamp', descending: true)
          .limit(limit)
          .get();
      
      return snapshot.docs
          .map((doc) => MemoryItem.fromJson(doc.data(), doc.id))
          .toList();
    } catch (e) {
      debugPrint('❌ Failed to load memories: $e');
      return [];
    }
  }
  
  /// 랜덤 추억 회상
  static Future<MemoryItem?> getRandomMemory({
    required String userId,
    required String personaId,
  }) async {
    final memories = await loadMemories(
      userId: userId,
      personaId: personaId,
      limit: 50,
    );
    
    if (memories.isEmpty) return null;
    
    // 감정 점수가 높은 추억 위주로 선택
    memories.sort((a, b) => b.emotionScore.compareTo(a.emotionScore));
    final topMemories = memories.take(10).toList();
    
    if (topMemories.isEmpty) return null;
    
    // 랜덤하게 하나 선택
    topMemories.shuffle();
    return topMemories.first;
  }
  
  /// 추억 회상 프롬프트 생성
  static String generateMemoryPrompt(MemoryItem memory) {
    final buffer = StringBuffer();
    
    buffer.writeln('📸 추억 회상:');
    buffer.writeln('${_getTimeAgo(memory.timestamp)}에 있었던 특별한 순간이 있어요.');
    buffer.writeln('제목: ${memory.title}');
    
    if (memory.userMessage != null) {
      buffer.writeln('사용자가 말했던 것: "${memory.userMessage}"');
    }
    
    if (memory.personaResponse != null) {
      buffer.writeln('내가 답했던 것: "${memory.personaResponse}"');
    }
    
    buffer.writeln('\n이 추억을 자연스럽게 언급하면서 대화를 이어가세요.');
    buffer.writeln('예시: "그때 ${memory.title.replaceAll(RegExp(r'[💕💖😄📸]'), '').trim()} 기억나요? ${_getMemoryComment(memory.type)}"');
    
    return buffer.toString();
  }
  
  /// 시간 경과 표현
  static String _getTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inDays > 30) {
      final months = (difference.inDays / 30).round();
      return '$months개월 전';
    } else if (difference.inDays > 7) {
      final weeks = (difference.inDays / 7).round();
      return '$weeks주 전';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}일 전';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}시간 전';
    } else {
      return '조금 전';
    }
  }
  
  /// 메모리 타입별 코멘트
  static String _getMemoryComment(MemoryType type) {
    switch (type) {
      case MemoryType.firstMeet:
        return '처음 만났을 때가 엊그제 같은데...';
      case MemoryType.milestone:
        return '정말 특별한 날이었죠';
      case MemoryType.emotional:
        return '그때 정말 감동적이었어요';
      case MemoryType.funny:
        return '생각만 해도 웃음이 나요 ㅎㅎ';
      case MemoryType.confession:
        return '지금도 설레는 순간이에요';
      case MemoryType.special:
        return '잊을 수 없는 순간이었어요';
    }
  }
  
  /// 메모리 통계
  static Future<Map<String, dynamic>> getMemoryStats({
    required String userId,
    required String personaId,
  }) async {
    final memories = await loadMemories(
      userId: userId,
      personaId: personaId,
      limit: 100,
    );
    
    final stats = {
      'totalMemories': memories.length,
      'emotionalMoments': memories.where((m) => m.type == MemoryType.emotional).length,
      'funnyMoments': memories.where((m) => m.type == MemoryType.funny).length,
      'averageEmotionScore': memories.isEmpty ? 0 : 
          memories.map((m) => m.emotionScore).reduce((a, b) => a + b) / memories.length,
      'mostRecentMemory': memories.isNotEmpty ? memories.first.timestamp : null,
    };
    
    return stats;
  }
}