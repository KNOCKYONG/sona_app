import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';

/// 앱 전체에서 사용되는 다국어 문자열 관리
class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = [
    Locale('en', 'US'),
    Locale('ko', 'KR'),
  ];

  // 현재 로케일이 한국어인지 확인
  bool get isKorean => locale.languageCode == 'ko';

  // ===== 공통 =====
  String get appName => isKorean ? 'SONA' : 'SONA';
  String get loading => isKorean ? '로딩 중...' : 'Loading...';
  String get error => isKorean ? '오류' : 'Error';
  String get retry => isKorean ? '다시 시도' : 'Retry';
  String get cancel => isKorean ? '취소' : 'Cancel';
  String get confirm => isKorean ? '확인' : 'Confirm';
  String get next => isKorean ? '다음' : 'Next';
  String get skip => isKorean ? '건너뛰기' : 'Skip';
  String get done => isKorean ? '완료' : 'Done';
  String get save => isKorean ? '저장' : 'Save';
  String get delete => isKorean ? '삭제' : 'Delete';
  String get edit => isKorean ? '수정' : 'Edit';
  String get close => isKorean ? '닫기' : 'Close';
  String get search => isKorean ? '검색' : 'Search';
  String get filter => isKorean ? '필터' : 'Filter';
  String get sort => isKorean ? '정렬' : 'Sort';
  String get refresh => isKorean ? '새로고침' : 'Refresh';
  String get yes => isKorean ? '예' : 'Yes';
  String get no => isKorean ? '아니오' : 'No';

  // ===== 로그인/회원가입 =====
  String get login => isKorean ? '로그인' : 'Login';
  String get signup => isKorean ? '회원가입' : 'Sign Up';
  String get meetAIPersonas => isKorean ? 'AI 페르소나를 만나보세요' : 'Meet AI Personas';
  String get welcomeMessage => isKorean ? '오신 걸 환영해요💕' : 'Welcome💕';
  String get aiDatingQuestion => isKorean
      ? 'AI랑 연애하면 어떤 기분일까?\n당신만의 페르소나를 만나보세요.'
      : 'How would it feel to date AI?\nMeet your own personas.';
  String get loginSignup => isKorean ? '로그인/회원가입' : 'Login/Sign Up';
  String get or => isKorean ? '또는' : 'or';
  String get startWithEmail => isKorean ? '이메일로 시작하기' : 'Start with Email';
  String get startWithGoogle => isKorean ? 'Google로 시작하기' : 'Start with Google';
  String get loginWithGoogle =>
      isKorean ? 'Google로 로그인' : 'Sign in with Google';
  String get loginError => isKorean ? '로그인에 실패했습니다' : 'Login failed';
  String get googleLoginError => isKorean
      ? 'Google 로그인 중 오류가 발생했습니다.'
      : 'Error occurred during Google login.';
  String get loginCancelled => isKorean ? '로그인이 취소되었습니다' : 'Login cancelled';
  String get loginWithoutAccount =>
      isKorean ? '로그인 없이 둘러보기' : 'Browse without login';
  String get logout => isKorean ? '로그아웃' : 'Logout';
  String get logoutConfirm =>
      isKorean ? '정말 로그아웃하시겠습니까?' : 'Are you sure you want to logout?';
  String get basicInfo => isKorean ? '기본 정보' : 'Basic Information';
  String get enterBasicInfo => isKorean
      ? '계정 생성을 위한 기본 정보를 입력해주세요'
      : 'Please enter basic information to create an account';
  String get email => isKorean ? '이메일' : 'Email';
  String get password => isKorean ? '비밀번호' : 'Password';
  String get nickname => isKorean ? '닉네임' : 'Nickname';
  String get nicknameRequired => isKorean ? '닉네임 *' : 'Nickname *';
  String get emailRequired => isKorean ? '이메일 *' : 'Email *';
  String get passwordRequired => isKorean ? '비밀번호 *' : 'Password *';
  String get emailHint => isKorean ? 'example@email.com' : 'example@email.com';
  String get passwordHint => isKorean ? '6자 이상' : '6 characters or more';
  String get nicknameHint => isKorean ? '3-10자' : '3-10 characters';
  String get enterEmail => isKorean ? '이메일을 입력해주세요' : 'Please enter email';
  String get invalidEmailFormat =>
      isKorean ? '올바른 이메일 형식이 아닙니다' : 'Invalid email format';
  String get enterPassword =>
      isKorean ? '비밀번호를 입력해주세요' : 'Please enter password';
  String get passwordTooShort => isKorean
      ? '비밀번호는 6자 이상이어야 합니다'
      : 'Password must be at least 6 characters';
  String get enterNickname =>
      isKorean ? '닉네임을 입력해주세요' : 'Please enter nickname';
  String get nicknameLength =>
      isKorean ? '닉네임은 3-10자여야 합니다' : 'Nickname must be 3-10 characters';
  String get nicknameAlreadyUsed =>
      isKorean ? '이미 사용 중인 닉네임입니다' : 'Nickname already in use';
  String get profilePhotoAndInfo => isKorean
      ? '프로필 사진과 기본 정보를 입력해주세요'
      : 'Please enter profile photo and basic information';
  String get profilePhoto => isKorean ? '프로필 사진' : 'Profile Photo';
  String get gender => isKorean ? '성별' : 'Gender';
  String get genderRequired => isKorean ? '성별 *' : 'Gender *';
  String get male => isKorean ? '남성' : 'Male';
  String get female => isKorean ? '여성' : 'Female';
  String get other => isKorean ? '기타' : 'Other';
  String get birthDate => isKorean ? '생년월일' : 'Birth Date';
  String get birthDateRequired => isKorean ? '생년월일 *' : 'Birth Date *';
  String get selectGender => isKorean ? '성별을 선택해주세요' : 'Please select gender';
  String get selectBirthDate =>
      isKorean ? '생년월일을 선택해주세요' : 'Please select birth date';
  String get personaGenderPreference =>
      isKorean ? '페르소나 성별 선호' : 'Persona Gender Preference';
  String get showAllGenders =>
      isKorean ? '모든 성별 페르소나 보기' : 'Show all gender personas';
  String get showOppositeGenderOnly => isKorean
      ? '체크하지 않으면 이성 페르소나만 표시됩니다'
      : 'If unchecked, only opposite gender personas will be shown';
  String get usagePurpose => isKorean ? '사용 목적' : 'Usage Purpose';
  String get selectUsagePurpose => isKorean
      ? 'SONA를 사용하시는 목적을 선택해주세요'
      : 'Please select your purpose for using SONA';
  String get selectPurpose =>
      isKorean ? '사용 목적을 선택해주세요' : 'Please select usage purpose';

  // ===== 감정/페르소나 =====
  String get feelingQuestion =>
      isKorean ? '지금 어떤 기분이신가요?' : 'How are you feeling?';
  String get selectFeeling => isKorean ? '감정 선택' : 'Select Feeling';
  String get happy => isKorean ? '행복해요' : 'Happy';
  String get sad => isKorean ? '슬퍼요' : 'Sad';
  String get angry => isKorean ? '화나요' : 'Angry';
  String get anxious => isKorean ? '불안해요' : 'Anxious';
  String get tired => isKorean ? '피곤해요' : 'Tired';
  String get lonely => isKorean ? '외로워요' : 'Lonely';
  String get stressed => isKorean ? '스트레스받아요' : 'Stressed';
  String get depressed => isKorean ? '우울해요' : 'Depressed';
  String get excited => isKorean ? '신나요' : 'Excited';
  String get calm => isKorean ? '평온해요' : 'Calm';

  String get recommendedPersonas =>
      isKorean ? '추천 페르소나' : 'Recommended Personas';
  String get allPersonas => isKorean ? '모든 페르소나' : 'All Personas';
  String get noPersonasFound =>
      isKorean ? '페르소나를 찾을 수 없습니다' : 'No personas found';
  String get loadingPersonas =>
      isKorean ? '페르소나를 불러오는 중...' : 'Loading personas...';

  // ===== 채팅 =====
  String get chat => isKorean ? '채팅' : 'Chat';
  String get chats => isKorean ? '채팅' : 'Chats';
  String get startChat => isKorean ? '대화 시작' : 'Start Chat';
  String get endChat => isKorean ? '대화 종료' : 'End Chat';
  String get endChatConfirm =>
      isKorean ? '대화를 종료하시겠습니까?' : 'Do you want to end this chat?';
  String get typeMessage => isKorean ? '메시지를 입력하세요...' : 'Type a message...';
  String get send => isKorean ? '전송' : 'Send';
  String get noChatsYet => isKorean ? '아직 대화가 없습니다' : 'No chats yet';
  String get noConversationYet =>
      isKorean ? '아직 대화가 없어요' : 'No conversation yet';
  String get sendFirstMessage =>
      isKorean ? '첫 메시지를 보내보세요!' : 'Send your first message!';
  String get todayChats => isKorean ? '오늘' : 'Today';
  String get yesterdayChats => isKorean ? '어제' : 'Yesterday';
  String get olderChats => isKorean ? '이전' : 'Older';
  String get chatEndedMessage => isKorean ? '대화가 종료되었습니다' : 'Chat has ended';
  String get messageDeleted => isKorean ? '메시지가 삭제되었습니다' : 'Message deleted';
  String get unsendMessage => isKorean ? '메시지 취소' : 'Unsend message';
  String get copyMessage => isKorean ? '메시지 복사' : 'Copy message';
  String get messageCopied => isKorean ? '메시지가 복사되었습니다' : 'Message copied';
  String waitingForChat(String name) =>
      isKorean ? '$name님이 대화를 기다리고 있어요.' : '$name is waiting to chat.';
  String get voiceMessage => isKorean ? '🎤 음성 메시지' : '🎤 Voice message';
  String get adaptiveConversation =>
      isKorean ? '맞춤형 대화' : 'Adaptive Conversation';
  String get adaptiveConversationDesc => isKorean
      ? '상대방의 말투와 스타일에 맞춰 대화합니다'
      : 'Adapts conversation style to match yours';
  String get signUp => isKorean ? '회원가입' : 'Sign Up';
  String conversationWith(String name) => isKorean ? '$name' : '$name';
  String get noMatchedPersonas =>
      isKorean ? '아직 매칭된 페르소나가 없어요' : 'No matched personas yet';
  String get meetNewPersonas =>
      isKorean ? '새로운 페르소나를 만나러 가볼까요?' : 'Want to meet new personas?';
  String get meetPersonas => isKorean ? '페르소나 만나기' : 'Meet Personas';
  String get refreshingChatList =>
      isKorean ? '채팅 목록을 새로고침하는 중...' : 'Refreshing chat list...';
  String refreshComplete(int count) => isKorean
      ? '새로고침 완료! ${count}명의 매칭된 페르소나'
      : 'Refresh complete! $count matched personas';
  String get allPersonasChecked =>
      isKorean ? '모든 소나를 확인했습니다!' : 'All personas checked!';
  String get wantNewEncounters =>
      isKorean ? '새로운 만남을 원하시나요?' : 'Want new encounters?';
  String get canMeetPreviousPersonas => isKorean
      ? '이전에 스와이프한 페르소나들을\n다시 만날 수 있어요!'
      : 'You can meet personas\nyou swiped before again!';
  String get endTutorialAndLogin => isKorean
      ? '튜토리얼을 종료하고 로그인하시겠습니까?\n로그인하면 데이터가 저장되고 모든 기능을 사용할 수 있습니다.'
      : 'End tutorial and login?\nLogin to save data and use all features.';
  String get dailyLimitTitle =>
      isKorean ? '일일 메시지 한도 도달' : 'Daily message limit reached';
  String get dailyLimitDescription => isKorean
      ? '오늘의 메시지 100개를 모두 사용하셨습니다.\n하트 1개를 사용하여 다시 100개의 메시지를 보낼 수 있습니다.'
      : 'You\'ve used all 100 messages today.\nUse 1 heart to send 100 more messages.';
  String get messageLimitReset =>
      isKorean ? '메시지 한도가 리셋되었습니다!' : 'Message limit reset!';
  String get heartInsufficient => isKorean ? '하트가 부족합니다' : 'Not enough hearts';
  String get messageSendFailed => isKorean
      ? '메시지 전송에 실패했습니다. 다시 시도해주세요.'
      : 'Failed to send message. Please try again.';
  String get leaveChatTitle => isKorean ? '채팅방 나가기' : 'Leave Chat';
  String get leaveChatConfirm => isKorean
      ? '이 채팅방을 나가시겠습니까?\n채팅 목록에서 사라집니다.'
      : 'Leave this chat?\nIt will disappear from your chat list.';
  String get leave => isKorean ? '나가기' : 'Leave';

  // ===== 스토어/구매 =====
  String get store => isKorean ? '스토어' : 'Store';
  String get hearts => isKorean ? '하트' : 'Hearts';
  String get notSubscribed => isKorean ? '미가입' : 'Not subscribed';
  String daysRemaining(int days) =>
      isKorean ? '$days일 남음' : '$days days remaining';
  String get expired => isKorean ? '만료됨' : 'Expired';
  String get purchaseConfirm => isKorean ? '구매 확인' : 'Purchase Confirmation';
  String purchaseConfirmMessage(String product, String price) => isKorean
      ? '$product을(를) $price에 구매하시겠습니까?'
      : 'Purchase $product for $price?';
  String get purchasePending =>
      isKorean ? '이미 구매가 진행 중입니다' : 'Purchase already in progress';
  String get purchaseFailed =>
      isKorean ? '구매를 시작할 수 없습니다' : 'Cannot start purchase';
  String get storeNotAvailable =>
      isKorean ? '스토어를 사용할 수 없습니다' : 'Store is not available';
  String get storeConnectionError =>
      isKorean ? '스토어 연결 오류' : 'Store connection error';
  String get loadingProducts =>
      isKorean ? '상품 정보를 불러오는 중...' : 'Loading products...';
  String get noProductsFound =>
      isKorean ? '상품을 찾을 수 없습니다' : 'No products found';
  String get purchaseButton => isKorean ? '구매하기' : 'Purchase';
  String get discount20 => isKorean ? '20% 할인' : '20% off';
  String get discount30 => isKorean ? '30% 할인' : '30% off';

  // 상품 설명
  String get hearts10 => isKorean ? '하트 10개' : '10 Hearts';
  String get hearts30 => isKorean ? '하트 30개' : '30 Hearts';
  String get hearts50 => isKorean ? '하트 50개' : '50 Hearts';
  String get heartDescription =>
      isKorean ? '매칭과 채팅에 사용할 수 있는 하트' : 'Hearts for matching and chatting';

  // ===== 설정 =====
  String get settings => isKorean ? '설정' : 'Settings';
  String get profile => isKorean ? '프로필' : 'Profile';
  String get profilePhotoUpdated =>
      isKorean ? '프로필 사진이 업데이트되었습니다' : 'Profile photo has been updated';
  String get profilePhotoUpdateFailed =>
      isKorean ? '프로필 사진 업데이트에 실패했습니다' : 'Failed to update profile photo';
  String get loginRequiredForProfile => isKorean
      ? '프로필을 보고 소나와의 기록을 확인하려면\n로그인이 필요해요'
      : 'Login required to view profile\nand check records with SONA';
  String get editProfile => isKorean ? '프로필 편집' : 'Edit Profile';
  String get purchaseHeartsOnly => isKorean ? '하트 구매' : 'Buy hearts';
  String get tutorialAccount => isKorean ? '튜토리얼 계정' : 'Tutorial Account';
  String get subscriptionStatus => isKorean ? '구독 현황' : 'Subscription Status';
  String get editInfo => isKorean ? '정보 수정' : 'Edit Info';
  String get joinDate => isKorean ? '가입일' : 'Join Date';
  String get notifications => isKorean ? '알림' : 'Notifications';
  String get notificationSettings =>
      isKorean ? '알림 설정' : 'Notification Settings';
  String get pushNotifications => isKorean ? '푸시 알림' : 'Push Notifications';
  String get newMessageNotification =>
      isKorean ? '새로운 메시지 알림을 받습니다' : 'Receive new message notifications';
  String get soundSettings => isKorean ? '소리 설정' : 'Sound Settings';
  String get effectSound => isKorean ? '효과음' : 'Sound Effects';
  String get effectSoundDescription =>
      isKorean ? '앱 내 효과음을 켜거나 끕니다' : 'Turn app sound effects on or off';
  String get language => isKorean ? '언어' : 'Language';
  String get languageSettings => isKorean ? '언어 설정' : 'Language Settings';
  String get theme => isKorean ? '테마' : 'Theme';
  String get themeSettings => isKorean ? '테마 설정' : 'Theme Settings';
  String get darkMode => isKorean ? '다크 모드' : 'Dark Mode';
  String get privacy => isKorean ? '개인정보 처리방침' : 'Privacy Policy';
  String get terms => isKorean ? '이용약관' : 'Terms of Service';
  String get purchasePolicy =>
      isKorean ? '구매 및 환불 정책' : 'Purchase & Refund Policy';
  String get help => isKorean ? '도움말' : 'Help';
  String get about => isKorean ? '앱 정보' : 'About';
  String get version => isKorean ? '버전' : 'Version';
  String get others => isKorean ? '기타' : 'Others';
  String get accountManagement => isKorean ? '계정 관리' : 'Account Management';
  String get deleteAccount => isKorean ? '계정 삭제' : 'Delete Account';
  String get deleteAccountWarning =>
      isKorean ? '모든 데이터가 삭제됩니다' : 'All data will be deleted';
  String get deleteAccountConfirm => isKorean
      ? '정말로 계정을 삭제하시겠습니까? 이 작업은 되돌릴 수 없습니다.'
      : 'Are you sure you want to delete your account? This action cannot be undone.';

  // Help Dialog
  String get howToUse => isKorean ? 'SONA 사용 방법' : 'How to use SONA';
  String get matchPersonaStep => isKorean
      ? '1. 페르소나 매칭: 좌우로 스와이프하여 마음에 드는 AI 페르소나를 선택하세요.'
      : '1. Match Personas: Swipe left or right to select your favorite AI personas.';
  String get startConversationStep => isKorean
      ? '2. 대화 시작: 매칭된 페르소나와 자유롭게 대화를 나누세요.'
      : '2. Start Conversation: Chat freely with matched personas.';
  String get developRelationshipStep => isKorean
      ? '3. 관계 발전: 대화를 통해 친밀도를 쌓고 특별한 관계로 발전시켜보세요.'
      : '3. Develop Relationship: Build intimacy through conversations and develop special relationships.';
  String get inquiries => isKorean ? '문의사항' : 'Inquiries';
  String get appTagline =>
      isKorean ? 'AI와 함께하는 특별한 만남' : 'Special encounters with AI';
  String get emotionBasedEncounters =>
      isKorean ? '감정으로 만나는 특별한 인연' : 'Special encounters through emotions';
  String get loginRequired => isKorean ? '로그인이 필요합니다' : 'Login required';
  String get sonaFriend => isKorean ? '소나 친구' : 'SONA Friend';
  String get totalLikes => isKorean ? '총 Like' : 'Total Likes';
  String get ownedHearts => isKorean ? '보유 하트' : 'Owned Hearts';
  String get matchedPersonas => isKorean ? '매칭된 소나' : 'Matched Personas';
  String chattingWithPersonas(int count) =>
      isKorean ? '${count}명의 소나와 대화중' : 'Chatting with $count personas';

  // ===== 에러 메시지 =====
  String get networkError =>
      isKorean ? '네트워크 연결을 확인해주세요' : 'Please check your network connection';
  String get somethingWentWrong =>
      isKorean ? '문제가 발생했습니다' : 'Something went wrong';
  String get refreshFailed =>
      isKorean ? '새로고침 실패. 다시 시도해주세요.' : 'Refresh failed. Please try again.';
  String get loginFailedTryAgain =>
      isKorean ? '로그인에 실패했습니다. 다시 시도해주세요.' : 'Login failed. Please try again.';
  String get imageNotAvailable =>
      isKorean ? '이미지가 없습니다' : 'Image not available';
  String get internetConnectionCheck =>
      isKorean ? '인터넷 연결을 확인해주세요' : 'Please check your internet connection';
  String get purchaseAlreadyInProgress =>
      isKorean ? '이미 구매가 진행 중입니다' : 'Purchase already in progress';
  String get cannotStartPurchase =>
      isKorean ? '구매를 시작할 수 없습니다' : 'Cannot start purchase';
  String get loadingProductInfo =>
      isKorean ? '상품 정보를 불러오는 중...' : 'Loading product information...';
  String get retryButton => isKorean ? '다시 시도' : 'Retry';
  String get purchaseConfirmTitle =>
      isKorean ? '구매 확인' : 'Purchase Confirmation';
  String purchaseConfirmContent(String product, String price) => isKorean
      ? '$product을(를) $price에 구매하시겠습니까?'
      : 'Purchase $product for $price?';
  String get loginCompleted =>
      isKorean ? '로그인이 완료되었습니다 🎉' : 'Login completed 🎉';
  String get heartInsufficientPleaseCharge => isKorean
      ? '하트가 부족합니다. 하트를 충전해주세요.'
      : 'Not enough hearts. Please recharge hearts.';
  String get matchingFailed => isKorean ? '매칭에 실패했습니다.' : 'Matching failed.';
  String get errorOccurred => isKorean ? '오류가 발생했습니다.' : 'An error occurred.';
  String get selectAtLeastOneInterest =>
      isKorean ? '관심사를 최소 1개 이상 선택해주세요' : 'Please select at least one interest';
  String get agreeToRequiredTerms =>
      isKorean ? '필수 약관에 동의해주세요' : 'Please agree to required terms';
  String get previous => isKorean ? '이전' : 'Previous';
  String get signupComplete => isKorean ? '가입완료' : 'Sign Up Complete';
  String get casualConversation =>
      isKorean ? '편안하고 캐주얼한 대화' : 'Comfortable and casual conversation';
  String get casualConversationDesc =>
      isKorean ? '친구처럼 편하게 대화해요' : 'Chat comfortably like friends';
  String get formalConversation =>
      isKorean ? '정중하고 포멀한 대화' : 'Polite and formal conversation';
  String get formalConversationDesc =>
      isKorean ? '공손하고 예의 바르게 대화해요' : 'Chat politely and courteously';
  String get specialRelationship =>
      isKorean ? '특별한 관계 맺기' : 'Build special relationships';
  String get specialRelationshipDesc => isKorean
      ? '서로를 이해하고 깊은 유대감을 쌓아요'
      : 'Understand each other and build deep bonds';
  String get emotionalSupport =>
      isKorean ? '정서적 지원과 위로' : 'Emotional support and comfort';
  String get emotionalSupportDesc => isKorean
      ? '고민을 나누고 따뜻한 위로를 받아요'
      : 'Share your concerns and receive warm comfort';
  String get entertainmentAndFun =>
      isKorean ? '재미있는 오락과 놀이' : 'Entertainment and fun';
  String get entertainmentAndFunDesc => isKorean
      ? '즐거운 게임과 유쾌한 대화를 즐겨요'
      : 'Enjoy fun games and pleasant conversations';
  String get accountDeletionTitle => isKorean ? '계정 삭제' : 'Delete Account';
  String get accountDeletionContent => isKorean
      ? '정말로 계정을 삭제하시겠습니까?\n이 작업은 되돌릴 수 없습니다.'
      : 'Are you sure you want to delete your account?\nThis action cannot be undone.';
  String get accountDeletionInfo =>
      isKorean ? '계정 삭제 시:' : 'When deleting account:';
  String get accountDeletionWarning1 =>
      isKorean ? '• 모든 대화 기록이 삭제됩니다' : '• All chat history will be deleted';
  String get accountDeletionWarning2 =>
      isKorean ? '• 보유한 하트가 모두 사라집니다' : '• All hearts will be lost';
  String get accountDeletionWarning3 =>
      isKorean ? '• 모든 구독이 취소됩니다' : '• All subscriptions will be cancelled';
  String get accountDeletionWarning4 =>
      isKorean ? '• 이 작업은 되돌릴 수 없습니다' : '• This action cannot be undone';
  String get continueButton => isKorean ? '계속' : 'Continue';
  String get userNotFound => isKorean ? '사용자를 찾을 수 없습니다' : 'User not found';
  String get accountDeletionError => isKorean
      ? '계정 삭제 중 오류가 발생했습니다.'
      : 'Error occurred while deleting account.';
  String get incorrectPassword =>
      isKorean ? '비밀번호가 올바르지 않습니다.' : 'Password is incorrect.';
  String get recentLoginRequired =>
      isKorean ? '보안을 위해 다시 로그인해주세요.' : 'Please login again for security.';
  String get passwordConfirmation =>
      isKorean ? '비밀번호 확인' : 'Password Confirmation';
  String get passwordConfirmationDesc => isKorean
      ? '계정 삭제를 위해 비밀번호를 다시 입력해주세요.'
      : 'Please re-enter your password to delete account.';
  String get deletingAccount =>
      isKorean ? '계정을 삭제하는 중...' : 'Deleting account...';
  String get accountDeletedSuccess =>
      isKorean ? '계정이 성공적으로 삭제되었습니다.' : 'Account successfully deleted.';
  String get monitoringTitle =>
      isKorean ? '상담 품질 모니터링' : 'Chat Quality Monitoring';
  String get noQualityIssues => isKorean
      ? '최근 1시간 동안 품질 문제가 없습니다 ✅'
      : 'No quality issues in the last hour ✅';
  String get loadingData => isKorean ? '데이터를 로딩 중입니다...' : 'Loading data...';
  String get noQualityLogs =>
      isKorean ? '아직 품질 로그가 없습니다.' : 'No quality logs yet.';
  String get report => isKorean ? '신고하기' : 'Report';
  String get reportInProgress =>
      isKorean ? '신고를 접수하는 중...' : 'Submitting report...';
  String get reportSubmitted => isKorean
      ? '신고가 접수되었습니다. 검토 후 조치하겠습니다.'
      : 'Report submitted. We will review and take action.';
  String reportError(String error) => isKorean
      ? '신고 접수 중 오류가 발생했습니다: $error'
      : 'Error submitting report: $error';
  String get loginRequiredToReport =>
      isKorean ? '신고하려면 로그인이 필요합니다' : 'Login required to report';
  String get termsOfService => isKorean ? '서비스 이용약관' : 'Terms of Service';
  String get privacyPolicy => isKorean ? '개인정보 처리방침' : 'Privacy Policy';
  String get grantPermission => isKorean ? '권한 허용' : 'Grant Permission';
  String get goToSettings => isKorean ? '설정으로 이동' : 'Go to Settings';
  String get notificationPermissionRequired =>
      isKorean ? '알림 권한 필요' : 'Notification Permission Required';
  String get notificationPermissionDesc => isKorean
      ? '새로운 메시지를 받으려면 알림 권한이 필요합니다.'
      : 'Notification permission is required to receive new messages.';
  String get later => isKorean ? '나중에' : 'Later';
  String get tryAgainLater =>
      isKorean ? '나중에 다시 시도해주세요' : 'Please try again later';
  String get noInternetConnection =>
      isKorean ? '인터넷 연결이 없습니다' : 'No internet connection';
  String get serverError =>
      isKorean ? '서버 오류가 발생했습니다' : 'Server error occurred';
  String get sessionExpired => isKorean ? '세션이 만료되었습니다' : 'Session expired';
  String get notEnoughHearts => isKorean ? '하트가 부족합니다' : 'Not enough hearts';
  String get unauthorizedAccess =>
      isKorean ? '접근 권한이 없습니다' : 'Unauthorized access';
  String get inappropriateContent =>
      isKorean ? '부적절한 콘텐츠' : 'Inappropriate content';
  String get spamAdvertising => isKorean ? '스팸/광고' : 'Spam/Advertising';
  String get hateSpeech => isKorean ? '혐오 발언' : 'Hate speech';
  String get sexualContent => isKorean ? '성적인 콘텐츠' : 'Sexual content';
  String get violentContent => isKorean ? '폭력적인 콘텐츠' : 'Violent content';
  String get harassmentBullying => isKorean ? '괴롭힘/따돌림' : 'Harassment/Bullying';
  String get personalInfoExposure =>
      isKorean ? '개인정보 노출' : 'Personal info exposure';
  String get copyrightInfringement =>
      isKorean ? '저작권 침해' : 'Copyright infringement';
  String get selectReportReason =>
      isKorean ? '신고 사유를 선택해주세요:' : 'Please select report reason:';
  String get detailedReason => isKorean ? '상세 사유' : 'Detailed reason';
  String get explainReportReason => isKorean
      ? '신고 사유를 자세히 설명해주세요'
      : 'Please explain the report reason in detail';

  // ===== 권한 =====
  String get permissionRequired => isKorean ? '권한 필요' : 'Permission Required';
  String get cameraPermission => isKorean ? '카메라 권한' : 'Camera Permission';
  String get galleryPermission => isKorean ? '갤러리 권한' : 'Gallery Permission';
  String get notificationPermission =>
      isKorean ? '알림 권한' : 'Notification Permission';
  String get permissionDenied => isKorean ? '권한이 거부되었습니다' : 'Permission denied';
  String get openSettings => isKorean ? '설정 열기' : 'Open Settings';
  String get cameraPermissionDesc => isKorean
      ? '프로필 사진 촬영을 위해 카메라 접근이 필요합니다.'
      : 'Camera access is required to take profile photos.';
  String get galleryPermissionDesc => isKorean
      ? '프로필 사진 선택을 위해 갤러리 접근이 필요합니다.'
      : 'Gallery access is required to select profile photos.';
  String permissionDeniedMessage(String permissionName) => isKorean
      ? '$permissionName 권한이 거부되었습니다.\n설정에서 권한을 허용해주세요.'
      : '$permissionName permission was denied.\nPlease allow permission in settings.';

  // ===== 일일 메시지 제한 =====
  String get dailyLimitReached =>
      isKorean ? '오늘의 메시지 한도에 도달했습니다' : 'Daily message limit reached';
  String get purchaseMoreHearts => isKorean
      ? '하트를 구매하여 대화를 계속하세요'
      : 'Purchase hearts to continue conversations';
  String messagesRemaining(int count) =>
      isKorean ? '남은 메시지: $count개' : '$count messages remaining';
  String get unlimitedMessages => isKorean ? '무제한' : 'Unlimited';

  // ===== 회원가입 추가 문구 =====
  String get requiredTermsAgreement =>
      isKorean ? '필수 약관에 동의해주세요' : 'Please agree to the required terms';
  String get nicknameLengthError =>
      isKorean ? '닉네임은 2-10자여야 합니다' : 'Nickname must be 2-10 characters';
  String get serviceTermsAgreement =>
      isKorean ? '서비스 이용약관에 동의해주세요' : 'Please agree to the Terms of Service';
  String get privacyPolicyAgreement =>
      isKorean ? '개인정보 처리방침에 동의해주세요' : 'Please agree to the Privacy Policy';
  String get completeSignup => isKorean ? '가입완료' : 'Complete Sign Up';
  String get basicInfoDescription => isKorean
      ? '계정 생성을 위한 기본 정보를 입력해주세요'
      : 'Please enter basic information to create an account';
  String get nicknameLabel => isKorean ? '닉네임 *' : 'Nickname *';
  String get profileInfo => isKorean ? '프로필 정보' : 'Profile Information';
  String get profileInfoDescription => isKorean
      ? '프로필 사진과 기본 정보를 입력해주세요'
      : 'Please enter your profile photo and basic information';
  String get year => isKorean ? '년' : 'Year';
  String get month => isKorean ? '월' : 'Month';
  String get day => isKorean ? '일' : 'Day';
  String get optional => isKorean ? '선택사항' : 'Optional';
  String get selfIntroduction => isKorean ? '자기소개' : 'Self Introduction';
  String get selfIntroductionHint => isKorean
      ? '간단한 자기소개를 작성해주세요 (선택)'
      : 'Please write a brief introduction (Optional)';
  String get generalPersona => isKorean ? '일반 페르소나' : 'General Persona';
  String get expertPersona => isKorean ? '전문가 페르소나' : 'Expert Persona';
  String get friendshipDescription => isKorean
      ? '새로운 친구를 만나고 대화를 나누고 싶어요'
      : 'I want to meet new friends and have conversations';
  String get datingDescription => isKorean
      ? '깊은 고민과 진솔한 대화를 나누고 싶어요'
      : 'I want to share deep thoughts and have sincere conversations';
  String get counselingDescription =>
      isKorean ? '전문가의 조언과 상담이 필요해요' : 'I need expert advice and counseling';
  String get entertainmentDescription => isKorean
      ? '재미있는 대화와 즐거운 시간을 보내고 싶어요'
      : 'I want to have fun conversations and enjoy my time';
  String get interests => isKorean ? '관심사' : 'Interests';
  String get selectInterests => isKorean
      ? '관심사를 선택해주세요 (최소 1개)'
      : 'Please select your interests (at least 1)';
  String get preferredTopics =>
      isKorean ? '선호하는 대화 주제' : 'Preferred Conversation Topics';
  String get whatTopicsToTalk => isKorean
      ? '어떤 주제로 대화하고 싶으신가요? (선택사항)'
      : 'What topics would you like to talk about? (Optional)';
  String get preferredConversationStyle =>
      isKorean ? '선호하는 대화 스타일' : 'Preferred Conversation Style';
  String get preferredMbti =>
      isKorean ? '선호하는 MBTI (선택사항)' : 'Preferred MBTI (Optional)';
  String get selectPreferredMbti => isKorean
      ? '특정 MBTI 유형의 페르소나를 선호하신다면 선택해주세요'
      : 'If you prefer personas with specific MBTI types, please select';
  String get termsAgreement => isKorean ? '약관 동의' : 'Terms Agreement';
  String get termsAgreementDescription => isKorean
      ? '서비스 이용을 위한 약관에 동의해주세요'
      : 'Please agree to the terms for using the service';
  String get preferredPersonaType =>
      isKorean ? '선호하는 페르소나 유형' : 'Preferred Persona Type';
  String get sonaUsagePurpose => isKorean
      ? 'SONA를 사용하시는 목적을 선택해주세요'
      : 'Please select your purpose for using SONA';
  String get preferredPersonaAgeRange =>
      isKorean ? '선호하는 페르소나 나이 범위 *' : 'Preferred Persona Age Range *';
  String get preferenceSettings => isKorean ? '선호 설정' : 'Preference Settings';
  String get aiPersonaPreferenceDescription => isKorean
      ? 'AI 페르소나 매칭을 위한 선호도를 설정해주세요'
      : 'Please set your preferences for AI persona matching';

  // ===== 채팅 화면 =====
  String get loginRequiredService =>
      isKorean ? '로그인이 필요한 서비스입니다' : 'Login required for this service';
  String get leaveChatRoom => isKorean ? '채팅방 나가기' : 'Leave Chat Room';
  String get backButton => isKorean ? '뒤로가기' : 'Back';
  String get moreButton => isKorean ? '더보기' : 'More';
  String get selectPersona =>
      isKorean ? '페르소나를 선택해주세요' : 'Please select a persona';
  String get chatListTab => isKorean ? '채팅 목록 탭' : 'Chat List Tab';

  // ===== 로그인 화면 =====
  String get checkInternetConnection =>
      isKorean ? '인터넷 연결을 확인해주세요' : 'Please check your internet connection';
  String get unexpectedLoginError => isKorean
      ? '로그인 중 예상치 못한 오류가 발생했습니다'
      : 'An unexpected error occurred during login';
  String get googleLoginCanceled => isKorean
      ? '구글 로그인이 취소되었습니다.\n다시 시도해주세요.'
      : 'Google login was canceled.\nPlease try again.';
  String get passwordResetEmailPrompt => isKorean
      ? '비밀번호를 재설정할 이메일을 입력해주세요'
      : 'Please enter your email to reset password';
  String get invalidEmailFormatError =>
      isKorean ? '올바른 이메일 형식을 입력해주세요' : 'Please enter a valid email format';
  String get passwordResetEmailSent => isKorean
      ? '비밀번호 재설정 이메일을 발송했습니다. 이메일을 확인해주세요.'
      : 'Password reset email has been sent. Please check your email.';
  String get loginTab => isKorean ? '로그인' : 'Login';
  String get signupTab => isKorean ? '회원가입' : 'Sign Up';
  String get browseWithoutLogin =>
      isKorean ? '로그인 없이 둘러보기' : 'Browse without login';
  String get emailLabel => isKorean ? '이메일' : 'Email';
  String get passwordLabel => isKorean ? '비밀번호' : 'Password';
  String get sendingEmail => isKorean ? '이메일 발송 중...' : 'Sending email...';
  String get forgotPassword => isKorean ? '비밀번호 찾기' : 'Forgot Password';
  String get simpleInfoRequired => isKorean
      ? 'AI 페르소나와의 매칭을 위해\n간단한 정보가 필요해요'
      : 'Simple information is required\nfor matching with AI personas';

  // ===== 페르소나 선택 화면 =====
  String get endTutorial => isKorean ? '튜토리얼 종료' : 'End Tutorial';
  String get endTutorialMessage => isKorean
      ? '튜토리얼을 종료하고 로그인하시겠습니까?\n로그인하면 데이터가 저장되고 모든 기능을 사용할 수 있습니다.'
      : 'Do you want to end the tutorial and login?\nBy logging in, your data will be saved and you can use all features.';
  String get loginFailed =>
      isKorean ? '로그인에 실패했습니다. 다시 시도해주세요.' : 'Login failed. Please try again.';
  String get loginComplete =>
      isKorean ? '로그인이 완료되었습니다 🎉' : 'Login completed 🎉';

  // ===== 프로필 편집 화면 =====
  String get profileUpdated =>
      isKorean ? '프로필이 업데이트되었습니다' : 'Profile has been updated';
  String get profileUpdateFailed =>
      isKorean ? '프로필 업데이트 실패' : 'Profile update failed';
  String get profileEdit => isKorean ? '프로필 편집' : 'Edit Profile';
  String get complete => isKorean ? '완료' : 'Done';
  String get changeProfilePhoto =>
      isKorean ? '프로필 사진 변경' : 'Change Profile Photo';
  String get nicknameInUse =>
      isKorean ? '이미 사용 중인 닉네임입니다' : 'This nickname is already in use';
  String get showAllGenderPersonas =>
      isKorean ? '모든 성별 페르소나 보기' : 'Show all gender personas';
  String get onlyOppositeGenderNote => isKorean
      ? '체크하지 않으면 이성 페르소나만 표시됩니다'
      : 'If unchecked, only opposite gender personas will be shown';

  // ===== 채팅 목록 화면 =====
  String get startConversation =>
      isKorean ? '대화를 시작해보세요!' : 'Start a conversation!';
  String get startConversationWithSona => isKorean
      ? '소나와 친구처럼 대화를 시작해보세요!'
      : 'Start chatting with Sona like a friend!';
  String get me => isKorean ? '나' : 'Me';
  String get photo => isKorean ? '사진' : 'Photo';
  String daysAgo(int days) => isKorean ? '$days일 전' : '$days days ago';
  String hoursAgo(int hours) => isKorean ? '$hours시간 전' : '$hours hours ago';
  String minutesAgo(int minutes) =>
      isKorean ? '$minutes분 전' : '$minutes minutes ago';
  String get justNow => isKorean ? '방금 전' : 'Just now';
  String isTyping(String name) =>
      isKorean ? '$name님이 입력 중...' : '$name is typing...';

  // ===== 메시지 버블 =====
  String get storyEvent => isKorean ? '스토리 이벤트' : 'Story Event';
  String get chooseOption => isKorean ? '선택하세요:' : 'Please choose:';

  // ===== 페르소나 카드 =====
  String get tapToSwipePhotos =>
      isKorean ? '좌우 탭으로 사진 넘기기' : 'Tap left/right to swipe photos';

  // ===== 권한 =====
  String get allowPermission => isKorean ? '권한 허용' : 'Allow Permission';

  // ===== 날짜/시간 =====
  String formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inDays == 0) {
      return DateFormat('HH:mm').format(time);
    } else if (difference.inDays == 1) {
      return isKorean ? '어제' : 'Yesterday';
    } else if (difference.inDays < 7) {
      return DateFormat('E', locale.toString()).format(time);
    } else {
      return DateFormat('MM/dd').format(time);
    }
  }

  String formatDate(DateTime date) {
    return DateFormat('yyyy.MM.dd', locale.toString()).format(date);
  }

  String formatFullDateTime(DateTime dateTime) {
    return DateFormat('yyyy.MM.dd HH:mm', locale.toString()).format(dateTime);
  }

  // Privacy Policy
  String get sonaPrivacyPolicy =>
      isKorean ? 'SONA 개인정보 처리방침' : 'SONA Privacy Policy';
  String get lastUpdated =>
      isKorean ? '마지막 업데이트: 2024년 7월 24일' : 'Last updated: July 24, 2024';

  String get privacySection1Title => isKorean
      ? '1. 개인정보 수집 및 이용 목적'
      : '1. Purpose of Collection and Use of Personal Information';
  String get privacySection1Content => isKorean
      ? '''SONA(이하 "앱")는 다음 목적으로 개인정보를 수집 및 이용합니다:

• 회원 가입 및 계정 관리
• AI 페르소나 대화 서비스 제공
• 서비스 품질 향상 및 맞춤형 서비스 제공
• 고객 지원 및 문의 대응
• 서비스 이용 통계 분석'''
      : '''SONA (the "App") collects and uses personal information for the following purposes:

• Member registration and account management
• AI persona chat service provision
• Service quality improvement and personalized service
• Customer support and inquiry response
• Service usage statistics analysis''';

  String get privacySection2Title =>
      isKorean ? '2. 수집하는 개인정보 항목' : '2. Personal Information We Collect';
  String get privacySection2Content => isKorean
      ? '''앱에서 수집하는 개인정보는 다음과 같습니다:

필수 정보:
• Google 계정 정보 (이메일, 프로필 사진, 이름)
• 기기 정보 (기기 ID, 운영체제 버전)
• 서비스 이용 기록 (대화 내역, 이용 시간)

선택 정보:
• 사용자 설정 정보
• 피드백 및 문의 내용'''
      : '''The personal information collected by the app includes:

Required Information:
• Google account information (email, profile picture, name)
• Device information (device ID, OS version)
• Service usage records (chat history, usage time)

Optional Information:
• User preference settings
• Feedback and inquiry content''';

  String get privacySection3Title => isKorean
      ? '3. 개인정보 보관 및 이용 기간'
      : '3. Retention and Use Period of Personal Information';
  String get privacySection3Content => isKorean
      ? '''• 회원 탈퇴 시까지 보관하며, 탈퇴 즉시 파기됩니다.
• 법령에 의해 보관이 필요한 경우 해당 기간까지 보관합니다.
• 서비스 이용 기록은 통계 분석 후 즉시 익명화됩니다.'''
      : '''• Retained until membership withdrawal and deleted immediately upon withdrawal.
• Retained for the required period if required by law.
• Service usage records are anonymized immediately after statistical analysis.''';

  String get privacySection4Title => isKorean
      ? '4. 개인정보 제3자 제공'
      : '4. Provision of Personal Information to Third Parties';
  String get privacySection4Content => isKorean
      ? '''앱은 다음의 경우를 제외하고는 개인정보를 제3자에게 제공하지 않습니다:

• 사용자의 동의가 있는 경우
• 법령에 의해 요구되는 경우
• OpenAI 등 AI 서비스 제공을 위한 필요한 경우 (대화 내용은 익명화하여 전송)'''
      : '''The app does not provide personal information to third parties except in the following cases:

• With user consent
• When required by law
• When necessary for AI service provision such as OpenAI (conversations are anonymized before transmission)''';

  String get privacySection5Title => isKorean
      ? '5. 개인정보 보호를 위한 기술적 보호조치'
      : '5. Technical Protection Measures for Personal Information';
  String get privacySection5Content => isKorean
      ? '''• Firebase 보안 시스템을 통한 데이터 암호화
• HTTPS 통신을 통한 전송 구간 암호화
• 접근 권한 관리 및 로그 모니터링
• 정기적인 보안 점검 및 업데이트'''
      : '''• Data encryption through Firebase security system
• Transmission encryption through HTTPS communication
• Access control management and log monitoring
• Regular security checks and updates''';

  String get privacySection6Title => isKorean ? '6. 이용자의 권리' : '6. User Rights';
  String get privacySection6Content => isKorean
      ? '''사용자는 다음 권리를 행사할 수 있습니다:

• 개인정보 열람, 정정, 삭제 요구
• 개인정보 처리 정지 요구
• 손해 발생 시 피해 구제 신청
• 회원 탈퇴 및 개인정보 전체 삭제

이러한 권리 행사를 원하실 경우:
1. 앱 내 설정 > 계정 관리에서 직접 처리
2. 고객센터 이메일(privacy@sona-app.com)로 요청
3. 회원 탈퇴 시 모든 개인정보는 즉시 삭제됩니다

데이터 삭제 요청 시 처리 기간:
• 일반 요청: 3영업일 이내
• 회원 탈퇴: 즉시 처리'''
      : '''Users can exercise the following rights:

• Request to access, correct, or delete personal information
• Request to stop processing personal information
• Apply for damage relief in case of harm
• Membership withdrawal and complete deletion of personal information

To exercise these rights:
1. Process directly in App Settings > Account Management
2. Request via customer service email (privacy@sona-app.com)
3. All personal information is immediately deleted upon membership withdrawal

Processing period for data deletion requests:
• General requests: Within 3 business days
• Membership withdrawal: Immediate processing''';

  String get privacySection7Title =>
      isKorean ? '7. 개인정보보호책임자' : '7. Personal Information Protection Officer';
  String get privacySection7Content => isKorean
      ? '''개인정보 처리에 관한 문의사항이 있으시면 아래로 연락주시기 바랍니다:

• 이메일: privacy@sona-app.com
• 개인정보보호책임자: SONA 개발팀
• 처리 부서: 개발운영팀'''
      : '''For inquiries regarding personal information processing, please contact us at:

• Email: privacy@sona-app.com
• Personal Information Protection Officer: SONA Development Team
• Processing Department: Development Operations Team''';

  String get privacySection8Title =>
      isKorean ? '8. 개인정보 처리방침 변경' : '8. Changes to Privacy Policy';
  String get privacySection8Content => isKorean
      ? '''본 개인정보 처리방침은 법령, 정책 또는 보안기술의 변경에 따라 내용의 추가, 
삭제 및 수정이 있을 시에는 변경 최소 7일 전부터 앱을 통해 변경 이유 및 내용 등을 공지하도록 하겠습니다.

본 개인정보 처리방침은 2024년 7월 24일부터 적용됩니다.'''
      : '''This privacy policy may be added, deleted, or modified according to changes in laws, policies, or security technologies. 
We will notify you of the reasons and details of changes through the app at least 7 days before the change.

This privacy policy is effective from July 24, 2024.''';

  // Theme Settings
  String get selectTheme => isKorean ? '테마를 선택하세요' : 'Select Theme';
  String get themeDescription => isKorean
      ? '앱의 외관을 원하는 대로 설정할 수 있습니다'
      : 'You can customize the app appearance as you like';
  String get systemTheme => isKorean ? '시스템 설정 따르기' : 'Follow System';
  String get systemThemeDesc => isKorean
      ? '기기의 다크 모드 설정에 따라 자동으로 변경됩니다'
      : 'Automatically changes based on device dark mode settings';
  String get lightTheme => isKorean ? '라이트 모드' : 'Light Mode';
  String get lightThemeDesc => isKorean ? '밝은 테마를 사용합니다' : 'Use bright theme';
  String get darkTheme => isKorean ? '다크 모드' : 'Dark Mode';
  String get darkThemeDesc => isKorean ? '어두운 테마를 사용합니다' : 'Use dark theme';
  String get preview => isKorean ? '미리보기' : 'Preview';
  String get helloEmoji => isKorean ? '안녕하세요! 😊' : 'Hello! 😊';
  String get niceToMeetYou => isKorean ? '반가워요!' : 'Nice to meet you!';

  // Purchase Policy
  String get purchaseAndRefundPolicy =>
      isKorean ? '구매 및 환불 정책' : 'Purchase and Refund Policy';
  String get sonaPurchasePolicy =>
      isKorean ? 'SONA 구매 및 환불 정책' : 'SONA Purchase and Refund Policy';
  String get purchaseSection1Title =>
      isKorean ? '1. 인앱 구매 상품' : '1. In-App Purchase Items';
  String get purchaseSection1Content => isKorean
      ? '''SONA에서 제공하는 인앱 구매 상품:

하트 구매:
• 하트 10개: ₩1,200
• 하트 30개: ₩3,300 (8% 할인)
• 하트 50개: ₩4,900 (18% 할인)'''
      : '''In-app purchase items offered by SONA:

Heart Purchase:
• 10 Hearts: ₩1,200
• 30 Hearts: ₩3,300 (8% discount)
• 50 Hearts: ₩4,900 (18% discount)''';

  String get purchaseSection2Title =>
      isKorean ? '2. 결제 방법' : '2. Payment Methods';
  String get purchaseSection2Content => isKorean
      ? '''• Google Play Store: Google Play 계정에 등록된 결제 수단
• Apple App Store: Apple ID에 등록된 결제 수단

결제는 구매 확인 시 자동으로 청구됩니다.'''
      : '''• Google Play Store: Payment method registered to your Google Play account
• Apple App Store: Payment method registered to your Apple ID

Payment will be automatically charged upon purchase confirmation.''';

  String get purchaseSection3Title =>
      isKorean ? '3. 환불 정책' : '3. Refund Policy';
  String get purchaseSection3Content => isKorean
      ? '''하트 상품:
• 구매 후 사용하지 않은 하트에 한해 구매일로부터 7일 이내 환불 가능
• 사용한 하트는 환불 불가
• 결제 오류 시 즉시 고객센터 문의'''
      : '''Hearts Products:
• Refund available within 7 days of purchase for unused hearts only
• Used hearts are non-refundable
• Contact customer service immediately for payment errors''';

  String get purchaseSection4Title =>
      isKorean ? '4. 취소 정책' : '4. Cancellation Policy';
  String get purchaseSection4Content => isKorean
      ? '''구매 취소:
• 결제 완료 전: 언제든지 취소 가능
• 결제 완료 후: 환불 정책에 따라 처리
• 오류로 인한 중복 결제: 전액 환불

고객센터:
• 이메일: support@teamsona.app
• 운영시간: 평일 09:00-18:00 (주말/공휴일 제외)

하트(소모성 상품):
• 구매 후 미사용 상태: 구매일로부터 7일 이내 환불 가능
• 일부라도 사용한 경우: 환불 불가

환불 요청 방법:
1. Google Play/App Store 환불 정책에 따라 직접 요청
2. 고객센터(support@sona-app.com)로 구매 영수증과 함께 요청

※ 환불 처리는 스토어 정책에 따라 3-5영업일 소요될 수 있습니다.'''
      : '''Purchase Cancellation:
• Before payment completion: Can be cancelled anytime
• After payment completion: Processed according to refund policy
• Duplicate payment due to error: Full refund

Customer Service:
• Email: support@teamsona.app
• Hours: Weekdays 09:00-18:00 (Excluding weekends/holidays)

Hearts (Consumable Items):
• Unused after purchase: Refundable within 7 days of purchase
• Partially used: Non-refundable

How to Request Refund:
1. Request directly according to Google Play/App Store refund policy
2. Request to customer service (support@sona-app.com) with purchase receipt

※ Refund processing may take 3-5 business days according to store policy.''';

  String get purchaseSection5Title =>
      isKorean ? '5. 이용 제한' : '5. Usage Restrictions';
  String get purchaseSection5Content => isKorean
      ? '''다음의 경우 구매한 상품 이용이 제한될 수 있습니다:
• 부정한 방법으로 구매한 경우
• 환불 후 재구매를 반복하는 경우
• 서비스 이용약관을 위반한 경우

이용 제한 시 구매한 상품에 대한 환불은 불가합니다.'''
      : '''Usage of purchased items may be restricted in the following cases:
• Purchased through fraudulent means
• Repeated refund and repurchase
• Violation of Terms of Service

Refunds are not available for purchased items when usage is restricted.''';

  String get purchaseSection6Title => isKorean ? '6. 문의사항' : '6. Inquiries';
  String get purchaseSection6Content => isKorean
      ? '''구매 관련 문의사항이 있으시면 아래로 연락주세요:

• 이메일: support@sona-app.com
• 고객센터 운영시간: 평일 10:00 - 18:00
• 답변 소요시간: 1-2영업일

구매 영수증과 함께 문의하시면 더 빠른 처리가 가능합니다.'''
      : '''For purchase-related inquiries, please contact us at:

• Email: support@sona-app.com
• Customer service hours: Weekdays 10:00 - 18:00
• Response time: 1-2 business days

Faster processing is available when you provide your purchase receipt.''';

  // Usage Purpose Options
  String get makeFriends => isKorean ? '친구 만들기' : 'Make Friends';
  String get emotionalConnection =>
      isKorean ? '정서적 교감' : 'Emotional Connection';
  String get hobbySharing => isKorean ? '취미 공유' : 'Hobby Sharing';
  String get lonelinessRelief => isKorean ? '외로움 해소' : 'Loneliness Relief';
  String get dailyConversation => isKorean ? '일상 대화' : 'Daily Conversation';
  String get entertainmentFun => isKorean ? '오락/재미' : 'Entertainment/Fun';

  // Age Unit
  String get ageUnit => isKorean ? '세' : 'years old';
  String ageRange(int min, int max) =>
      isKorean ? '$min~$max세' : '$min-$max years old';

  // Interests
  String get gaming => isKorean ? '게임' : 'Gaming';
  String get movies => isKorean ? '영화' : 'Movies';
  String get music => isKorean ? '음악' : 'Music';
  String get reading => isKorean ? '독서' : 'Reading';
  String get sports => isKorean ? '스포츠' : 'Sports';
  String get travel => isKorean ? '여행' : 'Travel';
  String get cooking => isKorean ? '요리' : 'Cooking';
  String get fashion => isKorean ? '패션' : 'Fashion';
  String get technology => isKorean ? '기술' : 'Technology';
  String get art => isKorean ? '예술' : 'Art';
  String get pets => isKorean ? '반려동물' : 'Pets';
  String get photography => isKorean ? '사진' : 'Photography';

  // Conversation Topics
  String get dailyChat => isKorean ? '일상 대화' : 'Daily Chat';
  String get datingAdvice => isKorean ? '연애 상담' : 'Dating Advice';
  String get hobbyTalk => isKorean ? '취미 이야기' : 'Hobby Talk';
  String get lifeAdvice => isKorean ? '인생 조언' : 'Life Advice';
  String get funChat => isKorean ? '재미있는 대화' : 'Fun Chat';
  String get deepTalk => isKorean ? '깊은 대화' : 'Deep Talk';
  String get lightTalk => isKorean ? '가벼운 수다' : 'Light Talk';

  // Terms Agreement Additional
  String get allAgree => isKorean ? '전체 동의' : 'Agree to All';
  String get termsOfServiceAgree =>
      isKorean ? '서비스 이용약관 동의' : 'Agree to Terms of Service';
  String get privacyPolicyAgree =>
      isKorean ? '개인정보 처리방침 동의' : 'Agree to Privacy Policy';
  String get marketingAgree => isKorean
      ? '마케팅 정보 수신 동의 (선택)'
      : 'Agree to Marketing Information (Optional)';
  String get required => isKorean ? '[필수]' : '[Required]';
  String get marketingDescription => isKorean
      ? '이벤트 및 혜택 정보를 받아보실 수 있습니다'
      : 'You can receive event and benefit information';
  String get ageConfirmation => isKorean
      ? '만 14세 이상이며, 위 내용을 확인했습니다.'
      : 'I am 14 years or older and have confirmed the above.';
  String get agreeToTerms => isKorean ? '에 동의합니다' : '';

  // ===== 다국어 지원 =====
  // Removed duplicate - languageSettings already defined at line 206
  String get preferredLanguage => isKorean ? '선호 언어' : 'Preferred Language';
  String get selectLanguage => isKorean ? '언어를 선택하세요' : 'Select Language';
  String get languageDescription => isKorean
      ? 'AI가 선택한 언어로 응답합니다'
      : 'AI will respond in your selected language';
  String get korean => isKorean ? '한국어' : 'Korean';
  String get english => isKorean ? '영어' : 'English';
  String get japanese => isKorean ? '일본어' : 'Japanese';
  String get chinese => isKorean ? '중국어' : 'Chinese';
  String get indonesian => isKorean ? '인도네시아어' : 'Indonesian';
  String get vietnamese => isKorean ? '베트남어' : 'Vietnamese';
  String get spanish => isKorean ? '스페인어' : 'Spanish';
  String get thai => isKorean ? '태국어' : 'Thai';
  String get showOriginalText => isKorean ? '원문 보기' : 'Show Original';
  String get hideOriginalText => isKorean ? '원문 숨기기' : 'Hide Original';
  String get translationError =>
      isKorean ? '번역 오류 신고' : 'Report Translation Error';
  String get translationErrorReport =>
      isKorean ? '번역 오류 신고' : 'Report Translation Error';
  String get translationErrorDescription => isKorean
      ? '잘못된 번역이나 어색한 표현을 신고해주세요'
      : 'Please report incorrect translations or awkward expressions';
  String get errorDetails => isKorean ? '오류 상세 내용' : 'Error Details';
  String get errorDetailsHint => isKorean
      ? '어떤 부분이 잘못되었는지 자세히 설명해주세요'
      : 'Please explain in detail what is wrong';
  String get submitReport => isKorean ? '신고 제출' : 'Submit Report';
  String get reportSubmittedSuccess => isKorean
      ? '신고가 접수되었습니다. 감사합니다!'
      : 'Your report has been submitted. Thank you!';
  String get reportSubmitFailed =>
      isKorean ? '신고 제출에 실패했습니다' : 'Failed to submit report';
  String get translationNote => isKorean
      ? '※ AI 번역은 완벽하지 않을 수 있습니다'
      : '※ AI translation may not be perfect';
  String get multilingualChat => isKorean ? '다국어 채팅' : 'Multilingual Chat';
  String get languageIndicator => isKorean ? '언어' : 'Language';
  String get translatedFrom => isKorean ? '번역됨' : 'Translated';
  String get originalText => isKorean ? '원문' : 'Original';
  String get noTranslatedMessages =>
      isKorean ? '번역된 메시지가 없습니다' : 'No translated messages';
  String get selectTranslationError => isKorean
      ? '번역 오류가 있는 메시지를 선택해주세요'
      : 'Please select a message with translation error';
  String get translationErrorReported => isKorean
      ? '번역 오류가 신고되었습니다. 감사합니다!'
      : 'Translation error reported. Thank you!';
  String get reportFailed =>
      isKorean ? '신고 제출에 실패했습니다' : 'Failed to submit report';
  String get translatedText => isKorean ? '번역' : 'Translation';
  String get autoTranslate => isKorean ? '자동 번역' : 'Auto Translate';
  String get translationSettings => isKorean ? '번역 설정' : 'Translation Settings';
  String get alwaysShowOriginal =>
      isKorean ? '항상 원문 표시' : 'Always Show Original';
  String get translationQuality => isKorean ? '번역 품질' : 'Translation Quality';
  String get reportTranslationIssue =>
      isKorean ? '번역 문제 신고' : 'Report Translation Issue';
  String get languageChanged =>
      isKorean ? '언어가 변경되었습니다' : 'Language has been changed';
  String get languageChangeFailed =>
      isKorean ? '언어 변경에 실패했습니다' : 'Failed to change language';
  String get selectErrorType => isKorean ? '오류 유형을 선택하세요' : 'Select error type';
  String get wrongTranslation => isKorean ? '잘못된 번역' : 'Wrong Translation';
  String get awkwardExpression => isKorean ? '어색한 표현' : 'Awkward Expression';
  String get missingTranslation => isKorean ? '번역 누락' : 'Missing Translation';
  String get culturalIssue => isKorean ? '문화적 오류' : 'Cultural Issue';
  String get technicalError => isKorean ? '기술적 오류' : 'Technical Error';
  String get otherError => isKorean ? '기타 오류' : 'Other Error';

  // Language codes map
  String getLanguageName(String code) {
    switch (code) {
      case 'ko':
        return korean;
      case 'en':
        return english;
      case 'ja':
        return japanese;
      case 'zh':
        return chinese;
      case 'id':
        return indonesian;
      case 'vi':
        return vietnamese;
      case 'es':
        return spanish;
      case 'th':
        return thai;
      default:
        return english;
    }
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ko'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
