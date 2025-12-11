import 'package:flutter/material.dart';
import 'package:who_mobile_project/app_core/theme/colors.dart';
import 'package:who_mobile_project/general/models/login/stored_account.dart';

class StoredAccountItem extends StatelessWidget {
  final StoredAccount account;
  final VoidCallback onTap;
  final VoidCallback? onRemove;
  final bool showRemoveButton;
  final bool isLoading;
  final bool isAccountSpecificLoading;

  const StoredAccountItem({
    super.key,
    required this.account,
    required this.onTap,
    this.onRemove,
    this.showRemoveButton = true,
    this.isLoading = false,
    this.isAccountSpecificLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48, // Match social auth button height
      decoration: BoxDecoration(
        color: GVColors.white,
        borderRadius: BorderRadius.circular(
          10,
        ), // Match social auth button radius
        border: Border.all(color: GVColors.borderGrey, width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onTap,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                // Avatar
                _buildAvatar(context),
                const SizedBox(width: 12),

                // Account info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        account.displayName.isNotEmpty
                            ? '${account.displayName[0].toUpperCase()}${account.displayName.substring(1)}'
                            : account.displayName,
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: GVColors.black,
                              letterSpacing: -0.3,
                            ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        account.email,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 12,
                          color: GVColors.lightGreyHint,
                          letterSpacing: -0.2,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                // Loading indicator or login method indicator and remove button
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isAccountSpecificLoading)
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            GVColors.guidaEvaiOrange,
                          ),
                        ),
                      )
                    else ...[
                      _buildLoginMethodIndicator(),
                      if (showRemoveButton && onRemove != null) ...[
                        const SizedBox(width: 8),
                        _buildRemoveButton(),
                      ],
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: GVColors.lightGreyBackground,
        shape: BoxShape.circle,
        border: Border.all(
          color: GVColors.borderGrey.withValues(alpha: 0.5),
          width: 0.5,
        ),
      ),
      child: account.avatarPath != null
          ? ClipOval(
              child: Image.network(
                account.avatarPath!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildInitialsAvatar(context);
                },
              ),
            )
          : _buildInitialsAvatar(context),
    );
  }

  Widget _buildInitialsAvatar(BuildContext context) {
    return Center(
      child: Text(
        account.initials,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: GVColors.black,
          letterSpacing: -0.2,
        ),
      ),
    );
  }

  Widget _buildLoginMethodIndicator() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: account.loginMethod.color.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        account.loginMethod.icon,
        size: 16,
        color: account.loginMethod.color,
      ),
    );
  }

  Widget _buildRemoveButton() {
    return GestureDetector(
      onTap: isLoading ? null : onRemove,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.close, size: 16, color: Colors.red.shade600),
      ),
    );
  }
}
