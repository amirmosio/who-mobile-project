import 'package:flutter/cupertino.dart';
import 'package:who_mobile_project/app_core/theme/colors.dart';
import 'package:who_mobile_project/generated/i18n/app_localizations.dart';

enum ReservationStatusType { pending, confirmed, approved, rejected }

extension ReservationStatusTypesDetails on ReservationStatusType {
  String getName(BuildContext context) {
    switch (this) {
      case ReservationStatusType.pending:
        return AppLocalizations.of(context)!.pending;
      case ReservationStatusType.confirmed:
        return AppLocalizations.of(context)!.confirmed;
      case ReservationStatusType.approved:
        return AppLocalizations.of(context)!.approved;
      case ReservationStatusType.rejected:
        return AppLocalizations.of(context)!.rejected;
    }
  }

  String get id {
    switch (this) {
      case ReservationStatusType.pending:
        return 'PENDING';
      case ReservationStatusType.confirmed:
        return 'CONFIRMED';
      case ReservationStatusType.approved:
        return 'APPROVED';
      case ReservationStatusType.rejected:
        return 'REJECTED';
    }
  }

  Color get color {
    switch (this) {
      case ReservationStatusType.pending:
        return GVColors.eventPending;
      case ReservationStatusType.confirmed:
        return GVColors.eventConfirmed;
      case ReservationStatusType.approved:
        return GVColors.eventApproved;
      case ReservationStatusType.rejected:
        return GVColors.eventRejected;
    }
  }
}
