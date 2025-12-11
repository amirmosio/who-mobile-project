class QuizResult {
  final String sessionId;
  final int totalQuestions;
  final int correctAnswers;
  final int incorrectAnswers;
  final int unansweredQuestions;
  final int totalTimeInSeconds;
  final bool isPassed;
  final double scorePercentage;
  final List<QuizResultItem> questionDetails;
  final DateTime completedAt;

  const QuizResult({
    required this.sessionId,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.incorrectAnswers,
    required this.unansweredQuestions,
    required this.totalTimeInSeconds,
    required this.isPassed,
    required this.scorePercentage,
    required this.questionDetails,
    required this.completedAt,
  });

  factory QuizResult.fromJson(Map<String, dynamic> json) {
    return QuizResult(
      sessionId: json['sessionId'] as String,
      totalQuestions: json['totalQuestions'] as int,
      correctAnswers: json['correctAnswers'] as int,
      incorrectAnswers: json['incorrectAnswers'] as int,
      unansweredQuestions: json['unansweredQuestions'] as int,
      totalTimeInSeconds: json['totalTimeInSeconds'] as int,
      isPassed: json['isPassed'] as bool,
      scorePercentage: json['scorePercentage'] as double,
      questionDetails: (json['questionDetails'] as List<dynamic>)
          .map((item) => QuizResultItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      completedAt: DateTime.parse(json['completedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sessionId': sessionId,
      'totalQuestions': totalQuestions,
      'correctAnswers': correctAnswers,
      'incorrectAnswers': incorrectAnswers,
      'unansweredQuestions': unansweredQuestions,
      'totalTimeInSeconds': totalTimeInSeconds,
      'isPassed': isPassed,
      'scorePercentage': scorePercentage,
      'questionDetails': questionDetails.map((item) => item.toJson()).toList(),
      'completedAt': completedAt.toIso8601String(),
    };
  }

  String get formattedTime {
    final minutes = totalTimeInSeconds ~/ 60;
    final seconds = totalTimeInSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String get resultStatus {
    if (isPassed) {
      return 'Promosso';
    } else {
      return 'Bocciato';
    }
  }

  QuizResult copyWith({
    String? sessionId,
    int? totalQuestions,
    int? correctAnswers,
    int? incorrectAnswers,
    int? unansweredQuestions,
    int? totalTimeInSeconds,
    bool? isPassed,
    double? scorePercentage,
    List<QuizResultItem>? questionDetails,
    DateTime? completedAt,
  }) {
    return QuizResult(
      sessionId: sessionId ?? this.sessionId,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      incorrectAnswers: incorrectAnswers ?? this.incorrectAnswers,
      unansweredQuestions: unansweredQuestions ?? this.unansweredQuestions,
      totalTimeInSeconds: totalTimeInSeconds ?? this.totalTimeInSeconds,
      isPassed: isPassed ?? this.isPassed,
      scorePercentage: scorePercentage ?? this.scorePercentage,
      questionDetails: questionDetails ?? this.questionDetails,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}

class QuizResultItem {
  final String questionId;
  final String questionText;
  final bool? userAnswer;
  final bool correctAnswer;
  final bool isCorrect;
  final bool wasAnswered;
  final int timeTakenInSeconds;
  final String? videoUrl;
  final String? theoryUrl;
  final int? manualId;
  final bool isMultipleChoice;
  final int? userAnswerId;
  final int? correctAnswerId;
  final String? storedUserAnswerText;
  final String? storedCorrectAnswerText;
  final String? imageUrl;

  const QuizResultItem({
    required this.questionId,
    required this.questionText,
    this.userAnswer,
    required this.correctAnswer,
    required this.isCorrect,
    required this.wasAnswered,
    required this.timeTakenInSeconds,
    this.videoUrl,
    this.theoryUrl,
    this.manualId,
    this.isMultipleChoice = false,
    this.userAnswerId,
    this.correctAnswerId,
    this.storedUserAnswerText,
    this.storedCorrectAnswerText,
    this.imageUrl,
  });

  factory QuizResultItem.fromJson(Map<String, dynamic> json) {
    return QuizResultItem(
      questionId: json['questionId'] as String,
      questionText: json['questionText'] as String,
      userAnswer: json['userAnswer'] as bool?,
      correctAnswer: json['correctAnswer'] as bool,
      isCorrect: json['isCorrect'] as bool,
      wasAnswered: json['wasAnswered'] as bool,
      timeTakenInSeconds: json['timeTakenInSeconds'] as int,
      videoUrl: json['videoUrl'] as String?,
      theoryUrl: json['theoryUrl'] as String?,
      manualId: json['manualId'] as int?,
      isMultipleChoice: json['isMultipleChoice'] as bool? ?? false,
      userAnswerId: json['userAnswerId'] as int?,
      correctAnswerId: json['correctAnswerId'] as int?,
      storedUserAnswerText: json['userAnswerText'] as String?,
      storedCorrectAnswerText: json['correctAnswerText'] as String?,
      imageUrl: json['imageUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'questionId': questionId,
      'questionText': questionText,
      'userAnswer': userAnswer,
      'correctAnswer': correctAnswer,
      'isCorrect': isCorrect,
      'wasAnswered': wasAnswered,
      'timeTakenInSeconds': timeTakenInSeconds,
      'videoUrl': videoUrl,
      'theoryUrl': theoryUrl,
      'manualId': manualId,
      'isMultipleChoice': isMultipleChoice,
      'userAnswerId': userAnswerId,
      'correctAnswerId': correctAnswerId,
      'userAnswerText': storedUserAnswerText,
      'correctAnswerText': storedCorrectAnswerText,
      'imageUrl': imageUrl,
    };
  }

  String get userAnswerText {
    if (!wasAnswered) return 'Non risposta';

    if (isMultipleChoice) {
      // Use the stored answer text if available, otherwise fallback to ID
      return storedUserAnswerText ??
          (userAnswerId != null ? 'Risposta $userAnswerId' : 'Non risposta');
    }

    // For boolean questions
    if (userAnswer == null) return 'Non risposta';
    return userAnswer! ? 'Vero' : 'Falso';
  }

  String get correctAnswerText {
    if (isMultipleChoice) {
      // Use the stored answer text if available, otherwise fallback to ID
      return storedCorrectAnswerText ??
          (correctAnswerId != null
              ? 'Risposta $correctAnswerId'
              : 'Sconosciuta');
    }

    // For boolean questions
    return correctAnswer ? 'Vero' : 'Falso';
  }

  QuizResultItem copyWith({
    String? questionId,
    String? questionText,
    bool? userAnswer,
    bool? correctAnswer,
    bool? isCorrect,
    bool? wasAnswered,
    int? timeTakenInSeconds,
    String? videoUrl,
    String? theoryUrl,
    int? manualId,
    bool? isMultipleChoice,
    int? userAnswerId,
    int? correctAnswerId,
    String? storedUserAnswerText,
    String? storedCorrectAnswerText,
    String? imageUrl,
  }) {
    return QuizResultItem(
      questionId: questionId ?? this.questionId,
      questionText: questionText ?? this.questionText,
      userAnswer: userAnswer ?? this.userAnswer,
      correctAnswer: correctAnswer ?? this.correctAnswer,
      isCorrect: isCorrect ?? this.isCorrect,
      wasAnswered: wasAnswered ?? this.wasAnswered,
      timeTakenInSeconds: timeTakenInSeconds ?? this.timeTakenInSeconds,
      videoUrl: videoUrl ?? this.videoUrl,
      theoryUrl: theoryUrl ?? this.theoryUrl,
      manualId: manualId ?? this.manualId,
      isMultipleChoice: isMultipleChoice ?? this.isMultipleChoice,
      userAnswerId: userAnswerId ?? this.userAnswerId,
      correctAnswerId: correctAnswerId ?? this.correctAnswerId,
      storedUserAnswerText: storedUserAnswerText ?? this.storedUserAnswerText,
      storedCorrectAnswerText:
          storedCorrectAnswerText ?? this.storedCorrectAnswerText,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
