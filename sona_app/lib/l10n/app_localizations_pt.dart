// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get about => 'Sobre';

  @override
  String get accountAndProfile => 'Informações da Conta e do Perfil';

  @override
  String get accountDeletedSuccess => 'Conta excluída com sucesso';

  @override
  String get accountDeletionContent =>
      'Você tem certeza de que deseja excluir sua conta? Esta ação não pode ser desfeita.';

  @override
  String get accountDeletionError => 'Ocorreu um erro ao excluir a conta.';

  @override
  String get accountDeletionInfo => 'Informações sobre exclusão de conta';

  @override
  String get accountDeletionTitle => 'Excluir Conta';

  @override
  String get accountDeletionWarning1 =>
      'Aviso: Esta ação não pode ser desfeita';

  @override
  String get accountDeletionWarning2 =>
      'Todos os seus dados serão excluídos permanentemente';

  @override
  String get accountDeletionWarning3 =>
      'Você perderá o acesso a todas as conversas';

  @override
  String get accountDeletionWarning4 => 'Isso inclui todo o conteúdo comprado';

  @override
  String get accountManagement => 'Gerenciamento de Conta';

  @override
  String get adaptiveConversationDesc =>
      'Adapta o estilo da conversa para combinar com o seu';

  @override
  String get afternoon => 'Tarde';

  @override
  String get afternoonFatigue => 'Cansaço da Tarde';

  @override
  String get ageConfirmation => 'Tenho 14 anos ou mais e confirmei o acima.';

  @override
  String ageRange(int min, int max) {
    return '$min-$max anos';
  }

  @override
  String get ageUnit => 'anos';

  @override
  String get agreeToTerms => 'Concordo com os termos';

  @override
  String get aiDatingQuestion => 'Uma vida especial do dia a dia com a IA';

  @override
  String get aiPersonaPreferenceDescription =>
      'Por favor, defina suas preferências para o emparelhamento de personas de IA';

  @override
  String get all => 'Todos';

  @override
  String get allAgree => 'Concordar com Todos';

  @override
  String get allFeaturesRequired =>
      '※ Todas as funcionalidades são necessárias para a prestação do serviço';

  @override
  String get allPersonas => 'Todas as Personas';

  @override
  String get allPersonasMatched =>
      'Todas as personas correspondem! Comece a conversar com elas.';

  @override
  String get allowPermission => 'Continuar';

  @override
  String alreadyChattingWith(String name) {
    return 'Já está conversando com $name!';
  }

  @override
  String get alsoBlockThisAI => 'Também bloquear esta IA';

  @override
  String get angry => 'Bravo';

  @override
  String get anonymousLogin => 'Login anônimo';

  @override
  String get anxious => 'Ansioso';

  @override
  String get apiKeyError => 'Erro de Chave de API';

  @override
  String get appName => 'SONA';

  @override
  String get appTagline => 'Seus companheiros de IA';

  @override
  String get appleLoginCanceled =>
      'O login com a Apple foi cancelado. Por favor, tente novamente.';

  @override
  String get appleLoginError => 'Ocorreu um erro durante o login com a Apple.';

  @override
  String get art => 'Arte';

  @override
  String get authError => 'Erro de Autenticação';

  @override
  String get autoTranslate => 'Tradução Automática';

  @override
  String get autumn => 'Outono';

  @override
  String get averageQuality => 'Qualidade Média';

  @override
  String get averageQualityScore => 'Pontuação de Qualidade Média';

  @override
  String get awkwardExpression => 'Expressão Estranha';

  @override
  String get backButton => 'Voltar';

  @override
  String get basicInfo => 'Informações Básicas';

  @override
  String get basicInfoDescription =>
      'Por favor, insira informações básicas para criar uma conta';

  @override
  String get birthDate => 'Data de Nascimento';

  @override
  String get birthDateOptional => 'Data de Nascimento (Opcional)';

  @override
  String get birthDateRequired => 'Data de Nascimento *';

  @override
  String get blockConfirm =>
      'Você deseja bloquear esta IA? AIs bloqueadas serão excluídas da lista de correspondência e chat.';

  @override
  String get blockReason => 'Motivo do bloqueio';

  @override
  String get blockThisAI => 'Bloquear esta IA';

  @override
  String blockedAICount(int count) {
    return '$count AIs bloqueadas';
  }

  @override
  String get blockedAIs => 'AIs Bloqueadas';

  @override
  String get blockedAt => 'Bloqueado em';

  @override
  String get blockedSuccessfully => 'Bloqueado com sucesso';

  @override
  String get breakfast => 'Café da manhã';

  @override
  String get byErrorType => 'Por Tipo de Erro';

  @override
  String get byPersona => 'Por Persona';

  @override
  String cacheDeleteError(String error) {
    return 'Erro ao deletar cache: $error';
  }

  @override
  String get cacheDeleted => 'O cache de imagens foi deletado';

  @override
  String get cafeTerrace => 'Terraço do café';

  @override
  String get calm => 'Calmo';

  @override
  String get cameraPermission => 'Permissão da câmera';

  @override
  String get cameraPermissionDesc =>
      'O acesso à câmera é necessário para tirar fotos do perfil.';

  @override
  String get canChangeInSettings =>
      'Você pode mudar isso depois nas configurações';

  @override
  String get canMeetPreviousPersonas =>
      'Você pode encontrar personas que você deslizou antes novamente!';

  @override
  String get cancel => 'Cancelar';

  @override
  String get changeProfilePhoto => 'Alterar foto do perfil';

  @override
  String get chat => 'Conversa';

  @override
  String get chatEndedMessage => 'O chat foi encerrado';

  @override
  String get chatErrorDashboard => 'Painel de Erros de Chat';

  @override
  String get chatErrorSentSuccessfully =>
      'O erro do chat foi enviado com sucesso.';

  @override
  String get chatListTab => 'Aba de Lista de Chats';

  @override
  String get chats => 'Chats';

  @override
  String chattingWithPersonas(int count) {
    return 'Conversando com $count personas';
  }

  @override
  String get checkInternetConnection => 'Verifique sua conexão com a internet';

  @override
  String get checkingUserInfo => 'Verificando informações do usuário';

  @override
  String get childrensDay => 'Dia das Crianças';

  @override
  String get chinese => 'Chinês';

  @override
  String get chooseOption => 'Por favor, escolha:';

  @override
  String get christmas => 'Natal';

  @override
  String get close => 'Fechar';

  @override
  String get complete => 'Concluído';

  @override
  String get completeSignup => 'Finalizar Cadastro';

  @override
  String get confirm => 'Confirmar';

  @override
  String get connectingToServer => 'Conectando ao servidor';

  @override
  String get consultQualityMonitoring =>
      'Monitoramento de Qualidade da Consulta';

  @override
  String get continueAsGuest => 'Continuar como Convidado';

  @override
  String get continueButton => 'Continuar';

  @override
  String get continueWithApple => 'Continuar com a Apple';

  @override
  String get continueWithGoogle => 'Continuar com o Google';

  @override
  String get conversationContinuity => 'Continuidade da Conversa';

  @override
  String get conversationContinuityDesc =>
      'Lembre-se das conversas anteriores e conecte os tópicos';

  @override
  String conversationWith(String name) {
    return '$name';
  }

  @override
  String get convertToMember => 'Inscrever-se';

  @override
  String get cooking => 'Cozinhando';

  @override
  String get copyMessage => 'Copiar mensagem';

  @override
  String get copyrightInfringement => 'Violação de direitos autorais';

  @override
  String get creatingAccount => 'Criando conta';

  @override
  String get crisisDetected => 'Crise Detectada';

  @override
  String get culturalIssue => 'Questão Cultural';

  @override
  String get current => 'Atual';

  @override
  String get currentCacheSize => 'Tamanho Atual do Cache';

  @override
  String get currentLanguage => 'Idioma atual';

  @override
  String get cycling => 'Ciclismo';

  @override
  String get dailyCare => 'Cuidados Diários';

  @override
  String get dailyCareDesc =>
      'Mensagens diárias de cuidados para refeições, sono, saúde';

  @override
  String get dailyChat => 'Bate-papo Diário';

  @override
  String get dailyCheck => 'Verificação Diária';

  @override
  String get dailyConversation => 'Conversa Diária';

  @override
  String get dailyLimitDescription =>
      'Você atingiu seu limite diário de mensagens';

  @override
  String get dailyLimitTitle => 'Limite diário atingido';

  @override
  String get darkMode => 'Modo escuro';

  @override
  String get darkTheme => 'Modo Escuro';

  @override
  String get darkThemeDesc => 'Use o tema escuro';

  @override
  String get dataCollection => 'Configurações de Coleta de Dados';

  @override
  String get datingAdvice => 'Conselhos sobre Relacionamento';

  @override
  String get datingDescription =>
      'Quero compartilhar pensamentos profundos e ter conversas sinceras';

  @override
  String get dawn => 'Amanhecer';

  @override
  String get day => 'Dia';

  @override
  String get dayAfterTomorrow => 'Depois de amanhã';

  @override
  String daysAgo(int count, String formatted) {
    return '$count dias atrás';
  }

  @override
  String daysRemaining(int days) {
    return '$days dias restantes';
  }

  @override
  String get deepTalk => 'Conversa Profunda';

  @override
  String get delete => 'Excluir';

  @override
  String get deleteAccount => 'Excluir conta';

  @override
  String get deleteAccountConfirm =>
      'Você tem certeza de que deseja excluir sua conta? Esta ação não pode ser desfeita.';

  @override
  String get deleteAccountWarning =>
      'Tem certeza de que deseja excluir sua conta?';

  @override
  String get deleteCache => 'Excluir Cache';

  @override
  String get deletingAccount => 'Excluindo conta...';

  @override
  String get depressed => 'Deprimido';

  @override
  String get describeError => 'Qual é o problema?';

  @override
  String get detailedReason => 'Motivo detalhado';

  @override
  String get developRelationshipStep =>
      '3. Desenvolver Relacionamento: Crie intimidade através de conversas e desenvolva relacionamentos especiais.';

  @override
  String get dinner => 'Jantar';

  @override
  String get discardGuestData => 'Começar do Zero';

  @override
  String get discount20 => '20% de desconto';

  @override
  String get discount30 => '30% de desconto';

  @override
  String get discountAmount => 'Economize';

  @override
  String discountAmountValue(String amount) {
    return 'Economize ₩$amount';
  }

  @override
  String get done => 'Concluído';

  @override
  String get downloadingPersonaImages => 'Baixando novas imagens de persona';

  @override
  String get edit => 'Editar';

  @override
  String get editInfo => 'Editar Informações';

  @override
  String get editProfile => 'Editar Perfil';

  @override
  String get effectSound => 'Efeitos Sonoros';

  @override
  String get effectSoundDescription => 'Reproduzir efeitos sonoros';

  @override
  String get email => 'E-mail';

  @override
  String get emailHint => 'exemplo@email.com';

  @override
  String get emailLabel => 'Email';

  @override
  String get emailRequired => 'Email *';

  @override
  String get emotionAnalysis => 'Análise de Emoção';

  @override
  String get emotionAnalysisDesc => 'Analise emoções para respostas empáticas';

  @override
  String get emotionAngry => 'Bravo';

  @override
  String get emotionBasedEncounters => 'Encontros baseados em emoções';

  @override
  String get emotionCool => 'Legal';

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
      'Compartilhe suas preocupações e receba conforto acolhedor';

  @override
  String get endChat => 'Encerrar Chat';

  @override
  String get endTutorial => 'Encerrar Tutorial';

  @override
  String get endTutorialAndLogin => 'Encerrar o tutorial e fazer login?';

  @override
  String get endTutorialMessage =>
      'Você quer encerrar o tutorial e fazer login?';

  @override
  String get english => 'Inglês';

  @override
  String get enterBasicInfo =>
      'Por favor, insira informações básicas para criar uma conta';

  @override
  String get enterBasicInformation => 'Por favor, insira informações básicas';

  @override
  String get enterEmail => 'Por favor, insira o e-mail';

  @override
  String get enterNickname => 'Digite um apelido';

  @override
  String get enterPassword => 'Digite uma senha';

  @override
  String get entertainmentAndFunDesc =>
      'Aproveite jogos divertidos e conversas agradáveis';

  @override
  String get entertainmentDescription =>
      'Quero ter conversas divertidas e aproveitar meu tempo';

  @override
  String get entertainmentFun => 'Entretenimento/Diversão';

  @override
  String get error => 'Erro';

  @override
  String get errorDescription => 'Descrição do erro';

  @override
  String get errorDescriptionHint =>
      'por exemplo, Deu respostas estranhas, Repete a mesma coisa, Dá respostas contextualmente inadequadas...';

  @override
  String get errorDetails => 'Detalhes do Erro';

  @override
  String get errorDetailsHint =>
      'Por favor, explique em detalhes o que está errado';

  @override
  String get errorFrequency24h => 'Frequência de Erros (Últimas 24 horas)';

  @override
  String get errorMessage => 'Mensagem de Erro:';

  @override
  String get errorOccurred => 'Ocorreu um erro.';

  @override
  String get errorOccurredTryAgain =>
      'Ocorreu um erro. Por favor, tente novamente.';

  @override
  String get errorSendingFailed => 'Falha ao enviar o erro';

  @override
  String get errorStats => 'Estatísticas de Erros';

  @override
  String errorWithMessage(String error) {
    return 'Ocorreu um erro: $error';
  }

  @override
  String get evening => 'Noite';

  @override
  String get excited => 'Animado';

  @override
  String get exit => 'Sair';

  @override
  String get exitApp => 'Sair do App';

  @override
  String get exitConfirmMessage =>
      'Você tem certeza de que deseja sair do app?';

  @override
  String get expertPersona => 'Persona Especialista';

  @override
  String get expertiseScore => 'Pontuação de Especialização';

  @override
  String get expired => 'Expirado';

  @override
  String get explainReportReason =>
      'Por favor, explique o motivo da denúncia em detalhes';

  @override
  String get fashion => 'Moda';

  @override
  String get female => 'Feminino';

  @override
  String get filter => 'Filtro';

  @override
  String get firstOccurred => 'Primeira Ocorrência:';

  @override
  String get followDeviceLanguage =>
      'Seguir as configurações de idioma do dispositivo';

  @override
  String get forenoon => 'Manhã';

  @override
  String get forgotPassword => 'Esqueceu a senha?';

  @override
  String get frequentlyAskedQuestions => 'Perguntas Frequentes';

  @override
  String get friday => 'Sexta-feira';

  @override
  String get friendshipDescription =>
      'Quero conhecer novos amigos e ter conversas';

  @override
  String get funChat => 'Bate-papo Divertido';

  @override
  String get galleryPermission => 'Permissão da galeria';

  @override
  String get galleryPermissionDesc =>
      'O acesso à galeria é necessário para selecionar fotos do perfil.';

  @override
  String get gaming => 'Jogos';

  @override
  String get gender => 'Gênero';

  @override
  String get genderNotSelectedInfo =>
      'Se o gênero não for selecionado, serão mostradas personas de todos os gêneros';

  @override
  String get genderOptional => 'Gênero (Opcional)';

  @override
  String get genderPreferenceActive =>
      'Você pode conhecer personas de todos os gêneros';

  @override
  String get genderPreferenceDisabled =>
      'Selecione seu gênero para habilitar a opção de gênero oposto apenas';

  @override
  String get genderPreferenceInactive =>
      'Apenas personas do gênero oposto serão mostradas';

  @override
  String get genderRequired => 'Gênero *';

  @override
  String get genderSelectionInfo =>
      'Se não selecionado, você pode conhecer personas de todos os gêneros';

  @override
  String get generalPersona => 'Persona Geral';

  @override
  String get goToSettings => 'Ir para configurações';

  @override
  String get permissionGuideAndroid =>
      'Settings > Apps > SONA > Permissions\nPlease allow photo permission';

  @override
  String get permissionGuideIOS =>
      'Settings > SONA > Photos\nPlease allow photo access';

  @override
  String get googleLoginCanceled =>
      'O login do Google foi cancelado. Por favor, tente novamente.';

  @override
  String get googleLoginError => 'Ocorreu um erro durante o login do Google.';

  @override
  String get grantPermission => 'Continuar';

  @override
  String get guest => 'Convidado';

  @override
  String get guestDataMigration =>
      'Você gostaria de manter seu histórico de chat atual ao se inscrever?';

  @override
  String get guestLimitReached => 'O período de teste do convidado terminou.';

  @override
  String get guestLoginPromptMessage => 'Faça login para continuar a conversa';

  @override
  String get guestMessageExhausted => 'Mensagens gratuitas esgotadas';

  @override
  String guestMessageRemaining(int count) {
    return '$count mensagens de convidado restantes';
  }

  @override
  String get guestModeBanner => 'Modo Convidado';

  @override
  String get guestModeDescription => 'Experimente o SONA sem se inscrever';

  @override
  String get guestModeFailedMessage => 'Falha ao iniciar o Modo Convidado';

  @override
  String get guestModeLimitation =>
      'Alguns recursos são limitados no Modo Convidado';

  @override
  String get guestModeTitle => 'Experimente como Convidado';

  @override
  String get guestModeWarning => 'O modo convidado dura 24 horas,';

  @override
  String get guestModeWelcome => 'Iniciando no Modo Convidado';

  @override
  String get happy => 'Feliz';

  @override
  String get hapticFeedback => 'Feedback Háptico';

  @override
  String get harassmentBullying => 'Assédio/Bullying';

  @override
  String get hateSpeech => 'Discurso de ódio';

  @override
  String get heartDescription => 'Corações para mais mensagens';

  @override
  String get heartInsufficient => 'Corações insuficientes';

  @override
  String get heartInsufficientPleaseCharge =>
      'Não há corações suficientes. Por favor, recarregue os corações.';

  @override
  String get heartRequired => '1 coração é necessário';

  @override
  String get heartUsageFailed => 'Falha ao usar o coração.';

  @override
  String get hearts => 'Corações';

  @override
  String get hearts10 => '10 Corações';

  @override
  String get hearts30 => '30 Corações';

  @override
  String get hearts30Discount => 'PROMOÇÃO';

  @override
  String get hearts50 => '50 Corações';

  @override
  String get hearts50Discount => 'PROMOÇÃO';

  @override
  String get helloEmoji => 'Olá! 😊';

  @override
  String get help => 'Ajuda';

  @override
  String get hideOriginalText => 'Ocultar Original';

  @override
  String get hobbySharing => 'Compartilhamento de Hobbies';

  @override
  String get hobbyTalk => 'Conversa sobre Hobbies';

  @override
  String get hours24Ago => '24 horas atrás';

  @override
  String hoursAgo(int count, String formatted) {
    return '$count horas atrás';
  }

  @override
  String get howToUse => 'Como usar o SONA';

  @override
  String get imageCacheManagement => 'Gerenciamento de Cache de Imagens';

  @override
  String get inappropriateContent => 'Conteúdo inapropriado';

  @override
  String get incorrect => 'incorreto';

  @override
  String get incorrectPassword => 'Senha incorreta';

  @override
  String get indonesian => 'Indonésio';

  @override
  String get inquiries => 'Consultas';

  @override
  String get insufficientHearts => 'Corações insuficientes.';

  @override
  String get interestSharing => 'Compartilhamento de Interesses';

  @override
  String get interestSharingDesc =>
      'Descubra e recomende interesses compartilhados';

  @override
  String get interests => 'Interesses';

  @override
  String get invalidEmailFormat => 'Formato de email inválido';

  @override
  String get invalidEmailFormatError => 'Digite um endereço de email válido';

  @override
  String isTyping(String name) {
    return '$name está digitando...';
  }

  @override
  String get japanese => 'Japonês';

  @override
  String get joinDate => 'Data de Entrada';

  @override
  String get justNow => 'Agora mesmo';

  @override
  String get keepGuestData => 'Manter Histórico de Conversas';

  @override
  String get korean => 'Coreano';

  @override
  String get koreanLanguage => 'Coreano';

  @override
  String get language => 'Idioma';

  @override
  String get languageDescription => 'A IA responderá no seu idioma selecionado';

  @override
  String get languageIndicator => 'Idioma';

  @override
  String get languageSettings => 'Configurações de Idioma';

  @override
  String get lastOccurred => 'Última Ocorrência:';

  @override
  String get lastUpdated => 'Última atualização';

  @override
  String get lateNight => 'Madrugada';

  @override
  String get later => 'Depois';

  @override
  String get laterButton => 'Depois';

  @override
  String get leave => 'Sair';

  @override
  String get leaveChatConfirm => 'Sair deste chat?';

  @override
  String get leaveChatRoom => 'Sair da Sala de Chat';

  @override
  String get leaveChatTitle => 'Sair do Chat';

  @override
  String get lifeAdvice => 'Conselhos de Vida';

  @override
  String get lightTalk => 'Conversa Leve';

  @override
  String get lightTheme => 'Modo Claro';

  @override
  String get lightThemeDesc => 'Use tema claro';

  @override
  String get loading => 'Carregando...';

  @override
  String get loadingData => 'Carregando dados...';

  @override
  String get loadingProducts => 'Carregando produtos...';

  @override
  String get loadingProfile => 'Carregando perfil';

  @override
  String get login => 'Entrar';

  @override
  String get loginButton => 'Entrar';

  @override
  String get loginCancelled => 'Login cancelado';

  @override
  String get loginComplete => 'Login concluído';

  @override
  String get loginError => 'Falha no login';

  @override
  String get loginFailed => 'Falha no login';

  @override
  String get loginFailedTryAgain => 'Falha no login. Tente novamente.';

  @override
  String get loginRequired => 'Login necessário';

  @override
  String get loginRequiredForProfile => 'Login necessário para ver o perfil';

  @override
  String get loginRequiredService => 'Login necessário para usar este serviço';

  @override
  String get loginRequiredTitle => 'Login Necessário';

  @override
  String get loginSignup => 'Login/Cadastrar';

  @override
  String get loginTab => 'Login';

  @override
  String get loginTitle => 'Login';

  @override
  String get loginWithApple => 'Entrar com Apple';

  @override
  String get loginWithGoogle => 'Entrar com Google';

  @override
  String get logout => 'Sair';

  @override
  String get logoutConfirm => 'Tem certeza de que deseja sair?';

  @override
  String get lonelinessRelief => 'Alívio da Solidão';

  @override
  String get lonely => 'Sozinho';

  @override
  String get lowQualityResponses => 'Respostas de Baixa Qualidade';

  @override
  String get lunch => 'Almoço';

  @override
  String get lunchtime => 'Hora do Almoço';

  @override
  String get mainErrorType => 'Tipo de Erro Principal';

  @override
  String get makeFriends => 'Fazer Amigos';

  @override
  String get male => 'Masculino';

  @override
  String get manageBlockedAIs => 'Gerenciar AIs Bloqueados';

  @override
  String get managePersonaImageCache => 'Gerenciar cache de imagem da persona';

  @override
  String get marketingAgree =>
      'Concordar com Informações de Marketing (Opcional)';

  @override
  String get marketingDescription =>
      'Você pode receber informações sobre eventos e benefícios';

  @override
  String get matchPersonaStep =>
      '1. Combinar Personas: Deslize para a esquerda ou para a direita para selecionar suas personas de IA favoritas.';

  @override
  String get matchedPersonas => 'Personas Correspondidas';

  @override
  String get matchedSona => 'Sona Correspondida';

  @override
  String get matching => 'Correspondendo';

  @override
  String get matchingFailed => 'A correspondência falhou.';

  @override
  String get me => 'Me';

  @override
  String get meetAIPersonas => 'Conheça Personas de IA';

  @override
  String get meetNewPersonas => 'Conhecer novas personas';

  @override
  String get meetPersonas => 'Conheça Personas';

  @override
  String get memberBenefits =>
      'Receba mais de 100 mensagens e 10 corações ao se inscrever!';

  @override
  String get memoryAlbum => 'Álbum de Memórias';

  @override
  String get memoryAlbumDesc =>
      'Salve e recorde automaticamente momentos especiais';

  @override
  String get messageCopied => 'Mensagem copiada';

  @override
  String get messageDeleted => 'Mensagem deletada';

  @override
  String get messageLimitReset =>
      'O limite de mensagens será redefinido à meia-noite';

  @override
  String get messageSendFailed =>
      'Falha ao enviar a mensagem. Por favor, tente novamente.';

  @override
  String get messagesRemaining => 'Mensagens restantes';

  @override
  String minutesAgo(int count, String formatted) {
    return '$count minutos atrás';
  }

  @override
  String get missingTranslation => 'Tradução ausente';

  @override
  String get monday => 'Segunda-feira';

  @override
  String get month => 'Mês';

  @override
  String monthDay(String month, int day) {
    return '$month $day';
  }

  @override
  String get moreButton => 'Mais';

  @override
  String get morning => 'Manhã';

  @override
  String get mostFrequentError => 'Erro mais frequente';

  @override
  String get movies => 'Filmes';

  @override
  String get multilingualChat => 'Chat multilíngue';

  @override
  String get music => 'Música';

  @override
  String get myGenderSection => 'Meu Gênero (Opcional)';

  @override
  String get networkErrorOccurred => 'Ocorreu um erro de rede.';

  @override
  String get newMessage => 'Nova mensagem';

  @override
  String newMessageCount(int count) {
    return '$count novas mensagens';
  }

  @override
  String get newMessageNotification => 'Notificação de nova mensagem';

  @override
  String get newMessages => 'Novas mensagens';

  @override
  String get newYear => 'Ano Novo';

  @override
  String get next => 'Próximo';

  @override
  String get niceToMeetYou => 'Prazer em conhecê-lo!';

  @override
  String get nickname => 'Apelido';

  @override
  String get nicknameAlreadyUsed => 'Este apelido já está em uso';

  @override
  String get nicknameHelperText => '3-10 caracteres';

  @override
  String get nicknameHint => '3-10 caracteres';

  @override
  String get nicknameInUse => 'Este apelido já está em uso';

  @override
  String get nicknameLabel => 'Apelido';

  @override
  String get nicknameLengthError =>
      'O apelido deve ter entre 3 e 10 caracteres';

  @override
  String get nicknamePlaceholder => 'Digite seu apelido';

  @override
  String get nicknameRequired => 'Apelido *';

  @override
  String get night => 'Noite';

  @override
  String get no => 'Não';

  @override
  String get noBlockedAIs => 'Nenhuma IA bloqueada';

  @override
  String get noChatsYet => 'Nenhuma conversa ainda';

  @override
  String get noConversationYet => 'Ainda sem conversa';

  @override
  String get noErrorReports => 'Nenhum relatório de erro.';

  @override
  String get noImageAvailable => 'Nenhuma imagem disponível';

  @override
  String get noMatchedPersonas => 'Ainda sem personas correspondentes';

  @override
  String get noMatchedSonas => 'Nenhum SONA correspondente até agora';

  @override
  String get noPersonasAvailable =>
      'Nenhuma persona disponível. Por favor, tente novamente.';

  @override
  String get noPersonasToSelect => 'Nenhuma persona disponível';

  @override
  String get noQualityIssues => 'Nenhum problema de qualidade na última hora ✅';

  @override
  String get noQualityLogs => 'Nenhum registro de qualidade ainda.';

  @override
  String get noTranslatedMessages => 'Sem mensagens para traduzir';

  @override
  String get notEnoughHearts => 'Corações insuficientes';

  @override
  String notEnoughHeartsCount(int count) {
    return 'Corações insuficientes. (Atual: $count)';
  }

  @override
  String get notRegistered => 'não registrado';

  @override
  String get notSubscribed => 'Não inscrito';

  @override
  String get notificationPermissionDesc =>
      'A permissão de notificação é necessária para receber novas mensagens.';

  @override
  String get notificationPermissionRequired =>
      'Permissão de notificação necessária';

  @override
  String get notificationSettings => 'Configurações de notificação';

  @override
  String get notifications => 'Notificações';

  @override
  String get occurrenceInfo => 'Informações da Ocorrência:';

  @override
  String get olderChats => 'Mais antigos';

  @override
  String get onlyOppositeGenderNote =>
      'Se desmarcado, apenas personas do gênero oposto serão exibidas';

  @override
  String get openSettings => 'Abrir Configurações';

  @override
  String get optional => 'Opcional';

  @override
  String get or => 'or';

  @override
  String get originalPrice => 'Original';

  @override
  String get originalText => 'Original';

  @override
  String get other => 'Outro';

  @override
  String get otherError => 'Outro Erro';

  @override
  String get others => 'Outros';

  @override
  String get ownedHearts => 'Corações Possuídos';

  @override
  String get parentsDay => 'Dia dos Pais';

  @override
  String get password => 'Senha';

  @override
  String get passwordConfirmation => 'Digite a senha para confirmar';

  @override
  String get passwordConfirmationDesc =>
      'Por favor, reentre sua senha para deletar a conta.';

  @override
  String get passwordHint => '6 caracteres ou mais';

  @override
  String get passwordLabel => 'Senha';

  @override
  String get passwordRequired => 'Senha *';

  @override
  String get passwordResetEmailPrompt =>
      'Por favor, insira seu e-mail para redefinir a senha';

  @override
  String get passwordResetEmailSent =>
      'E-mail de redefinição de senha foi enviado. Por favor, verifique seu e-mail.';

  @override
  String get passwordText => 'senha';

  @override
  String get passwordTooShort => 'A senha deve ter pelo menos 6 caracteres';

  @override
  String get permissionDenied => 'Permissão negada';

  @override
  String permissionDeniedMessage(String permissionName) {
    return 'A permissão $permissionName foi negada.\\nPor favor, permita a permissão nas configurações.';
  }

  @override
  String get permissionDeniedTryLater =>
      'Permissão negada. Por favor, tente novamente mais tarde.';

  @override
  String get permissionRequired => 'Permissão necessária';

  @override
  String get personaGenderSection => 'Preferência de Gênero da Persona';

  @override
  String get personaQualityStats => 'Estatísticas de Qualidade da Persona';

  @override
  String get personalInfoExposure => 'Exposição de informações pessoais';

  @override
  String get personality => 'Configurações de Personalidade';

  @override
  String get pets => 'Animais de Estimação';

  @override
  String get photo => 'Photo';

  @override
  String get photography => 'Photography';

  @override
  String get picnic => 'Picnic';

  @override
  String get preferenceSettings => 'Configurações de Preferência';

  @override
  String get preferredLanguage => 'Idioma Preferido';

  @override
  String get preparingForSleep => 'Preparando-se para dormir';

  @override
  String get preparingNewMeeting => 'Preparando nova reunião';

  @override
  String get preparingPersonaImages => 'Preparando imagens de persona';

  @override
  String get preparingPersonas => 'Preparando personas';

  @override
  String get preview => 'Prévia';

  @override
  String get previous => 'Anterior';

  @override
  String get privacy => 'Privacidade';

  @override
  String get privacyPolicy => 'Política de privacidade';

  @override
  String get privacyPolicyAgreement => 'Aceite a política de privacidade';

  @override
  String get privacySection1Content =>
      'Estamos comprometidos em proteger sua privacidade. Esta Política de Privacidade explica como coletamos, usamos e protegemos suas informações quando você utiliza nosso serviço.';

  @override
  String get privacySection1Title =>
      '1. Propósito da Coleta e Uso de Informações Pessoais';

  @override
  String get privacySection2Content =>
      'Coletamos informações que você nos fornece diretamente, como quando você cria uma conta, atualiza seu perfil ou utiliza nossos serviços.';

  @override
  String get privacySection2Title => 'Informações que Coletamos';

  @override
  String get privacySection3Content =>
      'Usamos as informações que coletamos para fornecer, manter e melhorar nossos serviços, e para nos comunicarmos com você.';

  @override
  String get privacySection3Title =>
      '3. Período de Retenção e Uso de Informações Pessoais';

  @override
  String get privacySection4Content =>
      'Não vendemos, trocamos ou transferimos suas informações pessoais para terceiros sem o seu consentimento.';

  @override
  String get privacySection4Title =>
      '4. Fornecimento de Informações Pessoais a Terceiros';

  @override
  String get privacySection5Content =>
      'Implementamos medidas de segurança apropriadas para proteger suas informações pessoais contra acesso não autorizado, alteração, divulgação ou destruição.';

  @override
  String get privacySection5Title =>
      '5. Medidas de Proteção Técnica para Informações Pessoais';

  @override
  String get privacySection6Content =>
      'Retemos informações pessoais pelo tempo necessário para fornecer nossos serviços e cumprir obrigações legais.';

  @override
  String get privacySection6Title => '6. Direitos do Usuário';

  @override
  String get privacySection7Content =>
      'Você tem o direito de acessar, atualizar ou excluir suas informações pessoais a qualquer momento através das configurações da sua conta.';

  @override
  String get privacySection7Title => 'Seus Direitos';

  @override
  String get privacySection8Content =>
      'Se você tiver alguma dúvida sobre esta Política de Privacidade, entre em contato conosco pelo e-mail support@sona.com.';

  @override
  String get privacySection8Title => 'Fale Conosco';

  @override
  String get privacySettings => 'Configurações de Privacidade';

  @override
  String get privacySettingsInfo =>
      'Desativar recursos individuais tornará esses serviços indisponíveis';

  @override
  String get privacySettingsScreen => 'Configurações de Privacidade';

  @override
  String get problemMessage => 'Problema';

  @override
  String get problemOccurred => 'Ocorreu um Problema';

  @override
  String get profile => 'Perfil';

  @override
  String get profileEdit => 'Editar Perfil';

  @override
  String get profileEditLoginRequiredMessage =>
      'É necessário fazer login para editar seu perfil. Você gostaria de ir para a tela de login?';

  @override
  String get profileInfo => 'Informações do Perfil';

  @override
  String get profileInfoDescription =>
      'Por favor, insira sua foto de perfil e informações básicas';

  @override
  String get profileNav => 'Perfil';

  @override
  String get profilePhoto => 'Foto do Perfil';

  @override
  String get profilePhotoAndInfo =>
      'Por favor, insira a foto do perfil e informações básicas';

  @override
  String get profilePhotoUpdateFailed => 'Falha ao atualizar a foto do perfil';

  @override
  String get profilePhotoUpdated => 'Foto do perfil atualizada';

  @override
  String get profileSettings => 'Configurações do Perfil';

  @override
  String get profileSetup => 'Configurando o perfil';

  @override
  String get profileUpdateFailed => 'Falha ao atualizar o perfil';

  @override
  String get profileUpdated => 'Perfil atualizado com sucesso';

  @override
  String get purchaseAndRefundPolicy => 'Política de Compra e Reembolso';

  @override
  String get purchaseButton => 'Comprar';

  @override
  String get purchaseConfirm => 'Confirmação de Compra';

  @override
  String purchaseConfirmContent(String product, String price) {
    return 'Comprar $product por $price?';
  }

  @override
  String purchaseConfirmMessage(
      String title, String price, String description) {
    return 'Confirmar compra de $title por $price? $description';
  }

  @override
  String get purchaseFailed => 'Compra falhou';

  @override
  String get purchaseHeartsOnly => 'Comprar corações';

  @override
  String get purchaseMoreHearts =>
      'Compre corações para continuar as conversas';

  @override
  String get purchasePending => 'Compra pendente...';

  @override
  String get purchasePolicy => 'Política de Compra';

  @override
  String get purchaseSection1Content =>
      'Aceitamos vários métodos de pagamento, incluindo cartões de crédito e carteiras digitais.';

  @override
  String get purchaseSection1Title => 'Métodos de Pagamento';

  @override
  String get purchaseSection2Content =>
      'Reembolsos estão disponíveis dentro de 14 dias após a compra, se você não tiver utilizado os itens adquiridos.';

  @override
  String get purchaseSection2Title => 'Política de Reembolso';

  @override
  String get purchaseSection3Content =>
      'Você pode cancelar sua assinatura a qualquer momento através das configurações da sua conta.';

  @override
  String get purchaseSection3Title => 'Cancelamento';

  @override
  String get purchaseSection4Content =>
      'Ao fazer uma compra, você concorda com nossos termos de uso e contrato de serviço.';

  @override
  String get purchaseSection4Title => 'Termos de Uso';

  @override
  String get purchaseSection5Content =>
      'Para questões relacionadas a compras, entre em contato com nossa equipe de suporte.';

  @override
  String get purchaseSection5Title => 'Contatar Suporte';

  @override
  String get purchaseSection6Content =>
      'Todas as compras estão sujeitas aos nossos termos e condições padrão.';

  @override
  String get purchaseSection6Title => '6. Consultas';

  @override
  String get pushNotifications => 'Notificações push';

  @override
  String get reading => 'Lendo';

  @override
  String get realtimeQualityLog => 'Registro de Qualidade em Tempo Real';

  @override
  String get recentConversation => 'Conversa Recente:';

  @override
  String get recentLoginRequired =>
      'Por favor, faça login novamente por segurança';

  @override
  String get referrerEmail => 'E-mail do Referente';

  @override
  String get referrerEmailHelper => 'Opcional: E-mail de quem te referiu';

  @override
  String get referrerEmailLabel => 'E-mail do Referente (Opcional)';

  @override
  String get refresh => 'Atualizar';

  @override
  String refreshComplete(int count) {
    return 'Atualização completa! $count personas correspondentes';
  }

  @override
  String get refreshFailed => 'Falha ao atualizar';

  @override
  String get refreshingChatList => 'Atualizando lista de chats...';

  @override
  String get relatedFAQ => 'Perguntas Frequentes Relacionadas';

  @override
  String get report => 'Denunciar';

  @override
  String get reportAI => 'Denunciar';

  @override
  String get reportAIDescription =>
      'Se a IA te deixou desconfortável, por favor descreva o problema.';

  @override
  String get reportAITitle => 'Denunciar Conversa com a IA';

  @override
  String get reportAndBlock => 'Denunciar e Bloquear';

  @override
  String get reportAndBlockDescription =>
      'Você pode denunciar e bloquear comportamentos inadequados desta IA';

  @override
  String get reportChatError => 'Denunciar Erro de Chat';

  @override
  String reportError(String error) {
    return 'Ocorreu um erro ao denunciar: $error';
  }

  @override
  String get reportFailed => 'Falha ao denunciar';

  @override
  String get reportSubmitted =>
      'Denúncia enviada. Nós iremos revisar e tomar uma ação.';

  @override
  String get reportSubmittedSuccess => 'Sua denúncia foi enviada. Obrigado!';

  @override
  String get requestLimit => 'Limite de Solicitações';

  @override
  String get required => '[Obrigatório]';

  @override
  String get requiredTermsAgreement => 'Por favor, concorde com os termos';

  @override
  String get restartConversation => 'Reiniciar Conversa';

  @override
  String restartConversationQuestion(String name) {
    return 'Você gostaria de reiniciar a conversa com $name?';
  }

  @override
  String restartConversationWithName(String name) {
    return 'Reiniciando a conversa com $name!';
  }

  @override
  String get retry => 'Tentar novamente';

  @override
  String get retryButton => 'Tentar Novamente';

  @override
  String get sad => 'Triste';

  @override
  String get saturday => 'Sábado';

  @override
  String get save => 'Salvar';

  @override
  String get search => 'Buscar';

  @override
  String get searchFAQ => 'Pesquisar FAQ...';

  @override
  String get searchResults => 'Resultados da Pesquisa';

  @override
  String get selectEmotion => 'Selecione Emoção';

  @override
  String get selectErrorType => 'Selecione o tipo de erro';

  @override
  String get selectFeeling => 'Selecione Sentimento';

  @override
  String get selectGender => 'Por favor, selecione o gênero';

  @override
  String get selectInterests => 'Selecione seus interesses';

  @override
  String get selectLanguage => 'Selecionar Idioma';

  @override
  String get selectPersona => 'Selecionar uma persona';

  @override
  String get selectPersonaPlease => 'Por favor, selecione uma persona.';

  @override
  String get selectPreferredMbti =>
      'Se você prefere personas com tipos MBTI específicos, por favor selecione';

  @override
  String get selectProblematicMessage =>
      'Selecione a mensagem problemática (opcional)';

  @override
  String get chatErrorAnalysisInfo => 'Analisando as últimas 10 conversas.';

  @override
  String get whatWasAwkward => 'O que pareceu estranho?';

  @override
  String get errorExampleHint =>
      'Ex: Forma estranha de falar (terminações ~nya)...';

  @override
  String get selectReportReason => 'Selecione o motivo do relatório';

  @override
  String get selectTheme => 'Selecionar Tema';

  @override
  String get selectTranslationError =>
      'Por favor, selecione uma mensagem com erro de tradução';

  @override
  String get selectUsagePurpose =>
      'Por favor, selecione seu propósito para usar o SONA';

  @override
  String get selfIntroduction => 'Introdução (Opcional)';

  @override
  String get selfIntroductionHint => 'Escreva uma breve introdução sobre você';

  @override
  String get send => 'Enviar';

  @override
  String get sendChatError => 'Erro ao Enviar Chat';

  @override
  String get sendFirstMessage => 'Envie sua primeira mensagem';

  @override
  String get sendReport => 'Enviar Relatório';

  @override
  String get sendingEmail => 'Enviando e-mail...';

  @override
  String get seoul => 'Seul';

  @override
  String get serverErrorDashboard => 'Erro no Servidor';

  @override
  String get serviceTermsAgreement =>
      'Por favor, concorde com os termos de serviço';

  @override
  String get sessionExpired => 'Sessão expirada';

  @override
  String get setAppInterfaceLanguage => 'Definir idioma da interface do app';

  @override
  String get setNow => 'Definir Agora';

  @override
  String get settings => 'Configurações';

  @override
  String get sexualContent => 'Conteúdo sexual';

  @override
  String get showAllGenderPersonas => 'Mostrar personas de todos os gêneros';

  @override
  String get showAllGendersOption => 'Mostrar Todos os Gêneros';

  @override
  String get showOppositeGenderOnly =>
      'Se desmarcado, apenas personas do gênero oposto serão exibidas';

  @override
  String get showOriginalText => 'Mostrar Original';

  @override
  String get signUp => 'Cadastrar';

  @override
  String get signUpFromGuest =>
      'Cadastre-se agora para acessar todos os recursos!';

  @override
  String get signup => 'Cadastrar';

  @override
  String get signupComplete => 'Cadastro Completo';

  @override
  String get signupTab => 'Cadastro';

  @override
  String get simpleInfoRequired => 'Informações simples são necessárias';

  @override
  String get skip => 'Pular';

  @override
  String get sonaFriend => 'Amigo SONA';

  @override
  String get sonaPrivacyPolicy => 'Política de Privacidade da SONA';

  @override
  String get sonaPurchasePolicy => 'Política de Compras da SONA';

  @override
  String get sonaTermsOfService => 'Termos de Serviço da SONA';

  @override
  String get sonaUsagePurpose =>
      'Por favor, selecione seu propósito para usar a SONA';

  @override
  String get sorryNotHelpful => 'Desculpe, isso não foi útil';

  @override
  String get sort => 'Ordenar';

  @override
  String get soundSettings => 'Configurações de Som';

  @override
  String get spamAdvertising => 'Spam/Publicidade';

  @override
  String get spanish => 'Espanhol';

  @override
  String get specialRelationshipDesc =>
      'Entendam-se e construam laços profundos';

  @override
  String get sports => 'Esportes';

  @override
  String get spring => 'Primavera';

  @override
  String get startChat => 'Iniciar Chat';

  @override
  String get startChatButton => 'Iniciar Chat';

  @override
  String get startConversation => 'Iniciar uma conversa';

  @override
  String get startConversationLikeAFriend =>
      'Comece uma conversa com Sona como um amigo';

  @override
  String get startConversationStep =>
      '2. Iniciar Conversa: Converse livremente com as personas combinadas.';

  @override
  String get startConversationWithSona =>
      'Comece a conversar com Sona como um amigo!';

  @override
  String get startWithEmail => 'Comece com Email';

  @override
  String get startWithGoogle => 'Comece com Google';

  @override
  String get startingApp => 'Iniciando o aplicativo';

  @override
  String get storageManagement => 'Gerenciamento de Armazenamento';

  @override
  String get store => 'Loja';

  @override
  String get storeConnectionError => 'Não foi possível conectar à loja';

  @override
  String get storeLoginRequiredMessage =>
      'É necessário fazer login para usar a loja. Você gostaria de ir para a tela de login?';

  @override
  String get storeNotAvailable => 'Loja não está disponível';

  @override
  String get storyEvent => 'Evento da História';

  @override
  String get stressed => 'Estressado';

  @override
  String get submitReport => 'Enviar Relatório';

  @override
  String get subscriptionStatus => 'Status da Assinatura';

  @override
  String get subtleVibrationOnTouch => 'Vibração sutil ao tocar';

  @override
  String get summer => 'Verão';

  @override
  String get sunday => 'Domingo';

  @override
  String get swipeAnyDirection => 'Deslize em qualquer direção';

  @override
  String get swipeDownToClose => 'Deslize para baixo para fechar';

  @override
  String get systemTheme => 'Seguir o Sistema';

  @override
  String get systemThemeDesc =>
      'Muda automaticamente com base nas configurações do modo escuro do dispositivo';

  @override
  String get tapBottomForDetails => 'Toque na parte inferior para ver detalhes';

  @override
  String get tapForDetails => 'Toque na área inferior para detalhes';

  @override
  String get tapToSwipePhotos => 'Toque para deslizar fotos';

  @override
  String get teachersDay => 'Dia dos Professores';

  @override
  String get technicalError => 'Erro Técnico';

  @override
  String get technology => 'Tecnologia';

  @override
  String get terms => 'Termos de Serviço';

  @override
  String get termsAgreement => 'Acordo de Termos';

  @override
  String get termsAgreementDescription =>
      'Por favor, concorde com os termos para usar o serviço';

  @override
  String get termsOfService => 'Termos de serviço';

  @override
  String get termsSection10Content =>
      'Reservamos o direito de modificar estes termos a qualquer momento com aviso aos usuários.';

  @override
  String get termsSection10Title => 'Artigo 10 (Resolução de Disputas)';

  @override
  String get termsSection11Content =>
      'Estes termos serão regidos pelas leis da jurisdição em que operamos.';

  @override
  String get termsSection11Title =>
      'Artigo 11 (Disposições Especiais do Serviço de IA)';

  @override
  String get termsSection12Content =>
      'Se qualquer disposição destes termos for considerada inaplicável, as disposições restantes continuarão em pleno vigor e efeito.';

  @override
  String get termsSection12Title => 'Artigo 12 (Coleta e Uso de Dados)';

  @override
  String get termsSection1Content =>
      'Estes termos e condições têm como objetivo definir os direitos, obrigações e responsabilidades entre a SONA (doravante \"Empresa\") e os usuários em relação ao uso do serviço de correspondência de conversa com persona de IA (doravante \"Serviço\") fornecido pela Empresa.';

  @override
  String get termsSection1Title => 'Artigo 1 (Finalidade)';

  @override
  String get termsSection2Content =>
      'Ao usar nosso serviço, você concorda em estar vinculado a estes Termos de Serviço e à nossa Política de Privacidade.';

  @override
  String get termsSection2Title => 'Artigo 2 (Definições)';

  @override
  String get termsSection3Content =>
      'Você deve ter pelo menos 13 anos para usar nosso serviço.';

  @override
  String get termsSection3Title => 'Artigo 3 (Efeito e Modificação dos Termos)';

  @override
  String get termsSection4Content =>
      'Você é responsável por manter a confidencialidade da sua conta e senha.';

  @override
  String get termsSection4Title => 'Artigo 4 (Prestação do Serviço)';

  @override
  String get termsSection5Content =>
      'Você concorda em não usar nosso serviço para qualquer finalidade ilegal ou não autorizada.';

  @override
  String get termsSection5Title => 'Artigo 5 (Registro de Membro)';

  @override
  String get termsSection6Content =>
      'Reservamos o direito de encerrar ou suspender sua conta por violação destes termos.';

  @override
  String get termsSection6Title => 'Artigo 6 (Obrigações do Usuário)';

  @override
  String get termsSection7Content =>
      'A Empresa pode restringir gradualmente o uso do serviço por meio de avisos, suspensão temporária ou suspensão permanente se os usuários violarem as obrigações destes termos ou interferirem nas operações normais do serviço.';

  @override
  String get termsSection7Title => 'Artigo 7 (Restrições de Uso do Serviço)';

  @override
  String get termsSection8Content =>
      'Não somos responsáveis por quaisquer danos indiretos, incidentais ou consequenciais decorrentes do seu uso do nosso serviço.';

  @override
  String get termsSection8Title => 'Artigo 8 (Interrupção do Serviço)';

  @override
  String get termsSection9Content =>
      'Todo o conteúdo e materiais disponíveis em nosso serviço estão protegidos por direitos de propriedade intelectual.';

  @override
  String get termsSection9Title => 'Artigo 9 (Isenção de Responsabilidade)';

  @override
  String get termsSupplementary => 'Termos Suplementares';

  @override
  String get thai => 'Tailandês';

  @override
  String get thanksFeedback => 'Obrigado pelo seu feedback!';

  @override
  String get theme => 'Tema';

  @override
  String get themeDescription =>
      'Você pode personalizar a aparência do aplicativo como quiser';

  @override
  String get themeSettings => 'Configurações do Tema';

  @override
  String get thursday => 'Quinta-feira';

  @override
  String get timeout => 'Tempo esgotado';

  @override
  String get tired => 'Cansado';

  @override
  String get today => 'Hoje';

  @override
  String get todayChats => 'Hoje';

  @override
  String get todayText => 'Hoje';

  @override
  String get tomorrowText => 'Amanhã';

  @override
  String get totalConsultSessions => 'Total de Sessões de Consulta';

  @override
  String get totalErrorCount => 'Total de Erros';

  @override
  String get totalLikes => 'Total de Curtidas';

  @override
  String totalOccurrences(Object count) {
    return 'Total de $count ocorrências';
  }

  @override
  String get totalResponses => 'Total de Respostas';

  @override
  String get translatedFrom => 'Traduzido';

  @override
  String get translatedText => 'Tradução';

  @override
  String get translationError => 'Erro de tradução';

  @override
  String get translationErrorDescription =>
      'Por favor, reporte traduções incorretas ou expressões estranhas';

  @override
  String get translationErrorReported =>
      'Erro de tradução reportado. Obrigado!';

  @override
  String get translationNote => '※ A tradução por IA pode não ser perfeita';

  @override
  String get translationQuality => 'Qualidade da Tradução';

  @override
  String get translationSettings => 'Configurações de Tradução';

  @override
  String get travel => 'Viagem';

  @override
  String get tuesday => 'Terça-feira';

  @override
  String get tutorialAccount => 'Conta de Tutorial';

  @override
  String get tutorialWelcomeDescription =>
      'Crie relacionamentos especiais com personas de IA.';

  @override
  String get tutorialWelcomeTitle => 'Bem-vindo ao SONA!';

  @override
  String get typeMessage => 'Digite uma mensagem...';

  @override
  String get unblock => 'Desbloquear';

  @override
  String get unblockFailed => 'Falha ao desbloquear';

  @override
  String unblockPersonaConfirm(String name) {
    return 'Desbloquear $name?';
  }

  @override
  String get unblockedSuccessfully => 'Desbloqueado com sucesso';

  @override
  String get unexpectedLoginError =>
      'Ocorreu um erro inesperado durante o login';

  @override
  String get unknown => 'Desconhecido';

  @override
  String get unknownError => 'Ocorreu um erro desconhecido';

  @override
  String get unlimitedMessages => 'Mensagens ilimitadas';

  @override
  String get unsendMessage => 'Desfazer envio da mensagem';

  @override
  String get usagePurpose => 'Propósito de uso';

  @override
  String get useOneHeart => 'Usar 1 Coração';

  @override
  String get useSystemLanguage => 'Usar Idioma do Sistema';

  @override
  String get user => 'Usuário:';

  @override
  String get userMessage => 'Mensagem do Usuário:';

  @override
  String get userNotFound => 'Usuário não encontrado';

  @override
  String get valentinesDay => 'Dia dos Namorados';

  @override
  String get verifyingAuth => 'Verificando autenticação';

  @override
  String get version => 'Versão';

  @override
  String get vietnamese => 'Vietnamita';

  @override
  String get violentContent => 'Conteúdo violento';

  @override
  String get voiceMessage => '🎤 Mensagem de voz';

  @override
  String waitingForChat(String name) {
    return '$name está aguardando para conversar.';
  }

  @override
  String get walk => 'Caminhar';

  @override
  String get wasHelpful => 'Isso foi útil?';

  @override
  String get weatherClear => 'Limpo';

  @override
  String get weatherCloudy => 'Nublado';

  @override
  String get weatherContext => 'Contexto do Tempo';

  @override
  String get weatherContextDesc =>
      'Forneça contexto de conversa com base no clima';

  @override
  String get weatherDrizzle => 'Chuvisco';

  @override
  String get weatherFog => 'Névoa';

  @override
  String get weatherMist => 'Bruma';

  @override
  String get weatherRain => 'Chuva';

  @override
  String get weatherRainy => 'Chuvoso';

  @override
  String get weatherSnow => 'Neve';

  @override
  String get weatherSnowy => 'Nevado';

  @override
  String get weatherThunderstorm => 'Tempestade';

  @override
  String get wednesday => 'Quarta-feira';

  @override
  String get weekdays => 'Dom,Seg,Ter,Qua,Qui,Sex,Sáb';

  @override
  String get welcomeMessage => 'Bem-vindo💕';

  @override
  String get whatTopicsToTalk =>
      'Sobre quais tópicos você gostaria de conversar? (Opcional)';

  @override
  String get whiteDay => 'Dia Branco';

  @override
  String get winter => 'Inverno';

  @override
  String get wrongTranslation => 'Tradução Incorreta';

  @override
  String get year => 'Ano';

  @override
  String get yearEnd => 'Fim do Ano';

  @override
  String get yes => 'Sim';

  @override
  String get yesterday => 'Ontem';

  @override
  String get yesterdayChats => 'Ontem';

  @override
  String get you => 'Você';

  @override
  String get loadingPersonaData => 'Carregando dados de persona';

  @override
  String get checkingMatchedPersonas => 'Verificando personas correspondentes';

  @override
  String get preparingImages => 'Preparando imagens';

  @override
  String get finalPreparation => 'Preparação final';

  @override
  String get editProfileSubtitle =>
      'Editar gênero, data de nascimento e introdução';

  @override
  String get systemThemeName => 'Sistema';

  @override
  String get lightThemeName => 'Claro';

  @override
  String get darkThemeName => 'Escuro';

  @override
  String get alwaysShowTranslationOn => 'Always Show Translation';

  @override
  String get alwaysShowTranslationOff => 'Hide Auto Translation';

  @override
  String get translationErrorAnalysisInfo =>
      'Analisaremos a mensagem selecionada e sua tradução.';

  @override
  String get whatWasWrongWithTranslation =>
      'O que estava errado com a tradução?';

  @override
  String get translationErrorHint =>
      'Ex: Significado incorreto, expressão não natural, contexto errado...';

  @override
  String get pleaseSelectMessage =>
      'Por favor, selecione uma mensagem primeiro';

  @override
  String get myPersonas => 'Minhas Personas';

  @override
  String get createPersona => 'Criar Persona';

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
  String get mbtiTest => 'Teste MBTI';

  @override
  String get mbtiStepDescription =>
      'Let\'s determine what personality your persona should have. Answer questions to shape their character.';

  @override
  String get startTest => 'Start Test';

  @override
  String get personalitySettings => 'Personality Settings';

  @override
  String get speechStyle => 'Estilo de Fala';

  @override
  String get conversationStyle => 'Estilo de Conversa';

  @override
  String get shareWithCommunity => 'Share with Community';

  @override
  String get shareDescription =>
      'Your persona can be shared with other users after approval';

  @override
  String get sharePersona => 'Share Persona';

  @override
  String get willBeSharedAfterApproval =>
      'Será compartilhado após aprovação do administrador';

  @override
  String get privatePersonaDescription => 'Only you can see this persona';

  @override
  String get create => 'Create';

  @override
  String get personaCreated => 'Persona criada com sucesso';

  @override
  String get createFailed => 'Falha ao criar';

  @override
  String get pendingApproval => 'Aguardando Aprovação';

  @override
  String get approved => 'Aprovado';

  @override
  String get privatePersona => 'Private';

  @override
  String get noPersonasYet => 'No Personas Yet';

  @override
  String get createYourFirstPersona =>
      'Create your first persona and start your journey';

  @override
  String get deletePersona => 'Excluir Persona';

  @override
  String get deletePersonaConfirm =>
      'Tem certeza de que deseja excluir esta persona? Esta ação não pode ser desfeita.';

  @override
  String get personaDeleted => 'Persona excluída com sucesso';

  @override
  String get deleteFailed => 'Falha ao excluir';

  @override
  String get personaLimitReached => 'You have reached the limit of 3 personas';

  @override
  String get personaName => 'Nome da Persona';

  @override
  String get personaAge => 'Idade';

  @override
  String get personaDescription => 'Descrição';

  @override
  String get personaNameHint => 'Ex: Ana, João';

  @override
  String get personaDescriptionHint => 'Descreva sua persona brevemente';

  @override
  String get loginRequiredContent => 'Please log in to continue';

  @override
  String get reportErrorButton => 'Report Error';
}
