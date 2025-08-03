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
    
    // 1단계: MBTI별 응답 길이 제한 적용
    processed = _enforceResponseLength(processed, persona.mbti);
    
    // 2단계: 기본적인 텍스트 정리
    processed = _cleanupText(processed);
    
    // 3단계: 이모티콘 최적화 (한국어 스타일)
    processed = _optimizeEmoticons(processed);
    
    return processed;
  }
  
  /// MBTI별 응답 길이 제한 적용
  static String _enforceResponseLength(String text, String mbti) {
    final responseLength = PersonaPromptBuilder.getMBTIResponseLength(mbti.toUpperCase());
    
    // 최대 길이를 초과하면 자연스러운 위치에서 자르기
    if (text.length > responseLength.max) {
      // 마지막 문장 부호나 공백에서 자르기
      int cutIndex = responseLength.max;
      
      // 문장 부호 찾기
      final punctuations = ['!', '?', '.', '~', 'ㅋ', 'ㅎ', 'ㅠ'];
      int lastPuncIndex = -1;
      
      for (final punc in punctuations) {
        final index = text.lastIndexOf(punc, cutIndex);
        if (index > lastPuncIndex && index > responseLength.min) {
          lastPuncIndex = index;
        }
      }
      
      if (lastPuncIndex > 0) {
        // 문장 부호 뒤의 반복되는 문자들도 포함
        cutIndex = lastPuncIndex + 1;
        while (cutIndex < text.length && 
               cutIndex < responseLength.max && 
               (text[cutIndex] == text[lastPuncIndex] || text[cutIndex] == ' ')) {
          cutIndex++;
        }
        text = text.substring(0, cutIndex).trim();
      } else {
        // 공백에서 자르기
        final spaceIndex = text.lastIndexOf(' ', cutIndex);
        if (spaceIndex > responseLength.min) {
          text = text.substring(0, spaceIndex).trim() + '...';
        } else {
          text = text.substring(0, cutIndex).trim() + '...';
        }
      }
    }
    
    return text;
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
    
    // 의문문은 반드시 ?로 끝나도록
    if (_isQuestion(text) && !text.endsWith('?')) {
      // ㅋㅋ, ㅎㅎ 등으로 끝나는 경우
      if (text.endsWith('ㅋ') || text.endsWith('ㅎ')) {
        // "뭐해ㅋㅋ" -> "뭐해?ㅋㅋ"
        final lastChar = text[text.length - 1];
        int endIndex = text.length - 1;
        while (endIndex > 0 && text[endIndex] == lastChar) {
          endIndex--;
        }
        text = text.substring(0, endIndex + 1) + '?' + text.substring(endIndex + 1);
      } else {
        text += '?';
      }
    }
    
    return text;
  }
  
  /// 의문문인지 확인
  static bool _isQuestion(String text) {
    final questionWords = ['뭐', '어디', '언제', '누구', '왜', '어떻게', '얼마', '몇'];
    final questionEndings = ['니', '나요', '까', '까요', '어요', '을까', '을까요'];
    
    final lower = text.toLowerCase();
    
    // 의문사로 시작하는 경우
    for (final word in questionWords) {
      if (lower.startsWith(word)) return true;
    }
    
    // 의문형 어미로 끝나는 경우
    for (final ending in questionEndings) {
      if (lower.endsWith(ending)) return true;
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