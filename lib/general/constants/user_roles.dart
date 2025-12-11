import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:who_mobile_project/generated/i18n/app_localizations.dart';

enum RoleType { owner, admin, member }

extension RoleTypeDetail on RoleType {
  String getTitle(BuildContext context) {
    switch (this) {
      case RoleType.owner:
        return AppLocalizations.of(context)!.owner;
      case RoleType.admin:
        return AppLocalizations.of(context)!.administrator;
      case RoleType.member:
        return AppLocalizations.of(context)!.operator;
    }
  }

  String get id {
    switch (this) {
      case RoleType.owner:
        return "O";
      case RoleType.admin:
        return "A";
      case RoleType.member:
        return "M";
    }
  }
}

extension RoleTypeString on String {
  RoleType get toRoleType {
    return RoleType.values.firstWhereOrNull((e) => e.id == this) ??
        RoleType.member;
  }
}
