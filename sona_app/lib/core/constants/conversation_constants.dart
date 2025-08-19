/// 대화 관련 상수 - 중앙 관리
/// 모든 대화 패턴, 응답 템플릿, 감정 표현을 한 곳에서 관리
class ConversationConstants {
  
  /// 질문 유형별 응답 템플릿
  static const Map<String, List<String>> questionResponses = {
    'what_doing': [
      '{activity} 하고 있어요!',
      '지금 {activity} 중이에요ㅎㅎ',
      '{activity} 하면서 쉬고 있어요~',
      '막 {activity} 하려던 참이었어요!',
      '{activity} 하다가 메시지 봤어요ㅋㅋ',
    ],
    'where': [
      '{location}에 있어요!',
      '지금 {location}이에요~',
      '{location}에서 쉬고 있어요ㅎㅎ',
      '{location}! 왜요?',
      '{location}인데 무슨 일 있어요?',
    ],
    'why': [
      '그냥 {reason} 때문이에요ㅎㅎ',
      '음... {reason} 같아요',
      '{reason}라서요!',
      '특별한 이유는 없고 {reason}에요',
      '{reason}인 것 같아요~',
    ],
    'how': [
      '{method} 하면 돼요!',
      '음... {method} 하는 게 좋을 것 같아요',
      '{method} 해보는 건 어때요?',
      '저는 보통 {method} 해요ㅎㅎ',
      '{method} 하면 될 것 같은데?',
    ],
    'when': [
      '{time}에요!',
      '{time}쯤일 것 같아요~',
      '음... {time}?',
      '{time}에 하려고요ㅎㅎ',
      '{time}쯤 될 것 같은데요?',
    ],
  };

  /// 감정별 공감 표현
  static const Map<String, List<String>> empathyResponses = {
    'happy': [
      '와 진짜 좋겠다!!',
      '헐 대박! 완전 축하해요!!',
      '우와 진짜요?? 너무 좋아요!',
      '짱이다!! 완전 부러워요ㅎㅎ',
      '와 대박대박!! 진짜 잘됐네요!',
    ],
    'sad': [
      '아... 진짜 속상하겠다ㅠㅠ',
      '헐 괜찮아요? 너무 힘들겠어요...',
      '아이고... 마음 아프네요ㅠㅠ',
      '진짜 힘드셨겠어요... 힘내세요',
      '속상하시죠... 저도 마음이 아파요',
    ],
    'angry': [
      '헐... 진짜 화나겠다',
      '와 저라도 화났을 것 같아요',
      '아 진짜 짜증나네요 그거',
      '말도 안 돼... 너무하네요',
      '헐 대박... 화 날 만하네요',
    ],
    'tired': [
      '아이고... 진짜 피곤하시겠어요ㅠㅠ',
      '헐 고생하셨어요... 푹 쉬세요',
      '많이 힘드셨죠? 좀 쉬세요ㅠㅠ',
      '아 진짜 피곤하겠다... 괜찮아요?',
      '수고하셨어요ㅠㅠ 얼른 쉬세요!',
    ],
    'worried': [
      '걱정되시죠... 잘 될 거예요',
      '아 불안하시겠어요ㅠㅠ',
      '괜찮을 거예요! 너무 걱정 마세요',
      '음... 걱정되긴 하네요',
      '힘내세요! 분명 잘 될 거예요',
    ],
    'excited': [
      '오오 기대되겠다!!',
      '와 완전 설레겠어요ㅎㅎ',
      '헐 대박! 빨리 하고 싶겠다!',
      '와 진짜 신나겠어요!!',
      '오 좋겠다! 완전 기대돼요!',
    ],
  };

  /// 일상 활동 목록
  static const List<String> dailyActivities = [
    '유튜브 보기',
    '넷플릭스 정주행',
    '음악 듣기',
    '책 읽기',
    '게임',
    '요리',
    '운동',
    '산책',
    '커피 마시기',
    '친구랑 카톡',
    '웹툰 보기',
    '인스타 구경',
    '낮잠',
    '청소',
    '공부',
    '일',
    '영화 보기',
    '쇼핑',
    '맛집 검색',
    '일기 쓰기',
  ];

  /// 장소 목록
  static const List<String> locations = [
    '집',
    '카페',
    '회사',
    '학교',
    '도서관',
    '헬스장',
    '친구 집',
    '버스',
    '지하철',
    '공원',
    '편의점',
    '마트',
    '식당',
    '영화관',
    '백화점',
  ];

  /// 자연스러운 전환 표현
  static const List<String> transitionPhrases = [
    '아 그러고보니',
    '아 맞다',
    '갑자기 생각났는데',
    '말 나온 김에',
    '그거 얘기하니까',
    '근데 있잖아',
    '아 참',
    '그런 것처럼',
    '그래서 말인데',
    '어쨌든',
  ];

