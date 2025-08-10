import 'package:flutter/material.dart';
import '../../../models/message.dart';

/// 패턴 분석 결과를 담는 클래스
class PatternAnalysis {
  final bool isEmojiOnly;
  final bool containsUrl;
  final bool isIncomplete;
  final bool isSarcasm;
  final bool isPasteError;
  final bool isRepetitiveShort;
  final bool hasVoiceRecognitionError;
  final bool hasDialect;
  final bool isTimeContextQuestion;
  final List<String> multipleQuestions;
  final String? correctedText;
  final String? dialectNormalized;
  final Map<String, String> responseGuidelines;
  final double confidenceScore;

  PatternAnalysis({
    this.isEmojiOnly = false,
    this.containsUrl = false,
    this.isIncomplete = false,
    this.isSarcasm = false,
    this.isPasteError = false,
    this.isRepetitiveShort = false,
    this.hasVoiceRecognitionError = false,
    this.hasDialect = false,
    this.isTimeContextQuestion = false,
    this.multipleQuestions = const [],
    this.correctedText,
    this.dialectNormalized,
    this.responseGuidelines = const {},
    this.confidenceScore = 0.0,
  });

  /// 패턴이 감지되었는지 확인
  bool get hasAnyPattern =>
      isEmojiOnly ||
      containsUrl ||
      isIncomplete ||
      isSarcasm ||
      isPasteError ||
      isRepetitiveShort ||
      hasVoiceRecognitionError ||
      hasDialect ||
      isTimeContextQuestion ||
      multipleQuestions.isNotEmpty;

  /// 디버그 정보 출력
  String toDebugString() {
    final patterns = <String>[];
    if (isEmojiOnly) patterns.add('이모지만');
    if (containsUrl) patterns.add('URL포함');
    if (isIncomplete) patterns.add('미완성');
    if (isSarcasm) patterns.add('빈정거림');
    if (isPasteError) patterns.add('복붙실수');
    if (isRepetitiveShort) patterns.add('단답반복');
    if (hasVoiceRecognitionError) patterns.add('음성인식오류');
    if (hasDialect) patterns.add('사투리');
    if (isTimeContextQuestion) patterns.add('시간문맥');
    if (multipleQuestions.isNotEmpty) patterns.add('복수질문(${multipleQuestions.length}개)');
    
    return patterns.isEmpty ? '패턴없음' : patterns.join(', ');
  }
}

/// 실시간 패턴 분석 서비스
class PatternAnalyzerService {
  static final PatternAnalyzerService _instance = PatternAnalyzerService._internal();
  factory PatternAnalyzerService() => _instance;
  PatternAnalyzerService._internal();

  /// 메시지 패턴 분석 메인 메서드
  PatternAnalysis analyzeMessage({
    required String message,
    List<Message> recentMessages = const [],
    String? personaMbti,
  }) {
    final analysis = PatternAnalysis(
      isEmojiOnly: _isEmojiOnlyMessage(message),
      containsUrl: _containsUrl(message),
      isIncomplete: _isIncompleteMessage(message),
      isSarcasm: _isSarcasm(message, recentMessages),
      isPasteError: _isPasteError(message, recentMessages),
      isRepetitiveShort: _isRepetitiveShortResponses(recentMessages),
      hasVoiceRecognitionError: _hasVoiceRecognitionError(message),
      hasDialect: _hasDialect(message),
      isTimeContextQuestion: _isTimeContextQuestion(message),
      multipleQuestions: _detectMultipleQuestions(message),
      correctedText: _correctVoiceRecognitionErrors(message),
      dialectNormalized: _normalizeDialect(message),
      responseGuidelines: _generateResponseGuidelines(message, recentMessages, personaMbti),
      confidenceScore: _calculateConfidenceScore(message, recentMessages),
    );

    // 디버그 출력
    if (analysis.hasAnyPattern) {
      debugPrint('🔍 패턴 분석: ${analysis.toDebugString()}');
    }

    return analysis;
  }

