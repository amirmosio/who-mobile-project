import 'package:who_mobile_project/general/models/base_dropdown_item.dart';
import 'package:who_mobile_project/general/constants/time_preferences.dart';
import 'package:who_mobile_project/generated/i18n/app_localizations.dart';

class TimePreferenceItem extends BaseDropDownItemModel {
  final String value;
  final DayOfWeek day;
  final TimeSlot timeSlot;

  // Translatable display text using AppLocalizations
  String getTranslatedDisplayText(AppLocalizations l10n) {
    return '${day.getTranslatedName(l10n)} - ${timeSlot.getTranslatedName(l10n)}';
  }

  // Italian text for backend API (must match Neith app)
  String get italianDisplayText =>
      '${day.italianName} - ${timeSlot.italianName}';

  TimePreferenceItem({
    required this.value,
    required this.day,
    required this.timeSlot,
  }) : super(id: value, name: value);

  @override
  String get displayName => value;

  static List<TimePreferenceItem> getAllTimePreferences() {
    return [
      TimePreferenceItem(
        value: 'monday_morning',
        day: DayOfWeek.monday,
        timeSlot: TimeSlot.morning,
      ),
      TimePreferenceItem(
        value: 'monday_afternoon',
        day: DayOfWeek.monday,
        timeSlot: TimeSlot.afternoon,
      ),
      TimePreferenceItem(
        value: 'tuesday_morning',
        day: DayOfWeek.tuesday,
        timeSlot: TimeSlot.morning,
      ),
      TimePreferenceItem(
        value: 'tuesday_afternoon',
        day: DayOfWeek.tuesday,
        timeSlot: TimeSlot.afternoon,
      ),
      TimePreferenceItem(
        value: 'wednesday_morning',
        day: DayOfWeek.wednesday,
        timeSlot: TimeSlot.morning,
      ),
      TimePreferenceItem(
        value: 'wednesday_afternoon',
        day: DayOfWeek.wednesday,
        timeSlot: TimeSlot.afternoon,
      ),
      TimePreferenceItem(
        value: 'thursday_morning',
        day: DayOfWeek.thursday,
        timeSlot: TimeSlot.morning,
      ),
      TimePreferenceItem(
        value: 'thursday_afternoon',
        day: DayOfWeek.thursday,
        timeSlot: TimeSlot.afternoon,
      ),
      TimePreferenceItem(
        value: 'friday_morning',
        day: DayOfWeek.friday,
        timeSlot: TimeSlot.morning,
      ),
      TimePreferenceItem(
        value: 'friday_afternoon',
        day: DayOfWeek.friday,
        timeSlot: TimeSlot.afternoon,
      ),
    ];
  }
}
