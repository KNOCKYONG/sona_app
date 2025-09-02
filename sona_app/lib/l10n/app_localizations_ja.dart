// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get about => 'アプリについて';

  @override
  String get accountAndProfile => 'アカウント＆プロフィール情報';

  @override
  String get accountDeletedSuccess => 'アカウントが正常に削除されました';

  @override
  String get accountDeletionContent => '本当にアカウントを削除しますか？\nこの操作は取り消せません。';

  @override
  String get accountDeletionError => 'アカウント削除中にエラーが発生しました。';

  @override
  String get accountDeletionInfo => 'アカウント削除のご案内';

  @override
  String get accountDeletionTitle => 'アカウント削除';

  @override
  String get accountDeletionWarning1 => '警告：この操作は元に戻せません';

  @override
  String get accountDeletionWarning2 => 'すべてのデータが永久に削除されます';

  @override
  String get accountDeletionWarning3 => 'すべての会話履歴にアクセスできなくなります';

  @override
  String get accountDeletionWarning4 => '購入したすべてのコンテンツが含まれます';

  @override
  String get accountManagement => 'アカウント管理';

  @override
  String get adaptiveConversationDesc => 'あなたの会話スタイルに合わせて適応します';

  @override
  String get afternoon => '午後';

  @override
  String get afternoonFatigue => '午後の疲れ';

  @override
  String get ageConfirmation => '私は14歳以上であり、上記を確認しました。';

  @override
  String ageRange(int min, int max) {
    return '$min〜$max歳';
  }

  @override
  String get ageUnit => '歳';

  @override
  String get agreeToTerms => '利用規約に同意します';

  @override
  String get aiDatingQuestion => 'AIとの特別な日常を\n自分だけのペルソナに出会いましょう。';

  @override
  String get aiPersonaPreferenceDescription => 'AIペルソナマッチングの設定をしてください';

  @override
  String get all => 'すべて';

  @override
  String get allAgree => 'すべてに同意';

  @override
  String get allFeaturesRequired => '※ すべての機能はサービス提供に必要です';

  @override
  String get allPersonas => 'すべてのペルソナ';

  @override
  String get allPersonasMatched => 'すべてのペルソナとマッチしました！チャットを始めましょう。';

  @override
  String get allowPermission => '続ける';

  @override
  String alreadyChattingWith(String name) {
    return 'すでに$nameとチャット中です！';
  }

  @override
  String get alsoBlockThisAI => 'このAIもブロックする';

  @override
  String get angry => '怒っている';

  @override
  String get anonymousLogin => '匿名ログイン';

  @override
  String get anxious => '不安';

  @override
  String get apiKeyError => 'APIキーエラー';

  @override
  String get appName => 'SONA';

  @override
  String get appTagline => 'あなたのAIコンパニオン';

  @override
  String get appleLoginCanceled => 'Appleログインがキャンセルされました。\nもう一度お試しください。';

  @override
  String get appleLoginError => 'Appleログイン中にエラーが発生しました。';

  @override
  String get art => 'アート';

  @override
  String get authError => '認証エラー';

  @override
  String get autoTranslate => '自動翻訳';

  @override
  String get autumn => '秋';

  @override
  String get averageQuality => '平均品質';

  @override
  String get averageQualityScore => '平均品質スコア';

  @override
  String get awkwardExpression => '不自然な表現';

  @override
  String get backButton => '戻る';

  @override
  String get basicInfo => '基本情報';

  @override
  String get basicInfoDescription => 'アカウント作成のため基本情報を入力してください';

  @override
  String get birthDate => '生年月日';

  @override
  String get birthDateOptional => '生年月日（任意）';

  @override
  String get birthDateRequired => '生年月日 *';

  @override
  String get blockConfirm => 'このAIをブロックしますか？\nブロックされたAIはマッチングとチャットリストから除外されます。';

  @override
  String get blockReason => 'ブロック理由';

  @override
  String get blockThisAI => 'このAIをブロック';

  @override
  String blockedAICount(int count) {
    return '$count個のブロックしたAI';
  }

  @override
  String get blockedAIs => 'ブロックしたAI';

  @override
  String get blockedAt => 'ブロック日時';

  @override
  String get blockedSuccessfully => 'ブロックしました';

  @override
  String get breakfast => '朝食';

  @override
  String get byErrorType => 'エラータイプ別';

  @override
  String get byPersona => 'ペルソナ別';

  @override
  String cacheDeleteError(String error) {
    return 'キャッシュ削除エラー：$error';
  }

  @override
  String get cacheDeleted => '画像キャッシュが削除されました';

  @override
  String get cafeTerrace => 'カフェテラス';

  @override
  String get calm => '穏やか';

  @override
  String get cameraPermission => 'カメラの許可';

  @override
  String get cameraPermissionDesc => 'プロフィール写真を撮影するにはカメラアクセスが必要です。';

  @override
  String get canChangeInSettings => '後で設定で変更できます';

  @override
  String get canMeetPreviousPersonas => '以前スワイプしたペルソナに\nまた出会えます！';

  @override
  String get cancel => 'キャンセル';

  @override
  String get changeProfilePhoto => 'プロフィール写真を変更';

  @override
  String get chat => 'チャット';

  @override
  String get chatEndedMessage => 'チャットが終了しました';

  @override
  String get chatErrorDashboard => 'チャットエラーダッシュボード';

  @override
  String get chatErrorSentSuccessfully => 'チャットエラーが正常に送信されました。';

  @override
  String get chatListTab => 'チャットリストタブ';

  @override
  String get chats => 'チャット';

  @override
  String chattingWithPersonas(int count) {
    return '$count人のペルソナとチャット中';
  }

  @override
  String get checkInternetConnection => 'インターネット接続を確認してください';

  @override
  String get checkingUserInfo => 'ユーザー情報を確認中';

  @override
  String get childrensDay => '子供の日';

  @override
  String get chinese => '中国語';

  @override
  String get chooseOption => '選択してください：';

  @override
  String get christmas => 'クリスマス';

  @override
  String get close => '閉じる';

  @override
  String get complete => '完了';

  @override
  String get completeSignup => '登録を完了';

  @override
  String get confirm => '確認';

  @override
  String get connectingToServer => 'サーバーに接続中';

  @override
  String get consultQualityMonitoring => '相談品質モニタリング';

  @override
  String get continueAsGuest => 'ゲストとして続ける';

  @override
  String get continueButton => '続ける';

  @override
  String get continueWithApple => 'Appleで続ける';

  @override
  String get continueWithGoogle => 'Googleで続ける';

  @override
  String get conversationContinuity => '会話の継続性';

  @override
  String get conversationContinuityDesc => '以前の会話を記憶してトピックを繋げる';

  @override
  String conversationWith(String name) {
    return '$name';
  }

  @override
  String get convertToMember => '新規登録';

  @override
  String get cooking => '料理';

  @override
  String get copyMessage => 'メッセージをコピー';

  @override
  String get copyrightInfringement => '著作権侵害';

  @override
  String get creatingAccount => 'アカウント作成中';

  @override
  String get crisisDetected => '危機検出';

  @override
  String get culturalIssue => '文化的な問題';

  @override
  String get current => '現在';

  @override
  String get currentCacheSize => '現在のキャッシュサイズ';

  @override
  String get currentLanguage => '現在の言語';

  @override
  String get cycling => 'サイクリング';

  @override
  String get dailyCare => '日常ケア';

  @override
  String get dailyCareDesc => '食事、睡眠、健康のための日常ケアメッセージ';

  @override
  String get dailyChat => '日常会話';

  @override
  String get dailyCheck => '日次チェック';

  @override
  String get dailyConversation => '日常会話';

  @override
  String get dailyLimitDescription => '1日のメッセージ制限に達しました';

  @override
  String get dailyLimitTitle => '1日の制限に達しました';

  @override
  String get darkMode => 'ダークモード';

  @override
  String get darkTheme => 'ダークモード';

  @override
  String get darkThemeDesc => '暗いテーマを使用';

  @override
  String get dataCollection => 'データ収集設定';

  @override
  String get datingAdvice => '恋愛アドバイス';

  @override
  String get datingDescription => '深い思いを共有し、誠実な会話をしたい';

  @override
  String get dawn => '夜明け';

  @override
  String get day => '日';

  @override
  String get dayAfterTomorrow => '明後日';

  @override
  String daysAgo(int count, String formatted) {
    return '$count日前';
  }

  @override
  String daysRemaining(int days) {
    return '残り$days日';
  }

  @override
  String get deepTalk => '深い話';

  @override
  String get delete => '削除';

  @override
  String get deleteAccount => 'アカウント削除';

  @override
  String get deleteAccountConfirm => '本当にアカウントを削除しますか？この操作は取り消せません。';

  @override
  String get deleteAccountWarning => '本当にアカウントを削除しますか？';

  @override
  String get deleteCache => 'キャッシュを削除';

  @override
  String get deletingAccount => 'アカウントを削除中...';

  @override
  String get depressed => '憂鬱';

  @override
  String get describeError => '何が問題ですか？';

  @override
  String get detailedReason => '詳細な理由';

  @override
  String get developRelationshipStep => '3. 関係を深める：会話を通じて親密度を築き、特別な関係を発展させる。';

  @override
  String get dinner => '夕食';

  @override
  String get discardGuestData => '新しく始める';

  @override
  String get discount20 => '20%オフ';

  @override
  String get discount30 => '30%オフ';

  @override
  String get discountAmount => '割引';

  @override
  String discountAmountValue(String amount) {
    return '¥$amount割引';
  }

  @override
  String get done => '完了';

  @override
  String get downloadingPersonaImages => '新しいペルソナ画像をダウンロード中';

  @override
  String get edit => '編集';

  @override
  String get editInfo => '情報を編集';

  @override
  String get editProfile => 'プロフィール編集';

  @override
  String get effectSound => '効果音';

  @override
  String get effectSoundDescription => '効果音を再生';

  @override
  String get email => 'メールアドレス';

  @override
  String get emailHint => 'example@email.com';

  @override
  String get emailLabel => 'メールアドレス';

  @override
  String get emailRequired => 'メールアドレス *';

  @override
  String get emotionAnalysis => '感情分析';

  @override
  String get emotionAnalysisDesc => '共感的な応答のために感情を分析';

  @override
  String get emotionAngry => '怒っている';

  @override
  String get emotionBasedEncounters => '感情に基づく出会い';

  @override
  String get emotionCool => 'クール';

  @override
  String get emotionHappy => '幸せ';

  @override
  String get emotionLove => '愛';

  @override
  String get emotionSad => '悲しい';

  @override
  String get emotionThinking => '考え中';

  @override
  String get emotionalSupportDesc => '悩みを共有し、温かい慰めを受ける';

  @override
  String get endChat => 'チャット終了';

  @override
  String get endTutorial => 'チュートリアル終了';

  @override
  String get endTutorialAndLogin =>
      'チュートリアルを終了してログインしますか？\nログインするとデータが保存され、すべての機能が使えます。';

  @override
  String get endTutorialMessage =>
      'チュートリアルを終了してログインしますか？\nログインすることでデータが保存され、すべての機能を使用できます。';

  @override
  String get english => '英語';

  @override
  String get enterBasicInfo => 'アカウント作成のため基本情報を入力してください';

  @override
  String get enterBasicInformation => '基本情報を入力してください';

  @override
  String get enterEmail => 'メールアドレスを入力してください';

  @override
  String get enterNickname => 'ニックネームを入力してください';

  @override
  String get enterPassword => 'パスワードを入力してください';

  @override
  String get entertainmentAndFunDesc => '楽しいゲームと楽しい会話を楽しむ';

  @override
  String get entertainmentDescription => '楽しい会話をして時間を楽しみたい';

  @override
  String get entertainmentFun => 'エンターテインメント/楽しみ';

  @override
  String get error => 'エラー';

  @override
  String get errorDescription => 'エラーの説明';

  @override
  String get errorDescriptionHint => '例：おかしな返答をした、同じことを繰り返す、文脈に合わない返答をする...';

  @override
  String get errorDetails => 'エラー詳細';

  @override
  String get errorDetailsHint => '何が問題なのか詳しく説明してください';

  @override
  String get errorFrequency24h => 'エラー頻度（過去24時間）';

  @override
  String get errorMessage => 'エラーメッセージ：';

  @override
  String get errorOccurred => 'エラーが発生しました。';

  @override
  String get errorOccurredTryAgain => 'エラーが発生しました。もう一度お試しください。';

  @override
  String get errorSendingFailed => 'エラーの送信に失敗しました';

  @override
  String get errorStats => 'エラー統計';

  @override
  String errorWithMessage(String error) {
    return 'エラーが発生しました：$error';
  }

  @override
  String get evening => '夕方';

  @override
  String get excited => '興奮';

  @override
  String get exit => '終了';

  @override
  String get exitApp => 'アプリを終了';

  @override
  String get exitConfirmMessage => '本当にアプリを終了しますか？';

  @override
  String get expertPersona => 'エキスパートペルソナ';

  @override
  String get expertiseScore => '専門性スコア';

  @override
  String get expired => '期限切れ';

  @override
  String get explainReportReason => '報告理由を詳しく説明してください';

  @override
  String get fashion => 'ファッション';

  @override
  String get female => '女性';

  @override
  String get filter => 'フィルター';

  @override
  String get firstOccurred => '最初の発生：';

  @override
  String get followDeviceLanguage => 'デバイスの言語設定に従う';

  @override
  String get forenoon => '午前';

  @override
  String get forgotPassword => 'パスワードをお忘れですか？';

  @override
  String get frequentlyAskedQuestions => 'よくある質問';

  @override
  String get friday => '金曜日';

  @override
  String get friendshipDescription => '新しい友達に出会い、会話をしたい';

  @override
  String get funChat => '楽しい会話';

  @override
  String get galleryPermission => 'ギャラリーの許可';

  @override
  String get galleryPermissionDesc => 'プロフィール写真を選択するにはギャラリーアクセスが必要です。';

  @override
  String get gaming => 'ゲーム';

  @override
  String get gender => '性別';

  @override
  String get genderNotSelectedInfo => '性別を選択しない場合、すべての性別のペルソナが表示されます';

  @override
  String get genderOptional => '性別（任意）';

  @override
  String get genderPreferenceActive => 'すべての性別のペルソナに出会えます';

  @override
  String get genderPreferenceDisabled => '異性のみオプションを有効にするには性別を選択してください';

  @override
  String get genderPreferenceInactive => '異性のペルソナのみが表示されます';

  @override
  String get genderRequired => '性別 *';

  @override
  String get genderSelectionInfo => '選択しない場合、すべての性別のペルソナに出会えます';

  @override
  String get generalPersona => '一般ペルソナ';

  @override
  String get goToSettings => '設定へ移動';

  @override
  String get googleLoginCanceled => 'Googleログインがキャンセルされました。\nもう一度お試しください。';

  @override
  String get googleLoginError => 'Googleログイン中にエラーが発生しました。';

  @override
  String get grantPermission => '続ける';

  @override
  String get guest => 'ゲスト';

  @override
  String get guestDataMigration => '登録時に現在のチャット履歴を保持しますか？';

  @override
  String get guestLimitReached => 'ゲスト体験が終了しました。\n無制限の会話のために登録してください！';

  @override
  String get guestLoginPromptMessage => '会話を続けるにはログインしてください';

  @override
  String get guestMessageExhausted => '無料メッセージを使い切りました';

  @override
  String guestMessageRemaining(int count) {
    return 'ゲストメッセージ残り$count';
  }

  @override
  String get guestModeBanner => 'ゲストモード';

  @override
  String get guestModeDescription =>
      '登録せずにSONAを試す\n• 20メッセージ制限\n• 1ハート提供\n• すべてのペルソナを表示';

  @override
  String get guestModeFailedMessage => 'ゲストモードの開始に失敗しました';

  @override
  String get guestModeLimitation => 'ゲストモードでは一部の機能が制限されます';

  @override
  String get guestModeTitle => 'ゲストとして試す';

  @override
  String get guestModeWarning => 'ゲストモードは24時間続き、\nその後データは削除されます。';

  @override
  String get guestModeWelcome => 'ゲストモードで開始';

  @override
  String get happy => '幸せ';

  @override
  String get hapticFeedback => '触覚フィードバック';

  @override
  String get harassmentBullying => 'ハラスメント/いじめ';

  @override
  String get hateSpeech => 'ヘイトスピーチ';

  @override
  String get heartDescription => 'メッセージのためのハート';

  @override
  String get heartInsufficient => 'ハートが足りません';

  @override
  String get heartInsufficientPleaseCharge => 'ハートが不足しています。ハートをチャージしてください。';

  @override
  String get heartRequired => '1ハートが必要です';

  @override
  String get heartUsageFailed => 'ハートの使用に失敗しました。';

  @override
  String get hearts => 'ハート';

  @override
  String get hearts10 => '10ハート';

  @override
  String get hearts30 => '30ハート';

  @override
  String get hearts30Discount => 'セール';

  @override
  String get hearts50 => '50ハート';

  @override
  String get hearts50Discount => 'セール';

  @override
  String get helloEmoji => 'こんにちは！ 😊';

  @override
  String get help => 'ヘルプ';

  @override
  String get hideOriginalText => '原文を隠す';

  @override
  String get hobbySharing => '趣味の共有';

  @override
  String get hobbyTalk => '趣味の話';

  @override
  String get hours24Ago => '24時間前';

  @override
  String hoursAgo(int count, String formatted) {
    return '$count時間前';
  }

  @override
  String get howToUse => 'SONAの使い方';

  @override
  String get imageCacheManagement => '画像キャッシュ管理';

  @override
  String get inappropriateContent => '不適切なコンテンツ';

  @override
  String get incorrect => '不正確';

  @override
  String get incorrectPassword => 'パスワードが正しくありません';

  @override
  String get indonesian => 'インドネシア語';

  @override
  String get inquiries => 'お問い合わせ';

  @override
  String get insufficientHearts => 'ハートが不足しています。';

  @override
  String get interestSharing => '興味の共有';

  @override
  String get interestSharingDesc => '共通の興味を発見して推薦';

  @override
  String get interests => '興味';

  @override
  String get invalidEmailFormat => '無効なメールフォーマット';

  @override
  String get invalidEmailFormatError => '有効なメールアドレスを入力してください';

  @override
  String isTyping(String name) {
    return '$nameが入力中...';
  }

  @override
  String get japanese => '日本語';

  @override
  String get joinDate => '登録日';

  @override
  String get justNow => 'たった今';

  @override
  String get keepGuestData => 'チャット履歴を保持';

  @override
  String get korean => '韓国語';

  @override
  String get koreanLanguage => '韓国語';

  @override
  String get language => '言語';

  @override
  String get languageDescription => 'AIは選択した言語で応答します';

  @override
  String get languageIndicator => '言語';

  @override
  String get languageSettings => '言語設定';

  @override
  String get lastOccurred => '最後の発生：';

  @override
  String get lastUpdated => '最終更新';

  @override
  String get lateNight => '深夜';

  @override
  String get later => '後で';

  @override
  String get laterButton => '後で';

  @override
  String get leave => '退室';

  @override
  String get leaveChatConfirm => 'このチャットを退室しますか？\nチャットリストから消えます。';

  @override
  String get leaveChatRoom => 'チャットルームを退室';

  @override
  String get leaveChatTitle => 'チャットを退室';

  @override
  String get lifeAdvice => '人生相談';

  @override
  String get lightTalk => '軽い話';

  @override
  String get lightTheme => 'ライトモード';

  @override
  String get lightThemeDesc => '明るいテーマを使用';

  @override
  String get loading => '読み込み中...';

  @override
  String get loadingData => 'データを読み込み中...';

  @override
  String get loadingProducts => '製品を読み込み中...';

  @override
  String get loadingProfile => 'プロフィールを読み込み中';

  @override
  String get login => 'ログイン';

  @override
  String get loginButton => 'ログイン';

  @override
  String get loginCancelled => 'ログインがキャンセルされました';

  @override
  String get loginComplete => 'ログイン完了';

  @override
  String get loginError => 'ログインに失敗しました';

  @override
  String get loginFailed => 'ログイン失敗';

  @override
  String get loginFailedTryAgain => 'ログインに失敗しました。もう一度お試しください。';

  @override
  String get loginRequired => 'ログインが必要です';

  @override
  String get loginRequiredForProfile => 'プロフィールを表示し、\nSONAとの記録を確認するにはログインが必要です';

  @override
  String get loginRequiredService => 'このサービスを利用するにはログインが必要です';

  @override
  String get loginRequiredTitle => 'ログインが必要です';

  @override
  String get loginSignup => 'ログイン/新規登録';

  @override
  String get loginTab => 'ログイン';

  @override
  String get loginTitle => 'ログイン';

  @override
  String get loginWithApple => 'Appleでログイン';

  @override
  String get loginWithGoogle => 'Googleでログイン';

  @override
  String get logout => 'ログアウト';

  @override
  String get logoutConfirm => '本当にログアウトしますか？';

  @override
  String get lonelinessRelief => '孤独感の解消';

  @override
  String get lonely => '寂しい';

  @override
  String get lowQualityResponses => '低品質レスポンス';

  @override
  String get lunch => '昼食';

  @override
  String get lunchtime => '昼食時間';

  @override
  String get mainErrorType => '主なエラータイプ';

  @override
  String get makeFriends => '友達を作る';

  @override
  String get male => '男性';

  @override
  String get manageBlockedAIs => 'ブロックしたAIを管理';

  @override
  String get managePersonaImageCache => 'ペルソナ画像のキャッシュを管理';

  @override
  String get marketingAgree => 'マーケティング情報に同意（任意）';

  @override
  String get marketingDescription => 'イベントや特典情報を受け取ることができます';

  @override
  String get matchPersonaStep => '1. ペルソナとマッチ：左右にスワイプしてお気に入りのAIペルソナを選択。';

  @override
  String get matchedPersonas => 'マッチしたペルソナ';

  @override
  String get matchedSona => 'マッチしたSona';

  @override
  String get matching => 'マッチング中';

  @override
  String get matchingFailed => 'マッチングに失敗しました。';

  @override
  String get me => '自分';

  @override
  String get meetAIPersonas => 'AIペルソナと出会う';

  @override
  String get meetNewPersonas => '新しいペルソナに出会う';

  @override
  String get meetPersonas => 'ペルソナと出会う';

  @override
  String get memberBenefits => '登録すると100以上のメッセージと10ハートをゲット！';

  @override
  String get memoryAlbum => '思い出アルバム';

  @override
  String get memoryAlbumDesc => '特別な瞬間を自動的に保存して思い出す';

  @override
  String get messageCopied => 'メッセージがコピーされました';

  @override
  String get messageDeleted => 'メッセージが削除されました';

  @override
  String get messageLimitReset => 'メッセージ制限は午前0時にリセットされます';

  @override
  String get messageSendFailed => 'メッセージの送信に失敗しました。もう一度お試しください。';

  @override
  String get messagesRemaining => '残りメッセージ';

  @override
  String minutesAgo(int count, String formatted) {
    return '$count分前';
  }

  @override
  String get missingTranslation => '翻訳漏れ';

  @override
  String get monday => '月曜日';

  @override
  String get month => '月';

  @override
  String monthDay(String month, int day) {
    return '$month $day日';
  }

  @override
  String get moreButton => 'もっと見る';

  @override
  String get morning => '朝';

  @override
  String get mostFrequentError => '最も頻繁なエラー';

  @override
  String get movies => '映画';

  @override
  String get multilingualChat => '多言語チャット';

  @override
  String get music => '音楽';

  @override
  String get myGenderSection => '私の性別（任意）';

  @override
  String get networkErrorOccurred => 'ネットワークエラーが発生しました。';

  @override
  String get newMessage => '新しいメッセージ';

  @override
  String newMessageCount(int count) {
    return '$count件の新しいメッセージ';
  }

  @override
  String get newMessageNotification => '新着メッセージ通知';

  @override
  String get newMessages => '新しいメッセージ';

  @override
  String get newYear => '新年';

  @override
  String get next => '次へ';

  @override
  String get niceToMeetYou => 'はじめまして！';

  @override
  String get nickname => 'ニックネーム';

  @override
  String get nicknameAlreadyUsed => 'このニックネームは既に使用されています';

  @override
  String get nicknameHelperText => '3〜10文字';

  @override
  String get nicknameHint => '3〜10文字';

  @override
  String get nicknameInUse => 'このニックネームは既に使用されています';

  @override
  String get nicknameLabel => 'ニックネーム';

  @override
  String get nicknameLengthError => 'ニックネームは3〜10文字である必要があります';

  @override
  String get nicknamePlaceholder => 'ニックネームを入力';

  @override
  String get nicknameRequired => 'ニックネーム *';

  @override
  String get night => '夜';

  @override
  String get no => 'いいえ';

  @override
  String get noBlockedAIs => 'ブロックしたAIはありません';

  @override
  String get noChatsYet => 'まだチャットはありません';

  @override
  String get noConversationYet => 'まだ会話がありません';

  @override
  String get noErrorReports => 'エラーレポートはありません。';

  @override
  String get noImageAvailable => '画像がありません';

  @override
  String get noMatchedPersonas => 'まだマッチしたペルソナがありません';

  @override
  String get noMatchedSonas => 'まだマッチしたSonaはありません';

  @override
  String get noPersonasAvailable => 'ペルソナがありません。もう一度お試しください。';

  @override
  String get noPersonasToSelect => '選択可能なペルソナがありません';

  @override
  String get noQualityIssues => '過去1時間に品質問題はありません ✅';

  @override
  String get noQualityLogs => 'まだ品質ログはありません。';

  @override
  String get noTranslatedMessages => '翻訳するメッセージがありません';

  @override
  String get notEnoughHearts => 'ハートが不足しています';

  @override
  String notEnoughHeartsCount(int count) {
    return 'ハートが不足しています。（現在：$count）';
  }

  @override
  String get notRegistered => '未登録';

  @override
  String get notSubscribed => '未登録';

  @override
  String get notificationPermissionDesc => '新しいメッセージを受信するには通知許可が必要です。';

  @override
  String get notificationPermissionRequired => '通知の許可が必要です';

  @override
  String get notificationSettings => '通知設定';

  @override
  String get notifications => '通知';

  @override
  String get occurrenceInfo => '発生情報：';

  @override
  String get olderChats => 'それ以前';

  @override
  String get onlyOppositeGenderNote => 'チェックを外すと、異性のペルソナのみが表示されます';

  @override
  String get openSettings => '設定を開く';

  @override
  String get optional => '任意';

  @override
  String get or => 'または';

  @override
  String get originalPrice => '通常価格';

  @override
  String get originalText => '原文';

  @override
  String get other => 'その他';

  @override
  String get otherError => 'その他のエラー';

  @override
  String get others => 'その他';

  @override
  String get ownedHearts => '所有ハート';

  @override
  String get parentsDay => '父母の日';

  @override
  String get password => 'パスワード';

  @override
  String get passwordConfirmation => '確認のためパスワードを入力';

  @override
  String get passwordConfirmationDesc => 'アカウントを削除するにはパスワードを再入力してください。';

  @override
  String get passwordHint => '6文字以上';

  @override
  String get passwordLabel => 'パスワード';

  @override
  String get passwordRequired => 'パスワード *';

  @override
  String get passwordResetEmailPrompt => 'パスワードをリセットするためメールアドレスを入力してください';

  @override
  String get passwordResetEmailSent => 'パスワードリセットメールが送信されました。メールをご確認ください。';

  @override
  String get passwordText => 'パスワード';

  @override
  String get passwordTooShort => 'パスワードは6文字以上である必要があります';

  @override
  String get permissionDenied => '許可が拒否されました';

  @override
  String permissionDeniedMessage(String permissionName) {
    return '$permissionNameの許可が拒否されました。\\n設定で許可を与えてください。';
  }

  @override
  String get permissionDeniedTryLater => '許可が拒否されました。後でもう一度お試しください。';

  @override
  String get permissionRequired => '許可が必要です';

  @override
  String get personaGenderSection => 'ペルソナの性別設定';

  @override
  String get personaQualityStats => 'ペルソナ品質統計';

  @override
  String get personalInfoExposure => '個人情報の露出';

  @override
  String get personality => '性格';

  @override
  String get pets => 'ペット';

  @override
  String get photo => '写真';

  @override
  String get photography => '写真';

  @override
  String get picnic => 'ピクニック';

  @override
  String get preferenceSettings => '設定';

  @override
  String get preferredLanguage => '優先言語';

  @override
  String get preparingForSleep => '就寝準備中';

  @override
  String get preparingNewMeeting => '新しい出会いを準備中';

  @override
  String get preparingPersonaImages => 'ペルソナ画像を準備中';

  @override
  String get preparingPersonas => 'ペルソナを準備中';

  @override
  String get preview => 'プレビュー';

  @override
  String get previous => '戻る';

  @override
  String get privacy => 'プライバシーポリシー';

  @override
  String get privacyPolicy => 'プライバシーポリシー';

  @override
  String get privacyPolicyAgreement => 'プライバシーポリシーに同意してください';

  @override
  String get privacySection1Content =>
      '私たちはあなたのプライバシーを保護することを約束します。このプライバシーポリシーでは、サービスを利用する際にどのように情報を収集、使用、保護するかを説明します。';

  @override
  String get privacySection1Title => '1. 個人情報の収集および利用目的';

  @override
  String get privacySection2Content =>
      'アカウントを作成したり、プロフィールを更新したり、サービスを利用したりする際に、直接提供された情報を収集します。';

  @override
  String get privacySection2Title => '収集する情報';

  @override
  String get privacySection3Content =>
      '収集した情報を使用して、サービスを提供、維持、改善し、あなたとコミュニケーションを取ります。';

  @override
  String get privacySection3Title => '3. 個人情報の保有および利用期間';

  @override
  String get privacySection4Content =>
      'あなたの同意なしに、個人情報を第三者に販売、取引、またはその他の方法で移転することはありません。';

  @override
  String get privacySection4Title => '4. 第三者への個人情報の提供';

  @override
  String get privacySection5Content =>
      '不正アクセス、改ざん、開示、または破壊からあなたの個人情報を保護するために、適切なセキュリティ対策を実施しています。';

  @override
  String get privacySection5Title => '5. 個人情報の技術的保護措置';

  @override
  String get privacySection6Content => 'サービスを提供し、法的義務を遵守するために必要な限り、個人情報を保持します。';

  @override
  String get privacySection6Title => '6. ユーザーの権利';

  @override
  String get privacySection7Content =>
      'あなたは、アカウント設定を通じて、いつでも個人情報にアクセス、更新、または削除する権利があります。';

  @override
  String get privacySection7Title => 'あなたの権利';

  @override
  String get privacySection8Content =>
      'このプライバシーポリシーについて質問がある場合は、support@sona.comまでご連絡ください。';

  @override
  String get privacySection8Title => 'お問い合わせ';

  @override
  String get privacySettings => 'プライバシー設定';

  @override
  String get privacySettingsInfo => '個別の機能を無効にすると、それらのサービスは利用できなくなります';

  @override
  String get privacySettingsScreen => 'プライバシー設定';

  @override
  String get problemMessage => '問題';

  @override
  String get problemOccurred => '問題が発生しました';

  @override
  String get profile => 'プロフィール';

  @override
  String get profileEdit => 'プロフィール編集';

  @override
  String get profileEditLoginRequiredMessage =>
      'プロフィールを編集するにはログインが必要です。\nログイン画面に移動しますか？';

  @override
  String get profileInfo => 'プロフィール情報';

  @override
  String get profileInfoDescription => 'プロフィール写真と基本情報を入力してください';

  @override
  String get profileNav => 'プロフィール';

  @override
  String get profilePhoto => 'プロフィール写真';

  @override
  String get profilePhotoAndInfo => 'プロフィール写真と基本情報を入力してください';

  @override
  String get profilePhotoUpdateFailed => 'プロフィール写真の更新に失敗しました';

  @override
  String get profilePhotoUpdated => 'プロフィール写真が更新されました';

  @override
  String get profileSettings => 'プロフィール設定';

  @override
  String get profileSetup => 'プロフィールをセットアップ中';

  @override
  String get profileUpdateFailed => 'プロフィールの更新に失敗しました';

  @override
  String get profileUpdated => 'プロフィールが正常に更新されました';

  @override
  String get purchaseAndRefundPolicy => '購入および返金ポリシー';

  @override
  String get purchaseButton => '購入';

  @override
  String get purchaseConfirm => '購入確認';

  @override
  String purchaseConfirmContent(String product, String price) {
    return '$productを$priceで購入しますか？';
  }

  @override
  String purchaseConfirmMessage(
      String title, String price, String description) {
    return '$titleを$priceで購入しますか？$description';
  }

  @override
  String get purchaseFailed => '購入に失敗しました';

  @override
  String get purchaseHeartsOnly => 'ハートを購入';

  @override
  String get purchaseMoreHearts => '会話を続けるためにハートを購入';

  @override
  String get purchasePending => '購入処理中...';

  @override
  String get purchasePolicy => '購入ポリシー';

  @override
  String get purchaseSection1Content =>
      'クレジットカードやデジタルウォレットなど、さまざまな支払い方法に対応しています。';

  @override
  String get purchaseSection1Title => '支払い方法';

  @override
  String get purchaseSection2Content => '購入したアイテムを使用していない場合、購入から14日以内に返金が可能です。';

  @override
  String get purchaseSection2Title => '返金ポリシー';

  @override
  String get purchaseSection3Content => 'アカウント設定からいつでもサブスクリプションをキャンセルできます。';

  @override
  String get purchaseSection3Title => 'キャンセル';

  @override
  String get purchaseSection4Content => '購入を行うことで、利用規約およびサービス契約に同意したことになります。';

  @override
  String get purchaseSection4Title => '利用規約';

  @override
  String get purchaseSection5Content => '購入に関する問題については、サポートチームにお問い合わせください。';

  @override
  String get purchaseSection5Title => 'サポートに連絡';

  @override
  String get purchaseSection6Content => 'すべての購入は、当社の標準利用規約および条件に従います。';

  @override
  String get purchaseSection6Title => '6. お問い合わせ';

  @override
  String get pushNotifications => 'プッシュ通知';

  @override
  String get reading => '読書';

  @override
  String get realtimeQualityLog => 'リアルタイム品質ログ';

  @override
  String get recentConversation => '最近の会話:';

  @override
  String get recentLoginRequired => 'セキュリティのため再度ログインしてください';

  @override
  String get referrerEmail => '紹介者のメール';

  @override
  String get referrerEmailHelper => '任意: あなたを紹介した人のメールアドレス';

  @override
  String get referrerEmailLabel => '紹介者のメール（任意）';

  @override
  String get refresh => '更新';

  @override
  String refreshComplete(int count) {
    return '更新完了！$count人のペルソナとマッチ';
  }

  @override
  String get refreshFailed => '更新に失敗しました';

  @override
  String get refreshingChatList => 'チャットリストを更新中です...';

  @override
  String get relatedFAQ => '関連FAQ';

  @override
  String get report => '報告';

  @override
  String get reportAI => '報告';

  @override
  String get reportAIDescription => 'AIがあなたを不快にさせた場合、問題を説明してください。';

  @override
  String get reportAITitle => 'AI会話を報告';

  @override
  String get reportAndBlock => '報告＆ブロック';

  @override
  String get reportAndBlockDescription => 'このAIの不適切な行動を報告してブロックできます';

  @override
  String get reportChatError => 'チャットエラーを報告';

  @override
  String reportError(String error) {
    return '報告中にエラーが発生しました：$error';
  }

  @override
  String get reportFailed => '通報に失敗しました';

  @override
  String get reportSubmitted => '報告が送信されました。レビューして対処します。';

  @override
  String get reportSubmittedSuccess => '報告が送信されました。ありがとうございます！';

  @override
  String get requestLimit => 'リクエスト制限';

  @override
  String get required => '[必須]';

  @override
  String get requiredTermsAgreement => '利用規約に同意してください';

  @override
  String get restartConversation => '会話を再開';

  @override
  String restartConversationQuestion(String name) {
    return '$nameとの会話を再開しますか？';
  }

  @override
  String restartConversationWithName(String name) {
    return '$nameとの会話を再開します！';
  }

  @override
  String get retry => 'リトライ';

  @override
  String get retryButton => 'リトライ';

  @override
  String get sad => '悲しい';

  @override
  String get saturday => '土曜日';

  @override
  String get save => '保存';

  @override
  String get search => '検索';

  @override
  String get searchFAQ => 'FAQを検索...';

  @override
  String get searchResults => '検索結果';

  @override
  String get selectEmotion => '感情を選択してください';

  @override
  String get selectErrorType => 'エラータイプを選択';

  @override
  String get selectFeeling => '気分を選択';

  @override
  String get selectGender => '性別を選択してください';

  @override
  String get selectInterests => '興味を選択してください（最低1つ）';

  @override
  String get selectLanguage => '言語を選択';

  @override
  String get selectPersona => 'ペルソナを選択してください';

  @override
  String get selectPersonaPlease => 'ペルソナを選択してください。';

  @override
  String get selectPreferredMbti => '特定のMBTIタイプのペルソナを希望する場合は選択してください';

  @override
  String get selectProblematicMessage => '問題のあるメッセージを選択（任意）';

  @override
  String get selectReportReason => '通報理由を選択してください';

  @override
  String get selectTheme => 'テーマを選択';

  @override
  String get selectTranslationError => '翻訳エラーのあるメッセージを選択してください';

  @override
  String get selectUsagePurpose => 'SONAの利用目的を選択してください';

  @override
  String get selfIntroduction => '自己紹介（任意）';

  @override
  String get selfIntroductionHint => '簡単な自己紹介を書いてください';

  @override
  String get send => '送信';

  @override
  String get sendChatError => 'チャットエラーを送信';

  @override
  String get sendFirstMessage => '最初のメッセージを送信してください';

  @override
  String get sendReport => '報告を送信';

  @override
  String get sendingEmail => 'メール送信中...';

  @override
  String get seoul => 'ソウル';

  @override
  String get serverErrorDashboard => 'サーバーエラー';

  @override
  String get serviceTermsAgreement => 'サービス利用規約に同意してください';

  @override
  String get sessionExpired => 'セッションの有効期限が切れました';

  @override
  String get setAppInterfaceLanguage => 'アプリのインターフェース言語を設定';

  @override
  String get setNow => '今すぐ設定';

  @override
  String get settings => '設定';

  @override
  String get sexualContent => '性的なコンテンツ';

  @override
  String get showAllGenderPersonas => 'すべての性別のペルソナを表示';

  @override
  String get showAllGendersOption => 'すべての性別を表示';

  @override
  String get showOppositeGenderOnly => 'チェックを外すと、異性のペルソナのみが表示されます';

  @override
  String get showOriginalText => '原文を表示';

  @override
  String get signUp => '新規登録';

  @override
  String get signUpFromGuest => 'すべての機能にアクセスするために今すぐ登録！';

  @override
  String get signup => '新規登録';

  @override
  String get signupComplete => '登録完了';

  @override
  String get signupTab => '新規登録';

  @override
  String get simpleInfoRequired => 'AIペルソナとのマッチングには\n簡単な情報が必要です';

  @override
  String get skip => 'スキップ';

  @override
  String get sonaFriend => 'SONAフレンド';

  @override
  String get sonaPrivacyPolicy => 'SONA プライバシーポリシー';

  @override
  String get sonaPurchasePolicy => 'SONA 購入ポリシー';

  @override
  String get sonaTermsOfService => 'SONA 利用規約';

  @override
  String get sonaUsagePurpose => 'SONAの利用目的を選択してください';

  @override
  String get sorryNotHelpful => 'お役に立てず申し訳ありません';

  @override
  String get sort => '並び替え';

  @override
  String get soundSettings => 'サウンド設定';

  @override
  String get spamAdvertising => 'スパム/広告';

  @override
  String get spanish => 'スペイン語';

  @override
  String get specialRelationshipDesc => 'お互いを理解し、深い絆を築く';

  @override
  String get sports => 'スポーツ';

  @override
  String get spring => '春';

  @override
  String get startChat => 'チャット開始';

  @override
  String get startChatButton => 'チャットを開始';

  @override
  String get startConversation => '会話を始める';

  @override
  String get startConversationLikeAFriend => 'Sonaと友達のように会話を始めよう';

  @override
  String get startConversationStep => '2. 会話を開始：マッチしたペルソナと自由にチャット。';

  @override
  String get startConversationWithSona => 'Sonaと友達のようにチャットを始めよう！';

  @override
  String get startWithEmail => 'メールで始める';

  @override
  String get startWithGoogle => 'Googleで始める';

  @override
  String get startingApp => 'アプリを起動中';

  @override
  String get storageManagement => 'ストレージ管理';

  @override
  String get store => 'ストア';

  @override
  String get storeConnectionError => 'ストアに接続できませんでした';

  @override
  String get storeLoginRequiredMessage =>
      'ストアを利用するにはログインが必要です。\nログイン画面に移動しますか？';

  @override
  String get storeNotAvailable => 'ストアは利用できません';

  @override
  String get storyEvent => 'ストーリーイベント';

  @override
  String get stressed => 'ストレス';

  @override
  String get submitReport => '報告を送信';

  @override
  String get subscriptionStatus => 'サブスクリプション状況';

  @override
  String get subtleVibrationOnTouch => 'タッチ時の微細な振動';

  @override
  String get summer => '夏';

  @override
  String get sunday => '日曜日';

  @override
  String get swipeAnyDirection => '任意の方向にスワイプ';

  @override
  String get swipeDownToClose => '下にスワイプして閉じる';

  @override
  String get systemTheme => 'システム設定に従う';

  @override
  String get systemThemeDesc => 'デバイスのダークモード設定に基づいて自動的に変更されます';

  @override
  String get tapBottomForDetails => '詳細を見るには下部をタップ';

  @override
  String get tapForDetails => '詳細を見るには下部をタップ';

  @override
  String get tapToSwipePhotos => '写真をスワイプするにはタップ';

  @override
  String get teachersDay => '教師の日';

  @override
  String get technicalError => '技術的エラー';

  @override
  String get technology => 'テクノロジー';

  @override
  String get terms => '利用規約';

  @override
  String get termsAgreement => '利用規約への同意';

  @override
  String get termsAgreementDescription => 'サービス利用のため規約に同意してください';

  @override
  String get termsOfService => '利用規約';

  @override
  String get termsSection10Content => '当社は、ユーザーに通知の上、これらの条件をいつでも変更する権利を留保します。';

  @override
  String get termsSection10Title => '第10条（紛争解決）';

  @override
  String get termsSection11Content => 'これらの条件は、当社が運営する管轄区域の法律に準拠します。';

  @override
  String get termsSection11Title => '第11条（AIサービス特約）';

  @override
  String get termsSection12Content =>
      'これらの条件のいずれかの条項が執行不可能と判断された場合でも、残りの条項は引き続き有効です。';

  @override
  String get termsSection12Title => '第12条（データ収集と利用）';

  @override
  String get termsSection1Content =>
      'これらの利用規約は、SONA（以下「会社」）が提供するAIペルソナ会話マッチングサービス（以下「サービス」）の利用に関して、会社とユーザー間の権利、義務、責任を定義することを目的とします。';

  @override
  String get termsSection1Title => '第1条（目的）';

  @override
  String get termsSection2Content =>
      '当社のサービスを利用することにより、これらの利用規約およびプライバシーポリシーに従うことに同意したものとみなされます。';

  @override
  String get termsSection2Title => '第2条（定義）';

  @override
  String get termsSection3Content => '当社のサービスを利用するには、13歳以上である必要があります。';

  @override
  String get termsSection3Title => '第3条（規約の効力と変更）';

  @override
  String get termsSection4Content => 'アカウントとパスワードの機密性を維持する責任はあなたにあります。';

  @override
  String get termsSection4Title => '第4条（サービスの提供）';

  @override
  String get termsSection5Content => 'あなたは、当社のサービスを違法または無許可の目的で使用しないことに同意します。';

  @override
  String get termsSection5Title => '第5条（会員登録）';

  @override
  String get termsSection6Content =>
      '当社は、これらの条件に違反した場合、あなたのアカウントを終了または一時停止する権利を留保します。';

  @override
  String get termsSection6Title => '第6条（ユーザーの義務）';

  @override
  String get termsSection7Content =>
      'ユーザーがこれらの規約の義務に違反したり、通常のサービス運営を妨害した場合、会社は警告、一時停止、または永久停止を通じてサービス利用を段階的に制限することができます。';

  @override
  String get termsSection7Title => '第7条（サービス利用制限）';

  @override
  String get termsSection8Content =>
      '当社のサービスの利用に起因する間接的、偶発的、または結果的な損害について、当社は責任を負いません。';

  @override
  String get termsSection8Title => '第8条（サービスの中断）';

  @override
  String get termsSection9Content =>
      '当社のサービスで利用可能なすべてのコンテンツおよび資料は、知的財産権によって保護されています。';

  @override
  String get termsSection9Title => '第9条（免責事項）';

  @override
  String get termsSupplementary => '補足条件';

  @override
  String get thai => 'タイ語';

  @override
  String get thanksFeedback => 'フィードバックありがとうございます！';

  @override
  String get theme => 'テーマ';

  @override
  String get themeDescription => 'お好みに合わせてアプリの外観をカスタマイズできます';

  @override
  String get themeSettings => 'テーマ設定';

  @override
  String get thursday => '木曜日';

  @override
  String get timeout => 'タイムアウト';

  @override
  String get tired => '疲れた';

  @override
  String get today => '今日';

  @override
  String get todayChats => '今日';

  @override
  String get todayText => '今日';

  @override
  String get tomorrowText => '明日';

  @override
  String get totalConsultSessions => '総相談セッション';

  @override
  String get totalErrorCount => '総エラー数';

  @override
  String get totalLikes => '合計いいね';

  @override
  String totalOccurrences(Object count) {
    return '合計 $count 回の発生';
  }

  @override
  String get totalResponses => '総レスポンス';

  @override
  String get translatedFrom => '翻訳済み';

  @override
  String get translatedText => '翻訳';

  @override
  String get translationError => '翻訳エラー';

  @override
  String get translationErrorDescription => '間違った翻訳や不自然な表現を報告してください';

  @override
  String get translationErrorReported => '翻訳エラーが報告されました。ありがとうございます！';

  @override
  String get translationNote => '※ AI翻訳は完璧ではない可能性があります';

  @override
  String get translationQuality => '翻訳品質';

  @override
  String get translationSettings => '翻訳設定';

  @override
  String get travel => '旅行';

  @override
  String get tuesday => '火曜日';

  @override
  String get tutorialAccount => 'チュートリアルアカウント';

  @override
  String get tutorialWelcomeDescription => 'AIペルソナと特別な関係を築きましょう。';

  @override
  String get tutorialWelcomeTitle => 'SONAへようこそ！';

  @override
  String get typeMessage => 'メッセージを入力...';

  @override
  String get unblock => 'ブロック解除';

  @override
  String get unblockFailed => 'ブロック解除に失敗しました';

  @override
  String unblockPersonaConfirm(String name) {
    return '$nameのブロックを解除しますか？';
  }

  @override
  String get unblockedSuccessfully => 'ブロック解除しました';

  @override
  String get unexpectedLoginError => 'ログイン中に予期しないエラーが発生しました';

  @override
  String get unknown => '不明';

  @override
  String get unknownError => '不明なエラーが発生しました';

  @override
  String get unlimitedMessages => '無制限';

  @override
  String get unsendMessage => 'メッセージを取り消す';

  @override
  String get usagePurpose => '利用目的';

  @override
  String get useOneHeart => '1ハート使用';

  @override
  String get useSystemLanguage => 'システム言語を使用';

  @override
  String get user => 'ユーザー:';

  @override
  String get userMessage => 'ユーザーメッセージ:';

  @override
  String get userNotFound => 'ユーザーが見つかりません';

  @override
  String get valentinesDay => 'バレンタインデー';

  @override
  String get verifyingAuth => '認証を確認中';

  @override
  String get version => 'バージョン';

  @override
  String get vietnamese => 'ベトナム語';

  @override
  String get violentContent => '暴力的なコンテンツ';

  @override
  String get voiceMessage => '🎤 ボイスメッセージ';

  @override
  String waitingForChat(String name) {
    return '$nameがチャットを待っています。';
  }

  @override
  String get walk => '散歩';

  @override
  String get wasHelpful => '役に立ちましたか？';

  @override
  String get weatherClear => '晴れ';

  @override
  String get weatherCloudy => '曇り';

  @override
  String get weatherContext => '天気コンテキスト';

  @override
  String get weatherContextDesc => '天気に基づいた会話コンテキストを提供';

  @override
  String get weatherDrizzle => '霧雨';

  @override
  String get weatherFog => '霧';

  @override
  String get weatherMist => 'ミスト';

  @override
  String get weatherRain => '雨';

  @override
  String get weatherRainy => '雨';

  @override
  String get weatherSnow => '雪';

  @override
  String get weatherSnowy => '雪';

  @override
  String get weatherThunderstorm => '雷雨';

  @override
  String get wednesday => '水曜日';

  @override
  String get weekdays => '日,月,火,水,木,金,土';

  @override
  String get welcomeMessage => 'ようこそ💕';

  @override
  String get whatTopicsToTalk => 'どんな話題について話したいですか？（任意）';

  @override
  String get whiteDay => 'ホワイトデー';

  @override
  String get winter => '冬';

  @override
  String get wrongTranslation => '誤訳';

  @override
  String get year => '年';

  @override
  String get yearEnd => '年末';

  @override
  String get yes => 'はい';

  @override
  String get yesterday => '昨日';

  @override
  String get yesterdayChats => '昨日';

  @override
  String get you => 'あなた';

  @override
  String get loadingPersonaData => 'ペルソナデータを読み込み中';

  @override
  String get checkingMatchedPersonas => 'マッチしたペルソナを確認中';

  @override
  String get preparingImages => '画像を準備中';

  @override
  String get finalPreparation => '最終準備中';
}
