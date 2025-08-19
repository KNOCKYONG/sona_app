import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../models/message.dart';
import '../../../models/persona.dart';
import '../intelligence/conversation_memory_service.dart';
import '../../../core/constants.dart';

/// 🧠 영구 메모리 시스템
/// 
/// 30일 제한을 넘어 영구적으로 대화를 기억하는 시스템
/// - 중요 메모리 영구 저장
/// - 관계 이정표 기록
/// - 핵심 정보 압축 저장
/// - 추억 앨범 기능
class PersistentMemorySystem {
  static PersistentMemorySystem? _instance;
  static PersistentMemorySystem get instance => 
      _instance ??= PersistentMemorySystem._();
  
  PersistentMemorySystem._();
  
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ConversationMemoryService _memoryService = ConversationMemoryService();
  
  // 컬렉션 이름
  static const String _permanentMemories = 'permanent_memories';
  static const String _relationshipMilestones = 'relationship_milestones';
  static const String _userProfiles = 'user_memory_profiles';
  static const String _sharedMemories = 'shared_memories';
  
  // 메모리 등급 (영구 저장 기준)
  static const double PERMANENT_THRESHOLD = 0.8;  // 중요도 80% 이상
  static const double MILESTONE_THRESHOLD = 0.9;  // 이정표 90% 이상
  
  /// 🔄 대화를 영구 메모리로 변환
  Future<void> convertToPermamentMemory({
    required String userId,
    required String personaId,
    required List<Message> messages,
    required Map<String, dynamic> conversationState,
  }) async {
    try {
      // 1. 중요 메모리 추출
      final importantMemories = await _memoryService.extractImportantMemories(
        messages: messages,
        userId: userId,
        personaId: personaId,
      );
      
      // 2. 영구 저장할 메모리 선별
      final permanentMemories = importantMemories
          .where((m) => m.importance >= PERMANENT_THRESHOLD)
          .toList();
      
      if (permanentMemories.isEmpty) return;
      
      // 3. 메모리 압축 및 카테고리화
      final compressedMemories = _compressMemories(permanentMemories);
      final categorizedMemories = _categorizeMemories(compressedMemories);
      
      // 4. Firebase에 영구 저장
      final batch = _firestore.batch();
      
      for (final category in categorizedMemories.entries) {
        final docRef = _firestore
            .collection(_permanentMemories)
            .doc('${userId}_${personaId}')
            .collection(category.key)
            .doc();
        
        batch.set(docRef, {
          'memories': category.value.map((m) => m.toCompressedMap()).toList(),
          'timestamp': FieldValue.serverTimestamp(),
          'messageCount': messages.length,
          'relationshipLevel': conversationState['relationshipLevel'] ?? 0,
          'topics': conversationState['topics'] ?? [],
          'metadata': {
            'userId': userId,
            'personaId': personaId,
            'extractedAt': DateTime.now().toIso8601String(),
          },
        });
      }
      
      // 5. 관계 이정표 체크 및 저장
      await _checkAndSaveMilestones(
        userId: userId,
        personaId: personaId,
        memories: permanentMemories,
        state: conversationState,
      );
      
      // 6. 사용자 프로필 업데이트
      await _updateUserMemoryProfile(
        userId: userId,
        personaId: personaId,
        newMemories: permanentMemories,
      );
      
      await batch.commit();
      debugPrint('💾 Saved ${permanentMemories.length} permanent memories');
      
    } catch (e) {
      debugPrint('❌ Error saving permanent memories: $e');
    }
  }
  
