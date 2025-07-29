import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

/// Firebase 스키마 마이그레이션 스크립트
/// 
/// 기존 relationshipScore를 새로운 likes 필드로 마이그레이션
/// 
/// 실행 방법:
/// dart run scripts/migrate_to_likes_system.dart
void main() async {
  // Firebase 초기화
  await Firebase.initializeApp();
  
  final firestore = FirebaseFirestore.instance;
  
  print('🚀 Like 시스템 마이그레이션 시작...');
  
  try {
    // 1. user_persona_relationships 컬렉션 마이그레이션
    print('\n📊 user_persona_relationships 마이그레이션 중...');
    final relationshipsSnapshot = await firestore
        .collection('user_persona_relationships')
        .get();
    
    int relationshipCount = 0;
    final batch1 = firestore.batch();
    
    for (final doc in relationshipsSnapshot.docs) {
      final data = doc.data();
      
      // relationshipScore가 있고 likes가 없는 경우만 마이그레이션
      if (data['relationshipScore'] != null && data['likes'] == null) {
        batch1.update(doc.reference, {
          'likes': data['relationshipScore'],
          'migratedAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
        relationshipCount++;
        
        // 배치가 너무 커지면 커밋하고 새로 시작
        if (relationshipCount % 500 == 0) {
          await batch1.commit();
          print('  - $relationshipCount개 문서 처리됨...');
        }
      }
    }
    
    if (relationshipCount % 500 != 0) {
      await batch1.commit();
    }
    
    print('✅ user_persona_relationships 마이그레이션 완료: $relationshipCount개 문서');
    
    // 2. messages 컬렉션에서 scoreChange 필드명 변경 (선택적)
    print('\n💬 messages 컬렉션 마이그레이션 중...');
    final messagesSnapshot = await firestore
        .collectionGroup('messages')
        .where('scoreChange', isNotEqualTo: null)
        .get();
    
    int messageCount = 0;
    final batch2 = firestore.batch();
    
    for (final doc in messagesSnapshot.docs) {
      final data = doc.data();
      
      // likeChange 필드가 없는 경우만 마이그레이션
      if (data['likeChange'] == null) {
        batch2.update(doc.reference, {
          'likeChange': data['scoreChange'],
          'updatedAt': FieldValue.serverTimestamp(),
        });
        messageCount++;
        
        // 배치가 너무 커지면 커밋하고 새로 시작
        if (messageCount % 500 == 0) {
          await batch2.commit();
          print('  - $messageCount개 메시지 처리됨...');
        }
      }
    }
    
    if (messageCount % 500 != 0) {
      await batch2.commit();
    }
    
    print('✅ messages 마이그레이션 완료: $messageCount개 메시지');
    
    // 3. 새로운 컬렉션 인덱스 생성 정보
    print('\n📋 필요한 Firebase 인덱스:');
    print('1. milestone_history:');
    print('   - Collection: milestone_history');
    print('   - Fields: userId (ASC), personaId (ASC), timestamp (DESC)');
    print('');
    print('2. breakup_history:');
    print('   - Collection: breakup_history');
    print('   - Fields: userId (ASC), personaId (ASC), timestamp (DESC)');
    print('');
    print('3. user_persona_relationships (업데이트):');
    print('   - Collection: user_persona_relationships');
    print('   - Fields: userId (ASC), likes (DESC)');
    
    print('\n✨ 마이그레이션 완료!');
    print('총 처리: relationships=$relationshipCount, messages=$messageCount');
    
  } catch (e) {
    print('❌ 마이그레이션 중 오류 발생: $e');
  }
}