/// 다국어 감정 강도 분석기
/// 
/// 언어별 강조 패턴, 반복 표현, 특수 문자 등을 인식하여 감정 강도 계산
class MultilingualIntensityAnalyzer {
  // 싱글톤 패턴
  static final MultilingualIntensityAnalyzer _instance = MultilingualIntensityAnalyzer._internal();
  factory MultilingualIntensityAnalyzer() => _instance;
  MultilingualIntensityAnalyzer._internal();

  /// 다국어 감정 강도 분석
  double analyzeIntensity(String text, String language) {
    double intensity = 0.5; // 기본 강도
    
    // 언어별 분석
    switch (language) {
      case 'ko':
        intensity = _analyzeKoreanIntensity(text);
        break;
      case 'en':
        intensity = _analyzeEnglishIntensity(text);
        break;
      case 'es':
        intensity = _analyzeSpanishIntensity(text);
        break;
      case 'fr':
        intensity = _analyzeFrenchIntensity(text);
        break;
      case 'de':
        intensity = _analyzeGermanIntensity(text);
        break;
      case 'it':
        intensity = _analyzeItalianIntensity(text);
        break;
      case 'pt':
        intensity = _analyzePortugueseIntensity(text);
        break;
      case 'ja':
        intensity = _analyzeJapaneseIntensity(text);
        break;
      case 'zh':
        intensity = _analyzeChineseIntensity(text);
        break;
      case 'ru':
        intensity = _analyzeRussianIntensity(text);
        break;
      case 'ar':
        intensity = _analyzeArabicIntensity(text);
        break;
      default:
        intensity = _analyzeUniversalPatterns(text);
    }
    
    return intensity.clamp(0.0, 1.0);
  }

  /// 한국어 강도 분석
  double _analyzeKoreanIntensity(String text) {
    double intensity = 0.5;
    
    // 느낌표 개수
    intensity += '!'.allMatches(text).length * 0.1;
    
    // 강조 부사
    final intensifiers = ['정말', '너무', '진짜', '완전', '매우', '엄청', '아주', '굉장히', '몹시'];
    for (final word in intensifiers) {
      if (text.contains(word)) {
        intensity += 0.15;
      }
    }
    
    // 반복 표현
    if (text.contains('ㅠㅠ') || text.contains('ㅜㅜ')) {
      intensity += 0.2; // 강한 슬픔
    }
    if (text.contains('ㅋㅋㅋ') || text.contains('ㅎㅎㅎ')) {
      intensity += 0.15; // 강한 웃음
    }
    if (text.contains('ㅋㅋ') || text.contains('ㅎㅎ')) {
      intensity += 0.1; // 보통 웃음
    }
    
    // 이모티콘
    if (text.contains('♡') || text.contains('❤') || text.contains('💕')) {
      intensity += 0.15;
    }
    
    // 대문자 한글 강조 (초성 반복)
    if (RegExp(r'ㄷㄷ|ㄱㄱ|ㅂㅂ|ㅅㅅ').hasMatch(text)) {
      intensity += 0.1;
    }
    
    return intensity;
  }

  /// 영어 강도 분석
  double _analyzeEnglishIntensity(String text) {
    double intensity = 0.5;
    final lower = text.toLowerCase();
    
    // 느낌표
    intensity += '!'.allMatches(text).length * 0.1;
    
    // 강조 부사
    final intensifiers = [
      'very', 'really', 'so', 'extremely', 'super', 'totally',
      'absolutely', 'completely', 'incredibly', 'amazingly',
      'terribly', 'awfully', 'quite', 'pretty', 'too'
    ];
    for (final word in intensifiers) {
      if (RegExp('\\b$word\\b').hasMatch(lower)) {
        intensity += 0.15;
      }
    }
    
    // 대문자 비율 (강조)
    final upperCount = RegExp(r'[A-Z]').allMatches(text).length;
    final letterCount = RegExp(r'[a-zA-Z]').allMatches(text).length;
    if (letterCount > 0) {
      final upperRatio = upperCount / letterCount;
      if (upperRatio > 0.5) {
        intensity += 0.2; // 대부분 대문자
      } else if (upperRatio > 0.3) {
        intensity += 0.1; // 일부 대문자
      }
    }
    
    // 반복 표현
    if (RegExp(r'(LOL|LMAO|ROFL|OMG|WTF)', caseSensitive: false).hasMatch(text)) {
      intensity += 0.15;
    }
    if (text.contains('!!!') || text.contains('???')) {
      intensity += 0.15;
    }
    
    // 이모티콘/이모지
    if (RegExp(r'[:;]-?[)D(|]|<3|xD', caseSensitive: false).hasMatch(text)) {
      intensity += 0.1;
    }
    
    return intensity;
  }

