import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:who_mobile_project/app_core/theme/colors.dart';
import 'package:who_mobile_project/app_core/theme/text_styles/app_text_styles.dart';
import 'package:who_mobile_project/generated/i18n/app_localizations.dart';

/// Helper function to check if license type name is "A, B" and navigate or show dialog
Future<void> checkLicenseTypeAndNavigate(
  BuildContext context,
  WidgetRef ref,
  String route, {
  String? featureName,
  String logPrefix = '📚',
}) async {
  // TODO: Removed - License type checking no longer available
  // Always show "coming soon" dialog since we can't check license type
  final feature = featureName ?? 'Feature';
  debugPrint('$logPrefix $feature tapped - showing coming soon dialog');
  if (context.mounted) {
    showFeatureComingSoonDialog(context);
  }
}

/// Shows a dialog indicating that the feature is coming soon
void showFeatureComingSoonDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    barrierColor: GVColors.black.withValues(alpha: 0.5),
    builder: (BuildContext dialogContext) {
      return Dialog(
        backgroundColor: GVColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.75),
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: GVColors.guidaEvaiOrange.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.info_outline,
                  size: 32,
                  color: GVColors.guidaEvaiOrange,
                ),
              ),
              const SizedBox(height: 20),
              // Message
              Text(
                AppLocalizations.of(context)!.feature_coming_soon,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyTextStrong.copyWith(
                  color: GVColors.black,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 24),
              // OK Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: GVColors.guidaEvaiOrange,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.75),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.ok,
                    style: AppTextStyles.buttonPrimary.copyWith(
                      color: GVColors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
