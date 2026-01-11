import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:who_mobile_project/general/constants/comment_categories.dart';
import 'package:who_mobile_project/general/models/comments/comment.dart';

/// Firebase Comments Service with caching
/// Handles all Firestore operations for comments with in-memory cache
/// Registered as singleton via FirebaseModule in DI
class FirebaseCommentsService {
  final FirebaseFirestore _firestore;

  /// Firestore collection name for comments
  static const String _commentsCollection = 'comments';

  /// Maximum characters for comment text
  static const int maxCommentLength = 1000;

  /// Cache TTL (time-to-live) in seconds
  static const int cacheTtlSeconds = 300; // 5 minutes

  /// In-memory cache for comments by category (null = all)
  final Map<CommentCategory?, _CacheEntry<List<Comment>>> _commentsCache = {};

  /// Cache for individual comments by ID
  final Map<String, _CacheEntry<Comment>> _singleCommentCache = {};

  /// Cache for comment counts
  _CacheEntry<Map<CommentCategory, int>>? _countsCache;

  /// Stream controllers for cached streams (to avoid multiple listeners)
  final Map<CommentCategory?, StreamController<List<Comment>>>
      _streamControllers = {};

  /// Active stream subscriptions
  final Map<CommentCategory?, StreamSubscription<QuerySnapshot>>
      _activeSubscriptions = {};

  FirebaseCommentsService() : _firestore = FirebaseFirestore.instance;

