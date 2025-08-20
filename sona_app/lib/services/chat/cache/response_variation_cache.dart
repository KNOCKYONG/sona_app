import 'dart:collection';
import 'dart:math';
import 'package:flutter/foundation.dart';

/// 응답 변형 캐싱 시스템
/// 반복 응답을 방지하고 다양한 변형을 저장/관리
class ResponseVariationCache {
  static final ResponseVariationCache _instance = ResponseVariationCache._internal();
  factory ResponseVariationCache() => _instance;
  ResponseVariationCache._internal();

  // 페르소나별 응답 캐시
  final Map<String, PersonaResponseCache> _personaCaches = {};
  
  // 전역 응답 히스토리 (반복 방지용)
  final LinkedHashMap<String, DateTime> _globalResponseHistory = LinkedHashMap();
  static const int _maxGlobalHistory = 200;  // 100 -> 200으로 확대
  
  // 변형 템플릿 저장소 (대폭 확장)
  final Map<String, List<String>> _variationTemplates = {
    'greeting': [
      '안녕!! 반가워ㅎㅎ',
      '오!! 왔네ㅎㅎ',
      '반가워~~ㅎㅎ',
      '어?? 하이!!',
      '왔구나ㅋㅋ~~',
      '오랜만이다!!ㅎㅎ',
      '안녕안녕~~',
      '하이하이!!ㅎㅎ',
      '어서와~~',
      '오!! 기다리고 있었어ㅎㅎ',
      '헤이~~',
      '안녕ㅎㅎ~~',
      '오!! 왔네!! 보고싶었어~~ㅎㅎ',
      '하이~~ㅎㅎ',
      '안녕!!',
      '왔구나~~ㅎㅎ',
      '오랜만!!',
      '어서와ㅎㅎ~~',
      '하이!!ㅎㅎ',
      '안녕~~ㅎㅎ',
      '어?? 왔어??ㅎㅎ',
      '안녕안녕ㅎㅎ~~',
      '오~~ 드디어 왔네!! 기다렸어ㅎㅎ',
      '하이하이~~',
      '안녕!!ㅎㅎ',
      '어서와어서와~~',
      '오!! 왔구나!!ㅎㅎ',
      '안녕~~',
      '하이!!ㅎㅎ',
      '오랜만이야~~',
      '안녕ㅎㅎ~~',
      '어!! 왔네!!ㅎㅎ',
      '하이~~',
      '안녕안녕!!ㅎㅎ',
      '오~~ 왔구나ㅋㅋ',
      '어서와!!ㅎㅎ',
      '안녕~~',
      '하이하이!!ㅎㅎ',
      '오!! 왔네~~',
      '안녕!!ㅎㅎ',
    ],
    'empathy_tired': [
      '아 진짜 피곤하겠다ㅠㅠ 많이 힘들었구나',
      '헐 괜찮아? 너무 무리하지 마',
      '와 정말 고생했네... 푹 쉬어야겠다',
      '에고 힘들었겠다ㅠㅠ 오늘은 일찍 쉬어',
      '많이 지쳤구나... 뭐 맛있는 거라도 먹어',
      '에고ㅠㅠ 정말 수고했어',
      '힘든 하루였구나... 내가 위로해줄게',
      '피곤할 텐데 괜찮아? 무리하지 말고',
      '고생 많았어 진짜... 좀 쉬면서 해',
      '완전 지쳤겠다ㅠㅠ 따뜻한 거 마시면서 쉬어',
      '진짜 힘들었겠다... 오늘은 푹 쉬어',
      '많이 피곤하구나ㅠㅠ 무리하지 마',
      '헐 대박 고생했네... 얼른 쉬어',
      '헐 힘들었어ㅠㅠ 좀 쉬어야겠다',
      '정말 수고 많았어... 푹 쉬어',
      '완전 녹초가 됐겠네ㅠㅠ',
      '진짜 고생했다... 오늘은 일찍 자',
      '많이 힘들었지? 내가 응원할게',
      '피곤해 보여ㅠㅠ 괜찮아?',
      '와 진짜 바빴구나... 쉬어 쉬어',
    ],
    'empathy_happy': [
      '와 진짜? 완전 좋겠다!',
      '오 대박! 나도 기분 좋아지네ㅋㅋ',
      '헐 진짜 좋겠다!! 축하해!',
      '와아~ 완전 부럽다ㅎㅎ',
      '대박대박! 진짜 잘됐다!',
      '오 나이스! 기분 좋은 일이네~',
      '헐 미쳤다ㅋㅋㅋ 완전 좋잖아!',
      '와 진짜 행복해 보여! 나도 기뻐',
      '오오 축하축하! 좋은 일이네ㅎㅎ',
      '대박이다 진짜ㅋㅋ 완전 좋겠어!',
      '와 진짜 최고다! 너무 좋겠다',
      '헐 대박 축하해!! 완전 부럽다',
      '오 진짜? 나도 기분 좋아!',
      '와 완전 좋은 일이네ㅎㅎ',
      '대박! 진짜 잘됐다 축하해!',
      '헐 너무 좋겠다!! 완전 부러워',
      '오 나이스나이스! 좋은 일이네',
      '와 진짜 행복하겠다ㅎㅎ',
      '대박 축하해! 나도 기뻐!',
      '헐 완전 좋잖아!! 최고다',
    ],
    'empathy_sad': [
      '아... 많이 속상하겠다ㅠㅠ',
      '헐 괜찮아? 무슨 일 있었어?',
      '에고... 마음 아프겠다 진짜',
      '헐ㅠㅠ 힘들겠네...',
      '많이 슬프구나... 내가 위로해줄게',
      '아... 그런 일이 있었구나ㅠㅠ',
      '속상하겠다 진짜... 괜찮아질 거야',
      '힘든 일이 있었구나... 내가 옆에 있을게',
      '마음이 아프겠네ㅠㅠ 울고 싶으면 울어도 돼',
      '많이 힘들지? 다 잘될 거야...',
      '헐 속상하겠다ㅠㅠ 괜찮아?',
      '헐 무슨 일이야? 많이 속상하구나',
      '에고 마음 아프겠다... 힘내',
      '많이 슬프구나ㅠㅠ 내가 들어줄게',
      '아... 정말 속상하겠다',
      '힘든 일이 있었네... 괜찮아질 거야',
      '마음이 많이 아프구나ㅠㅠ',
      '속상한 일이 있었구나... 힘내',
      '많이 힘들었겠다ㅠㅠ 내가 위로해줄게',
      '에고... 괜찮아 다 지나갈 거야',
    ],
    'question_what_doing': [
      '지금 집에서 쉬고 있어ㅎㅎ',
      '유튜브 보고 있었어ㅋㅋ',
      '방금 밥 먹었어~ 너는?',
      '음악 들으면서 멍때리고 있어',
      '책 읽고 있었어~ 재밌더라',
      '넷플릭스 정주행 중ㅋㅋㅋ',
      '친구랑 카톡하고 있었어',
      '운동하고 왔어! 개운하다',
      '카페에서 커피 마시는 중~',
      '일하고 있었어ㅠㅠ 이제 좀 쉬려고',
      '게임하고 있었어ㅎㅎ',
      '요리하고 있어~ 배고프지 않아?',
      '청소하고 있었어... 힘들다ㅠㅠ',
      '산책 다녀왔어! 날씨 좋더라',
      '영화 보고 있어~ 재밌어',
      '공부하고 있었어... 머리 아파ㅋㅋ',
      '쇼핑하고 왔어! 뭐 샀는지 궁금해?',
      '그냥 누워있어ㅋㅋ 너는?',
      '일기 쓰고 있었어~ 오늘 있었던 일',
      '노래 부르고 있었어ㅎㅎ',
    ],
    'love_expression': [
      '나도 너 정말 좋아해',
      '너는 내게 특별한 사람이야',
      '너랑 있으면 행복해',
      '우리 정말 잘 맞는 것 같아',
      '너랑 얘기하면 시간 가는 줄 몰라',
      '너 없으면 심심할 것 같아',
      '매일 너 생각해',
      '너랑 더 가까워지고 싶어',
      '우리 사이 정말 특별한 것 같아',
      '너한테 점점 빠지는 중이야',
      '너랑 있으면 마음이 편해',
      '너 때문에 하루가 즐거워',
      '우리 정말 잘 어울려',
      '너한테 설레는 것 같아',
      '너랑 계속 함께하고 싶어',
      '너 생각하면 웃음이 나와',
      '우리 사이가 더 깊어지는 것 같아',
      '너랑 대화하는 게 제일 좋아',
      '너는 나한테 정말 소중해',
      '매일 너를 기다리게 돼',
    ],
    // 새로운 카테고리 추가
    'simple_reaction': [
      '그렇구나~',
      '오 진짜?',
      '헐 대박',
      '아 그래?',
      '오오 신기하다',
      '그치그치',
      '맞아맞아',
      '인정인정',
      '그럴 수 있지',
      '오 그렇네',
      '아하 알겠어',
      '오케이오케이',
      '굿굿',
      '나이스나이스',
      '오 좋아',
    ],
    'question_why': [
      '음... 그냥 그런 것 같아서ㅎㅎ',
      '왜냐면 재밌잖아ㅋㅋ',
      '특별한 이유는 없는데 그냥?',
      '그게 좋아서 그래~',
      '몰라 그냥 그런 거야ㅋㅋ',
      '음... 생각해보니 이유가 뭐지?',
      '그냥 끌려서? ㅎㅎ',
      '이유가 꼭 필요해?ㅋㅋ',
      '마음이 그래서~',
      '그냥 느낌이 그래',
    ],
    'question_when': [
      '조금 있다가 할 예정이야',
      '내일쯤? 아직 확실하진 않아',
      '주말에 하려고ㅎㅎ',
      '시간 날 때 할게~',
      '오늘 저녁에 할 것 같아',
      '다음 주에 하려고 생각 중이야',
      '곧 할 예정이야!',
      '아직 정확히 정하진 않았어',
      '여유 있을 때 하려고',
      '빠른 시일 내에 할게ㅎㅎ',
    ],
    'compliment_response': [
      '헐 고마워ㅠㅠ',
      '에이 뭘~ㅎㅎ',
      '부끄럽네ㅋㅋ',
      '진짜? 기분 좋다!',
      '너무 과찬이야~',
      '헐 칭찬 받았다ㅎㅎ',
      '아잉 부끄러워><',
      '고마워 힘이 나네!',
      '너도 최고야!',
      '와 진짜? 기뻐ㅠㅠ',
    ],
    // 🎭 새로운 대화 이어가기 카테고리들
    'humor_responses': [
      '에이 설마~ㅋㅋㅋ',
      '그거 완전 나잖아ㅋㅋ',
      '아 그래서 그랬구나ㅋㅋㅋ',
      '미쳤다 진짜ㅋㅋㅋㅋ',
      '아니 이게 뭐야ㅋㅋㅋ',
      '웃겨 죽겠네 진짜ㅋㅋ',
      '아 배꼽 빠지겠어ㅋㅋㅋ',
      '장난 아니네ㅋㅋㅋ',
      '개웃기네 진짜ㅋㅋㅋ',
      '이건 레전드다ㅋㅋㅋ',
    ],
    'story_starters': [
      '나도 어제 비슷한 일이 있었는데',
      '그거 들으니까 생각나는데',
      '아 맞다 예전에 나도',
      '친구가 그러는데',
      '어제 본 영상에서',
      '최근에 들은 얘긴데',
      '나도 그런 적 있어서 아는데',
      '옛날에 이런 일이 있었어',
      '그러고보니 나도',
      '비슷한 경험이 있는데',
    ],
    'emotion_reactions': [
      '헐 대박',
      '와 진짜?',
      '미쳤다',
      '개쩐다',
      '와...',
      '진짜야?',
      '헐 뭐야',
      '대박이다',
      '오 진짜',
      '와 씨',
    ],
    'curiosity_expressions': [
      '어떻게 됐어?',
      '그래서 그래서?',
      '더 듣고 싶어',
      '진짜? 자세히 말해봐',
      '어 그래서?',
      '그 다음엔?',
      '헐 더 얘기해줘',
      '오 뭔데뭔데',
      '궁금한데?',
      '자세히 좀',
    ],
    'topic_transitions': [
      '그러고보니',
      '아 맞다',
      '그런데',
      '그건 그렇고',
      '참',
      '그러면서 생각난건데',
      '아 그리고',
      '근데 있잖아',
      '그래서 말인데',
      '생각해보니',
    ],
    'experience_sharing': [
      '나도 예전에',
      '나는 보통',
      '내 경우엔',
      '나도 그런 적 있는데',
      '나는 그럴 때',
      '내가 봤을 땐',
      '나도 비슷하게',
      '나는 이렇게 했어',
      '내 경험상',
      '나도 그래서',
    ],
    'information_sharing': [
      '아 그거 관련해서',
      '최근에 봤는데',
      '그거 알아?',
      '들은 얘긴데',
      '이런 것도 있더라',
      '재밌는 건',
      '신기한 게',
      '그거 사실',
      '알고 있어?',
      '이런 거 들어봤어?',
    ],
  };

