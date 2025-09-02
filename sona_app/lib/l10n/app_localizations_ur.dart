// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Urdu (`ur`).
class AppLocalizationsUr extends AppLocalizations {
  AppLocalizationsUr([String locale = 'ur']) : super(locale);

  @override
  String get about => 'بارے میں';

  @override
  String get accountAndProfile => 'اکاؤنٹ اور پروفائل کی معلومات';

  @override
  String get accountDeletedSuccess => 'اکاؤنٹ کامیابی سے حذف کر دیا گیا';

  @override
  String get accountDeletionContent =>
      'کیا آپ واقعی اپنا اکاؤنٹ حذف کرنا چاہتے ہیں؟';

  @override
  String get accountDeletionError => 'اکاؤنٹ حذف کرتے وقت خرابی پیش آئی۔';

  @override
  String get accountDeletionInfo => 'اکاؤنٹ حذف کرنے کی معلومات';

  @override
  String get accountDeletionTitle => 'اکاؤنٹ حذف کریں';

  @override
  String get accountDeletionWarning1 => 'انتباہ: یہ عمل واپس نہیں لیا جا سکتا';

  @override
  String get accountDeletionWarning2 =>
      'آپ کا تمام ڈیٹا مستقل طور پر حذف کر دیا جائے گا';

  @override
  String get accountDeletionWarning3 => 'آپ تمام گفتگوؤں تک رسائی کھو دیں گے';

  @override
  String get accountDeletionWarning4 => 'اس میں تمام خریدی گئی مواد شامل ہے';

  @override
  String get accountManagement => 'اکاؤنٹ کا انتظام';

  @override
  String get adaptiveConversationDesc =>
      'گفتگو کے انداز کو آپ کے انداز کے مطابق ڈھالتا ہے';

  @override
  String get afternoon => 'دوپہر';

  @override
  String get afternoonFatigue => 'دوپہر کی تھکن';

  @override
  String get ageConfirmation =>
      'میں 14 سال یا اس سے زیادہ عمر کا ہوں اور اوپر دی گئی معلومات کی تصدیق کرتا ہوں۔';

  @override
  String ageRange(int min, int max) {
    return '$min-$max سال';
  }

  @override
  String get ageUnit => 'سال';

  @override
  String get agreeToTerms => 'میں شرائط سے متفق ہوں';

  @override
  String get aiDatingQuestion => 'AI کے ساتھ ایک خاص روزمرہ کی زندگی';

  @override
  String get aiPersonaPreferenceDescription =>
      'براہ کرم AI کردار کے میچنگ کے لیے اپنی ترجیحات طے کریں';

  @override
  String get all => 'سب';

  @override
  String get allAgree => 'سب سے متفق ہوں';

  @override
  String get allFeaturesRequired =>
      '※ سروس کی فراہمی کے لیے تمام خصوصیات ضروری ہیں';

  @override
  String get allPersonas => 'تمام کردار';

  @override
  String get allPersonasMatched =>
      'تمام شخصیات مل گئیں! ان کے ساتھ بات چیت شروع کریں۔';

  @override
  String get allowPermission => 'جاری رکھیں';

  @override
  String alreadyChattingWith(String name) {
    return 'پہلے ہی $name کے ساتھ بات چیت کر رہے ہیں!';
  }

  @override
  String get alsoBlockThisAI => 'اس AI کو بھی بلاک کریں';

  @override
  String get angry => 'ناراض';

  @override
  String get anonymousLogin => 'نامعلوم لاگ ان';

  @override
  String get anxious => 'بے چینی';

  @override
  String get apiKeyError => 'API کی چابی کی غلطی';

  @override
  String get appName => 'SONA';

  @override
  String get appTagline => 'آپ کے AI ساتھی';

  @override
  String get appleLoginCanceled =>
      'ایپل لاگ ان منسوخ کر دیا گیا۔ براہ کرم دوبارہ کوشش کریں۔';

  @override
  String get appleLoginError => 'ایپل لاگ ان کے دوران ایک غلطی پیش آئی۔';

  @override
  String get art => 'فن';

  @override
  String get authError => 'توثیق کی غلطی';

  @override
  String get autoTranslate => 'خودکار ترجمہ';

  @override
  String get autumn => 'خزاں';

  @override
  String get averageQuality => 'اوسط معیار';

  @override
  String get averageQualityScore => 'اوسط معیار کا اسکور';

  @override
  String get awkwardExpression => 'عجیب اظہار';

  @override
  String get backButton => 'واپس';

  @override
  String get basicInfo => 'بنیادی معلومات';

  @override
  String get basicInfoDescription =>
      'براہ کرم اکاؤنٹ بنانے کے لیے بنیادی معلومات درج کریں';

  @override
  String get birthDate => 'تاریخ پیدائش';

  @override
  String get birthDateOptional => 'تاریخ پیدائش (اختیاری)';

  @override
  String get birthDateRequired => 'تاریخ پیدائش *';

  @override
  String get blockConfirm => 'کیا آپ اس AI کو بلاک کرنا چاہتے ہیں؟';

  @override
  String get blockReason => 'بلاک کرنے کی وجہ';

  @override
  String get blockThisAI => 'اس AI کو بلاک کریں';

  @override
  String blockedAICount(int count) {
    return '$count بلاک شدہ AIs';
  }

  @override
  String get blockedAIs => 'بلاک شدہ AIs';

  @override
  String get blockedAt => 'بلاک کیا گیا';

  @override
  String get blockedSuccessfully => 'کامیابی سے بلاک کیا گیا';

  @override
  String get breakfast => 'ناشتہ';

  @override
  String get byErrorType => 'غلطی کی قسم کے لحاظ سے';

  @override
  String get byPersona => 'بائی پرونا';

  @override
  String cacheDeleteError(String error) {
    return 'کیش حذف کرنے میں غلطی: $error';
  }

  @override
  String get cacheDeleted => 'امیج کیش حذف کر دی گئی ہے';

  @override
  String get cafeTerrace => 'کیفے کی چھت';

  @override
  String get calm => 'پرسکون';

  @override
  String get cameraPermission => 'کیمرہ کی اجازت';

  @override
  String get cameraPermissionDesc =>
      'تصویر لینے کے لیے ہمیں کیمرہ کی اجازت چاہیے۔';

  @override
  String get canChangeInSettings =>
      'آپ اسے بعد میں سیٹنگز میں تبدیل کر سکتے ہیں';

  @override
  String get canMeetPreviousPersonas =>
      'آپ پہلے ملے ہوئے پرسوناز سے دوبارہ مل سکتے ہیں!';

  @override
  String get cancel => 'منسوخ کریں';

  @override
  String get changeProfilePhoto => 'پروفائل تصویر تبدیل کریں';

  @override
  String get chat => 'چیٹ';

  @override
  String get chatEndedMessage => 'چیٹ ختم ہو گئی ہے';

  @override
  String get chatErrorDashboard => 'چیٹ کی خرابی کا ڈیش بورڈ';

  @override
  String get chatErrorSentSuccessfully =>
      'چیٹ کی خرابی کامیابی سے بھیج دی گئی ہے۔';

  @override
  String get chatListTab => 'چیٹ کی فہرست کا ٹیب';

  @override
  String get chats => 'چیٹس';

  @override
  String chattingWithPersonas(int count) {
    return '$count شخصیات کے ساتھ چیٹنگ';
  }

  @override
  String get checkInternetConnection =>
      'براہ کرم اپنے انٹرنیٹ کنکشن کی جانچ کریں';

  @override
  String get checkingUserInfo => 'صارف کی معلومات کی جانچ کر رہا ہے';

  @override
  String get childrensDay => 'بچوں کا دن';

  @override
  String get chinese => 'چینی';

  @override
  String get chooseOption => 'براہ کرم منتخب کریں:';

  @override
  String get christmas => 'کرسمس';

  @override
  String get close => 'بند کریں';

  @override
  String get complete => 'مکمل';

  @override
  String get completeSignup => 'سائن اپ مکمل کریں';

  @override
  String get confirm => 'تصدیق کریں';

  @override
  String get connectingToServer => 'سرور سے جڑنا';

  @override
  String get consultQualityMonitoring => 'مشاورت کے معیار کی نگرانی';

