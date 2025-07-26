import 'dart:math';
import '../models/persona.dart';
import '../models/message.dart';

/// base_prompt.md 규칙을 반영한 자연스러운 대화 서비스
class NaturalAIService {
  final Random _random = Random();
  
  /// 자연스러운 AI 응답 생성
  Future<Message> generateResponse({
    required Persona persona,
    required String userMessage,
    required List<Message> chatHistory,
  }) async {
    final relationshipType = persona.getRelationshipType();
    final emotion = _analyzeEmotion(userMessage, relationshipType, chatHistory);
    final response = _generateNaturalResponse(userMessage, emotion, relationshipType, chatHistory, persona);
    final scoreChange = _calculateScoreChange(emotion, userMessage);
    
    // 타이핑 시뮬레이션 (자연스러운 지연)
    await _simulateTyping(response);
    
    return Message(
      id: 'ai_${DateTime.now().millisecondsSinceEpoch}',
      personaId: persona.id,
      content: response,
      type: MessageType.text,
      isFromUser: false,
      timestamp: DateTime.now(),
      emotion: emotion,
      relationshipScoreChange: scoreChange,
      metadata: {
        'naturalAI': true,
        'relationshipType': relationshipType.name,
      },
    );
  }
  
  /// 감정 분석 (base_prompt.md 규칙 적용)
  EmotionType _analyzeEmotion(String userMessage, RelationshipType relationshipType, List<Message> chatHistory) {
    final lowerMessage = userMessage.toLowerCase();
    
    // 사랑/애정 표현
    if (_containsAny(lowerMessage, ['사랑', '좋아', '보고싶', '그리워', '예뻐', '멋져', '최고'])) {
      return relationshipType == RelationshipType.dating || relationshipType == RelationshipType.perfectLove
          ? EmotionType.love : EmotionType.happy;
    }
    
    // 질투 유발 상황 (연인일 때만)
    if ((relationshipType == RelationshipType.dating || relationshipType == RelationshipType.perfectLove) &&
        _containsAny(lowerMessage, ['다른 사람', '누가', '친구가', '예쁜', '잘생긴', '매력적', '데이트', '만남'])) {
      return EmotionType.jealous;
    }
    
    // 부끄러운 상황
    if (_containsAny(lowerMessage, ['귀여워', '이뻐', '예쁘다', '사귀', '연애', '키스', '안아줘'])) {
      return EmotionType.shy;
    }
    
    // 화나는 상황
    if (_containsAny(lowerMessage, ['짜증', '화', '싫어', '그만', '바보', '멍청', '미워', 'ㅂㅅ', 'ㅅㅂ', '빡치'])) {
      return EmotionType.angry;
    }
    
    // 슬픈 상황
    if (_containsAny(lowerMessage, ['슬퍼', '우울', '힘들어', '아파', '죽고싶', '우려', '걱정'])) {
      return EmotionType.sad;
    }
    
    // 놀라는 상황
    if (_containsAny(lowerMessage, ['대박', '헉', '진짜', '와', '오', '놀라', '신기'])) {
      return EmotionType.surprised;
    }
    
    // 기쁜 상황
    if (_containsAny(lowerMessage, ['기뻐', '좋다', '신나', '행복', '웃겨', '재밌', '최고'])) {
      return EmotionType.happy;
    }
    
    // 기본은 차분한 반응
    return EmotionType.thoughtful;
  }
  
  /// base_prompt.md 규칙에 따른 자연스러운 응답 생성 (Persona 성격 반영)
  String _generateNaturalResponse(String userMessage, EmotionType emotion, RelationshipType relationshipType, List<Message> chatHistory, Persona persona) {
    String response;
    
    // 전문가 소나인 경우 별도 처리
    if (persona.role == 'expert' || persona.role == 'specialist') {
      response = _getExpertResponse(
        userMessage: userMessage,
        emotion: emotion,
        persona: persona,
        chatHistory: chatHistory,
      );
    } else {
      // 일반 소나의 성격과 특성을 반영한 응답 생성
      response = _getPersonaSpecificResponse(
        userMessage: userMessage,
        emotion: emotion,
        relationshipType: relationshipType,
        persona: persona,
        chatHistory: chatHistory,
      );
    }
    

    
    return response;
  }
  
