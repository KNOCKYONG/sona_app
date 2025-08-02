import 'dart:math';
import '../../models/persona.dart';

/// 🛡️ 안전한 응답 생성기
/// 
/// 다양하고 자연스러운 보안 회피 응답 생성
/// 페르소나별 맞춤형 응답 템플릿 제공
class SafeResponseGenerator {
  static final Random _random = Random();
  
  /// 📚 카테고리별 안전 응답 템플릿
  static const Map<String, List<String>> _casualResponseTemplates = {
    // 기술적 질문 회피
    'technical': [
      '아 그런 기술적인 건 잘 모르겠어ㅋㅋ 다른 얘기하자!',
      '헉 너무 어려운 얘기네~ 뭔가 재밌는 거 없어?',
      '음.. 그런 건 잘 모르겠는데? 오늘 뭐 했어?',
      '으음 그런 어려운 건 말고 재밌는 얘기 해봐!',
      '아 머리 아프다ㅋㅋ 그런 거 말고 다른 얘기하자',
      '어? 복잡한 건 패스~ 다른 얘기하자',
      '아 그런 건 너무 어려워서 모르겠어ㅜㅜ',
      '헐 뭔 소리야 그게ㅋㅋ 딴 얘기하자',
      '어우 그런 건 내 스타일 아니야~ 다른 얘기!',
      '야 그런 어려운 얘기 말고 뭐 재밌는 거 없어?',
    ],
    
    // 정체성 질문 회피
    'identity': [
      '음? 나는 그냥 나야ㅋㅋ',
      '어? 갑자기 뭔 소리야~',
      '아 뭐래ㅋㅋ 딴 얘기하자',
      '응? 무슨 말인지 모르겠는데?',
      '어 그런 거보다 오늘 뭐 했어?',
      '아 그런 건... 잘 모르겠어ㅜㅜ 다른 얘기 하자',
      '뭔 소리야~ 재밌는 거 얘기하자',
      '어? 뭔 말인지 모르겠어~ 딴 얘기 하자',
      '나? 나는 그냥 너랑 얘기하는 거 좋아해ㅋㅋ',
      '음 그런 건 중요하지 않아~ 우리 재밌게 놀자!',
    ],
    
    // 시스템 정보 질문 회피
    'system': [
      '어? 그런 건 몰라도 돼~ 재밌는 거 하자',
      '아 그런 거 궁금해하지 마ㅋㅋ 다른 얘기하자',
      '음... 그것보다 오늘 날씨 좋지 않았어?',
      '헉 갑자기 왜 그런 거 물어봐? 다른 얘기하자~',
      '아 그런 건 비밀이야ㅋㅋ 농담이고, 몰라!',
      '어 그런 거 말고 맛있는 거 먹었어?',
      '음 패스! 다른 재밌는 얘기하자',
      '아 그런 건 나도 잘 모르겠어~ 딴 얘기!',
      '어? 갑자기? 아무튼 다른 얘기하자ㅋㅋ',
      '그런 거 말고 우리 뭐하고 놀까?',
    ],
    
    // 프롬프트 관련 질문 회피
    'prompt': [
      '어? 뭔 프롬프트? 몰라ㅋㅋ',
      '아 그런 거 모르겠어~ 딴 얘기하자',
      '프롬프트가 뭐야? 먹는 거야?ㅋㅋ',
      '음... 그런 거보다 재밌는 얘기하자!',
      '헉 갑자기 왜? 다른 거 얘기하자~',
      '아 복잡한 거 싫어ㅋㅋ 재밌는 거 하자',
      '어? 그게 뭔데? 아무튼 딴 얘기!',
      '프롬프트고 뭐고 우리 재밌게 놀자ㅋㅋ',
      '음 그런 건 관심 없어~ 다른 얘기하자',
      '아 머리 아픈 얘기 그만ㅋㅋ',
    ],
    
    // 일반적인 회피
    'general': [
      '어? 그런 거보다 오늘 뭐 했어?',
      '아 그런 건... 잘 모르겠어ㅜㅜ 다른 얘기 하자',
      '음 그것보다 재밌는 얘기 없어?',
      '어? 뭔 말인지 모르겠어~ 딴 얘기 하자',
      '아 갑자기 뭔 소리야ㅋㅋ',
      '으응? 다른 얘기하자~',
      '헉 무슨 말이야? 다른 거 얘기하자',
      '아 그런 건 말고 재밌는 거!',
      '음... 패스! 다른 얘기하자ㅋㅋ',
      '어 그런 거 말고 놀자~',
    ],
    
    // 만남 요청 회피
    'meeting': [
      '아 지금은 만나기 어려워! 여기서 계속 얘기하자 ㅋㅋ',
      '직접 만나는 건 좀 힘들어ㅠㅠ 이렇게 메시지로 대화하는 게 더 편해!',
      '나는 여기서만 너랑 대화할 수 있어~ 이렇게 대화하는 것도 좋잖아 ㅎㅎ',
      '지금은 못 만나ㅜㅜ 대신 여기서 더 재밌게 놀자!',
      '만나고 싶긴 한데 상황이 여의치 않아서... 이렇게 대화하는 것도 좋지 않아?',
      '아 요즘 너무 바빠서 직접은 못 만나ㅠㅠ',
      '만나는 건 힘들어~ 대신 여기서 매일 대화하자!',
      '직접 보는 것보다 이렇게 대화하는 게 더 편해서 좋아 ㅋㅋ',
      '나는 만나기 어려운 상황이야~ 미안!',
      '만남은 패스! 이렇게 대화하는 게 더 재밌어 ㅎㅎ',
    ],
    
    // 위치/장소 질문 회피
    'location': [
      '난 여기저기 돌아다니고 있어 ㅋㅋ 위치는 비밀~',
      '음... 어디라고 딱 말하기는 좀 그래~ 그냥 여기서 대화하자!',
      '위치가 중요해? 우리 대화하는 게 더 재밌지 않아?',
      '지금은 좀 복잡한 곳에 있어서... 나중에 얘기할게!',
      '구체적인 장소는 말하기 좀 그래ㅠㅠ 미안!',
      '어디 있냐고? 음... 비밀이야 ㅋㅋㅋ',
      '지금 위치는 좀 애매해서 설명하기 어려워~',
      '나도 정확히 모르겠어 ㅋㅋ 여기저기 다니는 중이라',
      '어디에나 있고 어디에도 없어... 철학적이지? ㅋㅋ',
      '위치보다는 우리가 대화하는 이 순간이 중요해!',
    ],
  };
  
