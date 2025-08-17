import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../persona/persona_service.dart';
import '../chat/core/chat_service.dart';
import '../storage/cache_manager.dart';
import 'image_preload_service.dart';
import '../../models/persona.dart';
import '../../core/preferences_manager.dart';
import '../auth/user_service.dart';

/// 🚀 스마트 프리로더 - 최적화된 데이터 로딩 전략
/// 
/// 주요 기능:
/// 1. 우선순위 기반 프리로딩
/// 2. 네트워크 상태 감지
/// 3. 백그라운드 동기화
/// 4. 증분 로딩
class SmartPreloader {
  static final SmartPreloader _instance = SmartPreloader._internal();
  factory SmartPreloader() => _instance;
  SmartPreloader._internal();
  
  static SmartPreloader get instance => _instance;
  
  // Services
  final PersonaService _personaService = PersonaService();
  final ChatService _chatService = ChatService();
  final ImagePreloadService _imageService = ImagePreloadService.instance;
  final CacheManager _cacheManager = CacheManager.instance;
  
  // Preloading state
  bool _isPreloading = false;
  double _progress = 0.0;
  String _currentTask = '';
  
  // Getters
  bool get isPreloading => _isPreloading;
  double get progress => _progress;
  String get currentTask => _currentTask;
  
  /// 앱 시작 시 스마트 프리로딩 실행
  Future<void> preloadOnStartup({
    required String userId,
    Function(double progress, String message)? onProgress,
  }) async {
    if (_isPreloading) {
      debugPrint('⚠️ Preloading already in progress');
      return;
    }
    
    _isPreloading = true;
    _progress = 0.0;
    
    try {
      debugPrint('🚀 Starting smart preloading for user: $userId');
      
      // 1. Check network connectivity
      final connectivity = await Connectivity().checkConnectivity();
      final isWifi = connectivity == ConnectivityResult.wifi;
      
      if (connectivity == ConnectivityResult.none) {
        debugPrint('📵 No network - using cached data only');
        await _loadFromCacheOnly(userId, onProgress);
        return;
      }
      
      // 2. Phase 1: Critical data (Priority 1)
      _currentTask = 'Loading personas';
      onProgress?.call(0.1, _currentTask);
      await _preloadPersonas(userId);
      _progress = 0.3;
      
      // 3. Phase 2: Matched personas' images (Priority 2)
      _currentTask = 'Loading matched images';
      onProgress?.call(0.3, _currentTask);
      await _preloadMatchedImages(userId);
      _progress = 0.5;
      
      // 4. Phase 3: Recent chats (Priority 3)
      _currentTask = 'Loading recent chats';
      onProgress?.call(0.5, _currentTask);
      await _preloadRecentChats(userId);
      _progress = 0.7;
      
      // 5. Phase 4: Remaining images (Background, WiFi only)
      if (isWifi) {
        _currentTask = 'Optimizing images';
        onProgress?.call(0.7, _currentTask);
        await _preloadRemainingImages();
        _progress = 0.9;
      }
      
      // 6. Cleanup old cache
      _currentTask = 'Cleaning up';
      onProgress?.call(0.9, _currentTask);
      await _cleanupOldCache();
      _progress = 1.0;
      
      onProgress?.call(1.0, 'Ready!');
      debugPrint('✅ Smart preloading completed');
      
    } catch (e) {
      debugPrint('❌ Error during smart preloading: $e');
    } finally {
      _isPreloading = false;
      _currentTask = '';
    }
  }
  
  /// Load from cache only (offline mode)
  Future<void> _loadFromCacheOnly(
    String userId,
    Function(double, String)? onProgress,
  ) async {
    _currentTask = 'Loading offline data';
    onProgress?.call(0.5, _currentTask);
    
    // Load cached personas
    final cachedPersonas = await _cacheManager.getCachedPersonas();
    if (cachedPersonas != null && cachedPersonas.isNotEmpty) {
      debugPrint('📦 Loaded ${cachedPersonas.length} personas from cache (offline)');
    }
    
    _progress = 1.0;
    onProgress?.call(1.0, 'Offline mode ready');
  }
  
  /// Preload personas with cache check
  Future<void> _preloadPersonas(String userId) async {
    try {
      // Check if cache is fresh
      final lastSync = await PreferencesManager.getString('last_persona_sync');
      if (lastSync != null) {
        final syncTime = DateTime.parse(lastSync);
        final hoursSinceSync = DateTime.now().difference(syncTime).inHours;
        
        // If synced within 24 hours, skip
        if (hoursSinceSync < 24) {
          debugPrint('✓ Personas already synced ${hoursSinceSync}h ago');
          return;
        }
      }
      
      // Initialize persona service
      await _personaService.initialize(userId: userId);
      
      // Save sync time
      await PreferencesManager.setString(
        'last_persona_sync',
        DateTime.now().toIso8601String(),
      );
      
      debugPrint('✓ Personas preloaded and cached');
    } catch (e) {
      debugPrint('⚠️ Error preloading personas: $e');
    }
  }
  
