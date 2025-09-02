// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Swedish (`sv`).
class AppLocalizationsSv extends AppLocalizations {
  AppLocalizationsSv([String locale = 'sv']) : super(locale);

  @override
  String get about => 'Om';

  @override
  String get accountAndProfile => 'Kontoinformation & Profilinformation';

  @override
  String get accountDeletedSuccess => 'Kontot har raderats framgångsrikt';

  @override
  String get accountDeletionContent =>
      'Är du säker på att du vill radera ditt konto?';

  @override
  String get accountDeletionError =>
      'Ett fel inträffade vid radering av kontot.';

  @override
  String get accountDeletionInfo => 'Information om kontoradering';

  @override
  String get accountDeletionTitle => 'Radera konto';

  @override
  String get accountDeletionWarning1 => 'Varning: Denna åtgärd kan inte ångras';

  @override
  String get accountDeletionWarning2 =>
      'Alla dina uppgifter kommer att raderas permanent';

  @override
  String get accountDeletionWarning3 =>
      'Du kommer att förlora tillgång till alla konversationer';

  @override
  String get accountDeletionWarning4 => 'Detta inkluderar allt köpt innehåll';

  @override
  String get accountManagement => 'Kontohantering';

  @override
  String get adaptiveConversationDesc =>
      'Anpassar samtalsstil för att matcha din';

  @override
  String get afternoon => 'Eftermiddag';

  @override
  String get afternoonFatigue => 'Eftermiddagsutmattning';

  @override
  String get ageConfirmation =>
      'Jag är 14 år eller äldre och har bekräftat ovanstående.';

  @override
  String ageRange(int min, int max) {
    return '$min-$max år';
  }

  @override
  String get ageUnit => 'år gammal';

  @override
  String get agreeToTerms => 'Jag godkänner villkoren';

  @override
  String get aiDatingQuestion => 'Ett speciellt vardagsliv med AI';

  @override
  String get aiPersonaPreferenceDescription =>
      'Vänligen ange dina preferenser för matchning av AI-personligheter';

  @override
  String get all => 'Alla';

  @override
  String get allAgree => 'Godkänn allt';

  @override
  String get allFeaturesRequired =>
      '※ Alla funktioner krävs för tjänsteleverans';

  @override
  String get allPersonas => 'Alla personligheter';

  @override
  String get allPersonasMatched =>
      'Alla personligheter matchade! Börja chatta med dem.';

  @override
  String get allowPermission => 'Fortsätt';

  @override
  String alreadyChattingWith(String name) {
    return 'Chattar redan med $name!';
  }

  @override
  String get alsoBlockThisAI => 'Blockera även denna AI';

  @override
  String get angry => 'Arg';

  @override
  String get anonymousLogin => 'Anonym inloggning';

  @override
  String get anxious => 'Orolig';

  @override
  String get apiKeyError => 'API-nyckelfel';

  @override
  String get appName => 'SONA';

  @override
  String get appTagline => 'Dina AI-kompanjoner';

  @override
  String get appleLoginCanceled =>
      'Apple-inloggningen avbröts. Vänligen försök igen.';

  @override
  String get appleLoginError => 'Ett fel inträffade under Apple-inloggningen.';

  @override
  String get art => 'Konst';

  @override
  String get authError => 'Autentiseringsfel';

  @override
  String get autoTranslate => 'Automatisk översättning';

  @override
  String get autumn => 'Höst';

  @override
  String get averageQuality => 'Genomsnittlig kvalitet';

  @override
  String get averageQualityScore => 'Genomsnittligt kvalitetsbetyg';

  @override
  String get awkwardExpression => 'Klumpigt uttryck';

  @override
  String get backButton => 'Tillbaka';

  @override
  String get basicInfo => 'Grundläggande information';

  @override
  String get basicInfoDescription =>
      'Vänligen ange grundläggande information för att skapa ett konto';

  @override
  String get birthDate => 'Födelsedatum';

  @override
  String get birthDateOptional => 'Födelsedatum (Valfritt)';

  @override
  String get birthDateRequired => 'Födelsedatum *';

  @override
  String get blockConfirm => 'Vill du blockera denna AI?';

  @override
  String get blockReason => 'Blockeringsorsak';

  @override
  String get blockThisAI => 'Blockera denna AI';

  @override
  String blockedAICount(int count) {
    return '$count blockerade AI:er';
  }

  @override
  String get blockedAIs => 'Blockerade AI:er';

  @override
  String get blockedAt => 'Blockerad vid';

  @override
  String get blockedSuccessfully => 'Blockerad framgångsrikt';

  @override
  String get breakfast => 'Frukost';

  @override
  String get byErrorType => 'Efter feltyp';

  @override
  String get byPersona => 'Efter persona';

  @override
  String cacheDeleteError(String error) {
    return 'Cache-raderingsfel: $error';
  }

  @override
  String get cacheDeleted => 'Bildcache har raderats';

  @override
  String get cafeTerrace => 'Caféterrass';

  @override
  String get calm => 'Lugnt';

  @override
  String get cameraPermission => 'Kamerabehörighet';

  @override
  String get cameraPermissionDesc =>
      'Kameråtkomst krävs för att ta profilbilder.';

  @override
  String get canChangeInSettings =>
      'Du kan ändra detta senare i inställningarna';

  @override
  String get canMeetPreviousPersonas => 'Du kan träffa personas';

  @override
  String get cancel => 'Avbryt';

  @override
  String get changeProfilePhoto => 'Ändra profilbild';

  @override
  String get chat => 'Chatt';

  @override
  String get chatEndedMessage => 'Chatten har avslutats';

  @override
  String get chatErrorDashboard => 'Chattfel Dashboard';

  @override
  String get chatErrorSentSuccessfully =>
      'Chattfelet har skickats framgångsrikt.';

  @override
  String get chatListTab => 'Chattlista Flik';

  @override
  String get chats => 'Chattar';

  @override
  String chattingWithPersonas(int count) {
    return 'Chattar med $count personas';
  }

  @override
  String get checkInternetConnection =>
      'Vänligen kontrollera din internetanslutning';

  @override
  String get checkingUserInfo => 'Kontrollerar användarinformation';

  @override
  String get childrensDay => 'Barnens Dag';

  @override
  String get chinese => 'Kinesiska';

  @override
  String get chooseOption => 'Vänligen välj:';

  @override
  String get christmas => 'Jul';

  @override
  String get close => 'Stäng';

  @override
  String get complete => 'Komplett';

  @override
  String get completeSignup => 'Slutför registreringen';

  @override
  String get confirm => 'Bekräfta';

  @override
  String get connectingToServer => 'Ansluter till servern';

  @override
  String get consultQualityMonitoring => 'Kvalitetsövervakning av konsultation';

  @override
  String get continueAsGuest => 'Fortsätt som gäst';

  @override
  String get continueButton => 'Fortsätt';

  @override
  String get continueWithApple => 'Fortsätt med Apple';

