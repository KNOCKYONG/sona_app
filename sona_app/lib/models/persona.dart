class Persona {
  final String id;
  final String name;
  final int age;
  final String description;
  final List<String> photoUrls;
  final String personality;
  final RelationshipType currentRelationship;
  final int relationshipScore;
  final DateTime createdAt;
  final Map<String, dynamic> preferences;
  final bool isCasualSpeech; // 반말 사용 플래그
  final String gender; // 성별 ('male', 'female')
  final String mbti; // MBTI 성격 유형 (예: 'ENFP', 'INTJ')
  final bool isExpert; // 전문가 여부
  final String? profession; // 전문 분야 (예: '임상심리학', '상담심리학', '정신건강의학')
  final String role; // 페르소나 역할 ('normal', 'expert')
  final DateTime? matchedAt; // 매칭된 시간
  
  // 새로운 이미지 구조 (Cloudflare R2)
  final Map<String, dynamic>? imageUrls; // 크기별 이미지 URL 저장

  Persona({
    required this.id,
    required this.name,
    required this.age,
    required this.description,
    required this.photoUrls,
    required this.personality,
    this.currentRelationship = RelationshipType.friend,
    this.relationshipScore = 0,
    DateTime? createdAt,
    this.preferences = const {},
    this.isCasualSpeech = false, // 기본값은 존댓말
    this.gender = 'female', // 기본값은 여성
    this.mbti = 'ENFP', // 기본값은 ENFP
    this.isExpert = false, // 기본값은 일반 페르소나
    this.profession, // 전문 분야는 선택사항
    this.role = 'normal', // 기본값은 일반 페르소나
    this.matchedAt, // 매칭된 시간
    this.imageUrls, // 새로운 이미지 URL 구조
  }) : createdAt = createdAt ?? DateTime.now();

  // 관계 상태 확인 메서드
  RelationshipType getRelationshipType() {
    if (relationshipScore >= 1000) return RelationshipType.perfectLove;
    if (relationshipScore >= 500) return RelationshipType.dating;
    if (relationshipScore >= 200) return RelationshipType.crush;
    return RelationshipType.friend;
  }

  // 감정 반응 강도 계산
  double getEmotionalIntensity() {
    switch (getRelationshipType()) {
      case RelationshipType.friend:
        return 0.3;
      case RelationshipType.crush:
        return 0.6;
      case RelationshipType.dating:
        return 0.8;
      case RelationshipType.perfectLove:
        return 1.0;
    }
  }

  // 질투 반응 여부
  bool canShowJealousy() {
    return getRelationshipType().index >= RelationshipType.crush.index;
  }
  
  // 이미지 URL 헬퍼 메서드들
  String? getThumbnailUrl() {
    // 새로운 구조에서 썸네일 URL 가져오기
    if (imageUrls != null && imageUrls!.containsKey('mainImageUrls')) {
      final mainUrls = imageUrls!['mainImageUrls'] as Map<String, dynamic>?;
      return mainUrls?['thumb'] ?? photoUrls.firstOrNull;
    }
    return photoUrls.firstOrNull;
  }
  
  String? getMediumImageUrl() {
    // 프로필 보기용 중간 크기 이미지
    if (imageUrls != null && imageUrls!.containsKey('mainImageUrls')) {
      final mainUrls = imageUrls!['mainImageUrls'] as Map<String, dynamic>?;
      return mainUrls?['medium'] ?? photoUrls.firstOrNull;
    }
    return photoUrls.firstOrNull;
  }
  
  String? getLargeImageUrl() {
    // 상세 보기용 큰 이미지
    if (imageUrls != null && imageUrls!.containsKey('mainImageUrls')) {
      final mainUrls = imageUrls!['mainImageUrls'] as Map<String, dynamic>?;
      return mainUrls?['large'] ?? photoUrls.firstOrNull;
    }
    return photoUrls.firstOrNull;
  }
  
  List<String> getAllImageUrls({String size = 'medium'}) {
    // 모든 이미지 URL 가져오기 (갤러리용)
    final urls = <String>[];
    
    if (imageUrls != null) {
      // 메인 이미지
      final mainUrls = imageUrls!['mainImageUrls'] as Map<String, dynamic>?;
      if (mainUrls != null && mainUrls.containsKey(size)) {
        urls.add(mainUrls[size]);
      }
      
      // 추가 이미지들
      final additionalUrls = imageUrls!['additionalImageUrls'] as Map<String, dynamic>?;
      if (additionalUrls != null) {
        additionalUrls.forEach((key, value) {
          final urlMap = value as Map<String, dynamic>;
          if (urlMap.containsKey(size)) {
            urls.add(urlMap[size]);
          }
        });
      }
    }
    
    // 폴백: 기존 photoUrls 사용
    if (urls.isEmpty) {
      return photoUrls;
    }
    
    return urls;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'description': description,
      'photoUrls': photoUrls,
      'personality': personality,
      'currentRelationship': currentRelationship.name,
      'relationshipScore': relationshipScore,
      'createdAt': createdAt.toIso8601String(),
      'preferences': preferences,
      'isCasualSpeech': isCasualSpeech,
      'gender': gender,
      'mbti': mbti,
      'isExpert': isExpert,
      'profession': profession,
      'role': role,
      'imageUrls': imageUrls, // 새로운 이미지 URL 구조
    };
  }

  factory Persona.fromJson(Map<String, dynamic> json) {
    return Persona(
      id: json['id'],
      name: json['name'],
      age: json['age'],
      description: json['description'],
      photoUrls: List<String>.from(json['photoUrls']),
      personality: json['personality'],
      currentRelationship: RelationshipType.values.firstWhere(
        (e) => e.name == json['currentRelationship'],
        orElse: () => RelationshipType.friend,
      ),
      relationshipScore: json['relationshipScore'] ?? 0,
      createdAt: DateTime.parse(json['createdAt']),
      preferences: Map<String, dynamic>.from(json['preferences'] ?? {}),
      isCasualSpeech: json['isCasualSpeech'] ?? false,
      gender: json['gender'] ?? 'female',
      mbti: json['mbti'] ?? 'ENFP',
      isExpert: json['isExpert'] ?? false,
      profession: json['profession'],
      role: json['role'] ?? 'normal',
      imageUrls: json['imageUrls'] != null 
        ? Map<String, dynamic>.from(json['imageUrls']) 
        : null,
    );
  }

  Persona copyWith({
    String? name,
    int? age,
    String? description,
    List<String>? photoUrls,
    String? personality,
    RelationshipType? currentRelationship,
    int? relationshipScore,
    Map<String, dynamic>? preferences,
    bool? isCasualSpeech,
    String? gender,
    String? mbti,
    bool? isExpert,
    String? profession,
    String? role,
    Map<String, dynamic>? imageUrls,
  }) {
    return Persona(
      id: id,
      name: name ?? this.name,
      age: age ?? this.age,
      description: description ?? this.description,
      photoUrls: photoUrls ?? this.photoUrls,
      personality: personality ?? this.personality,
      currentRelationship: currentRelationship ?? this.currentRelationship,
      relationshipScore: relationshipScore ?? this.relationshipScore,
      createdAt: createdAt,
      preferences: preferences ?? this.preferences,
      isCasualSpeech: isCasualSpeech ?? this.isCasualSpeech,
      gender: gender ?? this.gender,
      mbti: mbti ?? this.mbti,
      isExpert: isExpert ?? this.isExpert,
      profession: profession ?? this.profession,
      role: role ?? this.role,
      imageUrls: imageUrls ?? this.imageUrls,
    );
  }
}

enum RelationshipType {
  friend('친구', 0, 199),
  crush('썸', 200, 499),
  dating('연애', 500, 999),
  perfectLove('완전 연애', 1000, 1000);

  const RelationshipType(this.displayName, this.minScore, this.maxScore);

  final String displayName;
  final int minScore;
  final int maxScore;

  static RelationshipType fromScore(int score) {
    for (var type in RelationshipType.values) {
      if (score >= type.minScore && score <= type.maxScore) {
        return type;
      }
    }
    return RelationshipType.friend;
  }
}