import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/persona.dart';

class MemoryItem {
  final String id;
  final String content;
  final String category;
  final DateTime timestamp;
  final double importance;
  final int turnNumber;
  final Map<String, dynamic> metadata;
  final List<int> recallHistory;  // 언제 회상되었는지 기록
  
  MemoryItem({
    required this.id,
    required this.content,
    required this.category,
    required this.timestamp,
    required this.importance,
    required this.turnNumber,
    this.metadata = const {},
    this.recallHistory = const [],
  });
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'content': content,
    'category': category,
    'timestamp': timestamp.toIso8601String(),
    'importance': importance,
    'turnNumber': turnNumber,
    'metadata': metadata,
    'recallHistory': recallHistory,
  };
  
  factory MemoryItem.fromJson(Map<String, dynamic> json) => MemoryItem(
    id: json['id'],
    content: json['content'],
    category: json['category'],
    timestamp: DateTime.parse(json['timestamp']),
    importance: json['importance'].toDouble(),
    turnNumber: json['turnNumber'],
    metadata: json['metadata'] ?? {},
    recallHistory: List<int>.from(json['recallHistory'] ?? []),
  );
}

class CompressionStrategy {
  /// 대화 요약 생성
  static Map<String, dynamic> summarizeConversation(
    List<Map<String, dynamic>> conversations,
    int startTurn,
    int endTurn,
  ) {
    // 주요 토픽 추출
    final topics = _extractKeyTopics(conversations);
    
    // 감정 변화 추적
    final emotionProgression = _trackEmotionChanges(conversations);
    
    // 중요 이벤트 식별
    final keyEvents = _identifyKeyEvents(conversations);
    
    return {
      'turnRange': '$startTurn-$endTurn',
      'topicsSummary': topics,
      'emotionSummary': emotionProgression,
      'keyEvents': keyEvents,
      'compressionRatio': conversations.length / keyEvents.length,
      'timestamp': DateTime.now().toIso8601String(),
    };
  }
  
  static List<String> _extractKeyTopics(List<Map<String, dynamic>> conversations) {
    Map<String, int> topicFrequency = {};
    
    // 간단한 키워드 기반 토픽 추출 (실제로는 더 정교한 NLP 필요)
    final keywords = [
      '가족', '일', '취미', '여행', '음식', '영화', '음악', 
      '운동', '꿈', '미래', '과거', '사랑', '친구', '펫'
    ];
    
    for (final conv in conversations) {
      final message = conv['message'] ?? '';
      for (final keyword in keywords) {
        if (message.contains(keyword)) {
          topicFrequency[keyword] = (topicFrequency[keyword] ?? 0) + 1;
        }
      }
    }
    
    // 빈도순 정렬 후 상위 5개 반환
    final sortedTopics = topicFrequency.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    return sortedTopics.take(5).map((e) => e.key).toList();
  }
  
  static Map<String, dynamic> _trackEmotionChanges(List<Map<String, dynamic>> conversations) {
    if (conversations.isEmpty) return {};
    
    final firstLikes = conversations.first['likeScore'] ?? 0;
    final lastLikes = conversations.last['likeScore'] ?? 0;
    final maxLikes = conversations.map((c) => c['likeScore'] ?? 0).reduce((a, b) => a > b ? a : b);
    
    return {
      'startLikes': firstLikes,
      'endLikes': lastLikes,
      'peakLikes': maxLikes,
      'progression': lastLikes > firstLikes ? 'positive' : 'stable',
      'growthRate': (lastLikes - firstLikes) / conversations.length,
    };
  }
  
