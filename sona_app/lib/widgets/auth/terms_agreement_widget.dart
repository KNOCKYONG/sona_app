import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import '../screens/privacy_policy_screen.dart';
import '../screens/terms_of_service_screen.dart';

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '약관 동의',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        
        // 전체 동의
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: CheckboxListTile(
            title: const Text(
              '전체 동의합니다',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            value: _allAgreed,
            onChanged: _toggleAll,
            controlAffinity: ListTileControlAffinity.leading,
          ),
        ),
        const SizedBox(height: 8),
        const Divider(),
        const SizedBox(height: 8),
        
        // 서비스 이용약관 (필수)
        CheckboxListTile(
          title: RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.black87),
              children: [
                const TextSpan(text: '[필수] '),
                TextSpan(
                  text: '서비스 이용약관',
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
                const TextSpan(text: '에 동의합니다'),
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
        ),
        
        // 개인정보 처리방침 (필수)
        CheckboxListTile(
          title: RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.black87),
              children: [
                const TextSpan(text: '[필수] '),
                TextSpan(
                  text: '개인정보 처리방침',
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
                const TextSpan(text: '에 동의합니다'),
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
        ),
        
        // 마케팅 수신 동의 (선택)
        CheckboxListTile(
          title: const Text('[선택] 마케팅 정보 수신에 동의합니다'),
          subtitle: const Text(
            '이벤트 및 혜택 정보를 받아보실 수 있습니다',
            style: TextStyle(fontSize: 12),
          ),
          value: widget.agreedToMarketing,
          onChanged: (value) {
            if (value != null) {
              widget.onMarketingChanged(value);
              _checkAllAgreed();
            }
          },
          controlAffinity: ListTileControlAffinity.leading,
        ),
        
        const SizedBox(height: 16),
        const Text(
          '만 14세 이상이며, 위 내용을 확인했습니다.',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}