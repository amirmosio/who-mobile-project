import 'package:flutter/foundation.dart';
import 'package:who_mobile_project/generated/i18n/app_localizations.dart';

/// Enum representing the different initialization steps
enum InitializationStep {
  starting,
  migration,
  auth,
  sync,
  databaseUpdate,
  version,
}

/// Extension to get localized labels for initialization steps
extension InitializationStepLocalization on InitializationStep {
  String getLocalizedLabel(AppLocalizations localizations) {
    return switch (this) {
      InitializationStep.migration => localizations.init_step_migration,
      InitializationStep.auth => localizations.init_step_auth,
      InitializationStep.sync => localizations.init_step_sync,
      InitializationStep.databaseUpdate =>
        localizations.init_step_database_update,
      InitializationStep.version => localizations.init_step_version,
      InitializationStep.starting => localizations.init_step_starting,
    };
  }
}

/// Configuration for each initialization step with its progress value
class InitializationStepConfig {
  final InitializationStep step;
  final double progress;

  const InitializationStepConfig({required this.step, required this.progress});
}

/// Controller for managing initialization progress and current step
class InitializationProgressController extends ChangeNotifier {
  InitializationStep _currentStep = InitializationStep.starting;
  double _progress = 0.0;

  InitializationStep get currentStep => _currentStep;
  double get progress => _progress;

  /// Predefined step configurations with their progress values
  static const Map<InitializationStep, double> stepProgressMap = {
    InitializationStep.starting: 0.1,
    InitializationStep.migration: 0.25,
    InitializationStep.auth: 0.4,
    InitializationStep.sync: 0.5,
    InitializationStep.databaseUpdate: 0.7,
    InitializationStep.version: 0.9,
  };

  /// Update the current step and progress
  void updateStep(InitializationStep step) {
    _currentStep = step;
    _progress = stepProgressMap[step] ?? 0.0;
    notifyListeners();
  }

  /// Update with custom progress value (for special cases)
  void updateWithProgress(InitializationStep step, double progress) {
    _currentStep = step;
    _progress = progress.clamp(0.0, 1.0);
    notifyListeners();
  }

  /// Reset to initial state
  void reset() {
    _currentStep = InitializationStep.starting;
    _progress = 0.0;
    notifyListeners();
  }

  /// Mark as complete
  void complete() {
    _currentStep = InitializationStep.version;
    _progress = 1.0;
    notifyListeners();
  }
}
