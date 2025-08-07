import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../base/base_service.dart';

/// 인앱 결제 상품 ID
class ProductIds {
  // 하트 상품 (소모성)
  static const String hearts10 = 'com.nohbrother.teamsona.chatapp.hearts_10';
  static const String hearts30 = 'com.nohbrother.teamsona.chatapp.hearts_30';
  static const String hearts50 = 'com.nohbrother.teamsona.chatapp.hearts_50';

  // 소모성 상품 목록
  static const List<String> consumables = [
    hearts10,
    hearts30,
    hearts50,
  ];

  // 전체 상품 목록
  static List<String> get allProducts => consumables;
}

/// 구매 서비스
class PurchaseService extends BaseService {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 상태 변수들
  bool _isAvailable = false;
  bool _isPurchasePending = false;
  String? _queryProductError;
  List<ProductDetails> _products = [];
  List<PurchaseDetails> _purchases = [];
  StreamSubscription<List<PurchaseDetails>>? _subscription;
  StreamSubscription<User?>? _authSubscription;

  // Getters
  bool get isAvailable => _isAvailable;
  bool get isPurchasePending => _isPurchasePending;
  String? get queryProductError => _queryProductError;
  List<ProductDetails> get products => _products;
  List<PurchaseDetails> get purchases => _purchases;

  // 사용자 구매 상태
  int _hearts = 0;

  int get hearts => _hearts;

  PurchaseService() {
    _initialize();
  }

  /// 초기화
  Future<void> _initialize() async {
    try {
      // 스토어 연결 가능 여부 확인
      _isAvailable = await _inAppPurchase.isAvailable();

      if (!_isAvailable) {
        debugPrint('❌ In-App Purchase is not available');
        _queryProductError =
            'Google Play Services를 사용할 수 없습니다. 기기에 Google Play가 설치되어 있고 로그인되어 있는지 확인하세요.';
        notifyListeners();
        return;
      }
    } catch (e) {
      debugPrint('❌ Error checking store availability: $e');
      _isAvailable = false;
      _queryProductError = 'Google Play Services 연결 실패: $e';
      notifyListeners();
      return;
    }

    // 구매 업데이트 리스너 설정
    final purchaseUpdated = _inAppPurchase.purchaseStream;
    _subscription = purchaseUpdated.listen(
      _onPurchaseUpdate,
      onDone: () {
        _subscription?.cancel();
      },
      onError: (error) {
        debugPrint('❌ Purchase stream error: $error');
      },
    );

    // Auth 상태 변경 리스너 설정
    _authSubscription = _auth.authStateChanges().listen((user) async {
      debugPrint(
          '💰 [PurchaseService] Auth state changed: ${user?.uid ?? "logged out"}');
      if (user != null) {
        debugPrint(
            '💰 [PurchaseService] User logged in, waiting before loading purchase data...');
        // 신규 가입 시 user document 생성 완료를 위한 짧은 대기
        await Future.delayed(const Duration(milliseconds: 500));
        debugPrint('💰 [PurchaseService] Loading purchase data after delay...');
        _loadUserPurchaseData();
      } else {
        // 로그아웃 시 상태 초기화
        debugPrint('💰 [PurchaseService] User logged out, resetting state');
        _hearts = 0;
        notifyListeners();
      }
    });

    // 상품 정보 로드
    await loadProducts();

    // 기존 구매 복원
    await restorePurchases();

    // 사용자 데이터 로드
    _loadUserPurchaseData();
  }

  /// 상품 정보 로드
  Future<void> loadProducts() async {
    if (!_isAvailable) return;

    try {
      final ProductDetailsResponse response =
          await _inAppPurchase.queryProductDetails(
        ProductIds.allProducts.toSet(),
      );

      if (response.notFoundIDs.isNotEmpty) {
        debugPrint('⚠️ Products not found: ${response.notFoundIDs}');
      }

      if (response.error != null) {
        _queryProductError = response.error!.message;
        debugPrint('❌ Query product error: $_queryProductError');
        notifyListeners();
        return;
      }

      _products = response.productDetails;
      _products.sort((a, b) => a.price.compareTo(b.price));

      debugPrint('✅ Loaded ${_products.length} products');
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Error loading products: $e');
      _queryProductError = e.toString();
      notifyListeners();
    }
  }

