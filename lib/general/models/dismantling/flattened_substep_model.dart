import 'package:who_mobile_project/general/models/dismantling/dismantling_step_model.dart';
import 'package:who_mobile_project/general/models/dismantling/dismantling_substep_model.dart';

/// Represents a substep with its global index and parent step information
class FlattenedDismantlingSubstepModel {
  final int globalIndex;
  final String stepId;
  final String substepId;
  final DismantlingSubstepModel substep;
  final DismantlingStepModel parentStep;

  FlattenedDismantlingSubstepModel({
    required this.globalIndex,
    required this.stepId,
    required this.substepId,
    required this.substep,
    required this.parentStep,
  });
}

/// Helper class to flatten all substeps from sections into a single indexed list
class FlattenedDismantlingSubstepsHelper {
  static List<FlattenedDismantlingSubstepModel> flattenSubsteps(
    List<DismantlingStepModel> sections,
  ) {
    final List<FlattenedDismantlingSubstepModel> flattened = [];
    int globalIndex = 0;

    for (final section in sections) {
      // Only include actual steps, not requirements
      final substeps = section.steps ?? [];
      for (final substep in substeps) {
        flattened.add(
          FlattenedDismantlingSubstepModel(
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
    List<FlattenedDismantlingSubstepModel> flattenedList,
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
  static FlattenedDismantlingSubstepModel? findByGlobalIndex(
    List<FlattenedDismantlingSubstepModel> flattenedList,
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
