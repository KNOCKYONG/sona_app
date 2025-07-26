import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String uid;
  final String email;
  final String nickname;
  final String? gender;
  final DateTime birth;
  final int age;
  final PreferredPersona preferredPersona;
  final List<String> interests;
  final String? intro;
  final String? profileImageUrl;
  final DateTime createdAt;
  final DateTime? updatedAt;

  AppUser({
    required this.uid,
    required this.email,
    required this.nickname,
    this.gender,
    required this.birth,
    required this.age,
    required this.preferredPersona,
    required this.interests,
    this.intro,
    this.profileImageUrl,
    required this.createdAt,
    this.updatedAt,
  });

  // 나이 계산 함수
  static int calculateAge(DateTime birth) {
    final now = DateTime.now();
    int age = now.year - birth.year;
    if (now.month < birth.month || 
        (now.month == birth.month && now.day < birth.day)) {
      age--;
    }
    return age;
  }

  // Firestore 문서로 변환
  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'email': email,
      'nickname': nickname,
      'gender': gender,
      'birth': Timestamp.fromDate(birth),
      'age': age,
      'preferredPersona': preferredPersona.toMap(),
      'interests': interests,
      'intro': intro,
      'profileImageUrl': profileImageUrl,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }

  // Firestore 문서에서 생성
  factory AppUser.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AppUser(
      uid: data['uid'] ?? '',
      email: data['email'] ?? '',
      nickname: data['nickname'] ?? '',
      gender: data['gender'],
      birth: (data['birth'] as Timestamp).toDate(),
      age: data['age'] ?? 0,
      preferredPersona: PreferredPersona.fromMap(data['preferredPersona'] ?? {}),
      interests: List<String>.from(data['interests'] ?? []),
      intro: data['intro'],
      profileImageUrl: data['profileImageUrl'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: data['updatedAt'] != null 
          ? (data['updatedAt'] as Timestamp).toDate() 
          : null,
    );
  }

  // 복사 함수
  AppUser copyWith({
    String? nickname,
    String? gender,
    DateTime? birth,
    int? age,
    PreferredPersona? preferredPersona,
    List<String>? interests,
    String? intro,
    String? profileImageUrl,
    DateTime? updatedAt,
  }) {
    return AppUser(
      uid: uid,
      email: email,
      nickname: nickname ?? this.nickname,
      gender: gender ?? this.gender,
      birth: birth ?? this.birth,
      age: age ?? this.age,
      preferredPersona: preferredPersona ?? this.preferredPersona,
      interests: interests ?? this.interests,
      intro: intro ?? this.intro,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class PreferredPersona {
  final String gender;
  final List<int> ageRange;

  PreferredPersona({
    required this.gender,
    required this.ageRange,
  });

  Map<String, dynamic> toMap() {
    return {
      'gender': gender,
      'ageRange': ageRange,
    };
  }

  factory PreferredPersona.fromMap(Map<String, dynamic> map) {
    return PreferredPersona(
      gender: map['gender'] ?? 'female',
      ageRange: List<int>.from(map['ageRange'] ?? [20, 35]),
    );
  }
}

// 관심사 목록
class InterestOptions {
  static const List<String> allInterests = [
    '게임',
    '영화',
    '음악',
    '여행',
    '운동',
    '독서',
    '요리',
    '사진',
    '예술',
    '패션',
    '반려동물',
    '맛집탐방',
    'K-POP',
    '드라마',
    '애니메이션',
    '스포츠',
    '캠핑',
    '자기계발',
  ];
}