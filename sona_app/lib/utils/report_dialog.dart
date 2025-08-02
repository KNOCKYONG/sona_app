import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../l10n/app_localizations.dart';

class ReportDialog {
  static Future<void> show(BuildContext context, {
    required String targetType, // 'persona', 'message', 'user'
    required String targetId,
    String? targetName,
  }) async {
    String? selectedReason;
    String customReason = '';
    
    final localizations = AppLocalizations.of(context)!;
    final reasons = [
      localizations.inappropriateContent,
      localizations.spamAdvertising,
      localizations.hateSpeech,
      localizations.sexualContent,
      localizations.violentContent,
      localizations.harassmentBullying,
      localizations.personalInfoExposure,
      localizations.copyrightInfringement,
      localizations.other,
    ];
    
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('${targetName ?? targetType} ${localizations.report}'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localizations.selectReportReason,
                      style: const TextStyle(fontWeight: FontWeight.bold),
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
                    if (selectedReason == localizations.other) ...[
                      const SizedBox(height: 16),
                      TextField(
                        decoration: InputDecoration(
                          labelText: localizations.detailedReason,
                          hintText: localizations.explainReportReason,
                          border: const OutlineInputBorder(),
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
                  child: Text(localizations.cancel),
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
                  child: Text(localizations.report),
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
            SnackBar(
              content: Text(AppLocalizations.of(context)!.loginRequiredToReport),
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
          builder: (context) => Center(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    Text(AppLocalizations.of(context)!.reportInProgress),
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
          SnackBar(
            content: Text(AppLocalizations.of(context)!.reportSubmitted),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context); // 로딩 다이얼로그 닫기
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.reportError(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}