import 'package:drift/drift.dart';

/// Facility installations table - tracks active facility installations
@DataClassName('FacilityInstallationEntity')
class FacilityInstallations extends Table {
  /// Unique installation ID
  TextColumn get installationId => text()();

  /// Facility ID being installed
  TextColumn get facilityId => text()();

  /// Facility name
  TextColumn get facilityName => text()();

  /// Current phase (initial, installing, maintenance, dismantling, completed)
  TextColumn get currentPhase => text()();

  /// Installation start date
  DateTimeColumn get startedAt => dateTime()();

  /// Last update timestamp
  DateTimeColumn get updatedAt => dateTime()();

  /// Expected completion date
  DateTimeColumn get expectedCompletion => dateTime().nullable()();

  /// Actual completion date
  DateTimeColumn get completedAt => dateTime().nullable()();

  /// Total steps in current phase
  IntColumn get totalStepsInPhase => integer()();

  /// Completed steps in current phase
  IntColumn get completedStepsInPhase => integer()();

  /// Overall progress percentage (0-100)
  RealColumn get progressPercentage => real()();

  /// Installation location
  TextColumn get location => text().nullable()();

  /// Team members (JSON string array)
  TextColumn get teamMembers => text().nullable()();

  /// General notes about the installation
  TextColumn get notes => text().nullable()();

  @override
  Set<Column> get primaryKey => {installationId};
}
