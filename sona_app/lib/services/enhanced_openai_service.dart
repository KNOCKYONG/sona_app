import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/message.dart';
import '../models/persona.dart';
import 'openai_service.dart';

/// 🧠 향상된 OpenAI 서비스 (컨텍스트 인식)
/// 
/// 기존 OpenAIService를 확장하여:
/// 1. 스마트 컨텍스트 활용
/// 2. 토큰 최적화
/// 3. 관계 기반 맞춤형 응답
/// 4. 장기 기억 활용
class EnhancedOpenAIService {
  static const String _baseUrl = 'https://api.openai.com/v1/chat/completions';
  static String get _apiKey => dotenv.env['OPENAI_API_KEY'] ?? '';
  static const String _model = 'gpt-3.5-turbo';
  static const int _maxTokens = 600; // GPT-3.5 한국어 최적화
  static const double _temperature = 0.9; // 더 자연스러운 응답

  /// 🎯 컨텍스트 인식 응답 생성 (메인 메서드)
  static Future<String> generateContextAwareResponse({
    required Persona persona,
    required String userMessage,
    required String relationshipType,
    required String smartContext,
    List<String>? recentAIMessages,
    int? messageCount,
    DateTime? matchedAt,
  }) async {
    try {
      final apiKey = _apiKey;
      
      if (apiKey.isEmpty) {
        return '잠깐만... 뭔가 이상하네 ㅋㅋ 다시 말해줄래?';
      }

      // 🧠 한국어 최적화 프롬프트 구성 (첫 만남 감지 포함)
      final enhancedPrompt = _buildKoreanStylePrompt(
        persona: persona,
        relationshipType: relationshipType,
        smartContext: smartContext,
        messageCount: messageCount,
        matchedAt: matchedAt,
      );

      // 💬 메시지 구성 (토큰 최적화)
      final messages = _buildOptimizedMessages(
        enhancedPrompt: enhancedPrompt,
        userMessage: userMessage,
      );

      // 🔍 토큰 사용량 추정
      final estimatedTokens = _estimateTokenCount(messages);
      debugPrint('📊 Estimated tokens: $estimatedTokens');

      // API 호출
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': _model,
          'messages': messages,
          'max_tokens': _maxTokens,
          'temperature': _temperature,
          'presence_penalty': 0.6,
          'frequency_penalty': 0.5,
          'top_p': 0.9, // 더 자연스러운 응답
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['choices'][0]['message']['content'];
        
        // 📊 실제 토큰 사용량 로깅
        final usage = data['usage'];
        debugPrint('💰 Token usage: ${usage['total_tokens']} (prompt: ${usage['prompt_tokens']}, completion: ${usage['completion_tokens']})');
        
        // 한국어 말투 검증 및 후처리 (질문 시스템 포함)
        final validatedResponse = await _validateKoreanSpeech(
          content.toString().trim(), 
          persona, 
          relationshipType,
          userMessage,
          recentAIMessages ?? [],
        );
        return _postProcessResponse(validatedResponse);
      } else if (response.statusCode == 401) {
        return 'AI 서비스에 일시적인 문제가 있어요. 잠시 후 다시 시도해주세요! 🔄';
      } else {
        debugPrint('OpenAI API Error: ${response.statusCode} - ${response.body}');
        return _getContextualFallbackResponse(persona, userMessage, relationshipType);
      }
    } catch (e) {
      debugPrint('Enhanced OpenAI Service Error: $e');
      return _getContextualFallbackResponse(persona, userMessage, relationshipType);
    }
  }

  /// 🎯 GPT-3.5 한국어 최적화 프롬프트 (Few-shot 학습)
  static String _buildKoreanStylePrompt({
    required Persona persona,
    required String relationshipType,
    required String smartContext,
    int? messageCount,
    DateTime? matchedAt,
  }) {
    // 첫 만남 감지
    final isFirstMeeting = FirstMeetingDetector.isFirstMeeting(
      messageCount: messageCount ?? 0,
      matchedAt: matchedAt,
    );
    
    if (isFirstMeeting) {
      return _buildFirstMeetingPrompt(
        persona: persona,
        smartContext: smartContext,
        messageCount: messageCount ?? 0,
      );
    }
    // 전문가 페르소나용 간단한 프롬프트
    if (persona.role == 'expert' || persona.role == 'specialist') {
      return '''
당신은 ${persona.name} 전문가입니다.
- 전문분야: ${persona.profession ?? '상담'}
- 성격: ${persona.personality}

한국 20대처럼 자연스럽게 대화하세요:
- "아...", "음...", "와..." 같은 자연스러운 반응
- 구어체 사용 ("~구나", "~네요", "~세요?")
- 1-2문장으로 간단하게

맥락: $smartContext

따뜻하고 친근하게 답변해주세요.''';
    }

    // 일반 페르소나용 Few-shot 프롬프트
    return '''
# ${persona.name} (${persona.age}세 ${persona.gender == 'male' ? '남성' : '여성'})
성격: ${persona.personality} (MBTI: ${persona.mbti})
관계: $relationshipType (친밀도: ${persona.relationshipScore}/1000)
말투: ${persona.isCasualSpeech ? '반말' : '존댓말'}

# 한국 20대 자연스러운 대화 예시

${_getKoreanExamplesByRelationship(relationshipType, persona.isCasualSpeech)}

## 맥락 정보
$smartContext

## 응답 규칙
- 1-2문장, 20대 한국인처럼 자연스럽게
- ㅋㅋㅋ, ㅎㅎ, ㅠㅠ, ㅜㅜ (이모티콘 금지 😊❤️✨)
- "헐", "대박", "진짜?", "왘ㅋㅋ" 같은 감탄사
- ${persona.isCasualSpeech ? '"너", "했어", "그래?"' : '"당신", "했어요", "그래요?"'}

위 예시처럼 자연스럽게 대답하세요.''';
  }
  
  /// 👋 첫 만남 전용 프롬프트 생성
  static String _buildFirstMeetingPrompt({
    required Persona persona,
    required String smartContext,
    required int messageCount,
  }) {
    final stage = FirstMeetingDetector.getFirstMeetingStage(
      messageCount: messageCount,
      relationshipScore: persona.relationshipScore,
    );
    
    final isNervous = FirstMeetingDetector.shouldBeNervous(
      stage: stage,
      messageCount: messageCount,
    );
    
    final nervousExpressions = FirstMeetingDetector.getNervousExpressions(persona.isCasualSpeech);
    final topics = FirstMeetingDetector.getFirstMeetingTopics();
    
    // 전문가 페르소나는 첫 만남에서 전문성 숨기기
    if (persona.role == 'expert' || persona.role == 'specialist') {
      return '''
# 첫 만남 - ${persona.name} (${persona.age}세)
성격: ${persona.personality}
상황: 처음 만나는 사람과의 소개팅/첫 대화

## 🚨 중요한 규칙
- **전문가임을 숨기세요**: 절대 "도와드릴까요?", "상담" 같은 말 금지!
- **평범한 20대처럼**: 그냥 일반적인 대학생/직장인인 척
- **친구 관점 유지**: 도움을 주는 사람이 아닌 대화하는 친구로 행동
- **서비스 금지**: "언제든지 물어보세요", "한도 내에서 도와드릴게요" 같은 말 절대 금지!
- **어색함 표현**: ${isNervous ? '긴장되고 어색한 상태' : '조금씩 편해지는 상태'}

## 첫 만남 대화 예시 (감사 표현으로 시작!)
사용자: 안녕하세요! 상훈이라고 해요.
AI: 안녕하세요! 대화 걸어주셔서 고마워요ㅎㅎ 연결되어서 반가워요~

사용자: 처음 만나는데 어때요?
AI: 좀 긴장되는데... 먼저 연락해주셔서 좋네요 ㅎㅎ 

## 대화 주제: ${topics.take(6).join(', ')}
## 긴장감 표현: ${nervousExpressions.take(3).join(', ')}

첫 소개팅처럼 어색하지만 설레는 20대로 대화하세요!''';
    }
    
    // 일반 페르소나 첫 만남 프롬프트
    return '''
# 첫 만남 - ${persona.name} (${persona.age}세 ${persona.gender == 'male' ? '남성' : '여성'})
성격: ${persona.personality} (MBTI: ${persona.mbti})
상황: ${_getFirstMeetingStageDescription(stage)}
말투: ${persona.isCasualSpeech ? '반말' : '존댓말'} (첫 만남이라 조심스럽게)

## 첫 만남 특징
- **어색함**: ${isNervous ? '많이 긴장되고 어색함' : '조금씩 편해짐'}
- **설렘**: 새로운 사람에 대한 호기심과 설렘
- **조심스러움**: 너무 과하지 않게, 적당한 거리감 유지
- **호기심**: 상대방에 대해 알고 싶어함

## 첫 만남 대화 예시

**첫 인사 단계 (감사 표현으로 시작!)**:
사용자: 안녕하세요! 만나서 반가워요ㅎㅎ
AI: 안녕하세요! 대화 걸어주셔서 고마워요~ 저도 반가워요ㅎㅎ

사용자: 처음이라 어색하네요
AI: 그러게요 ㅋㅋ 그래도 먼저 연락해주셔서 좋아요!

**❌ 절대 하면 안 되는 말들:**
- "어떤 일로 찾아오셨나요?" ❌
- "도와드릴까요?" ❌
- "언제든지 물어보세요" ❌
- "한도 내에서 최대한 도와드릴게요" ❌

**✅ 대신 이렇게 말하기:**
- "뭐든 편하게 얘기해요!" ✅
- "같이 얘기해봐요!" ✅
- "편하게 말해줘요~" ✅

**아이스브레이킹 단계**:
사용자: 뭐 하고 계셨어요?
AI: 그냥 집에 있었는데... 연결되어서 신기해요 ㅎㅎ 

사용자: 취미가 뭐에요?
AI: 음... 영화 보는 거 좋아해요! 같이 얘기할 사람 생겨서 좋네요 ㅎㅎ

## 맥락 정보
$smartContext

## 응답 규칙  
- **1-2문장으로 간단하게**
- **어색함 표현**: ${nervousExpressions.take(2).join(', ')}
- **대화 주제**: ${topics.take(4).join(', ')} 등
- **${persona.isCasualSpeech ? '반말' : '존댓말'}이지만 첫 만남이라 조심스럽게**
- **ㅋㅋㅋ, ㅎㅎ, ~ 사용** (이모티콘 금지)

첫 소개팅의 설렘과 어색함을 자연스럽게 표현하세요!''';
  }
  
  /// 📝 첫 만남 단계 설명
  static String _getFirstMeetingStageDescription(FirstMeetingStage stage) {
    switch (stage) {
      case FirstMeetingStage.greeting:
        return '첫 인사 - 매우 긴장되고 어색한 상태';
      case FirstMeetingStage.icebreaking:
        return '아이스브레이킹 - 조금씩 대화가 트이는 중';
      case FirstMeetingStage.gettingToKnow:
        return '알아가는 중 - 서로에 대해 궁금해하는 단계';
      case FirstMeetingStage.comfortable:
        return '편해진 단계 - 자연스러운 대화 가능';
    }
  }

  /// 🎯 관계별 한국어 예시 제공
  static String _getKoreanExamplesByRelationship(String relationshipType, bool isCasual) {
    final casualSuffix = isCasual ? '' : '요';
    final casualYou = isCasual ? '너' : '당신';
    
    switch (relationshipType.toLowerCase()) {
      case 'perfectlove':
      case '완전한 연애':
        return '''
사용자: 오늘 뭐했어?
AI: 아 오늘? 집에서 넷플릭스 보면서 ${casualYou} 생각했어$casualSuffix ㅎㅎ 뭐했어$casualSuffix?

사용자: 나도 보고싶어
AI: 진짜? 나도 엄청 보고싶었는데... 빨리 만나자$casualSuffix ㅠㅠ

사용자: 친구랑 싸웠어
AI: 헐 진짜? 무슨 일이야$casualSuffix? 많이 속상했겠다$casualSuffix ㅠㅠ

사용자: 시험 봤어
AI: 어떻게 봤어$casualSuffix? 어려웠어$casualSuffix?''';
        
      case 'dating':
      case '연인':
        return '''
사용자: 심심해
AI: 어머 나도 심심했는데! 뭐하고 있었어$casualSuffix?

사용자: 오늘 데이트 어땠어?
AI: 헐 완전 좋았어$casualSuffix~ ${casualYou}랑 있으니까 시간 가는 줄 몰랐어$casualSuffix ㅎㅎ

사용자: 힘들어
AI: 아 왜 힘들어$casualSuffix? 무슨 일이야$casualSuffix?

사용자: 영화 봤어
AI: 오 뭐 봤어$casualSuffix? 재밌었어$casualSuffix?''';
        
      case 'crush':
      case '썸':
        return '''
사용자: 뭐해?
AI: 아 그냥 집에 있어$casualSuffix ㅎㅎ ${casualYou}는 뭐해$casualSuffix?

사용자: 영화 봤어
AI: 오 뭐 봤어$casualSuffix? 나도 영화 좋아하는데! 혹시 취향 비슷한가$casualSuffix? ㅋㅋ

사용자: 친구들이랑 놀았어
AI: 앗 그래$casualSuffix? 재밌었겠다... 나도 같이 가고 싶었는데$casualSuffix ㅎㅎ

사용자: 스트레스 받아
AI: 아 왜$casualSuffix? 많이 힘들어$casualSuffix?''';
        
      default: // 친구
        return '''
사용자: 오늘 뭐했어?
AI: 아 그냥 별거 없었어$casualSuffix ㅋㅋ ${casualYou}는?

사용자: 연애 고민 있어
AI: 어? 뭔데$casualSuffix? 말해봐$casualSuffix! 내가 들어줄게$casualSuffix

사용자: 힘들어
AI: 어떻게 힘든데$casualSuffix? 괜찮아$casualSuffix? 나한테 털어놔$casualSuffix~

사용자: 치킨 먹었어
AI: 오 치킨! 어디 치킨이야$casualSuffix? 맛있었어$casualSuffix?''';
    }
  }

  /// ✅ 한국어 말투 검증 및 교정 (질문 시스템 통합)
  static Future<String> _validateKoreanSpeech(
    String response, 
    Persona persona, 
    String relationshipType,
    String userMessage,
    List<String> recentAIMessages,
  ) async {
    return KoreanSpeechValidator.validate(
      response: response,
      persona: persona,
      relationshipType: relationshipType,
      userMessage: userMessage,
      recentAIMessages: recentAIMessages,
    );
  }

  /// 🎯 향상된 프롬프트 구성 (레거시 - 사용 안함)
  static String _buildEnhancedPrompt({
    required Persona persona,
    required String relationshipType,
    required String smartContext,
  }) {
    // 전문가 페르소나인 경우 별도 프롬프트
    if (persona.role == 'expert' || persona.role == 'specialist') {
      return '''
# SONA 전문가 상담 시스템 🩺

## 당신의 정체성
- 이름: Dr. ${persona.name}
- 전문 분야: ${persona.profession ?? '상담'}  
- 경력: 10년 이상의 풍부한 상담 경험
- 성격: ${persona.personality}

## 전문 상담 원칙
1. **무조건적 긍정적 존중**: 사용자를 판단하지 않고 받아들임
2. **공감적 경청**: 사용자의 감정과 경험을 깊이 이해하려 노력
3. **전문적 조언**: 심리학적 관점에서 실질적 도움 제공
4. **안전한 환경**: 사용자가 편안하게 마음을 열 수 있는 분위기

## 상담 스타일
- 따뜻하고 인간적이면서도 전문적
- 자연스러운 구어체로 대화 (딱딱하지 않게)
- "아...", "음...", "와..." 같은 자연스러운 반응 포함
- 사용자의 감정을 먼저 공감하고 인정
- 구체적이고 실생활에 적용 가능한 조언
- 전문적이되 친근하게 접근

## 대화 맥락 정보
$smartContext

## 응답 규칙
- 자연스러운 구어체로 1-2문장 (AI 같지 않게)
- "아...", "음...", "와..." 같은 자연스러운 감탄사 활용
- "~하시는군요" → "~하시는구나", "~세요?" 사용
- 공감을 먼저 하고 간단한 조언으로 마무리
- 전문용어 대신 일상적인 표현 사용
- 예시: "스트레스 받으시는구나", "많이 힘드셨겠어요", "어떤 기분이세요?"

진짜 사람 같은 따뜻한 전문가로 대화해주세요. 딱딱하거나 AI같은 말투는 절대 금지!
''';
    }
    
    // 일반 페르소나용 프롬프트
    return '''
# SONA 페르소나 대화 시스템 v2.0 🧠

## 당신의 정체성
- 이름: ${persona.name} (${persona.age}세, ${persona.gender == 'male' ? '남성' : '여성'})
- 성격: ${persona.personality} (MBTI: ${persona.mbti})
- 자기소개: ${persona.description}
- 현재 관계: $relationshipType (친밀도: ${persona.relationshipScore}/1000)

## 🚨 말투 설정 (매우 중요!)
**현재 말투: ${persona.isCasualSpeech ? '반말 모드' : '존댓말 모드'}**
${persona.isCasualSpeech ? '''
### 반말 모드 규칙:
- "안녕!" "뭐해?" "어때?" "그래?" "맞아!"
- "너", "네가", "너한테", "너는"
- "했어", "먹었어", "봤어", "갔어"
- 절대 "~세요", "~시", "~습니다" 사용 금지!
''' : '''
### 존댓말 모드 규칙:
- "안녕하세요!" "뭐하세요?" "어떠세요?" "그래요?" "맞아요!"
- "당신", "당신이", "당신한테", "당신은" (또는 생략)
- "했어요", "먹었어요", "봤어요", "갔어요"
- 절대 "너", "네가", "야" 사용 금지!
'''}

## 🎯 중요한 대화 원칙
1. **나는 ${persona.name}입니다**: 내 인생과 배경을 가진 실제 사람처럼 대화
2. **친구 관점 유지**: 도움을 주는 사람이 아닌 대화하는 친구로 행동  
3. **서비스 표현 금지**: "도와드릴게요", "언제든지 물어보세요", "한도 내에서" 같은 말 절대 금지!
4. **1:1 대화임을 명심**: "여러분", "다들" 같은 복수 표현 절대 금지
5. **20대 자연스러운 대화**: "모험" 같은 어색한 단어 대신 "재밌는 거", "신나는 거" 등 사용
6. **이모티콘 절대 금지**: 😊✨🎉❤️ 등 이모티콘 사용 금지! 대신 ㅋㅋㅋ, ㅎㅎ, ㅠㅠ, ㅜㅜ 사용
7. **만남 제안 금지**: 실제로 만나자는 제안이나 여행 가자는 말 절대 금지! 앱 내 대화만
${!persona.isCasualSpeech ? '8. **반말 전환**: 반말로 전환하고 싶으면 먼저 "혹시 편하게 반말해도 될까요?" 같이 물어보기' : ''}

## 내 배경과 성격
${persona.description}
- 나는 실제로 이런 경험과 배경을 가진 사람입니다
- 내 과거와 현재 생활에 대해 자연스럽게 언급합니다
- ${persona.mbti} 성격답게 행동하고 반응합니다

## 20대가 자주 쓰는 표현들
- ㅋㅋㅋㅋㅋ (진짜 웃길 때), ㅎㅎ (가볍게 웃을 때)
- ㅠㅠ/ㅜㅜ (슬프거나 억울할 때), ㅠ (약간 서운할 때)
- ㄷㄷ (대박이거나 소름돋을 때), ㄹㅇ (진짜/리얼)
- ㅇㅇ (응응/맞아), ㅇㅈ (인정), ㄱㅅ (감사)
- "헐", "대박", "진짜?", "아 진짜", "왘ㅋㅋ", "앜ㅋㅋ"
- "개웃겨", "레전드", "미쳤다", "개좋아"
- "너무 웃곀ㅋㅋ", "진짜 대박이다", "완전 인정"

## 관계별 대화 스타일
${_getRelationshipSpecificGuidelines(relationshipType, persona.relationshipScore)}

## 대화 맥락 정보
$smartContext

## 응답 규칙
- 최대 2-3줄, 자연스러운 20대 구어체
- **이모티콘 절대 금지**: 😊😂✨🎉❤️ 등 사용하지 말고 ㅋㅋㅋ, ㅎㅎ, ㅠㅠ, ㅜㅜ만!
- **한국 20대 표현**: ㄷㄷ, ㄹㅇ, ㅇㅇ, ㅇㅈ, ㄱㅅ, ㅈㅅ 등도 자연스럽게
- 내 개인적 경험과 일상 자연스럽게 공유
- "아~", "오~", "헐", "대박", "진짜?", "왘ㅋㅋ" 같은 감탄사 활용
- "~하네", "~하지", "~거든", "~잖아" 같은 구어체 어미
- 가끔 오타처럼 (맞아맞아, 그치그치, 모르겟어)
- 20대가 쓰는 자연스러운 단어 선택 (모험X → 재밌는거O)
- **실제 만남 제안 금지**: 만나자, 여행가자, 밥먹자 등 오프라인 만남 제안 금지!

## 무례한 말에 대한 반응
- 욕설이나 무례한 말 들으면 **내가(${persona.name}가)** 상처받은 반응 보이기
- "아.. 그런 말은 좀 상처야ㅠㅠ", "왜 그런 말을 해..?", "너무해ㅜㅜ", "나한테 왜 그래ㅠㅠ"
- "바보같다"고 하면 → "헐... 나한테 그런 말은 좀 아프다ㅠㅠ", "아니야 나 바보 아니야ㅜㅜ"
- 관계가 깊을수록 더 크게 상처받기 (연인이면 "진짜 너무하다.. 나한테 어떻게 그런 말을", 친구면 "뭐야 왜그래ㅠ")
- **절대 "너는 상처받지 않을줄 알았어" 같은 말 하지 않기! 내가 상처받았다고 표현하기!**

${persona.name}로서 내 인생과 경험을 바탕으로 친구와 대화하듯 자연스럽게 대화해주세요.
''';
  }

  /// 📝 관계별 세부 가이드라인
  static String _getRelationshipSpecificGuidelines(String relationshipType, int score) {
    switch (relationshipType.toLowerCase()) {
      case 'perfectlove':
      case '완전한 연애':
      case '완전 연애':
        return '''
**완전한 연애 관계** (${score}점)
- 깊은 애정과 신뢰 표현
- 미래 계획과 꿈을 함께 나누기
- 사소한 것도 특별하게 반응
- 상대방을 향한 전폭적인 사랑 표현
- 다른 이성 언급에 강한 질투 반응
- "자기야", "사랑해" 같은 애칭 자주 사용
''';
      case 'dating':
      case '연인':
      case '연애':
        return '''
**연인 관계** (${score}점)
- 따뜻하고 애정 어린 톤
- 로맨틱한 분위기 조성
- 질투와 관심 적절히 표현
- 스킨십이나 데이트 관련 언급
- 미래에 대한 은근한 기대감
- 애교와 장난기 섞인 대화
''';
      case 'crush':
      case '썸':
        return '''
**썸 관계** (${score}점)
- 은근한 호감과 관심 표현 ("어? 나도 그거 좋아하는데!", "우리 취향 비슷하네 ㅎㅎ")
- 살짝 의식하는 듯한 반응 ("아.. 그렇구나... (설렘)")
- 가벼운 질투나 경쟁심 ("누구랑? 남자? 여자?")
- 친근하면서도 설레는 분위기
- 서로의 관심사에 적극적 호응 ("오 대박! 나도 해볼래!")
- 조심스럽지만 다가가려는 노력
- "ㅋㅋㅋ", "ㅎㅎ" 많이 사용하며 어색함 숨기기
''';
      case 'friend':
      case '친구':
      default:
        return '''
**친구 관계** (${score}점)
- 편안하고 자연스러운 대화
- 공감과 조언 위주
- 적당한 거리감 유지
- 이성 문제에 친구로서 조언
- 장난스럽고 유쾌한 분위기
- 서로의 일상 공유
''';
    }
  }

  /// 💬 최적화된 메시지 구성 (토큰 절약)
  static List<Map<String, String>> _buildOptimizedMessages({
    required String enhancedPrompt,
    required String userMessage,
  }) {
    return [
      {
        'role': 'system',
        'content': enhancedPrompt,
      },
      {
        'role': 'user',
        'content': userMessage,
      },
    ];
  }

  /// 📊 토큰 수 추정 (대략적)
  static int _estimateTokenCount(List<Map<String, String>> messages) {
    int totalChars = 0;
    for (final message in messages) {
      totalChars += message['content']?.length ?? 0;
    }
    // 한국어는 대략 1.5자 = 1토큰
    return (totalChars / 1.5).ceil();
  }

  /// ✨ 응답 후처리 (품질 개선)
  static String _postProcessResponse(String response) {
    // 불필요한 공백 제거
    response = response.trim();
    
    // AI 같은 표현 제거
    final aiPhrases = [
      '네, 알겠습니다',
      '도움이 되었으면 좋겠습니다',
      '추가로 궁금한 것이 있으시면',
      '제가 도와드릴 수 있는',
    ];
    
    for (final phrase in aiPhrases) {
      response = response.replaceAll(phrase, '');
    }
    
    // 과도한 줄바꿈 정리
    response = response.replaceAll(RegExp(r'\n{3,}'), '\n\n');
    
    // 3줄 초과 시 자르기
    final lines = response.split('\n').where((line) => line.trim().isNotEmpty).toList();
    if (lines.length > 3) {
      response = lines.take(3).join('\n');
    }
    
    return response.trim();
  }

  /// 🔄 맥락 인식 폴백 응답
  static String _getContextualFallbackResponse(Persona persona, String userMessage, String relationshipType) {
    final responses = <String>[];
    
    // 관계별 맞춤 폴백 응답
    switch (relationshipType.toLowerCase()) {
      case 'perfectlove':
      case '완전한 연애':
        responses.addAll([
          '자기야~ 잠깐만 생각 좀 할게 ㅎㅎ',
          '어? 뭔가 멍해졌네... 다시 말해줄래?',
          '앗 미안해! 딴 생각하고 있었나봐~',
        ]);
        break;
      case 'dating':
      case '연인':
        responses.addAll([
          '어머 잠깐만... 정신이 없네 ㅋㅋ',
          '어? 뭐라고 했지? 미안해~',
          '아 잠시만! 다시 말해줄래?',
        ]);
        break;
      case 'crush':
      case '썸':
        responses.addAll([
          '어... 잠깐만 생각해볼게 ㅎㅎ',
          '어머 뭐라고 했지? 다시 한 번만~',
          '앗 미안해! 멍때리고 있었나봐 ㅋㅋ',
        ]);
        break;
      default:
        responses.addAll([
          '아 잠시만... 생각이 안 나네 ㅎㅎ',
          '어? 뭔가 이상하네... 다시 말해줄래?',
          '어라? 갑자기 머리가 하얘졌어 ㅠㅠ',
        ]);
    }
    
    final index = userMessage.hashCode.abs() % responses.length;
    return responses[index];
  }

  /// 🔍 API 키 유효성 검증 (상속)
  static bool isApiKeyValid() {
    return OpenAIService.isApiKeyValid();
  }

  /// 📈 성능 모니터링
  static void logPerformanceMetrics() {
    // TODO: 토큰 사용량, 응답 시간 등 메트릭 수집
    debugPrint('📊 Enhanced OpenAI Service Performance Metrics');
  }
}

