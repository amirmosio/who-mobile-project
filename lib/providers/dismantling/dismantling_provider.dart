import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:who_mobile_project/di/injector.dart';
import 'package:who_mobile_project/general/models/dismantling/dismantling_data_model.dart';
import 'package:who_mobile_project/general/models/dismantling/flattened_substep_model.dart';
import 'package:who_mobile_project/general/services/storage/storage_manager.dart';
import 'package:who_mobile_project/repository/dismantling/dismantling_repository.dart';
import 'package:who_mobile_project/routing_config/routes.dart';

part 'dismantling_provider.g.dart';

@riverpod
class DismantlingData extends _$DismantlingData {
  @override
  Future<DismantlingDataModel> build() async {
    return getIt<DismantlingRepository>().loadDismantlingData();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = getIt<DismantlingRepository>();
      repository.clearCache();
      return repository.loadDismantlingData();
    });
  }

  String getImagePath(String filename) {
    return getIt<DismantlingRepository>().getImagePath(filename);
  }
}

// Provider for flattened substeps list with global indexes
@riverpod
List<FlattenedDismantlingSubstepModel> flattenedDismantlingSubsteps(Ref ref) {
  final dismantlingDataAsync = ref.watch(dismantlingDataProvider);
  return dismantlingDataAsync.when(
    data: (data) => FlattenedDismantlingSubstepsHelper.flattenSubsteps(data.sections),
    loading: () => [],
    error: (_, __) => [],
  );
}

// Provider to track progress state
// Uses sequential progress: only tracks the last completed substep index
@riverpod
class DismantlingProgress extends _$DismantlingProgress {
  @override
  int build() {
    return getIt<StorageManager>().getLastCompletedDismantlingSubstepIndex();
  }

  /// Mark a substep as completed by its index
  /// This also marks all previous substeps as completed
  Future<void> markSubstepCompletedByIndex(int substepIndex) async {
    await getIt<StorageManager>().setLastCompletedDismantlingSubstepIndex(substepIndex);
    state = substepIndex;
  }

  /// Check if a substep is completed by its index
  bool isSubstepCompletedByIndex(int substepIndex) {
    return getIt<StorageManager>().isDismantlingSubstepCompletedByIndex(substepIndex);
  }

  /// Get the count of completed substeps
  int getCompletedSubstepsCount() {
    return getIt<StorageManager>().getCompletedDismantlingSubstepsCount();
  }

  /// Get overall progress percentage (0.0 to 1.0)
  double getOverallProgress(int totalSubsteps) {
    return getIt<StorageManager>().getDismantlingGuideProgress(totalSubsteps);
  }

  /// Reset all progress
  Future<void> resetProgress() async {
    await getIt<StorageManager>().resetDismantlingGuideProgress();
    state = -1;
  }
}

/// Navigation info for section detail pages
class DismantlingSectionNavigationInfo {
  final String? previousRoute;
  final String? nextRoute;
  final String? nextLabel;

  const DismantlingSectionNavigationInfo({
    this.previousRoute,
    this.nextRoute,
    this.nextLabel,
  });
}

/// Navigation info for substep detail pages
class DismantlingSubstepNavigationInfo {
  final String? previousRoute;
  final String? nextRoute;
  final String? nextLabel;

  const DismantlingSubstepNavigationInfo({
    this.previousRoute,
    this.nextRoute,
    this.nextLabel,
  });
}

