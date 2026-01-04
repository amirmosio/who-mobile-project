import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:who_mobile_project/general/models/maintenance/alert_template.dart';
import 'package:who_mobile_project/providers/auth/current_user_provider.dart';
import 'package:who_mobile_project/providers/base/base_api_notifier.dart';
import 'package:who_mobile_project/providers/base/base_api_state.dart';
import 'package:who_mobile_project/providers/maintenance/alert_repository_provider.dart';
import 'package:who_mobile_project/repository/maintenance/alert_template_repository.dart';

part 'alert_template_provider.g.dart';

/// Stream provider for all alert templates (for Super Admin management UI)
@Riverpod(keepAlive: true)
Stream<List<AlertTemplate>> alertTemplatesStream(Ref ref) {
  final repository = ref.watch(alertTemplateRepositoryProvider);
  return repository.getAllTemplatesStream();
}

/// Provider for templates filtered by facility
@riverpod
Future<List<AlertTemplate>> templatesForFacility(
  Ref ref,
  String facilityId,
) async {
  final repository = ref.watch(alertTemplateRepositoryProvider);
  return repository.getTemplatesForFacility(facilityId);
}

/// Notifier for alert template CRUD operations (Super Admin only)
@Riverpod(keepAlive: true)
class AlertTemplateNotifier extends BaseApiNotifier<BaseApiState> {
  late final AlertTemplateRepository _repository;

  @override
  BaseApiState build() {
    _repository = ref.read(alertTemplateRepositoryProvider);
    return const BaseApiInitial();
  }

  /// Create a new alert template
  Future<String?> createTemplate({
    required String facilityId,
    required String facilityName,
    required String title,
    required String description,
    required int intervalHours,
    required AlertPriority priority,
  }) async {
    final currentUser = ref.read(currentUserProvider).value;
    if (currentUser == null || !currentUser.isAuthenticated) {
      return null;
    }

    return executeApiCallAndSetState<String>(
      () => _repository.createTemplate(
        facilityId: facilityId,
        facilityName: facilityName,
        title: title,
        description: description,
        intervalHours: intervalHours,
        priority: priority,
        createdBy: currentUser.uid ?? 'unknown',
      ),
      loadingMessage: 'Creating alert template...',
      successMessage: 'Alert template created successfully',
    );
  }

  /// Update an existing template
  Future<bool> updateTemplate(AlertTemplate template) async {
    return executeOperationAndSetState(
      () => _repository.updateTemplate(template),
      successMessage: 'Alert template updated successfully',
    );
  }

  /// Toggle template active status
  Future<bool> toggleTemplateActive(String templateId, bool isActive) async {
    return executeOperationAndSetState(
      () => _repository.toggleTemplateActive(templateId, isActive),
      successMessage: isActive
          ? 'Alert template activated'
          : 'Alert template deactivated',
    );
  }

  /// Delete a template
  Future<bool> deleteTemplate(String templateId) async {
    return executeOperationAndSetState(
      () => _repository.deleteTemplate(templateId),
      successMessage: 'Alert template deleted',
    );
  }
}