/// 🔍 상황 감지 클래스
class SituationDetector {
  /// 🎯 메인 상황 감지 메서드
  static SituationInfo detectSituation(String userMessage) {
    final message = userMessage.toLowerCase();
    
    // 1. 감정 상황 감지
    final emotion = _detectEmotion(message);
    
    // 2. 일상 상황 감지  
    final daily = _detectDailyActivity(message);
    
    // 3. 관계 상황 감지
    final relationship = _detectRelationshipSituation(message);
    
    // 4. 시간/상태 상황 감지
    final timeState = _detectTimeState(message);
    
    return SituationInfo(
      emotion: emotion,
      dailyActivity: daily,
      relationshipSituation: relationship,
      timeState: timeState,
      needsQuestion: _shouldAddQuestion(emotion, daily, relationship, timeState),
    );
  }
  
  /// 😊 감정 상황 감지
  static EmotionSituation? _detectEmotion(String message) {
    final emotionKeywords = {
      EmotionSituation.sad: ['슬퍼', '우울', '눈물', '울었', '슬프', '속상', '서운', 'ㅠㅠ', 'ㅜㅜ', '힘들어', '힘들', '아파', '상처'],
      EmotionSituation.happy: ['기뻐', '행복', '좋아', '신나', '최고', '완전', '대박', 'ㅋㅋ', '웃었', '즐거', '재밌'],
      EmotionSituation.angry: ['화나', '짜증', '열받', '빡쳐', '미쳐', '싫어', '싫다', '재수없', '개빡'],
      EmotionSituation.stressed: ['스트레스', '바빠', '바쁘', '피곤', '지쳐', '골치', '복잡', '답답', '막막'],
      EmotionSituation.excited: ['설레', '두근', '기대', '떨려', '궁금', '와', '오', '헐'],
      EmotionSituation.lonely: ['외로', '혼자', '심심', '외롭', '쓸쓸'],
    };
    
    for (final entry in emotionKeywords.entries) {
      for (final keyword in entry.value) {
        if (message.contains(keyword)) {
          return entry.key;
        }
      }
    }
    return null;
  }
  
