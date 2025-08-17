import 'package:flutter_test/flutter_test.dart';
import 'package:sona_app/services/chat/security/security_aware_post_processor.dart';
import 'package:sona_app/services/relationship/negative_behavior_system.dart';
import 'package:sona_app/models/persona.dart';

void main() {
  group('의문문 교정 버그 수정 테스트', () {
    test('완전 좋아해! 가 물음표로 변경되지 않아야 함', () {
      final persona = Persona(
        id: 'test',
        name: '테스트',
        mbti: 'ENFP',
        age: 25,
        description: '테스트',
        photoUrls: [],
        personality: '테스트',
        likes: 100,
      );
      
      // 테스트 케이스 1: 완전 좋아해!
      String input = '완전 좋아해!';
      String result = SecurityAwarePostProcessor.processResponse(
        rawResponse: input,
        persona: persona,
      );
      
      expect(result.contains('완전 좋아해?'), false, 
        reason: '완전 좋아해!가 물음표로 변경되면 안됨');
      expect(!result.contains('?') || result.contains('!'), true,
        reason: '감탄문은 느낌표를 유지해야 함');
    });
    
    test('다양한 감탄문 패턴이 의문문으로 변경되지 않아야 함', () {
      final persona = Persona(
        id: 'test',
        name: '테스트',
        mbti: 'ENFP',
        age: 25,
        description: '테스트',
        photoUrls: [],
        personality: '테스트',
        likes: 100,
      );
      
      final testCases = [
        '진짜 좋아해!',
        '정말 좋아해!',
        '너무 좋아해!',
        '완전 멋있어!',
        '진짜 예뻐!',
        '너무 귀여워!',
        '개좋아!',
        '대박!',
        '짱이야!',
        '최고야!'
      ];
      
      for (final testCase in testCases) {
        String result = SecurityAwarePostProcessor.processResponse(
          rawResponse: testCase,
          persona: persona,
        );
        
        expect(result.contains('?'), false,
          reason: '$testCase 는 감탄문이므로 물음표가 붙으면 안됨');
      }
    });
    
    test('실제 의문문은 물음표가 붙어야 함', () {
      final persona = Persona(
        id: 'test',
        name: '테스트',
        mbti: 'ENFP',
        age: 25,
        description: '테스트',
        photoUrls: [],
        personality: '테스트',
        likes: 100,
      );
      
      final testCases = [
        '뭐해',
        '어디야',
        '언제 와',
        '왜 그래',
        '어떻게 생각해'
      ];
      
      for (final testCase in testCases) {
        String result = SecurityAwarePostProcessor.processResponse(
          rawResponse: testCase,
          persona: persona,
        );
        
        expect(result.contains('?'), true,
          reason: '$testCase 는 의문문이므로 물음표가 붙어야 함');
      }
    });
  });
  
  group('애니메이션 캐릭터 죽음 관련 오류 수정 테스트', () {
    test('아르민이 죽었다는 레벨3 위협이 아니어야 함', () {
      final negativeSystem = NegativeBehaviorSystem();
      
      // 테스트 케이스 1: 아르민이 죽었다
      final result1 = negativeSystem.analyze('아르민이 죽었다', likes: 100);
      expect(result1.level, lessThan(3),
        reason: '아르민이 죽었다는 캐릭터 서술이므로 레벨3 위협이 아님');
      
      // 테스트 케이스 2: 에렌이 죽었어
      final result2 = negativeSystem.analyze('에렌이 죽었어', likes: 100);
      expect(result2.level, lessThan(3),
        reason: '에렌이 죽었어는 캐릭터 서술이므로 레벨3 위협이 아님');
      
      // 테스트 케이스 3: 주인공이 죽음
      final result3 = negativeSystem.analyze('주인공이 죽음', likes: 100);
      expect(result3.level, lessThan(3),
        reason: '주인공이 죽음은 작품 서술이므로 레벨3 위협이 아님');
    });
    
    test('직접적인 위협은 여전히 레벨3이어야 함', () {
      final negativeSystem = NegativeBehaviorSystem();
      
      // 테스트 케이스 1: 너 죽어
      final result1 = negativeSystem.analyze('너 죽어', likes: 100);
      expect(result1.level, equals(3),
        reason: '너 죽어는 직접적인 위협이므로 레벨3');
      
      // 테스트 케이스 2: 네가 죽을래
      final result2 = negativeSystem.analyze('네가 죽을래', likes: 100);
      expect(result2.level, equals(3),
        reason: '네가 죽을래는 직접적인 위협이므로 레벨3');
      
      // 테스트 케이스 3: 죽어 (단독)
      final result3 = negativeSystem.analyze('죽어', likes: 100);
      expect(result3.level, equals(3),
        reason: '죽어는 명령형 위협이므로 레벨3');
    });
    
    test('애매한 표현은 레벨2로 처리되어야 함', () {
      final negativeSystem = NegativeBehaviorSystem();
      
      // 테스트 케이스: 죽고 싶다
      final result = negativeSystem.analyze('죽고 싶다', likes: 100);
      expect(result.level, equals(2),
        reason: '죽고 싶다는 간접적이므로 레벨2');
    });
  });
}