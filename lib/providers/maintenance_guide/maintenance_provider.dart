import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:who_mobile_project/di/injector.dart';
import 'package:who_mobile_project/general/models/maintenance_guide/flattened_maintenance_substep_model.dart';
import 'package:who_mobile_project/general/models/maintenance_guide/maintenance_data_model.dart';
import 'package:who_mobile_project/general/services/storage/storage_manager.dart';
import 'package:who_mobile_project/providers/app_locale/app_locale_provider.dart';
import 'package:who_mobile_project/repository/maintenance_guide/maintenance_repository.dart';

part 'maintenance_provider.g.dart';

@riverpod
class MaintenanceData extends _$MaintenanceData {
  @override
  Future<MaintenanceDataModel> build() async {
    final locale = ref.watch(appLocaleProvider);
    return getIt<MaintenanceRepository>().loadMaintenanceData(
      localeCode: locale.languageCode,
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    final locale = ref.read(appLocaleProvider);
    state = await AsyncValue.guard(() async {
      final repository = getIt<MaintenanceRepository>();
      repository.clearCache();
      return repository.loadMaintenanceData(
        localeCode: locale.languageCode,
      );
    });
  }

  String getImagePath(String filename) {
    return getIt<MaintenanceRepository>().getImagePath(filename);
  }
}

// Provider for flattened substeps list with global indexes
@riverpod
List<FlattenedMaintenanceSubstepModel> flattenedMaintenanceSubsteps(Ref ref) {
  final maintenanceDataAsync = ref.watch(maintenanceDataProvider);
  return maintenanceDataAsync.when(
    data: (data) =>
        FlattenedMaintenanceSubstepsHelper.flattenSubsteps(data.sections),
    loading: () => [],
    error: (_, __) => [],
  );
}

// Provider to track progress state
// Uses sequential progress: only tracks the last completed substep index
@riverpod
class MaintenanceProgress extends _$MaintenanceProgress {
  @override
  int build() {
    return getIt<StorageManager>().getLastCompletedMaintenanceSubstepIndex();
  }

  /// Mark a substep as completed by its index
  /// This also marks all previous substeps as completed
  Future<void> markSubstepCompletedByIndex(int substepIndex) async {
    await getIt<StorageManager>()
        .setLastCompletedMaintenanceSubstepIndex(substepIndex);
    state = substepIndex;
  }

  /// Check if a substep is completed by its index
  bool isSubstepCompletedByIndex(int substepIndex) {
    return getIt<StorageManager>()
        .isMaintenanceSubstepCompletedByIndex(substepIndex);
  }

  /// Get the count of completed substeps
  int getCompletedSubstepsCount() {
    return getIt<StorageManager>().getCompletedMaintenanceSubstepsCount();
  }

  /// Get overall progress percentage (0.0 to 1.0)
  double getOverallProgress(int totalSubsteps) {
    return getIt<StorageManager>().getMaintenanceGuideProgress(totalSubsteps);
  }

  /// Reset all progress
  Future<void> resetProgress() async {
    await getIt<StorageManager>().resetMaintenanceGuideProgress();
    state = -1;
  }
}