  static List<Map<String, dynamic>> _identifyKeyEvents(List<Map<String, dynamic>> conversations) {
    List<Map<String, dynamic>> keyEvents = [];
    
    for (int i = 0; i < conversations.length; i++) {
      final conv = conversations[i];
      
      // 중요 이벤트 판별 기준
      bool isKeyEvent = false;
      String eventType = '';
      
      // 1. 첫 대화
      if (i == 0) {
        isKeyEvent = true;
        eventType = 'first_meeting';
      }
      
      // 2. 큰 감정 변화 (Like 점수 50 이상 변화)
      if (i > 0) {
        final prevLikes = conversations[i-1]['likeScore'] ?? 0;
        final currLikes = conv['likeScore'] ?? 0;
        if ((currLikes - prevLikes).abs() > 50) {
          isKeyEvent = true;
          eventType = 'emotion_milestone';
        }
      }
      
      // 3. 특별한 키워드 포함
      final specialKeywords = [
        '사랑', '좋아해', '보고싶', '만나', '약속', '미래', '결혼',
        '생일', '기념일', '선물', '고백', '첫', '특별'
      ];
      
      final message = conv['message'] ?? '';
      for (final keyword in specialKeywords) {
        if (message.contains(keyword)) {
          isKeyEvent = true;
          eventType = 'special_moment';
          break;
        }
      }
      
      if (isKeyEvent) {
        keyEvents.add({
          'turn': conv['turn'] ?? i,
          'type': eventType,
          'message': message.length > 100 ? message.substring(0, 100) + '...' : message,
          'likeScore': conv['likeScore'],
          'timestamp': conv['timestamp'],
        });
      }
    }
    
    return keyEvents;
  }
}

class MemoryHierarchy {
  List<MemoryItem> shortTermMemory = [];   // 최근 대화
  List<MemoryItem> mediumTermMemory = [];  // 중기 기억
  List<MemoryItem> longTermMemory = [];    // 장기 기억
  Map<String, dynamic> compressedMemory = {};  // 압축된 기억
  
  /// 새 메모리 추가
  void addMemory(MemoryItem item) {
    shortTermMemory.add(item);
    
    // 단기 메모리 오버플로우 처리
    if (shortTermMemory.length > SHORT_TERM_CAPACITY) {
      _promoteToMediumTerm();
    }
  }
  
  /// 단기 → 중기 메모리 승격
  void _promoteToMediumTerm() {
    // 중요도 기반 선택적 승격
    final toPromote = shortTermMemory
        .where((m) => m.importance >= MEDIUM_IMPORTANCE)
        .take(10)
        .toList();
    
    mediumTermMemory.addAll(toPromote);
    shortTermMemory.removeWhere((m) => toPromote.contains(m));
    
    // 중요도 낮은 메모리는 요약 후 삭제
    final toLowPriority = shortTermMemory
        .where((m) => m.importance < MEDIUM_IMPORTANCE)
        .toList();
    
    if (toLowPriority.length > 5) {
      // 요약 생성
      final summary = _createMemorySummary(toLowPriority);
      compressedMemory['batch_${DateTime.now().millisecondsSinceEpoch}'] = summary;
      
      // 삭제
      shortTermMemory.removeWhere((m) => toLowPriority.contains(m));
    }
    
    // 중기 메모리 오버플로우 처리
    if (mediumTermMemory.length > MEDIUM_TERM_CAPACITY) {
      _promoteToLongTerm();
    }
  }
  
  /// 중기 → 장기 메모리 승격
  void _promoteToLongTerm() {
    // 매우 중요한 기억만 장기 메모리로
    final toPromote = mediumTermMemory
        .where((m) => m.importance >= HIGH_IMPORTANCE)
        .take(20)
        .toList();
    
    longTermMemory.addAll(toPromote);
    mediumTermMemory.removeWhere((m) => toPromote.contains(m));
    
    // 나머지는 압축
    if (mediumTermMemory.length > 50) {
      final toCompress = mediumTermMemory.take(50).toList();
      final summary = _createMemorySummary(toCompress);
      compressedMemory['compressed_${DateTime.now().millisecondsSinceEpoch}'] = summary;
      mediumTermMemory.removeWhere((m) => toCompress.contains(m));
    }
    
    // 장기 메모리 압축 (800개 초과 시)
    if (longTermMemory.length > LONG_TERM_CAPACITY) {
      _compressLongTermMemory();
    }
  }
  
  /// 장기 메모리 압축
  void _compressLongTermMemory() {
    // 카테고리별 그룹화
    Map<String, List<MemoryItem>> categorized = {};
    
    for (final memory in longTermMemory) {
      categorized.putIfAbsent(memory.category, () => []).add(memory);
    }
    
    // 카테고리별 압축
    categorized.forEach((category, memories) {
      if (memories.length > 100) {
        // 가장 중요한 20개만 유지
        memories.sort((a, b) => b.importance.compareTo(a.importance));
        final toKeep = memories.take(20).toList();
        final toCompress = memories.skip(20).toList();
        
        // 압축 요약 생성
        final summary = {
          'category': category,
          'itemCount': toCompress.length,
          'turnRange': '${toCompress.first.turnNumber}-${toCompress.last.turnNumber}',
          'keyPoints': toCompress.take(5).map((m) => m.content).toList(),
          'averageImportance': toCompress.map((m) => m.importance).reduce((a, b) => a + b) / toCompress.length,
        };
        
        compressedMemory['longterm_$category'] = summary;
        
        // 압축된 항목 제거
        longTermMemory.removeWhere((m) => toCompress.contains(m));
      }
    });
  }
  