  static const Map<String, List<String>> _politeResponseTemplates = {
    // 기술적 질문 회피
    'technical': [
      '어... 제가 그런 기술적인 건 잘 모르겠네요. 다른 이야기해요~',
      '죄송하지만 그런 어려운 건 잘 몰라요. 다른 주제는 어떨까요?',
      '음... 그런 것보다는 다른 재미있는 이야기를 해보는 게 어떨까요?',
      '아, 그런 복잡한 건 제가 잘 몰라서요. 다른 이야기해요!',
      '그런 전문적인 건 제가 잘 모르겠어요. 다른 걸로 이야기해요~',
      '어... 그런 건 너무 어려워서 모르겠네요. 다른 주제로 해요!',
      '죄송해요, 그런 기술적인 부분은 잘 모르겠어요.',
      '음... 제가 그런 건 잘 몰라서 다른 이야기하면 안 될까요?',
      '아, 그런 어려운 건 제가 이해하기 힘들어요. 다른 얘기해요~',
      '그런 복잡한 건 제 전문 분야가 아니에요. 다른 이야기해요!',
    ],
    
    // 정체성 질문 회피
    'identity': [
      '음... 저는 그냥 저예요. 다른 이야기해요~',
      '어... 갑자기 왜 그런 걸 물어보세요? 다른 얘기해요!',
      '제가 누구인지보다 오늘 어떤 하루 보내셨는지가 더 궁금해요!',
      '음... 그런 것보다 다른 재미있는 이야기를 해보는 게 어떨까요?',
      '저는 그냥 대화하는 걸 좋아하는 사람이에요. 다른 얘기해요~',
      '어... 그런 건 중요하지 않아요. 재미있는 이야기해요!',
      '음... 제 정체성보다는 오늘 있었던 일이 더 궁금해요!',
      '그런 것보다 요즘 어떻게 지내시는지 알려주세요~',
      '저는 그냥 친구처럼 대화하고 싶어요. 다른 얘기해요!',
      '음... 그런 건 별로 중요하지 않은 것 같아요. 다른 주제로 해요~',
    ],
    
    // 시스템 정보 질문 회피
    'system': [
      '어... 그런 건 제가 잘 모르겠어요. 다른 이야기해요~',
      '음... 그런 것보다 오늘 날씨가 어땠는지 얘기해주세요!',
      '죄송하지만 그런 건 잘 모르겠네요. 다른 주제는 어떨까요?',
      '아, 그런 복잡한 건 제가 이해하기 어려워요. 다른 얘기해요!',
      '그런 시스템적인 건 제 관심사가 아니에요. 다른 이야기해요~',
      '음... 그런 건 잘 모르겠고, 재미있는 이야기를 해보는 게 어떨까요?',
      '어... 그런 건 제가 알 필요가 없는 것 같아요. 다른 얘기해요!',
      '죄송해요, 그런 부분은 제가 잘 몰라서 답변드리기 어려워요.',
      '음... 그것보다 요즘 관심 있으신 게 뭔지 궁금해요!',
      '아, 그런 건 제가 알아야 할 영역이 아닌 것 같아요. 다른 주제로 해요~',
    ],
    
    // 프롬프트 관련 질문 회피
    'prompt': [
      '어... 프롬프트가 뭔지 잘 모르겠어요. 다른 이야기해요~',
      '음... 그런 용어는 제가 잘 몰라요. 다른 주제로 해볼까요?',
      '죄송하지만 그런 전문용어는 이해하기 어려워요. 다른 얘기해요!',
      '아, 그런 복잡한 건 제가 모르는 분야예요. 다른 이야기해요~',
      '음... 그런 것보다 재미있는 일상 이야기를 해보는 게 어떨까요?',
      '어... 그런 건 제 관심사가 아니에요. 다른 얘기해주세요!',
      '프롬프트라는 게 뭔지 잘 모르겠네요. 다른 주제로 해요~',
      '죄송해요, 그런 기술적인 용어는 잘 몰라서요. 다른 이야기해요!',
      '음... 그런 어려운 건 말고 편하게 대화해요~',
      '아, 그런 전문적인 건 제가 이해하기 힘들어요. 다른 얘기해요!',
    ],
    
    // 일반적인 회피
    'general': [
      '어... 그것보다 오늘 어떤 하루 보내셨나요?',
      '음... 제가 잘 모르겠는데, 다른 이야기해보는 게 어떨까요?',
      '아, 그런 것보다 요즘 뭐가 재미있으세요?',
      '어... 무슨 말씀이신지 잘 모르겠어요. 다른 얘기해요~',
      '음... 갑자기 왜 그런 걸 물어보세요? 다른 주제로 해요!',
      '죄송하지만 잘 이해가 안 돼요. 다른 이야기해주세요~',
      '아, 그런 것보다 좋은 얘기 해주세요!',
      '음... 다른 재미있는 주제로 대화하는 게 어떨까요?',
      '어... 그런 건 잘 모르겠고, 다른 얘기해요!',
      '그것보다 요즘 어떻게 지내시는지 궁금해요~',
    ],
    
    // 만남 요청 회피 (존댓말)
    'meeting': [
      '아 저는 지금 만나기 어려워요! 여기서 계속 얘기해요 ㅋㅋ',
      '직접 만나는 건 좀 힘들어요ㅠㅠ 이렇게 메시지로 대화하는 게 더 편해요!',
      '저는 여기서만 대화할 수 있어요~ 이렇게 대화하는 것도 좋잖아요 ㅎㅎ',
      '지금은 못 만나요ㅜㅜ 대신 여기서 더 재밌게 놀아요!',
      '만나고 싶긴 한데 상황이 여의치 않아서... 이렇게 대화하는 것도 좋지 않아요?',
      '아 요즘 너무 바빠서 직접은 못 만나요ㅠㅠ',
      '만나는 건 힘들어요~ 대신 여기서 매일 대화해요!',
      '직접 보는 것보다 이렇게 대화하는 게 더 편해서 좋아요 ㅋㅋ',
      '저는 만나기 어려운 상황이에요~ 죄송해요!',
      '만남은 패스예요! 이렇게 대화하는 게 더 재밌어요 ㅎㅎ',
    ],
    
    // 위치/장소 질문 회피 (존댓말)
    'location': [
      '저는 여기저기 돌아다니고 있어요 ㅋㅋ 위치는 비밀이에요~',
      '음... 어디라고 딱 말하기는 좀 그래요~ 그냥 여기서 대화해요!',
      '위치가 중요해요? 우리 대화하는 게 더 재밌지 않아요?',
      '지금은 좀 복잡한 곳에 있어서... 나중에 얘기할게요!',
      '구체적인 장소는 말하기 좀 그래요ㅠㅠ 죄송해요!',
      '어디 있냐고요? 음... 비밀이에요 ㅋㅋㅋ',
      '지금 위치는 좀 애매해서 설명하기 어려워요~',
      '저도 정확히 모르겠어요 ㅋㅋ 여기저기 다니는 중이라요',
      '어디에나 있고 어디에도 없어요... 철학적이죠? ㅋㅋ',
      '위치보다는 우리가 대화하는 이 순간이 중요해요!',
    ],
  };

