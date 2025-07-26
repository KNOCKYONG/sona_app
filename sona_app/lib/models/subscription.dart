enum SubscriptionType {
  free,      // 무료 사용자
  premium,   // 프리미엄 사용자 (친밀도 표시 포함)
  enterprise // 엔터프라이즈 (모든 기능)
}

class Subscription {
  final String id;
  final String userId;
  final SubscriptionType type;
  final DateTime? expiresAt;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Subscription({
    required this.id,
    required this.userId,
    required this.type,
    this.expiresAt,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  // 친밀도 표시 권한 체크
  bool get canShowIntimacyScore => type != SubscriptionType.free && isActive;
  
  // 프리미엄 기능 권한 체크
  bool get isPremium => (type == SubscriptionType.premium || type == SubscriptionType.enterprise) && isActive;
  
  // 만료 여부 체크
  bool get isExpired => expiresAt != null && DateTime.now().isAfter(expiresAt!);

  Subscription copyWith({
    String? id,
    String? userId,
    SubscriptionType? type,
    DateTime? expiresAt,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Subscription(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      expiresAt: expiresAt ?? this.expiresAt,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'type': type.name,
      'expiresAt': expiresAt?.toIso8601String(),
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      id: json['id'] as String,
      userId: json['userId'] as String,
      type: SubscriptionType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => SubscriptionType.free,
      ),
      expiresAt: json['expiresAt'] != null 
          ? DateTime.parse(json['expiresAt'] as String)
          : null,
      isActive: json['isActive'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  @override
  String toString() {
    return 'Subscription(id: $id, userId: $userId, type: $type, isActive: $isActive, expiresAt: $expiresAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Subscription &&
        other.id == id &&
        other.userId == userId &&
        other.type == type &&
        other.expiresAt == expiresAt &&
        other.isActive == isActive &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return Object.hash(id, userId, type, expiresAt, isActive, createdAt, updatedAt);
  }
}