// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Tagalog (`tl`).
class AppLocalizationsTl extends AppLocalizations {
  AppLocalizationsTl([String locale = 'tl']) : super(locale);

  @override
  String get about => 'Tungkol';

  @override
  String get accountAndProfile => 'Impormasyon sa Account at Profile';

  @override
  String get accountDeletedSuccess => 'Matagumpay na na-delete ang account';

  @override
  String get accountDeletionContent =>
      'Sigurado ka bang nais mong i-delete ang iyong account?';

  @override
  String get accountDeletionError =>
      'Nagkaroon ng error habang nagde-delete ng account.';

  @override
  String get accountDeletionInfo => 'Impormasyon sa Pag-delete ng Account';

  @override
  String get accountDeletionTitle => 'I-delete ang Account';

  @override
  String get accountDeletionWarning1 =>
      'Babala: Ang aksyong ito ay hindi maibabalik';

  @override
  String get accountDeletionWarning2 =>
      'Lahat ng iyong data ay permanenteng mabubura';

  @override
  String get accountDeletionWarning3 =>
      'Mawawalan ka ng access sa lahat ng pag-uusap';

  @override
  String get accountDeletionWarning4 =>
      'Kasama dito ang lahat ng biniling nilalaman';

  @override
  String get accountManagement => 'Pamamahala ng Account';

  @override
  String get adaptiveConversationDesc =>
      'Inaangkop ang estilo ng pag-uusap upang umangkop sa iyo';

  @override
  String get afternoon => 'Hapon';

  @override
  String get afternoonFatigue => 'Pagkapagod sa Hapon';

  @override
  String get ageConfirmation =>
      'Ako ay 14 na taong gulang o mas matanda at nakumpirma ang nasa itaas.';

  @override
  String ageRange(int min, int max) {
    return '$min-$max taong gulang';
  }

  @override
  String get ageUnit => 'taong gulang';

  @override
  String get agreeToTerms => 'Sumasang-ayon ako sa mga tuntunin';

  @override
  String get aiDatingQuestion =>
      'Isang espesyal na pang-araw-araw na buhay kasama ang AI';

  @override
  String get aiPersonaPreferenceDescription =>
      'Mangyaring itakda ang iyong mga kagustuhan para sa pagtutugma ng AI persona';

  @override
  String get all => 'Lahat';

  @override
  String get allAgree => 'Sumasang-ayon sa Lahat';

  @override
  String get allFeaturesRequired =>
      '※ Lahat ng tampok ay kinakailangan para sa pagbibigay ng serbisyo';

  @override
  String get allPersonas => 'Lahat ng Persona';

  @override
  String get allPersonasMatched =>
      'Lahat ng persona ay naitugma! Simulan ang pakikipag-chat sa kanila.';

  @override
  String get allowPermission => 'Magpatuloy';

  @override
  String alreadyChattingWith(String name) {
    return 'Nakikipag-chat na kay $name!';
  }

  @override
  String get alsoBlockThisAI => 'I-block din ang AI na ito';

  @override
  String get angry => 'Galit';

  @override
  String get anonymousLogin => 'Walang pangalan na pag-login';

  @override
  String get anxious => 'Nababalisa';

  @override
  String get apiKeyError => 'Error sa API Key';

  @override
  String get appName => 'SONA';

  @override
  String get appTagline => 'Ang iyong mga AI kasama';

  @override
  String get appleLoginCanceled =>
      'Nakansela ang pag-login sa Apple. Pakisubukan muli.';

  @override
  String get appleLoginError => 'Nagkaroon ng error sa pag-login sa Apple.';

  @override
  String get art => 'Sining';

  @override
  String get authError => 'Error sa Pagpapatotoo';

  @override
  String get autoTranslate => 'Awtomatikong Isasalin';

  @override
  String get autumn => 'Taglagas';

  @override
  String get averageQuality => 'Karaniwang Kalidad';

  @override
  String get averageQualityScore => 'Karaniwang Iskor ng Kalidad';

  @override
  String get awkwardExpression => 'Awkward Expression';

  @override
  String get backButton => 'Bumalik';

  @override
  String get basicInfo => 'Pangunahing Impormasyon';

  @override
  String get basicInfoDescription =>
      'Pakisok ang pangunahing impormasyon upang makagawa ng account';

  @override
  String get birthDate => 'Petsa ng Kapanganakan';

  @override
  String get birthDateOptional => 'Petsa ng Kapanganakan (Opsyonal)';

  @override
  String get birthDateRequired => 'Petsa ng Kapanganakan *';

  @override
  String get blockConfirm => 'Gusto mo bang i-block ang AI na ito?';

  @override
  String get blockReason => 'Dahilan ng pag-block';

  @override
  String get blockThisAI => 'I-block ang AI na ito';

  @override
  String blockedAICount(int count) {
    return '$count na naka-block na AIs';
  }

  @override
  String get blockedAIs => 'Naka-block na AIs';

  @override
  String get blockedAt => 'Naka-block sa';

  @override
  String get blockedSuccessfully => 'Matagumpay na naka-block';

  @override
  String get breakfast => 'Almusal';

  @override
  String get byErrorType => 'Ayon sa Uri ng Error';

  @override
  String get byPersona => 'Ayon sa Persona';

  @override
  String cacheDeleteError(String error) {
    return 'Error sa pagtanggal ng cache: $error';
  }

  @override
  String get cacheDeleted => 'Na-delete na ang image cache';

  @override
  String get cafeTerrace => 'Terrace ng cafe';

  @override
  String get calm => 'Kalma';

  @override
  String get cameraPermission => 'Pahintulot sa Camera';

  @override
  String get cameraPermissionDesc =>
      'Kailangan namin ng pahintulot sa camera para kumuha ng larawan.';

  @override
  String get canChangeInSettings =>
      'Maaari mo itong baguhin sa mga setting mamaya';

  @override
  String get canMeetPreviousPersonas =>
      'Maaari mong makilala muli ang mga persona na iyong na-swipe dati!';

  @override
  String get cancel => 'Kanselahin';

  @override
  String get changeProfilePhoto => 'Palitan ang Larawan ng Profile';

  @override
  String get chat => 'Usapan';

  @override
  String get chatEndedMessage => 'Natapos na ang usapan';

  @override
  String get chatErrorDashboard => 'Dashboard ng Error sa Usapan';

  @override
  String get chatErrorSentSuccessfully =>
      'Matagumpay na naipadala ang error sa usapan.';

  @override
  String get chatListTab => 'Tab ng Listahan ng Usapan';

  @override
  String get chats => 'Mga Usapan';

  @override
  String chattingWithPersonas(int count) {
    return 'Nakikipag-chat sa $count persona';
  }

  @override
  String get checkInternetConnection =>
      'Pakisuri ang iyong koneksyon sa internet';

  @override
  String get checkingUserInfo => 'Sinusuri ang impormasyon ng gumagamit';

  @override
  String get childrensDay => 'Araw ng mga Bata';

  @override
  String get chinese => 'Tsino';

  @override
  String get chooseOption => 'Pakipili:';

  @override
  String get christmas => 'Pasko';

  @override
  String get close => 'Isara';

  @override
  String get complete => 'Tapos na';

  @override
  String get completeSignup => 'Kumpletuhin ang Pag-sign Up';

  @override
  String get confirm => 'Kumpirmahin';

  @override
  String get connectingToServer => 'Kumokonekta sa server';

  @override
  String get consultQualityMonitoring => 'Pagsusuri ng Kalidad ng Konsultasyon';

  @override
  String get continueAsGuest => 'Magpatuloy bilang Bisita';

  @override
  String get continueButton => 'Magpatuloy';

  @override
  String get continueWithApple => 'Magpatuloy gamit ang Apple';

  @override
  String get continueWithGoogle => 'Magpatuloy gamit ang Google';

  @override
  String get conversationContinuity => 'Pagpapatuloy ng Usapan';

  @override
  String get conversationContinuityDesc =>
      'Tandaan ang mga nakaraang usapan at ikonekta ang mga paksa';

  @override
  String conversationWith(String name) {
    return '$name';
  }

  @override
  String get convertToMember => 'Mag-sign Up';

  @override
  String get cooking => 'Pagluluto';

  @override
  String get copyMessage => 'Kopyahin ang mensahe';

  @override
  String get copyrightInfringement => 'Paglabag sa Copyright';

  @override
  String get creatingAccount => 'Gumagawa ng account';

  @override
  String get crisisDetected => 'Nakatagpo ng Krisis';

  @override
  String get culturalIssue => 'Isyu sa Kultura';

  @override
  String get current => 'Kasalukuyan';

  @override
  String get currentCacheSize => 'Kasalukuyang Sukat ng Cache';

  @override
  String get currentLanguage => 'Kasalukuyang Wika';

  @override
  String get cycling => 'Pagbibisikleta';

