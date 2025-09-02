// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get about => 'About';

  @override
  String get accountAndProfile => 'Account & Profile Information';

  @override
  String get accountDeletedSuccess => 'Account deleted successfully';

  @override
  String get accountDeletionContent =>
      'Are you sure you want to delete your account?\nThis action cannot be undone.';

  @override
  String get accountDeletionError => 'Error occurred while deleting account.';

  @override
  String get accountDeletionInfo => 'Account deletion information';

  @override
  String get accountDeletionTitle => 'Delete Account';

  @override
  String get accountDeletionWarning1 => 'Warning: This action cannot be undone';

  @override
  String get accountDeletionWarning2 =>
      'All your data will be permanently deleted';

  @override
  String get accountDeletionWarning3 =>
      'You will lose access to all conversations';

  @override
  String get accountDeletionWarning4 => 'This includes all purchased content';

  @override
  String get accountManagement => 'Account Management';

  @override
  String get adaptiveConversationDesc =>
      'Adapts conversation style to match yours';

  @override
  String get afternoon => 'Afternoon';

  @override
  String get afternoonFatigue => 'Afternoon fatigue';

  @override
  String get ageConfirmation =>
      'I am 14 years or older and have confirmed the above.';

  @override
  String ageRange(int min, int max) {
    return '$min-$max years old';
  }

  @override
  String get ageUnit => 'years old';

  @override
  String get agreeToTerms => 'I agree to the terms';

  @override
  String get aiDatingQuestion =>
      'A special daily life with AI\nMeet your own personas.';

  @override
  String get aiPersonaPreferenceDescription =>
      'Please set your preferences for AI persona matching';

  @override
  String get all => 'All';

  @override
  String get allAgree => 'Agree to All';

  @override
  String get allFeaturesRequired =>
      '※ All features are required for service provision';

  @override
  String get allPersonas => 'All Personas';

  @override
  String get allPersonasMatched =>
      'All personas matched! Start chatting with them.';

  @override
  String get allowPermission => 'Continue';

  @override
  String alreadyChattingWith(String name) {
    return 'Already chatting with $name!';
  }

  @override
  String get alsoBlockThisAI => 'Also block this AI';

  @override
  String get angry => 'Angry';

  @override
  String get anonymousLogin => 'Anonymous login';

  @override
  String get anxious => 'Anxious';

  @override
  String get apiKeyError => 'API Key Error';

  @override
  String get appName => 'SONA';

  @override
  String get appTagline => 'Your AI companions';

  @override
  String get appleLoginCanceled =>
      'Apple login was canceled.\nPlease try again.';

  @override
  String get appleLoginError => 'Error occurred during Apple login.';

  @override
  String get art => 'Art';

  @override
  String get authError => 'Authentication Error';

  @override
  String get autoTranslate => 'Auto Translate';

  @override
  String get autumn => 'Autumn';

  @override
  String get averageQuality => 'Average Quality';

  @override
  String get averageQualityScore => 'Average Quality Score';

  @override
  String get awkwardExpression => 'Awkward Expression';

  @override
  String get backButton => 'Back';

  @override
  String get basicInfo => 'Basic Information';

  @override
  String get basicInfoDescription =>
      'Please enter basic information to create an account';

  @override
  String get birthDate => 'Birth Date';

  @override
  String get birthDateOptional => 'Birth Date (Optional)';

  @override
  String get birthDateRequired => 'Birth Date *';

  @override
  String get blockConfirm =>
      'Do you want to block this AI?\nBlocked AIs will be excluded from matching and chat list.';

  @override
  String get blockReason => 'Block reason';

  @override
  String get blockThisAI => 'Block this AI';

  @override
  String blockedAICount(int count) {
    return '$count blocked AIs';
  }

  @override
  String get blockedAIs => 'Blocked AIs';

  @override
  String get blockedAt => 'Blocked at';

  @override
  String get blockedSuccessfully => 'Blocked successfully';

  @override
  String get breakfast => 'Breakfast';

  @override
  String get byErrorType => 'By Error Type';

  @override
  String get byPersona => 'By Persona';

  @override
  String cacheDeleteError(String error) {
    return 'Error deleting cache: $error';
  }

  @override
  String get cacheDeleted => 'Image cache has been deleted';

  @override
  String get cafeTerrace => 'Cafe terrace';

  @override
  String get calm => 'Calm';

  @override
  String get cameraPermission => 'Camera Permission';

  @override
  String get cameraPermissionDesc =>
      'Camera access is required to take profile photos.';

  @override
  String get canChangeInSettings => 'You can change this later in settings';

  @override
  String get canMeetPreviousPersonas =>
      'You can meet personas\nyou swiped before again!';

  @override
  String get cancel => 'Cancel';

  @override
  String get changeProfilePhoto => 'Change Profile Photo';

  @override
  String get chat => 'Chat';

  @override
  String get chatEndedMessage => 'Chat has ended';

  @override
  String get chatErrorDashboard => 'Chat Error Dashboard';

  @override
  String get chatErrorSentSuccessfully =>
      'Chat error has been sent successfully.';

  @override
  String get chatListTab => 'Chat List Tab';

  @override
  String get chats => 'Chats';

  @override
  String chattingWithPersonas(int count) {
    return 'Chatting with $count personas';
  }

  @override
  String get checkInternetConnection => 'Please check your internet connection';

  @override
  String get checkingUserInfo => 'Checking user info';

  @override
  String get childrensDay => 'Children\'s Day';

  @override
  String get chinese => 'Chinese';

  @override
  String get chooseOption => 'Please choose:';

  @override
  String get christmas => 'Christmas';

  @override
  String get close => 'Close';

  @override
  String get complete => 'Complete!';

  @override
  String get completeSignup => 'Complete Sign Up';

  @override
  String get confirm => 'Confirm';

  @override
  String get connectingToServer => 'Connecting to server';

  @override
  String get consultQualityMonitoring => 'Consultation Quality Monitoring';

  @override
  String get continueAsGuest => 'Continue as Guest';

  @override
  String get continueButton => 'Continue';

  @override
  String get continueWithApple => 'Continue with Apple';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get conversationContinuity => 'Conversation Continuity';

  @override
  String get conversationContinuityDesc =>
      'Remember previous conversations and connect topics';

  @override
  String conversationWith(String name) {
    return '$name';
  }

  @override
  String get convertToMember => 'Sign Up';

  @override
  String get cooking => 'Cooking';

  @override
  String get copyMessage => 'Copy message';

  @override
  String get copyrightInfringement => 'Copyright infringement';

  @override
  String get creatingAccount => 'Creating account';

  @override
  String get crisisDetected => 'Crisis Detected';

  @override
  String get culturalIssue => 'Cultural Issue';

  @override
  String get current => 'Current';

  @override
  String get currentCacheSize => 'Current Cache Size';

  @override
  String get currentLanguage => 'Current Language';

  @override
  String get cycling => 'Cycling';

  @override
  String get dailyCare => 'Daily Care';

  @override
  String get dailyCareDesc => 'Daily care messages for meals, sleep, health';

  @override
  String get dailyChat => 'Daily Chat';

  @override
  String get dailyCheck => 'Daily check';

  @override
  String get dailyConversation => 'Daily Conversation';

  @override
  String get dailyLimitDescription =>
      'You have reached your daily message limit';

  @override
  String get dailyLimitTitle => 'Daily Limit Reached';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get darkTheme => 'Dark Mode';

  @override
  String get darkThemeDesc => 'Use dark theme';

  @override
  String get dataCollection => 'Data Collection Settings';

  @override
  String get datingAdvice => 'Dating Advice';

  @override
  String get datingDescription =>
      'I want to share deep thoughts and have sincere conversations';

  @override
  String get dawn => 'Dawn';

  @override
  String get day => 'Day';

  @override
  String get dayAfterTomorrow => 'Day after tomorrow';

  @override
  String daysAgo(int count, String formatted) {
    return '$count days ago';
  }

  @override
  String daysRemaining(int days) {
    return '$days days remaining';
  }

  @override
  String get deepTalk => 'Deep Talk';

  @override
  String get delete => 'Delete';

  @override
  String get deleteAccount => 'Delete Account';

  @override
  String get deleteAccountConfirm =>
      'Are you sure you want to delete your account? This action cannot be undone.';

  @override
  String get deleteAccountWarning =>
      'Are you sure you want to delete your account?';

  @override
  String get deleteCache => 'Delete Cache';

  @override
  String get deletingAccount => 'Deleting account...';

  @override
  String get depressed => 'Depressed';

  @override
  String get describeError => 'What is the problem?';

  @override
  String get detailedReason => 'Detailed reason';

  @override
  String get developRelationshipStep =>
      '3. Develop Relationship: Build intimacy through conversations and develop special relationships.';

  @override
  String get dinner => 'Dinner';

  @override
  String get discardGuestData => 'Start Fresh';

  @override
  String get discount20 => '20% off';

  @override
  String get discount30 => '30% off';

  @override
  String get discountAmount => 'Save';

  @override
  String discountAmountValue(String amount) {
    return 'Save ₩$amount';
  }

  @override
  String get done => 'Done';

  @override
  String get downloadingPersonaImages => 'Downloading new persona images';

  @override
  String get edit => 'Edit';

  @override
  String get editInfo => 'Edit Info';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get effectSound => 'Sound Effects';

  @override
  String get effectSoundDescription => 'Play sound effects';

  @override
  String get email => 'Email';

  @override
  String get emailHint => 'example@email.com';

  @override
  String get emailLabel => 'Email';

  @override
  String get emailRequired => 'Email *';

  @override
  String get emotionAnalysis => 'Emotion Analysis';

  @override
  String get emotionAnalysisDesc => 'Analyze emotions for empathetic responses';

  @override
  String get emotionAngry => 'Angry';

  @override
  String get emotionBasedEncounters => 'Meet personas based on your emotions';

  @override
  String get emotionCool => 'Cool';

  @override
  String get emotionHappy => 'Happy';

  @override
  String get emotionLove => 'Love';

  @override
  String get emotionSad => 'Sad';

  @override
  String get emotionThinking => 'Thinking';

  @override
  String get emotionalSupportDesc =>
      'Share your concerns and receive warm comfort';

  @override
  String get endChat => 'End Chat';

  @override
  String get endTutorial => 'End Tutorial';

  @override
  String get endTutorialAndLogin =>
      'End tutorial and login?\nLogin to save data and use all features.';

  @override
  String get endTutorialMessage =>
      'Do you want to end the tutorial and login?\nBy logging in, your data will be saved and you can use all features.';

  @override
  String get english => 'English';

  @override
  String get enterBasicInfo =>
      'Please enter basic information to create an account';

  @override
  String get enterBasicInformation => 'Please enter basic information';

  @override
  String get enterEmail => 'Please enter email';

  @override
  String get enterNickname => 'Please enter a nickname';

  @override
  String get enterPassword => 'Please enter a password';

  @override
  String get entertainmentAndFunDesc =>
      'Enjoy fun games and pleasant conversations';

  @override
  String get entertainmentDescription =>
      'I want to have fun conversations and enjoy my time';

  @override
  String get entertainmentFun => 'Entertainment/Fun';

  @override
  String get error => 'Error';

  @override
  String get errorDescription => 'Error description';

  @override
  String get errorDescriptionHint =>
      'e.g., Gave strange answers, Repeats the same thing, Gives contextually inappropriate responses...';

  @override
  String get errorDetails => 'Error Details';

  @override
  String get errorDetailsHint => 'Please explain in detail what is wrong';

  @override
  String get errorFrequency24h => 'Error Frequency (Last 24 hours)';

  @override
  String get errorMessage => 'Error Message:';

  @override
  String get errorOccurred => 'An error occurred.';

  @override
  String get errorOccurredTryAgain => 'An error occurred. Please try again.';

  @override
  String get errorSendingFailed => 'Failed to send error';

  @override
  String get errorStats => 'Error Statistics';

  @override
  String errorWithMessage(String error) {
    return 'Error occurred: $error';
  }

  @override
  String get evening => 'Evening';

  @override
  String get excited => 'Excited';

  @override
  String get exit => 'Exit';

  @override
  String get exitApp => 'Exit App';

  @override
  String get exitConfirmMessage => 'Are you sure you want to exit the app?';

  @override
  String get expertPersona => 'Expert Persona';

  @override
  String get expertiseScore => 'Expertise Score';

  @override
  String get expired => 'Expired';

  @override
  String get explainReportReason =>
      'Please explain the report reason in detail';

  @override
  String get fashion => 'Fashion';

  @override
  String get female => 'Female';

  @override
  String get filter => 'Filter';

  @override
  String get firstOccurred => 'First Occurred: ';

  @override
  String get followDeviceLanguage => 'Follow device language settings';

  @override
  String get forenoon => 'Forenoon';

  @override
  String get forgotPassword => 'Forgot Password';

  @override
  String get frequentlyAskedQuestions => 'Frequently Asked Questions';

  @override
  String get friday => 'Friday';

  @override
  String get friendshipDescription =>
      'I want to meet new friends and have conversations';

  @override
  String get funChat => 'Fun Chat';

  @override
  String get galleryPermission => 'Gallery Permission';

  @override
  String get galleryPermissionDesc =>
      'Gallery access is required to select profile photos.';

  @override
  String get gaming => 'Gaming';

  @override
  String get gender => 'Gender';

  @override
  String get genderNotSelectedInfo =>
      'If gender is not selected, personas of all genders will be shown';

  @override
  String get genderOptional => 'Gender (Optional)';

  @override
  String get genderPreferenceActive => 'You can meet personas of all genders';

  @override
  String get genderPreferenceDisabled =>
      'Select your gender to enable opposite gender only option';

  @override
  String get genderPreferenceInactive =>
      'Only opposite gender personas will be shown';

  @override
  String get genderRequired => 'Gender *';

  @override
  String get genderSelectionInfo =>
      'If not selected, you can meet personas of all genders';

  @override
  String get generalPersona => 'General Persona';

  @override
  String get goToSettings => 'Go to Settings';

  @override
  String get googleLoginCanceled =>
      'Google login was canceled.\nPlease try again.';

  @override
  String get googleLoginError => 'Error occurred during Google login.';

  @override
  String get grantPermission => 'Continue';

  @override
  String get guest => 'Guest';

  @override
  String get guestDataMigration =>
      'Would you like to keep your current chat history when signing up?';

  @override
  String get guestLimitReached =>
      'Guest trial ended.\nSign up for unlimited conversations!';

  @override
  String get guestLoginPromptMessage => 'Login to continue the conversation';

  @override
  String get guestMessageExhausted => 'Free messages exhausted';

  @override
  String guestMessageRemaining(int count) {
    return '$count guest messages remaining';
  }

  @override
  String get guestModeBanner => 'Guest Mode';

  @override
  String get guestModeDescription =>
      'Try SONA without signing up\n• 20 message limit\n• 1 heart provided\n• View all personas';

  @override
  String get guestModeFailedMessage => 'Failed to start Guest Mode';

  @override
  String get guestModeLimitation => 'Some features are limited in Guest Mode';

  @override
  String get guestModeTitle => 'Try as Guest';

  @override
  String get guestModeWarning =>
      'Guest mode lasts for 24 hours,\nafter which data will be deleted.';

  @override
  String get guestModeWelcome => 'Starting in Guest Mode';

  @override
  String get happy => 'Happy';

  @override
  String get hapticFeedback => 'Haptic Feedback';

  @override
  String get harassmentBullying => 'Harassment/Bullying';

  @override
  String get hateSpeech => 'Hate speech';

  @override
  String get heartDescription => 'Hearts for more messages';

  @override
  String get heartInsufficient => 'Not enough hearts';

  @override
  String get heartInsufficientPleaseCharge =>
      'Not enough hearts. Please recharge hearts.';

  @override
  String get heartRequired => '1 heart is required';

  @override
  String get heartUsageFailed => 'Failed to use heart.';

  @override
  String get hearts => 'Hearts';

  @override
  String get hearts10 => '10 Hearts';

  @override
  String get hearts30 => '30 Hearts';

  @override
  String get hearts30Discount => 'SALE';

  @override
  String get hearts50 => '50 Hearts';

  @override
  String get hearts50Discount => 'SALE';

  @override
  String get helloEmoji => 'Hello! 😊';

  @override
  String get help => 'Help';

  @override
  String get hideOriginalText => 'Hide Original';

  @override
  String get hobbySharing => 'Hobby Sharing';

  @override
  String get hobbyTalk => 'Hobby Talk';

  @override
  String get hours24Ago => '24 hours ago';

  @override
  String hoursAgo(int count, String formatted) {
    return '$count hours ago';
  }

  @override
  String get howToUse => 'How to use SONA';

  @override
  String get imageCacheManagement => 'Image Cache Management';

  @override
  String get inappropriateContent => 'Inappropriate content';

  @override
  String get incorrect => 'incorrect';

  @override
  String get incorrectPassword => 'Incorrect password';

  @override
  String get indonesian => 'Indonesian';

  @override
  String get inquiries => 'Inquiries';

  @override
  String get insufficientHearts => 'Insufficient hearts.';

  @override
  String get interestSharing => 'Interest Sharing';

  @override
  String get interestSharingDesc => 'Discover and recommend shared interests';

  @override
  String get interests => 'Interests';

  @override
  String get invalidEmailFormat => 'Invalid email format';

  @override
  String get invalidEmailFormatError => 'Please enter a valid email address';

  @override
  String isTyping(String name) {
    return '$name is typing...';
  }

  @override
  String get japanese => 'Japanese';

  @override
  String get joinDate => 'Join Date';

  @override
  String get justNow => 'Just now';

  @override
  String get keepGuestData => 'Keep Chat History';

  @override
  String get korean => 'Korean';

  @override
  String get koreanLanguage => 'Korean';

  @override
  String get language => 'Language';

  @override
  String get languageDescription => 'AI will respond in your selected language';

  @override
  String get languageIndicator => 'Language';

  @override
  String get languageSettings => 'Language Settings';

  @override
  String get lastOccurred => 'Last Occurred: ';

  @override
  String get lastUpdated => 'Last Updated';

  @override
  String get lateNight => 'Late night';

  @override
  String get later => 'Later';

  @override
  String get laterButton => 'Later';

  @override
  String get leave => 'Leave';

  @override
  String get leaveChatConfirm =>
      'Leave this chat?\nIt will disappear from your chat list.';

  @override
  String get leaveChatRoom => 'Leave Chat Room';

  @override
  String get leaveChatTitle => 'Leave Chat';

  @override
  String get lifeAdvice => 'Life Advice';

  @override
  String get lightTalk => 'Light Talk';

  @override
  String get lightTheme => 'Light Mode';

  @override
  String get lightThemeDesc => 'Use bright theme';

  @override
  String get loading => 'Loading...';

  @override
  String get loadingData => 'Loading data...';

  @override
  String get loadingProducts => 'Loading products...';

  @override
  String get loadingProfile => 'Loading profile';

  @override
  String get login => 'Login';

  @override
  String get loginButton => 'Login';

  @override
  String get loginCancelled => 'Login cancelled';

  @override
  String get loginComplete => 'Login complete';

  @override
  String get loginError => 'Login failed';

  @override
  String get loginFailed => 'Login failed';

  @override
  String get loginFailedTryAgain => 'Login failed. Please try again.';

  @override
  String get loginRequired => 'Login required';

  @override
  String get loginRequiredForProfile =>
      'Login required to view profile\nand check records with SONA';

  @override
  String get loginRequiredService => 'Login required to use this service';

  @override
  String get loginRequiredTitle => 'Login Required';

  @override
  String get loginSignup => 'Login/Sign Up';

  @override
  String get loginTab => 'Login';

  @override
  String get loginTitle => 'Login';

  @override
  String get loginWithApple => 'Login with Apple';

  @override
  String get loginWithGoogle => 'Login with Google';

  @override
  String get logout => 'Logout';

  @override
  String get logoutConfirm => 'Are you sure you want to logout?';

  @override
  String get lonelinessRelief => 'Loneliness Relief';

  @override
  String get lonely => 'Lonely';

  @override
  String get lowQualityResponses => 'Low Quality Responses';

  @override
  String get lunch => 'Lunch';

  @override
  String get lunchtime => 'Lunchtime';

  @override
  String get mainErrorType => 'Main Error Type';

  @override
  String get makeFriends => 'Make Friends';

  @override
  String get male => 'Male';

  @override
  String get manageBlockedAIs => 'Manage Blocked AIs';

  @override
  String get managePersonaImageCache => 'Manage persona image cache';

  @override
  String get marketingAgree => 'Agree to Marketing Information (Optional)';

  @override
  String get marketingDescription =>
      'You can receive event and benefit information';

  @override
  String get matchPersonaStep =>
      '1. Match Personas: Swipe left or right to select your favorite AI personas.';

  @override
  String get matchedPersonas => 'Matched Personas';

  @override
  String get matchedSona => 'Matched Sona';

  @override
  String get matching => 'Matching';

  @override
  String get matchingFailed => 'Matching failed.';

  @override
  String get me => 'Me';

  @override
  String get meetAIPersonas => 'Meet AI Personas';

  @override
  String get meetNewPersonas => 'Meet New Personas';

  @override
  String get meetPersonas => 'Meet Personas';

  @override
  String get memberBenefits =>
      'Get 100+ messages and 10 hearts when you sign up!';

  @override
  String get memoryAlbum => 'Memory Album';

  @override
  String get memoryAlbumDesc => 'Automatically save and recall special moments';

  @override
  String get messageCopied => 'Message copied';

  @override
  String get messageDeleted => 'Message deleted';

  @override
  String get messageLimitReset => 'Message limit will reset at midnight';

  @override
  String get messageSendFailed => 'Failed to send message. Please try again.';

  @override
  String get messagesRemaining => 'Messages Remaining';

  @override
  String minutesAgo(int count, String formatted) {
    return '$count minutes ago';
  }

  @override
  String get missingTranslation => 'Missing Translation';

  @override
  String get monday => 'Monday';

  @override
  String get month => 'Month';

  @override
  String monthDay(String month, int day) {
    return '$month $day';
  }

  @override
  String get moreButton => 'More';

  @override
  String get morning => 'Morning';

  @override
  String get mostFrequentError => 'Most Frequent Error';

  @override
  String get movies => 'Movies';

  @override
  String get multilingualChat => 'Multilingual Chat';

  @override
  String get music => 'Music';

  @override
  String get myGenderSection => 'My Gender (Optional)';

  @override
  String get networkErrorOccurred => 'A network error occurred.';

  @override
  String get newMessage => 'New message';

  @override
  String newMessageCount(int count) {
    return '$count new messages';
  }

  @override
  String get newMessageNotification => 'Notify me of new messages';

  @override
  String get newMessages => 'New messages';

  @override
  String get newYear => 'New Year';

  @override
  String get next => 'Next';

  @override
  String get niceToMeetYou => 'Nice to meet you!';

  @override
  String get nickname => 'Nickname';

  @override
  String get nicknameAlreadyUsed => 'This nickname is already in use';

  @override
  String get nicknameHelperText => '3-10 characters';

  @override
  String get nicknameHint => '3-10 characters';

  @override
  String get nicknameInUse => 'This nickname is already in use';

  @override
  String get nicknameLabel => 'Nickname';

  @override
  String get nicknameLengthError => 'Nickname must be 3-10 characters';

  @override
  String get nicknamePlaceholder => 'Enter your nickname';

  @override
  String get nicknameRequired => 'Nickname *';

  @override
  String get night => 'Night';

  @override
  String get no => 'No';

  @override
  String get noBlockedAIs => 'No blocked AIs';

  @override
  String get noChatsYet => 'No chats yet';

  @override
  String get noConversationYet => 'No conversation yet';

  @override
  String get noErrorReports => 'No error reports.';

  @override
  String get noImageAvailable => 'No image available';

  @override
  String get noMatchedPersonas => 'No matched personas yet';

  @override
  String get noMatchedSonas => 'No matched Sonas yet';

  @override
  String get noPersonasAvailable => 'No personas available. Please try again.';

  @override
  String get noPersonasToSelect => 'No personas available';

  @override
  String get noQualityIssues => 'No quality issues in the last hour ✅';

  @override
  String get noQualityLogs => 'No quality logs yet.';

  @override
  String get noTranslatedMessages => 'No messages to translate';

  @override
  String get notEnoughHearts => 'Not enough hearts';

  @override
  String notEnoughHeartsCount(int count) {
    return 'Not enough hearts. (Current: $count)';
  }

  @override
  String get notRegistered => 'not registered';

  @override
  String get notSubscribed => 'Not subscribed';

  @override
  String get notificationPermissionDesc =>
      'Notification permission is required to receive new messages.';

  @override
  String get notificationPermissionRequired =>
      'Notification permission required';

  @override
  String get notificationSettings => 'Notification Settings';

  @override
  String get notifications => 'Notifications';

  @override
  String get occurrenceInfo => 'Occurrence Info:';

  @override
  String get olderChats => 'Older';

  @override
  String get onlyOppositeGenderNote =>
      'If unchecked, only opposite gender personas will be shown';

  @override
  String get openSettings => 'Open Settings';

  @override
  String get optional => 'Optional';

  @override
  String get or => 'or';

  @override
  String get originalPrice => 'Original';

  @override
  String get originalText => 'Original';

  @override
  String get other => 'Other';

  @override
  String get otherError => 'Other Error';

  @override
  String get others => 'Others';

  @override
  String get ownedHearts => 'Owned Hearts';

  @override
  String get parentsDay => 'Parents\' Day';

  @override
  String get password => 'Password';

  @override
  String get passwordConfirmation => 'Enter password to confirm';

  @override
  String get passwordConfirmationDesc =>
      'Please re-enter your password to delete account.';

  @override
  String get passwordHint => '6 characters or more';

  @override
  String get passwordLabel => 'Password';

  @override
  String get passwordRequired => 'Password *';

  @override
  String get passwordResetEmailPrompt =>
      'Please enter your email to reset password';

  @override
  String get passwordResetEmailSent =>
      'Password reset email has been sent. Please check your email.';

  @override
  String get passwordText => 'password';

  @override
  String get passwordTooShort => 'Password must be at least 6 characters';

  @override
  String get permissionDenied => 'Permission denied';

  @override
  String permissionDeniedMessage(String permissionName) {
    return '$permissionName permission was denied.\\nPlease allow the permission in settings.';
  }

  @override
  String get permissionDeniedTryLater =>
      'Permission denied. Please try again later.';

  @override
  String get permissionRequired => 'Permission Required';

  @override
  String get personaGenderSection => 'Persona Gender Preference';

  @override
  String get personaQualityStats => 'Persona Quality Statistics';

  @override
  String get personalInfoExposure => 'Personal information exposure';

  @override
  String get personality => 'Personality';

  @override
  String get pets => 'Pets';

  @override
  String get photo => 'Photo';

  @override
  String get photography => 'Photography';

  @override
  String get picnic => 'Picnic';

  @override
  String get preferenceSettings => 'Preference Settings';

  @override
  String get preferredLanguage => 'Preferred Language';

  @override
  String get preparingForSleep => 'Preparing for sleep';

  @override
  String get preparingNewMeeting => 'Preparing new meeting';

  @override
  String get preparingPersonaImages => 'Preparing persona images';

  @override
  String get preparingPersonas => 'Preparing personas';

  @override
  String get preview => 'Preview';

  @override
  String get previous => 'Previous';

  @override
  String get privacy => 'Privacy Policy';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get privacyPolicyAgreement => 'Please agree to the privacy policy';

  @override
  String get privacySection1Content =>
      'We are committed to protecting your privacy. This Privacy Policy explains how we collect, use, and safeguard your information when you use our service.';

  @override
  String get privacySection1Title =>
      '1. Purpose of Collection and Use of Personal Information';

  @override
  String get privacySection2Content =>
      'We collect information you provide directly to us, such as when you create an account, update your profile, or use our services.';

  @override
  String get privacySection2Title => 'Information We Collect';

  @override
  String get privacySection3Content =>
      'We use the information we collect to provide, maintain, and improve our services, and to communicate with you.';

  @override
  String get privacySection3Title =>
      '3. Retention and Use Period of Personal Information';

  @override
  String get privacySection4Content =>
      'We do not sell, trade, or otherwise transfer your personal information to third parties without your consent.';

  @override
  String get privacySection4Title =>
      '4. Provision of Personal Information to Third Parties';

  @override
  String get privacySection5Content =>
      'We implement appropriate security measures to protect your personal information against unauthorized access, alteration, disclosure, or destruction.';

  @override
  String get privacySection5Title =>
      '5. Technical Protection Measures for Personal Information';

  @override
  String get privacySection6Content =>
      'We retain personal information for as long as necessary to provide our services and comply with legal obligations.';

  @override
  String get privacySection6Title => '6. User Rights';

  @override
  String get privacySection7Content =>
      'You have the right to access, update, or delete your personal information at any time through your account settings.';

  @override
  String get privacySection7Title => 'Your Rights';

  @override
  String get privacySection8Content =>
      'If you have any questions about this Privacy Policy, please contact us at support@sona.com.';

  @override
  String get privacySection8Title => 'Contact Us';

  @override
  String get privacySettings => 'Privacy Settings';

  @override
  String get privacySettingsInfo =>
      'Disabling individual features will make those services unavailable';

  @override
  String get privacySettingsScreen => 'Privacy Settings';

  @override
  String get problemMessage => 'Problem';

  @override
  String get problemOccurred => 'Problem Occurred';

  @override
  String get profile => 'Profile';

  @override
  String get profileEdit => 'Edit Profile';

  @override
  String get profileEditLoginRequiredMessage =>
      'Login is required to edit your profile.\nWould you like to go to the login screen?';

  @override
  String get profileInfo => 'Profile Information';

  @override
  String get profileInfoDescription =>
      'Please enter your profile photo and basic information';

  @override
  String get profileNav => 'Profile';

  @override
  String get profilePhoto => 'Profile Photo';

  @override
  String get profilePhotoAndInfo =>
      'Please enter profile photo and basic information';

  @override
  String get profilePhotoUpdateFailed => 'Failed to update profile photo';

  @override
  String get profilePhotoUpdated => 'Profile photo updated';

  @override
  String get profileSettings => 'Profile Settings';

  @override
  String get profileSetup => 'Setting up profile';

  @override
  String get profileUpdateFailed => 'Failed to update profile';

  @override
  String get profileUpdated => 'Profile updated successfully';

  @override
  String get purchaseAndRefundPolicy => 'Purchase & Refund Policy';

  @override
  String get purchaseButton => 'Purchase';

  @override
  String get purchaseConfirm => 'Purchase Confirmation';

  @override
  String purchaseConfirmContent(String product, String price) {
    return 'Purchase $product for $price?';
  }

  @override
  String purchaseConfirmMessage(
      String title, String price, String description) {
    return 'Confirm purchase of $title for $price? $description';
  }

  @override
  String get purchaseFailed => 'Purchase failed';

  @override
  String get purchaseHeartsOnly => 'Buy hearts';

  @override
  String get purchaseMoreHearts => 'Purchase hearts to continue conversations';

  @override
  String get purchasePending => 'Purchase pending...';

  @override
  String get purchasePolicy => 'Purchase Policy';

  @override
  String get purchaseSection1Content =>
      'We accept various payment methods including credit cards and digital wallets.';

  @override
  String get purchaseSection1Title => 'Payment Methods';

  @override
  String get purchaseSection2Content =>
      'Refunds are available within 14 days of purchase if you have not used the purchased items.';

  @override
  String get purchaseSection2Title => 'Refund Policy';

  @override
  String get purchaseSection3Content =>
      'You can cancel your subscription at any time through your account settings.';

  @override
  String get purchaseSection3Title => 'Cancellation';

  @override
  String get purchaseSection4Content =>
      'By making a purchase, you agree to our terms of use and service agreement.';

  @override
  String get purchaseSection4Title => 'Terms of Use';

  @override
  String get purchaseSection5Content =>
      'For purchase-related issues, please contact our support team.';

  @override
  String get purchaseSection5Title => 'Contact Support';

  @override
  String get purchaseSection6Content =>
      'All purchases are subject to our standard terms and conditions.';

  @override
  String get purchaseSection6Title => '6. Inquiries';

  @override
  String get pushNotifications => 'Push Notifications';

  @override
  String get reading => 'Reading';

  @override
  String get realtimeQualityLog => 'Real-time Quality Log';

  @override
  String get recentConversation => 'Recent Conversation:';

  @override
  String get recentLoginRequired => 'Please login again for security';

  @override
  String get referrerEmail => 'Referrer Email';

  @override
  String get referrerEmailHelper => 'Optional: Email of who referred you';

  @override
  String get referrerEmailLabel => 'Referrer Email (Optional)';

  @override
  String get refresh => 'Refresh';

  @override
  String refreshComplete(int count) {
    return 'Refresh complete! $count matched personas';
  }

  @override
  String get refreshFailed => 'Refresh failed';

  @override
  String get refreshingChatList => 'Refreshing chat list...';

  @override
  String get relatedFAQ => 'Related FAQ';

  @override
  String get report => 'Report';

  @override
  String get reportAI => 'Report';

  @override
  String get reportAIDescription =>
      'If the AI made you uncomfortable, please describe the issue.';

  @override
  String get reportAITitle => 'Report AI Conversation';

  @override
  String get reportAndBlock => 'Report & Block';

  @override
  String get reportAndBlockDescription =>
      'You can report and block inappropriate behavior of this AI';

  @override
  String get reportChatError => 'Report Chat Error';

  @override
  String reportError(String error) {
    return 'Error occurred while reporting: $error';
  }

  @override
  String get reportFailed => 'Report failed';

  @override
  String get reportSubmitted =>
      'Report submitted. We will review and take action.';

  @override
  String get reportSubmittedSuccess =>
      'Your report has been submitted. Thank you!';

  @override
  String get requestLimit => 'Request Limit';

  @override
  String get required => '[Required]';

  @override
  String get requiredTermsAgreement => 'Please agree to the terms';

  @override
  String get restartConversation => 'Restart Conversation';

  @override
  String restartConversationQuestion(String name) {
    return 'Would you like to restart the conversation with $name?';
  }

  @override
  String restartConversationWithName(String name) {
    return 'Restarting conversation with $name!';
  }

  @override
  String get retry => 'Retry';

  @override
  String get retryButton => 'Retry';

  @override
  String get sad => 'Sad';

  @override
  String get saturday => 'Saturday';

  @override
  String get save => 'Save';

  @override
  String get search => 'Search';

  @override
  String get searchFAQ => 'Search FAQ...';

  @override
  String get searchResults => 'Search Results';

  @override
  String get selectEmotion => 'Select Emotion';

  @override
  String get selectErrorType => 'Select error type';

  @override
  String get selectFeeling => 'Select Feeling';

  @override
  String get selectGender => 'Please select gender';

  @override
  String get selectInterests => 'Please select your interests (at least 1)';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get selectPersona => 'Select a persona';

  @override
  String get selectPersonaPlease => 'Please select a persona.';

  @override
  String get selectPreferredMbti =>
      'If you prefer personas with specific MBTI types, please select';

  @override
  String get selectProblematicMessage =>
      'Select the problematic message (optional)';

  @override
  String get selectReportReason => 'Select report reason';

  @override
  String get selectTheme => 'Select Theme';

  @override
  String get selectTranslationError =>
      'Please select a message with translation error';

  @override
  String get selectUsagePurpose => 'Please select your purpose for using SONA';

  @override
  String get selfIntroduction => 'Introduction (Optional)';

  @override
  String get selfIntroductionHint =>
      'Write a brief introduction about yourself';

  @override
  String get send => 'Send';

  @override
  String get sendChatError => 'Send Chat Error';

  @override
  String get sendFirstMessage => 'Send your first message';

  @override
  String get sendReport => 'Send Report';

  @override
  String get sendingEmail => 'Sending email...';

  @override
  String get seoul => 'Seoul';

  @override
  String get serverErrorDashboard => 'Server Error';

  @override
  String get serviceTermsAgreement => 'Please agree to the terms of service';

  @override
  String get sessionExpired => 'Session expired';

  @override
  String get setAppInterfaceLanguage => 'Set app interface language';

  @override
  String get setNow => 'Set Now';

  @override
  String get settings => 'Settings';

  @override
  String get sexualContent => 'Sexual content';

  @override
  String get showAllGenderPersonas => 'Show All Gender Personas';

  @override
  String get showAllGendersOption => 'Show All Genders';

  @override
  String get showOppositeGenderOnly =>
      'If unchecked, only opposite gender personas will be shown';

  @override
  String get showOriginalText => 'Show Original';

  @override
  String get signUp => 'Sign Up';

  @override
  String get signUpFromGuest => 'Sign up now to access all features!';

  @override
  String get signup => 'Sign Up';

  @override
  String get signupComplete => 'Sign Up Complete';

  @override
  String get signupTab => 'Sign Up';

  @override
  String get simpleInfoRequired =>
      'Simple information is required\nfor matching with AI personas';

  @override
  String get skip => 'Skip';

  @override
  String get sonaFriend => 'SONA Friend';

  @override
  String get sonaPrivacyPolicy => 'SONA Privacy Policy';

  @override
  String get sonaPurchasePolicy => 'SONA Purchase Policy';

  @override
  String get sonaTermsOfService => 'SONA Terms of Service';

  @override
  String get sonaUsagePurpose => 'Please select your purpose for using SONA';

  @override
  String get sorryNotHelpful => 'Sorry this wasn\'t helpful';

  @override
  String get sort => 'Sort';

  @override
  String get soundSettings => 'Sound Settings';

  @override
  String get spamAdvertising => 'Spam/Advertising';

  @override
  String get spanish => 'Spanish';

  @override
  String get specialRelationshipDesc =>
      'Understand each other and build deep bonds';

  @override
  String get sports => 'Sports';

  @override
  String get spring => 'Spring';

  @override
  String get startChat => 'Start Chat';

  @override
  String get startChatButton => 'Start Chat';

  @override
  String get startConversation => 'Start a conversation';

  @override
  String get startConversationLikeAFriend =>
      'Start a conversation with Sona like a friend';

  @override
  String get startConversationStep =>
      '2. Start Conversation: Chat freely with matched personas.';

  @override
  String get startConversationWithSona =>
      'Start chatting with Sona like a friend!';

  @override
  String get startWithEmail => 'Start with Email';

  @override
  String get startWithGoogle => 'Start with Google';

  @override
  String get startingApp => 'Starting app';

  @override
  String get storageManagement => 'Storage Management';

  @override
  String get store => 'Store';

  @override
  String get storeConnectionError => 'Could not connect to store';

  @override
  String get storeLoginRequiredMessage =>
      'Login is required to use the store.\nWould you like to go to the login screen?';

  @override
  String get storeNotAvailable => 'Store is not available';

  @override
  String get storyEvent => 'Story Event';

  @override
  String get stressed => 'Stressed';

  @override
  String get submitReport => 'Submit Report';

  @override
  String get subscriptionStatus => 'Subscription Status';

  @override
  String get subtleVibrationOnTouch => 'Subtle vibration on touch';

  @override
  String get summer => 'Summer';

  @override
  String get sunday => 'Sunday';

  @override
  String get swipeAnyDirection => 'Swipe in any direction';

  @override
  String get swipeDownToClose => 'Swipe down to close';

  @override
  String get systemTheme => 'Follow System';

  @override
  String get systemThemeDesc =>
      'Automatically changes based on device dark mode settings';

  @override
  String get tapBottomForDetails => 'Tap bottom area to see details';

  @override
  String get tapForDetails => 'Tap bottom area for details';

  @override
  String get tapToSwipePhotos => 'Tap to swipe photos';

  @override
  String get teachersDay => 'Teachers\' Day';

  @override
  String get technicalError => 'Technical Error';

  @override
  String get technology => 'Technology';

  @override
  String get terms => 'Terms of Service';

  @override
  String get termsAgreement => 'Terms Agreement';

  @override
  String get termsAgreementDescription =>
      'Please agree to the terms for using the service';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get termsSection10Content =>
      'We reserve the right to modify these terms at any time with notice to users.';

  @override
  String get termsSection10Title => 'Article 10 (Dispute Resolution)';

  @override
  String get termsSection11Content =>
      'These terms shall be governed by the laws of the jurisdiction in which we operate.';

  @override
  String get termsSection11Title =>
      'Article 11 (AI Service Special Provisions)';

  @override
  String get termsSection12Content =>
      'If any provision of these terms is found to be unenforceable, the remaining provisions shall continue in full force and effect.';

  @override
  String get termsSection12Title => 'Article 12 (Data Collection and Usage)';

  @override
  String get termsSection1Content =>
      'These terms and conditions aim to define the rights, obligations, and responsibilities between SONA (hereinafter \"Company\") and users regarding the use of the AI persona conversation matching service (hereinafter \"Service\") provided by the Company.';

  @override
  String get termsSection1Title => 'Article 1 (Purpose)';

  @override
  String get termsSection2Content =>
      'By using our service, you agree to be bound by these Terms of Service and our Privacy Policy.';

  @override
  String get termsSection2Title => 'Article 2 (Definitions)';

  @override
  String get termsSection3Content =>
      'You must be at least 13 years old to use our service.';

  @override
  String get termsSection3Title =>
      'Article 3 (Effect and Modification of Terms)';

  @override
  String get termsSection4Content =>
      'You are responsible for maintaining the confidentiality of your account and password.';

  @override
  String get termsSection4Title => 'Article 4 (Provision of Service)';

  @override
  String get termsSection5Content =>
      'You agree not to use our service for any illegal or unauthorized purpose.';

  @override
  String get termsSection5Title => 'Article 5 (Membership Registration)';

  @override
  String get termsSection6Content =>
      'We reserve the right to terminate or suspend your account for violation of these terms.';

  @override
  String get termsSection6Title => 'Article 6 (User Obligations)';

  @override
  String get termsSection7Content =>
      'The Company may gradually restrict service usage through warnings, temporary suspension, or permanent suspension if users violate the obligations of these terms or interfere with normal service operations.';

  @override
  String get termsSection7Title => 'Article 7 (Service Usage Restrictions)';

  @override
  String get termsSection8Content =>
      'We are not liable for any indirect, incidental, or consequential damages arising from your use of our service.';

  @override
  String get termsSection8Title => 'Article 8 (Service Interruption)';

  @override
  String get termsSection9Content =>
      'All content and materials available on our service are protected by intellectual property rights.';

  @override
  String get termsSection9Title => 'Article 9 (Disclaimer)';

  @override
  String get termsSupplementary => 'Supplementary Terms';

  @override
  String get thai => 'Thai';

  @override
  String get thanksFeedback => 'Thanks for your feedback!';

  @override
  String get theme => 'Theme';

  @override
  String get themeDescription =>
      'You can customize the app appearance as you like';

  @override
  String get themeSettings => 'Theme Settings';

  @override
  String get thursday => 'Thursday';

  @override
  String get timeout => 'Timeout';

  @override
  String get tired => 'Tired';

  @override
  String get today => 'Today';

  @override
  String get todayChats => 'Today';

  @override
  String get todayText => 'Today';

  @override
  String get tomorrowText => 'Tomorrow';

  @override
  String get totalConsultSessions => 'Total Consultation Sessions';

  @override
  String get totalErrorCount => 'Total Error Count';

  @override
  String get totalLikes => 'Total Likes';

  @override
  String totalOccurrences(Object count) {
    return 'Total $count occurrences';
  }

  @override
  String get totalResponses => 'Total Responses';

  @override
  String get translatedFrom => 'Translated';

  @override
  String get translatedText => 'Translation';

  @override
  String get translationError => 'Translation error';

  @override
  String get translationErrorDescription =>
      'Please report incorrect translations or awkward expressions';

  @override
  String get translationErrorReported =>
      'Translation error reported. Thank you!';

  @override
  String get translationNote => '※ AI translation may not be perfect';

  @override
  String get translationQuality => 'Translation Quality';

  @override
  String get translationSettings => 'Translation Settings';

  @override
  String get travel => 'Travel';

  @override
  String get tuesday => 'Tuesday';

  @override
  String get tutorialAccount => 'Tutorial Account';

  @override
  String get tutorialWelcomeDescription =>
      'Create special relationships with AI personas.';

  @override
  String get tutorialWelcomeTitle => 'Welcome to SONA!';

  @override
  String get typeMessage => 'Type a message...';

  @override
  String get unblock => 'Unblock';

  @override
  String get unblockFailed => 'Failed to unblock';

  @override
  String unblockPersonaConfirm(String name) {
    return 'Unblock $name?';
  }

  @override
  String get unblockedSuccessfully => 'Unblocked successfully';

  @override
  String get unexpectedLoginError =>
      'An unexpected error occurred during login';

  @override
  String get unknown => 'Unknown';

  @override
  String get unknownError => 'An unknown error occurred';

  @override
  String get unlimitedMessages => 'Unlimited';

  @override
  String get unsendMessage => 'Unsend message';

  @override
  String get usagePurpose => 'Usage Purpose';

  @override
  String get useOneHeart => 'Use 1 Heart';

  @override
  String get useSystemLanguage => 'Use System Language';

  @override
  String get user => 'User: ';

  @override
  String get userMessage => 'User Message:';

  @override
  String get userNotFound => 'User not found';

  @override
  String get valentinesDay => 'Valentine\'s Day';

  @override
  String get verifyingAuth => 'Verifying authentication';

  @override
  String get version => 'Version';

  @override
  String get vietnamese => 'Vietnamese';

  @override
  String get violentContent => 'Violent content';

  @override
  String get voiceMessage => '🎤 Voice message';

  @override
  String waitingForChat(String name) {
    return '$name is waiting to chat.';
  }

  @override
  String get walk => 'Walk';

  @override
  String get wasHelpful => 'Was this helpful?';

  @override
  String get weatherClear => 'Clear';

  @override
  String get weatherCloudy => 'Cloudy';

  @override
  String get weatherContext => 'Weather Context';

  @override
  String get weatherContextDesc =>
      'Provide conversation context based on weather';

  @override
  String get weatherDrizzle => 'Drizzle';

  @override
  String get weatherFog => 'Fog';

  @override
  String get weatherMist => 'Mist';

  @override
  String get weatherRain => 'Rain';

  @override
  String get weatherRainy => 'Rainy';

  @override
  String get weatherSnow => 'Snow';

  @override
  String get weatherSnowy => 'Snowy';

  @override
  String get weatherThunderstorm => 'Thunderstorm';

  @override
  String get wednesday => 'Wednesday';

  @override
  String get weekdays => 'Sun,Mon,Tue,Wed,Thu,Fri,Sat';

  @override
  String get welcomeMessage => 'Welcome💕';

  @override
  String get whatTopicsToTalk =>
      'What topics would you like to talk about? (Optional)';

  @override
  String get whiteDay => 'White Day';

  @override
  String get winter => 'Winter';

  @override
  String get wrongTranslation => 'Wrong Translation';

  @override
  String get year => 'Year';

  @override
  String get yearEnd => 'Year End';

  @override
  String get yes => 'Yes';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get yesterdayChats => 'Yesterday';

  @override
  String get you => 'You';

  @override
  String get loadingPersonaData => 'Loading persona data';

  @override
  String get checkingMatchedPersonas => 'Checking matched personas';

  @override
  String get preparingImages => 'Preparing images';

  @override
  String get finalPreparation => 'Final preparation';
}
