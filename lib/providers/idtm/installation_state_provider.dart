import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:who_mobile_project/general/models/idtm/installation_phase.dart';
import 'package:who_mobile_project/general/models/idtm/progress_tracker.dart';
import 'package:who_mobile_project/providers/base/base_api_notifier.dart';
import 'package:who_mobile_project/providers/base/base_api_state.dart';
import 'package:who_mobile_project/providers/idtm/idtm_repository_provider.dart';
import 'package:who_mobile_project/repository/idtm_repository.dart';
import 'package:who_mobile_project/repository/repo_state.dart';

part 'installation_state_provider.g.dart';

/// Provider for managing installation state and progress
@Riverpod(keepAlive: true)
class InstallationState extends BaseApiNotifier<BaseApiState> {
  late final IdtmRepository _repository;

  @override
  BaseApiState build() {
    _repository = ref.read(idtmRepositoryProvider);
    return const BaseApiInitial();
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
      return successState.data as String;
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
  Future<bool> transitionToNextPhase(String installationId) async {
    return executeOperationAndSetState(
      () async {
        await _repository.transitionToNextPhase(installationId);
        return SuccessState(true, null);
      },
      successMessage: 'Transitioned to next phase',
      onSuccess: () => loadProgress(installationId),
    );
  }

  /// Delete installation
  Future<bool> deleteInstallation(String installationId) async {
    return executeOperationAndSetState(
      () async {
        await _repository.deleteInstallation(installationId);
        return SuccessState(true, null);
      },
      successMessage: 'Installation deleted',
    );
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
