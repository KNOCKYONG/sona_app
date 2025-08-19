import 'dart:math';
import '../../../models/message.dart';
import '../../../models/persona.dart';

/// 🎯 최적화된 컨텍스트 관리자
/// 
/// OpenAI API 공식 문서 기반 구현
/// - 토큰 비용 최소화
/// - 컨텍스트 연속성 보장
/// - 중요 정보 우선 순위
class OptimizedContextManager {
  // 토큰 제한 설정
  static const int MAX_CONTEXT_TOKENS = 3000; // 충분한 컨텍스트 유지
  static const int SYSTEM_PROMPT_TOKENS = 500; // 시스템 프롬프트용
  static const int HISTORY_TOKENS = 2300; // 대화 히스토리용
  static const int CURRENT_MESSAGE_TOKENS = 200; // 현재 메시지용
  
  // 메시지 우선순위 가중치
  static const Map<String, double> PRIORITY_WEIGHTS = {
    'emotion_change': 0.9,      // 감정 변화
    'relationship_change': 0.85, // 관계 변화
    'user_info': 0.8,           // 사용자 정보
    'topic_start': 0.75,        // 주제 시작
    'question': 0.7,            // 질문
    'answer': 0.65,             // 답변
    'recent': 0.6,              // 최근 메시지
    'general': 0.3,             // 일반 대화
  };
  
  /// 📊 최적화된 메시지 선택
  static List<Message> selectOptimalMessages({
    required List<Message> fullHistory,
    required String currentMessage,
    required int maxMessages,
  }) {
    if (fullHistory.isEmpty) return [];
    
    // 1. 메시지 점수 계산
    final scoredMessages = <_ScoredMessage>[];
    
    for (int i = 0; i < fullHistory.length; i++) {
      final msg = fullHistory[i];
      final score = _calculateMessageScore(
        message: msg,
        index: i,
        totalMessages: fullHistory.length,
        currentMessage: currentMessage,
      );
      
      scoredMessages.add(_ScoredMessage(msg, score, i));
    }
    
    // 2. 점수순 정렬
    scoredMessages.sort((a, b) => b.score.compareTo(a.score));
    
    // 3. 컨텍스트 연속성 보장하며 선택
    final selectedMessages = _selectWithContinuity(
      scoredMessages: scoredMessages,
      maxMessages: maxMessages,
    );
    
    // 4. 시간순 정렬
    selectedMessages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    
    return selectedMessages;
  }
  
  /// 🎯 메시지 점수 계산
  static double _calculateMessageScore({
    required Message message,
    required int index,
    required int totalMessages,
    required String currentMessage,
  }) {
    double score = 0.0;
    
    // 1. 최근성 점수 (0~0.3)
    final recency = index / totalMessages;
    score += recency * PRIORITY_WEIGHTS['recent']!;
    
    // 2. 감정 변화 점수 (중요도 높음)
    if (message.emotion != null && message.emotion != EmotionType.neutral) {
      score += PRIORITY_WEIGHTS['emotion_change']!;
    }
    
    // 3. 관계 변화 점수 (likesChange가 있으면 높은 점수)
    if (message.likesChange != null && message.likesChange != 0) {
      score += PRIORITY_WEIGHTS['relationship_change']!;
      // 큰 변화일수록 보너스
      if (message.likesChange!.abs() >= 20) {
        score += 0.2;
      }
    }
    
    // 4. 질문/답변 쌍 점수
    if (message.content.contains('?')) {
      score += PRIORITY_WEIGHTS['question']!;
    }
    
    // 5. 사용자 정보 포함 점수
    if (_containsUserInfo(message.content)) {
      score += PRIORITY_WEIGHTS['user_info']!;
    }
    
    // 6. 현재 메시지와 관련성 (더 높은 가중치)
    final relevance = _calculateRelevance(message.content, currentMessage);
    score += relevance * 1.2;  // 0.5 -> 1.2로 증가
    
    // 7. 최근 3개 메시지는 보너스
    if (index >= totalMessages - 3) {
      score += 0.3;
    }
    
    return score.clamp(0.0, 2.5);
  }
  
