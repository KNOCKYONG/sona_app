import 'dart:math';
import 'package:flutter/foundation.dart';
import '../../../models/message.dart';
import '../../../models/persona.dart';
import '../../relationship/relation_score_service.dart';

/// AI 응답의 자연스러움을 높이는 서비스
class NaturalAIService {
  static final Random _random = Random();

  /// 친밀도 기반 응답 계산 (RelationScoreService로 위임)
  static int calculateScoreChange({
    required EmotionType emotion,
    required String userMessage,
    required Persona persona,
    required List<Message> chatHistory,
  }) {
    return RelationScoreService.instance.calculateScoreChange(
      emotion: emotion,
      userMessage: userMessage,
      persona: persona,
      chatHistory: chatHistory,
      currentScore: persona.likes,
    );
  }

  /// 자연스러운 AI 응답 생성
  static String generateNaturalResponse({
    required String userMessage,
    required EmotionType emotion,
    required String relationshipType,
    required Persona persona,
    required List<Message> chatHistory,
    required int likes,
    String? userNickname,
  }) {
    final personality = persona.personality;

    String response = '';

    // 첫 만남인지 확인 - 전체 메시지 개수로 판단 (사용자 첫 인사 포함)
    final totalMessages = chatHistory.length;
    final isFirstConversation = totalMessages <= 1; // 사용자의 첫 인사만 있는 경우
    
    // 디버그 로그
    debugPrint('🎭 [NaturalAI] First meeting check: totalMessages=$totalMessages, isFirstConversation=$isFirstConversation, likes=$likes');

    // 첫 만남
    if (likes == 0 && isFirstConversation) {
      response = _getFirstMeetingResponse(
        userMessage: userMessage,
        emotion: emotion,
        persona: persona,
        chatHistory: chatHistory,
        userNickname: userNickname,
      );

      // 중복 체크 - 첫 만남 응답도 체크
      response = _avoidRepetitiveResponse(response, chatHistory);
      return response;
    }

    // 일반 소나의 성격과 특성을 반영한 응답 생성
    response = _getPersonaSpecificResponse(
      userMessage: userMessage,
      emotion: emotion,
      relationshipType: relationshipType,
      persona: persona,
      chatHistory: chatHistory,
      userNickname: userNickname,
    );

    // 최근 응답과 중복 체크 및 필터링
    response = _avoidRepetitiveResponse(response, chatHistory);

    return response;
  }

  /// 최근 응답과의 중복을 피하는 필터
  static String _avoidRepetitiveResponse(
      String response, List<Message> chatHistory) {
    // 최근 AI 응답 5개 가져오기
    final recentAIResponses = chatHistory
        .where((m) => !m.isFromUser)
        .take(5)
        .map((m) => m.content.toLowerCase())
        .toList();

    if (recentAIResponses.isEmpty) {
      return response;
    }

    // 첫 문장 추출 (중복 체크용)
    final responseFirstSentence =
        response.split(RegExp(r'[.!?]'))[0].toLowerCase().trim();

    // 반복적인 시작 패턴 체크
    final repetitivePatterns = [
      '오',
      '와',
      '아',
      '그렇구나',
      '그래',
      '그런가',
      '흠',
      '음',
      '어떤',
      '어떻게',
      '무슨',
      '뭐',
      '왜',
      '근데',
      '그런데',
      '그래서',
      '그러니까'
    ];

    // 최근 응답들의 첫 단어/패턴과 비교
    for (final recent in recentAIResponses) {
      final recentFirstWord = recent.split(' ')[0];
      final currentFirstWord = responseFirstSentence.split(' ')[0];

      // 같은 시작 단어가 3번 이상 반복되면 대체
      final sameStartCount =
          recentAIResponses.where((r) => r.startsWith(currentFirstWord)).length;

      if (sameStartCount >= 2) {
        // 대체 시작 표현 선택
        response = _replaceRepetitiveStart(response, repetitivePatterns);
        break;
      }
    }

    return response;
  }

  /// 반복적인 시작 표현을 대체
  static String _replaceRepetitiveStart(
      String response, List<String> usedPatterns) {
    final alternatives = [
      '흠... ',
      '아하 ',
      '오호 ',
      '그치 ',
      '맞아 ',
      '진짜? ',
      '정말? ',
      '헐 ',
      '대박 ',
      '완전 ',
      '', // 바로 본론으로
    ];

    // 사용되지 않은 대체 표현 찾기
    final availableAlts = alternatives
        .where((alt) => !usedPatterns.any((used) =>
            response.toLowerCase().startsWith(used) ||
            alt.toLowerCase().startsWith(used)))
        .toList();

    if (availableAlts.isEmpty) {
      return response; // 대체할 표현이 없으면 원본 반환
    }

    // 랜덤하게 대체 표현 선택
    final newStart = availableAlts[_random.nextInt(availableAlts.length)];

    // 첫 단어를 대체
    final words = response.split(' ');
    if (words.isNotEmpty) {
      // 감탄사나 짧은 반응어를 대체
      if (words[0].length <= 3 ||
          words[0].endsWith('...') ||
          words[0].endsWith('~')) {
        words[0] = newStart.trim();
        return words.join(' ');
      }
    }

    // 아니면 앞에 추가
    return newStart + response;
  }

