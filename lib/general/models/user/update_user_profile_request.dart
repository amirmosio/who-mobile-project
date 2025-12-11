/// Request model for updating user profile
/// Used for PATCH /users/{id}/ endpoint
class UpdateUserProfileRequest {
  final String? firstName;
  final String? surname;
  final String? email;
  final String? phone;

  const UpdateUserProfileRequest({
    this.firstName,
    this.surname,
    this.email,
    this.phone,
  });

  factory UpdateUserProfileRequest.fromJson(Map<String, dynamic> json) {
    return UpdateUserProfileRequest(
      firstName: json['firstname'] as String?,
      surname: json['surname'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};

    if (firstName != null) json['firstname'] = firstName;
    if (surname != null) json['surname'] = surname;
    if (email != null) json['email'] = email;
    if (phone != null) json['phone'] = phone;

    return json;
  }
}
