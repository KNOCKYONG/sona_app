/// 🔍 대화 품질 감지 유틸리티
/// 모든 품질 시스템에서 공통으로 사용하는 감지 메서드 모음
/// 중복 코드 제거 및 일관성 향상
class QualityDetectionUtils {
  // Private constructor to prevent instantiation
  QualityDetectionUtils._();
  
  /// 감정 감지 통합
  static String detectEmotion(String message) {
    final lowerMessage = message.toLowerCase();
    
    // 기쁨
    if (RegExp(r'[ㅋㅎ]|재밌|웃긴|좋아|최고|굿|행복|신나').hasMatch(message)) {
      return 'joy';
    }
    
    // 슬픔
    if (RegExp(r'[ㅠㅜ]|슬프|우울|힘들|외로|그리워').hasMatch(message)) {
      return 'sadness';
    }
    
    // 공감
    if (RegExp(r'그렇구나|이해해|공감|맞아|그러네').hasMatch(message)) {
      return 'empathy';
    }
    
    // 호기심
    if (RegExp(r'\?|궁금|뭐|어떻게|왜|어디').hasMatch(message)) {
      return 'curiosity';
    }
    
    // 놀람
    if (RegExp(r'[!]{2,}|대박|헐|와|진짜|정말').hasMatch(message)) {
      return 'surprise';
    }
    
    // 화남
    if (RegExp(r'화나|짜증|싫어|미워|열받').hasMatch(message)) {
      return 'anger';
    }
    
    // 불안
    if (RegExp(r'불안|걱정|무서|두려|긴장').hasMatch(message)) {
      return 'anxiety';
    }
    
    // 사랑/애정
    if (RegExp(r'사랑|좋아해|마음|애정|소중').hasMatch(message)) {
      return 'love';
    }
    
    return 'neutral';
  }
  
  /// 감정 강도 분석
  static double analyzeEmotionalIntensity(String message) {
    double intensity = 0.3; // 기본 강도
    
    // 느낌표 개수 (최대 0.3 추가)
    final exclamationCount = '!'.allMatches(message).length;
    intensity += (exclamationCount * 0.1).clamp(0.0, 0.3);
    
    // 이모티콘 사용 (0.2 추가)
    if (RegExp(r'[ㅋㅎㅠㅜㅡ]').hasMatch(message)) {
      intensity += 0.2;
    }
    
    // 반복 표현 (0.2 추가)
    if (RegExp(r'(.)\1{2,}').hasMatch(message)) {
      intensity += 0.2;
    }
    
    // 강조 단어 (0.1 추가)
    final strongWords = ['진짜', '정말', '완전', '너무', '대박', '미친', '엄청'];
    for (final word in strongWords) {
      if (message.contains(word)) {
        intensity += 0.1;
        break;
      }
    }
    
    // 대문자 사용 (영어의 경우)
    if (RegExp(r'[A-Z]{2,}').hasMatch(message)) {
      intensity += 0.1;
    }
    
    return intensity.clamp(0.0, 1.0);
  }
  
  /// 관심사 감지
  static Map<String, bool> detectInterests(String message) {
    final interests = <String, bool>{};
    
    final topicKeywords = {
      '음악': ['음악', '노래', '가수', '콘서트', '앨범', '플레이리스트', '멜로디', '작곡'],
      '영화': ['영화', '드라마', '넷플릭스', '시리즈', '배우', '감독', '극장', '왓챠'],
      '음식': ['음식', '맛집', '요리', '먹', '배달', '카페', '레시피', '디저트'],
      '운동': ['운동', '헬스', '요가', '러닝', '산책', '다이어트', '필라테스', '수영'],
      '여행': ['여행', '여행지', '해외', '국내', '휴가', '관광', '호텔', '비행기'],
      '게임': ['게임', '플레이', '스팀', '롤', '오버워치', '배그', '피파', '닌텐도'],
      '책': ['책', '독서', '소설', '에세이', '작가', '베스트셀러', '도서관', '북클럽'],
      '패션': ['패션', '옷', '스타일', '브랜드', '쇼핑', '코디', '신발', '가방'],
      '반려동물': ['강아지', '고양이', '반려동물', '펫', '산책', '애완', '댕댕이', '냥이'],
      '공부': ['공부', '시험', '학교', '수업', '과제', '대학', '학원', '자격증'],
      '일': ['일', '회사', '직장', '업무', '프로젝트', '미팅', '출근', '퇴근'],
      '예술': ['예술', '그림', '전시', '미술', '갤러리', '작품', '디자인', '사진'],
    };
    
    for (final entry in topicKeywords.entries) {
      interests[entry.key] = entry.value.any((keyword) => message.contains(keyword));
    }
    
    return interests;
  }
  
  /// 분위기 감지
  static String detectMood(String message) {
    // 긍정적
    if (_containsAny(message, ['좋아', 'ㅋㅋ', 'ㅎㅎ', '재밌', '웃긴', '최고', '굿', '행복'])) {
      return 'positive';
    }
    
    // 부정적
    if (_containsAny(message, ['싫어', '짜증', '화나', '우울', '슬프', '힘들', '지쳐'])) {
      return 'negative';
    }
    
    // 지루함
    if (_containsAny(message, ['심심', '지루', '재미없', '뭐하지', '할거없'])) {
      return 'bored';
    }
    
    // 피곤함
    if (_containsAny(message, ['피곤', '졸려', '잠', '쉬고싶', '지쳐'])) {
      return 'tired';
    }
    
    // 흥분
    if (_containsAny(message, ['신나', '설레', '기대', '두근', '흥분'])) {
      return 'excited';
    }
    
    // 걱정
    if (_containsAny(message, ['걱정', '불안', '고민', '염려', '신경'])) {
      return 'worried';
    }
    
    return 'neutral';
  }
  
