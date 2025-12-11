import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

/// Service to communicate with Android native code for SharedPreferences migration
///
/// This service uses platform channels to:
/// 1. Read authentication data from the old Android app's SharedPreferences
/// 2. Extract JWT tokens, refresh tokens, and user information
/// 3. Return JSON format that can be consumed by Dart
@singleton
class AuthMigrationService {
  static const MethodChannel _channel = MethodChannel(
    'com.bokapp.quizpatente/auth_migration',
  );

  /// Check if old app has authentication data available for migration
  /// Returns true if auth data exists in old app's SharedPreferences
  Future<bool> hasOldAppAuthData() async {
    const maxRetries = 10;
    const retryDelay = Duration(milliseconds: 200);

    for (int attempt = 0; attempt < maxRetries; attempt++) {
      try {
        final result = await _channel.invokeMethod<bool>('hasOldAppAuthData');
        return result ?? false;
      } on PlatformException catch (e) {
        if (e.code == 'MissingPluginException' && attempt < maxRetries - 1) {
          debugPrint(
            '⚠️  Channel not ready yet, retrying... (attempt ${attempt + 1}/$maxRetries)',
          );
          await Future.delayed(retryDelay);
          continue;
        }
        debugPrint('❌ Error checking for old app auth data: ${e.message}');
        debugPrint('   Channel: ${_channel.name}');
        debugPrint('   Method: hasOldAppAuthData');
        return false;
      } catch (e) {
        if (e.toString().contains('MissingPluginException') &&
            attempt < maxRetries - 1) {
          debugPrint(
            '⚠️  Channel not ready yet, retrying... (attempt ${attempt + 1}/$maxRetries)',
          );
          await Future.delayed(retryDelay);
          continue;
        }
        debugPrint('❌ Unexpected error checking for old app auth data: $e');
        debugPrint('   Channel: ${_channel.name}');
        debugPrint('   Method: hasOldAppAuthData');
        return false;
      }
    }
    return false;
  }

  /// Inspect all SharedPreferences from old app
  /// Returns JSON string with all keys/values - useful for debugging
  /// Returns null if no data found or error occurs
  Future<String?> inspectOldAppSharedPreferences() async {
    try {
      final result = await _channel.invokeMethod<String>(
        'inspectOldAppSharedPreferences',
      );
      return result;
    } on PlatformException catch (e) {
      debugPrint('❌ Error inspecting SharedPreferences: ${e.message}');
      return null;
    } catch (e) {
      debugPrint('❌ Unexpected error inspecting SharedPreferences: $e');
      return null;
    }
  }

  /// Migrate authentication data from old Android app's SharedPreferences
  /// Returns JSON string containing authentication data (LoginResponse format)
  /// Returns null if no auth data found or error occurs
  Future<Map<String, dynamic>?> migrateAuthData() async {
    const maxRetries = 10;
    const retryDelay = Duration(milliseconds: 200);

    for (int attempt = 0; attempt < maxRetries; attempt++) {
      try {
        final result = await _channel.invokeMethod<String>('migrateAuthData');

        if (result == null || result.isEmpty) {
          debugPrint('📝 No auth data found in old app');
          return null;
        }

        // Parse JSON string to Map
        final authData = jsonDecode(result) as Map<String, dynamic>;
        debugPrint('✅ Successfully migrated auth data from old app');
        return authData;
      } on PlatformException catch (e) {
        if (e.code == 'MissingPluginException' && attempt < maxRetries - 1) {
          debugPrint(
            '⚠️  Channel not ready yet, retrying... (attempt ${attempt + 1}/$maxRetries)',
          );
          await Future.delayed(retryDelay);
          continue;
        }
        debugPrint('❌ Error migrating auth data: ${e.message}');
        debugPrint('   Channel: ${_channel.name}');
        debugPrint('   Method: migrateAuthData');
        return null;
      } catch (e) {
        if (e.toString().contains('MissingPluginException') &&
            attempt < maxRetries - 1) {
          debugPrint(
            '⚠️  Channel not ready yet, retrying... (attempt ${attempt + 1}/$maxRetries)',
          );
          await Future.delayed(retryDelay);
          continue;
        }
        debugPrint('❌ Unexpected error migrating auth data: $e');
        debugPrint('   Channel: ${_channel.name}');
        debugPrint('   Method: migrateAuthData');
        return null;
      }
    }
    return null;
  }
}
