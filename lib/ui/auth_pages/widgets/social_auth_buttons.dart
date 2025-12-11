import 'package:flutter/material.dart';
import 'package:who_mobile_project/app_core/theme/colors.dart';
import 'package:who_mobile_project/generated/i18n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SocialAuthButtons extends StatelessWidget {
  final VoidCallback? onGooglePressed;
  final VoidCallback? onApplePressed;
  final VoidCallback? onFacebookPressed;
  final bool showGoogleButton;
  final bool showAppleButton;
  final bool showFacebookButton;
  final bool isLoading;
  final bool isGoogleLoading;
  final bool isAppleLoading;
  final bool isFacebookLoading;

  const SocialAuthButtons({
    super.key,
    this.onGooglePressed,
    this.onApplePressed,
    this.onFacebookPressed,
    this.showGoogleButton = true,
    this.showAppleButton = true,
    this.showFacebookButton = true,
    this.isLoading = false,
    this.isGoogleLoading = false,
    this.isAppleLoading = false,
    this.isFacebookLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (!showGoogleButton && !showAppleButton && !showFacebookButton) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        // Apple Sign In button (iOS only)
        if (showAppleButton) ...[
          _SocialAuthButton(
            onPressed:
                (isLoading ||
                    isAppleLoading ||
                    isGoogleLoading ||
                    isFacebookLoading)
                ? null
                : onApplePressed,
            icon: FontAwesomeIcons.apple,
            text: AppLocalizations.of(context)!.continue_with_apple,
            backgroundColor: GVColors.black,
            textColor: GVColors.white,
            iconColor: GVColors.white,
            isLoading: isAppleLoading,
          ),
          const SizedBox(height: 12),
        ],

        // Google Sign In button
        if (showGoogleButton) ...[
          _SocialAuthButton(
            onPressed:
                (isLoading ||
                    isAppleLoading ||
                    isGoogleLoading ||
                    isFacebookLoading)
                ? null
                : onGooglePressed,
            icon: FontAwesomeIcons.google,
            text: AppLocalizations.of(context)!.continue_with_google,
            backgroundColor: GVColors.white,
            textColor: GVColors.black,
            iconColor: const Color(0xFF4285F4),
            borderColor: GVColors.borderGrey,
            isLoading: isGoogleLoading,
          ),
          const SizedBox(height: 12),
        ],

        // Facebook Sign In button
        if (showFacebookButton) ...[
          _SocialAuthButton(
            onPressed:
                (isLoading ||
                    isAppleLoading ||
                    isGoogleLoading ||
                    isFacebookLoading)
                ? null
                : onFacebookPressed,
            icon: FontAwesomeIcons.facebook,
            text: AppLocalizations.of(context)!.continue_with_facebook,
            backgroundColor: const Color(0xFF1877F2),
            textColor: GVColors.white,
            iconColor: GVColors.white,
            isLoading: isFacebookLoading,
          ),
        ],
      ],
    );
  }
}

class _SocialAuthButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final Color iconColor;
  final Color? borderColor;
  final bool isLoading;

  const _SocialAuthButton({
    required this.onPressed,
    required this.icon,
    required this.text,
    required this.backgroundColor,
    required this.textColor,
    required this.iconColor,
    this.borderColor,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: borderColor != null
                ? BorderSide(color: borderColor!, width: 1)
                : BorderSide.none,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        child: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(textColor),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FaIcon(icon, size: 20, color: iconColor),
                  const SizedBox(width: 12),
                  Text(
                    text,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: textColor,
                      letterSpacing: -0.4771,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
