import 'installation_image_model.dart';

class InstallationSubstepModel {
  final String id;
  final String title;
  final List<String> content;
  final List<InstallationImageModel>? images;
  final List<String>? actions;
  final List<String>? warnings;
  final String? purpose;
  final String? pdfStepReference;
  final Map<String, dynamic>? additionalData;

  InstallationSubstepModel({
    required this.id,
    required this.title,
    required this.content,
    this.images,
    this.actions,
    this.warnings,
    this.purpose,
    this.pdfStepReference,
    this.additionalData,
  });

  factory InstallationSubstepModel.fromJson(Map<String, dynamic> json) {
    return InstallationSubstepModel(
      id: json['id'] as String,
      title: json['title'] as String,
      content: (json['content'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      images: (json['images'] as List<dynamic>?)
          ?.map((e) => InstallationImageModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      actions: (json['actions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      warnings: (json['warnings'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      purpose: json['purpose'] as String?,
      pdfStepReference: json['pdfStepReference'] as String?,
      additionalData: json,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      if (images != null) 'images': images!.map((e) => e.toJson()).toList(),
      if (actions != null) 'actions': actions,
      if (warnings != null) 'warnings': warnings,
      if (purpose != null) 'purpose': purpose,
      if (pdfStepReference != null) 'pdfStepReference': pdfStepReference,
    };
  }
}