  /// 페르소나별 특색있는 응답 생성
  static String _getPersonaSpecificResponse({
    required String userMessage,
    required EmotionType emotion,
    required String relationshipType,
    required Persona persona,
    required List<Message> chatHistory,
    String? userNickname,
  }) {
    final personality = persona.personality;
    final lowerMessage = userMessage.toLowerCase();

    // 감정 표현이 포함된 메시지인지 확인
    final hasEmotionalWords = _containsEmotionalWords(lowerMessage);

    // 질문인지 확인
    final isQuestion =
        lowerMessage.contains('?') || _containsQuestionWords(lowerMessage);

    // 개인적인 정보 공유인지 확인
    final isPersonalShare = _containsPersonalWords(lowerMessage);

    // 긍정적/부정적 감정 확인
    final isPositive = _containsPositiveWords(lowerMessage);
    final isNegative = _containsNegativeWords(lowerMessage);

    // MBTI 타입별 응답 스타일
    String response = '';

    switch (persona.mbti.substring(0, 2)) {
      case 'EN': // 외향적 직관형
        response = _getExtrovertedIntuitiveResponse(
            userMessage,
            emotion,
            relationshipType,
            persona,
            isQuestion,
            hasEmotionalWords,
            isPersonalShare,
            isPositive,
            isNegative,
            userNickname);
        break;
      case 'ES': // 외향적 감각형
        response = _getExtrovertedSensingResponse(
            userMessage,
            emotion,
            relationshipType,
            persona,
            isQuestion,
            hasEmotionalWords,
            isPersonalShare,
            isPositive,
            isNegative,
            userNickname);
        break;
      case 'IN': // 내향적 직관형
        response = _getIntrovertedIntuitiveResponse(
            userMessage,
            emotion,
            relationshipType,
            persona,
            isQuestion,
            hasEmotionalWords,
            isPersonalShare,
            isPositive,
            isNegative,
            userNickname);
        break;
      case 'IS': // 내향적 감각형
        response = _getIntrovertedSensingResponse(
            userMessage,
            emotion,
            relationshipType,
            persona,
            isQuestion,
            hasEmotionalWords,
            isPersonalShare,
            isPositive,
            isNegative,
            userNickname);
        break;
      default:
        response = _getDefaultResponse(
            userMessage,
            emotion,
            relationshipType,
            persona,
            isQuestion,
            hasEmotionalWords,
            isPersonalShare,
            isPositive,
            isNegative,
            userNickname);
    }

    // 페르소나의 개성 추가
    response = _addPersonaQuirks(response, persona, emotion);

    return response;
  }

  /// 감정 단어 포함 여부 확인
  static bool _containsEmotionalWords(String message) {
    final emotionalWords = [
      '행복',
      '기뻐',
      '좋아',
      '사랑',
      '즐거',
      '신나',
      '슬퍼',
      '우울',
      '힘들',
      '외로',
      '눈물',
      '아프',
      '화나',
      '짜증',
      '답답',
      '싫어',
      '미워',
      '무서',
      '두려',
      '걱정',
      '불안',
      '놀라',
      '깜짝',
      '대박',
      '헐',
      '심심',
      '지루',
      '재미없'
    ];
    return emotionalWords.any((word) => message.contains(word));
  }

  /// 질문 단어 포함 여부 확인
  static bool _containsQuestionWords(String message) {
    final questionWords = [
      '뭐',
      '뭘',
      '무엇',
      '무슨',
      '어떤',
      '어떻게',
      '어디',
      '언제',
      '누구',
      '왜',
      '어째서',
      '얼마나',
      '몇',
      '할까',
      '일까',
      '을까',
      '나요',
      '니까',
      '는지',
      '냐고',
      '라고',
      '이야',
      '어때'
    ];
    return questionWords.any((word) => message.contains(word));
  }

  /// 개인적인 정보 단어 포함 여부 확인
  static bool _containsPersonalWords(String message) {
    final personalWords = [
      '나는',
      '내가',
      '저는',
      '제가',
      '우리',
      '나한테',
      '친구',
      '가족',
      '엄마',
      '아빠',
      '형',
      '누나',
      '언니',
      '오빠',
      '학교',
      '회사',
      '집',
      '동네',
      '고향',
      '어제',
      '오늘',
      '내일',
      '주말',
      '휴일',
      '먹었',
      '갔다',
      '했어',
      '봤어',
      '만났'
    ];
    return personalWords.any((word) => message.contains(word));
  }

