import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';
import 'package:who_mobile_project/general/services/notification/maintenance_alert_service.dart';
import 'package:who_mobile_project/repository/maintenance/alert_template_repository.dart';

@module
abstract class NotificationModule {
  @singleton
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPluginProvider() =>
      FlutterLocalNotificationsPlugin();

  @singleton
  MaintenanceAlertService maintenanceAlertService(
    FlutterLocalNotificationsPlugin plugin,
  ) =>
      MaintenanceAlertService(plugin);

  @injectable
  AlertTemplateRepository alertTemplateRepository(
    MaintenanceAlertService alertService,
  ) =>
      AlertTemplateRepository(alertService);
}
