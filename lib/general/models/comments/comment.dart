import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:who_mobile_project/general/constants/comment_categories.dart';

/// Model for comments in the WHO Mobile app
/// Stores user comments organized by category
class Comment {
  /// Firestore document ID
  final String id;

  /// Comment text content
  final String text;

  /// Category of the comment
  final CommentCategory category;

  /// Firebase user ID of the author
  final String authorId;

  /// Display name of the author
  final String authorName;

  /// Email of the author
  final String authorEmail;

  /// When the comment was created
  final DateTime createdAt;

  /// When the comment was last updated (optional)
  final DateTime? updatedAt;

  /// Soft delete flag
  final bool isDeleted;

  const Comment({
    required this.id,
    required this.text,
    required this.category,
    required this.authorId,
    required this.authorName,
    required this.authorEmail,
    required this.createdAt,
    this.updatedAt,
    this.isDeleted = false,
  });

  /// Create Comment from Firestore document snapshot
  factory Comment.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return Comment(
      id: doc.id,
      text: data['text'] as String? ?? '',
      category: CommentCategory.fromFirestoreValue(data['category'] as String?),
      authorId: data['authorId'] as String? ?? '',
      authorName: data['authorName'] as String? ?? 'Unknown',
      authorEmail: data['authorEmail'] as String? ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
      isDeleted: data['isDeleted'] as bool? ?? false,
    );
  }

  /// Create Comment from Firestore data map with document ID
  factory Comment.fromMap(String docId, Map<String, dynamic> data) {
    return Comment(
      id: docId,
      text: data['text'] as String? ?? '',
      category: CommentCategory.fromFirestoreValue(data['category'] as String?),
      authorId: data['authorId'] as String? ?? '',
      authorName: data['authorName'] as String? ?? 'Unknown',
      authorEmail: data['authorEmail'] as String? ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
      isDeleted: data['isDeleted'] as bool? ?? false,
    );
  }

  /// Convert to Firestore document data for creating a new comment
  Map<String, dynamic> toFirestore() => {
        'text': text,
        'category': category.toFirestoreValue(),
        'authorId': authorId,
        'authorName': authorName,
        'authorEmail': authorEmail,
        'createdAt': FieldValue.serverTimestamp(),
        'isDeleted': isDeleted,
      };

  /// Convert to Firestore document data for updating a comment
  Map<String, dynamic> toFirestoreUpdate() => {
        'text': text,
        'category': category.toFirestoreValue(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

  /// Get author initials for avatar display
  String get authorInitials {
    if (authorName.isNotEmpty && authorName != 'Unknown') {
      final parts = authorName.split(' ');
      if (parts.length >= 2) {
        return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
      }
      return authorName[0].toUpperCase();
    }
    if (authorEmail.isNotEmpty) {
      return authorEmail[0].toUpperCase();
    }
    return 'U';
  }

  /// Create a copy with updated fields
  Comment copyWith({
    String? id,
    String? text,
    CommentCategory? category,
    String? authorId,
    String? authorName,
    String? authorEmail,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isDeleted,
  }) {
    return Comment(
      id: id ?? this.id,
      text: text ?? this.text,
      category: category ?? this.category,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      authorEmail: authorEmail ?? this.authorEmail,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Comment && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'Comment(id: $id, category: ${category.displayName}, '
      'author: $authorName, text: ${text.length > 50 ? '${text.substring(0, 50)}...' : text})';
}
