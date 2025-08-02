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
  final int? relationshipScoreChange;
  final bool isRead;

  Message({
    required this.id,
    required this.personaId,
    required this.content,
    required this.type,
    required this.isFromUser,
    DateTime? timestamp,
    this.emotion,
    this.metadata,
    this.relationshipScoreChange,
    this.isRead = false,
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
      'relationshipScoreChange': relationshipScoreChange,
      'isRead': isRead,
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
      relationshipScoreChange: json['relationshipScoreChange'],
      isRead: json['isRead'] ?? false,
    );
  }

  Message copyWith({
    String? content,
    MessageType? type,
    EmotionType? emotion,
    Map<String, dynamic>? metadata,
    int? relationshipScoreChange,
    bool? isRead,
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
      relationshipScoreChange: relationshipScoreChange ?? this.relationshipScoreChange,
      isRead: isRead ?? this.isRead,
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