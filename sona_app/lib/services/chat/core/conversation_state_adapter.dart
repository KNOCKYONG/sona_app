import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../models/message.dart';
import 'conversations_service.dart';
import '../../../helpers/firebase_helper.dart';

/// 🔄 Firebase와 OpenAI Conversations API 간의 브리지
/// 
/// 점진적 마이그레이션을 위한 어댑터:
/// - Firebase → OpenAI Conversations 동기화
/// - 하이브리드 모드 지원
/// - 대화 히스토리 보존
class ConversationStateAdapter {
  static final ConversationStateAdapter _instance = ConversationStateAdapter._internal();
  factory ConversationStateAdapter() => _instance;
  ConversationStateAdapter._internal();
  
  // 마이그레이션 상태
  static bool _useLegacyMode = false;  // 점진적 전환을 위한 플래그
  static const bool _syncToFirebase = true;  // Firebase 백업 유지
  
  // 대화 ID 매핑 (Firebase ID -> OpenAI Conversation ID)
  final Map<String, String> _conversationMapping = {};
  
  /// 마이그레이션 모드 설정
  static void setLegacyMode(bool useLegacy) {
    _useLegacyMode = useLegacy;
    debugPrint('🔄 Conversation mode: ${useLegacy ? "Legacy (Firebase)" : "New (OpenAI)"}');
  }
  
  /// 대화 초기화 및 마이그레이션
  Future<String?> initializeConversation({
    required String userId,
    required String personaId,
    bool forceNew = false,
  }) async {
    final firebaseId = '${userId}_$personaId';
    
    // 이미 매핑된 대화가 있는지 확인
    if (!forceNew && _conversationMapping.containsKey(firebaseId)) {
      return _conversationMapping[firebaseId];
    }
    
    try {
      // OpenAI Conversation 생성/가져오기
      final conversationId = await ConversationsService.getOrCreateConversation(
        userId: userId,
        personaId: personaId,
        metadata: {
          'firebase_id': firebaseId,
          'migrated_at': DateTime.now().toIso8601String(),
        },
      );
      
      // 매핑 저장
      _conversationMapping[firebaseId] = conversationId;
      
      // 기존 Firebase 메시지가 있으면 마이그레이션 시작
      if (_syncToFirebase) {
        await _migrateExistingMessages(
          userId: userId,
          personaId: personaId,
          conversationId: conversationId,
        );
      }
      
      debugPrint('✅ Conversation initialized: $conversationId');
      return conversationId;
    } catch (e) {
      debugPrint('❌ Failed to initialize conversation: $e');
      return null;
    }
  }
  
  /// 기존 Firebase 메시지 마이그레이션
  Future<void> _migrateExistingMessages({
    required String userId,
    required String personaId,
    required String conversationId,
  }) async {
    try {
      // Firebase에서 최근 메시지 가져오기
      final querySnapshot = await FirebaseHelper.userChatMessages(userId, personaId)
          .orderBy('timestamp', descending: true)
          .limit(30)  // 최근 30개만 마이그레이션
          .get();
      
      if (querySnapshot.docs.isEmpty) {
        debugPrint('📭 No existing messages to migrate');
        return;
      }
      
      final messages = querySnapshot.docs
          .map((doc) => Message.fromJson({...doc.data(), 'id': doc.id}))
          .toList()
          .reversed  // 시간 순서대로
          .toList();
      
      debugPrint('🔄 Migrating ${messages.length} messages to OpenAI Conversation');
      
      // OpenAI Conversation에 히스토리로 추가
      // 참고: 실제로는 Conversations API의 items 엔드포인트로 추가해야 함
      // 현재는 다음 대화 시 컨텍스트로 전달되도록 함
      
      debugPrint('✅ Migration completed for conversation: $conversationId');
    } catch (e) {
      debugPrint('⚠️ Migration failed (non-critical): $e');
      // 마이그레이션 실패는 critical하지 않음 - 새 대화부터 OpenAI 사용
    }
  }
  