  @override
  String get continueAsGuest => 'مہمان کے طور پر جاری رکھیں';

  @override
  String get continueButton => 'جاری رکھیں';

  @override
  String get continueWithApple => 'ایپل کے ساتھ جاری رکھیں';

  @override
  String get continueWithGoogle => 'گوگل کے ساتھ جاری رکھیں';

  @override
  String get conversationContinuity => 'گفتگو کی تسلسل';

  @override
  String get conversationContinuityDesc =>
      'پچھلی گفتگوؤں کو یاد رکھیں اور موضوعات کو جوڑیں';

  @override
  String conversationWith(String name) {
    return '$name';
  }

  @override
  String get convertToMember => 'سائن اپ';

  @override
  String get cooking => 'کھانا پکانا';

  @override
  String get copyMessage => 'پیغام کاپی کریں';

  @override
  String get copyrightInfringement => 'کاپی رائٹ کی خلاف ورزی';

  @override
  String get creatingAccount => 'اکاؤنٹ بنا رہے ہیں';

  @override
  String get crisisDetected => 'بحران کا پتہ چلا';

  @override
  String get culturalIssue => 'ثقافتی مسئلہ';

  @override
  String get current => 'موجودہ';

  @override
  String get currentCacheSize => 'موجودہ کیش سائز';

  @override
  String get currentLanguage => 'موجودہ زبان';

  @override
  String get cycling => 'سائیکلنگ';

  @override
  String get dailyCare => 'روزانہ کی دیکھ بھال';

  @override
  String get dailyCareDesc =>
      'کھانے، نیند، صحت کے لیے روزانہ کی دیکھ بھال کے پیغامات';

  @override
  String get dailyChat => 'روزانہ کی گفتگو';

  @override
  String get dailyCheck => 'روزانہ کی جانچ';

  @override
  String get dailyConversation => 'روزانہ کی بات چیت';

  @override
  String get dailyLimitDescription =>
      'آپ نے اپنے روزانہ کے پیغام کی حد تک پہنچ چکے ہیں';

  @override
  String get dailyLimitTitle => 'روزانہ کی حد پوری ہو گئی';

  @override
  String get darkMode => 'ڈارک موڈ';

  @override
  String get darkTheme => 'تاریک موڈ';

  @override
  String get darkThemeDesc => 'تاریک تھیم استعمال کریں';

  @override
  String get dataCollection => 'ڈیٹا جمع کرنے کی ترتیبات';

  @override
  String get datingAdvice => 'ڈیٹنگ کے مشورے';

  @override
  String get datingDescription =>
      'میں گہرے خیالات کا تبادلہ کرنا چاہتا ہوں اور مخلصانہ گفتگو کرنا چاہتا ہوں';

  @override
  String get dawn => 'صبح';

  @override
  String get day => 'Day';

  @override
  String get dayAfterTomorrow => 'Day after tomorrow';

  @override
  String daysAgo(int count, String formatted) {
    return '$count دن پہلے';
  }

  @override
  String daysRemaining(int days) {
    return '$days days remaining';
  }

  @override
  String get deepTalk => 'Deep Talk';

  @override
  String get delete => 'حذف کریں';

  @override
  String get deleteAccount => 'اکاؤنٹ حذف کریں';

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
  String get depressed => 'ڈپریسڈ';

  @override
  String get describeError => 'مسئلہ کیا ہے؟';

  @override
  String get detailedReason => 'تفصیلی وجہ';

  @override
  String get developRelationshipStep =>
      '3. تعلقات تیار کریں: بات چیت کے ذریعے قربت پیدا کریں اور خاص تعلقات بنائیں۔';

  @override
  String get dinner => 'رات کا کھانا';

  @override
  String get discardGuestData => 'تازہ شروع کریں';

  @override
  String get discount20 => '20% رعایت';

  @override
  String get discount30 => '30% رعایت';

  @override
  String get discountAmount => 'بچت کریں';

  @override
  String discountAmountValue(String amount) {
    return 'بچت کریں ₩$amount';
  }

  @override
  String get done => 'ہو گیا';

  @override
  String get downloadingPersonaImages => 'نئے پرسنہ امیجز ڈاؤن لوڈ ہو رہے ہیں';

  @override
  String get edit => 'ترمیم کریں';

  @override
  String get editInfo => 'معلومات میں ترمیم کریں';

  @override
  String get editProfile => 'پروفائل میں ترمیم کریں';

  @override
  String get effectSound => 'صوتی اثرات';

  @override
  String get effectSoundDescription => 'صوتی اثرات چلائیں';

  @override
  String get email => 'ای میل';

  @override
  String get emailHint => 'example@email.com';

  @override
  String get emailLabel => 'ای میل';

  @override
  String get emailRequired => 'ای میل *';

  @override
  String get emotionAnalysis => 'جذباتی تجزیہ';

  @override
  String get emotionAnalysisDesc => 'ہمدردانہ جواب کے لئے جذبات کا تجزیہ کریں';

  @override
  String get emotionAngry => 'ناراض';

  @override
  String get emotionBasedEncounters => 'اپنے جذبات کی بنیاد پر شخصیات سے ملیں';

  @override
  String get emotionCool => 'ٹھنڈا';

  @override
  String get emotionHappy => 'خوش';

  @override
  String get emotionLove => 'محبت';

  @override
  String get emotionSad => 'اداسی';

  @override
  String get emotionThinking => 'سوچنا';

  @override
  String get emotionalSupportDesc =>
      'اپنی تشویشات کا اظہار کریں اور گرم تسلی حاصل کریں';

  @override
  String get endChat => 'چیٹ ختم کریں';

  @override
  String get endTutorial => 'سبق ختم کریں';

  @override
  String get endTutorialAndLogin => 'سبق ختم کریں اور لاگ ان کریں؟';

  @override
  String get endTutorialMessage =>
      'کیا آپ سبق ختم کرنا چاہتے ہیں اور لاگ ان کرنا چاہتے ہیں؟';

  @override
  String get english => 'انگریزی';

  @override
  String get enterBasicInfo =>
      'براہ کرم اکاؤنٹ بنانے کے لیے بنیادی معلومات درج کریں';

  @override
  String get enterBasicInformation => 'براہ کرم بنیادی معلومات درج کریں';

  @override
  String get enterEmail => 'ای میل درج کریں';

  @override
  String get enterNickname => 'براہ کرم ایک نک نیم درج کریں';

  @override
  String get enterPassword => 'پاس ورڈ درج کریں';

  @override
  String get entertainmentAndFunDesc =>
      'مزے دار کھیلوں اور خوشگوار گفتگو کا لطف اٹھائیں';

  @override
  String get entertainmentDescription =>
      'میں خوشگوار گفتگو کرنا چاہتا ہوں اور اپنا وقت گزارنا چاہتا ہوں';

  @override
  String get entertainmentFun => 'تفریح/مزہ';

  @override
  String get error => 'خرابی';

  @override
  String get errorDescription => 'غلطی کی وضاحت';

  @override
  String get errorDescriptionHint =>
      'مثلاً، عجیب جوابات دیے، ایک ہی بات کو دہرایا، سیاق و سباق کے لحاظ سے نامناسب جوابات دیے...';

  @override
  String get errorDetails => 'غلطی کی تفصیلات';

  @override
  String get errorDetailsHint => 'براہ کرم تفصیل سے وضاحت کریں کہ کیا غلط ہے';

  @override
  String get errorFrequency24h => 'غلطی کی تعدد (آخری 24 گھنٹے)';

  @override
  String get errorMessage => 'غلطی کا پیغام:';

  @override
  String get errorOccurred => 'ایک غلطی ہوئی ہے۔';

  @override
  String get errorOccurredTryAgain =>
      'ایک غلطی ہوئی ہے۔ براہ کرم دوبارہ کوشش کریں۔';

  @override
  String get errorSendingFailed => 'غلطی بھیجنے میں ناکامی';

  @override
  String get errorStats => 'غلطی کی شماریات';

  @override
  String errorWithMessage(String error) {
    return 'غلطی ہوئی: $error';
  }

  @override
  String get evening => 'شام';

  @override
  String get excited => 'پرجوش';

  @override
  String get exit => 'باہر نکلیں';

