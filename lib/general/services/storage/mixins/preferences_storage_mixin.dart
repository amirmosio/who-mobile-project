import 'package:who_mobile_project/general/services/storage/base_storage.dart';

/// Mixin for user preferences storage operations
mixin PreferencesStorageMixin on BaseStorage {
  // Storage keys
  static const _languageCodeKey = "language_code";
  static const _dsaFontEnabledKey = "dsa_font_enabled";
  static const _theoryShowcaseSeenKey = "theory_showcase_seen";
  static const _selectedArgumentIdsKey = "selected_argument_ids";

  /// Set language code
  Future<void> setLanguageCode(String code) async {
    await sharedPreferences.setString(_languageCodeKey, code);
  }

  /// Get language code
  String? getLanguageCode() {
    return sharedPreferences.getString(_languageCodeKey);
  }

  /// Set DSA font enabled preference
  Future<void> setDsaFontEnabled(bool enabled) async {
    await sharedPreferences.setBool(_dsaFontEnabledKey, enabled);
  }

  /// Get DSA font enabled preference
  bool getDsaFontEnabled() {
    return sharedPreferences.getBool(_dsaFontEnabledKey) ?? false;
  }

  /// Set theory showcase seen preference
  Future<void> setTheoryShowcaseSeen(bool seen) async {
    await sharedPreferences.setBool(_theoryShowcaseSeenKey, seen);
  }

  /// Get theory showcase seen preference
  bool getTheoryShowcaseSeen() {
    return sharedPreferences.getBool(_theoryShowcaseSeenKey) ?? false;
  }

  /// Save selected argument IDs for quiz
  Future<void> saveSelectedArgumentIds(List<int> argumentIds) async {
    await sharedPreferences.setStringList(
      _selectedArgumentIdsKey,
      argumentIds.map((id) => id.toString()).toList(),
    );
  }

  /// Get selected argument IDs for quiz
  List<int> getSelectedArgumentIds() {
    final stringList = sharedPreferences.getStringList(_selectedArgumentIdsKey);
    if (stringList == null) return [];
    return stringList.map((id) => int.parse(id)).toList();
  }

  // Quiz Reminder Storage
  static const _quizReminderEnabledKey = "quiz_reminder_enabled";
  static const _quizReminderTimeKey = "quiz_reminder_time";

  /// Set quiz reminder enabled preference
  Future<void> setQuizReminderEnabled(bool enabled) async {
    await sharedPreferences.setBool(_quizReminderEnabledKey, enabled);
  }

  /// Get quiz reminder enabled preference
  bool getQuizReminderEnabled() {
    return sharedPreferences.getBool(_quizReminderEnabledKey) ?? false;
  }

  /// Set quiz reminder time (stored as hour and minute)
  Future<void> setQuizReminderTime(int hour, int minute) async {
    await sharedPreferences.setInt('${_quizReminderTimeKey}_hour', hour);
    await sharedPreferences.setInt('${_quizReminderTimeKey}_minute', minute);
  }

  /// Get quiz reminder time (returns hour and minute as Map)
  Map<String, int>? getQuizReminderTime() {
    final hour = sharedPreferences.getInt('${_quizReminderTimeKey}_hour');
    final minute = sharedPreferences.getInt('${_quizReminderTimeKey}_minute');

    if (hour == null || minute == null) return null;

    return {'hour': hour, 'minute': minute};
  }

  /// Remove quiz reminder time
  Future<void> removeQuizReminderTime() async {
    await sharedPreferences.remove('${_quizReminderTimeKey}_hour');
    await sharedPreferences.remove('${_quizReminderTimeKey}_minute');
  }

  // Translation Preferences Storage
  static const _preferredTranslateLanguageKey = "preferred_translate_language";

  /// Set preferred translate language code
  Future<void> setPreferredTranslateLanguage(String languageCode) async {
    await sharedPreferences.setString(
      _preferredTranslateLanguageKey,
      languageCode,
    );
  }

  /// Get preferred translate language code
  String? getPreferredTranslateLanguage() {
    return sharedPreferences.getString(_preferredTranslateLanguageKey);
  }
}
