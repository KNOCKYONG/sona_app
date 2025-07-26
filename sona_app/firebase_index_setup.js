const admin = require('firebase-admin');

// Firebase Admin SDK 초기화
const serviceAccount = require('../firebase-service-account-key.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: `https://${serviceAccount.project_id}-default-rtdb.firebaseio.com`
});

const db = admin.firestore();

// 성능 테스트용 더미 데이터 생성
async function createTestData() {
  console.log('🧪 Creating test data for performance testing...');
  
  try {
    const batch = db.batch();
    const testUsers = ['test_user_1', 'test_user_2', 'test_user_3'];
    const testPersonas = ['persona_001', 'persona_002', 'persona_003', 'persona_004', 'persona_005'];
    
    let documentCount = 0;
    
    for (const userId of testUsers) {
      for (const personaId of testPersonas) {
        const docId = `${userId}_${personaId}`;
        const isMatched = Math.random() > 0.3; // 70% 매칭 확률
        const swipeAction = isMatched ? 'like' : 'pass';
        
        const relationshipData = {
          userId: userId,
          personaId: personaId,
          relationshipScore: isMatched ? Math.floor(Math.random() * 400) + 50 : 0,
          relationshipType: 'friend',
          relationshipDisplayName: '친구',
          isCasualSpeech: Math.random() > 0.7,
          emotionalIntensity: Math.random(),
          canShowJealousy: Math.random() > 0.5,
          interactionCount: Math.floor(Math.random() * 100),
          swipeAction: swipeAction,
          isMatched: isMatched,
          isActive: isMatched,
          matchedAt: admin.firestore.FieldValue.serverTimestamp(),
          createdAt: admin.firestore.FieldValue.serverTimestamp(),
          lastInteraction: admin.firestore.FieldValue.serverTimestamp(),
          // 비정규화 데이터
          personaName: `TestPersona_${personaId.split('_')[1]}`,
          personaAge: Math.floor(Math.random() * 20) + 20,
          personaPhotoUrl: `https://example.com/photo_${personaId}.jpg`,
          // 메타데이터
          metadata: {
            firstMet: new Date().toISOString(),
            favoriteTopics: ['테스트', '성능'],
            conversationStyle: 'test',
            preferredTime: 'any'
          }
        };
        
        const docRef = db.collection('user_persona_relationships').doc(docId);
        batch.set(docRef, relationshipData);
        documentCount++;
        
        // 배치 크기 제한 (500개)
        if (documentCount % 500 === 0) {
          await batch.commit();
          console.log(`📝 Created ${documentCount} test documents`);
        }
      }
    }
    
    // 남은 문서들 커밋
    if (documentCount % 500 !== 0) {
      await batch.commit();
    }
    
    console.log(`✅ Successfully created ${documentCount} test relationship documents`);
  } catch (error) {
    console.error('❌ Error creating test data:', error);
  }
}

