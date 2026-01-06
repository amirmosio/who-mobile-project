import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:who_mobile_project/general/models/maintenance/alert_template.dart';
import 'package:who_mobile_project/providers/auth/current_user_provider.dart';
import 'package:who_mobile_project/providers/base/base_api_notifier.dart';
import 'package:who_mobile_project/providers/base/base_api_state.dart';
import 'package:who_mobile_project/providers/maintenance/alert_repository_provider.dart';
import 'package:who_mobile_project/repository/maintenance/alert_template_repository.dart';

part 'alert_template_provider.g.dart';

/// Stream provider for all alert templates (for Super Admin management UI)
/// Uses keepAlive to maintain the stream connection and reduce API calls
@Riverpod(keepAlive: true)
Stream<List<AlertTemplate>> alertTemplatesStream(Ref ref) {
  final repository = ref.watch(alertTemplateRepositoryProvider);
  return repository.getAllTemplatesStream();
}

/// Cached provider for all active templates
/// This is the single source of truth - other providers derive from this
/// Uses keepAlive to cache data and reduce Firestore reads
@Riverpod(keepAlive: true)
Stream<List<AlertTemplate>> activeAlertTemplatesCache(Ref ref) {
  final repository = ref.watch(alertTemplateRepositoryProvider);
  return repository.getActiveTemplatesStream();
}

/// Provider for templates filtered by facility (derived from cache)
@riverpod
List<AlertTemplate> templatesForFacility(Ref ref, String facilityId) {
  final allTemplates = ref.watch(activeAlertTemplatesCacheProvider).value ?? [];
  return allTemplates.where((t) => t.facilityId == facilityId).toList();
}

/// Provider for templates linked to a specific maintenance task (derived from cache)
/// Used by maintenance pages to show related alert reminders
@riverpod
List<AlertTemplate> alertTemplatesForTask(Ref ref, String taskId) {
  final allTemplates = ref.watch(activeAlertTemplatesCacheProvider).value ?? [];
  return allTemplates.where((t) => t.maintenanceTaskId == taskId).toList();
}

/// Provider for templates filtered by interval type (derived from cache)
/// intervalType: 'daily' (1-24h), 'weekly' (25-168h), 'monthly' (169+h)
/// Used by maintenance step pages to show related alerts based on frequency
@riverpod
List<AlertTemplate> alertTemplatesByInterval(Ref ref, String intervalType) {
  final allTemplates = ref.watch(activeAlertTemplatesCacheProvider).value ?? [];
  return allTemplates.where((template) {
    final hours = template.intervalHours;
    switch (intervalType) {
      case 'daily':
        return hours >= 1 && hours <= 24;
      case 'weekly':
        return hours > 24 && hours <= 168;
      case 'monthly':
        return hours > 168;
      default:
        return false;
    }
  }).toList();
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
    String? maintenanceTaskId,
    String? maintenanceTaskTitle,
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
        maintenanceTaskId: maintenanceTaskId,
        maintenanceTaskTitle: maintenanceTaskTitle,
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
