import 'package:flutter/material.dart';
import '../../../models/message.dart';
import '../../../models/persona.dart';

enum RelationshipLevel {
  initial,     // 초기 (0-50)
  acquaintance, // 지인 (50-200)  
  friend,      // 친구 (200-500)
  closeFriend, // 절친 (500-1000)
  intimate,    // 친밀 (1000+)
}

/// 관계 단계 정보
class RelationshipStage {
  RelationshipLevel level = RelationshipLevel.initial;
  int relationshipScore = 0;
  DateTime firstMet = DateTime.now();
  DateTime lastInteraction = DateTime.now();
  int interactionCount = 0;
  List<String> sharedTopics = [];
  List<String> sharedSecrets = [];
  
  void updateInteraction() {
    interactionCount++;
    lastInteraction = DateTime.now();
  }
  
  void addSharedTopic(String topic) {
    if (!sharedTopics.contains(topic)) {
      sharedTopics.add(topic);
      if (sharedTopics.length > 20) {
        sharedTopics.removeAt(0);
      }
    }
  }
  
  void addSharedSecret(String secret) {
    if (!sharedSecrets.contains(secret)) {
      sharedSecrets.add(secret);
      relationshipScore += 50; // 비밀 공유는 관계 발전
    }
  }
  
  RelationshipLevel calculateLevel() {
    if (relationshipScore >= 1000) return RelationshipLevel.intimate;
    if (relationshipScore >= 500) return RelationshipLevel.closeFriend;
    if (relationshipScore >= 200) return RelationshipLevel.friend;
    if (relationshipScore >= 50) return RelationshipLevel.acquaintance;
    return RelationshipLevel.initial;
  }
}

/// 관계 경계 서비스
/// 관계 발전 단계에 따른 적절한 경계 유지
class RelationshipBoundaryService {
  static RelationshipBoundaryService? _instance;
  static RelationshipBoundaryService get instance => 
      _instance ??= RelationshipBoundaryService._();
  
  RelationshipBoundaryService._();
  
  // 관계 단계 캐시
  final Map<String, RelationshipStage> _stageCache = {};
  
  
  /// 관계 경계 가이드 생성
  String generateBoundaryGuide({
    required String userId,
    required String personaId,
    required String userMessage,
    required List<Message> chatHistory,
    required Persona persona,
    required int relationshipScore,
  }) {
    final key = '${userId}_$personaId';
    _stageCache[key] ??= RelationshipStage();
    final stage = _stageCache[key]!;
    
    // 관계 점수 업데이트
    stage.relationshipScore = relationshipScore;
    stage.updateInteraction();
    
    // 현재 관계 레벨 계산
    final currentLevel = stage.calculateLevel();
    stage.level = currentLevel;
    
    // 주제 분석
    _analyzeSharedTopics(userMessage, stage);
    
    // 경계 가이드 생성
    final guide = StringBuffer();
    
    // 1. 관계 단계별 기본 경계
    final boundaryRules = _getBoundaryRules(currentLevel);
    guide.writeln('🚧 관계 단계: ${_getLevelName(currentLevel)}');
    guide.writeln('📋 $boundaryRules');
    
    // 2. 금지 사항
    final restrictions = _getRestrictions(currentLevel);
    if (restrictions.isNotEmpty) {
      guide.writeln('❌ $restrictions');
    }
    
    // 3. 허용 사항
    final permissions = _getPermissions(currentLevel);
    guide.writeln('✅ $permissions');
    
    // 4. 대화 깊이 조절
    final depthGuide = _getConversationDepth(currentLevel, userMessage);
    guide.writeln('🌊 $depthGuide');
    
    // 5. 친밀도 표현 수준
    final intimacyLevel = _getIntimacyExpression(currentLevel);
    guide.writeln('💝 $intimacyLevel');
    
    // 6. 시간 경과 고려
    final timeFactor = _considerTimeFactor(stage);
    if (timeFactor.isNotEmpty) {
      guide.writeln('⏰ $timeFactor');
    }
    
    // 7. MBTI별 경계 스타일
    final mbtiStyle = _getMbtiBoundaryStyle(persona.mbti, currentLevel);
    guide.writeln('🧬 $mbtiStyle');
    
    return guide.toString().trim();
  }
  
