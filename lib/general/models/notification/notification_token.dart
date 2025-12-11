class NotificationTokenUpdateRequest {
  final String? token;

  NotificationTokenUpdateRequest({required this.token});

  Map<String, dynamic> toJson() => {"token": token};

  factory NotificationTokenUpdateRequest.empty() {
    return NotificationTokenUpdateRequest(token: null);
  }
}

class NotificationTokenRegisterRequest {
  final String token;

  NotificationTokenRegisterRequest({required this.token});

  Map<String, dynamic> toJson() => {"device_token": token};
}
