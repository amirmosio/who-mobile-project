import 'package:who_mobile_project/general/models/user/license_type_model.dart';
import 'argument_model.dart';
import 'manual_model.dart';
import 'quiz_model.dart';
import 'quiz_answer_model.dart';
import 'manual_book_model.dart';

/// Model representing database update response from API
/// Matches iOS UpdateDB entity structure
/// Contains incremental database updates for specific license type
///
/// This is used to receive updates from the backend and can be held
/// in memory without persisting to the database immediately.
///
/// To persist data, use DatabaseSyncService to map these models
/// to their corresponding database entities.
class UpdateDBModel {
  final List<LicenseTypeModel>? licenseTypes;
  final List<ArgumentModel>? arguments;
  final List<ManualModel>? manuals;
  final List<QuizModel>? quizzes;
  final List<ManualBookModel>? manualBooks;
  final List<QuizAnswerModel>? quizAnswers;

  UpdateDBModel({
    this.licenseTypes,
    this.arguments,
    this.manuals,
    this.quizzes,
    this.manualBooks,
    this.quizAnswers,
  });

  factory UpdateDBModel.fromJson(Map<String, dynamic> json) {
    return UpdateDBModel(
      licenseTypes: json['license_types'] != null
          ? (json['license_types'] as List)
                .map(
                  (e) => LicenseTypeModel.fromJson(e as Map<String, dynamic>),
                )
                .toList()
          : null,
      arguments: json['arguments'] != null
          ? (json['arguments'] as List)
                .map((e) => ArgumentModel.fromJson(e as Map<String, dynamic>))
                .toList()
          : null,
      manuals: json['manuals'] != null
          ? (json['manuals'] as List)
                .map((e) => ManualModel.fromJson(e as Map<String, dynamic>))
                .toList()
          : null,
      quizzes: json['quizzes'] != null
          ? (json['quizzes'] as List)
                .map((e) => QuizModel.fromJson(e as Map<String, dynamic>))
                .toList()
          : null,
      manualBooks: json['manual_books'] != null
          ? (json['manual_books'] as List)
                .map((e) => ManualBookModel.fromJson(e as Map<String, dynamic>))
                .toList()
          : null,
      quizAnswers: json['quiz_answers'] != null
          ? (json['quiz_answers'] as List)
                .map((e) => QuizAnswerModel.fromJson(e as Map<String, dynamic>))
                .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (licenseTypes != null)
        'license_types': licenseTypes!.map((e) => e.toJson()).toList(),
      if (arguments != null)
        'arguments': arguments!.map((e) => e.toJson()).toList(),
      if (manuals != null) 'manuals': manuals!.map((e) => e.toJson()).toList(),
      if (quizzes != null) 'quizzes': quizzes!.map((e) => e.toJson()).toList(),
      if (manualBooks != null)
        'manual_books': manualBooks!.map((e) => e.toJson()).toList(),
      if (quizAnswers != null)
        'quiz_answers': quizAnswers!.map((e) => e.toJson()).toList(),
    };
  }
}
