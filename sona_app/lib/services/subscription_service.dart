import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/subscription.dart';

/// 🚀 Optimized Subscription Service with Performance Enhancements
/// 
/// Key optimizations:
/// 1. Aggressive caching with TTL
/// 2. Lazy loading and validation
/// 3. Background expiry checks
/// 4. Minimal Firebase reads
/// 5. Local-first approach
class SubscriptionService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Cached subscription data
  Subscription? _currentSubscription;
  bool _isLoading = false;
  DateTime? _lastLoadTime;
  String? _lastUserId;
  
  // Cache configuration
  static const Duration _cacheTTL = Duration(minutes: 10);
  static const Duration _expiryCheckInterval = Duration(minutes: 5);
  
  // Background timer for expiry checks
  Timer? _expiryCheckTimer;
  
  // Local storage keys
  static const String _subscriptionCacheKey = 'cached_subscription';
  static const String _lastCheckKey = 'last_subscription_check';
  
  // Getters
  Subscription? get currentSubscription => _currentSubscription;
  bool get isLoading => _isLoading;
  
  // Optimized permission checks
  bool get canShowIntimacyScore => 
      _currentSubscription?.canShowIntimacyScore ?? false;
  
  bool get isPremiumUser => 
      _currentSubscription?.isPremium ?? false;

  /// Initialize service with background checks
  SubscriptionService() {
    _startExpiryCheckTimer();
  }

  /// Load subscription with intelligent caching
  Future<void> loadSubscription(String userId) async {
    // Check if we can use cached data
    if (_canUseCachedData(userId)) {
      debugPrint('Using cached subscription data');
      notifyListeners();
      return;
    }
    
    try {
      _isLoading = true;
      notifyListeners();

      // Check local cache first
      final cachedSubscription = await _loadFromLocalCache(userId);
      if (cachedSubscription != null) {
        _currentSubscription = cachedSubscription;
        _lastLoadTime = DateTime.now();
        _lastUserId = userId;
        _isLoading = false;
        notifyListeners();
        
        // Refresh from Firebase in background
        _refreshInBackground(userId);
        return;
      }

      // Load from Firebase
      await _loadFromFirebase(userId);
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      debugPrint('Error loading subscription: $e');
      
      // Fallback to free subscription
      _currentSubscription = _createFreeSubscription(userId);
      notifyListeners();
    }
  }

  /// Check if cached data is still valid
  bool _canUseCachedData(String userId) {
    if (_currentSubscription == null || 
        _lastLoadTime == null ||
        _lastUserId != userId) {
      return false;
    }
    
    final age = DateTime.now().difference(_lastLoadTime!);
    return age < _cacheTTL;
  }

  /// Load subscription from local cache
  Future<Subscription?> _loadFromLocalCache(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Check if this is tutorial user
      if (userId == 'tutorial_user') {
        return _createFreeSubscription(userId);
      }
      
      // Check cache timestamp
      final lastCheck = prefs.getInt(_lastCheckKey) ?? 0;
      final lastCheckTime = DateTime.fromMillisecondsSinceEpoch(lastCheck);
      final cacheAge = DateTime.now().difference(lastCheckTime);
      
      if (cacheAge > _cacheTTL) {
        return null; // Cache expired
      }
      
      // Load cached subscription
      final cachedJson = prefs.getString(_subscriptionCacheKey);
      if (cachedJson != null) {
        final Map<String, dynamic> json = Map<String, dynamic>.from(
          jsonDecode(cachedJson) as Map,
        );
        
        // Verify user ID matches
        if (json['userId'] == userId) {
          return Subscription.fromJson(json);
        }
      }
    } catch (e) {
      debugPrint('Error loading from cache: $e');
    }
    
    return null;
  }

  /// Load subscription from Firebase
  Future<void> _loadFromFirebase(String userId) async {
    try {
      final doc = await _firestore
          .collection('subscriptions')
          .doc(userId)
          .get();

      if (doc.exists) {
        _currentSubscription = Subscription.fromJson({
          ...doc.data()!,
          'id': doc.id,
        });
      } else {
        // Create free subscription
        _currentSubscription = _createFreeSubscription(userId);
        await _saveToFirebase(_currentSubscription!);
      }
      
      _lastLoadTime = DateTime.now();
      _lastUserId = userId;
      
      // Save to local cache
      await _saveToLocalCache(_currentSubscription!);
    } catch (e) {
      debugPrint('Error loading from Firebase: $e');
      throw e;
    }
  }

  /// Refresh subscription in background
  Future<void> _refreshInBackground(String userId) async {
    try {
      final doc = await _firestore
          .collection('subscriptions')
          .doc(userId)
          .get();

      if (doc.exists) {
        final newSubscription = Subscription.fromJson({
          ...doc.data()!,
          'id': doc.id,
        });
        
        // Only update if changed
        if (_hasSubscriptionChanged(newSubscription)) {
          _currentSubscription = newSubscription;
          _lastLoadTime = DateTime.now();
          await _saveToLocalCache(newSubscription);
          notifyListeners();
        }
      }
    } catch (e) {
      debugPrint('Background refresh error: $e');
    }
  }

  /// Check if subscription has changed
  bool _hasSubscriptionChanged(Subscription newSub) {
    if (_currentSubscription == null) return true;
    
    return _currentSubscription!.type != newSub.type ||
           _currentSubscription!.isActive != newSub.isActive ||
           _currentSubscription!.expiresAt != newSub.expiresAt;
  }

  /// Save subscription to local cache
  Future<void> _saveToLocalCache(Subscription subscription) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_subscriptionCacheKey, jsonEncode(subscription.toJson()));
      await prefs.setInt(_lastCheckKey, DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      debugPrint('Error saving to cache: $e');
    }
  }

  /// Save subscription to Firebase
  Future<void> _saveToFirebase(Subscription subscription) async {
    try {
      await _firestore
          .collection('subscriptions')
          .doc(subscription.userId)
          .set(subscription.toJson());
    } catch (e) {
      debugPrint('Error saving to Firebase: $e');
    }
  }

  /// Create free subscription
  Subscription _createFreeSubscription(String userId) {
    return Subscription(
      id: userId,
      userId: userId,
      type: SubscriptionType.free,
      isActive: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  /// Optimized premium upgrade
  Future<bool> upgradeToPremium(String userId, {Duration? duration}) async {
    try {
      _isLoading = true;
      notifyListeners();

      final expiresAt = duration != null 
          ? DateTime.now().add(duration)
          : null;

      final updatedSubscription = Subscription(
        id: userId,
        userId: userId,
        type: SubscriptionType.premium,
        expiresAt: expiresAt,
        isActive: true,
        createdAt: _currentSubscription?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Update Firebase
      await _saveToFirebase(updatedSubscription);
      
      // Update local state and cache
      _currentSubscription = updatedSubscription;
      _lastLoadTime = DateTime.now();
      _lastUserId = userId;
      await _saveToLocalCache(updatedSubscription);
      
      _isLoading = false;
      notifyListeners();
      
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint('Error upgrading to premium: $e');
      return false;
    }
  }

  /// Optimized subscription cancellation
  Future<bool> cancelSubscription(String userId) async {
    try {
      _isLoading = true;
      notifyListeners();

      final canceledSubscription = _currentSubscription?.copyWith(
        type: SubscriptionType.free,
        expiresAt: null,
        isActive: true,
        updatedAt: DateTime.now(),
      );

      if (canceledSubscription != null) {
        // Update Firebase
        await _saveToFirebase(canceledSubscription);
        
        // Update local state and cache
        _currentSubscription = canceledSubscription;
        _lastLoadTime = DateTime.now();
        await _saveToLocalCache(canceledSubscription);
      }

      _isLoading = false;
      notifyListeners();
      
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint('Error canceling subscription: $e');
      return false;
    }
  }

  /// Start background expiry check timer
  void _startExpiryCheckTimer() {
    _expiryCheckTimer?.cancel();
    _expiryCheckTimer = Timer.periodic(_expiryCheckInterval, (_) {
      _checkSubscriptionExpiry();
    });
  }

  /// Check subscription expiry
  void _checkSubscriptionExpiry() {
    if (_currentSubscription == null) return;
    
    if (_currentSubscription!.isExpired) {
      debugPrint('Subscription expired, downgrading to free');
      
      // Downgrade to free
      _currentSubscription = _currentSubscription!.copyWith(
        type: SubscriptionType.free,
        expiresAt: null,
        updatedAt: DateTime.now(),
      );
      
      // Save changes
      if (_lastUserId != null) {
        _saveToFirebase(_currentSubscription!);
        _saveToLocalCache(_currentSubscription!);
      }
      
      notifyListeners();
    }
  }

  /// Get subscription status text
  String getSubscriptionStatusText() {
    if (_currentSubscription == null) return '구독 정보 없음';
    
    switch (_currentSubscription!.type) {
      case SubscriptionType.free:
        return '무료 사용자';
      case SubscriptionType.premium:
        if (_currentSubscription!.expiresAt != null) {
          final daysLeft = _currentSubscription!.expiresAt!.difference(DateTime.now()).inDays;
          return '프리미엄 사용자 ($daysLeft일 남음)';
        }
        return '프리미엄 사용자';
      case SubscriptionType.enterprise:
        return '엔터프라이즈 사용자';
    }
  }

  /// Clear subscription and cache
  void clearSubscription() {
    _currentSubscription = null;
    _lastLoadTime = null;
    _lastUserId = null;
    _clearLocalCache();
    notifyListeners();
  }

  /// Clear local cache
  Future<void> _clearLocalCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_subscriptionCacheKey);
      await prefs.remove(_lastCheckKey);
    } catch (e) {
      debugPrint('Error clearing cache: $e');
    }
  }

  /// Enable premium for testing
  void enablePremiumForTesting() {
    _currentSubscription = _currentSubscription?.copyWith(
      type: SubscriptionType.premium,
      isActive: true,
      updatedAt: DateTime.now(),
    ) ?? Subscription(
      id: 'test',
      userId: 'test_user',
      type: SubscriptionType.premium,
      isActive: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    notifyListeners();
  }

  @override
  void dispose() {
    _expiryCheckTimer?.cancel();
    super.dispose();
  }
}