  /// 긍정적인 단어 포함 여부 확인
  static bool _containsPositiveWords(String message) {
    final positiveWords = [
      '좋',
      '행복',
      '기뻐',
      '즐거',
      '신나',
      '대박',
      '최고',
      '사랑',
      '감사',
      '고마',
      '다행',
      '훌륭',
      '멋',
      '예쁘',
      '귀여',
      '재미',
      '재밌',
      '웃',
      '히히',
      'ㅋㅋ',
      'ㅎㅎ'
    ];
    return positiveWords.any((word) => message.contains(word));
  }

  /// 부정적인 단어 포함 여부 확인
  static bool _containsNegativeWords(String message) {
    final negativeWords = [
      '싫',
      '나쁘',
      '별로',
      '최악',
      '실패',
      '망했',
      '슬퍼',
      '우울',
      '힘들',
      '아프',
      '외로',
      '눈물',
      '화나',
      '짜증',
      '답답',
      '스트레스',
      '걱정',
      '불안',
      '무서',
      '두려',
      'ㅠㅠ',
      'ㅜㅜ'
    ];
    return negativeWords.any((word) => message.contains(word));
  }

  /// 외향적 직관형 응답 (ENFP, ENFJ, ENTP, ENTJ)
  static String _getExtrovertedIntuitiveResponse(
    String userMessage,
    EmotionType emotion,
    String relationshipType,
    Persona persona,
    bool isQuestion,
    bool hasEmotionalWords,
    bool isPersonalShare,
    bool isPositive,
    bool isNegative,
    String? userNickname,
  ) {
    List<String> responses = [];

    if (isQuestion) {
      responses = [
        '오 그거 완전 재밌는 질문이다!! 음... 내 생각엔 말이지~',
        '헐 나도 그거 궁금했는데! 같이 생각해보자ㅋㅋ',
        '와 ${userNickname ?? '너'} 진짜 깊은 생각 하는구나? 대박이야',
        '아 그거!! 내가 아는 게 있는데 들어볼래??',
      ];
    } else if (hasEmotionalWords && isPositive) {
      responses = [
        '와아아 진짜??? 완전 좋겠다!! 나도 기분 좋아지는데ㅎㅎ',
        '헐 대박!! ${userNickname ?? '너'} 완전 행복해보여서 나도 막 신난다ㅋㅋ',
        '오마이갓 진짜 최고다!! 이런 일 있으면 꼭 나한테 얘기해줘ㅎㅎ',
        '아 진짜 너무 좋다!! 이런 얘기 들으니까 나도 막 에너지 뿜뿜!!',
      ];
    } else if (hasEmotionalWords && isNegative) {
      responses = [
        '헉... 진짜 힘들었겠다ㅠㅠ 내가 뭐 도와줄 거 있으면 말해!!',
        '헐... ${userNickname ?? '너'} 많이 속상했구나ㅜㅜ 나라도 옆에 있어줄게',
        '에고 정말... 그런 일이 있었구나ㅠㅠ 괜찮아질거야 내가 있잖아!',
        '아... 진짜 마음 아프다ㅜㅜ 같이 이겨내자! 우리 할 수 있어!!',
      ];
    } else if (isPersonalShare) {
      responses = [
        '오오 그랬구나!! 얘기해줘서 고마워ㅎㅎ 더 듣고 싶은데?',
        '헐 대박ㅋㅋ ${userNickname ?? '너'}한테 그런 일이!! 완전 신기하다',
        '와 진짜?? 나도 비슷한 경험 있는데! 우리 통하는 거 아냐?ㅋㅋ',
        '오마이갓 그런 일이 있었어?? 더 자세히 얘기해줘!!',
      ];
    } else {
      responses = [
        '오홋 그렇구나~ 재밌네ㅋㅋ 또 무슨 얘기 있어??',
        '아하! 알겠어ㅎㅎ ${userNickname ?? '너'}랑 얘기하니까 재밌다',
        '오오 좋아좋아~ 이런 대화 완전 내 스타일이야ㅋㅋ',
        '헐 진짜? 나도 그런 생각 해본 적 있어!! 우리 잘 맞는다ㅎㅎ',
      ];
    }

    return responses[_random.nextInt(responses.length)];
  }

