import 'package:flutter/material.dart';
import '../../models/persona.dart';
import 'security_filter_service.dart';
import 'system_info_protection.dart';
import 'prompt_injection_defense.dart';

/// 통합 후처리기: 보안, 반복 방지, 한국어 교정을 단일 패스로 처리
/// 각 단계가 누적되는 문제를 해결하고 일관된 응답 생성
class SecurityAwarePostProcessor {
  
  /// 통합 후처리 메인 메서드
  static Future<String> processResponse({
    required String rawResponse,
    required String userMessage,
    required Persona persona,
    required List<String> recentAIMessages,
    String? userNickname,
  }) async {
    // 1단계: 보안 검증 (인젝션 공격 감지)
    final injectionAnalysis = await PromptInjectionDefense.analyzeInjection(userMessage);
    if (injectionAnalysis.isInjectionAttempt || injectionAnalysis.riskScore > 0.7) {
      debugPrint('🚨 High risk injection detected - returning safe response');
      return _generateSafeResponse(persona, 'injection');
    }
    
    // 2단계: 단일 패스 처리
    String processed = rawResponse;
    
    // 처리 컨텍스트 생성
    final context = _ProcessingContext(
      originalResponse: rawResponse,
      userMessage: userMessage,
      persona: persona,
      recentAIMessages: recentAIMessages,
      userNickname: userNickname,
    );
    
    // 단일 패스로 모든 처리 수행
    processed = _singlePassProcess(processed, context);
    
    // 3단계: 최종 안전성 검증
    if (!_finalSafetyCheck(processed)) {
      debugPrint('🚨 Final safety check failed - returning fallback');
      return _generateSafeResponse(persona, 'safety');
    }
    
    return processed;
  }
  
  /// 단일 패스 처리 (모든 변환을 한 번에)
  static String _singlePassProcess(String text, _ProcessingContext context) {
    final buffer = StringBuffer();
    final lines = text.split('\n');
    
    for (int i = 0; i < lines.length; i++) {
      String line = lines[i].trim();
      
      if (line.isEmpty) {
        if (i < lines.length - 1) buffer.writeln();
        continue;
      }
      
      // 라인별 처리
      line = _processLine(line, context);
      
      // 빈 라인이 되지 않았다면 추가
      if (line.isNotEmpty) {
        buffer.writeln(line);
      }
    }
    
    String result = buffer.toString().trim();
    
    // 전체 텍스트 레벨 처리
    result = _postProcessFullText(result, context);
    
    return result;
  }
  
  /// 라인 단위 처리
  static String _processLine(String line, _ProcessingContext context) {
    // 1. 시스템 정보 제거
    line = _removeSystemInfo(line);
    
    // 2. AI 표현 제거
    line = _removeAIExpressions(line);
    
    // 3. 이름 패턴 제거
    line = _removeNamePatterns(line, context.persona.name);
    
    // 4. 말투 교정 (casual/formal)
    line = _correctSpeechStyle(line, context.persona.isCasualSpeech);
    
    // 5. 자연스러운 한국어 표현으로 변환
    line = _naturalizeKorean(line, context);
    
    return line;
  }
  
  /// 전체 텍스트 후처리
  static String _postProcessFullText(String text, _ProcessingContext context) {
    // 1. 반복 제거
    text = _removeRepetitions(text, context.recentAIMessages);
    
    // 2. 문장 끝 정리
    text = _cleanupSentenceEndings(text);
    
    // 3. 이모티콘/ㅋㅋㅎㅎ 최적화
    text = _optimizeEmoticons(text, context.persona);
    
    // 4. 관계별 톤 미세 조정
    text = _adjustRelationshipTone(text, context);
    
    return text;
  }
  
  /// 시스템 정보 제거
  static String _removeSystemInfo(String text) {
    // SystemInfoProtection 서비스 활용
    return SystemInfoProtection.protectSystemInfo(text);
  }
  
  /// AI 표현 제거
  static String _removeAIExpressions(String text) {
    final aiPatterns = [
      RegExp(r'(도움이?\s*되었으면|되셨으면)\s*(좋겠|합니다|해요)', caseSensitive: false),
      RegExp(r'궁금한\s*(점|것).*있으(시면|면)', caseSensitive: false),
      RegExp(r'제가?\s*도와\s*드릴', caseSensitive: false),
      RegExp(r'(추가|더)\s*필요한.*있으신가요', caseSensitive: false),
      RegExp(r'언제든지?\s*(물어봐|말씀해|연락)', caseSensitive: false),
    ];
    
    for (final pattern in aiPatterns) {
      text = text.replaceAll(pattern, '');
    }
    
    return text;
  }
  