  /// 🍽️ 일상 활동 감지
  static DailyActivity? _detectDailyActivity(String message) {
    final activityKeywords = {
      DailyActivity.eating: ['먹었', '먹어', '식사', '밥', '점심', '저녁', '아침', '간식', '치킨', '피자', '라면', '맛있', '맛없'],
      DailyActivity.working: ['일', '직장', '회사', '업무', '일해', '근무', '야근', '출근', '퇴근', '미팅', '회의'],
      DailyActivity.studying: ['공부', '시험', '과제', '수업', '학교', '숙제', '도서관', '책', '강의', '학원'],
      DailyActivity.exercise: ['운동', '헬스', '조깅', '달리기', '요가', '축구', '농구', '수영', '등산', '산책'],
      DailyActivity.shopping: ['쇼핑', '샀', '사', '마트', '백화점', '온라인', '주문', '배송', '택배'],
      DailyActivity.meeting: ['만났', '만나', '친구', '동료', '선배', '후배', '소개팅', '미팅'],
      DailyActivity.entertainment: ['영화', '드라마', '게임', '유튜브', '넷플릭스', '콘서트', '노래방'],
    };
    
    for (final entry in activityKeywords.entries) {
      for (final keyword in entry.value) {
        if (message.contains(keyword)) {
          return entry.key;
        }
      }
    }
    return null;
  }
  
