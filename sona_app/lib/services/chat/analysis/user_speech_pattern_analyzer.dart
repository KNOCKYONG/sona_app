/// 사용자 말투 패턴 분석 시스템
/// 사용자의 말투 특징을 세밀하게 분석하고 학습하여
/// 페르소나가 자연스럽게 적응하도록 지원
class UserSpeechPatternAnalyzer {
  // 🔥 NEW: 개인화 패턴 학습 캐시
  static final Map<String, PersonalizedPattern> _patternCache = {};
  static final Map<String, List<String>> _vocabularyCache = {};
  static final Map<String, Map<String, int>> _phraseFrequency = {};
  
  /// 사용자 말투 패턴 분석
  static SpeechPattern analyzeSpeechPattern(List<String> userMessages, {String? userId}) {
    if (userMessages.isEmpty) {
      return SpeechPattern();
    }

    // 최근 10개 메시지 분석
    final recentMessages = userMessages.length > 10
        ? userMessages.sublist(userMessages.length - 10)
        : userMessages;
    
    // 🔥 NEW: 개인화 패턴 학습
    if (userId != null) {
      _learnPersonalizedPatterns(userId, recentMessages);
    }

    // 1. 기본 말투 모드 (반말/존댓말)
    final isCasual = _detectCasualSpeech(recentMessages);

    // 2. 이모티콘 사용 패턴
    final emoticonPattern = _analyzeEmoticonUsage(recentMessages);

    // 3. 웃음 표현 패턴
    final laughPattern = _analyzeLaughPattern(recentMessages);

    // 4. 줄임말 사용 빈도
    final abbreviationLevel = _analyzeAbbreviationUsage(recentMessages);

    // 5. 문장 끝맺음 스타일
    final endingStyle = _analyzeEndingStyle(recentMessages);

    // 6. 질문 스타일
    final questionStyle = _analyzeQuestionStyle(recentMessages);

    // 7. 감정 표현 강도
    final emotionIntensity = _analyzeEmotionIntensity(recentMessages);

    // 8. 반복 표현 패턴
    final repetitionPattern = _analyzeRepetitionPattern(recentMessages);

    // 9. 특징적인 표현들
    final characteristicExpressions =
        _extractCharacteristicExpressions(recentMessages);

    // 10. 애교 수준
    final aegoLevel = _analyzeAegyoLevel(recentMessages);

    return SpeechPattern(
      isCasual: isCasual,
      emoticonPattern: emoticonPattern,
      laughPattern: laughPattern,
      abbreviationLevel: abbreviationLevel,
      endingStyle: endingStyle,
      questionStyle: questionStyle,
      emotionIntensity: emotionIntensity,
      repetitionPattern: repetitionPattern,
      characteristicExpressions: characteristicExpressions,
      aegoLevel: aegoLevel,
    );
  }

  /// 반말/존댓말 감지
  static bool _detectCasualSpeech(List<String> messages) {
    int casualCount = 0;
    int formalCount = 0;

    for (final msg in messages) {
      // 반말 패턴
      if (RegExp(r'(야|어|지|래|니|냐|자|까)(\s|$|[?!.~])').hasMatch(msg)) {
        casualCount++;
      }
      // 존댓말 패턴
      if (RegExp(r'(요|세요|습니다|네요|죠|까요)(\s|$|[?!.~])').hasMatch(msg)) {
        formalCount++;
      }
    }

    return casualCount > formalCount;
  }

