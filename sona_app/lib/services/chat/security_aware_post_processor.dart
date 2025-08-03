import 'package:flutter/material.dart';
import '../../models/persona.dart';
import 'persona_prompt_builder.dart';

/// 간소화된 후처리기: 응답 길이 제한과 기본적인 후처리만 수행
/// OpenAIService에서 이미 보안 필터링을 하므로 중복 제거
class SecurityAwarePostProcessor {
  
  /// 간소화된 후처리 메인 메서드
  static String processResponse({
    required String rawResponse,
    required Persona persona,
    String? userNickname,
  }) {
    String processed = rawResponse;
    
    // 1단계: 기본적인 텍스트 정리
    processed = _cleanupText(processed);
    
    // 2단계: 이모티콘 최적화 (한국어 스타일)
    processed = _optimizeEmoticons(processed);
    
    // 길이 제한은 ChatOrchestrator에서 메시지 분리로 처리
    
    return processed;
  }
  
  /// 기본적인 텍스트 정리
  static String _cleanupText(String text) {
    // 중복된 ㅋㅋ/ㅎㅎ/ㅠㅠ 정리
    text = text.replaceAll(RegExp(r'ㅋ{4,}'), 'ㅋㅋㅋ');
    text = text.replaceAll(RegExp(r'ㅎ{4,}'), 'ㅎㅎㅎ');
    text = text.replaceAll(RegExp(r'ㅠ{4,}'), 'ㅠㅠㅠ');
    text = text.replaceAll(RegExp(r'~{3,}'), '~~');
    
    // 불필요한 공백 정리
    text = text.replaceAll(RegExp(r'\s+'), ' ');
    text = text.trim();
    
    // 부드러운 표현으로 변환
    text = _softenExpression(text);
    
    // 의문문은 반드시 ?로 끝나도록
    if (_isQuestion(text) && !text.contains('?')) {
      // 마지막 문장을 찾아서 처리
      final sentences = text.split(RegExp(r'[.!?]\s*'));
      if (sentences.isNotEmpty) {
        final lastSentence = sentences.last.trim();
        
        // ㅋㅋ, ㅎㅎ, ㅠㅠ 등으로 끝나는 경우
        final laughMatch = RegExp(r'([ㅋㅎㅠ]+)$').firstMatch(lastSentence);
        if (laughMatch != null) {
          // "뭐해ㅋㅋ" -> "뭐해?ㅋㅋ"
          final beforeLaugh = lastSentence.substring(0, laughMatch.start);
          final laugh = laughMatch.group(0)!;
          
          // 이미 처리된 부분 + 수정된 마지막 문장
          final beforeLastSentence = sentences.length > 1 
              ? sentences.sublist(0, sentences.length - 1).join('. ') + '. '
              : '';
          text = beforeLastSentence + beforeLaugh + '?' + laugh;
        } else {
          // 마침표를 물음표로 변경
          if (text.endsWith('.')) {
            text = text.substring(0, text.length - 1) + '?';
          } else {
            text += '?';
          }
        }
      }
    }
    
    return text;
  }
  