  @override
  String get dailyCare => 'Araw-araw na Pangangalaga';

  @override
  String get dailyCareDesc =>
      'Mga mensahe para sa pang-araw-araw na pangangalaga sa pagkain, tulog, at kalusugan';

  @override
  String get dailyChat => 'Pang-araw-araw na Usapan';

  @override
  String get dailyCheck => 'Pang-araw-araw na Suri';

  @override
  String get dailyConversation => 'Pang-araw-araw na Pag-uusap';

  @override
  String get dailyLimitDescription =>
      'Naabot mo na ang iyong pang-araw-araw na limitasyon sa mensahe';

  @override
  String get dailyLimitTitle => 'Naabot na ang Pang-araw-araw na Limit';

  @override
  String get darkMode => 'Madilim na Mode';

  @override
  String get darkTheme => 'Madilim na Tema';

  @override
  String get darkThemeDesc => 'Gumamit ng madilim na tema';

  @override
  String get dataCollection => 'Mga Setting ng Pagkolekta ng Data';

  @override
  String get datingAdvice => 'Payo sa Pakikipag-date';

  @override
  String get datingDescription =>
      'Nais kong magbahagi ng malalalim na kaisipan at magkaroon ng tapat na pag-uusap';

  @override
  String get dawn => 'Bukang-liwayway';

  @override
  String get day => 'Araw';

  @override
  String get dayAfterTomorrow => 'Araw pagkatapos ng bukas';

  @override
  String daysAgo(int count, String formatted) {
    return '$count araw ang nakalipas';
  }

  @override
  String daysRemaining(int days) {
    return '$days natitirang araw';
  }

  @override
  String get deepTalk => 'Malalim na Usapan';

  @override
  String get delete => 'Tanggalin';

  @override
  String get deleteAccount => 'Tanggalin ang Account';

  @override
  String get deleteAccountConfirm =>
      'Sigurado ka bang nais mong tanggalin ang iyong account? Ang hakbang na ito ay hindi maibabalik.';

  @override
  String get deleteAccountWarning =>
      'Sigurado ka bang nais mong tanggalin ang iyong account?';

  @override
  String get deleteCache => 'Tanggalin ang Cache';

  @override
  String get deletingAccount => 'Binubura ang account...';

  @override
  String get depressed => 'Nalulumbay';

  @override
  String get describeError => 'Ano ang problema?';

  @override
  String get detailedReason => 'Detalyadong dahilan';

  @override
  String get developRelationshipStep =>
      '3. Paunlarin ang Relasyon: Magtayo ng pagkakaintindihan sa pamamagitan ng mga pag-uusap at paunlarin ang mga espesyal na relasyon.';

  @override
  String get dinner => 'Hapunan';

  @override
  String get discardGuestData => 'Magsimula Muli';

  @override
  String get discount20 => '20% diskwento';

  @override
  String get discount30 => '30% diskwento';

  @override
  String get discountAmount => 'Magtipid';

  @override
  String discountAmountValue(String amount) {
    return 'I-save ₩$amount';
  }

  @override
  String get done => 'Tapos na';

  @override
  String get downloadingPersonaImages =>
      'Nagda-download ng mga bagong larawan ng persona';

  @override
  String get edit => 'I-edit';

  @override
  String get editInfo => 'I-edit ang Impormasyon';

  @override
  String get editProfile => 'I-edit ang Profile';

  @override
  String get effectSound => 'Mga Epekto ng Tunog';

  @override
  String get effectSoundDescription => 'Mag-play ng mga epekto ng tunog';

  @override
  String get email => 'Email';

  @override
  String get emailHint => 'halimbawa@email.com';

  @override
  String get emailLabel => 'Email';

  @override
  String get emailRequired => 'Email *';

  @override
  String get emotionAnalysis => 'Pagsusuri ng Emosyon';

  @override
  String get emotionAnalysisDesc =>
      'Suriin ang mga emosyon para sa mga empatikong tugon';

  @override
  String get emotionAngry => 'Galit';

  @override
  String get emotionBasedEncounters =>
      'Makipagkita sa mga persona batay sa iyong emosyon';

  @override
  String get emotionCool => 'Astig';

  @override
  String get emotionHappy => 'Masaya';

  @override
  String get emotionLove => 'Pag-ibig';

  @override
  String get emotionSad => 'Malungkot';

  @override
  String get emotionThinking => 'Nag-iisip';

  @override
  String get emotionalSupportDesc =>
      'Ibahagi ang iyong mga alalahanin at tumanggap ng mainit na aliw';

  @override
  String get endChat => 'Tapusin ang Usapan';

  @override
  String get endTutorial => 'Tapusin ang Tutorial';

  @override
  String get endTutorialAndLogin => 'Tatapusin ba ang tutorial at mag-login?';

  @override
  String get endTutorialMessage =>
      'Gusto mo bang tapusin ang tutorial at mag-login?';

  @override
  String get english => 'Ingles';

  @override
  String get enterBasicInfo =>
      'Pakisagutan ang pangunahing impormasyon upang makagawa ng account';

  @override
  String get enterBasicInformation => 'Pakisagutan ang pangunahing impormasyon';

  @override
  String get enterEmail => 'Ilagay ang Email';

  @override
  String get enterNickname => 'Pakisagutan ang palayaw';

  @override
  String get enterPassword => 'Ilagay ang Password';

  @override
  String get entertainmentAndFunDesc =>
      'Mag-enjoy sa mga masayang laro at kaaya-ayang usapan';

  @override
  String get entertainmentDescription =>
      'Gusto kong magkaroon ng masayang usapan at mag-enjoy sa aking oras';

  @override
  String get entertainmentFun => 'Libangan/Saya';

  @override
  String get error => 'Error';

  @override
  String get errorDescription => 'Paglalarawan ng error';

  @override
  String get errorDescriptionHint =>
      'halimbawa, Nagbigay ng kakaibang sagot, Paulit-ulit ang parehong bagay, Nagbibigay ng hindi angkop na mga tugon sa konteksto...';

  @override
  String get errorDetails => 'Mga Detalye ng Error';

  @override
  String get errorDetailsHint => 'Pakisabihin nang detalyado kung ano ang mali';

  @override
  String get errorFrequency24h => 'Dalas ng Error (Huling 24 na oras)';

  @override
  String get errorMessage => 'Mensahe ng Error:';

  @override
  String get errorOccurred => 'Nagkaroon ng error.';

  @override
  String get errorOccurredTryAgain => 'Nagkaroon ng error. Pakisubukan muli.';

  @override
  String get errorSendingFailed => 'Nabigong magpadala ng error';

  @override
  String get errorStats => 'Estadistika ng Error';

  @override
  String errorWithMessage(String error) {
    return 'Naganap ang error: $error';
  }

  @override
  String get evening => 'Gabi';

  @override
  String get excited => 'Nasasabik';

  @override
  String get exit => 'Lumabas';

  @override
  String get exitApp => 'Lumabas sa App';

  @override
  String get exitConfirmMessage => 'Sigurado ka bang nais mong lumabas sa app?';

  @override
  String get expertPersona => 'Ekspertong Persona';

  @override
  String get expertiseScore => 'Iskor ng Kasanayan';

  @override
  String get expired => 'Nag-expire';

  @override
  String get explainReportReason =>
      'Mangyaring ipaliwanag ang dahilan ng ulat nang detalyado';

  @override
  String get fashion => 'Moda';

  @override
  String get female => 'Babae';

  @override
  String get filter => 'I-filter';

  @override
  String get firstOccurred => 'Unang Nangyari:';

  @override
  String get followDeviceLanguage =>
      'Sundin ang mga setting ng wika ng aparato';

  @override
  String get forenoon => 'Umaga';

  @override
  String get forgotPassword => 'Nakalimutan ang Password?';

  @override
  String get frequentlyAskedQuestions => 'Madalas na Itinataas na mga Tanong';

  @override
  String get friday => 'Biyernes';

  @override
  String get friendshipDescription =>
      'Gusto kong makilala ang mga bagong kaibigan at makipag-usap';

  @override
  String get funChat => 'Masayang Usapan';

  @override
  String get galleryPermission => 'Pahintulot sa Gallery';

  @override
  String get galleryPermissionDesc =>
      'Kailangan namin ng pahintulot sa gallery para pumili ng larawan.';

  @override
  String get gaming => 'Gaming';

  @override
  String get gender => 'Kasarian';

  @override
  String get genderNotSelectedInfo =>
      'Kung hindi napili ang kasarian, ipapakita ang mga persona ng lahat ng kasarian';

  @override
  String get genderOptional => 'Kasarian (Opsyonal)';

  @override
  String get genderPreferenceActive =>
      'Maaari kang makilala ng mga persona ng lahat ng kasarian';