  /// 응답 가이드라인 생성
  Map<String, String> _generateResponseGuidelines(
    String message,
    List<Message> recentMessages,
    String? personaMbti,
  ) {
    final guidelines = <String, String>{};

    // 이모지만 있는 경우
    if (_isEmojiOnlyMessage(message)) {
      guidelines['emoji_response'] = '이모지에 대해 짧고 재미있게 반응하세요. "ㅋㅋㅋ 뭐야 이 이모지" 같은 스타일';
    }

    // URL이 포함된 경우
    if (_containsUrl(message)) {
      guidelines['url_response'] = 'URL/링크에 대해 관심 표현. "오 뭔데? 재밌어 보인다!" 스타일';
    }

    // 미완성 메시지
    if (_isIncompleteMessage(message)) {
      guidelines['incomplete_response'] = '미완성 메시지 확인. "응? 뭐라고 하려던 거야?" 같은 질문';
    }

    // 빈정거림/비꼬기
    if (_isSarcasm(message, recentMessages)) {
      guidelines['sarcasm_response'] = '빈정거림 감지. 가볍게 받아치거나 진지하게 대응. 상황에 맞게';
    }

    // 복사-붙여넣기 실수
    if (_isPasteError(message, recentMessages)) {
      guidelines['paste_error_response'] = '복붙 실수 의심. "어? 갑자기 이게 뭐야?ㅋㅋ" 같은 반응';
    }

    // 복수 질문
    final questions = _detectMultipleQuestions(message);
    if (questions.length > 1) {
      guidelines['multiple_questions'] = '${questions.length}개 질문 감지. 각각 간단히 답변하세요';
      for (var i = 0; i < questions.length; i++) {
        guidelines['question_${i + 1}'] = questions[i];
      }
    }

    // 반복적인 단답
    if (_isRepetitiveShortResponses(recentMessages)) {
      guidelines['repetitive_short'] = '단답 반복 감지. 대화 활성화 필요. 재미있는 질문이나 화제 전환';
    }

    // 음성 인식 오류
    if (_hasVoiceRecognitionError(message)) {
      final corrected = _correctVoiceRecognitionErrors(message);
      guidelines['voice_error'] = '음성 인식 오류 의심. "$corrected" 의미로 이해하고 답변';
    }

    // 사투리
    if (_hasDialect(message)) {
      guidelines['dialect'] = '사투리 감지. 친근하게 반응. "부산 사람이야?" 같은 관심 표현 가능';
    }

    // 시간 문맥 질문
    if (_isTimeContextQuestion(message)) {
      guidelines['time_context'] = '시간 관련 질문. 현재 시간 기준으로 적절한 답변';
    }

    return guidelines;
  }

  /// 신뢰도 점수 계산
  double _calculateConfidenceScore(String message, List<Message> recentMessages) {
    double score = 1.0;

    // 메시지가 너무 짧으면 신뢰도 감소
    if (message.length < 2) score *= 0.7;
    
    // 특수문자만 있으면 신뢰도 감소
    if (RegExp(r'^[^가-힣a-zA-Z0-9]+$').hasMatch(message)) score *= 0.8;
    
    // 최근 메시지가 없으면 신뢰도 감소
    if (recentMessages.isEmpty) score *= 0.9;

    return score.clamp(0.0, 1.0);
  }

  // ===== 패턴 감지 메서드들 (ChatOrchestrator에서 이동) =====

  /// 이모지만으로 구성된 메시지 감지
  bool _isEmojiOnlyMessage(String message) {
    final cleanedMessage = message.trim();
    if (cleanedMessage.isEmpty) return false;
    
    // 한글, 영문, 숫자가 포함되어 있으면 false
    if (RegExp(r'[가-힣]|[a-zA-Z0-9]').hasMatch(cleanedMessage)) {
      return false;
    }
    
    // ㅋㅋㅋ, ㅎㅎ 같은 한글 자음/모음만 있으면 false
    if (RegExp(r'^[ㄱ-ㅣ]+$').hasMatch(cleanedMessage)) {
      return false;
    }
    
    // 나머지는 이모지로 간주
    return true;
  }

  /// URL/링크 포함 여부 감지
  bool _containsUrl(String message) {
    final urlPatterns = [
      RegExp(r'https?://[^\s]+'),
      RegExp(r'www\.[^\s]+'),
      RegExp(r'[a-zA-Z]+\.(com|net|org|co\.kr|io|ai|dev)[^\s]*'),
    ];
    
    for (final pattern in urlPatterns) {
      if (pattern.hasMatch(message)) {
        return true;
      }
    }
    return false;
  }

