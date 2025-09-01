/// 언어 감지 서비스
/// 
/// 사용자 입력 텍스트의 언어를 감지하여 적절한 감정 분석을 지원
class LanguageDetectionService {
  // 싱글톤 패턴
  static final LanguageDetectionService _instance = LanguageDetectionService._internal();
  factory LanguageDetectionService() => _instance;
  LanguageDetectionService._internal();

  /// 텍스트의 언어를 감지 (우선순위 기반)
  /// systemLanguage: 시스템 언어 코드 (우선순위 1)
  /// appLanguage: 앱 설정 언어 코드 (우선순위 2)
  String detectLanguageWithPriority(String text, {String? systemLanguage, String? appLanguage}) {
    if (text.isEmpty) {
      // 빈 텍스트인 경우 우선순위에 따라 결정
      if (systemLanguage != null && getSupportedLanguages().contains(systemLanguage)) {
        return systemLanguage;
      }
      if (appLanguage != null && getSupportedLanguages().contains(appLanguage)) {
        return appLanguage;
      }
      return 'en'; // 최종 기본값
    }
    
    // 1. 한국어가 포함되어 있으면 한국어 우선
    if (RegExp(r'[\u{AC00}-\u{D7AF}]', unicode: true).hasMatch(text)) {
      return 'ko';
    }
    
    // 2. 일반 언어 감지
    final detectedLang = detectLanguage(text);
    
    // 3. 감지 실패 시 우선순위 적용
    if (detectedLang == 'en') {
      // 영어로 감지되었지만, 실제로는 다른 언어일 수 있음
      // 시스템 언어나 앱 언어로 폴백
      if (systemLanguage != null && systemLanguage != 'en' && 
          getSupportedLanguages().contains(systemLanguage)) {
        // 시스템 언어가 영어가 아니고 지원되는 언어라면 우선 사용
        return systemLanguage;
      }
      if (appLanguage != null && appLanguage != 'en' && 
          getSupportedLanguages().contains(appLanguage)) {
        // 앱 언어가 영어가 아니고 지원되는 언어라면 사용
        return appLanguage;
      }
    }
    
    return detectedLang;
  }
  
