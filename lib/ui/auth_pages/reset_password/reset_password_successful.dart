import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:who_mobile_project/app_core/theme/colors.dart';
import 'package:who_mobile_project/generated/i18n/app_localizations.dart';
import 'package:who_mobile_project/routing_config/routes.dart';

class ResetPasswordSuccessfulConfirmationPage extends StatelessWidget {
  const ResetPasswordSuccessfulConfirmationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: GVColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              // Header section with logo
              Container(
                width: double.infinity,
                height: 220,
                color: GVColors.lightGreyBackground,
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
                        return Image.asset(
                          "assets/images/figma_designs/login_illustration.png",
                          height: 60,
                          width: 207,
                          fit: BoxFit.contain,
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 60),

              // Success content
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Success icon
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: GVColors.greenSuccess,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.check, color: GVColors.white, size: 50),
                    ),

                    const SizedBox(height: 32),

                    // Success title
                    Text(
                      AppLocalizations.of(
                        context,
                      )!.password_reset_success_title,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 24,
                        letterSpacing: -1.0982,
                        color: GVColors.black,
                        height: 1.2,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 16),

                    // Success subtitle
                    Text(
                      AppLocalizations.of(
                        context,
                      )!.password_reset_success_subtitle,
                      style: TextStyle(
                        fontSize: 16,
                        color: GVColors.darkGreyText,
                        letterSpacing: -0.4771,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 60),

                    // Go to login button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: GVColors.guidaEvaiOrange,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          context.go(YRRoutes.login);
                        },
                        child: Text(
                          AppLocalizations.of(context)!.go_to_login,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: GVColors.white,
                            height: 1.2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