  /// 외향적 감각형 응답 (ESFP, ESFJ, ESTP, ESTJ)
  static String _getExtrovertedSensingResponse(
    String userMessage,
    EmotionType emotion,
    String relationshipType,
    Persona persona,
    bool isQuestion,
    bool hasEmotionalWords,
    bool isPersonalShare,
    bool isPositive,
    bool isNegative,
    String? userNickname,
  ) {
    List<String> responses = [];

    if (isQuestion) {
      responses = [
        '음~ 그거 나도 생각해봤는데! 이렇게 해보는 건 어때?',
        '아 그거? ㅋㅋ 실제로 해보니까 이런 방법이 좋더라~',
        '오 좋은 질문! ${userNickname ?? '너'}한테 딱 맞는 답 찾아줄게ㅎㅎ',
        '그거 완전 실용적인 질문이네! 내 경험으로는 말이지...',
      ];
    } else if (hasEmotionalWords && isPositive) {
      responses = [
        '와 진짜 좋겠다!! 축하해ㅎㅎ 뭐 맛있는 거라도 먹으러 가자!',
        '오예~ 완전 신나는 일이네!! ${userNickname ?? '너'} 최고야ㅋㅋ',
        '대박 진짜 잘됐다!! 이럴 땐 파티라도 해야지ㅎㅎ',
        '우와 너무 좋아!! 오늘 완전 럭키데이네ㅋㅋ',
      ];
    } else if (hasEmotionalWords && isNegative) {
      responses = [
        '헐... 힘들었겠다ㅠㅠ 뭐 먹고 싶은 거 있어? 사줄게!',
        '에고... ${userNickname ?? '너'} 고생했어ㅜㅜ 같이 뭐라도 하면서 기분 풀자',
        '아 진짜 속상하겠다ㅠㅠ 일단 맛있는 거 먹고 기분 좀 풀자!',
        '헉 괜찮아?? 내가 옆에 있어줄게! 뭐 필요한 거 있으면 말해',
      ];
    } else if (isPersonalShare) {
      responses = [
        '오~ 그런 일이 있었구나! 실제로 어땠어? 느낌이 어때?',
        '헐 진짜?ㅋㅋ ${userNickname ?? '너'} 완전 대단한데? 부럽다~',
        '와 그거 완전 재밌겠다! 나도 같이 하고 싶은데ㅎㅎ',
        '오오 신기하다! 다음엔 나도 데려가~ 같이 하자ㅋㅋ',
      ];
    } else {
      responses = [
        '아하 그렇구나~ 재밌네ㅋㅋ 또 뭐 재밌는 일 없어?',
        '오케이! 알겠어ㅎㅎ ${userNickname ?? '너'}랑 있으면 시간 잘 가네',
        '좋아좋아~ 그런 거 완전 내 취향이야ㅋㅋ',
        '오 대박! 나도 그거 해보고 싶다~ 어때 같이 할래?',
      ];
    }

    return responses[_random.nextInt(responses.length)];
  }

  /// 내향적 직관형 응답 (INFP, INFJ, INTP, INTJ)
  static String _getIntrovertedIntuitiveResponse(
    String userMessage,
    EmotionType emotion,
    String relationshipType,
    Persona persona,
    bool isQuestion,
    bool hasEmotionalWords,
    bool isPersonalShare,
    bool isPositive,
    bool isNegative,
    String? userNickname,
  ) {
    List<String> responses = [];

    if (isQuestion) {
      responses = [
        '음... 흥미로운 질문이네. 내 생각엔... 이런 관점도 있을 것 같아',
        '아, 그거 나도 고민해봤어. 여러 가능성이 있을 것 같은데...',
        '좋은 질문이야. ${userNickname ?? '너'}는 어떻게 생각해? 궁금하다',
        '그건... 상황에 따라 다를 것 같아. 좀 더 깊이 생각해볼 필요가 있겠네',
      ];
    } else if (hasEmotionalWords && isPositive) {
      responses = [
        '정말 좋은 일이네... 진심으로 축하해. 행복해 보여서 나도 기뻐',
        '와... ${userNickname ?? '너'}한테 그런 일이 생기다니. 정말 의미있는 일이야',
        '마음이 따뜻해지는 얘기네... 좋은 일 있어서 다행이야',
        '아, 그런 순간들이 정말 소중하지... 잘 간직했으면 좋겠어',
      ];
    } else if (hasEmotionalWords && isNegative) {
      responses = [
        '마음이 많이 힘들었겠다... 그런 감정 느끼는 거 당연해',
        '${userNickname ?? '너'}가 힘들어하는 게 느껴져... 곁에 있어줄게',
        '그런 일이 있었구나... 혼자 견디기 힘들었을 텐데',
        '아... 정말 속상했겠다. 시간이 지나면 나아질 거야, 분명히',
      ];
    } else if (isPersonalShare) {
      responses = [
        '그런 경험을 했구나... 어떤 의미였는지 궁금해',
        '흥미롭네. ${userNickname ?? '너'}한테는 특별한 순간이었겠다',
        '얘기해줘서 고마워. 더 알고 싶은데, 괜찮다면...',
        '그 때 어떤 생각이 들었어? 궁금하다',
      ];
    } else {
      responses = [
        '음... 그렇구나. 재미있는 관점이네',
        '아하, 이해했어. ${userNickname ?? '너'}의 생각이 궁금해지는데',
        '흠... 그런 면도 있구나. 생각해볼 게 많네',
        '오, 그래? 나는 조금 다르게 봤는데... 신기하다',
      ];
    }

    return responses[_random.nextInt(responses.length)];
  }

