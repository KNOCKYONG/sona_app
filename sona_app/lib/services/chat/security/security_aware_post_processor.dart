import 'package:flutter/material.dart';
import '../../../models/persona.dart';
import '../prompts/persona_prompt_builder.dart';

/// 간소화된 후처리기: 응답 길이 제한과 기본적인 후처리만 수행
/// OpenAIService에서 이미 보안 필터링을 하므로 중복 제거
class SecurityAwarePostProcessor {
  // 최근 응답 저장 (매크로 감지용)
  static final List<String> _recentResponses = [];
  static const int _maxRecentResponses = 30;  // 반복 방지 강화 (5 -> 30)
  
  /// 간소화된 후처리 메인 메서드
  static String processResponse({
    required String rawResponse,
    required Persona persona,
    String? userNickname,
    String? userMessage,
    List<String>? recentMessages,
  }) {
    String processed = rawResponse;

    // 0단계: 매크로 응답 방지 (동일한 응답 반복 체크)
    if (_isMacroResponse(processed)) {
      debugPrint('⚠️ Macro response detected, requesting regeneration');
      // 매크로 감지 시 변형 시도
      processed = _variateResponse(processed, persona);
    }

    // 1단계: 기본적인 텍스트 정리
    processed = _cleanupText(processed);
    
    // 1-1단계: 음성 인식 오류 자동 교정
    processed = _correctCommonTypos(processed);
    
    // 1-2단계: 사투리 표준어 변환 (선택적)
    if (userMessage != null && _containsDialect(userMessage)) {
      processed = _adaptDialectResponse(processed, userMessage);
    }
    
    // 1-3단계: MZ세대 표현 적용
    processed = _applyMzGenExpression(processed, persona);

    // 2단계: 문장 완성도 검증 및 수정
    processed = _ensureCompleteSentence(processed);

    // 3단계: 이모티콘 최적화 (한국어 스타일)
    processed = _optimizeEmoticons(processed);

    // 4단계: 갑작스러운 주제 변경 감지 및 수정
    processed = _smoothTopicTransition(processed, userMessage, recentMessages);
    
    // 5단계: 이별 관련 부적절한 내용 필터링
    processed = _filterInappropriateBreakupContent(processed);
    
    // 6단계: 맥락 없는 응원 표현 필터링
    processed = _filterUncontextualEncouragement(processed);
    
    // 7단계: 최종 자연스러움 개선
    processed = _improveNaturalness(processed);

    // 최근 응답 기록 업데이트
    _updateRecentResponses(processed);

    // 길이 제한은 ChatOrchestrator에서 메시지 분리로 처리

    return processed;
  }
  
  /// 매크로 응답 감지 (동일한 응답 반복) - 강화됨
  static bool _isMacroResponse(String response) {
    if (_recentResponses.isEmpty) return false;
    
    // 정규화: 이모티콘, 공백 제거하여 비교
    String normalized = response
        .replaceAll(RegExp(r'[ㅋㅎㅠ~♥♡💕.!?]+'), '')
        .replaceAll(RegExp(r'\s+'), '')
        .toLowerCase();
    
    // 짧은 반복 패턴 감지 (3단어 이하 응답이 반복되면 즉시 매크로 판정)
    if (normalized.split(' ').length <= 3) {
      for (final recent in _recentResponses) {
        String recentNormalized = recent
            .replaceAll(RegExp(r'[ㅋㅎㅠ~♥♡💕.!?]+'), '')
            .replaceAll(RegExp(r'\s+'), '')
            .toLowerCase();
        if (normalized == recentNormalized) {
          debugPrint('🔴 Short macro detected: $response');
          return true;
        }
      }
    }
    
    int similarCount = 0;
    for (final recent in _recentResponses) {
      String recentNormalized = recent
          .replaceAll(RegExp(r'[ㅋㅎㅠ~♥♡💕.!?]+'), '')
          .replaceAll(RegExp(r'\s+'), '')
          .toLowerCase();
      
      // 유사도 계산 (60% 이상 유사하면 매크로로 판단 - 더 엄격하게)
      double similarity = _calculateSimilarity(normalized, recentNormalized);
      if (similarity > 0.6) {  // 0.7 -> 0.6으로 더 낮춤
        similarCount++;
      }
      
      // 완전 동일한 경우 즉시 매크로 판정
      if (normalized == recentNormalized) {
        debugPrint('🔴 Exact macro detected: $response');
        return true;
      }
    }
    
    // 최근 30개 중 2개 이상 유사하면 매크로로 판단 (더 엄격하게)
    return similarCount >= 2;
  }
  
