import 'package:flutter/material.dart';
import 'dart:math';
import '../../models/persona.dart';

/// 🚨 부정적 행동 감지 및 처리 시스템
/// 
/// 욕설, 비난, 협박 등을 감지하고 심각도에 따라 처리
class NegativeBehaviorSystem {
  // 싱글톤 패턴
  static final NegativeBehaviorSystem _instance = NegativeBehaviorSystem._internal();
  factory NegativeBehaviorSystem() => _instance;
  NegativeBehaviorSystem._internal();
  
  final Random _random = Random();
  
  /// 부정적 행동 분석
  NegativeAnalysisResult analyze(String message, {int relationshipScore = 0}) {
    final lowerMessage = message.toLowerCase();
    final trimmedMessage = message.trim();
    
    // 빈 메시지 또는 매우 짧은 메시지는 분석하지 않음
    if (trimmedMessage.length < 2) {
      return NegativeAnalysisResult(level: 0, category: 'none');
    }
    
    // 레벨별 분석
    final severeResult = _checkSevereLevel(lowerMessage);
    if (severeResult.level > 0) return severeResult;
    
    // 추임새 욕설 체크 (관계 점수 고려)
    final casualResult = _checkCasualSwearing(lowerMessage, message, relationshipScore);
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
      '죽어', '죽을', '죽여', '죽이', '자살', '살인',
      '칼로', '총으로', '불태워', '태워버려', '폭발',
      '때리', '패주', '두들겨', '맞아', '쳐맞'
    ];
    
    // 성적 모욕
    final sexualInsults = [
      '강간', '성폭행', '성희롱', '변태', '성적',
      '섹스', '야동', '포르노', '성매매'
    ];
    
    // 극도의 혐오 표현
    final extremeHate = [
      '쓰레기', '벌레', '기생충', '암덩어리', '사회악',
      '인간쓰레기', '저주받', '지옥', '악마'
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
  
  /// 추임새 욕설 체크 (관계 점수 고려)
  NegativeAnalysisResult _checkCasualSwearing(String lowerMessage, String originalMessage, int relationshipScore) {
    // 추임새로 사용될 수 있는 가벼운 욕설
    final casualSwearWords = [
      '씨', '아씨', '젠장', '망할', '빌어먹을', '씨바', '시바'
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
            lowerMessage.contains('... $word')) {
          isCasualContext = true;
          break;
        }
      }
    }
    
    if (isCasualContext && casualSwearWords.any((word) => lowerMessage.contains(word))) {
      // 관계 점수에 따른 페널티 조정
      int basePenalty = _random.nextInt(100) + 50; // 50~150
      
      // 관계 점수별 페널티 감소율
      double reductionRate = 0;
      if (relationshipScore >= 1000) {
        reductionRate = 0.9; // 90% 감소
      } else if (relationshipScore >= 500) {
        reductionRate = 0.8; // 80% 감소
      } else if (relationshipScore >= 100) {
        reductionRate = 0.5; // 50% 감소
      }
      
      final adjustedPenalty = (basePenalty * (1 - reductionRate)).round();
      
      return NegativeAnalysisResult(
        level: 1,
        category: 'casual_swear',
        penalty: adjustedPenalty,
        message: relationshipScore >= 500 
          ? '그런 말투는... 좀 그래요 ㅎㅎ' 
          : '욕은 좀 줄여주세요...',
      );
    }
    
    return NegativeAnalysisResult(level: 0, category: 'none');
  }
  
  /// 레벨 2: 중간 수준 욕설 (-500~-1000 Like)
  NegativeAnalysisResult _checkModerateLevel(String message) {
    // 공격적인 욕설 (추임새로 사용되지 않는 것들)
    final curseWords = [
      '시발', '씨발', '씨팔', '샤발',
      '병신', '븅신', '빙신', '좆', '좆같', '좃같',
      '개새끼', '개색끼', '개새키', '개색히', '개자식',
      '미친놈', '미친년', '또라이', '돌아이', '정신병',
      '지랄', '지럴', '염병', '썅', '닥쳐', '꺼져'
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
      '싫어', '싫다', '싫은', '미워', '미운'
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
  
  /// 부정적 행동에 대한 페르소나 반응 생성
  String generateResponse(NegativeAnalysisResult analysis, Persona persona, {int relationshipScore = 0}) {
    if (analysis.level == 0) return '';
    
    // 페르소나 성격에 따른 반응 차이
    final isEmotional = persona.mbti.contains('F');
    final isIntroverted = persona.mbti.startsWith('I');
    
    // 추임새 욕설에 대한 특별 처리
    if (analysis.category == 'casual_swear') {
      if (relationshipScore >= 1000) {
        // 매우 친한 관계
        if (isEmotional) {
          return '헤헤 말투 좀 봐~ 그래도 귀여워서 봐줄게 ㅋㅋ';
        } else {
          return '말투가... ㅋㅋ 뭐 우리 사이니까 괜찮지만~';
        }
      } else if (relationshipScore >= 500) {
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
}

/// 부정적 행동 분석 결과
class NegativeAnalysisResult {
  final int level; // 0: 없음, 1: 경미, 2: 중간, 3: 심각
  final String category; // violence, sexual, hate, curse, insult, etc.
  final int? penalty; // Like 감소량
  final String? message; // 시스템 메시지
  
  NegativeAnalysisResult({
    required this.level,
    required this.category,
    this.penalty,
    this.message,
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