class RegistrationRequest {
  String confirmPassword;
  String email;
  String firstName;
  String lastName;
  String password;
  String phoneNumber;
  String? acceptedTermsVersion;
  String? acceptedPrivacyVersion;
  DateTime? lastConsentUpdate;

  RegistrationRequest({
    required this.confirmPassword,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.password,
    required this.phoneNumber,
    this.acceptedTermsVersion,
    this.acceptedPrivacyVersion,
    this.lastConsentUpdate,
  });

  factory RegistrationRequest.fromJson(Map<String, dynamic> json) {
    return RegistrationRequest(
      confirmPassword: json['confirm_password'] as String,
      email: json['email'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      password: json['password'] as String,
      phoneNumber: json['phone_number'] as String,
      acceptedTermsVersion: json['accepted_terms_version'] as String?,
      acceptedPrivacyVersion: json['accepted_privacy_version'] as String?,
      lastConsentUpdate: json['last_consent_update'] != null
          ? DateTime.tryParse(json['last_consent_update'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'confirm_password': confirmPassword,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'password': password,
      'phone_number': phoneNumber,
      if (acceptedTermsVersion != null)
        'accepted_terms_version': acceptedTermsVersion,
      if (acceptedPrivacyVersion != null)
        'accepted_privacy_version': acceptedPrivacyVersion,
      if (lastConsentUpdate != null)
        'last_consent_update': lastConsentUpdate!.toIso8601String(),
    };
  }
}