  /// Get stream of comments filtered by category (optional)
  /// Returns non-deleted comments ordered by creation date (newest first)
  /// Uses cached stream to prevent multiple Firestore listeners
  Stream<List<Comment>> getCommentsStream({CommentCategory? category}) {
    // Check if we already have an active stream for this category
    if (_streamControllers.containsKey(category) &&
        !_streamControllers[category]!.isClosed) {
      // Return existing stream, but also emit cached data immediately if available
      final cached = _commentsCache[category];
      if (cached != null && !cached.isExpired) {
        // Add cached data to stream asynchronously
        Future.microtask(() {
          if (!_streamControllers[category]!.isClosed) {
            _streamControllers[category]!.add(cached.data);
          }
        });
      }
      return _streamControllers[category]!.stream;
    }

    // Create new stream controller
    final controller = StreamController<List<Comment>>.broadcast(
      onCancel: () {
        // Clean up when no more listeners
        _activeSubscriptions[category]?.cancel();
        _activeSubscriptions.remove(category);
        _streamControllers[category]?.close();
        _streamControllers.remove(category);
      },
    );
    _streamControllers[category] = controller;

    // Emit cached data immediately if available and not expired
    final cached = _commentsCache[category];
    if (cached != null && !cached.isExpired) {
      controller.add(cached.data);
    }

    // Set up Firestore listener
    Query<Map<String, dynamic>> query = _firestore
        .collection(_commentsCollection)
        .where('isDeleted', isEqualTo: false);

    if (category != null) {
      query = query.where('category', isEqualTo: category.toFirestoreValue());
    }

    final subscription = query
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snapshot) {
      final comments =
          snapshot.docs.map((doc) => Comment.fromFirestore(doc)).toList();

      // Update cache
      _commentsCache[category] = _CacheEntry(comments);

      // Also update individual comment cache
      for (final comment in comments) {
        _singleCommentCache[comment.id] = _CacheEntry(comment);
      }

      // Invalidate counts cache when comments change
      _countsCache = null;

      // Emit to stream
      if (!controller.isClosed) {
        controller.add(comments);
      }
    }, onError: (error) {
      if (!controller.isClosed) {
        controller.addError(error);
      }
    });

    _activeSubscriptions[category] = subscription;

    return controller.stream;
  }

  /// Get all comments once (not a stream) with caching
  /// Optionally filter by category
  Future<List<Comment>> getComments({CommentCategory? category}) async {
    // Check cache first
    final cached = _commentsCache[category];
    if (cached != null && !cached.isExpired) {
      return cached.data;
    }

    // Fetch from Firestore
    Query<Map<String, dynamic>> query = _firestore
        .collection(_commentsCollection)
        .where('isDeleted', isEqualTo: false);

    if (category != null) {
      query = query.where('category', isEqualTo: category.toFirestoreValue());
    }

    final snapshot = await query.orderBy('createdAt', descending: true).get();
    final comments =
        snapshot.docs.map((doc) => Comment.fromFirestore(doc)).toList();

    // Update cache
    _commentsCache[category] = _CacheEntry(comments);

    // Also update individual comment cache
    for (final comment in comments) {
      _singleCommentCache[comment.id] = _CacheEntry(comment);
    }

    return comments;
  }

  /// Create a new comment
  /// Returns the created comment's document ID
  /// Invalidates relevant caches
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

    // Invalidate caches for this category and all comments
    _invalidateCacheForCategory(category);

    return docRef.id;
  }

  /// Update an existing comment's text and/or category
  /// Invalidates relevant caches
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

    // Get old comment to know which category cache to invalidate
    final oldComment = await getComment(commentId);

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

    // Invalidate caches
    _singleCommentCache.remove(commentId);
    if (oldComment != null) {
      _invalidateCacheForCategory(oldComment.category);
    }
    if (category != null && category != oldComment?.category) {
      _invalidateCacheForCategory(category);
    }
  }

  /// Soft delete a comment (set isDeleted to true)
  /// Invalidates relevant caches
  Future<void> deleteComment(String commentId) async {
    // Get comment to know which category cache to invalidate
    final comment = await getComment(commentId);

    await _firestore.collection(_commentsCollection).doc(commentId).update({
      'isDeleted': true,
      'updatedAt': FieldValue.serverTimestamp(),
    });

    // Invalidate caches
    _singleCommentCache.remove(commentId);
    if (comment != null) {
      _invalidateCacheForCategory(comment.category);
    }
  }

  /// Permanently delete a comment document
  /// Use with caution - prefer soft delete for audit trail
  Future<void> permanentlyDeleteComment(String commentId) async {
    // Get comment to know which category cache to invalidate
    final comment = await getComment(commentId);

    await _firestore.collection(_commentsCollection).doc(commentId).delete();

    // Invalidate caches
    _singleCommentCache.remove(commentId);
    if (comment != null) {
      _invalidateCacheForCategory(comment.category);
    }
  }

  /// Get a single comment by ID with caching
  Future<Comment?> getComment(String commentId) async {
    // Check cache first
    final cached = _singleCommentCache[commentId];
    if (cached != null && !cached.isExpired) {
      return cached.data;
    }

    final doc =
        await _firestore.collection(_commentsCollection).doc(commentId).get();
    if (!doc.exists) return null;

    final comment = Comment.fromFirestore(doc);
    _singleCommentCache[commentId] = _CacheEntry(comment);
    return comment;
  }

  /// Get comment count by category with caching
  Future<Map<CommentCategory, int>> getCommentCountsByCategory() async {
    // Check cache first
    if (_countsCache != null && !_countsCache!.isExpired) {
      return _countsCache!.data;
    }

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

    _countsCache = _CacheEntry(counts);
    return counts;
  }

  /// Invalidate cache for a specific category
  void _invalidateCacheForCategory(CommentCategory category) {
    _commentsCache.remove(category);
    _commentsCache.remove(null); // Also invalidate "all" cache
    _countsCache = null;
  }

  /// Clear all caches (useful for logout or force refresh)
  void clearAllCaches() {
    _commentsCache.clear();
    _singleCommentCache.clear();
    _countsCache = null;
  }

  /// Force refresh comments for a category
  /// Clears cache and returns fresh data
  Future<List<Comment>> refreshComments({CommentCategory? category}) async {
    _commentsCache.remove(category);
    if (category != null) {
      _commentsCache.remove(null); // Also clear "all" cache
    }
    return getComments(category: category);
  }

  /// Check if cache is valid for a category
  bool isCacheValid({CommentCategory? category}) {
    final cached = _commentsCache[category];
    return cached != null && !cached.isExpired;
  }

  /// Get cached comments without hitting Firestore
  /// Returns null if cache is expired or missing
  List<Comment>? getCachedComments({CommentCategory? category}) {
    final cached = _commentsCache[category];
    if (cached != null && !cached.isExpired) {
      return cached.data;
    }
    return null;
  }

  /// Dispose all stream subscriptions
  void dispose() {
    for (final subscription in _activeSubscriptions.values) {
      subscription.cancel();
    }
    _activeSubscriptions.clear();

    for (final controller in _streamControllers.values) {
      controller.close();
    }
    _streamControllers.clear();
  }
}

/// Cache entry with timestamp for TTL checking
class _CacheEntry<T> {
  final T data;
  final DateTime timestamp;

  _CacheEntry(this.data) : timestamp = DateTime.now();

  bool get isExpired {
    final age = DateTime.now().difference(timestamp).inSeconds;
    return age > FirebaseCommentsService.cacheTtlSeconds;
  }
}
