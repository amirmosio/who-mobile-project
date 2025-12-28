import 'package:drift/drift.dart';

/// Installation progress table - tracks completion status of individual steps
@DataClassName('InstallationProgressEntity')
class InstallationProgress extends Table {
  /// Auto-increment ID
  IntColumn get id => integer().autoIncrement()();

  /// Installation ID this progress belongs to
  TextColumn get installationId => text()();

  /// Step ID
  TextColumn get stepId => text()();

  /// Whether the step is completed
  BoolColumn get completed => boolean().withDefault(const Constant(false))();

  /// Completion timestamp
  DateTimeColumn get completedAt => dateTime().nullable()();

  /// Notes specific to this step completion
  TextColumn get notes => text().nullable()();

  /// User who completed the step
  TextColumn get completedBy => text().nullable()();

  /// Time spent on this step (in minutes)
  IntColumn get timeSpentMinutes => integer().nullable()();
}