  /// 미완성 메시지 감지
  bool _isIncompleteMessage(String message) {
    final trimmed = message.trim();
    
    // 한 글자만 있는 경우
    if (trimmed.length <= 1) {
      return true;
    }
    
    // 미완성 패턴들
    final incompletePatterns = [
      RegExp(r'^[ㄱ-ㅣ]+$'), // 한글 자음/모음만
      RegExp(r'(그래서|그런데|아니|근데|그니까|그러니까)\s*$'),
      RegExp(r'(나는|너는|우리는|그는|그녀는)\s*$'),
      RegExp(r'(그게|이게|저게)\s*$'), // "아니 그게" 같은 패턴
    ];
    
    for (final pattern in incompletePatterns) {
      if (pattern.hasMatch(trimmed)) {
        return true;
      }
    }
    
    return false;
  }

  /// 빈정거림/비꼬기 감지
  bool _isSarcasm(String message, List<Message> recentMessages) {
    final sarcasmPatterns = [
      RegExp(r'[아-앙]~+.*[요-용]~+'),
      RegExp(r'정말.*대단.*[~]+'),
      RegExp(r'와~+.*멋지'),
      RegExp(r'(네|예)~{3,}'),
    ];
    
    for (final pattern in sarcasmPatterns) {
      if (pattern.hasMatch(message)) {
        // 최근 대화 맥락 확인
        if (recentMessages.isNotEmpty) {
          final lastMessage = recentMessages.last;
          // 실제 칭찬이 아닌 경우에만 빈정거림으로 판단
          if (!lastMessage.content.contains('고마워') && 
              !lastMessage.content.contains('감사')) {
            return true;
          }
        } else {
          return true;
        }
      }
    }
    return false;
  }

  /// 복사-붙여넣기 실수 감지
  bool _isPasteError(String message, List<Message> recentMessages) {
    // 비즈니스/공식 문서 패턴
    final businessPatterns = [
      RegExp(r'(회의|미팅|일정|안건|참석자|날짜|시간)[\s:：]'),
      RegExp(r'\d{4}[-/년]\d{1,2}[-/월]\d{1,2}[일]?\s*\d{1,2}[:시]\d{2}'),
      RegExp(r'(From|To|Subject|Date|Re:|Fwd:)[\s:：]'),
      RegExp(r'^[-•●▪▫◦]\s'),
    ];
    
    // 일상 대화 중에 갑자기 공식적인 내용이 나타나면 복사-붙여넣기 실수로 판단
    if (recentMessages.isNotEmpty) {
      bool hasNormalConversation = false;
      for (final msg in recentMessages) {
        if (!RegExp(r'(회의|미팅|일정)').hasMatch(msg.content)) {
          hasNormalConversation = true;
          break;
        }
      }
      
      if (hasNormalConversation) {
        for (final pattern in businessPatterns) {
          if (pattern.hasMatch(message)) {
            return true;
          }
        }
      }
    }
    
    return false;
  }

  /// 복수 질문 감지
  List<String> _detectMultipleQuestions(String message) {
    final questions = <String>[];
    
    // ? 또는 문장 끝을 기준으로 분리
    final sentences = message.split(RegExp(r'[?]'));
    
    // ? 로 분리된 문장이 2개 이상이면 복수 질문
    if (sentences.length > 1) {
      for (var i = 0; i < sentences.length; i++) {
        final sentence = sentences[i].trim();
        if (sentence.isEmpty) continue;
        
        // ?로 분리된 경우 마지막 문장 제외하고는 모두 질문
        if (i < sentences.length - 1 || sentence.isNotEmpty) {
          questions.add(sentence + '?');
        }
      }
    } else {
      // ? 가 없는 경우, 여러 질문이 포함되어 있는지 확인
      final singleSentence = message.trim();
      
      // 의문사 패턴
      final questionPatterns = [
        RegExp(r'뭐\s*해|뭐\s*했'), // 뭐해? 뭐했어?
        RegExp(r'어떻|어때'), // 어떻게? 어때?
        RegExp(r'누구|언제|어디|왜'), // 기본 의문사
        RegExp(r'얼마|몇'), // 수량 질문
        RegExp(r'밥.*먹었'), // 밥 먹었어?
      ];
      
      // 여러 개의 서로 다른 의문 패턴이 있는지 확인
      int questionCount = 0;
      for (final pattern in questionPatterns) {
        if (pattern.hasMatch(singleSentence)) {
          questionCount++;
        }
      }
      
      // 2개 이상의 서로 다른 질문 패턴이 있으면 복수 질문으로 간주
      if (questionCount >= 2) {
        // 간단히 전체를 하나의 질문으로 처리
        questions.add(singleSentence + (singleSentence.endsWith('?') ? '' : '?'));
      }
    }
    
    // 실제로 2개 이상의 질문이 있을 때만 반환
    return questions.length >= 2 ? questions : [];
  }

