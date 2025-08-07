import 'dart:async';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'purchase_service.dart';

/// 테스트용 Mock 구매 서비스
/// 실제 Google Play Services가 없어도 UI와 플로우를 테스트할 수 있습니다
class MockPurchaseService extends PurchaseService {
  bool _mockIsAvailable = true;
  bool _mockIsPurchasePending = false;

  // Mock 사용자 데이터
  int _mockHearts = 10; // 초기 하트 10개

  // Mock 상품 데이터
  final List<ProductDetails> _mockProducts = [
    _createMockProduct(ProductIds.hearts10, '하트 10개', '₩1,100'),
    _createMockProduct(ProductIds.hearts30, '하트 30개', '₩3,300'),
    _createMockProduct(ProductIds.hearts50, '하트 50개', '₩5,500'),
  ];

  @override
  bool get isAvailable => _mockIsAvailable;

  @override
  bool get isPurchasePending => _mockIsPurchasePending;

  @override
  List<ProductDetails> get products => _mockProducts;

  @override
  int get hearts => _mockHearts;

  @override
  Future<void> loadProducts() async {
    debugPrint('🧪 MockPurchaseService: Loading mock products...');

    // 로딩 시뮬레이션
    await Future.delayed(const Duration(seconds: 1));

    // 상품 로드 완료
    notifyListeners();
    debugPrint(
        '✅ MockPurchaseService: Loaded ${_mockProducts.length} mock products');
  }

  @override
  Future<bool> buyProduct(ProductDetails productDetails) async {
    debugPrint(
        '🧪 MockPurchaseService: Attempting to buy ${productDetails.id}');

    _mockIsPurchasePending = true;
    notifyListeners();

    // 구매 프로세스 시뮬레이션
    await Future.delayed(const Duration(seconds: 2));

    // 구매 성공 시뮬레이션
    if (ProductIds.consumables.contains(productDetails.id)) {
      // 하트 구매
      int amount = 0;
      switch (productDetails.id) {
        case ProductIds.hearts10:
          amount = 10;
          break;
        case ProductIds.hearts30:
          amount = 30;
          break;
        case ProductIds.hearts50:
          amount = 50;
          break;
      }

      // Mock 하트 지급
      await _mockGrantHearts(amount);
      debugPrint('✅ MockPurchaseService: Granted $amount hearts');
    }

    _mockIsPurchasePending = false;
    notifyListeners();

    return true;
  }

  @override
  Future<void> restorePurchases() async {
    debugPrint('🧪 MockPurchaseService: Restoring purchases...');

    // 복원 시뮬레이션
    await Future.delayed(const Duration(seconds: 1));

    // Mock 복원 완료
    debugPrint('✅ MockPurchaseService: Purchase restoration complete');
  }

  // Mock 하트 지급
  Future<void> _mockGrantHearts(int amount) async {
    debugPrint('💝 MockPurchaseService: Mock granting $amount hearts');

    _mockHearts += amount;
    notifyListeners();
  }

  @override
  Future<bool> useHearts(int amount) async {
    if (_mockHearts < amount) {
      debugPrint('❌ Not enough hearts: $_mockHearts < $amount');
      return false;
    }

    _mockHearts -= amount;
    notifyListeners();

    debugPrint(
        '✅ MockPurchaseService: Used $amount hearts. Remaining: $_mockHearts');
    return true;
  }

  // Mock ProductDetails 생성
  static ProductDetails _createMockProduct(
      String id, String title, String price) {
    return ProductDetails(
      id: id,
      title: title,
      description: '$title 상품입니다',
      price: price,
      rawPrice: 0.0,
      currencyCode: 'KRW',
    );
  }

  // 테스트 모드 설정
  void setTestMode(bool enabled) {
    _mockIsAvailable = enabled;
    notifyListeners();
  }

  // 구매 진행 상태 시뮬레이션
  void simulatePurchaseInProgress() {
    _mockIsPurchasePending = true;
    notifyListeners();

    // 3초 후 자동으로 완료
    Timer(const Duration(seconds: 3), () {
      _mockIsPurchasePending = false;
      notifyListeners();
    });
  }
}
