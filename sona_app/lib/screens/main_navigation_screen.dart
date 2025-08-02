import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'chat_list_screen.dart';
import 'persona_selection_screen.dart';
import 'profile_screen.dart';
import '../services/storage/cache_manager.dart';
import '../services/chat/chat_service.dart';
import '../services/auth/auth_service.dart';
import '../services/persona/persona_service.dart';
import '../widgets/tutorial/tutorial_overlay.dart';
import '../models/tutorial_animation.dart' as anim_model;

class MainNavigationScreen extends StatefulWidget {
  final int initialIndex;
  
  const MainNavigationScreen({
    super.key,
    this.initialIndex = 0,
  });

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;
  bool _isFirstTime = false;

  final List<Widget> _screens = [
    const PersonaSelectionScreen(),
    const ChatListScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    _checkFirstTimeUser();
    
    // 채팅 목록 탭으로 시작하는 경우 처리는 ChatListScreen의 initState에서 처리됨
  }

  Future<void> _checkFirstTimeUser() async {
    final isFirstTime = await CacheManager.instance.isFirstTimeUser();
    debugPrint('MainNavigationScreen - isFirstTime: $isFirstTime');
    if (mounted) {
      setState(() {
        _isFirstTime = isFirstTime;
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    
    // 채팅 목록 탭을 선택했을 때 처리는 ChatListScreen에서 자동으로 처리됨
  }

  Future<bool> _onWillPop() async {
    // 첫 번째 탭(PersonaSelectionScreen)이 아닌 경우 첫 번째 탭으로 이동
    if (_selectedIndex != 0) {
      setState(() {
        _selectedIndex = 0;
      });
      return false;
    }
    
    // 첫 번째 탭에서 뒤로 가기를 누른 경우 앱 종료 확인
    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('앱 종료'),
        content: const Text('앱을 종료하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('종료'),
          ),
        ],
      ),
    );
    
    return shouldExit ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final scaffold = WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: _screens,
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            selectedItemColor: const Color(0xFFFF6B9D),
            unselectedItemColor: Colors.grey,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            elevation: 0,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite_outline),
                activeIcon: Icon(Icons.favorite),
                label: '매칭',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.chat_bubble_outline),
                activeIcon: Icon(Icons.chat_bubble),
                label: '채팅',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: '프로필',
              ),
            ],
          ),
        ),
      ),
    );

    // 첫 사용자에게만 메인 네비게이션 튜토리얼 표시
    if (_isFirstTime) {
      return TutorialOverlay(
        screenKey: 'main_navigation_intro',
        tutorialSteps: [
          TutorialStep(
            title: 'SONA에 오신 것을 환영합니다!',
            description: 'AI 페르소나와 특별한 관계를 만들어보세요.',
            messagePosition: Offset(
              MediaQuery.of(context).size.width / 2 - 150,
              100,
            ),
          ),
        ],
        child: scaffold,
      );
    }

    return scaffold;
  }
}