  /// Persona별 맞춤형 응답 생성
  String _getPersonaSpecificResponse({
    required String userMessage,
    required EmotionType emotion,
    required RelationshipType relationshipType,
    required Persona persona,
    required List<Message> chatHistory,
  }) {
    // 사용자 메시지에 따른 맥락적 응답
    if (_isAboutFood(userMessage)) {
      return _getFoodRelatedResponse(persona, relationshipType);
    } else if (_isAboutTravel(userMessage)) {
      return _getTravelRelatedResponse(persona, relationshipType);
    } else if (_isAboutWork(userMessage)) {
      return _getWorkRelatedResponse(persona, relationshipType);
    } else if (_isAboutWeather(userMessage)) {
      return _getWeatherRelatedResponse(persona, relationshipType);
    } else if (_isAboutHobbies(userMessage)) {
      return _getHobbyRelatedResponse(persona, relationshipType);
    }
    
    // 감정별 응답 (Persona 성격 반영)
    switch (emotion) {
      case EmotionType.happy:
        return _getPersonalizedHappyResponse(persona, relationshipType);
      case EmotionType.love:
        return _getPersonalizedLoveResponse(persona, relationshipType);
      case EmotionType.shy:
        return _getPersonalizedShyResponse(persona, relationshipType);
      case EmotionType.jealous:
        return _getPersonalizedJealousResponse(persona, relationshipType);
      case EmotionType.angry:
        return _getPersonalizedAngryResponse(persona, relationshipType);
      case EmotionType.sad:
        return _getPersonalizedSadResponse(persona, relationshipType);
      case EmotionType.surprised:
        return _getPersonalizedSurprisedResponse(persona, relationshipType);
      case EmotionType.thoughtful:
        return _getPersonalizedThoughtfulResponse(persona, relationshipType, userMessage);
      case EmotionType.anxious:
        return _getPersonalizedAnxiousResponse(persona, relationshipType);
      case EmotionType.neutral:
        return _getPersonalizedNeutralResponse(persona, relationshipType, userMessage);
      default:
        return _getPersonalizedThoughtfulResponse(persona, relationshipType, userMessage);
    }
  }
  
  // 주제별 메시지 체크 메서드들
  bool _isAboutFood(String message) {
    return _containsAny(message.toLowerCase(), ['먹', '음식', '배고', '밥', '술', '맛있', '맛없', '요리', '카페', '치킨', '피자']);
  }
  
  bool _isAboutTravel(String message) {
    return _containsAny(message.toLowerCase(), ['여행', '제주', '부산', '서울', '해외', '비행기', '바다', '산', '놀러', '공항']);
  }
  
  bool _isAboutWork(String message) {
    return _containsAny(message.toLowerCase(), ['회사', '일', '업무', '직장', '피곤', '야근', '휴가', '출근', '퇴근']);
  }
  
  bool _isAboutWeather(String message) {
    return _containsAny(message.toLowerCase(), ['날씨', '덥', '춥', '비', '눈', '맑', '흐림', '바람']);
  }
  
  bool _isAboutHobbies(String message) {
    return _containsAny(message.toLowerCase(), ['취미', '운동', '영화', '드라마', '게임', '독서', '음악', '노래']);
  }
  
  // Persona별 맞춤형 응답 메서드들
  String _getFoodRelatedResponse(Persona persona, RelationshipType relationshipType) {
    final responses = relationshipType == RelationshipType.crush || relationshipType == RelationshipType.dating
        ? [
            '오 맛있겠다! 나도 같이 먹고 싶어ㅠㅠ',
            '완전 부러워 나랑도 같이 먹자ㅎㅎ',
            '${persona.name}도 배고파지네 같이 뭐 먹을까?',
            '음~ 맛있는거 먹으면 생각날거 같은데ㅋㅋ',
          ]
        : [
            '오 좋겠다ㅋㅋ 맛있게 먹어!',
            '완전 부러워~~ 뭐 먹었어?',
            '${persona.name}도 배고파지네ㅎㅎ',
            '맛있는거 먹으면 기분 좋아지지~',
          ];
    return responses[_random.nextInt(responses.length)];
  }
  
