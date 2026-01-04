import 'installation_image_model.dart';
import 'installation_requirement_model.dart';
import 'installation_substep_model.dart';

class InstallationStepModel {
  final String id;
  final String title;
  final String? description;
  final String? pdfReference;
  final List<InstallationImageModel>? images;
  final List<InstallationRequirementModel>? requirements;
  final List<InstallationSubstepModel>? steps;

  InstallationStepModel({
    required this.id,
    required this.title,
    this.description,
    this.pdfReference,
    this.images,
    this.requirements,
    this.steps,
  });

  factory InstallationStepModel.fromJson(Map<String, dynamic> json) {
    final requirementsJson = json['requirements'] as List<dynamic>?;
    final stepsJson = json['steps'] as List<dynamic>?;

    List<InstallationRequirementModel>? requirements;
    List<InstallationSubstepModel>? steps;

    if (requirementsJson != null) {
      requirements = requirementsJson
          .map(
            (e) => InstallationRequirementModel.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList();
    }

    if (stepsJson != null) {
      steps = stepsJson
          .map(
            (e) => InstallationSubstepModel.fromJson(e as Map<String, dynamic>),
          )
          .toList();
    }

    return InstallationStepModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      pdfReference: json['pdfReference'] as String?,
      images: (json['images'] as List<dynamic>?)
          ?.map(
            (e) => InstallationImageModel.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      requirements: requirements,
      steps: steps,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      if (description != null) 'description': description,
      if (pdfReference != null) 'pdfReference': pdfReference,
      if (images != null) 'images': images!.map((e) => e.toJson()).toList(),
      if (requirements != null)
        'requirements': requirements!.map((e) => e.toJson()).toList(),
      if (steps != null) 'steps': steps!.map((e) => e.toJson()).toList(),
    };
  }
}
