import 'package:who_mobile_project/general/models/idtm/installation_phase.dart';

/// Represents the progress of a facility installation
class ProgressTracker {
  /// Unique identifier for the installation
  final String installationId;

  /// Facility ID being installed
  final String facilityId;

  /// Facility name
  final String facilityName;

  /// Current phase
  final FacilityInstallationPhase currentPhase;

  /// Installation start date
  final DateTime startedAt;

  /// Last update timestamp
  final DateTime updatedAt;

  /// Expected completion date (optional)
  final DateTime? expectedCompletion;

  /// Actual completion date (when phase is completed)
  final DateTime? completedAt;

  /// Map of step IDs to completion status
  final Map<String, bool> stepCompletionStatus;

  /// Map of step IDs to completion timestamps
  final Map<String, DateTime> stepCompletionDates;

  /// Total steps in current phase
  final int totalStepsInPhase;

  /// Completed steps in current phase
  final int completedStepsInPhase;

  /// Overall progress percentage (0-100)
  final double progressPercentage;

  /// Location where the facility is being installed
  final String? location;

  /// Team members involved
  final List<String>? teamMembers;

  /// Notes about the installation
  final String? notes;

  const ProgressTracker({
    required this.installationId,
    required this.facilityId,
    required this.facilityName,
    required this.currentPhase,
    required this.startedAt,
    required this.updatedAt,
    this.expectedCompletion,
    this.completedAt,
    this.stepCompletionStatus = const {},
    this.stepCompletionDates = const {},
    required this.totalStepsInPhase,
    required this.completedStepsInPhase,
    required this.progressPercentage,
    this.location,
    this.teamMembers,
    this.notes,
  });

  factory ProgressTracker.fromJson(Map<String, dynamic> json) {
    return ProgressTracker(
      installationId: json['installationId'] as String,
      facilityId: json['facilityId'] as String,
      facilityName: json['facilityName'] as String,
      currentPhase: FacilityInstallationPhase.fromString(
          json['currentPhase'] as String),
      startedAt: DateTime.parse(json['startedAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      expectedCompletion: json['expectedCompletion'] != null
          ? DateTime.parse(json['expectedCompletion'] as String)
          : null,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
      stepCompletionStatus:
          (json['stepCompletionStatus'] as Map<String, dynamic>?)
                  ?.map((k, v) => MapEntry(k, v as bool)) ??
              {},
      stepCompletionDates:
          (json['stepCompletionDates'] as Map<String, dynamic>?)
                  ?.map((k, v) => MapEntry(k, DateTime.parse(v as String))) ??
              {},
      totalStepsInPhase: json['totalStepsInPhase'] as int,
      completedStepsInPhase: json['completedStepsInPhase'] as int,
      progressPercentage: (json['progressPercentage'] as num).toDouble(),
      location: json['location'] as String?,
      teamMembers: (json['teamMembers'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'installationId': installationId,
      'facilityId': facilityId,
      'facilityName': facilityName,
      'currentPhase': currentPhase.value,
      'startedAt': startedAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'expectedCompletion': expectedCompletion?.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'stepCompletionStatus': stepCompletionStatus,
      'stepCompletionDates': stepCompletionDates
          .map((k, v) => MapEntry(k, v.toIso8601String())),
      'totalStepsInPhase': totalStepsInPhase,
      'completedStepsInPhase': completedStepsInPhase,
      'progressPercentage': progressPercentage,
      'location': location,
      'teamMembers': teamMembers,
      'notes': notes,
    };
  }

  ProgressTracker copyWith({
    String? installationId,
    String? facilityId,
    String? facilityName,
    FacilityInstallationPhase? currentPhase,
    DateTime? startedAt,
    DateTime? updatedAt,
    DateTime? expectedCompletion,
    DateTime? completedAt,
    Map<String, bool>? stepCompletionStatus,
    Map<String, DateTime>? stepCompletionDates,
    int? totalStepsInPhase,
    int? completedStepsInPhase,
    double? progressPercentage,
    String? location,
    List<String>? teamMembers,
    String? notes,
  }) {
    return ProgressTracker(
      installationId: installationId ?? this.installationId,
      facilityId: facilityId ?? this.facilityId,
      facilityName: facilityName ?? this.facilityName,
      currentPhase: currentPhase ?? this.currentPhase,
      startedAt: startedAt ?? this.startedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      expectedCompletion: expectedCompletion ?? this.expectedCompletion,
      completedAt: completedAt ?? this.completedAt,
      stepCompletionStatus: stepCompletionStatus ?? this.stepCompletionStatus,
      stepCompletionDates: stepCompletionDates ?? this.stepCompletionDates,
      totalStepsInPhase: totalStepsInPhase ?? this.totalStepsInPhase,
      completedStepsInPhase:
          completedStepsInPhase ?? this.completedStepsInPhase,
      progressPercentage: progressPercentage ?? this.progressPercentage,
      location: location ?? this.location,
      teamMembers: teamMembers ?? this.teamMembers,
      notes: notes ?? this.notes,
    );
  }

  /// Check if a specific step is completed
  bool isStepCompleted(String stepId) {
    return stepCompletionStatus[stepId] ?? false;
  }

  /// Get completion date for a specific step
  DateTime? getStepCompletionDate(String stepId) {
    return stepCompletionDates[stepId];
  }

  /// Check if the current phase is completed
  bool get isPhaseCompleted {
    return completedStepsInPhase >= totalStepsInPhase &&
        totalStepsInPhase > 0;
  }

  /// Check if the entire installation is completed
  bool get isInstallationCompleted {
    return currentPhase == FacilityInstallationPhase.completed;
  }
}
