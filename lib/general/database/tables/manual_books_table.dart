import 'package:drift/drift.dart';

@DataClassName('ManualBookEntity')
class ManualBooks extends Table {
  IntColumn get id => integer()();
  DateTimeColumn get createdDatetime => dateTime().nullable()();
  DateTimeColumn get modifiedDatetime => dateTime().nullable()();
  IntColumn get argument => integer().nullable()(); // Topic/Argument ID
  BoolColumn get hasBeenScanned =>
      boolean().withDefault(const Constant(false))();

  TextColumn get manuals => text().nullable()();

  IntColumn get updateDbId => integer().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
