import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:who_mobile_project/general/extensions/string_extensions.dart';
import 'package:who_mobile_project/general/models/database/argument_model.dart';
import 'package:who_mobile_project/general/models/database/manual_book_model.dart';
import 'package:who_mobile_project/general/models/database/manual_model.dart';
import 'package:who_mobile_project/general/models/database/quiz_answer_model.dart';
import 'package:who_mobile_project/general/models/database/quiz_model.dart';
import 'package:who_mobile_project/general/models/database/update_db_model.dart';
import 'package:who_mobile_project/general/models/database/picture_quiz_model.dart';
import 'package:who_mobile_project/general/models/user/license_type_model.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart' as sqlite3lib;
import 'package:drift/drift.dart' hide JsonKey;
import 'app_database.dart';
import '../services/storage/storage_manager.dart';
import '../services/realm_migration_service.dart';
import '../services/auth_migration_service.dart';
import '../models/login/login_response.dart';
import 'package:who_mobile_project/app_core/authenticator/shared_preferences_authenticator.dart';
import '../utils/token_utils.dart';

@lazySingleton
class NativeDatabaseMigrationService {
  final AppDatabase _database;
  final StorageManager _storage;
  final RealmMigrationService _realmMigrationService;
  final AuthMigrationService _authMigrationService;
  final SharedPreferencesAuthenticator _authenticator;

  NativeDatabaseMigrationService(
    this._database,
    this._storage,
    this._realmMigrationService,
    this._authMigrationService,
    this._authenticator,
  );

  /// Decorator/Wrapper function to execute individual migration operations with:
  /// - Automatic transaction wrapping for each operation
  /// - Error handling that skips failed items but continues processing
  /// - Automatic commit after each successful operation
  ///
  /// This ensures that even if the app crashes mid-migration, successfully
  /// completed operations are persisted.
  ///
  /// Usage:
  /// ```dart
  /// final failures = await withOperationTransaction(
  ///   'Migrate Quizzes',
  ///   () => _migrateQuizzesInternal(oldDb),
  /// );
  /// ```
  Future<int> withOperationTransaction(
    String operationName,
    Future<int> Function() operation,
  ) async {
    try {
      int failures = 0;

      // Each operation runs in its own transaction and commits immediately
      await _database.transaction(() async {
        failures = await operation();
      });

      // Force checkpoint to ensure data is written to disk
      await _database.forceCheckpoint();

      if (failures == 0) {
        debugPrint('✅ $operationName: completed successfully (committed)');
      } else {
        debugPrint(
          '⚠️  $operationName: completed with $failures failures (committed)',
        );
      }

      return failures;
    } catch (e, stackTrace) {
      debugPrint('❌ $operationName: operation failed - $e');
      debugPrint('   Stack trace: $stackTrace');
      return 1; // Return 1 failure on operation error
    }
  }

  Future<bool> migrateIfNeeded() async {
    // Check if migration already completed
    if (_storage.getNativeDatabaseMigrationCompleted()) {
      debugPrint('📋 Native database migration already completed, skipping');
      return false;
    }

    // Determine which migration to run based on platform
    final success = await _migrateNativeData();

    if (success) {
      await _storage.setNativeDatabaseMigrationCompleted(true);
    }
    return success;
  }

  /// Internal method to perform the actual data migration
  Future<bool> _migrateNativeData() async {
    try {
      // Migrate authentication data first (Android only for now)
      if (Platform.isAndroid) {
        await _migrateAndroidAuthData();
      }

      if (Platform.isIOS) {
        // iOS migration: Use SQLite/CoreData (existing implementation)
        return await _migrateIOSData();
      } else {
        // Android migration: Use Realm (new implementation)
        return await _migrateAndroidRealmData();
      }
    } catch (e, stackTrace) {
      debugPrint('❌ Error during native data migration: $e');
      debugPrint('Stack trace: $stackTrace');
      return false;
    }
  }

  /// Migrate authentication data from old Android app's SharedPreferences
  /// This runs before database migration to ensure user is logged in
  Future<void> _migrateAndroidAuthData() async {
    try {
      debugPrint('🔐 Starting authentication data migration...');

      // Check if auth data exists in old app
      final hasAuthData = await _authMigrationService.hasOldAppAuthData();
      if (!hasAuthData) {
        debugPrint('📝 No auth data found in old app');
        return;
      }

      // Check if we already have auth data (don't overwrite existing)
      final existingAuth = await _authenticator.getUserAuth();
      if (existingAuth != null) {
        // Check if existing auth is valid - if token is valid, skip migration
        final accessToken = existingAuth.jwtToken;
        bool isValidToken = false;
        try {
          isValidToken = TokenUtils.checkIfJWTTokenWillBeValidForDuration(
            accessToken,
          );
        } catch (e) {
          // Token is invalid/malformed - treat as invalid
          debugPrint(
            '⚠️  Existing auth data has invalid token format, will migrate from old app',
          );
          debugPrint('   Error: $e');
          isValidToken = false;
        }

        if (isValidToken) {
          debugPrint('📝 Valid auth data already exists, skipping migration');
          return;
        } else {
          debugPrint(
            '⚠️  Existing auth data has expired/invalid token, will migrate from old app',
          );
          // Token is expired or invalid, so we should migrate from old app to get fresh tokens
          // Don't return - continue with migration
        }
      }

      // Migrate auth data from old app
      final authDataMap = await _authMigrationService.migrateAuthData();
      if (authDataMap == null || authDataMap.isEmpty) {
        debugPrint('📝 No auth data to migrate');
        return;
      }

      debugPrint('✅ Migrated auth data from old app: $authDataMap');

      // Try to parse as LoginResponse
      try {
        // Handle both complete JSON string and individual keys
        Map<String, dynamic> loginResponseJson;

        if (authDataMap.containsKey('access') ||
            authDataMap.containsKey('refresh')) {
          // Already in LoginResponse format
          loginResponseJson = authDataMap;
        } else {
          // Try to reconstruct from old app format (key_oauth2 and CURRENT_USER)
          String? accessToken;
          String? refreshToken;
          Map<String, dynamic>? userInfo;

          // Extract token data from key_oauth2
          if (authDataMap.containsKey('key_oauth2')) {
            final keyOAuth2 = authDataMap['key_oauth2'];
            if (keyOAuth2 is String) {
              try {
                final oauth2Data =
                    jsonDecode(keyOAuth2) as Map<String, dynamic>;
                accessToken = oauth2Data['access_token'] as String?;
                refreshToken = oauth2Data['refresh_token'] as String?;
              } catch (e) {
                debugPrint('⚠️  Error parsing key_oauth2: $e');
              }
            } else if (keyOAuth2 is Map) {
              accessToken = keyOAuth2['access_token'] as String?;
              refreshToken = keyOAuth2['refresh_token'] as String?;
            }
          }

          // Extract user data from CURRENT_USER
          if (authDataMap.containsKey('CURRENT_USER')) {
            final currentUser = authDataMap['CURRENT_USER'];
            if (currentUser is String) {
              try {
                userInfo = jsonDecode(currentUser) as Map<String, dynamic>;
              } catch (e) {
                debugPrint('⚠️  Error parsing CURRENT_USER: $e');
              }
            } else if (currentUser is Map) {
              userInfo = currentUser as Map<String, dynamic>;
            }
          }

          // Try to find a complete auth JSON string as fallback
          if (accessToken == null || refreshToken == null || userInfo == null) {
            String? authJsonString;
            try {
              final jsonStrings = authDataMap.values
                  .whereType<String>()
                  .where((value) => value.startsWith('{'))
                  .toList();
              if (jsonStrings.isNotEmpty) {
                authJsonString = jsonStrings.first;
              }
            } catch (e) {
              // Continue to check individual keys
            }

            if (authJsonString != null) {
              loginResponseJson =
                  jsonDecode(authJsonString) as Map<String, dynamic>;
            } else {
              debugPrint(
                '⚠️  Auth data format not recognized, skipping migration',
              );
              debugPrint(
                '   accessToken: ${accessToken != null ? "found" : "missing"}',
              );
              debugPrint(
                '   refreshToken: ${refreshToken != null ? "found" : "missing"}',
              );
              debugPrint(
                '   userInfo: ${userInfo != null ? "found" : "missing"}',
              );
              return;
            }
          } else {
            // Reconstruct LoginResponse format from old app format
            loginResponseJson = {
              'access': accessToken, // Transform access_token -> access
              'refresh': refreshToken, // Transform refresh_token -> refresh
              'user': userInfo,
            };
            debugPrint('✅ Reconstructed LoginResponse from old app format');
          }
        }

        // Create LoginResponse from migrated data (contains OAuth2 tokens)
        final loginResponse = LoginResponse.fromJson(loginResponseJson);

        // Store OAuth2 tokens - token exchange will be handled by AppAccounting provider
        // during app initialization
        debugPrint(
          '📝 Migrated OAuth2 tokens - will be exchanged during app initialization',
        );

        // Store in FlutterSecureStorage (OAuth2 tokens will be exchanged by auth provider)
        await _authenticator.setUserAuth(loginResponse);

        debugPrint('✅ Successfully migrated and stored authentication data');
        debugPrint(
          '   User: ${loginResponse.user.email} (ID: ${loginResponse.user.id})',
        );
      } catch (e) {
        debugPrint('⚠️  Error parsing migrated auth data: $e');
        debugPrint('   Auth data: $authDataMap');
        // Don't throw - migration should continue even if auth migration fails
      }
    } catch (e, stackTrace) {
      debugPrint('❌ Error during auth data migration: $e');
      debugPrint('   Stack trace: $stackTrace');
      // Don't throw - migration should continue even if auth migration fails
    }
  }

  /// Migrate iOS data from CoreData/SQLite
  Future<bool> _migrateIOSData() async {
    try {
      final oldDbPath = await _getOldIOSDatabasePath();

      if (oldDbPath == null || !await File(oldDbPath).exists()) {
        debugPrint('📂 Old iOS database not found at expected location');
        return true; // No data to migrate, consider it successful
      }

      debugPrint('📂 Found old iOS database at: $oldDbPath');

      // Open the old database (read-only) using sqlite3
      final oldDb = sqlite3lib.sqlite3.open(
        oldDbPath,
        mode: sqlite3lib.OpenMode.readOnly,
      );

      int totalFailures = 0;

      // ✅ CRITICAL FIX: Each operation runs in its own transaction with immediate commit
      totalFailures += await withOperationTransaction(
        'Migrate Quizzes',
        () => _migrateQuizzesIOS(oldDb),
      );
      totalFailures += await withOperationTransaction(
        'Migrate Manual Books',
        () => _migrateManualBooksIOS(oldDb),
      );
      totalFailures += await withOperationTransaction(
        'Migrate Sheets',
        () => _migrateSheetsIOS(oldDb),
      );
      totalFailures += await withOperationTransaction(
        'Migrate Quiz Answers',
        () => _migrateQuizAnswersIOS(oldDb),
      );

      oldDb.dispose();

      if (totalFailures == 0) {
        debugPrint('✅ iOS migration completed successfully with no failures');
        return true;
      } else {
        debugPrint('⚠️  iOS migration completed with $totalFailures failures');
        return false;
      }
    } catch (e, stackTrace) {
      debugPrint('❌ Error during iOS data migration: $e');
      debugPrint('Stack trace: $stackTrace');
      return false;
    }
  }