  @override
  String get continueWithGoogle => 'Fortsätt med Google';

  @override
  String get conversationContinuity => 'Konversationskontinuitet';

  @override
  String get conversationContinuityDesc =>
      'Kom ihåg tidigare konversationer och koppla ämnen';

  @override
  String conversationWith(String name) {
    return '$name';
  }

  @override
  String get convertToMember => 'Registrera dig';

  @override
  String get cooking => 'Matlagning';

  @override
  String get copyMessage => 'Kopiera meddelande';

  @override
  String get copyrightInfringement => 'Upphovsrättsintrång';

  @override
  String get creatingAccount => 'Skapar konto';

  @override
  String get crisisDetected => 'Kris upptäckt';

  @override
  String get culturalIssue => 'Kulturellt problem';

  @override
  String get current => 'Aktuell';

  @override
  String get currentCacheSize => 'Nuvarande cache-storlek';

  @override
  String get currentLanguage => 'Nuvarande språk';

  @override
  String get cycling => 'Cykling';

  @override
  String get dailyCare => 'Daglig vård';

  @override
  String get dailyCareDesc =>
      'Dagliga vårdmeddelanden för måltider, sömn, hälsa';

  @override
  String get dailyChat => 'Daglig chatt';

  @override
  String get dailyCheck => 'Daglig kontroll';

  @override
  String get dailyConversation => 'Daglig konversation';

  @override
  String get dailyLimitDescription => 'Du har nått din dagliga meddelandelimit';

  @override
  String get dailyLimitTitle => 'Daglig gräns nådd';

  @override
  String get darkMode => 'Mörkt läge';

  @override
  String get darkTheme => 'Mörkt tema';

  @override
  String get darkThemeDesc => 'Använd mörkt tema';

  @override
  String get dataCollection => 'Inställningar för datainsamling';

  @override
  String get datingAdvice => 'Dejtingråd';

  @override
  String get datingDescription =>
      'Jag vill dela djupa tankar och ha uppriktiga samtal';

  @override
  String get dawn => 'Gryning';

  @override
  String get day => 'Dag';

  @override
  String get dayAfterTomorrow => 'Övermorgon';

  @override
  String daysAgo(int count, String formatted) {
    return '$count dagar sedan';
  }

  @override
  String daysRemaining(int days) {
    return '$days dagar kvar';
  }

  @override
  String get deepTalk => 'Djupa samtal';

  @override
  String get delete => 'Radera';

  @override
  String get deleteAccount => 'Ta bort konto';

  @override
  String get deleteAccountConfirm =>
      'Är du säker på att du vill ta bort ditt konto? Denna åtgärd kan inte ångras.';

  @override
  String get deleteAccountWarning =>
      'Är du säker på att du vill ta bort ditt konto?';

  @override
  String get deleteCache => 'Ta bort cache';

  @override
  String get deletingAccount => 'Tar bort konto...';

  @override
  String get depressed => 'Deprimerad';

  @override
  String get describeError => 'Vad är problemet?';

  @override
  String get detailedReason => 'Detaljerad anledning';

  @override
  String get developRelationshipStep =>
      '3. Utveckla relation: Bygg intimitet genom samtal och utveckla speciella relationer.';

  @override
  String get dinner => 'Middag';

  @override
  String get discardGuestData => 'Börja om';

  @override
  String get discount20 => '20% rabatt';

  @override
  String get discount30 => '30% rabatt';

  @override
  String get discountAmount => 'Spara';

  @override
  String discountAmountValue(String amount) {
    return 'Spara ₩$amount';
  }

  @override
  String get done => 'Klar';

  @override
  String get downloadingPersonaImages => 'Laddar ner nya persona-bilder';

  @override
  String get edit => 'Redigera';

  @override
  String get editInfo => 'Redigera information';

  @override
  String get editProfile => 'Redigera profil';

  @override
  String get effectSound => 'Ljud effekter';

  @override
  String get effectSoundDescription => 'Spela ljud effekter';

  @override
  String get email => 'E-post';

  @override
  String get emailHint => 'exempel@email.com';

  @override
  String get emailLabel => 'E-post';

  @override
  String get emailRequired => 'E-post *';

  @override
  String get emotionAnalysis => 'Emotionanalys';

  @override
  String get emotionAnalysisDesc => 'Analysera känslor för empatiska svar';

  @override
  String get emotionAngry => 'Arg';

  @override
  String get emotionBasedEncounters => 'Möt personer baserat på dina känslor';

  @override
  String get emotionCool => 'Cool';

  @override
  String get emotionHappy => 'Glad';

  @override
  String get emotionLove => 'Kärlek';

  @override
  String get emotionSad => 'Ledsen';

  @override
  String get emotionThinking => 'Tänker';

  @override
  String get emotionalSupportDesc => 'Dela dina bekymmer och få varm tröst';

  @override
  String get endChat => 'Avsluta chatt';

  @override
  String get endTutorial => 'Avsluta handledning';

  @override
  String get endTutorialAndLogin => 'Avsluta handledning och logga in?';

  @override
  String get endTutorialMessage =>
      'Vill du avsluta handledningen och logga in?';

  @override
  String get english => 'Engelska';

  @override
  String get enterBasicInfo =>
      'Vänligen ange grundläggande information för att skapa ett konto';

  @override
  String get enterBasicInformation => 'Vänligen ange grundläggande information';

  @override
  String get enterEmail => 'Vänligen ange e-post';

  @override
  String get enterNickname => 'Vänligen ange ett smeknamn';

  @override
  String get enterPassword => 'Vänligen ange ett lösenord';

  @override
  String get entertainmentAndFunDesc =>
      'Njut av roliga spel och trevliga samtal';

  @override
  String get entertainmentDescription =>
      'Jag vill ha roliga samtal och njuta av min tid';

  @override
  String get entertainmentFun => 'Underhållning/Roligt';

  @override
  String get error => 'Fel';

  @override
  String get errorDescription => 'Felbeskrivning';

  @override
  String get errorDescriptionHint =>
      't.ex., Gav konstiga svar, Upprepar samma sak, Ger kontextuellt olämpliga svar...';

  @override
  String get errorDetails => 'Felinformation';

  @override
  String get errorDetailsHint => 'Vänligen förklara i detalj vad som är fel';

  @override
  String get errorFrequency24h => 'Felaktighetsfrekvens (Senaste 24 timmarna)';

  @override
  String get errorMessage => 'Ett fel uppstod';

  @override
  String get errorOccurred => 'Ett fel inträffade.';

  @override
  String get errorOccurredTryAgain =>
      'Ett fel inträffade. Vänligen försök igen.';

  @override
  String get errorSendingFailed => 'Misslyckades med att skicka fel';

  @override
  String get errorStats => 'Felstatistik';

  @override
  String errorWithMessage(String error) {
    return 'Fel uppstod: $error';
  }

  @override
  String get evening => 'Kväll';

  @override
  String get excited => 'Exalterad';

  @override
  String get exit => 'Gå ut';

