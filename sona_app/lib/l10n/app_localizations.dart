import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_id.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_nl.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_sv.dart';
import 'app_localizations_th.dart';
import 'app_localizations_tl.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_ur.dart';
import 'app_localizations_vi.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('hi'),
    Locale('id'),
    Locale('it'),
    Locale('ja'),
    Locale('ko'),
    Locale('nl'),
    Locale('pl'),
    Locale('pt'),
    Locale('ru'),
    Locale('sv'),
    Locale('th'),
    Locale('tl'),
    Locale('tr'),
    Locale('ur'),
    Locale('vi'),
    Locale('zh')
  ];

  /// Localized string for about
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// Localized string for accountAndProfile
  ///
  /// In en, this message translates to:
  /// **'Account & Profile Information'**
  String get accountAndProfile;

  /// Localized string for accountDeletedSuccess
  ///
  /// In en, this message translates to:
  /// **'Account deleted successfully'**
  String get accountDeletedSuccess;

  /// Localized string for accountDeletionContent
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your account?\nThis action cannot be undone.'**
  String get accountDeletionContent;

  /// Localized string for accountDeletionError
  ///
  /// In en, this message translates to:
  /// **'Error occurred while deleting account.'**
  String get accountDeletionError;

  /// Localized string for accountDeletionInfo
  ///
  /// In en, this message translates to:
  /// **'Account deletion information'**
  String get accountDeletionInfo;

  /// Localized string for accountDeletionTitle
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get accountDeletionTitle;

  /// Localized string for accountDeletionWarning1
  ///
  /// In en, this message translates to:
  /// **'Warning: This action cannot be undone'**
  String get accountDeletionWarning1;

  /// Localized string for accountDeletionWarning2
  ///
  /// In en, this message translates to:
  /// **'All your data will be permanently deleted'**
  String get accountDeletionWarning2;

  /// Localized string for accountDeletionWarning3
  ///
  /// In en, this message translates to:
  /// **'You will lose access to all conversations'**
  String get accountDeletionWarning3;

  /// Localized string for accountDeletionWarning4
  ///
  /// In en, this message translates to:
  /// **'This includes all purchased content'**
  String get accountDeletionWarning4;

  /// Localized string for accountManagement
  ///
  /// In en, this message translates to:
  /// **'Account Management'**
  String get accountManagement;

  /// Localized string for adaptiveConversationDesc
  ///
  /// In en, this message translates to:
  /// **'Adapts conversation style to match yours'**
  String get adaptiveConversationDesc;

  /// Localized string for afternoon
  ///
  /// In en, this message translates to:
  /// **'Afternoon'**
  String get afternoon;

  /// Localized string for afternoonFatigue
  ///
  /// In en, this message translates to:
  /// **'Afternoon fatigue'**
  String get afternoonFatigue;

  /// Localized string for ageConfirmation
  ///
  /// In en, this message translates to:
  /// **'I am 14 years or older and have confirmed the above.'**
  String get ageConfirmation;

  /// Age range
  ///
  /// In en, this message translates to:
  /// **'{min}-{max} years old'**
  String ageRange(int min, int max);

  /// Localized string for ageUnit
  ///
  /// In en, this message translates to:
  /// **'years old'**
  String get ageUnit;

  /// Localized string for agreeToTerms
  ///
  /// In en, this message translates to:
  /// **'I agree to the terms'**
  String get agreeToTerms;

  /// Localized string for aiDatingQuestion
  ///
  /// In en, this message translates to:
  /// **'A special daily life with AI\nMeet your own personas.'**
  String get aiDatingQuestion;

  /// Localized string for aiPersonaPreferenceDescription
  ///
  /// In en, this message translates to:
  /// **'Please set your preferences for AI persona matching'**
  String get aiPersonaPreferenceDescription;

  /// All tab label
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// Localized string for allAgree
  ///
  /// In en, this message translates to:
  /// **'Agree to All'**
  String get allAgree;

  /// Localized string for allFeaturesRequired
  ///
  /// In en, this message translates to:
  /// **'※ All features are required for service provision'**
  String get allFeaturesRequired;

  /// Localized string for allPersonas
  ///
  /// In en, this message translates to:
  /// **'All Personas'**
  String get allPersonas;

  /// Localized string for allPersonasMatched
  ///
  /// In en, this message translates to:
  /// **'All personas matched! Start chatting with them.'**
  String get allPersonasMatched;

  /// Localized string for allowPermission
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get allowPermission;

  /// Already chatting with persona
  ///
  /// In en, this message translates to:
  /// **'Already chatting with {name}!'**
  String alreadyChattingWith(String name);

  /// Localized string for alsoBlockThisAI
  ///
  /// In en, this message translates to:
  /// **'Also block this AI'**
  String get alsoBlockThisAI;

  /// Localized string for angry
  ///
  /// In en, this message translates to:
  /// **'Angry'**
  String get angry;

  /// Localized string for anonymousLogin
  ///
  /// In en, this message translates to:
  /// **'Anonymous login'**
  String get anonymousLogin;

  /// Localized string for anxious
  ///
  /// In en, this message translates to:
  /// **'Anxious'**
  String get anxious;

  /// Localized string for apiKeyError
  ///
  /// In en, this message translates to:
  /// **'API Key Error'**
  String get apiKeyError;

  /// Localized string for appName
  ///
  /// In en, this message translates to:
  /// **'SONA'**
  String get appName;

  /// Localized string for appTagline
  ///
  /// In en, this message translates to:
  /// **'Your AI companions'**
  String get appTagline;

  /// Localized string for appleLoginCanceled
  ///
  /// In en, this message translates to:
  /// **'Apple login was canceled.\nPlease try again.'**
  String get appleLoginCanceled;

  /// Localized string for appleLoginError
  ///
  /// In en, this message translates to:
  /// **'Error occurred during Apple login.'**
  String get appleLoginError;

  /// Localized string for art
  ///
  /// In en, this message translates to:
  /// **'Art'**
  String get art;

  /// Localized string for authError
  ///
  /// In en, this message translates to:
  /// **'Authentication Error'**
  String get authError;

  /// Localized string for autoTranslate
  ///
  /// In en, this message translates to:
  /// **'Auto Translate'**
  String get autoTranslate;

  /// Localized string for autumn
  ///
  /// In en, this message translates to:
  /// **'Autumn'**
  String get autumn;

  /// Localized string for averageQuality
  ///
  /// In en, this message translates to:
  /// **'Average Quality'**
  String get averageQuality;

  /// Localized string for averageQualityScore
  ///
  /// In en, this message translates to:
  /// **'Average Quality Score'**
  String get averageQualityScore;

  /// Localized string for awkwardExpression
  ///
  /// In en, this message translates to:
  /// **'Awkward Expression'**
  String get awkwardExpression;

  /// Localized string for backButton
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get backButton;

  /// Basic information step title
  ///
  /// In en, this message translates to:
  /// **'Basic Information'**
  String get basicInfo;

  /// Localized string for basicInfoDescription
  ///
  /// In en, this message translates to:
  /// **'Please enter basic information to create an account'**
  String get basicInfoDescription;

  /// Localized string for birthDate
  ///
  /// In en, this message translates to:
  /// **'Birth Date'**
  String get birthDate;

  /// Localized string for birthDateOptional
  ///
  /// In en, this message translates to:
  /// **'Birth Date (Optional)'**
  String get birthDateOptional;

  /// Localized string for birthDateRequired
  ///
  /// In en, this message translates to:
  /// **'Birth Date *'**
  String get birthDateRequired;

  /// Localized string for blockConfirm
  ///
  /// In en, this message translates to:
  /// **'Do you want to block this AI?\nBlocked AIs will be excluded from matching and chat list.'**
  String get blockConfirm;

  /// Localized string for blockReason
  ///
  /// In en, this message translates to:
  /// **'Block reason'**
  String get blockReason;

  /// Localized string for blockThisAI
  ///
  /// In en, this message translates to:
  /// **'Block this AI'**
  String get blockThisAI;

  /// Number of blocked AIs
  ///
  /// In en, this message translates to:
  /// **'{count} blocked AIs'**
  String blockedAICount(int count);

  /// Localized string for blockedAIs
  ///
  /// In en, this message translates to:
  /// **'Blocked AIs'**
  String get blockedAIs;

  /// Localized string for blockedAt
  ///
  /// In en, this message translates to:
  /// **'Blocked at'**
  String get blockedAt;

  /// Localized string for blockedSuccessfully
  ///
  /// In en, this message translates to:
  /// **'Blocked successfully'**
  String get blockedSuccessfully;

  /// Localized string for breakfast
  ///
  /// In en, this message translates to:
  /// **'Breakfast'**
  String get breakfast;

  /// Localized string for byErrorType
  ///
  /// In en, this message translates to:
  /// **'By Error Type'**
  String get byErrorType;

  /// Localized string for byPersona
  ///
  /// In en, this message translates to:
  /// **'By Persona'**
  String get byPersona;

  /// Cache delete error
  ///
  /// In en, this message translates to:
  /// **'Error deleting cache: {error}'**
  String cacheDeleteError(String error);

  /// Localized string for cacheDeleted
  ///
  /// In en, this message translates to:
  /// **'Image cache has been deleted'**
  String get cacheDeleted;

  /// Localized string for cafeTerrace
  ///
  /// In en, this message translates to:
  /// **'Cafe terrace'**
  String get cafeTerrace;

  /// Localized string for calm
  ///
  /// In en, this message translates to:
  /// **'Calm'**
  String get calm;

  /// Localized string for cameraPermission
  ///
  /// In en, this message translates to:
  /// **'Camera Permission'**
  String get cameraPermission;

  /// Localized string for cameraPermissionDesc
  ///
  /// In en, this message translates to:
  /// **'Camera access is required to take profile photos.'**
  String get cameraPermissionDesc;

  /// Localized string for canChangeInSettings
  ///
  /// In en, this message translates to:
  /// **'You can change this later in settings'**
  String get canChangeInSettings;

  /// Localized string for canMeetPreviousPersonas
  ///
  /// In en, this message translates to:
  /// **'You can meet personas\nyou swiped before again!'**
  String get canMeetPreviousPersonas;

  /// Localized string for cancel
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Localized string for changeProfilePhoto
  ///
  /// In en, this message translates to:
  /// **'Change Profile Photo'**
  String get changeProfilePhoto;

  /// Localized string for chat
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chat;

  /// Localized string for chatEndedMessage
  ///
  /// In en, this message translates to:
  /// **'Chat has ended'**
  String get chatEndedMessage;

  /// Localized string for chatErrorDashboard
  ///
  /// In en, this message translates to:
  /// **'Chat Error Dashboard'**
  String get chatErrorDashboard;

  /// Localized string for chatErrorSentSuccessfully
  ///
  /// In en, this message translates to:
  /// **'Chat error has been sent successfully.'**
  String get chatErrorSentSuccessfully;

  /// Localized string for chatListTab
  ///
  /// In en, this message translates to:
  /// **'Chat List Tab'**
  String get chatListTab;

  /// Localized string for chats
  ///
  /// In en, this message translates to:
  /// **'Chats'**
  String get chats;

  /// Number of personas chatting with
  ///
  /// In en, this message translates to:
  /// **'Chatting with {count} personas'**
  String chattingWithPersonas(int count);

  /// Localized string for checkInternetConnection
  ///
  /// In en, this message translates to:
  /// **'Please check your internet connection'**
  String get checkInternetConnection;

  /// Localized string for checkingUserInfo
  ///
  /// In en, this message translates to:
  /// **'Checking user info'**
  String get checkingUserInfo;

  /// Localized string for childrensDay
  ///
  /// In en, this message translates to:
  /// **'Children\'s Day'**
  String get childrensDay;

  /// Localized string for chinese
  ///
  /// In en, this message translates to:
  /// **'Chinese'**
  String get chinese;

  /// Localized string for chooseOption
  ///
  /// In en, this message translates to:
  /// **'Please choose:'**
  String get chooseOption;

  /// Localized string for christmas
  ///
  /// In en, this message translates to:
  /// **'Christmas'**
  String get christmas;

  /// Localized string for close
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// Completion message
  ///
  /// In en, this message translates to:
  /// **'Complete!'**
  String get complete;

  /// Localized string for completeSignup
  ///
  /// In en, this message translates to:
  /// **'Complete Sign Up'**
  String get completeSignup;

  /// Localized string for confirm
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// Localized string for connectingToServer
  ///
  /// In en, this message translates to:
  /// **'Connecting to server'**
  String get connectingToServer;

  /// Localized string for consultQualityMonitoring
  ///
  /// In en, this message translates to:
  /// **'Consultation Quality Monitoring'**
  String get consultQualityMonitoring;

  /// Localized string for continueAsGuest
  ///
  /// In en, this message translates to:
  /// **'Continue as Guest'**
  String get continueAsGuest;

  /// Localized string for continueButton
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// Localized string for continueWithApple
  ///
  /// In en, this message translates to:
  /// **'Continue with Apple'**
  String get continueWithApple;

  /// Localized string for continueWithGoogle
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;

  /// Localized string for conversationContinuity
  ///
  /// In en, this message translates to:
  /// **'Conversation Continuity'**
  String get conversationContinuity;

  /// Localized string for conversationContinuityDesc
  ///
  /// In en, this message translates to:
  /// **'Remember previous conversations and connect topics'**
  String get conversationContinuityDesc;

  /// Conversation with name
  ///
  /// In en, this message translates to:
  /// **'{name}'**
  String conversationWith(String name);

  /// Localized string for convertToMember
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get convertToMember;

  /// Localized string for cooking
  ///
  /// In en, this message translates to:
  /// **'Cooking'**
  String get cooking;

  /// Localized string for copyMessage
  ///
  /// In en, this message translates to:
  /// **'Copy message'**
  String get copyMessage;

  /// Localized string for copyrightInfringement
  ///
  /// In en, this message translates to:
  /// **'Copyright infringement'**
  String get copyrightInfringement;

  /// Localized string for creatingAccount
  ///
  /// In en, this message translates to:
  /// **'Creating account'**
  String get creatingAccount;

  /// Localized string for crisisDetected
  ///
  /// In en, this message translates to:
  /// **'Crisis Detected'**
  String get crisisDetected;

  /// Localized string for culturalIssue
  ///
  /// In en, this message translates to:
  /// **'Cultural Issue'**
  String get culturalIssue;

  /// Localized string for current
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get current;

  /// Localized string for currentCacheSize
  ///
  /// In en, this message translates to:
  /// **'Current Cache Size'**
  String get currentCacheSize;

  /// Localized string for currentLanguage
  ///
  /// In en, this message translates to:
  /// **'Current Language'**
  String get currentLanguage;

  /// Localized string for cycling
  ///
  /// In en, this message translates to:
  /// **'Cycling'**
  String get cycling;

  /// Localized string for dailyCare
  ///
  /// In en, this message translates to:
  /// **'Daily Care'**
  String get dailyCare;

  /// Localized string for dailyCareDesc
  ///
  /// In en, this message translates to:
  /// **'Daily care messages for meals, sleep, health'**
  String get dailyCareDesc;

  /// Localized string for dailyChat
  ///
  /// In en, this message translates to:
  /// **'Daily Chat'**
  String get dailyChat;

  /// Localized string for dailyCheck
  ///
  /// In en, this message translates to:
  /// **'Daily check'**
  String get dailyCheck;

  /// Localized string for dailyConversation
  ///
  /// In en, this message translates to:
  /// **'Daily Conversation'**
  String get dailyConversation;

  /// Localized string for dailyLimitDescription
  ///
  /// In en, this message translates to:
  /// **'You have reached your daily message limit'**
  String get dailyLimitDescription;

  /// Localized string for dailyLimitTitle
  ///
  /// In en, this message translates to:
  /// **'Daily Limit Reached'**
  String get dailyLimitTitle;

  /// Localized string for darkMode
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// Localized string for darkTheme
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkTheme;

  /// Localized string for darkThemeDesc
  ///
  /// In en, this message translates to:
  /// **'Use dark theme'**
  String get darkThemeDesc;

  /// Localized string for dataCollection
  ///
  /// In en, this message translates to:
  /// **'Data Collection Settings'**
  String get dataCollection;

  /// Localized string for datingAdvice
  ///
  /// In en, this message translates to:
  /// **'Dating Advice'**
  String get datingAdvice;

  /// Localized string for datingDescription
  ///
  /// In en, this message translates to:
  /// **'I want to share deep thoughts and have sincere conversations'**
  String get datingDescription;

  /// Localized string for dawn
  ///
  /// In en, this message translates to:
  /// **'Dawn'**
  String get dawn;

  /// Localized string for day
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get day;

  /// Localized string for dayAfterTomorrow
  ///
  /// In en, this message translates to:
  /// **'Day after tomorrow'**
  String get dayAfterTomorrow;

  /// Days ago format
  ///
  /// In en, this message translates to:
  /// **'{count} days ago'**
  String daysAgo(int count, String formatted);

  /// Days remaining
  ///
  /// In en, this message translates to:
  /// **'{days} days remaining'**
  String daysRemaining(int days);

  /// Localized string for deepTalk
  ///
  /// In en, this message translates to:
  /// **'Deep Talk'**
  String get deepTalk;

  /// Localized string for delete
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Localized string for deleteAccount
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// Localized string for deleteAccountConfirm
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your account? This action cannot be undone.'**
  String get deleteAccountConfirm;

  /// Localized string for deleteAccountWarning
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your account?'**
  String get deleteAccountWarning;

  /// Localized string for deleteCache
  ///
  /// In en, this message translates to:
  /// **'Delete Cache'**
  String get deleteCache;

  /// Localized string for deletingAccount
  ///
  /// In en, this message translates to:
  /// **'Deleting account...'**
  String get deletingAccount;

  /// Localized string for depressed
  ///
  /// In en, this message translates to:
  /// **'Depressed'**
  String get depressed;

  /// Localized string for describeError
  ///
  /// In en, this message translates to:
  /// **'What is the problem?'**
  String get describeError;

  /// Localized string for detailedReason
  ///
  /// In en, this message translates to:
  /// **'Detailed reason'**
  String get detailedReason;

  /// Localized string for developRelationshipStep
  ///
  /// In en, this message translates to:
  /// **'3. Develop Relationship: Build intimacy through conversations and develop special relationships.'**
  String get developRelationshipStep;

  /// Localized string for dinner
  ///
  /// In en, this message translates to:
  /// **'Dinner'**
  String get dinner;

  /// Localized string for discardGuestData
  ///
  /// In en, this message translates to:
  /// **'Start Fresh'**
  String get discardGuestData;

  /// Localized string for discount20
  ///
  /// In en, this message translates to:
  /// **'20% off'**
  String get discount20;

  /// Localized string for discount30
  ///
  /// In en, this message translates to:
  /// **'30% off'**
  String get discount30;

  /// Localized string for discountAmount
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get discountAmount;

  /// Discount amount
  ///
  /// In en, this message translates to:
  /// **'Save ₩{amount}'**
  String discountAmountValue(String amount);

  /// Localized string for done
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// Localized string for downloadingPersonaImages
  ///
  /// In en, this message translates to:
  /// **'Downloading new persona images'**
  String get downloadingPersonaImages;

  /// Localized string for edit
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// Localized string for editInfo
  ///
  /// In en, this message translates to:
  /// **'Edit Info'**
  String get editInfo;

  /// Localized string for editProfile
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// Localized string for effectSound
  ///
  /// In en, this message translates to:
  /// **'Sound Effects'**
  String get effectSound;

  /// Localized string for effectSoundDescription
  ///
  /// In en, this message translates to:
  /// **'Play sound effects'**
  String get effectSoundDescription;

  /// Localized string for email
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// Localized string for emailHint
  ///
  /// In en, this message translates to:
  /// **'example@email.com'**
  String get emailHint;

  /// Localized string for emailLabel
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// Localized string for emailRequired
  ///
  /// In en, this message translates to:
  /// **'Email *'**
  String get emailRequired;

  /// Localized string for emotionAnalysis
  ///
  /// In en, this message translates to:
  /// **'Emotion Analysis'**
  String get emotionAnalysis;

  /// Localized string for emotionAnalysisDesc
  ///
  /// In en, this message translates to:
  /// **'Analyze emotions for empathetic responses'**
  String get emotionAnalysisDesc;

  /// Localized string for emotionAngry
  ///
  /// In en, this message translates to:
  /// **'Angry'**
  String get emotionAngry;

  /// Localized string for emotionBasedEncounters
  ///
  /// In en, this message translates to:
  /// **'Meet personas based on your emotions'**
  String get emotionBasedEncounters;

  /// Localized string for emotionCool
  ///
  /// In en, this message translates to:
  /// **'Cool'**
  String get emotionCool;

  /// Localized string for emotionHappy
  ///
  /// In en, this message translates to:
  /// **'Happy'**
  String get emotionHappy;

  /// Localized string for emotionLove
  ///
  /// In en, this message translates to:
  /// **'Love'**
  String get emotionLove;

  /// Localized string for emotionSad
  ///
  /// In en, this message translates to:
  /// **'Sad'**
  String get emotionSad;

  /// Localized string for emotionThinking
  ///
  /// In en, this message translates to:
  /// **'Thinking'**
  String get emotionThinking;

  /// Localized string for emotionalSupportDesc
  ///
  /// In en, this message translates to:
  /// **'Share your concerns and receive warm comfort'**
  String get emotionalSupportDesc;

  /// Localized string for endChat
  ///
  /// In en, this message translates to:
  /// **'End Chat'**
  String get endChat;

  /// Localized string for endTutorial
  ///
  /// In en, this message translates to:
  /// **'End Tutorial'**
  String get endTutorial;

  /// Localized string for endTutorialAndLogin
  ///
  /// In en, this message translates to:
  /// **'End tutorial and login?\nLogin to save data and use all features.'**
  String get endTutorialAndLogin;

  /// Localized string for endTutorialMessage
  ///
  /// In en, this message translates to:
  /// **'Do you want to end the tutorial and login?\nBy logging in, your data will be saved and you can use all features.'**
  String get endTutorialMessage;

  /// Localized string for english
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// Localized string for enterBasicInfo
  ///
  /// In en, this message translates to:
  /// **'Please enter basic information to create an account'**
  String get enterBasicInfo;

  /// Localized string for enterBasicInformation
  ///
  /// In en, this message translates to:
  /// **'Please enter basic information'**
  String get enterBasicInformation;

  /// Localized string for enterEmail
  ///
  /// In en, this message translates to:
  /// **'Please enter email'**
  String get enterEmail;

  /// Localized string for enterNickname
  ///
  /// In en, this message translates to:
  /// **'Please enter a nickname'**
  String get enterNickname;

  /// Localized string for enterPassword
  ///
  /// In en, this message translates to:
  /// **'Please enter a password'**
  String get enterPassword;

  /// Localized string for entertainmentAndFunDesc
  ///
  /// In en, this message translates to:
  /// **'Enjoy fun games and pleasant conversations'**
  String get entertainmentAndFunDesc;

  /// Localized string for entertainmentDescription
  ///
  /// In en, this message translates to:
  /// **'I want to have fun conversations and enjoy my time'**
  String get entertainmentDescription;

  /// Localized string for entertainmentFun
  ///
  /// In en, this message translates to:
  /// **'Entertainment/Fun'**
  String get entertainmentFun;

  /// Localized string for error
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// Localized string for errorDescription
  ///
  /// In en, this message translates to:
  /// **'Error description'**
  String get errorDescription;

  /// Localized string for errorDescriptionHint
  ///
  /// In en, this message translates to:
  /// **'e.g., Gave strange answers, Repeats the same thing, Gives contextually inappropriate responses...'**
  String get errorDescriptionHint;

  /// Localized string for errorDetails
  ///
  /// In en, this message translates to:
  /// **'Error Details'**
  String get errorDetails;

  /// Localized string for errorDetailsHint
  ///
  /// In en, this message translates to:
  /// **'Please explain in detail what is wrong'**
  String get errorDetailsHint;

  /// Localized string for errorFrequency24h
  ///
  /// In en, this message translates to:
  /// **'Error Frequency (Last 24 hours)'**
  String get errorFrequency24h;

  /// Localized string for errorMessage
  ///
  /// In en, this message translates to:
  /// **'Error Message:'**
  String get errorMessage;

  /// Localized string for errorOccurred
  ///
  /// In en, this message translates to:
  /// **'An error occurred.'**
  String get errorOccurred;

  /// Localized string for errorOccurredTryAgain
  ///
  /// In en, this message translates to:
  /// **'An error occurred. Please try again.'**
  String get errorOccurredTryAgain;

  /// Localized string for errorSendingFailed
  ///
  /// In en, this message translates to:
  /// **'Failed to send error'**
  String get errorSendingFailed;

  /// Localized string for errorStats
  ///
  /// In en, this message translates to:
  /// **'Error Statistics'**
  String get errorStats;

  /// Error with message
  ///
  /// In en, this message translates to:
  /// **'Error occurred: {error}'**
  String errorWithMessage(String error);

  /// Localized string for evening
  ///
  /// In en, this message translates to:
  /// **'Evening'**
  String get evening;

  /// Localized string for excited
  ///
  /// In en, this message translates to:
  /// **'Excited'**
  String get excited;

  /// Localized string for exit
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get exit;

  /// Localized string for exitApp
  ///
  /// In en, this message translates to:
  /// **'Exit App'**
  String get exitApp;

  /// Localized string for exitConfirmMessage
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to exit the app?'**
  String get exitConfirmMessage;

  /// Localized string for expertPersona
  ///
  /// In en, this message translates to:
  /// **'Expert Persona'**
  String get expertPersona;

  /// Localized string for expertiseScore
  ///
  /// In en, this message translates to:
  /// **'Expertise Score'**
  String get expertiseScore;

  /// Localized string for expired
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get expired;

  /// Localized string for explainReportReason
  ///
  /// In en, this message translates to:
  /// **'Please explain the report reason in detail'**
  String get explainReportReason;

  /// Localized string for fashion
  ///
  /// In en, this message translates to:
  /// **'Fashion'**
  String get fashion;

  /// Localized string for female
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// Localized string for filter
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// Localized string for firstOccurred
  ///
  /// In en, this message translates to:
  /// **'First Occurred: '**
  String get firstOccurred;

  /// Localized string for followDeviceLanguage
  ///
  /// In en, this message translates to:
  /// **'Follow device language settings'**
  String get followDeviceLanguage;

  /// Localized string for forenoon
  ///
  /// In en, this message translates to:
  /// **'Forenoon'**
  String get forenoon;

  /// Localized string for forgotPassword
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgotPassword;

  /// Localized string for frequentlyAskedQuestions
  ///
  /// In en, this message translates to:
  /// **'Frequently Asked Questions'**
  String get frequentlyAskedQuestions;

  /// Localized string for friday
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get friday;

  /// Localized string for friendshipDescription
  ///
  /// In en, this message translates to:
  /// **'I want to meet new friends and have conversations'**
  String get friendshipDescription;

  /// Localized string for funChat
  ///
  /// In en, this message translates to:
  /// **'Fun Chat'**
  String get funChat;

  /// Localized string for galleryPermission
  ///
  /// In en, this message translates to:
  /// **'Gallery Permission'**
  String get galleryPermission;

  /// Localized string for galleryPermissionDesc
  ///
  /// In en, this message translates to:
  /// **'Gallery access is required to select profile photos.'**
  String get galleryPermissionDesc;

  /// Localized string for gaming
  ///
  /// In en, this message translates to:
  /// **'Gaming'**
  String get gaming;

  /// Localized string for gender
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// Localized string for genderNotSelectedInfo
  ///
  /// In en, this message translates to:
  /// **'If gender is not selected, personas of all genders will be shown'**
  String get genderNotSelectedInfo;

  /// Localized string for genderOptional
  ///
  /// In en, this message translates to:
  /// **'Gender (Optional)'**
  String get genderOptional;

  /// Localized string for genderPreferenceActive
  ///
  /// In en, this message translates to:
  /// **'You can meet personas of all genders'**
  String get genderPreferenceActive;

  /// Localized string for genderPreferenceDisabled
  ///
  /// In en, this message translates to:
  /// **'Select your gender to enable opposite gender only option'**
  String get genderPreferenceDisabled;

  /// Localized string for genderPreferenceInactive
  ///
  /// In en, this message translates to:
  /// **'Only opposite gender personas will be shown'**
  String get genderPreferenceInactive;

  /// Localized string for genderRequired
  ///
  /// In en, this message translates to:
  /// **'Gender *'**
  String get genderRequired;

  /// Localized string for genderSelectionInfo
  ///
  /// In en, this message translates to:
  /// **'If not selected, you can meet personas of all genders'**
  String get genderSelectionInfo;

  /// Localized string for generalPersona
  ///
  /// In en, this message translates to:
  /// **'General Persona'**
  String get generalPersona;

  /// Localized string for goToSettings
  ///
  /// In en, this message translates to:
  /// **'Go to Settings'**
  String get goToSettings;

  /// Guide text for Android permission settings
  ///
  /// In en, this message translates to:
  /// **'Settings > Apps > SONA > Permissions\nPlease allow photo permission'**
  String get permissionGuideAndroid;

  /// Guide text for iOS permission settings
  ///
  /// In en, this message translates to:
  /// **'Settings > SONA > Photos\nPlease allow photo access'**
  String get permissionGuideIOS;

  /// Localized string for googleLoginCanceled
  ///
  /// In en, this message translates to:
  /// **'Google login was canceled.\nPlease try again.'**
  String get googleLoginCanceled;

  /// Localized string for googleLoginError
  ///
  /// In en, this message translates to:
  /// **'Error occurred during Google login.'**
  String get googleLoginError;

  /// Localized string for grantPermission
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get grantPermission;

  /// Localized string for guest
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get guest;

  /// Localized string for guestDataMigration
  ///
  /// In en, this message translates to:
  /// **'Would you like to keep your current chat history when signing up?'**
  String get guestDataMigration;

  /// Localized string for guestLimitReached
  ///
  /// In en, this message translates to:
  /// **'Guest trial ended.\nSign up for unlimited conversations!'**
  String get guestLimitReached;

  /// Localized string for guestLoginPromptMessage
  ///
  /// In en, this message translates to:
  /// **'Login to continue the conversation'**
  String get guestLoginPromptMessage;

  /// Localized string for guestMessageExhausted
  ///
  /// In en, this message translates to:
  /// **'Free messages exhausted'**
  String get guestMessageExhausted;

  /// Guest messages remaining
  ///
  /// In en, this message translates to:
  /// **'{count} guest messages remaining'**
  String guestMessageRemaining(int count);

  /// Localized string for guestModeBanner
  ///
  /// In en, this message translates to:
  /// **'Guest Mode'**
  String get guestModeBanner;

  /// Localized string for guestModeDescription
  ///
  /// In en, this message translates to:
  /// **'Try SONA without signing up\n• 20 message limit\n• 1 heart provided\n• View all personas'**
  String get guestModeDescription;

  /// Localized string for guestModeFailedMessage
  ///
  /// In en, this message translates to:
  /// **'Failed to start Guest Mode'**
  String get guestModeFailedMessage;

  /// Localized string for guestModeLimitation
  ///
  /// In en, this message translates to:
  /// **'Some features are limited in Guest Mode'**
  String get guestModeLimitation;

  /// Localized string for guestModeTitle
  ///
  /// In en, this message translates to:
  /// **'Try as Guest'**
  String get guestModeTitle;

  /// Localized string for guestModeWarning
  ///
  /// In en, this message translates to:
  /// **'Guest mode lasts for 24 hours,\nafter which data will be deleted.'**
  String get guestModeWarning;

  /// Localized string for guestModeWelcome
  ///
  /// In en, this message translates to:
  /// **'Starting in Guest Mode'**
  String get guestModeWelcome;

  /// Localized string for happy
  ///
  /// In en, this message translates to:
  /// **'Happy'**
  String get happy;

  /// Localized string for hapticFeedback
  ///
  /// In en, this message translates to:
  /// **'Haptic Feedback'**
  String get hapticFeedback;

  /// Localized string for harassmentBullying
  ///
  /// In en, this message translates to:
  /// **'Harassment/Bullying'**
  String get harassmentBullying;

  /// Localized string for hateSpeech
  ///
  /// In en, this message translates to:
  /// **'Hate speech'**
  String get hateSpeech;

  /// Localized string for heartDescription
  ///
  /// In en, this message translates to:
  /// **'Hearts for more messages'**
  String get heartDescription;

  /// Localized string for heartInsufficient
  ///
  /// In en, this message translates to:
  /// **'Not enough hearts'**
  String get heartInsufficient;

  /// Localized string for heartInsufficientPleaseCharge
  ///
  /// In en, this message translates to:
  /// **'Not enough hearts. Please recharge hearts.'**
  String get heartInsufficientPleaseCharge;

  /// Localized string for heartRequired
  ///
  /// In en, this message translates to:
  /// **'1 heart is required'**
  String get heartRequired;

  /// Localized string for heartUsageFailed
  ///
  /// In en, this message translates to:
  /// **'Failed to use heart.'**
  String get heartUsageFailed;

  /// Localized string for hearts
  ///
  /// In en, this message translates to:
  /// **'Hearts'**
  String get hearts;

  /// Localized string for hearts10
  ///
  /// In en, this message translates to:
  /// **'10 Hearts'**
  String get hearts10;

  /// Localized string for hearts30
  ///
  /// In en, this message translates to:
  /// **'30 Hearts'**
  String get hearts30;

  /// Localized string for hearts30Discount
  ///
  /// In en, this message translates to:
  /// **'SALE'**
  String get hearts30Discount;

  /// Localized string for hearts50
  ///
  /// In en, this message translates to:
  /// **'50 Hearts'**
  String get hearts50;

  /// Localized string for hearts50Discount
  ///
  /// In en, this message translates to:
  /// **'SALE'**
  String get hearts50Discount;

  /// Localized string for helloEmoji
  ///
  /// In en, this message translates to:
  /// **'Hello! 😊'**
  String get helloEmoji;

  /// Localized string for help
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help;

  /// Localized string for hideOriginalText
  ///
  /// In en, this message translates to:
  /// **'Hide Original'**
  String get hideOriginalText;

  /// Localized string for hobbySharing
  ///
  /// In en, this message translates to:
  /// **'Hobby Sharing'**
  String get hobbySharing;

  /// Localized string for hobbyTalk
  ///
  /// In en, this message translates to:
  /// **'Hobby Talk'**
  String get hobbyTalk;

  /// Localized string for hours24Ago
  ///
  /// In en, this message translates to:
  /// **'24 hours ago'**
  String get hours24Ago;

  /// Hours ago format
  ///
  /// In en, this message translates to:
  /// **'{count} hours ago'**
  String hoursAgo(int count, String formatted);

  /// Localized string for howToUse
  ///
  /// In en, this message translates to:
  /// **'How to use SONA'**
  String get howToUse;

  /// Localized string for imageCacheManagement
  ///
  /// In en, this message translates to:
  /// **'Image Cache Management'**
  String get imageCacheManagement;

  /// Localized string for inappropriateContent
  ///
  /// In en, this message translates to:
  /// **'Inappropriate content'**
  String get inappropriateContent;

  /// Localized string for incorrect
  ///
  /// In en, this message translates to:
  /// **'incorrect'**
  String get incorrect;

  /// Localized string for incorrectPassword
  ///
  /// In en, this message translates to:
  /// **'Incorrect password'**
  String get incorrectPassword;

  /// Localized string for indonesian
  ///
  /// In en, this message translates to:
  /// **'Indonesian'**
  String get indonesian;

  /// Localized string for inquiries
  ///
  /// In en, this message translates to:
  /// **'Inquiries'**
  String get inquiries;

  /// Localized string for insufficientHearts
  ///
  /// In en, this message translates to:
  /// **'Insufficient hearts.'**
  String get insufficientHearts;

  /// Localized string for interestSharing
  ///
  /// In en, this message translates to:
  /// **'Interest Sharing'**
  String get interestSharing;

  /// Localized string for interestSharingDesc
  ///
  /// In en, this message translates to:
  /// **'Discover and recommend shared interests'**
  String get interestSharingDesc;

  /// Interests label
  ///
  /// In en, this message translates to:
  /// **'Interests'**
  String get interests;

  /// Localized string for invalidEmailFormat
  ///
  /// In en, this message translates to:
  /// **'Invalid email format'**
  String get invalidEmailFormat;

  /// Localized string for invalidEmailFormatError
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get invalidEmailFormatError;

  /// Shows someone is typing
  ///
  /// In en, this message translates to:
  /// **'{name} is typing...'**
  String isTyping(String name);

  /// Localized string for japanese
  ///
  /// In en, this message translates to:
  /// **'Japanese'**
  String get japanese;

  /// Localized string for joinDate
  ///
  /// In en, this message translates to:
  /// **'Join Date'**
  String get joinDate;

  /// Localized string for justNow
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get justNow;

  /// Localized string for keepGuestData
  ///
  /// In en, this message translates to:
  /// **'Keep Chat History'**
  String get keepGuestData;

  /// Localized string for korean
  ///
  /// In en, this message translates to:
  /// **'Korean'**
  String get korean;

  /// Localized string for koreanLanguage
  ///
  /// In en, this message translates to:
  /// **'Korean'**
  String get koreanLanguage;

  /// Localized string for language
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Localized string for languageDescription
  ///
  /// In en, this message translates to:
  /// **'AI will respond in your selected language'**
  String get languageDescription;

  /// Localized string for languageIndicator
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageIndicator;

  /// Localized string for languageSettings
  ///
  /// In en, this message translates to:
  /// **'Language Settings'**
  String get languageSettings;

  /// Localized string for lastOccurred
  ///
  /// In en, this message translates to:
  /// **'Last Occurred: '**
  String get lastOccurred;

  /// Localized string for lastUpdated
  ///
  /// In en, this message translates to:
  /// **'Last Updated'**
  String get lastUpdated;

  /// Localized string for lateNight
  ///
  /// In en, this message translates to:
  /// **'Late night'**
  String get lateNight;

  /// Localized string for later
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get later;

  /// Localized string for laterButton
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get laterButton;

  /// Localized string for leave
  ///
  /// In en, this message translates to:
  /// **'Leave'**
  String get leave;

  /// Localized string for leaveChatConfirm
  ///
  /// In en, this message translates to:
  /// **'Leave this chat?\nIt will disappear from your chat list.'**
  String get leaveChatConfirm;

  /// Localized string for leaveChatRoom
  ///
  /// In en, this message translates to:
  /// **'Leave Chat Room'**
  String get leaveChatRoom;

  /// Localized string for leaveChatTitle
  ///
  /// In en, this message translates to:
  /// **'Leave Chat'**
  String get leaveChatTitle;

  /// Localized string for lifeAdvice
  ///
  /// In en, this message translates to:
  /// **'Life Advice'**
  String get lifeAdvice;

  /// Localized string for lightTalk
  ///
  /// In en, this message translates to:
  /// **'Light Talk'**
  String get lightTalk;

  /// Localized string for lightTheme
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get lightTheme;

  /// Localized string for lightThemeDesc
  ///
  /// In en, this message translates to:
  /// **'Use bright theme'**
  String get lightThemeDesc;

  /// Localized string for loading
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// Localized string for loadingData
  ///
  /// In en, this message translates to:
  /// **'Loading data...'**
  String get loadingData;

  /// Localized string for loadingProducts
  ///
  /// In en, this message translates to:
  /// **'Loading products...'**
  String get loadingProducts;

  /// Localized string for loadingProfile
  ///
  /// In en, this message translates to:
  /// **'Loading profile'**
  String get loadingProfile;

  /// Localized string for login
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// Localized string for loginButton
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginButton;

  /// Localized string for loginCancelled
  ///
  /// In en, this message translates to:
  /// **'Login cancelled'**
  String get loginCancelled;

  /// Localized string for loginComplete
  ///
  /// In en, this message translates to:
  /// **'Login complete'**
  String get loginComplete;

  /// Localized string for loginError
  ///
  /// In en, this message translates to:
  /// **'Login failed'**
  String get loginError;

  /// Localized string for loginFailed
  ///
  /// In en, this message translates to:
  /// **'Login failed'**
  String get loginFailed;

  /// Localized string for loginFailedTryAgain
  ///
  /// In en, this message translates to:
  /// **'Login failed. Please try again.'**
  String get loginFailedTryAgain;

  /// Localized string for loginRequired
  ///
  /// In en, this message translates to:
  /// **'Login required'**
  String get loginRequired;

  /// Localized string for loginRequiredForProfile
  ///
  /// In en, this message translates to:
  /// **'Login required to view profile\nand check records with SONA'**
  String get loginRequiredForProfile;

  /// Localized string for loginRequiredService
  ///
  /// In en, this message translates to:
  /// **'Login required to use this service'**
  String get loginRequiredService;

  /// Localized string for loginRequiredTitle
  ///
  /// In en, this message translates to:
  /// **'Login Required'**
  String get loginRequiredTitle;

  /// Localized string for loginSignup
  ///
  /// In en, this message translates to:
  /// **'Login/Sign Up'**
  String get loginSignup;

  /// Localized string for loginTab
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginTab;

  /// Localized string for loginTitle
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginTitle;

  /// Localized string for loginWithApple
  ///
  /// In en, this message translates to:
  /// **'Login with Apple'**
  String get loginWithApple;

  /// Localized string for loginWithGoogle
  ///
  /// In en, this message translates to:
  /// **'Login with Google'**
  String get loginWithGoogle;

  /// Localized string for logout
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// Localized string for logoutConfirm
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get logoutConfirm;

  /// Localized string for lonelinessRelief
  ///
  /// In en, this message translates to:
  /// **'Loneliness Relief'**
  String get lonelinessRelief;

  /// Localized string for lonely
  ///
  /// In en, this message translates to:
  /// **'Lonely'**
  String get lonely;

  /// Localized string for lowQualityResponses
  ///
  /// In en, this message translates to:
  /// **'Low Quality Responses'**
  String get lowQualityResponses;

  /// Localized string for lunch
  ///
  /// In en, this message translates to:
  /// **'Lunch'**
  String get lunch;

  /// Localized string for lunchtime
  ///
  /// In en, this message translates to:
  /// **'Lunchtime'**
  String get lunchtime;

  /// Localized string for mainErrorType
  ///
  /// In en, this message translates to:
  /// **'Main Error Type'**
  String get mainErrorType;

  /// Localized string for makeFriends
  ///
  /// In en, this message translates to:
  /// **'Make Friends'**
  String get makeFriends;

  /// Localized string for male
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// Localized string for manageBlockedAIs
  ///
  /// In en, this message translates to:
  /// **'Manage Blocked AIs'**
  String get manageBlockedAIs;

  /// Localized string for managePersonaImageCache
  ///
  /// In en, this message translates to:
  /// **'Manage persona image cache'**
  String get managePersonaImageCache;

  /// Localized string for marketingAgree
  ///
  /// In en, this message translates to:
  /// **'Agree to Marketing Information (Optional)'**
  String get marketingAgree;

  /// Localized string for marketingDescription
  ///
  /// In en, this message translates to:
  /// **'You can receive event and benefit information'**
  String get marketingDescription;

  /// Localized string for matchPersonaStep
  ///
  /// In en, this message translates to:
  /// **'1. Match Personas: Swipe left or right to select your favorite AI personas.'**
  String get matchPersonaStep;

  /// Localized string for matchedPersonas
  ///
  /// In en, this message translates to:
  /// **'Matched Personas'**
  String get matchedPersonas;

  /// Localized string for matchedSona
  ///
  /// In en, this message translates to:
  /// **'Matched Sona'**
  String get matchedSona;

  /// Localized string for matching
  ///
  /// In en, this message translates to:
  /// **'Matching'**
  String get matching;

  /// Localized string for matchingFailed
  ///
  /// In en, this message translates to:
  /// **'Matching failed.'**
  String get matchingFailed;

  /// Localized string for me
  ///
  /// In en, this message translates to:
  /// **'Me'**
  String get me;

  /// Localized string for meetAIPersonas
  ///
  /// In en, this message translates to:
  /// **'Meet AI Personas'**
  String get meetAIPersonas;

  /// Localized string for meetNewPersonas
  ///
  /// In en, this message translates to:
  /// **'Meet New Personas'**
  String get meetNewPersonas;

  /// Localized string for meetPersonas
  ///
  /// In en, this message translates to:
  /// **'Meet Personas'**
  String get meetPersonas;

  /// Localized string for memberBenefits
  ///
  /// In en, this message translates to:
  /// **'Get 100+ messages and 10 hearts when you sign up!'**
  String get memberBenefits;

  /// Localized string for memoryAlbum
  ///
  /// In en, this message translates to:
  /// **'Memory Album'**
  String get memoryAlbum;

  /// Localized string for memoryAlbumDesc
  ///
  /// In en, this message translates to:
  /// **'Automatically save and recall special moments'**
  String get memoryAlbumDesc;

  /// Localized string for messageCopied
  ///
  /// In en, this message translates to:
  /// **'Message copied'**
  String get messageCopied;

  /// Localized string for messageDeleted
  ///
  /// In en, this message translates to:
  /// **'Message deleted'**
  String get messageDeleted;

  /// Localized string for messageLimitReset
  ///
  /// In en, this message translates to:
  /// **'Message limit will reset at midnight'**
  String get messageLimitReset;

  /// Localized string for messageSendFailed
  ///
  /// In en, this message translates to:
  /// **'Failed to send message. Please try again.'**
  String get messageSendFailed;

  /// Label for messages remaining
  ///
  /// In en, this message translates to:
  /// **'Messages Remaining'**
  String get messagesRemaining;

  /// Minutes ago format
  ///
  /// In en, this message translates to:
  /// **'{count} minutes ago'**
  String minutesAgo(int count, String formatted);

  /// Localized string for missingTranslation
  ///
  /// In en, this message translates to:
  /// **'Missing Translation'**
  String get missingTranslation;

  /// Localized string for monday
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get monday;

  /// Localized string for month
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get month;

  /// Month and day format
  ///
  /// In en, this message translates to:
  /// **'{month} {day}'**
  String monthDay(String month, int day);

  /// Localized string for moreButton
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get moreButton;

  /// Localized string for morning
  ///
  /// In en, this message translates to:
  /// **'Morning'**
  String get morning;

  /// Localized string for mostFrequentError
  ///
  /// In en, this message translates to:
  /// **'Most Frequent Error'**
  String get mostFrequentError;

  /// Localized string for movies
  ///
  /// In en, this message translates to:
  /// **'Movies'**
  String get movies;

  /// Localized string for multilingualChat
  ///
  /// In en, this message translates to:
  /// **'Multilingual Chat'**
  String get multilingualChat;

  /// Localized string for music
  ///
  /// In en, this message translates to:
  /// **'Music'**
  String get music;

  /// Localized string for myGenderSection
  ///
  /// In en, this message translates to:
  /// **'My Gender (Optional)'**
  String get myGenderSection;

  /// Localized string for networkErrorOccurred
  ///
  /// In en, this message translates to:
  /// **'A network error occurred.'**
  String get networkErrorOccurred;

  /// Localized string for newMessage
  ///
  /// In en, this message translates to:
  /// **'New message'**
  String get newMessage;

  /// Number of new messages
  ///
  /// In en, this message translates to:
  /// **'{count} new messages'**
  String newMessageCount(int count);

  /// Localized string for newMessageNotification
  ///
  /// In en, this message translates to:
  /// **'Notify me of new messages'**
  String get newMessageNotification;

  /// Localized string for newMessages
  ///
  /// In en, this message translates to:
  /// **'New messages'**
  String get newMessages;

  /// Localized string for newYear
  ///
  /// In en, this message translates to:
  /// **'New Year'**
  String get newYear;

  /// Localized string for next
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// Localized string for niceToMeetYou
  ///
  /// In en, this message translates to:
  /// **'Nice to meet you!'**
  String get niceToMeetYou;

  /// Localized string for nickname
  ///
  /// In en, this message translates to:
  /// **'Nickname'**
  String get nickname;

  /// Localized string for nicknameAlreadyUsed
  ///
  /// In en, this message translates to:
  /// **'This nickname is already in use'**
  String get nicknameAlreadyUsed;

  /// Localized string for nicknameHelperText
  ///
  /// In en, this message translates to:
  /// **'3-10 characters'**
  String get nicknameHelperText;

  /// Localized string for nicknameHint
  ///
  /// In en, this message translates to:
  /// **'3-10 characters'**
  String get nicknameHint;

  /// Localized string for nicknameInUse
  ///
  /// In en, this message translates to:
  /// **'This nickname is already in use'**
  String get nicknameInUse;

  /// Localized string for nicknameLabel
  ///
  /// In en, this message translates to:
  /// **'Nickname'**
  String get nicknameLabel;

  /// Localized string for nicknameLengthError
  ///
  /// In en, this message translates to:
  /// **'Nickname must be 3-10 characters'**
  String get nicknameLengthError;

  /// Localized string for nicknamePlaceholder
  ///
  /// In en, this message translates to:
  /// **'Enter your nickname'**
  String get nicknamePlaceholder;

  /// Localized string for nicknameRequired
  ///
  /// In en, this message translates to:
  /// **'Nickname *'**
  String get nicknameRequired;

  /// Localized string for night
  ///
  /// In en, this message translates to:
  /// **'Night'**
  String get night;

  /// Localized string for no
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// Localized string for noBlockedAIs
  ///
  /// In en, this message translates to:
  /// **'No blocked AIs'**
  String get noBlockedAIs;

  /// Localized string for noChatsYet
  ///
  /// In en, this message translates to:
  /// **'No chats yet'**
  String get noChatsYet;

  /// Localized string for noConversationYet
  ///
  /// In en, this message translates to:
  /// **'No conversation yet'**
  String get noConversationYet;

  /// Localized string for noErrorReports
  ///
  /// In en, this message translates to:
  /// **'No error reports.'**
  String get noErrorReports;

  /// Localized string for noImageAvailable
  ///
  /// In en, this message translates to:
  /// **'No image available'**
  String get noImageAvailable;

  /// Localized string for noMatchedPersonas
  ///
  /// In en, this message translates to:
  /// **'No matched personas yet'**
  String get noMatchedPersonas;

  /// Localized string for noMatchedSonas
  ///
  /// In en, this message translates to:
  /// **'No matched Sonas yet'**
  String get noMatchedSonas;

  /// Localized string for noPersonasAvailable
  ///
  /// In en, this message translates to:
  /// **'No personas available. Please try again.'**
  String get noPersonasAvailable;

  /// Localized string for noPersonasToSelect
  ///
  /// In en, this message translates to:
  /// **'No personas available'**
  String get noPersonasToSelect;

  /// Localized string for noQualityIssues
  ///
  /// In en, this message translates to:
  /// **'No quality issues in the last hour ✅'**
  String get noQualityIssues;

  /// Localized string for noQualityLogs
  ///
  /// In en, this message translates to:
  /// **'No quality logs yet.'**
  String get noQualityLogs;

  /// Localized string for noTranslatedMessages
  ///
  /// In en, this message translates to:
  /// **'No messages to translate'**
  String get noTranslatedMessages;

  /// Localized string for notEnoughHearts
  ///
  /// In en, this message translates to:
  /// **'Not enough hearts'**
  String get notEnoughHearts;

  /// Not enough hearts message
  ///
  /// In en, this message translates to:
  /// **'Not enough hearts. (Current: {count})'**
  String notEnoughHeartsCount(int count);

  /// Localized string for notRegistered
  ///
  /// In en, this message translates to:
  /// **'not registered'**
  String get notRegistered;

  /// Localized string for notSubscribed
  ///
  /// In en, this message translates to:
  /// **'Not subscribed'**
  String get notSubscribed;

  /// Localized string for notificationPermissionDesc
  ///
  /// In en, this message translates to:
  /// **'Notification permission is required to receive new messages.'**
  String get notificationPermissionDesc;

  /// Localized string for notificationPermissionRequired
  ///
  /// In en, this message translates to:
  /// **'Notification permission required'**
  String get notificationPermissionRequired;

  /// Localized string for notificationSettings
  ///
  /// In en, this message translates to:
  /// **'Notification Settings'**
  String get notificationSettings;

  /// Localized string for notifications
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// Localized string for occurrenceInfo
  ///
  /// In en, this message translates to:
  /// **'Occurrence Info:'**
  String get occurrenceInfo;

  /// Localized string for olderChats
  ///
  /// In en, this message translates to:
  /// **'Older'**
  String get olderChats;

  /// Localized string for onlyOppositeGenderNote
  ///
  /// In en, this message translates to:
  /// **'If unchecked, only opposite gender personas will be shown'**
  String get onlyOppositeGenderNote;

  /// Localized string for openSettings
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get openSettings;

  /// Optional label
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get optional;

  /// Localized string for or
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get or;

  /// Localized string for originalPrice
  ///
  /// In en, this message translates to:
  /// **'Original'**
  String get originalPrice;

  /// Localized string for originalText
  ///
  /// In en, this message translates to:
  /// **'Original'**
  String get originalText;

  /// Other gender option
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// Localized string for otherError
  ///
  /// In en, this message translates to:
  /// **'Other Error'**
  String get otherError;

  /// Localized string for others
  ///
  /// In en, this message translates to:
  /// **'Others'**
  String get others;

  /// Localized string for ownedHearts
  ///
  /// In en, this message translates to:
  /// **'Owned Hearts'**
  String get ownedHearts;

  /// Localized string for parentsDay
  ///
  /// In en, this message translates to:
  /// **'Parents\' Day'**
  String get parentsDay;

  /// Localized string for password
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Localized string for passwordConfirmation
  ///
  /// In en, this message translates to:
  /// **'Enter password to confirm'**
  String get passwordConfirmation;

  /// Localized string for passwordConfirmationDesc
  ///
  /// In en, this message translates to:
  /// **'Please re-enter your password to delete account.'**
  String get passwordConfirmationDesc;

  /// Localized string for passwordHint
  ///
  /// In en, this message translates to:
  /// **'6 characters or more'**
  String get passwordHint;

  /// Localized string for passwordLabel
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// Localized string for passwordRequired
  ///
  /// In en, this message translates to:
  /// **'Password *'**
  String get passwordRequired;

  /// Localized string for passwordResetEmailPrompt
  ///
  /// In en, this message translates to:
  /// **'Please enter your email to reset password'**
  String get passwordResetEmailPrompt;

  /// Localized string for passwordResetEmailSent
  ///
  /// In en, this message translates to:
  /// **'Password reset email has been sent. Please check your email.'**
  String get passwordResetEmailSent;

  /// Localized string for passwordText
  ///
  /// In en, this message translates to:
  /// **'password'**
  String get passwordText;

  /// Localized string for passwordTooShort
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordTooShort;

  /// Localized string for permissionDenied
  ///
  /// In en, this message translates to:
  /// **'Permission denied'**
  String get permissionDenied;

  /// Permission denied message
  ///
  /// In en, this message translates to:
  /// **'{permissionName} permission was denied.\\nPlease allow the permission in settings.'**
  String permissionDeniedMessage(String permissionName);

  /// Localized string for permissionDeniedTryLater
  ///
  /// In en, this message translates to:
  /// **'Permission denied. Please try again later.'**
  String get permissionDeniedTryLater;

  /// Localized string for permissionRequired
  ///
  /// In en, this message translates to:
  /// **'Permission Required'**
  String get permissionRequired;

  /// Localized string for personaGenderSection
  ///
  /// In en, this message translates to:
  /// **'Persona Gender Preference'**
  String get personaGenderSection;

  /// Localized string for personaQualityStats
  ///
  /// In en, this message translates to:
  /// **'Persona Quality Statistics'**
  String get personaQualityStats;

  /// Localized string for personalInfoExposure
  ///
  /// In en, this message translates to:
  /// **'Personal information exposure'**
  String get personalInfoExposure;

  /// Localized string for personality
  ///
  /// In en, this message translates to:
  /// **'Personality'**
  String get personality;

  /// Localized string for pets
  ///
  /// In en, this message translates to:
  /// **'Pets'**
  String get pets;

  /// Localized string for photo
  ///
  /// In en, this message translates to:
  /// **'Photo'**
  String get photo;

  /// Localized string for photography
  ///
  /// In en, this message translates to:
  /// **'Photography'**
  String get photography;

  /// Localized string for picnic
  ///
  /// In en, this message translates to:
  /// **'Picnic'**
  String get picnic;

  /// Localized string for preferenceSettings
  ///
  /// In en, this message translates to:
  /// **'Preference Settings'**
  String get preferenceSettings;

  /// Localized string for preferredLanguage
  ///
  /// In en, this message translates to:
  /// **'Preferred Language'**
  String get preferredLanguage;

  /// Localized string for preparingForSleep
  ///
  /// In en, this message translates to:
  /// **'Preparing for sleep'**
  String get preparingForSleep;

  /// Localized string for preparingNewMeeting
  ///
  /// In en, this message translates to:
  /// **'Preparing new meeting'**
  String get preparingNewMeeting;

  /// Localized string for preparingPersonaImages
  ///
  /// In en, this message translates to:
  /// **'Preparing persona images'**
  String get preparingPersonaImages;

  /// Localized string for preparingPersonas
  ///
  /// In en, this message translates to:
  /// **'Preparing personas'**
  String get preparingPersonas;

  /// Localized string for preview
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get preview;

  /// Previous button text
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// Localized string for privacy
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacy;

  /// Localized string for privacyPolicy
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// Localized string for privacyPolicyAgreement
  ///
  /// In en, this message translates to:
  /// **'Please agree to the privacy policy'**
  String get privacyPolicyAgreement;

  /// Localized string for privacySection1Content
  ///
  /// In en, this message translates to:
  /// **'We are committed to protecting your privacy. This Privacy Policy explains how we collect, use, and safeguard your information when you use our service.'**
  String get privacySection1Content;

  /// Localized string for privacySection1Title
  ///
  /// In en, this message translates to:
  /// **'1. Purpose of Collection and Use of Personal Information'**
  String get privacySection1Title;

  /// Localized string for privacySection2Content
  ///
  /// In en, this message translates to:
  /// **'We collect information you provide directly to us, such as when you create an account, update your profile, or use our services.'**
  String get privacySection2Content;

  /// Localized string for privacySection2Title
  ///
  /// In en, this message translates to:
  /// **'Information We Collect'**
  String get privacySection2Title;

  /// Localized string for privacySection3Content
  ///
  /// In en, this message translates to:
  /// **'We use the information we collect to provide, maintain, and improve our services, and to communicate with you.'**
  String get privacySection3Content;

  /// Localized string for privacySection3Title
  ///
  /// In en, this message translates to:
  /// **'3. Retention and Use Period of Personal Information'**
  String get privacySection3Title;

  /// Localized string for privacySection4Content
  ///
  /// In en, this message translates to:
  /// **'We do not sell, trade, or otherwise transfer your personal information to third parties without your consent.'**
  String get privacySection4Content;

  /// Localized string for privacySection4Title
  ///
  /// In en, this message translates to:
  /// **'4. Provision of Personal Information to Third Parties'**
  String get privacySection4Title;

  /// Localized string for privacySection5Content
  ///
  /// In en, this message translates to:
  /// **'We implement appropriate security measures to protect your personal information against unauthorized access, alteration, disclosure, or destruction.'**
  String get privacySection5Content;

  /// Localized string for privacySection5Title
  ///
  /// In en, this message translates to:
  /// **'5. Technical Protection Measures for Personal Information'**
  String get privacySection5Title;

  /// Localized string for privacySection6Content
  ///
  /// In en, this message translates to:
  /// **'We retain personal information for as long as necessary to provide our services and comply with legal obligations.'**
  String get privacySection6Content;

  /// Localized string for privacySection6Title
  ///
  /// In en, this message translates to:
  /// **'6. User Rights'**
  String get privacySection6Title;

  /// Localized string for privacySection7Content
  ///
  /// In en, this message translates to:
  /// **'You have the right to access, update, or delete your personal information at any time through your account settings.'**
  String get privacySection7Content;

  /// Localized string for privacySection7Title
  ///
  /// In en, this message translates to:
  /// **'Your Rights'**
  String get privacySection7Title;

  /// Localized string for privacySection8Content
  ///
  /// In en, this message translates to:
  /// **'If you have any questions about this Privacy Policy, please contact us at support@sona.com.'**
  String get privacySection8Content;

  /// Localized string for privacySection8Title
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get privacySection8Title;

  /// Localized string for privacySettings
  ///
  /// In en, this message translates to:
  /// **'Privacy Settings'**
  String get privacySettings;

  /// Localized string for privacySettingsInfo
  ///
  /// In en, this message translates to:
  /// **'Disabling individual features will make those services unavailable'**
  String get privacySettingsInfo;

  /// Localized string for privacySettingsScreen
  ///
  /// In en, this message translates to:
  /// **'Privacy Settings'**
  String get privacySettingsScreen;

  /// Localized string for problemMessage
  ///
  /// In en, this message translates to:
  /// **'Problem'**
  String get problemMessage;

  /// Localized string for problemOccurred
  ///
  /// In en, this message translates to:
  /// **'Problem Occurred'**
  String get problemOccurred;

  /// Localized string for profile
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// Localized string for profileEdit
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get profileEdit;

  /// Localized string for profileEditLoginRequiredMessage
  ///
  /// In en, this message translates to:
  /// **'Login is required to edit your profile.\nWould you like to go to the login screen?'**
  String get profileEditLoginRequiredMessage;

  /// Localized string for profileInfo
  ///
  /// In en, this message translates to:
  /// **'Profile Information'**
  String get profileInfo;

  /// Localized string for profileInfoDescription
  ///
  /// In en, this message translates to:
  /// **'Please enter your profile photo and basic information'**
  String get profileInfoDescription;

  /// Localized string for profileNav
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileNav;

  /// Localized string for profilePhoto
  ///
  /// In en, this message translates to:
  /// **'Profile Photo'**
  String get profilePhoto;

  /// Localized string for profilePhotoAndInfo
  ///
  /// In en, this message translates to:
  /// **'Please enter profile photo and basic information'**
  String get profilePhotoAndInfo;

  /// Localized string for profilePhotoUpdateFailed
  ///
  /// In en, this message translates to:
  /// **'Failed to update profile photo'**
  String get profilePhotoUpdateFailed;

  /// Localized string for profilePhotoUpdated
  ///
  /// In en, this message translates to:
  /// **'Profile photo updated'**
  String get profilePhotoUpdated;

  /// Localized string for profileSettings
  ///
  /// In en, this message translates to:
  /// **'Profile Settings'**
  String get profileSettings;

  /// Localized string for profileSetup
  ///
  /// In en, this message translates to:
  /// **'Setting up profile'**
  String get profileSetup;

  /// Localized string for profileUpdateFailed
  ///
  /// In en, this message translates to:
  /// **'Failed to update profile'**
  String get profileUpdateFailed;

  /// Localized string for profileUpdated
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get profileUpdated;

  /// Localized string for purchaseAndRefundPolicy
  ///
  /// In en, this message translates to:
  /// **'Purchase & Refund Policy'**
  String get purchaseAndRefundPolicy;

  /// Localized string for purchaseButton
  ///
  /// In en, this message translates to:
  /// **'Purchase'**
  String get purchaseButton;

  /// Localized string for purchaseConfirm
  ///
  /// In en, this message translates to:
  /// **'Purchase Confirmation'**
  String get purchaseConfirm;

  /// Purchase confirmation content
  ///
  /// In en, this message translates to:
  /// **'Purchase {product} for {price}?'**
  String purchaseConfirmContent(String product, String price);

  /// Purchase confirmation message
  ///
  /// In en, this message translates to:
  /// **'Confirm purchase of {title} for {price}? {description}'**
  String purchaseConfirmMessage(String title, String price, String description);

  /// Localized string for purchaseFailed
  ///
  /// In en, this message translates to:
  /// **'Purchase failed'**
  String get purchaseFailed;

  /// Localized string for purchaseHeartsOnly
  ///
  /// In en, this message translates to:
  /// **'Buy hearts'**
  String get purchaseHeartsOnly;

  /// Localized string for purchaseMoreHearts
  ///
  /// In en, this message translates to:
  /// **'Purchase hearts to continue conversations'**
  String get purchaseMoreHearts;

  /// Localized string for purchasePending
  ///
  /// In en, this message translates to:
  /// **'Purchase pending...'**
  String get purchasePending;

  /// Localized string for purchasePolicy
  ///
  /// In en, this message translates to:
  /// **'Purchase Policy'**
  String get purchasePolicy;

  /// Localized string for purchaseSection1Content
  ///
  /// In en, this message translates to:
  /// **'We accept various payment methods including credit cards and digital wallets.'**
  String get purchaseSection1Content;

  /// Localized string for purchaseSection1Title
  ///
  /// In en, this message translates to:
  /// **'Payment Methods'**
  String get purchaseSection1Title;

  /// Localized string for purchaseSection2Content
  ///
  /// In en, this message translates to:
  /// **'Refunds are available within 14 days of purchase if you have not used the purchased items.'**
  String get purchaseSection2Content;

  /// Localized string for purchaseSection2Title
  ///
  /// In en, this message translates to:
  /// **'Refund Policy'**
  String get purchaseSection2Title;

  /// Localized string for purchaseSection3Content
  ///
  /// In en, this message translates to:
  /// **'You can cancel your subscription at any time through your account settings.'**
  String get purchaseSection3Content;

  /// Localized string for purchaseSection3Title
  ///
  /// In en, this message translates to:
  /// **'Cancellation'**
  String get purchaseSection3Title;

  /// Localized string for purchaseSection4Content
  ///
  /// In en, this message translates to:
  /// **'By making a purchase, you agree to our terms of use and service agreement.'**
  String get purchaseSection4Content;

  /// Localized string for purchaseSection4Title
  ///
  /// In en, this message translates to:
  /// **'Terms of Use'**
  String get purchaseSection4Title;

  /// Localized string for purchaseSection5Content
  ///
  /// In en, this message translates to:
  /// **'For purchase-related issues, please contact our support team.'**
  String get purchaseSection5Content;

  /// Localized string for purchaseSection5Title
  ///
  /// In en, this message translates to:
  /// **'Contact Support'**
  String get purchaseSection5Title;

  /// Localized string for purchaseSection6Content
  ///
  /// In en, this message translates to:
  /// **'All purchases are subject to our standard terms and conditions.'**
  String get purchaseSection6Content;

  /// Localized string for purchaseSection6Title
  ///
  /// In en, this message translates to:
  /// **'6. Inquiries'**
  String get purchaseSection6Title;

  /// Localized string for pushNotifications
  ///
  /// In en, this message translates to:
  /// **'Push Notifications'**
  String get pushNotifications;

  /// Localized string for reading
  ///
  /// In en, this message translates to:
  /// **'Reading'**
  String get reading;

  /// Localized string for realtimeQualityLog
  ///
  /// In en, this message translates to:
  /// **'Real-time Quality Log'**
  String get realtimeQualityLog;

  /// Localized string for recentConversation
  ///
  /// In en, this message translates to:
  /// **'Recent Conversation:'**
  String get recentConversation;

  /// Localized string for recentLoginRequired
  ///
  /// In en, this message translates to:
  /// **'Please login again for security'**
  String get recentLoginRequired;

  /// Localized string for referrerEmail
  ///
  /// In en, this message translates to:
  /// **'Referrer Email'**
  String get referrerEmail;

  /// Localized string for referrerEmailHelper
  ///
  /// In en, this message translates to:
  /// **'Optional: Email of who referred you'**
  String get referrerEmailHelper;

  /// Localized string for referrerEmailLabel
  ///
  /// In en, this message translates to:
  /// **'Referrer Email (Optional)'**
  String get referrerEmailLabel;

  /// Localized string for refresh
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// Refresh complete message
  ///
  /// In en, this message translates to:
  /// **'Refresh complete! {count} matched personas'**
  String refreshComplete(int count);

  /// Localized string for refreshFailed
  ///
  /// In en, this message translates to:
  /// **'Refresh failed'**
  String get refreshFailed;

  /// Localized string for refreshingChatList
  ///
  /// In en, this message translates to:
  /// **'Refreshing chat list...'**
  String get refreshingChatList;

  /// Localized string for relatedFAQ
  ///
  /// In en, this message translates to:
  /// **'Related FAQ'**
  String get relatedFAQ;

  /// Localized string for report
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get report;

  /// Localized string for reportAI
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get reportAI;

  /// Localized string for reportAIDescription
  ///
  /// In en, this message translates to:
  /// **'If the AI made you uncomfortable, please describe the issue.'**
  String get reportAIDescription;

  /// Localized string for reportAITitle
  ///
  /// In en, this message translates to:
  /// **'Report AI Conversation'**
  String get reportAITitle;

  /// Localized string for reportAndBlock
  ///
  /// In en, this message translates to:
  /// **'Report & Block'**
  String get reportAndBlock;

  /// Localized string for reportAndBlockDescription
  ///
  /// In en, this message translates to:
  /// **'You can report and block inappropriate behavior of this AI'**
  String get reportAndBlockDescription;

  /// Localized string for reportChatError
  ///
  /// In en, this message translates to:
  /// **'Report Chat Error'**
  String get reportChatError;

  /// Report error message
  ///
  /// In en, this message translates to:
  /// **'Error occurred while reporting: {error}'**
  String reportError(String error);

  /// Localized string for reportFailed
  ///
  /// In en, this message translates to:
  /// **'Report failed'**
  String get reportFailed;

  /// Localized string for reportSubmitted
  ///
  /// In en, this message translates to:
  /// **'Report submitted. We will review and take action.'**
  String get reportSubmitted;

  /// Localized string for reportSubmittedSuccess
  ///
  /// In en, this message translates to:
  /// **'Your report has been submitted. Thank you!'**
  String get reportSubmittedSuccess;

  /// Localized string for requestLimit
  ///
  /// In en, this message translates to:
  /// **'Request Limit'**
  String get requestLimit;

  /// Localized string for required
  ///
  /// In en, this message translates to:
  /// **'[Required]'**
  String get required;

  /// Localized string for requiredTermsAgreement
  ///
  /// In en, this message translates to:
  /// **'Please agree to the terms'**
  String get requiredTermsAgreement;

  /// Localized string for restartConversation
  ///
  /// In en, this message translates to:
  /// **'Restart Conversation'**
  String get restartConversation;

  /// Restart conversation question
  ///
  /// In en, this message translates to:
  /// **'Would you like to restart the conversation with {name}?'**
  String restartConversationQuestion(String name);

  /// Restarting conversation message
  ///
  /// In en, this message translates to:
  /// **'Restarting conversation with {name}!'**
  String restartConversationWithName(String name);

  /// Localized string for retry
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// Localized string for retryButton
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retryButton;

  /// Localized string for sad
  ///
  /// In en, this message translates to:
  /// **'Sad'**
  String get sad;

  /// Localized string for saturday
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get saturday;

  /// Localized string for save
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Localized string for search
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// Localized string for searchFAQ
  ///
  /// In en, this message translates to:
  /// **'Search FAQ...'**
  String get searchFAQ;

  /// Localized string for searchResults
  ///
  /// In en, this message translates to:
  /// **'Search Results'**
  String get searchResults;

  /// Localized string for selectEmotion
  ///
  /// In en, this message translates to:
  /// **'Select Emotion'**
  String get selectEmotion;

  /// Localized string for selectErrorType
  ///
  /// In en, this message translates to:
  /// **'Select error type'**
  String get selectErrorType;

  /// Localized string for selectFeeling
  ///
  /// In en, this message translates to:
  /// **'Select Feeling'**
  String get selectFeeling;

  /// Localized string for selectGender
  ///
  /// In en, this message translates to:
  /// **'Please select gender'**
  String get selectGender;

  /// Localized string for selectInterests
  ///
  /// In en, this message translates to:
  /// **'Please select your interests (at least 1)'**
  String get selectInterests;

  /// Localized string for selectLanguage
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// Localized string for selectPersona
  ///
  /// In en, this message translates to:
  /// **'Select a persona'**
  String get selectPersona;

  /// Localized string for selectPersonaPlease
  ///
  /// In en, this message translates to:
  /// **'Please select a persona.'**
  String get selectPersonaPlease;

  /// Localized string for selectPreferredMbti
  ///
  /// In en, this message translates to:
  /// **'If you prefer personas with specific MBTI types, please select'**
  String get selectPreferredMbti;

  /// Localized string for selectProblematicMessage
  ///
  /// In en, this message translates to:
  /// **'Select the problematic message (optional)'**
  String get selectProblematicMessage;

  /// Information about chat error analysis
  ///
  /// In en, this message translates to:
  /// **'Analyzing the last 10 conversations.'**
  String get chatErrorAnalysisInfo;

  /// Question asking what was awkward in the chat
  ///
  /// In en, this message translates to:
  /// **'What seemed awkward?'**
  String get whatWasAwkward;

  /// Example hint for error description
  ///
  /// In en, this message translates to:
  /// **'e.g., Strange speech patterns (~nya expressions), awkward responses, repetitive answers, etc.'**
  String get errorExampleHint;

  /// Localized string for selectReportReason
  ///
  /// In en, this message translates to:
  /// **'Select report reason'**
  String get selectReportReason;

  /// Localized string for selectTheme
  ///
  /// In en, this message translates to:
  /// **'Select Theme'**
  String get selectTheme;

  /// Localized string for selectTranslationError
  ///
  /// In en, this message translates to:
  /// **'Please select a message with translation error'**
  String get selectTranslationError;

  /// Localized string for selectUsagePurpose
  ///
  /// In en, this message translates to:
  /// **'Please select your purpose for using SONA'**
  String get selectUsagePurpose;

  /// Localized string for selfIntroduction
  ///
  /// In en, this message translates to:
  /// **'Introduction (Optional)'**
  String get selfIntroduction;

  /// Localized string for selfIntroductionHint
  ///
  /// In en, this message translates to:
  /// **'Write a brief introduction about yourself'**
  String get selfIntroductionHint;

  /// Localized string for send
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// Localized string for sendChatError
  ///
  /// In en, this message translates to:
  /// **'Send Chat Error'**
  String get sendChatError;

  /// Localized string for sendFirstMessage
  ///
  /// In en, this message translates to:
  /// **'Send your first message'**
  String get sendFirstMessage;

  /// Localized string for sendReport
  ///
  /// In en, this message translates to:
  /// **'Send Report'**
  String get sendReport;

  /// Localized string for sendingEmail
  ///
  /// In en, this message translates to:
  /// **'Sending email...'**
  String get sendingEmail;

  /// Localized string for seoul
  ///
  /// In en, this message translates to:
  /// **'Seoul'**
  String get seoul;

  /// Localized string for serverErrorDashboard
  ///
  /// In en, this message translates to:
  /// **'Server Error'**
  String get serverErrorDashboard;

  /// Localized string for serviceTermsAgreement
  ///
  /// In en, this message translates to:
  /// **'Please agree to the terms of service'**
  String get serviceTermsAgreement;

  /// Localized string for sessionExpired
  ///
  /// In en, this message translates to:
  /// **'Session expired'**
  String get sessionExpired;

  /// Localized string for setAppInterfaceLanguage
  ///
  /// In en, this message translates to:
  /// **'Set app interface language'**
  String get setAppInterfaceLanguage;

  /// Localized string for setNow
  ///
  /// In en, this message translates to:
  /// **'Set Now'**
  String get setNow;

  /// Localized string for settings
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Localized string for sexualContent
  ///
  /// In en, this message translates to:
  /// **'Sexual content'**
  String get sexualContent;

  /// Localized string for showAllGenderPersonas
  ///
  /// In en, this message translates to:
  /// **'Show All Gender Personas'**
  String get showAllGenderPersonas;

  /// Localized string for showAllGendersOption
  ///
  /// In en, this message translates to:
  /// **'Show All Genders'**
  String get showAllGendersOption;

  /// Localized string for showOppositeGenderOnly
  ///
  /// In en, this message translates to:
  /// **'If unchecked, only opposite gender personas will be shown'**
  String get showOppositeGenderOnly;

  /// Localized string for showOriginalText
  ///
  /// In en, this message translates to:
  /// **'Show Original'**
  String get showOriginalText;

  /// Localized string for signUp
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// Localized string for signUpFromGuest
  ///
  /// In en, this message translates to:
  /// **'Sign up now to access all features!'**
  String get signUpFromGuest;

  /// Localized string for signup
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signup;

  /// Localized string for signupComplete
  ///
  /// In en, this message translates to:
  /// **'Sign Up Complete'**
  String get signupComplete;

  /// Localized string for signupTab
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signupTab;

  /// Localized string for simpleInfoRequired
  ///
  /// In en, this message translates to:
  /// **'Simple information is required\nfor matching with AI personas'**
  String get simpleInfoRequired;

  /// Localized string for skip
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// Localized string for sonaFriend
  ///
  /// In en, this message translates to:
  /// **'SONA Friend'**
  String get sonaFriend;

  /// Localized string for sonaPrivacyPolicy
  ///
  /// In en, this message translates to:
  /// **'SONA Privacy Policy'**
  String get sonaPrivacyPolicy;

  /// Localized string for sonaPurchasePolicy
  ///
  /// In en, this message translates to:
  /// **'SONA Purchase Policy'**
  String get sonaPurchasePolicy;

  /// Localized string for sonaTermsOfService
  ///
  /// In en, this message translates to:
  /// **'SONA Terms of Service'**
  String get sonaTermsOfService;

  /// Localized string for sonaUsagePurpose
  ///
  /// In en, this message translates to:
  /// **'Please select your purpose for using SONA'**
  String get sonaUsagePurpose;

  /// Localized string for sorryNotHelpful
  ///
  /// In en, this message translates to:
  /// **'Sorry this wasn\'t helpful'**
  String get sorryNotHelpful;

  /// Localized string for sort
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get sort;

  /// Localized string for soundSettings
  ///
  /// In en, this message translates to:
  /// **'Sound Settings'**
  String get soundSettings;

  /// Localized string for spamAdvertising
  ///
  /// In en, this message translates to:
  /// **'Spam/Advertising'**
  String get spamAdvertising;

  /// Localized string for spanish
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get spanish;

  /// Localized string for specialRelationshipDesc
  ///
  /// In en, this message translates to:
  /// **'Understand each other and build deep bonds'**
  String get specialRelationshipDesc;

  /// Localized string for sports
  ///
  /// In en, this message translates to:
  /// **'Sports'**
  String get sports;

  /// Localized string for spring
  ///
  /// In en, this message translates to:
  /// **'Spring'**
  String get spring;

  /// Localized string for startChat
  ///
  /// In en, this message translates to:
  /// **'Start Chat'**
  String get startChat;

  /// Localized string for startChatButton
  ///
  /// In en, this message translates to:
  /// **'Start Chat'**
  String get startChatButton;

  /// Localized string for startConversation
  ///
  /// In en, this message translates to:
  /// **'Start a conversation'**
  String get startConversation;

  /// Localized string for startConversationLikeAFriend
  ///
  /// In en, this message translates to:
  /// **'Start a conversation with Sona like a friend'**
  String get startConversationLikeAFriend;

  /// Localized string for startConversationStep
  ///
  /// In en, this message translates to:
  /// **'2. Start Conversation: Chat freely with matched personas.'**
  String get startConversationStep;

  /// Localized string for startConversationWithSona
  ///
  /// In en, this message translates to:
  /// **'Start chatting with Sona like a friend!'**
  String get startConversationWithSona;

  /// Localized string for startWithEmail
  ///
  /// In en, this message translates to:
  /// **'Start with Email'**
  String get startWithEmail;

  /// Localized string for startWithGoogle
  ///
  /// In en, this message translates to:
  /// **'Start with Google'**
  String get startWithGoogle;

  /// Localized string for startingApp
  ///
  /// In en, this message translates to:
  /// **'Starting app'**
  String get startingApp;

  /// Localized string for storageManagement
  ///
  /// In en, this message translates to:
  /// **'Storage Management'**
  String get storageManagement;

  /// Localized string for store
  ///
  /// In en, this message translates to:
  /// **'Store'**
  String get store;

  /// Localized string for storeConnectionError
  ///
  /// In en, this message translates to:
  /// **'Could not connect to store'**
  String get storeConnectionError;

  /// Localized string for storeLoginRequiredMessage
  ///
  /// In en, this message translates to:
  /// **'Login is required to use the store.\nWould you like to go to the login screen?'**
  String get storeLoginRequiredMessage;

  /// Localized string for storeNotAvailable
  ///
  /// In en, this message translates to:
  /// **'Store is not available'**
  String get storeNotAvailable;

  /// Localized string for storyEvent
  ///
  /// In en, this message translates to:
  /// **'Story Event'**
  String get storyEvent;

  /// Localized string for stressed
  ///
  /// In en, this message translates to:
  /// **'Stressed'**
  String get stressed;

  /// Localized string for submitReport
  ///
  /// In en, this message translates to:
  /// **'Submit Report'**
  String get submitReport;

  /// Localized string for subscriptionStatus
  ///
  /// In en, this message translates to:
  /// **'Subscription Status'**
  String get subscriptionStatus;

  /// Localized string for subtleVibrationOnTouch
  ///
  /// In en, this message translates to:
  /// **'Subtle vibration on touch'**
  String get subtleVibrationOnTouch;

  /// Localized string for summer
  ///
  /// In en, this message translates to:
  /// **'Summer'**
  String get summer;

  /// Localized string for sunday
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get sunday;

  /// Localized string for swipeAnyDirection
  ///
  /// In en, this message translates to:
  /// **'Swipe in any direction'**
  String get swipeAnyDirection;

  /// Localized string for swipeDownToClose
  ///
  /// In en, this message translates to:
  /// **'Swipe down to close'**
  String get swipeDownToClose;

  /// Localized string for systemTheme
  ///
  /// In en, this message translates to:
  /// **'Follow System'**
  String get systemTheme;

  /// Localized string for systemThemeDesc
  ///
  /// In en, this message translates to:
  /// **'Automatically changes based on device dark mode settings'**
  String get systemThemeDesc;

  /// Localized string for tapBottomForDetails
  ///
  /// In en, this message translates to:
  /// **'Tap bottom area to see details'**
  String get tapBottomForDetails;

  /// Localized string for tapForDetails
  ///
  /// In en, this message translates to:
  /// **'Tap bottom area for details'**
  String get tapForDetails;

  /// Localized string for tapToSwipePhotos
  ///
  /// In en, this message translates to:
  /// **'Tap to swipe photos'**
  String get tapToSwipePhotos;

  /// Localized string for teachersDay
  ///
  /// In en, this message translates to:
  /// **'Teachers\' Day'**
  String get teachersDay;

  /// Localized string for technicalError
  ///
  /// In en, this message translates to:
  /// **'Technical Error'**
  String get technicalError;

  /// Localized string for technology
  ///
  /// In en, this message translates to:
  /// **'Technology'**
  String get technology;

  /// Localized string for terms
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get terms;

  /// Localized string for termsAgreement
  ///
  /// In en, this message translates to:
  /// **'Terms Agreement'**
  String get termsAgreement;

  /// Localized string for termsAgreementDescription
  ///
  /// In en, this message translates to:
  /// **'Please agree to the terms for using the service'**
  String get termsAgreementDescription;

  /// Localized string for termsOfService
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// Localized string for termsSection10Content
  ///
  /// In en, this message translates to:
  /// **'We reserve the right to modify these terms at any time with notice to users.'**
  String get termsSection10Content;

  /// Localized string for termsSection10Title
  ///
  /// In en, this message translates to:
  /// **'Article 10 (Dispute Resolution)'**
  String get termsSection10Title;

  /// Localized string for termsSection11Content
  ///
  /// In en, this message translates to:
  /// **'These terms shall be governed by the laws of the jurisdiction in which we operate.'**
  String get termsSection11Content;

  /// Localized string for termsSection11Title
  ///
  /// In en, this message translates to:
  /// **'Article 11 (AI Service Special Provisions)'**
  String get termsSection11Title;

  /// Localized string for termsSection12Content
  ///
  /// In en, this message translates to:
  /// **'If any provision of these terms is found to be unenforceable, the remaining provisions shall continue in full force and effect.'**
  String get termsSection12Content;

  /// Localized string for termsSection12Title
  ///
  /// In en, this message translates to:
  /// **'Article 12 (Data Collection and Usage)'**
  String get termsSection12Title;

  /// Localized string for termsSection1Content
  ///
  /// In en, this message translates to:
  /// **'These terms and conditions aim to define the rights, obligations, and responsibilities between SONA (hereinafter \"Company\") and users regarding the use of the AI persona conversation matching service (hereinafter \"Service\") provided by the Company.'**
  String get termsSection1Content;

  /// Localized string for termsSection1Title
  ///
  /// In en, this message translates to:
  /// **'Article 1 (Purpose)'**
  String get termsSection1Title;

  /// Localized string for termsSection2Content
  ///
  /// In en, this message translates to:
  /// **'By using our service, you agree to be bound by these Terms of Service and our Privacy Policy.'**
  String get termsSection2Content;

  /// Localized string for termsSection2Title
  ///
  /// In en, this message translates to:
  /// **'Article 2 (Definitions)'**
  String get termsSection2Title;

  /// Localized string for termsSection3Content
  ///
  /// In en, this message translates to:
  /// **'You must be at least 13 years old to use our service.'**
  String get termsSection3Content;

  /// Localized string for termsSection3Title
  ///
  /// In en, this message translates to:
  /// **'Article 3 (Effect and Modification of Terms)'**
  String get termsSection3Title;

  /// Localized string for termsSection4Content
  ///
  /// In en, this message translates to:
  /// **'You are responsible for maintaining the confidentiality of your account and password.'**
  String get termsSection4Content;

  /// Localized string for termsSection4Title
  ///
  /// In en, this message translates to:
  /// **'Article 4 (Provision of Service)'**
  String get termsSection4Title;

  /// Localized string for termsSection5Content
  ///
  /// In en, this message translates to:
  /// **'You agree not to use our service for any illegal or unauthorized purpose.'**
  String get termsSection5Content;

  /// Localized string for termsSection5Title
  ///
  /// In en, this message translates to:
  /// **'Article 5 (Membership Registration)'**
  String get termsSection5Title;

  /// Localized string for termsSection6Content
  ///
  /// In en, this message translates to:
  /// **'We reserve the right to terminate or suspend your account for violation of these terms.'**
  String get termsSection6Content;

  /// Localized string for termsSection6Title
  ///
  /// In en, this message translates to:
  /// **'Article 6 (User Obligations)'**
  String get termsSection6Title;

  /// Localized string for termsSection7Content
  ///
  /// In en, this message translates to:
  /// **'The Company may gradually restrict service usage through warnings, temporary suspension, or permanent suspension if users violate the obligations of these terms or interfere with normal service operations.'**
  String get termsSection7Content;

  /// Localized string for termsSection7Title
  ///
  /// In en, this message translates to:
  /// **'Article 7 (Service Usage Restrictions)'**
  String get termsSection7Title;

  /// Localized string for termsSection8Content
  ///
  /// In en, this message translates to:
  /// **'We are not liable for any indirect, incidental, or consequential damages arising from your use of our service.'**
  String get termsSection8Content;

  /// Localized string for termsSection8Title
  ///
  /// In en, this message translates to:
  /// **'Article 8 (Service Interruption)'**
  String get termsSection8Title;

  /// Localized string for termsSection9Content
  ///
  /// In en, this message translates to:
  /// **'All content and materials available on our service are protected by intellectual property rights.'**
  String get termsSection9Content;

  /// Localized string for termsSection9Title
  ///
  /// In en, this message translates to:
  /// **'Article 9 (Disclaimer)'**
  String get termsSection9Title;

  /// Localized string for termsSupplementary
  ///
  /// In en, this message translates to:
  /// **'Supplementary Terms'**
  String get termsSupplementary;

  /// Localized string for thai
  ///
  /// In en, this message translates to:
  /// **'Thai'**
  String get thai;

  /// Localized string for thanksFeedback
  ///
  /// In en, this message translates to:
  /// **'Thanks for your feedback!'**
  String get thanksFeedback;

  /// Localized string for theme
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// Localized string for themeDescription
  ///
  /// In en, this message translates to:
  /// **'You can customize the app appearance as you like'**
  String get themeDescription;

  /// Localized string for themeSettings
  ///
  /// In en, this message translates to:
  /// **'Theme Settings'**
  String get themeSettings;

  /// Localized string for thursday
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get thursday;

  /// Localized string for timeout
  ///
  /// In en, this message translates to:
  /// **'Timeout'**
  String get timeout;

  /// Localized string for tired
  ///
  /// In en, this message translates to:
  /// **'Tired'**
  String get tired;

  /// Localized string for today
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// Localized string for todayChats
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get todayChats;

  /// Localized string for todayText
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get todayText;

  /// Localized string for tomorrowText
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get tomorrowText;

  /// Localized string for totalConsultSessions
  ///
  /// In en, this message translates to:
  /// **'Total Consultation Sessions'**
  String get totalConsultSessions;

  /// Localized string for totalErrorCount
  ///
  /// In en, this message translates to:
  /// **'Total Error Count'**
  String get totalErrorCount;

  /// Localized string for totalLikes
  ///
  /// In en, this message translates to:
  /// **'Total Likes'**
  String get totalLikes;

  /// Localized string for totalOccurrences
  ///
  /// In en, this message translates to:
  /// **'Total {count} occurrences'**
  String totalOccurrences(Object count);

  /// Localized string for totalResponses
  ///
  /// In en, this message translates to:
  /// **'Total Responses'**
  String get totalResponses;

  /// Localized string for translatedFrom
  ///
  /// In en, this message translates to:
  /// **'Translated'**
  String get translatedFrom;

  /// Localized string for translatedText
  ///
  /// In en, this message translates to:
  /// **'Translation'**
  String get translatedText;

  /// Localized string for translationError
  ///
  /// In en, this message translates to:
  /// **'Translation error'**
  String get translationError;

  /// Localized string for translationErrorDescription
  ///
  /// In en, this message translates to:
  /// **'Please report incorrect translations or awkward expressions'**
  String get translationErrorDescription;

  /// Localized string for translationErrorReported
  ///
  /// In en, this message translates to:
  /// **'Translation error reported. Thank you!'**
  String get translationErrorReported;

  /// Localized string for translationNote
  ///
  /// In en, this message translates to:
  /// **'※ AI translation may not be perfect'**
  String get translationNote;

  /// Localized string for translationQuality
  ///
  /// In en, this message translates to:
  /// **'Translation Quality'**
  String get translationQuality;

  /// Localized string for translationSettings
  ///
  /// In en, this message translates to:
  /// **'Translation Settings'**
  String get translationSettings;

  /// Localized string for travel
  ///
  /// In en, this message translates to:
  /// **'Travel'**
  String get travel;

  /// Localized string for tuesday
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get tuesday;

  /// Localized string for tutorialAccount
  ///
  /// In en, this message translates to:
  /// **'Tutorial Account'**
  String get tutorialAccount;

  /// Tutorial: Welcome description
  ///
  /// In en, this message translates to:
  /// **'Create special relationships with AI personas.'**
  String get tutorialWelcomeDescription;

  /// Tutorial: Welcome title
  ///
  /// In en, this message translates to:
  /// **'Welcome to SONA!'**
  String get tutorialWelcomeTitle;

  /// Localized string for typeMessage
  ///
  /// In en, this message translates to:
  /// **'Type a message...'**
  String get typeMessage;

  /// Localized string for unblock
  ///
  /// In en, this message translates to:
  /// **'Unblock'**
  String get unblock;

  /// Localized string for unblockFailed
  ///
  /// In en, this message translates to:
  /// **'Failed to unblock'**
  String get unblockFailed;

  /// Unblock persona confirmation
  ///
  /// In en, this message translates to:
  /// **'Unblock {name}?'**
  String unblockPersonaConfirm(String name);

  /// Localized string for unblockedSuccessfully
  ///
  /// In en, this message translates to:
  /// **'Unblocked successfully'**
  String get unblockedSuccessfully;

  /// Localized string for unexpectedLoginError
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred during login'**
  String get unexpectedLoginError;

  /// Localized string for unknown
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// Localized string for unknownError
  ///
  /// In en, this message translates to:
  /// **'An unknown error occurred'**
  String get unknownError;

  /// Localized string for unlimitedMessages
  ///
  /// In en, this message translates to:
  /// **'Unlimited'**
  String get unlimitedMessages;

  /// Localized string for unsendMessage
  ///
  /// In en, this message translates to:
  /// **'Unsend message'**
  String get unsendMessage;

  /// Localized string for usagePurpose
  ///
  /// In en, this message translates to:
  /// **'Usage Purpose'**
  String get usagePurpose;

  /// Localized string for useOneHeart
  ///
  /// In en, this message translates to:
  /// **'Use 1 Heart'**
  String get useOneHeart;

  /// Localized string for useSystemLanguage
  ///
  /// In en, this message translates to:
  /// **'Use System Language'**
  String get useSystemLanguage;

  /// Localized string for user
  ///
  /// In en, this message translates to:
  /// **'User: '**
  String get user;

  /// Localized string for userMessage
  ///
  /// In en, this message translates to:
  /// **'User Message:'**
  String get userMessage;

  /// Localized string for userNotFound
  ///
  /// In en, this message translates to:
  /// **'User not found'**
  String get userNotFound;

  /// Localized string for valentinesDay
  ///
  /// In en, this message translates to:
  /// **'Valentine\'s Day'**
  String get valentinesDay;

  /// Localized string for verifyingAuth
  ///
  /// In en, this message translates to:
  /// **'Verifying authentication'**
  String get verifyingAuth;

  /// Localized string for version
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// Localized string for vietnamese
  ///
  /// In en, this message translates to:
  /// **'Vietnamese'**
  String get vietnamese;

  /// Localized string for violentContent
  ///
  /// In en, this message translates to:
  /// **'Violent content'**
  String get violentContent;

  /// Localized string for voiceMessage
  ///
  /// In en, this message translates to:
  /// **'🎤 Voice message'**
  String get voiceMessage;

  /// Shows that a persona is waiting to chat
  ///
  /// In en, this message translates to:
  /// **'{name} is waiting to chat.'**
  String waitingForChat(String name);

  /// Localized string for walk
  ///
  /// In en, this message translates to:
  /// **'Walk'**
  String get walk;

  /// Localized string for wasHelpful
  ///
  /// In en, this message translates to:
  /// **'Was this helpful?'**
  String get wasHelpful;

  /// Localized string for weatherClear
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get weatherClear;

  /// Localized string for weatherCloudy
  ///
  /// In en, this message translates to:
  /// **'Cloudy'**
  String get weatherCloudy;

  /// Localized string for weatherContext
  ///
  /// In en, this message translates to:
  /// **'Weather Context'**
  String get weatherContext;

  /// Localized string for weatherContextDesc
  ///
  /// In en, this message translates to:
  /// **'Provide conversation context based on weather'**
  String get weatherContextDesc;

  /// Localized string for weatherDrizzle
  ///
  /// In en, this message translates to:
  /// **'Drizzle'**
  String get weatherDrizzle;

  /// Localized string for weatherFog
  ///
  /// In en, this message translates to:
  /// **'Fog'**
  String get weatherFog;

  /// Localized string for weatherMist
  ///
  /// In en, this message translates to:
  /// **'Mist'**
  String get weatherMist;

  /// Localized string for weatherRain
  ///
  /// In en, this message translates to:
  /// **'Rain'**
  String get weatherRain;

  /// Localized string for weatherRainy
  ///
  /// In en, this message translates to:
  /// **'Rainy'**
  String get weatherRainy;

  /// Localized string for weatherSnow
  ///
  /// In en, this message translates to:
  /// **'Snow'**
  String get weatherSnow;

  /// Localized string for weatherSnowy
  ///
  /// In en, this message translates to:
  /// **'Snowy'**
  String get weatherSnowy;

  /// Localized string for weatherThunderstorm
  ///
  /// In en, this message translates to:
  /// **'Thunderstorm'**
  String get weatherThunderstorm;

  /// Localized string for wednesday
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get wednesday;

  /// Localized string for weekdays
  ///
  /// In en, this message translates to:
  /// **'Sun,Mon,Tue,Wed,Thu,Fri,Sat'**
  String get weekdays;

  /// Localized string for welcomeMessage
  ///
  /// In en, this message translates to:
  /// **'Welcome💕'**
  String get welcomeMessage;

  /// Localized string for whatTopicsToTalk
  ///
  /// In en, this message translates to:
  /// **'What topics would you like to talk about? (Optional)'**
  String get whatTopicsToTalk;

  /// Localized string for whiteDay
  ///
  /// In en, this message translates to:
  /// **'White Day'**
  String get whiteDay;

  /// Localized string for winter
  ///
  /// In en, this message translates to:
  /// **'Winter'**
  String get winter;

  /// Localized string for wrongTranslation
  ///
  /// In en, this message translates to:
  /// **'Wrong Translation'**
  String get wrongTranslation;

  /// Localized string for year
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get year;

  /// Localized string for yearEnd
  ///
  /// In en, this message translates to:
  /// **'Year End'**
  String get yearEnd;

  /// Localized string for yes
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// Localized string for yesterday
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// Localized string for yesterdayChats
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterdayChats;

  /// Localized string for you
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get you;

  /// Loading message for persona data
  ///
  /// In en, this message translates to:
  /// **'Loading persona data'**
  String get loadingPersonaData;

  /// Loading message for checking matched personas
  ///
  /// In en, this message translates to:
  /// **'Checking matched personas'**
  String get checkingMatchedPersonas;

  /// Loading message for preparing images
  ///
  /// In en, this message translates to:
  /// **'Preparing images'**
  String get preparingImages;

  /// Loading message for final preparation
  ///
  /// In en, this message translates to:
  /// **'Final preparation'**
  String get finalPreparation;

  /// Subtitle for edit profile menu item
  ///
  /// In en, this message translates to:
  /// **'Edit gender, birthdate, and introduction'**
  String get editProfileSubtitle;

  /// System theme display name
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get systemThemeName;

  /// Light theme display name
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get lightThemeName;

  /// Dark theme display name
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get darkThemeName;

  /// Menu item to enable always showing translation
  ///
  /// In en, this message translates to:
  /// **'Always Show Translation'**
  String get alwaysShowTranslationOn;

  /// Menu item to disable always showing translation
  ///
  /// In en, this message translates to:
  /// **'Hide Auto Translation'**
  String get alwaysShowTranslationOff;

  /// Information text explaining that selected message and translation will be analyzed
  ///
  /// In en, this message translates to:
  /// **'We will analyze the selected message and its translation.'**
  String get translationErrorAnalysisInfo;

  /// Label asking user to describe translation issue
  ///
  /// In en, this message translates to:
  /// **'What was wrong with the translation?'**
  String get whatWasWrongWithTranslation;

  /// Hint text for translation error description input field
  ///
  /// In en, this message translates to:
  /// **'e.g., Incorrect meaning, unnatural expression, wrong context...'**
  String get translationErrorHint;

  /// Message shown when user tries to submit without selecting a message
  ///
  /// In en, this message translates to:
  /// **'Please select a message first'**
  String get pleaseSelectMessage;

  /// Title for my personas screen
  ///
  /// In en, this message translates to:
  /// **'My Personas'**
  String get myPersonas;

  /// Button text for creating a new persona
  ///
  /// In en, this message translates to:
  /// **'Create Persona'**
  String get createPersona;

  /// Subtitle for basic info step
  ///
  /// In en, this message translates to:
  /// **'Tell us about your persona'**
  String get tellUsAboutYourPersona;

  /// Hint text for persona name input
  ///
  /// In en, this message translates to:
  /// **'Enter persona name'**
  String get enterPersonaName;

  /// Hint text for persona description
  ///
  /// In en, this message translates to:
  /// **'Describe your persona briefly'**
  String get describeYourPersona;

  /// Profile image step title
  ///
  /// In en, this message translates to:
  /// **'Profile Image'**
  String get profileImage;

  /// Subtitle for image upload step
  ///
  /// In en, this message translates to:
  /// **'Upload images for your persona'**
  String get uploadPersonaImages;

  /// Main image label
  ///
  /// In en, this message translates to:
  /// **'Main Image'**
  String get mainImage;

  /// Tap to upload instruction
  ///
  /// In en, this message translates to:
  /// **'Tap to upload'**
  String get tapToUpload;

  /// Additional images label
  ///
  /// In en, this message translates to:
  /// **'Additional Images'**
  String get additionalImages;

  /// Add image button text
  ///
  /// In en, this message translates to:
  /// **'Add Image'**
  String get addImage;

  /// MBTI question header
  ///
  /// In en, this message translates to:
  /// **'Personality Question'**
  String get mbtiQuestion;

  /// MBTI test completion message
  ///
  /// In en, this message translates to:
  /// **'Personality Test Complete!'**
  String get mbtiComplete;

  /// MBTI test step title
  ///
  /// In en, this message translates to:
  /// **'MBTI Test'**
  String get mbtiTest;

  /// Description explaining that MBTI is for the persona's personality, not the user's
  ///
  /// In en, this message translates to:
  /// **'Let\'s determine what personality your persona should have. Answer questions to shape their character.'**
  String get mbtiStepDescription;

  /// Button text to start the MBTI test
  ///
  /// In en, this message translates to:
  /// **'Start Test'**
  String get startTest;

  /// Personality settings step title
  ///
  /// In en, this message translates to:
  /// **'Personality Settings'**
  String get personalitySettings;

  /// Speech style label
  ///
  /// In en, this message translates to:
  /// **'Speech Style'**
  String get speechStyle;

  /// Conversation style label
  ///
  /// In en, this message translates to:
  /// **'Conversation Style'**
  String get conversationStyle;

  /// Share with community title
  ///
  /// In en, this message translates to:
  /// **'Share with Community'**
  String get shareWithCommunity;

  /// Share description text
  ///
  /// In en, this message translates to:
  /// **'Your persona can be shared with other users after approval'**
  String get shareDescription;

  /// Share persona toggle title
  ///
  /// In en, this message translates to:
  /// **'Share Persona'**
  String get sharePersona;

  /// Will be shared after approval message
  ///
  /// In en, this message translates to:
  /// **'Will be shared after admin approval'**
  String get willBeSharedAfterApproval;

  /// Private persona description
  ///
  /// In en, this message translates to:
  /// **'Only you can see this persona'**
  String get privatePersonaDescription;

  /// Create button text
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// Persona created success message
  ///
  /// In en, this message translates to:
  /// **'Persona created successfully!'**
  String get personaCreated;

  /// Create failed error message
  ///
  /// In en, this message translates to:
  /// **'Failed to create persona'**
  String get createFailed;

  /// Pending approval status
  ///
  /// In en, this message translates to:
  /// **'Pending Approval'**
  String get pendingApproval;

  /// Approved status
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get approved;

  /// Private persona label
  ///
  /// In en, this message translates to:
  /// **'Private'**
  String get privatePersona;

  /// Empty state title
  ///
  /// In en, this message translates to:
  /// **'No Personas Yet'**
  String get noPersonasYet;

  /// Empty state description
  ///
  /// In en, this message translates to:
  /// **'Create your first persona and start your journey'**
  String get createYourFirstPersona;

  /// Delete persona dialog title
  ///
  /// In en, this message translates to:
  /// **'Delete Persona'**
  String get deletePersona;

  /// Delete persona confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this persona?'**
  String get deletePersonaConfirm;

  /// Persona deleted success message
  ///
  /// In en, this message translates to:
  /// **'Persona deleted successfully'**
  String get personaDeleted;

  /// Delete failed error message
  ///
  /// In en, this message translates to:
  /// **'Failed to delete persona'**
  String get deleteFailed;

  /// Persona limit reached message
  ///
  /// In en, this message translates to:
  /// **'You have reached the limit of 3 personas'**
  String get personaLimitReached;

  /// Persona name label
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get personaName;

  /// Persona age label
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get personaAge;

  /// Persona description label
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get personaDescription;

  /// Hint text for persona name input
  ///
  /// In en, this message translates to:
  /// **'Enter persona name'**
  String get personaNameHint;

  /// Hint text for persona description input
  ///
  /// In en, this message translates to:
  /// **'Describe the persona'**
  String get personaDescriptionHint;

  /// Content for login required dialog
  ///
  /// In en, this message translates to:
  /// **'Please log in to continue'**
  String get loginRequiredContent;

  /// Button text for report error
  ///
  /// In en, this message translates to:
  /// **'Report Error'**
  String get reportErrorButton;

  /// Friendly speech style option
  ///
  /// In en, this message translates to:
  /// **'Friendly'**
  String get speechStyleFriendly;

  /// Polite speech style option
  ///
  /// In en, this message translates to:
  /// **'Polite'**
  String get speechStylePolite;

  /// Chic speech style option
  ///
  /// In en, this message translates to:
  /// **'Chic'**
  String get speechStyleChic;

  /// Lively speech style option
  ///
  /// In en, this message translates to:
  /// **'Lively'**
  String get speechStyleLively;

  /// Talkative conversation style option
  ///
  /// In en, this message translates to:
  /// **'Talkative'**
  String get conversationStyleTalkative;

  /// Quiet conversation style option
  ///
  /// In en, this message translates to:
  /// **'Quiet'**
  String get conversationStyleQuiet;

  /// Empathetic conversation style option
  ///
  /// In en, this message translates to:
  /// **'Empathetic'**
  String get conversationStyleEmpathetic;

  /// Logical conversation style option
  ///
  /// In en, this message translates to:
  /// **'Logical'**
  String get conversationStyleLogical;

  /// Music interest option
  ///
  /// In en, this message translates to:
  /// **'Music'**
  String get interestMusic;

  /// Movies interest option
  ///
  /// In en, this message translates to:
  /// **'Movies'**
  String get interestMovies;

  /// Reading interest option
  ///
  /// In en, this message translates to:
  /// **'Reading'**
  String get interestReading;

  /// Travel interest option
  ///
  /// In en, this message translates to:
  /// **'Travel'**
  String get interestTravel;

  /// Exercise interest option
  ///
  /// In en, this message translates to:
  /// **'Exercise'**
  String get interestExercise;

  /// Gaming interest option
  ///
  /// In en, this message translates to:
  /// **'Gaming'**
  String get interestGaming;

  /// Cooking interest option
  ///
  /// In en, this message translates to:
  /// **'Cooking'**
  String get interestCooking;

  /// Fashion interest option
  ///
  /// In en, this message translates to:
  /// **'Fashion'**
  String get interestFashion;

  /// Art interest option
  ///
  /// In en, this message translates to:
  /// **'Art'**
  String get interestArt;

  /// Photography interest option
  ///
  /// In en, this message translates to:
  /// **'Photography'**
  String get interestPhotography;

  /// Technology interest option
  ///
  /// In en, this message translates to:
  /// **'Technology'**
  String get interestTechnology;

  /// Science interest option
  ///
  /// In en, this message translates to:
  /// **'Science'**
  String get interestScience;

  /// History interest option
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get interestHistory;

  /// Philosophy interest option
  ///
  /// In en, this message translates to:
  /// **'Philosophy'**
  String get interestPhilosophy;

  /// Politics interest option
  ///
  /// In en, this message translates to:
  /// **'Politics'**
  String get interestPolitics;

  /// Economy interest option
  ///
  /// In en, this message translates to:
  /// **'Economy'**
  String get interestEconomy;

  /// Sports interest option
  ///
  /// In en, this message translates to:
  /// **'Sports'**
  String get interestSports;

  /// Animation interest option
  ///
  /// In en, this message translates to:
  /// **'Animation'**
  String get interestAnimation;

  /// K-POP interest option
  ///
  /// In en, this message translates to:
  /// **'K-POP'**
  String get interestKpop;

  /// Drama interest option
  ///
  /// In en, this message translates to:
  /// **'Drama'**
  String get interestDrama;

  /// Message explaining that images are optional and require R2
  ///
  /// In en, this message translates to:
  /// **'Images are optional. They will only be uploaded if R2 is configured.'**
  String get imageOptionalR2;

  /// Network error message
  ///
  /// In en, this message translates to:
  /// **'Network error: Please check your internet connection'**
  String get networkErrorCheckConnection;

  /// Maximum 5 items message
  ///
  /// In en, this message translates to:
  /// **'Up to 5 items'**
  String get maxFiveItems;

  /// Mbtiquestion1
  ///
  /// In en, this message translates to:
  /// **'When meeting new people'**
  String get mbtiQuestion1;

  /// Mbtiquestion1Optiona
  ///
  /// In en, this message translates to:
  /// **'Hello... nice to meet you'**
  String get mbtiQuestion1OptionA;

  /// Mbtiquestion1Optionb
  ///
  /// In en, this message translates to:
  /// **'Oh! Nice to meet you! I\'m XX!'**
  String get mbtiQuestion1OptionB;

  /// Mbtiquestion2
  ///
  /// In en, this message translates to:
  /// **'When understanding a situation'**
  String get mbtiQuestion2;

  /// Mbtiquestion2Optiona
  ///
  /// In en, this message translates to:
  /// **'What exactly happened and how?'**
  String get mbtiQuestion2OptionA;

  /// Mbtiquestion2Optionb
  ///
  /// In en, this message translates to:
  /// **'I think I get the general feeling'**
  String get mbtiQuestion2OptionB;

  /// Mbtiquestion3
  ///
  /// In en, this message translates to:
  /// **'When making decisions'**
  String get mbtiQuestion3;

  /// Mbtiquestion3Optiona
  ///
  /// In en, this message translates to:
  /// **'Thinking logically...'**
  String get mbtiQuestion3OptionA;

  /// Mbtiquestion3Optionb
  ///
  /// In en, this message translates to:
  /// **'Your feelings matter more'**
  String get mbtiQuestion3OptionB;

  /// Mbtiquestion4
  ///
  /// In en, this message translates to:
  /// **'When making appointments'**
  String get mbtiQuestion4;

  /// Mbtiquestion4Optiona
  ///
  /// In en, this message translates to:
  /// **'Let\'s meet exactly at X o\'clock'**
  String get mbtiQuestion4OptionA;

  /// Mbtiquestion4Optionb
  ///
  /// In en, this message translates to:
  /// **'See you around that time~'**
  String get mbtiQuestion4OptionB;

  /// Meetnewsona
  ///
  /// In en, this message translates to:
  /// **'Meet new Sona!'**
  String get meetNewSona;

  /// Ageandpersonality
  ///
  /// In en, this message translates to:
  /// **'{age} years old • {personality}'**
  String ageAndPersonality(String age, String personality);

  /// Guestlabel
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get guestLabel;

  /// Developeroptions
  ///
  /// In en, this message translates to:
  /// **'Developer Options'**
  String get developerOptions;

  /// Reengagementnotificationtest
  ///
  /// In en, this message translates to:
  /// **'Re-engagement Notification Test'**
  String get reengagementNotificationTest;

  /// Churnrisknotificationtest
  ///
  /// In en, this message translates to:
  /// **'Churn Risk Notification Test'**
  String get churnRiskNotificationTest;

  /// Selectchurnrisk
  ///
  /// In en, this message translates to:
  /// **'Select churn risk:'**
  String get selectChurnRisk;

  /// Sevendaysinactive
  ///
  /// In en, this message translates to:
  /// **'7+ days inactive (90% risk)'**
  String get sevenDaysInactive;

  /// Threedaysinactive
  ///
  /// In en, this message translates to:
  /// **'3 days inactive (70% risk)'**
  String get threeDaysInactive;

  /// Onedayinactive
  ///
  /// In en, this message translates to:
  /// **'1 day inactive (50% risk)'**
  String get oneDayInactive;

  /// Generalnotification
  ///
  /// In en, this message translates to:
  /// **'General notification (30% risk)'**
  String get generalNotification;

  /// Noactivepersonas
  ///
  /// In en, this message translates to:
  /// **'No active personas'**
  String get noActivePersonas;

  /// Percentdiscount
  ///
  /// In en, this message translates to:
  /// **'{percent}% OFF'**
  String percentDiscount(String percent);

  /// Imageloadprogress
  ///
  /// In en, this message translates to:
  /// **'{loaded} / {total} images'**
  String imageLoadProgress(String loaded, String total);

  /// Checkingnewimages
  ///
  /// In en, this message translates to:
  /// **'Checking for new images...'**
  String get checkingNewImages;

  /// Findingnewpersonas
  ///
  /// In en, this message translates to:
  /// **'Finding new personas...'**
  String get findingNewPersonas;

  /// Superlikematch
  ///
  /// In en, this message translates to:
  /// **'Super Like Match!'**
  String get superLikeMatch;

  /// Matchsuccess
  ///
  /// In en, this message translates to:
  /// **'Match Success!'**
  String get matchSuccess;

  /// Restartingconversationwith
  ///
  /// In en, this message translates to:
  /// **'Restarting conversation with {name}!'**
  String restartingConversationWith(String name);

  /// Personalikesyou
  ///
  /// In en, this message translates to:
  /// **'{name} especially likes you!'**
  String personaLikesYou(String name);

  /// Matchedwithpersona
  ///
  /// In en, this message translates to:
  /// **'Matched with {name}!'**
  String matchedWithPersona(String name);

  /// Previousconversationkept
  ///
  /// In en, this message translates to:
  /// **'Previous conversation is preserved. Continue where you left off!'**
  String get previousConversationKept;

  /// Specialconnectionstart
  ///
  /// In en, this message translates to:
  /// **'Start of a special connection! Sona is waiting for you'**
  String get specialConnectionStart;

  /// Preparingprofilepicture
  ///
  /// In en, this message translates to:
  /// **'Preparing profile picture...'**
  String get preparingProfilePicture;

  /// Newsonacomingsoon
  ///
  /// In en, this message translates to:
  /// **'New Sona coming soon!'**
  String get newSonaComingSoon;

  /// Superlikedescription
  ///
  /// In en, this message translates to:
  /// **'Super Like (instant love stage)'**
  String get superLikeDescription;

  /// Checkingmorepersonas
  ///
  /// In en, this message translates to:
  /// **'Checking more personas...'**
  String get checkingMorePersonas;

  /// Allfilter
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get allFilter;

  /// Published
  ///
  /// In en, this message translates to:
  /// **'Published'**
  String get published;

  /// Yearsold
  ///
  /// In en, this message translates to:
  /// **'{age} years old'**
  String yearsOld(String age);

  /// Startconversationwithpersona
  ///
  /// In en, this message translates to:
  /// **'Start conversation with {name}?'**
  String startConversationWithPersona(String name);

  /// Failedtostartconversation
  ///
  /// In en, this message translates to:
  /// **'Failed to start conversation'**
  String get failedToStartConversation;

  /// Cannotdeleteapprovedpersona
  ///
  /// In en, this message translates to:
  /// **'Cannot delete approved persona'**
  String get cannotDeleteApprovedPersona;

  /// Deletepersonawithconversation
  ///
  /// In en, this message translates to:
  /// **'This persona has an active conversation. Delete anyway?\nThe chat room will also be deleted.'**
  String get deletePersonaWithConversation;

  /// Sharedpersonadeletewarning
  ///
  /// In en, this message translates to:
  /// **'This is a shared persona. It will only be removed from your list.'**
  String get sharedPersonaDeleteWarning;

  /// Firebasepermissionerror
  ///
  /// In en, this message translates to:
  /// **'Firebase permission error: Please contact administrator'**
  String get firebasePermissionError;

  /// Checkingpersonainfo
  ///
  /// In en, this message translates to:
  /// **'Checking persona information...'**
  String get checkingPersonaInfo;

  /// Personacachedescription
  ///
  /// In en, this message translates to:
  /// **'Persona images are saved on device for fast loading.'**
  String get personaCacheDescription;

  /// Cachedeletewarning
  ///
  /// In en, this message translates to:
  /// **'Deleting cache will require re-downloading images.'**
  String get cacheDeleteWarning;

  /// Blockedaidescription
  ///
  /// In en, this message translates to:
  /// **'Blocked AI will be excluded from matching and chat list.'**
  String get blockedAIDescription;

  /// Searchresultscount
  ///
  /// In en, this message translates to:
  /// **'Search results: {count}'**
  String searchResultsCount(String count);

  /// Questionscount
  ///
  /// In en, this message translates to:
  /// **'{count} questions'**
  String questionsCount(String count);

  /// Readytochat
  ///
  /// In en, this message translates to:
  /// **'Ready to chat!'**
  String get readyToChat;

  /// Preparingpersonascount
  ///
  /// In en, this message translates to:
  /// **'Preparing personas... ({count})'**
  String preparingPersonasCount(String count);

  /// Loggingin
  ///
  /// In en, this message translates to:
  /// **'Logging in...'**
  String get loggingIn;

  /// Languagechangedto
  ///
  /// In en, this message translates to:
  /// **'Language changed to {language}'**
  String languageChangedTo(String language);

  /// Englishlanguage
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get englishLanguage;

  /// Japaneselanguage
  ///
  /// In en, this message translates to:
  /// **'Japanese'**
  String get japaneseLanguage;

  /// Chineselanguage
  ///
  /// In en, this message translates to:
  /// **'Chinese'**
  String get chineseLanguage;

  /// Thailanguage
  ///
  /// In en, this message translates to:
  /// **'Thai'**
  String get thaiLanguage;

  /// Vietnameselanguage
  ///
  /// In en, this message translates to:
  /// **'Vietnamese'**
  String get vietnameseLanguage;

  /// Indonesianlanguage
  ///
  /// In en, this message translates to:
  /// **'Indonesian'**
  String get indonesianLanguage;

  /// Tagaloglanguage
  ///
  /// In en, this message translates to:
  /// **'Tagalog'**
  String get tagalogLanguage;

  /// Spanishlanguage
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get spanishLanguage;

  /// Frenchlanguage
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get frenchLanguage;

  /// Germanlanguage
  ///
  /// In en, this message translates to:
  /// **'German'**
  String get germanLanguage;

  /// Russianlanguage
  ///
  /// In en, this message translates to:
  /// **'Russian'**
  String get russianLanguage;

  /// Portugueselanguage
  ///
  /// In en, this message translates to:
  /// **'Portuguese'**
  String get portugueseLanguage;

  /// Italianlanguage
  ///
  /// In en, this message translates to:
  /// **'Italian'**
  String get italianLanguage;

  /// Dutchlanguage
  ///
  /// In en, this message translates to:
  /// **'Dutch'**
  String get dutchLanguage;

  /// Swedishlanguage
  ///
  /// In en, this message translates to:
  /// **'Swedish'**
  String get swedishLanguage;

  /// Polishlanguage
  ///
  /// In en, this message translates to:
  /// **'Polish'**
  String get polishLanguage;

  /// Turkishlanguage
  ///
  /// In en, this message translates to:
  /// **'Turkish'**
  String get turkishLanguage;

  /// Arabiclanguage
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabicLanguage;

  /// Hindilanguage
  ///
  /// In en, this message translates to:
  /// **'Hindi'**
  String get hindiLanguage;

  /// Urdulanguage
  ///
  /// In en, this message translates to:
  /// **'Urdu'**
  String get urduLanguage;

  /// Validation message: nameRequired
  ///
  /// In en, this message translates to:
  /// **'Please enter a name'**
  String get nameRequired;

  /// Validation message: ageRequired
  ///
  /// In en, this message translates to:
  /// **'Please enter age'**
  String get ageRequired;

  /// Validation message: descriptionRequired
  ///
  /// In en, this message translates to:
  /// **'Please enter a description'**
  String get descriptionRequired;

  /// Validation message: mbtiIncomplete
  ///
  /// In en, this message translates to:
  /// **'Please complete all MBTI questions'**
  String get mbtiIncomplete;

  /// Validation message: interestsRequired
  ///
  /// In en, this message translates to:
  /// **'Please select at least one interest'**
  String get interestsRequired;

  /// Validation message: mainImageRequired
  ///
  /// In en, this message translates to:
  /// **'Please add a main profile image'**
  String get mainImageRequired;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'ar',
        'de',
        'en',
        'es',
        'fr',
        'hi',
        'id',
        'it',
        'ja',
        'ko',
        'nl',
        'pl',
        'pt',
        'ru',
        'sv',
        'th',
        'tl',
        'tr',
        'ur',
        'vi',
        'zh'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'hi':
      return AppLocalizationsHi();
    case 'id':
      return AppLocalizationsId();
    case 'it':
      return AppLocalizationsIt();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'nl':
      return AppLocalizationsNl();
    case 'pl':
      return AppLocalizationsPl();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
    case 'sv':
      return AppLocalizationsSv();
    case 'th':
      return AppLocalizationsTh();
    case 'tl':
      return AppLocalizationsTl();
    case 'tr':
      return AppLocalizationsTr();
    case 'ur':
      return AppLocalizationsUr();
    case 'vi':
      return AppLocalizationsVi();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
