import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';

/// Manages local notifications (non-Firebase) for the app.
/// Handles platform-specific notification setup, channels, and display.
@singleton
class NotificationManager {
  final FlutterLocalNotificationsPlugin _localNotifications;

  NotificationManager(this._localNotifications);

  FlutterLocalNotificationsPlugin get plugin => _localNotifications;

  /// Initialize local notifications with platform-specific settings.
  /// This should be called during app startup.
  Future<void> initialize() async {
    debugPrint('🔔 Initializing NotificationManager');

    // Request Android permissions
    await _requestAndroidPermissions();

    // Configure platform-specific settings
    const initSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(
        requestSoundPermission: true,
        requestBadgePermission: true,
        requestAlertPermission: true,
      ),
      macOS: DarwinInitializationSettings(
        requestSoundPermission: true,
        requestBadgePermission: true,
        requestAlertPermission: true,
      ),
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) {
        debugPrint('Notification tapped: ${details.payload}');
      },
    );

    // Configure iOS foreground presentation
    await _configureIOSPermissions();

    debugPrint('✅ NotificationManager initialization complete');
  }

  /// Request notification permissions on Android
  Future<void> _requestAndroidPermissions() async {
    final androidPlugin = _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidPlugin != null) {
      await androidPlugin.requestNotificationsPermission();
      debugPrint('✅ Android notification permissions requested');
    }
  }

  /// Configure iOS notification permissions
  Future<void> _configureIOSPermissions() async {
    final iosPlugin = _localNotifications
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();

    if (iosPlugin != null) {
      await iosPlugin.requestPermissions(alert: true, badge: true, sound: true);
      debugPrint('✅ iOS notification permissions configured');
    }
  }

  /// Create a notification channel for Android.
  /// Channels are required for Android 8.0+ to display notifications.
  Future<void> createAndroidChannel({
    required String id,
    required String name,
    String? description,
    Importance importance = Importance.high,
  }) async {
    final androidPlugin = _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidPlugin == null) {
      debugPrint(
        '⚠️ Android plugin not available; skipping channel creation for $id',
      );
      return;
    }

    final channel = AndroidNotificationChannel(
      id,
      name,
      description: description,
      importance: importance,
      enableVibration: true,
      playSound: true,
      showBadge: true,
    );

    await androidPlugin.createNotificationChannel(channel);
    debugPrint('📡 Created Android notification channel: $id');
  }

  /// Show a local notification with the given details
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
    String? channelId,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'default_channel',
      'Default Channel',
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(id, title, body, details, payload: payload);
  }

  /// Cancel a specific notification by ID
  Future<void> cancelNotification(int id) async {
    await _localNotifications.cancel(id);
  }

  /// Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _localNotifications.cancelAll();
  }
}
