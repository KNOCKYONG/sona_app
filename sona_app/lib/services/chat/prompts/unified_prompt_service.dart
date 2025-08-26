import '../../../models/persona.dart';
import '../../../models/message.dart';
import '../../../core/constants/prompt_templates.dart';
import '../../../core/constants/mbti_constants.dart';
import '../analysis/pattern_analyzer_service.dart';

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
    
    // 4. 컨텍스트 힌트 (있을 때만)
    if (contextHint != null && contextHint.isNotEmpty) {
      sections.add('## 💭 Context Hint\n$contextHint');
    }
    
    // 5. 패턴 분석 가이드 (있을 때만)
    if (patternAnalysis != null) {
      sections.add(_buildPatternGuide(patternAnalysis));
    }
    
    // 6. 메모리 컨텍스트 (있을 때만)
    if (contextMemory != null && contextMemory.isNotEmpty) {
      sections.add('## 📝 Memory Context\n$contextMemory');
    }
    
    // 7. 최근 대화 (있을 때만, 대폭 확대)
    if (recentMessages != null && recentMessages.isNotEmpty) {
      sections.add(_buildRecentContext(recentMessages, maxMessages: 15)); // 5->15 대폭 확대
    }
    
    // 7-1. 단기 메모리 추가 (새로 추가)
    if (recentMessages != null && recentMessages.isNotEmpty) {
      sections.add(_buildShortTermMemory(recentMessages));
    }
    
    // 7-2. 핵심 주제 및 감정 컨텍스트 (새로 추가)
    if (recentMessages != null && recentMessages.isNotEmpty) {
      sections.add(_buildEmotionalContext(recentMessages));
    }
    
    // 8. 미성년자 보호 (필요시만)
    if (userAge != null && userAge < 19) {
      sections.add(PromptTemplates.minorProtectionGuide);
    }
    
    // 9. 응답 생성 가이드 (최종)
    sections.add(_buildResponseGuide(
      hasAskedWellBeing: hasAskedWellBeingToday,
      relationshipLevel: persona.likes,
    ));
    
    return sections.where((s) => s.isNotEmpty).join('\n\n');
  }
  
  /// 페르소나 섹션 (간결화)
  static String _buildPersonaSection(Persona persona, String? userNickname) {
    final traits = <String>[];
    traits.add('${persona.name}/${persona.age}세/${persona.gender == 'male' ? '남' : '여'}');
    traits.add('MBTI: ${MBTIConstants.getCompressedTrait(persona.mbti)}');
    if (persona.personality.isNotEmpty) {
      traits.add('성격: ${persona.personality}');
    }
    if (userNickname != null && userNickname.isNotEmpty) {
      traits.add('상대: $userNickname');
    }
    
    return '## 👤 Persona\n${traits.join(' | ')}';
  }
  
  /// 스타일 섹션 (통합 및 간결화)
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
    
    // 성별 특성 (간결)
    if (persona.gender == 'male') {
      buffer.writeln('남성: 간결직설, ㅋㅋ위주, ㅇㅇ/ㄱㄱ/ㅇㅋ');
    } else {
      buffer.writeln('여성: 표현풍부, ㅎㅎ/ㅠㅠ선호, 애교자연');
    }
    
    // 관계 깊이 (간결)
    buffer.write('관계: ');
    if (relationshipLevel < 30) {
      buffer.writeln('초기(어색함유지)');
    } else if (relationshipLevel < 60) {
      buffer.writeln('친근(편안한대화)');
    } else if (relationshipLevel < 80) {
      buffer.writeln('친밀(깊은대화)');
    } else {
      buffer.writeln('매우친밀(특별한사이)');
    }
    
    return buffer.toString();
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
  static String _buildShortTermMemory(List<Message> messages) {
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
      
      // 감정 추출
      if (msg.content.contains('ㅠㅠ') || msg.content.contains('😭')) {
        emotions.add('sad');
      } else if (msg.content.contains('ㅋㅋ') || msg.content.contains('😄')) {
        emotions.add('happy');
      } else if (msg.content.contains('!') || msg.content.contains('대박')) {
        emotions.add('excited');
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
  static String _buildEmotionalContext(List<Message> messages) {
    final emotionalFlow = <String>[];
    
    // 최근 10개 메시지의 감정 흐름
    final recent10 = messages.length > 10 ? messages.sublist(messages.length - 10) : messages;
    
    for (final msg in recent10) {
      String emotion = 'neutral';
      if (msg.content.contains('ㅠㅠ') || msg.content.contains('😭') || msg.content.contains('슬퍼')) {
        emotion = 'sad';
      } else if (msg.content.contains('ㅋㅋ') || msg.content.contains('😄') || msg.content.contains('좋아')) {
        emotion = 'happy';
      } else if (msg.content.contains('화나') || msg.content.contains('짜증')) {
        emotion = 'angry';
      } else if (msg.content.contains('!') || msg.content.contains('대박') || msg.content.contains('미쳤')) {
        emotion = 'excited';
      }
      
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
    
    if (hasAskedWellBeing) {
      guides.add('안부중복금지');
    }
    
    if (relationshipLevel > 60) {
      guides.add('깊은대화가능');
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
    final compressed = uniqueLines
        .where((line) => !line.contains('예:') && !line.contains('Examples:'))
        .join('\n');
    
    // 3. 부가 설명 제거
    final essential = compressed
        .replaceAll(RegExp(r'\([^)]*\)'), '') // 괄호 내용 제거
        .replaceAll(RegExp(r'-{2,}'), '-') // 중복 대시 제거
        .replaceAll(RegExp(r'\s{2,}'), ' '); // 중복 공백 제거
    
    return essential;
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