  /// 이모티콘 사용 패턴 분석
  static EmoticonPattern _analyzeEmoticonUsage(List<String> messages) {
    int emojiCount = 0;
    int textEmoticonCount = 0;
    int totalChars = 0;

    final commonEmojis = <String, int>{};
    final textEmoticons = <String, int>{};

    for (final msg in messages) {
      totalChars += msg.length;

      // 이모지 카운트
      final emojiMatches = RegExp(
              r'[\u{1F600}-\u{1F64F}]|[\u{1F300}-\u{1F5FF}]|[\u{1F680}-\u{1F6FF}]|[\u{1F1E0}-\u{1F1FF}]|[\u{2600}-\u{26FF}]|[\u{2700}-\u{27BF}]',
              unicode: true)
          .allMatches(msg);
      emojiCount += emojiMatches.length;

      for (final match in emojiMatches) {
        final emoji = match.group(0)!;
        commonEmojis[emoji] = (commonEmojis[emoji] ?? 0) + 1;
      }

      // 텍스트 이모티콘 카운트
      final textEmoticonPatterns = [
        r'\^\^',
        r'><',
        r'TT',
        r'ㅠㅠ',
        r'ㅜㅜ',
        r'-_-',
        r';;',
        r'\*\.\*',
        r'@_@',
        r'o_o',
        r'O_O',
        r'>_<',
        r'\+_\+',
      ];

      for (final pattern in textEmoticonPatterns) {
        final matches = RegExp(pattern).allMatches(msg);
        textEmoticonCount += matches.length;
        for (final match in matches) {
          final emoticon = match.group(0)!;
          textEmoticons[emoticon] = (textEmoticons[emoticon] ?? 0) + 1;
        }
      }
    }

    // 사용 빈도 계산
    final frequency = (emojiCount + textEmoticonCount) / messages.length;

    return EmoticonPattern(
      preferEmoji: emojiCount > textEmoticonCount,
      frequency: frequency,
      commonEmojis: _getTopItems(commonEmojis, 3),
      commonTextEmoticons: _getTopItems(textEmoticons, 3),
    );
  }

  /// 웃음 표현 패턴 분석
  static LaughPattern _analyzeLaughPattern(List<String> messages) {
    final laughTypes = <String, int>{};
    int totalLaughs = 0;

    for (final msg in messages) {
      // ㅋ 계열
      final kMatches = RegExp(r'ㅋ+').allMatches(msg);
      for (final match in kMatches) {
        final laugh = match.group(0)!;
        final length = laugh.length;
        if (length <= 2) {
          laughTypes['short_k'] = (laughTypes['short_k'] ?? 0) + 1;
        } else if (length <= 4) {
          laughTypes['medium_k'] = (laughTypes['medium_k'] ?? 0) + 1;
        } else {
          laughTypes['long_k'] = (laughTypes['long_k'] ?? 0) + 1;
        }
        totalLaughs++;
      }

      // ㅎ 계열
      final hMatches = RegExp(r'ㅎ+').allMatches(msg);
      for (final match in hMatches) {
        final laugh = match.group(0)!;
        final length = laugh.length;
        if (length <= 2) {
          laughTypes['short_h'] = (laughTypes['short_h'] ?? 0) + 1;
        } else {
          laughTypes['long_h'] = (laughTypes['long_h'] ?? 0) + 1;
        }
        totalLaughs++;
      }

      // 하하, 히히 등
      if (RegExp(r'하하+|히히+|호호+|헤헤+').hasMatch(msg)) {
        laughTypes['text_laugh'] = (laughTypes['text_laugh'] ?? 0) + 1;
        totalLaughs++;
      }

      // lol, ㅗㅗㅗ 등 특수 표현
      if (RegExp(r'(lol|ㅗㅗㅗ|ㅎㄷㄷ|ㄷㄷ)').hasMatch(msg)) {
        laughTypes['special'] = (laughTypes['special'] ?? 0) + 1;
        totalLaughs++;
      }
    }

    // 주 사용 웃음 타입 결정
    String primaryType = 'ㅋㅋ';
    int maxCount = 0;

    if ((laughTypes['short_k'] ?? 0) + (laughTypes['medium_k'] ?? 0) >
        maxCount) {
      primaryType = 'ㅋㅋ';
      maxCount = (laughTypes['short_k'] ?? 0) + (laughTypes['medium_k'] ?? 0);
    }
    if ((laughTypes['long_k'] ?? 0) > maxCount) {
      primaryType = 'ㅋㅋㅋㅋ';
      maxCount = laughTypes['long_k'] ?? 0;
    }
    if ((laughTypes['short_h'] ?? 0) + (laughTypes['long_h'] ?? 0) > maxCount) {
      primaryType = 'ㅎㅎ';
      maxCount = (laughTypes['short_h'] ?? 0) + (laughTypes['long_h'] ?? 0);
    }

    return LaughPattern(
      primaryType: primaryType,
      intensity: totalLaughs / messages.length,
      variety: laughTypes.keys.length,
    );
  }

