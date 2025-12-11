import 'package:flutter/material.dart';
import 'package:who_mobile_project/generated/i18n/app_localizations.dart';

enum CalendarViewType { month, week, day }

extension CalendarViewTypeDetails on CalendarViewType {
  String getName(BuildContext context) {
    switch (this) {
      case CalendarViewType.month:
        return AppLocalizations.of(context)!.month;
      case CalendarViewType.week:
        return AppLocalizations.of(context)!.week;
      case CalendarViewType.day:
        return AppLocalizations.of(context)!.day;
    }
  }
}
