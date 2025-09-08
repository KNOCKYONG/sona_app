import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/persona.dart';
import '../../models/app_user.dart';
import '../auth/device_id_service.dart';
import '../auth/user_service.dart';
import '../base/base_service.dart';
import '../../helpers/firebase_helper.dart';
import '../../core/constants.dart';
import '../../core/preferences_manager.dart';
import '../relationship/relation_score_service.dart';
import 'r2_validation_cache.dart';
import '../cache/image_preload_service.dart';
import '../storage/guest_conversation_service.dart';
import '../block_service.dart';
import '../purchase/purchase_service.dart';
import 'dart:convert';

/// 🚀 Optimized Persona Service with Performance Enhancements
///
/// Key optimizations:
/// 1. Intelligent caching with TTL
/// 2. Batch operations for Firebase
/// 3. Lazy loading for matched personas
/// 4. Memory-efficient data structures
/// 5. Parallel data fetching
class PersonaService extends BaseService {
  String? _currentUserId;

  // Data storage with caching
  List<Persona> _allPersonas = [];
  List<Persona> _matchedPersonas = [];
  Persona? _currentPersona;
  bool? _currentPersonaCasualSpeech; // 현재 페르소나의 반말 모드 별도 저장

  // Stable shuffled list for swipe session
  List<Persona>? _shuffledAvailablePersonas;
  DateTime? _lastShuffleTime;

  // Caching system
  final Map<String, _CachedRelationship> _relationshipCache = {};
  static const Duration _cacheTTL = Duration(hours: 24);
  static const int _maxCacheSize = 100;

  // Memory cache for persona data - Extended TTL for better performance
  final Map<String, Persona> _personaMemoryCache = {};
  DateTime? _lastPersonaCacheUpdate;
  static const Duration _memoryCacheTTL = Duration(minutes: 30);  // Extended from 1 minute

  // Batch operation queue
  final List<_PendingRelationshipUpdate> _pendingUpdates = [];
  Timer? _batchUpdateTimer;
  static const Duration _batchUpdateDelay = Duration(seconds: 2);
  static const int _maxBatchSize = 10;

  // Session data
  final Map<String, DateTime> _sessionSwipedPersonas = {};

  // R2 validation state
  final Set<String> _r2ValidatedPersonaIds = {};
  bool _isValidatingR2 = false;
  Timer? _r2ValidationTimer;

  // Midnight refresh timer
  Timer? _midnightRefreshTimer;
  DateTime? _lastRefreshDate;

  // Lazy loading state
  bool _matchedPersonasLoaded = false;
  Completer<void>? _loadingCompleter;

  // Public getter for matched personas loaded state
  bool get matchedPersonasLoaded => _matchedPersonasLoaded;
  
  // Block service instance
  final BlockService _blockService = BlockService();

  // Progressive loading for initial fast display
  List<Persona> get availablePersonasProgressive {
    _cleanExpiredSwipes();

    // 매칭된 페르소나가 로드되지 않았다면 먼저 로드
    if (!_matchedPersonasLoaded) {
      _lazyLoadMatchedPersonas();
    }

    // Return immediately without R2 check
    return _getImmediateAvailablePersonas();
  }

  // Original getter with R2 validation
  List<Persona> get availablePersonas {
    _cleanExpiredSwipes();

    // 매칭된 페르소나가 로드되지 않았다면 먼저 로드
    if (!_matchedPersonasLoaded) {
      _lazyLoadMatchedPersonas();
    }

    // Check if we need to reshuffle (every 30 minutes or if list is null)
    final now = DateTime.now();
    final shouldReshuffle = _shuffledAvailablePersonas == null ||
        _lastShuffleTime == null ||
        now.difference(_lastShuffleTime!).inMinutes >= 30;

    if (shouldReshuffle) {
      // Reshuffling personas: Total=${_allPersonas.length}, Matched=${_matchedPersonas.length}
      final personasWithR2 = _allPersonas.where((p) => _hasR2Image(p)).length;

      // Exclude both recently swiped and matched personas
      final matchedIds = _matchedPersonas.map((p) => p.id).toSet();

      // Excluding matched persona IDs: ${matchedIds.length}

      // 🔥 무한 스와이프 - 매칭된 페르소나만 제외
      // 커스텀 페르소나는 다음 조건일 때만 표시:
      // 1. 시스템 페르소나 (isCustom = false)
      // 2. 공개 승인된 페르소나 (isShare = true & isConfirm = true)
      // 3. 자신이 만든 페르소나 (createdBy = currentUserId)
      final filtered = _allPersonas
          .where((persona) =>
                  !matchedIds.contains(persona.id) &&
                  !_actionedPersonaIds.contains(persona.id) &&
                  // 커스텀 페르소나 필터링
                  (!persona.isCustom || // 시스템 페르소나는 모두 표시
                   (persona.isShare && persona.isConfirm) || // 공개 승인된 커스텀 페르소나
                   persona.createdBy == _currentUserId) // 자신이 만든 페르소나
              // 최근 스와이프 필터 제거 - 무한 스와이프
              // R2 필터링 제거 - 모든 페르소나 표시
              )
          .toList();

      // Filtering: Available=${filtered.length} from Total=${_allPersonas.length}

      // Filter stats calculated

      // Get recommended personas for current user (includes gender filtering)
      final recommendedPersonas = getRecommendedPersonas(filtered);
      _shuffledAvailablePersonas = recommendedPersonas;
      _lastShuffleTime = now;

      debugPrint('📊 Personas after gender filter: ${recommendedPersonas.length} from ${filtered.length}');
    } else {
      // Update the existing shuffled list to exclude newly swiped/matched personas
      final matchedIds = _matchedPersonas.map((p) => p.id).toSet();
      _shuffledAvailablePersonas = _shuffledAvailablePersonas!
          .where((persona) =>
                  !_isPersonaRecentlySwiped(persona.id) &&
                  !matchedIds.contains(persona.id) &&
                  (persona.isCustom || _hasR2Image(persona)) // Allow custom personas even without R2 images
              )
          .toList();
    }

    return List<Persona>.from(_shuffledAvailablePersonas!);
  }

  List<Persona> get allPersonas => _allPersonas;

  /// Get persona by ID with memory caching
  Persona? getPersonaById(String personaId) {
    // Check memory cache first
    if (_personaMemoryCache.containsKey(personaId)) {
      final cached = _personaMemoryCache[personaId];
      // Return cached if less than 30 minutes old (extended for better performance)
      if (_lastPersonaCacheUpdate != null &&
          DateTime.now().difference(_lastPersonaCacheUpdate!) < _memoryCacheTTL) {
        return cached;
      }
    }

    // Look in all personas list
    Persona? persona;
    try {
      persona = _allPersonas.firstWhere((p) => p.id == personaId);
    } catch (e) {
      try {
        persona = _matchedPersonas.firstWhere((p) => p.id == personaId);
      } catch (e) {
        persona = null;
      }
    }

    // Cache the result if found
    if (persona != null && persona.id != '') {
      _personaMemoryCache[personaId] = persona;
      _lastPersonaCacheUpdate = DateTime.now();

      // Clean cache if too large
      if (_personaMemoryCache.length > 50) {
        final keysToRemove = _personaMemoryCache.keys.take(10).toList();
        for (final key in keysToRemove) {
          _personaMemoryCache.remove(key);
        }
      }
    }

    return persona;
  }

  List<Persona> get matchedPersonas {
    if (!_matchedPersonasLoaded) {
      _lazyLoadMatchedPersonas();
    }
    // Allow custom personas even without R2 images
    // Only filter out system personas without R2 images
    return _matchedPersonas.where((persona) {
      // Custom personas created by users are always shown
      if (persona.isCustom) {
        return true;
      }
      // System personas must have R2 images
      return _hasR2Image(persona);
    }).toList();
  }

  Persona? get currentPersona => _currentPersona;
  bool? get currentPersonaCasualSpeech => _currentPersonaCasualSpeech;
  String? get currentUserId => _currentUserId;
  @override
  bool get isLoading => super.isLoading;
  int get swipedPersonasCount => _sessionSwipedPersonas.length;
  bool get isValidatingR2 => _isValidatingR2;

  /// 실제 대기 중인 페르소나 수 (전체에서 매칭된/액션된 페르소나 제외)
  int get waitingPersonasCount {
    debugPrint('📊 Calculating waitingPersonasCount...');
    debugPrint('  Total personas: ${_allPersonas.length}');

    // 전체 페르소나 중 R2 이미지가 있거나 커스텀 페르소나인 것
    final totalWithImages =
        _allPersonas.where((persona) => persona.isCustom || _hasR2Image(persona)).toList();
    debugPrint('  Personas with R2 images: ${totalWithImages.length}');

    // 성별 필터링 적용 (게스트는 필터링 없음)
    List<Persona> filteredPersonas = totalWithImages;
    final isGuestUser = _isGuestUserSync();
    
    if (_currentUser != null &&
        !isGuestUser && // Guest users see all personas
        !_currentUser!.genderAll &&
        _currentUser!.gender != null) {
      final targetGender = _currentUser!.gender == 'male' ? 'female' : 'male';
      filteredPersonas = totalWithImages
          .where((persona) => persona.gender == targetGender)
          .toList();
      debugPrint(
          '  After gender filter (showing $targetGender only): ${filteredPersonas.length}');
    } else {
      debugPrint(
          '  No gender filter applied (genderAll: ${_currentUser?.genderAll}, isGuest: $isGuestUser)');
    }

    // 매칭된 페르소나 ID 목록
    final matchedIds = _matchedPersonas.map((p) => p.id).toSet();
    // Matched personas: ${matchedIds.length}

    // 액션된 페르소나 ID 목록 (매칭, 패스 등 모든 액션)
    final actionedIds = _actionedPersonaIds.toSet();
    // Actioned personas: ${actionedIds.length}

    // 전체에서 매칭되거나 액션된 페르소나 제외
    final waitingPersonas = filteredPersonas
        .where((persona) =>
            !matchedIds.contains(persona.id) &&
            !actionedIds.contains(persona.id))
        .toList();

    debugPrint('  ✅ Final waiting personas: ${waitingPersonas.length}');

    return waitingPersonas.length;
  }

  // Additional getters for compatibility
  List<Persona> get sessionPersonas => _matchedPersonas;
  List<Persona> get myPersonas => _matchedPersonas;

  /// Initialize service with parallel loading
  Future<void> initialize({
    String? userId,
    bool forceRefresh = false,
    Function(double progress, String message)? onProgress,
  }) async {
    // Initialize block service with user ID
    if (userId != null && userId.isNotEmpty) {
      await _blockService.initialize(userId);
    }
    
    // Allow reinitialization if data is empty or previous attempt failed
    if (_loadingCompleter != null && !_loadingCompleter!.isCompleted) {
      return _loadingCompleter!.future;
    }
    
    // Reset completer if previous initialization failed or data is empty
    if (_loadingCompleter != null && _loadingCompleter!.isCompleted) {
      if (_allPersonas.isEmpty) {
        debugPrint('🔄 Resetting completer for reinitialization (empty data)');
        _loadingCompleter = null;
      }
    }

    _loadingCompleter = Completer<void>();

    await executeWithLoading(() async {
      await _initializeNormalMode(userId, forceRefresh, onProgress);

      _loadingCompleter!.complete();
    }, errorContext: 'initialize', showError: false);
  }

