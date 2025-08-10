import 'package:flutter/material.dart';
import '../../../models/message.dart';
import '../../../models/persona.dart';

/// 대화 리듬 상태
class ConversationRhythm {
  int shortResponseCount = 0;  // 짧은 응답 연속 횟수
  int longResponseCount = 0;   // 긴 응답 연속 횟수
  int questionCount = 0;        // 질문 연속 횟수
  DateTime lastResponseTime = DateTime.now();
  String lastResponseStyle = ''; // 마지막 응답 스타일
  
  void reset() {
    shortResponseCount = 0;
    longResponseCount = 0;
    questionCount = 0;
    lastResponseStyle = '';
  }
}

/// 응답 리듬 관리자
/// 대화의 자연스러운 리듬과 템포를 유지
class ResponseRhythmManager {
  static ResponseRhythmManager? _instance;
  static ResponseRhythmManager get instance => 
      _instance ??= ResponseRhythmManager._();
  
  ResponseRhythmManager._();
  
  // 대화 리듬 상태 추적
  final Map<String, ConversationRhythm> _rhythmCache = {};
  
  
  /// 응답 리듬 분석 및 가이드 생성
  String generateRhythmGuide({
    required String userId,
    required String personaId,
    required String userMessage,
    required List<Message> chatHistory,
    required Persona persona,
  }) {
    final key = '${userId}_$personaId';
    _rhythmCache[key] ??= ConversationRhythm();
    final rhythm = _rhythmCache[key]!;
    
    // 사용자 메시지 길이 분석
    final userMessageLength = userMessage.length;
    final isUserShort = userMessageLength < 20;
    final isUserLong = userMessageLength > 100;
    
    // 최근 대화 패턴 분석
    final recentMessages = _getRecentMessages(chatHistory, 5);
    final avgResponseLength = _calculateAverageLength(recentMessages);
    
    // 리듬 가이드 생성
    final guide = StringBuffer();
    
    // 1. 길이 밸런싱
    if (isUserShort && rhythm.longResponseCount >= 2) {
      guide.writeln('📏 짧고 간결하게 (1-2문장)');
      rhythm.shortResponseCount++;
      rhythm.longResponseCount = 0;
    } else if (isUserLong && rhythm.shortResponseCount >= 2) {
      guide.writeln('📏 충분히 상세하게 (3-4문장)');
      rhythm.longResponseCount++;
      rhythm.shortResponseCount = 0;
    } else {
      // 자연스러운 변화
      if (avgResponseLength < 50) {
        guide.writeln('📏 적당한 길이로 (2-3문장)');
      }
    }
    
    // 2. 질문 밸런싱
    if (_hasConsecutiveQuestions(recentMessages, 3)) {
      guide.writeln('❓ 질문 자제, 공감과 경험 공유 위주');
      rhythm.questionCount = 0;
    } else if (rhythm.questionCount == 0 && recentMessages.length > 3) {
      guide.writeln('❓ 자연스러운 질문 1개 포함 가능');
      rhythm.questionCount++;
    }
    
    // 3. 대화 템포 조절
    final timeSinceLastResponse = DateTime.now().difference(rhythm.lastResponseTime);
    if (timeSinceLastResponse.inSeconds < 2) {
      guide.writeln('⏱️ 너무 빠른 응답 주의');
    }
    
    // 4. 스타일 다양성
    final responseStyle = _determineResponseStyle(chatHistory, rhythm);
    guide.writeln('🎭 $responseStyle');
    rhythm.lastResponseStyle = responseStyle;
    
    // 5. MBTI별 리듬 특성
    final mbtiRhythm = _getMbtiRhythm(persona.mbti);
    if (mbtiRhythm.isNotEmpty) {
      guide.writeln('🧬 $mbtiRhythm');
    }
    
    // 상태 업데이트
    rhythm.lastResponseTime = DateTime.now();
    
    return guide.toString().trim();
  }
  
  /// 최근 메시지 가져오기
  List<Message> _getRecentMessages(List<Message> history, int count) {
    if (history.isEmpty) return [];
    
    final startIndex = history.length > count ? history.length - count : 0;
    return history.sublist(startIndex);
  }
  
  /// 평균 메시지 길이 계산
  double _calculateAverageLength(List<Message> messages) {
    if (messages.isEmpty) return 0;
    
    final aiMessages = messages.where((m) => !m.isFromUser);
    if (aiMessages.isEmpty) return 0;
    
    final totalLength = aiMessages.fold<int>(
      0, (sum, msg) => sum + msg.content.length
    );
    
    return totalLength / aiMessages.length;
  }
  
