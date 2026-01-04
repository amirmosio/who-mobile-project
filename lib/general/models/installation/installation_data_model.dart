import 'installation_step_model.dart';

class InstallationDataModel {
  final String title;
  final String overview;
  final String sourceDocument;
  final List<InstallationStepModel> sections;

  InstallationDataModel({
    required this.title,
    required this.overview,
    required this.sourceDocument,
    required this.sections,
  });

  factory InstallationDataModel.fromJson(Map<String, dynamic> json) {
    return InstallationDataModel(
      title: json['title'] as String,
      overview: json['overview'] as String,
      sourceDocument: json['sourceDocument'] as String,
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
      'sections': sections.map((e) => e.toJson()).toList(),
    };
  }
}
