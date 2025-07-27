import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('개인정보 처리방침'),
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
              'SONA 개인정보 처리방침',
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
              title: '1. 개인정보 수집 및 이용 목적',
              content: '''
SONA(이하 "앱")는 다음 목적으로 개인정보를 수집 및 이용합니다:

• 회원 가입 및 계정 관리
• AI 페르소나 대화 서비스 제공
• 서비스 품질 향상 및 맞춤형 서비스 제공
• 고객 지원 및 문의 대응
• 서비스 이용 통계 분석
              ''',
            ),
            
            _SectionWidget(
              title: '2. 수집하는 개인정보 항목',
              content: '''
앱에서 수집하는 개인정보는 다음과 같습니다:

필수 정보:
• Google 계정 정보 (이메일, 프로필 사진, 이름)
• 기기 정보 (기기 ID, 운영체제 버전)
• 서비스 이용 기록 (대화 내역, 이용 시간)

선택 정보:
• 사용자 설정 정보
• 피드백 및 문의 내용
              ''',
            ),
            
            _SectionWidget(
              title: '3. 개인정보 보관 및 이용 기간',
              content: '''
• 회원 탈퇴 시까지 보관하며, 탈퇴 즉시 파기됩니다.
• 법령에 의해 보관이 필요한 경우 해당 기간까지 보관합니다.
• 서비스 이용 기록은 통계 분석 후 즉시 익명화됩니다.
              ''',
            ),
            
            _SectionWidget(
              title: '4. 개인정보 제3자 제공',
              content: '''
앱은 다음의 경우를 제외하고는 개인정보를 제3자에게 제공하지 않습니다:

• 사용자의 동의가 있는 경우
• 법령에 의해 요구되는 경우
• OpenAI 등 AI 서비스 제공을 위한 필요한 경우 (대화 내용은 익명화하여 전송)
              ''',
            ),
            
            _SectionWidget(
              title: '5. 개인정보 보호를 위한 기술적 보호조치',
              content: '''
• Firebase 보안 시스템을 통한 데이터 암호화
• HTTPS 통신을 통한 전송 구간 암호화
• 접근 권한 관리 및 로그 모니터링
• 정기적인 보안 점검 및 업데이트
              ''',
            ),
            
            _SectionWidget(
              title: '6. 이용자의 권리',
              content: '''
사용자는 다음 권리를 행사할 수 있습니다:

• 개인정보 열람, 정정, 삭제 요구
• 개인정보 처리 정지 요구
• 손해 발생 시 피해 구제 신청
• 회원 탈퇴 및 개인정보 전체 삭제

이러한 권리 행사를 원하실 경우:
1. 앱 내 설정 > 계정 관리에서 직접 처리
2. 고객센터 이메일(privacy@sona-app.com)로 요청
3. 회원 탈퇴 시 모든 개인정보는 즉시 삭제됩니다

데이터 삭제 요청 시 처리 기간:
• 일반 요청: 3영업일 이내
• 회원 탈퇴: 즉시 처리
              ''',
            ),
            
            _SectionWidget(
              title: '7. 개인정보보호책임자',
              content: '''
개인정보 처리에 관한 문의사항이 있으시면 아래로 연락주시기 바랍니다:

• 이메일: privacy@sona-app.com
• 개인정보보호책임자: SONA 개발팀
• 처리 부서: 개발운영팀
              ''',
            ),
            
            _SectionWidget(
              title: '8. 개인정보 처리방침 변경',
              content: '''
본 개인정보 처리방침은 법령, 정책 또는 보안기술의 변경에 따라 내용의 추가, 
삭제 및 수정이 있을 시에는 변경 최소 7일 전부터 앱을 통해 변경 이유 및 내용 등을 공지하도록 하겠습니다.

본 개인정보 처리방침은 2024년 7월 24일부터 적용됩니다.
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