import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/message.dart';
import '../../models/persona.dart';
import '../../core/constants.dart';
import '../../core/preferences_manager.dart';
import '../chat/intelligence/conversation_memory_service.dart';

/// Service for managing guest user conversations locally on the device
/// Provides persistent storage for messages, memories, and relationship data
class GuestConversationService {
  static const String _messagesPrefix = 'guest_messages_';
  static const String _memoriesPrefix = 'guest_memories_';
  static const String _relationshipPrefix = 'guest_relationship_';
  static const String _lastMessagePrefix = 'guest_last_message_';
  static const String _contextPrefix = 'guest_context_';
  
  // Singleton instance
  static final GuestConversationService _instance = GuestConversationService._internal();
  static GuestConversationService get instance => _instance;
  
  GuestConversationService._internal();
  
  /// Get unique device ID for guest storage
  Future<String> _getDeviceId() async {
    String? deviceId = await PreferencesManager.getDeviceId();
    if (deviceId == null || deviceId.isEmpty) {
      // Generate a unique device ID if not exists
      deviceId = DateTime.now().millisecondsSinceEpoch.toString();
      await PreferencesManager.setDeviceId(deviceId);
    }
    return deviceId;
  }
  
  /// Generate storage key for device + persona combination
  String _generateKey(String prefix, String deviceId, String personaId) {
    return '$prefix${deviceId}_$personaId';
  }
  
  /// Save a message to local storage
  Future<void> saveGuestMessage({
    required String personaId,
    required Message message,
  }) async {
    try {
      final deviceId = await _getDeviceId();
      final prefs = await SharedPreferences.getInstance();
      final key = _generateKey(_messagesPrefix, deviceId, personaId);
      
      // Get existing messages
      final messages = await getGuestMessages(personaId);
      
      // Add new message
      messages.add(message);
      
      // Keep only last 100 messages per persona to save storage
      if (messages.length > AppConstants.maxMessagesInMemory) {
        // Before removing old messages, extract important memories
        await _extractAndSaveMemories(
          personaId: personaId,
          messagesToArchive: messages.sublist(0, messages.length - AppConstants.maxMessagesInMemory),
        );
        
        messages.removeRange(0, messages.length - AppConstants.maxMessagesInMemory);
      }
      
      // Save messages
      final messagesJson = messages.map((msg) => msg.toJson()).toList();
      await prefs.setString(key, jsonEncode(messagesJson));
      
      // Update last message for chat list
      await _saveLastMessage(personaId, message);
      
      // Update relationship data
      await _updateRelationshipData(personaId, message);
      
      debugPrint('💾 [GuestConversation] Saved message for persona: $personaId');
    } catch (e) {
      debugPrint('❌ [GuestConversation] Error saving message: $e');
    }
  }
  
  /// Get all messages for a persona
  Future<List<Message>> getGuestMessages(String personaId) async {
    try {
      final deviceId = await _getDeviceId();
      final prefs = await SharedPreferences.getInstance();
      final key = _generateKey(_messagesPrefix, deviceId, personaId);
      
      final messagesJson = prefs.getString(key);
      if (messagesJson == null) return [];
      
      final List<dynamic> messagesList = jsonDecode(messagesJson);
      return messagesList.map((json) => Message.fromJson(json)).toList();
    } catch (e) {
      debugPrint('❌ [GuestConversation] Error loading messages: $e');
      return [];
    }
  }
  
  /// Save last message for chat list display
  Future<void> _saveLastMessage(String personaId, Message message) async {
    try {
      final deviceId = await _getDeviceId();
      final prefs = await SharedPreferences.getInstance();
      final key = _generateKey(_lastMessagePrefix, deviceId, personaId);
      
      await prefs.setString(key, jsonEncode(message.toJson()));
    } catch (e) {
      debugPrint('❌ [GuestConversation] Error saving last message: $e');
    }
  }
  
  /// Get last message for a persona
  Future<Message?> getLastGuestMessage(String personaId) async {
    try {
      final deviceId = await _getDeviceId();
      final prefs = await SharedPreferences.getInstance();
      final key = _generateKey(_lastMessagePrefix, deviceId, personaId);
      
      final messageJson = prefs.getString(key);
      if (messageJson == null) return null;
      
      return Message.fromJson(jsonDecode(messageJson));
    } catch (e) {
      debugPrint('❌ [GuestConversation] Error loading last message: $e');
      return null;
    }
  }
  