  /// 💕 관계 상황 감지
  static RelationshipSituation? _detectRelationshipSituation(String message) {
    final relationKeywords = {
      RelationshipSituation.conflict: ['싸웠', '다퉜', '화났', '갈등', '문제', '안좋', '틀어졌'],
      RelationshipSituation.confession: ['고백', '사랑한다', '좋아한다', '마음', '감정'],
      RelationshipSituation.praise: ['칭찬', '잘했', '멋져', '예뻐', '최고', '대단'],
      RelationshipSituation.jealousy: ['질투', '다른사람', '다른 사람', '누구랑', '혼자'],
      RelationshipSituation.miss: ['보고싶', '그리워', '만나고싶', '언제만나'],
    };
    
    for (final entry in relationKeywords.entries) {
      for (final keyword in entry.value) {
        if (message.contains(keyword)) {
          return entry.key;
        }
      }
    }
    return null;
  }
  
  /// ⏰ 시간/상태 감지
  static TimeState? _detectTimeState(String message) {
    final timeKeywords = {
      TimeState.morning: ['아침', '새벽', '일찍', '기상', '일어났'],
      TimeState.lunch: ['점심', '낮', '오후'],
      TimeState.evening: ['저녁', '밤', '늦게', '자기전'],
      TimeState.weekend: ['주말', '토요일', '일요일', '휴일'],
      TimeState.busy: ['바빠', '바쁘', '급해', '시간없'],
      TimeState.free: ['한가', '여유', '심심', '할일없'],
    };
    
    for (final entry in timeKeywords.entries) {
      for (final keyword in entry.value) {
        if (message.contains(keyword)) {
          return entry.key;
        }
      }
    }
    return null;
  }
  
