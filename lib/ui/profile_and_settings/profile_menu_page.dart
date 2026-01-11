import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:who_mobile_project/app_core/theme/colors.dart';
import 'package:who_mobile_project/app_core/theme/text_styles/app_text_styles.dart';
import 'package:who_mobile_project/general/constants/available_languages.dart';
import 'package:who_mobile_project/general/models/auth/app_user.dart';
import 'package:who_mobile_project/generated/i18n/app_localizations.dart';
import 'package:who_mobile_project/providers/app_locale/app_locale_provider.dart';
import 'package:who_mobile_project/providers/auth/auth_provider.dart';
import 'package:who_mobile_project/providers/auth/current_user_provider.dart';
import 'package:who_mobile_project/providers/auth/role_access_provider.dart';
import 'package:who_mobile_project/providers/base/base_api_state.dart';
import 'package:who_mobile_project/routing_config/routes.dart';
import 'package:who_mobile_project/ui/profile_and_settings/widgets/language_picker_sheet.dart';
import 'package:who_mobile_project/ui/profile_and_settings/widgets/profile_header_widget.dart';
import 'package:who_mobile_project/ui/profile_and_settings/widgets/profile_menu_item.dart';

/// Profile and Settings page
/// Displays user info, login/logout options, and admin features for super admins
class ProfileMenuPage extends ConsumerWidget {
  const ProfileMenuPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final userAsync = ref.watch(currentUserProvider);
    final isSuperAdmin = ref.watch(isSuperAdminProvider);
    final hasAdminAccess = ref.watch(hasAdminAccessProvider);

