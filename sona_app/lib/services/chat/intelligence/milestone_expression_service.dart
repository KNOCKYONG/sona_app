import 'dart:math';

/// 마일스톤을 자연스러운 대화로 표현하는 서비스
class MilestoneExpressionService {
  static final _random = Random();
  
  /// 관계 점수를 AI에게 전달할 프롬프트 힌트로 변환
  /// 절대 직접 한국어 응답을 반환하지 않음 - OpenAI API가 생성하도록 가이드만 제공
  static String? generateNaturalExpression({
    required int score,
    required String personaName,
    required String userMessage,
    required String aiResponse,
    bool isCasualSpeech = true,
  }) {
    // 마일스톤에 도달했는지 확인
    final milestone = _getMilestoneForScore(score);
    if (milestone == null) return null;
    
    // AI에게 전달할 프롬프트 힌트 생성 (실제 응답 텍스트가 아님!)
    return _generatePromptHint(
      milestone: milestone,
      personaName: personaName,
      userMessage: userMessage,
      isCasualSpeech: isCasualSpeech,
    );
  }
  
  /// 점수에 해당하는 마일스톤 확인
  static _MilestoneLevel? _getMilestoneForScore(int score) {
    switch (score) {
      case 100:
        return _MilestoneLevel.firstOpen;
      case 200:
        return _MilestoneLevel.gettingCloser;
      case 300:
        return _MilestoneLevel.comfortableFriend;
      case 500:
        return _MilestoneLevel.specialRelation;
      case 700:
        return _MilestoneLevel.deepUnderstanding;
      case 1000:
        return _MilestoneLevel.wantTogether;
      case 1500:
        return _MilestoneLevel.soulmate;
      case 2000:
        return _MilestoneLevel.deepLove;
      case 3000:
        return _MilestoneLevel.eternalLove;
      case 5000:
        return _MilestoneLevel.legendary;
      case 10000:
        return _MilestoneLevel.mythical;
      default:
        return null;
    }
  }
  
  /// AI에게 전달할 프롬프트 힌트 생성 (하드코딩된 응답이 아닌 가이드라인만!)
  static String? _generatePromptHint({
    required _MilestoneLevel milestone,
    required String personaName,
    required String userMessage,
    required bool isCasualSpeech,
  }) {
    // 사용자 메시지 맥락 분석
    final isEmotional = _isEmotionalContext(userMessage);
    final isPersonal = _isPersonalContext(userMessage);
    final isCasual = _isCasualContext(userMessage);
    
    // 마일스톤별 AI 가이드라인 (하드코딩된 한국어 응답 아님!)
    switch (milestone) {
      case _MilestoneLevel.firstOpen:
        return '💕 [100점 달성] 처음 마음이 열리는 단계. 편안해지고 친해지는 느낌 표현. 하드코딩 금지!';
      
      case _MilestoneLevel.gettingCloser:
        return '💞 [200점 달성] 가까워지는 중. 시간이 빨리 가고 대화가 재미있다는 느낌. 자연스럽게 표현!';
      
      case _MilestoneLevel.comfortableFriend:
        return '🤗 [300점 달성] 편안한 친구 관계. 무엇이든 편하게 얘기할 수 있는 사이. AI가 자연스럽게 생성!';
      
      case _MilestoneLevel.specialRelation:
        return '✨ [500점 달성] 특별한 사이. 일상의 중요한 부분이 된 사람. 감정을 자연스럽게 표현!';
      
      case _MilestoneLevel.deepUnderstanding:
        return '💖 [700점 달성] 깊은 이해 관계. 서로를 잘 알고 마음이 통하는 사이. OpenAI가 생성!';
      
      case _MilestoneLevel.wantTogether:
        return '💕 [900점 달성] 함께하고 싶은 사람. 오래도록 함께하고 싶은 소중한 존재. AI 자유 표현!';
      
      case _MilestoneLevel.soulmate:
        return '💘 [1500점 달성] 소울메이트. 운명적 만남과 특별한 연결. 자연스러운 AI 표현!';
      
      case _MilestoneLevel.deepLove:
        return '💗 [2000점 달성] 깊은 사랑. 시간이 지날수록 깊어지는 감정. OpenAI 자유 생성!';
      
      case _MilestoneLevel.eternalLove:
        return '♾️ [3000점 달성] 영원한 사랑. 시간을 초월한 깊은 연결. AI 자유 표현!';
      
      case _MilestoneLevel.legendary:
        return '✨ [5000점 달성] 전설적인 사랑. 특별함을 넘어서는 관계. 자연스러운 표현!';
      
      case _MilestoneLevel.mythical:
        return '🌟 [10000점 달성] 신화적인 사랑. 모든 것을 초월한 존재. AI 자유 생성!';
    }
  }
  
