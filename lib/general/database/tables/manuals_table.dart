import 'package:drift/drift.dart';

/// Manual table - matches iOS Manual entity
@DataClassName('ManualEntity')
class Manuals extends Table {
  IntColumn get id => integer()();
  TextColumn get alt => text().nullable()();
  DateTimeColumn get createdDatetime => dateTime().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get modifiedDatetime => dateTime().nullable()();
  TextColumn get note => text().nullable()();
  IntColumn get position => integer().withDefault(const Constant(0))();
  TextColumn get symbol => text().nullable()();
  TextColumn get content => text().nullable()();
  TextColumn get title => text().nullable()();
  TextColumn get url => text().nullable()();
  TextColumn get summary => text().nullable()();
  IntColumn get argumentId => integer()();
  IntColumn get licenseTypeId => integer()();
  IntColumn get image => integer().nullable()();
  IntColumn get updateDbId => integer().nullable()();
  IntColumn get video => integer().nullable()();
  IntColumn get fokArgumentId => integer().nullable()();

  // Additional fields from API response
  IntColumn get appId => integer().nullable()();
  IntColumn get videoOriginalId => integer().nullable()();

  // Manual completion tracking
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get completedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id, licenseTypeId};
}