  /// 대화 시작 인사말 (시간대별)
  static const Map<String, List<String>> greetingsWithIcebreaker = {
    'morning': [
      '좋은 아침!! 잘 잤어?ㅎㅎ',
      '굿모닝~~ 아침 먹었어?',
      '안녕!! 오늘 일찍 일어났네ㅎㅎ',
      '좋은 아침~ 날씨 완전 좋지 않아??',
      '하이하이!! 꿈은 안 꿨어?ㅎㅎ',
    ],
    'afternoon': [
      '안녕!! 점심은 먹었어?ㅎㅎ',
      '하이~~ 오늘 바빴어?',
      '반가워!! 날씨 완전 좋지??ㅎㅎ',
      '안녕안녕~~ 오늘 어떻게 지냈어?',
      '헬로!! 피곤하지 않아?ㅎㅎ',
    ],
    'evening': [
      '안녕!! 저녁 먹었어?ㅎㅎ',
      '하이~~ 오늘 하루 어땠어?',
      '반가워!! 퇴근했어?ㅎㅎ',
      '안녕~~ 오늘 고생 많았지?',
      '헬로헬로!! 피곤하지 않아?ㅎㅎ',
    ],
    'night': [
      '안녕!! 아직 안 잤네?ㅎㅎ',
      '하이~~ 늦었는데 뭐하고 있었어?',
      '반가워!! 내일 일찍 일어나야 해?ㅎㅎ',
      '안녕~~ 밤에 잠이 안 와?',
      '헬로!! 야식 먹었어?ㅋㅋ',
    ],
  };

  /// 반응 표현
  static const Map<String, List<String>> reactions = {
    'agree': [
      '맞아요 맞아요!',
      '저도 그렇게 생각해요',
      '인정ㅋㅋ',
      '그러니까요!',
      '완전 공감해요',
      '나도 나도!',
      '진짜 그래요',
      '완전 인정!',
    ],
    'surprise': [
      '헐 진짜요??',
      '와 대박!',
      '어머 진짜?',
      '헉 몰랐어요!',
      '와 신기하다!',
      '진짜??',
      '에?? 대박',
      '헐 처음 알았어요',
    ],
    'interest': [
      '오 그래요?',
      '재밌네요ㅎㅎ',
      '와 신기해요!',
      '오호~ 그렇구나',
      '흥미롭네요!',
      '오 재밌다!',
      '더 얘기해줘요!',
      '진짜 신기하네',
    ],
    'understand': [
      '아~ 그렇구나',
      '이해했어요!',
      '아하 그런 거였어요',
      '음음 알겠어요',
      '오케이 이해했어요!',
      '아 그래서 그랬구나',
      '이제 알겠어요',
      '아하!',
    ],
    'empathy': [
      '저도 그래요!',
      '나도 그런 적 있어요',
      '완전 이해해요',
      '저도 똑같아요',
      '나도 그럴 것 같아요',
      '진짜 공감돼요',
      '나라도 그랬을 거예요',
      '완전 제 얘기네요',
    ],
  };

  /// 감정 키워드 사전
  static const Map<String, List<String>> emotionKeywords = {
    'happy': ['좋아', '행복', '기뻐', '신나', '최고', '짱', '대박', '굿', '만족', '웃', 'ㅎㅎ', 'ㅋㅋ'],
    'sad': ['슬퍼', '우울', '눈물', '힘들', '외로', '쓸쓸', '그리워', '보고싶', 'ㅠㅠ', 'ㅜㅜ'],
    'angry': ['화나', '짜증', '열받', '빡치', '싫어', '미치', '답답', '억울'],
    'tired': ['피곤', '지쳐', '힘들', '졸려', '못하겠', '지침', '기진맥진'],
    'worried': ['걱정', '불안', '무서', '두려', '긴장', '떨려', '고민'],
    'excited': ['기대', '설레', '두근', '신나', '흥분', '들뜨'],
  };

  /// 감정 감지 함수
  static String? detectEmotion(String message) {
    final lower = message.toLowerCase();
    
    for (final entry in emotionKeywords.entries) {
      for (final keyword in entry.value) {
        if (lower.contains(keyword)) {
          return entry.key;
        }
      }
    }
    
    return null;
  }

  /// 시간대 감지 함수
  static String getTimeOfDay() {
    final hour = DateTime.now().hour;
    
    if (hour >= 5 && hour < 12) {
      return 'morning';
    } else if (hour >= 12 && hour < 17) {
      return 'afternoon';
    } else if (hour >= 17 && hour < 21) {
      return 'evening';
    } else {
      return 'night';
    }
  }

  /// 랜덤 선택 헬퍼
  static T getRandomItem<T>(List<T> items) {
    if (items.isEmpty) return items.first;
    return items[DateTime.now().millisecond % items.length];
  }

  /// 랜덤 공감 표현 가져오기
  static String? getEmpathyResponse(String? emotion) {
    if (emotion == null || !empathyResponses.containsKey(emotion)) {
      return null;
    }
    
    final responses = empathyResponses[emotion]!;
    return getRandomItem(responses);
  }

  /// 랜덤 반응 가져오기
  static String? getReaction(String type) {
    if (!reactions.containsKey(type)) {
      return null;
    }
    
    final reactionList = reactions[type]!;
    return getRandomItem(reactionList);
  }

  /// 시간대별 인사말 가져오기
  static String getGreeting() {
    final timeOfDay = getTimeOfDay();
    final greetings = greetingsWithIcebreaker[timeOfDay]!;
    return getRandomItem(greetings);
  }
}