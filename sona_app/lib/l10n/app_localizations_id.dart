// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get about => 'Tentang';

  @override
  String get accountAndProfile => 'Akun & Profil';

  @override
  String get accountDeletedSuccess => 'Akun berhasil dihapus';

  @override
  String get accountDeletionContent =>
      'Apakah Anda yakin ingin menghapus akun Anda? Tindakan ini tidak dapat dibatalkan.';

  @override
  String get accountDeletionError => 'Terjadi kesalahan saat menghapus akun.';

  @override
  String get accountDeletionInfo => 'Informasi penghapusan akun';

  @override
  String get accountDeletionTitle => 'Hapus Akun';

  @override
  String get accountDeletionWarning1 =>
      'Peringatan: Tindakan ini tidak dapat dibatalkan';

  @override
  String get accountDeletionWarning2 => 'Semua data Anda akan dihapus permanen';

  @override
  String get accountDeletionWarning3 =>
      'Anda akan kehilangan akses ke semua percakapan';

  @override
  String get accountDeletionWarning4 => 'Ini termasuk semua konten yang dibeli';

  @override
  String get accountManagement => 'Manajemen akun';

  @override
  String get adaptiveConversationDesc =>
      'Menyesuaikan gaya percakapan agar sesuai dengan Anda';

  @override
  String get afternoon => 'Sore';

  @override
  String get afternoonFatigue => 'Kelelahan sore';

  @override
  String get ageConfirmation =>
      'Saya berusia 14 tahun atau lebih dan telah mengonfirmasi di atas.';

  @override
  String ageRange(int min, int max) {
    return '$min-$max tahun';
  }

  @override
  String get ageUnit => 'tahun';

  @override
  String get agreeToTerms => 'Saya setuju dengan persyaratan';

  @override
  String get aiDatingQuestion => 'Tertarik berkencan dengan AI?';

  @override
  String get aiPersonaPreferenceDescription =>
      'Silakan atur preferensi Anda untuk pencocokan persona AI';

  @override
  String get all => 'Semua';

  @override
  String get allAgree => 'Setuju untuk Semua';

  @override
  String get allFeaturesRequired =>
      '※ Semua fitur diperlukan untuk penyediaan layanan';

  @override
  String get allPersonas => 'Semua persona';

  @override
  String get allPersonasMatched => 'Semua persona dicocokkan';

  @override
  String get allowPermission => 'Lanjutkan';

  @override
  String alreadyChattingWith(String name) {
    return 'Sudah chatting dengan $name!';
  }

  @override
  String get alsoBlockThisAI => 'Juga blok AI ini';

  @override
  String get angry => 'Marah';

  @override
  String get anonymousLogin => 'Login anonim';

  @override
  String get anxious => 'Cemas';

  @override
  String get apiKeyError => 'Kesalahan Kunci API';

  @override
  String get appName => 'SONA';

  @override
  String get appTagline => 'Teman AI Anda';

  @override
  String get appleLoginCanceled => 'Login Apple dibatalkan. Silakan coba lagi.';

  @override
  String get appleLoginError => 'Error masuk Apple';

  @override
  String get art => 'Seni';

  @override
  String get authError => 'Kesalahan Autentikasi';

  @override
  String get autoTranslate => 'Terjemahan Otomatis';

  @override
  String get autumn => 'Musim Gugur';

  @override
  String get averageQuality => 'Kualitas Rata-rata';

  @override
  String get averageQualityScore => 'Skor Kualitas Rata-rata';

  @override
  String get awkwardExpression => 'Ekspresi Canggung';

  @override
  String get backButton => 'Kembali';

  @override
  String get basicInfo => 'Informasi Dasar';

  @override
  String get basicInfoDescription =>
      'Silakan masukkan informasi dasar untuk membuat akun';

  @override
  String get birthDate => 'Tanggal lahir';

  @override
  String get birthDateOptional => 'Tanggal lahir (opsional)';

  @override
  String get birthDateRequired => 'Silakan pilih tanggal lahir';

  @override
  String get blockConfirm => 'Apakah Anda ingin memblokir AI ini?';

  @override
  String get blockReason => 'Alasan pemblokiran';

  @override
  String get blockThisAI => 'Blokir AI ini';

  @override
  String blockedAICount(int count) {
    return '$count AI yang diblokir';
  }

  @override
  String get blockedAIs => 'AI yang diblokir';

  @override
  String get blockedAt => 'Diblokir pada';

  @override
  String get blockedSuccessfully => 'Berhasil diblokir';

  @override
  String get breakfast => 'Sarapan';

  @override
  String get byErrorType => 'Berdasarkan Tipe Kesalahan';

  @override
  String get byPersona => 'Berdasarkan Persona';

  @override
  String cacheDeleteError(String error) {
    return 'Kesalahan menghapus cache: $error';
  }

  @override
  String get cacheDeleted => 'Cache gambar telah dihapus';

  @override
  String get cafeTerrace => 'Teras kafe';

  @override
  String get calm => 'Tenang';

  @override
  String get cameraPermission => 'Izin kamera';

  @override
  String get cameraPermissionDesc =>
      'Akses kamera diperlukan untuk mengambil foto profil.';

  @override
  String get canChangeInSettings =>
      'Anda dapat mengubah ini nanti di pengaturan';

  @override
  String get canMeetPreviousPersonas => 'Anda dapat bertemu persona';

  @override
  String get cancel => 'Batal';

  @override
  String get changeProfilePhoto => 'Ubah Foto Profil';

  @override
  String get chat => 'Obrolan';

  @override
  String get chatEndedMessage => 'Obrolan berakhir';

  @override
  String get chatErrorDashboard => 'Dasbor Kesalahan Obrolan';

  @override
  String get chatErrorSentSuccessfully =>
      'Kesalahan obrolan telah berhasil dikirim.';

  @override
  String get chatListTab => 'Tab Daftar Obrolan';

  @override
  String get chats => 'Obrolan';

  @override
  String chattingWithPersonas(int count) {
    return 'Mengobrol dengan $count persona';
  }

  @override
  String get checkInternetConnection => 'Silakan periksa koneksi internet Anda';

  @override
  String get checkingUserInfo => 'Memeriksa informasi pengguna';

  @override
  String get childrensDay => 'Hari Anak';

  @override
  String get chinese => 'Cina';

  @override
  String get chooseOption => 'Silakan pilih:';

  @override
  String get christmas => 'Natal';

  @override
  String get close => 'Tutup';

  @override
  String get complete => 'Selesai';

  @override
  String get completeSignup => 'Selesaikan pendaftaran';

  @override
  String get confirm => 'Konfirmasi';

  @override
  String get connectingToServer => 'Menghubungkan ke server';

  @override
  String get consultQualityMonitoring => 'Pemantauan Kualitas Konsultasi';

  @override
  String get continueAsGuest => 'Lanjutkan sebagai Tamu';

  @override
  String get continueButton => 'Lanjutkan';

  @override
  String get continueWithApple => 'Lanjutkan dengan Apple';

  @override
  String get continueWithGoogle => 'Lanjutkan dengan Google';

  @override
  String get conversationContinuity => 'Kontinuitas Percakapan';

  @override
  String get conversationContinuityDesc =>
      'Ingat percakapan sebelumnya dan hubungkan topik';

  @override
  String conversationWith(String name) {
    return '$name';
  }

  @override
  String get convertToMember => 'Daftar';

  @override
  String get cooking => 'Memasak';

  @override
  String get copyMessage => 'Salin pesan';

  @override
  String get copyrightInfringement => 'Pelanggaran hak cipta';

  @override
  String get creatingAccount => 'Membuat akun';

  @override
  String get crisisDetected => 'Krisis Terdeteksi';

  @override
  String get culturalIssue => 'Masalah Budaya';

  @override
  String get current => 'Saat Ini';

  @override
  String get currentCacheSize => 'Ukuran Cache Saat Ini';

  @override
  String get currentLanguage => 'Bahasa Saat Ini';

  @override
  String get cycling => 'Bersepeda';

  @override
  String get dailyCare => 'Perawatan Harian';

  @override
  String get dailyCareDesc =>
      'Pesan perawatan harian untuk makanan, tidur, kesehatan';

  @override
  String get dailyChat => 'Obrolan Harian';

  @override
  String get dailyCheck => 'Pemeriksaan Harian';

  @override
  String get dailyConversation => 'Percakapan Harian';

  @override
  String get dailyLimitDescription => 'Anda telah mencapai batas pesan harian';

  @override
  String get dailyLimitTitle => 'Batas Harian Tercapai';

  @override
  String get darkMode => 'Mode gelap';

  @override
  String get darkTheme => 'Mode Gelap';

  @override
  String get darkThemeDesc => 'Gunakan tema gelap';

  @override
  String get dataCollection => 'Pengaturan Pengumpulan Data';

  @override
  String get datingAdvice => 'Saran Kencan';

  @override
  String get datingDescription =>
      'Saya ingin berbagi pemikiran mendalam dan memiliki percakapan yang tulus';

  @override
  String get dawn => 'Fajar';

  @override
  String get day => 'Hari';

  @override
  String get dayAfterTomorrow => 'Lusa';

  @override
  String daysAgo(int count, String formatted) {
    return '$count hari yang lalu';
  }

  @override
  String daysRemaining(int days) {
    return '$days hari tersisa';
  }

  @override
  String get deepTalk => 'Percakapan Mendalam';

  @override
  String get delete => 'Hapus';

  @override
  String get deleteAccount => 'Hapus akun';

  @override
  String get deleteAccountConfirm =>
      'Apakah Anda yakin ingin menghapus akun Anda? Tindakan ini tidak dapat dibatalkan.';

  @override
  String get deleteAccountWarning =>
      'Apakah Anda yakin ingin menghapus akun Anda?';

  @override
  String get deleteCache => 'Hapus Cache';

  @override
  String get deletingAccount => 'Menghapus akun...';

  @override
  String get depressed => 'Depresi';

  @override
  String get describeError => 'Apa masalahnya?';

  @override
  String get detailedReason => 'Alasan rinci';

  @override
  String get developRelationshipStep =>
      '3. Kembangkan Hubungan: Bangun kedekatan melalui percakapan dan kembangkan hubungan khusus.';

  @override
  String get dinner => 'Makan Malam';

  @override
  String get discardGuestData => 'Mulai Baru';

  @override
  String get discount20 => 'Diskon 20%';

  @override
  String get discount30 => 'Diskon 30%';

  @override
  String get discountAmount => 'Jumlah diskon';

  @override
  String discountAmountValue(String amount) {
    return 'Hemat ₩$amount';
  }

  @override
  String get done => 'Selesai';

  @override
  String get downloadingPersonaImages => 'Mengunduh gambar persona baru';

  @override
  String get edit => 'Edit';

  @override
  String get editInfo => 'Edit informasi';

  @override
  String get editProfile => 'Edit profil';

  @override
  String get effectSound => 'Efek suara';

  @override
  String get effectSoundDescription => 'Putar efek suara';

  @override
  String get email => 'Email';

  @override
  String get emailHint => 'contoh@email.com';

  @override
  String get emailLabel => 'Email';

  @override
  String get emailRequired => 'Silakan masukkan email';

  @override
  String get emotionAnalysis => 'Analisis Emosi';

  @override
  String get emotionAnalysisDesc => 'Analisis emosi untuk respons yang empatik';

  @override
  String get emotionAngry => 'Marah';

  @override
  String get emotionBasedEncounters => 'Temui persona berdasarkan emosi Anda';

  @override
  String get emotionCool => 'Keren';

  @override
  String get emotionHappy => 'Bahagia';

  @override
  String get emotionLove => 'Cinta';

  @override
  String get emotionSad => 'Sedih';

  @override
  String get emotionThinking => 'Berpikir';

  @override
  String get emotionalSupportDesc =>
      'Bagikan kekhawatiran Anda dan terima kenyamanan yang hangat';

  @override
  String get endChat => 'Akhiri obrolan';

  @override
  String get endTutorial => 'Akhiri Tutorial';

  @override
  String get endTutorialAndLogin => 'Akhiri tutorial dan masuk?';

  @override
  String get endTutorialMessage =>
      'Apakah Anda ingin mengakhiri tutorial dan masuk?';

  @override
  String get english => 'Inggris';

  @override
  String get enterBasicInfo =>
      'Silakan masukkan informasi dasar untuk membuat akun';

  @override
  String get enterBasicInformation => 'Masukkan informasi dasar';

  @override
  String get enterEmail => 'Masukkan email';

  @override
  String get enterNickname => 'Silakan masukkan nama panggilan';

  @override
  String get enterPassword => 'Silakan masukkan kata sandi';

  @override
  String get entertainmentAndFunDesc =>
      'Nikmati permainan yang menyenangkan dan percakapan yang menyenangkan';

  @override
  String get entertainmentDescription =>
      'Saya ingin memiliki percakapan yang menyenangkan dan menikmati waktu saya';

  @override
  String get entertainmentFun => 'Hiburan/Kesenangan';

  @override
  String get error => 'Kesalahan';

  @override
  String get errorDescription => 'Deskripsi kesalahan';

  @override
  String get errorDescriptionHint =>
      'misalnya, Memberikan jawaban yang aneh, Mengulangi hal yang sama, Memberikan respons yang tidak sesuai konteks...';

  @override
  String get errorDetails => 'Rincian kesalahan';

  @override
  String get errorDetailsHint => 'Silakan jelaskan secara rinci apa yang salah';

  @override
  String get errorFrequency24h => 'Frekuensi kesalahan (24 jam terakhir)';

  @override
  String get errorMessage => 'Pesan kesalahan:';

  @override
  String get errorOccurred => 'Terjadi kesalahan.';

  @override
  String get errorOccurredTryAgain => 'Terjadi kesalahan. Silakan coba lagi.';

  @override
  String get errorSendingFailed => 'Gagal mengirim kesalahan';

  @override
  String get errorStats => 'Statistik Kesalahan';

  @override
  String errorWithMessage(String error) {
    return 'Terjadi kesalahan: $error';
  }

  @override
  String get evening => 'Sore';

  @override
  String get excited => 'Bersemangat';

  @override
  String get exit => 'Keluar';

  @override
  String get exitApp => 'Keluar Aplikasi';

  @override
  String get exitConfirmMessage =>
      'Apakah Anda yakin ingin keluar dari aplikasi?';

  @override
  String get expertPersona => 'Persona Ahli';

  @override
  String get expertiseScore => 'Skor Keahlian';

  @override
  String get expired => 'Kedaluwarsa';

  @override
  String get explainReportReason =>
      'Harap jelaskan alasan laporan secara rinci';

  @override
  String get fashion => 'Mode';

  @override
  String get female => 'Perempuan';

  @override
  String get filter => 'Filter';

  @override
  String get firstOccurred => 'Pertama Kali Terjadi:';

  @override
  String get followDeviceLanguage => 'Ikuti pengaturan bahasa perangkat';

  @override
  String get forenoon => 'Pagi';

  @override
  String get forgotPassword => 'Lupa kata sandi?';

  @override
  String get frequentlyAskedQuestions => 'Pertanyaan yang sering diajukan';

  @override
  String get friday => 'Jumat';

  @override
  String get friendshipDescription =>
      'Saya ingin bertemu teman baru dan berdiskusi';

  @override
  String get funChat => 'Obrolan Seru';

  @override
  String get galleryPermission => 'Izin Galeri';

  @override
  String get galleryPermissionDesc =>
      'Akses galeri diperlukan untuk memilih foto profil.';

  @override
  String get gaming => 'Bermain game';

  @override
  String get gender => 'Jenis kelamin';

  @override
  String get genderNotSelectedInfo =>
      'Jika jenis kelamin tidak dipilih, persona dari semua jenis kelamin akan ditampilkan';

  @override
  String get genderOptional => 'Jenis kelamin (opsional)';

  @override
  String get genderPreferenceActive =>
      'Anda dapat bertemu persona dari semua jenis kelamin';

  @override
  String get genderPreferenceDisabled =>
      'Pilih jenis kelamin Anda untuk mengaktifkan opsi hanya untuk jenis kelamin yang berlawanan';

  @override
  String get genderPreferenceInactive =>
      'Hanya persona dari jenis kelamin yang berlawanan yang akan ditampilkan';

  @override
  String get genderRequired => 'Silakan pilih jenis kelamin';

  @override
  String get genderSelectionInfo =>
      'Jika tidak dipilih, Anda dapat bertemu persona dari semua jenis kelamin';

  @override
  String get generalPersona => 'Persona Umum';

  @override
  String get goToSettings => 'Ke pengaturan';

  @override
  String get permissionGuideAndroid =>
      'Pengaturan > Aplikasi > SONA > Izin\nHarap izinkan akses foto';

  @override
  String get permissionGuideIOS =>
      'Pengaturan > SONA > Foto\nHarap izinkan akses foto';

  @override
  String get googleLoginCanceled =>
      'Login Google dibatalkan. Silakan coba lagi.';

  @override
  String get googleLoginError => 'Error masuk Google';

  @override
  String get grantPermission => 'Lanjutkan';

  @override
  String get guest => 'Tamu';

  @override
  String get guestDataMigration =>
      'Apakah Anda ingin menyimpan riwayat obrolan Anda saat mendaftar?';

  @override
  String get guestLimitReached =>
      'Masa percobaan tamu telah berakhir. Daftar untuk percakapan tanpa batas!';

  @override
  String get guestLoginPromptMessage => 'Masuk untuk melanjutkan percakapan';

  @override
  String get guestMessageExhausted => 'Pesan gratis telah habis';

  @override
  String guestMessageRemaining(int count) {
    return '$count pesan tamu tersisa';
  }

  @override
  String get guestModeBanner => 'Mode Tamu';

  @override
  String get guestModeDescription => 'Coba SONA tanpa mendaftar';

  @override
  String get guestModeFailedMessage => 'Gagal memulai Mode Tamu';

  @override
  String get guestModeLimitation => 'Beberapa fitur dibatasi di Mode Tamu';

  @override
  String get guestModeTitle => 'Coba sebagai Tamu';

  @override
  String get guestModeWarning =>
      'Mode tamu berlangsung selama 24 jam, setelah itu data akan dihapus.';

  @override
  String get guestModeWelcome => 'Memulai di Mode Tamu';

  @override
  String get happy => 'Senang';

  @override
  String get hapticFeedback => 'Umpan Balik Haptik';

  @override
  String get harassmentBullying => 'Pelecehan/Bullying';

  @override
  String get hateSpeech => 'Ujaran kebencian';

  @override
  String get heartDescription => 'Hati untuk lebih banyak pesan';

  @override
  String get heartInsufficient => 'Hati tidak cukup';

  @override
  String get heartInsufficientPleaseCharge =>
      'Hati tidak cukup. Silakan isi ulang hati.';

  @override
  String get heartRequired => '1 hati diperlukan';

  @override
  String get heartUsageFailed => 'Gagal menggunakan hati.';

  @override
  String get hearts => 'Hati';

  @override
  String get hearts10 => '10 Hati';

  @override
  String get hearts30 => '30 Hati';

  @override
  String get hearts30Discount => '30 Hati (Diskon)';

  @override
  String get hearts50 => '50 Hati';

  @override
  String get hearts50Discount => '50 Hati (Diskon)';

  @override
  String get helloEmoji => 'Halo! 😊';

  @override
  String get help => 'Bantuan';

  @override
  String get hideOriginalText => 'Sembunyikan Asli';

  @override
  String get hobbySharing => 'Berbagi Hobi';

  @override
  String get hobbyTalk => 'Bicara Hobi';

  @override
  String get hours24Ago => '24 jam yang lalu';

  @override
  String hoursAgo(int count, String formatted) {
    return '$count jam yang lalu';
  }

  @override
  String get howToUse => 'Cara penggunaan';

  @override
  String get imageCacheManagement => 'Manajemen Cache Gambar';

  @override
  String get inappropriateContent => 'Konten yang tidak pantas';

  @override
  String get incorrect => 'salah';

  @override
  String get incorrectPassword => 'Kata sandi salah';

  @override
  String get indonesian => 'Bahasa Indonesia';

  @override
  String get inquiries => 'Pertanyaan';

  @override
  String get insufficientHearts => 'Hati tidak cukup';

  @override
  String get interestSharing => 'Berbagi Minat';

  @override
  String get interestSharingDesc =>
      'Temukan dan rekomendasikan minat yang sama';

  @override
  String get interests => 'Minat';

  @override
  String get invalidEmailFormat => 'Format email tidak valid';

  @override
  String get invalidEmailFormatError =>
      'Silakan masukkan alamat email yang valid';

  @override
  String isTyping(String name) {
    return '$name sedang mengetik...';
  }

  @override
  String get japanese => 'Jepang';

  @override
  String get joinDate => 'Tanggal bergabung';

  @override
  String get justNow => 'Baru saja';

  @override
  String get keepGuestData => 'Simpan Riwayat Obrolan';

  @override
  String get korean => 'Korea';

  @override
  String get koreanLanguage => 'Bahasa Korea';

  @override
  String get language => 'Bahasa';

  @override
  String get languageDescription =>
      'AI akan merespons dalam bahasa yang Anda pilih';

  @override
  String get languageIndicator => 'Bahasa';

  @override
  String get languageSettings => 'Pengaturan bahasa';

  @override
  String get lastOccurred => 'Terakhir Terjadi:';

  @override
  String get lastUpdated => 'Terakhir Diperbarui';

  @override
  String get lateNight => 'Larut malam';

  @override
  String get later => 'Nanti';

  @override
  String get laterButton => 'Nanti';

  @override
  String get leave => 'Tinggalkan';

  @override
  String get leaveChatConfirm => 'Tinggalkan obrolan ini?';

  @override
  String get leaveChatRoom => 'Tinggalkan Ruang Obrolan';

  @override
  String get leaveChatTitle => 'Tinggalkan obrolan';

  @override
  String get lifeAdvice => 'Nasihat Hidup';

  @override
  String get lightTalk => 'Obrolan Santai';

  @override
  String get lightTheme => 'Mode Terang';

  @override
  String get lightThemeDesc => 'Gunakan tema cerah';

  @override
  String get loading => 'Memuat...';

  @override
  String get loadingData => 'Memuat data...';

  @override
  String get loadingProducts => 'Memuat produk...';

  @override
  String get loadingProfile => 'Memuat profil';

  @override
  String get login => 'Masuk';

  @override
  String get loginButton => 'Masuk';

  @override
  String get loginCancelled => 'Masuk dibatalkan';

  @override
  String get loginComplete => 'Masuk berhasil';

  @override
  String get loginError => 'Error masuk';

  @override
  String get loginFailed => 'Masuk gagal';

  @override
  String get loginFailedTryAgain => 'Masuk gagal. Silakan coba lagi.';

  @override
  String get loginRequired => 'Perlu masuk';

  @override
  String get loginRequiredForProfile => 'Masuk diperlukan untuk melihat profil';

  @override
  String get loginRequiredService =>
      'Masuk diperlukan untuk menggunakan layanan ini';

  @override
  String get loginRequiredTitle => 'Masuk Diperlukan';

  @override
  String get loginSignup => 'Masuk/Daftar';

  @override
  String get loginTab => 'Masuk';

  @override
  String get loginTitle => 'Masuk';

  @override
  String get loginWithApple => 'Masuk dengan Apple';

  @override
  String get loginWithGoogle => 'Masuk dengan Google';

  @override
  String get logout => 'Keluar';

  @override
  String get logoutConfirm => 'Apakah Anda yakin ingin keluar?';

  @override
  String get lonelinessRelief => 'Penghilang Kesepian';

  @override
  String get lonely => 'Kesepian';

  @override
  String get lowQualityResponses => 'Respon Berkualitas Rendah';

  @override
  String get lunch => 'Makan Siang';

  @override
  String get lunchtime => 'Waktu Makan Siang';

  @override
  String get mainErrorType => 'Tipe Kesalahan Utama';

  @override
  String get makeFriends => 'Cari Teman';

  @override
  String get male => 'Laki-laki';

  @override
  String get manageBlockedAIs => 'Kelola AI yang Diblokir';

  @override
  String get managePersonaImageCache => 'Kelola cache gambar persona';

  @override
  String get marketingAgree => 'Setuju dengan Informasi Pemasaran (Opsional)';

  @override
  String get marketingDescription =>
      'Anda dapat menerima informasi acara dan manfaat';

  @override
  String get matchPersonaStep =>
      '1. Cocokkan Persona: Geser ke kiri atau kanan untuk memilih persona AI favorit Anda.';

  @override
  String get matchedPersonas => 'Persona yang Cocok';

  @override
  String get matchedSona => 'Sona yang Cocok';

  @override
  String get matching => 'Mencocokkan';

  @override
  String get matchingFailed => 'Pencocokan gagal.';

  @override
  String get me => 'Me';

  @override
  String get meetAIPersonas => 'Temui Persona AI';

  @override
  String get meetNewPersonas => 'Temui Persona Baru';

  @override
  String get meetPersonas => 'Temui persona';

  @override
  String get memberBenefits =>
      'Dapatkan 100+ pesan dan 10 hati saat Anda mendaftar!';

  @override
  String get memoryAlbum => 'Album Kenangan';

  @override
  String get memoryAlbumDesc =>
      'Secara otomatis menyimpan dan mengingat momen-momen spesial';

  @override
  String get messageCopied => 'Pesan disalin';

  @override
  String get messageDeleted => 'Pesan dihapus';

  @override
  String get messageLimitReset => 'Batas pesan akan direset pada tengah malam';

  @override
  String get messageSendFailed => 'Gagal mengirim pesan. Silakan coba lagi.';

  @override
  String get messagesRemaining => 'Pesan Tersisa';

  @override
  String minutesAgo(int count, String formatted) {
    return '$count menit yang lalu';
  }

  @override
  String get missingTranslation => 'Terjemahan Hilang';

  @override
  String get monday => 'Senin';

  @override
  String get month => 'Bulan';

  @override
  String monthDay(String month, int day) {
    return '$month $day';
  }

  @override
  String get moreButton => 'Lebih';

  @override
  String get morning => 'Pagi';

  @override
  String get mostFrequentError => 'Kesalahan Paling Sering';

  @override
  String get movies => 'Film';

  @override
  String get multilingualChat => 'Obrolan Multibahasa';

  @override
  String get music => 'Musik';

  @override
  String get myGenderSection => 'Jenis kelamin saya';

  @override
  String get networkErrorOccurred => 'Terjadi kesalahan jaringan.';

  @override
  String get newMessage => 'Pesan baru';

  @override
  String newMessageCount(int count) {
    return '$count pesan baru';
  }

  @override
  String get newMessageNotification => 'Beri tahu saya tentang pesan baru';

  @override
  String get newMessages => 'Pesan baru';

  @override
  String get newYear => 'Tahun Baru';

  @override
  String get next => 'Berikutnya';

  @override
  String get niceToMeetYou => 'Senang bertemu denganmu!';

  @override
  String get nickname => 'Nama panggilan';

  @override
  String get nicknameAlreadyUsed => 'Nama panggilan ini sudah digunakan';

  @override
  String get nicknameHelperText => '3-10 karakter';

  @override
  String get nicknameHint => 'Masukkan nama panggilan';

  @override
  String get nicknameInUse => 'Nama panggilan ini sudah digunakan';

  @override
  String get nicknameLabel => 'Nama Panggilan';

  @override
  String get nicknameLengthError => 'Nama panggilan harus 3-10 karakter';

  @override
  String get nicknamePlaceholder => 'Masukkan nama panggilan Anda';

  @override
  String get nicknameRequired => 'Silakan masukkan nama panggilan';

  @override
  String get night => 'Malam';

  @override
  String get no => 'Tidak';

  @override
  String get noBlockedAIs => 'Tidak ada AIs yang diblokir';

  @override
  String get noChatsYet => 'Belum ada obrolan';

  @override
  String get noConversationYet => 'Belum ada percakapan';

  @override
  String get noErrorReports => 'Tidak ada laporan kesalahan.';

  @override
  String get noImageAvailable => 'Tidak ada gambar yang tersedia';

  @override
  String get noMatchedPersonas => 'Belum ada persona yang cocok';

  @override
  String get noMatchedSonas => 'Belum ada SONA yang cocok';

  @override
  String get noPersonasAvailable => 'Tidak ada persona tersedia';

  @override
  String get noPersonasToSelect => 'Tidak ada persona yang tersedia';

  @override
  String get noQualityIssues =>
      'Tidak ada masalah kualitas dalam satu jam terakhir ✅';

  @override
  String get noQualityLogs => 'Belum ada catatan kualitas.';

  @override
  String get noTranslatedMessages => 'Tidak ada pesan untuk diterjemahkan';

  @override
  String get notEnoughHearts => 'Tidak cukup hati';

  @override
  String notEnoughHeartsCount(int count) {
    return 'Tidak cukup hati. (Saat ini: $count)';
  }

  @override
  String get notRegistered => 'belum terdaftar';

  @override
  String get notSubscribed => 'Tidak berlangganan';

  @override
  String get notificationPermissionDesc =>
      'Izin notifikasi diperlukan untuk menerima pesan baru.';

  @override
  String get notificationPermissionRequired => 'Izin notifikasi diperlukan';

  @override
  String get notificationSettings => 'Pengaturan Notifikasi';

  @override
  String get notifications => 'Notifikasi';

  @override
  String get occurrenceInfo => 'Info Kejadian:';

  @override
  String get olderChats => 'Lebih lama';

  @override
  String get onlyOppositeGenderNote =>
      'Jika tidak dicentang, hanya persona lawan jenis yang akan ditampilkan';

  @override
  String get openSettings => 'Buka Pengaturan';

  @override
  String get optional => 'Opsional';

  @override
  String get or => 'atau';

  @override
  String get originalPrice => 'Harga asli';

  @override
  String get originalText => 'Asli';

  @override
  String get other => 'Lainnya';

  @override
  String get otherError => 'Kesalahan Lain';

  @override
  String get others => 'Lainnya';

  @override
  String get ownedHearts => 'Hati yang Dimiliki';

  @override
  String get parentsDay => 'Hari Orang Tua';

  @override
  String get password => 'Kata sandi';

  @override
  String get passwordConfirmation => 'Masukkan kata sandi untuk mengonfirmasi';

  @override
  String get passwordConfirmationDesc =>
      'Silakan masukkan kembali kata sandi Anda untuk menghapus akun.';

  @override
  String get passwordHint => 'Masukkan kata sandi';

  @override
  String get passwordLabel => 'Kata Sandi';

  @override
  String get passwordRequired => 'Silakan masukkan kata sandi';

  @override
  String get passwordResetEmailPrompt =>
      'Silakan masukkan email Anda untuk mengatur ulang kata sandi';

  @override
  String get passwordResetEmailSent =>
      'Email pengaturan ulang kata sandi telah dikirim. Silakan periksa email Anda.';

  @override
  String get passwordText => 'kata sandi';

  @override
  String get passwordTooShort => 'Kata sandi minimal 6 karakter';

  @override
  String get permissionDenied => 'Izin ditolak';

  @override
  String permissionDeniedMessage(String permissionName) {
    return 'Izin $permissionName ditolak.\\nSilakan izinkan izin tersebut di pengaturan.';
  }

  @override
  String get permissionDeniedTryLater =>
      'Izin ditolak. Silakan coba lagi nanti.';

  @override
  String get permissionRequired => 'Izin Diperlukan';

  @override
  String get personaGenderSection => 'Jenis kelamin persona';

  @override
  String get personaQualityStats => 'Statistik Kualitas Persona';

  @override
  String get personalInfoExposure => 'Paparan informasi pribadi';

  @override
  String get personality => 'Kepribadian';

  @override
  String get pets => 'Hewan Peliharaan';

  @override
  String get photo => 'Foto';

  @override
  String get photography => 'Fotografi';

  @override
  String get picnic => 'Piknik';

  @override
  String get preferenceSettings => 'Pengaturan Preferensi';

  @override
  String get preferredLanguage => 'Bahasa yang Diutamakan';

  @override
  String get preparingForSleep => 'Mempersiapkan tidur';

  @override
  String get preparingNewMeeting => 'Mempersiapkan pertemuan baru';

  @override
  String get preparingPersonaImages => 'Mempersiapkan gambar persona';

  @override
  String get preparingPersonas => 'Mempersiapkan persona';

  @override
  String get preview => 'Prabaca';

  @override
  String get previous => 'Sebelumnya';

  @override
  String get privacy => 'Privasi';

  @override
  String get privacyPolicy => 'Kebijakan Privasi';

  @override
  String get privacyPolicyAgreement => 'Silakan setujui kebijakan privasi';

  @override
  String get privacySection1Content =>
      'Kami berkomitmen untuk melindungi privasi Anda. Kebijakan Privasi ini menjelaskan bagaimana kami mengumpulkan, menggunakan, dan melindungi informasi Anda saat Anda menggunakan layanan kami.';

  @override
  String get privacySection1Title =>
      '1. Tujuan Pengumpulan dan Penggunaan Informasi Pribadi';

  @override
  String get privacySection2Content =>
      'Kami mengumpulkan informasi yang Anda berikan langsung kepada kami, seperti saat Anda membuat akun, memperbarui profil Anda, atau menggunakan layanan kami.';

  @override
  String get privacySection2Title => 'Informasi yang Kami Kumpulkan';

  @override
  String get privacySection3Content =>
      'Kami menggunakan informasi yang kami kumpulkan untuk menyediakan, memelihara, dan meningkatkan layanan kami, serta untuk berkomunikasi dengan Anda.';

  @override
  String get privacySection3Title =>
      '3. Masa Retensi dan Penggunaan Informasi Pribadi';

  @override
  String get privacySection4Content =>
      'Kami tidak menjual, memperdagangkan, atau mentransfer informasi pribadi Anda kepada pihak ketiga tanpa persetujuan Anda.';

  @override
  String get privacySection4Title =>
      '4. Penyediaan Informasi Pribadi kepada Pihak Ketiga';

  @override
  String get privacySection5Content =>
      'Kami menerapkan langkah-langkah keamanan yang tepat untuk melindungi informasi pribadi Anda dari akses, perubahan, pengungkapan, atau penghancuran yang tidak sah.';

  @override
  String get privacySection5Title =>
      '5. Langkah Perlindungan Teknis untuk Informasi Pribadi';

  @override
  String get privacySection6Content =>
      'Kami menyimpan informasi pribadi selama diperlukan untuk menyediakan layanan kami dan memenuhi kewajiban hukum.';

  @override
  String get privacySection6Title => '6. Hak Pengguna';

  @override
  String get privacySection7Content =>
      'Anda memiliki hak untuk mengakses, memperbarui, atau menghapus informasi pribadi Anda kapan saja melalui pengaturan akun Anda.';

  @override
  String get privacySection7Title => 'Hak Anda';

  @override
  String get privacySection8Content =>
      'Jika Anda memiliki pertanyaan tentang Kebijakan Privasi ini, silakan hubungi kami di support@sona.com.';

  @override
  String get privacySection8Title => 'Hubungi Kami';

  @override
  String get privacySettings => 'Pengaturan privasi';

  @override
  String get privacySettingsInfo =>
      'Menonaktifkan fitur individu akan membuat layanan tersebut tidak tersedia';

  @override
  String get privacySettingsScreen => 'Pengaturan Privasi';

  @override
  String get problemMessage => 'Masalah';

  @override
  String get problemOccurred => 'Terjadi Masalah';

  @override
  String get profile => 'Profil';

  @override
  String get profileEdit => 'Edit Profil';

  @override
  String get profileEditLoginRequiredMessage =>
      'Login diperlukan untuk mengedit profil Anda. Apakah Anda ingin pergi ke layar login?';

  @override
  String get profileInfo => 'Informasi Profil';

  @override
  String get profileInfoDescription =>
      'Silakan masukkan foto profil dan informasi dasar Anda';

  @override
  String get profileNav => 'Profil';

  @override
  String get profilePhoto => 'Foto profil';

  @override
  String get profilePhotoAndInfo =>
      'Silakan masukkan foto profil dan informasi dasar';

  @override
  String get profilePhotoUpdateFailed => 'Gagal memperbarui foto profil';

  @override
  String get profilePhotoUpdated => 'Foto profil berhasil diperbarui';

  @override
  String get profileSettings => 'Pengaturan Profil';

  @override
  String get profileSetup => 'Mengatur profil';

  @override
  String get profileUpdateFailed => 'Gagal memperbarui profil';

  @override
  String get profileUpdated => 'Profil berhasil diperbarui';

  @override
  String get purchaseAndRefundPolicy => 'Kebijakan Pembelian & Pengembalian';

  @override
  String get purchaseButton => 'Beli';

  @override
  String get purchaseConfirm => 'Konfirmasi pembelian';

  @override
  String purchaseConfirmContent(String product, String price) {
    return 'Beli $product seharga $price?';
  }

  @override
  String purchaseConfirmMessage(
      String title, String price, String description) {
    return 'Konfirmasi pembelian $title seharga $price? $description';
  }

  @override
  String get purchaseFailed => 'Pembelian gagal';

  @override
  String get purchaseHeartsOnly => 'Beli hati saja';

  @override
  String get purchaseMoreHearts => 'Beli hati untuk melanjutkan percakapan';

  @override
  String get purchasePending => 'Pembelian sedang diproses...';

  @override
  String get purchasePolicy => 'Kebijakan Pembelian';

  @override
  String get purchaseSection1Content =>
      'Kami menerima berbagai metode pembayaran termasuk kartu kredit dan dompet digital.';

  @override
  String get purchaseSection1Title => 'Metode Pembayaran';

  @override
  String get purchaseSection2Content =>
      'Pengembalian dana tersedia dalam waktu 14 hari setelah pembelian jika Anda belum menggunakan barang yang dibeli.';

  @override
  String get purchaseSection2Title => 'Kebijakan Pengembalian Dana';

  @override
  String get purchaseSection3Content =>
      'Anda dapat membatalkan langganan kapan saja melalui pengaturan akun Anda.';

  @override
  String get purchaseSection3Title => 'Pembatalan';

  @override
  String get purchaseSection4Content =>
      'Dengan melakukan pembelian, Anda setuju dengan syarat penggunaan dan perjanjian layanan kami.';

  @override
  String get purchaseSection4Title => 'Syarat Penggunaan';

  @override
  String get purchaseSection5Content =>
      'Untuk masalah terkait pembelian, silakan hubungi tim dukungan kami.';

  @override
  String get purchaseSection5Title => 'Hubungi Dukungan';

  @override
  String get purchaseSection6Content =>
      'Semua pembelian tunduk pada syarat dan ketentuan standar kami.';

  @override
  String get purchaseSection6Title => '6. Pertanyaan';

  @override
  String get pushNotifications => 'Notifikasi push';

  @override
  String get reading => 'Membaca';

  @override
  String get realtimeQualityLog => 'Log Kualitas Waktu Nyata';

  @override
  String get recentConversation => 'Percakapan Terbaru:';

  @override
  String get recentLoginRequired => 'Silakan login lagi untuk keamanan';

  @override
  String get referrerEmail => 'Email Pengundang';

  @override
  String get referrerEmailHelper =>
      'Opsional: Email dari yang merekomendasikan Anda';

  @override
  String get referrerEmailLabel => 'Email perujuk';

  @override
  String get refresh => 'Segarkan';

  @override
  String refreshComplete(int count) {
    return 'Penyegaran selesai! $count persona yang cocok';
  }

  @override
  String get refreshFailed => 'Penyegaran gagal';

  @override
  String get refreshingChatList => 'Menyegarkan daftar obrolan...';

  @override
  String get relatedFAQ => 'FAQ terkait';

  @override
  String get report => 'Laporkan';

  @override
  String get reportAI => 'Laporkan';

  @override
  String get reportAIDescription =>
      'Jika AI membuat Anda merasa tidak nyaman, silakan jelaskan masalahnya.';

  @override
  String get reportAITitle => 'Laporkan Percakapan AI';

  @override
  String get reportAndBlock => 'Laporkan & Blokir';

  @override
  String get reportAndBlockDescription =>
      'Anda dapat melaporkan dan memblokir perilaku tidak pantas dari AI ini';

  @override
  String get reportChatError => 'Laporkan Kesalahan Obrolan';

  @override
  String reportError(String error) {
    return 'Terjadi kesalahan saat melaporkan: $error';
  }

  @override
  String get reportFailed => 'Laporan gagal';

  @override
  String get reportSubmitted => 'Laporan terkirim';

  @override
  String get reportSubmittedSuccess =>
      'Laporan Anda telah diajukan. Terima kasih!';

  @override
  String get requestLimit => 'Batas Permintaan';

  @override
  String get required => 'Wajib';

  @override
  String get requiredTermsAgreement => 'Silakan setujui syarat dan ketentuan';

  @override
  String get restartConversation => 'Mulai Ulang Percakapan';

  @override
  String restartConversationQuestion(String name) {
    return 'Apakah Anda ingin memulai ulang percakapan dengan $name?';
  }

  @override
  String restartConversationWithName(String name) {
    return 'Memulai ulang percakapan dengan $name!';
  }

  @override
  String get retry => 'Coba lagi';

  @override
  String get retryButton => 'Coba Lagi';

  @override
  String get sad => 'Sedih';

  @override
  String get saturday => 'Sabtu';

  @override
  String get save => 'Simpan';

  @override
  String get search => 'Cari';

  @override
  String get searchFAQ => 'Cari FAQ';

  @override
  String get searchResults => 'Hasil pencarian';

  @override
  String get selectEmotion => 'Pilih Emosi';

  @override
  String get selectErrorType => 'Pilih jenis kesalahan';

  @override
  String get selectFeeling => 'Bagaimana perasaan Anda?';

  @override
  String get selectGender => 'Pilih jenis kelamin';

  @override
  String get selectInterests => 'Silakan pilih minat Anda (minimal 1)';

  @override
  String get selectLanguage => 'Pilih Bahasa';

  @override
  String get selectPersona => 'Pilih persona';

  @override
  String get selectPersonaPlease => 'Silakan pilih sebuah persona.';

  @override
  String get selectPreferredMbti =>
      'Jika Anda lebih suka persona dengan tipe MBTI tertentu, silakan pilih';

  @override
  String get selectProblematicMessage =>
      'Pilih pesan yang bermasalah (opsional)';

  @override
  String get chatErrorAnalysisInfo => 'Menganalisis 10 percakapan terakhir.';

  @override
  String get whatWasAwkward => 'Apa yang terasa tidak natural?';

  @override
  String get errorExampleHint =>
      'Contoh: Cara bicara yang tidak natural (akhiran ~nya)...';

  @override
  String get selectReportReason => 'Pilih alasan laporan';

  @override
  String get selectTheme => 'Pilih Tema';

  @override
  String get selectTranslationError =>
      'Silakan pilih pesan dengan kesalahan terjemahan';

  @override
  String get selectUsagePurpose => 'Silakan pilih tujuan Anda menggunakan SONA';

  @override
  String get selfIntroduction => 'Perkenalan diri';

  @override
  String get selfIntroductionHint => 'Ceritakan tentang diri Anda';

  @override
  String get send => 'Kirim';

  @override
  String get sendChatError => 'Kesalahan Mengirim Chat';

  @override
  String get sendFirstMessage => 'Kirim pesan pertama Anda';

  @override
  String get sendReport => 'Kirim Laporan';

  @override
  String get sendingEmail => 'Mengirim email...';

  @override
  String get seoul => 'Seoul';

  @override
  String get serverErrorDashboard => 'Kesalahan Server';

  @override
  String get serviceTermsAgreement => 'Silakan setujui syarat layanan';

  @override
  String get sessionExpired => 'Sesi berakhir';

  @override
  String get setAppInterfaceLanguage => 'Atur bahasa antarmuka aplikasi';

  @override
  String get setNow => 'Atur sekarang';

  @override
  String get settings => 'Pengaturan';

  @override
  String get sexualContent => 'Konten seksual';

  @override
  String get showAllGenderPersonas => 'Tampilkan Semua Gender Persona';

  @override
  String get showAllGendersOption => 'Tampilkan semua jenis kelamin';

  @override
  String get showOppositeGenderOnly =>
      'Jika tidak dicentang, hanya persona lawan jenis yang akan ditampilkan';

  @override
  String get showOriginalText => 'Tampilkan Asli';

  @override
  String get signUp => 'Daftar';

  @override
  String get signUpFromGuest => 'Daftar sekarang untuk mengakses semua fitur!';

  @override
  String get signup => 'Daftar';

  @override
  String get signupComplete => 'Pendaftaran Selesai';

  @override
  String get signupTab => 'Daftar';

  @override
  String get simpleInfoRequired => 'Informasi sederhana diperlukan';

  @override
  String get skip => 'Lewati';

  @override
  String get sonaFriend => 'Teman SONA';

  @override
  String get sonaPrivacyPolicy => 'Kebijakan Privasi SONA';

  @override
  String get sonaPurchasePolicy => 'Kebijakan Pembelian SONA';

  @override
  String get sonaTermsOfService => 'Ketentuan Layanan SONA';

  @override
  String get sonaUsagePurpose => 'Silakan pilih tujuan Anda menggunakan SONA';

  @override
  String get sorryNotHelpful => 'Maaf, ini tidak membantu';

  @override
  String get sort => 'Urutkan';

  @override
  String get soundSettings => 'Pengaturan suara';

  @override
  String get spamAdvertising => 'Spam/Iklan';

  @override
  String get spanish => 'Spanyol';

  @override
  String get specialRelationshipDesc =>
      'Memahami satu sama lain dan membangun ikatan yang dalam';

  @override
  String get sports => 'Olahraga';

  @override
  String get spring => 'Musim Semi';

  @override
  String get startChat => 'Mulai obrolan';

  @override
  String get startChatButton => 'Mulai Obrolan';

  @override
  String get startConversation => 'Mulai percakapan';

  @override
  String get startConversationLikeAFriend =>
      'Mulai percakapan dengan SONA seperti teman';

  @override
  String get startConversationStep =>
      '2. Mulai Percakapan: Chat dengan bebas dengan persona yang cocok.';

  @override
  String get startConversationWithSona =>
      'Mulai chatting dengan Sona seperti teman!';

  @override
  String get startWithEmail => 'Mulai dengan Email';

  @override
  String get startWithGoogle => 'Mulai dengan Google';

  @override
  String get startingApp => 'Memulai aplikasi';

  @override
  String get storageManagement => 'Manajemen Penyimpanan';

  @override
  String get store => 'Toko';

  @override
  String get storeConnectionError => 'Tidak dapat terhubung ke toko';

  @override
  String get storeLoginRequiredMessage =>
      'Login diperlukan untuk menggunakan toko. Apakah Anda ingin pergi ke layar login?';

  @override
  String get storeNotAvailable => 'Toko tidak tersedia';

  @override
  String get storyEvent => 'Acara Cerita';

  @override
  String get stressed => 'Stres';

  @override
  String get submitReport => 'Kirim Laporan';

  @override
  String get subscriptionStatus => 'Status langganan';

  @override
  String get subtleVibrationOnTouch => 'Getaran halus saat disentuh';

  @override
  String get summer => 'Musim Panas';

  @override
  String get sunday => 'Minggu';

  @override
  String get swipeAnyDirection => 'Geser ke arah mana saja';

  @override
  String get swipeDownToClose => 'Geser ke bawah untuk menutup';

  @override
  String get systemTheme => 'Ikuti Sistem';

  @override
  String get systemThemeDesc =>
      'Secara otomatis berubah berdasarkan pengaturan mode gelap perangkat';

  @override
  String get tapBottomForDetails => 'Ketuk bagian bawah untuk detail';

  @override
  String get tapForDetails => 'Ketuk area bawah untuk detail';

  @override
  String get tapToSwipePhotos => 'Ketuk untuk menggeser foto';

  @override
  String get teachersDay => 'Hari Guru';

  @override
  String get technicalError => 'Kesalahan Teknis';

  @override
  String get technology => 'Teknologi';

  @override
  String get terms => 'Ketentuan';

  @override
  String get termsAgreement => 'Perjanjian Ketentuan';

  @override
  String get termsAgreementDescription =>
      'Harap setujui ketentuan untuk menggunakan layanan';

  @override
  String get termsOfService => 'Ketentuan Layanan';

  @override
  String get termsSection10Content =>
      'Kami berhak untuk mengubah ketentuan ini kapan saja dengan pemberitahuan kepada pengguna.';

  @override
  String get termsSection10Title => 'Pasal 10 (Penyelesaian Sengketa)';

  @override
  String get termsSection11Content =>
      'Ketentuan ini akan diatur oleh hukum di yurisdiksi tempat kami beroperasi.';

  @override
  String get termsSection11Title => 'Pasal 11 (Ketentuan Khusus Layanan AI)';

  @override
  String get termsSection12Content =>
      'Jika ada ketentuan dari ketentuan ini yang dianggap tidak dapat dilaksanakan, ketentuan lainnya akan tetap berlaku sepenuhnya.';

  @override
  String get termsSection12Title =>
      'Pasal 12 (Pengumpulan dan Penggunaan Data)';

  @override
  String get termsSection1Content =>
      'Ketentuan dan syarat ini bertujuan untuk mendefinisikan hak, kewajiban, dan tanggung jawab antara SONA (selanjutnya disebut \"Perusahaan\") dan pengguna terkait penggunaan layanan pencocokan percakapan persona AI (selanjutnya disebut \"Layanan\") yang disediakan oleh Perusahaan.';

  @override
  String get termsSection1Title => 'Pasal 1 (Tujuan)';

  @override
  String get termsSection2Content =>
      'Dengan menggunakan layanan kami, Anda setuju untuk terikat oleh Ketentuan Layanan ini dan Kebijakan Privasi kami.';

  @override
  String get termsSection2Title => 'Pasal 2 (Definisi)';

  @override
  String get termsSection3Content =>
      'Anda harus berusia minimal 13 tahun untuk menggunakan layanan kami.';

  @override
  String get termsSection3Title => 'Pasal 3 (Efek dan Modifikasi Ketentuan)';

  @override
  String get termsSection4Content =>
      'Anda bertanggung jawab untuk menjaga kerahasiaan akun dan kata sandi Anda.';

  @override
  String get termsSection4Title => 'Pasal 4 (Penyediaan Layanan)';

  @override
  String get termsSection5Content =>
      'Anda setuju untuk tidak menggunakan layanan kami untuk tujuan ilegal atau yang tidak sah.';

  @override
  String get termsSection5Title => 'Pasal 5 (Pendaftaran Keanggotaan)';

  @override
  String get termsSection6Content =>
      'Kami berhak untuk menghentikan atau menangguhkan akun Anda karena pelanggaran terhadap ketentuan ini.';

  @override
  String get termsSection6Title => 'Pasal 6 (Kewajiban Pengguna)';

  @override
  String get termsSection7Content =>
      'Perusahaan dapat secara bertahap membatasi penggunaan layanan melalui peringatan, penangguhan sementara, atau penangguhan permanen jika pengguna melanggar kewajiban dari syarat ini atau mengganggu operasi layanan yang normal.';

  @override
  String get termsSection7Title => 'Pasal 7 (Pembatasan Penggunaan Layanan)';

  @override
  String get termsSection8Content =>
      'Kami tidak bertanggung jawab atas kerugian tidak langsung, insidental, atau konsekuensial yang timbul dari penggunaan layanan kami.';

  @override
  String get termsSection8Title => 'Pasal 8 (Gangguan Layanan)';

  @override
  String get termsSection9Content =>
      'Semua konten dan materi yang tersedia di layanan kami dilindungi oleh hak kekayaan intelektual.';

  @override
  String get termsSection9Title => 'Pasal 9 (Penafian)';

  @override
  String get termsSupplementary => 'Syarat Tambahan';

  @override
  String get thai => 'Thai';

  @override
  String get thanksFeedback => 'Terima kasih atas masukan Anda';

  @override
  String get theme => 'Tema';

  @override
  String get themeDescription =>
      'Anda dapat menyesuaikan tampilan aplikasi sesuai keinginan Anda';

  @override
  String get themeSettings => 'Pengaturan tema';

  @override
  String get thursday => 'Kamis';

  @override
  String get timeout => 'Waktu Habis';

  @override
  String get tired => 'Lelah';

  @override
  String get today => 'Hari ini';

  @override
  String get todayChats => 'Hari ini';

  @override
  String get todayText => 'Hari Ini';

  @override
  String get tomorrowText => 'Besok';

  @override
  String get totalConsultSessions => 'Total Sesi Konsultasi';

  @override
  String get totalErrorCount => 'Total Jumlah Kesalahan';

  @override
  String get totalLikes => 'Total Suka';

  @override
  String totalOccurrences(Object count) {
    return 'Total $count kejadian';
  }

  @override
  String get totalResponses => 'Total Tanggapan';

  @override
  String get translatedFrom => 'Diterjemahkan';

  @override
  String get translatedText => 'Terjemahan';

  @override
  String get translationError => 'Kesalahan terjemahan';

  @override
  String get translationErrorDescription =>
      'Silakan laporkan terjemahan yang tidak tepat atau ungkapan yang canggung';

  @override
  String get translationErrorReported =>
      'Kesalahan terjemahan telah dilaporkan. Terima kasih!';

  @override
  String get translationNote => '※ Terjemahan AI mungkin tidak sempurna';

  @override
  String get translationQuality => 'Kualitas Terjemahan';

  @override
  String get translationSettings => 'Pengaturan Terjemahan';

  @override
  String get travel => 'Perjalanan';

  @override
  String get tuesday => 'Selasa';

  @override
  String get tutorialAccount => 'Akun tutorial';

  @override
  String get tutorialWelcomeDescription =>
      'Ciptakan hubungan istimewa dengan persona AI.';

  @override
  String get tutorialWelcomeTitle => 'Selamat datang di SONA!';

  @override
  String get typeMessage => 'Ketik pesan...';

  @override
  String get unblock => 'Buka blokir';

  @override
  String get unblockFailed => 'Gagal membuka blokir';

  @override
  String unblockPersonaConfirm(String name) {
    return 'Buka blokir $name?';
  }

  @override
  String get unblockedSuccessfully => 'Berhasil membuka blokir';

  @override
  String get unexpectedLoginError => 'Terjadi kesalahan tak terduga saat login';

  @override
  String get unknown => 'Tidak diketahui';

  @override
  String get unknownError => 'Terjadi kesalahan yang tidak diketahui';

  @override
  String get unlimitedMessages => 'Tidak terbatas';

  @override
  String get unsendMessage => 'Batalkan kirim pesan';

  @override
  String get usagePurpose => 'Tujuan penggunaan';

  @override
  String get useOneHeart => 'Gunakan 1 Hati';

  @override
  String get useSystemLanguage => 'Gunakan Bahasa Sistem';

  @override
  String get user => 'Pengguna:';

  @override
  String get userMessage => 'Pesan Pengguna:';

  @override
  String get userNotFound => 'Pengguna tidak ditemukan';

  @override
  String get valentinesDay => 'Hari Valentine';

  @override
  String get verifyingAuth => 'Memverifikasi autentikasi';

  @override
  String get version => 'Versi';

  @override
  String get vietnamese => 'Vietnam';

  @override
  String get violentContent => 'Konten kekerasan';

  @override
  String get voiceMessage => 'Pesan suara';

  @override
  String waitingForChat(String name) {
    return '$name sedang menunggu untuk mengobrol.';
  }

  @override
  String get walk => 'Jalan';

  @override
  String get wasHelpful => 'Apakah membantu?';

  @override
  String get weatherClear => 'Cerah';

  @override
  String get weatherCloudy => 'Mendung';

  @override
  String get weatherContext => 'Konteks Cuaca';

  @override
  String get weatherContextDesc =>
      'Berikan konteks percakapan berdasarkan cuaca';

  @override
  String get weatherDrizzle => 'Hujan gerimis';

  @override
  String get weatherFog => 'Kabut';

  @override
  String get weatherMist => 'Embun';

  @override
  String get weatherRain => 'Hujan';

  @override
  String get weatherRainy => 'Hujan';

  @override
  String get weatherSnow => 'Salju';

  @override
  String get weatherSnowy => 'Bersalju';

  @override
  String get weatherThunderstorm => 'Badai petir';

  @override
  String get wednesday => 'Rabu';

  @override
  String get weekdays => 'Min,Sen,Sel,Rab,Kam,Jum,Sab';

  @override
  String get welcomeMessage => 'Selamat datang💕';

  @override
  String get whatTopicsToTalk =>
      'Topik apa yang ingin Anda bicarakan? (Opsional)';

  @override
  String get whiteDay => 'Hari Putih';

  @override
  String get winter => 'Musim dingin';

  @override
  String get wrongTranslation => 'Terjemahan Salah';

  @override
  String get year => 'Tahun';

  @override
  String get yearEnd => 'Akhir Tahun';

  @override
  String get yes => 'Ya';

  @override
  String get yesterday => 'Kemarin';

  @override
  String get yesterdayChats => 'Kemarin';

  @override
  String get you => 'Anda';

  @override
  String get loadingPersonaData => 'Memuat data persona';

  @override
  String get checkingMatchedPersonas => 'Memeriksa persona yang cocok';

  @override
  String get preparingImages => 'Menyiapkan gambar';

  @override
  String get finalPreparation => 'Persiapan akhir';

  @override
  String get editProfileSubtitle =>
      'Edit jenis kelamin, tanggal lahir, dan perkenalan';

  @override
  String get systemThemeName => 'Sistem';

  @override
  String get lightThemeName => 'Terang';

  @override
  String get darkThemeName => 'Gelap';

  @override
  String get alwaysShowTranslationOn => 'Selalu Tampilkan Terjemahan';

  @override
  String get alwaysShowTranslationOff => 'Sembunyikan Terjemahan Otomatis';

  @override
  String get translationErrorAnalysisInfo =>
      'Kami akan menganalisis pesan dan terjemahan yang dipilih.';

  @override
  String get whatWasWrongWithTranslation =>
      'Apa yang salah dengan terjemahannya?';

  @override
  String get translationErrorHint =>
      'Contoh: Makna salah, ungkapan tidak alami, konteks salah...';

  @override
  String get pleaseSelectMessage => 'Silakan pilih pesan terlebih dahulu';

  @override
  String get myPersonas => 'Persona Saya';

  @override
  String get createPersona => 'Buat Persona';

  @override
  String get tellUsAboutYourPersona => 'Ceritakan tentang persona Anda';

  @override
  String get enterPersonaName => 'Masukkan nama persona';

  @override
  String get describeYourPersona => 'Deskripsikan persona Anda secara singkat';

  @override
  String get profileImage => 'Gambar Profil';

  @override
  String get uploadPersonaImages => 'Unggah gambar untuk persona Anda';

  @override
  String get mainImage => 'Gambar Utama';

  @override
  String get tapToUpload => 'Ketuk untuk mengunggah';

  @override
  String get additionalImages => 'Gambar Tambahan';

  @override
  String get addImage => 'Tambah Gambar';

  @override
  String get mbtiQuestion => 'Pertanyaan Kepribadian';

  @override
  String get mbtiComplete => 'Tes Kepribadian Selesai!';

  @override
  String get mbtiTest => 'Tes MBTI';

  @override
  String get mbtiStepDescription =>
      'Mari tentukan kepribadian apa yang harus dimiliki persona Anda. Jawab pertanyaan untuk membentuk karakternya.';

  @override
  String get startTest => 'Mulai Tes';

  @override
  String get personalitySettings => 'Pengaturan Kepribadian';

  @override
  String get speechStyle => 'Gaya Berbicara';

  @override
  String get conversationStyle => 'Gaya Percakapan';

  @override
  String get shareWithCommunity => 'Bagikan dengan Komunitas';

  @override
  String get shareDescription =>
      'Persona Anda akan dibagikan dengan pengguna lain setelah disetujui';

  @override
  String get sharePersona => 'Bagikan Persona';

  @override
  String get willBeSharedAfterApproval =>
      'Akan dibagikan setelah admin menyetujui';

  @override
  String get privatePersonaDescription =>
      'Hanya Anda yang dapat melihat persona ini';

  @override
  String get create => 'Buat';

  @override
  String get personaCreated => 'Persona berhasil dibuat!';

  @override
  String get createFailed => 'Gagal membuat persona';

  @override
  String get pendingApproval => 'Menunggu Persetujuan';

  @override
  String get approved => 'Disetujui';

  @override
  String get privatePersona => 'Pribadi';

  @override
  String get noPersonasYet => 'Belum Ada Persona';

  @override
  String get createYourFirstPersona =>
      'Buat persona pertama Anda dan mulai perjalanan';

  @override
  String get deletePersona => 'Hapus Persona';

  @override
  String get deletePersonaConfirm =>
      'Apakah Anda yakin ingin menghapus persona ini?';

  @override
  String get personaDeleted => 'Persona berhasil dihapus';

  @override
  String get deleteFailed => 'Gagal menghapus';

  @override
  String get personaLimitReached => 'Anda telah mencapai batas 3 persona';

  @override
  String get personaName => 'Nama';

  @override
  String get personaAge => 'Usia';

  @override
  String get personaDescription => 'Deskripsi';

  @override
  String get personaNameHint => 'Masukkan nama persona';

  @override
  String get personaDescriptionHint => 'Jelaskan persona';

  @override
  String get loginRequiredContent => 'Silakan masuk untuk melanjutkan';

  @override
  String get reportErrorButton => 'Laporkan Kesalahan';

  @override
  String get speechStyleFriendly => 'Ramah';

  @override
  String get speechStylePolite => 'Sopan';

  @override
  String get speechStyleChic => 'Keren';

  @override
  String get speechStyleLively => 'Ceria';

  @override
  String get conversationStyleTalkative => 'Cerewet';

  @override
  String get conversationStyleQuiet => 'Pendiam';

  @override
  String get conversationStyleEmpathetic => 'Empatik';

  @override
  String get conversationStyleLogical => 'Logis';

  @override
  String get interestMusic => 'Musik';

  @override
  String get interestMovies => 'Film';

  @override
  String get interestReading => 'Membaca';

  @override
  String get interestTravel => 'Perjalanan';

  @override
  String get interestExercise => 'Olahraga';

  @override
  String get interestGaming => 'Game';

  @override
  String get interestCooking => 'Memasak';

  @override
  String get interestFashion => 'Fashion';

  @override
  String get interestArt => 'Seni';

  @override
  String get interestPhotography => 'Fotografi';

  @override
  String get interestTechnology => 'Teknologi';

  @override
  String get interestScience => 'Sains';

  @override
  String get interestHistory => 'Sejarah';

  @override
  String get interestPhilosophy => 'Filsafat';

  @override
  String get interestPolitics => 'Politik';

  @override
  String get interestEconomy => 'Ekonomi';

  @override
  String get interestSports => 'Olahraga';

  @override
  String get interestAnimation => 'Animasi';

  @override
  String get interestKpop => 'K-POP';

  @override
  String get interestDrama => 'Drama';

  @override
  String get imageOptionalR2 =>
      'Gambar bersifat opsional. Hanya akan diunggah jika R2 dikonfigurasi.';

  @override
  String get networkErrorCheckConnection =>
      'Kesalahan jaringan: Silakan periksa koneksi internet Anda';

  @override
  String get maxFiveItems => 'Maksimal 5 item';

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
    return 'Mulai percakapan dengan $personaName?';
  }

  @override
  String reengagementNotificationSent(String personaName, String riskPercent) {
    return 'Notifikasi keterlibatan ulang dikirim ke $personaName (Risiko: $riskPercent%)';
  }

  @override
  String get noActivePersona => 'Tidak ada persona aktif';

  @override
  String get noInternetConnection => 'Tidak Ada Koneksi Internet';

  @override
  String get internetRequiredMessage =>
      'Koneksi internet diperlukan untuk menggunakan SONA. Silakan periksa koneksi Anda dan coba lagi.';

  @override
  String get retryConnection => 'Coba Lagi';

  @override
  String get openNetworkSettings => 'Buka Pengaturan';

  @override
  String get checkingConnection => 'Memeriksa koneksi...';

  @override
  String get editPersona => 'Edit Persona';

  @override
  String get personaUpdated => 'Persona berhasil diperbarui';

  @override
  String get cannotEditApprovedPersona =>
      'Persona yang telah disetujui tidak dapat diedit';

  @override
  String get update => 'Perbarui';
}
