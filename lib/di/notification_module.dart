import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';

@module
abstract class NotificationModule {
  @singleton
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPluginProvider() =>
      FlutterLocalNotificationsPlugin();
}