  @override
  String get exitApp => 'ایپ بند کریں';

  @override
  String get exitConfirmMessage => 'کیا آپ واقعی ایپ بند کرنا چاہتے ہیں؟';

  @override
  String get expertPersona => 'ماہر شخصیت';

  @override
  String get expertiseScore => 'مہارت کا اسکور';

  @override
  String get expired => 'ختم ہو گیا';

  @override
  String get explainReportReason => 'براہ کرم رپورٹ کی وجہ کی تفصیل بیان کریں';

  @override
  String get fashion => 'فیشن';

  @override
  String get female => 'عورت';

  @override
  String get filter => 'فلٹر';

  @override
  String get firstOccurred => 'پہلی بار ہوا:';

  @override
  String get followDeviceLanguage => 'ڈیوائس کی زبان کی ترتیبات کی پیروی کریں';

  @override
  String get forenoon => 'صبح';

  @override
  String get forgotPassword => 'پاس ورڈ بھول گئے؟';

  @override
  String get frequentlyAskedQuestions => 'اکثر پوچھے جانے والے سوالات';

  @override
  String get friday => 'جمعہ';

  @override
  String get friendshipDescription =>
      'میں نئے دوست بنانا چاہتا ہوں اور بات چیت کرنا چاہتا ہوں';

  @override
  String get funChat => 'مزے دار گفتگو';

  @override
  String get galleryPermission => 'گیلری کی اجازت';

  @override
  String get galleryPermissionDesc =>
      'تصاویر چننے کے لیے ہمیں گیلری کی اجازت چاہیے۔';

  @override
  String get gaming => 'گیمنگ';

  @override
  String get gender => 'جنس';

  @override
  String get genderNotSelectedInfo =>
      'اگر جنس منتخب نہیں کی گئی تو تمام جنسوں کے کردار دکھائے جائیں گے';

  @override
  String get genderOptional => 'جنس (اختیاری)';

  @override
  String get genderPreferenceActive =>
      'آپ تمام جنسوں کے کرداروں سے مل سکتے ہیں';

  @override
  String get genderPreferenceDisabled =>
      'صرف مخالف جنس کے آپشن کو فعال کرنے کے لیے اپنی جنس منتخب کریں';

  @override
  String get genderPreferenceInactive =>
      'صرف مخالف جنس کے کردار دکھائے جائیں گے';

  @override
  String get genderRequired => 'جنس *';

  @override
  String get genderSelectionInfo =>
      'اگر منتخب نہیں کیا گیا تو آپ تمام جنسوں کے کرداروں سے مل سکتے ہیں';

  @override
  String get generalPersona => 'عمومی کردار';

  @override
  String get goToSettings => 'سیٹنگز پر جائیں';

  @override
  String get googleLoginCanceled => 'گوگل لاگ ان منسوخ کر دیا گیا۔';

  @override
  String get googleLoginError => 'گوگل لاگ ان کے دوران ایک غلطی پیش آئی۔';

  @override
  String get grantPermission => 'جاری رکھیں';

  @override
  String get guest => 'مہمان';

  @override
  String get guestDataMigration =>
      'کیا آپ سائن اپ کرتے وقت اپنی موجودہ چیٹ کی تاریخ کو برقرار رکھنا چاہیں گے؟';

  @override
  String get guestLimitReached => 'مہمان کی آزمائش ختم ہوگئی۔';

  @override
  String get guestLoginPromptMessage => 'گفتگو جاری رکھنے کے لیے لاگ ان کریں';

  @override
  String get guestMessageExhausted => 'مفت پیغامات ختم ہوگئے';

  @override
  String guestMessageRemaining(int count) {
    return '$count مہمان پیغامات باقی ہیں';
  }

  @override
  String get guestModeBanner => 'مہمان موڈ';

  @override
  String get guestModeDescription => 'سائن اپ کیے بغیر SONA آزمائیں';

  @override
  String get guestModeFailedMessage => 'مہمان موڈ شروع کرنے میں ناکامی';

  @override
  String get guestModeLimitation => 'مہمان موڈ میں کچھ خصوصیات محدود ہیں';

  @override
  String get guestModeTitle => 'مہمان کے طور پر کوشش کریں';

  @override
  String get guestModeWarning => 'مہمان کا موڈ 24 گھنٹے تک جاری رہتا ہے،';

  @override
  String get guestModeWelcome => 'مہمان کے موڈ میں شروع ہو رہا ہے';

  @override
  String get happy => 'خوش';

  @override
  String get hapticFeedback => 'ہاپٹک فیڈبیک';

  @override
  String get harassmentBullying => 'ہراسانی/بدسلوکی';

  @override
  String get hateSpeech => 'نفرت انگیز تقریر';

  @override
  String get heartDescription => 'مزید پیغامات کے لیے دل';

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
  String get hearts50 => '50 دل';

  @override
  String get hearts50Discount => 'سیل';

  @override
  String get helloEmoji => 'ہیلو! 😊';

  @override
  String get help => 'مدد';

  @override
  String get hideOriginalText => 'اصل متن چھپائیں';

  @override
  String get hobbySharing => 'مشاغل کا اشتراک';

  @override
  String get hobbyTalk => 'مشاغل پر بات چیت';

  @override
  String get hours24Ago => '24 گھنٹے پہلے';

  @override
  String hoursAgo(int count, String formatted) {
    return '$count گھنٹے پہلے';
  }

  @override
  String get howToUse => 'SONA کا استعمال کیسے کریں';

  @override
  String get imageCacheManagement => 'امیج کیش مینجمنٹ';

  @override
  String get inappropriateContent => 'نامناسب مواد';

  @override
  String get incorrect => 'غلط';

  @override
  String get incorrectPassword => 'غلط پاس ورڈ';

  @override
  String get indonesian => 'انڈونیشیائی';

  @override
  String get inquiries => 'انکوائریاں';

  @override
  String get insufficientHearts => 'ناکافی دل۔';

  @override
  String get interestSharing => 'دلچسپی کا اشتراک';

  @override
  String get interestSharingDesc =>
      'مشترکہ دلچسپیاں دریافت کریں اور تجویز کریں';

  @override
  String get interests => 'دلچسپیاں';

  @override
  String get invalidEmailFormat => 'ای میل کا غلط فارمیٹ';

  @override
  String get invalidEmailFormatError =>
      'براہ کرم ایک درست ای میل ایڈریس درج کریں';

  @override
  String isTyping(String name) {
    return '$name ٹائپ کر رہا ہے...';
  }

  @override
  String get japanese => 'جاپانی';

  @override
  String get joinDate => 'شمولیت کی تاریخ';

  @override
  String get justNow => 'ابھی';

  @override
  String get keepGuestData => 'چیٹ کی تاریخ محفوظ رکھیں';

  @override
  String get korean => 'کورین';

  @override
  String get koreanLanguage => 'کورین';

  @override
  String get language => 'زبان';

  @override
  String get languageDescription => 'AI آپ کی منتخب کردہ زبان میں جواب دے گا';

  @override
  String get languageIndicator => 'زبان';

  @override
  String get languageSettings => 'زبان کی ترتیبات';

  @override
  String get lastOccurred => 'آخری بار ہوا:';

  @override
  String get lastUpdated => 'آخری بار اپ ڈیٹ ہوا';

  @override
  String get lateNight => 'رات دیر سے';

  @override
  String get later => 'بعد';

  @override
  String get laterButton => 'بعد';

  @override
  String get leave => 'چھوڑیں';

  @override
  String get leaveChatConfirm => 'کیا آپ اس چیٹ کو چھوڑنا چاہتے ہیں؟';

  @override
  String get leaveChatRoom => 'چیٹ روم چھوڑیں';

  @override
  String get leaveChatTitle => 'چیٹ چھوڑیں';

  @override
  String get lifeAdvice => 'زندگی کی نصیحت';

  @override
  String get lightTalk => 'ہلکی پھلکی بات چیت';

  @override
  String get lightTheme => 'روشنی کا موڈ';

  @override
  String get lightThemeDesc => 'روشن تھیم استعمال کریں';

  @override
  String get loading => 'لوڈ ہو رہا ہے...';

  @override
  String get loadingData => 'ڈیٹا لوڈ ہو رہا ہے...';

