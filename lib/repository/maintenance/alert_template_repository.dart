import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:who_mobile_project/general/models/maintenance/alert_template.dart';
import 'package:who_mobile_project/general/services/notification/maintenance_alert_service.dart';
import 'package:who_mobile_project/repository/repo_state.dart';

/// Repository for alert template CRUD operations
/// Templates are stored globally in /alert_templates collection
/// Registered via notification_module.dart
class AlertTemplateRepository {
  final FirebaseFirestore _firestore;
  final MaintenanceAlertService _alertService;

  static const String _collection = 'alert_templates';

  /// Special facilityId value for general alerts that apply to all users
  static const String generalFacilityId = 'general';

  AlertTemplateRepository(this._alertService)
      : _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _templatesRef =>
      _firestore.collection(_collection);

  // ============================================================================
  // Super Admin Operations (CRUD)
  // ============================================================================

  /// Create a new alert template
  Future<RepositoryState> createTemplate({
    required String facilityId,
    required String facilityName,
    required String title,
    required String description,
    required int intervalHours,
    required AlertPriority priority,
    required String createdBy,
    String? maintenanceTaskId,
    String? maintenanceTaskTitle,
  }) async {
    try {
      final docRef = _templatesRef.doc();

      final template = AlertTemplate(
        id: docRef.id,
        facilityId: facilityId,
        facilityName: facilityName,
        title: title,
        description: description,
        intervalHours: intervalHours,
        priority: priority,
        isActive: true,
        createdBy: createdBy,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        maintenanceTaskId: maintenanceTaskId,
        maintenanceTaskTitle: maintenanceTaskTitle,
      );

      await docRef.set(template.toFirestore());

      return SuccessState(docRef.id, null);
    } catch (e) {
      return ErrorState(
        RepositoryException(
          message: 'Failed to create alert template: $e',
          error: null,
        ),
      );
    }
  }

  /// Update an existing alert template
  Future<RepositoryState> updateTemplate(AlertTemplate template) async {
    try {
      await _templatesRef.doc(template.id).update(template.toFirestoreUpdate());
      return SuccessState(true, null);
    } catch (e) {
      return ErrorState(
        RepositoryException(
          message: 'Failed to update alert template: $e',
          error: null,
        ),
      );
    }
  }

  /// Toggle template active status
  Future<RepositoryState> toggleTemplateActive(
    String templateId,
    bool isActive,
  ) async {
    try {
      await _templatesRef.doc(templateId).update({
        'isActive': isActive,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return SuccessState(true, null);
    } catch (e) {
      return ErrorState(
        RepositoryException(
          message: 'Failed to toggle template status: $e',
          error: null,
        ),
      );
    }
  }

  /// Delete an alert template
  Future<RepositoryState> deleteTemplate(String templateId) async {
    try {
      await _templatesRef.doc(templateId).delete();
      return SuccessState(true, null);
    } catch (e) {
      return ErrorState(
        RepositoryException(
          message: 'Failed to delete alert template: $e',
          error: null,
        ),
      );
    }
  }

  // ============================================================================
  // Read Operations (All Admins)
  // ============================================================================

  /// Get stream of all alert templates (for Super Admin management UI)
  Stream<List<AlertTemplate>> getAllTemplatesStream() {
    return _templatesRef
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => AlertTemplate.fromFirestore(doc)).toList())
        .handleError((error) {
      // Return empty list on error
      return <AlertTemplate>[];
    });
  }

  /// Get templates for a specific facility (for scheduling)
  /// Also includes general alerts that apply to all facilities
  Future<List<AlertTemplate>> getTemplatesForFacility(String facilityId) async {
    try {
      // Fetch facility-specific templates
      final facilitySnapshot = await _templatesRef
          .where('facilityId', isEqualTo: facilityId)
          .where('isActive', isEqualTo: true)
          .get();

      // Fetch general templates (apply to all facilities)
      final generalSnapshot = await _templatesRef
          .where('facilityId', isEqualTo: generalFacilityId)
          .where('isActive', isEqualTo: true)
          .get();

      final templates = <AlertTemplate>[];
      templates.addAll(
        facilitySnapshot.docs.map((doc) => AlertTemplate.fromFirestore(doc)),
      );
      templates.addAll(
        generalSnapshot.docs.map((doc) => AlertTemplate.fromFirestore(doc)),
      );

      return templates;
    } catch (e) {
      return [];
    }
  }

