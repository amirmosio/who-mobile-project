/// Represents a user-created note for a specific step or component
class UserNote {
  /// Unique identifier for the note
  final String id;

  /// Installation ID this note belongs to
  final String installationId;

  /// Step ID (optional - can be general note)
  final String? stepId;

  /// Component ID (optional)
  final String? componentId;

  /// Note text content
  final String noteText;

  /// Type of note (e.g., "damage", "repair", "observation", "warning")
  final String noteType;

  /// Severity (e.g., "low", "medium", "high", "critical")
  final String? severity;

  /// Image URLs attached to the note
  final List<String> imageUrls;

  /// User ID who created the note
  final String? userId;

  /// User name who created the note
  final String? userName;

  /// Creation timestamp
  final DateTime createdAt;

  /// Last update timestamp
  final DateTime? updatedAt;

  /// Whether the issue has been resolved
  final bool isResolved;

  const UserNote({
    required this.id,
    required this.installationId,
    this.stepId,
    this.componentId,
    required this.noteText,
    this.noteType = 'observation',
    this.severity,
    this.imageUrls = const [],
    this.userId,
    this.userName,
    required this.createdAt,
    this.updatedAt,
    this.isResolved = false,
  });

  factory UserNote.fromJson(Map<String, dynamic> json) {
    return UserNote(
      id: json['id'] as String,
      installationId: json['installationId'] as String,
      stepId: json['stepId'] as String?,
      componentId: json['componentId'] as String?,
      noteText: json['noteText'] as String,
      noteType: json['noteType'] as String? ?? 'observation',
      severity: json['severity'] as String?,
      imageUrls: (json['imageUrls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      userId: json['userId'] as String?,
      userName: json['userName'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      isResolved: json['isResolved'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'installationId': installationId,
      'stepId': stepId,
      'componentId': componentId,
      'noteText': noteText,
      'noteType': noteType,
      'severity': severity,
      'imageUrls': imageUrls,
      'userId': userId,
      'userName': userName,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isResolved': isResolved,
    };
  }

  UserNote copyWith({
    String? id,
    String? installationId,
    String? stepId,
    String? componentId,
    String? noteText,
    String? noteType,
    String? severity,
    List<String>? imageUrls,
    String? userId,
    String? userName,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isResolved,
  }) {
    return UserNote(
      id: id ?? this.id,
      installationId: installationId ?? this.installationId,
      stepId: stepId ?? this.stepId,
      componentId: componentId ?? this.componentId,
      noteText: noteText ?? this.noteText,
      noteType: noteType ?? this.noteType,
      severity: severity ?? this.severity,
      imageUrls: imageUrls ?? this.imageUrls,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isResolved: isResolved ?? this.isResolved,
    );
  }
}