  /// Get all last messages for chat list
  Future<Map<String, Message>> getAllLastMessages() async {
    try {
      final deviceId = await _getDeviceId();
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();
      final Map<String, Message> lastMessages = {};
      
      final prefix = '$_lastMessagePrefix$deviceId';
      
      for (final key in keys) {
        if (key.startsWith(prefix)) {
          final personaId = key.substring(prefix.length + 1); // +1 for underscore
          final messageJson = prefs.getString(key);
          
          if (messageJson != null) {
            final message = Message.fromJson(jsonDecode(messageJson));
            lastMessages[personaId] = message;
          }
        }
      }
      
      return lastMessages;
    } catch (e) {
      debugPrint('❌ [GuestConversation] Error loading all last messages: $e');
      return {};
    }
  }
  
  /// Extract and save important memories from old messages
  Future<void> _extractAndSaveMemories({
    required String personaId,
    required List<Message> messagesToArchive,
  }) async {
    try {
      final deviceId = await _getDeviceId();
      final prefs = await SharedPreferences.getInstance();
      final key = _generateKey(_memoriesPrefix, deviceId, personaId);
      
      // Get existing memories
      final existingMemoriesJson = prefs.getString(key);
      final List<Map<String, dynamic>> memories = existingMemoriesJson != null
          ? List<Map<String, dynamic>>.from(jsonDecode(existingMemoriesJson))
          : [];
      
      // Extract important information from messages
      for (final message in messagesToArchive) {
        // Check if message contains important information
        if (_isImportantMessage(message)) {
          memories.add({
            'content': message.content,
            'timestamp': message.timestamp.toIso8601String(),
            'isFromUser': message.isFromUser,
            'importance': _calculateImportance(message),
            'tags': _extractTags(message.content),
          });
        }
      }
      
      // Keep only most recent/important memories (max 50)
      if (memories.length > 50) {
        // Sort by importance and recency
        memories.sort((a, b) {
          final importanceComp = (b['importance'] as double).compareTo(a['importance'] as double);
          if (importanceComp != 0) return importanceComp;
          
          return DateTime.parse(b['timestamp'] as String)
              .compareTo(DateTime.parse(a['timestamp'] as String));
        });
        
        memories.removeRange(50, memories.length);
      }
      
      await prefs.setString(key, jsonEncode(memories));
      debugPrint('💭 [GuestConversation] Saved ${memories.length} memories for persona: $personaId');
    } catch (e) {
      debugPrint('❌ [GuestConversation] Error saving memories: $e');
    }
  }
  
  /// Check if a message is important enough to save as memory
  bool _isImportantMessage(Message message) {
    final content = message.content.toLowerCase();
    
    // Important patterns
    final importantPatterns = [
      '좋아', '싫어', '사랑', '미워',
      '이름', '나이', '생일', '직업',
      '취미', '관심', '꿈', '목표',
      '기억', '약속', '비밀', '중요',
      '처음', '마지막', '특별', '최고',
      '행복', '슬프', '화나', '무서',
    ];
    
    return importantPatterns.any((pattern) => content.contains(pattern));
  }
  
  /// Calculate importance score for a message
  double _calculateImportance(Message message) {
    double score = 0.5; // Base score
    
    final content = message.content.toLowerCase();
    
    // Emotional content
    if (content.contains('사랑') || content.contains('좋아')) score += 0.2;
    if (content.contains('싫어') || content.contains('미워')) score += 0.2;
    
    // Personal information
    if (content.contains('이름') || content.contains('나이')) score += 0.15;
    if (content.contains('비밀') || content.contains('약속')) score += 0.25;
    
    // Question marks indicate important questions
    if (content.contains('?')) score += 0.1;
    
    // Longer messages are often more important
    if (message.content.length > 50) score += 0.1;
    
    return score.clamp(0.0, 1.0);
  }
  
  /// Extract tags from message content
  List<String> _extractTags(String content) {
    final tags = <String>[];
    final lowerContent = content.toLowerCase();
    
    // Emotion tags
    if (lowerContent.contains('행복') || lowerContent.contains('기쁘')) tags.add('positive');
    if (lowerContent.contains('슬프') || lowerContent.contains('우울')) tags.add('negative');
    
    // Topic tags
    if (lowerContent.contains('일') || lowerContent.contains('직장')) tags.add('work');
    if (lowerContent.contains('사랑') || lowerContent.contains('연애')) tags.add('love');
    if (lowerContent.contains('친구') || lowerContent.contains('우정')) tags.add('friendship');
    
    return tags;
  }
  