  /// Get only general templates (for all users)
  /// Used to schedule alerts for logged-in users regardless of facility
  Future<List<AlertTemplate>> getGeneralTemplates() async {
    try {
      final snapshot = await _templatesRef
          .where('facilityId', isEqualTo: generalFacilityId)
          .where('isActive', isEqualTo: true)
          .get();

      return snapshot.docs
          .map((doc) => AlertTemplate.fromFirestore(doc))
          .toList();
    } catch (e) {
      return [];
    }
  }

  /// Get all active templates (one-time fetch)
  Future<List<AlertTemplate>> getActiveTemplates() async {
    try {
      final snapshot = await _templatesRef
          .where('isActive', isEqualTo: true)
          .get();

      return snapshot.docs
          .map((doc) => AlertTemplate.fromFirestore(doc))
          .toList();
    } catch (e) {
      return [];
    }
  }

  /// Get stream of all active templates (for caching)
  /// This is the primary cache stream - filtered providers derive from this
  Stream<List<AlertTemplate>> getActiveTemplatesStream() {
    return _templatesRef
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => AlertTemplate.fromFirestore(doc)).toList())
        .handleError((error) {
      return <AlertTemplate>[];
    });
  }

  /// Get a single template by ID
  Future<AlertTemplate?> getTemplateById(String templateId) async {
    try {
      final doc = await _templatesRef.doc(templateId).get();
      if (!doc.exists) return null;
      return AlertTemplate.fromFirestore(doc);
    } catch (e) {
      return null;
    }
  }

  /// Get stream of active templates for a specific maintenance task
  /// Used by maintenance pages to show related alerts
  Stream<List<AlertTemplate>> getTemplatesForMaintenanceTaskStream(
    String taskId,
  ) {
    return _templatesRef
        .where('maintenanceTaskId', isEqualTo: taskId)
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => AlertTemplate.fromFirestore(doc)).toList())
        .handleError((error) {
      return <AlertTemplate>[];
    });
  }

  /// Get stream of active templates filtered by interval type
  /// intervalType: 'daily' (1-24h), 'weekly' (25-168h), 'monthly' (169+h)
  /// Used by maintenance pages to show alerts based on frequency
  Stream<List<AlertTemplate>> getTemplatesByIntervalTypeStream(
    String intervalType,
  ) {
    return _templatesRef
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
      final allTemplates = snapshot.docs
          .map((doc) => AlertTemplate.fromFirestore(doc))
          .toList();

      // Filter by interval type
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
    }).handleError((error) {
      return <AlertTemplate>[];
    });
  }

  // ============================================================================
  // Scheduling Operations
  // ============================================================================

  /// Schedule alerts for a facility installation
  Future<RepositoryState> scheduleAlertsForFacility({
    required String installationId,
    required String facilityId,
  }) async {
    try {
      // Fetch templates for this facility
      final templates = await getTemplatesForFacility(facilityId);

      if (templates.isEmpty) {
        return SuccessState(
          <int>[],
          'No alert templates found for this facility',
        );
      }

      // Schedule all alerts starting from now
      final scheduledIds = await _alertService.scheduleAlertsForFacility(
        installationId: installationId,
        templates: templates,
        startTime: DateTime.now(),
      );

      return SuccessState(scheduledIds, null);
    } catch (e) {
      return ErrorState(
        RepositoryException(
          message: 'Failed to schedule alerts: $e',
          error: null,
        ),
      );
    }
  }

  /// Schedule general alerts for a logged-in user
  /// These are alerts that apply to all users regardless of facility
  /// Called on login to schedule recurring notifications
  Future<RepositoryState> scheduleGeneralAlerts({
    required String userId,
  }) async {
    try {
      final templates = await getGeneralTemplates();

      if (templates.isEmpty) {
        return SuccessState(
          <int>[],
          'No general alert templates found',
        );
      }

      // Use 'general_<userId>' as installation ID for tracking
      final installationId = 'general_$userId';

      final scheduledIds = await _alertService.scheduleAlertsForFacility(
        installationId: installationId,
        templates: templates,
        startTime: DateTime.now(),
      );

      return SuccessState(scheduledIds, null);
    } catch (e) {
      return ErrorState(
        RepositoryException(
          message: 'Failed to schedule general alerts: $e',
          error: null,
        ),
      );
    }
  }

  /// Cancel all alerts for an installation
  Future<RepositoryState> cancelAlertsForInstallation(
    String installationId,
  ) async {
    try {
      await _alertService.cancelAlertsForInstallation(installationId);
      return SuccessState(true, null);
    } catch (e) {
      return ErrorState(
        RepositoryException(
          message: 'Failed to cancel alerts: $e',
          error: null,
        ),
      );
    }
  }

  /// Cancel all scheduled alerts (on logout)
  Future<void> cancelAllAlerts() async {
    await _alertService.cancelAllAlerts();
  }
}
