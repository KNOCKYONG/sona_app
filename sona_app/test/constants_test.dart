import 'package:flutter_test/flutter_test.dart';
import 'package:sona_app/core/constants/korean_slang_dictionary.dart';
import 'package:sona_app/core/constants/mbti_constants.dart';
import 'package:sona_app/core/constants/conversation_constants.dart';
import 'package:sona_app/core/constants/prompt_templates.dart';

void main() {
  group('중앙화된 상수 테스트', () {
    test('KoreanSlangDictionary 테스트', () {
      // 줄임말 사전이 제대로 로드되는지 확인
      expect(KoreanSlangDictionary.slangPrompt.isNotEmpty, true);
      expect(KoreanSlangDictionary.slangToMeaning.isNotEmpty, true);
      
      // 특정 줄임말 확인
      expect(KoreanSlangDictionary.isSlang('저메추'), true);
      expect(KoreanSlangDictionary.getMeaning('저메추'), '저녁 메뉴 추천');
      expect(KoreanSlangDictionary.isSlang('존맛'), true);
    });

    test('MBTIConstants 테스트', () {
      // MBTI 특성 확인
      expect(MBTIConstants.getTrait('ENFP'), contains('열정'));
      expect(MBTIConstants.getCompressedTrait('INTJ'), contains('분석'));
      
      // 응답 길이 확인
      final enfpLength = MBTIConstants.getResponseLength('ENFP');
      expect(enfpLength.min, 25);
      expect(enfpLength.max, 60);
      
      // MBTI 차원 분석
      final dimensions = MBTIConstants.analyzeDimensions('ENFP');
      expect(dimensions.isExtroverted, true);
      expect(dimensions.isIntuitive, true);
      expect(dimensions.isFeeling, true);
      expect(dimensions.isPerceiving, true);
    });

    test('ConversationConstants 테스트', () {
      // 질문 응답 템플릿
      expect(ConversationConstants.questionResponses.isNotEmpty, true);
      expect(ConversationConstants.questionResponses['what_doing']!.isNotEmpty, true);
      
      // 감정 표현
      expect(ConversationConstants.empathyResponses['happy']!.isNotEmpty, true);
      
      // 감정 감지
      expect(ConversationConstants.detectEmotion('너무 행복해!'), 'happy');
      expect(ConversationConstants.detectEmotion('진짜 슬퍼'), 'sad');
      
      // 시간대 감지
      final timeOfDay = ConversationConstants.getTimeOfDay();
      expect(['morning', 'afternoon', 'evening', 'night'].contains(timeOfDay), true);
      
      // 인사말 가져오기
      final greeting = ConversationConstants.getGreeting();
      expect(greeting.isNotEmpty, true);
    });

    test('PromptTemplates 테스트', () {
      // 프롬프트 템플릿 확인
      expect(PromptTemplates.chattingStyle.isNotEmpty, true);
      expect(PromptTemplates.directAnswerRules.contains('넌?'), true);
      
      // 성별 스타일
      expect(PromptTemplates.getGenderStyle('male'), contains('남성'));
      expect(PromptTemplates.getGenderStyle('female'), contains('여성'));
      
      // 핵심 프롬프트 빌드
      final corePrompt = PromptTemplates.buildCorePrompt();
      expect(corePrompt.contains('SONA'), true);
      expect(corePrompt.contains('넌?'), true);
      
      // 특정 섹션 가져오기
      expect(PromptTemplates.getSection('chatting').isNotEmpty, true);
      expect(PromptTemplates.getSection('emotion').contains('기쁨'), true);
    });

    test('상수들 간의 통합 테스트', () {
      // 모든 중앙화된 상수들이 제대로 작동하는지 확인
      
      // 줄임말과 대화 패턴 통합
      final slang = '존맛';
      expect(KoreanSlangDictionary.isSlang(slang), true);
      
      // MBTI와 프롬프트 통합
      final mbti = 'ENFP';
      final trait = MBTIConstants.getTrait(mbti);
      expect(trait.isNotEmpty, true);
      
      // 대화 상수와 감정 통합
      final emotion = ConversationConstants.detectEmotion('개행복해!');
      expect(emotion, 'happy');
      final empathy = ConversationConstants.getEmpathyResponse(emotion);
      expect(empathy?.isNotEmpty, true);
    });
  });
}