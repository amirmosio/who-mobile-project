import 'package:drift/drift.dart';

/// Sheet table - matches iOS Sheet entity (Exam sheets/simulations)
@DataClassName('SheetEntity')
class Sheets extends Table {
  IntColumn get id => integer().autoIncrement()(); // Local autoincrement ID
  IntColumn get serverId => integer()
      .nullable()(); // Server-assigned ID (null = offline, >0 = synced)
  TextColumn get groupCode => text().nullable()();
  DateTimeColumn get createdDatetime => dateTime().nullable()();
  DateTimeColumn get modifiedDatetime => dateTime().nullable()();
  RealColumn get duration => real().withDefault(const Constant(0.0))();
  DateTimeColumn get endDatetime => dateTime().nullable()();
  DateTimeColumn get expirationDatetime => dateTime().nullable()();
  BoolColumn get hasAnswer => boolean().withDefault(const Constant(false))();
  BoolColumn get isExecuted => boolean().withDefault(const Constant(false))();
  BoolColumn get isPassed => boolean().withDefault(const Constant(false))();
  BoolColumn get hasIncrementedCount =>
      boolean().withDefault(const Constant(false))();
  IntColumn get maxNumberError => integer().withDefault(const Constant(0))();
  IntColumn get numberCorrectQuestion =>
      integer().withDefault(const Constant(0))();
  IntColumn get numberErrorQuestion =>
      integer().withDefault(const Constant(0))();
  IntColumn get numberEmptyQuestion =>
      integer().withDefault(const Constant(0))();
  IntColumn get numberQuestion => integer().withDefault(const Constant(0))();
  TextColumn get quizzes =>
      text()(); // Stored as JSON string: [[quiz_id, user_answer]]
  DateTimeColumn get startDatetime => dateTime().nullable()();
  IntColumn get executionTime => integer().withDefault(const Constant(0))();
  IntColumn get type => integer().withDefault(const Constant(0))();
  IntColumn get student => integer().nullable()();
  IntColumn get teacher => integer().nullable()();
  IntColumn get licenseTypeId => integer()();
}
