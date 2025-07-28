import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../core/preferences_manager.dart';
import '../base/base_service.dart';

class AuthService extends BaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    // Web Client ID from Firebase console
    clientId: '874385422837-p5k562hl218ph0s2ucqgdi4ngk658r4s.apps.googleusercontent.com',
  );
  User? _user;

  User? get user => _user;
  User? get currentUser => _user; // Firebase 호환성을 위한 별칭
  bool get isAuthenticated => _user != null;

  AuthService() {
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  Future<bool> signInWithGoogle() async {
    final result = await executeWithLoading<bool>(() async {
      // Google 로그인 시작
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      // 사용자가 로그인을 취소한 경우
      if (googleUser == null) {
        return false;
      }

      // Google 인증 정보 가져오기
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Firebase 인증 자격 증명 생성
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Firebase에 로그인
      final userCredential = await _auth.signInWithCredential(credential);
      _user = userCredential.user;

      // 첫 로그인 시 기본 설정 저장
      if (userCredential.additionalUserInfo?.isNewUser == true) {
        await _saveDefaultSettings();
        await _saveUserProfile();
      }

      return true;
    }, errorContext: 'signInWithGoogle');
    
    return result ?? false;
  }

  Future<bool> signInAnonymously() async {
    final result = await executeWithLoading<bool>(() async {
      final credential = await _auth.signInAnonymously();
      _user = credential.user;
      
      // 첫 로그인 시 기본 설정 저장
      if (credential.additionalUserInfo?.isNewUser == true) {
        await _saveDefaultSettings();
      }

      return true;
    }, errorContext: 'signInAnonymously');
    
    return result ?? false;
  }


  Future<bool> signInWithEmail(String email, String password) async {
    final result = await executeWithLoading<bool>(() async {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      _user = credential.user;
      return true;
    }, errorContext: 'signInWithEmail');
    
    return result ?? false;
  }

  Future<bool> signUpWithEmail(String email, String password) async {
    final result = await executeWithLoading<bool>(() async {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      _user = credential.user;
      
      // 첫 회원가입 시 기본 설정 저장
      await _saveDefaultSettings();
      await _saveUserProfile();
      
      return true;
    }, errorContext: 'signUpWithEmail');
    
    return result ?? false;
  }

  Future<void> signOut() async {
    await executeWithLoading(() async {
      // Google 로그인도 로그아웃
      await _googleSignIn.signOut();
      await _auth.signOut();
      _user = null;
    }, errorContext: 'signOut', showError: false);
  }

  Future<void> _saveDefaultSettings() async {
    await PreferencesManager.setBool('first_launch', false);
    await PreferencesManager.setString('user_id', _user?.uid ?? '');
    await PreferencesManager.setInt('emotion_points', 100); // 초기 감정 포인트
  }

  Future<void> _saveUserProfile() async {
    if (_user == null) return;
    
    try {
      // Firestore에 사용자 프로필 저장은 나중에 구현
      // final userDoc = {
      //   'uid': _user!.uid,
      //   'email': _user!.email,
      //   'displayName': _user!.displayName ?? _user!.email?.split('@')[0] ?? 'User',
      //   'photoURL': _user!.photoURL,
      //   'createdAt': DateTime.now().toIso8601String(),
      //   'lastLoginAt': DateTime.now().toIso8601String(),
      //   'emotionPoints': 100,
      //   'preferences': {
      //     'notifications': true,
      //     'soundEnabled': true,
      //     'theme': 'light',
      //   },
      //   'stats': {
      //     'totalMatches': 0,
      //     'totalMessages': 0,
      //     'currentStreak': 0,
      //   },
      // };
      // await FirebaseFirestore.instance
      //     .collection('users')
      //     .doc(_user!.uid)
      //     .set(userDoc);
      
      debugPrint('User profile saved for: ${_user!.uid}');
    } catch (e) {
      debugPrint('Failed to save user profile: $e');
    }
  }

  Future<Map<String, dynamic>> getUserPreferences() async {
    return {
      'emotion_points': await PreferencesManager.getInt('emotion_points') ?? 100,
      'notifications_enabled': await PreferencesManager.getBool('notifications_enabled') ?? true,
      'sound_enabled': await PreferencesManager.getBool('sound_enabled') ?? true,
      'theme_mode': await PreferencesManager.getString('theme_mode') ?? 'light',
    };
  }

  Future<void> updateUserPreferences(Map<String, dynamic> preferences) async {
    for (String key in preferences.keys) {
      final value = preferences[key];
      if (value is bool) {
        await PreferencesManager.setBool(key, value);
      } else if (value is int) {
        await PreferencesManager.setInt(key, value);
      } else if (value is String) {
        await PreferencesManager.setString(key, value);
      }
    }
    
    notifyListeners();
  }

  Future<void> spendEmotionPoints(int amount) async {
    final currentPoints = await PreferencesManager.getInt('emotion_points') ?? 0;
    final newPoints = (currentPoints - amount).clamp(0, 9999);
    await PreferencesManager.setInt('emotion_points', newPoints);
    notifyListeners();
  }

  Future<void> addEmotionPoints(int amount) async {
    final currentPoints = await PreferencesManager.getInt('emotion_points') ?? 0;
    final newPoints = (currentPoints + amount).clamp(0, 9999);
    await PreferencesManager.setInt('emotion_points', newPoints);
    notifyListeners();
  }

}