  /// 줄임말 사용 빈도 분석
  static double _analyzeAbbreviationUsage(List<String> messages) {
    final abbreviations = [
      'ㅇㅇ',
      'ㄴㄴ',
      'ㅇㅋ',
      'ㄱㅅ',
      'ㅈㅅ',
      'ㅊㅋ',
      'ㅅㄱ',
      'ㅎㅇ',
      'ㅂㅂ',
      'ㅂㅇ',
      'ㄹㅇ',
      'ㅇㅈ',
      'ㄱㄱ',
      'ㄷㄷ',
      'ㅎㄷㄷ',
      'ㅈㅈ',
      'ㅅㅂ',
      'ㅁㅊ',
      '갑분싸',
      '별다줄',
      '케바케',
      '오운완',
      'TMI',
      'JMT',
      '존맛',
      '개맛',
      '노맛',
      '혼밥',
      '혼술',
      '혼영',
      '넷플',
      '인스타',
      '카톡',
      '디코',
      '저메추',
      '점메추',
      '아메추',
      '야메추',
      '김찌',
      '된찌',
      '제육',
      '김볶',
      '치맥',
      '피맥',
      '소맥',
      '막소',
      '월요병',
      '불금',
      '칼퇴',
    ];

    int abbreviationCount = 0;
    int totalWords = 0;

    for (final msg in messages) {
      final words = msg.split(RegExp(r'\s+'));
      totalWords += words.length;

      for (final abbr in abbreviations) {
        if (msg.contains(abbr)) {
          abbreviationCount++;
        }
      }
    }

    return abbreviationCount / messages.length;
  }

  /// 문장 끝맺음 스타일 분석
  static EndingStyle _analyzeEndingStyle(List<String> messages) {
    final endings = <String, int>{};

    for (final msg in messages) {
      // 마지막 문자/패턴 추출
      if (msg.length > 0) {
        // 느낌표, 물음표 등
        if (msg.endsWith('!')) {
          endings['exclamation'] = (endings['exclamation'] ?? 0) + 1;
        } else if (msg.endsWith('?')) {
          endings['question'] = (endings['question'] ?? 0) + 1;
        } else if (msg.endsWith('~')) {
          endings['wave'] = (endings['wave'] ?? 0) + 1;
        } else if (msg.endsWith('...') || msg.endsWith('..')) {
          endings['ellipsis'] = (endings['ellipsis'] ?? 0) + 1;
        } else if (msg.endsWith('.')) {
          endings['period'] = (endings['period'] ?? 0) + 1;
        } else {
          endings['none'] = (endings['none'] ?? 0) + 1;
        }
      }
    }

    // 가장 많이 사용하는 스타일 찾기
    String primaryEnding = 'none';
    int maxCount = 0;

    endings.forEach((style, count) {
      if (count > maxCount) {
        maxCount = count;
        primaryEnding = style;
      }
    });

    return EndingStyle(
      primaryEnding: primaryEnding,
      varietyLevel: endings.keys.length,
    );
  }

