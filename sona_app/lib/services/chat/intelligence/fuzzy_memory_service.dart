import 'package:flutter/material.dart';
import '../../../models/message.dart';
import 'conversation_memory_service.dart';

/// 인간적인 흐릿한 기억 시스템
/// 정확한 디테일보다 감정과 맥락을 우선시
class FuzzyMemoryService {
  
  /// 시간 경과에 따른 기억 표현
  static String getFuzzyTimeExpression(DateTime eventTime) {
    final now = DateTime.now();
    final difference = now.difference(eventTime);
    
    if (difference.inMinutes < 30) {
      return "방금 전에";
    } else if (difference.inHours < 2) {
      return "아까";
    } else if (difference.inHours < 12) {
      return "오늘 ${_getTimeOfDay(eventTime)}에";
    } else if (difference.inDays == 1) {
      return "어제";
    } else if (difference.inDays == 2) {
      return "그저께";
    } else if (difference.inDays < 7) {
      return "${difference.inDays}일 전에";
    } else if (difference.inDays < 14) {
      return "지난주에";
    } else if (difference.inDays < 30) {
      return "몇 주 전에";
    } else {
      return "예전에";
    }
  }
  
  /// 기억의 선명도 수준
  static String getMemoryClarityLevel(DateTime eventTime) {
    final now = DateTime.now();
    final hoursSince = now.difference(eventTime).inHours;
    
    if (hoursSince < 24) {
      return "clear"; // 선명한 기억
    } else if (hoursSince < 72) {
      return "moderate"; // 보통 기억
    } else if (hoursSince < 168) { // 1주일
      return "fuzzy"; // 흐릿한 기억
    } else {
      return "vague"; // 아주 흐릿한 기억
    }
  }
  
  /// 흐릿한 기억 표현 생성
  static String generateFuzzyMemoryExpression({
    required String content,
    required DateTime timestamp,
    required String emotion,
    bool isDetailed = false,
  }) {
    final clarity = getMemoryClarityLevel(timestamp);
    final timeExpr = getFuzzyTimeExpression(timestamp);
    
    switch (clarity) {
      case "clear":
        // 선명한 기억 - 디테일 포함
        if (content.contains('부장') || content.contains('상사')) {
          return "$timeExpr 부장님 때문에 스트레스 받았다고 했잖아";
        }
        return "$timeExpr ${content} 얘기했잖아";
        
      case "moderate":
        // 보통 기억 - 주요 내용만
        if (emotion == 'stressed' || emotion == 'angry') {
          return "$timeExpr 뭔가 짜증나는 일 있었다고 했던 것 같은데";
        }
        return "$timeExpr 그런 얘기 했던 것 같아";
        
      case "fuzzy":
        // 흐릿한 기억 - 감정 위주
        if (emotion == 'stressed') {
          return "저번에 스트레스 받는다고 했던 것 같은데... 정확히는 기억 안 나";
        } else if (emotion == 'happy') {
          return "예전에 좋은 일 있었다고 했던 것 같은데";
        }
        return "전에 비슷한 얘기 했던 것 같은데";
        
      case "vague":
      default:
        // 아주 흐릿한 기억 - 맥락만
        return "언젠가 그런 얘기 했던 것 같기도 하고... 잘 기억은 안 나는데";
    }
  }
  
  /// 감정 우선 기억 (감정 > 사실 > 디테일)
  static Map<String, dynamic> prioritizeMemoryElements(ConversationMemory memory) {
    return {
      'emotion': memory.emotion.name, // 최우선
      'generalContext': _extractGeneralContext(memory.content), // 차선
      'specificDetails': _extractDetails(memory.content), // 최후순위
      'timestamp': memory.timestamp,
    };
  }
  
  /// 일반적 맥락 추출
  static String _extractGeneralContext(String content) {
    // 구체적 내용을 일반화
    if (content.contains('부장') || content.contains('상사')) {
      return "직장 스트레스";
    } else if (content.contains('술') || content.contains('맥주')) {
      return "음주";
    } else if (content.contains('야근') || content.contains('일')) {
      return "업무 관련";
    } else if (content.contains('친구') || content.contains('만나')) {
      return "사교 활동";
    }
    return "일상 대화";
  }
  