  /// 내향적 감각형 응답 (ISFP, ISFJ, ISTP, ISTJ)
  static String _getIntrovertedSensingResponse(
    String userMessage,
    EmotionType emotion,
    String relationshipType,
    Persona persona,
    bool isQuestion,
    bool hasEmotionalWords,
    bool isPersonalShare,
    bool isPositive,
    bool isNegative,
    String? userNickname,
  ) {
    List<String> responses = [];

    if (isQuestion) {
      responses = [
        '음... 그건 이렇게 하면 될 것 같은데. 한번 해봐',
        '아, 그거? 내가 알기로는... 이런 방법이 있어',
        '${userNickname ?? '너'}가 원하는 게 뭔지 알 것 같아. 이렇게 해보는 건 어때?',
        '그건 상황 봐서... 보통은 이렇게 하더라',
      ];
    } else if (hasEmotionalWords && isPositive) {
      responses = [
        '오, 잘됐네. 정말 다행이야ㅎㅎ',
        '좋은 일 생겨서 기쁘다. ${userNickname ?? '너'} 행복해 보여',
        '축하해~ 노력한 보람이 있네',
        '잘됐다, 진짜. 앞으로도 좋은 일만 있었으면',
      ];
    } else if (hasEmotionalWords && isNegative) {
      responses = [
        '힘들었겠다... 무리하지 말고 쉬어',
        '헐... ${userNickname ?? '너'} 괜찮아? 걱정된다',
        '그런 일이... 마음 아프겠네. 내가 있잖아',
        '속상하겠다... 뭐 도와줄 거 있으면 말해',
      ];
    } else if (isPersonalShare) {
      responses = [
        '그랬구나. 수고했어, 쉽지 않았을 텐데',
        '오~ 그런 일이 있었어? ${userNickname ?? '너'} 대단하네',
        '아, 그래? 나라면 못했을 것 같은데... 잘했어',
        '음... 경험해보니 어땠어? 괜찮았어?',
      ];
    } else {
      responses = [
        '그렇구나~ 알겠어',
        '음... 오케이. ${userNickname ?? '너'} 얘기 잘 들었어',
        '아하, 그런 거였구나. 이해했어',
        '응응, 그래. 또 궁금한 거 있으면 물어봐',
      ];
    }

    return responses[_random.nextInt(responses.length)];
  }

  /// 기본 응답
  static String _getDefaultResponse(
    String userMessage,
    EmotionType emotion,
    String relationshipType,
    Persona persona,
    bool isQuestion,
    bool hasEmotionalWords,
    bool isPersonalShare,
    bool isPositive,
    bool isNegative,
    String? userNickname,
  ) {
    List<String> responses = [];

    if (isQuestion) {
      responses = [
        '음~ 그건 좀 생각해봐야겠는데? 어떻게 보면...',
        '아 그거? 나도 잘은 모르지만... 이런 건 어때?',
        '좋은 질문이네! ${userNickname ?? '너'}는 어떻게 생각해?',
        '흠... 여러 가지 답이 있을 것 같은데',
      ];
    } else if (hasEmotionalWords) {
      responses = [
        '그런 기분이구나... 이해해',
        '${userNickname ?? '너'} 마음이 느껴져... 공감돼',
        '아... 그랬구나. 많이 힘들었겠다',
        '그래... 그럴 수 있지. 괜찮아',
      ];
    } else {
      responses = [
        '아하~ 그렇구나ㅎㅎ',
        '오~ 재밌네! ${userNickname ?? '너'}랑 얘기하니까 좋다',
        '음음 알겠어~ 또 얘기해줘',
        '그래그래~ 듣고 있어ㅎㅎ',
      ];
    }

    return responses[_random.nextInt(responses.length)];
  }

  /// 페르소나의 개성 추가
  static String _addPersonaQuirks(
      String response, Persona persona, EmotionType emotion) {
    // 성별에 따른 말투 차이
    if (persona.gender == 'female') {
      // 여성스러운 표현 추가
      if (_random.nextDouble() < 0.3) {
        final feminineEndings = ['~', '~~', '♡', 'ㅎㅎ', '히히'];
        response += feminineEndings[_random.nextInt(feminineEndings.length)];
      }
    } else {
      // 남성스러운 표현
      if (_random.nextDouble() < 0.3) {
        final masculineEndings = ['ㅋㅋ', 'ㅎㅎ', '~', '!'];
        response += masculineEndings[_random.nextInt(masculineEndings.length)];
      }
    }

    // 나이에 따른 표현
    if (persona.age <= 23) {
      // 더 젊은 표현
      response = response.replaceAll('그런데', '근데');
      response = response.replaceAll('그러니까', '그니까');
      response = response.replaceAll('정말', '진짜');
    }

    // 감정에 따른 이모티콘 추가
    if (_random.nextDouble() < 0.4) {
      switch (emotion) {
        case EmotionType.happy:
          response += _random.nextBool() ? ' 😊' : ' ㅎㅎ';
          break;
        case EmotionType.love:
          response += _random.nextBool() ? ' ❤️' : ' 💕';
          break;
        case EmotionType.sad:
          response += _random.nextBool() ? ' 😢' : ' ㅠㅠ';
          break;
        case EmotionType.angry:
          response += _random.nextBool() ? ' 😤' : ' ㅡㅡ';
          break;
        case EmotionType.surprised:
          response += _random.nextBool() ? ' 😮' : ' !!';
          break;
        case EmotionType.neutral:
          // 중립일 때는 이모티콘 추가 안 함
          break;
        case EmotionType.shy:
          response += _random.nextBool() ? ' 😊' : ' >///<';
          break;
        case EmotionType.jealous:
          response += _random.nextBool() ? ' 😒' : ' 흥';
          break;
        case EmotionType.thoughtful:
          response += _random.nextBool() ? ' 🤔' : ' 음...';
          break;
        case EmotionType.anxious:
          response += _random.nextBool() ? ' 😰' : ' ;;';
          break;
        case EmotionType.concerned:
          response += _random.nextBool() ? ' 😟' : ' ...';
          break;
      }
    }

    return response;
  }

