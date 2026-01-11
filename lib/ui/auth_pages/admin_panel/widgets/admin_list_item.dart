import 'package:flutter/material.dart';
import 'package:who_mobile_project/app_core/theme/colors.dart';
import 'package:who_mobile_project/app_core/theme/text_styles/app_text_styles.dart';
import 'package:who_mobile_project/general/models/auth/admin_user.dart';

/// Widget to display a single admin user in the admin panel list
class AdminListItem extends StatelessWidget {
  final AdminUser admin;
  final VoidCallback? onToggleStatus;
  final VoidCallback? onEdit;
  final bool isCurrentUser;

  const AdminListItem({
    super.key,
    required this.admin,
    this.onToggleStatus,
    this.onEdit,
    this.isCurrentUser = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: GVColors.lightBorderGrey,
          width: 0.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Avatar
            _buildAvatar(),
            const SizedBox(width: 16),

            // User info
            Expanded(
              child: _buildUserInfo(),
            ),

            // Actions
            if (!admin.isSuperAdmin) _buildActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: admin.isActive
            ? GVColors.purpleAccent.withValues(alpha: 0.1)
            : GVColors.lightGrey,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          admin.initials,
          style: AppTextStyles.headingH3.copyWith(
            color: admin.isActive ? GVColors.purpleAccent : GVColors.darkGrey,
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Name/Email row with badges
        Row(
          children: [
            Expanded(
              child: Text(
                admin.displayName ?? admin.email,
                style: AppTextStyles.bodyTextStrong.copyWith(
                  color: admin.isActive ? GVColors.black : GVColors.darkGrey,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            _buildRoleBadge(),
          ],
        ),
        const SizedBox(height: 4),

        // Email (if display name exists)
        if (admin.displayName != null)
          Text(
            admin.email,
            style: AppTextStyles.smallText.copyWith(
              color: GVColors.darkGrey,
            ),
            overflow: TextOverflow.ellipsis,
          ),

        const SizedBox(height: 8),

        // Status and date row
        Row(
          children: [
            _buildStatusBadge(),
            const SizedBox(width: 12),
            if (isCurrentUser)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: GVColors.blueInfo.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'You',
                  style: AppTextStyles.subtitleText.copyWith(
                    color: GVColors.blueInfo,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildRoleBadge() {
    final isSuperAdmin = admin.isSuperAdmin;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isSuperAdmin
            ? GVColors.orangeAccent.withValues(alpha: 0.1)
            : GVColors.purpleAccent.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        isSuperAdmin ? 'Super Admin' : 'Admin',
        style: AppTextStyles.subtitleText.copyWith(
          color: isSuperAdmin ? GVColors.orangeAccent : GVColors.purpleAccent,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildStatusBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: admin.isActive
            ? GVColors.greenSuccess.withValues(alpha: 0.1)
            : GVColors.redError.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: admin.isActive ? GVColors.greenSuccess : GVColors.redError,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            admin.isActive ? 'Active' : 'Inactive',
            style: AppTextStyles.subtitleText.copyWith(
              color: admin.isActive ? GVColors.greenSuccess : GVColors.redError,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions() {
    return Column(
      children: [
        // Toggle status switch
        Switch(
          value: admin.isActive,
          onChanged: onToggleStatus != null ? (_) => onToggleStatus!() : null,
          activeThumbColor: GVColors.greenSuccess,
          inactiveThumbColor: GVColors.darkGrey,
          inactiveTrackColor: GVColors.lightGrey,
        ),
      ],
    );
  }
}