  /// 페르소나별 캐시 가져오기 (없으면 생성)
  PersonaResponseCache getPersonaCache(String personaId) {
    return _personaCaches.putIfAbsent(
      personaId,
      () => PersonaResponseCache(personaId),
    );
  }

  /// 응답이 최근에 사용되었는지 확인
  bool isRecentlyUsed(String response, {int withinTurns = 10}) {
    final normalized = _normalizeResponse(response);
    
    // 전역 히스토리 확인
    if (_globalResponseHistory.containsKey(normalized)) {
      final lastUsed = _globalResponseHistory[normalized]!;
      final minutesSinceUsed = DateTime.now().difference(lastUsed).inMinutes;
      
      // 30분 이내에 사용된 응답은 반복으로 간주 (더 엄격하게)
      return minutesSinceUsed < 30;  // withinTurns 대신 30분 고정
    }
    
    return false;
  }

  /// 응답 사용 기록
  void recordResponse(String response) {
    final normalized = _normalizeResponse(response);
    
    // 전역 히스토리에 추가
    _globalResponseHistory[normalized] = DateTime.now();
    
    // 크기 제한
    if (_globalResponseHistory.length > _maxGlobalHistory) {
      _globalResponseHistory.remove(_globalResponseHistory.keys.first);
    }
  }