  @override
  String get exitApp => 'Avsluta app';

  @override
  String get exitConfirmMessage => 'Är du säker på att du vill avsluta appen?';

  @override
  String get expertPersona => 'Expertpersona';

  @override
  String get expertiseScore => 'Expertpoäng';

  @override
  String get expired => 'Utgången';

  @override
  String get explainReportReason =>
      'Vänligen förklara rapporteringsorsaken i detalj';

  @override
  String get fashion => 'Mode';

  @override
  String get female => 'Kvinna';

  @override
  String get filter => 'Filtrera';

  @override
  String get firstOccurred => 'Första gången inträffade:';

  @override
  String get followDeviceLanguage => 'Följ enhetens språkinställningar';

  @override
  String get forenoon => 'Förmiddag';

  @override
  String get forgotPassword => 'Glömt lösenord?';

  @override
  String get frequentlyAskedQuestions => 'Vanliga frågor';

  @override
  String get friday => 'Fredag';

  @override
  String get friendshipDescription =>
      'Jag vill träffa nya vänner och ha samtal';

  @override
  String get funChat => 'Rolig chatt';

  @override
  String get galleryPermission => 'Galleriåtkomst';

  @override
  String get galleryPermissionDesc =>
      'Åtkomst till galleriet krävs för att välja profilbilder.';

  @override
  String get gaming => 'Spelande';

  @override
  String get gender => 'Kön';

  @override
  String get genderNotSelectedInfo =>
      'Om kön inte är valt kommer personas av alla kön att visas';

  @override
  String get genderOptional => 'Kön (Valfritt)';

  @override
  String get genderPreferenceActive => 'Du kan träffa personas av alla kön';

  @override
  String get genderPreferenceDisabled =>
      'Välj ditt kön för att aktivera alternativet endast motsatt kön';

  @override
  String get genderPreferenceInactive =>
      'Endast personas av motsatt kön kommer att visas';

  @override
  String get genderRequired => 'Kön *';

  @override
  String get genderSelectionInfo =>
      'Om det inte väljs kan du träffa personas av alla kön';

  @override
  String get generalPersona => 'Allmän Persona';

  @override
  String get goToSettings => 'Gå till Inställningar';

  @override
  String get googleLoginCanceled => 'Google-inloggning avbröts.';

  @override
  String get googleLoginError => 'Ett fel inträffade under Google-inloggning.';

  @override
  String get grantPermission => 'Fortsätt';

  @override
  String get guest => 'Gäst';

  @override
  String get guestDataMigration =>
      'Vill du behålla din nuvarande chatt-historik när du registrerar dig?';

  @override
  String get guestLimitReached => 'Gästprovet har avslutats.';

  @override
  String get guestLoginPromptMessage =>
      'Logga in för att fortsätta konversationen';

  @override
  String get guestMessageExhausted => 'Gratis meddelanden är slut';

  @override
  String guestMessageRemaining(int count) {
    return '$count gästmeddelanden kvar';
  }

  @override
  String get guestModeBanner => 'Gästläge';

  @override
  String get guestModeDescription => 'Prova SONA utan att registrera dig';

  @override
  String get guestModeFailedMessage => 'Misslyckades med att starta Gästläge';

  @override
  String get guestModeLimitation => 'Vissa funktioner är begränsade i Gästläge';

  @override
  String get guestModeTitle => 'Prova som Gäst';

  @override
  String get guestModeWarning => 'Gästläget varar i 24 timmar,';

  @override
  String get guestModeWelcome => 'Startar i Gästläge';

  @override
  String get happy => 'Glad';

  @override
  String get hapticFeedback => 'Haptisk feedback';

  @override
  String get harassmentBullying => 'Trakasserier/Mobbning';

  @override
  String get hateSpeech => 'Hets mot folkgrupp';

  @override
  String get heartDescription => 'Hjärtan för fler meddelanden';

  @override
  String get heartInsufficient => 'Inte tillräckligt med hjärtan';

  @override
  String get heartInsufficientPleaseCharge =>
      'Inte tillräckligt med hjärtan. Vänligen ladda hjärtan.';

  @override
  String get heartRequired => '1 hjärta krävs';

  @override
  String get heartUsageFailed => 'Misslyckades med att använda hjärtat.';

  @override
  String get hearts => 'Hjärtor';

  @override
  String get hearts10 => '10 Hjärtor';

  @override
  String get hearts30 => '30 Hjärtor';

  @override
  String get hearts30Discount => 'REA';

  @override
  String get hearts50 => '50 Hjärtor';

  @override
  String get hearts50Discount => 'REA';

  @override
  String get helloEmoji => 'Hej! 😊';

  @override
  String get help => 'Hjälp';

  @override
  String get hideOriginalText => 'Dölja original';

  @override
  String get hobbySharing => 'Hobby Dela';

  @override
  String get hobbyTalk => 'Hobby Prat';

  @override
  String get hours24Ago => 'För 24 timmar sedan';

  @override
  String hoursAgo(int count, String formatted) {
    return 'För $count timmar sedan';
  }

  @override
  String get howToUse => 'Hur man använder SONA';

  @override
  String get imageCacheManagement => 'Hantering av bildcache';

  @override
  String get inappropriateContent => 'Olämpligt innehåll';

  @override
  String get incorrect => 'Felaktig';

  @override
  String get incorrectPassword => 'Felaktigt lösenord';

  @override
  String get indonesian => 'Indonesiska';

  @override
  String get inquiries => 'Förfrågningar';

  @override
  String get insufficientHearts => 'Otillräckliga hjärtan.';

  @override
  String get interestSharing => 'Intressedelning';

  @override
  String get interestSharingDesc => 'Upptäck och rekommendera delade intressen';

  @override
  String get interests => 'Intressen';

  @override
  String get invalidEmailFormat => 'Ogiltigt e-postformat';

  @override
  String get invalidEmailFormatError => 'Vänligen ange en giltig e-postadress';

  @override
  String isTyping(String name) {
    return '$name skriver...';
  }

  @override
  String get japanese => 'Japanska';

  @override
  String get joinDate => 'Gå med datum';

  @override
  String get justNow => 'Nyss';

  @override
  String get keepGuestData => 'Behåll chattens historik';

  @override
  String get korean => 'Koreanska';

  @override
  String get koreanLanguage => 'Koreanska';

  @override
  String get language => 'Språk';

  @override
  String get languageDescription => 'AI kommer att svara på ditt valda språk';

  @override
  String get languageIndicator => 'Språk';

  @override
  String get languageSettings => 'Språkinställningar';

  @override
  String get lastOccurred => 'Senast inträffat:';

  @override
  String get lastUpdated => 'Senast uppdaterad';

  @override
  String get lateNight => 'Sen kväll';

  @override
  String get later => 'Senare';

  @override
  String get laterButton => 'Senare';

  @override
  String get leave => 'Lämna';

  @override
  String get leaveChatConfirm => 'Lämna denna chatt?';