  @override
  String get genderPreferenceDisabled =>
      'Pumili ng iyong kasarian upang paganahin ang opsyon na tanging kabaligtaran ng kasarian lamang';

  @override
  String get genderPreferenceInactive =>
      'Tanging mga persona ng kabaligtaran ng kasarian ang ipapakita';

  @override
  String get genderRequired => 'Kasarian *';

  @override
  String get genderSelectionInfo =>
      'Kung hindi napili, maaari kang makilala ng mga persona ng lahat ng kasarian';

  @override
  String get generalPersona => 'Pangkalahatang Persona';

  @override
  String get goToSettings => 'Pumunta sa Settings';

  @override
  String get permissionGuideAndroid =>
      'Settings > Apps > SONA > Permissions\nPahintulutan ang access sa larawan';

  @override
  String get permissionGuideIOS =>
      'Settings > SONA > Photos\nPahintulutan ang access sa larawan';

  @override
  String get googleLoginCanceled => 'Nakansela ang pag-login sa Google.';

  @override
  String get googleLoginError =>
      'Nagkaroon ng error sa pag-login gamit ang Google.';

  @override
  String get grantPermission => 'Magpatuloy';

  @override
  String get guest => 'Bisita';

  @override
  String get guestDataMigration =>
      'Gusto mo bang panatilihin ang iyong kasalukuyang kasaysayan ng chat kapag nag-sign up?';

  @override
  String get guestLimitReached => 'Natapos na ang trial ng bisita.';

  @override
  String get guestLoginPromptMessage =>
      'Mag-login upang ipagpatuloy ang pag-uusap';

  @override
  String get guestMessageExhausted => 'Naubos na ang mga libreng mensahe';

  @override
  String guestMessageRemaining(int count) {
    return '$count natitirang mensahe ng bisita';
  }

  @override
  String get guestModeBanner => 'Mode ng Bisita';

  @override
  String get guestModeDescription => 'Subukan ang SONA nang hindi nag-sign up';

  @override
  String get guestModeFailedMessage => 'Nabigong simulan ang Mode ng Bisita';

  @override
  String get guestModeLimitation =>
      'Ang ilang mga tampok ay limitado sa Guest Mode';

  @override
  String get guestModeTitle => 'Subukan bilang Bisita';

  @override
  String get guestModeWarning =>
      'Ang Guest mode ay tumatagal ng 24 na oras, pagkatapos nito ay mabubura ang data.';

  @override
  String get guestModeWelcome => 'Nagsisimula sa Guest Mode';

  @override
  String get happy => 'Masaya';

  @override
  String get hapticFeedback => 'Haptic Feedback';

  @override
  String get harassmentBullying => 'Pang-aabuso/Pang-bu-bully';

  @override
  String get hateSpeech => 'Pananalita ng poot';

  @override
  String get heartDescription => 'Mga puso para sa higit pang mga mensahe';

  @override
  String get heartInsufficient => 'Hindi sapat na mga puso';

  @override
  String get heartInsufficientPleaseCharge =>
      'Hindi sapat ang mga puso. Mangyaring mag-recharge ng mga puso.';

  @override
  String get heartRequired => '1 puso ang kinakailangan';

  @override
  String get heartUsageFailed => 'Nabigong gamitin ang puso.';

  @override
  String get hearts => 'Mga Puso';

  @override
  String get hearts10 => '10 Mga Puso';

  @override
  String get hearts30 => '30 Mga Puso';

  @override
  String get hearts30Discount => 'SALE';

  @override
  String get hearts50 => '50 Mga Puso';

  @override
  String get hearts50Discount => 'BENTA';

  @override
  String get helloEmoji => 'Kamusta! 😊';

  @override
  String get help => 'Tulong';

  @override
  String get hideOriginalText => 'Itago ang Orihinal';

  @override
  String get hobbySharing => 'Pagbabahagi ng Libangan';

  @override
  String get hobbyTalk => 'Usapang Libangan';

  @override
  String get hours24Ago => '24 oras na ang nakalipas';

  @override
  String hoursAgo(int count, String formatted) {
    return '$count oras ang nakalipas';
  }

  @override
  String get howToUse => 'Paano gamitin ang SONA';

  @override
  String get imageCacheManagement => 'Pamamahala ng Image Cache';

  @override
  String get inappropriateContent => 'Hindi angkop na nilalaman';

  @override
  String get incorrect => 'mali';

  @override
  String get incorrectPassword => 'Mali ang password';

  @override
  String get indonesian => 'Indonesian';

  @override
  String get inquiries => 'Mga Katanungan';

  @override
  String get insufficientHearts => 'Hindi sapat na puso.';

  @override
  String get interestSharing => 'Pagsasalo ng Interes';

  @override
  String get interestSharingDesc =>
      'Tuklasin at irekomenda ang mga ibinahaging interes';

  @override
  String get interests => 'Mga Interes';

  @override
  String get invalidEmailFormat => 'Di-wastong format ng email';

  @override
  String get invalidEmailFormatError =>
      'Mangyaring maglagay ng wastong address ng email';

  @override
  String isTyping(String name) {
    return 'Nagtatype si $name...';
  }

  @override
  String get japanese => 'Hapon';

  @override
  String get joinDate => 'Petsa ng Pagsali';

  @override
  String get justNow => 'Ngayon lang';

  @override
  String get keepGuestData => 'Panatilihin ang Kasaysayan ng Chat';

  @override
  String get korean => 'Koreano';

  @override
  String get koreanLanguage => 'Koreano';

  @override
  String get language => 'Wika';

  @override
  String get languageDescription => 'Ang AI ay tutugon sa iyong napiling wika';

  @override
  String get languageIndicator => 'Wika';

  @override
  String get languageSettings => 'Mga Setting ng Wika';

  @override
  String get lastOccurred => 'Huling Nangyari:';

  @override
  String get lastUpdated => 'Huling Na-update';

  @override
  String get lateNight => 'Hatingabi';

  @override
  String get later => 'Mamaya';

  @override
  String get laterButton => 'Mamaya';

  @override
  String get leave => 'Umalis';

  @override
  String get leaveChatConfirm => 'Umalis sa chat na ito?';

  @override
  String get leaveChatRoom => 'Umalis sa Chat Room';

  @override
  String get leaveChatTitle => 'Umalis sa Chat';

  @override
  String get lifeAdvice => 'Payo sa Buhay';

  @override
  String get lightTalk => 'Magaan na Usapan';

  @override
  String get lightTheme => 'Maliwanag na Tema';

  @override
  String get lightThemeDesc => 'Gumamit ng maliwanag na tema';

  @override
  String get loading => 'Nag-load...';

  @override
  String get loadingData => 'Naglo-load ng data...';

  @override
  String get loadingProducts => 'Naglo-load ng mga produkto...';

  @override
  String get loadingProfile => 'Naglo-load ng profile';

  @override
  String get login => 'Mag-login';

  @override
  String get loginButton => 'Mag-login';

  @override
  String get loginCancelled => 'Nakansela ang pag-login';

  @override
  String get loginComplete => 'Kumpleto ang pag-login';

  @override
  String get loginError => 'Nabigong mag-login';

  @override
  String get loginFailed => 'Nabigong mag-login';

  @override
  String get loginFailedTryAgain => 'Nabigong mag-login. Pakisubukan muli.';

  @override
  String get loginRequired => 'Kinakailangan ang pag-login';

  @override
  String get loginRequiredForProfile =>
      'Kinakailangan ang pag-login upang makita ang profile';

  @override
  String get loginRequiredService =>
      'Kinakailangan ang pag-login upang magamit ang serbisyong ito';

  @override
  String get loginRequiredTitle => 'Kinakailangan ang Pag-login';

  @override
  String get loginSignup => 'Mag-login/Mag-sign Up';

  @override
  String get loginTab => 'Mag-login';

  @override
  String get loginTitle => 'Mag-login';

  @override
  String get loginWithApple => 'Mag-login gamit ang Apple';

  @override
  String get loginWithGoogle => 'Mag-login gamit ang Google';

  @override
  String get logout => 'Mag-logout';

  @override
  String get logoutConfirm => 'Sigurado ka bang nais mong mag-logout?';

  @override
  String get lonelinessRelief => 'Pagbawas ng Kalungkutan';

  @override
  String get lonely => 'Nag-iisa';

  @override
  String get lowQualityResponses => 'Mababang Kalidad ng Mga Tugon';

  @override
  String get lunch => 'Tanghalian';

  @override
  String get lunchtime => 'Oras ng Tanghalian';

  @override
  String get mainErrorType => 'Pangunahing Uri ng Error';

  @override
  String get makeFriends => 'Gumawa ng Mga Kaibigan';

  @override
  String get male => 'Lalaki';

  @override
  String get manageBlockedAIs => 'Pamahalaan ang Mga Naharang na AI';

  @override
  String get managePersonaImageCache =>
      'Pamahalaan ang cache ng larawan ng persona';

