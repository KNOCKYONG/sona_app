import 'package:flutter_test/flutter_test.dart';
import 'package:sona_app/services/chat/core/unified_conversation_system.dart';
import 'package:sona_app/services/chat/core/conversation_state_manager.dart';
import 'package:sona_app/models/message.dart';
import 'package:sona_app/models/persona.dart';

void main() {
  group('UnifiedConversationSystem 통합 테스트', () {
    late UnifiedConversationSystem unifiedSystem;
    late Persona testPersona;
    
    setUp(() {
      unifiedSystem = UnifiedConversationSystem.instance;
      
      // 테스트용 페르소나 생성
      testPersona = Persona(
        id: 'test_persona',
        name: '테스트',
        age: 23,
        description: '밝고 긍정적인 대학생',
        photoUrls: ['test.jpg'],
        personality: '밝고 긍정적',
        likes: 50,
        gender: 'female',
        mbti: 'ENFP',
      );
    });
    
    test('대화 세션 생성 및 복원', () async {
      final conversationId = 'test_conv_001';
      final userId = 'test_user_001';
      
      // 첫 번째 세션 생성
      final session1 = await unifiedSystem.getOrCreateSession(
        conversationId: conversationId,
        userId: userId,
        personaId: testPersona.id,
        persona: testPersona,
      );
      
      expect(session1, isNotNull);
      expect(session1.conversationId, equals(conversationId));
      expect(session1.userId, equals(userId));
      
      // 같은 ID로 세션 복원
      final session2 = await unifiedSystem.getOrCreateSession(
        conversationId: conversationId,
        userId: userId,
        personaId: testPersona.id,
        persona: testPersona,
      );
      
      // 같은 세션이어야 함
      expect(identical(session1, session2), isTrue);
    });
    
    test('통합 컨텍스트 구성', () async {
      final conversationId = 'test_conv_002';
      final userId = 'test_user_002';
      
      // 테스트 메시지 히스토리 생성
      final chatHistory = [
        Message(
          id: '1',
          personaId: testPersona.id,
          content: '안녕하세요!',
          type: MessageType.text,
          isFromUser: true,
          timestamp: DateTime.now().subtract(Duration(minutes: 10)),
        ),
        Message(
          id: '2',
          personaId: testPersona.id,
          content: '안녕! 반가워 😊',
          type: MessageType.text,
          isFromUser: false,
          timestamp: DateTime.now().subtract(Duration(minutes: 9)),
          emotion: EmotionType.happy,
        ),
        Message(
          id: '3',
          personaId: testPersona.id,
          content: '오늘 날씨가 좋네요',
          type: MessageType.text,
          isFromUser: true,
          timestamp: DateTime.now().subtract(Duration(minutes: 5)),
        ),
      ];
      
      // 통합 컨텍스트 구성
      final context = await unifiedSystem.buildUnifiedContext(
        conversationId: conversationId,
        userId: userId,
        personaId: testPersona.id,
        userMessage: '뭐 하고 있어?',
        fullHistory: chatHistory,
        persona: testPersona,
      );
      
      // 컨텍스트 검증
      expect(context, isNotNull);
      expect(context['conversationId'], equals(conversationId));
      expect(context['state'], isNotNull);
      expect(context['optimizedMessages'], isNotNull);
      expect(context['memories'], isNotNull);
      expect(context['continuity'], isNotNull);
      expect(context['contextQuality'], isNotNull);
      
      // 컨텍스트 품질 확인
      final quality = context['contextQuality'] as double;
      expect(quality, greaterThan(0.0));
      expect(quality, lessThanOrEqualTo(1.0));
    });
    
    test('대화 상태 업데이트', () async {
      final conversationId = 'test_conv_003';
      final userId = 'test_user_003';
      
      // 초기 세션 생성
      await unifiedSystem.getOrCreateSession(
        conversationId: conversationId,
        userId: userId,
        personaId: testPersona.id,
        persona: testPersona,
      );
      
      // 사용자 메시지
      final userMessage = Message(
        id: 'msg_001',
        personaId: testPersona.id,
        content: '오늘 저녁 뭐 먹을까?',
        type: MessageType.text,
        isFromUser: true,
        timestamp: DateTime.now(),
      );
      
      // AI 응답
      final aiResponse = Message(
        id: 'msg_002',
        personaId: testPersona.id,
        content: '피자 어때? 오늘같은 날엔 피자가 최고지!',
        type: MessageType.text,
        isFromUser: false,
        timestamp: DateTime.now(),
        emotion: EmotionType.excited,
        likesChange: 5,
      );
      
      // 상태 업데이트
      await unifiedSystem.updateConversationState(
        conversationId: conversationId,
        userId: userId,
        personaId: testPersona.id,
        userMessage: userMessage,
        aiResponse: aiResponse,
        fullHistory: [userMessage, aiResponse],
      );
      
      // ConversationStateManager에서 상태 확인
      final state = ConversationStateManager.getOrCreateState(
        conversationId: conversationId,
        userId: userId,
        personaId: testPersona.id,
      );
      
      expect(state.messageCount, greaterThan(0));
      expect(state.topics, contains('음식'));
    });
    
    test('시스템 상태 리포트', () {
      final status = unifiedSystem.getSystemStatus();
      
      expect(status, isNotNull);
      expect(status['activeSessions'], isNotNull);
      expect(status['memoryUsage'], isNotNull);
      expect(status['contextQuality'], isNotNull);
    });
    
    test('세션 정리', () async {
      // 여러 세션 생성
      for (int i = 0; i < 5; i++) {
        await unifiedSystem.getOrCreateSession(
          conversationId: 'test_conv_cleanup_$i',
          userId: 'test_user_cleanup',
          personaId: testPersona.id,
          persona: testPersona,
        );
      }
      
      final statusBefore = unifiedSystem.getSystemStatus();
      expect(statusBefore['activeSessions'], greaterThan(0));
      
      // 세션 정리 (24시간 이상 미사용 세션만 정리되므로 테스트에서는 변화 없음)
      unifiedSystem.cleanupSessions();
      
      final statusAfter = unifiedSystem.getSystemStatus();
      // 방금 생성한 세션들은 정리되지 않아야 함
      expect(statusAfter['activeSessions'], equals(statusBefore['activeSessions']));
    });
    
    test('대화 컨텍스트 연속성', () async {
      final conversationId = 'test_conv_continuity';
      final userId = 'test_user_continuity';
      
      // 첫 번째 대화
      final context1 = await unifiedSystem.buildUnifiedContext(
        conversationId: conversationId,
        userId: userId,
        personaId: testPersona.id,
        userMessage: '나 25살이야',
        fullHistory: [],
        persona: testPersona,
      );
      
      // 사용자 정보 업데이트
      await unifiedSystem.updateConversationState(
        conversationId: conversationId,
        userId: userId,
        personaId: testPersona.id,
        userMessage: Message(
          id: '1',
          personaId: testPersona.id,
          content: '나 25살이야',
          type: MessageType.text,
          isFromUser: true,
          timestamp: DateTime.now(),
        ),
        aiResponse: Message(
          id: '2',
          personaId: testPersona.id,
          content: '오 나랑 비슷하네! 나는 23살이야',
          type: MessageType.text,
          isFromUser: false,
          timestamp: DateTime.now(),
        ),
        fullHistory: [],
      );
      
      // 두 번째 대화 - 이전 정보 유지 확인
      final context2 = await unifiedSystem.buildUnifiedContext(
        conversationId: conversationId,
        userId: userId,
        personaId: testPersona.id,
        userMessage: '우리 나이 차이가 얼마나 나지?',
        fullHistory: [
          Message(
            id: '1',
            personaId: testPersona.id,
            content: '나 25살이야',
            type: MessageType.text,
            isFromUser: true,
            timestamp: DateTime.now().subtract(Duration(minutes: 1)),
          ),
          Message(
            id: '2',
            personaId: testPersona.id,
            content: '오 나랑 비슷하네! 나는 23살이야',
            type: MessageType.text,
            isFromUser: false,
            timestamp: DateTime.now().subtract(Duration(seconds: 30)),
          ),
        ],
        persona: testPersona,
      );
      
      // 이전 대화 내용이 컨텍스트에 포함되어야 함
      final optimizedMessages = context2['optimizedMessages'] as List;
      expect(optimizedMessages, isNotEmpty);
      
      // 상태 요약에 정보가 포함되어야 함
      final stateSummary = context2['state']['summary'] as String;
      expect(stateSummary, contains('메시지'));
    });
  });
}