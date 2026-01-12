import 'package:who_mobile_project/general/services/storage/storage_manager.dart';

/// Mock implementation of StorageManager for testing
class MockStorageManager implements StorageManager {
  final Map<String, dynamic> _storage = {};

  @override
  Future<void> init() async {
    // Mock initialization - does nothing
  }

  @override
  Future<void> saveString(String key, String value) async {
    _storage[key] = value;
  }

  @override
  Future<String?> getString(String key) async {
    return _storage[key] as String?;
  }

  @override
  Future<void> saveInt(String key, int value) async {
    _storage[key] = value;
  }

  @override
  Future<int?> getInt(String key) async {
    return _storage[key] as int?;
  }

  @override
  Future<void> saveBool(String key, bool value) async {
    _storage[key] = value;
  }

  @override
  Future<bool?> getBool(String key) async {
    return _storage[key] as bool?;
  }

  @override
  Future<void> saveDouble(String key, double value) async {
    _storage[key] = value;
  }

  @override
  Future<double?> getDouble(String key) async {
    return _storage[key] as double?;
  }

  @override
  Future<void> saveStringList(String key, List<String> value) async {
    _storage[key] = value;
  }

  @override
  Future<List<String>?> getStringList(String key) async {
    return _storage[key] as List<String>?;
  }

  @override
  Future<void> remove(String key) async {
    _storage.remove(key);
  }

  @override
  Future<void> clear() async {
    _storage.clear();
  }

  @override
  Future<bool> containsKey(String key) async {
    return _storage.containsKey(key);
  }

  @override
  Set<String> getKeys() {
    return _storage.keys.toSet();
  }
}