  @override
  String get marketingAgree =>
      'Sumang-ayon sa Impormasyon sa Marketing (Opsyonal)';

  @override
  String get marketingDescription =>
      'Maaari kang makatanggap ng impormasyon tungkol sa mga kaganapan at benepisyo';

  @override
  String get matchPersonaStep =>
      '1. Itugma ang Mga Persona: Mag-swipe pakaliwa o pakanan upang piliin ang iyong paboritong AI persona.';

  @override
  String get matchedPersonas => 'Nakatugmang Personas';

  @override
  String get matchedSona => 'Nakatugmang Sona';

  @override
  String get matching => 'Nagtutugma';

  @override
  String get matchingFailed => 'Nabigo ang pagtutugma.';

  @override
  String get me => 'Me';

  @override
  String get meetAIPersonas => 'Kilalanin ang AI Personas';

  @override
  String get meetNewPersonas => 'Kilalanin ang Mga Bagong Personas';

  @override
  String get meetPersonas => 'Kilalanin ang Mga Personas';

  @override
  String get memberBenefits =>
      'Makakuha ng 100+ mensahe at 10 puso kapag nag-sign up ka!';

  @override
  String get memoryAlbum => 'Album ng Alaala';

  @override
  String get memoryAlbumDesc =>
      'Awtomatikong i-save at alalahanin ang mga espesyal na sandali';

  @override
  String get messageCopied => 'Mensahe na kopya';

  @override
  String get messageDeleted => 'Mensahe na tanggal';

  @override
  String get messageLimitReset =>
      'Magre-reset ang limit ng mensahe sa hatingabi';

  @override
  String get messageSendFailed =>
      'Nabigong magpadala ng mensahe. Pakisubukan muli.';

  @override
  String get messagesRemaining => 'Natitirang Mensahe';

  @override
  String minutesAgo(int count, String formatted) {
    return '$count minuto ang nakalipas';
  }

  @override
  String get missingTranslation => 'Nawawalang Pagsasalin';

  @override
  String get monday => 'Lunes';

  @override
  String get month => 'Buwan';

  @override
  String monthDay(String month, int day) {
    return '$month $day';
  }

  @override
  String get moreButton => 'Higit Pa';

  @override
  String get morning => 'Umaga';

  @override
  String get mostFrequentError => 'Pinakamadalas na Error';

  @override
  String get movies => 'Mga Pelikula';

  @override
  String get multilingualChat => 'Multilinggwal na Chat';

  @override
  String get music => 'Musika';

  @override
  String get myGenderSection => 'Ang Aking Kasarian (Opsyonal)';

  @override
  String get networkErrorOccurred => 'Nagkaroon ng error sa network.';

  @override
  String get newMessage => 'Bagong Mensahe';

  @override
  String newMessageCount(int count) {
    return '$count bagong mensahe';
  }

  @override
  String get newMessageNotification =>
      'Ipaalam sa akin ang tungkol sa mga bagong mensahe';

  @override
  String get newMessages => 'Mga bagong mensahe';

  @override
  String get newYear => 'Bagong Taon';

  @override
  String get next => 'Susunod';

  @override
  String get niceToMeetYou => 'Ikaw ay ikinagagalak kong makilala!';

  @override
  String get nickname => 'Palayaw';

  @override
  String get nicknameAlreadyUsed => 'Ang palayaw na ito ay ginagamit na';

  @override
  String get nicknameHelperText => '3-10 na karakter';

  @override
  String get nicknameHint => '3-10 na karakter';

  @override
  String get nicknameInUse => 'Ang palayaw na ito ay ginagamit na';

  @override
  String get nicknameLabel => 'Palayaw';

  @override
  String get nicknameLengthError => 'Ang palayaw ay dapat na 3-10 na karakter';

  @override
  String get nicknamePlaceholder => 'Ipasok ang iyong palayaw';

  @override
  String get nicknameRequired => 'Palayaw *';

  @override
  String get night => 'Gabi';

  @override
  String get no => 'Hindi';

  @override
  String get noBlockedAIs => 'Walang naka-block na AIs';

  @override
  String get noChatsYet => 'Wala pang mga chat';

  @override
  String get noConversationYet => 'Wala pang pag-uusap';

  @override
  String get noErrorReports => 'Walang ulat ng error.';

  @override
  String get noImageAvailable => 'Walang magagamit na larawan';

  @override
  String get noMatchedPersonas => 'Walang na-match na personas pa';

  @override
  String get noMatchedSonas => 'Walang na-match na Sonas pa';

  @override
  String get noPersonasAvailable =>
      'Walang magagamit na personas. Pakisubukan muli.';

  @override
  String get noPersonasToSelect => 'Walang magagamit na personas';

  @override
  String get noQualityIssues => 'Walang isyu sa kalidad sa nakaraang oras ✅';

  @override
  String get noQualityLogs => 'Wala pang mga tala ng kalidad.';

  @override
  String get noTranslatedMessages => 'Walang mensahe na isasalin';

  @override
  String get notEnoughHearts => 'Hindi sapat ang mga puso';

  @override
  String notEnoughHeartsCount(int count) {
    return 'Hindi sapat ang mga puso. (Kasalukuyan: $count)';
  }

  @override
  String get notRegistered => 'hindi nakarehistro';

  @override
  String get notSubscribed => 'Hindi nakasubscribe';

  @override
  String get notificationPermissionDesc =>
      'Kailangan namin ng pahintulot sa abiso para magpadala ng alerts.';

  @override
  String get notificationPermissionRequired =>
      'Kailangan ng pahintulot sa abiso';

  @override
  String get notificationSettings => 'Mga Setting ng Abiso';

  @override
  String get notifications => 'Mga Abiso';

  @override
  String get occurrenceInfo => 'Impormasyon sa Pagkakataon:';

  @override
  String get olderChats => 'Mas matanda';

  @override
  String get onlyOppositeGenderNote =>
      'Kung hindi naka-check, tanging mga persona ng kabaligtarang kasarian lamang ang ipapakita';

  @override
  String get openSettings => 'Buksan ang Mga Setting';

  @override
  String get optional => 'Opsyonal';

  @override
  String get or => 'or';

  @override
  String get originalPrice => 'Orihinal';

  @override
  String get originalText => 'Orihinal';

  @override
  String get other => 'Iba pa';

  @override
  String get otherError => 'Ibang Error';

  @override
  String get others => 'Iba pa';

  @override
  String get ownedHearts => 'Nabiling Puso';

  @override
  String get parentsDay => 'Araw ng mga Magulang';

  @override
  String get password => 'Password';

  @override
  String get passwordConfirmation => 'Ipasok ang password upang kumpirmahin';

  @override
  String get passwordConfirmationDesc =>
      'Pakisulit ang iyong password upang tanggalin ang account.';

  @override
  String get passwordHint => '6 na karakter o higit pa';

  @override
  String get passwordLabel => 'Password';

  @override
  String get passwordRequired => 'Password *';

  @override
  String get passwordResetEmailPrompt =>
      'Pakisulat ang iyong email upang i-reset ang password';

  @override
  String get passwordResetEmailSent =>
      'Ang email para sa pag-reset ng password ay naipadala na. Pakisuri ang iyong email.';

  @override
  String get passwordText => 'password';

  @override
  String get passwordTooShort =>
      'Ang password ay dapat hindi bababa sa 6 na karakter';

  @override
  String get permissionDenied => 'Hindi Pinahintulutan';

  @override
  String permissionDeniedMessage(String permissionName) {
    return 'Hindi pinahintulutan ang $permissionName. Mangyaring bigyan ng pahintulot mula sa settings.';
  }

  @override
  String get permissionDeniedTryLater =>
      'Tinanggihan ang pahintulot. Pakisubukan muli mamaya.';

  @override
  String get permissionRequired => 'Kailangan ng Pahintulot';

  @override
  String get personaGenderSection => 'Kagustuhan sa Kasarian ng Persona';

  @override
  String get personaQualityStats => 'Estadistika ng Kalidad ng Persona';

  @override
  String get personalInfoExposure => 'Pagbubunyag ng Personal na Impormasyon';

  @override
  String get personality => 'Personalidad';

  @override
  String get pets => 'Mga Alagang Hayop';

  @override
  String get photo => 'Larawan';

  @override
  String get photography => 'Potograpiya';

  @override
  String get picnic => 'Piknik';

  @override
  String get preferenceSettings => 'Mga Setting ng Kagustuhan';

  @override
  String get preferredLanguage => 'Piniling Wika';

  @override
  String get preparingForSleep => 'Naghahanda para sa Pagtulog';

  @override
  String get preparingNewMeeting => 'Naghahanda ng Bagong Pulong';

  @override
  String get preparingPersonaImages => 'Naghahanda ng mga larawan ng persona';

