const admin = require('firebase-admin');

// Firebase Admin SDK 초기화
if (!admin.apps.length) {
  const serviceAccount = require('./firebase-service-account-key.json');
  
  admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
    databaseURL: "https://sona-app-default-rtdb.firebaseio.com" // 실제 프로젝트 URL로 변경
  });
}

const db = admin.firestore();

// 다양한 MBTI 유형 목록
const mbtiTypes = [
  'INTJ', 'INTP', 'ENTJ', 'ENTP', // NT (분석가)
  'INFJ', 'INFP', 'ENFJ', 'ENFP', // NF (외교관)
  'ISTJ', 'ISFJ', 'ESTJ', 'ESFJ', // SJ (관리자)  
  'ISTP', 'ISFP', 'ESTP', 'ESFP'  // SP (탐험가)
];

// 성별 목록
const genders = ['male', 'female'];

// 랜덤 MBTI 선택
function getRandomMBTI() {
  return mbtiTypes[Math.floor(Math.random() * mbtiTypes.length)];
}

// 랜덤 성별 선택  
function getRandomGender() {
  return genders[Math.floor(Math.random() * genders.length)];
}

// 페르소나별 특성에 맞는 MBTI 할당 (선택적)
function getPersonalityBasedMBTI(personality = '') {
  const personalityLower = personality.toLowerCase();
  
  // 성격 설명에 따른 MBTI 매칭
  if (personalityLower.includes('분석') || personalityLower.includes('논리')) {
    return ['INTJ', 'INTP', 'ENTJ', 'ENTP'][Math.floor(Math.random() * 4)];
  } else if (personalityLower.includes('감정') || personalityLower.includes('공감')) {
    return ['INFJ', 'INFP', 'ENFJ', 'ENFP'][Math.floor(Math.random() * 4)];
  } else if (personalityLower.includes('활발') || personalityLower.includes('외향')) {
    return ['ENTJ', 'ENTP', 'ENFJ', 'ENFP', 'ESTJ', 'ESFJ', 'ESTP', 'ESFP'][Math.floor(Math.random() * 8)];
  } else if (personalityLower.includes('조용') || personalityLower.includes('내성')) {
    return ['INTJ', 'INTP', 'INFJ', 'INFP', 'ISTJ', 'ISFJ', 'ISTP', 'ISFP'][Math.floor(Math.random() * 8)];
  }
  
  // 기본: 랜덤 선택
  return getRandomMBTI();
}

// 이름에 따른 성별 추정 (한국 이름 기준)
function getGenderFromName(name = '') {
  const femaleNames = ['수진', '지영', '미나', '하은', '서연', '예원', '다연', '수빈', '채원', '윤서', '지우', '민서', '서준', '혜린'];
  const maleNames = ['민수', '지훈', '성호', '준영', '태영', '동현', '승민', '현우', '상혁', '재원', '진호', '우진', '도윤', '시우'];
  
  if (femaleNames.some(fname => name.includes(fname))) {
    return 'female';
  } else if (maleNames.some(mname => name.includes(mname))) {
    return 'male';
  }
  
  // 알 수 없으면 랜덤
  return getRandomGender();
}

