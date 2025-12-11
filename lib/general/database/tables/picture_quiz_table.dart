import 'package:drift/drift.dart';

/// PictureQuiz table - matches iOS PictureQuiz entity (Image references for arguments, quizzes, etc.)
///
/// This entity is shared across multiple tables:
/// - Arguments.thumb (Many-to-One: multiple arguments can share same image)
/// - LicenseTypes.thumb (Many-to-One: multiple license types can share same image)
/// - Manuals.image (Many-to-One: multiple manuals can share same image)
/// - Quizzes.image (stored as text path in Quizzes table, not as relationship)
///
/// Matches iOS PictureQuiz entity with inverse relationships:
/// - argument: toMany relationship back to Argument
/// - license_type: toMany relationship back to LicenseType
/// - manual: toMany relationship back to Manual
@DataClassName('PictureQuizEntity')
class PictureQuizzes extends Table {
  IntColumn get id => integer()();
  TextColumn get image => text().nullable()();
  TextColumn get imageHd => text().nullable()();
  RealColumn get aspectRatio => real().withDefault(const Constant(0.0))();
  TextColumn get symbol => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
