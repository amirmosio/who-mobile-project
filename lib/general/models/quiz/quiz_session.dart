import 'quiz_answer.dart';

class QuizSession {
  final String id;
  final String categoryType; // 'ministerial' or 'theory'
  final List<String> selectedTopics;
  final List<QuizAnswer> answers;
  final DateTime startedAt;
  final DateTime? completedAt;
  final int totalQuestions;
  final bool isCompleted;

  const QuizSession({
    required this.id,
    required this.categoryType,
    required this.selectedTopics,
    required this.answers,
    required this.startedAt,
    this.completedAt,
    required this.totalQuestions,
    required this.isCompleted,
  });

  factory QuizSession.fromJson(Map<String, dynamic> json) {
    return QuizSession(
      id: json['id'] as String,
      categoryType: json['categoryType'] as String,
      selectedTopics: List<String>.from(json['selectedTopics']),
      answers: (json['answers'] as List<dynamic>)
          .map(
            (answerJson) =>
                QuizAnswer.fromJson(answerJson as Map<String, dynamic>),
          )
          .toList(),
      startedAt: DateTime.parse(json['startedAt'] as String),
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
      totalQuestions: json['totalQuestions'] as int,
      isCompleted: json['isCompleted'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'categoryType': categoryType,
      'selectedTopics': selectedTopics,
      'answers': answers.map((answer) => answer.toJson()).toList(),
      'startedAt': startedAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'totalQuestions': totalQuestions,
      'isCompleted': isCompleted,
    };
  }

  int get correctAnswers => answers.where((answer) => answer.isCorrect).length;
  int get incorrectAnswers =>
      answers.where((answer) => !answer.isCorrect).length;
  double get scorePercentage =>
      answers.isEmpty ? 0.0 : (correctAnswers / answers.length) * 100;
  int get currentQuestionNumber => answers.length + 1;

  QuizSession copyWith({
    String? id,
    String? categoryType,
    List<String>? selectedTopics,
    List<QuizAnswer>? answers,
    DateTime? startedAt,
    DateTime? completedAt,
    int? totalQuestions,
    bool? isCompleted,
  }) {
    return QuizSession(
      id: id ?? this.id,
      categoryType: categoryType ?? this.categoryType,
      selectedTopics: selectedTopics ?? this.selectedTopics,
      answers: answers ?? this.answers,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
