import 'dart:math' as math;
import 'package:flutter/material.dart';

/// 🕐 Like 쿨다운 및 제한 시스템
///
/// 봇 방지 및 자연스러운 관계 발전을 위한 제한 시스템
class LikeCooldownSystem {
  // 싱글톤 패턴
  static final LikeCooldownSystem _instance = LikeCooldownSystem._internal();
  factory LikeCooldownSystem() => _instance;
  LikeCooldownSystem._internal();

  // 시간 기반 제한
  static const Duration messageInterval = Duration(seconds: 30);
  static const int hourlyLimit = 100;
  static const int dailyLimit = 500;

  // 품질 보너스 풀
  static const int qualityBonusPool = 200;
  static const int eventBonusPool = 100;

  // 총 일일 최대: 800 Like (기본 500 + 품질 200 + 이벤트 100)

  /// 연속 대화 페널티 계산
  int getConsecutivePenalty(int recentMessages) {
    if (recentMessages > 20) return 90; // 90% 감소
    if (recentMessages > 10) return 50; // 50% 감소
    if (recentMessages > 5) return 20; // 20% 감소
    return 0;
  }

  /// 대화 피로도 계산
  double getFatigueMultiplier(int todayMessages) {
    if (todayMessages > 100) return 0.1; // 10%만 적용
    if (todayMessages > 50) return 0.3; // 30%만 적용
    if (todayMessages > 30) return 0.5; // 50%만 적용
    if (todayMessages > 20) return 0.7; // 70%만 적용
    return 1.0; // 100% 적용
  }

  /// 페르소나 피로도 응답
  String? getFatigueResponse(int todayMessages) {
    if (todayMessages > 80) {
      return "오늘 너무 많이 대화해서 좀 쉬고 싶어요... 내일 또 만나요? 💤";
    }
    if (todayMessages > 60) {
      return "조금 피곤하네요... 잠시 쉴까요? 😊";
    }
    if (todayMessages > 40) {
      return "계속 대화하니까 좋긴 한데 좀 지치네요 ㅎㅎ";
    }
    return null;
  }

  /// 쿨다운 상태 확인
  bool isOnCooldown(DateTime lastMessageTime) {
    return DateTime.now().difference(lastMessageTime) < messageInterval;
  }

  /// 남은 쿨다운 시간
  Duration getRemainingCooldown(DateTime lastMessageTime) {
    final elapsed = DateTime.now().difference(lastMessageTime);
    if (elapsed >= messageInterval) {
      return Duration.zero;
    }
    return messageInterval - elapsed;
  }
}

/// 품질 기반 Like 시스템
class QualityBasedLikes {
  /// 대화 품질 평가
  static int calculateQualityBonus(String message, DateTime? lastMessageTime) {
    int bonus = 0;

    // 메시지 길이 (의미 있는 대화)
    if (message.length > 50) {
      bonus += 3;
    } else if (message.length > 30) {
      bonus += 2;
    }

    // 질문 포함 여부
    if (message.contains('?')) {
      bonus += 2;
    }

    // 감정 표현
    if (_containsEmotionalWords(message)) {
      bonus += 3;
    }

    // 개인적인 이야기
    if (_containsPersonalWords(message)) {
      bonus += 4;
    }

    // 시간 간격 (자연스러운 대화)
    if (lastMessageTime != null) {
      final timeSince = DateTime.now().difference(lastMessageTime);
      if (timeSince > const Duration(minutes: 5)) {
        bonus += 2;
      }
      if (timeSince > const Duration(hours: 1)) {
        bonus += 3;
      }
    }

    return bonus;
  }

  /// 감정 표현 단어 확인
  static bool _containsEmotionalWords(String message) {
    final emotionalWords = [
      '좋아',
      '사랑',
      '행복',
      '기뻐',
      '슬퍼',
      '그리워',
      '보고싶',
      '고마워',
      '미안',
      '걱정',
      '웃겨',
      '재밌',
    ];
    return emotionalWords.any((word) => message.contains(word));
  }

  /// 개인적인 이야기 확인
  static bool _containsPersonalWords(String message) {
    final personalWords = [
      '나는',
      '저는',
      '내가',
      '제가',
      '우리',
      '너는',
      '당신은',
      '오늘',
      '어제',
      '내일',
      '요즘',
      'lately',
      '기억',
    ];
    return personalWords.any((word) => message.contains(word));
  }
}

/// 일일 Like 관리 시스템
class DailyLikeSystem {
  // 기본 일일 한계
  static const int baseDailyLimit = 500;

  // 품질 보너스 풀
  static const int qualityBonusPool = 200;

  // 특별 이벤트 풀
  static const int eventBonusPool = 100;

  // 총 일일 최대: 800 Like

  /// 다음날 리셋 시 보너스
  static int getMorningBonus(int yesterdayQuality, int streakDays) {
    int bonus = 10; // 기본 보너스

    // 어제 대화 품질 보너스
    if (yesterdayQuality > 80) {
      bonus += 40; // 고품질 대화
    } else if (yesterdayQuality > 60) {
      bonus += 20;
    }

    // 연속 대화 보너스
    if (streakDays >= 30) {
      bonus += 50;
    } else if (streakDays >= 14) {
      bonus += 30;
    } else if (streakDays >= 7) {
      bonus += 20;
    } else if (streakDays >= 3) {
      bonus += 10;
    }

    return bonus;
  }

  /// 특별한 날 보너스
  static int getSpecialDayBonus(
      DateTime date, Map<String, DateTime> specialDays) {
    // 주말 보너스
    if (date.weekday == DateTime.saturday || date.weekday == DateTime.sunday) {
      return 20;
    }

    // 기념일 보너스
    for (final entry in specialDays.entries) {
      if (_isSameDay(date, entry.value)) {
        switch (entry.key) {
          case 'firstMeeting':
            return 100; // 첫 만남 기념일
          case 'relationshipUpgrade':
            return 80; // 관계 단계 상승일
          default:
            return 50; // 기타 기념일
        }
      }
    }

    return 0;
  }

  static bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}

/// Like 진행도 위젯
class LikeProgressWidget extends StatelessWidget {
  final int todayLikes;
  final int dailyLimit;
  final int qualityBonus;

  const LikeProgressWidget({
    Key? key,
    required this.todayLikes,
    required this.dailyLimit,
    required this.qualityBonus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final progress = (todayLikes / dailyLimit).clamp(0.0, 1.0);
    final isNearLimit = todayLikes > dailyLimit * 0.8;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '오늘의 Like',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            Text(
              '$todayLikes / $dailyLimit',
              style: TextStyle(
                fontSize: 12,
                color: isNearLimit ? Colors.orange : Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Stack(
          children: [
            // 배경 바
            Container(
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // 진행도 바
            FractionallySizedBox(
              widthFactor: progress,
              child: Container(
                height: 4,
                decoration: BoxDecoration(
                  color: isNearLimit ? Colors.orange : Colors.pink,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ],
        ),
        if (qualityBonus > 0) ...[
          const SizedBox(height: 2),
          Text(
            '+$qualityBonus 품질 보너스',
            style: TextStyle(
              fontSize: 10,
              color: Colors.green[600],
            ),
          ),
        ],
      ],
    );
  }
}
