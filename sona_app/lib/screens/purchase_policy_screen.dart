import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class PurchasePolicyScreen extends StatelessWidget {
  const PurchasePolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.purchaseAndRefundPolicy),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localizations.sonaPurchasePolicy,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFF6B9D),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              localizations.lastUpdated,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 30),
            
            _SectionWidget(
              title: localizations.purchaseSection1Title,
              content: localizations.purchaseSection1Content,
            ),
            
            _SectionWidget(
              title: localizations.purchaseSection2Title,
              content: localizations.purchaseSection2Content,
            ),
            
            _SectionWidget(
              title: localizations.purchaseSection3Title,
              content: localizations.purchaseSection3Content,
            ),
            
            _SectionWidget(
              title: localizations.purchaseSection4Title,
              content: localizations.purchaseSection4Content,
            ),
            
            _SectionWidget(
              title: localizations.purchaseSection5Title,
              content: localizations.purchaseSection5Content,
            ),
            
            _SectionWidget(
              title: localizations.purchaseSection6Title,
              content: localizations.purchaseSection6Content,
            ),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _SectionWidget extends StatelessWidget {
  final String title;
  final String content;

  const _SectionWidget({
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black54,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}