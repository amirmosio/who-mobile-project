import 'package:who_mobile_project/general/models/idtm/facility_component.dart';
import 'package:who_mobile_project/general/models/idtm/installation_step.dart';

/// Represents an IDTM facility (e.g., Infectious Disease Treatment Centre)
class IdtmFacility {
  /// Unique identifier for the facility type
  final String id;

  /// Facility name (e.g., "Infectious Disease Treatment Centre")
  final String name;

  /// Facility description
  final String description;

  /// Facility type code (e.g., "IDTC")
  final String facilityType;

  /// Manufacturer (e.g., "LANCO")
  final String manufacturer;

  /// Version/model number
  final String version;

  /// Total number of sheets/pages in manual
  final int totalSheets;

  /// Date of last manual update
  final DateTime? lastUpdated;

  /// List of all components required
  final List<FacilityComponent> components;

  /// All installation steps across all phases
  final List<InstallationStep> steps;

  /// Thumbnail image URL
  final String? thumbnailUrl;

  /// 3D view images
  final List<String> view3dImages;

  /// Technical specifications
  final Map<String, dynamic>? specifications;

  const IdtmFacility({
    required this.id,
    required this.name,
    required this.description,
    required this.facilityType,
    required this.manufacturer,
    required this.version,
    required this.totalSheets,
    this.lastUpdated,
    this.components = const [],
    this.steps = const [],
    this.thumbnailUrl,
    this.view3dImages = const [],
    this.specifications,
  });

  factory IdtmFacility.fromJson(Map<String, dynamic> json) {
    return IdtmFacility(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      facilityType: json['facilityType'] as String,
      manufacturer: json['manufacturer'] as String,
      version: json['version'] as String,
      totalSheets: json['totalSheets'] as int,
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'] as String)
          : null,
      components: (json['components'] as List<dynamic>?)
              ?.map((e) =>
                  FacilityComponent.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      steps: (json['steps'] as List<dynamic>?)
              ?.map((e) =>
                  InstallationStep.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      thumbnailUrl: json['thumbnailUrl'] as String?,
      view3dImages: (json['view3dImages'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      specifications: json['specifications'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'facilityType': facilityType,
      'manufacturer': manufacturer,
      'version': version,
      'totalSheets': totalSheets,
      'lastUpdated': lastUpdated?.toIso8601String(),
      'components': components.map((e) => e.toJson()).toList(),
      'steps': steps.map((e) => e.toJson()).toList(),
      'thumbnailUrl': thumbnailUrl,
      'view3dImages': view3dImages,
      'specifications': specifications,
    };
  }

  IdtmFacility copyWith({
    String? id,
    String? name,
    String? description,
    String? facilityType,
    String? manufacturer,
    String? version,
    int? totalSheets,
    DateTime? lastUpdated,
    List<FacilityComponent>? components,
    List<InstallationStep>? steps,
    String? thumbnailUrl,
    List<String>? view3dImages,
    Map<String, dynamic>? specifications,
  }) {
    return IdtmFacility(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      facilityType: facilityType ?? this.facilityType,
      manufacturer: manufacturer ?? this.manufacturer,
      version: version ?? this.version,
      totalSheets: totalSheets ?? this.totalSheets,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      components: components ?? this.components,
      steps: steps ?? this.steps,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      view3dImages: view3dImages ?? this.view3dImages,
      specifications: specifications ?? this.specifications,
    );
  }

  /// Get steps for a specific phase
  List<InstallationStep> getStepsForPhase(String phase) {
    return steps.where((step) => step.phase.value == phase).toList()
      ..sort((a, b) => a.stepNumber.compareTo(b.stepNumber));
  }

  /// Get components by category
  List<FacilityComponent> getComponentsByCategory(String category) {
    return components.where((c) => c.category == category).toList();
  }

  /// Get total estimated time (in minutes)
  int get totalEstimatedMinutes {
    return steps.fold(0, (sum, step) => sum + (step.estimatedMinutes ?? 0));
  }
}
