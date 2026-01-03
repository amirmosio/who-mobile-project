import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:who_mobile_project/di/injector.dart';
import 'package:who_mobile_project/general/models/installation/flattened_substep_model.dart';
import 'package:who_mobile_project/general/models/installation/installation_data_model.dart';
import 'package:who_mobile_project/general/services/storage/storage_manager.dart';
import 'package:who_mobile_project/repository/installation/installation_repository.dart';

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
