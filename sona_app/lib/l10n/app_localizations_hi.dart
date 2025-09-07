// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get about => 'के बारे में';

  @override
  String get accountAndProfile => 'खाता और प्रोफ़ाइल जानकारी';

  @override
  String get accountDeletedSuccess => 'खाता सफलतापूर्वक हटाया गया';

  @override
  String get accountDeletionContent =>
      'क्या आप वास्तव में अपना खाता हटाना चाहते हैं?';

  @override
  String get accountDeletionError => 'खाता हटाने में त्रुटि हुई।';

  @override
  String get accountDeletionInfo => 'खाता हटाने की जानकारी';

  @override
  String get accountDeletionTitle => 'खाता हटाएँ';

  @override
  String get accountDeletionWarning1 =>
      'चेतावनी: यह क्रिया पूर्ववत नहीं की जा सकती';

  @override
  String get accountDeletionWarning2 =>
      'आपका सारा डेटा स्थायी रूप से हटा दिया जाएगा';

  @override
  String get accountDeletionWarning3 => 'आप सभी वार्तालापों तक पहुँच खो देंगे';

  @override
  String get accountDeletionWarning4 => 'इसमें सभी खरीदी गई सामग्री शामिल है';

  @override
  String get accountManagement => 'खाता प्रबंधन';

  @override
  String get adaptiveConversationDesc =>
      'आपकी शैली के अनुसार बातचीत के तरीके को अनुकूलित करता है';

  @override
  String get afternoon => 'दोपहर';

  @override
  String get afternoonFatigue => 'दोपहर की थकान';

  @override
  String get ageConfirmation =>
      'मैं 14 वर्ष या उससे अधिक का हूँ और मैंने ऊपर की पुष्टि की है।';

  @override
  String ageRange(int min, int max) {
    return '$min-$max वर्ष';
  }

  @override
  String get ageUnit => 'वर्ष';

  @override
  String get agreeToTerms => 'मैं शर्तों से सहमत हूँ';

  @override
  String get aiDatingQuestion => 'AI के साथ एक विशेष दैनिक जीवन';

  @override
  String get aiPersonaPreferenceDescription =>
      'कृपया AI व्यक्तित्व मिलान के लिए अपनी प्राथमिकताएँ सेट करें';

  @override
  String get all => 'सभी';

  @override
  String get allAgree => 'सभी से सहमत';

  @override
  String get allFeaturesRequired =>
      '※ सेवा प्रदान करने के लिए सभी सुविधाएँ आवश्यक हैं';

  @override
  String get allPersonas => 'सभी व्यक्तित्व';

  @override
  String get allPersonasMatched =>
      'सभी व्यक्तित्व मेल खा गए! उनके साथ चैट करना शुरू करें।';

  @override
  String get allowPermission => 'जारी रखें';

  @override
  String alreadyChattingWith(String name) {
    return 'आप पहले से ही $name के साथ चैट कर रहे हैं!';
  }

  @override
  String get alsoBlockThisAI => 'इस AI को भी ब्लॉक करें';

  @override
  String get angry => 'गुस्सा';

  @override
  String get anonymousLogin => 'गुमनाम लॉगिन';

  @override
  String get anxious => 'चिंतित';

  @override
  String get apiKeyError => 'API कुंजी त्रुटि';

  @override
  String get appName => 'SONA';

  @override
  String get appTagline => 'आपके AI साथी';

  @override
  String get appleLoginCanceled =>
      'Apple लॉगिन रद्द कर दिया गया। कृपया फिर से प्रयास करें।';

  @override
  String get appleLoginError => 'Apple लॉगिन के दौरान त्रुटि हुई।';

  @override
  String get art => 'कला';

  @override
  String get authError => 'प्रमाणीकरण त्रुटि';

  @override
  String get autoTranslate => 'ऑटो ट्रांसलेट';

  @override
  String get autumn => 'शरद ऋतु';

  @override
  String get averageQuality => 'औसत गुणवत्ता';

  @override
  String get averageQualityScore => 'औसत गुणवत्ता स्कोर';

  @override
  String get awkwardExpression => 'अजीब अभिव्यक्ति';

  @override
  String get backButton => 'वापस';

  @override
  String get basicInfo => 'बुनियादी जानकारी';

  @override
  String get basicInfoDescription =>
      'कृपया खाता बनाने के लिए बुनियादी जानकारी दर्ज करें';

  @override
  String get birthDate => 'जन्म तिथि';

  @override
  String get birthDateOptional => 'जन्म तिथि (वैकल्पिक)';

  @override
  String get birthDateRequired => 'जन्म तिथि *';

  @override
  String get blockConfirm => 'क्या आप इस AI को ब्लॉक करना चाहते हैं?';

  @override
  String get blockReason => 'ब्लॉक करने का कारण';

  @override
  String get blockThisAI => 'इस AI को ब्लॉक करें';

  @override
  String blockedAICount(int count) {
    return '$count ब्लॉक किए गए AIs';
  }

  @override
  String get blockedAIs => 'ब्लॉक किए गए AIs';

  @override
  String get blockedAt => 'ब्लॉक किया गया';

  @override
  String get blockedSuccessfully => 'सफलतापूर्वक ब्लॉक किया गया';

  @override
  String get breakfast => 'नाश्ता';

  @override
  String get byErrorType => 'त्रुटि प्रकार द्वारा';

  @override
  String get byPersona => 'पर्सोना द्वारा';

  @override
  String cacheDeleteError(String error) {
    return 'कैश हटाने में त्रुटि: $error';
  }

  @override
  String get cacheDeleted => 'इमेज कैश हटा दिया गया है';

  @override
  String get cafeTerrace => 'कैफे की छत';

  @override
  String get calm => 'शांत';

  @override
  String get cameraPermission => 'कैमरा अनुमति';

  @override
  String get cameraPermissionDesc =>
      'फोटो लेने के लिए हमें कैमरा अनुमति की आवश्यकता है।';

  @override
  String get canChangeInSettings => 'आप इसे बाद में सेटिंग्स में बदल सकते हैं';

  @override
  String get canMeetPreviousPersonas =>
      'आप पहले स्वाइप किए गए व्यक्तित्वों से फिर मिल सकते हैं!';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get changeProfilePhoto => 'प्रोफ़ाइल फोटो बदलें';

  @override
  String get chat => 'चैट';

  @override
  String get chatEndedMessage => 'चैट समाप्त हो गई';

  @override
  String get chatErrorDashboard => 'चैट त्रुटि डैशबोर्ड';

  @override
  String get chatErrorSentSuccessfully => 'चैट त्रुटि सफलतापूर्वक भेजी गई है।';

  @override
  String get chatListTab => 'चैट सूची टैब';

  @override
  String get chats => 'चैट्स';

  @override
  String chattingWithPersonas(int count) {
    return '$count व्यक्तित्वों के साथ चैट कर रहे हैं';
  }

  @override
  String get checkInternetConnection => 'कृपया अपना इंटरनेट कनेक्शन जांचें';

  @override
  String get checkingUserInfo => 'उपयोगकर्ता जानकारी की जांच कर रहे हैं';

  @override
  String get childrensDay => 'बच्चों का दिन';

  @override
  String get chinese => 'चीनी';

  @override
  String get chooseOption => 'कृपया चुनें:';

  @override
  String get christmas => 'क्रिसमस';

  @override
  String get close => 'बंद करें';

  @override
  String get complete => 'पूरा';

  @override
  String get completeSignup => 'साइन अप पूरा करें';

  @override
  String get confirm => 'पुष्टि करें';

  @override
  String get connectingToServer => 'सर्वर से कनेक्ट हो रहा है';

  @override
  String get consultQualityMonitoring => 'परामर्श गुणवत्ता निगरानी';

  @override
  String get continueAsGuest => 'मेहमान के रूप में जारी रखें';

  @override
  String get continueButton => 'जारी रखें';

  @override
  String get continueWithApple => 'एप्पल के साथ जारी रखें';

  @override
  String get continueWithGoogle => 'गूगल के साथ जारी रखें';

  @override
  String get conversationContinuity => 'बातचीत की निरंतरता';

  @override
  String get conversationContinuityDesc =>
      'पिछले वार्तालापों को याद रखें और विषयों को जोड़ें';

  @override
  String conversationWith(String name) {
    return '$name';
  }

  @override
  String get convertToMember => 'साइन अप करें';

  @override
  String get cooking => 'खाना बनाना';

  @override
  String get copyMessage => 'संदेश कॉपी करें';

  @override
  String get copyrightInfringement => 'कॉपीराइट उल्लंघन';

  @override
  String get creatingAccount => 'खाता बना रहे हैं';

  @override
  String get crisisDetected => 'संकट का पता चला';

  @override
  String get culturalIssue => 'सांस्कृतिक मुद्दा';

  @override
  String get current => 'वर्तमान';

  @override
  String get currentCacheSize => 'वर्तमान कैश आकार';

  @override
  String get currentLanguage => 'वर्तमान भाषा';

  @override
  String get cycling => 'साइकिलिंग';

  @override
  String get dailyCare => 'दैनिक देखभाल';

  @override
  String get dailyCareDesc => 'भोजन, नींद, स्वास्थ्य के लिए दैनिक देखभाल संदेश';

  @override
  String get dailyChat => 'दैनिक चैट';

  @override
  String get dailyCheck => 'दैनिक जांच';

  @override
  String get dailyConversation => 'दैनिक बातचीत';

  @override
  String get dailyLimitDescription =>
      'आपने अपने दैनिक संदेश सीमा तक पहुँच गया है';

  @override
  String get dailyLimitTitle => 'दैनिक सीमा पहुँच गई';

  @override
  String get darkMode => 'डार्क मोड';

  @override
  String get darkTheme => 'डार्क मोड';

  @override
  String get darkThemeDesc => 'डार्क थीम का उपयोग करें';

  @override
  String get dataCollection => 'डेटा संग्रह सेटिंग्स';

  @override
  String get datingAdvice => 'डेटिंग सलाह';

  @override
  String get datingDescription =>
      'मैं गहरे विचार साझा करना चाहता हूँ और ईमानदार बातचीत करना चाहता हूँ';

  @override
  String get dawn => 'सुबह';

  @override
  String get day => 'दिन';

  @override
  String get dayAfterTomorrow => 'परसों';

  @override
  String daysAgo(int count, String formatted) {
    return '$count दिन पहले';
  }

  @override
  String daysRemaining(int days) {
    return '$days दिन शेष';
  }

  @override
  String get deepTalk => 'गहरी बातचीत';

  @override
  String get delete => 'हटाएं';

  @override
  String get deleteAccount => 'खाता हटाएं';

  @override
  String get deleteAccountConfirm =>
      'क्या आप सुनिश्चित हैं कि आप अपना खाता हटाना चाहते हैं? यह क्रिया पूर्ववत नहीं की जा सकती।';

  @override
  String get deleteAccountWarning =>
      'क्या आप सुनिश्चित हैं कि आप अपना खाता हटाना चाहते हैं?';

  @override
  String get deleteCache => 'कैश हटाएँ';

  @override
  String get deletingAccount => 'खाता हटाया जा रहा है...';

  @override
  String get depressed => 'उदास';

  @override
  String get describeError => 'समस्या क्या है?';

  @override
  String get detailedReason => 'विस्तृत कारण';

  @override
  String get developRelationshipStep =>
      '3. संबंध विकसित करें: बातचीत के माध्यम से निकटता बनाएं और विशेष संबंध विकसित करें।';

  @override
  String get dinner => 'रात का खाना';

  @override
  String get discardGuestData => 'नया शुरू करें';

  @override
  String get discount20 => '20% की छूट';

  @override
  String get discount30 => '30% की छूट';

  @override
  String get discountAmount => 'बचत';

  @override
  String discountAmountValue(String amount) {
    return 'बचत करें ₩$amount';
  }

  @override
  String get done => 'हो गया';

  @override
  String get downloadingPersonaImages => 'नए पर्सोना चित्र डाउनलोड हो रहे हैं';

  @override
  String get edit => 'संपादित करें';

  @override
  String get editInfo => 'जानकारी संपादित करें';

  @override
  String get editProfile => 'प्रोफ़ाइल संपादित करें';

  @override
  String get effectSound => 'ध्वनि प्रभाव';

  @override
  String get effectSoundDescription => 'ध्वनि प्रभाव चलाएँ';

  @override
  String get email => 'ईमेल';

  @override
  String get emailHint => 'example@email.com';

  @override
  String get emailLabel => 'ईमेल';

  @override
  String get emailRequired => 'ईमेल *';

  @override
  String get emotionAnalysis => 'भावना विश्लेषण';

  @override
  String get emotionAnalysisDesc =>
      'सहानुभूतिपूर्ण प्रतिक्रियाओं के लिए भावनाओं का विश्लेषण करें';

  @override
  String get emotionAngry => 'गुस्सा';

  @override
  String get emotionBasedEncounters =>
      'अपनी भावनाओं के आधार पर व्यक्तित्वों से मिलें';

  @override
  String get emotionCool => 'कूल';

  @override
  String get emotionHappy => 'खुश';

  @override
  String get emotionLove => 'प्यार';

  @override
  String get emotionSad => 'उदास';

  @override
  String get emotionThinking => 'सोचते हुए';

  @override
  String get emotionalSupportDesc =>
      'अपनी चिंताओं को साझा करें और गर्मजोशी से सहारा प्राप्त करें';

  @override
  String get endChat => 'चैट समाप्त करें';

  @override
  String get endTutorial => 'ट्यूटोरियल समाप्त करें';

  @override
  String get endTutorialAndLogin =>
      'क्या आप ट्यूटोरियल समाप्त करके लॉगिन करना चाहते हैं?';

  @override
  String get endTutorialMessage =>
      'क्या आप ट्यूटोरियल समाप्त करके लॉगिन करना चाहते हैं?';

  @override
  String get english => 'अंग्रेजी';

  @override
  String get enterBasicInfo =>
      'कृपया एक खाता बनाने के लिए बुनियादी जानकारी दर्ज करें';

  @override
  String get enterBasicInformation => 'कृपया बुनियादी जानकारी दर्ज करें';

  @override
  String get enterEmail => 'ईमेल दर्ज करें';

  @override
  String get enterNickname => 'कृपया एक उपनाम दर्ज करें';

  @override
  String get enterPassword => 'पासवर्ड दर्ज करें';

  @override
  String get entertainmentAndFunDesc =>
      'मजेदार खेलों और सुखद बातचीत का आनंद लें';

  @override
  String get entertainmentDescription =>
      'मैं मजेदार बातचीत करना चाहता हूँ और अपना समय बिताना चाहता हूँ';

  @override
  String get entertainmentFun => 'मनोरंजन/मज़ा';

  @override
  String get error => 'त्रुटि';

  @override
  String get errorDescription => 'त्रुटि विवरण';

  @override
  String get errorDescriptionHint =>
      'जैसे, अजीब जवाब दिए, वही बात दोहराते हैं, संदर्भ के अनुसार अनुपयुक्त प्रतिक्रियाएँ देते हैं...';

  @override
  String get errorDetails => 'त्रुटि विवरण';

  @override
  String get errorDetailsHint => 'कृपया विस्तार से बताएं कि क्या गलत है';

  @override
  String get errorFrequency24h => 'त्रुटि आवृत्ति (पिछले 24 घंटे)';

  @override
  String get errorMessage => 'त्रुटि संदेश:';

  @override
  String get errorOccurred => 'एक त्रुटि हुई।';

  @override
  String get errorOccurredTryAgain =>
      'एक त्रुटि हुई। कृपया फिर से प्रयास करें।';

  @override
  String get errorSendingFailed => 'त्रुटि भेजने में विफल';

  @override
  String get errorStats => 'त्रुटि सांख्यिकी';

  @override
  String errorWithMessage(String error) {
    return 'त्रुटि हुई: $error';
  }

  @override
  String get evening => 'शाम';

  @override
  String get excited => 'उत्साहित';

  @override
  String get exit => 'बाहर निकलें';

  @override
  String get exitApp => 'ऐप से बाहर निकलें';

  @override
  String get exitConfirmMessage => 'क्या आप वाकई ऐप से बाहर निकलना चाहते हैं?';

  @override
  String get expertPersona => 'विशेषज्ञ व्यक्तित्व';

  @override
  String get expertiseScore => 'विशेषज्ञता स्कोर';

  @override
  String get expired => 'समाप्त';

  @override
  String get explainReportReason => 'कृपया रिपोर्ट कारण को विस्तार से समझाएं';

  @override
  String get fashion => 'फैशन';

  @override
  String get female => 'महिला';

  @override
  String get filter => 'फ़िल्टर';

  @override
  String get firstOccurred => 'पहली बार हुआ:';

  @override
  String get followDeviceLanguage => 'डिवाइस की भाषा सेटिंग का पालन करें';

  @override
  String get forenoon => 'पूर्वाह्न';

  @override
  String get forgotPassword => 'पासवर्ड भूल गए?';

  @override
  String get frequentlyAskedQuestions => 'अक्सर पूछे जाने वाले प्रश्न';

  @override
  String get friday => 'शुक्रवार';

  @override
  String get friendshipDescription =>
      'मैं नए दोस्तों से मिलना चाहता हूँ और बातचीत करना चाहता हूँ';

  @override
  String get funChat => 'मजेदार चैट';

  @override
  String get galleryPermission => 'गैलरी अनुमति';

  @override
  String get galleryPermissionDesc =>
      'फोटो चुनने के लिए हमें गैलरी अनुमति की आवश्यकता है।';

  @override
  String get gaming => 'गेमिंग';

  @override
  String get gender => 'लिंग';

  @override
  String get genderNotSelectedInfo =>
      'यदि लिंग चयनित नहीं है, तो सभी लिंगों के व्यक्तित्व दिखाए जाएंगे';

  @override
  String get genderOptional => 'लिंग (वैकल्पिक)';

  @override
  String get genderPreferenceActive =>
      'आप सभी लिंगों के व्यक्तित्व से मिल सकते हैं';

  @override
  String get genderPreferenceDisabled =>
      'केवल विपरीत लिंग का विकल्प सक्षम करने के लिए अपना लिंग चुनें';

  @override
  String get genderPreferenceInactive =>
      'केवल विपरीत लिंग के व्यक्तित्व दिखाए जाएंगे';

  @override
  String get genderRequired => 'लिंग *';

  @override
  String get genderSelectionInfo =>
      'यदि चयनित नहीं किया गया, तो आप सभी लिंगों के व्यक्तित्व से मिल सकते हैं';

  @override
  String get generalPersona => 'सामान्य व्यक्तित्व';

  @override
  String get goToSettings => 'सेटिंग्स पर जाएं';

  @override
  String get permissionGuideAndroid =>
      'सेटिंग्स > ऐप्स > SONA > अनुमतियां\nकृपया फोटो की अनुमति दें';

  @override
  String get permissionGuideIOS =>
      'सेटिंग्स > SONA > फोटो\nकृपया फोटो एक्सेस की अनुमति दें';

  @override
  String get googleLoginCanceled =>
      'गूगल लॉगिन रद्द कर दिया गया। कृपया फिर से प्रयास करें।';

  @override
  String get googleLoginError => 'गूगल लॉगिन के दौरान त्रुटि हुई।';

  @override
  String get grantPermission => 'जारी रखें';

  @override
  String get guest => 'मेहमान';

  @override
  String get guestDataMigration =>
      'क्या आप साइन अप करते समय अपनी वर्तमान चैट इतिहास को रखना चाहेंगे?';

  @override
  String get guestLimitReached =>
      'मेहमान परीक्षण समाप्त हो गया। असीमित बातचीत के लिए साइन अप करें!';

  @override
  String get guestLoginPromptMessage => 'बातचीत जारी रखने के लिए लॉगिन करें';

  @override
  String get guestMessageExhausted => 'मुफ्त संदेश समाप्त हो गए';

  @override
  String guestMessageRemaining(int count) {
    return '$count मेहमान संदेश शेष हैं';
  }

  @override
  String get guestModeBanner => 'अतिथि मोड';

  @override
  String get guestModeDescription => 'बिना साइन अप किए SONA आजमाएँ';

  @override
  String get guestModeFailedMessage => 'अतिथि मोड शुरू करने में विफल';

  @override
  String get guestModeLimitation => 'कुछ सुविधाएँ अतिथि मोड में सीमित हैं';

  @override
  String get guestModeTitle => 'अतिथि के रूप में आजमाएँ';

  @override
  String get guestModeWarning => 'अतिथि मोड 24 घंटे तक चलता है,';

  @override
  String get guestModeWelcome => 'अतिथि मोड में शुरू करना';

  @override
  String get happy => 'खुश';

  @override
  String get hapticFeedback => 'हैप्टिक फीडबैक';

  @override
  String get harassmentBullying => 'उत्पीड़न/बुलिंग';

  @override
  String get hateSpeech => 'नफरत भरी बातें';

  @override
  String get heartDescription => 'अधिक संदेशों के लिए दिल';

  @override
  String get heartInsufficient => 'पर्याप्त दिल नहीं हैं';

  @override
  String get heartInsufficientPleaseCharge =>
      'पर्याप्त दिल नहीं हैं। कृपया दिल रिचार्ज करें।';

  @override
  String get heartRequired => '1 दिल की आवश्यकता है';

  @override
  String get heartUsageFailed => 'दिल का उपयोग करने में विफल।';

  @override
  String get hearts => 'दिल';

  @override
  String get hearts10 => '10 दिल';

  @override
  String get hearts30 => '30 दिल';

  @override
  String get hearts30Discount => 'बिक्री';

  @override
  String get hearts50 => '50 दिल';

  @override
  String get hearts50Discount => 'बिक्री';

  @override
  String get helloEmoji => 'नमस्ते! 😊';

  @override
  String get help => 'मदद';

  @override
  String get hideOriginalText => 'मूल पाठ छिपाएँ';

  @override
  String get hobbySharing => 'शौक साझा करना';

  @override
  String get hobbyTalk => 'शौक की बातें';

  @override
  String get hours24Ago => '24 घंटे पहले';

  @override
  String hoursAgo(int count, String formatted) {
    return '$count घंटे पहले';
  }

  @override
  String get howToUse => 'SONA का उपयोग कैसे करें';

  @override
  String get imageCacheManagement => 'इमेज कैश प्रबंधन';

  @override
  String get inappropriateContent => 'अनुपयुक्त सामग्री';

  @override
  String get incorrect => 'गलत';

  @override
  String get incorrectPassword => 'गलत पासवर्ड';

  @override
  String get indonesian => 'इंडोनेशियाई';

  @override
  String get inquiries => 'पूछताछ';

  @override
  String get insufficientHearts => 'पर्याप्त दिल नहीं हैं।';

  @override
  String get interestSharing => 'रुचि साझा करना';

  @override
  String get interestSharingDesc => 'साझा रुचियों को खोजें और सिफारिश करें';

  @override
  String get interests => 'रुचियां';

  @override
  String get invalidEmailFormat => 'अमान्य ईमेल प्रारूप';

  @override
  String get invalidEmailFormatError => 'कृपया एक मान्य ईमेल पता दर्ज करें';

  @override
  String isTyping(String name) {
    return '$name टाइप कर रहा है...';
  }

  @override
  String get japanese => 'जापानी';

  @override
  String get joinDate => 'शामिल होने की तिथि';

  @override
  String get justNow => 'अभी';

  @override
  String get keepGuestData => 'चैट इतिहास रखें';

  @override
  String get korean => 'कोरियाई';

  @override
  String get koreanLanguage => 'कोरियाई';

  @override
  String get language => 'भाषा';

  @override
  String get languageDescription =>
      'एआई आपके द्वारा चुनी गई भाषा में उत्तर देगा';

  @override
  String get languageIndicator => 'भाषा';

  @override
  String get languageSettings => 'भाषा सेटिंग्स';

  @override
  String get lastOccurred => 'अंतिम बार हुआ:';

  @override
  String get lastUpdated => 'अंतिम बार अपडेट किया गया';

  @override
  String get lateNight => 'देर रात';

  @override
  String get later => 'बाद में';

  @override
  String get laterButton => 'बाद में';

  @override
  String get leave => 'छोड़ें';

  @override
  String get leaveChatConfirm => 'क्या आप इस चैट को छोड़ना चाहते हैं?';

  @override
  String get leaveChatRoom => 'चैट रूम छोड़ें';

  @override
  String get leaveChatTitle => 'चैट छोड़ें';

  @override
  String get lifeAdvice => 'जीवन सलाह';

  @override
  String get lightTalk => 'हल्की बातचीत';

  @override
  String get lightTheme => 'लाइट मोड';

  @override
  String get lightThemeDesc => 'उज्ज्वल थीम का उपयोग करें';

  @override
  String get loading => 'लोड हो रहा है...';

  @override
  String get loadingData => 'डेटा लोड हो रहा है...';

  @override
  String get loadingProducts => 'उत्पाद लोड हो रहे हैं...';

  @override
  String get loadingProfile => 'प्रोफ़ाइल लोड हो रही है';

  @override
  String get login => 'लॉग इन करें';

  @override
  String get loginButton => 'लॉगिन';

  @override
  String get loginCancelled => 'लॉगिन रद्द किया गया';

  @override
  String get loginComplete => 'लॉगिन पूरा हुआ';

  @override
  String get loginError => 'लॉगिन विफल';

  @override
  String get loginFailed => 'लॉगिन विफल';

  @override
  String get loginFailedTryAgain => 'लॉगिन विफल। कृपया फिर से प्रयास करें।';

  @override
  String get loginRequired => 'लॉगिन आवश्यक है';

  @override
  String get loginRequiredForProfile =>
      'प्रोफ़ाइल देखने और SONA के साथ रिकॉर्ड चेक करने के लिए लॉगिन आवश्यक है';

  @override
  String get loginRequiredService =>
      'इस सेवा का उपयोग करने के लिए लॉगिन आवश्यक है';

  @override
  String get loginRequiredTitle => 'लॉगिन आवश्यक';

  @override
  String get loginSignup => 'लॉगिन/साइन अप';

  @override
  String get loginTab => 'लॉगिन';

  @override
  String get loginTitle => 'लॉगिन';

  @override
  String get loginWithApple => 'एप्पल के साथ लॉगिन';

  @override
  String get loginWithGoogle => 'गूगल के साथ लॉगिन';

  @override
  String get logout => 'लॉग आउट';

  @override
  String get logoutConfirm => 'क्या आप वाकई लॉगआउट करना चाहते हैं?';

  @override
  String get lonelinessRelief => 'अकेलेपन से राहत';

  @override
  String get lonely => 'अकेला';

  @override
  String get lowQualityResponses => 'निम्न गुणवत्ता की प्रतिक्रियाएँ';

  @override
  String get lunch => 'दोपहर का भोजन';

  @override
  String get lunchtime => 'दोपहर का समय';

  @override
  String get mainErrorType => 'मुख्य त्रुटि प्रकार';

  @override
  String get makeFriends => 'मित्र बनाएं';

  @override
  String get male => 'पुरुष';

  @override
  String get manageBlockedAIs => 'अवरुद्ध AIs का प्रबंधन करें';

  @override
  String get managePersonaImageCache => 'पर्सोना इमेज कैश का प्रबंधन करें';

  @override
  String get marketingAgree => 'मार्केटिंग जानकारी के लिए सहमत हों (वैकल्पिक)';

  @override
  String get marketingDescription =>
      'आप कार्यक्रम और लाभ की जानकारी प्राप्त कर सकते हैं';

  @override
  String get matchPersonaStep =>
      '1. पर्सोनाओं का मिलान करें: अपने पसंदीदा AI पर्सोनाओं का चयन करने के लिए बाएं या दाएं स्वाइप करें।';

  @override
  String get matchedPersonas => 'मिलान की गई पर्सोनाएं';

  @override
  String get matchedSona => 'मिलान की गई SONA';

  @override
  String get matching => 'मिलान कर रहा है';

  @override
  String get matchingFailed => 'मिलान विफल हो गया।';

  @override
  String get me => 'Me';

  @override
  String get meetAIPersonas => 'AI व्यक्तित्व से मिलें';

  @override
  String get meetNewPersonas => 'नए व्यक्तित्व से मिलें';

  @override
  String get meetPersonas => 'व्यक्तित्व से मिलें';

  @override
  String get memberBenefits =>
      'साइन अप करने पर 100+ संदेश और 10 दिल प्राप्त करें!';

  @override
  String get memoryAlbum => 'मेमोरी एल्बम';

  @override
  String get memoryAlbumDesc =>
      'विशेष क्षणों को स्वचालित रूप से सहेजें और याद करें';

  @override
  String get messageCopied => 'संदेश कॉपी कर लिया गया';

  @override
  String get messageDeleted => 'संदेश हटा दिया गया';

  @override
  String get messageLimitReset => 'संदेश सीमा मध्यरात्रि पर रीसेट होगी';

  @override
  String get messageSendFailed =>
      'संदेश भेजने में विफल। कृपया फिर से प्रयास करें।';

  @override
  String get messagesRemaining => 'शेष संदेश';

  @override
  String minutesAgo(int count, String formatted) {
    return '$count मिनट पहले';
  }

  @override
  String get missingTranslation => 'अनुवाद गायब है';

  @override
  String get monday => 'सोमवार';

  @override
  String get month => 'महीना';

  @override
  String monthDay(String month, int day) {
    return '$month $day';
  }

  @override
  String get moreButton => 'और';

  @override
  String get morning => 'सुबह';

  @override
  String get mostFrequentError => 'सबसे सामान्य त्रुटि';

  @override
  String get movies => 'फिल्में';

  @override
  String get multilingualChat => 'बहुभाषी चैट';

  @override
  String get music => 'संगीत';

  @override
  String get myGenderSection => 'मेरा लिंग (वैकल्पिक)';

  @override
  String get networkErrorOccurred => 'एक नेटवर्क त्रुटि हुई।';

  @override
  String get newMessage => 'नया संदेश';

  @override
  String newMessageCount(int count) {
    return '$count नए संदेश';
  }

  @override
  String get newMessageNotification => 'नए संदेशों की सूचना दें';

  @override
  String get newMessages => 'नए संदेश';

  @override
  String get newYear => 'नया साल';

  @override
  String get next => 'अगला';

  @override
  String get niceToMeetYou => 'आपसे मिलकर अच्छा लगा!';

  @override
  String get nickname => 'उपनाम';

  @override
  String get nicknameAlreadyUsed => 'यह उपनाम पहले से उपयोग में है';

  @override
  String get nicknameHelperText => '3-10 अक्षर';

  @override
  String get nicknameHint => '3-10 अक्षर';

  @override
  String get nicknameInUse => 'यह उपनाम पहले से उपयोग में है';

  @override
  String get nicknameLabel => 'उपनाम';

  @override
  String get nicknameLengthError => 'उपनाम 3-10 अक्षर होना चाहिए';

  @override
  String get nicknamePlaceholder => 'अपना उपनाम दर्ज करें';

  @override
  String get nicknameRequired => 'उपनाम *';

  @override
  String get night => 'रात';

  @override
  String get no => 'नहीं';

  @override
  String get noBlockedAIs => 'कोई ब्लॉक किए गए एआई नहीं';

  @override
  String get noChatsYet => 'अभी तक कोई चैट नहीं';

  @override
  String get noConversationYet => 'अभी तक कोई बातचीत नहीं';

  @override
  String get noErrorReports => 'कोई त्रुटि रिपोर्ट नहीं।';

  @override
  String get noImageAvailable => 'कोई चित्र उपलब्ध नहीं';

  @override
  String get noMatchedPersonas => 'अभी तक कोई मेल खाने वाले व्यक्तित्व नहीं';

  @override
  String get noMatchedSonas => 'अभी तक कोई मेल खाने वाले SONA नहीं';

  @override
  String get noPersonasAvailable =>
      'कोई व्यक्तित्व उपलब्ध नहीं। कृपया पुनः प्रयास करें।';

  @override
  String get noPersonasToSelect => 'कोई व्यक्तित्व उपलब्ध नहीं';

  @override
  String get noQualityIssues => 'पिछले एक घंटे में कोई गुणवत्ता समस्या नहीं ✅';

  @override
  String get noQualityLogs => 'अभी तक कोई गुणवत्ता लॉग नहीं हैं।';

  @override
  String get noTranslatedMessages => 'अनुवाद करने के लिए कोई संदेश नहीं हैं।';

  @override
  String get notEnoughHearts => 'पर्याप्त दिल नहीं हैं।';

  @override
  String notEnoughHeartsCount(int count) {
    return 'पर्याप्त दिल नहीं हैं। (वर्तमान: $count)';
  }

  @override
  String get notRegistered => 'पंजीकृत नहीं है।';

  @override
  String get notSubscribed => 'सदस्यता नहीं ली है।';

  @override
  String get notificationPermissionDesc =>
      'अलर्ट भेजने के लिए हमें सूचना अनुमति की आवश्यकता है।';

  @override
  String get notificationPermissionRequired => 'सूचना अनुमति आवश्यक है';

  @override
  String get notificationSettings => 'सूचना सेटिंग्स';

  @override
  String get notifications => 'सूचनाएं';

  @override
  String get occurrenceInfo => 'घटना जानकारी:';

  @override
  String get olderChats => 'पुराने';

  @override
  String get onlyOppositeGenderNote =>
      'यदि अनचेक किया गया, तो केवल विपरीत लिंग के व्यक्तित्व दिखाए जाएंगे।';

  @override
  String get openSettings => 'सेटिंग्स खोलें।';

  @override
  String get optional => 'वैकल्पिक';

  @override
  String get or => 'or';

  @override
  String get originalPrice => 'मूल';

  @override
  String get originalText => 'मूल';

  @override
  String get other => 'अन्य';

  @override
  String get otherError => 'अन्य त्रुटि';

  @override
  String get others => 'अन्य';

  @override
  String get ownedHearts => 'स्वामित्व वाले दिल';

  @override
  String get parentsDay => 'माता-पिता का दिन';

  @override
  String get password => 'पासवर्ड';

  @override
  String get passwordConfirmation =>
      'पासवर्ड की पुष्टि करने के लिए पासवर्ड दर्ज करें';

  @override
  String get passwordConfirmationDesc =>
      'कृपया अपने खाते को हटाने के लिए अपना पासवर्ड फिर से दर्ज करें।';

  @override
  String get passwordHint => '6 अक्षर या उससे अधिक';

  @override
  String get passwordLabel => 'पासवर्ड';

  @override
  String get passwordRequired => 'पासवर्ड *';

  @override
  String get passwordResetEmailPrompt =>
      'कृपया पासवर्ड रीसेट करने के लिए अपना ईमेल दर्ज करें';

  @override
  String get passwordResetEmailSent =>
      'पासवर्ड रीसेट करने वाला ईमेल भेजा गया है। कृपया अपने ईमेल की जांच करें।';

  @override
  String get passwordText => 'पासवर्ड';

  @override
  String get passwordTooShort => 'पासवर्ड कम से कम 6 अक्षरों का होना चाहिए';

  @override
  String get permissionDenied => 'अनुमति अस्वीकृत';

  @override
  String permissionDeniedMessage(String permissionName) {
    return '$permissionName अस्वीकृत। कृपया सेटिंग्स से अनुमति दें।';
  }

  @override
  String get permissionDeniedTryLater =>
      'अनुमति अस्वीकृत। कृपया बाद में पुनः प्रयास करें।';

  @override
  String get permissionRequired => 'अनुमति आवश्यक है';

  @override
  String get personaGenderSection => 'पर्सोना लिंग प्राथमिकता';

  @override
  String get personaQualityStats => 'पर्सोना गुणवत्ता सांख्यिकी';

  @override
  String get personalInfoExposure => 'व्यक्तिगत जानकारी का खुलासा';

  @override
  String get personality => 'व्यक्तित्व';

  @override
  String get pets => 'पालतू जानवर';

  @override
  String get photo => 'फोटो';

  @override
  String get photography => 'फोटोग्राफी';

  @override
  String get picnic => 'पिकनिक';

  @override
  String get preferenceSettings => 'प्राथमिकता सेटिंग्स';

  @override
  String get preferredLanguage => 'प्राथमिक भाषा';

  @override
  String get preparingForSleep => 'सोने की तैयारी कर रहे हैं';

  @override
  String get preparingNewMeeting => 'नई बैठक की तैयारी कर रहे हैं';

  @override
  String get preparingPersonaImages => 'पर्सोना छवियों की तैयारी कर रहे हैं';

  @override
  String get preparingPersonas => 'पर्सोना की तैयारी कर रहे हैं';

  @override
  String get preview => 'पूर्वावलोकन';

  @override
  String get previous => 'पिछला';

  @override
  String get privacy => 'गोपनीयता नीति';

  @override
  String get privacyPolicy => 'गोपनीयता नीति';

  @override
  String get privacyPolicyAgreement => 'कृपया गोपनीयता नीति से सहमत हों';

  @override
  String get privacySection1Content =>
      'हम आपकी गोपनीयता की रक्षा के लिए प्रतिबद्ध हैं। यह गोपनीयता नीति बताती है कि हम आपकी जानकारी को कैसे इकट्ठा, उपयोग और सुरक्षित करते हैं जब आप हमारी सेवा का उपयोग करते हैं।';

  @override
  String get privacySection1Title =>
      '1. व्यक्तिगत जानकारी के संग्रह और उपयोग का उद्देश्य';

  @override
  String get privacySection2Content =>
      'हम आपकी द्वारा सीधे प्रदान की गई जानकारी एकत्र करते हैं, जैसे कि जब आप एक खाता बनाते हैं, अपने प्रोफ़ाइल को अपडेट करते हैं, या हमारी सेवाओं का उपयोग करते हैं।';

  @override
  String get privacySection2Title => 'हम कौन सी जानकारी एकत्र करते हैं';

  @override
  String get privacySection3Content =>
      'हम जो जानकारी एकत्र करते हैं, उसका उपयोग अपनी सेवाओं को प्रदान करने, बनाए रखने और सुधारने के लिए तथा आपसे संवाद करने के लिए करते हैं।';

  @override
  String get privacySection3Title =>
      '3. व्यक्तिगत जानकारी का संरक्षण और उपयोग अवधि';

  @override
  String get privacySection4Content =>
      'हम आपकी व्यक्तिगत जानकारी को आपकी सहमति के बिना तीसरे पक्ष को नहीं बेचते, व्यापार करते हैं, या अन्यथा स्थानांतरित करते हैं।';

  @override
  String get privacySection4Title =>
      '4. तीसरे पक्ष को व्यक्तिगत जानकारी का प्रावधान';

  @override
  String get privacySection5Content =>
      'हम आपकी व्यक्तिगत जानकारी को अनधिकृत पहुंच, परिवर्तन, प्रकटीकरण या विनाश से सुरक्षित रखने के लिए उचित सुरक्षा उपाय लागू करते हैं।';

  @override
  String get privacySection5Title =>
      '5. व्यक्तिगत जानकारी के लिए तकनीकी सुरक्षा उपाय';

  @override
  String get privacySection6Content =>
      'हम अपनी सेवाओं को प्रदान करने और कानूनी दायित्वों का पालन करने के लिए आवश्यक समय तक व्यक्तिगत जानकारी को बनाए रखते हैं।';

  @override
  String get privacySection6Title => '6. उपयोगकर्ता अधिकार';

  @override
  String get privacySection7Content =>
      'आपके पास कभी भी अपने खाते की सेटिंग्स के माध्यम से अपनी व्यक्तिगत जानकारी तक पहुंचने, अपडेट करने या उसे हटाने का अधिकार है।';

  @override
  String get privacySection7Title => 'आपके अधिकार';

  @override
  String get privacySection8Content =>
      'यदि आपको इस गोपनीयता नीति के बारे में कोई प्रश्न है, तो कृपया हमसे support@sona.com पर संपर्क करें।';

  @override
  String get privacySection8Title => 'हमसे संपर्क करें';

  @override
  String get privacySettings => 'गोपनीयता सेटिंग्स';

  @override
  String get privacySettingsInfo =>
      'व्यक्तिगत सुविधाओं को बंद करने से वे सेवाएँ अनुपलब्ध हो जाएँगी';

  @override
  String get privacySettingsScreen => 'गोपनीयता सेटिंग्स';

  @override
  String get problemMessage => 'समस्या';

  @override
  String get problemOccurred => 'समस्या हुई';

  @override
  String get profile => 'प्रोफ़ाइल';

  @override
  String get profileEdit => 'प्रोफ़ाइल संपादित करें';

  @override
  String get profileEditLoginRequiredMessage =>
      'अपनी प्रोफ़ाइल संपादित करने के लिए लॉगिन आवश्यक है। क्या आप लॉगिन स्क्रीन पर जाना चाहेंगे?';

  @override
  String get profileInfo => 'प्रोफ़ाइल जानकारी';

  @override
  String get profileInfoDescription =>
      'कृपया अपनी प्रोफ़ाइल फोटो और बुनियादी जानकारी दर्ज करें';

  @override
  String get profileNav => 'प्रोफ़ाइल';

  @override
  String get profilePhoto => 'प्रोफ़ाइल फोटो';

  @override
  String get profilePhotoAndInfo =>
      'कृपया प्रोफ़ाइल फोटो और बुनियादी जानकारी दर्ज करें';

  @override
  String get profilePhotoUpdateFailed => 'प्रोफ़ाइल फ़ोटो अपडेट करने में विफल';

  @override
  String get profilePhotoUpdated => 'प्रोफ़ाइल फ़ोटो अपडेट हो गई';

  @override
  String get profileSettings => 'प्रोफ़ाइल सेटिंग्स';

  @override
  String get profileSetup => 'प्रोफ़ाइल सेटअप';

  @override
  String get profileUpdateFailed => 'प्रोफ़ाइल अपडेट करने में विफल';

  @override
  String get profileUpdated => 'प्रोफ़ाइल सफलतापूर्वक अपडेट हो गई';

  @override
  String get purchaseAndRefundPolicy => 'खरीद और रिफंड नीति';

  @override
  String get purchaseButton => 'खरीदें';

  @override
  String get purchaseConfirm => 'खरीद पुष्टि';

  @override
  String purchaseConfirmContent(String product, String price) {
    return '$price में $product खरीदें?';
  }

  @override
  String purchaseConfirmMessage(
      String title, String price, String description) {
    return '$price में $title की खरीद की पुष्टि करें? $description';
  }

  @override
  String get purchaseFailed => 'खरीद विफल';

  @override
  String get purchaseHeartsOnly => 'दिल खरीदें';

  @override
  String get purchaseMoreHearts => 'बातचीत जारी रखने के लिए दिल खरीदें';

  @override
  String get purchasePending => 'खरीदारी लंबित...';

  @override
  String get purchasePolicy => 'खरीदारी नीति';

  @override
  String get purchaseSection1Content =>
      'हम क्रेडिट कार्ड और डिजिटल वॉलेट सहित विभिन्न भुगतान विधियों को स्वीकार करते हैं।';

  @override
  String get purchaseSection1Title => 'भुगतान विधियाँ';

  @override
  String get purchaseSection2Content =>
      'यदि आपने खरीदी गई वस्तुओं का उपयोग नहीं किया है, तो 14 दिनों के भीतर रिफंड उपलब्ध है।';

  @override
  String get purchaseSection2Title => 'रिफंड नीति';

  @override
  String get purchaseSection3Content =>
      'आप किसी भी समय अपने खाता सेटिंग्स के माध्यम से अपनी सदस्यता रद्द कर सकते हैं।';

  @override
  String get purchaseSection3Title => 'रद्दीकरण';

  @override
  String get purchaseSection4Content =>
      'खरीदारी करके, आप हमारी उपयोग की शर्तों और सेवा समझौते से सहमत होते हैं।';

  @override
  String get purchaseSection4Title => 'उपयोग की शर्तें';

  @override
  String get purchaseSection5Content =>
      'खरीदारी से संबंधित मुद्दों के लिए, कृपया हमारी सहायता टीम से संपर्क करें।';

  @override
  String get purchaseSection5Title => 'समर्थन से संपर्क करें';

  @override
  String get purchaseSection6Content =>
      'सभी खरीद हमारे मानक शर्तों और नियमों के अधीन हैं।';

  @override
  String get purchaseSection6Title => '6. पूछताछ';

  @override
  String get pushNotifications => 'पुश सूचनाएं';

  @override
  String get reading => 'पढ़ाई';

  @override
  String get realtimeQualityLog => 'वास्तविक समय गुणवत्ता लॉग';

  @override
  String get recentConversation => 'हाल की बातचीत:';

  @override
  String get recentLoginRequired => 'सुरक्षा के लिए कृपया फिर से लॉगिन करें';

  @override
  String get referrerEmail => 'संदर्भित करने वाले का ईमेल';

  @override
  String get referrerEmailHelper =>
      'वैकल्पिक: जिस व्यक्ति ने आपको संदर्भित किया उसका ईमेल';

  @override
  String get referrerEmailLabel => 'संदर्भित करने वाले का ईमेल (वैकल्पिक)';

  @override
  String get refresh => 'रीफ्रेश करें';

  @override
  String refreshComplete(int count) {
    return 'रिफ्रेश पूरा! $count मेल खाते व्यक्तित्व';
  }

  @override
  String get refreshFailed => 'रिफ्रेश विफल हुआ';

  @override
  String get refreshingChatList => 'चैट सूची को ताज़ा किया जा रहा है...';

  @override
  String get relatedFAQ => 'संबंधित FAQ';

  @override
  String get report => 'रिपोर्ट करें';

  @override
  String get reportAI => 'रिपोर्ट करें';

  @override
  String get reportAIDescription =>
      'यदि AI ने आपको असहज किया, तो कृपया समस्या का विवरण दें।';

  @override
  String get reportAITitle => 'AI बातचीत की रिपोर्ट करें';

  @override
  String get reportAndBlock => 'रिपोर्ट और ब्लॉक करें';

  @override
  String get reportAndBlockDescription =>
      'आप इस AI के अनुचित व्यवहार की रिपोर्ट और ब्लॉक कर सकते हैं';

  @override
  String get reportChatError => 'चैट त्रुटि की रिपोर्ट करें';

  @override
  String reportError(String error) {
    return 'रिपोर्ट करते समय त्रुटि हुई: $error';
  }

  @override
  String get reportFailed => 'रिपोर्ट विफल';

  @override
  String get reportSubmitted =>
      'रिपोर्ट जमा कर दी गई है। हम इसकी समीक्षा करेंगे और कार्रवाई करेंगे।';

  @override
  String get reportSubmittedSuccess => 'आपकी रिपोर्ट जमा कर दी गई है। धन्यवाद!';

  @override
  String get requestLimit => 'अनुरोध सीमा';

  @override
  String get required => '[आवश्यक]';

  @override
  String get requiredTermsAgreement => 'कृपया शर्तों से सहमत हों';

  @override
  String get restartConversation => 'बातचीत पुनः प्रारंभ करें';

  @override
  String restartConversationQuestion(String name) {
    return 'क्या आप $name के साथ बातचीत पुनः प्रारंभ करना चाहेंगे?';
  }

  @override
  String restartConversationWithName(String name) {
    return '$name के साथ बातचीत पुनः प्रारंभ की जा रही है!';
  }

  @override
  String get retry => 'फिर से कोशिश करें';

  @override
  String get retryButton => 'पुनः प्रयास करें';

  @override
  String get sad => 'उदास';

  @override
  String get saturday => 'शनिवार';

  @override
  String get save => 'सहेजें';

  @override
  String get search => 'खोजें';

  @override
  String get searchFAQ => 'FAQ खोजें...';

  @override
  String get searchResults => 'खोज परिणाम';

  @override
  String get selectEmotion => 'भावना चुनें';

  @override
  String get selectErrorType => 'त्रुटि प्रकार चुनें';

  @override
  String get selectFeeling => 'भावना चुनें';

  @override
  String get selectGender => 'लिंग चुनें';

  @override
  String get selectInterests => 'कृपया अपनी रुचियाँ चुनें (कम से कम 1)';

  @override
  String get selectLanguage => 'भाषा चुनें';

  @override
  String get selectPersona => 'एक व्यक्तित्व चुनें';

  @override
  String get selectPersonaPlease => 'कृपया एक व्यक्तित्व चुनें।';

  @override
  String get selectPreferredMbti =>
      'यदि आप विशेष MBTI प्रकार के व्यक्तित्व पसंद करते हैं, तो कृपया चुनें';

  @override
  String get selectProblematicMessage => 'समस्या वाली संदेश चुनें (वैकल्पिक)';

  @override
  String get chatErrorAnalysisInfo =>
      'पिछली 10 बातचीत का विश्लेषण किया जा रहा है।';

  @override
  String get whatWasAwkward => 'क्या अजीब लगा?';

  @override
  String get errorExampleHint => 'उदाहरण: अजीब बोलने का तरीका (~nya अंत)...';

  @override
  String get selectReportReason => 'रिपोर्ट का कारण चुनें';

  @override
  String get selectTheme => 'थीम चुनें';

  @override
  String get selectTranslationError =>
      'कृपया एक संदेश चुनें जिसमें अनुवाद की गलती हो';

  @override
  String get selectUsagePurpose =>
      'कृपया SONA का उपयोग करने का अपना उद्देश्य चुनें';

  @override
  String get selfIntroduction => 'परिचय (वैकल्पिक)';

  @override
  String get selfIntroductionHint => 'अपने बारे में एक संक्षिप्त परिचय लिखें';

  @override
  String get send => 'भेजें';

  @override
  String get sendChatError => 'चैट भेजने में त्रुटि';

  @override
  String get sendFirstMessage => 'अपना पहला संदेश भेजें';

  @override
  String get sendReport => 'रिपोर्ट भेजें';

  @override
  String get sendingEmail => 'ईमेल भेजा जा रहा है...';

  @override
  String get seoul => 'सियोल';

  @override
  String get serverErrorDashboard => 'सर्वर त्रुटि';

  @override
  String get serviceTermsAgreement => 'कृपया सेवा की शर्तों से सहमत हों';

  @override
  String get sessionExpired => 'सत्र समाप्त हो गया';

  @override
  String get setAppInterfaceLanguage => 'ऐप इंटरफेस भाषा सेट करें';

  @override
  String get setNow => 'अभी सेट करें';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get sexualContent => 'यौन सामग्री';

  @override
  String get showAllGenderPersonas => 'सभी लिंग व्यक्तित्व दिखाएँ';

  @override
  String get showAllGendersOption => 'सभी लिंग दिखाएँ';

  @override
  String get showOppositeGenderOnly =>
      'यदि अनचेक किया गया, तो केवल विपरीत लिंग के व्यक्तित्व दिखाए जाएंगे';

  @override
  String get showOriginalText => 'मूल दिखाएँ';

  @override
  String get signUp => 'साइन अप करें';

  @override
  String get signUpFromGuest =>
      'सभी सुविधाओं तक पहुँचने के लिए अभी साइन अप करें!';

  @override
  String get signup => 'साइन अप करें';

  @override
  String get signupComplete => 'साइन अप पूरा';

  @override
  String get signupTab => 'साइन अप';

  @override
  String get simpleInfoRequired => 'सरल जानकारी आवश्यक है';

  @override
  String get skip => 'छोड़ें';

  @override
  String get sonaFriend => 'SONA मित्र';

  @override
  String get sonaPrivacyPolicy => 'SONA गोपनीयता नीति';

  @override
  String get sonaPurchasePolicy => 'SONA खरीद नीति';

  @override
  String get sonaTermsOfService => 'SONA सेवा की शर्तें';

  @override
  String get sonaUsagePurpose =>
      'कृपया SONA का उपयोग करने का अपना उद्देश्य चुनें';

  @override
  String get sorryNotHelpful => 'खेद है, यह सहायक नहीं था';

  @override
  String get sort => 'क्रमबद्ध करें';

  @override
  String get soundSettings => 'ध्वनि सेटिंग्स';

  @override
  String get spamAdvertising => 'स्पैम/विज्ञापन';

  @override
  String get spanish => 'स्पेनिश';

  @override
  String get specialRelationshipDesc =>
      'एक-दूसरे को समझें और गहरे रिश्ते बनाएं';

  @override
  String get sports => 'खेल';

  @override
  String get spring => 'वसंत';

  @override
  String get startChat => 'चैट शुरू करें';

  @override
  String get startChatButton => 'चैट शुरू करें';

  @override
  String get startConversation => 'बातचीत शुरू करें';

  @override
  String get startConversationLikeAFriend =>
      'SONA के साथ दोस्त की तरह बातचीत शुरू करें';

  @override
  String get startConversationStep =>
      '2. बातचीत शुरू करें: मिलान किए गए व्यक्तित्वों के साथ स्वतंत्र रूप से चैट करें।';

  @override
  String get startConversationWithSona =>
      'SONA के साथ दोस्त की तरह चैट करना शुरू करें!';

  @override
  String get startWithEmail => 'ईमेल से शुरू करें';

  @override
  String get startWithGoogle => 'गूगल से शुरू करें';

  @override
  String get startingApp => 'ऐप शुरू हो रहा है';

  @override
  String get storageManagement => 'स्टोरेज प्रबंधन';

  @override
  String get store => 'स्टोर';

  @override
  String get storeConnectionError => 'स्टोर से कनेक्ट नहीं हो सका';

  @override
  String get storeLoginRequiredMessage =>
      'स्टोर का उपयोग करने के लिए लॉगिन आवश्यक है।';

  @override
  String get storeNotAvailable => 'स्टोर उपलब्ध नहीं है';

  @override
  String get storyEvent => 'कहानी कार्यक्रम';

  @override
  String get stressed => 'तनावग्रस्त';

  @override
  String get submitReport => 'रिपोर्ट सबमिट करें';

  @override
  String get subscriptionStatus => 'सदस्यता स्थिति';

  @override
  String get subtleVibrationOnTouch => 'स्पर्श पर हल्की कंपन';

  @override
  String get summer => 'गर्मी';

  @override
  String get sunday => 'रविवार';

  @override
  String get swipeAnyDirection => 'किसी भी दिशा में स्वाइप करें';

  @override
  String get swipeDownToClose => 'बंद करने के लिए नीचे स्वाइप करें';

  @override
  String get systemTheme => 'सिस्टम का पालन करें';

  @override
  String get systemThemeDesc =>
      'डिवाइस के डार्क मोड सेटिंग्स के आधार पर स्वचालित रूप से बदलता है';

  @override
  String get tapBottomForDetails =>
      'विवरण देखने के लिए नीचे के क्षेत्र पर टैप करें';

  @override
  String get tapForDetails => 'विवरण के लिए नीचे के क्षेत्र पर टैप करें';

  @override
  String get tapToSwipePhotos => 'फोटो स्वाइप करने के लिए टैप करें';

  @override
  String get teachersDay => 'शिक्षक दिवस';

  @override
  String get technicalError => 'तकनीकी त्रुटि';

  @override
  String get technology => 'प्रौद्योगिकी';

  @override
  String get terms => 'सेवा की शर्तें';

  @override
  String get termsAgreement => 'शर्तों पर सहमति';

  @override
  String get termsAgreementDescription =>
      'कृपया सेवा का उपयोग करने के लिए शर्तों पर सहमति दें';

  @override
  String get termsOfService => 'सेवा की शर्तें';

  @override
  String get termsSection10Content =>
      'हम उपयोगकर्ताओं को सूचित करते हुए इन शर्तों में किसी भी समय संशोधन करने का अधिकार सुरक्षित रखते हैं।';

  @override
  String get termsSection10Title => 'अनुच्छेद 10 (विवाद समाधान)';

  @override
  String get termsSection11Content =>
      'ये शर्तें उस क्षेत्राधिकार के कानूनों द्वारा संचालित होंगी जिसमें हम कार्य करते हैं।';

  @override
  String get termsSection11Title => 'अनुच्छेद 11 (एआई सेवा विशेष प्रावधान)';

  @override
  String get termsSection12Content =>
      'यदि इन शर्तों का कोई प्रावधान लागू नहीं किया जा सकता है, तो शेष प्रावधान पूरी ताकत और प्रभाव में बने रहेंगे।';

  @override
  String get termsSection12Title => 'अनुच्छेद 12 (डेटा संग्रह और उपयोग)';

  @override
  String get termsSection1Content =>
      'ये शर्तें और नियम SONA (जिसे आगे \"कंपनी\" कहा जाएगा) और उपयोगकर्ताओं के बीच एआई व्यक्तित्व वार्तालाप मिलान सेवा (जिसे आगे \"सेवा\" कहा जाएगा) के उपयोग के संबंध में अधिकारों, दायित्वों और जिम्मेदारियों को परिभाषित करने का उद्देश्य रखते हैं।';

  @override
  String get termsSection1Title => 'अनुच्छेद 1 (उद्देश्य)';

  @override
  String get termsSection2Content =>
      'हमारी सेवा का उपयोग करके, आप इन सेवा की शर्तों और हमारी गोपनीयता नीति के तहत बंधने के लिए सहमत होते हैं।';

  @override
  String get termsSection2Title => 'अनुच्छेद 2 (परिभाषाएँ)';

  @override
  String get termsSection3Content =>
      'हमारी सेवा का उपयोग करने के लिए आपकी उम्र कम से कम 13 वर्ष होनी चाहिए।';

  @override
  String get termsSection3Title => 'अनुच्छेद 3 (शर्तों का प्रभाव और संशोधन)';

  @override
  String get termsSection4Content =>
      'आपके खाते और पासवर्ड की गोपनीयता बनाए रखने की जिम्मेदारी आपकी है।';

  @override
  String get termsSection4Title => 'अनुच्छेद 4 (सेवा का प्रावधान)';

  @override
  String get termsSection5Content =>
      'आप सहमत हैं कि हमारी सेवा का उपयोग किसी भी अवैध या अनधिकृत उद्देश्य के लिए नहीं करेंगे।';

  @override
  String get termsSection5Title => 'अनुच्छेद 5 (सदस्यता पंजीकरण)';

  @override
  String get termsSection6Content =>
      'हम इन शर्तों का उल्लंघन करने पर आपके खाते को समाप्त या निलंबित करने का अधिकार सुरक्षित रखते हैं।';

  @override
  String get termsSection6Title => 'अनुच्छेद 6 (उपयोगकर्ता की जिम्मेदारियाँ)';

  @override
  String get termsSection7Content =>
      'यदि उपयोगकर्ता इन शर्तों की जिम्मेदारियों का उल्लंघन करते हैं या सामान्य सेवा संचालन में हस्तक्षेप करते हैं, तो कंपनी चेतावनियों, अस्थायी निलंबन या स्थायी निलंबन के माध्यम से सेवा के उपयोग को धीरे-धीरे प्रतिबंधित कर सकती है।';

  @override
  String get termsSection7Title => 'अनुच्छेद 7 (सेवा उपयोग प्रतिबंध)';

  @override
  String get termsSection8Content =>
      'हम आपकी सेवा के उपयोग से उत्पन्न किसी भी अप्रत्यक्ष, आकस्मिक, या परिणामी क्षति के लिए जिम्मेदार नहीं हैं।';

  @override
  String get termsSection8Title => 'अनुच्छेद 8 (सेवा में बाधा)';

  @override
  String get termsSection9Content =>
      'हमारी सेवा पर उपलब्ध सभी सामग्री और सामग्री बौद्धिक संपदा अधिकारों द्वारा सुरक्षित हैं।';

  @override
  String get termsSection9Title => 'अनुच्छेद 9 (अस्वीकृति)';

  @override
  String get termsSupplementary => 'पूरक शर्तें';

  @override
  String get thai => 'थाई';

  @override
  String get thanksFeedback => 'आपकी प्रतिक्रिया के लिए धन्यवाद!';

  @override
  String get theme => 'थीम';

  @override
  String get themeDescription =>
      'आप ऐप की उपस्थिति को अपनी पसंद के अनुसार अनुकूलित कर सकते हैं';

  @override
  String get themeSettings => 'थीम सेटिंग्स';

  @override
  String get thursday => 'गुरुवार';

  @override
  String get timeout => 'टाइमआउट';

  @override
  String get tired => 'थका हुआ';

  @override
  String get today => 'आज';

  @override
  String get todayChats => 'आज';

  @override
  String get todayText => 'आज';

  @override
  String get tomorrowText => 'कल';

  @override
  String get totalConsultSessions => 'कुल परामर्श सत्र';

  @override
  String get totalErrorCount => 'कुल त्रुटि संख्या';

  @override
  String get totalLikes => 'कुल लाइक्स';

  @override
  String totalOccurrences(Object count) {
    return 'कुल $count घटनाएँ';
  }

  @override
  String get totalResponses => 'कुल प्रतिक्रियाएँ';

  @override
  String get translatedFrom => 'अनुवादित';

  @override
  String get translatedText => 'अनुवाद';

  @override
  String get translationError => 'अनुवाद त्रुटि';

  @override
  String get translationErrorDescription =>
      'कृपया गलत अनुवाद या अजीब अभिव्यक्तियों की रिपोर्ट करें';

  @override
  String get translationErrorReported =>
      'अनुवाद त्रुटि रिपोर्ट की गई। धन्यवाद!';

  @override
  String get translationNote => '※ एआई अनुवाद सही नहीं हो सकता';

  @override
  String get translationQuality => 'अनुवाद गुणवत्ता';

  @override
  String get translationSettings => 'अनुवाद सेटिंग्स';

  @override
  String get travel => 'यात्रा';

  @override
  String get tuesday => 'मंगलवार';

  @override
  String get tutorialAccount => 'ट्यूटोरियल खाता';

  @override
  String get tutorialWelcomeDescription =>
      'एआई व्यक्तित्वों के साथ विशेष संबंध बनाएं।';

  @override
  String get tutorialWelcomeTitle => 'SONA में आपका स्वागत है!';

  @override
  String get typeMessage => 'एक संदेश टाइप करें...';

  @override
  String get unblock => 'अनब्लॉक करें';

  @override
  String get unblockFailed => 'अनब्लॉक करने में विफल';

  @override
  String unblockPersonaConfirm(String name) {
    return '$name को अनब्लॉक करें?';
  }

  @override
  String get unblockedSuccessfully => 'सफलतापूर्वक अनब्लॉक किया गया';

  @override
  String get unexpectedLoginError => 'लॉगिन के दौरान एक अप्रत्याशित त्रुटि हुई';

  @override
  String get unknown => 'अज्ञात';

  @override
  String get unknownError => 'अज्ञात त्रुटि';

  @override
  String get unlimitedMessages => 'असीमित';

  @override
  String get unsendMessage => 'संदेश वापस लें';

  @override
  String get usagePurpose => 'उपयोग का उद्देश्य';

  @override
  String get useOneHeart => '1 दिल का उपयोग करें';

  @override
  String get useSystemLanguage => 'सिस्टम भाषा का उपयोग करें';

  @override
  String get user => 'उपयोगकर्ता:';

  @override
  String get userMessage => 'उपयोगकर्ता संदेश:';

  @override
  String get userNotFound => 'उपयोगकर्ता नहीं मिला';

  @override
  String get valentinesDay => 'वैलेंटाइन डे';

  @override
  String get verifyingAuth => 'प्रमाणीकरण की जांच की जा रही है';

  @override
  String get version => 'संस्करण';

  @override
  String get vietnamese => 'वियतनामी';

  @override
  String get violentContent => 'हिंसक सामग्री';

  @override
  String get voiceMessage => '🎤 वॉयस संदेश';

  @override
  String waitingForChat(String name) {
    return '$name चैट करने का इंतज़ार कर रहा है।';
  }

  @override
  String get walk => 'चलना';

  @override
  String get wasHelpful => 'क्या यह मददगार था?';

  @override
  String get weatherClear => 'साफ';

  @override
  String get weatherCloudy => 'बादलदार';

  @override
  String get weatherContext => 'मौसम संदर्भ';

  @override
  String get weatherContextDesc =>
      'मौसम के आधार पर बातचीत का संदर्भ प्रदान करें';

  @override
  String get weatherDrizzle => 'बूंदाबांदी';

  @override
  String get weatherFog => 'कोहरा';

  @override
  String get weatherMist => 'धुंध';

  @override
  String get weatherRain => 'बारिश';

  @override
  String get weatherRainy => 'बारिश वाला';

  @override
  String get weatherSnow => 'बर्फ';

  @override
  String get weatherSnowy => 'बर्फीला';

  @override
  String get weatherThunderstorm => 'गरज-चमक';

  @override
  String get wednesday => 'बुधवार';

  @override
  String get weekdays => 'रवि,सोम,मंगल,बुध,गुरु,शुक्र,शनिवार';

  @override
  String get welcomeMessage => 'स्वागत है💕';

  @override
  String get whatTopicsToTalk => 'आप किस विषय पर बात करना चाहेंगे? (वैकल्पिक)';

  @override
  String get whiteDay => 'व्हाइट डे';

  @override
  String get winter => 'सर्दी';

  @override
  String get wrongTranslation => 'गलत अनुवाद';

  @override
  String get year => 'वर्ष';

  @override
  String get yearEnd => 'वर्ष समाप्ति';

  @override
  String get yes => 'हाँ';

  @override
  String get yesterday => 'कल';

  @override
  String get yesterdayChats => 'कल';

  @override
  String get you => 'आप';

  @override
  String get loadingPersonaData => 'पर्सोना डेटा लोड हो रहा है';

  @override
  String get checkingMatchedPersonas => 'मैच किए गए पर्सोना की जांच हो रही है';

  @override
  String get preparingImages => 'छवियों को तैयार कर रहे हैं';

  @override
  String get finalPreparation => 'अंतिम तैयारी';

  @override
  String get editProfileSubtitle => 'लिंग, जन्मतिथि और परिचय संपादित करें';

  @override
  String get systemThemeName => 'सिस्टम';

  @override
  String get lightThemeName => 'लाइट';

  @override
  String get darkThemeName => 'डार्क';

  @override
  String get alwaysShowTranslationOn => 'हमेशा अनुवाद दिखाएं';

  @override
  String get alwaysShowTranslationOff => 'स्वचालित अनुवाद छुपाएं';

  @override
  String get translationErrorAnalysisInfo =>
      'हम चयनित संदेश और इसके अनुवाद का विश्लेषण करेंगे।';

  @override
  String get whatWasWrongWithTranslation => 'अनुवाद में क्या गलत था?';

  @override
  String get translationErrorHint =>
      'उदाहरण: गलत अर्थ, अप्राकृतिक अभिव्यक्ति, गलत संदर्भ...';

  @override
  String get pleaseSelectMessage => 'कृपया पहले एक संदेश चुनें';

  @override
  String get myPersonas => 'मेरे व्यक्तित्व';

  @override
  String get createPersona => 'व्यक्तित्व बनाएं';

  @override
  String get tellUsAboutYourPersona => 'अपने व्यक्तित्व के बारे में बताएं';

  @override
  String get enterPersonaName => 'व्यक्तित्व का नाम दर्ज करें';

  @override
  String get describeYourPersona => 'संक्षेप में अपने व्यक्तित्व का वर्णन करें';

  @override
  String get profileImage => 'प्रोफाइल चित्र';

  @override
  String get uploadPersonaImages => 'अपने व्यक्तित्व के लिए चित्र अपलोड करें';

  @override
  String get mainImage => 'मुख्य चित्र';

  @override
  String get tapToUpload => 'अपलोड करने के लिए टैप करें';

  @override
  String get additionalImages => 'अतिरिक्त चित्र';

  @override
  String get addImage => 'चित्र जोड़ें';

  @override
  String get mbtiQuestion => 'व्यक्तित्व प्रश्न';

  @override
  String get mbtiComplete => 'व्यक्तित्व परीक्षा पूर्ण!';

  @override
  String get mbtiTest => 'MBTI परीक्षण';

  @override
  String get mbtiStepDescription =>
      'आइए निर्धारित करें कि आपके व्यक्तित्व की क्या विशेषता होनी चाहिए। उनके चरित्र को आकार देने के लिए प्रश्नों का उत्तर दें।';

  @override
  String get startTest => 'परीक्षण शुरू करें';

  @override
  String get personalitySettings => 'व्यक्तित्व सेटिंग्स';

  @override
  String get speechStyle => 'बोलचाल की शैली';

  @override
  String get conversationStyle => 'बातचीत की शैली';

  @override
  String get shareWithCommunity => 'समुदाय के साथ साझा करें';

  @override
  String get shareDescription =>
      'आपका व्यक्तित्व अनुमोदन के बाद अन्य उपयोगकर्ताओं के साथ साझा किया जाएगा';

  @override
  String get sharePersona => 'व्यक्तित्व साझा करें';

  @override
  String get willBeSharedAfterApproval =>
      'व्यवस्थापक की अनुमति के बाद साझा किया जाएगा';

  @override
  String get privatePersonaDescription =>
      'केवल आप इस व्यक्तित्व को देख सकते हैं';

  @override
  String get create => 'बनाएं';

  @override
  String get personaCreated => 'व्यक्तित्व सफलतापूर्वक बनाया गया!';

  @override
  String get createFailed => 'व्यक्तित्व बनाने में विफल';

  @override
  String get pendingApproval => 'अनुमोदन प्रतीक्षित';

  @override
  String get approved => 'अनुमोदित';

  @override
  String get privatePersona => 'निजी';

  @override
  String get noPersonasYet => 'अभी तक कोई व्यक्तित्व नहीं';

  @override
  String get createYourFirstPersona =>
      'अपना पहला व्यक्तित्व बनाएं और यात्रा शुरू करें';

  @override
  String get deletePersona => 'व्यक्तित्व हटाएं';

  @override
  String get deletePersonaConfirm =>
      'क्या आप वाकई इस व्यक्तित्व को हटाना चाहते हैं?';

  @override
  String get personaDeleted => 'व्यक्तित्व सफलतापूर्वक हटाया गया';

  @override
  String get deleteFailed => 'हटाने में विफल';

  @override
  String get personaLimitReached => 'आप 3 व्यक्तित्वों की सीमा तक पहुंच गए हैं';

  @override
  String get personaName => 'नाम';

  @override
  String get personaAge => 'आयु';

  @override
  String get personaDescription => 'विवरण';

  @override
  String get personaNameHint => 'व्यक्तित्व का नाम दर्ज करें';

  @override
  String get personaDescriptionHint => 'व्यक्तित्व का वर्णन करें';

  @override
  String get loginRequiredContent => 'जारी रखने के लिए कृपया लॉगिन करें';

  @override
  String get reportErrorButton => 'त्रुटि रिपोर्ट करें';

  @override
  String get speechStyleFriendly => 'मित्रवत';

  @override
  String get speechStylePolite => 'विनम्र';

  @override
  String get speechStyleChic => 'स्टाइलिश';

  @override
  String get speechStyleLively => 'जीवंत';

  @override
  String get conversationStyleTalkative => 'बातूनी';

  @override
  String get conversationStyleQuiet => 'शांत';

  @override
  String get conversationStyleEmpathetic => 'सहानुभूतिपूर्ण';

  @override
  String get conversationStyleLogical => 'तार्किक';

  @override
  String get interestMusic => 'संगीत';

  @override
  String get interestMovies => 'फिल्में';

  @override
  String get interestReading => 'पढ़ना';

  @override
  String get interestTravel => 'यात्रा';

  @override
  String get interestExercise => 'व्यायाम';

  @override
  String get interestGaming => 'गेमिंग';

  @override
  String get interestCooking => 'खाना बनाना';

  @override
  String get interestFashion => 'फैशन';

  @override
  String get interestArt => 'कला';

  @override
  String get interestPhotography => 'फोटोग्राफी';

  @override
  String get interestTechnology => 'प्रौद्योगिकी';

  @override
  String get interestScience => 'विज्ञान';

  @override
  String get interestHistory => 'इतिहास';

  @override
  String get interestPhilosophy => 'दर्शन';

  @override
  String get interestPolitics => 'राजनीति';

  @override
  String get interestEconomy => 'अर्थव्यवस्था';

  @override
  String get interestSports => 'खेल';

  @override
  String get interestAnimation => 'एनिमेशन';

  @override
  String get interestKpop => 'K-POP';

  @override
  String get interestDrama => 'नाटक';

  @override
  String get imageOptionalR2 =>
      'छवियां वैकल्पिक हैं। केवल R2 कॉन्फ़िगर होने पर ही अपलोड की जाएंगी।';

  @override
  String get networkErrorCheckConnection =>
      'नेटवर्क त्रुटि: कृपया अपना इंटरनेट कनेक्शन जांचें';

  @override
  String get maxFiveItems => 'अधिकतम 5 आइटम';

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
    return '$personaName के साथ बातचीत शुरू करें?';
  }

  @override
  String reengagementNotificationSent(String personaName, String riskPercent) {
    return '$personaName को पुनः जुड़ाव सूचना भेजी गई (जोखिम: $riskPercent%)';
  }

  @override
  String get noActivePersona => 'कोई सक्रिय व्यक्तित्व नहीं';
}
