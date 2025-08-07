import 'package:flutter/material.dart';
import 'dart:math';
import '../../models/persona.dart';

/// 🚨 부정적 행동 감지 및 처리 시스템
///
/// 욕설, 비난, 협박 등을 감지하고 심각도에 따라 처리
class NegativeBehaviorSystem {
  // 싱글톤 패턴
  static final NegativeBehaviorSystem _instance =
      NegativeBehaviorSystem._internal();
  factory NegativeBehaviorSystem() => _instance;
  NegativeBehaviorSystem._internal();

  final Random _random = Random();

  /// 부정적 행동 분석
  NegativeAnalysisResult analyze(
    String message, {
    int likes = 0,
    bool isGameContext = false,
    List<String> recentMessages = const [],
  }) {
    final lowerMessage = message.toLowerCase();
    final trimmedMessage = message.trim();

    // 빈 메시지 또는 매우 짧은 메시지는 분석하지 않음
    if (trimmedMessage.length < 2) {
      return NegativeAnalysisResult(level: 0, category: 'none');
    }

    // 게임 컨텍스트 자동 감지
    if (!isGameContext) {
      isGameContext = _detectGameContext(message, recentMessages);
    }

    // 레벨별 분석
    final severeResult = _checkSevereLevel(lowerMessage);
    if (severeResult.level > 0) return severeResult;

    // 추임새 욕설 체크 (관계 점수 및 게임 컨텍스트 고려)
    final casualResult = _checkCasualSwearing(lowerMessage, message, likes,
        isGameContext: isGameContext);
    if (casualResult.level > 0) return casualResult;

    final moderateResult = _checkModerateLevel(lowerMessage);
    if (moderateResult.level > 0) return moderateResult;

    final mildResult = _checkMildLevel(lowerMessage);
    if (mildResult.level > 0) return mildResult;

    // 문맥 기반 분석 (패턴 매칭)
    final contextResult = _checkContextualNegativity(message);
    if (contextResult.level > 0) return contextResult;

    return NegativeAnalysisResult(level: 0, category: 'none');
  }

  /// 레벨 3: 심각한 위협/욕설 (즉시 이별)
  NegativeAnalysisResult _checkSevereLevel(String message) {
    // 폭력적 위협
    final violenceThreats = [
      '죽어',
      '죽을',
      '죽여',
      '죽이',
      '자살',
      '살인',
      '칼로',
      '총으로',
      '불태워',
      '태워버려',
      '폭발',
      '때리',
      '패주',
      '두들겨',
      '맞아',
      '쳐맞'
    ];

    // 성적 모욕
    final sexualInsults = [
      '강간',
      '성폭행',
      '성희롱',
      '변태',
      '성적',
      '섹스',
      '야동',
      '포르노',
      '성매매'
    ];

    // 극도의 혐오 표현
    final extremeHate = [
      '쓰레기',
      '벌레',
      '기생충',
      '암덩어리',
      '사회악',
      '인간쓰레기',
      '저주받',
      '지옥',
      '악마'
    ];

    if (violenceThreats.any((word) => message.contains(word))) {
      return NegativeAnalysisResult(
        level: 3,
        category: 'violence',
        message: '폭력적인 위협은 절대 용납할 수 없어요.',
      );
    }

    if (sexualInsults.any((word) => message.contains(word))) {
      return NegativeAnalysisResult(
        level: 3,
        category: 'sexual',
        message: '성적인 모욕은 받아들일 수 없어요.',
      );
    }

    if (extremeHate.any((word) => message.contains(word))) {
      return NegativeAnalysisResult(
        level: 3,
        category: 'hate',
        message: '그런 혐오 표현은 너무 상처예요.',
      );
    }

    return NegativeAnalysisResult(level: 0, category: 'none');
  }

