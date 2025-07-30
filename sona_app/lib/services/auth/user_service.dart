import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import '../../models/app_user.dart';
import '../base/base_service.dart';
import '../../helpers/firebase_helper.dart';
import '../storage/firebase_storage_service.dart';

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
      _firebaseUser = user;
      if (user != null) {
        await _loadUserData(user.uid);
      } else {
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
    required String gender,
    required DateTime birth,
    required List<int> preferredAgeRange,
    required List<String> interests,
    String? intro,
    File? profileImage,
    String? purpose,
    List<String>? preferredPersonaTypes,
    List<String>? preferredMbti,
    String? communicationStyle,
    List<String>? preferredTopics,
    bool genderAll = false,
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

      // 2. 프로필 이미지 업로드 (선택사항)
      String? profileImageUrl;
      if (profileImage != null) {
        profileImageUrl = await FirebaseStorageService.uploadUserProfileImage(
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
        age: AppUser.calculateAge(birth),
        preferredPersona: PreferredPersona(
          ageRange: preferredAgeRange,
        ),
        interests: interests,
        intro: intro,
        profileImageUrl: profileImageUrl,
        createdAt: DateTime.now(),
        purpose: purpose,
        preferredPersonaTypes: preferredPersonaTypes,
        preferredMbti: preferredMbti,
        communicationStyle: communicationStyle,
        preferredTopics: preferredTopics,
        genderAll: genderAll,
      );

      await FirebaseHelper.user(newUser.uid).set(
        newUser.toFirestore(),
      );

      _currentUser = newUser;
      return newUser;
    }, errorContext: 'signUpWithEmail');
  }

  // 구글 로그인 및 추가 정보 입력
  Future<User?> signInWithGoogle() async {
    return await executeWithLoading<User?>(() async {
      // 1. Google 로그인 진행
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return null;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 2. Firebase Auth로 로그인
      final userCredential = await _auth.signInWithCredential(credential);
      
      // 3. 기존 사용자인지 확인
      final userDoc = await FirebaseHelper.user(userCredential.user!.uid).get();

      if (!userDoc.exists) {
        // 신규 사용자 - 추가 정보 입력 필요
        return userCredential.user;
      }

      // 기존 사용자 - 사용자 정보 로드
      await _loadUserData(userCredential.user!.uid);
      
      return userCredential.user;
    }, errorContext: 'signInWithGoogle');
  }

  // 구글 로그인 후 추가 정보 저장
  Future<AppUser?> completeGoogleSignUp({
    required String nickname,
    required String gender,
    required DateTime birth,
    required List<int> preferredAgeRange,
    required List<String> interests,
    String? intro,
    File? profileImage,
    String? purpose,
    List<String>? preferredPersonaTypes,
    List<String>? preferredMbti,
    String? communicationStyle,
    List<String>? preferredTopics,
    bool genderAll = false,
  }) async {
    return await executeWithLoading<AppUser?>(() async {
      if (_firebaseUser == null) {
        throw Exception('로그인된 사용자가 없습니다.');
      }

      // 프로필 이미지 업로드
      String? profileImageUrl;
      if (profileImage != null) {
        profileImageUrl = await FirebaseStorageService.uploadUserProfileImage(
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
        age: AppUser.calculateAge(birth),
        preferredPersona: PreferredPersona(
          ageRange: preferredAgeRange,
        ),
        interests: interests,
        intro: intro,
        profileImageUrl: profileImageUrl,
        createdAt: DateTime.now(),
        purpose: purpose,
        preferredPersonaTypes: preferredPersonaTypes,
        preferredMbti: preferredMbti,
        communicationStyle: communicationStyle,
        preferredTopics: preferredTopics,
        genderAll: genderAll,
      );

      await FirebaseHelper.user(newUser.uid).set(
        newUser.toFirestore(),
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
    return await executeWithLoading<AppUser?>(() async {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        await _loadUserData(credential.user!.uid);
      }

      return _currentUser;
    }, errorContext: 'signInWithEmail');
  }


  // Firestore에서 사용자 데이터 로드
  Future<void> _loadUserData(String uid) async {
    try {
      final doc = await FirebaseHelper.user(uid).get();
      if (doc.exists) {
        _currentUser = AppUser.fromFirestore(doc);
      }
    } catch (e) {
      debugPrint('사용자 데이터 로드 실패: $e');
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
  }) async {
    final result = await executeWithLoading<bool>(() async {
      if (_currentUser == null) return false;

      // 새 프로필 이미지 업로드
      String? newProfileImageUrl = _currentUser!.profileImageUrl;
      if (profileImage != null) {
        newProfileImageUrl = await FirebaseStorageService.uploadUserProfileImage(
          userId: _currentUser!.uid,
          imageFile: profileImage,
        );
      }

      // 업데이트할 데이터 준비
      final updates = <String, dynamic>{
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (nickname != null) updates['nickname'] = nickname;
      if (gender != null) updates['gender'] = gender;
      if (birth != null) {
        updates['birth'] = Timestamp.fromDate(birth);
        updates['age'] = AppUser.calculateAge(birth);
      }
      if (preferredAgeRange != null) {
        updates['preferredPersona'] = {
          'ageRange': preferredAgeRange,
        };
      }
      if (interests != null) updates['interests'] = interests;
      if (intro != null) updates['intro'] = intro;
      if (newProfileImageUrl != null) {
        updates['profileImageUrl'] = newProfileImageUrl;
      }
      if (genderAll != null) updates['genderAll'] = genderAll;

      // Firestore 업데이트
      await FirebaseHelper.user(_currentUser!.uid).update(updates);

      // 로컬 사용자 정보 업데이트
      await _loadUserData(_currentUser!.uid);

      return true;
    }, errorContext: 'updateUserProfile');
    
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
      
      // 프로필 이미지 업로드
      final newProfileImageUrl = await FirebaseStorageService.uploadUserProfileImage(
        userId: _currentUser!.uid,
        imageFile: profileImage,
      );
      
      // Firestore 업데이트
      await FirebaseHelper.user(_currentUser!.uid).update({
        'profileImageUrl': newProfileImageUrl,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      
      // 로컬 사용자 정보 업데이트
      await _loadUserData(_currentUser!.uid);
      
      return true;
    }, errorContext: 'updateProfileImage');
    
    return result ?? false;
  }
}