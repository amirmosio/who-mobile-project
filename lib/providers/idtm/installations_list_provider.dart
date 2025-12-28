import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:who_mobile_project/general/models/idtm/progress_tracker.dart';
import 'package:who_mobile_project/providers/idtm/idtm_repository_provider.dart';

part 'installations_list_provider.g.dart';

/// Provider for list of all installations with progress
@riverpod
class InstallationsList extends _$InstallationsList {
  @override
  Future<List<ProgressTracker>> build() async {
    final repository = ref.watch(idtmRepositoryProvider);
    final installations = await repository.getAllInstallations();

    // Convert to progress trackers
    final List<ProgressTracker> trackers = [];
    for (final installation in installations) {
      final tracker = await repository.getProgressTracker(
        installation.installationId,
      );
      if (tracker != null) {
        trackers.add(tracker);
      }
    }
    return trackers;
  }

  /// Refresh installations list
  Future<void> refresh() async {
    state = const AsyncLoading();
    final repository = ref.read(idtmRepositoryProvider);

    state = await AsyncValue.guard(() async {
      final installations = await repository.getAllInstallations();
      final List<ProgressTracker> trackers = [];
      for (final installation in installations) {
        final tracker = await repository.getProgressTracker(
          installation.installationId,
        );
        if (tracker != null) {
          trackers.add(tracker);
        }
      }
      return trackers;
    });
  }

  /// Get active installations only
  Future<void> loadActive() async {
    state = const AsyncLoading();
    final repository = ref.read(idtmRepositoryProvider);

    state = await AsyncValue.guard(() async {
      final installations = await repository.getActiveInstallations();
      final List<ProgressTracker> trackers = [];
      for (final installation in installations) {
        final tracker = await repository.getProgressTracker(
          installation.installationId,
        );
        if (tracker != null) {
          trackers.add(tracker);
        }
      }
      return trackers;
    });
  }
}
