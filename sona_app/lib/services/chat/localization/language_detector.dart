/// Language detector using character scripts and keywords
class LanguageDetector {
  /// Detect language from text using character scripts
  static String? detectLanguageFromText(String text) {
    if (text.isEmpty) return null;
    
    // Check for unique scripts (2+ characters minimum)
    
    // Thai script (ก-๛)
    if (RegExp(r'[\u0E01-\u0E5B]{2,}').hasMatch(text)) {
      return 'TH';
    }
    
    // Arabic script (؀-ۿ)
    if (RegExp(r'[\u0600-\u06FF]{2,}').hasMatch(text)) {
      return 'AR';
    }
    
    // Hindi/Devanagari script (ऀ-ॿ)
    if (RegExp(r'[\u0900-\u097F]{2,}').hasMatch(text)) {
      return 'HI';
    }
    
    // Chinese characters (CJK Unified Ideographs)
    if (RegExp(r'[\u4E00-\u9FFF]{2,}').hasMatch(text)) {
      return 'ZH';
    }
    
    // Japanese Hiragana (ぁ-ゖ)
    if (RegExp(r'[\u3041-\u3096]{2,}').hasMatch(text)) {
      return 'JA';
    }
    
    // Japanese Katakana (ァ-ヺ)
    if (RegExp(r'[\u30A1-\u30FA]{2,}').hasMatch(text)) {
      return 'JA';
    }
    
    // Cyrillic script (А-я)
    if (RegExp(r'[\u0400-\u04FF]{2,}').hasMatch(text)) {
      return 'RU';
    }
    
    // Urdu script (Arabic + extended)
    if (RegExp(r'[\u0600-\u06FF\u0750-\u077F]{2,}').hasMatch(text) && 
        (text.contains('کیا') || text.contains('ہے') || text.contains('میں'))) {
      return 'UR';
    }
    
    // Korean Hangul (가-힣)
    if (RegExp(r'[\uAC00-\uD7AF]{2,}').hasMatch(text)) {
      return 'KO';
    }
    
    // For Latin-based languages, check keywords
    final lowerText = text.toLowerCase();
    
    // Vietnamese keywords
    if (_containsVietnameseKeywords(lowerText)) {
      return 'VI';
    }
    
    // Indonesian keywords
    if (_containsIndonesianKeywords(lowerText)) {
      return 'ID';
    }
    
    // Malay keywords (similar to Indonesian but with some differences)
    if (_containsMalayKeywords(lowerText)) {
      return 'MS';
    }
    
    // Spanish keywords
    if (_containsSpanishKeywords(lowerText)) {
      return 'ES';
    }
    
    // French keywords
    if (_containsFrenchKeywords(lowerText)) {
      return 'FR';
    }
    
    // German keywords
    if (_containsGermanKeywords(lowerText)) {
      return 'DE';
    }
    
    // Italian keywords
    if (_containsItalianKeywords(lowerText)) {
      return 'IT';
    }
    
    // Portuguese keywords
    if (_containsPortugueseKeywords(lowerText)) {
      return 'PT';
    }
    
    // Turkish keywords
    if (_containsTurkishKeywords(lowerText)) {
      return 'TR';
    }
    
    // Dutch keywords
    if (_containsDutchKeywords(lowerText)) {
      return 'NL';
    }
    
    // Swedish keywords
    if (_containsSwedishKeywords(lowerText)) {
      return 'SV';
    }
    
    // Polish keywords
    if (_containsPolishKeywords(lowerText)) {
      return 'PL';
    }
    
    // Tagalog/Filipino keywords
    if (_containsTagalogKeywords(lowerText)) {
      return 'TL';
    }
    
    // English keywords (last check as fallback for Latin script)
    if (_containsEnglishKeywords(lowerText)) {
      return 'EN';
    }
    
    return null;
  }
  
  static bool _containsVietnameseKeywords(String text) {
    final keywords = ['mệt', 'quá', 'rồi', 'làm', 'xin chào', 'cảm ơn', 'tôi', 'bạn', 'có', 'không', 'được', 'này', 'đó'];
    return keywords.any((word) => text.contains(word));
  }
  
