import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:who_mobile_project/app_core/theme/colors.dart';
import 'package:who_mobile_project/app_core/theme/text_styles/app_text_styles.dart';
import 'package:who_mobile_project/general/models/auth/app_user.dart';
import 'package:who_mobile_project/providers/auth/auth_provider.dart';
import 'package:who_mobile_project/providers/auth/current_user_provider.dart';
import 'package:who_mobile_project/providers/auth/role_access_provider.dart';
import 'package:who_mobile_project/providers/base/base_api_state.dart';
import 'package:who_mobile_project/routing_config/routes.dart';
import 'package:who_mobile_project/ui/profile_and_settings/widgets/profile_header_widget.dart';
import 'package:who_mobile_project/ui/profile_and_settings/widgets/profile_menu_item.dart';

/// Profile and Settings page
/// Displays user info, login/logout options, and admin features for super admins
class ProfileMenuPage extends ConsumerWidget {
  const ProfileMenuPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);
    final isSuperAdmin = ref.watch(isSuperAdminProvider);
    final hasAdminAccess = ref.watch(hasAdminAccessProvider);

    // Listen for auth state changes
    ref.listen(authProvider, (previous, next) {
      if (next is BaseApiError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              next.exception.message ?? 'An error occurred',
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
          'Profile & Settings',
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
        error: (error, _) => _buildError(context, error.toString()),
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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Profile Header - User Info
          ProfileHeaderWidget(user: user),

          const SizedBox(height: 24),

          // Auth Section
          _buildAuthSection(context, ref, user),

          const SizedBox(height: 24),

          // Admin Section (only for admin users)
          if (hasAdminAccess) ...[
            _buildAdminSection(context, isSuperAdmin),
            const SizedBox(height: 24),
          ],

          // Settings Section
          _buildSettingsSection(context),

          const SizedBox(height: 24),

          // App Info Section
          _buildAppInfoSection(context),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildAuthSection(BuildContext context, WidgetRef ref, AppUser user) {
    return _buildSection(
      title: 'Account',
      children: [
        if (user.isGuest) ...[
          ProfileMenuItem(
            icon: Icons.login,
            title: 'Login as Admin',
            subtitle: 'Sign in to access admin features',
            iconColor: GVColors.purpleAccent,
            onTap: () => context.push(YRRoutes.adminLogin),
          ),
        ] else ...[
          ProfileMenuItem(
            icon: Icons.logout,
            title: 'Logout',
            subtitle: 'Sign out from your account',
            iconColor: GVColors.redError,
            onTap: () => _showLogoutDialog(context, ref),
          ),
        ],
      ],
    );
  }

  Widget _buildAdminSection(BuildContext context, bool isSuperAdmin) {
    return _buildSection(
      title: 'Administration',
      children: [
        if (isSuperAdmin)
          ProfileMenuItem(
            icon: Icons.admin_panel_settings,
            title: 'Admin Panel',
            subtitle: 'Manage admin users',
            iconColor: GVColors.orangeAccent,
            onTap: () => context.push(YRRoutes.adminPanel),
          ),
        ProfileMenuItem(
          icon: Icons.analytics_outlined,
          title: 'Analytics',
          subtitle: 'View app statistics',
          iconColor: GVColors.blueInfo,
          showComingSoon: true,
          onTap: () => _showComingSoon(context),
        ),
        ProfileMenuItem(
          icon: Icons.settings_applications,
          title: 'App Configuration',
          subtitle: 'Manage app settings',
          iconColor: GVColors.greenSuccess,
          showComingSoon: true,
          onTap: () => _showComingSoon(context),
        ),
      ],
    );
  }

  Widget _buildSettingsSection(BuildContext context) {
    return _buildSection(
      title: 'Settings',
      children: [
        ProfileMenuItem(
          icon: Icons.notifications_outlined,
          title: 'Notifications',
          subtitle: 'Manage notification preferences',
          iconColor: GVColors.yellowWarning,
          showComingSoon: true,
          onTap: () => _showComingSoon(context),
        ),
        ProfileMenuItem(
          icon: Icons.language,
          title: 'Language',
          subtitle: 'Change app language',
          iconColor: GVColors.blueFeature,
          showComingSoon: true,
          onTap: () => _showComingSoon(context),
        ),
        ProfileMenuItem(
          icon: Icons.dark_mode_outlined,
          title: 'Appearance',
          subtitle: 'Light/Dark mode settings',
          iconColor: GVColors.purpleFeature,
          showComingSoon: true,
          onTap: () => _showComingSoon(context),
        ),
      ],
    );
  }

  Widget _buildAppInfoSection(BuildContext context) {
    return _buildSection(
      title: 'About',
      children: [
        ProfileMenuItem(
          icon: Icons.info_outline,
          title: 'About WHO Mobile',
          subtitle: 'App information and version',
          iconColor: GVColors.darkGrey,
          showComingSoon: true,
          onTap: () => _showComingSoon(context),
        ),
        ProfileMenuItem(
          icon: Icons.privacy_tip_outlined,
          title: 'Privacy Policy',
          subtitle: 'Read our privacy policy',
          iconColor: GVColors.darkGrey,
          showComingSoon: true,
          onTap: () => _showComingSoon(context),
        ),
        ProfileMenuItem(
          icon: Icons.description_outlined,
          title: 'Terms of Service',
          subtitle: 'Read our terms of service',
          iconColor: GVColors.darkGrey,
          showComingSoon: true,
          onTap: () => _showComingSoon(context),
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

  Widget _buildError(BuildContext context, String error) {
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
              'Error loading profile',
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

  Future<void> _showLogoutDialog(BuildContext context, WidgetRef ref) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Logout',
          style: AppTextStyles.headingH3.copyWith(
            color: GVColors.black,
          ),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: AppTextStyles.bodyText.copyWith(
            color: GVColors.darkGrey,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'Cancel',
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
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await ref.read(authProvider.notifier).signOut();
    }
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Coming soon!',
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
