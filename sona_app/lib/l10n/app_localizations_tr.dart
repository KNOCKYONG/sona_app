// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get about => 'Hakkında';

  @override
  String get accountAndProfile => 'Hesap ve Profil Bilgileri';

  @override
  String get accountDeletedSuccess => 'Hesap başarıyla silindi';

  @override
  String get accountDeletionContent =>
      'Hesabınızı silmek istediğinize emin misiniz?';

  @override
  String get accountDeletionError => 'Hesap silinirken bir hata oluştu.';

  @override
  String get accountDeletionInfo => 'Hesap silme bilgisi';

  @override
  String get accountDeletionTitle => 'Hesabı Sil';

  @override
  String get accountDeletionWarning1 => 'Uyarı: Bu işlem geri alınamaz';

  @override
  String get accountDeletionWarning2 =>
      'Tüm verileriniz kalıcı olarak silinecektir';

  @override
  String get accountDeletionWarning3 =>
      'Tüm sohbetlere erişiminizi kaybedeceksiniz';

  @override
  String get accountDeletionWarning4 =>
      'Bu, satın alınan tüm içerikleri de kapsar';

  @override
  String get accountManagement => 'Hesap Yönetimi';

  @override
  String get adaptiveConversationDesc =>
      'Sohbet stilini size uyacak şekilde uyarlıyor';

  @override
  String get afternoon => 'Öğleden sonra';

  @override
  String get afternoonFatigue => 'Öğleden sonra yorgunluğu';

  @override
  String get ageConfirmation =>
      '14 yaşındayım veya daha büyüküm ve yukarıdakileri onaylıyorum.';

  @override
  String ageRange(int min, int max) {
    return '$min-$max yaşında';
  }

  @override
  String get ageUnit => 'yaşında';

  @override
  String get agreeToTerms => 'Şartları kabul ediyorum';

  @override
  String get aiDatingQuestion => 'AI ile özel bir günlük yaşam';

  @override
  String get aiPersonaPreferenceDescription =>
      'Lütfen AI kişilik eşleştirmesi için tercihlerinizi ayarlayın';

  @override
  String get all => 'Hepsi';

  @override
  String get allAgree => 'Hepsini kabul et';

  @override
  String get allFeaturesRequired =>
      '※ Tüm özellikler hizmet sunumu için gereklidir';

  @override
  String get allPersonas => 'Tüm Kişilikler';

  @override
  String get allPersonasMatched =>
      'Tüm persona eşleşti! Onlarla sohbet etmeye başlayın.';

  @override
  String get allowPermission => 'Devam';

  @override
  String alreadyChattingWith(String name) {
    return 'Zaten $name ile sohbet ediyorsunuz!';
  }

  @override
  String get alsoBlockThisAI => 'Bu AI\'yı da engelle';

  @override
  String get angry => 'Kızgın';

  @override
  String get anonymousLogin => 'Anonim giriş';

  @override
  String get anxious => 'Endişeli';

  @override
  String get apiKeyError => 'API Anahtar Hatası';

  @override
  String get appName => 'SONA';

  @override
  String get appTagline => 'AI arkadaşlarınız';

  @override
  String get appleLoginCanceled =>
      'Apple girişi iptal edildi. Lütfen tekrar deneyin.';

  @override
  String get appleLoginError => 'Apple girişi sırasında bir hata oluştu.';

  @override
  String get art => 'Sanat';

  @override
  String get authError => 'Kimlik Doğrulama Hatası';

  @override
  String get autoTranslate => 'Otomatik Çeviri';

  @override
  String get autumn => 'Sonbahar';

  @override
  String get averageQuality => 'Ortalama Kalite';

  @override
  String get averageQualityScore => 'Ortalama Kalite Puanı';

  @override
  String get awkwardExpression => 'Garip İfade';

  @override
  String get backButton => 'Geri';

  @override
  String get basicInfo => 'Temel Bilgiler';

  @override
  String get basicInfoDescription =>
      'Bir hesap oluşturmak için lütfen temel bilgilerinizi girin';

  @override
  String get birthDate => 'Doğum Tarihi';

  @override
  String get birthDateOptional => 'Doğum Tarihi (Opsiyonel)';

  @override
  String get birthDateRequired => 'Doğum Tarihi *';

  @override
  String get blockConfirm => 'Bu AI\'yi engellemek istiyor musunuz?';

  @override
  String get blockReason => 'Engelleme nedeni';

  @override
  String get blockThisAI => 'Bu AI\'yı engelle';

  @override
  String blockedAICount(int count) {
    return '$count engellenmiş AI';
  }

  @override
  String get blockedAIs => 'Engellenmiş AI\'lar';

  @override
  String get blockedAt => 'Engellendiği zaman';

  @override
  String get blockedSuccessfully => 'Başarıyla engellendi';

  @override
  String get breakfast => 'Kahvaltı';

  @override
  String get byErrorType => 'Hata Türüne Göre';

  @override
  String get byPersona => 'Persona\'ya Göre';

  @override
  String cacheDeleteError(String error) {
    return 'Önbelleği silerken hata: $error';
  }

  @override
  String get cacheDeleted => 'Görüntü önbelleği silindi';

  @override
  String get cafeTerrace => 'Kafe terası';

  @override
  String get calm => 'Sakin';

  @override
  String get cameraPermission => 'Kamera İzni';

  @override
  String get cameraPermissionDesc =>
      'Fotoğraf çekmek için kamera iznine ihtiyacımız var.';

  @override
  String get canChangeInSettings =>
      'Bunu daha sonra ayarlardan değiştirebilirsiniz';

  @override
  String get canMeetPreviousPersonas =>
      'Daha önce kaydırdığınız kişiliklerle tekrar buluşabilirsiniz!';

  @override
  String get cancel => 'İptal';

  @override
  String get changeProfilePhoto => 'Profil Fotoğrafını Değiştir';

  @override
  String get chat => 'Sohbet';

  @override
  String get chatEndedMessage => 'Sohbet sona erdi';

  @override
  String get chatErrorDashboard => 'Sohbet Hatası Panosu';

  @override
  String get chatErrorSentSuccessfully => 'Sohbet hatası başarıyla gönderildi.';

  @override
  String get chatListTab => 'Sohbet Listesi Sekmesi';

  @override
  String get chats => 'Sohbetler';

  @override
  String chattingWithPersonas(int count) {
    return '$count kişilikle sohbet ediliyor';
  }

  @override
  String get checkInternetConnection =>
      'Lütfen internet bağlantınızı kontrol edin';

  @override
  String get checkingUserInfo => 'Kullanıcı bilgileri kontrol ediliyor';

  @override
  String get childrensDay => 'Çocuklar Günü';

  @override
  String get chinese => 'Çince';

  @override
  String get chooseOption => 'Lütfen seçin:';

  @override
  String get christmas => 'Noel';

  @override
  String get close => 'Kapat';

  @override
  String get complete => 'Tamam';

  @override
  String get completeSignup => 'Kayıt Tamamla';

  @override
  String get confirm => 'Onayla';

  @override
  String get connectingToServer => 'Sunucuya bağlanıyor';

  @override
  String get consultQualityMonitoring => 'Danışmanlık Kalite İzleme';

  @override
  String get continueAsGuest => 'Misafir olarak devam et';

  @override
  String get continueButton => 'Devam et';

  @override
  String get continueWithApple => 'Apple ile devam et';

  @override
  String get continueWithGoogle => 'Google ile devam et';

  @override
  String get conversationContinuity => 'Sohbet Sürekliliği';

  @override
  String get conversationContinuityDesc =>
      'Önceki sohbetleri hatırla ve konuları bağla';

  @override
  String conversationWith(String name) {
    return '$name';
  }

  @override
  String get convertToMember => 'Üye Ol';

  @override
  String get cooking => 'Yemek Pişirme';

  @override
  String get copyMessage => 'Mesajı kopyala';

  @override
  String get copyrightInfringement => 'Telif hakkı ihlali';

  @override
  String get creatingAccount => 'Hesap oluşturuluyor';

  @override
  String get crisisDetected => 'Kriz Tespit Edildi';

  @override
  String get culturalIssue => 'Kültürel Sorun';

  @override
  String get current => 'Güncel';

  @override
  String get currentCacheSize => 'Mevcut Önbellek Boyutu';

  @override
  String get currentLanguage => 'Mevcut Dil';

  @override
  String get cycling => 'Bisiklet Sürme';

  @override
  String get dailyCare => 'Günlük Bakım';

  @override
  String get dailyCareDesc => 'Yemek, uyku, sağlık için günlük bakım mesajları';

  @override
  String get dailyChat => 'Günlük Sohbet';

  @override
  String get dailyCheck => 'Günlük Kontrol';

  @override
  String get dailyConversation => 'Günlük Konuşma';

  @override
  String get dailyLimitDescription => 'Günlük mesaj limitinize ulaştınız';

  @override
  String get dailyLimitTitle => 'Günlük Limit Aşıldı';

  @override
  String get darkMode => 'Karanlık Mod';

  @override
  String get darkTheme => 'Karanlık Mod';

  @override
  String get darkThemeDesc => 'Karanlık temayı kullanın';

  @override
  String get dataCollection => 'Veri Toplama Ayarları';

  @override
  String get datingAdvice => 'Flört Tavsiyesi';

  @override
  String get datingDescription =>
      'Derin düşünceler paylaşmak ve samimi sohbetler yapmak istiyorum';

  @override
  String get dawn => 'Şafak';

  @override
  String get day => 'Gün';

  @override
  String get dayAfterTomorrow => 'Yarından sonraki gün';

  @override
  String daysAgo(int count, String formatted) {
    return '$count gün önce';
  }

  @override
  String daysRemaining(int days) {
    return '$days gün kaldı';
  }

  @override
  String get deepTalk => 'Derin Sohbet';

  @override
  String get delete => 'Sil';

  @override
  String get deleteAccount => 'Hesabı Sil';

  @override
  String get deleteAccountConfirm =>
      'Hesabınızı silmek istediğinizden emin misiniz? Bu işlem geri alınamaz.';

  @override
  String get deleteAccountWarning =>
      'Hesabınızı silmek istediğinizden emin misiniz?';

  @override
  String get deleteCache => 'Önbelleği Sil';

  @override
  String get deletingAccount => 'Hesap siliniyor...';

  @override
  String get depressed => 'Depresyonda';

  @override
  String get describeError => 'Sorun nedir?';

  @override
  String get detailedReason => 'Ayrıntılı neden';

  @override
  String get developRelationshipStep =>
      '3. İlişki Geliştirme: Sohbetler aracılığıyla yakınlık kurun ve özel ilişkiler geliştirin.';

  @override
  String get dinner => 'Akşam Yemeği';

  @override
  String get discardGuestData => 'Yeniden Başla';

  @override
  String get discount20 => '%20 indirim';

  @override
  String get discount30 => '%30 indirim';

  @override
  String get discountAmount => 'Tasarruf Et';

  @override
  String discountAmountValue(String amount) {
    return '₩$amount tasarruf et';
  }

  @override
  String get done => 'Tamam';

  @override
  String get downloadingPersonaImages => 'Yeni persona görselleri indiriliyor';

  @override
  String get edit => 'Düzenle';

  @override
  String get editInfo => 'Bilgileri Düzenle';

  @override
  String get editProfile => 'Profili Düzenle';

  @override
  String get effectSound => 'Ses Efektleri';

  @override
  String get effectSoundDescription => 'Ses efektlerini çal';

  @override
  String get email => 'E-posta';

  @override
  String get emailHint => 'ornek@email.com';

  @override
  String get emailLabel => 'E-posta';

  @override
  String get emailRequired => 'E-posta *';

  @override
  String get emotionAnalysis => 'Duygu Analizi';

  @override
  String get emotionAnalysisDesc => 'Empatik yanıtlar için duyguları analiz et';

  @override
  String get emotionAngry => 'Kızgın';

  @override
  String get emotionBasedEncounters => 'Duygularına göre kişiliklerle tanış';

  @override
  String get emotionCool => 'Havalı';

  @override
  String get emotionHappy => 'Mutlu';

  @override
  String get emotionLove => 'Aşk';

  @override
  String get emotionSad => 'Üzgün';

  @override
  String get emotionThinking => 'Düşünüyor';

  @override
  String get emotionalSupportDesc =>
      'Endişelerinizi paylaşın ve sıcak bir destek alın';

  @override
  String get endChat => 'Sohbeti Bitir';

  @override
  String get endTutorial => 'Eğitimi Bitir';

  @override
  String get endTutorialAndLogin =>
      'Eğitimi bitirip giriş yapmak istiyor musunuz?';

  @override
  String get endTutorialMessage =>
      'Eğitimi bitirip giriş yapmak istiyor musunuz?';

  @override
  String get english => 'İngilizce';

  @override
  String get enterBasicInfo =>
      'Hesap oluşturmak için lütfen temel bilgilerinizi girin';

  @override
  String get enterBasicInformation => 'Lütfen temel bilgilerinizi girin';

  @override
  String get enterEmail => 'E-posta Girin';

  @override
  String get enterNickname => 'Lütfen bir takma ad girin';

  @override
  String get enterPassword => 'Şifre Girin';

  @override
  String get entertainmentAndFunDesc =>
      'Eğlenceli oyunların ve keyifli sohbetlerin tadını çıkarın';

  @override
  String get entertainmentDescription =>
      'Eğlenceli sohbetler yapmak ve zamanımı keyifle geçirmek istiyorum';

  @override
  String get entertainmentFun => 'Eğlence/Keyif';

  @override
  String get error => 'Hata';

  @override
  String get errorDescription => 'Hata açıklaması';

  @override
  String get errorDescriptionHint =>
      'Örneğin, Garip cevaplar verdi, Aynı şeyi tekrar ediyor, Bağlam açısından uygun olmayan yanıtlar veriyor...';

  @override
  String get errorDetails => 'Hata Ayrıntıları';

  @override
  String get errorDetailsHint =>
      'Lütfen neyin yanlış olduğunu detaylı bir şekilde açıklayın';

  @override
  String get errorFrequency24h => 'Hata Sıklığı (Son 24 saat)';

  @override
  String get errorMessage => 'Hata Mesajı:';

  @override
  String get errorOccurred => 'Bir hata oluştu.';

  @override
  String get errorOccurredTryAgain => 'Bir hata oluştu. Lütfen tekrar deneyin.';

  @override
  String get errorSendingFailed => 'Hata gönderilemedi.';

  @override
  String get errorStats => 'Hata İstatistikleri';

  @override
  String errorWithMessage(String error) {
    return 'Hata oluştu: $error';
  }

  @override
  String get evening => 'Akşam';

  @override
  String get excited => 'Heyecanlı';

  @override
  String get exit => 'Çıkış';

  @override
  String get exitApp => 'Uygulamadan Çık';

  @override
  String get exitConfirmMessage =>
      'Uygulamadan çıkmak istediğinize emin misiniz?';

  @override
  String get expertPersona => 'Uzman Persona';

  @override
  String get expertiseScore => 'Uzmanlık Puanı';

  @override
  String get expired => 'Süresi Dolmuş';

  @override
  String get explainReportReason =>
      'Lütfen rapor nedenini detaylı bir şekilde açıklayın';

  @override
  String get fashion => 'Moda';

  @override
  String get female => 'Kadın';

  @override
  String get filter => 'Filtrele';

  @override
  String get firstOccurred => 'İlk Oluşum:';

  @override
  String get followDeviceLanguage => 'Cihaz dil ayarlarını takip et';

  @override
  String get forenoon => 'Öğle Öncesi';

  @override
  String get forgotPassword => 'Şifremi Unuttum?';

  @override
  String get frequentlyAskedQuestions => 'Sıkça Sorulan Sorular';

  @override
  String get friday => 'Cuma';

  @override
  String get friendshipDescription =>
      'Yeni arkadaşlar edinmek ve sohbet etmek istiyorum';

  @override
  String get funChat => 'Eğlenceli Sohbet';

  @override
  String get galleryPermission => 'Galeri İzni';

  @override
  String get galleryPermissionDesc =>
      'Fotoğraf seçmek için galeri iznine ihtiyacımız var.';

  @override
  String get gaming => 'Oyun';

  @override
  String get gender => 'Cinsiyet';

  @override
  String get genderNotSelectedInfo =>
      'Cinsiyet seçilmediğinde, tüm cinsiyetlerden persona gösterilecektir';

  @override
  String get genderOptional => 'Cinsiyet (İsteğe Bağlı)';

  @override
  String get genderPreferenceActive =>
      'Tüm cinsiyetlerden persona ile tanışabilirsiniz';

  @override
  String get genderPreferenceDisabled =>
      'Karşı cins seçeneğini etkinleştirmek için cinsiyetinizi seçin';

  @override
  String get genderPreferenceInactive =>
      'Sadece karşı cins kişilikler gösterilecektir';

  @override
  String get genderRequired => 'Cinsiyet *';

  @override
  String get genderSelectionInfo =>
      'Seçilmezse, tüm cinsiyetlerden kişiliklerle tanışabilirsiniz';

  @override
  String get generalPersona => 'Genel Kişilik';

  @override
  String get goToSettings => 'Ayarlara Git';

  @override
  String get googleLoginCanceled => 'Google girişi iptal edildi.';

  @override
  String get googleLoginError => 'Google girişi sırasında bir hata oluştu.';

  @override
  String get grantPermission => 'Devam';

  @override
  String get guest => 'Misafir';

  @override
  String get guestDataMigration =>
      'Üye olurken mevcut sohbet geçmişinizi saklamak ister misiniz?';

  @override
  String get guestLimitReached => 'Misafir denemesi sona erdi.';

  @override
  String get guestLoginPromptMessage => 'Sohbete devam etmek için giriş yapın';

  @override
  String get guestMessageExhausted => 'Ücretsiz mesaj hakkı tükendi';

  @override
  String guestMessageRemaining(int count) {
    return '$count misafir mesajı kaldı';
  }

  @override
  String get guestModeBanner => 'Misafir Modu';

  @override
  String get guestModeDescription => 'SONA\'ya kaydolmadan göz atın';

  @override
  String get guestModeFailedMessage => 'Misafir Modu başlatılamadı';

  @override
  String get guestModeLimitation =>
      'Misafir Modu\'nda bazı özellikler sınırlıdır';

  @override
  String get guestModeTitle => 'Misafir Olarak Deneyin';

  @override
  String get guestModeWarning =>
      'Misafir modu 24 saat sürer, ardından veriler silinecektir.';

  @override
  String get guestModeWelcome => 'Misafir Modu\'nda başlatılıyor';

  @override
  String get happy => 'Mutlu';

  @override
  String get hapticFeedback => 'Dokunsal Geri Bildirim';

  @override
  String get harassmentBullying => 'Taciz/Zorbalık';

  @override
  String get hateSpeech => 'Nefret söylemi';

  @override
  String get heartDescription => 'Daha fazla mesaj için kalpler';

  @override
  String get heartInsufficient => 'Yeterli kalp yok';

  @override
  String get heartInsufficientPleaseCharge =>
      'Yeterli kalp yok. Lütfen kalpleri yeniden yükleyin.';

  @override
  String get heartRequired => '1 kalp gereklidir';

  @override
  String get heartUsageFailed => 'Kalp kullanma işlemi başarısız oldu.';

  @override
  String get hearts => 'Kalpler';

  @override
  String get hearts10 => '10 Kalp';

  @override
  String get hearts30 => '30 Kalp';

  @override
  String get hearts30Discount => 'İNDİRİM';

  @override
  String get hearts50 => '50 Kalp';

  @override
  String get hearts50Discount => 'İNDİRİM';

  @override
  String get helloEmoji => 'Merhaba! 😊';

  @override
  String get help => 'Yardım';

  @override
  String get hideOriginalText => 'Orijinal Metni Gizle';

  @override
  String get hobbySharing => 'Hobileri Paylaşma';

  @override
  String get hobbyTalk => 'Hobiler Hakkında Sohbet';

  @override
  String get hours24Ago => '24 saat önce';

  @override
  String hoursAgo(int count, String formatted) {
    return '$count saat önce';
  }

  @override
  String get howToUse => 'SONA nasıl kullanılır';

  @override
  String get imageCacheManagement => 'Görüntü Önbellek Yönetimi';

  @override
  String get inappropriateContent => 'Uygunsuz içerik';

  @override
  String get incorrect => 'hatalı';

  @override
  String get incorrectPassword => 'Hatalı şifre';

  @override
  String get indonesian => 'Endonezyaca';

  @override
  String get inquiries => 'Soruşturma';

  @override
  String get insufficientHearts => 'Yetersiz kalp.';

  @override
  String get interestSharing => 'İlgi Alanlarını Paylaşma';

  @override
  String get interestSharingDesc =>
      'Paylaşılan ilgi alanlarını keşfedin ve önerin';

  @override
  String get interests => 'İlgi Alanları';

  @override
  String get invalidEmailFormat => 'Geçersiz e-posta formatı';

  @override
  String get invalidEmailFormatError =>
      'Lütfen geçerli bir e-posta adresi girin';

  @override
  String isTyping(String name) {
    return '$name yazıyor...';
  }

  @override
  String get japanese => 'Japonca';

  @override
  String get joinDate => 'Katılma Tarihi';

  @override
  String get justNow => 'Şimdi';

  @override
  String get keepGuestData => 'Sohbet Geçmişini Sakla';

  @override
  String get korean => 'Korece';

  @override
  String get koreanLanguage => 'Korece';

  @override
  String get language => 'Dil';

  @override
  String get languageDescription => 'AI, seçtiğiniz dilde yanıt verecek';

  @override
  String get languageIndicator => 'Dil';

  @override
  String get languageSettings => 'Dil Ayarları';

  @override
  String get lastOccurred => 'Son Gerçekleşme:';

  @override
  String get lastUpdated => 'Son Güncelleme';

  @override
  String get lateNight => 'Gece geç saat';

  @override
  String get later => 'Daha sonra';

  @override
  String get laterButton => 'Daha sonra';

  @override
  String get leave => 'Ayrıl';

  @override
  String get leaveChatConfirm => 'Bu sohbetten ayrılmak istiyor musun?';

  @override
  String get leaveChatRoom => 'Sohbet Odasından Ayrıl';

  @override
  String get leaveChatTitle => 'Sohbetten Ayrıl';

  @override
  String get lifeAdvice => 'Hayat Tavsiyesi';

  @override
  String get lightTalk => 'Hafif Sohbet';

  @override
  String get lightTheme => 'Aydınlık Mod';

  @override
  String get lightThemeDesc => 'Parlak temayı kullan';

  @override
  String get loading => 'Yükleniyor...';

  @override
  String get loadingData => 'Veriler yükleniyor...';

  @override
  String get loadingProducts => 'Ürünler yükleniyor...';

  @override
  String get loadingProfile => 'Profil yükleniyor';

  @override
  String get login => 'Giriş Yap';

  @override
  String get loginButton => 'Giriş Yap';

  @override
  String get loginCancelled => 'Giriş iptal edildi';

  @override
  String get loginComplete => 'Giriş tamamlandı';

  @override
  String get loginError => 'Giriş başarısız';

  @override
  String get loginFailed => 'Giriş başarısız';

  @override
  String get loginFailedTryAgain => 'Giriş başarısız. Lütfen tekrar deneyin.';

  @override
  String get loginRequired => 'Giriş yapılması gerekiyor';

  @override
  String get loginRequiredForProfile =>
      'Profili görüntülemek ve SONA ile kayıtları kontrol etmek için giriş yapmanız gerekiyor';

  @override
  String get loginRequiredService =>
      'Bu hizmeti kullanmak için giriş yapmanız gerekiyor';

  @override
  String get loginRequiredTitle => 'Giriş Gerekiyor';

  @override
  String get loginSignup => 'Giriş / Kayıt Ol';

  @override
  String get loginTab => 'Giriş';

  @override
  String get loginTitle => 'Giriş';

  @override
  String get loginWithApple => 'Apple ile Giriş';

  @override
  String get loginWithGoogle => 'Google ile Giriş';

  @override
  String get logout => 'Çıkış Yap';

  @override
  String get logoutConfirm => 'Çıkış yapmak istediğinizden emin misiniz?';

  @override
  String get lonelinessRelief => 'Yalnızlık Giderici';

  @override
  String get lonely => 'Yalnız';

  @override
  String get lowQualityResponses => 'Düşük Kalite Yanıtlar';

  @override
  String get lunch => 'Öğle Yemeği';

  @override
  String get lunchtime => 'Öğle Vakti';

  @override
  String get mainErrorType => 'Ana Hata Türü';

  @override
  String get makeFriends => 'Arkadaş Edin';

  @override
  String get male => 'Erkek';

  @override
  String get manageBlockedAIs => 'Engellenen Yapay Zekaları Yönet';

  @override
  String get managePersonaImageCache => 'Persona görüntü önbelleğini yönet';

  @override
  String get marketingAgree => 'Pazarlama Bilgilerini Kabul Et (İsteğe Bağlı)';

  @override
  String get marketingDescription =>
      'Etkinlik ve fayda bilgilerini alabilirsiniz';

  @override
  String get matchPersonaStep =>
      '1. Persona Eşleştir: Favori yapay zeka personanızı seçmek için sola veya sağa kaydırın.';

  @override
  String get matchedPersonas => 'Eşleşen Personalar';

  @override
  String get matchedSona => 'Eşleşen SONA';

  @override
  String get matching => 'Eşleştiriliyor';

  @override
  String get matchingFailed => 'Eşleşme başarısız oldu.';

  @override
  String get me => 'Me';

  @override
  String get meetAIPersonas => 'AI Kişiliklerle Tanışın';

  @override
  String get meetNewPersonas => 'Yeni Kişiliklerle Tanışın';

  @override
  String get meetPersonas => 'Kişiliklerle Tanışın';

  @override
  String get memberBenefits =>
      'Kaydolduğunuzda 100\'den fazla mesaj ve 10 kalp kazanın!';

  @override
  String get memoryAlbum => 'Anı Albümü';

  @override
  String get memoryAlbumDesc =>
      'Özel anları otomatik olarak kaydedin ve hatırlayın';

  @override
  String get messageCopied => 'Mesaj kopyalandı';

  @override
  String get messageDeleted => 'Mesaj silindi';

  @override
  String get messageLimitReset => 'Mesaj limiti gece yarısı sıfırlanacak';

  @override
  String get messageSendFailed => 'Mesaj gönderilemedi. Lütfen tekrar deneyin.';

  @override
  String get messagesRemaining => 'Kalan Mesajlar';

  @override
  String minutesAgo(int count, String formatted) {
    return '$count dakika önce';
  }

  @override
  String get missingTranslation => 'Çeviri Eksik';

  @override
  String get monday => 'Pazartesi';

  @override
  String get month => 'Ay';

  @override
  String monthDay(String month, int day) {
    return '$month $day';
  }

  @override
  String get moreButton => 'Daha Fazla';

  @override
  String get morning => 'Sabah';

  @override
  String get mostFrequentError => 'En Sık Karşılaşılan Hata';

  @override
  String get movies => 'Filmler';

  @override
  String get multilingualChat => 'Çok Dilli Sohbet';

  @override
  String get music => 'Müzik';

  @override
  String get myGenderSection => 'Cinsiyetim (İsteğe Bağlı)';

  @override
  String get networkErrorOccurred => 'Bir ağ hatası oluştu.';

  @override
  String get newMessage => 'Yeni Mesaj';

  @override
  String newMessageCount(int count) {
    return '$count yeni mesaj';
  }

  @override
  String get newMessageNotification =>
      'Yeni mesajlar hakkında beni bilgilendir';

  @override
  String get newMessages => 'Yeni mesajlar';

  @override
  String get newYear => 'Yeni Yıl';

  @override
  String get next => 'İleri';

  @override
  String get niceToMeetYou => 'Tanıştığımıza memnun oldum!';

  @override
  String get nickname => 'Takma ad';

  @override
  String get nicknameAlreadyUsed => 'Bu takma ad zaten kullanılıyor';

  @override
  String get nicknameHelperText => '3-10 karakter';

  @override
  String get nicknameHint => '3-10 karakter';

  @override
  String get nicknameInUse => 'Bu takma ad zaten kullanılıyor';

  @override
  String get nicknameLabel => 'Takma ad';

  @override
  String get nicknameLengthError => 'Takma ad 3-10 karakter olmalıdır';

  @override
  String get nicknamePlaceholder => 'Takma adınızı girin';

  @override
  String get nicknameRequired => 'Takma ad *';

  @override
  String get night => 'Gece';

  @override
  String get no => 'Hayır';

  @override
  String get noBlockedAIs => 'Engellenmiş yapay zekâ yok';

  @override
  String get noChatsYet => 'Henüz sohbet yok';

  @override
  String get noConversationYet => 'Henüz konuşma yok';

  @override
  String get noErrorReports => 'Hata raporu yok.';

  @override
  String get noImageAvailable => 'Görüntü mevcut değil';

  @override
  String get noMatchedPersonas => 'Henüz eşleşen persona yok';

  @override
  String get noMatchedSonas => 'Henüz eşleşen SONA yok';

  @override
  String get noPersonasAvailable =>
      'Persona mevcut değil. Lütfen tekrar deneyin.';

  @override
  String get noPersonasToSelect => 'Seçilecek persona yok';

  @override
  String get noQualityIssues => 'Son bir saatte kalite sorunu yok ✅';

  @override
  String get noQualityLogs => 'Henüz kalite kaydı yok.';

  @override
  String get noTranslatedMessages => 'Çevrilecek mesaj yok.';

  @override
  String get notEnoughHearts => 'Yeterli kalp yok.';

  @override
  String notEnoughHeartsCount(int count) {
    return 'Yeterli kalp yok. (Mevcut: $count)';
  }

  @override
  String get notRegistered => 'kayıtlı değil';

  @override
  String get notSubscribed => 'Abone değil';

  @override
  String get notificationPermissionDesc =>
      'Bildirim göndermek için bildirim iznine ihtiyacımız var.';

  @override
  String get notificationPermissionRequired => 'Bildirim izni gerekli';

  @override
  String get notificationSettings => 'Bildirim Ayarları';

  @override
  String get notifications => 'Bildirimler';

  @override
  String get occurrenceInfo => 'Olay Bilgisi:';

  @override
  String get olderChats => 'Eski';

  @override
  String get onlyOppositeGenderNote =>
      'Seçili değilse, yalnızca karşı cins kişilikler gösterilecektir.';

  @override
  String get openSettings => 'Ayarları Aç';

  @override
  String get optional => 'Opsiyonel';

  @override
  String get or => 'or';

  @override
  String get originalPrice => 'Orijinal';

  @override
  String get originalText => 'Orijinal';

  @override
  String get other => 'Diğer';

  @override
  String get otherError => 'Diğer Hata';

  @override
  String get others => 'Diğerleri';

  @override
  String get ownedHearts => 'Sahip Olunan Kalpler';

  @override
  String get parentsDay => 'Anneler ve Babalar Günü';

  @override
  String get password => 'Şifre';

  @override
  String get passwordConfirmation => 'Onaylamak için şifreyi girin';

  @override
  String get passwordConfirmationDesc =>
      'Hesabı silmek için lütfen şifrenizi tekrar girin.';

  @override
  String get passwordHint => '6 karakter veya daha fazla';

  @override
  String get passwordLabel => 'Şifre';

  @override
  String get passwordRequired => 'Şifre *';

  @override
  String get passwordResetEmailPrompt =>
      'Şifreyi sıfırlamak için lütfen e-posta adresinizi girin';

  @override
  String get passwordResetEmailSent =>
      'Şifre sıfırlama e-postası gönderildi. Lütfen e-posta kutunuzu kontrol edin.';

  @override
  String get passwordText => 'şifre';

  @override
  String get passwordTooShort => 'Şifre en az 6 karakter olmalıdır';

  @override
  String get permissionDenied => 'İzin Reddedildi';

  @override
  String permissionDeniedMessage(String permissionName) {
    return '$permissionName reddedildi. Lütfen ayarlardan izin verin.';
  }

  @override
  String get permissionDeniedTryLater =>
      'İzin reddedildi. Lütfen daha sonra tekrar deneyin.';

  @override
  String get permissionRequired => 'İzin Gerekli';

  @override
  String get personaGenderSection => 'Persona Cinsiyet Tercihi';

  @override
  String get personaQualityStats => 'Persona Kalite İstatistikleri';

  @override
  String get personalInfoExposure => 'Kişisel bilgi ifşası';

  @override
  String get personality => 'Kişilik';

  @override
  String get pets => 'Evcil hayvanlar';

  @override
  String get photo => 'Fotoğraf';

  @override
  String get photography => 'Fotoğrafçılık';

  @override
  String get picnic => 'Piknik';

  @override
  String get preferenceSettings => 'Tercih Ayarları';

  @override
  String get preferredLanguage => 'Tercih Edilen Dil';

  @override
  String get preparingForSleep => 'Uykuya hazırlanıyor';

  @override
  String get preparingNewMeeting => 'Yeni toplantı hazırlanıyor';

  @override
  String get preparingPersonaImages => 'Persona görselleri hazırlanıyor';

  @override
  String get preparingPersonas => 'Personas hazırlanıyor';

  @override
  String get preview => 'Önizleme';

  @override
  String get previous => 'Önceki';

  @override
  String get privacy => 'Gizlilik Politikası';

  @override
  String get privacyPolicy => 'Gizlilik Politikası';

  @override
  String get privacyPolicyAgreement =>
      'Lütfen gizlilik politikasını kabul edin';

  @override
  String get privacySection1Content =>
      'Gizliliğinizi korumaya kararlıyız. Bu Gizlilik Politikası, hizmetimizi kullandığınızda bilgilerinizi nasıl topladığımızı, kullandığımızı ve koruduğumuzu açıklar.';

  @override
  String get privacySection1Title =>
      '1. Kişisel Bilgilerin Toplanma ve Kullanım Amacı';

  @override
  String get privacySection2Content =>
      'Hesap oluşturduğunuzda, profilinizi güncellediğinizde veya hizmetlerimizi kullandığınızda doğrudan bize sağladığınız bilgileri topluyoruz.';

  @override
  String get privacySection2Title => 'Topladığımız Bilgiler';

  @override
  String get privacySection3Content =>
      'Topladığımız bilgileri hizmetlerimizi sağlamak, sürdürmek ve geliştirmek, ayrıca sizinle iletişim kurmak için kullanıyoruz.';

  @override
  String get privacySection3Title =>
      '3. Kişisel Bilgilerin Saklanma ve Kullanım Süresi';

  @override
  String get privacySection4Content =>
      'Kişisel bilgilerinizi izniniz olmadan üçüncü şahıslara satmıyoruz, takas etmiyoruz veya başka bir şekilde aktarmıyoruz.';

  @override
  String get privacySection4Title =>
      '4. Kişisel Bilgilerin Üçüncü Şahıslara Sağlanması';

  @override
  String get privacySection5Content =>
      'Kişisel bilgilerinizi yetkisiz erişim, değişiklik, ifşa veya yok edilme karşısında korumak için uygun güvenlik önlemleri alıyoruz.';

  @override
  String get privacySection5Title =>
      '5. Kişisel Bilgiler için Teknik Koruma Önlemleri';

  @override
  String get privacySection6Content =>
      'Hizmetlerimizi sağlamak ve yasal yükümlülüklere uymak için gerekli olduğu sürece kişisel bilgileri saklıyoruz.';

  @override
  String get privacySection6Title => '6. Kullanıcı Hakları';

  @override
  String get privacySection7Content =>
      'Hesap ayarlarınızdan istediğiniz zaman kişisel bilgilerinize erişme, güncelleme veya silme hakkına sahipsiniz.';

  @override
  String get privacySection7Title => 'Haklarınız';

  @override
  String get privacySection8Content =>
      'Bu Gizlilik Politikası hakkında herhangi bir sorunuz varsa, lütfen support@sona.com adresinden bizimle iletişime geçin.';

  @override
  String get privacySection8Title => 'Bizimle İletişime Geçin';

  @override
  String get privacySettings => 'Gizlilik Ayarları';

  @override
  String get privacySettingsInfo =>
      'Bireysel özellikleri devre dışı bırakmak, bu hizmetlerin kullanılamaz hale gelmesine neden olacaktır.';

  @override
  String get privacySettingsScreen => 'Gizlilik Ayarları';

  @override
  String get problemMessage => 'Problem';

  @override
  String get problemOccurred => 'Problem Oluştu';

  @override
  String get profile => 'Profil';

  @override
  String get profileEdit => 'Profili Düzenle';

  @override
  String get profileEditLoginRequiredMessage =>
      'Profilinizi düzenlemek için giriş yapmanız gerekmektedir. Giriş ekranına gitmek ister misiniz?';

  @override
  String get profileInfo => 'Profil Bilgileri';

  @override
  String get profileInfoDescription =>
      'Lütfen profil fotoğrafınızı ve temel bilgilerinizi girin.';

  @override
  String get profileNav => 'Profil';

  @override
  String get profilePhoto => 'Profil Fotoğrafı';

  @override
  String get profilePhotoAndInfo =>
      'Lütfen profil fotoğrafını ve temel bilgilerini girin.';

  @override
  String get profilePhotoUpdateFailed => 'Profil fotoğrafı güncellenemedi';

  @override
  String get profilePhotoUpdated => 'Profil fotoğrafı güncellendi';

  @override
  String get profileSettings => 'Profil Ayarları';

  @override
  String get profileSetup => 'Profil Kurulumu';

  @override
  String get profileUpdateFailed => 'Profil güncellenemedi';

  @override
  String get profileUpdated => 'Profil başarıyla güncellendi';

  @override
  String get purchaseAndRefundPolicy => 'Satın Alma & İade Politikası';

  @override
  String get purchaseButton => 'Satın Al';

  @override
  String get purchaseConfirm => 'Satın Alma Onayı';

  @override
  String purchaseConfirmContent(String product, String price) {
    return '$price karşılığında $product satın alacak mısınız?';
  }

  @override
  String purchaseConfirmMessage(
      String title, String price, String description) {
    return '$price karşılığında $title satın alımını onaylıyor musunuz? $description';
  }

  @override
  String get purchaseFailed => 'Satın alma başarısız oldu';

  @override
  String get purchaseHeartsOnly => 'Kalp satın al';

  @override
  String get purchaseMoreHearts =>
      'Sohbetlere devam etmek için kalp satın alın';

  @override
  String get purchasePending => 'Satın alma bekleniyor...';

  @override
  String get purchasePolicy => 'Satın Alma Politikası';

  @override
  String get purchaseSection1Content =>
      'Kredi kartları ve dijital cüzdanlar dahil olmak üzere çeşitli ödeme yöntemlerini kabul ediyoruz.';

  @override
  String get purchaseSection1Title => 'Ödeme Yöntemleri';

  @override
  String get purchaseSection2Content =>
      'Satın alınan ürünleri kullanmadıysanız, satın alma işleminden itibaren 14 gün içinde iade talep edebilirsiniz.';

  @override
  String get purchaseSection2Title => 'İade Politikası';

  @override
  String get purchaseSection3Content =>
      'Aboneliğinizi istediğiniz zaman hesap ayarlarınızdan iptal edebilirsiniz.';

  @override
  String get purchaseSection3Title => 'İptal';

  @override
  String get purchaseSection4Content =>
      'Satın alma işlemi yaparak, kullanım şartlarımızı ve hizmet sözleşmemizi kabul etmiş olursunuz.';

  @override
  String get purchaseSection4Title => 'Kullanım Şartları';

  @override
  String get purchaseSection5Content =>
      'Satın alma ile ilgili sorunlar için lütfen destek ekibimizle iletişime geçin.';

  @override
  String get purchaseSection5Title => 'Destekle İletişime Geç';

  @override
  String get purchaseSection6Content =>
      'Tüm satın alımlar standart şartlar ve koşullarımıza tabidir.';

  @override
  String get purchaseSection6Title => '6. Sorgular';

  @override
  String get pushNotifications => 'Anlık Bildirimler';

  @override
  String get reading => 'Okuma';

  @override
  String get realtimeQualityLog => 'Gerçek Zamanlı Kalite Kaydı';

  @override
  String get recentConversation => 'Son Görüşme:';

  @override
  String get recentLoginRequired => 'Güvenlik için lütfen tekrar giriş yapın';

  @override
  String get referrerEmail => 'Referans E-postası';

  @override
  String get referrerEmailHelper =>
      'Opsiyonel: Sizi referans eden kişinin e-postası';

  @override
  String get referrerEmailLabel => 'Referans E-postası (Opsiyonel)';

  @override
  String get refresh => 'Yenile';

  @override
  String refreshComplete(int count) {
    return 'Yenileme tamamlandı! $count eşleşen persona';
  }

  @override
  String get refreshFailed => 'Yenileme başarısız oldu';

  @override
  String get refreshingChatList => 'Sohbet listesini yeniliyor...';

  @override
  String get relatedFAQ => 'İlgili SSS';

  @override
  String get report => 'Bildir';

  @override
  String get reportAI => 'Bildir';

  @override
  String get reportAIDescription =>
      'Eğer yapay zeka sizi rahatsız ettiyse, lütfen durumu açıklayın.';

  @override
  String get reportAITitle => 'Yapay Zeka Sohbetini Bildir';

  @override
  String get reportAndBlock => 'Bildir & Engelle';

  @override
  String get reportAndBlockDescription =>
      'Bu yapay zekanın uygunsuz davranışını bildirebilir ve engelleyebilirsiniz.';

  @override
  String get reportChatError => 'Sohbet Hatasını Bildir';

  @override
  String reportError(String error) {
    return 'Bildirirken hata oluştu: $error';
  }

  @override
  String get reportFailed => 'Bildirim başarısız oldu';

  @override
  String get reportSubmitted =>
      'Bildirim gönderildi. İnceleyip gerekli işlemi yapacağız.';

  @override
  String get reportSubmittedSuccess =>
      'Bildiriminiz gönderildi. Teşekkür ederiz!';

  @override
  String get requestLimit => 'İstek Limiti';

  @override
  String get required => '[Gerekli]';

  @override
  String get requiredTermsAgreement => 'Lütfen şartları kabul edin';

  @override
  String get restartConversation => 'Sohbeti Yenile';

  @override
  String restartConversationQuestion(String name) {
    return '$name ile sohbeti yenilemek ister misiniz?';
  }

  @override
  String restartConversationWithName(String name) {
    return '$name ile sohbet yenileniyor!';
  }

  @override
  String get retry => 'Tekrar Dene';

  @override
  String get retryButton => 'Yeniden Dene';

  @override
  String get sad => 'Üzgün';

  @override
  String get saturday => 'Cumartesi';

  @override
  String get save => 'Kaydet';

  @override
  String get search => 'Ara';

  @override
  String get searchFAQ => 'SSS\'yi Ara...';

  @override
  String get searchResults => 'Arama sonuçları';

  @override
  String get selectEmotion => 'Duygu Seç';

  @override
  String get selectErrorType => 'Hata türünü seç';

  @override
  String get selectFeeling => 'Duygu Seç';

  @override
  String get selectGender => 'Cinsiyet Seçin';

  @override
  String get selectInterests => 'Lütfen ilgi alanlarınızı seçin (en az 1)';

  @override
  String get selectLanguage => 'Dil Seçin';

  @override
  String get selectPersona => 'Bir persona seçin';

  @override
  String get selectPersonaPlease => 'Lütfen bir persona seçin.';

  @override
  String get selectPreferredMbti =>
      'Belirli MBTI türlerine sahip personaları tercih ediyorsanız, lütfen seçin';

  @override
  String get selectProblematicMessage => 'Sorunlu mesajı seçin (isteğe bağlı)';

  @override
  String get selectReportReason => 'Rapor nedeni seçin';

  @override
  String get selectTheme => 'Tema Seçin';

  @override
  String get selectTranslationError =>
      'Lütfen çeviri hatası olan bir mesaj seçin';

  @override
  String get selectUsagePurpose => 'Lütfen SONA\'yı kullanma amacınızı seçin';

  @override
  String get selfIntroduction => 'Tanıtım (İsteğe Bağlı)';

  @override
  String get selfIntroductionHint => 'Kendiniz hakkında kısa bir tanıtım yazın';

  @override
  String get send => 'Gönder';

  @override
  String get sendChatError => 'Sohbet Gönderim Hatası';

  @override
  String get sendFirstMessage => 'İlk mesajınızı gönderin';

  @override
  String get sendReport => 'Raporu Gönder';

  @override
  String get sendingEmail => 'E-posta gönderiliyor...';

  @override
  String get seoul => 'Seul';

  @override
  String get serverErrorDashboard => 'Sunucu Hatası';

  @override
  String get serviceTermsAgreement => 'Lütfen hizmet şartlarını kabul edin';

  @override
  String get sessionExpired => 'Oturum süresi doldu';

  @override
  String get setAppInterfaceLanguage => 'Uygulama arayüz dilini ayarlayın';

  @override
  String get setNow => 'Şimdi Ayarla';

  @override
  String get settings => 'Ayarlar';

  @override
  String get sexualContent => 'Cinsel içerik';

  @override
  String get showAllGenderPersonas => 'Tüm Cinsiyet Persona\'larını Göster';

  @override
  String get showAllGendersOption => 'Tüm Cinsiyetleri Göster';

  @override
  String get showOppositeGenderOnly =>
      'Seçili değilse, yalnızca karşı cins kişilikleri gösterilecektir';

  @override
  String get showOriginalText => 'Orijinali Göster';

  @override
  String get signUp => 'Kayıt Ol';

  @override
  String get signUpFromGuest => 'Tüm özelliklere erişmek için şimdi kaydolun!';

  @override
  String get signup => 'Kaydol';

  @override
  String get signupComplete => 'Kayıt Tamamlandı';

  @override
  String get signupTab => 'Kaydol';

  @override
  String get simpleInfoRequired => 'Basit bilgiler gereklidir';

  @override
  String get skip => 'Atla';

  @override
  String get sonaFriend => 'SONA Arkadaş';

  @override
  String get sonaPrivacyPolicy => 'SONA Gizlilik Politikası';

  @override
  String get sonaPurchasePolicy => 'SONA Satın Alma Politikası';

  @override
  String get sonaTermsOfService => 'SONA Hizmet Şartları';

  @override
  String get sonaUsagePurpose => 'Lütfen SONA\'yı kullanma amacınızı seçin';

  @override
  String get sorryNotHelpful => 'Üzgünüm, bu yardımcı olmadı';

  @override
  String get sort => 'Sırala';

  @override
  String get soundSettings => 'Ses Ayarları';

  @override
  String get spamAdvertising => 'Spam/Reklam';

  @override
  String get spanish => 'İspanyolca';

  @override
  String get specialRelationshipDesc =>
      'Birbirinizi anlayın ve derin bağlar kurun';

  @override
  String get sports => 'Sporlar';

  @override
  String get spring => 'Bahar';

  @override
  String get startChat => 'Sohbete Başla';

  @override
  String get startChatButton => 'Sohbete Başla';

  @override
  String get startConversation => 'Konuşma başlat';

  @override
  String get startConversationLikeAFriend =>
      'Sona ile bir arkadaş gibi sohbet etmeye başlayın';

  @override
  String get startConversationStep =>
      '2. Sohbete Başla: Eşleşen karakterlerle serbestçe sohbet edin.';

  @override
  String get startConversationWithSona =>
      'Sona ile bir arkadaş gibi sohbet etmeye başlayın!';

  @override
  String get startWithEmail => 'E-posta ile başla';

  @override
  String get startWithGoogle => 'Google ile başla';

  @override
  String get startingApp => 'Uygulama başlatılıyor';

  @override
  String get storageManagement => 'Depolama Yönetimi';

  @override
  String get store => 'Mağaza';

  @override
  String get storeConnectionError => 'Mağazaya bağlanılamadı';

  @override
  String get storeLoginRequiredMessage =>
      'Mağazayı kullanmak için giriş yapmanız gerekiyor. Giriş ekranına gitmek ister misiniz?';

  @override
  String get storeNotAvailable => 'Mağaza mevcut değil';

  @override
  String get storyEvent => 'Hikaye Olayı';

  @override
  String get stressed => 'Stresli';

  @override
  String get submitReport => 'Raporu Gönder';

  @override
  String get subscriptionStatus => 'Abonelik Durumu';

  @override
  String get subtleVibrationOnTouch => 'Dokunulduğunda hafif titreşim';

  @override
  String get summer => 'Yaz';

  @override
  String get sunday => 'Pazar';

  @override
  String get swipeAnyDirection => 'Herhangi bir yöne kaydır';

  @override
  String get swipeDownToClose => 'Kapatmak için aşağı kaydır';

  @override
  String get systemTheme => 'Sistemi Takip Et';

  @override
  String get systemThemeDesc =>
      'Cihazın karanlık mod ayarlarına göre otomatik olarak değişir';

  @override
  String get tapBottomForDetails => 'Detayları görmek için alt alana dokunun';

  @override
  String get tapForDetails => 'Detaylar için alt alana dokunun';

  @override
  String get tapToSwipePhotos => 'Fotoğrafları kaydırmak için dokunun';

  @override
  String get teachersDay => 'Öğretmenler Günü';

  @override
  String get technicalError => 'Teknik Hata';

  @override
  String get technology => 'Teknoloji';

  @override
  String get terms => 'Hizmet Şartları';

  @override
  String get termsAgreement => 'Şartlar Anlaşması';

  @override
  String get termsAgreementDescription =>
      'Lütfen hizmeti kullanmak için şartları kabul edin';

  @override
  String get termsOfService => 'Hizmet Şartları';

  @override
  String get termsSection10Content =>
      'Bu şartları herhangi bir zamanda kullanıcıları bilgilendirerek değiştirme hakkını saklı tutarız.';

  @override
  String get termsSection10Title => 'Madde 10 (Uyuşmazlık Çözümü)';

  @override
  String get termsSection11Content =>
      'Bu şartlar, faaliyet gösterdiğimiz yargı alanının yasalarına tabi olacaktır.';

  @override
  String get termsSection11Title => 'Madde 11 (AI Hizmeti Özel Hükümleri)';

  @override
  String get termsSection12Content =>
      'Bu şartların herhangi bir hükmü uygulanamaz bulunursa, kalan hükümler tam olarak yürürlükte kalmaya devam edecektir.';

  @override
  String get termsSection12Title => 'Madde 12 (Veri Toplama ve Kullanım)';

  @override
  String get termsSection1Content =>
      'Bu şartlar ve koşullar, SONA (bundan sonra \"Şirket\") ile kullanıcılar arasında, Şirket tarafından sağlanan AI persona sohbet eşleştirme hizmetinin (bundan sonra \"Hizmet\") kullanımıyla ilgili hakları, yükümlülükleri ve sorumlulukları tanımlamayı amaçlamaktadır.';

  @override
  String get termsSection1Title => 'Madde 1 (Amaç)';

  @override
  String get termsSection2Content =>
      'Hizmetimizi kullanarak, bu Hizmet Şartları ve Gizlilik Politikasına uymayı kabul ediyorsunuz.';

  @override
  String get termsSection2Title => 'Madde 2 (Tanımlar)';

  @override
  String get termsSection3Content =>
      'Hizmetimizi kullanmak için en az 13 yaşında olmalısınız.';

  @override
  String get termsSection3Title =>
      'Madde 3 (Şartların Geçerliliği ve Değiştirilmesi)';

  @override
  String get termsSection4Content =>
      'Hesabınızın ve şifrenizin gizliliğini korumaktan siz sorumlusunuz.';

  @override
  String get termsSection4Title => 'Madde 4 (Hizmetin Sunumu)';

  @override
  String get termsSection5Content =>
      'Hizmetimizi herhangi bir yasa dışı veya yetkisiz amaçla kullanmamayı kabul ediyorsunuz.';

  @override
  String get termsSection5Title => 'Madde 5 (Üyelik Kaydı)';

  @override
  String get termsSection6Content =>
      'Bu şartları ihlal etmeniz durumunda hesabınızı sonlandırma veya askıya alma hakkını saklı tutuyoruz.';

  @override
  String get termsSection6Title => 'Madde 6 (Kullanıcı Yükümlülükleri)';

  @override
  String get termsSection7Content =>
      'Şirket, kullanıcıların bu şartların yükümlülüklerini ihlal etmesi veya normal hizmet işlemlerine müdahale etmesi durumunda, hizmet kullanımını uyarılar, geçici askıya alma veya kalıcı askıya alma yoluyla kademeli olarak kısıtlayabilir.';

  @override
  String get termsSection7Title => 'Madde 7 (Hizmet Kullanım Kısıtlamaları)';

  @override
  String get termsSection8Content =>
      'Hizmetimizi kullanmanızdan kaynaklanan dolaylı, tesadüfi veya sonuç olarak ortaya çıkan zararlardan sorumlu değiliz.';

  @override
  String get termsSection8Title => 'Madde 8 (Hizmet Kesintisi)';

  @override
  String get termsSection9Content =>
      'Hizmetimizde mevcut olan tüm içerik ve materyaller fikri mülkiyet haklarıyla korunmaktadır.';

  @override
  String get termsSection9Title => 'Madde 9 (Feragat)';

  @override
  String get termsSupplementary => 'Ek Şartlar';

  @override
  String get thai => 'Tay';

  @override
  String get thanksFeedback => 'Geri bildiriminiz için teşekkürler!';

  @override
  String get theme => 'Tema';

  @override
  String get themeDescription =>
      'Uygulamanın görünümünü istediğiniz gibi özelleştirebilirsiniz.';

  @override
  String get themeSettings => 'Tema Ayarları';

  @override
  String get thursday => 'Perşembe';

  @override
  String get timeout => 'Zaman Aşımı';

  @override
  String get tired => 'Yorgun';

  @override
  String get today => 'Bugün';

  @override
  String get todayChats => 'Bugün';

  @override
  String get todayText => 'Bugün';

  @override
  String get tomorrowText => 'Yarın';

  @override
  String get totalConsultSessions => 'Toplam Danışma Seansları';

  @override
  String get totalErrorCount => 'Toplam Hata Sayısı';

  @override
  String get totalLikes => 'Toplam Beğeni';

  @override
  String totalOccurrences(Object count) {
    return 'Toplam $count kez';
  }

  @override
  String get totalResponses => 'Toplam Yanıt';

  @override
  String get translatedFrom => 'Çeviri';

  @override
  String get translatedText => 'Çeviri';

  @override
  String get translationError => 'Çeviri hatası';

  @override
  String get translationErrorDescription =>
      'Lütfen yanlış çevirileri veya garip ifadeleri bildirin';

  @override
  String get translationErrorReported =>
      'Çeviri hatası bildirildi. Teşekkürler!';

  @override
  String get translationNote => '※ AI çevirisi mükemmel olmayabilir';

  @override
  String get translationQuality => 'Çeviri Kalitesi';

  @override
  String get translationSettings => 'Çeviri Ayarları';

  @override
  String get travel => 'Seyahat';

  @override
  String get tuesday => 'Salı';

  @override
  String get tutorialAccount => 'Eğitim Hesabı';

  @override
  String get tutorialWelcomeDescription =>
      'AI kişilikleriyle özel ilişkiler kurun.';

  @override
  String get tutorialWelcomeTitle => 'SONA\'ya Hoş Geldiniz!';

  @override
  String get typeMessage => 'Bir mesaj yazın...';

  @override
  String get unblock => 'Engeli Kaldır';

  @override
  String get unblockFailed => 'Engeli kaldırma başarısız oldu';

  @override
  String unblockPersonaConfirm(String name) {
    return '$name\'ın engelini kaldırmak istiyor musunuz?';
  }

  @override
  String get unblockedSuccessfully => 'Başarıyla engel kaldırıldı';

  @override
  String get unexpectedLoginError =>
      'Giriş sırasında beklenmedik bir hata oluştu';

  @override
  String get unknown => 'Bilinmiyor';

  @override
  String get unknownError => 'Bilinmeyen hata';

  @override
  String get unlimitedMessages => 'Sınırsız';

  @override
  String get unsendMessage => 'Mesajı geri al';

  @override
  String get usagePurpose => 'Kullanım Amacı';

  @override
  String get useOneHeart => '1 Kalp Kullan';

  @override
  String get useSystemLanguage => 'Sistem Dilini Kullan';

  @override
  String get user => 'Kullanıcı:';

  @override
  String get userMessage => 'Kullanıcı Mesajı:';

  @override
  String get userNotFound => 'Kullanıcı bulunamadı';

  @override
  String get valentinesDay => 'Sevgililer Günü';

  @override
  String get verifyingAuth => 'Kimlik doğrulama kontrol ediliyor';

  @override
  String get version => 'Versiyon';

  @override
  String get vietnamese => 'Vietnamca';

  @override
  String get violentContent => 'Şiddet içeren içerik';

  @override
  String get voiceMessage => '🎤 Sesli mesaj';

  @override
  String waitingForChat(String name) {
    return '$name sohbet etmek için bekliyor.';
  }

  @override
  String get walk => 'Yürüyüş';

  @override
  String get wasHelpful => 'Bu yardımcı oldu mu?';

  @override
  String get weatherClear => 'Açık';

  @override
  String get weatherCloudy => 'Bulutlu';

  @override
  String get weatherContext => 'Hava Durumu Bağlamı';

  @override
  String get weatherContextDesc =>
      'Hava durumu temelinde konuşma bağlamı sağlayın';

  @override
  String get weatherDrizzle => 'Çiseleme';

  @override
  String get weatherFog => 'Sis';

  @override
  String get weatherMist => 'Pus';

  @override
  String get weatherRain => 'Yağmur';

  @override
  String get weatherRainy => 'Yağmurlu';

  @override
  String get weatherSnow => 'Kar';

  @override
  String get weatherSnowy => 'Karlı';

  @override
  String get weatherThunderstorm => 'Fırtına';

  @override
  String get wednesday => 'Çarşamba';

  @override
  String get weekdays => 'Paz, Pzt, Sal, Çar, Per, Cum, Cmt';

  @override
  String get welcomeMessage => 'Hoş geldiniz💕';

  @override
  String get whatTopicsToTalk =>
      'Hangi konular hakkında konuşmak istersiniz? (İsteğe bağlı)';

  @override
  String get whiteDay => 'Beyaz Gün';

  @override
  String get winter => 'Kış';

  @override
  String get wrongTranslation => 'Yanlış Çeviri';

  @override
  String get year => 'Yıl';

  @override
  String get yearEnd => 'Yıl Sonu';

  @override
  String get yes => 'Evet';

  @override
  String get yesterday => 'Dün';

  @override
  String get yesterdayChats => 'Dün';

  @override
  String get you => 'Sen';

  @override
  String get loadingPersonaData => 'Kişilik verileri yükleniyor';

  @override
  String get checkingMatchedPersonas => 'Eşleşen kişilikler kontrol ediliyor';

  @override
  String get preparingImages => 'Görüntüler hazırlanıyor';

  @override
  String get finalPreparation => 'Son hazırlık';

  @override
  String get editProfileSubtitle =>
      'Cinsiyet, doğum tarihi ve tanıtımı düzenle';

  @override
  String get systemThemeName => 'Sistem';

  @override
  String get lightThemeName => 'Açık';

  @override
  String get darkThemeName => 'Koyu';
}
