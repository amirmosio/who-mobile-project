import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:who_mobile_project/general/models/live/live_session_comment.dart';
import 'package:who_mobile_project/general/models/notification/firestore_notification.dart';
import 'package:injectable/injectable.dart';

/// Service for accessing Firestore notifications
/// Matches the functionality from neithapp's FirestoreService
@singleton
class FirestoreService {
  final FirebaseFirestore _firestore;

  FirestoreService() : _firestore = FirebaseFirestore.instance {
    debugPrint('🔥 FirestoreService initialized');
  }

  /// Get real-time stream of notifications for a specific user
  /// Matches neithapp's getMyNotifications(userId: number)
  ///
  /// Returns a stream that emits updated notification lists whenever
  /// Firestore data changes (real-time updates)
  Stream<List<FirestoreNotification>> getMyNotifications(int userId) {
    debugPrint(
      '📬 Setting up Firestore notifications stream for user: $userId',
    );

    return _firestore
        .collection('notifications')
        .where('user_id', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
          final notifications = snapshot.docs.map((doc) {
            return FirestoreNotification.fromFirestore(doc.id, doc.data());
          }).toList();

          debugPrint(
            '📬 Received ${notifications.length} notifications from Firestore',
          );
          return notifications;
        })
        .handleError((error) {
          debugPrint('❌ Error in Firestore notifications stream: $error');
          return <FirestoreNotification>[];
        });
  }

  /// Get notifications as a one-time fetch (not real-time)
  Future<List<FirestoreNotification>> getMyNotificationsOnce(int userId) async {
    try {
      debugPrint('📬 Fetching notifications once for user: $userId');

      final snapshot = await _firestore
          .collection('notifications')
          .where('user_id', isEqualTo: userId)
          .orderBy('send_datetime', descending: true)
          .get();

      final notifications = snapshot.docs.map((doc) {
        return FirestoreNotification.fromFirestore(doc.id, doc.data());
      }).toList();

      debugPrint('✅ Fetched ${notifications.length} notifications');
      return notifications;
    } catch (error) {
      debugPrint('❌ Error fetching notifications: $error');
      return [];
    }
  }

  /// Mark a notification as read
  /// Matches neithapp's readNotification(notification: Notifications)
  ///
  /// Updates the 'read' field to true in Firestore
  Future<void> readNotification(String notificationId) async {
    try {
      debugPrint('✅ Marking notification as read: $notificationId');

      await _firestore.collection('notifications').doc(notificationId).update({
        'read': true,
      });

      debugPrint('✅ Notification marked as read: $notificationId');
    } catch (error) {
      debugPrint('❌ Error marking notification as read: $error');
      rethrow;
    }
  }

  /// Mark multiple notifications as read
  Future<void> readMultipleNotifications(List<String> notificationIds) async {
    try {
      debugPrint('✅ Marking ${notificationIds.length} notifications as read');

      final batch = _firestore.batch();

      for (final id in notificationIds) {
        final docRef = _firestore.collection('notifications').doc(id);
        batch.update(docRef, {'read': true});
      }

      await batch.commit();
      debugPrint('✅ Batch update completed');
    } catch (error) {
      debugPrint('❌ Error in batch update: $error');
      rethrow;
    }
  }

  /// Get count of unread notifications
  Future<int> getUnreadCount(int userId) async {
    try {
      final snapshot = await _firestore
          .collection('notifications')
          .where('user_id', isEqualTo: userId)
          .where('read', isEqualTo: false)
          .count()
          .get();

      return snapshot.count ?? 0;
    } catch (error) {
      debugPrint('❌ Error getting unread count: $error');
      return 0;
    }
  }

  /// Stream of unread notification count
  Stream<int> getUnreadCountStream(int userId) {
    return _firestore
        .collection('notifications')
        .where('user_id', isEqualTo: userId)
        .where('read', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  // =====================================================
  // Live Session Comments Methods
  // =====================================================

  /// Get real-time stream of comments for a specific live session
  /// For users: filtered by userId to show only their own comments
  /// For teachers: shows all comments
  Stream<List<LiveSessionComment>> getLiveSessionComments({
    required int liveSessionId,
    int? userId, // If null, returns all comments (for teachers)
  }) {
    debugPrint(
      '💬 Setting up live comments stream for session: $liveSessionId, userId: $userId',
    );

    var query = _firestore
        .collection('live_session_comments')
        .where('live_session_id', isEqualTo: liveSessionId);

    // If userId is provided, filter to show only that user's comments
    if (userId != null) {
      query = query.where('user_id', isEqualTo: userId);
    }

    return query
        .orderBy('timestamp', descending: false) // Oldest first (chat style)
        .snapshots()
        .map((snapshot) {
          final comments = snapshot.docs.map((doc) {
            return LiveSessionComment.fromFirestore(doc.id, doc.data());
          }).toList();

          debugPrint('💬 Received ${comments.length} comments from Firestore');
          return comments;
        })
        .handleError((error) {
          debugPrint('❌ Error in live comments stream: $error');
          return <LiveSessionComment>[];
        });
  }

  /// Get comments for a user (after live session)
  /// Shows only the user's comments with teacher replies
  Stream<List<LiveSessionComment>> getUserCommentsForLive({
    required int liveSessionId,
    required int userId,
  }) {
    debugPrint(
      '💬 Getting user comments for session: $liveSessionId, user: $userId',
    );

    return _firestore
        .collection('live_session_comments')
        .where('live_session_id', isEqualTo: liveSessionId)
        .where('user_id', isEqualTo: userId)
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map(
                (doc) => LiveSessionComment.fromFirestore(doc.id, doc.data()),
              )
              .toList();
        });
  }

  /// Get all comments for teacher (after live session)
  /// Shows all comments from all users
  Stream<List<LiveSessionComment>> getTeacherCommentsForLive({
    required int liveSessionId,
  }) {
    debugPrint(
      '👨‍🏫 Getting all comments for teacher, session: $liveSessionId',
    );

    return _firestore
        .collection('live_session_comments')
        .where('live_session_id', isEqualTo: liveSessionId)
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map(
                (doc) => LiveSessionComment.fromFirestore(doc.id, doc.data()),
              )
              .toList();
        });
  }

  /// Add a new comment during live session
  Future<void> addLiveSessionComment(LiveSessionComment comment) async {
    try {
      debugPrint('💬 Adding comment to live session: ${comment.liveSessionId}');

      await _firestore
          .collection('live_session_comments')
          .add(comment.toFirestore());

      debugPrint('✅ Comment added successfully');
    } catch (error) {
      debugPrint('❌ Error adding comment: $error');
      rethrow;
    }
  }

  /// Add teacher reply to a comment (after live session)
  Future<void> addTeacherReply({
    required String commentId,
    required String replyText,
    required String teacherName,
  }) async {
    try {
      debugPrint('👨‍🏫 Adding teacher reply to comment: $commentId');

      await _firestore.collection('live_session_comments').doc(commentId).update({
        'teacher_reply': replyText,
        'teacher_reply_timestamp': DateTime.now().millisecondsSinceEpoch,
        'teacher_name': teacherName,
        // Don't set is_read here - it should be false until user views the reply
      });

      debugPrint('✅ Teacher reply added successfully');
    } catch (error) {
      debugPrint('❌ Error adding teacher reply: $error');
      rethrow;
    }
  }

  /// Delete a comment (user's own comment only)
  Future<void> deleteLiveSessionComment(String commentId) async {
    try {
      debugPrint('🗑️ Deleting comment: $commentId');

      await _firestore
          .collection('live_session_comments')
          .doc(commentId)
          .delete();

      debugPrint('✅ Comment deleted');
    } catch (error) {
      debugPrint('❌ Error deleting comment: $error');
      rethrow;
    }
  }

  /// Get unread comments count for teacher
  Stream<int> getUnreadCommentsCount(int liveSessionId) {
    return _firestore
        .collection('live_session_comments')
        .where('live_session_id', isEqualTo: liveSessionId)
        .where('is_read', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  /// Report a comment (for moderation)
  Future<void> reportLiveComment(String commentId) async {
    try {
      await _firestore
          .collection('live_session_comments')
          .doc(commentId)
          .update({'is_reported': true});

      debugPrint('✅ Comment reported: $commentId');
    } catch (error) {
      debugPrint('❌ Error reporting comment: $error');
      rethrow;
    }
  }

  /// Mark comment as read by user (when they view teacher's reply)
  Future<void> markCommentAsReadByUser(String commentId) async {
    try {
      await _firestore
          .collection('live_session_comments')
          .doc(commentId)
          .update({'is_read': true});

      debugPrint('✅ Comment marked as read: $commentId');
    } catch (error) {
      debugPrint('❌ Error marking comment as read: $error');
      rethrow;
    }
  }

  /// Mark multiple comments as read (batch update)
  Future<void> markCommentsAsRead(List<String> commentIds) async {
    try {
      final batch = _firestore.batch();
      for (final commentId in commentIds) {
        batch.update(
          _firestore.collection('live_session_comments').doc(commentId),
          {'is_read': true},
        );
      }
      await batch.commit();
      debugPrint('✅ Marked ${commentIds.length} comments as read');
    } catch (error) {
      debugPrint('❌ Error marking comments as read: $error');
      rethrow;
    }
  }
}
