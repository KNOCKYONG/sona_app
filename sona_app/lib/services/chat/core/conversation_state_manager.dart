import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../models/message.dart';
import '../../../models/persona.dart';

/// 🎯 대화 상태 관리자
/// 
/// OpenAI API 공식 문서 기반 대화 상태 유지
/// - 대화방별 고유 상태 관리
/// - 컨텍스트 연속성 보장
/// - 메타데이터 추적
class ConversationStateManager {
  // 대화방별 상태 저장
  static final Map<String, ConversationState> _conversationStates = {};
  
  // 상태 유지 기간 (30일 - OpenAI 권장)
  static const Duration _stateRetentionDuration = Duration(days: 30);
  
  /// 🔄 대화 상태 생성 또는 갱신
  static ConversationState getOrCreateState({
    required String conversationId,
    required String userId,
    required String personaId,
  }) {
    final existingState = _conversationStates[conversationId];
    
    if (existingState != null && 
        !existingState.isExpired()) {
      return existingState;
    }
    
    // 새 상태 생성
    final newState = ConversationState(
      conversationId: conversationId,
      userId: userId,
      personaId: personaId,
      createdAt: DateTime.now(),
      lastUpdated: DateTime.now(),
    );
    
    _conversationStates[conversationId] = newState;
    return newState;
  }
  
  /// 📊 대화 상태 업데이트
  static void updateState({
    required String conversationId,
    required Message message,
    Map<String, dynamic>? metadata,
  }) {
    final state = _conversationStates[conversationId];
    if (state == null) return;
    
    state.addMessage(message);
    
    // 메타데이터 업데이트
    if (metadata != null) {
      state.updateMetadata(metadata);
    }
    
    // 대화 통계 업데이트
    state.updateStatistics(message);
  }
  
  /// 🧹 만료된 상태 정리
  static void cleanupExpiredStates() {
    _conversationStates.removeWhere((key, state) => state.isExpired());
  }
  
  /// 📈 대화 컨텍스트 요약 생성
  static String generateContextSummary(String conversationId) {
    final state = _conversationStates[conversationId];
    if (state == null) return '';
    
    final summary = StringBuffer();
    
    // 대화 통계
    summary.writeln('## 대화 상태');
    summary.writeln('- 메시지 수: ${state.messageCount}');
    summary.writeln('- 대화 시작: ${_formatTime(state.createdAt)}');
    summary.writeln('- 마지막 활동: ${_formatTime(state.lastUpdated)}');
    
    // 주요 주제
    if (state.topics.isNotEmpty) {
      summary.writeln('- 주요 주제: ${state.topics.join(', ')}');
    }
    
    // 감정 변화
    if (state.emotionHistory.isNotEmpty) {
      final recentEmotions = state.emotionHistory.take(3).join(' → ');
      summary.writeln('- 감정 변화: $recentEmotions');
    }
    
    // 관계 진전도
    summary.writeln('- 관계 레벨: ${state.relationshipLevel}');
    
    return summary.toString();
  }
  
  /// 🕐 시간 포맷팅
  static String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);
    
    if (diff.inMinutes < 1) return '방금 전';
    if (diff.inMinutes < 60) return '${diff.inMinutes}분 전';
    if (diff.inHours < 24) return '${diff.inHours}시간 전';
    if (diff.inDays < 7) return '${diff.inDays}일 전';
    
    return '${time.month}월 ${time.day}일';
  }
  
  /// 💾 상태 직렬화 (저장용)
  static Map<String, dynamic> serializeState(String conversationId) {
    final state = _conversationStates[conversationId];
    if (state == null) return {};
    
    return state.toJson();
  }
  
  /// 📥 상태 역직렬화 (복원용)
  static void deserializeState(String conversationId, Map<String, dynamic> json) {
    _conversationStates[conversationId] = ConversationState.fromJson(json);
  }
}

/// 📊 대화 상태 클래스
class ConversationState {
  final String conversationId;
  final String userId;
  final String personaId;
  final DateTime createdAt;
  DateTime lastUpdated;
  
  // 대화 히스토리 (최근 N개만 유지)
  final List<Message> _recentMessages = [];
  static const int _maxRecentMessages = 20;
  
  // 메타데이터
  final Map<String, dynamic> metadata = {};
  
  // 대화 통계
  int messageCount = 0;
  int userMessageCount = 0;
  int aiMessageCount = 0;
  final List<String> topics = [];
  final List<String> emotionHistory = [];
  int relationshipLevel = 0;
  
  // 대화 패턴 추적
  DateTime? lastUserMessageTime;
  DateTime? lastAIMessageTime;
  double averageResponseTime = 0;
  
