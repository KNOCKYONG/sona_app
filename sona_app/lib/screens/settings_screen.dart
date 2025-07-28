import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth/auth_service.dart';
import '../utils/account_deletion_dialog.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _soundEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
      _soundEnabled = prefs.getBool('sound_enabled') ?? true;
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_enabled', _notificationsEnabled);
    await prefs.setBool('sound_enabled', _soundEnabled);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          '설정',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            
            // 알림 설정
            _buildSectionTitle('알림 설정'),
            _buildSwitchItem(
              icon: Icons.notifications_outlined,
              title: '푸시 알림',
              subtitle: '새로운 메시지 알림을 받습니다',
              value: _notificationsEnabled,
              onChanged: (value) {
                setState(() {
                  _notificationsEnabled = value;
                });
                _saveSettings();
              },
            ),
            
            // 소리 설정
            _buildSectionTitle('소리 설정'),
            _buildSwitchItem(
              icon: Icons.volume_up_outlined,
              title: '효과음',
              subtitle: '앱 내 효과음을 켜거나 끕니다',
              value: _soundEnabled,
              onChanged: (value) {
                setState(() {
                  _soundEnabled = value;
                });
                _saveSettings();
              },
            ),
            
            // 기타
            _buildSectionTitle('기타'),
            _buildMenuItem(
              icon: Icons.help_outline,
              title: '도움말',
              onTap: () {
                // 도움말 화면으로 이동
                _showHelpDialog();
              },
            ),
            _buildMenuItem(
              icon: Icons.info_outline,
              title: '앱 정보',
              subtitle: '버전 1.0.0',
              onTap: () {
                _showAppInfoDialog();
              },
            ),
            _buildMenuItem(
              icon: Icons.privacy_tip_outlined,
              title: '개인정보 처리방침',
              onTap: () {
                Navigator.pushNamed(context, '/privacy-policy');
              },
            ),
            _buildMenuItem(
              icon: Icons.description_outlined,
              title: '이용약관',
              onTap: () {
                Navigator.pushNamed(context, '/terms-of-service');
              },
            ),
            _buildMenuItem(
              icon: Icons.payment_outlined,
              title: '구매 및 환불 정책',
              onTap: () {
                Navigator.pushNamed(context, '/purchase-policy');
              },
            ),
            
            // 계정 관리
            _buildSectionTitle('계정 관리'),
            _buildMenuItem(
              icon: Icons.delete_outline,
              title: '계정 삭제',
              subtitle: '모든 데이터가 삭제됩니다',
              onTap: () {
                AccountDeletionDialog.show(context);
              },
            ),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.grey[600],
        ),
      ),
    );
  }

  Widget _buildSwitchItem({
    required IconData icon,
    required String title,
    String? subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFFFF6B9D).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: const Color(0xFFFF6B9D),
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              )
            : null,
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xFFFF6B9D),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFFFF6B9D).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: const Color(0xFFFF6B9D),
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              )
            : null,
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey,
        ),
        onTap: onTap,
      ),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text('도움말'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'SONA 사용 방법',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12),
              Text('1. 페르소나 매칭: 좌우로 스와이프하여 마음에 드는 AI 페르소나를 선택하세요.'),
              SizedBox(height: 8),
              Text('2. 대화 시작: 매칭된 페르소나와 자유롭게 대화를 나누세요.'),
              SizedBox(height: 8),
              Text('3. 관계 발전: 대화를 통해 친밀도를 쌓고 특별한 관계로 발전시켜보세요.'),
              SizedBox(height: 16),
              Text(
                '문의사항',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text('support@sona.app'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              '확인',
              style: TextStyle(color: Color(0xFFFF6B9D)),
            ),
          ),
        ],
      ),
    );
  }

  void _showAppInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text('앱 정보'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.favorite,
              size: 60,
              color: Color(0xFFFF6B9D),
            ),
            SizedBox(height: 16),
            Text(
              'SONA',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '버전 1.0.0',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'AI와 함께하는 특별한 만남',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              '확인',
              style: TextStyle(color: Color(0xFFFF6B9D)),
            ),
          ),
        ],
      ),
    );
  }
}