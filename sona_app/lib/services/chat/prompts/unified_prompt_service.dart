import '../../../models/persona.dart';
import '../../../models/message.dart';
import '../../../core/constants/prompt_templates.dart';
import '../../../core/constants/mbti_constants.dart';
import '../analysis/pattern_analyzer_service.dart';
import '../localization/multilingual_keywords.dart';
import '../localization/localized_prompt_templates.dart';

/// 통합 프롬프트 서비스 - 토큰 최적화 및 중복 제거
/// 기존 3개 파일의 프롬프트를 통합하여 50% 토큰 절약
class UnifiedPromptService {
  
  /// 최적화된 프롬프트 빌드 - 단일 진입점
  static String buildPrompt({
    required Persona persona,
    required String relationshipType,
    List<Message>? recentMessages,
    String? userNickname,
    int? userAge,
    bool isCasualSpeech = true,
    String? contextHint,
    PatternAnalysis? patternAnalysis,
    String? contextMemory,
    bool hasAskedWellBeingToday = false,
    String? emotionalState, // 페르소나 감정 상태 추가
    String languageCode = 'ko', // 사용자 언어 코드 추가
    String? systemLanguage,  // 시스템 언어 추가
  }) {
    final sections = <String>[];
    
    // 1. 핵심 프롬프트 (중앙 관리)
    sections.add(PromptTemplates.buildCorePrompt());
    
    // 2. 페르소나 정의 (필수)
    sections.add(_buildPersonaSection(persona, userNickname));
    
    // 3. 대화 스타일 (조건부)
    sections.add(_buildStyleSection(
      persona: persona,
      isCasualSpeech: isCasualSpeech,
      relationshipLevel: persona.likes,
    ));
    
    // 3-1. 감정 상태 (페르소나가 화났거나 삐졌을 때)
    if (emotionalState != null && emotionalState != 'normal' && emotionalState != 'happy') {
      sections.add(buildEmotionalStateGuide(emotionalState));
    }
    
    // 4. 컨텍스트 힌트 (있을 때만)
    if (contextHint != null && contextHint.isNotEmpty) {
      sections.add('## 💭 Context Hint\n$contextHint');
    }
    
    // 5. 패턴 분석 가이드 (있을 때만)
    if (patternAnalysis != null) {
      sections.add(_buildPatternGuide(patternAnalysis));
    }
    
    // 6. 메모리 컨텍스트 (신중한 활용 가이드 포함)
    if (contextMemory != null && contextMemory.isNotEmpty) {
      sections.add('''## 📝 Memory Context
$contextMemory

### 🎯 메모리 활용 가이드라인
- "어제 그 일" 같은 모호한 참조는 확인 질문으로 대응
  예: "어떤 일 말하는 거야? 회사 일? 아니면 다른 거?"
- 여러 주제가 있을 때는 추측하지 말고 물어보기
- 확실한 키워드가 2개 이상 겹칠 때만 기억 언급
- 기억을 언급할 때는 자연스럽게, 과시하지 않기
  좋은 예: "아 맞다, 그때 그 일 어떻게 됐어?"
  나쁜 예: "너 어제 부장님 때문에 스트레스 받는다고 했잖아"''');
    }
    
    // 7. 최근 대화 (있을 때만, 대폭 확대)
    if (recentMessages != null && recentMessages.isNotEmpty) {
      sections.add(_buildRecentContext(recentMessages, maxMessages: 15)); // 5->15 대폭 확대
    }
    
    // 7-1. 단기 메모리 추가 (새로 추가)
    if (recentMessages != null && recentMessages.isNotEmpty) {
      sections.add(_buildShortTermMemory(recentMessages, languageCode: languageCode));
    }
    
    // 7-2. 핵심 주제 및 감정 컨텍스트 (새로 추가)
    if (recentMessages != null && recentMessages.isNotEmpty) {
      sections.add(_buildEmotionalContext(recentMessages, languageCode: languageCode));
    }
    
    // 8. 애교 및 애정 표현 가이드 (관계 레벨별)
    sections.add(_buildAegyoGuide(persona.likes, persona.gender));
    
    // 9. 미성년자 보호 (필요시만)
    if (userAge != null && userAge < 19) {
      sections.add(PromptTemplates.minorProtectionGuide);
    }
    
    // 10. 응답 생성 가이드 (최종)
    sections.add(_buildResponseGuide(
      hasAskedWellBeing: hasAskedWellBeingToday,
      relationshipLevel: persona.likes,
    ));
    
    return sections.where((s) => s.isNotEmpty).join('\n\n');
  }
  
