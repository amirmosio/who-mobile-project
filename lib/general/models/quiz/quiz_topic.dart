/// Quiz Topic Statistics model for actual quiz performance data
/// Tracks correct/wrong answers and average time per topic
class QuizTopicStats {
  final int argumentId;
  final int totalQuizzes;
  final int completedQuizzes;
  final int correctAnswers;
  final int wrongAnswers;
  final int totalTimeSeconds;

  const QuizTopicStats({
    required this.argumentId,
    required this.totalQuizzes,
    required this.completedQuizzes,
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.totalTimeSeconds,
  });

  /// Get average time per quiz in seconds
  double get averageTimeSeconds =>
      completedQuizzes > 0 ? totalTimeSeconds / completedQuizzes : 0.0;

  /// Get average time formatted as string (e.g., "45s" or "1m 23s")
  String get averageTimeFormatted {
    final seconds = averageTimeSeconds.round();
    if (seconds < 60) {
      return '${seconds}s';
    } else {
      final minutes = seconds ~/ 60;
      final remainingSeconds = seconds % 60;
      return '${minutes}m ${remainingSeconds}s';
    }
  }

  /// Get progress as decimal (0.0 to 1.0)
  double get progress => totalQuizzes > 0
      ? (completedQuizzes / totalQuizzes).clamp(0.0, 1.0)
      : 0.0;

  /// Get progress as percentage
  int get progressPercentage => (progress * 100).round();
}

/// Quiz Topic model for topic selection and statistics
/// Matches iOS CellSelezionaQuizArgomenti display data
/// Consolidates ArgumentStatistics and QuizTopic into single model
class QuizTopic {
  // UI fields
  final String id; // String ID for UI
  final String title;
  final String? iconPath;
  final bool isSelected;

  // Statistics fields
  final int argumentId; // Integer ID for database operations
  final int completedQuizzes;
  final int totalQuizzes;

  const QuizTopic({
    required this.id,
    required this.title,
    this.iconPath,
    this.isSelected = false,
    required this.argumentId,
    this.completedQuizzes = 0,
    this.totalQuizzes = 0,
  });

  /// Get progress as decimal (0.0 to 1.0) calculated from completed/total quizzes
  double get progress => totalQuizzes > 0
      ? (completedQuizzes / totalQuizzes).clamp(0.0, 1.0)
      : 0.0;

  /// Get progress as percentage (0 to 100) for UI display
  int get progressPercentage => (progress * 100).round();

  /// Factory constructor from statistics data (for database operations)
  factory QuizTopic.fromStatistics({
    required int argumentId,
    required int completedQuizzes,
    required int totalQuizzes,
    String? title,
    String? iconPath,
    bool isSelected = false,
  }) {
    return QuizTopic(
      id: argumentId.toString(),
      title: title ?? 'Topic $argumentId',
      iconPath: iconPath,
      isSelected: isSelected,
      argumentId: argumentId,
      completedQuizzes: completedQuizzes,
      totalQuizzes: totalQuizzes,
    );
  }

  QuizTopic copyWith({
    String? id,
    String? title,
    String? iconPath,
    bool? isSelected,
    int? argumentId,
    int? completedQuizzes,
    int? totalQuizzes,
  }) {
    return QuizTopic(
      id: id ?? this.id,
      title: title ?? this.title,
      iconPath: iconPath ?? this.iconPath,
      isSelected: isSelected ?? this.isSelected,
      argumentId: argumentId ?? this.argumentId,
      completedQuizzes: completedQuizzes ?? this.completedQuizzes,
      totalQuizzes: totalQuizzes ?? this.totalQuizzes,
    );
  }
}
