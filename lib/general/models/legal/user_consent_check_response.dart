/// Response model for user consent check endpoint
/// API returns: {"has_accepted": false}
class UserConsentCheckResponse {
  final bool hasAccepted;

  UserConsentCheckResponse({required this.hasAccepted});

  factory UserConsentCheckResponse.fromJson(Map<String, dynamic> json) {
    return UserConsentCheckResponse(
      hasAccepted: json['has_accepted'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {'has_accepted': hasAccepted};
  }
}
