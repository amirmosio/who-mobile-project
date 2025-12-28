/// Represents the different phases of a facility installation lifecycle
enum FacilityInstallationPhase {
  /// Initial state - not yet started
  initial('initial'),

  /// Installation in progress
  installing('installing'),

  /// Facility in use, maintenance mode
  maintenance('maintenance'),

  /// Dismantling/repacking in progress
  dismantling('dismantling'),

  /// Fully dismantled and completed
  completed('completed');

  const FacilityInstallationPhase(this.value);

  final String value;

  /// Get phase from string value
  static FacilityInstallationPhase fromString(String value) {
    return FacilityInstallationPhase.values.firstWhere(
      (phase) => phase.value == value,
      orElse: () => FacilityInstallationPhase.initial,
    );
  }

  /// Check if phase allows editing
  bool get canEdit => this != FacilityInstallationPhase.completed;

  /// Get display name for phase
  String get displayName {
    switch (this) {
      case FacilityInstallationPhase.initial:
        return 'Not Started';
      case FacilityInstallationPhase.installing:
        return 'Installing';
      case FacilityInstallationPhase.maintenance:
        return 'Maintenance';
      case FacilityInstallationPhase.dismantling:
        return 'Dismantling';
      case FacilityInstallationPhase.completed:
        return 'Completed';
    }
  }

  /// Get next phase in the lifecycle
  FacilityInstallationPhase? get nextPhase {
    switch (this) {
      case FacilityInstallationPhase.initial:
        return FacilityInstallationPhase.installing;
      case FacilityInstallationPhase.installing:
        return FacilityInstallationPhase.maintenance;
      case FacilityInstallationPhase.maintenance:
        return FacilityInstallationPhase.dismantling;
      case FacilityInstallationPhase.dismantling:
        return FacilityInstallationPhase.completed;
      case FacilityInstallationPhase.completed:
        return null;
    }
  }

  /// Get previous phase in the lifecycle
  FacilityInstallationPhase? get previousPhase {
    switch (this) {
      case FacilityInstallationPhase.initial:
        return null;
      case FacilityInstallationPhase.installing:
        return FacilityInstallationPhase.initial;
      case FacilityInstallationPhase.maintenance:
        return FacilityInstallationPhase.installing;
      case FacilityInstallationPhase.dismantling:
        return FacilityInstallationPhase.maintenance;
      case FacilityInstallationPhase.completed:
        return FacilityInstallationPhase.dismantling;
    }
  }
}
