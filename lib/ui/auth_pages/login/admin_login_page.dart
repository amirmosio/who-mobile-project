import 'package:flutter/material.dart';
import 'package:who_mobile_project/generated/i18n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:who_mobile_project/app_core/theme/colors.dart';
import 'package:who_mobile_project/app_core/theme/text_styles/app_text_styles.dart';
import 'package:who_mobile_project/general/widgets/formfields/my_text_formfield.dart';
import 'package:who_mobile_project/providers/auth/auth_provider.dart';
import 'package:who_mobile_project/providers/base/base_api_state.dart';
import 'package:who_mobile_project/routing_config/routes.dart';
import 'package:who_mobile_project/ui/base_template/gv_secondary_top_bar_header.dart';

/// Admin login page for WHO Mobile app
/// Only users with admin or super admin roles can login here
class AdminLoginPage extends ConsumerStatefulWidget {
  const AdminLoginPage({super.key});

  @override
  ConsumerState<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends ConsumerState<AdminLoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final user = await ref.read(authProvider.notifier).signIn(
          _emailController.text.trim(),
          _passwordController.text,
        );

    if (user != null && mounted) {
      // Navigate based on role
      if (user.isSuperAdmin) {
        context.go(YRRoutes.adminPanel);
      } else {
        context.go(YRRoutes.dashBoard);
      }
    }
  }

  Future<void> _handleGoogleSignIn() async {
    final user = await ref.read(authProvider.notifier).signInWithGoogle();

    if (user != null && mounted) {
      // Navigate based on role
      if (user.isSuperAdmin) {
        context.go(YRRoutes.adminPanel);
      } else {
        context.go(YRRoutes.dashBoard);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    // Listen for errors and show snackbar
    ref.listen(authProvider, (previous, next) {
      if (next is BaseApiError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              next.exception.message ?? 'Login failed. Please try again.',
              style: AppTextStyles.smallText.copyWith(color: GVColors.white),
            ),
            backgroundColor: GVColors.redError,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    });

    return GVSecondaryTopBarHeader(
      title: 'Admin Login',
      includeScrollable: true,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 32),

            // WHO Logo/Branding
            _buildHeader(),

            const SizedBox(height: 48),

            // Email field
            MyTextFormField(
              controller: _emailController,
              hintText: 'Enter your email',
              labelText: 'Email',
              isMandatoryStartSign: true,
              keyboardType: TextInputType.emailAddress,
              validator: _validateEmail,
            ),

            const SizedBox(height: 20),

            // Password field
            MyTextFormField(
              controller: _passwordController,
              hintText: 'Enter your password',
              labelText: 'Password',
              isMandatoryStartSign: true,
              obscureText: true,
              validator: _validatePassword,
            ),

            const SizedBox(height: 32),

            // Login button
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: authState is BaseApiLoading ? null : _handleLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: GVColors.purpleAccent,
                  foregroundColor: GVColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(60),
                  ),
                  disabledBackgroundColor: GVColors.purpleAccent.withValues(alpha: 0.6),
                ),
                child: authState is BaseApiLoading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation<Color>(GVColors.white),
                        ),
                      )
                    : Text(
                        'Login',
                        style: AppTextStyles.buttonPrimary,
                      ),
              ),
            ),

            const SizedBox(height: 16),

            // Continue as Guest button
            TextButton(
              onPressed: () => context.go(YRRoutes.dashBoard),
              child: Text(
                'Continue as Guest',
                style: AppTextStyles.bodyText.copyWith(
                  color: GVColors.purpleAccent,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Divider with "Or continue with"
            _buildDivider(),

            const SizedBox(height: 24),

            // Google Sign-In button
            _buildGoogleSignInButton(authState),

            const SizedBox(height: 32),

            // Info text
            _buildInfoText(),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        // WHO Icon or Logo placeholder
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: GVColors.purpleAccent.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(
            Icons.admin_panel_settings,
            size: 48,
            color: GVColors.purpleAccent,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'WHO Admin Portal',
          style: AppTextStyles.headingH1.copyWith(
            color: GVColors.black,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Sign in to access admin features',
          style: AppTextStyles.bodyText.copyWith(
            color: GVColors.darkGrey,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildInfoText() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: GVColors.blueInfo.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: GVColors.blueInfo.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline,
            size: 20,
            color: GVColors.blueInfo,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'This login is for administrators only. If you are a regular user, tap "Continue as Guest" to browse the app.',
              style: AppTextStyles.smallText.copyWith(
                color: GVColors.blueInfo,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        Expanded(child: Divider(color: GVColors.lightBorderGrey)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            l10n.or_continue_with,
            style: AppTextStyles.smallText.copyWith(color: GVColors.darkGrey),
          ),
        ),
        Expanded(child: Divider(color: GVColors.lightBorderGrey)),
      ],
    );
  }

  Widget _buildGoogleSignInButton(BaseApiState authState) {
    final l10n = AppLocalizations.of(context)!;
    return SizedBox(
      height: 50,
      child: OutlinedButton.icon(
        onPressed: authState is BaseApiLoading ? null : _handleGoogleSignIn,
        icon: Icon(
          Icons.g_mobiledata,
          size: 28,
          color: authState is BaseApiLoading ? GVColors.darkGrey : GVColors.black,
        ),
        label: Text(
          l10n.sign_in_with_google,
          style: AppTextStyles.bodyText.copyWith(
            color: authState is BaseApiLoading ? GVColors.darkGrey : GVColors.black,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: GVColors.lightBorderGrey),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(60),
          ),
        ),
      ),
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your email';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }
}
