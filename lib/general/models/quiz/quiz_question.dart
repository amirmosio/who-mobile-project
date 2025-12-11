class QuizQuestion {
  final String id;
  final String text;
  final String? imageUrl;
  final String? audioUrl;
  final bool isCorrect;
  final int questionNumber;
  final int totalQuestions;
  final String category;
  final int timeLimit; // in seconds

  const QuizQuestion({
    required this.id,
    required this.text,
    this.imageUrl,
    this.audioUrl,
    required this.isCorrect,
    required this.questionNumber,
    required this.totalQuestions,
    required this.category,
    required this.timeLimit,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      id: json['id'] as String,
      text: json['text'] as String,
      imageUrl: json['imageUrl'] as String?,
      audioUrl: json['audioUrl'] as String?,
      isCorrect: json['isCorrect'] as bool,
      questionNumber: json['questionNumber'] as int,
      totalQuestions: json['totalQuestions'] as int,
      category: json['category'] as String,
      timeLimit: json['timeLimit'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'imageUrl': imageUrl,
      'audioUrl': audioUrl,
      'isCorrect': isCorrect,
      'questionNumber': questionNumber,
      'totalQuestions': totalQuestions,
      'category': category,
      'timeLimit': timeLimit,
    };
  }

  QuizQuestion copyWith({
    String? id,
    String? text,
    String? imageUrl,
    String? audioUrl,
    bool? isCorrect,
    int? questionNumber,
    int? totalQuestions,
    String? category,
    int? timeLimit,
  }) {
    return QuizQuestion(
      id: id ?? this.id,
      text: text ?? this.text,
      imageUrl: imageUrl ?? this.imageUrl,
      audioUrl: audioUrl ?? this.audioUrl,
      isCorrect: isCorrect ?? this.isCorrect,
      questionNumber: questionNumber ?? this.questionNumber,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      category: category ?? this.category,
      timeLimit: timeLimit ?? this.timeLimit,
    );
  }
}
