import 'package:json_annotation/json_annotation.dart';
import 'package:who_mobile_project/general/models/user/teacher_model.dart';

part 'online_lesson_model.g.dart';

@JsonSerializable()
class OnlineLesson {
  final int? id;
  final TeacherModel? user;
  @JsonKey(name: 'online_lesson_argument')
  final OnlineLessonArgument? onlineLessonArgument;
  final String? description;
  @JsonKey(name: 'start_datetime')
  final String? startDatetime;
  @JsonKey(name: 'end_datetime')
  final String? endDatetime;
  final String? code;
  @JsonKey(name: 'referral_code')
  final String? referralCode;
  @JsonKey(name: 'is_active')
  final bool? isActive;
  @JsonKey(name: 'is_detailed')
  final bool? isDetailed;
  @JsonKey(name: 'is_booked')
  final bool? isBooked;

  const OnlineLesson({
    this.id,
    this.user,
    this.onlineLessonArgument,
    this.description,
    this.startDatetime,
    this.endDatetime,
    this.code,
    this.referralCode,
    this.isActive,
    this.isDetailed,
    this.isBooked,
  });

  factory OnlineLesson.fromJson(Map<String, dynamic> json) =>
      _$OnlineLessonFromJson(json);

  Map<String, dynamic> toJson() => _$OnlineLessonToJson(this);
}

@JsonSerializable()
class OnlineLessonArgument {
  final int id;
  final String name;
  @JsonKey(name: 'video_count')
  final int? videoCount;

  const OnlineLessonArgument({
    required this.id,
    required this.name,
    this.videoCount,
  });

  factory OnlineLessonArgument.fromJson(Map<String, dynamic> json) =>
      _$OnlineLessonArgumentFromJson(json);

  Map<String, dynamic> toJson() => _$OnlineLessonArgumentToJson(this);
}

@JsonSerializable(explicitToJson: true)
class OnlineLessonVideo {
  final int id;
  final String title;
  final TeacherModel? user;
  final String? url;
  final int? position;
  final String? summary;
  final String? faq;
  final String? mindmap;
  @JsonKey(name: 'lesson_datetime')
  final String? lessonDatetime;
  @JsonKey(name: 'is_active')
  final bool? isActive;

  const OnlineLessonVideo({
    required this.id,
    required this.title,
    this.user,
    this.url,
    this.position,
    this.summary,
    this.faq,
    this.mindmap,
    this.lessonDatetime,
    this.isActive,
  });

  factory OnlineLessonVideo.fromJson(Map<String, dynamic> json) =>
      _$OnlineLessonVideoFromJson(json);

  Map<String, dynamic> toJson() => _$OnlineLessonVideoToJson(this);
}

@JsonSerializable()
class UserOnlineLesson {
  final int? id;
  @JsonKey(name: 'online_lesson')
  final OnlineLesson? onlineLesson;
  @JsonKey(name: 'created_datetime')
  final String? createdDatetime;
  @JsonKey(name: 'attendance_datetime')
  final String? attendanceDatetime;
  final int? user;

  const UserOnlineLesson({
    this.id,
    this.onlineLesson,
    this.createdDatetime,
    this.attendanceDatetime,
    this.user,
  });

  factory UserOnlineLesson.fromJson(Map<String, dynamic> json) =>
      _$UserOnlineLessonFromJson(json);

  Map<String, dynamic> toJson() => _$UserOnlineLessonToJson(this);
}

@JsonSerializable()
class UserOnlineLessonVideo {
  final int? id;
  final int? user;
  @JsonKey(name: 'online_lesson_video')
  final int? onlineLessonVideo;
  @JsonKey(name: 'viewed_datetime')
  final String? viewedDatetime;

  const UserOnlineLessonVideo({
    this.id,
    this.user,
    this.onlineLessonVideo,
    this.viewedDatetime,
  });

  factory UserOnlineLessonVideo.fromJson(Map<String, dynamic> json) =>
      _$UserOnlineLessonVideoFromJson(json);

  Map<String, dynamic> toJson() => _$UserOnlineLessonVideoToJson(this);
}
