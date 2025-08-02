import 'package:flutter/material.dart';

class TipData {
  final String title;
  final String content;
  final IconData icon;
  final List<Color> gradientColors;

  const TipData({
    required this.title,
    required this.content,
    required this.icon,
    required this.gradientColors,
  });

  static List<TipData> get allTips => [
    TipData(
      title: "첫 대화가 어색하신가요?",
      content: "페르소나의 프로필을 참고해 관심사나 취미에 대해 물어보세요. 자연스러운 대화의 시작이 됩니다!",
      icon: Icons.chat_bubble_outline,
      gradientColors: [Color(0xFF667EEA), Color(0xFF764BA2)],
    ),
    TipData(
      title: "호감도를 효율적으로 올리는 방법",
      content: "페르소나의 성격(MBTI)에 맞는 대화를 나누면 호감도가 더 빨리 오릅니다. 잘못된 이름을 부르면 -10점이니 주의하세요!",
      icon: Icons.favorite_outline,
      gradientColors: [Color(0xFFFA709A), Color(0xFFFEE140)],
    ),
    TipData(
      title: "하트를 현명하게 사용하세요",
      content: "슈퍼 라이크(💖×5)는 특별한 페르소나에게만! 일반 대화는 💖×1로도 충분합니다. 매일 자정에 메시지 한도가 리셋됩니다.",
      icon: Icons.favorite,
      gradientColors: [Color(0xFFFF6B6B), Color(0xFFFFE66D)],
    ),
    TipData(
      title: "나와 잘 맞는 페르소나 찾기",
      content: "프로필 설정에서 선호하는 MBTI와 관심사를 설정하면 더 잘 맞는 페르소나를 만날 수 있어요!",
      icon: Icons.search,
      gradientColors: [Color(0xFF4FACFE), Color(0xFF00F2FE)],
    ),
    TipData(
      title: "관계가 깊어질수록",
      content: "호감도가 높아질수록 페르소나가 더 깊고 진솔한 감정을 표현합니다. 특별한 대화와 이벤트도 경험할 수 있어요!",
      icon: Icons.trending_up,
      gradientColors: [Color(0xFF43E97B), Color(0xFF38F9D7)],
    ),
  ];
}