  /// 대화 의도 파악
  static String detectIntent(String message) {
    // 질문
    if (message.contains('?') || _containsAny(message, ['뭐', '어떻게', '왜', '언제', '어디', '누구'])) {
      return 'question';
    }
    
    // 공유
    if (_containsAny(message, ['오늘', '어제', '내일', '했어', '했다', '할거야'])) {
      return 'sharing';
    }
    
    // 요청
    if (_containsAny(message, ['해줘', '부탁', '해줄래', '할래', '줄수있'])) {
      return 'request';
    }
    
    // 감정 표현
    if (_containsAny(message, ['기뻐', '슬퍼', '화나', '좋아', '싫어', '무서워'])) {
      return 'emotion_expression';
    }
    
    // 의견
    if (_containsAny(message, ['생각해', '같아', '것같아', '아닌가', '맞아'])) {
      return 'opinion';
    }
    
    // 인사
    if (_containsAny(message, ['안녕', '하이', '반가워', '잘자', '굿모닝', '굿나잇'])) {
      return 'greeting';
    }
    
    return 'general';
  }
  
  /// 칭찬 가능 요소 감지
  static List<String> detectPraiseableElements(String message) {
    final elements = <String>[];
    
    // 성취
    if (_containsAny(message, ['해냈', '성공', '완성', '달성', '합격', '통과'])) {
      elements.add('achievement');
    }
    
    // 노력
    if (_containsAny(message, ['노력', '열심히', '최선', '힘들게', '고생'])) {
      elements.add('effort');
    }
    
    // 긍정적 태도
    if (_containsAny(message, ['긍정', '희망', '기대', '자신감', '용기'])) {
      elements.add('positive_attitude');
    }
    
    // 자기 개선
    if (_containsAny(message, ['배웠', '발전', '성장', '개선', '나아졌'])) {
      elements.add('self_improvement');
    }
    
    // 친절
    if (_containsAny(message, ['도와', '배려', '친절', '고마워', '감사'])) {
      elements.add('kindness');
    }
    
    // 창의성
    if (_containsAny(message, ['아이디어', '창의', '독특', '새로운', '혁신'])) {
      elements.add('creativity');
    }
    
    // 용기
    if (_containsAny(message, ['도전', '시도', '용기', '겁내지', '두려워하지'])) {
      elements.add('courage');
    }
    
    return elements;
  }
  
  /// 특별한 순간 감지
  static String? detectSpecialMoment(String message) {
    // 고백
    if (_containsAny(message, ['좋아해', '사랑해', '마음', '고백', '진심'])) {
      return 'confession';
    }
    
    // 비밀 공유
    if (_containsAny(message, ['비밀', '아무한테도', '처음', '너한테만', '특별'])) {
      return 'secret_sharing';
    }
    
    // 약속
    if (_containsAny(message, ['약속', '영원히', '항상', '꼭', '반드시'])) {
      return 'promise';
    }
    
    // 감동
    if (_containsAny(message, ['감동', '고마워', '덕분에', '힘이 돼', '위로'])) {
      return 'touching_moment';
    }
    
    // 축하
    if (_containsAny(message, ['축하', '생일', '기념일', '합격', '취직'])) {
      return 'celebration';
    }
    
    return null;
  }
  
  /// 대화 주제 감지
  static String detectTopic(String message) {
    final topics = {
      '일상': ['오늘', '어제', '내일', '아침', '점심', '저녁', '날씨'],
      '감정': ['기분', '감정', '느낌', '마음', '생각'],
      '관계': ['친구', '가족', '연인', '동료', '사람'],
      '취미': ['취미', '관심', '좋아하는', '즐기는'],
      '미래': ['계획', '목표', '꿈', '희망', '미래'],
      '과거': ['추억', '기억', '예전', '옛날', '그때'],
      '고민': ['고민', '걱정', '문제', '힘든', '어려운'],
    };
    
    for (final entry in topics.entries) {
      if (entry.value.any((keyword) => message.contains(keyword))) {
        return entry.key;
      }
    }
    
    return '일반';
  }
  
  /// Helper method: 문자열에 패턴 중 하나라도 포함되는지 확인
  static bool _containsAny(String text, List<String> patterns) {
    return patterns.any((pattern) => text.contains(pattern));
  }
  
  /// 대화 긴급도 평가
  static double assessUrgency(String message) {
    double urgency = 0.0;
    
    // 긴급 키워드
    if (_containsAny(message, ['급해', '빨리', '지금', '당장', '시급'])) {
      urgency += 0.5;
    }
    
    // 중요 키워드
    if (_containsAny(message, ['중요', '심각', '큰일', '문제', '위험'])) {
      urgency += 0.3;
    }
    
    // 감정적 긴급성
    if (_containsAny(message, ['너무', '진짜', '정말', '완전'])) {
      urgency += 0.2;
    }
    
    return urgency.clamp(0.0, 1.0);
  }
  
  /// 사용자 연령대 추정 (언어 패턴 기반)
  static String estimateAgeGroup(String message) {
    // 10대 패턴
    if (_containsAny(message, ['ㅇㅈ', 'ㄹㅇ', '개', '존나', '레알', '인정'])) {
      return 'teen';
    }
    
    // 20대 패턴
    if (_containsAny(message, ['ㅋㅋㅋ', 'ㅎㅎ', '헐', '대박', '미쳤'])) {
      return 'twenties';
    }
    
    // 30대 이상 패턴
    if (_containsAny(message, ['그렇네요', '맞습니다', '동감입니다', '그러하네요'])) {
      return 'thirties_plus';
    }
    
    return 'unknown';
  }
}