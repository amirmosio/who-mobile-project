import 'package:who_mobile_project/general/models/installation/installation_step_model.dart';
import 'package:who_mobile_project/general/models/installation/installation_substep_model.dart';

/// Represents a substep with its global index and parent step information
class FlattenedSubstepModel {
  final int globalIndex;
  final String stepId;
  final String substepId;
  final InstallationSubstepModel substep;
  final InstallationStepModel parentStep;

  FlattenedSubstepModel({
    required this.globalIndex,
    required this.stepId,
    required this.substepId,
    required this.substep,
    required this.parentStep,
  });
}

/// Helper class to flatten all substeps from sections into a single indexed list
class FlattenedSubstepsHelper {
  static List<FlattenedSubstepModel> flattenSubsteps(
    List<InstallationStepModel> sections,
  ) {
    final List<FlattenedSubstepModel> flattened = [];
    int globalIndex = 0;

    for (final section in sections) {
      final substeps = section.allSubsteps;
      for (final substep in substeps) {
        flattened.add(
          FlattenedSubstepModel(
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
    List<FlattenedSubstepModel> flattenedList,
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
  static FlattenedSubstepModel? findByGlobalIndex(
    List<FlattenedSubstepModel> flattenedList,
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
