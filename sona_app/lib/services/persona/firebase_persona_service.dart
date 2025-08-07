import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../models/persona.dart';
import '../storage/firebase_storage_service.dart';
import '../chat/persona_relationship_cache.dart';

class FirebasePersonaService extends ChangeNotifier {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collections
  static const String _personasCollection = 'personas';
  static const String _usersCollection = 'users';
  static const String _messagesCollection = 'messages';
  static const String _matchesCollection = 'matches';

  List<Persona> _allPersonas = [];
  List<Persona> _availablePersonas = [];
  List<Persona> _myPersonas = [];
  List<String> _swipedPersonaIds = [];
  List<String> _matchedPersonaIds = [];
  Persona? _currentPersona;
  bool _isLoading = false;

  // Getters
  List<Persona> get allPersonas => _allPersonas;
  List<Persona> get availablePersonas => _availablePersonas;
  List<Persona> get myPersonas => _myPersonas;
  List<String> get swipedPersonaIds => _swipedPersonaIds;
  List<String> get matchedPersonaIds => _matchedPersonaIds;
  Persona? get currentPersona => _currentPersona;
  bool get isLoading => _isLoading;

  /// Firebase에서 모든 페르소나 로드
  Future<void> loadAllPersonas() async {
    try {
      _isLoading = true;
      notifyListeners();

      final querySnapshot = await _firestore
          .collection(_personasCollection)
          .where('isActive', isEqualTo: true)
          .orderBy('createdAt', descending: true)
          .get();

      _allPersonas = querySnapshot.docs
          .map((doc) => Persona.fromJson({
                'id': doc.id,
                ...doc.data(),
              }))
          .toList();

      _availablePersonas = _allPersonas
          .where((persona) => !_swipedPersonaIds.contains(persona.id))
          .toList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint('Error loading personas: $e');
      throw Exception('Failed to load personas: $e');
    }
  }

