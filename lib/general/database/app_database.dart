import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart' as sqlite3pkg;

// Table imports
import 'tables/quizzes_table.dart';
import 'tables/arguments_table.dart';
import 'tables/manuals_table.dart';
import 'tables/sheets_table.dart';
import 'tables/license_types_table.dart';
import 'tables/quiz_answers_table.dart';
import 'tables/manual_books_table.dart';
import 'tables/picture_quiz_table.dart';
import 'tables/redvertising_campaigns_table.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Quizzes,
    Arguments,
    Manuals,
    Sheets,
    LicenseTypes,
    QuizAnswers,
    ManualBooks,
    PictureQuizzes,
    RedvertisingCampaigns,
    RedvertisingImageSets,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// Reset database by deleting all database files
  Future<void> resetDatabase() async {
    // Use Library directory on iOS, Documents on Android
    final dbFolder = Platform.isIOS
        ? await getLibraryDirectory()
        : await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'app_database.db'));

    try {
      await close();
      debugPrint('✅ Database closed');
    } catch (e) {
      debugPrint('⚠️ Error closing database during reset: $e');
    }

    // CRITICAL: Wait for file handles to be fully released
    // In release mode with SQLCipher, this is essential
    await Future.delayed(const Duration(milliseconds: 500));

    // Delete all database files with retry logic
    int retries = 3;
    for (int i = 0; i < retries; i++) {
      try {
        if (await file.exists()) {
          await file.delete();
          debugPrint('✅ Deleted main database file');
        }

        // Delete journal file (DELETE mode uses -journal, not -wal/-shm)
        final journalFile = File('${file.path}-journal');
        if (await journalFile.exists()) {
          await journalFile.delete();
          debugPrint('✅ Deleted journal file');
        }

        // Clean up any legacy WAL files from previous versions
        final walFile = File('${file.path}-wal');
        if (await walFile.exists()) {
          await walFile.delete();
          debugPrint('✅ Deleted WAL file');
        }

        final shmFile = File('${file.path}-shm');
        if (await shmFile.exists()) {
          await shmFile.delete();
          debugPrint('✅ Deleted SHM file');
        }

        // If we got here, deletion was successful
        break;
      } catch (e) {
        if (i == retries - 1) {
          debugPrint(
            '❌ Error deleting database files after $retries attempts: $e',
          );
          rethrow;
        }
        debugPrint(
          '⚠️ Retry ${i + 1}/$retries: Error deleting files, waiting...',
        );
        await Future.delayed(const Duration(milliseconds: 300));
      }
    }

    // Extra wait to ensure file system has fully processed the deletions
    await Future.delayed(const Duration(milliseconds: 300));

    debugPrint(
      '✅ Database reset completed. Database will be recreated on next access.',
    );
  }

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      // No migrations - we manually reset when needed
    },
  );

  // ============================================================================
  // Quiz Queries
  // ============================================================================

  /// Get all quizzes for a license type
  Future<List<QuizEntity>> getQuizzesByLicenseType(int licenseTypeId) {
    return (select(quizzes)..where(
          (q) =>
              q.licenseTypeId.equals(licenseTypeId) & q.isActive.equals(true),
        ))
        .get();
  }

  /// Get quizzes by argument ID
  Future<List<QuizEntity>> getQuizzesByArgument(
    int licenseTypeId,
    int argumentId,
  ) {
    return (select(quizzes)..where(
          (q) =>
              q.licenseTypeId.equals(licenseTypeId) &
              q.argumentId.equals(argumentId) &
              q.isActive.equals(true),
        ))
        .get();
  }

  /// Get quizzes by manual ID
  Future<List<QuizEntity>> getQuizzesByManual(int licenseTypeId, int manualId) {
    return (select(quizzes)..where(
          (q) =>
              q.licenseTypeId.equals(licenseTypeId) &
              q.manualId.equals(manualId) &
              q.isActive.equals(true),
        ))
        .get();
  }

  /// Get quiz answers by quiz ID
  Future<List<QuizAnswerEntity>> getQuizAnswersByQuizId(int quizId) {
    return (select(quizAnswers)
          ..where((qa) => qa.quizId.equals(quizId) & qa.isActive.equals(true))
          ..orderBy([(qa) => OrderingTerm.asc(qa.position)]))
        .get();
  }

  /// Get quiz by ID
  Future<QuizEntity?> getQuizById(int id, int licenseTypeId) {
    return (select(quizzes)..where(
          (q) => q.id.equals(id) & q.licenseTypeId.equals(licenseTypeId),
        ))
        .getSingleOrNull();
  }

  /// Insert or update quiz
  Future<int> upsertQuiz(QuizzesCompanion quiz) {
    return into(quizzes).insertOnConflictUpdate(quiz);
  }

  /// Batch insert quizzes
  Future<void> batchInsertQuizzes(List<QuizzesCompanion> quizList) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(quizzes, quizList);
    });
  }

  // ============================================================================
  // Argument Queries
  // ============================================================================

  /// Get all arguments for a license type
  Future<List<ArgumentEntity>> getArgumentsByLicenseType(int licenseTypeId) {
    return (select(arguments)
          ..where(
            (a) =>
                a.licenseTypeId.equals(licenseTypeId) & a.isActive.equals(true),
          )
          ..orderBy([(a) => OrderingTerm(expression: a.position)]))
        .get();
  }

  /// Get argument by ID
  Future<ArgumentEntity?> getArgumentById(int id, int licenseTypeId) {
    return (select(arguments)..where(
          (a) => a.id.equals(id) & a.licenseTypeId.equals(licenseTypeId),
        ))
        .getSingleOrNull();
  }

  /// Insert or update argument
  Future<int> upsertArgument(ArgumentsCompanion argument) {
    return into(arguments).insertOnConflictUpdate(argument);
  }

  /// Batch insert arguments
  Future<void> batchInsertArguments(
    List<ArgumentsCompanion> argumentList,
  ) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(arguments, argumentList);
    });
  }

  // ============================================================================
  // Manual Queries
  // ============================================================================

  /// Get manuals by argument ID
  Future<List<ManualEntity>> getManualsByArgument(
    int licenseTypeId,
    int argumentId,
  ) {
    return (select(manuals)
          ..where(
            (m) =>
                m.licenseTypeId.equals(licenseTypeId) &
                m.argumentId.equals(argumentId) &
                m.isActive.equals(true),
          )
          ..orderBy([(m) => OrderingTerm(expression: m.position)]))
        .get();
  }

  /// Batch insert manuals
  Future<void> batchInsertManuals(List<ManualsCompanion> manualList) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(manuals, manualList);
    });
  }

  // ============================================================================
  // Sheet Queries
  // ============================================================================

  /// Get all sheets for a license type
  Future<List<SheetEntity>> getSheetsByLicenseType(int licenseTypeId) {
    return (select(sheets)
          ..where((s) => s.licenseTypeId.equals(licenseTypeId))
          ..orderBy([
            (s) => OrderingTerm(
              expression: s.createdDatetime,
              mode: OrderingMode.desc,
            ),
          ]))
        .get();
  }

  /// Insert sheet
  Future<int> insertSheet(SheetsCompanion sheet) {
    return into(sheets).insert(sheet);
  }

  /// Update sheet
  Future<bool> updateSheet(SheetsCompanion sheet) {
    return update(sheets).replace(sheet);
  }

  /// Clear all sheet server IDs (used when switching from guest to regular user)
  /// This assumes that previous user was a guest and their sheets should not sync
  Future<void> clearAllSheetServerIds() async {
    try {
      await update(sheets).write(const SheetsCompanion(serverId: Value(null)));
    } catch (e) {
      debugPrint("Error in removing sheet server ids, $e");
    }
  }

  // ============================================================================
  // License Type Queries
  // ============================================================================

  /// Get all license types
  Future<List<LicenseTypeEntity>> getAllLicenseTypes() {
    return (select(licenseTypes)..where((l) => l.isActive.equals(true))).get();
  }

  /// Insert license type
  Future<int> insertLicenseType(LicenseTypesCompanion licenseType) {
    return into(licenseTypes).insertOnConflictUpdate(licenseType);
  }

  // ============================================================================
  // Database Management
  // ============================================================================

  /// Clear all data (for testing or re-migration)
  Future<void> clearAllData() async {
    await transaction(() async {
      await delete(quizAnswers).go();
      await delete(sheets).go();
      await delete(manualBooks).go();
      await delete(manuals).go();
      await delete(quizzes).go();
      await delete(arguments).go();
      await delete(licenseTypes).go();
      await delete(pictureQuizzes).go();
    });
  }

  /// Get database statistics
  Future<Map<String, int>> getDatabaseStats() async {
    final quizCount = await (selectOnly(
      quizzes,
    )..addColumns([quizzes.id.count()])).getSingle();
    final argumentCount = await (selectOnly(
      arguments,
    )..addColumns([arguments.id.count()])).getSingle();
    final manualCount = await (selectOnly(
      manuals,
    )..addColumns([manuals.id.count()])).getSingle();
    final sheetCount = await (selectOnly(
      sheets,
    )..addColumns([sheets.id.count()])).getSingle();

    return {
      'quizzes': quizCount.read(quizzes.id.count()) ?? 0,
      'arguments': argumentCount.read(arguments.id.count()) ?? 0,
      'manuals': manualCount.read(manuals.id.count()) ?? 0,
      'sheets': sheetCount.read(sheets.id.count()) ?? 0,
    };
  }

  /// Force immediate checkpoint (no-op in DELETE journal mode)
  /// Kept for API compatibility but not needed since we use synchronous=FULL
  /// In DELETE mode, all writes are immediately persisted to disk
  Future<void> forceCheckpoint() async {
    try {
      // On WAL mode, allow truncating the WAL to reduce file size and ensure clean state
      await customStatement('PRAGMA wal_checkpoint(TRUNCATE)');
    } catch (e) {
      debugPrint('⚠️ WAL checkpoint failed: $e');
    }
  }

  // ============================================================================
  // Redvertising Campaigns Queries
  // ============================================================================

  /// Get all active campaigns that have started
  /// Matches iOS: campaigns.filter { $0.isActive && $0.startDatetime.isEarlierThanOrEqualTo(Date()) }
  Future<List<RedvertisingCampaignEntity>> getActiveRedvertisingCampaigns() {
    final now = DateTime.now();
    return (select(redvertisingCampaigns)..where(
          (c) =>
              c.isActive.equals(true) &
              c.startDatetime.isSmallerOrEqualValue(now),
        ))
        .get();
  }

  /// Get a specific campaign by ID
  Future<RedvertisingCampaignEntity?> getRedvertisingCampaignById(int id) {
    return (select(
      redvertisingCampaigns,
    )..where((c) => c.id.equals(id))).getSingleOrNull();
  }

  /// Get image sets for a specific campaign
  Future<List<RedvertisingImageSetEntity>> getImageSetsForCampaign(
    int campaignId,
  ) {
    return (select(
      redvertisingImageSets,
    )..where((s) => s.campaignId.equals(campaignId))).get();
  }

  /// Insert or update a campaign
  /// Matches iOS: RedvertisingCampaign.deserialize + CoreDataController.shared.mainContext.tryToSave()
  Future<void> upsertRedvertisingCampaign(RedvertisingCampaignEntity campaign) {
    return into(redvertisingCampaigns).insertOnConflictUpdate(campaign);
  }

  /// Insert or update multiple campaigns
  Future<void> upsertRedvertisingCampaigns(
    List<RedvertisingCampaignEntity> campaigns,
  ) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(redvertisingCampaigns, campaigns);
    });
  }

  /// Insert or update an image set
  Future<void> upsertRedvertisingImageSet(RedvertisingImageSetEntity imageSet) {
    return into(redvertisingImageSets).insertOnConflictUpdate(imageSet);
  }

  /// Insert or update multiple image sets
  Future<void> upsertRedvertisingImageSets(
    List<RedvertisingImageSetEntity> imageSets,
  ) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(redvertisingImageSets, imageSets);
    });
  }

  /// Increment displayed count for a campaign
  /// Matches iOS: displayed property tracking
  Future<void> incrementCampaignDisplayCount(int campaignId) async {
    await (update(
      redvertisingCampaigns,
    )..where((c) => c.id.equals(campaignId))).write(
      RedvertisingCampaignsCompanion(
        displayed: Value(
          (await getRedvertisingCampaignById(campaignId))?.displayed ?? 0 + 1,
        ),
      ),
    );
  }

  /// Delete all Redvertising campaigns
  Future<void> deleteAllRedvertisingCampaigns() async {
    await delete(redvertisingCampaigns).go();
    await delete(redvertisingImageSets).go();
  }

  /// Delete campaigns that are no longer active or have passed
  Future<void> cleanupExpiredRedvertisingCampaigns() async {
    final now = DateTime.now();
    await (delete(redvertisingCampaigns)..where(
          (c) =>
              c.isActive.equals(false) | c.startDatetime.isBiggerThanValue(now),
        ))
        .go();
  }
}

