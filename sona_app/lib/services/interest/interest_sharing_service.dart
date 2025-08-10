import 'package:flutter/material.dart';

class Interest {
  final InterestCategory category;
  final String name;
  final double affinity; // 0.0 - 1.0 (관심도)
  final List<String> subTopics;
  final Map<String, dynamic> metadata;
  
  Interest({
    required this.category,
    required this.name,
    required this.affinity,
    required this.subTopics,
    this.metadata = const {},
  });
}

class SharedInterest {
  final Interest userInterest;
  final Interest personaInterest;
  final double matchScore; // 0.0 - 1.0
  final List<String> commonTopics;
  final List<String> recommendations;
  
  SharedInterest({
    required this.userInterest,
    required this.personaInterest,
    required this.matchScore,
    required this.commonTopics,
    required this.recommendations,
  });
}


enum InterestCategory {
  gaming,        // 게임
  movies,        // 영화
  music,         // 음악
  sports,        // 운동
  books,         // 독서
  food,          // 음식
  travel,        // 여행
  fashion,       // 패션
  tech,          // 기술
  art,           // 예술
  cooking,       // 요리
  pets,          // 반려동물
}

/// 🎮 관심사 & 취미 공유 시스템
///
/// 사용자와 페르소나 간의 공통 관심사를 발견하고 공유합니다.
class InterestSharingService {
  
  // 관심사 카테고리

  
  // 관심사 항목

  
  // 공통 관심사

  
  // 사용자 관심사 저장소
  static final Map<String, List<Interest>> _userInterests = {};
  
  // 페르소나별 기본 관심사
  static final Map<String, List<Interest>> _personaInterests = {};
  
  // 추천 히스토리
  static final Map<String, List<String>> _recommendationHistory = {};
  
  /// 관심사 분석
  static Map<String, dynamic> analyzeInterests({
    required String userId,
    required String personaId,
    required String userMessage,
    required String personaMbti,
  }) {
    final key = '${userId}_$personaId';
    
    // 1. 메시지에서 관심사 추출
    final detectedInterests = _detectInterestsFromMessage(userMessage);
    
    // 2. 사용자 관심사 업데이트
    _updateUserInterests(userId, detectedInterests);
    
    // 3. 페르소나 관심사 가져오기
    final personaInterests = _getPersonaInterests(personaId, personaMbti);
    
    // 4. 공통 관심사 찾기
    final sharedInterests = _findSharedInterests(
      userInterests: _userInterests[userId] ?? [],
      personaInterests: personaInterests,
    );
    
    // 5. 추천 생성
    final recommendations = _generateRecommendations(
      sharedInterests: sharedInterests,
      category: detectedInterests.isNotEmpty ? detectedInterests.first.category : null,
      history: _recommendationHistory[key] ?? [],
    );
    
    // 6. 공감 포인트 생성
    final empathyPoints = _generateEmpathyPoints(
      detectedInterests: detectedInterests,
      sharedInterests: sharedInterests,
    );
    
    return {
      'detectedInterests': detectedInterests,
      'sharedInterests': sharedInterests,
      'recommendations': recommendations,
      'empathyPoints': empathyPoints,
      'hasCommonInterest': sharedInterests.isNotEmpty,
    };
  }
  
  /// 메시지에서 관심사 감지
  static List<Interest> _detectInterestsFromMessage(String message) {
    final interests = <Interest>[];
    final lower = message.toLowerCase();
    
    // 게임 관련
    if (_containsAny(lower, ['게임', '롤', '오버워치', '배그', '피파', '스팀', '플스', '닌텐도'])) {
      interests.add(Interest(
        category: InterestCategory.gaming,
        name: '게임',
        affinity: 0.8,
        subTopics: _extractGameTopics(lower),
      ));
    }
    
    // 영화/드라마 관련
    if (_containsAny(lower, ['영화', '드라마', '넷플릭스', '왓챠', '디즈니', '시리즈', '극장'])) {
      interests.add(Interest(
        category: InterestCategory.movies,
        name: '영화/드라마',
        affinity: 0.8,
        subTopics: _extractMovieTopics(lower),
      ));
    }
    
    // 음악 관련
    if (_containsAny(lower, ['음악', '노래', '가수', '아이돌', '밴드', '콘서트', '플레이리스트', '멜론', '스포티파이'])) {
      interests.add(Interest(
        category: InterestCategory.music,
        name: '음악',
        affinity: 0.8,
        subTopics: _extractMusicTopics(lower),
      ));
    }
    
    // 운동 관련
    if (_containsAny(lower, ['운동', '헬스', '요가', '필라테스', '러닝', '축구', '야구', '농구', '수영'])) {
      interests.add(Interest(
        category: InterestCategory.sports,
        name: '운동',
        affinity: 0.7,
        subTopics: _extractSportsTopics(lower),
      ));
    }
    
    // 음식 관련
    if (_containsAny(lower, ['맛집', '음식', '요리', '레시피', '카페', '디저트', '커피', '술'])) {
      interests.add(Interest(
        category: InterestCategory.food,
        name: '음식',
        affinity: 0.7,
        subTopics: _extractFoodTopics(lower),
      ));
    }
    
    // 여행 관련
    if (_containsAny(lower, ['여행', '해외', '국내', '여행지', '호텔', '비행기', '휴가'])) {
      interests.add(Interest(
        category: InterestCategory.travel,
        name: '여행',
        affinity: 0.8,
        subTopics: _extractTravelTopics(lower),
      ));
    }
    
    return interests;
  }
  