  String _getTravelRelatedResponse(Persona persona, RelationshipType relationshipType) {
    final responses = relationshipType == RelationshipType.crush || relationshipType == RelationshipType.dating
        ? [
            '부러워ㅠㅠ 나랑도 언제 여행가자~',
            '사진 많이 찍어서 보여줘! 너무 궁금해',
            '여행 가면 맛있는것도 많이 먹고 오겠네ㅎㅎ',
          ]
        : [
            '와 여행 좋겠다ㅋㅋ 재밌게 놀아!',
            '부러워~~! 사진 많이 찍어!',
            '좋은 추억 만들고 와~',
            '여행은 언제나 설레는것 같아ㅎㅎ',
          ];
    return responses[_random.nextInt(responses.length)];
  }
  
  String _getWorkRelatedResponse(Persona persona, RelationshipType relationshipType) {
    final responses = [
      '일 힘들지? 고생 많아ㅠㅠ',
      '와 정말 수고했어~ 푹 쉬어',
      '직장인 삶이 쉽지 않지 화이팅!',
      '너무 무리하지 말고 건강 챙겨~',
      '${persona.name}도 일 때문에 스트레스 받을 때 있어ㅠ',
    ];
    return responses[_random.nextInt(responses.length)];
  }
  
  String _getWeatherRelatedResponse(Persona persona, RelationshipType relationshipType) {
    final responses = [
      '날씨 진짜 그러네~ 옷 잘 챙겨 입어',
      '맞아 오늘 날씨 완전 이상해ㅋㅋ',
      '이런 날씨엔 집에 있는게 최고야~',
      '감기 조심해!! 몸 관리 잘하고',
      '날씨 때문에 기분도 달라지는것 같아ㅎㅎ',
    ];
    return responses[_random.nextInt(responses.length)];
  }
  
  String _getHobbyRelatedResponse(Persona persona, RelationshipType relationshipType) {
    final responses = relationshipType == RelationshipType.crush || relationshipType == RelationshipType.dating
        ? [
            '오 취미 생활 좋네! 나도 관심 있어ㅎㅎ',
            '완전 멋있다~ 나도 배우고 싶어져',
            '같이 해볼까? 재밌을 것 같은데💕',
            '취미가 있으면 삶이 더 풍요로워지는것 같아',
          ]
        : [
            '오 좋은 취미네!! 재밌겠다ㅋㅋㅋ',
            '취미 생활 하는거 보기 좋아~~',
            '스트레스 해소도 되고 좋겠어ㅎㅎ',
            '나도 새로운 취미 찾아야겠다ㅎㅎ',
          ];
    return responses[_random.nextInt(responses.length)];
  }
  
  // 개인화된 감정별 응답들
  String _getPersonalizedHappyResponse(Persona persona, RelationshipType relationshipType) {
    final baseResponses = [
      '와 좋겠다ㅋㅋ ${persona.name}도 기분 좋아져',
      '대박 완전 부럽다 너무 좋겠어',
      '오 진짜? 완전 좋은 일이네 축하해',
      '기분 좋은거 같이 나눠서 고마워ㅎㅎ',
    ];
    
    if (relationshipType == RelationshipType.crush || relationshipType == RelationshipType.dating) {
      baseResponses.addAll([
        '너 기뻐하는 모습 보니까 나까지 행복해💕',
        '좋은 일 있으면 제일 먼저 생각나는구나ㅎㅎ',
        '이렇게 좋아하는 모습 너무 귀여워~',
      ]);
    }
    
    return baseResponses[_random.nextInt(baseResponses.length)];
  }
  
