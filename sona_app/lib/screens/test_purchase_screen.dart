import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/purchase_service.dart';
import '../services/auth_service.dart';

class TestPurchaseScreen extends StatelessWidget {
  const TestPurchaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('구매 서비스 테스트'),
        centerTitle: true,
      ),
      body: Consumer2<PurchaseService, AuthService>(
        builder: (context, purchaseService, authService, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 인증 상태
                _buildSection(
                  '인증 상태',
                  [
                    _buildInfoRow('로그인 여부', authService.isAuthenticated ? '로그인됨' : '로그인 안됨'),
                    if (authService.user != null)
                      _buildInfoRow('사용자 UID', authService.user!.uid),
                  ],
                ),
                
                const SizedBox(height: 20),
                
                // 스토어 상태
                _buildSection(
                  '스토어 상태',
                  [
                    _buildInfoRow('스토어 사용 가능', purchaseService.isAvailable ? '예' : '아니오'),
                    _buildInfoRow('구매 진행 중', purchaseService.isPurchasePending ? '예' : '아니오'),
                    if (purchaseService.queryProductError != null)
                      _buildInfoRow('상품 로드 오류', purchaseService.queryProductError!),
                  ],
                ),
                
                const SizedBox(height: 20),
                
                // 사용자 구매 정보
                _buildSection(
                  '사용자 구매 정보',
                  [
                    _buildInfoRow('프리미엄 상태', purchaseService.isPremium ? '활성' : '비활성'),
                    if (purchaseService.premiumExpiryDate != null)
                      _buildInfoRow('프리미엄 만료일', purchaseService.premiumExpiryDate.toString()),
                    _buildInfoRow('보유 하트', '${purchaseService.hearts}개'),
                  ],
                ),
                
                const SizedBox(height: 20),
                
                // 상품 목록
                _buildSection(
                  '상품 목록 (${purchaseService.products.length}개)',
                  purchaseService.products.map((product) => 
                    _buildProductInfo(product.id, product.title, product.price)
                  ).toList(),
                ),
                
                const SizedBox(height: 20),
                
                // 테스트 액션
                _buildSection(
                  '테스트 액션',
                  [
                    ElevatedButton(
                      onPressed: purchaseService.isAvailable ? () async {
                        await purchaseService.loadProducts();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('상품 목록을 다시 로드했습니다')),
                        );
                      } : null,
                      child: const Text('상품 다시 로드'),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: purchaseService.isAvailable ? () async {
                        await purchaseService.restorePurchases();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('구매 복원을 시작했습니다')),
                        );
                      } : null,
                      child: const Text('구매 복원'),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: purchaseService.hearts >= 5 ? () async {
                        final success = await purchaseService.useHearts(5);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(success ? '하트 5개를 사용했습니다' : '하트 사용에 실패했습니다'),
                            backgroundColor: success ? Colors.green : Colors.red,
                          ),
                        );
                      } : null,
                      child: const Text('하트 5개 사용 테스트'),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFFFF6B9D),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
      ],
    );
  }
  
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildProductInfo(String id, String title, String price) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'ID: $id',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
          Text(
            '가격: $price',
            style: const TextStyle(color: Color(0xFFFF6B9D)),
          ),
        ],
      ),
    );
  }
}