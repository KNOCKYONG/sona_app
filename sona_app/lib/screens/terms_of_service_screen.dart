import 'package:flutter/material.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('서비스 이용약관'),
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
              'SONA 서비스 이용약관',
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
              title: '제1조 (목적)',
              content: '''
본 약관은 SONA(이하 "회사")가 제공하는 AI 페르소나 대화 매칭 서비스(이하 "서비스")의 이용과 관련하여 회사와 이용자 간의 권리, 의무 및 책임사항을 규정함을 목적으로 합니다.
              ''',
            ),
            
            _SectionWidget(
              title: '제2조 (정의)',
              content: '''
1. "서비스"란 회사가 제공하는 AI 페르소나 대화 매칭 플랫폼을 의미합니다.
2. "이용자"란 본 약관에 따라 회사와 이용계약을 체결하고 서비스를 이용하는 자를 의미합니다.
3. "페르소나"란 AI 기술을 활용하여 구현된 가상의 대화 상대를 의미합니다.
4. "콘텐츠"란 이용자가 서비스를 이용하면서 생성하는 모든 형태의 정보를 의미합니다.
              ''',
            ),
            
            _SectionWidget(
              title: '제3조 (약관의 효력 및 변경)',
              content: '''
1. 본 약관은 서비스 화면에 게시하거나 기타의 방법으로 이용자에게 공지함으로써 효력이 발생합니다.
2. 회사는 관련 법령을 위배하지 않는 범위에서 본 약관을 변경할 수 있습니다.
3. 약관이 변경되는 경우 변경사유 및 적용일자를 명시하여 최소 7일 전에 공지합니다.
              ''',
            ),
            
            _SectionWidget(
              title: '제4조 (서비스의 제공)',
              content: '''
1. 회사는 다음과 같은 서비스를 제공합니다:
   • AI 페르소나와의 대화 서비스
   • 개인 맞춤형 페르소나 추천
   • 대화 기록 관리
   • 기타 회사가 정하는 서비스

2. 회사는 서비스의 품질 향상을 위해 서비스의 내용을 변경할 수 있습니다.
              ''',
            ),
            
            _SectionWidget(
              title: '제5조 (회원가입)',
              content: '''
1. 이용자는 회사가 정한 가입 양식에 따라 회원정보를 기입한 후 본 약관에 동의한다는 의사표시를 함으로써 회원가입을 신청합니다.
2. 회사는 다음 각 호에 해당하는 신청에 대하여는 승낙하지 않을 수 있습니다:
   • 타인의 명의를 이용한 경우
   • 허위의 정보를 기재한 경우
   • 사회의 안녕과 질서, 미풍양속을 저해할 목적으로 신청한 경우
              ''',
            ),
            
            _SectionWidget(
              title: '제6조 (이용자의 의무)',
              content: '''
1. 이용자는 다음 행위를 하여서는 안 됩니다:
   • 신청 또는 변경 시 허위 내용의 등록
   • 타인의 정보 도용
   • 회사가 게시한 정보의 변경
   • 회사가 정한 정보 이외의 정보(컴퓨터 프로그램 등) 등의 송신 또는 게시
   • 회사 기타 제3자의 저작권 등 지적재산권에 대한 침해
   • 회사 기타 제3자의 명예를 손상시키거나 업무를 방해하는 행위
   • 외설 또는 폭력적인 메시지, 화상, 음성, 기타 공서양속에 반하는 정보를 서비스에 공개 또는 게시하는 행위

2. 이용자는 관계법령, 본 약관의 규정, 이용안내 및 서비스상에 공지한 주의사항, 회사가 통지하는 사항 등을 준수하여야 합니다.
              ''',
            ),
            
            _SectionWidget(
              title: '제7조 (서비스 이용제한)',
              content: '''
회사는 이용자가 본 약관의 의무를 위반하거나 서비스의 정상적인 운영을 방해한 경우, 경고, 일시정지, 영구이용정지 등으로 서비스 이용을 단계적으로 제한할 수 있습니다.
              ''',
            ),
            
            _SectionWidget(
              title: '제8조 (서비스 중단)',
              content: '''
1. 회사는 컴퓨터 등 정보통신설비의 보수점검, 교체 및 고장, 통신의 두절 등의 사유가 발생한 경우에는 서비스의 제공을 일시적으로 중단할 수 있습니다.
2. 회사는 제1항의 사유로 서비스의 제공이 일시적으로 중단됨으로 인하여 이용자 또는 제3자가 입은 손해에 대하여 배상하지 아니합니다.
              ''',
            ),
            
            _SectionWidget(
              title: '제9조 (면책조항)',
              content: '''
1. 회사는 천재지변 또는 이에 준하는 불가항력으로 인하여 서비스를 제공할 수 없는 경우에는 서비스 제공에 관한 책임이 면제됩니다.
2. 회사는 이용자의 귀책사유로 인한 서비스 이용의 장애에 대하여는 책임을 지지 않습니다.
3. 회사는 이용자가 서비스를 이용하여 기대하는 수익을 상실한 것에 대하여 책임을 지지 않습니다.
4. 회사는 AI 페르소나가 제공하는 정보의 정확성, 완전성에 대해 보장하지 않으며, 이로 인한 손해에 대해 책임을 지지 않습니다.
              ''',
            ),
            
            _SectionWidget(
              title: '제10조 (분쟁해결)',
              content: '''
1. 회사는 이용자가 제기하는 정당한 의견이나 불만을 반영하고 그 피해의 보상 등에 관하여 처리하기 위하여 피해보상처리기구를 설치·운영합니다.
2. 본 약관에 관해 분쟁이 있을 경우에는 대한민국법을 적용하며, 서울중앙지방법원을 관할 법원으로 합니다.
              ''',
            ),
            
            Text(
              '''
부칙

본 약관은 2024년 7월 24일부터 적용됩니다.

문의사항이 있으시면 앱 내 고객센터 또는 support@sona-app.com으로 연락주시기 바랍니다.
              ''',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
                height: 1.6,
              ),
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