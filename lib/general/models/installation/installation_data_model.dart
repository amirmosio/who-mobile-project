import 'installation_image_model.dart';
import 'installation_step_model.dart';

class InstallationDataModel {
  final String title;
  final String overview;
  final String sourceDocument;
  final int totalImages;
  final int imagePages;
  final List<InstallationImageModel> coverImages;
  final List<InstallationImageModel> overviewImages;
  final List<InstallationStepModel> sections;

  InstallationDataModel({
    required this.title,
    required this.overview,
    required this.sourceDocument,
    required this.totalImages,
    required this.imagePages,
    required this.coverImages,
    required this.overviewImages,
    required this.sections,
  });

  factory InstallationDataModel.fromJson(Map<String, dynamic> json) {
    return InstallationDataModel(
      title: json['title'] as String,
      overview: json['overview'] as String,
      sourceDocument: json['sourceDocument'] as String,
      totalImages: json['totalImages'] as int,
      imagePages: json['imagePages'] as int,
      coverImages: (json['coverImages'] as List<dynamic>)
          .map((e) => InstallationImageModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      overviewImages: (json['overviewImages'] as List<dynamic>)
          .map((e) => InstallationImageModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      sections: (json['sections'] as List<dynamic>)
          .map((e) => InstallationStepModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'overview': overview,
      'sourceDocument': sourceDocument,
      'totalImages': totalImages,
      'imagePages': imagePages,
      'coverImages': coverImages.map((e) => e.toJson()).toList(),
      'overviewImages': overviewImages.map((e) => e.toJson()).toList(),
      'sections': sections.map((e) => e.toJson()).toList(),
    };
  }
}