  /// 🔗 컨텍스트 연속성 보장 선택
  static List<Message> _selectWithContinuity({
    required List<_ScoredMessage> scoredMessages,
    required int maxMessages,
  }) {
    final selected = <Message>[];
    final selectedIds = <String>{};
    
    // 1. 최근 1개 메시지는 무조건 포함
    if (scoredMessages.isNotEmpty) {
      final lastMsg = scoredMessages.reduce((a, b) => 
          a.originalIndex > b.originalIndex ? a : b);
      selected.add(lastMsg.message);
      selectedIds.add(lastMsg.message.id);
    }
    
    // 2. 높은 점수 메시지 추가 (점수 0.7 이상)
    final highScoreMessages = scoredMessages
        .where((m) => m.score >= 0.7 && !selectedIds.contains(m.message.id))
        .toList()
      ..sort((a, b) => b.score.compareTo(a.score));
    
    for (final scored in highScoreMessages) {
      if (selected.length >= maxMessages) break;
      selected.add(scored.message);
      selectedIds.add(scored.message.id);
    }
    
    // 3. 부족하면 나머지 메시지로 채우기
    if (selected.length < maxMessages) {
      final remainingMessages = scoredMessages
          .where((m) => !selectedIds.contains(m.message.id))
          .toList()
        ..sort((a, b) => b.score.compareTo(a.score));
      
      for (final scored in remainingMessages) {
        if (selected.length >= maxMessages) break;
        selected.add(scored.message);
        selectedIds.add(scored.message.id);
      }
    }
    
    return selected;
  }
  
  /// 📝 메시지 압축 (토큰 절약)
  static String compressMessage(String message, {int maxLength = 100}) {
    if (message.length <= maxLength) return message;
    
    // 1. 중복 공백 제거
    String compressed = message.replaceAll(RegExp(r'\s+'), ' ').trim();
    
    // 2. 길이가 초과하면 자르고 ... 추가
    if (compressed.length > maxLength) {
      compressed = compressed.substring(0, maxLength - 3) + '...';
    }
    
    return compressed;
  }
  
  /// 🔍 사용자 정보 포함 여부
  static bool _containsUserInfo(String content) {
    final userInfoPatterns = [
      '나는', '내가', '제가', '저는',  // 자기 소개
      '좋아해', '싫어해',              // 선호도
      '있어', '없어',                  // 상태
      '했어', '할거야',                // 활동
      RegExp(r'\d+살'),               // 나이
      RegExp(r'[0-9]+시'),            // 시간
    ];
    
    final lower = content.toLowerCase();
    return userInfoPatterns.any((pattern) {
      if (pattern is String) {
        return lower.contains(pattern);
      } else if (pattern is RegExp) {
        return pattern.hasMatch(lower);
      }
      return false;
    });
  }
  
  /// 🎯 관련성 계산
  static double _calculateRelevance(String message, String currentMessage) {
    final msgLower = message.toLowerCase();
    final currentLower = currentMessage.toLowerCase();
    
    // 한글과 영어 모두 처리할 수 있도록 개선
    final msgWords = msgLower.split(RegExp(r'[\s,\.\!\?]+'));
    final currentWords = currentLower.split(RegExp(r'[\s,\.\!\?]+'));
    
    int commonWords = 0;
    double relevanceScore = 0.0;
    
    // 각 단어별로 관련성 체크
    for (final word in currentWords) {
      if (word.length >= 2) {
        // 정확히 일치하는 단어가 있으면 높은 점수
        if (msgWords.contains(word)) {
          commonWords++;
          relevanceScore += 1.0;
        }
        // 부분 일치도 체크 (예: "서울" in "서울에")
        else if (msgLower.contains(word)) {
          commonWords++;
          relevanceScore += 0.8;
        }
      }
    }
    
    if (currentWords.isEmpty) return 0.0;
    
    // 일치하는 단어 비율과 관련성 점수 모두 고려
    final ratio = (commonWords / currentWords.length);
    return ((ratio + relevanceScore / currentWords.length) / 2).clamp(0.0, 1.0);
  }
  
  /// 🔤 키워드 추출
  static List<String> _extractKeywords(String text) {
    // 불용어 제거
    final stopWords = {
      '그', '저', '이', '그리고', '하지만', '그런데',
      '는', '은', '이', '가', '을', '를', '에', '에서',
      'the', 'is', 'at', 'which', 'on', 'and', 'a', 'an',
    };
    
    final words = text.split(RegExp(r'[\s,\.!?]+'));
    final keywords = <String>[];
    
    for (final word in words) {
      if (word.length > 2 && !stopWords.contains(word.toLowerCase())) {
        keywords.add(word);
      }
    }
    
    // 최대 10개 키워드만
    return keywords.take(10).toList();
  }
  
