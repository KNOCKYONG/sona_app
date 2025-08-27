import 'sona_app/lib/services/relationship/relation_score_service.dart';
import 'sona_app/lib/services/relationship/negative_behavior_system.dart';
import 'sona_app/lib/models/persona.dart';
import 'sona_app/lib/models/message.dart';

void main() {
  print('=== Emotional State Transition Test ===\n');
  
  // Test persona
  final testPersona = Persona(
    id: 'test-persona',
    name: '테스트',
    gender: 'female',
    age: 25,
    mbti: 'ENFP',
    personality: '활발한',
    likes: 1500,
  );
  
  final testUserId = 'test-user';
  final service = RelationScoreService();
  final chatHistory = <Message>[];
  
  // Test 1: Mild negative behavior - should trigger upset state
  print('Test 1: Mild negative behavior (upset state)');
  print('User message: "짜증나네"');
  
  final result1 = service.calculateLike(
    emotion: EmotionType.neutral,
    userMessage: '짜증나네',
    persona: testPersona,
    currentLikes: testPersona.likes,
    userId: testUserId,
    chatHistory: chatHistory,
  );
  
  print('Result: ${result1.reason}');
  print('Like change: ${result1.likeChange}');
  print('Emotional state: ${result1.emotionalState}');
  print('Current state: ${service.getEmotionalState(testUserId, testPersona.id)}\n');
  
  // Test 2: Check state info
  print('Test 2: Check emotional state info');
  final stateInfo = service.getEmotionalStateInfo(testUserId, testPersona.id);
  if (stateInfo != null) {
    print('State: ${stateInfo.state}');
    print('Started: ${stateInfo.startTime}');
    print('Recovery time: ${stateInfo.recoveryTime}');
  }
  print('');
  
  // Test 3: Apology - should recover emotional state
  print('Test 3: Apology (recovery)');
  print('User message: "미안해 내가 잘못했어"');
  
  final result2 = service.calculateLike(
    emotion: EmotionType.neutral,
    userMessage: '미안해 내가 잘못했어',
    persona: testPersona,
    currentLikes: testPersona.likes,
    userId: testUserId,
    chatHistory: chatHistory,
  );
  
  print('Result: ${result2.reason}');
  print('Like change: ${result2.likeChange}');
  print('Emotional state: ${result2.emotionalState}');
  print('Current state: ${service.getEmotionalState(testUserId, testPersona.id)}\n');
  
  // Test 4: Severe negative behavior - should trigger hurt state
  print('Test 4: Severe negative behavior (hurt state)');
  print('User message: "진짜 짜증나 꺼져"');
  
  final result3 = service.calculateLike(
    emotion: EmotionType.neutral,
    userMessage: '진짜 짜증나 꺼져',
    persona: testPersona,
    currentLikes: testPersona.likes,
    userId: testUserId,
    chatHistory: chatHistory,
  );
  
  print('Result: ${result3.reason}');
  print('Like change: ${result3.likeChange}');
  print('Warning: ${result3.isWarning}');
  print('Emotional state: ${result3.emotionalState}');
  
  final stateInfo2 = service.getEmotionalStateInfo(testUserId, testPersona.id);
  if (stateInfo2 != null) {
    print('Recovery needed until: ${stateInfo2.recoveryTime}');
  }
  
  print('\n=== Test Complete ===');
}