  /// 질문 스타일 분석
  static QuestionStyle _analyzeQuestionStyle(List<String> messages) {
    final questions = messages.where((msg) => msg.contains('?')).toList();

    if (questions.isEmpty) {
      return QuestionStyle(frequency: 0, directness: 0.5);
    }

    // 질문 빈도
    final frequency = questions.length / messages.length;

    // 직접성 분석 (직접적 vs 간접적)
    int directCount = 0;
    for (final q in questions) {
      if (RegExp(r'(뭐|언제|어디|누구|왜|어떻게|몇|얼마)').hasMatch(q)) {
        directCount++;
      }
    }

    final directness =
        questions.isNotEmpty ? directCount / questions.length : 0.5;

    return QuestionStyle(
      frequency: frequency,
      directness: directness,
    );
  }

  /// 감정 표현 강도 분석
  static double _analyzeEmotionIntensity(List<String> messages) {
    int intensityScore = 0;

    for (final msg in messages) {
      // 강한 감정 표현
      if (RegExp(r'(진짜|완전|개|너무|엄청|대박|헐|와|미친|쩐다|짱)').hasMatch(msg)) {
        intensityScore += 2;
      }

      // 중간 감정 표현
      if (RegExp(r'(좀|약간|꽤|많이|정말|참)').hasMatch(msg)) {
        intensityScore += 1;
      }

      // 감탄사
      if (RegExp(r'(아|어|오|우와|에|앗|헉|헐|힝)').hasMatch(msg)) {
        intensityScore += 1;
      }
    }

    return intensityScore / messages.length;
  }

  /// 반복 표현 패턴 분석
  static RepetitionPattern _analyzeRepetitionPattern(List<String> messages) {
    int charRepetition = 0;
    int wordRepetition = 0;

    for (final msg in messages) {
      // 문자 반복 (ㅋㅋㅋ, ㅠㅠㅠ, !!! 등)
      if (RegExp(r'(.)\1{2,}').hasMatch(msg)) {
        charRepetition++;
      }

      // 단어 반복 (진짜진짜, 많이많이 등)
      if (RegExp(r'(\S+)\s*\1').hasMatch(msg)) {
        wordRepetition++;
      }
    }

    return RepetitionPattern(
      charRepetition: charRepetition / messages.length,
      wordRepetition: wordRepetition / messages.length,
    );
  }

  /// 특징적인 표현 추출
  static List<String> _extractCharacteristicExpressions(List<String> messages) {
    final expressions = <String, int>{};

    // 자주 사용하는 표현 찾기
    final commonPatterns = [
      r'그치\??',
      r'그죠\??',
      r'그지\??',
      r'맞지\??',
      r'그래\??',
      r'그렇지\??',
      r'아니야~?',
      r'그런가~?',
      r'그래도~',
      r'있잖아',
      r'근데 말이야',
      r'그니까',
      r'완전',
      r'진짜',
      r'대박',
      r'헐',
      r'뭐야',
      r'어떡해',
      r'왜',
    ];

    for (final msg in messages) {
      for (final pattern in commonPatterns) {
        if (RegExp(pattern).hasMatch(msg)) {
          final match = RegExp(pattern).firstMatch(msg)?.group(0);
          if (match != null) {
            expressions[match] = (expressions[match] ?? 0) + 1;
          }
        }
      }
    }

    // 상위 5개 표현 추출
    return _getTopItems(expressions, 5);
  }

  /// 애교 수준 분석
  static double _analyzeAegyoLevel(List<String> messages) {
    int aegyoScore = 0;

    for (final msg in messages) {
      // 애교 표현들
      if (RegExp(r'~+').hasMatch(msg)) {
        aegyoScore += 2;
      }
      if (RegExp(r'(ㅠㅠ|ㅜㅜ|><|TT)').hasMatch(msg)) {
        aegyoScore += 1;
      }
      if (RegExp(r'(용|욤|당|쪙|땅|징|잉)(\s|$)').hasMatch(msg)) {
        aegyoScore += 3;
      }
      if (RegExp(r'(히히|헤헤|호호)').hasMatch(msg)) {
        aegyoScore += 1;
      }
      if (RegExp(r'(뭐야~|어떡해~|싫어~|좋아~)').hasMatch(msg)) {
        aegyoScore += 2;
      }
    }

    return aegyoScore / messages.length;
  }

