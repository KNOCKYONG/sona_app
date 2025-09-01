// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get about => 'Tentang';

  @override
  String get accountAndProfile => 'Akun & Profil';

  @override
  String get accountDeletedSuccess => 'Akun berhasil dihapus';

  @override
  String get accountDeletionContent =>
      'Are you sure you want to delete your account?\nThis action cannot be undone.';

  @override
  String get accountDeletionError => 'Error occurred while deleting account.';

  @override
  String get accountDeletionInfo => 'Informasi penghapusan akun';

  @override
  String get accountDeletionTitle => 'Delete Account';

  @override
  String get accountDeletionWarning1 =>
      'Peringatan: Tindakan ini tidak dapat dibatalkan';

  @override
  String get accountDeletionWarning2 => 'Semua data Anda akan dihapus permanen';

  @override
  String get accountDeletionWarning3 =>
      'Anda akan kehilangan akses ke semua percakapan';

  @override
  String get accountDeletionWarning4 => 'Ini termasuk semua konten yang dibeli';

  @override
  String get accountManagement => 'Manajemen akun';

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
    return '$min-$max tahun';
  }

  @override
  String get ageUnit => 'years old';

  @override
  String get agreeToTerms => 'Saya setuju dengan persyaratan';

  @override
  String get aiDatingQuestion => 'Tertarik berkencan dengan AI?';

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
  String get allPersonas => 'Semua persona';

  @override
  String get allPersonasMatched => 'Semua persona dicocokkan';

  @override
  String get allowPermission => 'Continue';

  @override
  String alreadyChattingWith(String name) {
    return 'Already chatting with $name!';
  }

  @override
  String get alsoBlockThisAI => 'Also block this AI';

  @override
  String get angry => 'Marah';

  @override
  String get anonymousLogin => 'Anonymous login';

  @override
  String get anxious => 'Cemas';

  @override
  String get apiKeyError => 'API Key Error';

  @override
  String get appName => 'SONA';

  @override
  String get appTagline => 'Teman AI Anda';

  @override
  String get appleLoginCanceled =>
      'Apple login was canceled.\nPlease try again.';

  @override
  String get appleLoginError => 'Error masuk Apple';

  @override
  String get art => 'Seni';

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
  String get basicInfo => 'Informasi dasar';

  @override
  String get basicInfoDescription =>
      'Please enter basic information to create an account';

  @override
  String get birthDate => 'Tanggal lahir';

  @override
  String get birthDateOptional => 'Tanggal lahir (opsional)';

  @override
  String get birthDateRequired => 'Silakan pilih tanggal lahir';

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
  String get calm => 'Tenang';

  @override
  String get cameraPermission => 'Izin kamera';

  @override
  String get cameraPermissionDesc =>
      'Camera access is required to take profile photos.';

  @override
  String get canChangeInSettings => 'You can change this later in settings';

  @override
  String get canMeetPreviousPersonas =>
      'You can meet personas\nyou swiped before again!';

  @override
  String get cancel => 'Batal';

  @override
  String get changeProfilePhoto => 'Ubah Foto Profil';

  @override
  String get chat => 'Obrolan';

  @override
  String get chatEndedMessage => 'Obrolan berakhir';

  @override
  String get chatErrorDashboard => 'Chat Error Dashboard';

  @override
  String get chatErrorSentSuccessfully =>
      'Chat error has been sent successfully.';

  @override
  String get chatListTab => 'Chat List Tab';

  @override
  String get chats => 'Obrolan';

  @override
  String chattingWithPersonas(int count) {
    return 'Chatting with $count personas';
  }

  @override
  String get checkInternetConnection => 'Silakan periksa koneksi internet Anda';

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
  String get close => 'Tutup';

  @override
  String get complete => 'Done';

  @override
  String get completeSignup => 'Selesaikan pendaftaran';

  @override
  String get confirm => 'Konfirmasi';

  @override
  String get connectingToServer => 'Connecting to server';

  @override
  String get consultQualityMonitoring => 'Consultation Quality Monitoring';

  @override
  String get continueAsGuest => 'Continue as Guest';

  @override
  String get continueButton => 'Continue';

  @override
  String get continueWithApple => 'Lanjutkan dengan Apple';

  @override
  String get continueWithGoogle => 'Lanjutkan dengan Google';

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
  String get cooking => 'Memasak';

  @override
  String get copyMessage => 'Salin pesan';

  @override
  String get copyrightInfringement => 'Pelanggaran hak cipta';

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
  String get currentLanguage => 'Bahasa Saat Ini';

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
  String get dailyLimitDescription => 'Anda telah mencapai batas pesan harian';

  @override
  String get dailyLimitTitle => 'Batas Harian Tercapai';

  @override
  String get darkMode => 'Mode gelap';

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
  String get day => 'Hari';

  @override
  String get dayAfterTomorrow => 'Day after tomorrow';

  @override
  String daysAgo(int count, String formatted) {
    return '$count hari yang lalu';
  }

  @override
  String daysRemaining(int days) {
    return '$days days remaining';
  }

  @override
  String get deepTalk => 'Deep Talk';

  @override
  String get delete => 'Hapus';

  @override
  String get deleteAccount => 'Hapus akun';

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
  String get depressed => 'Depresi';

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
  String get discount20 => 'Diskon 20%';

  @override
  String get discount30 => 'Diskon 30%';

  @override
  String get discountAmount => 'Jumlah diskon';

  @override
  String discountAmountValue(String amount) {
    return 'Save ₩$amount';
  }

  @override
  String get done => 'Selesai';

  @override
  String get downloadingPersonaImages => 'Downloading new persona images';

  @override
  String get edit => 'Edit';

  @override
  String get editInfo => 'Edit informasi';

  @override
  String get editProfile => 'Edit profil';

  @override
  String get effectSound => 'Efek suara';

  @override
  String get effectSoundDescription => 'Play sound effects';

  @override
  String get email => 'Email';

  @override
  String get emailHint => 'contoh@email.com';

  @override
  String get emailLabel => 'Email';

  @override
  String get emailRequired => 'Silakan masukkan email';

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
  String get endChat => 'Akhiri obrolan';

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
  String get enterBasicInformation => 'Masukkan informasi dasar';

  @override
  String get enterEmail => 'Masukkan email';

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
  String get error => 'Kesalahan';

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
  String get excited => 'Bersemangat';

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
  String get expired => 'Kedaluwarsa';

  @override
  String get explainReportReason =>
      'Please explain the report reason in detail';

  @override
  String get fashion => 'Mode';

  @override
  String get female => 'Perempuan';

  @override
  String get filter => 'Filter';

  @override
  String get firstOccurred => 'First Occurred: ';

  @override
  String get followDeviceLanguage => 'Follow device language settings';

  @override
  String get forenoon => 'Forenoon';

  @override
  String get forgotPassword => 'Lupa kata sandi?';

  @override
  String get frequentlyAskedQuestions => 'Pertanyaan yang sering diajukan';

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
  String get gender => 'Jenis kelamin';

  @override
  String get genderNotSelectedInfo =>
      'If gender is not selected, personas of all genders will be shown';

  @override
  String get genderOptional => 'Jenis kelamin (opsional)';

  @override
  String get genderPreferenceActive => 'You can meet personas of all genders';

  @override
  String get genderPreferenceDisabled =>
      'Select your gender to enable opposite gender only option';

  @override
  String get genderPreferenceInactive =>
      'Only opposite gender personas will be shown';

  @override
  String get genderRequired => 'Silakan pilih jenis kelamin';

  @override
  String get genderSelectionInfo =>
      'If not selected, you can meet personas of all genders';

  @override
  String get generalPersona => 'General Persona';

  @override
  String get goToSettings => 'Ke pengaturan';

  @override
  String get googleLoginCanceled =>
      'Google login was canceled.\nPlease try again.';

  @override
  String get googleLoginError => 'Error masuk Google';

  @override
  String get grantPermission => 'Lanjutkan';

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
  String get happy => 'Senang';

  @override
  String get hapticFeedback => 'Haptic Feedback';

  @override
  String get harassmentBullying => 'Harassment/Bullying';

  @override
  String get hateSpeech => 'Hate speech';

  @override
  String get heartDescription => 'Hearts for more messages';

  @override
  String get heartInsufficient => 'Hati tidak cukup';

  @override
  String get heartInsufficientPleaseCharge =>
      'Not enough hearts. Please recharge hearts.';

  @override
  String get heartRequired => '1 heart is required';

  @override
  String get heartUsageFailed => 'Failed to use heart.';

  @override
  String get hearts => 'Hati';

  @override
  String get hearts10 => '10 Hati';

  @override
  String get hearts30 => '30 Hati';

  @override
  String get hearts30Discount => '30 Hati (Diskon)';

  @override
  String get hearts50 => '50 Hati';

  @override
  String get hearts50Discount => '50 Hati (Diskon)';

  @override
  String get helloEmoji => 'Hello! 😊';

  @override
  String get help => 'Bantuan';

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
    return '$count jam yang lalu';
  }

  @override
  String get howToUse => 'Cara penggunaan';

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
  String get inquiries => 'Pertanyaan';

  @override
  String get insufficientHearts => 'Hati tidak cukup';

  @override
  String get interestSharing => 'Interest Sharing';

  @override
  String get interestSharingDesc => 'Discover and recommend shared interests';

  @override
  String get interests => 'Minat';

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
  String get joinDate => 'Tanggal bergabung';

  @override
  String get justNow => 'Baru saja';

  @override
  String get keepGuestData => 'Keep Chat History';

  @override
  String get korean => 'Korean';

  @override
  String get koreanLanguage => 'Korean';

  @override
  String get language => 'Bahasa';

  @override
  String get languageDescription => 'AI will respond in your selected language';

  @override
  String get languageIndicator => 'Language';

  @override
  String get languageSettings => 'Pengaturan bahasa';

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
  String get leave => 'Tinggalkan';

  @override
  String get leaveChatConfirm =>
      'Leave this chat?\nIt will disappear from your chat list.';

  @override
  String get leaveChatRoom => 'Leave Chat Room';

  @override
  String get leaveChatTitle => 'Tinggalkan obrolan';

  @override
  String get lifeAdvice => 'Life Advice';

  @override
  String get lightTalk => 'Light Talk';

  @override
  String get lightTheme => 'Light Mode';

  @override
  String get lightThemeDesc => 'Use bright theme';

  @override
  String get loading => 'Memuat...';

  @override
  String get loadingData => 'Loading data...';

  @override
  String get loadingProducts => 'Loading products...';

  @override
  String get loadingProfile => 'Loading profile';

  @override
  String get login => 'Masuk';

  @override
  String get loginButton => 'Login';

  @override
  String get loginCancelled => 'Masuk dibatalkan';

  @override
  String get loginComplete => 'Login complete';

  @override
  String get loginError => 'Error masuk';

  @override
  String get loginFailed => 'Login failed';

  @override
  String get loginFailedTryAgain => 'Login failed. Please try again.';

  @override
  String get loginRequired => 'Perlu masuk';

  @override
  String get loginRequiredForProfile =>
      'Login required to view profile\nand check records with SONA';

  @override
  String get loginRequiredService => 'Login required to use this service';

  @override
  String get loginRequiredTitle => 'Login Required';

  @override
  String get loginSignup => 'Masuk/Daftar';

  @override
  String get loginTab => 'Login';

  @override
  String get loginTitle => 'Login';

  @override
  String get loginWithApple => 'Login with Apple';

  @override
  String get loginWithGoogle => 'Login with Google';

  @override
  String get logout => 'Keluar';

  @override
  String get logoutConfirm => 'Are you sure you want to logout?';

  @override
  String get lonelinessRelief => 'Loneliness Relief';

  @override
  String get lonely => 'Kesepian';

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
  String get male => 'Laki-laki';

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
  String get meetAIPersonas => 'Temui Persona AI';

  @override
  String get meetNewPersonas => 'Meet New Personas';

  @override
  String get meetPersonas => 'Temui persona';

  @override
  String get memberBenefits =>
      'Get 100+ messages and 10 hearts when you sign up!';

  @override
  String get memoryAlbum => 'Memory Album';

  @override
  String get memoryAlbumDesc => 'Automatically save and recall special moments';

  @override
  String get messageCopied => 'Pesan disalin';

  @override
  String get messageDeleted => 'Pesan dihapus';

  @override
  String get messageLimitReset => 'Message limit will reset at midnight';

  @override
  String get messageSendFailed => 'Failed to send message. Please try again.';

  @override
  String get messagesRemaining => 'Pesan Tersisa';

  @override
  String minutesAgo(int count, String formatted) {
    return '$count menit yang lalu';
  }

  @override
  String get missingTranslation => 'Missing Translation';

  @override
  String get monday => 'Monday';

  @override
  String get month => 'Bulan';

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
  String get movies => 'Film';

  @override
  String get multilingualChat => 'Multilingual Chat';

  @override
  String get music => 'Musik';

  @override
  String get myGenderSection => 'Jenis kelamin saya';

  @override
  String get networkErrorOccurred => 'A network error occurred.';

  @override
  String get newMessage => 'Pesan baru';

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
  String get next => 'Berikutnya';

  @override
  String get niceToMeetYou => 'Nice to meet you!';

  @override
  String get nickname => 'Nama panggilan';

  @override
  String get nicknameAlreadyUsed => 'This nickname is already in use';

  @override
  String get nicknameHelperText => '3-10 characters';

  @override
  String get nicknameHint => 'Masukkan nama panggilan';

  @override
  String get nicknameInUse => 'This nickname is already in use';

  @override
  String get nicknameLabel => 'Nickname';

  @override
  String get nicknameLengthError => 'Nickname must be 3-10 characters';

  @override
  String get nicknamePlaceholder => 'Enter your nickname';

  @override
  String get nicknameRequired => 'Silakan masukkan nama panggilan';

  @override
  String get night => 'Night';

  @override
  String get no => 'Tidak';

  @override
  String get noBlockedAIs => 'No blocked AIs';

  @override
  String get noChatsYet => 'Belum ada obrolan';

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
  String get noPersonasAvailable => 'Tidak ada persona tersedia';

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
  String get notSubscribed => 'Tidak berlangganan';

  @override
  String get notificationPermissionDesc =>
      'Notification permission is required to receive new messages.';

  @override
  String get notificationPermissionRequired =>
      'Notification permission required';

  @override
  String get notificationSettings => 'Notification Settings';

  @override
  String get notifications => 'Notifikasi';

  @override
  String get occurrenceInfo => 'Occurrence Info:';

  @override
  String get olderChats => 'Lebih lama';

  @override
  String get onlyOppositeGenderNote =>
      'If unchecked, only opposite gender personas will be shown';

  @override
  String get openSettings => 'Open Settings';

  @override
  String get optional => 'Opsional';

  @override
  String get or => 'atau';

  @override
  String get originalPrice => 'Harga asli';

  @override
  String get originalText => 'Original';

  @override
  String get other => 'Lainnya';

  @override
  String get otherError => 'Other Error';

  @override
  String get others => 'Lainnya';

  @override
  String get ownedHearts => 'Owned Hearts';

  @override
  String get parentsDay => 'Parents\' Day';

  @override
  String get password => 'Kata sandi';

  @override
  String get passwordConfirmation => 'Enter password to confirm';

  @override
  String get passwordConfirmationDesc =>
      'Please re-enter your password to delete account.';

  @override
  String get passwordHint => 'Masukkan kata sandi';

  @override
  String get passwordLabel => 'Password';

  @override
  String get passwordRequired => 'Silakan masukkan kata sandi';

  @override
  String get passwordResetEmailPrompt =>
      'Please enter your email to reset password';

  @override
  String get passwordResetEmailSent =>
      'Password reset email has been sent. Please check your email.';

  @override
  String get passwordText => 'password';

  @override
  String get passwordTooShort => 'Kata sandi minimal 6 karakter';

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
  String get personaGenderSection => 'Jenis kelamin persona';

  @override
  String get personaQualityStats => 'Persona Quality Statistics';

  @override
  String get personalInfoExposure => 'Personal information exposure';

  @override
  String get personality => 'Personality';

  @override
  String get pets => 'Pets';

  @override
  String get photo => 'Foto';

  @override
  String get photography => 'Fotografi';

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
  String get previous => 'Sebelumnya';

  @override
  String get privacy => 'Privasi';

  @override
  String get privacyPolicy => 'Kebijakan Privasi';

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
  String get privacySettings => 'Pengaturan privasi';

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
  String get profile => 'Profil';

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
  String get profilePhoto => 'Foto profil';

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
  String get purchaseButton => 'Beli';

  @override
  String get purchaseConfirm => 'Konfirmasi pembelian';

  @override
  String purchaseConfirmContent(String product, String price) {
    return 'Beli $product seharga $price?';
  }

  @override
  String purchaseConfirmMessage(
      String title, String price, String description) {
    return 'Konfirmasi pembelian $title seharga $price? $description';
  }

  @override
  String get purchaseFailed => 'Purchase failed';

  @override
  String get purchaseHeartsOnly => 'Beli hati saja';

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
  String get pushNotifications => 'Notifikasi push';

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
  String get referrerEmailLabel => 'Email perujuk';

  @override
  String get refresh => 'Segarkan';

  @override
  String refreshComplete(int count) {
    return 'Refresh complete! $count matched personas';
  }

  @override
  String get refreshFailed => 'Refresh failed';

  @override
  String get refreshingChatList => 'Refreshing chat list...';

  @override
  String get relatedFAQ => 'FAQ terkait';

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
  String get reportSubmitted => 'Laporan terkirim';

  @override
  String get reportSubmittedSuccess =>
      'Your report has been submitted. Thank you!';

  @override
  String get requestLimit => 'Request Limit';

  @override
  String get required => 'Wajib';

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
  String get retry => 'Coba lagi';

  @override
  String get retryButton => 'Retry';

  @override
  String get sad => 'Sedih';

  @override
  String get saturday => 'Saturday';

  @override
  String get save => 'Simpan';

  @override
  String get search => 'Cari';

  @override
  String get searchFAQ => 'Cari FAQ';

  @override
  String get searchResults => 'Hasil pencarian';

  @override
  String get selectEmotion => 'Select Emotion';

  @override
  String get selectErrorType => 'Select error type';

  @override
  String get selectFeeling => 'Bagaimana perasaan Anda?';

  @override
  String get selectGender => 'Pilih jenis kelamin';

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
  String get selfIntroduction => 'Perkenalan diri';

  @override
  String get selfIntroductionHint => 'Ceritakan tentang diri Anda';

  @override
  String get send => 'Kirim';

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
  String get sessionExpired => 'Sesi berakhir';

  @override
  String get setAppInterfaceLanguage => 'Set app interface language';

  @override
  String get setNow => 'Atur sekarang';

  @override
  String get settings => 'Pengaturan';

  @override
  String get sexualContent => 'Sexual content';

  @override
  String get showAllGenderPersonas => 'Tampilkan Semua Gender Persona';

  @override
  String get showAllGendersOption => 'Tampilkan semua jenis kelamin';

  @override
  String get showOppositeGenderOnly =>
      'If unchecked, only opposite gender personas will be shown';

  @override
  String get showOriginalText => 'Show Original';

  @override
  String get signUp => 'Daftar';

  @override
  String get signUpFromGuest => 'Sign up now to access all features!';

  @override
  String get signup => 'Daftar';

  @override
  String get signupComplete => 'Sign Up Complete';

  @override
  String get signupTab => 'Sign Up';

  @override
  String get simpleInfoRequired =>
      'Simple information is required\nfor matching with AI personas';

  @override
  String get skip => 'Lewati';

  @override
  String get sonaFriend => 'Teman SONA';

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
  String get sort => 'Urutkan';

  @override
  String get soundSettings => 'Pengaturan suara';

  @override
  String get spamAdvertising => 'Spam/Advertising';

  @override
  String get spanish => 'Spanish';

  @override
  String get specialRelationshipDesc =>
      'Understand each other and build deep bonds';

  @override
  String get sports => 'Olahraga';

  @override
  String get spring => 'Spring';

  @override
  String get startChat => 'Mulai obrolan';

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
  String get startWithEmail => 'Mulai dengan Email';

  @override
  String get startWithGoogle => 'Mulai dengan Google';

  @override
  String get startingApp => 'Starting app';

  @override
  String get storageManagement => 'Storage Management';

  @override
  String get store => 'Toko';

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
  String get stressed => 'Stres';

  @override
  String get submitReport => 'Submit Report';

  @override
  String get subscriptionStatus => 'Status langganan';

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
  String get tapBottomForDetails => 'Ketuk bagian bawah untuk detail';

  @override
  String get tapForDetails => 'Tap bottom area for details';

  @override
  String get tapToSwipePhotos => 'Tap to swipe photos';

  @override
  String get teachersDay => 'Teachers\' Day';

  @override
  String get technicalError => 'Technical Error';

  @override
  String get technology => 'Teknologi';

  @override
  String get terms => 'Ketentuan';

  @override
  String get termsAgreement => 'Terms Agreement';

  @override
  String get termsAgreementDescription =>
      'Please agree to the terms for using the service';

  @override
  String get termsOfService => 'Ketentuan Layanan';

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
  String get thanksFeedback => 'Terima kasih atas masukan Anda';

  @override
  String get theme => 'Tema';

  @override
  String get themeDescription =>
      'You can customize the app appearance as you like';

  @override
  String get themeSettings => 'Pengaturan tema';

  @override
  String get thursday => 'Thursday';

  @override
  String get timeout => 'Timeout';

  @override
  String get tired => 'Lelah';

  @override
  String get today => 'Hari ini';

  @override
  String get todayChats => 'Hari ini';

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
  String get travel => 'Perjalanan';

  @override
  String get tuesday => 'Tuesday';

  @override
  String get tutorialAccount => 'Akun tutorial';

  @override
  String get tutorialWelcomeDescription =>
      'Ciptakan hubungan istimewa dengan persona AI.';

  @override
  String get tutorialWelcomeTitle => 'Selamat datang di SONA!';

  @override
  String get typeMessage => 'Ketik pesan...';

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
  String get unsendMessage => 'Batalkan kirim pesan';

  @override
  String get usagePurpose => 'Tujuan penggunaan';

  @override
  String get useOneHeart => 'Use 1 Heart';

  @override
  String get useSystemLanguage => 'Use System Language';

  @override
  String get user => 'User: ';

  @override
  String get userMessage => 'User Message:';

  @override
  String get userNotFound => 'Pengguna tidak ditemukan';

  @override
  String get valentinesDay => 'Valentine\'s Day';

  @override
  String get verifyingAuth => 'Verifying authentication';

  @override
  String get version => 'Versi';

  @override
  String get vietnamese => 'Vietnamese';

  @override
  String get violentContent => 'Violent content';

  @override
  String get voiceMessage => 'Pesan suara';

  @override
  String waitingForChat(String name) {
    return '$name is waiting to chat.';
  }

  @override
  String get walk => 'Walk';

  @override
  String get wasHelpful => 'Apakah membantu?';

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
  String get weatherRainy => 'Hujan';

  @override
  String get weatherSnow => 'Snow';

  @override
  String get weatherSnowy => 'Bersalju';

  @override
  String get weatherThunderstorm => 'Thunderstorm';

  @override
  String get wednesday => 'Wednesday';

  @override
  String get weekdays => 'Min,Sen,Sel,Rab,Kam,Jum,Sab';

  @override
  String get welcomeMessage => 'Selamat datang💕';

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
  String get year => 'Tahun';

  @override
  String get yearEnd => 'Year End';

  @override
  String get yes => 'Ya';

  @override
  String get yesterday => 'Kemarin';

  @override
  String get yesterdayChats => 'Kemarin';

  @override
  String get you => 'Anda';
}
