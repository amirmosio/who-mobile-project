import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:who_mobile_project/general/constants/comment_categories.dart';
import 'package:who_mobile_project/general/models/comments/comment.dart';
import 'package:who_mobile_project/providers/base/base_api_notifier.dart';
import 'package:who_mobile_project/providers/base/base_api_state.dart';
import 'package:who_mobile_project/providers/comments/comments_repository_provider.dart';
import 'package:who_mobile_project/repository/comments/comments_repository.dart';
import 'package:who_mobile_project/repository/repo_state.dart';

part 'comments_provider.g.dart';

/// Stream provider for comments list with optional category filter
/// Uses Firestore real-time updates for live comment feed
/// Only admins should access this provider
///
/// Example usage:
/// ```dart
/// // All comments
/// final commentsAsync = ref.watch(commentsStreamProvider(null));
///
/// // Filtered by category
/// final installComments = ref.watch(
///   commentsStreamProvider(CommentCategory.install),
/// );
///
/// commentsAsync.when(
///   data: (comments) => ListView.builder(...),
///   loading: () => CircularProgressIndicator(),
///   error: (e, _) => ErrorWidget(e),
/// );
/// ```
@Riverpod(keepAlive: true)
Stream<List<Comment>> commentsStream(Ref ref, CommentCategory? category) {
  final repository = ref.watch(commentsRepositoryProvider);
  return repository.getCommentsStream(category: category);
}

/// Provider for the currently selected category filter
/// null means "all categories"
@riverpod
class SelectedCommentCategory extends _$SelectedCommentCategory {
  @override
  CommentCategory? build() {
    return null; // Default: show all comments
  }

  void selectCategory(CommentCategory? category) {
    state = category;
  }
}

/// Filtered comments based on selected category
/// Automatically updates when category filter changes
@riverpod
AsyncValue<List<Comment>> filteredComments(Ref ref) {
  final selectedCategory = ref.watch(selectedCommentCategoryProvider);
  return ref.watch(commentsStreamProvider(selectedCategory));
}

/// Provider for creating new comments
/// Uses BaseApiNotifier pattern for consistent error handling
@Riverpod(keepAlive: true)
class CreateComment extends _$CreateComment
    implements BaseApiNotifier<BaseApiState> {
  late CommentsRepository _repository;

  @override
  BaseApiState build() {
    _repository = ref.watch(commentsRepositoryProvider);
    return const BaseApiInitial();
  }

  /// Create a new comment
  /// Returns the created comment's ID on success
  Future<String?> createComment({
    required String text,
    required CommentCategory category,
    required String authorId,
    required String authorName,
    required String authorEmail,
  }) async {
    state = const BaseApiLoading();

    final response = await _repository.createComment(
      text: text,
      category: category,
      authorId: authorId,
      authorName: authorName,
      authorEmail: authorEmail,
    );

    if (response is SuccessState) {
      final commentId = response.data as String;
      state = BaseApiSuccess(commentId);
      return commentId;
    } else if (response is ErrorState) {
      state = BaseApiError(response.exception);
      return null;
    }
    return null;
  }

  /// Reset state to initial
  void reset() {
    state = const BaseApiInitial();
  }

  @override
  bool get hasError => state is BaseApiError;

  @override
  bool get isLoading => state is BaseApiLoading;

  @override
  RepositoryException? get exception =>
      state is BaseApiError ? (state as BaseApiError).exception : null;

  @override
  Future<K?> executeApiCallAndSetState<K>(
    Future<RepositoryState> Function() apiCall, {
    String? loadingMessage,
    String? successMessage,
  }) {
    throw UnimplementedError('Use createComment() instead');
  }

  @override
  Future<bool> executeOperationAndSetState(
    Future<RepositoryState> Function() operation, {
    String? loadingMessage,
    String? successMessage,
    String? errorMessage,
    void Function()? onSuccess,
  }) {
    throw UnimplementedError('Use createComment() instead');
  }

  @override
  String getCustomErrorMessage(
    RepositoryException exception,
    String defaultMessage,
  ) {
    return defaultMessage;
  }
}

/// Provider for deleting comments
/// Uses BaseApiNotifier pattern for consistent error handling
@Riverpod(keepAlive: true)
class DeleteComment extends _$DeleteComment
    implements BaseApiNotifier<BaseApiState> {
  late CommentsRepository _repository;

  @override
  BaseApiState build() {
    _repository = ref.watch(commentsRepositoryProvider);
    return const BaseApiInitial();
  }

  /// Delete a comment by ID (soft delete)
  Future<bool> deleteComment(String commentId) async {
    state = const BaseApiLoading();

    final response = await _repository.deleteComment(commentId);

    if (response is SuccessState) {
      state = const BaseApiOperationSuccess(true, 'Comment deleted');
      return true;
    } else if (response is ErrorState) {
      state = BaseApiError(response.exception);
      return false;
    }
    return false;
  }

  /// Reset state to initial
  void reset() {
    state = const BaseApiInitial();
  }

  @override
  bool get hasError => state is BaseApiError;

  @override
  bool get isLoading => state is BaseApiLoading;

  @override
  RepositoryException? get exception =>
      state is BaseApiError ? (state as BaseApiError).exception : null;

  @override
  Future<K?> executeApiCallAndSetState<K>(
    Future<RepositoryState> Function() apiCall, {
    String? loadingMessage,
    String? successMessage,
  }) {
    throw UnimplementedError('Use deleteComment() instead');
  }

  @override
  Future<bool> executeOperationAndSetState(
    Future<RepositoryState> Function() operation, {
    String? loadingMessage,
    String? successMessage,
    String? errorMessage,
    void Function()? onSuccess,
  }) {
    throw UnimplementedError('Use deleteComment() instead');
  }

  @override
  String getCustomErrorMessage(
    RepositoryException exception,
    String defaultMessage,
  ) {
    return defaultMessage;
  }
}

/// Provider for comment count by category
@riverpod
int commentCountByCategory(Ref ref, CommentCategory category) {
  final commentsAsync = ref.watch(commentsStreamProvider(category));
  return commentsAsync.when(
    data: (comments) => comments.length,
    loading: () => 0,
    error: (_, __) => 0,
  );
}

/// Provider for total comment count
@riverpod
int totalCommentCount(Ref ref) {
  final commentsAsync = ref.watch(commentsStreamProvider(null));
  return commentsAsync.when(
    data: (comments) => comments.length,
    loading: () => 0,
    error: (_, __) => 0,
  );
}