  /// 스페인어 강도 분석
  double _analyzeSpanishIntensity(String text) {
    double intensity = 0.5;
    final lower = text.toLowerCase();
    
    // 느낌표와 거꾸로 느낌표
    intensity += '!'.allMatches(text).length * 0.1;
    intensity += '¡'.allMatches(text).length * 0.1;
    
    // 강조 부사
    final intensifiers = [
      'muy', 'mucho', 'demasiado', 'súper', 'tan', 'tanto',
      'bastante', 'extremadamente', 'increíblemente', 'totalmente',
      'absolutamente', 'completamente', 'bien', 'mal'
    ];
    for (final word in intensifiers) {
      if (RegExp('\\b$word\\b').hasMatch(lower)) {
        intensity += 0.15;
      }
    }
    
    // 반복 표현
    if (text.contains('jajaja') || text.contains('jejeje')) {
      intensity += 0.15;
    }
    if (text.contains('jaja') || text.contains('jeje')) {
      intensity += 0.1;
    }
    
    // 대문자 강조
    if (text == text.toUpperCase() && text.length > 3) {
      intensity += 0.2;
    }
    
    return intensity;
  }

  /// 프랑스어 강도 분석
  double _analyzeFrenchIntensity(String text) {
    double intensity = 0.5;
    final lower = text.toLowerCase();
    
    // 느낌표
    intensity += '!'.allMatches(text).length * 0.1;
    
    // 강조 부사
    final intensifiers = [
      'très', 'trop', 'vraiment', 'beaucoup', 'énormément',
      'extrêmement', 'super', 'hyper', 'ultra', 'méga',
      'complètement', 'totalement', 'absolument', 'tellement'
    ];
    for (final word in intensifiers) {
      if (RegExp('\\b$word\\b').hasMatch(lower)) {
        intensity += 0.15;
      }
    }
    
    // 반복 표현
    if (text.contains('hahaha') || text.contains('hihihi')) {
      intensity += 0.15;
    }
    if (text.contains('mdr') || text.contains('ptdr')) { // mort de rire
      intensity += 0.15;
    }
    
    return intensity;
  }

  /// 독일어 강도 분석
  double _analyzeGermanIntensity(String text) {
    double intensity = 0.5;
    final lower = text.toLowerCase();
    
    // 느낌표
    intensity += '!'.allMatches(text).length * 0.1;
    
    // 강조 부사
    final intensifiers = [
      'sehr', 'zu', 'ganz', 'besonders', 'extrem', 'super',
      'total', 'völlig', 'absolut', 'wirklich', 'echt',
      'unglaublich', 'wahnsinnig', 'außerordentlich'
    ];
    for (final word in intensifiers) {
      if (RegExp('\\b$word\\b').hasMatch(lower)) {
        intensity += 0.15;
      }
    }
    
    // 반복 표현
    if (text.contains('hahaha') || text.contains('hehehe')) {
      intensity += 0.15;
    }
    
    // 대문자 강조 (독일어는 명사가 대문자로 시작하므로 전체 대문자 체크)
    if (text == text.toUpperCase() && text.length > 3) {
      intensity += 0.2;
    }
    
    return intensity;
  }