  /// Normal mode initialization with parallel loading
  Future<void> _initializeNormalMode(
    String? userId,
    bool forceRefresh,
    Function(double progress, String message)? onProgress,
  ) async {
    _currentUserId = await DeviceIdService.getCurrentUserId(
      firebaseUserId: userId,
    );

    debugPrint('🚀 PersonaService initializing with userId: $_currentUserId');
    
    // Ensure Firebase Auth token is refreshed for new users
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await user.getIdToken(true); // Force token refresh
        debugPrint('✅ Firebase Auth token refreshed for user: ${user.uid}');
      } catch (e) {
        debugPrint('⚠️ Failed to refresh Firebase Auth token: $e');
      }
    }

    // isLoading is managed by BaseService
    notifyListeners();

    // Report progress: Loading all personas first
    onProgress?.call(0.1, 'loadingPersonaData');

    // 🔥 먼저 모든 페르소나 데이터를 로드
    debugPrint(
        '⏱️ [${DateTime.now().millisecondsSinceEpoch}] Starting all personas load...');
    
    // Force refresh면 캐시 무시하고 Firebase에서 로드
    if (forceRefresh) {
      debugPrint('🔄 Force refresh enabled - loading from Firebase directly');
      await _loadPersonasFromFirebase();
    } else {
      await _loadFromFirebaseOrFallback();
    }
    
    debugPrint(
        '⏱️ [${DateTime.now().millisecondsSinceEpoch}] All personas loaded: ${_allPersonas.length}');

    // Report progress: Loading matched personas
    onProgress?.call(0.3, 'checkingMatchedPersonas');

    // 이제 _allPersonas가 로드된 후 매칭된 페르소나 로드
    final results = await Future.wait([
      _loadMatchedPersonas(),
      _loadSwipedPersonas(),
      _loadActionedPersonaIds(),
    ]);
    
    _matchedPersonasLoaded = true;
    debugPrint(
        '⏱️ [${DateTime.now().millisecondsSinceEpoch}] Matched personas loaded: ${_matchedPersonas.length}');

    // Report progress: Checking images
    onProgress?.call(0.7, 'preparingImages');

    // 🆕 Check and download new images in background (don't wait)
    checkAndDownloadNewImages().then((_) {
      debugPrint('✅ Background image check complete');
    }).catchError((error) {
      debugPrint('⚠️ Background image check error (ignored): $error');
    });

    // Report progress: Final preparation
    onProgress?.call(0.9, 'finalPreparation');

    // Skip image preloading here - will be done in PersonaSelectionScreen
    // This speeds up initial loading significantly

    // Report completion
    onProgress?.call(1.0, 'complete');

    // isLoading is managed by BaseService
    notifyListeners();
  }

  /// Load personas from cache first, then Firebase with fallback
  Future<void> _loadFromFirebaseOrFallback() async {
    // Try to load from local cache first
    await _loadPersonasFromCache();

    // If cache is empty or stale, load from Firebase
    if (_allPersonas.isEmpty || await _isCacheStale()) {
      await _loadPersonasFromFirebase();
    }
  }

  /// Lazy load matched personas
  Future<void> _lazyLoadMatchedPersonas() async {
    if (_matchedPersonasLoaded || _currentUserId == null) return;

    // Don't set the flag to true until loading succeeds
    try {
      await _loadMatchedPersonas();
      _matchedPersonasLoaded = true;
      debugPrint('✅ Matched personas loaded successfully');
    } catch (e) {
      debugPrint('❌ Error lazy loading matched personas: $e');
      // Reset the flag so it can be retried
      _matchedPersonasLoaded = false;
      // Clear any partial data
      _matchedPersonas = [];
    }
  }

  /// Public method to load matched personas if needed
  Future<void> loadMatchedPersonasIfNeeded() async {
    if (!_matchedPersonasLoaded) {
      await _lazyLoadMatchedPersonas();
    }
  }

  /// Set current persona with cached relationship data
  Future<void> setCurrentPersona(Persona persona, {bool clearPrevious = true}) async {
    // Only clear previous persona when actually switching to a different one
    if (_currentPersona?.id != persona.id) {
      debugPrint('🔄 Switching from ${_currentPersona?.name} to ${persona.name}');
      
      // Only clear if we're actually switching personas in ChatScreen
      // Don't clear when navigating back to chat_list_screen
      if (clearPrevious) {
        _currentPersona = null;
        _currentPersonaCasualSpeech = false;
        notifyListeners(); // Immediate UI update to clear old data
        
        // Small delay to ensure UI is cleared
        await Future.delayed(const Duration(milliseconds: 50));
      }
    }
    
    if (_currentUserId != null) {
      // Check cache first
      final cachedRelationship = _getFromCache(persona.id);

      if (cachedRelationship != null) {
        _currentPersona = persona.copyWith(
          likes: cachedRelationship.score,
          imageUrls: persona.imageUrls, // Preserve imageUrls
        );
        _currentPersonaCasualSpeech = cachedRelationship.isCasualSpeech;
        debugPrint('✅ Loaded ${persona.name} from cache (likes: ${cachedRelationship.score})');
        notifyListeners();
        return;
      }

      // Load from Firebase if not cached
      final relationshipData = await _loadUserPersonaRelationship(persona.id);
      if (relationshipData != null) {
        final likes = relationshipData['likes'] ??
            relationshipData['relationshipScore'] ?? 50;
        _currentPersona = persona.copyWith(
          likes: likes,
          imageUrls: persona.imageUrls, // Preserve imageUrls
        );
        _currentPersonaCasualSpeech =
            relationshipData['isCasualSpeech'] ?? false;

        // Cache the relationship
        _addToCache(
            persona.id,
            _CachedRelationship(
              score: likes,
              isCasualSpeech: relationshipData['isCasualSpeech'] ?? false,
              timestamp: DateTime.now(),
            ));
        debugPrint('✅ Loaded ${persona.name} from Firebase (likes: $likes)');
      } else {
        _currentPersona = persona;
        _currentPersonaCasualSpeech = false; // 기본값
        debugPrint('✅ Set ${persona.name} with default values');
      }
    } else {
      _currentPersona = persona;
      _currentPersonaCasualSpeech = false; // 기본값
      debugPrint('✅ Set ${persona.name} for guest user');
    }
    notifyListeners();
  }

  /// Optimized persona like with batch operations
  Future<bool> likePersona(String personaId, {Persona? personaObject, PurchaseService? purchaseService}) async {
    if (_currentUserId == null) {
      _currentUserId = await DeviceIdService.getTemporaryUserId();
    }

    if (_currentUserId == '') {
      debugPrint('⚠️ No user ID available for liking persona');
      return false;
    }

    try {
      // Use provided persona object or find it in _allPersonas
      Persona? persona = personaObject;
      if (persona == null) {
        persona = _allPersonas.where((p) => p.id == personaId).firstOrNull;
        if (persona == null) {
          debugPrint('⚠️ Persona not found for liking: $personaId');
          return false;
        }
      }

      // 하트 1개 소모 (이미 매칭된 경우는 제외)
      if (!_matchedPersonas.any((p) => p.id == personaId)) {
        if (purchaseService != null) {
          final heartConsumed = await purchaseService.useHearts(1);
          if (!heartConsumed) {
            debugPrint('❌ Failed to consume heart for liking persona: $personaId');
            return false;
          }
          debugPrint('💕 Successfully consumed 1 heart for liking persona: $personaId');
        } else {
          debugPrint('⚠️ PurchaseService not provided, skipping heart consumption');
        }
      }

      // 재매칭 시 leftChat 플래그 리셋
      final currentUser = FirebaseAuth.instance.currentUser;
      final isGuest = currentUser?.isAnonymous ?? false;
      
      if (isGuest) {
        // Guest mode: Clear ALL previous conversation data for fresh start
        await GuestConversationService.instance.clearGuestConversationForPersona(personaId);
        await GuestConversationService.instance.setLeftChatStatus(personaId, false);
        debugPrint('🔓 [PersonaService] Guest conversation data completely cleared for fresh start with persona: $personaId');
      } else {
        // Regular user: Reset in Firebase
        await FirebaseFirestore.instance
            .collection('users')
            .doc(_currentUserId!)
            .collection('chats')
            .doc(personaId)
            .set({
          'leftChat': false,
          'rejoinedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
        debugPrint('☁️ [PersonaService] User leftChat status reset in Firebase for persona: $personaId');
      }
      
      // Create relationship data
      final relationshipData = {
        'userId': _currentUserId!,
        'personaId': personaId,
        'likes': 50,
        'isCasualSpeech': false,
        'swipeAction': 'like',
        'isMatched': true,
        'isActive': true,
        'matchedAt': FieldValue.serverTimestamp(),
        'createdAt': FieldValue.serverTimestamp(),
        'lastInteraction': FieldValue.serverTimestamp(),
        'personaName': persona.name,
        'personaAge': persona.age,
        'personaPhotoUrl':
            persona.photoUrls.isNotEmpty ? persona.photoUrls.first : '',
      };

      // Queue for batch operation
      _queueRelationshipCreate(relationshipData);

      // Update local state immediately
      final matchedPersona = persona.copyWith(
        likes: 50,
        imageUrls: persona.imageUrls, // Preserve imageUrls
        matchedAt: DateTime.now(), // Set matched time
      );

      if (!_matchedPersonas.any((p) => p.id == personaId)) {
        _matchedPersonas.add(matchedPersona);
        await _saveMatchedPersonas();
      }

      // 🔥 즉시 사용 가능한 페르소나 목록에서 제거
      _shuffledAvailablePersonas?.removeWhere((p) => p.id == personaId);

      _sessionSwipedPersonas[personaId] = DateTime.now();

      // Cache the relationship
      _addToCache(
          personaId,
          _CachedRelationship(
            score: 50,
            isCasualSpeech: false,
            timestamp: DateTime.now(),
          ));

      // Update user's actionedPersonaIds
      await _updateActionedPersonaIds(personaId);

      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error liking persona: $e');
      return false;
    }
  }

  /// Optimized persona super like with enhanced relationship score
  Future<bool> superLikePersona(String personaId, {Persona? personaObject, PurchaseService? purchaseService}) async {
    if (_currentUserId == null) {
      _currentUserId = await DeviceIdService.getTemporaryUserId();
    }

    if (_currentUserId == '') {
      debugPrint('⚠️ No user ID available for super liking persona');
      return false;
    }

    try {
      // Use provided persona object or find it in _allPersonas
      Persona? persona = personaObject;
      if (persona == null) {
        persona = _allPersonas.where((p) => p.id == personaId).firstOrNull;
        if (persona == null) {
          debugPrint('⚠️ Persona not found for super liking: $personaId');
          return false;
        }
      }

      debugPrint('⭐ Processing SUPER LIKE for persona: ${persona.name}');

      // 하트 3개 소모 (슈퍼라이크, 이미 매칭된 경우는 제외)
      if (!_matchedPersonas.any((p) => p.id == personaId)) {
        if (purchaseService != null) {
          final heartConsumed = await purchaseService.useHearts(3);
          if (!heartConsumed) {
            debugPrint('❌ Failed to consume hearts for super liking persona: $personaId');
            return false;
          }
          debugPrint('⭐ Successfully consumed 3 hearts for super liking persona: $personaId');
        } else {
          debugPrint('⚠️ PurchaseService not provided, skipping heart consumption');
        }
      }

      // 재매칭 시 leftChat 플래그 리셋
      final currentUser = FirebaseAuth.instance.currentUser;
      final isGuest = currentUser?.isAnonymous ?? false;
      
      if (isGuest) {
        // Guest mode: Clear ALL previous conversation data for fresh start
        await GuestConversationService.instance.clearGuestConversationForPersona(personaId);
        await GuestConversationService.instance.setLeftChatStatus(personaId, false);
        debugPrint('🔓 [PersonaService] Guest conversation data completely cleared for fresh start with persona: $personaId');
      } else {
        // Regular user: Reset in Firebase
        await FirebaseFirestore.instance
            .collection('users')
            .doc(_currentUserId!)
            .collection('chats')
            .doc(personaId)
            .set({
          'leftChat': false,
          'rejoinedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
        debugPrint('☁️ [PersonaService] User leftChat status reset in Firebase for persona: $personaId');
      }

      // Create relationship data with super like relationship score (1000)
      final relationshipData = {
        'userId': _currentUserId!,
        'personaId': personaId,
        'likes': 1000, // 🌟 Super like starts with 1000 (perfect love level)
        'isCasualSpeech': false,
        'swipeAction': 'super_like',
        'isMatched': true,
        'isActive': true,
        'matchedAt': FieldValue.serverTimestamp(),
        'createdAt': FieldValue.serverTimestamp(),
        'lastInteraction': FieldValue.serverTimestamp(),
        'personaName': persona.name,
        'personaAge': persona.age,
        'personaPhotoUrl':
            persona.photoUrls.isNotEmpty ? persona.photoUrls.first : '',
      };

      // Queue for batch operation
      _queueRelationshipCreate(relationshipData);

      // Update local state immediately with super like score
      final matchedPersona = persona.copyWith(
        likes: 1000, // 🌟 Super like likes score
        imageUrls: persona.imageUrls, // Preserve imageUrls
        matchedAt: DateTime.now(), // Set matched time
      );

      if (!_matchedPersonas.any((p) => p.id == personaId)) {
        _matchedPersonas.add(matchedPersona);
        await _saveMatchedPersonas();
      } else {
        // Update existing matched persona
        final index = _matchedPersonas.indexWhere((p) => p.id == personaId);
        if (index != -1) {
          _matchedPersonas[index] = matchedPersona;
          await _saveMatchedPersonas();
        }
      }

      // 🔥 즉시 사용 가능한 페르소나 목록에서 제거
      _shuffledAvailablePersonas?.removeWhere((p) => p.id == personaId);

      _sessionSwipedPersonas[personaId] = DateTime.now();

      // Cache the relationship with super like score
      _addToCache(
          personaId,
          _CachedRelationship(
            score: 1000, // 🌟 Super like score
            isCasualSpeech: false,
            timestamp: DateTime.now(),
          ));

      debugPrint(
          '✅ Super like processed successfully: ${persona.name} → 1000 (완벽한 사랑)');

      // Update user's actionedPersonaIds
      await _updateActionedPersonaIds(personaId);

      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error super liking persona: $e');
      return false;
    }
  }

  /// Super like tutorial persona (local only)
  Future<bool> _superLikeTutorialPersona(String personaId) async {
    try {
      final persona = _allPersonas.where((p) => p.id == personaId).firstOrNull;
      if (persona == null) {
        debugPrint(
            '⚠️ Persona not found for tutorial super liking: $personaId');
        return false;
      }

      debugPrint(
          '🎓⭐ Processing tutorial SUPER LIKE for persona: ${persona.name}');

      final matchedIds =
          await PreferencesManager.getStringList('tutorial_matched_personas') ??
              [];

      if (!matchedIds.contains(personaId)) {
        matchedIds.add(personaId);
        await PreferencesManager.setStringList(
            'tutorial_matched_personas', matchedIds);
      }

      // Also save to super liked list
      final superLikedIds = await PreferencesManager.getStringList(
              'tutorial_super_liked_personas') ??
          [];
      if (!superLikedIds.contains(personaId)) {
        superLikedIds.add(personaId);
        await PreferencesManager.setStringList(
            'tutorial_super_liked_personas', superLikedIds);
        debugPrint('💾 Saved super like flag for: ${persona.name}');
      }

      // Super like creates crush likes level (1000 score)
      final matchedPersona = persona.copyWith(
        likes: 1000, // 🌟 Super like likes score
      );

      if (!_matchedPersonas.any((p) => p.id == personaId)) {
        _matchedPersonas.add(matchedPersona);
      } else {
        // Update existing matched persona
        final index = _matchedPersonas.indexWhere((p) => p.id == personaId);
        if (index != -1) {
          _matchedPersonas[index] = matchedPersona;
        }
      }

      _sessionSwipedPersonas[personaId] = DateTime.now();

      debugPrint(
          '✅ Tutorial super like processed successfully: ${persona.name} → 1000 (완벽한 사랑)');
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error in tutorial super liking: $e');
      return false;
    }
  }

  /// Update likes score with enhanced logging and immediate processing
  Future<void> updateRelationshipScore(
      String personaId, int change, String userId) async {
    if (userId.isEmpty || change == 0) {
      debugPrint(
          '⏭️ Skipping relationship update: userId=$userId, change=$change');
      return;
    }

    debugPrint(
        '🔄 Starting relationship score update: personaId=$personaId, change=$change, userId=$userId');

    try {
      // Get current score from cache or persona
      int currentScore = 50;
      final cachedRelationship = _getFromCache(personaId);

      if (cachedRelationship != null) {
        currentScore = cachedRelationship.score;
        debugPrint('📋 Using cached score: $currentScore');
      } else if (_currentPersona?.id == personaId) {
        currentScore = _currentPersona!.likes;
        debugPrint('👤 Using current persona score: $currentScore');
      } else {
        final matchedPersona =
            _matchedPersonas.where((p) => p.id == personaId).firstOrNull;
        if (matchedPersona != null) {
          currentScore = matchedPersona.likes;
          debugPrint('💕 Using matched persona score: $currentScore');
        } else {
          // Get from RelationScoreService
          currentScore =
              await RelationScoreService.instance.getRelationshipScore(
            userId: userId,
            personaId: personaId,
          );
          debugPrint('📈 Using score from RelationScoreService: $currentScore');
        }
      }

      // Use RelationScoreService to update score
      await RelationScoreService.instance.updateRelationshipScore(
        userId: userId,
        personaId: personaId,
        scoreChange: change,
        currentScore: currentScore,
      );

      final newScore = max(0, currentScore + change);  // 상한선 제거, 하한선만 0으로 유지
      debugPrint('📊 Score calculation: $currentScore + $change = $newScore');

      // Update relationship in Firebase
      debugPrint('🔥 Normal mode - queuing Firebase update');
      // Queue update for batch processing
      _queueRelationshipUpdate(_PendingRelationshipUpdate(
        userId: userId,
        personaId: personaId,
        newScore: newScore,
      ));

      // 🔧 FIX: Immediately process batch if this is a significant change
      if (change.abs() >= 3) {
        debugPrint(
            '🚀 Significant change detected ($change) - processing immediately');
        Future.microtask(() => _processBatchUpdates());
      }

      // Update local state immediately for all modes
      if (_currentPersona?.id == personaId) {
        _currentPersona = _currentPersona?.copyWith(
          likes: newScore,
          imageUrls: _currentPersona?.imageUrls, // Preserve imageUrls
        );
        debugPrint(
            '✅ Updated current persona: ${_currentPersona!.name} → $newScore');
        // 🔥 즉시 UI 업데이트 (currentPersona 변경)
        notifyListeners();
      }

      // Update matched personas list
      final index = _matchedPersonas.indexWhere((p) => p.id == personaId);
      if (index != -1) {
        _matchedPersonas[index] = _matchedPersonas[index].copyWith(
          likes: newScore,
          imageUrls: _matchedPersonas[index].imageUrls, // Preserve imageUrls
        );
        debugPrint(
            '✅ Updated matched persona: ${_matchedPersonas[index].name} → $newScore');
      }

      // Update cache
      _addToCache(
          personaId,
          _CachedRelationship(
            score: newScore,
            isCasualSpeech: cachedRelationship?.isCasualSpeech ?? false,
            timestamp: DateTime.now(),
          ));

      debugPrint('🔄 Relationship update completed successfully');
      // 🔥 최종 UI 업데이트 (모든 변경사항 반영)
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Error updating relationship score: $e');
    }
  }

  /// Queue relationship creation for batch processing
  void _queueRelationshipCreate(Map<String, dynamic> relationshipData) async {
    final docId =
        '${relationshipData['userId']}_${relationshipData['personaId']}';

    try {
      debugPrint('🔄 Creating relationship document: $docId');
      debugPrint(
          '📊 Relationship data: ${relationshipData['personaName']} (score: ${relationshipData['likes'] ?? relationshipData['relationshipScore']})');

      await FirebaseHelper.userPersonaRelationships
          .doc(docId)
          .set(relationshipData);

      debugPrint('✅ Relationship created successfully: $docId');
    } catch (e) {
      debugPrint('❌ Error creating relationship: $e');

      // 재시도 로직
      if (e.toString().contains('permission-denied')) {
        debugPrint('🚫 Permission denied - checking authentication status');
        // 권한 문제인 경우 로컬에만 저장
        await _saveMatchedPersonas();
      } else {
        // 네트워크 오류 등의 경우 재시도
        Future.delayed(const Duration(seconds: 2), () async {
          try {
            debugPrint('🔄 Retrying relationship creation...');
            await FirebaseHelper.userPersonaRelationships
                .doc(docId)
                .set(relationshipData);
            debugPrint('✅ Relationship created on retry: $docId');
          } catch (retryError) {
            debugPrint('❌ Retry failed: $retryError');
            // 최종 실패 시 로컬에만 저장
            await _saveMatchedPersonas();
          }
        });
      }
    }
  }

  /// Queue relationship update for batch processing
  void _queueRelationshipUpdate(_PendingRelationshipUpdate update) {
    _pendingUpdates.add(update);

    // Start batch timer if not running
    _batchUpdateTimer ??= Timer(_batchUpdateDelay, _processBatchUpdates);

    // Process immediately if batch is full
    if (_pendingUpdates.length >= _maxBatchSize) {
      _processBatchUpdates();
    }
  }

  /// Process batch updates to Firebase with auto-creation
  Future<void> _processBatchUpdates() async {
    if (_pendingUpdates.isEmpty) return;

    _batchUpdateTimer?.cancel();
    _batchUpdateTimer = null;

    final updates = List<_PendingRelationshipUpdate>.from(_pendingUpdates);
    _pendingUpdates.clear();

    debugPrint('🔥 Processing ${updates.length} relationship updates...');

    try {
      final batch = FirebaseHelper.batch();

      for (final update in updates) {
        final docRef = FirebaseHelper.userPersonaRelationships
            .doc('${update.userId}_${update.personaId}');

        // Get persona info for complete document
        final persona =
            _allPersonas.where((p) => p.id == update.personaId).firstOrNull;

        // Use set with merge to create document if it doesn't exist
        batch.set(
            docRef,
            {
              'userId': update.userId,
              'personaId': update.personaId,
              // Keep both fields for backward compatibility
              'likes':
                  update.newScore, // 🔧 FIX: Write both fields for consistency
              'lastInteraction': FieldValue.serverTimestamp(),
              'totalInteractions': FieldValue.increment(1),
              'isMatched': true,
              'isActive': true,
              // Add persona info for convenience
              'personaName': persona?.name ?? 'Unknown',
              'personaAge': persona?.age ?? 0,
              'personaPhotoUrl': (persona?.photoUrls.isNotEmpty == true)
                  ? persona!.photoUrls.first
                  : '',
              // Update existing document or create new one
              'updatedAt': FieldValue.serverTimestamp(),
            },
            SetOptions(merge: true));

        debugPrint(
            '📝 Queued update: ${update.personaId} → ${update.newScore}');
      }

      await batch.commit();
      debugPrint(
          '✅ Successfully batch updated ${updates.length} relationships');
    } catch (e) {
      debugPrint('❌ Error in batch update: $e');
      // Re-queue failed updates for retry
      _pendingUpdates.addAll(updates);

      // If it's a permission error, don't retry indefinitely
      if (e.toString().contains('permission-denied')) {
        debugPrint(
            '🚫 Permission denied - clearing failed updates to prevent infinite retry');
        _pendingUpdates.clear();
      }
    }
  }

  /// Optimized matched personas loading with caching
  Future<void> _loadMatchedPersonas() async {
    debugPrint('🔄 Loading matched personas...');

    if (_currentUserId == '') {
      debugPrint('⚠️ No user ID available for loading matched personas');
      return;
    }

    if (_currentUserId == null) {
      await _loadMatchedPersonasFromLocal();
      return;
    }

    // 먼저 로컬에서 로드하여 즉시 표시
    await _loadMatchedPersonasFromLocal();
    debugPrint(
        '📱 Loaded ${_matchedPersonas.length} matched personas from local storage');

    try {
      // Firebase에서도 로드하여 병합
      final querySnapshot = await FirebaseHelper.userPersonaRelationships
          .where('userId', isEqualTo: _currentUserId!)
          .get();

      debugPrint(
          '📊 Found ${querySnapshot.docs.length} relationship documents in Firebase');

      final firebaseMatchedIds = <String>{};
      final firebasePersonas = <Persona>[];
      
      // leftChat 상태를 저장할 Set
      final leftChatPersonaIds = <String>{};

      // Process in parallel
      final futures = <Future>[];

      for (final doc in querySnapshot.docs) {
        final data = doc.data();
        final isMatched = data['isMatched'] ?? false;
        final isActive = data['isActive'] ?? true; // 기본값을 true로 변경 (기존 데이터 호환성)
        final swipeAction = data['swipeAction'] ?? '';

        debugPrint(
            '  📋 Doc ${doc.id}: isMatched=$isMatched, isActive=$isActive, swipeAction=$swipeAction');

        // Only check isMatched - isActive is optional for backward compatibility
        if (!isMatched) {
          debugPrint('    ❌ Skipping - not matched');
          continue;
        }

        final personaId = data['personaId'] as String?;
        if (personaId == null) {
          debugPrint('    ❌ Skipping - no personaId');
          continue;
        }
        
        // leftChat 상태 체크를 위한 Future 추가
        futures.add(hasLeftChat(personaId).then((hasLeft) {
          if (hasLeft) {
            leftChatPersonaIds.add(personaId);
            debugPrint('    🚪 Persona $personaId has left chat');
          }
        }));

        // 먼저 _allPersonas에서 찾기
        Persona? persona =
            _allPersonas.where((p) => p.id == personaId).firstOrNull;
        
        // _allPersonas에 없으면 Firebase에서 직접 로드 (커스텀 페르소나일 가능성)
        if (persona == null) {
          try {
            final personaDoc = await FirebaseHelper.personas.doc(personaId).get();
            if (personaDoc.exists) {
              final personaData = personaDoc.data() as Map<String, dynamic>?;
              if (personaData != null) {
                // 커스텀 페르소나인지 확인하고 권한 체크
                final isCustom = personaData['isCustom'] ?? false;
                final createdBy = personaData['createdBy'];
                
                if (isCustom && createdBy == _currentUserId) {
                  // 커스텀 페르소나 생성
                  persona = _parseFirebaseDocumentSnapshot(personaDoc);
                  // _allPersonas에도 추가하여 캐싱
                  if (persona != null && !_allPersonas.any((p) => p.id == persona!.id)) {
                    _allPersonas.add(persona);
                    debugPrint('    🎯 Loaded and cached custom persona: ${persona.name}');
                  }
                }
              }
            }
          } catch (e) {
            debugPrint('    ❌ Error loading custom persona $personaId: $e');
          }
        }
        
        if (persona != null) {
          final likes = data['likes'] ?? data['relationshipScore'] ?? 50;

          // Get matchedAt timestamp from Firebase
          DateTime? matchedAt;
          if (data['matchedAt'] != null) {
            if (data['matchedAt'] is Timestamp) {
              matchedAt = (data['matchedAt'] as Timestamp).toDate();
            } else if (data['matchedAt'] is String) {
              // Handle string format (ISO8601)
              try {
                matchedAt = DateTime.parse(data['matchedAt'] as String);
              } catch (e) {
                debugPrint('    ⚠️ Error parsing matchedAt string: $e');
                matchedAt = DateTime.now(); // Fallback to now
              }
            }
          } else {
            // If no matchedAt, use createdAt or current time as fallback
            if (data['createdAt'] != null) {
              if (data['createdAt'] is Timestamp) {
                matchedAt = (data['createdAt'] as Timestamp).toDate();
              }
            } else {
              matchedAt = DateTime.now(); // Final fallback
            }
          }

          final matchedPersona = persona.copyWith(
            likes: likes,
            imageUrls: persona.imageUrls, // Preserve imageUrls
            matchedAt: matchedAt,
          );

          firebasePersonas.add(matchedPersona);
          firebaseMatchedIds.add(personaId);
          debugPrint('    ✅ Found ${persona.name} in Firebase (score: $likes)');

          // Cache relationship data
          _addToCache(
              personaId,
              _CachedRelationship(
                score: likes,
                isCasualSpeech: data['isCasualSpeech'] ?? false,
                timestamp: DateTime.now(),
              ));
        } else {
          debugPrint('    ⚠️ Persona not found in all personas: $personaId');
        }
      }
      
      // 모든 Future가 완료될 때까지 대기
      await Future.wait(futures);

      // 병합: 로컬과 Firebase 데이터 통합
      final mergedMap = <String, Persona>{};

      // 먼저 로컬 데이터 추가 (leftChat 필터링 적용)
      for (final persona in _matchedPersonas) {
        if (!leftChatPersonaIds.contains(persona.id)) {
          mergedMap[persona.id] = persona;
        }
      }

      // Firebase 데이터로 업데이트 (Firebase가 더 최신, leftChat 필터링 적용)
      for (final persona in firebasePersonas) {
        if (!leftChatPersonaIds.contains(persona.id)) {
          mergedMap[persona.id] = persona;
        }
      }

      _matchedPersonas = mergedMap.values.toList();

      // Sort by likes score
      _matchedPersonas.sort((a, b) => b.likes.compareTo(a.likes));

      debugPrint('✅ Merged matched personas: ${_matchedPersonas.length} total');
      debugPrint(
          '   - From local: ${mergedMap.length - firebasePersonas.length}');
      debugPrint('   - From Firebase: ${firebasePersonas.length}');

      await _saveMatchedPersonas();
    } catch (e) {
      debugPrint('❌ Error loading matched personas: $e');
      await _loadMatchedPersonasFromLocal();
    }
  }

  /// Cache management
  _CachedRelationship? _getFromCache(String personaId) {
    final cached = _relationshipCache[personaId];
    if (cached != null) {
      final age = DateTime.now().difference(cached.timestamp);
      if (age < _cacheTTL) {
        return cached;
      } else {
        _relationshipCache.remove(personaId);
      }
    }
    return null;
  }

  void _addToCache(String personaId, _CachedRelationship relationship) {
    _relationshipCache[personaId] = relationship;

    // Clean old entries if needed
    if (_relationshipCache.length > _maxCacheSize) {
      final sortedEntries = _relationshipCache.entries.toList()
        ..sort((a, b) => a.value.timestamp.compareTo(b.value.timestamp));

      for (int i = 0; i < sortedEntries.length - _maxCacheSize; i++) {
        _relationshipCache.remove(sortedEntries[i].key);
      }
    }
  }
  
  /// leftChat 상태 변경 시 해당 페르소나의 캐시 제거 및 목록 갱신
  void clearPersonaCacheForLeftChat(String personaId) async {
    _relationshipCache.remove(personaId);
    _matchedPersonas.removeWhere((p) => p.id == personaId);
    
    // 로컬 스토리지에서도 제거
    final matchedIds = _matchedPersonas.map((p) => p.id).toList();
    await PreferencesManager.setStringList('matched_personas', matchedIds);
    
    notifyListeners();
    debugPrint('🧹 Cleared cache and removed persona $personaId from matched list after leftChat');
  }

  /// Load personas from Firebase with enhanced retry and authentication
  Future<bool> _loadFromFirebase() async {
    debugPrint('🔥 Starting Firebase personas loading...');

    // Clear shuffled list when loading new personas
    _shuffledAvailablePersonas = null;
    _lastShuffleTime = null;

    // 🚀 Enhanced Firebase access with multiple strategies
    for (int attempt = 1; attempt <= 4; attempt++) {
      try {
        debugPrint('🔄 Firebase attempt $attempt/4...');

        // Strategy 1: Direct access (should work with new Security Rules)
        if (attempt == 1) {
          debugPrint('📖 Trying direct Firebase access...');
          
          // Get both regular personas and custom personas
          final regularPersonasQuery = await FirebaseHelper.personas
              .where('isCustom', isEqualTo: false)
              .get();
          
          // Get custom personas created by current user
          List<QueryDocumentSnapshot> customPersonaDocs = [];
          if (_currentUserId != null && _currentUserId!.isNotEmpty) {
            final customPersonasQuery = await FirebaseHelper.personas
                .where('isCustom', isEqualTo: true)
                .where('createdBy', isEqualTo: _currentUserId)
                .get();
            customPersonaDocs = customPersonasQuery.docs;
            debugPrint('📝 Found ${customPersonaDocs.length} custom personas for user: $_currentUserId');
          }
          
          // Combine both lists
          final allDocs = [...regularPersonasQuery.docs, ...customPersonaDocs];

          if (allDocs.isNotEmpty) {
            _allPersonas = _parseFirebasePersonas(allDocs);
            debugPrint(
                '✅ SUCCESS: Direct access loaded ${_allPersonas.length} personas (${regularPersonasQuery.docs.length} regular + ${customPersonaDocs.length} custom)');
            return true;
          }
        }

        // Strategy 2: Anonymous authentication
        else if (attempt == 2) {
          debugPrint('🎭 Trying anonymous authentication...');
          try {
            final userCredential =
                await FirebaseAuth.instance.signInAnonymously();
            debugPrint(
                '✅ Anonymous auth successful: ${userCredential.user?.uid}');

            await Future.delayed(const Duration(
                milliseconds: 500)); // Give time for auth to propagate

            final querySnapshot =
                await FirebaseFirestore.instance.collection('personas').get();

            if (querySnapshot.docs.isNotEmpty) {
              _allPersonas = _parseFirebasePersonas(querySnapshot.docs);
              debugPrint(
                  '✅ SUCCESS: Anonymous auth loaded ${_allPersonas.length} personas');
              return true;
            }
          } catch (authError) {
            debugPrint('❌ Anonymous auth failed: $authError');
          }
        }

        // Strategy 3: Force retry after clearing any cached auth issues
        else if (attempt == 3) {
          debugPrint('🔄 Clearing auth state and retrying...');
          try {
            // Don't sign out if we're already authenticated, just retry
            await Future.delayed(const Duration(milliseconds: 1000));

            final querySnapshot =
                await FirebaseFirestore.instance.collection('personas').get();

            if (querySnapshot.docs.isNotEmpty) {
              _allPersonas = _parseFirebasePersonas(querySnapshot.docs);
              debugPrint(
                  '✅ SUCCESS: Retry loaded ${_allPersonas.length} personas');
              return true;
            }
          } catch (retryError) {
            debugPrint('❌ Retry attempt failed: $retryError');
          }
        }

        // Strategy 4: Last resort with different approach
        else if (attempt == 4) {
          debugPrint('🚨 Last resort: Trying with limit query...');
          try {
            final querySnapshot = await FirebaseFirestore.instance
                .collection('personas')
                .limit(10)
                .get();

            if (querySnapshot.docs.isNotEmpty) {
              _allPersonas = _parseFirebasePersonas(querySnapshot.docs);
              debugPrint(
                  '✅ SUCCESS: Limited query loaded ${_allPersonas.length} personas');
              return true;
            }
          } catch (limitError) {
            debugPrint('❌ Limited query failed: $limitError');
          }
        }
      } catch (e) {
        debugPrint('❌ Firebase attempt $attempt failed: $e');

        if (e.toString().contains('permission-denied')) {
          debugPrint('🚫 Permission denied on attempt $attempt');
        } else if (e.toString().contains('network')) {
          debugPrint('📡 Network error on attempt $attempt');
        }

        // Wait before next attempt (except for last attempt)
        if (attempt < 4) {
          final delay = attempt * 500; // 500ms, 1s, 1.5s
          debugPrint('⏳ Waiting ${delay}ms before next attempt...');
          await Future.delayed(Duration(milliseconds: delay));
        }
      }
    }

    debugPrint('💥 All Firebase attempts failed. Using fallback personas.');
    return false;
  }

  /// Parse single Firebase persona document into Persona object (from DocumentSnapshot)
  Persona? _parseFirebaseDocumentSnapshot(DocumentSnapshot doc) {
    try {
      final data = doc.data() as Map<String, dynamic>?;
      if (data == null) return null;

      // Parse photoUrls - handle both string and array formats with validation
      List<String> photoUrls = [];

      // First check if R2 images are available in imageUrls field
      if (data['imageUrls'] != null && data['imageUrls'] is Map) {
        // R2 images are available, clear photoUrls to force using R2 images
        photoUrls = [];
        debugPrint(
            '🎯 R2 images available for ${data['name']}, clearing photoUrls');
      } else if (data['photoUrls'] != null) {
        // No R2 images, use legacy photoUrls with validation
        if (data['photoUrls'] is List) {
          final rawUrls = List<String>.from(data['photoUrls']);
          photoUrls = _validateAndFilterPhotoUrls(rawUrls);
        } else if (data['photoUrls'] is String) {
          String photoUrlsStr = data['photoUrls'];
          // Remove brackets and split by comma
          photoUrlsStr = photoUrlsStr.replaceAll('[', '').replaceAll(']', '');
          final rawUrls =
              photoUrlsStr.split(', ').map((url) => url.trim()).toList();
          photoUrls = _validateAndFilterPhotoUrls(rawUrls);
        }
      }

      // Parse imageUrls for R2 storage
      Map<String, dynamic>? imageUrls;
      if (data['imageUrls'] != null) {
        debugPrint('🔍 Parsing imageUrls for ${data['name']}:');
        debugPrint('   Type: ${data['imageUrls'].runtimeType}');
        debugPrint('   Value: ${data['imageUrls']}');

        if (data['imageUrls'] is Map) {
          imageUrls = Map<String, dynamic>.from(data['imageUrls']);
          debugPrint('   ✅ Parsed as Map: $imageUrls');
        } else if (data['imageUrls'] is String) {
          // Sometimes Firebase returns "[Object]" as a string
          debugPrint('   ⚠️ imageUrls is String, might be corrupted data');
        }
      }

      final persona = Persona(
        id: doc.id,
        name: data['name'] ?? '',
        age: data['age'] ?? 0,
        description: data['description'] ?? '',
        photoUrls: photoUrls,
        personality: data['personality'] ?? '',
        likes: 0,
        gender: data['gender'] ?? 'female',
        mbti: data['mbti'] ?? 'ENFP',
        imageUrls: imageUrls, // Add R2 image URLs
        topics:
            data['topics'] != null ? List<String>.from(data['topics']) : null,
        keywords: data['keywords'] != null
            ? List<String>.from(data['keywords'])
            : null,
        hasValidR2Image: data['hasValidR2Image'] ?? null,
        // 커스텀 페르소나 필드
        createdBy: data['createdBy'],
        isCustom: data['isCustom'] ?? false,
        isShare: data['isShare'] ?? false,
        isConfirm: data['isConfirm'] ?? false,
      );

      return persona;
    } catch (e) {
      debugPrint('❌ Error parsing persona document ${doc.id}: $e');
      return null;
    }
  }

  /// Parse single Firebase persona document into Persona object (from QueryDocumentSnapshot)
  Persona? _parseFirebasePersona(QueryDocumentSnapshot doc) {
    try {
      final data = doc.data() as Map<String, dynamic>;

      // Parse photoUrls - handle both string and array formats with validation
      List<String> photoUrls = [];

      // First check if R2 images are available in imageUrls field
      if (data['imageUrls'] != null && data['imageUrls'] is Map) {
        // R2 images are available, clear photoUrls to force using R2 images
        photoUrls = [];
        debugPrint(
            '🎯 R2 images available for ${data['name']}, clearing photoUrls');
      } else if (data['photoUrls'] != null) {
        // No R2 images, use legacy photoUrls with validation
        if (data['photoUrls'] is List) {
          final rawUrls = List<String>.from(data['photoUrls']);
          photoUrls = _validateAndFilterPhotoUrls(rawUrls);
        } else if (data['photoUrls'] is String) {
          String photoUrlsStr = data['photoUrls'];
          // Remove brackets and split by comma
          photoUrlsStr = photoUrlsStr.replaceAll('[', '').replaceAll(']', '');
          final rawUrls =
              photoUrlsStr.split(', ').map((url) => url.trim()).toList();
          photoUrls = _validateAndFilterPhotoUrls(rawUrls);
        }
      }

      // Parse imageUrls for R2 storage
      Map<String, dynamic>? imageUrls;
      if (data['imageUrls'] != null) {
        debugPrint('🔍 Parsing imageUrls for ${data['name']}:');
        debugPrint('   Type: ${data['imageUrls'].runtimeType}');
        debugPrint('   Value: ${data['imageUrls']}');

        if (data['imageUrls'] is Map) {
          imageUrls = Map<String, dynamic>.from(data['imageUrls']);
          debugPrint('   ✅ Parsed as Map: $imageUrls');
        } else if (data['imageUrls'] is String) {
          // Sometimes Firebase returns "[Object]" as a string
          debugPrint('   ⚠️ imageUrls is String, might be corrupted data');
        }
      }

      final persona = Persona(
        id: doc.id,
        name: data['name'] ?? '',
        age: data['age'] ?? 0,
        description: data['description'] ?? '',
        photoUrls: photoUrls,
        personality: data['personality'] ?? '',
        likes: 0,
        gender: data['gender'] ?? 'female',
        mbti: data['mbti'] ?? 'ENFP',
        imageUrls: imageUrls, // Add R2 image URLs
        topics:
            data['topics'] != null ? List<String>.from(data['topics']) : null,
        keywords: data['keywords'] != null
            ? List<String>.from(data['keywords'])
            : null,
        hasValidR2Image: data['hasValidR2Image'] ?? null,
        // 커스텀 페르소나 필드
        createdBy: data['createdBy'],
        isCustom: data['isCustom'] ?? false,
        isShare: data['isShare'] ?? false,
        isConfirm: data['isConfirm'] ?? false,
      );

      return persona;
    } catch (e) {
      debugPrint('❌ Error parsing persona document ${doc.id}: $e');
      return null;
    }
  }
  
  /// Parse Firebase personas documents into Persona objects
  List<Persona> _parseFirebasePersonas(List<QueryDocumentSnapshot> docs) {
    return docs.map((doc) {
      return _parseFirebasePersona(doc);
    }).where((persona) => persona != null).cast<Persona>().toList();
  }

  /// 🔧 Validate and filter photo URLs - only return valid URLs, no placeholders
  List<String> _validateAndFilterPhotoUrls(List<String> rawUrls) {
    List<String> validUrls = [];

    for (String url in rawUrls) {
      String trimmedUrl = url.trim();

      // Skip empty URLs
      if (trimmedUrl.isEmpty) continue;

      // Check if URL is valid (starts with http or https)
      if (trimmedUrl.startsWith('http://') ||
          trimmedUrl.startsWith('https://')) {
        validUrls.add(trimmedUrl);
      }
      // Skip invalid URLs (like assets/images/...) without replacement
    }

    return validUrls;
  }

  // Other helper methods remain the same...

  Future<Map<String, dynamic>?> _loadUserPersonaRelationship(
      String personaId) async {
    if (_currentUserId == null) return null;

    try {
      final docId = '${_currentUserId}_$personaId';
      final doc =
          await FirebaseHelper.userPersonaRelationships.doc(docId).get();

      if (doc.exists) {
        return doc.data();
      }
    } catch (e) {
      debugPrint('Error loading relationship: $e');
    }
    return null;
  }

  Future<void> _loadSwipedPersonas() async {
    try {
      final swipedIds =
          await PreferencesManager.getStringList('swiped_personas') ?? [];

      _sessionSwipedPersonas.clear();
      for (String id in swipedIds) {
        _sessionSwipedPersonas[id] =
            DateTime.now().subtract(const Duration(hours: 1));
      }
    } catch (e) {
      debugPrint('Error loading swiped personas: $e');
    }
  }

  Future<void> _loadMatchedPersonasFromLocal() async {
    try {
      final matchedIds =
          await PreferencesManager.getStringList('matched_personas') ?? [];

      // 로컬에서 로드한 페르소나들
      final localPersonas = <Persona>[];
      
      for (final personaId in matchedIds) {
        // 먼저 _allPersonas에서 찾기
        Persona? persona = _allPersonas
            .where((p) => p.id == personaId)
            .firstOrNull;
        
        // _allPersonas에 없으면 Firebase에서 직접 로드 (커스텀 페르소나일 가능성)
        if (persona == null && _currentUserId != null) {
          try {
            final doc = await FirebaseHelper.personas.doc(personaId).get();
            if (doc.exists) {
              final data = doc.data() as Map<String, dynamic>?;
              if (data != null) {
                // 커스텀 페르소나인지 확인하고 권한 체크
                final isCustom = data['isCustom'] ?? false;
                final createdBy = data['createdBy'];
                
                if (isCustom && createdBy == _currentUserId) {
                  // 커스텀 페르소나 생성
                  persona = _parseFirebaseDocumentSnapshot(doc);
                  // _allPersonas에도 추가하여 캐싱
                  if (persona != null && !_allPersonas.any((p) => p.id == persona!.id)) {
                    _allPersonas.add(persona);
                    debugPrint('🎯 Added custom persona to _allPersonas: ${persona.name}');
                  }
                }
              }
            }
          } catch (e) {
            debugPrint('❌ Error loading custom persona $personaId: $e');
          }
        }
        
        if (persona != null) {
          localPersonas.add(persona);
        }
      }
      
      // leftChat 상태 체크하여 필터링
      final filteredPersonas = <Persona>[];
      for (final persona in localPersonas) {
        final hasLeft = await hasLeftChat(persona.id);
        if (!hasLeft) {
          filteredPersonas.add(persona);
        } else {
          debugPrint('🚪 Filtering out persona ${persona.id} from local due to leftChat');
        }
      }
      
      _matchedPersonas = filteredPersonas;
      debugPrint('📱 Loaded ${_matchedPersonas.length} matched personas from local (including custom)');
    } catch (e) {
      debugPrint('Error loading from local storage: $e');
      _matchedPersonas = [];
    }
  }

  Future<void> _saveMatchedPersonas() async {
    try {
      // leftChat 상태인 페르소나는 저장하지 않음
      final filteredPersonas = <String>[];
      for (final persona in _matchedPersonas) {
        final hasLeft = await hasLeftChat(persona.id);
        if (!hasLeft) {
          filteredPersonas.add(persona.id);
        }
      }
      await PreferencesManager.setStringList('matched_personas', filteredPersonas);
    } catch (e) {
      debugPrint('Error saving matched personas: $e');
    }
  }

  bool _isPersonaRecentlySwiped(String personaId) {
    final swipeTime = _sessionSwipedPersonas[personaId];
    if (swipeTime == null) return false;
    return DateTime.now().difference(swipeTime).inHours < 24;
  }

  void _cleanExpiredSwipes() {
    final now = DateTime.now();
    _sessionSwipedPersonas
        .removeWhere((id, time) => now.difference(time).inHours >= 24);
  }

  /// Get immediate available personas without R2 check
  List<Persona> _getImmediateAvailablePersonas() {
    final now = DateTime.now();
    final shouldReshuffle = _shuffledAvailablePersonas == null ||
        _lastShuffleTime == null ||
        now.difference(_lastShuffleTime!).inMinutes >= 30;

    if (shouldReshuffle) {
      final matchedIds = _matchedPersonas.map((p) => p.id).toSet();
      // 차단된 페르소나 ID 가져오기
      final blockedIds = _blockService.getBlockedPersonaIds();
      
      // 🔥 무한 스와이프 - 매칭된 페르소나와 차단된 페르소나 제외
      // 커스텀 페르소나 필터링 추가
      final filtered = _allPersonas
          .where((persona) =>
                  !matchedIds.contains(persona.id) &&
                  !_actionedPersonaIds.contains(persona.id) &&
                  !blockedIds.contains(persona.id) &&  // 차단된 AI 제외
                  // 커스텀 페르소나 필터링
                  (!persona.isCustom || // 시스템 페르소나는 모두 표시
                   (persona.isShare && persona.isConfirm) || // 공개 승인된 커스텀 페르소나
                   persona.createdBy == _currentUserId) // 자신이 만든 페르소나
              // 최근 스와이프 필터 제거 - 무한 스와이프
              // R2 필터링 제거 - 모든 페르소나 표시
              )
          .toList();

      final recommendedPersonas = getRecommendedPersonas(filtered);
      _shuffledAvailablePersonas = recommendedPersonas;
      _lastShuffleTime = now;

      // Start background R2 validation
      _startBackgroundR2Validation();
    }

    return List<Persona>.from(_shuffledAvailablePersonas!);
  }

  /// Start background R2 validation
  void _startBackgroundR2Validation() {
    if (_isValidatingR2) return;

    _isValidatingR2 = true;
    _r2ValidationTimer?.cancel();

    // Start validation after a short delay
    _r2ValidationTimer = Timer(const Duration(milliseconds: 100), () async {
      await _validateR2ImagesInBackground();
    });
  }

  /// Validate R2 images in background
  Future<void> _validateR2ImagesInBackground() async {
    debugPrint('🔄 Starting background R2 validation...');
    final startTime = DateTime.now();

    try {
      final personasToValidate = _shuffledAvailablePersonas ?? [];
      final validatedIds = <String>{};

      // Process in batches for better performance
      const batchSize = 10;
      for (int i = 0; i < personasToValidate.length; i += batchSize) {
        final batch = personasToValidate.skip(i).take(batchSize).toList();

        // Parallel validation within batch
        final results = await Future.wait(batch.map((persona) async {
          final hasR2 = await _hasR2ImageOptimized(persona);
          return MapEntry(persona.id, hasR2);
        }));

        // Update validated IDs
        for (final result in results) {
          if (result.value) {
            validatedIds.add(result.key);
          }
        }

        // Update UI periodically
        if (i % 30 == 0 && i > 0) {
          _r2ValidatedPersonaIds.clear();
          _r2ValidatedPersonaIds.addAll(validatedIds);
          notifyListeners();
        }
      }

      // Final update
      _r2ValidatedPersonaIds.clear();
      _r2ValidatedPersonaIds.addAll(validatedIds);

      final duration = DateTime.now().difference(startTime);
      debugPrint(
          '✅ R2 validation complete: ${validatedIds.length}/${personasToValidate.length} valid (${duration.inMilliseconds}ms)');

      notifyListeners();
    } catch (e) {
      debugPrint('❌ Error in background R2 validation: $e');
    } finally {
      _isValidatingR2 = false;
    }
  }

  /// Optimized R2 image check with caching
  Future<bool> _hasR2ImageOptimized(Persona persona) async {
    // 1. Check Firebase field first
    if (persona.hasValidR2Image != null) {
      return persona.hasValidR2Image!;
    }

    // 2. For custom personas, quickly check photoUrls
    if (persona.isCustom && persona.photoUrls.isNotEmpty) {
      final r2Pattern =
          RegExp(r'(teamsona\.work|r2\.dev|cloudflare|imagedelivery\.net)');
      for (final url in persona.photoUrls) {
        if (r2Pattern.hasMatch(url)) {
          return true;
        }
      }
    }

    // 3. Check cache
    final cached = await R2ValidationCache.getCached(persona.id);
    if (cached != null) {
      return cached;
    }

    // 4. Perform quick check
    final hasR2 = _hasR2ImageQuick(persona);

    // 4. Cache the result
    await R2ValidationCache.setCache(persona.id, hasR2);

    return hasR2;
  }

  /// Quick R2 image check without logging
  bool _hasR2ImageQuick(Persona persona) {
    // For custom personas, check photoUrls first
    if (persona.isCustom && persona.photoUrls.isNotEmpty) {
      final r2Pattern =
          RegExp(r'(teamsona\.work|r2\.dev|cloudflare|imagedelivery\.net)');
      for (final url in persona.photoUrls) {
        if (r2Pattern.hasMatch(url)) {
          return true;
        }
      }
    }

    if (persona.imageUrls == null || persona.imageUrls!.isEmpty) {
      return false;
    }

    // Quick pattern matching without jsonEncode
    // Check if any value in the map contains R2 domains
    final r2Pattern =
        RegExp(r'(teamsona\.work|r2\.dev|cloudflare|imagedelivery\.net)');

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

  /// Check if persona has valid R2 image (original method with logging)
  bool _hasR2Image(Persona persona) {
    // 1. Firebase에 저장된 값 우선 사용
    if (persona.hasValidR2Image != null) {
      return persona.hasValidR2Image!;
    }

    // 2. 디버깅을 위한 상세 로그
    debugPrint('🔍 Checking R2 image for ${persona.name} (${persona.id})');

    // 3. For custom personas, check photoUrls first
    if (persona.isCustom && persona.photoUrls.isNotEmpty) {
      debugPrint('  📝 Custom persona - checking photoUrls');
      for (final url in persona.photoUrls) {
        if (url.contains('teamsona.work') ||
            url.contains('r2.dev') ||
            url.contains('cloudflare') ||
            url.contains('imagedelivery.net')) {
          debugPrint('  ✅ Valid R2 URL found in photoUrls: $url');
          return true;
        }
      }
    }

    if (persona.imageUrls == null || persona.imageUrls!.isEmpty) {
      debugPrint('  ❌ No imageUrls found');
      return false;
    }

    // imageUrls 구조 체크
    final urls = persona.imageUrls!;
    debugPrint('  📋 imageUrls structure: ${urls.keys.toList()}');

    // 1. 기본 구조 체크 (medium 사이즈 필수)
    if (urls.containsKey('medium') && urls['medium'] is Map) {
      final mediumUrls = urls['medium'] as Map;
      if (mediumUrls.containsKey('jpg')) {
        final url = mediumUrls['jpg'] as String;
        debugPrint('  🎯 Found medium.jpg: $url');
        // URL이 실제 R2 도메인인지 확인
        final isR2 = url.contains('teamsona.work') ||
            url.contains('r2.dev') ||
            url.contains('cloudflare') ||
            url.contains('imagedelivery.net');
        debugPrint('  ${isR2 ? "✅" : "❌"} Is R2 URL: $isR2');
        if (isR2) return true;
      }
    }

    // 2. mainImageUrls 구조 체크
    if (urls.containsKey('mainImageUrls')) {
      final mainUrls = urls['mainImageUrls'] as Map?;
      if (mainUrls != null && mainUrls.containsKey('medium')) {
        final url = mainUrls['medium'] as String;
        debugPrint('  🎯 Found mainImageUrls.medium: $url');
        final isR2 = url.contains('teamsona.work') ||
            url.contains('r2.dev') ||
            url.contains('cloudflare') ||
            url.contains('imagedelivery.net');
        debugPrint('  ${isR2 ? "✅" : "❌"} Is R2 URL: $isR2');
        if (isR2) return true;
      }
    }

    // 3. 최상위 size 키 체크 (thumb, small, medium, large, original)
    final sizes = ['thumb', 'small', 'medium', 'large', 'original'];
    for (final size in sizes) {
      if (urls.containsKey(size) && urls[size] is Map) {
        final sizeUrls = urls[size] as Map;
        if (sizeUrls.containsKey('jpg')) {
          final url = sizeUrls['jpg'] as String;
          debugPrint('  🎯 Found $size.jpg: $url');
          if (url.contains('teamsona.work') ||
              url.contains('r2.dev') ||
              url.contains('cloudflare') ||
              url.contains('imagedelivery.net')) {
            debugPrint('  ✅ Valid R2 URL found in $size');
            return true;
          }
        }
      }
    }

    debugPrint('  ❌ No valid R2 URL found for ${persona.name}');
    return false;
  }

  /// Force reshuffle of available personas (useful after major changes)
  void reshuffleAvailablePersonas() {
    debugPrint('🔄 Force reshuffling available personas...');
    _shuffledAvailablePersonas = null;
    _lastShuffleTime = null;
    notifyListeners();
  }

  /// Refresh matched personas from Firebase (used to prevent duplicate matches)
  Future<void> refreshMatchedPersonasFromFirebase() async {
    if (_currentUserId == null) {
      debugPrint('⚠️ No user ID available for refreshing matched personas');
      return;
    }

    debugPrint('🔄 Refreshing matched personas from Firebase...');
    
    try {
      // Query Firebase for latest matched personas
      final relationshipsQuery = await FirebaseHelper.userPersonaRelationships
          .where('userId', isEqualTo: _currentUserId)
          .where('isMatched', isEqualTo: true)
          .where('isActive', isEqualTo: true)
          .get();

      final firebaseMatchedIds = <String>{};
      for (var doc in relationshipsQuery.docs) {
        final data = doc.data();
        final personaId = data['personaId'] as String?;
        if (personaId != null) {
          firebaseMatchedIds.add(personaId);
        }
      }

      // Update local matched personas list to match Firebase
      final updatedMatchedPersonas = <Persona>[];
      for (final personaId in firebaseMatchedIds) {
        final persona = getPersonaById(personaId);
        if (persona != null) {
          updatedMatchedPersonas.add(persona);
        }
      }

      _matchedPersonas = updatedMatchedPersonas;
      await _saveMatchedPersonas();
      
      debugPrint('✅ Refreshed ${_matchedPersonas.length} matched personas from Firebase');
      
      // Clear shuffled list to force refresh
      _shuffledAvailablePersonas = null;
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Error refreshing matched personas from Firebase: $e');
    }
  }

  @override
  void dispose() {
    _batchUpdateTimer?.cancel();
    _r2ValidationTimer?.cancel();
    super.dispose();
  }

  /// 추천 알고리즘 - 사용자 선호도에 따라 페르소나 정렬
  List<Persona> getRecommendedPersonas(List<Persona> personas) {
    // 현재 사용자 정보가 없으면 랜덤 순서로 반환
    if (_currentUser == null) {
      personas.shuffle();
      return personas;
    }

    // 1. 성별 필터링 (Gender All이 아닌 경우 이성만 필터링) - 게스트는 필터링 없음
    List<Persona> filteredPersonas = personas;
    final isGuestUser = _isGuestUserSync();
    
    if (!isGuestUser && // Guest users see all personas
        !_currentUser!.genderAll && 
        _currentUser!.gender != null) {
      // 사용자가 남성이면 여성 페르소나만, 여성이면 남성 페르소나만
      final targetGender = _currentUser!.gender == 'male' ? 'female' : 'male';
      filteredPersonas =
          personas.where((persona) => persona.gender == targetGender).toList();

      debugPrint(
          '🎯 Gender filtering: User(${_currentUser!.gender}) → Showing only $targetGender personas');
      debugPrint(
          '   Filtered from ${personas.length} to ${filteredPersonas.length} personas');
    } else {
      debugPrint(
          '🌈 Gender All enabled, no gender specified, or guest user - showing all personas (isGuest: $isGuestUser)');
    }

    // 2. 액션한 페르소나 제외는 이미 availablePersonas에서 처리됨
    // 여기서는 순서만 정렬하고 추가 필터링하지 않음
    debugPrint(
        '📋 Available personas for recommendation: ${filteredPersonas.length}');

    // 필터링 후 페르소나가 없으면 빈 리스트 반환
    if (filteredPersonas.isEmpty) {
      debugPrint('⚠️ No personas available after gender filtering');
      return [];
    }

    // 각 페르소나에 대한 추천 점수 계산
    final scoredPersonas = filteredPersonas.map((persona) {
      // 모든 페르소나에 기본 점수 부여 (0.1) - 아무도 배제되지 않도록
      double score = 0.1;

      // 1. 관심사 매칭 점수 (30% 가중치)
      if (_currentUser != null &&
          _currentUser!.interests.isNotEmpty &&
          persona.keywords != null) {
        int matchingInterests = 0;
        for (final interest in _currentUser!.interests) {
          // 페르소나 설명에서 관심사 키워드 찾기
          if (persona.description.contains(interest)) {
            matchingInterests++;
          }
          // 키워드에서 매칭
          if (persona.keywords!.any((keyword) =>
              keyword.toLowerCase().contains(interest.toLowerCase()) ||
              interest.toLowerCase().contains(keyword.toLowerCase()))) {
            matchingInterests++;
          }
        }
        score += (matchingInterests / _currentUser!.interests.length) * 0.3;
      }

      // 2. 용도 매칭 점수 (20% 가중치)
      if (_currentUser != null && _currentUser!.purpose != null) {
        switch (_currentUser!.purpose) {
          case 'friendship':
            // 친구 만들기 - 약간의 추가 점수
            score += 0.1;
            break;
          case 'dating':
            // 연애/데이팅 - 나이 선호도 반영
            score += 0.1;
            // 선호 나이대 매칭
            if (_currentUser!.preferredPersona != null &&
                _currentUser!.preferredPersona!.ageRange != null) {
              final ageRange = _currentUser!.preferredPersona!.ageRange!;
              if (persona.age >= ageRange[0] && persona.age <= ageRange[1]) {
                score += 0.1;
              }
            }
            break;
          case 'counseling':
            // 상담 - 약간의 추가 점수
            score += 0.1;
            break;
          case 'entertainment':
            // 엔터테인먼트 - 약간의 추가 점수
            score += 0.1;
            break;
        }
      }

      // 3. 성향 매칭 점수 (20% 가중치)
      if (_currentUser != null &&
          _currentUser!.preferredMbti != null &&
          _currentUser!.preferredMbti!.isNotEmpty) {
        if (_currentUser!.preferredMbti!.contains(persona.mbti)) {
          score += 0.2;
        }
      }

      // 4. 주제 매칭 점수 (10% 가중치)
      if (_currentUser != null &&
          _currentUser!.preferredTopics != null &&
          _currentUser!.preferredTopics!.isNotEmpty &&
          persona.topics != null) {
        int matchingTopics = 0;
        for (final topic in _currentUser!.preferredTopics!) {
          if (persona.topics!.any((pTopic) =>
              pTopic.toLowerCase().contains(topic.toLowerCase()) ||
              topic.toLowerCase().contains(pTopic.toLowerCase()))) {
            matchingTopics++;
          }
        }
        if (_currentUser!.preferredTopics!.isNotEmpty) {
          score +=
              (matchingTopics / _currentUser!.preferredTopics!.length) * 0.1;
        }
      }

      // 5. 랜덤 요소 추가 (10% 가중치) - 다양성 확보
      score += (persona.hashCode % 100) / 1000.0;

      return MapEntry(persona, score);
    }).toList();

    // 점수순으로 정렬 (높은 점수가 먼저)
    scoredPersonas.sort((a, b) => b.value.compareTo(a.value));

    // 상위 30%는 추천순, 나머지는 랜덤하게 섞어서 다양성 확보
    final topCount = (filteredPersonas.length * 0.3).ceil();
    final topPersonas =
        scoredPersonas.take(topCount).map((e) => e.key).toList();
    final otherPersonas =
        scoredPersonas.skip(topCount).map((e) => e.key).toList();
    otherPersonas.shuffle();

    // 모든 필터링된 페르소나 반환 (순서만 조정됨)
    final result = [...topPersonas, ...otherPersonas];
    debugPrint('✅ Recommendation complete: ${result.length} personas ordered');
    return result;
  }

  // 현재 사용자 정보 설정 (추천 알고리즘을 위해)
  AppUser? _currentUser;
  List<String> _actionedPersonaIds = [];

  void setCurrentUser(AppUser? user) {
    _currentUser = user;
    if (user != null) {
      _actionedPersonaIds = List<String>.from(user.actionedPersonaIds);
    }
    // 사용자 정보가 변경되면 페르소나 순서 재정렬
    _shuffledAvailablePersonas = null;
    notifyListeners();
  }

  /// Load actionedPersonaIds from Firebase if not already loaded
  Future<void> _loadActionedPersonaIds() async {
    if (_currentUserId == null) {
      debugPrint('⚠️ No user ID available for loading actionedPersonaIds');
      return;
    }

    debugPrint('🔄 Loading actionedPersonaIds for user: $_currentUserId');

    try {
      // user_persona_relationships에서 매칭된(isMatched=true) 페르소나만 가져오기
      final relationshipsQuery = await FirebaseHelper.userPersonaRelationships
          .where('userId', isEqualTo: _currentUserId)
          .where('isMatched', isEqualTo: true)
          .where('isActive', isEqualTo: true)
          .get();

      final matchedIds = <String>[];
      for (final doc in relationshipsQuery.docs) {
        final data = doc.data();
        final personaId = data['personaId'] as String?;
        final swipeAction = data['swipeAction'] ?? '';

        if (personaId != null &&
            (swipeAction == 'like' || swipeAction == 'super_like')) {
          matchedIds.add(personaId);
          debugPrint('  ✅ Found matched persona: $personaId ($swipeAction)');
        }
      }

      _actionedPersonaIds = matchedIds;
      debugPrint(
          '📋 Loaded ${_actionedPersonaIds.length} MATCHED personas as actionedPersonaIds');

      // users 컬렉션도 업데이트하여 동기화
      await FirebaseHelper.users.doc(_currentUserId).set({
        'actionedPersonaIds': _actionedPersonaIds,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      debugPrint('✅ Synced actionedPersonaIds to users collection');

      debugPrint(
          '📋 Final actionedPersonaIds (matched only): $_actionedPersonaIds');
    } catch (e) {
      debugPrint('❌ Error loading actionedPersonaIds: $e');
      // 에러 발생 시 빈 배열로 초기화
      _actionedPersonaIds = [];
    }
  }

  Future<bool> _likeTutorialPersona(String personaId) async {
    try {
      final persona = _allPersonas.where((p) => p.id == personaId).firstOrNull;
      if (persona == null) {
        debugPrint('⚠️ Persona not found for tutorial liking: $personaId');
        return false;
      }
      final matchedIds =
          await PreferencesManager.getStringList('tutorial_matched_personas') ??
              [];

      if (!matchedIds.contains(personaId)) {
        matchedIds.add(personaId);
        await PreferencesManager.setStringList(
            'tutorial_matched_personas', matchedIds);
      }

      final matchedPersona = persona.copyWith(
        likes: 50,
        imageUrls: persona.imageUrls, // Preserve imageUrls
      );

      if (!_matchedPersonas.any((p) => p.id == personaId)) {
        _matchedPersonas.add(matchedPersona);
      }

      _sessionSwipedPersonas[personaId] = DateTime.now();

      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error in tutorial matching: $e');
      return false;
    }
  }

  /// Public method to load tutorial personas (deprecated - use initialize() instead)
  @Deprecated('Use initialize() with tutorial_user userId instead')
  Future<void> loadTutorialPersonas() async {
    // This method is deprecated - initialize() should be used instead
    // for complete state setup including swiped personas and loading state
    debugPrint(
        '⚠️ loadTutorialPersonas() is deprecated, use initialize() instead');
    await initialize(userId: 'tutorial_user');
  }

  void setCurrentUserId(String userId) {
    // Check if user has actually changed
    if (_currentUserId != userId) {
      debugPrint('🔄 User ID changed from $_currentUserId to $userId');
      
      // Reset state when user changes
      _currentUserId = userId;
      
      // Reset matched personas state to force reload for new user
      _matchedPersonasLoaded = false;
      _matchedPersonas = [];
      
      // Clear cached data that might be from previous user
      _relationshipCache.clear();
      _sessionSwipedPersonas.clear();
      _shuffledAvailablePersonas = null;
      _lastShuffleTime = null;
      
      // Clear local storage of matched personas to prevent loading wrong user's data
      PreferencesManager.remove('matched_personas').then((_) {
        debugPrint('✅ Cleared local matched personas cache for user transition');
      });
      
      debugPrint('✅ PersonaService state reset for new user: $userId');
    }
    
    notifyListeners();
  }
  
  /// Check if current user is a guest (synchronous version for getters)
  bool _isGuestUserSync() {
    final auth = FirebaseAuth.instance;
    if (auth.currentUser == null) return false;
    if (!auth.currentUser!.isAnonymous) return false;
    
    // For sync context, check if currentUser is a guest (email check)
    return _currentUser?.email == 'guest@sona.app';
  }
  
  /// Check if current user is a guest (async version)
  Future<bool> _isGuestUser() async {
    final auth = FirebaseAuth.instance;
    if (auth.currentUser == null) return false;
    if (!auth.currentUser!.isAnonymous) return false;
    
    // Check if user is marked as guest in local storage
    final isGuest = await PreferencesManager.getBool(AppConstants.isGuestUserKey) ?? false;
    return isGuest;
  }

  Future<void> selectPersona(Persona persona, {bool clearPrevious = true}) async {
    await setCurrentPersona(persona, clearPrevious: clearPrevious);
  }

  /// Refresh current persona data from Firebase
  Future<void> refreshCurrentPersona() async {
    if (_currentPersona == null || _currentUserId == null) return;
    
    try {
      // Get fresh data from Firebase
      final relationshipData = await _loadUserPersonaRelationship(_currentPersona!.id);
      
      if (relationshipData != null) {
        final likes = relationshipData['likes'] ?? 
            relationshipData['relationshipScore'] ?? 50;
        
        // Update current persona with new likes value
        _currentPersona = _currentPersona!.copyWith(
          likes: likes,
          imageUrls: _currentPersona!.imageUrls, // Preserve imageUrls
        );
        
        // Also update cache
        _addToCache(
          _currentPersona!.id,
          _CachedRelationship(
            score: likes,
            isCasualSpeech: relationshipData['isCasualSpeech'] ?? false,
            timestamp: DateTime.now(),
          ),
        );
        
        debugPrint('✅ Refreshed ${_currentPersona!.name} - likes: $likes');
        notifyListeners();
      }
    } catch (e) {
      debugPrint('❌ Error refreshing current persona: $e');
    }
  }

  Future<bool> passPersona(String personaId) async {
    if (_currentUserId == null) {
      _currentUserId = await DeviceIdService.getTemporaryUserId();
    }

    try {
      final docId = '${_currentUserId}_$personaId';

      final persona = _allPersonas.where((p) => p.id == personaId).firstOrNull;

      final passData = {
        'userId': _currentUserId!,
        'personaId': personaId,
        'swipeAction': 'pass',
        'isMatched': false,
        'isActive': false,
        'passedAt': FieldValue.serverTimestamp(),
        'createdAt': FieldValue.serverTimestamp(),
        'personaName': persona?.name ?? '',
        'personaAge': persona?.age ?? 0,
        'personaPhotoUrl': '', // No photo URL for passed personas
      };

      await FirebaseHelper.userPersonaRelationships.doc(docId).set(passData);

      _sessionSwipedPersonas[personaId] = DateTime.now();

      // ❌ REMOVED: 패스한 페르소나는 actionedPersonaIds에 추가하지 않음
      // 매칭된 페르소나만 actionedPersonaIds에 포함되어야 함
      debugPrint(
          '✅ Passed persona $personaId - NOT adding to actionedPersonaIds');

      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error passing persona: $e');
      return false;
    }
  }

  Future<void> markPersonaAsSwiped(String personaId) async {
    _sessionSwipedPersonas[personaId] = DateTime.now();
    notifyListeners();
  }

  /// 매칭된 페르소나 목록에서 제거
  void removeFromMatchedPersonas(String personaId) {
    debugPrint('🗑️ Removing persona from matched list: $personaId');

    // 매칭된 페르소나 목록에서 제거
    _matchedPersonas.removeWhere((p) => p.id == personaId);

    // SharedPreferences에도 저장
    _saveMatchedPersonas();

    // UI 업데이트
    notifyListeners();
  }
  
  // 차단 시 즉시 매칭 목록에서 제거하는 메서드
  void removeFromMatched(String personaId) {
    removeFromMatchedPersonas(personaId);
  }

  /// 새로운 이미지 체크 및 다운로드
  Future<void> checkAndDownloadNewImages() async {
    debugPrint('🔍 Checking for new persona images...');

    final imagePreloadService = ImagePreloadService.instance;

    // 모든 페르소나 수집 (R2 이미지가 있는 것만)
    final allPersonasWithImages =
        _allPersonas.where((p) => _hasR2Image(p)).toList();

    if (allPersonasWithImages.isEmpty) {
      debugPrint('❌ No personas with R2 images found');
      return;
    }

    // 새로운 이미지가 있는지 확인
    final hasNewImages =
        await imagePreloadService.hasNewImages(allPersonasWithImages);

    if (hasNewImages) {
      debugPrint('🆕 New images detected! Starting download...');

      // 새로운 이미지 다운로드
      await imagePreloadService.preloadNewImages(allPersonasWithImages);

      debugPrint('✅ New images downloaded successfully');
    } else {
      debugPrint('✅ All images are already cached');
    }
  }

  /// 반말/존댓말 모드 업데이트
  Future<bool> updateCasualSpeech({
    required String personaId,
    required bool isCasualSpeech,
  }) async {
    if (_currentUserId == null) {
      debugPrint('⚠️ No user ID available for updating casual speech');
      return false;
    }

    debugPrint(
        '🗣️ Updating casual speech for persona $personaId to: $isCasualSpeech');

    try {
      // 1. Firebase 업데이트
      final docId = '${_currentUserId}_$personaId';
      await FirebaseHelper.userPersonaRelationships.doc(docId).update({
        'isCasualSpeech': isCasualSpeech,
        'casualSpeechUpdatedAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      debugPrint('✅ Firebase updated successfully');

      // 2. 현재 페르소나 업데이트
      if (_currentPersona?.id == personaId) {
        _currentPersonaCasualSpeech = isCasualSpeech;
        debugPrint(
            '✅ Current persona casual speech updated: ${_currentPersona!.name} → ${isCasualSpeech ? "반말" : "존댓말"}');
      }

      // 3. 매칭된 페르소나 리스트 업데이트
      final index = _matchedPersonas.indexWhere((p) => p.id == personaId);
      if (index != -1) {
        // 매칭된 페르소나 리스트에서는 likes 점수만 관리
        // isCasualSpeech는 캐시에서 별도 관리
        debugPrint('✅ Matched persona found in list');

        // Save to local storage
        await _saveMatchedPersonas();
      }

      // 4. 캐시 업데이트
      final cachedRelationship = _getFromCache(personaId);
      if (cachedRelationship != null) {
        _addToCache(
            personaId,
            _CachedRelationship(
              score: cachedRelationship.score,
              isCasualSpeech: isCasualSpeech,
              timestamp: DateTime.now(),
            ));
        debugPrint('✅ Cache updated');
      }

      // 5. UI 즉시 업데이트
      notifyListeners();

      debugPrint('🎯 Casual speech update completed successfully');
      return true;
    } catch (e) {
      debugPrint('❌ Error updating casual speech: $e');
      return false;
    }
  }

  /// Check if user has left the chat with this persona
  Future<bool> hasLeftChat(String personaId) async {
    if (_currentUserId == null) return false;
    
    try {
      // Check if user is guest
      final isGuest = await _isGuestUser();
      
      if (isGuest) {
        // Check local storage for guest users
        return await GuestConversationService.instance.getLeftChatStatus(personaId);
      } else {
        // Check Firebase for authenticated users
        final chatDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(_currentUserId)
            .collection('chats')
            .doc(personaId)
            .get();
        
        if (chatDoc.exists) {
          final data = chatDoc.data();
          return data?['leftChat'] == true;
        }
      }
    } catch (e) {
      debugPrint('❌ Error checking leftChat status: $e');
    }
    
    return false;
  }
  
  /// Reset leftChat status to allow re-joining
  Future<void> resetLeftChatStatus(String personaId) async {
    if (_currentUserId == null) return;
    
    try {
      // Check if user is guest
      final isGuest = await _isGuestUser();
      
      if (isGuest) {
        // Reset in local storage for guest users
        await GuestConversationService.instance.setLeftChatStatus(personaId, false);
        debugPrint('🔓 [PersonaService] Reset guest leftChat status for: $personaId');
      } else {
        // Reset in Firebase for authenticated users
        await FirebaseFirestore.instance
            .collection('users')
            .doc(_currentUserId!)
            .collection('chats')
            .doc(personaId)
            .update({
          'leftChat': false,
          'rejoinedAt': FieldValue.serverTimestamp(),
        });
        debugPrint('🔓 [PersonaService] Reset Firebase leftChat status for: $personaId');
      }
    } catch (e) {
      debugPrint('❌ Error resetting leftChat status: $e');
      // If document doesn't exist, create it
      if (e.toString().contains('NOT_FOUND')) {
        try {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(_currentUserId!)
              .collection('chats')
              .doc(personaId)
              .set({
            'leftChat': false,
            'rejoinedAt': FieldValue.serverTimestamp(),
          });
          debugPrint('✅ Created chat document with leftChat: false');
        } catch (createError) {
          debugPrint('❌ Error creating chat document: $createError');
        }
      }
    }
  }

  Future<bool> matchWithPersona(String personaId,
      {bool isSuperLike = false, Persona? personaObject, PurchaseService? purchaseService}) async {
    // 🔥 이미 매칭된 페르소나인지 먼저 확인
    if (_matchedPersonas.any((p) => p.id == personaId)) {
      debugPrint(
          '⚠️ Already matched with persona: $personaId - checking if re-joining...');
      
      // Check if this is a re-join scenario (user left chat before)
      final hasLeft = await hasLeftChat(personaId);
      if (hasLeft) {
        debugPrint('♻️ User is re-joining chat with persona: $personaId');
        // Reset leftChat status to allow re-entry
        await resetLeftChatStatus(personaId);
        // Return true to indicate successful re-join (no heart consumed)
        return true;
      }
      
      // Not a re-join, it's a duplicate match attempt
      debugPrint('❌ Duplicate match attempt blocked for: $personaId');
      return false;
    }

    if (isSuperLike) {
      debugPrint('⭐ Processing as SUPER LIKE: $personaId');
      return await superLikePersona(personaId, personaObject: personaObject, purchaseService: purchaseService);
    } else {
      debugPrint('💕 Processing as regular LIKE: $personaId');
      return await likePersona(personaId, personaObject: personaObject, purchaseService: purchaseService);
    }
  }

  Future<void> refreshMatchedPersonasRelationships() async {
    if (_currentUserId == null) return;

    try {
      final List<Persona> refreshedPersonas = [];
      
      // leftChat 상태를 체크할 Set
      final leftChatPersonaIds = <String>{};

      // Batch fetch relationships
      final personaIds = _matchedPersonas.map((p) => p.id).toList();
      final relationships = await batchGetRelationships(personaIds);
      
      // leftChat 상태 체크
      for (final personaId in personaIds) {
        final hasLeft = await hasLeftChat(personaId);
        if (hasLeft) {
          leftChatPersonaIds.add(personaId);
          debugPrint('🚪 Persona $personaId has left chat (refresh)');
        }
      }

      for (final persona in _matchedPersonas) {
        // leftChat인 페르소나는 제외
        if (leftChatPersonaIds.contains(persona.id)) {
          continue;
        }
        
        final relationshipData = relationships[persona.id];
        if (relationshipData != null) {
          // Parse matchedAt from relationship data
          DateTime? matchedAt = persona.matchedAt; // Keep existing if not in data
          if (relationshipData['matchedAt'] != null) {
            if (relationshipData['matchedAt'] is Timestamp) {
              matchedAt = (relationshipData['matchedAt'] as Timestamp).toDate();
            } else if (relationshipData['matchedAt'] is String) {
              try {
                matchedAt = DateTime.parse(relationshipData['matchedAt'] as String);
              } catch (e) {
                // Keep existing matchedAt on parse error
              }
            }
          }
          
          final refreshedPersona = persona.copyWith(
            likes: relationshipData['likes'] ??
                relationshipData['relationshipScore'] ??
                persona.likes,
            imageUrls: persona.imageUrls, // Preserve imageUrls
            matchedAt: matchedAt, // Include matchedAt
          );
          refreshedPersonas.add(refreshedPersona);

          // Update cache
          _addToCache(
              persona.id,
              _CachedRelationship(
                score: relationshipData['likes'] ??
                    relationshipData['relationshipScore'] ??
                    persona.likes,
                isCasualSpeech: relationshipData['isCasualSpeech'] ?? false,
                timestamp: DateTime.now(),
              ));
        } else {
          refreshedPersonas.add(persona);
        }
      }

      _matchedPersonas = refreshedPersonas;
      notifyListeners();
    } catch (e) {
      debugPrint('Error refreshing matched personas: $e');
    }
  }

  Future<Map<String, Map<String, dynamic>>> batchGetRelationships(
      List<String> personaIds) async {
    if (_currentUserId == null || personaIds.isEmpty) return {};

    try {
      final results = <String, Map<String, dynamic>>{};

      // Check cache first
      final uncachedIds = <String>[];
      for (final personaId in personaIds) {
        final cached = _getFromCache(personaId);
        if (cached != null) {
          results[personaId] = {
            'likes': cached.score,
            'isCasualSpeech': cached.isCasualSpeech,
            // Note: matchedAt not cached, will be loaded from Firebase
          };
        } else {
          uncachedIds.add(personaId);
        }
      }

      if (uncachedIds.isEmpty) return results;

      // Batch fetch uncached relationships
      for (int i = 0; i < uncachedIds.length; i += 10) {
        final batch = uncachedIds.skip(i).take(10).toList();

        final futures = batch.map((personaId) async {
          final docId = '${_currentUserId}_$personaId';
          final doc =
              await FirebaseHelper.userPersonaRelationships.doc(docId).get();

          if (doc.exists) {
            return MapEntry(personaId, doc.data()!);
          }
          return null;
        });

        final batchResults = await Future.wait(futures);

        for (final result in batchResults) {
          if (result != null) {
            results[result.key] = result.value;

            // Cache the result
            _addToCache(
                result.key,
                _CachedRelationship(
                  score: result.value['likes'] ??
                      result.value['relationshipScore'] ??
                      50,
                  isCasualSpeech: result.value['isCasualSpeech'] ?? false,
                  timestamp: DateTime.now(),
                ));
          }
        }
      }

      return results;
    } catch (e) {
      debugPrint('Error batch loading relationships: $e');
      return {};
    }
  }

  /// Update user's actionedPersonaIds list
  Future<void> _updateActionedPersonaIds(String personaId) async {
    if (_currentUserId == null) {
      debugPrint('⚠️ No user ID available for updating actionedPersonaIds');
      return;
    }

    try {
      // Update local list
      if (!_actionedPersonaIds.contains(personaId)) {
        _actionedPersonaIds.add(personaId);
        debugPrint(
            '📝 Added persona $personaId to local actionedPersonaIds list');
      }

      // Also update currentUser if available
      if (_currentUser != null) {
        if (!_currentUser!.actionedPersonaIds.contains(personaId)) {
          _currentUser = _currentUser!.copyWith(
            actionedPersonaIds: [
              ..._currentUser!.actionedPersonaIds,
              personaId
            ],
          );
          debugPrint(
              '📝 Added persona $personaId to currentUser actionedPersonaIds');
        }
      }

      // Always update Firebase to ensure persistence
      await FirebaseHelper.users.doc(_currentUserId).update({
        'actionedPersonaIds': FieldValue.arrayUnion([personaId]),
      });

      debugPrint(
          '✅ Updated actionedPersonaIds in Firebase for persona: $personaId');

      // Force reshuffle to immediately exclude this persona
      _shuffledAvailablePersonas = null;
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Error updating actionedPersonaIds: $e');
      // If the user document doesn't exist yet (e.g., guest user), create it
      if (e.toString().contains('NOT_FOUND')) {
        try {
          await FirebaseHelper.users.doc(_currentUserId).set({
            'actionedPersonaIds': [personaId],
            'updatedAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
          debugPrint('✅ Created user document with actionedPersonaIds');

          // Also update local list
          if (!_actionedPersonaIds.contains(personaId)) {
            _actionedPersonaIds.add(personaId);
          }
        } catch (createError) {
          debugPrint('❌ Error creating user document: $createError');
        }
      }
    }
  }

  /// Load personas from local cache
  Future<void> _loadPersonasFromCache() async {
    try {
      final cacheKey = 'cached_personas';
      final cachedData = await PreferencesManager.getString(cacheKey);

      if (cachedData != null) {
        final decoded = json.decode(cachedData) as Map<String, dynamic>;
        final cacheTime = DateTime.parse(decoded['timestamp'] as String);
        final personasList = decoded['personas'] as List;

        // Check if cache is less than 48 hours old to balance performance and freshness
        if (DateTime.now().difference(cacheTime).inHours < 48) {
          _allPersonas = personasList
              .map((data) => Persona.fromJson(data as Map<String, dynamic>))
              .toList();
          debugPrint('📦 Loaded ${_allPersonas.length} personas from cache');

          // Preload images for cached personas
          if (_allPersonas.isNotEmpty) {
            ImagePreloadService.instance
                .preloadNewImages(_allPersonas.take(10).toList());
          }
        }
      }
    } catch (e) {
      debugPrint('❌ Error loading personas from cache: $e');
    }
  }

  /// Save personas to local cache
  Future<void> _savePersonasToCache() async {
    try {
      final cacheData = {
        'timestamp': DateTime.now().toIso8601String(),
        'personas': _allPersonas.map((p) => p.toJson()).toList(),
      };

      final cacheKey = 'cached_personas';
      await PreferencesManager.setString(cacheKey, json.encode(cacheData));
      debugPrint('💾 Saved ${_allPersonas.length} personas to cache');
    } catch (e) {
      debugPrint('❌ Error saving personas to cache: $e');
    }
  }

  /// Check if cache is stale
  Future<bool> _isCacheStale() async {
    try {
      final cacheKey = 'cached_personas_timestamp';
      final timestamp = await PreferencesManager.getString(cacheKey);

      if (timestamp == null) return true;

      final cacheTime = DateTime.parse(timestamp);
      // Consider cache stale after 48 hours to ensure new personas are loaded
      return DateTime.now().difference(cacheTime).inHours >= 48;
    } catch (e) {
      return true;
    }
  }

  /// Load personas from Firebase
  Future<void> _loadPersonasFromFirebase() async {
    try {
      final success = await _loadFromFirebase();
      if (success) {
        // Save to cache after successful load
        await _savePersonasToCache();

        // Update cache timestamp
        await PreferencesManager.setString(
          'cached_personas_timestamp',
          DateTime.now().toIso8601String(),
        );
      }
    } catch (e) {
      debugPrint('❌ Error loading personas from Firebase: $e');
    }
  }
  
  /// Clear all loaded data from memory to force reload from Firebase
  void clearLoadedData() {
    debugPrint('🗑️ Clearing all loaded persona data from memory');
    _allPersonas.clear();
    _matchedPersonas.clear();
    _shuffledAvailablePersonas = null;
    _lastShuffleTime = null;
    _matchedPersonasLoaded = false;
    _loadingCompleter = null;
    _sessionSwipedPersonas.clear();
    _personaMemoryCache.clear();
    _lastPersonaCacheUpdate = null;
    notifyListeners();
  }
}

/// Helper classes
class _CachedRelationship {
  final int score;
  final bool isCasualSpeech;
  final DateTime timestamp;

  _CachedRelationship({
    required this.score,
    required this.isCasualSpeech,
    required this.timestamp,
  });
}

class _PendingRelationshipUpdate {
  final String userId;
  final String personaId;
  final int newScore;
  _PendingRelationshipUpdate({
    required this.userId,
    required this.personaId,
    required this.newScore,
  });
}
