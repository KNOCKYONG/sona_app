/// 첫 만남 감지 및 상태 관리를 위한 유틸리티 클래스
class FirstMeetingDetector {
  /// 첫 만남 단계 정의
  static const int greetingMessages = 5; // 첫 인사 단계
  static const int icebreakingMessages = 15; // 아이스브레이킹 단계
  static const int gettingToKnowMessages = 30; // 알아가는 단계

  /// 첫 만남 여부 확인
  static bool isFirstMeeting({
    required int messageCount,
    DateTime? matchedAt,
  }) {
    // 메시지가 30개 이하면 첫 만남으로 간주
    if (messageCount <= gettingToKnowMessages) {
      return true;
    }

    // 매칭된 지 24시간 이내면 첫 만남
    if (matchedAt != null) {
      final hoursSinceMatch = DateTime.now().difference(matchedAt).inHours;
      if (hoursSinceMatch < 24) {
        return true;
      }
    }

    return false;
  }

  /// 첫 만남 단계 확인
  static FirstMeetingStage getFirstMeetingStage({
    required int messageCount,
    required int relationshipScore,
  }) {
    if (messageCount <= greetingMessages) {
      return FirstMeetingStage.greeting;
    } else if (messageCount <= icebreakingMessages) {
      return FirstMeetingStage.icebreaking;
    } else if (messageCount <= gettingToKnowMessages) {
      return FirstMeetingStage.gettingToKnow;
    } else {
      return FirstMeetingStage.comfortable;
    }
  }

  /// 긴장감 표현 여부 결정
  static bool shouldBeNervous({
    required FirstMeetingStage stage,
    required int messageCount,
  }) {
    switch (stage) {
      case FirstMeetingStage.greeting:
        return true; // 항상 긴장
      case FirstMeetingStage.icebreaking:
        return messageCount < 10; // 초반에만 긴장
      case FirstMeetingStage.gettingToKnow:
        return messageCount < 20 && messageCount % 3 == 0; // 가끔 긴장
      case FirstMeetingStage.comfortable:
        return false; // 긴장하지 않음
    }
  }

  /// 첫 만남 대화 주제 제공
  static List<String> getFirstMeetingTopics() {
    return [
      '취미',
      '일상',
      '날씨',
      '음식',
      '영화',
      '음악',
      '여행',
      '주말 계획',
      '관심사',
      'MBTI',
      '좋아하는 것',
      '싫어하는 것',
    ];
  }

  /// 긴장감 표현 문구
  static List<String> getNervousExpressions(bool isCasual) {
    if (isCasual) {
      return [
        '아... 뭐라고 말해야 할지',
        '음... 조금 긴장되네',
        '처음이라 어색하다 ㅋㅋ',
        '뭔가 떨려',
        '이렇게 말하는 거 맞나?',
        '갑자기 할 말이 생각이 안 나네',
      ];
    } else {
      return [
        '아... 뭐라고 말해야 할지 모르겠어요',
        '음... 조금 긴장되네요',
        '처음이라 어색하네요 ㅋㅋ',
        '뭔가 떨려요',
        '이렇게 말하는 거 맞나요?',
        '갑자기 할 말이 생각이 안 나네요',
      ];
    }
  }

  /// 감사 표현 문구
  static List<String> getThankfulExpressions(bool isCasual) {
    if (isCasual) {
      return [
        '대화 걸어줘서 고마워',
        '먼저 연락해줘서 좋다',
        '연결되어서 반가워',
        '말 걸어줘서 기뻐',
        '대화할 수 있어서 좋아',
      ];
    } else {
      return [
        '대화 걸어주셔서 고마워요',
        '먼저 연락해주셔서 좋아요',
        '연결되어서 반가워요',
        '말 걸어주셔서 기뻐요',
        '대화할 수 있어서 좋아요',
      ];
    }
  }
}

/// 첫 만남 단계 열거형
enum FirstMeetingStage {
  greeting, // 첫 인사 (1-5 메시지)
  icebreaking, // 아이스브레이킹 (6-15 메시지)
  gettingToKnow, // 알아가는 중 (16-30 메시지)
  comfortable, // 편해진 단계 (31+ 메시지)
}
