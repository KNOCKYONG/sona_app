// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get about => '앱 정보';

  @override
  String get accountAndProfile => '계정 & 프로필 정보';

  @override
  String get accountDeletedSuccess => '계정이 성공적으로 삭제되었습니다';

  @override
  String get accountDeletionContent => '정말로 계정을 삭제하시겠습니까?\n이 작업은 되돌릴 수 없습니다.';

  @override
  String get accountDeletionError => '계정 삭제 중 오류가 발생했습니다.';

  @override
  String get accountDeletionInfo => '계정 삭제 안내';

  @override
  String get accountDeletionTitle => '계정 삭제';

  @override
  String get accountDeletionWarning1 => '경고: 이 작업은 되돌릴 수 없습니다';

  @override
  String get accountDeletionWarning2 => '모든 데이터가 영구적으로 삭제됩니다';

  @override
  String get accountDeletionWarning3 => '모든 대화 기록에 접근할 수 없게 됩니다';

  @override
  String get accountDeletionWarning4 => '구매한 모든 콘텐츠가 포함됩니다';

  @override
  String get accountManagement => '계정 관리';

  @override
  String get adaptiveConversationDesc => '상대방의 말투와 스타일에 맞춰 대화합니다';

  @override
  String get afternoon => '오후';

  @override
  String get afternoonFatigue => '오후피로';

  @override
  String get ageConfirmation => '만 14세 이상이며, 위 내용을 확인했습니다.';

  @override
  String ageRange(int min, int max) {
    return '$min~$max세';
  }

  @override
  String get ageUnit => '세';

  @override
  String get agreeToTerms => '약관에 동의합니다';

  @override
  String get aiDatingQuestion => 'AI와 함께하는 특별한 일상\n당신만의 페르소나를 만나보세요.';

  @override
  String get aiPersonaPreferenceDescription => 'AI 페르소나 매칭을 위한 선호도를 설정해주세요';

  @override
  String get all => '전체';

  @override
  String get allAgree => '전체 동의';

  @override
  String get allFeaturesRequired => '※ 모든 기능은 서비스 제공을 위해 필요합니다';

  @override
  String get allPersonas => '모든 페르소나';

  @override
  String get allPersonasMatched => '모든 페르소나와 매칭되었습니다! 대화를 나눠보세요.';

  @override
  String get allowPermission => '계속';

  @override
  String alreadyChattingWith(String name) {
    return '$name님과는 이미 대화중이에요!';
  }

  @override
  String get alsoBlockThisAI => '이 AI도 차단하기';

  @override
  String get angry => '화나요';

  @override
  String get anonymousLogin => '익명 로그인 중';

  @override
  String get anxious => '불안해요';

  @override
  String get apiKeyError => 'API 키 오류';

  @override
  String get appName => 'SONA';

  @override
  String get appTagline => '당신의 AI 친구들';

  @override
  String get appleLoginCanceled => 'Apple 로그인이 취소되었습니다.\n다시 시도해주세요.';

  @override
  String get appleLoginError => 'Apple 로그인 중 오류가 발생했습니다.';

  @override
  String get art => '예술';

  @override
  String get authError => '인증 오류';

  @override
  String get autoTranslate => '자동 번역';

  @override
  String get autumn => '가을';

  @override
  String get averageQuality => '평균 품질';

  @override
  String get averageQualityScore => '평균 품질 점수';

  @override
  String get awkwardExpression => '어색한 표현';

  @override
  String get backButton => '뒤로가기';

  @override
  String get basicInfo => '기본 정보';

  @override
  String get basicInfoDescription => '계정 생성을 위한 기본 정보를 입력해주세요';

  @override
  String get birthDate => '생년월일';

  @override
  String get birthDateOptional => '생년월일 (선택)';

  @override
  String get birthDateRequired => '생년월일 *';

  @override
  String get blockConfirm => '이 AI를 차단하시겠습니까?\n차단된 AI는 매칭과 채팅 목록에서 제외됩니다.';

  @override
  String get blockReason => '차단 사유';

  @override
  String get blockThisAI => '이 AI 차단하기';

  @override
  String blockedAICount(int count) {
    return '차단된 AI $count개';
  }

  @override
  String get blockedAIs => '차단된 AI';

  @override
  String get blockedAt => '차단 날짜';

  @override
  String get blockedSuccessfully => '차단되었습니다';

  @override
  String get breakfast => '아침식사';

  @override
  String get byErrorType => '에러 타입별';

  @override
  String get byPersona => '페르소나별';

  @override
  String cacheDeleteError(String error) {
    return '캐시 삭제 중 오류가 발생했습니다: $error';
  }

  @override
  String get cacheDeleted => '이미지 캐시가 삭제되었습니다';

  @override
  String get cafeTerrace => '카페 테라스';

  @override
  String get calm => '평온해요';

  @override
  String get cameraPermission => '카메라 권한';

  @override
  String get cameraPermissionDesc => '프로필 사진 촬영을 위해 카메라 접근이 필요합니다.';

  @override
  String get canChangeInSettings => '나중에 설정에서 변경 가능합니다';

  @override
  String get canMeetPreviousPersonas => '이전에 스와이프한 페르소나들을\n다시 만날 수 있어요!';

  @override
  String get cancel => '취소';

  @override
  String get changeProfilePhoto => '프로필 사진 변경';

  @override
  String get chat => '채팅';

  @override
  String get chatEndedMessage => '대화가 종료되었습니다';

  @override
  String get chatErrorDashboard => '대화 오류 대시보드';

  @override
  String get chatErrorSentSuccessfully => '대화 오류가 성공적으로 전송되었습니다.';

  @override
  String get chatListTab => '채팅 목록 탭';

  @override
  String get chats => '채팅';

  @override
  String chattingWithPersonas(int count) {
    return '$count명의 소나와 대화중';
  }

  @override
  String get checkInternetConnection => '인터넷 연결을 확인해주세요';

  @override
  String get checkingUserInfo => '사용자 정보 확인 중';

  @override
  String get childrensDay => '어린이날';

  @override
  String get chinese => '중국어';

  @override
  String get chooseOption => '선택하세요:';

  @override
  String get christmas => '크리스마스';

  @override
  String get close => '닫기';

  @override
  String get complete => '완료';

  @override
  String get completeSignup => '가입 완료';

  @override
  String get confirm => '확인';

  @override
  String get connectingToServer => '서버 연결 중';

  @override
  String get consultQualityMonitoring => '상담 품질 모니터링';

  @override
  String get continueAsGuest => '게스트로 계속하기';

  @override
  String get continueButton => '계속';

  @override
  String get continueWithApple => 'Apple로 계속하기';

  @override
  String get continueWithGoogle => 'Google로 계속하기';

  @override
  String get conversationContinuity => '대화 연속성';

  @override
  String get conversationContinuityDesc => '이전 대화 기억 및 주제 연결';

  @override
  String conversationWith(String name) {
    return '$name';
  }

  @override
  String get convertToMember => '회원가입 하기';

  @override
  String get cooking => '요리';

  @override
  String get copyMessage => '메시지 복사';

  @override
  String get copyrightInfringement => '저작권 침해';

  @override
  String get creatingAccount => '계정 생성 중';

  @override
  String get crisisDetected => '위기 상황 감지';

  @override
  String get culturalIssue => '문화적 오류';

  @override
  String get current => '현재';

  @override
  String get currentCacheSize => '현재 캐시 크기';

  @override
  String get currentLanguage => '현재 언어';

  @override
  String get cycling => '자전거';

  @override
  String get dailyCare => '일상 케어';

  @override
  String get dailyCareDesc => '식사, 수면, 건강 등 일상 챙김 메시지';

  @override
  String get dailyChat => '일상 대화';

  @override
  String get dailyCheck => '일상체크';

  @override
  String get dailyConversation => '일상 대화';

  @override
  String get dailyLimitDescription => '일일 메시지 한도에 도달했습니다';

  @override
  String get dailyLimitTitle => '일일 한도 도달';

  @override
  String get darkMode => '다크 모드';

  @override
  String get darkTheme => '다크 모드';

  @override
  String get darkThemeDesc => '어두운 테마를 사용합니다';

  @override
  String get dataCollection => '데이터 수집 설정';

  @override
  String get datingAdvice => '연애 상담';

  @override
  String get datingDescription => '깊은 고민과 진솔한 대화를 나누고 싶어요';

  @override
  String get dawn => '새벽';

  @override
  String get day => '일';

  @override
  String get dayAfterTomorrow => '모레';

  @override
  String daysAgo(int count, String formatted) {
    return '$count일 전';
  }

  @override
  String daysRemaining(int days) {
    return '$days일 남음';
  }

  @override
  String get deepTalk => '깊은 대화';

  @override
  String get delete => '삭제';

  @override
  String get deleteAccount => '계정 삭제';

  @override
  String get deleteAccountConfirm => '정말로 계정을 삭제하시겠습니까? 이 작업은 되돌릴 수 없습니다.';

  @override
  String get deleteAccountWarning => '정말로 계정을 삭제하시겠습니까?';

  @override
  String get deleteCache => '캐시 삭제';

  @override
  String get deletingAccount => '계정 삭제 중...';

  @override
  String get depressed => '우울해요';

  @override
  String get describeError => '어떤 문제가 있나요?';

  @override
  String get detailedReason => '상세 사유';

  @override
  String get developRelationshipStep =>
      '3. 관계 발전: 대화를 통해 친밀도를 쌓고 특별한 관계로 발전시켜보세요.';

  @override
  String get dinner => '저녁식사';

  @override
  String get discardGuestData => '새로 시작';

  @override
  String get discount20 => '20% 할인';

  @override
  String get discount30 => '30% 할인';

  @override
  String get discountAmount => '할인';

  @override
  String discountAmountValue(String amount) {
    return '₩$amount 할인';
  }

  @override
  String get done => '완료';

  @override
  String get downloadingPersonaImages => '새로운 페르소나 이미지를 다운로드하고 있어요';

  @override
  String get edit => '수정';

  @override
  String get editInfo => '정보 수정';

  @override
  String get editProfile => '프로필 편집';

  @override
  String get effectSound => '효과음';

  @override
  String get effectSoundDescription => '효과음 재생';

  @override
  String get email => '이메일';

  @override
  String get emailHint => 'example@email.com';

  @override
  String get emailLabel => '이메일';

  @override
  String get emailRequired => '이메일 *';

  @override
  String get emotionAnalysis => '감정 분석';

  @override
  String get emotionAnalysisDesc => '대화 중 감정을 분석하여 공감 응답 제공';

  @override
  String get emotionAngry => '화남';

  @override
  String get emotionBasedEncounters => '감정 기반 만남';

  @override
  String get emotionCool => '쿨함';

  @override
  String get emotionHappy => '행복';

  @override
  String get emotionLove => '사랑';

  @override
  String get emotionSad => '슬픔';

  @override
  String get emotionThinking => '생각';

  @override
  String get emotionalSupportDesc => '고민을 나누고 따뜻한 위로를 받아요';

  @override
  String get endChat => '대화 종료';

  @override
  String get endTutorial => '튜토리얼 종료';

  @override
  String get endTutorialAndLogin =>
      '튜토리얼을 종료하고 로그인하시겠습니까?\n로그인하면 데이터가 저장되고 모든 기능을 사용할 수 있습니다.';

  @override
  String get endTutorialMessage =>
      '튜토리얼을 종료하고 로그인하시겠습니까?\n로그인하면 데이터가 저장되고 모든 기능을 사용할 수 있습니다.';

  @override
  String get english => '영어';

  @override
  String get enterBasicInfo => '계정 생성을 위한 기본 정보를 입력해줘';

  @override
  String get enterBasicInformation => '기본 정보를 입력해주세요';

  @override
  String get enterEmail => '이메일을 입력해주세요';

  @override
  String get enterNickname => '닉네임을 입력해주세요';

  @override
  String get enterPassword => '비밀번호를 입력해주세요';

  @override
  String get entertainmentAndFunDesc => '즐거운 게임과 유쾌한 대화를 즐겨요';

  @override
  String get entertainmentDescription => '재미있는 대화와 즐거운 시간을 보내고 싶어요';

  @override
  String get entertainmentFun => '오락/재미';

  @override
  String get error => '오류';

  @override
  String get errorDescription => '오류 설명';

  @override
  String get errorDescriptionHint =>
      '예: 이상한 대답을 했어요, 반복적으로 같은 말만 해요, 맥락에 맞지 않는 대답을 해요...';

  @override
  String get errorDetails => '오류 상세 내용';

  @override
  String get errorDetailsHint => '어떤 부분이 잘못되었는지 자세히 설명해주세요';

  @override
  String get errorFrequency24h => '에러 발생 빈도 (최근 24시간)';

  @override
  String get errorMessage => '에러 메시지:';

  @override
  String get errorOccurred => '오류가 발생했습니다.';

  @override
  String get errorOccurredTryAgain => '오류가 발생했습니다. 다시 시도해주세요.';

  @override
  String get errorSendingFailed => '오류 전송 실패';

  @override
  String get errorStats => '에러 통계';

  @override
  String errorWithMessage(String error) {
    return '오류가 발생했습니다: $error';
  }

  @override
  String get evening => '저녁';

  @override
  String get excited => '신나요';

  @override
  String get exit => '종료';

  @override
  String get exitApp => '앱 종료';

  @override
  String get exitConfirmMessage => '정말 앱을 종료하시겠습니까?';

  @override
  String get expertPersona => '전문가 페르소나';

  @override
  String get expertiseScore => '전문성 점수';

  @override
  String get expired => '만료됨';

  @override
  String get explainReportReason => '신고 사유를 자세히 설명해주세요';

  @override
  String get fashion => '패션';

  @override
  String get female => '여성';

  @override
  String get filter => '필터';

  @override
  String get firstOccurred => '첫 발생: ';

  @override
  String get followDeviceLanguage => '기기의 언어 설정을 따릅니다';

  @override
  String get forenoon => '오전';

  @override
  String get forgotPassword => '비밀번호 찾기';

  @override
  String get frequentlyAskedQuestions => '자주 묻는 질문';

  @override
  String get friday => '금요일';

  @override
  String get friendshipDescription => '새로운 친구를 만나고 대화를 나누고 싶어요';

  @override
  String get funChat => '재미있는 대화';

  @override
  String get galleryPermission => '갤러리 권한';

  @override
  String get galleryPermissionDesc => '프로필 사진 선택을 위해 갤러리 접근이 필요합니다.';

  @override
  String get gaming => '게임';

  @override
  String get gender => '성별';

  @override
  String get genderNotSelectedInfo => '성별을 선택하지 않으면 모든 성별의 페르소나가 표시됩니다';

  @override
  String get genderOptional => '성별 (선택)';

  @override
  String get genderPreferenceActive => '모든 성별의 페르소나를 만날 수 있어요';

  @override
  String get genderPreferenceDisabled => '성별을 선택하면 이성만 보기 옵션이 활성화됩니다';

  @override
  String get genderPreferenceInactive => '이성 페르소나만 보여집니다';

  @override
  String get genderRequired => '성별 *';

  @override
  String get genderSelectionInfo => '선택하지 않으면 모든 성별의 페르소나를 만날 수 있어요';

  @override
  String get generalPersona => '일반 페르소나';

  @override
  String get goToSettings => '설정으로 이동';

  @override
  String get googleLoginCanceled => '구글 로그인이 취소되었습니다.\n다시 시도해주세요.';

  @override
  String get googleLoginError => 'Google 로그인 중 오류가 발생했습니다.';

  @override
  String get grantPermission => '계속';

  @override
  String get guest => '게스트';

  @override
  String get guestDataMigration => '회원가입 시 현재 대화 기록을 보존하시겠습니까?';

  @override
  String get guestLimitReached => '게스트 체험이 끝났습니다.\n회원가입하고 무제한으로 대화하세요!';

  @override
  String get guestLoginPromptMessage => '대화를 계속하려면 로그인하세요';

  @override
  String get guestMessageExhausted => '무료 메시지를 모두 사용했어요';

  @override
  String guestMessageRemaining(int count) {
    return '게스트 메시지 $count회 남음';
  }

  @override
  String get guestModeBanner => '게스트 모드';

  @override
  String get guestModeDescription =>
      '회원가입 없이 SONA를 체험해보세요\n• 20회 메시지 제한\n• 하트 1개 제공\n• 모든 페르소나 조회 가능';

  @override
  String get guestModeFailedMessage => '게스트 모드 시작에 실패했습니다';

  @override
  String get guestModeLimitation => '게스트 모드에서는 일부 기능이 제한됩니다';

  @override
  String get guestModeTitle => '게스트로 체험하기';

  @override
  String get guestModeWarning => '게스트 모드는 24시간 동안 유지되며,\n이후 데이터가 삭제됩니다.';

  @override
  String get guestModeWelcome => '게스트 모드로 시작합니다';

  @override
  String get happy => '행복해요';

  @override
  String get hapticFeedback => '햅틱 피드백';

  @override
  String get harassmentBullying => '괴롭힘/따돌림';

  @override
  String get hateSpeech => '혐오 발언';

  @override
  String get heartDescription => '더 많은 메시지를 위한 하트';

  @override
  String get heartInsufficient => '하트가 부족합니다';

  @override
  String get heartInsufficientPleaseCharge => '하트가 부족합니다. 하트를 충전해주세요.';

  @override
  String get heartRequired => '하트 1개가 필요합니다';

  @override
  String get heartUsageFailed => '하트 사용에 실패했습니다.';

  @override
  String get hearts => '하트';

  @override
  String get hearts10 => '하트 10개';

  @override
  String get hearts30 => '하트 30개';

  @override
  String get hearts30Discount => '할인';

  @override
  String get hearts50 => '하트 50개';

  @override
  String get hearts50Discount => '할인';

  @override
  String get helloEmoji => '안녕하세요! 😊';

  @override
  String get help => '도움말';

  @override
  String get hideOriginalText => '원문 숨기기';

  @override
  String get hobbySharing => '취미 공유';

  @override
  String get hobbyTalk => '취미 이야기';

  @override
  String get hours24Ago => '24시간 전';

  @override
  String hoursAgo(int count, String formatted) {
    return '$count시간 전';
  }

  @override
  String get howToUse => 'SONA 사용 방법';

  @override
  String get imageCacheManagement => '이미지 캐시 관리';

  @override
  String get inappropriateContent => '부적절한 콘텐츠';

  @override
  String get incorrect => '올바르지 않습니다';

  @override
  String get incorrectPassword => '잘못된 비밀번호';

  @override
  String get indonesian => '인도네시아어';

  @override
  String get inquiries => '문의사항';

  @override
  String get insufficientHearts => '하트가 부족합니다.';

  @override
  String get interestSharing => '관심사 공유';

  @override
  String get interestSharingDesc => '공통 관심사 발견 및 추천';

  @override
  String get interests => '관심사';

  @override
  String get invalidEmailFormat => '잘못된 이메일 형식';

  @override
  String get invalidEmailFormatError => '올바른 이메일 주소를 입력해주세요';

  @override
  String isTyping(String name) {
    return '$name님이 입력 중...';
  }

  @override
  String get japanese => '일본어';

  @override
  String get joinDate => '가입일';

  @override
  String get justNow => '방금 전';

  @override
  String get keepGuestData => '대화 기록 유지';

  @override
  String get korean => '한국어';

  @override
  String get koreanLanguage => '한국어';

  @override
  String get language => '언어';

  @override
  String get languageDescription => 'AI가 선택한 언어로 응답합니다';

  @override
  String get languageIndicator => '언어';

  @override
  String get languageSettings => '언어 설정';

  @override
  String get lastOccurred => '마지막 발생: ';

  @override
  String get lastUpdated => '마지막 업데이트';

  @override
  String get lateNight => '늦은시간';

  @override
  String get later => '나중에';

  @override
  String get laterButton => '나중에';

  @override
  String get leave => '나가기';

  @override
  String get leaveChatConfirm => '이 채팅방을 나가시겠습니까?\n채팅 목록에서 사라집니다.';

  @override
  String get leaveChatRoom => '채팅방 나가기';

  @override
  String get leaveChatTitle => '채팅방 나가기';

  @override
  String get lifeAdvice => '인생 조언';

  @override
  String get lightTalk => '가벼운 수다';

  @override
  String get lightTheme => '라이트 모드';

  @override
  String get lightThemeDesc => '밝은 테마를 사용합니다';

  @override
  String get loading => '로딩 중...';

  @override
  String get loadingData => '데이터를 로딩 중입니다...';

  @override
  String get loadingProducts => '상품 불러오는 중...';

  @override
  String get loadingProfile => '프로필 불러오는 중';

  @override
  String get login => '로그인';

  @override
  String get loginButton => '로그인';

  @override
  String get loginCancelled => '로그인이 취소되었습니다';

  @override
  String get loginComplete => '로그인 완료';

  @override
  String get loginError => '로그인에 실패했습니다';

  @override
  String get loginFailed => '로그인 실패';

  @override
  String get loginFailedTryAgain => '로그인 실패. 다시 시도해주세요.';

  @override
  String get loginRequired => '로그인이 필요합니다';

  @override
  String get loginRequiredForProfile => '프로필을 보고 소나와의 기록을 확인하려면\n로그인이 필요해요';

  @override
  String get loginRequiredService => '이 서비스를 이용하려면 로그인이 필요합니다';

  @override
  String get loginRequiredTitle => '로그인이 필요합니다';

  @override
  String get loginSignup => '로그인/회원가입';

  @override
  String get loginTab => '로그인';

  @override
  String get loginTitle => '로그인';

  @override
  String get loginWithApple => 'Apple로 로그인';

  @override
  String get loginWithGoogle => 'Google로 로그인';

  @override
  String get logout => '로그아웃';

  @override
  String get logoutConfirm => '정말로 로그아웃하시겠습니까?';

  @override
  String get lonelinessRelief => '외로움 해소';

  @override
  String get lonely => '외로워요';

  @override
  String get lowQualityResponses => '낮은 품질 응답';

  @override
  String get lunch => '점심식사';

  @override
  String get lunchtime => '점심시간';

  @override
  String get mainErrorType => '주요 에러 타입';

  @override
  String get makeFriends => '친구 만들기';

  @override
  String get male => '남성';

  @override
  String get manageBlockedAIs => '차단된 AI 관리';

  @override
  String get managePersonaImageCache => '페르소나 이미지 캐시를 관리합니다';

  @override
  String get marketingAgree => '마케팅 정보 수신 동의 (선택)';

  @override
  String get marketingDescription => '이벤트 및 혜택 정보를 받아보실 수 있습니다';

  @override
  String get matchPersonaStep =>
      '1. 페르소나 매칭: 좌우로 스와이프하여 마음에 드는 AI 페르소나를 선택하세요.';

  @override
  String get matchedPersonas => '매칭된 소나';

  @override
  String get matchedSona => '매칭된 소나';

  @override
  String get matching => '매칭';

  @override
  String get matchingFailed => '매칭에 실패했습니다.';

  @override
  String get me => '나';

  @override
  String get meetAIPersonas => 'AI 페르소나를 만나보세요';

  @override
  String get meetNewPersonas => '새로운 페르소나 만나기';

  @override
  String get meetPersonas => '페르소나 만나기';

  @override
  String get memberBenefits => '회원가입 시 100개 이상의 메시지와 하트 10개 지급!';

  @override
  String get memoryAlbum => '추억 앨범';

  @override
  String get memoryAlbumDesc => '특별한 순간을 자동으로 저장하고 회상';

  @override
  String get messageCopied => '메시지가 복사되었습니다';

  @override
  String get messageDeleted => '메시지가 삭제되었습니다';

  @override
  String get messageLimitReset => '메시지 한도는 자정에 초기화됩니다';

  @override
  String get messageSendFailed => '메시지 전송에 실패했습니다. 다시 시도해주세요.';

  @override
  String get messagesRemaining => '메시지 잔량';

  @override
  String minutesAgo(int count, String formatted) {
    return '$count분 전';
  }

  @override
  String get missingTranslation => '번역 누락';

  @override
  String get monday => '월요일';

  @override
  String get month => '월';

  @override
  String monthDay(String month, int day) {
    return '$month월 $day일';
  }

  @override
  String get moreButton => '더보기';

  @override
  String get morning => '아침';

  @override
  String get mostFrequentError => '가장 많은 에러';

  @override
  String get movies => '영화';

  @override
  String get multilingualChat => '다국어 채팅';

  @override
  String get music => '음악';

  @override
  String get myGenderSection => '내 성별 (선택)';

  @override
  String get networkErrorOccurred => '네트워크 오류가 발생했습니다.';

  @override
  String get newMessage => '새 메시지';

  @override
  String newMessageCount(int count) {
    return '새 메시지 $count개';
  }

  @override
  String get newMessageNotification => '새 메시지 알림';

  @override
  String get newMessages => '새 메시지';

  @override
  String get newYear => '새해';

  @override
  String get next => '다음';

  @override
  String get niceToMeetYou => '반가워요!';

  @override
  String get nickname => '닉네임';

  @override
  String get nicknameAlreadyUsed => '이미 사용 중인 닉네임입니다';

  @override
  String get nicknameHelperText => '3-10자';

  @override
  String get nicknameHint => '3-10자';

  @override
  String get nicknameInUse => '이미 사용 중인 닉네임입니다';

  @override
  String get nicknameLabel => '닉네임';

  @override
  String get nicknameLengthError => '닉네임은 3-10자여야 합니다';

  @override
  String get nicknamePlaceholder => '닉네임을 입력하세요';

  @override
  String get nicknameRequired => '닉네임 *';

  @override
  String get night => '밤';

  @override
  String get no => '아니오';

  @override
  String get noBlockedAIs => '차단된 AI가 없습니다';

  @override
  String get noChatsYet => '아직 대화가 없습니다';

  @override
  String get noConversationYet => '아직 대화가 없습니다';

  @override
  String get noErrorReports => '에러 리포트가 없습니다.';

  @override
  String get noImageAvailable => '이미지가 없습니다';

  @override
  String get noMatchedPersonas => '아직 매칭된 페르소나가 없습니다';

  @override
  String get noMatchedSonas => '아직 매칭된 소나가 없어요';

  @override
  String get noPersonasAvailable => '사용 가능한 페르소나가 없습니다. 다시 시도해주세요.';

  @override
  String get noPersonasToSelect => '선택할 소나가 없습니다';

  @override
  String get noQualityIssues => '최근 1시간 동안 품질 문제가 없습니다 ✅';

  @override
  String get noQualityLogs => '아직 품질 로그가 없습니다.';

  @override
  String get noTranslatedMessages => '번역할 메시지가 없습니다';

  @override
  String get notEnoughHearts => '하트가 부족합니다';

  @override
  String notEnoughHeartsCount(int count) {
    return '하트가 부족합니다. (현재: $count개)';
  }

  @override
  String get notRegistered => '등록되지 않은';

  @override
  String get notSubscribed => '미가입';

  @override
  String get notificationPermissionDesc => '새로운 메시지를 받으려면 알림 권한이 필요합니다.';

  @override
  String get notificationPermissionRequired => '알림 권한이 필요합니다';

  @override
  String get notificationSettings => '알림 설정';

  @override
  String get notifications => '알림';

  @override
  String get occurrenceInfo => '발생 정보:';

  @override
  String get olderChats => '이전';

  @override
  String get onlyOppositeGenderNote => '체크하지 않으면 이성 페르소나만 표시됩니다';

  @override
  String get openSettings => '설정 열기';

  @override
  String get optional => '선택';

  @override
  String get or => '또는';

  @override
  String get originalPrice => '원가';

  @override
  String get originalText => '원문';

  @override
  String get other => '기타';

  @override
  String get otherError => '기타 오류';

  @override
  String get others => '기타';

  @override
  String get ownedHearts => '보유 하트';

  @override
  String get parentsDay => '어버이날';

  @override
  String get password => '비밀번호';

  @override
  String get passwordConfirmation => '확인을 위해 비밀번호를 입력하세요';

  @override
  String get passwordConfirmationDesc => '계정 삭제를 위해 비밀번호를 다시 입력해주세요.';

  @override
  String get passwordHint => '6자 이상';

  @override
  String get passwordLabel => '비밀번호';

  @override
  String get passwordRequired => '비밀번호 *';

  @override
  String get passwordResetEmailPrompt => '비밀번호를 재설정할 이메일을 입력해주세요';

  @override
  String get passwordResetEmailSent => '비밀번호 재설정 이메일을 발송했습니다. 이메일을 확인해주세요.';

  @override
  String get passwordText => '비밀번호';

  @override
  String get passwordTooShort => '비밀번호는 6자 이상이어야 합니다';

  @override
  String get permissionDenied => '권한이 거부되었습니다';

  @override
  String permissionDeniedMessage(String permissionName) {
    return '$permissionName 권한이 거부되었습니다.\\n설정에서 권한을 허용해주세요.';
  }

  @override
  String get permissionDeniedTryLater => '권한이 없습니다. 나중에 다시 시도해 주세요.';

  @override
  String get permissionRequired => '권한 필요';

  @override
  String get personaGenderSection => '만나고 싶은 페르소나 성별';

  @override
  String get personaQualityStats => '페르소나별 품질 통계';

  @override
  String get personalInfoExposure => '개인정보 노출';

  @override
  String get personality => '성격';

  @override
  String get pets => '반려동물';

  @override
  String get photo => '사진';

  @override
  String get photography => '사진';

  @override
  String get picnic => '피크닉';

  @override
  String get preferenceSettings => '선호 설정';

  @override
  String get preferredLanguage => '선호 언어';

  @override
  String get preparingForSleep => '수면준비';

  @override
  String get preparingNewMeeting => '새로운 만남 준비 중';

  @override
  String get preparingPersonaImages => '페르소나 이미지를 준비하고 있어요';

  @override
  String get preparingPersonas => '페르소나를 준비하고 있어요';

  @override
  String get preview => '미리보기';

  @override
  String get previous => '이전';

  @override
  String get privacy => '개인정보 처리방침';

  @override
  String get privacyPolicy => '개인정보 처리방침';

  @override
  String get privacyPolicyAgreement => '개인정보 처리방침에 동의해주세요';

  @override
  String get privacySection1Content =>
      '저희는 귀하의 개인정보를 보호하기 위해 최선을 다하고 있습니다. 본 개인정보 처리방침은 귀하가 서비스를 이용할 때 저희가 정보를 수집, 사용, 보호하는 방법을 설명합니다.';

  @override
  String get privacySection1Title => '1. 개인정보 수집 및 이용 목적';

  @override
  String get privacySection2Content =>
      '저희는 귀하가 계정을 생성하거나, 프로필을 업데이트하거나, 서비스를 이용할 때 직접 제공하는 정보를 수집합니다.';

  @override
  String get privacySection2Title => '수집하는 정보';

  @override
  String get privacySection3Content =>
      '저희는 서비스를 제공, 유지, 개선하고 귀하와 소통하기 위해 수집한 정보를 사용합니다.';

  @override
  String get privacySection3Title => '3. 개인정보 보관 및 이용 기간';

  @override
  String get privacySection4Content =>
      '저희는 귀하의 동의 없이 개인정보를 제3자에게 판매, 거래 또는 전송하지 않습니다.';

  @override
  String get privacySection4Title => '4. 개인정보 제3자 제공';

  @override
  String get privacySection5Content =>
      '저희는 무단 액세스, 변경, 공개 또는 파괴로부터 귀하의 개인정보를 보호하기 위해 적절한 보안 조치를 구현합니다.';

  @override
  String get privacySection5Title => '5. 개인정보 보호를 위한 기술적 보호조치';

  @override
  String get privacySection6Content =>
      '저희는 서비스 제공 및 법적 의무 준수에 필요한 기간 동안 개인정보를 보관합니다.';

  @override
  String get privacySection6Title => '6. 이용자의 권리';

  @override
  String get privacySection7Content =>
      '귀하는 언제든지 계정 설정을 통해 개인정보에 접근, 업데이트 또는 삭제할 권리가 있습니다.';

  @override
  String get privacySection7Title => '귀하의 권리';

  @override
  String get privacySection8Content =>
      '본 개인정보 처리방침에 대한 질문이 있으시면 support@sona.com으로 문의해주세요.';

  @override
  String get privacySection8Title => '문의하기';

  @override
  String get privacySettings => '프라이버시 설정';

  @override
  String get privacySettingsInfo => '각 기능을 개별적으로 끄면 해당 서비스를 이용할 수 없습니다';

  @override
  String get privacySettingsScreen => '개인정보 보호 설정';

  @override
  String get problemMessage => '문제';

  @override
  String get problemOccurred => '문제 발생';

  @override
  String get profile => '프로필';

  @override
  String get profileEdit => '프로필 편집';

  @override
  String get profileEditLoginRequiredMessage =>
      '프로필 편집을 위해 로그인이 필요합니다.\n로그인 화면으로 이동하시겠습니까?';

  @override
  String get profileInfo => '프로필 정보';

  @override
  String get profileInfoDescription => '프로필 사진과 기본 정보를 입력해주세요';

  @override
  String get profileNav => '프로필';

  @override
  String get profilePhoto => '프로필 사진';

  @override
  String get profilePhotoAndInfo => '프로필 사진과 기본 정보를 입력해주세요';

  @override
  String get profilePhotoUpdateFailed => '프로필 사진 업데이트 실패';

  @override
  String get profilePhotoUpdated => '프로필 사진이 업데이트되었습니다';

  @override
  String get profileSettings => '프로필 설정';

  @override
  String get profileSetup => '프로필 설정 중';

  @override
  String get profileUpdateFailed => '프로필 업데이트 실패';

  @override
  String get profileUpdated => '프로필이 성공적으로 업데이트되었습니다';

  @override
  String get purchaseAndRefundPolicy => '구매 및 환불 정책';

  @override
  String get purchaseButton => '구매하기';

  @override
  String get purchaseConfirm => '구매 확인';

  @override
  String purchaseConfirmContent(String product, String price) {
    return '$product을(를) $price에 구매하시겠습니까?';
  }

  @override
  String purchaseConfirmMessage(
      String title, String price, String description) {
    return '$title을(를) $price에 구매하시겠습니까? $description';
  }

  @override
  String get purchaseFailed => '구매 실패';

  @override
  String get purchaseHeartsOnly => '하트 구매';

  @override
  String get purchaseMoreHearts => '하트를 구매하여 대화를 계속하세요';

  @override
  String get purchasePending => '구매 처리 중...';

  @override
  String get purchasePolicy => '구매 정책';

  @override
  String get purchaseSection1Content => '신용카드 및 디지털 지갑을 포함한 다양한 결제 수단을 지원합니다.';

  @override
  String get purchaseSection1Title => '결제 수단';

  @override
  String get purchaseSection2Content =>
      '구매한 아이템을 사용하지 않은 경우 구매일로부터 14일 이내에 환불이 가능합니다.';

  @override
  String get purchaseSection2Title => '환불 정책';

  @override
  String get purchaseSection3Content => '계정 설정을 통해 언제든지 구독을 취소할 수 있습니다.';

  @override
  String get purchaseSection3Title => '취소';

  @override
  String get purchaseSection4Content => '구매 시 이용약관 및 서비스 계약에 동의하는 것으로 간주됩니다.';

  @override
  String get purchaseSection4Title => '이용약관';

  @override
  String get purchaseSection5Content => '구매 관련 문제는 고객 지원팀에 문의해주세요.';

  @override
  String get purchaseSection5Title => '고객 지원';

  @override
  String get purchaseSection6Content => '모든 구매는 표준 약관이 적용됩니다.';

  @override
  String get purchaseSection6Title => '6. 문의사항';

  @override
  String get pushNotifications => '푸시 알림';

  @override
  String get reading => '독서';

  @override
  String get realtimeQualityLog => '실시간 품질 로그';

  @override
  String get recentConversation => '최근 대화:';

  @override
  String get recentLoginRequired => '보안을 위해 다시 로그인해주세요';

  @override
  String get referrerEmail => '추천인 이메일';

  @override
  String get referrerEmailHelper => '선택사항: 추천해준 사람의 이메일';

  @override
  String get referrerEmailLabel => '추천인 이메일 (선택)';

  @override
  String get refresh => '새로고침';

  @override
  String refreshComplete(int count) {
    return '새로고침 완료! $count명의 매칭된 페르소나';
  }

  @override
  String get refreshFailed => 'Refresh failed';

  @override
  String get refreshingChatList => 'Refreshing chat list...';

  @override
  String get relatedFAQ => '관련 FAQ';

  @override
  String get report => '신고하기';

  @override
  String get reportAI => '신고';

  @override
  String get reportAIDescription => 'AI가 당신에게 불쾌감을 주었다면 내용을 적어 신고하세요.';

  @override
  String get reportAITitle => 'AI 대화 신고';

  @override
  String get reportAndBlock => '신고 및 차단';

  @override
  String get reportAndBlockDescription => '이 AI의 부적절한 행동을 신고하고 차단할 수 있습니다';

  @override
  String get reportChatError => '대화 오류 신고';

  @override
  String reportError(String error) {
    return '신고 접수 중 오류가 발생했습니다: $error';
  }

  @override
  String get reportFailed => 'Report failed';

  @override
  String get reportSubmitted => '신고가 접수되었습니다. 검토 후 조치하겠습니다.';

  @override
  String get reportSubmittedSuccess => '신고가 접수되었습니다. 감사합니다!';

  @override
  String get requestLimit => '요청 제한';

  @override
  String get required => '[필수]';

  @override
  String get requiredTermsAgreement => 'Please agree to the terms';

  @override
  String get restartConversation => '다시 대화하기';

  @override
  String restartConversationQuestion(String name) {
    return '$name와 다시 대화를 시작하시겠어요?';
  }

  @override
  String restartConversationWithName(String name) {
    return '$name와 다시 대화를 시작합니다!';
  }

  @override
  String get retry => '다시 시도';

  @override
  String get retryButton => '다시 시도';

  @override
  String get sad => '슬퍼요';

  @override
  String get saturday => '토요일';

  @override
  String get save => '저장';

  @override
  String get search => '검색';

  @override
  String get searchFAQ => 'FAQ 검색...';

  @override
  String get searchResults => '검색 결과';

  @override
  String get selectEmotion => '감정 선택';

  @override
  String get selectErrorType => '오류 유형을 선택하세요';

  @override
  String get selectFeeling => '감정 선택';

  @override
  String get selectGender => '성별을 선택해주세요';

  @override
  String get selectInterests => '관심사를 선택해주세요 (최소 1개)';

  @override
  String get selectLanguage => '언어를 선택하세요';

  @override
  String get selectPersona => 'Select a persona';

  @override
  String get selectPersonaPlease => '페르소나를 선택해 주세요.';

  @override
  String get selectPreferredMbti => '특정 MBTI 유형의 페르소나를 선호하신다면 선택해주세요';

  @override
  String get selectProblematicMessage => '문제가 있는 메시지를 선택해주세요 (선택사항)';

  @override
  String get selectReportReason => 'Select report reason';

  @override
  String get selectTheme => '테마를 선택하세요';

  @override
  String get selectTranslationError => '번역 오류가 있는 메시지를 선택해주세요';

  @override
  String get selectUsagePurpose => 'SONA를 사용하시는 목적을 선택해주세요';

  @override
  String get selfIntroduction => '자기소개 (선택)';

  @override
  String get selfIntroductionHint => '간단한 자기소개를 작성해주세요';

  @override
  String get send => '전송';

  @override
  String get sendChatError => '대화 오류 전송하기';

  @override
  String get sendFirstMessage => 'Send your first message';

  @override
  String get sendReport => '신고하기';

  @override
  String get sendingEmail => '이메일 발송 중...';

  @override
  String get seoul => '서울';

  @override
  String get serverErrorDashboard => '서버 오류';

  @override
  String get serviceTermsAgreement => 'Please agree to the terms of service';

  @override
  String get sessionExpired => '세션이 만료되었습니다';

  @override
  String get setAppInterfaceLanguage => '앱 인터페이스 언어를 설정합니다';

  @override
  String get setNow => '지금 설정하기';

  @override
  String get settings => '설정';

  @override
  String get sexualContent => '성적인 콘텐츠';

  @override
  String get showAllGenderPersonas => '모든 성별 페르소나 보기';

  @override
  String get showAllGendersOption => '모든 성별 보기';

  @override
  String get showOppositeGenderOnly => '체크하지 않으면 이성 페르소나만 표시됩니다';

  @override
  String get showOriginalText => '원문 보기';

  @override
  String get signUp => '회원가입';

  @override
  String get signUpFromGuest => '지금 회원가입하고 모든 기능을 이용하세요!';

  @override
  String get signup => '회원가입';

  @override
  String get signupComplete => '가입완료';

  @override
  String get signupTab => '회원가입';

  @override
  String get simpleInfoRequired => 'AI 페르소나와의 매칭을 위해\n간단한 정보가 필요해요';

  @override
  String get skip => '건너뛰기';

  @override
  String get sonaFriend => '소나 친구';

  @override
  String get sonaPrivacyPolicy => 'SONA Privacy Policy';

  @override
  String get sonaPurchasePolicy => 'SONA Purchase Policy';

  @override
  String get sonaTermsOfService => 'SONA Terms of Service';

  @override
  String get sonaUsagePurpose => 'SONA를 사용하시는 목적을 선택해주세요';

  @override
  String get sorryNotHelpful => 'Sorry this wasn\'t helpful';

  @override
  String get sort => '정렬';

  @override
  String get soundSettings => '소리 설정';

  @override
  String get spamAdvertising => '스팸/광고';

  @override
  String get spanish => '스페인어';

  @override
  String get specialRelationshipDesc => '서로를 이해하고 깊은 유대감을 쌓아요';

  @override
  String get sports => '스포츠';

  @override
  String get spring => '봄';

  @override
  String get startChat => '대화 시작';

  @override
  String get startChatButton => '채팅 시작';

  @override
  String get startConversation => 'Start a conversation';

  @override
  String get startConversationLikeAFriend => '소나와 친구처럼 대화를 시작해보세요';

  @override
  String get startConversationStep => '2. 대화 시작: 매칭된 페르소나와 자유롭게 대화를 나누세요.';

  @override
  String get startConversationWithSona => '소나와 친구처럼 대화를 시작해보세요!';

  @override
  String get startWithEmail => '이메일로 시작하기';

  @override
  String get startWithGoogle => 'Google로 시작하기';

  @override
  String get startingApp => '앱을 시작하고 있어요';

  @override
  String get storageManagement => '저장소 관리';

  @override
  String get store => '스토어';

  @override
  String get storeConnectionError => 'Could not connect to store';

  @override
  String get storeLoginRequiredMessage =>
      '스토어 이용을 위해 로그인이 필요합니다.\n로그인 화면으로 이동하시겠습니까?';

  @override
  String get storeNotAvailable => 'Store is not available';

  @override
  String get storyEvent => '스토리 이벤트';

  @override
  String get stressed => '스트레스받아요';

  @override
  String get submitReport => '신고 제출';

  @override
  String get subscriptionStatus => '구독 현황';

  @override
  String get subtleVibrationOnTouch => '터치 시 미세한 진동 효과';

  @override
  String get summer => '여름';

  @override
  String get sunday => '일요일';

  @override
  String get swipeAnyDirection => '아무 방향으로나 스와이프하세요';

  @override
  String get swipeDownToClose => '아래로 스와이프하여 닫기';

  @override
  String get systemTheme => '시스템 설정 따르기';

  @override
  String get systemThemeDesc => '기기의 다크 모드 설정에 따라 자동으로 변경됩니다';

  @override
  String get tapBottomForDetails => '하단 영역을 탭하여 상세 정보 보기';

  @override
  String get tapForDetails => '하단 영역을 탭하여 상세 정보 보기';

  @override
  String get tapToSwipePhotos => 'Tap to swipe photos';

  @override
  String get teachersDay => '스승의날';

  @override
  String get technicalError => '기술적 오류';

  @override
  String get technology => '기술';

  @override
  String get terms => '이용약관';

  @override
  String get termsAgreement => '약관 동의';

  @override
  String get termsAgreementDescription => '서비스 이용을 위한 약관에 동의해주세요';

  @override
  String get termsOfService => '서비스 이용약관';

  @override
  String get termsSection10Content =>
      'We reserve the right to modify these terms at any time with notice to users.';

  @override
  String get termsSection10Title => '제10조 (분쟁해결)';

  @override
  String get termsSection11Content =>
      'These terms shall be governed by the laws of the jurisdiction in which we operate.';

  @override
  String get termsSection11Title => '제11조 (AI 서비스 특별조항)';

  @override
  String get termsSection12Content =>
      'If any provision of these terms is found to be unenforceable, the remaining provisions shall continue in full force and effect.';

  @override
  String get termsSection12Title => '제12조 (데이터 수집 및 활용)';

  @override
  String get termsSection1Content =>
      '본 약관은 SONA(이하 \"회사\")가 제공하는 AI 페르소나 대화 매칭 서비스(이하 \"서비스\")의 이용과 관련하여 회사와 이용자 간의 권리, 의무 및 책임사항을 규정함을 목적으로 합니다.';

  @override
  String get termsSection1Title => '제1조 (목적)';

  @override
  String get termsSection2Content =>
      'By using our service, you agree to be bound by these Terms of Service and our Privacy Policy.';

  @override
  String get termsSection2Title => '제2조 (정의)';

  @override
  String get termsSection3Content =>
      'You must be at least 13 years old to use our service.';

  @override
  String get termsSection3Title => '제3조 (약관의 효력 및 변경)';

  @override
  String get termsSection4Content =>
      'You are responsible for maintaining the confidentiality of your account and password.';

  @override
  String get termsSection4Title => '제4조 (서비스의 제공)';

  @override
  String get termsSection5Content =>
      'You agree not to use our service for any illegal or unauthorized purpose.';

  @override
  String get termsSection5Title => '제5조 (회원가입)';

  @override
  String get termsSection6Content =>
      'We reserve the right to terminate or suspend your account for violation of these terms.';

  @override
  String get termsSection6Title => '제6조 (이용자의 의무)';

  @override
  String get termsSection7Content =>
      '회사는 이용자가 본 약관의 의무를 위반하거나 서비스의 정상적인 운영을 방해한 경우, 경고, 일시정지, 영구이용정지 등으로 서비스 이용을 단계적으로 제한할 수 있습니다.';

  @override
  String get termsSection7Title => '제7조 (서비스 이용제한)';

  @override
  String get termsSection8Content =>
      'We are not liable for any indirect, incidental, or consequential damages arising from your use of our service.';

  @override
  String get termsSection8Title => '제8조 (서비스 중단)';

  @override
  String get termsSection9Content =>
      'All content and materials available on our service are protected by intellectual property rights.';

  @override
  String get termsSection9Title => '제9조 (면책조항)';

  @override
  String get termsSupplementary => 'Supplementary Terms';

  @override
  String get thai => '태국어';

  @override
  String get thanksFeedback => '피드백 감사합니다!';

  @override
  String get theme => '테마';

  @override
  String get themeDescription => '앱의 외관을 원하는 대로 설정할 수 있습니다';

  @override
  String get themeSettings => '테마 설정';

  @override
  String get thursday => '목요일';

  @override
  String get timeout => '타임아웃';

  @override
  String get tired => '피곤해요';

  @override
  String get today => '오늘';

  @override
  String get todayChats => '오늘';

  @override
  String get todayText => '오늘';

  @override
  String get tomorrowText => '내일';

  @override
  String get totalConsultSessions => '총 상담 세션';

  @override
  String get totalErrorCount => '총 에러 수';

  @override
  String get totalLikes => '총 Like';

  @override
  String totalOccurrences(Object count) {
    return '총 $count회 발생';
  }

  @override
  String get totalResponses => '총 응답';

  @override
  String get translatedFrom => '번역됨';

  @override
  String get translatedText => '번역';

  @override
  String get translationError => 'Translation error';

  @override
  String get translationErrorDescription => '잘못된 번역이나 어색한 표현을 신고해주세요';

  @override
  String get translationErrorReported => '번역 오류가 신고되었습니다. 감사합니다!';

  @override
  String get translationNote => '※ AI 번역은 완벽하지 않을 수 있습니다';

  @override
  String get translationQuality => '번역 품질';

  @override
  String get translationSettings => '번역 설정';

  @override
  String get travel => '여행';

  @override
  String get tuesday => '화요일';

  @override
  String get tutorialAccount => '튜토리얼 계정';

  @override
  String get tutorialWelcomeDescription => 'AI 페르소나와 특별한 관계를 만들어보세요.';

  @override
  String get tutorialWelcomeTitle => 'SONA에 오신 것을 환영합니다!';

  @override
  String get typeMessage => '메시지를 입력하세요...';

  @override
  String get unblock => '차단 해제';

  @override
  String get unblockFailed => '차단 해제에 실패했습니다';

  @override
  String unblockPersonaConfirm(String name) {
    return '$name의 차단을 해제하시겠습니까?';
  }

  @override
  String get unblockedSuccessfully => '차단이 해제되었습니다';

  @override
  String get unexpectedLoginError => '로그인 중 예상치 못한 오류가 발생했습니다';

  @override
  String get unknown => '알 수 없음';

  @override
  String get unknownError => '알 수 없는 오류가 발생했습니다';

  @override
  String get unlimitedMessages => '무제한';

  @override
  String get unsendMessage => '메시지 취소';

  @override
  String get usagePurpose => '사용 목적';

  @override
  String get useOneHeart => '하트 1개 사용하기';

  @override
  String get useSystemLanguage => '시스템 언어 사용';

  @override
  String get user => '사용자: ';

  @override
  String get userMessage => '사용자 메시지:';

  @override
  String get userNotFound => '사용자를 찾을 수 없습니다';

  @override
  String get valentinesDay => '발렌타인데이';

  @override
  String get verifyingAuth => '인증 확인 중';

  @override
  String get version => '버전';

  @override
  String get vietnamese => '베트남어';

  @override
  String get violentContent => '폭력적인 콘텐츠';

  @override
  String get voiceMessage => '🎤 음성 메시지';

  @override
  String waitingForChat(String name) {
    return '$name님이 대화를 기다리고 있어요.';
  }

  @override
  String get walk => '산책';

  @override
  String get wasHelpful => '도움이 되었나요?';

  @override
  String get weatherClear => '맑음';

  @override
  String get weatherCloudy => '흐림';

  @override
  String get weatherContext => '날씨 컨텍스트';

  @override
  String get weatherContextDesc => '날씨 정보를 활용한 대화 맥락 제공';

  @override
  String get weatherDrizzle => '이슬비';

  @override
  String get weatherFog => '짙은 안개';

  @override
  String get weatherMist => '안개';

  @override
  String get weatherRain => '비';

  @override
  String get weatherRainy => '비';

  @override
  String get weatherSnow => '눈';

  @override
  String get weatherSnowy => '눈';

  @override
  String get weatherThunderstorm => '뇌우';

  @override
  String get wednesday => '수요일';

  @override
  String get weekdays => '일,월,화,수,목,금,토';

  @override
  String get welcomeMessage => '오신 걸 환영해요💕';

  @override
  String get whatTopicsToTalk => '어떤 주제로 대화하고 싶으신가요? (선택사항)';

  @override
  String get whiteDay => '화이트데이';

  @override
  String get winter => '겨울';

  @override
  String get wrongTranslation => '잘못된 번역';

  @override
  String get year => '년';

  @override
  String get yearEnd => '연말';

  @override
  String get yes => '예';

  @override
  String get yesterday => '어제';

  @override
  String get yesterdayChats => '어제';

  @override
  String get you => '나';
}
