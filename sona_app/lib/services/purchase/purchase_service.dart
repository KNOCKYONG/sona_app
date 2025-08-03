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
  
  // 프리미엄 구독 상품
  static const String premium1Month = 'com.nohbrother.teamsona.chatapp.premium1';
  static const String premium3Months = 'com.nohbrother.teamsona.chatapp.premium_3months';
  static const String premium6Months = 'com.nohbrother.teamsona.chatapp.premium_6months';
  
  // 구독 상품 목록
  static const List<String> subscriptions = [
    premium1Month,
    // premium3Months,  // Google Play Console에 추가 후 활성화
    // premium6Months,  // Google Play Console에 추가 후 활성화
  ];
  
  // 소모성 상품 목록
  static const List<String> consumables = [
    hearts10,
    hearts30,
    hearts50,
  ];
  
  // 전체 상품 목록
  static List<String> get allProducts => [...subscriptions, ...consumables];
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
  
  // 사용자 구독 상태
  bool _isPremium = false;
  DateTime? _premiumExpiryDate;
  int _hearts = 0;
  
  bool get isPremium => _isPremium;
  DateTime? get premiumExpiryDate => _premiumExpiryDate;
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
        _queryProductError = 'Google Play Services를 사용할 수 없습니다. 기기에 Google Play가 설치되어 있고 로그인되어 있는지 확인하세요.';
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
    _authSubscription = _auth.authStateChanges().listen((user) {
      debugPrint('🔄 Auth state changed: ${user?.uid ?? "logged out"}');
      if (user != null) {
        _loadUserPurchaseData();
      } else {
        // 로그아웃 시 상태 초기화
        _isPremium = false;
        _premiumExpiryDate = null;
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
      final ProductDetailsResponse response = await _inAppPurchase.queryProductDetails(
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
    
    // 구독 상품인지 확인
    final isSubscription = ProductIds.subscriptions.contains(productDetails.id);
    
    final PurchaseParam purchaseParam = PurchaseParam(
      productDetails: productDetails,
      applicationUserName: user.uid,
    );
    
    bool success = false;
    
    try {
      if (isSubscription) {
        // 구독 상품 구매
        success = await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
      } else {
        // 소모성 상품 구매
        success = await _inAppPurchase.buyConsumable(purchaseParam: purchaseParam);
      }
      
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
      debugPrint('🛒 Purchase update: ${purchase.productID} - ${purchase.status}');
      
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
    
    final userRef = _firestore.collection('users').doc(user.uid);
    
    switch (productId) {
      case ProductIds.premium1Month:
        await _grantPremium(30);
        break;
      case ProductIds.premium3Months:
        await _grantPremium(90);
        break;
      case ProductIds.premium6Months:
        await _grantPremium(180);
        break;
      case ProductIds.hearts10:
        await _grantHearts(10);
        break;
      case ProductIds.hearts30:
        await _grantHearts(30);
        break;
      case ProductIds.hearts50:
        await _grantHearts(50);
        break;
    }
    
    // 사용자 데이터 다시 로드
    await _loadUserPurchaseData();
  }
  
  /// 프리미엄 권한 부여
  Future<void> _grantPremium(int days) async {
    final user = _auth.currentUser;
    if (user == null) return;
    
    final now = DateTime.now();
    final currentExpiry = _premiumExpiryDate;
    
    // 기존 만료일이 있고 아직 유효하면 연장, 아니면 현재부터 시작
    final startDate = (currentExpiry != null && currentExpiry.isAfter(now)) 
        ? currentExpiry 
        : now;
    
    final newExpiry = startDate.add(Duration(days: days));
    
    await _firestore.collection('users').doc(user.uid).update({
      'isPremium': true,
      'premiumExpiryDate': Timestamp.fromDate(newExpiry),
      'updatedAt': FieldValue.serverTimestamp(),
    });
    
    debugPrint('✅ Premium granted until: $newExpiry');
  }
  
  /// 하트 지급
  Future<void> _grantHearts(int amount) async {
    final user = _auth.currentUser;
    if (user == null) return;
    
    await _firestore.collection('users').doc(user.uid).update({
      'hearts': FieldValue.increment(amount),
      'updatedAt': FieldValue.serverTimestamp(),
    });
    
    debugPrint('✅ Hearts granted: $amount');
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
    if (user == null) return;
    
    try {
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        final data = userDoc.data()!;
        
        _isPremium = data['isPremium'] ?? false;
        _hearts = data['hearts'] ?? 0;
        
        if (data['premiumExpiryDate'] != null) {
          _premiumExpiryDate = (data['premiumExpiryDate'] as Timestamp).toDate();
          
          // 만료 확인
          if (_premiumExpiryDate!.isBefore(DateTime.now())) {
            _isPremium = false;
            _premiumExpiryDate = null;
            
            // 만료 상태 업데이트
            await _firestore.collection('users').doc(user.uid).update({
              'isPremium': false,
              'updatedAt': FieldValue.serverTimestamp(),
            });
          }
        }
        
        notifyListeners();
      }
    } catch (e) {
      debugPrint('❌ Error loading user purchase data: $e');
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
  
  @override
  void dispose() {
    _subscription?.cancel();
    _authSubscription?.cancel();
    super.dispose();
  }
}