/// Response patterns for natural conversation flow
/// These are pattern references, not actual responses
class ResponsePatterns {
  // Prevent instantiation
  ResponsePatterns._();

  /// Daily activities for context
  static const List<String> dailyActivities = [
    'activity_work',
    'activity_study',
    'activity_rest',
    'activity_exercise',
    'activity_hobby',
    'activity_social',
    'activity_meal',
    'activity_entertainment',
  ];

  /// Common locations for context
  static const List<String> locations = [
    'location_home',
    'location_office',
    'location_school',
    'location_cafe',
    'location_outside',
    'location_transport',
    'location_shopping',
    'location_restaurant',
  ];

  /// Transition phrases for topic changes
  static const List<String> transitionPhrases = [
    'transition_by_the_way',
    'transition_speaking_of',
    'transition_that_reminds_me',
    'transition_oh_right',
    'transition_anyway',
    'transition_but_really',
  ];
}