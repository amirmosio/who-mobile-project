import 'package:flutter/material.dart';
import 'package:who_mobile_project/app_core/theme/colors.dart';
import 'package:who_mobile_project/generated/i18n/app_localizations.dart';
import 'package:who_mobile_project/general/widgets/my_progress_bar.dart';

class AuthProgressHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final int currentStep;
  final int totalSteps;
  final Animation<double> progressAnimation;
  final double height;
  final String? stepText; // Optional custom step text

  const AuthProgressHeader({
    super.key,
    required this.title,
    this.subtitle,
    required this.currentStep,
    required this.totalSteps,
    required this.progressAnimation,
    this.height = 220,
    this.stepText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      height: subtitle != null
          ? height + 40
          : height, // Extra height for subtitle
      color: GVColors.lightGreyBackground,
      child: Column(
        children: [
          // Logo and title section
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Image.asset(
                  "assets/images/figma_designs/logo_quiz_patente_ufficiale_guida_e_vai_logo_63_100_1024x224_2_1.png",
                  height: 60,
                  width: 207,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    // Fallback if the asset doesn't exist
                    return Image.asset(
                      "assets/images/figma_designs/login_illustration.png",
                      height: 60,
                      width: 207,
                      fit: BoxFit.contain,
                    );
                  },
                ),
                const SizedBox(height: 25),
                // Title
                Text(
                  title,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 25,
                    letterSpacing: -1.0982,
                    color: GVColors.black,
                    height: 1.2,
                  ),
                ),
                // Subtitle if provided
                if (subtitle != null) ...[
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      subtitle!,
                      style: TextStyle(
                        fontSize: 14,
                        color: GVColors.darkGreyText,
                        letterSpacing: -0.4771,
                        height: 1.3,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ],
            ),
          ),
          // Progress indicator section
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Step indicator text
                Text(
                  stepText ?? _getDefaultStepText(context),
                  style: TextStyle(
                    fontSize: 12,
                    color: GVColors.lightGreyHint,
                    letterSpacing: -0.4771,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 7),
                // Animated progress bar using reusable widget
                MyAuthProgressBar(
                  animation: progressAnimation,
                  progressColor: GVColors.orange,
                  backgroundColor: GVColors.borderGrey,
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getDefaultStepText(BuildContext context) {
    if (totalSteps == 3) {
      switch (currentStep) {
        case 1:
          return AppLocalizations.of(context)!.step_1_of_3;
        case 2:
          return AppLocalizations.of(context)!.step_2_of_3;
        case 3:
          return AppLocalizations.of(context)!.step_3_of_3;
        default:
          return 'Passo $currentStep di $totalSteps';
      }
    }
    return 'Passo $currentStep di $totalSteps';
  }
}