  /// 사용자 관심사 업데이트
  static void _updateUserInterests(String userId, List<Interest> newInterests) {
    final existingInterests = _userInterests[userId] ?? [];
    
    for (final newInterest in newInterests) {
      // 기존 관심사 확인
      final existingIndex = existingInterests.indexWhere(
        (i) => i.category == newInterest.category
      );
      
      if (existingIndex >= 0) {
        // 관심도 증가
        final existing = existingInterests[existingIndex];
        existingInterests[existingIndex] = Interest(
          category: existing.category,
          name: existing.name,
          affinity: (existing.affinity + 0.1).clamp(0.0, 1.0),
          subTopics: {...existing.subTopics, ...newInterest.subTopics}.toList(),
        );
      } else {
        // 새 관심사 추가
        existingInterests.add(newInterest);
      }
    }
    
    _userInterests[userId] = existingInterests;
  }
  
  /// 페르소나 관심사 가져오기
  static List<Interest> _getPersonaInterests(String personaId, String mbti) {
    // 캐시 확인
    if (_personaInterests.containsKey(personaId)) {
      return _personaInterests[personaId]!;
    }
    
    // MBTI 기반 기본 관심사 생성
    final interests = <Interest>[];
    
    // E(외향) vs I(내향)
    if (mbti.startsWith('E')) {
      interests.add(Interest(
        category: InterestCategory.sports,
        name: '야외 활동',
        affinity: 0.7,
        subTopics: ['등산', '캠핑', '자전거'],
      ));
    } else {
      interests.add(Interest(
        category: InterestCategory.books,
        name: '독서',
        affinity: 0.7,
        subTopics: ['소설', '에세이', '자기계발서'],
      ));
    }
    
    // N(직관) vs S(감각)
    if (mbti.contains('N')) {
      interests.add(Interest(
        category: InterestCategory.movies,
        name: 'SF/판타지',
        affinity: 0.8,
        subTopics: ['마블', 'DC', '넷플릭스 시리즈'],
      ));
    } else {
      interests.add(Interest(
        category: InterestCategory.food,
        name: '맛집 탐방',
        affinity: 0.8,
        subTopics: ['카페', '브런치', '디저트'],
      ));
    }
    
    // F(감정) vs T(사고)
    if (mbti.contains('F')) {
      interests.add(Interest(
        category: InterestCategory.music,
        name: '감성 음악',
        affinity: 0.7,
        subTopics: ['발라드', '인디', '어쿠스틱'],
      ));
    } else {
      interests.add(Interest(
        category: InterestCategory.tech,
        name: '최신 기술',
        affinity: 0.7,
        subTopics: ['가젯', 'AI', '스마트홈'],
      ));
    }
    
    // 공통 관심사 추가
    interests.addAll([
      Interest(
        category: InterestCategory.gaming,
        name: '캐주얼 게임',
        affinity: 0.6,
        subTopics: ['모바일 게임', '닌텐도', '인디게임'],
      ),
      Interest(
        category: InterestCategory.pets,
        name: '반려동물',
        affinity: 0.5,
        subTopics: ['강아지', '고양이', '반려동물 카페'],
      ),
    ]);
    
    _personaInterests[personaId] = interests;
    return interests;
  }
  