  @override
  String get preparingPersonas => 'Naghahanda ng mga persona';

  @override
  String get preview => 'Pagsusuri';

  @override
  String get previous => 'Nakaraan';

  @override
  String get privacy => 'Patakaran sa Privacy';

  @override
  String get privacyPolicy => 'Patakaran sa Privacy';

  @override
  String get privacyPolicyAgreement =>
      'Pakisuyo, sumang-ayon sa patakaran sa privacy';

  @override
  String get privacySection1Content =>
      'Kami ay nakatuon sa pagprotekta sa iyong privacy. Ang Patakaran sa Privacy na ito ay nagpapaliwanag kung paano namin kinokolekta, ginagamit, at pinangangalagaan ang iyong impormasyon kapag ginagamit mo ang aming serbisyo.';

  @override
  String get privacySection1Title =>
      '1. Layunin ng Pagkolekta at Paggamit ng Personal na Impormasyon';

  @override
  String get privacySection2Content =>
      'Kinokolekta namin ang impormasyong ibinibigay mo nang direkta sa amin, tulad ng kapag lumikha ka ng isang account, nag-update ng iyong profile, o gumamit ng aming mga serbisyo.';

  @override
  String get privacySection2Title => 'Impormasyon na Kinokolekta Namin';

  @override
  String get privacySection3Content =>
      'Ginagamit namin ang impormasyong aming kinokolekta upang magbigay, magpanatili, at magpabuti ng aming mga serbisyo, at upang makipag-ugnayan sa iyo.';

  @override
  String get privacySection3Title =>
      '3. Panahon ng Pag-iingat at Paggamit ng Personal na Impormasyon';

  @override
  String get privacySection4Content =>
      'Hindi namin ibinibenta, ipinagpapalit, o sa ibang paraan ay inililipat ang iyong personal na impormasyon sa mga ikatlong partido nang walang iyong pahintulot.';

  @override
  String get privacySection4Title =>
      '4. Pagbibigay ng Personal na Impormasyon sa mga Ikatlong Partido';

  @override
  String get privacySection5Content =>
      'Nagpapatupad kami ng angkop na mga hakbang sa seguridad upang protektahan ang iyong personal na impormasyon laban sa hindi awtorisadong pag-access, pagbabago, pagsisiwalat, o pagkasira.';

  @override
  String get privacySection5Title =>
      '5. Mga Teknikal na Hakbang sa Proteksyon para sa Personal na Impormasyon';

  @override
  String get privacySection6Content =>
      'Nananatili kami ng personal na impormasyon hangga\'t kinakailangan upang maibigay ang aming mga serbisyo at sumunod sa mga legal na obligasyon.';

  @override
  String get privacySection6Title => '6. Mga Karapatan ng Gumagamit';

  @override
  String get privacySection7Content =>
      'May karapatan kang ma-access, i-update, o tanggalin ang iyong personal na impormasyon anumang oras sa pamamagitan ng iyong mga setting ng account.';

  @override
  String get privacySection7Title => 'Ang Iyong Mga Karapatan';

  @override
  String get privacySection8Content =>
      'Kung mayroon kang anumang katanungan tungkol sa Patakarang ito sa Privacy, mangyaring makipag-ugnayan sa amin sa support@sona.com.';

  @override
  String get privacySection8Title => 'Makipag-ugnayan sa Amin';

  @override
  String get privacySettings => 'Mga Setting ng Privacy';

  @override
  String get privacySettingsInfo =>
      'Ang pag-disable ng mga indibidwal na tampok ay magpapawalang-bisa sa mga serbisyong iyon';

  @override
  String get privacySettingsScreen => 'Mga Setting ng Privacy';

  @override
  String get problemMessage => 'Problema';

  @override
  String get problemOccurred => 'Naganap ang Problema';

  @override
  String get profile => 'Profile';

  @override
  String get profileEdit => 'I-edit ang Profile';

  @override
  String get profileEditLoginRequiredMessage =>
      'Kinakailangan ang pag-login upang i-edit ang iyong profile.';

  @override
  String get profileInfo => 'Impormasyon sa Profile';

  @override
  String get profileInfoDescription =>
      'Pakisuyong ilagay ang iyong larawan sa profile at pangunahing impormasyon';

  @override
  String get profileNav => 'Profile';

  @override
  String get profilePhoto => 'Larawan sa Profile';

  @override
  String get profilePhotoAndInfo =>
      'Pakisuyong ilagay ang larawan sa profile at pangunahing impormasyon';

  @override
  String get profilePhotoUpdateFailed =>
      'Nabigong i-update ang larawan sa profile';

  @override
  String get profilePhotoUpdated => 'Na-update ang larawan sa profile';

  @override
  String get profileSettings => 'Mga Setting ng Profile';

  @override
  String get profileSetup => 'Profile Setup';

  @override
  String get profileUpdateFailed => 'Nabigong i-update ang profile';

  @override
  String get profileUpdated => 'Matagumpay na na-update ang profile';

  @override
  String get purchaseAndRefundPolicy => 'Patakaran sa Pagbili at Pagbabalik';

  @override
  String get purchaseButton => 'Bumili';

  @override
  String get purchaseConfirm => 'Kumpirmasyon ng Pagbili';

  @override
  String purchaseConfirmContent(String product, String price) {
    return 'Bibilhin ang $product para sa $price?';
  }

  @override
  String purchaseConfirmMessage(
      String title, String price, String description) {
    return 'Kumpirmahin ang pagbili ng $title para sa $price? $description';
  }

  @override
  String get purchaseFailed => 'Nabigo ang pagbili';

  @override
  String get purchaseHeartsOnly => 'Bumili ng mga puso';

  @override
  String get purchaseMoreHearts =>
      'Bumili ng mga puso upang ipagpatuloy ang mga pag-uusap';

  @override
  String get purchasePending => 'Naghihintay ng pagbili...';

  @override
  String get purchasePolicy => 'Patakaran sa Pagbili';

  @override
  String get purchaseSection1Content =>
      'Tumatanggap kami ng iba\'t ibang paraan ng pagbabayad kabilang ang mga credit card at digital wallets.';

  @override
  String get purchaseSection1Title => 'Mga Paraan ng Pagbabayad';

  @override
  String get purchaseSection2Content =>
      'Ang mga refund ay available sa loob ng 14 na araw mula sa pagbili kung hindi mo pa nagamit ang mga biniling item.';

  @override
  String get purchaseSection2Title => 'Patakaran sa Refund';

  @override
  String get purchaseSection3Content =>
      'Maaari mong kanselahin ang iyong subscription anumang oras sa pamamagitan ng iyong account settings.';

  @override
  String get purchaseSection3Title => 'Kanselasyon';

  @override
  String get purchaseSection4Content =>
      'Sa paggawa ng pagbili, sumasang-ayon ka sa aming mga tuntunin ng paggamit at kasunduan sa serbisyo.';

  @override
  String get purchaseSection4Title => 'Mga Tuntunin ng Paggamit';

  @override
  String get purchaseSection5Content =>
      'Para sa mga isyu na may kaugnayan sa pagbili, mangyaring makipag-ugnayan sa aming support team.';

  @override
  String get purchaseSection5Title => 'Makipag-ugnayan sa Suporta';

  @override
  String get purchaseSection6Content =>
      'Ang lahat ng pagbili ay napapailalim sa aming mga karaniwang tuntunin at kundisyon.';

  @override
  String get purchaseSection6Title => '6. Mga Katanungan';

  @override
  String get pushNotifications => 'Mga Push Notification';

  @override
  String get reading => 'Pagbasa';

  @override
  String get realtimeQualityLog => 'Real-time na Quality Log';

  @override
  String get recentConversation => 'Kamakailang Usapan:';

  @override
  String get recentLoginRequired =>
      'Mangyaring mag-login muli para sa seguridad';

  @override
  String get referrerEmail => 'Email ng Nag-refer';

  @override
  String get referrerEmailHelper => 'Opsyonal: Email ng nag-refer sa iyo';

  @override
  String get referrerEmailLabel => 'Email ng Nag-refer (Opsyonal)';

  @override
  String get refresh => 'I-refresh';

  @override
  String refreshComplete(int count) {
    return 'Natapos ang pag-refresh! $count na tugmang persona';
  }

  @override
  String get refreshFailed => 'Nabigo ang pag-refresh';

  @override
  String get refreshingChatList => 'Nagre-refresh ng listahan ng chat...';

  @override
  String get relatedFAQ => 'Kaugnay na FAQ';

  @override
  String get report => 'I-report';

  @override
  String get reportAI => 'Iulat';

  @override
  String get reportAIDescription =>
      'Kung ang AI ay nagdulot sa iyo ng hindi komportable, mangyaring ilarawan ang isyu.';

  @override
  String get reportAITitle => 'Iulat ang Usapan sa AI';

