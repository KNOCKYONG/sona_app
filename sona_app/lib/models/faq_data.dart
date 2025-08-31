import 'package:flutter/material.dart';

class FAQCategory {
  final String id;
  final String titleKo;
  final String titleEn;
  final IconData icon;
  final List<Color> gradientColors;
  final List<FAQItem> items;

  const FAQCategory({
    required this.id,
    required this.titleKo,
    required this.titleEn,
    required this.icon,
    required this.gradientColors,
    required this.items,
  });

  String getTitle(bool isKorean) => isKorean ? titleKo : titleEn;
}

class FAQItem {
  final String questionKo;
  final String questionEn;
  final String answerKo;
  final String answerEn;
  final List<String>? relatedIds;

  const FAQItem({
    required this.questionKo,
    required this.questionEn,
    required this.answerKo,
    required this.answerEn,
    this.relatedIds,
  });

  String getQuestion(bool isKorean) => isKorean ? questionKo : questionEn;
  String getAnswer(bool isKorean) => isKorean ? answerKo : answerEn;
}

class FAQData {
  static List<FAQCategory> get categories => [
        // 🎮 기본 사용법
        FAQCategory(
          id: 'basic',
          titleKo: '기본 사용법',
          titleEn: 'Basic Usage',
          icon: Icons.help_outline,
          gradientColors: [Color(0xFF667EEA), Color(0xFF764BA2)],
          items: [
            FAQItem(
              questionKo: '첫 대화가 어색해요',
              questionEn: 'First conversation feels awkward',
              answerKo:
                  '페르소나 프로필의 관심사나 취미를 물어보면 자연스럽게 대화가 시작됩니다. 예를 들어 "영화 좋아해?" 같은 질문으로 시작해보세요.',
              answerEn:
                  'Start naturally by asking about their interests or hobbies from their profile. Try questions like "Do you like movies?"',
              relatedIds: ['persona_matching', 'conversation'],
            ),
            FAQItem(
              questionKo: 'SONA 사용 방법을 알려주세요',
              questionEn: 'How do I use SONA?',
              answerKo:
                  '1. 페르소나를 스와이프하여 매칭\n2. 채팅방에서 대화 시작\n3. 꾸준한 대화로 관계 발전',
              answerEn:
                  '1. Swipe personas to match\n2. Start chatting in the chat room\n3. Develop relationships through consistent conversation',
            ),
          ],
        ),

        // 💕 호감도 시스템
        FAQCategory(
          id: 'affinity',
          titleKo: '호감도 시스템',
          titleEn: 'Affinity System',
          icon: Icons.favorite_outline,
          gradientColors: [Color(0xFFFA709A), Color(0xFFFEE140)],
          items: [
            FAQItem(
              questionKo: '호감도는 어떻게 올리나요?',
              questionEn: 'How do I increase affinity?',
              answerKo:
                  'MBTI에 맞는 대화, 관심사 공유, 꾸준한 대화로 호감도가 상승합니다.\n\n⚠️ 주의: 잘못된 이름을 부르면 -10점!',
              answerEn:
                  'Increase affinity through MBTI-compatible conversations, sharing interests, and consistent chatting.\n\n⚠️ Warning: Calling wrong name gives -10 points!',
              relatedIds: ['conversation', 'persona_matching'],
            ),
            FAQItem(
              questionKo: '관계가 깊어질수록 어떤 변화가 있나요?',
              questionEn: 'What changes as the relationship deepens?',
              answerKo:
                  '호감도가 높을수록 더 깊고 특별한 대화와 이벤트가 발생합니다. 페르소나가 더 친근하게 대화하고 특별한 추억을 만들어갑니다.',
              answerEn:
                  'Higher affinity leads to deeper conversations and special events. Personas talk more intimately and create special memories.',
            ),
            FAQItem(
              questionKo: '호감도는 어떻게 발전하나요?',
              questionEn: 'How does affinity develop?',
              answerKo:
                  '호감도는 대화를 나눌수록 계속 올라갑니다. 보통 50점으로 시작하며, 제한 없이 계속 쌓여갑니다.\n\n주요 단계:\n• 50-99점: 새로운 만남\n• 100-299점: 알아가는 중\n• 300-499점: 친한 친구\n• 500-999점: 특별한 감정\n• 1000-1999점: 연인\n• 2000-4999점: 오랜 연인\n• 5000점+: 소울메이트\n\n높은 점수는 오래 대화하고 좋은 관계를 유지한 증거입니다.',
              answerEn:
                  'Affinity increases continuously through conversations. It usually starts at 50 points and accumulates without limit.\n\nKey stages:\n• 50-99: New meeting\n• 100-299: Getting to know\n• 300-499: Close friend\n• 500-999: Special feelings\n• 1000-1999: Lovers\n• 2000-4999: Long-term lovers\n• 5000+: Soulmates\n\nHigh scores indicate long conversations and good relationships.',
            ),
          ],
        ),

        // 💎 하트 & 메시지
        FAQCategory(
          id: 'hearts_messages',
          titleKo: '하트 & 메시지',
          titleEn: 'Hearts & Messages',
          icon: Icons.favorite,
          gradientColors: [Color(0xFFFF6B6B), Color(0xFFFFE66D)],
          items: [
            FAQItem(
              questionKo: '하트는 어떻게 얻나요?',
              questionEn: 'How do I get hearts?',
              answerKo:
                  '신규 가입 시 10개의 하트가 지급됩니다. 추가 하트가 필요하면 스토어에서 구매할 수 있습니다.',
              answerEn:
                  'New users receive 10 hearts upon signup. You can purchase additional hearts from the store.',
              relatedIds: ['premium'],
            ),
            FAQItem(
              questionKo: '슈퍼라이크는 무엇인가요?',
              questionEn: 'What is Super Like?',
              answerKo:
                  '슈퍼라이크(💖)는 하트 5개를 사용해 특별한 호감을 표현하는 기능입니다. 슈퍼라이크로 매칭하면 호감도가 높은 점수로 시작해 더 친밀한 대화를 나눌 수 있습니다!',
              answerEn:
                  'Super Like (💖) uses 5 hearts to express special affection. Matching with Super Like starts with higher affinity points for more intimate conversations!',
              relatedIds: ['affinity', 'persona_matching'],
            ),
            FAQItem(
              questionKo: '일일 메시지 제한이 있나요?',
              questionEn: 'Is there a daily message limit?',
              answerKo:
                  '하루 100개의 메시지를 무료로 보낼 수 있습니다. 한국 시간 기준 자정에 리셋됩니다. 추가 100개 메시지는 하트 1개를 사용해 즉시 리셋 가능합니다.',
              answerEn:
                  'You can send 100 free messages per day. It resets at midnight Korean time. Additional 100 messages can be unlocked instantly with 1 heart.',
              relatedIds: ['hearts_messages'],
            ),
            FAQItem(
              questionKo: '메시지 잔량은 어떻게 확인하나요?',
              questionEn: 'How do I check remaining messages?',
              answerKo:
                  '채팅 화면 상단의 배터리 아이콘 색상으로 확인할 수 있습니다.\n🟢 녹색: 6-10개\n🟠 주황: 3-5개\n🔴 빨강: 0-2개',
              answerEn:
                  'Check the battery icon color at the top of chat screen.\n🟢 Green: 6-10\n🟠 Orange: 3-5\n🔴 Red: 0-2',
            ),
          ],
        ),

        // 👥 페르소나 매칭
        FAQCategory(
          id: 'persona_matching',
          titleKo: '페르소나 매칭',
          titleEn: 'Persona Matching',
          icon: Icons.people_outline,
          gradientColors: [Color(0xFF4FACFE), Color(0xFF00F2FE)],
          items: [
            FAQItem(
              questionKo: '나와 잘 맞는 페르소나를 찾으려면?',
              questionEn: 'How to find compatible personas?',
              answerKo:
                  '프로필에서 MBTI와 관심사를 설정하면 더 잘 맞는 페르소나를 추천받을 수 있습니다. 취향이 비슷한 페르소나와 대화가 더 잘 통해요!',
              answerEn:
                  'Set your MBTI and interests in your profile for better persona recommendations. Conversations flow better with similar interests!',
              relatedIds: ['basic', 'affinity'],
            ),
            FAQItem(
              questionKo: '스와이프는 어떻게 하나요?',
              questionEn: 'How do I swipe?',
              answerKo:
                  '오른쪽: 좋아요 (하트 1개)\n왼쪽: 패스\n위로: 슈퍼라이크 (하트 5개)',
              answerEn:
                  'Right: Like (1 heart)\nLeft: Pass\nUp: Super Like (5 hearts)',
              relatedIds: ['hearts_messages'],
            ),
            FAQItem(
              questionKo: '매칭된 페르소나는 어디서 보나요?',
              questionEn: 'Where can I see matched personas?',
              answerKo:
                  '홈 화면 하단의 채팅 탭에서 매칭된 모든 페르소나를 볼 수 있습니다.',
              answerEn:
                  'You can see all matched personas in the Chat tab at the bottom of the home screen.',
            ),
          ],
        ),

        // 💬 대화 기능
        FAQCategory(
          id: 'conversation',
          titleKo: '대화 기능',
          titleEn: 'Conversation Features',
          icon: Icons.chat_bubble_outline,
          gradientColors: [Color(0xFF43E97B), Color(0xFF38F9D7)],
          items: [
            FAQItem(
              questionKo: '외국어로 대화할 수 있나요?',
              questionEn: 'Can I chat in foreign languages?',
              answerKo:
                  '네! 외국어로 메시지를 보내면 AI가 자동으로 인식합니다. 메시지를 탭하면 번역을 볼 수 있어요.',
              answerEn:
                  'Yes! AI automatically recognizes foreign language messages. Tap a message to see the translation.',
              relatedIds: ['conversation'],
            ),
            FAQItem(
              questionKo: '대화 오류를 발견했어요',
              questionEn: 'I found a conversation error',
              answerKo:
                  '채팅방 우측 상단 더보기(⋮) → \'대화 오류 전송하기\'를 눌러 신고해주세요. 서비스 개선에 큰 도움이 됩니다!',
              answerEn:
                  'Tap More(⋮) in top right → \'Report Conversation Error\'. It helps improve our service!',
              relatedIds: ['troubleshooting'],
            ),
            FAQItem(
              questionKo: 'MBTI별 대화 팁이 있나요?',
              questionEn: 'Any conversation tips by MBTI?',
              answerKo:
                  'E(외향): 활발하고 다양한 주제로 대화\nI(내향): 깊이 있는 대화 선호\nT(사고): 논리적이고 객관적인 대화\nF(감정): 공감과 감정 표현 중요',
              answerEn:
                  'E(Extrovert): Active, various topics\nI(Introvert): Prefers deep conversations\nT(Thinking): Logical, objective talks\nF(Feeling): Empathy and emotions matter',
              relatedIds: ['affinity', 'persona_matching'],
            ),
          ],
        ),

        // ⚙️ 설정 & 계정
        FAQCategory(
          id: 'settings_account',
          titleKo: '설정 & 계정',
          titleEn: 'Settings & Account',
          icon: Icons.settings_outlined,
          gradientColors: [Color(0xFF6A85B6), Color(0xFFBAC8E0)],
          items: [
            FAQItem(
              questionKo: '캐시 관리는 어떻게 하나요?',
              questionEn: 'How do I manage cache?',
              answerKo:
                  '설정 → 저장소 관리 → 이미지 캐시 관리에서 캐시를 삭제할 수 있습니다. 캐시를 삭제하면 이미지를 다시 다운로드해야 합니다.',
              answerEn:
                  'Settings → Storage Management → Image Cache Management to delete cache. After deletion, images will need to be re-downloaded.',
            ),
            FAQItem(
              questionKo: '계정을 삭제하려면?',
              questionEn: 'How to delete account?',
              answerKo:
                  '설정 → 계정 관리 → 계정 삭제를 선택하세요.\n\n⚠️ 주의: 모든 대화 기록, 하트, 구독이 영구 삭제되며 복구할 수 없습니다.',
              answerEn:
                  'Settings → Account Management → Delete Account.\n\n⚠️ Warning: All chats, hearts, and subscriptions will be permanently deleted and cannot be recovered.',
            ),
            FAQItem(
              questionKo: '알림 설정은 어떻게 변경하나요?',
              questionEn: 'How do I change notification settings?',
              answerKo:
                  '설정 → 알림 설정에서 푸시 알림, 효과음, 햅틱 피드백을 켜거나 끌 수 있습니다.',
              answerEn:
                  'Settings → Notification Settings to toggle push notifications, sound effects, and haptic feedback.',
            ),
            FAQItem(
              questionKo: '테마를 변경하고 싶어요',
              questionEn: 'I want to change the theme',
              answerKo:
                  '설정 → 테마 설정에서 라이트/다크/시스템 테마를 선택할 수 있습니다.',
              answerEn:
                  'Settings → Theme Settings to choose Light/Dark/System theme.',
            ),
          ],
        ),

        // 🐛 문제 해결
        FAQCategory(
          id: 'troubleshooting',
          titleKo: '문제 해결',
          titleEn: 'Troubleshooting',
          icon: Icons.bug_report_outlined,
          gradientColors: [Color(0xFF667EEA), Color(0xFF764BA2)],
          items: [
            FAQItem(
              questionKo: '메시지가 전송되지 않아요',
              questionEn: 'Messages won\'t send',
              answerKo:
                  '1. 인터넷 연결 확인\n2. 일일 메시지 한도 확인 (100개)\n3. 앱 재시작\n4. 문제 지속 시 support@sona.app으로 문의',
              answerEn:
                  '1. Check internet connection\n2. Check daily message limit (100)\n3. Restart app\n4. If problem persists, contact support@sona.app',
              relatedIds: ['hearts_messages'],
            ),
            FAQItem(
              questionKo: '페르소나가 응답하지 않아요',
              questionEn: 'Persona not responding',
              answerKo:
                  '페르소나가 생각 중일 수 있습니다. 1-2분 기다려보시고, 계속 응답이 없으면 채팅방을 나갔다가 다시 들어와보세요.',
              answerEn:
                  'The persona might be thinking. Wait 1-2 minutes, if still no response, exit and re-enter the chat room.',
            ),
            FAQItem(
              questionKo: '앱이 느려요',
              questionEn: 'App is slow',
              answerKo:
                  '1. 캐시 삭제 (설정 → 저장소 관리)\n2. 앱 업데이트 확인\n3. 기기 재시작\n4. 백그라운드 앱 종료',
              answerEn:
                  '1. Clear cache (Settings → Storage Management)\n2. Check for app updates\n3. Restart device\n4. Close background apps',
              relatedIds: ['settings_account'],
            ),
          ],
        ),

        // 📱 프리미엄 기능
        FAQCategory(
          id: 'premium',
          titleKo: '프리미엄 기능',
          titleEn: 'Premium Features',
          icon: Icons.star_outline,
          gradientColors: [Color(0xFFFECA57), Color(0xFFFF6B9D)],
          items: [
            FAQItem(
              questionKo: '프리미엄 구독의 혜택은?',
              questionEn: 'What are premium subscription benefits?',
              answerKo:
                  '• 무제한 메시지\n• 매달 보너스 하트\n• 프리미엄 페르소나 우선 매칭\n• 광고 제거',
              answerEn:
                  '• Unlimited messages\n• Monthly bonus hearts\n• Premium persona priority matching\n• Ad-free experience',
              relatedIds: ['hearts_messages'],
            ),
            FAQItem(
              questionKo: '구독을 취소하려면?',
              questionEn: 'How to cancel subscription?',
              answerKo:
                  'iOS: 설정 → Apple ID → 구독\nAndroid: Play Store → 프로필 → 결제 및 구독 → 구독',
              answerEn:
                  'iOS: Settings → Apple ID → Subscriptions\nAndroid: Play Store → Profile → Payments & Subscriptions → Subscriptions',
            ),
            FAQItem(
              questionKo: '환불은 가능한가요?',
              questionEn: 'Can I get a refund?',
              answerKo:
                  'iOS: App Store 구매 내역에서 환불 신청\nAndroid: Play Store 주문 내역에서 환불 요청\n\n사용하지 않은 하트는 환불 가능합니다.',
              answerEn:
                  'iOS: Request refund from App Store purchase history\nAndroid: Request refund from Play Store order history\n\nUnused hearts are refundable.',
            ),
          ],
        ),
      ];