  @override
  String get leaveChatRoom => 'Lämna chattrum';

  @override
  String get leaveChatTitle => 'Lämna chatt';

  @override
  String get lifeAdvice => 'Livsråd';

  @override
  String get lightTalk => 'Lätt prat';

  @override
  String get lightTheme => 'Ljust läge';

  @override
  String get lightThemeDesc => 'Använd ljus tema';

  @override
  String get loading => 'Laddar...';

  @override
  String get loadingData => 'Laddar data...';

  @override
  String get loadingProducts => 'Laddar produkter...';

  @override
  String get loadingProfile => 'Laddar profil';

  @override
  String get login => 'Logga in';

  @override
  String get loginButton => 'Logga in';

  @override
  String get loginCancelled => 'Inloggning avbruten';

  @override
  String get loginComplete => 'Inloggning slutförd';

  @override
  String get loginError => 'Inloggning misslyckades';

  @override
  String get loginFailed => 'Inloggning misslyckades';

  @override
  String get loginFailedTryAgain =>
      'Inloggning misslyckades. Vänligen försök igen.';

  @override
  String get loginRequired => 'Inloggning krävs';

  @override
  String get loginRequiredForProfile => 'Inloggning krävs för att se profil';

  @override
  String get loginRequiredService =>
      'Inloggning krävs för att använda denna tjänst';

  @override
  String get loginRequiredTitle => 'Inloggning krävs';

  @override
  String get loginSignup => 'Inloggning/Registrera';

  @override
  String get loginTab => 'Inloggning';

  @override
  String get loginTitle => 'Inloggning';

  @override
  String get loginWithApple => 'Inloggning med Apple';

  @override
  String get loginWithGoogle => 'Logga in med Google';

  @override
  String get logout => 'Logga ut';

  @override
  String get logoutConfirm => 'Är du säker på att du vill logga ut?';

  @override
  String get lonelinessRelief => 'Lättnad från ensamhet';

  @override
  String get lonely => 'Ensam';

  @override
  String get lowQualityResponses => 'Lågkvalitativa svar';

  @override
  String get lunch => 'Lunch';

  @override
  String get lunchtime => 'Lunchtid';

  @override
  String get mainErrorType => 'Huvudfeltyp';

  @override
  String get makeFriends => 'Skapa vänner';

  @override
  String get male => 'Man';

  @override
  String get manageBlockedAIs => 'Hantera blockerade AI:er';

  @override
  String get managePersonaImageCache => 'Hantera persona bildcache';

  @override
  String get marketingAgree => 'Godkänn marknadsföringsinformation (valfritt)';

  @override
  String get marketingDescription =>
      'Du kan ta emot information om evenemang och förmåner';

  @override
  String get matchPersonaStep =>
      '1. Matcha personas: Svep vänster eller höger för att välja dina favorit AI-personas.';

  @override
  String get matchedPersonas => 'Matchade personas';

  @override
  String get matchedSona => 'Matchad Sona';

  @override
  String get matching => 'Matchning';

  @override
  String get matchingFailed => 'Matchning misslyckades.';

  @override
  String get me => 'Me';

  @override
  String get meetAIPersonas => 'Möt AI-personor';

  @override
  String get meetNewPersonas => 'Möt nya personor';

  @override
  String get meetPersonas => 'Möt personor';

  @override
  String get memberBenefits =>
      'Få 100+ meddelanden och 10 hjärtan när du registrerar dig!';

  @override
  String get memoryAlbum => 'Minnessalbum';

  @override
  String get memoryAlbumDesc =>
      'Spara och återkalla speciella ögonblick automatiskt';

  @override
  String get messageCopied => 'Meddelande kopierat';

  @override
  String get messageDeleted => 'Meddelande raderat';

  @override
  String get messageLimitReset =>
      'Meddelandegräns kommer att återställas vid midnatt';

  @override
  String get messageSendFailed =>
      'Misslyckades med att skicka meddelande. Vänligen försök igen.';

  @override
  String get messagesRemaining => 'Återstående meddelanden';

  @override
  String minutesAgo(int count, String formatted) {
    return '$count minuter sedan';
  }

  @override
  String get missingTranslation => 'Saknad översättning';

  @override
  String get monday => 'Måndag';

  @override
  String get month => 'Månad';

  @override
  String monthDay(String month, int day) {
    return '$month $day';
  }

  @override
  String get moreButton => 'Mer';

  @override
  String get morning => 'Morgon';

  @override
  String get mostFrequentError => 'Mest Frekvent Fel';

  @override
  String get movies => 'Filmer';

  @override
  String get multilingualChat => 'Flerspråkig Chatt';

  @override
  String get music => 'Musik';

  @override
  String get myGenderSection => 'Mitt Kön (Valfritt)';

  @override
  String get networkErrorOccurred => 'Ett nätverksfel inträffade.';

  @override
  String get newMessage => 'Nytt meddelande';

  @override
  String newMessageCount(int count) {
    return '$count nya meddelanden';
  }

  @override
  String get newMessageNotification => 'Meddela mig om nya meddelanden';

  @override
  String get newMessages => 'Nya meddelanden';

  @override
  String get newYear => 'Nytt år';

  @override
  String get next => 'Nästa';

  @override
  String get niceToMeetYou => 'Trevligt att träffas!';

  @override
  String get nickname => 'Smeknamn';

  @override
  String get nicknameAlreadyUsed => 'Det här smeknamnet används redan';

  @override
  String get nicknameHelperText => '3-10 tecken';

  @override
  String get nicknameHint => '3-10 tecken';

  @override
  String get nicknameInUse => 'Det här smeknamnet används redan';

  @override
  String get nicknameLabel => 'Smeknamn';

  @override
  String get nicknameLengthError => 'Smeknamnet måste vara 3-10 tecken';

  @override
  String get nicknamePlaceholder => 'Ange ditt smeknamn';

  @override
  String get nicknameRequired => 'Smeknamn *';

  @override
  String get night => 'Natt';

  @override
  String get no => 'Nej';

  @override
  String get noBlockedAIs => 'Inga blockerade AI:er';

  @override
  String get noChatsYet => 'Inga chattar än';

  @override
  String get noConversationYet => 'Ingen konversation än';

  @override
  String get noErrorReports => 'Inga felrapporter.';

  @override
  String get noImageAvailable => 'Ingen bild tillgänglig';

  @override
  String get noMatchedPersonas => 'Inga matchade personas än';

  @override
  String get noMatchedSonas => 'Inga matchade Sonas än';

  @override
  String get noPersonasAvailable =>
      'Inga personas tillgängliga. Vänligen försök igen.';

  @override
  String get noPersonasToSelect => 'Inga personas tillgängliga';

  @override
  String get noQualityIssues => 'Inga kvalitetsproblem den senaste timmen ✅';

  @override
  String get noQualityLogs => 'Inga kvalitetsloggar än.';

  @override
  String get noTranslatedMessages => 'Inga meddelanden att översätta';

