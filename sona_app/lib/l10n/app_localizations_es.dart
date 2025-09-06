// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get about => 'Acerca de';

  @override
  String get accountAndProfile => 'Información de la cuenta y perfil';

  @override
  String get accountDeletedSuccess => 'Cuenta eliminada exitosamente';

  @override
  String get accountDeletionContent =>
      '¿Estás seguro de que deseas eliminar tu cuenta?';

  @override
  String get accountDeletionError => 'Ocurrió un error al eliminar la cuenta.';

  @override
  String get accountDeletionInfo => 'Información de eliminación de cuenta';

  @override
  String get accountDeletionTitle => 'Eliminar cuenta';

  @override
  String get accountDeletionWarning1 =>
      'Advertencia: Esta acción no se puede deshacer';

  @override
  String get accountDeletionWarning2 =>
      'Todos tus datos serán eliminados permanentemente';

  @override
  String get accountDeletionWarning3 =>
      'Perderás acceso a todas las conversaciones';

  @override
  String get accountDeletionWarning4 =>
      'Esto incluye todo el contenido comprado';

  @override
  String get accountManagement => 'Gestión de la cuenta';

  @override
  String get adaptiveConversationDesc =>
      'Adapta el estilo de conversación para que coincida con el tuyo';

  @override
  String get afternoon => 'Tarde';

  @override
  String get afternoonFatigue => 'Fatiga de la tarde';

  @override
  String get ageConfirmation =>
      'Tengo 14 años o más y he confirmado lo anterior.';

  @override
  String ageRange(int min, int max) {
    return '$min-$max años';
  }

  @override
  String get ageUnit => 'años';

  @override
  String get agreeToTerms => 'Acepto los términos';

  @override
  String get aiDatingQuestion => 'Una vida diaria especial con IA';

  @override
  String get aiPersonaPreferenceDescription =>
      'Por favor, establece tus preferencias para la coincidencia de personas de IA';

  @override
  String get all => 'Todo';

  @override
  String get allAgree => 'Aceptar todo';

  @override
  String get allFeaturesRequired =>
      '※ Todas las funciones son necesarias para la prestación del servicio';

  @override
  String get allPersonas => 'Todas las Personas';

  @override
  String get allPersonasMatched =>
      '¡Todas las personas coinciden! Comienza a chatear con ellas.';

  @override
  String get allowPermission => 'Continuar';

  @override
  String alreadyChattingWith(String name) {
    return '¡Ya estás chateando con $name!';
  }

  @override
  String get alsoBlockThisAI => 'También bloquear esta IA';

  @override
  String get angry => 'Enojado';

  @override
  String get anonymousLogin => 'Inicio de sesión anónimo';

  @override
  String get anxious => 'Ansioso';

  @override
  String get apiKeyError => 'Error de clave API';

  @override
  String get appName => 'SONA';

  @override
  String get appTagline => 'Tus compañeros de IA';

  @override
  String get appleLoginCanceled =>
      'El inicio de sesión con Apple fue cancelado.';

  @override
  String get appleLoginError =>
      'Ocurrió un error durante el inicio de sesión con Apple.';

  @override
  String get art => 'Arte';

  @override
  String get authError => 'Error de autenticación';

  @override
  String get autoTranslate => 'Traducción automática';

  @override
  String get autumn => 'Otoño';

  @override
  String get averageQuality => 'Calidad promedio';

  @override
  String get averageQualityScore => 'Puntuación de calidad promedio';

  @override
  String get awkwardExpression => 'Expresión incómoda';

  @override
  String get backButton => 'Atrás';

  @override
  String get basicInfo => 'Información Básica';

  @override
  String get basicInfoDescription =>
      'Por favor, ingresa información básica para crear una cuenta';

  @override
  String get birthDate => 'Fecha de nacimiento';

  @override
  String get birthDateOptional => 'Fecha de nacimiento (Opcional)';

  @override
  String get birthDateRequired => 'Fecha de nacimiento *';

  @override
  String get blockConfirm => '¿Quieres bloquear esta IA?';

  @override
  String get blockReason => 'Motivo del bloqueo';

  @override
  String get blockThisAI => 'Bloquear esta IA';

  @override
  String blockedAICount(int count) {
    return '$count IAs bloqueadas';
  }

  @override
  String get blockedAIs => 'IAs bloqueadas';

  @override
  String get blockedAt => 'Bloqueado en';

  @override
  String get blockedSuccessfully => 'Bloqueado con éxito';

  @override
  String get breakfast => 'Desayuno';

  @override
  String get byErrorType => 'Por tipo de error';

  @override
  String get byPersona => 'Por persona';

  @override
  String cacheDeleteError(String error) {
    return 'Error al eliminar la caché: $error';
  }

  @override
  String get cacheDeleted => 'La caché de imágenes ha sido eliminada';

  @override
  String get cafeTerrace => 'Terraza del café';

  @override
  String get calm => 'Tranquilo';

  @override
  String get cameraPermission => 'Permiso de cámara';

  @override
  String get cameraPermissionDesc =>
      'Se necesita acceso a la cámara para tomar fotos de perfil.';

  @override
  String get canChangeInSettings =>
      'Puedes cambiar esto más tarde en la configuración';

  @override
  String get canMeetPreviousPersonas =>
      '¡Puedes volver a encontrar personas que deslizaron antes!';

  @override
  String get cancel => 'Cancelar';

  @override
  String get changeProfilePhoto => 'Cambiar foto de perfil';

  @override
  String get chat => 'Chat';

  @override
  String get chatEndedMessage => 'El chat ha terminado';

  @override
  String get chatErrorDashboard => 'Panel de errores de chat';

  @override
  String get chatErrorSentSuccessfully =>
      'El error del chat se ha enviado con éxito.';

  @override
  String get chatListTab => 'Pestaña de lista de chats';

  @override
  String get chats => 'Chats';

  @override
  String chattingWithPersonas(int count) {
    return 'Chateando con $count personas';
  }

  @override
  String get checkInternetConnection =>
      'Por favor, verifica tu conexión a internet';

  @override
  String get checkingUserInfo => 'Verificando la información del usuario';

  @override
  String get childrensDay => 'Día del Niño';

  @override
  String get chinese => 'Chino';

  @override
  String get chooseOption => 'Por favor elige:';

  @override
  String get christmas => 'Navidad';

  @override
  String get close => 'Cerrar';

  @override
  String get complete => 'Hecho';

  @override
  String get completeSignup => 'Completar Registro';

  @override
  String get confirm => 'Confirmar';

  @override
  String get connectingToServer => 'Conectando al servidor';

  @override
  String get consultQualityMonitoring => 'Consulta de Monitoreo de Calidad';

  @override
  String get continueAsGuest => 'Continuar como Invitado';

  @override
  String get continueButton => 'Continuar';

  @override
  String get continueWithApple => 'Continuar con Apple';

  @override
  String get continueWithGoogle => 'Continuar con Google';

  @override
  String get conversationContinuity => 'Continuidad de la Conversación';

  @override
  String get conversationContinuityDesc =>
      'Recuerda conversaciones anteriores y conecta temas';

  @override
  String conversationWith(String name) {
    return '$name';
  }

  @override
  String get convertToMember => 'Registrarse';

  @override
  String get cooking => 'Cocinando';

  @override
  String get copyMessage => 'Copiar mensaje';

  @override
  String get copyrightInfringement => 'Infracción de derechos de autor';

  @override
  String get creatingAccount => 'Creando cuenta';

  @override
  String get crisisDetected => 'Crisis Detectada';

  @override
  String get culturalIssue => 'Problema Cultural';

  @override
  String get current => 'Actual';

  @override
  String get currentCacheSize => 'Tamaño de caché actual';

  @override
  String get currentLanguage => 'Idioma actual';

  @override
  String get cycling => 'Ciclismo';

  @override
  String get dailyCare => 'Cuidado diario';

  @override
  String get dailyCareDesc =>
      'Mensajes de cuidado diario para comidas, sueño, salud';

  @override
  String get dailyChat => 'Charla diaria';

  @override
  String get dailyCheck => 'Revisión diaria';

  @override
  String get dailyConversation => 'Conversación diaria';

  @override
  String get dailyLimitDescription =>
      'Has alcanzado tu límite diario de mensajes';

  @override
  String get dailyLimitTitle => 'Límite diario alcanzado';

  @override
  String get darkMode => 'Modo oscuro';

  @override
  String get darkTheme => 'Modo oscuro';

  @override
  String get darkThemeDesc => 'Usar tema oscuro';

  @override
  String get dataCollection => 'Configuración de recopilación de datos';

  @override
  String get datingAdvice => 'Consejos de citas';

  @override
  String get datingDescription =>
      'Quiero compartir pensamientos profundos y tener conversaciones sinceras';

  @override
  String get dawn => 'Amanecer';

  @override
  String get day => 'Día';

  @override
  String get dayAfterTomorrow => 'Pasado mañana';

  @override
  String daysAgo(int count, String formatted) {
    return 'hace $count días';
  }

  @override
  String daysRemaining(int days) {
    return '$days días restantes';
  }

  @override
  String get deepTalk => 'Charla profunda';

  @override
  String get delete => 'Eliminar';

  @override
  String get deleteAccount => 'Eliminar cuenta';

  @override
  String get deleteAccountConfirm =>
      '¿Estás seguro de que quieres eliminar tu cuenta? Esta acción no se puede deshacer.';

  @override
  String get deleteAccountWarning =>
      '¿Estás seguro de que quieres eliminar tu cuenta?';

  @override
  String get deleteCache => 'Eliminar caché';

  @override
  String get deletingAccount => 'Eliminando cuenta...';

  @override
  String get depressed => 'Deprimido';

  @override
  String get describeError => '¿Cuál es el problema?';

  @override
  String get detailedReason => 'Razón detallada';

  @override
  String get developRelationshipStep =>
      '3. Desarrollar relación: Crea intimidad a través de conversaciones y desarrolla relaciones especiales.';

  @override
  String get dinner => 'Cena';

  @override
  String get discardGuestData => 'Comenzar de nuevo';

  @override
  String get discount20 => '20% de descuento';

  @override
  String get discount30 => '30% de descuento';

  @override
  String get discountAmount => 'Ahorra';

  @override
  String discountAmountValue(String amount) {
    return 'Ahorra ₩$amount';
  }

  @override
  String get done => 'Hecho';

  @override
  String get downloadingPersonaImages =>
      'Descargando nuevas imágenes de persona';

  @override
  String get edit => 'Editar';

  @override
  String get editInfo => 'Editar información';

  @override
  String get editProfile => 'Editar perfil';

  @override
  String get effectSound => 'Efectos de sonido';

  @override
  String get effectSoundDescription => 'Reproducir efectos de sonido';

  @override
  String get email => 'Correo electrónico';

  @override
  String get emailHint => 'ejemplo@email.com';

  @override
  String get emailLabel => 'Correo electrónico';

  @override
  String get emailRequired => 'Por favor ingresa el correo';

  @override
  String get emotionAnalysis => 'Análisis de emociones';

  @override
  String get emotionAnalysisDesc =>
      'Analiza emociones para respuestas empáticas';

  @override
  String get emotionAngry => 'Enojado';

  @override
  String get emotionBasedEncounters => 'Encuentros basados en emociones';

  @override
  String get emotionCool => 'Genial';

  @override
  String get emotionHappy => 'Feliz';

  @override
  String get emotionLove => 'Amor';

  @override
  String get emotionSad => 'Triste';

  @override
  String get emotionThinking => 'Pensando';

  @override
  String get emotionalSupportDesc =>
      'Comparte tus preocupaciones y recibe un cálido consuelo';

  @override
  String get endChat => 'Terminar Chat';

  @override
  String get endTutorial => 'Terminar Tutorial';

  @override
  String get endTutorialAndLogin => '¿Terminar el tutorial e iniciar sesión?';

  @override
  String get endTutorialMessage =>
      '¿Quieres terminar el tutorial e iniciar sesión?';

  @override
  String get english => 'Inglés';

  @override
  String get enterBasicInfo =>
      'Por favor, ingresa información básica para crear una cuenta';

  @override
  String get enterBasicInformation => 'Por favor, ingresa información básica';

  @override
  String get enterEmail => 'Por favor, ingresa tu correo electrónico';

  @override
  String get enterNickname => 'Por favor, ingresa un apodo';

  @override
  String get enterPassword => 'Por favor, ingresa una contraseña';

  @override
  String get entertainmentAndFunDesc =>
      'Disfruta de juegos divertidos y conversaciones agradables';

  @override
  String get entertainmentDescription =>
      'Quiero tener conversaciones divertidas y disfrutar mi tiempo';

  @override
  String get entertainmentFun => 'Entretenimiento/Diversión';

  @override
  String get error => 'Error';

  @override
  String get errorDescription => 'Descripción del error';

  @override
  String get errorDescriptionHint =>
      'p. ej., Dio respuestas extrañas, Repite lo mismo, Da respuestas contextualmente inapropiadas...';

  @override
  String get errorDetails => 'Detalles del Error';

  @override
  String get errorDetailsHint => 'Por favor, explica en detalle qué está mal';

  @override
  String get errorFrequency24h => 'Frecuencia de Errores (Últas 24 horas)';

  @override
  String get errorMessage => 'Mensaje de Error:';

  @override
  String get errorOccurred => 'Ocurrió un error.';

  @override
  String get errorOccurredTryAgain =>
      'Ocurrió un error. Por favor, inténtalo de nuevo.';

  @override
  String get errorSendingFailed => 'Falló el envío del error';

  @override
  String get errorStats => 'Estadísticas de Errores';

  @override
  String errorWithMessage(String error) {
    return 'Ocurrió un error: $error';
  }

  @override
  String get evening => 'Noche';

  @override
  String get excited => 'Emocionado';

  @override
  String get exit => 'Salir';

  @override
  String get exitApp => 'Salir de la App';

  @override
  String get exitConfirmMessage =>
      '¿Estás seguro de que quieres salir de la app?';

  @override
  String get expertPersona => 'Persona Experta';

  @override
  String get expertiseScore => 'Puntuación de Experiencia';

  @override
  String get expired => 'Expirado';

  @override
  String get explainReportReason =>
      'Por favor, explica el motivo del reporte en detalle';

  @override
  String get fashion => 'Moda';

  @override
  String get female => 'Mujer';

  @override
  String get filter => 'Filtrar';

  @override
  String get firstOccurred => 'Ocurrió por primera vez:';

  @override
  String get followDeviceLanguage =>
      'Seguir la configuración de idioma del dispositivo';

  @override
  String get forenoon => 'Mañana';

  @override
  String get forgotPassword => '¿Olvidaste tu contraseña?';

  @override
  String get frequentlyAskedQuestions => 'Preguntas Frecuentes';

  @override
  String get friday => 'Viernes';

  @override
  String get friendshipDescription =>
      'Quiero conocer nuevos amigos y tener conversaciones';

  @override
  String get funChat => 'Charla Divertida';

  @override
  String get galleryPermission => 'Permiso de galería';

  @override
  String get galleryPermissionDesc =>
      'Se necesita acceso a la galería para seleccionar fotos de perfil.';

  @override
  String get gaming => 'Juegos';

  @override
  String get gender => 'Género';

  @override
  String get genderNotSelectedInfo =>
      'Si no se selecciona género, se mostrarán personas de todos los géneros';

  @override
  String get genderOptional => 'Género (Opcional)';

  @override
  String get genderPreferenceActive =>
      'Puedes conocer personas de todos los géneros';

  @override
  String get genderPreferenceDisabled =>
      'Selecciona tu género para habilitar la opción de solo género opuesto';

  @override
  String get genderPreferenceInactive =>
      'Solo se mostrarán personas de género opuesto';

  @override
  String get genderRequired => 'Género *';

  @override
  String get genderSelectionInfo =>
      'Si no se selecciona, puedes conocer personas de todos los géneros';

  @override
  String get generalPersona => 'Persona General';

  @override
  String get goToSettings => 'Ir a ajustes';

  @override
  String get permissionGuideAndroid =>
      'Settings > Apps > SONA > Permissions\nPlease allow photo permission';

  @override
  String get permissionGuideIOS =>
      'Settings > SONA > Photos\nPlease allow photo access';

  @override
  String get googleLoginCanceled =>
      'El inicio de sesión de Google fue cancelado.';

  @override
  String get googleLoginError =>
      'Ocurrió un error durante el inicio de sesión de Google.';

  @override
  String get grantPermission => 'Continuar';

  @override
  String get guest => 'Invitado';

  @override
  String get guestDataMigration =>
      '¿Te gustaría conservar tu historial de chat actual al registrarte?';

  @override
  String get guestLimitReached => 'Prueba de invitado finalizada.';

  @override
  String get guestLoginPromptMessage =>
      'Inicia sesión para continuar la conversación';

  @override
  String get guestMessageExhausted => 'Mensajes gratuitos agotados';

  @override
  String guestMessageRemaining(int count) {
    return '$count mensajes de invitado restantes';
  }

  @override
  String get guestModeBanner => 'Modo Invitado';

  @override
  String get guestModeDescription => 'Prueba SONA sin registrarte';

  @override
  String get guestModeFailedMessage => 'No se pudo iniciar el Modo Invitado';

  @override
  String get guestModeLimitation =>
      'Algunas funciones están limitadas en el Modo Invitado';

  @override
  String get guestModeTitle => 'Prueba como Invitado';

  @override
  String get guestModeWarning =>
      'El modo invitado dura 24 horas, después de las cuales los datos serán eliminados.';

  @override
  String get guestModeWelcome => 'Iniciando en Modo Invitado';

  @override
  String get happy => 'Feliz';

  @override
  String get hapticFeedback => 'Retroalimentación háptica';

  @override
  String get harassmentBullying => 'Acoso/Intimidación';

  @override
  String get hateSpeech => 'Discurso de odio';

  @override
  String get heartDescription => 'Corazones para más mensajes';

  @override
  String get heartInsufficient => 'No hay suficientes corazones';

  @override
  String get heartInsufficientPleaseCharge =>
      'No hay suficientes corazones. Por favor, recarga corazones.';

  @override
  String get heartRequired => 'Se requiere 1 corazón';

  @override
  String get heartUsageFailed => 'No se pudo usar el corazón.';

  @override
  String get hearts => 'Corazones';

  @override
  String get hearts10 => '10 Corazones';

  @override
  String get hearts30 => '30 Corazones';

  @override
  String get hearts30Discount => 'OFERTA';

  @override
  String get hearts50 => '50 Corazones';

  @override
  String get hearts50Discount => 'OFERTA';

  @override
  String get helloEmoji => '¡Hola! 😊';

  @override
  String get help => 'Ayuda';

  @override
  String get hideOriginalText => 'Ocultar Original';

  @override
  String get hobbySharing => 'Compartir Pasatiempos';

  @override
  String get hobbyTalk => 'Charla sobre Pasatiempos';

  @override
  String get hours24Ago => 'Hace 24 horas';

  @override
  String hoursAgo(int count, String formatted) {
    return 'hace $count horas';
  }

  @override
  String get howToUse => 'Cómo usar SONA';

  @override
  String get imageCacheManagement => 'Gestión de Caché de Imágenes';

  @override
  String get inappropriateContent => 'Contenido inapropiado';

  @override
  String get incorrect => 'incorrecto';

  @override
  String get incorrectPassword => 'Contraseña incorrecta';

  @override
  String get indonesian => 'Indonesio';

  @override
  String get inquiries => 'Consultas';

  @override
  String get insufficientHearts => 'Corazones insuficientes.';

  @override
  String get interestSharing => 'Compartir Intereses';

  @override
  String get interestSharingDesc =>
      'Descubre y recomienda intereses compartidos';

  @override
  String get interests => 'Intereses';

  @override
  String get invalidEmailFormat => 'Formato de correo electrónico no válido';

  @override
  String get invalidEmailFormatError =>
      'Por favor, ingresa una dirección de correo electrónico válida';

  @override
  String isTyping(String name) {
    return '$name está escribiendo...';
  }

  @override
  String get japanese => 'Japonés';

  @override
  String get joinDate => 'Fecha de Unirse';

  @override
  String get justNow => 'Ahora mismo';

  @override
  String get keepGuestData => 'Mantener Historial de Chat';

  @override
  String get korean => 'Coreano';

  @override
  String get koreanLanguage => 'Coreano';

  @override
  String get language => 'Idioma';

  @override
  String get languageDescription =>
      'La IA responderá en el idioma que seleccionaste';

  @override
  String get languageIndicator => 'Idioma';

  @override
  String get languageSettings => 'Configuración de idioma';

  @override
  String get lastOccurred => 'Última vez ocurrido:';

  @override
  String get lastUpdated => 'Última actualización';

  @override
  String get lateNight => 'Tarde noche';

  @override
  String get later => 'Más tarde';

  @override
  String get laterButton => 'Más tarde';

  @override
  String get leave => 'Salir';

  @override
  String get leaveChatConfirm => '¿Salir de este chat?';

  @override
  String get leaveChatRoom => 'Salir de la sala de chat';

  @override
  String get leaveChatTitle => 'Salir del chat';

  @override
  String get lifeAdvice => 'Consejos de vida';

  @override
  String get lightTalk => 'Charla ligera';

  @override
  String get lightTheme => 'Modo claro';

  @override
  String get lightThemeDesc => 'Usar tema brillante';

  @override
  String get loading => 'Cargando...';

  @override
  String get loadingData => 'Cargando datos...';

  @override
  String get loadingProducts => 'Cargando productos...';

  @override
  String get loadingProfile => 'Cargando perfil';

  @override
  String get login => 'Iniciar sesión';

  @override
  String get loginButton => 'Iniciar sesión';

  @override
  String get loginCancelled => 'Inicio de sesión cancelado';

  @override
  String get loginComplete => 'Inicio de sesión completado';

  @override
  String get loginError => 'Error en el inicio de sesión';

  @override
  String get loginFailed => 'Error al iniciar sesión';

  @override
  String get loginFailedTryAgain =>
      'Error al iniciar sesión. Por favor, inténtalo de nuevo.';

  @override
  String get loginRequired => 'Se requiere iniciar sesión';

  @override
  String get loginRequiredForProfile =>
      'Se requiere iniciar sesión para ver el perfil';

  @override
  String get loginRequiredService =>
      'Se requiere iniciar sesión para usar este servicio';

  @override
  String get loginRequiredTitle => 'Se requiere iniciar sesión';

  @override
  String get loginSignup => 'Iniciar sesión/Registrarse';

  @override
  String get loginTab => 'Iniciar sesión';

  @override
  String get loginTitle => 'Iniciar sesión';

  @override
  String get loginWithApple => 'Iniciar sesión con Apple';

  @override
  String get loginWithGoogle => 'Iniciar sesión con Google';

  @override
  String get logout => 'Cerrar sesión';

  @override
  String get logoutConfirm => '¿Estás seguro de que quieres cerrar sesión?';

  @override
  String get lonelinessRelief => 'Alivio de la soledad';

  @override
  String get lonely => 'Solo';

  @override
  String get lowQualityResponses => 'Respuestas de baja calidad';

  @override
  String get lunch => 'Almuerzo';

  @override
  String get lunchtime => 'Hora del almuerzo';

  @override
  String get mainErrorType => 'Tipo de error principal';

  @override
  String get makeFriends => 'Hacer amigos';

  @override
  String get male => 'Hombre';

  @override
  String get manageBlockedAIs => 'Gestionar AIs bloqueados';

  @override
  String get managePersonaImageCache =>
      'Gestionar caché de imágenes de personas';

  @override
  String get marketingAgree => 'Aceptar información de marketing (opcional)';

  @override
  String get marketingDescription =>
      'Puedes recibir información sobre eventos y beneficios';

  @override
  String get matchPersonaStep =>
      '1. Emparejar personas: Desliza a la izquierda o derecha para seleccionar tus AIs favoritas.';

  @override
  String get matchedPersonas => 'Personas emparejadas';

  @override
  String get matchedSona => 'SONA emparejado';

  @override
  String get matching => 'Emparejando';

  @override
  String get matchingFailed => 'La coincidencia falló.';

  @override
  String get me => 'Me';

  @override
  String get meetAIPersonas => 'Conoce a las Personas IA';

  @override
  String get meetNewPersonas => 'Conocer nuevas personas';

  @override
  String get meetPersonas => 'Conoce a Personas';

  @override
  String get memberBenefits =>
      '¡Recibe más de 100 mensajes y 10 corazones al registrarte!';

  @override
  String get memoryAlbum => 'Álbum de Recuerdos';

  @override
  String get memoryAlbumDesc =>
      'Guarda y recuerda momentos especiales automáticamente';

  @override
  String get messageCopied => 'Mensaje copiado';

  @override
  String get messageDeleted => 'Mensaje eliminado';

  @override
  String get messageLimitReset =>
      'El límite de mensajes se restablecerá a medianoche';

  @override
  String get messageSendFailed =>
      'Error al enviar el mensaje. Por favor, inténtalo de nuevo.';

  @override
  String get messagesRemaining => 'Mensajes restantes';

  @override
  String minutesAgo(int count, String formatted) {
    return 'hace $count minutos';
  }

  @override
  String get missingTranslation => 'Traducción faltante';

  @override
  String get monday => 'Lunes';

  @override
  String get month => 'Mes';

  @override
  String monthDay(String month, int day) {
    return '$month $day';
  }

  @override
  String get moreButton => 'Más';

  @override
  String get morning => 'Mañana';

  @override
  String get mostFrequentError => 'Error más frecuente';

  @override
  String get movies => 'Películas';

  @override
  String get multilingualChat => 'Chat multilingüe';

  @override
  String get music => 'Música';

  @override
  String get myGenderSection => 'Mi género (Opcional)';

  @override
  String get networkErrorOccurred => 'Ocurrió un error de red.';

  @override
  String get newMessage => 'Nuevo mensaje';

  @override
  String newMessageCount(int count) {
    return '$count nuevos mensajes';
  }

  @override
  String get newMessageNotification => 'Notificación de nuevo mensaje';

  @override
  String get newMessages => 'Nuevos mensajes';

  @override
  String get newYear => 'Año Nuevo';

  @override
  String get next => 'Siguiente';

  @override
  String get niceToMeetYou => '¡Encantado de conocerte!';

  @override
  String get nickname => 'Apodo';

  @override
  String get nicknameAlreadyUsed => 'Este apodo ya está en uso';

  @override
  String get nicknameHelperText => '3-10 caracteres';

  @override
  String get nicknameHint => '3-10 caracteres';

  @override
  String get nicknameInUse => 'Este apodo ya está en uso';

  @override
  String get nicknameLabel => 'Apodo';

  @override
  String get nicknameLengthError =>
      'El apodo debe tener entre 3 y 10 caracteres';

  @override
  String get nicknamePlaceholder => 'Ingresa tu apodo';

  @override
  String get nicknameRequired => 'Por favor ingresa el apodo';

  @override
  String get night => 'Noche';

  @override
  String get no => 'No';

  @override
  String get noBlockedAIs => 'No hay AIs bloqueados';

  @override
  String get noChatsYet => 'Aún no hay chats';

  @override
  String get noConversationYet => 'Aún no hay conversación';

  @override
  String get noErrorReports => 'No hay informes de errores.';

  @override
  String get noImageAvailable => 'No hay imagen disponible';

  @override
  String get noMatchedPersonas => 'Aún no hay personas coincidentes';

  @override
  String get noMatchedSonas => 'Aún no hay Sonas coincidentes';

  @override
  String get noPersonasAvailable =>
      'No hay personas disponibles. Por favor, inténtalo de nuevo.';

  @override
  String get noPersonasToSelect => 'No hay personas disponibles';

  @override
  String get noQualityIssues =>
      'No hay problemas de calidad en la última hora ✅';

  @override
  String get noQualityLogs => 'Aún no hay registros de calidad.';

  @override
  String get noTranslatedMessages => 'No hay mensajes para traducir';

  @override
  String get notEnoughHearts => 'No hay suficientes corazones';

  @override
  String notEnoughHeartsCount(int count) {
    return 'No hay suficientes corazones. (Actual: $count)';
  }

  @override
  String get notRegistered => 'no registrado';

  @override
  String get notSubscribed => 'No suscrito';

  @override
  String get notificationPermissionDesc =>
      'Se necesita permiso de notificación para recibir mensajes nuevos.';

  @override
  String get notificationPermissionRequired =>
      'Se requiere permiso de notificación';

  @override
  String get notificationSettings => 'Ajustes de notificación';

  @override
  String get notifications => 'Notificaciones';

  @override
  String get occurrenceInfo => 'Información de ocurrencia:';

  @override
  String get olderChats => 'Más antiguos';

  @override
  String get onlyOppositeGenderNote =>
      'Si no está marcado, solo se mostrarán personas del género opuesto';

  @override
  String get openSettings => 'Abrir Configuración';

  @override
  String get optional => 'Opcional';

  @override
  String get or => 'o';

  @override
  String get originalPrice => 'Original';

  @override
  String get originalText => 'Original';

  @override
  String get other => 'Otro';

  @override
  String get otherError => 'Otro error';

  @override
  String get others => 'Otros';

  @override
  String get ownedHearts => 'Corazones poseídos';

  @override
  String get parentsDay => 'Día de los Padres';

  @override
  String get password => 'Contraseña';

  @override
  String get passwordConfirmation => 'Ingresa la contraseña para confirmar';

  @override
  String get passwordConfirmationDesc =>
      'Por favor, vuelve a ingresar tu contraseña para eliminar la cuenta.';

  @override
  String get passwordHint => '6 caracteres o más';

  @override
  String get passwordLabel => 'Contraseña';

  @override
  String get passwordRequired => 'Por favor ingresa la contraseña';

  @override
  String get passwordResetEmailPrompt =>
      'Por favor, ingresa tu correo electrónico para restablecer la contraseña';

  @override
  String get passwordResetEmailSent =>
      'Se ha enviado un correo electrónico para restablecer la contraseña. Por favor, revisa tu correo.';

  @override
  String get passwordText => 'contraseña';

  @override
  String get passwordTooShort =>
      'La contraseña debe tener al menos 6 caracteres';

  @override
  String get permissionDenied => 'Permiso denegado';

  @override
  String permissionDeniedMessage(String permissionName) {
    return 'Se denegó el permiso de $permissionName.\\nPor favor, permite el permiso en la configuración.';
  }

  @override
  String get permissionDeniedTryLater =>
      'Permiso denegado. Por favor, intenta de nuevo más tarde.';

  @override
  String get permissionRequired => 'Permiso requerido';

  @override
  String get personaGenderSection => 'Preferencia de Género de Persona';

  @override
  String get personaQualityStats => 'Estadísticas de Calidad de Persona';

  @override
  String get personalInfoExposure => 'Exposición de información personal';

  @override
  String get personality => 'Configuración de Personalidad';

  @override
  String get pets => 'Mascotas';

  @override
  String get photo => 'Foto';

  @override
  String get photography => 'Fotografía';

  @override
  String get picnic => 'Picnic';

  @override
  String get preferenceSettings => 'Configuración de preferencias';

  @override
  String get preferredLanguage => 'Idioma preferido';

  @override
  String get preparingForSleep => 'Preparándose para dormir';

  @override
  String get preparingNewMeeting => 'Preparando nueva reunión';

  @override
  String get preparingPersonaImages => 'Preparando imágenes de persona';

  @override
  String get preparingPersonas => 'Preparando personas';

  @override
  String get preview => 'Vista previa';

  @override
  String get previous => 'Anterior';

  @override
  String get privacy => 'Privacidad';

  @override
  String get privacyPolicy => 'Política de privacidad';

  @override
  String get privacyPolicyAgreement =>
      'Por favor, acepta la política de privacidad';

  @override
  String get privacySection1Content =>
      'Nos comprometemos a proteger su privacidad. Esta Política de Privacidad explica cómo recopilamos, usamos y salvaguardamos su información cuando utiliza nuestro servicio.';

  @override
  String get privacySection1Title =>
      '1. Propósito de la recopilación y uso de información personal';

  @override
  String get privacySection2Content =>
      'Recopilamos información que nos proporciona directamente, como cuando crea una cuenta, actualiza su perfil o utiliza nuestros servicios.';

  @override
  String get privacySection2Title => 'Información que recopilamos';

  @override
  String get privacySection3Content =>
      'Usamos la información que recopilamos para proporcionar, mantener y mejorar nuestros servicios, y para comunicarnos con usted.';

  @override
  String get privacySection3Title =>
      '3. Período de retención y uso de información personal';

  @override
  String get privacySection4Content =>
      'No vendemos, intercambiamos ni transferimos de ninguna otra manera su información personal a terceros sin su consentimiento.';

  @override
  String get privacySection4Title =>
      '4. Provisión de información personal a terceros';

  @override
  String get privacySection5Content =>
      'Implementamos medidas de seguridad adecuadas para proteger su información personal contra el acceso no autorizado, alteración, divulgación o destrucción.';

  @override
  String get privacySection5Title =>
      '5. Medidas Técnicas de Protección de la Información Personal';

  @override
  String get privacySection6Content =>
      'Retenemos la información personal durante el tiempo necesario para proporcionar nuestros servicios y cumplir con las obligaciones legales.';

  @override
  String get privacySection6Title => '6. Derechos del Usuario';

  @override
  String get privacySection7Content =>
      'Tienes el derecho de acceder, actualizar o eliminar tu información personal en cualquier momento a través de la configuración de tu cuenta.';

  @override
  String get privacySection7Title => 'Tus Derechos';

  @override
  String get privacySection8Content =>
      'Si tienes alguna pregunta sobre esta Política de Privacidad, por favor contáctanos a support@sona.com.';

  @override
  String get privacySection8Title => 'Contáctanos';

  @override
  String get privacySettings => 'Configuración de Privacidad';

  @override
  String get privacySettingsInfo =>
      'Desactivar funciones individuales hará que esos servicios no estén disponibles';

  @override
  String get privacySettingsScreen => 'Configuración de Privacidad';

  @override
  String get problemMessage => 'Problema';

  @override
  String get problemOccurred => 'Ocurrió un Problema';

  @override
  String get profile => 'Perfil';

  @override
  String get profileEdit => 'Editar Perfil';

  @override
  String get profileEditLoginRequiredMessage =>
      'Se requiere iniciar sesión para editar tu perfil.';

  @override
  String get profileInfo => 'Información del Perfil';

  @override
  String get profileInfoDescription =>
      'Por favor, ingresa tu foto de perfil e información básica';

  @override
  String get profileNav => 'Perfil';

  @override
  String get profilePhoto => 'Foto de Perfil';

  @override
  String get profilePhotoAndInfo =>
      'Por favor, ingresa la foto de perfil e información básica';

  @override
  String get profilePhotoUpdateFailed =>
      'Falló la actualización de la foto de perfil';

  @override
  String get profilePhotoUpdated => 'Foto de perfil actualizada';

  @override
  String get profileSettings => 'Configuración del perfil';

  @override
  String get profileSetup => 'Configurando el perfil';

  @override
  String get profileUpdateFailed => 'Fallo al actualizar el perfil';

  @override
  String get profileUpdated => 'Perfil actualizado con éxito';

  @override
  String get purchaseAndRefundPolicy => 'Política de compra y reembolso';

  @override
  String get purchaseButton => 'Comprar';

  @override
  String get purchaseConfirm => 'Confirmación de compra';

  @override
  String purchaseConfirmContent(String product, String price) {
    return '¿Comprar $product por $price?';
  }

  @override
  String purchaseConfirmMessage(
      String title, String price, String description) {
    return '¿Confirmar compra de $title por $price? $description';
  }

  @override
  String get purchaseFailed => 'La compra ha fallado';

  @override
  String get purchaseHeartsOnly => 'Comprar corazones';

  @override
  String get purchaseMoreHearts =>
      'Compra corazones para continuar las conversaciones';

  @override
  String get purchasePending => 'Compra pendiente...';

  @override
  String get purchasePolicy => 'Política de compra';

  @override
  String get purchaseSection1Content =>
      'Aceptamos varios métodos de pago, incluidas tarjetas de crédito y billeteras digitales.';

  @override
  String get purchaseSection1Title => 'Métodos de pago';

  @override
  String get purchaseSection2Content =>
      'Los reembolsos están disponibles dentro de los 14 días posteriores a la compra si no has utilizado los artículos comprados.';

  @override
  String get purchaseSection2Title => 'Política de reembolso';

  @override
  String get purchaseSection3Content =>
      'Puedes cancelar tu suscripción en cualquier momento a través de la configuración de tu cuenta.';

  @override
  String get purchaseSection3Title => 'Cancelación';

  @override
  String get purchaseSection4Content =>
      'Al realizar una compra, aceptas nuestros términos de uso y el acuerdo de servicio.';

  @override
  String get purchaseSection4Title => 'Términos de Uso';

  @override
  String get purchaseSection5Content =>
      'Para problemas relacionados con compras, por favor contacta a nuestro equipo de soporte.';

  @override
  String get purchaseSection5Title => 'Contactar Soporte';

  @override
  String get purchaseSection6Content =>
      'Todas las compras están sujetas a nuestros términos y condiciones estándar.';

  @override
  String get purchaseSection6Title => '6. Consultas';

  @override
  String get pushNotifications => 'Notificaciones push';

  @override
  String get reading => 'Leyendo';

  @override
  String get realtimeQualityLog => 'Registro de Calidad en Tiempo Real';

  @override
  String get recentConversation => 'Conversación Reciente:';

  @override
  String get recentLoginRequired =>
      'Por favor, inicia sesión nuevamente por seguridad';

  @override
  String get referrerEmail => 'Correo Electrónico del Referidor';

  @override
  String get referrerEmailHelper => 'Opcional: Correo de quien te refirió';

  @override
  String get referrerEmailLabel =>
      'Correo Electrónico del Referidor (Opcional)';

  @override
  String get refresh => 'Actualizar';

  @override
  String refreshComplete(int count) {
    return '¡Actualización completa! $count personas coincidentes';
  }

  @override
  String get refreshFailed => 'Fallo en la actualización';

  @override
  String get refreshingChatList => 'Actualizando lista de chats...';

  @override
  String get relatedFAQ => 'Preguntas Frecuentes Relacionadas';

  @override
  String get report => 'Reportar';

  @override
  String get reportAI => 'Reportar';

  @override
  String get reportAIDescription =>
      'Si la IA te hizo sentir incómodo, por favor describe el problema.';

  @override
  String get reportAITitle => 'Reportar Conversación con IA';

  @override
  String get reportAndBlock => 'Reportar y Bloquear';

  @override
  String get reportAndBlockDescription =>
      'Puedes reportar y bloquear el comportamiento inapropiado de esta IA';

  @override
  String get reportChatError => 'Reportar error de chat';

  @override
  String reportError(String error) {
    return 'Ocurrió un error al reportar: $error';
  }

  @override
  String get reportFailed => 'Reporte fallido';

  @override
  String get reportSubmitted =>
      'Reporte enviado. Lo revisaremos y tomaremos acción.';

  @override
  String get reportSubmittedSuccess => 'Tu reporte ha sido enviado. ¡Gracias!';

  @override
  String get requestLimit => 'Límite de solicitudes';

  @override
  String get required => '[Requerido]';

  @override
  String get requiredTermsAgreement => 'Por favor, acepta los términos';

  @override
  String get restartConversation => 'Reiniciar conversación';

  @override
  String restartConversationQuestion(String name) {
    return '¿Te gustaría reiniciar la conversación con $name?';
  }

  @override
  String restartConversationWithName(String name) {
    return 'Reiniciando la conversación con $name!';
  }

  @override
  String get retry => 'Reintentar';

  @override
  String get retryButton => 'Reintentar';

  @override
  String get sad => 'Triste';

  @override
  String get saturday => 'Sábado';

  @override
  String get save => 'Guardar';

  @override
  String get search => 'Buscar';

  @override
  String get searchFAQ => 'Buscar preguntas frecuentes...';

  @override
  String get searchResults => 'Resultados de búsqueda';

  @override
  String get selectEmotion => 'Seleccionar emoción';

  @override
  String get selectErrorType => 'Seleccionar tipo de error';

  @override
  String get selectFeeling => 'Seleccionar sentimiento';

  @override
  String get selectGender => 'Por favor, selecciona el género';

  @override
  String get selectInterests => 'Selecciona tus intereses';

  @override
  String get selectLanguage => 'Seleccionar idioma';

  @override
  String get selectPersona => 'Seleccionar una persona';

  @override
  String get selectPersonaPlease => 'Por favor, selecciona una persona.';

  @override
  String get selectPreferredMbti =>
      'Si prefieres personas con tipos MBTI específicos, por favor selecciona';

  @override
  String get selectProblematicMessage =>
      'Selecciona el mensaje problemático (opcional)';

  @override
  String get chatErrorAnalysisInfo =>
      'Analizando las últimas 10 conversaciones.';

  @override
  String get whatWasAwkward => '¿Qué te pareció extraño?';

  @override
  String get errorExampleHint =>
      'Ej: Forma de hablar extraña (terminaciones ~nya)...';

  @override
  String get selectReportReason => 'Selecciona el motivo del reporte';

  @override
  String get selectTheme => 'Seleccionar tema';

  @override
  String get selectTranslationError =>
      'Por favor, selecciona un mensaje con error de traducción';

  @override
  String get selectUsagePurpose =>
      'Por favor, selecciona tu propósito para usar SONA';

  @override
  String get selfIntroduction => 'Introducción (Opcional)';

  @override
  String get selfIntroductionHint => 'Escribe una breve introducción sobre ti';

  @override
  String get send => 'Enviar';

  @override
  String get sendChatError => 'Error al enviar el chat';

  @override
  String get sendFirstMessage => 'Envía tu primer mensaje';

  @override
  String get sendReport => 'Enviar reporte';

  @override
  String get sendingEmail => 'Enviando correo electrónico...';

  @override
  String get seoul => 'Seúl';

  @override
  String get serverErrorDashboard => 'Error del servidor';

  @override
  String get serviceTermsAgreement =>
      'Por favor, acepta los términos del servicio';

  @override
  String get sessionExpired => 'La sesión ha expirado';

  @override
  String get setAppInterfaceLanguage =>
      'Establecer el idioma de la interfaz de la app';

  @override
  String get setNow => 'Establecer ahora';

  @override
  String get settings => 'Ajustes';

  @override
  String get sexualContent => 'Contenido sexual';

  @override
  String get showAllGenderPersonas => 'Mostrar personas de todos los géneros';

  @override
  String get showAllGendersOption => 'Mostrar todos los géneros';

  @override
  String get showOppositeGenderOnly =>
      'Si no está marcado, solo se mostrarán personas del género opuesto';

  @override
  String get showOriginalText => 'Mostrar original';

  @override
  String get signUp => 'Registrarse';

  @override
  String get signUpFromGuest =>
      '¡Regístrate ahora para acceder a todas las funciones!';

  @override
  String get signup => 'Registrarse';

  @override
  String get signupComplete => 'Registro completo';

  @override
  String get signupTab => 'Registro';

  @override
  String get simpleInfoRequired => 'Se requiere información simple';

  @override
  String get skip => 'Omitir';

  @override
  String get sonaFriend => 'Amigo de SONA';

  @override
  String get sonaPrivacyPolicy => 'Política de privacidad de SONA';

  @override
  String get sonaPurchasePolicy => 'Política de compras de SONA';

  @override
  String get sonaTermsOfService => 'Términos de servicio de SONA';

  @override
  String get sonaUsagePurpose =>
      'Por favor, selecciona tu propósito para usar SONA';

  @override
  String get sorryNotHelpful => 'Lo siento, esto no fue útil';

  @override
  String get sort => 'Ordenar';

  @override
  String get soundSettings => 'Configuración de sonido';

  @override
  String get spamAdvertising => 'Spam/Publicidad';

  @override
  String get spanish => 'Español';

  @override
  String get specialRelationshipDesc =>
      'Entiendan y construyan lazos profundos';

  @override
  String get sports => 'Deportes';

  @override
  String get spring => 'Primavera';

  @override
  String get startChat => 'Iniciar Chat';

  @override
  String get startChatButton => 'Iniciar Chat';

  @override
  String get startConversation => 'Iniciar una conversación';

  @override
  String get startConversationLikeAFriend =>
      'Inicia una conversación con SONA como un amigo';

  @override
  String get startConversationStep =>
      '2. Iniciar Conversación: Chatea libremente con las personas emparejadas.';

  @override
  String get startConversationWithSona =>
      '¡Comienza a chatear con SONA como un amigo!';

  @override
  String get startWithEmail => 'Comenzar con Email';

  @override
  String get startWithGoogle => 'Comenzar con Google';

  @override
  String get startingApp => 'Iniciando la aplicación';

  @override
  String get storageManagement => 'Gestión de Almacenamiento';

  @override
  String get store => 'Tienda';

  @override
  String get storeConnectionError => 'No se pudo conectar a la tienda';

  @override
  String get storeLoginRequiredMessage =>
      'Se requiere iniciar sesión para usar la tienda. ¿Te gustaría ir a la pantalla de inicio de sesión?';

  @override
  String get storeNotAvailable => 'La tienda no está disponible';

  @override
  String get storyEvent => 'Evento de Historia';

  @override
  String get stressed => 'Estresado';

  @override
  String get submitReport => 'Enviar Informe';

  @override
  String get subscriptionStatus => 'Estado de Suscripción';

  @override
  String get subtleVibrationOnTouch => 'Vibración sutil al tocar';

  @override
  String get summer => 'Verano';

  @override
  String get sunday => 'Domingo';

  @override
  String get swipeAnyDirection => 'Desliza en cualquier dirección';

  @override
  String get swipeDownToClose => 'Desliza hacia abajo para cerrar';

  @override
  String get systemTheme => 'Seguir el sistema';

  @override
  String get systemThemeDesc =>
      'Cambia automáticamente según la configuración del modo oscuro del dispositivo';

  @override
  String get tapBottomForDetails => 'Toca la parte inferior para ver detalles';

  @override
  String get tapForDetails => 'Toca el área inferior para más detalles';

  @override
  String get tapToSwipePhotos => 'Toca para deslizar fotos';

  @override
  String get teachersDay => 'Día del Maestro';

  @override
  String get technicalError => 'Error técnico';

  @override
  String get technology => 'Tecnología';

  @override
  String get terms => 'Términos de servicio';

  @override
  String get termsAgreement => 'Acuerdo de términos';

  @override
  String get termsAgreementDescription =>
      'Por favor, acepta los términos para utilizar el servicio';

  @override
  String get termsOfService => 'Términos de servicio';

  @override
  String get termsSection10Content =>
      'Nos reservamos el derecho de modificar estos términos en cualquier momento con aviso a los usuarios.';

  @override
  String get termsSection10Title => 'Artículo 10 (Resolución de disputas)';

  @override
  String get termsSection11Content =>
      'Estos términos se regirán por las leyes de la jurisdicción en la que operamos.';

  @override
  String get termsSection11Title =>
      'Artículo 11 (Disposiciones especiales del servicio de IA)';

  @override
  String get termsSection12Content =>
      'Si alguna disposición de estos términos se considera inaplicable, las disposiciones restantes seguirán en pleno vigor y efecto.';

  @override
  String get termsSection12Title => 'Artículo 12 (Recopilación y Uso de Datos)';

  @override
  String get termsSection1Content =>
      'Estos términos y condiciones tienen como objetivo definir los derechos, obligaciones y responsabilidades entre SONA (en adelante \"Compañía\") y los usuarios en relación con el uso del servicio de coincidencia de conversación con persona de IA (en adelante \"Servicio\") proporcionado por la Compañía.';

  @override
  String get termsSection1Title => 'Artículo 1 (Propósito)';

  @override
  String get termsSection2Content =>
      'Al utilizar nuestro servicio, aceptas estar sujeto a estos Términos de Servicio y a nuestra Política de Privacidad.';

  @override
  String get termsSection2Title => 'Artículo 2 (Definiciones)';

  @override
  String get termsSection3Content =>
      'Debes tener al menos 13 años para utilizar nuestro servicio.';

  @override
  String get termsSection3Title =>
      'Artículo 3 (Efecto y Modificación de los Términos)';

  @override
  String get termsSection4Content =>
      'Eres responsable de mantener la confidencialidad de tu cuenta y contraseña.';

  @override
  String get termsSection4Title => 'Artículo 4 (Prestación del Servicio)';

  @override
  String get termsSection5Content =>
      'Aceptas no utilizar nuestro servicio para ningún propósito ilegal o no autorizado.';

  @override
  String get termsSection5Title => 'Artículo 5 (Registro de Membresía)';

  @override
  String get termsSection6Content =>
      'Nos reservamos el derecho de terminar o suspender tu cuenta por violación de estos términos.';

  @override
  String get termsSection6Title => 'Artículo 6 (Obligaciones del Usuario)';

  @override
  String get termsSection7Content =>
      'La Compañía puede restringir gradualmente el uso del servicio a través de advertencias, suspensión temporal o suspensión permanente si los usuarios violan las obligaciones de estos términos o interfieren con el funcionamiento normal del servicio.';

  @override
  String get termsSection7Title =>
      'Artículo 7 (Restricciones en el Uso del Servicio)';

  @override
  String get termsSection8Content =>
      'No somos responsables de ningún daño indirecto, incidental o consecuente que surja de tu uso de nuestro servicio.';

  @override
  String get termsSection8Title => 'Artículo 8 (Interrupción del Servicio)';

  @override
  String get termsSection9Content =>
      'Todo el contenido y materiales disponibles en nuestro servicio están protegidos por derechos de propiedad intelectual.';

  @override
  String get termsSection9Title => 'Artículo 9 (Descargo de Responsabilidad)';

  @override
  String get termsSupplementary => 'Términos Suplementarios';

  @override
  String get thai => 'Tailandés';

  @override
  String get thanksFeedback => '¡Gracias por tus comentarios!';

  @override
  String get theme => 'Tema';

  @override
  String get themeDescription =>
      'Puedes personalizar la apariencia de la app como desees';

  @override
  String get themeSettings => 'Configuración del Tema';

  @override
  String get thursday => 'Jueves';

  @override
  String get timeout => 'Tiempo de espera';

  @override
  String get tired => 'Cansado';

  @override
  String get today => 'Hoy';

  @override
  String get todayChats => 'Hoy';

  @override
  String get todayText => 'Hoy';

  @override
  String get tomorrowText => 'Mañana';

  @override
  String get totalConsultSessions => 'Total de Sesiones de Consulta';

  @override
  String get totalErrorCount => 'Total de Errores';

  @override
  String get totalLikes => 'Total de Me gusta';

  @override
  String totalOccurrences(Object count) {
    return 'Total de $count ocurrencias';
  }

  @override
  String get totalResponses => 'Total de Respuestas';

  @override
  String get translatedFrom => 'Traducido';

  @override
  String get translatedText => 'Traducción';

  @override
  String get translationError => 'Error de traducción';

  @override
  String get translationErrorDescription =>
      'Por favor, informa sobre traducciones incorrectas o expresiones poco naturales';

  @override
  String get translationErrorReported =>
      'Error de traducción reportado. ¡Gracias!';

  @override
  String get translationNote => '※ La traducción de IA puede no ser perfecta';

  @override
  String get translationQuality => 'Calidad de la Traducción';

  @override
  String get translationSettings => 'Configuración de Traducción';

  @override
  String get travel => 'Viajar';

  @override
  String get tuesday => 'Martes';

  @override
  String get tutorialAccount => 'Cuenta de Tutorial';

  @override
  String get tutorialWelcomeDescription =>
      'Crea relaciones especiales con personajes de IA.';

  @override
  String get tutorialWelcomeTitle => '¡Bienvenido a SONA!';

  @override
  String get typeMessage => 'Escribe un mensaje...';

  @override
  String get unblock => 'Desbloquear';

  @override
  String get unblockFailed => 'No se pudo desbloquear';

  @override
  String unblockPersonaConfirm(String name) {
    return '¿Desbloquear a $name?';
  }

  @override
  String get unblockedSuccessfully => 'Desbloqueado con éxito';

  @override
  String get unexpectedLoginError =>
      'Ocurrió un error inesperado durante el inicio de sesión';

  @override
  String get unknown => 'Desconocido';

  @override
  String get unknownError => 'Error desconocido';

  @override
  String get unlimitedMessages => 'Ilimitado';

  @override
  String get unsendMessage => 'Anular envío de mensaje';

  @override
  String get usagePurpose => 'Propósito de Uso';

  @override
  String get useOneHeart => 'Usar 1 Corazón';

  @override
  String get useSystemLanguage => 'Usar Idioma del Sistema';

  @override
  String get user => 'Usuario:';

  @override
  String get userMessage => 'Mensaje del Usuario:';

  @override
  String get userNotFound => 'Usuario no encontrado';

  @override
  String get valentinesDay => 'Día de San Valentín';

  @override
  String get verifyingAuth => 'Verificando autenticación';

  @override
  String get version => 'Versión';

  @override
  String get vietnamese => 'Vietnamita';

  @override
  String get violentContent => 'Contenido violento';

  @override
  String get voiceMessage => '🎤 Mensaje de voz';

  @override
  String waitingForChat(String name) {
    return '$name está esperando para chatear.';
  }

  @override
  String get walk => 'Caminar';

  @override
  String get wasHelpful => '¿Fue útil?';

  @override
  String get weatherClear => 'Despejado';

  @override
  String get weatherCloudy => 'Nublado';

  @override
  String get weatherContext => 'Contexto del clima';

  @override
  String get weatherContextDesc =>
      'Proporciona contexto de conversación basado en el clima';

  @override
  String get weatherDrizzle => 'Llovizna';

  @override
  String get weatherFog => 'Niebla';

  @override
  String get weatherMist => 'Bruma';

  @override
  String get weatherRain => 'Lluvia';

  @override
  String get weatherRainy => 'Lluvioso';

  @override
  String get weatherSnow => 'Nieve';

  @override
  String get weatherSnowy => 'Nevado';

  @override
  String get weatherThunderstorm => 'Tormenta eléctrica';

  @override
  String get wednesday => 'Miércoles';

  @override
  String get weekdays => 'Dom,Lun,Mar,Mié,Jue,Vie,Sáb';

  @override
  String get welcomeMessage => '¡Bienvenido!💕';

  @override
  String get whatTopicsToTalk =>
      '¿Sobre qué temas te gustaría hablar? (Opcional)';

  @override
  String get whiteDay => 'Día Blanco';

  @override
  String get winter => 'Invierno';

  @override
  String get wrongTranslation => 'Traducción incorrecta';

  @override
  String get year => 'Año';

  @override
  String get yearEnd => 'Fin de año';

  @override
  String get yes => 'Sí';

  @override
  String get yesterday => 'Ayer';

  @override
  String get yesterdayChats => 'Ayer';

  @override
  String get you => 'Tú';

  @override
  String get loadingPersonaData => 'Cargando datos de persona';

  @override
  String get checkingMatchedPersonas => 'Verificando personas coincidentes';

  @override
  String get preparingImages => 'Preparando imágenes';

  @override
  String get finalPreparation => 'Preparación final';

  @override
  String get editProfileSubtitle =>
      'Editar género, fecha de nacimiento e introducción';

  @override
  String get systemThemeName => 'Sistema';

  @override
  String get lightThemeName => 'Claro';

  @override
  String get darkThemeName => 'Oscuro';

  @override
  String get alwaysShowTranslationOn => 'Always Show Translation';

  @override
  String get alwaysShowTranslationOff => 'Hide Auto Translation';

  @override
  String get translationErrorAnalysisInfo =>
      'Analizaremos el mensaje seleccionado y su traducción.';

  @override
  String get whatWasWrongWithTranslation =>
      '¿Qué estaba mal con la traducción?';

  @override
  String get translationErrorHint =>
      'Ej: Significado incorrecto, expresión poco natural, contexto erróneo...';

  @override
  String get pleaseSelectMessage => 'Por favor, selecciona un mensaje primero';

  @override
  String get myPersonas => 'Mis Personas';

  @override
  String get createPersona => 'Crear Persona';

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
  String get mbtiQuestion => 'Pregunta de Personalidad';

  @override
  String get mbtiComplete => '¡Prueba de Personalidad Completa!';

  @override
  String get mbtiTest => 'Test MBTI';

  @override
  String get mbtiStepDescription =>
      '¿Qué personalidad quieres que tenga tu persona? Responde las preguntas para definir su carácter.';

  @override
  String get startTest => 'Iniciar Prueba';

  @override
  String get personalitySettings => 'Personality Settings';

  @override
  String get speechStyle => 'Estilo de Habla';

  @override
  String get conversationStyle => 'Estilo de Conversación';

  @override
  String get shareWithCommunity => 'Share with Community';

  @override
  String get shareDescription =>
      'Your persona can be shared with other users after approval';

  @override
  String get sharePersona => 'Share Persona';

  @override
  String get willBeSharedAfterApproval =>
      'Se compartirá después de la aprobación del administrador';

  @override
  String get privatePersonaDescription => 'Only you can see this persona';

  @override
  String get create => 'Create';

  @override
  String get personaCreated => 'Persona creada exitosamente';

  @override
  String get createFailed => 'Falló la creación';

  @override
  String get pendingApproval => 'Pendiente de Aprobación';

  @override
  String get approved => 'Aprobado';

  @override
  String get privatePersona => 'Private';

  @override
  String get noPersonasYet => 'No Personas Yet';

  @override
  String get createYourFirstPersona =>
      'Create your first persona and start your journey';

  @override
  String get deletePersona => 'Eliminar Persona';

  @override
  String get deletePersonaConfirm =>
      '¿Estás seguro de que deseas eliminar esta persona? Esta acción no se puede deshacer.';

  @override
  String get personaDeleted => 'Persona eliminada exitosamente';

  @override
  String get deleteFailed => 'Falló la eliminación';

  @override
  String get personaLimitReached => 'You have reached the limit of 3 personas';

  @override
  String get personaName => 'Nombre de Persona';

  @override
  String get personaAge => 'Edad';

  @override
  String get personaDescription => 'Descripción';

  @override
  String get personaNameHint => 'Ej: Ana, Carlos';

  @override
  String get personaDescriptionHint => 'Describe a tu persona brevemente';

  @override
  String get loginRequiredContent => 'Please log in to continue';

  @override
  String get reportErrorButton => 'Report Error';

  @override
  String get speechStyleFriendly => 'Amigable';

  @override
  String get speechStylePolite => 'Educado';

  @override
  String get speechStyleChic => 'Elegante';

  @override
  String get speechStyleLively => 'Animado';

  @override
  String get conversationStyleTalkative => 'Hablador';

  @override
  String get conversationStyleQuiet => 'Callado';

  @override
  String get conversationStyleEmpathetic => 'Empático';

  @override
  String get conversationStyleLogical => 'Lógico';

  @override
  String get interestMusic => 'Música';

  @override
  String get interestMovies => 'Películas';

  @override
  String get interestReading => 'Lectura';

  @override
  String get interestTravel => 'Viajes';

  @override
  String get interestExercise => 'Ejercicio';

  @override
  String get interestGaming => 'Videojuegos';

  @override
  String get interestCooking => 'Cocina';

  @override
  String get interestFashion => 'Moda';

  @override
  String get interestArt => 'Arte';

  @override
  String get interestPhotography => 'Fotografía';

  @override
  String get interestTechnology => 'Tecnología';

  @override
  String get interestScience => 'Ciencia';

  @override
  String get interestHistory => 'Historia';

  @override
  String get interestPhilosophy => 'Filosofía';

  @override
  String get interestPolitics => 'Política';

  @override
  String get interestEconomy => 'Economía';

  @override
  String get interestSports => 'Deportes';

  @override
  String get interestAnimation => 'Animación';

  @override
  String get interestKpop => 'K-POP';

  @override
  String get interestDrama => 'Drama';

  @override
  String get imageOptionalR2 =>
      'Las imágenes son opcionales. Solo se cargarán si R2 está configurado.';

  @override
  String get networkErrorCheckConnection =>
      'Error de red: Por favor, verifica tu conexión a internet';

  @override
  String get maxFiveItems => 'Hasta 5 elementos';

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