  /// 📚 영구 메모리 로드
  Future<Map<String, dynamic>> loadPermanentMemories({
    required String userId,
    required String personaId,
    DateTime? since,
    int limit = 50,
  }) async {
    try {
      final memories = <String, List<CompressedMemory>>{};
      
      // 모든 카테고리에서 메모리 로드
      final categories = ['emotional', 'factual', 'relational', 'special'];
      
      for (final category in categories) {
        Query query = _firestore
            .collection(_permanentMemories)
            .doc('${userId}_${personaId}')
            .collection(category)
            .orderBy('timestamp', descending: true)
            .limit(limit);
        
        if (since != null) {
          query = query.where('timestamp', isGreaterThan: since);
        }
        
        final snapshot = await query.get();
        
        final categoryMemories = <CompressedMemory>[];
        for (final doc in snapshot.docs) {
          final data = doc.data() as Map<String, dynamic>;
          final memoriesList = data['memories'] as List<dynamic>;
          
          for (final memData in memoriesList) {
            categoryMemories.add(
              CompressedMemory.fromMap(memData as Map<String, dynamic>)
            );
          }
        }
        
        if (categoryMemories.isNotEmpty) {
          memories[category] = categoryMemories;
        }
      }
      
      // 관계 이정표 로드
      final milestones = await _loadMilestones(userId, personaId);
      
      // 사용자 프로필 로드
      final profile = await _loadUserProfile(userId, personaId);
      
      return {
        'memories': memories,
        'milestones': milestones,
        'profile': profile,
        'totalMemories': memories.values.fold(0, (sum, list) => sum + list.length),
      };
    } catch (e) {
      debugPrint('❌ Error loading permanent memories: $e');
      return {};
    }
  }
  
  /// 🎯 특정 주제/감정 관련 메모리 검색
  Future<List<CompressedMemory>> searchMemories({
    required String userId,
    required String personaId,
    String? topic,
    String? emotion,
    DateTime? dateRange,
  }) async {
    final results = <CompressedMemory>[];
    
    try {
      // 카테고리 결정
      String? targetCategory;
      if (emotion != null) {
        targetCategory = 'emotional';
      } else if (topic != null) {
        targetCategory = 'factual';
      }
      
      // 쿼리 구성
      Query query = _firestore
          .collection(_permanentMemories)
          .doc('${userId}_${personaId}')
          .collection(targetCategory ?? 'all');
      
      if (dateRange != null) {
        query = query.where('timestamp', isGreaterThan: dateRange);
      }
      
      final snapshot = await query.get();
      
      for (final doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final memoriesList = data['memories'] as List<dynamic>;
        
        for (final memData in memoriesList) {
          final memory = CompressedMemory.fromMap(memData as Map<String, dynamic>);
          
          // 필터링
          bool matches = true;
          if (topic != null && !memory.topics.contains(topic)) {
            matches = false;
          }
          if (emotion != null && memory.emotion != emotion) {
            matches = false;
          }
          
          if (matches) {
            results.add(memory);
          }
        }
      }
      
    } catch (e) {
      debugPrint('❌ Error searching memories: $e');
    }
    
    return results;
  }
  
  /// 💝 공유 추억 생성
  Future<void> createSharedMemory({
    required String userId,
    required String personaId,
    required String title,
    required String content,
    required DateTime date,
    String? imageUrl,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      await _firestore.collection(_sharedMemories).add({
        'userId': userId,
        'personaId': personaId,
        'title': title,
        'content': content,
        'date': date,
        'imageUrl': imageUrl,
        'metadata': metadata ?? {},
        'createdAt': FieldValue.serverTimestamp(),
        'isSpecial': true,
      });
      
      debugPrint('💝 Created shared memory: $title');
    } catch (e) {
      debugPrint('❌ Error creating shared memory: $e');
    }
  }
  
