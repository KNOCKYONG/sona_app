// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get about => 'О приложении';

  @override
  String get accountAndProfile => 'Информация об аккаунте и профиле';

  @override
  String get accountDeletedSuccess => 'Аккаунт успешно удален';

  @override
  String get accountDeletionContent =>
      'Вы уверены, что хотите удалить свой аккаунт?';

  @override
  String get accountDeletionError => 'Произошла ошибка при удалении аккаунта.';

  @override
  String get accountDeletionInfo => 'Информация об удалении аккаунта';

  @override
  String get accountDeletionTitle => 'Удалить аккаунт';

  @override
  String get accountDeletionWarning1 =>
      'Предупреждение: Это действие нельзя отменить';

  @override
  String get accountDeletionWarning2 =>
      'Все ваши данные будут удалены навсегда';

  @override
  String get accountDeletionWarning3 =>
      'Вы потеряете доступ ко всем разговорам';

  @override
  String get accountDeletionWarning4 => 'Это включает весь купленный контент';

  @override
  String get accountManagement => 'Управление аккаунтом';

  @override
  String get adaptiveConversationDesc => 'Адаптирует стиль общения под ваш';

  @override
  String get afternoon => 'После полудня';

  @override
  String get afternoonFatigue => 'Усталость после полудня';

  @override
  String get ageConfirmation =>
      'Мне 14 лет или больше, и я подтвердил(а) вышеуказанное.';

  @override
  String ageRange(int min, int max) {
    return '$min-$max лет';
  }

  @override
  String get ageUnit => 'лет';

  @override
  String get agreeToTerms => 'Я согласен с условиями';

  @override
  String get aiDatingQuestion => 'Особая повседневная жизнь с ИИ';

  @override
  String get aiPersonaPreferenceDescription =>
      'Пожалуйста, установите свои предпочтения для соответствия с ИИ персонами';

  @override
  String get all => 'Все';

  @override
  String get allAgree => 'Согласен(на) со всем';

  @override
  String get allFeaturesRequired =>
      '※ Все функции обязательны для предоставления услуги';

  @override
  String get allPersonas => 'Все Персоны';

  @override
  String get allPersonasMatched => 'Все персоны совпали! Начните с ними чат.';

  @override
  String get allowPermission => 'Продолжить';

  @override
  String alreadyChattingWith(String name) {
    return 'Вы уже общаетесь с $name!';
  }

  @override
  String get alsoBlockThisAI => 'Также заблокировать этого ИИ';

  @override
  String get angry => 'Раздражён';

  @override
  String get anonymousLogin => 'Анонимный вход';

  @override
  String get anxious => 'Тревожный';

  @override
  String get apiKeyError => 'Ошибка API ключа';

  @override
  String get appName => 'SONA';

  @override
  String get appTagline => 'Ваши ИИ-компаньоны';

  @override
  String get appleLoginCanceled =>
      'Вход через Apple был отменён. Пожалуйста, попробуйте снова.';

  @override
  String get appleLoginError => 'Произошла ошибка при входе через Apple.';

  @override
  String get art => 'Искусство';

  @override
  String get authError => 'Ошибка аутентификации';

  @override
  String get autoTranslate => 'Автоперевод';

  @override
  String get autumn => 'Осень';

  @override
  String get averageQuality => 'Среднее качество';

  @override
  String get averageQualityScore => 'Средний балл качества';

  @override
  String get awkwardExpression => 'Неловкое выражение';

  @override
  String get backButton => 'Назад';

  @override
  String get basicInfo => 'Основная Информация';

  @override
  String get basicInfoDescription =>
      'Пожалуйста, введите основную информацию для создания аккаунта';

  @override
  String get birthDate => 'Дата рождения';

  @override
  String get birthDateOptional => 'Дата рождения (необязательно)';

  @override
  String get birthDateRequired => 'Дата рождения *';

  @override
  String get blockConfirm =>
      'Вы хотите заблокировать этого ИИ? Заблокированные ИИ будут исключены из списка совпадений и чата.';

  @override
  String get blockReason => 'Причина блокировки';

  @override
  String get blockThisAI => 'Заблокировать этого ИИ';

  @override
  String blockedAICount(int count) {
    return '$count заблокированных ИИ';
  }

  @override
  String get blockedAIs => 'Заблокированные ИИ';

  @override
  String get blockedAt => 'Заблокировано в';

  @override
  String get blockedSuccessfully => 'Успешно заблокировано';

  @override
  String get breakfast => 'Завтрак';

  @override
  String get byErrorType => 'По типу ошибки';

  @override
  String get byPersona => 'По персонажу';

  @override
  String cacheDeleteError(String error) {
    return 'Ошибка при удалении кеша: $error';
  }

  @override
  String get cacheDeleted => 'Кеш изображений был удалён';

  @override
  String get cafeTerrace => 'Терраса кафе';

  @override
  String get calm => 'Спокойствие';

  @override
  String get cameraPermission => 'Разрешение камеры';

  @override
  String get cameraPermissionDesc =>
      'Доступ к камере необходим для съемки фотографий профиля.';

  @override
  String get canChangeInSettings => 'Вы можете изменить это позже в настройках';

  @override
  String get canMeetPreviousPersonas => 'Вы можете встретить персонажей,';

  @override
  String get cancel => 'Отмена';

  @override
  String get changeProfilePhoto => 'Изменить фото профиля';

  @override
  String get chat => 'Чат';

  @override
  String get chatEndedMessage => 'Чат завершён';

  @override
  String get chatErrorDashboard => 'Панель ошибок чата';

  @override
  String get chatErrorSentSuccessfully => 'Ошибка чата успешно отправлена.';

  @override
  String get chatListTab => 'Вкладка списка чатов';

  @override
  String get chats => 'Чаты';

  @override
  String chattingWithPersonas(int count) {
    return 'Общение с $count персонами';
  }

  @override
  String get checkInternetConnection => 'Проверьте подключение к интернету';

  @override
  String get checkingUserInfo => 'Проверка информации о пользователе';

  @override
  String get childrensDay => 'День защиты детей';

  @override
  String get chinese => 'Китайский';

  @override
  String get chooseOption => 'Пожалуйста, выберите:';

  @override
  String get christmas => 'Рождество';

  @override
  String get close => 'Закрыть';

  @override
  String get complete => 'Готово';

  @override
  String get completeSignup => 'Завершить регистрацию';

  @override
  String get confirm => 'Подтвердить';

  @override
  String get connectingToServer => 'Подключение к серверу';

  @override
  String get consultQualityMonitoring => 'Мониторинг качества консультаций';

  @override
  String get continueAsGuest => 'Продолжить как гость';

  @override
  String get continueButton => 'Продолжить';

  @override
  String get continueWithApple => 'Продолжить с Apple';

  @override
  String get continueWithGoogle => 'Продолжить с Google';

  @override
  String get conversationContinuity => 'Непрерывность общения';

  @override
  String get conversationContinuityDesc =>
      'Запоминайте предыдущие разговоры и связывайте темы';

  @override
  String conversationWith(String name) {
    return '$name';
  }

  @override
  String get convertToMember => 'Зарегистрироваться';

  @override
  String get cooking => 'Кулинария';

  @override
  String get copyMessage => 'Скопировать сообщение';

  @override
  String get copyrightInfringement => 'Нарушение авторских прав';

  @override
  String get creatingAccount => 'Создание аккаунта';

  @override
  String get crisisDetected => 'Обнаружена кризисная ситуация';

  @override
  String get culturalIssue => 'Культурная проблема';

  @override
  String get current => 'Текущий';

  @override
  String get currentCacheSize => 'Текущий размер кэша';

  @override
  String get currentLanguage => 'Текущий язык';

  @override
  String get cycling => 'Велоспорт';

  @override
  String get dailyCare => 'Ежедневный уход';

  @override
  String get dailyCareDesc =>
      'Сообщения о ежедневном уходе за едой, сном, здоровьем';

  @override
  String get dailyChat => 'Ежедневный чат';

  @override
  String get dailyCheck => 'Ежедневная проверка';

  @override
  String get dailyConversation => 'Ежедневный разговор';

  @override
  String get dailyLimitDescription => 'Вы достигли дневного лимита сообщений';

  @override
  String get dailyLimitTitle => 'Достигнут дневной лимит';

  @override
  String get darkMode => 'Темный режим';

  @override
  String get darkTheme => 'Темная тема';

  @override
  String get darkThemeDesc => 'Использовать темную тему';

  @override
  String get dataCollection => 'Настройки сбора данных';

  @override
  String get datingAdvice => 'Советы по знакомствам';

  @override
  String get datingDescription =>
      'Я хочу делиться глубокими мыслями и вести искренние беседы';

  @override
  String get dawn => 'Рассвет';

  @override
  String get day => 'День';

  @override
  String get dayAfterTomorrow => 'Послезавтра';

  @override
  String daysAgo(int count, String formatted) {
    return '$count дней назад';
  }

  @override
  String daysRemaining(int days) {
    return 'Осталось $days дней';
  }

  @override
  String get deepTalk => 'Глубокий разговор';

  @override
  String get delete => 'Удалить';

  @override
  String get deleteAccount => 'Удалить аккаунт';

  @override
  String get deleteAccountConfirm =>
      'Вы уверены, что хотите удалить свою учетную запись? Это действие нельзя отменить.';

  @override
  String get deleteAccountWarning =>
      'Вы уверены, что хотите удалить свой аккаунт?';

  @override
  String get deleteCache => 'Удалить кэш';

  @override
  String get deletingAccount => 'Удаление аккаунта...';

  @override
  String get depressed => 'В депрессии';

  @override
  String get describeError => 'В чем проблема?';

  @override
  String get detailedReason => 'Подробная причина';

  @override
  String get developRelationshipStep =>
      '3. Развивайте отношения: Углубляйте близость через беседы и развивайте особые отношения.';

  @override
  String get dinner => 'Ужин';

  @override
  String get discardGuestData => 'Начать заново';

  @override
  String get discount20 => 'Скидка 20%';

  @override
  String get discount30 => 'Скидка 30%';

  @override
  String get discountAmount => 'Сэкономить';

  @override
  String discountAmountValue(String amount) {
    return 'Сэкономить ₩$amount';
  }

  @override
  String get done => 'Готово';

  @override
  String get downloadingPersonaImages =>
      'Загрузка новых изображений персонажей';

  @override
  String get edit => 'Редактировать';

  @override
  String get editInfo => 'Редактировать информацию';

  @override
  String get editProfile => 'Редактировать профиль';

  @override
  String get effectSound => 'Звуковые эффекты';

  @override
  String get effectSoundDescription => 'Воспроизводить звуковые эффекты';

  @override
  String get email => 'Электронная почта';

  @override
  String get emailHint => 'example@email.com';

  @override
  String get emailLabel => 'Электронная почта';

  @override
  String get emailRequired => 'Электронная почта *';

  @override
  String get emotionAnalysis => 'Анализ эмоций';

  @override
  String get emotionAnalysisDesc =>
      'Анализируйте эмоции для эмпатичных ответов';

  @override
  String get emotionAngry => 'Сердитый';

  @override
  String get emotionBasedEncounters => 'Встречи на основе эмоций';

  @override
  String get emotionCool => 'Классный';

  @override
  String get emotionHappy => 'Счастливый';

  @override
  String get emotionLove => 'Любовь';

  @override
  String get emotionSad => 'Грустный';

  @override
  String get emotionThinking => 'Думающий';

  @override
  String get emotionalSupportDesc =>
      'Поделитесь своими переживаниями и получите теплую поддержку';

  @override
  String get endChat => 'Завершить чат';

  @override
  String get endTutorial => 'Завершить обучение';

  @override
  String get endTutorialAndLogin => 'Завершить обучение и войти?';

  @override
  String get endTutorialMessage => 'Вы хотите завершить обучение и войти?';

  @override
  String get english => 'Английский';

  @override
  String get enterBasicInfo =>
      'Пожалуйста, введите основную информацию для создания аккаунта';

  @override
  String get enterBasicInformation => 'Пожалуйста, введите основную информацию';

  @override
  String get enterEmail => 'Пожалуйста, введите email';

  @override
  String get enterNickname => 'Введите никнейм';

  @override
  String get enterPassword => 'Введите пароль';

  @override
  String get entertainmentAndFunDesc =>
      'Наслаждайтесь увлекательными играми и приятными беседами';

  @override
  String get entertainmentDescription =>
      'Я хочу вести интересные беседы и хорошо проводить время';

  @override
  String get entertainmentFun => 'Развлечения/Увлечения';

  @override
  String get error => 'Ошибка';

  @override
  String get errorDescription => 'Описание ошибки';

  @override
  String get errorDescriptionHint =>
      'например, давал странные ответы, повторяет одно и то же, дает контекстуально неуместные ответы...';

  @override
  String get errorDetails => 'Подробности ошибки';

  @override
  String get errorDetailsHint => 'Пожалуйста, подробно объясните, что не так';

  @override
  String get errorFrequency24h => 'Частота ошибок (за последние 24 часа)';

  @override
  String get errorMessage => 'Сообщение об ошибке:';

  @override
  String get errorOccurred => 'Произошла ошибка.';

  @override
  String get errorOccurredTryAgain =>
      'Произошла ошибка. Пожалуйста, попробуйте снова.';

  @override
  String get errorSendingFailed => 'Не удалось отправить ошибку';

  @override
  String get errorStats => 'Статистика ошибок';

  @override
  String errorWithMessage(String error) {
    return 'Произошла ошибка: $error';
  }

  @override
  String get evening => 'Вечер';

  @override
  String get excited => 'В восторге';

  @override
  String get exit => 'Выход';

  @override
  String get exitApp => 'Выход из приложения';

  @override
  String get exitConfirmMessage =>
      'Вы уверены, что хотите выйти из приложения?';

  @override
  String get expertPersona => 'Экспертная персона';

  @override
  String get expertiseScore => 'Оценка экспертизы';

  @override
  String get expired => 'Истекло';

  @override
  String get explainReportReason =>
      'Пожалуйста, подробно объясните причину жалобы';

  @override
  String get fashion => 'Мода';

  @override
  String get female => 'Женский';

  @override
  String get filter => 'Фильтр';

  @override
  String get firstOccurred => 'Произошло впервые:';

  @override
  String get followDeviceLanguage => 'Следовать настройкам языка устройства';

  @override
  String get forenoon => 'Утро';

  @override
  String get forgotPassword => 'Забыли пароль?';

  @override
  String get frequentlyAskedQuestions => 'Часто задаваемые вопросы';

  @override
  String get friday => 'Пятница';

  @override
  String get friendshipDescription =>
      'Я хочу познакомиться с новыми друзьями и пообщаться';

  @override
  String get funChat => 'Веселый Чат';

  @override
  String get galleryPermission => 'Разрешение галереи';

  @override
  String get galleryPermissionDesc =>
      'Доступ к галерее необходим для выбора фотографий профиля.';

  @override
  String get gaming => 'Игры';

  @override
  String get gender => 'Пол';

  @override
  String get genderNotSelectedInfo =>
      'Если пол не выбран, будут показаны персонажи всех полов';

  @override
  String get genderOptional => 'Пол (необязательно)';

  @override
  String get genderPreferenceActive =>
      'Вы можете встречать персонажей всех полов';

  @override
  String get genderPreferenceDisabled =>
      'Выберите свой пол, чтобы активировать опцию только для противоположного пола';

  @override
  String get genderPreferenceInactive =>
      'Будут показаны только персонажи противоположного пола';

  @override
  String get genderRequired => 'Пол *';

  @override
  String get genderSelectionInfo =>
      'Если не выбран, вы можете встречать персонажей всех полов';

  @override
  String get generalPersona => 'Общий Персонаж';

  @override
  String get goToSettings => 'Перейти в настройки';

  @override
  String get permissionGuideAndroid =>
      'Настройки > Приложения > SONA > Разрешения\nРазрешите доступ к фото';

  @override
  String get permissionGuideIOS =>
      'Настройки > SONA > Фото\nРазрешите доступ к фото';

  @override
  String get googleLoginCanceled =>
      'Вход через Google был отменен. Пожалуйста, попробуйте снова.';

  @override
  String get googleLoginError => 'Произошла ошибка при входе через Google.';

  @override
  String get grantPermission => 'Продолжить';

  @override
  String get guest => 'Гость';

  @override
  String get guestDataMigration =>
      'Хотите сохранить текущую историю чата при регистрации?';

  @override
  String get guestLimitReached =>
      'Пробный период для гостей закончился. Зарегистрируйтесь для неограниченных разговоров!';

  @override
  String get guestLoginPromptMessage => 'Войдите, чтобы продолжить разговор';

  @override
  String get guestMessageExhausted => 'Бесплатные сообщения исчерпаны';

  @override
  String guestMessageRemaining(int count) {
    return 'Осталось $count сообщений для гостей';
  }

  @override
  String get guestModeBanner => 'Режим Гостя';

  @override
  String get guestModeDescription => 'Попробуйте SONA без регистрации';

  @override
  String get guestModeFailedMessage => 'Не удалось запустить Режим Гостя';

  @override
  String get guestModeLimitation =>
      'Некоторые функции ограничены в Режиме Гостя';

  @override
  String get guestModeTitle => 'Попробовать как Гость';

  @override
  String get guestModeWarning =>
      'Режим Гостя действует 24 часа, после чего данные будут удалены.';

  @override
  String get guestModeWelcome => 'Запуск в Режиме Гостя';

  @override
  String get happy => 'Счастлив';

  @override
  String get hapticFeedback => 'Тактильная обратная связь';

  @override
  String get harassmentBullying => 'Домогательства/Буллинг';

  @override
  String get hateSpeech => 'Речь ненависти';

  @override
  String get heartDescription => 'Сердца для больше сообщений';

  @override
  String get heartInsufficient => 'Недостаточно сердец';

  @override
  String get heartInsufficientPleaseCharge =>
      'Недостаточно сердец. Пожалуйста, пополните сердца.';

  @override
  String get heartRequired => 'Требуется 1 сердце';

  @override
  String get heartUsageFailed => 'Не удалось использовать сердце.';

  @override
  String get hearts => 'Сердца';

  @override
  String get hearts10 => '10 Сердец';

  @override
  String get hearts30 => '30 Сердец';

  @override
  String get hearts30Discount => 'СКИДКА';

  @override
  String get hearts50 => '50 Сердец';

  @override
  String get hearts50Discount => 'СКИДКА';

  @override
  String get helloEmoji => 'Привет! 😊';

  @override
  String get help => 'Помощь';

  @override
  String get hideOriginalText => 'Скрыть оригинал';

  @override
  String get hobbySharing => 'Обмен хобби';

  @override
  String get hobbyTalk => 'Разговоры о хобби';

  @override
  String get hours24Ago => '24 часа назад';

  @override
  String hoursAgo(int count, String formatted) {
    return '$count часов назад';
  }

  @override
  String get howToUse => 'Как использовать SONA';

  @override
  String get imageCacheManagement => 'Управление кэшем изображений';

  @override
  String get inappropriateContent => 'Неприемлемый контент';

  @override
  String get incorrect => 'incorrect';

  @override
  String get incorrectPassword => 'Неверный пароль';

  @override
  String get indonesian => 'Indonesian';

  @override
  String get inquiries => 'Inquiries';

  @override
  String get insufficientHearts => 'Insufficient hearts.';

  @override
  String get interestSharing => 'Interest Sharing';

  @override
  String get interestSharingDesc => 'Discover and recommend shared interests';

  @override
  String get interests => 'Интересы';

  @override
  String get invalidEmailFormat => 'Неверный формат email';

  @override
  String get invalidEmailFormatError =>
      'Введите действительный адрес электронной почты';

  @override
  String isTyping(String name) {
    return '$name is typing...';
  }

  @override
  String get japanese => 'Japanese';

  @override
  String get joinDate => 'Join Date';

  @override
  String get justNow => 'Только что';

  @override
  String get keepGuestData => 'Keep Chat History';

  @override
  String get korean => 'Korean';

  @override
  String get koreanLanguage => 'Korean';

  @override
  String get language => 'Язык';

  @override
  String get languageDescription => 'AI will respond in your selected language';

  @override
  String get languageIndicator => 'Language';

  @override
  String get languageSettings => 'Настройки языка';

  @override
  String get lastOccurred => 'Последний раз:';

  @override
  String get lastUpdated => 'Последнее обновление';

  @override
  String get lateNight => 'Поздно ночью';

  @override
  String get later => 'Позже';

  @override
  String get laterButton => 'Позже';

  @override
  String get leave => 'Выйти';

  @override
  String get leaveChatConfirm => 'Выйти из этого чата?';

  @override
  String get leaveChatRoom => 'Выйти из чата';

  @override
  String get leaveChatTitle => 'Выйти из чата';

  @override
  String get lifeAdvice => 'Советы по жизни';

  @override
  String get lightTalk => 'Легкая беседа';

  @override
  String get lightTheme => 'Светлый режим';

  @override
  String get lightThemeDesc => 'Использовать светлую тему';

  @override
  String get loading => 'Загрузка...';

  @override
  String get loadingData => 'Загружается данные...';

  @override
  String get loadingProducts => 'Загрузка продуктов...';

  @override
  String get loadingProfile => 'Загружается профиль';

  @override
  String get login => 'Войти';

  @override
  String get loginButton => 'Войти';

  @override
  String get loginCancelled => 'Вход отменён';

  @override
  String get loginComplete => 'Вход выполнен';

  @override
  String get loginError => 'Ошибка входа';

  @override
  String get loginFailed => 'Ошибка входа';

  @override
  String get loginFailedTryAgain => 'Ошибка входа. Попробуйте снова.';

  @override
  String get loginRequired => 'Необходим вход';

  @override
  String get loginRequiredForProfile => 'Необходим вход для просмотра профиля';

  @override
  String get loginRequiredService =>
      'Для использования этого сервиса требуется вход';

  @override
  String get loginRequiredTitle => 'Необходим вход';

  @override
  String get loginSignup => 'Вход/Регистрация';

  @override
  String get loginTab => 'Вход';

  @override
  String get loginTitle => 'Вход';

  @override
  String get loginWithApple => 'Войти через Apple';

  @override
  String get loginWithGoogle => 'Войти через Google';

  @override
  String get logout => 'Выход';

  @override
  String get logoutConfirm => 'Вы уверены, что хотите выйти?';

  @override
  String get lonelinessRelief => 'Облегчение одиночества';

  @override
  String get lonely => 'Одинокий';

  @override
  String get lowQualityResponses => 'Низкокачественные ответы';

  @override
  String get lunch => 'Обед';

  @override
  String get lunchtime => 'Время обеда';

  @override
  String get mainErrorType => 'Основной тип ошибки';

  @override
  String get makeFriends => 'Найти друзей';

  @override
  String get male => 'Мужской';

  @override
  String get manageBlockedAIs => 'Управление заблокированными ИИ';

  @override
  String get managePersonaImageCache =>
      'Управление кэшем изображений персонажей';

  @override
  String get marketingAgree =>
      'Согласие на получение маркетинговой информации (по желанию)';

  @override
  String get marketingDescription =>
      'Вы можете получать информацию о событиях и преимуществах';

  @override
  String get matchPersonaStep =>
      '1. Сопоставление персонажей: Проведите влево или вправо, чтобы выбрать своих любимых ИИ-персонажей.';

  @override
  String get matchedPersonas => 'Сопоставленные персонажи';

  @override
  String get matchedSona => 'Сопоставленный SONA';

  @override
  String get matching => 'Сопоставление';

  @override
  String get matchingFailed => 'Сопоставление не удалось.';

  @override
  String get me => 'Me';

  @override
  String get meetAIPersonas => 'Познакомьтесь с ИИ-персонажами';

  @override
  String get meetNewPersonas => 'Встретить новые персоны';

  @override
  String get meetPersonas => 'Познакомьтесь с персонажами';

  @override
  String get memberBenefits =>
      'Получите 100+ сообщений и 10 сердечек при регистрации!';

  @override
  String get memoryAlbum => 'Альбом воспоминаний';

  @override
  String get memoryAlbumDesc =>
      'Автоматически сохраняйте и вспоминайте особые моменты';

  @override
  String get messageCopied => 'Сообщение скопировано';

  @override
  String get messageDeleted => 'Сообщение удалено';

  @override
  String get messageLimitReset => 'Лимит сообщений сбросится в полночь';

  @override
  String get messageSendFailed =>
      'Не удалось отправить сообщение. Пожалуйста, попробуйте снова.';

  @override
  String get messagesRemaining => 'Осталось сообщений';

  @override
  String minutesAgo(int count, String formatted) {
    return '$count минут назад';
  }

  @override
  String get missingTranslation => 'Отсутствует перевод';

  @override
  String get monday => 'Понедельник';

  @override
  String get month => 'Месяц';

  @override
  String monthDay(String month, int day) {
    return '$month $day';
  }

  @override
  String get moreButton => 'Ещё';

  @override
  String get morning => 'Утро';

  @override
  String get mostFrequentError => 'Наиболее частая ошибка';

  @override
  String get movies => 'Фильмы';

  @override
  String get multilingualChat => 'Многоязычный чат';

  @override
  String get music => 'Музыка';

  @override
  String get myGenderSection => 'Мой пол (необязательно)';

  @override
  String get networkErrorOccurred => 'Произошла ошибка сети.';

  @override
  String get newMessage => 'Новое сообщение';

  @override
  String newMessageCount(int count) {
    return '$count новых сообщений';
  }

  @override
  String get newMessageNotification => 'Уведомление о новом сообщении';

  @override
  String get newMessages => 'Новые сообщения';

  @override
  String get newYear => 'Новый год';

  @override
  String get next => 'Далее';

  @override
  String get niceToMeetYou => 'Приятно познакомиться!';

  @override
  String get nickname => 'Никнейм';

  @override
  String get nicknameAlreadyUsed => 'Этот никнейм уже используется';

  @override
  String get nicknameHelperText => '3-10 символов';

  @override
  String get nicknameHint => '3-10 символов';

  @override
  String get nicknameInUse => 'Этот никнейм уже используется';

  @override
  String get nicknameLabel => 'Никнейм';

  @override
  String get nicknameLengthError => 'Никнейм должен быть от 3 до 10 символов';

  @override
  String get nicknamePlaceholder => 'Введите ваш никнейм';

  @override
  String get nicknameRequired => 'Никнейм *';

  @override
  String get night => 'Ночь';

  @override
  String get no => 'Нет';

  @override
  String get noBlockedAIs => 'Нет заблокированных ИИ';

  @override
  String get noChatsYet => 'Пока нет чатов';

  @override
  String get noConversationYet => 'Пока нет разговора';

  @override
  String get noErrorReports => 'Нет отчетов об ошибках.';

  @override
  String get noImageAvailable => 'Изображение недоступно';

  @override
  String get noMatchedPersonas => 'Пока нет подходящих персон';

  @override
  String get noMatchedSonas => 'Пока нет совпадающих SONA';

  @override
  String get noPersonasAvailable =>
      'Нет доступных персонажей. Пожалуйста, попробуйте снова.';

  @override
  String get noPersonasToSelect => 'Нет доступных персонажей';

  @override
  String get noQualityIssues => 'Нет проблем с качеством за последний час ✅';

  @override
  String get noQualityLogs => 'Пока нет записей о качестве.';

  @override
  String get noTranslatedMessages => 'Нет сообщений для перевода';

  @override
  String get notEnoughHearts => 'Недостаточно сердец';

  @override
  String notEnoughHeartsCount(int count) {
    return 'Недостаточно сердец. (Текущие: $count)';
  }

  @override
  String get notRegistered => 'не зарегистрирован';

  @override
  String get notSubscribed => 'Не подписан';

  @override
  String get notificationPermissionDesc =>
      'Разрешение на уведомления необходимо для получения новых сообщений.';

  @override
  String get notificationPermissionRequired =>
      'Требуется разрешение на уведомления';

  @override
  String get notificationSettings => 'Настройки уведомлений';

  @override
  String get notifications => 'Уведомления';

  @override
  String get occurrenceInfo => 'Информация о событии:';

  @override
  String get olderChats => 'Старые';

  @override
  String get onlyOppositeGenderNote =>
      'Если не отмечено, будут показаны только персонажи противоположного пола';

  @override
  String get openSettings => 'Открыть настройки';

  @override
  String get optional => 'Необязательно';

  @override
  String get or => 'or';

  @override
  String get originalPrice => 'Оригинальная';

  @override
  String get originalText => 'Оригинальный';

  @override
  String get other => 'Другой';

  @override
  String get otherError => 'Другая ошибка';

  @override
  String get others => 'Другие';

  @override
  String get ownedHearts => 'Владение сердцами';

  @override
  String get parentsDay => 'День родителей';

  @override
  String get password => 'Пароль';

  @override
  String get passwordConfirmation => 'Введите пароль для подтверждения';

  @override
  String get passwordConfirmationDesc =>
      'Пожалуйста, введите свой пароль еще раз, чтобы удалить аккаунт.';

  @override
  String get passwordHint => '6 символов или больше';

  @override
  String get passwordLabel => 'Пароль';

  @override
  String get passwordRequired => 'Пароль *';

  @override
  String get passwordResetEmailPrompt =>
      'Пожалуйста, введите свой адрес электронной почты для сброса пароля';

  @override
  String get passwordResetEmailSent =>
      'Письмо для сброса пароля было отправлено. Пожалуйста, проверьте свою почту.';

  @override
  String get passwordText => 'пароль';

  @override
  String get passwordTooShort => 'Пароль должен содержать не менее 6 символов';

  @override
  String get permissionDenied => 'В разрешении отказано';

  @override
  String permissionDeniedMessage(String permissionName) {
    return 'Доступ к $permissionName был запрещен.\\nПожалуйста, разрешите доступ в настройках.';
  }

  @override
  String get permissionDeniedTryLater =>
      'Доступ запрещен. Пожалуйста, попробуйте позже.';

  @override
  String get permissionRequired => 'Требуется разрешение';

  @override
  String get personaGenderSection => 'Предпочтения по полу персонажа';

  @override
  String get personaQualityStats => 'Статистика качества персонажа';

  @override
  String get personalInfoExposure => 'Раскрытие личной информации';

  @override
  String get personality => 'Настройки Личности';

  @override
  String get pets => 'Питомцы';

  @override
  String get photo => 'Фото';

  @override
  String get photography => 'Фотография';

  @override
  String get picnic => 'Пикник';

  @override
  String get preferenceSettings => 'Настройки предпочтений';

  @override
  String get preferredLanguage => 'Предпочитаемый язык';

  @override
  String get preparingForSleep => 'Подготовка ко сну';

  @override
  String get preparingNewMeeting => 'Подготовка новой встречи';

  @override
  String get preparingPersonaImages => 'Подготовка изображений персонажей';

  @override
  String get preparingPersonas => 'Подготовка персонажей';

  @override
  String get preview => 'Предварительный просмотр';

  @override
  String get previous => 'Назад';

  @override
  String get privacy => 'Конфиденциальность';

  @override
  String get privacyPolicy => 'Политика конфиденциальности';

  @override
  String get privacyPolicyAgreement => 'Примите политику конфиденциальности';

  @override
  String get privacySection1Content =>
      'Мы стремимся защищать вашу конфиденциальность. Эта Политика конфиденциальности объясняет, как мы собираем, используем и защищаем вашу информацию, когда вы пользуетесь нашим сервисом.';

  @override
  String get privacySection1Title =>
      '1. Цель сбора и использования личной информации';

  @override
  String get privacySection2Content =>
      'Мы собираем информацию, которую вы предоставляете нам напрямую, например, когда вы создаете учетную запись, обновляете свой профиль или используете наши услуги.';

  @override
  String get privacySection2Title => 'Информация, которую мы собираем';

  @override
  String get privacySection3Content =>
      'Мы используем собранную информацию для предоставления, поддержания и улучшения наших услуг, а также для связи с вами.';

  @override
  String get privacySection3Title =>
      '3. Срок хранения и использования персональной информации';

  @override
  String get privacySection4Content =>
      'Мы не продаем, не обмениваем и не передаем вашу персональную информацию третьим лицам без вашего согласия.';

  @override
  String get privacySection4Title =>
      '4. Предоставление персональной информации третьим лицам';

  @override
  String get privacySection5Content =>
      'Мы принимаем соответствующие меры безопасности для защиты вашей персональной информации от несанкционированного доступа, изменения, раскрытия или уничтожения.';

  @override
  String get privacySection5Title =>
      '5. Технические меры защиты персональной информации';

  @override
  String get privacySection6Content =>
      'Мы храним персональную информацию столько, сколько необходимо для предоставления наших услуг и выполнения юридических обязательств.';

  @override
  String get privacySection6Title => '6. Права пользователей';

  @override
  String get privacySection7Content =>
      'Вы имеете право в любой момент получить доступ к своей персональной информации, обновить ее или удалить через настройки вашего аккаунта.';

  @override
  String get privacySection7Title => 'Ваши права';

  @override
  String get privacySection8Content =>
      'Если у вас есть вопросы по данной Политике конфиденциальности, пожалуйста, свяжитесь с нами по адресу support@sona.com.';

  @override
  String get privacySection8Title => 'Свяжитесь с нами';

  @override
  String get privacySettings => 'Настройки конфиденциальности';

  @override
  String get privacySettingsInfo =>
      'Отключение отдельных функций сделает эти услуги недоступными';

  @override
  String get privacySettingsScreen => 'Настройки конфиденциальности';

  @override
  String get problemMessage => 'Проблема';

  @override
  String get problemOccurred => 'Произошла ошибка';

  @override
  String get profile => 'Профиль';

  @override
  String get profileEdit => 'Редактировать профиль';

  @override
  String get profileEditLoginRequiredMessage =>
      'Для редактирования профиля требуется вход в систему. Хотите перейти на экран входа?';

  @override
  String get profileInfo => 'Информация о профиле';

  @override
  String get profileInfoDescription =>
      'Пожалуйста, введите вашу фотографию профиля и основную информацию';

  @override
  String get profileNav => 'Профиль';

  @override
  String get profilePhoto => 'Фотография профиля';

  @override
  String get profilePhotoAndInfo =>
      'Пожалуйста, введите фотографию профиля и основную информацию';

  @override
  String get profilePhotoUpdateFailed =>
      'Не удалось обновить фотографию профиля';

  @override
  String get profilePhotoUpdated => 'Фотография профиля обновлена';

  @override
  String get profileSettings => 'Настройки профиля';

  @override
  String get profileSetup => 'Настройка профиля';

  @override
  String get profileUpdateFailed => 'Не удалось обновить профиль';

  @override
  String get profileUpdated => 'Профиль успешно обновлён';

  @override
  String get purchaseAndRefundPolicy => 'Политика покупки и возврата';

  @override
  String get purchaseButton => 'Купить';

  @override
  String get purchaseConfirm => 'Подтверждение покупки';

  @override
  String purchaseConfirmContent(String product, String price) {
    return 'Купить $product за $price?';
  }

  @override
  String purchaseConfirmMessage(
      String title, String price, String description) {
    return 'Подтвердить покупку $title за $price? $description';
  }

  @override
  String get purchaseFailed => 'Ошибка покупки';

  @override
  String get purchaseHeartsOnly => 'Купить сердца';

  @override
  String get purchaseMoreHearts => 'Купите сердца, чтобы продолжить разговоры';

  @override
  String get purchasePending => 'Покупка в ожидании...';

  @override
  String get purchasePolicy => 'Политика покупок';

  @override
  String get purchaseSection1Content =>
      'Мы принимаем различные способы оплаты, включая кредитные карты и цифровые кошельки.';

  @override
  String get purchaseSection1Title => 'Способы оплаты';

  @override
  String get purchaseSection2Content =>
      'Возврат средств возможен в течение 14 дней с момента покупки, если вы не использовали приобретенные товары.';

  @override
  String get purchaseSection2Title => 'Политика возврата';

  @override
  String get purchaseSection3Content =>
      'Вы можете отменить свою подписку в любое время через настройки аккаунта.';

  @override
  String get purchaseSection3Title => 'Отмена';

  @override
  String get purchaseSection4Content =>
      'Совершая покупку, вы соглашаетесь с нашими условиями использования и соглашением об обслуживании.';

  @override
  String get purchaseSection4Title => 'Условия использования';

  @override
  String get purchaseSection5Content =>
      'По вопросам, связанным с покупками, пожалуйста, свяжитесь с нашей службой поддержки.';

  @override
  String get purchaseSection5Title => 'Связаться с поддержкой';

  @override
  String get purchaseSection6Content =>
      'Все покупки подлежат нашим стандартным условиям и положениям.';

  @override
  String get purchaseSection6Title => '6. Запросы';

  @override
  String get pushNotifications => 'Push-уведомления';

  @override
  String get reading => 'Чтение';

  @override
  String get realtimeQualityLog => 'Журнал качества в реальном времени';

  @override
  String get recentConversation => 'Недавний разговор:';

  @override
  String get recentLoginRequired =>
      'Пожалуйста, войдите снова для безопасности';

  @override
  String get referrerEmail => 'Email реферера';

  @override
  String get referrerEmailHelper =>
      'Необязательно: Email того, кто вас пригласил';

  @override
  String get referrerEmailLabel => 'Email реферера (необязательно)';

  @override
  String get refresh => 'Обновить';

  @override
  String refreshComplete(int count) {
    return 'Обновление завершено! $count совпадающих персонажей';
  }

  @override
  String get refreshFailed => 'Ошибка обновления';

  @override
  String get refreshingChatList => 'Обновление списка чатов...';

  @override
  String get relatedFAQ => 'Связанные часто задаваемые вопросы';

  @override
  String get report => 'Пожаловаться';

  @override
  String get reportAI => 'Пожаловаться';

  @override
  String get reportAIDescription =>
      'Если ИИ вызвал у вас дискомфорт, пожалуйста, опишите проблему.';

  @override
  String get reportAITitle => 'Пожаловаться на разговор с ИИ';

  @override
  String get reportAndBlock => 'Пожаловаться и заблокировать';

  @override
  String get reportAndBlockDescription =>
      'Вы можете пожаловаться и заблокировать неподобающее поведение этого ИИ';

  @override
  String get reportChatError => 'Пожаловаться на ошибку в чате';

  @override
  String reportError(String error) {
    return 'Произошла ошибка при подаче жалобы: $error';
  }

  @override
  String get reportFailed => 'Жалоба не удалась';

  @override
  String get reportSubmitted =>
      'Жалоба отправлена. Мы рассмотрим и примем меры.';

  @override
  String get reportSubmittedSuccess => 'Ваша жалоба была отправлена. Спасибо!';

  @override
  String get requestLimit => 'Лимит запросов';

  @override
  String get required => '[Обязательно]';

  @override
  String get requiredTermsAgreement => 'Пожалуйста, согласитесь с условиями';

  @override
  String get restartConversation => 'Перезапустить разговор';

  @override
  String restartConversationQuestion(String name) {
    return 'Вы хотите перезапустить разговор с $name?';
  }

  @override
  String restartConversationWithName(String name) {
    return 'Перезапускаем разговор с $name!';
  }

  @override
  String get retry => 'Повторить';

  @override
  String get retryButton => 'Повторить';

  @override
  String get sad => 'Грустный';

  @override
  String get saturday => 'Суббота';

  @override
  String get save => 'Сохранить';

  @override
  String get search => 'Поиск';

  @override
  String get searchFAQ => 'Поиск FAQ...';

  @override
  String get searchResults => 'Результаты поиска';

  @override
  String get selectEmotion => 'Выберите эмоцию';

  @override
  String get selectErrorType => 'Выберите тип ошибки';

  @override
  String get selectFeeling => 'Выберите чувство';

  @override
  String get selectGender => 'Пожалуйста, выберите пол';

  @override
  String get selectInterests => 'Выберите ваши интересы';

  @override
  String get selectLanguage => 'Выберите язык';

  @override
  String get selectPersona => 'Выберите персонажа';

  @override
  String get selectPersonaPlease => 'Пожалуйста, выберите персонажа.';

  @override
  String get selectPreferredMbti =>
      'Если вы предпочитаете персонажей с определёнными типами MBTI, пожалуйста, выберите';

  @override
  String get selectProblematicMessage =>
      'Выберите проблемное сообщение (необязательно)';

  @override
  String get chatErrorAnalysisInfo => 'Анализ последних 10 разговоров.';

  @override
  String get whatWasAwkward => 'Что показалось странным?';

  @override
  String get errorExampleHint =>
      'Например: Странная манера речи (окончания ~nya)...';

  @override
  String get selectReportReason => 'Выберите причину жалобы';

  @override
  String get selectTheme => 'Выберите тему';

  @override
  String get selectTranslationError =>
      'Пожалуйста, выберите сообщение с ошибкой перевода';

  @override
  String get selectUsagePurpose =>
      'Пожалуйста, выберите вашу цель использования SONA';

  @override
  String get selfIntroduction => 'Введение (необязательно)';

  @override
  String get selfIntroductionHint => 'Напишите краткое введение о себе';

  @override
  String get send => 'Отправить';

  @override
  String get sendChatError => 'Ошибка отправки чата';

  @override
  String get sendFirstMessage => 'Отправьте ваше первое сообщение';

  @override
  String get sendReport => 'Отправить жалобу';

  @override
  String get sendingEmail => 'Отправка электронной почты...';

  @override
  String get seoul => 'Сеул';

  @override
  String get serverErrorDashboard => 'Ошибка сервера';

  @override
  String get serviceTermsAgreement =>
      'Пожалуйста, согласитесь с условиями обслуживания';

  @override
  String get sessionExpired => 'Сессия истекла';

  @override
  String get setAppInterfaceLanguage => 'Установить язык интерфейса приложения';

  @override
  String get setNow => 'Установить сейчас';

  @override
  String get settings => 'Настройки';

  @override
  String get sexualContent => 'Сексуальный контент';

  @override
  String get showAllGenderPersonas => 'Показать персонажей всех полов';

  @override
  String get showAllGendersOption => 'Показать все полы';

  @override
  String get showOppositeGenderOnly =>
      'Если не отмечено, будут показаны только персонажи противоположного пола';

  @override
  String get showOriginalText => 'Показать оригинал';

  @override
  String get signUp => 'Регистрация';

  @override
  String get signUpFromGuest =>
      'Зарегистрируйтесь сейчас, чтобы получить доступ ко всем функциям!';

  @override
  String get signup => 'Регистрация';

  @override
  String get signupComplete => 'Регистрация завершена';

  @override
  String get signupTab => 'Регистрация';

  @override
  String get simpleInfoRequired => 'Требуется простая информация';

  @override
  String get skip => 'Пропустить';

  @override
  String get sonaFriend => 'SONA Друг';

  @override
  String get sonaPrivacyPolicy => 'Политика конфиденциальности SONA';

  @override
  String get sonaPurchasePolicy => 'Политика покупок SONA';

  @override
  String get sonaTermsOfService => 'Условия обслуживания SONA';

  @override
  String get sonaUsagePurpose => 'Пожалуйста, выберите цель использования SONA';

  @override
  String get sorryNotHelpful => 'Извините, это не помогло';

  @override
  String get sort => 'Сортировка';

  @override
  String get soundSettings => 'Настройки звука';

  @override
  String get spamAdvertising => 'Спам/Реклама';

  @override
  String get spanish => 'Испанский';

  @override
  String get specialRelationshipDesc =>
      'Понимать друг друга и строить глубокие связи';

  @override
  String get sports => 'Спорт';

  @override
  String get spring => 'Весна';

  @override
  String get startChat => 'Начать чат';

  @override
  String get startChatButton => 'Начать чат';

  @override
  String get startConversation => 'Начать разговор';

  @override
  String get startConversationLikeAFriend =>
      'Начать разговор с SONA как с другом';

  @override
  String get startConversationStep =>
      '2. Начать разговор: Общайтесь свободно с подобранными персонами.';

  @override
  String get startConversationWithSona =>
      'Начните общаться с SONA как с другом!';

  @override
  String get startWithEmail => 'Начать с электронной почты';

  @override
  String get startWithGoogle => 'Начать с Google';

  @override
  String get startingApp => 'Запуск приложения';

  @override
  String get storageManagement => 'Управление хранилищем';

  @override
  String get store => 'Магазин';

  @override
  String get storeConnectionError => 'Не удалось подключиться к магазину';

  @override
  String get storeLoginRequiredMessage =>
      'Для использования магазина требуется вход в систему. Хотите перейти на экран входа?';

  @override
  String get storeNotAvailable => 'Магазин недоступен';

  @override
  String get storyEvent => 'Событие истории';

  @override
  String get stressed => 'В стрессовом состоянии';

  @override
  String get submitReport => 'Отправить отчет';

  @override
  String get subscriptionStatus => 'Статус подписки';

  @override
  String get subtleVibrationOnTouch => 'Легкая вибрация при касании';

  @override
  String get summer => 'Лето';

  @override
  String get sunday => 'Воскресенье';

  @override
  String get swipeAnyDirection => 'Проведите в любом направлении';

  @override
  String get swipeDownToClose => 'Проведите вниз, чтобы закрыть';

  @override
  String get systemTheme => 'Следовать системным настройкам';

  @override
  String get systemThemeDesc =>
      'Автоматически меняется в зависимости от настроек темной темы устройства';

  @override
  String get tapBottomForDetails => 'Нажмите внизу для подробностей';

  @override
  String get tapForDetails => 'Нажмите на нижнюю область для подробностей';

  @override
  String get tapToSwipePhotos => 'Нажмите, чтобы пролистать фото';

  @override
  String get teachersDay => 'День учителя';

  @override
  String get technicalError => 'Техническая ошибка';

  @override
  String get technology => 'Технология';

  @override
  String get terms => 'Условия обслуживания';

  @override
  String get termsAgreement => 'Согласие с условиями';

  @override
  String get termsAgreementDescription =>
      'Пожалуйста, согласитесь с условиями использования сервиса';

  @override
  String get termsOfService => 'Условия использования';

  @override
  String get termsSection10Content =>
      'Мы оставляем за собой право в любое время изменять эти условия с уведомлением пользователей.';

  @override
  String get termsSection10Title => 'Статья 10 (Разрешение споров)';

  @override
  String get termsSection11Content =>
      'Эти условия регулируются законами юрисдикции, в которой мы работаем.';

  @override
  String get termsSection11Title =>
      'Статья 11 (Особые положения об ИИ-сервисах)';

  @override
  String get termsSection12Content =>
      'Если какое-либо положение этих условий будет признано неисполнимым, остальные положения останутся в полной силе и действии.';

  @override
  String get termsSection12Title => 'Статья 12 (Сбор и использование данных)';

  @override
  String get termsSection1Content =>
      'Эти условия и положения направлены на определение прав, обязанностей и ответственности между SONA (в дальнейшем \"Компания\") и пользователями в отношении использования сервиса сопоставления разговоров с AI персонажем (в дальнейшем \"Сервис\"), предоставляемого Компанией.';

  @override
  String get termsSection1Title => 'Статья 1 (Цель)';

  @override
  String get termsSection2Content =>
      'Используя наш сервис, вы соглашаетесь соблюдать эти Условия обслуживания и нашу Политику конфиденциальности.';

  @override
  String get termsSection2Title => 'Статья 2 (Определения)';

  @override
  String get termsSection3Content =>
      'Вы должны быть не моложе 13 лет, чтобы использовать наш сервис.';

  @override
  String get termsSection3Title => 'Статья 3 (Действие и изменение условий)';

  @override
  String get termsSection4Content =>
      'Вы несете ответственность за сохранение конфиденциальности вашего аккаунта и пароля.';

  @override
  String get termsSection4Title => 'Статья 4 (Предоставление сервиса)';

  @override
  String get termsSection5Content =>
      'Вы соглашаетесь не использовать наш сервис для каких-либо незаконных или несанкционированных целей.';

  @override
  String get termsSection5Title => 'Статья 5 (Регистрация участника)';

  @override
  String get termsSection6Content =>
      'Мы оставляем за собой право прекратить или приостановить ваш аккаунт за нарушение этих условий.';

  @override
  String get termsSection6Title => 'Статья 6 (Обязанности пользователя)';

  @override
  String get termsSection7Content =>
      'Компания может постепенно ограничивать использование сервиса через предупреждения, временные приостановки или постоянные приостановки, если пользователи нарушают обязательства этих условий или вмешиваются в нормальную работу сервиса.';

  @override
  String get termsSection7Title =>
      'Статья 7 (Ограничения на использование услуги)';

  @override
  String get termsSection8Content =>
      'Мы не несем ответственности за любые косвенные, случайные или последующие убытки, возникающие в результате вашего использования нашей услуги.';

  @override
  String get termsSection8Title => 'Статья 8 (Перерыв в обслуживании)';

  @override
  String get termsSection9Content =>
      'Все контенты и материалы, доступные в нашей услуге, защищены правами интеллектуальной собственности.';

  @override
  String get termsSection9Title => 'Статья 9 (Отказ от ответственности)';

  @override
  String get termsSupplementary => 'Дополнительные условия';

  @override
  String get thai => 'Тайский';

  @override
  String get thanksFeedback => 'Спасибо за ваш отзыв!';

  @override
  String get theme => 'Тема';

  @override
  String get themeDescription =>
      'Вы можете настроить внешний вид приложения по своему усмотрению';

  @override
  String get themeSettings => 'Настройки темы';

  @override
  String get thursday => 'Четверг';

  @override
  String get timeout => 'Время ожидания';

  @override
  String get tired => 'Устал';

  @override
  String get today => 'Сегодня';

  @override
  String get todayChats => 'Сегодня';

  @override
  String get todayText => 'Сегодня';

  @override
  String get tomorrowText => 'Завтра';

  @override
  String get totalConsultSessions => 'Всего консультационных сессий';

  @override
  String get totalErrorCount => 'Общее количество ошибок';

  @override
  String get totalLikes => 'Всего лайков';

  @override
  String totalOccurrences(Object count) {
    return 'Всего $count случаев';
  }

  @override
  String get totalResponses => 'Всего ответов';

  @override
  String get translatedFrom => 'Переведено';

  @override
  String get translatedText => 'Перевод';

  @override
  String get translationError => 'Ошибка перевода';

  @override
  String get translationErrorDescription =>
      'Пожалуйста, сообщите о некорректных переводах или неуклюжих выражениях';

  @override
  String get translationErrorReported => 'Ошибка перевода сообщена. Спасибо!';

  @override
  String get translationNote =>
      '※ Перевод с помощью ИИ может быть не идеальным';

  @override
  String get translationQuality => 'Качество перевода';

  @override
  String get translationSettings => 'Настройки перевода';

  @override
  String get travel => 'Путешествие';

  @override
  String get tuesday => 'Вторник';

  @override
  String get tutorialAccount => 'Учебный аккаунт';

  @override
  String get tutorialWelcomeDescription =>
      'Создавайте особые отношения с ИИ-персонажами.';

  @override
  String get tutorialWelcomeTitle => 'Добро пожаловать в SONA!';

  @override
  String get typeMessage => 'Напишите сообщение...';

  @override
  String get unblock => 'Разблокировать';

  @override
  String get unblockFailed => 'Не удалось разблокировать';

  @override
  String unblockPersonaConfirm(String name) {
    return 'Разблокировать $name?';
  }

  @override
  String get unblockedSuccessfully => 'Успешно разблокировано';

  @override
  String get unexpectedLoginError => 'Произошла неожиданная ошибка при входе';

  @override
  String get unknown => 'Неизвестно';

  @override
  String get unknownError => 'Неизвестная ошибка';

  @override
  String get unlimitedMessages => 'Неограниченно';

  @override
  String get unsendMessage => 'Отменить отправку сообщения';

  @override
  String get usagePurpose => 'Цель использования';

  @override
  String get useOneHeart => 'Использовать 1 Сердце';

  @override
  String get useSystemLanguage => 'Использовать системный язык';

  @override
  String get user => 'Пользователь:';

  @override
  String get userMessage => 'Сообщение пользователя:';

  @override
  String get userNotFound => 'Пользователь не найден';

  @override
  String get valentinesDay => 'День Святого Валентина';

  @override
  String get verifyingAuth => 'Проверка аутентификации';

  @override
  String get version => 'Версия';

  @override
  String get vietnamese => 'Вьетнамский';

  @override
  String get violentContent => 'Насильственный контент';

  @override
  String get voiceMessage => '🎤 Голосовое сообщение';

  @override
  String waitingForChat(String name) {
    return '$name ждет, чтобы пообщаться.';
  }

  @override
  String get walk => 'Прогулка';

  @override
  String get wasHelpful => 'Это было полезно?';

  @override
  String get weatherClear => 'Ясно';

  @override
  String get weatherCloudy => 'Облачно';

  @override
  String get weatherContext => 'Контекст погоды';

  @override
  String get weatherContextDesc =>
      'Предоставьте контекст разговора на основе погоды';

  @override
  String get weatherDrizzle => 'Морось';

  @override
  String get weatherFog => 'Туман';

  @override
  String get weatherMist => 'Туман';

  @override
  String get weatherRain => 'Дождь';

  @override
  String get weatherRainy => 'Дождливо';

  @override
  String get weatherSnow => 'Снег';

  @override
  String get weatherSnowy => 'Снежно';

  @override
  String get weatherThunderstorm => 'Гроза';

  @override
  String get wednesday => 'Среда';

  @override
  String get weekdays => 'Вс,Пн,Вт,Ср,Чт,Пт,Сб';

  @override
  String get welcomeMessage => 'Добро пожаловать💕';

  @override
  String get whatTopicsToTalk =>
      'О каких темах вы хотели бы поговорить? (Необязательно)';

  @override
  String get whiteDay => 'Белый день';

  @override
  String get winter => 'Зима';

  @override
  String get wrongTranslation => 'Неверный перевод';

  @override
  String get year => 'Год';

  @override
  String get yearEnd => 'Конец года';

  @override
  String get yes => 'Да';

  @override
  String get yesterday => 'Вчера';

  @override
  String get yesterdayChats => 'Вчера';

  @override
  String get you => 'Вы';

  @override
  String get loadingPersonaData => 'Загрузка данных персоны';

  @override
  String get checkingMatchedPersonas => 'Проверка совпавших персон';

  @override
  String get preparingImages => 'Подготовка изображений';

  @override
  String get finalPreparation => 'Финальная подготовка';

  @override
  String get editProfileSubtitle => 'Изменить пол, дату рождения и описание';

  @override
  String get systemThemeName => 'Система';

  @override
  String get lightThemeName => 'Светлая';

  @override
  String get darkThemeName => 'Темная';

  @override
  String get alwaysShowTranslationOn => 'Всегда показывать перевод';

  @override
  String get alwaysShowTranslationOff => 'Скрыть автоперевод';

  @override
  String get translationErrorAnalysisInfo =>
      'Мы проанализируем выбранное сообщение и его перевод.';

  @override
  String get whatWasWrongWithTranslation => 'Что было не так с переводом?';

  @override
  String get translationErrorHint =>
      'Например: Неверный смысл, неестественное выражение, неправильный контекст...';

  @override
  String get pleaseSelectMessage => 'Пожалуйста, сначала выберите сообщение';

  @override
  String get myPersonas => 'Мои Персоны';

  @override
  String get createPersona => 'Создать Персону';

  @override
  String get tellUsAboutYourPersona => 'Расскажите о вашей персоне';

  @override
  String get enterPersonaName => 'Введите имя персоны';

  @override
  String get describeYourPersona => 'Кратко опишите вашу персону';

  @override
  String get profileImage => 'Изображение профиля';

  @override
  String get uploadPersonaImages => 'Загрузите изображения для персоны';

  @override
  String get mainImage => 'Главное изображение';

  @override
  String get tapToUpload => 'Нажмите для загрузки';

  @override
  String get additionalImages => 'Дополнительные изображения';

  @override
  String get addImage => 'Добавить изображение';

  @override
  String get mbtiQuestion => 'Вопрос о личности';

  @override
  String get mbtiComplete => 'Тест личности завершен!';

  @override
  String get mbtiTest => 'Тест MBTI';

  @override
  String get mbtiStepDescription =>
      'Давайте определим, какая личность должна быть у вашей персоны. Ответьте на вопросы, чтобы сформировать ее характер.';

  @override
  String get startTest => 'Начать тест';

  @override
  String get personalitySettings => 'Настройки личности';

  @override
  String get speechStyle => 'Стиль Речи';

  @override
  String get conversationStyle => 'Стиль Разговора';

  @override
  String get shareWithCommunity => 'Поделиться с сообществом';

  @override
  String get shareDescription =>
      'Ваша персона может быть доступна другим пользователям после одобрения';

  @override
  String get sharePersona => 'Поделиться персоной';

  @override
  String get willBeSharedAfterApproval =>
      'Будет опубликовано после одобрения администратора';

  @override
  String get privatePersonaDescription => 'Только вы видите эту персону';

  @override
  String get create => 'Создать';

  @override
  String get personaCreated => 'Персона успешно создана';

  @override
  String get createFailed => 'Не удалось создать';

  @override
  String get pendingApproval => 'Ожидает Одобрения';

  @override
  String get approved => 'Одобрено';

  @override
  String get privatePersona => 'Приватная';

  @override
  String get noPersonasYet => 'Персон пока нет';

  @override
  String get createYourFirstPersona =>
      'Создайте свою первую персону и начните путешествие';

  @override
  String get deletePersona => 'Удалить Персону';

  @override
  String get deletePersonaConfirm =>
      'Вы уверены, что хотите удалить эту персону? Это действие нельзя отменить.';

  @override
  String get personaDeleted => 'Персона успешно удалена';

  @override
  String get deleteFailed => 'Не удалось удалить';

  @override
  String get personaLimitReached => 'Достигнут лимит в 3 персоны';

  @override
  String get personaName => 'Имя Персоны';

  @override
  String get personaAge => 'Возраст';

  @override
  String get personaDescription => 'Описание';

  @override
  String get personaNameHint => 'Например: Анна, Максим';

  @override
  String get personaDescriptionHint => 'Кратко опишите вашу персону';

  @override
  String get loginRequiredContent => 'Войдите, чтобы продолжить';

  @override
  String get reportErrorButton => 'Сообщить об ошибке';

  @override
  String get speechStyleFriendly => 'Дружелюбный';

  @override
  String get speechStylePolite => 'Вежливый';

  @override
  String get speechStyleChic => 'Стильный';

  @override
  String get speechStyleLively => 'Живой';

  @override
  String get conversationStyleTalkative => 'Разговорчивый';

  @override
  String get conversationStyleQuiet => 'Тихий';

  @override
  String get conversationStyleEmpathetic => 'Эмпатичный';

  @override
  String get conversationStyleLogical => 'Логичный';

  @override
  String get interestMusic => 'Музыка';

  @override
  String get interestMovies => 'Фильмы';

  @override
  String get interestReading => 'Чтение';

  @override
  String get interestTravel => 'Путешествия';

  @override
  String get interestExercise => 'Спорт';

  @override
  String get interestGaming => 'Игры';

  @override
  String get interestCooking => 'Кулинария';

  @override
  String get interestFashion => 'Мода';

  @override
  String get interestArt => 'Искусство';

  @override
  String get interestPhotography => 'Фотография';

  @override
  String get interestTechnology => 'Технологии';

  @override
  String get interestScience => 'Наука';

  @override
  String get interestHistory => 'История';

  @override
  String get interestPhilosophy => 'Философия';

  @override
  String get interestPolitics => 'Политика';

  @override
  String get interestEconomy => 'Экономика';

  @override
  String get interestSports => 'Спорт';

  @override
  String get interestAnimation => 'Анимация';

  @override
  String get interestKpop => 'K-POP';

  @override
  String get interestDrama => 'Драма';

  @override
  String get imageOptionalR2 =>
      'Изображения необязательны. Они будут загружены только при настройке R2.';

  @override
  String get networkErrorCheckConnection =>
      'Ошибка сети: Пожалуйста, проверьте подключение к интернету';

  @override
  String get maxFiveItems => 'До 5 элементов';

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
    return 'Начать разговор с $personaName?';
  }

  @override
  String reengagementNotificationSent(String personaName, String riskPercent) {
    return 'Уведомление о повторном вовлечении отправлено $personaName (Риск: $riskPercent%)';
  }

  @override
  String get noActivePersona => 'Нет активной персоны';

  @override
  String get noInternetConnection => 'Нет подключения к Интернету';

  @override
  String get internetRequiredMessage =>
      'Для использования SONA требуется подключение к интернету. Пожалуйста, проверьте ваше подключение и попробуйте снова.';

  @override
  String get retryConnection => 'Повторить';

  @override
  String get openNetworkSettings => 'Открыть настройки';

  @override
  String get checkingConnection => 'Проверка подключения...';

  @override
  String get editPersona => 'Редактировать персону';

  @override
  String get personaUpdated => 'Персона успешно обновлена';

  @override
  String get cannotEditApprovedPersona =>
      'Одобренные персоны нельзя редактировать';

  @override
  String get update => 'Обновить';
}
