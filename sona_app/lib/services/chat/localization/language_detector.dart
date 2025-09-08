/// Language detection confidence score
class LanguageScore {
  final String language;
  double score = 0.0;
  int matchCount = 0;
  
  LanguageScore(this.language);
}

/// Language detector using character scripts, keywords, and weighted scoring
class LanguageDetector {
  
  /// Detect language from text using character scripts and weighted keyword matching
  static String? detectLanguageFromText(String text, {double minConfidence = 0.3}) {
    if (text.isEmpty) return null;
    
    // First, check for unique scripts (2+ characters minimum) - highest confidence
    
    // Thai script (ก-๛)
    if (RegExp(r'[\u0E01-\u0E5B]{2,}').hasMatch(text)) {
      return 'TH';
    }
    
    // Arabic script (؀-ۿ) - but not Urdu
    if (RegExp(r'[\u0600-\u06FF]{2,}').hasMatch(text) && 
        !text.contains('کیا') && !text.contains('ہے') && !text.contains('میں')) {
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
    
    // Urdu script (Arabic + extended with specific markers)
    if (RegExp(r'[\u0600-\u06FF\u0750-\u077F]{2,}').hasMatch(text) && 
        (text.contains('کیا') || text.contains('ہے') || text.contains('میں'))) {
      return 'UR';
    }
    
    // Korean Hangul (가-힣)
    if (RegExp(r'[\uAC00-\uD7AF]{2,}').hasMatch(text)) {
      return 'KO';
    }
    
    // For Latin-based languages, use weighted scoring system
    final lowerText = text.toLowerCase();
    final scores = <String, LanguageScore>{};
    
    // Check for language-specific characters (adds to confidence)
    final hasVietnameseTones = RegExp(r'[àáảãạèéẻẽẹìíỉĩịòóỏõọùúủũụỳýỷỹỵăâêôơưđ]').hasMatch(lowerText);
    final hasSpanishChars = RegExp(r'[ñáéíóú]').hasMatch(lowerText);
    final hasPortugueseChars = RegExp(r'[ãõçáàâêôú]').hasMatch(lowerText);
    final hasFrenchChars = RegExp(r'[àâéèêëïîôùûç]').hasMatch(lowerText);
    final hasGermanChars = RegExp(r'[äöüß]').hasMatch(lowerText);
    final hasSwedishChars = RegExp(r'[åäö]').hasMatch(lowerText);
    final hasPolishChars = RegExp(r'[ąćęłńóśźż]').hasMatch(lowerText);
    final hasTurkishChars = RegExp(r'[ğıöşüç]').hasMatch(lowerText);
    final hasDutchChars = RegExp(r'[ëï]').hasMatch(lowerText);
    final hasItalianChars = RegExp(r'[àèéìòù]').hasMatch(lowerText);
    
    // Vietnamese (highest priority for tonal marks)
    if (hasVietnameseTones) {
      scores['VI'] = LanguageScore('VI')..score = 5.0;
    }
    _scoreVietnamese(lowerText, scores);
    
    // Indonesian vs Malay disambiguation
    _scoreIndonesian(lowerText, scores);
    _scoreMalay(lowerText, scores);
    
    // Spanish with character boost
    if (hasSpanishChars) {
      scores['ES'] ??= LanguageScore('ES');
      scores['ES']!.score += 2.0;
    }
    _scoreSpanish(lowerText, scores);
    
    // Portuguese with character boost
    if (hasPortugueseChars) {
      scores['PT'] ??= LanguageScore('PT');
      scores['PT']!.score += 2.0;
    }
    _scorePortuguese(lowerText, scores);
    
    // French with character boost
    if (hasFrenchChars) {
      scores['FR'] ??= LanguageScore('FR');
      scores['FR']!.score += 2.0;
    }
    _scoreFrench(lowerText, scores);
    
    // German with character boost
    if (hasGermanChars) {
      scores['DE'] ??= LanguageScore('DE');
      scores['DE']!.score += 2.0;
    }
    _scoreGerman(lowerText, scores);
    
    // Italian with character boost
    if (hasItalianChars) {
      scores['IT'] ??= LanguageScore('IT');
      scores['IT']!.score += 2.0;
    }
    _scoreItalian(lowerText, scores);
    
    // Turkish with character boost
    if (hasTurkishChars) {
      scores['TR'] ??= LanguageScore('TR');
      scores['TR']!.score += 2.0;
    }
    _scoreTurkish(lowerText, scores);
    
    // Dutch with character boost
    if (hasDutchChars) {
      scores['NL'] ??= LanguageScore('NL');
      scores['NL']!.score += 1.0;
    }
    _scoreDutch(lowerText, scores);
    
    // Swedish with character boost
    if (hasSwedishChars) {
      scores['SV'] ??= LanguageScore('SV');
      scores['SV']!.score += 2.0;
    }
    _scoreSwedish(lowerText, scores);
    
    // Polish with character boost
    if (hasPolishChars) {
      scores['PL'] ??= LanguageScore('PL');
      scores['PL']!.score += 2.0;
    }
    _scorePolish(lowerText, scores);
    
    // Tagalog
    _scoreTagalog(lowerText, scores);
    
    // English (check last as fallback)
    _scoreEnglish(lowerText, scores);
    
    // Find language with highest score
    String? bestLanguage;
    double bestScore = 0.0;
    int bestMatchCount = 0;
    
    for (final entry in scores.entries) {
      final score = entry.value;
      // Require at least 2 keyword matches for confidence
      if (score.matchCount >= 2 && score.score > bestScore) {
        bestScore = score.score;
        bestLanguage = entry.key;
        bestMatchCount = score.matchCount;
      }
    }
    
    // Check confidence threshold
    if (bestLanguage != null && bestScore >= minConfidence && bestMatchCount >= 2) {
      return bestLanguage;
    }
    
    // If only 1 match but high score (special characters), still accept
    if (bestLanguage != null && bestScore >= 3.0) {
      return bestLanguage;
    }
    
    return null;
  }
  
  static void _scoreVietnamese(String text, Map<String, LanguageScore> scores) {
    // Unique Vietnamese keywords (high weight)
    final uniqueKeywords = ['mệt', 'quá', 'rồi', 'được', 'này', 'đó', 'xin chào', 'cảm ơn', 'tôi', 'bạn'];
    scores['VI'] ??= LanguageScore('VI');
    
    for (final keyword in uniqueKeywords) {
      if (text.contains(keyword)) {
        scores['VI']!.score += 2.0;
        scores['VI']!.matchCount++;
      }
    }
  }
  
  static void _scoreIndonesian(String text, Map<String, LanguageScore> scores) {
    // Unique Indonesian keywords (distinguishes from Malay)
    final uniqueKeywords = ['aku', 'lembur', 'bagaimana', 'sudah', 'belum', 'bisa', 'tidak'];
    final sharedKeywords = ['saya', 'kerja', 'terima kasih', 'selamat'];
    
    scores['ID'] ??= LanguageScore('ID');
    
    // High weight for unique keywords
    for (final keyword in uniqueKeywords) {
      if (text.contains(keyword)) {
        scores['ID']!.score += 2.0;
        scores['ID']!.matchCount++;
      }
    }
    
    // Lower weight for shared keywords
    for (final keyword in sharedKeywords) {
      if (text.contains(keyword)) {
        scores['ID']!.score += 0.5;
        scores['ID']!.matchCount++;
      }
    }
  }
  
  static void _scoreMalay(String text, Map<String, LanguageScore> scores) {
    // Unique Malay keywords (distinguishes from Indonesian)
    final uniqueKeywords = ['awak', 'penat', 'apa khabar', 'macam mana', 'tak', 'dah', 'boleh'];
    final sharedKeywords = ['hai', 'saya', 'kerja', 'terima kasih'];
    
    scores['MS'] ??= LanguageScore('MS');
    
    // High weight for unique keywords
    for (final keyword in uniqueKeywords) {
      if (text.contains(keyword)) {
        scores['MS']!.score += 2.0;
        scores['MS']!.matchCount++;
      }
    }
    
    // Lower weight for shared keywords
    for (final keyword in sharedKeywords) {
      if (text.contains(keyword)) {
        scores['MS']!.score += 0.5;
        scores['MS']!.matchCount++;
      }
    }
  }
  
  static void _scoreEnglish(String text, Map<String, LanguageScore> scores) {
    // More specific English phrases (avoid generic words)
    final keywords = ['hello', 'thank you', 'how are you', 'tired', 'what\'s', 'i\'m', 'you\'re', 
                     'don\'t', 'can\'t', 'won\'t', 'let\'s', 'please', 'sorry', 'excuse me'];
    scores['EN'] ??= LanguageScore('EN');
    
    for (final keyword in keywords) {
      if (text.contains(keyword)) {
        scores['EN']!.score += 1.5;
        scores['EN']!.matchCount++;
      }
    }
  }
  
  static void _scoreSpanish(String text, Map<String, LanguageScore> scores) {
    // Unique Spanish keywords (avoid Portuguese overlap)
    final uniqueKeywords = ['hola', 'estás', 'qué', 'por qué', 'gracias', 'buenos días', 'adiós', 'dónde'];
    final sharedKeywords = ['trabajo', 'como'];  // Lower weight for shared words
    
    scores['ES'] ??= LanguageScore('ES');
    
    for (final keyword in uniqueKeywords) {
      if (text.contains(keyword)) {
        scores['ES']!.score += 2.0;
        scores['ES']!.matchCount++;
      }
    }
    
    for (final keyword in sharedKeywords) {
      if (text.contains(keyword)) {
        scores['ES']!.score += 0.3;
        scores['ES']!.matchCount++;
      }
    }
  }
  
  static void _scoreFrench(String text, Map<String, LanguageScore> scores) {
    final keywords = ['bonjour', 'merci', 'comment allez', 'vous', 'bien', 'aujourd', 
                     'pourquoi', 'où', 'quand', 's\'il vous plaît', 'je suis', 'fatigué'];
    scores['FR'] ??= LanguageScore('FR');
    
    for (final keyword in keywords) {
      if (text.contains(keyword)) {
        scores['FR']!.score += 2.0;
        scores['FR']!.matchCount++;
      }
    }
  }
  
  static void _scoreGerman(String text, Map<String, LanguageScore> scores) {
    // Unique German keywords (distinguish from Dutch)
    final uniqueKeywords = ['wie geht', 'danke', 'müde', 'warum', 'guten tag', 'auf wiedersehen', 'ich bin'];
    final sharedKeywords = ['arbeit', 'was', 'wo', 'wann'];
    
    scores['DE'] ??= LanguageScore('DE');
    
    for (final keyword in uniqueKeywords) {
      if (text.contains(keyword)) {
        scores['DE']!.score += 2.0;
        scores['DE']!.matchCount++;
      }
    }
    
    for (final keyword in sharedKeywords) {
      if (text.contains(keyword)) {
        scores['DE']!.score += 0.5;
        scores['DE']!.matchCount++;
      }
    }
  }
  
  static void _scoreItalian(String text, Map<String, LanguageScore> scores) {
    // Unique Italian keywords
    final keywords = ['ciao', 'grazie', 'come stai', 'perché', 'buongiorno', 'arrivederci', 
                     'scusi', 'prego', 'stanco', 'dove', 'cosa'];
    scores['IT'] ??= LanguageScore('IT');
    
    for (final keyword in keywords) {
      if (text.contains(keyword)) {
        scores['IT']!.score += 2.0;
        scores['IT']!.matchCount++;
      }
    }
  }
  
  static void _scorePortuguese(String text, Map<String, LanguageScore> scores) {
    // Unique Portuguese keywords (distinguish from Spanish)
    final uniqueKeywords = ['olá', 'obrigado', 'está', 'por quê', 'você', 'estou', 'tchau'];
    final sharedKeywords = ['trabalho', 'como', 'quando'];
    
    scores['PT'] ??= LanguageScore('PT');
    
    for (final keyword in uniqueKeywords) {
      if (text.contains(keyword)) {
        scores['PT']!.score += 2.0;
        scores['PT']!.matchCount++;
      }
    }
    
    for (final keyword in sharedKeywords) {
      if (text.contains(keyword)) {
        scores['PT']!.score += 0.3;
        scores['PT']!.matchCount++;
      }
    }
  }
  
  static void _scoreTurkish(String text, Map<String, LanguageScore> scores) {
    final keywords = ['merhaba', 'teşekkür', 'nasılsın', 'günaydın', 'görüşürüz', 
                     'lütfen', 'özür dilerim', 'yorgun', 'nerede', 'ne zaman'];
    scores['TR'] ??= LanguageScore('TR');
    
    for (final keyword in keywords) {
      if (text.contains(keyword)) {
        scores['TR']!.score += 2.0;
        scores['TR']!.matchCount++;
      }
    }
  }
  
  static void _scoreDutch(String text, Map<String, LanguageScore> scores) {
    // Unique Dutch keywords (distinguish from German)
    final uniqueKeywords = ['bedankt', 'hoe gaat', 'goedemorgen', 'tot ziens', 'alsjeblieft', 'waarom'];
    final sharedKeywords = ['werk', 'wat', 'waar', 'wanneer'];
    
    scores['NL'] ??= LanguageScore('NL');
    
    for (final keyword in uniqueKeywords) {
      if (text.contains(keyword)) {
        scores['NL']!.score += 2.0;
        scores['NL']!.matchCount++;
      }
    }
    
    for (final keyword in sharedKeywords) {
      if (text.contains(keyword)) {
        scores['NL']!.score += 0.5;
        scores['NL']!.matchCount++;
      }
    }
  }
  
  static void _scoreSwedish(String text, Map<String, LanguageScore> scores) {
    final keywords = ['hej', 'tack', 'hur mår', 'god morgon', 'hej då', 'varsågod', 
                     'ursäkta', 'trött', 'varför', 'när'];
    scores['SV'] ??= LanguageScore('SV');
    
    for (final keyword in keywords) {
      if (text.contains(keyword)) {
        scores['SV']!.score += 2.0;
        scores['SV']!.matchCount++;
      }
    }
  }
  
  static void _scorePolish(String text, Map<String, LanguageScore> scores) {
    final keywords = ['cześć', 'dziękuję', 'jak się', 'dzień dobry', 'do widzenia', 
                     'proszę', 'przepraszam', 'zmęczony', 'gdzie', 'kiedy', 'dlaczego'];
    scores['PL'] ??= LanguageScore('PL');
    
    for (final keyword in keywords) {
      if (text.contains(keyword)) {
        scores['PL']!.score += 2.0;
        scores['PL']!.matchCount++;
      }
    }
  }
  
  static void _scoreTagalog(String text, Map<String, LanguageScore> scores) {
    final keywords = ['kumusta', 'salamat', 'magandang umaga', 'paalam', 'pasensya', 
                     'pagod', 'trabaho', 'saan', 'kailan', 'bakit'];
    scores['TL'] ??= LanguageScore('TL');
    
    for (final keyword in keywords) {
      if (text.contains(keyword)) {
        scores['TL']!.score += 2.0;
        scores['TL']!.matchCount++;
      }
    }
  }
}