  /// 🏆 관계 이정표 체크 및 저장
  Future<void> _checkAndSaveMilestones({
    required String userId,
    required String personaId,
    required List<ConversationMemory> memories,
    required Map<String, dynamic> state,
  }) async {
    final relationshipLevel = state['relationshipLevel'] ?? 0;
    final topics = state['topics'] ?? [];
    
    // 이정표 조건 체크
    final milestones = <Map<String, dynamic>>[];
    
    // 첫 만남
    final firstMeetingQuery = await _firestore
        .collection(_relationshipMilestones)
        .doc('${userId}_${personaId}')
        .collection('milestones')
        .where('type', isEqualTo: 'first_meeting')
        .get();
    
    if (firstMeetingQuery.docs.isEmpty && memories.isNotEmpty) {
      milestones.add({
        'type': 'first_meeting',
        'title': '첫 만남',
        'description': '우리가 처음 만난 날',
        'date': memories.first.timestamp,
        'relationshipLevel': 0,
      });
    }
    
    // 관계 레벨 이정표
    final levelMilestones = {
      50: '친구가 된 날',
      100: '가까운 친구',
      200: '특별한 사이',
      500: '썸타는 사이',
      1000: '연인',
    };
    
    for (final entry in levelMilestones.entries) {
      if (relationshipLevel >= entry.key) {
        final existingQuery = await _firestore
            .collection(_relationshipMilestones)
            .doc('${userId}_${personaId}')
            .collection('milestones')
            .where('type', isEqualTo: 'level_${entry.key}')
            .get();
        
        if (existingQuery.docs.isEmpty) {
          milestones.add({
            'type': 'level_${entry.key}',
            'title': entry.value,
            'description': '관계 레벨 ${entry.key} 달성',
            'date': DateTime.now(),
            'relationshipLevel': entry.key,
          });
        }
      }
    }
    
    // 특별한 순간들
    for (final memory in memories) {
      if (memory.importance >= MILESTONE_THRESHOLD) {
        // 감정적으로 중요한 순간
        if (memory.emotion == EmotionType.love || 
            memory.emotion == EmotionType.excited) {
          milestones.add({
            'type': 'emotional_moment',
            'title': '특별한 순간',
            'description': memory.content.substring(0, 50),
            'date': memory.timestamp,
            'emotion': memory.emotion.name,
            'importance': memory.importance,
          });
        }
      }
    }
    
    // 이정표 저장
    if (milestones.isNotEmpty) {
      final batch = _firestore.batch();
      
      for (final milestone in milestones) {
        final docRef = _firestore
            .collection(_relationshipMilestones)
            .doc('${userId}_${personaId}')
            .collection('milestones')
            .doc();
        
        batch.set(docRef, {
          ...milestone,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
      
      await batch.commit();
      debugPrint('🏆 Saved ${milestones.length} milestones');
    }
  }
  
  /// 📊 사용자 메모리 프로필 업데이트
  Future<void> _updateUserMemoryProfile({
    required String userId,
    required String personaId,
    required List<ConversationMemory> newMemories,
  }) async {
    try {
      final profileRef = _firestore
          .collection(_userProfiles)
          .doc('${userId}_${personaId}');
      
      final doc = await profileRef.get();
      
      if (doc.exists) {
        // 기존 프로필 업데이트
        final data = doc.data()!;
        final totalMemories = (data['totalMemories'] ?? 0) + newMemories.length;
        final topics = Set<String>.from(data['topics'] ?? []);
        final emotions = Map<String, int>.from(data['emotionCounts'] ?? {});
        
        // 새 메모리 정보 추가
        for (final memory in newMemories) {
          topics.addAll(memory.tags);
          emotions[memory.emotion.name] = (emotions[memory.emotion.name] ?? 0) + 1;
        }
        
        await profileRef.update({
          'totalMemories': totalMemories,
          'topics': topics.toList(),
          'emotionCounts': emotions,
          'lastUpdated': FieldValue.serverTimestamp(),
        });
      } else {
        // 새 프로필 생성
        final topics = <String>{};
        final emotions = <String, int>{};
        
        for (final memory in newMemories) {
          topics.addAll(memory.tags);
          emotions[memory.emotion.name] = (emotions[memory.emotion.name] ?? 0) + 1;
        }
        
        await profileRef.set({
          'userId': userId,
          'personaId': personaId,
          'totalMemories': newMemories.length,
          'topics': topics.toList(),
          'emotionCounts': emotions,
          'createdAt': FieldValue.serverTimestamp(),
          'lastUpdated': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      debugPrint('❌ Error updating user memory profile: $e');
    }
  }
  
  /// 🗜️ 메모리 압축
  List<CompressedMemory> _compressMemories(List<ConversationMemory> memories) {
    return memories.map((m) => CompressedMemory(
      id: m.id,
      essence: _extractEssence(m.content),
      emotion: m.emotion.name,
      importance: m.importance,
      topics: m.tags,
      timestamp: m.timestamp,
      metadata: {
        'originalLength': m.content.length,
        'likesChange': m.likesChange,
      },
    )).toList();
  }
  
  /// 📁 메모리 카테고리화
  Map<String, List<CompressedMemory>> _categorizeMemories(
    List<CompressedMemory> memories
  ) {
    final categorized = <String, List<CompressedMemory>>{
      'emotional': [],
      'factual': [],
      'relational': [],
      'special': [],
    };
    
    for (final memory in memories) {
      // 감정적 메모리
      if (['love', 'excited', 'sad'].contains(memory.emotion)) {
        categorized['emotional']!.add(memory);
      }
      
      // 사실적 메모리 (정보 포함)
      if (memory.topics.any((t) => 
          ['나이', '직업', '취미', '일정'].contains(t))) {
        categorized['factual']!.add(memory);
      }
      
      // 관계적 메모리
      if (memory.importance >= 0.85) {
        categorized['relational']!.add(memory);
      }
      
      // 특별한 메모리
      if (memory.importance >= MILESTONE_THRESHOLD) {
        categorized['special']!.add(memory);
      }
    }
    
    return categorized;
  }
  
  /// 💎 핵심 내용 추출
  String _extractEssence(String content) {
    // 긴 내용을 핵심만 추출
    if (content.length <= 100) return content;
    
    // 중요 키워드 우선 보존
    final keywords = ['사랑', '좋아', '행복', '약속', '함께', '영원'];
    final hasKeyword = keywords.any((k) => content.contains(k));
    
    if (hasKeyword) {
      // 키워드 주변 문맥 보존
      for (final keyword in keywords) {
        if (content.contains(keyword)) {
          final index = content.indexOf(keyword);
          final start = (index - 20).clamp(0, content.length);
          final end = (index + 50).clamp(0, content.length);
          return '...${content.substring(start, end)}...';
        }
      }
    }
    
    // 앞뒤 중요 부분만 보존
    return '${content.substring(0, 50)}...${content.substring(content.length - 30)}';
  }
  
  /// 🏆 이정표 로드
  Future<List<Map<String, dynamic>>> _loadMilestones(
    String userId,
    String personaId
  ) async {
    try {
      final snapshot = await _firestore
          .collection(_relationshipMilestones)
          .doc('${userId}_${personaId}')
          .collection('milestones')
          .orderBy('date', descending: true)
          .get();
      
      return snapshot.docs.map((doc) => {
        'id': doc.id,
        ...doc.data(),
      }).toList();
    } catch (e) {
      debugPrint('❌ Error loading milestones: $e');
      return [];
    }
  }
  
  /// 👤 사용자 프로필 로드
  Future<Map<String, dynamic>?> _loadUserProfile(
    String userId,
    String personaId
  ) async {
    try {
      final doc = await _firestore
          .collection(_userProfiles)
          .doc('${userId}_${personaId}')
          .get();
      
      if (doc.exists) {
        return doc.data();
      }
    } catch (e) {
      debugPrint('❌ Error loading user profile: $e');
    }
    return null;
  }
  
  /// 🧹 오래된 임시 메모리 정리 (영구 메모리는 유지)
  Future<void> cleanupOldTemporaryMemories({
    required String userId,
    required String personaId,
    Duration retention = const Duration(days: 30),
  }) async {
    // 30일 이상 된 임시 메모리만 정리
    // 영구 메모리는 절대 삭제하지 않음
    debugPrint('🧹 Cleaning temporary memories older than ${retention.inDays} days');
    // 구현은 ConversationStateManager의 임시 메모리 정리와 연동
  }
}

/// 압축된 메모리 클래스
class CompressedMemory {
  final String id;
  final String essence;  // 핵심 내용
  final String emotion;
  final double importance;
  final List<String> topics;
  final DateTime timestamp;
  final Map<String, dynamic> metadata;
  
  CompressedMemory({
    required this.id,
    required this.essence,
    required this.emotion,
    required this.importance,
    required this.topics,
    required this.timestamp,
    this.metadata = const {},
  });
  
  Map<String, dynamic> toCompressedMap() => {
    'id': id,
    'essence': essence,
    'emotion': emotion,
    'importance': importance,
    'topics': topics,
    'timestamp': timestamp.toIso8601String(),
    'metadata': metadata,
  };
  
  factory CompressedMemory.fromMap(Map<String, dynamic> map) {
    return CompressedMemory(
      id: map['id'] ?? '',
      essence: map['essence'] ?? '',
      emotion: map['emotion'] ?? 'neutral',
      importance: (map['importance'] ?? 0.5).toDouble(),
      topics: List<String>.from(map['topics'] ?? []),
      timestamp: DateTime.parse(map['timestamp'] ?? DateTime.now().toIso8601String()),
      metadata: map['metadata'] ?? {},
    );
  }
}