import 'maintenance_step_model.dart';

class MaintenanceDataModel {
  final String title;
  final String overview;
  final String sourceDocument;
  final List<MaintenanceStepModel> sections;

  MaintenanceDataModel({
    required this.title,
    required this.overview,
    required this.sourceDocument,
    required this.sections,
  });

  factory MaintenanceDataModel.fromJson(Map<String, dynamic> json) {
    return MaintenanceDataModel(
      title: json['title'] as String,
      overview: json['overview'] as String,
      sourceDocument: json['sourceDocument'] as String,
      sections: (json['sections'] as List<dynamic>)
          .map((e) => MaintenanceStepModel.fromJson(e as Map<String, dynamic>))
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
