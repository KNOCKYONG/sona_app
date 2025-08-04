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
    const TipData(
      title: "첫 대화가 어색하신가요?",
      content: "페르소나 프로필의 관심사나 취미를 물어보면 자연스럽게 대화가 시작됩니다.",
      icon: Icons.chat_bubble_outline,
      gradientColors: [Color(0xFF667EEA), Color(0xFF764BA2)],
    ),
    const TipData(
      title: "호감도 빠르게 올리기",
      content: "MBTI에 맞는 대화로 호감도↑ 잘못된 이름 부르면 -10점!",
      icon: Icons.favorite_outline,
      gradientColors: [Color(0xFFFA709A), Color(0xFFFEE140)],
    ),
    const TipData(
      title: "하트 사용 꿀팁",
      content: "슈퍼 라이크(💖×5)는 특별한 사람에게! 매일 자정 리셋",
      icon: Icons.favorite,
      gradientColors: [Color(0xFFFF6B6B), Color(0xFFFFE66D)],
    ),
    const TipData(
      title: "나와 잘 맞는 페르소나",
      content: "프로필에서 MBTI와 관심사 설정 → 더 잘 맞는 페르소나 만남",
      icon: Icons.search,
      gradientColors: [Color(0xFF4FACFE), Color(0xFF00F2FE)],
    ),
    const TipData(
      title: "관계가 깊어질수록",
      content: "호감도가 높을수록 더 깊고 특별한 대화와 이벤트!",
      icon: Icons.trending_up,
      gradientColors: [Color(0xFF43E97B), Color(0xFF38F9D7)],
    ),
    const TipData(
      title: "메시지 잔량 확인",
      content: "배터리 색상: 🟢6-10개 🟠3-5개 🔴0-2개",
      icon: Icons.battery_alert,
      gradientColors: [Color(0xFF6A85B6), Color(0xFFBAC8E0)],
    ),
    const TipData(
      title: "대화 오류 발견하셨나요?",
      content: "채팅방 더보기 → '대화 오류 전송하기'로 개선에 도움을 주세요!",
      icon: Icons.bug_report_outlined,
      gradientColors: [Color(0xFF667EEA), Color(0xFF764BA2)],
    ),
  ];
}