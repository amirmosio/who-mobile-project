import 'package:flutter/services.dart';

/// Manages device orientation with proper cross-platform handling
///
/// Uses SystemChrome.setPreferredOrientations to control allowed orientations.
/// The orientation will update automatically when the device is rotated.
class OrientationManager {
  /// Sets the preferred orientations
  static Future<void> setPreferredOrientations(
    List<DeviceOrientation> orientations,
  ) async {
    await SystemChrome.setPreferredOrientations(orientations);
  }

  /// Enable all orientations (for fullscreen views)
  static Future<void> enableAllOrientations() async {
    await setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  /// Lock to portrait orientation only
  static Future<void> lockToPortrait() async {
    await setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  /// Lock to landscape orientation only
  static Future<void> lockToLandscape() async {
    await setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }
}
