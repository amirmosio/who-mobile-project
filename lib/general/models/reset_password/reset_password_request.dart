class ResetPasswordRequest {
  final String confirmPassword;
  final String newPassword;

  ResetPasswordRequest({
    required this.confirmPassword,
    required this.newPassword,
  });

  factory ResetPasswordRequest.fromJson(Map<String, dynamic> json) {
    return ResetPasswordRequest(
      confirmPassword: json['confirm_password'] ?? '',
      newPassword: json['new_password'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'confirm_password': confirmPassword, 'new_password': newPassword};
  }
}
