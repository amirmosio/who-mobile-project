import 'package:drift/drift.dart';

/// Facility notes table - user notes for installations
@DataClassName('FacilityNoteEntity')
class FacilityNotes extends Table {
  /// Unique note ID
  TextColumn get noteId => text()();

  /// Installation ID this note belongs to
  TextColumn get installationId => text()();

  /// Step ID (optional - can be general note)
  TextColumn get stepId => text().nullable()();

  /// Component ID (optional)
  TextColumn get componentId => text().nullable()();

  /// Note text content
  TextColumn get noteText => text()();

  /// Type of note (damage, repair, observation, warning)
  TextColumn get noteType =>
      text().withDefault(const Constant('observation'))();

  /// Severity (low, medium, high, critical)
  TextColumn get severity => text().nullable()();

  /// Image URLs (JSON string array)
  TextColumn get imageUrls => text().nullable()();

  /// User ID who created the note
  TextColumn get userId => text().nullable()();

  /// User name who created the note
  TextColumn get userName => text().nullable()();

  /// Creation timestamp
  DateTimeColumn get createdAt => dateTime()();

  /// Last update timestamp
  DateTimeColumn get updatedAt => dateTime().nullable()();

  /// Whether the issue has been resolved
  BoolColumn get isResolved => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {noteId};
}
