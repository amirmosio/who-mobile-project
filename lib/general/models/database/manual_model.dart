import 'manual_video_model.dart';
import 'picture_quiz_model.dart';

/// Manual (Theory content) model from API
/// Maps to Manuals table in local database
class ManualModel {
  final int id;
  final String? alt;
  final String createdDatetime;
  final bool? isActive;
  final String modifiedDatetime;
  final String? note;
  final int? position;
  final String? symbol;
  final String? content;
  final String? title;
  final String? url;
  final String? summary;
  final int? argumentId;
  final int? licenseTypeId;
  final PictureQuizModel? image;
  final ManualVideoModel? video;
  final int? fokArgumentId;

  // Additional fields from API response
  final int? appId;
  final int? videoOriginalId;

  ManualModel({
    required this.id,
    this.alt,
    required this.createdDatetime,
    this.isActive,
    required this.modifiedDatetime,
    this.note,
    this.position,
    this.symbol,
    this.content,
    this.title,
    this.url,
    this.summary,
    this.argumentId,
    this.licenseTypeId,
    this.image,
    this.video,
    this.fokArgumentId,
    this.appId,
    this.videoOriginalId,
  });

  factory ManualModel.fromJson(Map<String, dynamic> json) {
    return ManualModel(
      id: json['id'] as int,
      alt: json['alt'] as String?,
      createdDatetime: json['created_datetime'] as String,
      isActive: json['is_active'] as bool?,
      modifiedDatetime: json['modified_datetime'] as String,
      note: json['note'] as String?,
      position: json['position'] as int?,
      symbol: json['symbol'] as String?,
      content: json['text'] as String?,
      title: json['title'] as String?,
      url: json['url'] as String?,
      summary: json['summary'] as String?,
      argumentId: json['argument'] as int?,
      licenseTypeId: json['license_type'] as int?,
      image: json['image'] != null
          ? PictureQuizModel.fromJson(json['image'] as Map<String, dynamic>)
          : null,
      video: json['video'] != null
          ? ManualVideoModel.fromJson(json['video'] as Map<String, dynamic>)
          : null,
      fokArgumentId: json['_fok_argument'] as int?,
      appId: json['app_id'] as int?,
      videoOriginalId: json['video_original_id'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (alt != null) 'alt': alt,
      'created_datetime': createdDatetime,
      if (isActive != null) 'is_active': isActive,
      'modified_datetime': modifiedDatetime,
      if (note != null) 'note': note,
      if (position != null) 'position': position,
      if (symbol != null) 'symbol': symbol,
      if (content != null) 'text': content,
      if (title != null) 'title': title,
      if (url != null) 'url': url,
      if (summary != null) 'summary': summary,
      if (argumentId != null) 'argument': argumentId,
      if (licenseTypeId != null) 'license_type': licenseTypeId,
      if (image != null) 'image': image!.toJson(),
      if (video != null) 'video': video!.toJson(),
      if (fokArgumentId != null) '_fok_argument': fokArgumentId,
      if (appId != null) 'app_id': appId,
      if (videoOriginalId != null) 'video_original_id': videoOriginalId,
    };
  }

  /// Get video ID from the video model
  int? get videoId => video?.id;
}