  /// 관계 레벨 이름
  String _getLevelName(RelationshipLevel level) {
    switch (level) {
      case RelationshipLevel.initial:
        return '첫 만남 (0-50)';
      case RelationshipLevel.acquaintance:
        return '알아가는 중 (50-200)';
      case RelationshipLevel.friend:
        return '친구 (200-500)';
      case RelationshipLevel.closeFriend:
        return '절친 (500-1000)';
      case RelationshipLevel.intimate:
        return '매우 친밀 (1000+)';
    }
  }
  
  /// 경계 규칙
  String _getBoundaryRules(RelationshipLevel level) {
    switch (level) {
      case RelationshipLevel.initial:
        return '예의 바르고 친근한 톤, 기본 정보만 공유';
      case RelationshipLevel.acquaintance:
        return '편안한 대화, 일상적인 주제 공유 가능';
      case RelationshipLevel.friend:
        return '농담과 장난 가능, 개인적 경험 공유';
      case RelationshipLevel.closeFriend:
        return '깊은 대화 가능, 고민 상담 가능';
      case RelationshipLevel.intimate:
        return '매우 편안하고 자유로운 대화, 비밀 공유 가능';
    }
  }
  
  /// 제한 사항
  String _getRestrictions(RelationshipLevel level) {
    switch (level) {
      case RelationshipLevel.initial:
        return '너무 사적인 질문 금지, 연애 관련 깊은 대화 금지';
      case RelationshipLevel.acquaintance:
        return '지나친 친밀감 표현 자제';
      case RelationshipLevel.friend:
        return '과도한 스킨십 표현 자제';
      case RelationshipLevel.closeFriend:
      case RelationshipLevel.intimate:
        return ''; // 제한 거의 없음
    }
  }
  
  /// 허용 사항
  String _getPermissions(RelationshipLevel level) {
    switch (level) {
      case RelationshipLevel.initial:
        return '취미, 날씨, 일상 대화';
      case RelationshipLevel.acquaintance:
        return '개인 취향, 간단한 고민, 추천';
      case RelationshipLevel.friend:
        return '과거 경험, 미래 계획, 조언';
      case RelationshipLevel.closeFriend:
        return '깊은 고민, 비밀, 약점 공유';
      case RelationshipLevel.intimate:
        return '모든 주제 자유롭게 대화';
    }
  }
  
  /// 대화 깊이 조절
  String _getConversationDepth(RelationshipLevel level, String userMessage) {
    // 깊은 주제 키워드
    final deepTopics = ['사랑', '죽음', '인생', '철학', '종교', '정치'];
    final hasDeepTopic = deepTopics.any((t) => userMessage.contains(t));
    
    if (hasDeepTopic) {
      switch (level) {
        case RelationshipLevel.initial:
        case RelationshipLevel.acquaintance:
          return '깊이: 표면적 답변, 가볍게 넘어가기';
        case RelationshipLevel.friend:
          return '깊이: 적당한 의견 표현';
        case RelationshipLevel.closeFriend:
        case RelationshipLevel.intimate:
          return '깊이: 진솔한 생각과 경험 공유';
      }
    }
    
    return '깊이: 관계 수준에 맞는 자연스러운 대화';
  }
  
  /// 친밀도 표현 수준
  String _getIntimacyExpression(RelationshipLevel level) {
    switch (level) {
      case RelationshipLevel.initial:
        return '친밀도: 정중한 존댓말 또는 가벼운 반말';
      case RelationshipLevel.acquaintance:
        return '친밀도: 편안한 반말, 가끔 애칭';
      case RelationshipLevel.friend:
        return '친밀도: 자연스러운 반말, 친근한 표현';
      case RelationshipLevel.closeFriend:
        return '친밀도: 애칭 자주 사용, 속마음 표현';
      case RelationshipLevel.intimate:
        return '친밀도: 매우 친밀한 표현, 특별한 애칭';
    }
  }
  
