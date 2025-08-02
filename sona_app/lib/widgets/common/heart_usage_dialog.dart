import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

/// 하트 사용 확인 다이얼로그 - 통일된 디자인
class HeartUsageDialog extends StatelessWidget {
  final String title;
  final String description;
  final int heartCost;
  final VoidCallback onConfirm;
  final String? additionalInfo;
  final IconData icon;
  
  const HeartUsageDialog({
    Key? key,
    required this.title,
    required this.description,
    required this.heartCost,
    required this.onConfirm,
    this.additionalInfo,
    this.icon = Icons.favorite,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDarkMode
                ? [
                    AppTheme.darkCardColor,
                    AppTheme.darkCardColor.withOpacity(0.8),
                  ]
                : [
                    const Color(0xFFFF6B9D).withOpacity(0.1),
                    const Color(0xFFFFC0CB).withOpacity(0.05),
                  ],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 아이콘
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFFF6B9D), Color(0xFFFF8FA3)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF6B9D).withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 40,
              ),
            ),
            const SizedBox(height: 24),
            
            // 타이틀
            Text(
              title,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : const Color(0xFF2D2D2D),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            
            // 설명
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                height: 1.5,
              ),
            ),
            
            // 추가 정보가 있으면 표시
            if (additionalInfo != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF6B9D).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFFFF6B9D).withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  additionalInfo!,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFFFF6B9D),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
            
            const SizedBox(height: 32),
            
            // 버튼들
            Row(
              children: [
                // 취소 버튼
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                      side: BorderSide(
                        color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      '취소',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                
                // 하트 사용 버튼
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                      onConfirm();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF6B9D),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.favorite, size: 18),
                        const SizedBox(width: 6),
                        Text(
                          heartCost.toString(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  /// 하트 사용 다이얼로그를 표시하는 정적 메서드
  static Future<bool> show({
    required BuildContext context,
    required String title,
    required String description,
    required int heartCost,
    required VoidCallback onConfirm,
    String? additionalInfo,
    IconData icon = Icons.favorite,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return HeartUsageDialog(
          title: title,
          description: description,
          heartCost: heartCost,
          onConfirm: onConfirm,
          additionalInfo: additionalInfo,
          icon: icon,
        );
      },
    );
    
    return result ?? false;
  }
}