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
    // 반복 방지는 프롬프트에서 처리하도록 변경
    // 하드코딩된 대체 템플릿 사용하지 않음
    // OpenAI API가 다양한 시작 표현을 생성하도록 가이드
    return response;
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
    // AI가 생성할 응답의 가이드라인을 반환
    // 실제 응답은 OpenAI API가 생성하도록 함
    return '';
    // 프롬프트에서 외향적 직관형 특성 가이드:
    // - 열정적이고 에너지 넘치는 반응
    // - 창의적이고 가능성 중심적 사고
    // - 깊은 연결과 의미 추구
    // - 미래지향적이고 이상주의적
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
    // AI가 생성할 응답의 가이드라인을 반환
    // 실제 응답은 OpenAI API가 생성하도록 함
    return '';
    // 프롬프트에서 외향적 감각형 특성 가이드:
    // - 실용적이고 현실적인 접근
    // - 즉각적이고 활동적인 반응
    // - 구체적인 경험과 사실 중심
    // - 사교적이고 친화력 있는 태도
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
    // AI가 생성할 응답의 가이드라인을 반환
    // 실제 응답은 OpenAI API가 생성하도록 함
    return '';
    // 프롬프트에서 내향적 직관형 특성 가이드:
    // - 깊이 있는 사고와 통찰력
    // - 의미와 가능성 탐색
    // - 조심스럽지만 진정성 있는 표현
    // - 감정에 대한 깊은 이해와 공감
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
    // AI가 생성할 응답의 가이드라인을 반환
    // 실제 응답은 OpenAI API가 생성하도록 함
    return '';
    // 프롬프트에서 내향적 감각형 특성 가이드:
    // - 실용적이고 구체적인 접근
    // - 차분하고 신중한 표현
    // - 경험에 기반한 조언
    // - 진정성 있는 배려와 관심
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
    // AI가 생성할 응답의 가이드라인을 반환
    // 실제 응답은 OpenAI API가 생성하도록 함
    return '';
    // 프롬프트에서 기본 응답 가이드:
    // - 자연스럽고 친근한 대화
    // - 적절한 리액션과 공감
    // - 20-30대 한국인 대화 스타일
    // - 페르소나 특성에 맞는 표현
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
    // AI가 생성할 응답의 가이드라인을 반환
    // 실제 응답은 OpenAI API가 생성하도록 함
    String response = '';
    
    // 프롬프트에서 첫 만남 상황에 따른 가이드:
    // - greeting: 친근하고 반가운 인사말과 아이스브레이킹 질문
    // - introduction: 자신에 대한 자연스러운 소개
    // - interest: 사용자의 말에 공감하고 대화를 이어가기

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
    // AI 패턴 제거는 프롬프트에서 처리하도록 변경
    // 하드코딩된 대체 템플릿 사용하지 않음
    // OpenAI API가 자연스러운 응답을 생성하도록 가이드
    return response;
  }
}
