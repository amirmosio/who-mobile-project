class NotificationCountResponse {
  final int count;

  NotificationCountResponse({required this.count});

  factory NotificationCountResponse.fromJson(Map<String, dynamic> json) {
    return NotificationCountResponse(count: json['count']);
  }

  Map<String, dynamic> toJson() => {"count": count};

  factory NotificationCountResponse.empty() {
    return NotificationCountResponse(count: 0);
  }
}
