import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:who_mobile_project/general/constants/comment_categories.dart';
import 'package:who_mobile_project/general/models/comments/comment.dart';

/// Firebase Comments Service
/// Handles all Firestore operations for comments
/// Registered as singleton via FirebaseModule in DI
class FirebaseCommentsService {
  final FirebaseFirestore _firestore;

  /// Firestore collection name for comments
  static const String _commentsCollection = 'comments';

  /// Maximum characters for comment text
  static const int maxCommentLength = 1000;

  FirebaseCommentsService() : _firestore = FirebaseFirestore.instance;

  /// Get stream of comments filtered by category (optional)
  /// Returns non-deleted comments ordered by creation date (newest first)
  Stream<List<Comment>> getCommentsStream({CommentCategory? category}) {
    Query<Map<String, dynamic>> query = _firestore
        .collection(_commentsCollection)
        .where('isDeleted', isEqualTo: false);

    if (category != null) {
      query = query.where('category', isEqualTo: category.toFirestoreValue());
    }

    return query.orderBy('createdAt', descending: true).snapshots().map(
        (snapshot) =>
            snapshot.docs.map((doc) => Comment.fromFirestore(doc)).toList());
  }

  /// Get all comments once (not a stream)
  /// Optionally filter by category
  Future<List<Comment>> getComments({CommentCategory? category}) async {
    Query<Map<String, dynamic>> query = _firestore
        .collection(_commentsCollection)
        .where('isDeleted', isEqualTo: false);

    if (category != null) {
      query = query.where('category', isEqualTo: category.toFirestoreValue());
    }

    final snapshot = await query.orderBy('createdAt', descending: true).get();
    return snapshot.docs.map((doc) => Comment.fromFirestore(doc)).toList();
  }

  /// Create a new comment
  /// Returns the created comment's document ID
  Future<String> createComment({
    required String text,
    required CommentCategory category,
    required String authorId,
    required String authorName,
    required String authorEmail,
  }) async {
    if (text.isEmpty) {
      throw ArgumentError('Comment text cannot be empty');
    }
    if (text.length > maxCommentLength) {
      throw ArgumentError(
          'Comment text exceeds maximum length of $maxCommentLength characters');
    }

    final docRef = await _firestore.collection(_commentsCollection).add({
      'text': text.trim(),
      'category': category.toFirestoreValue(),
      'authorId': authorId,
      'authorName': authorName,
      'authorEmail': authorEmail,
      'createdAt': FieldValue.serverTimestamp(),
      'isDeleted': false,
    });

    return docRef.id;
  }

  /// Update an existing comment's text and/or category
  Future<void> updateComment({
    required String commentId,
    String? text,
    CommentCategory? category,
  }) async {
    if (text != null && text.isEmpty) {
      throw ArgumentError('Comment text cannot be empty');
    }
    if (text != null && text.length > maxCommentLength) {
      throw ArgumentError(
          'Comment text exceeds maximum length of $maxCommentLength characters');
    }

    final updates = <String, dynamic>{
      'updatedAt': FieldValue.serverTimestamp(),
    };

    if (text != null) {
      updates['text'] = text.trim();
    }
    if (category != null) {
      updates['category'] = category.toFirestoreValue();
    }

    await _firestore
        .collection(_commentsCollection)
        .doc(commentId)
        .update(updates);
  }

  /// Soft delete a comment (set isDeleted to true)
  Future<void> deleteComment(String commentId) async {
    await _firestore.collection(_commentsCollection).doc(commentId).update({
      'isDeleted': true,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Permanently delete a comment document
  /// Use with caution - prefer soft delete for audit trail
  Future<void> permanentlyDeleteComment(String commentId) async {
    await _firestore.collection(_commentsCollection).doc(commentId).delete();
  }

  /// Get a single comment by ID
  Future<Comment?> getComment(String commentId) async {
    final doc =
        await _firestore.collection(_commentsCollection).doc(commentId).get();
    if (!doc.exists) return null;
    return Comment.fromFirestore(doc);
  }

  /// Get comment count by category
  Future<Map<CommentCategory, int>> getCommentCountsByCategory() async {
    final counts = <CommentCategory, int>{};

    for (final category in CommentCategory.values) {
      final snapshot = await _firestore
          .collection(_commentsCollection)
          .where('isDeleted', isEqualTo: false)
          .where('category', isEqualTo: category.toFirestoreValue())
          .count()
          .get();
      counts[category] = snapshot.count ?? 0;
    }

    return counts;
  }
}