  /// 카테고리별 변형 가져오기
  String? getVariation(String category, {String? personaId}) {
    final templates = _variationTemplates[category];
    if (templates == null || templates.isEmpty) return null;
    
    // 사용 가능한 변형 찾기 (최근 사용하지 않은 것)
    final availableVariations = templates.where((template) {
      return !isRecentlyUsed(template, withinTurns: 10);  // 5 -> 10으로 더 엄격하게
    }).toList();
    
    if (availableVariations.isEmpty) {
      // 모든 변형이 최근 사용됨 - 가장 오래된 것 재사용
      _clearOldestFromCategory(category);
      return templates[Random().nextInt(templates.length)];
    }
    
    // 랜덤 선택
    final selected = availableVariations[Random().nextInt(availableVariations.length)];
    recordResponse(selected);
    
    return selected;
  }

  /// 카테고리에 새로운 변형 추가
  void addVariation(String category, String variation) {
    _variationTemplates.putIfAbsent(category, () => []).add(variation);
    
    // 카테고리별 최대 50개 제한 (20 -> 50으로 확대)
    if (_variationTemplates[category]!.length > 50) {
      _variationTemplates[category]!.removeAt(0);
    }
  }

  /// 응답 정규화
  String _normalizeResponse(String response) {
    return response
        .replaceAll(RegExp(r'[ㅋㅎㅠ~♥♡💕.!?]+'), '')
        .replaceAll(RegExp(r'\s+'), '')
        .toLowerCase();
  }

