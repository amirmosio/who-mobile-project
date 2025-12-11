import 'package:flutter/material.dart';
import 'package:who_mobile_project/generated/i18n/app_localizations.dart';

enum AILanguage { italian, english, spanish, french, german, arabic }

extension AILanguageDetail on AILanguage {
  String getLabel(BuildContext context) {
    switch (this) {
      case AILanguage.italian:
        return AppLocalizations.of(context)!.italian;
      case AILanguage.english:
        return AppLocalizations.of(context)!.english;
      case AILanguage.spanish:
        return AppLocalizations.of(context)!.spanish;
      case AILanguage.french:
        return AppLocalizations.of(context)!.french;
      case AILanguage.german:
        return AppLocalizations.of(context)!.german;
      case AILanguage.arabic:
        return AppLocalizations.of(context)!.arabic;
    }
  }

  String get id {
    switch (this) {
      case AILanguage.italian:
        return "it";
      case AILanguage.english:
        return "en";
      case AILanguage.spanish:
        return "es";
      case AILanguage.french:
        return "fr";
      case AILanguage.german:
        return "de";
      case AILanguage.arabic:
        return "ar";
    }
  }
}
