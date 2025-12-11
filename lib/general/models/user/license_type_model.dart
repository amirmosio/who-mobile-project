import 'package:who_mobile_project/general/models/database/picture_quiz_model.dart';
import 'language_model.dart';

class LicenseTypeModel {
  final int id;
  final String name;
  final String? note;
  final int? position;
  final PictureQuizModel? thumb;
  final bool isActive;
  final int duration;
  final int? numberOfQuestions;
  final int? numberOfAnswer;
  final int? maxErrors;
  final int? numberQuizzes;
  final DateTime? createdDate;
  final DateTime? modifiedDate;
  final bool? isRevision;
  final bool? hasBook;
  final bool? hasAnswer;
  final List<int> children;
  final List<Language>? languages;

  const LicenseTypeModel({
    required this.id,
    required this.name,
    this.note,
    this.position,
    this.thumb,
    this.isActive = true,
    this.duration = 0,
    this.numberOfQuestions,
    this.numberOfAnswer,
    this.maxErrors,
    this.numberQuizzes,
    this.createdDate,
    this.modifiedDate,
    this.isRevision,
    this.hasBook,
    this.hasAnswer,
    this.children = const [],
    this.languages,
  });

  factory LicenseTypeModel.fromJson(Map<String, dynamic> json) {
    return LicenseTypeModel(
      id: json['id'] as int,
      name: json['name'] as String,
      note: json['note'] as String?,
      position: json['position'] as int?,
      thumb: json['thumb'] != null
          ? PictureQuizModel.fromJson(json['thumb'] as Map<String, dynamic>)
          : null,
      isActive: json['is_active'] as bool? ?? true,
      duration: json['duration'] as int? ?? 0,
      numberOfQuestions: json['number_question'] as int?,
      numberOfAnswer: json['number_answer'] as int?,
      maxErrors: json['max_number_error'] as int?,
      numberQuizzes: json['number_quizzes'] as int?,
      createdDate: json['created_datetime'] != null
          ? DateTime.tryParse(json['created_datetime'] as String)
          : null,
      modifiedDate: json['modified_datetime'] != null
          ? DateTime.tryParse(json['modified_datetime'] as String)
          : null,
      isRevision: json['is_revision'] as bool?,
      hasBook: json['has_book'] as bool?,
      hasAnswer: json['has_answer'] as bool?,
      children:
          (json['children'] as List<dynamic>?)?.map((e) => e as int).toList() ??
          const [],
      languages: json['languages'] != null
          ? (json['languages'] as List<dynamic>)
                .map((e) => Language.fromJson(e as Map<String, dynamic>))
                .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      if (note != null) 'note': note,
      if (position != null) 'position': position,
      if (thumb != null) 'thumb': thumb!.toJson(),
      'is_active': isActive,
      'duration': duration,
      if (numberOfQuestions != null) 'number_question': numberOfQuestions,
      if (numberOfAnswer != null) 'number_answer': numberOfAnswer,
      if (maxErrors != null) 'max_number_error': maxErrors,
      if (numberQuizzes != null) 'number_quizzes': numberQuizzes,
      if (createdDate != null)
        'created_datetime': createdDate!.toIso8601String(),
      if (modifiedDate != null)
        'modified_datetime': modifiedDate!.toIso8601String(),
      if (isRevision != null) 'is_revision': isRevision,
      if (hasBook != null) 'has_book': hasBook,
      if (hasAnswer != null) 'has_answer': hasAnswer,
      'children': children,
      if (languages != null)
        'languages': languages!.map((e) => e.toJson()).toList(),
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LicenseTypeModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'LicenseTypeModel(id: $id, name: $name)';
}
