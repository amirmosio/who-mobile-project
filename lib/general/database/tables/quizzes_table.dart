import 'package:drift/drift.dart';

/// Quiz table - matches iOS Quiz entity
@DataClassName('QuizEntity')
class Quizzes extends Table {
  IntColumn get id => integer()();
  IntColumn get appId => integer()();
  TextColumn get comment => text().nullable()();
  DateTimeColumn get createdDatetime => dateTime().nullable()();
  BoolColumn get hasAnswer => boolean().withDefault(const Constant(false))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get modifiedDatetime => dateTime().nullable()();
  TextColumn get originalId => text().nullable()();
  IntColumn get position => integer().withDefault(const Constant(0))();
  IntColumn get numberExtracted => integer().withDefault(const Constant(0))();
  BoolColumn get result => boolean().withDefault(const Constant(false))();
  TextColumn get symbol => text().nullable()();
  TextColumn get questionText => text().nullable()();
  IntColumn get argumentId => integer()();
  IntColumn get licenseTypeId => integer()();
  IntColumn get manualId => integer().nullable()();
  TextColumn get image => text().nullable()();
  IntColumn get updateDbId => integer().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
