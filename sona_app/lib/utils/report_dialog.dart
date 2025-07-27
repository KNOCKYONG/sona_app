import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReportDialog {
  static Future<void> show(BuildContext context, {
    required String targetType, // 'persona', 'message', 'user'
    required String targetId,
    String? targetName,
  }) async {
    String? selectedReason;
    String customReason = '';
    
    final reasons = [
      '부적절한 콘텐츠',
      '스팸/광고',
      '혐오 발언',
      '성적인 콘텐츠',
      '폭력적인 콘텐츠',
      '괴롭힘/따돌림',
      '개인정보 노출',
      '저작권 침해',
      '기타',
    ];
    
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('${targetName ?? targetType} 신고'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '신고 사유를 선택해주세요:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    ...reasons.map((reason) => RadioListTile<String>(
                      title: Text(reason),
                      value: reason,
                      groupValue: selectedReason,
                      onChanged: (value) {
                        setState(() {
                          selectedReason = value;
                        });
                      },
                    )),
                    if (selectedReason == '기타') ...[
                      const SizedBox(height: 16),
                      TextField(
                        decoration: const InputDecoration(
                          labelText: '상세 사유',
                          hintText: '신고 사유를 자세히 설명해주세요',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                        onChanged: (value) {
                          customReason = value;
                        },
                      ),
                    ],
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, null),
                  child: const Text('취소'),
                ),
                ElevatedButton(
                  onPressed: selectedReason == null ? null : () {
                    Navigator.pop(context, {
                      'reason': selectedReason!,
                      'customReason': customReason,
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: const Text('신고하기'),
                ),
              ],
            );
          },
        );
      },
    );
    
    if (result != null && context.mounted) {
      await _submitReport(
        context: context,
        targetType: targetType,
        targetId: targetId,
        targetName: targetName,
        reason: result['reason']!,
        customReason: result['customReason'] ?? '',
      );
    }
  }
  
  static Future<void> _submitReport({
    required BuildContext context,
    required String targetType,
    required String targetId,
    String? targetName,
    required String reason,
    required String customReason,
  }) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('신고하려면 로그인이 필요합니다'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }
      
      // 로딩 다이얼로그 표시
      if (context.mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('신고를 접수하는 중...'),
                  ],
                ),
              ),
            ),
          ),
        );
      }
      
      // Firestore에 신고 정보 저장
      await FirebaseFirestore.instance.collection('reports').add({
        'reporterId': user.uid,
        'reporterEmail': user.email,
        'targetType': targetType,
        'targetId': targetId,
        'targetName': targetName,
        'reason': reason,
        'customReason': customReason,
        'status': 'pending', // pending, reviewed, resolved
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      
      if (context.mounted) {
        Navigator.pop(context); // 로딩 다이얼로그 닫기
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('신고가 접수되었습니다. 검토 후 조치하겠습니다.'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context); // 로딩 다이얼로그 닫기
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('신고 접수 중 오류가 발생했습니다: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}