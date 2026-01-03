import 'package:who_mobile_project/general/services/storage/base_storage.dart';

/// Mixin for installation progress tracking storage operations
/// Uses a sequential approach: tracks only the last completed substep,
/// and all substeps before it are considered completed
mixin InstallationProgressStorageMixin on BaseStorage {
  // Storage key
  static const _lastCompletedSubstepIndexKey = 'installation_last_completed_substep_index';

  /// Get the last completed substep index
  /// Returns -1 if no substep has been completed yet
  int getLastCompletedSubstepIndex() {
    return sharedPreferences.getInt(_lastCompletedSubstepIndexKey) ?? -1;
  }

  /// Set the last completed substep index
  /// This marks this substep and all previous substeps as completed
  Future<void> setLastCompletedSubstepIndex(int index) async {
    await sharedPreferences.setInt(_lastCompletedSubstepIndexKey, index);
  }

  /// Check if a substep is completed based on its index
  /// A substep is completed if its index is <= last completed index
  bool isSubstepCompletedByIndex(int substepIndex) {
    final lastCompleted = getLastCompletedSubstepIndex();
    return substepIndex <= lastCompleted;
  }

  /// Get count of completed substeps
  int getCompletedSubstepsCount() {
    final lastCompleted = getLastCompletedSubstepIndex();
    return lastCompleted + 1; // +1 because index starts at 0
  }

  /// Reset all installation progress
  Future<void> resetInstallationProgress() async {
    await sharedPreferences.remove(_lastCompletedSubstepIndexKey);
  }

  /// Get overall progress percentage (0.0 to 1.0)
  double getOverallProgress(int totalSubsteps) {
    if (totalSubsteps == 0) return 0.0;
    final completed = getCompletedSubstepsCount();
    return (completed / totalSubsteps).clamp(0.0, 1.0);
  }
}
