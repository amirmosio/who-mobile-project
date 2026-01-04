import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:who_mobile_project/di/injector.dart';
import 'package:who_mobile_project/general/models/dismantling/dismantling_data_model.dart';
import 'package:who_mobile_project/general/models/dismantling/flattened_substep_model.dart';
import 'package:who_mobile_project/general/services/storage/storage_manager.dart';
import 'package:who_mobile_project/repository/dismantling/dismantling_repository.dart';

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
