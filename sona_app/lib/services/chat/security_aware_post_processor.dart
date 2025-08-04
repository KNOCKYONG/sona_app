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
    
    // 2단계: 문장 완성도 검증 및 수정
    processed = _ensureCompleteSentence(processed);
    
    // 3단계: 이모티콘 최적화 (한국어 스타일)
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
    String result = text;
    
    // 1. 구체적인 패턴 먼저 처리 (replaceAll 사용)
    final specificPatterns = {
      // 의문문 패턴
      '무슨 점이 마음에 들었나요': '뭐가 좋았어요',
      '어떤 점이 좋았나요': '뭐가 좋았어요',
      '무엇을 원하시나요': '뭐 원해요',
      '어떻게 생각하시나요': '어떻게 생각해요',
      '괜찮으신가요': '괜찮으세요',
      '어떠신가요': '어떠세요',
      '계신가요': '계세요',
      '하시나요': '하세요',
      '되시나요': '되세요',
      '오시나요': '오세요',
      '가시나요': '가세요',
      '좋으신가요': '좋으세요',
      '이신가요': '이세요',
      '인가요': '인가요',  // 그대로 유지
      
      // ~습니까 → ~어요/아요
      '있습니까': '있어요',
      '없습니까': '없어요',
      '좋습니까': '좋아요',
      '맞습니까': '맞아요',
      '합니까': '해요',
      '됩니까': '돼요',
      '갑니까': '가요',
      '옵니까': '와요',
      
      // 너무 격식있는 표현
      '그러십니까': '그러세요',
      '그렇습니까': '그래요',
      '아니십니까': '아니세요',
      
      // 딱딱한 공감 표현
      '그런 감정 이해해요': '아 진짜 슬펐겠다',
      '마음이 아프시겠어요': '아 속상하겠다',
      '이해가 됩니다': '그럴 수 있어요',
      '공감이 됩니다': '나도 그럴 것 같아요',
    };
    
    // 구체적인 패턴 적용
    for (final entry in specificPatterns.entries) {
      result = result.replaceAll(entry.key, entry.value);
    }
    
    // 2. 정규표현식 패턴 처리 (replaceAllMapped 사용)
    // ~시나요? → ~세요?
    result = result.replaceAllMapped(
      RegExp(r'([가-힣]+)시나요(?=\?|$)'),
      (match) => '${match.group(1)}세요'
    );
    
    // ~신가요? → ~세요?
    result = result.replaceAllMapped(
      RegExp(r'([가-힣]+)신가요(?=\?|$)'),
      (match) => '${match.group(1)}세요'
    );
    
    // 있나요? → 있어요?
    result = result.replaceAllMapped(
      RegExp(r'있나요(?=\?|$)'),
      (match) => '있어요'
    );
    
    // 없나요? → 없어요?
    result = result.replaceAllMapped(
      RegExp(r'없나요(?=\?|$)'),
      (match) => '없어요'
    );
    
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
  
  /// 문장 완성도 검증 및 수정
  static String _ensureCompleteSentence(String text) {
    if (text.isEmpty) return text;
    
    // 문장 종결 어미 패턴
    final sentenceEndings = [
      '요', '죠', '네요', '어요', '아요', '해요', '이에요', '예요',
      '습니다', '합니다', '입니다', '다', '어', '아', '지', '야',
      '까', '까요', '나', '나요', '니', '거든', '잖아', '는데',
      '!', '?', '.', '~', 'ㅋ', 'ㅎ', 'ㅠ', '♡', '♥', '💕'
    ];
    
    // 불완전한 종결 패턴 (이것으로 끝나면 불완전함)
    final incompleteEndings = [
      '때가', '하는', '있는', '없는', '같은', '되는', '라는', '이라는',
      '때', '것', '듯', '중', '그', '이', '를', '을', '에서', '으로'
    ];
    
    // 마지막 문자/단어 확인
    String trimmed = text.trim();
    
    // 이미 완전한 문장인지 확인
    bool isComplete = false;
    for (final ending in sentenceEndings) {
      if (trimmed.endsWith(ending)) {
        isComplete = true;
        break;
      }
    }
    
    if (isComplete) return text;
    
    // 불완전한 문장인지 확인
    bool isIncomplete = false;
    String lastWord = '';
    
    for (final ending in incompleteEndings) {
      if (trimmed.endsWith(ending)) {
        isIncomplete = true;
        lastWord = ending;
        break;
      }
    }
    
    // 불완전한 문장 수정
    if (isIncomplete) {
      // 문맥에 따라 적절한 종결어미 추가
      if (lastWord == '때가' || lastWord == '때') {
        return trimmed + ' 좋아요';
      } else if (lastWord.endsWith('하는') || lastWord.endsWith('되는')) {
        return trimmed + ' 거예요';
      } else if (lastWord.endsWith('있는') || lastWord.endsWith('없는')) {
        return trimmed + ' 편이에요';
      } else if (lastWord == '중') {
        return trimmed + '이에요';
      } else {
        // 기본적으로 자연스러운 종결
        return trimmed + '요';
      }
    }
    
    // 그 외의 경우 기본 종결어미 추가
    // 마지막 글자가 받침이 있는지 확인
    final lastChar = trimmed[trimmed.length - 1];
    final lastCharCode = lastChar.codeUnitAt(0);
    
    // 한글인 경우
    if (lastCharCode >= 0xAC00 && lastCharCode <= 0xD7A3) {
      final hasJongsung = (lastCharCode - 0xAC00) % 28 != 0;
      if (hasJongsung) {
        return trimmed + '이에요';
      } else {
        return trimmed + '예요';
      }
    }
    
    // 한글이 아닌 경우 기본값
    return trimmed + '요';
  }
}