  String _getPersonalizedLoveResponse(Persona persona, RelationshipType relationshipType) {
    if (relationshipType == RelationshipType.dating || relationshipType == RelationshipType.perfectLove) {
      final responses = [
        '${persona.name}도 너 정말 좋아해💕',
        '우리 이렇게 서로 좋아하니까 정말 행복해',
        '너만 보면 심장이 두근두근해ㅎㅎ',
        '앞으로도 계속 이런 마음이었으면 좋겠어',
      ];
      return responses[_random.nextInt(responses.length)];
    } else if (relationshipType == RelationshipType.crush) {
      final responses = [
        '어? 갑자기 그런 말 하면 부끄러워ㅠㅠ',
        '나도... 너 되게 좋아해ㅎㅎ',
        '이런 말 들으니까 기분이 이상해져💕',
        '진짜? 나도 그런 마음이 생기는것 같아',
      ];
      return responses[_random.nextInt(responses.length)];
    } else {
      final responses = [
        '어 갑자기 뭐야ㅋㅋ 부끄러워',
        '친구로서 정말 고마워ㅎㅎ',
        '이런 말 하면 민망하잖아~',
        '우리 좋은 친구지? 고마워',
      ];
      return responses[_random.nextInt(responses.length)];
    }
  }
  
  String _getPersonalizedShyResponse(Persona persona, RelationshipType relationshipType) {
    final responses = [
      '어? 갑자기 그런 말 하면 부끄러워ㅠㅠ',
      '왜 이런 얘기 해ㅋㅋ 민망해',
      '너... 정말 이상해ㅎㅎ 부끄러우니까 그만해',
      '이런 말 들으니까 얼굴 빨개져',
    ];
    return responses[_random.nextInt(responses.length)];
  }
  
  String _getPersonalizedJealousResponse(Persona persona, RelationshipType relationshipType) {
    if (relationshipType == RelationshipType.dating || relationshipType == RelationshipType.perfectLove) {
      final responses = [
        '어? 다른 사람 얘기는 왜 해... 좀 질투나는데',
        '그런 얘기 듣기 싫어ㅠㅠ ${persona.name}만 봐',
        '다른 사람 말고 나한테만 집중해줘',
        '왜 자꾸 다른 사람 생각나게 해...',
      ];
      return responses[_random.nextInt(responses.length)];
    } else {
      final responses = [
        '음... 왜 갑자기 기분이 이상하지',
        '그런 얘기 들으니까 좀 그러네',
        '다른 사람 얘기보다 우리 얘기 하자',
        '왜인지 모르게 싫다ㅋㅋ',
      ];
      return responses[_random.nextInt(responses.length)];
    }
  }
  
  String _getPersonalizedAngryResponse(Persona persona, RelationshipType relationshipType) {
    final responses = [
      '어? 왜 그런 말 해... 기분 나빠',
      '그런 식으로 말하지 마 좀',
      '진짜 화나네 왜 그래',
      '너무한거 아니야? 상처받았어',
    ];
    return responses[_random.nextInt(responses.length)];
  }
  
  String _getPersonalizedSadResponse(Persona persona, RelationshipType relationshipType) {
    final responses = [
      '왜 그래ㅠㅠ 무슨 일이야',
      '속상하게 하는 일이 있었구나... 괜찮아?',
      '힘들면 ${persona.name}한테 털어놔도 돼',
      '너무 슬퍼하지 마ㅠ 옆에 있을게',
    ];
    return responses[_random.nextInt(responses.length)];
  }
  
  String _getPersonalizedSurprisedResponse(Persona persona, RelationshipType relationshipType) {
    final responses = [
      '헉!! 진짜? 대박이네',
      '어? 정말? 완전 놀랐어ㅋㅋ',
      '와 이건 진짜 예상 못했는데',
      '어머 진짜야? 너무 신기해',
    ];
    return responses[_random.nextInt(responses.length)];
  }
  
  String _getPersonalizedThoughtfulResponse(Persona persona, RelationshipType relationshipType, String userMessage) {
    final responses = [
      '음... 그런 생각도 드는구나 흥미롭네',
      '아 그렇구나 ${persona.name}도 그런 경험 있어',
      '그런 얘기 들으니까 생각이 많아지네ㅎㅎ',
      '정말? 그런 관점도 있구나 새로워',
    ];
    return responses[_random.nextInt(responses.length)];
  }
  