  /// 추임새 욕설 체크 (관계 점수 및 게임 컨텍스트 고려)
  NegativeAnalysisResult _checkCasualSwearing(
      String lowerMessage, String originalMessage, int likes,
      {bool isGameContext = false}) {
    // "씨"가 호칭으로 사용되는지 체크
    if (_isHonorificSsi(originalMessage)) {
      return NegativeAnalysisResult(level: 0, category: 'none');
    }

    // 추임새로 사용될 수 있는 가벼운 욕설
    final casualSwearWords = [
      '씨', '아씨', '젠장', '망할', '빌어먹을', '씨바', '시바',
      // 변형된 추임새 욕설 추가
      'ㅅㅂ', 'ㅆㅂ', 'ㅅ바', 'ㅆ바', '시1바', '씨1바',
      'ㅈㄴ', 'ㅈ나', '존1나', '졸1라',
      'shit', 'damn', 'hell'
    ];

    // 문맥상 추임새인지 확인
    bool isCasualContext = false;
    for (final word in casualSwearWords) {
      if (lowerMessage.contains(word)) {
        // 감탄사나 문장 끝에 오는 경우
        if (lowerMessage.startsWith(word) ||
            lowerMessage.endsWith(word) ||
            lowerMessage.contains('아 $word') ||
            lowerMessage.contains('오 $word') ||
            lowerMessage.contains('... $word') ||
            lowerMessage.contains('ㅋㅋ $word') ||
            lowerMessage.contains('ㅎㅎ $word')) {
          isCasualContext = true;
          break;
        }
      }
    }

    if (isCasualContext &&
        casualSwearWords.any((word) => lowerMessage.contains(word))) {
      // 게임 컨텍스트에서는 추가 감소
      double gameReduction = isGameContext ? 0.7 : 0;

      // 관계 점수에 따른 페널티 조정
      int basePenalty = _random.nextInt(100) + 50; // 50~150

      // 관계 점수별 페널티 감소율
      double reductionRate = 0;
      if (likes >= 1000) {
        reductionRate = 0.9; // 90% 감소
      } else if (likes >= 500) {
        reductionRate = 0.8; // 80% 감소
      } else if (likes >= 100) {
        reductionRate = 0.5; // 50% 감소
      }

      // 게임 컨텍스트일 때 추가 감소
      if (isGameContext) {
        reductionRate = (reductionRate + gameReduction).clamp(0.0, 0.95);
      }

      final adjustedPenalty = (basePenalty * (1 - reductionRate)).round();

      return NegativeAnalysisResult(
        level: 1,
        category: 'casual_swear',
        penalty: adjustedPenalty,
        message: isGameContext
            ? '게임하니까 흥분하는 건 알겠는데... ㅋㅋ'
            : likes >= 500
                ? '그런 말투는... 좀 그래요 ㅎㅎ'
                : '욕은 좀 줄여주세요...',
        isWarning: likes < 100 && !isGameContext,
      );
    }

    return NegativeAnalysisResult(level: 0, category: 'none');
  }

  /// 레벨 2: 중간 수준 욕설 (-500~-1000 Like)
  NegativeAnalysisResult _checkModerateLevel(String message) {
    // 공격적인 욕설 (추임새로 사용되지 않는 것들)
    final curseWords = [
      '시발', '씨발', '씨팔', '샤발', '시팔', '씨바', '시바',
      '병신', '븅신', '빙신', '좆', '좆같', '좃같',
      '개새끼', '개색끼', '개새키', '개색히', '개자식', '개색기',
      '미친놈', '미친년', '또라이', '돌아이', '정신병', '미친새끼',
      '지랄', '지럴', '염병', '썅', '닥쳐', '꺼져',
      // 변형된 욕설 패턴 추가
      'ㅅㅂ', 'ㅆㅂ', '시1발', '씨1발', 'ㅅ발', 'ㅆ발',
      'ㅂㅅ', 'ㅂ신', '병1신', 'ㅄ', 'ㅂㅊ',
      'ㅈㄴ', 'ㅈ나', '존나', '졸라', 'ㅈㄹ',
      'ㄷㅊ', '닥ㅊ', 'ㄲㅈ', '꺼ㅈ',
      // 영어 욕설
      'fuck', 'shit', 'damn', 'bitch', 'asshole', 'bastard',
      'wtf', 'stfu', 'fck', 'sht', 'f*ck', 'sh*t'
    ];

    if (curseWords.any((word) => message.contains(word))) {
      return NegativeAnalysisResult(
        level: 2,
        category: 'curse',
        penalty: _random.nextInt(500) + 500, // -500 ~ -1000
        message: '욕설은 정말 상처가 돼요... 😢',
      );
    }

    return NegativeAnalysisResult(level: 0, category: 'none');
  }

