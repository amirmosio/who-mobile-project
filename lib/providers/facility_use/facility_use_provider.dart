import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:who_mobile_project/di/injector.dart';
import 'package:who_mobile_project/general/models/facility_use/facility_use_data_model.dart';
import 'package:who_mobile_project/providers/app_locale/app_locale_provider.dart';
import 'package:who_mobile_project/repository/facility_use/facility_use_repository.dart';

part 'facility_use_provider.g.dart';

@riverpod
class FacilityUseData extends _$FacilityUseData {
  @override
  Future<FacilityUseDataModel> build() async {
    final locale = ref.watch(appLocaleProvider);
    return getIt<FacilityUseRepository>().loadFacilityUseData(
      localeCode: locale.languageCode,
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    final locale = ref.read(appLocaleProvider);
    state = await AsyncValue.guard(() async {
      final repository = getIt<FacilityUseRepository>();
      repository.clearCache();
      return repository.loadFacilityUseData(
        localeCode: locale.languageCode,
      );
    });
  }

  String getImagePath(String filename) {
    return getIt<FacilityUseRepository>().getImagePath(filename);
  }
}
