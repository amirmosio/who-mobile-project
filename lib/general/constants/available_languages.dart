import 'package:flutter/material.dart';
import 'package:who_mobile_project/generated/i18n/app_localizations.dart';

enum AvailableLanguage {
  italian(code: 'it', flagCode: 'it', locale: Locale('it', 'IT')),
  english(code: 'en', flagCode: 'gb', locale: Locale('en', 'US')),
  spanish(code: 'es', flagCode: 'es', locale: Locale('es', 'ES')),
  french(code: 'fr', flagCode: 'fr', locale: Locale('fr', 'FR')),
  german(code: 'de', flagCode: 'de', locale: Locale('de', 'DE'));

  /// Short language code (e.g., 'it', 'en', 'es')
  final String code;

  /// Flag country code for displaying country flags (e.g., 'it', 'gb', 'es')
  final String flagCode;

  /// Flutter Locale object
  final Locale locale;

  const AvailableLanguage({
    required this.code,
    required this.flagCode,
    required this.locale,
  });

  /// Full language code for TTS and other services (e.g., 'it-IT', 'en-US')
  /// Derived from the locale object
  String get languageCode {
    return '${locale.languageCode}-${locale.countryCode}';
  }

  /// Get localized display name for this language
  String getDisplayName(AppLocalizations l10n) {
    switch (this) {
      case AvailableLanguage.italian:
        return l10n.italian;
      case AvailableLanguage.english:
        return l10n.english;
      case AvailableLanguage.spanish:
        return l10n.spanish;
      case AvailableLanguage.french:
        return l10n.french;
      case AvailableLanguage.german:
        return l10n.german;
    }
  }

  /// Find language by locale
  static AvailableLanguage fromLocale(Locale locale) {
    return values.firstWhere(
      (lang) => lang.locale.languageCode == locale.languageCode,
      orElse: () => AvailableLanguage.italian, // Default to Italian
    );
  }

  /// Find language by short code (e.g., 'it', 'en')
  static AvailableLanguage fromCode(String code) {
    return values.firstWhere(
      (lang) => lang.code == code,
      orElse: () => AvailableLanguage.italian, // Default to Italian
    );
  }

  /// Find language by TTS language code (e.g., 'it-IT', 'en-US')
  static AvailableLanguage fromLanguageCode(String languageCode) {
    return values.firstWhere(
      (lang) => lang.languageCode == languageCode,
      orElse: () => AvailableLanguage.italian, // Default to Italian
    );
  }

  /// Get all available languages
  static List<AvailableLanguage> get all => values;

  /// Get all language codes
  static List<String> get allCodes => values.map((lang) => lang.code).toList();

  /// Get all locales
  static List<Locale> get allLocales =>
      values.map((lang) => lang.locale).toList();
}

/// Extension on Locale to easily get AvailableLanguage
extension LocaleExtension on Locale {
  AvailableLanguage toAvailableLanguage() {
    return AvailableLanguage.fromLocale(this);
  }
}

/// Extension on String to easily get AvailableLanguage
extension StringLanguageExtension on String {
  AvailableLanguage? toAvailableLanguage() {
    return AvailableLanguage.fromCode(this);
  }
}
