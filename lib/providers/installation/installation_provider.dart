import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:who_mobile_project/di/injector.dart';
import 'package:who_mobile_project/general/models/installation/flattened_substep_model.dart';
import 'package:who_mobile_project/general/models/installation/installation_data_model.dart';
import 'package:who_mobile_project/general/services/storage/storage_manager.dart';
import 'package:who_mobile_project/repository/installation/installation_repository.dart';
import 'package:who_mobile_project/routing_config/routes.dart';

part 'installation_provider.g.dart';

@riverpod
class InstallationData extends _$InstallationData {
  @override
  Future<InstallationDataModel> build() async {
    return getIt<InstallationRepository>().loadInstallationData();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = getIt<InstallationRepository>();
      repository.clearCache();
      return repository.loadInstallationData();
    });
  }

  String getImagePath(String filename) {
    return getIt<InstallationRepository>().getImagePath(filename);
  }
}

// Provider for flattened substeps list with global indexes
@riverpod
List<FlattenedSubstepModel> flattenedSubsteps(Ref ref) {
  final installationDataAsync = ref.watch(installationDataProvider);
  return installationDataAsync.when(
    data: (data) => FlattenedSubstepsHelper.flattenSubsteps(data.sections),
    loading: () => [],
    error: (_, __) => [],
  );
}

// Provider to track progress state
// Uses sequential progress: only tracks the last completed substep index
@riverpod
class InstallationProgress extends _$InstallationProgress {
  @override
  int build() {
    return getIt<StorageManager>().getLastCompletedSubstepIndex();
  }

  /// Mark a substep as completed by its index
  /// This also marks all previous substeps as completed
  Future<void> markSubstepCompletedByIndex(int substepIndex) async {
    await getIt<StorageManager>().setLastCompletedSubstepIndex(substepIndex);
    state = substepIndex;
  }

  /// Check if a substep is completed by its index
  bool isSubstepCompletedByIndex(int substepIndex) {
    return getIt<StorageManager>().isSubstepCompletedByIndex(substepIndex);
  }

  /// Get the count of completed substeps
  int getCompletedSubstepsCount() {
    return getIt<StorageManager>().getCompletedSubstepsCount();
  }

  /// Get overall progress percentage (0.0 to 1.0)
  double getOverallProgress(int totalSubsteps) {
    return getIt<StorageManager>().getInstallationGuideProgress(totalSubsteps);
  }

  /// Reset all progress
  Future<void> resetProgress() async {
    await getIt<StorageManager>().resetInstallationGuideProgress();
    state = -1;
  }
}

/// Navigation info for section detail pages
class SectionNavigationInfo {
  final String? previousRoute;
  final String? nextRoute;
  final String? nextLabel;

  const SectionNavigationInfo({
    this.previousRoute,
    this.nextRoute,
    this.nextLabel,
  });
}

/// Navigation info for substep detail pages
class SubstepNavigationInfo {
  final String? previousRoute;
  final String? nextRoute;
  final String? nextLabel;

  const SubstepNavigationInfo({
    this.previousRoute,
    this.nextRoute,
    this.nextLabel,
  });
}

/// Provider for section detail page navigation
@riverpod
SectionNavigationInfo installationSectionNavigation(
  Ref ref,
  String stepId,
) {
  final installationDataAsync = ref.watch(installationDataProvider);

  return installationDataAsync.when(
    data: (data) {
      final sections = data.sections;
      final currentIndex = sections.indexWhere((s) => s.id == stepId);

      if (currentIndex == -1) {
        return const SectionNavigationInfo();
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
          previousRoute = YRRoutes.installationSubstepDetail
              .replaceFirst(':stepId', previousSection.id)
              .replaceFirst(':substepId', lastSubstep.id);
        } else {
          // Go to previous section detail
          previousRoute = YRRoutes.installationStepDetail
              .replaceFirst(':stepId', previousSection.id);
        }
      }

      // Next logic
      final currentSteps = currentSection.steps;
      if (currentSteps != null && currentSteps.isNotEmpty) {
        // Go to first substep of current section
        final firstSubstep = currentSteps.first;
        nextRoute = YRRoutes.installationSubstepDetail
            .replaceFirst(':stepId', stepId)
            .replaceFirst(':substepId', firstSubstep.id);
        nextLabel = 'Next: ${firstSubstep.title}';
      } else if (currentIndex < sections.length - 1) {
        // Go to next section detail (no substeps in current)
        final nextSection = sections[currentIndex + 1];
        nextRoute = YRRoutes.installationStepDetail
            .replaceFirst(':stepId', nextSection.id);
        nextLabel = 'Next: ${nextSection.title}';
      }

      return SectionNavigationInfo(
        previousRoute: previousRoute,
        nextRoute: nextRoute,
        nextLabel: nextLabel,
      );
    },
    loading: () => const SectionNavigationInfo(),
    error: (_, __) => const SectionNavigationInfo(),
  );
}

/// Provider for substep detail page navigation
@riverpod
SubstepNavigationInfo installationSubstepNavigation(
  Ref ref,
  String stepId,
  String substepId,
) {
  final installationDataAsync = ref.watch(installationDataProvider);

  return installationDataAsync.when(
    data: (data) {
      final sections = data.sections;
      final sectionIndex = sections.indexWhere((s) => s.id == stepId);

      if (sectionIndex == -1) {
        return const SubstepNavigationInfo();
      }

      final currentSection = sections[sectionIndex];
      final currentSteps = currentSection.steps;

      if (currentSteps == null || currentSteps.isEmpty) {
        return const SubstepNavigationInfo();
      }

      final substepIndex = currentSteps.indexWhere((s) => s.id == substepId);

      if (substepIndex == -1) {
        return const SubstepNavigationInfo();
      }

      String? previousRoute;
      String? nextRoute;
      String? nextLabel;

      // Previous logic
      if (substepIndex > 0) {
        // Go to previous substep in same section
        final previousSubstep = currentSteps[substepIndex - 1];
        previousRoute = YRRoutes.installationSubstepDetail
            .replaceFirst(':stepId', stepId)
            .replaceFirst(':substepId', previousSubstep.id);
      } else {
        // First substep in section, go back to section detail
        previousRoute =
            YRRoutes.installationStepDetail.replaceFirst(':stepId', stepId);
      }

      // Next logic
      if (substepIndex < currentSteps.length - 1) {
        // Go to next substep in same section
        final nextSubstep = currentSteps[substepIndex + 1];
        nextRoute = YRRoutes.installationSubstepDetail
            .replaceFirst(':stepId', stepId)
            .replaceFirst(':substepId', nextSubstep.id);
        nextLabel = 'Next: ${nextSubstep.title}';
      } else if (sectionIndex < sections.length - 1) {
        // Last substep in section, go to next section detail
        final nextSection = sections[sectionIndex + 1];
        nextRoute = YRRoutes.installationStepDetail
            .replaceFirst(':stepId', nextSection.id);
        nextLabel = 'Next: ${nextSection.title}';
      }

      return SubstepNavigationInfo(
        previousRoute: previousRoute,
        nextRoute: nextRoute,
        nextLabel: nextLabel,
      );
    },
    loading: () => const SubstepNavigationInfo(),
    error: (_, __) => const SubstepNavigationInfo(),
  );
}
