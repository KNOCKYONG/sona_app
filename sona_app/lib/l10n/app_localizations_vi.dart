// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get about => 'Về chúng tôi';

  @override
  String get accountAndProfile => 'Tài khoản & Hồ sơ';

  @override
  String get accountDeletedSuccess => 'Tài khoản đã được xóa thành công';

  @override
  String get accountDeletionContent => 'Tài khoản sẽ bị xóa vĩnh viễn';

  @override
  String get accountDeletionError => 'Lỗi khi xóa tài khoản';

  @override
  String get accountDeletionInfo => 'Thông tin xóa tài khoản';

  @override
  String get accountDeletionTitle => 'Xóa tài khoản';

  @override
  String get accountDeletionWarning1 =>
      'Cảnh báo: Hành động này không thể hoàn tác';

  @override
  String get accountDeletionWarning2 =>
      'Tất cả dữ liệu của bạn sẽ bị xóa vĩnh viễn';

  @override
  String get accountDeletionWarning3 =>
      'Bạn sẽ mất quyền truy cập vào tất cả các cuộc trò chuyện';

  @override
  String get accountDeletionWarning4 =>
      'Điều này bao gồm tất cả nội dung đã mua';

  @override
  String get accountManagement => 'Quản lý tài khoản';

  @override
  String get adaptiveConversationDesc =>
      'Điều chỉnh phong cách trò chuyện để phù hợp với bạn';

  @override
  String get afternoon => 'Buổi chiều';

  @override
  String get afternoonFatigue => 'Mệt mỏi buổi chiều';

  @override
  String get ageConfirmation => 'Xác nhận độ tuổi';

  @override
  String ageRange(int min, int max) {
    return '$min-$max tuổi';
  }

  @override
  String get ageUnit => 'tuổi';

  @override
  String get agreeToTerms => 'Tôi đồng ý với các điều khoản';

  @override
  String get aiDatingQuestion => 'Một cuộc sống đặc biệt hàng ngày với AI';

  @override
  String get aiPersonaPreferenceDescription => 'Sở thích nhân vật AI';

  @override
  String get all => 'Tất cả';

  @override
  String get allAgree => 'Đồng ý tất cả';

  @override
  String get allFeaturesRequired => 'Cần tất cả tính năng';

  @override
  String get allPersonas => 'Tất cả nhân vật';

  @override
  String get allPersonasMatched => 'Đã ghép đôi với tất cả nhân vật';

  @override
  String get allowPermission => 'Tiếp tục';

  @override
  String alreadyChattingWith(String name) {
    return 'Đã đang trò chuyện với $name';
  }

  @override
  String get alsoBlockThisAI => 'Cũng chặn AI này';

  @override
  String get angry => 'Tức giận';

  @override
  String get anonymousLogin => 'Đăng nhập ẩn danh';

  @override
  String get anxious => 'Lo lắng';

  @override
  String get apiKeyError => 'Lỗi API Key';

  @override
  String get appName => 'SONA';

  @override
  String get appTagline => 'Người bạn AI của bạn';

  @override
  String get appleLoginCanceled => 'Đăng nhập Apple đã hủy';

  @override
  String get appleLoginError =>
      'Đã xảy ra lỗi trong quá trình đăng nhập Apple.';

  @override
  String get art => 'Nghệ thuật';

  @override
  String get authError => 'Lỗi xác thực';

  @override
  String get autoTranslate => 'Dịch tự động';

  @override
  String get autumn => 'Mùa thu';

  @override
  String get averageQuality => 'Chất lượng trung bình';

  @override
  String get averageQualityScore => 'Điểm chất lượng trung bình';

  @override
  String get awkwardExpression => 'Biểu cảm ngượng ngùng';

  @override
  String get backButton => 'Quay lại';

  @override
  String get basicInfo => 'Thông tin cơ bản';

  @override
  String get basicInfoDescription => 'Thông tin cơ bản của bạn';

  @override
  String get birthDate => 'Ngày sinh';

  @override
  String get birthDateOptional => 'Ngày sinh (tùy chọn)';

  @override
  String get birthDateRequired => 'Vui lòng chọn ngày sinh';

  @override
  String get blockConfirm => 'Xác nhận chặn';

  @override
  String get blockReason => 'Lý do chặn';

  @override
  String get blockThisAI => 'Chặn AI này';

  @override
  String blockedAICount(int count) {
    return '$count AI đã chặn';
  }

  @override
  String get blockedAIs => 'Các AI đã bị chặn';

  @override
  String get blockedAt => 'Bị chặn tại';

  @override
  String get blockedSuccessfully => 'Đã chặn thành công';

  @override
  String get breakfast => 'Bữa sáng';

  @override
  String get byErrorType => 'Theo loại lỗi';

  @override
  String get byPersona => 'Theo nhân vật';

  @override
  String cacheDeleteError(String error) {
    return 'Lỗi xóa bộ nhớ đệm: $error';
  }

  @override
  String get cacheDeleted => 'Bộ nhớ hình ảnh đã được xóa';

  @override
  String get cafeTerrace => 'Sân thượng quán cà phê';

  @override
  String get calm => 'Bình tĩnh';

  @override
  String get cameraPermission => 'Quyền truy cập máy ảnh';

  @override
  String get cameraPermissionDesc => 'Cần quyền máy ảnh để chụp ảnh';

  @override
  String get canChangeInSettings =>
      'Bạn có thể thay đổi điều này sau trong cài đặt';

  @override
  String get canMeetPreviousPersonas => 'Bạn có thể gặp lại các nhân vật';

  @override
  String get cancel => 'Hủy';

  @override
  String get changeProfilePhoto => 'Đổi ảnh hồ sơ';

  @override
  String get chat => 'Trò chuyện';

  @override
  String get chatEndedMessage => 'Cuộc trò chuyện đã kết thúc';

  @override
  String get chatErrorDashboard => 'Bảng điều khiển lỗi trò chuyện';

  @override
  String get chatErrorSentSuccessfully =>
      'Lỗi trò chuyện đã được gửi thành công.';

  @override
  String get chatListTab => 'Danh sách chat';

  @override
  String get chats => 'Trò chuyện';

  @override
  String chattingWithPersonas(int count) {
    return 'Đang trò chuyện với $count nhân vật';
  }

  @override
  String get checkInternetConnection => 'Vui lòng kiểm tra kết nối internet';

  @override
  String get checkingUserInfo => 'Đang kiểm tra thông tin người dùng';

  @override
  String get childrensDay => 'Ngày Quốc tế Thiếu nhi';

  @override
  String get chinese => 'Tiếng Trung';

  @override
  String get chooseOption => 'Chọn một tùy chọn:';

  @override
  String get christmas => 'Giáng sinh';

  @override
  String get close => 'Đóng';

  @override
  String get complete => 'Hoàn thành';

  @override
  String get completeSignup => 'Hoàn tất đăng ký';

  @override
  String get confirm => 'Xác nhận';

  @override
  String get connectingToServer => 'Đang kết nối đến máy chủ';

  @override
  String get consultQualityMonitoring => 'Giám sát chất lượng tư vấn';

  @override
  String get continueAsGuest => 'Tiếp tục với tư cách Khách';

  @override
  String get continueButton => 'Tiếp tục';

  @override
  String get continueWithApple => 'Tiếp tục với Apple';

  @override
  String get continueWithGoogle => 'Tiếp tục với Google';

  @override
  String get conversationContinuity => 'Tính liên tục của cuộc trò chuyện';

  @override
  String get conversationContinuityDesc => 'Liên tục cuộc trò chuyện';

  @override
  String conversationWith(String name) {
    return '$name';
  }

  @override
  String get convertToMember => 'Đăng ký';

  @override
  String get cooking => 'Nấu ăn';

  @override
  String get copyMessage => 'Sao chép tin nhắn';

  @override
  String get copyrightInfringement => 'Vi phạm bản quyền';

  @override
  String get creatingAccount => 'Tạo tài khoản';

  @override
  String get crisisDetected => 'Đã phát hiện khủng hoảng';

  @override
  String get culturalIssue => 'Vấn đề văn hóa';

  @override
  String get current => 'Hiện tại';

  @override
  String get currentCacheSize => 'Kích thước bộ nhớ cache hiện tại';

  @override
  String get currentLanguage => 'Ngôn ngữ hiện tại';

  @override
  String get cycling => 'Đạp xe';

  @override
  String get dailyCare => 'Chăm sóc hàng ngày';

  @override
  String get dailyCareDesc => 'Chăm sóc hàng ngày';

  @override
  String get dailyChat => 'Trò chuyện hàng ngày';

  @override
  String get dailyCheck => 'Kiểm tra hàng ngày';

  @override
  String get dailyConversation => 'Cuộc trò chuyện hàng ngày';

  @override
  String get dailyLimitDescription => 'Bạn đã đạt giới hạn tin nhắn hàng ngày';

  @override
  String get dailyLimitTitle => 'Đã đạt giới hạn hàng ngày';

  @override
  String get darkMode => 'Chế độ tối';

  @override
  String get darkTheme => 'Chế độ tối';

  @override
  String get darkThemeDesc => 'Sử dụng chế độ tối';

  @override
  String get dataCollection => 'Cài đặt thu thập dữ liệu';

  @override
  String get datingAdvice => 'Lời khuyên hẹn hò';

  @override
  String get datingDescription => 'Tìm kiếm hẹn hò';

  @override
  String get dawn => 'Bình minh';

  @override
  String get day => 'Ngày';

  @override
  String get dayAfterTomorrow => 'Ngày kia';

  @override
  String daysAgo(int count, String formatted) {
    return '$count ngày trước';
  }

  @override
  String daysRemaining(int days) {
    return '$days ngày còn lại';
  }

  @override
  String get deepTalk => 'Cuộc trò chuyện sâu sắc';

  @override
  String get delete => 'Xóa';

  @override
  String get deleteAccount => 'Xóa tài khoản';

  @override
  String get deleteAccountConfirm =>
      'Bạn có chắc chắn muốn xóa tài khoản của mình không? Hành động này không thể hoàn tác.';

  @override
  String get deleteAccountWarning =>
      'Bạn có chắc chắn muốn xóa tài khoản của mình không?';

  @override
  String get deleteCache => 'Xóa bộ nhớ cache';

  @override
  String get deletingAccount => 'Đang xóa tài khoản...';

  @override
  String get depressed => 'Buồn chán';

  @override
  String get describeError => 'Có vấn đề gì?';

  @override
  String get detailedReason => 'Lý do chi tiết';

  @override
  String get developRelationshipStep =>
      '3. Phát triển mối quan hệ: Xây dựng sự thân mật qua các cuộc trò chuyện và phát triển những mối quan hệ đặc biệt.';

  @override
  String get dinner => 'Bữa tối';

  @override
  String get discardGuestData => 'Bắt đầu lại';

  @override
  String get discount20 => 'Giảm 20%';

  @override
  String get discount30 => 'Giảm 30%';

  @override
  String get discountAmount => 'Số tiền giảm';

  @override
  String discountAmountValue(String amount) {
    return 'Giảm $amount';
  }

  @override
  String get done => 'Hoàn thành';

  @override
  String get downloadingPersonaImages => 'Đang tải hình ảnh nhân vật mới';

  @override
  String get edit => 'Chỉnh sửa';

  @override
  String get editInfo => 'Chỉnh sửa thông tin';

  @override
  String get editProfile => 'Chỉnh sửa hồ sơ';

  @override
  String get effectSound => 'Hiệu ứng âm thanh';

  @override
  String get effectSoundDescription => 'Phát âm thanh hiệu ứng';

  @override
  String get email => 'Email';

  @override
  String get emailHint => 'example@email.com';

  @override
  String get emailLabel => 'Email';

  @override
  String get emailRequired => 'Vui lòng nhập email';

  @override
  String get emotionAnalysis => 'Phân tích cảm xúc';

  @override
  String get emotionAnalysisDesc => 'Phân tích cảm xúc';

  @override
  String get emotionAngry => 'Giận dữ';

  @override
  String get emotionBasedEncounters =>
      'Gặp gỡ nhân vật dựa trên cảm xúc của bạn';

  @override
  String get emotionCool => 'Ngầu';

  @override
  String get emotionHappy => 'Hạnh phúc';

  @override
  String get emotionLove => 'Yêu';

  @override
  String get emotionSad => 'Buồn';

  @override
  String get emotionThinking => 'Đang suy nghĩ';

  @override
  String get emotionalSupportDesc => 'Nhận hỗ trợ tinh thần';

  @override
  String get endChat => 'Kết thúc trò chuyện';

  @override
  String get endTutorial => 'Kết thúc hướng dẫn';

  @override
  String get endTutorialAndLogin => 'Kết thúc hướng dẫn và đăng nhập?';

  @override
  String get endTutorialMessage => 'Kết thúc hướng dẫn';

  @override
  String get english => 'Tiếng Anh';

  @override
  String get enterBasicInfo =>
      'Vui lòng nhập thông tin cơ bản để tạo tài khoản';

  @override
  String get enterBasicInformation => 'Nhập thông tin cơ bản';

  @override
  String get enterEmail => 'Nhập email';

  @override
  String get enterNickname => 'Vui lòng nhập một biệt danh';

  @override
  String get enterPassword => 'Vui lòng nhập mật khẩu';

  @override
  String get entertainmentAndFunDesc => 'Giải trí và vui vẻ';

  @override
  String get entertainmentDescription => 'Giải trí';

  @override
  String get entertainmentFun => 'Giải trí/Vui chơi';

  @override
  String get error => 'Lỗi';

  @override
  String get errorDescription => 'Mô tả lỗi';

  @override
  String get errorDescriptionHint =>
      'ví dụ, Đưa ra câu trả lời lạ, Lặp lại cùng một điều, Đưa ra phản hồi không phù hợp với ngữ cảnh...';

  @override
  String get errorDetails => 'Chi tiết lỗi';

  @override
  String get errorDetailsHint => 'Mô tả chi tiết lỗi';

  @override
  String get errorFrequency24h => 'Tần suất lỗi (24 giờ qua)';

  @override
  String get errorMessage => 'Thông báo lỗi:';

  @override
  String get errorOccurred => 'Đã xảy ra lỗi';

  @override
  String get errorOccurredTryAgain => 'Đã xảy ra lỗi. Vui lòng thử lại.';

  @override
  String get errorSendingFailed => 'Gửi lỗi không thành công';

  @override
  String get errorStats => 'Thống kê lỗi';

  @override
  String errorWithMessage(String error) {
    return 'Lỗi xảy ra: $error';
  }

  @override
  String get evening => 'Buổi tối';

  @override
  String get excited => 'Phấn khích';

  @override
  String get exit => 'Thoát';

  @override
  String get exitApp => 'Thoát ứng dụng';

  @override
  String get exitConfirmMessage =>
      'Bạn có chắc chắn muốn thoát ứng dụng không?';

  @override
  String get expertPersona => 'Persona chuyên gia';

  @override
  String get expertiseScore => 'Điểm chuyên môn';

  @override
  String get expired => 'Đã hết hạn';

  @override
  String get explainReportReason => 'Giải thích lý do báo cáo';

  @override
  String get fashion => 'Thời trang';

  @override
  String get female => 'Nữ';

  @override
  String get filter => 'Lọc';

  @override
  String get firstOccurred => 'Lần đầu xảy ra:';

  @override
  String get followDeviceLanguage => 'Theo cài đặt ngôn ngữ của thiết bị';

  @override
  String get forenoon => 'Buổi sáng';

  @override
  String get forgotPassword => 'Quên mật khẩu?';

  @override
  String get frequentlyAskedQuestions => 'Câu hỏi thường gặp';

  @override
  String get friday => 'Thứ Sáu';

  @override
  String get friendshipDescription => 'Tìm kiếm tình bạn';

  @override
  String get funChat => 'Trò Chuyện Vui';

  @override
  String get galleryPermission => 'Quyền truy cập thư viện';

  @override
  String get galleryPermissionDesc => 'Cần quyền thư viện để chọn ảnh';

  @override
  String get gaming => 'Chơi game';

  @override
  String get gender => 'Giới tính';

  @override
  String get genderNotSelectedInfo =>
      'Nếu không chọn giới tính, bạn sẽ thấy các nhân vật của tất cả các giới tính';

  @override
  String get genderOptional => 'Giới tính (tùy chọn)';

  @override
  String get genderPreferenceActive =>
      'Bạn có thể gặp các nhân vật của tất cả các giới tính';

  @override
  String get genderPreferenceDisabled =>
      'Chọn giới tính của bạn để kích hoạt tùy chọn chỉ giới tính đối diện';

  @override
  String get genderPreferenceInactive =>
      'Chỉ các nhân vật giới tính đối diện sẽ được hiển thị';

  @override
  String get genderRequired => 'Vui lòng chọn giới tính';

  @override
  String get genderSelectionInfo =>
      'Nếu không chọn, bạn có thể gặp các nhân vật của tất cả các giới tính';

  @override
  String get generalPersona => 'Nhân vật tổng quát';

  @override
  String get goToSettings => 'Đến cài đặt';

  @override
  String get googleLoginCanceled => 'Đăng nhập Google đã hủy';

  @override
  String get googleLoginError =>
      'Đã xảy ra lỗi trong quá trình đăng nhập Google.';

  @override
  String get grantPermission => 'Tiếp tục';

  @override
  String get guest => 'Khách';

  @override
  String get guestDataMigration => 'Chuyển dữ liệu khách';

  @override
  String get guestLimitReached => 'Đã đạt giới hạn khách';

  @override
  String get guestLoginPromptMessage => 'Đăng nhập để tiếp tục cuộc trò chuyện';

  @override
  String get guestMessageExhausted => 'Tin nhắn miễn phí đã hết';

  @override
  String guestMessageRemaining(int count) {
    return '$count tin nhắn khách còn lại';
  }

  @override
  String get guestModeBanner => 'Chế độ Khách';

  @override
  String get guestModeDescription => 'Chế độ khách';

  @override
  String get guestModeFailedMessage =>
      'Khởi động Chế độ Khách không thành công';

  @override
  String get guestModeLimitation => 'Giới hạn chế độ khách';

  @override
  String get guestModeTitle => 'Thử nghiệm với tư cách Khách';

  @override
  String get guestModeWarning => 'Cảnh báo chế độ khách';

  @override
  String get guestModeWelcome => 'Bắt đầu ở Chế độ Khách';

  @override
  String get happy => 'Vui vẻ';

  @override
  String get hapticFeedback => 'Phản hồi xúc giác';

  @override
  String get harassmentBullying => 'Quấy rối/Bắt nạt';

  @override
  String get hateSpeech => 'Ngôn từ thù ghét';

  @override
  String get heartDescription => 'Tim để gửi thêm tin nhắn';

  @override
  String get heartInsufficient => 'Không đủ tim';

  @override
  String get heartInsufficientPleaseCharge =>
      'Không đủ tim. Vui lòng nạp thêm!';

  @override
  String get heartRequired => 'Cần 1 trái tim';

  @override
  String get heartUsageFailed => 'Sử dụng trái tim không thành công.';

  @override
  String get hearts => 'Tim';

  @override
  String get hearts10 => '10 Trái tim';

  @override
  String get hearts30 => '30 Trái tim';

  @override
  String get hearts30Discount => '30 Trái tim (Giảm giá)';

  @override
  String get hearts50 => '50 Trái tim';

  @override
  String get hearts50Discount => '50 Trái tim (Giảm giá)';

  @override
  String get helloEmoji => 'Xin chào! 😊';

  @override
  String get help => 'Trợ giúp';

  @override
  String get hideOriginalText => 'Ẩn văn bản gốc';

  @override
  String get hobbySharing => 'Chia sẻ sở thích';

  @override
  String get hobbyTalk => 'Nói chuyện về sở thích';

  @override
  String get hours24Ago => '24 giờ trước';

  @override
  String hoursAgo(int count, String formatted) {
    return '$count giờ trước';
  }

  @override
  String get howToUse => 'Cách sử dụng';

  @override
  String get imageCacheManagement => 'Quản lý bộ nhớ cache hình ảnh';

  @override
  String get inappropriateContent => 'Nội dung không phù hợp';

  @override
  String get incorrect => 'không chính xác';

  @override
  String get incorrectPassword => 'Mật khẩu không chính xác';

  @override
  String get indonesian => 'Tiếng Indonesia';

  @override
  String get inquiries => 'Thắc mắc';

  @override
  String get insufficientHearts => 'Không đủ tim';

  @override
  String get interestSharing => 'Chia sẻ sở thích';

  @override
  String get interestSharingDesc => 'Chia sẻ sở thích';

  @override
  String get interests => 'Sở thích';

  @override
  String get invalidEmailFormat => 'Định dạng email không hợp lệ';

  @override
  String get invalidEmailFormatError => 'Vui lòng nhập địa chỉ email hợp lệ';

  @override
  String isTyping(String name) {
    return '$name đang nhập...';
  }

  @override
  String get japanese => 'Tiếng Nhật';

  @override
  String get joinDate => 'Ngày tham gia';

  @override
  String get justNow => 'Vừa xong';

  @override
  String get keepGuestData => 'Lưu lịch sử trò chuyện';

  @override
  String get korean => 'Tiếng Hàn';

  @override
  String get koreanLanguage => 'Tiếng Hàn';

  @override
  String get language => 'Ngôn ngữ';

  @override
  String get languageDescription => 'Chọn ngôn ngữ hiển thị';

  @override
  String get languageIndicator => 'Ngôn ngữ';

  @override
  String get languageSettings => 'Cài đặt ngôn ngữ';

  @override
  String get lastOccurred => 'Lần cuối xảy ra:';

  @override
  String get lastUpdated => 'Cập nhật lần cuối';

  @override
  String get lateNight => 'Đêm muộn';

  @override
  String get later => 'Sau này';

  @override
  String get laterButton => 'Sau';

  @override
  String get leave => 'Rời đi';

  @override
  String get leaveChatConfirm =>
      'Bạn có chắc chắn muốn rời khỏi cuộc trò chuyện này không? Nó sẽ biến mất khỏi danh sách trò chuyện của bạn.';

  @override
  String get leaveChatRoom => 'Rời khỏi phòng chat';

  @override
  String get leaveChatTitle => 'Rời khỏi cuộc trò chuyện';

  @override
  String get lifeAdvice => 'Lời Khuyên Cuộc Sống';

  @override
  String get lightTalk => 'Trò Chuyện Nhẹ Nhàng';

  @override
  String get lightTheme => 'Chế Độ Sáng';

  @override
  String get lightThemeDesc => 'Sử dụng giao diện sáng';

  @override
  String get loading => 'Đang tải...';

  @override
  String get loadingData => 'Đang tải dữ liệu...';

  @override
  String get loadingProducts => 'Đang tải sản phẩm...';

  @override
  String get loadingProfile => 'Đang tải hồ sơ';

  @override
  String get login => 'Đăng nhập';

  @override
  String get loginButton => 'Đăng nhập';

  @override
  String get loginCancelled => 'Đăng nhập đã hủy';

  @override
  String get loginComplete => 'Đăng nhập thành công';

  @override
  String get loginError => 'Lỗi đăng nhập';

  @override
  String get loginFailed => 'Đăng nhập thất bại';

  @override
  String get loginFailedTryAgain => 'Đăng nhập thất bại. Vui lòng thử lại.';

  @override
  String get loginRequired => 'Cần đăng nhập';

  @override
  String get loginRequiredForProfile =>
      'Cần đăng nhập để xem hồ sơ và kiểm tra các bản ghi với SONA';

  @override
  String get loginRequiredService => 'Cần đăng nhập để sử dụng dịch vụ này';

  @override
  String get loginRequiredTitle => 'Cần Đăng Nhập';

  @override
  String get loginSignup => 'Đăng nhập/Đăng ký';

  @override
  String get loginTab => 'Đăng nhập';

  @override
  String get loginTitle => 'Đăng Nhập';

  @override
  String get loginWithApple => 'Đăng nhập bằng Apple';

  @override
  String get loginWithGoogle => 'Đăng nhập bằng Google';

  @override
  String get logout => 'Đăng xuất';

  @override
  String get logoutConfirm => 'Bạn có chắc chắn muốn đăng xuất không?';

  @override
  String get lonelinessRelief => 'Giảm Cảm Giác Cô Đơn';

  @override
  String get lonely => 'Cô đơn';

  @override
  String get lowQualityResponses => 'Phản Hồi Chất Lượng Thấp';

  @override
  String get lunch => 'Bữa trưa';

  @override
  String get lunchtime => 'Giờ ăn trưa';

  @override
  String get mainErrorType => 'Loại lỗi chính';

  @override
  String get makeFriends => 'Kết bạn';

  @override
  String get male => 'Nam';

  @override
  String get manageBlockedAIs => 'Quản lý AI bị chặn';

  @override
  String get managePersonaImageCache => 'Quản lý bộ nhớ hình ảnh persona';

  @override
  String get marketingAgree => 'Đồng ý nhận marketing';

  @override
  String get marketingDescription => 'Nhận thông tin khuyến mãi';

  @override
  String get matchPersonaStep =>
      '1. Ghép Persona: Vuốt trái hoặc phải để chọn những persona AI yêu thích của bạn.';

  @override
  String get matchedPersonas => 'Personas đã ghép đôi';

  @override
  String get matchedSona => 'Sona đã ghép';

  @override
  String get matching => 'Đang ghép';

  @override
  String get matchingFailed => 'Ghép đôi thất bại';

  @override
  String get me => 'Tôi';

  @override
  String get meetAIPersonas => 'Gặp gỡ các nhân vật AI';

  @override
  String get meetNewPersonas => 'Gặp gỡ các Persona mới';

  @override
  String get meetPersonas => 'Gặp gỡ nhân vật';

  @override
  String get memberBenefits =>
      'Nhận 100+ tin nhắn và 10 trái tim khi bạn đăng ký!';

  @override
  String get memoryAlbum => 'Album kỷ niệm';

  @override
  String get memoryAlbumDesc => 'Album kỷ niệm';

  @override
  String get messageCopied => 'Đã sao chép tin nhắn';

  @override
  String get messageDeleted => 'Tin nhắn đã xóa';

  @override
  String get messageLimitReset =>
      'Giới hạn tin nhắn sẽ được đặt lại vào nửa đêm';

  @override
  String get messageSendFailed =>
      'Gửi tin nhắn không thành công. Vui lòng thử lại.';

  @override
  String get messagesRemaining => 'Tin nhắn còn lại';

  @override
  String minutesAgo(int count, String formatted) {
    return '$count phút trước';
  }

  @override
  String get missingTranslation => 'Thiếu bản dịch';

  @override
  String get monday => 'Thứ Hai';

  @override
  String get month => 'Tháng';

  @override
  String monthDay(String month, int day) {
    return '$month ngày $day';
  }

  @override
  String get moreButton => 'Xem thêm';

  @override
  String get morning => 'Buổi sáng';

  @override
  String get mostFrequentError => 'Lỗi thường gặp nhất';

  @override
  String get movies => 'Phim ảnh';

  @override
  String get multilingualChat => 'Trò chuyện đa ngôn ngữ';

  @override
  String get music => 'Âm nhạc';

  @override
  String get myGenderSection => 'Giới tính của tôi';

  @override
  String get networkErrorOccurred => 'Đã xảy ra lỗi mạng.';

  @override
  String get newMessage => 'Tin nhắn mới';

  @override
  String newMessageCount(int count) {
    return '$count tin nhắn mới';
  }

  @override
  String get newMessageNotification => 'Thông báo cho tôi về tin nhắn mới';

  @override
  String get newMessages => 'Tin nhắn mới';

  @override
  String get newYear => 'Năm mới';

  @override
  String get next => 'Tiếp theo';

  @override
  String get niceToMeetYou => 'Rất vui được gặp bạn!';

  @override
  String get nickname => 'Biệt danh';

  @override
  String get nicknameAlreadyUsed => 'Biệt danh này đã được sử dụng';

  @override
  String get nicknameHelperText => '3-10 ký tự';

  @override
  String get nicknameHint => 'Nhập biệt danh';

  @override
  String get nicknameInUse => 'Biệt danh này đã được sử dụng';

  @override
  String get nicknameLabel => 'Biệt danh';

  @override
  String get nicknameLengthError => 'Biệt danh phải từ 3-10 ký tự';

  @override
  String get nicknamePlaceholder => 'Nhập biệt danh của bạn';

  @override
  String get nicknameRequired => 'Vui lòng nhập biệt danh';

  @override
  String get night => 'Đêm';

  @override
  String get no => 'Không';

  @override
  String get noBlockedAIs => 'Không có AI nào bị chặn';

  @override
  String get noChatsYet => 'Chưa có cuộc trò chuyện nào';

  @override
  String get noConversationYet => 'Chưa có cuộc trò chuyện nào';

  @override
  String get noErrorReports => 'Không có báo cáo lỗi.';

  @override
  String get noImageAvailable => 'Không có hình ảnh nào';

  @override
  String get noMatchedPersonas => 'Chưa có nhân vật nào phù hợp';

  @override
  String get noMatchedSonas => 'Chưa có SONA nào phù hợp';

  @override
  String get noPersonasAvailable => 'Không có nhân vật nào';

  @override
  String get noPersonasToSelect => 'Không có nhân vật nào để chọn';

  @override
  String get noQualityIssues => 'Không có vấn đề chất lượng trong giờ qua ✅';

  @override
  String get noQualityLogs => 'Chưa có nhật ký chất lượng nào.';

  @override
  String get noTranslatedMessages => 'Không có tin nhắn nào để dịch';

  @override
  String get notEnoughHearts => 'Không đủ trái tim';

  @override
  String notEnoughHeartsCount(int count) {
    return 'Cần $count tim';
  }

  @override
  String get notRegistered => 'chưa đăng ký';

  @override
  String get notSubscribed => 'Chưa đăng ký';

  @override
  String get notificationPermissionDesc =>
      'Cho phép thông báo để nhận tin nhắn';

  @override
  String get notificationPermissionRequired => 'Cần quyền thông báo';

  @override
  String get notificationSettings => 'Cài đặt thông báo';

  @override
  String get notifications => 'Thông báo';

  @override
  String get occurrenceInfo => 'Thông tin sự kiện:';

  @override
  String get olderChats => 'Cũ hơn';

  @override
  String get onlyOppositeGenderNote => 'Chỉ hiển thị giới tính khác';

  @override
  String get openSettings => 'Mở cài đặt';

  @override
  String get optional => 'Tùy chọn';

  @override
  String get or => 'hoặc';

  @override
  String get originalPrice => 'Giá gốc';

  @override
  String get originalText => 'Gốc';

  @override
  String get other => 'Khác';

  @override
  String get otherError => 'Lỗi khác';

  @override
  String get others => 'Khác';

  @override
  String get ownedHearts => 'Trái tim sở hữu';

  @override
  String get parentsDay => 'Ngày của Cha Mẹ';

  @override
  String get password => 'Mật khẩu';

  @override
  String get passwordConfirmation => 'Nhập mật khẩu để xác nhận';

  @override
  String get passwordConfirmationDesc => 'Xác nhận mật khẩu để tiếp tục';

  @override
  String get passwordHint => 'Nhập mật khẩu';

  @override
  String get passwordLabel => 'Mật khẩu';

  @override
  String get passwordRequired => 'Vui lòng nhập mật khẩu';

  @override
  String get passwordResetEmailPrompt => 'Nhập email để đặt lại mật khẩu';

  @override
  String get passwordResetEmailSent => 'Email đặt lại mật khẩu đã gửi';

  @override
  String get passwordText => 'mật khẩu';

  @override
  String get passwordTooShort => 'Mật khẩu phải có ít nhất 6 ký tự';

  @override
  String get permissionDenied => 'Quyền truy cập bị từ chối';

  @override
  String permissionDeniedMessage(String permissionName) {
    return 'Quyền $permissionName bị từ chối.\nVui lòng cho phép trong cài đặt.';
  }

  @override
  String get permissionDeniedTryLater =>
      'Quyền bị từ chối. Vui lòng thử lại sau.';

  @override
  String get permissionRequired => 'Yêu cầu quyền truy cập';

  @override
  String get personaGenderSection => 'Giới tính nhân vật';

  @override
  String personaQualityStats(Object personaQualityStats) {
    return 'Thống kê chất lượng nhân vật';
  }

  @override
  String personalInfoExposure(Object personalInfoExposure) {
    return 'Tiết lộ thông tin cá nhân';
  }

  @override
  String personality(Object personality) {
    return 'Tính cách';
  }

  @override
  String pets(Object pets) {
    return 'Thú cưng';
  }

  @override
  String get photo => 'Ảnh';

  @override
  String photography(Object photography) {
    return 'Nhiếp ảnh';
  }

  @override
  String picnic(Object picnic) {
    return 'Dã ngoại';
  }

  @override
  String preferenceSettings(Object preferenceSettings) {
    return 'Cài đặt ưu tiên';
  }

  @override
  String preferredLanguage(Object preferredLanguage) {
    return 'Ngôn ngữ ưa thích';
  }

  @override
  String get preparingForSleep => 'Chuẩn bị đi ngủ';

  @override
  String get preparingNewMeeting => 'Chuẩn bị cuộc họp mới';

  @override
  String get preparingPersonaImages => 'Chuẩn bị hình ảnh nhân vật';

  @override
  String get preparingPersonas => 'Đang chuẩn bị personas';

  @override
  String get preview => 'Xem trước';

  @override
  String get previous => 'Trước';

  @override
  String get privacy => 'Quyền riêng tư';

  @override
  String get privacyPolicy => 'Chính sách bảo mật';

  @override
  String get privacyPolicyAgreement => 'Vui lòng đồng ý với chính sách bảo mật';

  @override
  String get privacySection1Content =>
      'Chúng tôi cam kết bảo vệ quyền riêng tư của bạn. Chính sách Bảo mật này giải thích cách chúng tôi thu thập, sử dụng và bảo vệ thông tin của bạn khi bạn sử dụng dịch vụ của chúng tôi.';

  @override
  String get privacySection1Title => 'Thu thập thông tin';

  @override
  String get privacySection2Content =>
      'Chúng tôi thu thập thông tin bạn cung cấp trực tiếp cho chúng tôi, chẳng hạn như khi bạn tạo tài khoản, cập nhật hồ sơ hoặc sử dụng dịch vụ của chúng tôi.';

  @override
  String get privacySection2Title => 'Thông tin chúng tôi thu thập';

  @override
  String get privacySection3Content =>
      'Chúng tôi sử dụng thông tin mà chúng tôi thu thập để cung cấp, duy trì và cải thiện dịch vụ của chúng tôi, cũng như để giao tiếp với bạn.';

  @override
  String get privacySection3Title => 'Chia sẻ thông tin';

  @override
  String get privacySection4Content =>
      'Chúng tôi không bán, trao đổi hoặc chuyển nhượng thông tin cá nhân của bạn cho bên thứ ba mà không có sự đồng ý của bạn.';

  @override
  String get privacySection4Title => 'Bảo mật thông tin';

  @override
  String get privacySection5Content =>
      'Chúng tôi thực hiện các biện pháp bảo mật thích hợp để bảo vệ thông tin cá nhân của bạn khỏi việc truy cập, thay đổi, tiết lộ hoặc phá hủy trái phép.';

  @override
  String get privacySection5Title => 'Quyền của người dùng';

  @override
  String get privacySection6Content =>
      'Chúng tôi giữ thông tin cá nhân trong thời gian cần thiết để cung cấp dịch vụ của chúng tôi và tuân thủ các nghĩa vụ pháp lý.';

  @override
  String get privacySection6Title => '6. Quyền của người dùng';

  @override
  String get privacySection7Content =>
      'Bạn có quyền truy cập, cập nhật hoặc xóa thông tin cá nhân của mình bất cứ lúc nào thông qua cài đặt tài khoản của bạn.';

  @override
  String get privacySection7Title => 'Quyền của bạn';

  @override
  String get privacySection8Content =>
      'Nếu bạn có bất kỳ câu hỏi nào về Chính sách Bảo mật này, vui lòng liên hệ với chúng tôi tại support@sona.com.';

  @override
  String get privacySection8Title => 'Liên hệ với chúng tôi';

  @override
  String get privacySettings => 'Cài đặt quyền riêng tư';

  @override
  String get privacySettingsInfo => 'Thông tin cài đặt riêng tư';

  @override
  String get privacySettingsScreen => 'Cài đặt quyền riêng tư';

  @override
  String get problemMessage => 'Vấn đề';

  @override
  String get problemOccurred => 'Đã xảy ra vấn đề';

  @override
  String get profile => 'Hồ sơ';

  @override
  String get profileEdit => 'Chỉnh sửa hồ sơ';

  @override
  String get profileEditLoginRequiredMessage => 'Cần đăng nhập để sửa hồ sơ';

  @override
  String get profileInfo => 'Thông tin hồ sơ';

  @override
  String get profileInfoDescription => 'Thông tin hồ sơ';

  @override
  String get profileNav => 'Hồ sơ';

  @override
  String get profilePhoto => 'Ảnh hồ sơ';

  @override
  String get profilePhotoAndInfo =>
      'Vui lòng nhập ảnh hồ sơ và thông tin cơ bản';

  @override
  String get profilePhotoUpdateFailed => 'Cập nhật ảnh hồ sơ không thành công';

  @override
  String get profilePhotoUpdated => 'Ảnh đại diện đã được cập nhật';

  @override
  String get profileSettings => 'Cài đặt hồ sơ';

  @override
  String get profileSetup => 'Đang thiết lập hồ sơ';

  @override
  String get profileUpdateFailed => 'Cập nhật hồ sơ không thành công';

  @override
  String get profileUpdated => 'Hồ sơ đã được cập nhật thành công';

  @override
  String get purchaseAndRefundPolicy => 'Chính sách Mua hàng & Hoàn tiền';

  @override
  String get purchaseButton => 'Mua ngay';

  @override
  String get purchaseConfirm => 'Xác nhận mua';

  @override
  String purchaseConfirmContent(String product, String price) {
    return 'Bạn sẽ mua $product với giá $price';
  }

  @override
  String purchaseConfirmMessage(
      String title, String price, String description) {
    return 'Xác nhận mua $title với giá $price? $description';
  }

  @override
  String get purchaseFailed => 'Mua hàng không thành công';

  @override
  String get purchaseHeartsOnly => 'Chỉ mua tim';

  @override
  String get purchaseMoreHearts => 'Mua thêm tim';

  @override
  String get purchasePending => 'Đang xử lý mua hàng...';

  @override
  String get purchasePolicy => 'Chính sách Mua hàng';

  @override
  String get purchaseSection1Content =>
      'Chúng tôi chấp nhận nhiều phương thức thanh toán bao gồm thẻ tín dụng và ví điện tử.';

  @override
  String get purchaseSection1Title => 'Phương thức Thanh toán';

  @override
  String get purchaseSection2Content =>
      'Hoàn tiền có sẵn trong vòng 14 ngày kể từ ngày mua nếu bạn chưa sử dụng các mặt hàng đã mua.';

  @override
  String get purchaseSection2Title => 'Chính sách Hoàn tiền';

  @override
  String get purchaseSection3Content =>
      'Bạn có thể hủy đăng ký bất cứ lúc nào thông qua cài đặt tài khoản của bạn.';

  @override
  String get purchaseSection3Title => 'Hủy bỏ';

  @override
  String get purchaseSection4Content =>
      'Bằng việc thực hiện giao dịch mua, bạn đồng ý với các điều khoản sử dụng và thỏa thuận dịch vụ của chúng tôi.';

  @override
  String get purchaseSection4Title => 'Điều khoản Sử dụng';

  @override
  String get purchaseSection5Content =>
      'Đối với các vấn đề liên quan đến mua hàng, vui lòng liên hệ với đội ngũ hỗ trợ của chúng tôi.';

  @override
  String get purchaseSection5Title => 'Liên hệ Hỗ trợ';

  @override
  String get purchaseSection6Content =>
      'Tất cả các giao dịch mua đều phải tuân theo các điều khoản và điều kiện tiêu chuẩn của chúng tôi.';

  @override
  String get purchaseSection6Title => '6. Thắc mắc';

  @override
  String get pushNotifications => 'Thông báo đẩy';

  @override
  String get reading => 'Đọc';

  @override
  String get realtimeQualityLog => 'Nhật ký chất lượng thời gian thực';

  @override
  String get recentConversation => 'Cuộc trò chuyện gần đây:';

  @override
  String get recentLoginRequired => 'Vui lòng đăng nhập lại để đảm bảo an toàn';

  @override
  String get referrerEmail => 'Email người giới thiệu';

  @override
  String get referrerEmailHelper =>
      'Tùy chọn: Email của người đã giới thiệu bạn';

  @override
  String get referrerEmailLabel => 'Email người giới thiệu';

  @override
  String get refresh => 'Làm mới';

  @override
  String refreshComplete(int count) {
    return 'Đã làm mới $count mục';
  }

  @override
  String get refreshFailed => 'Làm mới không thành công';

  @override
  String get refreshingChatList => 'Đang làm mới danh sách trò chuyện...';

  @override
  String get relatedFAQ => 'FAQ liên quan';

  @override
  String get report => 'Báo cáo';

  @override
  String get reportAI => 'Báo cáo AI';

  @override
  String get reportAIDescription => 'Báo cáo hành vi không phù hợp của AI';

  @override
  String get reportAITitle => 'Báo cáo cuộc trò chuyện AI';

  @override
  String get reportAndBlock => 'Báo cáo & Chặn';

  @override
  String get reportAndBlockDescription => 'Báo cáo và chặn';

  @override
  String get reportChatError => 'Báo cáo lỗi trò chuyện';

  @override
  String reportError(String error) {
    return 'Lỗi xảy ra khi báo cáo: $error';
  }

  @override
  String get reportFailed => 'Báo cáo không thành công';

  @override
  String get reportSubmitted => 'Đã gửi báo cáo';

  @override
  String get reportSubmittedSuccess => 'Báo cáo thành công';

  @override
  String get requestLimit => 'Giới hạn yêu cầu';

  @override
  String get required => 'Bắt buộc';

  @override
  String get requiredTermsAgreement => 'Vui lòng đồng ý với các điều khoản';

  @override
  String get restartConversation => 'Khởi động lại cuộc trò chuyện';

  @override
  String restartConversationQuestion(String name) {
    return 'Bạn có muốn bắt đầu lại cuộc trò chuyện với $name không?';
  }

  @override
  String restartConversationWithName(String name) {
    return 'Bắt đầu lại với $name';
  }

  @override
  String get retry => 'Thử lại';

  @override
  String get retryButton => 'Thử lại';

  @override
  String get sad => 'Buồn';

  @override
  String get saturday => 'Thứ Bảy';

  @override
  String get save => 'Lưu';

  @override
  String get search => 'Tìm kiếm';

  @override
  String get searchFAQ => 'Tìm kiếm FAQ';

  @override
  String get searchResults => 'Kết quả tìm kiếm';

  @override
  String get selectEmotion => 'Chọn cảm xúc';

  @override
  String get selectErrorType => 'Chọn loại lỗi';

  @override
  String get selectFeeling => 'Bạn cảm thấy thế nào?';

  @override
  String get selectGender => 'Chọn giới tính';

  @override
  String get selectInterests => 'Chọn sở thích';

  @override
  String get selectLanguage => 'Chọn ngôn ngữ';

  @override
  String get selectPersona => 'Chọn một nhân vật';

  @override
  String get selectPersonaPlease => 'Vui lòng chọn một nhân vật.';

  @override
  String get selectPreferredMbti => 'Chọn MBTI ưa thích';

  @override
  String get selectProblematicMessage => 'Chọn tin nhắn có vấn đề (tùy chọn)';

  @override
  String get selectReportReason => 'Chọn lý do báo cáo';

  @override
  String get selectTheme => 'Chọn giao diện';

  @override
  String get selectTranslationError => 'Chọn lỗi dịch thuật';

  @override
  String get selectUsagePurpose => 'Vui lòng chọn mục đích sử dụng SONA';

  @override
  String get selfIntroduction => 'Giới thiệu bản thân';

  @override
  String get selfIntroductionHint => 'Hãy viết vài dòng về bản thân';

  @override
  String get send => 'Gửi';

  @override
  String get sendChatError => 'Lỗi gửi chat';

  @override
  String get sendFirstMessage => 'Gửi tin nhắn đầu tiên của bạn';

  @override
  String get sendReport => 'Gửi báo cáo';

  @override
  String get sendingEmail => 'Đang gửi email...';

  @override
  String get seoul => 'Seoul';

  @override
  String get serverErrorDashboard => 'Lỗi máy chủ';

  @override
  String get serviceTermsAgreement =>
      'Vui lòng đồng ý với các điều khoản dịch vụ';

  @override
  String get sessionExpired => 'Phiên đã hết hạn';

  @override
  String get setAppInterfaceLanguage => 'Đặt ngôn ngữ giao diện ứng dụng';

  @override
  String get setNow => 'Thiết lập ngay';

  @override
  String get settings => 'Cài đặt';

  @override
  String get sexualContent => 'Nội dung khiêu dâm';

  @override
  String get showAllGenderPersonas => 'Hiển thị tất cả giới tính personas';

  @override
  String get showAllGendersOption => 'Hiển thị tất cả giới tính';

  @override
  String get showOppositeGenderOnly =>
      'Nếu không chọn, chỉ hiển thị các nhân vật giới tính đối diện';

  @override
  String get showOriginalText => 'Hiển thị gốc';

  @override
  String get signUp => 'Đăng ký';

  @override
  String get signUpFromGuest => 'Đăng ký từ khách';

  @override
  String get signup => 'Đăng ký';

  @override
  String get signupComplete => 'Đăng ký hoàn tất';

  @override
  String get signupTab => 'Đăng ký';

  @override
  String get simpleInfoRequired => 'Cần thông tin cơ bản';

  @override
  String get skip => 'Bỏ qua';

  @override
  String get sonaFriend => 'Bạn SONA';

  @override
  String get sonaPrivacyPolicy => 'Chính sách bảo mật của SONA';

  @override
  String get sonaPurchasePolicy => 'Chính sách mua hàng của SONA';

  @override
  String get sonaTermsOfService => 'Điều khoản dịch vụ của SONA';

  @override
  String get sonaUsagePurpose => 'Mục đích sử dụng SONA';

  @override
  String get sorryNotHelpful => 'Xin lỗi, điều này không hữu ích';

  @override
  String get sort => 'Sắp xếp';

  @override
  String get soundSettings => 'Cài đặt âm thanh';

  @override
  String get spamAdvertising => 'Spam/Quảng cáo';

  @override
  String get spanish => 'Tiếng Tây Ban Nha';

  @override
  String get specialRelationshipDesc => 'Xây dựng mối quan hệ đặc biệt';

  @override
  String get sports => 'Thể thao';

  @override
  String get spring => 'Mùa xuân';

  @override
  String get startChat => 'Bắt đầu trò chuyện';

  @override
  String get startChatButton => 'Bắt đầu chat';

  @override
  String get startConversation => 'Bắt đầu cuộc trò chuyện';

  @override
  String get startConversationLikeAFriend =>
      'Bắt đầu cuộc trò chuyện với SONA như một người bạn';

  @override
  String get startConversationStep =>
      '2. Bắt đầu cuộc trò chuyện: Trò chuyện tự do với các nhân vật đã ghép nối.';

  @override
  String get startConversationWithSona => 'Bắt đầu trò chuyện với SONA';

  @override
  String get startWithEmail => 'Bắt đầu với Email';

  @override
  String get startWithGoogle => 'Bắt đầu với Google';

  @override
  String get startingApp => 'Đang khởi động ứng dụng';

  @override
  String get storageManagement => 'Quản lý bộ nhớ';

  @override
  String get store => 'Cửa hàng';

  @override
  String get storeConnectionError => 'Không thể kết nối đến cửa hàng';

  @override
  String get storeLoginRequiredMessage => 'Cần đăng nhập để vào cửa hàng';

  @override
  String get storeNotAvailable => 'Cửa hàng không khả dụng';

  @override
  String get storyEvent => 'Sự kiện câu chuyện';

  @override
  String get stressed => 'Căng thẳng';

  @override
  String get submitReport => 'Gửi báo cáo';

  @override
  String get subscriptionStatus => 'Trạng thái đăng ký';

  @override
  String get subtleVibrationOnTouch => 'Rung nhẹ khi chạm';

  @override
  String get summer => 'Mùa hè';

  @override
  String get sunday => 'Chủ nhật';

  @override
  String get swipeAnyDirection => 'Vuốt theo bất kỳ hướng nào';

  @override
  String get swipeDownToClose => 'Vuốt xuống để đóng';

  @override
  String get systemTheme => 'Theo hệ thống';

  @override
  String get systemThemeDesc => 'Theo hệ thống';

  @override
  String get tapBottomForDetails => 'Chạm phía dưới để xem chi tiết';

  @override
  String get tapForDetails => 'Chạm vào khu vực dưới để xem chi tiết';

  @override
  String get tapToSwipePhotos => 'Chạm để vuốt ảnh';

  @override
  String get teachersDay => 'Ngày Nhà giáo';

  @override
  String get technicalError => 'Lỗi kỹ thuật';

  @override
  String get technology => 'Công nghệ';

  @override
  String get terms => 'Điều khoản';

  @override
  String get termsAgreement => 'Đồng ý điều khoản';

  @override
  String get termsAgreementDescription => 'Đồng ý với điều khoản';

  @override
  String get termsOfService => 'Điều khoản dịch vụ';

  @override
  String get termsSection10Content =>
      'Chúng tôi có quyền sửa đổi các điều khoản này bất cứ lúc nào với thông báo cho người dùng.';

  @override
  String get termsSection10Title => 'Điều 10 (Giải quyết tranh chấp)';

  @override
  String get termsSection11Content =>
      'Các điều khoản này sẽ được điều chỉnh bởi luật pháp của khu vực mà chúng tôi hoạt động.';

  @override
  String get termsSection11Title =>
      'Điều 11 (Các quy định đặc biệt về dịch vụ AI)';

  @override
  String get termsSection12Content =>
      'Nếu bất kỳ điều khoản nào trong các điều khoản này bị coi là không thể thi hành, các điều khoản còn lại sẽ tiếp tục có hiệu lực đầy đủ.';

  @override
  String get termsSection12Title => 'Điều 12 (Thu thập và Sử dụng Dữ liệu)';

  @override
  String get termsSection1Content => 'Nội dung điều khoản 1';

  @override
  String get termsSection1Title => 'Điều 1 (Mục đích)';

  @override
  String get termsSection2Content =>
      'Bằng cách sử dụng dịch vụ của chúng tôi, bạn đồng ý tuân thủ các Điều khoản Dịch vụ này và Chính sách Bảo mật của chúng tôi.';

  @override
  String get termsSection2Title => 'Điều 2 (Định nghĩa)';

  @override
  String get termsSection3Content =>
      'Bạn phải ít nhất 13 tuổi để sử dụng dịch vụ của chúng tôi.';

  @override
  String get termsSection3Title => 'Điều 3 (Hiệu lực và Sửa đổi Điều khoản)';

  @override
  String get termsSection4Content =>
      'Bạn có trách nhiệm bảo mật thông tin tài khoản và mật khẩu của mình.';

  @override
  String get termsSection4Title => 'Điều 4 (Cung cấp Dịch vụ)';

  @override
  String get termsSection5Content =>
      'Bạn đồng ý không sử dụng dịch vụ của chúng tôi cho bất kỳ mục đích bất hợp pháp hoặc không được phép.';

  @override
  String get termsSection5Title => 'Điều 5 (Đăng ký Thành viên)';

  @override
  String get termsSection6Content =>
      'Chúng tôi có quyền chấm dứt hoặc tạm ngừng tài khoản của bạn nếu vi phạm các điều khoản này.';

  @override
  String get termsSection6Title => 'Điều 6 (Nghĩa vụ của Người dùng)';

  @override
  String get termsSection7Content => 'Nội dung điều khoản 7';

  @override
  String get termsSection7Title => 'Điều 7 (Hạn chế Sử dụng Dịch vụ)';

  @override
  String get termsSection8Content =>
      'Chúng tôi không chịu trách nhiệm về bất kỳ thiệt hại gián tiếp, ngẫu nhiên hoặc hậu quả nào phát sinh từ việc bạn sử dụng dịch vụ của chúng tôi.';

  @override
  String get termsSection8Title => 'Điều 8 (Gián đoạn Dịch vụ)';

  @override
  String get termsSection9Content =>
      'Tất cả nội dung và tài liệu có sẵn trên dịch vụ của chúng tôi đều được bảo vệ bởi quyền sở hữu trí tuệ.';

  @override
  String get termsSection9Title => 'Điều 9 (Tuyên bố từ chối trách nhiệm)';

  @override
  String get termsSupplementary => 'Điều khoản bổ sung';

  @override
  String get thai => 'Thái';

  @override
  String get thanksFeedback => 'Cảm ơn phản hồi của bạn';

  @override
  String get theme => 'Giao diện';

  @override
  String get themeDescription => 'Chọn giao diện';

  @override
  String get themeSettings => 'Cài đặt giao diện';

  @override
  String get thursday => 'Thứ Năm';

  @override
  String get timeout => 'Thời gian chờ';

  @override
  String get tired => 'Mệt mỏi';

  @override
  String get today => 'Hôm nay';

  @override
  String get todayChats => 'Hôm nay';

  @override
  String get todayText => 'Hôm nay';

  @override
  String get tomorrowText => 'Ngày mai';

  @override
  String get totalConsultSessions => 'Tổng số buổi tư vấn';

  @override
  String get totalErrorCount => 'Tổng số lỗi';

  @override
  String get totalLikes => 'Tổng số lượt thích';

  @override
  String totalOccurrences(Object count) {
    return 'Tổng cộng $count lần xảy ra';
  }

  @override
  String get totalResponses => 'Tổng số phản hồi';

  @override
  String get translatedFrom => 'Đã dịch từ';

  @override
  String get translatedText => 'Bản dịch';

  @override
  String get translationError => 'Lỗi dịch';

  @override
  String get translationErrorDescription => 'Báo lỗi dịch thuật';

  @override
  String get translationErrorReported => 'Đã báo lỗi dịch thuật';

  @override
  String get translationNote => 'Lưu ý về dịch thuật';

  @override
  String get translationQuality => 'Chất lượng dịch';

  @override
  String get translationSettings => 'Cài đặt dịch';

  @override
  String get travel => 'Du lịch';

  @override
  String get tuesday => 'Thứ Ba';

  @override
  String get tutorialAccount => 'Tài khoản hướng dẫn';

  @override
  String get tutorialWelcomeDescription =>
      'Tạo mối quan hệ đặc biệt với AI personas.';

  @override
  String get tutorialWelcomeTitle => 'Chào mừng đến với SONA!';

  @override
  String get typeMessage => 'Nhập tin nhắn...';

  @override
  String get unblock => 'Bỏ chặn';

  @override
  String get unblockFailed => 'Bỏ chặn không thành công';

  @override
  String unblockPersonaConfirm(String name) {
    return 'Bỏ chặn $name?';
  }

  @override
  String get unblockedSuccessfully => 'Mở khóa thành công';

  @override
  String get unexpectedLoginError => 'Lỗi đăng nhập không mong đợi';

  @override
  String get unknown => 'Không xác định';

  @override
  String get unknownError => 'Đã xảy ra lỗi không xác định';

  @override
  String get unlimitedMessages => 'Không giới hạn';

  @override
  String get unsendMessage => 'Thu hồi tin nhắn';

  @override
  String get usagePurpose => 'Mục đích sử dụng';

  @override
  String get useOneHeart => 'Sử dụng 1 Trái Tim';

  @override
  String get useSystemLanguage => 'Sử dụng Ngôn Ngữ Hệ Thống';

  @override
  String get user => 'Người dùng:';

  @override
  String get userMessage => 'Tin nhắn của người dùng:';

  @override
  String get userNotFound => 'Không tìm thấy người dùng';

  @override
  String get valentinesDay => 'Ngày Valentine';

  @override
  String get verifyingAuth => 'Đang xác minh xác thực';

  @override
  String get version => 'Phiên bản';

  @override
  String get vietnamese => 'Tiếng Việt';

  @override
  String get violentContent => 'Nội dung bạo lực';

  @override
  String get voiceMessage => 'Tin nhắn thoại';

  @override
  String waitingForChat(String name) {
    return '$name đang chờ trò chuyện.';
  }

  @override
  String get walk => 'Đi bộ';

  @override
  String get wasHelpful => 'Có hữu ích không?';

  @override
  String get weatherClear => 'Trời quang';

  @override
  String get weatherCloudy => 'Trời nhiều mây';

  @override
  String get weatherContext => 'Bối cảnh thời tiết';

  @override
  String get weatherContextDesc => 'Ngữ cảnh thời tiết';

  @override
  String get weatherDrizzle => 'Mưa phùn';

  @override
  String get weatherFog => 'Sương mù';

  @override
  String get weatherMist => 'Sương mù';

  @override
  String get weatherRain => 'Mưa';

  @override
  String get weatherRainy => 'Mưa';

  @override
  String get weatherSnow => 'Tuyết';

  @override
  String get weatherSnowy => 'Tuyết';

  @override
  String get weatherThunderstorm => 'Bão tố';

  @override
  String get wednesday => 'Thứ Tư';

  @override
  String get weekdays => 'CN,T2,T3,T4,T5,T6,T7';

  @override
  String get welcomeMessage => 'Chào mừng bạn💕';

  @override
  String get whatTopicsToTalk => 'Bạn muốn nói về chủ đề gì?';

  @override
  String get whiteDay => 'Ngày Trắng';

  @override
  String get winter => 'Mùa Đông';

  @override
  String get wrongTranslation => 'Dịch Sai';

  @override
  String get year => 'Năm';

  @override
  String get yearEnd => 'Cuối Năm';

  @override
  String get yes => 'Có';

  @override
  String get yesterday => 'Hôm qua';

  @override
  String get yesterdayChats => 'Hôm qua';

  @override
  String get you => 'Bạn';
}
