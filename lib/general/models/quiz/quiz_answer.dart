class QuizAnswer {
  final String questionId;
  final bool userAnswer;
  final bool correctAnswer;
  final DateTime answeredAt;
  final int timeTaken; // in seconds

  const QuizAnswer({
    required this.questionId,
    required this.userAnswer,
    required this.correctAnswer,
    required this.answeredAt,
    required this.timeTaken,
  });

  factory QuizAnswer.fromJson(Map<String, dynamic> json) {
    return QuizAnswer(
      questionId: json['questionId'] as String,
      userAnswer: json['userAnswer'] as bool,
      correctAnswer: json['correctAnswer'] as bool,
      answeredAt: DateTime.parse(json['answeredAt'] as String),
      timeTaken: json['timeTaken'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'questionId': questionId,
      'userAnswer': userAnswer,
      'correctAnswer': correctAnswer,
      'answeredAt': answeredAt.toIso8601String(),
      'timeTaken': timeTaken,
    };
  }

  bool get isCorrect => userAnswer == correctAnswer;
}
