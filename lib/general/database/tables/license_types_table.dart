import 'package:drift/drift.dart';

/// License Type table
@DataClassName('LicenseTypeEntity')
class LicenseTypes extends Table {
  IntColumn get id => integer()();
  TextColumn get name => text()();
  TextColumn get code => text().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  BoolColumn get hasAnswer => boolean().withDefault(const Constant(false))();
  BoolColumn get hasBook => boolean().withDefault(const Constant(false))();
  BoolColumn get hasEbook => boolean().withDefault(const Constant(false))();
  BoolColumn get isRevision => boolean().withDefault(const Constant(false))();
  IntColumn get maxNumberError => integer().withDefault(const Constant(0))();
  IntColumn get numberAnswer => integer().withDefault(const Constant(0))();
  IntColumn get numberQuestion => integer().withDefault(const Constant(0))();
  IntColumn get numberQuizzes => integer().withDefault(const Constant(0))();
  IntColumn get position => integer().withDefault(const Constant(0))();
  IntColumn get thumbId => integer().nullable()();
  IntColumn get updateDbId => integer().nullable()();
  DateTimeColumn get createdDatetime => dateTime().nullable()();
  DateTimeColumn get modifiedDatetime => dateTime().nullable()();
  RealColumn get duration => real().withDefault(const Constant(0.0))();
  TextColumn get note => text().nullable()();

  // Additional fields from API response
  TextColumn get children =>
      text().withDefault(const Constant('[]'))(); // JSON array as string
  TextColumn get languages =>
      text().withDefault(const Constant('[]'))(); // JSON array as string

  @override
  Set<Column> get primaryKey => {id};
}