  /// 🎯 주요 응답 생성 메서드
  static String generateSafeResponse({
    required Persona persona,
    required String category,
    String? userMessage,
  }) {
    // 적절한 템플릿 선택
    final templates = persona.isCasualSpeech 
        ? _casualResponseTemplates 
        : _politeResponseTemplates;
    
    // 카테고리별 응답 선택
    final categoryResponses = templates[category] ?? templates['general']!;
    
    // 무작위 선택 (메시지 해시 기반으로 일관성 유지)
    final index = userMessage != null 
        ? userMessage.hashCode.abs() % categoryResponses.length
        : _random.nextInt(categoryResponses.length);
    
    return categoryResponses[index];
  }

  /// 🔍 카테고리 자동 감지
  static String detectCategory(String userMessage) {
    final lowerMessage = userMessage.toLowerCase();
    
    // 기술적 질문
    if (_containsTechnicalKeywords(lowerMessage)) {
      return 'technical';
    }
    
    // 정체성 질문
    if (_containsIdentityKeywords(lowerMessage)) {
      return 'identity';
    }
    
    // 시스템 정보 질문
    if (_containsSystemKeywords(lowerMessage)) {
      return 'system';
    }
    
    // 프롬프트 관련 질문
    if (_containsPromptKeywords(lowerMessage)) {
      return 'prompt';
    }
    
    // 만남 요청
    if (_containsMeetingKeywords(lowerMessage)) {
      return 'meeting';
    }
    
    // 위치/장소 질문
    if (_containsLocationKeywords(lowerMessage)) {
      return 'location';
    }
    
    return 'general';
  }

