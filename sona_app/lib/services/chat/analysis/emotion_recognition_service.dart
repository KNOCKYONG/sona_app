import 'package:flutter/material.dart';

/// 감정 인식 및 공감 서비스
class EmotionRecognitionService {
  /// 감정 분석 결과
  static EmotionAnalysis analyzeEmotion(String message) {
    final lower = message.toLowerCase();
    
    // 감정 점수 계산
    final scores = <String, double>{};
    
    // 긍정 감정
    scores['happy'] = _calculateEmotionScore(lower, _happyIndicators);
    scores['excited'] = _calculateEmotionScore(lower, _excitedIndicators);
    scores['grateful'] = _calculateEmotionScore(lower, _gratefulIndicators);
    
    // 부정 감정
    scores['sad'] = _calculateEmotionScore(lower, _sadIndicators);
    scores['angry'] = _calculateEmotionScore(lower, _angryIndicators);
    scores['tired'] = _calculateEmotionScore(lower, _tiredIndicators);
    scores['worried'] = _calculateEmotionScore(lower, _worriedIndicators);
    scores['frustrated'] = _calculateEmotionScore(lower, _frustratedIndicators);
    
    // 가장 높은 점수의 감정 찾기
    String? primaryEmotion;
    double maxScore = 0;
    
    scores.forEach((emotion, score) {
      if (score > maxScore && score > 0.3) { // 최소 임계값 0.3
        maxScore = score;
        primaryEmotion = emotion;
      }
    });
    
    // 감정 강도 계산
    final intensity = _calculateIntensity(message, primaryEmotion);
    
    return EmotionAnalysis(
      primaryEmotion: primaryEmotion,
      intensity: intensity,
      scores: scores,
      requiresEmpathy: primaryEmotion != null && 
        (primaryEmotion == 'sad' || primaryEmotion == 'angry' || 
         primaryEmotion == 'tired' || primaryEmotion == 'worried' ||
         primaryEmotion == 'frustrated'),
    );
  }
  
  /// 감정별 지표
  static const _happyIndicators = [
    '좋아', '좋은', '좋네', '좋다', '행복', '기뻐', '기쁘', '신나', '신난다',
    '최고', '짱', '대박', '굿', '만족', '웃', '웃겨', '재밌', '재미있',
    'ㅎㅎ', 'ㅋㅋ', '히히', '하하', '호호', '^^', ':)', '😊', '😄',
    '즐거', '즐겁', '흐뭇', '뿌듯', '상쾌', '개운', '시원', '날아갈'
  ];
  
  static const _excitedIndicators = [
    '기대', '설레', '설렌다', '두근', '두근거려', '신나', '흥분',
    '들뜨', '와', '우와', '대박', '헐', '오', '!!', '!!!',
    '빨리', '어서', '못참', '궁금', '떨려', '심쿵', '하트'
  ];
  
  static const _gratefulIndicators = [
    '고마워', '고맙', '감사', '땡큐', '사랑해', '사랑', '최고',
    '덕분', '덕택', '감동', '눈물', '뭉클', '따뜻', '훈훈'
  ];
  
  static const _sadIndicators = [
    '슬퍼', '슬프', '우울', '눈물', '울', '울어', '울고',
    '힘들', '힘든', '외로', '외롭', '쓸쓸', '그리워', '그립',
    '보고싶', 'ㅠㅠ', 'ㅜㅜ', 'ㅠ', 'ㅜ', '😢', '😭', '💔',
    '서러', '서럽', '서글', '처량', '안타', '아프', '아파',
    '마음이', '가슴이', '눈물이', '코끝이'
  ];
  
  static const _angryIndicators = [
    '화나', '화난', '짜증', '빡치', '빡쳐', '열받', '열받아',
    '싫어', '싫다', '미치', '미쳐', '답답', '억울', '분하',
    '어이없', '황당', '무시', '개짜증', '진짜', '아오',
    '시발', '씨발', 'ㅅㅂ', '개', '미친', '나쁜', '최악'
  ];
  
  static const _tiredIndicators = [
    '피곤', '지쳐', '지친', '지쳤', '힘들', '힘든', '졸려', '졸린',
    '못하겠', '못해', '지침', '기진맥진', '파김치', '녹초',
    '죽겠', '죽을', '쉬고싶', '자고싶', '눕고싶', '퇴근',
    '하기싫', '귀찮', '몸살', '아프', '머리', '어지러'
  ];
  
