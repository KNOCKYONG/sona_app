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

class _PurchaseScreenState extends State<PurchaseScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
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
          icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).iconTheme.color),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<PurchaseService>(
        builder: (context, purchaseService, child) {
          if (!purchaseService.isAvailable) {
            return Center(
              child: Text(
                AppLocalizations.of(context)!.storeNotAvailable,
                style: TextStyle(fontSize: 16, color: Theme.of(context).textTheme.bodyLarge?.color),
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatusItem(
                      icon: Icons.favorite,
                      label: localizations.hearts,
                      value: '${purchaseService.hearts}',
                    ),
                    Container(
                      height: 40,
                      width: 1,
                      color: Colors.white.withOpacity(0.3),
                    ),
                    _buildStatusItem(
                      icon: Icons.star,
                      label: localizations.premium,
                      value: purchaseService.isPremium 
                          ? _formatExpiryDate(purchaseService.premiumExpiryDate!)
                          : localizations.notSubscribed,
                    ),
                  ],
                ),
              ),
              
              // 탭 바
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Theme.of(context).dividerColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: Colors.white,
                  unselectedLabelColor: Theme.of(context).textTheme.bodySmall?.color,
                  labelStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  labelPadding: EdgeInsets.zero,
                  tabs: [
                    Tab(
                      height: 48,
                      child: Center(
                        child: Text(localizations.hearts),
                      ),
                    ),
                    Tab(
                      height: 48,
                      child: Center(
                        child: Text(localizations.premium),
                      ),
                    ),
                  ],
                ),
              ),
              
              // 탭 뷰
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // 하트 상품
                    _buildHeartProducts(purchaseService),
                    // 프리미엄 상품
                    _buildPremiumProducts(purchaseService),
                  ],
                ),
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
            CircularProgressIndicator(color: Theme.of(context).colorScheme.primary),
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
  
  Widget _buildPremiumProducts(PurchaseService purchaseService) {
    final premiumProducts = purchaseService.products
        .where((p) => ProductIds.subscriptions.contains(p.id))
        .toList();
    
    if (premiumProducts.isEmpty) {
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
            CircularProgressIndicator(color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 16),
            Text(AppLocalizations.of(context)!.loadingProducts),
          ],
        ),
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: premiumProducts.length,
      itemBuilder: (context, index) {
        final product = premiumProducts[index];
        return _buildProductCard(
          product: product,
          icon: Icons.star,
          iconColor: Colors.amber,
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
    
    // Google Play Console의 상품 ID와 매칭
    if (product.id == ProductIds.hearts10) {
      displayName = localizations.hearts10;
      description = localizations.heartDescription;
    } else if (product.id == ProductIds.hearts30) {
      displayName = localizations.hearts30;
      description = localizations.heartDescription;
    } else if (product.id == ProductIds.hearts50) {
      displayName = localizations.hearts50;
      description = localizations.heartDescription;
    } else if (product.id.contains('premium')) {
      if (product.id.contains('1month')) {
        displayName = localizations.premium1Month;
        description = localizations.premiumDescription;
      } else if (product.id.contains('3months')) {
        displayName = localizations.premium3Months;
        description = localizations.premiumDescription20Off;
      } else if (product.id.contains('6months')) {
        displayName = localizations.premium6Months;
        description = localizations.premiumDescription30Off;
      }
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
                      Text(
                        displayName,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      product.price,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    if (product.id.contains('3months') || product.id.contains('6months'))
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          product.id.contains('3months') ? localizations.discount20 : localizations.discount30,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
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
        content: Text(AppLocalizations.of(context)!.purchaseConfirmMessage(product.title, product.price)),
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
  
  String _formatExpiryDate(DateTime date) {
    final remaining = date.difference(DateTime.now()).inDays;
    if (remaining > 0) {
      return AppLocalizations.of(context)!.daysRemaining(remaining);
    } else {
      return AppLocalizations.of(context)!.expired;
    }
  }
}