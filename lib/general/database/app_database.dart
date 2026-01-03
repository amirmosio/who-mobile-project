import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart' as sqlite3pkg;

// Table imports
// IDTM tables
import 'tables/facility_installations_table.dart';
import 'tables/installation_progress_table.dart';
import 'tables/facility_notes_table.dart';
import 'tables/component_checklist_table.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    // IDTM tables
    FacilityInstallations,
    InstallationProgress,
    FacilityNotes,
    ComponentChecklist,
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
  // Database Management
  // ============================================================================

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
