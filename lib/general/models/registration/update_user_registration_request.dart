/// Request model for updating guest user to registered user (iOS-style)
/// This matches the iOS implementation where we PATCH /users/{id}/ to convert guest to registered user
class UpdateUserRegistrationRequest {
  final String firstname;
  final String surname;
  final String email;
  final String password;
  final String? phone;
  final bool isGuest;
  final bool acceptedMarketing;
  final bool acceptedPrivacy;

  UpdateUserRegistrationRequest({
    required this.firstname,
    required this.surname,
    required this.email,
    required this.password,
    this.phone,
    this.isGuest = false,
    required this.acceptedMarketing,
    this.acceptedPrivacy = true,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'firstname': firstname,
      'surname': surname,
      'email': email,
      'password': password,
      'is_guest': isGuest,
      'accepted_marketing': acceptedMarketing,
      'accepted_privacy': acceptedPrivacy,
    };

    if (phone != null && phone!.isNotEmpty) {
      json['phone'] = phone;
    }

    return json;
  }

  factory UpdateUserRegistrationRequest.fromJson(Map<String, dynamic> json) {
    return UpdateUserRegistrationRequest(
      firstname: json['firstname'] as String,
      surname: json['surname'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      phone: json['phone'] as String?,
      isGuest: json['is_guest'] as bool? ?? false,
      acceptedMarketing: json['accepted_marketing'] as bool,
      acceptedPrivacy: json['accepted_privacy'] as bool? ?? true,
    );
  }
}