  @override
  String get notEnoughHearts => 'Inte tillräckligt med hjärtan';

  @override
  String notEnoughHeartsCount(int count) {
    return 'Inte tillräckligt med hjärtan. (Aktuell: $count)';
  }

  @override
  String get notRegistered => 'inte registrerad';

  @override
  String get notSubscribed => 'Inte prenumererad';

  @override
  String get notificationPermissionDesc =>
      'Meddelandebehörighet krävs för att ta emot nya meddelanden.';

  @override
  String get notificationPermissionRequired => 'Meddelandebehörighet krävs';

  @override
  String get notificationSettings => 'Meddelandeinställningar';

  @override
  String get notifications => 'Meddelanden';

  @override
  String get occurrenceInfo => 'Förekomstinformation:';

  @override
  String get olderChats => 'Äldre';

  @override
  String get onlyOppositeGenderNote =>
      'Om avmarkerad, visas endast personor av motsatt kön';

  @override
  String get openSettings => 'Öppna inställningar';

  @override
  String get optional => 'Valfri';

  @override
  String get or => 'or';

  @override
  String get originalPrice => 'Original';

  @override
  String get originalText => 'Original';

  @override
  String get other => 'Annat';

  @override
  String get otherError => 'Annan fel';

  @override
  String get others => 'Andra';

  @override
  String get ownedHearts => 'Ägda hjärtan';

  @override
  String get parentsDay => 'Föräldrars dag';

  @override
  String get password => 'Lösenord';

  @override
  String get passwordConfirmation => 'Ange lösenord för att bekräfta';

  @override
  String get passwordConfirmationDesc =>
      'Vänligen ange ditt lösenord igen för att radera kontot.';

  @override
  String get passwordHint => '6 tecken eller fler';

  @override
  String get passwordLabel => 'Lösenord';

  @override
  String get passwordRequired => 'Lösenord *';

  @override
  String get passwordResetEmailPrompt =>
      'Vänligen ange din e-post för att återställa lösenordet';

  @override
  String get passwordResetEmailSent =>
      'Återställningsmejl för lösenord har skickats. Vänligen kontrollera din e-post.';

  @override
  String get passwordText => 'lösenord';

  @override
  String get passwordTooShort => 'Lösenordet måste vara minst 6 tecken';

  @override
  String get permissionDenied => 'Åtkomst nekad';

  @override
  String permissionDeniedMessage(String permissionName) {
    return '$permissionName behörighet nekades.\nTillåt behörigheten i inställningar.';
  }

  @override
  String get permissionDeniedTryLater =>
      'Åtkomst nekad. Vänligen försök igen senare.';

  @override
  String get permissionRequired => 'Åtkomst krävs';

  @override
  String get personaGenderSection => 'Preferens för kön i persona';

  @override
  String get personaQualityStats => 'Kvalitetsstatistik för persona';

  @override
  String get personalInfoExposure => 'Utlämnande av personlig information';

  @override
  String get personality => 'Personlighet';

  @override
  String get pets => 'Husdjur';

  @override
  String get photo => 'Foto';

  @override
  String get photography => 'Fotografi';

  @override
  String get picnic => 'Picknick';

  @override
  String get preferenceSettings => 'Inställningar för preferenser';

  @override
  String get preferredLanguage => 'Föredraget språk';

  @override
  String get preparingForSleep => 'Förbereder för sömn';

  @override
  String get preparingNewMeeting => 'Förbereder ny möte';

  @override
  String get preparingPersonaImages => 'Förbereder persona bilder';

  @override
  String get preparingPersonas => 'Förbereder personas';

  @override
  String get preview => 'Förhandsgranska';

  @override
  String get previous => 'Föregående';

  @override
  String get privacy => 'Integritetspolicy';

  @override
  String get privacyPolicy => 'Integritetspolicy';

  @override
  String get privacyPolicyAgreement => 'Vänligen godkänn integritetspolicyn';

  @override
  String get privacySection1Content =>
      'Vi är engagerade i att skydda din integritet. Denna integritetspolicy förklarar hur vi samlar in, använder och skyddar din information när du använder vår tjänst.';

  @override
  String get privacySection1Title =>
      '1. Syfte med insamling och användning av personlig information';

  @override
  String get privacySection2Content =>
      'Vi samlar in information som du direkt tillhandahåller oss, såsom när du skapar ett konto, uppdaterar din profil eller använder våra tjänster.';

  @override
  String get privacySection2Title => 'Information Vi Samlar In';

  @override
  String get privacySection3Content =>
      'Vi använder den information vi samlar in för att tillhandahålla, underhålla och förbättra våra tjänster, samt för att kommunicera med dig.';

  @override
  String get privacySection3Title =>
      '3. Bevarande och Användningsperiod för Personlig Information';

  @override
  String get privacySection4Content =>
      'Vi säljer, handlar med eller på annat sätt överför inte din personliga information till tredje part utan ditt samtycke.';

  @override
  String get privacySection4Title =>
      '4. Tillhandahållande av Personlig Information till Tredje Parter';

  @override
  String get privacySection5Content =>
      'Vi vidtar lämpliga säkerhetsåtgärder för att skydda din personliga information mot obehörig åtkomst, ändring, avslöjande eller förstörelse.';

  @override
  String get privacySection5Title =>
      '5. Tekniska Skyddsåtgärder för Personlig Information';

  @override
  String get privacySection6Content =>
      'Vi behåller personlig information så länge som nödvändigt för att tillhandahålla våra tjänster och uppfylla lagliga skyldigheter.';

  @override
  String get privacySection6Title => '6. Användarrättigheter';

  @override
  String get privacySection7Content =>
      'Du har rätt att få tillgång till, uppdatera eller radera din personliga information när som helst genom dina kontoinställningar.';

  @override
  String get privacySection7Title => 'Dina Rättigheter';

  @override
  String get privacySection8Content =>
      'Om du har några frågor om denna integritetspolicy, vänligen kontakta oss på support@sona.com.';

  @override
  String get privacySection8Title => 'Kontakta Oss';

  @override
  String get privacySettings => 'Integritetsinställningar';

  @override
  String get privacySettingsInfo =>
      'Att inaktivera individuella funktioner kommer att göra dessa tjänster otillgängliga.';

  @override
  String get privacySettingsScreen => 'Integritetsinställningar';

  @override
  String get problemMessage => 'Problem';

  @override
  String get problemOccurred => 'Problem uppstod';

  @override
  String get profile => 'Profil';

  @override
  String get profileEdit => 'Redigera profil';

  @override
  String get profileEditLoginRequiredMessage =>
      'Inloggning krävs för att redigera din profil. Vill du gå till inloggningsskärmen?';

  @override
  String get profileInfo => 'Profilinformation';

  @override
  String get profileInfoDescription =>
      'Vänligen ange din profilbild och grundläggande information';

  @override
  String get profileNav => 'Profil';

  @override
  String get profilePhoto => 'Profilfoto';

