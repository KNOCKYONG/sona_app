import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:animations/animations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth/auth_service.dart';
import '../services/persona/persona_service.dart';
import '../services/auth/device_id_service.dart';
import '../services/auth/user_service.dart';
import '../services/storage/cache_manager.dart';
import '../models/persona.dart';
import '../models/app_user.dart';
import '../widgets/persona/persona_card.dart';
import '../widgets/tutorial/tutorial_overlay.dart';
import '../models/tutorial_animation.dart' as anim_model;
import '../widgets/common/sona_logo.dart';
import '../widgets/navigation/animated_action_button.dart';
import '../theme/app_theme.dart';

class PersonaSelectionScreen extends StatefulWidget {
  const PersonaSelectionScreen({super.key});

  @override
  State<PersonaSelectionScreen> createState() => _PersonaSelectionScreenState();
}

class _PersonaSelectionScreenState extends State<PersonaSelectionScreen>
    with TickerProviderStateMixin {
  final CardSwiperController _cardController = CardSwiperController();
  late AnimationController _heartAnimationController;
  late AnimationController _passAnimationController;
  
  int _currentIndex = 0;
  bool _isLoading = false;
  bool _isFirstTimeUser = false;

  @override
  void initState() {
    super.initState();
    
    _heartAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _passAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadPersonas();
      _checkFirstTimeUser();
    });
  }
  
  Future<void> _checkFirstTimeUser() async {
    final isFirstTime = await CacheManager.instance.isFirstTimeUser();
    if (mounted) {
      setState(() {
        _isFirstTimeUser = isFirstTime;
      });
    }
  }

  Future<void> _loadPersonas() async {
    final personaService = Provider.of<PersonaService>(context, listen: false);
    final authService = Provider.of<AuthService>(context, listen: false);
    final userService = Provider.of<UserService>(context, listen: false);
    
    // 🔧 DeviceIdService로 사용자 ID 확보
    final currentUserId = await DeviceIdService.getCurrentUserId(
      firebaseUserId: authService.user?.uid,
    );
    
    debugPrint('🆔 Loading personas with userId: $currentUserId');
    
    // 디바이스 정보 로그 (디버깅용)
    await DeviceIdService.logDeviceInfo();
    
    personaService.setCurrentUserId(currentUserId);
    
    // 추천 알고리즘을 위해 현재 사용자 정보 설정
    if (userService.currentUser != null) {
      debugPrint('📊 Setting current user for recommendation algorithm');
      personaService.setCurrentUser(userService.currentUser!);
    } else {
      // 게스트 사용자의 경우 기본 설정 사용
      debugPrint('⚠️ No current user available - checking local preferences');
      
      // SharedPreferences에서 성별 설정 확인
      final prefs = await SharedPreferences.getInstance();
      final gender = prefs.getString('user_gender');
      final genderAll = prefs.getBool('user_gender_all') ?? false;
      
      if (gender != null) {
        debugPrint('📊 Found local gender preference: $gender, genderAll: $genderAll');
        // 게스트 사용자를 위한 기본 AppUser 객체 생성
        final guestUser = AppUser(
          uid: currentUserId,
          email: '',
          nickname: 'Guest',
          gender: gender,
          genderAll: genderAll,
          birth: DateTime(2000, 1, 1),
          age: AppUser.calculateAge(DateTime(2000, 1, 1)),
          preferredPersona: PreferredPersona(ageRange: [20, 35]),
          interests: [],
          createdAt: DateTime.now(),
        );
        personaService.setCurrentUser(guestUser);
      } else {
        debugPrint('⚠️ No gender preference found');
      }
    }
    
    // 일반 모드에서는 전체 초기화
    await personaService.initialize(userId: currentUserId);
  }

  void _showTutorialExitDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            '튜토리얼 종료',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFF6B9D),
            ),
            textAlign: TextAlign.center,
          ),
          content: const Text(
            '튜토리얼을 종료하고 로그인하시겠습니까?\n로그인하면 데이터가 저장되고 모든 기능을 사용할 수 있습니다.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.grey),
                    ),
                    child: const Text(
                      '취소',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                      await _exitTutorialAndSignIn();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF6B9D),
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<void> _exitTutorialAndSignIn() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(
            color: Color(0xFFFF6B9D),
          ),
        );
      },
    );

    final success = await authService.signInWithGoogle();
    
    if (mounted) {
      Navigator.of(context).pop(); // 로딩 다이얼로그 닫기
      
      if (!success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('로그인에 실패했습니다. 다시 시도해주세요.'),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('로그인이 완료되었습니다 🎉'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    // 애니메이션 컨트롤러를 먼저 정리
    _heartAnimationController.stop();
    _passAnimationController.stop();
    _heartAnimationController.dispose();
    _passAnimationController.dispose();
    
    // 카드 컨트롤러는 마지막에 정리
    try {
      _cardController.dispose();
    } catch (e) {
      // CardSwiper dispose 중 발생하는 오류 무시
      debugPrint('CardSwiper dispose error (ignored): $e');
    }
    
    super.dispose();
  }

  bool _onSwipe(int previousIndex, int? currentIndex, CardSwiperDirection direction) {
    final personaService = Provider.of<PersonaService>(context, listen: false);
    // 🔧 FIX: 스와이프 시점에 고정된 스냅샷 사용 (실시간 변경 방지)
    final personas = List<Persona>.from(personaService.availablePersonas);
    
    debugPrint('🎯 Swipe detected: previousIndex=$previousIndex, currentIndex=$currentIndex, direction=$direction');
    debugPrint('📊 Personas snapshot length: ${personas.length}');
    
    if (previousIndex >= 0 && previousIndex < personas.length) {
      final persona = personas[previousIndex];
      
      if (direction == CardSwiperDirection.right) {
        debugPrint('💕 Right swipe - Liking persona: ${persona.name}');
        _onPersonaLiked(persona, isSuperLike: false);
      } else if (direction == CardSwiperDirection.left) {
        debugPrint('👈 Left swipe - Passing persona: ${persona.name}');
        _onPersonaPassed(persona);
      } else if (direction == CardSwiperDirection.top) {
        debugPrint('⭐ Top swipe - Super liking persona: ${persona.name}');
        _onPersonaLiked(persona, isSuperLike: true);
      }
    } else {
      debugPrint('❌ Index out of bounds: $previousIndex (total: ${personas.length})');
    }
    
    // 🔧 FIX: currentIndex 업데이트를 지연시켜 UI 안정성 확보
    if (currentIndex != null && mounted) {
      Future.microtask(() {
        if (mounted) {
          setState(() {
            _currentIndex = currentIndex;
          });
        }
      });
    }
    
    return true; // Allow swipe to proceed
  }

  void _onPersonaLiked(Persona persona, {bool isSuperLike = false}) async {
    if (!mounted) return;
    
    _heartAnimationController.forward().then((_) {
      if (mounted && _heartAnimationController != null) {
        try {
          _heartAnimationController.reverse();
        } catch (e) {
          // 애니메이션 오류 무시
        }
      }
    });
    
    final authService = Provider.of<AuthService>(context, listen: false);
    final personaService = Provider.of<PersonaService>(context, listen: false);
    
    // 전문가 기능 제거됨
    
    // 🔧 일반 모드: Firebase를 통한 매칭 처리
    Future.microtask(() async {
      debugPrint('🔄 Processing persona match: ${persona.name}');
      
      // 먼저 스와이프 마킹
      await personaService.markPersonaAsSwiped(persona.id);
      
      // 그 다음 매칭 처리 (내부적으로 이미 스와이프 체크함)
      final matchSuccess = await personaService.matchWithPersona(persona.id, isSuperLike: isSuperLike);
      
      debugPrint('✅ Match processing complete: ${persona.name} (success: $matchSuccess, isSuperLike: $isSuperLike)');
    });
    
    // 🔧 DeviceIdService 기반 매칭 (로그인 없이도 작동)
    setState(() => _isLoading = true);
    
    try {
      // DeviceIdService로 사용자 ID 확보
      final currentUserId = await DeviceIdService.getCurrentUserId(
        firebaseUserId: authService.user?.uid,
      );
      
      debugPrint('🆔 Matching with userId: $currentUserId');
      
      // PersonaService가 currentUserId를 가지고 있는지 확인
      if (personaService.matchedPersonas.isEmpty) {
        personaService.setCurrentUserId(currentUserId);
      }
      
      // 매칭 수행
      final success = await personaService.likePersona(persona.id);
      
      setState(() => _isLoading = false);
      
      if (success && mounted) {
        _showMatchDialog(persona, isSuperLike: isSuperLike);
      } else if (mounted) {
        debugPrint('❌ Matching failed for persona: ${persona.id}');
        // 실패해도 다이얼로그는 표시 (UX)
        _showMatchDialog(persona, isSuperLike: isSuperLike);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      debugPrint('❌ Error in matching process: $e');
      // 에러가 발생해도 다이얼로그 표시 (UX)
      if (mounted) {
        _showMatchDialog(persona, isSuperLike: isSuperLike);
      }
    }
  }

  void _onPersonaPassed(Persona persona) {
    if (!mounted) return;
    
    _passAnimationController.forward().then((_) {
      if (mounted && _passAnimationController != null) {
        try {
          _passAnimationController.reverse();
        } catch (e) {
          // 애니메이션 오류 무시
        }
      }
    });
    
    final personaService = Provider.of<PersonaService>(context, listen: false);
    // 🔧 FIX: Pass 처리도 안전하게 비동기 처리
    Future.microtask(() async {
      debugPrint('👈 Processing persona pass: ${persona.name}');
      final success = await personaService.passPersona(persona.id);
      if (success) {
        debugPrint('✅ Pass processing complete: ${persona.name}');
      } else {
        debugPrint('❌ Pass processing failed: ${persona.name}');
      }
    });
  }

  // 전문가 상담 안내 팝업
  // 전문가 매칭 시 로그인 필요 다이얼로그
  void _showExpertLoginRequiredDialog(Persona persona) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF2196F3).withOpacity(0.1),
                  const Color(0xFF1976D2).withOpacity(0.05),
                ],
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF2196F3).withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.lock_outline,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  '전문 상담 서비스',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2196F3),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '${persona.name}님과의 전문 상담은\n로그인 후 이용 가능합니다.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: const [
                      Row(
                        children: [
                          Icon(Icons.check_circle, color: Color(0xFF2196F3), size: 20),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '검증된 전문가의 1:1 맞춤 상담',
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.check_circle, color: Color(0xFF2196F3), size: 20),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '실행 가능한 구체적 솔루션 제공',
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.check_circle, color: Color(0xFF2196F3), size: 20),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '안전하고 비밀이 보장되는 상담',
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _cardController.undo(); // 카드 되돌리기
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.grey[600],
                          side: BorderSide(color: Colors.grey[400]!),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('나중에'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          Navigator.of(context).pop();
                          await _exitTutorialAndSignIn();
                          // 로그인 성공 후 다시 전문가와 매칭
                          if (mounted) {
                            final authService = Provider.of<AuthService>(context, listen: false);
                            if (authService.user != null) {
                              _showExpertConsultationDialog(persona);
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2196F3),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          '로그인하기',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // 전문가 상담 시작 다이얼로그
  void _showExpertConsultationDialog(Persona persona) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFFF6B9D), Color(0xFFFF8FA3)],
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  '💫 전문가 매칭! 💫',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                // 전문가 프로필
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: persona.photoUrls.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: persona.photoUrls.first,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: Colors.grey[300],
                              child: const Icon(Icons.person, size: 40),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: Colors.grey[300],
                              child: const Icon(Icons.person, size: 40),
                            ),
                          )
                        : Container(
                            color: Colors.grey[300],
                            child: const Icon(Icons.person, size: 40),
                          ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '${persona.name}님과 매칭되었습니다! 🎉',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '전문적인 상담을 시작할 수 있어요! 💕',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '${persona.name}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        persona.description,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.white70,
                          height: 1.5,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.thumb_up, color: Colors.white70, size: 16),
                          SizedBox(width: 4),
                          Text(
                            '좋은 텔로우를 사귀 넣기기',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(dialogContext).pop();
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: const Text('나중에'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          Navigator.of(dialogContext).pop();
                          await _navigateToChat(persona, context, false);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFFFF6B9D),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: const Text(
                          '채팅 시작',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showExpertConsultationPopup(Persona persona, BuildContext screenContext) {
    showModal<void>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  '🎉 전문가 매칭 성공! 🎉',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                
                // 전문가 프로필 이미지
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: persona.getThumbnailUrl() != null
                        ? CachedNetworkImage(
                            imageUrl: persona.getThumbnailUrl()!,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: Colors.grey[300],
                              child: const Icon(Icons.person, size: 40),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: Colors.grey[300],
                              child: const Icon(Icons.person, size: 40),
                            ),
                          )
                        : Container(
                            color: Colors.grey[300],
                            child: const Icon(Icons.person, size: 40),
                          ),
                  ),
                ),
                const SizedBox(height: 16),
                
                Text(
                  'Dr. ${persona.name}',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                // profession 필드 제거됨
                const SizedBox(height: 20),
                
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        '🌟 전문가와 매칭되었습니다! 🌟',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '이제 궁금한 점을 마음껏 물어보고\n전문적인 조언을 받아보세요!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white.withOpacity(0.9),
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const [
                          Icon(Icons.psychology, color: Colors.white70, size: 24),
                          Icon(Icons.chat_bubble, color: Colors.white70, size: 24),
                          Icon(Icons.lightbulb, color: Colors.white70, size: 24),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '전문 상담 • 맞춤 조언 • 실행 가능한 솔루션',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                
                ElevatedButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    // Continue with navigation
                    await _navigateToChat(persona, screenContext, false);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF2196F3),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text(
                    '전문 상담 시작하기',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // 전문가 소나 확인 다이얼로그
  Future<void> _showExpertConfirmDialog(Persona persona) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF2196F3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.verified,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  '전문가 Sona',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    height: 1.5,
                  ),
                  children: [
                    const TextSpan(text: 'Dr. '),
                    TextSpan(
                      text: persona.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const TextSpan(text: '님은 '),
                    TextSpan(
                      text: '상담사',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2196F3),
                      ),
                    ),
                    const TextSpan(text: ' 전문가입니다.\n\n'),
                    const TextSpan(
                      text: '전문가와의 매칭은 ',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const TextSpan(
                      text: '5 포인트',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFF6B9D),
                      ),
                    ),
                    const TextSpan(
                      text: '가 차감되며, ',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const TextSpan(
                      text: '친구 관계(50점)',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2196F3),
                      ),
                    ),
                    const TextSpan(
                      text: '로 시작됩니다.\n(전문가는 Super Like 불가)\n\n매칭하시겠습니까?',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                '취소',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _onPersonaLiked(persona, isSuperLike: false); // 전문가는 항상 일반 매칭
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6B9D),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                '5 포인트로 매칭',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showMatchDialog(Persona persona, {bool isSuperLike = false}) {
    // 🔧 FIX: 메인 화면의 context를 미리 저장
    final BuildContext screenContext = context;
    
    // 전문가 기능 제거됨
    
    showModal<void>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFFF6B9D), Color(0xFFFF8FA3)],
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isSuperLike 
                      ? '💫 슈퍼 라이크 매칭! 💫' 
                      : '✨ 매칭 성공! ✨',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                
                // 소나 프로필 이미지
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                  child: ClipOval(
                    child: persona.getThumbnailUrl() != null
                        ? CachedNetworkImage(
                            imageUrl: persona.getThumbnailUrl()!,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: Colors.grey[300],
                              child: const Icon(Icons.person, size: 40),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: Colors.grey[300],
                              child: const Icon(Icons.person, size: 40),
                            ),
                          )
                        : Container(
                            color: Colors.grey[300],
                            child: const Icon(Icons.person, size: 40),
                          ),
                  ),
                ),
                const SizedBox(height: 16),
                
                Text(
                  isSuperLike 
                      ? '${persona.name}님이 당신을 특별히 좋아해요! 💕'
                      : '${persona.name}님과 매칭되었어요!',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                
                Text(
                  isSuperLike 
                      ? 'Like 200점(썸)으로 시작됩니다! 🎉'
                      : 'Like 50점(친구)부터 시작해보세요 💕',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 24),
                
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () async {
                          Navigator.of(context).pop();
                          
                          // 페르소나 서비스 새로고침을 트리거
                          final personaService = Provider.of<PersonaService>(screenContext, listen: false);
                          final authService = Provider.of<AuthService>(screenContext, listen: false);
                          final userId = authService.user?.uid ?? '';
                          
                          if (userId.isNotEmpty) {
                            // 매칭된 페르소나 새로고침
                            await personaService.initialize(userId: userId);
                          }
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: const Text('나중에'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          Navigator.of(context).pop();
                          await _navigateToChat(persona, screenContext, isSuperLike);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFFFF6B9D),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: const Text(
                          '채팅 시작',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _onLikePressed() {
    debugPrint('Like button pressed - attempting to swipe right');
    _cardController.swipe(CardSwiperDirection.right);
  }

  void _onSuperLikePressed() {
    debugPrint('Super like button pressed - attempting to swipe top');
    _cardController.swipe(CardSwiperDirection.top);
  }

  void _onPassPressed() {
    debugPrint('Pass button pressed - attempting to swipe left');
    _cardController.swipe(CardSwiperDirection.left);
  }

  // Helper method for chat navigation
  Future<void> _navigateToChat(Persona persona, BuildContext screenContext, bool isSuperLike) async {
    final personaService = Provider.of<PersonaService>(screenContext, listen: false);
    final authService = Provider.of<AuthService>(screenContext, listen: false);
    
    if (!mounted) {
      debugPrint('❌ Widget not mounted, skipping navigation');
      return;
    }
    
    debugPrint('🚀 Starting chat navigation process...');
    
    try {
      // 🔧 DeviceIdService로 사용자 ID 확보
      final currentUserId = await DeviceIdService.getCurrentUserId(
        firebaseUserId: authService.user?.uid,
      );
      
      debugPrint('🆔 Processing match with userId: $currentUserId');
      
      // 🔧 중요: 전문가 페르소나도 실제로 매칭 처리해야 채팅 목록에 나타남
      debugPrint('🩺 Processing persona match: ${persona.name}');
      
      // 실제 매칭 처리 (전문가든 일반이든 모두 매칭 필요)
      final matchSuccess = await personaService.matchWithPersona(persona.id, isSuperLike: isSuperLike);
      debugPrint('✅ Match result: $matchSuccess for ${persona.name}');
      
      // Firebase에서 최신 매칭 정보 다시 로드
      debugPrint('🔄 Refreshing matched personas after successful match...');
      await personaService.initialize(userId: currentUserId);
      
      // 매칭 확인
      final matchedCount = personaService.matchedPersonas.length;
      debugPrint('✅ Refreshed - $matchedCount matched personas found');
      
      // 🔧 FIX: 메인 화면 context로 안전한 네비게이션
      if (mounted && screenContext.mounted) {
        debugPrint('🧭 Attempting direct chat navigation with screen context...');
        try {
          // 🎯 매칭된 소나와 바로 채팅 시작 (더 나은 UX)
          // 🔧 FIX: 업데이트된 persona를 전달
          final updatedPersona = isSuperLike 
              ? persona.copyWith(
                  relationshipScore: 200, 
                  currentRelationship: RelationshipType.crush,
                  imageUrls: persona.imageUrls,  // Preserve imageUrls
                )
              : persona.copyWith(
                  relationshipScore: 50, 
                  currentRelationship: RelationshipType.friend,
                  imageUrls: persona.imageUrls,  // Preserve imageUrls
                );
          
          Navigator.of(screenContext).pushNamedAndRemoveUntil(
            '/chat',
            (route) => false,
            arguments: updatedPersona,
          );
          debugPrint('✅ Successfully navigated to direct chat with ${persona.name} (score: ${updatedPersona.relationshipScore})');
        } catch (navError) {
          debugPrint('❌ Direct chat navigation error: $navError');
          
          // 실패 시 채팅 목록으로 대체
          if (mounted && screenContext.mounted) {
            try {
              debugPrint('🔄 Fallback to chat list navigation...');
              Navigator.of(screenContext).pushNamedAndRemoveUntil(
                '/chat-list', 
                (route) => false,
              );
              debugPrint('✅ Fallback navigation succeeded');
            } catch (altError) {
              debugPrint('❌ Even fallback navigation failed: $altError');
              
              // 마지막 수단: 약간의 지연 후 재시도
              await Future.delayed(const Duration(milliseconds: 100));
              if (mounted && screenContext.mounted) {
                Navigator.of(screenContext).pushReplacementNamed('/chat-list');
              }
            }
          }
        }
      } else {
        debugPrint('❌ Screen context not mounted for navigation');
      }
    } catch (e) {
      debugPrint('❌ Error refreshing personas: $e');
      
      // 에러가 발생해도 채팅으로 이동 시도 (메인 화면 context 사용)
      if (mounted && screenContext.mounted) {
        try {
          debugPrint('🚑 Emergency direct chat navigation attempt...');
          Navigator.of(screenContext).pushNamedAndRemoveUntil(
            '/chat',
            (route) => false,
            arguments: persona,
          );
          debugPrint('✅ Emergency navigation successful - direct to chat');
        } catch (emergencyError) {
          debugPrint('❌ Emergency navigation failed, trying chat list: $emergencyError');
          try {
            Navigator.of(screenContext).pushReplacementNamed('/chat-list');
            debugPrint('✅ Emergency fallback to chat list successful');
          } catch (finalError) {
            debugPrint('❌ All navigation methods failed: $finalError');
          }
        }
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    
    Widget scaffold = Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Consumer<AuthService>(
          builder: (context, authService, child) {
            return SonaLogo(
              size: 35,
              textColor: const Color(0xFFFF6B9D),
            );
          },
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.shopping_bag_outlined,
              color: Color(0xFFFF6B9D),
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/purchase');
            },
          ),
        ],
      ),
      body: Consumer<PersonaService>(
        builder: (context, personaService, child) {
          if (personaService.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFFFF6B9D),
              ),
            );
          }

          final personas = personaService.availablePersonas;
          
          debugPrint('🎯 PersonaSelectionScreen: Available personas count: ${personas.length}');
          debugPrint('🎯 PersonaSelectionScreen: All personas count: ${personaService.allPersonas.length}');
          
          // CardSwiper는 최소 1개의 카드가 필요하므로 빈 배열 체크
          if (personas.isEmpty || personas.length == 0) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.schedule,
                    size: 80,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    '모든 소나를 확인했습니다!',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFF6B9D),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '24시간 후에 다시 만날 수 있어요.\n${personaService.swipedPersonasCount}명의 소나가 대기 중입니다.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      // 애니메이션 컨트롤러 정지
                      _heartAnimationController.stop();
                      _passAnimationController.stop();
                      
                      // 채팅 목록 화면으로 이동
                      Navigator.of(context).pushReplacementNamed('/chat-list');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF6B9D),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    ),
                    child: const Text(
                      '새로고침',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // 메인 카드 스택
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: personas.length > 0 
                    ? CardSwiper(
                        key: ValueKey('cardswiper_${personas.length}'), // 🔧 FIX: 리스트 길이 기반 안정적 키
                        controller: _cardController,
                        cardsCount: personas.length > 0 ? personas.length : 1,
                    onSwipe: _onSwipe,
                    onEnd: () {
                      // 모든 카드를 스와이프했을 때
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('모든 소나를 확인했습니다!'),
                        ),
                      );
                    },
                    numberOfCardsDisplayed: personas.length >= 2 ? 2 : personas.length,
                    backCardOffset: const Offset(0, -20),
                    padding: const EdgeInsets.all(8),
                    allowedSwipeDirection: const AllowedSwipeDirection.only(
                      left: true,
                      right: true,
                      up: true,
                      down: false,
                    ),
                    cardBuilder: (context, index, horizontalThresholdPercentage, verticalThresholdPercentage) {
                      // index 범위 검사
                      if (index < 0 || index >= personas.length) {
                        return const SizedBox.shrink();
                      }
                      // 소나 ID를 키로 사용하여 안정적인 렌더링 보장
                      return PersonaCard(
                        key: ValueKey(personas[index].id),
                        persona: personas[index],
                        horizontalThresholdPercentage: horizontalThresholdPercentage.toDouble(),
                        verticalThresholdPercentage: verticalThresholdPercentage.toDouble(),
                      );
                    },
                  )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.favorite_border,
                            size: 100,
                            color: Color(0xFFFF6B9D),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            '선택할 소나가 없습니다',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFFF6B9D),
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            '새로운 소나가 곧 추가될 예정입니다!',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                ),
              ),
              
              // 액션 버튼들 (소나가 있을 때만 표시)
              if (personas.isNotEmpty) Container(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Pass 버튼
                    AnimatedBuilder(
                      animation: _passAnimationController,
                      builder: (context, child) {
                        final animValue = _passAnimationController.value.clamp(0.0, 1.0);
                        return Transform.scale(
                          scale: 1.0 + (animValue * 0.1),
                          child: AnimatedActionButton(
                            onTap: _isLoading ? null : _onPassPressed,
                            size: 60,
                            gradientColors: [
                              Colors.grey[400]!,
                              Colors.grey[500]!,
                            ],
                            shadowColor: Colors.grey,
                            icon: Icons.close_rounded,
                            iconSize: 30,
                            tooltip: 'Pass',
                          ),
                        );
                      },
                    ),
                    
                    // Super Like 버튼 (전문가가 아닐 때만 활성화)
                    Consumer<PersonaService>(
                      builder: (context, personaService, child) {
                        final personas = personaService.availablePersonas;
                        final currentPersona = personas.isNotEmpty ? personas[0] : null;
                        
                        return AnimatedActionButton(
                          onTap: _isLoading ? null : _onSuperLikePressed,
                          size: 70,
                          gradientColors: [const Color(0xFF00BCD4), const Color(0xFF2196F3)],
                          shadowColor: const Color(0xFF2196F3),
                          icon: Icons.star_rounded,
                          iconSize: 35,
                          tooltip: 'Super Like (바로 썸 단계)',
                        );
                      },
                    ),
                    
                    // Like 버튼
                    AnimatedBuilder(
                      animation: _heartAnimationController,
                      builder: (context, child) {
                        final animValue = _heartAnimationController.value.clamp(0.0, 1.0);
                        return Transform.scale(
                          scale: 1.0 + (animValue * 0.2),
                          child: AnimatedActionButton(
                            onTap: _isLoading ? null : _onLikePressed,
                            size: 65,
                            gradientColors: const [
                              Color(0xFFFF6B9D),
                              Color(0xFFFF8FA3),
                            ],
                            shadowColor: const Color(0xFFFF6B9D),
                            icon: Icons.favorite_rounded,
                            iconSize: 32,
                            isLoading: _isLoading,
                            tooltip: 'Like',
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );

    // 첫 사용자이고 사용 가능한 소나가 있을 때만 튜토리얼 오버레이 표시
    if (_isFirstTimeUser) {
      return Consumer<PersonaService>(
        builder: (context, personaService, child) {
          final hasAvailablePersonas = personaService.availablePersonas.isNotEmpty;
          
          // 사용 가능한 소나가 없으면 튜토리얼 없이 기본 화면만 표시
          if (!hasAvailablePersonas) {
            return scaffold;
          }
          
          final screenWidth = MediaQuery.of(context).size.width;
          final screenHeight = MediaQuery.of(context).size.height;
          
          return TutorialOverlay(
            screenKey: 'persona_selection',
            child: scaffold,
            onTutorialComplete: () {
              // 튜토리얼 완료 시 상태 업데이트
              if (mounted) {
                setState(() {
                  _isFirstTimeUser = false;
                });
              }
            },
            animatedSteps: [
              // 스텝 1: 스와이프 가이드
              anim_model.AnimatedTutorialStep(
                animations: [
                  // 오른쪽 스와이프 애니메이션 - 친구 (더 긴 이동거리)
                  anim_model.TutorialAnimation(
                    type: anim_model.TutorialAnimationType.swipeRight,
                    startPosition: Offset(screenWidth * 0.5, screenHeight * 0.47),
                    endPosition: Offset(screenWidth * 0.95, screenHeight * 0.47),  // 0.85 → 0.95로 증가
                    duration: const Duration(seconds: 2),
                    delay: const Duration(milliseconds: 500),
                  ),
                  // 위로 스와이프 애니메이션 - 연인 (더 긴 이동거리)
                  anim_model.TutorialAnimation(
                    type: anim_model.TutorialAnimationType.swipeUp,
                    startPosition: Offset(screenWidth * 0.5, screenHeight * 0.47),
                    endPosition: Offset(screenWidth * 0.5, screenHeight * 0.15),  // 0.25 → 0.15로 감소 (더 위로)
                    duration: const Duration(seconds: 2),
                    delay: const Duration(seconds: 3),
                  ),
                  // 왼쪽 스와이프 애니메이션 - 패스 (더 긴 이동거리)
                  anim_model.TutorialAnimation(
                    type: anim_model.TutorialAnimationType.swipeLeft,
                    startPosition: Offset(screenWidth * 0.5, screenHeight * 0.47),
                    endPosition: Offset(screenWidth * 0.05, screenHeight * 0.47),  // 0.15 → 0.05로 감소
                    duration: const Duration(seconds: 2),
                    delay: const Duration(seconds: 6),
                  ),
                ],
                highlightArea: anim_model.HighlightArea(
                  left: screenWidth * 0.1,
                  top: screenHeight * 0.25,
                  width: screenWidth * 0.8,
                  height: screenHeight * 0.45,
                  borderRadius: BorderRadius.circular(20),
                  glowRadius: 30,
                ),
                stepDuration: const Duration(seconds: 10),  // 10초로 증가
              ),
              // 스텝 2: 프로필 사진 스와이프 가이드
              anim_model.AnimatedTutorialStep(
                animations: [
                  // 왼쪽 화살표 탭
                  anim_model.TutorialAnimation(
                    type: anim_model.TutorialAnimationType.tap,
                    startPosition: Offset(screenWidth * 0.2, screenHeight * 0.4),
                    duration: const Duration(seconds: 1),
                    delay: const Duration(milliseconds: 500),
                  ),
                  // 오른쪽 화살표 탭
                  anim_model.TutorialAnimation(
                    type: anim_model.TutorialAnimationType.tap,
                    startPosition: Offset(screenWidth * 0.8, screenHeight * 0.4),
                    duration: const Duration(seconds: 1),
                    delay: const Duration(seconds: 2),
                  ),
                  // 프로필 사진 영역 펄스
                  anim_model.TutorialAnimation(
                    type: anim_model.TutorialAnimationType.pulse,
                    startPosition: Offset(screenWidth * 0.5, screenHeight * 0.4),
                    duration: const Duration(seconds: 2),
                    delay: const Duration(seconds: 3, milliseconds: 500),
                    color: const Color(0xFF66D9EF),
                  ),
                ],
                highlightArea: anim_model.HighlightArea(
                  left: screenWidth * 0.15,
                  top: screenHeight * 0.3,
                  width: screenWidth * 0.7,
                  height: screenHeight * 0.2,  // 프로필 사진 영역만
                  borderRadius: BorderRadius.circular(15),
                  glowColor: const Color(0xFF66D9EF),
                ),
                stepDuration: const Duration(seconds: 8),
              ),
              // 스텝 3: 하단 버튼 가이드
              anim_model.AnimatedTutorialStep(
                animations: [
                  // 왼쪽 버튼 (X) 탭 - 더 아래로 조정
                  anim_model.TutorialAnimation(
                    type: anim_model.TutorialAnimationType.tap,
                    startPosition: Offset(screenWidth * 0.25, screenHeight * 0.85),  // 0.74 → 0.85로 조정
                    duration: const Duration(seconds: 1),
                    delay: const Duration(milliseconds: 500),
                  ),
                  // 중앙 버튼 (하트) 탭 - 더 아래로 조정
                  anim_model.TutorialAnimation(
                    type: anim_model.TutorialAnimationType.tap,
                    startPosition: Offset(screenWidth * 0.5, screenHeight * 0.85),  // 0.74 → 0.85로 조정
                    duration: const Duration(seconds: 1),
                    delay: const Duration(seconds: 2, milliseconds: 500),
                  ),
                  // 오른쪽 버튼 (별) 탭 - 더 아래로 조정
                  anim_model.TutorialAnimation(
                    type: anim_model.TutorialAnimationType.tap,
                    startPosition: Offset(screenWidth * 0.75, screenHeight * 0.85),  // 0.74 → 0.85로 조정
                    duration: const Duration(seconds: 1),
                    delay: const Duration(seconds: 4),
                  ),
                ],
                highlightArea: anim_model.HighlightArea(
                  left: screenWidth * 0.1,  // 0.15 → 0.1로 조정 (좀 더 넓게)
                  top: screenHeight * 0.80,  // 0.70 → 0.80으로 조정 (더 아래로)
                  width: screenWidth * 0.8,  // 0.7 → 0.8로 조정 (좀 더 넓게)
                  height: 100,  // 80 → 100으로 증가
                  borderRadius: BorderRadius.circular(40),
                  glowRadius: 20,
                ),
                stepDuration: const Duration(seconds: 8),
              ),
            ],
            // 레거시 텍스트 스텝 (백업용) - 3개로 축소
            tutorialSteps: [
              TutorialStep(
                title: '',
                description: '',
                messagePosition: Offset(0, 0),
              ),
              TutorialStep(
                title: '',
                description: '',
                messagePosition: Offset(0, 0),
              ),
              TutorialStep(
                title: '',
                description: '',
                messagePosition: Offset(0, 0),
              ),
            ],
          );
        },
      );
    }

    return scaffold;
  }
}