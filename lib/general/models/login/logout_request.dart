class LogoutRequest {
  final String refresh;

  LogoutRequest({required this.refresh});

  factory LogoutRequest.fromJson(Map<String, dynamic> json) {
    return LogoutRequest(refresh: json['refresh']);
  }

  Map<String, dynamic> toJson() => {"refresh": refresh};

  factory LogoutRequest.empty() {
    return LogoutRequest(refresh: "");
  }
}
