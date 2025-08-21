import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import '../../models/app_user.dart';
import '../base/base_service.dart';
import '../../helpers/firebase_helper.dart';
import '../storage/local_profile_image_service.dart';
import '../../core/constants.dart';

class UserService extends BaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  AppUser? _currentUser;
  User? _firebaseUser;

  // Getters
  AppUser? get currentUser => _currentUser;
  User? get firebaseUser => _firebaseUser;
  bool get isLoggedIn => _firebaseUser != null;

  UserService() {
    // Auth 상태 리스너
    _auth.authStateChanges().listen((User? user) async {
      debugPrint(
          '👤 [UserService] Auth state changed: ${user != null ? 'User logged in (${user.uid})' : 'User logged out'}');
      _firebaseUser = user;
      if (user != null) {
        debugPrint('👤 [UserService] Loading user data for: ${user.uid}');
        await _loadUserData(user.uid);
      } else {
        debugPrint('👤 [UserService] Clearing user data');
        _currentUser = null;
      }
      notifyListeners();
    });
  }

  // 이메일/비밀번호로 회원가입
  Future<AppUser?> signUpWithEmail({
    required String email,
    required String password,
    required String nickname,
    String? gender,
    DateTime? birth,
    List<int>? preferredAgeRange,
    List<String>? interests,
    String? intro,
    File? profileImage,
    String? purpose,
    List<String>? preferredPersonaTypes,
    List<String>? preferredMbti,
    String? communicationStyle,
    List<String>? preferredTopics,
    bool genderAll = false,
    String? referralEmail,
  }) async {
    return await executeWithLoading<AppUser?>(() async {
      // 1. Firebase Auth로 사용자 생성
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        throw Exception('회원가입에 실패했습니다.');
      }

      // 2. 프로필 이미지 저장 (선택사항)
      String? profileImagePath;
      if (profileImage != null) {
        profileImagePath = await LocalProfileImageService.saveProfileImage(
          userId: credential.user!.uid,
          imageFile: profileImage,
        );
      }

      // 3. Firestore에 사용자 정보 저장
      final newUser = AppUser(
        uid: credential.user!.uid,
        email: email,
        nickname: nickname,
        gender: gender,
        birth: birth,
        age: birth != null ? AppUser.calculateAge(birth) : null,
        preferredPersona: PreferredPersona(
          ageRange: preferredAgeRange ?? [20, 35],
        ),
        interests: interests ?? [],
        intro: intro,
        profileImageUrl: profileImagePath,
        createdAt: DateTime.now(),
        purpose: purpose,
        preferredMbti: preferredMbti,
        communicationStyle: communicationStyle,
        preferredTopics: null,
        genderAll: genderAll,
        dailyMessageCount: 0,
        dailyMessageLimit: AppConstants.dailyMessageLimit,
        lastMessageCountReset: DateTime.now(),
        referralEmail: referralEmail,
      );

      await FirebaseHelper.user(newUser.uid).set(
        FirebaseHelper.withTimestamps({
          ...newUser.toFirestore(),
          'hearts': 10, // 신규 가입 시 기본 하트 10개 지급
        }),
      );

      _currentUser = newUser;
      return newUser;
    }, errorContext: 'signUpWithEmail');
  }

  // 구글 로그인 및 추가 정보 입력
  Future<User?> signInWithGoogle() async {
    debugPrint('🔵 [UserService] Starting Google Sign-In process...');
    return await executeWithLoading<User?>(() async {
      try {
        // 1. Google 로그인 진행
        debugPrint('🔵 [UserService] Step 1: Initiating Google Sign-In...');
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

        if (googleUser == null) {
          debugPrint('⚠️ [UserService] Google Sign-In canceled by user');
          return null; // 사용자가 로그인을 취소한 경우
        }

        debugPrint(
            '✅ [UserService] Google Sign-In successful: ${googleUser.email}');
        debugPrint('🔵 [UserService] Step 2: Getting Google authentication...');

        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        debugPrint('✅ [UserService] Google authentication obtained');

        debugPrint('🔵 [UserService] Step 3: Creating Firebase credential...');
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // 2. Firebase Auth로 로그인
        debugPrint('🔵 [UserService] Step 4: Signing in with Firebase...');
        final userCredential = await _auth.signInWithCredential(credential);
        debugPrint(
            '✅ [UserService] Firebase Auth successful: ${userCredential.user?.uid}');

        // 3. 기존 사용자인지 확인
        debugPrint(
            '🔵 [UserService] Step 5: Checking if user exists in Firestore...');
        final userDoc =
            await FirebaseHelper.user(userCredential.user!.uid).get();

        if (!userDoc.exists) {
          // 신규 사용자 - 추가 정보 입력 필요
          debugPrint(
              '🆕 [UserService] New user detected, additional info required');
          return userCredential.user;
        }

        // 기존 사용자 - 사용자 정보 로드
        debugPrint(
            '👤 [UserService] Existing user found, loading user data...');
        await _loadUserData(userCredential.user!.uid);
        debugPrint('✅ [UserService] Google Sign-In completed successfully');

        return userCredential.user;
      } catch (e) {
        debugPrint('❌ [UserService] Google Sign-In error: $e');
        debugPrint('❌ [UserService] Error type: ${e.runtimeType}');
        rethrow; // BaseService에서 에러 메시지 처리하도록 전달
      }
    }, errorContext: 'signInWithGoogle');
  }

  // 구글 로그인 후 추가 정보 저장
  Future<AppUser?> completeGoogleSignUp({
    required String nickname,
    String? gender,
    DateTime? birth,
    List<int>? preferredAgeRange,
    List<String>? interests,
    String? intro,
    File? profileImage,
    String? purpose,
    List<String>? preferredPersonaTypes,
    List<String>? preferredMbti,
    String? communicationStyle,
    List<String>? preferredTopics,
    bool genderAll = false,
    String? referralEmail,
  }) async {
    return await executeWithLoading<AppUser?>(() async {
      if (_firebaseUser == null) {
        throw Exception('로그인된 사용자가 없습니다.');
      }

      // 프로필 이미지 저장
      String? profileImagePath;
      if (profileImage != null) {
        profileImagePath = await LocalProfileImageService.saveProfileImage(
          userId: _firebaseUser!.uid,
          imageFile: profileImage,
        );
      }

      // Firestore에 사용자 정보 저장
      final newUser = AppUser(
        uid: _firebaseUser!.uid,
        email: _firebaseUser!.email ?? '',
        nickname: nickname,
        gender: gender,
        birth: birth,
        age: birth != null ? AppUser.calculateAge(birth) : null,
        preferredPersona: PreferredPersona(
          ageRange: preferredAgeRange ?? [20, 35],
        ),
        interests: interests ?? [],
        intro: intro,
        profileImageUrl: profileImagePath,
        createdAt: DateTime.now(),
        purpose: purpose,
        preferredMbti: preferredMbti,
        communicationStyle: communicationStyle,
        preferredTopics: null,
        genderAll: genderAll,
        dailyMessageCount: 0,
        dailyMessageLimit: AppConstants.dailyMessageLimit,
        lastMessageCountReset: DateTime.now(),
        referralEmail: referralEmail,
      );

      await FirebaseHelper.user(newUser.uid).set(
        FirebaseHelper.withTimestamps({
          ...newUser.toFirestore(),
          'hearts': 10, // 신규 가입 시 기본 하트 10개 지급
        }),
      );

      _currentUser = newUser;
      return newUser;
    }, errorContext: 'completeGoogleSignUp');
  }

  // 이메일/비밀번호로 로그인
  Future<AppUser?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    debugPrint('👤 [UserService] Starting email sign in for: $email');
    return await executeWithLoading<AppUser?>(() async {
      debugPrint(
          '👤 [UserService] Attempting Firebase Auth signInWithEmailAndPassword...');
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      debugPrint(
          '👤 [UserService] Firebase Auth successful, user ID: ${credential.user?.uid}');
      if (credential.user != null) {
        debugPrint('👤 [UserService] Loading user data from Firestore...');
        await _loadUserData(credential.user!.uid);
        debugPrint(
            '👤 [UserService] Current user after loading: ${_currentUser?.nickname}');
      }

      return _currentUser;
    }, errorContext: 'signInWithEmail');
  }

  // Firestore에서 사용자 데이터 로드
  Future<void> _loadUserData(String uid) async {
    debugPrint(
        '👤 [UserService] Starting to load user data from Firestore for: $uid');
    try {
      final doc = await FirebaseHelper.user(uid).get();
      debugPrint('👤 [UserService] Firestore document exists: ${doc.exists}');

      if (doc.exists) {
        debugPrint(
            '👤 [UserService] Converting Firestore document to AppUser...');
        _currentUser = AppUser.fromFirestore(doc);
        debugPrint(
            '👤 [UserService] User data loaded successfully: ${_currentUser?.nickname} (${_currentUser?.email})');

        // 기존 사용자 데이터 마이그레이션 (일일 메시지 제한 필드가 없는 경우)
        final data = doc.data() as Map<String, dynamic>;
        bool needsMigration = false;

        if (data['dailyMessageLimit'] == null ||
            data['dailyMessageCount'] == null) {
          debugPrint('👤 [UserService] User data needs migration, updating...');
          needsMigration = true;
        }

        // hearts 필드가 없는 경우도 마이그레이션 필요
        if (data['hearts'] == null) {
          needsMigration = true;
        }

        if (needsMigration) {
          await _migrateUserData(uid, data);
        }
      } else {
        debugPrint(
            '⚠️ [UserService] User document does not exist in Firestore for uid: $uid');
        _currentUser = null;
      }
    } catch (e) {
      debugPrint('❌ [UserService] Failed to load user data: $e');
      _currentUser = null;
    }
  }

  // 기존 사용자 데이터 마이그레이션
  Future<void> _migrateUserData(
      String uid, Map<String, dynamic> currentData) async {
    try {
      final updates = <String, dynamic>{};

      // 일일 메시지 제한 필드 추가
      if (currentData['dailyMessageLimit'] == null) {
        updates['dailyMessageLimit'] = AppConstants.dailyMessageLimit;
      }
      if (currentData['dailyMessageCount'] == null) {
        updates['dailyMessageCount'] = 0;
      }
      if (currentData['lastMessageCountReset'] == null) {
        updates['lastMessageCountReset'] = FieldValue.serverTimestamp();
      }

      // hearts 필드 추가 (기존 사용자에게는 5개 지급)
      if (currentData['hearts'] == null) {
        updates['hearts'] = 5;
      }

      if (updates.isNotEmpty) {
        await FirebaseHelper.user(uid).update(updates);
      }

      // 로컬 데이터 재로드
      final doc = await FirebaseHelper.user(uid).get();
      if (doc.exists) {
        _currentUser = AppUser.fromFirestore(doc);
      }
    } catch (e) {
      debugPrint('사용자 데이터 마이그레이션 실패: $e');
    }
  }

  // 사용자 정보 업데이트
  Future<bool> updateUserProfile({
    String? nickname,
    String? gender,
    DateTime? birth,
    List<int>? preferredAgeRange,
    List<String>? interests,
    String? intro,
    File? profileImage,
    bool? genderAll,
    String? preferredLanguage,
  }) async {
    final result = await executeWithLoading<bool>(() async {
      if (_currentUser == null) return false;

      // 새 프로필 이미지 저장
      String? newProfileImagePath = _currentUser!.profileImageUrl;
      if (profileImage != null) {
        try {
          debugPrint('🖼️ Saving profile image for user: ${_currentUser!.uid}');
          debugPrint('📁 Image file path: ${profileImage.path}');
          debugPrint('📏 Image file exists: ${await profileImage.exists()}');
          debugPrint(
              '📊 Image file size: ${await profileImage.length()} bytes');

          newProfileImagePath = await LocalProfileImageService.saveProfileImage(
            userId: _currentUser!.uid,
            imageFile: profileImage,
          );
          debugPrint(
              '✅ Profile image saved successfully: $newProfileImagePath');
        } catch (e) {
          debugPrint('❌ Failed to save profile image: $e');
          throw Exception('프로필 사진 저장 중 오류가 발생했습니다.');
        }
      }

      // 업데이트할 데이터 준비
      final updates = <String, dynamic>{
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (nickname != null) updates['nickname'] = nickname;
      if (gender != null) updates['gender'] = gender;
      // Handle birth update - can be set to null for optional
      if (birth != null) {
        updates['birth'] = Timestamp.fromDate(birth);
        updates['age'] = AppUser.calculateAge(birth);
      } else if (birth == null && _currentUser!.birth != null) {
        // Allow clearing birth date if needed (though UI might not support this)
        updates['birth'] = null;
        updates['age'] = null;
      }
      if (preferredAgeRange != null) {
        updates['preferredPersona'] = {
          'ageRange': preferredAgeRange,
        };
      }
      if (interests != null) updates['interests'] = interests;
      if (intro != null) updates['intro'] = intro;
      if (newProfileImagePath != null) {
        updates['profileImageUrl'] = newProfileImagePath;
      }
      if (genderAll != null) updates['genderAll'] = genderAll;
      if (preferredLanguage != null)
        updates['preferredLanguage'] = preferredLanguage;

      // Firestore 업데이트
      await FirebaseHelper.user(_currentUser!.uid).update(updates);

      // 로컬 사용자 정보 업데이트
      await _loadUserData(_currentUser!.uid);

      return true;
    }, errorContext: 'updateUserProfile');

    return result ?? false;
  }

  // 사용자 정보 업데이트 (AppUser 객체 사용)
  Future<bool> updateUser(AppUser user) async {
    final result = await executeWithLoading<bool>(() async {
      if (_currentUser == null || user.uid != _currentUser!.uid) return false;

      // Firestore 업데이트
      await FirebaseHelper.user(user.uid).update(user.toFirestore());

      // 로컬 사용자 정보 업데이트
      _currentUser = user;
      notifyListeners();

      return true;
    }, errorContext: 'updateUser');

    return result ?? false;
  }

  // 로그아웃
  Future<void> signOut() async {
    await executeWithLoading(() async {
      await _auth.signOut();
      await _googleSignIn.signOut();
      _currentUser = null;
      _firebaseUser = null;
    }, errorContext: 'signOut', showError: false);
  }

  // 닉네임 중복 확인
  Future<bool> isNicknameAvailable(String nickname) async {
    try {
      final query = await FirebaseHelper.users
          .where('nickname', isEqualTo: nickname)
          .limit(1)
          .get();

      return query.docs.isEmpty;
    } catch (e) {
      debugPrint('닉네임 중복 확인 실패: $e');
      return false;
    }
  }

  // 프로필 이미지만 업데이트
  Future<bool> updateProfileImage(File profileImage) async {
    final result = await executeWithLoading<bool>(() async {
      if (_currentUser == null) return false;

      // 프로필 이미지 저장 (기존 이미지는 자동 삭제됨)
      final newProfileImagePath =
          await LocalProfileImageService.saveProfileImage(
        userId: _currentUser!.uid,
        imageFile: profileImage,
      );

      if (newProfileImagePath == null) {
        throw Exception('프로필 이미지 저장에 실패했습니다.');
      }

      // Firestore 업데이트
      await FirebaseHelper.user(_currentUser!.uid).update({
        'profileImageUrl': newProfileImagePath,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // 로컬 사용자 정보 업데이트
      await _loadUserData(_currentUser!.uid);

      return true;
    }, errorContext: 'updateProfileImage');

    return result ?? false;
  }

  /// 일일 메시지 제한 관련 메서드들

  // 현재 남은 메시지 수 가져오기
  int getRemainingMessages() {
    if (_currentUser == null) return 0;

    // 기본값 설정 (null safety를 위한 추가 체크)
    final dailyLimit = _currentUser!.dailyMessageLimit;
    final dailyCount = _currentUser!.dailyMessageCount;

    // 리셋이 필요한지 확인
    if (_shouldResetMessageCount()) {
      return dailyLimit;
    }

    return dailyLimit - dailyCount;
  }

  // 일일 메시지 제한에 도달했는지 확인
  bool isDailyMessageLimitReached() {
    if (_currentUser == null) return false; // 로그인하지 않은 경우 제한 없음

    // 리셋이 필요한지 확인하고 필요하면 자동 리셋
    if (_shouldResetMessageCount()) {
      // 비동기 작업이므로 바로 리셋은 못하지만 false 반환
      _resetMessageCount().then((_) {
        debugPrint('✅ 일일 메시지 카운트 자동 리셋됨');
      });
      return false;
    }

    // 기본값 설정 (null safety를 위한 추가 체크)
    final dailyCount = _currentUser!.dailyMessageCount;
    final dailyLimit = _currentUser!.dailyMessageLimit;

    return dailyCount >= dailyLimit;
  }

  // 메시지 카운트 증가
  Future<void> incrementMessageCount() async {
    if (_currentUser == null) return;

    await executeWithLoading(() async {
      // 리셋이 필요한지 확인
      if (_shouldResetMessageCount()) {
        await _resetMessageCount();
      }

      // 카운트 증가
      await FirebaseHelper.user(_currentUser!.uid).update({
        'dailyMessageCount': FieldValue.increment(1),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // 로컬 상태 업데이트
      _currentUser = _currentUser!.copyWith(
        dailyMessageCount: _currentUser!.dailyMessageCount + 1,
      );
      notifyListeners();
    }, errorContext: 'incrementMessageCount');
  }

  // 하트를 사용해서 메시지 카운트 리셋
  Future<bool> resetMessageCountWithHeart() async {
    if (_currentUser == null) return false;

    final result = await executeWithLoading<bool>(() async {
      // 하트가 충분한지 확인 (PurchaseService에서 처리되므로 여기서는 리셋만)
      await _resetMessageCount();
      return true;
    }, errorContext: 'resetMessageCountWithHeart');

    return result ?? false;
  }

  // 메시지 카운트 리셋 (내부 메서드)
  Future<void> _resetMessageCount() async {
    if (_currentUser == null) return;

    final now = DateTime.now();
    await FirebaseHelper.user(_currentUser!.uid).update({
      'dailyMessageCount': 0,
      'lastMessageCountReset': Timestamp.fromDate(now),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    // 로컬 상태 업데이트
    _currentUser = _currentUser!.copyWith(
      dailyMessageCount: 0,
      lastMessageCountReset: now,
    );
    notifyListeners();
  }

  // 메시지 카운트 리셋이 필요한지 확인 (한국 시간 기준 자정)
  bool _shouldResetMessageCount() {
    if (_currentUser == null || _currentUser!.lastMessageCountReset == null) {
      return true;
    }

    // 한국 시간대 (UTC+9) 기준으로 자정 체크
    final now = DateTime.now().toUtc().add(const Duration(hours: 9));
    final lastReset = _currentUser!.lastMessageCountReset!
        .toUtc()
        .add(const Duration(hours: 9));

    // 날짜가 바뀌었으면 리셋 필요
    return now.year != lastReset.year ||
        now.month != lastReset.month ||
        now.day != lastReset.day;
  }
}
