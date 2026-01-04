class DismantlingImageModel {
  final String filename;
  final String description;

  DismantlingImageModel({
    required this.filename,
    required this.description,
  });

  factory DismantlingImageModel.fromJson(Map<String, dynamic> json) {
    return DismantlingImageModel(
      filename: json['filename'] as String,
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'filename': filename,
      'description': description,
    };
  }
}
