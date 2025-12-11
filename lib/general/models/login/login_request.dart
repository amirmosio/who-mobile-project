class LoginRequest {
  final String email;
  final String password;

  LoginRequest({required this.email, required this.password});

  factory LoginRequest.fromJson(Map<String, dynamic> json) {
    return LoginRequest(email: json['email'], password: json['password']);
  }

  Map<String, dynamic> toJson() => {"email": email, "password": password};

  factory LoginRequest.empty() {
    return LoginRequest(email: "", password: "");
  }
}