// 성능 테스트 실행
async function runPerformanceTests() {
  console.log('\n🚀 Running performance tests...');
  
  try {
    // 테스트 1: 단일 문서 읽기 (최적화된 방식)
    console.log('\n📖 Test 1: Direct document read');
    const startTime1 = Date.now();
    
    const doc = await db
      .collection('user_persona_relationships')
      .doc('test_user_1_persona_001')
      .get();
    
    const endTime1 = Date.now();
    console.log(`   ✅ Direct read: ${endTime1 - startTime1}ms`);
    console.log(`   📄 Document exists: ${doc.exists}`);
    
    // 테스트 2: 사용자의 모든 매칭 조회 (최적화된 방식)
    console.log('\n📊 Test 2: User matches query');
    const startTime2 = Date.now();
    
    const querySnapshot = await db
      .collection('user_persona_relationships')
      .where('userId', '==', 'test_user_1')
      .where('isMatched', '==', true)
      .where('isActive', '==', true)
      .orderBy('lastInteraction', 'desc')
      .get();
    
    const endTime2 = Date.now();
    console.log(`   ✅ Query execution: ${endTime2 - startTime2}ms`);
    console.log(`   📊 Results count: ${querySnapshot.size}`);
    
    // 테스트 3: 배치 읽기 (병렬 처리)
    console.log('\n🔄 Test 3: Batch parallel reads');
    const startTime3 = Date.now();
    
    const docIds = [
      'test_user_1_persona_001',
      'test_user_1_persona_002',
      'test_user_1_persona_003',
      'test_user_1_persona_004',
      'test_user_1_persona_005'
    ];
    
    const batchReads = docIds.map(docId => 
      db.collection('user_persona_relationships').doc(docId).get()
    );
    
    const batchResults = await Promise.all(batchReads);
    const endTime3 = Date.now();
    
    console.log(`   ✅ Batch reads: ${endTime3 - startTime3}ms`);
    console.log(`   📊 Documents read: ${batchResults.length}`);
    console.log(`   📈 Avg per document: ${(endTime3 - startTime3) / batchResults.length}ms`);
    
    // 테스트 4: 통계 쿼리
    console.log('\n📈 Test 4: Statistics query');
    const startTime4 = Date.now();
    
    const statsSnapshot = await db
      .collection('user_persona_relationships')
      .where('userId', '==', 'test_user_1')
      .get();
    
    const endTime4 = Date.now();
    
    // 통계 계산
    let totalMatches = 0;
    let totalPasses = 0;
    let avgScore = 0;
    let scoreSum = 0;
    
    statsSnapshot.docs.forEach(doc => {
      const data = doc.data();
      if (data.isMatched) {
        totalMatches++;
        scoreSum += data.relationshipScore || 0;
      } else {
        totalPasses++;
      }
    });
    
    avgScore = totalMatches > 0 ? scoreSum / totalMatches : 0;
    
    console.log(`   ✅ Stats query: ${endTime4 - startTime4}ms`);
    console.log(`   📊 Total relationships: ${statsSnapshot.size}`);
    console.log(`   💕 Matches: ${totalMatches}`);
    console.log(`   ❌ Passes: ${totalPasses}`);
    console.log(`   📈 Average score: ${avgScore.toFixed(1)}`);
    
  } catch (error) {
    console.error('❌ Performance test failed:', error);
  }
}

// 인덱스 필요성 체크
async function checkIndexRequirements() {
  console.log('\n🔍 Checking index requirements...');
  
  try {
    // 복합 쿼리 테스트 (인덱스 필요)
    console.log('📋 Testing compound query (requires index)...');
    
    const testQuery = db
      .collection('user_persona_relationships')
      .where('userId', '==', 'test_user_1')
      .where('isMatched', '==', true)
      .where('isActive', '==', true)
      .orderBy('lastInteraction', 'desc')
      .limit(10);
    
    const snapshot = await testQuery.get();
    console.log(`✅ Index working correctly - ${snapshot.size} results`);
    
    // 필요한 인덱스 출력
    console.log('\n📝 Required Firebase indexes:');
    console.log('1. user_persona_relationships collection:');
    console.log('   - Fields: userId (ASC), isMatched (ASC), isActive (ASC), lastInteraction (DESC)');
    console.log('   - Purpose: Load user matched personas sorted by recent interaction');
    console.log('');
    console.log('2. user_persona_relationships collection:');
    console.log('   - Fields: userId (ASC), createdAt (DESC)');
    console.log('   - Purpose: Load all user relationships chronologically');
    console.log('');
    console.log('📌 Create these indexes in Firebase Console > Firestore > Indexes');
    
  } catch (error) {
    if (error.code === 9) { // FAILED_PRECONDITION
      console.log('⚠️  Index not found - Create the required indexes in Firebase Console');
      console.log('📋 Error details:', error.message);
    } else {
      console.error('❌ Index check failed:', error);
    }
  }
}

