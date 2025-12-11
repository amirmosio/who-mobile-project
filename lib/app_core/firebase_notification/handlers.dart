// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/foundation.dart';
// import 'package:go_router/go_router.dart';
// import 'package:who_mobile_project/main.dart';
// import 'package:who_mobile_project/routing_config/routes.dart';

// /////////////////////////
// //// Message Handlers///
// ///////////////////////

// /// Top-level function for handling background/terminated FCM messages.
// /// This MUST be a top-level function (not a class method) to work with Firebase.
// @pragma('vm:entry-point')
// Future<void> backgroundOrTerminatedMessageHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();

//   debugPrint('📦 Background/terminated message received: ${message.messageId}');
//   debugPrint('Notification: ${message.notification?.title}');
//   debugPrint('Data: ${message.data}');

//   final notificationType = message.data['type'] as String?;

//   switch (notificationType) {
//     case 'message':
//       debugPrint('💬 Message notification in background');
//       break;
//     case 'lesson_reminder':
//       debugPrint('📚 Lesson reminder in background');
//       break;
//     case 'quiz_reminder':
//       debugPrint('📝 Quiz reminder in background');
//       break;
//     default:
//       debugPrint('📩 Generic notification in background: $notificationType');
//   }

//   debugPrint('✅ Background handler completed');
// }

// /// Handle foreground notification (app is open and active)
// void handleForegroundMessage(RemoteMessage message) {
//   debugPrint('📬 Handling foreground message: ${message.messageId}');
//   debugPrint('Data: ${message.data}');

//   final notificationType = message.data['type'] as String?;

//   switch (notificationType) {
//     case 'message':
//       debugPrint('💬 Received chat message notification');
//       break;
//     default:
//       debugPrint('⚠️ Unknown notification type: $notificationType');
//   }
// }

// /// Handle notification tap (user opened app from notification)
// void handleNotificationTap(RemoteMessage message) {
//   debugPrint('🔔 Handling notification tap: ${message.messageId}');
//   debugPrint('Data: ${message.data}');

//   final notificationType = message.data['type'] as String?;

//   switch (notificationType) {
//     case 'message':
//       mainRouterKey.currentContext?.go(YRRoutes.assistance);
//       debugPrint('💬 Navigating to assistance/chat screen');
//       break;
//     case 'lesson_reminder':
//       mainRouterKey.currentContext?.go(YRRoutes.theory);
//       debugPrint('📚 Navigating to lessons screen');
//       break;
//     case 'quiz_reminder':
//       mainRouterKey.currentContext?.go(YRRoutes.quiz);
//       debugPrint('📝 Navigating to quiz screen');
//       break;
//     default:
//       debugPrint('⚠️ Unknown notification tap type: $notificationType');
//   }
// }
