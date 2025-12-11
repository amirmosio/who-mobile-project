import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:who_mobile_project/services/navigation_tracker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FeedbackService {
  static final FeedbackService _instance = FeedbackService._internal();
  factory FeedbackService() => _instance;
  FeedbackService._internal();

  Future<bool> submitFeedback({
    required String comments,
    required String level,
    required WidgetRef ref,
    BuildContext? context,
    bool includeScreenshot = true,
  }) async {
    try {
      final goRouterInfo = GoRouterTracker().getGoRouterInfo();

      // TODO: Removed - User profile no longer available
      String userName = 'Unknown';
      String userEmail = '';

      Uint8List? screenshotBytes;
      if (includeScreenshot && context != null) {
        screenshotBytes = await _captureScreenshot(context);
      }

      await Sentry.captureFeedback(
        SentryFeedback(
          message: 'User Feedback: $comments',
          name: userName,
          contactEmail: userEmail,
        ),
        withScope: (scope) {
          scope.setTag('feedback_type', level);
          scope.setTag('has_screenshot', (screenshotBytes != null).toString());
          scope.setTag('timestamp', DateTime.now().toIso8601String());
          if (goRouterInfo.isNotEmpty) {
            scope.setTag('navigation_info', goRouterInfo.toString());
          }

          // Set user info
          scope.setUser(SentryUser(email: userEmail, username: userName));

          // Add feedback details context
          scope.setContexts('feedback_details', {
            'message': comments,
            'has_screenshot': (screenshotBytes != null).toString(),
          });

          // Add screenshot as attachment if available
          if (screenshotBytes != null) {
            scope.addAttachment(
              SentryAttachment.fromUint8List(
                screenshotBytes,
                'screenshot.png',
                contentType: 'image/png',
              ),
            );
          }
        },
      );

      return true;
    } catch (e, stackTrace) {
      // Log error with stack trace for debugging
      debugPrint('Error submitting feedback: $e');
      debugPrint('Stack trace: $stackTrace');
      return false;
    }
  }

  Future<Uint8List?> _captureScreenshot(BuildContext context) async {
    try {
      final RenderObject? renderObject = context.findRenderObject();
      if (renderObject is! RenderRepaintBoundary) {
        debugPrint('Widget is not a RenderRepaintBoundary');
        return null;
      }

      final ui.Image image = await renderObject.toImage(pixelRatio: 1.5);

      final ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );

      if (byteData == null) {
        debugPrint('Failed to convert image to bytes');
        return null;
      }

      return byteData.buffer.asUint8List();
    } catch (e) {
      debugPrint('Error capturing screenshot: $e');
      return null;
    }
  }
}
