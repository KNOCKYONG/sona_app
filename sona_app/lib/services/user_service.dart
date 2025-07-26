import 'dart:io';
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

  // 프로필 이미지 업로드
  Future<String?> _uploadProfileImage(String uid, File imageFile) async {
    try {
      final ref = _storage.ref().child('users/$uid/profile.jpg');
      final uploadTask = await ref.putFile(imageFile);
      final downloadUrl = await uploadTask.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      debugPrint('프로필 이미지 업로드 실패: $e');
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
}