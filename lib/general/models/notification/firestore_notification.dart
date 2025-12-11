/// Model for notifications stored in Firestore
/// Matches the structure from neithapp's Notifications interface
class FirestoreNotification {
  final String id; // Firestore document ID
  final int userId;
  final String title;
  final String text; // Notification body/content
  final int sendDatetime; // Unix timestamp in milliseconds
  final bool read;
  final String path; // Navigation path/route
  final String extras; // Additional metadata (JSON string)

  const FirestoreNotification({
    required this.id,
    required this.userId,
    required this.title,
    required this.text,
    required this.sendDatetime,
    required this.read,
    required this.path,
    required this.extras,
  });

  /// Convert Unix timestamp to DateTime
  DateTime get dateTime => DateTime.fromMillisecondsSinceEpoch(sendDatetime);

  /// Create from Firestore document
  factory FirestoreNotification.fromFirestore(
    String docId,
    Map<String, dynamic> data,
  ) {
    return FirestoreNotification(
      id: docId,
      userId: data['user_id'] as int? ?? 0,
      title: data['title'] as String? ?? '',
      text: data['text'] as String? ?? '',
      sendDatetime: data['send_datetime'] as int? ?? 0,
      read: data['read'] as bool? ?? false,
      path: data['path'] as String? ?? '',
      extras: data['extras'] as String? ?? '',
    );
  }

  /// Convert to Map for Firestore updates
  Map<String, dynamic> toFirestore() {
    return {
      'user_id': userId,
      'title': title,
      'text': text,
      'send_datetime': sendDatetime,
      'read': read,
      'path': path,
      'extras': extras,
    };
  }

  /// Create a copy with updated fields
  FirestoreNotification copyWith({
    String? id,
    int? userId,
    String? title,
    String? text,
    int? sendDatetime,
    bool? read,
    String? path,
    String? extras,
  }) {
    return FirestoreNotification(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      text: text ?? this.text,
      sendDatetime: sendDatetime ?? this.sendDatetime,
      read: read ?? this.read,
      path: path ?? this.path,
      extras: extras ?? this.extras,
    );
  }

  @override
  String toString() {
    return 'FirestoreNotification(id: $id, userId: $userId, title: $title, '
        'read: $read, sendDatetime: $sendDatetime)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FirestoreNotification &&
        other.id == id &&
        other.userId == userId &&
        other.title == title &&
        other.text == text &&
        other.sendDatetime == sendDatetime &&
        other.read == read &&
        other.path == path &&
        other.extras == extras;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        title.hashCode ^
        text.hashCode ^
        sendDatetime.hashCode ^
        read.hashCode ^
        path.hashCode ^
        extras.hashCode;
  }
}