  /// 텍스트의 언어를 감지
  String detectLanguage(String text) {
    if (text.isEmpty) return 'en'; // 기본값은 영어
    
    final lower = text.toLowerCase();
    
    // 한국어 감지 (한글 유니코드 범위: AC00-D7AF)
    if (RegExp(r'[\u{AC00}-\u{D7AF}]', unicode: true).hasMatch(text)) {
      return 'ko';
    }
    
    // 일본어 감지 (히라가나: 3040-309F, 카타카나: 30A0-30FF, 한자: 4E00-9FAF)
    if (RegExp(r'[\u{3040}-\u{309F}]|[\u{30A0}-\u{30FF}]', unicode: true).hasMatch(text)) {
      return 'ja';
    }
    
    // 중국어 감지 (한자만 있고 일본어 문자가 없는 경우)
    if (RegExp(r'[\u{4E00}-\u{9FFF}]', unicode: true).hasMatch(text) &&
        !RegExp(r'[\u{3040}-\u{309F}]|[\u{30A0}-\u{30FF}]', unicode: true).hasMatch(text)) {
      return 'zh';
    }
    
    // 아랍어 감지 (0600-06FF)
    if (RegExp(r'[\u{0600}-\u{06FF}]', unicode: true).hasMatch(text)) {
      return 'ar';
    }
    
    // 러시아어 감지 (키릴 문자: 0400-04FF)
    if (RegExp(r'[\u{0400}-\u{04FF}]', unicode: true).hasMatch(text)) {
      return 'ru';
    }
    
    // 스페인어 특수 문자와 악센트 감지
    if (lower.contains('ñ') || lower.contains('¿') || lower.contains('¡') ||
        lower.contains('á') || lower.contains('é') || lower.contains('í') || 
        lower.contains('ó') || lower.contains('ú')) {
      // 프랑스어와 구별하기 위한 추가 체크
      if (_containsSpanishKeywords(lower) || lower.contains('ñ') || 
          lower.contains('¿') || lower.contains('¡')) {
        return 'es';
      }
    }
    
    // 프랑스어 특수 문자 감지
    if ((lower.contains('ç') || lower.contains('œ') || lower.contains('æ')) &&
        !lower.contains('ñ')) {
      return 'fr';
    }
    
    // 독일어 특수 문자 감지
    if (lower.contains('ä') || lower.contains('ö') || lower.contains('ü') || 
        lower.contains('ß')) {
      return 'de';
    }
    
    // 포르투갈어 특수 문자 감지
    if ((lower.contains('ã') || lower.contains('õ') || lower.contains('ç')) &&
        !lower.contains('ñ')) {
      return 'pt';
    }
    
    // 베트남어 감지 (성조 표시)
    if (RegExp(r'[àảãáạăằẳẵắặâầẩẫấậèẻẽéẹêềểễếệìỉĩíịòỏõóọôồổỗốộơờởỡớợùủũúụưừửữứựỳỷỹýỵđĐ]').hasMatch(text)) {
      return 'vi';
    }
    
    // 베트남어 키워드 감지
    if (_containsVietnameseKeywords(lower)) {
      return 'vi';
    }
    
    // 태국어 감지 (태국 문자: 0E00-0E7F)
    if (RegExp(r'[\u{0E00}-\u{0E7F}]', unicode: true).hasMatch(text)) {
      return 'th';
    }
    
    // 인도네시아어 키워드 감지
    if (_containsIndonesianKeywords(lower)) {
      return 'id';
    }
    
    // 힌디어 감지 (데바나가리 문자: 0900-097F)
    if (RegExp(r'[\u{0900}-\u{097F}]', unicode: true).hasMatch(text)) {
      return 'hi';
    }
    
    // 네덜란드어 키워드 감지
    if (_containsDutchKeywords(lower)) {
      return 'nl';
    }
    
    // 폴란드어 특수 문자 감지
    if (lower.contains('ą') || lower.contains('ć') || lower.contains('ę') || 
        lower.contains('ł') || lower.contains('ń') || lower.contains('ś') || 
        lower.contains('ź') || lower.contains('ż')) {
      return 'pl';
    }
    
    // 스웨덴어 키워드 감지
    if (_containsSwedishKeywords(lower)) {
      return 'sv';
    }
    
    // 타갈로그어 키워드 감지
    if (_containsTagalogKeywords(lower)) {
      return 'tl';
    }
    
    // 터키어 특수 문자 감지
    if (lower.contains('ğ') || lower.contains('ı') || lower.contains('ş')) {
      return 'tr';
    }
    
    // 우르두어 감지 (아랍 문자 + 우르두 특수)
    if (RegExp(r'[\u{0600}-\u{06FF}]', unicode: true).hasMatch(text) &&
        (text.contains('ہ') || text.contains('ے') || text.contains('ں'))) {
      return 'ur';
    }
    
    // 말레이시아어 키워드 감지
    if (_containsMalayKeywords(lower)) {
      return 'ms';
    }
    
    // 이탈리아어 키워드 감지
    if (_containsItalianKeywords(lower)) {
      return 'it';
    }
    
    // 스페인어 키워드 감지
    if (_containsSpanishKeywords(lower)) {
      return 'es';
    }
    
    // 프랑스어 키워드 감지
    if (_containsFrenchKeywords(lower)) {
      return 'fr';
    }
    
    // 기본값: 영어
    return 'en';
  }
  
  /// 지원되는 언어 목록
  List<String> getSupportedLanguages() {
    return ['en', 'ko', 'es', 'fr', 'de', 'it', 'pt', 'ja', 'zh', 'ru', 'ar', 'ms', 'vi', 'th', 'id', 'hi', 'nl', 'pl', 'sv', 'tl', 'tr', 'ur'];
  }
  
  /// 언어 코드를 언어 이름으로 변환
  String getLanguageName(String code) {
    switch (code) {
      case 'en': return 'English';
      case 'ko': return '한국어';
      case 'es': return 'Español';
      case 'fr': return 'Français';
      case 'de': return 'Deutsch';
      case 'it': return 'Italiano';
      case 'pt': return 'Português';
      case 'ja': return '日本語';
      case 'zh': return '中文';
      case 'ru': return 'Русский';
      case 'ar': return 'العربية';
      case 'ms': return 'Bahasa Melayu';
      case 'vi': return 'Tiếng Việt';
      case 'th': return 'ภาษาไทย';
      case 'id': return 'Bahasa Indonesia';
      case 'hi': return 'हिन्दी';
      case 'nl': return 'Nederlands';
      case 'pl': return 'Polski';
      case 'sv': return 'Svenska';
      case 'tl': return 'Tagalog';
      case 'tr': return 'Türkçe';
      case 'ur': return 'اردو';
      default: return 'Unknown';
    }
  }
  
  // 언어별 키워드 감지 헬퍼 메서드
  
  bool _containsItalianKeywords(String text) {
    final keywords = ['ciao', 'grazie', 'prego', 'scusi', 'bene', 'molto',
                     'tutto', 'quando', 'dove', 'perché', 'anche'];
    return keywords.any((word) => text.contains(word));
  }
  
