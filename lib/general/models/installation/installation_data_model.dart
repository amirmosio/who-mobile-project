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
      sections: (json['sections'] as List<dynamic>).map((i) {
        try {
          return InstallationStepModel.fromJson(i as Map<String, dynamic>);
        } catch (e) {
          var a = InstallationStepModel.fromJson(i as Map<String, dynamic>);
          rethrow;
        }
      }).toList(),
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
