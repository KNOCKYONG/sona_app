import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/auth/auth_service.dart';
import '../services/auth/user_service.dart';

class AccountDeletionDialog {
  static Future<void> show(BuildContext context) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final userService = Provider.of<UserService>(context, listen: false);
    
    // 1단계: 경고 다이얼로그
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('계정 삭제'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '정말로 계정을 삭제하시겠습니까?',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text('계정 삭제 시:'),
            SizedBox(height: 8),
            Text('• 모든 개인정보가 즉시 삭제됩니다'),
            Text('• 모든 대화 내역이 삭제됩니다'),
            Text('• 구매한 상품은 복구할 수 없습니다'),
            Text('• 이 작업은 되돌릴 수 없습니다'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('계속'),
          ),
        ],
      ),
    );
    
    if (confirmed != true) return;
    
    // 2단계: 재인증 요청
    final password = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        final passwordController = TextEditingController();
        return AlertDialog(
          title: const Text('비밀번호 확인'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('계정 삭제를 위해 비밀번호를 다시 입력해주세요.'),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: '비밀번호',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, null),
              child: const Text('취소'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, passwordController.text),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
    
    if (password == null || password.isEmpty) return;
    
    // 3단계: 계정 삭제 처리
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
                  Text('계정을 삭제하는 중...'),
                ],
              ),
            ),
          ),
        ),
      );
    }
    
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('사용자를 찾을 수 없습니다');
      
      // 재인증
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );
      await user.reauthenticateWithCredential(credential);
      
      // Firestore에서 사용자 데이터 삭제
      final firestore = FirebaseFirestore.instance;
      
      // 1. 사용자 문서 삭제
      await firestore.collection('users').doc(user.uid).delete();
      
      // 2. 사용자의 모든 대화 내역 삭제
      final chats = await firestore
          .collection('chats')
          .where('userId', isEqualTo: user.uid)
          .get();
      
      for (final doc in chats.docs) {
        await doc.reference.delete();
      }
      
      // 3. 사용자의 모든 매칭 데이터 삭제
      final matches = await firestore
          .collection('matches')
          .where('userId', isEqualTo: user.uid)
          .get();
          
      for (final doc in matches.docs) {
        await doc.reference.delete();
      }
      
      // 4. 프로필 이미지 삭제
      await firestore
          .collection('user_profile_images')
          .doc(user.uid)
          .delete();
      
      // 5. Firebase Auth에서 계정 삭제
      await user.delete();
      
      // 로그아웃 처리
      await authService.signOut();
      
      if (context.mounted) {
        Navigator.of(context).popUntil((route) => route.isFirst);
        Navigator.of(context).pushReplacementNamed('/login');
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('계정이 성공적으로 삭제되었습니다.'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context); // 로딩 다이얼로그 닫기
        
        String errorMessage = '계정 삭제 중 오류가 발생했습니다.';
        if (e.toString().contains('wrong-password')) {
          errorMessage = '비밀번호가 올바르지 않습니다.';
        } else if (e.toString().contains('requires-recent-login')) {
          errorMessage = '보안을 위해 다시 로그인해주세요.';
        }
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}