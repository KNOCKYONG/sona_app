// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get about => 'Informazioni';

  @override
  String get accountAndProfile => 'Informazioni su Account e Profilo';

  @override
  String get accountDeletedSuccess => 'Account eliminato con successo';

  @override
  String get accountDeletionContent =>
      'Sei sicuro di voler eliminare il tuo account?';

  @override
  String get accountDeletionError =>
      'Si è verificato un errore durante l\'eliminazione dell\'account.';

  @override
  String get accountDeletionInfo =>
      'Informazioni sull\'eliminazione dell\'account';

  @override
  String get accountDeletionTitle => 'Elimina Account';

  @override
  String get accountDeletionWarning1 =>
      'Attenzione: Questa azione non può essere annullata';

  @override
  String get accountDeletionWarning2 =>
      'Tutti i tuoi dati saranno eliminati permanentemente';

  @override
  String get accountDeletionWarning3 =>
      'Perderai l\'accesso a tutte le conversazioni';

  @override
  String get accountDeletionWarning4 =>
      'Questo include tutti i contenuti acquistati';

  @override
  String get accountManagement => 'Gestione Account';

  @override
  String get adaptiveConversationDesc =>
      'Adatta lo stile della conversazione per allinearsi al tuo';

  @override
  String get afternoon => 'Pomeriggio';

  @override
  String get afternoonFatigue => 'Fatica pomeridiana';

  @override
  String get ageConfirmation =>
      'Ho 14 anni o più e ho confermato quanto sopra.';

  @override
  String ageRange(int min, int max) {
    return '$min-$max anni';
  }

  @override
  String get ageUnit => 'anni';

  @override
  String get agreeToTerms => 'Accetto i termini';

  @override
  String get aiDatingQuestion => 'Una vita quotidiana speciale con l\'AI';

  @override
  String get aiPersonaPreferenceDescription =>
      'Imposta le tue preferenze per l\'abbinamento delle persone AI';

  @override
  String get all => 'Tutto';

  @override
  String get allAgree => 'Accetta tutto';

  @override
  String get allFeaturesRequired =>
      '※ Tutte le funzionalità sono necessarie per la fornitura del servizio';

  @override
  String get allPersonas => 'Tutte le Personas';

  @override
  String get allPersonasMatched =>
      'Tutte le personas abbinate! Inizia a chattare con loro.';

  @override
  String get allowPermission => 'Continua';

  @override
  String alreadyChattingWith(String name) {
    return 'Stai già chattando con $name!';
  }

  @override
  String get alsoBlockThisAI => 'Blocca anche questa IA';

  @override
  String get angry => 'Arrabbiato';

  @override
  String get anonymousLogin => 'Accesso anonimo';

  @override
  String get anxious => 'Ansioso';

  @override
  String get apiKeyError => 'Errore della chiave API';

  @override
  String get appName => 'SONA';

  @override
  String get appTagline => 'I tuoi compagni IA';

  @override
  String get appleLoginCanceled => 'L\'accesso con Apple è stato annullato.';

  @override
  String get appleLoginError =>
      'Si è verificato un errore durante l\'accesso con Apple.';

  @override
  String get art => 'Arte';

  @override
  String get authError => 'Errore di autenticazione';

  @override
  String get autoTranslate => 'Traduzione automatica';

  @override
  String get autumn => 'Autunno';

  @override
  String get averageQuality => 'Qualità Media';

  @override
  String get averageQualityScore => 'Punteggio Qualità Media';

  @override
  String get awkwardExpression => 'Espressione Imbarazzante';

  @override
  String get backButton => 'Indietro';

  @override
  String get basicInfo => 'Informazioni di Base';

  @override
  String get basicInfoDescription =>
      'Si prega di inserire informazioni di base per creare un account';

  @override
  String get birthDate => 'Data di Nascita';

  @override
  String get birthDateOptional => 'Data di Nascita (Facoltativa)';

  @override
  String get birthDateRequired => 'Data di nascita *';

  @override
  String get blockConfirm => 'Vuoi bloccare questa IA?';

  @override
  String get blockReason => 'Motivo del blocco';

  @override
  String get blockThisAI => 'Blocca questa IA';

  @override
  String blockedAICount(int count) {
    return '$count IA bloccate';
  }

  @override
  String get blockedAIs => 'IA bloccate';

  @override
  String get blockedAt => 'Bloccato il';

  @override
  String get blockedSuccessfully => 'Bloccato con successo';

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
  String get cameraPermission => 'Permesso fotocamera';

  @override
  String get cameraPermissionDesc =>
      'L\'accesso alla fotocamera è necessario per scattare foto del profilo.';

  @override
  String get canChangeInSettings => 'You can change this later in settings';

  @override
  String get canMeetPreviousPersonas =>
      'Puoi incontrare di nuovo le personas che hai scambiato in precedenza!';

  @override
  String get cancel => 'Annulla';

  @override
  String get changeProfilePhoto => 'Cambia foto profilo';

  @override
  String get chat => 'Chat';

  @override
  String get chatEndedMessage => 'La chat è terminata';

  @override
  String get chatErrorDashboard => 'Dashboard degli errori di chat';

  @override
  String get chatErrorSentSuccessfully =>
      'L\'errore della chat è stato inviato con successo.';

  @override
  String get chatListTab => 'Scheda della lista chat';

  @override
  String get chats => 'Chat';

  @override
  String chattingWithPersonas(int count) {
    return 'Chatting con $count personas';
  }

  @override
  String get checkInternetConnection => 'Controlla la tua connessione internet';

  @override
  String get checkingUserInfo => 'Controllo informazioni utente';

  @override
  String get childrensDay => 'Giorno dei Bambini';

  @override
  String get chinese => 'Cinese';

  @override
  String get chooseOption => 'Si prega di scegliere:';

  @override
  String get christmas => 'Natale';

  @override
  String get close => 'Chiudi';

  @override
  String get complete => 'Fatto';

  @override
  String get completeSignup => 'Completa la registrazione';

  @override
  String get confirm => 'Conferma';

  @override
  String get connectingToServer => 'Connessione al server';

  @override
  String get consultQualityMonitoring =>
      'Monitoraggio della Qualità della Consultazione';

  @override
  String get continueAsGuest => 'Continua come Ospite';

  @override
  String get continueButton => 'Continua';

  @override
  String get continueWithApple => 'Continua con Apple';

  @override
  String get continueWithGoogle => 'Continua con Google';

  @override
  String get conversationContinuity => 'Continuità della Conversazione';

  @override
  String get conversationContinuityDesc =>
      'Ricorda le conversazioni precedenti e collega gli argomenti';

  @override
  String conversationWith(String name) {
    return '$name';
  }

  @override
  String get convertToMember => 'Iscriviti';

  @override
  String get cooking => 'Cucinare';

  @override
  String get copyMessage => 'Copia messaggio';

  @override
  String get copyrightInfringement => 'Violazione del copyright';

  @override
  String get creatingAccount => 'Creazione account';

  @override
  String get crisisDetected => 'Crisi Rilevata';

  @override
  String get culturalIssue => 'Problema Culturale';

  @override
  String get current => 'Corrente';

  @override
  String get currentCacheSize => 'Dimensione Cache Corrente';

  @override
  String get currentLanguage => 'Lingua attuale';

  @override
  String get cycling => 'Ciclismo';

  @override
  String get dailyCare => 'Cura Giornaliera';

  @override
  String get dailyCareDesc =>
      'Messaggi di cura giornaliera per pasti, sonno, salute';

  @override
  String get dailyChat => 'Chat Giornaliera';

  @override
  String get dailyCheck => 'Controllo Giornaliero';

  @override
  String get dailyConversation => 'Conversazione Giornaliera';

  @override
  String get dailyLimitDescription =>
      'Hai raggiunto il limite giornaliero di messaggi';

  @override
  String get dailyLimitTitle => 'Limite giornaliero raggiunto';

  @override
  String get darkMode => 'Modalità scura';

  @override
  String get darkTheme => 'Modalità Scura';

  @override
  String get darkThemeDesc => 'Usa tema scuro';

  @override
  String get dataCollection => 'Impostazioni Raccolta Dati';

  @override
  String get datingAdvice => 'Consigli per gli appuntamenti';

  @override
  String get datingDescription =>
      'Voglio condividere pensieri profondi e avere conversazioni sincere';

  @override
  String get dawn => 'Alba';

  @override
  String get day => 'Giorno';

  @override
  String get dayAfterTomorrow => 'Dopodomani';

  @override
  String daysAgo(int count, String formatted) {
    return '$count giorni fa';
  }

  @override
  String daysRemaining(int days) {
    return '$days giorni rimanenti';
  }

  @override
  String get deepTalk => 'Conversazione profonda';

  @override
  String get delete => 'Elimina';

  @override
  String get deleteAccount => 'Elimina account';

  @override
  String get deleteAccountConfirm =>
      'Sei sicuro di voler eliminare il tuo account? Questa azione non può essere annullata.';

  @override
  String get deleteAccountWarning =>
      'Sei sicuro di voler eliminare il tuo account?';

  @override
  String get deleteCache => 'Elimina Cache';

  @override
  String get deletingAccount => 'Eliminazione account...';

  @override
  String get depressed => 'Depresso';

  @override
  String get describeError => 'Qual è il problema?';

  @override
  String get detailedReason => 'Motivo dettagliato';

  @override
  String get developRelationshipStep =>
      '3. Sviluppa Relazione: Costruisci intimità attraverso conversazioni e sviluppa relazioni speciali.';

  @override
  String get dinner => 'Cena';

  @override
  String get discardGuestData => 'Inizia da capo';

  @override
  String get discount20 => '20% di sconto';

  @override
  String get discount30 => '30% di sconto';

  @override
  String get discountAmount => 'Risparmia';

  @override
  String discountAmountValue(String amount) {
    return 'Risparmia ₩$amount';
  }

  @override
  String get done => 'Fatto';

  @override
  String get downloadingPersonaImages => 'Downloading nuove immagini persona';

  @override
  String get edit => 'Modifica';

  @override
  String get editInfo => 'Modifica Info';

  @override
  String get editProfile => 'Modifica Profilo';

  @override
  String get effectSound => 'Effetti Sonori';

  @override
  String get effectSoundDescription => 'Riproduci effetti sonori';

  @override
  String get email => 'Email';

  @override
  String get emailHint => 'example@email.com';

  @override
  String get emailLabel => 'Email';

  @override
  String get emailRequired => 'Email *';

  @override
  String get emotionAnalysis => 'Analisi delle Emozioni';

  @override
  String get emotionAnalysisDesc =>
      'Analizza le emozioni per risposte empatiche';

  @override
  String get emotionAngry => 'Arrabbiato';

  @override
  String get emotionBasedEncounters => 'Incontri basati sulle emozioni';

  @override
  String get emotionCool => 'Figo';

  @override
  String get emotionHappy => 'Felice';

  @override
  String get emotionLove => 'Amore';

  @override
  String get emotionSad => 'Triste';

  @override
  String get emotionThinking => 'Pensando';

  @override
  String get emotionalSupportDesc =>
      'Condividi le tue preoccupazioni e ricevi conforto caloroso';

  @override
  String get endChat => 'Termina chat';

  @override
  String get endTutorial => 'Termina tutorial';

  @override
  String get endTutorialAndLogin => 'Terminare il tutorial e accedere?';

  @override
  String get endTutorialMessage => 'Vuoi terminare il tutorial e accedere?';

  @override
  String get english => 'English';

  @override
  String get enterBasicInfo =>
      'Si prega di inserire informazioni di base per creare un account';

  @override
  String get enterBasicInformation =>
      'Si prega di inserire informazioni di base';

  @override
  String get enterEmail => 'Si prega di inserire l\'email';

  @override
  String get enterNickname => 'Inserisci un nickname';

  @override
  String get enterPassword => 'Inserisci una password';

  @override
  String get entertainmentAndFunDesc =>
      'Goditi giochi divertenti e conversazioni piacevoli';

  @override
  String get entertainmentDescription =>
      'Voglio avere conversazioni divertenti e godermi il mio tempo';

  @override
  String get entertainmentFun => 'Intrattenimento/Divertimento';

  @override
  String get error => 'Errore';

  @override
  String get errorDescription => 'Descrizione errore';

  @override
  String get errorDescriptionHint =>
      'ad es., Ha dato risposte strane, Ripete la stessa cosa, Fornisce risposte contestualmente inappropriate...';

  @override
  String get errorDetails => 'Dettagli dell\'errore';

  @override
  String get errorDetailsHint =>
      'Si prega di spiegare in dettaglio cosa c\'è di sbagliato';

  @override
  String get errorFrequency24h => 'Frequenza degli errori (Ultime 24 ore)';

  @override
  String get errorMessage => 'Messaggio di errore:';

  @override
  String get errorOccurred => 'Si è verificato un errore.';

  @override
  String get errorOccurredTryAgain =>
      'Si è verificato un errore. Si prega di riprovare.';

  @override
  String get errorSendingFailed => 'Invio dell\'errore non riuscito';

  @override
  String get errorStats => 'Statistiche sugli errori';

  @override
  String errorWithMessage(String error) {
    return 'Si è verificato un errore: $error';
  }

  @override
  String get evening => 'Sera';

  @override
  String get excited => 'Eccitato';

  @override
  String get exit => 'Esci';

  @override
  String get exitApp => 'Esci dall\'app';

  @override
  String get exitConfirmMessage => 'Sei sicuro di voler uscire dall\'app?';

  @override
  String get expertPersona => 'Persona Esperta';

  @override
  String get expertiseScore => 'Punteggio di Competenza';

  @override
  String get expired => 'Scaduto';

  @override
  String get explainReportReason =>
      'Si prega di spiegare il motivo del rapporto in dettaglio';

  @override
  String get fashion => 'Moda';

  @override
  String get female => 'Femmina';

  @override
  String get filter => 'Filtro';

  @override
  String get firstOccurred => 'Prima Occorrenza:';

  @override
  String get followDeviceLanguage =>
      'Segui le impostazioni della lingua del dispositivo';

  @override
  String get forenoon => 'Mattina';

  @override
  String get forgotPassword => 'Password dimenticata?';

  @override
  String get frequentlyAskedQuestions => 'Domande Frequenti';

  @override
  String get friday => 'Friday';

  @override
  String get friendshipDescription =>
      'I want to meet new friends and have conversations';

  @override
  String get funChat => 'Fun Chat';

  @override
  String get galleryPermission => 'Permesso galleria';

  @override
  String get galleryPermissionDesc =>
      'L\'accesso alla galleria è necessario per selezionare foto del profilo.';

  @override
  String get gaming => 'Gaming';

  @override
  String get gender => 'Genere';

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
      'Verranno mostrati solo i personaggi di genere opposto';

  @override
  String get genderRequired => 'Genere *';

  @override
  String get genderSelectionInfo =>
      'Se non selezionato, puoi incontrare personaggi di tutti i generi';

  @override
  String get generalPersona => 'Persona Generale';

  @override
  String get goToSettings => 'Vai alle impostazioni';

  @override
  String get googleLoginCanceled => 'Il login con Google è stato annullato.';

  @override
  String get googleLoginError =>
      'Si è verificato un errore durante il login con Google.';

  @override
  String get grantPermission => 'Continua';

  @override
  String get guest => 'Ospite';

  @override
  String get guestDataMigration =>
      'Vuoi mantenere la tua attuale cronologia chat durante la registrazione?';

  @override
  String get guestLimitReached => 'Prova per gli ospiti terminata.';

  @override
  String get guestLoginPromptMessage =>
      'Accedi per continuare la conversazione';

  @override
  String get guestMessageExhausted => 'Messaggi gratuiti esauriti';

  @override
  String guestMessageRemaining(int count) {
    return '$count messaggi per ospiti rimanenti';
  }

  @override
  String get guestModeBanner => 'Modalità Ospite';

  @override
  String get guestModeDescription => 'Prova SONA senza registrarti';

  @override
  String get guestModeFailedMessage => 'Impossibile avviare la Modalità Ospite';

  @override
  String get guestModeLimitation =>
      'Alcune funzionalità sono limitate in Modalità Ospite';

  @override
  String get guestModeTitle => 'Prova come Ospite';

  @override
  String get guestModeWarning =>
      'La modalità ospite dura 24 ore, dopo di che i dati verranno eliminati.';

  @override
  String get guestModeWelcome => 'Inizio in modalità ospite';

  @override
  String get happy => 'Felice';

  @override
  String get hapticFeedback => 'Feedback aptico';

  @override
  String get harassmentBullying => 'Molestie/Intimidazioni';

  @override
  String get hateSpeech => 'Discorso d\'odio';

  @override
  String get heartDescription => 'Cuori per più messaggi';

  @override
  String get heartInsufficient => 'Cuori insufficienti';

  @override
  String get heartInsufficientPleaseCharge =>
      'Cuori insufficienti. Si prega di ricaricare i cuori.';

  @override
  String get heartRequired => 'È richiesto 1 cuore';

  @override
  String get heartUsageFailed => 'Impossibile utilizzare il cuore.';

  @override
  String get hearts => 'Cuori';

  @override
  String get hearts10 => '10 Cuori';

  @override
  String get hearts30 => '30 Cuori';

  @override
  String get hearts30Discount => 'SALDI';

  @override
  String get hearts50 => '50 Cuori';

  @override
  String get hearts50Discount => 'SALDI';

  @override
  String get helloEmoji => 'Ciao! 😊';

  @override
  String get help => 'Aiuto';

  @override
  String get hideOriginalText => 'Nascondi originale';

  @override
  String get hobbySharing => 'Condivisione hobby';

  @override
  String get hobbyTalk => 'Conversazione sugli hobby';

  @override
  String get hours24Ago => '24 ore fa';

  @override
  String hoursAgo(int count, String formatted) {
    return '$count ore fa';
  }

  @override
  String get howToUse => 'Come usare SONA';

  @override
  String get imageCacheManagement => 'Gestione della cache delle immagini';

  @override
  String get inappropriateContent => 'Contenuto inappropriato';

  @override
  String get incorrect => 'errato';

  @override
  String get incorrectPassword => 'Password errata';

  @override
  String get indonesian => 'Indonesiano';

  @override
  String get inquiries => 'Richieste';

  @override
  String get insufficientHearts => 'Cuori insufficienti.';

  @override
  String get interestSharing => 'Condivisione degli interessi';

  @override
  String get interestSharingDesc => 'Scopri e raccomanda interessi condivisi';

  @override
  String get interests => 'Interessi';

  @override
  String get invalidEmailFormat => 'Formato email non valido';

  @override
  String get invalidEmailFormatError => 'Inserisci un indirizzo email valido';

  @override
  String isTyping(String name) {
    return '$name sta scrivendo...';
  }

  @override
  String get japanese => 'Giapponese';

  @override
  String get joinDate => 'Data di Iscrizione';

  @override
  String get justNow => 'Proprio ora';

  @override
  String get keepGuestData => 'Mantieni Cronologia Chat';

  @override
  String get korean => 'Coreano';

  @override
  String get koreanLanguage => 'Coreano';

  @override
  String get language => 'Lingua';

  @override
  String get languageDescription => 'L\'IA risponderà nella lingua selezionata';

  @override
  String get languageIndicator => 'Lingua';

  @override
  String get languageSettings => 'Impostazioni Lingua';

  @override
  String get lastOccurred => 'Ultima Occorrenza:';

  @override
  String get lastUpdated => 'Ultimo aggiornamento';

  @override
  String get lateNight => 'Notte fonda';

  @override
  String get later => 'Più tardi';

  @override
  String get laterButton => 'Più tardi';

  @override
  String get leave => 'Lascia';

  @override
  String get leaveChatConfirm => 'Vuoi lasciare questa chat?';

  @override
  String get leaveChatRoom => 'Lascia la chat';

  @override
  String get leaveChatTitle => 'Lascia chat';

  @override
  String get lifeAdvice => 'Consigli di vita';

  @override
  String get lightTalk => 'Light Talk';

  @override
  String get lightTheme => 'Modalità Chiara';

  @override
  String get lightThemeDesc => 'Usa tema chiaro';

  @override
  String get loading => 'Caricamento...';

  @override
  String get loadingData => 'Caricamento dati...';

  @override
  String get loadingProducts => 'Caricamento prodotti...';

  @override
  String get loadingProfile => 'Caricamento profilo';

  @override
  String get login => 'Accedi';

  @override
  String get loginButton => 'Accedi';

  @override
  String get loginCancelled => 'Accesso annullato';

  @override
  String get loginComplete => 'Accesso completato';

  @override
  String get loginError => 'Accesso fallito';

  @override
  String get loginFailed => 'Accesso fallito';

  @override
  String get loginFailedTryAgain => 'Accesso fallito. Riprova.';

  @override
  String get loginRequired => 'Accesso richiesto';

  @override
  String get loginRequiredForProfile =>
      'Accesso richiesto per visualizzare il profilo';

  @override
  String get loginRequiredService =>
      'Accesso richiesto per usare questo servizio';

  @override
  String get loginRequiredTitle => 'Accesso Richiesto';

  @override
  String get loginSignup => 'Accesso/Registrati';

  @override
  String get loginTab => 'Accesso';

  @override
  String get loginTitle => 'Accesso';

  @override
  String get loginWithApple => 'Accedi con Apple';

  @override
  String get loginWithGoogle => 'Accedi con Google';

  @override
  String get logout => 'Esci';

  @override
  String get logoutConfirm => 'Sei sicuro di voler uscire?';

  @override
  String get lonelinessRelief => 'Sollievo dalla Solitudine';

  @override
  String get lonely => 'Solo';

  @override
  String get lowQualityResponses => 'Risposte di bassa qualità';

  @override
  String get lunch => 'Pranzo';

  @override
  String get lunchtime => 'Ora di pranzo';

  @override
  String get mainErrorType => 'Tipo di errore principale';

  @override
  String get makeFriends => 'Fai amicizia';

  @override
  String get male => 'Maschio';

  @override
  String get manageBlockedAIs => 'Gestisci AIs bloccati';

  @override
  String get managePersonaImageCache =>
      'Gestisci la cache delle immagini del profilo';

  @override
  String get marketingAgree =>
      'Accetta le informazioni di marketing (opzionale)';

  @override
  String get marketingDescription =>
      'Puoi ricevere informazioni sugli eventi e sui benefici';

  @override
  String get matchPersonaStep =>
      '1. Abbina le Personas: Scorri a sinistra o a destra per selezionare le tue AI personas preferite.';

  @override
  String get matchedPersonas => 'Personas abbinate';

  @override
  String get matchedSona => 'Sona abbinata';

  @override
  String get matching => 'Abbinamento';

  @override
  String get matchingFailed => 'Abbinamento fallito.';

  @override
  String get me => 'Me';

  @override
  String get meetAIPersonas => 'Incontra le AI Personas';

  @override
  String get meetNewPersonas => 'Incontra nuove personas';

  @override
  String get meetPersonas => 'Incontra le Personas';

  @override
  String get memberBenefits =>
      'Ricevi oltre 100 messaggi e 10 cuori quando ti registri!';

  @override
  String get memoryAlbum => 'Album dei Ricordi';

  @override
  String get memoryAlbumDesc =>
      'Salva e ricorda automaticamente momenti speciali';

  @override
  String get messageCopied => 'Messaggio copiato';

  @override
  String get messageDeleted => 'Messaggio eliminato';

  @override
  String get messageLimitReset =>
      'Il limite messaggi si reimposterà a mezzanotte';

  @override
  String get messageSendFailed =>
      'Invio del messaggio fallito. Per favore riprova.';

  @override
  String get messagesRemaining => 'Messaggi rimanenti';

  @override
  String minutesAgo(int count, String formatted) {
    return '$count minuti fa';
  }

  @override
  String get missingTranslation => 'Traduzione mancante';

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
  String get myGenderSection => 'Il mio genere (Opzionale)';

  @override
  String get networkErrorOccurred => 'Si è verificato un errore di rete.';

  @override
  String get newMessage => 'Nuovo messaggio';

  @override
  String newMessageCount(int count) {
    return '$count nuovi messaggi';
  }

  @override
  String get newMessageNotification => 'Notifica nuovo messaggio';

  @override
  String get newMessages => 'Nuovi messaggi';

  @override
  String get newYear => 'Nuovo Anno';

  @override
  String get next => 'Avanti';

  @override
  String get niceToMeetYou => 'Piacere di conoscerti!';

  @override
  String get nickname => 'Soprannome';

  @override
  String get nicknameAlreadyUsed => 'Questo nickname è già in uso';

  @override
  String get nicknameHelperText => '3-10 caratteri';

  @override
  String get nicknameHint => '3-10 caratteri';

  @override
  String get nicknameInUse => 'Questo nickname è già in uso';

  @override
  String get nicknameLabel => 'Soprannome';

  @override
  String get nicknameLengthError => 'Il nickname deve essere di 3-10 caratteri';

  @override
  String get nicknamePlaceholder => 'Inserisci il tuo nickname';

  @override
  String get nicknameRequired => 'Soprannome *';

  @override
  String get night => 'Notte';

  @override
  String get no => 'No';

  @override
  String get noBlockedAIs => 'Nessuna IA bloccata';

  @override
  String get noChatsYet => 'Nessuna chat ancora';

  @override
  String get noConversationYet => 'Ancora nessuna conversazione';

  @override
  String get noErrorReports => 'Nessun rapporto di errore.';

  @override
  String get noImageAvailable => 'Immagine non disponibile';

  @override
  String get noMatchedPersonas => 'Ancora nessuna persona corrispondente';

  @override
  String get noMatchedSonas => 'Nessuna Sonas corrispondente ancora';

  @override
  String get noPersonasAvailable =>
      'Nessuna persona disponibile. Per favore riprova.';

  @override
  String get noPersonasToSelect => 'Nessuna persona disponibile';

  @override
  String get noQualityIssues => 'Nessun problema di qualità nell\'ultima ora ✅';

  @override
  String get noQualityLogs => 'Nessun registro di qualità ancora.';

  @override
  String get noTranslatedMessages => 'Nessun messaggio da tradurre';

  @override
  String get notEnoughHearts => 'Non abbastanza cuori';

  @override
  String notEnoughHeartsCount(int count) {
    return 'Non abbastanza cuori. (Attuale: $count)';
  }

  @override
  String get notRegistered => 'non registrato';

  @override
  String get notSubscribed => 'Non iscritto';

  @override
  String get notificationPermissionDesc =>
      'Il permesso di notifica è necessario per ricevere nuovi messaggi.';

  @override
  String get notificationPermissionRequired => 'Permesso di notifica richiesto';

  @override
  String get notificationSettings => 'Impostazioni notifiche';

  @override
  String get notifications => 'Notifiche';

  @override
  String get occurrenceInfo => 'Informazioni sull\'Occorrenza:';

  @override
  String get olderChats => 'Più Vecchi';

  @override
  String get onlyOppositeGenderNote =>
      'Se non selezionato, verranno mostrati solo i personaggi di genere opposto';

  @override
  String get openSettings => 'Apri Impostazioni';

  @override
  String get optional => 'Facoltativo';

  @override
  String get or => 'or';

  @override
  String get originalPrice => 'Originale';

  @override
  String get originalText => 'Originale';

  @override
  String get other => 'Altro';

  @override
  String get otherError => 'Altro Errore';

  @override
  String get others => 'Altri';

  @override
  String get ownedHearts => 'Cuori Posseduti';

  @override
  String get parentsDay => 'Giornata dei Genitori';

  @override
  String get password => 'Password';

  @override
  String get passwordConfirmation => 'Inserisci la password per confermare';

  @override
  String get passwordConfirmationDesc =>
      'Si prega di reinserire la password per eliminare l\'account.';

  @override
  String get passwordHint => '6 caratteri o più';

  @override
  String get passwordLabel => 'Password';

  @override
  String get passwordRequired => 'Password *';

  @override
  String get passwordResetEmailPrompt =>
      'Per favore inserisci la tua email per reimpostare la password';

  @override
  String get passwordResetEmailSent =>
      'L\'email per la reimpostazione della password è stata inviata. Controlla la tua email.';

  @override
  String get passwordText => 'password';

  @override
  String get passwordTooShort =>
      'La password deve essere lunga almeno 6 caratteri';

  @override
  String get permissionDenied => 'Permesso negato';

  @override
  String permissionDeniedMessage(String permissionName) {
    return 'Il permesso $permissionName è stato negato.\\nPer favore consenti il permesso nelle impostazioni.';
  }

  @override
  String get permissionDeniedTryLater =>
      'Permesso negato. Per favore riprova più tardi.';

  @override
  String get permissionRequired => 'Permesso richiesto';

  @override
  String get personaGenderSection => 'Preferenza di Genere della Persona';

  @override
  String get personaQualityStats => 'Statistiche di Qualità della Persona';

  @override
  String get personalInfoExposure => 'Esposizione informazioni personali';

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
  String get preparingNewMeeting => 'Preparazione di una nuova riunione';

  @override
  String get preparingPersonaImages =>
      'Preparazione delle immagini delle persone';

  @override
  String get preparingPersonas => 'Preparazione delle persone';

  @override
  String get preview => 'Anteprima';

  @override
  String get previous => 'Indietro';

  @override
  String get privacy => 'Privacy';

  @override
  String get privacyPolicy => 'Politica sulla privacy';

  @override
  String get privacyPolicyAgreement => 'Accetta la politica sulla privacy';

  @override
  String get privacySection1Content =>
      'Ci impegniamo a proteggere la tua privacy. Questa Informativa sulla Privacy spiega come raccogliamo, utilizziamo e proteggiamo le tue informazioni quando utilizzi il nostro servizio.';

  @override
  String get privacySection1Title =>
      '1. Scopo della raccolta e utilizzo delle informazioni personali';

  @override
  String get privacySection2Content =>
      'Raccogliamo informazioni che ci fornisci direttamente, ad esempio quando crei un account, aggiorni il tuo profilo o utilizzi i nostri servizi.';

  @override
  String get privacySection2Title => 'Informazioni che raccogliamo';

  @override
  String get privacySection3Content =>
      'Utilizziamo le informazioni che raccogliamo per fornire, mantenere e migliorare i nostri servizi e per comunicare con te.';

  @override
  String get privacySection3Title =>
      '3. Periodo di Conservazione e Utilizzo delle Informazioni Personali';

  @override
  String get privacySection4Content =>
      'Non vendiamo, scambiamo o trasferiamo in altro modo le tue informazioni personali a terzi senza il tuo consenso.';

  @override
  String get privacySection4Title =>
      '4. Fornitura di Informazioni Personali a Terzi';

  @override
  String get privacySection5Content =>
      'Implementiamo misure di sicurezza appropriate per proteggere le tue informazioni personali da accessi non autorizzati, alterazioni, divulgazioni o distruzioni.';

  @override
  String get privacySection5Title =>
      '5. Misure Tecniche di Protezione per le Informazioni Personali';

  @override
  String get privacySection6Content =>
      'Conserviamo le informazioni personali per tutto il tempo necessario a fornire i nostri servizi e a rispettare gli obblighi legali.';

  @override
  String get privacySection6Title => '6. Diritti degli Utenti';

  @override
  String get privacySection7Content =>
      'Hai il diritto di accedere, aggiornare o eliminare le tue informazioni personali in qualsiasi momento tramite le impostazioni del tuo account.';

  @override
  String get privacySection7Title => 'I Tuoi Diritti';

  @override
  String get privacySection8Content =>
      'Se hai domande su questa Informativa sulla Privacy, ti preghiamo di contattarci a support@sona.com.';

  @override
  String get privacySection8Title => 'Contattaci';

  @override
  String get privacySettings => 'Impostazioni sulla Privacy';

  @override
  String get privacySettingsInfo =>
      'Disabilitare singole funzionalità renderà quei servizi non disponibili';

  @override
  String get privacySettingsScreen => 'Impostazioni sulla Privacy';

  @override
  String get problemMessage => 'Problema';

  @override
  String get problemOccurred => 'Si è verificato un problema';

  @override
  String get profile => 'Profilo';

  @override
  String get profileEdit => 'Modifica Profilo';

  @override
  String get profileEditLoginRequiredMessage =>
      'È necessario effettuare il login per modificare il tuo profilo.';

  @override
  String get profileInfo => 'Informazioni sul Profilo';

  @override
  String get profileInfoDescription =>
      'Si prega di inserire la foto del profilo e le informazioni di base';

  @override
  String get profileNav => 'Profilo';

  @override
  String get profilePhoto => 'Foto del Profilo';

  @override
  String get profilePhotoAndInfo =>
      'Si prega di inserire la foto del profilo e le informazioni di base';

  @override
  String get profilePhotoUpdateFailed =>
      'Impossibile aggiornare la foto del profilo';

  @override
  String get profilePhotoUpdated => 'Foto del profilo aggiornata';

  @override
  String get profileSettings => 'Impostazioni del profilo';

  @override
  String get profileSetup => 'Configurazione del profilo';

  @override
  String get profileUpdateFailed => 'Impossibile aggiornare il profilo';

  @override
  String get profileUpdated => 'Profilo aggiornato con successo';

  @override
  String get purchaseAndRefundPolicy => 'Politica di acquisto e rimborso';

  @override
  String get purchaseButton => 'Acquista';

  @override
  String get purchaseConfirm => 'Conferma di acquisto';

  @override
  String purchaseConfirmContent(String product, String price) {
    return 'Acquistare $product per $price?';
  }

  @override
  String purchaseConfirmMessage(
      String title, String price, String description) {
    return 'Confermare l\'acquisto di $title per $price? $description';
  }

  @override
  String get purchaseFailed => 'Acquisto non riuscito';

  @override
  String get purchaseHeartsOnly => 'Acquista cuori';

  @override
  String get purchaseMoreHearts =>
      'Acquista cuori per continuare le conversazioni';

  @override
  String get purchasePending => 'Acquisto in sospeso...';

  @override
  String get purchasePolicy => 'Politica di acquisto';

  @override
  String get purchaseSection1Content =>
      'Accettiamo vari metodi di pagamento, tra cui carte di credito e portafogli digitali.';

  @override
  String get purchaseSection1Title => 'Metodi di pagamento';

  @override
  String get purchaseSection2Content =>
      'I rimborsi sono disponibili entro 14 giorni dall\'acquisto se non hai utilizzato gli articoli acquistati.';

  @override
  String get purchaseSection2Title => 'Politica di Rimborso';

  @override
  String get purchaseSection3Content =>
      'Puoi annullare il tuo abbonamento in qualsiasi momento tramite le impostazioni del tuo account.';

  @override
  String get purchaseSection3Title => 'Cancellazione';

  @override
  String get purchaseSection4Content =>
      'Effettuando un acquisto, accetti i nostri termini di utilizzo e il contratto di servizio.';

  @override
  String get purchaseSection4Title => 'Termini di Utilizzo';

  @override
  String get purchaseSection5Content =>
      'Per problemi relativi all\'acquisto, ti preghiamo di contattare il nostro team di supporto.';

  @override
  String get purchaseSection5Title => 'Contatta il Supporto';

  @override
  String get purchaseSection6Content =>
      'Tutti gli acquisti sono soggetti ai nostri termini e condizioni standard.';

  @override
  String get purchaseSection6Title => '6. Richieste';

  @override
  String get pushNotifications => 'Notifiche push';

  @override
  String get reading => 'Lettura';

  @override
  String get realtimeQualityLog => 'Registro Qualità in Tempo Reale';

  @override
  String get recentConversation => 'Conversazione Recente:';

  @override
  String get recentLoginRequired => 'Accedi di nuovo per motivi di sicurezza';

  @override
  String get referrerEmail => 'Email del Referente';

  @override
  String get referrerEmailHelper => 'Facoltativo: Email di chi ti ha riferito';

  @override
  String get referrerEmailLabel => 'Email del referente (Opzionale)';

  @override
  String get refresh => 'Aggiorna';

  @override
  String refreshComplete(int count) {
    return 'Aggiornamento completato! $count persone corrispondenti';
  }

  @override
  String get refreshFailed => 'Aggiornamento fallito';

  @override
  String get refreshingChatList => 'Aggiornamento della lista chat...';

  @override
  String get relatedFAQ => 'FAQ correlate';

  @override
  String get report => 'Segnala';

  @override
  String get reportAI => 'Segnala';

  @override
  String get reportAIDescription =>
      'Se l\'AI ti ha messo a disagio, ti preghiamo di descrivere il problema.';

  @override
  String get reportAITitle => 'Segnala Conversazione AI';

  @override
  String get reportAndBlock => 'Segnala & Blocca';

  @override
  String get reportAndBlockDescription =>
      'Puoi segnalare e bloccare comportamenti inappropriati di questa AI';

  @override
  String get reportChatError => 'Segnala Errore Chat';

  @override
  String reportError(String error) {
    return 'Si è verificato un errore durante la segnalazione: $error';
  }

  @override
  String get reportFailed => 'Segnalazione fallita';

  @override
  String get reportSubmitted =>
      'Segnalazione inviata. La esamineremo e prenderemo provvedimenti.';

  @override
  String get reportSubmittedSuccess => 'Il tuo report è stato inviato. Grazie!';

  @override
  String get requestLimit => 'Limite di Richiesta';

  @override
  String get required => '[Obbligatorio]';

  @override
  String get requiredTermsAgreement => 'Per favore, accetta i termini';

  @override
  String get restartConversation => 'Riavvia Conversazione';

  @override
  String restartConversationQuestion(String name) {
    return 'Vuoi riavviare la conversazione con $name?';
  }

  @override
  String restartConversationWithName(String name) {
    return 'Riavviando la conversazione con $name!';
  }

  @override
  String get retry => 'Riprova';

  @override
  String get retryButton => 'Riprova';

  @override
  String get sad => 'Triste';

  @override
  String get saturday => 'Sabato';

  @override
  String get save => 'Salva';

  @override
  String get search => 'Cerca';

  @override
  String get searchFAQ => 'Cerca FAQ...';

  @override
  String get searchResults => 'Risultati della ricerca';

  @override
  String get selectEmotion => 'Seleziona Emozione';

  @override
  String get selectErrorType => 'Seleziona tipo di errore';

  @override
  String get selectFeeling => 'Seleziona Sensazione';

  @override
  String get selectGender => 'Seleziona genere';

  @override
  String get selectInterests =>
      'Per favore seleziona i tuoi interessi (almeno 1)';

  @override
  String get selectLanguage => 'Seleziona Lingua';

  @override
  String get selectPersona => 'Seleziona una persona';

  @override
  String get selectPersonaPlease => 'Per favore seleziona una persona.';

  @override
  String get selectPreferredMbti =>
      'Se preferisci persone con tipi MBTI specifici, per favore seleziona';

  @override
  String get selectProblematicMessage =>
      'Seleziona il messaggio problematico (opzionale)';

  @override
  String get selectReportReason => 'Seleziona il motivo della segnalazione';

  @override
  String get selectTheme => 'Seleziona Tema';

  @override
  String get selectTranslationError =>
      'Si prega di selezionare un messaggio con errore di traduzione';

  @override
  String get selectUsagePurpose =>
      'Si prega di selezionare il proprio scopo per utilizzare SONA';

  @override
  String get selfIntroduction => 'Introduzione (Facoltativa)';

  @override
  String get selfIntroductionHint => 'Scrivi una breve introduzione su di te';

  @override
  String get send => 'Invia';

  @override
  String get sendChatError => 'Errore nell\'invio della chat';

  @override
  String get sendFirstMessage => 'Invia il tuo primo messaggio';

  @override
  String get sendReport => 'Invia rapporto';

  @override
  String get sendingEmail => 'Invio email...';

  @override
  String get seoul => 'Seoul';

  @override
  String get serverErrorDashboard => 'Errore del server';

  @override
  String get serviceTermsAgreement =>
      'Si prega di accettare i termini di servizio';

  @override
  String get sessionExpired => 'Sessione scaduta';

  @override
  String get setAppInterfaceLanguage =>
      'Imposta la lingua dell\'interfaccia dell\'app';

  @override
  String get setNow => 'Imposta ora';

  @override
  String get settings => 'Impostazioni';

  @override
  String get sexualContent => 'Contenuto sessuale';

  @override
  String get showAllGenderPersonas => 'Mostra tutte le personas';

  @override
  String get showAllGendersOption => 'Mostra tutte le opzioni di genere';

  @override
  String get showOppositeGenderOnly =>
      'Se non selezionato, verranno mostrati solo i personaggi di genere opposto';

  @override
  String get showOriginalText => 'Mostra originale';

  @override
  String get signUp => 'Registrati';

  @override
  String get signUpFromGuest =>
      'Iscriviti ora per accedere a tutte le funzionalità!';

  @override
  String get signup => 'Registrati';

  @override
  String get signupComplete => 'Iscrizione completata';

  @override
  String get signupTab => 'Iscriviti';

  @override
  String get simpleInfoRequired => 'Sono richieste informazioni semplici';

  @override
  String get skip => 'Salta';

  @override
  String get sonaFriend => 'Amico SONA';

  @override
  String get sonaPrivacyPolicy => 'Politica sulla privacy SONA';

  @override
  String get sonaPurchasePolicy => 'Politica di Acquisto SONA';

  @override
  String get sonaTermsOfService => 'Termini di Servizio SONA';

  @override
  String get sonaUsagePurpose => 'Seleziona il tuo scopo per utilizzare SONA';

  @override
  String get sorryNotHelpful => 'Ci dispiace, non è stato utile';

  @override
  String get sort => 'Ordina';

  @override
  String get soundSettings => 'Impostazioni Audio';

  @override
  String get spamAdvertising => 'Spam/Advertising';

  @override
  String get spanish => 'Spagnolo';

  @override
  String get specialRelationshipDesc =>
      'Comprendersi e costruire legami profondi';

  @override
  String get sports => 'Sport';

  @override
  String get spring => 'Primavera';

  @override
  String get startChat => 'Inizia Chat';

  @override
  String get startChatButton => 'Inizia Chat';

  @override
  String get startConversation => 'Inizia una conversazione';

  @override
  String get startConversationLikeAFriend =>
      'Inizia una conversazione con Sona come un amico';

  @override
  String get startConversationStep =>
      '2. Inizia Conversazione: Chattare liberamente con le persone abbinate.';

  @override
  String get startConversationWithSona =>
      'Inizia a chattare con Sona come un amico!';

  @override
  String get startWithEmail => 'Inizia con Email';

  @override
  String get startWithGoogle => 'Inizia con Google';

  @override
  String get startingApp => 'Avvio dell\'app';

  @override
  String get storageManagement => 'Gestione dello spazio di archiviazione';

  @override
  String get store => 'Negozio';

  @override
  String get storeConnectionError => 'Impossibile connettersi al negozio';

  @override
  String get storeLoginRequiredMessage =>
      'È necessario effettuare il login per utilizzare il negozio. Vuoi andare alla schermata di login?';

  @override
  String get storeNotAvailable => 'Il negozio non è disponibile';

  @override
  String get storyEvent => 'Evento Storia';

  @override
  String get stressed => 'Stressato';

  @override
  String get submitReport => 'Invia Rapporto';

  @override
  String get subscriptionStatus => 'Stato dell\'abbonamento';

  @override
  String get subtleVibrationOnTouch => 'Vibrazione sottile al tocco';

  @override
  String get summer => 'Estate';

  @override
  String get sunday => 'Domenica';

  @override
  String get swipeAnyDirection => 'Scorri in qualsiasi direzione';

  @override
  String get swipeDownToClose => 'Scorri verso il basso per chiudere';

  @override
  String get systemTheme => 'Segui il sistema';

  @override
  String get systemThemeDesc =>
      'Cambia automaticamente in base alle impostazioni della modalità scura del dispositivo';

  @override
  String get tapBottomForDetails => 'Tocca in basso per i dettagli';

  @override
  String get tapForDetails => 'Tocca l\'area in basso per i dettagli';

  @override
  String get tapToSwipePhotos => 'Tocca per scorrere le foto';

  @override
  String get teachersDay => 'Giornata degli insegnanti';

  @override
  String get technicalError => 'Errore tecnico';

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
  String get termsOfService => 'Termini di servizio';

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
      'Se una qualsiasi disposizione di questi termini viene ritenuta inapplicabile, le disposizioni rimanenti continueranno ad avere piena validità ed effetto.';

  @override
  String get termsSection12Title =>
      'Articolo 12 (Raccolta e Utilizzo dei Dati)';

  @override
  String get termsSection1Content =>
      'Questi termini e condizioni mirano a definire i diritti, gli obblighi e le responsabilità tra SONA (di seguito \"Azienda\") e gli utenti riguardo all\'uso del servizio di corrispondenza delle conversazioni con persona AI (di seguito \"Servizio\") fornito dall\'Azienda.';

  @override
  String get termsSection1Title => 'Articolo 1 (Scopo)';

  @override
  String get termsSection2Content =>
      'Utilizzando il nostro servizio, accetti di essere vincolato da questi Termini di Servizio e dalla nostra Informativa sulla Privacy.';

  @override
  String get termsSection2Title => 'Articolo 2 (Definizioni)';

  @override
  String get termsSection3Content =>
      'Devi avere almeno 13 anni per utilizzare il nostro servizio.';

  @override
  String get termsSection3Title =>
      'Articolo 3 (Efficacia e Modifica dei Termini)';

  @override
  String get termsSection4Content =>
      'Sei responsabile della riservatezza del tuo account e della tua password.';

  @override
  String get termsSection4Title => 'Articolo 4 (Fornitura del Servizio)';

  @override
  String get termsSection5Content =>
      'Accetti di non utilizzare il nostro servizio per scopi illegali o non autorizzati.';

  @override
  String get termsSection5Title => 'Articolo 5 (Registrazione al Servizio)';

  @override
  String get termsSection6Content =>
      'Ci riserviamo il diritto di terminare o sospendere il tuo account per violazione di questi termini.';

  @override
  String get termsSection6Title => 'Articolo 6 (Obblighi dell\'Utente)';

  @override
  String get termsSection7Content =>
      'La Società può gradualmente limitare l\'uso del servizio attraverso avvisi, sospensione temporanea o sospensione permanente se gli utenti violano gli obblighi di questi termini o interferiscono con il normale funzionamento del servizio.';

  @override
  String get termsSection7Title =>
      'Articolo 7 (Restrizioni all\'Uso del Servizio)';

  @override
  String get termsSection8Content =>
      'Non siamo responsabili per eventuali danni indiretti, incidentali o consequenziali derivanti dall\'uso del nostro servizio.';

  @override
  String get termsSection8Title => 'Articolo 8 (Interruzione del Servizio)';

  @override
  String get termsSection9Content =>
      'Tutti i contenuti e i materiali disponibili sul nostro servizio sono protetti da diritti di proprietà intellettuale.';

  @override
  String get termsSection9Title => 'Articolo 9 (Esclusione di Responsabilità)';

  @override
  String get termsSupplementary => 'Termini Supplementari';

  @override
  String get thai => 'Thai';

  @override
  String get thanksFeedback => 'Grazie per il tuo feedback!';

  @override
  String get theme => 'Tema';

  @override
  String get themeDescription =>
      'Puoi personalizzare l\'aspetto dell\'app come preferisci.';

  @override
  String get themeSettings => 'Impostazioni del Tema';

  @override
  String get thursday => 'Giovedì';

  @override
  String get timeout => 'Timeout';

  @override
  String get tired => 'Stanco';

  @override
  String get today => 'Oggi';

  @override
  String get todayChats => 'Oggi';

  @override
  String get todayText => 'Oggi';

  @override
  String get tomorrowText => 'Domani';

  @override
  String get totalConsultSessions => 'Totale Sessioni di Consultazione';

  @override
  String get totalErrorCount => 'Conteggio totale degli errori';

  @override
  String get totalLikes => 'Mi piace totali';

  @override
  String totalOccurrences(Object count) {
    return 'Totale $count occorrenze';
  }

  @override
  String get totalResponses => 'Risposte totali';

  @override
  String get translatedFrom => 'Tradotto';

  @override
  String get translatedText => 'Traduzione';

  @override
  String get translationError => 'Errore di traduzione';

  @override
  String get translationErrorDescription =>
      'Si prega di segnalare traduzioni errate o espressioni scomode';

  @override
  String get translationErrorReported =>
      'Errore di traduzione segnalato. Grazie!';

  @override
  String get translationNote =>
      '※ La traduzione AI potrebbe non essere perfetta';

  @override
  String get translationQuality => 'Qualità della Traduzione';

  @override
  String get translationSettings => 'Impostazioni di Traduzione';

  @override
  String get travel => 'Viaggio';

  @override
  String get tuesday => 'Martedì';

  @override
  String get tutorialAccount => 'Account Tutorial';

  @override
  String get tutorialWelcomeDescription =>
      'Crea relazioni speciali con i personaggi IA.';

  @override
  String get tutorialWelcomeTitle => 'Benvenuto su SONA!';

  @override
  String get typeMessage => 'Digita un messaggio...';

  @override
  String get unblock => 'Sblocca';

  @override
  String get unblockFailed => 'Impossibile sbloccare';

  @override
  String unblockPersonaConfirm(String name) {
    return 'Sbloccare $name?';
  }

  @override
  String get unblockedSuccessfully => 'Sbloccato con successo';

  @override
  String get unexpectedLoginError =>
      'Si è verificato un errore imprevisto durante il login';

  @override
  String get unknown => 'Sconosciuto';

  @override
  String get unknownError => 'Si è verificato un errore sconosciuto';

  @override
  String get unlimitedMessages => 'Illimitato';

  @override
  String get unsendMessage => 'Annulla messaggio';

  @override
  String get usagePurpose => 'Scopo d\'uso';

  @override
  String get useOneHeart => 'Usa 1 Cuore';

  @override
  String get useSystemLanguage => 'Usa Lingua di Sistema';

  @override
  String get user => 'Utente:';

  @override
  String get userMessage => 'Messaggio dell\'utente:';

  @override
  String get userNotFound => 'Utente non trovato';

  @override
  String get valentinesDay => 'San Valentino';

  @override
  String get verifyingAuth => 'Verifica autenticazione';

  @override
  String get version => 'Versione';

  @override
  String get vietnamese => 'Vietnamita';

  @override
  String get violentContent => 'Contenuto violento';

  @override
  String get voiceMessage => '🎤 Messaggio vocale';

  @override
  String waitingForChat(String name) {
    return '$name sta aspettando di chattare.';
  }

  @override
  String get walk => 'Cammina';

  @override
  String get wasHelpful => 'È stato utile?';

  @override
  String get weatherClear => 'Sereno';

  @override
  String get weatherCloudy => 'Nuvoloso';

  @override
  String get weatherContext => 'Contesto Meteo';

  @override
  String get weatherContextDesc =>
      'Fornisci contesto alla conversazione basato sul meteo';

  @override
  String get weatherDrizzle => 'Pioviggine';

  @override
  String get weatherFog => 'Nebbia';

  @override
  String get weatherMist => 'Foschia';

  @override
  String get weatherRain => 'Pioggia';

  @override
  String get weatherRainy => 'Piovoso';

  @override
  String get weatherSnow => 'Neve';

  @override
  String get weatherSnowy => 'Nevoso';

  @override
  String get weatherThunderstorm => 'Temporale';

  @override
  String get wednesday => 'Mercoledì';

  @override
  String get weekdays => 'Dom,Lun,Mar,Mer,Gio,Ven,Sab';

  @override
  String get welcomeMessage => 'Benvenuto💕';

  @override
  String get whatTopicsToTalk =>
      'Di quali argomenti ti piacerebbe parlare? (Facoltativo)';

  @override
  String get whiteDay => 'White Day';

  @override
  String get winter => 'Inverno';

  @override
  String get wrongTranslation => 'Traduzione Errata';

  @override
  String get year => 'Anno';

  @override
  String get yearEnd => 'Fine anno';

  @override
  String get yes => 'Sì';

  @override
  String get yesterday => 'Ieri';

  @override
  String get yesterdayChats => 'Ieri';

  @override
  String get you => 'Tu';
}
