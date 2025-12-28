import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';
import 'package:who_mobile_project/general/database/app_database.dart';
import 'package:who_mobile_project/general/models/idtm/idtm_facility.dart';
import 'package:who_mobile_project/general/models/idtm/installation_phase.dart';
import 'package:who_mobile_project/general/models/idtm/progress_tracker.dart';
import 'package:who_mobile_project/general/models/idtm/user_note.dart';
import 'package:who_mobile_project/general/services/idtm_asset_loader.dart';

/// Repository for IDTM guide data operations (local only)
@injectable
class IdtmRepository {
  final AppDatabase _database;
  final IdtmAssetLoader _assetLoader;
  final Uuid _uuid = const Uuid();

  IdtmRepository(this._database, this._assetLoader);

  // ============================================================================
  // Facility Queries
  // ============================================================================

  /// Get all available facilities from assets
  Future<List<IdtmFacility>> getAllFacilities() async {
    return await _assetLoader.loadFacilities();
  }

  /// Get a specific facility by ID
  Future<IdtmFacility?> getFacilityById(String facilityId) async {
    return await _assetLoader.loadFacilityById(facilityId);
  }

  // ============================================================================
  // Installation Queries
  // ============================================================================

  /// Get all installations
  Future<List<FacilityInstallationEntity>> getAllInstallations() async {
    return await _database.select(_database.facilityInstallations).get();
  }

  /// Get installation by ID
  Future<FacilityInstallationEntity?> getInstallationById(
    String installationId,
  ) async {
    return await (_database.select(_database.facilityInstallations)
          ..where((i) => i.installationId.equals(installationId)))
        .getSingleOrNull();
  }

  /// Get active installations (not completed)
  Future<List<FacilityInstallationEntity>> getActiveInstallations() async {
    return await (_database.select(_database.facilityInstallations)
          ..where((i) => i.currentPhase.isNotValue('completed'))
          ..orderBy([(i) => OrderingTerm.desc(i.updatedAt)]))
        .get();
  }

  /// Create new installation
  Future<FacilityInstallationEntity> createInstallation({
    required String facilityId,
    required String facilityName,
    String? location,
    List<String>? teamMembers,
  }) async {
    final installationId = _uuid.v4();
    final now = DateTime.now();

    final companion = FacilityInstallationsCompanion.insert(
      installationId: installationId,
      facilityId: facilityId,
      facilityName: facilityName,
      currentPhase: FacilityInstallationPhase.initial.value,
      startedAt: now,
      updatedAt: now,
      totalStepsInPhase: 0,
      completedStepsInPhase: 0,
      progressPercentage: 0.0,
      location: Value(location),
      teamMembers: Value(teamMembers != null ? jsonEncode(teamMembers) : null),
    );

    await _database.into(_database.facilityInstallations).insert(companion);
    return (await getInstallationById(installationId))!;
  }

  /// Update installation
  Future<void> updateInstallation(
    FacilityInstallationEntity installation,
  ) async {
    await _database.update(_database.facilityInstallations).replace(
          installation.copyWith(updatedAt: DateTime.now()),
        );
  }

  /// Delete installation
  Future<void> deleteInstallation(String installationId) async {
    await (_database.delete(_database.facilityInstallations)
          ..where((i) => i.installationId.equals(installationId)))
        .go();
    // Also delete related progress and notes
    await deleteInstallationProgress(installationId);
    await deleteInstallationNotes(installationId);
  }

  /// Transition to next phase
  Future<void> transitionToNextPhase(String installationId) async {
    final installation = await getInstallationById(installationId);
    if (installation == null) return;

    final currentPhase =
        FacilityInstallationPhase.fromString(installation.currentPhase);
    final nextPhase = currentPhase.nextPhase;

    if (nextPhase != null) {
      await _database.update(_database.facilityInstallations).replace(
            installation.copyWith(
              currentPhase: nextPhase.value,
              completedStepsInPhase: 0, // Reset for new phase
              updatedAt: DateTime.now(),
            ),
          );
    }
  }

  // ============================================================================
  // Progress Tracking
  // ============================================================================

  /// Get progress for an installation
  Future<List<InstallationProgressEntity>> getInstallationProgress(
    String installationId,
  ) async {
    return await (_database.select(_database.installationProgress)
          ..where((p) => p.installationId.equals(installationId)))
        .get();
  }

  /// Get completed steps for installation
  Future<List<InstallationProgressEntity>> getCompletedSteps(
    String installationId,
  ) async {
    return await (_database.select(_database.installationProgress)
          ..where(
            (p) =>
                p.installationId.equals(installationId) &
                p.completed.equals(true),
          ))
        .get();
  }

