class UpdateFcmTokenRequest {
  final String fcmToken;

  const UpdateFcmTokenRequest({required this.fcmToken});

  factory UpdateFcmTokenRequest.fromJson(Map<String, dynamic> json) {
    return UpdateFcmTokenRequest(fcmToken: json['fcm_token'] as String);
  }

  Map<String, dynamic> toJson() {
    return {'fcm_token': fcmToken};
  }

  @override
  String toString() => 'UpdateFcmTokenRequest(fcmToken: $fcmToken)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UpdateFcmTokenRequest && other.fcmToken == fcmToken;
  }

  @override
  int get hashCode => fcmToken.hashCode;
}
