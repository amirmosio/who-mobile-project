import 'installation_image_model.dart';

class InstallationRequirementModel {
  final String id;
  final String title;
  final List<String> content;
  final List<InstallationImageModel>? images;

  InstallationRequirementModel({
    required this.id,
    required this.title,
    required this.content,
    this.images,
  });

  factory InstallationRequirementModel.fromJson(Map<String, dynamic> json) {
    return InstallationRequirementModel(
      id: json['id'] as String,
      title: json['title'] as String,
      content: (json['content'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      images: (json['images'] as List<dynamic>?)
          ?.map((e) => InstallationImageModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      if (images != null) 'images': images!.map((e) => e.toJson()).toList(),
    };
  }
}