  @override
  String get loadingProducts => 'مصنوعات لوڈ ہو رہی ہیں...';

  @override
  String get loadingProfile => 'پروفائل لوڈ ہو رہی ہے';

  @override
  String get login => 'لاگ ان';

  @override
  String get loginButton => 'لاگ ان';

  @override
  String get loginCancelled => 'لاگ ان منسوخ';

  @override
  String get loginComplete => 'لاگ ان مکمل';

  @override
  String get loginError => 'لاگ ان ناکام ہوا';

  @override
  String get loginFailed => 'لاگ ان ناکام ہوا';

  @override
  String get loginFailedTryAgain =>
      'لاگ ان ناکام ہوا۔ براہ کرم دوبارہ کوشش کریں۔';

  @override
  String get loginRequired => 'لاگ ان ضروری ہے';

  @override
  String get loginRequiredForProfile => 'پروفائل دیکھنے کے لیے لاگ ان ضروری ہے';

  @override
  String get loginRequiredService =>
      'اس سروس کو استعمال کرنے کے لیے لاگ ان ضروری ہے';

  @override
  String get loginRequiredTitle => 'لاگ ان ضروری ہے';

  @override
  String get loginSignup => 'لاگ ان/سائن اپ';

  @override
  String get loginTab => 'لاگ ان';

  @override
  String get loginTitle => 'لاگ ان';

  @override
  String get loginWithApple => 'ایپل کے ساتھ لاگ ان';

  @override
  String get loginWithGoogle => 'گوگل کے ساتھ لاگ ان';

  @override
  String get logout => 'لاگ آؤٹ';

  @override
  String get logoutConfirm => 'کیا آپ واقعی لاگ آؤٹ کرنا چاہتے ہیں؟';

  @override
  String get lonelinessRelief => 'تنہائی کی راحت';

  @override
  String get lonely => 'تنہا';

  @override
  String get lowQualityResponses => 'کم معیار کے جوابات';

  @override
  String get lunch => 'Lunch';

  @override
  String get lunchtime => 'Lunchtime';

  @override
  String get mainErrorType => 'Main Error Type';

  @override
  String get makeFriends => 'Make Friends';

  @override
  String get male => 'مرد';

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
      '1. شخصیات کا ملاپ: اپنے پسندیدہ AI شخصیات کو منتخب کرنے کے لیے بائیں یا دائیں سوائپ کریں۔';

  @override
  String get matchedPersonas => 'ملاپ شدہ شخصیات';

  @override
  String get matchedSona => 'ملاپ شدہ سونا';

  @override
  String get matching => 'ملاپ';

  @override
  String get matchingFailed => 'ملاپ ناکام ہوگیا۔';

  @override
  String get me => 'Me';

  @override
  String get meetAIPersonas => 'AI شخصیات سے ملیں';

  @override
  String get meetNewPersonas => 'نئی شخصیات سے ملیں';

  @override
  String get meetPersonas => 'شخصیات سے ملیں';

  @override
  String get memberBenefits =>
      'سائن اپ کرنے پر 100+ پیغامات اور 10 دل حاصل کریں!';

  @override
  String get memoryAlbum => 'یادوں کا البم';

  @override
  String get memoryAlbumDesc => 'خاص لمحات کو خود بخود محفوظ کریں اور یاد کریں';

  @override
  String get messageCopied => 'پیغام کاپی کر لیا گیا';

  @override
  String get messageDeleted => 'پیغام حذف کر دیا گیا';

  @override
  String get messageLimitReset =>
      'پیغام کی حد آدھی رات کو دوبارہ شروع ہو جائے گی';

  @override
  String get messageSendFailed =>
      'پیغام بھیجنے میں ناکامی۔ براہ کرم دوبارہ کوشش کریں۔';

  @override
  String get messagesRemaining => 'باقی پیغامات';

  @override
  String minutesAgo(int count, String formatted) {
    return '$count منٹ پہلے';
  }

  @override
  String get missingTranslation => 'Missing Translation';

  @override
  String get monday => 'پیر';

  @override
  String get month => 'مہینہ';

  @override
  String monthDay(String month, int day) {
    return '$month $day';
  }

  @override
  String get moreButton => 'مزید';

  @override
  String get morning => 'صبح';

  @override
  String get mostFrequentError => 'سب سے زیادہ عام غلطی';

  @override
  String get movies => 'فلمیں';

  @override
  String get multilingualChat => 'کثیر لسانی گفتگو';

  @override
  String get music => 'موسیقی';

  @override
  String get myGenderSection => 'میرا جنس (اختیاری)';

  @override
  String get networkErrorOccurred => 'ایک نیٹ ورک کی خرابی ہوئی۔';

  @override
  String get newMessage => 'نیا پیغام';

  @override
  String newMessageCount(int count) {
    return '$count نئے پیغامات';
  }

  @override
  String get newMessageNotification => 'مجھے نئے پیغامات کی اطلاع دیں';

  @override
  String get newMessages => 'نئے پیغامات';

  @override
  String get newYear => 'نیا سال';

  @override
  String get next => 'اگلا';

  @override
  String get niceToMeetYou => 'آپ سے مل کر خوشی ہوئی!';

  @override
  String get nickname => 'عرفیت';

  @override
  String get nicknameAlreadyUsed => 'یہ عرفیت پہلے ہی استعمال میں ہے';

  @override
  String get nicknameHelperText => '3-10 حروف';

  @override
  String get nicknameHint => '3-10 حروف';

  @override
  String get nicknameInUse => 'یہ عرفیت پہلے ہی استعمال میں ہے';

  @override
  String get nicknameLabel => 'عرفیت';

  @override
  String get nicknameLengthError => 'عرفیت 3-10 حروف پر مشتمل ہونی چاہیے';

  @override
  String get nicknamePlaceholder => 'اپنی عرفیت درج کریں';

  @override
  String get nicknameRequired => 'نک نیم *';

  @override
  String get night => 'رات';

  @override
  String get no => 'نہیں';

  @override
  String get noBlockedAIs => 'کوئی بلاک شدہ AI نہیں';

  @override
  String get noChatsYet => 'ابھی تک کوئی چیٹ نہیں';

  @override
  String get noConversationYet => 'ابھی تک کوئی گفتگو نہیں';

  @override
  String get noErrorReports => 'کوئی غلطی کی رپورٹ نہیں۔';

  @override
  String get noImageAvailable => 'کوئی تصویر دستیاب نہیں';

  @override
  String get noMatchedPersonas => 'ابھی تک کوئی ملتے جلتے کردار نہیں';

  @override
  String get noMatchedSonas => 'ابھی تک کوئی ملتا جلتا سونا نہیں';

  @override
  String get noPersonasAvailable =>
      'کوئی پرسناز دستیاب نہیں۔ براہ کرم دوبارہ کوشش کریں۔';

  @override
  String get noPersonasToSelect => 'کوئی پرسناز دستیاب نہیں';

  @override
  String get noQualityIssues =>
      'پچھلے ایک گھنٹے میں کوئی معیار کے مسائل نہیں ✅';

  @override
  String get noQualityLogs => 'ابھی تک کوئی معیار کے لاگ نہیں ہیں۔';

  @override
  String get noTranslatedMessages => 'ترجمہ کرنے کے لیے کوئی پیغامات نہیں ہیں';

  @override
  String get notEnoughHearts => 'دل کی تعداد کافی نہیں ہے';

  @override
  String notEnoughHeartsCount(int count) {
    return 'دل کی تعداد کافی نہیں ہے۔ (موجودہ: $count)';
  }

  @override
  String get notRegistered => 'رجسٹرڈ نہیں';

  @override
  String get notSubscribed => 'سبسکرائب نہیں کیا';

  @override
  String get notificationPermissionDesc =>
      'الرٹس بھیجنے کے لیے ہمیں اطلاع کی اجازت چاہیے۔';

  @override
  String get notificationPermissionRequired => 'اطلاع کی اجازت درکار ہے';

  @override
  String get notificationSettings => 'اطلاع کی ترتیبات';

  @override
  String get notifications => 'اطلاعات';

  @override
  String get occurrenceInfo => 'واقعے کی معلومات:';