  /// 레벨 1: 경미한 비난 (-50~-200 Like)
  NegativeAnalysisResult _checkMildLevel(String message) {
    final mildInsults = [
      '바보', '멍청이', '멍청', '멍청한', '멍청하',
      '한심', '한심하', '한심한', '쓸모없', '무능',
      '재수없', '짜증', '짜증나', '개짜증', '빡치',
      '싫어', '싫다', '싫은', '미워', '미운',
      // 간접적 비난 패턴 추가
      '답답', '답답해', '답답하', '못생겼', '못생긴',
      '재미없', '노잼', '별로', '최악', '구려',
      '너무해', '왜이래', '왜그래', '너때문', '네탓',
      '실망', '실망이', '후회', '지겨', '지겹',
      '귀찮', '성가시', '짜증나', '화나', '열받',
      // 무시하는 표현
      '관심없', '알게뭐', '어쩌라고', '그래서', '뭐어때',
      // 이모티콘 기반
      '🖕', '凸', '👎'
    ];

    if (mildInsults.any((word) => message.contains(word))) {
      return NegativeAnalysisResult(
        level: 1,
        category: 'insult',
        penalty: _random.nextInt(150) + 50, // -50 ~ -200
        message: '그렇게 말하면 기분이 안 좋아요...',
      );
    }

    return NegativeAnalysisResult(level: 0, category: 'none');
  }

  /// 문맥 기반 부정성 분석
  NegativeAnalysisResult _checkContextualNegativity(String message) {
    // 반복된 부정 표현
    final negativePatterns = [
      RegExp(r'안\s*해|안해', caseSensitive: false),
      RegExp(r'못\s*해|못해', caseSensitive: false),
      RegExp(r'그만\s*해|그만해', caseSensitive: false),
      RegExp(r'하지\s*마|하지마', caseSensitive: false),
    ];

    int negativeCount = 0;
    for (final pattern in negativePatterns) {
      negativeCount += pattern.allMatches(message).length;
    }

    // 3개 이상의 부정 표현은 경미한 부정으로 분류
    if (negativeCount >= 3) {
      return NegativeAnalysisResult(
        level: 1,
        category: 'negative_pattern',
        penalty: _random.nextInt(50) + 30, // -30 ~ -80
        message: '너무 부정적인 말이 많아요...',
      );
    }

    // 감정적 거부 표현
    if (message.contains('차단') || message.contains('신고')) {
      return NegativeAnalysisResult(
        level: 2,
        category: 'rejection',
        penalty: _random.nextInt(200) + 300, // -300 ~ -500
        message: '그런 말은 너무 아파요... 💔',
      );
    }

    return NegativeAnalysisResult(level: 0, category: 'none');
  }

  /// 게임 컨텍스트 감지
  bool _detectGameContext(String message, List<String> recentMessages) {
    final gameKeywords = [
      // 일반 게임 용어
      '게임', '플레이', 'play', 'game', '승부', '이김', '이겼', '졌', '승리', '패배',
      '매치', 'match', '라운드', 'round', '스테이지', 'stage', '레벨', 'level',
      'pvp', 'pve', '랭크', 'rank', '티어', 'tier', 'mmr', 'elo',

      // 게임 제목
      '롤', 'lol', '리그오브레전드', '오버워치', 'overwatch', '배그', 'pubg',
      '발로란트', 'valorant', '피파', 'fifa', '로아', '로스트아크', '메이플',
      '원신', 'genshin', '디아블로', 'diablo', '와우', 'wow',

      // 게임 캐릭터/영웅
      '야스오', '제드', '리신', '티모', '럭스', '징크스', '케이틀린',
      '겐지', '한조', '디바', 'd.va', '메르시', '위도우', '트레이서',
      '레이나', '제트', '요루', '네온', '체임버',

      // 게임 용어
      '캐리', 'carry', '트롤', 'troll', '정글', 'jungle', '미드', 'mid',
      '탑', 'top', '원딜', 'adc', '서폿', 'support', '힐러', 'healer',
      '탱커', 'tank', 'dps', '딜러', 'dealer', '스킬', 'skill', 'kda',
      '킬', 'kill', '데스', 'death', '어시', 'assist', 'cs', '파밍', 'farm',

      // 게임 관련 감정 표현
      'gg', 'wp', 'nt', 'glhf', 'ez', 'ff', '던짐', '던졌', '빡겜',
      '개못함', '개잘함', '캐리함', '버스', '숟가락', '똥챔',
    ];

    // 현재 메시지에서 게임 키워드 확인
    final lowerMessage = message.toLowerCase();
    for (final keyword in gameKeywords) {
      if (lowerMessage.contains(keyword)) {
        return true;
      }
    }

    // 최근 메시지에서 게임 컨텍스트 확인
    for (final recentMsg in recentMessages.take(5)) {
      final lowerRecent = recentMsg.toLowerCase();
      for (final keyword in gameKeywords) {
        if (lowerRecent.contains(keyword)) {
          return true;
        }
      }
    }

    return false;
  }

