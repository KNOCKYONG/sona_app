// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get about => 'حول';

  @override
  String get accountAndProfile => 'معلومات الحساب والملف الشخصي';

  @override
  String get accountDeletedSuccess => 'تم حذف الحساب بنجاح';

  @override
  String get accountDeletionContent => 'هل أنت متأكد أنك تريد حذف حسابك؟';

  @override
  String get accountDeletionError => 'حدث خطأ أثناء حذف الحساب.';

  @override
  String get accountDeletionInfo => 'معلومات حذف الحساب';

  @override
  String get accountDeletionTitle => 'حذف الحساب';

  @override
  String get accountDeletionWarning1 => 'تحذير: لا يمكن التراجع عن هذا الإجراء';

  @override
  String get accountDeletionWarning2 => 'سيتم حذف جميع بياناتك بشكل دائم';

  @override
  String get accountDeletionWarning3 => 'ستفقد الوصول إلى جميع المحادثات';

  @override
  String get accountDeletionWarning4 => 'يشمل ذلك جميع المحتويات المشتراة';

  @override
  String get accountManagement => 'إدارة الحساب';

  @override
  String get adaptiveConversationDesc =>
      'يتكيف أسلوب المحادثة ليتناسب مع أسلوبك';

  @override
  String get afternoon => 'بعد الظهر';

  @override
  String get afternoonFatigue => 'تعب بعد الظهر';

  @override
  String get ageConfirmation =>
      'أنا في الرابعة عشر من عمري أو أكبر وقد أكدت ما سبق.';

  @override
  String ageRange(int min, int max) {
    return '$min-$max سنة';
  }

  @override
  String get ageUnit => 'سنة';

  @override
  String get agreeToTerms => 'أوافق على الشروط';

  @override
  String get aiDatingQuestion => 'حياة يومية خاصة مع الذكاء الاصطناعي';

  @override
  String get aiPersonaPreferenceDescription =>
      'يرجى تحديد تفضيلاتك لمطابقة شخصية الذكاء الاصطناعي';

  @override
  String get all => 'الكل';

  @override
  String get allAgree => 'أوافق على الكل';

  @override
  String get allFeaturesRequired => '※ جميع الميزات مطلوبة لتقديم الخدمة';

  @override
  String get allPersonas => 'جميع الشخصيات';

  @override
  String get allPersonasMatched =>
      'تم مطابقة جميع الشخصيات! ابدأ الدردشة معهم.';

  @override
  String get allowPermission => 'متابعة';

  @override
  String alreadyChattingWith(String name) {
    return 'أنت بالفعل تتحدث مع $name!';
  }

  @override
  String get alsoBlockThisAI => 'قم أيضًا بحظر هذه الذكاء الاصطناعي';

  @override
  String get angry => 'غاضب';

  @override
  String get anonymousLogin => 'تسجيل دخول مجهول';

  @override
  String get anxious => 'قلق';

  @override
  String get apiKeyError => 'خطأ في مفتاح API';

  @override
  String get appName => 'SONA';

  @override
  String get appTagline => 'رفقاء الذكاء الاصطناعي الخاصين بك';

  @override
  String get appleLoginCanceled =>
      'تم إلغاء تسجيل الدخول عبر Apple. يرجى المحاولة مرة أخرى.';

  @override
  String get appleLoginError => 'حدث خطأ أثناء تسجيل الدخول عبر Apple.';

  @override
  String get art => 'فن';

  @override
  String get authError => 'خطأ في المصادقة';

  @override
  String get autoTranslate => 'الترجمة التلقائية';

  @override
  String get autumn => 'الخريف';

  @override
  String get averageQuality => 'جودة متوسطة';

  @override
  String get averageQualityScore => 'درجة الجودة المتوسطة';

  @override
  String get awkwardExpression => 'تعبير محرج';

  @override
  String get backButton => 'العودة';

  @override
  String get basicInfo => 'المعلومات الأساسية';

  @override
  String get basicInfoDescription =>
      'يرجى إدخال المعلومات الأساسية لإنشاء حساب';

  @override
  String get birthDate => 'تاريخ الميلاد';

  @override
  String get birthDateOptional => 'تاريخ الميلاد (اختياري)';

  @override
  String get birthDateRequired => 'تاريخ الميلاد *';

  @override
  String get blockConfirm => 'هل تريد حظر هذا الذكاء الاصطناعي؟';

  @override
  String get blockReason => 'سبب الحظر';

  @override
  String get blockThisAI => 'حظر هذه الذكاء الاصطناعي';

  @override
  String blockedAICount(int count) {
    return '$count ذكاءات اصطناعية محظورة';
  }

  @override
  String get blockedAIs => 'ذكاءات اصطناعية محظورة';

  @override
  String get blockedAt => 'محظور في';

  @override
  String get blockedSuccessfully => 'تم الحظر بنجاح';

  @override
  String get breakfast => 'الإفطار';

  @override
  String get byErrorType => 'حسب نوع الخطأ';

  @override
  String get byPersona => 'حسب الشخصية';

  @override
  String cacheDeleteError(String error) {
    return 'خطأ في حذف الذاكرة المؤقتة: $error';
  }

  @override
  String get cacheDeleted => 'تم حذف ذاكرة الصور المؤقتة';

  @override
  String get cafeTerrace => 'شرفة المقهى';

  @override
  String get calm => 'هدوء';

  @override
  String get cameraPermission => 'إذن الكاميرا';

  @override
  String get cameraPermissionDesc => 'نحتاج إلى إذن الكاميرا لالتقاط الصور.';

  @override
  String get canChangeInSettings => 'يمكنك تغيير هذا لاحقًا في الإعدادات';

  @override
  String get canMeetPreviousPersonas =>
      'يمكنك مقابلة الشخصيات التي قمت بالسحب عليها من قبل!';

  @override
  String get cancel => 'إلغاء';

  @override
  String get changeProfilePhoto => 'تغيير صورة الملف الشخصي';

  @override
  String get chat => 'دردشة';

  @override
  String get chatEndedMessage => 'انتهت الدردشة';

  @override
  String get chatErrorDashboard => 'لوحة معلومات خطأ الدردشة';

  @override
  String get chatErrorSentSuccessfully => 'تم إرسال خطأ الدردشة بنجاح.';

  @override
  String get chatListTab => 'علامة تبويب قائمة الدردشات';

  @override
  String get chats => 'الدردشات';

  @override
  String chattingWithPersonas(int count) {
    return 'الدردشة مع $count شخصية';
  }

  @override
  String get checkInternetConnection =>
      'يرجى التحقق من اتصال الإنترنت الخاص بك';

  @override
  String get checkingUserInfo => 'جاري التحقق من معلومات المستخدم';

  @override
  String get childrensDay => 'يوم الأطفال';

  @override
  String get chinese => 'الصينية';

  @override
  String get chooseOption => 'يرجى الاختيار:';

  @override
  String get christmas => 'عيد الميلاد';

  @override
  String get close => 'إغلاق';

  @override
  String get complete => 'تم';

  @override
  String get completeSignup => 'إكمال التسجيل';

  @override
  String get confirm => 'تأكيد';

  @override
  String get connectingToServer => 'جاري الاتصال بالخادم';

  @override
  String get consultQualityMonitoring => 'استشارة مراقبة الجودة';

  @override
  String get continueAsGuest => 'المتابعة كزائر';

  @override
  String get continueButton => 'متابعة';

  @override
  String get continueWithApple => 'تابع مع Apple';

  @override
  String get continueWithGoogle => 'تابع مع Google';

  @override
  String get conversationContinuity => 'استمرارية المحادثة';

  @override
  String get conversationContinuityDesc =>
      'تذكر المحادثات السابقة وتواصل المواضيع';

  @override
  String conversationWith(String name) {
    return '$name';
  }

  @override
  String get convertToMember => 'التسجيل';

  @override
  String get cooking => 'الطهي';

  @override
  String get copyMessage => 'نسخ الرسالة';

  @override
  String get copyrightInfringement => 'انتهاك حقوق الطبع والنشر';

  @override
  String get creatingAccount => 'جاري إنشاء الحساب';

  @override
  String get crisisDetected => 'تم اكتشاف أزمة';

  @override
  String get culturalIssue => 'قضية ثقافية';

  @override
  String get current => 'الحالي';

  @override
  String get currentCacheSize => 'حجم الذاكرة المؤقتة الحالي';

  @override
  String get currentLanguage => 'اللغة الحالية';

  @override
  String get cycling => 'ركوب الدراجات';

  @override
  String get dailyCare => 'العناية اليومية';

  @override
  String get dailyCareDesc => 'رسائل العناية اليومية للوجبات، النوم، الصحة';

  @override
  String get dailyChat => 'الدردشة اليومية';

  @override
  String get dailyCheck => 'الفحص اليومي';

  @override
  String get dailyConversation => 'المحادثة اليومية';

  @override
  String get dailyLimitDescription => 'لقد وصلت إلى حد الرسائل اليومية';

  @override
  String get dailyLimitTitle => 'تم الوصول إلى الحد اليومي';

  @override
  String get darkMode => 'الوضع الداكن';

  @override
  String get darkTheme => 'الوضع الداكن';

  @override
  String get darkThemeDesc => 'استخدم الوضع الداكن';

  @override
  String get dataCollection => 'إعدادات جمع البيانات';

  @override
  String get datingAdvice => 'نصائح المواعدة';

  @override
  String get datingDescription =>
      'أريد أن أشارك أفكاراً عميقة وأجري محادثات صادقة';

  @override
  String get dawn => 'الفجر';

  @override
  String get day => 'يوم';

  @override
  String get dayAfterTomorrow => 'بعد غد';

  @override
  String daysAgo(int count, String formatted) {
    return '$count أيام مضت';
  }

  @override
  String daysRemaining(int days) {
    return '$days يوم متبقي';
  }

  @override
  String get deepTalk => 'حديث عميق';

  @override
  String get delete => 'حذف';

  @override
  String get deleteAccount => 'حذف الحساب';

  @override
  String get deleteAccountConfirm =>
      'هل أنت متأكد أنك تريد حذف حسابك؟ لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get deleteAccountWarning => 'هل أنت متأكد أنك تريد حذف حسابك؟';

  @override
  String get deleteCache => 'حذف الذاكرة المؤقتة';

  @override
  String get deletingAccount => 'جارٍ حذف الحساب...';

  @override
  String get depressed => 'مكتئب';

  @override
  String get describeError => 'ما هي المشكلة؟';

  @override
  String get detailedReason => 'سبب مفصل';

  @override
  String get developRelationshipStep =>
      '3. تطوير العلاقة: بناء الألفة من خلال المحادثات وتطوير علاقات خاصة.';

  @override
  String get dinner => 'عشاء';

  @override
  String get discardGuestData => 'ابدأ من جديد';

  @override
  String get discount20 => 'خصم 20%';

  @override
  String get discount30 => 'خصم 30%';

  @override
  String get discountAmount => 'احفظ';

  @override
  String discountAmountValue(String amount) {
    return 'احفظ ₩$amount';
  }

  @override
  String get done => 'تم';

  @override
  String get downloadingPersonaImages => 'تحميل صور الشخصية الجديدة';

  @override
  String get edit => 'تعديل';

  @override
  String get editInfo => 'تعديل المعلومات';

  @override
  String get editProfile => 'تعديل الملف الشخصي';

  @override
  String get effectSound => 'مؤثرات صوتية';

  @override
  String get effectSoundDescription => 'تشغيل المؤثرات الصوتية';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get emailHint => 'example@email.com';

  @override
  String get emailLabel => 'البريد الإلكتروني';

  @override
  String get emailRequired => 'البريد الإلكتروني *';

  @override
  String get emotionAnalysis => 'تحليل المشاعر';

  @override
  String get emotionAnalysisDesc => 'تحليل المشاعر للحصول على ردود فعل تعاطفية';

  @override
  String get emotionAngry => 'غاضب';

  @override
  String get emotionBasedEncounters => 'لقاء شخصيات بناءً على مشاعرك';

  @override
  String get emotionCool => 'رائع';

  @override
  String get emotionHappy => 'سعيد';

  @override
  String get emotionLove => 'حب';

  @override
  String get emotionSad => 'حزين';

  @override
  String get emotionThinking => 'تفكير';

  @override
  String get emotionalSupportDesc => 'شارك مخاوفك واحصل على راحة دافئة';

  @override
  String get endChat => 'إنهاء الدردشة';

  @override
  String get endTutorial => 'إنهاء البرنامج التعليمي';

  @override
  String get endTutorialAndLogin =>
      'هل تريد إنهاء البرنامج التعليمي وتسجيل الدخول؟';

  @override
  String get endTutorialMessage =>
      'هل تريد إنهاء البرنامج التعليمي وتسجيل الدخول؟';

  @override
  String get english => 'الإنجليزية';

  @override
  String get enterBasicInfo => 'يرجى إدخال المعلومات الأساسية لإنشاء حساب';

  @override
  String get enterBasicInformation => 'يرجى إدخال المعلومات الأساسية';

  @override
  String get enterEmail => 'أدخل البريد الإلكتروني';

  @override
  String get enterNickname => 'يرجى إدخال اسم مستعار';

  @override
  String get enterPassword => 'أدخل كلمة المرور';

  @override
  String get entertainmentAndFunDesc => 'استمتع بألعاب ممتعة ومحادثات لطيفة';

  @override
  String get entertainmentDescription =>
      'أريد أن أستمتع بمحادثات ممتعة وأقضي وقتي بشكل جيد';

  @override
  String get entertainmentFun => 'الترفيه/المرح';

  @override
  String get error => 'خطأ';

  @override
  String get errorDescription => 'وصف الخطأ';

  @override
  String get errorDescriptionHint =>
      'مثل، أعطى إجابات غريبة، يكرر نفس الشيء، يعطي ردود غير مناسبة سياقياً...';

  @override
  String get errorDetails => 'تفاصيل الخطأ';

  @override
  String get errorDetailsHint => 'يرجى الشرح بالتفصيل ما هو الخطأ';

  @override
  String get errorFrequency24h => 'تكرار الأخطاء (آخر 24 ساعة)';

  @override
  String get errorMessage => 'رسالة الخطأ:';

  @override
  String get errorOccurred => 'حدث خطأ.';

  @override
  String get errorOccurredTryAgain => 'حدث خطأ. يرجى المحاولة مرة أخرى.';

  @override
  String get errorSendingFailed => 'فشل في إرسال الخطأ';

  @override
  String get errorStats => 'إحصائيات الأخطاء';

  @override
  String errorWithMessage(String error) {
    return 'حدث خطأ: $error';
  }

  @override
  String get evening => 'مساء الخير';

  @override
  String get excited => 'متحمس';

  @override
  String get exit => 'خروج';

  @override
  String get exitApp => 'إنهاء التطبيق';

  @override
  String get exitConfirmMessage => 'هل أنت متأكد أنك تريد الخروج من التطبيق؟';

  @override
  String get expertPersona => 'شخصية خبير';

  @override
  String get expertiseScore => 'درجة الخبرة';

  @override
  String get expired => 'منتهية';

  @override
  String get explainReportReason => 'يرجى توضيح سبب التقرير بالتفصيل';

  @override
  String get fashion => 'موضة';

  @override
  String get female => 'أنثى';

  @override
  String get filter => 'تصفية';

  @override
  String get firstOccurred => 'حدث لأول مرة';

  @override
  String get followDeviceLanguage => 'اتبع إعدادات لغة الجهاز';

  @override
  String get forenoon => 'صباح';

  @override
  String get forgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get frequentlyAskedQuestions => 'الأسئلة الشائعة';

  @override
  String get friday => 'الجمعة';

  @override
  String get friendshipDescription => 'أريد أن ألتقي بأصدقاء جدد وأجري محادثات';

  @override
  String get funChat => 'دردشة ممتعة';

  @override
  String get galleryPermission => 'إذن المعرض';

  @override
  String get galleryPermissionDesc => 'نحتاج إلى إذن المعرض لاختيار الصور.';

  @override
  String get gaming => 'ألعاب';

  @override
  String get gender => 'الجنس';

  @override
  String get genderNotSelectedInfo =>
      'إذا لم يتم تحديد الجنس، ستظهر شخصيات من جميع الأجناس';

  @override
  String get genderOptional => 'الجنس (اختياري)';

  @override
  String get genderPreferenceActive => 'يمكنك مقابلة شخصيات من جميع الأجناس';

  @override
  String get genderPreferenceDisabled =>
      'حدد جنسك لتمكين خيار الجنس المعاكس فقط';

  @override
  String get genderPreferenceInactive => 'سيتم عرض شخصيات من الجنس المعاكس فقط';

  @override
  String get genderRequired => 'الجنس *';

  @override
  String get genderSelectionInfo =>
      'إذا لم يتم الاختيار، يمكنك لقاء شخصيات من جميع الأجناس';

  @override
  String get generalPersona => 'شخصية عامة';

  @override
  String get goToSettings => 'الذهاب إلى الإعدادات';

  @override
  String get permissionGuideAndroid =>
      'الإعدادات > التطبيقات > SONA > الصلاحيات\nيرجى السماح بصلاحية الصور';

  @override
  String get permissionGuideIOS =>
      'الإعدادات > SONA > الصور\nيرجى السماح بالوصول للصور';

  @override
  String get googleLoginCanceled =>
      'تم إلغاء تسجيل الدخول عبر Google. يرجى المحاولة مرة أخرى.';

  @override
  String get googleLoginError => 'حدث خطأ أثناء تسجيل الدخول عبر Google.';

  @override
  String get grantPermission => 'متابعة';

  @override
  String get guest => 'ضيف';

  @override
  String get guestDataMigration =>
      'هل ترغب في الاحتفاظ بسجل الدردشات الحالي عند التسجيل؟';

  @override
  String get guestLimitReached => 'انتهت فترة تجربة الضيف.';

  @override
  String get guestLoginPromptMessage => 'سجل الدخول لمتابعة المحادثة';

  @override
  String get guestMessageExhausted => 'انتهت الرسائل المجانية';

  @override
  String guestMessageRemaining(int count) {
    return '$count رسالة ضيف متبقية';
  }

  @override
  String get guestModeBanner => 'وضع الضيف';

  @override
  String get guestModeDescription => 'جرب SONA دون التسجيل';

  @override
  String get guestModeFailedMessage => 'فشل بدء وضع الضيف';

  @override
  String get guestModeLimitation => 'بعض الميزات محدودة في وضع الضيف';

  @override
  String get guestModeTitle => 'جرب كضيف';

  @override
  String get guestModeWarning =>
      'يستمر وضع الضيف لمدة 24 ساعة، بعد ذلك سيتم حذف البيانات.';

  @override
  String get guestModeWelcome => 'بدء وضع الضيف';

  @override
  String get happy => 'سعيد';

  @override
  String get hapticFeedback => 'ردود الفعل اللمسية';

  @override
  String get harassmentBullying => 'التحرش/التنمر';

  @override
  String get hateSpeech => 'خطاب الكراهية';

  @override
  String get heartDescription => 'قلوب لمزيد من الرسائل';

  @override
  String get heartInsufficient => 'ليس لديك قلوب كافية';

  @override
  String get heartInsufficientPleaseCharge =>
      'ليس لديك قلوب كافية. يرجى إعادة شحن القلوب.';

  @override
  String get heartRequired => 'يتطلب 1 قلب';

  @override
  String get heartUsageFailed => 'فشل استخدام القلب.';

  @override
  String get hearts => 'قلوب';

  @override
  String get hearts10 => '10 قلوب';

  @override
  String get hearts30 => '30 قلب';

  @override
  String get hearts30Discount => 'تخفيض';

  @override
  String get hearts50 => '50 قلب';

  @override
  String get hearts50Discount => 'تخفيض';

  @override
  String get helloEmoji => 'مرحبًا! 😊';

  @override
  String get help => 'مساعدة';

  @override
  String get hideOriginalText => 'إخفاء النص الأصلي';

  @override
  String get hobbySharing => 'مشاركة الهوايات';

  @override
  String get hobbyTalk => 'حديث الهوايات';

  @override
  String get hours24Ago => 'منذ 24 ساعة';

  @override
  String hoursAgo(int count, String formatted) {
    return '$count ساعات مضت';
  }

  @override
  String get howToUse => 'كيفية استخدام SONA';

  @override
  String get imageCacheManagement => 'إدارة ذاكرة التخزين المؤقت للصور';

  @override
  String get inappropriateContent => 'محتوى غير مناسب';

  @override
  String get incorrect => 'غير صحيح';

  @override
  String get incorrectPassword => 'كلمة المرور غير صحيحة';

  @override
  String get indonesian => 'إندونيسي';

  @override
  String get inquiries => 'استفسارات';

  @override
  String get insufficientHearts => 'قلوب غير كافية.';

  @override
  String get interestSharing => 'مشاركة الاهتمامات';

  @override
  String get interestSharingDesc => 'اكتشف وشارك الاهتمامات المشتركة';

  @override
  String get interests => 'الاهتمامات';

  @override
  String get invalidEmailFormat => 'تنسيق البريد الإلكتروني غير صالح';

  @override
  String get invalidEmailFormatError => 'يرجى إدخال عنوان بريد إلكتروني صالح';

  @override
  String isTyping(String name) {
    return '$name يكتب...';
  }

  @override
  String get japanese => 'ياباني';

  @override
  String get joinDate => 'تاريخ الانضمام';

  @override
  String get justNow => 'الآن';

  @override
  String get keepGuestData => 'الاحتفاظ بسجل الدردشة';

  @override
  String get korean => 'كوري';

  @override
  String get koreanLanguage => 'كوري';

  @override
  String get language => 'اللغة';

  @override
  String get languageDescription =>
      'ستقوم الذكاء الاصطناعي بالرد باللغة التي اخترتها';

  @override
  String get languageIndicator => 'اللغة';

  @override
  String get languageSettings => 'إعدادات اللغة';

  @override
  String get lastOccurred => 'آخر حدوث:';

  @override
  String get lastUpdated => 'آخر تحديث';

  @override
  String get lateNight => 'وقت متأخر من الليل';

  @override
  String get later => 'لاحقاً';

  @override
  String get laterButton => 'لاحقاً';

  @override
  String get leave => 'مغادرة';

  @override
  String get leaveChatConfirm => 'هل تريد مغادرة هذه الدردشة؟';

  @override
  String get leaveChatRoom => 'مغادرة غرفة الدردشة';

  @override
  String get leaveChatTitle => 'مغادرة الدردشة';

  @override
  String get lifeAdvice => 'نصائح حياتية';

  @override
  String get lightTalk => 'حديث خفيف';

  @override
  String get lightTheme => 'الوضع الفاتح';

  @override
  String get lightThemeDesc => 'استخدم السمة الساطعة';

  @override
  String get loading => 'جاري التحميل...';

  @override
  String get loadingData => 'جارٍ تحميل البيانات...';

  @override
  String get loadingProducts => 'جارٍ تحميل المنتجات...';

  @override
  String get loadingProfile => 'جارٍ تحميل الملف الشخصي';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get loginButton => 'تسجيل الدخول';

  @override
  String get loginCancelled => 'تم إلغاء تسجيل الدخول';

  @override
  String get loginComplete => 'تم تسجيل الدخول بنجاح';

  @override
  String get loginError => 'فشل تسجيل الدخول';

  @override
  String get loginFailed => 'فشل تسجيل الدخول';

  @override
  String get loginFailedTryAgain => 'فشل تسجيل الدخول. يرجى المحاولة مرة أخرى.';

  @override
  String get loginRequired => 'يتطلب تسجيل الدخول';

  @override
  String get loginRequiredForProfile =>
      'تسجيل الدخول مطلوب لعرض الملف الشخصي والتحقق من السجلات مع SONA';

  @override
  String get loginRequiredService => 'تسجيل الدخول مطلوب لاستخدام هذه الخدمة';

  @override
  String get loginRequiredTitle => 'تسجيل الدخول مطلوب';

  @override
  String get loginSignup => 'تسجيل الدخول / الاشتراك';

  @override
  String get loginTab => 'تسجيل الدخول';

  @override
  String get loginTitle => 'تسجيل الدخول';

  @override
  String get loginWithApple => 'تسجيل الدخول باستخدام Apple';

  @override
  String get loginWithGoogle => 'تسجيل الدخول باستخدام Google';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get logoutConfirm => 'هل أنت متأكد أنك تريد تسجيل الخروج؟';

  @override
  String get lonelinessRelief => 'تخفيف الوحدة';

  @override
  String get lonely => 'وحيد';

  @override
  String get lowQualityResponses => 'ردود منخفضة الجودة';

  @override
  String get lunch => 'غداء';

  @override
  String get lunchtime => 'وقت الغداء';

  @override
  String get mainErrorType => 'نوع الخطأ الرئيسي';

  @override
  String get makeFriends => 'تكوين صداقات';

  @override
  String get male => 'ذكر';

  @override
  String get manageBlockedAIs => 'إدارة الذكاءات الاصطناعية المحجوبة';

  @override
  String get managePersonaImageCache => 'إدارة ذاكرة تخزين صور الشخصيات';

  @override
  String get marketingAgree => 'الموافقة على معلومات التسويق (اختياري)';

  @override
  String get marketingDescription =>
      'يمكنك تلقي معلومات حول الفعاليات والفوائد';

  @override
  String get matchPersonaStep =>
      '1. مطابقة الشخصيات: اسحب لليسار أو اليمين لاختيار شخصيات الذكاء الاصطناعي المفضلة لديك.';

  @override
  String get matchedPersonas => 'الشخصيات المتطابقة';

  @override
  String get matchedSona => 'SONA المتطابقة';

  @override
  String get matching => 'المطابقة';

  @override
  String get matchingFailed => 'فشل المطابقة.';

  @override
  String get me => 'Me';

  @override
  String get meetAIPersonas => 'تعرف على شخصيات الذكاء الاصطناعي';

  @override
  String get meetNewPersonas => 'تعرف على شخصيات جديدة';

  @override
  String get meetPersonas => 'تعرف على الشخصيات';

  @override
  String get memberBenefits =>
      'احصل على أكثر من 100 رسالة و10 قلوب عند التسجيل!';

  @override
  String get memoryAlbum => 'ألبوم الذكريات';

  @override
  String get memoryAlbumDesc => 'احفظ واسترجع اللحظات الخاصة تلقائيًا';

  @override
  String get messageCopied => 'تم نسخ الرسالة';

  @override
  String get messageDeleted => 'تم حذف الرسالة';

  @override
  String get messageLimitReset => 'سيتم إعادة تعيين حد الرسائل عند منتصف الليل';

  @override
  String get messageSendFailed =>
      'فشل في إرسال الرسالة. يرجى المحاولة مرة أخرى.';

  @override
  String get messagesRemaining => 'الرسائل المتبقية';

  @override
  String minutesAgo(int count, String formatted) {
    return '$count دقائق مضت';
  }

  @override
  String get missingTranslation => 'ترجمة مفقودة';

  @override
  String get monday => 'الإثنين';

  @override
  String get month => 'شهر';

  @override
  String monthDay(String month, int day) {
    return '$month $day';
  }

  @override
  String get moreButton => 'المزيد';

  @override
  String get morning => 'صباح';

  @override
  String get mostFrequentError => 'الخطأ الأكثر شيوعًا';

  @override
  String get movies => 'أفلام';

  @override
  String get multilingualChat => 'دردشة متعددة اللغات';

  @override
  String get music => 'موسيقى';

  @override
  String get myGenderSection => 'جنسيتي (اختياري)';

  @override
  String get networkErrorOccurred => 'حدث خطأ في الشبكة.';

  @override
  String get newMessage => 'رسالة جديدة';

  @override
  String newMessageCount(int count) {
    return '$count رسائل جديدة';
  }

  @override
  String get newMessageNotification => 'أعلمني بالرسائل الجديدة';

  @override
  String get newMessages => 'رسائل جديدة';

  @override
  String get newYear => 'السنة الجديدة';

  @override
  String get next => 'التالي';

  @override
  String get niceToMeetYou => 'سعيد بلقائك!';

  @override
  String get nickname => 'الاسم المستعار';

  @override
  String get nicknameAlreadyUsed => 'هذا الاسم المستعار مستخدم بالفعل';

  @override
  String get nicknameHelperText => '3-10 أحرف';

  @override
  String get nicknameHint => '3-10 أحرف';

  @override
  String get nicknameInUse => 'هذا الاسم المستعار مستخدم بالفعل';

  @override
  String get nicknameLabel => 'الاسم المستعار';

  @override
  String get nicknameLengthError => 'يجب أن يتكون الاسم المستعار من 3-10 أحرف';

  @override
  String get nicknamePlaceholder => 'أدخل اسمك المستعار';

  @override
  String get nicknameRequired => 'الاسم المستعار *';

  @override
  String get night => 'ليلة';

  @override
  String get no => 'لا';

  @override
  String get noBlockedAIs => 'لا توجد ذكاءات محجوبة';

  @override
  String get noChatsYet => 'لا توجد محادثات حتى الآن';

  @override
  String get noConversationYet => 'لا توجد محادثات حتى الآن';

  @override
  String get noErrorReports => 'لا توجد تقارير أخطاء.';

  @override
  String get noImageAvailable => 'لا توجد صورة متاحة';

  @override
  String get noMatchedPersonas => 'لا توجد شخصيات متطابقة حتى الآن';

  @override
  String get noMatchedSonas => 'لا توجد SONA متطابقة حتى الآن';

  @override
  String get noPersonasAvailable =>
      'لا توجد شخصيات متاحة. يرجى المحاولة مرة أخرى.';

  @override
  String get noPersonasToSelect => 'لا توجد شخصيات متاحة';

  @override
  String get noQualityIssues => 'لا توجد مشاكل جودة في الساعة الأخيرة ✅';

  @override
  String get noQualityLogs => 'لا توجد سجلات جودة بعد.';

  @override
  String get noTranslatedMessages => 'لا توجد رسائل لترجمتها';

  @override
  String get notEnoughHearts => 'ليس لديك قلوب كافية';

  @override
  String notEnoughHeartsCount(int count) {
    return 'ليس لديك قلوب كافية. (الحالي: $count)';
  }

  @override
  String get notRegistered => 'غير مسجل';

  @override
  String get notSubscribed => 'غير مشترك';

  @override
  String get notificationPermissionDesc =>
      'نحتاج إلى إذن الإشعارات لإرسال التنبيهات.';

  @override
  String get notificationPermissionRequired => 'إذن الإشعارات مطلوب';

  @override
  String get notificationSettings => 'إعدادات الإشعارات';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get occurrenceInfo => 'معلومات الحدوث:';

  @override
  String get olderChats => 'أقدم';

  @override
  String get onlyOppositeGenderNote =>
      'إذا تم إلغاء تحديدها، ستظهر فقط شخصيات الجنس المعاكس';

  @override
  String get openSettings => 'افتح الإعدادات';

  @override
  String get optional => 'اختياري';

  @override
  String get or => 'or';

  @override
  String get originalPrice => 'السعر الأصلي';

  @override
  String get originalText => 'أصلي';

  @override
  String get other => 'آخر';

  @override
  String get otherError => 'خطأ آخر';

  @override
  String get others => 'آخرون';

  @override
  String get ownedHearts => 'القلوب المملوكة';

  @override
  String get parentsDay => 'يوم الآباء';

  @override
  String get password => 'كلمة المرور';

  @override
  String get passwordConfirmation => 'أدخل كلمة المرور للتأكيد';

  @override
  String get passwordConfirmationDesc =>
      'يرجى إعادة إدخال كلمة المرور الخاصة بك لحذف الحساب.';

  @override
  String get passwordHint => '6 أحرف أو أكثر';

  @override
  String get passwordLabel => 'كلمة المرور';

  @override
  String get passwordRequired => 'كلمة المرور *';

  @override
  String get passwordResetEmailPrompt =>
      'يرجى إدخال بريدك الإلكتروني لإعادة تعيين كلمة المرور';

  @override
  String get passwordResetEmailSent =>
      'تم إرسال بريد إلكتروني لإعادة تعيين كلمة المرور. يرجى التحقق من بريدك الإلكتروني.';

  @override
  String get passwordText => 'كلمة المرور';

  @override
  String get passwordTooShort => 'يجب أن تتكون كلمة المرور من 6 أحرف على الأقل';

  @override
  String get permissionDenied => 'تم رفض الإذن';

  @override
  String permissionDeniedMessage(String permissionName) {
    return 'تم رفض $permissionName. يرجى منح الإذن من الإعدادات.';
  }

  @override
  String get permissionDeniedTryLater =>
      'تم رفض الإذن. يرجى المحاولة مرة أخرى لاحقًا.';

  @override
  String get permissionRequired => 'الإذن مطلوب';

  @override
  String get personaGenderSection => 'تفضيل جنس الشخصية';

  @override
  String get personaQualityStats => 'إحصائيات جودة الشخصية';

  @override
  String get personalInfoExposure => 'تعرض المعلومات الشخصية';

  @override
  String get personality => 'الشخصية';

  @override
  String get pets => 'الحيوانات الأليفة';

  @override
  String get photo => 'صورة';

  @override
  String get photography => 'التصوير الفوتوغرافي';

  @override
  String get picnic => 'نزهة';

  @override
  String get preferenceSettings => 'إعدادات التفضيلات';

  @override
  String get preferredLanguage => 'اللغة المفضلة';

  @override
  String get preparingForSleep => 'الاستعداد للنوم';

  @override
  String get preparingNewMeeting => 'التحضير لاجتماع جديد';

  @override
  String get preparingPersonaImages => 'التحضير لصور الشخصيات';

  @override
  String get preparingPersonas => 'التحضير للشخصيات';

  @override
  String get preview => 'معاينة';

  @override
  String get previous => 'السابق';

  @override
  String get privacy => 'سياسة الخصوصية';

  @override
  String get privacyPolicy => 'سياسة الخصوصية';

  @override
  String get privacyPolicyAgreement => 'يرجى الموافقة على سياسة الخصوصية';

  @override
  String get privacySection1Content =>
      'نحن ملتزمون بحماية خصوصيتك. تشرح سياسة الخصوصية هذه كيفية جمعنا واستخدامنا وحماية معلوماتك عند استخدامك لخدماتنا.';

  @override
  String get privacySection1Title => '1. غرض جمع واستخدام المعلومات الشخصية';

  @override
  String get privacySection2Content =>
      'نجمع المعلومات التي تقدمها لنا مباشرة، مثل عندما تقوم بإنشاء حساب، أو تحديث ملفك الشخصي، أو استخدام خدماتنا.';

  @override
  String get privacySection2Title => 'المعلومات التي نجمعها';

  @override
  String get privacySection3Content =>
      'نستخدم المعلومات التي نجمعها لتقديم خدماتنا وصيانتها وتحسينها، وللتواصل معك.';

  @override
  String get privacySection3Title =>
      '3. فترة الاحتفاظ واستخدام المعلومات الشخصية';

  @override
  String get privacySection4Content =>
      'نحن لا نبيع أو نتاجر أو ننقل معلوماتك الشخصية إلى أطراف ثالثة دون موافقتك.';

  @override
  String get privacySection4Title => '4. تقديم المعلومات الشخصية لأطراف ثالثة';

  @override
  String get privacySection5Content =>
      'نحن نطبق تدابير أمان مناسبة لحماية معلوماتك الشخصية من الوصول غير المصرح به، أو التعديل، أو الكشف، أو التدمير.';

  @override
  String get privacySection5Title =>
      '5. تدابير الحماية التقنية للمعلومات الشخصية';

  @override
  String get privacySection6Content =>
      'نحتفظ بالمعلومات الشخصية طالما كان ذلك ضروريًا لتقديم خدماتنا والامتثال للالتزامات القانونية.';

  @override
  String get privacySection6Title => '6. حقوق المستخدم';

  @override
  String get privacySection7Content =>
      'لديك الحق في الوصول إلى معلوماتك الشخصية، وتحديثها، أو حذفها في أي وقت من خلال إعدادات حسابك.';

  @override
  String get privacySection7Title => 'حقوقك';

  @override
  String get privacySection8Content =>
      'إذا كان لديك أي أسئلة حول سياسة الخصوصية هذه، يرجى الاتصال بنا على support@sona.com.';

  @override
  String get privacySection8Title => 'اتصل بنا';

  @override
  String get privacySettings => 'إعدادات الخصوصية';

  @override
  String get privacySettingsInfo =>
      'تعطيل الميزات الفردية سيجعل تلك الخدمات غير متاحة';

  @override
  String get privacySettingsScreen => 'إعدادات الخصوصية';

  @override
  String get problemMessage => 'مشكلة';

  @override
  String get problemOccurred => 'حدثت مشكلة';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get profileEdit => 'تعديل الملف الشخصي';

  @override
  String get profileEditLoginRequiredMessage =>
      'يتطلب تسجيل الدخول لتعديل ملفك الشخصي.';

  @override
  String get profileInfo => 'معلومات الملف الشخصي';

  @override
  String get profileInfoDescription =>
      'يرجى إدخال صورة الملف الشخصي والمعلومات الأساسية';

  @override
  String get profileNav => 'الملف الشخصي';

  @override
  String get profilePhoto => 'صورة الملف الشخصي';

  @override
  String get profilePhotoAndInfo =>
      'يرجى إدخال صورة الملف الشخصي والمعلومات الأساسية';

  @override
  String get profilePhotoUpdateFailed => 'فشل تحديث صورة الملف الشخصي';

  @override
  String get profilePhotoUpdated => 'تم تحديث صورة الملف الشخصي';

  @override
  String get profileSettings => 'إعدادات الملف الشخصي';

  @override
  String get profileSetup => 'إعداد الملف الشخصي';

  @override
  String get profileUpdateFailed => 'فشل تحديث الملف الشخصي';

  @override
  String get profileUpdated => 'تم تحديث الملف الشخصي بنجاح';

  @override
  String get purchaseAndRefundPolicy => 'سياسة الشراء والاسترداد';

  @override
  String get purchaseButton => 'شراء';

  @override
  String get purchaseConfirm => 'تأكيد الشراء';

  @override
  String purchaseConfirmContent(String product, String price) {
    return 'شراء $product مقابل $price؟';
  }

  @override
  String purchaseConfirmMessage(
      String title, String price, String description) {
    return 'تأكيد شراء $title مقابل $price؟ $description';
  }

  @override
  String get purchaseFailed => 'فشل الشراء';

  @override
  String get purchaseHeartsOnly => 'اشترِ القلوب';

  @override
  String get purchaseMoreHearts => 'اشترِ القلوب لمتابعة المحادثات';

  @override
  String get purchasePending => 'الشراء قيد الانتظار...';

  @override
  String get purchasePolicy => 'سياسة الشراء';

  @override
  String get purchaseSection1Content =>
      'نقبل طرق دفع متنوعة بما في ذلك بطاقات الائتمان والمحافظ الرقمية.';

  @override
  String get purchaseSection1Title => 'طرق الدفع';

  @override
  String get purchaseSection2Content =>
      'يمكن استرداد المبالغ خلال 14 يومًا من الشراء إذا لم تقم باستخدام العناصر المشتراة.';

  @override
  String get purchaseSection2Title => 'سياسة الاسترداد';

  @override
  String get purchaseSection3Content =>
      'يمكنك إلغاء اشتراكك في أي وقت من خلال إعدادات حسابك.';

  @override
  String get purchaseSection3Title => 'الإلغاء';

  @override
  String get purchaseSection4Content =>
      'من خلال إجراء عملية شراء، فإنك توافق على شروط الاستخدام واتفاقية الخدمة الخاصة بنا.';

  @override
  String get purchaseSection4Title => 'شروط الاستخدام';

  @override
  String get purchaseSection5Content =>
      'لمشاكل تتعلق بالشراء، يرجى الاتصال بفريق الدعم لدينا.';

  @override
  String get purchaseSection5Title => 'اتصل بالدعم';

  @override
  String get purchaseSection6Content =>
      'جميع المشتريات تخضع لشروطنا وأحكامنا القياسية.';

  @override
  String get purchaseSection6Title => '6. الاستفسارات';

  @override
  String get pushNotifications => 'الإشعارات الفورية';

  @override
  String get reading => 'قراءة';

  @override
  String get realtimeQualityLog => 'سجل الجودة في الوقت الحقيقي';

  @override
  String get recentConversation => 'المحادثة الأخيرة:';

  @override
  String get recentLoginRequired => 'يرجى تسجيل الدخول مرة أخرى لأسباب أمنية';

  @override
  String get referrerEmail => 'بريد المحيل';

  @override
  String get referrerEmailHelper => 'اختياري: بريد الشخص الذي أحالك';

  @override
  String get referrerEmailLabel => 'بريد المحيل (اختياري)';

  @override
  String get refresh => 'تحديث';

  @override
  String refreshComplete(int count) {
    return 'تم التحديث بنجاح! $count شخصيات متطابقة';
  }

  @override
  String get refreshFailed => 'فشل التحديث';

  @override
  String get refreshingChatList => 'جاري تحديث قائمة الدردشات...';

  @override
  String get relatedFAQ => 'الأسئلة الشائعة ذات الصلة';

  @override
  String get report => 'إبلاغ';

  @override
  String get reportAI => 'الإبلاغ';

  @override
  String get reportAIDescription =>
      'إذا شعرت بعدم الارتياح بسبب الذكاء الاصطناعي، يرجى وصف المشكلة.';

  @override
  String get reportAITitle => 'الإبلاغ عن محادثة الذكاء الاصطناعي';

  @override
  String get reportAndBlock => 'الإبلاغ والحظر';

  @override
  String get reportAndBlockDescription =>
      'يمكنك الإبلاغ عن سلوك غير مناسب لهذا الذكاء الاصطناعي وحظره.';

  @override
  String get reportChatError => 'الإبلاغ عن خطأ في الدردشة';

  @override
  String reportError(String error) {
    return 'حدث خطأ أثناء الإبلاغ: $error';
  }

  @override
  String get reportFailed => 'فشل الإبلاغ';

  @override
  String get reportSubmitted =>
      'تم تقديم التقرير. سنقوم بمراجعته واتخاذ الإجراءات اللازمة.';

  @override
  String get reportSubmittedSuccess => 'تم تقديم تقريرك. شكرًا لك!';

  @override
  String get requestLimit => 'حد الطلب';

  @override
  String get required => '[مطلوب]';

  @override
  String get requiredTermsAgreement => 'يرجى الموافقة على الشروط';

  @override
  String get restartConversation => 'إعادة بدء المحادثة';

  @override
  String restartConversationQuestion(String name) {
    return 'هل ترغب في إعادة بدء المحادثة مع $name؟';
  }

  @override
  String restartConversationWithName(String name) {
    return 'إعادة بدء المحادثة مع $name!';
  }

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get retryButton => 'إعادة المحاولة';

  @override
  String get sad => 'حزين';

  @override
  String get saturday => 'السبت';

  @override
  String get save => 'حفظ';

  @override
  String get search => 'بحث';

  @override
  String get searchFAQ => 'البحث في الأسئلة الشائعة...';

  @override
  String get searchResults => 'نتائج البحث';

  @override
  String get selectEmotion => 'اختر شعور';

  @override
  String get selectErrorType => 'اختر نوع الخطأ';

  @override
  String get selectFeeling => 'اختر الشعور';

  @override
  String get selectGender => 'اختر الجنس';

  @override
  String get selectInterests => 'يرجى اختيار اهتماماتك (على الأقل 1)';

  @override
  String get selectLanguage => 'اختر اللغة';

  @override
  String get selectPersona => 'اختر شخصية';

  @override
  String get selectPersonaPlease => 'يرجى اختيار شخصية.';

  @override
  String get selectPreferredMbti =>
      'إذا كنت تفضل شخصيات بأنواع MBTI محددة، يرجى الاختيار';

  @override
  String get selectProblematicMessage => 'اختر الرسالة المشكلة (اختياري)';

  @override
  String get chatErrorAnalysisInfo => 'جاري تحليل آخر 10 محادثات.';

  @override
  String get whatWasAwkward => 'ما الذي بدا غريباً؟';

  @override
  String get errorExampleHint => 'مثال: طريقة كلام غريبة (نهايات ~nya)...';

  @override
  String get selectReportReason => 'اختر سبب التقرير';

  @override
  String get selectTheme => 'اختر المظهر';

  @override
  String get selectTranslationError =>
      'يرجى اختيار رسالة تحتوي على خطأ في الترجمة';

  @override
  String get selectUsagePurpose => 'يرجى اختيار الغرض من استخدام SONA';

  @override
  String get selfIntroduction => 'مقدمة (اختياري)';

  @override
  String get selfIntroductionHint => 'اكتب مقدمة قصيرة عن نفسك';

  @override
  String get send => 'إرسال';

  @override
  String get sendChatError => 'خطأ في إرسال الدردشة';

  @override
  String get sendFirstMessage => 'أرسل رسالتك الأولى';

  @override
  String get sendReport => 'إرسال تقرير';

  @override
  String get sendingEmail => 'جاري إرسال البريد الإلكتروني...';

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
  String get settings => 'الإعدادات';

  @override
  String get sexualContent => 'Sexual content';

  @override
  String get showAllGenderPersonas => 'Show All Gender Personas';

  @override
  String get showAllGendersOption => 'عرض جميع الأجناس';

  @override
  String get showOppositeGenderOnly =>
      'إذا لم يتم تحديده، سيتم عرض شخصيات الجنس المعاكس فقط';

  @override
  String get showOriginalText => 'عرض النص الأصلي';

  @override
  String get signUp => 'التسجيل';

  @override
  String get signUpFromGuest => 'سجّل الآن للوصول إلى جميع الميزات!';

  @override
  String get signup => 'التسجيل';

  @override
  String get signupComplete => 'تم التسجيل بنجاح';

  @override
  String get signupTab => 'التسجيل';

  @override
  String get simpleInfoRequired => 'معلومات بسيطة مطلوبة';

  @override
  String get skip => 'تخطي';

  @override
  String get sonaFriend => 'صديق سونا';

  @override
  String get sonaPrivacyPolicy => 'سياسة خصوصية سونا';

  @override
  String get sonaPurchasePolicy => 'سياسة شراء سونا';

  @override
  String get sonaTermsOfService => 'شروط خدمة سونا';

  @override
  String get sonaUsagePurpose => 'يرجى تحديد الغرض من استخدام سونا';

  @override
  String get sorryNotHelpful => 'عذرًا، لم يكن هذا مفيدًا';

  @override
  String get sort => 'ترتيب';

  @override
  String get soundSettings => 'إعدادات الصوت';

  @override
  String get spamAdvertising => 'بريد عشوائي/إعلانات';

  @override
  String get spanish => 'الإسبانية';

  @override
  String get specialRelationshipDesc => 'فهم بعضهم البعض وبناء روابط عميقة';

  @override
  String get sports => 'الرياضة';

  @override
  String get spring => 'الربيع';

  @override
  String get startChat => 'ابدأ الدردشة';

  @override
  String get startChatButton => 'ابدأ الدردشة';

  @override
  String get startConversation => 'ابدأ محادثة';

  @override
  String get startConversationLikeAFriend => 'ابدأ محادثة مع سونا كصديق';

  @override
  String get startConversationStep =>
      '2. ابدأ المحادثة: تحدث بحرية مع الشخصيات المتطابقة.';

  @override
  String get startConversationWithSona => 'ابدأ الدردشة مع سونا كصديق!';

  @override
  String get startWithEmail => 'ابدأ بالبريد الإلكتروني';

  @override
  String get startWithGoogle => 'ابدأ باستخدام جوجل';

  @override
  String get startingApp => 'بدء التطبيق';

  @override
  String get storageManagement => 'إدارة التخزين';

  @override
  String get store => 'المتجر';

  @override
  String get storeConnectionError => 'لم نتمكن من الاتصال بالمتجر';

  @override
  String get storeLoginRequiredMessage => 'يتطلب تسجيل الدخول لاستخدام المتجر.';

  @override
  String get storeNotAvailable => 'المتجر غير متوفر';

  @override
  String get storyEvent => 'حدث القصة';

  @override
  String get stressed => 'متوتر';

  @override
  String get submitReport => 'تقديم تقرير';

  @override
  String get subscriptionStatus => 'حالة الاشتراك';

  @override
  String get subtleVibrationOnTouch => 'اهتزاز خفيف عند اللمس';

  @override
  String get summer => 'صيف';

  @override
  String get sunday => 'الأحد';

  @override
  String get swipeAnyDirection => 'اسحب في أي اتجاه';

  @override
  String get swipeDownToClose => 'اسحب لأسفل للإغلاق';

  @override
  String get systemTheme => 'اتبع النظام';

  @override
  String get systemThemeDesc =>
      'يتغير تلقائيًا بناءً على إعدادات وضع الظلام للجهاز';

  @override
  String get tapBottomForDetails => 'انقر على المنطقة السفلية لرؤية التفاصيل';

  @override
  String get tapForDetails => 'انقر على المنطقة السفلية للتفاصيل';

  @override
  String get tapToSwipePhotos => 'انقر للسحب بين الصور';

  @override
  String get teachersDay => 'يوم المعلم';

  @override
  String get technicalError => 'خطأ تقني';

  @override
  String get technology => 'تكنولوجيا';

  @override
  String get terms => 'شروط الخدمة';

  @override
  String get termsAgreement => 'اتفاقية الشروط';

  @override
  String get termsAgreementDescription =>
      'يرجى الموافقة على الشروط لاستخدام الخدمة';

  @override
  String get termsOfService => 'شروط الخدمة';

  @override
  String get termsSection10Content =>
      'نحتفظ بالحق في تعديل هذه الشروط في أي وقت مع إشعار للمستخدمين.';

  @override
  String get termsSection10Title => 'المادة 10 (حل النزاعات)';

  @override
  String get termsSection11Content =>
      'تخضع هذه الشروط لقوانين الولاية القضائية التي نعمل فيها.';

  @override
  String get termsSection11Title => 'المادة 11 (أحكام خاصة بالخدمة الذكية)';

  @override
  String get termsSection12Content =>
      'إذا وُجد أن أي حكم من هذه الشروط غير قابل للتنفيذ، ستظل الأحكام المتبقية سارية المفعول بالكامل.';

  @override
  String get termsSection12Title => 'المادة 12 (جمع البيانات واستخدامها)';

  @override
  String get termsSection1Content =>
      'تهدف هذه الشروط والأحكام إلى تحديد الحقوق والالتزامات والمسؤوليات بين SONA (المشار إليها فيما بعد بـ \"الشركة\") والمستخدمين فيما يتعلق باستخدام خدمة مطابقة محادثة الشخصية الذكية (المشار إليها فيما بعد بـ \"الخدمة\") المقدمة من الشركة.';

  @override
  String get termsSection1Title => 'المادة 1 (الهدف)';

  @override
  String get termsSection2Content =>
      'من خلال استخدام خدمتنا، فإنك توافق على الالتزام بشروط الخدمة هذه وسياسة الخصوصية الخاصة بنا.';

  @override
  String get termsSection2Title => 'المادة 2 (التعريفات)';

  @override
  String get termsSection3Content =>
      'يجب أن تكون في سن 13 عامًا على الأقل لاستخدام خدمتنا.';

  @override
  String get termsSection3Title => 'المادة 3 (أثر وتعديل الشروط)';

  @override
  String get termsSection4Content =>
      'أنت مسؤول عن الحفاظ على سرية حسابك وكلمة المرور الخاصة بك.';

  @override
  String get termsSection4Title => 'المادة 4 (تقديم الخدمة)';

  @override
  String get termsSection5Content =>
      'توافق على عدم استخدام خدمتنا لأي غرض غير قانوني أو غير مصرح به.';

  @override
  String get termsSection5Title => 'المادة 5 (تسجيل العضوية)';

  @override
  String get termsSection6Content =>
      'نحتفظ بالحق في إنهاء أو تعليق حسابك بسبب انتهاك هذه الشروط.';

  @override
  String get termsSection6Title => 'المادة 6 (التزامات المستخدم)';

  @override
  String get termsSection7Content =>
      'قد تقوم الشركة بتقييد استخدام الخدمة تدريجياً من خلال التحذيرات، أو التعليق المؤقت، أو التعليق الدائم إذا انتهك المستخدمون التزامات هذه الشروط أو تدخلوا في العمليات العادية للخدمة.';

  @override
  String get termsSection7Title => 'المادة 7 (قيود استخدام الخدمة)';

  @override
  String get termsSection8Content =>
      'نحن غير مسؤولين عن أي أضرار غير مباشرة أو عرضية أو تبعية ناتجة عن استخدامك لخدمتنا.';

  @override
  String get termsSection8Title => 'المادة 8 (انقطاع الخدمة)';

  @override
  String get termsSection9Content =>
      'جميع المحتويات والمواد المتاحة على خدمتنا محمية بحقوق الملكية الفكرية.';

  @override
  String get termsSection9Title => 'المادة 9 (إخلاء المسؤولية)';

  @override
  String get termsSupplementary => 'الشروط التكميلية';

  @override
  String get thai => 'تايلاندي';

  @override
  String get thanksFeedback => 'شكرًا على ملاحظاتك!';

  @override
  String get theme => 'المظهر';

  @override
  String get themeDescription => 'يمكنك تخصيص مظهر التطبيق كما تشاء';

  @override
  String get themeSettings => 'إعدادات السمة';

  @override
  String get thursday => 'الخميس';

  @override
  String get timeout => 'انتهاء الوقت';

  @override
  String get tired => 'متعب';

  @override
  String get today => 'اليوم';

  @override
  String get todayChats => 'اليوم';

  @override
  String get todayText => 'اليوم';

  @override
  String get tomorrowText => 'غدًا';

  @override
  String get totalConsultSessions => 'إجمالي جلسات الاستشارة';

  @override
  String get totalErrorCount => 'إجمالي عدد الأخطاء';

  @override
  String get totalLikes => 'إجمالي الإعجابات';

  @override
  String totalOccurrences(Object count) {
    return 'إجمالي $count حدوث';
  }

  @override
  String get totalResponses => 'إجمالي الردود';

  @override
  String get translatedFrom => 'مترجم';

  @override
  String get translatedText => 'ترجمة';

  @override
  String get translationError => 'خطأ في الترجمة';

  @override
  String get translationErrorDescription =>
      'يرجى الإبلاغ عن الترجمات غير الصحيحة أو التعبيرات الغير ملائمة';

  @override
  String get translationErrorReported =>
      'تم الإبلاغ عن خطأ في الترجمة. شكرًا لك!';

  @override
  String get translationNote =>
      '※ قد لا تكون الترجمة بواسطة الذكاء الاصطناعي مثالية';

  @override
  String get translationQuality => 'جودة الترجمة';

  @override
  String get translationSettings => 'إعدادات الترجمة';

  @override
  String get travel => 'السفر';

  @override
  String get tuesday => 'الثلاثاء';

  @override
  String get tutorialAccount => 'حساب الدروس';

  @override
  String get tutorialWelcomeDescription =>
      'أنشئ علاقات خاصة مع شخصيات الذكاء الاصطناعي.';

  @override
  String get tutorialWelcomeTitle => 'مرحبًا بك في SONA!';

  @override
  String get typeMessage => 'اكتب رسالة...';

  @override
  String get unblock => 'إلغاء الحظر';

  @override
  String get unblockFailed => 'فشل في إلغاء الحظر';

  @override
  String unblockPersonaConfirm(String name) {
    return 'هل تريد إلغاء حظر $name؟';
  }

  @override
  String get unblockedSuccessfully => 'تم إلغاء الحظر بنجاح';

  @override
  String get unexpectedLoginError => 'حدث خطأ غير متوقع أثناء تسجيل الدخول';

  @override
  String get unknown => 'غير معروف';

  @override
  String get unknownError => 'خطأ غير معروف';

  @override
  String get unlimitedMessages => 'غير محدود';

  @override
  String get unsendMessage => 'إلغاء إرسال الرسالة';

  @override
  String get usagePurpose => 'غرض الاستخدام';

  @override
  String get useOneHeart => 'استخدم 1 قلب';

  @override
  String get useSystemLanguage => 'استخدم لغة النظام';

  @override
  String get user => 'المستخدم:';

  @override
  String get userMessage => 'رسالة المستخدم:';

  @override
  String get userNotFound => 'المستخدم غير موجود';

  @override
  String get valentinesDay => 'عيد الحب';

  @override
  String get verifyingAuth => 'التحقق من المصادقة';

  @override
  String get version => 'الإصدار';

  @override
  String get vietnamese => 'فيتنامي';

  @override
  String get violentContent => 'محتوى عنيف';

  @override
  String get voiceMessage => '🎤 رسالة صوتية';

  @override
  String waitingForChat(String name) {
    return '$name في انتظار الدردشة.';
  }

  @override
  String get walk => 'امشِ';

  @override
  String get wasHelpful => 'هل كان هذا مفيداً؟';

  @override
  String get weatherClear => 'صافٍ';

  @override
  String get weatherCloudy => 'غائم';

  @override
  String get weatherContext => 'سياق الطقس';

  @override
  String get weatherContextDesc => 'قدم سياق المحادثة بناءً على الطقس';

  @override
  String get weatherDrizzle => 'رذاذ';

  @override
  String get weatherFog => 'ضباب';

  @override
  String get weatherMist => 'ضباب خفيف';

  @override
  String get weatherRain => 'مطر';

  @override
  String get weatherRainy => 'ممطر';

  @override
  String get weatherSnow => 'ثلج';

  @override
  String get weatherSnowy => 'مثلج';

  @override
  String get weatherThunderstorm => 'عاصفة رعدية';

  @override
  String get wednesday => 'الأربعاء';

  @override
  String get weekdays => 'الأحد,الإثنين,الثلاثاء,الأربعاء,الخميس,الجمعة,السبت';

  @override
  String get welcomeMessage => 'مرحباً💕';

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
  String get yes => 'نعم';

  @override
  String get yesterday => 'أمس';

  @override
  String get yesterdayChats => 'Yesterday';

  @override
  String get you => 'You';

  @override
  String get loadingPersonaData => 'جاري تحميل بيانات الشخصية';

  @override
  String get checkingMatchedPersonas => 'جاري التحقق من الشخصيات المطابقة';

  @override
  String get preparingImages => 'جاري تحضير الصور';

  @override
  String get finalPreparation => 'التحضير النهائي';

  @override
  String get editProfileSubtitle => 'تعديل الجنس وتاريخ الميلاد والمقدمة';

  @override
  String get systemThemeName => 'النظام';

  @override
  String get lightThemeName => 'فاتح';

  @override
  String get darkThemeName => 'داكن';

  @override
  String get alwaysShowTranslationOn => 'إظهار الترجمة دائماً';

  @override
  String get alwaysShowTranslationOff => 'إخفاء الترجمة التلقائية';

  @override
  String get translationErrorAnalysisInfo =>
      'سنقوم بتحليل الرسالة المختارة وترجمتها.';

  @override
  String get whatWasWrongWithTranslation => 'ما الخطأ في الترجمة؟';

  @override
  String get translationErrorHint =>
      'مثال: معنى خاطئ، تعبير غير طبيعي، سياق خاطئ...';

  @override
  String get pleaseSelectMessage => 'الرجاء اختيار رسالة أولاً';

  @override
  String get myPersonas => 'شخصياتي';

  @override
  String get createPersona => 'إنشاء شخصية';

  @override
  String get tellUsAboutYourPersona => 'أخبرنا عن شخصيتك';

  @override
  String get enterPersonaName => 'أدخل اسم الشخصية';

  @override
  String get describeYourPersona => 'اوصف شخصيتك بإيجاز';

  @override
  String get profileImage => 'صورة الملف الشخصي';

  @override
  String get uploadPersonaImages => 'ارفع صوراً لشخصيتك';

  @override
  String get mainImage => 'الصورة الرئيسية';

  @override
  String get tapToUpload => 'اضغط للرفع';

  @override
  String get additionalImages => 'صور إضافية';

  @override
  String get addImage => 'إضافة صورة';

  @override
  String get mbtiQuestion => 'سؤال الشخصية';

  @override
  String get mbtiComplete => 'اكتمل اختبار الشخصية!';

  @override
  String get mbtiTest => 'اختبار MBTI';

  @override
  String get mbtiStepDescription =>
      'دعنا نحدد الشخصية التي يجب أن تكون عليها شخصيتك. أجب على الأسئلة لتشكيل شخصيتها.';

  @override
  String get startTest => 'بدء الاختبار';

  @override
  String get personalitySettings => 'إعدادات الشخصية';

  @override
  String get speechStyle => 'أسلوب الكلام';

  @override
  String get conversationStyle => 'أسلوب المحادثة';

  @override
  String get shareWithCommunity => 'مشاركة مع المجتمع';

  @override
  String get shareDescription =>
      'ستتم مشاركة شخصيتك مع المستخدمين الآخرين بعد الموافقة';

  @override
  String get sharePersona => 'مشاركة الشخصية';

  @override
  String get willBeSharedAfterApproval => 'ستتم المشاركة بعد موافقة المشرف';

  @override
  String get privatePersonaDescription => 'يمكنك فقط رؤية هذه الشخصية';

  @override
  String get create => 'إنشاء';

  @override
  String get personaCreated => 'تم إنشاء الشخصية بنجاح!';

  @override
  String get createFailed => 'فشل في إنشاء الشخصية';

  @override
  String get pendingApproval => 'في انتظار الموافقة';

  @override
  String get approved => 'موافق عليها';

  @override
  String get privatePersona => 'خاصة';

  @override
  String get noPersonasYet => 'لا توجد شخصيات بعد';

  @override
  String get createYourFirstPersona => 'أنشئ شخصيتك الأولى وابدأ رحلتك';

  @override
  String get deletePersona => 'حذف الشخصية';

  @override
  String get deletePersonaConfirm =>
      'هل أنت متأكد من أنك تريد حذف هذه الشخصية؟';

  @override
  String get personaDeleted => 'تم حذف الشخصية بنجاح';

  @override
  String get deleteFailed => 'فشل في الحذف';

  @override
  String get personaLimitReached => 'لقد وصلت إلى حد 3 شخصيات';

  @override
  String get personaName => 'الاسم';

  @override
  String get personaAge => 'العمر';

  @override
  String get personaDescription => 'الوصف';

  @override
  String get personaNameHint => 'أدخل اسم الشخصية';

  @override
  String get personaDescriptionHint => 'صف الشخصية';

  @override
  String get loginRequiredContent => 'يرجى تسجيل الدخول للمتابعة';

  @override
  String get reportErrorButton => 'الإبلاغ عن خطأ';

  @override
  String get speechStyleFriendly => 'ودود';

  @override
  String get speechStylePolite => 'مهذب';

  @override
  String get speechStyleChic => 'أنيق';

  @override
  String get speechStyleLively => 'حيوي';

  @override
  String get conversationStyleTalkative => 'ثرثار';

  @override
  String get conversationStyleQuiet => 'هادئ';

  @override
  String get conversationStyleEmpathetic => 'متعاطف';

  @override
  String get conversationStyleLogical => 'منطقي';

  @override
  String get interestMusic => 'موسيقى';

  @override
  String get interestMovies => 'أفلام';

  @override
  String get interestReading => 'قراءة';

  @override
  String get interestTravel => 'سفر';

  @override
  String get interestExercise => 'تمرين';

  @override
  String get interestGaming => 'ألعاب';

  @override
  String get interestCooking => 'طبخ';

  @override
  String get interestFashion => 'موضة';

  @override
  String get interestArt => 'فن';

  @override
  String get interestPhotography => 'تصوير';

  @override
  String get interestTechnology => 'تقنية';

  @override
  String get interestScience => 'علوم';

  @override
  String get interestHistory => 'تاريخ';

  @override
  String get interestPhilosophy => 'فلسفة';

  @override
  String get interestPolitics => 'سياسة';

  @override
  String get interestEconomy => 'اقتصاد';

  @override
  String get interestSports => 'رياضة';

  @override
  String get interestAnimation => 'رسوم متحركة';

  @override
  String get interestKpop => 'K-POP';

  @override
  String get interestDrama => 'دراما';

  @override
  String get imageOptionalR2 =>
      'الصور اختيارية. سيتم تحميلها فقط إذا تم تكوين R2.';

  @override
  String get networkErrorCheckConnection =>
      'خطأ في الشبكة: يرجى التحقق من اتصالك بالإنترنت';

  @override
  String get maxFiveItems => 'حتى 5 عناصر';

  @override
  String get mbtiQuestion1 => 'When meeting new people';

  @override
  String get mbtiQuestion1OptionA => 'Hello... nice to meet you';

  @override
  String get mbtiQuestion1OptionB => 'Oh! Nice to meet you! I\'m XX!';

  @override
  String get mbtiQuestion2 => 'When understanding a situation';

  @override
  String get mbtiQuestion2OptionA => 'What exactly happened and how?';

  @override
  String get mbtiQuestion2OptionB => 'I think I get the general feeling';

  @override
  String get mbtiQuestion3 => 'When making decisions';

  @override
  String get mbtiQuestion3OptionA => 'Thinking logically...';

  @override
  String get mbtiQuestion3OptionB => 'Your feelings matter more';

  @override
  String get mbtiQuestion4 => 'When making appointments';

  @override
  String get mbtiQuestion4OptionA => 'Let\'s meet exactly at X o\'clock';

  @override
  String get mbtiQuestion4OptionB => 'See you around that time~';

  @override
  String get meetNewSona => 'Meet new Sona!';

  @override
  String ageAndPersonality(String age, String personality) {
    return '$age years old • $personality';
  }

  @override
  String get guestLabel => 'Guest';

  @override
  String get developerOptions => 'Developer Options';

  @override
  String get reengagementNotificationTest => 'Re-engagement Notification Test';

  @override
  String get churnRiskNotificationTest => 'Churn Risk Notification Test';

  @override
  String get selectChurnRisk => 'Select churn risk:';

  @override
  String get sevenDaysInactive => '7+ days inactive (90% risk)';

  @override
  String get threeDaysInactive => '3 days inactive (70% risk)';

  @override
  String get oneDayInactive => '1 day inactive (50% risk)';

  @override
  String get generalNotification => 'General notification (30% risk)';

  @override
  String get noActivePersonas => 'No active personas';

  @override
  String percentDiscount(String percent) {
    return '$percent% OFF';
  }

  @override
  String imageLoadProgress(String loaded, String total) {
    return '$loaded / $total images';
  }

  @override
  String get checkingNewImages => 'Checking for new images...';

  @override
  String get findingNewPersonas => 'Finding new personas...';

  @override
  String get superLikeMatch => 'Super Like Match!';

  @override
  String get matchSuccess => 'Match Success!';

  @override
  String restartingConversationWith(String name) {
    return 'Restarting conversation with $name!';
  }

  @override
  String personaLikesYou(String name) {
    return '$name especially likes you!';
  }

  @override
  String matchedWithPersona(String name) {
    return 'Matched with $name!';
  }

  @override
  String get previousConversationKept =>
      'Previous conversation is preserved. Continue where you left off!';

  @override
  String get specialConnectionStart =>
      'Start of a special connection! Sona is waiting for you';

  @override
  String get preparingProfilePicture => 'Preparing profile picture...';

  @override
  String get newSonaComingSoon => 'New Sona coming soon!';

  @override
  String get superLikeDescription => 'Super Like (instant love stage)';

  @override
  String get checkingMorePersonas => 'Checking more personas...';

  @override
  String get allFilter => 'All';

  @override
  String get published => 'Published';

  @override
  String yearsOld(String age) {
    return '$age years old';
  }

  @override
  String startConversationWithPersona(String name) {
    return 'Start conversation with $name?';
  }

  @override
  String get failedToStartConversation => 'Failed to start conversation';

  @override
  String get cannotDeleteApprovedPersona => 'Cannot delete approved persona';

  @override
  String get deletePersonaWithConversation =>
      'This persona has an active conversation. Delete anyway?\nThe chat room will also be deleted.';

  @override
  String get sharedPersonaDeleteWarning =>
      'This is a shared persona. It will only be removed from your list.';

  @override
  String get firebasePermissionError =>
      'Firebase permission error: Please contact administrator';

  @override
  String get checkingPersonaInfo => 'Checking persona information...';

  @override
  String get personaCacheDescription =>
      'Persona images are saved on device for fast loading.';

  @override
  String get cacheDeleteWarning =>
      'Deleting cache will require re-downloading images.';

  @override
  String get blockedAIDescription =>
      'Blocked AI will be excluded from matching and chat list.';

  @override
  String searchResultsCount(String count) {
    return 'Search results: $count';
  }

  @override
  String questionsCount(String count) {
    return '$count questions';
  }

  @override
  String get readyToChat => 'Ready to chat!';

  @override
  String preparingPersonasCount(String count) {
    return 'Preparing personas... ($count)';
  }

  @override
  String get loggingIn => 'Logging in...';

  @override
  String languageChangedTo(String language) {
    return 'Language changed to $language';
  }

  @override
  String get englishLanguage => 'English';

  @override
  String get japaneseLanguage => 'Japanese';

  @override
  String get chineseLanguage => 'Chinese';

  @override
  String get thaiLanguage => 'Thai';

  @override
  String get vietnameseLanguage => 'Vietnamese';

  @override
  String get indonesianLanguage => 'Indonesian';

  @override
  String get tagalogLanguage => 'Tagalog';

  @override
  String get spanishLanguage => 'Spanish';

  @override
  String get frenchLanguage => 'French';

  @override
  String get germanLanguage => 'German';

  @override
  String get russianLanguage => 'Russian';

  @override
  String get portugueseLanguage => 'Portuguese';

  @override
  String get italianLanguage => 'Italian';

  @override
  String get dutchLanguage => 'Dutch';

  @override
  String get swedishLanguage => 'Swedish';

  @override
  String get polishLanguage => 'Polish';

  @override
  String get turkishLanguage => 'Turkish';

  @override
  String get arabicLanguage => 'Arabic';

  @override
  String get hindiLanguage => 'Hindi';

  @override
  String get urduLanguage => 'Urdu';

  @override
  String get nameRequired => 'Please enter a name';

  @override
  String get ageRequired => 'Please enter age';

  @override
  String get descriptionRequired => 'Please enter a description';

  @override
  String get mbtiIncomplete => 'Please complete all MBTI questions';

  @override
  String get interestsRequired => 'Please select at least one interest';

  @override
  String get mainImageRequired => 'Please add a main profile image';

  @override
  String startChatWithPersona(String personaName) {
    return 'بدء محادثة مع $personaName؟';
  }

  @override
  String reengagementNotificationSent(String personaName, String riskPercent) {
    return 'تم إرسال إشعار إعادة المشاركة إلى $personaName (المخاطر: $riskPercent%)';
  }

  @override
  String get noActivePersona => 'لا توجد شخصية نشطة';

  @override
  String get noInternetConnection => 'لا يوجد اتصال بالإنترنت';

  @override
  String get internetRequiredMessage =>
      'يتطلب استخدام SONA اتصالاً بالإنترنت. يرجى التحقق من اتصالك والمحاولة مرة أخرى.';

  @override
  String get retryConnection => 'إعادة المحاولة';

  @override
  String get openNetworkSettings => 'فتح الإعدادات';

  @override
  String get checkingConnection => 'جاري فحص الاتصال...';

  @override
  String get editPersona => 'تحرير الشخصية';

  @override
  String get personaUpdated => 'تم تحديث الشخصية بنجاح';

  @override
  String get cannotEditApprovedPersona => 'لا يمكن تحرير الشخصيات المعتمدة';

  @override
  String get update => 'تحديث';
}