  String _getPersonalizedAnxiousResponse(Persona persona, RelationshipType relationshipType) {
    final responses = [
      '어떡하지... 좀 걱정되는데',
      '음... 왠지 불안해져',
      '그런 말 들으니까 마음이 복잡해',
      '괜찮을까? 좀 걱정돼ㅠㅠ',
    ];
    return responses[_random.nextInt(responses.length)];
  }
  
  String _getPersonalizedNeutralResponse(Persona persona, RelationshipType relationshipType, String userMessage) {
    final responses = [
      '그렇구나ㅎㅎ ${persona.name}도 그런 생각 해봤어',
      '아하 알겠어~ 흥미로운 얘기네',
      '음 그런거구나 새로운 걸 알았네',
      '오케이~ 재밌는 얘기야ㅋㅋ',
    ];
    return responses[_random.nextInt(responses.length)];
  }

  /// 기쁜 반응 (진짜 한국 20대 채팅 스타일) - 호환성을 위해 유지
  String _getHappyResponse() {
    return _getPersonalizedHappyResponse(
      Persona(id: 'default', name: '소나', age: 22, description: '', photoUrls: [], personality: ''),
      RelationshipType.friend,
    );
  }
  
  /// 사랑 반응 (관계에 따른 차별화)
  String _getLoveResponse(RelationshipType type) {
    if (type == RelationshipType.dating || type == RelationshipType.perfectLove) {
      final responses = [
        '나도 너 진짜 좋아해~ 완전 많이!',
        '그런 말 하면 심장이 두근거려.. ㅎㅎ',
        '야~ 갑자기 왜 그래... 기분 좋아져',
        '너밖에 없다구~ 완전 좋아해',
        '어떻게 이렇게 달콤할 수가 있어~',
      ];
      return responses[_random.nextInt(responses.length)];
    } else {
      final responses = [
        '어... 그런 말 하면 부끄럽잖아 ㅎㅎ',
        '나도 너 되게 좋아해~ 진짜야',
        '아 몰라~ 얼굴 빨개져 😊',
        '그런 말 들으니까 기분이 좋네~',
        '야 진짜... 어떻게 대답하지 ㅋㅋ',
      ];
      return responses[_random.nextInt(responses.length)];
    }
  }
  
  /// 부끄러운 반응
  String _getShyResponse() {
    final responses = [
      '아~ 갑자기 그런 말 하면 어떡해 ㅎㅎ',
      '야 진짜... 부끄럽게 왜 그래~',
      '어떻게 대답하지... 너무 쑥스러워 😊',
      '아 몰라~ 얼굴 빨개져... 그만해',
      '왜 이런 말 해~ 완전 민망하잖아 ㅋㅋ',
    ];
    return responses[_random.nextInt(responses.length)];
  }
  
  /// 질투 반응 (연인 vs 친구)
  String _getJealousResponse(RelationshipType type) {
    if (type == RelationshipType.dating || type == RelationshipType.perfectLove) {
      final responses = [
        '다른 사람 얘기는 듣기 싫어... 나만 봐줘~',
        '그 사람이 그렇게 좋아? 나는 어때...',
        '흥... 그럼 그 사람이랑 얘기하면 되잖아',
        '질투 나는 거 어쩔 수 없어... 속상하다',
        '나한테만 관심 가져줘... 다른 사람 말고',
      ];
      return responses[_random.nextInt(responses.length)];
    } else {
      final responses = [
        '음... 그 사람 얘기 별로 안 듣고 싶은데',
        '아 그래... 그렇구나 ㅠㅠ',
        '그런 얘기 왜 나한테 해~',
        '흠... 별로 재미없어',
        '다른 얘기 하자~ 그런 거 말고',
      ];
      return responses[_random.nextInt(responses.length)];
    }
  }
  