  @override
  String get profilePhotoAndInfo =>
      'Vänligen ange profilfoto och grundläggande information';

  @override
  String get profilePhotoUpdateFailed =>
      'Misslyckades med att uppdatera profilfoto';

  @override
  String get profilePhotoUpdated => 'Profilfoto uppdaterat';

  @override
  String get profileSettings => 'Profilinställningar';

  @override
  String get profileSetup => 'Ställer in profil';

  @override
  String get profileUpdateFailed => 'Misslyckades med att uppdatera profil';

  @override
  String get profileUpdated => 'Profilen har uppdaterats framgångsrikt';

  @override
  String get purchaseAndRefundPolicy => 'Köpe- och återbetalningspolicy';

  @override
  String get purchaseButton => 'Köp';

  @override
  String get purchaseConfirm => 'Köpbekräftelse';

  @override
  String purchaseConfirmContent(String product, String price) {
    return 'Du kommer att köpa $product för $price';
  }

  @override
  String purchaseConfirmMessage(
      String title, String price, String description) {
    return 'Bekräfta köp av $title för $price? $description';
  }

  @override
  String get purchaseFailed => 'Köpet misslyckades';

  @override
  String get purchaseHeartsOnly => 'Köp hjärtan';

  @override
  String get purchaseMoreHearts =>
      'Köp hjärtan för att fortsätta konversationerna';

  @override
  String get purchasePending => 'Köpet är under behandling...';

  @override
  String get purchasePolicy => 'Köpvillkor';

  @override
  String get purchaseSection1Content =>
      'Vi accepterar olika betalningsmetoder inklusive kreditkort och digitala plånböcker.';

  @override
  String get purchaseSection1Title => 'Betalningsmetoder';

  @override
  String get purchaseSection2Content =>
      'Återbetalningar är tillgängliga inom 14 dagar efter köp om du inte har använt de köpta artiklarna.';

  @override
  String get purchaseSection2Title => 'Återbetalningspolicy';

  @override
  String get purchaseSection3Content =>
      'Du kan avbryta din prenumeration när som helst genom dina kontoinställningar.';

  @override
  String get purchaseSection3Title => 'Avbokning';

  @override
  String get purchaseSection4Content =>
      'Genom att göra ett köp godkänner du våra användarvillkor och serviceavtal.';

  @override
  String get purchaseSection4Title => 'Användarvillkor';

  @override
  String get purchaseSection5Content =>
      'För köprelaterade frågor, vänligen kontakta vårt supportteam.';

  @override
  String get purchaseSection5Title => 'Kontakta Support';

  @override
  String get purchaseSection6Content =>
      'Alla köp omfattas av våra standardvillkor.';

  @override
  String get purchaseSection6Title => '6. Förfrågningar';

  @override
  String get pushNotifications => 'Push-notiser';

  @override
  String get reading => 'Läsning';

  @override
  String get realtimeQualityLog => 'Realtidskvalitetslogg';

  @override
  String get recentConversation => 'Senaste konversationen:';

  @override
  String get recentLoginRequired => 'Vänligen logga in igen av säkerhetsskäl';

  @override
  String get referrerEmail => 'Referrer E-post';

  @override
  String get referrerEmailHelper =>
      'Valfritt: E-postadress till den som hänvisade dig';

  @override
  String get referrerEmailLabel => 'Referrer E-post (Valfritt)';

  @override
  String get refresh => 'Uppdatera';

  @override
  String refreshComplete(int count) {
    return 'Uppdatering av $count objekt slutförd';
  }

  @override
  String get refreshFailed => 'Uppdatering misslyckades';

  @override
  String get refreshingChatList => 'Uppdaterar chattlista...';

  @override
  String get relatedFAQ => 'Relaterade vanliga frågor';

  @override
  String get report => 'Rapportera';

  @override
  String get reportAI => 'Rapportera';

  @override
  String get reportAIDescription =>
      'Om AI:n gjorde dig obekväm, vänligen beskriv problemet.';

  @override
  String get reportAITitle => 'Rapportera AI-konversation';

  @override
  String get reportAndBlock => 'Rapportera & Blockera';

  @override
  String get reportAndBlockDescription =>
      'Du kan rapportera och blockera olämpligt beteende från denna AI';

  @override
  String get reportChatError => 'Rapportera chattfel';

  @override
  String reportError(String error) {
    return 'Rapporteringsfel: $error';
  }

  @override
  String get reportFailed => 'Rapporteringen misslyckades';

  @override
  String get reportSubmitted =>
      'Rapporten har skickats. Vi kommer att granska och vidta åtgärder.';

  @override
  String get reportSubmittedSuccess => 'Din rapport har skickats in. Tack!';

  @override
  String get requestLimit => 'Begärningsgräns';

  @override
  String get required => 'Krävs';

  @override
  String get requiredTermsAgreement => 'Vänligen godkänn villkoren';

  @override
  String get restartConversation => 'Starta om konversation';

  @override
  String restartConversationQuestion(String name) {
    return 'Vill du starta om konversationen med $name?';
  }

  @override
  String restartConversationWithName(String name) {
    return 'Startar om konversationen med $name!';
  }

  @override
  String get retry => 'Försök igen';

  @override
  String get retryButton => 'Försök igen';

  @override
  String get sad => 'Ledsen';

  @override
  String get saturday => 'Lördag';

  @override
  String get save => 'Spara';

  @override
  String get search => 'Sök';

  @override
  String get searchFAQ => 'Sök i FAQ...';

  @override
  String get searchResults => 'Sökresultat';

  @override
  String get selectEmotion => 'Välj känsla';

  @override
  String get selectErrorType => 'Välj feltyp';

  @override
  String get selectFeeling => 'Välj känsla';

  @override
  String get selectGender => 'Vänligen välj kön';

  @override
  String get selectInterests => 'Vänligen välj dina intressen (minst 1)';

  @override
  String get selectLanguage => 'Välj språk';

  @override
  String get selectPersona => 'Välj en persona';

  @override
  String get selectPersonaPlease => 'Vänligen välj en persona.';

  @override
  String get selectPreferredMbti =>
      'Om du föredrar personas med specifika MBTI-typer, vänligen välj';

  @override
  String get selectProblematicMessage =>
      'Välj det problematiska meddelandet (valfritt)';

  @override
  String get selectReportReason => 'Välj rapporteringsorsak';

  @override
  String get selectTheme => 'Välj tema';

  @override
  String get selectTranslationError =>
      'Vänligen välj ett meddelande med översättningsfel';

  @override
  String get selectUsagePurpose =>
      'Vänligen välj ditt syfte med att använda SONA';

  @override
  String get selfIntroduction => 'Introduktion (Valfritt)';

  @override
  String get selfIntroductionHint => 'Skriv en kort introduktion om dig själv';

  @override
  String get send => 'Skicka';

  @override
  String get sendChatError => 'Skicka chattfel';

  @override
  String get sendFirstMessage => 'Skicka ditt första meddelande';