  @override
  String get olderChats => 'پرانی';

  @override
  String get onlyOppositeGenderNote =>
      'اگر چیک نہیں کیا گیا تو صرف مخالف جنس کے کردار دکھائے جائیں گے';

  @override
  String get openSettings => 'سیٹنگز کھولیں';

  @override
  String get optional => 'اختیاری';

  @override
  String get or => 'or';

  @override
  String get originalPrice => 'اصل';

  @override
  String get originalText => 'اصل';

  @override
  String get other => 'دیگر';

  @override
  String get otherError => 'دیگر خرابی';

  @override
  String get others => 'دوسرے';

  @override
  String get ownedHearts => 'ملکیت والے دل';

  @override
  String get parentsDay => 'والدین کا دن';

  @override
  String get password => 'پاس ورڈ';

  @override
  String get passwordConfirmation => 'تصدیق کے لیے پاس ورڈ درج کریں';

  @override
  String get passwordConfirmationDesc =>
      'براہ کرم اپنے پاس ورڈ کو دوبارہ درج کریں تاکہ اکاؤنٹ حذف کیا جا سکے۔';

  @override
  String get passwordHint => '6 حروف یا اس سے زیادہ';

  @override
  String get passwordLabel => 'پاس ورڈ';

  @override
  String get passwordRequired => 'پاس ورڈ *';

  @override
  String get passwordResetEmailPrompt =>
      'براہ کرم اپنا ای میل درج کریں تاکہ پاس ورڈ ری سیٹ کیا جا سکے';

  @override
  String get passwordResetEmailSent =>
      'پاس ورڈ ری سیٹ کرنے کا ای میل بھیج دیا گیا ہے۔ براہ کرم اپنے ای میل کو چیک کریں۔';

  @override
  String get passwordText => 'پاس ورڈ';

  @override
  String get passwordTooShort => 'پاس ورڈ کم از کم 6 حروف پر مشتمل ہونا چاہیے';

  @override
  String get permissionDenied => 'اجازت مسترد';

  @override
  String permissionDeniedMessage(String permissionName) {
    return '$permissionName مسترد کی گئی۔ براہ کرم سیٹنگز سے اجازت دیں۔';
  }

  @override
  String get permissionDeniedTryLater =>
      'اجازت نہیں ملی۔ براہ کرم بعد میں دوبارہ کوشش کریں۔';

  @override
  String get permissionRequired => 'اجازت درکار ہے';

  @override
  String get personaGenderSection => 'پرسنہ کی جنس کی ترجیح';

  @override
  String get personaQualityStats => 'پرسونا کوالٹی کی شماریات';

  @override
  String get personalInfoExposure => 'ذاتی معلومات کی نمائش';

  @override
  String get personality => 'شخصیت';

  @override
  String get pets => 'پالتو جانور';

  @override
  String get photo => 'تصویر';

  @override
  String get photography => 'Photography';

  @override
  String get picnic => 'Picnic';

  @override
  String get preferenceSettings => 'Preference Settings';

  @override
  String get preferredLanguage => 'Preferred Language';

  @override
  String get preparingForSleep => 'نیند کے لئے تیاری';

  @override
  String get preparingNewMeeting => 'نئی ملاقات کی تیاری';

  @override
  String get preparingPersonaImages => 'شخصیت کی تصاویر کی تیاری';

  @override
  String get preparingPersonas => 'شخصیتوں کی تیاری';

  @override
  String get preview => 'پیش نظارہ';

  @override
  String get previous => 'پچھلا';

  @override
  String get privacy => 'رازداری کی پالیسی';

  @override
  String get privacyPolicy => 'رازداری کی پالیسی';

  @override
  String get privacyPolicyAgreement =>
      'براہ کرم رازداری کی پالیسی سے اتفاق کریں';

  @override
  String get privacySection1Content =>
      'ہم آپ کی رازداری کے تحفظ کے لیے پرعزم ہیں۔ یہ رازداری کی پالیسی وضاحت کرتی ہے کہ ہم آپ کی معلومات کو کس طرح جمع، استعمال اور محفوظ کرتے ہیں جب آپ ہماری خدمات کا استعمال کرتے ہیں۔';

  @override
  String get privacySection1Title =>
      '1. ذاتی معلومات کے جمع کرنے اور استعمال کا مقصد';

  @override
  String get privacySection2Content =>
      'ہم وہ معلومات جمع کرتے ہیں جو آپ براہ راست ہمیں فراہم کرتے ہیں، جیسے جب آپ اکاؤنٹ بناتے ہیں، اپنے پروفائل کو اپ ڈیٹ کرتے ہیں، یا ہماری خدمات کا استعمال کرتے ہیں۔';

  @override
  String get privacySection2Title => 'ہم جو معلومات جمع کرتے ہیں';

  @override
  String get privacySection3Content =>
      'ہم جمع کردہ معلومات کا استعمال اپنی خدمات فراہم کرنے، برقرار رکھنے اور بہتر بنانے کے لیے کرتے ہیں، اور آپ سے رابطہ کرنے کے لیے۔';

  @override
  String get privacySection3Title =>
      '3. ذاتی معلومات کا برقرار رکھنے اور استعمال کرنے کا دورانیہ';

  @override
  String get privacySection4Content =>
      'ہم آپ کی ذاتی معلومات کو آپ کی رضامندی کے بغیر تیسرے فریق کو فروخت، تجارت یا کسی اور طریقے سے منتقل نہیں کرتے۔';

  @override
  String get privacySection4Title => '4. تیسرے فریق کو ذاتی معلومات کی فراہمی';

  @override
  String get privacySection5Content =>
      'ہم آپ کی ذاتی معلومات کو غیر مجاز رسائی، تبدیلی، افشاء، یا تباہی سے بچانے کے لیے مناسب حفاظتی اقدامات نافذ کرتے ہیں۔';

  @override
  String get privacySection5Title =>
      '5. ذاتی معلومات کے لیے تکنیکی حفاظتی اقدامات';

  @override
  String get privacySection6Content =>
      'ہم اپنی خدمات فراہم کرنے اور قانونی ذمہ داریوں کی تعمیل کے لیے جتنی دیر تک ضروری ہو، ذاتی معلومات کو برقرار رکھتے ہیں۔';

  @override
  String get privacySection6Title => '6. صارف کے حقوق';

  @override
  String get privacySection7Content =>
      'آپ کو اپنے ذاتی معلومات تک رسائی حاصل کرنے، اسے اپ ڈیٹ کرنے، یا کسی بھی وقت اپنے اکاؤنٹ کی ترتیبات کے ذریعے حذف کرنے کا حق ہے۔';

  @override
  String get privacySection7Title => 'آپ کے حقوق';

  @override
  String get privacySection8Content =>
      'اگر آپ کو اس پرائیویسی پالیسی کے بارے میں کوئی سوالات ہیں، تو براہ کرم ہم سے support@sona.com پر رابطہ کریں۔';

  @override
  String get privacySection8Title => 'ہم سے رابطہ کریں';

  @override
  String get privacySettings => 'پرائیویسی سیٹنگز';

  @override
  String get privacySettingsInfo =>
      'انفرادی خصوصیات کو غیر فعال کرنے سے وہ خدمات دستیاب نہیں ہوں گی';

  @override
  String get privacySettingsScreen => 'پرائیویسی سیٹنگز';

  @override
  String get problemMessage => 'مسئلہ';

  @override
  String get problemOccurred => 'مسئلہ پیش آیا';

  @override
  String get profile => 'پروفائل';

  @override
  String get profileEdit => 'پروفائل ایڈٹ کریں';

  @override
  String get profileEditLoginRequiredMessage =>
      'اپنے پروفائل کو ایڈٹ کرنے کے لیے لاگ ان کرنا ضروری ہے۔';

  @override
  String get profileInfo => 'پروفائل کی معلومات';

  @override
  String get profileInfoDescription =>
      'براہ کرم اپنی پروفائل کی تصویر اور بنیادی معلومات درج کریں';

  @override
  String get profileNav => 'پروفائل';

  @override
  String get profilePhoto => 'پروفائل کی تصویر';

  @override
  String get profilePhotoAndInfo =>
      'براہ کرم پروفائل کی تصویر اور بنیادی معلومات درج کریں';

