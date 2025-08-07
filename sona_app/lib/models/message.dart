enum MessageType {
  text,
  image,
  voice,
  system,
  emotion,
  storyEvent,
}

enum EmotionType {
  happy('😊'),
  love('😍'),
  shy('😳'),
  jealous('😒'),
  angry('😠'),
  sad('😢'),
  surprised('😲'),
  thoughtful('🤔'),
  anxious('😰'),
  concerned('😟'),
  neutral('😐'),
  excited('🤗'),
  caring('🥰'),
  confident('😎'),
  curious('🤔'),
  calm('😌'),
  grateful('🙏'),
  proud('💪'),
  sympathetic('🤝'),
  disappointed('😞'),
  confused('😕'),
  bored('😑'),
  tired('😴'),
  lonely('😔'),
  guilty('😣'),
  embarrassed('😳'),
  hopeful('🤞'),
  frustrated('😤'),
  relieved('😌');

  const EmotionType(this.emoji);
  final String emoji;
}

class Message {
  final String id;
  final String personaId;
  final String content;
  final MessageType type;
  final bool isFromUser;
  final DateTime timestamp;
  final EmotionType? emotion;
  final Map<String, dynamic>? metadata;
  final int? likesChange;
  final bool isRead;
  final bool isFirstInSequence;
  final bool isSending; // 전송 중 상태
  final bool hasFailed; // 전송 실패 상태

  // 다국어 지원 필드
  final String? originalLanguage; // 원문 언어 코드 (예: 'ko', 'en')
  final String? translatedContent; // 번역된 내용
  final String? targetLanguage; // 번역 대상 언어 코드
  
  // 리액션 지원
  final Map<String, int>? reactions; // emoji -> count

  Message({
    required this.id,
    required this.personaId,
    required this.content,
    required this.type,
    required this.isFromUser,
    DateTime? timestamp,
    this.emotion,
    this.metadata,
    this.likesChange,
    this.isRead = false,
    this.isFirstInSequence = true,
    this.isSending = false,
    this.hasFailed = false,
    this.originalLanguage,
    this.translatedContent,
    this.targetLanguage,
    this.reactions,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'personaId': personaId,
      'content': content,
      'type': type.name,
      'isFromUser': isFromUser,
      'timestamp': timestamp.toIso8601String(),
      'emotion': emotion?.name,
      'metadata': metadata,
      'likesChange': likesChange,
      'isRead': isRead,
      'isFirstInSequence': isFirstInSequence,
      'isSending': isSending,
      'hasFailed': hasFailed,
      'originalLanguage': originalLanguage,
      'translatedContent': translatedContent,
      'targetLanguage': targetLanguage,
      'reactions': reactions,
    };
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      personaId: json['personaId'],
      content: json['content'],
      type: MessageType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => MessageType.text,
      ),
      isFromUser: json['isFromUser'],
      timestamp: DateTime.parse(json['timestamp']),
      emotion: json['emotion'] != null
          ? EmotionType.values.firstWhere(
              (e) => e.name == json['emotion'],
              orElse: () => EmotionType.happy,
            )
          : null,
      metadata: json['metadata'] != null
          ? Map<String, dynamic>.from(json['metadata'])
          : null,
      likesChange:
          json['likesChange'] ?? json['relationshipScoreChange'], // 호환성
      isRead: json['isRead'] ?? false,
      isFirstInSequence: json['isFirstInSequence'] ?? true,
      isSending: json['isSending'] ?? false,
      hasFailed: json['hasFailed'] ?? false,
      originalLanguage: json['originalLanguage'],
      translatedContent: json['translatedContent'],
      targetLanguage: json['targetLanguage'],
      reactions: json['reactions'] != null
          ? Map<String, int>.from(json['reactions'])
          : null,
    );
  }

  Message copyWith({
    String? content,
    MessageType? type,
    EmotionType? emotion,
    Map<String, dynamic>? metadata,
    int? likesChange,
    bool? isRead,
    bool? isFirstInSequence,
    bool? isSending,
    bool? hasFailed,
    String? originalLanguage,
    String? translatedContent,
    String? targetLanguage,
    Map<String, int>? reactions,
  }) {
    return Message(
      id: id,
      personaId: personaId,
      content: content ?? this.content,
      type: type ?? this.type,
      isFromUser: isFromUser,
      timestamp: timestamp,
      emotion: emotion ?? this.emotion,
      metadata: metadata ?? this.metadata,
      likesChange: likesChange ?? this.likesChange,
      isRead: isRead ?? this.isRead,
      isFirstInSequence: isFirstInSequence ?? this.isFirstInSequence,
      isSending: isSending ?? this.isSending,
      hasFailed: hasFailed ?? this.hasFailed,
      originalLanguage: originalLanguage ?? this.originalLanguage,
      translatedContent: translatedContent ?? this.translatedContent,
      targetLanguage: targetLanguage ?? this.targetLanguage,
      reactions: reactions ?? this.reactions,
    );
  }
}

class StoryEvent {
  final String id;
  final String title;
  final String description;
  final List<StoryChoice> choices;
  final DateTime triggerDate;
  final bool isCompleted;
  final Map<String, dynamic> conditions;

  StoryEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.choices,
    required this.triggerDate,
    this.isCompleted = false,
    this.conditions = const {},
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'choices': choices.map((c) => c.toJson()).toList(),
      'triggerDate': triggerDate.toIso8601String(),
      'isCompleted': isCompleted,
      'conditions': conditions,
    };
  }

  factory StoryEvent.fromJson(Map<String, dynamic> json) {
    return StoryEvent(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      choices: (json['choices'] as List)
          .map((c) => StoryChoice.fromJson(c))
          .toList(),
      triggerDate: DateTime.parse(json['triggerDate']),
      isCompleted: json['isCompleted'] ?? false,
      conditions: Map<String, dynamic>.from(json['conditions'] ?? {}),
    );
  }
}

class StoryChoice {
  final String id;
  final String text;
  final int scoreChange;
  final EmotionType emotion;
  final String? followUpMessage;

  StoryChoice({
    required this.id,
    required this.text,
    required this.scoreChange,
    required this.emotion,
    this.followUpMessage,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'scoreChange': scoreChange,
      'emotion': emotion.name,
      'followUpMessage': followUpMessage,
    };
  }

  factory StoryChoice.fromJson(Map<String, dynamic> json) {
    return StoryChoice(
      id: json['id'],
      text: json['text'],
      scoreChange: json['scoreChange'],
      emotion: EmotionType.values.firstWhere(
        (e) => e.name == json['emotion'],
        orElse: () => EmotionType.happy,
      ),
      followUpMessage: json['followUpMessage'],
    );
  }
}
