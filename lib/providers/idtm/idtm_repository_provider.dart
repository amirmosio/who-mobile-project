import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:who_mobile_project/di/injector.dart';
import 'package:who_mobile_project/repository/idtm_repository.dart';

part 'idtm_repository_provider.g.dart';

/// Provider for IDTM repository
@riverpod
IdtmRepository idtmRepository(Ref ref) {
  return getIt<IdtmRepository>();
}
