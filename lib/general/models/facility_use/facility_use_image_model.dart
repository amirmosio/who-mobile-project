class FacilityUseImageModel {
  final String filename;
  final String? description;

  FacilityUseImageModel({
    required this.filename,
    this.description,
  });

  factory FacilityUseImageModel.fromJson(Map<String, dynamic> json) {
    return FacilityUseImageModel(
      filename: json['filename'] as String,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'filename': filename,
      if (description != null) 'description': description,
    };
  }
}