  /// Mark step as completed
  Future<void> markStepCompleted({
    required String installationId,
    required String stepId,
    String? notes,
    String? completedBy,
    int? timeSpentMinutes,
  }) async {
    final existing = await (_database.select(_database.installationProgress)
          ..where(
            (p) =>
                p.installationId.equals(installationId) &
                p.stepId.equals(stepId),
          ))
        .getSingleOrNull();

    if (existing != null) {
      // Update existing
      await _database.update(_database.installationProgress).replace(
            existing.copyWith(
              completed: true,
              completedAt: Value(DateTime.now()),
              notes: Value(notes),
              completedBy: Value(completedBy),
              timeSpentMinutes: Value(timeSpentMinutes),
            ),
          );
    } else {
      // Insert new
      await _database.into(_database.installationProgress).insert(
            InstallationProgressCompanion.insert(
              installationId: installationId,
              stepId: stepId,
              completed: const Value(true),
              completedAt: Value(DateTime.now()),
              notes: Value(notes),
              completedBy: Value(completedBy),
              timeSpentMinutes: Value(timeSpentMinutes),
            ),
          );
    }
  }

  /// Mark step as incomplete
  Future<void> markStepIncomplete({
    required String installationId,
    required String stepId,
  }) async {
    await (_database.delete(_database.installationProgress)
          ..where(
            (p) =>
                p.installationId.equals(installationId) &
                p.stepId.equals(stepId),
          ))
        .go();
  }

  /// Delete all progress for installation
  Future<void> deleteInstallationProgress(String installationId) async {
    await (_database.delete(_database.installationProgress)
          ..where((p) => p.installationId.equals(installationId)))
        .go();
  }

  /// Get progress tracker with calculated metrics
  Future<ProgressTracker?> getProgressTracker(String installationId) async {
    final installation = await getInstallationById(installationId);
    if (installation == null) return null;

    final progress = await getInstallationProgress(installationId);
    final completed = progress.where((p) => p.completed).toList();

    // Build step completion maps
    final stepCompletionStatus = <String, bool>{};
    final stepCompletionDates = <String, DateTime>{};

    for (final p in progress) {
      stepCompletionStatus[p.stepId] = p.completed;
      if (p.completedAt != null) {
        stepCompletionDates[p.stepId] = p.completedAt!;
      }
    }

    // Parse team members
    List<String>? teamMembers;
    if (installation.teamMembers != null) {
      teamMembers = (jsonDecode(installation.teamMembers!) as List<dynamic>)
          .map((e) => e as String)
          .toList();
    }

    return ProgressTracker(
      installationId: installation.installationId,
      facilityId: installation.facilityId,
      facilityName: installation.facilityName,
      currentPhase:
          FacilityInstallationPhase.fromString(installation.currentPhase),
      startedAt: installation.startedAt,
      updatedAt: installation.updatedAt,
      expectedCompletion: installation.expectedCompletion,
      completedAt: installation.completedAt,
      stepCompletionStatus: stepCompletionStatus,
      stepCompletionDates: stepCompletionDates,
      totalStepsInPhase: installation.totalStepsInPhase,
      completedStepsInPhase: completed.length,
      progressPercentage: installation.progressPercentage,
      location: installation.location,
      teamMembers: teamMembers,
      notes: installation.notes,
    );
  }

  // ============================================================================
  // Notes
  // ============================================================================

  /// Get all notes for an installation
  Future<List<UserNote>> getInstallationNotes(String installationId) async {
    final entities = await (_database.select(_database.facilityNotes)
          ..where((n) => n.installationId.equals(installationId))
          ..orderBy([(n) => OrderingTerm.desc(n.createdAt)]))
        .get();

    return entities.map(_entityToUserNote).toList();
  }

  /// Get notes for a specific step
  Future<List<UserNote>> getStepNotes({
    required String installationId,
    required String stepId,
  }) async {
    final entities = await (_database.select(_database.facilityNotes)
          ..where(
            (n) =>
                n.installationId.equals(installationId) &
                n.stepId.equals(stepId),
          )
          ..orderBy([(n) => OrderingTerm.desc(n.createdAt)]))
        .get();

    return entities.map(_entityToUserNote).toList();
  }