  /// 이탈리아어 강도 분석
  double _analyzeItalianIntensity(String text) {
    double intensity = 0.5;
    final lower = text.toLowerCase();
    
    // 느낌표
    intensity += '!'.allMatches(text).length * 0.1;
    
    // 강조 부사
    final intensifiers = [
      'molto', 'troppo', 'tanto', 'così', 'veramente',
      'davvero', 'proprio', 'assai', 'estremamente',
      'incredibilmente', 'super', 'ultra', 'mega'
    ];
    for (final word in intensifiers) {
      if (RegExp('\\b$word\\b').hasMatch(lower)) {
        intensity += 0.15;
      }
    }
    
    // 반복 표현
    if (text.contains('ahahah') || text.contains('eheheh')) {
      intensity += 0.15;
    }
    
    return intensity;
  }

  /// 포르투갈어 강도 분석
  double _analyzePortugueseIntensity(String text) {
    double intensity = 0.5;
    final lower = text.toLowerCase();
    
    // 느낌표
    intensity += '!'.allMatches(text).length * 0.1;
    
    // 강조 부사
    final intensifiers = [
      'muito', 'demais', 'super', 'mega', 'ultra',
      'extremamente', 'incrivelmente', 'totalmente',
      'completamente', 'absolutamente', 'bem', 'tão'
    ];
    for (final word in intensifiers) {
      if (RegExp('\\b$word\\b').hasMatch(lower)) {
        intensity += 0.15;
      }
    }
    
    // 반복 표현 (브라질 포르투갈어)
    if (text.contains('kkkkk') || text.contains('rsrsrs')) {
      intensity += 0.15;
    }
    if (text.contains('kkk') || text.contains('rsrs')) {
      intensity += 0.1;
    }
    // 유럽 포르투갈어
    if (text.contains('ahahah') || text.contains('hehehe')) {
      intensity += 0.15;
    }
    
    return intensity;
  }

  /// 일본어 강도 분석
  double _analyzeJapaneseIntensity(String text) {
    double intensity = 0.5;
    
    // 느낌표
    intensity += '！'.allMatches(text).length * 0.1;
    intensity += '!'.allMatches(text).length * 0.1;
    
    // 강조 부사
    final intensifiers = [
      'とても', 'すごく', 'めちゃ', 'めっちゃ', 'ちょう',
      '超', 'マジ', 'ガチ', 'めちゃくちゃ', '本当に',
      'ほんとに', 'すごい', 'やばい'
    ];
    for (final word in intensifiers) {
      if (text.contains(word)) {
        intensity += 0.15;
      }
    }
    
    // 반복 표현
    if (text.contains('www') || text.contains('ｗｗｗ')) {
      intensity += 0.15;
    }
    if (text.contains('笑笑') || text.contains('爆笑')) {
      intensity += 0.15;
    }
    
    // 카타카나 강조 (통상 히라가나로 쓰는 단어를 카타카나로)
    if (RegExp(r'[ァ-ヶー]{5,}').hasMatch(text)) {
      intensity += 0.1;
    }
    
    // 이모티콘
    if (RegExp(r'[（(][^）)]*[）)]').hasMatch(text)) {
      intensity += 0.1;
    }
    
    return intensity;
  }

  /// 중국어 강도 분석
  double _analyzeChineseIntensity(String text) {
    double intensity = 0.5;
    
    // 느낌표
    intensity += '！'.allMatches(text).length * 0.1;
    intensity += '!'.allMatches(text).length * 0.1;
    
    // 강조 부사
    final intensifiers = [
      '很', '非常', '特别', '超', '超级', '极', '极其',
      '十分', '相当', '太', '真', '真的', '好', '最'
    ];
    for (final word in intensifiers) {
      if (text.contains(word)) {
        intensity += 0.15;
      }
    }
    
    // 반복 표현
    if (text.contains('哈哈哈') || text.contains('呵呵呵')) {
      intensity += 0.15;
    }
    if (text.contains('哈哈') || text.contains('呵呵')) {
      intensity += 0.1;
    }
    if (text.contains('233') || text.contains('666')) { // 인터넷 슬랭
      intensity += 0.15;
    }
    
    // 중복 문자
    if (RegExp(r'(.)\1{2,}').hasMatch(text)) {
      intensity += 0.1;
    }
    
    return intensity;
  }

