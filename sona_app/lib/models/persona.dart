class Persona {
  final String id;
  final String name;
  final int age;
  final String description;
  final List<String> photoUrls;
  final String personality;
  final int relationshipScore;
  final DateTime createdAt;
  final Map<String, dynamic> preferences;
  final String gender; // 성별 ('male', 'female')
  final String mbti; // MBTI 성격 유형 (예: 'ENFP', 'INTJ')
  final DateTime? matchedAt; // 매칭된 시간
  
  // 새로운 이미지 구조 (Cloudflare R2)
  final Map<String, dynamic>? imageUrls; // 크기별 이미지 URL 저장
  
  // 추천 관련 필드
  final List<String>? topics; // 페르소나가 다룰 수 있는 주제들
  final List<String>? keywords; // 페르소나를 설명하는 키워드들
  
  // R2 이미지 유효성 캐싱 필드
  final bool? hasValidR2Image; // Firebase에 저장된 R2 이미지 유효성

  Persona({
    required this.id,
    required this.name,
    required this.age,
    required this.description,
    required this.photoUrls,
    required this.personality,
    this.relationshipScore = 0,
    DateTime? createdAt,
    this.preferences = const {},
    this.gender = 'female', // 기본값은 여성
    this.mbti = 'ENFP', // 기본값은 ENFP
    this.matchedAt, // 매칭된 시간
    this.imageUrls, // 새로운 이미지 URL 구조
    this.topics, // 주제들
    this.keywords, // 키워드들
    this.hasValidR2Image, // R2 이미지 유효성
  }) : createdAt = createdAt ?? DateTime.now();

  // 관계 상태 확인 메서드

  // 감정 반응 강도 계산 (점수 기반)
  double getEmotionalIntensity() {
    if (relationshipScore >= 1000) return 1.0; // 완전한 연애
    if (relationshipScore >= 500) return 0.8;  // 연애
    if (relationshipScore >= 200) return 0.6;  // 썸
    return 0.3; // 친구
  }

  // 질투 반응 여부 (점수 기반)
  bool canShowJealousy() {
    return relationshipScore >= 200; // 썸 이상부터 질투 반응
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
      // 우선순위 1: mainImageUrls 구조 확인 (여러 이미지 지원)
      if (imageUrls!.containsKey('mainImageUrls')) {
        final mainUrls = imageUrls!['mainImageUrls'] as Map<String, dynamic>?;
        if (mainUrls != null && mainUrls.containsKey(size)) {
          urls.add(mainUrls[size]);
        }
        
        // 추가 이미지들 확인 - additionalImageUrls가 있는 경우
        if (imageUrls!.containsKey('additionalImageUrls')) {
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
      // 우선순위 2: 최상위 size 키만 있는 경우 (단일 이미지)
      else if (imageUrls!.containsKey(size)) {
        final sizeUrls = imageUrls![size] as Map<String, dynamic>?;
        if (sizeUrls != null && sizeUrls.containsKey('jpg')) {
          urls.add(sizeUrls['jpg'] as String);
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
      'relationshipScore': relationshipScore,
      'createdAt': createdAt.toIso8601String(),
      'preferences': preferences,
      'gender': gender,
      'mbti': mbti,
      'imageUrls': imageUrls, // 새로운 이미지 URL 구조
      'topics': topics,
      'keywords': keywords,
      'hasValidR2Image': hasValidR2Image,
      if (matchedAt != null) 'matchedAt': matchedAt!.toIso8601String(),
    };
  }

  factory Persona.fromJson(Map<String, dynamic> json) {
    // photoUrls 파싱 처리 - 문자열 "[]" 문제 해결
    List<String> photoUrlsList = [];
    if (json['photoUrls'] != null) {
      if (json['photoUrls'] is List) {
        photoUrlsList = List<String>.from(json['photoUrls']);
      } else if (json['photoUrls'] is String && json['photoUrls'] == '[]') {
        // Firebase에서 잘못 저장된 문자열 "[]" 처리
        photoUrlsList = [];
      }
    }
    
    return Persona(
      id: json['id'],
      name: json['name'],
      age: json['age'],
      description: json['description'],
      photoUrls: photoUrlsList,
      personality: json['personality'],
      relationshipScore: json['relationshipScore'] ?? 0,
      createdAt: DateTime.parse(json['createdAt']),
      preferences: Map<String, dynamic>.from(json['preferences'] ?? {}),
      gender: json['gender'] ?? 'female',
      mbti: json['mbti'] ?? 'ENFP',
      imageUrls: json['imageUrls'] != null 
        ? Map<String, dynamic>.from(json['imageUrls']) 
        : null,
      topics: json['topics'] != null 
        ? List<String>.from(json['topics'])
        : null,
      keywords: json['keywords'] != null 
        ? List<String>.from(json['keywords'])
        : null,
      matchedAt: json['matchedAt'] != null 
        ? DateTime.parse(json['matchedAt'])
        : null,
      hasValidR2Image: json['hasValidR2Image'] ?? null,
    );
  }

  Persona copyWith({
    String? name,
    int? age,
    String? description,
    List<String>? photoUrls,
    String? personality,
    int? relationshipScore,
    Map<String, dynamic>? preferences,
    String? gender,
    String? mbti,
    Map<String, dynamic>? imageUrls,
    List<String>? topics,
    List<String>? keywords,
    DateTime? matchedAt,
    bool? hasValidR2Image,
  }) {
    return Persona(
      id: id,
      name: name ?? this.name,
      age: age ?? this.age,
      description: description ?? this.description,
      photoUrls: photoUrls ?? this.photoUrls,
      personality: personality ?? this.personality,
      relationshipScore: relationshipScore ?? this.relationshipScore,
      createdAt: createdAt,
      preferences: preferences ?? this.preferences,
      gender: gender ?? this.gender,
      mbti: mbti ?? this.mbti,
      imageUrls: imageUrls ?? this.imageUrls,
      matchedAt: matchedAt ?? this.matchedAt,
      topics: topics ?? this.topics,
      keywords: keywords ?? this.keywords,
      hasValidR2Image: hasValidR2Image ?? this.hasValidR2Image,
    );
  }
}