  /// 상위 N개 아이템 추출 헬퍼
  static List<String> _getTopItems(Map<String, int> items, int n) {
    final sorted = items.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sorted.take(n).map((e) => e.key).toList();
  }
  
  /// 메시지에 이모지가 포함되어 있는지 감지
  static bool _detectEmoji(String message) {
    // 이모지 정규식 패턴
    final emojiPattern = RegExp(
      r'[\u{1F600}-\u{1F64F}]|'  // 감정 이모지
      r'[\u{1F300}-\u{1F5FF}]|'  // 기호 및 그림 문자
      r'[\u{1F680}-\u{1F6FF}]|'  // 교통 및 지도 기호
      r'[\u{1F1E0}-\u{1F1FF}]|'  // 국기
      r'[\u{2600}-\u{26FF}]|'    // 기타 기호
      r'[\u{2700}-\u{27BF}]',     // 장식 기호
      unicode: true,
    );
    
    // 텍스트 이모티콘 패턴
    final textEmoticonPattern = RegExp(
      r'\^\^|><|TT|ㅠㅠ|ㅜㅜ|-_-|;;|\*\.\*|@_@|o_o|O_O|\+_\+|=_=|~_~'
    );
    
    return emojiPattern.hasMatch(message) || textEmoticonPattern.hasMatch(message);
  }