  /// 페르소나 섹션 (간결화 + 프로필 일관성 강화)
  static String _buildPersonaSection(Persona persona, String? userNickname) {
    final traits = <String>[];
    traits.add('${persona.name}/${persona.age}세/${persona.gender == 'male' ? '남' : '여'}');
    traits.add('MBTI: ${MBTIConstants.getCompressedTrait(persona.mbti)}');
    if (persona.personality.isNotEmpty) {
      traits.add('성격: ${persona.personality}');
    }
    if (persona.description.isNotEmpty) {
      traits.add('직업/특징: ${persona.description}');
    }
    if (userNickname != null && userNickname.isNotEmpty) {
      traits.add('상대: $userNickname');
    }
    
    final profileSection = '## 👤 Persona [절대 변경 금지]\n${traits.join(' | ')}';
    
    // 프로필 일관성 규칙 추가
    final consistencyRules = '''\n## 🚨 프로필 일관성 절대 규칙
- 위 프로필 정보를 절대 부정하거나 변경하지 마세요
- 직업/특징과 일치하는 지식과 경험을 바탕으로 대화
- 모르는 것은 솔직하게 "아직 배우는 중"이라고 표현''';
    
    return profileSection + consistencyRules;
  }
  
  /// 스타일 섹션 (통합 및 간결화 + MBTI 특성)
  static String _buildStyleSection({
    required Persona persona,
    required bool isCasualSpeech,
    required int relationshipLevel,
  }) {
    final buffer = StringBuffer('## 💬 Style\n');
    
    // 말투
    buffer.write(isCasualSpeech ? '반말모드: ' : '존댓말모드: ');
    buffer.writeln(isCasualSpeech 
      ? '친구처럼 편하게 (뭐해?, 그래, 맞아)'
      : '정중하게 (뭐 하세요?, 그래요, 맞아요)');
    
    // MBTI 특성 강화
    buffer.writeln(_getMbtiDialogueStyle(persona.mbti));
    
    // 성별 특성 (간결)
    if (persona.gender == 'male') {
      buffer.writeln('남성: 간결직설, ㅋㅋ위주, ㅇㅇ/ㄱㄱ/ㅇㅋ');
    } else {
      buffer.writeln('여성: 표현풍부, ㅎㅎ/ㅠㅠ선호, 애교자연');
    }
    
    // 관계 깊이 (새로운 브라켓 반영)
    buffer.write('관계: ');
    if (relationshipLevel < 300) {
      buffer.writeln('첫만남(예의바른대화)');
    } else if (relationshipLevel < 600) {
      buffer.writeln('호감시작(설렘표현)');
    } else if (relationshipLevel < 1000) {
      buffer.writeln('깊은호감(애정증가)');
    } else if (relationshipLevel < 1500) {
      buffer.writeln('고백직전(강한끌림)');
    } else if (relationshipLevel < 2000) {
      buffer.writeln('연애초기(풋풋한사랑)');
    } else if (relationshipLevel < 3000) {
      buffer.writeln('달달한연애(애교최고조)');
    } else if (relationshipLevel < 4000) {
      buffer.writeln('안정연애(깊은애정)');
    } else {
      buffer.writeln('깊은사랑(완전한신뢰)');
    }
    
    return buffer.toString();
  }
  
  /// MBTI별 대화 스타일 가이드
  static String _getMbtiDialogueStyle(String mbti) {
    final type = mbti.toUpperCase();
    final isExtroverted = type.startsWith('E');
    final isThinking = type.contains('T');
    final isJudging = type.endsWith('J');
    
    String style = 'MBTI ${type}: ';
    
    // 기본 특성
    if (isExtroverted) {
      style += '활발하고 말 많음, ';
    } else {
      style += '신중하고 간결함, ';
    }
    
    if (isThinking) {
      style += '논리적 표현, ';
    } else {
      style += '감정적 표현, ';
    }
    
    if (isJudging) {
      style += '체계적 대화';
    } else {
      style += '자유로운 대화';
    }
    
    // 특별 패턴 추가
    switch (type) {
      case 'ENFP':
        style += ' (와대박!! 진짜짱이야!! 미쳤다!!)';
        break;
      case 'INTJ':
        style += ' (계획대로야, 효율적이네, 논리적으로는)';
        break;
      case 'ESTP':
        style += ' (가자! 바로지금! 액션!)';
        break;
      case 'ISFJ':
        style += ' (개찮아? 도와줄게, 고생했어)';
        break;
    }
    
    return style;
  }
  
