import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:who_mobile_project/general/models/idtm/installation_phase.dart';
import 'package:who_mobile_project/general/models/idtm/progress_tracker.dart';
import 'package:who_mobile_project/general/services/storage/storage_manager.dart';
import 'package:who_mobile_project/providers/auth/current_user_provider.dart';
import 'package:who_mobile_project/providers/base/base_api_notifier.dart';
import 'package:who_mobile_project/providers/base/base_api_state.dart';
import 'package:who_mobile_project/providers/idtm/idtm_repository_provider.dart';
import 'package:who_mobile_project/providers/maintenance/scheduled_alerts_provider.dart';
import 'package:who_mobile_project/repository/idtm_repository.dart';
import 'package:who_mobile_project/repository/repo_state.dart';
import 'package:who_mobile_project/services/firebase/firebase_auth_service.dart';

part 'installation_state_provider.g.dart';

/// Provider for managing installation state and progress
@Riverpod(keepAlive: true)
class InstallationState extends BaseApiNotifier<BaseApiState> {
  late final IdtmRepository _repository;
  late final FirebaseAuthService _authService;
  late final StorageManager _storageManager;

  @override
  BaseApiState build() {
    _repository = ref.read(idtmRepositoryProvider);
    _authService = GetIt.instance<FirebaseAuthService>();
    _storageManager = GetIt.instance<StorageManager>();
    return const BaseApiInitial();
  }

  /// Sync installation state to Firebase for persistence across devices
  Future<void> _syncToFirebase(FacilityInstallationPhase phase) async {
    try {
      final currentUser = await ref.read(currentUserProvider.future);
      if (!currentUser.isAuthenticated || currentUser.uid == null) return;

      await _authService.updateInstallationState(
        currentUser.uid!,
        phase: phase.value,
        installationId: _storageManager.getInstallationId(),
        facilityId: _storageManager.getFacilityId(),
        facilityName: _storageManager.getFacilityName(),
      );
    } catch (e) {
      // Silently fail - Firebase sync is not critical
      debugPrint('Failed to sync installation state to Firebase: $e');
    }
  }

  /// Clear installation state from Firebase
  Future<void> _clearFirebaseState() async {
    try {
      final currentUser = await ref.read(currentUserProvider.future);
      if (!currentUser.isAuthenticated || currentUser.uid == null) return;

      await _authService.clearInstallationState(currentUser.uid!);
    } catch (e) {
      // Silently fail - Firebase sync is not critical
      debugPrint('Failed to clear installation state from Firebase: $e');
    }
  }

  /// Create a new installation
  Future<String?> createInstallation({
    required String facilityId,
    required String facilityName,
    String? location,
    List<String>? teamMembers,
  }) async {
    final result = await executeOperationAndSetState(
      () async {
        final installation = await _repository.createInstallation(
          facilityId: facilityId,
          facilityName: facilityName,
          location: location,
          teamMembers: teamMembers,
        );
        return SuccessState(installation.installationId, null);
      },
      successMessage: 'Installation created successfully',
    );

    if (result) {
      // Return installation ID from success state
      final successState = state as BaseApiSuccess;
      final installationId = successState.data as String;

      // Sync to Firebase (creating installation sets phase to 'installing')
      await _syncToFirebase(FacilityInstallationPhase.installing);

      return installationId;
    }
    return null;
  }

  /// Load installation progress
  Future<ProgressTracker?> loadProgress(String installationId) async {
    return executeApiCallAndSetState<ProgressTracker>(
      () async {
        final progress = await _repository.getProgressTracker(installationId);
        if (progress == null) {
          return ErrorState(
            RepositoryException(
              message: 'Installation not found',
              error: null,
            ),
          );
        }
        return SuccessState(progress, null);
      },
      loadingMessage: 'Loading progress...',
      successMessage: 'Progress loaded',
    );
  }

  /// Mark a step as completed
  Future<bool> completeStep({
    required String installationId,
    required String stepId,
    String? notes,
    String? completedBy,
    int? timeSpentMinutes,
  }) async {
    return executeOperationAndSetState(
      () async {
        await _repository.markStepCompleted(
          installationId: installationId,
          stepId: stepId,
          notes: notes,
          completedBy: completedBy,
          timeSpentMinutes: timeSpentMinutes,
        );
        return SuccessState(true, null);
      },
      successMessage: 'Step marked as completed',
      onSuccess: () => loadProgress(installationId),
    );
  }

  /// Mark a step as incomplete
  Future<bool> uncompleteStep({
    required String installationId,
    required String stepId,
  }) async {
    return executeOperationAndSetState(
      () async {
        await _repository.markStepIncomplete(
          installationId: installationId,
          stepId: stepId,
        );
        return SuccessState(true, null);
      },
      successMessage: 'Step marked as incomplete',
      onSuccess: () => loadProgress(installationId),
    );
  }

  /// Transition to next phase
  /// Auto-schedules maintenance alerts when entering maintenance phase
  /// Syncs new phase to Firebase for cross-device persistence
  Future<bool> transitionToNextPhase(String installationId) async {
    final result = await executeOperationAndSetState(
      () async {
        await _repository.transitionToNextPhase(installationId);

        // Check if entering maintenance phase and schedule alerts
        final progress = await _repository.getProgressTracker(installationId);
        if (progress?.currentPhase == FacilityInstallationPhase.maintenance) {
          debugPrint(
            'Entering maintenance phase for facility: ${progress!.facilityId}',
          );
          // Schedule maintenance alerts for this facility
          await ref
              .read(scheduledAlertsProvider.notifier)
              .scheduleAlertsForFacility(
                installationId: installationId,
                facilityId: progress.facilityId,
              );
        }

        return SuccessState(true, null);
      },
      successMessage: 'Transitioned to next phase',
      onSuccess: () => loadProgress(installationId),
    );

    if (result) {
      // Sync new phase to Firebase
      final newPhase = _storageManager.getCurrentPhase();
      await _syncToFirebase(newPhase);
    }

    return result;
  }

  /// Delete installation
  /// Also clears Firebase state
  Future<bool> deleteInstallation(String installationId) async {
    final result = await executeOperationAndSetState(
      () async {
        await _repository.deleteInstallation(installationId);
        return SuccessState(true, null);
      },
      successMessage: 'Installation deleted',
    );

    if (result) {
      // Clear Firebase state
      await _clearFirebaseState();
    }

    return result;
  }

  /// Get current phase
  FacilityInstallationPhase? getCurrentPhase() {
    if (state is BaseApiSuccess<ProgressTracker>) {
      final progress = (state as BaseApiSuccess<ProgressTracker>).data;
      return progress.currentPhase;
    }
    return null;
  }
}
