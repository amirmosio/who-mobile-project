import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;
import 'package:who_mobile_project/general/models/maintenance/alert_template.dart';
import 'package:who_mobile_project/general/services/device/device_service.dart';
import 'package:who_mobile_project/general/services/permissions/permission_service.dart';

/// Service for managing maintenance alert local notifications
/// Schedules repeating notifications based on alert templates
/// Registered via notification_module.dart
class MaintenanceAlertService {
  final FlutterLocalNotificationsPlugin _localNotifications;
  bool _isInitialized = false;

  /// Method channel for Android background scheduling
  static const MethodChannel _androidAlertChannel = MethodChannel(
    'com.who.mobile/maintenanceAlert',
  );

  /// Notification ID base offset for maintenance alerts (to avoid conflicts)
  /// Quiz reminders use 99999, we use 200000+ range
  static const int _notificationIdBase = 200000;

  /// Track scheduled notification IDs per installation
  final Map<String, List<int>> _scheduledNotifications = {};

  MaintenanceAlertService(this._localNotifications) {
    _initialize();
  }

  Future<void> _initialize() async {
    debugPrint('Initializing MaintenanceAlertService');
    if (!DeviceUtils.getInstance().isAndroid) {
      await _initializeTimezone();
    }
    _isInitialized = true;
    debugPrint('MaintenanceAlertService initialized');
  }

