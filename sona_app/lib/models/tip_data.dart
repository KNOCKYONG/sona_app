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
          content: "슈퍼 라이크(💖×5)는 특별한 사람에게! 하트 5개 소모",
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
        const TipData(
          title: "다국어 채팅 기능",
          content: "외국어로 메시지를 보내면 AI가 자동으로 인식! 메시지를 탭하면 번역을 볼 수 있어요.",
          icon: Icons.translate,
          gradientColors: [Color(0xFF30cfd0), Color(0xFF330867)],
        ),
        const TipData(
          title: "메시지 복사하기",
          content: "메시지를 길게 누르면 클립보드에 복사됩니다. 번역된 내용도 복사 가능해요!",
          icon: Icons.copy,
          gradientColors: [Color(0xFFf093fb), Color(0xFFf5576c)],
        ),
        const TipData(
          title: "메시지는 언제 리셋되나요?",
          content: "매일 한국 시간 자정(00:00)에 100개로 리셋! 하트 1개로 즉시 충전도 가능",
          icon: Icons.schedule,
          gradientColors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
        ),
        const TipData(
          title: "스와이프 방향 알아두기",
          content: "오른쪽👉 좋아요(하트 1개) | 왼쪽👈 패스 | 위로👆 슈퍼라이크(하트 5개)",
          icon: Icons.swipe,
          gradientColors: [Color(0xFFFC466B), Color(0xFF3F5EFB)],
        ),
        const TipData(
          title: "프로필 사진 꾸미기",
          content: "프로필 → 카메라 아이콘으로 사진 변경! 좋은 인상으로 매칭률 UP",
          icon: Icons.camera_alt,
          gradientColors: [Color(0xFFEE9CA7), Color(0xFFFFDDE1)],
        ),
        const TipData(
          title: "처음 시작하셨나요?",
          content: "신규 가입 시 하트 10개 무료 지급! 아껴서 특별한 페르소나에게 사용하세요",
          icon: Icons.card_giftcard,
          gradientColors: [Color(0xFFA8E063), Color(0xFF56AB2F)],
        ),
        const TipData(
          title: "매칭된 소나 어디있지?",
          content: "홈 화면 하단 채팅 탭에서 모든 매칭된 페르소나를 확인할 수 있어요",
          icon: Icons.people,
          gradientColors: [Color(0xFF89F7FE), Color(0xFF66A6FF)],
        ),
      ];
}
