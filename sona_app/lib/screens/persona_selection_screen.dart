import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:animations/animations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth/auth_service.dart';
import '../services/persona/persona_service.dart';
import '../services/auth/device_id_service.dart';
import '../services/auth/user_service.dart';
import '../services/purchase/purchase_service.dart';
import '../services/storage/cache_manager.dart';
import '../services/cache/image_preload_service.dart';
import '../models/persona.dart';
import '../models/app_user.dart';
import '../widgets/persona/persona_card.dart';
import '../l10n/app_localizations.dart';
import '../widgets/tutorial/tutorial_overlay.dart';
import '../models/tutorial_animation.dart' as anim_model;
import '../widgets/common/sona_logo.dart';
import '../widgets/navigation/animated_action_button.dart';
import '../widgets/common/heart_usage_dialog.dart';
import '../theme/app_theme.dart';
import '../models/tip_data.dart';
import '../widgets/tutorial/tip_card.dart';
import 'dart:math';

class PersonaSelectionScreen extends StatefulWidget {
  const PersonaSelectionScreen({super.key});

  @override
  State<PersonaSelectionScreen> createState() => _PersonaSelectionScreenState();
}

class _PersonaSelectionScreenState extends State<PersonaSelectionScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  final CardSwiperController _cardController = CardSwiperController();
  late AnimationController _heartAnimationController;
  late AnimationController _passAnimationController;
  
  int _currentIndex = 0;
  bool _isLoading = false;
  bool _isFirstTimeUser = false;
  List<dynamic> _cardItems = []; // Personas와 Tips를 함께 담을 리스트
  final Random _random = Random();
  List<Persona>? _lastPersonas; // 이전 페르소나 리스트 추적
  bool _isPreparingCards = false; // 카드 준비 중 플래그
  String _cardsKey = ''; // 안정적인 카드 키를 위한 변수
  bool _isSwipeInProgress = false; // 스와이프 진행 중 플래그
  final Set<String> _processingPersonas = {}; // 처리 중인 페르소나 추적
  bool _isMatchDialogShowing = false; // 매칭 다이얼로그 표시 상태
  List<dynamic> _originalCardSet = []; // 원본 카드 세트 보관 (재셔플용)

  @override
  void initState() {
    super.initState();
    
    // Add observer for app lifecycle
    WidgetsBinding.instance.addObserver(this);
    
    _heartAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _passAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _loadPersonas();
      _checkFirstTimeUser();
    });
  }
  
  @override
  void dispose() {
    // Remove observer
    WidgetsBinding.instance.removeObserver(this);
    
    // 플래그 리셋
    _isPreparingCards = false;
    
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
  
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // App resumed from background
      debugPrint('🔄 App resumed');
      _loadPersonas();
      
      // 🆕 백그라운드에서 새로운 이미지 체크
      _checkForNewImagesInBackground();
    }
  }
  
  /// 백그라운드에서 새로운 이미지 체크
  Future<void> _checkForNewImagesInBackground() async {
    try {
      final personaService = Provider.of<PersonaService>(context, listen: false);
      final imagePreloadService = ImagePreloadService.instance;
      
      // R2 이미지가 있는 페르소나 목록
      final personasWithImages = personaService.allPersonas
          .where((p) => _hasR2Image(p))
          .toList();
      
      if (personasWithImages.isEmpty) return;
      
      // 새로운 이미지 체크
      final hasNewImages = await imagePreloadService.hasNewImages(personasWithImages);
      
      if (hasNewImages) {
        debugPrint('🆕 New images detected in background! Downloading...');
        // 백그라운드에서 조용히 다운로드
        await imagePreloadService.preloadNewImages(personasWithImages);
        debugPrint('✅ Background image download complete');
      }
    } catch (e) {
      debugPrint('❌ Error checking for new images in background: $e');
    }
  }
  
  Future<void> _checkFirstTimeUser() async {
    final isFirstTime = await CacheManager.instance.isFirstTimeUser();
    if (mounted) {
      setState(() {
        _isFirstTimeUser = isFirstTime;
      });
    }
  }

  /// 카드 세트를 셔플하고 재시작
  void _shuffleAndRestartCardSet() {
    if (_originalCardSet.isEmpty) {
      debugPrint('⚠️ No original card set to shuffle');
      return;
    }
    
    // 원본 세트를 복사하여 셔플
    _cardItems = List.from(_originalCardSet)..shuffle(_random);
    _cardsKey = DateTime.now().millisecondsSinceEpoch.toString(); // 새 키로 CardSwiper 리셋
    
    debugPrint('✨ Cards shuffled! Starting new round with ${_cardItems.length} cards');
    debugPrint('🎲 First 5 cards after shuffle:');
    for (int i = 0; i < 5 && i < _cardItems.length; i++) {
      final item = _cardItems[i];
      if (item is Persona) {
        debugPrint('   ${i+1}. Persona: ${item.name}');
      } else if (item is TipData) {
        debugPrint('   ${i+1}. Tip: ${item.title.substring(0, 20)}...');
      }
    }
  }
  
  // 매칭된 페르소나를 카드에서 제거
  void _removeMatchedPersonaFromCards(String personaId) {
    debugPrint('🗑️ Removing matched persona from cards: $personaId');
    
    // 현재 카드 리스트에서 제거
    _cardItems.removeWhere((item) {
      if (item is Persona) {
        return item.id == personaId;
      }
      return false;
    });
    
    // 원본 세트에서도 제거
    _originalCardSet.removeWhere((item) {
      if (item is Persona) {
        return item.id == personaId;
      }
      return false;
    });
    
    // UI 업데이트
    if (mounted) {
      setState(() {
        _cardsKey = DateTime.now().millisecondsSinceEpoch.toString();
      });
    }
    
    debugPrint('✅ Removed persona from cards. Remaining: ${_cardItems.length}');
  }

  // 카드 아이템 리스트 준비 (Personas + Tips)
  void _prepareCardItems(List<Persona> personas) {
    if (personas.isEmpty) {
      _cardItems = [];
      _cardsKey = '';
      return;
    }

    // 🔥 매칭된 페르소나 추가 필터링 - Firebase에서 최신 정보 확인
    final personaService = Provider.of<PersonaService>(context, listen: false);
    
    // 매칭된 페르소나가 아직 로드되지 않았다면 강제 로드
    if (!personaService.matchedPersonasLoaded) {
      debugPrint('⚠️ Matched personas not loaded yet in _prepareCardItems!');
      // 비동기로 로드 시작 (UI는 일단 진행)
      personaService.loadMatchedPersonasIfNeeded();
    }
    
    final matchedIds = personaService.matchedPersonas.map((p) => p.id).toSet();
    
    // 디버깅 정보 추가
    debugPrint('⏱️ [${DateTime.now().millisecondsSinceEpoch}] Preparing cards...');
    debugPrint('🔍 Checking matched personas:');
    debugPrint('   - Total matched personas: ${matchedIds.length}');
    debugPrint('   - Matched IDs: ${matchedIds.take(5).join(', ')}...');
    debugPrint('   - Input personas: ${personas.length}');
    
    final filteredPersonas = personas.where((p) => !matchedIds.contains(p.id)).toList();
    
    if (filteredPersonas.isEmpty) {
      debugPrint('⚠️ All available personas are already matched');
      _cardItems = [];
      _cardsKey = '';
      return;
    }
    
    debugPrint('🔥 Filtered out ${personas.length - filteredPersonas.length} already matched personas');
    debugPrint('✅ Remaining personas for cards: ${filteredPersonas.length}');

    // 중복 페르소나 체크
    final uniquePersonas = <String, Persona>{};
    for (final persona in filteredPersonas) {
      if (!uniquePersonas.containsKey(persona.id)) {
        uniquePersonas[persona.id] = persona;
      } else {
        debugPrint('⚠️ Duplicate persona found: ${persona.name} (ID: ${persona.id})');
      }
    }
    debugPrint('📊 Unique personas: ${uniquePersonas.length} (from ${filteredPersonas.length} filtered)');

    _cardItems = [];
    final tips = TipData.allTips;
    final usedTips = <TipData>[];
    
    // uniquePersonasList를 먼저 선언
    final uniquePersonasList = uniquePersonas.values.toList();
    
    // 최소 2~3개의 팁은 반드시 보여주기
    int insertedTipCount = 0;
    final targetTipCount = 2 + (_random.nextBool() ? 1 : 0); // 2 or 3
    
    // 팁 카드 삽입 위치를 미리 결정
    final guaranteedTipPositions = <int>[];
    if (uniquePersonasList.length >= 5) {
      guaranteedTipPositions.add(4); // 5번째 위치 (0,1,2,3,[TIP],4,...)
      if (uniquePersonasList.length >= 10) {
        guaranteedTipPositions.add(9); // 10번째 위치
      }
      if (uniquePersonasList.length >= 15) {
        guaranteedTipPositions.add(14); // 15번째 위치
      }
    }
    
    // 현재 추가된 아이템의 인덱스 추적
    int currentItemIndex = 0;
    
    for (int i = 0; i < uniquePersonasList.length; i++) {
      // 현재 위치가 팁 카드 위치인지 확인
      if (guaranteedTipPositions.contains(currentItemIndex) && 
          insertedTipCount < targetTipCount && 
          tips.length > usedTips.length) {
        // 팁 카드 삽입
        final availableTips = tips.where((tip) => !usedTips.contains(tip)).toList();
        if (availableTips.isNotEmpty) {
          final tipIndex = _random.nextInt(availableTips.length);
          final selectedTip = availableTips[tipIndex];
          usedTips.add(selectedTip);
          _cardItems.add(selectedTip);
          insertedTipCount++;
          currentItemIndex++;
          debugPrint('💡 Inserted tip at position $currentItemIndex: ${selectedTip.title.substring(0, 10)}...');
        }
      }
      
      // 페르소나 추가
      _cardItems.add(uniquePersonasList[i]);
      currentItemIndex++;
      
      // 추가 랜덤 팁 카드 (보장된 위치가 아닌 경우)
      if (i >= 5 && i < uniquePersonasList.length - 3 && // 마지막 3장에는 팁 넣지 않음
          insertedTipCount < targetTipCount && 
          tips.length > usedTips.length &&
          !guaranteedTipPositions.contains(currentItemIndex)) {
        // 20% 확률로 팁 카드 삽입
        if (_random.nextDouble() < 0.2) {
          final availableTips = tips.where((tip) => !usedTips.contains(tip)).toList();
          if (availableTips.isNotEmpty) {
            final tipIndex = _random.nextInt(availableTips.length);
            final selectedTip = availableTips[tipIndex];
            usedTips.add(selectedTip);
            _cardItems.add(selectedTip);
            insertedTipCount++;
            currentItemIndex++;
            debugPrint('💡 Inserted random tip at position $currentItemIndex: ${selectedTip.title.substring(0, 10)}...');
          }
        }
      }
    }
    
    // 만약 목표 팁 개수를 채우지 못했다면 마지막에 추가
    while (insertedTipCount < targetTipCount && tips.length > usedTips.length) {
      final availableTips = tips.where((tip) => !usedTips.contains(tip)).toList();
      if (availableTips.isNotEmpty) {
        final tipIndex = _random.nextInt(availableTips.length);
        final selectedTip = availableTips[tipIndex];
        usedTips.add(selectedTip);
        _cardItems.add(selectedTip);
        insertedTipCount++;
        debugPrint('💡 Added tip at end: ${selectedTip.title.substring(0, 10)}...');
      } else {
        break;
      }
    }
    
    // 원본 세트 저장 (재셔플용)
    _originalCardSet = List.from(_cardItems);
    
    // 첫 시작도 셔플
    _cardItems.shuffle(_random);
    
    // 안정적인 키 생성 - personas의 ID 조합으로 유니크한 키 생성
    _cardsKey = 'cards_${uniquePersonasList.map((p) => p.id.substring(0, 4)).join('_')}_${DateTime.now().millisecondsSinceEpoch}';
    
    debugPrint('🎴 Card set prepared: ${_cardItems.length} cards total');
    debugPrint('   - Personas: ${uniquePersonasList.length}');
    debugPrint('   - Tips: $insertedTipCount');
    debugPrint('📊 Cards shuffled and ready!');
    
    // 팁 카드 위치 확인 (디버깅용)
    final tipPositions = <int>[];
    final personaPositions = <String>[];
    for (int i = 0; i < _cardItems.length; i++) {
      if (_cardItems[i] is TipData) {
        tipPositions.add(i);
      } else if (_cardItems[i] is Persona) {
        final persona = _cardItems[i] as Persona;
        personaPositions.add('[$i] ${persona.name} (${persona.id.substring(0, 8)})');
      }
    }
    debugPrint('💡 Tip card positions: $tipPositions');
    debugPrint('👥 Persona positions: ${personaPositions.take(5).join(', ')}...');
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
    debugPrint('⏱️ [${DateTime.now().millisecondsSinceEpoch}] PersonaSelectionScreen starting persona load...');
    
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
    
    // 🔥 매칭된 페르소나 로드 완료 확인
    debugPrint('⏱️ [${DateTime.now().millisecondsSinceEpoch}] PersonaService initialization complete');
    debugPrint('📊 Matched personas count: ${personaService.matchedPersonas.length}');
    
    // 매칭된 페르소나 ID 로그 (디버깅)
    if (personaService.matchedPersonas.isNotEmpty) {
      debugPrint('🔍 Currently matched persona IDs:');
      for (final persona in personaService.matchedPersonas.take(5)) {
        debugPrint('   - ${persona.id}: ${persona.name}');
      }
    }
  }

  void _showTutorialExitDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            AppLocalizations.of(context)!.endTutorial,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFF6B9D),
            ),
            textAlign: TextAlign.center,
          ),
          content: Text(
            AppLocalizations.of(context)!.endTutorialMessage,
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black87,
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
                    child: Text(
            AppLocalizations.of(context)!.cancel,
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
          SnackBar(
            content: Text(AppLocalizations.of(context)!.loginFailed),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.loginComplete),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }


  bool _onSwipe(int previousIndex, int? currentIndex, CardSwiperDirection direction) {
    // 스와이프가 진행 중이면 무시
    if (_isSwipeInProgress) {
      debugPrint('⚠️ Swipe already in progress, ignoring');
      return false;
    }
    
    debugPrint('🎯 Swipe detected: previousIndex=$previousIndex, currentIndex=$currentIndex, direction=$direction');
    debugPrint('📊 Card items length: ${_cardItems.length}');
    
    // 스와이프 방향이 null이거나 유효하지 않은 경우 (취소된 경우)
    if (direction == null) {
      debugPrint('❌ Swipe cancelled');
      return true; // 스와이프를 허용하여 다음 카드로 이동
    }
    
    // 스와이프 진행 중 플래그 설정
    _isSwipeInProgress = true;
    
    if (previousIndex >= 0 && previousIndex < _cardItems.length) {
      final item = _cardItems[previousIndex];
      
      // Tip 카드인 경우 - 어떤 방향으로든 스와이프 허용, 매칭 처리 없음
      if (item is TipData) {
        debugPrint('💡 Tip card swiped: ${item.title}');
        // Tip 카드는 그냥 넘어가기만 함
      } else if (item is Persona) {
        // 페르소나 카드인 경우 - 기존 로직대로 처리
        debugPrint('🎯 Persona at index $previousIndex: ${item.name} (ID: ${item.id})');
        
        if (direction == CardSwiperDirection.right) {
          debugPrint('💕 Right swipe - Liking persona: ${item.name} (ID: ${item.id})');
          _onPersonaLiked(item, isSuperLike: false);
        } else if (direction == CardSwiperDirection.left) {
          debugPrint('👈 Left swipe - Passing persona: ${item.name} (ID: ${item.id})');
          _onPersonaPassed(item);
        } else if (direction == CardSwiperDirection.top) {
          debugPrint('⭐ Top swipe - Super liking persona: ${item.name} (ID: ${item.id})');
          _onPersonaLiked(item, isSuperLike: true);
        }
      }
    } else {
      debugPrint('❌ Index out of bounds: $previousIndex (total: ${_cardItems.length})');
    }
    
    // currentIndex 업데이트 - 즉시 업데이트하여 UI 반응성 향상
    if (currentIndex != null && mounted) {
      setState(() {
        _currentIndex = currentIndex;
      });
    }
    
    // 스와이프 진행 플래그 해제 (짧은 지연 후)
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _isSwipeInProgress = false;
      }
    });
    
    return true; // Always allow swipe to proceed
  }

  /// Check if persona has valid R2 image
  bool _hasR2Image(Persona persona) {
    if (persona.imageUrls == null || persona.imageUrls!.isEmpty) {
      return false;
    }
    
    // Check if any value in the map contains R2 domains
    final r2Pattern = RegExp(r'(teamsona\.work|r2\.dev|cloudflare|imagedelivery\.net)');
    
    bool checkMap(Map<String, dynamic> map) {
      for (final value in map.values) {
        if (value is String && r2Pattern.hasMatch(value)) {
          return true;
        } else if (value is Map) {
          if (checkMap(Map<String, dynamic>.from(value))) {
            return true;
          }
        }
      }
      return false;
    }
    
    return checkMap(persona.imageUrls!);
  }

  void _onPersonaLiked(Persona persona, {bool isSuperLike = false}) async {
    if (!mounted) return;
    
    // 이미 처리 중인 페르소나인지 확인
    if (_processingPersonas.contains(persona.id)) {
      debugPrint('⚠️ Already processing persona: ${persona.name} (ID: ${persona.id})');
      return;
    }
    _processingPersonas.add(persona.id);
    
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
    
    // 라이크/슈퍼라이크 모두 매칭을 지연시키고 다이얼로그에서 처리
    try {
      // 스와이프만 마킹하고 매칭은 하지 않음
      await personaService.markPersonaAsSwiped(persona.id);
      if (mounted) {
        _showMatchDialog(persona, isSuperLike: isSuperLike);
      }
    } catch (e) {
      debugPrint('❌ Error marking persona as swiped: $e');
      // 에러가 발생해도 다이얼로그 표시 (UX)
      if (mounted) {
        _showMatchDialog(persona, isSuperLike: isSuperLike);
      }
    } finally {
      // 처리 완료 후 목록에서 제거
      _processingPersonas.remove(persona.id);
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
    // 🔥 이미 매칭된 페르소나인지 확인
    final personaService = Provider.of<PersonaService>(context, listen: false);
    if (personaService.matchedPersonas.any((p) => p.id == persona.id)) {
      debugPrint('⚠️ Already matched with ${persona.name} - showing warning');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${persona.name}님과는 이미 대화중이에요!'),
          backgroundColor: Colors.orange,
          duration: const Duration(seconds: 3),
        ),
      );
      return;
    }
    
    // 🔧 FIX: 메인 화면의 context를 미리 저장
    final BuildContext screenContext = context;
    
    // 매칭 다이얼로그 표시 상태 업데이트
    setState(() => _isMatchDialogShowing = true);
    
    // 전문가 기능 제거됨
    
    showModal<void>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: 340,
              maxHeight: MediaQuery.of(context).size.height * 0.8, // 화면 높이의 80%로 동적 조정
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFFF6B9D), Color(0xFFFF8FA3)],
              ),
            ),
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(), // 스크롤 물리 효과 개선
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      isSuperLike
                          ? '💫 슈퍼 라이크 매칭! 💫'
                          : '✨ 매칭 성공! ✨',
                      style: const TextStyle(
                        fontSize: 22, // 24 -> 22
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12), // 16 -> 12

                    // 소나 프로필 이미지
                    Container(
                      width: 90, // 100 -> 90
                      height: 90, // 100 -> 90
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
                    const SizedBox(height: 12), // 16 -> 12

                    Text(
                      isSuperLike
                          ? '${persona.name}님이 당신을\n특별히 좋아해요! 💕'
                          : '${persona.name}님과 매칭되었어요!',
                      style: const TextStyle(
                        fontSize: 16, // 18 -> 16
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6), // 8 -> 6

                    Text(
                      isSuperLike
                          ? '특별한 인연의 시작! 소나가 당신을 기다리고 있어요 💫'
                          : '소나와 친구처럼 대화를 시작해보세요 💕',
                      style: const TextStyle(
                        fontSize: 13, // 14 -> 13
                        color: Colors.white70,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20), // 24 -> 20

                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () async {
                              Navigator.of(context).pop();

                              // Super like의 경우에도 나중에 버튼에서는 매칭 처리하지 않음
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: const BorderSide(color: Colors.white),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 10), // 버튼 패딩 조정
                            ),
                            child: const Text('나중에'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              if (isSuperLike) {
                                // Super like인 경우 팝업 없이 바로 처리
                                Navigator.of(context).pop(); // Close match dialog first

                                setState(() => _isLoading = true);
                                
                                try {
                                  final personaService = Provider.of<PersonaService>(screenContext, listen: false);
                                  final authService = Provider.of<AuthService>(screenContext, listen: false);
                                  final purchaseService = Provider.of<PurchaseService>(screenContext, listen: false);
                                  
                                  final userId = authService.user?.uid ?? await DeviceIdService.getDeviceId();
                                  
                                  // 하트 5개 차감
                                  final hasEnoughHearts = await purchaseService.useHearts(5);
                                  if (!hasEnoughHearts) {
                                    ScaffoldMessenger.of(screenContext).showSnackBar(
                                      const SnackBar(content: Text('하트가 부족합니다.')),
                                    );
                                    setState(() => _isLoading = false);
                                    return;
                                  }
                                  
                                  // 매칭 처리
                                  final matchSuccess = await personaService.matchWithPersona(persona.id, isSuperLike: true);

                                  if (matchSuccess) {
                                    debugPrint('✅ Super like matching complete: ${persona.name}');
                                    // 매칭 성공 시 카드에서 즉시 제거
                                    _removeMatchedPersonaFromCards(persona.id);
                                    await _navigateToChat(persona, screenContext, true);
                                  } else {
                                    debugPrint('❌ Super like matching failed: ${persona.name}');
                                    ScaffoldMessenger.of(screenContext).showSnackBar(
                                      const SnackBar(content: Text('매칭에 실패했습니다.')),
                                    );
                                  }
                                } catch (e) {
                                  debugPrint('❌ Error in super like matching: $e');
                                  ScaffoldMessenger.of(screenContext).showSnackBar(
                                    const SnackBar(content: Text('오류가 발생했습니다.')),
                                  );
                                } finally {
                                  setState(() => _isLoading = false);
                                }
                              } else {
                                // 일반 like도 하트 1개 차감 후 매칭 처리
                                Navigator.of(context).pop();

                                setState(() => _isLoading = true);

                                try {
                                  final personaService = Provider.of<PersonaService>(screenContext, listen: false);
                                  final authService = Provider.of<AuthService>(screenContext, listen: false);
                                  final purchaseService = Provider.of<PurchaseService>(screenContext, listen: false);
                                  
                                  final userId = authService.user?.uid ?? await DeviceIdService.getDeviceId();

                                  // 하트 1개 차감
                                  final hasEnoughHearts = await purchaseService.useHearts(1);
                                  if (!hasEnoughHearts) {
                                    ScaffoldMessenger.of(screenContext).showSnackBar(
                                      const SnackBar(content: Text('하트가 부족합니다.')),
                                    );
                                    setState(() => _isLoading = false);
                                    return;
                                  }

                                  // 매칭 처리
                                  final matchSuccess = await personaService.matchWithPersona(persona.id, isSuperLike: false);

                                  if (matchSuccess) {
                                    debugPrint('✅ Normal like matching complete: ${persona.name}');
                                    // 매칭 성공 시 카드에서 즉시 제거
                                    _removeMatchedPersonaFromCards(persona.id);
                                    await _navigateToChat(persona, screenContext, false);
                                  } else {
                                    debugPrint('❌ Normal like matching failed: ${persona.name}');
                                    ScaffoldMessenger.of(screenContext).showSnackBar(
                                      const SnackBar(content: Text('매칭에 실패했습니다.')),
                                    );
                                  }
                                } catch (e) {
                                  debugPrint('❌ Error in normal like: $e');
                                  ScaffoldMessenger.of(screenContext).showSnackBar(
                                    const SnackBar(content: Text('오류가 발생했습니다.')),
                                  );
                                } finally {
                                  setState(() => _isLoading = false);
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: const Color(0xFFFF6B9D),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10), // 패딩 조정
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (isSuperLike) ...[
                                  const Text('💖×5 ', style: TextStyle(fontSize: 14)), // 16 -> 14
                                ] else ...[
                                  const Text('💖×1 ', style: TextStyle(fontSize: 14)), // 16 -> 14
                                ],
                                const Text(
                                  '채팅 시작',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14), // 15 -> 14
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    ],
                ),
              ),
            ),
          ),
        );
      },
    ).then((_) {
      // 다이얼로그가 닫힐 때 상태 업데이트
      if (mounted) {
        setState(() => _isMatchDialogShowing = false);
      }
    });
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
      
      // 실제 매칭 처리는 이미 버튼 클릭 시 처리되었으므로 여기서는 생략
      // final matchSuccess = await personaService.matchWithPersona(persona.id, isSuperLike: isSuperLike);
      // debugPrint('✅ Match result: $matchSuccess for ${persona.name}');
      
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
                  // currentRelationship: RelationshipType.crush, // RelationshipType 정의 필요
                  imageUrls: persona.imageUrls,  // Preserve imageUrls
                )
              : persona.copyWith(
                  relationshipScore: 50, 
                  // currentRelationship: RelationshipType.friend, // RelationshipType 정의 필요
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
          
          // 카드 아이템 리스트 준비 (Personas + Tips) - 무한 루프 방지
          if (!_isPreparingCards && (!listEquals(_lastPersonas, personas) || _cardItems.isEmpty)) {
            _isPreparingCards = true;
            _lastPersonas = List.from(personas); // 새 List 인스턴스로 복사
            debugPrint('🔄 Personas changed, preparing ${personas.length} personas...');
            
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted && _isPreparingCards) {
                setState(() {
                  _prepareCardItems(personas);
                  _isPreparingCards = false;
                });
              }
            });
          }
          
          // CardSwiper는 최소 1개의 카드가 필요하므로 빈 배열 체크
          if (_cardItems.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFFFF6B9D),
              ),
            );
          }

          return Stack(
            children: [
              Column(
                children: [
                  // 메인 카드 스택
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: _cardItems.isNotEmpty
                        ? CardSwiper(
                        key: ValueKey(_cardsKey), // 안정적인 키 사용
                        controller: _cardController,
                        cardsCount: _cardItems.length,
                    onSwipe: _onSwipe,
                    onEnd: () {
                      // 세트가 끝났을 때 셔플 후 재시작
                      debugPrint('🔄 Card set completed, shuffling and restarting...');
                      setState(() {
                        _shuffleAndRestartCardSet();
                      });
                    },
                    numberOfCardsDisplayed: _cardItems.length >= 2 ? 2 : _cardItems.length,
                    backCardOffset: const Offset(0, -20),
                    padding: const EdgeInsets.all(8),
                    allowedSwipeDirection: const AllowedSwipeDirection.only(
                      left: true,
                      right: true,
                      up: true, // 모든 카드에 대해 위로 스와이프 허용
                      down: false,
                    ),
                    // 스와이프 임계값 조정 - 더 낮은 값으로 설정하여 쉽게 스와이프되도록 함
                    threshold: 30, // 기본값 50에서 30으로 감소
                    scale: 0.9, // 뒤 카드 크기
                    isLoop: true, // 무한 루프 활성화
                    duration: const Duration(milliseconds: 150), // 스와이프 애니메이션 시간 더 단축
                    maxAngle: 20, // 최대 회전 각도 감소
                    isDisabled: false,
                    onUndo: (previousIndex, currentIndex, direction) {
                      // 스와이프 취소 시 처리
                      debugPrint('⏪ Undo detected: prev=$previousIndex, curr=$currentIndex');
                      // 취소 시에도 상태 업데이트
                      if (mounted && currentIndex != null) {
                        setState(() {
                          _currentIndex = currentIndex;
                        });
                      }
                      return true;
                    },
                    cardBuilder: (context, index, horizontalThresholdPercentage, verticalThresholdPercentage) {
                      // index 범위 검사
                      if (index < 0 || index >= _cardItems.length) {
                        debugPrint('⚠️ Card builder index out of bounds: $index (total: ${_cardItems.length})');
                        return const SizedBox.shrink();
                      }

                      final item = _cardItems[index];

                      // Tip 카드인 경우
                      if (item is TipData) {
                        return TipCard(
                          key: ValueKey('tip_${item.title}'),
                          tipData: item,
                        );
                      }
                      // Persona 카드인 경우
                      else if (item is Persona) {
                        return PersonaCard(
                          key: ValueKey(item.id),
                          persona: item,
                          horizontalThresholdPercentage: horizontalThresholdPercentage.toDouble(),
                          verticalThresholdPercentage: verticalThresholdPercentage.toDouble(),
                          isEnabled: !_isMatchDialogShowing,
                        );
                      }

                      return const SizedBox.shrink();
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
                    
                    // Super Like 버튼
                    AnimatedActionButton(
                      onTap: _isLoading ? null : _onSuperLikePressed,
                      size: 70,
                      gradientColors: [const Color(0xFF00BCD4), const Color(0xFF2196F3)],
                      shadowColor: const Color(0xFF2196F3),
                      icon: Icons.star_rounded,
                      iconSize: 35,
                      tooltip: 'Super Like (바로 사랑 단계)',
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
            ),
            // R2 validation indicator
            if (personaService.isValidatingR2)
              Positioned(
                bottom: 100,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          '더 많은 카드 로딩 중...',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
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