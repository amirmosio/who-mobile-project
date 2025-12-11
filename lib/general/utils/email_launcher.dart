import 'package:flutter/material.dart';
import 'package:who_mobile_project/general/services/device/device_service.dart';
import 'package:who_mobile_project/generated/i18n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

/// Utility class for launching email client with pre-filled support email
class EmailLauncher {
  EmailLauncher._();

  /// Launch email client with platform-specific subject line
  ///
  /// Opens the device's default email client with:
  /// - Recipient: quizpatente@guidaevai.com
  /// - Subject: Platform-specific subject line (iOS, Android, or generic)
  ///
  /// Falls back to a simpler mailto URL if the full URL fails
  static Future<void> launchSupportEmail(BuildContext context) async {
    try {
      final l10n = AppLocalizations.of(context)!;
      final isIOS = DeviceUtils.getInstance().isIos;
      final isAndroid = DeviceUtils.getInstance().isAndroid;

      String subject;
      if (isIOS) {
        subject = l10n.email_assistance_subject_ios;
      } else if (isAndroid) {
        subject = l10n.email_assistance_subject_android;
      } else {
        subject = l10n.email_assistance_subject_generic;
      }

      final Uri emailUri = Uri(
        scheme: 'mailto',
        path: 'quizpatente@guidaevai.com',
        queryParameters: {'subject': subject},
      );

      debugPrint('Attempting to launch email: $emailUri');

      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri, mode: LaunchMode.externalApplication);
        debugPrint('Email launched successfully');
      } else {
        debugPrint('Cannot launch email client');
        // Fallback: try a simpler mailto URL
        final simpleUri = Uri.parse('mailto:quizpatente@guidaevai.com');
        if (await canLaunchUrl(simpleUri)) {
          await launchUrl(simpleUri, mode: LaunchMode.externalApplication);
          debugPrint('Fallback email launched');
        }
      }
    } catch (e) {
      debugPrint('Error launching email: $e');
    }
  }
}
