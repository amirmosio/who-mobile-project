class RefreshTokenRequest {
  final String refresh;

  RefreshTokenRequest({required this.refresh});

  factory RefreshTokenRequest.fromJson(Map<String, dynamic> json) {
    return RefreshTokenRequest(refresh: json['refresh']);
  }

  Map<String, dynamic> toJson() => {"refresh": refresh};

  factory RefreshTokenRequest.empty() {
    return RefreshTokenRequest(refresh: "");
  }
}
