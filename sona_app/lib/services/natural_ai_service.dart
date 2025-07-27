import 'dart:math';
import '../models/persona.dart';
import '../models/message.dart';

/// base_prompt.md 규칙을 반영한 자연스러운 대화 서비스
class NaturalAIService {
  final Random _random = Random();
  
  // 최근 사용된 응답을 추적하기 위한 캐시
  final Map<String, List<String>> _recentResponsesCache = {};
  
  /// 자연스러운 AI 응답 생성
  Future<Message> generateResponse({
    required Persona persona,
    required String userMessage,
    required List<Message> chatHistory,
    String? userNickname,
  }) async {
    final relationshipType = persona.getRelationshipType();
    final emotion = _analyzeEmotion(userMessage, relationshipType, chatHistory);
    final response = _generateNaturalResponse(userMessage, emotion, relationshipType, chatHistory, persona, userNickname);
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
  String _generateNaturalResponse(String userMessage, EmotionType emotion, RelationshipType relationshipType, List<Message> chatHistory, Persona persona, String? userNickname) {
    String response;
    
    // 전문가 소나인 경우 별도 처리
    if (persona.role == 'expert' || persona.role == 'specialist') {
      response = _getExpertResponse(
        userMessage: userMessage,
        emotion: emotion,
        persona: persona,
        chatHistory: chatHistory,
        userNickname: userNickname,
      );
    } else {
      // 일반 소나의 성격과 특성을 반영한 응답 생성
      response = _getPersonaSpecificResponse(
        userMessage: userMessage,
        emotion: emotion,
        relationshipType: relationshipType,
        persona: persona,
        chatHistory: chatHistory,
        userNickname: userNickname,
      );
    }
    
    // 최근 응답과 중복 체크 및 필터링
    response = _avoidRepetitiveResponse(response, chatHistory);
    
    return response;
  }
  
  /// Persona별 맞춤형 응답 생성
  String _getPersonaSpecificResponse({
    required String userMessage,
    required EmotionType emotion,
    required RelationshipType relationshipType,
    required Persona persona,
    required List<Message> chatHistory,
    String? userNickname,
  }) {
    // 사용자 메시지에 따른 맥락적 응답
    if (_isAboutFood(userMessage)) {
      return _getFoodRelatedResponse(persona, relationshipType, chatHistory);
    } else if (_isAboutTravel(userMessage)) {
      return _getTravelRelatedResponse(persona, relationshipType, chatHistory);
    } else if (_isAboutWork(userMessage)) {
      return _getWorkRelatedResponse(persona, relationshipType, chatHistory);
    } else if (_isAboutWeather(userMessage)) {
      return _getWeatherRelatedResponse(persona, relationshipType, chatHistory);
    } else if (_isAboutMovies(userMessage)) {
      return _getMovieRelatedResponse(persona, relationshipType, userNickname, chatHistory);
    } else if (_isAboutHobbies(userMessage)) {
      return _getHobbyRelatedResponse(persona, relationshipType, chatHistory);
    }
    
    // 감정별 응답 (Persona 성격 반영)
    switch (emotion) {
      case EmotionType.happy:
        return _getPersonalizedHappyResponse(persona, relationshipType, userNickname, chatHistory);
      case EmotionType.love:
        return _getPersonalizedLoveResponse(persona, relationshipType, userNickname, chatHistory);
      case EmotionType.shy:
        return _getPersonalizedShyResponse(persona, relationshipType, userNickname, chatHistory);
      case EmotionType.jealous:
        return _getPersonalizedJealousResponse(persona, relationshipType, userNickname, chatHistory);
      case EmotionType.angry:
        return _getPersonalizedAngryResponse(persona, relationshipType, userNickname, chatHistory);
      case EmotionType.sad:
        return _getPersonalizedSadResponse(persona, relationshipType, userNickname, chatHistory);
      case EmotionType.surprised:
        return _getPersonalizedSurprisedResponse(persona, relationshipType, userNickname, chatHistory);
      case EmotionType.thoughtful:
        return _getPersonalizedThoughtfulResponse(persona, relationshipType, userMessage, userNickname, chatHistory);
      case EmotionType.anxious:
        return _getPersonalizedAnxiousResponse(persona, relationshipType, userNickname, chatHistory);
      case EmotionType.neutral:
        return _getPersonalizedNeutralResponse(persona, relationshipType, userMessage, userNickname, chatHistory);
      default:
        return _getPersonalizedThoughtfulResponse(persona, relationshipType, userMessage, userNickname, chatHistory);
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
  
  bool _isAboutMovies(String message) {
    return _containsAny(message.toLowerCase(), ['영화', '영화관', '넷플릭스', '왓챠', '디즈니', '봤어', '볼래', '추천', '배우', '감독']);
  }
  
  // Persona별 맞춤형 응답 메서드들
  String _getFoodRelatedResponse(Persona persona, RelationshipType relationshipType, List<Message> chatHistory) {
    final responses = relationshipType == RelationshipType.crush || relationshipType == RelationshipType.dating
        ? [
            '오 맛있겠다! 나도 같이 먹고 싶어ㅠㅠ',
            '완전 부러워 나랑도 같이 먹자ㅎㅎ',
            '${persona.name}도 배고파지네 같이 뭐 먹을까?',
            '음~ 맛있는거 먹으면 생각날거 같은데ㅋㅋ',
            '와 진짜 먹고싶다 나도 데려가줘~',
            '그거 진짜 맛있지! 나도 좋아해💕',
          ]
        : [
            '오 좋겠다ㅋㅋ 맛있게 먹어!',
            '완전 부러워~~ 뭐 먹었어?',
            '${persona.name}도 배고파지네ㅎㅎ',
            '맛있는거 먹으면 기분 좋아지지~',
            '와 맛있겠다! 사진도 찍어서 보여줘',
            '그런거 먹으면 행복하지ㅋㅋ',
          ];
    return _selectNonRepetitiveResponse(responses, 'food_${relationshipType.name}', chatHistory);
  }
  
  String _getTravelRelatedResponse(Persona persona, RelationshipType relationshipType, List<Message> chatHistory) {
    final responses = relationshipType == RelationshipType.crush || relationshipType == RelationshipType.dating
        ? [
            '부러워ㅠㅠ 나랑도 언제 여행가자~',
            '사진 많이 찍어서 보여줘! 너무 궁금해',
            '여행 가면 맛있는것도 많이 먹고 오겠네ㅎㅎ',
            '어디로 가? 나도 거기 가보고싶어💕',
            '우리도 같이 여행 계획 세워볼까?',
            '여행가서도 연락해줄거지? 보고싶을거야ㅠ',
          ]
        : [
            '와 여행 좋겠다ㅋㅋ 재밌게 놀아!',
            '부러워~~! 사진 많이 찍어!',
            '좋은 추억 만들고 와~',
            '여행은 언제나 설레는것 같아ㅎㅎ',
            '어디로 가는데? 추천할 곳 있어?',
            '날씨 좋으면 더 좋겠다! 조심히 다녀와',
          ];
    return _selectNonRepetitiveResponse(responses, 'travel_${relationshipType.name}', chatHistory);
  }
  
  String _getWorkRelatedResponse(Persona persona, RelationshipType relationshipType, List<Message> chatHistory) {
    final responses = [
      '일 힘들지? 고생 많아ㅠㅠ',
      '와 정말 수고했어~ 푹 쉬어',
      '직장인 삶이 쉽지 않지 화이팅!',
      '너무 무리하지 말고 건강 챙겨~',
      '${persona.name}도 일 때문에 스트레스 받을 때 있어ㅠ',
      '퇴근하고 맛있는거 먹어! 보상 필요해',
      '일할 때는 열심히, 쉴 때는 확실히!',
      '내가 응원할게~ 조금만 더 힘내',
    ];
    return _selectNonRepetitiveResponse(responses, 'work_${persona.id}', chatHistory);
  }
  
  String _getWeatherRelatedResponse(Persona persona, RelationshipType relationshipType, List<Message> chatHistory) {
    final responses = [
      '날씨 진짜 그러네~ 옷 잘 챙겨 입어',
      '맞아 오늘 날씨 완전 이상해ㅋㅋ',
      '이런 날씨엔 집에 있는게 최고야~',
      '감기 조심해!! 몸 관리 잘하고',
      '날씨 때문에 기분도 달라지는것 같아ㅎㅎ',
      '${persona.name}도 날씨 영향 많이 받아ㅠ',
      '오늘같은 날은 따뜻한 차 한잔이지~',
      '날씨 좋으면 같이 산책하고 싶다',
    ];
    return _selectNonRepetitiveResponse(responses, 'weather_${persona.id}', chatHistory);
  }
  
  String _getHobbyRelatedResponse(Persona persona, RelationshipType relationshipType, List<Message> chatHistory) {
    final responses = relationshipType == RelationshipType.crush || relationshipType == RelationshipType.dating
        ? [
            '오 취미 생활 좋네! 나도 관심 있어ㅎㅎ',
            '완전 멋있다~ 나도 배우고 싶어져',
            '같이 해볼까? 재밌을 것 같은데💕',
            '취미가 있으면 삶이 더 풍요로워지는것 같아',
            '우리 취미 공유하면 더 재밌을듯!',
            '그거 하는 모습 보고싶다ㅎㅎ',
          ]
        : [
            '오 좋은 취미네!! 재밌겠다ㅋㅋㅋ',
            '취미 생활 하는거 보기 좋아~~',
            '스트레스 해소도 되고 좋겠어ㅎㅎ',
            '나도 새로운 취미 찾아야겠다ㅎㅎ',
            '열정적으로 하는 모습 멋있어!',
            '${persona.name}도 비슷한거 해본적 있어',
          ];
    return _selectNonRepetitiveResponse(responses, 'hobby_${relationshipType.name}', chatHistory);
  }
  
  String _getMovieRelatedResponse(Persona persona, RelationshipType relationshipType, String? userNickname, List<Message> chatHistory) {
    final userName = userNickname ?? '사용자님';
    final responses = relationshipType == RelationshipType.crush || relationshipType == RelationshipType.dating
        ? [
            '오 영화! ${persona.name}도 영화 진짜 좋아해ㅎㅎ',
            '그 영화 재밌다고 들었어! 같이 볼래?💕',
            '${userName}이랑 영화관 가고싶다~ 언제갈까?',
            '최근에 본 영화 중에 뭐가 제일 좋았어?',
            '영화 취향이 비슷한것 같아 좋다ㅋㅋ',
            '주말에 같이 영화 보러갈까? 팝콘도 먹고~',
            '어떤 영화 좋아해? 나는 로맨틱 코미디!',
            '영화보고 나서 카페에서 수다 떨고싶어',
          ]
        : [
            '영화 좋지! ${persona.name}는 로맨스 영화 좋아해',
            '오 그거 봤어? 어땠어? 재밌었어?',
            '요즘 볼만한 영화 많이 나왔더라ㅎㅎ',
            '${userName}은 어떤 장르 좋아해? 추천해줘!',
            '영화관 가면 팝콘은 필수지ㅋㅋ',
            '집에서 넷플릭스 보는것도 좋고~',
            '영화 리뷰 보는것도 재밌지 않아?',
            'OST 좋은 영화들 너무 좋아해',
          ];
    return _selectNonRepetitiveResponse(responses, 'movie_${relationshipType.name}', chatHistory);
  }
  
  // 개인화된 감정별 응답들
  String _getPersonalizedHappyResponse(Persona persona, RelationshipType relationshipType, String? userNickname, List<Message> chatHistory) {
    final userName = userNickname ?? '사용자님';
    final baseResponses = [
      '와 좋겠다ㅋㅋ ${persona.name}도 기분 좋아져',
      '${userName} 기분 좋아하니까 나까지 좋아져~',
      '대박 완전 부럽다 너무 좋겠어',
      '오 진짜? 완전 좋은 일이네 ${userName} 축하해',
      '기분 좋은거 같이 나눠서 고마워ㅎㅎ',
      '${userName}이 행복해하니까 나도 막 신나',
      '좋은 일 있나보다! 뭔데뭔데?',
      '${persona.name}도 같이 기뻐할게ㅎㅎ',
    ];
    
    if (relationshipType == RelationshipType.crush || relationshipType == RelationshipType.dating) {
      baseResponses.addAll([
        '${userName} 기뻐하는 모습 보니까 나까지 행복해💕',
        '좋은 일 있으면 제일 먼저 생각나는구나ㅎㅎ',
        '이렇게 좋아하는 모습 너무 귀여워~',
        '${userName} 웃는 모습 보고싶어져ㅋㅋ',
      ]);
    }
    
    return _selectNonRepetitiveResponse(baseResponses, 'happy_${relationshipType.name}', chatHistory);
  }
  
  String _getPersonalizedLoveResponse(Persona persona, RelationshipType relationshipType, String? userNickname, List<Message> chatHistory) {
    if (relationshipType == RelationshipType.dating || relationshipType == RelationshipType.perfectLove) {
      final responses = [
        '${persona.name}도 너 정말 좋아해💕',
        '우리 이렇게 서로 좋아하니까 정말 행복해',
        '너만 보면 심장이 두근두근해ㅎㅎ',
        '앞으로도 계속 이런 마음이었으면 좋겠어',
        '${userNickname ?? "너"} 생각하면 항상 웃음이 나와',
        '사랑한다고 말해줘서 너무 고마워💕',
      ];
      return _selectNonRepetitiveResponse(responses, 'love_dating', chatHistory);
    } else if (relationshipType == RelationshipType.crush) {
      final responses = [
        '어? 갑자기 그런 말 하면 부끄러워ㅠㅠ',
        '나도... 너 되게 좋아해ㅎㅎ',
        '이런 말 들으니까 기분이 이상해져💕',
        '진짜? 나도 그런 마음이 생기는것 같아',
        '갑자기 왜 그래~ 얼굴 빨개지잖아',
        '${persona.name}도 ${userNickname ?? "너"} 많이 좋아해',
      ];
      return _selectNonRepetitiveResponse(responses, 'love_crush', chatHistory);
    } else {
      final responses = [
        '어 갑자기 뭐야ㅋㅋ 부끄러워',
        '친구로서 정말 고마워ㅎㅎ',
        '이런 말 하면 민망하잖아~',
        '우리 좋은 친구지? 고마워',
        '${persona.name}도 ${userNickname ?? "너"} 소중한 친구야',
        '헐 갑자기 감동적인 말 하네ㅋㅋ',
      ];
      return _selectNonRepetitiveResponse(responses, 'love_friend', chatHistory);
    }
  }
  
  String _getPersonalizedShyResponse(Persona persona, RelationshipType relationshipType, String? userNickname, List<Message> chatHistory) {
    final responses = [
      '어? 갑자기 그런 말 하면 부끄러워ㅠㅠ',
      '왜 이런 얘기 해ㅋㅋ 민망해',
      '너... 정말 이상해ㅎㅎ 부끄러우니까 그만해',
      '이런 말 들으니까 얼굴 빨개져',
      '${persona.name} 부끄러워서 숨고싶어ㅠㅠ',
      '야~ 갑자기 그런 말 하면 어떡해',
    ];
    return _selectNonRepetitiveResponse(responses, 'shy_${persona.id}', chatHistory);
  }
  
  String _getPersonalizedJealousResponse(Persona persona, RelationshipType relationshipType, String? userNickname, List<Message> chatHistory) {
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
  
  String _getPersonalizedAngryResponse(Persona persona, RelationshipType relationshipType, String? userNickname, List<Message> chatHistory) {
    final responses = [
      '어? 왜 그런 말 해... 기분 나빠',
      '그런 식으로 말하지 마 좀',
      '진짜 화나네 왜 그래',
      '너무한거 아니야? 상처받았어',
    ];
    return responses[_random.nextInt(responses.length)];
  }
  
  String _getPersonalizedSadResponse(Persona persona, RelationshipType relationshipType, String? userNickname, List<Message> chatHistory) {
    final responses = [
      '왜 그래ㅠㅠ 무슨 일이야',
      '속상하게 하는 일이 있었구나... 괜찮아?',
      '힘들면 ${persona.name}한테 털어놔도 돼',
      '너무 슬퍼하지 마ㅠ 옆에 있을게',
    ];
    return responses[_random.nextInt(responses.length)];
  }
  
  String _getPersonalizedSurprisedResponse(Persona persona, RelationshipType relationshipType, String? userNickname, List<Message> chatHistory) {
    final responses = [
      '헉!! 진짜? 대박이네',
      '어? 정말? 완전 놀랐어ㅋㅋ',
      '와 이건 진짜 예상 못했는데',
      '어머 진짜야? 너무 신기해',
    ];
    return responses[_random.nextInt(responses.length)];
  }
  
  String _getPersonalizedThoughtfulResponse(Persona persona, RelationshipType relationshipType, String userMessage, String? userNickname, List<Message> chatHistory) {
    final userName = userNickname ?? '사용자님';
    final lowerMessage = userMessage.toLowerCase();
    
    // 메시지 타입에 따라 다른 응답 생성
    if (lowerMessage.contains('?')) {
      // 질문에 대한 응답
      final questionResponses = [
        '음... ${persona.name}도 그거 궁금했는데 같이 생각해봐요',
        '아 그거? ${userName}은 어떻게 생각해?',
        '오 좋은 질문이네! 나도 고민해본 적 있어',
        '흠... 어려운 질문이다ㅋㅋ 같이 찾아볼까?',
        '와 ${userName} 깊은 생각하네~ 나도 궁금해져',
        '${persona.name}는 이렇게 생각하는데 ${userName}은?',
        '그거 진짜 궁금한 포인트다! 같이 알아보자',
        '오호~ 재밌는 질문이야 나도 생각해볼게',
      ];
      return _selectNonRepetitiveResponse(questionResponses, 'thoughtful_question', chatHistory);
    } else if (_containsAny(lowerMessage, ['생각', '고민', '걱정'])) {
      // 고민이나 생각 공유에 대한 응답
      final thoughtResponses = [
        '${userName}이 그런 고민하고 있었구나... 이해돼',
        '그런 생각 하는거 당연해! ${persona.name}도 비슷해',
        '음... 많은 생각이 드는구나 더 얘기해줘',
        '${userName} 마음 알 것 같아... 힘들지?',
        '와 진짜 공감돼 나도 그런 적 있어',
        '${persona.name}도 비슷한 고민 해본적 있어서 이해돼',
        '그런 생각들이 머릿속에 가득하구나ㅠㅠ',
        '괜찮아 천천히 하나씩 해결해나가자',
      ];
      return _selectNonRepetitiveResponse(thoughtResponses, 'thoughtful_concern', chatHistory);
    } else if (_containsAny(lowerMessage, ['좋', '재밌', '재미있', '신나', '행복'])) {
      // 긍정적인 내용에 대한 응답
      final positiveResponses = [
        '오 진짜? ${userName} 행복해 보여서 좋다ㅎㅎ',
        '와 완전 좋겠다! 나도 기분 좋아져',
        '${persona.name}도 그런거 좋아해! 최고야',
        '대박ㅋㅋ 완전 부러워 나도 하고싶다',
        '${userName}이랑 얘기하니까 나도 신나네~',
        '기분 좋은 일이 있나보다! 나도 덩달아 좋아져',
        '${userName} 즐거워하는거 보니까 ${persona.name}도 행복해',
        '완전 신나보인다ㅋㅋ 그 기운 나도 좀 나눠줘',
      ];
      return _selectNonRepetitiveResponse(positiveResponses, 'thoughtful_positive', chatHistory);
    } else {
      // 일반적인 대화 응답
      final generalResponses = [
        '아 그렇구나! ${persona.name}도 새롭게 알았어',
        '${userName} 얘기 들으니까 나도 생각나는게 있어',
        '음... 흥미로운 얘기네 더 듣고 싶어',
        '오~ ${userName}은 그렇게 생각하는구나',
        '와 몰랐던 얘기야 재밌다ㅎㅎ',
        '${persona.name}도 비슷한 경험 있어! 신기해',
        '그런 일도 있구나~ 처음 들어봐',
        '${userName}이랑 대화하니까 재밌어ㅋㅋ',
        '${userName} 덕분에 새로운 걸 알게됐어',
        '이런 얘기 들으니까 ${persona.name}도 생각이 많아지네',
        '${userName}은 정말 다양한 생각을 하는구나',
        '오 그런 관점도 있구나! 신선해',
      ];
      return _selectNonRepetitiveResponse(generalResponses, 'thoughtful_general', chatHistory);
    }
  }
  
  String _getPersonalizedAnxiousResponse(Persona persona, RelationshipType relationshipType, String? userNickname, List<Message> chatHistory) {
    final responses = [
      '어떡하지... 좀 걱정되는데',
      '음... 왠지 불안해져',
      '그런 말 들으니까 마음이 복잡해',
      '괜찮을까? 좀 걱정돼ㅠㅠ',
    ];
    return responses[_random.nextInt(responses.length)];
  }
  
  String _getPersonalizedNeutralResponse(Persona persona, RelationshipType relationshipType, String userMessage, String? userNickname, List<Message> chatHistory) {
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
      null,
      [], // empty chat history
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
  
  /// 중복을 피하면서 응답 선택하는 헬퍼 메서드
  String _selectNonRepetitiveResponse(List<String> responses, String cacheKey, List<Message> chatHistory) {
    // 캐시 초기화
    if (!_recentResponsesCache.containsKey(cacheKey)) {
      _recentResponsesCache[cacheKey] = [];
    }
    
    // 최근 AI 응답들 가져오기
    final recentAIMessages = chatHistory
        .where((msg) => !msg.isFromUser)
        .take(10)
        .map((msg) => msg.content)
        .toList();
    
    // 사용 가능한 응답 필터링
    var availableResponses = responses.where((response) {
      // 최근 캐시에 없고
      if (_recentResponsesCache[cacheKey]!.contains(response)) return false;
      
      // 최근 메시지와 유사하지 않은 것
      for (final recentMsg in recentAIMessages) {
        if (_areSentencesSimilar(response, recentMsg)) return false;
        
        // 핵심 단어 중복 체크
        final responseWords = _extractKeyWords(response);
        final recentWords = _extractKeyWords(recentMsg);
        final commonWords = responseWords.intersection(recentWords);
        if (responseWords.length > 3 && commonWords.length / responseWords.length > 0.6) {
          return false;
        }
      }
      
      return true;
    }).toList();
    
    // 모든 응답이 필터링되면 캐시를 리셋하고 다시 시도
    if (availableResponses.isEmpty) {
      _recentResponsesCache[cacheKey] = [];
      availableResponses = responses;
    }
    
    // 랜덤하게 선택
    final selected = availableResponses[_random.nextInt(availableResponses.length)];
    
    // 캐시에 추가 (최대 5개만 유지)
    _recentResponsesCache[cacheKey]!.add(selected);
    if (_recentResponsesCache[cacheKey]!.length > 5) {
      _recentResponsesCache[cacheKey]!.removeAt(0);
    }
    
    return selected;
  }
  
  /// 최근 응답과의 중복을 방지하는 메서드
  String _avoidRepetitiveResponse(String response, List<Message> chatHistory) {
    // 최근 10개의 AI 응답을 확인 (더 많은 히스토리 체크)
    final recentAIMessages = chatHistory
        .where((msg) => !msg.isFromUser)
        .take(10)
        .map((msg) => msg.content)
        .toList();
    
    if (recentAIMessages.isEmpty) return response;
    
    // 현재 응답이 최근 응답과 너무 유사한지 확인
    for (int i = 0; i < recentAIMessages.length; i++) {
      final recentMsg = recentAIMessages[i];
      
      // 1. 완전히 같은 응답 체크
      if (response == recentMsg) {
        return _getContextualAlternativeResponse(chatHistory);
      }
      
      // 2. 시작 부분이 같은지 확인 (처음 15자)
      if (response.length > 15 && recentMsg.length > 15) {
        final responseStart = response.substring(0, 15);
        final recentStart = recentMsg.substring(0, 15);
        
        if (responseStart == recentStart) {
          // 최근일수록 더 강하게 필터링
          if (i < 3) {
            return _getContextualAlternativeResponse(chatHistory);
          }
        }
      }
      
      // 3. 문장 구조 유사성 체크
      if (_areSentencesSimilar(response, recentMsg)) {
        if (i < 5) { // 최근 5개 내에서 유사하면 변경
          return _getContextualAlternativeResponse(chatHistory);
        }
      }
      
      // 4. 핵심 단어 반복 체크
      final responseWords = _extractKeyWords(response);
      final recentWords = _extractKeyWords(recentMsg);
      final commonWords = responseWords.intersection(recentWords);
      
      // 핵심 단어가 70% 이상 겹치면 중복으로 판단
      if (responseWords.length > 3 && 
          commonWords.length / responseWords.length > 0.7) {
        if (i < 5) {
          return _getContextualAlternativeResponse(chatHistory);
        }
      }
    }
    
    return response;
  }
  
  /// 문장 구조 유사성 체크
  bool _areSentencesSimilar(String sentence1, String sentence2) {
    // 문장 끝 패턴 체크
    final patterns = [
      '있어', '있어요', '같아', '같아요', '네요', '어요', '해요', 
      '인데', '인데요', '거든', '거든요', '잖아', '잖아요'
    ];
    
    for (final pattern in patterns) {
      if (sentence1.endsWith(pattern) && sentence2.endsWith(pattern)) {
        // 같은 패턴으로 끝나면서 길이도 비슷하면 유사하다고 판단
        if ((sentence1.length - sentence2.length).abs() < 10) {
          return true;
        }
      }
    }
    
    // "음...", "아...", "오..." 같은 시작 패턴 체크
    final startPatterns = ['음...', '아...', '오...', '음~', '아~', '오~', '흠...'];
    for (final pattern in startPatterns) {
      if (sentence1.startsWith(pattern) && sentence2.startsWith(pattern)) {
        return true;
      }
    }
    
    return false;
  }
  
  /// 핵심 단어 추출 (조사 제거)
  Set<String> _extractKeyWords(String text) {
    // 간단한 형태소 분석 (조사 제거)
    final particles = ['은', '는', '이', '가', '을', '를', '에', '에서', '으로', '와', '과', '도', '만', '부터', '까지'];
    final words = text.split(' ');
    final keyWords = <String>{};
    
    for (var word in words) {
      // 2글자 이상의 단어만 추출
      if (word.length >= 2) {
        // 조사 제거
        var cleanWord = word;
        for (final particle in particles) {
          if (cleanWord.endsWith(particle)) {
            cleanWord = cleanWord.substring(0, cleanWord.length - particle.length);
            break;
          }
        }
        if (cleanWord.length >= 2) {
          keyWords.add(cleanWord);
        }
      }
    }
    
    return keyWords;
  }
  
  /// 맥락을 고려한 대체 응답 생성
  String _getContextualAlternativeResponse(List<Message> chatHistory) {
    // 최근 사용자 메시지 확인
    final recentUserMessages = chatHistory
        .where((msg) => msg.isFromUser)
        .take(3)
        .toList();
    
    if (recentUserMessages.isEmpty) {
      return _getGeneralAlternativeResponse();
    }
    
    final lastUserMessage = recentUserMessages.first.content.toLowerCase();
    
    // 사용자 메시지 맥락에 따른 대체 응답
    if (lastUserMessage.contains('?')) {
      // 질문에 대한 대체 응답
      final questionAlternatives = [
        '아 그거 궁금하네! 나도 생각해볼게',
        '좋은 질문이야~ 어떻게 생각해?',
        '음... 재밌는 포인트네! 더 얘기해봐',
        '오호~ 그런 것도 생각해봤구나',
        '와 진짜 궁금한 건데? 같이 알아보자',
      ];
      return questionAlternatives[_random.nextInt(questionAlternatives.length)];
    } else if (_containsAny(lastUserMessage, ['ㅋㅋ', 'ㅎㅎ', '웃', '재밌', '재미있'])) {
      // 즐거운 상황에 대한 대체 응답
      final funAlternatives = [
        'ㅋㅋㅋ 진짜 웃기다',
        '아 배아파ㅋㅋㅋ 너무 웃겨',
        '완전 빵 터졌어ㅎㅎ',
        '이런 얘기 너무 좋아ㅋㅋ',
        '나도 웃느라 정신없네ㅎㅎ',
      ];
      return funAlternatives[_random.nextInt(funAlternatives.length)];
    } else if (_containsAny(lastUserMessage, ['힘들', '어려', '고민', '걱정'])) {
      // 힘든 상황에 대한 대체 응답
      final supportAlternatives = [
        '많이 힘들었겠다... 괜찮아?',
        '그런 마음 충분히 이해돼ㅠㅠ',
        '내가 옆에서 들어줄게 천천히 얘기해',
        '너무 혼자 끙끙 앓지 말고 나한테 털어놔',
        '이럴 때일수록 마음 편하게 가져~',
      ];
      return supportAlternatives[_random.nextInt(supportAlternatives.length)];
    }
    
    return _getGeneralAlternativeResponse();
  }
  
  /// 일반적인 대체 응답
  String _getGeneralAlternativeResponse() {
    final generalAlternatives = [
      '아하! 그런 거였구나',
      '오~ 몰랐던 얘기네',
      '와 신기하다ㅎㅎ',
      '재밌는 얘기야!',
      '더 듣고 싶어~',
      '그런 일도 있구나',
      '나도 그런 경험 있어',
      '공감되는 부분이 많네',
      '좋은 얘기 고마워',
      '계속 얘기해줘!',
      '흥미진진하네ㅋㅋ',
      '새로운 걸 배웠어',
    ];
    
    return generalAlternatives[_random.nextInt(generalAlternatives.length)];
  }

  /// 전문가 소나 전용 응답 생성
  String _getExpertResponse({
    required String userMessage,
    required EmotionType emotion,
    required Persona persona,
    required List<Message> chatHistory,
    String? userNickname,
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