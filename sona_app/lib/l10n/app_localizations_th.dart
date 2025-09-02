// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class AppLocalizationsTh extends AppLocalizations {
  AppLocalizationsTh([String locale = 'th']) : super(locale);

  @override
  String get about => 'เกี่ยวกับ';

  @override
  String get accountAndProfile => 'ข้อมูลบัญชี & โปรไฟล์';

  @override
  String get accountDeletedSuccess => 'ลบบัญชีสำเร็จแล้ว';

  @override
  String get accountDeletionContent => 'คุณแน่ใจหรือว่าต้องการลบบัญชีของคุณ?';

  @override
  String get accountDeletionError => 'เกิดข้อผิดพลาดขณะลบบัญชี';

  @override
  String get accountDeletionInfo => 'ข้อมูลการลบบัญชี';

  @override
  String get accountDeletionTitle => 'ลบบัญชี';

  @override
  String get accountDeletionWarning1 =>
      'คำเตือน: การดำเนินการนี้ไม่สามารถยกเลิกได้';

  @override
  String get accountDeletionWarning2 => 'ข้อมูลทั้งหมดของคุณจะถูกลบอย่างถาวร';

  @override
  String get accountDeletionWarning3 => 'คุณจะสูญเสียการเข้าถึงบทสนทนาทั้งหมด';

  @override
  String get accountDeletionWarning4 => 'รวมถึงเนื้อหาที่ซื้อทั้งหมด';

  @override
  String get accountManagement => 'การจัดการบัญชี';

  @override
  String get adaptiveConversationDesc => 'ปรับสไตล์การสนทนาให้ตรงกับของคุณ';

  @override
  String get afternoon => 'ช่วงบ่าย';

  @override
  String get afternoonFatigue => 'ความเหนื่อยล้าในช่วงบ่าย';

  @override
  String get ageConfirmation => 'ฉันอายุ 14 ปีขึ้นไปและได้ยืนยันข้อมูลข้างต้น';

  @override
  String ageRange(int min, int max) {
    return '$min-$max ปี';
  }

  @override
  String get ageUnit => 'ปี';

  @override
  String get agreeToTerms => 'ฉันยอมรับเงื่อนไข';

  @override
  String get aiDatingQuestion => 'คุณจะคบกับ AI ไหม?';

  @override
  String get aiPersonaPreferenceDescription =>
      'กรุณาตั้งค่าความชอบสำหรับการจับคู่บุคลิก AI';

  @override
  String get all => 'ทั้งหมด';

  @override
  String get allAgree => 'ตกลงทั้งหมด';

  @override
  String get allFeaturesRequired => '※ ฟีเจอร์ทั้งหมดจำเป็นสำหรับการให้บริการ';

  @override
  String get allPersonas => 'บุคคลทั้งหมด';

  @override
  String get allPersonasMatched =>
      'บุคลิกทั้งหมดถูกจับคู่แล้ว! เริ่มสนทนากับพวกเขาได้เลย';

  @override
  String get allowPermission => 'ดำเนินการต่อ';

  @override
  String alreadyChattingWith(String name) {
    return 'กำลังแชทกับ $name อยู่แล้ว';
  }

  @override
  String get alsoBlockThisAI => 'บล็อก AI นี้ด้วย';

  @override
  String get angry => 'โกรธ';

  @override
  String get anonymousLogin => 'เข้าสู่ระบบแบบไม่ระบุตัวตน';

  @override
  String get anxious => 'กังวล';

  @override
  String get apiKeyError => 'ข้อผิดพลาดของ API Key';

  @override
  String get appName => 'SONA';

  @override
  String get appTagline => 'เพื่อน AI ของคุณ';

  @override
  String get appleLoginCanceled => 'การเข้าสู่ระบบด้วย Apple ถูกยกเลิก';

  @override
  String get appleLoginError => 'เข้าสู่ระบบ Apple ล้มเหลว';

  @override
  String get art => 'ศิลปะ';

  @override
  String get authError => 'ข้อผิดพลาดในการตรวจสอบสิทธิ์';

  @override
  String get autoTranslate => 'แปลอัตโนมัติ';

  @override
  String get autumn => 'ฤดูใบไม้ร่วง';

  @override
  String get averageQuality => 'คุณภาพเฉลี่ย';

  @override
  String get averageQualityScore => 'คะแนนคุณภาพเฉลี่ย';

  @override
  String get awkwardExpression => 'การแสดงออกที่ไม่เหมาะสม';

  @override
  String get backButton => 'กลับ';

  @override
  String get basicInfo => 'ข้อมูลพื้นฐาน';

  @override
  String get basicInfoDescription => 'กรุณากรอกข้อมูลพื้นฐานเพื่อสร้างบัญชี';

  @override
  String get birthDate => 'วันเกิด';

  @override
  String get birthDateOptional => 'วันเกิด (ไม่บังคับ)';

  @override
  String get birthDateRequired => 'วันเกิด *';

  @override
  String get blockConfirm => 'คุณต้องการบล็อก AI นี้หรือไม่?';

  @override
  String get blockReason => 'เหตุผลในการบล็อก';

  @override
  String get blockThisAI => 'บล็อก AI นี้';

  @override
  String blockedAICount(int count) {
    return 'AI ที่ถูกบล็อก $count ตัว';
  }

  @override
  String get blockedAIs => 'AI ที่ถูกบล็อก';

  @override
  String get blockedAt => 'ถูกบล็อกเมื่อ';

  @override
  String get blockedSuccessfully => 'บล็อกสำเร็จ';

  @override
  String get breakfast => 'อาหารเช้า';

  @override
  String get byErrorType => 'โดยประเภทข้อผิดพลาด';

  @override
  String get byPersona => 'โดยบุคลิก';

  @override
  String cacheDeleteError(String error) {
    return 'เกิดข้อผิดพลาดในการลบแคช: $error';
  }

  @override
  String get cacheDeleted => 'แคชภาพถูกลบแล้ว';

  @override
  String get cafeTerrace => 'ระเบียงคาเฟ่';

  @override
  String get calm => 'สงบ';

  @override
  String get cameraPermission => 'สิทธิ์กล้อง';

  @override
  String get cameraPermissionDesc => 'ต้องการสิทธิ์กล้องเพื่อถ่ายรูปโปรไฟล์';

  @override
  String get canChangeInSettings =>
      'คุณสามารถเปลี่ยนแปลงนี้ได้ในภายหลังที่การตั้งค่า';

  @override
  String get canMeetPreviousPersonas =>
      'คุณสามารถพบกับบุคลิกที่คุณเคยปัดไปก่อนหน้านี้อีกครั้ง!';

  @override
  String get cancel => 'ยกเลิก';

  @override
  String get changeProfilePhoto => 'เปลี่ยนรูปโปรไฟล์';

  @override
  String get chat => 'แชท';

  @override
  String get chatEndedMessage => 'การสนทนาได้สิ้นสุดลง';

  @override
  String get chatErrorDashboard => 'แดชบอร์ดข้อผิดพลาดการสนทนา';

  @override
  String get chatErrorSentSuccessfully =>
      'ข้อผิดพลาดการสนทนาได้ถูกส่งเรียบร้อยแล้ว';

  @override
  String get chatListTab => 'แท็บรายการสนทนา';

  @override
  String get chats => 'การสนทนา';

  @override
  String chattingWithPersonas(int count) {
    return 'กำลังสนทนากับบุคลิก $count ตัว';
  }

  @override
  String get checkInternetConnection => 'โปรดตรวจสอบการเชื่อมต่ออินเทอร์เน็ต';

  @override
  String get checkingUserInfo => 'กำลังตรวจสอบข้อมูลผู้ใช้';

  @override
  String get childrensDay => 'วันเด็ก';

  @override
  String get chinese => 'จีน';

  @override
  String get chooseOption => 'กรุณาเลือก:';

  @override
  String get christmas => 'คริสต์มาส';

  @override
  String get close => 'ปิด';

  @override
  String get complete => 'เสร็จสิ้น';

  @override
  String get completeSignup => 'เสร็จสิ้นการลงทะเบียน';

  @override
  String get confirm => 'ยืนยัน';

  @override
  String get connectingToServer => 'กำลังเชื่อมต่อกับเซิร์ฟเวอร์';

  @override
  String get consultQualityMonitoring => 'การตรวจสอบคุณภาพการให้คำปรึกษา';

  @override
  String get continueAsGuest => 'ดำเนินการต่อในฐานะแขก';

  @override
  String get continueButton => 'ดำเนินการต่อ';

  @override
  String get continueWithApple => 'ดำเนินการต่อด้วย Apple';

  @override
  String get continueWithGoogle => 'ดำเนินการต่อด้วย Google';

  @override
  String get conversationContinuity => 'ความต่อเนื่องของการสนทนา';

  @override
  String get conversationContinuityDesc =>
      'จำการสนทนาก่อนหน้าและเชื่อมโยงหัวข้อ';

  @override
  String conversationWith(String name) {
    return '$name';
  }

  @override
  String get convertToMember => 'ลงทะเบียน';

  @override
  String get cooking => 'การทำอาหาร';

  @override
  String get copyMessage => 'คัดลอกข้อความ';

  @override
  String get copyrightInfringement => 'การละเมิดลิขสิทธิ์';

  @override
  String get creatingAccount => 'กำลังสร้างบัญชี';

  @override
  String get crisisDetected => 'ตรวจพบวิกฤต';

  @override
  String get culturalIssue => 'ปัญหาทางวัฒนธรรม';

  @override
  String get current => 'ปัจจุบัน';

  @override
  String get currentCacheSize => 'ขนาดแคชปัจจุบัน';

  @override
  String get currentLanguage => 'ภาษาปัจจุบัน';

  @override
  String get cycling => 'การปั่นจักรยาน';

  @override
  String get dailyCare => 'การดูแลประจำวัน';

  @override
  String get dailyCareDesc =>
      'ข้อความดูแลประจำวันเกี่ยวกับมื้ออาหาร, การนอนหลับ, สุขภาพ';

  @override
  String get dailyChat => 'การสนทนาประจำวัน';

  @override
  String get dailyCheck => 'ตรวจสอบประจำวัน';

  @override
  String get dailyConversation => 'การสนทนาประจำวัน';

  @override
  String get dailyLimitDescription => 'คุณถึงขีดจำกัดข้อความต่อวันแล้ว';

  @override
  String get dailyLimitTitle => 'ถึงขีดจำกัดรายวันแล้ว';

  @override
  String get darkMode => 'โหมดมืด';

  @override
  String get darkTheme => 'โหมดมืด';

  @override
  String get darkThemeDesc => 'ใช้โหมดมืด';

  @override
  String get dataCollection => 'การตั้งค่าการเก็บข้อมูล';

  @override
  String get datingAdvice => 'คำแนะนำการเดท';

  @override
  String get datingDescription =>
      'ฉันต้องการแบ่งปันความคิดลึกซึ้งและมีการสนทนาที่จริงใจ';

  @override
  String get dawn => 'รุ่งอรุณ';

  @override
  String get day => 'วัน';

  @override
  String get dayAfterTomorrow => 'วันมะรืน';

  @override
  String daysAgo(int count, String formatted) {
    return '$count วันที่แล้ว';
  }

  @override
  String daysRemaining(int days) {
    return 'เหลืออีก $days วัน';
  }

  @override
  String get deepTalk => 'การสนทนาลึก';

  @override
  String get delete => 'ลบ';

  @override
  String get deleteAccount => 'ลบบัญชี';

  @override
  String get deleteAccountConfirm =>
      'คุณแน่ใจหรือว่าต้องการลบบัญชี? การกระทำนี้ไม่สามารถย้อนกลับได้';

  @override
  String get deleteAccountWarning => 'คุณแน่ใจหรือว่าต้องการลบบัญชีของคุณ?';

  @override
  String get deleteCache => 'ลบแคช';

  @override
  String get deletingAccount => 'กำลังลบบัญชี...';

  @override
  String get depressed => 'ซึมเศร้า';

  @override
  String get describeError => 'มีปัญหาอะไร?';

  @override
  String get detailedReason => 'สาเหตุโดยละเอียด';

  @override
  String get developRelationshipStep =>
      '3. พัฒนาความสัมพันธ์: สร้างความใกล้ชิดผ่านการสนทนาและพัฒนาความสัมพันธ์ที่พิเศษ';

  @override
  String get dinner => 'มื้อเย็น';

  @override
  String get discardGuestData => 'เริ่มใหม่';

  @override
  String get discount20 => 'ลด 20%';

  @override
  String get discount30 => 'ลด 30%';

  @override
  String get discountAmount => 'ประหยัด';

  @override
  String discountAmountValue(String amount) {
    return 'ประหยัด ₩$amount';
  }

  @override
  String get done => 'เสร็จ';

  @override
  String get downloadingPersonaImages => 'กำลังดาวน์โหลดภาพบุคลิกใหม่';

  @override
  String get edit => 'แก้ไข';

  @override
  String get editInfo => 'แก้ไขข้อมูล';

  @override
  String get editProfile => 'แก้ไขโปรไฟล์';

  @override
  String get effectSound => 'เสียงเอฟเฟกต์';

  @override
  String get effectSoundDescription => 'เล่นเสียงเอฟเฟกต์';

  @override
  String get email => 'อีเมล';

  @override
  String get emailHint => 'example@email.com';

  @override
  String get emailLabel => 'อีเมล';

  @override
  String get emailRequired => 'อีเมล *';

  @override
  String get emotionAnalysis => 'การวิเคราะห์อารมณ์';

  @override
  String get emotionAnalysisDesc =>
      'วิเคราะห์อารมณ์เพื่อการตอบสนองอย่างเห็นอกเห็นใจ';

  @override
  String get emotionAngry => 'โกรธ';

  @override
  String get emotionBasedEncounters => 'พบกับบุคลิกตามอารมณ์ของคุณ';

  @override
  String get emotionCool => 'เท่';

  @override
  String get emotionHappy => 'มีความสุข';

  @override
  String get emotionLove => 'รัก';

  @override
  String get emotionSad => 'เศร้า';

  @override
  String get emotionThinking => 'กำลังคิด';

  @override
  String get emotionalSupportDesc =>
      'แบ่งปันความกังวลของคุณและรับการปลอบประโลมอย่างอบอุ่น';

  @override
  String get endChat => 'สิ้นสุดการสนทนา';

  @override
  String get endTutorial => 'สิ้นสุดการสอน';

  @override
  String get endTutorialAndLogin => 'สิ้นสุดการสอนและเข้าสู่ระบบ?';

  @override
  String get endTutorialMessage =>
      'คุณต้องการสิ้นสุดการสอนและเข้าสู่ระบบหรือไม่?';

  @override
  String get english => 'อังกฤษ';

  @override
  String get enterBasicInfo => 'กรอกข้อมูลพื้นฐานของคุณ';

  @override
  String get enterBasicInformation => 'กรุณากรอกข้อมูลพื้นฐาน';

  @override
  String get enterEmail => 'กรุณากรอกอีเมล';

  @override
  String get enterNickname => 'กรุณากรอกชื่อเล่น';

  @override
  String get enterPassword => 'กรุณากรอกรหัสผ่าน';

  @override
  String get entertainmentAndFunDesc => 'สนุกกับเกมสนุกๆ และการสนทนาที่น่าพอใจ';

  @override
  String get entertainmentDescription =>
      'ฉันต้องการสนทนาที่สนุกสนานและเพลิดเพลินกับเวลา';

  @override
  String get entertainmentFun => 'ความบันเทิง/สนุกสนาน';

  @override
  String get error => 'ข้อผิดพลาด';

  @override
  String get errorDescription => 'คำอธิบายข้อผิดพลาด';

  @override
  String get errorDescriptionHint =>
      'เช่น ตอบคำถามแปลกๆ, พูดซ้ำสิ่งเดิม, ให้คำตอบที่ไม่เหมาะสมตามบริบท...';

  @override
  String get errorDetails => 'รายละเอียดข้อผิดพลาด';

  @override
  String get errorDetailsHint => 'กรุณาอธิบายรายละเอียดว่าเกิดอะไรขึ้น';

  @override
  String get errorFrequency24h => 'ความถี่ของข้อผิดพลาด (24 ชั่วโมงที่ผ่านมา)';

  @override
  String get errorMessage => 'ข้อความข้อผิดพลาด:';

  @override
  String get errorOccurred => 'เกิดข้อผิดพลาด';

  @override
  String get errorOccurredTryAgain => 'เกิดข้อผิดพลาดขึ้น กรุณาลองอีกครั้ง';

  @override
  String get errorSendingFailed => 'ส่งข้อผิดพลาดไม่สำเร็จ';

  @override
  String get errorStats => 'สถิติข้อผิดพลาด';

  @override
  String errorWithMessage(String error) {
    return 'ข้อผิดพลาด: $error';
  }

  @override
  String get evening => 'เย็น';

  @override
  String get excited => 'ตื่นเต้น';

  @override
  String get exit => 'ออก';

  @override
  String get exitApp => 'ออกจากแอป';

  @override
  String get exitConfirmMessage => 'คุณแน่ใจหรือว่าต้องการออกจากแอป?';

  @override
  String get expertPersona => 'บุคลิกภาพผู้เชี่ยวชาญ';

  @override
  String get expertiseScore => 'คะแนนความเชี่ยวชาญ';

  @override
  String get expired => 'หมดอายุ';

  @override
  String get explainReportReason => 'กรุณาอธิบายเหตุผลในการรายงานอย่างละเอียด';

  @override
  String get fashion => 'แฟชั่น';

  @override
  String get female => 'หญิง';

  @override
  String get filter => 'กรอง';

  @override
  String get firstOccurred => 'เกิดขึ้นครั้งแรก:';

  @override
  String get followDeviceLanguage => 'ตามการตั้งค่าภาษาของอุปกรณ์';

  @override
  String get forenoon => 'ช่วงเช้า';

  @override
  String get forgotPassword => 'ลืมรหัสผ่าน?';

  @override
  String get frequentlyAskedQuestions => 'คำถามที่พบบ่อย';

  @override
  String get friday => 'วันศุกร์';

  @override
  String get friendshipDescription => 'ฉันต้องการพบเพื่อนใหม่และมีการสนทนา';

  @override
  String get funChat => 'แชทสนุก';

  @override
  String get galleryPermission => 'สิทธิ์แกลเลอรี';

  @override
  String get galleryPermissionDesc =>
      'ต้องการสิทธิ์แกลเลอรีเพื่อเลือกรูปโปรไฟล์';

  @override
  String get gaming => 'เกม';

  @override
  String get gender => 'เพศ';

  @override
  String get genderNotSelectedInfo =>
      'หากยังไม่ได้เลือกเพศ จะมีบุคลิกภาพของทุกเพศแสดงให้เห็น';

  @override
  String get genderOptional => 'เพศ (ไม่บังคับ)';

  @override
  String get genderPreferenceActive => 'คุณสามารถพบกับบุคคลในทุกเพศ';

  @override
  String get genderPreferenceDisabled =>
      'กรุณาเลือกเพศของคุณเพื่อเปิดใช้งานตัวเลือกเฉพาะเพศตรงข้าม';

  @override
  String get genderPreferenceInactive => 'จะแสดงเฉพาะบุคคลเพศตรงข้าม';

  @override
  String get genderRequired => 'เพศ *';

  @override
  String get genderSelectionInfo => 'หากไม่เลือก คุณสามารถพบกับบุคคลในทุกเพศ';

  @override
  String get generalPersona => 'บุคคลทั่วไป';

  @override
  String get goToSettings => 'ไปที่การตั้งค่า';

  @override
  String get googleLoginCanceled => 'การเข้าสู่ระบบ Google ถูกยกเลิก';

  @override
  String get googleLoginError => 'เข้าสู่ระบบ Google ล้มเหลว';

  @override
  String get grantPermission => 'ดำเนินการต่อ';

  @override
  String get guest => 'ผู้เยี่ยมชม';

  @override
  String get guestDataMigration =>
      'คุณต้องการเก็บประวัติการแชทปัจจุบันเมื่อสมัครสมาชิกหรือไม่?';

  @override
  String get guestLimitReached => 'การทดลองใช้ผู้เยี่ยมชมสิ้นสุดแล้ว';

  @override
  String get guestLoginPromptMessage => 'เข้าสู่ระบบเพื่อดำเนินการสนทนาต่อ';

  @override
  String get guestMessageExhausted => 'ข้อความฟรีหมดแล้ว';

  @override
  String guestMessageRemaining(int count) {
    return 'ข้อความผู้เยี่ยมชมที่เหลืออยู่ $count ข้อความ';
  }

  @override
  String get guestModeBanner => 'โหมดผู้เยี่ยมชม';

  @override
  String get guestModeDescription => 'ลองใช้ SONA โดยไม่ต้องสมัครสมาชิก';

  @override
  String get guestModeFailedMessage => 'ไม่สามารถเริ่มโหมดผู้เยี่ยมชมได้';

  @override
  String get guestModeLimitation => 'ฟีเจอร์บางอย่างถูกจำกัดในโหมดผู้เยี่ยมชม';

  @override
  String get guestModeTitle => 'ลองใช้ในฐานะผู้เยี่ยมชม';

  @override
  String get guestModeWarning => 'โหมดผู้เยี่ยมชมจะมีอายุ 24 ชั่วโมง';

  @override
  String get guestModeWelcome => 'เริ่มต้นในโหมดผู้เยี่ยมชม';

  @override
  String get happy => 'มีความสุข';

  @override
  String get hapticFeedback => 'การตอบสนองแบบสัมผัส';

  @override
  String get harassmentBullying => 'การรังแก/การกลั่นแกล้ง';

  @override
  String get hateSpeech => 'การพูดเกลียดชัง';

  @override
  String get heartDescription => 'หัวใจสำหรับข้อความเพิ่มเติม';

  @override
  String get heartInsufficient => 'หัวใจไม่เพียงพอ';

  @override
  String get heartInsufficientPleaseCharge => 'หัวใจไม่เพียงพอ กรุณาชาร์จหัวใจ';

  @override
  String get heartRequired => 'ต้องการหัวใจ 1 ดวง';

  @override
  String get heartUsageFailed => 'ใช้หัวใจล้มเหลว';

  @override
  String get hearts => 'หัวใจ';

  @override
  String get hearts10 => '10 หัวใจ';

  @override
  String get hearts30 => '30 หัวใจ';

  @override
  String get hearts30Discount => 'ลดราคา';

  @override
  String get hearts50 => '50 หัวใจ';

  @override
  String get hearts50Discount => 'ลดราคา';

  @override
  String get helloEmoji => 'สวัสดี! 😊';

  @override
  String get help => 'ช่วยเหลือ';

  @override
  String get hideOriginalText => 'ซ่อนต้นฉบับ';

  @override
  String get hobbySharing => 'แบ่งปันงานอดิเรก';

  @override
  String get hobbyTalk => 'พูดคุยเกี่ยวกับงานอดิเรก';

  @override
  String get hours24Ago => '24 ชั่วโมงที่แล้ว';

  @override
  String hoursAgo(int count, String formatted) {
    return '$count ชั่วโมงที่แล้ว';
  }

  @override
  String get howToUse => 'วิธีการใช้ SONA';

  @override
  String get imageCacheManagement => 'การจัดการแคชภาพ';

  @override
  String get inappropriateContent => 'เนื้อหาที่ไม่เหมาะสม';

  @override
  String get incorrect => 'ไม่ถูกต้อง';

  @override
  String get incorrectPassword => 'รหัสผ่านไม่ถูกต้อง';

  @override
  String get indonesian => 'ภาษาอินโดนีเซีย';

  @override
  String get inquiries => 'สอบถาม';

  @override
  String get insufficientHearts => 'หัวใจไม่เพียงพอ';

  @override
  String get interestSharing => 'การแบ่งปันความสนใจ';

  @override
  String get interestSharingDesc => 'ค้นพบและแนะนำความสนใจที่แบ่งปัน';

  @override
  String get interests => 'ความสนใจ';

  @override
  String get invalidEmailFormat => 'รูปแบบอีเมลไม่ถูกต้อง';

  @override
  String get invalidEmailFormatError => 'กรุณาใส่อีเมลที่ถูกต้อง';

  @override
  String isTyping(String name) {
    return '$name กำลังพิมพ์...';
  }

  @override
  String get japanese => 'ภาษาญี่ปุ่น';

  @override
  String get joinDate => 'วันที่เข้าร่วม';

  @override
  String get justNow => 'เมื่อสักครู่';

  @override
  String get keepGuestData => 'เก็บประวัติการแชท';

  @override
  String get korean => 'ภาษาเกาหลี';

  @override
  String get koreanLanguage => 'ภาษาเกาหลี';

  @override
  String get language => 'ภาษา';

  @override
  String get languageDescription => 'AI จะตอบกลับในภาษาที่คุณเลือก';

  @override
  String get languageIndicator => 'ภาษา';

  @override
  String get languageSettings => 'ตั้งค่าภาษา';

  @override
  String get lastOccurred => 'เกิดขึ้นล่าสุด:';

  @override
  String get lastUpdated => 'อัปเดตล่าสุด';

  @override
  String get lateNight => 'กลางคืนดึก';

  @override
  String get later => 'ทีหลัง';

  @override
  String get laterButton => 'ทีหลัง';

  @override
  String get leave => 'ออกจาก';

  @override
  String get leaveChatConfirm => 'คุณต้องการออกจากแชทนี้ไหม?';

  @override
  String get leaveChatRoom => 'ออกจากห้องแชท';

  @override
  String get leaveChatTitle => 'ออกจากแชท';

  @override
  String get lifeAdvice => 'คำแนะนำชีวิต';

  @override
  String get lightTalk => 'สนทนาเบาๆ';

  @override
  String get lightTheme => 'โหมดสว่าง';

  @override
  String get lightThemeDesc => 'ใช้ธีมสว่าง';

  @override
  String get loading => 'กำลังโหลด...';

  @override
  String get loadingData => 'กำลังโหลดข้อมูล...';

  @override
  String get loadingProducts => 'กำลังโหลดผลิตภัณฑ์...';

  @override
  String get loadingProfile => 'กำลังโหลดโปรไฟล์';

  @override
  String get login => 'เข้าสู่ระบบ';

  @override
  String get loginButton => 'เข้าสู่ระบบ';

  @override
  String get loginCancelled => 'ยกเลิกการเข้าสู่ระบบ';

  @override
  String get loginComplete => 'เข้าสู่ระบบสำเร็จ';

  @override
  String get loginError => 'เข้าสู่ระบบล้มเหลว กรุณาลองใหม่';

  @override
  String get loginFailed => 'การเข้าสู่ระบบล éch';

  @override
  String get loginFailedTryAgain => 'การเข้าสู่ระบบล éch กรุณาลองอีกครั้ง';

  @override
  String get loginRequired => 'ต้องเข้าสู่ระบบ';

  @override
  String get loginRequiredForProfile => 'ต้องเข้าสู่ระบบเพื่อดูโปรไฟล์';

  @override
  String get loginRequiredService => 'ต้องเข้าสู่ระบบเพื่อใช้บริการนี้';

  @override
  String get loginRequiredTitle => 'ต้องเข้าสู่ระบบ';

  @override
  String get loginSignup => 'เข้าสู่ระบบ/สมัครสมาชิก';

  @override
  String get loginTab => 'เข้าสู่ระบบ';

  @override
  String get loginTitle => 'เข้าสู่ระบบ';

  @override
  String get loginWithApple => 'เข้าสู่ระบบด้วย Apple';

  @override
  String get loginWithGoogle => 'เข้าสู่ระบบด้วย Google';

  @override
  String get logout => 'ออกจากระบบ';

  @override
  String get logoutConfirm => 'คุณแน่ใจว่าต้องการออกจากระบบหรือไม่?';

  @override
  String get lonelinessRelief => 'บรรเทาความเหงา';

  @override
  String get lonely => 'เหงา';

  @override
  String get lowQualityResponses => 'การตอบกลับคุณภาพต่ำ';

  @override
  String get lunch => 'อาหารกลางวัน';

  @override
  String get lunchtime => 'เวลาทานอาหารกลางวัน';

  @override
  String get mainErrorType => 'ประเภทข้อผิดพลาดหลัก';

  @override
  String get makeFriends => 'สร้างมิตรภาพ';

  @override
  String get male => 'ชาย';

  @override
  String get manageBlockedAIs => 'จัดการ AI ที่ถูกบล็อก';

  @override
  String get managePersonaImageCache => 'จัดการแคชภาพบุคลิก';

  @override
  String get marketingAgree => 'ตกลงรับข้อมูลการตลาด (ไม่บังคับ)';

  @override
  String get marketingDescription =>
      'คุณสามารถรับข้อมูลเกี่ยวกับกิจกรรมและสิทธิประโยชน์';

  @override
  String get matchPersonaStep =>
      '1. จับคู่บุคลิก: ปัดซ้ายหรือขวาเพื่อเลือกบุคลิก AI ที่คุณชื่นชอบ';

  @override
  String get matchedPersonas => 'บุคลิกที่จับคู่แล้ว';

  @override
  String get matchedSona => 'SONA ที่จับคู่แล้ว';

  @override
  String get matching => 'จับคู่';

  @override
  String get matchingFailed => 'การจับคู่ล้มเหลว';

  @override
  String get me => 'Me';

  @override
  String get meetAIPersonas => 'พบกับ AI คู่ใจ';

  @override
  String get meetNewPersonas => 'พบกับบุคลิกใหม่';

  @override
  String get meetPersonas => 'พบกับบุคลิก';

  @override
  String get memberBenefits =>
      'รับข้อความมากกว่า 100 ข้อความและ 10 หัวใจเมื่อคุณลงทะเบียน!';

  @override
  String get memoryAlbum => 'อัลบั้มความทรงจำ';

  @override
  String get memoryAlbumDesc => 'บันทึกและเรียกคืนช่วงเวลาพิเศษโดยอัตโนมัติ';

  @override
  String get messageCopied => 'คัดลอกข้อความแล้ว';

  @override
  String get messageDeleted => 'ข้อความถูกลบ';

  @override
  String get messageLimitReset => 'ข้อจำกัดข้อความจะรีเซ็ตในเที่ยงคืน';

  @override
  String get messageSendFailed => 'ไม่สามารถส่งข้อความได้ กรุณาลองอีกครั้ง';

  @override
  String get messagesRemaining => 'ข้อความที่เหลือ';

  @override
  String minutesAgo(int count, String formatted) {
    return '$count นาทีที่แล้ว';
  }

  @override
  String get missingTranslation => 'ขาดการแปล';

  @override
  String get monday => 'วันจันทร์';

  @override
  String get month => 'เดือน';

  @override
  String monthDay(String month, int day) {
    return '$day $month';
  }

  @override
  String get moreButton => 'เพิ่มเติม';

  @override
  String get morning => 'เช้า';

  @override
  String get mostFrequentError => 'ข้อผิดพลาดที่พบบ่อยที่สุด';

  @override
  String get movies => 'ภาพยนตร์';

  @override
  String get multilingualChat => 'แชทหลายภาษา';

  @override
  String get music => 'เพลง';

  @override
  String get myGenderSection => 'เพศของฉัน (ไม่บังคับ)';

  @override
  String get networkErrorOccurred => 'เกิดข้อผิดพลาดเกี่ยวกับเครือข่าย';

  @override
  String get newMessage => 'ข้อความใหม่';

  @override
  String newMessageCount(int count) {
    return 'ข้อความใหม่ $count ข้อความ';
  }

  @override
  String get newMessageNotification => 'แจ้งเตือนเมื่อมีข้อความใหม่';

  @override
  String get newMessages => 'ข้อความใหม่';

  @override
  String get newYear => 'ปีใหม่';

  @override
  String get next => 'ถัดไป';

  @override
  String get niceToMeetYou => 'ยินดีที่ได้พบคุณ!';

  @override
  String get nickname => 'ชื่อเล่น';

  @override
  String get nicknameAlreadyUsed => 'ชื่อนี้ถูกใช้งานแล้ว';

  @override
  String get nicknameHelperText => '3-10 ตัวอักษร';

  @override
  String get nicknameHint => 'กรอกชื่อเล่นของคุณ';

  @override
  String get nicknameInUse => 'ชื่อนี้ถูกใช้งานแล้ว';

  @override
  String get nicknameLabel => 'ชื่อเล่น';

  @override
  String get nicknameLengthError => 'ชื่อเล่นต้องมี 3-10 ตัวอักษร';

  @override
  String get nicknamePlaceholder => 'กรุณาใส่ชื่อเล่นของคุณ';

  @override
  String get nicknameRequired => 'ชื่อเล่น *';

  @override
  String get night => 'คืน';

  @override
  String get no => 'ไม่';

  @override
  String get noBlockedAIs => 'ไม่มี AI ที่ถูกบล็อก';

  @override
  String get noChatsYet => 'ยังไม่มีการสนทนา';

  @override
  String get noConversationYet => 'ยังไม่มีการสนทนา';

  @override
  String get noErrorReports => 'ไม่มีรายงานข้อผิดพลาด';

  @override
  String get noImageAvailable => 'ไม่มีรูปภาพให้ใช้งาน';

  @override
  String get noMatchedPersonas => 'ยังไม่มีบุคลิกที่ตรงกัน';

  @override
  String get noMatchedSonas => 'ยังไม่มี SONA ที่ตรงกัน';

  @override
  String get noPersonasAvailable => 'ไม่มีบุคลิกให้เลือก กรุณาลองใหม่';

  @override
  String get noPersonasToSelect => 'ไม่มีบุคลิกให้เลือก';

  @override
  String get noQualityIssues => 'ไม่มีปัญหาคุณภาพในชั่วโมงที่ผ่านมา ✅';

  @override
  String get noQualityLogs => 'ยังไม่มีบันทึกคุณภาพ';

  @override
  String get noTranslatedMessages => 'ไม่มีข้อความให้แปล';

  @override
  String get notEnoughHearts => 'คะแนนหัวใจไม่เพียงพอ';

  @override
  String notEnoughHeartsCount(int count) {
    return 'คะแนนหัวใจไม่เพียงพอ (ปัจจุบัน: $count)';
  }

  @override
  String get notRegistered => 'ยังไม่ได้ลงทะเบียน';

  @override
  String get notSubscribed => 'ยังไม่ได้สมัครสมาชิก';

  @override
  String get notificationPermissionDesc =>
      'ต้องการสิทธิ์การแจ้งเตือนเพื่อรับข้อความใหม่';

  @override
  String get notificationPermissionRequired => 'ต้องการสิทธิ์การแจ้งเตือน';

  @override
  String get notificationSettings => 'ตั้งค่าการแจ้งเตือน';

  @override
  String get notifications => 'การแจ้งเตือน';

  @override
  String get occurrenceInfo => 'ข้อมูลการเกิดเหตุ:';

  @override
  String get olderChats => 'เก่า';

  @override
  String get onlyOppositeGenderNote =>
      'หากไม่เลือก จะมีเพียงบุคลิกเพศตรงข้ามเท่านั้นที่แสดง';

  @override
  String get openSettings => 'เปิดการตั้งค่า';

  @override
  String get optional => 'ไม่บังคับ';

  @override
  String get or => 'หรือ';

  @override
  String get originalPrice => 'ราคาเดิม';

  @override
  String get originalText => 'ข้อความเดิม';

  @override
  String get other => 'อื่นๆ';

  @override
  String get otherError => 'ข้อผิดพลาดอื่น';

  @override
  String get others => 'อื่นๆ';

  @override
  String get ownedHearts => 'หัวใจที่เป็นเจ้าของ';

  @override
  String get parentsDay => 'วันผู้ปกครอง';

  @override
  String get password => 'รหัสผ่าน';

  @override
  String get passwordConfirmation => 'กรุณาใส่รหัสผ่านเพื่อยืนยัน';

  @override
  String get passwordConfirmationDesc =>
      'กรุณาใส่รหัสผ่านของคุณอีกครั้งเพื่อทำการลบบัญชี';

  @override
  String get passwordHint => 'กรอกรหัสผ่าน (6 ตัวอักษรขึ้นไป)';

  @override
  String get passwordLabel => 'รหัสผ่าน';

  @override
  String get passwordRequired => 'รหัสผ่าน *';

  @override
  String get passwordResetEmailPrompt =>
      'กรุณาใส่อีเมลของคุณเพื่อรีเซ็ตรหัสผ่าน';

  @override
  String get passwordResetEmailSent =>
      'อีเมลสำหรับรีเซ็ตรหัสผ่านได้ถูกส่งไปแล้ว กรุณาตรวจสอบอีเมลของคุณ';

  @override
  String get passwordText => 'รหัสผ่าน';

  @override
  String get passwordTooShort => 'รหัสผ่านต้องมีอย่างน้อย 6 ตัวอักษร';

  @override
  String get permissionDenied => 'ปฏิเสธสิทธิ์';

  @override
  String permissionDeniedMessage(String permissionName) {
    return 'สิทธิ์ $permissionName ถูกปฏิเสธ.\\nกรุณาอนุญาตสิทธิ์ในการตั้งค่า';
  }

  @override
  String get permissionDeniedTryLater =>
      'สิทธิ์ถูกปฏิเสธ กรุณาลองอีกครั้งในภายหลัง';

  @override
  String get permissionRequired => 'ต้องการสิทธิ์';

  @override
  String get personaGenderSection => 'ความชอบเพศของบุคลิก';

  @override
  String get personaQualityStats => 'สถิติคุณภาพบุคลิก';

  @override
  String get personalInfoExposure => 'การเปิดเผยข้อมูลส่วนบุคคล';

  @override
  String get personality => 'บุคลิกภาพ';

  @override
  String get pets => 'สัตว์เลี้ยง';

  @override
  String get photo => 'รูปภาพ';

  @override
  String get photography => 'การถ่ายภาพ';

  @override
  String get picnic => 'ปิคนิค';

  @override
  String get preferenceSettings => 'การตั้งค่าความชอบ';

  @override
  String get preferredLanguage => 'ภาษาโปรด';

  @override
  String get preparingForSleep => 'กำลังเตรียมตัวสำหรับการนอน';

  @override
  String get preparingNewMeeting => 'กำลังเตรียมการประชุมใหม่';

  @override
  String get preparingPersonaImages => 'กำลังเตรียมภาพบุคลิก';

  @override
  String get preparingPersonas => 'กำลังเตรียมบุคลิก';

  @override
  String get preview => 'ตัวอย่าง';

  @override
  String get previous => 'ก่อนหน้า';

  @override
  String get privacy => 'ความเป็นส่วนตัว';

  @override
  String get privacyPolicy => 'นโยบายความเป็นส่วนตัว';

  @override
  String get privacyPolicyAgreement => 'กรุณาเห็นด้วยกับนโยบายความเป็นส่วนตัว';

  @override
  String get privacySection1Content =>
      'เรามุ่งมั่นที่จะปกป้องความเป็นส่วนตัวของคุณ นโยบายความเป็นส่วนตัวนี้อธิบายว่าเรารวบรวม ใช้ และปกป้องข้อมูลของคุณอย่างไรเมื่อคุณใช้บริการของเรา';

  @override
  String get privacySection1Title =>
      '1. วัตถุประสงค์ในการรวบรวมและใช้ข้อมูลส่วนบุคคล';

  @override
  String get privacySection2Content =>
      'เรารวบรวมข้อมูลที่คุณให้โดยตรงกับเรา เช่น เมื่อคุณสร้างบัญชี อัปเดตโปรไฟล์ หรือใช้บริการของเรา';

  @override
  String get privacySection2Title => 'ข้อมูลที่เรารวบรวม';

  @override
  String get privacySection3Content =>
      'เราใช้ข้อมูลที่เรารวบรวมเพื่อให้บริการ รักษา และปรับปรุงบริการของเรา รวมถึงการสื่อสารกับคุณ';

  @override
  String get privacySection3Title =>
      '3. ระยะเวลาในการเก็บรักษาและการใช้ข้อมูลส่วนบุคคล';

  @override
  String get privacySection4Content =>
      'เราจะไม่ขาย แลกเปลี่ยน หรือโอนข้อมูลส่วนบุคคลของคุณให้กับบุคคลที่สามโดยไม่ได้รับความยินยอมจากคุณ';

  @override
  String get privacySection4Title => '4. การให้ข้อมูลส่วนบุคคลแก่บุคคลที่สาม';

  @override
  String get privacySection5Content =>
      'เราใช้มาตรการรักษาความปลอดภัยที่เหมาะสมเพื่อปกป้องข้อมูลส่วนบุคคลของคุณจากการเข้าถึง การเปลี่ยนแปลง การเปิดเผย หรือการทำลายที่ไม่ได้รับอนุญาต';

  @override
  String get privacySection5Title =>
      '5. มาตรการป้องกันทางเทคนิคสำหรับข้อมูลส่วนบุคคล';

  @override
  String get privacySection6Content =>
      'เราจะเก็บข้อมูลส่วนบุคคลไว้เท่าที่จำเป็นเพื่อให้บริการของเราและปฏิบัติตามข้อกำหนดทางกฎหมาย';

  @override
  String get privacySection6Title => '6. สิทธิของผู้ใช้';

  @override
  String get privacySection7Content =>
      'คุณมีสิทธิ์เข้าถึง อัปเดต หรือ ลบข้อมูลส่วนตัวของคุณได้ตลอดเวลาผ่านการตั้งค่าบัญชีของคุณ';

  @override
  String get privacySection7Title => 'สิทธิของคุณ';

  @override
  String get privacySection8Content =>
      'หากคุณมีคำถามเกี่ยวกับนโยบายความเป็นส่วนตัวนี้ โปรดติดต่อเราที่ support@sona.com';

  @override
  String get privacySection8Title => 'ติดต่อเรา';

  @override
  String get privacySettings => 'การตั้งค่าความเป็นส่วนตัว';

  @override
  String get privacySettingsInfo =>
      'การปิดฟีเจอร์แต่ละอย่างจะทำให้บริการเหล่านั้นไม่สามารถใช้งานได้';

  @override
  String get privacySettingsScreen => 'การตั้งค่าความเป็นส่วนตัว';

  @override
  String get problemMessage => 'ปัญหา';

  @override
  String get problemOccurred => 'เกิดปัญหา';

  @override
  String get profile => 'โปรไฟล์';

  @override
  String get profileEdit => 'แก้ไขโปรไฟล์';

  @override
  String get profileEditLoginRequiredMessage =>
      'ต้องเข้าสู่ระบบเพื่อแก้ไขโปรไฟล์ของคุณ';

  @override
  String get profileInfo => 'ข้อมูลโปรไฟล์';

  @override
  String get profileInfoDescription =>
      'กรุณาใส่รูปโปรไฟล์และข้อมูลพื้นฐานของคุณ';

  @override
  String get profileNav => 'โปรไฟล์';

  @override
  String get profilePhoto => 'รูปโปรไฟล์';

  @override
  String get profilePhotoAndInfo => 'กรุณาใส่รูปโปรไฟล์และข้อมูลพื้นฐาน';

  @override
  String get profilePhotoUpdateFailed => 'ไม่สามารถอัปเดตรูปโปรไฟล์ได้';

  @override
  String get profilePhotoUpdated => 'อัปเดตรูปโปรไฟล์เรียบร้อยแล้ว';

  @override
  String get profileSettings => 'การตั้งค่าโปรไฟล์';

  @override
  String get profileSetup => 'กำลังตั้งค่าโปรไฟล์';

  @override
  String get profileUpdateFailed => 'ไม่สามารถอัปเดตโปรไฟล์ได้';

  @override
  String get profileUpdated => 'อัปเดตโปรไฟล์สำเร็จ';

  @override
  String get purchaseAndRefundPolicy => 'นโยบายการซื้อและคืนเงิน';

  @override
  String get purchaseButton => 'ซื้อ';

  @override
  String get purchaseConfirm => 'ยืนยันการซื้อ';

  @override
  String purchaseConfirmContent(String product, String price) {
    return 'ซื้อ $product ในราคา $price?';
  }

  @override
  String purchaseConfirmMessage(
      String title, String price, String description) {
    return 'ยืนยันการซื้อ $title ในราคา $price? $description';
  }

  @override
  String get purchaseFailed => 'การซื้อไม่สำเร็จ';

  @override
  String get purchaseHeartsOnly => 'ซื้อหัวใจ';

  @override
  String get purchaseMoreHearts => 'ซื้อหัวใจเพื่อดำเนินการสนทนาต่อ';

  @override
  String get purchasePending => 'การซื้ออยู่ระหว่างดำเนินการ...';

  @override
  String get purchasePolicy => 'นโยบายการซื้อ';

  @override
  String get purchaseSection1Content =>
      'เรารับชำระเงินผ่านช่องทางต่างๆ รวมถึงบัตรเครดิตและกระเป๋าเงินดิจิทัล';

  @override
  String get purchaseSection1Title => 'ช่องทางการชำระเงิน';

  @override
  String get purchaseSection2Content =>
      'สามารถขอคืนเงินได้ภายใน 14 วันหลังจากการซื้อ หากคุณยังไม่ได้ใช้สินค้าที่ซื้อ';

  @override
  String get purchaseSection2Title => 'นโยบายการคืนเงิน';

  @override
  String get purchaseSection3Content =>
      'คุณสามารถยกเลิกการสมัครสมาชิกได้ทุกเมื่อผ่านการตั้งค่าบัญชีของคุณ';

  @override
  String get purchaseSection3Title => 'การยกเลิก';

  @override
  String get purchaseSection4Content =>
      'โดยการทำการซื้อ คุณยอมรับข้อกำหนดการใช้งานและข้อตกลงการให้บริการของเรา';

  @override
  String get purchaseSection4Title => 'ข้อกำหนดการใช้งาน';

  @override
  String get purchaseSection5Content =>
      'สำหรับปัญหาที่เกี่ยวกับการซื้อ กรุณาติดต่อทีมสนับสนุนของเรา';

  @override
  String get purchaseSection5Title => 'ติดต่อฝ่ายสนับสนุน';

  @override
  String get purchaseSection6Content =>
      'การซื้อทั้งหมดอยู่ภายใต้ข้อกำหนดและเงื่อนไขมาตรฐานของเรา';

  @override
  String get purchaseSection6Title => '6. การสอบถาม';

  @override
  String get pushNotifications => 'การแจ้งเตือนแบบพุช';

  @override
  String get reading => 'การอ่าน';

  @override
  String get realtimeQualityLog => 'บันทึกคุณภาพแบบเรียลไทม์';

  @override
  String get recentConversation => 'การสนทนาล่าสุด:';

  @override
  String get recentLoginRequired => 'กรุณาเข้าสู่ระบบอีกครั้งเพื่อความปลอดภัย';

  @override
  String get referrerEmail => 'อีเมลผู้แนะนำ';

  @override
  String get referrerEmailHelper => 'ตัวเลือก: อีเมลของผู้ที่แนะนำคุณ';

  @override
  String get referrerEmailLabel => 'อีเมลผู้แนะนำ (ตัวเลือก)';

  @override
  String get refresh => 'รีเฟรช';

  @override
  String refreshComplete(int count) {
    return 'การรีเฟรชเสร็จสิ้น! $count บุคลิกภาพที่ตรงกัน';
  }

  @override
  String get refreshFailed => 'การรีเฟรชล้มเหลว';

  @override
  String get refreshingChatList => 'กำลังรีเฟรชรายการแชท...';

  @override
  String get relatedFAQ => 'คำถามที่พบบ่อยที่เกี่ยวข้อง';

  @override
  String get report => 'รายงาน';

  @override
  String get reportAI => 'รายงาน';

  @override
  String get reportAIDescription =>
      'หาก AI ทำให้คุณรู้สึกไม่สบายใจ กรุณาอธิบายปัญหา';

  @override
  String get reportAITitle => 'รายงานการสนทนา AI';

  @override
  String get reportAndBlock => 'รายงาน & บล็อก';

  @override
  String get reportAndBlockDescription =>
      'คุณสามารถรายงานและบล็อกพฤติกรรมที่ไม่เหมาะสมของ AI นี้';

  @override
  String get reportChatError => 'รายงานข้อผิดพลาดในการแชท';

  @override
  String reportError(String error) {
    return 'เกิดข้อผิดพลาดขณะรายงาน: $error';
  }

  @override
  String get reportFailed => 'การรายงานล้มเหลว';

  @override
  String get reportSubmitted =>
      'รายงานถูกส่งแล้ว เราจะตรวจสอบและดำเนินการต่อไป';

  @override
  String get reportSubmittedSuccess => 'รายงานของคุณถูกส่งแล้ว ขอบคุณ!';

  @override
  String get requestLimit => 'ขีดจำกัดการร้องขอ';

  @override
  String get required => '[จำเป็น]';

  @override
  String get requiredTermsAgreement => 'กรุณายอมรับข้อตกลง';

  @override
  String get restartConversation => 'เริ่มการสนทนาใหม่';

  @override
  String restartConversationQuestion(String name) {
    return 'เริ่มการสนทนาใหม่กับ $name?';
  }

  @override
  String restartConversationWithName(String name) {
    return 'กำลังเริ่มการสนทนาใหม่กับ $name!';
  }

  @override
  String get retry => 'ลองใหม่';

  @override
  String get retryButton => 'ลองอีกครั้ง';

  @override
  String get sad => 'เศร้า';

  @override
  String get saturday => 'วันเสาร์';

  @override
  String get save => 'บันทึก';

  @override
  String get search => 'ค้นหา';

  @override
  String get searchFAQ => 'ค้นหาคำถามที่พบบ่อย...';

  @override
  String get searchResults => 'ผลการค้นหา';

  @override
  String get selectEmotion => 'เลือกอารมณ์';

  @override
  String get selectErrorType => 'เลือกประเภทข้อผิดพลาด';

  @override
  String get selectFeeling => 'เลือกความรู้สึก';

  @override
  String get selectGender => 'เลือกเพศ';

  @override
  String get selectInterests => 'กรุณาเลือกความสนใจของคุณ (อย่างน้อย 1)';

  @override
  String get selectLanguage => 'เลือกภาษา';

  @override
  String get selectPersona => 'เลือกบุคลิก';

  @override
  String get selectPersonaPlease => 'กรุณาเลือกบุคลิก.';

  @override
  String get selectPreferredMbti =>
      'หากคุณชอบบุคลิกภาพที่มีประเภท MBTI เฉพาะ กรุณาเลือก';

  @override
  String get selectProblematicMessage => 'เลือกข้อความที่มีปัญหา (ไม่บังคับ)';

  @override
  String get selectReportReason => 'เลือกเหตุผลในการรายงาน';

  @override
  String get selectTheme => 'เลือกธีม';

  @override
  String get selectTranslationError =>
      'กรุณาเลือกข้อความที่มีข้อผิดพลาดในการแปล';

  @override
  String get selectUsagePurpose => 'กรุณาเลือกวัตถุประสงค์ในการใช้ SONA';

  @override
  String get selfIntroduction => 'แนะนำตัว (ไม่บังคับ)';

  @override
  String get selfIntroductionHint => 'เขียนแนะนำตัวสั้นๆ เกี่ยวกับตัวคุณ';

  @override
  String get send => 'ส่ง';

  @override
  String get sendChatError => 'ส่งข้อความแชทผิดพลาด';

  @override
  String get sendFirstMessage => 'ส่งข้อความแรกของคุณ';

  @override
  String get sendReport => 'ส่งรายงาน';

  @override
  String get sendingEmail => 'กำลังส่งอีเมล...';

  @override
  String get seoul => 'โซล';

  @override
  String get serverErrorDashboard => 'ข้อผิดพลาดของเซิร์ฟเวอร์';

  @override
  String get serviceTermsAgreement => 'กรุณายอมรับเงื่อนไขการให้บริการ';

  @override
  String get sessionExpired => 'เซสชันหมดอายุ';

  @override
  String get setAppInterfaceLanguage => 'ตั้งค่าภาษาของแอป';

  @override
  String get setNow => 'ตั้งค่าเดี๋ยวนี้';

  @override
  String get settings => 'การตั้งค่า';

  @override
  String get sexualContent => 'เนื้อหาทางเพศ';

  @override
  String get showAllGenderPersonas => 'แสดงเพอร์โซน่าทุกเพศ';

  @override
  String get showAllGendersOption => 'แสดงทุกเพศ';

  @override
  String get showOppositeGenderOnly =>
      'หากไม่เลือก จะมีเพียงบุคลิกภาพเพศตรงข้ามเท่านั้นที่จะแสดง';

  @override
  String get showOriginalText => 'แสดงข้อความต้นฉบับ';

  @override
  String get signUp => 'สมัครสมาชิก';

  @override
  String get signUpFromGuest => 'ลงทะเบียนตอนนี้เพื่อเข้าถึงฟีเจอร์ทั้งหมด!';

  @override
  String get signup => 'สมัครสมาชิก';

  @override
  String get signupComplete => 'ลงทะเบียนเสร็จสิ้น';

  @override
  String get signupTab => 'ลงทะเบียน';

  @override
  String get simpleInfoRequired =>
      'ต้องการข้อมูลพื้นฐานสำหรับการจับคู่กับ AI personas';

  @override
  String get skip => 'ข้าม';

  @override
  String get sonaFriend => 'เพื่อน SONA';

  @override
  String get sonaPrivacyPolicy => 'นโยบายความเป็นส่วนตัวของ SONA';

  @override
  String get sonaPurchasePolicy => 'นโยบายการซื้อของ SONA';

  @override
  String get sonaTermsOfService => 'ข้อตกลงการให้บริการของ SONA';

  @override
  String get sonaUsagePurpose => 'กรุณาเลือกวัตถุประสงค์ในการใช้ SONA';

  @override
  String get sorryNotHelpful => 'ขอโทษที่ไม่เป็นประโยชน์';

  @override
  String get sort => 'เรียง';

  @override
  String get soundSettings => 'ตั้งค่าเสียง';

  @override
  String get spamAdvertising => 'สแปม/โฆษณา';

  @override
  String get spanish => 'สเปน';

  @override
  String get specialRelationshipDesc =>
      'เข้าใจกันและสร้างความสัมพันธ์ที่ลึกซึ้ง';

  @override
  String get sports => 'กีฬา';

  @override
  String get spring => 'ฤดูใบไม้ผลิ';

  @override
  String get startChat => 'เริ่มแชท';

  @override
  String get startChatButton => 'เริ่มแชท';

  @override
  String get startConversation => 'เริ่มการสนทนา';

  @override
  String get startConversationLikeAFriend =>
      'เริ่มการสนทนากับ SONA เหมือนเพื่อน';

  @override
  String get startConversationStep =>
      '2. เริ่มการสนทนา: แชทอย่างอิสระกับ personas ที่จับคู่กัน';

  @override
  String get startConversationWithSona => 'เริ่มแชทกับ SONA เหมือนเพื่อน!';

  @override
  String get startWithEmail => 'เริ่มต้นด้วยอีเมล';

  @override
  String get startWithGoogle => 'เริ่มต้นด้วย Google';

  @override
  String get startingApp => 'กำลังเริ่มแอป';

  @override
  String get storageManagement => 'การจัดการพื้นที่เก็บข้อมูล';

  @override
  String get store => 'ร้านค้า';

  @override
  String get storeConnectionError => 'ไม่สามารถเชื่อมต่อกับร้านค้าได้';

  @override
  String get storeLoginRequiredMessage => 'ต้องเข้าสู่ระบบเพื่อใช้ร้านค้า';

  @override
  String get storeNotAvailable => 'ร้านค้าไม่พร้อมใช้งาน';

  @override
  String get storyEvent => 'เหตุการณ์ในเรื่อง';

  @override
  String get stressed => 'เครียด';

  @override
  String get submitReport => 'ส่งรายงาน';

  @override
  String get subscriptionStatus => 'สถานะการสมัครสมาชิก';

  @override
  String get subtleVibrationOnTouch => 'สั่นเบาๆ เมื่อสัมผัส';

  @override
  String get summer => 'ฤดูร้อน';

  @override
  String get sunday => 'วันอาทิตย์';

  @override
  String get swipeAnyDirection => 'ปัดในทิศทางใดก็ได้';

  @override
  String get swipeDownToClose => 'ปัดลงเพื่อปิด';

  @override
  String get systemTheme => 'ตามธีมของระบบ';

  @override
  String get systemThemeDesc =>
      'เปลี่ยนโดยอัตโนมัติตามการตั้งค่าระบบโหมดมืดของอุปกรณ์';

  @override
  String get tapBottomForDetails => 'แตะด้านล่างเพื่อดูรายละเอียด';

  @override
  String get tapForDetails => 'แตะที่บริเวณด้านล่างเพื่อดูรายละเอียด';

  @override
  String get tapToSwipePhotos => 'แตะเพื่อปัดรูปภาพ';

  @override
  String get teachersDay => 'วันครู';

  @override
  String get technicalError => 'ข้อผิดพลาดทางเทคนิค';

  @override
  String get technology => 'เทคโนโลยี';

  @override
  String get terms => 'ข้อตกลงการให้บริการ';

  @override
  String get termsAgreement => 'ข้อตกลงการให้บริการ';

  @override
  String get termsAgreementDescription => 'กรุณายอมรับข้อตกลงเพื่อใช้บริการ';

  @override
  String get termsOfService => 'เงื่อนไขการให้บริการ';

  @override
  String get termsSection10Content =>
      'เราขอสงวนสิทธิ์ในการแก้ไขข้อตกลงเหล่านี้ได้ตลอดเวลาโดยจะแจ้งให้ผู้ใช้ทราบ';

  @override
  String get termsSection10Title => 'มาตรา 10 (การระงับข้อพิพาท)';

  @override
  String get termsSection11Content =>
      'ข้อตกลงเหล่านี้จะอยู่ภายใต้กฎหมายของเขตอำนาจที่เราดำเนินการ';

  @override
  String get termsSection11Title => 'มาตรา 11 (ข้อกำหนดพิเศษสำหรับบริการ AI)';

  @override
  String get termsSection12Content =>
      'หากข้อกำหนดใดในข้อตกลงเหล่านี้ถูกพบว่าไม่สามารถบังคับใช้ได้ ข้อกำหนดที่เหลือจะยังคงมีผลบังคับใช้เต็มที่';

  @override
  String get termsSection12Title => 'มาตรา 12 (การเก็บรวบรวมและการใช้ข้อมูล)';

  @override
  String get termsSection1Content =>
      'ข้อตกลงและเงื่อนไขเหล่านี้มีจุดประสงค์เพื่อกำหนดสิทธิ หน้าที่ และความรับผิดชอบระหว่าง SONA (ต่อไปนี้เรียกว่า \"บริษัท\") และผู้ใช้เกี่ยวกับการใช้บริการจับคู่การสนทนา AI (ต่อไปนี้เรียกว่า \"บริการ\") ที่บริษัทจัดให้';

  @override
  String get termsSection1Title => 'มาตรา 1 (วัตถุประสงค์)';

  @override
  String get termsSection2Content =>
      'โดยการใช้บริการของเรา คุณยอมรับที่จะผูกพันตามข้อตกลงการให้บริการและนโยบายความเป็นส่วนตัวของเรา';

  @override
  String get termsSection2Title => 'มาตรา 2 (คำจำกัดความ)';

  @override
  String get termsSection3Content =>
      'คุณต้องมีอายุอย่างน้อย 13 ปีจึงจะสามารถใช้บริการของเราได้';

  @override
  String get termsSection3Title => 'มาตรา 3 (ผลและการแก้ไขข้อตกลง)';

  @override
  String get termsSection4Content =>
      'คุณมีหน้าที่รับผิดชอบในการรักษาความลับของบัญชีและรหัสผ่านของคุณ';

  @override
  String get termsSection4Title => 'มาตรา 4 (การให้บริการ)';

  @override
  String get termsSection5Content =>
      'คุณตกลงที่จะไม่ใช้บริการของเราเพื่อวัตถุประสงค์ที่ผิดกฎหมายหรือไม่ได้รับอนุญาต';

  @override
  String get termsSection5Title => 'มาตรา 5 (การลงทะเบียนสมาชิก)';

  @override
  String get termsSection6Content =>
      'เราขอสงวนสิทธิ์ในการยกเลิกหรือระงับบัญชีของคุณหากมีการละเมิดข้อกำหนดเหล่านี้';

  @override
  String get termsSection6Title => 'มาตรา 6 (หน้าที่ของผู้ใช้)';

  @override
  String get termsSection7Content =>
      'บริษัทอาจจำกัดการใช้บริการอย่างค่อยเป็นค่อยไปโดยการเตือน, การระงับชั่วคราว, หรือการระงับถาวรหากผู้ใช้ละเมิดหน้าที่ตามข้อกำหนดเหล่านี้หรือก่อกวนการดำเนินงานของบริการตามปกติ';

  @override
  String get termsSection7Title => 'มาตรา 7 (ข้อจำกัดการใช้บริการ)';

  @override
  String get termsSection8Content =>
      'เราจะไม่รับผิดชอบต่อความเสียหายที่เกิดขึ้นโดยอ้อม, บังเอิญ, หรือผลที่ตามมาจากการใช้บริการของเรา';

  @override
  String get termsSection8Title => 'มาตรา 8 (การหยุดชะงักของบริการ)';

  @override
  String get termsSection9Content =>
      'เนื้อหาและวัสดุทั้งหมดที่มีอยู่ในบริการของเราได้รับการคุ้มครองโดยสิทธิในทรัพย์สินทางปัญญา';

  @override
  String get termsSection9Title => 'มาตรา 9 (การปฏิเสธความรับผิด)';

  @override
  String get termsSupplementary => 'ข้อกำหนดเพิ่มเติม';

  @override
  String get thai => 'ไทย';

  @override
  String get thanksFeedback => 'ขอบคุณสำหรับความคิดเห็นของคุณ!';

  @override
  String get theme => 'ธีม';

  @override
  String get themeDescription =>
      'คุณสามารถปรับแต่งรูปลักษณ์ของแอปได้ตามที่คุณต้องการ';

  @override
  String get themeSettings => 'การตั้งค่าธีม';

  @override
  String get thursday => 'วันพฤหัสบดี';

  @override
  String get timeout => 'หมดเวลา';

  @override
  String get tired => 'เหนื่อย';

  @override
  String get today => 'วันนี้';

  @override
  String get todayChats => 'วันนี้';

  @override
  String get todayText => 'วันนี้';

  @override
  String get tomorrowText => 'วันพรุ่งนี้';

  @override
  String get totalConsultSessions => 'จำนวนการปรึกษาทั้งหมด';

  @override
  String get totalErrorCount => 'จำนวนข้อผิดพลาดทั้งหมด';

  @override
  String get totalLikes => 'จำนวนถูกใจทั้งหมด';

  @override
  String totalOccurrences(Object count) {
    return 'จำนวน $count ครั้ง';
  }

  @override
  String get totalResponses => 'จำนวนการตอบกลับทั้งหมด';

  @override
  String get translatedFrom => 'แปลจาก';

  @override
  String get translatedText => 'การแปล';

  @override
  String get translationError => 'ข้อผิดพลาดในการแปล';

  @override
  String get translationErrorDescription =>
      'กรุณารายงานการแปลที่ไม่ถูกต้องหรือการแสดงออกที่ไม่เหมาะสม';

  @override
  String get translationErrorReported => 'รายงานข้อผิดพลาดในการแปลแล้ว ขอบคุณ!';

  @override
  String get translationNote => '※ การแปลโดย AI อาจไม่สมบูรณ์';

  @override
  String get translationQuality => 'คุณภาพการแปล';

  @override
  String get translationSettings => 'การตั้งค่าการแปล';

  @override
  String get travel => 'การเดินทาง';

  @override
  String get tuesday => 'วันอังคาร';

  @override
  String get tutorialAccount => 'บัญชีสอนการใช้งาน';

  @override
  String get tutorialWelcomeDescription =>
      'สร้างความสัมพันธ์พิเศษกับ AI personas';

  @override
  String get tutorialWelcomeTitle => 'ยินดีต้อนรับสู่ SONA!';

  @override
  String get typeMessage => 'พิมพ์ข้อความ...';

  @override
  String get unblock => 'ยกเลิกบล็อก';

  @override
  String get unblockFailed => 'ไม่สามารถปลดบล็อกได้';

  @override
  String unblockPersonaConfirm(String name) {
    return 'ยกเลิกการบล็อก $name?';
  }

  @override
  String get unblockedSuccessfully => 'ปลดบล็อกสำเร็จ';

  @override
  String get unexpectedLoginError =>
      'เกิดข้อผิดพลาดที่ไม่คาดคิดระหว่างการเข้าสู่ระบบ';

  @override
  String get unknown => 'ไม่ทราบ';

  @override
  String get unknownError => 'ข้อผิดพลาดที่ไม่ทราบสาเหตุ';

  @override
  String get unlimitedMessages => 'ข้อความไม่จำกัด';

  @override
  String get unsendMessage => 'ยกเลิกการส่งข้อความ';

  @override
  String get usagePurpose => 'วัตถุประสงค์การใช้งาน';

  @override
  String get useOneHeart => 'ใช้ 1 หัวใจ';

  @override
  String get useSystemLanguage => 'ใช้ภาษาของระบบ';

  @override
  String get user => 'ผู้ใช้:';

  @override
  String get userMessage => 'ข้อความจากผู้ใช้:';

  @override
  String get userNotFound => 'ไม่พบผู้ใช้';

  @override
  String get valentinesDay => 'วันวาเลนไทน์';

  @override
  String get verifyingAuth => 'กำลังตรวจสอบการรับรองตัวตน';

  @override
  String get version => 'เวอร์ชัน';

  @override
  String get vietnamese => 'เวียดนาม';

  @override
  String get violentContent => 'เนื้อหาที่มีความรุนแรง';

  @override
  String get voiceMessage => '🎤 ข้อความเสียง';

  @override
  String waitingForChat(String name) {
    return '$name กำลังรอการสนทนาอยู่';
  }

  @override
  String get walk => 'เดิน';

  @override
  String get wasHelpful => 'นี่มีประโยชน์ไหม?';

  @override
  String get weatherClear => 'แจ่มใส';

  @override
  String get weatherCloudy => 'มีเมฆ';

  @override
  String get weatherContext => 'บริบทสภาพอากาศ';

  @override
  String get weatherContextDesc => 'ให้บริบทการสนทนาตามสภาพอากาศ';

  @override
  String get weatherDrizzle => 'ฝนปรอย';

  @override
  String get weatherFog => 'หมอก';

  @override
  String get weatherMist => 'หมอกบาง';

  @override
  String get weatherRain => 'ฝน';

  @override
  String get weatherRainy => 'ฝนตก';

  @override
  String get weatherSnow => 'หิมะ';

  @override
  String get weatherSnowy => 'หิมะตก';

  @override
  String get weatherThunderstorm => 'พายุฝนฟ้าคะนอง';

  @override
  String get wednesday => 'วันพุธ';

  @override
  String get weekdays => 'อา,จ,อ,พ,พฤ,ศ,ส';

  @override
  String get welcomeMessage => 'ยินดีต้อนรับ💕';

  @override
  String get whatTopicsToTalk =>
      'คุณต้องการพูดคุยเกี่ยวกับหัวข้ออะไร? (ไม่บังคับ)';

  @override
  String get whiteDay => 'วันไวท์เดย์';

  @override
  String get winter => 'ฤดูหนาว';

  @override
  String get wrongTranslation => 'การแปลผิด';

  @override
  String get year => 'ปี';

  @override
  String get yearEnd => 'สิ้นปี';

  @override
  String get yes => 'ใช่';

  @override
  String get yesterday => 'เมื่อวาน';

  @override
  String get yesterdayChats => 'เมื่อวานนี้';

  @override
  String get you => 'คุณ';

  @override
  String get loadingPersonaData => 'กำลังโหลดข้อมูลเพอร์โซน่า';

  @override
  String get checkingMatchedPersonas => 'กำลังตรวจสอบเพอร์โซน่าที่จับคู่แล้ว';

  @override
  String get preparingImages => 'กำลังเตรียมรูปภาพ';

  @override
  String get finalPreparation => 'การเตรียมการขั้นสุดท้าย';

  @override
  String get editProfileSubtitle => 'แก้ไขเพศ วันเกิด และการแนะนำตัว';

  @override
  String get systemThemeName => 'ระบบ';

  @override
  String get lightThemeName => 'สว่าง';

  @override
  String get darkThemeName => 'มืด';
}