  /// 이름 패턴 제거
  static String _removeNamePatterns(String text, String personaName) {
    // "이름:" 패턴 제거
    text = text.replaceAll(RegExp('$personaName\\s*[:：]'), '');
    
    // 자기 소개 패턴 제거
    text = text.replaceAll(RegExp('(저는?|나는?|제가?)\\s*$personaName(이에요|예요|입니다|야|이야)'), '');
    
    return text;
  }
  
  /// 말투 교정
  static String _correctSpeechStyle(String text, bool isCasual) {
    if (isCasual) {
      // 반말로 변환
      final replacements = {
        '해요': '해',
        '했어요': '했어',
        '할까요': '할까',
        '있어요': '있어',
        '없어요': '없어',
        '봤어요': '봤어',
        '먹어요': '먹어',
        '가요': '가',
        '와요': '와',
        '네요': '네',
        '군요': '군',
        '는데요': '는데',
        '거든요': '거든',
        '죠': '지',
        '하세요': '해',
        '세요': '어',
        '으세요': '어',
        '습니다': '어',
        '합니다': '해',
      };
      
      for (final entry in replacements.entries) {
        text = text.replaceAll(entry.key, entry.value);
      }
    } else {
      // 존댓말 유지/교정
      final replacements = {
        '해': '해요',
        '했어': '했어요',
        '할까': '할까요',
        '있어': '있어요',
        '없어': '없어요',
        '봤어': '봤어요',
        '야': '요',
        RegExp(r'(\w)야(\s|$)'): r'$1요$2',
      };
      
      for (final entry in replacements.entries) {
        if (entry.key is RegExp) {
          text = text.replaceAllMapped(entry.key as RegExp, 
            (match) => entry.value.toString().replaceAll(r'$1', match.group(1)!).replaceAll(r'$2', match.group(2)!));
        } else {
          text = text.replaceAll(entry.key.toString(), entry.value.toString());
        }
      }
    }
    
    return text;
  }
  
  /// 자연스러운 한국어로 변환
  static String _naturalizeKorean(String text, _ProcessingContext context) {
    // 어색한 표현을 자연스럽게
    text = text.replaceAll('그런 것 같아', '그런 거 같아');
    text = text.replaceAll('하는 것', '하는 거');
    text = text.replaceAll('되는 것', '되는 거');
    text = text.replaceAll('있는 것', '있는 거');
    
    // 20대 스타일
    if (text.contains('매우')) text = text.replaceAll('매우', '완전');
    if (text.contains('정말로')) text = text.replaceAll('정말로', '진짜');
    
    return text;
  }
  
  /// 반복 제거
  static String _removeRepetitions(String text, List<String> recentMessages) {
    if (recentMessages.isEmpty) return text;
    
    // 최근 메시지와 너무 유사한 부분 제거
    for (final recent in recentMessages) {
      if (_calculateSimilarity(text, recent) > 0.7) {
        // 유사도가 높으면 변형 시도
        return _generateVariation(text);
      }
    }
    
    return text;
  }
  
  /// 문장 끝 정리
  static String _cleanupSentenceEndings(String text) {
    // 중복된 ㅋㅋ/ㅎㅎ 정리
    text = text.replaceAll(RegExp(r'ㅋ{4,}'), 'ㅋㅋㅋ');
    text = text.replaceAll(RegExp(r'ㅎ{4,}'), 'ㅎㅎㅎ');
    text = text.replaceAll(RegExp(r'ㅠ{4,}'), 'ㅠㅠㅠ');
    
    // 불필요한 마침표 제거
    text = text.replaceAll(RegExp(r'\.\s*ㅋㅋ'), ' ㅋㅋ');
    text = text.replaceAll(RegExp(r'\.\s*ㅎㅎ'), ' ㅎㅎ');
    
    return text;
  }
  