// 최적화 제안
async function analyzeOptimizationOpportunities() {
  console.log('\n🔧 Analyzing optimization opportunities...');
  
  try {
    // 데이터 크기 분석
    const allDocs = await db.collection('user_persona_relationships').get();
    console.log(`📊 Total documents: ${allDocs.size}`);
    
    let totalDataSize = 0;
    let largestDoc = 0;
    let avgFieldCount = 0;
    
    allDocs.docs.forEach(doc => {
      const data = doc.data();
      const docSize = JSON.stringify(data).length;
      totalDataSize += docSize;
      
      if (docSize > largestDoc) {
        largestDoc = docSize;
      }
      
      avgFieldCount += Object.keys(data).length;
    });
    
    const avgDocSize = totalDataSize / allDocs.size;
    avgFieldCount = avgFieldCount / allDocs.size;
    
    console.log(`📏 Average document size: ${avgDocSize.toFixed(0)} bytes`);
    console.log(`📏 Largest document: ${largestDoc} bytes`);
    console.log(`📊 Average field count: ${avgFieldCount.toFixed(1)}`);
    
    // 최적화 제안
    console.log('\n💡 Optimization recommendations:');
    
    if (avgDocSize > 1000) {
      console.log('⚠️  Large document size detected - consider field optimization');
    } else {
      console.log('✅ Document size is optimal');
    }
    
    if (avgFieldCount > 20) {
      console.log('⚠️  High field count - consider data normalization');
    } else {
      console.log('✅ Field count is reasonable');
    }
    
    console.log('📈 Performance tips:');
    console.log('   1. Use document ID pattern: {userId}_{personaId}');
    console.log('   2. Limit query results with .limit()');
    console.log('   3. Use batch operations for multiple writes');
    console.log('   4. Implement client-side caching');
    console.log('   5. Monitor read/write costs in Firebase Console');
    
  } catch (error) {
    console.error('❌ Analysis failed:', error);
  }
}

// 메인 실행 함수
async function main() {
  console.log('🌟 Firebase Performance Optimization Suite');
  console.log('='.repeat(50));
  
  try {
    // 1. 테스트 데이터 생성
    await createTestData();
    
    // 2. 성능 테스트 실행
    await runPerformanceTests();
    
    // 3. 인덱스 요구사항 체크
    await checkIndexRequirements();
    
    // 4. 최적화 분석
    await analyzeOptimizationOpportunities();
    
    console.log('\n🎉 Performance optimization analysis completed!');
    console.log('📋 Next steps:');
    console.log('   1. Create required indexes in Firebase Console');
    console.log('   2. Monitor performance metrics in production');
    console.log('   3. Implement caching strategies in Flutter app');
    console.log('   4. Set up Firebase Performance Monitoring');
    
  } catch (error) {
    console.error('💥 Suite execution failed:', error);
  } finally {
    // Firebase Admin 연결 종료
    admin.app().delete();
  }
}

// 정리 함수 (테스트 데이터 삭제)
async function cleanup() {
  console.log('🧹 Cleaning up test data...');
  
  try {
    const testDocs = await db
      .collection('user_persona_relationships')
      .where('userId', 'in', ['test_user_1', 'test_user_2', 'test_user_3'])
      .get();
    
    const batch = db.batch();
    testDocs.docs.forEach(doc => {
      batch.delete(doc.ref);
    });
    
    await batch.commit();
    console.log(`🗑️  Deleted ${testDocs.size} test documents`);
  } catch (error) {
    console.error('❌ Cleanup failed:', error);
  }
}

// 명령줄 인수 처리
if (require.main === module) {
  const args = process.argv.slice(2);
  
  if (args.includes('--cleanup')) {
    cleanup();
  } else {
    main();
  }
}

module.exports = {
  createTestData,
  runPerformanceTests,
  checkIndexRequirements,
  analyzeOptimizationOpportunities,
  cleanup
}; 