  /// Migrate Android data from Realm database
  Future<bool> _migrateAndroidRealmData() async {
    try {
      // Find Realm database files
      final realmFiles = await _realmMigrationService.findRealmFiles();

      if (realmFiles.isEmpty) {
        debugPrint('📂 No Realm database files found');
        return true; // No data to migrate, consider it successful
      }

      debugPrint('📂 Found ${realmFiles.length} Realm database file(s)');
      for (final file in realmFiles) {
        debugPrint('   - $file');
      }

      // ============================================================================
      // DIAGNOSTIC: Inspect all Realm files first to understand what they contain
      // ============================================================================
      debugPrint('');
      debugPrint('🔍 DIAGNOSTIC: Inspecting Realm files before migration...');
      try {
        final inspection = await _realmMigrationService.inspectRealmFiles();
        for (final entry in inspection.entries) {
          final fileName = entry.key;
          final fileInfo = entry.value as Map<String, dynamic>;
          debugPrint('');
          debugPrint('📄 File: $fileName');
          debugPrint('   Path: ${fileInfo['path']}');
          debugPrint('   Size: ${fileInfo['size']} bytes');
          debugPrint('   Can Open: ${fileInfo['canOpen']}');
          debugPrint('   Is Encrypted: ${fileInfo['isEncrypted']}');

          if (fileInfo['canOpen'] == true && fileInfo['schemas'] != null) {
            final schemas = fileInfo['schemas'] as Map<String, dynamic>;
            debugPrint('   Schemas found: ${schemas.length}');
            for (final schemaEntry in schemas.entries) {
              final schemaName = schemaEntry.key;
              final schemaInfo = schemaEntry.value as Map<String, dynamic>;
              final count = schemaInfo['count'] ?? -1;
              final fieldCount = (schemaInfo['fields'] as List?)?.length ?? 0;
              debugPrint(
                '     - $schemaName: $count objects, $fieldCount fields',
              );
            }
          } else if (fileInfo['canOpen'] == false) {
            debugPrint('   ❌ Cannot open: ${fileInfo['error']}');
            debugPrint('   Error Type: ${fileInfo['errorType']}');
          }
        }
      } catch (e) {
        debugPrint('⚠️  Error during diagnostic inspection: $e');
        // Continue with migration even if inspection fails
      }
      debugPrint('');
      debugPrint(
        '============================================================================',
      );
      debugPrint('');

      // Prioritize backup file (might be unencrypted) or try all files
      // Sort files: backup files first, then main files
      final sortedFiles = realmFiles.toList()
        ..sort((a, b) {
          final aIsBackup = a.contains('.backup') || a.contains('backup');
          final bIsBackup = b.contains('.backup') || b.contains('backup');
          if (aIsBackup && !bIsBackup) return -1;
          if (!aIsBackup && bIsBackup) return 1;
          return 0;
        });

      debugPrint('📂 Trying Realm files in order:');
      for (final file in sortedFiles) {
        debugPrint('   - $file');
      }

      // Try all files for each data type to collect data from all sources
      // This ensures we get quizzes from one file and sheets from another if needed
      int totalFailures = 0;
      bool foundAnyData = false;
      Set<String> successfulFiles = {};

      // IMPORTANT: Check ALL data types from ALL files
      // Different Realm files might contain different data or schema versions
      // We accumulate data from all files, not just the first one

      for (final realmFilePath in sortedFiles) {
        debugPrint('📂 Trying Realm file: $realmFilePath');

        try {
          // Try to migrate each data type from this file
          // We check all files for all data types to ensure we get all data

          // Quizzes: Check all files (might have different quiz sets)
          try {
            final failures = await withOperationTransaction(
              'Migrate Quizzes from Realm',
              () => _migrateQuizzesFromRealm(realmFilePath),
            );
            if (failures == 0) {
              successfulFiles.add(realmFilePath);
              foundAnyData = true;
              debugPrint(
                '✅ Quizzes checked from: $realmFilePath (no failures)',
              );
            } else {
              totalFailures += failures;
              debugPrint(
                '⚠️  Some quiz migration failures from $realmFilePath: $failures',
              );
            }
          } catch (e) {
            // If encryption error or fatal crash, skip this file for quizzes
            if (e.toString().contains('encrypted') ||
                e.toString().contains('bad_optional_access') ||
                e.toString().contains('Fatal')) {
              debugPrint(
                '⚠️  File is encrypted or corrupted, skipping quizzes from: $realmFilePath',
              );
            } else {
              debugPrint('⚠️  Error migrating quizzes from $realmFilePath: $e');
              totalFailures++;
            }
          }

          // Manual Books: Check all files
          try {
            final failures = await withOperationTransaction(
              'Migrate Manual Books from Realm',
              () => _migrateManualBooksFromRealm(realmFilePath),
            );
            if (failures == 0) {
              successfulFiles.add(realmFilePath);
              foundAnyData = true;
              debugPrint(
                '✅ Manual books checked from: $realmFilePath (no failures)',
              );
            } else {
              totalFailures += failures;
              debugPrint(
                '⚠️  Some manual book migration failures from $realmFilePath: $failures',
              );
            }
          } catch (e) {
            if (e.toString().contains('encrypted') ||
                e.toString().contains('bad_optional_access') ||
                e.toString().contains('Fatal')) {
              debugPrint(
                '⚠️  File is encrypted or corrupted, skipping manual books from: $realmFilePath',
              );
            } else {
              debugPrint(
                '⚠️  Error migrating manual books from $realmFilePath: $e',
              );
              totalFailures++;
            }
          }

          // Sheets: Check all files (completed quizzes might be in different files)
          try {
            final failures = await withOperationTransaction(
              'Migrate Sheets from Realm',
              () => _migrateSheetsFromRealm(realmFilePath),
            );
            if (failures == 0) {
              successfulFiles.add(realmFilePath);
              foundAnyData = true;
              debugPrint('✅ Sheets checked from: $realmFilePath (no failures)');
            } else {
              totalFailures += failures;
              debugPrint(
                '⚠️  Some sheet migration failures from $realmFilePath: $failures',
              );
            }
          } catch (e) {
            if (e.toString().contains('encrypted') ||
                e.toString().contains('bad_optional_access') ||
                e.toString().contains('Fatal')) {
              debugPrint(
                '⚠️  File is encrypted or corrupted, skipping sheets from: $realmFilePath',
              );
            } else {
              debugPrint('⚠️  Error migrating sheets from $realmFilePath: $e');
              totalFailures++;
            }
          }

          // Quiz Answers: Check all files
          try {
            final failures = await withOperationTransaction(
              'Migrate Quiz Answers from Realm',
              () => _migrateQuizAnswersFromRealm(realmFilePath),
            );
            if (failures == 0) {
              successfulFiles.add(realmFilePath);
              foundAnyData = true;
              debugPrint(
                '✅ Quiz answers checked from: $realmFilePath (no failures)',
              );
            } else {
              totalFailures += failures;
              debugPrint(
                '⚠️  Some quiz answer migration failures from $realmFilePath: $failures',
              );
            }
          } catch (e) {
            if (e.toString().contains('encrypted') ||
                e.toString().contains('bad_optional_access') ||
                e.toString().contains('Fatal')) {
              debugPrint(
                '⚠️  File is encrypted or corrupted, skipping quiz answers from: $realmFilePath',
              );
            } else {
              debugPrint(
                '⚠️  Error migrating quiz answers from $realmFilePath: $e',
              );
              totalFailures++;
            }
          }

          // Users: Check all files (might contain guest user data)
          try {
            final failures = await withOperationTransaction(
              'Migrate Users from Realm',
              () => _migrateUsersFromRealm(realmFilePath),
            );
            if (failures == 0) {
              successfulFiles.add(realmFilePath);
              foundAnyData = true;
              debugPrint('✅ Users checked from: $realmFilePath (no failures)');
            } else {
              totalFailures += failures;
              debugPrint(
                '⚠️  Some user migration failures from $realmFilePath: $failures',
              );
            }
          } catch (e) {
            if (e.toString().contains('encrypted') ||
                e.toString().contains('bad_optional_access') ||
                e.toString().contains('Fatal')) {
              debugPrint(
                '⚠️  File is encrypted or corrupted, skipping users from: $realmFilePath',
              );
            } else {
              debugPrint('⚠️  Error migrating users from $realmFilePath: $e');
              totalFailures++;
            }
          }

          // ItemQuizzes: CRITICAL - represents completed quiz items (90 objects!)
          try {
            final failures = await withOperationTransaction(
              'Migrate ItemQuizzes from Realm',
              () => _migrateItemQuizzesFromRealm(realmFilePath),
            );
            if (failures == 0) {
              successfulFiles.add(realmFilePath);
              foundAnyData = true;
              debugPrint(
                '✅ ItemQuizzes checked from: $realmFilePath (no failures)',
              );
            } else {
              totalFailures += failures;
              debugPrint(
                '⚠️  Some ItemQuizzes migration failures from $realmFilePath: $failures',
              );
            }
          } catch (e) {
            if (e.toString().contains('encrypted') ||
                e.toString().contains('bad_optional_access') ||
                e.toString().contains('Fatal')) {
              debugPrint(
                '⚠️  File is encrypted or corrupted, skipping ItemQuizzes from: $realmFilePath',
              );
            } else {
              debugPrint(
                '⚠️  Error migrating ItemQuizzes from $realmFilePath: $e',
              );
              totalFailures++;
            }
          }

          // LicenseTypes: Check all files
          try {
            final failures = await withOperationTransaction(
              'Migrate LicenseTypes from Realm',
              () => _migrateLicenseTypesFromRealm(realmFilePath),
            );
            if (failures == 0) {
              successfulFiles.add(realmFilePath);
              foundAnyData = true;
              debugPrint(
                '✅ LicenseTypes checked from: $realmFilePath (no failures)',
              );
            } else {
              totalFailures += failures;
              debugPrint(
                '⚠️  Some LicenseTypes migration failures from $realmFilePath: $failures',
              );
            }
          } catch (e) {
            if (e.toString().contains('encrypted') ||
                e.toString().contains('bad_optional_access') ||
                e.toString().contains('Fatal')) {
              debugPrint(
                '⚠️  File is encrypted or corrupted, skipping LicenseTypes from: $realmFilePath',
              );
            } else {
              debugPrint(
                '⚠️  Error migrating LicenseTypes from $realmFilePath: $e',
              );
              totalFailures++;
            }
          }

          // Manuals: Check all files
          try {
            final failures = await withOperationTransaction(
              'Migrate Manuals from Realm',
              () => _migrateManualsFromRealm(realmFilePath),
            );
            if (failures == 0) {
              successfulFiles.add(realmFilePath);
              foundAnyData = true;
              debugPrint(
                '✅ Manuals checked from: $realmFilePath (no failures)',
              );
            } else {
              totalFailures += failures;
              debugPrint(
                '⚠️  Some Manuals migration failures from $realmFilePath: $failures',
              );
            }
          } catch (e) {
            if (e.toString().contains('encrypted') ||
                e.toString().contains('bad_optional_access') ||
                e.toString().contains('Fatal')) {
              debugPrint(
                '⚠️  File is encrypted or corrupted, skipping Manuals from: $realmFilePath',
              );
            } else {
              debugPrint('⚠️  Error migrating Manuals from $realmFilePath: $e');
              totalFailures++;
            }
          }

          // Topics (Arguments): Check all files
          try {
            final failures = await withOperationTransaction(
              'Migrate Topics from Realm',
              () => _migrateTopicsFromRealm(realmFilePath),
            );
            if (failures == 0) {
              successfulFiles.add(realmFilePath);
              foundAnyData = true;
              debugPrint('✅ Topics checked from: $realmFilePath (no failures)');
            } else {
              totalFailures += failures;
              debugPrint(
                '⚠️  Some Topics migration failures from $realmFilePath: $failures',
              );
            }
          } catch (e) {
            if (e.toString().contains('encrypted') ||
                e.toString().contains('bad_optional_access') ||
                e.toString().contains('Fatal')) {
              debugPrint(
                '⚠️  File is encrypted or corrupted, skipping Topics from: $realmFilePath',
              );
            } else {
              debugPrint('⚠️  Error migrating Topics from $realmFilePath: $e');
              totalFailures++;
            }
          }

          // Pictures: Check all files
          try {
            final failures = await withOperationTransaction(
              'Migrate Pictures from Realm',
              () => _migratePicturesFromRealm(realmFilePath),
            );
            if (failures == 0) {
              successfulFiles.add(realmFilePath);
              foundAnyData = true;
              debugPrint(
                '✅ Pictures checked from: $realmFilePath (no failures)',
              );
            } else {
              totalFailures += failures;
              debugPrint(
                '⚠️  Some Pictures migration failures from $realmFilePath: $failures',
              );
            }
          } catch (e) {
            if (e.toString().contains('encrypted') ||
                e.toString().contains('bad_optional_access') ||
                e.toString().contains('Fatal')) {
              debugPrint(
                '⚠️  File is encrypted or corrupted, skipping Pictures from: $realmFilePath',
              );
            } else {
              debugPrint(
                '⚠️  Error migrating Pictures from $realmFilePath: $e',
              );
              totalFailures++;
            }
          }
        } catch (e, stackTrace) {
          debugPrint(
            '❌ Fatal error migrating from Realm file $realmFilePath: $e',
          );
          debugPrint('   Stack trace: $stackTrace');
          debugPrint(
            '   This file might be corrupted or have incompatible schema. Skipping...',
          );
          // Continue to next file - don't crash the entire migration
        }
      }

      if (foundAnyData) {
        debugPrint('✅ Android Realm migration completed successfully');
        if (successfulFiles.isNotEmpty) {
          debugPrint('   Files used: ${successfulFiles.join(", ")}');
        }

        // Debug: Log what was migrated
        try {
          // Query all sheets directly from database
          final allSheetsQuery = _database.select(_database.sheets);
          final allSheets = await allSheetsQuery.get();
          debugPrint(
            '📊 DEBUG: Total sheets in database after migration: ${allSheets.length}',
          );

          // Group by licenseTypeId
          final Map<int, int> sheetsByLicenseType = {};
          for (final sheet in allSheets) {
            sheetsByLicenseType[sheet.licenseTypeId] =
                (sheetsByLicenseType[sheet.licenseTypeId] ?? 0) + 1;
          }
          debugPrint('📊 DEBUG: Sheets by licenseTypeId: $sheetsByLicenseType');
        } catch (e) {
          debugPrint('⚠️  Error logging migrated data stats: $e');
        }

        return true;
      } else if (totalFailures == 0) {
        debugPrint(
          '⚠️  No data found in any Realm file (or all files are encrypted)',
        );
        return true; // Consider it successful if no failures (might just be empty)
      } else {
        debugPrint(
          '⚠️  Android Realm migration failed for all Realm files ($totalFailures total failures)',
        );
        debugPrint('   This might be because the Realm files are encrypted.');
        debugPrint(
          '   Please check if the old app uses encrypted Realm files and provide the encryption key if needed.',
        );
        return false;
      }
    } catch (e, stackTrace) {
      debugPrint('❌ Error during Android Realm data migration: $e');
      debugPrint('Stack trace: $stackTrace');
      return false;
    }
  }

  /// Get the path to the old iOS CoreData database
  Future<String?> _getOldIOSDatabasePath() async {
    try {
      // iOS CoreData stores in Application Support directory
      final appSupport = await getApplicationSupportDirectory();
      debugPrint('📂 iOS App Support dir: ${appSupport.path}');

      // Look for GuidaEVai.sqlite (the CoreData SQLite file)
      final dbPath = p.join(appSupport.path, 'GuidaEVai.sqlite');
      debugPrint('📂 Checking iOS database at: $dbPath');

      if (await File(dbPath).exists()) {
        debugPrint('✅ Found iOS database at: $dbPath');
        return dbPath;
      }

      // Try alternative locations
      final documentsDir = await getApplicationDocumentsDirectory();
      debugPrint('📂 iOS Documents dir: ${documentsDir.path}');
      final altDbPath = p.join(documentsDir.path, 'GuidaEVai.sqlite');
      debugPrint('📂 Checking alternative iOS database at: $altDbPath');

      if (await File(altDbPath).exists()) {
        debugPrint('✅ Found iOS database at: $altDbPath');
        return altDbPath;
      }

      debugPrint('❌ No iOS database found in: $dbPath or $altDbPath');
      return null;
    } catch (e) {
      debugPrint('Error getting old iOS database path: $e');
      return null;
    }
  }

  // /// Get the path to the old Android SQLite database
  // Future<String?> _getOldAndroidDatabasePath() async {
  //   try {
  //     // Android SQLite databases are stored in /data/data/<package>/databases/
  //     // getApplicationDocumentsDirectory() returns /data/data/<package>/files/
  //     // We need to go up one level and into databases folder
  //     final documentsDir = await getApplicationDocumentsDirectory();

  //     debugPrint('📂 Android documents dir: ${documentsDir.path}');

  //     // Navigate to databases folder: /data/data/<package>/databases/
  //     final databasesPath = p.normalize(
  //       p.join(documentsDir.path, '../databases'),
  //     );
  //     debugPrint('📂 Checking databases path: $databasesPath');

  //     // Look for common Android database file names
  //     final possibleDbNames = [
  //       'GuidaEVai.db',
  //       'GuidaEVai.sqlite',
  //       'quiz_patente.db',
  //       'database.db',
  //     ];

  //     // Check if databases directory exists
  //     final dirExists = await Directory(databasesPath).exists();
  //     debugPrint('📂 Databases directory exists: $dirExists');

