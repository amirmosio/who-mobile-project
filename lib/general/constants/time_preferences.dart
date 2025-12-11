/// Enums for medical visit time preferences
/// These match the Neith app implementation
library;

import 'package:who_mobile_project/generated/i18n/app_localizations.dart';

enum DayOfWeek {
  monday('monday'),
  tuesday('tuesday'),
  wednesday('wednesday'),
  thursday('thursday'),
  friday('friday');

  const DayOfWeek(this.key);

  final String key;

  /// Italian name for backend API (must match Neith app)
  String get italianName {
    switch (this) {
      case DayOfWeek.monday:
        return 'Lunedì';
      case DayOfWeek.tuesday:
        return 'Martedì';
      case DayOfWeek.wednesday:
        return 'Mercoledì';
      case DayOfWeek.thursday:
        return 'Giovedì';
      case DayOfWeek.friday:
        return 'Venerdì';
    }
  }

  /// Get translated name using AppLocalizations
  String getTranslatedName(AppLocalizations l10n) {
    switch (this) {
      case DayOfWeek.monday:
        return l10n.monday;
      case DayOfWeek.tuesday:
        return l10n.tuesday;
      case DayOfWeek.wednesday:
        return l10n.wednesday;
      case DayOfWeek.thursday:
        return l10n.thursday;
      case DayOfWeek.friday:
        return l10n.friday;
    }
  }
}

enum TimeSlot {
  morning('morning'),
  afternoon('afternoon');

  const TimeSlot(this.key);

  final String key;

  /// Italian name for backend API (must match Neith app)
  String get italianName {
    switch (this) {
      case TimeSlot.morning:
        return 'Mattina';
      case TimeSlot.afternoon:
        return 'Pomeriggio';
    }
  }

  /// Get translated name using AppLocalizations
  String getTranslatedName(AppLocalizations l10n) {
    switch (this) {
      case TimeSlot.morning:
        return l10n.morning;
      case TimeSlot.afternoon:
        return l10n.afternoon;
    }
  }
}

/// Time preference combining day and time slot
class TimePreference {
  final DayOfWeek day;
  final TimeSlot timeSlot;

  const TimePreference({required this.day, required this.timeSlot});

  /// Get the unique key for this preference
  String get key => '${day.key}_${timeSlot.key}';

  /// Get Italian display text for backend API
  String get italianDisplayText =>
      '${day.italianName} - ${timeSlot.italianName}';

  /// Get translated display text using AppLocalizations
  String getTranslatedDisplayText(AppLocalizations l10n) =>
      '${day.getTranslatedName(l10n)} - ${timeSlot.getTranslatedName(l10n)}';

  /// Get all available time preferences
  static List<TimePreference> getAllPreferences() {
    return [
      const TimePreference(day: DayOfWeek.monday, timeSlot: TimeSlot.morning),
      const TimePreference(day: DayOfWeek.monday, timeSlot: TimeSlot.afternoon),
      const TimePreference(day: DayOfWeek.tuesday, timeSlot: TimeSlot.morning),
      const TimePreference(
        day: DayOfWeek.tuesday,
        timeSlot: TimeSlot.afternoon,
      ),
      const TimePreference(
        day: DayOfWeek.wednesday,
        timeSlot: TimeSlot.morning,
      ),
      const TimePreference(
        day: DayOfWeek.wednesday,
        timeSlot: TimeSlot.afternoon,
      ),
      const TimePreference(day: DayOfWeek.thursday, timeSlot: TimeSlot.morning),
      const TimePreference(
        day: DayOfWeek.thursday,
        timeSlot: TimeSlot.afternoon,
      ),
      const TimePreference(day: DayOfWeek.friday, timeSlot: TimeSlot.morning),
      const TimePreference(day: DayOfWeek.friday, timeSlot: TimeSlot.afternoon),
    ];
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimePreference &&
          runtimeType == other.runtimeType &&
          day == other.day &&
          timeSlot == other.timeSlot;

  @override
  int get hashCode => day.hashCode ^ timeSlot.hashCode;
}