// ============================================================================
// Database Connection
// ============================================================================

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    // Use Library directory on iOS (Apple's recommendation for DBs)
    // Use Documents directory on Android
    final dbFolder = Platform.isIOS
        ? await getLibraryDirectory()
        : await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'app_database.db'));

    try {
      return NativeDatabase.createInBackground(
        file,
        setup: (database) async {
          // Ensure sqlite uses a valid temp directory (important on iOS sandboxes)
          try {
            final tmp = (await getTemporaryDirectory()).path;
            sqlite3pkg.sqlite3.tempDirectory = tmp;
          } catch (_) {
            // Best effort only
          }

          // Log SQLite version for diagnostics
          final sqliteVersion = database.select('SELECT sqlite_version()');
          debugPrint('✅ SQLite version: ${sqliteVersion.first}');

          // Enable foreign keys
          database.execute('PRAGMA foreign_keys = ON');

          // Concurrency & durability tuning for Drift
          // WAL allows concurrent readers during a writer transaction
          database.execute('PRAGMA journal_mode = WAL');
          // NORMAL sync is recommended with WAL
          database.execute('PRAGMA synchronous = NORMAL');
          // Busy timeout to wait for locks instead of immediate failures
          database.execute('PRAGMA busy_timeout = 5000');
          // Optional: automatic checkpointing
          database.execute('PRAGMA wal_autocheckpoint = 1000');

          // Performance optimizations (that don't affect persistence)
          database.execute('PRAGMA temp_store = MEMORY');
          database.execute('PRAGMA cache_size = -64000'); // 64MB cache
        },
      );
    } catch (e) {
      debugPrint('❌ Database initialization failed: $e');
      debugPrint('   Database file: ${file.path}');
      rethrow;
    }
  });
}
