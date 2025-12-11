import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

/// Service to communicate with Android native code for Realm database migration
///
/// This service uses platform channels to:
/// 1. Find Realm database files from the old Android app
/// 2. Read and export data from Realm databases
/// 3. Convert Realm data to JSON format that can be consumed by Dart
@singleton
class RealmMigrationService {
  static const MethodChannel _channel = MethodChannel(
    'com.bokapp.quizpatente/realm_migration',
  );

  /// Find all Realm database files in the app's directory
  /// Returns a list of file paths
  Future<List<String>> findRealmFiles() async {
    try {
      final result = await _channel.invokeMethod<List<dynamic>>(
        'findRealmFiles',
      );
      if (result == null) {
        return [];
      }
      return result.map((e) => e.toString()).toList();
    } on PlatformException catch (e) {
      debugPrint('❌ Error finding Realm files: ${e.message}');
      return [];
    } catch (e) {
      debugPrint('❌ Unexpected error finding Realm files: $e');
      return [];
    }
  }

  /// Migrate Quiz data from Realm database
  /// Returns JSON string containing quiz data
  /// Throws exception if file is encrypted or other error occurs
  Future<String> migrateQuizzes(String? realmFilePath) async {
    try {
      final result = await _channel.invokeMethod<String>('migrateQuizzes', {
        'realmFilePath': realmFilePath,
      });
      return result ?? '[]';
    } on PlatformException catch (e) {
      final errorMsg = e.message ?? '';
      if (errorMsg.contains('encrypted') ||
          errorMsg.contains('invalid mnemonic')) {
        debugPrint('❌ Realm file is encrypted: ${e.message}');
        // Re-throw to signal Dart code to try next file
        throw Exception('Realm file is encrypted: $realmFilePath');
      }
      debugPrint('❌ Error migrating quizzes from Realm: ${e.message}');
      // Re-throw other errors too
      throw Exception('Error migrating quizzes: ${e.message}');
    } catch (e) {
      debugPrint('❌ Unexpected error migrating quizzes: $e');
      // Re-throw to let caller handle it
      rethrow;
    }
  }

  /// Migrate Sheets data from Realm database
  /// Returns JSON string containing sheet data
  /// Throws exception if file is encrypted or other error occurs
  Future<String> migrateSheets(String? realmFilePath) async {
    try {
      final result = await _channel.invokeMethod<String>('migrateSheets', {
        'realmFilePath': realmFilePath,
      });
      return result ?? '[]';
    } on PlatformException catch (e) {
      final errorMsg = e.message ?? '';
      if (errorMsg.contains('encrypted') ||
          errorMsg.contains('invalid mnemonic')) {
        debugPrint('❌ Realm file is encrypted: ${e.message}');
        throw Exception('Realm file is encrypted: $realmFilePath');
      }
      debugPrint('❌ Error migrating sheets from Realm: ${e.message}');
      throw Exception('Error migrating sheets: ${e.message}');
    } catch (e) {
      debugPrint('❌ Unexpected error migrating sheets: $e');
      rethrow;
    }
  }

  /// Migrate Quiz Answers data from Realm database
  /// Returns JSON string containing quiz answer data
  /// Throws exception if file is encrypted or other error occurs
  Future<String> migrateQuizAnswers(String? realmFilePath) async {
    try {
      final result = await _channel.invokeMethod<String>('migrateQuizAnswers', {
        'realmFilePath': realmFilePath,
      });
      return result ?? '[]';
    } on PlatformException catch (e) {
      final errorMsg = e.message ?? '';
      if (errorMsg.contains('encrypted') ||
          errorMsg.contains('invalid mnemonic')) {
        debugPrint('❌ Realm file is encrypted: ${e.message}');
        throw Exception('Realm file is encrypted: $realmFilePath');
      }
      debugPrint('❌ Error migrating quiz answers from Realm: ${e.message}');
      throw Exception('Error migrating quiz answers: ${e.message}');
    } catch (e) {
      debugPrint('❌ Unexpected error migrating quiz answers: $e');
      rethrow;
    }
  }