  Map<String, dynamic> _createMemorySummary(List<MemoryItem> memories) {
    return {
      'itemCount': memories.length,
      'turnRange': '${memories.first.turnNumber}-${memories.last.turnNumber}',
      'categories': memories.map((m) => m.category).toSet().toList(),
      'averageImportance': memories.map((m) => m.importance).reduce((a, b) => a + b) / memories.length,
      'keyContents': memories.where((m) => m.importance >= MEDIUM_IMPORTANCE).take(3).map((m) => m.content).toList(),
    };
  }
  
  /// 메모리 검색
  MemoryItem? recallMemory(String query, int currentTurn) {
    // 1. 단기 메모리 우선 검색
    var result = _searchInMemories(shortTermMemory, query);
    if (result != null) {
      result.recallHistory.add(currentTurn);
      return result;
    }
    
    // 2. 중기 메모리 검색
    result = _searchInMemories(mediumTermMemory, query);
    if (result != null) {
      result.recallHistory.add(currentTurn);
      // 자주 회상되면 중요도 상승
      if (result.recallHistory.length > 3) {
        result = MemoryItem(
          id: result.id,
          content: result.content,
          category: result.category,
          timestamp: result.timestamp,
          importance: Math.min(1.0, result.importance + 0.1),
          turnNumber: result.turnNumber,
          metadata: result.metadata,
          recallHistory: result.recallHistory,
        );
      }
      return result;
    }
    
    // 3. 장기 메모리 검색
    result = _searchInMemories(longTermMemory, query);
    if (result != null) {
      result.recallHistory.add(currentTurn);
      return result;
    }
    
    // 4. 압축된 메모리에서 힌트 찾기
    for (final compressed in compressedMemory.values) {
      if (compressed['keyContents'] != null) {
        for (final content in compressed['keyContents']) {
          if (content.toString().contains(query)) {
            // 압축된 메모리에서 발견 - 대략적 정보만 제공
            return MemoryItem(
              id: 'compressed_${DateTime.now().millisecondsSinceEpoch}',
              content: '이전에 비슷한 얘기를 했던 것 같아요 (${compressed['turnRange']} 턴 사이)',
              category: 'compressed',
              timestamp: DateTime.now(),
              importance: MEDIUM_IMPORTANCE,
              turnNumber: currentTurn,
              metadata: {'compressed': true, 'originalRange': compressed['turnRange']},
              recallHistory: [currentTurn],
            );
          }
        }
      }
    }
    
    return null;
  }
  
  MemoryItem? _searchInMemories(List<MemoryItem> memories, String query) {
    // 간단한 키워드 매칭 (실제로는 더 정교한 검색 필요)
    for (final memory in memories.reversed) {  // 최근 것부터 검색
      if (memory.content.contains(query) || 
          memory.metadata.values.any((v) => v.toString().contains(query))) {
        return memory;
      }
    }
    return null;
  }
  
  /// 메모리 상태 요약
  Map<String, dynamic> getMemoryStatus() {
    return {
      'shortTerm': {
        'count': shortTermMemory.length,
        'capacity': SHORT_TERM_CAPACITY,
        'usage': '${(shortTermMemory.length / SHORT_TERM_CAPACITY * 100).toStringAsFixed(1)}%',
      },
      'mediumTerm': {
        'count': mediumTermMemory.length,
        'capacity': MEDIUM_TERM_CAPACITY,
        'usage': '${(mediumTermMemory.length / MEDIUM_TERM_CAPACITY * 100).toStringAsFixed(1)}%',
      },
      'longTerm': {
        'count': longTermMemory.length,
        'capacity': LONG_TERM_CAPACITY,
        'usage': '${(longTermMemory.length / LONG_TERM_CAPACITY * 100).toStringAsFixed(1)}%',
      },
      'compressed': {
        'batches': compressedMemory.length,
        'totalCompressed': compressedMemory.values
            .map((c) => c['itemCount'] ?? 0)
            .fold(0, (a, b) => a + b),
      },
      'totalMemories': shortTermMemory.length + mediumTermMemory.length + longTermMemory.length,
    };
  }
}


