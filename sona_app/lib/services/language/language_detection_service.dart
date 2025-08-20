/// 언어 감지 서비스
/// 
/// 사용자 입력 텍스트의 언어를 감지하여 적절한 감정 분석을 지원
class LanguageDetectionService {
  // 싱글톤 패턴
  static final LanguageDetectionService _instance = LanguageDetectionService._internal();
  factory LanguageDetectionService() => _instance;
  LanguageDetectionService._internal();

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
    return ['en', 'ko', 'es', 'fr', 'de', 'it', 'pt', 'ja', 'zh', 'ru', 'ar', 'ms'];
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