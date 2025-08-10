import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.termsOfService),
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
              localizations.sonaTermsOfService,
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
              title: localizations.termsSection1Title,
              content: localizations.termsSection1Content,
            ),
            _SectionWidget(
              title: localizations.termsSection2Title,
              content: localizations.termsSection2Content,
            ),
            _SectionWidget(
              title: localizations.termsSection3Title,
              content: localizations.termsSection3Content,
            ),
            _SectionWidget(
              title: localizations.termsSection4Title,
              content: localizations.termsSection4Content,
            ),
            _SectionWidget(
              title: localizations.termsSection5Title,
              content: localizations.termsSection5Content,
            ),
            _SectionWidget(
              title: localizations.termsSection6Title,
              content: localizations.termsSection6Content,
            ),
            _SectionWidget(
              title: localizations.termsSection7Title,
              content: localizations.termsSection7Content,
            ),
            _SectionWidget(
              title: localizations.termsSection8Title,
              content: localizations.termsSection8Content,
            ),
            _SectionWidget(
              title: localizations.termsSection9Title,
              content: localizations.termsSection9Content,
            ),
            _SectionWidget(
              title: localizations.termsSection10Title,
              content: localizations.termsSection10Content,
            ),
            // AI 서비스 특별 조항 추가
            _SectionWidget(
              title: localizations.termsSection11Title,
              content: localizations.termsSection11Content,
            ),
            _SectionWidget(
              title: localizations.termsSection12Title,
              content: localizations.termsSection12Content,
            ),
            Text(
              localizations.termsSupplementary,
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).textTheme.bodyMedium?.color,
                height: 1.6,
              ),
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