  /// 세부사항 추출 (가장 나중에 잊혀짐)
  static String? _extractDetails(String content) {
    // 숫자, 시간, 구체적 이름 등
    final detailPattern = RegExp(r'\d+시|\d+개|\d+명|[가-힣]+님');
    final match = detailPattern.firstMatch(content);
    return match?.group(0);
  }
  
  /// 연관 기억 트리거
  static List<String> getAssociativeMemories({
    required String currentTopic,
    required List<ConversationMemory> memories,
  }) {
    final associations = <String>[];
    
    // 현재 주제와 관련된 과거 기억 찾기
    for (final memory in memories) {
      if (_isRelated(currentTopic, memory.content)) {
        final timeExpr = getFuzzyTimeExpression(memory.timestamp);
        final clarity = getMemoryClarityLevel(memory.timestamp);
        
        if (clarity == "clear" || clarity == "moderate") {
          // 비교적 선명한 기억
          associations.add("아 맞다, $timeExpr에도 비슷한 얘기 했었네");
        } else {
          // 흐릿한 기억
          associations.add("전에도 이런 얘기 한 것 같은데...");
        }
      }
    }
    
    // 반복 패턴 감지
    final topicCount = memories.where((m) => 
      m.content.contains(currentTopic)).length;
    
    if (topicCount >= 3) {
      associations.add("또 ${currentTopic} 얘기야? 맨날 그것 때문에 힘들어하네");
    } else if (topicCount >= 2) {
      associations.add("저번에도 ${currentTopic} 때문에 스트레스 받는다고 했잖아");
    }
    
    return associations;
  }
  
  /// 관련성 판단
  static bool _isRelated(String topic1, String topic2) {
    // 관련 키워드 그룹
    final relatedGroups = [
      ['부장', '상사', '팀장', '직장', '회사', '야근'],
      ['술', '맥주', '소주', '음주', '한잔'],
      ['스트레스', '짜증', '힘들', '피곤', '지쳐'],
      ['친구', '만나', '약속', '데이트'],
    ];
    
    for (final group in relatedGroups) {
      bool topic1InGroup = false;
      bool topic2InGroup = false;
      
      for (final keyword in group) {
        if (topic1.contains(keyword)) topic1InGroup = true;
        if (topic2.contains(keyword)) topic2InGroup = true;
      }
      
      if (topic1InGroup && topic2InGroup) return true;
    }
    
    return false;
  }
  
  /// 자연스러운 기억 회상 패턴
  static String generateNaturalRecall({
    required String topic,
    required List<ConversationMemory> memories,
  }) {
    // 관련 기억 찾기
    ConversationMemory? relevantMemory;
    for (final memory in memories) {
      if (memory.content.contains(topic)) {
        relevantMemory = memory;
        break;
      }
    }
    
    if (relevantMemory == null) {
      return "";
    }
    
    final clarity = getMemoryClarityLevel(relevantMemory.timestamp);
    final timeExpr = getFuzzyTimeExpression(relevantMemory.timestamp);
    
    // 자연스러운 회상 표현들
    final recallPatterns = <String>[];
    
    switch (clarity) {
      case "clear":
        recallPatterns.addAll([
          "$timeExpr $topic 얘기했잖아, 기억나",
          "아 맞아, $timeExpr $topic 때문에 힘들다고 했었지",
        ]);
        break;
        
      case "moderate":
        recallPatterns.addAll([
          "$timeExpr 그런 얘기 했던 것 같은데... $topic 말이야",
          "언제였더라... $timeExpr쯤? $topic 얘기 했었잖아",
        ]);
        break;
        
      case "fuzzy":
        recallPatterns.addAll([
          "정확히 기억은 안 나는데, 전에도 $topic 얘기 했던 것 같아",
          "$topic... 어디서 들은 것 같은데... 아 우리가 얘기했었나?",
        ]);
        break;
        
      default:
        recallPatterns.addAll([
          "뭔가 $topic 관련해서 얘기한 적 있는 것 같기도 하고...",
          "$topic? 음... 잘 기억은 안 나네",
        ]);
    }
    
    // 랜덤하게 하나 선택
    final index = DateTime.now().millisecond % recallPatterns.length;
    return recallPatterns[index];
  }
  
  /// 시간대 표현
  static String _getTimeOfDay(DateTime time) {
    final hour = time.hour;
    if (hour < 6) return "새벽";
    if (hour < 12) return "아침";
    if (hour < 14) return "점심때";
    if (hour < 18) return "오후";
    if (hour < 21) return "저녁";
    return "밤";
  }
}