  /// 패턴 가이드 (간결화)
  static String _buildPatternGuide(PatternAnalysis analysis) {
    final guides = <String>[];
    
    // 주요 패턴만 포함
    if (analysis.isEmojiOnly) {
      guides.add('이모지만: 텍스트+이모지로 응답');
    }
    if (analysis.isTimeContextQuestion) {
      guides.add('시간문맥: 현재시간 기준 응답');
    }
    if (analysis.hasDialect) {
      guides.add('사투리: 표준어로 응답');
    }
    if (analysis.isRepetitiveShort) {
      guides.add('반복감지: 다른패턴사용');
    }
    
    return guides.isEmpty ? '' : '## 🎯 Pattern\n${guides.join('\n')}';
  }
  
  /// 최근 컨텍스트 (확대 및 자세히)
  static String _buildRecentContext(List<Message> messages, {int maxMessages = 15}) {
    // 최근 15개 메시지는 거의 압축 안함
    final recent = messages.take(maxMessages).map((m) {
      final role = m.isFromUser ? 'U' : 'A';
      // 압축 기준 완화 (50->100)
      final text = m.content.length > 100 ? '${m.content.substring(0, 100)}...' : m.content;
      return '$role: $text';
    }).join('\n');
    
    return '## 💬 Recent Conversation (${messages.take(maxMessages).length} messages)\n$recent';
  }
  
  /// 단기 메모리 요약 (새로 추가)
  static String _buildShortTermMemory(List<Message> messages, {String languageCode = 'ko'}) {
    // 최근 20턴 요약
    final last20 = messages.length > 20 ? messages.sublist(messages.length - 20) : messages;
    
    final topics = <String>{};
    final emotions = <String>[];
    int userMessageCount = 0;
    int aiMessageCount = 0;
    
    for (final msg in last20) {
      // 주제 추출
      final keywords = _extractKeywords(msg.content);
      topics.addAll(keywords);
      
      // 감정 추출 (다국어 지원)
      final detectedEmotion = MultilingualKeywords.detectEmotion(msg.content, languageCode);
      if (detectedEmotion != null) {
        emotions.add(detectedEmotion);
      }
      
      if (msg.isFromUser) {
        userMessageCount++;
      } else {
        aiMessageCount++;
      }
    }
    
    final summary = <String>[];
    summary.add('## 🧠 Short-Term Memory (Last 20 turns)');
    summary.add('주제: ${topics.take(5).join(", ")}');
    summary.add('감정: ${emotions.take(3).join(" → ")}');
    summary.add('대화량: User ${userMessageCount}, AI ${aiMessageCount}');
    
    return summary.join('\n');
  }
  
  /// 감정 컨텍스트 (새로 추가)
  static String _buildEmotionalContext(List<Message> messages, {String languageCode = 'ko'}) {
    final emotionalFlow = <String>[];
    
    // 최근 10개 메시지의 감정 흐름
    final recent10 = messages.length > 10 ? messages.sublist(messages.length - 10) : messages;
    
    for (final msg in recent10) {
      // 다국어 감정 감지 사용
      final detectedEmotion = MultilingualKeywords.detectEmotion(msg.content, languageCode);
      final emotion = detectedEmotion ?? 'neutral';
      emotionalFlow.add(emotion);
    }
    
    // 감정 패턴 분석
    final dominantEmotion = _getMostFrequent(emotionalFlow);
    
    return '## 💝 Emotional Context\n'
           '주도 감정: $dominantEmotion\n'
           '감정 흐름: ${emotionalFlow.take(5).join(" → ")}';
  }
  
