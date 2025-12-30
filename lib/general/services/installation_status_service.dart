import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:who_mobile_project/general/models/idtm/installation_phase.dart';

/// Service for managing installation status in SharedPreferences
@singleton
class InstallationStatusService {
  static const String _keyInstallationPhase = 'installation_phase';
  static const String _keyInstallationId = 'installation_id';
  static const String _keyFacilityId = 'facility_id';
  static const String _keyFacilityName = 'facility_name';
  static const String _keyCompletedSteps = 'completed_installation_steps';
  static const String _keyCompletedDismantlingSteps = 'completed_dismantling_steps';

  final SharedPreferences _prefs;

  InstallationStatusService(this._prefs);

  /// Get current installation phase
  FacilityInstallationPhase getCurrentPhase() {
    final phaseString = _prefs.getString(_keyInstallationPhase);
    if (phaseString == null) {
      return FacilityInstallationPhase.initial;
    }
    return FacilityInstallationPhase.fromString(phaseString);
  }

  /// Set current installation phase
  Future<void> setCurrentPhase(FacilityInstallationPhase phase) async {
    await _prefs.setString(_keyInstallationPhase, phase.value);
  }

  /// Get installation ID
  String? getInstallationId() {
    return _prefs.getString(_keyInstallationId);
  }

  /// Set installation ID
  Future<void> setInstallationId(String? id) async {
    if (id == null) {
      await _prefs.remove(_keyInstallationId);
    } else {
      await _prefs.setString(_keyInstallationId, id);
    }
  }

  /// Get facility ID
  String? getFacilityId() {
    return _prefs.getString(_keyFacilityId);
  }

  /// Set facility ID
  Future<void> setFacilityId(String? id) async {
    if (id == null) {
      await _prefs.remove(_keyFacilityId);
    } else {
      await _prefs.setString(_keyFacilityId, id);
    }
  }

  /// Get facility name
  String? getFacilityName() {
    return _prefs.getString(_keyFacilityName);
  }

  /// Set facility name
  Future<void> setFacilityName(String? name) async {
    if (name == null) {
      await _prefs.remove(_keyFacilityName);
    } else {
      await _prefs.setString(_keyFacilityName, name);
    }
  }

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
  Future<void> reset() async {
    await _prefs.remove(_keyInstallationPhase);
    await _prefs.remove(_keyInstallationId);
    await _prefs.remove(_keyFacilityId);
    await _prefs.remove(_keyFacilityName);
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
    final stepsList = _prefs.getStringList(_keyCompletedSteps);
    return stepsList ?? [];
  }

  /// Mark an installation step as completed
  Future<void> markStepCompleted(String stepId) async {
    final completedSteps = getCompletedSteps();
    if (!completedSteps.contains(stepId)) {
      completedSteps.add(stepId);
      await _prefs.setStringList(_keyCompletedSteps, completedSteps);
    }
  }

  /// Mark an installation step as incomplete
  Future<void> markStepIncomplete(String stepId) async {
    final completedSteps = getCompletedSteps();
    completedSteps.remove(stepId);
    await _prefs.setStringList(_keyCompletedSteps, completedSteps);
  }

  /// Clear all completed installation steps
  Future<void> clearCompletedSteps() async {
    await _prefs.remove(_keyCompletedSteps);
  }

  /// Get list of completed dismantling step IDs
  List<String> getCompletedDismantlingSteps() {
    final stepsList = _prefs.getStringList(_keyCompletedDismantlingSteps);
    return stepsList ?? [];
  }

  /// Mark a dismantling step as completed
  Future<void> markDismantlingStepCompleted(String stepId) async {
    final completedSteps = getCompletedDismantlingSteps();
    if (!completedSteps.contains(stepId)) {
      completedSteps.add(stepId);
      await _prefs.setStringList(_keyCompletedDismantlingSteps, completedSteps);
    }
  }

  /// Mark a dismantling step as incomplete
  Future<void> markDismantlingStepIncomplete(String stepId) async {
    final completedSteps = getCompletedDismantlingSteps();
    completedSteps.remove(stepId);
    await _prefs.setStringList(_keyCompletedDismantlingSteps, completedSteps);
  }

  /// Clear all completed dismantling steps
  Future<void> clearCompletedDismantlingSteps() async {
    await _prefs.remove(_keyCompletedDismantlingSteps);
  }
}
