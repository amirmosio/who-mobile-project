import 'package:flutter/material.dart';
import 'package:who_mobile_project/app_core/theme/colors.dart';
import 'package:who_mobile_project/app_core/theme/text_styles/app_text_styles.dart';

/// A consistent confirmation dialog widget used throughout the app
///
/// This dialog follows the app's design system with:
/// - Customizable title color
/// - Two buttons in a row for quick action
/// - Less border radius for modern look
/// - Consistent spacing
///
/// Example usage:
/// ```dart
/// final confirmed = await showGVConfirmationDialog(
///   context: context,
///   title: 'Delete Account',
///   message: 'Are you sure you want to delete your account?',
///   cancelButtonText: 'Go Back',
///   confirmButtonText: 'Delete',
///   titleColor: YRColors.guidaEvaiOrange,
///   confirmButtonColor: GVColors.redError,
/// );
///
/// if (confirmed == true) {
///   // User confirmed
/// }
/// ```
Future<bool?> showGVConfirmationDialog({
  required BuildContext context,
  required String title,
  required String message,
  String? cancelButtonText,
  String? confirmButtonText,
  Color? titleColor,
  Color? cancelButtonColor,
  Color? confirmButtonColor,
  bool isDismissible = true,
}) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: isDismissible,
    builder: (context) => GVConfirmationDialog(
      title: title,
      message: message,
      cancelButtonText: cancelButtonText,
      confirmButtonText: confirmButtonText,
      titleColor: titleColor,
      cancelButtonColor: cancelButtonColor,
      confirmButtonColor: confirmButtonColor,
    ),
  );
}

/// The confirmation dialog widget
///
/// Prefer using [showGVConfirmationDialog] function instead of directly
/// instantiating this widget
class GVConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String? cancelButtonText;
  final String? confirmButtonText;
  final Color? titleColor;
  final Color? cancelButtonColor;
  final Color? confirmButtonColor;

  const GVConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    this.cancelButtonText,
    this.confirmButtonText,
    this.titleColor,
    this.cancelButtonColor,
    this.confirmButtonColor,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveCancelText = cancelButtonText ?? 'Annulla';
    final effectiveConfirmText = confirmButtonText ?? 'Conferma';
    final effectiveTitleColor = titleColor ?? YRColors.guidaEvaiOrange;
    final effectiveCancelColor = cancelButtonColor ?? YRColors.guidaEvaiOrange;
    final effectiveConfirmColor = confirmButtonColor ?? GVColors.redError;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      actionsPadding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
      title: Text(
        title,
        style: AppTextStyles.bodyTextStrong.copyWith(
          color: effectiveTitleColor,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
      ),
      content: Text(
        message,
        style: AppTextStyles.bodyText.copyWith(
          color: GVColors.darkTextBlack,
          fontSize: 16,
          height: 1.4,
        ),
        textAlign: TextAlign.center,
      ),
      actions: [
        Row(
          children: [
            // Cancel / Go Back button
            Expanded(
              child: SizedBox(
                height: 44,
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: effectiveCancelColor,
                    side: BorderSide(color: effectiveCancelColor, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    effectiveCancelText,
                    style: AppTextStyles.buttonPrimary.copyWith(
                      color: effectiveCancelColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Confirm button
            Expanded(
              child: SizedBox(
                height: 44,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: effectiveConfirmColor,
                    foregroundColor: GVColors.white,
                    elevation: 0,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    effectiveConfirmText,
                    style: AppTextStyles.buttonPrimary.copyWith(
                      color: GVColors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