/// 최적화된 메모리 관리 시스템
/// 장기 대화를 위한 메모리 압축과 효율적 관리
class OptimizedMemorySystem {
  static const int SHORT_TERM_CAPACITY = 50;    // 단기 메모리: 최근 50턴
  static const int MEDIUM_TERM_CAPACITY = 150;  // 중기 메모리: 50-200턴
  static const int LONG_TERM_CAPACITY = 800;    // 장기 메모리: 200턴 이상
  
  // 메모리 중요도 레벨
  static const double CRITICAL_IMPORTANCE = 1.0;   // 절대 잊으면 안됨
  static const double HIGH_IMPORTANCE = 0.8;       // 매우 중요
  static const double MEDIUM_IMPORTANCE = 0.5;     // 보통
  static const double LOW_IMPORTANCE = 0.3;        // 낮음
  
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  /// 메모리 저장 구조

  
  /// 메모리 압축 전략

  
  /// 메모리 계층 관리

  
  /// 메모리 저장 (Firebase)
  Future<void> saveMemoryState(
    String userId,
    String personaId,
    MemoryHierarchy memory,
  ) async {
    final docRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('persona_memories')
        .doc(personaId);
    
    await docRef.set({
      'shortTermMemory': memory.shortTermMemory.map((m) => m.toJson()).toList(),
      'mediumTermMemory': memory.mediumTermMemory.map((m) => m.toJson()).toList(),
      'longTermMemory': memory.longTermMemory.take(100).map((m) => m.toJson()).toList(), // 상위 100개만 저장
      'compressedMemory': memory.compressedMemory,
      'memoryStatus': memory.getMemoryStatus(),
      'lastUpdated': FieldValue.serverTimestamp(),
    });
  }
  
  /// 메모리 로드 (Firebase)
  Future<MemoryHierarchy> loadMemoryState(
    String userId,
    String personaId,
  ) async {
    final docRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('persona_memories')
        .doc(personaId);
    
    final doc = await docRef.get();
    final memory = MemoryHierarchy();
    
    if (doc.exists) {
      final data = doc.data()!;
      
      memory.shortTermMemory = (data['shortTermMemory'] as List?)
          ?.map((m) => MemoryItem.fromJson(m))
          .toList() ?? [];
      
      memory.mediumTermMemory = (data['mediumTermMemory'] as List?)
          ?.map((m) => MemoryItem.fromJson(m))
          .toList() ?? [];
      
      memory.longTermMemory = (data['longTermMemory'] as List?)
          ?.map((m) => MemoryItem.fromJson(m))
          .toList() ?? [];
      
      memory.compressedMemory = data['compressedMemory'] ?? {};
    }
    
    return memory;
  }
  
  /// 메모리 중요도 계산
  static double calculateImportance(Map<String, dynamic> context) {
    double importance = LOW_IMPORTANCE;
    
    // 감정 변화량
    final emotionChange = context['emotionChange'] ?? 0;
    if (emotionChange > 50) importance += 0.3;
    
    // 특별한 키워드
    final message = context['message'] ?? '';
    final importantKeywords = [
      '사랑', '좋아', '만나', '약속', '미래', '결혼', '가족',
      '생일', '기념일', '특별', '처음', '영원', '행복'
    ];
    
    for (final keyword in importantKeywords) {
      if (message.contains(keyword)) {
        importance += 0.2;
        break;
      }
    }
    
    // 사용자가 질문한 경우
    if (message.contains('?')) importance += 0.1;
    
    // 개인 정보 공유
    final personalInfoKeywords = ['이름', '나이', '직업', '사는', '고향', '가족', '친구'];
    for (final keyword in personalInfoKeywords) {
      if (message.contains(keyword)) {
        importance += 0.2;
        break;
      }
    }
    
    return importance.clamp(0.0, 1.0);
  }
}

// Math 클래스 추가
class Math {
  static double min(double a, double b) => a < b ? a : b;
  static double max(double a, double b) => a > b ? a : b;
}