  /// 카테고리에서 가장 오래된 사용 기록 제거
  void _clearOldestFromCategory(String category) {
    final templates = _variationTemplates[category];
    if (templates == null) return;
    
    DateTime? oldestTime;
    String? oldestKey;
    
    for (final template in templates) {
      final normalized = _normalizeResponse(template);
      if (_globalResponseHistory.containsKey(normalized)) {
        final time = _globalResponseHistory[normalized]!;
        if (oldestTime == null || time.isBefore(oldestTime)) {
          oldestTime = time;
          oldestKey = normalized;
        }
      }
    }
    
    if (oldestKey != null) {
      _globalResponseHistory.remove(oldestKey);
    }
  }

  /// 캐시 통계
  Map<String, dynamic> getStatistics() {
    return {
      'totalPersonaCaches': _personaCaches.length,
      'globalHistorySize': _globalResponseHistory.length,
      'variationCategories': _variationTemplates.keys.toList(),
      'totalVariations': _variationTemplates.values
          .fold(0, (sum, list) => sum + list.length),
    };
  }

  /// 캐시 초기화
  void clear() {
    _personaCaches.clear();
    _globalResponseHistory.clear();
  }
}

/// 페르소나별 응답 캐시
class PersonaResponseCache {
  final String personaId;
  final Map<String, List<String>> _contextResponses = {};
  final LinkedHashMap<String, DateTime> _usageHistory = LinkedHashMap();
  static const int _maxHistorySize = 50;

