import 'package:flutter/material.dart';

class PurchasePolicyScreen extends StatelessWidget {
  const PurchasePolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('구매 및 환불 정책'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'SONA 구매 및 환불 정책',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFF6B9D),
              ),
            ),
            SizedBox(height: 20),
            Text(
              '마지막 업데이트: 2024년 7월 24일',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 30),
            
            _SectionWidget(
              title: '1. 인앱 구매 상품',
              content: '''
SONA에서 제공하는 인앱 구매 상품:

프리미엄 구독:
• 1개월 구독: ₩9,900
• 3개월 구독: ₩24,900 (17% 할인)
• 6개월 구독: ₩44,900 (25% 할인)

하트 구매:
• 하트 10개: ₩1,200
• 하트 30개: ₩3,300 (8% 할인)
• 하트 50개: ₩4,900 (18% 할인)
              ''',
            ),
            
            _SectionWidget(
              title: '2. 결제 방법',
              content: '''
• Google Play Store: Google Play 계정에 등록된 결제 수단
• Apple App Store: Apple ID에 등록된 결제 수단

결제는 구매 확인 시 자동으로 청구됩니다.
              ''',
            ),
            
            _SectionWidget(
              title: '3. 구독 갱신 및 해지',
              content: '''
구독 자동 갱신:
• 구독은 취소하지 않는 한 자동으로 갱신됩니다
• 현재 구독 기간 종료 24시간 전에 갱신 요금이 청구됩니다

구독 해지 방법:

Android (Google Play):
1. Google Play Store 앱 실행
2. 프로필 아이콘 탭
3. 결제 및 구독 > 구독 선택
4. SONA 구독 선택 > 구독 취소

iOS (App Store):
1. 설정 앱 실행
2. 상단의 Apple ID 탭
3. 구독 선택
4. SONA 구독 선택 > 구독 취소

※ 구독 해지 후에도 남은 구독 기간 동안은 프리미엄 혜택을 이용할 수 있습니다.
              ''',
            ),
            
            _SectionWidget(
              title: '4. 환불 정책',
              content: '''
구독 상품:
• 구독 시작 후 7일 이내: 전액 환불 가능
• 7일 이후: 남은 기간에 대한 부분 환불 불가
• 자동 갱신된 구독: 갱신 후 48시간 이내 환불 요청 시 전액 환불

하트(소모성 상품):
• 구매 후 미사용 상태: 구매일로부터 7일 이내 환불 가능
• 일부라도 사용한 경우: 환불 불가

환불 요청 방법:
1. Google Play/App Store 환불 정책에 따라 직접 요청
2. 고객센터(support@sona-app.com)로 구매 영수증과 함께 요청

※ 환불 처리는 스토어 정책에 따라 3-5영업일 소요될 수 있습니다.
              ''',
            ),
            
            _SectionWidget(
              title: '5. 이용 제한',
              content: '''
다음의 경우 구매한 상품 이용이 제한될 수 있습니다:
• 부정한 방법으로 구매한 경우
• 환불 후 재구매를 반복하는 경우
• 서비스 이용약관을 위반한 경우

이용 제한 시 구매한 상품에 대한 환불은 불가합니다.
              ''',
            ),
            
            _SectionWidget(
              title: '6. 문의사항',
              content: '''
구매 관련 문의사항이 있으시면 아래로 연락주세요:

• 이메일: support@sona-app.com
• 고객센터 운영시간: 평일 10:00 - 18:00
• 답변 소요시간: 1-2영업일

구매 영수증과 함께 문의하시면 더 빠른 처리가 가능합니다.
              ''',
            ),
            
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _SectionWidget extends StatelessWidget {
  final String title;
  final String content;

  const _SectionWidget({
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black54,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}