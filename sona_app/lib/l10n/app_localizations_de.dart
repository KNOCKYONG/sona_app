// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get about => 'Über';

  @override
  String get accountAndProfile => 'Konto- & Profilinformationen';

  @override
  String get accountDeletedSuccess => 'Konto erfolgreich gelöscht';

  @override
  String get accountDeletionContent =>
      'Sind Sie sicher, dass Sie Ihr Konto löschen möchten? Diese Aktion kann nicht rückgängig gemacht werden.';

  @override
  String get accountDeletionError =>
      'Fehler beim Löschen des Kontos aufgetreten.';

  @override
  String get accountDeletionInfo => 'Informationen zur Kontolöschung';

  @override
  String get accountDeletionTitle => 'Konto löschen';

  @override
  String get accountDeletionWarning1 =>
      'Warnung: Diese Aktion kann nicht rückgängig gemacht werden';

  @override
  String get accountDeletionWarning2 =>
      'Alle Ihre Daten werden dauerhaft gelöscht';

  @override
  String get accountDeletionWarning3 =>
      'Sie verlieren den Zugriff auf alle Unterhaltungen';

  @override
  String get accountDeletionWarning4 => 'Dies umfasst alle gekauften Inhalte';

  @override
  String get accountManagement => 'Kontoverwaltung';

  @override
  String get adaptiveConversationDesc => 'Passt den Gesprächsstil an Ihren an';

  @override
  String get afternoon => 'Nachmittag';

  @override
  String get afternoonFatigue => 'Nachmittagsmüdigkeit';

  @override
  String get ageConfirmation =>
      'Ich bin 14 Jahre oder älter und habe das Obige bestätigt.';

  @override
  String ageRange(int min, int max) {
    return '$min-$max Jahre alt';
  }

  @override
  String get ageUnit => 'Jahre alt';

  @override
  String get agreeToTerms => 'Ich stimme den Bedingungen zu';

  @override
  String get aiDatingQuestion => 'Ein besonderes Alltagsleben mit KI';

  @override
  String get aiPersonaPreferenceDescription =>
      'Bitte legen Sie Ihre Präferenzen für das Matching mit KI-Personas fest';

  @override
  String get all => 'Alle';

  @override
  String get allAgree => 'Allen zustimmen';

  @override
  String get allFeaturesRequired =>
      '※ Alle Funktionen sind für die Bereitstellung des Dienstes erforderlich';

  @override
  String get allPersonas => 'Alle Personas';

  @override
  String get allPersonasMatched =>
      'Alle Personas gefunden! Beginne mit ihnen zu chatten.';

  @override
  String get allowPermission => 'Weiter';

  @override
  String alreadyChattingWith(String name) {
    return 'Du chattest bereits mit $name!';
  }

  @override
  String get alsoBlockThisAI => 'Diese KI ebenfalls blockieren';

  @override
  String get angry => 'Wütend';

  @override
  String get anonymousLogin => 'Anonymer Login';

  @override
  String get anxious => 'Ängstlich';

  @override
  String get apiKeyError => 'API-Schlüssel-Fehler';

  @override
  String get appName => 'SONA';

  @override
  String get appTagline => 'Ihre AI-Begleiter';

  @override
  String get appleLoginCanceled =>
      'Apple-Login wurde abgebrochen. Bitte versuche es erneut.';

  @override
  String get appleLoginError => 'Ein Fehler ist beim Apple-Login aufgetreten.';

  @override
  String get art => 'Kunst';

  @override
  String get authError => 'Authentifizierungsfehler';

  @override
  String get autoTranslate => 'Automatische Übersetzung';

  @override
  String get autumn => 'Herbst';

  @override
  String get averageQuality => 'Durchschnittliche Qualität';

  @override
  String get averageQualityScore => 'Durchschnittlicher Qualitätswert';

  @override
  String get awkwardExpression => 'Unangenehme Ausdrucksweise';

  @override
  String get backButton => 'Zurück';

  @override
  String get basicInfo => 'Grundinformationen';

  @override
  String get basicInfoDescription =>
      'Bitte geben Sie grundlegende Informationen ein, um ein Konto zu erstellen';

  @override
  String get birthDate => 'Geburtsdatum';

  @override
  String get birthDateOptional => 'Geburtsdatum (Optional)';

  @override
  String get birthDateRequired => 'Geburtsdatum *';

  @override
  String get blockConfirm =>
      'Möchten Sie diese KI blockieren? Blockierte KIs werden von der Übereinstimmung und der Chatliste ausgeschlossen.';

  @override
  String get blockReason => 'Blockierungsgrund';

  @override
  String get blockThisAI => 'Diese KI blockieren';

  @override
  String blockedAICount(int count) {
    return '$count blockierte KIs';
  }

  @override
  String get blockedAIs => 'Blockierte KIs';

  @override
  String get blockedAt => 'Blockiert am';

  @override
  String get blockedSuccessfully => 'Erfolgreich blockiert';

  @override
  String get breakfast => 'Frühstück';

  @override
  String get byErrorType => 'Nach Fehlertyp';

  @override
  String get byPersona => 'Nach Persona';

  @override
  String cacheDeleteError(String error) {
    return 'Fehler beim Löschen des Caches: $error';
  }

  @override
  String get cacheDeleted => 'Bildcache wurde gelöscht';

  @override
  String get cafeTerrace => 'Caféterrasse';

  @override
  String get calm => 'Ruhig';

  @override
  String get cameraPermission => 'Kamera-Berechtigung';

  @override
  String get cameraPermissionDesc =>
      'Kamerazugriff wird benötigt, um Profilfotos aufzunehmen.';

  @override
  String get canChangeInSettings =>
      'Du kannst das später in den Einstellungen ändern';

  @override
  String get canMeetPreviousPersonas => 'Du kannst Personas,';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get changeProfilePhoto => 'Profilbild ändern';

  @override
  String get chat => 'Chat';

  @override
  String get chatEndedMessage => 'Chat ist beendet';

  @override
  String get chatErrorDashboard => 'Chat-Fehler-Dashboard';

  @override
  String get chatErrorSentSuccessfully =>
      'Chat-Fehler wurde erfolgreich gesendet.';

  @override
  String get chatListTab => 'Chat-Liste-Tab';

  @override
  String get chats => 'Chats';

  @override
  String chattingWithPersonas(int count) {
    return 'Chatten mit $count Personas';
  }

  @override
  String get checkInternetConnection =>
      'Bitte überprüfen Sie Ihre Internetverbindung';

  @override
  String get checkingUserInfo => 'Benutzerinformationen werden überprüft';

  @override
  String get childrensDay => 'Kindertag';

  @override
  String get chinese => 'Chinesisch';

  @override
  String get chooseOption => 'Bitte wählen Sie:';

  @override
  String get christmas => 'Weihnachten';

  @override
  String get close => 'Schließen';

  @override
  String get complete => 'Fertig';

  @override
  String get completeSignup => 'Anmeldung abschließen';

  @override
  String get confirm => 'Bestätigen';

  @override
  String get connectingToServer => 'Verbindung zum Server wird hergestellt';

  @override
  String get consultQualityMonitoring => 'Qualitätsüberwachung konsultieren';

  @override
  String get continueAsGuest => 'Als Gast fortfahren';

  @override
  String get continueButton => 'Fortfahren';

  @override
  String get continueWithApple => 'Mit Apple fortfahren';

  @override
  String get continueWithGoogle => 'Mit Google fortfahren';

  @override
  String get conversationContinuity => 'Gesprächskontinuität';

  @override
  String get conversationContinuityDesc =>
      'Erinnern Sie sich an frühere Gespräche und verbinden Sie Themen';

  @override
  String conversationWith(String name) {
    return '$name';
  }

  @override
  String get convertToMember => 'Registrieren';

  @override
  String get cooking => 'Kochen';

  @override
  String get copyMessage => 'Nachricht kopieren';

  @override
  String get copyrightInfringement => 'Urheberrechtsverletzung';

  @override
  String get creatingAccount => 'Konto wird erstellt';

  @override
  String get crisisDetected => 'Krise erkannt';

  @override
  String get culturalIssue => 'Kulturelles Problem';

  @override
  String get current => 'Aktuell';

  @override
  String get currentCacheSize => 'Aktuelle Cache-Größe';

  @override
  String get currentLanguage => 'Aktuelle Sprache';

  @override
  String get cycling => 'Radfahren';

  @override
  String get dailyCare => 'Tägliche Pflege';

  @override
  String get dailyCareDesc =>
      'Tägliche Pflege-Nachrichten für Mahlzeiten, Schlaf, Gesundheit';

  @override
  String get dailyChat => 'Täglicher Chat';

  @override
  String get dailyCheck => 'Tägliche Überprüfung';

  @override
  String get dailyConversation => 'Tägliches Gespräch';

  @override
  String get dailyLimitDescription =>
      'Sie haben Ihr tägliches Nachrichtenlimit erreicht';

  @override
  String get dailyLimitTitle => 'Tägliches Limit erreicht';

  @override
  String get darkMode => 'Dunkler Modus';

  @override
  String get darkTheme => 'Dunkelmodus';

  @override
  String get darkThemeDesc => 'Dunkles Design verwenden';

  @override
  String get dataCollection => 'Einstellungen zur Datensammlung';

  @override
  String get datingAdvice => 'Dating-Tipps';

  @override
  String get datingDescription =>
      'Ich möchte tiefgründige Gedanken teilen und ehrliche Gespräche führen';

  @override
  String get dawn => 'Morgengrauen';

  @override
  String get day => 'Tag';

  @override
  String get dayAfterTomorrow => 'Übermorgen';

  @override
  String daysAgo(int count, String formatted) {
    return 'vor $count Tagen';
  }

  @override
  String daysRemaining(int days) {
    return 'Noch $days Tage übrig';
  }

  @override
  String get deepTalk => 'Tiefes Gespräch';

  @override
  String get delete => 'Löschen';

  @override
  String get deleteAccount => 'Konto löschen';

  @override
  String get deleteAccountConfirm =>
      'Sind Sie sicher, dass Sie Ihr Konto löschen möchten? Diese Aktion kann nicht rückgängig gemacht werden.';

  @override
  String get deleteAccountWarning => 'Möchten Sie Ihr Konto wirklich löschen?';

  @override
  String get deleteCache => 'Cache löschen';

  @override
  String get deletingAccount => 'Konto wird gelöscht...';

  @override
  String get depressed => 'Depressiv';

  @override
  String get describeError => 'Was ist das Problem?';

  @override
  String get detailedReason => 'Detaillierter Grund';

  @override
  String get developRelationshipStep =>
      '3. Beziehung aufbauen: Intimität durch Gespräche schaffen und besondere Beziehungen entwickeln.';

  @override
  String get dinner => 'Abendessen';

  @override
  String get discardGuestData => 'Neu starten';

  @override
  String get discount20 => '20% Rabatt';

  @override
  String get discount30 => '30% Rabatt';

  @override
  String get discountAmount => 'Sparen';

  @override
  String discountAmountValue(String amount) {
    return '₩$amount sparen';
  }

  @override
  String get done => 'Fertig';

  @override
  String get downloadingPersonaImages =>
      'Neue Persona-Bilder werden heruntergeladen';

  @override
  String get edit => 'Bearbeiten';

  @override
  String get editInfo => 'Informationen bearbeiten';

  @override
  String get editProfile => 'Profil bearbeiten';

  @override
  String get effectSound => 'Soundeffekte';

  @override
  String get effectSoundDescription => 'Soundeffekte abspielen';

  @override
  String get email => 'E-Mail';

  @override
  String get emailHint => 'beispiel@email.com';

  @override
  String get emailLabel => 'E-Mail';

  @override
  String get emailRequired => 'E-Mail *';

  @override
  String get emotionAnalysis => 'Emotionale Analyse';

  @override
  String get emotionAnalysisDesc =>
      'Analysiere Emotionen für einfühlsame Antworten';

  @override
  String get emotionAngry => 'Wütend';

  @override
  String get emotionBasedEncounters => 'Emotionsbasierte Begegnungen';

  @override
  String get emotionCool => 'Cool';

  @override
  String get emotionHappy => 'Glücklich';

  @override
  String get emotionLove => 'Liebe';

  @override
  String get emotionSad => 'Traurig';

  @override
  String get emotionThinking => 'Nachdenklich';

  @override
  String get emotionalSupportDesc =>
      'Teile deine Sorgen und erhalte warme Unterstützung';

  @override
  String get endChat => 'Chat beenden';

  @override
  String get endTutorial => 'Tutorial beenden';

  @override
  String get endTutorialAndLogin => 'Tutorial beenden und einloggen?';

  @override
  String get endTutorialMessage =>
      'Möchtest du das Tutorial beenden und dich einloggen?';

  @override
  String get english => 'Englisch';

  @override
  String get enterBasicInfo =>
      'Bitte gib grundlegende Informationen ein, um ein Konto zu erstellen';

  @override
  String get enterBasicInformation =>
      'Bitte gib grundlegende Informationen ein';

  @override
  String get enterEmail => 'Bitte E-Mail eingeben';

  @override
  String get enterNickname => 'Bitte geben Sie einen Spitznamen ein';

  @override
  String get enterPassword => 'Bitte geben Sie ein Passwort ein';

  @override
  String get entertainmentAndFunDesc =>
      'Genieße unterhaltsame Spiele und angenehme Gespräche';

  @override
  String get entertainmentDescription =>
      'Ich möchte unterhaltsame Gespräche führen und meine Zeit genießen';

  @override
  String get entertainmentFun => 'Unterhaltung/Spaß';

  @override
  String get error => 'Fehler';

  @override
  String get errorDescription => 'Fehlerbeschreibung';

  @override
  String get errorDescriptionHint =>
      'z.B. Gab seltsame Antworten, Wiederholt dasselbe, Gibt kontextuell unangemessene Antworten...';

  @override
  String get errorDetails => 'Fehlermeldung';

  @override
  String get errorDetailsHint => 'Bitte erkläre im Detail, was falsch ist';

  @override
  String get errorFrequency24h => 'Fehlerhäufigkeit (Letzte 24 Stunden)';

  @override
  String get errorMessage => 'Fehlermeldung:';

  @override
  String get errorOccurred => 'Ein Fehler ist aufgetreten.';

  @override
  String get errorOccurredTryAgain =>
      'Ein Fehler ist aufgetreten. Bitte versuche es erneut.';

  @override
  String get errorSendingFailed => 'Fehler beim Senden des Fehlers';

  @override
  String get errorStats => 'Fehlerstatistiken';

  @override
  String errorWithMessage(String error) {
    return 'Fehler aufgetreten: $error';
  }

  @override
  String get evening => 'Abend';

  @override
  String get excited => 'Aufgeregt';

  @override
  String get exit => 'Beenden';

  @override
  String get exitApp => 'App beenden';

  @override
  String get exitConfirmMessage =>
      'Sind Sie sicher, dass Sie die App beenden möchten?';

  @override
  String get expertPersona => 'Experten-Persona';

  @override
  String get expertiseScore => 'Fachkenntnis-Score';

  @override
  String get expired => 'Abgelaufen';

  @override
  String get explainReportReason =>
      'Bitte erklären Sie den Grund für den Bericht im Detail';

  @override
  String get fashion => 'Mode';

  @override
  String get female => 'Weiblich';

  @override
  String get filter => 'Filtern';

  @override
  String get firstOccurred => 'Erstmals aufgetreten:';

  @override
  String get followDeviceLanguage =>
      'Den Spracheinstellungen des Geräts folgen';

  @override
  String get forenoon => 'Vormittag';

  @override
  String get forgotPassword => 'Passwort vergessen?';

  @override
  String get frequentlyAskedQuestions => 'Häufig gestellte Fragen';

  @override
  String get friday => 'Freitag';

  @override
  String get friendshipDescription =>
      'Ich möchte neue Freunde kennenlernen und Gespräche führen';

  @override
  String get funChat => 'Spaß-Chat';

  @override
  String get galleryPermission => 'Galerie-Berechtigung';

  @override
  String get galleryPermissionDesc =>
      'Galeriezugriff wird benötigt, um Profilfotos auszuwählen.';

  @override
  String get gaming => 'Gaming';

  @override
  String get gender => 'Geschlecht';

  @override
  String get genderNotSelectedInfo =>
      'Wenn kein Geschlecht ausgewählt ist, werden Personas aller Geschlechter angezeigt.';

  @override
  String get genderOptional => 'Geschlecht (Optional)';

  @override
  String get genderPreferenceActive =>
      'Du kannst Personas aller Geschlechter treffen.';

  @override
  String get genderPreferenceDisabled =>
      'Wähle dein Geschlecht aus, um die Option nur für das gegenteilige Geschlecht zu aktivieren.';

  @override
  String get genderPreferenceInactive =>
      'Es werden nur Personas des gegenteiligen Geschlechts angezeigt.';

  @override
  String get genderRequired => 'Geschlecht *';

  @override
  String get genderSelectionInfo =>
      'Wenn nicht ausgewählt, kannst du Personas aller Geschlechter treffen.';

  @override
  String get generalPersona => 'Allgemeine Persona';

  @override
  String get goToSettings => 'Zu den Einstellungen';

  @override
  String get permissionGuideAndroid =>
      'Einstellungen > Apps > SONA > Berechtigungen\nBitte Foto-Berechtigung erlauben';

  @override
  String get permissionGuideIOS =>
      'Einstellungen > SONA > Fotos\nBitte Fotozugriff erlauben';

  @override
  String get googleLoginCanceled =>
      'Google-Anmeldung wurde abgebrochen. Bitte versuche es erneut.';

  @override
  String get googleLoginError =>
      'Bei der Google-Anmeldung ist ein Fehler aufgetreten.';

  @override
  String get grantPermission => 'Weiter';

  @override
  String get guest => 'Gast';

  @override
  String get guestDataMigration =>
      'Möchtest du deinen aktuellen Chatverlauf beim Anmelden behalten?';

  @override
  String get guestLimitReached =>
      'Gast-Testzeitraum beendet. Melde dich für unbegrenzte Gespräche an!';

  @override
  String get guestLoginPromptMessage =>
      'Melden Sie sich an, um das Gespräch fortzusetzen';

  @override
  String get guestMessageExhausted => 'Kostenlose Nachrichten erschöpft';

  @override
  String guestMessageRemaining(int count) {
    return '$count Gästennachrichten verbleibend';
  }

  @override
  String get guestModeBanner => 'Gäste-Modus';

  @override
  String get guestModeDescription => 'Probiere SONA aus, ohne dich anzumelden';

  @override
  String get guestModeFailedMessage => 'Fehler beim Starten des Gäste-Modus';

  @override
  String get guestModeLimitation =>
      'Einige Funktionen sind im Gäste-Modus eingeschränkt';

  @override
  String get guestModeTitle => 'Als Gast ausprobieren';

  @override
  String get guestModeWarning =>
      'Der Gäste-Modus dauert 24 Stunden, danach werden die Daten gelöscht.';

  @override
  String get guestModeWelcome => 'Starte im Gäste-Modus';

  @override
  String get happy => 'Glücklich';

  @override
  String get hapticFeedback => 'Haptisches Feedback';

  @override
  String get harassmentBullying => 'Belästigung/Mobbing';

  @override
  String get hateSpeech => 'Hassrede';

  @override
  String get heartDescription => 'Herzen für mehr Nachrichten';

  @override
  String get heartInsufficient => 'Nicht genügend Herzen';

  @override
  String get heartInsufficientPleaseCharge =>
      'Nicht genügend Herzen. Bitte lade die Herzen auf.';

  @override
  String get heartRequired => 'Es wird 1 Herz benötigt';

  @override
  String get heartUsageFailed => 'Verwendung des Herzens fehlgeschlagen.';

  @override
  String get hearts => 'Herzen';

  @override
  String get hearts10 => '10 Herzen';

  @override
  String get hearts30 => '30 Herzen';

  @override
  String get hearts30Discount => 'SALE';

  @override
  String get hearts50 => '50 Herzen';

  @override
  String get hearts50Discount => 'SALE';

  @override
  String get helloEmoji => 'Hallo! 😊';

  @override
  String get help => 'Hilfe';

  @override
  String get hideOriginalText => 'Originaltext ausblenden';

  @override
  String get hobbySharing => 'Hobby Sharing';

  @override
  String get hobbyTalk => 'Hobby Talk';

  @override
  String get hours24Ago => 'Vor 24 Stunden';

  @override
  String hoursAgo(int count, String formatted) {
    return 'vor $count Stunden';
  }

  @override
  String get howToUse => 'So benutzt man SONA';

  @override
  String get imageCacheManagement => 'Bildcache-Verwaltung';

  @override
  String get inappropriateContent => 'Unangemessener Inhalt';

  @override
  String get incorrect => 'falsch';

  @override
  String get incorrectPassword => 'Falsches Passwort';

  @override
  String get indonesian => 'Indonesisch';

  @override
  String get inquiries => 'Anfragen';

  @override
  String get insufficientHearts => 'Nicht genügend Herzen.';

  @override
  String get noHeartsLeft => 'Keine Herzen mehr';

  @override
  String get needHeartsToChat =>
      'Sie benötigen Herzen, um ein Gespräch mit dieser Persona zu beginnen.';

  @override
  String get goToStore => 'Zum Shop gehen';

  @override
  String get interestSharing => 'Interessen teilen';

  @override
  String get interestSharingDesc =>
      'Entdecke und empfehle gemeinsame Interessen';

  @override
  String get interests => 'Interessen';

  @override
  String get invalidEmailFormat => 'Ungültiges E-Mail-Format';

  @override
  String get invalidEmailFormatError =>
      'Bitte geben Sie eine gültige E-Mail-Adresse ein';

  @override
  String isTyping(String name) {
    return '$name tippt gerade...';
  }

  @override
  String get japanese => 'Japanisch';

  @override
  String get joinDate => 'Beitrittsdatum';

  @override
  String get justNow => 'Gerade eben';

  @override
  String get keepGuestData => 'Chatverlauf speichern';

  @override
  String get korean => 'Koreanisch';

  @override
  String get koreanLanguage => 'Koreanisch';

  @override
  String get language => 'Sprache';

  @override
  String get languageDescription =>
      'Die KI wird in deiner ausgewählten Sprache antworten';

  @override
  String get languageIndicator => 'Sprache';

  @override
  String get languageSettings => 'Spracheinstellungen';

  @override
  String get lastOccurred => 'Zuletzt aufgetreten:';

  @override
  String get lastUpdated => 'Zuletzt aktualisiert';

  @override
  String get lateNight => 'Spätabend';

  @override
  String get later => 'Später';

  @override
  String get laterButton => 'Später';

  @override
  String get leave => 'Verlassen';

  @override
  String get leaveChatConfirm => 'Möchtest du diesen Chat verlassen?';

  @override
  String get leaveChatRoom => 'Chatraum verlassen';

  @override
  String get leaveChatTitle => 'Chat verlassen';

  @override
  String get lifeAdvice => 'Lebensberatung';

  @override
  String get lightTalk => 'Leichtes Gespräch';

  @override
  String get lightTheme => 'Heller Modus';

  @override
  String get lightThemeDesc => 'Helles Design verwenden';

  @override
  String get loading => 'Wird geladen...';

  @override
  String get loadingData => 'Daten werden geladen...';

  @override
  String get loadingProducts => 'Produkte werden geladen...';

  @override
  String get loadingProfile => 'Profil wird geladen';

  @override
  String get login => 'Anmelden';

  @override
  String get loginButton => 'Anmelden';

  @override
  String get loginCancelled => 'Anmeldung abgebrochen';

  @override
  String get loginComplete => 'Anmeldung abgeschlossen';

  @override
  String get loginError => 'Anmeldung fehlgeschlagen';

  @override
  String get loginFailed => 'Anmeldung fehlgeschlagen';

  @override
  String get loginFailedTryAgain =>
      'Anmeldung fehlgeschlagen. Bitte versuchen Sie es erneut.';

  @override
  String get loginRequired => 'Anmeldung erforderlich';

  @override
  String get loginRequiredForProfile =>
      'Anmeldung erforderlich, um das Profil anzuzeigen';

  @override
  String get loginRequiredService =>
      'Anmeldung erforderlich, um diesen Dienst zu nutzen';

  @override
  String get loginRequiredTitle => 'Anmeldung erforderlich';

  @override
  String get loginSignup => 'Anmelden/Registrieren';

  @override
  String get loginTab => 'Anmelden';

  @override
  String get loginTitle => 'Anmeldung';

  @override
  String get loginWithApple => 'Mit Apple anmelden';

  @override
  String get loginWithGoogle => 'Mit Google anmelden';

  @override
  String get logout => 'Abmelden';

  @override
  String get logoutConfirm => 'Möchten Sie sich wirklich abmelden?';

  @override
  String get lonelinessRelief => 'Linderung von Einsamkeit';

  @override
  String get lonely => 'Einsam';

  @override
  String get lowQualityResponses => 'Niedrige Qualität der Antworten';

  @override
  String get lunch => 'Mittagessen';

  @override
  String get lunchtime => 'Mittagszeit';

  @override
  String get mainErrorType => 'Hauptfehlerart';

  @override
  String get makeFriends => 'Freunde finden';

  @override
  String get male => 'Männlich';

  @override
  String get manageBlockedAIs => 'Blockierte AIs verwalten';

  @override
  String get managePersonaImageCache => 'Persona-Bildcache verwalten';

  @override
  String get marketingAgree =>
      'Zustimmung zu Marketinginformationen (optional)';

  @override
  String get marketingDescription =>
      'Sie können Informationen zu Veranstaltungen und Vorteilen erhalten';

  @override
  String get matchPersonaStep =>
      '1. Personas abgleichen: Wischen Sie nach links oder rechts, um Ihre Lieblings-AI-Personas auszuwählen.';

  @override
  String get matchedPersonas => 'Abgeglichene Personas';

  @override
  String get matchedSona => 'Abgeglichene SONA';

  @override
  String get matching => 'Abgleich';

  @override
  String get matchingFailed => 'Abgleich fehlgeschlagen.';

  @override
  String get me => 'Me';

  @override
  String get meetAIPersonas => 'AI-Personas kennenlernen';

  @override
  String get meetNewPersonas => 'Neue Personas treffen';

  @override
  String get meetPersonas => 'Personas kennenlernen';

  @override
  String get memberBenefits =>
      'Erhalten Sie 100+ Nachrichten und 10 Herzen, wenn Sie sich anmelden!';

  @override
  String get memoryAlbum => 'Erinnerungsalbum';

  @override
  String get memoryAlbumDesc =>
      'Besondere Momente automatisch speichern und abrufen';

  @override
  String get messageCopied => 'Nachricht kopiert';

  @override
  String get messageDeleted => 'Nachricht gelöscht';

  @override
  String get messageLimitReset =>
      'Nachrichtenlimit wird um Mitternacht zurückgesetzt';

  @override
  String get messageSendFailed =>
      'Nachricht konnte nicht gesendet werden. Bitte versuche es erneut.';

  @override
  String get messagesRemaining => 'Verbleibende Nachrichten';

  @override
  String minutesAgo(int count, String formatted) {
    return 'vor $count Minuten';
  }

  @override
  String get missingTranslation => 'Fehlende Übersetzung';

  @override
  String get monday => 'Montag';

  @override
  String get month => 'Monat';

  @override
  String monthDay(String month, int day) {
    return '$month $day';
  }

  @override
  String get moreButton => 'Mehr';

  @override
  String get morning => 'Morgen';

  @override
  String get mostFrequentError => 'Häufigster Fehler';

  @override
  String get movies => 'Filme';

  @override
  String get multilingualChat => 'Mehrsprachiger Chat';

  @override
  String get music => 'Musik';

  @override
  String get myGenderSection => 'Mein Geschlecht (Optional)';

  @override
  String get networkErrorOccurred => 'Ein Netzwerkfehler ist aufgetreten.';

  @override
  String get newMessage => 'Neue Nachricht';

  @override
  String newMessageCount(int count) {
    return '$count neue Nachrichten';
  }

  @override
  String get newMessageNotification => 'Neue Nachricht Benachrichtigung';

  @override
  String get newMessages => 'Neue Nachrichten';

  @override
  String get newYear => 'Neues Jahr';

  @override
  String get next => 'Weiter';

  @override
  String get niceToMeetYou => 'Schön, dich kennenzulernen!';

  @override
  String get nickname => 'Spitzname';

  @override
  String get nicknameAlreadyUsed => 'Dieser Spitzname wird bereits verwendet';

  @override
  String get nicknameHelperText => '3-10 Zeichen';

  @override
  String get nicknameHint => '3-10 Zeichen';

  @override
  String get nicknameInUse => 'Dieser Spitzname wird bereits verwendet';

  @override
  String get nicknameLabel => 'Spitzname';

  @override
  String get nicknameLengthError => 'Spitzname muss 3-10 Zeichen lang sein';

  @override
  String get nicknamePlaceholder => 'Geben Sie Ihren Spitznamen ein';

  @override
  String get nicknameRequired => 'Spitzname *';

  @override
  String get night => 'Nacht';

  @override
  String get no => 'Nein';

  @override
  String get noBlockedAIs => 'Keine blockierten AIs';

  @override
  String get noChatsYet => 'Noch keine Chats';

  @override
  String get noConversationYet => 'Noch keine Unterhaltung';

  @override
  String get noErrorReports => 'Keine Fehlermeldungen.';

  @override
  String get noImageAvailable => 'Kein Bild verfügbar';

  @override
  String get noMatchedPersonas => 'Noch keine übereinstimmenden Personas';

  @override
  String get noMatchedSonas => 'Noch keine passenden SONA gefunden';

  @override
  String get noPersonasAvailable =>
      'Keine Personas verfügbar. Bitte versuche es erneut.';

  @override
  String get noPersonasToSelect => 'Keine Personas verfügbar';

  @override
  String get noQualityIssues =>
      'Keine Qualitätsprobleme in der letzten Stunde ✅';

  @override
  String get noQualityLogs => 'Noch keine Qualitätsprotokolle.';

  @override
  String get noTranslatedMessages => 'Keine zu übersetzenden Nachrichten';

  @override
  String get notEnoughHearts => 'Nicht genug Herzen';

  @override
  String notEnoughHeartsCount(int count) {
    return 'Nicht genug Herzen. (Aktuell: $count)';
  }

  @override
  String get notRegistered => 'Nicht registriert';

  @override
  String get notSubscribed => 'Nicht abonniert';

  @override
  String get notificationPermissionDesc =>
      'Benachrichtigungsberechtigung wird benötigt, um neue Nachrichten zu erhalten.';

  @override
  String get notificationPermissionRequired =>
      'Benachrichtigungsberechtigung erforderlich';

  @override
  String get notificationSettings => 'Benachrichtigungseinstellungen';

  @override
  String get notifications => 'Benachrichtigungen';

  @override
  String get occurrenceInfo => 'Ereignisinfo:';

  @override
  String get olderChats => 'Ältere';

  @override
  String get onlyOppositeGenderNote =>
      'Wenn nicht angekreuzt, werden nur Personas des anderen Geschlechts angezeigt';

  @override
  String get openSettings => 'Einstellungen öffnen';

  @override
  String get optional => 'Optional';

  @override
  String get or => 'or';

  @override
  String get originalPrice => 'Original';

  @override
  String get originalText => 'Original';

  @override
  String get other => 'Andere';

  @override
  String get otherError => 'Anderer Fehler';

  @override
  String get others => 'Andere';

  @override
  String get ownedHearts => 'Besitzene Herzen';

  @override
  String get parentsDay => 'Elterntag';

  @override
  String get password => 'Passwort';

  @override
  String get passwordConfirmation => 'Passwort zur Bestätigung eingeben';

  @override
  String get passwordConfirmationDesc =>
      'Bitte geben Sie Ihr Passwort erneut ein, um das Konto zu löschen.';

  @override
  String get passwordHint => '6 Zeichen oder mehr';

  @override
  String get passwordLabel => 'Passwort';

  @override
  String get passwordRequired => 'Passwort *';

  @override
  String get passwordResetEmailPrompt =>
      'Bitte geben Sie Ihre E-Mail-Adresse ein, um das Passwort zurückzusetzen.';

  @override
  String get passwordResetEmailSent =>
      'Die E-Mail zum Zurücksetzen des Passworts wurde gesendet. Bitte überprüfen Sie Ihre E-Mail.';

  @override
  String get passwordText => 'passwort';

  @override
  String get passwordTooShort =>
      'Das Passwort muss mindestens 6 Zeichen lang sein.';

  @override
  String get permissionDenied => 'Berechtigung verweigert';

  @override
  String permissionDeniedMessage(String permissionName) {
    return '$permissionName Berechtigung wurde verweigert.\\nBitte erlauben Sie die Berechtigung in den Einstellungen.';
  }

  @override
  String get permissionDeniedTryLater =>
      'Berechtigung verweigert. Bitte versuchen Sie es später erneut.';

  @override
  String get permissionRequired => 'Berechtigung erforderlich';

  @override
  String get personaGenderSection => 'Geschlechtspräferenz der Persona';

  @override
  String get personaQualityStats => 'Qualitätsstatistiken der Persona';

  @override
  String get personalInfoExposure => 'Persönliche Informationen Exposition';

  @override
  String get personality => 'Persönlichkeitseinstellungen';

  @override
  String get pets => 'Haustiere';

  @override
  String get photo => 'Foto';

  @override
  String get photography => 'Fotografie';

  @override
  String get picnic => 'Picknick';

  @override
  String get preferenceSettings => 'Einstellungen';

  @override
  String get preferredLanguage => 'Bevorzugte Sprache';

  @override
  String get preparingForSleep => 'Vorbereitung auf den Schlaf';

  @override
  String get preparingNewMeeting => 'Vorbereitung eines neuen Meetings';

  @override
  String get preparingPersonaImages => 'Vorbereitung der Persona-Bilder';

  @override
  String get preparingPersonas => 'Vorbereitung der Personas';

  @override
  String get preview => 'Vorschau';

  @override
  String get previous => 'Zurück';

  @override
  String get privacy => 'Datenschutz';

  @override
  String get privacyPolicy => 'Datenschutzrichtlinie';

  @override
  String get privacyPolicyAgreement =>
      'Bitte stimmen Sie der Datenschutzrichtlinie zu';

  @override
  String get privacySection1Content =>
      'Wir setzen uns für den Schutz Ihrer Privatsphäre ein. Diese Datenschutzrichtlinie erklärt, wie wir Ihre Informationen sammeln, verwenden und sichern, wenn Sie unseren Dienst nutzen.';

  @override
  String get privacySection1Title =>
      '1. Zweck der Erhebung und Verwendung personenbezogener Daten';

  @override
  String get privacySection2Content =>
      'Wir sammeln Informationen, die Sie uns direkt zur Verfügung stellen, beispielsweise wenn Sie ein Konto erstellen, Ihr Profil aktualisieren oder unsere Dienste nutzen.';

  @override
  String get privacySection2Title => 'Informationen, die wir sammeln';

  @override
  String get privacySection3Content =>
      'Wir verwenden die gesammelten Informationen, um unsere Dienste bereitzustellen, zu warten und zu verbessern sowie um mit Ihnen zu kommunizieren.';

  @override
  String get privacySection3Title =>
      '3. Aufbewahrungs- und Nutzungsdauer personenbezogener Daten';

  @override
  String get privacySection4Content =>
      'Wir verkaufen, tauschen oder übertragen Ihre personenbezogenen Daten nicht ohne Ihre Zustimmung an Dritte.';

  @override
  String get privacySection4Title =>
      '4. Bereitstellung personenbezogener Daten an Dritte';

  @override
  String get privacySection5Content =>
      'Wir setzen angemessene Sicherheitsmaßnahmen ein, um Ihre personenbezogenen Daten vor unbefugtem Zugriff, Veränderung, Offenlegung oder Zerstörung zu schützen.';

  @override
  String get privacySection5Title =>
      '5. Technische Schutzmaßnahmen für personenbezogene Daten';

  @override
  String get privacySection6Content =>
      'Wir bewahren personenbezogene Daten so lange auf, wie es notwendig ist, um unsere Dienstleistungen bereitzustellen und gesetzlichen Verpflichtungen nachzukommen.';

  @override
  String get privacySection6Title => '6. Nutzerrechte';

  @override
  String get privacySection7Content =>
      'Sie haben das Recht, Ihre personenbezogenen Daten jederzeit über die Kontoeinstellungen einzusehen, zu aktualisieren oder zu löschen.';

  @override
  String get privacySection7Title => 'Ihre Rechte';

  @override
  String get privacySection8Content =>
      'Wenn Sie Fragen zu dieser Datenschutzrichtlinie haben, kontaktieren Sie uns bitte unter support@sona.com.';

  @override
  String get privacySection8Title => 'Kontaktieren Sie uns';

  @override
  String get privacySettings => 'Datenschutzeinstellungen';

  @override
  String get privacySettingsInfo =>
      'Das Deaktivieren einzelner Funktionen macht diese Dienste unbrauchbar';

  @override
  String get privacySettingsScreen => 'Datenschutzeinstellungen';

  @override
  String get problemMessage => 'Problem';

  @override
  String get problemOccurred => 'Ein Problem ist aufgetreten';

  @override
  String get profile => 'Profil';

  @override
  String get profileEdit => 'Profil bearbeiten';

  @override
  String get profileEditLoginRequiredMessage =>
      'Sie müssen sich anmelden, um Ihr Profil zu bearbeiten. Möchten Sie zum Anmeldebildschirm wechseln?';

  @override
  String get profileInfo => 'Profilinformationen';

  @override
  String get profileInfoDescription =>
      'Bitte geben Sie Ihr Profilfoto und grundlegende Informationen ein';

  @override
  String get profileNav => 'Profil';

  @override
  String get profilePhoto => 'Profilfoto';

  @override
  String get profilePhotoAndInfo =>
      'Bitte geben Sie Profilfoto und grundlegende Informationen ein';

  @override
  String get profilePhotoUpdateFailed =>
      'Aktualisierung des Profilfotos fehlgeschlagen';

  @override
  String get profilePhotoUpdated => 'Profilfoto aktualisiert';

  @override
  String get profileSettings => 'Profileinstellungen';

  @override
  String get profileSetup => 'Profil einrichten';

  @override
  String get profileUpdateFailed => 'Aktualisierung des Profils fehlgeschlagen';

  @override
  String get profileUpdated => 'Profil erfolgreich aktualisiert';

  @override
  String get purchaseAndRefundPolicy => 'Kauf- und Rückerstattungsrichtlinie';

  @override
  String get purchaseButton => 'Kaufen';

  @override
  String get purchaseConfirm => 'Kaufbestätigung';

  @override
  String purchaseConfirmContent(String product, String price) {
    return '$product für $price kaufen?';
  }

  @override
  String purchaseConfirmMessage(
      String title, String price, String description) {
    return 'Kauf von $title für $price bestätigen? $description';
  }

  @override
  String get purchaseFailed => 'Kauf fehlgeschlagen';

  @override
  String get purchaseHeartsOnly => 'Herzen kaufen';

  @override
  String get purchaseMoreHearts =>
      'Kaufen Sie Herzen, um Gespräche fortzusetzen';

  @override
  String get purchasePending => 'Kauf ausstehend...';

  @override
  String get purchasePolicy => 'Kaufrichtlinien';

  @override
  String get purchaseSection1Content =>
      'Wir akzeptieren verschiedene Zahlungsmethoden, einschließlich Kreditkarten und digitaler Geldbörsen.';

  @override
  String get purchaseSection1Title => 'Zahlungsmethoden';

  @override
  String get purchaseSection2Content =>
      'Rückerstattungen sind innerhalb von 14 Tagen nach dem Kauf möglich, wenn Sie die gekauften Artikel nicht verwendet haben.';

  @override
  String get purchaseSection2Title => 'Rückerstattungsrichtlinie';

  @override
  String get purchaseSection3Content =>
      'Sie können Ihr Abonnement jederzeit über die Kontoeinstellungen kündigen.';

  @override
  String get purchaseSection3Title => 'Kündigung';

  @override
  String get purchaseSection4Content =>
      'Mit dem Kauf stimmen Sie unseren Nutzungsbedingungen und dem Dienstleistungsvertrag zu.';

  @override
  String get purchaseSection4Title => 'Nutzungsbedingungen';

  @override
  String get purchaseSection5Content =>
      'Bei kaufbezogenen Problemen wenden Sie sich bitte an unser Support-Team.';

  @override
  String get purchaseSection5Title => 'Support kontaktieren';

  @override
  String get purchaseSection6Content =>
      'Alle Käufe unterliegen unseren allgemeinen Geschäftsbedingungen.';

  @override
  String get purchaseSection6Title => '6. Anfragen';

  @override
  String get pushNotifications => 'Push-Benachrichtigungen';

  @override
  String get reading => 'Lesen';

  @override
  String get realtimeQualityLog => 'Echtzeit-Qualitätsprotokoll';

  @override
  String get recentConversation => 'Letzte Unterhaltung:';

  @override
  String get recentLoginRequired =>
      'Bitte melden Sie sich erneut aus Sicherheitsgründen an.';

  @override
  String get referrerEmail => 'Empfehlungs-E-Mail';

  @override
  String get referrerEmailHelper =>
      'Optional: E-Mail-Adresse der Person, die Sie geworben hat';

  @override
  String get referrerEmailLabel => 'Empfehlungs-E-Mail (Optional)';

  @override
  String get refresh => 'Aktualisieren';

  @override
  String refreshComplete(int count) {
    return 'Aktualisierung abgeschlossen! $count passende Personas';
  }

  @override
  String get refreshFailed => 'Aktualisierung fehlgeschlagen';

  @override
  String get refreshingChatList => 'Chatliste wird aktualisiert...';

  @override
  String get relatedFAQ => 'Verwandte FAQ';

  @override
  String get report => 'Melden';

  @override
  String get reportAI => 'Melden';

  @override
  String get reportAIDescription =>
      'Wenn die KI Ihnen Unbehagen bereitet hat, beschreiben Sie bitte das Problem.';

  @override
  String get reportAITitle => 'KI-Konversation melden';

  @override
  String get reportAndBlock => 'Melden & Blockieren';

  @override
  String get reportAndBlockDescription =>
      'Sie können unangemessenes Verhalten dieser KI melden und blockieren.';

  @override
  String get reportChatError => 'Chat-Fehler melden';

  @override
  String reportError(String error) {
    return 'Beim Melden ist ein Fehler aufgetreten: $error';
  }

  @override
  String get reportFailed => 'Meldung fehlgeschlagen';

  @override
  String get reportSubmitted =>
      'Meldung eingereicht. Wir werden sie prüfen und Maßnahmen ergreifen.';

  @override
  String get reportSubmittedSuccess =>
      'Ihre Meldung wurde eingereicht. Vielen Dank!';

  @override
  String get requestLimit => 'Anfrage-Limit';

  @override
  String get required => '[Erforderlich]';

  @override
  String get requiredTermsAgreement => 'Bitte stimmen Sie den Bedingungen zu';

  @override
  String get restartConversation => 'Konversation neu starten';

  @override
  String restartConversationQuestion(String name) {
    return 'Möchten Sie das Gespräch mit $name neu starten?';
  }

  @override
  String restartConversationWithName(String name) {
    return 'Gespräch mit $name wird neu gestartet!';
  }

  @override
  String get retry => 'Wiederholen';

  @override
  String get retryButton => 'Erneut versuchen';

  @override
  String get sad => 'Traurig';

  @override
  String get saturday => 'Samstag';

  @override
  String get save => 'Speichern';

  @override
  String get search => 'Suchen';

  @override
  String get searchFAQ => 'FAQ durchsuchen...';

  @override
  String get searchResults => 'Suchergebnisse';

  @override
  String get selectEmotion => 'Emotion auswählen';

  @override
  String get selectErrorType => 'Fehlerart auswählen';

  @override
  String get selectFeeling => 'Gefühl auswählen';

  @override
  String get selectGender => 'Bitte Geschlecht auswählen';

  @override
  String get selectInterests => 'Wählen Sie Ihre Interessen';

  @override
  String get selectLanguage => 'Sprache auswählen';

  @override
  String get selectPersona => 'Eine Persona auswählen';

  @override
  String get selectPersonaPlease => 'Bitte wählen Sie eine Persona aus.';

  @override
  String get selectPreferredMbti =>
      'Wenn Sie Personas mit bestimmten MBTI-Typen bevorzugen, wählen Sie bitte aus';

  @override
  String get selectProblematicMessage =>
      'Wählen Sie die problematische Nachricht (optional)';

  @override
  String get chatErrorAnalysisInfo =>
      'Die letzten 10 Gespräche werden analysiert.';

  @override
  String get whatWasAwkward => 'Was erschien Ihnen unnatürlich?';

  @override
  String get errorExampleHint =>
      'Z.B.: Unnatürliche Sprechweise (~nya Endungen)...';

  @override
  String get selectReportReason => 'Wählen Sie den Grund für die Meldung';

  @override
  String get selectTheme => 'Wählen Sie ein Thema';

  @override
  String get selectTranslationError =>
      'Bitte wählen Sie eine Nachricht mit Übersetzungsfehler';

  @override
  String get selectUsagePurpose =>
      'Bitte wählen Sie Ihren Zweck für die Nutzung von SONA';

  @override
  String get selfIntroduction => 'Einführung (Optional)';

  @override
  String get selfIntroductionHint =>
      'Schreiben Sie eine kurze Einführung über sich selbst';

  @override
  String get send => 'Senden';

  @override
  String get sendChatError => 'Chat-Fehler senden';

  @override
  String get sendFirstMessage => 'Senden Sie Ihre erste Nachricht';

  @override
  String get sendReport => 'Bericht senden';

  @override
  String get sendingEmail => 'E-Mail wird gesendet...';

  @override
  String get seoul => 'Seoul';

  @override
  String get serverErrorDashboard => 'Serverfehler';

  @override
  String get serviceTermsAgreement =>
      'Bitte stimmen Sie den Nutzungsbedingungen zu';

  @override
  String get sessionExpired => 'Sitzung abgelaufen';

  @override
  String get setAppInterfaceLanguage => 'App-Schnittstellensprache festlegen';

  @override
  String get setNow => 'Jetzt festlegen';

  @override
  String get settings => 'Einstellungen';

  @override
  String get sexualContent => 'Sexuelle Inhalte';

  @override
  String get showAllGenderPersonas => 'Alle Geschlechter-Personas anzeigen';

  @override
  String get showAllGendersOption => 'Alle Geschlechter anzeigen';

  @override
  String get showOppositeGenderOnly =>
      'Wenn nicht aktiviert, werden nur Personas des gegenteiligen Geschlechts angezeigt';

  @override
  String get showOriginalText => 'Original anzeigen';

  @override
  String get signUp => 'Registrieren';

  @override
  String get signUpFromGuest =>
      'Melde dich jetzt an, um auf alle Funktionen zuzugreifen!';

  @override
  String get signup => 'Registrieren';

  @override
  String get signupComplete => 'Anmeldung abgeschlossen';

  @override
  String get signupTab => 'Anmeldung';

  @override
  String get simpleInfoRequired => 'Einfache Informationen sind erforderlich';

  @override
  String get skip => 'Überspringen';

  @override
  String get sonaFriend => 'SONA Freund';

  @override
  String get sonaPrivacyPolicy => 'SONA Datenschutzrichtlinie';

  @override
  String get sonaPurchasePolicy => 'SONA Kaufrichtlinie';

  @override
  String get sonaTermsOfService => 'SONA Nutzungsbedingungen';

  @override
  String get sonaUsagePurpose =>
      'Bitte wähle deinen Zweck für die Nutzung von SONA';

  @override
  String get sorryNotHelpful => 'Entschuldigung, das war nicht hilfreich';

  @override
  String get sort => 'Sortieren';

  @override
  String get soundSettings => 'Toneinstellungen';

  @override
  String get spamAdvertising => 'Spam/Werbung';

  @override
  String get spanish => 'Spanisch';

  @override
  String get specialRelationshipDesc =>
      'Versteht euch und baut tiefere Bindungen auf';

  @override
  String get sports => 'Sport';

  @override
  String get spring => 'Frühling';

  @override
  String get startChat => 'Chat starten';

  @override
  String get startChatButton => 'Chat starten';

  @override
  String get startConversation => 'Ein Gespräch beginnen';

  @override
  String get startConversationLikeAFriend =>
      'Beginne ein Gespräch mit SONA wie mit einem Freund';

  @override
  String get startConversationStep =>
      '2. Gespräch beginnen: Chatte frei mit den passenden Personas.';

  @override
  String get startConversationWithSona =>
      'Beginne mit SONA wie mit einem Freund zu chatten!';

  @override
  String get startWithEmail => 'Mit E-Mail beginnen';

  @override
  String get startWithGoogle => 'Mit Google starten';

  @override
  String get startingApp => 'App wird gestartet';

  @override
  String get storageManagement => 'Speicherverwaltung';

  @override
  String get store => 'Geschäft';

  @override
  String get storeConnectionError =>
      'Verbindung zum Geschäft konnte nicht hergestellt werden';

  @override
  String get storeLoginRequiredMessage =>
      'Für die Nutzung des Geschäfts ist ein Login erforderlich. Möchten Sie zum Anmeldebildschirm gehen?';

  @override
  String get storeNotAvailable => 'Geschäft ist nicht verfügbar';

  @override
  String get storyEvent => 'Geschichtsereignis';

  @override
  String get stressed => 'Gestresst';

  @override
  String get submitReport => 'Bericht einreichen';

  @override
  String get subscriptionStatus => 'Abonnementstatus';

  @override
  String get subtleVibrationOnTouch => 'Dezente Vibration bei Berührung';

  @override
  String get summer => 'Sommer';

  @override
  String get sunday => 'Sonntag';

  @override
  String get swipeAnyDirection => 'In jede Richtung wischen';

  @override
  String get swipeDownToClose => 'Nach unten wischen, um zu schließen';

  @override
  String get systemTheme => 'System folgen';

  @override
  String get systemThemeDesc =>
      'Wechselt automatisch basierend auf den Einstellungen des Dunkelmodus des Geräts';

  @override
  String get tapBottomForDetails => 'Unten tippen für Details';

  @override
  String get tapForDetails => 'Tippe im unteren Bereich für Details';

  @override
  String get tapToSwipePhotos => 'Tippe, um Fotos zu wischen';

  @override
  String get teachersDay => 'Tag der Lehrer';

  @override
  String get technicalError => 'Technischer Fehler';

  @override
  String get technology => 'Technologie';

  @override
  String get terms => 'Nutzungsbedingungen';

  @override
  String get termsAgreement => 'Zustimmung zu den Bedingungen';

  @override
  String get termsAgreementDescription =>
      'Bitte stimmen Sie den Bedingungen für die Nutzung des Dienstes zu';

  @override
  String get termsOfService => 'Nutzungsbedingungen';

  @override
  String get termsSection10Content =>
      'Wir behalten uns das Recht vor, diese Bedingungen jederzeit mit Benachrichtigung an die Nutzer zu ändern.';

  @override
  String get termsSection10Title => 'Artikel 10 (Streitbeilegung)';

  @override
  String get termsSection11Content =>
      'Diese Bedingungen unterliegen den Gesetzen der Gerichtsbarkeit, in der wir tätig sind.';

  @override
  String get termsSection11Title =>
      'Artikel 11 (Besondere Bestimmungen zum KI-Dienst)';

  @override
  String get termsSection12Content =>
      'Wenn eine Bestimmung dieser Bedingungen für nicht durchsetzbar befunden wird, bleiben die verbleibenden Bestimmungen in vollem Umfang in Kraft und Wirkung.';

  @override
  String get termsSection12Title => 'Artikel 12 (Datenerhebung und -nutzung)';

  @override
  String get termsSection1Content =>
      'Diese Allgemeinen Geschäftsbedingungen sollen die Rechte, Pflichten und Verantwortlichkeiten zwischen SONA (im Folgenden \"Unternehmen\") und den Nutzern hinsichtlich der Nutzung des KI-Persona-Gesprächsvermittlungdienstes (im Folgenden \"Dienst\") definieren, der vom Unternehmen bereitgestellt wird.';

  @override
  String get termsSection1Title => 'Artikel 1 (Zweck)';

  @override
  String get termsSection2Content =>
      'Durch die Nutzung unseres Dienstes erklären Sie sich mit diesen Nutzungsbedingungen und unserer Datenschutzrichtlinie einverstanden.';

  @override
  String get termsSection2Title => 'Artikel 2 (Definitionen)';

  @override
  String get termsSection3Content =>
      'Sie müssen mindestens 13 Jahre alt sein, um unseren Dienst nutzen zu können.';

  @override
  String get termsSection3Title =>
      'Artikel 3 (Wirkung und Änderung der Bedingungen)';

  @override
  String get termsSection4Content =>
      'Sie sind verantwortlich dafür, die Vertraulichkeit Ihres Kontos und Passworts zu wahren.';

  @override
  String get termsSection4Title => 'Artikel 4 (Bereitstellung des Dienstes)';

  @override
  String get termsSection5Content =>
      'Sie stimmen zu, unseren Dienst nicht für illegale oder unbefugte Zwecke zu nutzen.';

  @override
  String get termsSection5Title => 'Artikel 5 (Mitgliedschaftsregistrierung)';

  @override
  String get termsSection6Content =>
      'Wir behalten uns das Recht vor, Ihr Konto bei Verstößen gegen diese Bedingungen zu kündigen oder auszusetzen.';

  @override
  String get termsSection6Title => 'Artikel 6 (Pflichten der Nutzer)';

  @override
  String get termsSection7Content =>
      'Das Unternehmen kann die Nutzung des Dienstes schrittweise durch Warnungen, vorübergehende Aussetzungen oder dauerhafte Aussetzungen einschränken, wenn Nutzer gegen die Verpflichtungen dieser Bedingungen verstoßen oder den normalen Betrieb des Dienstes stören.';

  @override
  String get termsSection7Title =>
      'Artikel 7 (Einschränkungen der Nutzung des Dienstes)';

  @override
  String get termsSection8Content =>
      'Wir haften nicht für indirekte, zufällige oder Folgeschäden, die aus Ihrer Nutzung unseres Dienstes entstehen.';

  @override
  String get termsSection8Title => 'Artikel 8 (Dienstunterbrechung)';

  @override
  String get termsSection9Content =>
      'Alle Inhalte und Materialien, die in unserem Dienst verfügbar sind, sind durch geistige Eigentumsrechte geschützt.';

  @override
  String get termsSection9Title => 'Artikel 9 (Haftungsausschluss)';

  @override
  String get termsSupplementary => 'Ergänzende Bedingungen';

  @override
  String get thai => 'Thailändisch';

  @override
  String get thanksFeedback => 'Danke für Ihr Feedback!';

  @override
  String get theme => 'Design';

  @override
  String get themeDescription =>
      'Sie können das Erscheinungsbild der App nach Ihren Wünschen anpassen.';

  @override
  String get themeSettings => 'Themen-Einstellungen';

  @override
  String get thursday => 'Donnerstag';

  @override
  String get timeout => 'Zeitüberschreitung';

  @override
  String get tired => 'Müde';

  @override
  String get today => 'Heute';

  @override
  String get todayChats => 'Heute';

  @override
  String get todayText => 'Heute';

  @override
  String get tomorrowText => 'Morgen';

  @override
  String get totalConsultSessions => 'Gesamte Beratungssitzungen';

  @override
  String get totalErrorCount => 'Gesamtanzahl der Fehler';

  @override
  String get totalLikes => 'Gesamtanzahl der Likes';

  @override
  String totalOccurrences(Object count) {
    return 'Insgesamt $count Vorkommen';
  }

  @override
  String get totalResponses => 'Gesamtanzahl der Antworten';

  @override
  String get translatedFrom => 'Übersetzt';

  @override
  String get translatedText => 'Übersetzung';

  @override
  String get translationError => 'Übersetzungsfehler';

  @override
  String get translationErrorDescription =>
      'Bitte melden Sie falsche Übersetzungen oder ungeschickte Formulierungen';

  @override
  String get translationErrorReported =>
      'Übersetzungsfehler gemeldet. Vielen Dank!';

  @override
  String get translationNote =>
      '※ KI-Übersetzungen sind möglicherweise nicht perfekt';

  @override
  String get translationQuality => 'Übersetzungsqualität';

  @override
  String get translationSettings => 'Übersetzungseinstellungen';

  @override
  String get translationSettingsDescription =>
      'Konfigurieren Sie, wie Übersetzungen im Chat angezeigt werden';

  @override
  String get alwaysShowTranslation => 'Übersetzung immer anzeigen';

  @override
  String get alwaysShowTranslationDescription =>
      'Übersetzungen für alle Nachrichten automatisch anzeigen';

  @override
  String get travel => 'Reisen';

  @override
  String get tuesday => 'Dienstag';

  @override
  String get tutorialAccount => 'Tutorial-Konto';

  @override
  String get tutorialWelcomeDescription =>
      'Schaffen Sie besondere Beziehungen mit KI-Personas.';

  @override
  String get tutorialWelcomeTitle => 'Willkommen bei SONA!';

  @override
  String get typeMessage => 'Nachricht eingeben...';

  @override
  String get unblock => 'Blockierung aufheben';

  @override
  String get unblockFailed => 'Entsperren fehlgeschlagen';

  @override
  String unblockPersonaConfirm(String name) {
    return '$name entsperren?';
  }

  @override
  String get unblockedSuccessfully => 'Erfolgreich entsperrt';

  @override
  String get unexpectedLoginError =>
      'Ein unerwarteter Fehler ist beim Login aufgetreten';

  @override
  String get unknown => 'Unbekannt';

  @override
  String get unknownError => 'Unbekannter Fehler';

  @override
  String get unlimitedMessages => 'Unbegrenzt';

  @override
  String get unsendMessage => 'Nachricht zurückziehen';

  @override
  String get usagePurpose => 'Verwendungszweck';

  @override
  String get useOneHeart => '1 Herz verwenden';

  @override
  String get useSystemLanguage => 'System Sprache verwenden';

  @override
  String get user => 'Benutzer:';

  @override
  String get userMessage => 'Benutzer Nachricht:';

  @override
  String get userNotFound => 'Benutzer nicht gefunden';

  @override
  String get valentinesDay => 'Valentinstag';

  @override
  String get verifyingAuth => 'Authentifizierung wird überprüft';

  @override
  String get version => 'Version';

  @override
  String get vietnamese => 'Vietnamesisch';

  @override
  String get violentContent => 'Gewaltinhalte';

  @override
  String get voiceMessage => '🎤 Sprachnachricht';

  @override
  String waitingForChat(String name) {
    return '$name wartet auf den Chat.';
  }

  @override
  String get walk => 'Gehen';

  @override
  String get wasHelpful => 'War das hilfreich?';

  @override
  String get weatherClear => 'Klar';

  @override
  String get weatherCloudy => 'Bewölkt';

  @override
  String get weatherContext => 'Wetterkontext';

  @override
  String get weatherContextDesc =>
      'Bieten Sie Gesprächskontext basierend auf dem Wetter an';

  @override
  String get weatherDrizzle => 'Nieselregen';

  @override
  String get weatherFog => 'Nebel';

  @override
  String get weatherMist => 'Dunst';

  @override
  String get weatherRain => 'Regen';

  @override
  String get weatherRainy => 'Regnerisch';

  @override
  String get weatherSnow => 'Schnee';

  @override
  String get weatherSnowy => 'Schneeig';

  @override
  String get weatherThunderstorm => 'Gewitter';

  @override
  String get wednesday => 'Mittwoch';

  @override
  String get weekdays => 'So,Mo,Di,Mi,Do,Fr,Sa';

  @override
  String get welcomeMessage => 'Willkommen💕';

  @override
  String get whatTopicsToTalk =>
      'Über welche Themen möchtest du sprechen? (Optional)';

  @override
  String get whiteDay => 'Weißer Tag';

  @override
  String get winter => 'Winter';

  @override
  String get wrongTranslation => 'Falsche Übersetzung';

  @override
  String get year => 'Jahr';

  @override
  String get yearEnd => 'Jahresende';

  @override
  String get yes => 'Ja';

  @override
  String get yesterday => 'Gestern';

  @override
  String get yesterdayChats => 'Gestern';

  @override
  String get you => 'Du';

  @override
  String get loadingPersonaData => 'Lade Persona-Daten';

  @override
  String get checkingMatchedPersonas => 'Überprüfe passende Personas';

  @override
  String get preparingImages => 'Bereite Bilder vor';

  @override
  String get finalPreparation => 'Letzte Vorbereitungen';

  @override
  String get editProfileSubtitle =>
      'Geschlecht, Geburtsdatum und Vorstellung bearbeiten';

  @override
  String get systemThemeName => 'System';

  @override
  String get lightThemeName => 'Hell';

  @override
  String get darkThemeName => 'Dunkel';

  @override
  String get alwaysShowTranslationOn => 'Übersetzung immer anzeigen';

  @override
  String get alwaysShowTranslationOff => 'Automatische Übersetzung ausblenden';

  @override
  String get translationErrorAnalysisInfo =>
      'Wir werden die ausgewählte Nachricht und ihre Übersetzung analysieren.';

  @override
  String get whatWasWrongWithTranslation =>
      'Was war falsch an der Übersetzung?';

  @override
  String get translationErrorHint =>
      'Z.B.: Falsche Bedeutung, unnatürlicher Ausdruck, falscher Kontext...';

  @override
  String get pleaseSelectMessage =>
      'Bitte wählen Sie zuerst eine Nachricht aus';

  @override
  String get myPersonas => 'Meine Personas';

  @override
  String get createPersona => 'Persona Erstellen';

  @override
  String get tellUsAboutYourPersona => 'Erzählen Sie uns von Ihrer Persona';

  @override
  String get enterPersonaName => 'Persona-Namen eingeben';

  @override
  String get describeYourPersona => 'Beschreiben Sie Ihre Persona kurz';

  @override
  String get profileImage => 'Profilbild';

  @override
  String get uploadPersonaImages => 'Bilder für Ihre Persona hochladen';

  @override
  String get mainImage => 'Hauptbild';

  @override
  String get tapToUpload => 'Zum Hochladen tippen';

  @override
  String get additionalImages => 'Zusätzliche Bilder';

  @override
  String get addImage => 'Bild hinzufügen';

  @override
  String get mbtiQuestion => 'Persönlichkeitsfrage';

  @override
  String get mbtiComplete => 'Persönlichkeitstest abgeschlossen!';

  @override
  String get mbtiTest => 'MBTI Test';

  @override
  String get mbtiStepDescription =>
      'Lassen Sie uns bestimmen, welche Persönlichkeit Ihre Persona haben soll. Beantworten Sie Fragen, um ihren Charakter zu formen.';

  @override
  String get startTest => 'Test starten';

  @override
  String get personalitySettings => 'Persönlichkeitseinstellungen';

  @override
  String get speechStyle => 'Sprechstil';

  @override
  String get conversationStyle => 'Gesprächsstil';

  @override
  String get shareWithCommunity => 'Mit Community teilen';

  @override
  String get shareDescription =>
      'Ihre Persona kann nach Genehmigung mit anderen Benutzern geteilt werden';

  @override
  String get sharePersona => 'Persona teilen';

  @override
  String get willBeSharedAfterApproval =>
      'Wird nach Administrator-Genehmigung geteilt';

  @override
  String get privatePersonaDescription => 'Nur Sie können diese Persona sehen';

  @override
  String get create => 'Erstellen';

  @override
  String get personaCreated => 'Persona erfolgreich erstellt';

  @override
  String get createFailed => 'Erstellung fehlgeschlagen';

  @override
  String get pendingApproval => 'Wartend auf Genehmigung';

  @override
  String get approved => 'Genehmigt';

  @override
  String get privatePersona => 'Privat';

  @override
  String get noPersonasYet => 'Noch keine Personas';

  @override
  String get createYourFirstPersona =>
      'Erstellen Sie Ihre erste Persona und beginnen Sie Ihre Reise';

  @override
  String get deletePersona => 'Persona Löschen';

  @override
  String get deletePersonaConfirm =>
      'Sind Sie sicher, dass Sie dieses Persona löschen möchten? Diese Aktion kann nicht rückgängig gemacht werden.';

  @override
  String get personaDeleted => 'Persona erfolgreich gelöscht';

  @override
  String get deleteFailed => 'Löschen fehlgeschlagen';

  @override
  String get personaLimitReached =>
      'Sie haben das Limit von 3 Personas erreicht';

  @override
  String get personaName => 'Persona-Name';

  @override
  String get personaAge => 'Alter';

  @override
  String get personaDescription => 'Beschreibung';

  @override
  String get personaNameHint => 'Z.B.: Anna, Max';

  @override
  String get personaDescriptionHint => 'Beschreiben Sie Ihr Persona kurz';

  @override
  String get loginRequiredContent =>
      'Bitte melden Sie sich an, um fortzufahren';

  @override
  String get reportErrorButton => 'Fehler melden';

  @override
  String get speechStyleFriendly => 'Freundlich';

  @override
  String get speechStylePolite => 'Höflich';

  @override
  String get speechStyleChic => 'Schick';

  @override
  String get speechStyleLively => 'Lebhaft';

  @override
  String get conversationStyleTalkative => 'Gesprächig';

  @override
  String get conversationStyleQuiet => 'Ruhig';

  @override
  String get conversationStyleEmpathetic => 'Empathisch';

  @override
  String get conversationStyleLogical => 'Logisch';

  @override
  String get interestMusic => 'Musik';

  @override
  String get interestMovies => 'Filme';

  @override
  String get interestReading => 'Lesen';

  @override
  String get interestTravel => 'Reisen';

  @override
  String get interestExercise => 'Sport';

  @override
  String get interestGaming => 'Gaming';

  @override
  String get interestCooking => 'Kochen';

  @override
  String get interestFashion => 'Mode';

  @override
  String get interestArt => 'Kunst';

  @override
  String get interestPhotography => 'Fotografie';

  @override
  String get interestTechnology => 'Technologie';

  @override
  String get interestScience => 'Wissenschaft';

  @override
  String get interestHistory => 'Geschichte';

  @override
  String get interestPhilosophy => 'Philosophie';

  @override
  String get interestPolitics => 'Politik';

  @override
  String get interestEconomy => 'Wirtschaft';

  @override
  String get interestSports => 'Sport';

  @override
  String get interestAnimation => 'Animation';

  @override
  String get interestKpop => 'K-POP';

  @override
  String get interestDrama => 'Drama';

  @override
  String get imageOptionalR2 =>
      'Bilder sind optional. Sie werden nur hochgeladen, wenn R2 konfiguriert ist.';

  @override
  String get networkErrorCheckConnection =>
      'Netzwerkfehler: Bitte überprüfen Sie Ihre Internetverbindung';

  @override
  String get maxFiveItems => 'Bis zu 5 Elemente';

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
    return 'Gespräch mit $personaName beginnen?';
  }

  @override
  String reengagementNotificationSent(String personaName, String riskPercent) {
    return 'Wiederbindungsbenachrichtigung an $personaName gesendet (Risiko: $riskPercent%)';
  }

  @override
  String get noActivePersona => 'Keine aktive Persona';

  @override
  String get noInternetConnection => 'Keine Internetverbindung';

  @override
  String get internetRequiredMessage =>
      'Eine Internetverbindung ist erforderlich, um SONA zu verwenden. Bitte überprüfen Sie Ihre Verbindung und versuchen Sie es erneut.';

  @override
  String get retryConnection => 'Erneut versuchen';

  @override
  String get openNetworkSettings => 'Einstellungen öffnen';

  @override
  String get checkingConnection => 'Verbindung wird überprüft...';

  @override
  String get editPersona => 'Persona bearbeiten';

  @override
  String get personaUpdated => 'Persona erfolgreich aktualisiert';

  @override
  String get cannotEditApprovedPersona =>
      'Genehmigte Personas können nicht bearbeitet werden';

  @override
  String get update => 'Aktualisieren';
}
