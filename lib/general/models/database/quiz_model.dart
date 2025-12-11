/// Quiz (Question) model from API
/// Maps to Quizzes table in local database
class QuizModel {
  final int id;
  final int appId;
  final String? comment;
  final String createdDatetime;
  final bool? hasAnswer;
  final bool? isActive;
  final String modifiedDatetime;
  final String? originalId;
  final int? position;
  final int? numberExtracted;
  final bool result;
  final String? symbol;
  final String? questionText;
  final int? argumentId;
  final int? licenseTypeId;
  final int? manualId;
  final dynamic image;

  QuizModel({
    required this.id,
    required this.appId,
    this.comment,
    required this.createdDatetime,
    this.hasAnswer,
    this.isActive,
    required this.modifiedDatetime,
    this.originalId,
    this.position,
    this.numberExtracted,
    required this.result,
    this.symbol,
    this.questionText,
    this.argumentId,
    this.licenseTypeId,
    this.manualId,
    this.image,
  });

  factory QuizModel.fromJson(Map<String, dynamic> json) {
    return QuizModel(
      id: json['id'] as int,
      appId: json['app_id'] as int? ?? 0,
      comment: json['comment'] as String?,
      createdDatetime: json['created_datetime'] as String,
      hasAnswer: json['has_answer'] as bool?,
      isActive: json['is_active'] as bool?,
      modifiedDatetime: json['modified_datetime'] as String,
      originalId: json['original_id'] as String?,
      position: json['position'] as int?,
      numberExtracted: json['number_extracted'] as int?,
      result: json['result'] as bool,
      symbol: json['symbol'] as String?,
      questionText: json['text'] as String?,
      argumentId: json['argument'] as int?,
      licenseTypeId: json['license_type'] as int?,
      manualId: json['manual'] as int?,
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'app_id': appId,
      if (comment != null) 'comment': comment,
      'created_datetime': createdDatetime,
      if (hasAnswer != null) 'has_answer': hasAnswer,
      if (isActive != null) 'is_active': isActive,
      'modified_datetime': modifiedDatetime,
      if (originalId != null) 'original_id': originalId,
      if (position != null) 'position': position,
      if (numberExtracted != null) 'number_extracted': numberExtracted,
      'result': result,
      if (symbol != null) 'symbol': symbol,
      if (questionText != null) 'text': questionText,
      if (argumentId != null) 'argument': argumentId,
      if (licenseTypeId != null) 'license_type': licenseTypeId,
      if (manualId != null) 'manual': manualId,
      if (image != null) 'image': image,
    };
  }
}