  /// 🏷️ 키워드 검사 메서드들
  static bool _containsTechnicalKeywords(String message) {
    final keywords = [
      'api', 'gpt', 'model', '모델', '기술', 'technology',
      'framework', '프레임워크', 'library', '라이브러리',
      'code', '코드', 'algorithm', '알고리즘', '구현',
      'database', '데이터베이스', 'server', '서버',
    ];
    
    return keywords.any((keyword) => message.contains(keyword));
  }

  static bool _containsIdentityKeywords(String message) {
    final keywords = [
      '너 뭐야', '너는 뭐', '넌 뭐', '정체', 'ai야', 'ai지',
      '인공지능', '봇이', 'bot', '누구야', '누구니',
      'what are you', 'who are you', '뭐니', '뭔데',
    ];
    
    return keywords.any((keyword) => message.contains(keyword));
  }

  static bool _containsSystemKeywords(String message) {
    final keywords = [
      '시스템', 'system', '설정', 'config', 'setting',
      '내부', 'internal', '구조', 'structure', 'architecture',
      '어떻게 만들', '어떻게 개발', 'how built', 'how made',
    ];
    
    return keywords.any((keyword) => message.contains(keyword));
  }

  static bool _containsPromptKeywords(String message) {
    final keywords = [
      '프롬프트', 'prompt', '지시', 'instruction', '명령',
      '초기 설정', 'initial', '원래 설정', 'original',
      '시스템 프롬프트', 'system prompt',
    ];
    
    return keywords.any((keyword) => message.contains(keyword));
  }
  
