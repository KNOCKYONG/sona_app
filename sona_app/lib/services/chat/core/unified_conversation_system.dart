import 'dart:async';
import 'package:flutter/material.dart';
import '../../../models/message.dart';
import '../../../models/persona.dart';
import 'conversation_state_manager.dart';
import 'optimized_context_manager.dart';
import 'persistent_memory_system.dart';
import '../intelligence/conversation_memory_service.dart';
import '../intelligence/conversation_context_manager.dart';
import '../../conversation/conversation_continuity_service.dart';
import '../intelligence/memory_network_service.dart';
import '../../../core/constants.dart';

/// 🎯 통합 대화 시스템
/// 
/// 모든 대화 관련 서비스를 통합하여 완벽한 대화형 챗봇 서비스 제공
/// - OpenAI API 상태 관리
/// - 메모리 시스템 통합
/// - 컨텍스트 최적화
/// - 대화 연속성 보장
class UnifiedConversationSystem {
  static UnifiedConversationSystem? _instance;
  static UnifiedConversationSystem get instance => 
      _instance ??= UnifiedConversationSystem._();
  
  UnifiedConversationSystem._();
  
  // 서비스 참조
  final ConversationMemoryService _memoryService = ConversationMemoryService();
  final ConversationContextManager _contextManager = ConversationContextManager.instance;
  final MemoryNetworkService _memoryNetwork = MemoryNetworkService.instance;
  final PersistentMemorySystem _persistentMemory = PersistentMemorySystem.instance;
  
  // 통합 캐시
  final Map<String, _ConversationSession> _sessions = {};
  
  /// 🔄 대화 세션 초기화 또는 복원
  Future<ConversationSession> getOrCreateSession({
    required String conversationId,
    required String userId,
    required String personaId,
    required Persona persona,
  }) async {
    final sessionKey = conversationId;
    
    // 기존 세션 확인
    if (_sessions.containsKey(sessionKey)) {
      await _sessions[sessionKey]!.refresh();
      return _sessions[sessionKey]!;
    }
    
    // 새 세션 생성
    final session = _ConversationSession(
      conversationId: conversationId,
      userId: userId,
      personaId: personaId,
      persona: persona,
    );
    
    await session.initialize();
    _sessions[sessionKey] = session;
    
    return session;
  }
  
  /// 📊 통합 컨텍스트 구성
  Future<Map<String, dynamic>> buildUnifiedContext({
    required String conversationId,
    required String userId,
    required String personaId,
    required String userMessage,
    required List<Message> fullHistory,
    required Persona persona,
  }) async {
    // 1. ConversationStateManager에서 상태 가져오기
    final state = ConversationStateManager.getOrCreateState(
      conversationId: conversationId,
      userId: userId,
      personaId: personaId,
    );
    
    // 2. OptimizedContextManager로 최적화된 메시지 선택
    final optimizedMessages = OptimizedContextManager.selectOptimalMessages(
      fullHistory: fullHistory,
      currentMessage: userMessage,
      maxMessages: 15, // 충분한 컨텍스트 유지
    );
    
    // 3. ConversationMemoryService에서 중요 메모리 추출
    final memories = await _memoryService.extractImportantMemories(
      messages: optimizedMessages,
      userId: userId,
      personaId: personaId,
    );
    
    // 4. ConversationContextManager에서 사용자 지식 가져오기
    final userKnowledge = _contextManager.getKnowledge(userId, personaId);
    
    // 5. ConversationContinuityService에서 연속성 분석
    final continuityAnalysis = ConversationContinuityService.analyzeContinuity(
      userId: userId,
      personaId: personaId,
      userMessage: userMessage,
      chatHistory: optimizedMessages,
    );
    
    // 6. MemoryNetworkService에서 연관 기억 활성화
    final memoryActivation = _memoryNetwork.activateMemory(
      userMessage: userMessage,
      chatHistory: optimizedMessages,
      userId: userId,
      persona: persona,
      likeScore: persona.likes,
    );
    final relatedMemories = memoryActivation['associatedMemories'] ?? [];
    
    // 7. 영구 메모리 로드 (30일 이상 된 메모리도 포함)
    final permanentMemories = await _persistentMemory.loadPermanentMemories(
      userId: userId,
      personaId: personaId,
      limit: 20,  // 최근 20개 영구 메모리
    );
    
    // 8. 상태 요약 생성
    final stateSummary = ConversationStateManager.generateContextSummary(conversationId);
    
    // 9. 영구 메모리 요약 추가
    String permanentSummary = '';
    if (permanentMemories['totalMemories'] != null && 
        permanentMemories['totalMemories'] > 0) {
      permanentSummary = _generatePermanentMemorySummary(permanentMemories);
    }
    
    // 10. 통합 컨텍스트 구성
    return {
      'conversationId': conversationId,
      'state': {
        'messageCount': state.messageCount,
        'relationshipLevel': state.relationshipLevel,
        'topics': state.topics,
        'emotionHistory': state.emotionHistory,
        'averageResponseTime': state.averageResponseTime,
        'summary': stateSummary,
      },
      'optimizedMessages': optimizedMessages.map((m) => {
        'content': m.content,
        'isFromUser': m.isFromUser,
        'emotion': m.emotion?.name,
        'timestamp': m.timestamp.toIso8601String(),
      }).toList(),
      'memories': memories.map((m) => {
        'content': m.content,
        'importance': m.importance,
        'tags': m.tags,
        'emotion': m.emotion.name,
      }).toList(),
      'userKnowledge': userKnowledge != null ? {
        'schedule': userKnowledge.schedule,
        'preferences': userKnowledge.preferences,
        'personalInfo': userKnowledge.personalInfo,
        'recentTopics': userKnowledge.recentTopics,
        'sharedActivities': userKnowledge.sharedActivities,
        'implicitSignals': userKnowledge.implicitSignals,
        'moodIndicators': userKnowledge.moodIndicators,
      } : null,
      'continuity': {
        'unansweredQuestions': continuityAnalysis['unansweredQuestions'],
        'topicContinuity': continuityAnalysis['topicContinuity'],
        'strategy': continuityAnalysis['strategy'],
      },
      'relatedMemories': relatedMemories.map((m) => {
        'content': m['content'],
        'relevance': m['relevance'],
        'timestamp': m['timestamp'],
      }).toList(),
      'permanentMemories': permanentMemories,
      'permanentSummary': permanentSummary,
      'contextQuality': _assessContextQuality(
        optimizedMessages: optimizedMessages,
        memories: memories,
        userKnowledge: userKnowledge,
        permanentMemories: permanentMemories,
      ),
    };
  }
  