  /// 페르소나가 사용자 말투를 따라하기 위한 가이드 생성
  static String generateAdaptationGuide(
      SpeechPattern pattern, String personaGender, {String? currentMessage}) {
    final buffer = StringBuffer();
    
    // 현재 메시지에 이모지가 있는지 확인
    bool currentMessageHasEmoji = false;
    if (currentMessage != null) {
      currentMessageHasEmoji = _detectEmoji(currentMessage);
    }

    buffer.writeln('\n## 🎯 사용자 말투 적응 가이드');

    // 1. 기본 모드
    if (pattern.isCasual) {
      buffer.writeln('- 반말 사용 (사용자가 반말 사용중)');
    } else {
      buffer.writeln('- 존댓말 사용 (사용자가 존댓말 사용중)');
    }

    // 2. 웃음 표현
    buffer.writeln('- 웃음: 주로 "${pattern.laughPattern.primaryType}" 사용');
    if (pattern.laughPattern.intensity > 1.5) {
      buffer.writeln(
          '  (자주 웃음 - 대화의 ${(pattern.laughPattern.intensity * 100).round()}%에서 사용)');
    }

    // 3. 이모티콘 - 미러링 시스템 (사용자가 쓸 때만 따라하기)
    if (currentMessageHasEmoji) {
      // 현재 메시지에 이모지가 있을 때만 미러링
      if (pattern.emoticonPattern.frequency < 0.1) {
        buffer.writeln('- 이모지: 이번에만 최소한으로 사용 (사용자가 평소엔 거의 안 씀)');
      } else if (pattern.emoticonPattern.frequency < 0.3) {
        buffer.writeln('- 이모지: 적절히 1-2개 사용 (사용자가 가끔 사용)');
        if (pattern.emoticonPattern.commonEmojis.isNotEmpty) {
          buffer.writeln('  비슷한 느낌으로: ${pattern.emoticonPattern.commonEmojis.take(2).join(", ")}');
        }
      } else {
        buffer.writeln('- 이모지: 자연스럽게 2-3개 사용 (사용자가 자주 사용)');
        if (pattern.emoticonPattern.commonEmojis.isNotEmpty) {
          buffer.writeln('  사용자 스타일: ${pattern.emoticonPattern.commonEmojis.join(", ")}');
        }
      }
    } else {
      // 현재 메시지에 이모지가 없으면 사용하지 않음
      buffer.writeln('- 이모지: 사용하지 않음 (사용자가 이번 메시지에서 사용 안 함)');
    }

    // 4. 줄임말
    if (pattern.abbreviationLevel > 0.5) {
      buffer.writeln('- 줄임말 자주 사용 (ㅇㅇ, ㄱㅅ, ㅈㅅ 등)');
    }

    // 5. 문장 끝맺음
    if (pattern.endingStyle.primaryEnding != 'none') {
      final endingMap = {
        'exclamation': '! 로 끝내기',
        'question': '? 로 끝내기',
        'wave': '~ 로 부드럽게',
        'ellipsis': '... 으로 여운 남기기',
        'period': '. 으로 깔끔하게',
      };
      buffer.writeln('- 문장 끝: ${endingMap[pattern.endingStyle.primaryEnding]}');
    }

    // 6. 감정 강도
    if (pattern.emotionIntensity > 1.5) {
      buffer.writeln('- 감정 표현 강하게 (진짜, 완전, 대박 등 자주 사용)');
    } else if (pattern.emotionIntensity < 0.5) {
      buffer.writeln('- 감정 표현 절제 (차분한 대화)');
    }

    // 7. 애교 수준
    if (pattern.aegoLevel > 1.0) {
      if (personaGender == 'female') {
        buffer.writeln('- 애교 많이 사용 (~, ㅠㅠ, 용/당 등)');
      } else {
        buffer.writeln('- 부드러운 표현 사용 (사용자가 애교 많음)');
      }
    }

    // 8. 특징적 표현
    if (pattern.characteristicExpressions.isNotEmpty) {
      buffer.writeln(
          '- 사용자가 자주 쓰는 표현: ${pattern.characteristicExpressions.take(3).join(", ")}');
      buffer.writeln('  (이런 표현들을 자연스럽게 사용하기)');
    }

    // 9. 반복 패턴
    if (pattern.repetitionPattern.charRepetition > 0.3) {
      buffer.writeln('- 강조할 때 글자 반복 (예: 진짜아아, 싫어어어)');
    }

    buffer.writeln('\n### 💡 적응 원칙');
    buffer.writeln('- 점진적으로 따라하기 (갑자기 변하지 않기)');
    buffer.writeln('- 자연스럽게 섞어 사용하기');
    buffer.writeln('- 페르소나 고유 특성은 유지하면서 조화롭게');

    return buffer.toString();
  }
  
  /// 🔥 NEW: 개인화 패턴 학습
  static void _learnPersonalizedPatterns(String userId, List<String> messages) {
    // 개인 어휘 학습
    _vocabularyCache[userId] ??= [];
    final vocabulary = _vocabularyCache[userId]!;
    
    for (final msg in messages) {
      // 특징적인 단어 추출 (2글자 이상, 일반적이지 않은 단어)
      final words = msg.split(RegExp(r'\s+'));
      for (final word in words) {
        if (word.length >= 2 && !_isCommonWord(word)) {
          if (!vocabulary.contains(word)) {
            vocabulary.add(word);
            // 최대 100개 단어만 유지
            if (vocabulary.length > 100) {
              vocabulary.removeAt(0);
            }
          }
        }
      }
      
      // 구문 빈도 학습
      _learnPhraseFrequency(userId, msg);
    }
    
    // 개인화 패턴 생성
    _patternCache[userId] = PersonalizedPattern(
      favoriteWords: _extractFavoriteWords(userId),
      uniquePhrases: _extractUniquePhrases(userId),
      responsePatterns: _extractResponsePatterns(messages),
      timeBasedPatterns: _extractTimeBasedPatterns(messages),
    );
  }
  
