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
    // OpenAI API가 감정에 맞는 공감 응답을 생성하도록
    // 감정 분석 결과만 전달하고 응답 생성은 AI에게 위임
    return '';
  }
  
  /// 일반 대화용 공감/관심 표현 생성
  static String generateGeneralEmpathy(String userMessage) {
    // OpenAI API가 자연스럽게 공감하도록 빈 문자열 반환
    // 프롬프트에서 공감 가이드라인 제공
    return '';
  }
  
  /// 공감 응답 감정 분류만 제공
  /// 실제 응답은 OpenAI API가 생성
  static const List<String> _emotionCategories = [
    'happy',
    'sad',
    'angry',
    'tired',
    'worried',
    'excited',
    'grateful',
    'frustrated',
  ];
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