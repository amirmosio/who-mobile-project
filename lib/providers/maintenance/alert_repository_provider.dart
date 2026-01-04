import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:who_mobile_project/di/injector.dart';
import 'package:who_mobile_project/repository/maintenance/alert_template_repository.dart';

part 'alert_repository_provider.g.dart';

@riverpod
AlertTemplateRepository alertTemplateRepository(Ref ref) {
  return getIt<AlertTemplateRepository>();
}
