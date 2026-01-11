import 'dismantling_image_model.dart';

class DismantlingSubstepModel {
  final String id;
  final String title;
  final String purpose;
  final List<String> actions;
  final String? criticalWarning;
  final String? criticalNote;
  final List<DismantlingImageModel>? images;
  final String? pdfStepReference;

  DismantlingSubstepModel({
    required this.id,
    required this.title,
    required this.purpose,
    required this.actions,
    this.criticalWarning,
    this.criticalNote,
    this.images,
    this.pdfStepReference,
  });

  factory DismantlingSubstepModel.fromJson(Map<String, dynamic> json) {
    return DismantlingSubstepModel(
      id: json['id'] as String,
      title: json['title'] as String,
      purpose: json['purpose'] as String,
      actions: (json['actions'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      criticalWarning: json['criticalWarning'] as String?,
      criticalNote: json['criticalNote'] as String?,
      images: (json['images'] as List<dynamic>?)
          ?.map(
            (e) => DismantlingImageModel.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      pdfStepReference: json['pdfStepReference'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'purpose': purpose,
      'actions': actions,
      if (criticalWarning != null) 'criticalWarning': criticalWarning,
      if (criticalNote != null) 'criticalNote': criticalNote,
      if (images != null) 'images': images!.map((e) => e.toJson()).toList(),
      if (pdfStepReference != null) 'pdfStepReference': pdfStepReference,
    };
  }
}