  //     if (dirExists) {
  //       // List all files in databases directory for debugging
  //       try {
  //         final dbDir = Directory(databasesPath);
  //         final files = await dbDir.list().toList();
  //         debugPrint('📂 Found ${files.length} items in databases directory:');
  //         for (var file in files) {
  //           debugPrint('   - ${file.path}');
  //         }
  //       } catch (e) {
  //         debugPrint('⚠️  Could not list databases directory: $e');
  //       }

  //       for (final dbName in possibleDbNames) {
  //         final dbPath = p.join(databasesPath, dbName);
  //         if (await File(dbPath).exists()) {
  //           debugPrint('✅ Found Android database at: $dbPath');
  //           return dbPath;
  //         }
  //       }
  //     }

  //     // Fallback: Check in files directory too (some apps might store DBs there)
  //     debugPrint('📂 Checking files directory: ${documentsDir.path}');
  //     final filesDirExists = await Directory(documentsDir.path).exists();
  //     if (filesDirExists) {
  //       try {
  //         final files = await Directory(documentsDir.path).list().toList();
  //         debugPrint('📂 Found ${files.length} items in files directory:');
  //         for (var file in files) {
  //           debugPrint('   - ${file.path}');
  //         }
  //       } catch (e) {
  //         debugPrint('⚠️  Could not list files directory: $e');
  //       }
  //     }

  //     for (final dbName in possibleDbNames) {
  //       final dbPath = p.join(documentsDir.path, dbName);
  //       if (await File(dbPath).exists()) {
  //         debugPrint('✅ Found Android database in files dir: $dbPath');
  //         return dbPath;
  //       }
  //     }

  //     debugPrint(
  //       '❌ No Android database found in: $databasesPath or ${documentsDir.path}',
  //     );
  //     debugPrint('   Searched for: ${possibleDbNames.join(", ")}');
  //     return null;
  //   } catch (e) {
  //     debugPrint('Error getting old Android database path: $e');
  //     return null;
  //   }
  // }

  /// Migrate Quiz entities from iOS CoreData to Drift
  Future<int> _migrateQuizzesIOS(sqlite3lib.Database oldDb) async {
    int failures = 0;

    try {
      // CoreData table name is ZQUIZ (Z prefix is CoreData convention)
      final quizzes = oldDb.select('SELECT * FROM ZQUIZ');

      debugPrint('📝 Migrating ${quizzes.length} quizzes...');
      final currentCount =
          (await _database.select(_database.quizzes).get()).length;
      debugPrint('  ✅ Current count of quizzes before adding: $currentCount');

      for (final quiz in quizzes) {
        try {
          final companion = QuizzesCompanion(
            id: Value(quiz['ZID'] as int? ?? 0),
            appId: Value(quiz['ZAPP_ID'] as int? ?? 0),
            comment: Value(quiz['ZCOMMENT'] as String?),
            createdDatetime: Value(_parseDate(quiz['ZCREATED_DATETIME'])),
            hasAnswer: Value((quiz['ZHAS_ANSWER'] as int?) == 1),
            // isActive: Value(true),
            modifiedDatetime: Value(_parseDate(quiz['ZMODIFIED_DATETIME'])),
            originalId: Value(quiz['ZORIGINAL_ID'] as String?),
            position: Value(quiz['ZPOSITION'] as int? ?? 0),
            numberExtracted: Value(quiz['ZNUMBER_EXTRACTED'] as int? ?? 0),
            result: Value((quiz['ZRESULT'] as int?) == 1),
            symbol: Value(quiz['ZSYMBOL'] as String?),
            questionText: Value(quiz['ZTEXT'] as String?),
            argumentId: Value(quiz['ZARGUMENT_ID'] as int? ?? 0),
            licenseTypeId: Value(quiz['ZLICENSE_TYPE'] as int? ?? 0),
            manualId: Value(quiz['ZMANUAL_ID'] as int?),
            image: Value((quiz['ZIMAGE'] as String?)?.addDomainIfNeeded),
            updateDbId: Value(quiz['ZUPDATE_DB'] as int?),
          );

          await _database
              .into(_database.quizzes)
              .insert(companion, onConflict: DoUpdate((_) => companion));
        } catch (e) {
          debugPrint('  ⚠️  Error migrating quiz ${quiz['ZID']}: $e');
          failures++;
        }
      }

      debugPrint(
        '  ✅ Migrated quizzes: ${quizzes.length - failures} successful, $failures failures',
      );
      final newCurrentCount =
          (await _database.select(_database.quizzes).get()).length;
      debugPrint(
        '  ✅ Current count of quizzes after inserting: $newCurrentCount',
      );
    } catch (e) {
      debugPrint('  ❌ Error migrating quizzes table: $e');
      failures++;
    }

    return failures;
  }

  /// Migrate Argument entities
  // Future<int> _migrateArguments(Database oldDb) async {
  //   int failures = 0;
  //   try {
  //     final arguments = await oldDb.query('ZARGUMENT');

  //     debugPrint('📝 Migrating ${arguments.length} arguments...');

  //     for (final argument in arguments) {
  //       try {
  //         await _database.into(_database.arguments).insert(
  //               ArgumentsCompanion(
  //                 id: Value(argument['ZID'] as int? ?? 0),
  //                 name: Value(argument['ZNAME'] as String?),
  //                 numberQuestion:
  //                     Value(argument['ZNUMBER_QUESTION'] as int? ?? 0),
  //                 numberQuizzes:
  //                     Value(argument['ZNUMBER_QUIZZES'] as int? ?? 0),
  //                 position: Value(argument['ZPOSITION'] as int? ?? 0),
  //                 // isActive: Value((argument['ZIS_ACTIVE'] as int?) == 1),
  //                 isVideo: Value((argument['ZIS_VIDEO'] as int?) == 1),
  //                 createdDatetime:
  //                     Value(_parseDate(argument['ZCREATED_DATETIME'])),
  //                 modifiedDatetime:
  //                     Value(_parseDate(argument['ZMODIFIED_DATETIME'])),
  //                 licenseTypeId: Value(argument['ZLICENSE_TYPE'] as int? ?? 0),
  //                 thumbId: Value(argument['ZTHUMB'] as int?),
  //                 updateDbId: Value(argument['ZUPDATE_DB'] as int?),
  //               ),
  //               mode: InsertMode.insertOrReplace,
  //             );
  //       } catch (e) {
  //         failures++;
  //         debugPrint('  ⚠️  Error migrating argument ${argument['ZID']}: $e');
  //       }
  //     }

  //     debugPrint(
  //         '  ✅ Migrated arguments: ${arguments.length - failures} successful, $failures failures');
  //   } catch (e) {
  //     debugPrint('  ❌ Error migrating arguments table: $e');
  //     failures++;
  //   }
  //   return failures;
  // }

  // /// Migrate LicenseType entities
  // Future<int> _migrateLicenseTypes(Database oldDb) async {
  //   int failures = 0;
  //   try {
  //     final licenseTypes = await oldDb.query('ZLICENSETYPE');

  //     debugPrint('📝 Migrating ${licenseTypes.length} license types...');

  //     for (final licenseType in licenseTypes) {
  //       try {
  //         await _database.into(_database.licenseTypes).insert(
  //               LicenseTypesCompanion(
  //                 id: Value(licenseType['ZID'] as int? ?? 0),
  //                 name: Value(licenseType['ZNAME'] as String? ?? ''),
  //                 code: const Value.absent(),
  //                 // isActive: Value((licenseType['ZIS_ACTIVE'] as int?) == 1),
  //                 hasAnswer: Value((licenseType['ZHAS_ANSWER'] as int?) == 1),
  //                 hasBook: Value((licenseType['ZHAS_BOOK'] as int?) == 1),
  //                 hasEbook: Value((licenseType['ZHAS_EBOOK'] as int?) == 1),
  //                 isRevision: Value((licenseType['ZIS_REVISION'] as int?) == 1),
  //                 maxNumberError:
  //                     Value(licenseType['ZMAX_NUMBER_ERROR'] as int? ?? 0),
  //                 numberAnswer:
  //                     Value(licenseType['ZNUMBER_ANSWER'] as int? ?? 0),
  //                 numberQuestion:
  //                     Value(licenseType['ZNUMBER_QUESTION'] as int? ?? 0),
  //                 numberQuizzes:
  //                     Value(licenseType['ZNUMBER_QUIZZES'] as int? ?? 0),
  //                 position: Value(licenseType['ZPOSITION'] as int? ?? 0),
  //                 thumbId: Value(licenseType['ZTHUMB'] as int?),
  //                 updateDbId: Value(licenseType['ZUPDATE_DB'] as int?),
  //                 createdDatetime:
  //                     Value(_parseDate(licenseType['ZCREATED_DATETIME'])),
  //                 modifiedDatetime:
  //                     Value(_parseDate(licenseType['ZMODIFIED_DATETIME'])),
  //                 duration: Value(
  //                     (licenseType['ZDURATION'] as num?)?.toDouble() ?? 0.0),
  //                 note: Value(licenseType['ZNOTE'] as String?),
  //               ),
  //               mode: InsertMode.insertOrReplace,
  //             );
  //       } catch (e) {
  //         failures++;
  //         debugPrint(
  //             '  ⚠️  Error migrating license type ${licenseType['ZID']}: $e');
  //       }
  //     }

  //     debugPrint(
  //         '  ✅ Migrated license types: ${licenseTypes.length - failures} successful, $failures failures');
  //   } catch (e) {
  //     debugPrint('  ❌ Error migrating license types table: $e');
  //     failures++;
  //   }
  //   return failures;
  // }

  // /// Migrate Manual entities
  // Future<int> _migrateManuals(Database oldDb) async {
  //   int failures = 0;
  //   try {
  //     final manuals = await oldDb.query('ZMANUAL');

  //     debugPrint('📝 Migrating ${manuals.length} manuals...');

  //     for (final manual in manuals) {
  //       try {
  //         await _database.into(_database.manuals).insert(
  //               ManualsCompanion(
  //                 id: Value(manual['ZID'] as int? ?? 0),
  //                 title: Value(manual['ZTITLE'] as String?),
  //                 content: Value(manual['ZTEXT'] as String?),
  //                 alt: Value(manual['ZALT'] as String?),
  //                 note: Value(manual['ZNOTE'] as String?),
  //                 symbol: Value(manual['ZSYMBOL'] as String?),
  //                 url: Value(manual['ZURL'] as String?),
  //                 position: Value(manual['ZPOSITION'] as int? ?? 0),
  //                 // isActive: Value((manual['ZIS_ACTIVE'] as int?) == 1),
  //                 createdDatetime:
  //                     Value(_parseDate(manual['ZCREATED_DATETIME'])),
  //                 modifiedDatetime:
  //                     Value(_parseDate(manual['ZMODIFIED_DATETIME'])),
  //                 argumentId: Value(manual['ZARGUMENT'] as int? ?? 0),
  //                 licenseTypeId: Value(manual['ZLICENSE_TYPE'] as int? ?? 0),
  //                 image: Value(manual['ZIMAGE'] as int?),
  //                 updateDbId: Value(manual['ZUPDATE_DB'] as int?),
  //                 video: Value(manual['ZVIDEO'] as int?),
  //                 fokArgumentId: Value(manual['Z_FOK_ARGUMENT'] as int?),
  //               ),
  //               mode: InsertMode.insertOrReplace,
  //             );
  //       } catch (e) {
  //         failures++;
  //         debugPrint('  ⚠️  Error migrating manual ${manual['ZID']}: $e');
  //       }
  //     }

  //     debugPrint(
  //         '  ✅ Migrated manuals: ${manuals.length - failures} successful, $failures failures');
  //   } catch (e) {
  //     debugPrint('  ❌ Error migrating manuals table: $e');
  //     failures++;
  //   }
  //   return failures;
  // }

  Future<int> _migrateManualBooksIOS(sqlite3lib.Database oldDb) async {
    int failures = 0;
    try {
      final manualBooks = oldDb.select('SELECT * FROM ZMANUALBOOKS');

      debugPrint('📝 Migrating ${manualBooks.length} manual books...');

      for (final manualBook in manualBooks) {
        try {
          // iOS stores manuals as a plist array - need to parse it
          String? manualsJson;
          final manualsRaw = manualBook['ZMANUALS'];
          if (manualsRaw != null) {
            // Try to parse as JSON array or convert from binary plist
            if (manualsRaw is String) {
              manualsJson = manualsRaw;
            } else if (manualsRaw is List) {
              manualsJson = jsonEncode(manualsRaw);
            }
          }

          final companion = ManualBooksCompanion(
            id: Value(manualBook['ZID'] as int? ?? 0),
            argument: Value(manualBook['ZARGUMENT'] as int?),
            manuals: Value(manualsJson),
            hasBeenScanned: Value(
              (manualBook['ZHAS_BEEN_SCANNED'] as int?) == 1,
            ),
            createdDatetime: Value(_parseDate(manualBook['ZCREATED_DATETIME'])),
            modifiedDatetime: Value(
              _parseDate(manualBook['ZMODIFIED_DATETIME']),
            ),
            updateDbId: Value(manualBook['ZUPDATE_DB'] as int?),
          );

          await _database
              .into(_database.manualBooks)
              .insert(companion, onConflict: DoUpdate((_) => companion));
        } catch (e) {
          failures++;
          debugPrint(
            '  ⚠️  Error migrating manual book ${manualBook['ZID']}: $e',
          );
        }
      }

      debugPrint(
        '  ✅ Migrated manual books: ${manualBooks.length - failures} successful, $failures failures',
      );
    } catch (e) {
      debugPrint('  ❌ Error migrating manual books table: $e');
      failures++;
    }
    return failures;
  }

