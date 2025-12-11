import 'package:json_annotation/json_annotation.dart';

part 'book_online_lesson_request.g.dart';

/// Request model for booking an online lesson
/// Matches the API specification for POST /user-online-lessons/
@JsonSerializable()
class BookOnlineLessonRequest {
  /// User ID who is booking the lesson
  final int user;

  /// Online lesson ID to book
  @JsonKey(name: 'online_lesson')
  final int onlineLesson;

  /// Timestamp when the user registered for this lesson
  @JsonKey(name: 'attendance_datetime')
  final String attendanceDatetime;

  const BookOnlineLessonRequest({
    required this.user,
    required this.onlineLesson,
    required this.attendanceDatetime,
  });

  factory BookOnlineLessonRequest.fromJson(Map<String, dynamic> json) =>
      _$BookOnlineLessonRequestFromJson(json);

  Map<String, dynamic> toJson() => _$BookOnlineLessonRequestToJson(this);
}
