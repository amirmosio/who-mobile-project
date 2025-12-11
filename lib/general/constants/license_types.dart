import 'package:who_mobile_project/general/models/user/license_type_model.dart';

/// License type options matching Android implementation
enum LicenseGroup {
  classica('CLASSICA', 'Classica'),
  superiori('SUPERIORI', 'Superiori'),
  cap('CAP', 'CAP'),
  revisione('REVISIONE', 'Revisione');

  const LicenseGroup(this.id, this.displayName);

  final String id;
  final String displayName;

  static LicenseGroup? fromId(String id) {
    for (final group in LicenseGroup.values) {
      if (group.id == id) return group;
    }
    return null;
  }

  List<LicenseTypeModel> filterLicenseTypes(List<LicenseTypeModel> allTypes) {
    switch (this) {
      case LicenseGroup.classica:
        return allTypes
            .where(
              (lt) =>
                  lt.isActive &&
                  !(lt.isRevision ?? false) &&
                  lt.name.toUpperCase().startsWith('A'),
            )
            .toList();

      case LicenseGroup.superiori:
        return allTypes
            .where(
              (lt) =>
                  lt.isActive &&
                  !(lt.isRevision ?? false) &&
                  !lt.name.toUpperCase().startsWith('A') &&
                  !(lt.hasAnswer ?? false),
            )
            .toList();

      case LicenseGroup.revisione:
        return allTypes
            .where((lt) => lt.isActive && (lt.isRevision ?? false))
            .toList();

      case LicenseGroup.cap:
        return allTypes
            .where((lt) => lt.isActive && (lt.hasAnswer ?? false))
            .toList();
    }
  }

  static LicenseGroup? fromLicenseType(LicenseTypeModel licenseType) {
    if (licenseType.isRevision ?? false) {
      return LicenseGroup.revisione;
    }

    if (licenseType.hasAnswer ?? false) {
      return LicenseGroup.cap;
    }

    if (licenseType.name.toUpperCase().startsWith('A')) {
      return LicenseGroup.classica;
    }

    return LicenseGroup.superiori;
  }
}
