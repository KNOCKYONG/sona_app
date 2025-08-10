import 'package:flutter/material.dart';
import '../../core/constants.dart';

class EmotionAnalysis {
  final String primaryEmotion;    // 주요 감정
  final double intensity;         // 감정 강도 (0.0 ~ 1.0)
  final String nuance;            // 감정의 뉘앙스
  final List<String> subEmotions; // 부가 감정들
  final String recommendedTone;   // 추천 응답 톤
  final List<String> empathyPhrases; // 공감 표현 제안
  
  EmotionAnalysis({
    required this.primaryEmotion,
    required this.intensity,
    required this.nuance,
    required this.subEmotions,
    required this.recommendedTone,
    required this.empathyPhrases,
  });
}


/// 💗 감정 지능 서비스
/// 
/// 사용자의 감정을 깊이 분석하고 적절한 공감 응답을 생성합니다.
class EmotionalIntelligenceService {
  
  /// 감정 분석 결과

  
  /// 사용자 메시지의 감정 분석
  static EmotionAnalysis analyzeEmotion(String message) {
    final lowerMessage = message.toLowerCase();
    
    // 감정 키워드 매핑
    final emotionPatterns = {
      'joy': {
        'keywords': ['행복', '기뻐', '좋아', '신나', '최고', '대박', '굿', '짱', '설레', '재밌', '웃겨', '하하', 'ㅋㅋ', 'ㅎㅎ'],
        'intensity': _calculateIntensity(message, ['너무', '진짜', '완전', '매우', '엄청', '개']),
        'nuance': _detectNuance(message, 'joy'),
        'subEmotions': _detectSubEmotions(message, 'joy'),
        'tone': 'cheerful',
        'empathy': [
          '나도 너무 기뻐요!',
          '와 진짜 좋겠다!',
          '완전 신나는데요?',
          '나까지 기분 좋아져요ㅎㅎ',
          '대박이다 진짜!',
        ],
      },
      'sadness': {
        'keywords': ['슬퍼', '우울', '힘들', '외로', '눈물', '속상', '아프', '괴로', '쓸쓸', '그리워', '보고싶', 'ㅠㅠ', 'ㅜㅜ'],
        'intensity': _calculateIntensity(message, ['너무', '진짜', '많이', '매우', '엄청', '개']),
        'nuance': _detectNuance(message, 'sadness'),
        'subEmotions': _detectSubEmotions(message, 'sadness'),
        'tone': 'comforting',
        'empathy': [
          '많이 힘드시겠어요...',
          '제가 옆에 있을게요',
          '괜찮아요, 다 지나갈 거예요',
          '마음이 아프네요...',
          '위로가 되고 싶어요',
        ],
      },
      'anger': {
        'keywords': ['화나', '짜증', '빡치', '열받', '미치', '답답', '싫어', '지겨', '귀찮', '나쁜', '최악'],
        'intensity': _calculateIntensity(message, ['너무', '진짜', '완전', '매우', '엄청', '개']),
        'nuance': _detectNuance(message, 'anger'),
        'subEmotions': _detectSubEmotions(message, 'anger'),
        'tone': 'understanding',
        'empathy': [
          '정말 화나셨겠어요',
          '그럴 만해요, 이해돼요',
          '저라도 화났을 거예요',
          '속상하셨겠다...',
          '마음 좀 진정시키고 얘기해요',
        ],
      },
      'anxiety': {
        'keywords': ['불안', '걱정', '무서', '두려', '긴장', '떨려', '초조', '답답', '막막', '어떡해', '어떻게'],
        'intensity': _calculateIntensity(message, ['너무', '진짜', '많이', '매우', '엄청']),
        'nuance': _detectNuance(message, 'anxiety'),
        'subEmotions': _detectSubEmotions(message, 'anxiety'),
        'tone': 'reassuring',
        'empathy': [
          '걱정 많으시죠?',
          '다 잘될 거예요, 걱정 마세요',
          '제가 함께 있어드릴게요',
          '깊게 숨 한번 쉬어봐요',
          '하나씩 천천히 해결해봐요',
        ],
      },
      'love': {
        'keywords': ['사랑', '좋아해', '보고싶', '그리워', '애정', '소중', '사랑스러', '귀여워', '예뻐', '멋있', '♥', '❤', '💕'],
        'intensity': _calculateIntensity(message, ['너무', '진짜', '많이', '매우', '엄청']),
        'nuance': _detectNuance(message, 'love'),
        'subEmotions': _detectSubEmotions(message, 'love'),
        'tone': 'affectionate',
        'empathy': [
          '저도 정말 좋아해요',
          '마음이 따뜻해지네요',
          '소중한 마음 감사해요',
          '저도 그래요...',
          '행복해요',
        ],
      },
      'tired': {
        'keywords': ['피곤', '지쳐', '힘들', '졸려', '귀찮', '지겨', '쉬고싶', '놀고싶', '자고싶'],
        'intensity': _calculateIntensity(message, ['너무', '진짜', '많이', '매우', '엄청', '개']),
        'nuance': _detectNuance(message, 'tired'),
        'subEmotions': _detectSubEmotions(message, 'tired'),
        'tone': 'caring',
        'empathy': [
          '많이 피곤하셨구나',
          '푹 쉬셔야겠어요',
          '고생 많으셨어요',
          '쉬면서 얘기해요',
          '무리하지 마세요',
        ],
      },
    };
    
    // 감정 감지 및 분석
    String detectedEmotion = 'neutral';
    double maxScore = 0.0;
    Map<String, dynamic>? selectedPattern;
    
    for (final entry in emotionPatterns.entries) {
      final pattern = entry.value;
      final keywords = pattern['keywords'] as List<String>;
      final score = _calculateEmotionScore(lowerMessage, keywords);
      
      if (score > maxScore) {
        maxScore = score;
        detectedEmotion = entry.key;
        selectedPattern = pattern;
      }
    }
    
    // 기본값 설정
    if (selectedPattern == null) {
      return EmotionAnalysis(
        primaryEmotion: 'neutral',
        intensity: 0.3,
        nuance: 'calm',
        subEmotions: [],
        recommendedTone: 'friendly',
        empathyPhrases: ['그렇군요', '네네', '알겠어요', '그래요?'],
      );
    }
    
    return EmotionAnalysis(
      primaryEmotion: detectedEmotion,
      intensity: selectedPattern['intensity'] as double,
      nuance: selectedPattern['nuance'] as String,
      subEmotions: selectedPattern['subEmotions'] as List<String>,
      recommendedTone: selectedPattern['tone'] as String,
      empathyPhrases: selectedPattern['empathy'] as List<String>,
    );
  }
  