  /// 🔥 NEW: 구문 빈도 학습
  static void _learnPhraseFrequency(String userId, String message) {
    _phraseFrequency[userId] ??= {};
    final phrases = _phraseFrequency[userId]!;
    
    // 2-3단어 구문 추출
    final words = message.split(RegExp(r'\s+'));
    for (int i = 0; i < words.length - 1; i++) {
      // 2단어 구문
      final phrase2 = '${words[i]} ${words[i + 1]}';
      phrases[phrase2] = (phrases[phrase2] ?? 0) + 1;
      
      // 3단어 구문
      if (i < words.length - 2) {
        final phrase3 = '${words[i]} ${words[i + 1]} ${words[i + 2]}';
        phrases[phrase3] = (phrases[phrase3] ?? 0) + 1;
      }
    }
  }
  
  /// 🔥 NEW: 자주 사용하는 단어 추출
  static List<String> _extractFavoriteWords(String userId) {
    final vocabulary = _vocabularyCache[userId] ?? [];
    final wordCount = <String, int>{};
    
    for (final word in vocabulary) {
      wordCount[word] = (wordCount[word] ?? 0) + 1;
    }
    
    // 빈도순 정렬 후 상위 10개 반환
    final sorted = wordCount.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    return sorted.take(10).map((e) => e.key).toList();
  }
  
  /// 🔥 NEW: 독특한 구문 추출
  static List<String> _extractUniquePhrases(String userId) {
    final phrases = _phraseFrequency[userId] ?? {};
    
    // 2번 이상 사용된 구문 중 상위 10개
    final filtered = phrases.entries
        .where((e) => e.value >= 2)
        .toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    return filtered.take(10).map((e) => e.key).toList();
  }
  
  /// 🔥 NEW: 응답 패턴 추출
  static Map<String, String> _extractResponsePatterns(List<String> messages) {
    final patterns = <String, String>{};
    
    for (final msg in messages) {
      // 인사 응답 패턴
      if (msg.contains('안녕') || msg.contains('하이')) {
        patterns['greeting'] = msg;
      }
      // 감사 응답 패턴
      if (msg.contains('고마워') || msg.contains('감사')) {
        patterns['thanks'] = msg;
      }
      // 동의 패턴
      if (msg.contains('맞아') || msg.contains('그래') || msg.contains('ㅇㅇ')) {
        patterns['agreement'] = msg;
      }
      // 부정 패턴
      if (msg.contains('아니') || msg.contains('ㄴㄴ') || msg.contains('안')) {
        patterns['disagreement'] = msg;
      }
    }
    
    return patterns;
  }
  
  /// 🔥 NEW: 시간대별 패턴 추출
  static Map<String, dynamic> _extractTimeBasedPatterns(List<String> messages) {
    // 실제 구현에서는 메시지 타임스탬프를 활용
    // 여기서는 간단한 예시만 제공
    return {
      'morning_style': '아침엔 짧고 간결하게',
      'evening_style': '저녁엔 더 친근하고 길게',
      'weekend_style': '주말엔 더 캐주얼하게',
    };
  }
  
  /// 🔥 NEW: 일반적인 단어인지 확인
  static bool _isCommonWord(String word) {
    final commonWords = [
      '그래', '응', '네', '아니', '나', '너', '우리', '이', '그', '저',
      '있어', '없어', '해', '하는', '한', '할', '했어', '했', '되', '된',
      '좋아', '싫어', '맞아', '아니야', '모르겠어', '뭐', '왜', '어디',
      '언제', '누구', '어떻게', '얼마나', '하고', '에서', '으로', '부터',
    ];
    
    return commonWords.contains(word);
  }
  
