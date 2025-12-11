import 'dart:io';

// COMMENTED OUT - Firebase (keeping for future use)
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:permission_handler/permission_handler.dart';

class YRPermissionHandler {
  YRPermissionHandler._privateConstructor();

  static Future<bool> requestNotificationPermission() async {
   return true;
  }

  static Future<bool> requestExactAlarmPermission() async {
    if (!Platform.isAndroid) {
      return true;
    }

    final currentStatus = await Permission.scheduleExactAlarm.status;
    if (currentStatus.isGranted) {
      debugPrint('⏰ Exact alarm permission already granted');
      return true;
    }

    debugPrint('⏰ Exact alarm permission current status: $currentStatus');
    final requestedStatus = await Permission.scheduleExactAlarm.request();
    debugPrint('⏰ Exact alarm permission request result: $requestedStatus');

    if (requestedStatus.isGranted) {
      return true;
    }

    if (requestedStatus.isPermanentlyDenied) {
      debugPrint(
        '⚠️ Exact alarm permission permanently denied. Opening settings...',
      );
      await openAppSettings();
    }

    return false;
  }

  static Future<bool> ensureReminderPermissions() async {
    final notificationsGranted = await requestNotificationPermission();
    final exactAlarmsGranted = await requestExactAlarmPermission();
    debugPrint(
      '📊 Reminder permissions summary -> notifications: $notificationsGranted, '
      'exact alarms: $exactAlarmsGranted',
    );
    return notificationsGranted && exactAlarmsGranted;
  }

  /// Opens the app settings page so user can manually enable permissions
  static Future<bool> openYRAppSettings() async {
    debugPrint('🔧 Opening app settings for manual permission configuration');
    return await openAppSettings();
  }
}
