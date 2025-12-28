import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:who_mobile_project/general/models/idtm/user_note.dart';
import 'package:who_mobile_project/providers/idtm/idtm_repository_provider.dart';

part 'notes_provider.g.dart';

/// Provider for managing installation notes with optimistic updates
@riverpod
class InstallationNotes extends _$InstallationNotes {
  @override
  Future<List<UserNote>> build(String installationId) async {
    final repository = ref.watch(idtmRepositoryProvider);
    return repository.getInstallationNotes(installationId);
  }

  /// Refresh notes list
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(idtmRepositoryProvider).getInstallationNotes(installationId),
    );
  }

  /// Create a new note with optimistic update
  Future<void> createNote(UserNote note) async {
    final current = state.value ?? [];

    // Optimistic update
    state = AsyncData([note, ...current]);

    try {
      final created = await ref.read(idtmRepositoryProvider).createNote(note);
      if (!ref.mounted) return;

      // Replace temp note with actual created note
      final list = List<UserNote>.from(state.value ?? []);
      final index = list.indexWhere((n) => n.id == note.id);
      if (index >= 0) {
        list[index] = created;
      }
      state = AsyncData(list);
    } catch (e, st) {
      if (!ref.mounted) return;
      state = AsyncData(current); // Rollback
      state = AsyncError(e, st);
    }
  }

  /// Update an existing note
  Future<void> updateNote(UserNote note) async {
    final current = state.value ?? [];

    // Optimistic update
    final list = List<UserNote>.from(current);
    final index = list.indexWhere((n) => n.id == note.id);
    if (index >= 0) {
      list[index] = note;
      state = AsyncData(list);
    }

    try {
      await ref.read(idtmRepositoryProvider).updateNote(note);
    } catch (e, st) {
      if (!ref.mounted) return;
      state = AsyncData(current); // Rollback
      state = AsyncError(e, st);
    }
  }

  /// Delete a note with optimistic update
  Future<void> deleteNote(String noteId) async {
    final current = state.value ?? [];

    // Optimistic delete
    state = AsyncData(current.where((n) => n.id != noteId).toList());

    try {
      await ref.read(idtmRepositoryProvider).deleteNote(noteId);
    } catch (e, st) {
      if (!ref.mounted) return;
      state = AsyncData(current); // Rollback
      state = AsyncError(e, st);
    }
  }
}

/// Provider for step-specific notes
@riverpod
class StepNotes extends _$StepNotes {
  @override
  Future<List<UserNote>> build({
    required String installationId,
    required String stepId,
  }) async {
    final repository = ref.watch(idtmRepositoryProvider);
    return repository.getStepNotes(
      installationId: installationId,
      stepId: stepId,
    );
  }

  /// Refresh step notes
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(idtmRepositoryProvider).getStepNotes(
            installationId: installationId,
            stepId: stepId,
          ),
    );
  }
}