  // 모든 FAQ 아이템을 평면 리스트로 반환 (검색용)
  static List<FAQItemWithCategory> get allItems {
    final List<FAQItemWithCategory> items = [];
    for (final category in categories) {
      for (final item in category.items) {
        items.add(FAQItemWithCategory(
          item: item,
          category: category,
        ));
      }
    }
    return items;
  }

  // FAQ 검색 기능
  static List<FAQItemWithCategory> search(String query, bool isKorean) {
    if (query.isEmpty) return [];

    final lowerQuery = query.toLowerCase();
    final results = <FAQItemWithCategory>[];

    for (final category in categories) {
      for (final item in category.items) {
        final question = item.getQuestion(isKorean).toLowerCase();
        final answer = item.getAnswer(isKorean).toLowerCase();

        if (question.contains(lowerQuery) || answer.contains(lowerQuery)) {
          results.add(FAQItemWithCategory(
            item: item,
            category: category,
          ));
        }
      }
    }

    return results;
  }

  // 관련 FAQ 가져오기
  static List<FAQItemWithCategory> getRelatedItems(
      List<String>? relatedIds, String currentQuestionKo) {
    if (relatedIds == null || relatedIds.isEmpty) return [];

    final results = <FAQItemWithCategory>[];
    for (final categoryId in relatedIds) {
      final category = categories.firstWhere(
        (c) => c.id == categoryId,
        orElse: () => categories.first,
      );
      
      // 현재 질문과 다른 첫 번째 아이템 추가
      for (final item in category.items) {
        if (item.questionKo != currentQuestionKo) {
          results.add(FAQItemWithCategory(
            item: item,
            category: category,
          ));
          break;
        }
      }
    }

    return results.take(3).toList(); // 최대 3개까지만 반환
  }
}

// FAQ 아이템과 카테고리를 함께 담는 클래스
class FAQItemWithCategory {
  final FAQItem item;
  final FAQCategory category;

  const FAQItemWithCategory({
    required this.item,
    required this.category,
  });
}