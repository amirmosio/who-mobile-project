import 'dismantling_step_model.dart';

class DismantlingDataModel {
  final String title;
  final String overview;
  final String sourceDocument;
  final String? pdfReference;
  final int totalImages;
  final int imagePages;
  final String? requiredPersonnel;
  final String? estimatedTime;
  final List<DismantlingStepModel> sections;

  DismantlingDataModel({
    required this.title,
    required this.overview,
    required this.sourceDocument,
    this.pdfReference,
    required this.totalImages,
    required this.imagePages,
    this.requiredPersonnel,
    this.estimatedTime,
    required this.sections,
  });

  factory DismantlingDataModel.fromJson(Map<String, dynamic> json) {
    return DismantlingDataModel(
      title: json['title'] as String,
      overview: json['overview'] as String,
      sourceDocument: json['sourceDocument'] as String,
      pdfReference: json['pdfReference'] as String?,
      totalImages: json['totalImages'] as int,
      imagePages: json['imagePages'] as int,
      requiredPersonnel: json['requiredPersonnel'] as String?,
      estimatedTime: json['estimatedTime'] as String?,
      sections: (json['sections'] as List<dynamic>)
          .map((e) => DismantlingStepModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'overview': overview,
      'sourceDocument': sourceDocument,
      if (pdfReference != null) 'pdfReference': pdfReference,
      'totalImages': totalImages,
      'imagePages': imagePages,
      if (requiredPersonnel != null) 'requiredPersonnel': requiredPersonnel,
      if (estimatedTime != null) 'estimatedTime': estimatedTime,
      'sections': sections.map((e) => e.toJson()).toList(),
    };
  }
}