  @override
  String get sendReport => 'Skicka rapport';

  @override
  String get sendingEmail => 'Skickar e-post...';

  @override
  String get seoul => 'Seoul';

  @override
  String get serverErrorDashboard => 'Serverfel';

  @override
  String get serviceTermsAgreement => 'Vänligen godkänn användarvillkoren';

  @override
  String get sessionExpired => 'Sessionen har gått ut';

  @override
  String get setAppInterfaceLanguage => 'Ställ in appens gränssnittsspråk';

  @override
  String get setNow => 'Ställ in nu';

  @override
  String get settings => 'Inställningar';

  @override
  String get sexualContent => 'Sexuellt innehåll';

  @override
  String get showAllGenderPersonas => 'Visa alla könsidentiteter';

  @override
  String get showAllGendersOption => 'Visa alla kön';

  @override
  String get showOppositeGenderOnly =>
      'Om avmarkerad, kommer endast motsatt könsidentiteter att visas';

  @override
  String get showOriginalText => 'Visa original';

  @override
  String get signUp => 'Registrera dig';

  @override
  String get signUpFromGuest =>
      'Registrera dig nu för att få tillgång till alla funktioner!';

  @override
  String get signup => 'Registrera';

  @override
  String get signupComplete => 'Registrering slutförd';

  @override
  String get signupTab => 'Registrera dig';

  @override
  String get simpleInfoRequired => 'Enkel information krävs';

  @override
  String get skip => 'Hoppa över';

  @override
  String get sonaFriend => 'SONA Vän';

  @override
  String get sonaPrivacyPolicy => 'SONA Integritetspolicy';

  @override
  String get sonaPurchasePolicy => 'SONA Köpolicy';

  @override
  String get sonaTermsOfService => 'SONA Användarvillkor';

  @override
  String get sonaUsagePurpose =>
      'Vänligen välj ditt syfte med att använda SONA';

  @override
  String get sorryNotHelpful => 'Tyvärr var detta inte till hjälp';

  @override
  String get sort => 'Sortera';

  @override
  String get soundSettings => 'Ljudinställningar';

  @override
  String get spamAdvertising => 'Spam/annonsering';

  @override
  String get spanish => 'Spanska';

  @override
  String get specialRelationshipDesc => 'Förstå varandra och bygg djupa band';

  @override
  String get sports => 'Sport';

  @override
  String get spring => 'Vår';

  @override
  String get startChat => 'Starta chatt';

  @override
  String get startChatButton => 'Starta chatt';

  @override
  String get startConversation => 'Starta en konversation';

  @override
  String get startConversationLikeAFriend =>
      'Starta en konversation med Sona som en vän';

  @override
  String get startConversationStep =>
      '2. Starta konversation: Chatta fritt med matchade personligheter.';

  @override
  String get startConversationWithSona => 'Börja chatta med Sona som en vän!';

  @override
  String get startWithEmail => 'Starta med e-post';

  @override
  String get startWithGoogle => 'Starta med Google';

  @override
  String get startingApp => 'Startar app';

  @override
  String get storageManagement => 'Lagringshantering';

  @override
  String get store => 'Butik';

  @override
  String get storeConnectionError => 'Kunde inte ansluta till butiken';

  @override
  String get storeLoginRequiredMessage =>
      'Inloggning krävs för att använda butiken. Vill du gå till inloggningsskärmen?';

  @override
  String get storeNotAvailable => 'Butiken är inte tillgänglig';

  @override
  String get storyEvent => 'Berättelsehändelse';

  @override
  String get stressed => 'Stressad';

  @override
  String get submitReport => 'Skicka rapport';

  @override
  String get subscriptionStatus => 'Prenumerationsstatus';

  @override
  String get subtleVibrationOnTouch => 'Subtil vibration vid beröring';

  @override
  String get summer => 'Sommar';

  @override
  String get sunday => 'Söndag';

  @override
  String get swipeAnyDirection => 'Svep i vilken riktning som helst';

  @override
  String get swipeDownToClose => 'Svep neråt för att stänga';

  @override
  String get systemTheme => 'Följ system';

  @override
  String get systemThemeDesc =>
      'Ändras automatiskt baserat på enhetens mörkt läge-inställningar';

  @override
  String get tapBottomForDetails =>
      'Tryck på nedersta området för att se detaljer';

  @override
  String get tapForDetails => 'Tryck på nedersta området för detaljer';

  @override
  String get tapToSwipePhotos => 'Tryck för att svepa bilder';

  @override
  String get teachersDay => 'Lärardagen';

  @override
  String get technicalError => 'Tekniskt fel';

  @override
  String get technology => 'Teknik';

  @override
  String get terms => 'Användarvillkor';

  @override
  String get termsAgreement => 'Avtal om användarvillkor';

  @override
  String get termsAgreementDescription =>
      'Vänligen godkänn villkoren för att använda tjänsten';

  @override
  String get termsOfService => 'Användarvillkor';

  @override
  String get termsSection10Content =>
      'Vi förbehåller oss rätten att ändra dessa villkor när som helst med meddelande till användarna.';

  @override
  String get termsSection10Title => 'Artikel 10 (Tvistlösning)';

  @override
  String get termsSection11Content =>
      'Dessa villkor ska regleras av lagarna i den jurisdiktion där vi verkar.';

  @override
  String get termsSection11Title =>
      'Artikel 11 (Särskilda bestämmelser för AI-tjänster)';

  @override
  String get termsSection12Content =>
      'Om någon bestämmelse i dessa villkor befinns vara ogiltig, ska de återstående bestämmelserna fortsätta att gälla i full kraft och verkan.';

  @override
  String get termsSection12Title => 'Artikel 12 (Datainsamling och användning)';

  @override
  String get termsSection1Content =>
      'Dessa villkor syftar till att definiera rättigheter, skyldigheter och ansvar mellan SONA (hädanefter \"Företaget\") och användare av den AI-baserade tjänsten för samtalsmatchning (hädanefter \"Tjänsten\") som tillhandahålls av Företaget.';

  @override
  String get termsSection1Title => 'Artikel 1 (Syfte)';

  @override
  String get termsSection2Content =>
      'Genom att använda vår tjänst godkänner du att vara bunden av dessa användarvillkor och vår integritetspolicy.';

  @override
  String get termsSection2Title => 'Artikel 2 (Definitioner)';

  @override
  String get termsSection3Content =>
      'Du måste vara minst 13 år gammal för att använda vår tjänst.';

  @override
  String get termsSection3Title => 'Artikel 3 (Verkan och ändring av villkor)';

  @override
  String get termsSection4Content =>
      'Du är ansvarig för att upprätthålla konfidentialiteten för ditt konto och lösenord.';

  @override
  String get termsSection4Title => 'Artikel 4 (Tillhandahållande av tjänst)';

  @override
  String get termsSection5Content =>
      'Du samtycker till att inte använda vår tjänst för något olagligt eller obehörigt syfte.';

