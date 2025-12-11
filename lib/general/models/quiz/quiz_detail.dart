/// Image detail model from quiz detail API response
class ImageDetail {
  final int id;
  final String? image;
  final String? imageHd;
  final double? aspectRatio;
  final String? symbol;
  final int? userId;

  ImageDetail({
    required this.id,
    this.image,
    this.imageHd,
    this.aspectRatio,
    this.symbol,
    this.userId,
  });

  factory ImageDetail.fromJson(Map<String, dynamic> json) {
    return ImageDetail(
      id: json['id'] as int,
      image: json['image'] as String?,
      imageHd: json['image_hd'] as String?,
      aspectRatio: (json['aspect_ratio'] as num?)?.toDouble(),
      symbol: json['symbol'] as String?,
      userId: json['user'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (image != null) 'image': image,
      if (imageHd != null) 'image_hd': imageHd,
      if (aspectRatio != null) 'aspect_ratio': aspectRatio,
      if (symbol != null) 'symbol': symbol,
      if (userId != null) 'user': userId,
    };
  }
}

/// Quiz answer detail model from quiz detail API response
class QuizAnswerDetail {
  final int id;
  final String? text;
  final int? position;
  final String createdDatetime;
  final String modifiedDatetime;
  final bool? isCorrect;
  final bool? isActive;
  final int? licenseType;
  final int? quiz;

  QuizAnswerDetail({
    required this.id,
    this.text,
    this.position,
    required this.createdDatetime,
    required this.modifiedDatetime,
    this.isCorrect,
    this.isActive,
    this.licenseType,
    this.quiz,
  });

  factory QuizAnswerDetail.fromJson(Map<String, dynamic> json) {
    return QuizAnswerDetail(
      id: json['id'] as int,
      text: json['text'] as String?,
      position: json['position'] as int?,
      createdDatetime: json['created_datetime'] as String,
      modifiedDatetime: json['modified_datetime'] as String,
      isCorrect: json['is_correct'] as bool?,
      isActive: json['is_active'] as bool?,
      licenseType: json['license_type'] as int?,
      quiz: json['quiz'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (text != null) 'text': text,
      if (position != null) 'position': position,
      'created_datetime': createdDatetime,
      'modified_datetime': modifiedDatetime,
      if (isCorrect != null) 'is_correct': isCorrect,
      if (isActive != null) 'is_active': isActive,
      if (licenseType != null) 'license_type': licenseType,
      if (quiz != null) 'quiz': quiz,
    };
  }
}

/// Quiz detail model from GET /quizzes/{id}/ API
/// Used for fetching quiz details with translation support via Accept-Language header
class QuizDetail {
  final int id;
  final ImageDetail? image;
  final List<QuizAnswerDetail> quizAnswerSet;
  final String? originalId;
  final int? appId;
  final String? text;
  final bool? result;
  final String? symbol;
  final int? position;
  final String? comment;
  final String createdDatetime;
  final String modifiedDatetime;
  final bool? isActive;
  final bool? hasAnswer;
  final int? manual;
  final int? licenseType;
  final int? argument;

  QuizDetail({
    required this.id,
    this.image,
    required this.quizAnswerSet,
    this.originalId,
    this.appId,
    this.text,
    this.result,
    this.symbol,
    this.position,
    this.comment,
    required this.createdDatetime,
    required this.modifiedDatetime,
    this.isActive,
    this.hasAnswer,
    this.manual,
    this.licenseType,
    this.argument,
  });

  factory QuizDetail.fromJson(Map<String, dynamic> json) {
    return QuizDetail(
      id: json['id'] as int,
      image: json['image'] != null
          ? ImageDetail.fromJson(json['image'] as Map<String, dynamic>)
          : null,
      quizAnswerSet:
          (json['quizanswer_set'] as List<dynamic>?)
              ?.map((e) => QuizAnswerDetail.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      originalId: json['original_id'] as String?,
      appId: json['app_id'] as int?,
      text: json['text'] as String?,
      result: json['result'] as bool?,
      symbol: json['symbol'] as String?,
      position: json['position'] as int?,
      comment: json['comment'] as String?,
      createdDatetime: json['created_datetime'] as String,
      modifiedDatetime: json['modified_datetime'] as String,
      isActive: json['is_active'] as bool?,
      hasAnswer: json['has_answer'] as bool?,
      manual: json['manual'] as int?,
      licenseType: json['license_type'] as int?,
      argument: json['argument'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (image != null) 'image': image!.toJson(),
      'quizanswer_set': quizAnswerSet.map((e) => e.toJson()).toList(),
      if (originalId != null) 'original_id': originalId,
      if (appId != null) 'app_id': appId,
      if (text != null) 'text': text,
      if (result != null) 'result': result,
      if (symbol != null) 'symbol': symbol,
      if (position != null) 'position': position,
      if (comment != null) 'comment': comment,
      'created_datetime': createdDatetime,
      'modified_datetime': modifiedDatetime,
      if (isActive != null) 'is_active': isActive,
      if (hasAnswer != null) 'has_answer': hasAnswer,
      if (manual != null) 'manual': manual,
      if (licenseType != null) 'license_type': licenseType,
      if (argument != null) 'argument': argument,
    };
  }
}