  /// Get conversation memories for a persona
  Future<List<Map<String, dynamic>>> getGuestMemories(String personaId) async {
    try {
      final deviceId = await _getDeviceId();
      final prefs = await SharedPreferences.getInstance();
      final key = _generateKey(_memoriesPrefix, deviceId, personaId);
      
      final memoriesJson = prefs.getString(key);
      if (memoriesJson == null) return [];
      
      return List<Map<String, dynamic>>.from(jsonDecode(memoriesJson));
    } catch (e) {
      debugPrint('❌ [GuestConversation] Error loading memories: $e');
      return [];
    }
  }
  
  /// Update relationship data (likes, message count, etc.)
  Future<void> _updateRelationshipData(String personaId, Message message) async {
    try {
      final deviceId = await _getDeviceId();
      final prefs = await SharedPreferences.getInstance();
      final key = _generateKey(_relationshipPrefix, deviceId, personaId);
      
      // Get existing relationship data
      final existingData = await getRelationshipData(personaId);
      
      // Update data
      existingData['messageCount'] = (existingData['messageCount'] ?? 0) + 1;
      existingData['lastInteraction'] = DateTime.now().toIso8601String();
      
      // Save updated data
      await prefs.setString(key, jsonEncode(existingData));
    } catch (e) {
      debugPrint('❌ [GuestConversation] Error updating relationship: $e');
    }
  }
  
  /// Get relationship data for a persona
  Future<Map<String, dynamic>> getRelationshipData(String personaId) async {
    try {
      final deviceId = await _getDeviceId();
      final prefs = await SharedPreferences.getInstance();
      final key = _generateKey(_relationshipPrefix, deviceId, personaId);
      
      final dataJson = prefs.getString(key);
      if (dataJson == null) {
        return {
          'likes': AppConstants.guestInitialHearts,
          'messageCount': 0,
          'lastInteraction': null,
        };
      }
      
      return Map<String, dynamic>.from(jsonDecode(dataJson));
    } catch (e) {
      debugPrint('❌ [GuestConversation] Error loading relationship: $e');
      return {
        'likes': AppConstants.guestInitialHearts,
        'messageCount': 0,
        'lastInteraction': null,
      };
    }
  }
  
  /// Generate conversation context for AI from local data
  Future<String> generateGuestContext(String personaId) async {
    try {
      // Get recent messages
      final messages = await getGuestMessages(personaId);
      final recentMessages = messages.length > 10 
          ? messages.sublist(messages.length - 10)
          : messages;
      
      // Get memories
      final memories = await getGuestMemories(personaId);
      
      // Get relationship data
      final relationship = await getRelationshipData(personaId);
      
      // Build context
      final contextParts = <String>[];
      
      // Add relationship status
      final messageCount = relationship['messageCount'] ?? 0;
      if (messageCount > 0) {
        contextParts.add('대화 횟수: $messageCount번');
      }
      
      // Add important memories
      if (memories.isNotEmpty) {
        contextParts.add('\n기억할 내용:');
        for (final memory in memories.take(5)) {
          contextParts.add('- ${memory['content']}');
        }
      }
      
      // Add recent conversation summary
      if (recentMessages.isNotEmpty) {
        contextParts.add('\n최근 대화:');
        for (final msg in recentMessages.take(5)) {
          final speaker = msg.isFromUser ? '사용자' : '페르소나';
          contextParts.add('$speaker: ${msg.content}');
        }
      }
      
      return contextParts.join('\n');
    } catch (e) {
      debugPrint('❌ [GuestConversation] Error generating context: $e');
      return '';
    }
  }
  
  /// Clear all data for a specific persona
  Future<void> clearGuestConversation(String personaId) async {
    try {
      final deviceId = await _getDeviceId();
      final prefs = await SharedPreferences.getInstance();
      
      // Remove all data for this persona
      await prefs.remove(_generateKey(_messagesPrefix, deviceId, personaId));
      await prefs.remove(_generateKey(_memoriesPrefix, deviceId, personaId));
      await prefs.remove(_generateKey(_relationshipPrefix, deviceId, personaId));
      await prefs.remove(_generateKey(_lastMessagePrefix, deviceId, personaId));
      await prefs.remove(_generateKey(_contextPrefix, deviceId, personaId));
      
      debugPrint('🗑️ [GuestConversation] Cleared data for persona: $personaId');
    } catch (e) {
      debugPrint('❌ [GuestConversation] Error clearing data: $e');
    }
  }
  
