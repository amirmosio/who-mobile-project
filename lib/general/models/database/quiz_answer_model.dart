/// Quiz Answer (Multiple choice option) model from API
/// Maps to QuizAnswers table in local database
class QuizAnswerModel {
  final int id;
  final String? answerText;
  final int? position;
  final String createdDatetime;
  final String modifiedDatetime;
  final bool? isCorrect;
  final bool? isActive;
  final int? licenseTypeId;
  final int? quizId;

  QuizAnswerModel({
    required this.id,
    this.answerText,
    this.position,
    required this.createdDatetime,
    required this.modifiedDatetime,
    this.isCorrect,
    this.isActive,
    this.licenseTypeId,
    this.quizId,
  });

  factory QuizAnswerModel.fromJson(Map<String, dynamic> json) {
    return QuizAnswerModel(
      id: json['id'] as int,
      answerText: (json['answer_text'] as String?) ?? (json['text'] as String?),
      position: json['position'] as int?,
      createdDatetime: json['created_datetime'] as String,
      modifiedDatetime: json['modified_datetime'] as String,
      isCorrect: json['is_correct'] as bool?,
      isActive: json['is_active'] as bool?,
      licenseTypeId: json['license_type'] as int?,
      quizId: json['quiz'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (answerText != null) 'answer_text': answerText,
      if (position != null) 'position': position,
      'created_datetime': createdDatetime,
      'modified_datetime': modifiedDatetime,
      if (isCorrect != null) 'is_correct': isCorrect,
      if (isActive != null) 'is_active': isActive,
      if (licenseTypeId != null) 'license_type': licenseTypeId,
      if (quizId != null) 'quiz': quizId,
    };
  }
}
