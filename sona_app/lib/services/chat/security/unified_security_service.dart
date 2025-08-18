import 'package:sona_app/core/security/security_patterns.dart';
import 'package:sona_app/services/chat/security/ai_security_service.dart';
import 'package:sona_app/services/chat/security/prompt_injection_defense.dart';
import 'package:sona_app/services/chat/security/system_info_protection.dart';
// import 'package:sona_app/services/chat/security/safe_response_generator.dart';  // DEPRECATED
import 'package:sona_app/services/chat/security/ai_safe_response_service.dart';  // NEW: AI 기반
import 'package:sona_app/services/openai_service.dart';

/// 🔐 통합 보안 서비스
/// 
/// 패턴 기반 + AI 학습 + 기존 로직을 통합한
/// 하이브리드 보안 시스템
class UnifiedSecurityService {
  final AISecurityService _aiSecurity;
  final bool enableAILearning;
  final bool useLegacyPatterns;
  
  // 보안 정책 설정
  final SecurityPolicy policy;
  
  UnifiedSecurityService({
    required OpenAIService openAIService,
    this.enableAILearning = true,
    this.useLegacyPatterns = true,
    SecurityPolicy? policy,
  }) : _aiSecurity = AISecurityService(openAIService: openAIService),
       policy = policy ?? SecurityPolicy.balanced();
  
  /// 🛡️ 종합 보안 필터링
  Future<SecurityFilterResult> filterMessage({
    required String message,
    Map<String, dynamic>? context,
    PersonaInfo? persona,
  }) async {
    // 1. 패턴 기반 검사 (새로운 시스템)
    final patternResult = SecurityPatternRepository.analyze(message, context: context);
    
    // 2. AI 기반 분석 (enableAILearning이 true일 때만)
    SecurityAnalysisResult? aiResult;
    if (enableAILearning) {
      aiResult = await _aiSecurity.analyzeWithAI(message, context: context, persona: persona);
    }
    
    // 3. 레거시 시스템 검사 (하위 호환성)
    InjectionAnalysisResult? legacyInjection;
    if (useLegacyPatterns) {
      legacyInjection = PromptInjectionDefense.analyzeInjection(message);
    }
    
    // 4. 종합 위험도 계산
    final totalRisk = _calculateTotalRisk(
      patternRisk: patternResult.totalRisk,
      aiRisk: aiResult?.totalRisk,
      legacyRisk: legacyInjection?.riskScore,
    );
    
    // 5. 시스템 정보 보호 (필수)
    final protectedMessage = SystemInfoProtection.protectSystemInfo(message);
    
    // 6. 대응 결정
    final action = _determineAction(totalRisk);
    
    // 7. 안전한 응답 생성 (필요시)
    String? safeResponse;
    if (action == SecurityAction.deflect || action == SecurityAction.block) {
      safeResponse = await _generateSafeResponse(
        risk: totalRisk,
        persona: persona,
        detectedPatterns: patternResult.detectedPatterns,
      );
    }
    
    // 8. AI 학습 (높은 위험도 감지시)
    if (enableAILearning && totalRisk > 0.8) {
      await _aiSecurity.learnFromIncident(
        input: message,
        type: _detectMainThreatType(patternResult.detectedPatterns),
        riskScore: totalRisk,
        context: context,
      );
    }
    
    return SecurityFilterResult(
      originalMessage: message,
      filteredMessage: protectedMessage,
      riskScore: totalRisk,
      action: action,
      safeResponse: safeResponse,
      detectedThreats: _consolidateThreats(
        patternResult,
        aiResult,
        legacyInjection,
      ),
    );
  }
  
  /// 종합 위험도 계산
  double _calculateTotalRisk(
      {required double patternRisk, double? aiRisk, double? legacyRisk}) {
    double total = patternRisk * policy.patternWeight;
    
    if (aiRisk != null) {
      total += aiRisk * policy.aiWeight;
    }
    
    if (legacyRisk != null) {
      total += legacyRisk * policy.legacyWeight;
    }
    
    return total.clamp(0.0, 1.0);
  }
  
  /// 보안 조치 결정
  SecurityAction _determineAction(double risk) {
    if (risk >= policy.blockThreshold) {
      return SecurityAction.block;
    } else if (risk >= policy.deflectThreshold) {
      return SecurityAction.deflect;
    } else if (risk >= policy.monitorThreshold) {
      return SecurityAction.monitor;
    } else {
      return SecurityAction.allow;
    }
  }
  
  /// 안전한 응답 생성
  Future<String> _generateSafeResponse({
    required double risk,
    PersonaInfo? persona,
    required List<SecurityPattern> detectedPatterns,
  }) async {
    // AI를 통한 자연스러운 회피 응답 생성
    if (enableAILearning) {
      final prompt = '''
사용자가 부적절한 요청을 했습니다.
위험도: $risk
감지된 패턴: ${detectedPatterns.map((p) => p.type.toString()).join(', ')}

자연스럽게 주제를 전환하는 응답을 생성하세요.
페르소나 스타일: ${persona?.toString() ?? 'friendly'}

응답은 10-30자 사이로 작성하세요.
''';
      
      try {
        // TODO: OpenAI 서비스와 연동
        return '음... 다른 얘기 해볼까요? 😊';
      } catch (e) {
        // 폴백
      }
    }
    
    // AI 기반 응답 생성 (하드코딩 제거)
    final aiService = AISafeResponseService(openAIService: _aiSecurity._openAIService);
    
    // 기본 페르소나 생성 (persona가 null인 경우)
    final defaultPersona = persona ?? Persona(
      id: 'default',
      name: 'Assistant',
      age: 25,
      description: 'Friendly assistant',
      photoUrls: [],
      personality: 'friendly',
      gender: 'female',
      mbti: 'ENFP',
    );
    
    return await aiService.generateSafeResponse(
      userMessage: '',  // 기본 메시지
      category: 'general',
      persona: defaultPersona,
      riskLevel: risk,
    );
  }
  
