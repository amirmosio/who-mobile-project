class RegistrationResponse {
  String otpId;

  RegistrationResponse({required this.otpId});

  factory RegistrationResponse.fromJson(Map<String, dynamic> json) {
    return RegistrationResponse(otpId: json['otp_id'] as String);
  }

  Map<String, dynamic> toJson() {
    return {'otp_id': otpId};
  }
}