  static const _worriedIndicators = [
    '걱정', '불안', '무서', '두려', '긴장', '떨려', '떨린다',
    '고민', '망설', '헷갈', '모르겠', '어떡해', '어떻게',
    '어쩌지', '큰일', '문제', '실수', '실패', '망했', '망할',
    '안될', '안돼', '안되', '못할', '못해', '힘들'
  ];
  
  static const _frustratedIndicators = [
    '답답', '갑갑', '막막', '짜증', '스트레스', '미치겠',
    '돌아버리겠', '환장', '한숨', '에휴', '아이고', '하...',
    '안풀려', '안돼', '막혀', '모르겠', '포기', '그만'
  ];
  
  /// 감정 점수 계산
  static double _calculateEmotionScore(String message, List<String> indicators) {
    int count = 0;
    double weight = 0;
    
    for (final indicator in indicators) {
      if (message.contains(indicator)) {
        count++;
        // 긴 지표일수록 가중치 높임
        weight += indicator.length > 3 ? 2.0 : 1.0;
      }
    }
    
    // 정규화 (0~1 사이)
    return (weight / (indicators.length * 2)).clamp(0.0, 1.0);
  }
  
  /// 감정 강도 계산
  static double _calculateIntensity(String message, String? emotion) {
    if (emotion == null) return 0.0;
    
    double intensity = 0.5; // 기본 강도
    
    // 느낌표 개수
    final exclamationCount = '!'.allMatches(message).length;
    intensity += exclamationCount * 0.1;
    
    // 이모티콘 개수
    final emoticonCount = RegExp(r'[ㅠㅜㅋㅎ]{2,}').allMatches(message).length;
    intensity += emoticonCount * 0.1;
    
    // 강조 표현
    if (message.contains('진짜') || message.contains('정말') || 
        message.contains('너무') || message.contains('완전')) {
      intensity += 0.2;
    }
    
    // 대문자 사용
    if (message.contains(RegExp(r'[A-Z]{2,}'))) {
      intensity += 0.1;
    }
    
    return intensity.clamp(0.0, 1.0);
  }
  
  /// 공감 응답 생성
  static String generateEmpathyResponse(EmotionAnalysis analysis) {
    if (analysis.primaryEmotion == null) return '';
    
    final responses = _empathyResponses[analysis.primaryEmotion] ?? [];
    if (responses.isEmpty) return '';
    
    // 강도에 따라 다른 응답 선택
    final intensityLevel = analysis.intensity > 0.7 ? 'high' : 
                          analysis.intensity > 0.4 ? 'medium' : 'low';
    
    final levelResponses = responses.where((r) => 
      r.contains(intensityLevel) || !r.contains('level:')).toList();
    
    if (levelResponses.isEmpty) return '';
    
    // 랜덤 선택
    final index = DateTime.now().millisecond % levelResponses.length;
    String response = levelResponses[index];
    
    // 레벨 태그 제거
    response = response.replaceAll(RegExp(r'level:\w+\s*'), '');
    
    return response;
  }
  
  /// 일반 대화용 공감/관심 표현 생성
  static String generateGeneralEmpathy(String userMessage) {
    final lower = userMessage.toLowerCase();
    
    // 음식 관련
    if (lower.contains('먹었') || lower.contains('먹을') || lower.contains('음식')) {
      final responses = [
        '오 맛있었어?',
        '뭐 먹었는데?',
        '나도 그거 좋아해!',
        '배고프겠다ㅎㅎ',
        '와 맛있겠다!',
      ];
      return responses[DateTime.now().millisecond % responses.length];
    }
    
    // 장소/이동 관련
    if (lower.contains('갔') || lower.contains('갈') || lower.contains('왔')) {
      final responses = [
        '어땠어?',
        '재밌었어?',
        '다음엔 나도 가보고 싶다!',
        '오 좋았겠다!',
        '피곤하지 않아?',
      ];
      return responses[DateTime.now().millisecond % responses.length];
    }
    
    // 시청/감상 관련
    if (lower.contains('봤') || lower.contains('볼') || lower.contains('보고')) {
      final responses = [
        '재밌었어?',
        '어떤 부분이 좋았어?',
        '나도 봐야겠다!',
        '오 그거 유명하던데!',
        '추천해?',
      ];
      return responses[DateTime.now().millisecond % responses.length];
    }
    
    // 활동 관련
    if (lower.contains('했') || lower.contains('할') || lower.contains('하고')) {
      final responses = [
        '어떻게 됐어?',
        '잘 됐어?',
        '수고했어!',
        '힘들지 않았어?',
        '나도 해보고 싶다!',
      ];
      return responses[DateTime.now().millisecond % responses.length];
    }
    
    // 기본 관심 표현
    final defaultResponses = [
      '너는?',
      '너는 어때?',
      '너도 그래?',
      '너는 어떻게 생각해?',
      '너도 해봤어?',
    ];
    
    return defaultResponses[DateTime.now().millisecond % defaultResponses.length];
  }
  
