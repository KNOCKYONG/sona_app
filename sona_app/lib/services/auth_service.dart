import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  User? _user;
  bool _isLoading = false;
  bool _isTutorialMode = false;

  User? get user => _user;
  User? get currentUser => _user; // Firebase 호환성을 위한 별칭
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;
  bool get isTutorialMode => _isTutorialMode;

  AuthService() {
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  Future<bool> signInWithGoogle() async {
    try {
      _isLoading = true;
      notifyListeners();

      // Google 로그인 시작
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      // 사용자가 로그인을 취소한 경우
      if (googleUser == null) {
        _isLoading = false;
        notifyListeners();
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

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint('Google sign in failed: $e');
      return false;
    }
  }

  Future<bool> signInAnonymously() async {
    try {
      _isLoading = true;
      notifyListeners();

      final credential = await _auth.signInAnonymously();
      _user = credential.user;
      
      // 첫 로그인 시 기본 설정 저장
      if (credential.additionalUserInfo?.isNewUser == true) {
        await _saveDefaultSettings();
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint('Anonymous sign in failed: $e');
      return false;
    }
  }


  Future<bool> signInWithEmail(String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();

      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      _user = credential.user;

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint('Email sign in failed: $e');
      return false;
    }
  }

  Future<bool> signUpWithEmail(String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();

      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      _user = credential.user;
      
      // 첫 회원가입 시 기본 설정 저장
      await _saveDefaultSettings();
      await _saveUserProfile();

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint('Email sign up failed: $e');
      return false;
    }
  }

  Future<void> signOut() async {
    try {
      // Google 로그인도 로그아웃
      await _googleSignIn.signOut();
      await _auth.signOut();
      _user = null;
      _isTutorialMode = false;
      notifyListeners();
    } catch (e) {
      debugPrint('Sign out failed: $e');
    }
  }

  Future<void> _saveDefaultSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('first_launch', false);
    await prefs.setString('user_id', _user?.uid ?? '');
    await prefs.setInt('emotion_points', 100); // 초기 감정 포인트
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
    final prefs = await SharedPreferences.getInstance();
    return {
      'emotion_points': prefs.getInt('emotion_points') ?? 100,
      'notifications_enabled': prefs.getBool('notifications_enabled') ?? true,
      'sound_enabled': prefs.getBool('sound_enabled') ?? true,
      'theme_mode': prefs.getString('theme_mode') ?? 'light',
    };
  }

  Future<void> updateUserPreferences(Map<String, dynamic> preferences) async {
    final prefs = await SharedPreferences.getInstance();
    
    for (String key in preferences.keys) {
      final value = preferences[key];
      if (value is bool) {
        await prefs.setBool(key, value);
      } else if (value is int) {
        await prefs.setInt(key, value);
      } else if (value is String) {
        await prefs.setString(key, value);
      }
    }
    
    notifyListeners();
  }

  Future<void> spendEmotionPoints(int amount) async {
    final prefs = await SharedPreferences.getInstance();
    final currentPoints = prefs.getInt('emotion_points') ?? 0;
    final newPoints = (currentPoints - amount).clamp(0, 9999);
    await prefs.setInt('emotion_points', newPoints);
    notifyListeners();
  }

  Future<void> addEmotionPoints(int amount) async {
    final prefs = await SharedPreferences.getInstance();
    final currentPoints = prefs.getInt('emotion_points') ?? 0;
    final newPoints = (currentPoints + amount).clamp(0, 9999);
    await prefs.setInt('emotion_points', newPoints);
    notifyListeners();
  }

  // 튜토리얼 모드 시작
  Future<bool> startTutorialMode() async {
    try {
      _isTutorialMode = true;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_tutorial_mode', true);
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Failed to start tutorial mode: $e');
      return false;
    }
  }

  // 튜토리얼 모드 종료 후 로그인으로 이동
  Future<bool> exitTutorialAndSignIn() async {
    _isTutorialMode = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_tutorial_mode', false);
    notifyListeners();
    return await signInAnonymously();
  }

  // 튜토리얼 모드 종료
  void exitTutorialMode() {
    _isTutorialMode = false;
    notifyListeners();
  }

  // 튜토리얼 모드에서 사용할 가상 사용자 정보
  Map<String, dynamic> getTutorialUserPreferences() {
    return {
      'emotion_points': 100,
      'notifications_enabled': true,
      'sound_enabled': true,
      'theme_mode': 'light',
    };
  }
}