async function updatePersonasWithMBTI() {
  try {
    console.log('🚀 Starting MBTI and Gender field update for existing personas...');
    
    // 모든 페르소나 문서 가져오기
    const personasSnapshot = await db.collection('personas').get();
    
    if (personasSnapshot.empty) {
      console.log('❌ No personas found in Firebase');
      return;
    }
    
    console.log(`📄 Found ${personasSnapshot.size} personas to update`);
    
    let updateCount = 0;
    let skipCount = 0;
    
    // 배치 업데이트 준비
    const batch = db.batch();
    
    for (const doc of personasSnapshot.docs) {
      const data = doc.data();
      const personaId = doc.id;
      
      // 이미 mbti와 gender 필드가 있는지 확인
      if (data.mbti && data.gender) {
        console.log(`⏭️  Skipping ${data.name || personaId} - already has MBTI (${data.mbti}) and gender (${data.gender})`);
        skipCount++;
        continue;
      }
      
      // 새로운 필드 생성
      const updates = {};
      
      if (!data.mbti) {
        updates.mbti = getPersonalityBasedMBTI(data.personality);
      }
      
      if (!data.gender) {
        updates.gender = getGenderFromName(data.name);
      }
      
      // 업데이트 타임스탬프 추가
      updates.updatedAt = admin.firestore.FieldValue.serverTimestamp();
      
      // 배치에 추가
      batch.update(doc.ref, updates);
      
      console.log(`✅ Queued update for ${data.name || personaId}: MBTI=${updates.mbti || data.mbti}, Gender=${updates.gender || data.gender}`);
      updateCount++;
    }
    
    // 배치 실행
    if (updateCount > 0) {
      await batch.commit();
      console.log(`🎉 Successfully updated ${updateCount} personas`);
    }
    
    console.log(`📊 Summary:`);
    console.log(`   - Updated: ${updateCount} personas`);
    console.log(`   - Skipped: ${skipCount} personas (already had fields)`);
    console.log(`   - Total: ${personasSnapshot.size} personas processed`);
    
    // 업데이트된 데이터 확인
    console.log('\n🔍 Verifying updates...');
    const updatedSnapshot = await db.collection('personas').limit(5).get();
    
    updatedSnapshot.docs.forEach(doc => {
      const data = doc.data();
      console.log(`   ${data.name}: ${data.mbti} (${data.gender})`);
    });
    
  } catch (error) {
    console.error('❌ Error updating personas:', error);
  }
}

// 특정 페르소나의 MBTI 수동 업데이트 함수
async function updateSpecificPersonaMBTI(personaId, mbti, gender) {
  try {
    await db.collection('personas').doc(personaId).update({
      mbti: mbti,
      gender: gender,
      updatedAt: admin.firestore.FieldValue.serverTimestamp()
    });
    
    console.log(`✅ Updated persona ${personaId}: MBTI=${mbti}, Gender=${gender}`);
  } catch (error) {
    console.error(`❌ Error updating persona ${personaId}:`, error);
  }
}

// 새로운 페르소나 생성 함수 (테스트용)
async function createTestPersonaWithMBTI(name, age, description, personality, mbti, gender, photoUrls = []) {
  try {
    const personaData = {
      name: name,
      age: age,
      description: description,
      personality: personality,
      photoUrls: photoUrls.length > 0 ? photoUrls : ['https://via.placeholder.com/400?text=' + encodeURIComponent(name)],
      preferences: {},
      currentRelationship: 'friend',
      relationshipScore: 0,
      isCasualSpeech: false,
      gender: gender,
      mbti: mbti,
      isActive: true,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    };
    
    const docRef = await db.collection('personas').add(personaData);
    console.log(`✅ Created test persona: ${name} (${mbti}, ${gender}) with ID: ${docRef.id}`);
    return docRef.id;
  } catch (error) {
    console.error(`❌ Error creating test persona:`, error);
  }
}

// 실행 모드 선택
async function main() {
  const args = process.argv.slice(2);
  const mode = args[0] || 'update';
  
  switch (mode) {
    case 'update':
      await updatePersonasWithMBTI();
      break;
      
    case 'specific':
      const personaId = args[1];
      const mbti = args[2];
      const gender = args[3];
      if (personaId && mbti && gender) {
        await updateSpecificPersonaMBTI(personaId, mbti, gender);
      } else {
        console.log('Usage: node firebase_mbti_update_script.js specific <personaId> <mbti> <gender>');
      }
      break;
      
    case 'test':
      await createTestPersonaWithMBTI(
        '테스트 INTJ 남성',
        25,
        '분석적이고 전략적인 사고를 하는 스마트한 사람',
        '논리적이고 계획적이며, 혁신적인 아이디어를 좋아함',
        'INTJ',
        'male'
      );
      
      await createTestPersonaWithMBTI(
        '테스트 ENFP 여성',
        23,
        '밝고 에너지 넘치는 창의적인 사람',
        '열정적이고 사교적이며, 새로운 가능성을 탐구하는 것을 좋아함',
        'ENFP',
        'female'
      );
      break;
      
    default:
      console.log('Available modes:');
      console.log('  update - Update all existing personas');
      console.log('  specific <id> <mbti> <gender> - Update specific persona');
      console.log('  test - Create test personas');
  }
  
  process.exit(0);
}

// 스크립트 실행
main().catch(console.error); 