  /// Migrate Sheet entities (user exam sheets)
  Future<int> _migrateSheetsIOS(sqlite3lib.Database oldDb) async {
    int failures = 0;
    try {
      final sheets = oldDb.select('SELECT * FROM ZSHEET');
      debugPrint('📝 Migrating ${sheets.length} sheets...');

      for (final sheet in sheets) {
        try {
          final companion = SheetsCompanion(
            id: Value(sheet['ZID'] as int? ?? 0),
            serverId: Value(sheet['ZID'] as int? ?? 0),
            groupCode: Value(sheet['ZGROUP_CODE'] as String?),
            type: Value(sheet['ZTYPE'] as int? ?? 0),
            duration: Value(sheet['ZDURATION'] as double? ?? 0.0),
            executionTime: Value(sheet['ZEXECUTION_TIME'] as int? ?? 0),
            maxNumberError: Value(sheet['ZMAX_NUMBER_ERROR'] as int? ?? 0),
            numberQuestion: Value(sheet['ZNUMBER_QUESTION'] as int? ?? 0),
            numberCorrectQuestion: Value(
              sheet['ZNUMBER_CORRECT_QUESTION'] as int? ?? 0,
            ),
            numberErrorQuestion: Value(
              sheet['ZNUMBER_ERROR_QUESTION'] as int? ?? 0,
            ),
            numberEmptyQuestion: Value(
              sheet['ZNUMBER_EMPTY_QUESTION'] as int? ?? 0,
            ),
            student: Value(sheet['ZSTUDENT'] as int? ?? 0),
            teacher: Value(sheet['ZTEACHER'] as int? ?? 0),
            hasAnswer: Value((sheet['ZHAS_ANSWER'] as int?) == 1),
            isExecuted: Value((sheet['ZIS_EXECUTED'] as int?) == 1),
            isPassed: Value((sheet['ZIS_PASSED'] as int?) == 1),
            hasIncrementedCount: Value(
              (sheet['ZHAS_INCREMENTED_COUNT'] as int?) == 1,
            ),
            createdDatetime: Value(_parseDate(sheet['ZCREATED_DATETIME'])),
            modifiedDatetime: Value(_parseDate(sheet['ZMODIFIED_DATETIME'])),
            startDatetime: Value(_parseDate(sheet['ZSTART_DATETIME'])),
            endDatetime: Value(_parseDate(sheet['ZEND_DATETIME'])),
            expirationDatetime: Value(
              _parseDate(sheet['ZEXPIRATION_DATETIME']),
            ),
            licenseTypeId: Value(sheet['ZLICENSE_TYPE'] as int? ?? 0),
            quizzes: Value(_serializeQuizzes(sheet['ZQUIZZES'])),
          );

          await _database
              .into(_database.sheets)
              .insert(companion, onConflict: DoUpdate((_) => companion));
        } catch (e) {
          failures++;
          debugPrint('  ⚠️  Error migrating sheet ${sheet['ZID']}: $e');
        }
      }

      debugPrint(
        '  ✅ Migrated sheets: ${sheets.length - failures} successful, $failures failures',
      );
    } catch (e) {
      debugPrint('  ❌ Error migrating sheets table: $e');
      failures++;
    }
    return failures;
  }

  /// Migrate QuizAnswer entities (multiple choice answer options)
  Future<int> _migrateQuizAnswersIOS(sqlite3lib.Database oldDb) async {
    int failures = 0;
    try {
      final quizAnswers = oldDb.select('SELECT * FROM ZQUIZANSWER');
      debugPrint('📝 Migrating ${quizAnswers.length} quiz answers...');

      for (final quizAnswer in quizAnswers) {
        try {
          final companion = QuizAnswersCompanion(
            id: Value(quizAnswer['ZID'] as int? ?? 0),
            answerText: Value(quizAnswer['ZTEXT'] as String?),
            position: Value(quizAnswer['ZPOSITION'] as int?),
            createdDatetime: Value(_parseDate(quizAnswer['ZCREATED_DATETIME'])),
            modifiedDatetime: Value(
              _parseDate(quizAnswer['ZMODIFIED_DATETIME']),
            ),
            isCorrect: Value(
              quizAnswer['ZIS_CORRECT'] != null
                  ? (quizAnswer['ZIS_CORRECT'] as int?) == 1
                  : null,
            ),
            // isActive: Value((quizAnswer['ZIS_ACTIVE'] as int?) == 1),
            licenseTypeId: Value(quizAnswer['ZLICENSE_TYPE'] as int? ?? 0),
            quizId: Value(quizAnswer['ZQUIZ'] as int? ?? 0),
            updateDbId: Value(quizAnswer['ZUPDATE_DB'] as int?),
          );

          await _database
              .into(_database.quizAnswers)
              .insert(companion, onConflict: DoUpdate((_) => companion));
        } catch (e) {
          failures++;
          debugPrint(
            '  ⚠️  Error migrating quiz answer ${quizAnswer['ZID']}: $e',
          );
        }
      }

      debugPrint(
        '  ✅ Migrated quiz answers: ${quizAnswers.length - failures} successful, $failures failures',
      );
    } catch (e) {
      debugPrint('  ❌ Error migrating quiz answers table: $e');
      failures++;
    }
    return failures;
  }

  /// Helper to parse CoreData dates (stored as seconds since 2001-01-01)
  DateTime? _parseDate(dynamic value) {
    if (value == null) return null;

    try {
      // CoreData stores dates as seconds since 2001-01-01 00:00:00 UTC
      final coreDataEpoch = DateTime(2001, 1, 1);
      final secondsSince2001 = value is int ? value : (value as double).toInt();
      return coreDataEpoch.add(Duration(seconds: secondsSince2001));
    } catch (e) {
      debugPrint('  ⚠️  Error parsing date: $e');
      return null;
    }
  }

  String _serializeQuizzes(dynamic value) {
    if (value == null) return '[]';

    // If already a string (JSON), return as-is
    if (value is String) {
      return value;
    }

    // Handle binary NSKeyedArchiver data from iOS Core Data
    if (value is Uint8List) {
      try {
        final quizzes = _parseNSKeyedArchiverQuizzes(value);
        return jsonEncode(quizzes);
      } catch (e) {
        debugPrint('  ⚠️  Error parsing NSKeyedArchiver quizzes: $e');
        return '[]';
      }
    }

    debugPrint('  ⚠️  Unexpected quizzes type: ${value.runtimeType}');
    return '[]';
  }

  /// Parse NSKeyedArchiver binary data to extract [[Int]] quiz arrays
  /// iOS stores quizzes as NSSecureUnarchiveFromData which creates binary plist format
  List<List<int>> _parseNSKeyedArchiverQuizzes(Uint8List data) {
    // Check for bplist header
    if (data.length < 8 ||
        String.fromCharCodes(data.sublist(0, 6)) != 'bplist') {
      throw Exception('Invalid bplist format');
    }

    // For iOS Core Data NSKeyedArchiver format, we need to parse the binary plist
    // This is a simplified parser that extracts integer arrays
    // The format stores arrays of arrays with 4 integers each: [quizID, answer, result, argumentID]

    try {
      final List<List<int>> quizzes = [];

      // Strategy: Look for sequences of 4 integers in the binary data
      // NSKeyedArchiver stores integers in specific patterns
      // We'll scan for the pattern and extract the values

      // Convert to string to find markers (this is a heuristic approach)
      int i = 0;
      final List<int> currentIntegers = [];

      while (i < data.length - 1) {
        // Look for integer markers in binary plist format
        // 0x10 followed by 1 byte = small integer (0-255)
        // 0x11 followed by 2 bytes = 16-bit integer
        // 0x12 followed by 4 bytes = 32-bit integer

        if (data[i] == 0x10 && i + 1 < data.length) {
          // Single byte integer
          final value = data[i + 1];
          currentIntegers.add(value);
          i += 2;
        } else if (data[i] == 0x11 && i + 2 < data.length) {
          // 16-bit integer (big-endian)
          final value = (data[i + 1] << 8) | data[i + 2];
          currentIntegers.add(value);
          i += 3;
        } else if (data[i] == 0x12 && i + 4 < data.length) {
          // 32-bit integer (big-endian)
          final value =
              (data[i + 1] << 24) |
              (data[i + 2] << 16) |
              (data[i + 3] << 8) |
              data[i + 4];
          currentIntegers.add(value);
          i += 5;
        } else {
          i++;
        }

        // When we have 4 integers, that's one quiz entry
        if (currentIntegers.length >= 4) {
          quizzes.add([
            currentIntegers[currentIntegers.length - 4],
            currentIntegers[currentIntegers.length - 3],
            currentIntegers[currentIntegers.length - 2],
            currentIntegers[currentIntegers.length - 1],
          ]);
          // Keep the last few integers in case they overlap
          while (currentIntegers.length > 3) {
            currentIntegers.removeAt(0);
          }
        }
      }

      return quizzes;
    } catch (e) {
      debugPrint('  ❌ Failed to parse binary plist: $e');
      return [];
    }
  }
  // ============================================================================
  // Realm Migration Methods (Android)
  // ============================================================================

  /// Migrate Quizzes from Realm database
  Future<int> _migrateQuizzesFromRealm(String realmFilePath) async {
    int failures = 0;
    int successCount = 0;
    try {
      debugPrint('🔍 [Quizzes] Starting migration from: $realmFilePath');
      final quizzesJson = await _realmMigrationService.migrateQuizzes(
        realmFilePath,
      );
      debugPrint(
        '🔍 [Quizzes] Got JSON response (length: ${quizzesJson.length})',
      );
      final quizzesList = jsonDecode(quizzesJson) as List<dynamic>;

      debugPrint('📝 Migrating ${quizzesList.length} quizzes from Realm...');
      if (quizzesList.isEmpty) {
        debugPrint('  ⚠️  WARNING: No quizzes found in Realm!');
        return 0;
      }
      final currentCount =
          (await _database.select(_database.quizzes).get()).length;
      debugPrint('  ✅ Current count of quizzes before adding: $currentCount');

      int processedCount = 0;
      for (final quizMap in quizzesList) {
        processedCount++;
        try {
          final quiz = quizMap as Map<String, dynamic>;
          final quizId = quiz['id'] as int?;

          // Log progress every 100 items or for first/last items
          if (processedCount == 1 ||
              processedCount == quizzesList.length ||
              processedCount % 100 == 0) {
            debugPrint(
              '   📄 Processing quiz $processedCount/${quizzesList.length}: id=$quizId',
            );
          }
          final companion = QuizzesCompanion(
            id: Value(quiz['id'] as int? ?? 0),
            appId: Value(quiz['appId'] as int? ?? quiz['app_id'] as int? ?? 0),
            comment: Value(quiz['comment'] as String?),
            createdDatetime: Value(
              _parseRealmDate(
                quiz['createdDatetime'] ?? quiz['created_datetime'],
              ),
            ),
            hasAnswer: Value(
              quiz['hasAnswer'] as bool? ??
                  (quiz['has_answer'] as int? ?? 0) == 1,
            ),
            modifiedDatetime: Value(
              _parseRealmDate(
                quiz['modifiedDatetime'] ?? quiz['modified_datetime'],
              ),
            ),
            originalId: Value(
              quiz['originalId'] as String? ?? quiz['original_id'] as String?,
            ),
            position: Value(quiz['position'] as int? ?? 0),
            numberExtracted: Value(
              quiz['numberExtracted'] as int? ??
                  quiz['number_extracted'] as int? ??
                  0,
            ),
            result: Value(
              quiz['result'] as bool? ?? (quiz['result'] as int? ?? 0) == 1,
            ),
            symbol: Value(quiz['symbol'] as String?),
            questionText: Value(
              quiz['questionText'] as String? ??
                  quiz['question_text'] as String?,
            ),
            argumentId: Value(
              quiz['argumentId'] as int? ?? quiz['argument_id'] as int? ?? 0,
            ),
            licenseTypeId: Value(
              quiz['licenseTypeId'] as int? ??
                  quiz['license_type_id'] as int? ??
                  0,
            ),
            manualId: Value(
              quiz['manualId'] as int? ?? quiz['manual_id'] as int?,
            ),
            image: Value((quiz['image'] as String?)?.addDomainIfNeeded),
            updateDbId: Value(
              quiz['updateDbId'] as int? ?? quiz['update_db_id'] as int?,
            ),
          );

          await _database
              .into(_database.quizzes)
              .insert(companion, onConflict: DoUpdate((_) => companion));
          successCount++;
        } catch (e, stackTrace) {
          failures++;
          final quizId = quizMap['id'];
          final questionTextRaw =
              quizMap['questionText'] ?? quizMap['question_text'] as String?;
          final questionText = questionTextRaw?.substring(
            0,
            questionTextRaw.length.clamp(0, 50),
          );
          debugPrint('  ⚠️  Error migrating quiz $quizId: $e');
          debugPrint(
            '      Quiz details: questionText=$questionText..., argumentId=${quizMap['argumentId'] ?? quizMap['argument_id']}',
          );
          debugPrint('      Stack trace: $stackTrace');
        }
      }

      debugPrint(
        '   📊 Migration progress: $successCount successful, $failures failures out of ${quizzesList.length} total',
      );
      debugPrint(
        '  ✅ Migrated quizzes: ${quizzesList.length - failures} successful, $failures failures',
      );
      final newCurrentCount =
          (await _database.select(_database.quizzes).get()).length;
      debugPrint(
        '  ✅ Current count of quizzes after inserting: $newCurrentCount',
      );
    } catch (e) {
      // If encryption is detected, re-throw to signal Dart code to try next file
      if (e.toString().contains('encrypted')) {
        debugPrint('  ❌ Realm file is encrypted, will try next file: $e');
        rethrow;
      }
      debugPrint('  ❌ Error migrating quizzes from Realm: $e');
      failures++;
    }
    return failures;
  }

