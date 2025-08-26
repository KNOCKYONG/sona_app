import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../../models/message.dart';
import '../../../../helpers/firebase_helper.dart';
import '../../../../core/constants.dart';

/// 메시지 관리 모듈
/// ChatService에서 메시지 CRUD 관련 책임을 분리
class MessageManager {
  // 메시지 저장소
  final Map<String, List<Message>> _messagesByPersona = {};
  final Map<String, bool> _hasMoreMessages = {};
  final Map<String, DocumentSnapshot?> _lastDocuments = {};
  
  // 페이지네이션 설정
  static const int _messagesPerPage = 50;
  static const int _maxMessagesInMemory = 200;
  
  /// 특정 페르소나의 메시지 가져오기
  List<Message> getMessages(String personaId) {
    return List<Message>.from(_messagesByPersona[personaId] ?? []);
  }
  
  /// 메시지 추가
  void addMessage(String personaId, Message message) {
    _messagesByPersona[personaId] ??= [];
    _messagesByPersona[personaId]!.add(message);
    
    // 메모리 관리: 최대 개수 초과 시 오래된 메시지 제거
    if (_messagesByPersona[personaId]!.length > _maxMessagesInMemory) {
      _messagesByPersona[personaId] = 
        _messagesByPersona[personaId]!.sublist(
          _messagesByPersona[personaId]!.length - _maxMessagesInMemory
        );
    }
  }
  
  /// 메시지 일괄 추가
  void addMessages(String personaId, List<Message> messages) {
    _messagesByPersona[personaId] ??= [];
    _messagesByPersona[personaId]!.addAll(messages);
    
    // 메모리 관리
    if (_messagesByPersona[personaId]!.length > _maxMessagesInMemory) {
      _messagesByPersona[personaId] = 
        _messagesByPersona[personaId]!.sublist(
          _messagesByPersona[personaId]!.length - _maxMessagesInMemory
        );
    }
  }
  
  /// 메시지 업데이트
  void updateMessage(String personaId, String messageId, Message updatedMessage) {
    final messages = _messagesByPersona[personaId];
    if (messages == null) return;
    
    final index = messages.indexWhere((m) => m.id == messageId);
    if (index != -1) {
      messages[index] = updatedMessage;
    }
  }
  
  /// Firebase에서 메시지 로드
  Future<List<Message>> loadMessagesFromFirebase(
    String userId, 
    String personaId, {
    int limit = _messagesPerPage,
  }) async {
    try {
      Query query = FirebaseHelper.userPersonaChats(userId, personaId)
          .orderBy('timestamp', descending: true)
          .limit(limit);
      
      final snapshot = await query.get();
      
      if (snapshot.docs.isEmpty) {
        _hasMoreMessages[personaId] = false;
        return [];
      }
      
      // 마지막 문서 저장 (페이지네이션용)
      _lastDocuments[personaId] = snapshot.docs.last;
      _hasMoreMessages[personaId] = snapshot.docs.length == limit;
      
      final messages = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Message.fromMap(data, doc.id);
      }).toList();
      
      // 시간 순서대로 정렬 (오래된 것부터)
      messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
      
      // 메모리에 저장
      _messagesByPersona[personaId] = messages;
      
