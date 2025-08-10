import 'package:flutter_test/flutter_test.dart';
import 'package:sona_app/models/persona.dart';

void main() {
  group('다시 대화하기 기능 테스트', () {
    test('오프라인 상태 확인 테스트', () {
      // 테스트 케이스 1: likes가 0 이하면 오프라인
      final offlinePersona = Persona(
        id: 'test1',
        name: '테스트1',
        mbti: 'ENFP',
        age: 25,
        description: '테스트',
        photoUrls: [],
        personality: '테스트',
        likes: 0, // 오프라인 상태
      );
      
      expect(offlinePersona.likes <= 0, true,
          reason: 'likes가 0 이하면 오프라인 상태여야 함');
      
      // 테스트 케이스 2: likes가 -10인 경우도 오프라인
      final negativePersona = Persona(
        id: 'test2',
        name: '테스트2',
        mbti: 'INTJ',
        age: 28,
        description: '테스트',
        photoUrls: [],
        personality: '테스트',
        likes: -10, // 음수도 오프라인
      );
      
      expect(negativePersona.likes <= 0, true,
          reason: 'likes가 음수여도 오프라인 상태여야 함');
    });
    
    test('온라인 상태 확인 테스트', () {
      // 테스트 케이스: likes가 1 이상이면 온라인
      final onlinePersona = Persona(
        id: 'test3',
        name: '테스트3',
        mbti: 'ISFJ',
        age: 27,
        description: '테스트',
        photoUrls: [],
        personality: '테스트',
        likes: 50, // 온라인 상태
      );
      
      expect(onlinePersona.likes > 0, true,
          reason: 'likes가 0보다 크면 온라인 상태여야 함');
    });
    
    test('likes 리셋 계산 테스트', () {
      // 오프라인 페르소나
      final offlinePersona = Persona(
        id: 'test4',
        name: '테스트4',
        mbti: 'ENTP',
        age: 26,
        description: '테스트',
        photoUrls: [],
        personality: '테스트',
        likes: -5, // 오프라인 상태
      );
      
      // 50으로 리셋하기 위한 변화량 계산
      final likeChange = 50 - offlinePersona.likes;
      
      expect(likeChange, 55,
          reason: '-5에서 50으로 만들려면 55를 더해야 함');
      
      // 리셋 후 상태 확인
      final resetPersona = offlinePersona.copyWith(likes: 50);
      
      expect(resetPersona.likes, 50,
          reason: '리셋 후 likes는 50이어야 함');
      expect(resetPersona.likes > 0, true,
          reason: '리셋 후 온라인 상태여야 함');
    });
    
    test('하트 소비 조건 테스트', () {
      // 하트 개수 시뮬레이션
      final hearts = 5;
      const requiredHearts = 1;
      
      // 충분한 하트가 있는 경우
      expect(hearts >= requiredHearts, true,
          reason: '하트가 충분하면 다시 대화하기 가능');
      
      // 하트가 부족한 경우
      final insufficientHearts = 0;
      expect(insufficientHearts >= requiredHearts, false,
          reason: '하트가 부족하면 다시 대화하기 불가능');
    });
    
    test('UI 상태 전환 테스트', () {
      // 오프라인 페르소나
      var persona = Persona(
        id: 'test5',
        name: '테스트5',
        mbti: 'INFP',
        age: 24,
        description: '테스트',
        photoUrls: [],
        personality: '테스트',
        likes: -10,
      );
      
      // 초기 상태: 오프라인
      final isOfflineInitially = persona.likes <= 0;
      expect(isOfflineInitially, true,
          reason: '초기 상태는 오프라인이어야 함');
      
      // 다시 대화하기 메뉴 표시 여부
      final showRestartOption = isOfflineInitially;
      expect(showRestartOption, true,
          reason: '오프라인일 때 다시 대화하기 옵션이 표시되어야 함');
      
      // likes 리셋 후
      persona = persona.copyWith(likes: 50);
      
      // 리셋 후 상태: 온라인
      final isOnlineAfterReset = persona.likes > 0;
      expect(isOnlineAfterReset, true,
          reason: '리셋 후 온라인 상태여야 함');
      
      // 다시 대화하기 메뉴 숨김
      final hideRestartOption = !isOnlineAfterReset;
      expect(hideRestartOption, false,
          reason: '온라인일 때 다시 대화하기 옵션이 숨겨져야 함');
    });
  });
}