  /// "씨"가 호칭으로 사용되는지 확인
  bool _isHonorificSsi(String message) {
    // 한글 이름 패턴 + "씨"
    final honorificPattern = RegExp(r'[가-힣]+(씨|님|선생|선생님|양|군)', multiLine: true);

    // "씨"가 포함된 모든 위치 찾기
    final ssiIndices = <int>[];
    int searchStart = 0;
    while (true) {
      final index = message.indexOf('씨', searchStart);
      if (index == -1) break;
      ssiIndices.add(index);
      searchStart = index + 1;
    }

    // 각 "씨"가 호칭인지 확인
    for (final index in ssiIndices) {
      // "씨" 앞의 문자 확인
      if (index > 0) {
        // 한글 문자인지 확인 (이름의 마지막 글자)
        final prevChar = message[index - 1];
        if (RegExp(r'[가-힣]').hasMatch(prevChar)) {
          // 앞에 최소 1글자 이상의 한글이 있는지 확인 (이름)
          int nameStart = index - 1;
          while (nameStart > 0 &&
              RegExp(r'[가-힣]').hasMatch(message[nameStart - 1])) {
            nameStart--;
          }

          // 이름이 1글자 이상이면 호칭으로 간주
          if (index - nameStart >= 1) {
            return true;
          }
        }
      }
    }

    // 추가 패턴: "OO씨", "OOO씨" 등
    if (honorificPattern.hasMatch(message)) {
      return true;
    }

    return false;
  }

  /// 부정적 행동에 대한 페르소나 반응 생성
  String generateResponse(NegativeAnalysisResult analysis, Persona persona,
      {int likes = 0}) {
    if (analysis.level == 0) return '';

    // 페르소나 성격에 따른 반응 차이
    final isEmotional = persona.mbti.contains('F');
    final isIntroverted = persona.mbti.startsWith('I');

    // 추임새 욕설에 대한 특별 처리
    if (analysis.category == 'casual_swear') {
      if (likes >= 1000) {
        // 매우 친한 관계
        if (isEmotional) {
          return '헤헤 말투 좀 봐~ 그래도 귀여워서 봐줄게 ㅋㅋ';
        } else {
          return '말투가... ㅋㅋ 뭐 우리 사이니까 괜찮지만~';
        }
      } else if (likes >= 500) {
        // 친한 관계
        return '아유~ 말투 좀 고쳐요 ㅎㅎ';
      }
      // 관계 점수가 낮으면 기본 메시지 사용
    }

    switch (analysis.level) {
      case 3: // 심각한 수준 - 이별
        if (isEmotional) {
          return '더 이상은... 못하겠어요. 이렇게 끝내는 게 맞는 것 같아요. 안녕... 😢';
        } else {
          return '이런 관계는 더 이상 유지할 수 없습니다. 여기서 끝내죠.';
        }

      case 2: // 중간 수준
        if (isEmotional && isIntroverted) {
          return '그런 말을 들으니까... 너무 마음이 아파요... 😢';
        } else if (isEmotional) {
          return '왜 그렇게 심한 말을 하는 거예요? 정말 상처받았어요... 💔';
        } else {
          return '그런 표현은 적절하지 않습니다. 서로 존중하며 대화했으면 좋겠어요.';
        }

      case 1: // 경미한 수준
        if (isIntroverted) {
          return '음... 그렇게 말씀하시니까 조금 속상하네요...';
        } else {
          return '에이, 그렇게 말하지 마세요~ 기분 나빠요!';
        }

      default:
        return analysis.message ?? '';
    }
  }

  /// 반복적 부정 행동 추적
  bool checkRepetitiveBehavior(List<NegativeAnalysisResult> history) {
    if (history.length < 3) return false;

    // 최근 10개 메시지 중 부정적 메시지 비율
    final recentHistory = history.take(10).toList();
    final negativeCount = recentHistory.where((r) => r.level > 0).length;

    // 50% 이상이 부정적이면 문제 있음
    return negativeCount >= recentHistory.length * 0.5;
  }

