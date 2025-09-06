// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get about => 'À propos';

  @override
  String get accountAndProfile => 'Informations sur le compte et le profil';

  @override
  String get accountDeletedSuccess => 'Compte supprimé avec succès';

  @override
  String get accountDeletionContent =>
      'Êtes-vous sûr de vouloir supprimer votre compte ? Cette action ne peut pas être annulée.';

  @override
  String get accountDeletionError =>
      'Une erreur est survenue lors de la suppression du compte.';

  @override
  String get accountDeletionInfo => 'Informations sur la suppression du compte';

  @override
  String get accountDeletionTitle => 'Supprimer le compte';

  @override
  String get accountDeletionWarning1 =>
      'Avertissement: Cette action ne peut pas être annulée';

  @override
  String get accountDeletionWarning2 =>
      'Toutes vos données seront supprimées définitivement';

  @override
  String get accountDeletionWarning3 =>
      'Vous perdrez l\'accès à toutes les conversations';

  @override
  String get accountDeletionWarning4 => 'Cela inclut tout le contenu acheté';

  @override
  String get accountManagement => 'Gestion du compte';

  @override
  String get adaptiveConversationDesc =>
      'Adapte le style de conversation pour correspondre au vôtre';

  @override
  String get afternoon => 'Après-midi';

  @override
  String get afternoonFatigue => 'Fatigue de l\'après-midi';

  @override
  String get ageConfirmation =>
      'J\'ai 14 ans ou plus et j\'ai confirmé ce qui précède.';

  @override
  String ageRange(int min, int max) {
    return '$min-$max ans';
  }

  @override
  String get ageUnit => 'ans';

  @override
  String get agreeToTerms => 'J\'accepte les conditions';

  @override
  String get aiDatingQuestion => 'Une vie quotidienne spéciale avec l\'IA';

  @override
  String get aiPersonaPreferenceDescription =>
      'Veuillez définir vos préférences pour le matching de persona IA';

  @override
  String get all => 'Tout';

  @override
  String get allAgree => 'Accepter tout';

  @override
  String get allFeaturesRequired =>
      '※ Toutes les fonctionnalités sont requises pour la fourniture du service';

  @override
  String get allPersonas => 'Tous les Personas';

  @override
  String get allPersonasMatched =>
      'Tous les personas sont appariés ! Commencez à discuter avec eux.';

  @override
  String get allowPermission => 'Continuer';

  @override
  String alreadyChattingWith(String name) {
    return 'Déjà en conversation avec $name !';
  }

  @override
  String get alsoBlockThisAI => 'Bloquer également cette IA';

  @override
  String get angry => 'En colère';

  @override
  String get anonymousLogin => 'Connexion anonyme';

  @override
  String get anxious => 'Anxieux';

  @override
  String get apiKeyError => 'Erreur de clé API';

  @override
  String get appName => 'SONA';

  @override
  String get appTagline => 'Vos compagnons IA';

  @override
  String get appleLoginCanceled =>
      'La connexion Apple a été annulée. Veuillez réessayer.';

  @override
  String get appleLoginError =>
      'Une erreur est survenue lors de la connexion Apple.';

  @override
  String get art => 'Art';

  @override
  String get authError => 'Erreur d\'authentification';

  @override
  String get autoTranslate => 'Traduction automatique';

  @override
  String get autumn => 'Automne';

  @override
  String get averageQuality => 'Qualité moyenne';

  @override
  String get averageQualityScore => 'Score de qualité moyenne';

  @override
  String get awkwardExpression => 'Expression maladroite';

  @override
  String get backButton => 'Retour';

  @override
  String get basicInfo => 'Informations de Base';

  @override
  String get basicInfoDescription =>
      'Veuillez entrer des informations de base pour créer un compte';

  @override
  String get birthDate => 'Date de naissance';

  @override
  String get birthDateOptional => 'Date de naissance (facultatif)';

  @override
  String get birthDateRequired => 'Date de naissance *';

  @override
  String get blockConfirm =>
      'Voulez-vous bloquer cette IA ? Les IA bloquées seront exclues des correspondances et de la liste de chat.';

  @override
  String get blockReason => 'Raison du blocage';

  @override
  String get blockThisAI => 'Bloquer cette IA';

  @override
  String blockedAICount(int count) {
    return '$count IA bloquées';
  }

  @override
  String get blockedAIs => 'IA bloquées';

  @override
  String get blockedAt => 'Bloqué à';

  @override
  String get blockedSuccessfully => 'Bloqué avec succès';

  @override
  String get breakfast => 'Petit-déjeuner';

  @override
  String get byErrorType => 'Par type d\'erreur';

  @override
  String get byPersona => 'Par persona';

  @override
  String cacheDeleteError(String error) {
    return 'Erreur lors de la suppression du cache : $error';
  }

  @override
  String get cacheDeleted => 'Le cache d\'images a été supprimé';

  @override
  String get cafeTerrace => 'Terrasse de café';

  @override
  String get calm => 'Calme';

  @override
  String get cameraPermission => 'Permission caméra';

  @override
  String get cameraPermissionDesc =>
      'L\'accès à la caméra est nécessaire pour prendre des photos de profil.';

  @override
  String get canChangeInSettings =>
      'Vous pouvez changer cela plus tard dans les paramètres';

  @override
  String get canMeetPreviousPersonas =>
      'Vous pouvez rencontrer à nouveau les personas que vous avez balayés !';

  @override
  String get cancel => 'Annuler';

  @override
  String get changeProfilePhoto => 'Changer la photo de profil';

  @override
  String get chat => 'Discussion';

  @override
  String get chatEndedMessage => 'La discussion est terminée';

  @override
  String get chatErrorDashboard => 'Tableau de bord des erreurs de chat';

  @override
  String get chatErrorSentSuccessfully =>
      'L\'erreur de chat a été envoyée avec succès.';

  @override
  String get chatListTab => 'Onglet de la liste de chat';

  @override
  String get chats => 'Chats';

  @override
  String chattingWithPersonas(int count) {
    return 'Discussion avec $count personas';
  }

  @override
  String get checkInternetConnection =>
      'Veuillez vérifier votre connexion internet';

  @override
  String get checkingUserInfo => 'Vérification des informations utilisateur';

  @override
  String get childrensDay => 'Journée des enfants';

  @override
  String get chinese => 'Chinois';

  @override
  String get chooseOption => 'Veuillez choisir :';

  @override
  String get christmas => 'Noël';

  @override
  String get close => 'Fermer';

  @override
  String get complete => 'Terminé';

  @override
  String get completeSignup => 'Finaliser l\'inscription';

  @override
  String get confirm => 'Confirmer';

  @override
  String get connectingToServer => 'Connexion au serveur';

  @override
  String get consultQualityMonitoring => 'Consultation de la qualité de suivi';

  @override
  String get continueAsGuest => 'Continuer en tant qu\'invité';

  @override
  String get continueButton => 'Continuer';

  @override
  String get continueWithApple => 'Continuer avec Apple';

  @override
  String get continueWithGoogle => 'Continuer avec Google';

  @override
  String get conversationContinuity => 'Continuité de la conversation';

  @override
  String get conversationContinuityDesc =>
      'Se souvenir des conversations précédentes et relier les sujets';

  @override
  String conversationWith(String name) {
    return '$name';
  }

  @override
  String get convertToMember => 'S\'inscrire';

  @override
  String get cooking => 'Cuisine';

  @override
  String get copyMessage => 'Copier le message';

  @override
  String get copyrightInfringement => 'Violation du droit d\'auteur';

  @override
  String get creatingAccount => 'Création du compte';

  @override
  String get crisisDetected => 'Crise détectée';

  @override
  String get culturalIssue => 'Problème culturel';

  @override
  String get current => 'Actuel';

  @override
  String get currentCacheSize => 'Taille du cache actuel';

  @override
  String get currentLanguage => 'Langue actuelle';

  @override
  String get cycling => 'Cyclisme';

  @override
  String get dailyCare => 'Soins quotidiens';

  @override
  String get dailyCareDesc =>
      'Messages de soins quotidiens pour les repas, le sommeil, la santé';

  @override
  String get dailyChat => 'Discussion quotidienne';

  @override
  String get dailyCheck => 'Vérification quotidienne';

  @override
  String get dailyConversation => 'Conversation quotidienne';

  @override
  String get dailyLimitDescription =>
      'Vous avez atteint votre limite quotidienne de messages';

  @override
  String get dailyLimitTitle => 'Limite quotidienne atteinte';

  @override
  String get darkMode => 'Mode sombre';

  @override
  String get darkTheme => 'Mode sombre';

  @override
  String get darkThemeDesc => 'Utiliser le mode sombre';

  @override
  String get dataCollection => 'Paramètres de collecte de données';

  @override
  String get datingAdvice => 'Conseils de rencontre';

  @override
  String get datingDescription =>
      'Je veux partager des pensées profondes et avoir des conversations sincères';

  @override
  String get dawn => 'Aube';

  @override
  String get day => 'Jour';

  @override
  String get dayAfterTomorrow => 'Après-demain';

  @override
  String daysAgo(int count, String formatted) {
    return 'il y a $count jours';
  }

  @override
  String daysRemaining(int days) {
    return '$days jours restants';
  }

  @override
  String get deepTalk => 'Conversation profonde';

  @override
  String get delete => 'Supprimer';

  @override
  String get deleteAccount => 'Supprimer le compte';

  @override
  String get deleteAccountConfirm =>
      'Êtes-vous sûr de vouloir supprimer votre compte ? Cette action ne peut pas être annulée.';

  @override
  String get deleteAccountWarning =>
      'Êtes-vous sûr de vouloir supprimer votre compte?';

  @override
  String get deleteCache => 'Supprimer le cache';

  @override
  String get deletingAccount => 'Suppression du compte...';

  @override
  String get depressed => 'Déprimé';

  @override
  String get describeError => 'Quel est le problème ?';

  @override
  String get detailedReason => 'Raison détaillée';

  @override
  String get developRelationshipStep =>
      '3. Développer la relation : Créez de l\'intimité à travers des conversations et développez des relations spéciales.';

  @override
  String get dinner => 'Dîner';

  @override
  String get discardGuestData => 'Repartir à zéro';

  @override
  String get discount20 => '20 % de réduction';

  @override
  String get discount30 => '30 % de réduction';

  @override
  String get discountAmount => 'Économiser';

  @override
  String discountAmountValue(String amount) {
    return 'Économisez ₩$amount';
  }

  @override
  String get done => 'Terminé';

  @override
  String get downloadingPersonaImages =>
      'Téléchargement des nouvelles images de persona';

  @override
  String get edit => 'Modifier';

  @override
  String get editInfo => 'Modifier les informations';

  @override
  String get editProfile => 'Modifier le profil';

  @override
  String get effectSound => 'Effets sonores';

  @override
  String get effectSoundDescription => 'Jouer des effets sonores';

  @override
  String get email => 'Email';

  @override
  String get emailHint => 'exemple@email.com';

  @override
  String get emailLabel => 'Email';

  @override
  String get emailRequired => 'Email *';

  @override
  String get emotionAnalysis => 'Analyse des émotions';

  @override
  String get emotionAnalysisDesc =>
      'Analysez les émotions pour des réponses empathiques';

  @override
  String get emotionAngry => 'En colère';

  @override
  String get emotionBasedEncounters => 'Rencontres basées sur les émotions';

  @override
  String get emotionCool => 'Cool';

  @override
  String get emotionHappy => 'Heureux';

  @override
  String get emotionLove => 'Amour';

  @override
  String get emotionSad => 'Triste';

  @override
  String get emotionThinking => 'En train de réfléchir';

  @override
  String get emotionalSupportDesc =>
      'Partagez vos préoccupations et recevez un réconfort chaleureux';

  @override
  String get endChat => 'Terminer la discussion';

  @override
  String get endTutorial => 'Terminer le tutoriel';

  @override
  String get endTutorialAndLogin => 'Terminer le tutoriel et se connecter ?';

  @override
  String get endTutorialMessage =>
      'Voulez-vous terminer le tutoriel et vous connecter ?';

  @override
  String get english => 'Anglais';

  @override
  String get enterBasicInfo =>
      'Veuillez entrer des informations de base pour créer un compte';

  @override
  String get enterBasicInformation =>
      'Veuillez entrer des informations de base';

  @override
  String get enterEmail => 'Veuillez entrer un email';

  @override
  String get enterNickname => 'Veuillez entrer un pseudo';

  @override
  String get enterPassword => 'Veuillez entrer un mot de passe';

  @override
  String get entertainmentAndFunDesc =>
      'Profitez de jeux amusants et de conversations agréables';

  @override
  String get entertainmentDescription =>
      'Je veux avoir des conversations amusantes et profiter de mon temps';

  @override
  String get entertainmentFun => 'Divertissement/Amusement';

  @override
  String get error => 'Erreur';

  @override
  String get errorDescription => 'Description de l\'erreur';

  @override
  String get errorDescriptionHint =>
      'par exemple, A donné des réponses étranges, Répète la même chose, Donne des réponses contextuellement inappropriées...';

  @override
  String get errorDetails => 'Détails de l\'erreur';

  @override
  String get errorDetailsHint =>
      'Veuillez expliquer en détail ce qui ne va pas';

  @override
  String get errorFrequency24h => 'Fréquence des erreurs (dernières 24 heures)';

  @override
  String get errorMessage => 'Message d\'erreur :';

  @override
  String get errorOccurred => 'Une erreur est survenue.';

  @override
  String get errorOccurredTryAgain =>
      'Une erreur est survenue. Veuillez réessayer.';

  @override
  String get errorSendingFailed => 'Échec de l\'envoi de l\'erreur';

  @override
  String get errorStats => 'Statistiques des erreurs';

  @override
  String errorWithMessage(String error) {
    return 'Erreur survenue : $error';
  }

  @override
  String get evening => 'Soirée';

  @override
  String get excited => 'Excité';

  @override
  String get exit => 'Quitter';

  @override
  String get exitApp => 'Quitter l\'application';

  @override
  String get exitConfirmMessage =>
      'Êtes-vous sûr de vouloir quitter l\'application ?';

  @override
  String get expertPersona => 'Persona expert';

  @override
  String get expertiseScore => 'Score d\'expertise';

  @override
  String get expired => 'Expiré';

  @override
  String get explainReportReason =>
      'Veuillez expliquer la raison du rapport en détail';

  @override
  String get fashion => 'Mode';

  @override
  String get female => 'Femme';

  @override
  String get filter => 'Filtrer';

  @override
  String get firstOccurred => 'Première apparition :';

  @override
  String get followDeviceLanguage =>
      'Suivre les paramètres de langue de l\'appareil';

  @override
  String get forenoon => 'Avant-midi';

  @override
  String get forgotPassword => 'Mot de passe oublié ?';

  @override
  String get frequentlyAskedQuestions => 'Questions fréquemment posées';

  @override
  String get friday => 'Vendredi';

  @override
  String get friendshipDescription =>
      'Je veux rencontrer de nouveaux amis et avoir des conversations';

  @override
  String get funChat => 'Discussion amusante';

  @override
  String get galleryPermission => 'Permission galerie';

  @override
  String get galleryPermissionDesc =>
      'L\'accès à la galerie est nécessaire pour sélectionner des photos de profil.';

  @override
  String get gaming => 'Jeux';

  @override
  String get gender => 'Genre';

  @override
  String get genderNotSelectedInfo =>
      'Si le genre n\'est pas sélectionné, des personas de tous les genres seront affichés';

  @override
  String get genderOptional => 'Genre (Optionnel)';

  @override
  String get genderPreferenceActive =>
      'Vous pouvez rencontrer des personas de tous les genres';

  @override
  String get genderPreferenceDisabled =>
      'Sélectionnez votre genre pour activer l\'option uniquement pour le genre opposé';

  @override
  String get genderPreferenceInactive =>
      'Seules les personas du genre opposé seront affichées';

  @override
  String get genderRequired => 'Genre *';

  @override
  String get genderSelectionInfo =>
      'Si non sélectionné, vous pouvez rencontrer des personas de tous les genres';

  @override
  String get generalPersona => 'Persona générale';

  @override
  String get goToSettings => 'Aller aux paramètres';

  @override
  String get permissionGuideAndroid =>
      'Settings > Apps > SONA > Permissions\nPlease allow photo permission';

  @override
  String get permissionGuideIOS =>
      'Settings > SONA > Photos\nPlease allow photo access';

  @override
  String get googleLoginCanceled =>
      'La connexion Google a été annulée. Veuillez réessayer.';

  @override
  String get googleLoginError =>
      'Une erreur est survenue lors de la connexion Google.';

  @override
  String get grantPermission => 'Continuer';

  @override
  String get guest => 'Invité';

  @override
  String get guestDataMigration =>
      'Souhaitez-vous conserver votre historique de chat actuel lors de l\'inscription ?';

  @override
  String get guestLimitReached => 'Essai invité terminé.';

  @override
  String get guestLoginPromptMessage =>
      'Connectez-vous pour continuer la conversation';

  @override
  String get guestMessageExhausted => 'Messages gratuits épuisés';

  @override
  String guestMessageRemaining(int count) {
    return '$count messages invités restants';
  }

  @override
  String get guestModeBanner => 'Mode Invité';

  @override
  String get guestModeDescription => 'Essayez SONA sans vous inscrire';

  @override
  String get guestModeFailedMessage => 'Échec du démarrage du Mode Invité';

  @override
  String get guestModeLimitation =>
      'Certaines fonctionnalités sont limitées en Mode Invité';

  @override
  String get guestModeTitle => 'Essayer en tant qu\'Invité';

  @override
  String get guestModeWarning =>
      'Le mode invité dure 24 heures, après quoi les données seront supprimées.';

  @override
  String get guestModeWelcome => 'Démarrage en Mode Invité';

  @override
  String get happy => 'Heureux';

  @override
  String get hapticFeedback => 'Retour haptique';

  @override
  String get harassmentBullying => 'Harcèlement/Intimidation';

  @override
  String get hateSpeech => 'Discours de haine';

  @override
  String get heartDescription => 'Cœurs pour plus de messages';

  @override
  String get heartInsufficient => 'Pas assez de cœurs';

  @override
  String get heartInsufficientPleaseCharge =>
      'Pas assez de cœurs. Veuillez recharger les cœurs.';

  @override
  String get heartRequired => '1 cœur est requis';

  @override
  String get heartUsageFailed => 'Échec de l\'utilisation du cœur.';

  @override
  String get hearts => 'Cœurs';

  @override
  String get hearts10 => '10 Cœurs';

  @override
  String get hearts30 => '30 Cœurs';

  @override
  String get hearts30Discount => 'VENTE';

  @override
  String get hearts50 => '50 Cœurs';

  @override
  String get hearts50Discount => 'VENTE';

  @override
  String get helloEmoji => 'Bonjour ! 😊';

  @override
  String get help => 'Aide';

  @override
  String get hideOriginalText => 'Cacher l\'original';

  @override
  String get hobbySharing => 'Partage de loisirs';

  @override
  String get hobbyTalk => 'Discussion sur les loisirs';

  @override
  String get hours24Ago => 'Il y a 24 heures';

  @override
  String hoursAgo(int count, String formatted) {
    return 'il y a $count heures';
  }

  @override
  String get howToUse => 'Comment utiliser SONA';

  @override
  String get imageCacheManagement => 'Gestion du cache d\'images';

  @override
  String get inappropriateContent => 'Contenu inapproprié';

  @override
  String get incorrect => 'incorrect';

  @override
  String get incorrectPassword => 'Mot de passe incorrect';

  @override
  String get indonesian => 'Indonésien';

  @override
  String get inquiries => 'Demandes';

  @override
  String get insufficientHearts => 'Cœurs insuffisants.';

  @override
  String get interestSharing => 'Partage d\'intérêts';

  @override
  String get interestSharingDesc =>
      'Découvrez et recommandez des intérêts partagés';

  @override
  String get interests => 'Intérêts';

  @override
  String get invalidEmailFormat => 'Format d\'email invalide';

  @override
  String get invalidEmailFormatError =>
      'Veuillez entrer une adresse email valide';

  @override
  String isTyping(String name) {
    return '$name est en train d\'écrire...';
  }

  @override
  String get japanese => 'Japonais';

  @override
  String get joinDate => 'Date d\'inscription';

  @override
  String get justNow => 'À l\'instant';

  @override
  String get keepGuestData => 'Conserver l\'historique des discussions';

  @override
  String get korean => 'Coréen';

  @override
  String get koreanLanguage => 'Coréen';

  @override
  String get language => 'Langue';

  @override
  String get languageDescription =>
      'L\'IA répondra dans la langue que vous avez sélectionnée';

  @override
  String get languageIndicator => 'Langue';

  @override
  String get languageSettings => 'Paramètres de langue';

  @override
  String get lastOccurred => 'Dernière occurrence :';

  @override
  String get lastUpdated => 'Dernière mise à jour';

  @override
  String get lateNight => 'Tard dans la nuit';

  @override
  String get later => 'Plus tard';

  @override
  String get laterButton => 'Plus tard';

  @override
  String get leave => 'Quitter';

  @override
  String get leaveChatConfirm => 'Quitter cette discussion ?';

  @override
  String get leaveChatRoom => 'Quitter la salle de discussion';

  @override
  String get leaveChatTitle => 'Quitter la discussion';

  @override
  String get lifeAdvice => 'Conseils de vie';

  @override
  String get lightTalk => 'Discussion légère';

  @override
  String get lightTheme => 'Mode clair';

  @override
  String get lightThemeDesc => 'Utiliser un thème lumineux';

  @override
  String get loading => 'Chargement...';

  @override
  String get loadingData => 'Chargement des données...';

  @override
  String get loadingProducts => 'Chargement des produits...';

  @override
  String get loadingProfile => 'Chargement du profil';

  @override
  String get login => 'Se connecter';

  @override
  String get loginButton => 'Connexion';

  @override
  String get loginCancelled => 'Connexion annulée';

  @override
  String get loginComplete => 'Connexion réussie';

  @override
  String get loginError => 'Échec de la connexion';

  @override
  String get loginFailed => 'Échec de la connexion';

  @override
  String get loginFailedTryAgain =>
      'Échec de la connexion. Veuillez réessayer.';

  @override
  String get loginRequired => 'Connexion requise';

  @override
  String get loginRequiredForProfile => 'Connexion requise pour voir le profil';

  @override
  String get loginRequiredService =>
      'Connexion requise pour utiliser ce service';

  @override
  String get loginRequiredTitle => 'Connexion requise';

  @override
  String get loginSignup => 'Connexion/S\'inscrire';

  @override
  String get loginTab => 'Connexion';

  @override
  String get loginTitle => 'Connexion';

  @override
  String get loginWithApple => 'Se connecter avec Apple';

  @override
  String get loginWithGoogle => 'Se connecter avec Google';

  @override
  String get logout => 'Déconnexion';

  @override
  String get logoutConfirm => 'Êtes-vous sûr de vouloir vous déconnecter?';

  @override
  String get lonelinessRelief => 'Soulagement de la solitude';

  @override
  String get lonely => 'Seul';

  @override
  String get lowQualityResponses => 'Réponses de faible qualité';

  @override
  String get lunch => 'Déjeuner';

  @override
  String get lunchtime => 'Heure du déjeuner';

  @override
  String get mainErrorType => 'Type d\'erreur principal';

  @override
  String get makeFriends => 'Se faire des amis';

  @override
  String get male => 'Homme';

  @override
  String get manageBlockedAIs => 'Gérer les IA bloquées';

  @override
  String get managePersonaImageCache => 'Gérer le cache des images de persona';

  @override
  String get marketingAgree =>
      'Accepter les informations marketing (facultatif)';

  @override
  String get marketingDescription =>
      'Vous pouvez recevoir des informations sur les événements et les avantages';

  @override
  String get matchPersonaStep =>
      '1. Correspondre aux Personas : Glissez à gauche ou à droite pour sélectionner vos personas IA préférés.';

  @override
  String get matchedPersonas => 'Personas correspondants';

  @override
  String get matchedSona => 'Sona correspondant';

  @override
  String get matching => 'Correspondance';

  @override
  String get matchingFailed => 'Échec de la correspondance.';

  @override
  String get me => 'Me';

  @override
  String get meetAIPersonas => 'Rencontrez les Personas IA';

  @override
  String get meetNewPersonas => 'Rencontrer de nouvelles personas';

  @override
  String get meetPersonas => 'Rencontrez les Personas';

  @override
  String get memberBenefits =>
      'Recevez plus de 100 messages et 10 cœurs lors de votre inscription !';

  @override
  String get memoryAlbum => 'Album de souvenirs';

  @override
  String get memoryAlbumDesc =>
      'Enregistrez et rappelez automatiquement des moments spéciaux';

  @override
  String get messageCopied => 'Message copié';

  @override
  String get messageDeleted => 'Message supprimé';

  @override
  String get messageLimitReset =>
      'La limite de messages sera réinitialisée à minuit';

  @override
  String get messageSendFailed =>
      'Échec de l\'envoi du message. Veuillez réessayer.';

  @override
  String get messagesRemaining => 'Messages restants';

  @override
  String minutesAgo(int count, String formatted) {
    return 'il y a $count minutes';
  }

  @override
  String get missingTranslation => 'Traduction manquante';

  @override
  String get monday => 'Lundi';

  @override
  String get month => 'Mois';

  @override
  String monthDay(String month, int day) {
    return '$month $day';
  }

  @override
  String get moreButton => 'Plus';

  @override
  String get morning => 'Matin';

  @override
  String get mostFrequentError => 'Erreur la plus fréquente';

  @override
  String get movies => 'Films';

  @override
  String get multilingualChat => 'Chat multilingue';

  @override
  String get music => 'Musique';

  @override
  String get myGenderSection => 'Mon genre (optionnel)';

  @override
  String get networkErrorOccurred => 'Une erreur réseau est survenue.';

  @override
  String get newMessage => 'Nouveau message';

  @override
  String newMessageCount(int count) {
    return '$count nouveaux messages';
  }

  @override
  String get newMessageNotification => 'Notification de nouveau message';

  @override
  String get newMessages => 'Nouveaux messages';

  @override
  String get newYear => 'Nouvelle année';

  @override
  String get next => 'Suivant';

  @override
  String get niceToMeetYou => 'Ravi de vous rencontrer !';

  @override
  String get nickname => 'Surnom';

  @override
  String get nicknameAlreadyUsed => 'Ce pseudo est déjà utilisé';

  @override
  String get nicknameHelperText => '3-10 caractères';

  @override
  String get nicknameHint => '3-10 caractères';

  @override
  String get nicknameInUse => 'Ce pseudo est déjà utilisé';

  @override
  String get nicknameLabel => 'Pseudo';

  @override
  String get nicknameLengthError =>
      'Le pseudo doit contenir entre 3 et 10 caractères';

  @override
  String get nicknamePlaceholder => 'Entrez votre pseudo';

  @override
  String get nicknameRequired => 'Surnom *';

  @override
  String get night => 'Nuit';

  @override
  String get no => 'Non';

  @override
  String get noBlockedAIs => 'Aucune IA bloquée';

  @override
  String get noChatsYet => 'Pas encore de discussions';

  @override
  String get noConversationYet => 'Pas encore de conversation';

  @override
  String get noErrorReports => 'Aucun rapport d\'erreur.';

  @override
  String get noImageAvailable => 'Aucune image disponible';

  @override
  String get noMatchedPersonas => 'Pas encore de personas correspondantes';

  @override
  String get noMatchedSonas => 'Aucun SONA correspondant pour l\'instant';

  @override
  String get noPersonasAvailable =>
      'Aucune persona disponible. Veuillez réessayer.';

  @override
  String get noPersonasToSelect => 'Aucune persona disponible';

  @override
  String get noQualityIssues =>
      'Aucun problème de qualité dans la dernière heure ✅';

  @override
  String get noQualityLogs => 'Aucun journal de qualité pour le moment.';

  @override
  String get noTranslatedMessages => 'Aucun message à traduire';

  @override
  String get notEnoughHearts => 'Pas assez de cœurs';

  @override
  String notEnoughHeartsCount(int count) {
    return 'Pas assez de cœurs. (Actuel : $count)';
  }

  @override
  String get notRegistered => 'non enregistré';

  @override
  String get notSubscribed => 'Non abonné';

  @override
  String get notificationPermissionDesc =>
      'La permission de notification est nécessaire pour recevoir de nouveaux messages.';

  @override
  String get notificationPermissionRequired =>
      'Permission de notification requise';

  @override
  String get notificationSettings => 'Paramètres de notification';

  @override
  String get notifications => 'Notifications';

  @override
  String get occurrenceInfo => 'Informations sur l\'occurrence :';

  @override
  String get olderChats => 'Plus anciens';

  @override
  String get onlyOppositeGenderNote =>
      'Si décoché, seules les personas de l\'autre genre seront affichées';

  @override
  String get openSettings => 'Ouvrir les paramètres';

  @override
  String get optional => 'Optionnel';

  @override
  String get or => 'or';

  @override
  String get originalPrice => 'Prix original';

  @override
  String get originalText => 'Texte original';

  @override
  String get other => 'Autre';

  @override
  String get otherError => 'Autre erreur';

  @override
  String get others => 'Autres';

  @override
  String get ownedHearts => 'Cœurs possédés';

  @override
  String get parentsDay => 'Fête des parents';

  @override
  String get password => 'Mot de passe';

  @override
  String get passwordConfirmation => 'Entrez le mot de passe pour confirmer';

  @override
  String get passwordConfirmationDesc =>
      'Veuillez ressaisir votre mot de passe pour supprimer le compte.';

  @override
  String get passwordHint => '6 caractères ou plus';

  @override
  String get passwordLabel => 'Mot de passe';

  @override
  String get passwordRequired => 'Mot de passe *';

  @override
  String get passwordResetEmailPrompt =>
      'Veuillez entrer votre email pour réinitialiser le mot de passe';

  @override
  String get passwordResetEmailSent =>
      'Un email de réinitialisation du mot de passe a été envoyé. Veuillez vérifier votre email.';

  @override
  String get passwordText => 'mot de passe';

  @override
  String get passwordTooShort => 'Mot de passe trop court';

  @override
  String get permissionDenied => 'Permission refusée';

  @override
  String permissionDeniedMessage(String permissionName) {
    return 'La permission $permissionName a été refusée.\\nVeuillez autoriser la permission dans les paramètres.';
  }

  @override
  String get permissionDeniedTryLater =>
      'Permission refusée. Veuillez réessayer plus tard.';

  @override
  String get permissionRequired => 'Permission requise';

  @override
  String get personaGenderSection => 'Préférence de genre de persona';

  @override
  String get personaQualityStats => 'Statistiques de qualité de persona';

  @override
  String get personalInfoExposure => 'Exposition d\'informations personnelles';

  @override
  String get personality => 'Paramètres de Personnalité';

  @override
  String get pets => 'Animaux de compagnie';

  @override
  String get photo => 'Photo';

  @override
  String get photography => 'Photographie';

  @override
  String get picnic => 'Pique-nique';

  @override
  String get preferenceSettings => 'Paramètres de préférence';

  @override
  String get preferredLanguage => 'Langue préférée';

  @override
  String get preparingForSleep => 'Préparation au sommeil';

  @override
  String get preparingNewMeeting => 'Préparation d\'une nouvelle réunion';

  @override
  String get preparingPersonaImages => 'Préparation des images de persona';

  @override
  String get preparingPersonas => 'Préparation des personas';

  @override
  String get preview => 'Aperçu';

  @override
  String get previous => 'Précédent';

  @override
  String get privacy => 'Confidentialité';

  @override
  String get privacyPolicy => 'Politique de confidentialité';

  @override
  String get privacyPolicyAgreement =>
      'Veuillez accepter la politique de confidentialité';

  @override
  String get privacySection1Content =>
      'Nous nous engageons à protéger votre vie privée. Cette politique de confidentialité explique comment nous collectons, utilisons et protégeons vos informations lorsque vous utilisez notre service.';

  @override
  String get privacySection1Title =>
      '1. Objectif de la collecte et de l\'utilisation des informations personnelles';

  @override
  String get privacySection2Content =>
      'Nous collectons les informations que vous nous fournissez directement, par exemple lorsque vous créez un compte, mettez à jour votre profil ou utilisez nos services.';

  @override
  String get privacySection2Title => 'Informations que nous collectons';

  @override
  String get privacySection3Content =>
      'Nous utilisons les informations que nous collectons pour fournir, maintenir et améliorer nos services, et pour communiquer avec vous.';

  @override
  String get privacySection3Title =>
      '3. Durée de conservation et période d\'utilisation des informations personnelles';

  @override
  String get privacySection4Content =>
      'Nous ne vendons, n\'échangeons ni ne transférons autrement vos informations personnelles à des tiers sans votre consentement.';

  @override
  String get privacySection4Title =>
      '4. Fourniture d\'informations personnelles à des tiers';

  @override
  String get privacySection5Content =>
      'Nous mettons en œuvre des mesures de sécurité appropriées pour protéger vos informations personnelles contre tout accès, altération, divulgation ou destruction non autorisés.';

  @override
  String get privacySection5Title =>
      '5. Mesures de protection technique des informations personnelles';

  @override
  String get privacySection6Content =>
      'Nous conservons les informations personnelles aussi longtemps que nécessaire pour fournir nos services et respecter nos obligations légales.';

  @override
  String get privacySection6Title => '6. Droits des utilisateurs';

  @override
  String get privacySection7Content =>
      'Vous avez le droit d\'accéder, de mettre à jour ou de supprimer vos informations personnelles à tout moment via les paramètres de votre compte.';

  @override
  String get privacySection7Title => 'Vos droits';

  @override
  String get privacySection8Content =>
      'Si vous avez des questions concernant cette politique de confidentialité, veuillez nous contacter à support@sona.com.';

  @override
  String get privacySection8Title => 'Contactez-nous';

  @override
  String get privacySettings => 'Paramètres de confidentialité';

  @override
  String get privacySettingsInfo =>
      'Désactiver des fonctionnalités individuelles rendra ces services indisponibles';

  @override
  String get privacySettingsScreen => 'Paramètres de confidentialité';

  @override
  String get problemMessage => 'Problème';

  @override
  String get problemOccurred => 'Un problème est survenu';

  @override
  String get profile => 'Profil';

  @override
  String get profileEdit => 'Modifier le profil';

  @override
  String get profileEditLoginRequiredMessage =>
      'Une connexion est requise pour modifier votre profil.';

  @override
  String get profileInfo => 'Informations sur le profil';

  @override
  String get profileInfoDescription =>
      'Veuillez entrer votre photo de profil et vos informations de base';

  @override
  String get profileNav => 'Profil';

  @override
  String get profilePhoto => 'Photo de profil';

  @override
  String get profilePhotoAndInfo =>
      'Veuillez entrer la photo de profil et les informations de base';

  @override
  String get profilePhotoUpdateFailed =>
      'Échec de la mise à jour de la photo de profil';

  @override
  String get profilePhotoUpdated => 'Photo de profil mise à jour';

  @override
  String get profileSettings => 'Paramètres du profil';

  @override
  String get profileSetup => 'Configuration du profil';

  @override
  String get profileUpdateFailed => 'Échec de la mise à jour du profil';

  @override
  String get profileUpdated => 'Profil mis à jour avec succès';

  @override
  String get purchaseAndRefundPolicy =>
      'Politique d\'achat et de remboursement';

  @override
  String get purchaseButton => 'Acheter';

  @override
  String get purchaseConfirm => 'Confirmation d\'achat';

  @override
  String purchaseConfirmContent(String product, String price) {
    return 'Acheter $product pour $price?';
  }

  @override
  String purchaseConfirmMessage(
      String title, String price, String description) {
    return 'Confirmer l\'achat de $title pour $price? $description';
  }

  @override
  String get purchaseFailed => 'Échec de l\'achat';

  @override
  String get purchaseHeartsOnly => 'Acheter des cœurs';

  @override
  String get purchaseMoreHearts =>
      'Achetez des cœurs pour continuer les conversations';

  @override
  String get purchasePending => 'Achat en attente...';

  @override
  String get purchasePolicy => 'Politique d\'achat';

  @override
  String get purchaseSection1Content =>
      'Nous acceptons divers modes de paiement, y compris les cartes de crédit et les portefeuilles numériques.';

  @override
  String get purchaseSection1Title => 'Méthodes de paiement';

  @override
  String get purchaseSection2Content =>
      'Les remboursements sont disponibles dans les 14 jours suivant l\'achat si vous n\'avez pas utilisé les articles achetés.';

  @override
  String get purchaseSection2Title => 'Politique de remboursement';

  @override
  String get purchaseSection3Content =>
      'Vous pouvez annuler votre abonnement à tout moment via les paramètres de votre compte.';

  @override
  String get purchaseSection3Title => 'Annulation';

  @override
  String get purchaseSection4Content =>
      'En effectuant un achat, vous acceptez nos conditions d\'utilisation et notre accord de service.';

  @override
  String get purchaseSection4Title => 'Conditions d\'utilisation';

  @override
  String get purchaseSection5Content =>
      'Pour les problèmes liés aux achats, veuillez contacter notre équipe de support.';

  @override
  String get purchaseSection5Title => 'Contacter le support';

  @override
  String get purchaseSection6Content =>
      'Tous les achats sont soumis à nos conditions générales.';

  @override
  String get purchaseSection6Title => '6. Demandes';

  @override
  String get pushNotifications => 'Notifications push';

  @override
  String get reading => 'Lecture';

  @override
  String get realtimeQualityLog => 'Journal de qualité en temps réel';

  @override
  String get recentConversation => 'Conversation récente :';

  @override
  String get recentLoginRequired =>
      'Veuillez vous reconnecter pour des raisons de sécurité';

  @override
  String get referrerEmail => 'Email du parrain';

  @override
  String get referrerEmailHelper =>
      'Optionnel : Email de la personne qui vous a parrainé';

  @override
  String get referrerEmailLabel => 'Email du parrain (Optionnel)';

  @override
  String get refresh => 'Actualiser';

  @override
  String refreshComplete(int count) {
    return 'Actualisation terminée ! $count personas correspondants';
  }

  @override
  String get refreshFailed => 'Échec de l\'actualisation';

  @override
  String get refreshingChatList => 'Actualisation de la liste de discussion...';

  @override
  String get relatedFAQ => 'FAQ associée';

  @override
  String get report => 'Signaler';

  @override
  String get reportAI => 'Signaler';

  @override
  String get reportAIDescription =>
      'Si l\'IA vous a mis mal à l\'aise, veuillez décrire le problème.';

  @override
  String get reportAITitle => 'Signaler la conversation avec l\'IA';

  @override
  String get reportAndBlock => 'Signaler & Bloquer';

  @override
  String get reportAndBlockDescription =>
      'Vous pouvez signaler et bloquer un comportement inapproprié de cette IA';

  @override
  String get reportChatError => 'Signaler une erreur de chat';

  @override
  String reportError(String error) {
    return 'Une erreur est survenue lors du signalement : $error';
  }

  @override
  String get reportFailed => 'Échec du signalement';

  @override
  String get reportSubmitted =>
      'Signalement soumis. Nous allons examiner et agir.';

  @override
  String get reportSubmittedSuccess =>
      'Votre signalement a été soumis. Merci !';

  @override
  String get requestLimit => 'Limite de demande';

  @override
  String get required => '[Requis]';

  @override
  String get requiredTermsAgreement => 'Veuillez accepter les conditions';

  @override
  String get restartConversation => 'Redémarrer la conversation';

  @override
  String restartConversationQuestion(String name) {
    return 'Souhaitez-vous redémarrer la conversation avec $name ?';
  }

  @override
  String restartConversationWithName(String name) {
    return 'Redémarrage de la conversation avec $name !';
  }

  @override
  String get retry => 'Réessayer';

  @override
  String get retryButton => 'Réessayer';

  @override
  String get sad => 'Triste';

  @override
  String get saturday => 'Samedi';

  @override
  String get save => 'Enregistrer';

  @override
  String get search => 'Rechercher';

  @override
  String get searchFAQ => 'Rechercher dans la FAQ...';

  @override
  String get searchResults => 'Résultats de recherche';

  @override
  String get selectEmotion => 'Sélectionner une émotion';

  @override
  String get selectErrorType => 'Sélectionner le type d\'erreur';

  @override
  String get selectFeeling => 'Sélectionner un sentiment';

  @override
  String get selectGender => 'Veuillez sélectionner un genre';

  @override
  String get selectInterests => 'Sélectionnez vos intérêts';

  @override
  String get selectLanguage => 'Sélectionner une langue';

  @override
  String get selectPersona => 'Sélectionner une persona';

  @override
  String get selectPersonaPlease => 'Veuillez sélectionner une persona.';

  @override
  String get selectPreferredMbti =>
      'Si vous préférez des personas avec des types MBTI spécifiques, veuillez sélectionner';

  @override
  String get selectProblematicMessage =>
      'Sélectionner le message problématique (optionnel)';

  @override
  String get chatErrorAnalysisInfo => 'Analyse des 10 dernières conversations.';

  @override
  String get whatWasAwkward => 'Qu\'est-ce qui vous a semblé étrange ?';

  @override
  String get errorExampleHint =>
      'Ex : Façon de parler étrange (terminaisons ~nya)...';

  @override
  String get selectReportReason => 'Sélectionner le motif du rapport';

  @override
  String get selectTheme => 'Sélectionner un thème';

  @override
  String get selectTranslationError =>
      'Veuillez sélectionner un message avec une erreur de traduction';

  @override
  String get selectUsagePurpose =>
      'Veuillez sélectionner votre objectif d\'utilisation de SONA';

  @override
  String get selfIntroduction => 'Introduction (Optionnel)';

  @override
  String get selfIntroductionHint =>
      'Écrivez une brève introduction sur vous-même';

  @override
  String get send => 'Envoyer';

  @override
  String get sendChatError => 'Erreur d\'envoi de chat';

  @override
  String get sendFirstMessage => 'Envoyez votre premier message';

  @override
  String get sendReport => 'Envoyer le rapport';

  @override
  String get sendingEmail => 'Envoi de l\'email...';

  @override
  String get seoul => 'Séoul';

  @override
  String get serverErrorDashboard => 'Erreur du serveur';

  @override
  String get serviceTermsAgreement =>
      'Veuillez accepter les conditions de service';

  @override
  String get sessionExpired => 'Session expirée';

  @override
  String get setAppInterfaceLanguage =>
      'Définir la langue de l\'interface de l\'application';

  @override
  String get setNow => 'Définir maintenant';

  @override
  String get settings => 'Paramètres';

  @override
  String get sexualContent => 'Contenu sexuel';

  @override
  String get showAllGenderPersonas => 'Afficher toutes les personas';

  @override
  String get showAllGendersOption => 'Afficher tous les genres';

  @override
  String get showOppositeGenderOnly =>
      'Si décoché, seules les personnes de l\'autre genre seront affichées';

  @override
  String get showOriginalText => 'Afficher l\'original';

  @override
  String get signUp => 'S\'inscrire';

  @override
  String get signUpFromGuest =>
      'Inscrivez-vous maintenant pour accéder à toutes les fonctionnalités !';

  @override
  String get signup => 'Inscription';

  @override
  String get signupComplete => 'Inscription terminée';

  @override
  String get signupTab => 'Inscription';

  @override
  String get simpleInfoRequired =>
      'Des informations simples sont requises pour correspondre avec des personas IA';

  @override
  String get skip => 'Passer';

  @override
  String get sonaFriend => 'SONA Ami';

  @override
  String get sonaPrivacyPolicy => 'Politique de confidentialité de SONA';

  @override
  String get sonaPurchasePolicy => 'Politique d\'achat de SONA';

  @override
  String get sonaTermsOfService => 'Conditions d\'utilisation de SONA';

  @override
  String get sonaUsagePurpose =>
      'Veuillez sélectionner votre objectif d\'utilisation de SONA';

  @override
  String get sorryNotHelpful => 'Désolé, cela n\'a pas été utile';

  @override
  String get sort => 'Trier';

  @override
  String get soundSettings => 'Paramètres de son';

  @override
  String get spamAdvertising => 'Spam/Publicité';

  @override
  String get spanish => 'Espagnol';

  @override
  String get specialRelationshipDesc =>
      'Comprenez-vous et créez des liens profonds';

  @override
  String get sports => 'Sports';

  @override
  String get spring => 'Printemps';

  @override
  String get startChat => 'Démarrer une discussion';

  @override
  String get startChatButton => 'Démarrer le chat';

  @override
  String get startConversation => 'Commencer une conversation';

  @override
  String get startConversationLikeAFriend =>
      'Commencez une conversation avec SONA comme un ami';

  @override
  String get startConversationStep =>
      '2. Commencer la conversation : Discutez librement avec les personas correspondants.';

  @override
  String get startConversationWithSona =>
      'Commencez à discuter avec SONA comme un ami !';

  @override
  String get startWithEmail => 'Commencer avec un e-mail';

  @override
  String get startWithGoogle => 'Commencer avec Google';

  @override
  String get startingApp => 'Lancement de l\'application';

  @override
  String get storageManagement => 'Gestion du stockage';

  @override
  String get store => 'Boutique';

  @override
  String get storeConnectionError => 'Impossible de se connecter à la boutique';

  @override
  String get storeLoginRequiredMessage =>
      'Une connexion est requise pour utiliser la boutique. Voulez-vous aller à l\'écran de connexion ?';

  @override
  String get storeNotAvailable => 'La boutique n\'est pas disponible';

  @override
  String get storyEvent => 'Événement de l\'histoire';

  @override
  String get stressed => 'Stressé';

  @override
  String get submitReport => 'Soumettre le rapport';

  @override
  String get subscriptionStatus => 'État de l\'abonnement';

  @override
  String get subtleVibrationOnTouch => 'Vibration subtile au toucher';

  @override
  String get summer => 'Été';

  @override
  String get sunday => 'Dimanche';

  @override
  String get swipeAnyDirection => 'Glissez dans n\'importe quelle direction';

  @override
  String get swipeDownToClose => 'Glissez vers le bas pour fermer';

  @override
  String get systemTheme => 'Suivre le système';

  @override
  String get systemThemeDesc =>
      'Change automatiquement en fonction des paramètres du mode sombre de l\'appareil';

  @override
  String get tapBottomForDetails => 'Appuyez en bas pour voir les détails';

  @override
  String get tapForDetails =>
      'Appuyez sur la zone inférieure pour plus de détails';

  @override
  String get tapToSwipePhotos => 'Appuyez pour faire défiler les photos';

  @override
  String get teachersDay => 'Journée des enseignants';

  @override
  String get technicalError => 'Erreur technique';

  @override
  String get technology => 'Technologie';

  @override
  String get terms => 'Conditions d\'utilisation';

  @override
  String get termsAgreement => 'Accord des termes';

  @override
  String get termsAgreementDescription =>
      'Veuillez accepter les conditions d\'utilisation du service';

  @override
  String get termsOfService => 'Conditions d\'utilisation';

  @override
  String get termsSection10Content =>
      'Nous nous réservons le droit de modifier ces conditions à tout moment avec notification aux utilisateurs.';

  @override
  String get termsSection10Title => 'Article 10 (Résolution des litiges)';

  @override
  String get termsSection11Content =>
      'Ces conditions seront régies par les lois de la juridiction dans laquelle nous opérons.';

  @override
  String get termsSection11Title =>
      'Article 11 (Dispositions spéciales sur le service d\'IA)';

  @override
  String get termsSection12Content =>
      'Si une disposition de ces conditions est jugée inapplicable, les dispositions restantes continueront de s\'appliquer pleinement.';

  @override
  String get termsSection12Title =>
      'Article 12 (Collecte et utilisation des données)';

  @override
  String get termsSection1Content =>
      'Ces termes et conditions visent à définir les droits, obligations et responsabilités entre SONA (ci-après \"Société\") et les utilisateurs concernant l\'utilisation du service de mise en relation de conversation avec une persona IA (ci-après \"Service\") fourni par la Société.';

  @override
  String get termsSection1Title => 'Article 1 (Objet)';

  @override
  String get termsSection2Content =>
      'En utilisant notre service, vous acceptez d\'être lié par ces Conditions de service et notre Politique de confidentialité.';

  @override
  String get termsSection2Title => 'Article 2 (Définitions)';

  @override
  String get termsSection3Content =>
      'Vous devez avoir au moins 13 ans pour utiliser notre service.';

  @override
  String get termsSection3Title =>
      'Article 3 (Effet et modification des conditions)';

  @override
  String get termsSection4Content =>
      'Vous êtes responsable du maintien de la confidentialité de votre compte et de votre mot de passe.';

  @override
  String get termsSection4Title => 'Article 4 (Fourniture du service)';

  @override
  String get termsSection5Content =>
      'Vous acceptez de ne pas utiliser notre service à des fins illégales ou non autorisées.';

  @override
  String get termsSection5Title => 'Article 5 (Inscription au service)';

  @override
  String get termsSection6Content =>
      'Nous nous réservons le droit de résilier ou de suspendre votre compte en cas de violation de ces conditions.';

  @override
  String get termsSection6Title => 'Article 6 (Obligations de l\'utilisateur)';

  @override
  String get termsSection7Content =>
      'La société peut progressivement restreindre l\'utilisation du service par le biais d\'avertissements, de suspensions temporaires ou de suspensions permanentes si les utilisateurs enfreignent les obligations de ces conditions ou interfèrent avec le bon fonctionnement du service.';

  @override
  String get termsSection7Title =>
      'Article 7 (Restrictions d\'utilisation du service)';

  @override
  String get termsSection8Content =>
      'Nous ne sommes pas responsables des dommages indirects, accessoires ou consécutifs résultant de votre utilisation de notre service.';

  @override
  String get termsSection8Title => 'Article 8 (Interruption du service)';

  @override
  String get termsSection9Content =>
      'Tout le contenu et les matériaux disponibles sur notre service sont protégés par des droits de propriété intellectuelle.';

  @override
  String get termsSection9Title => 'Article 9 (Avertissement)';

  @override
  String get termsSupplementary => 'Conditions supplémentaires';

  @override
  String get thai => 'Thaïlandais';

  @override
  String get thanksFeedback => 'Merci pour vos retours !';

  @override
  String get theme => 'Thème';

  @override
  String get themeDescription =>
      'Vous pouvez personnaliser l\'apparence de l\'application comme vous le souhaitez.';

  @override
  String get themeSettings => 'Paramètres du thème';

  @override
  String get thursday => 'Jeudi';

  @override
  String get timeout => 'Délai dépassé';

  @override
  String get tired => 'Fatigué';

  @override
  String get today => 'Aujourd\'hui';

  @override
  String get todayChats => 'Aujourd\'hui';

  @override
  String get todayText => 'Aujourd\'hui';

  @override
  String get tomorrowText => 'Demain';

  @override
  String get totalConsultSessions => 'Total des sessions de consultation';

  @override
  String get totalErrorCount => 'Total des erreurs';

  @override
  String get totalLikes => 'Total des likes';

  @override
  String totalOccurrences(Object count) {
    return 'Total de $count occurrences';
  }

  @override
  String get totalResponses => 'Total des réponses';

  @override
  String get translatedFrom => 'Traduit';

  @override
  String get translatedText => 'Traduction';

  @override
  String get translationError => 'Erreur de traduction';

  @override
  String get translationErrorDescription =>
      'Veuillez signaler les traductions incorrectes ou les expressions maladroites';

  @override
  String get translationErrorReported =>
      'Erreur de traduction signalée. Merci !';

  @override
  String get translationNote =>
      '※ La traduction par IA peut ne pas être parfaite';

  @override
  String get translationQuality => 'Qualité de la traduction';

  @override
  String get translationSettings => 'Paramètres de traduction';

  @override
  String get travel => 'Voyage';

  @override
  String get tuesday => 'Mardi';

  @override
  String get tutorialAccount => 'Compte de tutoriel';

  @override
  String get tutorialWelcomeDescription =>
      'Créez des relations spéciales avec des personnages IA.';

  @override
  String get tutorialWelcomeTitle => 'Bienvenue sur SONA!';

  @override
  String get typeMessage => 'Tapez un message...';

  @override
  String get unblock => 'Débloquer';

  @override
  String get unblockFailed => 'Échec du déblocage';

  @override
  String unblockPersonaConfirm(String name) {
    return 'Débloquer $name ?';
  }

  @override
  String get unblockedSuccessfully => 'Débloqué avec succès';

  @override
  String get unexpectedLoginError =>
      'Une erreur inattendue est survenue lors de la connexion';

  @override
  String get unknown => 'Inconnu';

  @override
  String get unknownError => 'Erreur inconnue';

  @override
  String get unlimitedMessages => 'Illimité';

  @override
  String get unsendMessage => 'Annuler l\'envoi du message';

  @override
  String get usagePurpose => 'But d\'utilisation';

  @override
  String get useOneHeart => 'Utiliser 1 cœur';

  @override
  String get useSystemLanguage => 'Utiliser la langue du système';

  @override
  String get user => 'Utilisateur :';

  @override
  String get userMessage => 'Message de l\'utilisateur :';

  @override
  String get userNotFound => 'Utilisateur non trouvé';

  @override
  String get valentinesDay => 'Saint-Valentin';

  @override
  String get verifyingAuth => 'Vérification de l\'authentification';

  @override
  String get version => 'Version';

  @override
  String get vietnamese => 'Vietnamien';

  @override
  String get violentContent => 'Contenu violent';

  @override
  String get voiceMessage => '🎤 Message vocal';

  @override
  String waitingForChat(String name) {
    return '$name attend pour discuter.';
  }

  @override
  String get walk => 'Marcher';

  @override
  String get wasHelpful => 'Cela a-t-il été utile ?';

  @override
  String get weatherClear => 'Dégagé';

  @override
  String get weatherCloudy => 'Nuageux';

  @override
  String get weatherContext => 'Contexte Météo';

  @override
  String get weatherContextDesc =>
      'Fournir un contexte de conversation basé sur la météo';

  @override
  String get weatherDrizzle => 'Bruine';

  @override
  String get weatherFog => 'Brouillard';

  @override
  String get weatherMist => 'Brume';

  @override
  String get weatherRain => 'Pluie';

  @override
  String get weatherRainy => 'Pluvieux';

  @override
  String get weatherSnow => 'Neige';

  @override
  String get weatherSnowy => 'Neigeux';

  @override
  String get weatherThunderstorm => 'Orage';

  @override
  String get wednesday => 'Mercredi';

  @override
  String get weekdays => 'Dim,Lun,Mar,Mer,Jeu,Ven,Sam';

  @override
  String get welcomeMessage => 'Bienvenue💕';

  @override
  String get whatTopicsToTalk =>
      'De quels sujets aimeriez-vous parler ? (Optionnel)';

  @override
  String get whiteDay => 'Journée Blanche';

  @override
  String get winter => 'Hiver';

  @override
  String get wrongTranslation => 'Mauvaise Traduction';

  @override
  String get year => 'Année';

  @override
  String get yearEnd => 'Fin d\'année';

  @override
  String get yes => 'Oui';

  @override
  String get yesterday => 'Hier';

  @override
  String get yesterdayChats => 'Hier';

  @override
  String get you => 'Vous';

  @override
  String get loadingPersonaData => 'Chargement des données de persona';

  @override
  String get checkingMatchedPersonas =>
      'Vérification des personas correspondants';

  @override
  String get preparingImages => 'Préparation des images';

  @override
  String get finalPreparation => 'Préparation finale';

  @override
  String get editProfileSubtitle =>
      'Modifier le genre, la date de naissance et la présentation';

  @override
  String get systemThemeName => 'Système';

  @override
  String get lightThemeName => 'Clair';

  @override
  String get darkThemeName => 'Sombre';

  @override
  String get alwaysShowTranslationOn => 'Always Show Translation';

  @override
  String get alwaysShowTranslationOff => 'Hide Auto Translation';

  @override
  String get translationErrorAnalysisInfo =>
      'Nous analyserons le message sélectionné et sa traduction.';

  @override
  String get whatWasWrongWithTranslation =>
      'Qu\'est-ce qui n\'allait pas avec la traduction ?';

  @override
  String get translationErrorHint =>
      'Ex : Sens incorrect, expression non naturelle, contexte erroné...';

  @override
  String get pleaseSelectMessage => 'Veuillez d\'abord sélectionner un message';

  @override
  String get myPersonas => 'Mes Personas';

  @override
  String get createPersona => 'Créer un Persona';

  @override
  String get tellUsAboutYourPersona => 'Tell us about your persona';

  @override
  String get enterPersonaName => 'Enter persona name';

  @override
  String get describeYourPersona => 'Describe your persona briefly';

  @override
  String get profileImage => 'Profile Image';

  @override
  String get uploadPersonaImages => 'Upload images for your persona';

  @override
  String get mainImage => 'Main Image';

  @override
  String get tapToUpload => 'Tap to upload';

  @override
  String get additionalImages => 'Additional Images';

  @override
  String get addImage => 'Add Image';

  @override
  String get mbtiQuestion => 'Personality Question';

  @override
  String get mbtiComplete => 'Personality Test Complete!';

  @override
  String get mbtiTest => 'Test MBTI';

  @override
  String get mbtiStepDescription =>
      'Let\'s determine what personality your persona should have. Answer questions to shape their character.';

  @override
  String get startTest => 'Start Test';

  @override
  String get personalitySettings => 'Personality Settings';

  @override
  String get speechStyle => 'Style de Parole';

  @override
  String get conversationStyle => 'Style de Conversation';

  @override
  String get shareWithCommunity => 'Share with Community';

  @override
  String get shareDescription =>
      'Your persona can be shared with other users after approval';

  @override
  String get sharePersona => 'Share Persona';

  @override
  String get willBeSharedAfterApproval =>
      'Sera partagé après approbation de l\'administrateur';

  @override
  String get privatePersonaDescription => 'Only you can see this persona';

  @override
  String get create => 'Create';

  @override
  String get personaCreated => 'Persona créé avec succès';

  @override
  String get createFailed => 'Échec de la création';

  @override
  String get pendingApproval => 'En Attente d\'Approbation';

  @override
  String get approved => 'Approuvé';

  @override
  String get privatePersona => 'Private';

  @override
  String get noPersonasYet => 'No Personas Yet';

  @override
  String get createYourFirstPersona =>
      'Create your first persona and start your journey';

  @override
  String get deletePersona => 'Supprimer le Persona';

  @override
  String get deletePersonaConfirm =>
      'Êtes-vous sûr de vouloir supprimer ce persona ? Cette action ne peut pas être annulée.';

  @override
  String get personaDeleted => 'Persona supprimé avec succès';

  @override
  String get deleteFailed => 'Échec de la suppression';

  @override
  String get personaLimitReached => 'You have reached the limit of 3 personas';

  @override
  String get personaName => 'Nom du Persona';

  @override
  String get personaAge => 'Âge';

  @override
  String get personaDescription => 'Description';

  @override
  String get personaNameHint => 'Ex : Emma, Lucas';

  @override
  String get personaDescriptionHint => 'Décrivez brièvement votre persona';

  @override
  String get loginRequiredContent => 'Please log in to continue';

  @override
  String get reportErrorButton => 'Report Error';

  @override
  String get speechStyleFriendly => 'Amical';

  @override
  String get speechStylePolite => 'Poli';

  @override
  String get speechStyleChic => 'Chic';

  @override
  String get speechStyleLively => 'Animé';

  @override
  String get conversationStyleTalkative => 'Bavard';

  @override
  String get conversationStyleQuiet => 'Silencieux';

  @override
  String get conversationStyleEmpathetic => 'Empathique';

  @override
  String get conversationStyleLogical => 'Logique';

  @override
  String get interestMusic => 'Musique';

  @override
  String get interestMovies => 'Films';

  @override
  String get interestReading => 'Lecture';

  @override
  String get interestTravel => 'Voyages';

  @override
  String get interestExercise => 'Exercice';

  @override
  String get interestGaming => 'Jeux vidéo';

  @override
  String get interestCooking => 'Cuisine';

  @override
  String get interestFashion => 'Mode';

  @override
  String get interestArt => 'Art';

  @override
  String get interestPhotography => 'Photographie';

  @override
  String get interestTechnology => 'Technologie';

  @override
  String get interestScience => 'Science';

  @override
  String get interestHistory => 'Histoire';

  @override
  String get interestPhilosophy => 'Philosophie';

  @override
  String get interestPolitics => 'Politique';

  @override
  String get interestEconomy => 'Économie';

  @override
  String get interestSports => 'Sports';

  @override
  String get interestAnimation => 'Animation';

  @override
  String get interestKpop => 'K-POP';

  @override
  String get interestDrama => 'Drame';

  @override
  String get imageOptionalR2 =>
      'Les images sont optionnelles. Elles ne seront téléchargées que si R2 est configuré.';

  @override
  String get networkErrorCheckConnection =>
      'Erreur réseau : Veuillez vérifier votre connexion internet';

  @override
  String get maxFiveItems => 'Jusqu\'à 5 éléments';

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
}