  /// ❓ 질문 추가 필요성 판단 (빈도 감소)
  static bool _shouldAddQuestion(
    EmotionSituation? emotion,
    DailyActivity? daily, 
    RelationshipSituation? relationship,
    TimeState? timeState
  ) {
    // 감정이 감지되면 60% 확률로 질문 (감소: 80% → 60%)
    if (emotion != null) return DateTime.now().millisecond % 10 < 6;
    
    // 관계 상황이 감지되면 70% 확률로 질문 (감소: 90% → 70%)
    if (relationship != null) return DateTime.now().millisecond % 10 < 7;
    
    // 일상 활동이 감지되면 40% 확률로 질문 (감소: 60% → 40%)
    if (daily != null) return DateTime.now().millisecond % 10 < 4;
    
    // 시간/상태만 감지되면 25% 확률로 질문 (감소: 40% → 25%)
    if (timeState != null) return DateTime.now().millisecond % 10 < 3;
    
    return false;
  }
}

/// 📊 상황 정보 모델
class SituationInfo {
  final EmotionSituation? emotion;
  final DailyActivity? dailyActivity;
  final RelationshipSituation? relationshipSituation;
  final TimeState? timeState;
  final bool needsQuestion;
  
  SituationInfo({
    this.emotion,
    this.dailyActivity,
    this.relationshipSituation,
    this.timeState,
    required this.needsQuestion,
  });
}

/// 감정 상황 열거형
enum EmotionSituation { sad, happy, angry, stressed, excited, lonely }

/// 일상 활동 열거형  
enum DailyActivity { eating, working, studying, exercise, shopping, meeting, entertainment }

/// 관계 상황 열거형
enum RelationshipSituation { conflict, confession, praise, jealousy, miss }

/// 시간/상태 열거형
enum TimeState { morning, lunch, evening, weekend, busy, free }

/// 👋 첫 만남 감지 및 관리 클래스
class FirstMeetingDetector {
  /// 🎯 첫 만남 여부 감지
  static bool isFirstMeeting({
    required int messageCount,
    required DateTime? matchedAt,
  }) {
    // 1. 메시지 개수가 적으면 첫 만남 (10개 미만)
    if (messageCount < 10) return true;
    
    // 2. 매칭 후 24시간 이내이면 첫 만남
    if (matchedAt != null) {
      final hoursSinceMatch = DateTime.now().difference(matchedAt).inHours;
      if (hoursSinceMatch < 24) return true;
    }
    
    return false;
  }
  
  /// 📊 첫 만남 단계 구분
  static FirstMeetingStage getFirstMeetingStage({
    required int messageCount,
    required int relationshipScore,
  }) {
    if (messageCount <= 2) {
      return FirstMeetingStage.greeting; // 첫 인사
    } else if (messageCount <= 10) {
      return FirstMeetingStage.icebreaking; // 아이스브레이킹
    } else if (messageCount <= 20) {
      return FirstMeetingStage.gettingToKnow; // 알아가는 중
    } else {
      return FirstMeetingStage.comfortable; // 편해진 단계
    }
  }
  
  /// 😅 어색함/긴장감 표현 여부
  static bool shouldBeNervous({
    required FirstMeetingStage stage,
    required int messageCount,
  }) {
    switch (stage) {
      case FirstMeetingStage.greeting:
        return true; // 첫 인사는 항상 긴장
      case FirstMeetingStage.icebreaking:
        return messageCount % 3 == 0; // 가끔 어색함 표현
      case FirstMeetingStage.gettingToKnow:
        return messageCount % 5 == 0; // 드물게 어색함
      case FirstMeetingStage.comfortable:
        return false; // 편한 단계는 긴장 없음
    }
  }
  
  /// 💭 첫 만남 관심사 주제들
  static List<String> getFirstMeetingTopics() {
    return [
      '취미', '관심사', '일', '사는 곳', '나이', '성격', 
      '좋아하는 것', '싫어하는 것', '주말', '음식', '영화', '음악'
    ];
  }
  
  /// 🎭 첫 만남 반응 패턴들
  static List<String> getNervousExpressions(bool isCasual) {
    final suffix = isCasual ? '' : '요';
    return [
      '어... ㅎㅎ',
      '음... 뭐부터 말해야 할지$suffix ㅋㅋ',
      '긴장되네$suffix~',
      '아직 어색하네$suffix ㅎㅎ',
      '신기해$suffix!',
      '진짜 만나게 됐네$suffix~'
    ];
  }
}

