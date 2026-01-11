import 'package:who_mobile_project/general/constants/comment_categories.dart';
import 'package:who_mobile_project/general/models/comments/comment.dart';
import 'package:who_mobile_project/repository/repo_state.dart';
import 'package:who_mobile_project/services/firebase/firebase_comments_service.dart';

/// Repository for comments operations
/// Provides consistent error handling and returns RepositoryState
/// Registered via FirebaseModule in DI
class CommentsRepository {
  final FirebaseCommentsService _commentsService;

  CommentsRepository(this._commentsService);

  /// Get stream of comments filtered by category (optional)
  /// Returns non-deleted comments ordered by creation date (newest first)
  Stream<List<Comment>> getCommentsStream({CommentCategory? category}) {
    return _commentsService.getCommentsStream(category: category);
  }

  /// Get all comments once
  /// Optionally filter by category
  Future<RepositoryState> getComments({CommentCategory? category}) async {
    try {
      final comments = await _commentsService.getComments(category: category);
      return SuccessState(comments, null);
    } catch (e) {
      return ErrorState(RepositoryException(
        message: 'Failed to load comments.',
        error: null,
      ));
    }
  }

  /// Create a new comment
  /// Returns the created comment's document ID on success
  Future<RepositoryState> createComment({
    required String text,
    required CommentCategory category,
    required String authorId,
    required String authorName,
    required String authorEmail,
  }) async {
    try {
      // Validate text
      if (text.trim().isEmpty) {
        return ErrorState(RepositoryException(
          message: 'Comment text cannot be empty.',
          error: null,
        ));
      }

      if (text.length > FirebaseCommentsService.maxCommentLength) {
        return ErrorState(RepositoryException(
          message:
              'Comment exceeds maximum length of ${FirebaseCommentsService.maxCommentLength} characters.',
          error: null,
        ));
      }

      final commentId = await _commentsService.createComment(
        text: text,
        category: category,
        authorId: authorId,
        authorName: authorName,
        authorEmail: authorEmail,
      );

      return SuccessState(commentId, null);
    } on ArgumentError catch (e) {
      return ErrorState(RepositoryException(
        message: e.message,
        error: null,
      ));
    } catch (e) {
      return ErrorState(RepositoryException(
        message: 'Failed to create comment. Please try again.',
        error: null,
      ));
    }
  }

  /// Update an existing comment's text and/or category
  Future<RepositoryState> updateComment({
    required String commentId,
    String? text,
    CommentCategory? category,
  }) async {
    try {
      if (text != null && text.trim().isEmpty) {
        return ErrorState(RepositoryException(
          message: 'Comment text cannot be empty.',
          error: null,
        ));
      }

      if (text != null && text.length > FirebaseCommentsService.maxCommentLength) {
        return ErrorState(RepositoryException(
          message:
              'Comment exceeds maximum length of ${FirebaseCommentsService.maxCommentLength} characters.',
          error: null,
        ));
      }

      await _commentsService.updateComment(
        commentId: commentId,
        text: text,
        category: category,
      );

      return SuccessState(true, null);
    } on ArgumentError catch (e) {
      return ErrorState(RepositoryException(
        message: e.message,
        error: null,
      ));
    } catch (e) {
      return ErrorState(RepositoryException(
        message: 'Failed to update comment. Please try again.',
        error: null,
      ));
    }
  }

  /// Soft delete a comment
  Future<RepositoryState> deleteComment(String commentId) async {
    try {
      await _commentsService.deleteComment(commentId);
      return SuccessState(true, null);
    } catch (e) {
      return ErrorState(RepositoryException(
        message: 'Failed to delete comment.',
        error: null,
      ));
    }
  }

  /// Get a single comment by ID
  Future<RepositoryState> getComment(String commentId) async {
    try {
      final comment = await _commentsService.getComment(commentId);
      if (comment == null) {
        return ErrorState(RepositoryException(
          message: 'Comment not found.',
          error: null,
        ));
      }
      return SuccessState(comment, null);
    } catch (e) {
      return ErrorState(RepositoryException(
        message: 'Failed to load comment.',
        error: null,
      ));
    }
  }

  /// Get comment count by category
  Future<RepositoryState> getCommentCountsByCategory() async {
    try {
      final counts = await _commentsService.getCommentCountsByCategory();
      return SuccessState(counts, null);
    } catch (e) {
      return ErrorState(RepositoryException(
        message: 'Failed to load comment counts.',
        error: null,
      ));
    }
  }
}