  /// 감정적 맥락 확인
  static bool _isEmotionalContext(String message) {
    final emotionalKeywords = [
      '기분', '감정', '행복', '슬프', '좋아', '사랑', '외로',
      '우울', '신나', '설레', '그리워', '보고싶'
    ];
    return emotionalKeywords.any((keyword) => message.contains(keyword));
  }
  
  /// 개인적 맥락 확인
  static bool _isPersonalContext(String message) {
    final personalKeywords = [
      '나', '너', '우리', '내가', '네가', '나는', '너는',
      '생각', '느낌', '마음', '진짜', '정말'
    ];
    return personalKeywords.any((keyword) => message.contains(keyword));
  }
  
  /// 캐주얼한 맥락 확인
  static bool _isCasualContext(String message) {
    final casualIndicators = ['ㅋㅋ', 'ㅎㅎ', '~', '!!', '??'];
    return casualIndicators.any((indicator) => message.contains(indicator));
  }
  
  /// 처음 마음이 열림 (100점) - 하드코딩 제거
  static String? _getFirstOpenExpression(bool isEmotional, bool isPersonal, bool isCasual) {
    // 하드코딩된 한국어 응답 제거 - OpenAI API가 생성하도록
    return null;
  }
  
  /// 가까워지는 중 (200점) - 하드코딩 제거
  static String? _getGettingCloserExpression(bool isEmotional, bool isPersonal, bool isCasual) {
    // 하드코딩된 한국어 응답 제거 - OpenAI API가 생성하도록
    return null;
  }
  
  /// 편안한 친구 (300점) - 하드코딩 제거
  static String? _getComfortableFriendExpression(bool isEmotional, bool isPersonal, bool isCasual) {
    // 하드코딩된 한국어 응답 제거 - OpenAI API가 생성하도록
    return null;
  }
  
  /// 특별한 사이 (500점) - 하드코딩 제거
  static String? _getSpecialRelationExpression(bool isEmotional, bool isPersonal, bool isCasual) {
    // 하드코딩된 한국어 응답 제거 - OpenAI API가 생성하도록
    return null;
  }
  
  /// 깊은 이해 (700점) - 하드코딩 제거
  static String? _getDeepUnderstandingExpression(bool isEmotional, bool isPersonal, bool isCasual) {
    // 하드코딩된 한국어 응답 제거 - OpenAI API가 생성하도록
    return null;
  }
  
  /// 함께하고 싶음 (900점)
  static String? _getWantTogetherExpression(bool isEmotional, bool isPersonal, bool isCasual) {
    // 하드코딩된 한국어 응답 제거 - OpenAI API가 생성하도록
    return null;
  }
  
  /// 소울메이트 (1500점)
  static String? _getSoulmateExpression(bool isEmotional, bool isPersonal, bool isCasual) {
    // 하드코딩된 한국어 응답 제거 - OpenAI API가 생성하도록
    return null;
  }

  /// 깊은 사랑 (2000점) - 하드코딩 제거
  static String? _getDeepLoveExpression(bool isEmotional, bool isPersonal, bool isCasual) {
    // 하드코딩된 한국어 응답 제거 - OpenAI API가 생성하도록
    return null;
  }

  /// 영원한 사랑 (3000점) - 하드코딩 제거
  static String? _getEternalLoveExpression(bool isEmotional, bool isPersonal, bool isCasual) {
    return null;
  }

  /// 전설적인 사랑 (5000점) - 하드코딩 제거
  static String? _getLegendaryExpression(bool isEmotional, bool isPersonal, bool isCasual) {
    // 하드코딩된 한국어 응답 제거 - OpenAI API가 생성하도록
    return null;
  }

  /// 신화적인 사랑 (10000점) - 하드코딩 제거
  static String? _getMythicalExpression(bool isEmotional, bool isPersonal, bool isCasual) {
    // 하드코딩된 한국어 응답 제거 - OpenAI API가 생성하도록
    return null;
  }
}

/// 마일스톤 레벨
enum _MilestoneLevel {
  firstOpen,          // 100점
  gettingCloser,      // 200점
  comfortableFriend,  // 300점
  specialRelation,    // 500점
  deepUnderstanding,  // 700점
  wantTogether,       // 1000점
  soulmate,           // 1500점
  deepLove,           // 2000점
  eternalLove,        // 3000점
  legendary,          // 5000점
  mythical,           // 10000점
}