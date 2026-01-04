import 'package:flutter/material.dart';
import 'package:who_mobile_project/app_core/theme/colors.dart';
import 'package:who_mobile_project/app_core/theme/text_styles/app_text_styles.dart';
import 'package:who_mobile_project/general/models/auth/app_user.dart';

/// Widget that displays user profile information
/// Shows different UI for guest vs authenticated users
class ProfileHeaderWidget extends StatelessWidget {
  final AppUser user;

  const ProfileHeaderWidget({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: user.isGuest
              ? [
                  GVColors.lightGreyBackground,
                  GVColors.lightGrey,
                ]
              : [
                  GVColors.purpleAccent.withValues(alpha: 0.1),
                  GVColors.purpleAccent.withValues(alpha: 0.05),
                ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: user.isGuest
              ? GVColors.lightBorderGrey
              : GVColors.purpleAccent.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Avatar
          _buildAvatar(),
          const SizedBox(width: 16),

          // User Info
          Expanded(
            child: _buildUserInfo(),
          ),

          // Role Badge
          _buildRoleBadge(),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: user.isGuest
            ? GVColors.darkGrey.withValues(alpha: 0.1)
            : GVColors.purpleAccent.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: user.isGuest
              ? GVColors.darkGrey.withValues(alpha: 0.2)
              : GVColors.purpleAccent.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Center(
        child: user.isGuest
            ? Icon(
                Icons.person_outline,
                size: 32,
                color: GVColors.darkGrey,
              )
            : Text(
                user.initials,
                style: AppTextStyles.headingH2.copyWith(
                  color: GVColors.purpleAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  Widget _buildUserInfo() {
    if (user.isGuest) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Guest User',
            style: AppTextStyles.headingH3.copyWith(
              color: GVColors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Sign in to access all features',
            style: AppTextStyles.smallText.copyWith(
              color: GVColors.darkGrey,
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          user.displayName ?? 'Admin User',
          style: AppTextStyles.headingH3.copyWith(
            color: GVColors.black,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          user.email ?? '',
          style: AppTextStyles.smallText.copyWith(
            color: GVColors.darkGrey,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildRoleBadge() {
    final roleText = _getRoleText();
    final roleColor = _getRoleColor();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: roleColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: roleColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: roleColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            roleText,
            style: AppTextStyles.subtitleText.copyWith(
              color: roleColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _getRoleText() {
    if (user.isSuperAdmin) return 'Super Admin';
    if (user.hasAdminAccess) return 'Admin';
    return 'Guest';
  }

  Color _getRoleColor() {
    if (user.isSuperAdmin) return GVColors.orangeAccent;
    if (user.hasAdminAccess) return GVColors.purpleAccent;
    return GVColors.darkGrey;
  }
}
