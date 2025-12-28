import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:who_mobile_project/general/models/idtm/idtm_facility.dart';
import 'package:who_mobile_project/providers/base/base_api_notifier.dart';
import 'package:who_mobile_project/providers/base/base_api_state.dart';
import 'package:who_mobile_project/providers/idtm/idtm_repository_provider.dart';
import 'package:who_mobile_project/repository/idtm_repository.dart';
import 'package:who_mobile_project/repository/repo_state.dart';

part 'facilities_provider.g.dart';

/// Provider for managing IDTM facilities list
@Riverpod(keepAlive: true)
class Facilities extends BaseApiNotifier<BaseApiState> {
  late final IdtmRepository _repository;

  @override
  BaseApiState build() {
    _repository = ref.read(idtmRepositoryProvider);
    return const BaseApiInitial();
  }

  /// Load all available facilities from assets
  Future<List<IdtmFacility>?> loadFacilities() async {
    return executeApiCallAndSetState<List<IdtmFacility>>(
      () async {
        final facilities = await _repository.getAllFacilities();
        return SuccessState(facilities, null);
      },
      loadingMessage: 'Loading facilities...',
      successMessage: 'Facilities loaded',
    );
  }

  /// Load a specific facility by ID
  Future<IdtmFacility?> loadFacility(String facilityId) async {
    return executeApiCallAndSetState<IdtmFacility>(
      () async {
        final facility = await _repository.getFacilityById(facilityId);
        if (facility == null) {
          return ErrorState(
            RepositoryException(
              message: 'Facility not found',
              error: null,
            ),
          );
        }
        return SuccessState(facility, null);
      },
      loadingMessage: 'Loading facility...',
      successMessage: 'Facility loaded',
    );
  }
}