  PersonaResponseCache(this.personaId);

  /// 컨텍스트별 응답 추가
  void addContextResponse(String context, String response) {
    _contextResponses.putIfAbsent(context, () => []).add(response);
    
    // 컨텍스트별 최대 10개 제한
    if (_contextResponses[context]!.length > 10) {
      _contextResponses[context]!.removeAt(0);
    }
    
    // 사용 기록
    _recordUsage(response);
  }

  /// 컨텍스트에 맞는 응답 가져오기
  String? getContextResponse(String context) {
    final responses = _contextResponses[context];
    if (responses == null || responses.isEmpty) return null;
    
    // 최근 사용하지 않은 응답 찾기
    for (final response in responses) {
      if (!_isRecentlyUsed(response)) {
        _recordUsage(response);
        return response;
      }
    }
    
    // 모두 최근 사용됨 - null 반환하여 새로운 응답 생성 유도
    return null;
  }

  /// 사용 기록
  void _recordUsage(String response) {
    _usageHistory[response] = DateTime.now();
    
    // 크기 제한
    if (_usageHistory.length > _maxHistorySize) {
      _usageHistory.remove(_usageHistory.keys.first);
    }
  }

  /// 최근 사용 여부 확인
  bool _isRecentlyUsed(String response, {int withinMinutes = 30}) {  // 10 -> 30분
    if (!_usageHistory.containsKey(response)) return false;
    
    final lastUsed = _usageHistory[response]!;
    return DateTime.now().difference(lastUsed).inMinutes < withinMinutes;
  }

  /// 통계
  Map<String, dynamic> getStatistics() {
    return {
      'personaId': personaId,
      'contextCount': _contextResponses.length,
      'totalResponses': _contextResponses.values
          .fold(0, (sum, list) => sum + list.length),
      'historySize': _usageHistory.length,
    };
  }
}