  /// Clear all guest conversation data
  Future<void> clearAllGuestConversations() async {
    try {
      final deviceId = await _getDeviceId();
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();
      
      final prefixesToRemove = [
        '$_messagesPrefix$deviceId',
        '$_memoriesPrefix$deviceId',
        '$_relationshipPrefix$deviceId',
        '$_lastMessagePrefix$deviceId',
        '$_contextPrefix$deviceId',
      ];
      
      for (final key in keys) {
        if (prefixesToRemove.any((prefix) => key.startsWith(prefix))) {
          await prefs.remove(key);
        }
      }
      
      debugPrint('🗑️ [GuestConversation] Cleared all guest conversation data');
    } catch (e) {
      debugPrint('❌ [GuestConversation] Error clearing all data: $e');
    }
  }
  
  /// Get all guest conversation data for migration
  Future<Map<String, dynamic>> getAllGuestDataForMigration() async {
    try {
      final deviceId = await _getDeviceId();
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();
      
      final Map<String, dynamic> allData = {
        'deviceId': deviceId,
        'conversations': {},
      };
      
      // Extract persona IDs
      final personaIds = <String>{};
      final prefix = '$_messagesPrefix$deviceId';
      
      for (final key in keys) {
        if (key.startsWith(prefix)) {
          final personaId = key.substring(prefix.length + 1);
          personaIds.add(personaId);
        }
      }
      
      // Get all data for each persona
      for (final personaId in personaIds) {
        allData['conversations'][personaId] = {
          'messages': await getGuestMessages(personaId),
          'memories': await getGuestMemories(personaId),
          'relationship': await getRelationshipData(personaId),
        };
      }
      
      debugPrint('📦 [GuestConversation] Prepared migration data for ${personaIds.length} personas');
      return allData;
    } catch (e) {
      debugPrint('❌ [GuestConversation] Error preparing migration data: $e');
      return {};
    }
  }
  
  /// Set left chat status for a persona (guest mode)
  Future<void> setLeftChatStatus(String personaId, bool leftChat) async {
    try {
      final deviceId = await _getDeviceId();
      final prefs = await SharedPreferences.getInstance();
      final key = 'guest_leftChat_${deviceId}_$personaId';
      
      if (leftChat) {
        await prefs.setBool(key, true);
        await prefs.setString('guest_leftAt_${deviceId}_$personaId', 
            DateTime.now().toIso8601String());
        debugPrint('🚪 [GuestConversation] Set leftChat status for persona: $personaId');
      } else {
        // Remove leftChat status (for rejoining)
        await prefs.remove(key);
        await prefs.remove('guest_leftAt_${deviceId}_$personaId');
        debugPrint('🔓 [GuestConversation] Cleared leftChat status for persona: $personaId');
      }
    } catch (e) {
      debugPrint('❌ [GuestConversation] Error setting leftChat status: $e');
    }
  }
  
  /// Get left chat status for a persona (guest mode)
  Future<bool> getLeftChatStatus(String personaId) async {
    try {
      final deviceId = await _getDeviceId();
      final prefs = await SharedPreferences.getInstance();
      final key = 'guest_leftChat_${deviceId}_$personaId';
      return prefs.getBool(key) ?? false;
    } catch (e) {
      debugPrint('❌ [GuestConversation] Error getting leftChat status: $e');
      return false;
    }
  }
  
  /// Get all left chat statuses for guest
  Future<Map<String, bool>> getAllLeftChatStatuses() async {
    try {
      final deviceId = await _getDeviceId();
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();
      final Map<String, bool> leftChatStatuses = {};
      
      final prefix = 'guest_leftChat_${deviceId}_';
      
      for (final key in keys) {
        if (key.startsWith(prefix)) {
          final personaId = key.substring(prefix.length);
          final isLeft = prefs.getBool(key) ?? false;
          if (isLeft) {
            leftChatStatuses[personaId] = true;
          }
        }
      }
      
      return leftChatStatuses;
    } catch (e) {
      debugPrint('❌ [GuestConversation] Error getting all leftChat statuses: $e');
      return {};
    }
  }
}