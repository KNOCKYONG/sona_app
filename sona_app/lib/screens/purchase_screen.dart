import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import '../services/purchase_service.dart';
import '../theme/app_theme.dart';

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
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          '스토어',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<PurchaseService>(
        builder: (context, purchaseService, child) {
          if (!purchaseService.isAvailable) {
            return const Center(
              child: Text(
                '스토어를 사용할 수 없습니다',
                style: TextStyle(fontSize: 16, color: Colors.grey),
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
                      label: '하트',
                      value: '${purchaseService.hearts}',
                    ),
                    Container(
                      height: 40,
                      width: 1,
                      color: Colors.white.withOpacity(0.3),
                    ),
                    _buildStatusItem(
                      icon: Icons.star,
                      label: '프리미엄',
                      value: purchaseService.isPremium 
                          ? _formatExpiryDate(purchaseService.premiumExpiryDate!)
                          : '미가입',
                    ),
                  ],
                ),
              ),
              
              // 탭 바
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: AppTheme.primaryColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.grey[600],
                  labelStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  tabs: const [
                    Tab(text: '하트'),
                    Tab(text: '프리미엄'),
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
    
    if (heartProducts.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: AppTheme.primaryColor),
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
      return const Center(
        child: CircularProgressIndicator(color: AppTheme.primaryColor),
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
    // 상품명에서 정보 추출
    String displayName = product.title;
    String? description;
    
    if (product.id.contains('hearts')) {
      final count = product.id.split('_').last;
      displayName = '하트 $count개';
      description = '매칭과 채팅에 사용할 수 있는 하트';
    } else if (product.id.contains('premium')) {
      if (product.id.contains('1month')) {
        displayName = '프리미엄 1개월';
        description = '무제한 매칭, 광고 제거';
      } else if (product.id.contains('3months')) {
        displayName = '프리미엄 3개월';
        description = '무제한 매칭, 광고 제거 (20% 할인)';
      } else if (product.id.contains('6months')) {
        displayName = '프리미엄 6개월';
        description = '무제한 매칭, 광고 제거 (30% 할인)';
      }
    }
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: Colors.white,
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
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (description != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          description,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
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
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
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
                          product.id.contains('3months') ? '20% 할인' : '30% 할인',
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
        const SnackBar(
          content: Text('이미 구매가 진행 중입니다'),
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
        title: const Text('구매 확인'),
        content: Text('${product.title}을(를) ${product.price}에 구매하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              '구매',
              style: TextStyle(color: AppTheme.primaryColor),
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
        const SnackBar(
          content: Text('구매를 시작할 수 없습니다'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  
  String _formatExpiryDate(DateTime date) {
    final remaining = date.difference(DateTime.now()).inDays;
    if (remaining > 0) {
      return '$remaining일 남음';
    } else {
      return '만료됨';
    }
  }
}