  Future<void> _initializeTimezone() async {
    if (DeviceUtils.getInstance().isAndroid) {
      return;
    }
    if (_isInitialized) {
      return;
    }

    tz_data.initializeTimeZones();

    final now = DateTime.now();
    final utcOffset = now.timeZoneOffset;
    final offsetHours = utcOffset.inHours;

    tz.Location location;

    if (offsetHours == 1 || offsetHours == 2) {
      location = tz.getLocation('Europe/Rome');
    } else {
      try {
        final matchingZones =
            tz.timeZoneDatabase.locations.values.where((loc) {
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
      debugPrint('iOS timezone: ${tz.local.name}');
    }
  }

  /// Schedule alerts for a facility when entering maintenance phase
  /// Returns list of scheduled notification IDs
  Future<List<int>> scheduleAlertsForFacility({
    required String installationId,
    required List<AlertTemplate> templates,
    required DateTime startTime,
  }) async {
    final scheduledIds = <int>[];

    for (final template in templates) {
      if (!template.isActive) continue;

      final notificationId = _generateNotificationId(template.id);

      final success = await _scheduleAlert(
        notificationId: notificationId,
        title: template.title,
        body: template.description,
        intervalHours: template.intervalHours,
        priority: template.priority,
        startTime: startTime,
        payload: '${installationId}|${template.id}',
      );

      if (success) {
        scheduledIds.add(notificationId);
      }
    }

    _scheduledNotifications[installationId] = scheduledIds;
    debugPrint(
      'Scheduled ${scheduledIds.length} alerts for installation: $installationId',
    );

    return scheduledIds;
  }

  Future<bool> _scheduleAlert({
    required int notificationId,
    required String title,
    required String body,
    required int intervalHours,
    required AlertPriority priority,
    required DateTime startTime,
    required String payload,
  }) async {
    final permissionsGranted =
        await YRPermissionHandler.ensureReminderPermissions();
    if (!permissionsGranted) {
      debugPrint('Notification permissions not granted');
      return false;
    }

    if (DeviceUtils.getInstance().isAndroid) {
      return _scheduleAlertOnAndroid(
        notificationId: notificationId,
        title: title,
        body: body,
        intervalHours: intervalHours,
        startTime: startTime,
        payload: payload,
      );
    }
    return _scheduleAlertOnIOS(
      notificationId: notificationId,
      title: title,
      body: body,
      intervalHours: intervalHours,
      priority: priority,
      startTime: startTime,
      payload: payload,
    );
  }

  Future<bool> _scheduleAlertOnAndroid({
    required int notificationId,
    required String title,
    required String body,
    required int intervalHours,
    required DateTime startTime,
    required String payload,
  }) async {
    try {
      // Calculate first trigger time
      final firstTrigger = startTime.add(Duration(hours: intervalHours));

      final result = await _androidAlertChannel.invokeMethod<bool>(
        'scheduleMaintenanceAlert',
        {
          'notificationId': notificationId,
          'title': title,
          'body': body,
          'intervalHours': intervalHours,
          'triggerAtMillis': firstTrigger.millisecondsSinceEpoch,
          'payload': payload,
        },
      );
      if (kDebugMode) {
        debugPrint('Android alert scheduled: $result (ID: $notificationId)');
      }
      return result ?? false;
    } catch (e, stackTrace) {
      debugPrint('Error scheduling Android alert: $e');
      debugPrint('Stack trace: $stackTrace');
      // Fallback to flutter_local_notifications for Android too
      return _scheduleAlertOnIOSFallback(
        notificationId: notificationId,
        title: title,
        body: body,
        intervalHours: intervalHours,
        startTime: startTime,
        payload: payload,
      );
    }
  }

  Future<bool> _scheduleAlertOnIOS({
    required int notificationId,
    required String title,
    required String body,
    required int intervalHours,
    required AlertPriority priority,
    required DateTime startTime,
    required String payload,
  }) async {
    try {
      await _initializeTimezone();

      // Cancel any existing notification with same ID
      await _localNotifications.cancel(notificationId);

      final iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        interruptionLevel: _getInterruptionLevel(priority),
      );

      final notificationDetails = NotificationDetails(iOS: iosDetails);

      // Calculate first trigger time
      final firstTrigger = startTime.add(Duration(hours: intervalHours));
      final scheduledTime = tz.TZDateTime.from(firstTrigger, tz.local);

      if (kDebugMode) {
        debugPrint(
          'Scheduling iOS alert: $title at $scheduledTime (every ${intervalHours}h)',
        );
      }

      // Schedule repeating notification
      await _localNotifications.zonedSchedule(
        notificationId,
        title,
        body,
        scheduledTime,
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: payload,
        matchDateTimeComponents: _getRepeatComponent(intervalHours),
      );

      return true;
    } catch (e, stackTrace) {
      debugPrint('Error scheduling iOS alert: $e');
      debugPrint('Stack trace: $stackTrace');
      return false;
    }
  }

  /// Fallback for Android using flutter_local_notifications
  Future<bool> _scheduleAlertOnIOSFallback({
    required int notificationId,
    required String title,
    required String body,
    required int intervalHours,
    required DateTime startTime,
    required String payload,
  }) async {
    try {
      await _initializeTimezone();

      await _localNotifications.cancel(notificationId);

      const androidDetails = AndroidNotificationDetails(
        'maintenance_alerts',
        'Maintenance Alerts',
        channelDescription: 'Notifications for facility maintenance tasks',
        importance: Importance.high,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
      );

      const notificationDetails = NotificationDetails(android: androidDetails);

      final firstTrigger = startTime.add(Duration(hours: intervalHours));
      final scheduledTime = tz.TZDateTime.from(firstTrigger, tz.local);

      await _localNotifications.zonedSchedule(
        notificationId,
        title,
        body,
        scheduledTime,
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: payload,
        matchDateTimeComponents: _getRepeatComponent(intervalHours),
      );

      return true;
    } catch (e, stackTrace) {
      debugPrint('Error in fallback scheduling: $e');
      debugPrint('Stack trace: $stackTrace');
      return false;
    }
  }

  InterruptionLevel _getInterruptionLevel(AlertPriority priority) {
    switch (priority) {
      case AlertPriority.critical:
        return InterruptionLevel.critical;
      case AlertPriority.high:
        return InterruptionLevel.timeSensitive;
      case AlertPriority.medium:
      case AlertPriority.low:
        return InterruptionLevel.active;
    }
  }

  DateTimeComponents? _getRepeatComponent(int intervalHours) {
    // For daily and longer intervals, match time component
    if (intervalHours >= 24) {
      return DateTimeComponents.time;
    }
    // For shorter intervals, we can't use matchDateTimeComponents
    // The notification will fire once, then we'd need to reschedule
    return null;
  }

  /// Cancel all alerts for a specific installation
  Future<void> cancelAlertsForInstallation(String installationId) async {
    final ids = _scheduledNotifications[installationId] ?? [];
    for (final id in ids) {
      await _cancelAlert(id);
    }
    _scheduledNotifications.remove(installationId);
    debugPrint('Cancelled ${ids.length} alerts for installation: $installationId');
  }

  /// Cancel all scheduled maintenance alerts
  Future<void> cancelAllAlerts() async {
    if (DeviceUtils.getInstance().isAndroid) {
      try {
        await _androidAlertChannel.invokeMethod('cancelAllMaintenanceAlerts');
      } catch (e) {
        debugPrint('Error canceling Android alerts: $e');
      }
    }

    // Cancel all tracked notifications
    for (final ids in _scheduledNotifications.values) {
      for (final id in ids) {
        await _localNotifications.cancel(id);
      }
    }
    _scheduledNotifications.clear();

    // Also cancel any in our ID range that might not be tracked
    final pending = await _localNotifications.pendingNotificationRequests();
    for (final notification in pending) {
      if (notification.id >= _notificationIdBase) {
        await _localNotifications.cancel(notification.id);
      }
    }

    debugPrint('Cancelled all maintenance alerts');
  }

  Future<void> _cancelAlert(int notificationId) async {
    if (DeviceUtils.getInstance().isAndroid) {
      try {
        await _androidAlertChannel.invokeMethod(
          'cancelMaintenanceAlert',
          {'notificationId': notificationId},
        );
      } catch (e) {
        debugPrint('Error canceling Android alert: $e');
      }
    }
    await _localNotifications.cancel(notificationId);
  }

  /// Generate a unique notification ID from template ID
  int _generateNotificationId(String templateId) {
    // Use hashCode but ensure it's positive and in our range
    final hash = templateId.hashCode.abs();
    return _notificationIdBase + (hash % 100000);
  }

  /// Get list of currently scheduled notifications
  Future<List<PendingNotificationRequest>> getPendingAlerts() async {
    final pending = await _localNotifications.pendingNotificationRequests();
    return pending
        .where((n) => n.id >= _notificationIdBase)
        .toList();
  }
}