  @override
  String get termsSection5Title => 'Artikel 5 (Medlemsregistrering)';

  @override
  String get termsSection6Content =>
      'Vi förbehåller oss rätten att avsluta eller stänga av ditt konto vid överträdelse av dessa villkor.';

  @override
  String get termsSection6Title => 'Artikel 6 (Användarens skyldigheter)';

  @override
  String get termsSection7Content =>
      'Företaget kan gradvis begränsa användningen av tjänsten genom varningar, tillfällig avstängning eller permanent avstängning om användare bryter mot skyldigheterna i dessa villkor eller stör normal tjänsteverksamhet.';

  @override
  String get termsSection7Title =>
      'Artikel 7 (Begränsningar av tjänsteanvändning)';

  @override
  String get termsSection8Content =>
      'Vi är inte ansvariga för några indirekta, tillfälliga eller följdskador som uppstår från din användning av vår tjänst.';

  @override
  String get termsSection8Title => 'Artikel 8 (Tjänsteavbrott)';

  @override
  String get termsSection9Content =>
      'allt innehåll och material som finns tillgängligt på vår tjänst är skyddat av immateriella rättigheter.';

  @override
  String get termsSection9Title => 'Artikel 9 (Ansvarsfriskrivning)';

  @override
  String get termsSupplementary => 'Tilläggsvillkor';

  @override
  String get thai => 'Thailändska';

  @override
  String get thanksFeedback => 'Tack för din feedback!';

  @override
  String get theme => 'Tema';

  @override
  String get themeDescription => 'Du kan anpassa appens utseende som du vill.';

  @override
  String get themeSettings => 'Temainställningar';

  @override
  String get thursday => 'Torsdag';

  @override
  String get timeout => 'Timeout';

  @override
  String get tired => 'Trött';

  @override
  String get today => 'Idag';

  @override
  String get todayChats => 'Idag';

  @override
  String get todayText => 'Idag';

  @override
  String get tomorrowText => 'Imorgon';

  @override
  String get totalConsultSessions => 'Totala konsultationstillfällen';

  @override
  String get totalErrorCount => 'Totalt antal fel';

  @override
  String get totalLikes => 'Totala gillningar';

  @override
  String totalOccurrences(Object count) {
    return 'Totalt $count förekomster';
  }

  @override
  String get totalResponses => 'Totala svar';

  @override
  String get translatedFrom => 'Översatt';

  @override
  String get translatedText => 'Översättning';

  @override
  String get translationError => 'Översättningsfel';

  @override
  String get translationErrorDescription =>
      'Vänligen rapportera felaktiga översättningar eller klumpiga uttryck';

  @override
  String get translationErrorReported => 'Översättningsfel rapporterat. Tack!';

  @override
  String get translationNote => '※ AI-översättning kanske inte är perfekt';

  @override
  String get translationQuality => 'Översättningskvalitet';

  @override
  String get translationSettings => 'Översättningsinställningar';

  @override
  String get travel => 'Resa';

  @override
  String get tuesday => 'Tisdag';

  @override
  String get tutorialAccount => 'Tutorialkonto';

  @override
  String get tutorialWelcomeDescription =>
      'Skapa speciella relationer med AI-personligheter.';

  @override
  String get tutorialWelcomeTitle => 'Välkommen till SONA!';

  @override
  String get typeMessage => 'Skriv ett meddelande...';

  @override
  String get unblock => 'Avblockera';

  @override
  String get unblockFailed => 'Misslyckades med att avblockera';

  @override
  String unblockPersonaConfirm(String name) {
    return 'Avblockera $name?';
  }

  @override
  String get unblockedSuccessfully => 'Avblockerat framgångsrikt';

  @override
  String get unexpectedLoginError =>
      'Ett oväntat fel inträffade vid inloggning';

  @override
  String get unknown => 'Okänd';

  @override
  String get unknownError => 'Ett okänt fel inträffade';

  @override
  String get unlimitedMessages => 'Obegränsat';

  @override
  String get unsendMessage => 'Ångra meddelande';

  @override
  String get usagePurpose => 'Användningssyfte';

  @override
  String get useOneHeart => 'Använd 1 Hjärta';

  @override
  String get useSystemLanguage => 'Använd systemets språk';

  @override
  String get user => 'Användare';

  @override
  String get userMessage => 'Användarmeddelande:';

  @override
  String get userNotFound => 'Användare hittades inte';

  @override
  String get valentinesDay => 'Alla hjärtans dag';

  @override
  String get verifyingAuth => 'Verifierar autentisering';

  @override
  String get version => 'Version';

  @override
  String get vietnamese => 'Vietnamesiska';

  @override
  String get violentContent => 'Våldsam innehåll';

  @override
  String get voiceMessage => '🎤 Röstmeddelande';

  @override
  String waitingForChat(String name) {
    return '$name väntar på chatt.';
  }

  @override
  String get walk => 'Gå';

  @override
  String get wasHelpful => 'Var detta till hjälp?';

  @override
  String get weatherClear => 'Klart';

  @override
  String get weatherCloudy => 'Molnigt';

  @override
  String get weatherContext => 'Väderkontext';

  @override
  String get weatherContextDesc => 'Ge konversationskontext baserat på vädret';

  @override
  String get weatherDrizzle => 'Duggregn';

  @override
  String get weatherFog => 'Dimma';

  @override
  String get weatherMist => 'Dis';

  @override
  String get weatherRain => 'Regn';

  @override
  String get weatherRainy => 'Regnigt';

  @override
  String get weatherSnow => 'Snö';

  @override
  String get weatherSnowy => 'Snöigt';

  @override
  String get weatherThunderstorm => 'Åskväder';

  @override
  String get wednesday => 'Onsdag';

  @override
  String get weekdays => 'Sön,Mån,Tis,Ons,Tor,Fre,Lör';

  @override
  String get welcomeMessage => 'Välkommen!';

  @override
  String get whatTopicsToTalk =>
      'Vilka ämnen skulle du vilja prata om? (Valfritt)';

  @override
  String get whiteDay => 'Vit dag';

  @override
  String get winter => 'Vinter';

  @override
  String get wrongTranslation => 'Fel översättning';

  @override
  String get year => 'År';

  @override
  String get yearEnd => 'Årets slut';

  @override
  String get yes => 'Ja';

  @override
  String get yesterday => 'Igår';

  @override
  String get yesterdayChats => 'Igår';

  @override
  String get you => 'Du';

  @override
  String get loadingPersonaData => 'Laddar persona-data';

  @override
  String get checkingMatchedPersonas => 'Kontrollerar matchade personas';

  @override
  String get preparingImages => 'Förbereder bilder';

  @override
  String get finalPreparation => 'Slutförberedelse';

  @override
  String get editProfileSubtitle =>
      'Redigera kön, födelsedatum och introduktion';

  @override
  String get systemThemeName => 'System';

  @override
  String get lightThemeName => 'Ljus';

  @override
  String get darkThemeName => 'Mörk';
}