  /// Migrate Manual Books from Realm database
  Future<int> _migrateManualBooksFromRealm(String realmFilePath) async {
    int failures = 0;
    int successCount = 0;
    try {
      debugPrint('🔍 [ManualBooks] Starting migration from: $realmFilePath');
      final manualBooksJson = await _realmMigrationService.migrateManualBooks(
        realmFilePath,
      );
      debugPrint(
        '🔍 [ManualBooks] Got JSON response (length: ${manualBooksJson.length})',
      );
      final manualBooksList = jsonDecode(manualBooksJson) as List<dynamic>;

      debugPrint(
        '📝 Migrating ${manualBooksList.length} manual books from Realm...',
      );
      if (manualBooksList.isEmpty) {
        debugPrint('  ⚠️  WARNING: No manual books found in Realm!');
        return 0;
      }

      int processedCount = 0;
      for (final manualBookMap in manualBooksList) {
        processedCount++;
        try {
          final manualBook = manualBookMap as Map<String, dynamic>;
          final manualBookId = manualBook['id'] as int?;

          // Log progress every 50 items or for first/last items
          if (processedCount == 1 ||
              processedCount == manualBooksList.length ||
              processedCount % 50 == 0) {
            debugPrint(
              '   📄 Processing manual book $processedCount/${manualBooksList.length}: id=$manualBookId',
            );
          }
          String? manualsJson;
          if (manualBook['manuals'] != null) {
            if (manualBook['manuals'] is String) {
              manualsJson = manualBook['manuals'] as String;
            } else {
              manualsJson = jsonEncode(manualBook['manuals']);
            }
          }

          final companion = ManualBooksCompanion(
            id: Value(manualBook['id'] as int? ?? 0),
            argument: Value(manualBook['argument'] as int?),
            manuals: Value(manualsJson),
            hasBeenScanned: Value(
              manualBook['hasBeenScanned'] as bool? ??
                  (manualBook['has_been_scanned'] as int? ?? 0) == 1,
            ),
            createdDatetime: Value(
              _parseRealmDate(
                manualBook['createdDatetime'] ?? manualBook['created_datetime'],
              ),
            ),
            modifiedDatetime: Value(
              _parseRealmDate(
                manualBook['modifiedDatetime'] ??
                    manualBook['modified_datetime'],
              ),
            ),
            updateDbId: Value(
              manualBook['updateDbId'] as int? ??
                  manualBook['update_db_id'] as int?,
            ),
          );

          await _database
              .into(_database.manualBooks)
              .insert(companion, onConflict: DoUpdate((_) => companion));
          successCount++;
        } catch (e, stackTrace) {
          failures++;
          final manualBookId = manualBookMap['id'];
          debugPrint('  ⚠️  Error migrating manual book $manualBookId: $e');
          debugPrint('      Stack trace: $stackTrace');
        }
      }

      debugPrint(
        '   📊 Migration progress: $successCount successful, $failures failures out of ${manualBooksList.length} total',
      );
      debugPrint(
        '  ✅ Migrated manual books: ${manualBooksList.length - failures} successful, $failures failures',
      );
    } catch (e) {
      // If encryption is detected, re-throw to signal Dart code to try next file
      if (e.toString().contains('encrypted')) {
        debugPrint('  ❌ Realm file is encrypted, will try next file: $e');
        rethrow;
      }
      debugPrint('  ❌ Error migrating manual books from Realm: $e');
      failures++;
    }
    return failures;
  }

  /// Migrate Sheets from Realm database
  Future<int> _migrateSheetsFromRealm(String realmFilePath) async {
    int failures = 0;
    int successCount = 0;
    try {
      debugPrint('🔍 [Sheets] Starting migration from: $realmFilePath');
      final sheetsJson = await _realmMigrationService.migrateSheets(
        realmFilePath,
      );
      debugPrint(
        '🔍 [Sheets] Got JSON response (length: ${sheetsJson.length})',
      );
      final sheetsList = jsonDecode(sheetsJson) as List<dynamic>;

      debugPrint('📝 Migrating ${sheetsList.length} sheets from Realm...');
      if (sheetsList.isEmpty) {
        debugPrint('  ⚠️  WARNING: No sheets found in Realm!');
        return 0; // Not a failure if there are none
      }

      // Debug: Log licenseTypeId distribution
      final Map<int, int> licenseTypeDistribution = {};
      for (final sheet in sheetsList) {
        final licenseTypeId =
            (sheet['licenseTypeId'] ?? sheet['license_type_id'] ?? 0) as int;
        licenseTypeDistribution[licenseTypeId] =
            (licenseTypeDistribution[licenseTypeId] ?? 0) + 1;
      }
      debugPrint('   📊 Sheets by licenseTypeId: $licenseTypeDistribution');

      int processedCount = 0;
      for (final sheetMap in sheetsList) {
        processedCount++;
        try {
          final sheet = sheetMap as Map<String, dynamic>;
          final sheetId = sheet['id'] as int?;

          // Log progress every 10 items or for first/last items
          if (processedCount == 1 ||
              processedCount == sheetsList.length ||
              processedCount % 10 == 0) {
            debugPrint(
              '   📄 Processing sheet $processedCount/${sheetsList.length}: id=$sheetId',
            );
          }
          String? quizzesJson;
          if (sheet['quizzes'] != null) {
            if (sheet['quizzes'] is String) {
              quizzesJson = sheet['quizzes'] as String;
            } else {
              quizzesJson = jsonEncode(sheet['quizzes']);
            }
          }

          final companion = SheetsCompanion(
            id: Value(sheet['id'] as int? ?? 0),
            serverId: Value(sheet['id'] as int? ?? 0),
            groupCode: Value(
              sheet['groupCode'] as String? ?? sheet['group_code'] as String?,
            ),
            type: Value(sheet['type'] as int? ?? 0),
            duration: Value((sheet['duration'] as num?)?.toDouble() ?? 0.0),
            executionTime: Value(
              sheet['executionTime'] as int? ??
                  sheet['execution_time'] as int? ??
                  0,
            ),
            maxNumberError: Value(
              sheet['maxNumberError'] as int? ??
                  sheet['max_number_error'] as int? ??
                  0,
            ),
            numberQuestion: Value(
              sheet['numberQuestion'] as int? ??
                  sheet['number_question'] as int? ??
                  0,
            ),
            numberCorrectQuestion: Value(
              sheet['numberCorrectQuestion'] as int? ??
                  sheet['number_correct_question'] as int? ??
                  0,
            ),
            numberErrorQuestion: Value(
              sheet['numberErrorQuestion'] as int? ??
                  sheet['number_error_question'] as int? ??
                  0,
            ),
            numberEmptyQuestion: Value(
              sheet['numberEmptyQuestion'] as int? ??
                  sheet['number_empty_question'] as int? ??
                  0,
            ),
            student: Value(sheet['student'] as int? ?? 0),
            teacher: Value(sheet['teacher'] as int? ?? 0),
            hasAnswer: Value(
              sheet['hasAnswer'] as bool? ??
                  (sheet['has_answer'] as int? ?? 0) == 1,
            ),
            isExecuted: Value(
              sheet['isExecuted'] as bool? ??
                  (sheet['is_executed'] as int? ?? 0) == 1,
            ),
            isPassed: Value(
              sheet['isPassed'] as bool? ??
                  (sheet['is_passed'] as int? ?? 0) == 1,
            ),
            hasIncrementedCount: Value(
              sheet['hasIncrementedCount'] as bool? ??
                  (sheet['has_incremented_count'] as int? ?? 0) == 1,
            ),
            createdDatetime: Value(
              _parseRealmDate(
                sheet['createdDatetime'] ?? sheet['created_datetime'],
              ),
            ),
            modifiedDatetime: Value(
              _parseRealmDate(
                sheet['modifiedDatetime'] ?? sheet['modified_datetime'],
              ),
            ),
            startDatetime: Value(
              _parseRealmDate(
                sheet['startDatetime'] ?? sheet['start_datetime'],
              ),
            ),
            endDatetime: Value(
              _parseRealmDate(sheet['endDatetime'] ?? sheet['end_datetime']),
            ),
            expirationDatetime: Value(
              _parseRealmDate(
                sheet['expirationDatetime'] ?? sheet['expiration_datetime'],
              ),
            ),
            licenseTypeId: Value(_getLicenseTypeId(sheet)),
            quizzes: Value(quizzesJson ?? '[]'),
          );

          await _database
              .into(_database.sheets)
              .insert(companion, onConflict: DoUpdate((_) => companion));
          successCount++;
        } catch (e, stackTrace) {
          failures++;
          final sheetId = sheetMap['id'];
          final student = sheetMap['student'];
          final teacher = sheetMap['teacher'];
          final licenseTypeId =
              sheetMap['licenseTypeId'] ?? sheetMap['license_type_id'];
          debugPrint('  ⚠️  Error migrating sheet $sheetId: $e');
          debugPrint(
            '      Sheet details: student=$student, teacher=$teacher, licenseTypeId=$licenseTypeId',
          );
          debugPrint('      Stack trace: $stackTrace');
        }
      }

      debugPrint(
        '   📊 Migration progress: $successCount successful, $failures failures out of ${sheetsList.length} total',
      );

      debugPrint(
        '  ✅ Migrated sheets: ${sheetsList.length - failures} successful, $failures failures',
      );
    } catch (e) {
      // If encryption is detected, re-throw to signal Dart code to try next file
      if (e.toString().contains('encrypted')) {
        debugPrint('  ❌ Realm file is encrypted, will try next file: $e');
        rethrow;
      }
      debugPrint('  ❌ Error migrating sheets from Realm: $e');
      failures++;
    }
    return failures;
  }

  /// Migrate Quiz Answers from Realm database
  Future<int> _migrateQuizAnswersFromRealm(String realmFilePath) async {
    int failures = 0;
    int successCount = 0;
    try {
      debugPrint('🔍 [QuizAnswers] Starting migration from: $realmFilePath');
      final quizAnswersJson = await _realmMigrationService.migrateQuizAnswers(
        realmFilePath,
      );
      debugPrint(
        '🔍 [QuizAnswers] Got JSON response (length: ${quizAnswersJson.length})',
      );
      final quizAnswersList = jsonDecode(quizAnswersJson) as List<dynamic>;

      debugPrint(
        '📝 Migrating ${quizAnswersList.length} quiz answers from Realm...',
      );
      if (quizAnswersList.isEmpty) {
        debugPrint('  ⚠️  WARNING: No quiz answers found in Realm!');
        return 0;
      }

      int processedCount = 0;
      for (final quizAnswerMap in quizAnswersList) {
        processedCount++;
        try {
          final quizAnswer = quizAnswerMap as Map<String, dynamic>;
          final quizAnswerId = quizAnswer['id'] as int?;
          final quizId = quizAnswer['quizId'] ?? quizAnswer['quiz_id'];

          // Log progress every 100 items or for first/last items
          if (processedCount == 1 ||
              processedCount == quizAnswersList.length ||
              processedCount % 100 == 0) {
            debugPrint(
              '   📄 Processing quiz answer $processedCount/${quizAnswersList.length}: id=$quizAnswerId, quizId=$quizId',
            );
          }
          final companion = QuizAnswersCompanion(
            id: Value(quizAnswer['id'] as int? ?? 0),
            answerText: Value(
              quizAnswer['answerText'] as String? ??
                  quizAnswer['answer_text'] as String?,
            ),
            position: Value(quizAnswer['position'] as int?),
            createdDatetime: Value(
              _parseRealmDate(
                quizAnswer['createdDatetime'] ?? quizAnswer['created_datetime'],
              ),
            ),
            modifiedDatetime: Value(
              _parseRealmDate(
                quizAnswer['modifiedDatetime'] ??
                    quizAnswer['modified_datetime'],
              ),
            ),
            isCorrect: Value(
              quizAnswer['isCorrect'] != null
                  ? (quizAnswer['isCorrect'] as bool? ??
                        (quizAnswer['isCorrect'] as int? ?? 0) == 1)
                  : (quizAnswer['is_correct'] != null
                        ? (quizAnswer['is_correct'] as bool? ??
                              (quizAnswer['is_correct'] as int? ?? 0) == 1)
                        : null),
            ),
            licenseTypeId: Value(
              quizAnswer['licenseTypeId'] as int? ??
                  quizAnswer['license_type_id'] as int? ??
                  0,
            ),
            quizId: Value(
              quizAnswer['quizId'] as int? ??
                  quizAnswer['quiz_id'] as int? ??
                  0,
            ),
            updateDbId: Value(
              quizAnswer['updateDbId'] as int? ??
                  quizAnswer['update_db_id'] as int?,
            ),
          );

          await _database
              .into(_database.quizAnswers)
              .insert(companion, onConflict: DoUpdate((_) => companion));
          successCount++;
        } catch (e, stackTrace) {
          failures++;
          final quizAnswerId = quizAnswerMap['id'];
          final quizId = quizAnswerMap['quizId'] ?? quizAnswerMap['quiz_id'];
          debugPrint(
            '  ⚠️  Error migrating quiz answer $quizAnswerId (quizId=$quizId): $e',
          );
          debugPrint('      Stack trace: $stackTrace');
        }
      }

      debugPrint(
        '   📊 Migration progress: $successCount successful, $failures failures out of ${quizAnswersList.length} total',
      );
      debugPrint(
        '  ✅ Migrated quiz answers: ${quizAnswersList.length - failures} successful, $failures failures',
      );
    } catch (e) {
      // If encryption is detected, re-throw to signal Dart code to try next file
      if (e.toString().contains('encrypted')) {
        debugPrint('  ❌ Realm file is encrypted, will try next file: $e');
        rethrow;
      }
      debugPrint('  ❌ Error migrating quiz answers from Realm: $e');
      failures++;
    }
    return failures;
  }

  /// Migrate Users from Realm database
  Future<int> _migrateUsersFromRealm(String realmFilePath) async {
    int failures = 0;
    int successCount = 0;
    try {
      debugPrint('🔍 [Users] Starting migration from: $realmFilePath');
      final usersJson = await _realmMigrationService.migrateUsers(
        realmFilePath,
      );
      debugPrint('🔍 [Users] Got JSON response (length: ${usersJson.length})');
      final usersList = jsonDecode(usersJson) as List<dynamic>;

      debugPrint('📝 Migrating ${usersList.length} users from Realm...');
      if (usersList.isEmpty) {
        debugPrint('  ⚠️  WARNING: No users found in Realm!');
        return 0;
      }

      int processedCount = 0;
      for (final userMap in usersList) {
        processedCount++;
        try {
          final user = userMap as Map<String, dynamic>;
          final userId = user['id'];
          final userEmail = user['email'];
          final isGuest = user['isGuest'];
          final userName = user['name'];

          // Note: User data structure depends on your Drift schema
          // For now, we'll just log the user data to see what's available
          debugPrint(
            '   👤 Processing user $processedCount/${usersList.length}: id=$userId, email=$userEmail, isGuest=$isGuest, name=$userName',
          );

          // TODO: Insert user into Drift database once user schema is defined
          // For now, we just log the data to help identify the guest user
          successCount++;
        } catch (e, stackTrace) {
          failures++;
          final userId = userMap['id'];
          debugPrint('  ⚠️  Error processing user $userId: $e');
          debugPrint('      Stack trace: $stackTrace');
        }
      }

      debugPrint(
        '   📊 Migration progress: $successCount successful, $failures failures out of ${usersList.length} total',
      );
      debugPrint(
        '  ✅ Migrated users: ${usersList.length - failures} successful, $failures failures',
      );
    } catch (e) {
      // If encryption is detected, re-throw to signal Dart code to try next file
      if (e.toString().contains('encrypted')) {
        debugPrint('  ❌ Realm file is encrypted, will try next file: $e');
        rethrow;
      }
      debugPrint('  ❌ Error migrating users from Realm: $e');
      failures++;
    }
    return failures;
  }

