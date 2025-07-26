import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/message.dart';

class LocalStorageService {
  static const String _messagesPrefix = 'tutorial_messages_';
  static const String _lastMessagePrefix = 'last_message_';
  
  // 튜토리얼 메시지 저장
  static Future<void> saveTutorialMessage(String personaId, Message message) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = '$_messagesPrefix$personaId';
      
      // 기존 메시지 목록 가져오기
      final existingMessages = await getTutorialMessages(personaId);
      
      // 새 메시지 추가
      existingMessages.add(message);
      
      // 최대 100개 메시지만 유지 (메모리 절약)
      if (existingMessages.length > 100) {
        existingMessages.removeRange(0, existingMessages.length - 100);
      }
      
      // JSON으로 변환하여 저장
      final messagesJson = existingMessages.map((msg) => msg.toJson()).toList();
      await prefs.setString(key, jsonEncode(messagesJson));
      
      // 마지막 메시지만 별도 저장 (빠른 접근용)
      await _saveLastMessage(personaId, message);
      
    } catch (e) {
      print('Error saving tutorial message: $e');
    }
  }
  
  // 튜토리얼 메시지 목록 가져오기
  static Future<List<Message>> getTutorialMessages(String personaId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = '$_messagesPrefix$personaId';
      final messagesJson = prefs.getString(key);
      
      if (messagesJson == null) return [];
      
      final List<dynamic> messagesList = jsonDecode(messagesJson);
      return messagesList.map((json) => Message.fromJson(json)).toList();
      
    } catch (e) {
      print('Error loading tutorial messages: $e');
      return [];
    }
  }
  
  // 마지막 메시지만 저장 (채팅 목록용)
  static Future<void> _saveLastMessage(String personaId, Message message) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = '$_lastMessagePrefix$personaId';
      await prefs.setString(key, jsonEncode(message.toJson()));
    } catch (e) {
      print('Error saving last message: $e');
    }
  }
  
  // 마지막 메시지 가져오기 (채팅 목록용)
  static Future<Message?> getLastTutorialMessage(String personaId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = '$_lastMessagePrefix$personaId';
      final messageJson = prefs.getString(key);
      
      if (messageJson == null) return null;
      
      return Message.fromJson(jsonDecode(messageJson));
      
    } catch (e) {
      print('Error loading last tutorial message: $e');
      return null;
    }
  }
  
  // 특정 페르소나의 모든 메시지 삭제
  static Future<void> clearTutorialMessages(String personaId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('$_messagesPrefix$personaId');
      await prefs.remove('$_lastMessagePrefix$personaId');
    } catch (e) {
      print('Error clearing tutorial messages: $e');
    }
  }
  
  // 모든 튜토리얼 메시지 삭제
  static Future<void> clearAllTutorialMessages() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();
      
      for (final key in keys) {
        if (key.startsWith(_messagesPrefix) || key.startsWith(_lastMessagePrefix)) {
          await prefs.remove(key);
        }
      }
    } catch (e) {
      print('Error clearing all tutorial messages: $e');
    }
  }
  
  // 페르소나별 메시지 수 가져오기
  static Future<int> getTutorialMessageCount(String personaId) async {
    final messages = await getTutorialMessages(personaId);
    return messages.length;
  }
  
  // 모든 페르소나의 마지막 메시지 가져오기 (채팅 목록용)
  static Future<Map<String, Message>> getAllLastMessages() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();
      final Map<String, Message> lastMessages = {};
      
      for (final key in keys) {
        if (key.startsWith(_lastMessagePrefix)) {
          final personaId = key.substring(_lastMessagePrefix.length);
          final messageJson = prefs.getString(key);
          
          if (messageJson != null) {
            final message = Message.fromJson(jsonDecode(messageJson));
            lastMessages[personaId] = message;
          }
        }
      }
      
      return lastMessages;
    } catch (e) {
      print('Error loading all last messages: $e');
      return {};
    }
  }
}