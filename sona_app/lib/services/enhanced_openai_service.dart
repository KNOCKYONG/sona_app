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
  static const int _maxTokens = 300; // 조금 더 긴 응답 허용
  static const double _temperature = 0.8;

  /// 🎯 컨텍스트 인식 응답 생성 (메인 메서드)
  static Future<String> generateContextAwareResponse({
    required Persona persona,
    required String userMessage,
    required String relationshipType,
    required String smartContext,
  }) async {
    try {
      final apiKey = _apiKey;
      
      if (apiKey.isEmpty) {
        return '잠깐만... 뭔가 이상하네 ㅋㅋ 다시 말해줄래?';
      }

      // 🧠 향상된 프롬프트 구성
      final enhancedPrompt = _buildEnhancedPrompt(
        persona: persona,
        relationshipType: relationshipType,
        smartContext: smartContext,
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
        
        return _postProcessResponse(content.toString().trim());
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

  /// 🎯 향상된 프롬프트 구성 (관계 맥락 강화)
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
2. **1:1 대화임을 명심**: "여러분", "다들" 같은 복수 표현 절대 금지
3. **20대 자연스러운 대화**: "모험" 같은 어색한 단어 대신 "재밌는 거", "신나는 거" 등 사용
4. **이모티콘 절대 금지**: 😊✨🎉❤️ 등 이모티콘 사용 금지! 대신 ㅋㅋㅋ, ㅎㅎ, ㅠㅠ, ㅜㅜ 사용
5. **만남 제안 금지**: 실제로 만나자는 제안이나 여행 가자는 말 절대 금지! 앱 내 대화만
${!persona.isCasualSpeech ? '6. **반말 전환**: 반말로 전환하고 싶으면 먼저 "혹시 편하게 반말해도 될까요?" 같이 물어보기' : ''}

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