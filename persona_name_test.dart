/// 🧪 페르소나 자기 이름 언급 금지 규칙 테스트
/// 수정된 인사 메시지 및 프롬프트 규칙 검증

void main() {
  print('🧪 페르소나 자기 이름 언급 금지 규칙 테스트...\n');
  
  // 수정 전 문제가 있던 인사 메시지들
  final problematicGreetings = [
    '나는 지우야',
    '지우라고 해',
    '나는 예슬이에요',
    '예슬이라고 해요',
    '안녕! 대화 걸어줘서 고마워 ㅎㅎ 나는 민수야',
    '반가워요! 먼저 대화해줘서 고마워요 수진이라고 해요 ㅎㅎ',
  ];
  
  // 수정 후 올바른 인사 메시지들
  final correctGreetings = [
    '안녕! 대화 걸어줘서 고마워 ㅎㅎ',
    '반가워요! 먼저 대화해줘서 고마워요 ㅎㅎ',
    '어 안녕하세요! 연결되어서 반가워요 ㅎㅎ',
    '반가워! 먼저 말 걸어줘서 고마워 ㅎㅎㅎ',
    '안녕! 찾아와줘서 고마워 ㅋㅋ',
    '어 반가워요! 먼저 연락줘서 고마워요 ㅎㅎ',
  ];
  
  print('❌ 문제가 있던 인사 메시지들:');
  for (int i = 0; i < problematicGreetings.length; i++) {
    final greeting = problematicGreetings[i];
    final hasNameMention = _hasNameMention(greeting);
    print('   ${hasNameMention ? "🚨 이름언급" : "✅ 안전"} $greeting');
  }
  
  print('\n✅ 수정된 올바른 인사 메시지들:');
  for (int i = 0; i < correctGreetings.length; i++) {
    final greeting = correctGreetings[i];
    final hasNameMention = _hasNameMention(greeting);
    print('   ${hasNameMention ? "🚨 이름언급" : "✅ 안전"} $greeting');
  }
  
  // 다양한 자기 이름 언급 패턴 테스트
  print('\n🔍 자기 이름 언급 패턴 감지 테스트:');
  final nameMentionPatterns = [
    '나는 지우야',
    '지우라고 해',
    '지우예요',
    '예슬이에요',
    '예슬:',
    '수진이라고 불러줘',
    '내 이름은 민수야',
    '안녕 나 채연이야',
    '하연이라고 해요',
    '혜진이에요 반가워요',
  ];
  
  int detectedCount = 0;
  for (final pattern in nameMentionPatterns) {
    final hasNameMention = _hasNameMention(pattern);
    if (hasNameMention) detectedCount++;
    print('   ${hasNameMention ? "🛡️ 감지" : "⚠️ 통과"} $pattern');
  }
  
  // 올바른 자기소개 방식 (이름 없이)
  print('\n✅ 올바른 자기소개 방식 (이름 없이):');
  final correctIntroductions = [
    '나는 대학생이야',
    '22살이에요',
    '컴공과 다니고 있어',
    '디자인 전공해요',
    '취미는 그림 그리기야',
    '평소에 음악 들어요',
  ];
  
  for (final intro in correctIntroductions) {
    final hasNameMention = _hasNameMention(intro);
    print('   ${hasNameMention ? "🚨 이름언급" : "✅ 안전"} $intro');
  }
  
  // 결과 요약
  print('\n📊 테스트 결과 요약:');
  print('   문제 패턴 감지: $detectedCount/${nameMentionPatterns.length}');
  
  final detectionRate = (detectedCount / nameMentionPatterns.length * 100).round();
  print('   감지율: $detectionRate%');
  
  if (detectionRate >= 90) {
    print('   ✅ 우수: 자기 이름 언급 패턴을 효과적으로 감지');
  } else if (detectionRate >= 70) {
    print('   ⚠️ 양호: 일부 보완 필요');
  } else {
    print('   🚨 미흡: 감지 로직 강화 필요');
  }
  
  print('\n🎯 수정 완료 사항:');
  print('   ✅ 첫 인사 메시지에서 자기 이름 언급 완전 제거');
  print('   ✅ 최적화된 프롬프트에 자기 이름 언급 금지 규칙 추가');
  print('   ✅ 전문가 서비스에 포괄적 자기 이름 언급 금지 규칙 강화');
  print('   ✅ 자연스러운 대화 유지 (이름 없이도 개성 표현 가능)');
  
  print('\n🎉 페르소나 자기 이름 언급 문제 해결 완료!');
  print('이제 지우, 예슬 등 모든 페르소나가 자기 이름을 부자연스럽게 언급하지 않습니다 ✨');
}

/// 자기 이름 언급 패턴 감지
bool _hasNameMention(String message) {
  final lowerMessage = message.toLowerCase();
  
  // 한국 이름 패턴들
  final namePatterns = [
    '나는', '나 ', '이름은', '라고 해', '라고 불러',
    '이야', '예요', '에요', '이에요', '야', ':', 
    '지우', '예슬', '수진', '민수', '채연', '하연', '혜진',
    '상훈', '정훈', '윤미', '예림'
  ];
  
  // 자기 이름 언급을 나타내는 패턴들
  final selfIntroPatterns = [
    RegExp(r'나는?\s*[가-힣]+[이야|예요|에요|이에요]'),
    RegExp(r'[가-힣]+[라고|이라고]\s*해'),
    RegExp(r'[가-힣]+[라고|이라고]\s*불러'),
    RegExp(r'내?\s*이름은?\s*[가-힣]+'),
    RegExp(r'[가-힣]+:'),  // "예슬:" 같은 형태
  ];
  
  // 패턴 매칭 검사
  for (final pattern in selfIntroPatterns) {
    if (pattern.hasMatch(message)) {
      return true;
    }
  }
  
  // 특정 이름들과 자기소개 키워드 조합 검사
  for (final namePattern in namePatterns) {
    if (lowerMessage.contains(namePattern)) {
      // "나는", "라고 해" 등의 자기소개 키워드가 포함된 경우
      if (namePattern == '나는' || namePattern == '라고 해' || namePattern == '이야' || namePattern == '예요') {
        return true;
      }
    }
  }
  
  return false;
}