  @override
  String get reportAndBlock => 'Iulat at I-block';

  @override
  String get reportAndBlockDescription =>
      'Maaari mong iulat at i-block ang hindi angkop na pag-uugali ng AI na ito';

  @override
  String get reportChatError => 'Iulat ang Error sa Chat';

  @override
  String reportError(String error) {
    return 'Nagkaroon ng error habang nag-uulat: $error';
  }

  @override
  String get reportFailed => 'Nabigo ang ulat';

  @override
  String get reportSubmitted =>
      'Naipasa na ang ulat. Susuriin namin ito at gagawa ng aksyon.';

  @override
  String get reportSubmittedSuccess => 'Naipasa na ang iyong ulat. Salamat!';

  @override
  String get requestLimit => 'Limit ng Kahilingan';

  @override
  String get required => '[Kailangan]';

  @override
  String get requiredTermsAgreement => 'Pakisundin ang mga tuntunin';

  @override
  String get restartConversation => 'I-restart ang Usapan';

  @override
  String restartConversationQuestion(String name) {
    return 'Gusto mo bang i-restart ang usapan kasama si $name?';
  }

  @override
  String restartConversationWithName(String name) {
    return 'I-rerestart ang usapan kasama si $name!';
  }

  @override
  String get retry => 'Subukang muli';

  @override
  String get retryButton => 'Subukan Muli';

  @override
  String get sad => 'Malungkot';

  @override
  String get saturday => 'Sabado';

  @override
  String get save => 'I-save';

  @override
  String get search => 'Maghanap';

  @override
  String get searchFAQ => 'Maghanap ng FAQ...';

  @override
  String get searchResults => 'Mga Resulta ng Paghahanap';

  @override
  String get selectEmotion => 'Pumili ng Emosyon';

  @override
  String get selectErrorType => 'Pumili ng uri ng error';

  @override
  String get selectFeeling => 'Pumili ng Pakiramdam';

  @override
  String get selectGender => 'Piliin ang Kasarian';

  @override
  String get selectInterests =>
      'Mangyaring pumili ng iyong mga interes (higit sa 1)';

  @override
  String get selectLanguage => 'Piliin ang Wika';

  @override
  String get selectPersona => 'Pumili ng persona';

  @override
  String get selectPersonaPlease => 'Mangyaring pumili ng isang persona.';

  @override
  String get selectPreferredMbti =>
      'Kung mas gusto mo ang mga persona na may tiyak na uri ng MBTI, mangyaring pumili';

  @override
  String get selectProblematicMessage =>
      'Pumili ng problemadong mensahe (opsyonal)';

  @override
  String get chatErrorAnalysisInfo => 'Sinusuri ang huling 10 pag-uusap.';

  @override
  String get whatWasAwkward => 'Ano ang tila hindi natural?';

  @override
  String get errorExampleHint =>
      'Halimbawa: Hindi natural na paraan ng pagsasalita (hulapi na ~nya)...';

  @override
  String get selectReportReason => 'Pumili ng dahilan ng ulat';

  @override
  String get selectTheme => 'Piliin ang Tema';

  @override
  String get selectTranslationError =>
      'Mangyaring pumili ng mensahe na may pagkakamali sa pagsasalin';

  @override
  String get selectUsagePurpose =>
      'Mangyaring pumili ng iyong layunin sa paggamit ng SONA';

  @override
  String get selfIntroduction => 'Panimula (Opsyonal)';

  @override
  String get selfIntroductionHint =>
      'Isulat ang isang maikling panimula tungkol sa iyong sarili';

  @override
  String get send => 'Ipadala';

  @override
  String get sendChatError => 'Nagkaroon ng error sa pagpapadala ng chat';

  @override
  String get sendFirstMessage => 'Ipadala ang iyong unang mensahe';

  @override
  String get sendReport => 'Ipadala ang Ulat';

  @override
  String get sendingEmail => 'Nagpapadala ng email...';

  @override
  String get seoul => 'Seoul';

  @override
  String get serverErrorDashboard => 'Error sa Server';

  @override
  String get serviceTermsAgreement => 'Pakisundin ang mga tuntunin ng serbisyo';

  @override
  String get sessionExpired => 'Nawala ang session';

  @override
  String get setAppInterfaceLanguage => 'Itakda ang wika ng interface ng app';

  @override
  String get setNow => 'Itakda Ngayon';

  @override
  String get settings => 'Mga Setting';

  @override
  String get sexualContent => 'Nilalaman na Sekswal';

  @override
  String get showAllGenderPersonas => 'Ipakita ang Lahat ng Gender Personas';

  @override
  String get showAllGendersOption => 'Ipakita ang Lahat ng Kasarian';

  @override
  String get showOppositeGenderOnly =>
      'Kung hindi naka-check, tanging mga persona ng kabaligtarang kasarian lamang ang ipapakita';

  @override
  String get showOriginalText => 'Ipakita ang Orihinal';

  @override
  String get signUp => 'Mag-sign up';

  @override
  String get signUpFromGuest =>
      'Mag-sign up ngayon upang ma-access ang lahat ng mga tampok!';

  @override
  String get signup => 'Mag-sign Up';

  @override
  String get signupComplete => 'Kumpleto na ang Pag-sign Up';

  @override
  String get signupTab => 'Mag-sign Up';

  @override
  String get simpleInfoRequired => 'Kinakailangan ang simpleng impormasyon';

  @override
  String get skip => 'Laktawan';

  @override
  String get sonaFriend => 'SONA Kaibigan';

  @override
  String get sonaPrivacyPolicy => 'Patakaran sa Privacy ng SONA';

  @override
  String get sonaPurchasePolicy => 'Patakaran sa Pagbili ng SONA';

  @override
  String get sonaTermsOfService => 'Mga Tuntunin ng Serbisyo ng SONA';

  @override
  String get sonaUsagePurpose =>
      'Pakisuyong piliin ang iyong layunin sa paggamit ng SONA';

  @override
  String get sorryNotHelpful => 'Paumanhin, hindi ito nakatulong';

  @override
  String get sort => 'Ayusin';

  @override
  String get soundSettings => 'Mga Setting ng Tunog';

  @override
  String get spamAdvertising => 'Spam/Pag-aanunsyo';

  @override
  String get spanish => 'Espanyol';

  @override
  String get specialRelationshipDesc =>
      'Magkaintindihan at bumuo ng malalim na ugnayan';

  @override
  String get sports => 'Isports';

  @override
  String get spring => 'Tagsibol';

  @override
  String get startChat => 'Simulan ang Usapan';

  @override
  String get startChatButton => 'Simulan ang Usapan';

  @override
  String get startConversation => 'Simulan ang pag-uusap';

  @override
  String get startConversationLikeAFriend =>
      'Simulan ang usapan kay Sona na parang kaibigan';

  @override
  String get startConversationStep =>
      '2. Simulan ang Usapan: Makipag-chat nang malaya sa mga katugmang persona.';

  @override
  String get startConversationWithSona =>
      'Simulan ang pakikipag-chat kay Sona na parang kaibigan!';

  @override
  String get startWithEmail => 'Simulan gamit ang Email';

  @override
  String get startWithGoogle => 'Simulan gamit ang Google';

  @override
  String get startingApp => 'Sinisimulan ang app';

  @override
  String get storageManagement => 'Pamamahala ng Imbakan';

  @override
  String get store => 'Tindahan';

  @override
  String get storeConnectionError => 'Hindi makakonekta sa tindahan';

  @override
  String get storeLoginRequiredMessage =>
      'Kinakailangan ang pag-login upang magamit ang tindahan.';

  @override
  String get storeNotAvailable => 'Hindi available ang tindahan';

  @override
  String get storyEvent => 'Kaganapan ng Kwento';

  @override
  String get stressed => 'Na-stress';

  @override
  String get submitReport => 'Isumite ang Ulat';

  @override
  String get subscriptionStatus => 'Katayuan ng Subscription';

  @override
  String get subtleVibrationOnTouch => 'Banayad na panginginig sa pagdampi';

  @override
  String get summer => 'Tag-init';

  @override
  String get sunday => 'Linggo';

  @override
  String get swipeAnyDirection => 'Mag-swipe sa anumang direksyon';

  @override
  String get swipeDownToClose => 'I-swipe pababa upang isara';

  @override
  String get systemTheme => 'Sundin ang Sistema';

  @override
  String get systemThemeDesc =>
      'Awtomatikong nagbabago batay sa mga setting ng madilim na mode ng aparato';

  @override
  String get tapBottomForDetails =>
      'I-tap ang ibabang bahagi upang makita ang mga detalye';

  @override
  String get tapForDetails => 'I-tap ang ibabang bahagi para sa mga detalye';

  @override
  String get tapToSwipePhotos => 'I-tap upang i-swipe ang mga larawan';

  @override
  String get teachersDay => 'Araw ng mga Guro';