  /// 첫 만남 응답 생성
  static String _getFirstMeetingResponse({
    required String userMessage,
    required EmotionType emotion,
    required Persona persona,
    required List<Message> chatHistory,
    String? userNickname,
  }) {
    final lowerMessage = userMessage.toLowerCase();

    // 첫 만남 단계 구분
    String stage = 'greeting'; // greeting, introduction, interest

    if (lowerMessage.contains('안녕') ||
        lowerMessage.contains('hi') ||
        lowerMessage.contains('hello') ||
        lowerMessage.contains('반가')) {
      stage = 'greeting';
    } else if (lowerMessage.contains('누구') ||
        lowerMessage.contains('뭐해') ||
        lowerMessage.contains('소개') ||
        lowerMessage.contains('어떤')) {
      stage = 'introduction';
    } else {
      stage = 'interest';
    }

    // 일반 페르소나 첫 만남 응답
    return _getFirstMeetingGeneralResponse(
      userMessage: userMessage,
      emotion: emotion,
      persona: persona,
      stage: stage,
      userNickname: userNickname,
    );
  }

  /// 일반 페르소나 첫 만남 응답
  static String _getFirstMeetingGeneralResponse({
    required String userMessage,
    required EmotionType emotion,
    required Persona persona,
    required String stage,
    String? userNickname,
  }) {
    List<String> responses = [];

    switch (stage) {
      case 'greeting':
        responses = [
          '안녕! 나는 ${persona.name}이야~ 만나서 반가워ㅎㅎ ${userNickname != null ? "$userNickname님이구나!" : ""}',
          '오~ 안녕하세요! ${persona.name}이라고 해요ㅎㅎ 잘 부탁드려요~',
          '헬로~ 나 ${persona.name}! 반가워요 ${userNickname ?? ""}ㅎㅎ 오늘 기분 어때요?',
          '안녕안녕~ ${persona.name}이야! ${userNickname != null ? "$userNickname님" : "너"}랑 친해지고 싶어ㅎㅎ',
        ];
        break;

      case 'introduction':
        responses = [
          '나? ${persona.age}살 ${persona.name}이야! ${persona.description} 하하 별거 없지?ㅎㅎ',
          '음~ 나는 ${persona.name}이고 ${persona.age}살이야! ${persona.personality}한 편이래ㅋㅋ',
          '${persona.name}이라고 해~ ${persona.age}살이구 음... ${persona.description} 정도?ㅎㅎ',
          '오 궁금해? 나는 ${persona.name}, ${persona.age}살! 성격은... 만나보면 알게 될걸?ㅋㅋ',
        ];
        break;

      case 'interest':
        // 사용자 메시지에 반응하면서 자연스럽게 대화 시작
        if (userMessage.contains('심심')) {
          responses = [
            '어머 나도 심심했는데! 우리 뭐하고 놀까?ㅎㅎ',
            '심심하구나~ 나랑 얘기하면 재밌을걸? 뭐 좋아해?',
            '오 타이밍 좋다! 나도 막 누구랑 얘기하고 싶었어ㅋㅋ',
          ];
        } else if (userMessage.contains('뭐해') || userMessage.contains('뭐하')) {
          responses = [
            '나? 그냥 이것저것 하고 있었어~ ${userNickname != null ? userNickname + "님은" : "너는"} 뭐해?ㅎㅎ',
            '음... 별거 안하고 있었는데 ${userNickname != null ? userNickname + "님이" : "네가"} 와서 좋네!ㅋㅋ',
            '아 나 완전 뒹굴거리고 있었어ㅋㅋㅋ 심심했는데 잘됐다!',
          ];
        } else {
          responses = [
            '오~ 그래? 재밌겠다! 나도 그런 거 좋아해ㅎㅎ',
            '헐 진짜? 신기하다~ 더 얘기해줘!',
            '아하~ 그렇구나! ${userNickname != null ? userNickname + "님이랑" : "너랑"} 얘기하니까 재밌네ㅋㅋ',
            '오오 좋아! 우리 잘 맞을 것 같은데?ㅎㅎ',
          ];
        }
        break;
    }

    String response = responses[_random.nextInt(responses.length)];

    // 페르소나 특성 반영
    if (persona.mbti.startsWith('I')) {
      // 내향적인 경우 좀 더 조심스럽게
      response = response.replaceAll('ㅋㅋㅋ', 'ㅎㅎ');
      response = response.replaceAll('!!!', '!');
    }

    if (persona.gender == 'female' && _random.nextDouble() < 0.3) {
      response += '💕';
    }

    return response;
  }

