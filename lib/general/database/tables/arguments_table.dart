import 'package:drift/drift.dart';
import 'package:who_mobile_project/general/database/tables/picture_quiz_table.dart';

/// Argument table - matches iOS Argument entity (Topics/Categories)
///
/// Relationships (matching iOS CoreData):
/// - thumb: Many-to-One relationship with PictureQuiz (one PictureQuiz can be shared by multiple Arguments)
/// - license_type: Many-to-One relationship with LicenseType
@DataClassName('ArgumentEntity')
class Arguments extends Table {
  IntColumn get id => integer()();
  DateTimeColumn get createdDatetime => dateTime().nullable()();
  BoolColumn get isVideo => boolean().withDefault(const Constant(false))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get modifiedDatetime => dateTime().nullable()();
  TextColumn get name => text().nullable()();
  IntColumn get position => integer().withDefault(const Constant(0))();
  IntColumn get numberQuestion => integer().withDefault(const Constant(0))();
  IntColumn get numberQuizzes => integer().withDefault(const Constant(0))();
  IntColumn get licenseTypeId => integer()();

  /// Foreign key to PictureQuizzes table (thumb relationship)
  /// Matches iOS: @NSManaged var thumb: PictureQuiz?
  IntColumn get thumbId =>
      integer().nullable().references(PictureQuizzes, #id)();

  IntColumn get updateDbId => integer().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