  @override
  String get technicalError => 'Teknikal na Error';

  @override
  String get technology => 'Teknolohiya';

  @override
  String get terms => 'Mga Tuntunin ng Serbisyo';

  @override
  String get termsAgreement => 'Kasunduan ng mga Tuntunin';

  @override
  String get termsAgreementDescription =>
      'Mangyaring sumang-ayon sa mga tuntunin para sa paggamit ng serbisyo';

  @override
  String get termsOfService => 'Mga Tuntunin ng Serbisyo';

  @override
  String get termsSection10Content =>
      'Nananatili ang karapatan naming baguhin ang mga tuntuning ito anumang oras na may abiso sa mga gumagamit.';

  @override
  String get termsSection10Title => 'Artikulo 10 (Pagsusuri ng Alitan)';

  @override
  String get termsSection11Content =>
      'Ang mga tuntuning ito ay pamamahalaan ng mga batas ng hurisdiksyon kung saan kami nagpapatakbo.';

  @override
  String get termsSection11Title =>
      'Artikulo 11 (Mga Espesyal na Probisyon ng Serbisyo ng AI)';

  @override
  String get termsSection12Content =>
      'Kung ang anumang probisyon ng mga tuntuning ito ay natagpuang hindi maipatutupad, ang mga natitirang probisyon ay mananatiling may buong bisa at epekto.';

  @override
  String get termsSection12Title =>
      'Artikulo 12 (Pagkolekta at Paggamit ng Data)';

  @override
  String get termsSection1Content =>
      'Layunin ng mga tuntunin at kundisyong ito na tukuyin ang mga karapatan, obligasyon, at responsibilidad sa pagitan ng SONA (na tinutukoy dito bilang \"Kompanya\") at mga gumagamit kaugnay ng paggamit ng serbisyo ng pag-uusap na tumutugma sa AI persona (na tinutukoy dito bilang \"Serbisyo\") na ibinibigay ng Kompanya.';

  @override
  String get termsSection1Title => 'Artikulo 1 (Layunin)';

  @override
  String get termsSection2Content =>
      'Sa paggamit ng aming serbisyo, sumasang-ayon ka na sumunod sa mga Tuntunin ng Serbisyo na ito at sa aming Patakaran sa Privacy.';

  @override
  String get termsSection2Title => 'Artikulo 2 (Mga Kahulugan)';

  @override
  String get termsSection3Content =>
      'Dapat kang hindi bababa sa 13 taong gulang upang magamit ang aming serbisyo.';

  @override
  String get termsSection3Title =>
      'Artikulo 3 (Epekto at Pagbabago ng mga Tuntunin)';

  @override
  String get termsSection4Content =>
      'Ikaw ang may pananagutan sa pagpapanatili ng pagiging kompidensyal ng iyong account at password.';

  @override
  String get termsSection4Title => 'Artikulo 4 (Pagbibigay ng Serbisyo)';

  @override
  String get termsSection5Content =>
      'Sumasang-ayon kang hindi gamitin ang aming serbisyo para sa anumang ilegal o hindi awtorisadong layunin.';

  @override
  String get termsSection5Title => 'Artikulo 5 (Rehistrasyon ng Miyembro)';

  @override
  String get termsSection6Content =>
      'Inilalaan namin ang karapatan na wakasan o suspindihin ang iyong account dahil sa paglabag sa mga tuntuning ito.';

  @override
  String get termsSection6Title => 'Artikulo 6 (Mga Obligasyon ng Gumagamit)';

  @override
  String get termsSection7Content =>
      'Maaaring unti-unting limitahan ng Kumpanya ang paggamit ng serbisyo sa pamamagitan ng mga babala, pansamantalang pagsuspinde, o permanenteng pagsuspinde kung ang mga gumagamit ay lumalabag sa mga obligasyon ng mga terminong ito o nakikialam sa normal na operasyon ng serbisyo.';

  @override
  String get termsSection7Title =>
      'Artikulo 7 (Mga Paghihigpit sa Paggamit ng Serbisyo)';

  @override
  String get termsSection8Content =>
      'Wala kaming pananagutan para sa anumang di-tuwirang, incidental, o consequential na pinsala na nagmumula sa iyong paggamit ng aming serbisyo.';

  @override
  String get termsSection8Title => 'Artikulo 8 (Pagkakasuspinde ng Serbisyo)';

  @override
  String get termsSection9Content =>
      'Lahat ng nilalaman at materyales na available sa aming serbisyo ay protektado ng mga karapatan sa intelektwal na ari-arian.';

  @override
  String get termsSection9Title => 'Artikulo 9 (Pagtatanggi)';

  @override
  String get termsSupplementary => 'Mga Karagdagang Tuntunin';

  @override
  String get thai => 'Thai';

  @override
  String get thanksFeedback => 'Salamat sa iyong feedback!';

  @override
  String get theme => 'Tema';

  @override
  String get themeDescription =>
      'Maaari mong i-customize ang hitsura ng app ayon sa iyong gusto.';

  @override
  String get themeSettings => 'Mga Setting ng Tema';

  @override
  String get thursday => 'Huwebes';

  @override
  String get timeout => 'Oras ng Pagtigil';

  @override
  String get tired => 'Pagod';

  @override
  String get today => 'Ngayon';

  @override
  String get todayChats => 'Ngayon';

  @override
  String get todayText => 'Ngayon';

  @override
  String get tomorrowText => 'Bukas';

  @override
  String get totalConsultSessions => 'Kabuuang Sesyon ng Konsultasyon';

  @override
  String get totalErrorCount => 'Kabuuang Bilang ng Error';

  @override
  String get totalLikes => 'Kabuuang Likes';

  @override
  String totalOccurrences(Object count) {
    return 'Kabuuang $count na mga pagkakataon';
  }

  @override
  String get totalResponses => 'Kabuuang Tugon';

  @override
  String get translatedFrom => 'Isinalin mula';

  @override
  String get translatedText => 'Pagsasalin';

  @override
  String get translationError => 'Kamalian sa pagsasalin';

  @override
  String get translationErrorDescription =>
      'Pakisabi ang mga maling pagsasalin o hindi natural na mga ekspresyon';

  @override
  String get translationErrorReported =>
      'Naiulat ang kamalian sa pagsasalin. Salamat!';

  @override
  String get translationNote =>
      '※ Maaaring hindi perpekto ang pagsasalin ng AI';

  @override
  String get translationQuality => 'Kalidad ng Pagsasalin';

  @override
  String get translationSettings => 'Mga Setting ng Pagsasalin';

  @override
  String get travel => 'Maglakbay';

  @override
  String get tuesday => 'Martes';

  @override
  String get tutorialAccount => 'Tutorial na Account';

  @override
  String get tutorialWelcomeDescription =>
      'Lumikha ng espesyal na ugnayan sa mga AI persona.';

  @override
  String get tutorialWelcomeTitle => 'Maligayang pagdating sa SONA!';

  @override
  String get typeMessage => 'Mag-type ng mensahe...';

  @override
  String get unblock => 'I-unblock';

  @override
  String get unblockFailed => 'Nabigong i-unblock';

  @override
  String unblockPersonaConfirm(String name) {
    return 'I-unblock si $name?';
  }

  @override
  String get unblockedSuccessfully => 'Matagumpay na na-unblock';

  @override
  String get unexpectedLoginError =>
      'Isang hindi inaasahang error ang nangyari sa pag-login';

  @override
  String get unknown => 'Hindi Kilala';

  @override
  String get unknownError => 'Hindi kilalang Error';

  @override
  String get unlimitedMessages => 'Walang Hanggang Mensahe';

  @override
  String get unsendMessage => 'I-undo ang mensahe';

  @override
  String get usagePurpose => 'Layunin ng Paggamit';

  @override
  String get useOneHeart => 'Gumamit ng 1 Puso';

  @override
  String get useSystemLanguage => 'Gamitin ang Wika ng Sistema';

  @override
  String get user => 'Gumagamit:';

  @override
  String get userMessage => 'Mensahe ng Gumagamit:';

  @override
  String get userNotFound => 'Hindi natagpuan ang gumagamit';

  @override
  String get valentinesDay => 'Araw ng mga Puso';

  @override
  String get verifyingAuth => 'Nagsasagawa ng pagpapatunay ng awtorisasyon';

  @override
  String get version => 'Bersyon';

  @override
  String get vietnamese => 'Vietnamese';

  @override
  String get violentContent => 'Marahas na nilalaman';

  @override
  String get voiceMessage => '🎤 Mensahe ng boses';

  @override
  String waitingForChat(String name) {
    return 'Naghihintay si $name na makipag-chat.';
  }

  @override
  String get walk => 'Maglakad';

  @override
  String get wasHelpful => 'Nakakatulong ba ito?';

  @override
  String get weatherClear => 'Maliwanag';