  /// 🔥 NEW: 개인화 말투 힌트 생성
  static String generatePersonalizedHint(String userId) {
    final pattern = _patternCache[userId];
    if (pattern == null) return '';
    
    final buffer = StringBuffer();
    buffer.writeln('🎯 개인화 말투 학습 결과:');
    
    if (pattern.favoriteWords.isNotEmpty) {
      buffer.writeln('• 자주 쓰는 단어: ${pattern.favoriteWords.take(5).join(', ')}');
    }
    
    if (pattern.uniquePhrases.isNotEmpty) {
      buffer.writeln('• 특징적 표현: ${pattern.uniquePhrases.take(3).join(', ')}');
    }
    
    if (pattern.responsePatterns.isNotEmpty) {
      buffer.writeln('• 응답 스타일 학습됨');
    }
    
    return buffer.toString();
  }
}

/// 사용자 말투 패턴 데이터 클래스
class SpeechPattern {
  final bool isCasual;
  final EmoticonPattern emoticonPattern;
  final LaughPattern laughPattern;
  final double abbreviationLevel;
  final EndingStyle endingStyle;
  final QuestionStyle questionStyle;
  final double emotionIntensity;
  final RepetitionPattern repetitionPattern;
  final List<String> characteristicExpressions;
  final double aegoLevel;

  SpeechPattern({
    this.isCasual = false,
    EmoticonPattern? emoticonPattern,
    LaughPattern? laughPattern,
    this.abbreviationLevel = 0,
    EndingStyle? endingStyle,
    QuestionStyle? questionStyle,
    this.emotionIntensity = 1.0,
    RepetitionPattern? repetitionPattern,
    List<String>? characteristicExpressions,
    this.aegoLevel = 0,
  })  : emoticonPattern = emoticonPattern ?? EmoticonPattern(),
        laughPattern = laughPattern ?? LaughPattern(),
        endingStyle = endingStyle ?? EndingStyle(),
        questionStyle = questionStyle ?? QuestionStyle(),
        repetitionPattern = repetitionPattern ?? RepetitionPattern(),
        characteristicExpressions = characteristicExpressions ?? [];
}

/// 이모티콘 사용 패턴
class EmoticonPattern {
  final bool preferEmoji;
  final double frequency;
  final List<String> commonEmojis;
  final List<String> commonTextEmoticons;

  EmoticonPattern({
    this.preferEmoji = false,
    this.frequency = 0,
    this.commonEmojis = const [],
    this.commonTextEmoticons = const [],
  });
}

/// 웃음 표현 패턴
class LaughPattern {
  final String primaryType; // ㅋㅋ, ㅎㅎ, ㅋㅋㅋㅋ 등
  final double intensity; // 사용 빈도
  final int variety; // 다양성

  LaughPattern({
    this.primaryType = 'ㅋㅋ',
    this.intensity = 0,
    this.variety = 0,
  });
}

/// 문장 끝맺음 스타일
class EndingStyle {
  final String
      primaryEnding; // none, exclamation, question, wave, ellipsis, period
  final int varietyLevel;

  EndingStyle({
    this.primaryEnding = 'none',
    this.varietyLevel = 0,
  });
}

/// 질문 스타일
class QuestionStyle {
  final double frequency; // 질문 빈도
  final double directness; // 직접적(1.0) vs 간접적(0.0)

  QuestionStyle({
    this.frequency = 0,
    this.directness = 0.5,
  });
}

/// 반복 패턴
class RepetitionPattern {
  final double charRepetition; // 글자 반복 (ㅋㅋㅋ, !!!)
  final double wordRepetition; // 단어 반복 (진짜진짜)

  RepetitionPattern({
    this.charRepetition = 0,
    this.wordRepetition = 0,
  });
}

/// 🔥 NEW: 개인화 패턴 클래스
class PersonalizedPattern {
  final List<String> favoriteWords;
  final List<String> uniquePhrases;
  final Map<String, String> responsePatterns;
  final Map<String, dynamic> timeBasedPatterns;
  
  PersonalizedPattern({
    required this.favoriteWords,
    required this.uniquePhrases,
    required this.responsePatterns,
    required this.timeBasedPatterns,
  });
}