  /// 부드러운 표현으로 변환
  static String _softenExpression(String text) {
    // 딱딱한 표현을 부드럽게 변환
    final softExpressions = {
      // 의문문 패턴
      RegExp(r'무슨\s+점이\s+마음에\s+들었나요'): '뭐가 좋았어요',
      RegExp(r'어떤\s+점이\s+좋았나요'): '뭐가 좋았어요',
      RegExp(r'무엇을\s+원하시나요'): '뭐 원해요',
      RegExp(r'어떻게\s+생각하시나요'): '어떻게 생각해요',
      RegExp(r'괜찮으신가요'): '괜찮아요',
      RegExp(r'어떠신가요'): '어때요',
      RegExp(r'계신가요'): '있어요',
      RegExp(r'하시나요'): '해요',
      RegExp(r'되시나요'): '돼요',
      RegExp(r'이신가요'): '이에요',
      RegExp(r'인가요'): '이에요',
      
      // 일반적인 ~나요 → ~어요 변환
      RegExp(r'([가-힣]+)나요(?=[?]|$)'): r'$1어요',
      RegExp(r'([가-힣]+)시나요(?=[?]|$)'): r'$1어요',
      RegExp(r'([가-힣]+)신가요(?=[?]|$)'): r'$1어요',
      
      // ~습니까 → ~어요 변환
      RegExp(r'([가-힣]+)습니까(?=[?]|$)'): r'$1어요',
      RegExp(r'([가-힣]+)습니다'): r'$1어요',
      
      // 너무 격식있는 표현
      RegExp(r'그러십니까'): '그래요',
      RegExp(r'그렇습니까'): '그래요',
      RegExp(r'아니십니까'): '아니에요',
      
      // 딱딱한 공감 표현
      RegExp(r'그런\s*감정\s*이해해요'): '아 진짜 슬펐겠다',
      RegExp(r'마음이\s*아프시겠어요'): '아 속상하겠다',
      RegExp(r'이해가\s*됩니다'): '그럴 수 있어요',
      RegExp(r'공감이\s*됩니다'): '나도 그럴 것 같아요',
    };
    
    String result = text;
    for (final entry in softExpressions.entries) {
      result = result.replaceAll(entry.key, entry.value);
    }
    
    return result;
  }
  
  /// 의문문인지 확인
  static bool _isQuestion(String text) {
    final questionWords = ['뭐', '어디', '언제', '누구', '왜', '어떻게', '얼마', '몇', '어느', '무슨', '무엇'];
    final questionEndings = [
      '니', '나요', '까', '까요', '어요', '을까', '을까요', '는지', '은지', '나', '냐',
      '어', '야', '지', '죠', '는데', '은데', '던데', '는가', '은가', '가요', '나요',
      '래', '래요', '대', '대요', '던가', '던가요', '인가', '인가요'
    ];
    
    // 문장 정리 (마침표, 느낌표 제거)
    final cleanText = text.replaceAll(RegExp(r'[.!]+$'), '').trim();
    final lower = cleanText.toLowerCase();
    
    // 의문사가 포함된 경우
    for (final word in questionWords) {
      if (lower.contains(word)) return true;
    }
    
    // 의문형 어미로 끝나는 경우 (ㅋㅋ, ㅎㅎ 등 제외하고 확인)
    final textWithoutLaugh = lower.replaceAll(RegExp(r'[ㅋㅎㅠ]+$'), '').trim();
    for (final ending in questionEndings) {
      if (textWithoutLaugh.endsWith(ending)) return true;
    }
    
    // "~하는 거" 패턴도 의문문으로 처리
    if (lower.contains('하는 거') || lower.contains('하는 건') || 
        lower.contains('인 거') || lower.contains('인 건')) {
      return true;
    }
    
    return false;
  }
  
  /// 이모티콘 최적화 (한국어 스타일)
  static String _optimizeEmoticons(String text) {
    // 과도한 이모티콘을 ㅋㅋ/ㅎㅎ로 변환
    final emojiMap = {
      RegExp(r'[😊😄😃😀🙂☺️]+') : 'ㅎㅎ',
      RegExp(r'[😂🤣]+') : 'ㅋㅋㅋ',
      RegExp(r'[😢😭😥😰]+') : 'ㅠㅠ',
      RegExp(r'[😍🥰😘]+') : '♥',
      RegExp(r'[😮😲😯😳]+') : '헐',
      RegExp(r'[😤😠😡🤬]+') : '화나',
    };
    
    for (final entry in emojiMap.entries) {
      if (text.contains(entry.key)) {
        text = text.replaceAll(entry.key, ' ${entry.value}');
      }
    }
    
    // 중복 공백 제거
    text = text.replaceAll(RegExp(r'\s+'), ' ').trim();
    
    return text;
  }
}