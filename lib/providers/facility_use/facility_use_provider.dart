import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:who_mobile_project/di/injector.dart';
import 'package:who_mobile_project/general/models/facility_use/facility_use_data_model.dart';
import 'package:who_mobile_project/repository/facility_use/facility_use_repository.dart';

part 'facility_use_provider.g.dart';

@riverpod
class FacilityUseData extends _$FacilityUseData {
  @override
  Future<FacilityUseDataModel> build() async {
    return getIt<FacilityUseRepository>().loadFacilityUseData();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = getIt<FacilityUseRepository>();
      repository.clearCache();
      return repository.loadFacilityUseData();
    });
  }

  String getImagePath(String filename) {
    return getIt<FacilityUseRepository>().getImagePath(filename);
  }
}
