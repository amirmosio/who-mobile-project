import 'package:injectable/injectable.dart';
import 'package:who_mobile_project/repository/base/base_repository.dart';
import 'package:who_mobile_project/repository/repo_state.dart';

@injectable
class DatabaseUpdateRepository extends BaseRepository {
  DatabaseUpdateRepository(super.apiClient);

  // TODO: Removed - getUpdatedDB endpoint no longer available
  Future<RepositoryState> getUpdatedDB({
    required int licenseType,
    required String lastUpdate,
    bool forceUpdate = false,
  }) async {
    // API endpoint removed - return error state
    throw Exception('Database update endpoint not available');
  }
}