  /// 📊 토큰 수 추정 (정확도 향상)
  static int estimateTokens(String text) {
    // OpenAI 공식 추정 방식
    // 영어: ~4 chars = 1 token
    // 한글: ~2-3 chars = 1 token (한글이 더 많은 토큰 사용)
    
    int koreanChars = 0;
    int englishChars = 0;
    int specialChars = 0;
    
    for (int i = 0; i < text.length; i++) {
      final char = text[i];
      if (RegExp(r'[가-힣]').hasMatch(char)) {
        koreanChars++;
      } else if (RegExp(r'[a-zA-Z]').hasMatch(char)) {
        englishChars++;
      } else {
        specialChars++;
      }
    }
    
    // 더 정확한 토큰 추정
    final koreanTokens = (koreanChars / 2.5).ceil();
    final englishTokens = (englishChars / 4).ceil();
    final specialTokens = (specialChars / 3).ceil();
    
    return koreanTokens + englishTokens + specialTokens;
  }
  
  /// 🎯 컨텍스트 요약 생성 (시스템 프롬프트용)
  static String generateContextSummary({
    required List<Message> messages,
    required String userId,
    required String personaId,
  }) {
    if (messages.isEmpty) return '';
    
    final summary = StringBuffer();
    
    // 1. 대화 통계
    final userMessages = messages.where((m) => m.isFromUser).length;
    final aiMessages = messages.length - userMessages;
    summary.writeln('대화 기록: 사용자 $userMessages개, AI $aiMessages개 메시지');
    
    // 2. 주요 주제
    final topics = _extractTopics(messages);
    if (topics.isNotEmpty) {
      summary.writeln('주요 주제: ${topics.join(', ')}');
    }
    
    // 3. 감정 변화
    final emotions = messages
        .where((m) => m.emotion != null && m.emotion != EmotionType.neutral)
        .map((m) => m.emotion!.name)
        .toSet()
        .toList();
    if (emotions.isNotEmpty) {
      summary.writeln('감정 상태: ${emotions.join(', ')}');
    }
    
    // 4. 중요 정보
    final importantInfo = _extractImportantInfo(messages);
    if (importantInfo.isNotEmpty) {
      summary.writeln('중요 정보: $importantInfo');
    }
    
    return summary.toString();
  }
  
  /// 🏷️ 주제 추출
  static List<String> _extractTopics(List<Message> messages) {
    final topicKeywords = {
      '날씨': ['날씨', '비', '눈', '맑', '흐림', '추워', '더워'],
      '음식': ['먹', '밥', '음식', '배고', '맛있', '요리'],
      '감정': ['좋아', '싫어', '사랑', '행복', '슬퍼', '우울'],
      '일상': ['오늘', '어제', '내일', '일', '학교', '회사'],
      '취미': ['영화', '음악', '게임', '운동', '책', '여행'],
    };
    
    final topics = <String>{};
    final allContent = messages.map((m) => m.content).join(' ').toLowerCase();
    
    topicKeywords.forEach((topic, keywords) {
      if (keywords.any((k) => allContent.contains(k))) {
        topics.add(topic);
      }
    });
    
    return topics.toList()..take(3); // 최대 3개 주제
  }
  
  /// 💡 중요 정보 추출
  static String _extractImportantInfo(List<Message> messages) {
    final info = <String>[];
    
    for (final msg in messages) {
      if (!msg.isFromUser) continue;
      
      // 나이 정보
      final ageMatch = RegExp(r'(\d+)살').firstMatch(msg.content);
      if (ageMatch != null) {
        info.add('${ageMatch.group(1)}살');
      }
      
      // 시간 정보
      final timeMatch = RegExp(r'(\d+)시').firstMatch(msg.content);
      if (timeMatch != null) {
        info.add('${timeMatch.group(1)}시 언급');
      }
      
      // 장소 정보
      final places = ['집', '회사', '학교', '카페', '식당'];
      for (final place in places) {
        if (msg.content.contains(place)) {
          info.add(place);
          break;
        }
      }
    }
    
    return info.take(3).join(', ');
  }
}

/// 점수가 매겨진 메시지
class _ScoredMessage {
  final Message message;
  final double score;
  final int originalIndex;
  
  _ScoredMessage(this.message, this.score, this.originalIndex);
}