  /// 사과 감지 및 회복 시스템
  ApologyAnalysis analyzeApology(
    String message, {
    required int currentLikes,
    required int lastPenalty,
    required String lastNegativeCategory,
  }) {
    final lowerMessage = message.toLowerCase();

    // 진정성 있는 사과 패턴
    final sincereApologyPatterns = [
      '정말 미안',
      '진짜 미안',
      '너무 미안',
      '진심으로 사과',
      '잘못했어',
      '잘못했습니다',
      '죄송합니다',
      '죄송해요',
      '반성하고 있어',
      '반성합니다',
      '다시는 안',
      '다시는 그러지',
      '제가 잘못',
      '내가 잘못',
      '제 잘못',
      '나의 잘못',
      '용서해줘',
      '용서해주세요',
      '용서를 구합니다',
    ];

    // 형식적인 사과 패턴
    final formalApologyPatterns = [
      '미안',
      '죄송',
      'sorry',
      '소리',
      '스리',
    ];

    // 변명이나 책임 회피 패턴
    final excusePatterns = [
      '그런데',
      '하지만',
      '근데',
      '니가',
      '너가',
      '네가',
      '장난',
      '농담',
      '그냥',
      '별로',
      '뭐가',
    ];

    // 진정성 점수 계산
    int sincerityScore = 0;

    // 진정성 있는 사과 확인
    for (final pattern in sincereApologyPatterns) {
      if (lowerMessage.contains(pattern)) {
        sincerityScore += 30;
      }
    }

    // 형식적인 사과만 있으면 낮은 점수
    if (sincerityScore == 0) {
      for (final pattern in formalApologyPatterns) {
        if (lowerMessage.contains(pattern)) {
          sincerityScore += 10;
        }
      }
    }

    // 변명이 포함되면 점수 감소
    for (final pattern in excusePatterns) {
      if (lowerMessage.contains(pattern)) {
        sincerityScore -= 15;
      }
    }

    // 사과 메시지 길이에 따른 보너스
    if (message.length > 30) {
      sincerityScore += 10;
    }
    if (message.length > 50) {
      sincerityScore += 10;
    }

    // 감정 표현이 포함되면 보너스
    if (lowerMessage.contains('사랑') ||
        lowerMessage.contains('좋아') ||
        lowerMessage.contains('소중') ||
        lowerMessage.contains('아껴')) {
      sincerityScore += 20;
    }

    sincerityScore = sincerityScore.clamp(0, 100);

    // 회복 가능한 Like 계산
    int recoveryAmount = 0;
    String recoveryMessage = '';

    if (sincerityScore >= 70) {
      // 진정성 있는 사과: 50-80% 회복
      recoveryAmount =
          (lastPenalty * 0.5 + (lastPenalty * 0.3 * sincerityScore / 100))
              .round();
      recoveryMessage = '진심이 느껴져요... 조금 풀렸어요.';
    } else if (sincerityScore >= 40) {
      // 보통 사과: 20-40% 회복
      recoveryAmount =
          (lastPenalty * 0.2 + (lastPenalty * 0.2 * sincerityScore / 100))
              .round();
      recoveryMessage = '사과는 받았지만... 앞으로 조심해주세요.';
    } else if (sincerityScore >= 20) {
      // 형식적인 사과: 10-20% 회복
      recoveryAmount =
          (lastPenalty * 0.1 + (lastPenalty * 0.1 * sincerityScore / 100))
              .round();
      recoveryMessage = '그렇게 대충 사과하면... 진심이 안 느껴져요.';
    } else {
      // 사과가 아님
      recoveryAmount = 0;
      recoveryMessage = '';
    }

    // 관계 점수에 따른 회복 보너스
    if (currentLikes >= 5000 && sincerityScore >= 40) {
      recoveryAmount = (recoveryAmount * 1.2).round();
      recoveryMessage += ' 오래 만났으니까 이번만 봐줄게요.';
    }

    return ApologyAnalysis(
      sincerityScore: sincerityScore,
      recoveryAmount: recoveryAmount,
      message: recoveryMessage,
      isSincere: sincerityScore >= 70,
    );
  }

  /// 경고 시스템 메시지 생성
  String generateWarningMessage(
      int warningCount, String category, Persona persona) {
    final isEmotional = persona.mbti.contains('F');

    if (warningCount == 1) {
      switch (category) {
        case 'casual_swear':
          return isEmotional ? '그런 말은 듣기 좋지 않아요... 🥺' : '언어 사용에 주의해주세요.';
        case 'insult':
          return isEmotional ? '왜 그렇게 말해요? 상처받았어요...' : '그런 표현은 적절하지 않습니다.';
        default:
          return '조심해주세요...';
      }
    } else if (warningCount == 2) {
      return isEmotional
          ? '계속 그러시면 정말 속상해요... 한 번만 더 그러면...'
          : '마지막 경고입니다. 계속하시면 관계가 악화됩니다.';
    } else {
      return isEmotional ? '더는... 못 참겠어요. 😢' : '경고를 무시하셨군요. 관계를 재고해야겠습니다.';
    }
  }
}