  /// Migrate Manual Books data from Realm database
  /// Returns JSON string containing manual book data
  /// Throws exception if file is encrypted or other error occurs
  Future<String> migrateManualBooks(String? realmFilePath) async {
    try {
      final result = await _channel.invokeMethod<String>('migrateManualBooks', {
        'realmFilePath': realmFilePath,
      });
      return result ?? '[]';
    } on PlatformException catch (e) {
      final errorMsg = e.message ?? '';
      if (errorMsg.contains('encrypted') ||
          errorMsg.contains('invalid mnemonic')) {
        debugPrint('❌ Realm file is encrypted: ${e.message}');
        throw Exception('Realm file is encrypted: $realmFilePath');
      }
      debugPrint('❌ Error migrating manual books from Realm: ${e.message}');
      throw Exception('Error migrating manual books: ${e.message}');
    } catch (e) {
      debugPrint('❌ Unexpected error migrating manual books: $e');
      rethrow;
    }
  }

  /// Inspect all Realm files and return diagnostic information
  /// Returns JSON string with information about each Realm file:
  /// - Which schemas/models exist in each file
  /// - How many objects are in each schema
  /// - Field information for each schema
  /// - Whether files can be opened and if they're encrypted
  Future<Map<String, dynamic>> inspectRealmFiles() async {
    try {
      final result = await _channel.invokeMethod<String>('inspectRealmFiles');
      if (result == null) {
        return {};
      }
      // Parse the JSON string to a Map
      return jsonDecode(result) as Map<String, dynamic>;
    } on PlatformException catch (e) {
      debugPrint('❌ Error inspecting Realm files: ${e.message}');
      return {};
    } catch (e) {
      debugPrint('❌ Unexpected error inspecting Realm files: $e');
      return {};
    }
  }

  /// Migrate User data from Realm database
  /// Returns JSON string containing user data
  /// Throws exception if file is encrypted or other error occurs
  Future<String> migrateUsers(String? realmFilePath) async {
    try {
      final result = await _channel.invokeMethod<String>('migrateUsers', {
        'realmFilePath': realmFilePath,
      });
      return result ?? '[]';
    } on PlatformException catch (e) {
      final errorMsg = e.message ?? '';
      if (errorMsg.contains('encrypted') ||
          errorMsg.contains('invalid mnemonic')) {
        debugPrint('❌ Realm file is encrypted: ${e.message}');
        throw Exception('Realm file is encrypted: $realmFilePath');
      }
      debugPrint('❌ Error migrating users from Realm: ${e.message}');
      throw Exception('Error migrating users: ${e.message}');
    } catch (e) {
      debugPrint('❌ Unexpected error migrating users: $e');
      rethrow;
    }
  }

  /// Migrate ItemQuizzes data from Realm database
  /// Returns JSON string containing ItemQuizzes data
  /// Throws exception if file is encrypted or other error occurs
  Future<String> migrateItemQuizzes(String? realmFilePath) async {
    try {
      final result = await _channel.invokeMethod<String>('migrateItemQuizzes', {
        'realmFilePath': realmFilePath,
      });
      return result ?? '[]';
    } on PlatformException catch (e) {
      final errorMsg = e.message ?? '';
      if (errorMsg.contains('encrypted') ||
          errorMsg.contains('invalid mnemonic')) {
        debugPrint('❌ Realm file is encrypted: ${e.message}');
        throw Exception('Realm file is encrypted: $realmFilePath');
      }
      debugPrint('❌ Error migrating ItemQuizzes from Realm: ${e.message}');
      throw Exception('Error migrating ItemQuizzes: ${e.message}');
    } catch (e) {
      debugPrint('❌ Unexpected error migrating ItemQuizzes: $e');
      rethrow;
    }
  }