  /// Migrate ItemQuizzes from Realm database
  /// CRITICAL: These represent completed quiz items (90 objects!)
  /// Note: ItemQuizzes might be stored in Sheets.quizzes as JSON, or we might need a separate table
  Future<int> _migrateItemQuizzesFromRealm(String realmFilePath) async {
    int failures = 0;
    try {
      debugPrint('🔍 [ItemQuizzes] Starting migration from: $realmFilePath');
      final itemQuizzesJson = await _realmMigrationService.migrateItemQuizzes(
        realmFilePath,
      );
      debugPrint(
        '🔍 [ItemQuizzes] Got JSON response (length: ${itemQuizzesJson.length})',
      );

      final itemQuizzesList = jsonDecode(itemQuizzesJson) as List<dynamic>;

      debugPrint(
        '📝 Migrating ${itemQuizzesList.length} ItemQuizzes from Realm...',
      );
      if (itemQuizzesList.isEmpty) {
        debugPrint('  ⚠️  WARNING: No ItemQuizzes found in Realm!');
        return 0; // Not a failure if there are none
      }
      debugPrint(
        '   📋 Merging ItemQuizzes into their corresponding Sheets...',
      );

      // Group ItemQuizzes by idSheet
      final Map<int, List<Map<String, dynamic>>> itemQuizzesBySheet = {};
      final Set<int> uniqueSheetIds = {};
      for (final itemQuizMap in itemQuizzesList) {
        try {
          final itemQuiz = itemQuizMap as Map<String, dynamic>;
          final idSheet = itemQuiz['idSheet'] as int?;
          if (idSheet != null && idSheet > 0) {
            itemQuizzesBySheet.putIfAbsent(idSheet, () => []).add(itemQuiz);
            uniqueSheetIds.add(idSheet);
          }
        } catch (e) {
          debugPrint('  ⚠️  Error processing ItemQuiz for grouping: $e');
          failures++;
        }
      }

      debugPrint(
        '   📋 Found ItemQuizzes for ${itemQuizzesBySheet.length} unique sheets',
      );
      final sortedSheetIds = uniqueSheetIds.toList()..sort();
      debugPrint('   📋 Unique sheet IDs: $sortedSheetIds');

      // Merge ItemQuizzes into their corresponding Sheets
      // Also collect licenseTypeId from ItemQuizzes to fix sheets with licenseTypeId: 0
      final Map<int, int> licenseTypeBySheetId = {};
      for (final itemQuizMap in itemQuizzesList) {
        try {
          final itemQuiz = itemQuizMap as Map<String, dynamic>;
          final idSheet = itemQuiz['idSheet'] as int?;
          final licenseType = itemQuiz['licenseType'] as int?;
          if (idSheet != null &&
              idSheet > 0 &&
              licenseType != null &&
              licenseType > 0) {
            licenseTypeBySheetId[idSheet] = licenseType;
          }
        } catch (e) {
          // Ignore errors when collecting license types
        }
      }
      debugPrint(
        '   📋 Found licenseTypeIds for ${licenseTypeBySheetId.length} sheets: $licenseTypeBySheetId',
      );

      int mergedCount = 0;
      int notFoundCount = 0;
      for (final entry in itemQuizzesBySheet.entries) {
        final sheetId = entry.key;
        final itemQuizzes = entry.value;

        try {
          // Get the existing sheet
          final sheetQuery = _database.select(_database.sheets)
            ..where((s) => s.id.equals(sheetId));
          final existingSheet = await sheetQuery.getSingleOrNull();

          if (existingSheet != null) {
            // Fix licenseTypeId if it's 0 and we have it from ItemQuizzes
            int? licenseTypeIdToUse = existingSheet.licenseTypeId;
            if (licenseTypeIdToUse == 0 &&
                licenseTypeBySheetId.containsKey(sheetId)) {
              licenseTypeIdToUse = licenseTypeBySheetId[sheetId];
              debugPrint(
                '   🔧 Fixing licenseTypeId for sheet $sheetId: 0 -> $licenseTypeIdToUse',
              );
            }
            // Parse existing quizzes JSON
            // Handle both formats: List<List<int>> and List<Map<String, dynamic>>
            List<dynamic> quizzesList = [];
            try {
              final existingQuizzesJson = existingSheet.quizzes;
              if (existingQuizzesJson.isNotEmpty) {
                final decoded =
                    jsonDecode(existingQuizzesJson) as List<dynamic>;
                quizzesList = decoded;
              }
            } catch (e) {
              debugPrint(
                '  ⚠️  Error parsing existing quizzes JSON for sheet $sheetId: $e',
              );
              quizzesList = [];
            }

            // Convert any Map or 2-element array entries to 4-element format
            // This handles old migrations that stored {idQuiz: X, quizAnswer: Y} or [quiz_id, user_answer]
            for (int i = 0; i < quizzesList.length; i++) {
              final quiz = quizzesList[i];

              // Skip if already in correct 4-element format
              if (quiz is List && quiz.length >= 4) {
                continue;
              }

              int? idQuiz;
              int? quizAnswer;

              // Extract idQuiz and quizAnswer from different formats
              if (quiz is Map) {
                // Old format from Realm: {idQuiz: X, quizAnswer: Y}
                idQuiz = quiz['idQuiz'] as int?;
                quizAnswer = quiz['quizAnswer'] as int?;
              } else if (quiz is List && quiz.length >= 2) {
                // Old format: [quiz_id, user_answer]
                idQuiz = quiz[0] as int?;
                quizAnswer = quiz[1] as int?;
              }

              if (idQuiz != null && quizAnswer != null) {
                try {
                  final idQuizValue = idQuiz; // Non-nullable for use in queries
                  // Look up the quiz to get argumentId and determine if answer is correct
                  final quizQuery = _database.select(_database.quizzes)
                    ..where((q) => q.id.equals(idQuizValue));
                  final quizEntity = await quizQuery.getSingleOrNull();

                  if (quizEntity != null) {
                    final argumentId = quizEntity.argumentId;

                    // Find the correct answer for this quiz
                    final correctAnswerQuery =
                        _database.select(_database.quizAnswers)
                          ..where(
                            (qa) =>
                                qa.quizId.equals(idQuizValue) &
                                qa.isCorrect.equals(true),
                          )
                          ..limit(1);
                    final correctAnswer = await correctAnswerQuery
                        .getSingleOrNull();

                    // Determine if user's answer is correct (result: 0 = wrong, 1 = correct)
                    int result = 0; // Default to wrong
                    if (correctAnswer != null &&
                        correctAnswer.id == quizAnswer) {
                      result = 1; // Correct answer
                    }

                    // Convert to 4-element format
                    quizzesList[i] = [idQuiz, quizAnswer, result, argumentId];
                  }
                } catch (e) {
                  debugPrint(
                    '  ⚠️  Error converting old format quiz (idQuiz=$idQuiz): $e',
                  );
                  // Remove invalid entry - it will be skipped by statistics code anyway
                  quizzesList[i] = null;
                }
              } else {
                // Invalid format, remove it
                quizzesList[i] = null;
              }
            }

            // Remove any null entries
            quizzesList = quizzesList.where((quiz) => quiz != null).toList();

            // Merge ItemQuizzes into quizzes list
            // Format: [quiz_id, user_answer, result, argumentId]
            // where result is 0 (wrong) or 1 (correct)
            int addedCount = 0;
            int updatedCount = 0;
            int skippedCount = 0;
            for (final itemQuiz in itemQuizzes) {
              final idQuiz = itemQuiz['idQuiz'] as int?;
              final quizAnswer = itemQuiz['quizAnswer'] as int?;

              if (idQuiz != null && quizAnswer != null) {
                try {
                  // Look up the quiz to get argumentId and determine if answer is correct
                  final quizQuery = _database.select(_database.quizzes)
                    ..where((q) => q.id.equals(idQuiz));
                  final quiz = await quizQuery.getSingleOrNull();

                  if (quiz == null) {
                    debugPrint(
                      '  ⚠️  Quiz $idQuiz not found in database, skipping ItemQuiz',
                    );
                    skippedCount++;
                    continue;
                  }

                  // Get argumentId from quiz
                  final argumentId = quiz.argumentId;

                  // Find the correct answer for this quiz
                  final correctAnswerQuery =
                      _database.select(_database.quizAnswers)
                        ..where(
                          (qa) =>
                              qa.quizId.equals(idQuiz) &
                              qa.isCorrect.equals(true),
                        )
                        ..limit(1);
                  final correctAnswer = await correctAnswerQuery
                      .getSingleOrNull();

                  // Determine if user's answer is correct (result: 0 = wrong, 1 = correct)
                  int result = 0; // Default to wrong
                  if (correctAnswer != null && correctAnswer.id == quizAnswer) {
                    result = 1; // Correct answer
                  }

                  // Format: [quiz_id, user_answer, result, argumentId]
                  final quizEntry = [idQuiz, quizAnswer, result, argumentId];

                  // Check if this quiz already exists in the list
                  bool found = false;
                  for (int i = 0; i < quizzesList.length; i++) {
                    final existingQuiz = quizzesList[i];
                    if (existingQuiz is List &&
                        existingQuiz.isNotEmpty &&
                        existingQuiz[0] == idQuiz) {
                      // Update existing entry
                      quizzesList[i] = quizEntry;
                      found = true;
                      updatedCount++;
                      break;
                    }
                  }

                  if (!found) {
                    // Add new entry
                    quizzesList.add(quizEntry);
                    addedCount++;
                  }
                } catch (e) {
                  debugPrint(
                    '  ⚠️  Error processing ItemQuiz (idQuiz=$idQuiz, quizAnswer=$quizAnswer): $e',
                  );
                  skippedCount++;
                }
              }
            }

            if (skippedCount > 0) {
              debugPrint(
                '   ⚠️  Skipped $skippedCount ItemQuizzes due to errors or missing quizzes',
              );
            }

            // Update the sheet with merged quizzes and fixed licenseTypeId
            final updatedQuizzesJson = jsonEncode(quizzesList);
            final updateCompanion = SheetsCompanion(
              serverId: Value(sheetId),
              quizzes: Value(updatedQuizzesJson),
              licenseTypeId:
                  (licenseTypeIdToUse != null &&
                      licenseTypeIdToUse != existingSheet.licenseTypeId)
                  ? Value(licenseTypeIdToUse)
                  : Value(existingSheet.licenseTypeId),
            );
            await (_database.update(
              _database.sheets,
            )..where((s) => s.id.equals(sheetId))).write(updateCompanion);

            mergedCount++;
            debugPrint(
              '   ✅ Merged ${itemQuizzes.length} ItemQuizzes into sheet $sheetId (added: $addedCount, updated: $updatedCount, skipped: $skippedCount)${licenseTypeIdToUse != existingSheet.licenseTypeId ? ", fixed licenseTypeId: ${existingSheet.licenseTypeId} -> $licenseTypeIdToUse" : ""}',
            );
          } else {
            notFoundCount++;
            debugPrint(
              '   ⚠️  Sheet $sheetId not found in database! ItemQuizzes count: ${itemQuizzes.length}',
            );
            debugPrint(
              '      First ItemQuiz: idQuiz=${itemQuizzes.first['idQuiz']}, quizAnswer=${itemQuizzes.first['quizAnswer']}',
            );
            failures++;
          }
        } catch (e) {
          debugPrint('  ⚠️  Error merging ItemQuizzes into sheet $sheetId: $e');
          failures++;
        }
      }

      debugPrint(
        '   📊 ItemQuizzes merge summary: $mergedCount sheets updated, $notFoundCount sheets not found',
      );

      debugPrint(
        '  ✅ Merged ItemQuizzes: ${itemQuizzesList.length - failures} successful, $failures failures',
      );
    } catch (e) {
      if (e.toString().contains('encrypted')) {
        debugPrint('  ❌ Realm file is encrypted, will try next file: $e');
        rethrow;
      }
      debugPrint('  ❌ Error migrating ItemQuizzes from Realm: $e');
      failures++;
    }
    return failures;
  }

  /// Migrate LicenseTypes from Realm database
  Future<int> _migrateLicenseTypesFromRealm(String realmFilePath) async {
    int failures = 0;
    int successCount = 0;
    try {
      debugPrint('🔍 [LicenseTypes] Starting migration from: $realmFilePath');
      final licenseTypesJson = await _realmMigrationService.migrateLicenseTypes(
        realmFilePath,
      );
      debugPrint(
        '🔍 [LicenseTypes] Got JSON response (length: ${licenseTypesJson.length})',
      );
      final licenseTypesList = jsonDecode(licenseTypesJson) as List<dynamic>;

      debugPrint(
        '📝 Migrating ${licenseTypesList.length} LicenseTypes from Realm...',
      );
      if (licenseTypesList.isEmpty) {
        debugPrint('  ⚠️  WARNING: No LicenseTypes found in Realm!');
        return 0;
      }

      int processedCount = 0;
      for (final licenseTypeMap in licenseTypesList) {
        processedCount++;
        try {
          final licenseType = licenseTypeMap as Map<String, dynamic>;
          final licenseTypeId = licenseType['id'] as int?;
          final licenseTypeName = licenseType['name'] as String?;

          debugPrint(
            '   📄 Processing LicenseType $processedCount/${licenseTypesList.length}: id=$licenseTypeId, name=$licenseTypeName',
          );
          final companion = LicenseTypesCompanion(
            id: Value(licenseType['id'] as int? ?? 0),
            name: Value(licenseType['name'] as String? ?? ''),
            note: Value(licenseType['note'] as String?),
            isActive: Value(licenseType['isActive'] as bool? ?? true),
            hasAnswer: Value(licenseType['hasAnswer'] as bool? ?? false),
            isRevision: Value(licenseType['isRevision'] as bool? ?? false),
            maxNumberError: Value(licenseType['maxErrors'] as int? ?? 0),
            numberAnswer: Value(licenseType['numberOfAnswer'] as int? ?? 0),
            numberQuestion: Value(
              licenseType['numberOfQuestions'] as int? ?? 0,
            ),
            numberQuizzes: Value(licenseType['numberQuizzes'] as int? ?? 0),
            position: Value(licenseType['position'] as int? ?? 0),
            thumbId: Value(
              (licenseType['thumb'] as String?) != null ? 0 : null,
            ), // TODO: Map Picture ID
            updateDbId: Value(licenseType['updateDbId'] as int?),
            createdDatetime: Value(_parseRealmDate(licenseType['createdDate'])),
            modifiedDatetime: Value(_parseRealmDate(licenseType['lastUpdate'])),
            duration: Value((licenseType['time'] as num?)?.toDouble() ?? 0.0),
          );

          await _database
              .into(_database.licenseTypes)
              .insert(companion, onConflict: DoUpdate((_) => companion));
          successCount++;
        } catch (e, stackTrace) {
          failures++;
          final licenseTypeId = licenseTypeMap['id'];
          debugPrint('  ⚠️  Error migrating LicenseType $licenseTypeId: $e');
          debugPrint('      Stack trace: $stackTrace');
        }
      }

      debugPrint(
        '   📊 Migration progress: $successCount successful, $failures failures out of ${licenseTypesList.length} total',
      );
      debugPrint(
        '  ✅ Migrated LicenseTypes: ${licenseTypesList.length - failures} successful, $failures failures',
      );
    } catch (e) {
      if (e.toString().contains('encrypted')) {
        debugPrint('  ❌ Realm file is encrypted, will try next file: $e');
        rethrow;
      }
      debugPrint('  ❌ Error migrating LicenseTypes from Realm: $e');
      failures++;
    }
    return failures;
  }