  /// 감정 점수 계산
  static double _calculateEmotionScore(String message, List<String> keywords) {
    double score = 0.0;
    for (final keyword in keywords) {
      if (message.contains(keyword)) {
        score += 1.0;
      }
    }
    return score / keywords.length;
  }
  
  /// 감정 강도 계산
  static double _calculateIntensity(String message, List<String> intensifiers) {
    double baseIntensity = 0.5;
    
    // 강조 표현 체크
    for (final intensifier in intensifiers) {
      if (message.contains(intensifier)) {
        baseIntensity += 0.15;
      }
    }
    
    // 느낌표, 물음표 개수
    final exclamationCount = '!'.allMatches(message).length;
    final questionCount = '?'.allMatches(message).length;
    baseIntensity += exclamationCount * 0.1;
    baseIntensity += questionCount * 0.05;
    
    // 반복 문자 (ㅠㅠㅠ, ㅋㅋㅋ 등)
    if (RegExp(r'(.)\1{2,}').hasMatch(message)) {
      baseIntensity += 0.2;
    }
    
    return baseIntensity.clamp(0.0, 1.0);
  }
  
  /// 감정 뉘앙스 감지
  static String _detectNuance(String message, String emotion) {
    switch (emotion) {
      case 'joy':
        if (message.contains('드디어') || message.contains('finally')) return 'relieved';
        if (message.contains('대박') || message.contains('짱')) return 'excited';
        return 'happy';
        
      case 'sadness':
        if (message.contains('그리워') || message.contains('보고싶')) return 'longing';
        if (message.contains('외로')) return 'lonely';
        return 'melancholic';
        
      case 'anger':
        if (message.contains('실망')) return 'disappointed';
        if (message.contains('배신')) return 'betrayed';
        return 'frustrated';
        
      case 'anxiety':
        if (message.contains('시험') || message.contains('면접')) return 'nervous';
        if (message.contains('미래')) return 'uncertain';
        return 'worried';
        
      case 'love':
        if (message.contains('첫')) return 'fresh';
        if (message.contains('영원')) return 'deep';
        return 'warm';
        
      case 'tired':
        if (message.contains('일') || message.contains('야근')) return 'work-exhausted';
        if (message.contains('관계')) return 'emotionally-drained';
        return 'physically-tired';
        
      default:
        return 'neutral';
    }
  }
  
