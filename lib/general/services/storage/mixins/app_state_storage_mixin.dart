import 'dart:convert';
import 'package:who_mobile_project/general/models/login/stored_account.dart';
import 'package:who_mobile_project/general/services/storage/base_storage.dart';

/// Mixin for app state storage operations
mixin AppStateStorageMixin on BaseStorage {
  // Storage keys
  static const _storedAccountsKey = "stored_accounts";
  static const _nativeUserPreferencesMigrationCompletedKey =
      "native_user_preferences_migration_completed";
  static const _nativeGuestUserMigrationCompletedKey =
      "native_guest_user_migration_completed";

  /// Get stored accounts list
  Future<List<StoredAccount>> getStoredAccounts() async {
    try {
      final accountsJson = sharedPreferences.getString(_storedAccountsKey);
      if (accountsJson != null && accountsJson.isNotEmpty) {
        final List<dynamic> accountsList = jsonDecode(accountsJson);
        return accountsList
            .map(
              (accountJson) =>
                  StoredAccount.fromJson(accountJson as Map<String, dynamic>),
            )
            .toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  /// Set stored accounts list
  Future<void> setStoredAccounts(List<StoredAccount> accounts) async {
    try {
      final accountsJson = jsonEncode(
        accounts.map((account) => account.toJson()).toList(),
      );
      await sharedPreferences.setString(_storedAccountsKey, accountsJson);
    } catch (e) {
      // Handle error silently
    }
  }

  /// Set native user preferences migration completed flag
  Future<void> setNativeUserPreferencesMigrationCompleted(
    bool completed,
  ) async {
    await sharedPreferences.setBool(
      _nativeUserPreferencesMigrationCompletedKey,
      completed,
    );
  }

  /// Get native user preferences migration completed flag
  bool getNativeUserPreferencesMigrationCompleted() {
    return sharedPreferences.getBool(
          _nativeUserPreferencesMigrationCompletedKey,
        ) ??
        false;
  }

  /// Set native guest user migration completed flag
  Future<void> setNativeGuestUserMigrationCompleted(bool completed) async {
    await sharedPreferences.setBool(
      _nativeGuestUserMigrationCompletedKey,
      completed,
    );
  }

  bool getNativeGuestUserMigrationCompleted() {
    return sharedPreferences.getBool(_nativeGuestUserMigrationCompletedKey) ??
        false;
  }
}
