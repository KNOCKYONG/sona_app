import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/auth/auth_service.dart';
import '../services/auth/user_service.dart';
import '../l10n/app_localizations.dart';

class AccountDeletionDialog {
  static Future<void> show(BuildContext context) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final userService = Provider.of<UserService>(context, listen: false);

    // 1단계: 경고 다이얼로그
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.accountDeletionTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!
                  .accountDeletionContent
                  .split('\n')[0],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(AppLocalizations.of(context)!.accountDeletionInfo),
            const SizedBox(height: 8),
            Text(AppLocalizations.of(context)!.accountDeletionWarning1),
            Text(AppLocalizations.of(context)!.accountDeletionWarning2),
            Text(AppLocalizations.of(context)!.accountDeletionWarning3),
            Text(AppLocalizations.of(context)!.accountDeletionWarning4),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: Text(AppLocalizations.of(context)!.continueButton),
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
          title: Text(AppLocalizations.of(context)!.passwordConfirmation),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(AppLocalizations.of(context)!.passwordConfirmationDesc),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.password,
                  border: const OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, null),
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, passwordController.text),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: Text(AppLocalizations.of(context)!.confirm),
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
        builder: (context) => Center(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(AppLocalizations.of(context)!.deletingAccount),
                ],
              ),
            ),
          ),
        ),
      );
    }

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null)
        throw Exception(AppLocalizations.of(context)!.userNotFound);

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
      await firestore.collection('user_profile_images').doc(user.uid).delete();

      // 5. Firebase Auth에서 계정 삭제
      await user.delete();

      // 로그아웃 처리
      await authService.signOut();

      if (context.mounted) {
        Navigator.of(context).popUntil((route) => route.isFirst);
        Navigator.of(context).pushReplacementNamed('/login');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.accountDeletedSuccess),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context); // 로딩 다이얼로그 닫기

        String errorMessage =
            AppLocalizations.of(context)!.accountDeletionError;
        if (e.toString().contains('wrong-password')) {
          errorMessage = AppLocalizations.of(context)!.incorrectPassword;
        } else if (e.toString().contains('requires-recent-login')) {
          errorMessage = AppLocalizations.of(context)!.recentLoginRequired;
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
