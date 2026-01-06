import 'facility_use_step_model.dart';

class FacilityUseDataModel {
  final String title;
  final String overview;
  final String sourceDocument;
  final List<FacilityUseStepModel> sections;

  FacilityUseDataModel({
    required this.title,
    required this.overview,
    required this.sourceDocument,
    required this.sections,
  });

  factory FacilityUseDataModel.fromJson(Map<String, dynamic> json) {
    return FacilityUseDataModel(
      title: json['title'] as String,
      overview: json['overview'] as String,
      sourceDocument: json['sourceDocument'] as String,
      sections: (json['sections'] as List<dynamic>)
          .map((e) => FacilityUseStepModel.fromJson(e as Map<String, dynamic>))
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