/// Provider for section detail page navigation
@riverpod
DismantlingSectionNavigationInfo dismantlingSectionNavigation(
  Ref ref,
  String stepId,
) {
  final dismantlingDataAsync = ref.watch(dismantlingDataProvider);

  return dismantlingDataAsync.when(
    data: (data) {
      final sections = data.sections;
      final currentIndex = sections.indexWhere((s) => s.id == stepId);

      if (currentIndex == -1) {
        return const DismantlingSectionNavigationInfo();
      }

      final currentSection = sections[currentIndex];
      String? previousRoute;
      String? nextRoute;
      String? nextLabel;

      // Previous logic
      if (currentIndex > 0) {
        final previousSection = sections[currentIndex - 1];
        final previousSteps = previousSection.steps;
        if (previousSteps != null && previousSteps.isNotEmpty) {
          // Go to last substep of previous section
          final lastSubstep = previousSteps.last;
          previousRoute = YRRoutes.dismantlingSubstepDetail
              .replaceFirst(':stepId', previousSection.id)
              .replaceFirst(':substepId', lastSubstep.id);
        } else {
          // Go to previous section detail
          previousRoute = YRRoutes.dismantlingStepDetail
              .replaceFirst(':stepId', previousSection.id);
        }
      }

      // Next logic
      final currentSteps = currentSection.steps;
      if (currentSteps != null && currentSteps.isNotEmpty) {
        // Go to first substep of current section
        final firstSubstep = currentSteps.first;
        nextRoute = YRRoutes.dismantlingSubstepDetail
            .replaceFirst(':stepId', stepId)
            .replaceFirst(':substepId', firstSubstep.id);
        nextLabel = 'Next: ${firstSubstep.title}';
      } else if (currentIndex < sections.length - 1) {
        // Go to next section detail (no substeps in current)
        final nextSection = sections[currentIndex + 1];
        nextRoute = YRRoutes.dismantlingStepDetail
            .replaceFirst(':stepId', nextSection.id);
        nextLabel = 'Next: ${nextSection.title}';
      }

      return DismantlingSectionNavigationInfo(
        previousRoute: previousRoute,
        nextRoute: nextRoute,
        nextLabel: nextLabel,
      );
    },
    loading: () => const DismantlingSectionNavigationInfo(),
    error: (_, __) => const DismantlingSectionNavigationInfo(),
  );
}

/// Provider for substep detail page navigation
@riverpod
DismantlingSubstepNavigationInfo dismantlingSubstepNavigation(
  Ref ref,
  String stepId,
  String substepId,
) {
  final dismantlingDataAsync = ref.watch(dismantlingDataProvider);

  return dismantlingDataAsync.when(
    data: (data) {
      final sections = data.sections;
      final sectionIndex = sections.indexWhere((s) => s.id == stepId);

      if (sectionIndex == -1) {
        return const DismantlingSubstepNavigationInfo();
      }

      final currentSection = sections[sectionIndex];
      final currentSteps = currentSection.steps;

      if (currentSteps == null || currentSteps.isEmpty) {
        return const DismantlingSubstepNavigationInfo();
      }

      final substepIndex = currentSteps.indexWhere((s) => s.id == substepId);

      if (substepIndex == -1) {
        return const DismantlingSubstepNavigationInfo();
      }

      String? previousRoute;
      String? nextRoute;
      String? nextLabel;

      // Previous logic
      if (substepIndex > 0) {
        // Go to previous substep in same section
        final previousSubstep = currentSteps[substepIndex - 1];
        previousRoute = YRRoutes.dismantlingSubstepDetail
            .replaceFirst(':stepId', stepId)
            .replaceFirst(':substepId', previousSubstep.id);
      } else {
        // First substep in section, go back to section detail
        previousRoute =
            YRRoutes.dismantlingStepDetail.replaceFirst(':stepId', stepId);
      }

      // Next logic
      if (substepIndex < currentSteps.length - 1) {
        // Go to next substep in same section
        final nextSubstep = currentSteps[substepIndex + 1];
        nextRoute = YRRoutes.dismantlingSubstepDetail
            .replaceFirst(':stepId', stepId)
            .replaceFirst(':substepId', nextSubstep.id);
        nextLabel = 'Next: ${nextSubstep.title}';
      } else if (sectionIndex < sections.length - 1) {
        // Last substep in section, go to next section detail
        final nextSection = sections[sectionIndex + 1];
        nextRoute = YRRoutes.dismantlingStepDetail
            .replaceFirst(':stepId', nextSection.id);
        nextLabel = 'Next: ${nextSection.title}';
      }

      return DismantlingSubstepNavigationInfo(
        previousRoute: previousRoute,
        nextRoute: nextRoute,
        nextLabel: nextLabel,
      );
    },
    loading: () => const DismantlingSubstepNavigationInfo(),
    error: (_, __) => const DismantlingSubstepNavigationInfo(),
  );
}