/// 부정적 행동 분석 결과
class NegativeAnalysisResult {
  final int level; // 0: 없음, 1: 경미, 2: 중간, 3: 심각
  final String category; // violence, sexual, hate, curse, insult, etc.
  final int? penalty; // Like 감소량
  final String? message; // 시스템 메시지
  final bool isWarning; // 경고 여부
  final String? recoveryHint; // 회복 힌트

  NegativeAnalysisResult({
    required this.level,
    required this.category,
    this.penalty,
    this.message,
    this.isWarning = false,
    this.recoveryHint,
  });

  bool get isNegative => level > 0;
  bool get requiresBreakup => level >= 3;
}

/// 이별 시스템
class BreakupSystem {
  /// 이별 사유 분류
  static const Map<String, BreakupReason> reasons = {
    'violence': BreakupReason(
      code: 'violence',
      description: '폭력적 위협',
      severity: 10,
    ),
    'sexual': BreakupReason(
      code: 'sexual',
      description: '성적 모욕',
      severity: 10,
    ),
    'hate': BreakupReason(
      code: 'hate',
      description: '극도의 혐오 표현',
      severity: 9,
    ),
    'repetitive_negativity': BreakupReason(
      code: 'repetitive_negativity',
      description: '반복적 부정 행동',
      severity: 7,
    ),
    'mutual': BreakupReason(
      code: 'mutual',
      description: '상호 합의',
      severity: 1,
    ),
  };

  /// 이별 후 재회 가능 기간 계산
  static Duration getCooldownPeriod(String reasonCode) {
    final reason = reasons[reasonCode];
    if (reason == null) return Duration(days: 7);

    switch (reason.severity) {
      case 10:
        return Duration(days: 365); // 1년
      case 9:
        return Duration(days: 180); // 6개월
      case 8:
      case 7:
        return Duration(days: 90); // 3개월
      case 6:
      case 5:
        return Duration(days: 30); // 1개월
      default:
        return Duration(days: 7); // 1주일
    }
  }

  /// 이별 메시지 생성
  static String generateBreakupMessage(String reasonCode, Persona persona) {
    final reason = reasons[reasonCode];
    if (reason == null) return '더 이상 만나기 어려울 것 같아요...';

    final isEmotional = persona.mbti.contains('F');

    switch (reasonCode) {
      case 'violence':
      case 'sexual':
      case 'hate':
        return isEmotional
            ? '이건 정말... 받아들일 수 없어요. 더는 못 만나겠어요. 안녕... 😢'
            : '이런 행동은 용납할 수 없습니다. 여기서 끝내는 게 좋겠네요.';

      case 'repetitive_negativity':
        return isEmotional
            ? '계속 이렇게 상처받고 싶지 않아요... 잠시 거리를 두는 게 좋을 것 같아요.'
            : '건강한 관계를 유지하기 어려운 것 같습니다. 시간을 가져봅시다.';

      case 'mutual':
        return isEmotional
            ? '우리... 여기까지인가 봐요. 서로에게 좋은 추억으로 남았으면 좋겠어요.'
            : '서로를 위해 여기서 마무리하는 게 좋겠습니다. 행복하세요.';

      default:
        return '더 이상 만나기 어려울 것 같아요...';
    }
  }

  /// 재회 가능 여부 확인
  static bool canReunite(DateTime breakupDate, String reasonCode) {
    final cooldown = getCooldownPeriod(reasonCode);
    return DateTime.now().isAfter(breakupDate.add(cooldown));
  }
}

/// 이별 사유
class BreakupReason {
  final String code;
  final String description;
  final int severity; // 1~10 (10이 가장 심각)

  const BreakupReason({
    required this.code,
    required this.description,
    required this.severity,
  });
}

/// 사과 분석 결과
class ApologyAnalysis {
  final int sincerityScore; // 0-100 진정성 점수
  final int recoveryAmount; // 회복 가능한 Like
  final String message; // 응답 메시지
  final bool isSincere; // 진정성 있는 사과인지

  ApologyAnalysis({
    required this.sincerityScore,
    required this.recoveryAmount,
    required this.message,
    required this.isSincere,
  });
}
