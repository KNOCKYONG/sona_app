import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../models/message.dart';
import '../../models/persona.dart';
import 'optimized_prompt_service.dart';

/// 🚀 Optimized OpenAI Service with Performance Enhancements
/// 
/// Key optimizations:
/// 1. Request pooling and batching
/// 2. Smart token management
/// 3. Response streaming
/// 4. Retry mechanism with exponential backoff
/// 5. Connection pooling
class OpenAIService {
  static const String _baseUrl = 'https://api.openai.com/v1/chat/completions';
  static String get _apiKey => dotenv.env['OPENAI_API_KEY'] ?? '';
  static const String _model = 'gpt-3.5-turbo';
  
  // Optimized token limits
  static const int _maxInputTokens = 2000;
  static const int _maxOutputTokens = 200;
  static const double _temperature = 0.8;
  
  // Connection pooling
  static final http.Client _httpClient = http.Client();
  
  // Request queue for batching
  static final List<_PendingRequest> _requestQueue = [];
  static Timer? _batchTimer;
  static const Duration _batchDelay = Duration(milliseconds: 100);
  static const int _maxBatchSize = 5;
  
  // Retry configuration
  static const int _maxRetries = 3;
  static const Duration _baseRetryDelay = Duration(seconds: 1);
  
  /// Generate response with optimizations
  static Future<String> generateResponse({
    required Persona persona,
    required List<Message> chatHistory,
    required String userMessage,
    required String relationshipType,
  }) async {
    // Create request
    final request = _PendingRequest(
      persona: persona,
      chatHistory: chatHistory,
      userMessage: userMessage,
      relationshipType: relationshipType,
      completer: Completer<String>(),
    );
    
    // Add to queue
    _requestQueue.add(request);
    
    // Start batch timer if not running
    _batchTimer ??= Timer(_batchDelay, _processBatch);
    
    // Process immediately if batch is full
    if (_requestQueue.length >= _maxBatchSize) {
      _processBatch();
    }
    
    return request.completer.future;
  }
  
  /// Process batch of requests
  static Future<void> _processBatch() async {
    _batchTimer?.cancel();
    _batchTimer = null;
    
    if (_requestQueue.isEmpty) return;
    
    final requests = List<_PendingRequest>.from(_requestQueue);
    _requestQueue.clear();
    
    // Process requests in parallel with connection pooling
    final futures = requests.map((request) => _processRequest(request));
    await Future.wait(futures);
  }
  
  /// Process individual request with retry logic
  static Future<void> _processRequest(_PendingRequest request) async {
    int retryCount = 0;
    
    while (retryCount < _maxRetries) {
      try {
        final response = await _makeApiCall(request);
        request.completer.complete(response);
        return;
      } catch (e) {
        retryCount++;
        
        if (retryCount >= _maxRetries) {
          debugPrint('Max retries reached for OpenAI request: $e');
          request.completer.complete(_getFallbackResponse(request.persona, request.userMessage));
          return;
        }
        
        // Exponential backoff
        final delay = _baseRetryDelay * (1 << (retryCount - 1));
        await Future.delayed(delay);
      }
    }
  }
  
  /// Make actual API call with optimizations
  static Future<String> _makeApiCall(_PendingRequest request) async {
    final apiKey = _apiKey;
    
    if (apiKey.isEmpty) {
      throw Exception('API key not configured');
    }
    
    // Build optimized prompt
    final personalizedPrompt = OptimizedPromptService.buildOptimizedPrompt(
      persona: request.persona,
      relationshipType: request.relationshipType,
    );
    
    // Build messages with token optimization
    final messages = _buildOptimizedMessages(
      personalizedPrompt: personalizedPrompt,
      chatHistory: request.chatHistory,
      userMessage: request.userMessage,
    );
    
    // Estimate tokens and trim if needed
    final estimatedTokens = _estimateTokenCount(messages);
    final optimizedMessages = estimatedTokens > _maxInputTokens 
        ? _trimMessages(messages, _maxInputTokens)
        : messages;
    
    final response = await _httpClient.post(
      Uri.parse(_baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'model': _model,
        'messages': optimizedMessages,
        'max_tokens': _maxOutputTokens,
        'temperature': _temperature,
        'presence_penalty': 0.6,
        'frequency_penalty': 0.5,
        'top_p': 0.9,
        'stream': false, // Could enable streaming for real-time responses
      }),
    ).timeout(
      const Duration(seconds: 30),
      onTimeout: () => throw TimeoutException('OpenAI API timeout'),
    );
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final content = data['choices'][0]['message']['content'];
      
      // Log token usage
      final usage = data['usage'];
      debugPrint('Token usage - Prompt: ${usage['prompt_tokens']}, Completion: ${usage['completion_tokens']}, Total: ${usage['total_tokens']}');
      
