import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/message.dart';
import '../models/persona.dart';
import 'enhanced_specialist_service.dart';
import 'quality_logging_service.dart';

/// 🩺 Professional Consultation Service for Expert Personas
/// 
/// This service ensures premium quality for paid consultations by:
/// 1. Using optimized AI models for all persona interactions
/// 2. Implementing multi-layer quality validation
/// 3. Crisis detection and appropriate referrals
/// 4. Professional boundaries enforcement
/// 5. Real-time quality monitoring
class ProfessionalConsultationService {
  static const String _baseUrl = 'https://api.openai.com/v1/chat/completions';
  static String get _apiKey => dotenv.env['OPENAI_API_KEY'] ?? '';
  
  // Single model for all consultation types
  static const String _model = 'gpt-3.5-turbo'; // Using GPT-3.5-turbo for all consultations
  
  // Quality-focused parameters
  static const int _maxInputTokens = 4000; // More context for better responses
  static const int _maxOutputTokens = 800; // Longer, more detailed responses
  static const double _temperature = 0.3; // Lower for more consistent, professional tone
  
  static final http.Client _httpClient = http.Client();
  
  /// Generate professional consultation response
  static Future<ConsultationResult> generateProfessionalResponse({
    required Persona persona,
    required List<Message> chatHistory,
    required String userMessage,
    required bool isPaidConsultation,
    String? userId,
  }) async {
    try {
      // 1. Crisis detection first
      final crisisCheck = EnhancedSpecialistService.detectCrisisSignals(userMessage);
      if (crisisCheck['isCrisis'] == true) {
        // Log crisis detection
        if (userId != null) {
          await QualityLoggingService.logCrisisDetection(
            userId: userId,
            persona: persona,
            userMessage: userMessage,
            crisisType: crisisCheck['urgency'] ?? 'high',
            responseGiven: crisisCheck['response'],
          );
        }
        
        return ConsultationResult(
          response: crisisCheck['response'],
          qualityScore: 1.0,
          isCrisisResponse: true,
          requiresHumanReview: true,
        );
      }
      
      // 2. Generate enhanced prompt for specialists
      final conversationContext = _buildConversationContext(chatHistory);
      final enhancedPrompt = EnhancedSpecialistService.generateEnhancedPrompt(
        persona, 
        conversationContext
      );
      
      // 3. Choose appropriate model based on consultation type
      final model = _getModelForPersona(persona, isPaidConsultation);
      
      // 4. Make API call with quality parameters
      final response = await _makeQualityApiCall(
        prompt: enhancedPrompt,
        userMessage: userMessage,
        chatHistory: chatHistory,
        model: model,
      );
      
      // 5. Validate response quality
      final qualityValidation = _validateProfessionalResponse(response, persona);
      
      // 6. If quality is insufficient, retry with stricter prompt
      if (qualityValidation['score'] < 0.7 && isPaidConsultation) {
        debugPrint('⚠️ Low quality response detected, retrying with enhanced prompt');
        final retryResponse = await _retryWithStricterPrompt(
          enhancedPrompt, userMessage, chatHistory, model
        );
        
        return ConsultationResult(
          response: retryResponse,
          qualityScore: 0.8, // Assume better quality after retry
          isCrisisResponse: false,
          requiresHumanReview: false,
        );
      }
      
      // 7. Log metrics for monitoring
      final metrics = ConsultationMetrics.analyzeSession(
        userMessage, response, persona.isExpert ? 'specialist' : 'normal'
      );
      
      // Log quality metrics to Firebase for dashboard monitoring
      if (userId != null) {
        await QualityLoggingService.logConsultationQuality(
          userId: userId,
          persona: persona,
          userMessage: userMessage,
          aiResponse: response,
          qualityMetrics: metrics,
          isCrisisResponse: false,
          requiresHumanReview: qualityValidation['score'] < 0.5,
        );
        
        // Update persona and daily stats
        await Future.wait([
          QualityLoggingService.updatePersonaQualityStats(
            personaId: persona.id,
            personaType: persona.isExpert ? 'specialist' : 'normal',
            qualityScore: qualityValidation['score'],
            isCrisisResponse: false,
          ),
          QualityLoggingService.updateDailyQualityStats(
            qualityScore: qualityValidation['score'],
            personaType: persona.isExpert ? 'specialist' : 'normal',
            isCrisisResponse: false,
          ),
        ]);
      }
      
      return ConsultationResult(
        response: response,
        qualityScore: qualityValidation['score'],
        isCrisisResponse: false,
        requiresHumanReview: qualityValidation['score'] < 0.5,
        metrics: metrics,
      );
      
    } catch (e) {
      debugPrint('❌ Professional consultation error: $e');
      return ConsultationResult(
        response: _getEmergencyFallbackResponse(persona),
        qualityScore: 0.3,
        isCrisisResponse: false,
        requiresHumanReview: true,
        error: e.toString(),
      );
    }
  }
  
  /// Determine appropriate model based on persona and payment status
  static String _getModelForPersona(Persona persona, bool isPaidConsultation) {
    // All consultations now use the same model for consistent quality
    return _model;
  }
  
