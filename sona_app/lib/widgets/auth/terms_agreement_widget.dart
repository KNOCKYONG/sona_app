import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import '../../screens/privacy_policy_screen.dart';
import '../../screens/terms_of_service_screen.dart';
import '../../l10n/app_localizations.dart';

class TermsAgreementWidget extends StatefulWidget {
  final bool agreedToTerms;
  final bool agreedToPrivacy;
  final bool agreedToMarketing;
  final Function(bool) onTermsChanged;
  final Function(bool) onPrivacyChanged;
  final Function(bool) onMarketingChanged;
  
  const TermsAgreementWidget({
    super.key,
    required this.agreedToTerms,
    required this.agreedToPrivacy,
    required this.agreedToMarketing,
    required this.onTermsChanged,
    required this.onPrivacyChanged,
    required this.onMarketingChanged,
  });

  @override
  State<TermsAgreementWidget> createState() => _TermsAgreementWidgetState();
}

class _TermsAgreementWidgetState extends State<TermsAgreementWidget> {
  bool _allAgreed = false;

  @override
  void initState() {
    super.initState();
    _checkAllAgreed();
  }

  void _checkAllAgreed() {
    setState(() {
      _allAgreed = widget.agreedToTerms && 
                   widget.agreedToPrivacy && 
                   widget.agreedToMarketing;
    });
  }

  void _toggleAll(bool? value) {
    if (value != null) {
      widget.onTermsChanged(value);
      widget.onPrivacyChanged(value);
      widget.onMarketingChanged(value);
      setState(() {
        _allAgreed = value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.termsAgreement,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        
        // 전체 동의
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark 
                ? Colors.grey[800] 
                : Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: CheckboxListTile(
            title: Text(
              localizations.allAgree,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).brightness == Brightness.dark 
                    ? Colors.black 
                    : null,
              ),
            ),
            value: _allAgreed,
            onChanged: _toggleAll,
            controlAffinity: ListTileControlAffinity.leading,
            checkColor: Colors.white,
            activeColor: Theme.of(context).brightness == Brightness.dark 
                ? Colors.black 
                : null,
          ),
        ),
        const SizedBox(height: 8),
        const Divider(),
        const SizedBox(height: 8),
        
        // 서비스 이용약관 (필수)
        CheckboxListTile(
          title: RichText(
            text: TextSpan(
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark 
                    ? Colors.black87 
                    : Colors.black87,
              ),
              children: [
                TextSpan(text: localizations.required + ' '),
                TextSpan(
                  text: localizations.termsOfService,
                  style: const TextStyle(
                    decoration: TextDecoration.underline,
                    color: Colors.blue,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TermsOfServiceScreen(),
                        ),
                      );
                    },
                ),
                TextSpan(text: localizations.agreeToTerms),
              ],
            ),
          ),
          value: widget.agreedToTerms,
          onChanged: (value) {
            if (value != null) {
              widget.onTermsChanged(value);
              _checkAllAgreed();
            }
          },
          controlAffinity: ListTileControlAffinity.leading,
          checkColor: Colors.white,
          activeColor: Theme.of(context).brightness == Brightness.dark 
              ? Colors.black 
              : null,
        ),
        
        // 개인정보 처리방침 (필수)
        CheckboxListTile(
          title: RichText(
            text: TextSpan(
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark 
                    ? Colors.black87 
                    : Colors.black87,
              ),
              children: [
                TextSpan(text: localizations.required + ' '),
                TextSpan(
                  text: localizations.privacyPolicy,
                  style: const TextStyle(
                    decoration: TextDecoration.underline,
                    color: Colors.blue,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PrivacyPolicyScreen(),
                        ),
                      );
                    },
                ),
                TextSpan(text: localizations.agreeToTerms),
              ],
            ),
          ),
          value: widget.agreedToPrivacy,
          onChanged: (value) {
            if (value != null) {
              widget.onPrivacyChanged(value);
              _checkAllAgreed();
            }
          },
          controlAffinity: ListTileControlAffinity.leading,
          checkColor: Colors.white,
          activeColor: Theme.of(context).brightness == Brightness.dark 
              ? Colors.black 
              : null,
        ),
        
        // 마케팅 수신 동의 (선택)
        CheckboxListTile(
          title: Text(
            localizations.marketingAgree,
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark 
                  ? Colors.black87 
                  : null,
            ),
          ),
          subtitle: Text(
            localizations.marketingDescription,
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).brightness == Brightness.dark 
                  ? Colors.black54 
                  : null,
            ),
          ),
          value: widget.agreedToMarketing,
          onChanged: (value) {
            if (value != null) {
              widget.onMarketingChanged(value);
              _checkAllAgreed();
            }
          },
          controlAffinity: ListTileControlAffinity.leading,
          checkColor: Colors.white,
          activeColor: Theme.of(context).brightness == Brightness.dark 
              ? Colors.black 
              : null,
        ),
        
        const SizedBox(height: 16),
        Text(
          localizations.ageConfirmation,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}