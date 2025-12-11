class VerifyOtpRequest {
  String otpId;
  String otp;

  VerifyOtpRequest({required this.otpId, required this.otp});

  factory VerifyOtpRequest.fromJson(Map<String, dynamic> json) {
    return VerifyOtpRequest(
      otpId: json['otp_id'] as String,
      otp: json['otp'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'otp_id': otpId, 'otp': otp};
  }
}