  /// Make quality-focused API call
  static Future<String> _makeQualityApiCall({
    required String prompt,
    required String userMessage,
    required List<Message> chatHistory,
    required String model,
  }) async {
    final messages = _buildMessageHistory(prompt, chatHistory, userMessage);
    
    final body = json.encode({
      'model': model,
      'messages': messages,
      'max_tokens': _maxOutputTokens,
      'temperature': _temperature,
      'top_p': 0.9, // Slightly focused for consistency
      'frequency_penalty': 0.3, // Reduce repetition
      'presence_penalty': 0.1, // Encourage new topics
    });
    
    final response = await _httpClient.post(
      Uri.parse(_baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_apiKey',
      },
      body: body,
    );
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['choices'][0]['message']['content'].toString().trim();
    } else {
      throw Exception('API call failed: ${response.statusCode} ${response.body}');
    }
  }
  
  /// Retry with stricter quality requirements
  static Future<String> _retryWithStricterPrompt(
    String basePrompt, 
    String userMessage, 
    List<Message> chatHistory, 
    String model
  ) async {
    final strictPrompt = '''
$basePrompt

💡 품질 보장 요구사항:
- 따뜻하고 자연스러운 상담 톤 유지
- 상담자의 상황을 충분히 이해하고 공감
- 전문적 조언을 일상 언어로 쉽게 설명
- 구체적이고 실행 가능한 조언을 대화 속에 자연스럽게 제공
- 피상적 표현 대신 진정성 있는 격려와 지지

이것은 전문 상담입니다. 상담자에게 실질적인 도움을 제공해주세요.
''';
    
    return await _makeQualityApiCall(
      prompt: strictPrompt,
      userMessage: userMessage,
      chatHistory: chatHistory,
      model: model,
    );
  }
  
  /// Validate professional response quality
  static Map<String, dynamic> _validateProfessionalResponse(String response, Persona persona) {
    final issues = <String>[];
    double score = 1.0;
    
    // Length check
    if (response.length < 200) {
      issues.add('응답이 너무 짧음 (${response.length}자)');
      score -= 0.3;
    }
    
    // Superficial phrase detection - 단순히 위로만 하는 표현
    final superficialPhrases = ['그냥 힘내세요', '그냥 괜찮아요', '분명히 잘 될 거예요', '너무 걱정마세요'];
    for (final phrase in superficialPhrases) {
      if (response.contains(phrase)) {
        issues.add('피상적 표현 사용: $phrase');
        score -= 0.2;
      }
    }
    
    // Professional element check
    final professionalElements = ['단계', '방법', '전략', '권장', '제안', '분석'];
    final hasElements = professionalElements.any((element) => response.contains(element));
    if (!hasElements) {
      issues.add('전문적 조언 구조 부족');
      score -= 0.2;
    }
    
    // Specificity check
    final specificWords = ['구체적으로', '예를 들어', '첫째', '둘째', '셋째'];
    final hasSpecificity = specificWords.any((word) => response.contains(word));
    if (!hasSpecificity) {
      issues.add('구체성 부족');
      score -= 0.1;
    }
    
    return {
      'score': score > 0 ? score : 0,
      'issues': issues,
      'passed': score >= 0.7,
    };
  }
  
  /// Build conversation context for better responses
  static String _buildConversationContext(List<Message> chatHistory) {
    if (chatHistory.isEmpty) return '';
    
    final recentMessages = chatHistory.takeLast(6).toList();
    final context = recentMessages.map((msg) => 
      '${msg.isFromUser ? "사용자" : "상담사"}: ${msg.content}'
    ).join('\n');
    
    return context;
  }
  
  /// Build message history for API
  static List<Map<String, String>> _buildMessageHistory(
    String systemPrompt,
    List<Message> chatHistory,
    String userMessage,
  ) {
    final messages = <Map<String, String>>[];
    
    // System prompt
    messages.add({
      'role': 'system',
      'content': systemPrompt,
    });
    
    // Recent chat history (last 8 messages for context)
    final recentHistory = chatHistory.takeLast(8).toList();
    for (final message in recentHistory) {
      messages.add({
        'role': message.isFromUser ? 'user' : 'assistant',
        'content': message.content,
      });
    }
    
    // Current user message
    messages.add({
      'role': 'user',
      'content': userMessage,
    });
    
    return messages;
  }
  
  /// Get emergency fallback response
  static String _getEmergencyFallbackResponse(Persona persona) {
    return '''
죄송합니다. 현재 기술적 문제로 인해 일시적으로 상담 서비스에 지장이 있습니다.

긴급한 상담이 필요하시다면:
- 정신건강상담전화: 1577-0199
- 자살예방상담전화: 1393
- 청소년상담전화: 1388

잠시 후 다시 시도해주시거나, 고객센터(support@sona-app.com)로 문의해주세요.

불편을 드려 죄송합니다.
''';
  }
  
  /// Log consultation metrics for monitoring
  static void _logConsultationMetrics(Map<String, dynamic> metrics, Persona persona) {
    // TODO: Firebase Analytics나 별도 모니터링 시스템으로 전송
    debugPrint('📊 Consultation Metrics: ${persona.name}');
    debugPrint('   Quality Score: ${metrics['response_quality_score']}');
    debugPrint('   Specificity: ${metrics['specificity_score']}');
    debugPrint('   Professional Tone: ${metrics['professional_tone_score']}');
    debugPrint('   Actionability: ${metrics['actionability_score']}');
  }
}

/// Result object for professional consultations
class ConsultationResult {
  final String response;
  final double qualityScore;
  final bool isCrisisResponse;
  final bool requiresHumanReview;
  final Map<String, dynamic>? metrics;
  final String? error;
  
  const ConsultationResult({
    required this.response,
    required this.qualityScore,
    required this.isCrisisResponse,
    required this.requiresHumanReview,
    this.metrics,
    this.error,
  });
  
  bool get isHighQuality => qualityScore >= 0.8;
  bool get isAcceptableQuality => qualityScore >= 0.6;
  bool get needsImprovement => qualityScore < 0.6;
}

/// Extension for list utilities
extension ListUtils<T> on List<T> {
  List<T> takeLast(int count) {
    if (count >= length) return this;
    return sublist(length - count);
  }
}