// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get about => 'O aplikacji';

  @override
  String get accountAndProfile => 'Informacje o koncie i profilu';

  @override
  String get accountDeletedSuccess => 'Konto zostało pomyślnie usunięte';

  @override
  String get accountDeletionContent =>
      'Czy na pewno chcesz usunąć swoje konto?';

  @override
  String get accountDeletionError => 'Wystąpił błąd podczas usuwania konta.';

  @override
  String get accountDeletionInfo => 'Informacje o usunięciu konta';

  @override
  String get accountDeletionTitle => 'Usuń konto';

  @override
  String get accountDeletionWarning1 =>
      'Ostrzeżenie: Ta akcja nie może być cofnięta';

  @override
  String get accountDeletionWarning2 =>
      'Wszystkie Twoje dane zostaną trwale usunięte';

  @override
  String get accountDeletionWarning3 => 'Stracisz dostęp do wszystkich rozmów';

  @override
  String get accountDeletionWarning4 =>
      'Dotyczy to również całej zakupionej zawartości';

  @override
  String get accountManagement => 'Zarządzanie kontem';

  @override
  String get adaptiveConversationDesc => 'Dostosowuje styl rozmowy do Twojego';

  @override
  String get afternoon => 'Popołudnie';

  @override
  String get afternoonFatigue => 'Zmęczenie popołudniowe';

  @override
  String get ageConfirmation => 'Mam 14 lat lub więcej i potwierdzam powyższe.';

  @override
  String ageRange(int min, int max) {
    return '$min-$max lat';
  }

  @override
  String get ageUnit => 'lat';

  @override
  String get agreeToTerms => 'Zgadzam się na warunki';

  @override
  String get aiDatingQuestion => 'Specjalne codzienne życie z AI';

  @override
  String get aiPersonaPreferenceDescription =>
      'Proszę ustawić swoje preferencje dotyczące dopasowania persony AI';

  @override
  String get all => 'Wszystko';

  @override
  String get allAgree => 'Zgadzam się na wszystko';

  @override
  String get allFeaturesRequired =>
      '※ Wszystkie funkcje są wymagane do świadczenia usługi';

  @override
  String get allPersonas => 'Wszystkie persony';

  @override
  String get allPersonasMatched =>
      'Wszystkie persony dopasowane! Zacznij z nimi rozmawiać.';

  @override
  String get allowPermission => 'Kontynuuj';

  @override
  String alreadyChattingWith(String name) {
    return 'Już rozmawiasz z $name!';
  }

  @override
  String get alsoBlockThisAI => 'Zablokuj też tego AI';

  @override
  String get angry => 'Zły';

  @override
  String get anonymousLogin => 'Logowanie anonimowe';

  @override
  String get anxious => 'Zaniepokojony';

  @override
  String get apiKeyError => 'Błąd klucza API';

  @override
  String get appName => 'SONA';

  @override
  String get appTagline => 'Twoi towarzysze AI';

  @override
  String get appleLoginCanceled =>
      'Logowanie przez Apple zostało anulowane. Spróbuj ponownie.';

  @override
  String get appleLoginError => 'Wystąpił błąd podczas logowania przez Apple.';

  @override
  String get art => 'Sztuka';

  @override
  String get authError => 'Błąd uwierzytelnienia';

  @override
  String get autoTranslate => 'Automatyczne tłumaczenie';

  @override
  String get autumn => 'Jesień';

  @override
  String get averageQuality => 'Średnia jakość';

  @override
  String get averageQualityScore => 'Wynik średniej jakości';

  @override
  String get awkwardExpression => 'Niezręczne wyrażenie';

  @override
  String get backButton => 'Wstecz';

  @override
  String get basicInfo => 'Podstawowe informacje';

  @override
  String get basicInfoDescription =>
      'Proszę wprowadzić podstawowe informacje, aby utworzyć konto';

  @override
  String get birthDate => 'Data urodzenia';

  @override
  String get birthDateOptional => 'Data urodzenia (opcjonalnie)';

  @override
  String get birthDateRequired => 'Data urodzenia *';

  @override
  String get blockConfirm => 'Czy chcesz zablokować tę AI?';

  @override
  String get blockReason => 'Powód blokady';

  @override
  String get blockThisAI => 'Zablokuj tego AI';

  @override
  String blockedAICount(int count) {
    return '$count zablokowanych AI';
  }

  @override
  String get blockedAIs => 'Zablokowane AI';

  @override
  String get blockedAt => 'Zablokowane o';

  @override
  String get blockedSuccessfully => 'Pomyślnie zablokowane';

  @override
  String get breakfast => 'Śniadanie';

  @override
  String get byErrorType => 'Według typu błędu';

  @override
  String get byPersona => 'Według persony';

  @override
  String cacheDeleteError(String error) {
    return 'Błąd podczas usuwania pamięci podręcznej: $error';
  }

  @override
  String get cacheDeleted => 'Pamięć podręczna obrazów została usunięta';

  @override
  String get cafeTerrace => 'Taras kawiarni';

  @override
  String get calm => 'Spokój';

  @override
  String get cameraPermission => 'Uprawnienia do aparatu';

  @override
  String get cameraPermissionDesc =>
      'Dostęp do aparatu jest wymagany, aby zrobić zdjęcia profilowe.';

  @override
  String get canChangeInSettings => 'Możesz to zmienić później w ustawieniach';

  @override
  String get canMeetPreviousPersonas => 'Możesz spotkać ponownie persony,';

  @override
  String get cancel => 'Anuluj';

  @override
  String get changeProfilePhoto => 'Zmień zdjęcie profilowe';

  @override
  String get chat => 'Czat';

  @override
  String get chatEndedMessage => 'Czat został zakończony';

  @override
  String get chatErrorDashboard => 'Panel błędów czatu';

  @override
  String get chatErrorSentSuccessfully =>
      'Błąd czatu został pomyślnie wysłany.';

  @override
  String get chatListTab => 'Zakładka czatów';

  @override
  String get chats => 'Czat';

  @override
  String chattingWithPersonas(int count) {
    return 'Rozmowa z $count personami';
  }

  @override
  String get checkInternetConnection =>
      'Proszę sprawdzić połączenie z internetem';

  @override
  String get checkingUserInfo => 'Sprawdzanie informacji o użytkowniku';

  @override
  String get childrensDay => 'Dzień Dziecka';

  @override
  String get chinese => 'Chiński';

  @override
  String get chooseOption => 'Proszę wybrać:';

  @override
  String get christmas => 'Boże Narodzenie';

  @override
  String get close => 'Zamknij';

  @override
  String get complete => 'Zrobione';

  @override
  String get completeSignup => 'Ukończ rejestrację';

  @override
  String get confirm => 'Potwierdź';

  @override
  String get connectingToServer => 'Łączenie z serwerem';

  @override
  String get consultQualityMonitoring => 'Monitorowanie jakości konsultacji';

  @override
  String get continueAsGuest => 'Kontynuuj jako Gość';

  @override
  String get continueButton => 'Kontynuuj';

  @override
  String get continueWithApple => 'Kontynuuj z Apple';

  @override
  String get continueWithGoogle => 'Kontynuuj z Google';

  @override
  String get conversationContinuity => 'Ciągłość rozmowy';

  @override
  String get conversationContinuityDesc =>
      'Zapamiętaj poprzednie rozmowy i połącz tematy';

  @override
  String conversationWith(String name) {
    return '$name';
  }

  @override
  String get convertToMember => 'Zarejestruj się';

  @override
  String get cooking => 'Gotowanie';

  @override
  String get copyMessage => 'Skopiuj wiadomość';

  @override
  String get copyrightInfringement => 'Naruszenie praw autorskich';

  @override
  String get creatingAccount => 'Tworzenie konta';

  @override
  String get crisisDetected => 'Wykryto kryzys';

  @override
  String get culturalIssue => 'Kwestia kulturowa';

  @override
  String get current => 'Bieżący';

  @override
  String get currentCacheSize => 'Bieżący rozmiar pamięci podręcznej';

  @override
  String get currentLanguage => 'Bieżący język';

  @override
  String get cycling => 'Jazda na rowerze';

  @override
  String get dailyCare => 'Codzienna opieka';

  @override
  String get dailyCareDesc =>
      'Codzienne wiadomości dotyczące posiłków, snu, zdrowia';

  @override
  String get dailyChat => 'Codzienna rozmowa';

  @override
  String get dailyCheck => 'Codzienna kontrola';

  @override
  String get dailyConversation => 'Codzienna konwersacja';

  @override
  String get dailyLimitDescription => 'Osiągnąłeś dzienny limit wiadomości';

  @override
  String get dailyLimitTitle => 'Osiągnięto dzienny limit';

  @override
  String get darkMode => 'Tryb ciemny';

  @override
  String get darkTheme => 'Tryb ciemny';

  @override
  String get darkThemeDesc => 'Użyj ciemnego motywu';

  @override
  String get dataCollection => 'Ustawienia zbierania danych';

  @override
  String get datingAdvice => 'Porady dotyczące randek';

  @override
  String get datingDescription =>
      'Chcę dzielić się głębokimi myślami i prowadzić szczere rozmowy';

  @override
  String get dawn => 'Świt';

  @override
  String get day => 'Dzień';

  @override
  String get dayAfterTomorrow => 'Po jutrze';

  @override
  String daysAgo(int count, String formatted) {
    return '$count dni temu';
  }

  @override
  String daysRemaining(int days) {
    return 'Pozostało $days dni';
  }

  @override
  String get deepTalk => 'Głęboka rozmowa';

  @override
  String get delete => 'Usuń';

  @override
  String get deleteAccount => 'Usuń konto';

  @override
  String get deleteAccountConfirm =>
      'Czy na pewno chcesz usunąć swoje konto? Tej operacji nie można cofnąć.';

  @override
  String get deleteAccountWarning => 'Czy na pewno chcesz usunąć swoje konto?';

  @override
  String get deleteCache => 'Usuń pamięć podręczną';

  @override
  String get deletingAccount => 'Usuwanie konta...';

  @override
  String get depressed => 'Przygnębiony';

  @override
  String get describeError => 'Jaki jest problem?';

  @override
  String get detailedReason => 'Szczegółowy powód';

  @override
  String get developRelationshipStep =>
      '3. Rozwijaj relację: Buduj bliskość poprzez rozmowy i rozwijaj wyjątkowe relacje.';

  @override
  String get dinner => 'Kolacja';

  @override
  String get discardGuestData => 'Zaczynamy od nowa';

  @override
  String get discount20 => '20% zniżki';

  @override
  String get discount30 => '30% zniżki';

  @override
  String get discountAmount => 'Oszczędź';

  @override
  String discountAmountValue(String amount) {
    return 'Oszczędź ₩$amount';
  }

  @override
  String get done => 'Gotowe';

  @override
  String get downloadingPersonaImages => 'Pobieranie nowych obrazów persony';

  @override
  String get edit => 'Edytuj';

  @override
  String get editInfo => 'Edytuj informacje';

  @override
  String get editProfile => 'Edytuj profil';

  @override
  String get effectSound => 'Efekty dźwiękowe';

  @override
  String get effectSoundDescription => 'Odtwarzaj efekty dźwiękowe';

  @override
  String get email => 'E-mail';

  @override
  String get emailHint => 'przykład@email.com';

  @override
  String get emailLabel => 'E-mail';

  @override
  String get emailRequired => 'E-mail *';

  @override
  String get emotionAnalysis => 'Analiza emocji';

  @override
  String get emotionAnalysisDesc =>
      'Analizuj emocje, aby uzyskać empatyczne odpowiedzi';

  @override
  String get emotionAngry => 'Zły';

  @override
  String get emotionBasedEncounters =>
      'Spotkaj persony na podstawie swoich emocji';

  @override
  String get emotionCool => 'Fajnie';

  @override
  String get emotionHappy => 'Szczęśliwy';

  @override
  String get emotionLove => 'Miłość';

  @override
  String get emotionSad => 'Smutny';

  @override
  String get emotionThinking => 'Myślę';

  @override
  String get emotionalSupportDesc =>
      'Podziel się swoimi obawami i otrzymaj ciepłe wsparcie';

  @override
  String get endChat => 'Zakończ czat';

  @override
  String get endTutorial => 'Zakończ samouczek';

  @override
  String get endTutorialAndLogin => 'Zakończyć samouczek i zalogować się?';

  @override
  String get endTutorialMessage =>
      'Czy chcesz zakończyć samouczek i się zalogować?';

  @override
  String get english => 'Angielski';

  @override
  String get enterBasicInfo =>
      'Proszę wprowadzić podstawowe informacje, aby utworzyć konto';

  @override
  String get enterBasicInformation => 'Proszę wprowadzić podstawowe informacje';

  @override
  String get enterEmail => 'Proszę wprowadzić adres e-mail';

  @override
  String get enterNickname => 'Proszę wprowadzić pseudonim';

  @override
  String get enterPassword => 'Proszę wprowadzić hasło';

  @override
  String get entertainmentAndFunDesc =>
      'Ciesz się zabawnymi grami i przyjemnymi rozmowami';

  @override
  String get entertainmentDescription =>
      'Chcę prowadzić ciekawe rozmowy i miło spędzać czas';

  @override
  String get entertainmentFun => 'Rozrywka/Zabawa';

  @override
  String get error => 'Błąd';

  @override
  String get errorDescription => 'Opis błędu';

  @override
  String get errorDescriptionHint =>
      'np. Daje dziwne odpowiedzi, Powtarza to samo, Daje kontekstowo niewłaściwe odpowiedzi...';

  @override
  String get errorDetails => 'Szczegóły błędu';

  @override
  String get errorDetailsHint => 'Proszę szczegółowo wyjaśnić, co jest nie tak';

  @override
  String get errorFrequency24h => 'Częstotliwość błędów (Ostatnie 24 godziny)';

  @override
  String get errorMessage => 'Komunikat o błędzie:';

  @override
  String get errorOccurred => 'Wystąpił błąd.';

  @override
  String get errorOccurredTryAgain =>
      'Wystąpił błąd. Proszę spróbować ponownie.';

  @override
  String get errorSendingFailed => 'Nie udało się wysłać błędu';

  @override
  String get errorStats => 'Statystyki błędów';

  @override
  String errorWithMessage(String error) {
    return 'Wystąpił błąd: $error';
  }

  @override
  String get evening => 'Wieczór';

  @override
  String get excited => 'Podekscytowany';

  @override
  String get exit => 'Wyjście';

  @override
  String get exitApp => 'Wyjdź z aplikacji';

  @override
  String get exitConfirmMessage => 'Czy na pewno chcesz wyjść z aplikacji?';

  @override
  String get expertPersona => 'Ekspert';

  @override
  String get expertiseScore => 'Wynik ekspertyzy';

  @override
  String get expired => 'Wygasły';

  @override
  String get explainReportReason =>
      'Proszę szczegółowo wyjaśnić powód zgłoszenia';

  @override
  String get fashion => 'Moda';

  @override
  String get female => 'Kobieta';

  @override
  String get filter => 'Filtruj';

  @override
  String get firstOccurred => 'Po raz pierwszy wystąpiło:';

  @override
  String get followDeviceLanguage =>
      'Podążaj za ustawieniami języka urządzenia';

  @override
  String get forenoon => 'Przedpołudnie';

  @override
  String get forgotPassword => 'Zapomniałeś hasła?';

  @override
  String get frequentlyAskedQuestions => 'Najczęściej Zadawane Pytania';

  @override
  String get friday => 'Piątek';

  @override
  String get friendshipDescription =>
      'Chcę poznać nowych przyjaciół i prowadzić rozmowy';

  @override
  String get funChat => 'Fajna Rozmowa';

  @override
  String get galleryPermission => 'Uprawnienia do galerii';

  @override
  String get galleryPermissionDesc =>
      'Dostęp do galerii jest wymagany, aby wybrać zdjęcia profilowe.';

  @override
  String get gaming => 'Gry';

  @override
  String get gender => 'Płeć';

  @override
  String get genderNotSelectedInfo =>
      'Jeśli płeć nie jest wybrana, będą wyświetlane persony wszystkich płci';

  @override
  String get genderOptional => 'Płeć (Opcjonalnie)';

  @override
  String get genderPreferenceActive => 'Możesz spotkać persony wszystkich płci';

  @override
  String get genderPreferenceDisabled =>
      'Wybierz swoją płeć, aby włączyć opcję tylko dla przeciwnej płci';

  @override
  String get genderPreferenceInactive =>
      'Będą wyświetlane tylko persony przeciwnej płci';

  @override
  String get genderRequired => 'Płeć *';

  @override
  String get genderSelectionInfo =>
      'Jeśli nie wybrano, możesz spotkać persony wszystkich płci';

  @override
  String get generalPersona => 'Ogólna Persona';

  @override
  String get goToSettings => 'Przejdź do Ustawień';

  @override
  String get googleLoginCanceled =>
      'Logowanie przez Google zostało anulowane. Spróbuj ponownie.';

  @override
  String get googleLoginError =>
      'Wystąpił błąd podczas logowania przez Google.';

  @override
  String get grantPermission => 'Kontynuuj';

  @override
  String get guest => 'Gość';

  @override
  String get guestDataMigration =>
      'Czy chcesz zachować swoją obecną historię czatu podczas rejestracji?';

  @override
  String get guestLimitReached => 'Okres próbny gościa dobiegł końca.';

  @override
  String get guestLoginPromptMessage => 'Zaloguj się, aby kontynuować rozmowę';

  @override
  String get guestMessageExhausted => 'Darmowe wiadomości wyczerpane';

  @override
  String guestMessageRemaining(int count) {
    return 'Pozostało $count wiadomości gościa';
  }

  @override
  String get guestModeBanner => 'Tryb gościa';

  @override
  String get guestModeDescription => 'Wypróbuj SONA bez rejestracji';

  @override
  String get guestModeFailedMessage => 'Nie udało się uruchomić trybu gościa';

  @override
  String get guestModeLimitation =>
      'Niektóre funkcje są ograniczone w trybie gościa';

  @override
  String get guestModeTitle => 'Wypróbuj jako gość';

  @override
  String get guestModeWarning => 'Tryb gościa trwa 24 godziny,';

  @override
  String get guestModeWelcome => 'Rozpoczynanie w trybie gościa';

  @override
  String get happy => 'Szczęśliwy';

  @override
  String get hapticFeedback => 'Sprzężenie zwrotne';

  @override
  String get harassmentBullying => 'Nękanie/Przemoc';

  @override
  String get hateSpeech => 'Mowa nienawiści';

  @override
  String get heartDescription => 'Serduszka na więcej wiadomości';

  @override
  String get heartInsufficient => 'Za mało serduszek';

  @override
  String get heartInsufficientPleaseCharge =>
      'Za mało serduszek. Proszę doładuj serduszka.';

  @override
  String get heartRequired => 'Wymagane jest 1 serduszko';

  @override
  String get heartUsageFailed => 'Nie udało się użyć serduszka.';

  @override
  String get hearts => 'Serduszka';

  @override
  String get hearts10 => '10 Serduszek';

  @override
  String get hearts30 => '30 Serduszek';

  @override
  String get hearts30Discount => 'WYPRZEDAŻ';

  @override
  String get hearts50 => '50 Serc';

  @override
  String get hearts50Discount => 'WYPRZEDAŻ';

  @override
  String get helloEmoji => 'Cześć! 😊';

  @override
  String get help => 'Pomoc';

  @override
  String get hideOriginalText => 'Ukryj oryginał';

  @override
  String get hobbySharing => 'Dzielenie się hobby';

  @override
  String get hobbyTalk => 'Rozmowy o hobby';

  @override
  String get hours24Ago => '24 godziny temu';

  @override
  String hoursAgo(int count, String formatted) {
    return '$count godzin temu';
  }

  @override
  String get howToUse => 'Jak używać SONA';

  @override
  String get imageCacheManagement => 'Zarządzanie pamięcią podręczną obrazów';

  @override
  String get inappropriateContent => 'Treści nieodpowiednie';

  @override
  String get incorrect => 'niepoprawny';

  @override
  String get incorrectPassword => 'Niepoprawne hasło';

  @override
  String get indonesian => 'Indonezyjski';

  @override
  String get inquiries => 'Zapytania';

  @override
  String get insufficientHearts => 'Niewystarczająca liczba serc.';

  @override
  String get interestSharing => 'Dzielenie się zainteresowaniami';

  @override
  String get interestSharingDesc =>
      'Odkrywaj i polecaj wspólne zainteresowania';

  @override
  String get interests => 'Zainteresowania';

  @override
  String get invalidEmailFormat => 'Nieprawidłowy format adresu e-mail';

  @override
  String get invalidEmailFormatError =>
      'Proszę wprowadzić prawidłowy adres e-mail';

  @override
  String isTyping(String name) {
    return '$name pisze...';
  }

  @override
  String get japanese => 'Japoński';

  @override
  String get joinDate => 'Data dołączenia';

  @override
  String get justNow => 'Właśnie teraz';

  @override
  String get keepGuestData => 'Zachowaj historię czatu';

  @override
  String get korean => 'Koreański';

  @override
  String get koreanLanguage => 'Koreański';

  @override
  String get language => 'Język';

  @override
  String get languageDescription => 'AI odpowie w wybranym języku';

  @override
  String get languageIndicator => 'Język';

  @override
  String get languageSettings => 'Ustawienia języka';

  @override
  String get lastOccurred => 'Ostatnie wystąpienie:';

  @override
  String get lastUpdated => 'Ostatnia aktualizacja';

  @override
  String get lateNight => 'Późna noc';

  @override
  String get later => 'Później';

  @override
  String get laterButton => 'Później';

  @override
  String get leave => 'Wyjdź';

  @override
  String get leaveChatConfirm => 'Opuszczasz ten czat?';

  @override
  String get leaveChatRoom => 'Opuszczam pokój czatu';

  @override
  String get leaveChatTitle => 'Opuszczam czat';

  @override
  String get lifeAdvice => 'Porady życiowe';

  @override
  String get lightTalk => 'Luźna rozmowa';

  @override
  String get lightTheme => 'Jasny tryb';

  @override
  String get lightThemeDesc => 'Użyj jasnego motywu';

  @override
  String get loading => 'Ładowanie...';

  @override
  String get loadingData => 'Ładowanie danych...';

  @override
  String get loadingProducts => 'Ładowanie produktów...';

  @override
  String get loadingProfile => 'Ładowanie profilu';

  @override
  String get login => 'Zaloguj';

  @override
  String get loginButton => 'Zaloguj się';

  @override
  String get loginCancelled => 'Anulowano logowanie';

  @override
  String get loginComplete => 'Logowanie zakończone';

  @override
  String get loginError => 'Logowanie nie powiodło się';

  @override
  String get loginFailed => 'Logowanie nie powiodło się';

  @override
  String get loginFailedTryAgain =>
      'Logowanie nie powiodło się. Proszę spróbować ponownie.';

  @override
  String get loginRequired => 'Wymagane logowanie';

  @override
  String get loginRequiredForProfile =>
      'Wymagane logowanie, aby zobaczyć profil';

  @override
  String get loginRequiredService =>
      'Wymagane logowanie, aby korzystać z tej usługi';

  @override
  String get loginRequiredTitle => 'Wymagane logowanie';

  @override
  String get loginSignup => 'Zaloguj się/Zarejestruj się';

  @override
  String get loginTab => 'Zaloguj się';

  @override
  String get loginTitle => 'Zaloguj się';

  @override
  String get loginWithApple => 'Zaloguj się za pomocą Apple';

  @override
  String get loginWithGoogle => 'Zaloguj się za pomocą Google';

  @override
  String get logout => 'Wyloguj';

  @override
  String get logoutConfirm => 'Czy na pewno chcesz się wylogować?';

  @override
  String get lonelinessRelief => 'Ulga w samotności';

  @override
  String get lonely => 'Samotny';

  @override
  String get lowQualityResponses => 'Odpowiedzi niskiej jakości';

  @override
  String get lunch => 'Obiad';

  @override
  String get lunchtime => 'Czas na lunch';

  @override
  String get mainErrorType => 'Główny typ błędu';

  @override
  String get makeFriends => 'Zawieraj przyjaźnie';

  @override
  String get male => 'Mężczyzna';

  @override
  String get manageBlockedAIs => 'Zarządzaj zablokowanymi AI';

  @override
  String get managePersonaImageCache =>
      'Zarządzaj pamięcią podręczną obrazów person';

  @override
  String get marketingAgree =>
      'Zgadzam się na informacje marketingowe (opcjonalnie)';

  @override
  String get marketingDescription =>
      'Możesz otrzymywać informacje o wydarzeniach i korzyściach';

  @override
  String get matchPersonaStep =>
      '1. Dopasuj persony: Przesuń w lewo lub w prawo, aby wybrać swoje ulubione persony AI.';

  @override
  String get matchedPersonas => 'Dopasowane persony';

  @override
  String get matchedSona => 'Dopasowane SONA';

  @override
  String get matching => 'Dopasowywanie';

  @override
  String get matchingFailed => 'Nie udało się dopasować.';

  @override
  String get me => 'Me';

  @override
  String get meetAIPersonas => 'Poznaj persony AI';

  @override
  String get meetNewPersonas => 'Poznaj nowe persony';

  @override
  String get meetPersonas => 'Poznaj persony';

  @override
  String get memberBenefits =>
      'Otrzymaj 100+ wiadomości i 10 serc po rejestracji!';

  @override
  String get memoryAlbum => 'Album Pamięci';

  @override
  String get memoryAlbumDesc =>
      'Automatycznie zapisuj i przypominaj sobie wyjątkowe chwile';

  @override
  String get messageCopied => 'Wiadomość skopiowana';

  @override
  String get messageDeleted => 'Wiadomość usunięta';

  @override
  String get messageLimitReset => 'Limit wiadomości zresetuje się o północy';

  @override
  String get messageSendFailed =>
      'Nie udało się wysłać wiadomości. Proszę spróbować ponownie.';

  @override
  String get messagesRemaining => 'Pozostałe wiadomości';

  @override
  String minutesAgo(int count, String formatted) {
    return '$count minut temu';
  }

  @override
  String get missingTranslation => 'Brakujące Tłumaczenie';

  @override
  String get monday => 'Poniedziałek';

  @override
  String get month => 'Miesiąc';

  @override
  String monthDay(String month, int day) {
    return '$month $day';
  }

  @override
  String get moreButton => 'Więcej';

  @override
  String get morning => 'Poranek';

  @override
  String get mostFrequentError => 'Najczęstszy Błąd';

  @override
  String get movies => 'Filmy';

  @override
  String get multilingualChat => 'Czat wielojęzyczny';

  @override
  String get music => 'Muzyka';

  @override
  String get myGenderSection => 'Moja płeć (opcjonalnie)';

  @override
  String get networkErrorOccurred => 'Wystąpił błąd sieciowy.';

  @override
  String get newMessage => 'Nowa wiadomość';

  @override
  String newMessageCount(int count) {
    return '$count nowych wiadomości';
  }

  @override
  String get newMessageNotification => 'Powiadom mnie o nowych wiadomościach';

  @override
  String get newMessages => 'Nowe wiadomości';

  @override
  String get newYear => 'Nowy Rok';

  @override
  String get next => 'Dalej';

  @override
  String get niceToMeetYou => 'Miło cię poznać!';

  @override
  String get nickname => 'Pseudonim';

  @override
  String get nicknameAlreadyUsed => 'Ten pseudonim jest już zajęty';

  @override
  String get nicknameHelperText => '3-10 znaków';

  @override
  String get nicknameHint => '3-10 znaków';

  @override
  String get nicknameInUse => 'Ten pseudonim jest już zajęty';

  @override
  String get nicknameLabel => 'Pseudonim';

  @override
  String get nicknameLengthError => 'Pseudonim musi mieć od 3 do 10 znaków';

  @override
  String get nicknamePlaceholder => 'Wprowadź swój pseudonim';

  @override
  String get nicknameRequired => 'Pseudonim *';

  @override
  String get night => 'Noc';

  @override
  String get no => 'Nie';

  @override
  String get noBlockedAIs => 'Brak zablokowanych AI';

  @override
  String get noChatsYet => 'Brak czatów';

  @override
  String get noConversationYet => 'Brak rozmów';

  @override
  String get noErrorReports => 'Brak zgłoszeń błędów.';

  @override
  String get noImageAvailable => 'Brak dostępnych obrazów';

  @override
  String get noMatchedPersonas => 'Brak dopasowanych person';

  @override
  String get noMatchedSonas => 'Brak dopasowanych SONA';

  @override
  String get noPersonasAvailable =>
      'Brak dostępnych person. Proszę spróbować ponownie.';

  @override
  String get noPersonasToSelect => 'Brak dostępnych person';

  @override
  String get noQualityIssues =>
      'Brak problemów z jakością w ciągu ostatniej godziny ✅';

  @override
  String get noQualityLogs => 'Brak logów jakości.';

  @override
  String get noTranslatedMessages => 'Brak wiadomości do przetłumaczenia';

  @override
  String get notEnoughHearts => 'Niewystarczająca liczba serc';

  @override
  String notEnoughHeartsCount(int count) {
    return 'Niewystarczająca liczba serc. (Aktualnie: $count)';
  }

  @override
  String get notRegistered => 'nie zarejestrowany';

  @override
  String get notSubscribed => 'Nie subskrybowany';

  @override
  String get notificationPermissionDesc =>
      'Wymagana jest zgoda na powiadomienia, aby otrzymywać nowe wiadomości.';

  @override
  String get notificationPermissionRequired =>
      'Wymagana zgoda na powiadomienia';

  @override
  String get notificationSettings => 'Ustawienia powiadomień';

  @override
  String get notifications => 'Powiadomienia';

  @override
  String get occurrenceInfo => 'Informacje o wystąpieniu:';

  @override
  String get olderChats => 'Starsze';

  @override
  String get onlyOppositeGenderNote =>
      'Jeśli odznaczone, będą wyświetlane tylko persony przeciwnej płci';

  @override
  String get openSettings => 'Otwórz ustawienia';

  @override
  String get optional => 'Opcjonalne';

  @override
  String get or => 'or';

  @override
  String get originalPrice => 'Oryginalna';

  @override
  String get originalText => 'Oryginalny';

  @override
  String get other => 'Inne';

  @override
  String get otherError => 'Inny błąd';

  @override
  String get others => 'Inni';

  @override
  String get ownedHearts => 'Posiadane serca';

  @override
  String get parentsDay => 'Dzień Rodziców';

  @override
  String get password => 'Hasło';

  @override
  String get passwordConfirmation => 'Wprowadź hasło, aby potwierdzić';

  @override
  String get passwordConfirmationDesc =>
      'Proszę ponownie wprowadzić hasło, aby usunąć konto.';

  @override
  String get passwordHint => '6 znaków lub więcej';

  @override
  String get passwordLabel => 'Hasło';

  @override
  String get passwordRequired => 'Hasło *';

  @override
  String get passwordResetEmailPrompt =>
      'Proszę wprowadzić swój e-mail, aby zresetować hasło';

  @override
  String get passwordResetEmailSent =>
      'E-mail z resetowaniem hasła został wysłany. Proszę sprawdzić swoją skrzynkę pocztową.';

  @override
  String get passwordText => 'hasło';

  @override
  String get passwordTooShort => 'Hasło musi mieć co najmniej 6 znaków';

  @override
  String get permissionDenied => 'Odrzucono uprawnienia';

  @override
  String permissionDeniedMessage(String permissionName) {
    return 'Odrzucono uprawnienia dla $permissionName.\\nProszę zezwolić na uprawnienia w ustawieniach.';
  }

  @override
  String get permissionDeniedTryLater =>
      'Odrzucono uprawnienia. Proszę spróbować ponownie później.';

  @override
  String get permissionRequired => 'Wymagane uprawnienia';

  @override
  String get personaGenderSection => 'Preferencje dotyczące płci persony';

  @override
  String personaQualityStats(Object personaQualityStats) {
    return 'Statystyki jakości persony';
  }

  @override
  String personalInfoExposure(Object personalInfoExposure) {
    return 'Ekspozycja danych osobowych';
  }

  @override
  String personality(Object personality) {
    return 'Osobowość';
  }

  @override
  String pets(Object pets) {
    return 'Zwierzęta domowe';
  }

  @override
  String get photo => 'Zdjęcie';

  @override
  String photography(Object photography) {
    return 'Fotografia';
  }

  @override
  String picnic(Object picnic) {
    return 'Piknik';
  }

  @override
  String preferenceSettings(Object preferenceSettings) {
    return 'Ustawienia preferencji';
  }

  @override
  String preferredLanguage(Object preferredLanguage) {
    return 'Preferowany język';
  }

  @override
  String get preparingForSleep => 'Przygotowanie do snu';

  @override
  String get preparingNewMeeting => 'Przygotowanie nowego spotkania';

  @override
  String get preparingPersonaImages => 'Przygotowanie obrazów postaci';

  @override
  String get preparingPersonas => 'Przygotowanie postaci';

  @override
  String get preview => 'Podgląd';

  @override
  String get previous => 'Poprzedni';

  @override
  String get privacy => 'Polityka prywatności';

  @override
  String get privacyPolicy => 'Polityka prywatności';

  @override
  String get privacyPolicyAgreement =>
      'Proszę zaakceptować politykę prywatności';

  @override
  String get privacySection1Content =>
      'Zobowiązujemy się do ochrony Twojej prywatności. Niniejsza Polityka prywatności wyjaśnia, w jaki sposób zbieramy, wykorzystujemy i chronimy Twoje informacje podczas korzystania z naszej usługi.';

  @override
  String get privacySection1Title =>
      '1. Cel zbierania i wykorzystywania danych osobowych';

  @override
  String get privacySection2Content =>
      'Zbieramy informacje, które podajesz nam bezpośrednio, na przykład gdy tworzysz konto, aktualizujesz swój profil lub korzystasz z naszych usług.';

  @override
  String get privacySection2Title => 'Informacje, które zbieramy';

  @override
  String get privacySection3Content =>
      'Wykorzystujemy zebrane informacje, aby świadczyć, utrzymywać i poprawiać nasze usługi oraz komunikować się z Tobą.';

  @override
  String get privacySection3Title =>
      '3. Okres przechowywania i wykorzystywania danych osobowych';

  @override
  String get privacySection4Content =>
      'Nie sprzedajemy, nie wymieniamy ani w żaden inny sposób nie przekazujemy Twoich danych osobowych osobom trzecim bez Twojej zgody.';

  @override
  String get privacySection4Title =>
      '4. Przekazywanie danych osobowych osobom trzecim';

  @override
  String get privacySection5Content =>
      'Wdrażamy odpowiednie środki bezpieczeństwa, aby chronić Twoje dane osobowe przed nieautoryzowanym dostępem, zmianą, ujawnieniem lub zniszczeniem.';

  @override
  String get privacySection5Title =>
      '5. Techniczne środki ochrony danych osobowych';

  @override
  String get privacySection6Content =>
      'Przechowujemy dane osobowe tak długo, jak to konieczne, aby świadczyć nasze usługi i spełniać obowiązki prawne.';

  @override
  String get privacySection6Title => '6. Prawa użytkowników';

  @override
  String get privacySection7Content =>
      'Masz prawo do dostępu, aktualizacji lub usunięcia swoich danych osobowych w dowolnym momencie za pośrednictwem ustawień swojego konta.';

  @override
  String get privacySection7Title => 'Twoje Prawa';

  @override
  String get privacySection8Content =>
      'Jeśli masz jakiekolwiek pytania dotyczące tej Polityki Prywatności, skontaktuj się z nami pod adresem support@sona.com.';

  @override
  String get privacySection8Title => 'Skontaktuj się z nami';

  @override
  String get privacySettings => 'Ustawienia Prywatności';

  @override
  String get privacySettingsInfo =>
      'Wyłączenie poszczególnych funkcji spowoduje, że te usługi będą niedostępne';

  @override
  String get privacySettingsScreen => 'Ustawienia Prywatności';

  @override
  String get problemMessage => 'Problem';

  @override
  String get problemOccurred => 'Wystąpił problem';

  @override
  String get profile => 'Profil';

  @override
  String get profileEdit => 'Edytuj Profil';

  @override
  String get profileEditLoginRequiredMessage =>
      'Wymagane jest zalogowanie się, aby edytować swój profil. Czy chcesz przejść do ekranu logowania?';

  @override
  String get profileInfo => 'Informacje o Profilu';

  @override
  String get profileInfoDescription =>
      'Proszę wprowadzić zdjęcie profilowe i podstawowe informacje';

  @override
  String get profileNav => 'Profil';

  @override
  String get profilePhoto => 'Zdjęcie profilowe';

  @override
  String get profilePhotoAndInfo =>
      'Proszę wprowadzić zdjęcie profilowe i podstawowe informacje';

  @override
  String get profilePhotoUpdateFailed =>
      'Nie udało się zaktualizować zdjęcia profilowego';

  @override
  String get profilePhotoUpdated => 'Zdjęcie profilowe zaktualizowane';

  @override
  String get profileSettings => 'Ustawienia profilu';

  @override
  String get profileSetup => 'Ustawianie profilu';

  @override
  String get profileUpdateFailed => 'Nie udało się zaktualizować profilu';

  @override
  String get profileUpdated => 'Profil został pomyślnie zaktualizowany';

  @override
  String get purchaseAndRefundPolicy => 'Polityka zakupu i zwrotu';

  @override
  String get purchaseButton => 'Kup';

  @override
  String get purchaseConfirm => 'Potwierdzenie zakupu';

  @override
  String purchaseConfirmContent(String product, String price) {
    return 'Czy chcesz kupić $product za $price?';
  }

  @override
  String purchaseConfirmMessage(
      String title, String price, String description) {
    return 'Potwierdź zakup $title za $price? $description';
  }

  @override
  String get purchaseFailed => 'Zakup nie powiódł się';

  @override
  String get purchaseHeartsOnly => 'Kup serca';

  @override
  String get purchaseMoreHearts => 'Kup serca, aby kontynuować rozmowy';

  @override
  String get purchasePending => 'Zakup w toku...';

  @override
  String get purchasePolicy => 'Polityka zakupu';

  @override
  String get purchaseSection1Content =>
      'Akceptujemy różne metody płatności, w tym karty kredytowe i portfele cyfrowe.';

  @override
  String get purchaseSection1Title => 'Metody płatności';

  @override
  String get purchaseSection2Content =>
      'Zwroty są dostępne w ciągu 14 dni od zakupu, jeśli nie użyto zakupionych przedmiotów.';

  @override
  String get purchaseSection2Title => 'Polityka zwrotów';

  @override
  String get purchaseSection3Content =>
      'Możesz anulować subskrypcję w dowolnym momencie w ustawieniach swojego konta.';

  @override
  String get purchaseSection3Title => 'Anulowanie';

  @override
  String get purchaseSection4Content =>
      'Dokonując zakupu, zgadzasz się na nasze warunki użytkowania i umowę serwisową.';

  @override
  String get purchaseSection4Title => 'Warunki użytkowania';

  @override
  String get purchaseSection5Content =>
      'W przypadku problemów związanych z zakupem, skontaktuj się z naszym zespołem wsparcia.';

  @override
  String get purchaseSection5Title => 'Skontaktuj się z pomocą';

  @override
  String get purchaseSection6Content =>
      'Wszystkie zakupy podlegają naszym standardowym warunkom i zasadom.';

  @override
  String get purchaseSection6Title => '6. Zapytania';

  @override
  String get pushNotifications => 'Powiadomienia Push';

  @override
  String get reading => 'Czytanie';

  @override
  String get realtimeQualityLog => 'Dziennik jakości w czasie rzeczywistym';

  @override
  String get recentConversation => 'Ostatnia rozmowa:';

  @override
  String get recentLoginRequired =>
      'Proszę zalogować się ponownie dla bezpieczeństwa';

  @override
  String get referrerEmail => 'E-mail osoby polecającej';

  @override
  String get referrerEmailHelper =>
      'Opcjonalnie: E-mail osoby, która Cię poleciła';

  @override
  String get referrerEmailLabel => 'E-mail osoby polecającej (Opcjonalnie)';

  @override
  String get refresh => 'Odśwież';

  @override
  String refreshComplete(int count) {
    return 'Odświeżanie zakończone! $count dopasowanych person';
  }

  @override
  String get refreshFailed => 'Odświeżanie nie powiodło się';

  @override
  String get refreshingChatList => 'Odświeżanie listy czatów...';

  @override
  String get relatedFAQ => 'Powiązane FAQ';

  @override
  String get report => 'Raport';

  @override
  String get reportAI => 'Zgłoś';

  @override
  String get reportAIDescription =>
      'Jeśli AI sprawiło, że poczułeś się niekomfortowo, opisz problem.';

  @override
  String get reportAITitle => 'Zgłoś rozmowę z AI';

  @override
  String get reportAndBlock => 'Zgłoś i zablokuj';

  @override
  String get reportAndBlockDescription =>
      'Możesz zgłosić i zablokować niewłaściwe zachowanie tego AI';

  @override
  String get reportChatError => 'Zgłoś błąd czatu';

  @override
  String reportError(String error) {
    return 'Wystąpił błąd podczas zgłaszania: $error';
  }

  @override
  String get reportFailed => 'Zgłoszenie nie powiodło się';

  @override
  String get reportSubmitted =>
      'Zgłoszenie zostało wysłane. Przejrzymy je i podejmiemy działania.';

  @override
  String get reportSubmittedSuccess =>
      'Twoje zgłoszenie zostało wysłane. Dziękujemy!';

  @override
  String get requestLimit => 'Limit żądań';

  @override
  String get required => '[Wymagane]';

  @override
  String get requiredTermsAgreement => 'Proszę zaakceptować warunki';

  @override
  String get restartConversation => 'Zrestartuj rozmowę';

  @override
  String restartConversationQuestion(String name) {
    return 'Czy chcesz zrestartować rozmowę z $name?';
  }

  @override
  String restartConversationWithName(String name) {
    return 'Zrestartowanie rozmowy z $name!';
  }

  @override
  String get retry => 'Spróbuj ponownie';

  @override
  String get retryButton => 'Spróbuj ponownie';

  @override
  String get sad => 'Smutny';

  @override
  String get saturday => 'Sobota';

  @override
  String get save => 'Zapisz';

  @override
  String get search => 'Szukaj';

  @override
  String get searchFAQ => 'Szukaj FAQ...';

  @override
  String get searchResults => 'Wyniki wyszukiwania';

  @override
  String get selectEmotion => 'Wybierz emocję';

  @override
  String get selectErrorType => 'Wybierz typ błędu';

  @override
  String get selectFeeling => 'Wybierz uczucie';

  @override
  String get selectGender => 'Proszę wybrać płeć';

  @override
  String get selectInterests =>
      'Proszę wybrać swoje zainteresowania (przynajmniej 1)';

  @override
  String get selectLanguage => 'Wybierz język';

  @override
  String get selectPersona => 'Wybierz personę';

  @override
  String get selectPersonaPlease => 'Proszę wybrać personę.';

  @override
  String get selectPreferredMbti =>
      'Jeśli preferujesz persony z określonymi typami MBTI, proszę wybierz';

  @override
  String get selectProblematicMessage =>
      'Wybierz problematyczną wiadomość (opcjonalnie)';

  @override
  String get selectReportReason => 'Wybierz powód zgłoszenia';

  @override
  String get selectTheme => 'Wybierz temat';

  @override
  String get selectTranslationError =>
      'Proszę wybrać wiadomość z błędem tłumaczenia';

  @override
  String get selectUsagePurpose => 'Proszę wybrać cel korzystania z SONA';

  @override
  String get selfIntroduction => 'Wprowadzenie (opcjonalnie)';

  @override
  String get selfIntroductionHint => 'Napisz krótkie wprowadzenie o sobie';

  @override
  String get send => 'Wyślij';

  @override
  String get sendChatError => 'Błąd wysyłania czatu';

  @override
  String get sendFirstMessage => 'Wyślij swoją pierwszą wiadomość';

  @override
  String get sendReport => 'Wyślij raport';

  @override
  String get sendingEmail => 'Wysyłanie e-maila...';

  @override
  String get seoul => 'Seul';

  @override
  String get serverErrorDashboard => 'Błąd serwera';

  @override
  String get serviceTermsAgreement => 'Proszę zgodzić się na warunki usługi';

  @override
  String get sessionExpired => 'Sesja wygasła';

  @override
  String get setAppInterfaceLanguage => 'Ustaw język interfejsu aplikacji';

  @override
  String get setNow => 'Ustaw teraz';

  @override
  String get settings => 'Ustawienia';

  @override
  String get sexualContent => 'Treści seksualne';

  @override
  String get showAllGenderPersonas => 'Pokaż wszystkie osobowości płciowe';

  @override
  String get showAllGendersOption => 'Pokaż wszystkie płci';

  @override
  String get showOppositeGenderOnly =>
      'Jeśli odznaczone, będą wyświetlane tylko osobowości przeciwnej płci';

  @override
  String get showOriginalText => 'Pokaż oryginał';

  @override
  String get signUp => 'Zarejestruj się';

  @override
  String get signUpFromGuest =>
      'Zarejestruj się teraz, aby uzyskać dostęp do wszystkich funkcji!';

  @override
  String get signup => 'Zarejestruj się';

  @override
  String get signupComplete => 'Rejestracja zakończona';

  @override
  String get signupTab => 'Rejestracja';

  @override
  String get simpleInfoRequired => 'Wymagane są proste informacje';

  @override
  String get skip => 'Pomiń';

  @override
  String get sonaFriend => 'SONA Przyjaciel';

  @override
  String get sonaPrivacyPolicy => 'Polityka Prywatności SONA';

  @override
  String get sonaPurchasePolicy => 'Polityka Zakupu SONA';

  @override
  String get sonaTermsOfService => 'Warunki Usługi SONA';

  @override
  String get sonaUsagePurpose => 'Proszę wybrać cel korzystania z SONA';

  @override
  String get sorryNotHelpful => 'Przykro nam, to nie było pomocne';

  @override
  String get sort => 'Sortuj';

  @override
  String get soundSettings => 'Ustawienia Dźwięku';

  @override
  String get spamAdvertising => 'Spam/Reklama';

  @override
  String get spanish => 'Hiszpański';

  @override
  String get specialRelationshipDesc =>
      'Rozumieć się nawzajem i budować głębokie więzi';

  @override
  String get sports => 'Sport';

  @override
  String get spring => 'Wiosna';

  @override
  String get startChat => 'Rozpocznij czat';

  @override
  String get startChatButton => 'Rozpocznij czat';

  @override
  String get startConversation => 'Rozpocznij rozmowę';

  @override
  String get startConversationLikeAFriend =>
      'Rozpocznij rozmowę z Soną jak z przyjacielem';

  @override
  String get startConversationStep =>
      '2. Rozpocznij rozmowę: Czat z dopasowanymi osobami.';

  @override
  String get startConversationWithSona =>
      'Zacznij czatować z Soną jak z przyjacielem!';

  @override
  String get startWithEmail => 'Rozpocznij od e-maila';

  @override
  String get startWithGoogle => 'Rozpocznij od Google';

  @override
  String get startingApp => 'Uruchamianie aplikacji';

  @override
  String get storageManagement => 'Zarządzanie pamięcią';

  @override
  String get store => 'Sklep';

  @override
  String get storeConnectionError => 'Nie można połączyć się ze sklepem';

  @override
  String get storeLoginRequiredMessage =>
      'Wymagane jest zalogowanie się, aby korzystać ze sklepu.';

  @override
  String get storeNotAvailable => 'Sklep jest niedostępny';

  @override
  String get storyEvent => 'Wydarzenie fabularne';

  @override
  String get stressed => 'Zestresowany';

  @override
  String get submitReport => 'Prześlij raport';

  @override
  String get subscriptionStatus => 'Status subskrypcji';

  @override
  String get subtleVibrationOnTouch => 'Subtelna wibracja przy dotyku';

  @override
  String get summer => 'Lato';

  @override
  String get sunday => 'Niedziela';

  @override
  String get swipeAnyDirection => 'Przesuń w dowolnym kierunku';

  @override
  String get swipeDownToClose => 'Przesuń w dół, aby zamknąć';

  @override
  String get systemTheme => 'Podążaj za systemem';

  @override
  String get systemThemeDesc =>
      'Automatycznie zmienia się w zależności od ustawień trybu ciemnego urządzenia';

  @override
  String get tapBottomForDetails =>
      'Stuknij w dolną część, aby zobaczyć szczegóły';

  @override
  String get tapForDetails => 'Stuknij w dolną część, aby uzyskać szczegóły';

  @override
  String get tapToSwipePhotos => 'Stuknij, aby przesuwać zdjęcia';

  @override
  String get teachersDay => 'Dzień Nauczyciela';

  @override
  String get technicalError => 'Błąd techniczny';

  @override
  String get technology => 'Technologia';

  @override
  String get terms => 'Warunki korzystania z usługi';

  @override
  String get termsAgreement => 'Zgoda na warunki';

  @override
  String get termsAgreementDescription =>
      'Proszę zgodzić się na warunki korzystania z usługi';

  @override
  String get termsOfService => 'Warunki korzystania';

  @override
  String get termsSection10Content =>
      'Zastrzegamy sobie prawo do modyfikacji tych warunków w dowolnym momencie z powiadomieniem użytkowników.';

  @override
  String get termsSection10Title => 'Artykuł 10 (Rozwiązywanie sporów)';

  @override
  String get termsSection11Content =>
      'Niniejsze warunki będą regulowane prawem jurysdykcji, w której działamy.';

  @override
  String get termsSection11Title =>
      'Artykuł 11 (Specjalne postanowienia dotyczące usług AI)';

  @override
  String get termsSection12Content =>
      'Jeśli jakiekolwiek postanowienie tych warunków okaże się niewykonalne, pozostałe postanowienia pozostaną w pełnej mocy i skutku.';

  @override
  String get termsSection12Title =>
      'Artykuł 12 (Zbieranie i wykorzystywanie danych)';

  @override
  String get termsSection1Content =>
      'Niniejsze warunki mają na celu określenie praw, obowiązków i odpowiedzialności między SONA (dalej \"Firma\") a użytkownikami w związku z korzystaniem z usługi dopasowywania rozmów z osobą AI (dalej \"Usługa\") świadczonej przez Firmę.';

  @override
  String get termsSection1Title => 'Artykuł 1 (Cel)';

  @override
  String get termsSection2Content =>
      'Korzystając z naszej usługi, zgadzasz się na przestrzeganie tych Warunków Usługi oraz naszej Polityki Prywatności.';

  @override
  String get termsSection2Title => 'Artykuł 2 (Definicje)';

  @override
  String get termsSection3Content =>
      'Musisz mieć co najmniej 13 lat, aby korzystać z naszej usługi.';

  @override
  String get termsSection3Title => 'Artykuł 3 (Skuteczność i zmiana warunków)';

  @override
  String get termsSection4Content =>
      'Jesteś odpowiedzialny za zachowanie poufności swojego konta i hasła.';

  @override
  String get termsSection4Title => 'Artykuł 4 (Świadczenie usługi)';

  @override
  String get termsSection5Content =>
      'Zgadzasz się nie używać naszej usługi do jakichkolwiek nielegalnych lub nieautoryzowanych celów.';

  @override
  String get termsSection5Title => 'Artykuł 5 (Rejestracja członkostwa)';

  @override
  String get termsSection6Content =>
      'Zastrzegamy sobie prawo do zakończenia lub zawieszenia Twojego konta w przypadku naruszenia tych warunków.';

  @override
  String get termsSection6Title => 'Artykuł 6 (Obowiązki Użytkownika)';

  @override
  String get termsSection7Content =>
      'Firma może stopniowo ograniczać korzystanie z usługi poprzez ostrzeżenia, tymczasowe zawieszenie lub trwałe zawieszenie, jeśli użytkownicy naruszają obowiązki wynikające z tych warunków lub zakłócają normalne funkcjonowanie usługi.';

  @override
  String get termsSection7Title =>
      'Artykuł 7 (Ograniczenia w Korzystaniu z Usługi)';

  @override
  String get termsSection8Content =>
      'Nie ponosimy odpowiedzialności za jakiekolwiek pośrednie, przypadkowe lub wynikowe szkody powstałe w wyniku korzystania z naszej usługi.';

  @override
  String get termsSection8Title => 'Artykuł 8 (Przerwa w Usłudze)';

  @override
  String get termsSection9Content =>
      'Wszystkie treści i materiały dostępne w naszej usłudze są chronione prawami własności intelektualnej.';

  @override
  String get termsSection9Title =>
      'Artykuł 9 (Zrzeczenie się Odpowiedzialności)';

  @override
  String get termsSupplementary => 'Warunki Dodatkowe';

  @override
  String get thai => 'Tajski';

  @override
  String get thanksFeedback => 'Dziękujemy za Twoją opinię!';

  @override
  String get theme => 'Motyw';

  @override
  String get themeDescription =>
      'Możesz dostosować wygląd aplikacji według własnych upodobań';

  @override
  String get themeSettings => 'Ustawienia motywu';

  @override
  String get thursday => 'Czwartek';

  @override
  String get timeout => 'Czas oczekiwania';

  @override
  String get tired => 'Zmęczony';

  @override
  String get today => 'Dziś';

  @override
  String get todayChats => 'Dziś';

  @override
  String get todayText => 'Dziś';

  @override
  String get tomorrowText => 'Jutro';

  @override
  String get totalConsultSessions => 'Łączna liczba sesji konsultacyjnych';

  @override
  String get totalErrorCount => 'Łączna liczba błędów';

  @override
  String get totalLikes => 'Łączna liczba polubień';

  @override
  String totalOccurrences(Object count) {
    return 'Łącznie $count wystąpień';
  }

  @override
  String get totalResponses => 'Łącznie odpowiedzi';

  @override
  String get translatedFrom => 'Przetłumaczone';

  @override
  String get translatedText => 'Tłumaczenie';

  @override
  String get translationError => 'Błąd tłumaczenia';

  @override
  String get translationErrorDescription =>
      'Proszę zgłaszać niepoprawne tłumaczenia lub niezręczne wyrażenia';

  @override
  String get translationErrorReported =>
      'Zgłoszono błąd tłumaczenia. Dziękujemy!';

  @override
  String get translationNote => '※ Tłumaczenie AI może nie być idealne';

  @override
  String get translationQuality => 'Jakość tłumaczenia';

  @override
  String get translationSettings => 'Ustawienia tłumaczenia';

  @override
  String get travel => 'Podróż';

  @override
  String get tuesday => 'Wtorek';

  @override
  String get tutorialAccount => 'Konto samouczka';

  @override
  String get tutorialWelcomeDescription =>
      'Twórz specjalne relacje z osobami AI.';

  @override
  String get tutorialWelcomeTitle => 'Witaj w SONA!';

  @override
  String get typeMessage => 'Wpisz wiadomość...';

  @override
  String get unblock => 'Odblokuj';

  @override
  String get unblockFailed => 'Nie udało się odblokować';

  @override
  String unblockPersonaConfirm(String name) {
    return 'Odblokować $name?';
  }

  @override
  String get unblockedSuccessfully => 'Pomyślnie odblokowano';

  @override
  String get unexpectedLoginError =>
      'Wystąpił nieoczekiwany błąd podczas logowania';

  @override
  String get unknown => 'Nieznane';

  @override
  String get unknownError => 'Wystąpił nieznany błąd';

  @override
  String get unlimitedMessages => 'Nielimitowane';

  @override
  String get unsendMessage => 'Cofnij wiadomość';

  @override
  String get usagePurpose => 'Cel użycia';

  @override
  String get useOneHeart => 'Użyj 1 serca';

  @override
  String get useSystemLanguage => 'Użyj języka systemowego';

  @override
  String get user => 'Użytkownik:';

  @override
  String get userMessage => 'Wiadomość użytkownika:';

  @override
  String get userNotFound => 'Użytkownik nie znaleziony';

  @override
  String get valentinesDay => 'Walentynki';

  @override
  String get verifyingAuth => 'Weryfikacja autoryzacji';

  @override
  String get version => 'Wersja';

  @override
  String get vietnamese => 'Wietnamski';

  @override
  String get violentContent => 'Treści przemocowe';

  @override
  String get voiceMessage => '🎤 Wiadomość głosowa';

  @override
  String waitingForChat(String name) {
    return '$name czeka na czat.';
  }

  @override
  String get walk => 'Spacer';

  @override
  String get wasHelpful => 'Czy to było pomocne?';

  @override
  String get weatherClear => 'Czyste';

  @override
  String get weatherCloudy => 'Pochmurne';

  @override
  String get weatherContext => 'Kontekst pogodowy';

  @override
  String get weatherContextDesc => 'Podaj kontekst rozmowy na podstawie pogody';

  @override
  String get weatherDrizzle => 'Mżawka';

  @override
  String get weatherFog => 'Mgła';

  @override
  String get weatherMist => 'Mglisto';

  @override
  String get weatherRain => 'Deszcz';

  @override
  String get weatherRainy => 'Deszczowo';

  @override
  String get weatherSnow => 'Śnieg';

  @override
  String get weatherSnowy => 'Śnieżnie';

  @override
  String get weatherThunderstorm => 'Burza';

  @override
  String get wednesday => 'Środa';

  @override
  String get weekdays => 'Nd, Pon, Wt, Śr, Czw, Pt, Sob';

  @override
  String get welcomeMessage => 'Witaj💕';

  @override
  String get whatTopicsToTalk =>
      'O jakich tematach chciałbyś porozmawiać? (Opcjonalnie)';

  @override
  String get whiteDay => 'Biały Dzień';

  @override
  String get winter => 'Zima';

  @override
  String get wrongTranslation => 'Błędne Tłumaczenie';

  @override
  String get year => 'Rok';

  @override
  String get yearEnd => 'Koniec Roku';

  @override
  String get yes => 'Tak';

  @override
  String get yesterday => 'Wczoraj';

  @override
  String get yesterdayChats => 'Wczoraj';

  @override
  String get you => 'Ty';
}
