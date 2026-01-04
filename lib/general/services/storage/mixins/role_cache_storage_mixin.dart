import 'dart:convert';

import 'package:who_mobile_project/general/constants/user_roles.dart';
import 'package:who_mobile_project/general/models/auth/app_user.dart';
import 'package:who_mobile_project/general/services/storage/base_storage.dart';

/// Mixin for caching user role data in secure storage
/// Provides fast access to role information without Firebase calls
mixin RoleCacheStorageMixin on BaseStorage {
  /// Key for storing cached user role
  static const String _cachedUserRoleKey = 'cached_user_role';

  /// Key for storing cached user data
  static const String _cachedUserDataKey = 'cached_user_data';

  /// Key for storing cache timestamp
  static const String _cacheTimestampKey = 'role_cache_timestamp';

  /// Cache validity duration (5 minutes)
  static const Duration cacheValidityDuration = Duration(minutes: 5);

  /// Cache the current user's role for quick access
  Future<void> cacheUserRole(UserRole role) async {
    await secureStorage.write(
      key: _cachedUserRoleKey,
      value: role.toFirestoreValue(),
    );
    await _updateCacheTimestamp();
  }

  /// Get cached user role
  /// Returns null if no cached role or cache is expired
  Future<UserRole?> getCachedUserRole() async {
    if (!await _isCacheValid()) {
      return null;
    }

    final value = await secureStorage.read(key: _cachedUserRoleKey);
    if (value == null) {
      return null;
    }
    return UserRole.fromFirestoreValue(value);
  }

  /// Cache the entire user data for quick access
  Future<void> cacheUserData(AppUser user) async {
    final jsonString = jsonEncode(user.toJson());
    await secureStorage.write(key: _cachedUserDataKey, value: jsonString);
    await _updateCacheTimestamp();
  }

  /// Get cached user data
  /// Returns null if no cached data or cache is expired
  Future<AppUser?> getCachedUserData() async {
    if (!await _isCacheValid()) {
      return null;
    }

    final jsonString = await secureStorage.read(key: _cachedUserDataKey);
    if (jsonString == null) {
      return null;
    }

    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return AppUser.fromJson(json);
    } catch (e) {
      // Invalid JSON, clear cache
      await clearRoleCache();
      return null;
    }
  }

  /// Clear all role-related cache
  Future<void> clearRoleCache() async {
    await secureStorage.delete(key: _cachedUserRoleKey);
    await secureStorage.delete(key: _cachedUserDataKey);
    await secureStorage.delete(key: _cacheTimestampKey);
  }

  /// Update cache timestamp to current time
  Future<void> _updateCacheTimestamp() async {
    await secureStorage.write(
      key: _cacheTimestampKey,
      value: DateTime.now().toIso8601String(),
    );
  }

  /// Check if cache is still valid (not expired)
  Future<bool> _isCacheValid() async {
    final timestampString = await secureStorage.read(key: _cacheTimestampKey);
    if (timestampString == null) {
      return false;
    }

    try {
      final timestamp = DateTime.parse(timestampString);
      final now = DateTime.now();
      return now.difference(timestamp) < cacheValidityDuration;
    } catch (e) {
      return false;
    }
  }

  /// Force refresh cache timestamp (extend validity)
  Future<void> extendCacheValidity() async {
    await _updateCacheTimestamp();
  }

  /// Check if user is cached and has admin access
  /// Quick check without async if cache was recently set
  Future<bool> hasCachedAdminAccess() async {
    final role = await getCachedUserRole();
    return role?.isAdminOrAbove ?? false;
  }
}
