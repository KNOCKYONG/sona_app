import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import '../services/purchase/purchase_service.dart';
import '../theme/app_theme.dart';
import '../l10n/app_localizations.dart';

class PurchaseScreen extends StatefulWidget {
  const PurchaseScreen({super.key});

  @override
  State<PurchaseScreen> createState() => _PurchaseScreenState();
}

class _PurchaseScreenState extends State<PurchaseScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // 구매 대기 상태 리셋
    final purchaseService =
        Provider.of<PurchaseService>(context, listen: false);
    purchaseService.resetPurchasePending();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        title: Text(
          localizations.store,
          style: TextStyle(
            color: Theme.of(context).textTheme.headlineSmall?.color,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,
              color: Theme.of(context).iconTheme.color),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<PurchaseService>(
        builder: (context, purchaseService, child) {
          if (!purchaseService.isAvailable) {
            return Center(
              child: Text(
                AppLocalizations.of(context)!.storeNotAvailable,
                style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).textTheme.bodyLarge?.color),
              ),
            );
          }

          return Column(
            children: [
              // 현재 보유 정보
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFFFF6B9D),
                      const Color(0xFFFECA57),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFF6B9D).withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Center(
                  child: _buildStatusItem(
                    icon: Icons.favorite,
                    label: localizations.hearts,
                    value: '${purchaseService.hearts}',
                  ),
                ),
              ),

              // 하트 상품 목록
              Expanded(
                child: _buildHeartProducts(purchaseService),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatusItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 28),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildHeartProducts(PurchaseService purchaseService) {
    final heartProducts = purchaseService.products
        .where((p) => ProductIds.consumables.contains(p.id))
        .toList();

    // 디버그 정보 출력
    debugPrint('🔍 Store available: ${purchaseService.isAvailable}');
    debugPrint('🔍 All products: ${purchaseService.products.length}');
    debugPrint('🔍 Heart products: ${heartProducts.length}');
    debugPrint('🔍 Query error: ${purchaseService.queryProductError}');

    if (heartProducts.isEmpty) {
      // 에러 메시지가 있으면 표시
      if (purchaseService.queryProductError != null) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Theme.of(context).colorScheme.error,
                ),
                const SizedBox(height: 16),
                Text(
                  AppLocalizations.of(context)!.storeConnectionError,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  purchaseService.queryProductError!,
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    await purchaseService.loadProducts();
                  },
                  child: Text(AppLocalizations.of(context)!.retry),
                ),
              ],
            ),
          ),
        );
      }

      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 16),
            Text(AppLocalizations.of(context)!.loadingProducts),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: heartProducts.length,
      itemBuilder: (context, index) {
        final product = heartProducts[index];
        return _buildProductCard(
          product: product,
          icon: Icons.favorite,
          iconColor: Colors.pink,
          onTap: () => _handlePurchase(context, purchaseService, product),
        );
      },
    );
  }

  Widget _buildProductCard({
    required ProductDetails product,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    final localizations = AppLocalizations.of(context)!;

    // 상품명에서 정보 추출
    String displayName = product.title;
    String? description;
    String? originalPrice;
    String? discountLabel;
    bool hasDiscount = false;

    // Google Play Console의 상품 ID와 매칭
    // 할인율은 원가가 100원 단위로 떨어지도록 조정
    if (product.id == ProductIds.hearts10) {
      displayName = localizations.hearts10;
      description = localizations.heartDescription;
      // 9% 할인 적용 (₩1,100 → ₩1,200)
      originalPrice = _calculateOriginalPrice(product.price, 0.0833);
      discountLabel = _getDiscountLabel(0.08);
      hasDiscount = true;
    } else if (product.id == ProductIds.hearts30) {
      displayName = localizations.hearts30;
      description = localizations.heartDescription;
      // 12% 할인 적용 (₩2,900 → ₩3,300)
      originalPrice = _calculateOriginalPrice(product.price, 0.121);
      discountLabel = _getDiscountLabel(0.12);
      hasDiscount = true;
    } else if (product.id == ProductIds.hearts50) {
      displayName = localizations.hearts50;
      description = localizations.heartDescription;
      // 29% 할인 적용 (₩3,900 → ₩5,500)
      originalPrice = _calculateOriginalPrice(product.price, 0.291);
      discountLabel = _getDiscountLabel(0.29);
      hasDiscount = true;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        elevation: 2,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor, size: 32),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              displayName,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).textTheme.bodyLarge?.color,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (hasDiscount) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: Colors.red.withOpacity(0.3),
                                ),
                              ),
                              child: Text(
                                discountLabel ?? '',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      if (description != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          description,
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).textTheme.bodySmall?.color,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (hasDiscount) 
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        originalPrice ?? '',
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).textTheme.bodySmall?.color,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        product.price,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  )
                else
                  Text(
                    product.price,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handlePurchase(
    BuildContext context,
    PurchaseService purchaseService,
    ProductDetails product,
  ) async {
    if (purchaseService.isPurchasePending) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.purchasePending),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // 구매 확인 다이얼로그
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(AppLocalizations.of(context)!.purchaseConfirm),
        content: Text(AppLocalizations.of(context)!
            .purchaseConfirmMessage(product.title, product.price, product.description ?? '')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              AppLocalizations.of(context)!.purchaseButton,
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    // 구매 진행
    final success = await purchaseService.buyProduct(product);

    if (!success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.purchaseFailed),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // 원가격 계산 헬퍼 메서드
  String _calculateOriginalPrice(String currentPrice, double discountPercentage) {
    // 현재 가격에서 통화 기호와 숫자 분리
    final priceData = _parsePriceString(currentPrice);
    if (priceData == null) return currentPrice;
    
    final currency = priceData['currency'] as String;
    final price = priceData['amount'] as double;
    
    // 원가격 계산 (할인율 기반)
    // 예: 30% 할인이면 현재가격 = 원가 * 0.7, 원가 = 현재가격 / 0.7
    var originalPrice = price / (1 - discountPercentage);
    
    // 100원 단위로 반올림 (한국 원화의 경우)
    if (currency.contains('₩') || currency == 'KRW') {
      originalPrice = (originalPrice / 100).round() * 100.0;
    }
    
    // 포맷팅
    return _formatPriceWithCurrency(originalPrice, currency);
  }
  
  // 할인 라벨 생성 헬퍼 메서드
  String _getDiscountLabel(double discountPercentage) {
    final percentage = (discountPercentage * 100).round();
    final locale = Localizations.localeOf(context);
    final isKorean = locale.languageCode == 'ko';
    
    return isKorean ? '$percentage% 할인' : '$percentage% OFF';
  }
  
  // 가격 문자열 파싱 헬퍼 메서드
  Map<String, dynamic>? _parsePriceString(String priceString) {
    // 통화 기호 패턴
    final currencyPattern = RegExp(r'([₩$€£¥]|KRW|USD|EUR|GBP|JPY)');
    final currencyMatch = currencyPattern.firstMatch(priceString);
    final currency = currencyMatch?.group(0) ?? '';
    
    // 숫자 추출 (소수점과 쉼표 처리)
    final numberPattern = RegExp(r'[\d,]+\.?\d*');
    final numberMatch = numberPattern.firstMatch(priceString);
    if (numberMatch == null) return null;
    
    final numberString = numberMatch.group(0)!.replaceAll(',', '');
    final amount = double.tryParse(numberString);
    if (amount == null) return null;
    
    return {
      'currency': currency,
      'amount': amount,
    };
  }
  
  // 통화와 함께 가격 포맷팅
  String _formatPriceWithCurrency(double amount, String currency) {
    final formattedAmount = _formatPrice(amount);
    
    // 통화별 포맷
    if (currency.contains('\$') || currency == 'USD') {
      return '\$$formattedAmount';
    } else if (currency.contains('₩') || currency == 'KRW') {
      return '₩$formattedAmount';
    } else if (currency.contains('€') || currency == 'EUR') {
      return '€$formattedAmount';
    } else if (currency.contains('£') || currency == 'GBP') {
      return '£$formattedAmount';
    } else if (currency.contains('¥') || currency == 'JPY') {
      return '¥$formattedAmount';
    } else {
      // 기본값 (통화 기호가 없으면 원화로 가정)
      return '₩$formattedAmount';
    }
  }
  
  // 가격 포맷팅 헬퍼 메서드
  String _formatPrice(double price) {
    if (price >= 1000) {
      // 천 단위 구분
      final thousands = (price / 1000).floor();
      final remainder = (price % 1000).round();
      if (remainder == 0) {
        return '$thousands,000';
      } else {
        return '$thousands,${remainder.toString().padLeft(3, '0')}';
      }
    }
    return price.toStringAsFixed(0);
  }
}