  /// 문자열 유사도 계산 (Jaccard similarity)
  static double _calculateSimilarity(String s1, String s2) {
    if (s1.isEmpty || s2.isEmpty) return 0.0;
    if (s1 == s2) return 1.0;
    
    // 문자 단위로 분해
    Set<String> set1 = s1.split('').toSet();
    Set<String> set2 = s2.split('').toSet();
    
    // Jaccard similarity
    int intersection = set1.intersection(set2).length;
    int union = set1.union(set2).length;
    
    return union > 0 ? intersection / union : 0.0;
  }
  
  /// 매크로 응답 변형 - 다양성 강화
  static String _variateResponse(String response, Persona persona) {
    // 매크로 감지 시 OpenAI API에게 재생성 요청하도록 표시
    // 하드코딩된 변형 템플릿 사용하지 않음
    // 원본 응답을 반환하고 상위 레벨에서 재생성 처리
    return response;
  }
  
  /// 키워드 추출 헬퍼
  static List<String> _extractKeywords(String text) {
    final keywords = <String>[];
    final keywordPatterns = [
      '좋아', '싫어', '사랑', '미워', '힘들', '괜찮', '재밌', '심심',
      '고마', '미안', '배고', '졸려', '피곤', '신나', '우울', '외로'
    ];
    
    final lower = text.toLowerCase();
    for (final pattern in keywordPatterns) {
      if (lower.contains(pattern)) {
        keywords.add(pattern);
      }
    }
    
    return keywords;
  }
  
  /// 최근 응답 기록 업데이트
  static void _updateRecentResponses(String response) {
    _recentResponses.add(response);
    if (_recentResponses.length > _maxRecentResponses) {
      _recentResponses.removeAt(0);
    }
  }
  
  /// 최종 자연스러움 개선
  static String _improveNaturalness(String text) {
    String result = text;
    
    // 추가 자연스러운 표현 변환
    final naturalPatterns = {
      // AI 티 나는 표현 제거/변경
      '~하는군요': '~하네요',
      '~는군요': '~네요',
      '이해합니다': '알겠어요',
      '이해가 됩니다': '이해가 돼요',
      '이해해요': '알겠어요',
      '공감합니다': '나도 그럴 것 같아요',
      '공감이 됩니다': '공감돼요',
      '공감이 가요': '공감돼요',
      '~인 것 같습니다': '~인 것 같아요',
      '~는 것 같습니다': '~는 것 같아요',
      '그런 감정': '그런 마음',
      '그런 감정이': '그런 마음이',
      '그런 느낌': '그런 기분',
      '마음이 아프시겠어요': '아 속상하겠다',
      '마음이 아프겠어요': '속상하겠어요',
      '힘드시겠어요': '힘들겠어요',
      '어려우시겠어요': '어려울 것 같아요',
      
      // 딱딱한 확인 표현
      '그렇군요': '그렇구나',
      '알겠습니다': '알겠어요',
      '그렇습니다': '그래요',
      '맞습니다': '맞아요',
      
      // 부자연스러운 연결 표현
      '그러나': '근데',
      '그렇지만': '근데',
      '하지만': '근데',
      '그런데도': '그래도',
      
      // 격식체 → 친근한 표현
      '하십시오': '하세요',
      '되십니까': '되세요',
      '계십니까': '계세요',
      
      // 어색한 감정 표현
      '슬프네요': '슬퍼요',
      '기쁘네요': '기뻐요',
      '좋네요': '좋아요',
      '싫네요': '싫어요',
      
      // 어색한 추측 표현
      '그런 것 같네요': '그런 것 같아요',
      '그럴 것 같네요': '그럴 것 같아요',
      '그렇게 생각하네요': '그렇게 생각해요',
    };
    
    for (final entry in naturalPatterns.entries) {
      result = result.replaceAll(entry.key, entry.value);
    }
    
    // 연속된 문장 부호 정리
    result = result.replaceAll(RegExp(r'[.]{2,}'), '...');
    result = result.replaceAll(RegExp(r'[!]{2,}'), '!!');
    result = result.replaceAll(RegExp(r'[?]{2,}'), '??');
    
    return result;
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

    // 모든 문장을 개별적으로 처리하여 의문문에 물음표 추가
    text = _ensureProperPunctuation(text);

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
      '인가요': '인가요', // 그대로 유지

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
      
      // MZ세대 표현 추가
      '매우 좋아요': '진짜 좋아요',
      '정말 대단해요': '완전 대박이에요',
      '아주 멋져요': '개멋있어요',
      '매우 재미있어요': '진짜 재밌어요',
      '놀라워요': '대박이에요',
      '훌륭해요': '짱이에요',
    };