  @override
  String get weatherCloudy => 'Maulap';

  @override
  String get weatherContext => 'Konteksto ng Panahon';

  @override
  String get weatherContextDesc =>
      'Magbigay ng konteksto ng pag-uusap batay sa panahon';

  @override
  String get weatherDrizzle => 'Ambon';

  @override
  String get weatherFog => 'Hamog';

  @override
  String get weatherMist => 'Ulap';

  @override
  String get weatherRain => 'Ulan';

  @override
  String get weatherRainy => 'Maulan';

  @override
  String get weatherSnow => 'Niyeber';

  @override
  String get weatherSnowy => 'Niyebe';

  @override
  String get weatherThunderstorm => 'Bagyo ng Kidlat';

  @override
  String get wednesday => 'Miyerkules';

  @override
  String get weekdays =>
      'Linggo,Lunes,Martes,Miyerkules,Huwebes,Biyernes,Sabado';

  @override
  String get welcomeMessage => 'Maligayang pagdating💕';

  @override
  String get whatTopicsToTalk =>
      'Anong mga paksa ang nais mong pag-usapan? (Opsyonal)';

  @override
  String get whiteDay => 'Araw ng mga Puti';

  @override
  String get winter => 'Taglamig';

  @override
  String get wrongTranslation => 'Mali ang Pagsasalin';

  @override
  String get year => 'Taon';

  @override
  String get yearEnd => 'Pagtatapos ng Taon';

  @override
  String get yes => 'Oo';

  @override
  String get yesterday => 'Kahapon';

  @override
  String get yesterdayChats => 'Kahapon';

  @override
  String get you => 'Ikaw';

  @override
  String get loadingPersonaData => 'Naglo-load ng persona data';

  @override
  String get checkingMatchedPersonas => 'Sinusuri ang mga tugmang persona';

  @override
  String get preparingImages => 'Inihahanda ang mga larawan';

  @override
  String get finalPreparation => 'Huling paghahanda';

  @override
  String get editProfileSubtitle =>
      'I-edit ang kasarian, petsa ng kapanganakan at pagpapakilala';

  @override
  String get systemThemeName => 'Sistema';

  @override
  String get lightThemeName => 'Maliwanag';

  @override
  String get darkThemeName => 'Madilim';

  @override
  String get alwaysShowTranslationOn => 'Palaging Ipakita ang Pagsasalin';

  @override
  String get alwaysShowTranslationOff => 'Itago ang Awtomatikong Pagsasalin';

  @override
  String get translationErrorAnalysisInfo =>
      'Susuriin namin ang napiling mensahe at pagsasalin.';

  @override
  String get whatWasWrongWithTranslation => 'Ano ang mali sa pagsasalin?';

  @override
  String get translationErrorHint =>
      'Hal: Maling kahulugan, hindi natural na pagpapahayag, maling konteksto...';

  @override
  String get pleaseSelectMessage => 'Pumili muna ng mensahe';

  @override
  String get myPersonas => 'Aking mga Persona';

  @override
  String get createPersona => 'Gumawa ng Persona';

  @override
  String get tellUsAboutYourPersona =>
      'Sabihin mo sa amin ang tungkol sa inyong persona';

  @override
  String get enterPersonaName => 'Ilagay ang pangalan ng persona';

  @override
  String get describeYourPersona => 'Ilarawan ang inyong persona nang maikli';

  @override
  String get profileImage => 'Larawan ng Profile';

  @override
  String get uploadPersonaImages =>
      'Mag-upload ng mga larawan para sa inyong persona';

  @override
  String get mainImage => 'Pangunahing Larawan';

  @override
  String get tapToUpload => 'I-tap para mag-upload';

  @override
  String get additionalImages => 'Karagdagang mga Larawan';

  @override
  String get addImage => 'Magdagdag ng Larawan';

  @override
  String get mbtiQuestion => 'Tanong sa Personalidad';

  @override
  String get mbtiComplete => 'Pagsusulit sa Personalidad Tapos Na!';

  @override
  String get mbtiTest => 'MBTI Test';

  @override
  String get mbtiStepDescription =>
      'Tukuyin natin kung anong personalidad ang dapat magkaroon ang iyong persona. Sagutin ang mga tanong para hubugin ang kanilang karakter.';

  @override
  String get startTest => 'Simulan ang Pagsusulit';

  @override
  String get personalitySettings => 'Mga Setting ng Personalidad';

  @override
  String get speechStyle => 'Estilo ng Pagsasalita';

  @override
  String get conversationStyle => 'Estilo ng Pag-uusap';

  @override
  String get shareWithCommunity => 'Ibahagi sa Komunidad';

  @override
  String get shareDescription =>
      'Ang inyong persona ay maiibahagi sa ibang mga user pagkatapos ma-approve';

  @override
  String get sharePersona => 'Ibahagi ang Persona';

  @override
  String get willBeSharedAfterApproval =>
      'Maiibahagi pagkatapos ng admin approval';

  @override
  String get privatePersonaDescription =>
      'Ikaw lang ang makakakita sa persona na ito';

  @override
  String get create => 'Gumawa';

  @override
  String get personaCreated => 'Matagumpay na nagawa ang persona!';

  @override
  String get createFailed => 'Hindi nagawa ang persona';

  @override
  String get pendingApproval => 'Naghihintay ng Approval';

  @override
  String get approved => 'Na-approve';

  @override
  String get privatePersona => 'Pribado';

  @override
  String get noPersonasYet => 'Walang mga Persona Pa';

  @override
  String get createYourFirstPersona =>
      'Gumawa ng inyong unang persona at simulan ang inyong paglalakbay';

  @override
  String get deletePersona => 'Tanggalin ang Persona';

  @override
  String get deletePersonaConfirm =>
      'Sigurado ba kayo na gusto ninyong tanggalin ang persona na ito?';

  @override
  String get personaDeleted => 'Matagumpay na natanggal ang persona';

  @override
  String get deleteFailed => 'Hindi natanggal';

  @override
  String get personaLimitReached => 'Naabot mo na ang limitasyon na 3 persona';

  @override
  String get personaName => 'Pangalan';

  @override
  String get personaAge => 'Edad';

  @override
  String get personaDescription => 'Paglalarawan';

  @override
  String get personaNameHint => 'Ilagay ang pangalan ng persona';

  @override
  String get personaDescriptionHint => 'Ilarawan ang persona';

  @override
  String get loginRequiredContent => 'Mag-login para magpatuloy';

  @override
  String get reportErrorButton => 'I-report ang Error';

  @override
  String get speechStyleFriendly => 'Palakaibigan';

  @override
  String get speechStylePolite => 'Magalang';

  @override
  String get speechStyleChic => 'Astig';

  @override
  String get speechStyleLively => 'Masigla';

  @override
  String get conversationStyleTalkative => 'Madaldal';

  @override
  String get conversationStyleQuiet => 'Tahimik';

  @override
  String get conversationStyleEmpathetic => 'Maawain';

  @override
  String get conversationStyleLogical => 'Lohikal';

  @override
  String get interestMusic => 'Musika';

  @override
  String get interestMovies => 'Pelikula';

  @override
  String get interestReading => 'Pagbabasa';

  @override
  String get interestTravel => 'Paglalakbay';

  @override
  String get interestExercise => 'Ehersisyo';

  @override
  String get interestGaming => 'Gaming';

  @override
  String get interestCooking => 'Pagluluto';

  @override
  String get interestFashion => 'Fashion';

  @override
  String get interestArt => 'Sining';

  @override
  String get interestPhotography => 'Pagkuha ng larawan';

  @override
  String get interestTechnology => 'Teknolohiya';

  @override
  String get interestScience => 'Agham';

  @override
  String get interestHistory => 'Kasaysayan';

  @override
  String get interestPhilosophy => 'Pilosopiya';

  @override
  String get interestPolitics => 'Pulitika';

  @override
  String get interestEconomy => 'Ekonomiya';

  @override
  String get interestSports => 'Sports';

  @override
  String get interestAnimation => 'Animation';

  @override
  String get interestKpop => 'K-POP';

  @override
  String get interestDrama => 'Drama';

  @override
  String get imageOptionalR2 =>
      'Ang mga larawan ay opsyonal. Mag-upload lamang kung naka-configure ang R2.';

  @override
  String get networkErrorCheckConnection =>
      'Network error: Pakisuri ang iyong koneksyon sa internet';

  @override
  String get maxFiveItems => 'Hanggang 5 items';

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
    return 'Magsimula ng pag-uusap kay $personaName?';
  }

  @override
  String reengagementNotificationSent(String personaName, String riskPercent) {
    return 'Ipinadala ang abiso ng muling pakikipag-ugnayan kay $personaName (Panganib: $riskPercent%)';
  }

  @override
  String get noActivePersona => 'Walang aktibong persona';
}