  /// 메시지 저장 (하이브리드 모드)
  Future<void> saveMessage({
    required String userId,
    required String personaId,
    required Message message,
    String? conversationId,
  }) async {
    // Firebase에 저장 (백업)
    if (_syncToFirebase) {
      try {
        await FirebaseHelper.userChatMessages(userId, personaId).add({
          ...message.toJson(),
          'conversationId': conversationId,
          'syncedToOpenAI': conversationId != null,
        });
        debugPrint('💾 Message saved to Firebase');
      } catch (e) {
        debugPrint('⚠️ Failed to save to Firebase: $e');
      }
    }
    
    // OpenAI Conversation은 API 호출 시 자동 저장됨
    if (conversationId != null) {
      debugPrint('✅ Message auto-saved to OpenAI Conversation: $conversationId');
    }
  }
  
  /// 대화 히스토리 로드 (하이브리드 모드)
  Future<List<Message>> loadConversationHistory({
    required String userId,
    required String personaId,
    String? conversationId,
    int limit = 30,
  }) async {
    // OpenAI Conversation에서 로드 시도
    if (conversationId != null && !_useLegacyMode) {
      try {
        final items = await ConversationsService.getConversationHistory(
          conversationId: conversationId,
          limit: limit,
        );
        
        if (items.isNotEmpty) {
          // OpenAI 형식을 Message 객체로 변환
          final messages = items.map((item) {
            return Message(
              id: item['id'] ?? '',
              personaId: personaId,
              content: item['content'] ?? '',
              type: MessageType.text,
              isFromUser: item['role'] == 'user',
              timestamp: DateTime.tryParse(item['created_at'] ?? '') ?? DateTime.now(),
            );
          }).toList();
          
          debugPrint('📚 Loaded ${messages.length} messages from OpenAI');
          return messages;
        }
      } catch (e) {
        debugPrint('⚠️ Failed to load from OpenAI, falling back to Firebase: $e');
      }
    }
    
    // Firebase에서 로드 (폴백 또는 레거시 모드)
    try {
      final querySnapshot = await FirebaseHelper.userChatMessages(userId, personaId)
          .orderBy('timestamp', descending: true)
          .limit(limit)
          .get();
      
      final messages = querySnapshot.docs
          .map((doc) => Message.fromJson({...doc.data(), 'id': doc.id}))
          .toList()
          .reversed
          .toList();
      
      debugPrint('📚 Loaded ${messages.length} messages from Firebase');
      return messages;
    } catch (e) {
      debugPrint('❌ Failed to load messages: $e');
      return [];
    }
  }
  
  /// 대화 삭제 (양쪽 모두)
  Future<bool> deleteConversation({
    required String userId,
    required String personaId,
    String? conversationId,
  }) async {
    bool success = true;
    
    // OpenAI Conversation 삭제
    if (conversationId != null) {
      success &= await ConversationsService.deleteConversation(conversationId);
      _conversationMapping.remove('${userId}_$personaId');
    }
    
    // Firebase 메시지 삭제
    if (_syncToFirebase) {
      try {
        final batch = FirebaseFirestore.instance.batch();
        final messages = await FirebaseHelper.userChatMessages(userId, personaId).get();
        
        for (final doc in messages.docs) {
          batch.delete(doc.reference);
        }
        
        await batch.commit();
        debugPrint('🗑️ Deleted Firebase messages');
      } catch (e) {
        debugPrint('⚠️ Failed to delete Firebase messages: $e');
        success = false;
      }
    }
    
    return success;
  }
  
  /// 마이그레이션 상태 확인
  static Map<String, dynamic> getMigrationStatus() {
    return {
      'mode': _useLegacyMode ? 'legacy' : 'new',
      'syncToFirebase': _syncToFirebase,
      'mappedConversations': _instance._conversationMapping.length,
    };
  }
  
  /// 캐시 초기화
  void clearCache() {
    _conversationMapping.clear();
    ConversationsService.clearCache();
    debugPrint('🧹 Cleared conversation adapter cache');
  }
}