  /// 공통 관심사 찾기
  static List<SharedInterest> _findSharedInterests({
    required List<Interest> userInterests,
    required List<Interest> personaInterests,
  }) {
    final sharedInterests = <SharedInterest>[];
    
    for (final userInterest in userInterests) {
      for (final personaInterest in personaInterests) {
        if (userInterest.category == personaInterest.category) {
          // 공통 서브토픽 찾기
          final commonTopics = userInterest.subTopics
              .where((t) => personaInterest.subTopics.contains(t))
              .toList();
          
          // 매치 점수 계산
          final matchScore = (userInterest.affinity + personaInterest.affinity) / 2 * 
              (commonTopics.isNotEmpty ? 1.2 : 1.0);
          
          sharedInterests.add(SharedInterest(
            userInterest: userInterest,
            personaInterest: personaInterest,
            matchScore: matchScore.clamp(0.0, 1.0),
            commonTopics: commonTopics,
            recommendations: _getRecommendationsForCategory(userInterest.category),
          ));
        }
      }
    }
    
    // 매치 점수로 정렬
    sharedInterests.sort((a, b) => b.matchScore.compareTo(a.matchScore));
    
    return sharedInterests;
  }
  
  /// 추천 생성
  static List<String> _generateRecommendations({
    required List<SharedInterest> sharedInterests,
    required InterestCategory? category,
    required List<String> history,
  }) {
    final recommendations = <String>[];
    
    if (category != null) {
      recommendations.addAll(_getRecommendationsForCategory(category));
    }
    
    for (final shared in sharedInterests.take(2)) {
      recommendations.addAll(shared.recommendations);
    }
    
    // 중복 제거 및 히스토리 필터링
    return recommendations
        .where((r) => !history.contains(r))
        .toSet()
        .take(5)
        .toList();
  }
  
  /// 공감 포인트 생성
  static List<String> _generateEmpathyPoints({
    required List<Interest> detectedInterests,
    required List<SharedInterest> sharedInterests,
  }) {
    final points = <String>[];
    
    // 감지된 관심사에 대한 공감
    for (final interest in detectedInterests) {
      points.addAll(_getEmpathyForCategory(interest.category));
    }
    
    // 공통 관심사에 대한 공감
    for (final shared in sharedInterests.take(2)) {
      if (shared.matchScore > 0.7) {
        points.add('나도 ${shared.userInterest.name} 진짜 좋아해!');
      }
      
      if (shared.commonTopics.isNotEmpty) {
        points.add('${shared.commonTopics.first} 완전 재밌지 않아?');
      }
    }
    
    return points;
  }
  
  /// 카테고리별 추천
  static List<String> _getRecommendationsForCategory(InterestCategory category) {
    switch (category) {
      case InterestCategory.gaming:
        return [
          '최근에 스팀 세일하던데 뭐 살까 고민중이야',
          '요즘 뭐하고 놀아? 같이 할 게임 추천해줘!',
          '이번에 나온 신작 해봤어?',
        ];
      case InterestCategory.movies:
        return [
          '요즘 볼만한 거 있어? 추천 좀!',
          '넷플릭스에 신작 올라왔던데 봤어?',
          '주말에 영화 보러 갈까 생각중인데 뭐가 재밌을까?',
        ];
      case InterestCategory.music:
        return [
          '요즘 뭐 들어? 플레이리스트 공유해줘!',
          '이번에 컴백한 가수 노래 들어봤어?',
          '운동할 때 듣기 좋은 노래 추천해줘~',
        ];
      case InterestCategory.food:
        return [
          '오늘 뭐 먹었어? 나도 그거 먹고 싶다',
          '요즘 핫한 맛집 알아? 가보고 싶어',
          '디저트 먹고 싶은데 추천해줘!',
        ];
      default:
        return [];
    }
  }
  
  /// 카테고리별 공감 표현
  static List<String> _getEmpathyForCategory(InterestCategory category) {
    switch (category) {
      case InterestCategory.gaming:
        return [
          '오 게임 얘기! 나도 게임 좋아해~',
          '게임 하면 시간 가는 줄 모르지 ㅋㅋ',
          '요즘 게임 너무 재밌는 거 많아',
        ];
      case InterestCategory.movies:
        return [
          '영화 진짜 좋아해! 뭐 봤어?',
          '나도 영화 보는 거 좋아해~',
          '극장 가는 거 너무 좋아',
        ];
      case InterestCategory.music:
        return [
          '음악 없으면 못 살아 진짜',
          '나도 그 노래 좋아해!',
          '음악 듣는 거 최고야',
        ];
      case InterestCategory.sports:
        return [
          '운동하는 거 멋있어!',
          '나도 운동해야 하는데...',
          '운동하면 기분 좋아지지',
        ];
      default:
        return ['오 그거 재밌겠다!', '나도 관심 있어!'];
    }
  }
  