  @override
  String get profilePhotoUpdateFailed =>
      'پروفائل کی تصویر کو اپ ڈیٹ کرنے میں ناکامی';

  @override
  String get profilePhotoUpdated => 'پروفائل کی تصویر اپ ڈیٹ ہو گئی';

  @override
  String get profileSettings => 'پروفائل کی ترتیبات';

  @override
  String get profileSetup => 'پروفائل سیٹ اپ';

  @override
  String get profileUpdateFailed => 'پروفائل کو اپ ڈیٹ کرنے میں ناکامی';

  @override
  String get profileUpdated => 'پروفائل کامیابی سے اپ ڈیٹ ہو گئی';

  @override
  String get purchaseAndRefundPolicy => 'خریداری اور واپسی کی پالیسی';

  @override
  String get purchaseButton => 'خریدیں';

  @override
  String get purchaseConfirm => 'خریداری کی تصدیق';

  @override
  String purchaseConfirmContent(String product, String price) {
    return '$price میں $product خریدیں؟';
  }

  @override
  String purchaseConfirmMessage(
      String title, String price, String description) {
    return '$price میں $title کی خریداری کی تصدیق کریں؟ $description';
  }

  @override
  String get purchaseFailed => 'خریداری ناکام ہو گئی';

  @override
  String get purchaseHeartsOnly => 'دل خریدیں';

  @override
  String get purchaseMoreHearts => 'گفتگو جاری رکھنے کے لیے دل خریدیں';

  @override
  String get purchasePending => 'خریداری زیر غور ہے...';

  @override
  String get purchasePolicy => 'خریداری کی پالیسی';

  @override
  String get purchaseSection1Content =>
      'ہم مختلف ادائیگی کے طریقے قبول کرتے ہیں جن میں کریڈٹ کارڈز اور ڈیجیٹل والٹس شامل ہیں۔';

  @override
  String get purchaseSection1Title => 'ادائیگی کے طریقے';

  @override
  String get purchaseSection2Content =>
      'اگر آپ نے خریدی گئی اشیاء کا استعمال نہیں کیا ہے تو خریداری کے 14 دنوں کے اندر رقم کی واپسی دستیاب ہے۔';

  @override
  String get purchaseSection2Title => 'رقم کی واپسی کی پالیسی';

  @override
  String get purchaseSection3Content =>
      'آپ کسی بھی وقت اپنے اکاؤنٹ کی ترتیبات کے ذریعے اپنی رکنیت منسوخ کر سکتے ہیں۔';

  @override
  String get purchaseSection3Title => 'منسوخی';

  @override
  String get purchaseSection4Content =>
      'خریداری کرکے، آپ ہماری استعمال کی شرائط اور سروس کے معاہدے سے اتفاق کرتے ہیں۔';

  @override
  String get purchaseSection4Title => 'استعمال کی شرائط';

  @override
  String get purchaseSection5Content =>
      'خریداری سے متعلق مسائل کے لیے، براہ کرم ہماری سپورٹ ٹیم سے رابطہ کریں۔';

  @override
  String get purchaseSection5Title => 'سپورٹ سے رابطہ کریں';

  @override
  String get purchaseSection6Content =>
      'تمام خریداریوں کا تعلق ہماری معیاری شرائط و ضوابط سے ہے۔';

  @override
  String get purchaseSection6Title => '6. انکوائریاں';

  @override
  String get pushNotifications => 'پش اطلاعات';

  @override
  String get reading => 'پڑھنا';

  @override
  String get realtimeQualityLog => 'حقیقی وقت کا معیار لاگ';

  @override
  String get recentConversation => 'حالیہ گفتگو:';

  @override
  String get recentLoginRequired =>
      'براہ کرم سیکیورٹی کے لیے دوبارہ لاگ ان کریں';

  @override
  String get referrerEmail => 'ریفرر ای میل';

  @override
  String get referrerEmailHelper =>
      'اختیاری: جس نے آپ کو ریفر کیا اس کی ای میل';

  @override
  String get referrerEmailLabel => 'ریفرر ای میل (اختیاری)';

  @override
  String get refresh => 'تازہ کریں';

  @override
  String refreshComplete(int count) {
    return 'ریفریش مکمل! $count ملتے جلتے کردار';
  }

  @override
  String get refreshFailed => 'ریفریش ناکام';

  @override
  String get refreshingChatList => 'چیٹ کی فہرست کو تازہ کر رہے ہیں...';

  @override
  String get relatedFAQ => 'متعلقہ سوالات';

  @override
  String get report => 'رپورٹ کریں';

  @override
  String get reportAI => 'رپورٹ کریں';

  @override
  String get reportAIDescription =>
      'اگر AI نے آپ کو غیر آرام دہ محسوس کرایا، تو براہ کرم مسئلے کی وضاحت کریں۔';

  @override
  String get reportAITitle => 'AI گفتگو کی رپورٹ';

  @override
  String get reportAndBlock => 'رپورٹ کریں اور بلاک کریں';

  @override
  String get reportAndBlockDescription =>
      'آپ اس AI کے نامناسب رویے کی رپورٹ اور بلاک کر سکتے ہیں';

  @override
  String get reportChatError => 'چیٹ کی غلطی کی رپورٹ کریں';

  @override
  String reportError(String error) {
    return 'رپورٹ کرتے وقت خرابی ہوئی: $error';
  }

  @override
  String get reportFailed => 'رپورٹ ناکام ہوگئی';

  @override
  String get reportSubmitted =>
      'رپورٹ جمع کر دی گئی ہے۔ ہم اس کا جائزہ لیں گے اور کارروائی کریں گے۔';

  @override
  String get reportSubmittedSuccess => 'آپ کی رپورٹ جمع کر دی گئی ہے۔ شکریہ!';

  @override
  String get requestLimit => 'درخواست کی حد';

  @override
  String get required => '[ضروری]';

  @override
  String get requiredTermsAgreement => 'براہ کرم شرائط سے اتفاق کریں';

  @override
  String get restartConversation => 'گفتگو دوبارہ شروع کریں';

  @override
  String restartConversationQuestion(String name) {
    return 'کیا آپ $name کے ساتھ گفتگو دوبارہ شروع کرنا چاہیں گے؟';
  }

  @override
  String restartConversationWithName(String name) {
    return '$name کے ساتھ گفتگو دوبارہ شروع کی جا رہی ہے!';
  }

  @override
  String get retry => 'دوبارہ کوشش کریں';

  @override
  String get retryButton => 'دوبارہ کوشش کریں';

  @override
  String get sad => 'اداس';

  @override
  String get saturday => 'ہفتہ';

  @override
  String get save => 'محفوظ کریں';

  @override
  String get search => 'تلاش کریں';

  @override
  String get searchFAQ => 'FAQ تلاش کریں...';

  @override
  String get searchResults => 'تلاش کے نتائج';

  @override
  String get selectEmotion => 'جذبات منتخب کریں';

  @override
  String get selectErrorType => 'غلطی کی قسم منتخب کریں';

  @override
  String get selectFeeling => 'احساس منتخب کریں';

  @override
  String get selectGender => 'جنس منتخب کریں';

  @override
  String get selectInterests => 'براہ کرم اپنے مفادات منتخب کریں (کم از کم 1)';

  @override
  String get selectLanguage => 'زبان منتخب کریں';

  @override
  String get selectPersona => 'ایک شخصیت منتخب کریں';

  @override
  String get selectPersonaPlease => 'براہ کرم ایک شخصیت منتخب کریں۔';

  @override
  String get selectPreferredMbti =>
      'اگر آپ مخصوص MBTI اقسام کے ساتھ شخصیات کو ترجیح دیتے ہیں، تو براہ کرم منتخب کریں';

  @override
  String get selectProblematicMessage => 'مسئلہ دار پیغام منتخب کریں (اختیاری)';

  @override
  String get selectReportReason => 'رپورٹ کرنے کی وجہ منتخب کریں';

  @override
  String get selectTheme => 'تھیم منتخب کریں';

  @override
  String get selectTranslationError =>
      'براہ کرم ایک پیغام منتخب کریں جس میں ترجمے کی غلطی ہو';