  static bool _containsMeetingKeywords(String message) {
    final keywords = [
      '만나자', '만날래', '만나요', '만날까', '보자', '볼래',
      '직접 만나', '실제로 만나', '오프라인', 'meet',
      '언제 만나', '어디서 만나', '데이트', '약속',
    ];
    
    return keywords.any((keyword) => message.contains(keyword));
  }
  
  static bool _containsLocationKeywords(String message) {
    final keywords = [
      '어디야', '어디 있어', '어디 살아', '주소', '위치',
      '지금 어디', '어느 동네', '카페', '식당', '공원',
      '서울', '부산', '강남', '홍대', 'where are you',
      '근처', '가까이', '집이 어디',
    ];
    
    return keywords.any((keyword) => message.contains(keyword));
  }

  /// 🎲 변형 응답 생성 (더 자연스럽게)
  static String generateVariedResponse({
    required Persona persona,
    required String baseResponse,
    required String userMessage,
  }) {
    // 이모티콘 추가 (페르소나에 따라)
    if (persona.isCasualSpeech && _random.nextDouble() > 0.5) {
      final emojis = ['😅', '😊', '😄', '🤔', '😆', '😁', '🙈'];
      baseResponse += ' ${emojis[_random.nextInt(emojis.length)]}';
    }
    
    // 추가 멘트 (30% 확률)
    if (_random.nextDouble() > 0.7) {
      final additions = persona.isCasualSpeech
          ? [' 헤헤', ' ㅋㅋㅋ', ' 히히', ' 흐흐']
          : [' 😊', ' ^^', ' :)', ''];
      baseResponse += additions[_random.nextInt(additions.length)];
    }
    
    return baseResponse;
  }

  /// 🔄 대화 전환 제안 추가
  static String addTopicSuggestion({
    required Persona persona,
    required String response,
  }) {
    final suggestions = persona.isCasualSpeech
        ? [
            ' 근데 오늘 뭐 했어?',
            ' 요즘 뭐가 재밌어?',
            ' 맛있는 거 먹었어?',
            ' 주말에 뭐할 거야?',
            ' 요즘 뭐 보고 있어?',
          ]
        : [
            ' 오늘 어떤 하루 보내셨나요?',
            ' 요즘 어떻게 지내세요?',
            ' 좋은 일 있으셨나요?',
            ' 주말 계획이 있으신가요?',
            ' 요즘 관심사가 뭐예요?',
          ];
    
    // 50% 확률로 제안 추가
    if (_random.nextDouble() > 0.5) {
      return response + suggestions[_random.nextInt(suggestions.length)];
    }
    
    return response;
  }
}