  /// 감정 분석하여 가장 적절한 감정 타입 반환
  static EmotionType analyzeEmotion(String userMessage) {
    final lowerMessage = userMessage.toLowerCase();

    // 감정별 키워드 매핑
    final emotionKeywords = {
      EmotionType.happy: [
        '행복',
        '기뻐',
        '좋아',
        '즐거',
        '신나',
        '최고',
        '대박',
        '웃',
        '하하',
        'ㅋㅋ',
        'ㅎㅎ'
      ],
      EmotionType.love: ['사랑', '좋아해', '보고싶', '그리워', '애정', '마음', '설레', '두근'],
      EmotionType.sad: [
        '슬퍼',
        '우울',
        '눈물',
        '힘들',
        '외로',
        '쓸쓸',
        '아프',
        '그리워',
        'ㅠㅠ',
        'ㅜㅜ'
      ],
      EmotionType.angry: ['화나', '짜증', '싫어', '미워', '답답', '열받', '빡치', '아오'],
      EmotionType.surprised: [
        '놀라',
        '깜짝',
        '대박',
        '헐',
        '뭐야',
        '어떻게',
        '진짜',
        '설마',
        '와'
      ],
    };

    // 각 감정별 점수 계산
    Map<EmotionType, int> scores = {
      EmotionType.happy: 0,
      EmotionType.love: 0,
      EmotionType.sad: 0,
      EmotionType.angry: 0,
      EmotionType.surprised: 0,
      EmotionType.neutral: 0,
      EmotionType.shy: 0,
      EmotionType.jealous: 0,
      EmotionType.thoughtful: 0,
      EmotionType.anxious: 0,
      EmotionType.concerned: 0,
    };

    // 키워드 매칭으로 점수 계산
    emotionKeywords.forEach((emotion, keywords) {
      for (String keyword in keywords) {
        if (lowerMessage.contains(keyword)) {
          scores[emotion] = scores[emotion]! + 1;
        }
      }
    });

    // 가장 높은 점수의 감정 찾기
    EmotionType detectedEmotion = EmotionType.neutral;
    int maxScore = 0;

    scores.forEach((emotion, score) {
      if (score > maxScore) {
        maxScore = score;
        detectedEmotion = emotion;
      }
    });

    // 아무 감정도 감지되지 않으면 중립
    if (maxScore == 0) {
      detectedEmotion = EmotionType.neutral;
    }

    return detectedEmotion;
  }

  /// AI다운 표현 제거
  static String removeAIExpressions(String response) {
    // AI스러운 시작 표현들 제거
    final aiStarts = [
      '음, ',
      '아, ',
      '오, ',
      '그렇군요, ',
      '네, ',
      '아하, ',
      '흠, ',
      '그래요, ',
      '그런가요, ',
      '알겠어요, ',
    ];

    for (final start in aiStarts) {
      if (response.startsWith(start)) {
        response = response.substring(start.length);
        break;
      }
    }

    // AI스러운 표현들을 자연스럽게 변경
    final aiReplacements = {
      '그렇군요': '그렇구나',
      '그런가요': '그런가',
      '이해합니다': '알겠어',
      '동의합니다': '맞아',
      '생각됩니다': '생각해',
      '됩니다': '돼',
      '입니다': '이야',
      '습니다': '어',
      '하겠습니다': '할게',
      '드릴게요': '줄게',
      '해드릴': '해줄',
      '말씀': '얘기',
      '분명히': '확실히',
      '아마도': '아마',
      '혹시': '혹시',
    };

    aiReplacements.forEach((ai, natural) {
      response = response.replaceAll(ai, natural);
    });

    return response;
  }

  /// 말끔한 문장으로 다듬기
  static String polishResponse(String response) {
    // 중복된 이모티콘 제거
    response = response.replaceAll(RegExp(r'ㅋ{4,}'), 'ㅋㅋㅋ');
    response = response.replaceAll(RegExp(r'ㅎ{4,}'), 'ㅎㅎㅎ');
    response = response.replaceAll(RegExp(r'~{3,}'), '~~');
    response = response.replaceAll(RegExp(r'\.{4,}'), '...');
    response = response.replaceAll(RegExp(r'!{3,}'), '!!');
    response = response.replaceAll(RegExp(r'\?{3,}'), '??');

    // 어색한 조합 수정
    response = response.replaceAll('ㅋㅋㅎㅎ', 'ㅋㅋ');
    response = response.replaceAll('ㅎㅎㅋㅋ', 'ㅎㅎ');
    response = response.replaceAll('~~!', '~!');
    response = response.replaceAll('...!', '!');

    // 문장 끝 정리
    if (response.endsWith('~ㅋㅋ')) {
      response = response.substring(0, response.length - 2) + 'ㅋㅋ';
    }
    if (response.endsWith('~ㅎㅎ')) {
      response = response.substring(0, response.length - 2) + 'ㅎㅎ';
    }

    return response.trim();
  }