  bool _containsSpanishKeywords(String text) {
    final keywords = ['hola', 'gracias', 'por favor', 'buenos', 'días',
                     'muy', 'pero', 'cuando', 'donde', 'porque', 'cómo',
                     'estás', 'estar', 'estoy', 'eres', 'soy', 'tengo',
                     'quiero', 'puedo', 'vamos', 'ahora', 'mañana'];
    return keywords.any((word) => text.contains(word));
  }
  
  bool _containsFrenchKeywords(String text) {
    final keywords = ['bonjour', 'merci', 'très', 'bien', 'mais', 'avec',
                     'pour', 'dans', 'sur', 'tout', 'plus'];
    return keywords.any((word) => text.contains(word));
  }
  
  bool _containsMalayKeywords(String text) {
    final keywords = ['apa', 'khabar', 'terima', 'kasih', 'selamat', 'pagi',
                     'saya', 'kamu', 'anda', 'boleh', 'tidak', 'ya',
                     'bagaimana', 'bila', 'siapa', 'kenapa', 'mana',
                     'sudah', 'akan', 'ini', 'itu', 'dengan', 'untuk'];
    return keywords.any((word) => text.contains(word));
  }
  
  bool _containsVietnameseKeywords(String text) {
    final keywords = ['xin chào', 'cảm ơn', 'tạm biệt', 'chào', 'bạn',
                     'tôi', 'anh', 'chị', 'em', 'có', 'không', 'được',
                     'rất', 'và', 'hoặc', 'nhưng', 'vì', 'nếu', 'thì',
                     'này', 'đó', 'ở', 'với', 'của', 'cho', 'về',
                     'khỏe', 'vui', 'buồn', 'thế nào', 'bao giờ'];
    return keywords.any((word) => text.contains(word));
  }
  
  bool _containsIndonesianKeywords(String text) {
    final keywords = ['halo', 'terima kasih', 'selamat', 'pagi', 'siang',
                     'malam', 'saya', 'kamu', 'anda', 'apa', 'bagaimana',
                     'di mana', 'kapan', 'siapa', 'mengapa', 'baik',
                     'tidak', 'ya', 'bisa', 'mau', 'ada', 'adalah',
                     'ini', 'itu', 'dengan', 'untuk', 'dari', 'ke'];
    return keywords.any((word) => text.contains(word));
  }
  
  bool _containsDutchKeywords(String text) {
    final keywords = ['hallo', 'hoi', 'dag', 'dank je', 'bedankt', 'alsjeblieft',
                     'ja', 'nee', 'ik', 'jij', 'je', 'u', 'wij', 'zij',
                     'wat', 'waar', 'wanneer', 'wie', 'waarom', 'hoe',
                     'met', 'van', 'voor', 'naar', 'bij', 'op', 'in'];
    return keywords.any((word) => text.contains(word));
  }
  
  bool _containsSwedishKeywords(String text) {
    final keywords = ['hej', 'hallo', 'tack', 'varsågod', 'ja', 'nej',
                     'jag', 'du', 'vi', 'de', 'han', 'hon', 'vad',
                     'var', 'när', 'vem', 'varför', 'hur', 'med',
                     'från', 'till', 'på', 'i', 'för', 'och', 'eller'];
    return keywords.any((word) => text.contains(word));
  }
  
  bool _containsTagalogKeywords(String text) {
    final keywords = ['kumusta', 'salamat', 'paalam', 'oo', 'hindi',
                     'ako', 'ikaw', 'ka', 'siya', 'kami', 'tayo',
                     'ano', 'saan', 'kailan', 'sino', 'bakit', 'paano',
                     'sa', 'ng', 'ang', 'mga', 'para', 'at', 'o'];
    return keywords.any((word) => text.contains(word));
  }
  
  /// 혼합 언어 감지 (여러 언어가 섞인 경우)
  Map<String, double> detectMixedLanguages(String text) {
    final scores = <String, double>{};
    
    // 각 언어별 점수 계산
    if (RegExp(r'[\u{AC00}-\u{D7AF}]', unicode: true).hasMatch(text)) {
      final koreanChars = RegExp(r'[\u{AC00}-\u{D7AF}]', unicode: true)
          .allMatches(text).length;
      scores['ko'] = koreanChars / text.length;
    }
    
    if (RegExp(r'[a-zA-Z]').hasMatch(text)) {
      final englishChars = RegExp(r'[a-zA-Z]').allMatches(text).length;
      scores['en'] = englishChars / text.length;
    }
    
    // 정규화
    final total = scores.values.fold(0.0, (a, b) => a + b);
    if (total > 0) {
      scores.forEach((key, value) {
        scores[key] = value / total;
      });
    }
    
    return scores;
  }
}