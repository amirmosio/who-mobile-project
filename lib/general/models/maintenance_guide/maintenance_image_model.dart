class MaintenanceImageModel {
  final String filename;
  final String? description;

  MaintenanceImageModel({
    required this.filename,
    this.description,
  });

  factory MaintenanceImageModel.fromJson(Map<String, dynamic> json) {
    return MaintenanceImageModel(
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