  /// 반복적인 단답형 응답 감지
  bool _isRepetitiveShortResponses(List<Message> messages) {
    if (messages.length < 3) return false;
    
    int shortResponseCount = 0;
    for (int i = messages.length - 1; i >= 0 && i >= messages.length - 5; i--) {
      if (!messages[i].isFromUser) continue;
      
      final content = messages[i].content.trim();
      if (content.length <= 3 || 
          content == 'ㅇㅇ' || content == '응' || content == 'ㅎㅎ' ||
          content == 'ㅋㅋ' || content == '네' || content == '예') {
        shortResponseCount++;
      }
    }
    
    return shortResponseCount >= 3;
  }

  /// 음성 인식 오류 여부 확인
  bool _hasVoiceRecognitionError(String message) {
    final errorPatterns = [
      '어떼', '어떄', '안년', '안녕하새요', '반가와요',
      '뭐해여', '보고십어', '사랑행', '고마와', '미안행',
      '괜찬', '조아', '있써', '없써', '그랬써', '했써',
    ];
    
    for (final pattern in errorPatterns) {
      if (message.contains(pattern)) {
        return true;
      }
    }
    return false;
  }

  /// 음성 인식 오류 교정
  String _correctVoiceRecognitionErrors(String message) {
    final corrections = {
      '어떼': '어때',
      '어떄': '어때',
      '안년': '안녕',
      '안녕하새요': '안녕하세요',
      '반가와요': '반가워요',
      '뭐해여': '뭐해요',
      '보고십어': '보고싶어',
      '사랑행': '사랑해',
      '고마와': '고마워',
      '미안행': '미안해',
      '괜찬': '괜찮',
      '조아': '좋아',
      '있써': '있어',
      '없써': '없어',
      '그랬써': '그랬어',
      '했써': '했어',
    };
    
    String corrected = message;
    corrections.forEach((error, correct) {
      corrected = corrected.replaceAll(error, correct);
    });
    
    return corrected;
  }

  /// 사투리 포함 여부 확인
  bool _hasDialect(String message) {
    final dialectPatterns = [
      '머하노', '머하냐', '겁나', '억수로', '아이가',
      '머꼬', '머라카노', '기가', '와이라노', '거시기',
      '허벌나게', '징하게', '잉', '뭐시여', '그려'
    ];
    
    for (final pattern in dialectPatterns) {
      if (message.contains(pattern)) {
        return true;
      }
    }
    return false;
  }

  /// 사투리 표준어 변환
  String _normalizeDialect(String message) {
    final dialectMap = {
      '머하노': '뭐해',
      '머하냐': '뭐해',
      '겁나': '엄청',
      '억수로': '매우',
      '아이가': '아니',
      '머꼬': '뭐',
      '거시기': '그거',
      '징하게': '심하게',
    };
    
    String normalized = message;
    dialectMap.forEach((dialect, standard) {
      normalized = normalized.replaceAll(dialect, standard);
    });
    
    return normalized;
  }

  /// 시간 문맥 질문 감지
  bool _isTimeContextQuestion(String message) {
    final timePatterns = [
      RegExp(r'지금.*몇\s*시'),
      RegExp(r'오늘.*날짜'),
      RegExp(r'무슨.*요일'),
      RegExp(r'언제.*[해했할]'),
      RegExp(r'몇\s*시.*[에까지]'),
      RegExp(r'(아침|점심|저녁).*먹었'),
    ];
    
    for (final pattern in timePatterns) {
      if (pattern.hasMatch(message)) {
        return true;
      }
    }
    return false;
  }
}