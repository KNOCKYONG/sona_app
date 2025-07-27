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
  final DateTime? matchedAt; // 매칭된 시간
  
  // 새로운 이미지 구조 (Cloudflare R2)
  final Map<String, dynamic>? imageUrls; // 크기별 이미지 URL 저장
  
  // 전문가/상담사 관련 필드
  final bool isExpert; // 전문가 여부
  final String? profession; // 전문 분야 (예: '심리상담', '연애코치')
  final String? role; // 역할 (예: 'expert', 'specialist', 'normal')

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
    this.matchedAt, // 매칭된 시간
    this.imageUrls, // 새로운 이미지 URL 구조
    this.isExpert = false, // 기본값은 일반 페르소나
    this.profession, // 전문 분야
    this.role, // 역할
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
  
  // 이미지 URL 헬퍼 메서드들 (Cloudflare R2 구조 대응)
  String? getThumbnailUrl() {
    // 새로운 R2 구조에서 썸네일 URL 가져오기
    if (imageUrls != null) {
      // 직접 thumb 키 확인
      if (imageUrls!.containsKey('thumb')) {
        final thumbUrls = imageUrls!['thumb'] as Map<String, dynamic>?;
        // JPEG 우선 (WebP 디코딩 문제 회피)
        return thumbUrls?['jpg'] ?? thumbUrls?['webp'] ?? photoUrls.firstOrNull;
      }
      // mainImageUrls 구조 확인
      else if (imageUrls!.containsKey('mainImageUrls')) {
        final mainUrls = imageUrls!['mainImageUrls'] as Map<String, dynamic>?;
        if (mainUrls != null && mainUrls.containsKey('thumb')) {
          return mainUrls['thumb'] as String?;
        }
      }
    }
    return photoUrls.firstOrNull;
  }
  
  String? getMediumImageUrl() {
    // 프로필 보기용 중간 크기 이미지
    if (imageUrls != null) {
      // 직접 medium 키 확인
      if (imageUrls!.containsKey('medium')) {
        final mediumUrls = imageUrls!['medium'] as Map<String, dynamic>?;
        // JPEG 우선 (WebP 디코딩 문제 회피)
        return mediumUrls?['jpg'] ?? mediumUrls?['webp'] ?? photoUrls.firstOrNull;
      }
      // mainImageUrls 구조 확인 (윤미 같은 경우)
      else if (imageUrls!.containsKey('mainImageUrls')) {
        final mainUrls = imageUrls!['mainImageUrls'] as Map<String, dynamic>?;
        if (mainUrls != null && mainUrls.containsKey('medium')) {
          // mainImageUrls.medium은 직접 URL 문자열
          return mainUrls['medium'] as String?;
        }
      }
    }
    return photoUrls.firstOrNull;
  }
  
  String? getLargeImageUrl() {
    // 상세 보기용 큰 이미지
    if (imageUrls != null) {
      // 직접 large 키 확인
      if (imageUrls!.containsKey('large')) {
        final largeUrls = imageUrls!['large'] as Map<String, dynamic>?;
        // JPEG 우선 (WebP 디코딩 문제 회피)
        return largeUrls?['jpg'] ?? largeUrls?['webp'] ?? photoUrls.firstOrNull;
      }
      // mainImageUrls 구조 확인
      else if (imageUrls!.containsKey('mainImageUrls')) {
        final mainUrls = imageUrls!['mainImageUrls'] as Map<String, dynamic>?;
        if (mainUrls != null && mainUrls.containsKey('large')) {
          return mainUrls['large'] as String?;
        }
      }
    }
    return photoUrls.firstOrNull;
  }
  
  String? getSmallImageUrl() {
    // 작은 이미지 (카드용)
    if (imageUrls != null) {
      // 직접 small 키 확인
      if (imageUrls!.containsKey('small')) {
        final smallUrls = imageUrls!['small'] as Map<String, dynamic>?;
        // JPEG 우선 (WebP 디코딩 문제 회피)
        return smallUrls?['jpg'] ?? smallUrls?['webp'] ?? photoUrls.firstOrNull;
      }
      // mainImageUrls 구조 확인
      else if (imageUrls!.containsKey('mainImageUrls')) {
        final mainUrls = imageUrls!['mainImageUrls'] as Map<String, dynamic>?;
        if (mainUrls != null && mainUrls.containsKey('small')) {
          return mainUrls['small'] as String?;
        }
      }
    }
    return photoUrls.firstOrNull;
  }
  
  String? getOriginalImageUrl() {
    // 원본 이미지
    if (imageUrls != null) {
      // 직접 original 키 확인
      if (imageUrls!.containsKey('original')) {
        final originalUrls = imageUrls!['original'] as Map<String, dynamic>?;
        return originalUrls?['jpg'] ?? originalUrls?['webp'] ?? photoUrls.firstOrNull;
      }
      // mainImageUrls 구조 확인
      else if (imageUrls!.containsKey('mainImageUrls')) {
        final mainUrls = imageUrls!['mainImageUrls'] as Map<String, dynamic>?;
        if (mainUrls != null && mainUrls.containsKey('original')) {
          return mainUrls['original'] as String?;
        }
      }
    }
    return photoUrls.firstOrNull;
  }
  
  List<String> getAllImageUrls({String size = 'medium'}) {
    // 모든 이미지 URL 가져오기 (갤러리용)
    final urls = <String>[];
    
    if (imageUrls != null) {
      // 현재 Firebase 구조에서 직접 size 키 확인
      if (imageUrls!.containsKey(size)) {
        final sizeUrls = imageUrls![size] as Map<String, dynamic>?;
        if (sizeUrls != null && sizeUrls.containsKey('jpg')) {
          urls.add(sizeUrls['jpg'] as String);
        }
      }
      
      // 대체 구조: mainImageUrls가 있는 경우
      else if (imageUrls!.containsKey('mainImageUrls')) {
        final mainUrls = imageUrls!['mainImageUrls'] as Map<String, dynamic>?;
        if (mainUrls != null && mainUrls.containsKey(size)) {
          urls.add(mainUrls[size]);
        }
        
        // 추가 이미지들 - 순서대로 정렬
        final additionalUrls = imageUrls!['additionalImageUrls'] as Map<String, dynamic>?;
        if (additionalUrls != null) {
          // image1, image2, ... 순서로 정렬
          final sortedKeys = additionalUrls.keys.toList()
            ..sort((a, b) {
              // 숫자 추출하여 정렬
              final numA = int.tryParse(a.replaceAll('image', '')) ?? 0;
              final numB = int.tryParse(b.replaceAll('image', '')) ?? 0;
              return numA.compareTo(numB);
            });
          
          for (final key in sortedKeys) {
            final urlMap = additionalUrls[key] as Map<String, dynamic>;
            if (urlMap.containsKey(size)) {
              urls.add(urlMap[size]);
            }
          }
        }
      }
    }
    
    // 폴백: 기존 photoUrls 사용
    if (urls.isEmpty && photoUrls.isNotEmpty) {
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
      'imageUrls': imageUrls, // 새로운 이미지 URL 구조
      'isExpert': isExpert,
      'profession': profession,
      'role': role,
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
      imageUrls: json['imageUrls'] != null 
        ? Map<String, dynamic>.from(json['imageUrls']) 
        : null,
      isExpert: json['isExpert'] ?? false,
      profession: json['profession'],
      role: json['role'],
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
    Map<String, dynamic>? imageUrls,
    bool? isExpert,
    String? profession,
    String? role,
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
      imageUrls: imageUrls ?? this.imageUrls,
      isExpert: isExpert ?? this.isExpert,
      profession: profession ?? this.profession,
      role: role ?? this.role,
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