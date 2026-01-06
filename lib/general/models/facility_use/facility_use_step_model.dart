import 'facility_use_image_model.dart';
import 'facility_use_requirement_model.dart';
import 'facility_use_substep_model.dart';

class FacilityUseStepModel {
  final String id;
  final String title;
  final String? description;
  final String? pdfReference;
  final List<FacilityUseImageModel>? images;
  final List<FacilityUseRequirementModel>? requirements;
  final List<FacilityUseSubstepModel>? steps;

  FacilityUseStepModel({
    required this.id,
    required this.title,
    this.description,
    this.pdfReference,
    this.images,
    this.requirements,
    this.steps,
  });

  factory FacilityUseStepModel.fromJson(Map<String, dynamic> json) {
    final requirementsJson = json['requirements'] as List<dynamic>?;
    final stepsJson = json['steps'] as List<dynamic>?;

    List<FacilityUseRequirementModel>? requirements;
    List<FacilityUseSubstepModel>? steps;

    if (requirementsJson != null) {
      requirements = requirementsJson
          .map(
            (e) => FacilityUseRequirementModel.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList();
    }

    if (stepsJson != null) {
      steps = stepsJson
          .map(
            (e) => FacilityUseSubstepModel.fromJson(e as Map<String, dynamic>),
          )
          .toList();
    }

    return FacilityUseStepModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      pdfReference: json['pdfReference'] as String?,
      images: (json['images'] as List<dynamic>?)
          ?.map(
            (e) => FacilityUseImageModel.fromJson(e as Map<String, dynamic>),
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