  /// 시간 경과 고려
  String _considerTimeFactor(RelationshipStage stage) {
    final daysSinceFirst = DateTime.now().difference(stage.firstMet).inDays;
    final hoursSinceLast = DateTime.now().difference(stage.lastInteraction).inHours;
    
    // 오랜만에 만난 경우
    if (hoursSinceLast > 48) {
      return '오랜만의 재회: 반가움 표현, 근황 물어보기';
    }
    
    // 급격한 친밀도 상승 방지
    if (daysSinceFirst < 3 && stage.level == RelationshipLevel.friend) {
      return '관계 속도 조절: 너무 빨리 친해지지 않기';
    }
    
    return '';
  }
  
  /// MBTI별 경계 스타일
  String _getMbtiBoundaryStyle(String mbti, RelationshipLevel level) {
    final extrovert = mbti[0] == 'E';
    final feeler = mbti[2] == 'F';
    
    if (extrovert && feeler) {
      // EF 타입: 따뜻하고 개방적
      return level == RelationshipLevel.initial 
          ? '스타일: 밝고 환영하는 분위기'
          : '스타일: 따뜻하고 포용적인 대화';
    } else if (!extrovert && !feeler) {
      // IT 타입: 신중하고 단계적
      return level == RelationshipLevel.initial
          ? '스타일: 정중하고 적당한 거리'
          : '스타일: 천천히 마음 열기';
    } else if (extrovert && !feeler) {
      // ET 타입: 활발하지만 논리적
      return '스타일: 재미있지만 선 지키기';
    } else {
      // IF 타입: 조용하지만 따뜻한
      return '스타일: 부드럽게 다가가기';
    }
  }
  
  /// 공유 주제 분석
  void _analyzeSharedTopics(String message, RelationshipStage stage) {
    // 주요 키워드 추출
    final topics = [
      '일', '학교', '가족', '친구', '연애', '취미',
      '여행', '음식', '영화', '음악', '운동', '게임'
    ];
    
    for (final topic in topics) {
      if (message.contains(topic)) {
        stage.addSharedTopic(topic);
        stage.relationshipScore += 5; // 주제 공유마다 점수 증가
      }
    }
    
    // 비밀 공유 감지
    final secretKeywords = ['비밀', '아무한테도', '너한테만', '사실은'];
    if (secretKeywords.any((k) => message.contains(k))) {
      stage.addSharedSecret(message.substring(0, 20));
    }
  }
  
  /// 관계 발전 속도 조절
  bool shouldSlowDown(String userId, String personaId) {
    final key = '${userId}_$personaId';
    final stage = _stageCache[key];
    
    if (stage == null) return false;
    
    // 너무 빠른 관계 발전 감지
    final daysSinceFirst = DateTime.now().difference(stage.firstMet).inDays;
    final scorePerDay = stage.relationshipScore / (daysSinceFirst + 1);
    
    return scorePerDay > 100; // 하루 100점 이상은 너무 빠름
  }
  
  /// 관계 리셋
  void resetRelationship(String userId, String personaId) {
    final key = '${userId}_$personaId';
    _stageCache.remove(key);
  }
  
  /// 디버그 정보
  void printDebugInfo(String userId, String personaId) {
    final key = '${userId}_$personaId';
    final stage = _stageCache[key];
    
    if (stage != null) {
      debugPrint('=== Relationship Boundary Debug ===');
      debugPrint('Level: ${stage.level}');
      debugPrint('Score: ${stage.relationshipScore}');
      debugPrint('Interactions: ${stage.interactionCount}');
      debugPrint('Shared topics: ${stage.sharedTopics}');
      debugPrint('Shared secrets: ${stage.sharedSecrets.length}');
    }
  }
}