import 'package:flutter/material.dart';
import '../../../models/message.dart';
import '../../../models/persona.dart';
import 'persistent_memory_system.dart';
import '../intelligence/conversation_memory_service.dart';
import '../intelligence/memory_network_service.dart';
import '../intelligence/fuzzy_memory_service.dart';
import '../intelligence/conversation_context_manager.dart';

/// 메모리 관리 통합 모듈
/// 여러 메모리 서비스를 조율하는 매니저
class MemoryManager {
  static MemoryManager? _instance;
  static MemoryManager get instance => _instance ??= MemoryManager._();
  
  MemoryManager._();
  
  // 메모리 서비스들
  final PersistentMemorySystem _persistentMemory = PersistentMemorySystem.instance;
  final ConversationMemoryService _conversationMemory = ConversationMemoryService();
  final MemoryNetworkService _memoryNetwork = MemoryNetworkService.instance;
  final FuzzyMemoryService _fuzzyMemory = FuzzyMemoryService();
  final ConversationContextManager _contextManager = ConversationContextManager.instance;
  
  /// 메모리 컨텍스트 구축
  Future<Map<String, dynamic>> buildMemoryContext({
    required String userId,
    required String personaId,
    required List<Message> chatHistory,
    required String userMessage,
  }) async {
    // 1. 중요 메모리 추출
    final importantMemories = await _conversationMemory.extractImportantMemories(
      messages: chatHistory.take(20).toList(),
      userId: userId,
      personaId: personaId,
    );
    
    // 2. 영구 메모리 로드
    final permanentMemories = await _persistentMemory.loadPermanentMemories(
      userId: userId,
      personaId: personaId,
      limit: 10,
    );
    
    // 3. 연관 메모리 활성화
    final activatedMemories = _memoryNetwork.activateMemory(
      userMessage: userMessage,
      chatHistory: chatHistory,
      userId: userId,
      persona: Persona(
        id: personaId,
        name: '',
        age: 0,
        description: '',
        photoUrls: [],
        personality: '',
        likes: 0,
      ),
      likeScore: 0,
    );
    
    // 4. 퍼지 메모리 검색
    final fuzzyResults = await _fuzzyMemory.searchSimilarMemories(
      query: userMessage,
      userId: userId,
      personaId: personaId,
      limit: 5,
    );
    
    // 5. 사용자 지식 가져오기
    final userKnowledge = _contextManager.getKnowledge(userId, personaId);
    
    // 6. 메모리 요약 생성
    final memorySummary = _generateMemorySummary(
      importantMemories: importantMemories,
      permanentMemories: permanentMemories,
      activatedMemories: activatedMemories,
      fuzzyResults: fuzzyResults,
    );
    
    // 7. 컨텍스트 힌트 생성
    final contextHints = _generateContextHints(
      memories: importantMemories,
      userKnowledge: userKnowledge,
      userMessage: userMessage,
    );
    
    return {
      'importantMemories': importantMemories.map((m) => {
        'content': m.content,
        'importance': m.importance,
        'emotion': m.emotion.name,
        'tags': m.tags,
        'timestamp': m.timestamp.toIso8601String(),
      }).toList(),
      'permanentMemories': permanentMemories,
      'activatedMemories': activatedMemories['associatedMemories'] ?? [],
      'fuzzyMemories': fuzzyResults,
      'userKnowledge': userKnowledge != null ? {
        'schedule': userKnowledge.schedule,
        'preferences': userKnowledge.preferences,
        'personalInfo': userKnowledge.personalInfo,
        'recentTopics': userKnowledge.recentTopics,
        'sharedActivities': userKnowledge.sharedActivities,
      } : null,
      'memorySummary': memorySummary,
      'contextHints': contextHints,
      'memoryStrength': _calculateMemoryStrength(
        importantCount: importantMemories.length,
        permanentCount: permanentMemories['totalMemories'] ?? 0,
        fuzzyCount: fuzzyResults.length,
      ),
    };
  }
  
  /// 메모리 업데이트
  Future<void> updateMemory({
    required String userId,
    required String personaId,
    required String userMessage,
    required String aiResponse,
  }) async {
    // 1. 새 메시지로부터 메모리 추출
    final newMemories = await _conversationMemory.extractImportantMemories(
      messages: [
        Message(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          personaId: personaId,
          content: userMessage,
          type: MessageType.text,
          isFromUser: true,
          timestamp: DateTime.now(),
        ),
        Message(
          id: '${DateTime.now().millisecondsSinceEpoch + 1}',
          personaId: personaId,
          content: aiResponse,
          type: MessageType.text,
          isFromUser: false,
          timestamp: DateTime.now(),
        ),
      ],
      userId: userId,
      personaId: personaId,
    );
    
    // 2. 중요한 메모리 저장
    if (newMemories.isNotEmpty) {
      await _conversationMemory.saveMemories(newMemories);
      
      // 퍼지 메모리에도 저장
      for (final memory in newMemories) {
        await _fuzzyMemory.storeMemory(
          content: memory.content,
          userId: userId,
          personaId: personaId,
          importance: memory.importance,
          metadata: {
            'emotion': memory.emotion.name,
            'tags': memory.tags,
          },
        );
      }
    }
    
    // 3. 사용자 지식 업데이트
    await _contextManager.updateKnowledge(
      userId: userId,
      personaId: personaId,
      userMessage: userMessage,
      personaResponse: aiResponse,
      chatHistory: [],
    );
    
    // 4. 메모리 네트워크 강화
    _memoryNetwork.strengthenConnection(
      memory1: userMessage,
      memory2: aiResponse,
      strength: 0.5,
    );
  }
  