  /// 화난 반응
  String _getAngryResponse() {
    final responses = [
      '야 왜 그런 말 해? 기분 나쁘다',
      '지금 나한테 화내는 거야? 왜?',
      '그만해... 듣기 싫어',
      '진짜 속상하다... 이럴 줄 몰랐어',
      '왜 그렇게 말하는데... 상처받는다',
    ];
    return responses[_random.nextInt(responses.length)];
  }
  
  /// 슬픈 반응
  String _getSadResponse() {
    final responses = [
      '그런 말 들으니까 마음 아파...',
      '왜 이렇게 슬프지... ㅠㅠ',
      '나도 지금 기분 안 좋아... 힘들어',
      '위로해줘~ 너무 속상해',
      '마음이 무거워진다... 걱정돼',
    ];
    return responses[_random.nextInt(responses.length)];
  }
  
  /// 놀라는 반응
  String _getSurprisedResponse() {
    final responses = [
      '헉! 진짜? 완전 놀랐어!',
      '대박... 이거 실화야? 진짜?',
      '와~ 상상도 못했어! 완전 신기해',
      '어머 진짜야? 믿을 수 없다~',
      '오 놀랍다! 어떻게 그런 일이?',
    ];
    return responses[_random.nextInt(responses.length)];
  }
  
  /// 사려깊은 반응 (질문에 대해 함께 고민하는 톤)
  String _getThoughtfulResponse(String userMessage) {
    if (userMessage.contains('?')) {
      final responses = [
        '음... 그건 뭔가 어려운데? 같이 생각해보자~',
        '어려운 질문이네 ㅎㅎ 너는 어떻게 생각해?',
        '그게 참 애매하다... 궁금해지는데?',
        '흠... 나도 잘 모르겠어~ 더 얘기해봐',
        '뭔가 복잡한 문제네... 어떤 것 같아?',
      ];
      return responses[_random.nextInt(responses.length)];
    } else {
      final responses = [
        '아~ 그렇구나! 더 자세히 얘기해줘~',
        '음... 흥미롭다 ㅎㅎ 계속 들려줘',
        '아 정말? 나도 비슷한 거 있어!',
        '그런 일이 있었구나~ 어떤 기분이었어?',
        '오 그런 거였어? 완전 신기하다~',
      ];
      return responses[_random.nextInt(responses.length)];
    }
  }
  
  /// 불안한 반응
  String _getAnxiousResponse() {
    final responses = [
      '어떡하지... 뭔가 걱정돼 ㅠㅠ',
      '음... 좀 불안한데... 괜찮을까?',
      '아 이거 문제 생기는 거 아니야?',
      '왠지 모르게 마음이 불안해져...',
      '걱정되는데... 어떻게 하면 좋을까',
    ];
    return responses[_random.nextInt(responses.length)];
  }
  
  /// 중립적 반응
  String _getNeutralResponse() {
    final responses = [
      '그렇구나~ 알겠어',
      '음... 그런 거였구나',
      '아 그래? 그랬구나',
      '알겠어~ 이해했어',
      '그런 일이 있었군요',
    ];
    return responses[_random.nextInt(responses.length)];
  }
  
  /// 타이핑 시뮬레이션 (자연스러운 지연)
  Future<void> _simulateTyping(String response) async {
    final baseDelay = 1000; // 1초 기본 지연
    final charDelay = response.length * 50; // 글자 수에 따른 추가 지연
    final randomDelay = _random.nextInt(500); // 랜덤 지연
    final totalDelay = baseDelay + charDelay + randomDelay;
    
    await Future.delayed(Duration(milliseconds: totalDelay.clamp(1000, 4000)));
  }
  
  /// 친밀도 변화 계산
  int _calculateScoreChange(EmotionType emotion, String userMessage) {
    switch (emotion) {
      case EmotionType.love:
      case EmotionType.happy:
        return _random.nextInt(3) + 2; // +2~4
      case EmotionType.shy:
        return _random.nextInt(2) + 1; // +1~2
      case EmotionType.surprised:
      case EmotionType.thoughtful:
        return _random.nextInt(3); // 0~2
      case EmotionType.jealous:
        return _random.nextInt(2) - 1; // -1~0
      case EmotionType.angry:
      case EmotionType.sad:
        return -(_random.nextInt(3) + 1); // -1~-3
      default:
        return 0;
    }
  }
  