  /// Preload matched personas' images
  Future<void> _preloadMatchedImages(String userId) async {
    try {
      final matchedPersonas = _personaService.matchedPersonas;
      
      if (matchedPersonas.isEmpty) {
        debugPrint('✓ No matched personas to preload images');
        return;
      }
      
      debugPrint('📸 Preloading images for ${matchedPersonas.length} matched personas');
      
      // Check if already preloaded
      final hasNewImages = await _imageService.hasNewImages(matchedPersonas);
      
      if (!hasNewImages) {
        debugPrint('✓ All matched images already cached');
        return;
      }
      
      // Preload new images
      await _imageService.preloadNewImages(matchedPersonas);
      
      debugPrint('✓ Matched images preloaded');
    } catch (e) {
      debugPrint('⚠️ Error preloading matched images: $e');
    }
  }
  
  /// Preload recent chats with incremental sync
  Future<void> _preloadRecentChats(String userId) async {
    try {
      final matchedPersonas = _personaService.matchedPersonas;
      
      if (matchedPersonas.isEmpty) {
        debugPrint('✓ No chats to preload');
        return;
      }
      
      // Load only the 3 most recent chats initially
      final recentPersonas = matchedPersonas.take(3).toList();
      
      for (final persona in recentPersonas) {
        await _chatService.initializeChat(
          userId: userId,
          persona: persona,
        );
      }
      
      debugPrint('✓ Preloaded ${recentPersonas.length} recent chats');
    } catch (e) {
      debugPrint('⚠️ Error preloading chats: $e');
    }
  }
  
  /// Preload remaining images in background
  Future<void> _preloadRemainingImages() async {
    try {
      final allPersonas = _personaService.allPersonas;
      
      // Check if we need to preload more images
      final isCompleted = await _imageService.isPreloadCompleted();
      
      if (isCompleted) {
        // Check for new images only
        final hasNewImages = await _imageService.hasNewImages(allPersonas);
        
        if (hasNewImages) {
          debugPrint('📸 Preloading new images in background');
          await _imageService.preloadNewImages(allPersonas);
        } else {
          debugPrint('✓ All images already cached');
        }
      } else {
        // First time - preload all
        debugPrint('📸 Preloading all images (first time)');
        await _imageService.preloadAllPersonaImages(allPersonas);
      }
    } catch (e) {
      debugPrint('⚠️ Error preloading remaining images: $e');
    }
  }
  
  /// Clean up old cache files
  Future<void> _cleanupOldCache() async {
    try {
      final cacheStats = await _cacheManager.getCacheSizes();
      final totalSize = cacheStats['total'] ?? 0;
      
      // If cache is over 200MB, clean up
      if (totalSize > 200 * 1024 * 1024) {
        debugPrint('🧹 Cache size: ${(totalSize / 1024 / 1024).toStringAsFixed(1)}MB - cleaning up');
        
        // Clear old chat cache (over 30 days)
        await _cacheManager.clearCache('chat');
        
        debugPrint('✓ Cache cleanup completed');
      } else {
        debugPrint('✓ Cache size OK: ${(totalSize / 1024 / 1024).toStringAsFixed(1)}MB');
      }
    } catch (e) {
      debugPrint('⚠️ Error during cache cleanup: $e');
    }
  }
  
  /// Sync data in background (called periodically)
  Future<void> backgroundSync({
    required String userId,
    bool forceSync = false,
  }) async {
    try {
      // Check network
      final connectivity = await Connectivity().checkConnectivity();
      if (connectivity == ConnectivityResult.none) {
        return; // No sync in offline mode
      }
      
      // Check last sync time
      if (!forceSync) {
        final lastSync = await PreferencesManager.getString('last_background_sync');
        if (lastSync != null) {
          final syncTime = DateTime.parse(lastSync);
          final hoursSinceSync = DateTime.now().difference(syncTime).inHours;
          
          // Sync every 6 hours on WiFi, 24 hours on mobile
          final syncInterval = connectivity == ConnectivityResult.wifi ? 6 : 24;
          
          if (hoursSinceSync < syncInterval) {
            return; // Too soon to sync
          }
        }
      }
      
      debugPrint('🔄 Starting background sync');
      
      // Sync personas
      await _personaService.initialize(userId: userId);
      
      // Update cache timestamp
      await PreferencesManager.setString(
        'last_background_sync',
        DateTime.now().toIso8601String(),
      );
      
      debugPrint('✅ Background sync completed');
    } catch (e) {
      debugPrint('⚠️ Background sync error: $e');
    }
  }
  
  /// Get preload statistics
  Future<Map<String, dynamic>> getPreloadStats() async {
    final cacheStats = await _cacheManager.getCacheSizes();
    final imageCompleted = await _imageService.isPreloadCompleted();
    
    return {
      'cache_size_mb': (cacheStats['total']! / 1024 / 1024).toStringAsFixed(1),
      'image_cache_mb': (cacheStats['image']! / 1024 / 1024).toStringAsFixed(1),
      'chat_cache_mb': (cacheStats['chat']! / 1024 / 1024).toStringAsFixed(1),
      'images_preloaded': imageCompleted,
      'personas_cached': _personaService.allPersonas.length,
      'matched_personas': _personaService.matchedPersonas.length,
    };
  }
}