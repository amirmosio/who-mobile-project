import 'package:who_mobile_project/general/models/idtm/installation_phase.dart';

/// Represents a single step in the installation/maintenance/dismantling process
class InstallationStep {
  /// Unique identifier for the step
  final String id;

  /// Step number in sequence
  final int stepNumber;

  /// Title of the step
  final String title;

  /// Detailed description/instructions
  final String description;

  /// Phase this step belongs to
  final FacilityInstallationPhase phase;

  /// List of image asset paths for this step
  final List<String> images;

  /// List of warning messages for common mistakes
  final List<String> warnings;

  /// Estimated time to complete (in minutes)
  final int? estimatedMinutes;

  /// Whether this step is critical/required
  final bool isCritical;

  /// Dependencies - IDs of steps that must be completed first
  final List<String> dependencies;

  /// Component IDs involved in this step
  final List<String> componentIds;

  const InstallationStep({
    required this.id,
    required this.stepNumber,
    required this.title,
    required this.description,
    required this.phase,
    this.images = const [],
    this.warnings = const [],
    this.estimatedMinutes,
    this.isCritical = false,
    this.dependencies = const [],
    this.componentIds = const [],
  });

  factory InstallationStep.fromJson(Map<String, dynamic> json) {
    return InstallationStep(
      id: json['id'] as String,
      stepNumber: json['stepNumber'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      phase: FacilityInstallationPhase.fromString(json['phase'] as String),
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      warnings: (json['warnings'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      estimatedMinutes: json['estimatedMinutes'] as int?,
      isCritical: json['isCritical'] as bool? ?? false,
      dependencies: (json['dependencies'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      componentIds: (json['componentIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'stepNumber': stepNumber,
      'title': title,
      'description': description,
      'phase': phase.value,
      'images': images,
      'warnings': warnings,
      'estimatedMinutes': estimatedMinutes,
      'isCritical': isCritical,
      'dependencies': dependencies,
      'componentIds': componentIds,
    };
  }

  InstallationStep copyWith({
    String? id,
    int? stepNumber,
    String? title,
    String? description,
    FacilityInstallationPhase? phase,
    List<String>? images,
    List<String>? warnings,
    int? estimatedMinutes,
    bool? isCritical,
    List<String>? dependencies,
    List<String>? componentIds,
  }) {
    return InstallationStep(
      id: id ?? this.id,
      stepNumber: stepNumber ?? this.stepNumber,
      title: title ?? this.title,
      description: description ?? this.description,
      phase: phase ?? this.phase,
      images: images ?? this.images,
      warnings: warnings ?? this.warnings,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
      isCritical: isCritical ?? this.isCritical,
      dependencies: dependencies ?? this.dependencies,
      componentIds: componentIds ?? this.componentIds,
    );
  }
}
