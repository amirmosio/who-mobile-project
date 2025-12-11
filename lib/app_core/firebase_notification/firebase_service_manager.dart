// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/foundation.dart';
// import 'package:injectable/injectable.dart';
// import 'package:logger/logger.dart';
// import 'package:who_mobile_project/app_core/firebase_notification/handlers.dart';

// /// Manages Firebase Cloud Messaging (FCM) configuration and token management.
// /// Handles FCM initialization, token refresh listeners, and background message handlers.
// /// Does NOT handle notification display or navigation - those are separate concerns.
// @singleton
// class FirebaseServiceManager {
//   final Logger _logger = Logger();

//   /// Initialize Firebase Core.
//   /// Should be called once during app startup before any other Firebase services.
//   Future<void> initialize() async {
//     await Firebase.initializeApp();
//     debugPrint('✅ Firebase initialized successfully');
//   }

//   /// Configure FCM token refresh listener.
//   /// Calls [onNewFCMToken] whenever a new token is generated or refreshed.
//   ///
//   /// The FCM token is used to send push notifications to this device.
//   /// It can change when the app is reinstalled or data is cleared.
//   Future<void> configureTokenListener({
//     required Function(String fcmToken) onNewFCMToken,
//   }) async {
//     // Get current token
//     final fcmToken = await FirebaseMessaging.instance.getToken();
//     debugPrint('📱 Current FCM Token: $fcmToken');

//     if (fcmToken != null) {
//       onNewFCMToken(fcmToken);
//     }

//     // Listen for token refresh events
//     FirebaseMessaging.instance.onTokenRefresh.listen(
//       (newToken) {
//         debugPrint('🔄 FCM Token refreshed: $newToken');
//         onNewFCMToken(newToken);
//       },
//       onError: (error) {
//         _logger.e('❌ FCM token refresh error: $error');
//       },
//     );
//   }

//   /// Configure background message handler.
//   /// This handler is called when a notification is received while the app
//   /// is in the background or terminated.
//   ///
//   /// IMPORTANT: The handler must be a top-level function.
//   void configureBackgroundMessageHandler() {
//     FirebaseMessaging.onBackgroundMessage(backgroundOrTerminatedMessageHandler);
//     debugPrint('✅ Background message handler configured');
//   }

//   /// Configure foreground message listener.
//   /// Calls [onMessageReceived] when a notification arrives while app is active.
//   void configureForegroundMessageListener({
//     required void Function(RemoteMessage message) onMessageReceived,
//   }) {
//     FirebaseMessaging.onMessage.listen((message) {
//       debugPrint('📬 Foreground message received: ${message.messageId}');
//       onMessageReceived(message);
//     });
//     debugPrint('✅ Foreground message listener configured');
//   }

//   /// Configure listener for when user taps a notification.
//   /// Called when app is opened from background/foreground notification tap.
//   void configureNotificationTapListener({
//     required void Function(RemoteMessage message) onNotificationTapped,
//   }) {
//     FirebaseMessaging.onMessageOpenedApp.listen((message) {
//       debugPrint(
//         '🔔 Notification tapped (from background): ${message.messageId}',
//       );
//       onNotificationTapped(message);
//     });
//     debugPrint('✅ Notification tap listener configured');
//   }

//   /// Handle initial notification that opened the app from terminated state.
//   /// Returns the message if app was launched from a notification, null otherwise.
//   Future<RemoteMessage?> getInitialMessage() async {
//     final message = await FirebaseMessaging.instance.getInitialMessage();
//     if (message != null) {
//       debugPrint(
//         '🚀 App opened from notification (terminated): ${message.messageId}',
//       );
//     }
//     return message;
//   }
// }
