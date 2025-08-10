import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../../models/message.dart';
import '../../models/persona.dart';

/// 최적화된 채팅 서비스
/// - 배치 로드 지원
/// - 메모리 효율적인 캐싱
/// - 스트림 기반 실시간 업데이트
class OptimizedChatService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // 메시지 캐시 (personaId -> messages)
  final Map<String, List<Message>> _messageCache = {};
  
  // 캐시 타임스탬프
  final Map<String, DateTime> _cacheTimestamps = {};
  
  // 캐시 유효 시간 (30초)
  static const Duration _cacheValidity = Duration(seconds: 30);
  
  // 최대 캐시 메시지 수 (페르소나당)
  static const int _maxMessagesPerPersona = 100;
  
  /// 배치로 여러 페르소나의 메시지 로드
  Future<void> loadMessagesBatch({
    required String userId,
    required List<String> personaIds,
    int messagesPerPersona = 20,
  }) async {
    if (personaIds.isEmpty) return;
    
    try {
      // 캐시 유효성 체크
      final now = DateTime.now();
      final idsToLoad = personaIds.where((id) {
        final timestamp = _cacheTimestamps[id];
        if (timestamp == null) return true;
        return now.difference(timestamp) > _cacheValidity;
      }).toList();
      
      if (idsToLoad.isEmpty) {
        debugPrint('✅ All messages cached');
        return;
      }
      
      debugPrint('🔄 Loading messages for ${idsToLoad.length} personas');
      
      // Collection Group Query 사용 (더 효율적)
      final futures = <Future<QuerySnapshot>>[];
      
      for (final personaId in idsToLoad) {
        futures.add(
          _firestore
              .collection('users')
              .doc(userId)
              .collection('messages')
              .where('personaId', isEqualTo: personaId)
              .orderBy('timestamp', descending: true)
              .limit(messagesPerPersona)
              .get()
        );
      }
      
      // 병렬 실행
      final snapshots = await Future.wait(futures);
      
      // 결과 처리
      for (int i = 0; i < idsToLoad.length; i++) {
        final personaId = idsToLoad[i];
        final snapshot = snapshots[i];
        
        final messages = snapshot.docs
            .map((doc) => Message.fromJson({
                  ...doc.data(),
                  'id': doc.id,
                }))
            .toList()
            .reversed // 시간순 정렬
            .toList();
        
        // 캐시 업데이트
        _messageCache[personaId] = messages;
        _cacheTimestamps[personaId] = now;
        
        // 메모리 관리: 오래된 메시지 제거
        if (messages.length > _maxMessagesPerPersona) {
          _messageCache[personaId] = messages.take(_maxMessagesPerPersona).toList();
        }
      }
      
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Error loading batch messages: $e');
    }
  }
  
  /// 단일 페르소나 메시지 스트림
  Stream<List<Message>> getMessageStream({
    required String userId,
    required String personaId,
    int limit = 50,
  }) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('messages')
        .where('personaId', isEqualTo: personaId)
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) {
      final messages = snapshot.docs
          .map((doc) => Message.fromJson({
                ...doc.data(),
                'id': doc.id,
              }))
          .toList()
          .reversed
          .toList();
      
      // 캐시 업데이트
      _messageCache[personaId] = messages;
      _cacheTimestamps[personaId] = DateTime.now();
      
      return messages;
    });
  }
  
  /// 캐시된 메시지 가져오기
  List<Message> getCachedMessages(String personaId) {
    return _messageCache[personaId] ?? [];
  }
  
  /// 캐시 무효화
  void invalidateCache([String? personaId]) {
    if (personaId != null) {
      _messageCache.remove(personaId);
      _cacheTimestamps.remove(personaId);
    } else {
      _messageCache.clear();
      _cacheTimestamps.clear();
    }
    notifyListeners();
  }
  
  /// 메모리 정리
  void clearOldCache() {
    final now = DateTime.now();
    final keysToRemove = <String>[];
    
    _cacheTimestamps.forEach((key, timestamp) {
      if (now.difference(timestamp) > const Duration(minutes: 5)) {
        keysToRemove.add(key);
      }
    });
    
    for (final key in keysToRemove) {
      _messageCache.remove(key);
      _cacheTimestamps.remove(key);
    }
    
    if (keysToRemove.isNotEmpty) {
      debugPrint('🧹 Cleared ${keysToRemove.length} old caches');
    }
  }
  
  /// 실시간 메시지 업데이트 구독
  void subscribeToPersonaMessages({
    required String userId,
    required String personaId,
    required Function(Message) onNewMessage,
  }) {
    _firestore
        .collection('users')
        .doc(userId)
        .collection('messages')
        .where('personaId', isEqualTo: personaId)
        .where('isFromUser', isEqualTo: false)
        .orderBy('timestamp', descending: true)
        .limit(1)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        final message = Message.fromJson({
          ...snapshot.docs.first.data(),
          'id': snapshot.docs.first.id,
        });
        
        // 캐시에 추가
        final cached = _messageCache[personaId] ?? [];
        if (cached.isEmpty || cached.last.id != message.id) {
          cached.add(message);
          _messageCache[personaId] = cached;
          onNewMessage(message);
        }
      }
    });
  }
  
  @override
  void dispose() {
    _messageCache.clear();
    _cacheTimestamps.clear();
    super.dispose();
  }
}