  /// Migrate Manuals from Realm database
  Future<int> _migrateManualsFromRealm(String realmFilePath) async {
    int failures = 0;
    int successCount = 0;
    try {
      debugPrint('🔍 [Manuals] Starting migration from: $realmFilePath');
      final manualsJson = await _realmMigrationService.migrateManuals(
        realmFilePath,
      );
      debugPrint(
        '🔍 [Manuals] Got JSON response (length: ${manualsJson.length})',
      );
      final manualsList = jsonDecode(manualsJson) as List<dynamic>;

      debugPrint('📝 Migrating ${manualsList.length} Manuals from Realm...');
      if (manualsList.isEmpty) {
        debugPrint('  ⚠️  WARNING: No Manuals found in Realm!');
        return 0;
      }

      int processedCount = 0;
      for (final manualMap in manualsList) {
        processedCount++;
        try {
          final manual = manualMap as Map<String, dynamic>;
          final manualId = manual['id'] as int?;
          final manualTitle = manual['title'] as String?;

          // Log progress every 100 items or for first/last items
          if (processedCount == 1 ||
              processedCount == manualsList.length ||
              processedCount % 100 == 0) {
            debugPrint(
              '   📄 Processing manual $processedCount/${manualsList.length}: id=$manualId, title=${manualTitle?.substring(0, manualTitle.length.clamp(0, 30))}...',
            );
          }
          final companion = ManualsCompanion(
            id: Value(manual['id'] as int? ?? 0),
            licenseTypeId: Value(manual['licenseType'] as int? ?? 0),
            alt: Value(manual['alt'] as String?),
            createdDatetime: Value(_parseRealmDate(manual['createdDate'])),
            isActive: Value(manual['isActive'] as bool? ?? true),
            modifiedDatetime: Value(_parseRealmDate(manual['lastUpdate'])),
            note: Value(manual['note'] as String?),
            position: Value(manual['position'] as int? ?? 0),
            symbol: Value(manual['symbol'] as String?),
            content: Value(manual['text'] as String?),
            title: Value(manual['title'] as String?),
            url: Value(manual['url'] as String?),
            argumentId: Value(manual['topic'] as int? ?? 0),
            image: Value(
              (manual['image'] as String?) != null ? 0 : null,
            ), // TODO: Map Picture ID
            updateDbId: Value(manual['updateDbId'] as int?),
            video: Value(manual['videoId'] as int?),
            appId: Value(manual['appId'] as int?),
            videoOriginalId: Value(manual['videoOriginalId'] as int?),
          );

          await _database
              .into(_database.manuals)
              .insert(companion, onConflict: DoUpdate((_) => companion));
          successCount++;
        } catch (e, stackTrace) {
          failures++;
          final manualId = manualMap['id'];
          debugPrint('  ⚠️  Error migrating Manual $manualId: $e');
          debugPrint('      Stack trace: $stackTrace');
        }
      }

      debugPrint(
        '   📊 Migration progress: $successCount successful, $failures failures out of ${manualsList.length} total',
      );
      debugPrint(
        '  ✅ Migrated Manuals: ${manualsList.length - failures} successful, $failures failures',
      );
    } catch (e) {
      if (e.toString().contains('encrypted')) {
        debugPrint('  ❌ Realm file is encrypted, will try next file: $e');
        rethrow;
      }
      debugPrint('  ❌ Error migrating Manuals from Realm: $e');
      failures++;
    }
    return failures;
  }

  /// Migrate Topics (Arguments) from Realm database
  Future<int> _migrateTopicsFromRealm(String realmFilePath) async {
    int failures = 0;
    int successCount = 0;
    try {
      debugPrint('🔍 [Topics] Starting migration from: $realmFilePath');
      final topicsJson = await _realmMigrationService.migrateTopics(
        realmFilePath,
      );
      debugPrint(
        '🔍 [Topics] Got JSON response (length: ${topicsJson.length})',
      );
      final topicsList = jsonDecode(topicsJson) as List<dynamic>;

      debugPrint(
        '📝 Migrating ${topicsList.length} Topics (Arguments) from Realm...',
      );
      if (topicsList.isEmpty) {
        debugPrint('  ⚠️  WARNING: No Topics found in Realm!');
        return 0;
      }

      int processedCount = 0;
      for (final topicMap in topicsList) {
        processedCount++;
        try {
          final topic = topicMap as Map<String, dynamic>;
          final topicId = topic['id'] as int?;
          final topicName = topic['name'] as String?;

          debugPrint(
            '   📄 Processing Topic $processedCount/${topicsList.length}: id=$topicId, name=$topicName',
          );
          final companion = ArgumentsCompanion(
            id: Value(topic['id'] as int? ?? 0),
            licenseTypeId: Value(topic['licenseType'] as int? ?? 0),
            createdDatetime: Value(_parseRealmDate(topic['createdDate'])),
            isActive: Value(topic['isActive'] as bool? ?? true),
            modifiedDatetime: Value(_parseRealmDate(topic['lastUpdate'])),
            name: Value(topic['name'] as String?),
            position: Value(topic['position'] as int? ?? 0),
            updateDbId: Value(topic['updateDbId'] as int?),
          );

          await _database
              .into(_database.arguments)
              .insert(companion, onConflict: DoUpdate((_) => companion));
          successCount++;
        } catch (e, stackTrace) {
          failures++;
          final topicId = topicMap['id'];
          debugPrint('  ⚠️  Error migrating Topic $topicId: $e');
          debugPrint('      Stack trace: $stackTrace');
        }
      }

      debugPrint(
        '   📊 Migration progress: $successCount successful, $failures failures out of ${topicsList.length} total',
      );
      debugPrint(
        '  ✅ Migrated Topics: ${topicsList.length - failures} successful, $failures failures',
      );
    } catch (e) {
      if (e.toString().contains('encrypted')) {
        debugPrint('  ❌ Realm file is encrypted, will try next file: $e');
        rethrow;
      }
      debugPrint('  ❌ Error migrating Topics from Realm: $e');
      failures++;
    }
    return failures;
  }

  /// Migrate Pictures from Realm database
  Future<int> _migratePicturesFromRealm(String realmFilePath) async {
    int failures = 0;
    int successCount = 0;
    try {
      debugPrint('🔍 [Pictures] Starting migration from: $realmFilePath');
      final picturesJson = await _realmMigrationService.migratePictures(
        realmFilePath,
      );
      debugPrint(
        '🔍 [Pictures] Got JSON response (length: ${picturesJson.length})',
      );
      final picturesList = jsonDecode(picturesJson) as List<dynamic>;

      debugPrint('📝 Migrating ${picturesList.length} Pictures from Realm...');
      if (picturesList.isEmpty) {
        debugPrint('  ⚠️  WARNING: No Pictures found in Realm!');
        return 0;
      }

      int processedCount = 0;
      for (final pictureMap in picturesList) {
        processedCount++;
        try {
          final picture = pictureMap as Map<String, dynamic>;
          final pictureId = picture['id'] as int?;

          // Log progress every 100 items or for first/last items
          if (processedCount == 1 ||
              processedCount == picturesList.length ||
              processedCount % 100 == 0) {
            debugPrint(
              '   📄 Processing picture $processedCount/${picturesList.length}: id=$pictureId',
            );
          }
          // Map Realm Picture fields to Drift PictureQuizzes fields
          // Realm: url, urlHD, symbol, aspectRation -> Drift: image, imageHd, symbol, aspectRatio
          final companion = PictureQuizzesCompanion(
            id: Value(picture['id'] as int? ?? 0),
            image: Value(picture['url'] as String?),
            imageHd: Value(picture['urlHD'] as String?),
            symbol: Value(picture['symbol'] as String?),
            aspectRatio: Value(
              (picture['aspectRation'] as num?)?.toDouble() ?? 0.0,
            ),
          );

          await _database
              .into(_database.pictureQuizzes)
              .insert(companion, onConflict: DoUpdate((_) => companion));
          successCount++;
        } catch (e, stackTrace) {
          failures++;
          final pictureId = pictureMap['id'];
          debugPrint('  ⚠️  Error migrating Picture $pictureId: $e');
          debugPrint('      Stack trace: $stackTrace');
        }
      }

      debugPrint(
        '   📊 Migration progress: $successCount successful, $failures failures out of ${picturesList.length} total',
      );
      debugPrint(
        '  ✅ Migrated Pictures: ${picturesList.length - failures} successful, $failures failures',
      );
    } catch (e) {
      if (e.toString().contains('encrypted')) {
        debugPrint('  ❌ Realm file is encrypted, will try next file: $e');
        rethrow;
      }
      debugPrint('  ❌ Error migrating Pictures from Realm: $e');
      failures++;
    }
    return failures;
  }

  /// Helper to parse Realm dates
  ///
  /// Primary format: Unix timestamps (milliseconds) - integers from Realm
  /// Fallback formats: ISO8601 strings or Java Date.toString() format (for backwards compatibility)
  DateTime? _parseRealmDate(dynamic value) {
    if (value == null) return null;

    try {
      // Try parsing as Unix timestamp (milliseconds) first - this is the primary format from Realm
      if (value is int) {
        return DateTime.fromMillisecondsSinceEpoch(value);
      }
      if (value is double) {
        return DateTime.fromMillisecondsSinceEpoch(value.toInt());
      }

      // Fallback: Try parsing as string (ISO8601 or Java Date.toString() format)
      if (value is String) {
        // Try parsing as ISO8601 string first
        try {
          return DateTime.parse(value);
        } catch (e) {
          // If ISO8601 fails, try Java Date.toString() format: "Fri Nov 11 10:45:37 GMT+01:00 2016"
          // Format: "EEE MMM dd HH:mm:ss zzz yyyy"
          // intl DateFormat doesn't support Java's timezone format, so parse manually
          try {
            // Match pattern: "Fri Nov 11 10:45:37 GMT+01:00 2016"
            // Extract: day name (ignore), month, day, hour, minute, second, timezone offset, year
            final regex = RegExp(
              r'^[A-Za-z]{3}\s+([A-Za-z]{3})\s+(\d{1,2})\s+(\d{1,2}):(\d{2}):(\d{2})\s+GMT([+-]\d{2}):(\d{2})\s+(\d{4})$',
            );
            final match = regex.firstMatch(value);

            if (match != null) {
              final monthStr = match.group(1)!; // "Nov"
              final day = int.parse(match.group(2)!); // "11"
              final hour = int.parse(match.group(3)!); // "10"
              final minute = int.parse(match.group(4)!); // "45"
              final second = int.parse(match.group(5)!); // "37"
              final tzSign = match.group(6)!; // "+" or "-"
              final tzHour = int.parse(match.group(7)!); // "01"
              final tzMinute = int.parse(match.group(8)!); // "00"
              final year = int.parse(match.group(9)!); // "2016"

              // Convert month name to number
              final monthMap = {
                'Jan': 1,
                'Feb': 2,
                'Mar': 3,
                'Apr': 4,
                'May': 5,
                'Jun': 6,
                'Jul': 7,
                'Aug': 8,
                'Sep': 9,
                'Oct': 10,
                'Nov': 11,
                'Dec': 12,
              };
              final month = monthMap[monthStr];

              if (month != null) {
                // Create DateTime in UTC first (the time in the string is in the timezone)
                final localDateTime = DateTime(
                  year,
                  month,
                  day,
                  hour,
                  minute,
                  second,
                );

                // Calculate timezone offset in minutes
                final offsetHours = tzSign == '+' ? tzHour : -tzHour;
                final offsetMinutes = tzSign == '+' ? tzMinute : -tzMinute;
                final offsetTotalMinutes = (offsetHours * 60) + offsetMinutes;

                // Subtract the offset to get UTC time
                final utcDateTime = localDateTime.subtract(
                  Duration(minutes: offsetTotalMinutes),
                );

                return utcDateTime.toLocal();
              }
            }

            // If regex parsing fails, try intl DateFormat without timezone as fallback
            try {
              // Remove timezone info and try parsing without it
              final dateWithoutTz = value.replaceAll(
                RegExp(r' GMT[+-]\d{2}:\d{2}'),
                '',
              );
              final dateFormat = DateFormat(
                'EEE MMM dd HH:mm:ss yyyy',
                'en_US',
              );
              return dateFormat.parse(dateWithoutTz);
            } catch (e3) {
              debugPrint('  ⚠️  Error parsing Realm date "$value": $e3');
              return null;
            }
          } catch (e2) {
            debugPrint('  ⚠️  Error parsing Realm date "$value": $e2');
            return null;
          }
        }
      }

      // If value is neither int, double, nor string, return null
      return null;
    } catch (e) {
      debugPrint('  ⚠️  Error parsing Realm date: $e');
      return null;
    }
  }

  /// Get licenseTypeId from sheet, handling multiple possible field names
  /// If not found, tries to get from ItemQuizzes or defaults to current user's license type
  int _getLicenseTypeId(Map<String, dynamic> sheet) {
    // Try common field names
    final licenseTypeId =
        sheet['licenseTypeId'] as int? ??
        sheet['license_type_id'] as int? ??
        sheet['licenseType'] as int? ??
        sheet['license_type'] as int?;

    if (licenseTypeId != null && licenseTypeId > 0) {
      return licenseTypeId;
    }

    // If still 0 or null, log a warning
    debugPrint(
      '  ⚠️  Sheet ${sheet['id']} has no valid licenseTypeId (got: $licenseTypeId), defaulting to 0',
    );
    return 0;
  }

  // ============================================================================
  // API Database Sync Methods
  // ============================================================================