  @override
  String get selectUsagePurpose =>
      'براہ کرم SONA استعمال کرنے کا مقصد منتخب کریں';

  @override
  String get selfIntroduction => 'تعارف (اختیاری)';

  @override
  String get selfIntroductionHint => 'اپنے بارے میں ایک مختصر تعارف لکھیں';

  @override
  String get send => 'بھیجیں';

  @override
  String get sendChatError => 'چیٹ بھیجنے میں خرابی';

  @override
  String get sendFirstMessage => 'اپنا پہلا پیغام بھیجیں';

  @override
  String get sendReport => 'رپورٹ بھیجیں';

  @override
  String get sendingEmail => 'ای میل بھیجی جا رہی ہے...';

  @override
  String get seoul => 'سئول';

  @override
  String get serverErrorDashboard => 'سرور کی خرابی';

  @override
  String get serviceTermsAgreement => 'براہ کرم سروس کی شرائط سے اتفاق کریں';

  @override
  String get sessionExpired => 'سیشن ختم ہو گیا';

  @override
  String get setAppInterfaceLanguage => 'ایپ کے انٹرفیس کی زبان مقرر کریں';

  @override
  String get setNow => 'ابھی مقرر کریں';

  @override
  String get settings => 'ترتیبات';

  @override
  String get sexualContent => 'جنسی مواد';

  @override
  String get showAllGenderPersonas => 'تمام جنسوں کے کردار دکھائیں';

  @override
  String get showAllGendersOption => 'تمام جنسیں دکھائیں';

  @override
  String get showOppositeGenderOnly =>
      'اگر غیر منتخب کیا جائے تو صرف مخالف جنس کے کردار دکھائے جائیں گے';

  @override
  String get showOriginalText => 'اصل دکھائیں';

  @override
  String get signUp => 'سائن اپ کریں';

  @override
  String get signUpFromGuest =>
      'تمام خصوصیات تک رسائی کے لیے ابھی سائن اپ کریں!';

  @override
  String get signup => 'سائن اپ کریں';

  @override
  String get signupComplete => 'سائن اپ مکمل';

  @override
  String get signupTab => 'سائن اپ';

  @override
  String get simpleInfoRequired =>
      'AI کرداروں کے ساتھ ملانے کے لیے سادہ معلومات کی ضرورت ہے';

  @override
  String get skip => 'چھوڑیں';

  @override
  String get sonaFriend => 'SONA دوست';

  @override
  String get sonaPrivacyPolicy => 'SONA کی رازداری کی پالیسی';

  @override
  String get sonaPurchasePolicy => 'SONA کی خریداری کی پالیسی';

  @override
  String get sonaTermsOfService => 'SONA کی خدمات کی شرائط';

  @override
  String get sonaUsagePurpose => 'براہ کرم SONA کے استعمال کا مقصد منتخب کریں';

  @override
  String get sorryNotHelpful => 'معاف کیجیے، یہ مددگار نہیں تھا';

  @override
  String get sort => 'ترتیب دیں';

  @override
  String get soundSettings => 'آواز کی ترتیبات';

  @override
  String get spamAdvertising => 'اسپام/اشتہارات';

  @override
  String get spanish => 'ہسپانوی';

  @override
  String get specialRelationshipDesc =>
      'ایک دوسرے کو سمجھیں اور گہرے رشتے بنائیں';

  @override
  String get sports => 'کھیل';

  @override
  String get spring => 'بہار';

  @override
  String get startChat => 'چیٹ شروع کریں';

  @override
  String get startChatButton => 'چیٹ شروع کریں';

  @override
  String get startConversation => 'گفتگو شروع کریں';

  @override
  String get startConversationLikeAFriend =>
      'سونا کے ساتھ دوست کی طرح گفتگو شروع کریں';

  @override
  String get startConversationStep =>
      '2. گفتگو شروع کریں: ملے جلے کرداروں کے ساتھ آزادانہ گفتگو کریں۔';

  @override
  String get startConversationWithSona =>
      'سونا کے ساتھ دوست کی طرح چیٹ کرنا شروع کریں!';

  @override
  String get startWithEmail => 'ای میل کے ساتھ شروع کریں';

  @override
  String get startWithGoogle => 'گوگل کے ساتھ شروع کریں';

  @override
  String get startingApp => 'ایپ شروع ہو رہی ہے';

  @override
  String get storageManagement => 'اسٹوریج کا انتظام';

  @override
  String get store => 'اسٹور';

  @override
  String get storeConnectionError => 'اسٹور سے جڑنے میں ناکامی';

  @override
  String get storeLoginRequiredMessage =>
      'اسٹور استعمال کرنے کے لیے لاگ ان کرنا ضروری ہے۔';

  @override
  String get storeNotAvailable => 'اسٹور دستیاب نہیں ہے';

  @override
  String get storyEvent => 'کہانی کا واقعہ';

  @override
  String get stressed => 'دباؤ میں';

  @override
  String get submitReport => 'رپورٹ جمع کروائیں';

  @override
  String get subscriptionStatus => 'سبسکرپشن کی حیثیت';

  @override
  String get subtleVibrationOnTouch => 'چھونے پر ہلکی کمپن';

  @override
  String get summer => 'گرمیوں';

  @override
  String get sunday => 'اتوار';

  @override
  String get swipeAnyDirection => 'کسی بھی سمت میں سوائپ کریں';

  @override
  String get swipeDownToClose => 'نیچے سوائپ کریں بند کرنے کے لیے';

  @override
  String get systemTheme => 'نظام کے مطابق';

  @override
  String get systemThemeDesc =>
      'خود بخود ڈیوائس کے ڈارک موڈ کی ترتیبات کے مطابق تبدیل ہوتا ہے';

  @override
  String get tapBottomForDetails =>
      'تفصیلات دیکھنے کے لیے نیچے کے علاقے پر ٹیپ کریں';

  @override
  String get tapForDetails => 'تفصیلات کے لیے نیچے کے علاقے پر ٹیپ کریں';

  @override
  String get tapToSwipePhotos => 'تصاویر کو سوائپ کرنے کے لیے ٹیپ کریں';

  @override
  String get teachersDay => 'اساتذہ کا دن';

  @override
  String get technicalError => 'تکنیکی خرابی';

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
  String get termsOfService => 'سروس کی شرائط';

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
      'اگر ان شرائط کا کوئی بھی provision نافذ کرنے کے قابل نہ پایا جائے تو باقی provisions مکمل قوت اور اثر کے ساتھ جاری رہیں گی۔';

  @override
  String get termsSection12Title => 'آرٹیکل 12 (ڈیٹا جمع کرنا اور استعمال)';

  @override
  String get termsSection1Content =>
      'یہ شرائط و ضوابط SONA (جسے بعد میں \"کمپنی\" کہا جائے گا) اور صارفین کے درمیان AI persona گفتگو میچنگ سروس (جسے بعد میں \"سروس\" کہا جائے گا) کے استعمال کے بارے میں حقوق، ذمہ داریاں اور فرائض کی وضاحت کرنے کے لیے ہیں۔';

  @override
  String get termsSection1Title => 'آرٹیکل 1 (مقصد)';

  @override
  String get termsSection2Content =>
      'ہماری سروس کا استعمال کرتے ہوئے، آپ ان خدمات کی شرائط اور ہماری پرائیویسی پالیسی کے پابند ہونے پر رضامند ہیں۔';

  @override
  String get termsSection2Title => 'آرٹیکل 2 (تعریفیں)';

  @override
  String get termsSection3Content =>
      'آپ کو ہماری سروس استعمال کرنے کے لیے کم از کم 13 سال کا ہونا ضروری ہے۔';

  @override
  String get termsSection3Title => 'آرٹیکل 3 (شرائط کا اثر اور ترمیم)';

  @override
  String get termsSection4Content =>
      'آپ اپنے اکاؤنٹ اور پاس ورڈ کی رازداری کو برقرار رکھنے کے ذمہ دار ہیں۔';

  @override
  String get termsSection4Title => 'آرٹیکل 4 (سروس کی فراہمی)';

  @override
  String get termsSection5Content =>
      'آپ اس بات پر متفق ہیں کہ ہماری سروس کو کسی غیر قانونی یا غیر مجاز مقصد کے لیے استعمال نہیں کریں گے۔';