  /// Migrate LicenseTypes data from Realm database
  /// Returns JSON string containing LicenseTypes data
  /// Throws exception if file is encrypted or other error occurs
  Future<String> migrateLicenseTypes(String? realmFilePath) async {
    try {
      final result = await _channel.invokeMethod<String>(
        'migrateLicenseTypes',
        {'realmFilePath': realmFilePath},
      );
      return result ?? '[]';
    } on PlatformException catch (e) {
      final errorMsg = e.message ?? '';
      if (errorMsg.contains('encrypted') ||
          errorMsg.contains('invalid mnemonic')) {
        debugPrint('❌ Realm file is encrypted: ${e.message}');
        throw Exception('Realm file is encrypted: $realmFilePath');
      }
      debugPrint('❌ Error migrating LicenseTypes from Realm: ${e.message}');
      throw Exception('Error migrating LicenseTypes: ${e.message}');
    } catch (e) {
      debugPrint('❌ Unexpected error migrating LicenseTypes: $e');
      rethrow;
    }
  }

  /// Migrate Manuals data from Realm database
  /// Returns JSON string containing Manuals data
  /// Throws exception if file is encrypted or other error occurs
  Future<String> migrateManuals(String? realmFilePath) async {
    try {
      final result = await _channel.invokeMethod<String>('migrateManuals', {
        'realmFilePath': realmFilePath,
      });
      return result ?? '[]';
    } on PlatformException catch (e) {
      final errorMsg = e.message ?? '';
      if (errorMsg.contains('encrypted') ||
          errorMsg.contains('invalid mnemonic')) {
        debugPrint('❌ Realm file is encrypted: ${e.message}');
        throw Exception('Realm file is encrypted: $realmFilePath');
      }
      debugPrint('❌ Error migrating Manuals from Realm: ${e.message}');
      throw Exception('Error migrating Manuals: ${e.message}');
    } catch (e) {
      debugPrint('❌ Unexpected error migrating Manuals: $e');
      rethrow;
    }
  }

  /// Migrate Topics (Arguments) data from Realm database
  /// Returns JSON string containing Topics data
  /// Throws exception if file is encrypted or other error occurs
  Future<String> migrateTopics(String? realmFilePath) async {
    try {
      final result = await _channel.invokeMethod<String>('migrateTopics', {
        'realmFilePath': realmFilePath,
      });
      return result ?? '[]';
    } on PlatformException catch (e) {
      final errorMsg = e.message ?? '';
      if (errorMsg.contains('encrypted') ||
          errorMsg.contains('invalid mnemonic')) {
        debugPrint('❌ Realm file is encrypted: ${e.message}');
        throw Exception('Realm file is encrypted: $realmFilePath');
      }
      debugPrint('❌ Error migrating Topics from Realm: ${e.message}');
      throw Exception('Error migrating Topics: ${e.message}');
    } catch (e) {
      debugPrint('❌ Unexpected error migrating Topics: $e');
      rethrow;
    }
  }

  /// Migrate Pictures data from Realm database
  /// Returns JSON string containing Pictures data
  /// Throws exception if file is encrypted or other error occurs
  Future<String> migratePictures(String? realmFilePath) async {
    try {
      final result = await _channel.invokeMethod<String>('migratePictures', {
        'realmFilePath': realmFilePath,
      });
      return result ?? '[]';
    } on PlatformException catch (e) {
      final errorMsg = e.message ?? '';
      if (errorMsg.contains('encrypted') ||
          errorMsg.contains('invalid mnemonic')) {
        debugPrint('❌ Realm file is encrypted: ${e.message}');
        throw Exception('Realm file is encrypted: $realmFilePath');
      }
      debugPrint('❌ Error migrating Pictures from Realm: ${e.message}');
      throw Exception('Error migrating Pictures: ${e.message}');
    } catch (e) {
      debugPrint('❌ Unexpected error migrating Pictures: $e');
      rethrow;
    }
  }
}