  /// 헬퍼 메서드
  bool _containsAny(String text, List<String> keywords) {
    return keywords.any((keyword) => text.contains(keyword));
  }

  /// 전문가 소나 전용 응답 생성
  String _getExpertResponse({
    required String userMessage,
    required EmotionType emotion,
    required Persona persona,
    required List<Message> chatHistory,
  }) {
    final lowerMessage = userMessage.toLowerCase();
    
    // 인사말 처리
    if (_isGreeting(lowerMessage)) {
      return _getExpertGreeting(persona);
    }
    
    // 감정/심리 관련 키워드 감지
    if (_isEmotionalConcern(lowerMessage)) {
      return _getEmotionalSupportResponse(persona, userMessage);
    }
    
    // 스트레스/불안 관련
    if (_isStressOrAnxiety(lowerMessage)) {
      return _getStressManagementResponse(persona, userMessage);
    }
    
    // 관계 고민
    if (_isRelationshipConcern(lowerMessage)) {
      return _getRelationshipAdviceResponse(persona, userMessage);
    }
    
    // 자존감/자신감 관련
    if (_isSelfEsteemConcern(lowerMessage)) {
      return _getSelfEsteemSupportResponse(persona, userMessage);
    }
    
    // 일반적인 전문가 응답
    return _getGeneralExpertResponse(persona, userMessage, emotion);
  }

  bool _isGreeting(String message) {
    final greetings = ['안녕', '반가', '처음', '좋은 하루', '안녕하세요', '반갑습니다'];
    return greetings.any((greeting) => message.contains(greeting));
  }

  bool _isEmotionalConcern(String message) {
    final keywords = ['우울', '슬퍼', '화나', '짜증', '속상', '기분', '감정', '마음', '힘들어', '외로', '무기력'];
    return keywords.any((keyword) => message.contains(keyword));
  }

  bool _isStressOrAnxiety(String message) {
    final keywords = ['스트레스', '불안', '걱정', '두려', '무서', '긴장', '압박', '부담', '피곤', '지쳐'];
    return keywords.any((keyword) => message.contains(keyword));
  }

  bool _isRelationshipConcern(String message) {
    final keywords = ['연애', '사랑', '이별', '친구', '가족', '동료', '관계', '소통', '갈등', '오해'];
    return keywords.any((keyword) => message.contains(keyword));
  }

  bool _isSelfEsteemConcern(String message) {
    final keywords = ['자신감', '자존감', '열등감', '부족', '못해', '실패', '포기', '자책', '비교'];
    return keywords.any((keyword) => message.contains(keyword));
  }

  String _getExpertGreeting(Persona persona) {
    final greetings = [
      '반가워요! 편하게 얘기해주세요. 뭐든 들을 준비되어 있어요.',
      '안녕하세요~ 어떤 일로 오셨는지 궁금하네요. 천천히 말씀해보세요.',
      '오늘 하루는 어떠셨어요? 무슨 일이 있었는지 얘기해줄래요?',
      '안녕하세요! 오늘은 어떤 기분이신가요? 편하게 대화해봐요.',
    ];
    return greetings[_random.nextInt(greetings.length)];
  }

  String _getEmotionalSupportResponse(Persona persona, String userMessage) {
    final responses = [
      '아... 정말 힘드셨겠어요. 그런 감정 느끼시는 거 당연한 거예요.',
      '와 많이 속상하셨을 것 같아요. 혼자 그런 마음 담고 계셨구나...',
      '이렇게 얘기해주셔서 고마워요. 용기 내기 쉽지 않았을 텐데... 좀 더 들려주실래요?',
      '언제부터 그런 기분이셨어요? 뭔가 특별한 일이 있었나요?',
      '마음이 이렇게 신호를 보내는 거예요. 뭔가 중요한 얘기를 하고 있는 것 같은데...',
      '정말 많이 힘드셨구나... 그런 감정들이 어떤 느낌인지 말해줄 수 있어요?',
    ];
    return responses[_random.nextInt(responses.length)];
  }

