import 'package:flutter_dotenv/flutter_dotenv.dart';

/// 앱 전체에서 사용되는 상수값 중앙 관리
class AppConstants {
  // Private constructor
  AppConstants._();

  // Firebase Collections
  static const String usersCollection = 'users';
  static const String personasCollection = 'personas';
  static const String messagesCollection = 'messages';
  static const String chatsCollection = 'chats';
  static const String matchesCollection = 'matches';
  static const String swipesCollection = 'swipes';
  static const String purchasesCollection = 'purchases';
  static const String conversationMemoriesCollection = 'conversation_memories';
  static const String conversationSummariesCollection =
      'conversation_summaries';
  static const String userPersonaRelationshipsCollection =
      'user_persona_relationships';
  static const String userProfileImagesCollection = 'user_profile_images';
  static const String consultationQualityLogsCollection =
      'consultation_quality_logs';
  static const String dailyQualityStatsCollection = 'daily_quality_stats';
  static const String personaQualityStatsCollection = 'persona_quality_stats';
  static const String qualityAlertsCollection = 'quality_alerts';

  // Message Limits
  static const int maxMessagesInMemory = 30; // 초기 로딩 속도 개선을 위해 축소
  static const int messagesPerPage = 20; // 추가 로드 시 가져올 메시지 수
  static const int maxCacheSize = 50;
  static const int maxBatchSize = 500;
  static const int recentMessagesLimit = 50;
  static const int dailyMessageLimit = 100;
  static const int dailyMessageWarningThreshold = 10;
  
  // Guest Mode Limits
  static const int guestDailyMessageLimit = 20;
  static const int guestInitialHearts = 1;
  static const int guestSessionDurationHours = 24;
  static const int guestWarningThreshold = 5;

  // Token Limits
  static const int maxInputTokens = 3000;
  static const int maxOutputTokens = 200;
  static const int maxContextTokens = 1500; // 1000 -> 1500으로 증가하여 더 많은 대화 기억
  static const double tokensPerCharacterKorean = 1.5;

  // Time Durations
  static const Duration cacheDuration = Duration(minutes: 5);
  static const Duration batchWriteDuration = Duration(seconds: 2);
  static const Duration batchDelay = Duration(milliseconds: 100);
  static const Duration typingDelay = Duration(milliseconds: 50);
  static const Duration typingTimeout = Duration(minutes: 1);
  static const Duration heartCooldownDuration = Duration(minutes: 30);

  // API Configuration
  static const String openAIModel = 'gpt-4o-mini';
  static String get openAIKey => dotenv.env['OPENAI_API_KEY'] ?? '';
  static const double openAITemperature = 0.8;
  static const int openAIMaxRetries = 3;

  // Storage Paths
  static const String personaPhotosPath = 'personas';
  static const String userProfilePhotosPath = 'users/profiles';

  // Local Storage Keys
  static const String deviceIdKey = 'device_id';
  static const String swipedPersonasKey = 'swiped_personas';
  static const String lastSyncKey = 'last_sync';
  static const String languageCodeKey = 'language_code';
  static const String useSystemLanguageKey = 'use_system_language';
  static const String cachedUserKey = 'cached_user';
  static const String cachedSubscriptionKey = 'cached_subscription';
  
  // Guest Mode Storage Keys
  static const String isGuestUserKey = 'is_guest_user';
  static const String guestSessionStartKey = 'guest_session_start';
  static const String guestMessageCountKey = 'guest_message_count';
  static const String guestChatHistoryKey = 'guest_chat_history';

  // Purchase Product IDs
  static const String productIdHearts30 = 'hearts_30';
  static const String productIdHearts50 = 'hearts_50';
  static const String productIdHearts100 = 'hearts_100';

  // Relationship Score Thresholds
  static const int relationshipFriend = 0;
  static const int relationshipSome = 200;
  static const int relationshipLover = 600;
  static const int relationshipComplete = 900;
  static const int relationshipMax = 1000;

  // Quality Thresholds
  static const double qualityScoreThreshold = 0.8;
  static const double importanceThreshold = 0.7;

  // Image Compression
  static const int imageQuality = 85;
  static const int maxImageWidth = 1080;
  static const int maxImageHeight = 1920;

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
}
