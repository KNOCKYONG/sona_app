import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/persona.dart';
import '../../models/message.dart';
import '../base/base_service.dart';
import '../../helpers/firebase_helper.dart';
import '../../core/constants.dart';

/// 🎯 관계 점수 관리 서비스
/// 
/// 핵심 기능:
/// 1. 관계 점수 계산 및 업데이트
/// 2. 관계 단계 변화 감지
/// 3. 감정 기반 점수 변화 계산
/// 4. 관계 이력 추적
class RelationScoreService extends BaseService {
  static RelationScoreService? _instance;
  static RelationScoreService get instance => _instance ??= RelationScoreService._();
  
  RelationScoreService._();
  
  final Random _random = Random();
  
  /// 관계 단계별 점수 임계값
  static const Map<RelationshipType, int> _scoreThresholds = {
    RelationshipType.friend: 0,
    RelationshipType.crush: 200,
    RelationshipType.dating: 500,
    RelationshipType.perfectLove: 1000,
  };
  
  /// 관계 단계별 최대 점수
  static const Map<RelationshipType, int> _maxScores = {
    RelationshipType.friend: 199,
    RelationshipType.crush: 499,
    RelationshipType.dating: 999,
    RelationshipType.perfectLove: 1000,
  };
  
  /// 감정에 따른 점수 변화 계산
  int calculateScoreChange({
    required EmotionType emotion,
    required String userMessage,
    required Persona persona,
    required List<Message> chatHistory,
    required int currentScore,
  }) {
    // 랜덤 요소 추가 (70% 확률로만 친밀도 변화)
    if (_random.nextDouble() > 0.7) {
      return 0;
    }
    
    // 현재 관계 단계 확인
    final currentRelationship = getRelationshipType(currentScore);
    
    // 관계 단계별 최대 변화량 제한
    final maxChange = _getMaxChangeForRelationship(currentRelationship);
    
    // 감정과 대화 내용에 따른 친밀도 변화
    int baseChange = _getBaseScoreChange(emotion);
    
    // 부정적인 메시지 체크
    if (_containsNegativeWords(userMessage)) {
      baseChange = -(_random.nextInt(5) + 3); // -3 ~ -7
    }
    
    // 관계 단계별 보정
    baseChange = _applyRelationshipModifier(baseChange, currentRelationship);
    
    // 최대 변화량 제한 적용
    return baseChange.clamp(-maxChange, maxChange);
  }
  
  /// 감정별 기본 점수 변화량
  int _getBaseScoreChange(EmotionType emotion) {
    switch (emotion) {
      case EmotionType.happy:
        return _random.nextInt(3) + 2; // 2~4
      case EmotionType.love:
        return _random.nextInt(4) + 3; // 3~6
      case EmotionType.surprised:
        return _random.nextInt(3) + 1; // 1~3
      case EmotionType.angry:
        return -(_random.nextInt(3) + 1); // -1~-3
      case EmotionType.sad:
        return _random.nextInt(2) - 1; // -1~0
      case EmotionType.neutral:
        return _random.nextInt(2); // 0~1
      case EmotionType.shy:
      case EmotionType.jealous:
      case EmotionType.thoughtful:
      case EmotionType.anxious:
      case EmotionType.concerned:
        return _random.nextInt(2); // 0~1
    }
  }
  
  /// 관계 단계별 최대 변화량
  int _getMaxChangeForRelationship(RelationshipType relationship) {
    switch (relationship) {
      case RelationshipType.friend:
        return 7;
      case RelationshipType.crush:
        return 10;
      case RelationshipType.dating:
        return 8;
      case RelationshipType.perfectLove:
        return 5; // 완벽한 사랑은 변화가 적음
    }
  }
  
  /// 관계 단계별 점수 변화 보정
  int _applyRelationshipModifier(int baseChange, RelationshipType relationship) {
    switch (relationship) {
      case RelationshipType.friend:
        // 친구일 때는 긍정적 변화 증폭
        return baseChange > 0 ? (baseChange * 1.2).round() : baseChange;
      case RelationshipType.crush:
        // 썸 단계에서는 부정적 변화 감소
        return baseChange < 0 ? (baseChange * 0.7).round() : baseChange;
      case RelationshipType.dating:
        // 연인 단계에서는 전체적으로 안정적
        return (baseChange * 0.8).round();
      case RelationshipType.perfectLove:
        // 완벽한 사랑은 매우 안정적
        return (baseChange * 0.5).round();
    }
  }
  
  /// 부정적인 단어 포함 여부 확인
  bool _containsNegativeWords(String message) {
    final rudeWords = [
      '바보', '멍청이', '멍청', '병신', '시발', '씨발', '개새끼', '새끼',
      '닥쳐', '꺼져', '지랄', '좆', '좆같', '개같', '미친', '또라이',
      '쓰레기', '찐따', '한심', '재수없', '짜증', '싫어', '싫다',
      '꺼져', '죽어', '뒤져', '개짜증', '존나', '뭐야', '뭔데'
    ];
    
    final lowerMessage = message.toLowerCase();
    return rudeWords.any((word) => lowerMessage.contains(word));
  }
  