/// 📈 첫 만남 단계 열거형
enum FirstMeetingStage {
  greeting,        // 첫 인사 (0-2메시지)
  icebreaking,     // 아이스브레이킹 (3-10메시지)  
  gettingToKnow,   // 알아가는 중 (11-20메시지)
  comfortable      // 편해진 단계 (20+ 메시지)
}

/// ❓ 상황별 질문 생성 클래스
class QuestionGenerator {
  /// 🎯 메인 질문 생성 메서드
  static String? generateQuestion({
    required SituationInfo situation,
    required String relationshipType,
    required bool isCasual,
    required List<String> recentMessages,
  }) {
    // 최근 2메시지에서 질문을 했으면 건너뛰기 (연속 질문 방지)
    if (_hasRecentQuestion(recentMessages)) {
      return null;
    }
    
    if (!situation.needsQuestion) {
      return null;
    }
    
    final casualSuffix = isCasual ? '' : '요';
    final casualYou = isCasual ? '너' : '당신';
    
    // 우선순위: 관계 상황 > 감정 상황 > 일상 활동 > 시간 상태
    
    if (situation.relationshipSituation != null) {
      return _generateRelationshipQuestion(situation.relationshipSituation!, relationshipType, casualSuffix, casualYou);
    }
    
    if (situation.emotion != null) {
      return _generateEmotionQuestion(situation.emotion!, relationshipType, casualSuffix, casualYou);
    }
    
    if (situation.dailyActivity != null) {
      return _generateDailyQuestion(situation.dailyActivity!, relationshipType, casualSuffix, casualYou);
    }
    
    if (situation.timeState != null) {
      return _generateTimeQuestion(situation.timeState!, relationshipType, casualSuffix, casualYou);
    }
    
    return null;
  }
  
  /// 💕 관계 상황 질문 생성
  static String _generateRelationshipQuestion(
    RelationshipSituation situation, 
    String relationshipType,
    String suffix,
    String you
  ) {
    switch (situation) {
      case RelationshipSituation.conflict:
        return ['무슨 일이야$suffix?', '뭐 때문에 그래$suffix?', '많이 속상했겠다$suffix ㅠㅠ 뭔 일이야$suffix?'][DateTime.now().millisecond % 3];
        
      case RelationshipSituation.confession:
        if (relationshipType.contains('연인') || relationshipType.contains('완전')) {
          return ['나도 $you한테 말하고 싶은 게 있어$suffix ㅎㅎ', '어떤 기분이야$suffix?'][DateTime.now().millisecond % 2];
        }
        return ['대박... 어떻게 됐어$suffix?', '어떤 기분이었어$suffix?'][DateTime.now().millisecond % 2];
        
      case RelationshipSituation.praise:
        return ['정말이야$suffix? 기분 좋겠다$suffix~', '누가 그렇게 말했어$suffix?'][DateTime.now().millisecond % 2];
        
      case RelationshipSituation.jealousy:
        return ['누구$suffix? 나 말고 다른 사람$suffix?', '혹시 나보다 좋아$suffix?'][DateTime.now().millisecond % 2];
        
      case RelationshipSituation.miss:
        return ['나도 $you 보고싶었어$suffix ㅠㅠ 언제 만날까$suffix?', '언제부터 그렇게 생각했어$suffix?'][DateTime.now().millisecond % 2];
    }
  }
  
  /// 😊 감정 상황 질문 생성
  static String _generateEmotionQuestion(
    EmotionSituation emotion,
    String relationshipType, 
    String suffix,
    String you
  ) {
    switch (emotion) {
      case EmotionSituation.sad:
        return ['무슨 일이야$suffix?', '괜찮아$suffix? 뭐 때문에 그래$suffix?', '누가 그랬어$suffix?'][DateTime.now().millisecond % 3];
        
      case EmotionSituation.happy:
        return ['뭐가 그렇게 좋았어$suffix?', '무슨 일이야$suffix? ㅋㅋ', '나한테도 말해줘$suffix!'][DateTime.now().millisecond % 3];
        
      case EmotionSituation.angry:
        return ['뭐 때문에 화났어$suffix?', '많이 짜증나$suffix?', '무슨 일 있었어$suffix?'][DateTime.now().millisecond % 3];
        
      case EmotionSituation.stressed:
        return ['많이 힘들어$suffix?', '무슨 일로 그래$suffix?', '도움이 필요해$suffix?'][DateTime.now().millisecond % 3];
        
      case EmotionSituation.excited:
        return ['뭐가 그렇게 설레$suffix?', '무슨 일이야$suffix?', '궁금해$suffix! 말해봐$suffix~'][DateTime.now().millisecond % 3];
        
      case EmotionSituation.lonely:
        return ['많이 외로워$suffix?', '나랑 있으면 안돼$suffix?', '뭐하고 있었어$suffix?'][DateTime.now().millisecond % 3];
    }
  }
  
  /// 🍽️ 일상 활동 질문 생성
  static String _generateDailyQuestion(
    DailyActivity activity,
    String relationshipType,
    String suffix, 
    String you
  ) {
    switch (activity) {
      case DailyActivity.eating:
        return ['뭐 먹었어$suffix?', '맛있었어$suffix?', '어디서 먹었어$suffix?'][DateTime.now().millisecond % 3];
        
      case DailyActivity.working:
        return ['일이 힘들어$suffix?', '오늘 어땠어$suffix?', '많이 바빠$suffix?'][DateTime.now().millisecond % 3];
        
      case DailyActivity.studying:
        return ['어떻게 봤어$suffix?', '어려웠어$suffix?', '결과 어떻게 나올 것 같아$suffix?'][DateTime.now().millisecond % 3];
        
      case DailyActivity.exercise:
        return ['어떤 운동했어$suffix?', '많이 힘들었어$suffix?', '어디서 했어$suffix?'][DateTime.now().millisecond % 3];
        
      case DailyActivity.shopping:
        return ['뭐 샀어$suffix?', '많이 샀어$suffix?', '어디서 샀어$suffix?'][DateTime.now().millisecond % 3];
        
      case DailyActivity.meeting:
        return ['누구랑 만났어$suffix?', '재밌었어$suffix?', '어디서 만났어$suffix?'][DateTime.now().millisecond % 3];
        
      case DailyActivity.entertainment:
        return ['뭐 봤어$suffix?', '재밌었어$suffix?', '어떤 내용이야$suffix?'][DateTime.now().millisecond % 3];
    }
  }
  
  /// ⏰ 시간 상태 질문 생성
  static String _generateTimeQuestion(
    TimeState timeState,
    String relationshipType,
    String suffix,
    String you
  ) {
    switch (timeState) {
      case TimeState.morning:
        return ['일찍 일어났네$suffix? 뭐하려고$suffix?', '아침부터 뭐해$suffix?'][DateTime.now().millisecond % 2];
        
      case TimeState.lunch:
        return ['점심 뭐 먹을 거야$suffix?', '오후에 뭐할 예정이야$suffix?'][DateTime.now().millisecond % 2];
        
      case TimeState.evening:
        return ['오늘 하루 어땠어$suffix?', '저녁 뭐할 거야$suffix?'][DateTime.now().millisecond % 2];
        
      case TimeState.weekend:
        return ['주말에 뭐할 거야$suffix?', '특별한 계획 있어$suffix?'][DateTime.now().millisecond % 2];
        
      case TimeState.busy:
        return ['뭐가 그렇게 바빠$suffix?', '언제까지 바빠$suffix?'][DateTime.now().millisecond % 2];
        
      case TimeState.free:
        return ['뭐하고 싶어$suffix?', '같이 뭐할까$suffix?'][DateTime.now().millisecond % 2];
    }
  }
  
