import 'dart:io';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import '../models/app_user.dart';

class UserService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  
  AppUser? _currentUser;
  User? _firebaseUser;
  bool _isLoading = false;
  String? _error;

  // Getters
  AppUser? get currentUser => _currentUser;
  User? get firebaseUser => _firebaseUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
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
    String? gender,
    required DateTime birth,
    required String preferredGender,
    required List<int> preferredAgeRange,
    required List<String> interests,
    String? intro,
    File? profileImage,
    String? purpose,
    List<String>? preferredPersonaTypes,
    List<String>? preferredMbti,
    String? communicationStyle,
    List<String>? preferredTopics,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

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
        profileImageUrl = await _uploadProfileImage(
          credential.user!.uid,
          profileImage,
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
          gender: preferredGender,
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
      );

      await _firestore.collection('users').doc(newUser.uid).set(
        newUser.toFirestore(),
      );

      _currentUser = newUser;
      _isLoading = false;
      notifyListeners();
      
      return newUser;
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException: ${e.code} - ${e.message}');
      _error = _getAuthErrorMessage(e.code);
      _isLoading = false;
      notifyListeners();
      return null;
    } catch (e) {
      debugPrint('회원가입 오류: $e');
      _error = '회원가입 중 오류가 발생했습니다: $e';
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  // 구글 로그인 및 추가 정보 입력
  Future<User?> signInWithGoogle() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // 1. Google 로그인 진행
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        _isLoading = false;
        notifyListeners();
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
      final userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (!userDoc.exists) {
        // 신규 사용자 - 추가 정보 입력 필요
        _isLoading = false;
        notifyListeners();
        return userCredential.user;
      }

      // 기존 사용자 - 사용자 정보 로드
      await _loadUserData(userCredential.user!.uid);
      _isLoading = false;
      notifyListeners();
      
      return userCredential.user;
    } catch (e) {
      _error = '구글 로그인 중 오류가 발생했습니다: $e';
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  // 구글 로그인 후 추가 정보 저장
  Future<AppUser?> completeGoogleSignUp({
    required String nickname,
    String? gender,
    required DateTime birth,
    required String preferredGender,
    required List<int> preferredAgeRange,
    required List<String> interests,
    String? intro,
    File? profileImage,
    String? purpose,
    List<String>? preferredPersonaTypes,
    List<String>? preferredMbti,
    String? communicationStyle,
    List<String>? preferredTopics,
  }) async {
    try {
      if (_firebaseUser == null) {
        throw Exception('로그인된 사용자가 없습니다.');
      }

      _isLoading = true;
      _error = null;
      notifyListeners();

      // 프로필 이미지 업로드
      String? profileImageUrl;
      if (profileImage != null) {
        profileImageUrl = await _uploadProfileImage(
          _firebaseUser!.uid,
          profileImage,
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
          gender: preferredGender,
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
      );

      await _firestore.collection('users').doc(newUser.uid).set(
        newUser.toFirestore(),
      );

      _currentUser = newUser;
      _isLoading = false;
      notifyListeners();
      
      return newUser;
    } catch (e) {
      _error = '프로필 저장 중 오류가 발생했습니다: $e';
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  // 이메일/비밀번호로 로그인
  Future<AppUser?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        await _loadUserData(credential.user!.uid);
      }

      _isLoading = false;
      notifyListeners();
      
      return _currentUser;
    } on FirebaseAuthException catch (e) {
      _error = _getAuthErrorMessage(e.code);
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  // 프로필 이미지 업로드 (Firestore에 base64로 저장)
  Future<String?> _uploadProfileImage(String uid, File imageFile) async {
    try {
      // 파일이 존재하는지 확인
      if (!await imageFile.exists()) {
        debugPrint('이미지 파일이 존재하지 않습니다: ${imageFile.path}');
        return null;
      }
      
      // 파일 크기 확인 (1MB 제한 - Firestore 문서 크기 제한)
      final fileSize = await imageFile.length();
      if (fileSize > 1024 * 1024) {
        debugPrint('파일 크기가 너무 큽니다: ${fileSize / 1024 / 1024}MB');
        _error = '이미지 파일 크기는 1MB 이하여야 합니다.';
        return null;
      }
      
      debugPrint('이미지 파일 크기: ${fileSize / 1024}KB');
      
      try {
        debugPrint('Firestore에 base64로 프로필 이미지 저장 시도...');
        
        // 파일을 바이트로 읽기
        final bytes = await imageFile.readAsBytes();
        debugPrint('이미지 바이트 크기: ${bytes.length} bytes (${bytes.length / 1024}KB)');
        
        // base64로 인코딩
        debugPrint('Base64 인코딩 시작...');
        final base64String = base64Encode(bytes);
        final dataUrl = 'data:image/jpeg;base64,$base64String';
        debugPrint('Base64 인코딩 완료. 데이터 URL 길이: ${dataUrl.length}');
        
        // Firestore에 저장
        debugPrint('Firestore에 저장 시작...');
        await _firestore.collection('user_profile_images').doc(uid).set({
          'imageData': dataUrl,
          'updatedAt': FieldValue.serverTimestamp(),
        });
        
        debugPrint('✅ Firestore에 프로필 이미지 저장 성공!');
        _error = null; // 성공 시 에러 메시지 초기화
        return dataUrl;
      } catch (firestoreError) {
        debugPrint('Firestore 저장 실패: $firestoreError');
        _error = '이미지 저장에 실패했습니다. 다시 시도해주세요.';
      }
      
      return null;
    } catch (e) {
      debugPrint('프로필 이미지 업로드 최종 실패: $e');
      _error = _error ?? '이미지 업로드에 실패했습니다. 나중에 다시 시도해주세요.';
      return null;
    }
  }

  // Firestore에서 사용자 데이터 로드
  Future<void> _loadUserData(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
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
    String? preferredGender,
    List<int>? preferredAgeRange,
    List<String>? interests,
    String? intro,
    File? profileImage,
  }) async {
    try {
      if (_currentUser == null) return false;

      _isLoading = true;
      notifyListeners();

      // 새 프로필 이미지 업로드
      String? newProfileImageUrl = _currentUser!.profileImageUrl;
      if (profileImage != null) {
        newProfileImageUrl = await _uploadProfileImage(
          _currentUser!.uid,
          profileImage,
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
      if (preferredGender != null || preferredAgeRange != null) {
        updates['preferredPersona'] = {
          'gender': preferredGender ?? _currentUser!.preferredPersona.gender,
          'ageRange': preferredAgeRange ?? _currentUser!.preferredPersona.ageRange,
        };
      }
      if (interests != null) updates['interests'] = interests;
      if (intro != null) updates['intro'] = intro;
      if (newProfileImageUrl != null) {
        updates['profileImageUrl'] = newProfileImageUrl;
      }

      // Firestore 업데이트
      await _firestore.collection('users').doc(_currentUser!.uid).update(updates);

      // 로컬 사용자 정보 업데이트
      await _loadUserData(_currentUser!.uid);

      _isLoading = false;
      notifyListeners();
      
      return true;
    } catch (e) {
      _error = '프로필 업데이트 실패: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // 로그아웃
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
      _currentUser = null;
      _firebaseUser = null;
      notifyListeners();
    } catch (e) {
      debugPrint('로그아웃 실패: $e');
    }
  }

  // 에러 메시지 변환
  String _getAuthErrorMessage(String code) {
    switch (code) {
      case 'email-already-in-use':
        return '이미 사용 중인 이메일입니다.';
      case 'invalid-email':
        return '올바르지 않은 이메일 형식입니다.';
      case 'weak-password':
        return '비밀번호는 6자 이상이어야 합니다.';
      case 'user-not-found':
        return '등록되지 않은 이메일입니다.';
      case 'wrong-password':
        return '잘못된 비밀번호입니다.';
      default:
        return '인증 중 오류가 발생했습니다.';
    }
  }

  // 닉네임 중복 확인
  Future<bool> isNicknameAvailable(String nickname) async {
    try {
      final query = await _firestore
          .collection('users')
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
    try {
      if (_currentUser == null) return false;
      
      _isLoading = true;
      notifyListeners();
      
      // 프로필 이미지 업로드
      final newProfileImageUrl = await _uploadProfileImage(
        _currentUser!.uid,
        profileImage,
      );
      
      // Firestore 업데이트
      await _firestore.collection('users').doc(_currentUser!.uid).update({
        'profileImageUrl': newProfileImageUrl,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      
      // 로컬 사용자 정보 업데이트
      await _loadUserData(_currentUser!.uid);
      
      _isLoading = false;
      notifyListeners();
      
      return true;
    } catch (e) {
      _error = '프로필 이미지 업데이트 실패: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}