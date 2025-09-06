// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get about => '关于';

  @override
  String get accountAndProfile => '账户与个人信息';

  @override
  String get accountDeletedSuccess => '账户已成功删除';

  @override
  String get accountDeletionContent => '您确定要删除您的账户吗？';

  @override
  String get accountDeletionError => '删除账户时发生错误。';

  @override
  String get accountDeletionInfo => '账户删除信息';

  @override
  String get accountDeletionTitle => '删除账户';

  @override
  String get accountDeletionWarning1 => '警告：此操作无法撤消';

  @override
  String get accountDeletionWarning2 => '所有数据将被永久删除';

  @override
  String get accountDeletionWarning3 => '您将无法访问所有对话记录';

  @override
  String get accountDeletionWarning4 => '这包括所有购买的内容';

  @override
  String get accountManagement => '账户管理';

  @override
  String get adaptiveConversationDesc => '根据您的风格调整对话方式';

  @override
  String get afternoon => '下午';

  @override
  String get afternoonFatigue => '下午疲劳';

  @override
  String get ageConfirmation => '我已年满14岁并确认上述信息。';

  @override
  String ageRange(int min, int max) {
    return '$min-$max岁';
  }

  @override
  String get ageUnit => '岁';

  @override
  String get agreeToTerms => '同意条款';

  @override
  String get aiDatingQuestion => '你会和AI谈恋爱吗？';

  @override
  String get aiPersonaPreferenceDescription => '请设置您的AI角色匹配偏好';

  @override
  String get all => '全部';

  @override
  String get allAgree => '同意所有';

  @override
  String get allFeaturesRequired => '※ 所有功能均为服务提供所需';

  @override
  String get allPersonas => '全部';

  @override
  String get allPersonasMatched => '所有角色已匹配！开始与他们聊天吧。';

  @override
  String get allowPermission => '继续';

  @override
  String alreadyChattingWith(String name) {
    return '已经在与$name聊天！';
  }

  @override
  String get alsoBlockThisAI => '也阻止这个AI';

  @override
  String get angry => '生气';

  @override
  String get anonymousLogin => '匿名登录';

  @override
  String get anxious => '焦虑';

  @override
  String get apiKeyError => 'API密钥错误';

  @override
  String get appName => 'SONA';

  @override
  String get appTagline => '您的AI伴侣';

  @override
  String get appleLoginCanceled => 'Apple登录已被取消。';

  @override
  String get appleLoginError => 'Apple登录失败';

  @override
  String get art => '艺术';

  @override
  String get authError => '认证错误';

  @override
  String get autoTranslate => '自动翻译';

  @override
  String get autumn => '秋天';

  @override
  String get averageQuality => '平均质量';

  @override
  String get averageQualityScore => '平均质量评分';

  @override
  String get awkwardExpression => '尴尬的表情';

  @override
  String get backButton => '返回';

  @override
  String get basicInfo => '基本信息';

  @override
  String get basicInfoDescription => '请填写基本信息以创建账户';

  @override
  String get birthDate => '出生日期';

  @override
  String get birthDateOptional => '出生日期（可选）';

  @override
  String get birthDateRequired => '出生日期 *';

  @override
  String get blockConfirm => '您想要屏蔽这个AI吗？';

  @override
  String get blockReason => '屏蔽原因';

  @override
  String get blockThisAI => '屏蔽这个AI';

  @override
  String blockedAICount(int count) {
    return '$count 个已屏蔽的AI';
  }

  @override
  String get blockedAIs => '已屏蔽的AI';

  @override
  String get blockedAt => '屏蔽于';

  @override
  String get blockedSuccessfully => '屏蔽成功';

  @override
  String get breakfast => '早餐';

  @override
  String get byErrorType => '按错误类型';

  @override
  String get byPersona => '按角色';

  @override
  String cacheDeleteError(String error) {
    return '删除缓存时出错：$error';
  }

  @override
  String get cacheDeleted => '图片缓存已被删除';

  @override
  String get cafeTerrace => '咖啡馆露台';

  @override
  String get calm => '冷静';

  @override
  String get cameraPermission => '相机权限';

  @override
  String get cameraPermissionDesc => '需要相机权限来拍摄个人资料照片。';

  @override
  String get canChangeInSettings => '您可以在设置中稍后更改此项';

  @override
  String get canMeetPreviousPersonas => '您可以再次遇到之前滑动过的角色！';

  @override
  String get cancel => '取消';

  @override
  String get changeProfilePhoto => '更改个人资料照片';

  @override
  String get chat => '聊天';

  @override
  String get chatEndedMessage => '聊天已结束';

  @override
  String get chatErrorDashboard => '聊天错误仪表板';

  @override
  String get chatErrorSentSuccessfully => '聊天错误已成功发送。';

  @override
  String get chatListTab => '聊天列表标签';

  @override
  String get chats => '聊天';

  @override
  String chattingWithPersonas(int count) {
    return '正在与 $count 个角色聊天';
  }

  @override
  String get checkInternetConnection => '请检查网络连接';

  @override
  String get checkingUserInfo => '正在检查用户信息';

  @override
  String get childrensDay => '儿童节';

  @override
  String get chinese => '中文';

  @override
  String get chooseOption => '请选择：';

  @override
  String get christmas => '圣诞节';

  @override
  String get close => '关闭';

  @override
  String get complete => '完成';

  @override
  String get completeSignup => '完成注册';

  @override
  String get confirm => '确认';

  @override
  String get connectingToServer => '正在连接到服务器';

  @override
  String get consultQualityMonitoring => '咨询质量监控';

  @override
  String get continueAsGuest => '以访客身份继续';

  @override
  String get continueButton => '继续';

  @override
  String get continueWithApple => '使用 Apple 继续';

  @override
  String get continueWithGoogle => '使用 Google 继续';

  @override
  String get conversationContinuity => '对话连续性';

  @override
  String get conversationContinuityDesc => '记住之前的对话并连接话题';

  @override
  String conversationWith(String name) {
    return '$name';
  }

  @override
  String get convertToMember => '注册';

  @override
  String get cooking => '烹饪';

  @override
  String get copyMessage => '复制消息';

  @override
  String get copyrightInfringement => '版权侵权';

  @override
  String get creatingAccount => '正在创建账户';

  @override
  String get crisisDetected => '检测到危机';

  @override
  String get culturalIssue => '文化问题';

  @override
  String get current => '当前';

  @override
  String get currentCacheSize => '当前缓存大小';

  @override
  String get currentLanguage => '当前语言';

  @override
  String get cycling => '骑自行车';

  @override
  String get dailyCare => '日常关怀';

  @override
  String get dailyCareDesc => '每日关怀消息，包括饮食、睡眠、健康';

  @override
  String get dailyChat => '每日聊天';

  @override
  String get dailyCheck => '每日检查';

  @override
  String get dailyConversation => '每日对话';

  @override
  String get dailyLimitDescription => '您已达到每日消息限制';

  @override
  String get dailyLimitTitle => '已达每日限制';

  @override
  String get darkMode => '深色模式';

  @override
  String get darkTheme => '深色模式';

  @override
  String get darkThemeDesc => '使用深色主题';

  @override
  String get dataCollection => '数据收集设置';

  @override
  String get datingAdvice => '约会建议';

  @override
  String get datingDescription => '我想分享深刻的想法，进行真诚的对话';

  @override
  String get dawn => '黎明';

  @override
  String get day => '天';

  @override
  String get dayAfterTomorrow => '后天';

  @override
  String daysAgo(int count, String formatted) {
    return '$count天前';
  }

  @override
  String daysRemaining(int days) {
    return '剩余$days天';
  }

  @override
  String get deepTalk => '深度交谈';

  @override
  String get delete => '删除';

  @override
  String get deleteAccount => '删除账户';

  @override
  String get deleteAccountConfirm => '确定要删除账号吗？此操作不可恢复。';

  @override
  String get deleteAccountWarning => '您确定要删除账户吗？';

  @override
  String get deleteCache => '删除缓存';

  @override
  String get deletingAccount => '正在删除账户...';

  @override
  String get depressed => '抑郁';

  @override
  String get describeError => '出了什么问题？';

  @override
  String get detailedReason => '详细原因';

  @override
  String get developRelationshipStep => '3. 发展关系：通过对话建立亲密感，发展特殊关系。';

  @override
  String get dinner => '晚餐';

  @override
  String get discardGuestData => '重新开始';

  @override
  String get discount20 => '享受20%优惠';

  @override
  String get discount30 => '享受30%优惠';

  @override
  String get discountAmount => '节省';

  @override
  String discountAmountValue(String amount) {
    return '节省₩$amount';
  }

  @override
  String get done => '完成';

  @override
  String get downloadingPersonaImages => '正在下载新的人物形象';

  @override
  String get edit => '编辑';

  @override
  String get editInfo => '编辑信息';

  @override
  String get editProfile => '编辑个人资料';

  @override
  String get effectSound => '音效';

  @override
  String get effectSoundDescription => '播放音效';

  @override
  String get email => '电子邮件';

  @override
  String get emailHint => 'example@email.com';

  @override
  String get emailLabel => '电子邮件';

  @override
  String get emailRequired => '电子邮件 *';

  @override
  String get emotionAnalysis => '情感分析';

  @override
  String get emotionAnalysisDesc => '分析情感以获得同理心回应';

  @override
  String get emotionAngry => '生气';

  @override
  String get emotionBasedEncounters => '基于情绪的相遇';

  @override
  String get emotionCool => '酷';

  @override
  String get emotionHappy => '快乐';

  @override
  String get emotionLove => '爱';

  @override
  String get emotionSad => '悲伤';

  @override
  String get emotionThinking => '思考';

  @override
  String get emotionalSupportDesc => '分享你的担忧，获得温暖的安慰';

  @override
  String get endChat => '结束聊天';

  @override
  String get endTutorial => '结束教程';

  @override
  String get endTutorialAndLogin => '结束教程并登录？';

  @override
  String get endTutorialMessage => '你想结束教程并登录吗？';

  @override
  String get english => '英语';

  @override
  String get enterBasicInfo => '输入您的基本信息';

  @override
  String get enterBasicInformation => '请输入基本信息';

  @override
  String get enterEmail => '请输入邮箱';

  @override
  String get enterNickname => '请输入昵称';

  @override
  String get enterPassword => '请输入密码';

  @override
  String get entertainmentAndFunDesc => '享受有趣的游戏和愉快的对话';

  @override
  String get entertainmentDescription => '我想进行有趣的对话，享受我的时光';

  @override
  String get entertainmentFun => '娱乐/乐趣';

  @override
  String get error => '错误';

  @override
  String get errorDescription => '错误描述';

  @override
  String get errorDescriptionHint => '例如，给出奇怪的回答，重复同样的事情，给出不合适的回应...';

  @override
  String get errorDetails => '错误详情';

  @override
  String get errorDetailsHint => '请详细说明问题所在';

  @override
  String get errorFrequency24h => '错误频率（过去24小时）';

  @override
  String get errorMessage => '错误信息：';

  @override
  String get errorOccurred => '发生错误';

  @override
  String get errorOccurredTryAgain => '发生错误。请再试一次。';

  @override
  String get errorSendingFailed => '发送错误失败';

  @override
  String get errorStats => '错误统计';

  @override
  String errorWithMessage(String error) {
    return '发生错误：$error';
  }

  @override
  String get evening => '晚上';

  @override
  String get excited => '兴奋';

  @override
  String get exit => '退出';

  @override
  String get exitApp => '退出应用';

  @override
  String get exitConfirmMessage => '您确定要退出应用吗？';

  @override
  String get expertPersona => '专家角色';

  @override
  String get expertiseScore => '专业评分';

  @override
  String get expired => '已过期';

  @override
  String get explainReportReason => '请详细说明举报原因';

  @override
  String get fashion => '时尚';

  @override
  String get female => '女性';

  @override
  String get filter => '筛选';

  @override
  String get firstOccurred => '首次发生：';

  @override
  String get followDeviceLanguage => '跟随设备语言设置';

  @override
  String get forenoon => '上午';

  @override
  String get forgotPassword => '忘记密码？';

  @override
  String get frequentlyAskedQuestions => '常见问题';

  @override
  String get friday => '星期五';

  @override
  String get friendshipDescription => '我想结识新朋友并进行交流';

  @override
  String get funChat => '有趣的聊天';

  @override
  String get galleryPermission => '相册权限';

  @override
  String get galleryPermissionDesc => '需要相册权限来选择个人资料照片。';

  @override
  String get gaming => '游戏';

  @override
  String get gender => '性别';

  @override
  String get genderNotSelectedInfo => '如果未选择性别，将显示所有性别的角色';

  @override
  String get genderOptional => '性别（可选）';

  @override
  String get genderPreferenceActive => '您可以见到所有性别的角色';

  @override
  String get genderPreferenceDisabled => '选择您的性别以启用仅对异性别选项';

  @override
  String get genderPreferenceInactive => '只会显示异性别角色';

  @override
  String get genderRequired => '性别 *';

  @override
  String get genderSelectionInfo => '如果未选择，您可以与所有性别的用户见面';

  @override
  String get generalPersona => '一般用户';

  @override
  String get goToSettings => '前往设置';

  @override
  String get permissionGuideAndroid =>
      'Settings > Apps > SONA > Permissions\nPlease allow photo permission';

  @override
  String get permissionGuideIOS =>
      'Settings > SONA > Photos\nPlease allow photo access';

  @override
  String get googleLoginCanceled => '谷歌登录已取消。';

  @override
  String get googleLoginError => 'Google登录失败';

  @override
  String get grantPermission => '继续';

  @override
  String get guest => '游客';

  @override
  String get guestDataMigration => '注册时您想保留当前聊天记录吗？';

  @override
  String get guestLimitReached => '游客试用已结束。';

  @override
  String get guestLoginPromptMessage => '登录以继续对话';

  @override
  String get guestMessageExhausted => '免费消息用尽';

  @override
  String guestMessageRemaining(int count) {
    return '剩余 $count 条游客消息';
  }

  @override
  String get guestModeBanner => '游客模式';

  @override
  String get guestModeDescription => '在不注册的情况下尝试 SONA';

  @override
  String get guestModeFailedMessage => '启动游客模式失败';

  @override
  String get guestModeLimitation => '游客模式下某些功能受限';

  @override
  String get guestModeTitle => '以游客身份尝试';

  @override
  String get guestModeWarning => '游客模式持续 24 小时，';

  @override
  String get guestModeWelcome => '正在进入游客模式';

  @override
  String get happy => '开心';

  @override
  String get hapticFeedback => '触觉反馈';

  @override
  String get harassmentBullying => '骚扰/欺凌';

  @override
  String get hateSpeech => '仇恨言论';

  @override
  String get heartDescription => '获得更多消息的爱心';

  @override
  String get heartInsufficient => '心数不足';

  @override
  String get heartInsufficientPleaseCharge => '心数不足。请充值心。';

  @override
  String get heartRequired => '需要 1 个心';

  @override
  String get heartUsageFailed => '使用心失败。';

  @override
  String get hearts => '爱心';

  @override
  String get hearts10 => '10 个心';

  @override
  String get hearts30 => '30 个心';

  @override
  String get hearts30Discount => '特卖';

  @override
  String get hearts50 => '50颗心';

  @override
  String get hearts50Discount => '特卖';

  @override
  String get helloEmoji => '你好！😊';

  @override
  String get help => '帮助';

  @override
  String get hideOriginalText => '隐藏原文';

  @override
  String get hobbySharing => '爱好分享';

  @override
  String get hobbyTalk => '爱好交流';

  @override
  String get hours24Ago => '24小时前';

  @override
  String hoursAgo(int count, String formatted) {
    return '$count小时前';
  }

  @override
  String get howToUse => '如何使用SONA';

  @override
  String get imageCacheManagement => '图片缓存管理';

  @override
  String get inappropriateContent => '不当内容';

  @override
  String get incorrect => '不正确';

  @override
  String get incorrectPassword => '密码错误';

  @override
  String get indonesian => '印尼语';

  @override
  String get inquiries => '查询';

  @override
  String get insufficientHearts => '爱心不足';

  @override
  String get interestSharing => '兴趣分享';

  @override
  String get interestSharingDesc => '发现并推荐共同兴趣';

  @override
  String get interests => '兴趣';

  @override
  String get invalidEmailFormat => '无效的电子邮件格式';

  @override
  String get invalidEmailFormatError => '请输入有效的电子邮件地址';

  @override
  String isTyping(String name) {
    return '$name 正在输入...';
  }

  @override
  String get japanese => '日语';

  @override
  String get joinDate => '加入日期';

  @override
  String get justNow => '刚刚';

  @override
  String get keepGuestData => '保留聊天记录';

  @override
  String get korean => '韩语';

  @override
  String get koreanLanguage => '韩语';

  @override
  String get language => '语言';

  @override
  String get languageDescription => 'AI将以您选择的语言回复';

  @override
  String get languageIndicator => '语言';

  @override
  String get languageSettings => '语言设置';

  @override
  String get lastOccurred => '最近发生：';

  @override
  String get lastUpdated => '最后更新';

  @override
  String get lateNight => '深夜';

  @override
  String get later => '稍后';

  @override
  String get laterButton => '稍后';

  @override
  String get leave => '离开';

  @override
  String get leaveChatConfirm => '确认离开此聊天吗？';

  @override
  String get leaveChatRoom => '离开聊天室';

  @override
  String get leaveChatTitle => '离开聊天';

  @override
  String get lifeAdvice => '生活建议';

  @override
  String get lightTalk => '轻松聊天';

  @override
  String get lightTheme => '明亮模式';

  @override
  String get lightThemeDesc => '使用明亮主题';

  @override
  String get loading => '加载中...';

  @override
  String get loadingData => '正在加载数据...';

  @override
  String get loadingProducts => '正在加载产品...';

  @override
  String get loadingProfile => '正在加载个人资料';

  @override
  String get login => '登录';

  @override
  String get loginButton => '登录';

  @override
  String get loginCancelled => '登录已取消';

  @override
  String get loginComplete => '登录完成';

  @override
  String get loginError => '登录失败。请重试。';

  @override
  String get loginFailed => '登录失败';

  @override
  String get loginFailedTryAgain => '登录失败。请重试。';

  @override
  String get loginRequired => '需要登录';

  @override
  String get loginRequiredForProfile => '需要登录才能查看个人资料';

  @override
  String get loginRequiredService => '使用此服务需要登录';

  @override
  String get loginRequiredTitle => '需要登录';

  @override
  String get loginSignup => '登录/注册';

  @override
  String get loginTab => '登录';

  @override
  String get loginTitle => '登录';

  @override
  String get loginWithApple => '使用Apple登录';

  @override
  String get loginWithGoogle => '使用Google登录';

  @override
  String get logout => '退出登录';

  @override
  String get logoutConfirm => '确定要退出吗？';

  @override
  String get lonelinessRelief => '缓解孤独';

  @override
  String get lonely => '孤独';

  @override
  String get lowQualityResponses => '低质量回复';

  @override
  String get lunch => '午餐';

  @override
  String get lunchtime => '午餐时间';

  @override
  String get mainErrorType => '主要错误类型';

  @override
  String get makeFriends => '交朋友';

  @override
  String get male => '男性';

  @override
  String get manageBlockedAIs => '管理已屏蔽的AI';

  @override
  String get managePersonaImageCache => '管理角色图像缓存';

  @override
  String get marketingAgree => '同意接收营销信息（可选）';

  @override
  String get marketingDescription => '您可以接收活动和优惠信息';

  @override
  String get matchPersonaStep => '1. 匹配角色：向左或向右滑动选择您喜欢的AI角色。';

  @override
  String get matchedPersonas => '匹配的角色';

  @override
  String get matchedSona => '匹配的SONA';

  @override
  String get matching => '匹配';

  @override
  String get matchingFailed => '匹配失败。';

  @override
  String get me => 'Me';

  @override
  String get meetAIPersonas => '遇见AI伴侣';

  @override
  String get meetNewPersonas => '认识新的角色';

  @override
  String get meetPersonas => '认识角色';

  @override
  String get memberBenefits => '注册时获得100+条消息和10颗心！';

  @override
  String get memoryAlbum => '回忆相册';

  @override
  String get memoryAlbumDesc => '自动保存和回忆特殊时刻';

  @override
  String get messageCopied => '消息已复制';

  @override
  String get messageDeleted => '消息已删除';

  @override
  String get messageLimitReset => '消息限制将在午夜重置';

  @override
  String get messageSendFailed => '发送消息失败。请再试一次。';

  @override
  String get messagesRemaining => '剩余消息';

  @override
  String minutesAgo(int count, String formatted) {
    return '$count分钟前';
  }

  @override
  String get missingTranslation => '缺少翻译';

  @override
  String get monday => '星期一';

  @override
  String get month => '月';

  @override
  String monthDay(String month, int day) {
    return '$month月$day日';
  }

  @override
  String get moreButton => '更多';

  @override
  String get morning => '早上';

  @override
  String get mostFrequentError => '最常见的错误';

  @override
  String get movies => '电影';

  @override
  String get multilingualChat => '多语言聊天';

  @override
  String get music => '音乐';

  @override
  String get myGenderSection => '我的性别（可选）';

  @override
  String get networkErrorOccurred => '网络错误发生。';

  @override
  String get newMessage => '新消息';

  @override
  String newMessageCount(int count) {
    return '$count 条新消息';
  }

  @override
  String get newMessageNotification => '新消息通知';

  @override
  String get newMessages => '新消息';

  @override
  String get newYear => '新年';

  @override
  String get next => '下一步';

  @override
  String get niceToMeetYou => '很高兴认识你！';

  @override
  String get nickname => '昵称';

  @override
  String get nicknameAlreadyUsed => '此昵称已被使用';

  @override
  String get nicknameHelperText => '3-10个字符';

  @override
  String get nicknameHint => '输入您的昵称';

  @override
  String get nicknameInUse => '此昵称已被使用';

  @override
  String get nicknameLabel => '昵称';

  @override
  String get nicknameLengthError => '昵称必须为3-10个字符';

  @override
  String get nicknamePlaceholder => '输入您的昵称';

  @override
  String get nicknameRequired => '昵称 *';

  @override
  String get night => '晚安';

  @override
  String get no => '否';

  @override
  String get noBlockedAIs => '没有被屏蔽的AI';

  @override
  String get noChatsYet => '还没有聊天';

  @override
  String get noConversationYet => '还没有对话';

  @override
  String get noErrorReports => '没有错误报告。';

  @override
  String get noImageAvailable => '没有可用的图片';

  @override
  String get noMatchedPersonas => '还没有匹配的角色';

  @override
  String get noMatchedSonas => '还没有匹配的SONA';

  @override
  String get noPersonasAvailable => '没有可用的人物。请再试一次。';

  @override
  String get noPersonasToSelect => '没有人物可供选择';

  @override
  String get noQualityIssues => '在过去一小时内没有质量问题 ✅';

  @override
  String get noQualityLogs => '还没有质量日志。';

  @override
  String get noTranslatedMessages => '没有要翻译的消息';

  @override
  String get notEnoughHearts => '心数不足';

  @override
  String notEnoughHeartsCount(int count) {
    return '心数不足。（当前: $count）';
  }

  @override
  String get notRegistered => '未注册';

  @override
  String get notSubscribed => '未订阅';

  @override
  String get notificationPermissionDesc => '需要通知权限来接收新消息。';

  @override
  String get notificationPermissionRequired => '需要通知权限';

  @override
  String get notificationSettings => '通知设置';

  @override
  String get notifications => '通知';

  @override
  String get occurrenceInfo => '事件信息：';

  @override
  String get olderChats => '较旧的';

  @override
  String get onlyOppositeGenderNote => '如果未勾选，将只显示异性人物';

  @override
  String get openSettings => '打开设置';

  @override
  String get optional => '可选';

  @override
  String get or => '或';

  @override
  String get originalPrice => '原价';

  @override
  String get originalText => '原文';

  @override
  String get other => '其他';

  @override
  String get otherError => '其他错误';

  @override
  String get others => '其他';

  @override
  String get ownedHearts => '拥有的心数';

  @override
  String get parentsDay => '父母节';

  @override
  String get password => '密码';

  @override
  String get passwordConfirmation => '输入密码以确认';

  @override
  String get passwordConfirmationDesc => '请重新输入您的密码以删除账户。';

  @override
  String get passwordHint => '输入密码（6位以上）';

  @override
  String get passwordLabel => '密码';

  @override
  String get passwordRequired => '密码 *';

  @override
  String get passwordResetEmailPrompt => '请输入您的电子邮件以重置密码';

  @override
  String get passwordResetEmailSent => '密码重置邮件已发送。请检查您的电子邮件。';

  @override
  String get passwordText => '密码';

  @override
  String get passwordTooShort => '密码太短';

  @override
  String get permissionDenied => '权限被拒绝';

  @override
  String permissionDeniedMessage(String permissionName) {
    return '$permissionName 权限被拒绝。\\n请在设置中允许该权限。';
  }

  @override
  String get permissionDeniedTryLater => '权限被拒绝。请稍后再试。';

  @override
  String get permissionRequired => '需要权限';

  @override
  String get personaGenderSection => '角色性别偏好';

  @override
  String get personaQualityStats => '个性质量统计';

  @override
  String get personalInfoExposure => '个人信息暴露';

  @override
  String get personality => '性格';

  @override
  String get pets => '宠物';

  @override
  String get photo => '照片';

  @override
  String get photography => '摄影';

  @override
  String get picnic => '野餐';

  @override
  String get preferenceSettings => '偏好设置';

  @override
  String get preferredLanguage => '首选语言';

  @override
  String get preparingForSleep => '准备睡觉';

  @override
  String get preparingNewMeeting => '准备新会议';

  @override
  String get preparingPersonaImages => '准备个性图像';

  @override
  String get preparingPersonas => '准备个性';

  @override
  String get preview => '预览';

  @override
  String get previous => '上一步';

  @override
  String get privacy => '隐私';

  @override
  String get privacyPolicy => '隐私政策';

  @override
  String get privacyPolicyAgreement => '请同意隐私政策';

  @override
  String get privacySection1Content =>
      '我们致力于保护您的隐私。本隐私政策解释了我们在您使用我们的服务时如何收集、使用和保护您的信息。';

  @override
  String get privacySection1Title => '1. 个人信息的收集和使用目的';

  @override
  String get privacySection2Content =>
      '我们收集您直接提供给我们的信息，例如当您创建账户、更新个人资料或使用我们的服务时。';

  @override
  String get privacySection2Title => '我们收集的信息';

  @override
  String get privacySection3Content => '我们使用收集的信息来提供、维护和改善我们的服务，并与您沟通。';

  @override
  String get privacySection3Title => '3. 个人信息的保留和使用期限';

  @override
  String get privacySection4Content => '未经您的同意，我们不会将您的个人信息出售、交易或以其他方式转让给第三方。';

  @override
  String get privacySection4Title => '4. 向第三方提供个人信息';

  @override
  String get privacySection5Content =>
      '我们实施适当的安全措施，以保护您的个人信息免受未经授权的访问、修改、披露或销毁。';

  @override
  String get privacySection5Title => '5. 个人信息的技术保护措施';

  @override
  String get privacySection6Content => '我们会在提供服务和遵守法律义务所需的时间内保留个人信息。';

  @override
  String get privacySection6Title => '6. 用户权利';

  @override
  String get privacySection7Content => '您有权随时通过账户设置访问、更新或删除您的个人信息。';

  @override
  String get privacySection7Title => '您的权利';

  @override
  String get privacySection8Content =>
      '如果您对本隐私政策有任何疑问，请通过 support@sona.com 联系我们。';

  @override
  String get privacySection8Title => '联系我们';

  @override
  String get privacySettings => '隐私设置';

  @override
  String get privacySettingsInfo => '禁用单个功能将使这些服务不可用';

  @override
  String get privacySettingsScreen => '隐私设置';

  @override
  String get problemMessage => '问题';

  @override
  String get problemOccurred => '发生问题';

  @override
  String get profile => '个人资料';

  @override
  String get profileEdit => '编辑个人资料';

  @override
  String get profileEditLoginRequiredMessage => '编辑个人资料需要登录。您想去登录界面吗？';

  @override
  String get profileInfo => '个人资料信息';

  @override
  String get profileInfoDescription => '请输入您的个人资料照片和基本信息';

  @override
  String get profileNav => '个人资料';

  @override
  String get profilePhoto => '个人照片';

  @override
  String get profilePhotoAndInfo => '请输入个人资料照片和基本信息';

  @override
  String get profilePhotoUpdateFailed => '更新个人资料照片失败';

  @override
  String get profilePhotoUpdated => '个人资料照片已更新';

  @override
  String get profileSettings => '个人资料设置';

  @override
  String get profileSetup => '设置个人资料';

  @override
  String get profileUpdateFailed => '更新个人资料失败';

  @override
  String get profileUpdated => '个人资料已更新';

  @override
  String get purchaseAndRefundPolicy => '购买与退款政策';

  @override
  String get purchaseButton => '购买';

  @override
  String get purchaseConfirm => '购买确认';

  @override
  String purchaseConfirmContent(String product, String price) {
    return '以$price购买$product吗？';
  }

  @override
  String purchaseConfirmMessage(
      String title, String price, String description) {
    return '确认以$price购买$title吗？$description';
  }

  @override
  String get purchaseFailed => '购买失败';

  @override
  String get purchaseHeartsOnly => '购买心心';

  @override
  String get purchaseMoreHearts => '购买心心以继续对话';

  @override
  String get purchasePending => '购买待处理...';

  @override
  String get purchasePolicy => '购买政策';

  @override
  String get purchaseSection1Content => '我们接受多种支付方式，包括信用卡和数字钱包。';

  @override
  String get purchaseSection1Title => '支付方式';

  @override
  String get purchaseSection2Content => '如果您在购买后未使用所购项目，可以在14天内申请退款。';

  @override
  String get purchaseSection2Title => '退款政策';

  @override
  String get purchaseSection3Content => '您可以随时通过账户设置取消订阅。';

  @override
  String get purchaseSection3Title => '取消';

  @override
  String get purchaseSection4Content => '通过购买，您同意我们的使用条款和服务协议。';

  @override
  String get purchaseSection4Title => '使用条款';

  @override
  String get purchaseSection5Content => '如有与购买相关的问题，请联系支持团队。';

  @override
  String get purchaseSection5Title => '联系支持';

  @override
  String get purchaseSection6Content => '所有购买均受我们的标准条款和条件约束。';

  @override
  String get purchaseSection6Title => '6. 查询';

  @override
  String get pushNotifications => '推送通知';

  @override
  String get reading => '阅读';

  @override
  String get realtimeQualityLog => '实时质量日志';

  @override
  String get recentConversation => '最近对话：';

  @override
  String get recentLoginRequired => '请重新登录以确保安全';

  @override
  String get referrerEmail => '推荐人邮箱';

  @override
  String get referrerEmailHelper => '可选：推荐您的人的邮箱';

  @override
  String get referrerEmailLabel => '推荐人邮箱（可选）';

  @override
  String get refresh => '刷新';

  @override
  String refreshComplete(int count) {
    return '刷新完成！$count 个匹配的个性';
  }

  @override
  String get refreshFailed => '刷新失败';

  @override
  String get refreshingChatList => '正在刷新聊天列表...';

  @override
  String get relatedFAQ => '相关常见问题';

  @override
  String get report => '举报';

  @override
  String get reportAI => '举报';

  @override
  String get reportAIDescription => '如果AI让您感到不适，请描述问题。';

  @override
  String get reportAITitle => '举报AI对话';

  @override
  String get reportAndBlock => '举报与屏蔽';

  @override
  String get reportAndBlockDescription => '您可以举报并屏蔽该AI的不当行为';

  @override
  String get reportChatError => '举报聊天错误';

  @override
  String reportError(String error) {
    return '举报时发生错误：$error';
  }

  @override
  String get reportFailed => '举报失败';

  @override
  String get reportSubmitted => '举报已提交。我们将进行审核并采取措施。';

  @override
  String get reportSubmittedSuccess => '您的举报已提交。谢谢！';

  @override
  String get requestLimit => '请求限制';

  @override
  String get required => '必需';

  @override
  String get requiredTermsAgreement => '请同意条款';

  @override
  String get restartConversation => '重启对话';

  @override
  String restartConversationQuestion(String name) {
    return '您想要与 $name 重启对话吗？';
  }

  @override
  String restartConversationWithName(String name) {
    return '正在与 $name 重启对话！';
  }

  @override
  String get retry => '重试';

  @override
  String get retryButton => '重试';

  @override
  String get sad => '难过';

  @override
  String get saturday => '星期六';

  @override
  String get save => '保存';

  @override
  String get search => '搜索';

  @override
  String get searchFAQ => '搜索常见问题...';

  @override
  String get searchResults => '搜索结果';

  @override
  String get selectEmotion => '选择情感';

  @override
  String get selectErrorType => '选择错误类型';

  @override
  String get selectFeeling => '选择心情';

  @override
  String get selectGender => '选择性别';

  @override
  String get selectInterests => '请选择您的兴趣（至少 1 个）';

  @override
  String get selectLanguage => '选择语言';

  @override
  String get selectPersona => '选择角色';

  @override
  String get selectPersonaPlease => '请选择一个角色。';

  @override
  String get selectPreferredMbti => '如果您偏好特定 MBTI 类型的角色，请选择';

  @override
  String get selectProblematicMessage => '选择问题消息（可选）';

  @override
  String get chatErrorAnalysisInfo => '正在分析最近10条对话。';

  @override
  String get whatWasAwkward => '哪些地方让您感到不自然？';

  @override
  String get errorExampleHint => '例如：不自然的说话方式（~喵的语尾）...';

  @override
  String get selectReportReason => '选择举报原因';

  @override
  String get selectTheme => '选择主题';

  @override
  String get selectTranslationError => '请选择一条翻译错误的消息';

  @override
  String get selectUsagePurpose => '请选择您使用 SONA 的目的';

  @override
  String get selfIntroduction => '自我介绍（可选）';

  @override
  String get selfIntroductionHint => '写一段关于你自己的简短介绍';

  @override
  String get send => '发送';

  @override
  String get sendChatError => '发送聊天错误';

  @override
  String get sendFirstMessage => '发送第一条消息';

  @override
  String get sendReport => '发送举报';

  @override
  String get sendingEmail => '正在发送邮件...';

  @override
  String get seoul => '首尔';

  @override
  String get serverErrorDashboard => '服务器错误';

  @override
  String get serviceTermsAgreement => '请同意服务条款';

  @override
  String get sessionExpired => '会话已过期';

  @override
  String get setAppInterfaceLanguage => '设置应用界面语言';

  @override
  String get setNow => '立即设置';

  @override
  String get settings => '设置';

  @override
  String get sexualContent => '性内容';

  @override
  String get showAllGenderPersonas => '显示所有性别角色';

  @override
  String get showAllGendersOption => '显示所有性别';

  @override
  String get showOppositeGenderOnly => '如果未勾选，则只显示异性角色';

  @override
  String get showOriginalText => '显示原文';

  @override
  String get signUp => '注册';

  @override
  String get signUpFromGuest => '立即注册以访问所有功能！';

  @override
  String get signup => '注册';

  @override
  String get signupComplete => '注册完成';

  @override
  String get signupTab => '注册';

  @override
  String get simpleInfoRequired => '需要简单信息';

  @override
  String get skip => '跳过';

  @override
  String get sonaFriend => 'SONA 朋友';

  @override
  String get sonaPrivacyPolicy => 'SONA 隐私政策';

  @override
  String get sonaPurchasePolicy => 'SONA 购买政策';

  @override
  String get sonaTermsOfService => 'SONA 服务条款';

  @override
  String get sonaUsagePurpose => '请选择您使用 SONA 的目的';

  @override
  String get sorryNotHelpful => '对不起，这没有帮助';

  @override
  String get sort => '排序';

  @override
  String get soundSettings => '声音设置';

  @override
  String get spamAdvertising => '垃圾信息/广告';

  @override
  String get spanish => '西班牙语';

  @override
  String get specialRelationshipDesc => '彼此理解，建立深厚的联系';

  @override
  String get sports => '体育';

  @override
  String get spring => '春天';

  @override
  String get startChat => '开始聊天';

  @override
  String get startChatButton => '开始聊天';

  @override
  String get startConversation => '开始对话';

  @override
  String get startConversationLikeAFriend => '像朋友一样与 Sona 开始对话';

  @override
  String get startConversationStep => '2. 开始对话：与匹配的角色自由聊天。';

  @override
  String get startConversationWithSona => '像朋友一样与 Sona 开始聊天！';

  @override
  String get startWithEmail => '使用邮箱开始';

  @override
  String get startWithGoogle => '使用Google开始';

  @override
  String get startingApp => '启动应用';

  @override
  String get storageManagement => '存储管理';

  @override
  String get store => '商店';

  @override
  String get storeConnectionError => '无法连接到商店';

  @override
  String get storeLoginRequiredMessage => '使用商店需要登录。您想去登录界面吗？';

  @override
  String get storeNotAvailable => '商店不可用';

  @override
  String get storyEvent => '故事事件';

  @override
  String get stressed => '压力大';

  @override
  String get submitReport => '提交报告';

  @override
  String get subscriptionStatus => '订阅状态';

  @override
  String get subtleVibrationOnTouch => '触摸时轻微震动';

  @override
  String get summer => '夏天';

  @override
  String get sunday => '星期天';

  @override
  String get swipeAnyDirection => '向任意方向滑动';

  @override
  String get swipeDownToClose => '向下滑动以关闭';

  @override
  String get systemTheme => '跟随系统';

  @override
  String get systemThemeDesc => '根据设备的深色模式设置自动更改';

  @override
  String get tapBottomForDetails => '点击底部查看详情';

  @override
  String get tapForDetails => '点击底部区域查看详情';

  @override
  String get tapToSwipePhotos => '点击以滑动照片';

  @override
  String get teachersDay => '教师节';

  @override
  String get technicalError => '技术错误';

  @override
  String get technology => '技术';

  @override
  String get terms => '服务条款';

  @override
  String get termsAgreement => '条款协议';

  @override
  String get termsAgreementDescription => '请同意使用服务的条款';

  @override
  String get termsOfService => '服务条款';

  @override
  String get termsSection10Content => '我们保留随时修改这些条款的权利，并通知用户。';

  @override
  String get termsSection10Title => '第10条（争议解决）';

  @override
  String get termsSection11Content => '这些条款应受我们运营所在司法管辖区的法律管辖。';

  @override
  String get termsSection11Title => '第11条（人工智能服务特别条款）';

  @override
  String get termsSection12Content => '如果这些条款的任何条款被认为不可执行，其余条款将继续有效。';

  @override
  String get termsSection12Title => '第12条（数据收集与使用）';

  @override
  String get termsSection1Content =>
      '本条款旨在定义SONA（以下简称“公司”）与用户之间关于使用公司提供的人工智能角色对话匹配服务（以下简称“服务”）的权利、义务和责任。';

  @override
  String get termsSection1Title => '第1条（目的）';

  @override
  String get termsSection2Content => '使用我们的服务即表示您同意受这些服务条款和我们的隐私政策的约束。';

  @override
  String get termsSection2Title => '第2条（定义）';

  @override
  String get termsSection3Content => '您必须年满 13 岁才能使用我们的服务。';

  @override
  String get termsSection3Title => '第三条（条款的生效与修改）';

  @override
  String get termsSection4Content => '您有责任维护您的账户和密码的机密性。';

  @override
  String get termsSection4Title => '第四条（服务的提供）';

  @override
  String get termsSection5Content => '您同意不将我们的服务用于任何非法或未经授权的目的。';

  @override
  String get termsSection5Title => '第五条（会员注册）';

  @override
  String get termsSection6Content => '我们保留因违反这些条款而终止或暂停您的账户的权利。';

  @override
  String get termsSection6Title => '第六条（用户义务）';

  @override
  String get termsSection7Content =>
      '如果用户违反这些条款的义务或干扰正常的服务运营，公司可能会通过警告、临时暂停或永久暂停逐步限制服务使用。';

  @override
  String get termsSection7Title => '第七条（服务使用限制）';

  @override
  String get termsSection8Content => '我们不对因您使用我们的服务而产生的任何间接、附带或后果性损害负责。';

  @override
  String get termsSection8Title => '第八条（服务中断）';

  @override
  String get termsSection9Content => '我们服务中所有可用的内容和材料均受知识产权保护。';

  @override
  String get termsSection9Title => '第九条（免责声明）';

  @override
  String get termsSupplementary => '附加条款';

  @override
  String get thai => '泰语';

  @override
  String get thanksFeedback => '感谢您的反馈！';

  @override
  String get theme => '主题';

  @override
  String get themeDescription => '您可以根据自己的喜好自定义应用外观';

  @override
  String get themeSettings => '主题设置';

  @override
  String get thursday => '星期四';

  @override
  String get timeout => '超时';

  @override
  String get tired => '疲惫';

  @override
  String get today => '今天';

  @override
  String get todayChats => '今天';

  @override
  String get todayText => '今天';

  @override
  String get tomorrowText => '明天';

  @override
  String get totalConsultSessions => '总咨询会话数';

  @override
  String get totalErrorCount => '总错误次数';

  @override
  String get totalLikes => '总点赞数';

  @override
  String totalOccurrences(Object count) {
    return '总计 $count 次';
  }

  @override
  String get totalResponses => '总回复数';

  @override
  String get translatedFrom => '翻译自';

  @override
  String get translatedText => '翻译';

  @override
  String get translationError => '翻译错误';

  @override
  String get translationErrorDescription => '请报告不正确的翻译或生硬的表达';

  @override
  String get translationErrorReported => '翻译错误已报告。谢谢！';

  @override
  String get translationNote => '※ AI 翻译可能不完美';

  @override
  String get translationQuality => '翻译质量';

  @override
  String get translationSettings => '翻译设置';

  @override
  String get travel => '旅行';

  @override
  String get tuesday => '星期二';

  @override
  String get tutorialAccount => '教程账户';

  @override
  String get tutorialWelcomeDescription => '与AI角色建立特殊关系。';

  @override
  String get tutorialWelcomeTitle => '欢迎来到SONA！';

  @override
  String get typeMessage => '输入消息...';

  @override
  String get unblock => '取消屏蔽';

  @override
  String get unblockFailed => '解封失败';

  @override
  String unblockPersonaConfirm(String name) {
    return '确认解封 $name？';
  }

  @override
  String get unblockedSuccessfully => '解封成功';

  @override
  String get unexpectedLoginError => '登录时发生意外错误';

  @override
  String get unknown => '未知';

  @override
  String get unknownError => '未知错误';

  @override
  String get unlimitedMessages => '无限消息';

  @override
  String get unsendMessage => '撤回消息';

  @override
  String get usagePurpose => '使用目的';

  @override
  String get useOneHeart => '使用 1 个心';

  @override
  String get useSystemLanguage => '使用系统语言';

  @override
  String get user => '用户：';

  @override
  String get userMessage => '用户消息：';

  @override
  String get userNotFound => '用户未找到';

  @override
  String get valentinesDay => '情人节';

  @override
  String get verifyingAuth => '正在验证身份';

  @override
  String get version => '版本';

  @override
  String get vietnamese => '越南语';

  @override
  String get violentContent => '暴力内容';

  @override
  String get voiceMessage => '语音消息';

  @override
  String waitingForChat(String name) {
    return '$name 正在等待聊天。';
  }

  @override
  String get walk => '散步';

  @override
  String get wasHelpful => '这有帮助吗？';

  @override
  String get weatherClear => '晴天';

  @override
  String get weatherCloudy => '多云';

  @override
  String get weatherContext => '天气背景';

  @override
  String get weatherContextDesc => '根据天气提供对话背景';

  @override
  String get weatherDrizzle => '毛毛雨';

  @override
  String get weatherFog => '雾';

  @override
  String get weatherMist => '霭';

  @override
  String get weatherRain => '雨';

  @override
  String get weatherRainy => '下雨';

  @override
  String get weatherSnow => '雪';

  @override
  String get weatherSnowy => '下雪';

  @override
  String get weatherThunderstorm => '雷暴';

  @override
  String get wednesday => '星期三';

  @override
  String get weekdays => '日,一,二,三,四,五,六';

  @override
  String get welcomeMessage => '欢迎💕';

  @override
  String get whatTopicsToTalk => '你想聊些什么话题？（可选）';

  @override
  String get whiteDay => '白色情人节';

  @override
  String get winter => '冬季';

  @override
  String get wrongTranslation => '错误翻译';

  @override
  String get year => '年';

  @override
  String get yearEnd => '年底';

  @override
  String get yes => '是';

  @override
  String get yesterday => '昨天';

  @override
  String get yesterdayChats => '昨天的聊天记录';

  @override
  String get you => '你';

  @override
  String get loadingPersonaData => '正在加载角色数据';

  @override
  String get checkingMatchedPersonas => '正在检查匹配的角色';

  @override
  String get preparingImages => '正在准备图片';

  @override
  String get finalPreparation => '最后准备';

  @override
  String get editProfileSubtitle => '编辑性别、生日和自我介绍';

  @override
  String get systemThemeName => '系统';

  @override
  String get lightThemeName => '浅色';

  @override
  String get darkThemeName => '深色';

  @override
  String get alwaysShowTranslationOn => 'Always Show Translation';

  @override
  String get alwaysShowTranslationOff => 'Hide Auto Translation';

  @override
  String get translationErrorAnalysisInfo => '我们将分析所选消息及其翻译。';

  @override
  String get whatWasWrongWithTranslation => '翻译哪里出错了？';

  @override
  String get translationErrorHint => '例如：意思错误、表达不自然、上下文错误...';

  @override
  String get pleaseSelectMessage => '请先选择一条消息';

  @override
  String get myPersonas => '我的角色';

  @override
  String get createPersona => '创建角色';

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
  String get mbtiQuestion => '性格问题';

  @override
  String get mbtiComplete => '性格测试完成！';

  @override
  String get mbtiTest => 'MBTI测试';

  @override
  String get mbtiStepDescription => '您希望角色拥有什么样的性格？请回答问题来决定角色的性格。';

  @override
  String get startTest => '开始测试';

  @override
  String get personalitySettings => 'Personality Settings';

  @override
  String get speechStyle => '说话风格';

  @override
  String get conversationStyle => '对话风格';

  @override
  String get shareWithCommunity => 'Share with Community';

  @override
  String get shareDescription => '批准后，其他用户也可以使用这个角色';

  @override
  String get sharePersona => 'Share Persona';

  @override
  String get willBeSharedAfterApproval => 'Will be shared after admin approval';

  @override
  String get privatePersonaDescription => 'Only you can see this persona';

  @override
  String get create => 'Create';

  @override
  String get personaCreated => 'Persona created successfully!';

  @override
  String get createFailed => 'Failed to create persona';

  @override
  String get pendingApproval => '待审核';

  @override
  String get approved => '已批准';

  @override
  String get privatePersona => 'Private';

  @override
  String get noPersonasYet => 'No Personas Yet';

  @override
  String get createYourFirstPersona =>
      'Create your first persona and start your journey';

  @override
  String get deletePersona => '删除角色';

  @override
  String get deletePersonaConfirm => '确定要删除这个角色吗？';

  @override
  String get personaDeleted => '角色已删除';

  @override
  String get deleteFailed => '删除失败';

  @override
  String get personaLimitReached => 'You have reached the limit of 3 personas';

  @override
  String get personaName => '名字';

  @override
  String get personaAge => '年龄';

  @override
  String get personaDescription => '介绍';

  @override
  String get personaNameHint => 'Enter persona name';

  @override
  String get personaDescriptionHint => 'Describe the persona';

  @override
  String get loginRequiredContent => 'Please log in to continue';

  @override
  String get reportErrorButton => 'Report Error';

  @override
  String get speechStyleFriendly => '友好';

  @override
  String get speechStylePolite => '礼貌';

  @override
  String get speechStyleChic => '时尚';

  @override
  String get speechStyleLively => '活泼';

  @override
  String get conversationStyleTalkative => '健谈';

  @override
  String get conversationStyleQuiet => '安静';

  @override
  String get conversationStyleEmpathetic => '有同理心';

  @override
  String get conversationStyleLogical => '逻辑性';

  @override
  String get interestMusic => '音乐';

  @override
  String get interestMovies => '电影';

  @override
  String get interestReading => '阅读';

  @override
  String get interestTravel => '旅行';

  @override
  String get interestExercise => '运动';

  @override
  String get interestGaming => '游戏';

  @override
  String get interestCooking => '烹饪';

  @override
  String get interestFashion => '时尚';

  @override
  String get interestArt => '艺术';

  @override
  String get interestPhotography => '摄影';

  @override
  String get interestTechnology => '科技';

  @override
  String get interestScience => '科学';

  @override
  String get interestHistory => '历史';

  @override
  String get interestPhilosophy => '哲学';

  @override
  String get interestPolitics => '政治';

  @override
  String get interestEconomy => '经济';

  @override
  String get interestSports => '体育';

  @override
  String get interestAnimation => '动画';

  @override
  String get interestKpop => 'K-POP';

  @override
  String get interestDrama => '电视剧';

  @override
  String get imageOptionalR2 => '图片是可选的。只有在配置了R2后才会上传。';

  @override
  String get networkErrorCheckConnection => '网络错误：请检查您的网络连接';

  @override
  String get maxFiveItems => '最多5个';

  @override
  String get mbtiQuestion1 => '遇到新朋友时';

  @override
  String get mbtiQuestion1OptionA => '你好...很高兴认识你';

  @override
  String get mbtiQuestion1OptionB => '哦！很高兴认识你！我是○○！';

  @override
  String get mbtiQuestion2 => '了解情况时';

  @override
  String get mbtiQuestion2OptionA => '具体发生了什么？怎么回事？';

  @override
  String get mbtiQuestion2OptionB => '我大概了解是什么感觉';

  @override
  String get mbtiQuestion3 => '做决定时';

  @override
  String get mbtiQuestion3OptionA => '从逻辑上考虑...';

  @override
  String get mbtiQuestion3OptionB => '你的感受更重要';

  @override
  String get mbtiQuestion4 => '约定时间时';

  @override
  String get mbtiQuestion4OptionA => '我们○点○分准时见面';

  @override
  String get mbtiQuestion4OptionB => '那个时候见就行～';

  @override
  String get meetNewSona => '认识新的Sona！';

  @override
  String ageAndPersonality(String age, String personality) {
    return '$age岁 • $personality';
  }

  @override
  String get guestLabel => '访客';

  @override
  String get developerOptions => '开发者选项';

  @override
  String get reengagementNotificationTest => '重新参与通知测试';

  @override
  String get churnRiskNotificationTest => '流失风险通知测试';

  @override
  String get selectChurnRisk => '选择流失风险:';

  @override
  String get sevenDaysInactive => '7天以上未登录（风险90%）';

  @override
  String get threeDaysInactive => '3天未登录（风险70%）';

  @override
  String get oneDayInactive => '1天未登录（风险50%）';

  @override
  String get generalNotification => '一般通知（风险30%）';

  @override
  String get noActivePersonas => '没有活跃的角色';

  @override
  String percentDiscount(String percent) {
    return '$percent%折扣';
  }

  @override
  String imageLoadProgress(String loaded, String total) {
    return '$loaded / $total 图片';
  }

  @override
  String get checkingNewImages => '检查新图片中...';

  @override
  String get findingNewPersonas => '寻找新角色中...';

  @override
  String get superLikeMatch => '超级喜欢匹配！';

  @override
  String get matchSuccess => '匹配成功！';

  @override
  String restartingConversationWith(String name) {
    return '与$name\\n重新开始对话！';
  }

  @override
  String personaLikesYou(String name) {
    return '$name\\n特别喜欢你！';
  }

  @override
  String matchedWithPersona(String name) {
    return '与$name匹配成功！';
  }

  @override
  String get previousConversationKept => '之前的对话已保留。继续你们的聊天吧！';

  @override
  String get specialConnectionStart => '特别缘分的开始！Sona在等你';

  @override
  String get preparingProfilePicture => '准备个人资料图片中...';

  @override
  String get newSonaComingSoon => '新的Sona即将推出！';

  @override
  String get superLikeDescription => '超级喜欢（直接恋爱阶段）';

  @override
  String get checkingMorePersonas => '检查更多角色中...';

  @override
  String get allFilter => '全部';

  @override
  String get published => '已发布';

  @override
  String yearsOld(String age) {
    return '$age岁';
  }

  @override
  String startConversationWithPersona(String name) {
    return '与$name开始对话？';
  }

  @override
  String get failedToStartConversation => '开始对话失败';

  @override
  String get cannotDeleteApprovedPersona => '无法删除已批准的角色';

  @override
  String get deletePersonaWithConversation => '此角色有进行中的对话。确定删除吗？\\n聊天室也将被删除。';

  @override
  String get sharedPersonaDeleteWarning => '这是共享角色。只会从您的列表中删除。';

  @override
  String get firebasePermissionError => 'Firebase权限错误：请联系管理员';

  @override
  String get checkingPersonaInfo => '检查角色信息中...';

  @override
  String get personaCacheDescription => '角色图片已保存在设备上，可快速加载。';

  @override
  String get cacheDeleteWarning => '删除缓存将需要重新下载图片。';

  @override
  String get blockedAIDescription => '被屏蔽的AI将从匹配和聊天列表中排除。';

  @override
  String searchResultsCount(String count) {
    return '搜索结果: $count个';
  }

  @override
  String questionsCount(String count) {
    return '$count个问题';
  }

  @override
  String get readyToChat => '准备好聊天了！';

  @override
  String preparingPersonasCount(String count) {
    return '准备角色中... ($count)';
  }

  @override
  String get loggingIn => '登录中...';

  @override
  String languageChangedTo(String language) {
    return '语言已更改为$language';
  }

  @override
  String get englishLanguage => '英语';

  @override
  String get japaneseLanguage => '日语';

  @override
  String get chineseLanguage => '中文';

  @override
  String get thaiLanguage => '泰语';

  @override
  String get vietnameseLanguage => '越南语';

  @override
  String get indonesianLanguage => '印尼语';

  @override
  String get tagalogLanguage => '他加禄语';

  @override
  String get spanishLanguage => '西班牙语';

  @override
  String get frenchLanguage => '法语';

  @override
  String get germanLanguage => '德语';

  @override
  String get russianLanguage => '俄语';

  @override
  String get portugueseLanguage => '葡萄牙语';

  @override
  String get italianLanguage => '意大利语';

  @override
  String get dutchLanguage => '荷兰语';

  @override
  String get swedishLanguage => '瑞典语';

  @override
  String get polishLanguage => '波兰语';

  @override
  String get turkishLanguage => '土耳其语';

  @override
  String get arabicLanguage => '阿拉伯语';

  @override
  String get hindiLanguage => '印地语';

  @override
  String get urduLanguage => '乌尔都语';

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