  /// Create a note
  Future<UserNote> createNote(UserNote note) async {
    final noteId = note.id.isEmpty ? _uuid.v4() : note.id;

    await _database.into(_database.facilityNotes).insert(
          FacilityNotesCompanion.insert(
            noteId: noteId,
            installationId: note.installationId,
            stepId: Value(note.stepId),
            componentId: Value(note.componentId),
            noteText: note.noteText,
            noteType: Value(note.noteType),
            severity: Value(note.severity),
            imageUrls: Value(
              note.imageUrls.isNotEmpty ? jsonEncode(note.imageUrls) : null,
            ),
            userId: Value(note.userId),
            userName: Value(note.userName),
            createdAt: note.createdAt,
            updatedAt: Value(note.updatedAt),
            isResolved: Value(note.isResolved),
          ),
        );

    final entity = await (_database.select(_database.facilityNotes)
          ..where((n) => n.noteId.equals(noteId)))
        .getSingle();

    return _entityToUserNote(entity);
  }

  /// Update a note
  Future<void> updateNote(UserNote note) async {
    final entity = await (_database.select(_database.facilityNotes)
          ..where((n) => n.noteId.equals(note.id)))
        .getSingleOrNull();

    if (entity != null) {
      await _database.update(_database.facilityNotes).replace(
            entity.copyWith(
              noteText: note.noteText,
              noteType: note.noteType,
              severity: Value(note.severity),
              imageUrls: Value(note.imageUrls.isNotEmpty
                  ? jsonEncode(note.imageUrls)
                  : null),
              updatedAt: Value(DateTime.now()),
              isResolved: note.isResolved,
            ),
          );
    }
  }

  /// Delete a note
  Future<void> deleteNote(String noteId) async {
    await (_database.delete(_database.facilityNotes)
          ..where((n) => n.noteId.equals(noteId)))
        .go();
  }

  /// Delete all notes for installation
  Future<void> deleteInstallationNotes(String installationId) async {
    await (_database.delete(_database.facilityNotes)
          ..where((n) => n.installationId.equals(installationId)))
        .go();
  }

  /// Convert entity to UserNote model
  UserNote _entityToUserNote(FacilityNoteEntity entity) {
    List<String> imageUrls = [];
    if (entity.imageUrls != null) {
      imageUrls = (jsonDecode(entity.imageUrls!) as List<dynamic>)
          .map((e) => e as String)
          .toList();
    }

    return UserNote(
      id: entity.noteId,
      installationId: entity.installationId,
      stepId: entity.stepId,
      componentId: entity.componentId,
      noteText: entity.noteText,
      noteType: entity.noteType,
      severity: entity.severity,
      imageUrls: imageUrls,
      userId: entity.userId,
      userName: entity.userName,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      isResolved: entity.isResolved,
    );
  }

  // ============================================================================
  // Component Checklist
  // ============================================================================

  /// Get checklist for installation
  Future<List<ComponentChecklistEntity>> getComponentChecklist(
    String installationId,
  ) async {
    return await (_database.select(_database.componentChecklist)
          ..where((c) => c.installationId.equals(installationId)))
        .get();
  }

  /// Mark component as verified
  Future<void> verifyComponent({
    required String installationId,
    required String componentId,
    required String componentName,
    required int quantityRequired,
    int? quantityVerified,
    String? condition,
    String? notes,
    String? imageUrl,
    String? verifiedBy,
  }) async {
    final existing = await (_database.select(_database.componentChecklist)
          ..where(
            (c) =>
                c.installationId.equals(installationId) &
                c.componentId.equals(componentId),
          ))
        .getSingleOrNull();

    if (existing != null) {
      await _database.update(_database.componentChecklist).replace(
            existing.copyWith(
              verified: true,
              verifiedAt: Value(DateTime.now()),
              condition: Value(condition),
              quantityVerified: Value(quantityVerified ?? quantityRequired),
              notes: Value(notes),
              imageUrl: Value(imageUrl),
              verifiedBy: Value(verifiedBy),
            ),
          );
    } else {
      await _database.into(_database.componentChecklist).insert(
            ComponentChecklistCompanion.insert(
              installationId: installationId,
              componentId: componentId,
              componentName: componentName,
              quantityRequired: quantityRequired,
              verified: const Value(true),
              verifiedAt: Value(DateTime.now()),
              condition: Value(condition),
              quantityVerified: Value(quantityVerified ?? quantityRequired),
              notes: Value(notes),
              imageUrl: Value(imageUrl),
              verifiedBy: Value(verifiedBy),
            ),
          );
    }
  }

  /// Unverify component
  Future<void> unverifyComponent({
    required String installationId,
    required String componentId,
  }) async {
    await (_database.delete(_database.componentChecklist)
          ..where(
            (c) =>
                c.installationId.equals(installationId) &
                c.componentId.equals(componentId),
          ))
        .go();
  }
}