  /// 점수를 기반으로 관계 타입 결정
  RelationshipType getRelationshipType(int score) {
    if (score >= 1000) {
      return RelationshipType.perfectLove;
    } else if (score >= 500) {
      return RelationshipType.dating;
    } else if (score >= 200) {
      return RelationshipType.crush;
    } else {
      return RelationshipType.friend;
    }
  }
  
  /// 관계 타입을 문자열로 변환
  String getRelationshipTypeString(int score) {
    final type = getRelationshipType(score);
    switch (type) {
      case RelationshipType.friend:
        return '친구';
      case RelationshipType.crush:
        return '썸';
      case RelationshipType.dating:
        return '연애';
      case RelationshipType.perfectLove:
        return '완전 연애';
    }
  }
  
  /// Firebase에 관계 점수 업데이트
  Future<void> updateRelationshipScore({
    required String userId,
    required String personaId,
    required int scoreChange,
    required int currentScore,
  }) async {
    if (scoreChange == 0) return;
    
    await executeWithLoading(() async {
      final newScore = (currentScore + scoreChange).clamp(0, 1000);
      final newRelationshipType = getRelationshipType(newScore);
      
      // user_persona_relationships 컬렉션 업데이트
      final docId = '${userId}_${personaId}';
      await FirebaseHelper.userPersonaRelationships
          .doc(docId)
          .set({
        'userId': userId,
        'personaId': personaId,
        'relationshipScore': newScore,
        'currentRelationship': newRelationshipType.name,
        'lastInteraction': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      
      // 관계 이력 추가 (선택적)
      await _addRelationshipHistory(
        userId: userId,
        personaId: personaId,
        scoreChange: scoreChange,
        oldScore: currentScore,
        newScore: newScore,
        oldRelationship: getRelationshipType(currentScore),
        newRelationship: newRelationshipType,
      );
      
      debugPrint('💕 Relationship score updated: $personaId ($currentScore -> $newScore, ${newRelationshipType.displayName})');
    });
  }
  
  /// 관계 이력 추가
  Future<void> _addRelationshipHistory({
    required String userId,
    required String personaId,
    required int scoreChange,
    required int oldScore,
    required int newScore,
    required RelationshipType oldRelationship,
    required RelationshipType newRelationship,
  }) async {
    // 관계 단계가 변경된 경우에만 이력 추가
    if (oldRelationship != newRelationship) {
      await FirebaseFirestore.instance
          .collection('relationship_history')
          .add({
        'userId': userId,
        'personaId': personaId,
        'scoreChange': scoreChange,
        'oldScore': oldScore,
        'newScore': newScore,
        'oldRelationship': oldRelationship.name,
        'newRelationship': newRelationship.name,
        'timestamp': FieldValue.serverTimestamp(),
      });
      
      debugPrint('📈 Relationship milestone reached: ${oldRelationship.displayName} -> ${newRelationship.displayName}');
    }
  }
  
  /// 특정 페르소나와의 관계 점수 조회
  Future<int> getRelationshipScore({
    required String userId,
    required String personaId,
  }) async {
    final result = await executeSafely<int>(() async {
      final docId = '${userId}_${personaId}';
      final doc = await FirebaseHelper.userPersonaRelationships
          .doc(docId)
          .get();
      
      if (doc.exists) {
        return doc.data()?['relationshipScore'] ?? 0;
      }
      return 0;
    }, defaultValue: 0);
    
    return result ?? 0;
  }
  
  /// 모든 페르소나와의 관계 점수 조회
  Future<Map<String, int>> getAllRelationshipScores(String userId) async {
    final result = await executeSafely<Map<String, int>>(() async {
      final snapshot = await FirebaseHelper.userPersonaRelationships
          .where('userId', isEqualTo: userId)
          .get();
      
      final scores = <String, int>{};
      for (final doc in snapshot.docs) {
        final data = doc.data();
        final personaId = data['personaId'] as String;
        final score = data['relationshipScore'] as int? ?? 0;
        scores[personaId] = score;
      }
      
      return scores;
    }, defaultValue: {});
    
    return result ?? {};
  }
  
  /// 관계 이력 조회
  Future<List<Map<String, dynamic>>> getRelationshipHistory({
    required String userId,
    required String personaId,
    int limit = 10,
  }) async {
    final result = await executeSafely<List<Map<String, dynamic>>>(() async {
      final snapshot = await FirebaseFirestore.instance
          .collection('relationship_history')
          .where('userId', isEqualTo: userId)
          .where('personaId', isEqualTo: personaId)
          .orderBy('timestamp', descending: true)
          .limit(limit)
          .get();
      
      return snapshot.docs.map((doc) => doc.data()).toList();
    }, defaultValue: []);
    
    return result ?? [];
  }
}