  /// 📈 대화 후 상태 업데이트
  Future<void> updateConversationState({
    required String conversationId,
    required String userId,
    required String personaId,
    required Message userMessage,
    required Message aiResponse,
    required List<Message> fullHistory,
  }) async {
    // 1. ConversationStateManager 업데이트
    ConversationStateManager.updateState(
      conversationId: conversationId,
      message: userMessage,
      metadata: {
        'type': 'user_message',
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
    
    ConversationStateManager.updateState(
      conversationId: conversationId,
      message: aiResponse,
      metadata: {
        'type': 'ai_response',
        'model': AppConstants.openAIModel,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
    
    // 2. ConversationMemoryService에 메모리 저장
    final memories = await _memoryService.extractImportantMemories(
      messages: [userMessage, aiResponse],
      userId: userId,
      personaId: personaId,
    );
    
    if (memories.isNotEmpty) {
      await _memoryService.saveMemories(memories);
    }
    
    // 3. ConversationContextManager 지식 업데이트
    await _contextManager.updateKnowledge(
      userId: userId,
      personaId: personaId,
      userMessage: userMessage.content,
      personaResponse: aiResponse.content,
      chatHistory: fullHistory,
    );
    
    // 4. MemoryNetworkService 활성화로 연결 강화
    _memoryNetwork.activateMemory(
      userMessage: aiResponse.content,
      chatHistory: fullHistory,
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
    
    // 5. 세션 업데이트
    final session = _sessions[conversationId];
    if (session != null) {
      session.lastActivity = DateTime.now();
      session.turnCount++;
    }
    
    // 6. 영구 메모리 저장 체크 (중요한 대화는 즉시 저장)
    final state = ConversationStateManager.getOrCreateState(
      conversationId: conversationId,
      userId: userId,
      personaId: personaId,
    );
    
    // 30턴마다 또는 중요한 순간에 영구 저장
    if (session != null && (session.turnCount % 30 == 0 || 
        aiResponse.likesChange != null && aiResponse.likesChange! >= 20)) {
      await _persistentMemory.convertToPermamentMemory(
        userId: userId,
        personaId: personaId,
        messages: fullHistory,
        conversationState: {
          'relationshipLevel': state.relationshipLevel,
          'topics': state.topics,
          'emotionHistory': state.emotionHistory,
          'messageCount': state.messageCount,
        },
      );
      debugPrint('💾 Saved conversation to permanent memory at turn ${session.turnCount}');
    }
  }
  
  /// 🎯 컨텍스트 품질 평가
  double _assessContextQuality({
    required List<Message> optimizedMessages,
    required List<ConversationMemory> memories,
    UserKnowledge? userKnowledge,
    Map<String, dynamic>? permanentMemories,
  }) {
    double quality = 0.0;
    
    // 메시지 다양성 (30%)
    final messageTypes = optimizedMessages.map((m) => m.isFromUser).toSet();
    quality += messageTypes.length > 1 ? 0.3 : 0.15;
    
    // 메모리 풍부도 (30%)
    quality += (memories.length / 10).clamp(0.0, 0.3);
    
    // 사용자 지식 완성도 (20%)
    if (userKnowledge != null) {
      int knowledgeCount = 0;
      if (userKnowledge.schedule.isNotEmpty) knowledgeCount++;
      if (userKnowledge.preferences.isNotEmpty) knowledgeCount++;
      if (userKnowledge.personalInfo.isNotEmpty) knowledgeCount++;
      if (userKnowledge.recentTopics.isNotEmpty) knowledgeCount++;
      quality += (knowledgeCount / 4) * 0.2;
    }
    
    // 최근성 (15%)
    final hasRecentMessages = optimizedMessages.any((m) => 
      DateTime.now().difference(m.timestamp).inMinutes < 5
    );
    quality += hasRecentMessages ? 0.15 : 0.075;
    
    // 영구 메모리 (5%)
    if (permanentMemories != null && 
        permanentMemories['totalMemories'] != null &&
        permanentMemories['totalMemories'] > 0) {
      quality += 0.05;
    }
    
    return quality.clamp(0.0, 1.0);
  }
  
  /// 💎 영구 메모리 요약 생성
  String _generatePermanentMemorySummary(Map<String, dynamic> permanentMemories) {
    final summary = StringBuffer();
    
    // 이정표
    final milestones = permanentMemories['milestones'] as List?;
    if (milestones != null && milestones.isNotEmpty) {
      summary.writeln('🏆 관계 이정표:');
      for (final milestone in milestones.take(3)) {
        summary.writeln('  - ${milestone['title']}: ${milestone['description']}');
      }
    }
    
    // 프로필
    final profile = permanentMemories['profile'] as Map<String, dynamic>?;
    if (profile != null) {
      final totalMemories = profile['totalMemories'] ?? 0;
      final topics = profile['topics'] as List? ?? [];
      summary.writeln('📚 총 ${totalMemories}개의 소중한 기억');
      if (topics.isNotEmpty) {
        summary.writeln('💬 주요 대화 주제: ${topics.take(5).join(', ')}');
      }
    }
    
    // 메모리 카테고리
    final memories = permanentMemories['memories'] as Map<String, dynamic>?;
    if (memories != null) {
      final emotionalCount = (memories['emotional'] as List?)?.length ?? 0;
      final specialCount = (memories['special'] as List?)?.length ?? 0;
      if (emotionalCount > 0 || specialCount > 0) {
        summary.writeln('💝 감정적 기억: $emotionalCount개, 특별한 순간: $specialCount개');
      }
    }
    
    return summary.toString();
  }
  
  /// 🧹 세션 정리
  void cleanupSessions() {
    final now = DateTime.now();
    _sessions.removeWhere((key, session) {
      final idle = now.difference(session.lastActivity).inHours > 24;
      if (idle) {
        debugPrint('🧹 Cleaning up idle session: $key');
      }
      return idle;
    });
    
    // ConversationStateManager도 정리
    ConversationStateManager.cleanupExpiredStates();
  }
  
  /// 📊 시스템 상태 리포트
  Map<String, dynamic> getSystemStatus() {
    return {
      'activeSessions': _sessions.length,
      'totalStates': _sessions.values.fold(0, (sum, s) => sum + s.turnCount),
      'memoryUsage': _calculateMemoryUsage(),
      'oldestSession': _sessions.values.isEmpty ? null : 
          _sessions.values.reduce((a, b) => 
            a.createdAt.isBefore(b.createdAt) ? a : b
          ).createdAt.toIso8601String(),
      'contextQuality': _sessions.values.isEmpty ? 0.0 :
          _sessions.values.map((s) => s.contextQuality).reduce((a, b) => a + b) / 
          _sessions.length,
    };
  }
  
  /// 💾 메모리 사용량 계산
  double _calculateMemoryUsage() {
    // 간단한 추정: 각 세션당 약 10KB
    return (_sessions.length * 10.0) / 1024; // MB 단위
  }
}

/// 대화 세션 클래스
class _ConversationSession {
  final String conversationId;
  final String userId;
  final String personaId;
  final Persona persona;
  final DateTime createdAt;
  DateTime lastActivity;
  int turnCount;
  double contextQuality;
  
  _ConversationSession({
    required this.conversationId,
    required this.userId,
    required this.personaId,
    required this.persona,
  }) : createdAt = DateTime.now(),
       lastActivity = DateTime.now(),
       turnCount = 0,
       contextQuality = 0.5;
  
  Future<void> initialize() async {
    debugPrint('🎯 Initializing conversation session: $conversationId');
    // 세션 초기화 로직
  }
  
  Future<void> refresh() async {
    lastActivity = DateTime.now();
    // 세션 새로고침 로직
  }
}

// 외부 인터페이스용 타입 정의
typedef ConversationSession = _ConversationSession;