  /// 러시아어 강도 분석
  double _analyzeRussianIntensity(String text) {
    double intensity = 0.5;
    final lower = text.toLowerCase();
    
    // 느낌표
    intensity += '!'.allMatches(text).length * 0.1;
    
    // 강조 부사
    final intensifiers = [
      'очень', 'слишком', 'так', 'такой', 'настолько',
      'весьма', 'крайне', 'чрезвычайно', 'ужасно',
      'страшно', 'жутко', 'супер', 'мега', 'ультра'
    ];
    for (final word in intensifiers) {
      if (lower.contains(word)) {
        intensity += 0.15;
      }
    }
    
    // 반복 표현
    if (text.contains('ахаха') || text.contains('хахаха')) {
      intensity += 0.15;
    }
    if (text.contains(')))') || text.contains('(((')) { // 러시아식 이모티콘
      intensity += 0.15; // 0.1에서 0.15로 증가
    }
    
    // 대문자 강조
    if (text == text.toUpperCase() && text.length > 3) {
      intensity += 0.2;
    }
    
    return intensity;
  }

  /// 아랍어 강도 분석
  double _analyzeArabicIntensity(String text) {
    double intensity = 0.5;
    
    // 느낌표
    intensity += '!'.allMatches(text).length * 0.1;
    intensity += '؟'.allMatches(text).length * 0.05; // 아랍어 물음표
    
    // 강조 표현
    final intensifiers = [
      'جداً', 'جدا', 'كثير', 'كثيراً', 'للغاية',
      'تماماً', 'فعلاً', 'حقاً', 'بشدة'
    ];
    for (final word in intensifiers) {
      if (text.contains(word)) {
        intensity += 0.15;
      }
    }
    
    // 반복 표현
    if (text.contains('ههههه') || text.contains('خخخخخ')) {
      intensity += 0.15;
    }
    if (text.contains('ههه') || text.contains('خخخ')) {
      intensity += 0.1;
    }
    
    // 이모티콘
    if (text.contains(':)') || text.contains(':(') || text.contains(':D')) {
      intensity += 0.1;
    }
    
    return intensity;
  }

  /// 범용 패턴 분석 (언어 무관)
  double _analyzeUniversalPatterns(String text) {
    double intensity = 0.5;
    
    // 느낌표
    intensity += '!'.allMatches(text).length * 0.1;
    
    // 물음표 반복
    if (text.contains('???')) {
      intensity += 0.15;
    } else if (text.contains('??')) {
      intensity += 0.1;
    }
    
    // 이모지 감지
    final emojiPattern = RegExp(
      r'[\u{1F600}-\u{1F64F}]|' // 이모티콘
      r'[\u{1F300}-\u{1F5FF}]|' // 기타 심볼
      r'[\u{1F680}-\u{1F6FF}]|' // 교통/지도
      r'[\u{2600}-\u{26FF}]|'   // 기타 심볼
      r'[\u{2700}-\u{27BF}]',    // 딩뱃
      unicode: true
    );
    final emojiCount = emojiPattern.allMatches(text).length;
    intensity += emojiCount * 0.1;
    
    // 대문자 비율
    final upperCount = RegExp(r'[A-Z]').allMatches(text).length;
    final letterCount = RegExp(r'[a-zA-Z]').allMatches(text).length;
    if (letterCount > 5) {
      final upperRatio = upperCount / letterCount;
      if (upperRatio > 0.7) {
        intensity += 0.2;
      }
    }
    
    // 반복 문자 패턴
    if (RegExp(r'(.)\1{3,}').hasMatch(text)) {
      intensity += 0.15;
    }
    
    return intensity;
  }

  /// 문화별 강도 조정 계수
  double getCulturalAdjustment(String language) {
    // 일부 문화는 감정 표현이 더 절제되거나 과장됨
    switch (language) {
      case 'ja': // 일본어: 절제된 표현
        return 0.85;
      case 'ko': // 한국어: 중간
        return 1.0;
      case 'es': // 스페인어: 표현적
      case 'it': // 이탈리아어: 표현적
        return 1.1;
      case 'en': // 영어: 중간
      case 'de': // 독일어: 절제
        return 0.95;
      case 'ar': // 아랍어: 표현적
        return 1.05;
      default:
        return 1.0;
    }
  }
}