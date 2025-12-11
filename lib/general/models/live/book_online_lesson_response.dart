import 'package:json_annotation/json_annotation.dart';

part 'book_online_lesson_response.g.dart';

/// Response model for booking an online lesson
/// Returned from POST /user-online-lessons/
/// This is the simplified response with IDs instead of nested objects
@JsonSerializable()
class BookOnlineLessonResponse {
  /// Booking ID
  final int id;

  /// User ID who booked the lesson
  final int user;

  /// Online lesson ID that was booked
  @JsonKey(name: 'online_lesson')
  final int onlineLesson;

  /// When the booking was created
  @JsonKey(name: 'created_datetime')
  final String createdDatetime;

  /// When the user registered for attendance
  @JsonKey(name: 'attendance_datetime')
  final String attendanceDatetime;

  const BookOnlineLessonResponse({
    required this.id,
    required this.user,
    required this.onlineLesson,
    required this.createdDatetime,
    required this.attendanceDatetime,
  });

  factory BookOnlineLessonResponse.fromJson(Map<String, dynamic> json) =>
      _$BookOnlineLessonResponseFromJson(json);

  Map<String, dynamic> toJson() => _$BookOnlineLessonResponseToJson(this);
}