  // 유틸리티 함수들
  static bool _containsAny(String text, List<String> keywords) {
    return keywords.any((k) => text.contains(k));
  }
  
  static List<String> _extractGameTopics(String text) {
    final topics = <String>[];
    if (text.contains('롤')) topics.add('리그오브레전드');
    if (text.contains('오버워치')) topics.add('오버워치');
    if (text.contains('배그')) topics.add('배틀그라운드');
    if (text.contains('피파')) topics.add('피파');
    if (text.contains('닌텐도')) topics.add('닌텐도');
    return topics;
  }
  
  static List<String> _extractMovieTopics(String text) {
    final topics = <String>[];
    if (text.contains('넷플릭스')) topics.add('넷플릭스');
    if (text.contains('마블')) topics.add('마블');
    if (text.contains('디즈니')) topics.add('디즈니');
    if (text.contains('드라마')) topics.add('드라마');
    return topics;
  }
  
  static List<String> _extractMusicTopics(String text) {
    final topics = <String>[];
    if (text.contains('아이돌')) topics.add('K-POP');
    if (text.contains('발라드')) topics.add('발라드');
    if (text.contains('힙합')) topics.add('힙합');
    if (text.contains('인디')) topics.add('인디');
    return topics;
  }
  
  static List<String> _extractSportsTopics(String text) {
    final topics = <String>[];
    if (text.contains('헬스')) topics.add('헬스');
    if (text.contains('요가')) topics.add('요가');
    if (text.contains('축구')) topics.add('축구');
    if (text.contains('러닝')) topics.add('러닝');
    return topics;
  }
  
  static List<String> _extractFoodTopics(String text) {
    final topics = <String>[];
    if (text.contains('카페')) topics.add('카페');
    if (text.contains('디저트')) topics.add('디저트');
    if (text.contains('맛집')) topics.add('맛집');
    if (text.contains('요리')) topics.add('요리');
    return topics;
  }
  
  static List<String> _extractTravelTopics(String text) {
    final topics = <String>[];
    if (text.contains('해외')) topics.add('해외여행');
    if (text.contains('국내')) topics.add('국내여행');
    if (text.contains('제주')) topics.add('제주도');
    if (text.contains('일본')) topics.add('일본');
    return topics;
  }
  
  /// AI 프롬프트용 관심사 가이드 생성
  static String generateInterestGuide(Map<String, dynamic> analysis) {
    final buffer = StringBuffer();
    
    buffer.writeln('🎮 관심사 공유 가이드:');
    
    // 감지된 관심사
    final detected = analysis['detectedInterests'] as List<Interest>;
    if (detected.isNotEmpty) {
      buffer.writeln('\n감지된 관심사:');
      for (final interest in detected) {
        buffer.writeln('- ${interest.name}: ${interest.subTopics.join(', ')}');
      }
    }
    
    // 공통 관심사
    final shared = analysis['sharedInterests'] as List<SharedInterest>;
    if (shared.isNotEmpty) {
      buffer.writeln('\n🎯 공통 관심사 발견!');
      final topShared = shared.first;
      buffer.writeln('- ${topShared.userInterest.name} (매치도: ${(topShared.matchScore * 100).toInt()}%)');
      if (topShared.commonTopics.isNotEmpty) {
        buffer.writeln('  공통 주제: ${topShared.commonTopics.join(', ')}');
      }
    }
    
    // 공감 포인트
    final empathy = analysis['empathyPoints'] as List<String>;
    if (empathy.isNotEmpty) {
      buffer.writeln('\n공감 표현 예시:');
      for (final point in empathy.take(2)) {
        buffer.writeln('- $point');
      }
    }
    
    // 추천
    final recommendations = analysis['recommendations'] as List<String>;
    if (recommendations.isNotEmpty) {
      buffer.writeln('\n대화 이어가기:');
      buffer.writeln('- ${recommendations.first}');
    }
    
    return buffer.toString();
  }
}