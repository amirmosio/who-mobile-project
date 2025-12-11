import 'package:json_annotation/json_annotation.dart';

part 'mark_video_viewed_request.g.dart';

@JsonSerializable()
class MarkVideoViewedRequest {
  final int user;
  @JsonKey(name: 'online_lesson_video')
  final int onlineLessonVideo;

  const MarkVideoViewedRequest({
    required this.user,
    required this.onlineLessonVideo,
  });

  factory MarkVideoViewedRequest.fromJson(Map<String, dynamic> json) =>
      _$MarkVideoViewedRequestFromJson(json);

  Map<String, dynamic> toJson() => _$MarkVideoViewedRequestToJson(this);
}
