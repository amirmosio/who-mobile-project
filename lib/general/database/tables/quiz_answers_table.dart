import 'package:drift/drift.dart';

/// Quiz answer options (multiple choice answers A, B, C, D for a quiz)
/// Matches iOS QuizAnswer entity
@DataClassName('QuizAnswerEntity')
class QuizAnswers extends Table {
  IntColumn get id => integer()();
  TextColumn get answerText => text().nullable()();
  IntColumn get position => integer().nullable()();
  DateTimeColumn get createdDatetime => dateTime().nullable()();
  DateTimeColumn get modifiedDatetime => dateTime().nullable()();
  BoolColumn get isCorrect => boolean().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  IntColumn get licenseTypeId => integer()();
  IntColumn get quizId => integer()();
  IntColumn get updateDbId => integer().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
