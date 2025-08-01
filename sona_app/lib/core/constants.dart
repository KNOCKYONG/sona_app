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
  static const String subscriptionsCollection = 'subscriptions';
  static const String purchasesCollection = 'purchases';
  static const String conversationMemoriesCollection = 'conversation_memories';
  static const String conversationSummariesCollection = 'conversation_summaries';
  static const String userPersonaRelationshipsCollection = 'user_persona_relationships';
  static const String userProfileImagesCollection = 'user_profile_images';
  static const String consultationQualityLogsCollection = 'consultation_quality_logs';
  static const String dailyQualityStatsCollection = 'daily_quality_stats';
  static const String personaQualityStatsCollection = 'persona_quality_stats';
  static const String qualityAlertsCollection = 'quality_alerts';
  
  // Message Limits
  static const int maxMessagesInMemory = 100;
  static const int maxCacheSize = 50;
  static const int maxBatchSize = 500;
  static const int recentMessagesLimit = 10;
  
  // Token Limits
  static const int maxInputTokens = 3000;
  static const int maxOutputTokens = 300;
  static const int maxContextTokens = 1000;
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
  static const String openAIKey = String.fromEnvironment('OPENAI_API_KEY', defaultValue: '');
  static const double openAITemperature = 0.8;
  static const int openAIMaxRetries = 3;
  
  // Storage Paths
  static const String personaPhotosPath = 'personas';
  static const String userProfilePhotosPath = 'users/profiles';
  
  // Local Storage Keys
  static const String deviceIdKey = 'device_id';
  static const String swipedPersonasKey = 'swiped_personas';
  static const String lastSyncKey = 'last_sync';
  static const String cachedUserKey = 'cached_user';
  static const String cachedSubscriptionKey = 'cached_subscription';
  
  // Subscription Types
  static const String subscriptionBasic = 'basic';
  static const String subscriptionPremium = 'premium';
  static const String subscriptionVip = 'vip';
  
  // Purchase Product IDs
  static const String productIdPremium1Month = 'premium_1month';
  static const String productIdPremium3Months = 'premium_3months';
  static const String productIdPremium6Months = 'premium_6months';
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