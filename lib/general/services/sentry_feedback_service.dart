import 'package:sentry_flutter/sentry_flutter.dart';

/// Service for sending user feedback to Sentry
/// In local environment, only user feedback is sent (no crashes/exceptions)
/// In staging/production, full error reporting is enabled
class SentryFeedbackService {
  /// Send user feedback to Sentry
  ///
  /// [name] - User's name (optional)
  /// [contactEmail] - User's email for contact (optional)
  /// [message] - Feedback message describing what occurred
  /// [associatedEventId] - Associate feedback with a specific event ID (optional)
  static Future<SentryId> sendFeedback({
    String? name,
    String? contactEmail,
    required String message,
    SentryId? associatedEventId,
  }) async {
    final feedback = SentryFeedback(
      message: message,
      name: name,
      contactEmail: contactEmail,
      associatedEventId: associatedEventId,
    );

    return await Sentry.captureFeedback(feedback);
  }

  /// Send a custom message to Sentry (will be sent even in local environment)
  ///
  /// [message] - The message to send
  /// [level] - Severity level (info, warning, error, etc.)
  /// [tags] - Additional tags for filtering
  /// [contexts] - Additional structured context data
  static Future<SentryId> captureMessage(
    String message, {
    SentryLevel level = SentryLevel.info,
    Map<String, String>? tags,
    Map<String, dynamic>? contexts,
  }) async {
    return await Sentry.captureMessage(
      message,
      level: level,
      withScope: (scope) {
        if (tags != null) {
          tags.forEach((key, value) => scope.setTag(key, value));
        }
        if (contexts != null) {
          contexts.forEach((key, value) {
            if (value is Map<String, dynamic>) {
              scope.setContexts(key, value);
            }
          });
        }
      },
    );
  }

  /// Set user context for all future events
  ///
  /// [userId] - Unique user identifier
  /// [email] - User's email
  /// [username] - User's username
  /// [extras] - Additional user data
  static Future<void> setUser({
    String? userId,
    String? email,
    String? username,
    Map<String, dynamic>? extras,
  }) async {
    await Sentry.configureScope((scope) {
      scope.setUser(
        SentryUser(id: userId, email: email, username: username, data: extras),
      );
    });
  }

  /// Clear user context
  static Future<void> clearUser() async {
    await Sentry.configureScope((scope) => scope.setUser(null));
  }

  /// Add breadcrumb for debugging context
  ///
  /// [message] - Breadcrumb message
  /// [category] - Category (e.g., 'navigation', 'user_action', 'api')
  /// [level] - Severity level
  /// [data] - Additional data
  static void addBreadcrumb({
    required String message,
    String? category,
    SentryLevel level = SentryLevel.info,
    Map<String, dynamic>? data,
  }) {
    Sentry.addBreadcrumb(
      Breadcrumb(
        message: message,
        category: category,
        level: level,
        data: data,
        timestamp: DateTime.now().toUtc(),
      ),
    );
  }

  /// Set a custom tag for all future events
  ///
  /// [key] - Tag key
  /// [value] - Tag value
  static Future<void> setTag(String key, String value) async {
    await Sentry.configureScope((scope) => scope.setTag(key, value));
  }

  /// Set custom context data for all future events
  ///
  /// [key] - Context key
  /// [value] - Context data
  static Future<void> setContext(String key, Map<String, dynamic> value) async {
    await Sentry.configureScope((scope) => scope.setContexts(key, value));
  }
}
