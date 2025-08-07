import 'package:cloud_firestore/cloud_firestore.dart';

/// 대화 예시 모델
class ConversationExample {
  final String id;
  final String mbti; // MBTI 타입 (ENFP, INTJ 등)
  final String category; // 카테고리 (greeting, food, compliment 등)
  final String subcategory; // 세부 카테고리 (positive, negative 등)
  final bool isCasual; // 반말/존댓말 구분
  final List<String> triggers; // 트리거 키워드들
  final List<String> responses; // 가능한 응답들
  final Map<String, dynamic>? metadata; // 추가 메타데이터
  final DateTime createdAt;
  final DateTime updatedAt;

  ConversationExample({
    required this.id,
    required this.mbti,
    required this.category,
    required this.subcategory,
    required this.isCasual,
    required this.triggers,
    required this.responses,
    this.metadata,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Factory constructor for creating from Firestore
  factory ConversationExample.fromJson(Map<String, dynamic> json, String id) {
    return ConversationExample(
      id: id,
      mbti: json['mbti'] ?? '',
      category: json['category'] ?? '',
      subcategory: json['subcategory'] ?? '',
      isCasual: json['isCasual'] ?? false,
      triggers: List<String>.from(json['triggers'] ?? []),
      responses: List<String>.from(json['responses'] ?? []),
      metadata: json['metadata'],
      createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (json['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  /// Convert to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'mbti': mbti,
      'category': category,
      'subcategory': subcategory,
      'isCasual': isCasual,
      'triggers': triggers,
      'responses': responses,
      'metadata': metadata,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  /// Create a copy with some fields updated
  ConversationExample copyWith({
    String? mbti,
    String? category,
    String? subcategory,
    bool? isCasual,
    List<String>? triggers,
    List<String>? responses,
    Map<String, dynamic>? metadata,
    DateTime? updatedAt,
  }) {
    return ConversationExample(
      id: id,
      mbti: mbti ?? this.mbti,
      category: category ?? this.category,
      subcategory: subcategory ?? this.subcategory,
      isCasual: isCasual ?? this.isCasual,
      triggers: triggers ?? this.triggers,
      responses: responses ?? this.responses,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
