import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:who_mobile_project/providers/maintenance/alert_repository_provider.dart';
import 'package:who_mobile_project/repository/maintenance/alert_template_repository.dart';
import 'package:who_mobile_project/repository/repo_state.dart' as repo;

part 'scheduled_alerts_provider.g.dart';

/// State for tracking scheduled alerts
class ScheduledAlertsState {
  final Map<String, List<int>> scheduledByInstallation;
  final bool isScheduling;
  final String? error;

  const ScheduledAlertsState({
    this.scheduledByInstallation = const {},
    this.isScheduling = false,
    this.error,
  });

  ScheduledAlertsState copyWith({
    Map<String, List<int>>? scheduledByInstallation,
    bool? isScheduling,
    String? error,
  }) {
    return ScheduledAlertsState(
      scheduledByInstallation:
          scheduledByInstallation ?? this.scheduledByInstallation,
      isScheduling: isScheduling ?? this.isScheduling,
      error: error,
    );
  }

  bool hasScheduledAlerts(String installationId) {
    final ids = scheduledByInstallation[installationId];
    return ids != null && ids.isNotEmpty;
  }

  int getScheduledCount(String installationId) {
    return scheduledByInstallation[installationId]?.length ?? 0;
  }
}

/// Notifier for managing scheduled maintenance alerts
/// Called when entering maintenance phase to schedule alerts
/// Called on logout to cancel all alerts
@Riverpod(keepAlive: true)
class ScheduledAlertsNotifier extends _$ScheduledAlertsNotifier {
  late final AlertTemplateRepository _repository;

  @override
  ScheduledAlertsState build() {
    _repository = ref.read(alertTemplateRepositoryProvider);
    return const ScheduledAlertsState();
  }

  /// Schedule alerts for a facility when entering maintenance phase
  /// Called from installation_state_provider when transitioning to maintenance
  Future<bool> scheduleAlertsForFacility({
    required String installationId,
    required String facilityId,
  }) async {
    state = state.copyWith(isScheduling: true, error: null);

    try {
      final result = await _repository.scheduleAlertsForFacility(
        installationId: installationId,
        facilityId: facilityId,
      );

      if (result is repo.SuccessState) {
        final scheduledIds = result.data as List<int>? ?? [];
        final newMap = Map<String, List<int>>.from(state.scheduledByInstallation);
        newMap[installationId] = scheduledIds;

        state = state.copyWith(
          scheduledByInstallation: newMap,
          isScheduling: false,
        );

        debugPrint(
          'Scheduled ${scheduledIds.length} alerts for installation: $installationId',
        );
        return true;
      } else {
        state = state.copyWith(
          isScheduling: false,
          error: 'Failed to schedule alerts',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isScheduling: false,
        error: 'Error scheduling alerts: $e',
      );
      return false;
    }
  }

  /// Cancel alerts for a specific installation
  Future<void> cancelAlertsForInstallation(String installationId) async {
    await _repository.cancelAlertsForInstallation(installationId);

    final newMap = Map<String, List<int>>.from(state.scheduledByInstallation);
    newMap.remove(installationId);

    state = state.copyWith(scheduledByInstallation: newMap);
    debugPrint('Cancelled alerts for installation: $installationId');
  }

  /// Cancel all scheduled alerts (called on logout)
  Future<void> cancelAllAlerts() async {
    await _repository.cancelAllAlerts();
    state = const ScheduledAlertsState();
    debugPrint('Cancelled all maintenance alerts');
  }
}
