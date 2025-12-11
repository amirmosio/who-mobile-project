import 'dart:convert';
import 'package:who_mobile_project/general/services/storage/base_storage.dart';
import 'package:who_mobile_project/models/config/config_model.dart';

/// Mixin for config storage operations
mixin ConfigStorageMixin on BaseStorage {
  // Storage keys
  static const _cachedConfigsKey = "cached_configs";

  /// Cache configs locally
  Future<void> cacheConfigs(List<ConfigModel> configs) async {
    final configMap = <String, String>{};
    for (final config in configs) {
      configMap[config.key] = jsonEncode(config.toJson());
    }

    await sharedPreferences.setString(_cachedConfigsKey, jsonEncode(configMap));
  }

  /// Get cached config value by key
  T? getCachedConfigValue<T>(String key) {
    try {
      final cachedConfigsJson = sharedPreferences.getString(_cachedConfigsKey);
      if (cachedConfigsJson == null) return null;

      final configMap = jsonDecode(cachedConfigsJson) as Map<String, dynamic>;
      final configJson = configMap[key];
      if (configJson == null) return null;

      final config = ConfigModel.fromJson(jsonDecode(configJson));
      return config.getParsedValue<T>();
    } catch (e) {
      return null;
    }
  }

  /// Check if configs are cached
  bool hasCachedConfigs() {
    return sharedPreferences.containsKey(_cachedConfigsKey);
  }

  /// Clear cached configs
  Future<void> clearCachedConfigs() async {
    await sharedPreferences.remove(_cachedConfigsKey);
  }

  /// Get all cached config keys
  Set<String> getCachedConfigKeys() {
    try {
      final cachedConfigsJson = sharedPreferences.getString(_cachedConfigsKey);
      if (cachedConfigsJson == null) return <String>{};

      final configMap = jsonDecode(cachedConfigsJson) as Map<String, dynamic>;
      return configMap.keys.toSet();
    } catch (e) {
      return <String>{};
    }
  }
}