    // Listen for auth state changes
    ref.listen(authProvider, (previous, next) {
      if (next is BaseApiError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              next.exception.message ?? l10n.an_error_occurred,
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

    return Scaffold(
      backgroundColor: GVColors.white,
      appBar: AppBar(
        backgroundColor: GVColors.white,
        elevation: 0,
        title: Text(
          l10n.profile_settings_title,
          style: AppTextStyles.headingH2.copyWith(
            color: GVColors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: GVColors.lightBorderGrey,
          ),
        ),
      ),
      body: userAsync.when(
        data: (user) => _buildContent(context, ref, user, isSuperAdmin, hasAdminAccess),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _buildError(context, ref, error.toString()),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    AppUser user,
    bool isSuperAdmin,
    bool hasAdminAccess,
  ) {
    final l10n = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Profile Header - User Info
          ProfileHeaderWidget(user: user),

          const SizedBox(height: 24),

          // Auth Section
          _buildAuthSection(context, ref, user, l10n),

          const SizedBox(height: 24),

          // Admin Section (only for admin users)
          if (hasAdminAccess) ...[
            _buildAdminSection(context, isSuperAdmin, l10n),
            const SizedBox(height: 24),
          ],

          // Settings Section
          _buildSettingsSection(context, ref, l10n),

          const SizedBox(height: 24),

          // App Info Section
          _buildAppInfoSection(context, l10n),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildAuthSection(
    BuildContext context,
    WidgetRef ref,
    AppUser user,
    AppLocalizations l10n,
  ) {
    return _buildSection(
      title: l10n.section_account,
      children: [
        if (user.isGuest) ...[
          ProfileMenuItem(
            icon: Icons.login,
            title: l10n.login_as_admin,
            subtitle: l10n.login_as_admin_subtitle,
            iconColor: GVColors.purpleAccent,
            onTap: () => context.push(YRRoutes.adminLogin),
          ),
          ProfileMenuItem(
            icon: Icons.lock_reset,
            title: l10n.reset_password,
            subtitle: l10n.reset_password_profile_subtitle,
            iconColor: GVColors.blueFeature,
            onTap: () => _showResetPasswordDialogForGuest(context, ref, l10n),
          ),
        ] else ...[
          ProfileMenuItem(
            icon: Icons.lock_reset,
            title: l10n.reset_password,
            subtitle: l10n.reset_password_profile_subtitle,
            iconColor: GVColors.blueFeature,
            onTap: () => _showResetPasswordDialog(context, ref, l10n),
          ),
          ProfileMenuItem(
            icon: Icons.logout,
            title: l10n.logout_button,
            subtitle: l10n.logout_subtitle,
            iconColor: GVColors.redError,
            onTap: () => _showLogoutDialog(context, ref, l10n),
          ),
        ],
      ],
    );
  }

  Widget _buildAdminSection(
    BuildContext context,
    bool isSuperAdmin,
    AppLocalizations l10n,
  ) {
    return _buildSection(
      title: l10n.section_administration,
      children: [
        if (isSuperAdmin)
          ProfileMenuItem(
            icon: Icons.admin_panel_settings,
            title: l10n.admin_panel,
            subtitle: l10n.admin_panel_subtitle,
            iconColor: GVColors.orangeAccent,
            onTap: () => context.push(YRRoutes.adminPanel),
          ),
        ProfileMenuItem(
          icon: Icons.analytics_outlined,
          title: l10n.analytics_menu,
          subtitle: l10n.analytics_subtitle,
          iconColor: GVColors.blueInfo,
          showComingSoon: true,
          onTap: () => _showComingSoon(context, l10n),
        ),
        ProfileMenuItem(
          icon: Icons.settings_applications,
          title: l10n.app_configuration,
          subtitle: l10n.app_configuration_subtitle,
          iconColor: GVColors.greenSuccess,
          showComingSoon: true,
          onTap: () => _showComingSoon(context, l10n),
        ),
      ],
    );
  }

  Widget _buildSettingsSection(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) {
    final currentLocale = ref.watch(appLocaleProvider);
    final currentLanguage = AvailableLanguage.fromLocale(currentLocale);

    return _buildSection(
      title: l10n.section_settings,
      children: [
        ProfileMenuItem(
          icon: Icons.notifications_outlined,
          title: l10n.notifications_menu,
          subtitle: l10n.notifications_subtitle,
          iconColor: GVColors.yellowWarning,
          showComingSoon: true,
          onTap: () => _showComingSoon(context, l10n),
        ),
        ProfileMenuItem(
          icon: Icons.language,
          title: l10n.language_setting,
          subtitle: l10n.language_subtitle,
          iconColor: GVColors.blueFeature,
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                currentLanguage.getDisplayName(l10n),
                style: AppTextStyles.bodyText.copyWith(
                  color: GVColors.darkGrey,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.chevron_right,
                color: GVColors.lightGrey,
                size: 20,
              ),
            ],
          ),
          onTap: () => LanguagePickerSheet.show(context),
        ),
        ProfileMenuItem(
          icon: Icons.dark_mode_outlined,
          title: l10n.appearance_menu,
          subtitle: l10n.appearance_subtitle,
          iconColor: GVColors.purpleFeature,
          showComingSoon: true,
          onTap: () => _showComingSoon(context, l10n),
        ),
      ],
    );
  }

  Widget _buildAppInfoSection(BuildContext context, AppLocalizations l10n) {
    return _buildSection(
      title: l10n.section_about,
      children: [
        ProfileMenuItem(
          icon: Icons.info_outline,
          title: l10n.about_app,
          subtitle: l10n.about_app_subtitle,
          iconColor: GVColors.darkGrey,
          showComingSoon: true,
          onTap: () => _showComingSoon(context, l10n),
        ),
        ProfileMenuItem(
          icon: Icons.privacy_tip_outlined,
          title: l10n.privacy_policy,
          subtitle: l10n.privacy_policy_subtitle,
          iconColor: GVColors.darkGrey,
          showComingSoon: true,
          onTap: () => _showComingSoon(context, l10n),
        ),
        ProfileMenuItem(
          icon: Icons.description_outlined,
          title: l10n.terms_of_service,
          subtitle: l10n.terms_of_service_subtitle,
          iconColor: GVColors.darkGrey,
          showComingSoon: true,
          onTap: () => _showComingSoon(context, l10n),
        ),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            title,
            style: AppTextStyles.bodyTextStrong.copyWith(
              color: GVColors.darkGrey,
              fontSize: 14,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: GVColors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: GVColors.lightBorderGrey,
              width: 1,
            ),
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildError(BuildContext context, WidgetRef ref, String error) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: GVColors.redError,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.error_loading_profile,
              style: AppTextStyles.headingH2.copyWith(
                color: GVColors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: AppTextStyles.bodyText.copyWith(
                color: GVColors.darkGrey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showLogoutDialog(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          l10n.logout_button,
          style: AppTextStyles.headingH3.copyWith(
            color: GVColors.black,
          ),
        ),
        content: Text(
          l10n.logout_confirmation,
          style: AppTextStyles.bodyText.copyWith(
            color: GVColors.darkGrey,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              l10n.cancel,
              style: AppTextStyles.bodyText.copyWith(
                color: GVColors.darkGrey,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: GVColors.redError,
              foregroundColor: GVColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(60),
              ),
            ),
            child: Text(l10n.logout_button),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await ref.read(authProvider.notifier).signOut();
    }
  }

  Future<void> _showResetPasswordDialog(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          l10n.reset_password,
          style: AppTextStyles.headingH3.copyWith(
            color: GVColors.black,
          ),
        ),
        content: Text(
          l10n.reset_password_confirmation,
          style: AppTextStyles.bodyText.copyWith(
            color: GVColors.darkGrey,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              l10n.cancel,
              style: AppTextStyles.bodyText.copyWith(
                color: GVColors.darkGrey,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: GVColors.blueFeature,
              foregroundColor: GVColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(60),
              ),
            ),
            child: Text(l10n.send_reset_email),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final success =
          await ref.read(authProvider.notifier).sendPasswordResetEmail();
      if (success && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              l10n.reset_password_email_sent,
              style: AppTextStyles.smallText.copyWith(color: GVColors.white),
            ),
            backgroundColor: GVColors.greenSuccess,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  Future<void> _showResetPasswordDialogForGuest(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) async {
    final emailController = TextEditingController();

    final email = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          l10n.reset_password,
          style: AppTextStyles.headingH3.copyWith(
            color: GVColors.black,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.reset_password_enter_email,
              style: AppTextStyles.bodyText.copyWith(
                color: GVColors.darkGrey,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
              decoration: InputDecoration(
                hintText: l10n.email,
                hintStyle: AppTextStyles.bodyText.copyWith(
                  color: GVColors.lightGrey,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: GVColors.lightBorderGrey),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: GVColors.lightBorderGrey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: GVColors.blueFeature),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(null),
            child: Text(
              l10n.cancel,
              style: AppTextStyles.bodyText.copyWith(
                color: GVColors.darkGrey,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final email = emailController.text.trim();
              Navigator.of(context).pop(email.isNotEmpty ? email : null);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: GVColors.blueFeature,
              foregroundColor: GVColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(60),
              ),
            ),
            child: Text(l10n.send_reset_email),
          ),
        ],
      ),
    );

    if (email != null && email.isNotEmpty) {
      final success = await ref
          .read(authProvider.notifier)
          .sendPasswordResetEmail(email: email);
      if (success && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              l10n.reset_password_email_sent,
              style: AppTextStyles.smallText.copyWith(color: GVColors.white),
            ),
            backgroundColor: GVColors.greenSuccess,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  void _showComingSoon(BuildContext context, AppLocalizations l10n) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          l10n.coming_soon,
          style: AppTextStyles.smallText.copyWith(color: GVColors.white),
        ),
        backgroundColor: GVColors.blueInfo,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        duration: const Duration(seconds: 1),
      ),
    );
  }
}