  /// 메모리 요약 생성
  String _generateMemorySummary({
    required List<ConversationMemory> importantMemories,
    required Map<String, dynamic> permanentMemories,
    required Map<String, dynamic> activatedMemories,
    required List<Map<String, dynamic>> fuzzyResults,
  }) {
    final summary = StringBuffer();
    
    // 중요 메모리 요약
    if (importantMemories.isNotEmpty) {
      final recentTopics = importantMemories
          .expand((m) => m.tags)
          .toSet()
          .take(3)
          .join(', ');
      if (recentTopics.isNotEmpty) {
        summary.writeln('최근 대화 주제: $recentTopics');
      }
    }
    
    // 영구 메모리 요약
    final totalPermanent = permanentMemories['totalMemories'] ?? 0;
    if (totalPermanent > 0) {
      summary.writeln('총 $totalPermanent개의 소중한 기억');
      
      final milestones = permanentMemories['milestones'] as List?;
      if (milestones != null && milestones.isNotEmpty) {
        summary.writeln('주요 이정표: ${milestones.first['title']}');
      }
    }
    
    // 연관 메모리 언급
    final associatedCount = (activatedMemories['associatedMemories'] as List?)?.length ?? 0;
    if (associatedCount > 0) {
      summary.writeln('$associatedCount개의 관련 기억 활성화');
    }
    
    return summary.toString();
  }
  
  /// 컨텍스트 힌트 생성
  List<String> _generateContextHints({
    required List<ConversationMemory> memories,
    UserKnowledge? userKnowledge,
    required String userMessage,
  }) {
    final hints = <String>[];
    
    // 메모리 기반 힌트
    for (final memory in memories.take(3)) {
      if (memory.importance > 0.7) {
        hints.add('이전에 "${memory.content.substring(0, 30)}..." 대화를 나눴음');
      }
    }
    
    // 사용자 지식 기반 힌트
    if (userKnowledge != null) {
      if (userKnowledge.preferences.isNotEmpty) {
        hints.add('선호사항: ${userKnowledge.preferences.take(2).join(', ')}');
      }
      
      if (userKnowledge.recentTopics.isNotEmpty) {
        hints.add('최근 관심사: ${userKnowledge.recentTopics.first}');
      }
    }
    
    // 메시지 관련 힌트
    if (userMessage.contains('어제') || userMessage.contains('지난')) {
      hints.add('과거 대화를 참조하는 중');
    }
    
    return hints;
  }
  
  /// 메모리 강도 계산
  double _calculateMemoryStrength({
    required int importantCount,
    required int permanentCount,
    required int fuzzyCount,
  }) {
    double strength = 0.0;
    
    // 중요 메모리 (40%)
    strength += (importantCount / 10).clamp(0.0, 0.4);
    
    // 영구 메모리 (40%)
    strength += (permanentCount / 50).clamp(0.0, 0.4);
    
    // 퍼지 메모리 (20%)
    strength += (fuzzyCount / 5).clamp(0.0, 0.2);
    
    return strength.clamp(0.0, 1.0);
  }
  
  /// 메모리 정리
  Future<void> cleanupMemories({
    required String userId,
    required String personaId,
    int daysToKeep = 30,
  }) async {
    // 오래된 메모리 정리
    final cutoffDate = DateTime.now().subtract(Duration(days: daysToKeep));
    
    // 퍼지 메모리 정리
    await _fuzzyMemory.cleanupOldMemories(
      userId: userId,
      personaId: personaId,
      before: cutoffDate,
    );
    
    debugPrint('🧹 메모리 정리 완료: $daysToKeep일 이상 된 메모리 제거');
  }
  
  /// 메모리 통계
  Future<Map<String, dynamic>> getMemoryStatistics({
    required String userId,
    required String personaId,
  }) async {
    // 영구 메모리 통계
    final permanentStats = await _persistentMemory.loadPermanentMemories(
      userId: userId,
      personaId: personaId,
      limit: 1,
    );
    
    // 퍼지 메모리 개수
    final fuzzyCount = await _fuzzyMemory.getMemoryCount(
      userId: userId,
      personaId: personaId,
    );
    
    return {
      'permanentMemories': permanentStats['totalMemories'] ?? 0,
      'fuzzyMemories': fuzzyCount,
      'memoryNetworkNodes': _memoryNetwork.getNodeCount(),
      'lastMemoryUpdate': DateTime.now().toIso8601String(),
    };
  }
}