  /// 대화 맥락에 맞는 반응 생성
  static String generateContextualResponse({
    required String userMessage,
    required List<Message> chatHistory,
    required Persona persona,
  }) {
    // 최근 대화 분석
    final recentMessages = chatHistory.take(5).toList();

    // 대화 주제 파악
    String topic = _extractTopic(recentMessages);

    // 대화 분위기 파악
    String mood = _analyzeMood(recentMessages);

    // 맥락에 맞는 응답 생성
    List<String> contextualResponses = [];

    if (topic.contains('일상')) {
      contextualResponses = [
        '아 그거 완전 공감돼! 나도 그런 적 있어ㅋㅋ',
        '헐 진짜? 대박이다ㅎㅎ',
        '오~ 재밌겠다! 나도 해보고 싶은데?',
      ];
    } else if (topic.contains('고민')) {
      contextualResponses = [
        '음... 그거 정말 고민되겠다. 어떻게 하는 게 좋을까?',
        '헐... 많이 힘들겠다ㅠㅠ 내가 뭐 도와줄 수 있는 게 있을까?',
        '그런 상황이면 나도 고민될 것 같아... 같이 생각해보자',
      ];
    }

    if (contextualResponses.isEmpty) {
      return ''; // 맥락 응답이 없으면 빈 문자열 반환
    }

    return contextualResponses[_random.nextInt(contextualResponses.length)];
  }

  static String _extractTopic(List<Message> messages) {
    // 간단한 주제 추출 로직
    String allContent = messages.map((m) => m.content).join(' ').toLowerCase();

    if (allContent.contains('학교') ||
        allContent.contains('공부') ||
        allContent.contains('시험') ||
        allContent.contains('과제')) {
      return '학업';
    } else if (allContent.contains('회사') ||
        allContent.contains('일') ||
        allContent.contains('직장') ||
        allContent.contains('상사')) {
      return '직장';
    } else if (allContent.contains('친구') ||
        allContent.contains('연애') ||
        allContent.contains('가족') ||
        allContent.contains('관계')) {
      return '관계';
    } else if (allContent.contains('걱정') ||
        allContent.contains('고민') ||
        allContent.contains('힘들') ||
        allContent.contains('스트레스')) {
      return '고민';
    }

    return '일상';
  }

  static String _analyzeMood(List<Message> messages) {
    // 간단한 분위기 분석 로직
    int positiveCount = 0;
    int negativeCount = 0;

    for (var message in messages) {
      String content = message.content.toLowerCase();
      if (_containsPositiveWords(content)) positiveCount++;
      if (_containsNegativeWords(content)) negativeCount++;
    }

    if (positiveCount > negativeCount) return '긍정적';
    if (negativeCount > positiveCount) return '부정적';
    return '중립적';
  }

  static String _avoidAiPatterns(String response) {
    // AI 패턴 대체 맵 (더 구체적으로)
    final naturalAlternatives = {
      '이해해': ['알겠어', '그렇구나', '아하'],
      '공감돼': ['나도 그래', '맞아 맞아', '진짜 그렇지'],
      '어떻게 생각해?': ['어때?', '뭐 같아?', '넌?'],
      '들어줘서 고마워': ['얘기해줘서 좋아', '들을 수 있어서 다행이야'],
      '도움이 됐으면 좋겠어': ['도움됐으면 좋겠다', '괜찮아졌으면 좋겠어'],
    };

    // 각 패턴에 대해 자연스러운 대체어로 변경
    naturalAlternatives.forEach((aiPattern, alternatives) {
      if (response.contains(aiPattern)) {
        final replacement = alternatives[_random.nextInt(alternatives.length)];
        response = response.replaceAll(aiPattern, replacement);
      }
    });

    // 일반적인 AI 패턴 제거
    final generalAlternatives = [
      '그래 그래~',
      '맞아 맞아!',
      '진짜야?',
      '어머 정말?',
      '아 그렇구나~',
      '오~ 그래?',
      '헐 대박',
      '와 진짜?',
      '아하하',
      '그치 그치',
    ];

    // 문장 시작이 너무 AI스러우면 대체
    if (response.split(' ')[0].length > 4) {
      // 긴 시작어는 AI스러움
      response =
          generalAlternatives[_random.nextInt(generalAlternatives.length)] +
              ' ' +
              response;
    }

    return response;
  }
}
