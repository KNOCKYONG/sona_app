import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// Service for managing blocked AI personas
class BlockService {
  static final BlockService _instance = BlockService._internal();
  factory BlockService() => _instance;
  BlockService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _blockedPersonasCollection = 'blocked_personas';
  final String _localCacheKey = 'blocked_personas_cache';
  
  // In-memory cache
  Set<String> _blockedPersonaIds = {};
  String? _currentUserId;

  /// Initialize the service and load blocked personas
  Future<void> initialize(String userId) async {
    // Re-initialize if userId changed
    if (_currentUserId == userId) {
      print('🔄 BlockService already initialized for userId: $userId');
      return;
    }
    
    try {
      print('🚀 Initializing BlockService for userId: $userId');
      _currentUserId = userId;
      
      // Load from local cache first
      await _loadLocalCache();
      
      // Then sync with Firestore
      await _syncWithFirestore(userId);
      
      print('✅ BlockService initialized successfully');
    } catch (e) {
      print('❌ Error initializing BlockService: $e');
      _currentUserId = null; // Reset on error
    }
  }

  /// Load blocked personas from local cache
  Future<void> _loadLocalCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cached = prefs.getString(_localCacheKey);
      if (cached != null) {
        final List<dynamic> list = json.decode(cached);
        _blockedPersonaIds = Set<String>.from(list);
      }
    } catch (e) {
      print('Error loading local cache: $e');
    }
  }

  /// Save blocked personas to local cache
  Future<void> _saveLocalCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_localCacheKey, json.encode(_blockedPersonaIds.toList()));
    } catch (e) {
      print('Error saving local cache: $e');
    }
  }

  /// Sync blocked personas with Firestore
  Future<void> _syncWithFirestore(String userId) async {
    try {
      print('🔄 Syncing with Firestore for userId: $userId');
      
      final snapshot = await _firestore
          .collection(_blockedPersonasCollection)
          .where('userId', isEqualTo: userId)
          .get();

      print('📊 Found ${snapshot.docs.length} blocked personas in Firestore');
      
      _blockedPersonaIds = snapshot.docs
          .map((doc) {
            final data = doc.data();
            print('  - ${data['personaName']} (${data['personaId']})');
            return data['personaId'] as String;
          })
          .toSet();
      
      await _saveLocalCache();
      print('💾 Saved ${_blockedPersonaIds.length} blocked personas to local cache');
    } catch (e) {
      print('❌ Error syncing with Firestore: $e');
      print('   Stack trace: ${StackTrace.current}');
    }
  }

  /// Block an AI persona
  Future<bool> blockPersona({
    required String userId,
    required String personaId,
    required String personaName,
    String? reason,
    String? reportId,
  }) async {
    try {
      print('🚫 Blocking persona: $personaName ($personaId) for user: $userId');
      final docId = '${userId}_${personaId}';  // Use underscore for consistency
      
      final blockData = {
        'userId': userId,
        'personaId': personaId,
        'personaName': personaName,
        'blockedAt': FieldValue.serverTimestamp(),
        'reason': reason,
        'reportId': reportId,
      };
      
      print('📝 Saving to Firestore with docId: $docId');
      print('📝 Collection: $_blockedPersonasCollection');
      print('📝 Block data: $blockData');
      
      await _firestore.collection(_blockedPersonasCollection).doc(docId).set(blockData);
      
      print('✅ Successfully saved to Firestore');

      // Update local cache immediately
      _blockedPersonaIds.add(personaId);
      await _saveLocalCache();
      
      // Force re-sync to ensure consistency
      await _syncWithFirestore(userId);
      
      print('✅ Local cache updated and synced');

      return true;
    } catch (e) {
      print('❌ Error blocking persona: $e');
      print('   Stack trace: ${StackTrace.current}');
      return false;
    }
  }

  /// Unblock an AI persona
  Future<bool> unblockPersona({
    required String userId,
    required String personaId,
  }) async {
    try {
      final docId = '${userId}_${personaId}';  // Use underscore for consistency
      
      print('🔓 Unblocking persona: $personaId for user: $userId');
      print('📝 Deleting document: $docId');
      
      await _firestore.collection(_blockedPersonasCollection).doc(docId).delete();

      // Update local cache
      _blockedPersonaIds.remove(personaId);
      await _saveLocalCache();
      
      // Force re-sync to ensure consistency
      await _syncWithFirestore(userId);
      
      print('✅ Successfully unblocked persona');

      return true;
    } catch (e) {
      print('❌ Error unblocking persona: $e');
      print('   Stack trace: ${StackTrace.current}');
      return false;
    }
  }

  /// Check if a persona is blocked
  bool isBlocked(String personaId) {
    return _blockedPersonaIds.contains(personaId);
  }

  /// Get all blocked persona IDs
  Set<String> getBlockedPersonaIds() {
    return Set<String>.from(_blockedPersonaIds);
  }

  /// Get detailed blocked personas list
  Future<List<BlockedPersona>> getBlockedPersonas(String userId) async {
    try {
      print('🔍 Getting blocked personas for userId: $userId');
      print('📝 Collection: $_blockedPersonasCollection');
      
      // First, ensure we're initialized with the correct userId
      await initialize(userId);
      
      final query = _firestore
          .collection(_blockedPersonasCollection)
          .where('userId', isEqualTo: userId);
      
      print('🔍 Executing query...');
      final snapshot = await query.get();

      print('🔍 Query completed. Found ${snapshot.docs.length} blocked personas');
      
      if (snapshot.docs.isEmpty) {
        print('📭 No blocked personas found for this user');
        return [];
      }
      
      final blockedList = snapshot.docs.map((doc) {
        final data = doc.data();
        print('📋 Document ID: ${doc.id}');
        print('   - Persona: ${data['personaName']} (${data['personaId']})');
        print('   - Reason: ${data['reason'] ?? "No reason provided"}');
        
        return BlockedPersona(
          personaId: data['personaId'] as String,
          personaName: data['personaName'] as String,
          blockedAt: (data['blockedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
          reason: data['reason'] as String?,
          reportId: data['reportId'] as String?,
        );
      }).toList();
      
      // Sort by blockedAt date in memory
      blockedList.sort((a, b) => b.blockedAt.compareTo(a.blockedAt));
      
      print('✅ Returning ${blockedList.length} blocked personas');
      return blockedList;
    } catch (e) {
      print('❌ Error getting blocked personas: $e');
      print('   Stack trace: ${StackTrace.current}');
      return [];
    }
  }

  /// Clear all cached data (for logout)
  Future<void> clearCache() async {
    _blockedPersonaIds.clear();
    _currentUserId = null;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_localCacheKey);
  }
}

/// Model for blocked persona details
class BlockedPersona {
  final String personaId;
  final String personaName;
  final DateTime blockedAt;
  final String? reason;
  final String? reportId;

  BlockedPersona({
    required this.personaId,
    required this.personaName,
    required this.blockedAt,
    this.reason,
    this.reportId,
  });
}