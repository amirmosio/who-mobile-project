import 'package:who_mobile_project/general/services/storage/base_storage.dart';

mixin DatabaseMigrationStorageMixin on BaseStorage {
  static const _dbMigrationPrefix = 'gev_db_migration_completed_v1';
  static const _dbMigrationLicenseTypeKey = 'gev_db_migration_license_type';
  static const _dbMigrationLanguageKey = 'gev_db_migration_language';
  static const _dbMigrationCompletedV1Key = 'gev_db_migration_completed_v1';
  static const _nativeDatabaseMigrationCompletedKey =
      'native_database_migration_completed';
  static const _lastDatabaseUpdateKey = 'last_database_update';
  static const _developmentResetOfDatabaseKey = 'dev_reset_of_database38';

  String _buildMigrationKey(int licenseTypeId, String language) {
    return '${_dbMigrationPrefix}_${licenseTypeId}_$language';
  }

  bool getDatabaseMigrationCompleted({
    required int licenseTypeId,
    required String language,
  }) {
    final key = _buildMigrationKey(licenseTypeId, language);
    return sharedPreferences.getBool(key) ?? false;
  }

  Future<void> setDatabaseMigrationCompleted({
    required int licenseTypeId,
    required String language,
    required bool completed,
  }) async {
    final key = _buildMigrationKey(licenseTypeId, language);
    await sharedPreferences.setBool(key, completed);
  }

  Future<void> setDatabaseMigrationLicenseType(int licenseTypeId) async {
    await sharedPreferences.setInt(_dbMigrationLicenseTypeKey, licenseTypeId);
  }

  int? getDatabaseMigrationLicenseType() {
    return sharedPreferences.getInt(_dbMigrationLicenseTypeKey);
  }

  Future<void> setDatabaseMigrationLanguage(String language) async {
    await sharedPreferences.setString(_dbMigrationLanguageKey, language);
  }

  String? getDatabaseMigrationLanguage() {
    return sharedPreferences.getString(_dbMigrationLanguageKey);
  }

  bool getDatabaseMigrationCompletedV1() {
    return sharedPreferences.getBool(_dbMigrationCompletedV1Key) ?? false;
  }

  Future<void> setLastDatabaseUpdate(
    int licenseTypeId,
    String timestamp,
  ) async {
    await sharedPreferences.setStringList(_lastDatabaseUpdateKey, [
      licenseTypeId.toString(),
      timestamp,
    ]);
  }

  String? getLastDatabaseUpdate(int licenseTypeId) {
    try {
      List<String> values =
          sharedPreferences.getStringList(_lastDatabaseUpdateKey) ?? [];
      if (values.isNotEmpty && values[0] == licenseTypeId.toString()) {
        return values[1];
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<void> resetDatabaseMigrationFlag({
    required int licenseTypeId,
    required String language,
  }) async {
    final key = _buildMigrationKey(licenseTypeId, language);
    await sharedPreferences.remove(key);
  }

  Future<void> clearAllDatabaseMigrationFlags() async {
    final keys = sharedPreferences.getKeys().where(
      (k) => k.startsWith(_dbMigrationPrefix),
    );
    for (final key in keys) {
      await sharedPreferences.remove(key);
    }
    // Also clear the last database update timestamp to force a full sync
    await sharedPreferences.remove(_lastDatabaseUpdateKey);
  }

  /// Native database migration (iOS CoreData -> Flutter Drift)
  bool getNativeDatabaseMigrationCompleted() {
    return sharedPreferences.getBool(_nativeDatabaseMigrationCompletedKey) ??
        false;
  }

  Future<void> setNativeDatabaseMigrationCompleted(bool completed) async {
    await sharedPreferences.setBool(
      _nativeDatabaseMigrationCompletedKey,
      completed,
    );
  }

  bool getDevelopmentResetOfDatabase() {
    return sharedPreferences.getBool(_developmentResetOfDatabaseKey) ?? false;
  }

  Future<void> setDevelopmentResetOfDatabase(bool completed) async {
    await sharedPreferences.setBool(_developmentResetOfDatabaseKey, completed);
  }
}
