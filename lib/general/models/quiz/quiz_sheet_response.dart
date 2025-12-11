import 'package:who_mobile_project/general/constants/quiz_constants.dart';

/// Quiz Sheet Response Model
/// Response from backend after submitting a sheet
class QuizSheetResponse {
  final int id;
  final String? groupCode;
  final String? createdDatetime;
  final String? modifiedDatetime;
  final double duration;
  final String? endDatetime;
  final String? expirationDatetime;
  final bool hasAnswer;
  final bool isExecuted;
  final bool isPassed;
  final bool hasIncrementedCount;
  final int maxNumberError;
  final int numberCorrectQuestion;
  final int numberErrorQuestion;
  final int numberEmptyQuestion;
  final int numberQuestion;
  final List<List<int>> quizzes;
  final String? startDatetime;
  final int executionTime;
  final int type;
  final int? student;
  final int? teacher;
  final int licenseTypeId;

  const QuizSheetResponse({
    required this.id,
    this.groupCode,
    this.createdDatetime,
    this.modifiedDatetime,
    required this.duration,
    this.endDatetime,
    this.expirationDatetime,
    required this.hasAnswer,
    required this.isExecuted,
    required this.isPassed,
    required this.hasIncrementedCount,
    required this.maxNumberError,
    required this.numberCorrectQuestion,
    required this.numberErrorQuestion,
    required this.numberEmptyQuestion,
    required this.numberQuestion,
    required this.quizzes,
    this.startDatetime,
    required this.executionTime,
    required this.type,
    this.student,
    this.teacher,
    required this.licenseTypeId,
  });

  factory QuizSheetResponse.fromJson(Map<String, dynamic> json) {
    return QuizSheetResponse(
      id: json['id'] as int,
      groupCode: json['group_code'] as String?,
      createdDatetime: json['created_datetime'] as String?,
      modifiedDatetime: json['modified_datetime'] as String?,
      duration: (json['duration'] as num).toDouble(),
      endDatetime: json['end_datetime'] as String?,
      expirationDatetime: json['expiration_datetime'] as String?,
      hasAnswer: json['has_answer'] as bool? ?? false,
      isExecuted: json['is_executed'] as bool? ?? false,
      isPassed: json['is_passed'] as bool? ?? false,
      hasIncrementedCount: json['has_incremented_count'] as bool? ?? false,
      maxNumberError: json['max_number_error'] as int? ?? 0,
      numberCorrectQuestion: json['number_correct_question'] as int? ?? 0,
      numberErrorQuestion: json['number_error_question'] as int? ?? 0,
      numberEmptyQuestion: json['number_empty_question'] as int? ?? 0,
      numberQuestion: json['number_question'] as int? ?? 0,
      quizzes:
          (json['quizzes'] as List<dynamic>?)
              ?.map((e) => (e as List<dynamic>).map((i) => i as int).toList())
              .toList() ??
          [],
      startDatetime: json['start_datetime'] as String?,
      executionTime: json['execution_time'] as int? ?? 0,
      type: json['type'] as int? ?? 0,
      student: (json['student'] is int?)
          ? (json['student'] as int?)
          : (json['student'] as Map?)?["id"],
      teacher: (json['teacher'] is int?)
          ? (json['teacher'] as int?)
          : (json['teacher'] as Map?)?["id"],
      licenseTypeId: (json['license_type'] is int)
          ? (json['license_type'] as int)
          : (json['license_type'] as Map)["id"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (groupCode != null) 'group_code': groupCode,
      if (createdDatetime != null) 'created_datetime': createdDatetime,
      if (modifiedDatetime != null) 'modified_datetime': modifiedDatetime,
      'duration': duration,
      if (endDatetime != null) 'end_datetime': endDatetime,
      if (expirationDatetime != null) 'expiration_datetime': expirationDatetime,
      'has_answer': hasAnswer,
      'is_executed': isExecuted,
      'is_passed': isPassed,
      'has_incremented_count': hasIncrementedCount,
      'max_number_error': maxNumberError,
      'number_correct_question': numberCorrectQuestion,
      'number_error_question': numberErrorQuestion,
      'number_empty_question': numberEmptyQuestion,
      'number_question': numberQuestion,
      'quizzes': quizzes,
      if (startDatetime != null) 'start_datetime': startDatetime,
      'execution_time': executionTime,
      'type': type,
      if (student != null) 'student': student,
      if (teacher != null) 'teacher': teacher,
      'license_type': licenseTypeId,
    };
  }

  /// Helper method to check if this is a teacher sheet
  bool get isTeacherSheet {
    return SheetType.isTeacherSheet(type, teacher);
  }

  /// Helper method to check if this sheet is expired
  bool get isExpired {
    if (expirationDatetime == null || isExecuted) return false;
    final expirationDate = DateTime.parse(expirationDatetime!);
    return DateTime.now().isAfter(expirationDate);
  }

  /// Helper method to check if this is a pending teacher assignment
  bool get isPendingTeacherSheet {
    return isTeacherSheet && !isExecuted && !isExpired;
  }

  /// Get display name for sheet type
  String get typeDisplayName {
    return SheetType.getDisplayName(type);
  }
}
