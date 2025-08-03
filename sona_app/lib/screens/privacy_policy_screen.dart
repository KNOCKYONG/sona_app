import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.privacyPolicy),
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
              localizations.sonaPrivacyPolicy,
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
              title: localizations.privacySection1Title,
              content: localizations.privacySection1Content,
            ),
            
            _SectionWidget(
              title: localizations.privacySection2Title,
              content: localizations.privacySection2Content,
            ),
            
            _SectionWidget(
              title: localizations.privacySection3Title,
              content: localizations.privacySection3Content,
            ),
            
            _SectionWidget(
              title: localizations.privacySection4Title,
              content: localizations.privacySection4Content,
            ),
            
            _SectionWidget(
              title: localizations.privacySection5Title,
              content: localizations.privacySection5Content,
            ),
            
            _SectionWidget(
              title: localizations.privacySection6Title,
              content: localizations.privacySection6Content,
            ),
            
            _SectionWidget(
              title: localizations.privacySection7Title,
              content: localizations.privacySection7Content,
            ),
            
            _SectionWidget(
              title: localizations.privacySection8Title,
              content: localizations.privacySection8Content,
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
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.titleLarge?.color,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).textTheme.bodyMedium?.color,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}