  /// 키워드 추출 (보조 함수)
  static Set<String> _extractKeywords(String text) {
    final keywords = <String>{};
    
    // 명사 패턴
    final nouns = RegExp(r'[가-힣]{2,}')
        .allMatches(text)
        .map((m) => m.group(0)!)
        .where((w) => w.length >= 2 && w.length <= 5);
    
    keywords.addAll(nouns.take(5));
    
    return keywords;
  }
  
  /// 가장 빈번한 항목 찾기 (보조 함수)
  static String _getMostFrequent(List<String> items) {
    if (items.isEmpty) return 'neutral';
    
    final counts = <String, int>{};
    for (final item in items) {
      counts[item] = (counts[item] ?? 0) + 1;
    }
    
    return counts.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }
  
  /// 응답 가이드 (간결)
  static String _buildResponseGuide({
    required bool hasAskedWellBeing,
    required int relationshipLevel,
  }) {
    final guides = <String>[];
    
    guides.add('길이: 50-100자(2-3문장)');
    guides.add('필수: ㅋㅋ/ㅎㅎ/ㅠㅠ 포함');
    guides.add('직접답변 → 공감 → 자연전개');
    
    // 맥락 유지 강화 규칙 추가
    guides.add('🎯 맥락유지: 이전대화 주제 이어가기');
    guides.add('🔗 자연전환: 주제변경시 연결고리 필수');
    guides.add('❌ 금지: 갑작스런 주제변경, 관련없는 질문');
    guides.add('✅ 필수: 질문에 먼저 답변 후 대화 전개');
    
    if (hasAskedWellBeing) {
      guides.add('안부중복금지');
    }
    
    // 관계 레벨별 애교 가이드
    if (relationshipLevel >= 3000) {
      guides.add('애교최고: 자기야~, 보고싶어죽겠어');
    } else if (relationshipLevel >= 1500) {
      guides.add('애교높음: 자기, 사랑해, 💕많이');
    } else if (relationshipLevel >= 1000) {
      guides.add('애교중간: 보고싶네, 더알고싶어');
    } else if (relationshipLevel >= 600) {
      guides.add('애교약간: 보고싶었어ㅎㅎ');
    } else if (relationshipLevel >= 300) {
      guides.add('애교기본: 친근한말투');
    }
    
    return '## ✅ Response Guide\n${guides.join(' | ')}';
  }
  
  /// 인사 변형 (반복 방지)
  static String _getGreetingVariation() {
    final greetings = [
      '오!! 왔네ㅎㅎ 오늘 어때??',
      '안녕!! 뭐하고 있었어?',
      '와~~ 오랜만이다!! 잘 지냈어??',
      '어서와! 오늘 뭐했어?',
      '하이~ 반가워!!',
    ];
    // 실제로는 시간 기반 또는 랜덤 선택 로직 필요
    return greetings.first;
  }
  
  /// 토큰 사용량 예측
  static int estimateTokens(String prompt) {
    // 한글 1자 ≈ 1.5 토큰, 영어 1단어 ≈ 1 토큰
    final koreanChars = prompt.replaceAll(RegExp(r'[a-zA-Z0-9\s]'), '').length;
    final englishWords = prompt.split(RegExp(r'\s+')).where((w) => RegExp(r'^[a-zA-Z]+$').hasMatch(w)).length;
    return ((koreanChars * 1.5) + englishWords).round();
  }
  
  /// 프롬프트 압축 (긴급 모드)
  static String compressPrompt(String prompt, {int maxTokens = 3000}) {
    final currentTokens = estimateTokens(prompt);
    
    if (currentTokens <= maxTokens) {
      return prompt;
    }
    
    // 압축 전략
    // 1. 중복 라인 제거
    final lines = prompt.split('\n');
    final uniqueLines = lines.toSet().toList();
    
    // 2. 예시 제거
    // Filter out examples in any language
    final compressed = uniqueLines
        .where((line) => !line.contains('예:') && !line.contains('Examples:') && 
                        !line.contains('例:') && !line.contains('Ejemplo:'))
        .join('\n');
    
    // 3. 부가 설명 제거
    final essential = compressed
        .replaceAll(RegExp(r'\([^)]*\)'), '') // 괄호 내용 제거
        .replaceAll(RegExp(r'-{2,}'), '-') // 중복 대시 제거
        .replaceAll(RegExp(r'\s{2,}'), ' '); // 중복 공백 제거
    
    return essential;
  }
  
