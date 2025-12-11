/// Model for live session comments stored in Firestore
/// Users can comment during live sessions, teachers can view and reply after
class LiveSessionComment {
  final String id; // Firestore document ID
  final int liveSessionId; // OnlineLesson.id or OnlineLessonVideo.id
  final int userId; // User who posted
  final String userName; // Display name
  final String userAvatar; // Optional avatar URL
  final String text; // Comment content
  final int timestamp; // Unix timestamp in milliseconds
  final bool isTeacher; // Whether commenter is a teacher

  // Teacher reply fields
  final String? teacherReply; // Reply text from teacher
  final int? teacherReplyTimestamp; // When teacher replied
  final String? teacherName; // Name of teacher who replied

  // Metadata
  final bool isReported; // For moderation
  final bool
  isRead; // Whether user has read the teacher's reply (default false)

  const LiveSessionComment({
    required this.id,
    required this.liveSessionId,
    required this.userId,
    required this.userName,
    this.userAvatar = '',
    required this.text,
    required this.timestamp,
    this.isTeacher = false,
    this.teacherReply,
    this.teacherReplyTimestamp,
    this.teacherName,
    this.isReported = false,
    this.isRead = false,
  });

  /// Convert Unix timestamp to DateTime
  DateTime get dateTime => DateTime.fromMillisecondsSinceEpoch(timestamp);

  /// Convert teacher reply timestamp to DateTime
  DateTime? get teacherReplyDateTime => teacherReplyTimestamp != null
      ? DateTime.fromMillisecondsSinceEpoch(teacherReplyTimestamp!)
      : null;

  /// Check if this comment has a teacher reply
  bool get hasTeacherReply => teacherReply != null && teacherReply!.isNotEmpty;

  /// Check if this comment has an unseen teacher reply
  bool get hasUnseenTeacherReply => hasTeacherReply && !isRead;

  /// Create from Firestore document
  factory LiveSessionComment.fromFirestore(
    String docId,
    Map<String, dynamic> data,
  ) {
    return LiveSessionComment(
      id: docId,
      liveSessionId: data['live_session_id'] as int? ?? 0,
      userId: data['user_id'] as int? ?? 0,
      userName: data['user_name'] as String? ?? '',
      userAvatar: data['user_avatar'] as String? ?? '',
      text: data['text'] as String? ?? '',
      timestamp: data['timestamp'] as int? ?? 0,
      isTeacher: data['is_teacher'] as bool? ?? false,
      teacherReply: data['teacher_reply'] as String?,
      teacherReplyTimestamp: data['teacher_reply_timestamp'] as int?,
      teacherName: data['teacher_name'] as String?,
      isReported: data['is_reported'] as bool? ?? false,
      isRead: data['is_read'] as bool? ?? false,
    );
  }

  /// Convert to Map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'live_session_id': liveSessionId,
      'user_id': userId,
      'user_name': userName,
      'user_avatar': userAvatar,
      'text': text,
      'timestamp': timestamp,
      'is_teacher': isTeacher,
      'teacher_reply': teacherReply,
      'teacher_reply_timestamp': teacherReplyTimestamp,
      'teacher_name': teacherName,
      'is_reported': isReported,
      'is_read': isRead,
    };
  }

  LiveSessionComment copyWith({
    String? id,
    int? liveSessionId,
    int? userId,
    String? userName,
    String? userAvatar,
    String? text,
    int? timestamp,
    bool? isTeacher,
    String? teacherReply,
    int? teacherReplyTimestamp,
    String? teacherName,
    bool? isReported,
    bool? isRead,
  }) {
    return LiveSessionComment(
      id: id ?? this.id,
      liveSessionId: liveSessionId ?? this.liveSessionId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userAvatar: userAvatar ?? this.userAvatar,
      text: text ?? this.text,
      timestamp: timestamp ?? this.timestamp,
      isTeacher: isTeacher ?? this.isTeacher,
      teacherReply: teacherReply ?? this.teacherReply,
      teacherReplyTimestamp:
          teacherReplyTimestamp ?? this.teacherReplyTimestamp,
      teacherName: teacherName ?? this.teacherName,
      isReported: isReported ?? this.isReported,
      isRead: isRead ?? this.isRead,
    );
  }

  @override
  String toString() {
    return 'LiveSessionComment(id: $id, liveSessionId: $liveSessionId, '
        'userId: $userId, userName: $userName, hasReply: $hasTeacherReply)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LiveSessionComment &&
        other.id == id &&
        other.liveSessionId == liveSessionId &&
        other.userId == userId &&
        other.userName == userName &&
        other.userAvatar == userAvatar &&
        other.text == text &&
        other.timestamp == timestamp &&
        other.isTeacher == isTeacher &&
        other.teacherReply == teacherReply &&
        other.teacherReplyTimestamp == teacherReplyTimestamp &&
        other.teacherName == teacherName &&
        other.isReported == isReported &&
        other.isRead == isRead;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        liveSessionId.hashCode ^
        userId.hashCode ^
        userName.hashCode ^
        userAvatar.hashCode ^
        text.hashCode ^
        timestamp.hashCode ^
        isTeacher.hashCode ^
        teacherReply.hashCode ^
        teacherReplyTimestamp.hashCode ^
        teacherName.hashCode ^
        isReported.hashCode ^
        isRead.hashCode;
  }
}
