import 'package:flutter/foundation.dart' show protected;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:who_mobile_project/general/services/device/device_service.dart';

/// Base storage manager that provides access to storage instances
/// Instances are created and accessed per-instance (not static)
///
/// Storage instances are @protected, meaning they are only accessible
/// to mixins and subclasses, not to external consumers.
abstract class BaseStorage {
  /// SharedPreferences instance (protected - accessible to mixins only)
  @protected
  late SharedPreferences sharedPreferences;

  /// FlutterSecureStorage instance (protected - accessible to mixins only)
  @protected
  late FlutterSecureStorage secureStorage;

  bool _isInitialized = false;

  /// Initialize storage instances
  Future<void> initialize() async {
    if (_isInitialized) {
      return;
    }

    sharedPreferences = await SharedPreferences.getInstance();

    if (DeviceUtils.getInstance().isAndroid) {
      secureStorage = const FlutterSecureStorage(
        aOptions: AndroidOptions(encryptedSharedPreferences: true),
      );
    } else if (DeviceUtils.getInstance().isIos) {
      secureStorage = const FlutterSecureStorage();
    }

    _isInitialized = true;
  }

  /// Check if storage is initialized
  bool get isInitialized => _isInitialized;
}