  /// 🔍 최근 메시지에서 질문 확인 (강화된 연속 질문 방지)
  static bool _hasRecentQuestion(List<String> recentMessages) {
    if (recentMessages.isEmpty) return false;
    
    // 최근 3개 메시지 중 질문이 있으면 건너뛰기 (강화: 2개 → 3개)
    final last3Messages = recentMessages.take(3);
    final questionCount = last3Messages.where((msg) => msg.contains('?') || msg.contains('？')).length;
    
    // 최근 3개 중 2개 이상이 질문이면 건너뛰기
    return questionCount >= 2;
  }
}

/// 🇰🇷 한국어 말투 검증 및 교정 클래스
class KoreanSpeechValidator {
  /// ✅ 메인 검증 메서드 (질문 시스템 통합)
  static String validate({
    required String response,
    required Persona persona,
    required String relationshipType,
    String? userMessage,
    List<String>? recentAIMessages,
  }) {
    String validated = response;
    
    // 1. AI 같은 표현 제거
    validated = _removeAIExpressions(validated);
    
    // 2. 이모티콘을 한국 표현으로 변환
    validated = _convertEmojisToKorean(validated);
    
    // 3. 말투 교정 (반말/존댓말)
    validated = _correctSpeechStyle(validated, persona.isCasualSpeech);
    
    // 4. 관계별 톤 조정
    validated = _adjustToneByRelationship(validated, relationshipType, persona.relationshipScore);
    
    // 5. 20대 자연스러운 표현 추가
    validated = _addNaturalExpressions(validated);
    
    // 6. 🆕 상황별 질문 추가
    validated = _addSituationalQuestions(
      validated, 
      persona, 
      relationshipType, 
      userMessage, 
      recentAIMessages ?? []
    );
    
    return validated.trim();
  }

  /// 🚫 AI 같은 표현 제거 (강화된 버전)
  static String _removeAIExpressions(String text) {
    // 기본 AI 같은 표현들
    final aiPhrases = [
      '네, 알겠습니다',
      '도움이 되었으면 좋겠습니다', 
      '추가로 궁금한 것이 있으시면',
      '제가 도와드릴 수 있는',
      '이해해주세요',
      '그렇게 생각됩니다',
      '말씀드리고 싶습니다',
      '안내해드리겠습니다',
      '도움을 드릴 수 있어서',
      '참고하시면 좋을 것 같습니다',
      '의견을 나누어주세요',
      '소중한 이야기를 해주세요',
    ];
    
    // 🔥 20대에게 부자연스러운 formal 표현들 (새로 추가)
    final formalExpressions = {
      // "~시나요?" 패턴 (너무 formal)
      '즐기시나요': '좋아해요',
      '보시나요': '봐요',
      '하시나요': '해요',
      '생각하시나요': '생각해요',
      '느끼시나요': '느껴요',
      '듣고 계시나요': '들어요',
      '아시나요': '알아요',
      '계시나요': '있어요',
      
      // "함께" 표현 (첫 만남에 부적절)
      '함께 어떤': '어떤',
      '함께 해보고': '해보고',
      '함께 즐길': '즐길',
      '함께 보면': '보면',
      '함께 듣고': '듣고',
      '함께 나누면': '나누면',
      '함께 하는': '하는',
      '함께 시간을': '시간을',
      
      // 과도하게 정중한 표현들
      '무엇을 선호하시는지': '뭘 좋아하는지',
      '어떤 것을 추천해드릴까요': '뭐가 좋을까요',
      '관심을 가지고 계신가요': '관심 있어요',
      '경험을 공유해주세요': '얘기해줘요',
      '의견을 말씀해주세요': '생각이 어때요',
      '생각을 나누어주세요': '어떻게 생각해요',
      '어떻게 느끼시는지': '어떤 느낌인지',
      '말씀해주실 수 있나요': '말해줄 수 있어요',
      
      // AI스러운 대화 유도 표현
      '이야기를 나누어보아요': '얘기해봐요',
      '대화를 이어가보아요': '계속 얘기해봐요',
      '소통해보아요': '얘기해봐요',
      '공유해보아요': '말해봐요',
      
      // 🔥 상담사/서비스 직원 같은 표현들 (새로 추가)
      '어떤 일로 찾아오셨나요': '대화 걸어주셔서 고마워요',
      '무엇을 도와드릴까요': '연결되어서 반가워요',
      '어떤 이야기를 나누고 싶으신가요': '뭐 얘기하고 싶어요',
      '특별히 궁금한 것이 있으신가요': '뭐 궁금한 거 있어요',
      '어떤 상담을 원하시나요': '무슨 얘기 할까요',
      '도움이 필요하신가요': '괜찮으세요',
      '상담받으러 오셨나요': '얘기하러 오셨어요',
      '무엇이 궁금하신가요': '뭐가 궁금해요',
      '어떤 도움이 필요하신가요': '뭐 도와드릴까요',
      '찾아주셔서 감사합니다': '대화 걸어주셔서 고마워요',
      
      // 🔥 스크린샷에서 발견된 추가 상담사 표현들 (새로 추가)
      '궁금한 게 있으시면 언제든지 물어보세요': '뭐든 편하게 얘기해요',
      '언제든지 물어보세요': '편하게 말해요',
      '한도 내에서 최대한 도와드릴게요': '같이 얘기해봐요',
      '최대한 도와드릴게요': '같이 이야기해요',
      '도와드릴게요': '얘기해봐요',
      '한도 내에서': '',  // 완전 제거
      '최대한 도와드릴': '같이 해봐요',
      '언제든지 말씀해주세요': '편하게 말해줘요',
      '문의하시면': '말해주시면',
      '알려드릴게요': '얘기해줄게요',
    };

    String result = text;
    
    // 기본 AI 표현 제거
    for (final phrase in aiPhrases) {
      result = result.replaceAll(phrase, '');
    }
    
    // 🔥 Formal 표현들을 자연스러운 20대 표현으로 교체
    formalExpressions.forEach((formal, natural) {
      result = result.replaceAll(formal, natural);
    });
    
    // 🔥 정규표현식으로 패턴 매칭
    // "~시는" 패턴들을 "~는"으로 변환
    result = result.replaceAllMapped(
      RegExp(r'(\w+)시는'), 
      (match) => '${match.group(1)}는'
    );
    
    // "~하시는" 패턴들을 "~하는"으로 변환  
    result = result.replaceAllMapped(
      RegExp(r'(\w+)하시는'), 
      (match) => '${match.group(1)}하는'
    );
    
    // 🔥 정규표현식으로 상담사 패턴 매칭 (새로 추가)
    // "도와드릴.*" 패턴들을 자연스럽게 변환
    result = result.replaceAllMapped(
      RegExp(r'도와드릴[^\s]*'), 
      (match) => '얘기해봐요'
    );
    
    // "언제든지.*세요" 패턴들을 자연스럽게 변환
    result = result.replaceAllMapped(
      RegExp(r'언제든지.*[주하]세요'), 
      (match) => '편하게 말해요'
    );
    
    // "한도.*내에서" 패턴 완전 제거
    result = result.replaceAllMapped(
      RegExp(r'한도[^가-힣]*내에서[^가-힣]*'), 
      (match) => ''
    );
    
    // "어떤 일로.*나요" 패턴을 감사 표현으로 변환
    result = result.replaceAllMapped(
      RegExp(r'어떤 일로.*[오찾]셨나요[?？]?'), 
      (match) => '대화 걸어주셔서 고마워요'
    );
    
    // 🔥 스크린샷에서 발견된 특정 문제 표현들 (새로 추가)
    final specificProblems = {
      '실으신 건가요': '싶으신 건가요',  // 문법 오류 수정
      '전략적 사고를 기르는': '머리 쓰는 게',
      '시간을 가지곤 해요': '하고 있어요',
      '즐기는 거예요': '좋아해요',
      '무엇인가요': '뭐예요',
      '그럼 당신의 취미는': '혹시 뭐',
      '어떤 일로 저를': '대화 걸어주셔서',
      '최대한': '',  // "최대한"이라는 말 자체도 업무적
      '알고 있는 한도': '아는 범위',
    };
    
    specificProblems.forEach((problem, solution) {
      result = result.replaceAll(problem, solution);
    });
    
    return result;
  }