  @override
  String get termsSection5Title => 'آرٹیکل 5 (رکنیت کی رجسٹریشن)';

  @override
  String get termsSection6Content =>
      'ہم ان شرائط کی خلاف ورزی پر آپ کا اکاؤنٹ ختم کرنے یا معطل کرنے کا حق محفوظ رکھتے ہیں۔';

  @override
  String get termsSection6Title => 'آرٹیکل 6 (صارف کی ذمہ داریاں)';

  @override
  String get termsSection7Content =>
      'اگر صارفین ان شرائط کی ذمہ داریوں کی خلاف ورزی کرتے ہیں یا معمول کی سروس کی کارروائیوں میں مداخلت کرتے ہیں تو کمپنی مرحلہ وار انتباہات، عارضی معطلی، یا مستقل معطلی کے ذریعے سروس کے استعمال کو محدود کر سکتی ہے۔';

  @override
  String get termsSection7Title => 'آرٹیکل 7 (سروس کے استعمال کی پابندیاں)';

  @override
  String get termsSection8Content =>
      'ہم آپ کی خدمت کے استعمال سے پیدا ہونے والے کسی بھی غیر براہ راست، حادثاتی، یا نتیجہ خیز نقصانات کے لئے ذمہ دار نہیں ہیں۔';

  @override
  String get termsSection8Title => 'آرٹیکل 8 (سروس میں خلل)';

  @override
  String get termsSection9Content =>
      'ہماری خدمت پر دستیاب تمام مواد اور مواد دانشورانہ املاک کے حقوق سے محفوظ ہیں۔';

  @override
  String get termsSection9Title => 'آرٹیکل 9 (انکار)';

  @override
  String get termsSupplementary => 'اضافی شرائط';

  @override
  String get thai => 'تھائی';

  @override
  String get thanksFeedback => 'آپ کی رائے کا شکریہ!';

  @override
  String get theme => 'تھیم';

  @override
  String get themeDescription =>
      'آپ ایپ کی ظاہری شکل کو اپنی پسند کے مطابق اپنی مرضی سے ترتیب دے سکتے ہیں۔';

  @override
  String get themeSettings => 'تھیم کی ترتیبات';

  @override
  String get thursday => 'جمعرات';

  @override
  String get timeout => 'ٹائم آؤٹ';

  @override
  String get tired => 'تھکا ہوا';

  @override
  String get today => 'آج';

  @override
  String get todayChats => 'آج';

  @override
  String get todayText => 'آج';

  @override
  String get tomorrowText => 'کل';

  @override
  String get totalConsultSessions => 'کل مشاورتی سیشن';

  @override
  String get totalErrorCount => 'کل غلطیوں کی تعداد';

  @override
  String get totalLikes => 'کل پسندیدگیاں';

  @override
  String totalOccurrences(Object count) {
    return 'کل $count بار';
  }

  @override
  String get totalResponses => 'کل جوابات';

  @override
  String get translatedFrom => 'ترجمہ شدہ';

  @override
  String get translatedText => 'ترجمہ';

  @override
  String get translationError => 'ترجمے کی غلطی';

  @override
  String get translationErrorDescription =>
      'براہ کرم غلط ترجمے یا عجیب و غریب اظہار کی اطلاع دیں';

  @override
  String get translationErrorReported =>
      'ترجمے کی غلطی کی اطلاع دی گئی۔ شکریہ!';

  @override
  String get translationNote => '※ AI ترجمہ مکمل درست نہیں ہو سکتا';

  @override
  String get translationQuality => 'ترجمے کا معیار';

  @override
  String get translationSettings => 'ترجمے کی ترتیبات';

  @override
  String get travel => 'سفر';

  @override
  String get tuesday => 'منگل';

  @override
  String get tutorialAccount => 'ٹیوٹوریل اکاؤنٹ';

  @override
  String get tutorialWelcomeDescription =>
      'AI شخصیات کے ساتھ خاص تعلقات بنائیں۔';

  @override
  String get tutorialWelcomeTitle => 'SONA میں خوش آمدید!';

  @override
  String get typeMessage => 'ایک پیغام ٹائپ کریں...';

  @override
  String get unblock => 'ان بلاک کریں';

  @override
  String get unblockFailed => 'ان بلاک کرنے میں ناکامی';

  @override
  String unblockPersonaConfirm(String name) {
    return '$name کو ان بلاک کریں؟';
  }

  @override
  String get unblockedSuccessfully => 'کامیابی سے ان بلاک کر دیا گیا';

  @override
  String get unexpectedLoginError => 'لاگ ان کے دوران ایک غیر متوقع خرابی ہوئی';

  @override
  String get unknown => 'نامعلوم';

  @override
  String get unknownError => 'نامعلوم خرابی';

  @override
  String get unlimitedMessages => 'لامحدود';

  @override
  String get unsendMessage => 'پیغام واپس لیں';

  @override
  String get usagePurpose => 'استعمال کا مقصد';

  @override
  String get useOneHeart => '1 دل استعمال کریں';

  @override
  String get useSystemLanguage => 'سسٹم کی زبان استعمال کریں';

  @override
  String get user => 'صارف:';

  @override
  String get userMessage => 'صارف کا پیغام:';

  @override
  String get userNotFound => 'صارف نہیں ملا';

  @override
  String get valentinesDay => 'ویلنٹائن کا دن';

  @override
  String get verifyingAuth => 'تصدیق کی جا رہی ہے';

  @override
  String get version => 'ورژن';

  @override
  String get vietnamese => 'ویتنامی';

  @override
  String get violentContent => 'تشدد پر مبنی مواد';

  @override
  String get voiceMessage => '🎤 صوتی پیغام';

  @override
  String waitingForChat(String name) {
    return '$name بات چیت کے لیے انتظار کر رہا ہے۔';
  }

  @override
  String get walk => 'چلنا';

  @override
  String get wasHelpful => 'کیا یہ مددگار تھا؟';

  @override
  String get weatherClear => 'صاف';

  @override
  String get weatherCloudy => 'ابر آلود';

  @override
  String get weatherContext => 'موسم کا سیاق و سباق';

  @override
  String get weatherContextDesc => 'موسم کی بنیاد پر گفتگو کا سیاق فراہم کریں';

  @override
  String get weatherDrizzle => 'ہلکی بارش';

  @override
  String get weatherFog => 'دھند';

  @override
  String get weatherMist => 'کہر';

  @override
  String get weatherRain => 'بارش';

  @override
  String get weatherRainy => 'بارش';

  @override
  String get weatherSnow => 'برف';

  @override
  String get weatherSnowy => 'برفیلا';

  @override
  String get weatherThunderstorm => 'طوفانی بارش';

  @override
  String get wednesday => 'بدھ';

  @override
  String get weekdays => 'اتوار، پیر، منگل، بدھ، جمعرات، جمعہ، ہفتہ';

  @override
  String get welcomeMessage => 'خوش آمدید💕';

  @override
  String get whatTopicsToTalk => 'آپ کس موضوع پر بات کرنا چاہیں گے؟ (اختیاری)';

  @override
  String get whiteDay => 'سفید دن';

  @override
  String get winter => 'سردی';

  @override
  String get wrongTranslation => 'غلط ترجمہ';

  @override
  String get year => 'سال';

  @override
  String get yearEnd => 'سال کا اختتام';

  @override
  String get yes => 'ہاں';

  @override
  String get yesterday => 'کل';

  @override
  String get yesterdayChats => 'کل';

  @override
  String get you => 'آپ';

  @override
  String get loadingPersonaData => 'پرسونا ڈیٹا لوڈ ہو رہا ہے';

  @override
  String get checkingMatchedPersonas => 'میچ شدہ پرسونا چیک کر رہے ہیں';

  @override
  String get preparingImages => 'تصاویر تیار کر رہے ہیں';

  @override
  String get finalPreparation => 'آخری تیاری';

  @override
  String get editProfileSubtitle =>
      'جنس، تاریخ پیدائش اور تعارف میں ترمیم کریں';

  @override
  String get systemThemeName => 'سسٹم';

  @override
  String get lightThemeName => 'لائٹ';

  @override
  String get darkThemeName => 'ڈارک';
}