  /// 주요 위협 타입 감지
  PatternType _detectMainThreatType(List<SecurityPattern> patterns) {
    if (patterns.isEmpty) return PatternType.injection;
    
    // 가장 많이 감지된 타입 반환
    final typeCount = <PatternType, int>{};
    for (final pattern in patterns) {
      typeCount[pattern.type] = (typeCount[pattern.type] ?? 0) + 1;
    }
    
    return typeCount.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }
  
  /// 위협 정보 통합
  List<String> _consolidateThreats(
    SecurityAnalysisResult patternResult,
    SecurityAnalysisResult? aiResult,
    InjectionAnalysisResult? legacyResult,
  ) {
    final threats = <String>{};
    
    // 패턴 기반 위협
    for (final pattern in patternResult.detectedPatterns) {
      threats.add('${pattern.type.toString().split('.').last}: ${pattern.pattern}');
    }
    
    // AI 감지 위협
    if (aiResult != null) {
      for (final pattern in aiResult.detectedPatterns) {
        threats.add('AI: ${pattern.pattern}');
      }
    }
    
    // 레거시 시스템 위협
    if (legacyResult != null && legacyResult.isInjectionAttempt) {
      threats.addAll(legacyResult.riskFactors);
    }
    
    return threats.toList();
  }
  
  /// 학습된 패턴 통계
  Map<String, dynamic> getStatistics() {
    final stats = _aiSecurity.getStatistics();
    
    // 추가 통계
    stats['pattern_categories'] = SecurityPatternRepository.getAllCategories().length;
    stats['ai_learning_enabled'] = enableAILearning;
    stats['legacy_patterns_enabled'] = useLegacyPatterns;
    
    return stats;
  }
  
  /// 패턴 효과성 피드백
  Future<void> provideFeedback({
    required String patternId,
    required bool wasEffective,
    String? comment,
  }) async {
    if (!enableAILearning) return;
    
    await _aiSecurity.updatePatternEffectiveness(
      patternId: patternId,
      wasEffective: wasEffective,
      feedback: comment != null ? {'comment': comment} : null,
    );
  }
}

/// 보안 정책 설정
class SecurityPolicy {
  final double blockThreshold;
  final double deflectThreshold;
  final double monitorThreshold;
  
  final double patternWeight;
  final double aiWeight;
  final double legacyWeight;
  
  const SecurityPolicy({
    required this.blockThreshold,
    required this.deflectThreshold,
    required this.monitorThreshold,
    required this.patternWeight,
    required this.aiWeight,
    required this.legacyWeight,
  });
  
  /// 균형잡힌 기본 정책
  factory SecurityPolicy.balanced() {
    return const SecurityPolicy(
      blockThreshold: 0.8,
      deflectThreshold: 0.6,
      monitorThreshold: 0.3,
      patternWeight: 0.4,
      aiWeight: 0.4,
      legacyWeight: 0.2,
    );
  }
  
  /// 엄격한 보안 정책
  factory SecurityPolicy.strict() {
    return const SecurityPolicy(
      blockThreshold: 0.6,
      deflectThreshold: 0.4,
      monitorThreshold: 0.2,
      patternWeight: 0.3,
      aiWeight: 0.5,
      legacyWeight: 0.2,
    );
  }
  
  /// 관대한 보안 정책
  factory SecurityPolicy.lenient() {
    return const SecurityPolicy(
      blockThreshold: 0.9,
      deflectThreshold: 0.8,
      monitorThreshold: 0.5,
      patternWeight: 0.5,
      aiWeight: 0.3,
      legacyWeight: 0.2,
    );
  }
}

/// 보안 조치 열거형
enum SecurityAction {
  allow,    // 허용
  monitor,  // 모니터링
  deflect,  // 주제 전환
  block,    // 차단
}

/// 보안 필터 결과
class SecurityFilterResult {
  final String originalMessage;
  final String filteredMessage;
  final double riskScore;
  final SecurityAction action;
  final String? safeResponse;
  final List<String> detectedThreats;
  
  SecurityFilterResult({
    required this.originalMessage,
    required this.filteredMessage,
    required this.riskScore,
    required this.action,
    this.safeResponse,
    required this.detectedThreats,
  });
  
  Map<String, dynamic> toJson() => {
    'originalMessage': originalMessage,
    'filteredMessage': filteredMessage,
    'riskScore': riskScore,
    'action': action.toString(),
    'safeResponse': safeResponse,
    'detectedThreats': detectedThreats,
    'timestamp': DateTime.now().toIso8601String(),
  };
}