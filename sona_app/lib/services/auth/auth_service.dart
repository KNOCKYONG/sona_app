import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import '../../core/preferences_manager.dart';
import '../../core/constants.dart';
import '../base/base_service.dart';
import '../storage/guest_conversation_service.dart';
import '../../models/message.dart';

class AuthService extends BaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    // Web Client ID from Firebase console
    clientId:
        '874385422837-p5k562hl218ph0s2ucqgdi4ngk658r4s.apps.googleusercontent.com',
  );
  User? _user;

  User? get user => _user;
  User? get currentUser => _user; // Firebase 호환성을 위한 별칭
  bool get isAuthenticated => _user != null;
  
  // Guest mode support
  Future<bool> get isGuestUser async {
    if (_user == null) return false;
    if (!_user!.isAnonymous) return false;
    
    // Check if user is marked as guest in local storage
    return await PreferencesManager.getBool(AppConstants.isGuestUserKey) ?? false;
  }

  AuthService() {
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  /// Auth 상태가 초기화될 때까지 대기
  Future<void> waitForAuthState() async {
    // authStateChanges의 첫 번째 이벤트를 기다림
    await _auth.authStateChanges().first;
  }

  Future<bool> signInWithGoogle() async {
    final result = await executeWithLoading<bool>(() async {
      // Check if current user is guest before Google sign-in
      final wasGuest = await isGuestUser;
      Map<String, dynamic>? guestData;
      
      if (wasGuest) {
        // Save guest data before linking accounts
        guestData = await _saveGuestDataForMigration();
        debugPrint('💾 [AuthService] Saved guest data for Google sign-in migration');
        
        // Clear matched personas from local storage to prevent loading guest's matches
        await PreferencesManager.remove('matched_personas');
        debugPrint('🧹 [AuthService] Cleared guest matched personas before Google sign-in');
      }
      
      // Google 로그인 시작
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      // 사용자가 로그인을 취소한 경우
      if (googleUser == null) {
        return false;
      }

      // Google 인증 정보 가져오기
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

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
        
        // Migrate guest data if user was previously a guest
        if (wasGuest && guestData != null && _user != null) {
          await _migrateGuestDataToMember(_user!.uid, guestData);
          await _clearGuestData();
          debugPrint('✅ [AuthService] Guest data migrated successfully via Google sign-in');
        }
      }

      return true;
    }, errorContext: 'signInWithGoogle');

    return result ?? false;
  }

  Future<bool> signInWithApple() async {
    // Only available on iOS
    if (!Platform.isIOS) {
      debugPrint('⚠️ [AuthService] Apple Sign-In is only available on iOS');
      return false;
    }

    final result = await executeWithLoading<bool>(() async {
      // Check if current user is guest before Apple sign-in
      final wasGuest = await isGuestUser;
      Map<String, dynamic>? guestData;
      
      if (wasGuest) {
        debugPrint('🔄 [AuthService] Current user is guest, preparing data migration for Apple sign-in');
        guestData = await _collectGuestData();
      }

      try {
        // Check Apple Sign-In availability first
        final isAvailable = await SignInWithApple.isAvailable();
        if (!isAvailable) {
          debugPrint('❌ [AuthService] Apple Sign-In is not available on this device');
          setError('Apple 로그인을 사용할 수 없는 기기입니다');
          return false;
        }

        // Generate nonce for security
        final rawNonce = _generateNonce();
        final nonce = _sha256ofString(rawNonce);

        debugPrint('🍎 [AuthService] Requesting Apple ID credential...');
        debugPrint('  - Generated nonce: $rawNonce');
        debugPrint('  - SHA256 nonce: $nonce');
        
        // Request Apple ID credential
        final appleCredential = await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
          nonce: nonce,
        );

        // Log received credential details for debugging
        debugPrint('🍎 [AuthService] Apple credential received:');
        debugPrint('  - identityToken: ${appleCredential.identityToken?.substring(0, math.min(20, appleCredential.identityToken?.length ?? 0))}...');
        debugPrint('  - identityToken length: ${appleCredential.identityToken?.length}');
        debugPrint('  - authorizationCode: ${appleCredential.authorizationCode.substring(0, math.min(20, appleCredential.authorizationCode.length))}...');
        debugPrint('  - authorizationCode length: ${appleCredential.authorizationCode.length}');
        debugPrint('  - userIdentifier: ${appleCredential.userIdentifier}');
        debugPrint('  - email: ${appleCredential.email ?? "null"}');
        debugPrint('  - familyName: ${appleCredential.familyName ?? "null"}');
        debugPrint('  - givenName: ${appleCredential.givenName ?? "null"}');
        debugPrint('  - state: ${appleCredential.state ?? "null"}');

        debugPrint('🍎 [AuthService] Creating OAuth credential...');
        
        // Create OAuth credential with additional logging
        final oauthCredential = OAuthProvider("apple.com").credential(
          idToken: appleCredential.identityToken,
          rawNonce: rawNonce,
          accessToken: appleCredential.authorizationCode,
        );
        
        debugPrint('🍎 [AuthService] OAuth credential created successfully');
        debugPrint('🍎 [AuthService] Signing in with Firebase...');

        // Sign in with Firebase
        final userCredential = await _auth.signInWithCredential(oauthCredential);
        _user = userCredential.user;

        if (_user != null) {
          debugPrint('✅ [AuthService] Apple Sign-In successful: ${_user!.uid}');
          
          // Store Apple user info if available
          if (appleCredential.email != null) {
            await PreferencesManager.setString('apple_user_email', appleCredential.email!);
          }
          if (appleCredential.givenName != null || appleCredential.familyName != null) {
            final fullName = '${appleCredential.givenName ?? ''} ${appleCredential.familyName ?? ''}'.trim();
            if (fullName.isNotEmpty) {
              await PreferencesManager.setString('apple_user_name', fullName);
            }
          }

          // Migrate guest data if user was previously a guest
          if (wasGuest && guestData != null) {
            await _migrateGuestDataToMember(_user!.uid, guestData);
            await _clearGuestData();
            debugPrint('✅ [AuthService] Guest data migrated successfully via Apple sign-in');
          }
        }

        return true;
      } on SignInWithAppleAuthorizationException catch (e) {
        // Handle specific Apple Sign-In errors
        debugPrint('❌ [AuthService] Apple Sign-In authorization error: ${e.code} - ${e.message}');
        
        switch (e.code) {
          case AuthorizationErrorCode.canceled:
            debugPrint('⚠️ [AuthService] User canceled Apple Sign-In');
            setError('Apple 로그인이 취소되었습니다');
            break;
          case AuthorizationErrorCode.failed:
            debugPrint('❌ [AuthService] Apple Sign-In failed');
            setError('Apple 로그인에 실패했습니다. 다시 시도해주세요');
            break;
          case AuthorizationErrorCode.invalidResponse:
            debugPrint('❌ [AuthService] Invalid response from Apple');
            setError('Apple 서버 응답 오류. 잠시 후 다시 시도해주세요');
            break;
          case AuthorizationErrorCode.notHandled:
            debugPrint('❌ [AuthService] Apple Sign-In not handled');
            setError('Apple 로그인 처리 오류');
            break;
          case AuthorizationErrorCode.unknown:
            debugPrint('❌ [AuthService] Unknown Apple Sign-In error');
            setError('Apple 로그인 오류가 발생했습니다');
            break;
          default:
            debugPrint('❌ [AuthService] Unexpected Apple Sign-In error');
            setError('Apple 로그인 중 오류가 발생했습니다');
        }
        return false;
      } on FirebaseAuthException catch (e) {
        debugPrint('❌ [AuthService] Firebase Auth error during Apple Sign-In:');
        debugPrint('  - Error code: ${e.code}');
        debugPrint('  - Error message: ${e.message}');
        debugPrint('  - Full error: $e');
        
        // More specific error handling for common Firebase Auth errors
        switch (e.code) {
          case 'invalid-credential':
            debugPrint('  ⚠️ This usually means:');
            debugPrint('    1. Service ID mismatch in Firebase Console');
            debugPrint('    2. Team ID is incorrect');
            debugPrint('    3. Key ID or Private Key is wrong');
            debugPrint('    4. OAuth redirect URL mismatch');
            setError('Apple 로그인 설정 오류. Firebase Console에서 Apple 프로바이더 설정을 확인해주세요.');
            break;
          case 'operation-not-allowed':
            debugPrint('  ⚠️ Apple Sign-In is not enabled in Firebase Console');
            setError('Apple 로그인이 비활성화되어 있습니다. 관리자에게 문의해주세요.');
            break;
          case 'user-disabled':
            debugPrint('  ⚠️ User account has been disabled');
            setError('계정이 비활성화되었습니다.');
            break;
          default:
            setError('Firebase 인증 오류: ${e.message}');
        }
        return false;
      } catch (e) {
        debugPrint('❌ [AuthService] Unexpected error during Apple Sign-In: $e');
        setError('Apple 로그인 중 예기치 않은 오류가 발생했습니다');
        return false;
      }
    }, errorContext: 'signInWithApple');

    return result ?? false;
  }

  // Generate a cryptographically secure random nonce
  String _generateNonce([int length = 32]) {
    const charset = '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = math.Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)]).join();
  }

  // Returns the sha256 hash of [input] in hex notation.
  String _sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
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

  /// Sign in as guest user with limited features
  Future<bool> signInAsGuest() async {
    final result = await executeWithLoading<bool>(() async {
      debugPrint('🔵 [AuthService] Starting guest sign-in...');
      
      // Sign in anonymously through Firebase
      final credential = await _auth.signInAnonymously();
      _user = credential.user;
      
      if (_user == null) {
        debugPrint('❌ [AuthService] Guest sign-in failed: no user');
        return false;
      }
      
      // Mark as guest user in local storage
      await PreferencesManager.setBool(AppConstants.isGuestUserKey, true);
      
      // Set guest session start time
      await PreferencesManager.setString(
        AppConstants.guestSessionStartKey,
        DateTime.now().toIso8601String(),
      );
      
      // Initialize guest message count
      await PreferencesManager.setInt(AppConstants.guestMessageCountKey, 0);
      
      // Initialize guest hearts (1 heart for guests)
      await PreferencesManager.setInt(AppConstants.guestHeartsKey, 1);
      debugPrint('💝 [AuthService] Guest hearts initialized: 1');
      
      // Save default settings for guest
      if (credential.additionalUserInfo?.isNewUser == true) {
        await _saveDefaultSettings();
      }
      
      debugPrint('✅ [AuthService] Guest sign-in successful: ${_user!.uid}');
      return true;
    }, errorContext: 'signInAsGuest');

    return result ?? false;
  }

  Future<bool> signInWithEmail(String email, String password) async {
    final result = await executeWithLoading<bool>(() async {
      try {
        final credential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        _user = credential.user;
        return true;
      } on FirebaseAuthException catch (e) {
        // Firebase Auth 에러를 더 구체적으로 처리
        debugPrint('Firebase Auth Error Code: ${e.code}');
        debugPrint('Firebase Auth Error Message: ${e.message}');

        // 네트워크 에러인 경우 추가 디버깅 정보
        if (e.code == 'network-request-failed') {
          debugPrint('Network error details: ${e.toString()}');
          debugPrint(
              'Please check: 1) Internet connection 2) Firebase project setup 3) Email/Password auth enabled in Firebase Console');
        }

        // BaseService의 _getErrorMessage가 처리하도록 에러를 다시 throw
        throw e;
      }
    }, errorContext: 'signInWithEmail');

    return result ?? false;
  }

  Future<bool> signUpWithEmail(String email, String password) async {
    final result = await executeWithLoading<bool>(() async {
      // Check if current user is guest before signup
      final wasGuest = await isGuestUser;
      Map<String, dynamic>? guestData;
      
      if (wasGuest) {
        // Save guest data before linking accounts
        guestData = await _saveGuestDataForMigration();
        debugPrint('💾 [AuthService] Saved guest data for migration');
      }
      
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      _user = credential.user;

      // 첫 회원가입 시 기본 설정 저장
      await _saveDefaultSettings();
      await _saveUserProfile();
      
      // Migrate guest data if user was previously a guest
      if (wasGuest && guestData != null && _user != null) {
        await _migrateGuestDataToMember(_user!.uid, guestData);
        await _clearGuestData();
        debugPrint('✅ [AuthService] Guest data migrated successfully');
      }

      return true;
    }, errorContext: 'signUpWithEmail');

    return result ?? false;
  }

  Future<void> signOut() async {
    await executeWithLoading(() async {
      // Clear guest data if signing out from guest mode
      if (await isGuestUser) {
        await _clearGuestData();
      }
      
      // Clear persona-related local storage to prevent stale data
      await PreferencesManager.remove('matched_personas');
      debugPrint('🧹 Cleared matched personas from local storage on sign out');
      
      // Google 로그인도 로그아웃
      await _googleSignIn.signOut();
      await _auth.signOut();
      _user = null;
    }, errorContext: 'signOut', showError: false);
  }
  
  /// Clear all guest-related data from local storage
  Future<void> _clearGuestData() async {
    await PreferencesManager.remove(AppConstants.isGuestUserKey);
    await PreferencesManager.remove(AppConstants.guestSessionStartKey);
    await PreferencesManager.remove(AppConstants.guestMessageCountKey);
    await PreferencesManager.remove(AppConstants.guestChatHistoryKey);
    debugPrint('🧹 [AuthService] Guest data cleared');
  }
  
  /// Check if guest session has expired (24 hours)
  Future<bool> isGuestSessionExpired() async {
    if (!await isGuestUser) return false;
    
    final sessionStartStr = await PreferencesManager.getString(AppConstants.guestSessionStartKey);
    if (sessionStartStr == null) return true;
    
    try {
      final sessionStart = DateTime.parse(sessionStartStr);
      final now = DateTime.now();
      final difference = now.difference(sessionStart);
      
      return difference.inHours >= AppConstants.guestSessionDurationHours;
    } catch (e) {
      debugPrint('❌ [AuthService] Error checking guest session expiry: $e');
      return true;
    }
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
      'emotion_points':
          await PreferencesManager.getInt('emotion_points') ?? 100,
      'notifications_enabled':
          await PreferencesManager.getBool('notifications_enabled') ?? true,
      'sound_enabled':
          await PreferencesManager.getBool('sound_enabled') ?? true,
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
    final currentPoints =
        await PreferencesManager.getInt('emotion_points') ?? 0;
    final newPoints = (currentPoints - amount).clamp(0, 9999);
    await PreferencesManager.setInt('emotion_points', newPoints);
    notifyListeners();
  }

  Future<void> addEmotionPoints(int amount) async {
    final currentPoints =
        await PreferencesManager.getInt('emotion_points') ?? 0;
    final newPoints = (currentPoints + amount).clamp(0, 9999);
    await PreferencesManager.setInt('emotion_points', newPoints);
    notifyListeners();
  }

  /// 비밀번호 재설정 이메일 발송
  Future<bool> sendPasswordResetEmail(String email) async {
    final result = await executeWithLoading<bool>(() async {
      debugPrint('🔐 [AuthService] Sending password reset email to: $email');
      await _auth.sendPasswordResetEmail(email: email);
      debugPrint('✅ [AuthService] Password reset email sent successfully');
      return true;
    }, errorContext: 'sendPasswordResetEmail');

    return result ?? false;
  }

  /// 이메일 형식 검증
  bool isValidEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(email);
  }
  
  /// Save guest data before migration
  Future<Map<String, dynamic>?> _saveGuestDataForMigration() async {
    try {
      final guestData = await GuestConversationService.instance.getAllGuestDataForMigration();
      debugPrint('📦 [AuthService] Collected guest data for migration');
      return guestData;
    } catch (e) {
      debugPrint('❌ [AuthService] Error saving guest data: $e');
      return null;
    }
  }
  
  /// Collect guest data for migration
  Future<Map<String, dynamic>> _collectGuestData() async {
    try {
      // Get guest conversation data from local storage
      final conversationsJson = await PreferencesManager.getString(AppConstants.guestChatHistoryKey);
      if (conversationsJson != null && conversationsJson.isNotEmpty) {
        final conversations = json.decode(conversationsJson) as Map<String, dynamic>;
        return {'conversations': conversations};
      }
    } catch (e) {
      debugPrint('❌ [AuthService] Error collecting guest data: $e');
    }
    return {};
  }
  
  /// Migrate guest data to member account
  Future<void> _migrateGuestDataToMember(String userId, Map<String, dynamic> guestData) async {
    try {
      final conversations = guestData['conversations'] as Map<String, dynamic>?;
      if (conversations == null || conversations.isEmpty) {
        debugPrint('ℹ️ [AuthService] No guest conversations to migrate');
        return;
      }
      
      final batch = FirebaseFirestore.instance.batch();
      
      // Migrate each persona's conversation
      for (final entry in conversations.entries) {
        final personaId = entry.key;
        final conversationData = entry.value as Map<String, dynamic>;
        
        // Get messages
        final messages = conversationData['messages'] as List<dynamic>?;
        if (messages != null && messages.isNotEmpty) {
          // Save messages to Firebase
          for (final messageData in messages) {
            final message = Message.fromJson(messageData);
            final messageRef = FirebaseFirestore.instance
                .collection('users')
                .doc(userId)
                .collection('chats')
                .doc(personaId)
                .collection('messages')
                .doc(message.id);
            
            batch.set(messageRef, message.toJson());
          }
        }
        
        // Migrate memories to Firebase (if you have a memories collection)
        final memories = conversationData['memories'] as List<dynamic>?;
        if (memories != null && memories.isNotEmpty) {
          for (final memory in memories) {
            final memoryRef = FirebaseFirestore.instance
                .collection('users')
                .doc(userId)
                .collection('conversation_memories')
                .doc();
            
            batch.set(memoryRef, {
              ...memory,
              'userId': userId,
              'personaId': personaId,
            });
          }
        }
        
        // Migrate relationship data
        final relationship = conversationData['relationship'] as Map<String, dynamic>?;
        if (relationship != null) {
          final relationshipRef = FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .collection('relationships')
              .doc(personaId);
          
          batch.set(relationshipRef, {
            ...relationship,
            'migratedFromGuest': true,
            'migrationDate': FieldValue.serverTimestamp(),
          });
        }
      }
      
      // Commit all changes
      await batch.commit();
      debugPrint('✅ [AuthService] Guest data migrated to Firebase for ${conversations.length} personas');
      
      // Clear local guest data after successful migration
      await GuestConversationService.instance.clearAllGuestConversations();
      
    } catch (e) {
      debugPrint('❌ [AuthService] Error migrating guest data: $e');
      // Don't throw - allow signup to continue even if migration fails
    }
  }
}