      return messages;
    } catch (e) {
      debugPrint('❌ Error loading messages: $e');
      return [];
    }
  }
  
  /// 더 많은 메시지 로드 (페이지네이션)
  Future<List<Message>> loadMoreMessages(
    String userId, 
    String personaId,
  ) async {
    if (!hasMoreMessages(personaId)) {
      return [];
    }
    
    try {
      Query query = FirebaseHelper.userPersonaChats(userId, personaId)
          .orderBy('timestamp', descending: true)
          .limit(_messagesPerPage);
      
      // 마지막 문서부터 시작
      final lastDoc = _lastDocuments[personaId];
      if (lastDoc != null) {
        query = query.startAfterDocument(lastDoc);
      }
      
      final snapshot = await query.get();
      
      if (snapshot.docs.isEmpty) {
        _hasMoreMessages[personaId] = false;
        return [];
      }
      
      // 마지막 문서 업데이트
      _lastDocuments[personaId] = snapshot.docs.last;
      _hasMoreMessages[personaId] = snapshot.docs.length == _messagesPerPage;
      
      final newMessages = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Message.fromMap(data, doc.id);
      }).toList();
      
      // 시간 순서대로 정렬
      newMessages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
      
      // 기존 메시지 앞에 추가
      _messagesByPersona[personaId] = [
        ...newMessages,
        ...(_messagesByPersona[personaId] ?? [])
      ];
      
      return newMessages;
    } catch (e) {
      debugPrint('❌ Error loading more messages: $e');
      return [];
    }
  }
  
  /// 메시지를 읽음으로 표시
  Future<void> markMessagesAsRead(
    String userId,
    String personaId,
    List<String> messageIds,
  ) async {
    if (messageIds.isEmpty) return;
    
    try {
      final batch = FirebaseFirestore.instance.batch();
      
      for (final messageId in messageIds) {
        final docRef = FirebaseHelper.userPersonaChats(userId, personaId)
            .doc(messageId);
        batch.update(docRef, {
          'isRead': true,
          'readAt': FieldValue.serverTimestamp(),
        });
      }
      
      await batch.commit();
      
      // 로컬 메시지 업데이트
      final messages = _messagesByPersona[personaId];
      if (messages != null) {
        for (final message in messages) {
          if (messageIds.contains(message.id) && !message.isRead) {
            message.isRead = true;
            message.readAt = DateTime.now();
          }
        }
      }
    } catch (e) {
      debugPrint('❌ Error marking messages as read: $e');
    }
  }
  
  /// 모든 메시지를 읽음으로 표시
  Future<void> markAllMessagesAsRead(
    String userId,
    String personaId,
  ) async {
    final messages = getMessages(personaId);
    final unreadIds = messages
        .where((m) => !m.isUser && !m.isRead)
        .map((m) => m.id)
        .toList();
    
    if (unreadIds.isNotEmpty) {
      await markMessagesAsRead(userId, personaId, unreadIds);
    }
  }
  
  /// 메시지 삭제
  Future<bool> deleteMessage(
    String userId,
    String personaId,
    String messageId,
  ) async {
    try {
      await FirebaseHelper.userPersonaChats(userId, personaId)
          .doc(messageId)
          .delete();
      
      // 로컬에서도 삭제
      _messagesByPersona[personaId]?.removeWhere((m) => m.id == messageId);
      
      return true;
    } catch (e) {
      debugPrint('❌ Error deleting message: $e');
      return false;
    }
  }
  
  /// 특정 페르소나의 모든 메시지 삭제
  Future<void> clearMessages(String personaId) async {
    _messagesByPersona.remove(personaId);
    _hasMoreMessages.remove(personaId);
    _lastDocuments.remove(personaId);
  }
  
  /// 모든 메시지 삭제
  void clearAllMessages() {
    _messagesByPersona.clear();
    _hasMoreMessages.clear();
    _lastDocuments.clear();
  }
  
  /// 더 많은 메시지가 있는지 확인
  bool hasMoreMessages(String personaId) {
    return _hasMoreMessages[personaId] ?? true;
  }
  
  /// 메시지 개수 가져오기
  int getMessageCount(String personaId) {
    return _messagesByPersona[personaId]?.length ?? 0;
  }
  
  /// 읽지 않은 메시지 개수
  int getUnreadCount(String personaId) {
    final messages = _messagesByPersona[personaId] ?? [];
    return messages.where((m) => !m.isUser && !m.isRead).length;
  }
  
  /// 최근 메시지 가져오기
  List<Message> getRecentMessages(String personaId, {int limit = 10}) {
    final messages = getMessages(personaId);
    if (messages.length <= limit) {
      return messages;
    }
    return messages.sublist(messages.length - limit);
  }
  
  /// 메모리 정리
  void cleanup() {
    // 오래된 메시지 정리
    _messagesByPersona.forEach((personaId, messages) {
      if (messages.length > _maxMessagesInMemory) {
        _messagesByPersona[personaId] = 
          messages.sublist(messages.length - _maxMessagesInMemory);
      }
    });
  }
  
  /// 디버깅용 통계
  Map<String, dynamic> getStatistics() {
    final stats = <String, dynamic>{};
    
    _messagesByPersona.forEach((personaId, messages) {
      stats[personaId] = {
        'totalMessages': messages.length,
        'unreadCount': messages.where((m) => !m.isUser && !m.isRead).length,
        'hasMore': _hasMoreMessages[personaId] ?? false,
      };
    });
    
    return {
      'personas': stats,
      'totalPersonas': _messagesByPersona.length,
      'totalMessages': _messagesByPersona.values
          .fold(0, (sum, messages) => sum + messages.length),
    };
  }
}