  ConversationState({
    required this.conversationId,
    required this.userId,
    required this.personaId,
    required this.createdAt,
    required this.lastUpdated,
  });
  
  /// 메시지 추가
  void addMessage(Message message) {
    _recentMessages.add(message);
    
    // 최대 개수 유지
    if (_recentMessages.length > _maxRecentMessages) {
      _recentMessages.removeAt(0);
    }
    
    lastUpdated = DateTime.now();
    messageCount++;
    
    if (message.isFromUser) {
      userMessageCount++;
      lastUserMessageTime = DateTime.now();
    } else {
      aiMessageCount++;
      lastAIMessageTime = DateTime.now();
      
      // 감정 히스토리 업데이트
      if (message.emotion != null) {
        emotionHistory.add(message.emotion!.name);
        if (emotionHistory.length > 10) {
          emotionHistory.removeAt(0);
        }
      }
    }
  }
  
  /// 메타데이터 업데이트
  void updateMetadata(Map<String, dynamic> data) {
    metadata.addAll(data);
    lastUpdated = DateTime.now();
  }
  
  /// 통계 업데이트
  void updateStatistics(Message message) {
    // 주제 추출
    _extractTopics(message.content);
    
    // 관계 레벨 업데이트
    if (message.likesChange != null) {
      relationshipLevel += message.likesChange!;
    }
    
    // 응답 시간 계산
    if (!message.isFromUser && lastUserMessageTime != null) {
      final responseTime = DateTime.now().difference(lastUserMessageTime!).inSeconds;
      averageResponseTime = (averageResponseTime * (aiMessageCount - 1) + responseTime) / aiMessageCount;
    }
  }
  
  /// 주제 추출
  void _extractTopics(String content) {
    final topicKeywords = {
      '날씨': ['날씨', '비', '눈', '맑', '흐림'],
      '음식': ['먹', '밥', '음식', '배고', '맛있'],
      '감정': ['좋아', '싫어', '사랑', '행복', '슬퍼'],
      '일상': ['오늘', '어제', '내일', '일', '학교'],
      '취미': ['영화', '음악', '게임', '운동', '책'],
    };
    
    final contentLower = content.toLowerCase();
    topicKeywords.forEach((topic, keywords) {
      if (keywords.any((k) => contentLower.contains(k))) {
        if (!topics.contains(topic)) {
          topics.add(topic);
          if (topics.length > 5) {
            topics.removeAt(0);
          }
        }
      }
    });
  }
  
  /// 상태 만료 여부
  bool isExpired() {
    return DateTime.now().difference(lastUpdated) > ConversationStateManager._stateRetentionDuration;
  }
  
  /// 최근 메시지 가져오기
  List<Message> getRecentMessages({int? limit}) {
    final count = limit ?? _recentMessages.length;
    final start = _recentMessages.length > count ? _recentMessages.length - count : 0;
    return _recentMessages.sublist(start);
  }
  
  /// JSON 변환
  Map<String, dynamic> toJson() {
    return {
      'conversationId': conversationId,
      'userId': userId,
      'personaId': personaId,
      'createdAt': createdAt.toIso8601String(),
      'lastUpdated': lastUpdated.toIso8601String(),
      'messageCount': messageCount,
      'userMessageCount': userMessageCount,
      'aiMessageCount': aiMessageCount,
      'topics': topics,
      'emotionHistory': emotionHistory,
      'relationshipLevel': relationshipLevel,
      'metadata': metadata,
      'averageResponseTime': averageResponseTime,
    };
  }
  
  /// JSON에서 생성
  factory ConversationState.fromJson(Map<String, dynamic> json) {
    final state = ConversationState(
      conversationId: json['conversationId'],
      userId: json['userId'],
      personaId: json['personaId'],
      createdAt: DateTime.parse(json['createdAt']),
      lastUpdated: DateTime.parse(json['lastUpdated']),
    );
    
    state.messageCount = json['messageCount'] ?? 0;
    state.userMessageCount = json['userMessageCount'] ?? 0;
    state.aiMessageCount = json['aiMessageCount'] ?? 0;
    state.relationshipLevel = json['relationshipLevel'] ?? 0;
    state.averageResponseTime = (json['averageResponseTime'] ?? 0).toDouble();
    
    if (json['topics'] != null) {
      state.topics.addAll(List<String>.from(json['topics']));
    }
    
    if (json['emotionHistory'] != null) {
      state.emotionHistory.addAll(List<String>.from(json['emotionHistory']));
    }
    
    if (json['metadata'] != null) {
      state.metadata.addAll(json['metadata']);
    }
    
    return state;
  }
}