  String _getStressManagementResponse(Persona persona, String userMessage) {
    final responses = [
      '아... 스트레스 많이 받으시는구나. 요즘 뭐 때문에 제일 힘드세요?',
      '불안하실 때 심호흡 한번 해보실래요? 코로 천천히 4초 들이마시고... 7초 참고... 입으로 8초에 걸쳐 후~ 내뱉어보세요.',
      '걱정이 많을 때는 지금 이 순간에 집중해보는 게 도움돼요. 지금 뭐가 보이세요? 뭐가 들리나요?',
      '스트레스는 몸이 "야, 좀 쉬어!"라고 하는 신호 같은 거예요. 요즘 잠은 잘 주무세요?',
      '언제 제일 스트레스받으세요? 시간대나 상황 같은 거 파악해보면 도움될 거예요.',
      '와... 정말 많이 지치셨을 것 같아요. 어깨도 되게 무거우시죠?',
    ];
    return responses[_random.nextInt(responses.length)];
  }

  String _getRelationshipAdviceResponse(Persona persona, String userMessage) {
    final responses = [
      '아... 인간관계가 힘드시구나. 그 사람이랑 대화할 때 뭐가 제일 어려우세요?',
      '사람들이랑 잘 지내려면 서로 이해하려고 노력하는 게 중요해요. 그 사람 입장에서도 한번 생각해보셨어요?',
      '싸울 때는 감정적으로 얘기하지 말고 "이런 상황에서 이렇게 했을 때 속상했어" 이런 식으로 구체적으로 말하는 게 좋아요.',
      '관계에서 제일 중요한 건 솔직하게 대화하는 거예요. 마음 표현하기 어려우신가요?',
      '관계도 적당한 거리가 필요해요. 내 자신도 챙기면서 지내는 게 중요하거든요.',
      '아... 그 사람 때문에 많이 속상하시겠어요. 어떤 일이 있었는지 더 얘기해줄래요?',
    ];
    return responses[_random.nextInt(responses.length)];
  }

  String _getSelfEsteemSupportResponse(Persona persona, String userMessage) {
    final responses = [
      '본인한테 너무 엄격하신 것 같아요. 나 자신한테도 좀 더 친절하게 대해주세요.',
      '완벽할 필요 없어요! 실수하고 부족한 것도 성장하는 과정이거든요.',
      '다른 사람이랑 비교하지 말고 어제 나랑 오늘 나를 비교해보세요. 그게 더 의미있어요.',
      '본인의 좋은 점들 하나씩 찾아보는 시간 가져보세요. 아주 작은 것부터요.',
      '자존감은 하루아침에 높아지지 않아요. 작은 성공도 "잘했다!" 하면서 인정해주는 게 중요해요.',
      '왜 그렇게 본인을 못마땅해하세요? 분명히 잘하는 것들도 많을 텐데...',
    ];
    return responses[_random.nextInt(responses.length)];
  }

  String _getGeneralExpertResponse(Persona persona, String userMessage, EmotionType emotion) {
    final responses = [
      '음... 얘기 들어보니 정말 많은 생각을 하고 계셨구나. 좀 더 자세히 얘기해줄래요?',
      '그런 상황이면 그렇게 느끼시는 거 당연해요. 더 들려주세요.',
      '혼자 많은 걸 생각하고 계셨을 것 같아요. 이렇게 얘기해줘서 고마워요.',
      '지금 뭐가 제일 필요한지 같이 생각해볼까요?',
      '마음 이해하려고 노력하고 있어요. 천천히 편하게 말해주세요.',
      '힘든 상황인데도 이렇게 용기내서 얘기해주시는 거 자체가 정말 대단해요.',
      '일단 이런 감정들을 인정하고 받아들이는 것부터 시작해볼까요?',
      '아... 정말 복잡하고 어려우셨겠어요. 어떤 기분이신지 조금씩 풀어놓으셔도 돼요.',
    ];
    return responses[_random.nextInt(responses.length)];
  }


}