  /// 새 페르소나 생성 및 Firebase에 저장
  Future<String> createPersona({
    required String name,
    required int age,
    required String description,
    required String personality,
    required List<String> photoUrls,
    Map<String, dynamic> preferences = const {},
  }) async {
    try {
      final personaData = {
        'name': name,
        'age': age,
        'description': description,
        'personality': personality,
        'photoUrls': photoUrls,
        'preferences': preferences,
        // TODO: RelationshipType 정의 후 주석 해제
        // 'currentRelationship': RelationshipType.friend.name,
        'currentRelationship': 'friend', // 임시로 문자열 사용
        'likes': 0, // Use new likes field
        'isCasualSpeech': true, // 항상 반말 모드
        'gender': 'female', // 기본값
        'mbti': 'ENFP', // 기본값
        'isActive': true,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      final docRef =
          await _firestore.collection(_personasCollection).add(personaData);

      await loadAllPersonas(); // 새로 고침
      return docRef.id;
    } catch (e) {
      debugPrint('Error creating persona: $e');
      throw Exception('Failed to create persona: $e');
    }
  }

  /// 페르소나 업데이트
  Future<bool> updatePersona(
      String personaId, Map<String, dynamic> updateData) async {
    try {
      await _firestore.collection(_personasCollection).doc(personaId).update({
        ...updateData,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      await loadAllPersonas(); // 새로 고침
      return true;
    } catch (e) {
      debugPrint('Error updating persona: $e');
      return false;
    }
  }

  /// 페르소나 삭제 (soft delete)
  Future<bool> deletePersona(String personaId) async {
    try {
      await _firestore.collection(_personasCollection).doc(personaId).update({
        'isActive': false,
        'deletedAt': FieldValue.serverTimestamp(),
      });

      // Storage에서 사진도 삭제
      await FirebaseStorageService.deleteAllPersonaPhotos(personaId);

      await loadAllPersonas(); // 새로 고침
      return true;
    } catch (e) {
      debugPrint('Error deleting persona: $e');
      return false;
    }
  }

  /// 사용자별 매칭 정보 로드
  Future<void> loadUserMatches(String userId) async {
    try {
      // 사용자의 스와이프 기록 로드
      final swipeDoc = await _firestore
          .collection(_usersCollection)
          .doc(userId)
          .collection('swipes')
          .doc('history')
          .get();

      if (swipeDoc.exists) {
        final data = swipeDoc.data();
        _swipedPersonaIds = List<String>.from(data?['personaIds'] ?? []);
      }

      // 사용자의 매칭 기록 로드
      final matchSnapshot = await _firestore
          .collection(_usersCollection)
          .doc(userId)
          .collection(_matchesCollection)
          .where('isActive', isEqualTo: true)
          .get();

      _matchedPersonaIds = matchSnapshot.docs
          .map((doc) => doc.data()['personaId'] as String)
          .toList();

      // 매칭된 페르소나들 로드
      if (_matchedPersonaIds.isNotEmpty) {
        _myPersonas = _allPersonas
            .where((persona) => _matchedPersonaIds.contains(persona.id))
            .toList();
      }

      // 사용 가능한 페르소나 업데이트
      _availablePersonas = _allPersonas
          .where((persona) => !_swipedPersonaIds.contains(persona.id))
          .toList();

      notifyListeners();
    } catch (e) {
      debugPrint('Error loading user matches: $e');
    }
  }

  /// 페르소나에 좋아요 표시
  Future<bool> likePersona(String userId, String personaId) async {
    try {
      // 스와이프 기록에 추가
      await _firestore
          .collection(_usersCollection)
          .doc(userId)
          .collection('swipes')
          .doc('history')
          .set({
        'personaIds': FieldValue.arrayUnion([personaId]),
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // 매칭 생성
      await _firestore
          .collection(_usersCollection)
          .doc(userId)
          .collection(_matchesCollection)
          .doc(personaId)
          .set({
        'personaId': personaId,
        'userId': userId,
        'isActive': true,
        'matchedAt': FieldValue.serverTimestamp(),
        'likes': 0, // Use new likes field
        'isCasualSpeech': true, // 항상 반말 모드
      });

      _swipedPersonaIds.add(personaId);
      _matchedPersonaIds.add(personaId);

      // 페르소나를 내 리스트에 추가
      final persona = _allPersonas.firstWhere((p) => p.id == personaId);
      _myPersonas.add(persona);

      // 사용 가능한 목록에서 제거
      _availablePersonas.removeWhere((p) => p.id == personaId);

      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error liking persona: $e');
      return false;
    }
  }

  /// 페르소나에 싫어요 표시
  Future<bool> passPersona(String userId, String personaId) async {
    try {
      // 스와이프 기록에만 추가 (매칭 없음)
      await _firestore
          .collection(_usersCollection)
          .doc(userId)
          .collection('swipes')
          .doc('history')
          .set({
        'personaIds': FieldValue.arrayUnion([personaId]),
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      _swipedPersonaIds.add(personaId);

      // 사용 가능한 목록에서 제거
      _availablePersonas.removeWhere((p) => p.id == personaId);

      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error passing persona: $e');
      return false;
    }
  }

  /// 관계 점수 업데이트
  Future<bool> updateRelationshipScore(
    String userId,
    String personaId,
    int scoreChange,
  ) async {
    try {
      final matchDocRef = _firestore
          .collection(_usersCollection)
          .doc(userId)
          .collection(_matchesCollection)
          .doc(personaId);

      final matchDoc = await matchDocRef.get();
      if (!matchDoc.exists) return false;

      final currentScore = matchDoc.data()?['likes'] ??
          matchDoc.data()?['relationshipScore'] ??
          0;
      final newScore = (currentScore + scoreChange).clamp(0, 1000);

      await matchDocRef.update({
        'likes': newScore, // Update using new likes field
        'lastScoreUpdate': FieldValue.serverTimestamp(),
      });

      // 로컬에서도 업데이트
      if (_currentPersona?.id == personaId) {
        _currentPersona = _currentPersona!.copyWith(likes: newScore);
      }

      // myPersonas에서도 업데이트
      final index = _myPersonas.indexWhere((p) => p.id == personaId);
      if (index != -1) {
        _myPersonas[index] = _myPersonas[index].copyWith(likes: newScore);
      }

      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error updating relationship score: $e');
      return false;
    }
  }

  /// 반말 설정 업데이트
  Future<bool> updateCasualSpeech(
    String userId,
    String personaId,
    bool isCasualSpeech,
  ) async {
    try {
      await _firestore
          .collection(_usersCollection)
          .doc(userId)
          .collection(_matchesCollection)
          .doc(personaId)
          .update({
        'isCasualSpeech': isCasualSpeech,
        'casualSpeechUpdatedAt': FieldValue.serverTimestamp(),
      });

      // 로컬에서도 업데이트 - PersonaRelationshipCache가 처리하므로 여기서는 캐시 무효화만
      PersonaRelationshipCache.instance.invalidatePersona(userId, personaId);

      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error updating casual speech: $e');
      return false;
    }
  }

  /// 현재 페르소나 설정
  void setCurrentPersona(Persona persona) {
    _currentPersona = persona;
    notifyListeners();
  }

  /// 페르소나 검색
  List<Persona> searchPersonas(String query) {
    if (query.isEmpty) return _availablePersonas;

    return _availablePersonas
        .where((persona) =>
            persona.name.toLowerCase().contains(query.toLowerCase()) ||
            persona.description.toLowerCase().contains(query.toLowerCase()) ||
            persona.personality.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  /// 데이터 초기화 (로그아웃 시)
  void clearData() {
    _allPersonas.clear();
    _availablePersonas.clear();
    _myPersonas.clear();
    _swipedPersonaIds.clear();
    _matchedPersonaIds.clear();
    _currentPersona = null;
    notifyListeners();
  }
}
