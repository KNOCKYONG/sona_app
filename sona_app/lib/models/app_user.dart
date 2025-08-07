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

  // 새로운 필드들
  final String?
      purpose; // 'friendship', 'dating', 'counseling', 'entertainment'
  final List<String>? preferredPersonaTypes; // 선호하는 페르소나 유형들
  final List<String>? preferredMbti; // 선호하는 MBTI 유형들
  final String? communicationStyle; // 'casual', 'formal', 'adaptive'
  final List<String>? preferredTopics; // 선호하는 대화 주제들
  final bool genderAll; // Gender All 체크박스 - 모든 성별 페르소나 보기
  final List<String> actionedPersonaIds; // 액션(좋아요, 슈퍼좋아요, 취소)한 페르소나 ID 목록

  // 일일 메시지 제한 관련 필드
  final int dailyMessageCount; // 오늘 보낸 메시지 수
  final DateTime? lastMessageCountReset; // 마지막 리셋 시간
  final int dailyMessageLimit; // 일일 메시지 제한 (기본값: 100)

  // 다국어 지원 필드
  final String
      preferredLanguage; // 선호 언어 코드 ('ko', 'en', 'ja', 'zh', 'id', 'vi' 등)

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
    this.purpose,
    this.preferredPersonaTypes,
    this.preferredMbti,
    this.communicationStyle,
    this.preferredTopics,
    this.genderAll = false,
    List<String>? actionedPersonaIds,
    this.dailyMessageCount = 0,
    this.lastMessageCountReset,
    this.dailyMessageLimit = 100,
    this.preferredLanguage = 'ko', // 기본값은 한국어
  }) : actionedPersonaIds = actionedPersonaIds ?? [];

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
      'purpose': purpose,
      'preferredPersonaTypes': preferredPersonaTypes,
      'preferredMbti': preferredMbti,
      'communicationStyle': communicationStyle,
      'preferredTopics': preferredTopics,
      'genderAll': genderAll,
      'actionedPersonaIds': actionedPersonaIds,
      'dailyMessageCount': dailyMessageCount,
      'lastMessageCountReset': lastMessageCountReset != null
          ? Timestamp.fromDate(lastMessageCountReset!)
          : null,
      'dailyMessageLimit': dailyMessageLimit,
      'preferredLanguage': preferredLanguage,
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
      preferredPersona:
          PreferredPersona.fromMap(data['preferredPersona'] ?? {}),
      interests: List<String>.from(data['interests'] ?? []),
      intro: data['intro'],
      profileImageUrl: data['profileImageUrl'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: data['updatedAt'] != null
          ? (data['updatedAt'] as Timestamp).toDate()
          : null,
      purpose: data['purpose'],
      preferredPersonaTypes: data['preferredPersonaTypes'] != null
          ? List<String>.from(data['preferredPersonaTypes'])
          : null,
      preferredMbti: data['preferredMbti'] != null
          ? List<String>.from(data['preferredMbti'])
          : null,
      communicationStyle: data['communicationStyle'],
      preferredTopics: data['preferredTopics'] != null
          ? List<String>.from(data['preferredTopics'])
          : null,
      genderAll: data['genderAll'] ?? false,
      actionedPersonaIds: data['actionedPersonaIds'] != null
          ? List<String>.from(data['actionedPersonaIds'])
          : [],
      dailyMessageCount: data['dailyMessageCount'] ?? 0,
      lastMessageCountReset: data['lastMessageCountReset'] != null
          ? (data['lastMessageCountReset'] as Timestamp).toDate()
          : null,
      dailyMessageLimit: data['dailyMessageLimit'] ?? 100,
      preferredLanguage: data['preferredLanguage'] ?? 'ko',
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
    String? purpose,
    List<String>? preferredPersonaTypes,
    List<String>? preferredMbti,
    String? communicationStyle,
    List<String>? preferredTopics,
    bool? genderAll,
    List<String>? actionedPersonaIds,
    int? dailyMessageCount,
    DateTime? lastMessageCountReset,
    int? dailyMessageLimit,
    String? preferredLanguage,
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
      purpose: purpose ?? this.purpose,
      preferredPersonaTypes:
          preferredPersonaTypes ?? this.preferredPersonaTypes,
      preferredMbti: preferredMbti ?? this.preferredMbti,
      communicationStyle: communicationStyle ?? this.communicationStyle,
      preferredTopics: preferredTopics ?? this.preferredTopics,
      genderAll: genderAll ?? this.genderAll,
      actionedPersonaIds: actionedPersonaIds ?? this.actionedPersonaIds,
      dailyMessageCount: dailyMessageCount ?? this.dailyMessageCount,
      lastMessageCountReset:
          lastMessageCountReset ?? this.lastMessageCountReset,
      dailyMessageLimit: dailyMessageLimit ?? this.dailyMessageLimit,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
    );
  }
}

class PreferredPersona {
  final List<int> ageRange;

  PreferredPersona({
    required this.ageRange,
  });

  Map<String, dynamic> toMap() {
    return {
      'ageRange': ageRange,
    };
  }

  factory PreferredPersona.fromMap(Map<String, dynamic> map) {
    return PreferredPersona(
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

// 사용 목적 옵션
class PurposeOptions {
  static const Map<String, String> purposes = {
    'friendship': '친구 만들기',
    'dating': '연애/데이팅',
    'entertainment': '엔터테인먼트',
  };
}

// 선호 주제 옵션
class TopicOptions {
  static const List<String> allTopics = [
    '일상 대화',
    '연애 상담',
    '진로 상담',
    '취미 공유',
    '운동/건강',
    '요리/맛집',
    '여행 계획',
    '문화/예술',
    '게임 이야기',
    '공부/학습',
    '직장 생활',
    '인간관계',
    '자기계발',
    '심리 상담',
    '패션/뷰티',
  ];
}

// MBTI 옵션
class MbtiOptions {
  static const List<String> allTypes = [
    'INTJ',
    'INTP',
    'ENTJ',
    'ENTP',
    'INFJ',
    'INFP',
    'ENFJ',
    'ENFP',
    'ISTJ',
    'ISFJ',
    'ESTJ',
    'ESFJ',
    'ISTP',
    'ISFP',
    'ESTP',
    'ESFP',
  ];
}
