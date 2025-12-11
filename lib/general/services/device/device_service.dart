import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:who_mobile_project/general/services/network/error_handling_service.dart';
import 'package:who_mobile_project/network/device_info.dart';

class DeviceUtils {
  static DeviceUtils? _utility;
  static late String _cachedAppVersion;
  static late int _cachedBuildNumber;

  static DeviceUtils getInstance() {
    _utility ??= DeviceUtils();
    return _utility!;
  }

  /// Initialize cached app version for synchronous access
  /// Should be called once at app startup
  static Future<void> init() async {
    _utility ??= DeviceUtils();
    final packageInfo = await PackageInfo.fromPlatform();
    _cachedAppVersion = packageInfo.version;
    _cachedBuildNumber = int.parse(packageInfo.buildNumber);
  }

  static String getAppVersionSync() {
    return _cachedAppVersion;
  }

  /// Get cached build number and version synchronously
  static Pair<int, String> getAppVersion() {
    return Pair(_cachedBuildNumber, _cachedAppVersion);
  }

  bool get isWeb {
    return kIsWeb;
  }

  bool get isAndroid {
    if (!kIsWeb && Platform.isAndroid) return true;
    return false;
  }

  bool get isIos {
    if (!kIsWeb && Platform.isIOS) return true;
    return false;
  }

  Future<DeviceOrBrowserInfo> getDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (kIsWeb) {
      WebBrowserInfo webBrowserInfo = await deviceInfo.webBrowserInfo;
      return DeviceOrBrowserInfo(
        id: "",
        operatingSystem: webBrowserInfo.platform,
        operatingSystemVersion: webBrowserInfo.userAgent,
      );
    } else if (Platform.isAndroid) {
      AndroidDeviceInfo info = await deviceInfo.androidInfo;
      return DeviceOrBrowserInfo(
        id: info.id,
        operatingSystem: Platform.operatingSystem,
        operatingSystemVersion: info.version.release,
      );
    } else if (Platform.isIOS) {
      IosDeviceInfo info = await deviceInfo.iosInfo;
      return DeviceOrBrowserInfo(
        id: info.identifierForVendor,
        operatingSystem: Platform.operatingSystem,
        operatingSystemVersion: info.systemVersion,
      );
    }
    return DeviceOrBrowserInfo();
  }

  Future<String> getDeviceId() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.id;
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return iosInfo.identifierForVendor!;
    }
    throw Exception('Unknown platform');
  }

  /// Get OS value for API requests
  /// 1 = iOS, 2 = Android
  /// This matches the backend API validation
  static int getOsValue() {
    if (kIsWeb) {
      return 2; // Default to Android for web
    } else if (Platform.isIOS) {
      return 1;
    } else if (Platform.isAndroid) {
      return 2;
    } else {
      // Fallback for other platforms (desktop, etc.)
      return 2;
    }
  }
}
