import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:who_mobile_project/general/services/device/device_service.dart';
import 'package:injectable/injectable.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;
import 'package:who_mobile_project/general/services/permissions/permission_service.dart';
import 'package:who_mobile_project/app_core/notification/notification_manager.dart';

/// Service for managing quiz reminder local notifications
@singleton
class QuizReminderService {
  final NotificationManager _notificationManager;
  bool _isInitialized = false;

  static const MethodChannel _androidReminderChannel = MethodChannel(
    'com.bokapp.quizpatente/quizReminder',
  );

  QuizReminderService(this._notificationManager) {
    _initialize();
  }

  /// Get the local notifications plugin from FirebaseServiceManager
  FlutterLocalNotificationsPlugin get _localNotifications =>
      _notificationManager.plugin;

  Future<void> _initialize() async {
    debugPrint('🔧 Initializing QuizReminderService');
    if (DeviceUtils.getInstance().isAndroid) {
      debugPrint('🤖 Android detected; native scheduler handles setup');
      return;
    } else {
      // iOS only: Initialize timezone for scheduled notifications
      await _initializeTimezone();
      debugPrint('✅ QuizReminderService initialization complete (iOS)');
    }
  }

  Future<void> _initializeTimezone() async {
    // iOS only - Android uses native AlarmManager
    if (DeviceUtils.getInstance().isAndroid) {
      return;
    }
    if (_isInitialized) {
      return;
    }

    tz_data.initializeTimeZones();

    // Get the device's UTC offset to find the correct timezone
    final now = DateTime.now();
    final utcOffset = now.timeZoneOffset;
    final offsetHours = utcOffset.inHours;

    // Find timezone location based on UTC offset
    tz.Location location;

    if (offsetHours == 1 || offsetHours == 2) {
      // Italy/Rome timezone (UTC+1 CET or UTC+2 CEST)
      location = tz.getLocation('Europe/Rome');
    } else {
      // Try to find a matching timezone by offset
      try {
        final matchingZones = tz.timeZoneDatabase.locations.values.where((loc) {
          final testTime = tz.TZDateTime.now(loc);
          return testTime.timeZoneOffset == utcOffset;
        }).toList();

        if (matchingZones.isNotEmpty) {
          location = matchingZones.first;
        } else {
          location = tz.UTC;
        }
      } catch (e) {
        location = tz.getLocation('Europe/Rome');
      }
    }

    tz.setLocalLocation(location);
    if (kDebugMode) {
      debugPrint('🌐 iOS timezone: ${tz.local.name}');
    }
    _isInitialized = true;
  }

  Future<bool> scheduleQuizReminder({
    required int hour,
    required int minute,
    required String title,
    required String body,
  }) {
    if (DeviceUtils.getInstance().isAndroid) {
      return _scheduleReminderOnAndroid(
        hour: hour,
        minute: minute,
        title: title,
        body: body,
      );
    }
    return _scheduleReminderOnIOS(
      hour: hour,
      minute: minute,
      title: title,
      body: body,
    );
  }

  Future<bool> _scheduleReminderOnAndroid({
    required int hour,
    required int minute,
    required String title,
    required String body,
  }) async {
    final permissionsGranted =
        await YRPermissionHandler.ensureReminderPermissions();
    if (!permissionsGranted) {
      return false;
    }

    try {
      final result = await _androidReminderChannel.invokeMethod<bool>(
        'scheduleReminder',
        {'hour': hour, 'minute': minute, 'title': title, 'body': body},
      );
      if (kDebugMode) {
        debugPrint('🤖 Android reminder scheduled: $result');
      }
      return result ?? false;
    } catch (e, stackTrace) {
      debugPrint('❌ Unexpected Android scheduling error: $e');
      debugPrint('Stack trace: $stackTrace');
      return false;
    }
  }

  Future<bool> _scheduleReminderOnIOS({
    required int hour,
    required int minute,
    required String title,
    required String body,
  }) async {
    try {
      await _initializeTimezone();

      final permissionsGranted =
          await YRPermissionHandler.ensureReminderPermissions();
      if (!permissionsGranted) {
        return false;
      }

      await cancelQuizReminder();

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        interruptionLevel: InterruptionLevel.active,
      );

      const notificationDetails = NotificationDetails(iOS: iosDetails);

      final now = tz.TZDateTime.now(tz.local);
      var nextScheduleTime = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        hour,
        minute,
      );

      if (nextScheduleTime.isBefore(now)) {
        nextScheduleTime = nextScheduleTime.add(const Duration(days: 1));
      }
      if (kDebugMode) {
        final diff = nextScheduleTime.difference(now);
        debugPrint(
          '🕰️ Current tz time: $now, next schedule: $nextScheduleTime, '
          'difference: ${diff.inMinutes} minutes (${diff.inSeconds} seconds)',
        );
      }

      // iOS: Schedule a single repeating notification using matchDateTimeComponents
      // This creates a truly repeating daily notification at the specified time
      await _localNotifications.zonedSchedule(
        99999,
        title,
        body,
        nextScheduleTime,
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
      );

      final pending = await _localNotifications.pendingNotificationRequests();
      debugPrint(
        '📋 iOS: Scheduled repeating notification. Total pending: ${pending.length}',
      );

      return true;
    } catch (e, stackTrace) {
      debugPrint('❌ Error scheduling quiz reminder: $e');
      debugPrint('Stack trace: $stackTrace');
      return false;
    }
  }

  /// Cancel the quiz reminder notification
  Future<void> cancelQuizReminder() async {
    if (DeviceUtils.getInstance().isAndroid) {
      try {
        await _androidReminderChannel.invokeMethod('cancelReminder');
      } catch (e, stackTrace) {
        debugPrint('❌ Unexpected Android cancel error: $e');
        debugPrint('Stack trace: $stackTrace');
      }
      return;
    } else {
      try {
        // iOS: Cancel the single repeating notification
        await _localNotifications.cancelAll();
      } catch (e, stackTrace) {
        debugPrint('❌ Error canceling quiz reminder: $e');
        debugPrint('Stack trace: $stackTrace');
      }
    }
  }
}
