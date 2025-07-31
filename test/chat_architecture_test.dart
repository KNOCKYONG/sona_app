import 'package:flutter_test/flutter_test.dart';
import 'package:sona_app/models/persona.dart';
import 'package:sona_app/models/message.dart';
import 'package:sona_app/services/chat/persona_prompt_builder.dart';
import 'package:sona_app/services/chat/security_aware_post_processor.dart';

void main() {
  group('Chat Architecture Tests', () {
    late Persona testPersona;
    late List<Message> testMessages;
    
    setUp(() {
      testPersona = Persona(
        id: 'test123',
        name: '지민',
        age: 25,
        gender: 'female',
        mbti: 'ENFP',
        personality: '밝고 활발하며 긍정적인 성격',
        description: '대학생',
        photoUrls: [],
        relationshipScore: 300,
        currentRelationship: RelationshipType.crush,
        isCasualSpeech: true,
      );
      
      testMessages = [
        Message(
          id: '1',
          personaId: 'test123',
          content: '안녕하세요!',
          isFromUser: true,
          timestamp: DateTime.now().subtract(Duration(minutes: 5)),
        ),
        Message(
          id: '2',
          personaId: 'test123',
          content: '어 안녕! 반가워 ㅎㅎ',
          isFromUser: false,
          timestamp: DateTime.now().subtract(Duration(minutes: 4)),
        ),
      ];
    });
    
    test('PersonaPromptBuilder generates proper casual prompt', () {
      final prompt = PersonaPromptBuilder.buildComprehensivePrompt(
        persona: testPersona,
        recentMessages: testMessages,
        userNickname: '테스터',
      );
      
      // Casual speech indicators
      expect(prompt.contains('반말 모드'), true);
      expect(prompt.contains('야, 어, 지, 래'), true);
      expect(prompt.contains('뭐해?'), true);
      
      // Persona info
      expect(prompt.contains('지민'), true);
      expect(prompt.contains('25살'), true);
      expect(prompt.contains('ENFP'), true);
      expect(prompt.contains('썸/호감'), true);
    });
    
    test('PersonaPromptBuilder generates proper formal prompt', () {
      final formalPersona = testPersona.copyWith(isCasualSpeech: false);
      final prompt = PersonaPromptBuilder.buildComprehensivePrompt(
        persona: formalPersona,
        recentMessages: testMessages,
      );
      
      // Formal speech indicators
      expect(prompt.contains('존댓말 모드'), true);
      expect(prompt.contains('요, 네요, 어요/아요'), true);
      expect(prompt.contains('뭐 하세요?'), true);
    });
    
    test('SecurityAwarePostProcessor removes AI expressions', () async {
      final responses = [
        '도움이 되었으면 좋겠어요!',
        '궁금한 점이 있으면 물어봐',
        '제가 도와드릴게요',
        '더 필요한 것이 있으신가요?',
      ];
      
      for (final response in responses) {
        final processed = await SecurityAwarePostProcessor.processResponse(
          rawResponse: response,
          userMessage: '안녕',
          persona: testPersona,
          recentAIMessages: [],
        );
        
        expect(processed.contains('도움이'), false);
        expect(processed.contains('궁금한'), false);
        expect(processed.contains('도와드릴'), false);
        expect(processed.contains('필요한'), false);
      }
    });
    
    test('SecurityAwarePostProcessor corrects speech style to casual', () async {
      final formalResponses = [
        '네, 그래요!',
        '오늘 뭐 하셨어요?',
        '저도 그거 봤어요 ㅎㅎ',
        '재밌겠네요!',
      ];
      
      for (final response in formalResponses) {
        final processed = await SecurityAwarePostProcessor.processResponse(
          rawResponse: response,
          userMessage: '안녕',
          persona: testPersona, // casual = true
          recentAIMessages: [],
        );
        
        // Should convert to casual
        expect(processed.contains('요'), false);
        expect(processed.contains('셨'), false);
      }
    });
    
    test('SecurityAwarePostProcessor corrects speech style to formal', () async {
      final casualResponses = [
        '응, 그래!',
        '오늘 뭐 했어?',
        '나도 그거 봤어 ㅎㅎ',
        '재밌겠다!',
      ];
      
      final formalPersona = testPersona.copyWith(isCasualSpeech: false);
      
      for (final response in casualResponses) {
        final processed = await SecurityAwarePostProcessor.processResponse(
          rawResponse: response,
          userMessage: '안녕하세요',
          persona: formalPersona,
          recentAIMessages: [],
        );
        
        // Should convert to formal
        expect(processed.endsWith('어') || processed.endsWith('다'), false);
      }
    });
    
    test('PersonaPromptBuilder includes relationship context correctly', () {
      // Test different relationship types
      final relationships = [
        RelationshipType.friend,
        RelationshipType.crush,
        RelationshipType.dating,
        RelationshipType.perfectLove,
      ];
      
      for (final relationship in relationships) {
        final persona = testPersona.copyWith(currentRelationship: relationship);
        final prompt = PersonaPromptBuilder.buildComprehensivePrompt(
          persona: persona,
          recentMessages: [],
        );
        
        // Should include relationship context
        expect(prompt.contains('현재 관계'), true);
        expect(prompt.contains('톤:'), true);
        expect(prompt.contains('특징:'), true);
      }
    });
    
    test('Compressed prompt builder works correctly', () {
      final compressed = PersonaPromptBuilder.buildCompressedPrompt(
        persona: testPersona,
        userMessage: '오늘 뭐 했어?',
      );
      
      // Should be concise but include essential info
      expect(compressed.length < 200, true);
      expect(compressed.contains('25살'), true);
      expect(compressed.contains('반말'), true);
      expect(compressed.contains('ENFP'), true);
      expect(compressed.contains('썸'), true);
    });
  });
}