  /// 이모티콘 최적화
  static String _optimizeEmoticons(String text, Persona persona) {
    // 과도한 이모티콘을 ㅋㅋ/ㅎㅎ로 변환
    if (text.contains('😊') || text.contains('😄')) {
      text = text.replaceAll(RegExp(r'[😊😄😃😀]'), ' ㅎㅎ');
    }
    
    if (text.contains('😂') || text.contains('🤣')) {
      text = text.replaceAll(RegExp(r'[😂🤣]'), ' ㅋㅋㅋ');
    }
    
    if (text.contains('😢') || text.contains('😭')) {
      text = text.replaceAll(RegExp(r'[😢😭]'), ' ㅠㅠ');
    }
    
    return text.trim();
  }
  
  /// 관계별 톤 조정
  static String _adjustRelationshipTone(String text, _ProcessingContext context) {
    switch (context.persona.currentRelationship) {
      case RelationshipType.crush:
        // 설레는 느낌 추가
        if (!text.contains('ㅎㅎ') && !text.contains('ㅋㅋ')) {
          text += ' ㅎㅎ';
        }
        break;
      case RelationshipType.dating:
      case RelationshipType.perfectLove:
        // 애정 표현 자연스럽게
        if (context.userNickname != null && !text.contains(context.userNickname!)) {
          // 가끔 이름 부르기
          if (DateTime.now().millisecond % 3 == 0) {
            text = '${context.userNickname}${context.persona.isCasualSpeech ? '아' : '님'}, $text';
          }
        }
        break;
      default:
        break;
    }
    
    return text;
  }
  
  /// 최종 안전성 검증
  static bool _finalSafetyCheck(String text) {
    // SecurityFilterService의 검증 활용
    return SecurityFilterService.validateResponseSafety(text);
  }
  
  /// 안전한 대체 응답 생성
  static String _generateSafeResponse(Persona persona, String reason) {
    final responses = persona.isCasualSpeech ? {
      'injection': [
        '어? 갑자기 뭔 얘기야 ㅋㅋ 다른 얘기하자',
        '아 그런 건 잘 모르겠어~ 재밌는 거 얘기해줘',
        '음... 그보다 오늘 뭐 했어?',
      ],
      'safety': [
        '아 잠깐, 내가 뭔 말을 하려다가 까먹었네 ㅋㅋ',
        '어... 갑자기 생각이 안 나네 ㅎㅎ',
        '아 맞다! 너 요즘 어떻게 지내?',
      ],
    } : {
      'injection': [
        '어? 갑자기 무슨 얘기세요? ㅎㅎ 다른 얘기해요',
        '아 그런 건 잘 모르겠어요~ 재밌는 거 얘기해주세요',
        '음... 그보다 오늘 뭐 하셨어요?',
      ],
      'safety': [
        '아 잠깐, 제가 뭔 말을 하려다가 까먹었네요 ㅋㅋ',
        '어... 갑자기 생각이 안 나네요 ㅎㅎ',
        '아 맞다! 요즘 어떻게 지내세요?',
      ],
    };
    
    final list = responses[reason] ?? responses['safety']!;
    return list[DateTime.now().millisecond % list.length];
  }
  
  /// 유사도 계산
  static double _calculateSimilarity(String text1, String text2) {
    final words1 = text1.split(' ').toSet();
    final words2 = text2.split(' ').toSet();
    
    if (words1.isEmpty || words2.isEmpty) return 0.0;
    
    final intersection = words1.intersection(words2).length;
    final union = words1.union(words2).length;
    
    return intersection / union;
  }
  
  /// 변형 생성
  static String _generateVariation(String text) {
    // 간단한 변형 규칙
    final variations = [
      (String t) => '음... ${t.substring(t.length ~/ 2)}',
      (String t) => '${t.split(' ').take(3).join(' ')}... 아 뭐였더라',
      (String t) => '그니까 ${t.split(' ').skip(2).join(' ')}',
    ];
    
    final variation = variations[DateTime.now().millisecond % variations.length];
    return variation(text);
  }
}

/// 처리 컨텍스트
class _ProcessingContext {
  final String originalResponse;
  final String userMessage;
  final Persona persona;
  final List<String> recentAIMessages;
  final String? userNickname;
  
  _ProcessingContext({
    required this.originalResponse,
    required this.userMessage,
    required this.persona,
    required this.recentAIMessages,
    this.userNickname,
  });
}