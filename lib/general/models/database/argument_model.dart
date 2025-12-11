import 'package:who_mobile_project/general/models/database/picture_quiz_model.dart';

class ArgumentModel {
  final int id;
  final String createdDatetime;
  final bool? isVideo;
  final bool? isActive;
  final String modifiedDatetime;
  final String? name;
  final int? position;
  final int? numberQuestion;
  final int? numberQuizzes;
  final int? licenseTypeId;

  /// Nested PictureQuiz object from API (not just the ID)
  final PictureQuizModel? thumb;

  ArgumentModel({
    required this.id,
    required this.createdDatetime,
    this.isVideo,
    this.isActive,
    required this.modifiedDatetime,
    this.name,
    this.position,
    this.numberQuestion,
    this.numberQuizzes,
    this.licenseTypeId,
    this.thumb,
  });

  factory ArgumentModel.fromJson(Map<String, dynamic> json) {
    return ArgumentModel(
      id: json['id'] as int,
      createdDatetime: json['created_datetime'] as String,
      isVideo: json['is_video'] as bool?,
      isActive: json['is_active'] as bool?,
      modifiedDatetime: json['modified_datetime'] as String,
      name: json['name'] as String?,
      position: json['position'] as int?,
      numberQuestion: json['number_question'] as int?,
      numberQuizzes: json['number_quizzes'] as int?,
      licenseTypeId: json['license_type'] as int?,
      // Parse nested thumb object (not just ID)
      thumb: json['thumb'] != null
          ? PictureQuizModel.fromJson(json['thumb'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_datetime': createdDatetime,
      if (isVideo != null) 'is_video': isVideo,
      if (isActive != null) 'is_active': isActive,
      'modified_datetime': modifiedDatetime,
      if (name != null) 'name': name,
      if (position != null) 'position': position,
      if (numberQuestion != null) 'number_question': numberQuestion,
      if (numberQuizzes != null) 'number_quizzes': numberQuizzes,
      if (licenseTypeId != null) 'license_type': licenseTypeId,
      if (thumb != null) 'thumb': thumb!.toJson(),
    };
  }

  /// Get thumb ID for database storage
  int? get thumbId => thumb?.id;
}
