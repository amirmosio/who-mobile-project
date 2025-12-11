import 'package:who_mobile_project/general/database/app_database.dart';

/// Quiz entity with its answers for multiple choice questions
class QuizWithAnswers {
  final QuizEntity quiz;
  final List<QuizAnswerEntity> answers;

  const QuizWithAnswers({required this.quiz, required this.answers});

  /// Create from quiz entity and answers
  factory QuizWithAnswers.fromQuizAndAnswers(
    QuizEntity quiz,
    List<QuizAnswerEntity> answers,
  ) {
    return QuizWithAnswers(quiz: quiz, answers: answers);
  }

  /// Create for boolean quiz (no answers needed)
  factory QuizWithAnswers.fromBooleanQuiz(QuizEntity quiz) {
    return QuizWithAnswers(quiz: quiz, answers: []);
  }

  /// Check if this is a multiple choice question
  bool get isMultipleChoice => quiz.hasAnswer && answers.isNotEmpty;

  /// Check if this is a boolean question
  bool get isBoolean => !quiz.hasAnswer || answers.isEmpty;

  /// Get the correct answer ID for multiple choice questions
  int? get correctAnswerId {
    if (!isMultipleChoice) return null;
    final correctAnswer = answers.firstWhere(
      (answer) => answer.isCorrect == true,
      orElse: () => answers.first,
    );
    return correctAnswer.id;
  }

  /// Get answer by ID
  QuizAnswerEntity? getAnswerById(int answerId) {
    try {
      return answers.firstWhere((answer) => answer.id == answerId);
    } catch (e) {
      return null;
    }
  }

  @override
  String toString() {
    return 'QuizWithAnswers(quiz: ${quiz.id}, answers: ${answers.length})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is QuizWithAnswers &&
        other.quiz.id == quiz.id &&
        other.answers.length == answers.length;
  }

  @override
  int get hashCode => quiz.id.hashCode ^ answers.length.hashCode;
}
