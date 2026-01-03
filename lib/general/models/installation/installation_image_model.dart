class InstallationImageModel {
  final String filename;
  final String? description;

  InstallationImageModel({
    required this.filename,
    this.description,
  });

  factory InstallationImageModel.fromJson(Map<String, dynamic> json) {
    return InstallationImageModel(
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
