import 'package:who_mobile_project/general/constants/quiz_constants.dart';

/// Quiz Sheet Request Model
/// Used for submitting completed quiz sheets to the backend
class QuizSheetRequest {
  final double duration;
  final int maxNumberError;
  final bool isExecuted;
  final bool isPassed;
  final String endDatetime;
  final List<List<int>>
  quizzes; // [[quiz_id, user_answer, result, argument_id]]
  final int numberCorrectQuestion;
  final int numberErrorQuestion;
  final int numberEmptyQuestion;
  final int numberQuestion;
  final String startDatetime;
  final int licenseType;
  final int student;
  final bool hasIncrementedCount;
  final int type; // Sheet type
  final int os; // 2 for Flutter (3 for Flutter per iOS convention)
  final String version;
  final int executionTime; // in seconds
  final bool hasAnswer;
  final int? teacher; // Teacher ID for teacher-assigned sheets
  final String? groupCode; // Group code for teacher sheets
  final int? id; // Sheet ID for updates (PATCH requests)

  const QuizSheetRequest({
    required this.duration,
    required this.maxNumberError,
    required this.isExecuted,
    required this.isPassed,
    required this.endDatetime,
    required this.quizzes,
    required this.numberCorrectQuestion,
    required this.numberErrorQuestion,
    required this.numberEmptyQuestion,
    required this.numberQuestion,
    required this.startDatetime,
    required this.licenseType,
    required this.student,
    required this.hasIncrementedCount,
    required this.type,
    required this.os,
    required this.version,
    required this.executionTime,
    required this.hasAnswer,
    this.teacher,
    this.groupCode,
    this.id,
  });

  Map<String, dynamic> toJson() {
    final json = {
      'duration': duration,
      'max_number_error': maxNumberError,
      'is_executed': isExecuted,
      'is_passed': isPassed,
      'end_datetime': endDatetime,
      'quizzes': quizzes,
      'number_correct_question': numberCorrectQuestion,
      'number_error_question': numberErrorQuestion,
      'number_empty_question': numberEmptyQuestion,
      'number_question': numberQuestion,
      'start_datetime': startDatetime,
      'license_type': licenseType,
      'student': student,
      'has_incremented_count': hasIncrementedCount,
      'type': type,
      'os': os,
      'version': version,
      'execution_time': executionTime,
      'has_answer': hasAnswer,
    };

    // Add optional fields only if they're not null
    if (teacher != null) json['teacher'] = teacher!;
    if (groupCode != null) json['group_code'] = groupCode!;
    if (id != null) json['id'] = id!;

    return json;
  }

  factory QuizSheetRequest.fromJson(Map<String, dynamic> json) {
    return QuizSheetRequest(
      duration: (json['duration'] as num).toDouble(),
      maxNumberError: json['max_number_error'] as int,
      isExecuted: json['is_executed'] as bool,
      isPassed: json['is_passed'] as bool,
      endDatetime: json['end_datetime'] as String,
      quizzes: (json['quizzes'] as List<dynamic>)
          .map((e) => (e as List<dynamic>).map((i) => i as int).toList())
          .toList(),
      numberCorrectQuestion: json['number_correct_question'] as int,
      numberErrorQuestion: json['number_error_question'] as int,
      numberEmptyQuestion: json['number_empty_question'] as int,
      numberQuestion: json['number_question'] as int,
      startDatetime: json['start_datetime'] as String,
      licenseType: json['license_type'] as int,
      student: json['student'] as int,
      hasIncrementedCount: json['has_incremented_count'] as bool,
      type: json['type'] as int,
      os: json['os'] as int,
      version: json['version'] as String,
      executionTime: json['execution_time'] as int,
      hasAnswer: json['has_answer'] as bool,
      teacher: json['teacher'] as int?,
      groupCode: json['group_code'] as String?,
      id: json['id'] as int?,
    );
  }

  /// Helper method to check if this is a teacher sheet
  bool get isTeacherSheet {
    return SheetType.isTeacherSheet(type, teacher);
  }
}