  /// 구매 처리
  Future<bool> buyProduct(ProductDetails productDetails) async {
    if (_isPurchasePending) {
      debugPrint('⚠️ Purchase already pending');
      return false;
    }

    final user = _auth.currentUser;
    if (user == null) {
      debugPrint('❌ User not logged in');
      return false;
    }

    _isPurchasePending = true;
    notifyListeners();

    // 모든 상품은 소모품으로 처리
    final PurchaseParam purchaseParam = PurchaseParam(
      productDetails: productDetails,
      applicationUserName: user.uid,
    );

    bool success = false;

    try {
      // 소모성 상품 구매
      success =
          await _inAppPurchase.buyConsumable(purchaseParam: purchaseParam);

      // 구매 시작 실패 시 pending 상태 리셋
      if (!success) {
        _isPurchasePending = false;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('❌ Purchase error: $e');
      _isPurchasePending = false;
      notifyListeners();
    }

    return success;
  }

  /// 구매 업데이트 처리
  void _onPurchaseUpdate(List<PurchaseDetails> purchaseDetailsList) {
    _purchases = purchaseDetailsList;

    for (final purchase in purchaseDetailsList) {
      debugPrint(
          '🛒 Purchase update: ${purchase.productID} - ${purchase.status}');

      if (purchase.status == PurchaseStatus.pending) {
        _isPurchasePending = true;
      } else {
        if (purchase.status == PurchaseStatus.error) {
          debugPrint('❌ Purchase error: ${purchase.error}');
          _isPurchasePending = false;
        } else if (purchase.status == PurchaseStatus.purchased ||
            purchase.status == PurchaseStatus.restored) {
          // 구매 성공 - 서버 검증 및 처리
          _verifyAndDeliverProduct(purchase);
        }

        if (purchase.pendingCompletePurchase) {
          _inAppPurchase.completePurchase(purchase);
        }
      }
    }

    notifyListeners();
  }

  /// 구매 검증 및 상품 지급
  Future<void> _verifyAndDeliverProduct(PurchaseDetails purchase) async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      // Firestore에 구매 기록 저장
      final purchaseDoc = await _firestore.collection('purchases').add({
        'userId': user.uid,
        'productId': purchase.productID,
        'purchaseId': purchase.purchaseID,
        'transactionDate': FieldValue.serverTimestamp(),
        'status': purchase.status.toString(),
        'platform': Platform.isIOS ? 'ios' : 'android',
        'verificationData': purchase.verificationData.serverVerificationData,
      });

      debugPrint('✅ Purchase recorded: ${purchaseDoc.id}');

      // 상품별 처리
      await _deliverProduct(purchase.productID);

      _isPurchasePending = false;

      // 구매 완료 후 데이터 새로고침
      debugPrint(
          '💰 [PurchaseService] Purchase completed, refreshing user data...');
      await _loadUserPurchaseData();

      notifyListeners();
    } catch (e) {
      debugPrint('❌ Error verifying purchase: $e');
      _isPurchasePending = false;
      notifyListeners();
    }
  }

  /// 상품 지급
  Future<void> _deliverProduct(String productId) async {
    final user = _auth.currentUser;
    if (user == null) return;

    debugPrint('💰 [PurchaseService] Delivering product: $productId');

    switch (productId) {
      case ProductIds.hearts10:
        debugPrint('💰 [PurchaseService] Delivering 10 hearts');
        await _grantHearts(10);
        break;
      case ProductIds.hearts30:
        debugPrint('💰 [PurchaseService] Delivering 30 hearts');
        await _grantHearts(30);
        break;
      case ProductIds.hearts50:
        debugPrint('💰 [PurchaseService] Delivering 50 hearts');
        await _grantHearts(50);
        break;
      default:
        debugPrint('⚠️ [PurchaseService] Unknown product ID: $productId');
    }
  }

  /// 하트 지급
  Future<void> _grantHearts(int amount) async {
    final user = _auth.currentUser;
    if (user == null) return;

    debugPrint(
        '💰 [PurchaseService] Granting $amount hearts to user: ${user.uid}');

    try {
      // 트랜잭션을 사용하여 원자적으로 처리
      await _firestore.runTransaction((transaction) async {
        final userDoc =
            await transaction.get(_firestore.collection('users').doc(user.uid));

        if (!userDoc.exists) {
          debugPrint(
              '❌ [PurchaseService] User document does not exist during heart grant');
          throw Exception('User document not found');
        }

        final currentHearts = userDoc.data()?['hearts'] ?? 0;
        debugPrint(
            '💰 [PurchaseService] Current hearts: $currentHearts, Adding: $amount');

        transaction.update(userDoc.reference, {
          'hearts': currentHearts + amount,
          'updatedAt': FieldValue.serverTimestamp(),
        });

        debugPrint(
            '💰 [PurchaseService] Transaction completed - New hearts: ${currentHearts + amount}');
      });

      debugPrint('✅ Hearts granted successfully: $amount');
    } catch (e) {
      debugPrint('❌ [PurchaseService] Error granting hearts: $e');
      rethrow;
    }
  }

  /// 구매 복원
  Future<void> restorePurchases() async {
    if (!_isAvailable) return;

    try {
      await _inAppPurchase.restorePurchases();
      debugPrint('✅ Restore purchases initiated');
    } catch (e) {
      debugPrint('❌ Error restoring purchases: $e');
    }
  }

  /// 사용자 구매 데이터 로드
  Future<void> _loadUserPurchaseData() async {
    final user = _auth.currentUser;
    if (user == null) {
      debugPrint(
          '💰 [PurchaseService] Cannot load purchase data - no user logged in');
      return;
    }

    debugPrint(
        '💰 [PurchaseService] Loading purchase data for user: ${user.uid}');

    try {
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      debugPrint(
          '💰 [PurchaseService] User document exists: ${userDoc.exists}');

      if (userDoc.exists) {
        final data = userDoc.data()!;

        final previousHearts = _hearts;
        _hearts = data['hearts'] ?? 0;

        debugPrint(
            '💰 [PurchaseService] Hearts loaded - Previous: $previousHearts, Current: $_hearts');
        debugPrint(
            '💰 [PurchaseService] Raw hearts data from Firestore: ${data['hearts']}');

        debugPrint(
            '💰 [PurchaseService] Purchase data loaded successfully - Hearts: $_hearts');
        notifyListeners();
      } else {
        debugPrint('⚠️ [PurchaseService] User document does not exist yet');
      }
    } catch (e) {
      debugPrint('❌ [PurchaseService] Error loading user purchase data: $e');
    }
  }

  /// 하트 사용
  Future<bool> useHearts(int amount) async {
    final user = _auth.currentUser;
    if (user == null) {
      debugPrint('❌ Cannot use hearts: User not logged in');
      return false;
    }

    if (_hearts < amount) {
      debugPrint('❌ Not enough hearts: $_hearts < $amount');
      return false;
    }

    try {
      // 먼저 로컬 상태 업데이트
      final previousHearts = _hearts;
      _hearts -= amount;
      notifyListeners();

      // Firebase 업데이트
      await _firestore.collection('users').doc(user.uid).update({
        'hearts': FieldValue.increment(-amount),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      debugPrint('✅ Hearts used: $amount (Remaining: $_hearts)');

      // Firebase에서 최신 데이터 다시 로드하여 동기화
      await _loadUserPurchaseData();

      return true;
    } catch (e) {
      debugPrint('❌ Error using hearts: $e');
      // 에러 발생 시 로컬 상태 롤백
      _hearts += amount;
      notifyListeners();
      return false;
    }
  }

  /// 구매 대기 상태 리셋
  void resetPurchasePending() {
    if (_isPurchasePending) {
      debugPrint('🔄 Resetting purchase pending state');
      _isPurchasePending = false;
      notifyListeners();
    }
  }

  /// 사용자 구매 데이터 강제 새로고침
  Future<void> refreshUserData() async {
    debugPrint('💰 [PurchaseService] Force refreshing user purchase data...');
    await _loadUserPurchaseData();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _authSubscription?.cancel();
    super.dispose();
  }
}
