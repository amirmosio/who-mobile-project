import 'package:who_mobile_project/general/constants/login_methods.dart';

class SocialRegistrationRequest {
  final String idToken;
  final String? accessToken;
  final LoginMethod provider;
  final String email;
  final String name;
  final String? phoneNumber;
  final bool termsAccepted;
  final bool privacyPolicyAccepted;
  final String? acceptedTermsVersion;
  final String? acceptedPrivacyVersion;
  final DateTime? lastConsentUpdate;

  SocialRegistrationRequest({
    required this.idToken,
    this.accessToken,
    required this.provider,
    required this.email,
    required this.name,
    this.phoneNumber,
    required this.termsAccepted,
    required this.privacyPolicyAccepted,
    this.acceptedTermsVersion,
    this.acceptedPrivacyVersion,
    this.lastConsentUpdate,
  });

  factory SocialRegistrationRequest.fromJson(Map<String, dynamic> json) {
    return SocialRegistrationRequest(
      idToken: json['id_token'] as String,
      accessToken: json['access_token'] as String?,
      provider: LoginMethod.fromId(json['provider'] as String),
      email: json['email'] as String,
      name: json['name'] as String,
      phoneNumber: json['phone_number'] as String?,
      termsAccepted: json['terms_accepted'] as bool,
      privacyPolicyAccepted: json['privacy_policy_accepted'] as bool,
      acceptedTermsVersion: json['accepted_terms_version'] as String?,
      acceptedPrivacyVersion: json['accepted_privacy_version'] as String?,
      lastConsentUpdate: json['last_consent_update'] != null
          ? DateTime.tryParse(json['last_consent_update'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id_token': idToken,
    'access_token': accessToken,
    'provider': provider.id,
    'email': email,
    'name': name,
    'phone_number': phoneNumber,
    'terms_accepted': termsAccepted,
    'privacy_policy_accepted': privacyPolicyAccepted,
    if (acceptedTermsVersion != null)
      'accepted_terms_version': acceptedTermsVersion,
    if (acceptedPrivacyVersion != null)
      'accepted_privacy_version': acceptedPrivacyVersion,
    if (lastConsentUpdate != null)
      'last_consent_update': lastConsentUpdate!.toIso8601String(),
  };

  factory SocialRegistrationRequest.empty() {
    return SocialRegistrationRequest(
      idToken: "",
      provider: LoginMethod.google,
      email: "",
      name: "",
      termsAccepted: false,
      privacyPolicyAccepted: false,
      acceptedTermsVersion: null,
      acceptedPrivacyVersion: null,
      lastConsentUpdate: null,
    );
  }
}