  /// 공감 응답 데이터베이스
  static const Map<String, List<String>> _empathyResponses = {
    'happy': [
      'level:high 와!! 진짜 대박이네요!! 완전 좋겠다!!',
      'level:high 헐 대박!! 너무너무 축하해요!!',
      'level:medium 오 좋으시겠어요ㅎㅎ 부럽다~',
      'level:medium 와 진짜요? 좋겠네요!',
      'level:low 오 좋네요ㅎㅎ',
      'level:low 그렇구나~ 좋으시겠어요',
    ],
    'sad': [
      'level:high 헐... 진짜 많이 힘드시겠어요ㅠㅠ',
      'level:high 아... 너무 속상하시겠다ㅠㅠ 힘내세요',
      'level:medium 아이고... 속상하시겠어요',
      'level:medium 힘드시죠? 괜찮아질 거예요',
      'level:low 아... 그러셨구나',
      'level:low 음... 좀 그렇네요',
    ],
    'angry': [
      'level:high 와... 진짜 열받으시겠다',
      'level:high 헐 저라도 완전 화났을 것 같아요',
      'level:medium 아 짜증나네요 그거',
      'level:medium 화날 만하네요...',
      'level:low 음... 좀 그렇긴 하네요',
      'level:low 아 그렇구나...',
    ],
    'tired': [
      'level:high 헐... 진짜 많이 피곤하시겠어요ㅠㅠ 푹 쉬세요',
      'level:high 아이고... 정말 고생하셨네요ㅠㅠ',
      'level:medium 피곤하시죠? 좀 쉬세요',
      'level:medium 많이 힘드셨나봐요',
      'level:low 수고하셨어요~',
      'level:low 좀 쉬시는 게 좋을 것 같아요',
    ],
    'worried': [
      'level:high 많이 걱정되시죠... 잘 될 거예요 분명!',
      'level:high 불안하시겠어요ㅠㅠ 힘내세요!',
      'level:medium 걱정 마세요~ 괜찮을 거예요',
      'level:medium 음... 걱정되긴 하네요',
      'level:low 잘 될 거예요~',
      'level:low 너무 걱정하지 마세요',
    ],
    'excited': [
      'level:high 와!! 완전 설레시겠다!! 대박!!',
      'level:high 헐 진짜요?? 완전 기대되겠어요!!',
      'level:medium 오 기대되시겠어요ㅎㅎ',
      'level:medium 와 좋으시겠다~',
      'level:low 오 그렇구나ㅎㅎ',
      'level:low 기대되네요~',
    ],
    'grateful': [
      'level:high 에이~ 뭘요ㅎㅎ 저도 너무 감사해요!',
      'level:high 아니에요~ 오히려 제가 더 고마워요!',
      'level:medium 별말씀을요~ 당연한 거죠ㅎㅎ',
      'level:medium 에이 뭘 이런 걸로~',
      'level:low 네네ㅎㅎ',
      'level:low 아니에요~',
    ],
    'frustrated': [
      'level:high 아... 진짜 답답하시겠어요ㅠㅠ',
      'level:high 헐... 스트레스 받으시겠다',
      'level:medium 음... 좀 답답하긴 하네요',
      'level:medium 아이고... 힘드시겠어요',
      'level:low 그렇구나...',
      'level:low 음... 좀 그렇네요',
    ],
  };
}

/// 감정 분석 결과
class EmotionAnalysis {
  final String? primaryEmotion;
  final double intensity;
  final Map<String, double> scores;
  final bool requiresEmpathy;
  
  EmotionAnalysis({
    required this.primaryEmotion,
    required this.intensity,
    required this.scores,
    required this.requiresEmpathy,
  });
  
  @override
  String toString() {
    return 'EmotionAnalysis(emotion: $primaryEmotion, intensity: $intensity, requiresEmpathy: $requiresEmpathy)';
  }
}