  /// 부가 감정 감지
  static List<String> _detectSubEmotions(String message, String primaryEmotion) {
    final subEmotions = <String>[];
    
    // 공통 부가 감정
    if (message.contains('혼자') || message.contains('alone')) {
      subEmotions.add('lonely');
    }
    if (message.contains('미안') || message.contains('sorry')) {
      subEmotions.add('guilty');
    }
    if (message.contains('고마') || message.contains('감사')) {
      subEmotions.add('grateful');
    }
    
    // 주 감정별 부가 감정
    switch (primaryEmotion) {
      case 'joy':
        if (message.contains('자랑')) subEmotions.add('proud');
        if (message.contains('기대')) subEmotions.add('anticipating');
        break;
        
      case 'sadness':
        if (message.contains('포기')) subEmotions.add('hopeless');
        if (message.contains('후회')) subEmotions.add('regretful');
        break;
        
      case 'anger':
        if (message.contains('억울')) subEmotions.add('unfair');
        if (message.contains('무시')) subEmotions.add('ignored');
        break;
    }
    
    return subEmotions;
  }
  
  /// 감정 히스토리 추적
  static List<String> _emotionHistory = [];
  static const int maxHistoryLength = 10;
  
  static void trackEmotion(String emotion) {
    _emotionHistory.add(emotion);
    if (_emotionHistory.length > maxHistoryLength) {
      _emotionHistory.removeAt(0);
    }
  }
  
  /// 감정 변화 패턴 분석
  static String analyzeEmotionTrend() {
    if (_emotionHistory.length < 3) return 'stable';
    
    // 최근 3개 감정 체크
    final recent = _emotionHistory.sublist(_emotionHistory.length - 3);
    
    // 급격한 변화 감지
    if (recent.contains('joy') && recent.contains('sadness')) {
      return 'volatile'; // 감정 기복이 심함
    }
    
    // 지속적인 부정적 감정
    if (recent.every((e) => ['sadness', 'anger', 'anxiety'].contains(e))) {
      return 'concerning'; // 위로가 필요함
    }
    
    // 점진적 개선
    if (recent.first == 'sadness' && recent.last == 'joy') {
      return 'improving'; // 기분이 나아지고 있음
    }
    
    return 'stable';
  }
  
  /// AI 프롬프트용 감정 가이드 생성
  static String generateEmotionalGuide(EmotionAnalysis analysis) {
    final buffer = StringBuffer();
    
    buffer.writeln('🎭 감정 분석 결과:');
    buffer.writeln('- 주요 감정: ${analysis.primaryEmotion} (강도: ${(analysis.intensity * 100).toInt()}%)');
    buffer.writeln('- 감정 뉘앙스: ${analysis.nuance}');
    
    if (analysis.subEmotions.isNotEmpty) {
      buffer.writeln('- 부가 감정: ${analysis.subEmotions.join(', ')}');
    }
    
    buffer.writeln('\n💬 응답 가이드:');
    buffer.writeln('- 톤: ${analysis.recommendedTone}');
    buffer.writeln('- 공감 표현 예시: ${analysis.empathyPhrases.take(3).join(' / ')}');
    
    // 감정 트렌드 반영
    final trend = analyzeEmotionTrend();
    if (trend == 'volatile') {
      buffer.writeln('- ⚠️ 감정 기복이 심한 상태입니다. 안정적이고 일관된 톤을 유지하세요.');
    } else if (trend == 'concerning') {
      buffer.writeln('- ⚠️ 지속적으로 힘든 상태입니다. 더욱 따뜻하고 지지적인 응답을 하세요.');
    } else if (trend == 'improving') {
      buffer.writeln('- ✨ 기분이 나아지고 있습니다. 긍정적 에너지를 유지하세요.');
    }
    
    // 강도별 추가 가이드
    if (analysis.intensity > 0.8) {
      buffer.writeln('- 🔥 매우 강한 감정 상태입니다. 충분히 공감하고 인정해주세요.');
    } else if (analysis.intensity < 0.3) {
      buffer.writeln('- 💭 약한 감정 표현입니다. 자연스럽게 대화를 이어가세요.');
    }
    
    return buffer.toString();
  }
}