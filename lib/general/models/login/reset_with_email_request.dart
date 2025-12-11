class RestWithEmailRequest {
  final String email;

  RestWithEmailRequest({required this.email});

  factory RestWithEmailRequest.fromJson(Map<String, dynamic> json) {
    return RestWithEmailRequest(email: json['email']);
  }

  Map<String, dynamic> toJson() => {"email": email};

  factory RestWithEmailRequest.empty() {
    return RestWithEmailRequest(email: "");
  }
}
