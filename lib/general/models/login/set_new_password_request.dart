class SetNewPasswordRequest {
  final String password;
  final String password2;

  SetNewPasswordRequest({required this.password, required this.password2});

  Map<String, dynamic> toJson() => {
    "password": password,
    "password2": password2,
  };

  factory SetNewPasswordRequest.empty() {
    return SetNewPasswordRequest(password: '', password2: '');
  }
}