  /// 연속 질문 확인
  bool _hasConsecutiveQuestions(List<Message> messages, int threshold) {
    if (messages.length < threshold) return false;
    
    int consecutiveQuestions = 0;
    for (final msg in messages) {
      if (!msg.isFromUser && msg.content.contains('?')) {
        consecutiveQuestions++;
        if (consecutiveQuestions >= threshold) return true;
      } else if (!msg.isFromUser) {
        consecutiveQuestions = 0;
      }
    }
    
    return false;
  }
  
  /// 응답 스타일 결정
  String _determineResponseStyle(List<Message> history, ConversationRhythm rhythm) {
    // 스타일 로테이션
    final styles = [
      '공감 표현 중심',
      '경험 공유 중심',
      '감정 표현 중심',
      '호기심 표현',
      '응원과 격려',
    ];
    
    // 마지막 스타일과 다른 스타일 선택
    final availableStyles = styles.where((s) => s != rhythm.lastResponseStyle).toList();
    
    // 대화 맥락에 맞는 스타일 선택
    if (_needsEmpathy(history)) {
      return '공감 표현 중심';
    } else if (_needsEncouragement(history)) {
      return '응원과 격려';
    } else if (_needsCuriosity(history)) {
      return '호기심 표현';
    }
    
    // 랜덤 선택 (다양성)
    final index = DateTime.now().millisecond % availableStyles.length;
    return availableStyles[index];
  }
  
  /// MBTI별 리듬 특성
  String _getMbtiRhythm(String mbti) {
    final rhythmMap = {
      'ENFP': '활발한 리액션, 이모지 활용',
      'INFP': '공감적이고 따뜻한 톤',
      'ENFJ': '격려와 지지, 긍정적',
      'INFJ': '깊이 있고 사려깊은',
      'ENTP': '재치있고 유머러스한',
      'INTP': '논리적이고 차분한',
      'ENTJ': '자신감 있고 직설적',
      'INTJ': '간결하고 핵심적인',
      'ESFP': '밝고 에너지 넘치는',
      'ISFP': '부드럽고 온화한',
      'ESFJ': '친절하고 배려심 깊은',
      'ISFJ': '차분하고 안정적인',
      'ESTP': '즉흥적이고 활동적인',
      'ISTP': '실용적이고 간단명료한',
      'ESTJ': '명확하고 체계적인',
      'ISTJ': '신중하고 일관된',
    };
    
    return rhythmMap[mbti] ?? '';
  }
  
  /// 공감이 필요한지 확인
  bool _needsEmpathy(List<Message> history) {
    if (history.isEmpty) return false;
    
    final lastUserMessage = history.lastWhere(
      (m) => m.isFromUser,
      orElse: () => history.last,
    );
    
    final empathyKeywords = ['힘들', '슬프', '우울', '외로', '아프', '피곤'];
    return empathyKeywords.any((k) => lastUserMessage.content.contains(k));
  }
  
  /// 격려가 필요한지 확인
  bool _needsEncouragement(List<Message> history) {
    if (history.isEmpty) return false;
    
    final lastUserMessage = history.lastWhere(
      (m) => m.isFromUser,
      orElse: () => history.last,
    );
    
    final encouragementKeywords = ['걱정', '불안', '못하', '실패', '어려'];
    return encouragementKeywords.any((k) => lastUserMessage.content.contains(k));
  }
  
  /// 호기심이 필요한지 확인  
  bool _needsCuriosity(List<Message> history) {
    if (history.isEmpty) return false;
    
    final lastUserMessage = history.lastWhere(
      (m) => m.isFromUser,
      orElse: () => history.last,
    );
    
    final curiosityKeywords = ['새로', '처음', '시작', '계획', '생각'];
    return curiosityKeywords.any((k) => lastUserMessage.content.contains(k));
  }
  
  /// 리듬 상태 리셋
  void resetRhythm(String userId, String personaId) {
    final key = '${userId}_$personaId';
    _rhythmCache[key]?.reset();
  }
  
  /// 디버그 정보 출력
  void printDebugInfo(String userId, String personaId) {
    final key = '${userId}_$personaId';
    final rhythm = _rhythmCache[key];
    
    if (rhythm != null) {
      debugPrint('=== Response Rhythm Debug ===');
      debugPrint('Short responses: ${rhythm.shortResponseCount}');
      debugPrint('Long responses: ${rhythm.longResponseCount}');
      debugPrint('Questions: ${rhythm.questionCount}');
      debugPrint('Last style: ${rhythm.lastResponseStyle}');
    }
  }
}