    // 구체적인 패턴 적용
    for (final entry in specificPatterns.entries) {
      result = result.replaceAll(entry.key, entry.value);
    }

    // 2. 정규표현식 패턴 처리 (replaceAllMapped 사용)
    // ~시나요? → ~세요?
    result = result.replaceAllMapped(
        RegExp(r'([가-힣]+)시나요(?=\?|$)'), (match) => '${match.group(1)}세요');

    // ~신가요? → ~세요?
    result = result.replaceAllMapped(
        RegExp(r'([가-힣]+)신가요(?=\?|$)'), (match) => '${match.group(1)}세요');

    // 있나요? → 있어요?
    result = result.replaceAllMapped(RegExp(r'있나요(?=\?|$)'), (match) => '있어요');

    // 없나요? → 없어요?
    result = result.replaceAllMapped(RegExp(r'없나요(?=\?|$)'), (match) => '없어요');

    return result;
  }

  /// 의문문인지 확인
  static bool _isQuestion(String text) {
    final questionWords = [
      '뭐',
      '어디',
      '언제',
      '누구',
      '왜',
      '어떻게',
      '얼마',
      '몇',
      '어느',
      '무슨',
      '무엇'
    ];
    final questionEndings = [
      '니',
      '나요',
      '까',
      '까요',
      '어요',
      '을까',
      '을까요',
      '는지',
      '은지',
      '나',
      '냐',
      '어',
      '야',
      '지',
      '죠',
      '는데',
      '은데',
      '던데',
      '는가',
      '은가',
      '가요',
      '나요',
      '래',
      '래요',
      '대',
      '대요',
      '던가',
      '던가요',
      '인가',
      '인가요'
    ];

    // 문장 정리 (마침표, 느낌표 제거)
    final cleanText = text.replaceAll(RegExp(r'[.!]+$'), '').trim();
    final lower = cleanText.toLowerCase();

    // 감탄문 패턴 먼저 체크 (의문문으로 오인되는 것 방지)
    final exclamationPatterns = [
      '완전 좋아해',
      '진짜 좋아해',
      '정말 좋아해',
      '너무 좋아해',
      '완전 싫어해',
      '진짜 싫어해',
      '정말 싫어해',
      '너무 싫어해',
      '완전 재밌어',
      '진짜 재밌어',
      '정말 재밌어',
      '너무 재밌어',
      '완전 멋있어',
      '진짜 멋있어',
      '정말 멋있어',
      '너무 멋있어',
      '완전 예뻐',
      '진짜 예뻐',
      '정말 예뻐',
      '너무 예뻐',
      '완전 귀여워',
      '진짜 귀여워',
      '정말 귀여워',
      '너무 귀여워',
      '대박',
      '짱이야',
      '최고야',
      '개좋아',
      '개멋있어',
      '개웃겨',
      '개귀여워'
    ];
    
    // 감탄문 패턴이면 의문문이 아님
    for (final pattern in exclamationPatterns) {
      if (lower.contains(pattern)) {
        return false;
      }
    }

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
    if (lower.contains('하는 거') ||
        lower.contains('하는 건') ||
        lower.contains('인 거') ||
        lower.contains('인 건')) {
      return true;
    }

    return false;
  }

  /// 이모티콘 최적화 (한국어 스타일)
  static String _optimizeEmoticons(String text) {
    // 과도한 이모티콘을 ㅋㅋ/ㅎㅎ로 변환
    final emojiMap = {
      RegExp(r'[😊😄😃😀🙂☺️]+'): 'ㅎㅎ',
      RegExp(r'[😂🤣]+'): 'ㅋㅋㅋ',
      RegExp(r'[😢😭😥😰]+'): 'ㅠㅠ',
      RegExp(r'[😍🥰😘]+'): '♥',
      RegExp(r'[😮😲😯😳]+'): '헐',
      RegExp(r'[😤😠😡🤬]+'): '화나',
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
      '요',
      '죠',
      '네요',
      '어요',
      '아요',
      '해요',
      '이에요',
      '예요',
      '습니다',
      '합니다',
      '입니다',
      '다',
      '어',
      '아',
      '지',
      '야',
      '까',
      '까요',
      '나',
      '나요',
      '니',
      '거든',
      '잖아',
      '는데',
      '!',
      '?',
      '.',
      '~',
      'ㅋ',
      'ㅎ',
      'ㅠ',
      '♡',
      '♥',
      '💕'
    ];

    // 불완전한 종결 패턴 (이것으로 끝나면 불완전함)
    final incompleteEndings = [
      '때가', '하는', '있는', '없는', '같은', '되는', '라는', '이라는',
      '때', '것', '듯', '중', '그', '이', '를', '을', '에서', '으로',
      '하고', '인데', '했는데', '있고', '없고', '같고', '되고', '라고',
      '지내고', '있었고', '했고', '이고', '그리고', '그런데',
      // 질문 중간에 끊기는 패턴 추가
      '무슨', '어떤', '어디', '언제', '누가', '왜', '어떻게',
      '하셨는데', '하시는데', '한다는데', '한다고 하는데',
      // 쉼표로 끝나는 경우
      ',', '，'
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
      } else if (lastWord.endsWith('하고') ||
          lastWord.endsWith('있고') ||
          lastWord.endsWith('없고') ||
          lastWord.endsWith('같고')) {
        // "~하고"로 끝나는 경우 (예: "그럼 요즘 어떻게 지내고")
        if (trimmed.contains('어떻게') ||
            trimmed.contains('뭐') ||
            trimmed.contains('무엇')) {
          return trimmed.substring(0, trimmed.length - 1) + ' 있어요?';
        } else {
          return trimmed + ' 있어요';
        }
      } else if (lastWord.endsWith('인데') ||
          lastWord.endsWith('그런데') ||
          lastWord.endsWith('했는데') ||
          lastWord.endsWith('하셨는데') ||
          lastWord.endsWith('하시는데') ||
          lastWord.endsWith('한다는데')) {
        // "~인데"로 끝나는 경우
        // "소나 개발하고 있다고 하셨는데, 무슨" 같은 패턴 처리
        if (trimmed.endsWith('무슨') ||
            trimmed.endsWith('어떤') ||
            trimmed.endsWith('어디') ||
            trimmed.endsWith('왜')) {
          return trimmed + ' 부분이 궁금해요?';
        } else {
          return trimmed + ' 어떠세요?';
        }
      } else if (lastWord == '무슨' ||
          lastWord == '어떤' ||
          lastWord == '어디' ||
          lastWord == '왜' ||
          lastWord == '어떻게' ||
          lastWord == '언제') {
        // 의문사로 끝나는 경우
        return trimmed + ' 것인지 궁금해요';
      } else if (lastWord == ',' || lastWord == '，') {
        // 쉼표로 끝나는 경우
        if (trimmed.contains('하셨는데') || trimmed.contains('하시는데')) {
          return trimmed.substring(0, trimmed.length - 1) + ' 궁금해요';
        } else {
          return trimmed.substring(0, trimmed.length - 1) + '요';
        }
      } else if (lastWord.endsWith('라고') || lastWord.endsWith('이고')) {
        // "~라고", "~이고"로 끝나는 경우
        return trimmed + ' 생각해요';
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

  /// 갑작스러운 주제 변경 감지 및 수정 - 강화됨
  static String _smoothTopicTransition(String text, [String? userMessage, List<String>? recentMessages]) {
    // 이전 대화 주제 추출
    Set<String> recentTopics = {};
    if (recentMessages != null && recentMessages.isNotEmpty) {
      for (final msg in recentMessages.take(5)) {
        final keywords = _extractKeywords(msg);
        recentTopics.addAll(keywords);
      }
    }
    
    // 현재 응답의 주제
    final currentTopics = _extractKeywords(text);
    
    // 주제 일관성 점수 계산
    double relevanceScore = 100;
    if (recentTopics.isNotEmpty && currentTopics.isNotEmpty) {
      final matchingTopics = currentTopics.where((topic) => 
        recentTopics.any((recentTopic) => 
          topic.toLowerCase() == recentTopic.toLowerCase())).toList();
      relevanceScore = (matchingTopics.length / currentTopics.length) * 100;
    }
    
    // 낮은 관련성 시 전환 표현 추가 (30점 미만)
    if (relevanceScore < 30 && recentMessages != null && recentMessages.length > 2) {
      // 자연스러운 전환 표현들
      final transitionPhrases = [
        '아 그러고보니',
        '아 맞다',
        '그 얘기 들으니까',
        '말 나온 김에',
        '아 참',
        '근데 있잖아',
      ];
      
      // 전환 표현이 없으면 추가
      bool hasTransition = false;
      for (final phrase in transitionPhrases) {
        if (text.contains(phrase)) {
          hasTransition = true;
          break;
        }
      }
      
      if (!hasTransition && !text.startsWith('아') && !text.startsWith('근데')) {
        final randomPhrase = transitionPhrases[DateTime.now().millisecond % transitionPhrases.length];
        text = '$randomPhrase, $text';
      }
    }
    
    // 주제 전환 표현이 없으면서 특정 패턴으로 시작하는 경우
    final abruptPatterns = [
      // 게임 관련 갑작스러운 시작
      RegExp(r'^(게임|롤|오버워치|배그|발로란트|피파)', caseSensitive: false),
      RegExp(r'^(딜러|탱커|힐러|서포터|정글)', caseSensitive: false),

      // 전문 주제 갑작스러운 시작
      RegExp(r'^(회사|업무|프로젝트|개발|코딩)', caseSensitive: false),

      // 일상 주제 갑작스러운 시작
      RegExp(r'^(음식|영화|드라마|웹툰|카페)', caseSensitive: false),
      
      // 감정 표현 갑작스러운 시작
      RegExp(r'^(좋아해|사랑해|싫어해|미워해)', caseSensitive: false),
      
      // 질문 갑작스러운 시작
      RegExp(r'^(너는|넌|있어\?|해봤어\?)', caseSensitive: false),
    ];

    // 자연스러운 전환 표현들 - 더 다양하게
    final transitionPhrases = [
      '아 그러고보니',
      '아 맞다',
      '갑자기 생각났는데',
      '그거 얘기하니까',
      '말 나온 김에',
      '그런 것처럼',
      '아 참',
      '근데 있잖아',
      '그건 그렇고',
      '다른 얘긴데',
      '아 그래서 말인데',
      '생각해보니',
      '문득 궁금한데',
      '그러고 보면'
    ];

    // 이미 전환 표현이 있는지 확인
    bool hasTransition = false;
    for (final phrase in transitionPhrases) {
      if (text.toLowerCase().contains(phrase)) {
        hasTransition = true;
        break;
      }
    }

    // 전환 표현이 없고 갑작스러운 패턴으로 시작하면 추가
    if (!hasTransition) {
      for (final pattern in abruptPatterns) {
        if (pattern.hasMatch(text)) {
          // 시간 기반으로 더 나은 분산
          final now = DateTime.now();
          final randomIndex = (now.millisecond + now.second) % transitionPhrases.length;
          final transition = transitionPhrases[randomIndex];

          // 게임 관련이면 더 구체적인 전환
          if (text.toLowerCase().contains('게임') ||
              text.toLowerCase().contains('딜러') ||
              text.toLowerCase().contains('롤') ||
              text.toLowerCase().contains('시메트라') ||
              text.toLowerCase().contains('오버워치')) {
            // 이미 게임 대화 중이면 전환 표현 불필요
            return text;
          }

          return '$transition $text';
        }
      }
    }

    // 공감 표현 개선 (딱딱한 표현 -> 자연스러운 표현)
    final empathyPatterns = {
      '그런 감정 이해해요': '아 진짜 그럴 것 같아요',
      '그런 감정이 이해돼요': '아 진짜 그럴 것 같아요',
      '마음이 아프시겠어요': '아 속상하겠다',
      '마음이 아프겠어요': '아 속상하겠다',
      '이해가 됩니다': '그럴 수 있어요',
      '이해가 돼요': '그럴 수 있어요',
      '공감이 됩니다': '나도 그럴 것 같아요',
      '공감이 돼요': '나도 그럴 것 같아요',
      '그런 마음 알아요': '나도 그런 적 있어요',
      '그런 기분 알아요': '나도 그런 적 있어요',
    };

    for (final entry in empathyPatterns.entries) {
      if (text.contains(entry.key)) {
        text = text.replaceAll(entry.key, entry.value);
      }
    }

    return text;
  }
  
  /// 이별 관련 부적절한 내용 필터링
  static String _filterInappropriateBreakupContent(String text) {
    // 이별 관련 부적절한 표현들
    final inappropriateBreakupPhrases = [
      '이제 그만 만나자',
      '우리 헤어지자',
      '이별하자',
      '관계를 끝내자',
      '더 이상 못 만나겠어',
      '마음이 식었어',
      '정이 떨어졌어',
      '사랑이 식었어',
      '이제 끝이야',
      '여기까지야'
    ];
    
    // 부적절한 이별 표현이 있는지 확인
    for (final phrase in inappropriateBreakupPhrases) {
      if (text.contains(phrase)) {
        debugPrint('⚠️ Inappropriate breakup phrase detected and filtered: $phrase');
        
        // 부적절한 이별 표현을 부드러운 표현으로 변경
        text = text.replaceAll(phrase, '우리 좀 더 얘기해보자');
      }
    }
    
    // 갑작스러운 이별 암시 표현들도 필터링
    if (text.contains('안녕') && text.contains('영원히')) {
      text = text.replaceAll('영원히', '나중에');
    }
    
    if (text.contains('마지막') && text.contains('인사')) {
      text = text.replaceAll('마지막 인사', '오늘 인사');
    }
    
    return text;
  }
  
  /// 문법적으로 어색한 응원 표현 수정
  static String _filterUncontextualEncouragement(String text) {
    // 문법적으로 어색한 패턴들만 수정
    final awkwardPatterns = [
      // "어떻게 지내 힘내" 같은 문법 오류 패턴
      RegExp(r'어떻게\s+지내\s+힘내'),
      RegExp(r'뭐\s*해\s+힘내'),
      RegExp(r'괜찮아\s+힘내'),
      // 두 개의 독립적인 문장이 붙어있는 경우
      RegExp(r'([가-힣]+[아야어])\s+(힘내|화이팅|파이팅)([!?]?)'),
    ];
    
    // 문법 오류 수정
    if (text.contains('어떻게 지내 힘내')) {
      // "어떻게 지내 힘내" -> "어떻게 지내? 힘내!"
      text = text.replaceAll('어떻게 지내 힘내', '어떻게 지내? 힘내!');
    }
    
    if (text.contains('뭐해 힘내')) {
      text = text.replaceAll('뭐해 힘내', '뭐해? 힘내!');
    }
    
    if (text.contains('괜찮아 힘내')) {
      text = text.replaceAll('괜찮아 힘내', '괜찮아? 힘내!');
    }
    
    // "너는 요즘 어떻게 지내 힘내?" 같은 패턴 수정
    text = text.replaceAll(RegExp(r'너는\s+요즘\s+어떻게\s+지내\s+힘내'), '너는 요즘 어떻게 지내?');
    
    // 야근 관련 대화에서는 자연스러운 위로 유지
    // "야근 힘들겠다. 힘내!" (O)
    // "야근수당 안 나와? 힘내!" (O)
    // 이런 자연스러운 표현은 그대로 유지
    
    return text;
  }
  
  /// 흔한 음성 인식 오류 자동 교정
  static String _correctCommonTypos(String text) {
    // 흔한 음성 인식 오류 패턴
    final corrections = {
      '어떼': '어때',
      '어떄': '어때',
      '안년': '안녕',
      '안녕하새요': '안녕하세요',
      '반가와요': '반가워요',
      '뭐해여': '뭐해요',
      '보고십어': '보고싶어',
      '사랑행': '사랑해',
      '고마와': '고마워',
      '미안행': '미안해',
      '괜찬': '괜찮',
      '조아': '좋아',
      '있써': '있어',
      '없써': '없어',
      '그랬써': '그랬어',
      '했써': '했어',
    };
    
    String corrected = text;
    corrections.forEach((error, correct) {
      corrected = corrected.replaceAll(error, correct);
    });
    
    return corrected;
  }
  
  /// 사투리가 포함되어 있는지 확인
  static bool _containsDialect(String text) {
    final dialectPatterns = [
      '머하노', '머하냐', '겁나', '억수로', '아이가',
      '머꼬', '머라카노', '기가', '와이라노', '거시기',
      '허벌나게', '징하게', '잉', '뭐시여', '그려'
    ];
    
    for (final pattern in dialectPatterns) {
      if (text.contains(pattern)) return true;
    }
    return false;
  }
  
  /// 사투리에 맞춰 응답 조정
  static String _adaptDialectResponse(String text, String userMessage) {
    // 사용자가 부산 사투리를 쓰면 친근한 반응
    if (userMessage.contains('머하노') || userMessage.contains('아이가')) {
      // 가끔 "부산 사람이야?" 같은 반응 추가 (20% 확률)
      if (text.hashCode % 5 == 0) {
        text += ' 부산 사람이야?ㅎㅎ';
      }
    }
    
    // 전라도 사투리
    if (userMessage.contains('겁나') || userMessage.contains('잉')) {
      if (text.hashCode % 5 == 0) {
        text += ' 전라도 출신이구나ㅋㅋ';
      }
    }
    
    return text;
  }
  
  /// MZ세대 표현 적용
  static String _applyMzGenExpression(String text, Persona persona) {
    // MZ세대 신조어 사전
    final mzSlang = {
      // 긍정적 표현
      '정말 좋다': '개좋다',
      '매우 귀엽다': '개귀엽다',
      '정말 멋있다': '개멋있다',
      '최고다': '킹이다',
      '대단하다': '쩐다',
      '잘했다': '잘했네',
      '진짜야': '레알',
      '놀랍다': '충격적이다',
      '부럽다': '개부럽다',
      
      // 감정 표현
      '화가 난다': '킹받는다',
      '짜증난다': '빡친다',
      '우울하다': '우울해미치겠다',
      '슬프다': '슬퍼서 눈물난다',
      
      // 일상 표현
      '열심히 살고 있다': '갓생 살고 있다',
      '친한 친구': '찐친',
      '인정한다': 'ㅇㅈ',
      '개이득': 'ㄱㅇㄷ',
      '진짜로': '레알',
      '완전히': '완전',
      '그렇지': 'ㄱㅈ',
      
      // 인터넷 슬랭
      'TMI': 'TMI',
      '존맛탱': '존맛탱',
      '꿀잼': '꿀잼',
      '노잼': '노잼',
      '실화냐': '실화냐',
      '레전드': '레전드',
      '찐이다': '찐이다',
    };
    
    // 20% 확률로 MZ 표현 적용 (너무 자주 사용하면 부자연스러움)
    if (DateTime.now().millisecond % 5 == 0) {
      // 외향적 성격은 더 적극적으로 신조어 사용
      if (persona.mbti.startsWith('E')) {
        for (final entry in mzSlang.entries) {
          if (text.contains(entry.key)) {
            text = text.replaceFirst(entry.key, entry.value);
            break; // 한 번에 하나씩만 변경
          }
        }
      }
    }
    
    // 시간대별 인사말 추가
    final hour = DateTime.now().hour;
    if (text.startsWith('안녕') || text.startsWith('반가')) {
      if (hour >= 6 && hour < 12) {
        // 아침 인사
        if (DateTime.now().millisecond % 3 == 0) {
          text = '굿모닝~! ' + text;
        }
      } else if (hour >= 22 || hour < 3) {
        // 늦은 밤
        if (DateTime.now().millisecond % 3 == 0) {
          text = text + ' 늦은 시간까지 안 자고 뭐해요?ㅎㅎ';
        }
      }
    }
    
    return text;
  }
  
  /// 모든 문장에 적절한 구두점 추가
  static String _ensureProperPunctuation(String text) {
    if (text.isEmpty) return text;
    
    // 문장을 분리 (구두점, 줄바꿈, 이모티콘 기준)
    final sentences = <String>[];
    final sentencePattern = RegExp(r'([^.!?\n]+(?:[.!?]+|[\n]|$))');
    final matches = sentencePattern.allMatches(text);
    
    if (matches.isEmpty) {
      // 패턴 매칭이 안 되면 전체 텍스트를 하나의 문장으로 처리
      sentences.add(text);
    } else {
      for (final match in matches) {
        final sentence = match.group(0)?.trim() ?? '';
        if (sentence.isNotEmpty) {
          sentences.add(sentence);
        }
      }
    }
    
    // 각 문장 처리
    final processedSentences = <String>[];
    for (var sentence in sentences) {
      if (sentence.isEmpty) continue;
      
      // 이미 구두점이 있으면 그대로 유지
      if (sentence.endsWith('.') || sentence.endsWith('!') || sentence.endsWith('?')) {
        processedSentences.add(sentence);
        continue;
      }
      
      // ㅋㅋ, ㅎㅎ, ㅠㅠ 등으로 끝나는 경우 처리
      final emotionMatch = RegExp(r'(.+?)([\s]*[ㅋㅎㅠ~]+)$').firstMatch(sentence);
      String mainPart = sentence;
      String emotionPart = '';
      
      if (emotionMatch != null) {
        mainPart = emotionMatch.group(1) ?? sentence;
        emotionPart = emotionMatch.group(2) ?? '';
      }
      
      // 의문문 체크
      if (_isQuestion(mainPart)) {
        // 의문문이면 물음표 추가
        processedSentences.add(mainPart.trim() + '?' + emotionPart);
      } 
      // 감탄사나 강한 감정 표현 체크
      else if (_isExclamation(mainPart)) {
        // 느낌표 추가
        processedSentences.add(mainPart.trim() + '!' + emotionPart);
      }
      // 일반 평서문
      else {
        // 마침표 추가 (캐주얼한 대화체에서는 마침표 생략 가능)
        if (emotionPart.isNotEmpty || mainPart.length < 10) {
          // 짧은 문장이나 이모티콘이 있으면 마침표 생략 가능
          processedSentences.add(sentence);
        } else {
          // 긴 문장은 마침표 추가
          processedSentences.add(mainPart.trim() + '.' + emotionPart);
        }
      }
    }
    
    // 문장들을 다시 합치기
    return processedSentences.join(' ');
  }
  
  /// 감탄문인지 확인
  static bool _isExclamation(String text) {
    final exclamationPatterns = [
      '와', '우와', '헐', '대박', '진짜', '완전',
      '미친', '개', '너무', '정말', '엄청',
      '아', '아이고', '어머', '맙소사', '세상에',
      '짱', '최고', '굿', '나이스', '멋져',
      '싫어', '좋아', '사랑해', '미워', '화나'
    ];
    
    final lower = text.toLowerCase().trim();
    
    // 감탄 패턴으로 시작하는 경우
    for (final pattern in exclamationPatterns) {
      if (lower.startsWith(pattern)) {
        return true;
      }
    }
    
    // 강한 감정 표현이 포함된 경우
    if (lower.contains('진짜') && (lower.contains('좋') || lower.contains('싫') || lower.contains('멋'))) {
      return true;
    }
    
    return false;
  }
}
