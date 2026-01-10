import 'package:who_mobile_project/general/models/facility_use/facility_use_step_model.dart';
import 'package:who_mobile_project/general/models/facility_use/facility_use_substep_model.dart';

/// Represents a substep with its global index and parent step information
class FlattenedFacilityUseSubstepModel {
  final int globalIndex;
  final String stepId;
  final String substepId;
  final FacilityUseSubstepModel substep;
  final FacilityUseStepModel parentStep;

  FlattenedFacilityUseSubstepModel({
    required this.globalIndex,
    required this.stepId,
    required this.substepId,
    required this.substep,
    required this.parentStep,
  });
}

/// Helper class to flatten all substeps from sections into a single indexed list
class FlattenedFacilityUseSubstepsHelper {
  static List<FlattenedFacilityUseSubstepModel> flattenSubsteps(
    List<FacilityUseStepModel> sections,
  ) {
    final List<FlattenedFacilityUseSubstepModel> flattened = [];
    int globalIndex = 0;

    for (final section in sections) {
      // Only include actual steps, not requirements
      final substeps = section.steps ?? [];
      for (final substep in substeps) {
        flattened.add(
          FlattenedFacilityUseSubstepModel(
            globalIndex: globalIndex,
            stepId: section.id,
            substepId: substep.id,
            substep: substep,
            parentStep: section,
          ),
        );
        globalIndex++;
      }
    }

    return flattened;
  }

  /// Find the global index for a specific stepId and substepId combination
  static int? findGlobalIndex(
    List<FlattenedFacilityUseSubstepModel> flattenedList,
    String stepId,
    String substepId,
  ) {
    try {
      final item = flattenedList.firstWhere(
        (item) => item.stepId == stepId && item.substepId == substepId,
      );
      return item.globalIndex;
    } catch (e) {
      return null;
    }
  }

  /// Find a flattened substep by its global index
  static FlattenedFacilityUseSubstepModel? findByGlobalIndex(
    List<FlattenedFacilityUseSubstepModel> flattenedList,
    int globalIndex,
  ) {
    try {
      return flattenedList.firstWhere(
        (item) => item.globalIndex == globalIndex,
      );
    } catch (e) {
      return null;
    }
  }
}
