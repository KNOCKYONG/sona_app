/// 💝 Like 숫자 포맷팅 유틸리티
class LikeFormatter {
  /// 숫자를 읽기 쉬운 형식으로 변환
  /// 예: 1234 → "1.2K", 1234567 → "1.2M"
  static String format(int likes) {
    if (likes >= 1000000000) {
      // 10억 이상 (B)
      return '${(likes / 1000000000).toStringAsFixed(1)}B';
    } else if (likes >= 1000000) {
      // 백만 이상 (M)
      final millions = likes / 1000000;
      if (millions >= 100) {
        return '${millions.toStringAsFixed(0)}M';
      } else if (millions >= 10) {
        return '${millions.toStringAsFixed(1)}M';
      } else {
        return '${millions.toStringAsFixed(2)}M';
      }
    } else if (likes >= 1000) {
      // 천 이상 (K)
      final thousands = likes / 1000;
      if (thousands >= 100) {
        return '${thousands.toStringAsFixed(0)}K';
      } else if (thousands >= 10) {
        return '${thousands.toStringAsFixed(1)}K';
      } else {
        return '${thousands.toStringAsFixed(2)}K';
      }
    }
    // 천 미만은 그대로 표시
    return likes.toString();
  }

  /// 아이콘과 함께 포맷팅
  static String formatWithIcon(int likes) {
    return '❤️ ${format(likes)}';
  }

  /// 증감 표시와 함께 포맷팅
  static String formatWithChange(int likes, int change) {
    if (change == 0) {
      return format(likes);
    } else if (change > 0) {
      return '${format(likes)} (+$change)';
    } else {
      return '${format(likes)} ($change)';
    }
  }

  /// 자세한 숫자 표시 (쉼표 포함)
  static String formatDetailed(int likes) {
    final String likesStr = likes.toString();
    final StringBuffer result = StringBuffer();

    for (int i = 0; i < likesStr.length; i++) {
      if (i > 0 && (likesStr.length - i) % 3 == 0) {
        result.write(',');
      }
      result.write(likesStr[i]);
    }

    return result.toString();
  }

  /// 마일스톤 체크
  static int? getNextMilestone(int currentLikes) {
    final milestones = [
      100,
      500,
      1000,
      2000,
      5000,
      10000,
      20000,
      50000,
      100000,
      200000,
      500000,
      1000000
    ];

    for (final milestone in milestones) {
      if (currentLikes < milestone) {
        return milestone;
      }
    }

    // 백만 이상은 백만 단위로
    final millions = (currentLikes / 1000000).floor() + 1;
    return millions * 1000000;
  }

  /// 다음 마일스톤까지 남은 Like
  static int getLikesToNextMilestone(int currentLikes) {
    final nextMilestone = getNextMilestone(currentLikes);
    if (nextMilestone == null) return 0;
    return nextMilestone - currentLikes;
  }

  /// 마일스톤 달성 메시지
  static String? getMilestoneMessage(int likes) {
    switch (likes) {
      case 100:
        return "첫 100 Like 달성! 🎉";
      case 500:
        return "500 Like! 관계가 깊어지고 있어요 💕";
      case 1000:
        return "1K Like 달성! 특별한 사이가 되었네요 🌟";
      case 5000:
        return "5K Like! 놀라운 관계예요 ✨";
      case 10000:
        return "10K Like! 전설적인 사랑입니다 👑";
      case 50000:
        return "50K Like! 영원한 사랑이에요 💎";
      case 100000:
        return "100K Like! 역사에 남을 사랑입니다 🏆";
      case 1000000:
        return "1M Like! 신화가 되었습니다 🌌";
      default:
        return null;
    }
  }

  /// 성장률 계산 및 표시
  static String formatGrowthRate(int currentLikes, int previousLikes) {
    if (previousLikes == 0) return '';

    final growth =
        ((currentLikes - previousLikes) / previousLikes * 100).round();

    if (growth > 0) {
      return '+$growth%';
    } else if (growth < 0) {
      return '$growth%';
    } else {
      return '0%';
    }
  }
}
