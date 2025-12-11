import 'package:who_mobile_project/general/models/user/license_type_model.dart';

class GuestRegistrationModel {
  final String firstName;
  final String surname;
  final String email;
  final String password;
  final bool isGuest;
  final bool wasGuest;
  final bool acceptedPrivacy;
  final bool acceptedMarketing;
  final int? drivingSchoolId;
  int licenseTypeId;
  final LicenseTypeModel? tempLicenseType;
  final String? acceptedTermsVersion;
  final String? acceptedPrivacyVersion;
  final DateTime? lastConsentUpdate;

  /// Getter to get license type ID from either the model or the ID field
  int get effectiveLicenseTypeId => tempLicenseType?.id ?? licenseTypeId;

  GuestRegistrationModel({
    required this.firstName,
    required this.surname,
    required this.email,
    required this.password,
    this.isGuest = true,
    this.wasGuest = true,
    this.acceptedPrivacy = true,
    required this.acceptedMarketing,
    this.drivingSchoolId,
    required this.licenseTypeId,
    this.tempLicenseType,
    this.acceptedTermsVersion,
    this.acceptedPrivacyVersion,
    this.lastConsentUpdate,
  });

  Map<String, dynamic> toJson() => {
    'firstname': firstName,
    'surname': surname,
    'email': email,
    'password': password,
    'is_guest': isGuest,
    'was_guest': wasGuest,
    'accepted_privacy': acceptedPrivacy,
    'accepted_marketing': acceptedMarketing,
    if (drivingSchoolId != null) 'driving_school': drivingSchoolId,
    'license_type': tempLicenseType?.id ?? licenseTypeId,
    if (acceptedTermsVersion != null)
      'accepted_terms_version': acceptedTermsVersion,
    if (acceptedPrivacyVersion != null)
      'accepted_privacy_version': acceptedPrivacyVersion,
    if (lastConsentUpdate != null)
      'last_consent_update': lastConsentUpdate!.toIso8601String(),
  };

  factory GuestRegistrationModel.fromJson(Map<String, dynamic> json) {
    return GuestRegistrationModel(
      firstName: json['firstname'] as String,
      surname: json['surname'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      isGuest: json['is_guest'] as bool? ?? true,
      wasGuest: json['was_guest'] as bool? ?? true,
      acceptedPrivacy: json['accepted_privacy'] as bool? ?? true,
      acceptedMarketing: json['accepted_marketing'] as bool,
      drivingSchoolId: json['driving_school'] as int?,
      licenseTypeId: json['license_type'] as int,
      acceptedTermsVersion: json['accepted_terms_version'] as String?,
      acceptedPrivacyVersion: json['accepted_privacy_version'] as String?,
      lastConsentUpdate: json['last_consent_update'] != null
          ? DateTime.tryParse(json['last_consent_update'] as String)
          : null,
    );
  }

  @override
  String toString() {
    return 'GuestRegistrationRequest: $firstName, $surname, $email';
  }
}
