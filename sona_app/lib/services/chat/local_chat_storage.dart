import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/message.dart';
import '../../core/constants.dart';

/// 로그인하지 않은 사용자를 위한 로컬 채팅 저장소
class LocalChatStorage {
  static const String _keyPrefix = 'local_chat_';
  static const String _messageCountKey = 'local_message_count';
  static const int _maxMessagesPerPersona = 100;
  static const int _totalMaxMessages = 100;
  
  SharedPreferences? _prefs;
  bool _isInitialized = false;
  
  /// 초기화
  Future<void> initialize() async {
    if (_isInitialized) return;
    _prefs = await SharedPreferences.getInstance();
    _isInitialized = true;
  }
  
  /// 초기화 확인
  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await initialize();
    }
  }
  
  /// 특정 페르소나의 메시지 가져오기
  Future<List<Message>> getMessages(String personaId) async {
    await _ensureInitialized();
    final key = '$_keyPrefix$personaId';
    final jsonString = _prefs!.getString(key);
    
    if (jsonString == null) return [];
    
    try {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => Message.fromJson(json)).toList();
    } catch (e) {
      print('Error loading local messages: $e');
      return [];
    }
  }
  
  /// 메시지 저장
  Future<bool> saveMessage(String personaId, Message message) async {
    await _ensureInitialized();
    // 전체 메시지 수 확인
    final totalCount = await getTotalMessageCount();
    if (totalCount >= _totalMaxMessages) {
      return false; // 100개 제한 도달
    }
    
    // 기존 메시지 로드
    final messages = await getMessages(personaId);
    
    // 페르소나별 메시지 제한
    if (messages.length >= _maxMessagesPerPersona) {
      messages.removeAt(0); // 가장 오래된 메시지 제거
    }
    
    // 새 메시지 추가
    messages.add(message);
    
    // 저장
    final key = '$_keyPrefix$personaId';
    final jsonString = json.encode(messages.map((m) => m.toJson()).toList());
    await _prefs!.setString(key, jsonString);
    
    // 전체 메시지 수 업데이트
    await _incrementMessageCount();
    
    return true;
  }
  
  /// 메시지 업데이트
  Future<void> updateMessage(String personaId, String messageId, Message updatedMessage) async {
    final messages = await getMessages(personaId);
    
    final index = messages.indexWhere((m) => m.id == messageId);
    if (index != -1) {
      messages[index] = updatedMessage;
      
      final key = '$_keyPrefix$personaId';
      final jsonString = json.encode(messages.map((m) => m.toJson()).toList());
      await _prefs!.setString(key, jsonString);
    }
  }
  
  /// 전체 메시지 수 가져오기
  Future<int> getTotalMessageCount() async {
    await _ensureInitialized();
    return _prefs!.getInt(_messageCountKey) ?? 0;
  }
  
  /// 메시지 수 증가
  Future<void> _incrementMessageCount() async {
    final currentCount = await getTotalMessageCount();
    await _prefs!.setInt(_messageCountKey, currentCount + 1);
  }
  
  /// 남은 메시지 수 가져오기
  Future<int> getRemainingMessages() async {
    final count = await getTotalMessageCount();
    return _totalMaxMessages - count;
  }
  
  /// 특정 페르소나의 대화 기록 삭제
  Future<void> clearPersonaChat(String personaId) async {
    await _ensureInitialized();
    final key = '$_keyPrefix$personaId';
    await _prefs!.remove(key);
  }
  
  /// 모든 로컬 대화 기록 삭제
  Future<void> clearAllChats() async {
    await _ensureInitialized();
    final keys = _prefs!.getKeys().where((key) => key.startsWith(_keyPrefix));
    for (final key in keys) {
      await _prefs!.remove(key);
    }
    await _prefs!.remove(_messageCountKey);
  }
  
  /// 로그인 시 로컬 데이터를 Firebase로 마이그레이션
  Future<Map<String, List<Message>>> getAllMessagesForMigration() async {
    await _ensureInitialized();
    final Map<String, List<Message>> allMessages = {};
    
    final keys = _prefs!.getKeys().where((key) => key.startsWith(_keyPrefix));
    for (final key in keys) {
      final personaId = key.substring(_keyPrefix.length);
      final messages = await getMessages(personaId);
      if (messages.isNotEmpty) {
        allMessages[personaId] = messages;
      }
    }
    
    return allMessages;
  }
}