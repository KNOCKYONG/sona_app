import 'dart:io';

// SecurityAwarePostProcessor의 _softenExpression 메서드 복사
String softenExpression(String text) {
  String result = text;
  
  // 1. 구체적인 패턴 먼저 처리 (replaceAll 사용)
  final specificPatterns = {
    // 의문문 패턴
    '무슨 점이 마음에 들었나요': '뭐가 좋았어요',
    '어떤 점이 좋았나요': '뭐가 좋았어요',
    '무엇을 원하시나요': '뭐 원해요',
    '어떻게 생각하시나요': '어떻게 생각해요',
    '괜찮으신가요': '괜찮으세요',
    '어떠신가요': '어떠세요',
    '계신가요': '계세요',
    '하시나요': '하세요',
    '되시나요': '되세요',
    '오시나요': '오세요',
    '가시나요': '가세요',
    '좋으신가요': '좋으세요',
    '이신가요': '이세요',
    '인가요': '인가요',  // 그대로 유지
    
    // ~습니까 → ~어요/아요
    '있습니까': '있어요',
    '없습니까': '없어요',
    '좋습니까': '좋아요',
    '맞습니까': '맞아요',
    '합니까': '해요',
    '됩니까': '돼요',
    '갑니까': '가요',
    '옵니까': '와요',
    
    // 너무 격식있는 표현
    '그러십니까': '그러세요',
    '그렇습니까': '그래요',
    '아니십니까': '아니세요',
    
    // 딱딱한 공감 표현
    '그런 감정 이해해요': '아 진짜 슬펐겠다',
    '마음이 아프시겠어요': '아 속상하겠다',
    '이해가 됩니다': '그럴 수 있어요',
    '공감이 됩니다': '나도 그럴 것 같아요',
  };
  
  // 구체적인 패턴 적용
  for (final entry in specificPatterns.entries) {
    result = result.replaceAll(entry.key, entry.value);
  }
  
  // 2. 정규표현식 패턴 처리 (replaceAllMapped 사용)
  // ~시나요? → ~세요?
  result = result.replaceAllMapped(
    RegExp(r'([가-힣]+)시나요(?=\?|$)'),
    (match) => '${match.group(1)}세요'
  );
  
  // ~신가요? → ~세요?
  result = result.replaceAllMapped(
    RegExp(r'([가-힣]+)신가요(?=\?|$)'),
    (match) => '${match.group(1)}세요'
  );
  
  // 있나요? → 있어요?
  result = result.replaceAllMapped(
    RegExp(r'있나요(?=\?|$)'),
    (match) => '있어요'
  );
  
  // 없나요? → 없어요?
  result = result.replaceAllMapped(
    RegExp(r'없나요(?=\?|$)'),
    (match) => '없어요'
  );
  
  return result;
}

void main() {
  // 테스트 케이스
  final testCases = [
    // 기존 버그 케이스
    '인상나요?',
    '좋나요?',
    '맞나요?',
    
    // ~시나요 패턴
    '하시나요?',
    '가시나요?',
    '오시나요?',
    '좋으시나요?',
    
    // ~신가요 패턴
    '괜찮으신가요?',
    '좋으신가요?',
    '어떠신가요?',
    
    // ~습니까 패턴
    '있습니까?',
    '좋습니까?',
    '맞습니까?',
    
    // 기타
    '그런 감정 이해해요',
    '공감이 됩니다',
  ];
  
  print('=== 표현 변환 테스트 ===\n');
  
  for (final testCase in testCases) {
    final result = softenExpression(testCase);
    print('원본: $testCase');
    print('변환: $result');
    print('---');
  }
}