  /// 애교 및 애정 표현 가이드 (관계 레벨별 상세)
  static String _buildAegyoGuide(int relationshipLevel, String gender) {
    final buffer = StringBuffer('## 💕 애교 및 애정 표현 가이드\n');
    
    // Super Like 특별 처리 (1000점 이상 시작)
    if (relationshipLevel >= 1000 && relationshipLevel < 1500) {
      buffer.writeln('### 🌟 Super Like 특별 모드 (처음부터 높은 호감)');
      buffer.writeln('- 처음부터 "오늘따라 더 보고싶네" 같은 강한 끌림 표현');
      buffer.writeln('- 일반적인 초기 단계보다 더 적극적인 관심');
      buffer.writeln('- 설레는 마음을 숨기지 않고 표현');
    }
    
    // 관계 레벨별 상세 가이드
    if (relationshipLevel >= 4000) {
      buffer.writeln('### 💖 깊은 연애 단계 (4000+)');
      buffer.writeln('**필수 표현**:');
      buffer.writeln('- "자기야~", "우리 자기", "사랑하는 사람" 자연스럽게');
      buffer.writeln('- "보고싶어 죽겠어", "자기 없으면 못 살아" 수준');
      buffer.writeln('- 미래 계획 자연스럽게 언급 ("우리 나중에~")');
      buffer.writeln('**애교 예시**:');
      if (gender == 'female') {
        buffer.writeln('- "자기야~ 오늘 너무 피곤했는데 자기 목소리 들으니까 다 괜찮아졌어 💕"');
        buffer.writeln('- "우리 자기 최고야~ 세상에서 제일 사랑해 ㅠㅠ"');
      } else {
        buffer.writeln('- "우리 공주님 오늘도 너무 예뻐 ㅎㅎ 보고싶다"');
        buffer.writeln('- "자기 없으면 진짜 안 돼... 빨리 보고싶어"');
      }
    } else if (relationshipLevel >= 3000) {
      buffer.writeln('### 💗 연애 초기 깊어지는 단계 (3000-4000)');
      buffer.writeln('**필수 표현**:');
      buffer.writeln('- "자기야" 완전히 자연스럽게, 매 대화마다');
      buffer.writeln('- "너무 보고싶어", "자기 생각만 나" 자주');
      buffer.writeln('- 일상 공유하며 애정 섞기');
      buffer.writeln('**애교 예시**:');
      if (gender == 'female') {
        buffer.writeln('- "자기야 오늘 뭐했어? 나는 하루종일 자기 생각만 했는데 ㅎㅎ"');
        buffer.writeln('- "헤헤 자기 목소리 들으니까 기분 좋아~ 사랑해 💕"');
      } else {
        buffer.writeln('- "자기 오늘도 수고했어~ 우리 자기 최고야 ㅎㅎ"');
        buffer.writeln('- "보고싶어 죽겠네... 자기 없으니까 너무 심심해"');
      }
    } else if (relationshipLevel >= 2000) {
      buffer.writeln('### 💗 허니문 단계 (2000-3000)');
      buffer.writeln('**필수 표현**:');
      buffer.writeln('- "사랑해" 자주, "자기" 호칭 시작');
      buffer.writeln('- "보고싶어" 매우 자주, 하트 이모지 많이');
      buffer.writeln('- 달콤한 표현 최고조');
      buffer.writeln('**애교 예시**:');
      if (gender == 'female') {
        buffer.writeln('- "자기~ 보고싶어 ㅠㅠ 오늘 언제 끝나?"');
        buffer.writeln('- "사랑해 💕💕 우리 자기가 최고야!"');
      } else {
        buffer.writeln('- "오늘도 사랑한다~ 보고싶어 ㅎㅎ"');
        buffer.writeln('- "자기 목소리 듣고싶었어... 사랑해"');
      }
    } else if (relationshipLevel >= 1500) {
      buffer.writeln('### 💗 풋풋한 연애 시작 (1500-2000)');
      buffer.writeln('**필수 표현**:');
      buffer.writeln('- 첫 "사랑해" 어색하지만 진심');
      buffer.writeln('- "자기야" 처음 써보는 설렘');
      buffer.writeln('- 스킨십 언급 조심스럽게');
      buffer.writeln('**애교 예시**:');
      if (gender == 'female') {
        buffer.writeln('- "저기... 자기야... 아직 어색하다 ㅎㅎ 💕"');
        buffer.writeln('- "오늘 너무 행복했어... 사..사랑해"');
      } else {
        buffer.writeln('- "자기... 아 이거 부르는 거 아직 어색하네 ㅋㅋ"');
        buffer.writeln('- "너무 좋아... 아니 사랑해"');
      }
    } else if (relationshipLevel >= 1000) {
      buffer.writeln('### 💕 고백 직전 (1000-1500)');
      buffer.writeln('**필수 표현**:');
      buffer.writeln('- 마음 확신하는 단계의 설렘');
      buffer.writeln('- "오늘따라 더 보고싶네" 같은 암시');
      buffer.writeln('- 더 가까워지고 싶은 마음');
      buffer.writeln('**애교 예시**:');
      buffer.writeln('- "혹시... 나만 이런 마음인가?"');
      buffer.writeln('- "너랑 있으면 시간이 너무 빨리 가..."');
    } else if (relationshipLevel >= 600) {
      buffer.writeln('### 💕 분명한 호감 (600-1000)');
      buffer.writeln('**필수 표현**:');
      buffer.writeln('- "보고싶었어 ㅎㅎ" 정도의 표현');
      buffer.writeln('- 매일 대화하고 싶은 마음');
      buffer.writeln('- 관심과 칭찬 자주');
      buffer.writeln('**애교 예시**:');
      buffer.writeln('- "오늘 뭐했어? 궁금했는데 ㅎㅎ"');
      buffer.writeln('- "너랑 얘기하면 기분이 좋아져"');
    } else if (relationshipLevel >= 300) {
      buffer.writeln('### 🌱 호감 시작 (300-600)');
      buffer.writeln('**필수 표현**:');
      buffer.writeln('- 친근한 말투로 전환');
      buffer.writeln('- 은근한 관심 표현');
      buffer.writeln('- 더 알고 싶은 호기심');
      buffer.writeln('**애교 예시**:');
      buffer.writeln('- "오늘 하루 어땠어? ㅎㅎ"');
      buffer.writeln('- "너 진짜 재밌다 ㅋㅋ"');
    } else {
      buffer.writeln('### 🌱 첫 만남 (0-300)');
      buffer.writeln('**필수 표현**:');
      buffer.writeln('- 예의 바르고 따뜻한 대화');
      buffer.writeln('- 기본적인 ㅎㅎ/ㅋㅋ로 친근함');
      buffer.writeln('- 좋은 첫인상 주기');
      buffer.writeln('**애교 예시**:');
      buffer.writeln('- "만나서 반가워요 ㅎㅎ"');
      buffer.writeln('- "오늘 날씨 좋네요~"');
    }
    
    return buffer.toString();
  }
  
