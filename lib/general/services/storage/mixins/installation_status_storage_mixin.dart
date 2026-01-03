import 'package:who_mobile_project/general/models/idtm/installation_phase.dart';
import 'package:who_mobile_project/general/services/storage/base_storage.dart';

/// Mixin for managing all installation-related storage operations
///
/// This mixin handles two types of installation tracking:
/// 1. **IDTM Installation** - Actual facility installation tracking
///    - Phase management (initial, installing, maintenance, dismantling, completed)
///    - Installation/facility info (ID, name)
///    - Step completion by step ID (installation and dismantling steps)
///
/// 2. **Installation Guide** - Educational/documentation feature
///    - Sequential progress tracking by substep index
///    - Overall progress percentage calculation
mixin InstallationStatusStorageMixin on BaseStorage {
  // ============================================================================
  // IDTM Installation Storage
  // ============================================================================

  // Storage keys
  static const String _keyInstallationPhase = 'installation_phase';
  static const String _keyInstallationId = 'installation_id';
  static const String _keyFacilityId = 'facility_id';
  static const String _keyFacilityName = 'facility_name';
  static const String _keyCompletedSteps = 'completed_installation_steps';
  static const String _keyCompletedDismantlingSteps = 'completed_dismantling_steps';

  // Phase management

  /// Get current installation phase
  FacilityInstallationPhase getCurrentPhase() {
    final phaseString = sharedPreferences.getString(_keyInstallationPhase);
    if (phaseString == null) {
      return FacilityInstallationPhase.initial;
    }
    return FacilityInstallationPhase.fromString(phaseString);
  }

  /// Set current installation phase
  Future<void> setCurrentPhase(FacilityInstallationPhase phase) async {
    await sharedPreferences.setString(_keyInstallationPhase, phase.value);
  }

  // Installation and facility info

  /// Get installation ID
  String? getInstallationId() {
    return sharedPreferences.getString(_keyInstallationId);
  }

  /// Set installation ID
  Future<void> setInstallationId(String? id) async {
    if (id == null) {
      await sharedPreferences.remove(_keyInstallationId);
    } else {
      await sharedPreferences.setString(_keyInstallationId, id);
    }
  }

  /// Get facility ID
  String? getFacilityId() {
    return sharedPreferences.getString(_keyFacilityId);
  }

  /// Set facility ID
  Future<void> setFacilityId(String? id) async {
    if (id == null) {
      await sharedPreferences.remove(_keyFacilityId);
    } else {
      await sharedPreferences.setString(_keyFacilityId, id);
    }
  }

  /// Get facility name
  String? getFacilityName() {
    return sharedPreferences.getString(_keyFacilityName);
  }

  /// Set facility name
  Future<void> setFacilityName(String? name) async {
    if (name == null) {
      await sharedPreferences.remove(_keyFacilityName);
    } else {
      await sharedPreferences.setString(_keyFacilityName, name);
    }
  }

  // Phase transitions

  /// Start installation - transition from initial to installing
  Future<void> startInstallation({
    required String installationId,
    required String facilityId,
    required String facilityName,
  }) async {
    await setInstallationId(installationId);
    await setFacilityId(facilityId);
    await setFacilityName(facilityName);
    await setCurrentPhase(FacilityInstallationPhase.installing);
  }

  /// Complete installation - transition to maintenance
  Future<void> completeInstallation() async {
    await setCurrentPhase(FacilityInstallationPhase.maintenance);
  }

  /// Start dismantling
  Future<void> startDismantling() async {
    await setCurrentPhase(FacilityInstallationPhase.dismantling);
  }

  /// Complete dismantling - reset to initial
  Future<void> completeDismantling() async {
    await setCurrentPhase(FacilityInstallationPhase.initial);
    await setInstallationId(null);
    await setFacilityId(null);
    await setFacilityName(null);
    await clearCompletedSteps();
    await clearCompletedDismantlingSteps();
  }

  /// Reset all installation data
  Future<void> resetInstallationStatus() async {
    await sharedPreferences.remove(_keyInstallationPhase);
    await sharedPreferences.remove(_keyInstallationId);
    await sharedPreferences.remove(_keyFacilityId);
    await sharedPreferences.remove(_keyFacilityName);
    await clearCompletedSteps();
    await clearCompletedDismantlingSteps();
  }

  /// Check if installation is active
  bool get hasActiveInstallation {
    final phase = getCurrentPhase();
    return phase != FacilityInstallationPhase.initial;
  }

  // Step completion management

  /// Get list of completed installation step IDs
  List<String> getCompletedSteps() {
    final stepsList = sharedPreferences.getStringList(_keyCompletedSteps);
    return stepsList ?? [];
  }

  /// Mark an installation step as completed
  Future<void> markStepCompleted(String stepId) async {
    final completedSteps = getCompletedSteps();
    if (!completedSteps.contains(stepId)) {
      completedSteps.add(stepId);
      await sharedPreferences.setStringList(_keyCompletedSteps, completedSteps);
    }
  }

  /// Mark an installation step as incomplete
  Future<void> markStepIncomplete(String stepId) async {
    final completedSteps = getCompletedSteps();
    completedSteps.remove(stepId);
    await sharedPreferences.setStringList(_keyCompletedSteps, completedSteps);
  }

  /// Clear all completed installation steps
  Future<void> clearCompletedSteps() async {
    await sharedPreferences.remove(_keyCompletedSteps);
  }

  // Dismantling step completion

  /// Get list of completed dismantling step IDs
  List<String> getCompletedDismantlingSteps() {
    final stepsList = sharedPreferences.getStringList(_keyCompletedDismantlingSteps);
    return stepsList ?? [];
  }

  /// Mark a dismantling step as completed
  Future<void> markDismantlingStepCompleted(String stepId) async {
    final completedSteps = getCompletedDismantlingSteps();
    if (!completedSteps.contains(stepId)) {
      completedSteps.add(stepId);
      await sharedPreferences.setStringList(_keyCompletedDismantlingSteps, completedSteps);
    }
  }

  /// Mark a dismantling step as incomplete
  Future<void> markDismantlingStepIncomplete(String stepId) async {
    final completedSteps = getCompletedDismantlingSteps();
    completedSteps.remove(stepId);
    await sharedPreferences.setStringList(_keyCompletedDismantlingSteps, completedSteps);
  }

  /// Clear all completed dismantling steps
  Future<void> clearCompletedDismantlingSteps() async {
    await sharedPreferences.remove(_keyCompletedDismantlingSteps);
  }

  // ============================================================================
  // Installation Guide Storage (Educational feature)
  // ============================================================================

  static const _keyLastCompletedSubstepIndex = 'installation_last_completed_substep_index';

  /// Get the last completed substep index (Installation Guide)
  /// Returns -1 if no substep has been completed yet
  int getLastCompletedSubstepIndex() {
    return sharedPreferences.getInt(_keyLastCompletedSubstepIndex) ?? -1;
  }

  /// Set the last completed substep index (Installation Guide)
  /// This marks this substep and all previous substeps as completed
  Future<void> setLastCompletedSubstepIndex(int index) async {
    await sharedPreferences.setInt(_keyLastCompletedSubstepIndex, index);
  }

  /// Check if a substep is completed based on its index (Installation Guide)
  /// A substep is completed if its index is <= last completed index
  bool isSubstepCompletedByIndex(int substepIndex) {
    final lastCompleted = getLastCompletedSubstepIndex();
    return substepIndex <= lastCompleted;
  }

  /// Get count of completed substeps (Installation Guide)
  int getCompletedSubstepsCount() {
    final lastCompleted = getLastCompletedSubstepIndex();
    return lastCompleted + 1; // +1 because index starts at 0
  }

  /// Reset all installation guide progress
  Future<void> resetInstallationGuideProgress() async {
    await sharedPreferences.remove(_keyLastCompletedSubstepIndex);
  }

  /// Get overall progress percentage for installation guide (0.0 to 1.0)
  double getInstallationGuideProgress(int totalSubsteps) {
    if (totalSubsteps == 0) return 0.0;
    final completed = getCompletedSubstepsCount();
    return (completed / totalSubsteps).clamp(0.0, 1.0);
  }
}
