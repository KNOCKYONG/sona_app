import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/constants.dart';

/// Firebase 작업을 위한 헬퍼 클래스
/// 컬렉션 참조 및 공통 작업 통합 관리
class FirebaseHelper {
  // Private constructor
  FirebaseHelper._();

  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Users Collection
  static CollectionReference<Map<String, dynamic>> get users =>
      _firestore.collection(AppConstants.usersCollection);

  static DocumentReference<Map<String, dynamic>> user(String userId) =>
      users.doc(userId);

  // User Sub-collections
  static CollectionReference<Map<String, dynamic>> userChats(String userId) =>
      user(userId).collection(AppConstants.chatsCollection);

  static DocumentReference<Map<String, dynamic>> userChat(
          String userId, String personaId) =>
      userChats(userId).doc(personaId);

  static CollectionReference<Map<String, dynamic>> userChatMessages(
          String userId, String personaId) =>
      userChat(userId, personaId).collection(AppConstants.messagesCollection);

  static CollectionReference<Map<String, dynamic>> userMatches(String userId) =>
      user(userId).collection(AppConstants.matchesCollection);

  static CollectionReference<Map<String, dynamic>> userSwipes(String userId) =>
      user(userId).collection(AppConstants.swipesCollection);

  // Personas Collection
  static CollectionReference<Map<String, dynamic>> get personas =>
      _firestore.collection(AppConstants.personasCollection);

  static DocumentReference<Map<String, dynamic>> persona(String personaId) =>
      personas.doc(personaId);

  // Other Collections
  static CollectionReference<Map<String, dynamic>> get purchases =>
      _firestore.collection(AppConstants.purchasesCollection);

  static CollectionReference<Map<String, dynamic>> get conversationMemories =>
      _firestore.collection(AppConstants.conversationMemoriesCollection);

  static CollectionReference<Map<String, dynamic>> get conversationSummaries =>
      _firestore.collection(AppConstants.conversationSummariesCollection);

  static CollectionReference<Map<String, dynamic>>
      get userPersonaRelationships => _firestore
          .collection(AppConstants.userPersonaRelationshipsCollection);

  static CollectionReference<Map<String, dynamic>> get userProfileImages =>
      _firestore.collection(AppConstants.userProfileImagesCollection);

  // Quality Collections
  static CollectionReference<Map<String, dynamic>>
      get consultationQualityLogs =>
          _firestore.collection(AppConstants.consultationQualityLogsCollection);

  static CollectionReference<Map<String, dynamic>> get dailyQualityStats =>
      _firestore.collection(AppConstants.dailyQualityStatsCollection);

  static CollectionReference<Map<String, dynamic>> get personaQualityStats =>
      _firestore.collection(AppConstants.personaQualityStatsCollection);

  static CollectionReference<Map<String, dynamic>> get qualityAlerts =>
      _firestore.collection(AppConstants.qualityAlertsCollection);

  // Error Reporting Collection
  static CollectionReference<Map<String, dynamic>> get chatErrorFix =>
      _firestore.collection('chat_error_fix');

  // Common Fields
  static Map<String, dynamic> get serverTimestamp => {
        'timestamp': FieldValue.serverTimestamp(),
      };

  static Map<String, dynamic> get createdAtTimestamp => {
        'createdAt': FieldValue.serverTimestamp(),
      };

  static Map<String, dynamic> get updatedAtTimestamp => {
        'updatedAt': FieldValue.serverTimestamp(),
      };

  static Map<String, dynamic> withTimestamps(Map<String, dynamic> data,
      {bool isNew = true}) {
    final timestampedData = Map<String, dynamic>.from(data);

    if (isNew) {
      timestampedData['createdAt'] = FieldValue.serverTimestamp();
    }
    timestampedData['updatedAt'] = FieldValue.serverTimestamp();

    return timestampedData;
  }

  // Batch Operations
  static WriteBatch batch() => _firestore.batch();

  static Future<void> commitBatch(WriteBatch batch) => batch.commit();

  // Transaction
  static Future<T> runTransaction<T>(
    TransactionHandler<T> transactionHandler, {
    Duration timeout = const Duration(seconds: 30),
  }) {
    return _firestore.runTransaction(transactionHandler, timeout: timeout);
  }

  // Query Helpers
  static Query<Map<String, dynamic>> orderByTimestamp(
    Query<Map<String, dynamic>> query, {
    bool descending = true,
  }) {
    return query.orderBy('timestamp', descending: descending);
  }

  static Query<Map<String, dynamic>> orderByCreatedAt(
    Query<Map<String, dynamic>> query, {
    bool descending = true,
  }) {
    return query.orderBy('createdAt', descending: descending);
  }

  static Query<Map<String, dynamic>> orderByUpdatedAt(
    Query<Map<String, dynamic>> query, {
    bool descending = true,
  }) {
    return query.orderBy('updatedAt', descending: descending);
  }

  static Query<Map<String, dynamic>> limitTo(
    Query<Map<String, dynamic>> query,
    int limit,
  ) {
    return query.limit(limit);
  }

  // Document ID Generation
  static String generateDocumentId() => _firestore.collection('temp').doc().id;

  // Compound Document IDs
  static String generateUserPersonaId(String userId, String personaId) =>
      '${userId}_$personaId';
}