  Future<bool> syncDatabaseUpdates(UpdateDBModel? updateDBModel) async {
    try {
      debugPrint('🔄 Starting database sync from API...');
      int totalFailures = 0;

      if (updateDBModel == null) {
        return false;
      }

      // ✅ CRITICAL FIX: Each sync operation runs in its own transaction with immediate commit
      // This ensures that successfully synced data is persisted even if app crashes
      // Failed operations are skipped, allowing sync to continue

      // STEP 1: Extract and sync PictureQuiz data from nested objects
      // This must happen FIRST because of foreign key constraints
      final pictureQuizzes = _extractPictureQuizzesFromUpdate(updateDBModel);
      totalFailures += await withOperationTransaction(
        'Sync Picture Quizzes',
        () async => await _syncPictureQuizzes(pictureQuizzes),
      );

      // STEP 2: Sync entities with foreign key references to PictureQuizzes
      totalFailures += await withOperationTransaction(
        'Sync License Types',
        () async => await _syncLicenseTypes(updateDBModel.licenseTypes),
      );
      totalFailures += await withOperationTransaction(
        'Sync Arguments',
        () async => await _syncArguments(updateDBModel.arguments),
      );
      totalFailures += await withOperationTransaction(
        'Sync Manuals',
        () async => await _syncManuals(updateDBModel.manuals),
      );

      // STEP 3: Sync remaining entities
      totalFailures += await withOperationTransaction(
        'Sync Quizzes',
        () async => await _syncQuizzes(updateDBModel.quizzes),
      );
      totalFailures += await withOperationTransaction(
        'Sync Quiz Answers',
        () async => await _syncQuizAnswers(updateDBModel.quizAnswers),
      );
      totalFailures += await withOperationTransaction(
        'Sync Manual Books',
        () async => await _syncManualBooks(updateDBModel.manualBooks),
      );

      if (totalFailures == 0) {
        debugPrint('✅ Database sync completed successfully with no failures');
        return true;
      } else {
        debugPrint('⚠️  Database sync completed with $totalFailures failures');
        return false;
      }
    } catch (e, stackTrace) {
      debugPrint('❌ Error during database sync: $e');
      debugPrint('Stack trace: $stackTrace');
      return false;
    }
  }

  List<PictureQuizModel> _extractPictureQuizzesFromUpdate(
    UpdateDBModel updateDBModel,
  ) {
    final pictureQuizzes = <int, PictureQuizModel>{};

    // Extract from Arguments.thumb
    if (updateDBModel.arguments != null) {
      for (final argument in updateDBModel.arguments!) {
        if (argument.thumb != null) {
          pictureQuizzes[argument.thumb!.id] = argument.thumb!;
        }
      }
    }

    // Extract from LicenseTypes.thumb
    if (updateDBModel.licenseTypes != null) {
      for (final licenseType in updateDBModel.licenseTypes!) {
        if (licenseType.thumb != null) {
          pictureQuizzes[licenseType.thumb!.id] = licenseType.thumb!;
        }
      }
    }

    // Extract from Manuals.image
    if (updateDBModel.manuals != null) {
      for (final manual in updateDBModel.manuals!) {
        if (manual.image != null) {
          pictureQuizzes[manual.image!.id] = manual.image!;
        }
      }
    }

    debugPrint(
      '📸 Extracted ${pictureQuizzes.length} unique PictureQuiz objects from update',
    );
    return pictureQuizzes.values.toList();
  }

  Future<int> _syncPictureQuizzes(List<PictureQuizModel> pictureQuizzes) async {
    if (pictureQuizzes.isEmpty) return 0;

    int failures = 0;
    debugPrint('📝 Syncing ${pictureQuizzes.length} picture quizzes...');

    for (final pictureQuiz in pictureQuizzes) {
      try {
        final companion = PictureQuizzesCompanion(
          id: Value(pictureQuiz.id),
          image: Value(pictureQuiz.image),
          imageHd: Value(pictureQuiz.imageHd),
          aspectRatio: Value(pictureQuiz.aspectRatio ?? 0.0),
          symbol: Value(pictureQuiz.symbol),
        );

        await _database
            .into(_database.pictureQuizzes)
            .insert(companion, onConflict: DoUpdate((_) => companion));
      } catch (e) {
        debugPrint('  ⚠️  Error syncing picture quiz ${pictureQuiz.id}: $e');
        failures++;
      }
    }

    debugPrint(
      '  ✅ Synced picture quizzes: ${pictureQuizzes.length - failures} successful, $failures failures',
    );
    return failures;
  }

  /// Sync License Types from API
  Future<int> _syncLicenseTypes(List<LicenseTypeModel>? licenseTypes) async {
    if (licenseTypes == null || licenseTypes.isEmpty) return 0;

    int failures = 0;
    debugPrint('📝 Syncing ${licenseTypes.length} license types...');

    for (final licenseType in licenseTypes) {
      try {
        final companion = LicenseTypesCompanion(
          id: Value(licenseType.id),
          name: Value(licenseType.name),
          code: const Value.absent(),
          isActive: Value(licenseType.isActive),
          hasAnswer: Value(licenseType.hasAnswer ?? false),
          hasBook: Value(licenseType.hasBook ?? false),
          hasEbook: const Value(false),
          isRevision: Value(licenseType.isRevision ?? false),
          maxNumberError: Value(licenseType.maxErrors ?? 0),
          numberAnswer: Value(licenseType.numberOfAnswer ?? 0),
          numberQuestion: Value(licenseType.numberOfQuestions ?? 0),
          numberQuizzes: Value(licenseType.numberQuizzes ?? 0),
          position: Value(licenseType.position ?? 0),
          thumbId: Value(licenseType.thumb?.id),
          updateDbId: const Value.absent(),
          createdDatetime: Value(licenseType.createdDate),
          modifiedDatetime: Value(licenseType.modifiedDate),
          duration: Value(licenseType.duration.toDouble()),
          note: Value(licenseType.note),
          children: Value(jsonEncode(licenseType.children)),
          languages: Value(
            licenseType.languages != null
                ? jsonEncode(
                    licenseType.languages!.map((e) => e.toJson()).toList(),
                  )
                : '[]',
          ),
        );

        await _database
            .into(_database.licenseTypes)
            .insert(companion, onConflict: DoUpdate((_) => companion));
      } catch (e) {
        debugPrint('  ⚠️  Error syncing license type ${licenseType.id}: $e');
        failures++;
      }
    }

    debugPrint(
      '  ✅ Synced license types: ${licenseTypes.length - failures} successful, $failures failures',
    );
    return failures;
  }

  /// Sync Arguments from API
  Future<int> _syncArguments(List<ArgumentModel>? arguments) async {
    if (arguments == null || arguments.isEmpty) return 0;

    int failures = 0;
    debugPrint('📝 Syncing ${arguments.length} arguments...');

    for (final argument in arguments) {
      try {
        final companion = ArgumentsCompanion(
          id: Value(argument.id),
          name: Value(argument.name),
          numberQuestion: Value(argument.numberQuestion ?? 0),
          numberQuizzes: Value(argument.numberQuizzes ?? 0),
          position: Value(argument.position ?? 0),
          isActive: Value(argument.isActive ?? true),
          isVideo: Value(argument.isVideo ?? false),
          createdDatetime: Value(DateTime.tryParse(argument.createdDatetime)),
          modifiedDatetime: Value(DateTime.tryParse(argument.modifiedDatetime)),
          licenseTypeId: Value(argument.licenseTypeId ?? 0),
          thumbId: Value(argument.thumbId),
          updateDbId: const Value.absent(),
        );

        await _database
            .into(_database.arguments)
            .insert(companion, onConflict: DoUpdate((_) => companion));
      } catch (e) {
        debugPrint('  ⚠️  Error syncing argument ${argument.id}: $e');
        failures++;
      }
    }

    debugPrint(
      '  ✅ Synced arguments: ${arguments.length - failures} successful, $failures failures',
    );
    return failures;
  }

  /// Sync Quizzes from API
  Future<int> _syncQuizzes(List<QuizModel>? quizzes) async {
    if (quizzes == null || quizzes.isEmpty) return 0;

    int failures = 0;
    debugPrint('📝 Syncing ${quizzes.length} quizzes...');

    // await logQuizzesInDatabase("Before update");

    for (final quiz in quizzes) {
      try {
        final companion = QuizzesCompanion(
          id: Value(quiz.id),
          appId: Value(quiz.appId),
          comment: Value(quiz.comment),
          createdDatetime: Value(DateTime.tryParse(quiz.createdDatetime)),
          hasAnswer: Value(quiz.hasAnswer ?? false),
          isActive: Value(quiz.isActive ?? true),
          modifiedDatetime: Value(DateTime.tryParse(quiz.modifiedDatetime)),
          originalId: Value(quiz.originalId),
          position: Value(quiz.position ?? 0),
          // numberExtracted: Value(quiz.numberExtracted ?? 0),
          result: Value(quiz.result),
          symbol: Value(quiz.symbol),
          questionText: Value(quiz.questionText),
          argumentId: Value(quiz.argumentId ?? 0),
          licenseTypeId: Value(quiz.licenseTypeId ?? 0),
          manualId: Value(quiz.manualId),
          image: Value((quiz.image?["image"] as String?)?.addDomainIfNeeded),
          updateDbId: const Value.absent(),
        );

        await _database
            .into(_database.quizzes)
            .insert(companion, onConflict: DoUpdate((_) => companion));
      } catch (e) {
        debugPrint('  ⚠️  Error syncing quiz ${quiz.id}: $e');
        failures++;
      }
    }

    // await logQuizzesInDatabase("After update");

    debugPrint(
      '  ✅ Synced quizzes: ${quizzes.length - failures} successful, $failures failures',
    );
    return failures;
  }

  // Future<void> logQuizzesInDatabase(String logMessage) async {
  //   // Log active quizzes with license type ID 11 AFTER sync (from database)
  //   final dbQuizzes = await (_database.select(_database.quizzes)
  //         ..where((tbl) =>
  //             tbl.licenseTypeId.equals(11) & tbl.isActive.equals(true)))
  //       .get();
  //   debugPrint('🔍 $logMessage:  ${dbQuizzes.length}');
  // }

  /// Sync Quiz Answers from API
  Future<int> _syncQuizAnswers(List<QuizAnswerModel>? quizAnswers) async {
    if (quizAnswers == null || quizAnswers.isEmpty) return 0;

    int failures = 0;
    debugPrint('📝 Syncing ${quizAnswers.length} quiz answers...');

    for (final quizAnswer in quizAnswers) {
      try {
        final companion = QuizAnswersCompanion(
          id: Value(quizAnswer.id),
          answerText: Value(quizAnswer.answerText),
          position: Value(quizAnswer.position),
          createdDatetime: Value(DateTime.tryParse(quizAnswer.createdDatetime)),
          modifiedDatetime: Value(
            DateTime.tryParse(quizAnswer.modifiedDatetime),
          ),
          isCorrect: Value(quizAnswer.isCorrect),
          isActive: Value(quizAnswer.isActive ?? true),
          licenseTypeId: Value(quizAnswer.licenseTypeId ?? 0),
          quizId: Value(quizAnswer.quizId ?? 0),
          updateDbId: const Value.absent(),
        );

        await _database
            .into(_database.quizAnswers)
            .insert(companion, onConflict: DoUpdate((_) => companion));
      } catch (e) {
        debugPrint('  ⚠️  Error syncing quiz answer ${quizAnswer.id}: $e');
        failures++;
      }
    }

    debugPrint(
      '  ✅ Synced quiz answers: ${quizAnswers.length - failures} successful, $failures failures',
    );
    return failures;
  }

  /// Sync Manuals from API
  Future<int> _syncManuals(List<ManualModel>? manuals) async {
    if (manuals == null || manuals.isEmpty) return 0;

    int failures = 0;
    debugPrint('📝 Syncing ${manuals.length} manuals...');

    for (final manual in manuals) {
      try {
        // Build companion once, reuse for insert and update
        final companion = ManualsCompanion(
          id: Value(manual.id),
          title: Value(manual.title),
          content: Value(manual.content),
          summary: Value(manual.summary),
          alt: Value(manual.alt),
          note: Value(manual.note),
          symbol: Value(manual.symbol),
          url: Value(manual.url),
          position: Value(manual.position ?? 0),
          isActive: Value(manual.isActive ?? true),
          createdDatetime: Value(DateTime.tryParse(manual.createdDatetime)),
          modifiedDatetime: Value(DateTime.tryParse(manual.modifiedDatetime)),
          argumentId: Value(manual.argumentId ?? 0),
          licenseTypeId: Value(manual.licenseTypeId ?? 0),
          image: Value(manual.image?.id),
          updateDbId: const Value.absent(),
          video: Value(manual.videoId),
          fokArgumentId: Value(manual.fokArgumentId),
          appId: Value(manual.appId),
          videoOriginalId: Value(manual.videoOriginalId),
        );

        await _database
            .into(_database.manuals)
            .insert(companion, onConflict: DoUpdate((_) => companion));
      } catch (e) {
        debugPrint('  ⚠️  Error syncing manual ${manual.id}: $e');
        failures++;
      }
    }

    debugPrint(
      '  ✅ Synced manuals: ${manuals.length - failures} successful, $failures failures',
    );
    return failures;
  }

  /// Sync Manual Books from API
  Future<int> _syncManualBooks(List<ManualBookModel>? manualBooks) async {
    if (manualBooks == null || manualBooks.isEmpty) return 0;

    int failures = 0;
    debugPrint('📝 Syncing ${manualBooks.length} manual books...');

    for (final manualBook in manualBooks) {
      try {
        // Convert manuals array to JSON string for database storage
        String? manualsJson;
        if (manualBook.manuals != null) {
          manualsJson = jsonEncode(manualBook.manuals);
        }

        final companion = ManualBooksCompanion(
          id: Value(manualBook.id),
          argument: Value(manualBook.argument),
          manuals: Value(manualsJson),
          hasBeenScanned: const Value(false),
          createdDatetime: Value(DateTime.tryParse(manualBook.createdDatetime)),
          modifiedDatetime: Value(
            DateTime.tryParse(manualBook.modifiedDatetime),
          ),
          updateDbId: const Value.absent(),
        );

        await _database
            .into(_database.manualBooks)
            .insert(companion, onConflict: DoUpdate((_) => companion));
      } catch (e) {
        debugPrint('  ⚠️  Error syncing manual book ${manualBook.id}: $e');
        failures++;
      }
    }

    debugPrint(
      '  ✅ Synced manual books: ${manualBooks.length - failures} successful, $failures failures',
    );
    return failures;
  }
}
