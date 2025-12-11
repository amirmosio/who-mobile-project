/// Manual Image model from manual detail API response
class ManualImage {
  final int id;
  final String image;
  final String? imageHd;
  final double? aspectRatio;
  final String? symbol;
  final int? user;

  ManualImage({
    required this.id,
    required this.image,
    this.imageHd,
    this.aspectRatio,
    this.symbol,
    this.user,
  });

  factory ManualImage.fromJson(Map<String, dynamic> json) {
    return ManualImage(
      id: json['id'] as int,
      image: json['image'] as String,
      imageHd: json['image_hd'] as String?,
      aspectRatio: (json['aspect_ratio'] as num?)?.toDouble(),
      symbol: json['symbol'] as String?,
      user: json['user'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': image,
      if (imageHd != null) 'image_hd': imageHd,
      if (aspectRatio != null) 'aspect_ratio': aspectRatio,
      if (symbol != null) 'symbol': symbol,
      if (user != null) 'user': user,
    };
  }
}

/// Manual Video model from manual detail API response
class ManualVideo {
  final int id;
  final int? argumentId; // Only store the ID, not the full object
  final String? url;
  final String? youtubeUrl;
  final String? title;
  final String? description;
  final String? thumb;
  final int position;
  final int? promotedState;
  final String? buttonUrl;
  final String? buttonTitle;
  final String? transcription;
  final String? transcriptionStatus;
  final String? transcriptionError;
  final bool? isNew;
  final bool isActive;
  final int? drivingSchool;
  final int? licenseType;

  ManualVideo({
    required this.id,
    this.argumentId,
    this.url,
    this.youtubeUrl,
    this.title,
    this.description,
    this.thumb,
    required this.position,
    this.promotedState,
    this.buttonUrl,
    this.buttonTitle,
    this.transcription,
    this.transcriptionStatus,
    this.transcriptionError,
    this.isNew,
    required this.isActive,
    this.drivingSchool,
    this.licenseType,
  });

  factory ManualVideo.fromJson(Map<String, dynamic> json) {
    // Extract argument ID if argument object exists
    int? argumentId;
    if (json['argument'] != null) {
      if (json['argument'] is Map) {
        argumentId = json['argument']['id'] as int?;
      } else if (json['argument'] is int) {
        argumentId = json['argument'] as int;
      }
    }

    return ManualVideo(
      id: json['id'] as int,
      argumentId: argumentId,
      url: json['url'] as String?,
      youtubeUrl: json['youtube_url'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      thumb: json['thumb'] as String?,
      position: json['position'] as int,
      promotedState: json['promoted_state'] as int?,
      buttonUrl: json['button_url'] as String?,
      buttonTitle: json['button_title'] as String?,
      transcription: json['transcription'] as String?,
      transcriptionStatus: json['transcription_status'] as String?,
      transcriptionError: json['transcription_error'] as String?,
      isNew: json['is_new'] as bool?,
      isActive: json['is_active'] as bool,
      drivingSchool: json['driving_school'] as int?,
      licenseType: json['license_type'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (argumentId != null) 'argument': argumentId,
      if (url != null) 'url': url,
      if (youtubeUrl != null) 'youtube_url': youtubeUrl,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (thumb != null) 'thumb': thumb,
      'position': position,
      if (promotedState != null) 'promoted_state': promotedState,
      if (buttonUrl != null) 'button_url': buttonUrl,
      if (buttonTitle != null) 'button_title': buttonTitle,
      if (transcription != null) 'transcription': transcription,
      if (transcriptionStatus != null)
        'transcription_status': transcriptionStatus,
      if (transcriptionError != null) 'transcription_error': transcriptionError,
      if (isNew != null) 'is_new': isNew,
      'is_active': isActive,
      if (drivingSchool != null) 'driving_school': drivingSchool,
      if (licenseType != null) 'license_type': licenseType,
    };
  }
}

/// Manual Detail model from GET /manuals/{id}/ API
/// Used for fetching manual details with translation support via Accept-Language header
class ManualDetail {
  final int id;
  final int appId;
  final String title;
  final String text;
  final String? symbol;
  final String? note;
  final String? alt;
  final String? url;
  final String createdDatetime;
  final String modifiedDatetime;
  final int position;
  final int? videoOriginalId;
  final String? summary;
  final String? summaryStatus;
  final String? summaryError;
  final bool isActive;
  final int licenseType;
  final int argument;
  final ManualImage? image;
  final ManualVideo? video;

  ManualDetail({
    required this.id,
    required this.appId,
    required this.title,
    required this.text,
    this.symbol,
    this.note,
    this.alt,
    this.url,
    required this.createdDatetime,
    required this.modifiedDatetime,
    required this.position,
    this.videoOriginalId,
    this.summary,
    this.summaryStatus,
    this.summaryError,
    required this.isActive,
    required this.licenseType,
    required this.argument,
    this.image,
    this.video,
  });

  factory ManualDetail.fromJson(Map<String, dynamic> json) {
    return ManualDetail(
      id: json['id'] as int,
      appId: json['app_id'] as int,
      title: json['title'] as String,
      text: json['text'] as String,
      symbol: json['symbol'] as String?,
      note: json['note'] as String?,
      alt: json['alt'] as String?,
      url: json['url'] as String?,
      createdDatetime: json['created_datetime'] as String,
      modifiedDatetime: json['modified_datetime'] as String,
      position: json['position'] as int,
      videoOriginalId: json['video_original_id'] as int?,
      summary: json['summary'] as String?,
      summaryStatus: json['summary_status'] as String?,
      summaryError: json['summary_error'] as String?,
      isActive: json['is_active'] as bool,
      licenseType: json['license_type'] as int,
      argument: json['argument'] as int,
      image: json['image'] != null
          ? ManualImage.fromJson(json['image'] as Map<String, dynamic>)
          : null,
      video: json['video'] != null
          ? ManualVideo.fromJson(json['video'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'app_id': appId,
      'title': title,
      'text': text,
      if (symbol != null) 'symbol': symbol,
      if (note != null) 'note': note,
      if (alt != null) 'alt': alt,
      if (url != null) 'url': url,
      'created_datetime': createdDatetime,
      'modified_datetime': modifiedDatetime,
      'position': position,
      if (videoOriginalId != null) 'video_original_id': videoOriginalId,
      if (summary != null) 'summary': summary,
      if (summaryStatus != null) 'summary_status': summaryStatus,
      if (summaryError != null) 'summary_error': summaryError,
      'is_active': isActive,
      'license_type': licenseType,
      'argument': argument,
      if (image != null) 'image': image!.toJson(),
      if (video != null) 'video': video!.toJson(),
    };
  }
}
