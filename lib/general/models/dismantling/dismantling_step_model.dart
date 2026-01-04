import 'dismantling_image_model.dart';
import 'dismantling_requirement_model.dart';
import 'dismantling_substep_model.dart';

class DismantlingStepModel {
  final String id;
  final String title;
  final String? description;
  final String? pdfReference;
  final List<DismantlingImageModel>? images;
  final List<DismantlingRequirementModel>? requirements;
  final List<DismantlingSubstepModel>? steps;

  DismantlingStepModel({
    required this.id,
    required this.title,
    this.description,
    this.pdfReference,
    this.images,
    this.requirements,
    this.steps,
  });

  factory DismantlingStepModel.fromJson(Map<String, dynamic> json) {
    final requirementsJson = json['requirements'] as List<dynamic>?;
    final stepsJson = json['steps'] as List<dynamic>?;

    List<DismantlingRequirementModel>? requirements;
    List<DismantlingSubstepModel>? steps;

    if (requirementsJson != null) {
      requirements = requirementsJson
          .map(
            (e) => DismantlingRequirementModel.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList();
    }

    if (stepsJson != null) {
      steps = stepsJson
          .map(
            (e) => DismantlingSubstepModel.fromJson(e as Map<String, dynamic>),
          )
          .toList();
    }

    return DismantlingStepModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      pdfReference: json['pdfReference'] as String?,
      images: (json['images'] as List<dynamic>?)
          ?.map(
            (e) => DismantlingImageModel.fromJson(e as Map<String, dynamic>),
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
