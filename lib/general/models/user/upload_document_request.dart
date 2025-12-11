class UploadDocumentRequest {
  final int type;
  final String frontPic;
  final String? backPic;
  final bool? sameResidenceAsIdCard;
  final bool? isItalianCitizen;
  final bool? hasPathology;
  final String? note;

  const UploadDocumentRequest({
    required this.type,
    required this.frontPic,
    this.backPic,
    this.sameResidenceAsIdCard,
    this.isItalianCitizen,
    this.hasPathology,
    this.note,
  });

  factory UploadDocumentRequest.fromJson(Map<String, dynamic> json) {
    return UploadDocumentRequest(
      type: json['type'] as int,
      frontPic: json['front_pic'] as String,
      backPic: json['back_pic'] as String?,
      sameResidenceAsIdCard: json['same_residence_as_id_card'] as bool?,
      isItalianCitizen: json['is_italian_citizen'] as bool?,
      hasPathology: json['has_pathology'] as bool?,
      note: json['note'] as String?,
    );
  }

  /// Custom toJson that mimics neith app behavior:
  /// - Omits fields when they are null
  /// - Only sends is_italian_citizen when it's true (not false or null)
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{'type': type, 'front_pic': frontPic};

    // Add optional fields only if they're not null
    if (backPic != null) json['back_pic'] = backPic;
    if (sameResidenceAsIdCard != null) {
      json['same_residence_as_id_card'] = sameResidenceAsIdCard;
    }
    // Only send is_italian_citizen when it's true (mirrors neith app behavior)
    if (isItalianCitizen == true) {
      json['is_italian_citizen'] = isItalianCitizen;
    }
    if (hasPathology != null) json['has_pathology'] = hasPathology;
    if (note != null) json['note'] = note;

    return json;
  }
}
