import 'installation_image_model.dart';
import 'installation_substep_model.dart';

class InstallationStepModel {
  final String id;
  final String title;
  final String? description;
  final String? pdfReference;
  final List<InstallationImageModel>? images;
  final List<InstallationSubstepModel>? substeps;
  final List<InstallationSubstepModel>? steps; // For nested steps structure

  InstallationStepModel({
    required this.id,
    required this.title,
    this.description,
    this.pdfReference,
    this.images,
    this.substeps,
    this.steps,
  });

  factory InstallationStepModel.fromJson(Map<String, dynamic> json) {
    // Handle both "subsections" and "substeps" keys
    final subsectionsJson = json['subsections'] as List<dynamic>?;
    final substepsJson = json['steps'] as List<dynamic>?;

    List<InstallationSubstepModel>? substeps;
    List<InstallationSubstepModel>? steps;

    if (subsectionsJson != null) {
      substeps = subsectionsJson
          .map((e) => InstallationSubstepModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    if (substepsJson != null) {
      steps = substepsJson
          .map((e) => InstallationSubstepModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    return InstallationStepModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      pdfReference: json['pdfReference'] as String?,
      images: (json['images'] as List<dynamic>?)
          ?.map((e) => InstallationImageModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      substeps: substeps,
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
      if (substeps != null) 'substeps': substeps!.map((e) => e.toJson()).toList(),
      if (steps != null) 'steps': steps!.map((e) => e.toJson()).toList(),
    };
  }

  // Get all substeps (from both substeps and steps)
  List<InstallationSubstepModel> get allSubsteps {
    final List<InstallationSubstepModel> all = [];
    if (substeps != null) all.addAll(substeps!);
    if (steps != null) all.addAll(steps!);
    return all;
  }
}
