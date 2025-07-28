import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/persona.dart';
import '../../models/app_user.dart';
import '../auth/device_id_service.dart';
import '../base/base_service.dart';
import '../../helpers/firebase_helper.dart';
import '../../core/constants.dart';
import '../../core/preferences_manager.dart';
import '../relationship/relation_score_service.dart';

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
  
  // Stable shuffled list for swipe session
  List<Persona>? _shuffledAvailablePersonas;
  DateTime? _lastShuffleTime;
  
  // Caching system
  final Map<String, _CachedRelationship> _relationshipCache = {};
  static const Duration _cacheTTL = Duration(minutes: 5);
  static const int _maxCacheSize = 100;
  
  // Batch operation queue
  final List<_PendingRelationshipUpdate> _pendingUpdates = [];
  Timer? _batchUpdateTimer;
  static const Duration _batchUpdateDelay = Duration(seconds: 2);
  static const int _maxBatchSize = 10;
  
  // Session data
  final Map<String, DateTime> _sessionSwipedPersonas = {};
  
  // Lazy loading state
  bool _matchedPersonasLoaded = false;
  Completer<void>? _loadingCompleter;
  
  // Getters
  List<Persona> get availablePersonas {
    _cleanExpiredSwipes();
    
    // Check if we need to reshuffle (every 30 minutes or if list is null)
    final now = DateTime.now();
    final shouldReshuffle = _shuffledAvailablePersonas == null ||
        _lastShuffleTime == null ||
        now.difference(_lastShuffleTime!).inMinutes >= 30;
    
    if (shouldReshuffle) {
      debugPrint('🔀 Reshuffling available personas...');
      
      // Exclude both recently swiped and matched personas
      final matchedIds = _matchedPersonas.map((p) => p.id).toSet();
      final filtered = _allPersonas.where((persona) => 
        !_isPersonaRecentlySwiped(persona.id) && 
        !matchedIds.contains(persona.id) &&
        _hasR2Image(persona)  // Only include personas with R2 images
      ).toList();
      
      // Get recommended personas for current user
      final recommendedPersonas = getRecommendedPersonas(filtered);
      _shuffledAvailablePersonas = recommendedPersonas;
      _lastShuffleTime = now;
      
      debugPrint('✅ Sorted ${recommendedPersonas.length} personas by recommendation score');
    } else {
      // Update the existing shuffled list to exclude newly swiped/matched personas
      final matchedIds = _matchedPersonas.map((p) => p.id).toSet();
      _shuffledAvailablePersonas = _shuffledAvailablePersonas!.where((persona) => 
        !_isPersonaRecentlySwiped(persona.id) && 
        !matchedIds.contains(persona.id) &&
        _hasR2Image(persona)  // Only include personas with R2 images
      ).toList();
    }
    
    return List<Persona>.from(_shuffledAvailablePersonas!);
  }
  
  List<Persona> get allPersonas => _allPersonas;
  List<Persona> get matchedPersonas {
    if (!_matchedPersonasLoaded) {
      _lazyLoadMatchedPersonas();
    }
    // Filter out personas without R2 images
    return _matchedPersonas.where((persona) => _hasR2Image(persona)).toList();
  }
  
  Persona? get currentPersona => _currentPersona;
  @override
  bool get isLoading => super.isLoading;
  int get swipedPersonasCount => _sessionSwipedPersonas.length;
  
  // Additional getters for compatibility
  List<Persona> get sessionPersonas => _matchedPersonas;
  List<Persona> get myPersonas => _matchedPersonas;

  /// Get persona by ID from all personas
  Persona? getPersonaById(String personaId) {
    try {
      return _allPersonas.firstWhere((persona) => persona.id == personaId);
    } catch (e) {
      debugPrint('Persona not found with ID: $personaId');
      return null;
    }
  }

  /// Initialize service with parallel loading
  Future<void> initialize({String? userId}) async {
    // Prevent duplicate initialization
    if (_loadingCompleter != null && !_loadingCompleter!.isCompleted) {
      return _loadingCompleter!.future;
    }
    
    _loadingCompleter = Completer<void>();
    
    await executeWithLoading(() async {
      
      await _initializeNormalMode(userId);
      
      _loadingCompleter!.complete();
    }, errorContext: 'initialize', showError: false);
  }


  /// Normal mode initialization with parallel loading
  Future<void> _initializeNormalMode(String? userId) async {
    _currentUserId = await DeviceIdService.getCurrentUserId(
      firebaseUserId: userId,
    );
    
    debugPrint('🚀 PersonaService initializing with userId: $_currentUserId');
    
    // isLoading is managed by BaseService
    notifyListeners();
    
    // Parallel loading for performance
    final results = await Future.wait([
      _loadFromFirebaseOrFallback(),
      _loadSwipedPersonas(),
    ]);
    
    // Lazy load matched personas
    _matchedPersonasLoaded = false;
    
    // isLoading is managed by BaseService
    notifyListeners();
  }

  /// Load personas from Firebase with fallback
  Future<void> _loadFromFirebaseOrFallback() async {
    try {
      final success = await _loadFromFirebase();
      if (!success) {
        debugPrint('Firebase failed, using empty persona list...');
        _allPersonas = [];
        debugPrint('✅ Using empty persona list');
      }
    } catch (e) {
      debugPrint('Error loading from Firebase: $e, using empty list');
      _allPersonas = [];
    }
  }

  /// Lazy load matched personas
  Future<void> _lazyLoadMatchedPersonas() async {
    if (_matchedPersonasLoaded || _currentUserId == null) return;
    
    _matchedPersonasLoaded = true;
    
    try {
      await _loadMatchedPersonas();
    } catch (e) {
      debugPrint('Error lazy loading matched personas: $e');
    }
  }

  /// Set current persona with cached relationship data
  Future<void> setCurrentPersona(Persona persona) async {
    if (_currentUserId != null) {
      // Check cache first
      final cachedRelationship = _getFromCache(persona.id);
      
      if (cachedRelationship != null) {
        _currentPersona = persona.copyWith(
          relationshipScore: cachedRelationship.score,
          currentRelationship: _getRelationshipTypeFromScore(cachedRelationship.score),
          isCasualSpeech: cachedRelationship.isCasualSpeech,
          imageUrls: persona.imageUrls,  // Preserve imageUrls
        );
        notifyListeners();
        return;
      }
      
      // Load from Firebase if not cached
      final relationshipData = await _loadUserPersonaRelationship(persona.id);
      if (relationshipData != null) {
        _currentPersona = persona.copyWith(
          relationshipScore: relationshipData['relationshipScore'] ?? 50,
          currentRelationship: _getRelationshipTypeFromScore(relationshipData['relationshipScore'] ?? 50),
          isCasualSpeech: relationshipData['isCasualSpeech'] ?? false,
          imageUrls: persona.imageUrls,  // Preserve imageUrls
        );
        
        // Cache the relationship
        _addToCache(persona.id, _CachedRelationship(
          score: relationshipData['relationshipScore'] ?? 50,
          isCasualSpeech: relationshipData['isCasualSpeech'] ?? false,
          timestamp: DateTime.now(),
        ));
      } else {
        _currentPersona = persona;
      }
    } else {
      _currentPersona = persona;
    }
    notifyListeners();
  }

  /// Optimized persona like with batch operations
  Future<bool> likePersona(String personaId) async {
    if (_currentUserId == null) {
      _currentUserId = await DeviceIdService.getTemporaryUserId();
    }

    if (_currentUserId == '') {
      debugPrint('⚠️ No user ID available for liking persona');
      return false;
    }

    try {
      final persona = _allPersonas.where((p) => p.id == personaId).firstOrNull;
      if (persona == null) {
        debugPrint('⚠️ Persona not found for liking: $personaId');
        return false;
      }
      
      // Create relationship data
      final relationshipData = {
        'userId': _currentUserId!,
        'personaId': personaId,
        'relationshipScore': 50,
        'relationshipType': 'friend',
        'relationshipDisplayName': '친구',
        'isCasualSpeech': false,
        'swipeAction': 'like',
        'isMatched': true,
        'isActive': true,
        'matchedAt': FieldValue.serverTimestamp(),
        'createdAt': FieldValue.serverTimestamp(),
        'lastInteraction': FieldValue.serverTimestamp(),
        'personaName': persona.name,
        'personaAge': persona.age,
        'personaPhotoUrl': persona.photoUrls.isNotEmpty ? persona.photoUrls.first : '',
      };

      // Queue for batch operation
      _queueRelationshipCreate(relationshipData);

      // Update local state immediately
      final matchedPersona = persona.copyWith(
        relationshipScore: 50,
        currentRelationship: RelationshipType.friend,
        isCasualSpeech: false,
        imageUrls: persona.imageUrls,  // Preserve imageUrls
      );
      
      if (!_matchedPersonas.any((p) => p.id == personaId)) {
        _matchedPersonas.add(matchedPersona);
        await _saveMatchedPersonas();
      }
      
      _sessionSwipedPersonas[personaId] = DateTime.now();
      
      // Cache the relationship
      _addToCache(personaId, _CachedRelationship(
        score: 50,
        isCasualSpeech: false,
        timestamp: DateTime.now(),
      ));
      
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error liking persona: $e');
      return false;
    }
  }

  /// Optimized persona super like with enhanced relationship score
  Future<bool> superLikePersona(String personaId) async {
    if (_currentUserId == null) {
      _currentUserId = await DeviceIdService.getTemporaryUserId();
    }

    if (_currentUserId == '') {
      debugPrint('⚠️ No user ID available for super liking persona');
      return false;
    }

    try {
      final persona = _allPersonas.where((p) => p.id == personaId).firstOrNull;
      if (persona == null) {
        debugPrint('⚠️ Persona not found for super liking: $personaId');
        return false;
      }
      
      debugPrint('⭐ Processing SUPER LIKE for persona: ${persona.name}');
      
      // Create relationship data with super like relationship score (200)
      final relationshipData = {
        'userId': _currentUserId!,
        'personaId': personaId,
        'relationshipScore': 200, // 🌟 Super like starts with 200 (crush level)
        'relationshipType': 'crush',
        'relationshipDisplayName': '썸',
        'isCasualSpeech': false,
        'swipeAction': 'super_like',
        'isMatched': true,
        'isActive': true,
        'matchedAt': FieldValue.serverTimestamp(),
        'createdAt': FieldValue.serverTimestamp(),
        'lastInteraction': FieldValue.serverTimestamp(),
        'personaName': persona.name,
        'personaAge': persona.age,
        'personaPhotoUrl': persona.photoUrls.isNotEmpty ? persona.photoUrls.first : '',
      };

      // Queue for batch operation
      _queueRelationshipCreate(relationshipData);

      // Update local state immediately with super like score
      final matchedPersona = persona.copyWith(
        relationshipScore: 200, // 🌟 Super like relationship score
        currentRelationship: RelationshipType.crush, // 🌟 Super like relationship type
        isCasualSpeech: false,
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
      
      _sessionSwipedPersonas[personaId] = DateTime.now();
      
      // Cache the relationship with super like score
      _addToCache(personaId, _CachedRelationship(
        score: 200, // 🌟 Super like score
        isCasualSpeech: false,
        timestamp: DateTime.now(),
      ));
      
      debugPrint('✅ Super like processed successfully: ${persona.name} → 200 (썸)');
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
        debugPrint('⚠️ Persona not found for tutorial super liking: $personaId');
        return false;
      }
      
      debugPrint('🎓⭐ Processing tutorial SUPER LIKE for persona: ${persona.name}');
      
      final matchedIds = await PreferencesManager.getStringList('tutorial_matched_personas') ?? [];
      
      if (!matchedIds.contains(personaId)) {
        matchedIds.add(personaId);
        await PreferencesManager.setStringList('tutorial_matched_personas', matchedIds);
      }
      
      // Also save to super liked list
      final superLikedIds = await PreferencesManager.getStringList('tutorial_super_liked_personas') ?? [];
      if (!superLikedIds.contains(personaId)) {
        superLikedIds.add(personaId);
        await PreferencesManager.setStringList('tutorial_super_liked_personas', superLikedIds);
        debugPrint('💾 Saved super like flag for: ${persona.name}');
      }
      
      // Super like creates crush relationship (200 score)
      final matchedPersona = persona.copyWith(
        relationshipScore: 200, // 🌟 Super like relationship score
        currentRelationship: RelationshipType.crush, // 🌟 Super like relationship type
        isCasualSpeech: false,
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
      
      debugPrint('✅ Tutorial super like processed successfully: ${persona.name} → 200 (썸)');
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error in tutorial super liking: $e');
      return false;
    }
  }

  /// Update relationship score with enhanced logging and immediate processing
  Future<void> updateRelationshipScore(String personaId, int change, String userId) async {
    if (userId.isEmpty || change == 0) {
      debugPrint('⏭️ Skipping relationship update: userId=$userId, change=$change');
      return;
    }
    
    debugPrint('🔄 Starting relationship score update: personaId=$personaId, change=$change, userId=$userId');
    
    try {
      // Get current score from cache or persona
      int currentScore = 50;
      final cachedRelationship = _getFromCache(personaId);
      
      if (cachedRelationship != null) {
        currentScore = cachedRelationship.score;
        debugPrint('📋 Using cached score: $currentScore');
      } else if (_currentPersona?.id == personaId) {
        currentScore = _currentPersona!.relationshipScore;
        debugPrint('👤 Using current persona score: $currentScore');
      } else {
        final matchedPersona = _matchedPersonas.where((p) => p.id == personaId).firstOrNull;
        if (matchedPersona != null) {
          currentScore = matchedPersona.relationshipScore;
          debugPrint('💕 Using matched persona score: $currentScore');
        } else {
          // Get from RelationScoreService
          currentScore = await RelationScoreService.instance.getRelationshipScore(
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
      
      final newScore = (currentScore + change).clamp(0, 1000);
      final relationshipType = RelationScoreService.instance.getRelationshipType(newScore);
      
      debugPrint('📊 Score calculation: $currentScore + $change = $newScore (${relationshipType.displayName})');
      
      // Update relationship in Firebase
      debugPrint('🔥 Normal mode - queuing Firebase update');
      // Queue update for batch processing
      _queueRelationshipUpdate(_PendingRelationshipUpdate(
          userId: userId,
          personaId: personaId,
          newScore: newScore,
          relationshipType: relationshipType,
        ));
        
        // 🔧 FIX: Immediately process batch if this is a significant change
        if (change.abs() >= 3) {
          debugPrint('🚀 Significant change detected ($change) - processing immediately');
          Future.microtask(() => _processBatchUpdates());
        }
      
      // Update local state immediately for all modes
      if (_currentPersona?.id == personaId) {
        _currentPersona = _currentPersona?.copyWith(
          relationshipScore: newScore,
          currentRelationship: relationshipType,
          imageUrls: _currentPersona?.imageUrls,  // Preserve imageUrls
        );
        debugPrint('✅ Updated current persona: ${_currentPersona!.name} → $newScore');
        // 🔥 즉시 UI 업데이트 (currentPersona 변경)
        notifyListeners();
      }
      
      // Update matched personas list
      final index = _matchedPersonas.indexWhere((p) => p.id == personaId);
      if (index != -1) {
        _matchedPersonas[index] = _matchedPersonas[index].copyWith(
          relationshipScore: newScore,
          currentRelationship: relationshipType,
          imageUrls: _matchedPersonas[index].imageUrls,  // Preserve imageUrls
        );
        debugPrint('✅ Updated matched persona: ${_matchedPersonas[index].name} → $newScore');
      }
      
      // Update cache
      _addToCache(personaId, _CachedRelationship(
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
  void _queueRelationshipCreate(Map<String, dynamic> relationshipData) {
    final docId = '${relationshipData['userId']}_${relationshipData['personaId']}';
    
    FirebaseHelper.userPersonaRelationships
        .doc(docId)
        .set(relationshipData)
        .catchError((e) {
          debugPrint('Error creating relationship: $e');
        });
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
        final persona = _allPersonas.where((p) => p.id == update.personaId).firstOrNull;
        
        // Use set with merge to create document if it doesn't exist
        batch.set(docRef, {
          'userId': update.userId,
          'personaId': update.personaId,
          'relationshipScore': update.newScore,
          'relationshipType': update.relationshipType.name,
          'relationshipDisplayName': update.relationshipType.displayName,
          'lastInteraction': FieldValue.serverTimestamp(),
          'totalInteractions': FieldValue.increment(1),
          'isMatched': true,
          'isActive': true,
          // Add persona info for convenience
          'personaName': persona?.name ?? 'Unknown',
          'personaAge': persona?.age ?? 0,
          'personaPhotoUrl': (persona?.photoUrls.isNotEmpty == true) ? persona!.photoUrls.first : '',
          // Update existing document or create new one
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
        
        debugPrint('📝 Queued update: ${update.personaId} → ${update.newScore}');
      }
      
      await batch.commit();
      debugPrint('✅ Successfully batch updated ${updates.length} relationships');
    } catch (e) {
      debugPrint('❌ Error in batch update: $e');
      // Re-queue failed updates for retry
      _pendingUpdates.addAll(updates);
      
      // If it's a permission error, don't retry indefinitely
      if (e.toString().contains('permission-denied')) {
        debugPrint('🚫 Permission denied - clearing failed updates to prevent infinite retry');
        _pendingUpdates.clear();
      }
    }
  }

  /// Optimized matched personas loading with caching
  Future<void> _loadMatchedPersonas() async {
    if (_currentUserId == '') {
      debugPrint('⚠️ No user ID available for loading matched personas');
      return;
    }

    if (_currentUserId == null) {
      await _loadMatchedPersonasFromLocal();
      return;
    }

    try {
      // Try simple query first
      final querySnapshot = await FirebaseHelper.userPersonaRelationships
          .where('userId', isEqualTo: _currentUserId!)
          .get();

      _matchedPersonas.clear();
      
      // Process in parallel
      final futures = <Future>[];
      
      for (final doc in querySnapshot.docs) {
        final data = doc.data();
        final isMatched = data['isMatched'] ?? false;
        final isActive = data['isActive'] ?? false;
        
        if (!isMatched || !isActive) continue;
        
        final personaId = data['personaId'] as String?;
        if (personaId == null) continue;
        
        final persona = _allPersonas.where((p) => p.id == personaId).firstOrNull;
        if (persona != null) {
          final relationshipScore = data['relationshipScore'] ?? 50;
          final matchedPersona = persona.copyWith(
            relationshipScore: relationshipScore,
            currentRelationship: _getRelationshipTypeFromScore(relationshipScore),
            isCasualSpeech: data['isCasualSpeech'] ?? false,
            imageUrls: persona.imageUrls,  // Preserve imageUrls
          );
          
          _matchedPersonas.add(matchedPersona);
          
          // Cache relationship data
          _addToCache(personaId, _CachedRelationship(
            score: relationshipScore,
            isCasualSpeech: data['isCasualSpeech'] ?? false,
            timestamp: DateTime.now(),
          ));
        }
      }
      
      // Sort by relationship score
      _matchedPersonas.sort((a, b) => b.relationshipScore.compareTo(a.relationshipScore));
      
      await _saveMatchedPersonas();
      
    } catch (e) {
      debugPrint('Error loading matched personas: $e');
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
          final querySnapshot = await FirebaseHelper.personas
              .get();
          
          if (querySnapshot.docs.isNotEmpty) {
            _allPersonas = _parseFirebasePersonas(querySnapshot.docs);
            debugPrint('✅ SUCCESS: Direct access loaded ${_allPersonas.length} personas');
            return true;
          }
        }
        
        // Strategy 2: Anonymous authentication
        else if (attempt == 2) {
          debugPrint('🎭 Trying anonymous authentication...');
          try {
            final userCredential = await FirebaseAuth.instance.signInAnonymously();
            debugPrint('✅ Anonymous auth successful: ${userCredential.user?.uid}');
            
            await Future.delayed(const Duration(milliseconds: 500)); // Give time for auth to propagate
            
            final querySnapshot = await FirebaseFirestore.instance
                .collection('personas')
                .get();
                
            if (querySnapshot.docs.isNotEmpty) {
              _allPersonas = _parseFirebasePersonas(querySnapshot.docs);
              debugPrint('✅ SUCCESS: Anonymous auth loaded ${_allPersonas.length} personas');
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
            
            final querySnapshot = await FirebaseFirestore.instance
                .collection('personas')
                .get();
                
            if (querySnapshot.docs.isNotEmpty) {
              _allPersonas = _parseFirebasePersonas(querySnapshot.docs);
              debugPrint('✅ SUCCESS: Retry loaded ${_allPersonas.length} personas');
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
              debugPrint('✅ SUCCESS: Limited query loaded ${_allPersonas.length} personas');
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

  /// Parse Firebase personas documents into Persona objects
  List<Persona> _parseFirebasePersonas(List<QueryDocumentSnapshot> docs) {
    return docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      
      // Parse photoUrls - handle both string and array formats with validation
      List<String> photoUrls = [];
      
      // First check if R2 images are available in imageUrls field
      if (data['imageUrls'] != null && data['imageUrls'] is Map) {
        // R2 images are available, clear photoUrls to force using R2 images
        photoUrls = [];
        debugPrint('🎯 R2 images available for ${data['name']}, clearing photoUrls');
      } else if (data['photoUrls'] != null) {
        // No R2 images, use legacy photoUrls with validation
        if (data['photoUrls'] is List) {
          final rawUrls = List<String>.from(data['photoUrls']);
          photoUrls = _validateAndFilterPhotoUrls(rawUrls);
        } else if (data['photoUrls'] is String) {
          String photoUrlsStr = data['photoUrls'];
          // Remove brackets and split by comma
          photoUrlsStr = photoUrlsStr.replaceAll('[', '').replaceAll(']', '');
          final rawUrls = photoUrlsStr.split(', ').map((url) => url.trim()).toList();
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
        currentRelationship: RelationshipType.friend,
        relationshipScore: 0,
        isCasualSpeech: false,
        gender: data['gender'] ?? 'female',
        mbti: data['mbti'] ?? 'ENFP',
        imageUrls: imageUrls,  // Add R2 image URLs
        topics: data['topics'] != null 
          ? List<String>.from(data['topics'])
          : null,
        keywords: data['keywords'] != null 
          ? List<String>.from(data['keywords'])
          : null,
      );
      
      return persona;
    }).toList();
  }

  /// 🔧 Validate and filter photo URLs - only return valid URLs, no placeholders
  List<String> _validateAndFilterPhotoUrls(List<String> rawUrls) {
    List<String> validUrls = [];
    
    for (String url in rawUrls) {
      String trimmedUrl = url.trim();
      
      // Skip empty URLs
      if (trimmedUrl.isEmpty) continue;
      
      // Check if URL is valid (starts with http or https)
      if (trimmedUrl.startsWith('http://') || trimmedUrl.startsWith('https://')) {
        validUrls.add(trimmedUrl);
      }
      // Skip invalid URLs (like assets/images/...) without replacement
    }
    
    return validUrls;
  }


  // Other helper methods remain the same...
  
  RelationshipType _getRelationshipTypeFromScore(int score) {
    return RelationScoreService.instance.getRelationshipType(score);
  }

  Future<Map<String, dynamic>?> _loadUserPersonaRelationship(String personaId) async {
    if (_currentUserId == null) return null;
    
    try {
      final docId = '${_currentUserId}_$personaId';
      final doc = await FirebaseHelper.userPersonaRelationships
          .doc(docId)
          .get();
      
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
      final swipedIds = await PreferencesManager.getStringList('swiped_personas') ?? [];
      
      _sessionSwipedPersonas.clear();
      for (String id in swipedIds) {
        _sessionSwipedPersonas[id] = DateTime.now().subtract(const Duration(hours: 1));
      }
    } catch (e) {
      debugPrint('Error loading swiped personas: $e');
    }
  }

  Future<void> _loadMatchedPersonasFromLocal() async {
    try {
      final matchedIds = await PreferencesManager.getStringList('matched_personas') ?? [];
      
      _matchedPersonas = _allPersonas
          .where((persona) => matchedIds.contains(persona.id))
          .toList();
    } catch (e) {
      debugPrint('Error loading from local storage: $e');
      _matchedPersonas = [];
    }
  }

  Future<void> _saveMatchedPersonas() async {
    try {
      final matchedIds = _matchedPersonas.map((persona) => persona.id).toList();
      await PreferencesManager.setStringList('matched_personas', matchedIds);
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
    _sessionSwipedPersonas.removeWhere((id, time) => 
      now.difference(time).inHours >= 24);
  }
  
  /// Check if persona has R2 image
  bool _hasR2Image(Persona persona) {
    return persona.imageUrls != null && persona.imageUrls!.isNotEmpty;
  }
  
  /// Force reshuffle of available personas (useful after major changes)
  void reshuffleAvailablePersonas() {
    debugPrint('🔄 Force reshuffling available personas...');
    _shuffledAvailablePersonas = null;
    _lastShuffleTime = null;
    notifyListeners();
  }
  
  /// 추천 알고리즘 - 사용자 선호도에 따라 페르소나 정렬
  List<Persona> getRecommendedPersonas(List<Persona> personas) {
    // 현재 사용자 정보가 없으면 랜덤 순서로 반환
    if (_currentUser == null) {
      personas.shuffle();
      return personas;
    }
    
    // 각 페르소나에 대한 추천 점수 계산
    final scoredPersonas = personas.map((persona) {
      double score = 0.0;
      
      // 1. 관심사 매칭 점수 (40%)
      if (_currentUser != null && _currentUser!.interests.isNotEmpty && persona.keywords != null) {
        int matchingInterests = 0;
        for (final interest in _currentUser!.interests) {
          // 페르소나 설명에서 관심사 키워드 찾기
          if (persona.description.contains(interest)) {
            matchingInterests++;
          }
          // 키워드에서 매칭
          if (persona.keywords!.any((keyword) => 
            keyword.toLowerCase().contains(interest.toLowerCase()) ||
            interest.toLowerCase().contains(keyword.toLowerCase())
          )) {
            matchingInterests++;
          }
        }
        score += (matchingInterests / _currentUser!.interests.length) * 0.4;
      }
      
      // 2. 용도 매칭 점수 (30%)
      if (_currentUser != null && _currentUser!.purpose != null) {
        switch (_currentUser!.purpose) {
          case 'friendship':
            // 친구 만들기 - 모든 페르소나 동일하게 취급
            score += 0.3;
            break;
          case 'dating':
            // 연애/데이팅 - 일반 페르소나 중 나이/성별 선호도 반영
            score += 0.2;
            // 선호 성별 매칭
            if (_currentUser!.preferredPersona != null && persona.gender == _currentUser!.preferredPersona!.gender) {
              score += 0.05;
            }
            // 선호 나이대 매칭
            if (_currentUser!.preferredPersona != null && _currentUser!.preferredPersona!.ageRange != null) {
              final ageRange = _currentUser!.preferredPersona!.ageRange!;
              if (persona.age >= ageRange[0] && persona.age <= ageRange[1]) {
                score += 0.05;
              }
            }
            break;
          case 'counseling':
            // 상담 - 모든 페르소나 가능
            score += 0.2;
            break;
          case 'entertainment':
            // 엔터테인먼트 - 다양한 페르소나
            score += 0.15; // 기본 점수
            break;
        }
      }
      
      // 3. 성향 매칭 점수 (20%)
      if (_currentUser != null && _currentUser!.preferredMbti != null && _currentUser!.preferredMbti!.isNotEmpty) {
        if (_currentUser!.preferredMbti!.contains(persona.mbti)) {
          score += 0.2;
        }
      }
      
      // 4. 주제 매칭 점수 (10%)
      if (_currentUser != null && _currentUser!.preferredTopics != null && 
          _currentUser!.preferredTopics!.isNotEmpty && 
          persona.topics != null) {
        int matchingTopics = 0;
        for (final topic in _currentUser!.preferredTopics!) {
          if (persona.topics!.any((pTopic) => 
            pTopic.toLowerCase().contains(topic.toLowerCase()) ||
            topic.toLowerCase().contains(pTopic.toLowerCase())
          )) {
            matchingTopics++;
          }
        }
        if (_currentUser!.preferredTopics!.isNotEmpty) {
          score += (matchingTopics / _currentUser!.preferredTopics!.length) * 0.1;
        }
      }
      
      // 5. 페르소나 타입 선호도 반영
      if (_currentUser != null && _currentUser!.preferredPersonaTypes != null) {
        if (_currentUser!.preferredPersonaTypes!.contains('normal')) {
          score += 0.05;
        }
      }
      
      return MapEntry(persona, score);
    }).toList();
    
    // 점수순으로 정렬 (높은 점수가 먼저)
    scoredPersonas.sort((a, b) => b.value.compareTo(a.value));
    
    // 상위 20%는 추천순, 나머지는 랜덤하게 섞어서 다양성 확보
    final topCount = (personas.length * 0.2).ceil();
    final topPersonas = scoredPersonas.take(topCount).map((e) => e.key).toList();
    final otherPersonas = scoredPersonas.skip(topCount).map((e) => e.key).toList();
    otherPersonas.shuffle();
    
    return [...topPersonas, ...otherPersonas];
  }
  
  // 현재 사용자 정보 설정 (추천 알고리즘을 위해)
  AppUser? _currentUser;
  
  void setCurrentUser(AppUser? user) {
    _currentUser = user;
    // 사용자 정보가 변경되면 페르소나 순서 재정렬
    _shuffledAvailablePersonas = null;
    notifyListeners();
  }

  Future<bool> _likeTutorialPersona(String personaId) async {
    try {
      final persona = _allPersonas.where((p) => p.id == personaId).firstOrNull;
      if (persona == null) {
        debugPrint('⚠️ Persona not found for tutorial liking: $personaId');
        return false;
      }
      final matchedIds = await PreferencesManager.getStringList('tutorial_matched_personas') ?? [];
      
      if (!matchedIds.contains(personaId)) {
        matchedIds.add(personaId);
        await PreferencesManager.setStringList('tutorial_matched_personas', matchedIds);
      }
      
      final matchedPersona = persona.copyWith(
        relationshipScore: 50,
        currentRelationship: RelationshipType.friend,
        isCasualSpeech: false,
        imageUrls: persona.imageUrls,  // Preserve imageUrls
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
    debugPrint('⚠️ loadTutorialPersonas() is deprecated, use initialize() instead');
    await initialize(userId: 'tutorial_user');
  }

  void setCurrentUserId(String userId) {
    _currentUserId = userId;
    notifyListeners();
  }

  Future<void> selectPersona(Persona persona) async {
    await setCurrentPersona(persona);
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
        'personaPhotoUrl': '',  // No photo URL for passed personas
      };

      await FirebaseHelper.userPersonaRelationships
          .doc(docId)
          .set(passData);

      _sessionSwipedPersonas[personaId] = DateTime.now();
      
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

  Future<bool> matchWithPersona(String personaId, {bool isSuperLike = false}) async {
    if (isSuperLike) {
      debugPrint('⭐ Processing as SUPER LIKE: $personaId');
      return await superLikePersona(personaId);
    } else {
      debugPrint('💕 Processing as regular LIKE: $personaId');
      return await likePersona(personaId);
    }
  }

  Future<void> refreshMatchedPersonasRelationships() async {
    if (_currentUserId == null) return;
    
    try {
      final List<Persona> refreshedPersonas = [];
      
      // Batch fetch relationships
      final personaIds = _matchedPersonas.map((p) => p.id).toList();
      final relationships = await batchGetRelationships(personaIds);
      
      for (final persona in _matchedPersonas) {
        final relationshipData = relationships[persona.id];
        if (relationshipData != null) {
          final refreshedPersona = persona.copyWith(
            relationshipScore: relationshipData['relationshipScore'] ?? persona.relationshipScore,
            currentRelationship: _getRelationshipTypeFromScore(relationshipData['relationshipScore'] ?? persona.relationshipScore),
            isCasualSpeech: relationshipData['isCasualSpeech'] ?? persona.isCasualSpeech,
            imageUrls: persona.imageUrls,  // Preserve imageUrls
          );
          refreshedPersonas.add(refreshedPersona);
          
          // Update cache
          _addToCache(persona.id, _CachedRelationship(
            score: relationshipData['relationshipScore'] ?? persona.relationshipScore,
            isCasualSpeech: relationshipData['isCasualSpeech'] ?? persona.isCasualSpeech,
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

  Future<Map<String, Map<String, dynamic>>> batchGetRelationships(List<String> personaIds) async {
    if (_currentUserId == null || personaIds.isEmpty) return {};

    try {
      final results = <String, Map<String, dynamic>>{};
      
      // Check cache first
      final uncachedIds = <String>[];
      for (final personaId in personaIds) {
        final cached = _getFromCache(personaId);
        if (cached != null) {
          results[personaId] = {
            'relationshipScore': cached.score,
            'isCasualSpeech': cached.isCasualSpeech,
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
          final doc = await FirebaseHelper.userPersonaRelationships
              .doc(docId)
              .get();
          
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
            _addToCache(result.key, _CachedRelationship(
              score: result.value['relationshipScore'] ?? 50,
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

  @override
  void dispose() {
    _batchUpdateTimer?.cancel();
    _processBatchUpdates(); // Process any pending updates
    super.dispose();
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
  final RelationshipType relationshipType;
  
  _PendingRelationshipUpdate({
    required this.userId,
    required this.personaId,
    required this.newScore,
    required this.relationshipType,
  });
}