import 'package:drift/drift.dart';

/// Component checklist table - tracks component verification status
@DataClassName('ComponentChecklistEntity')
class ComponentChecklist extends Table {
  /// Auto-increment ID
  IntColumn get id => integer().autoIncrement()();

  /// Installation ID this checklist belongs to
  TextColumn get installationId => text()();

  /// Component ID
  TextColumn get componentId => text()();

  /// Component name
  TextColumn get componentName => text()();

  /// Whether the component has been verified
  BoolColumn get verified => boolean().withDefault(const Constant(false))();

  /// Verification timestamp
  DateTimeColumn get verifiedAt => dateTime().nullable()();

  /// Component condition (excellent, good, acceptable, damaged)
  TextColumn get condition => text().nullable()();

  /// Quantity verified
  IntColumn get quantityVerified => integer().nullable()();

  /// Quantity required
  IntColumn get quantityRequired => integer()();

  /// Notes about the component
  TextColumn get notes => text().nullable()();

  /// Image URL of verified component
  TextColumn get imageUrl => text().nullable()();

  /// User who verified
  TextColumn get verifiedBy => text().nullable()();
}