  static bool _containsIndonesianKeywords(String text) {
    final keywords = ['aku', 'saya', 'kerja', 'lembur', 'selamat', 'terima kasih', 'bagaimana', 'kabar', 'sudah', 'belum', 'bisa', 'tidak'];
    return keywords.any((word) => text.contains(word));
  }
  
  static bool _containsMalayKeywords(String text) {
    final keywords = ['hai', 'terima kasih', 'kerja', 'penat', 'apa khabar', 'saya', 'awak', 'boleh', 'tak', 'dah', 'macam mana'];
    return keywords.any((word) => text.contains(word));
  }
  
  static bool _containsEnglishKeywords(String text) {
    final keywords = ['hello', 'thanks', 'tired', 'how are you', 'work', 'today', 'good', 'morning', 'night', 'what', 'where', 'when', 'why'];
    return keywords.any((word) => text.contains(word));
  }
  
  static bool _containsSpanishKeywords(String text) {
    final keywords = ['hola', 'gracias', 'trabajo', 'cansado', 'cómo', 'estás', 'buenos', 'días', 'qué', 'donde', 'cuando', 'por qué'];
    return keywords.any((word) => text.contains(word));
  }
  
  static bool _containsFrenchKeywords(String text) {
    final keywords = ['bonjour', 'merci', 'travail', 'fatigué', 'comment', 'allez', 'vous', 'bien', 'aujourd', 'quoi', 'où', 'quand', 'pourquoi'];
    return keywords.any((word) => text.contains(word));
  }
  
  static bool _containsGermanKeywords(String text) {
    final keywords = ['hallo', 'danke', 'arbeit', 'müde', 'wie geht', 'guten', 'tag', 'morgen', 'was', 'wo', 'wann', 'warum'];
    return keywords.any((word) => text.contains(word));
  }
  
  static bool _containsItalianKeywords(String text) {
    final keywords = ['ciao', 'grazie', 'lavoro', 'stanco', 'come', 'stai', 'buon', 'giorno', 'sera', 'cosa', 'dove', 'quando', 'perché'];
    return keywords.any((word) => text.contains(word));
  }
  
  static bool _containsPortugueseKeywords(String text) {
    final keywords = ['olá', 'obrigado', 'trabalho', 'cansado', 'como', 'está', 'bom', 'dia', 'noite', 'que', 'onde', 'quando', 'por quê'];
    return keywords.any((word) => text.contains(word));
  }
  
  static bool _containsTurkishKeywords(String text) {
    final keywords = ['merhaba', 'teşekkür', 'yorgun', 'nasılsın', 'günaydın', 'iyi', 'akşam', 'ne', 'nerede', 'ne zaman', 'neden'];
    return keywords.any((word) => text.contains(word));
  }
  
  static bool _containsDutchKeywords(String text) {
    final keywords = ['hallo', 'bedankt', 'werk', 'moe', 'hoe gaat', 'goedemorgen', 'dag', 'wat', 'waar', 'wanneer', 'waarom'];
    return keywords.any((word) => text.contains(word));
  }
  
  static bool _containsSwedishKeywords(String text) {
    final keywords = ['hej', 'tack', 'arbete', 'trött', 'hur mår', 'god', 'morgon', 'kväll', 'vad', 'var', 'när', 'varför'];
    return keywords.any((word) => text.contains(word));
  }
  
  static bool _containsPolishKeywords(String text) {
    final keywords = ['cześć', 'dziękuję', 'praca', 'zmęczony', 'jak się', 'dzień dobry', 'dobranoc', 'co', 'gdzie', 'kiedy', 'dlaczego'];
    return keywords.any((word) => text.contains(word));
  }
  
  static bool _containsTagalogKeywords(String text) {
    final keywords = ['kumusta', 'salamat', 'trabaho', 'pagod', 'magandang', 'umaga', 'gabi', 'ano', 'saan', 'kailan', 'bakit'];
    return keywords.any((word) => text.contains(word));
  }
}