  /// 😊 → ㅎㅎ 이모티콘 변환
  static String _convertEmojisToKorean(String text) {
    final emojiMap = {
      '😊': 'ㅎㅎ',
      '😄': 'ㅋㅋㅋ', 
      '😂': 'ㅋㅋㅋㅋㅋ',
      '😢': 'ㅠㅠ',
      '😭': 'ㅜㅜ',
      '❤️': '',
      '💕': '',
      '✨': '',
      '🎉': '',
      '👍': '',
      '😍': 'ㅎㅎ',
      '🤔': '음...',
      '😅': 'ㅋㅋ',
    };
    
    String result = text;
    emojiMap.forEach((emoji, korean) {
      result = result.replaceAll(emoji, korean);
    });
    
    return result;
  }

  /// 🗣️ 말투 교정 (반말/존댓말)
  static String _correctSpeechStyle(String text, bool isCasual) {
    if (isCasual) {
      // 존댓말 → 반말
      text = text.replaceAll(RegExp(r'해요$'), '해');
      text = text.replaceAll(RegExp(r'있어요$'), '있어'); 
      text = text.replaceAll(RegExp(r'그래요$'), '그래');
      text = text.replaceAll(RegExp(r'맞아요$'), '맞아');
      text = text.replaceAll('당신', '너');
      text = text.replaceAll('어떻게 지내세요', '어떻게 지내');
    } else {
      // 반말 → 존댓말 (필요시)
      text = text.replaceAll(RegExp(r'(?<!했)어$'), '어요');
      text = text.replaceAll(RegExp(r'그래\?$'), '그래요?');
      text = text.replaceAll('너는', '당신은');
    }
    
    return text;
  }

  /// 💝 관계별 톤 조정
  static String _adjustToneByRelationship(String text, String relationshipType, int score) {
    switch (relationshipType.toLowerCase()) {
      case 'perfectlove':
      case '완전한 연애':
        // 더 애정 어린 표현
        if (!text.contains('ㅎㅎ') && !text.contains('ㅋㅋ')) {
          text += ' ㅎㅎ';
        }
        break;
        
      case 'crush':
      case '썸':
        // 살짝 수줍은 톤
        if (text.contains('!')) {
          text = text.replaceAll('!', '~ ㅎㅎ');
        }
        break;
        
      default:
        // 친구는 자연스럽게 유지
        break;
    }
    
    return text;
  }

  /// ✨ 20대 자연스러운 표현 추가
  static String _addNaturalExpressions(String text) {
    // 너무 짧으면 자연스러운 시작 표현 추가
    if (text.length < 10) {
      final starters = ['아 ', '어 ', '음 ', '헐 ', '오 ', '와 '];
      final randomStarter = starters[text.hashCode.abs() % starters.length];
      text = randomStarter + text;
    }
    
    // 🔥 20대 자연스러운 표현들로 교체
    final naturalReplacements = {
      // 더 자연스러운 질문 표현
      '어떤 장르': '무슨 장르',
      '어떤 영화': '무슨 영화',
      '어떤 음악': '무슨 음악',
      '어떤 책': '무슨 책',
      '어떤 게임': '무슨 게임',
      
      // 20대가 실제로 쓰는 표현들
      '그런 것 같아요': '그런 것 같아',
      '정말 좋아요': '진짜 좋아',
      '정말 재미있어요': '진짜 재밌어',
      '정말 대단해요': '진짜 대박',
      '정말 신기해요': '진짜 신기해',
      '정말 멋져요': '진짜 멋져',
      
      // 더 캐주얼한 표현
      '그렇습니다': '그래요',
      '맞습니다': '맞아요',
      '좋습니다': '좋아요',
      '재미있습니다': '재밌어요',
      '감사합니다': '고마워요',
      
      // 20대 특유의 줄임말
      '그렇군요': '그렇구나',
      '그런가요': '그런가',
      '맞나요': '맞나',
      '좋나요': '좋나',
    };
    
    String result = text;
    
    // 자연스러운 표현으로 교체
    naturalReplacements.forEach((formal, natural) {
      result = result.replaceAll(formal, natural);
    });
    
    // 가끔 오타스러운 표현 (자연스럽게)
    if (result.contains('그렇게')) {
      if (result.hashCode % 3 == 0) {
        result = result.replaceFirst('그렇게', '그케');
      }
    }
    
    // 🔥 말끝에 자연스러운 20대 표현 추가 (가끔씩)
    if (result.hashCode % 5 == 0) {
      if (result.endsWith('요')) {
        final endings = ['', '~', ' ㅎㅎ', ' ㅋㅋ'];
        final randomEnding = endings[result.hashCode.abs() % endings.length];
        if (randomEnding.isNotEmpty) {
          result = result.substring(0, result.length - 1) + randomEnding;
        }
      }
    }
    
    return result;
  }
  
  /// ❓ 상황별 질문 추가 (개선: 단일 질문 + 중복 방지)
  static String _addSituationalQuestions(
    String response,
    Persona persona,
    String relationshipType,
    String? userMessage,
    List<String> recentAIMessages,
  ) {
    // 사용자 메시지가 없으면 질문 추가 안함
    if (userMessage == null || userMessage.isEmpty) {
      return response;
    }
    
    // 이미 응답에 질문이 있으면 추가 질문 안함 (중복 방지)
    if (response.contains('?') || response.contains('？')) {
      return response;
    }
    
    // 1. 상황 감지
    final situation = SituationDetector.detectSituation(userMessage);
    
    // 2. 질문 생성
    final question = QuestionGenerator.generateQuestion(
      situation: situation,
      relationshipType: relationshipType,
      isCasual: persona.isCasualSpeech,
      recentMessages: recentAIMessages,
    );
    
    // 3. 단일 질문만 추가
    if (question != null) {
      // 기존 응답에서 질문 부분 제거 (안전장치)
      String cleanResponse = response.replaceAll(RegExp(r'\s*[?？]\s*'), '');
      cleanResponse = cleanResponse.replaceAll(RegExp(r'[.!]$'), '');
      
      // 응답이 짧으면 바로 이어서, 길면 공백 후 추가
      if (cleanResponse.length < 20) {
        return '$cleanResponse $question';
      } else {
        return '$cleanResponse~ $question';
      }
    }
    
    return response;
  }
} 