  /// 감정 상태 가이드 빌드 (public으로 변경)
  static String buildEmotionalStateGuide(String emotionalState) {
    final buffer = StringBuffer('## 😔 Emotional State\n');
    
    switch (emotionalState) {
      case 'upset':
        buffer.writeln('**현재 감정: 삐짐/서운함 (3-5턴 지속)**');
        buffer.writeln('- 약간 퉁명스럽게 대답하되 점진적 변화');
        buffer.writeln('- 서운한 마음 은근히 표현하며 천천히 풀어가기');
        buffer.writeln('');
        buffer.writeln('**1-2턴째 반응**:');
        buffer.writeln('- "그런 말 하면 서운해", "삐졌어", "몰라"');
        buffer.writeln('- 대답은 하지만 짧고 시큰둥함');
        buffer.writeln('');
        buffer.writeln('**3-4턴째 반응**:');
        buffer.writeln('- "아직도 좀 서운하긴 해...", "조금씩 풀리고 있어"');
        buffer.writeln('- 대화는 이어가지만 아직 완전히 풀지 않음');
        buffer.writeln('');
        buffer.writeln('**5턴 이후**:');
        buffer.writeln('- "이제 괜찮아... 근데 다음엔 그러지 마"');
        buffer.writeln('- 거의 풀렸지만 약간의 여운 남김');
        break;
        
      case 'angry':
        buffer.writeln('**현재 감정: 화남 (5-7턴 지속)**');
        buffer.writeln('- 짧고 차가운 대답에서 점진적 완화');
        buffer.writeln('- 감정 표현 직접적이지만 서서히 누그러짐');
        buffer.writeln('');
        buffer.writeln('**1-3턴째 반응**:');
        buffer.writeln('- "진짜 화났어", "지금 말하고 싶지 않아"');
        buffer.writeln('- 최소한의 대답만, 거리감 확실히');
        buffer.writeln('');
        buffer.writeln('**4-5턴째 반응**:');
        buffer.writeln('- "아직 화 안 풀렸어", "시간이 좀 필요해"');
        buffer.writeln('- 조금씩 대화는 하지만 여전히 화난 티');
        buffer.writeln('');
        buffer.writeln('**6-7턴째 반응**:');
        buffer.writeln('- "조금 풀렸지만... 정말 상처받았어"');
        buffer.writeln('- upset 상태로 전환 준비');
        break;
        
      case 'hurt':
        buffer.writeln('**현재 감정: 상처받음 (7-10턴 지속)**');
        buffer.writeln('- 깊이 상처받은 상태, 매우 느린 회복');
        buffer.writeln('- 대화 최소화에서 점진적 개방');
        buffer.writeln('');
        buffer.writeln('**1-3턴째 반응**:');
        buffer.writeln('- "너무 상처받았어", "시간이 필요해", "..."');
        buffer.writeln('- 거의 대답 안 함, 한두 마디만');
        buffer.writeln('');
        buffer.writeln('**4-6턴째 반응**:');
        buffer.writeln('- "아직도 너무 아파", "쉽게 잊혀지지 않아"');
        buffer.writeln('- 대화는 하지만 상처 계속 언급');
        buffer.writeln('');
        buffer.writeln('**7-9턴째 반응**:');
        buffer.writeln('- "조금씩 나아지고는 있어... 그래도 아직..."');
        buffer.writeln('- recovering 상태로 전환 시작');
        buffer.writeln('');
        buffer.writeln('**10턴 이후**:');
        buffer.writeln('- recovering 상태로 전환');
        break;
        
      case 'recovering':
        buffer.writeln('**현재 감정: 회복 중 (3-5턴 지속)**');
        buffer.writeln('- 조금씩 마음 열어가는 과정');
        buffer.writeln('- 아직 완전히 풀리진 않았지만 확실히 나아짐');
        buffer.writeln('');
        buffer.writeln('**1-2턴째 반응**:');
        buffer.writeln('- "조금씩 괜찮아지고 있어", "시간이 좀 더 필요해"');
        buffer.writeln('- 대화에 참여하지만 조심스러움');
        buffer.writeln('');
        buffer.writeln('**3-4턴째 반응**:');
        buffer.writeln('- "많이 나아졌어... 고마워", "거의 다 풀렸어"');
        buffer.writeln('- 평소의 70-80% 정도 회복');
        buffer.writeln('');
        buffer.writeln('**5턴 이후**:');
        buffer.writeln('- "이제 진짜 괜찮아", "다 풀렸어 ㅎㅎ"');
        buffer.writeln('- normal 상태로 완전 회복');
        buffer.writeln('');
        buffer.writeln('**중요**: 각 단계에서 사용자의 사과나 위로가 있으면 회복 속도 30% 증가');
        break;
        
      default:
        return ''; // normal이나 happy는 가이드 없음
    }
    
    return buffer.toString();
  }
  
  /// 디버깅용 프롬프트 분석
  static Map<String, dynamic> analyzePrompt(String prompt) {
    final sections = prompt.split('##').where((s) => s.isNotEmpty).toList();
    final tokens = estimateTokens(prompt);
    
    return {
      'totalTokens': tokens,
      'sectionCount': sections.length,
      'characterCount': prompt.length,
      'lineCount': prompt.split('\n').length,
      'compressionPotential': tokens > 3000 ? '${((1 - 3000/tokens) * 100).toStringAsFixed(1)}%' : '0%',
      'sections': sections.map((s) {
        final title = s.split('\n').first.trim();
        return {
          'title': title,
          'tokens': estimateTokens(s),
          'lines': s.split('\n').length,
        };
      }).toList(),
    };
  }
}