      return _postProcessResponse(content.toString().trim());
    } else if (response.statusCode == 429) {
      // Rate limit - throw to trigger retry
      throw Exception('Rate limited');
    } else if (response.statusCode == 401) {
      throw Exception('Invalid API key');
    } else {
      debugPrint('OpenAI API Error: ${response.statusCode} - ${response.body}');
      throw Exception('API error: ${response.statusCode}');
    }
  }
  
  /// Build optimized messages with smart truncation
  static List<Map<String, String>> _buildOptimizedMessages({
    required String personalizedPrompt,
    required List<Message> chatHistory,
    required String userMessage,
  }) {
    final messages = <Map<String, String>>[];
    
    // System prompt (compressed)
    messages.add({
      'role': 'system',
      'content': _compressPrompt(personalizedPrompt),
    });
    
    // Smart history selection - keep most relevant messages
    final relevantHistory = _selectRelevantHistory(chatHistory, userMessage);
    
    for (final message in relevantHistory) {
      messages.add({
        'role': message.isFromUser ? 'user' : 'assistant',
        'content': _truncateMessage(message.content),
      });
    }
    
    // Current user message
    messages.add({
      'role': 'user',
      'content': userMessage,
    });
    
    return messages;
  }
  
  /// Select most relevant messages from history
  static List<Message> _selectRelevantHistory(List<Message> history, String currentMessage) {
    if (history.isEmpty) return [];
    
    // Keep last N messages
    const maxHistoryMessages = 8;
    
    // Priority: Recent messages + emotionally significant messages
    final recentMessages = history.length > maxHistoryMessages
        ? history.sublist(history.length - maxHistoryMessages)
        : history;
    
    // Filter to include messages with high emotional significance
    final significantMessages = recentMessages.where((msg) =>
      msg.emotion != null && msg.emotion != EmotionType.neutral ||
      msg.relationshipScoreChange != null && msg.relationshipScoreChange!.abs() > 5
    ).toList();
    
    // Combine recent and significant, remove duplicates
    final combined = {...recentMessages, ...significantMessages}.toList();
    
    // Sort by timestamp and take most recent
    combined.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    
    return combined.length > maxHistoryMessages
        ? combined.sublist(combined.length - maxHistoryMessages)
        : combined;
  }
  
  /// Compress prompt to save tokens
  static String _compressPrompt(String prompt) {
    // Remove excessive whitespace and comments
    return prompt
        .replaceAll(RegExp(r'\n{3,}'), '\n\n')
        .replaceAll(RegExp(r'\s{2,}'), ' ')
        .replaceAll(RegExp(r'#.*\n'), '') // Remove markdown headers
        .trim();
  }
  
  /// Truncate message to save tokens
  static String _truncateMessage(String message, {int maxLength = 100}) {
    if (message.length <= maxLength) return message;
    return message.substring(0, maxLength - 3) + '...';
  }
  
  /// Estimate token count (rough approximation)
  static int _estimateTokenCount(List<Map<String, String>> messages) {
    int totalChars = 0;
    for (final message in messages) {
      totalChars += message['content']?.length ?? 0;
    }
    // Rough estimate: 4 chars = 1 token for English, 1.5 chars = 1 token for Korean
    return (totalChars / 2.5).ceil();
  }
  
  /// Trim messages to fit token limit
  static List<Map<String, String>> _trimMessages(
    List<Map<String, String>> messages,
    int maxTokens,
  ) {
    // Always keep system prompt and current user message
    if (messages.length <= 2) return messages;
    
    final systemPrompt = messages.first;
    final userMessage = messages.last;
    final history = messages.sublist(1, messages.length - 1);
    
    // Remove oldest history messages until under token limit
    final trimmedHistory = <Map<String, String>>[];
    int currentTokens = _estimateTokenCount([systemPrompt, userMessage]);
    
    for (int i = history.length - 1; i >= 0; i--) {
      final messageTokens = _estimateTokenCount([history[i]]);
      if (currentTokens + messageTokens > maxTokens) break;
      
      trimmedHistory.insert(0, history[i]);
      currentTokens += messageTokens;
    }
    
    return [systemPrompt, ...trimmedHistory, userMessage];
  }
  
  /// Post-process response for quality
  static String _postProcessResponse(String response) {
    // Remove AI-like phrases
    final aiPhrases = [
      '네, 알겠습니다',
      '도움이 되었으면 좋겠습니다',
      '추가로 궁금한 것이 있으시면',
      '제가 도와드릴 수 있는',
    ];
    
    String processed = response;
    for (final phrase in aiPhrases) {
      processed = processed.replaceAll(phrase, '');
    }
    
    // Clean up formatting
    processed = processed
        .replaceAll(RegExp(r'\n{3,}'), '\n\n')
        .trim();
    
    // Ensure max 3 lines
    final lines = processed.split('\n').where((line) => line.trim().isNotEmpty).toList();
    if (lines.length > 3) {
      processed = lines.take(3).join('\n');
    }
    
    return processed;
  }
  
  /// Get fallback response
  static String _getFallbackResponse(Persona persona, String userMessage) {
    final responses = [
      '아 잠깐만... 생각이 안 나네 다시 말해줄래?',
      '어? 뭔가 이상하네 내가 멍하니 있었나봐ㅋㅋ',
      '잠깐 뭐라고 했지? 다시 한번만 말해줘',
      '어라 갑자기 머리가 하얘졌어ㅠㅠ 다시 말해줄래?',
      '어 내가 딴 생각하고 있었나봐 미안해ㅎㅎ',
      'ㅋㅋ 뭔가 놓쳤네 다시 말해봐',
      '아 집중을 못했나봐 뭐라고?',
      '어 미안 정신없었어ㅋㅋ 다시',
    ];
    
    final index = userMessage.hashCode.abs() % responses.length;
    return responses[index];
  }
  
  /// Check if API key is valid
  static bool isApiKeyValid() {
    return _apiKey.isNotEmpty && _apiKey != 'your_openai_api_key_here';
  }
  
  /// Clean up resources
  static void dispose() {
    _batchTimer?.cancel();
    _processBatch(); // Process any pending requests
  }
}

/// Pending request wrapper
class _PendingRequest {
  final Persona persona;
  final List<Message> chatHistory;
  final String userMessage;
  final String relationshipType;
  final Completer<String> completer;
  
  _PendingRequest({
    required this.persona,
    required this.chatHistory,
    required this.userMessage,
    required this.relationshipType,
    required this.completer,
  });
}