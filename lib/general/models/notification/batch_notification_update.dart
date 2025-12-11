class BatchNotificationItem {
  final bool hasSeen;
  final List<String> notificationIds;

  BatchNotificationItem({required this.notificationIds, required this.hasSeen});

  factory BatchNotificationItem.fromJson(Map<String, dynamic> json) {
    return BatchNotificationItem(
      hasSeen: json['has_seen'],
      notificationIds: json['notifications_ids'],
    );
  }

  Map<String, dynamic> toJson() => {
    "has_seen": hasSeen,
    "notifications_ids": notificationIds,
  };

  factory BatchNotificationItem.empty() {
    return BatchNotificationItem(notificationIds: [], hasSeen: false);
  }
}
