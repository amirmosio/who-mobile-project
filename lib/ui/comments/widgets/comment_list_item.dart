import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:who_mobile_project/app_core/theme/colors.dart';
import 'package:who_mobile_project/app_core/theme/text_styles/app_text_styles.dart';
import 'package:who_mobile_project/general/models/comments/comment.dart';

/// Widget to display a single comment in the comments list
class CommentListItem extends StatelessWidget {
  final Comment comment;
  final VoidCallback? onDelete;
  final bool isCurrentUserComment;

  const CommentListItem({
    super.key,
    required this.comment,
    this.onDelete,
    this.isCurrentUserComment = false,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Author info and actions
            _buildHeader(),
            const SizedBox(height: 12),

            // Comment text
            Text(
              comment.text,
              style: AppTextStyles.bodyText.copyWith(
                color: GVColors.black,
              ),
            ),

            const SizedBox(height: 12),

            // Footer: Category badge and timestamp
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        // Avatar
        _buildAvatar(),
        const SizedBox(width: 12),

        // Author info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      comment.authorName,
                      style: AppTextStyles.bodyTextStrong.copyWith(
                        color: GVColors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (isCurrentUserComment)
                    Container(
                      margin: const EdgeInsets.only(left: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
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
              const SizedBox(height: 2),
              Text(
                comment.authorEmail,
                style: AppTextStyles.smallText.copyWith(
                  color: GVColors.darkGrey,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),

        // Delete button (only for current user's comments or super admin)
        if (onDelete != null)
          IconButton(
            onPressed: onDelete,
            icon: Icon(
              Icons.delete_outline,
              color: GVColors.redError,
              size: 20,
            ),
            tooltip: 'Delete comment',
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(
              minWidth: 36,
              minHeight: 36,
            ),
          ),
      ],
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: GVColors.purpleAccent.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          comment.authorInitials,
          style: AppTextStyles.bodyTextStrong.copyWith(
            color: GVColors.purpleAccent,
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Row(
      children: [
        // Category badge
        _buildCategoryBadge(),
        const Spacer(),

        // Timestamp
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.access_time,
              size: 14,
              color: GVColors.darkGrey,
            ),
            const SizedBox(width: 4),
            Text(
              _formatTimestamp(comment.createdAt),
              style: AppTextStyles.smallText.copyWith(
                color: GVColors.darkGrey,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryBadge() {
    final categoryColors = _getCategoryColor();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: categoryColors.$1.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getCategoryIcon(),
            size: 14,
            color: categoryColors.$1,
          ),
          const SizedBox(width: 6),
          Text(
            comment.category.displayName,
            style: AppTextStyles.subtitleText.copyWith(
              color: categoryColors.$1,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  (Color, Color) _getCategoryColor() {
    switch (comment.category) {
      case _:
        return (GVColors.purpleAccent, GVColors.purpleAccent);
    }
  }

  IconData _getCategoryIcon() {
    switch (comment.category) {
      case _:
        return Icons.label_outline;
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      final minutes = difference.inMinutes;
      return '$minutes ${minutes == 1 ? 'min' : 'mins'} ago';
    } else if (difference.inDays < 1) {
      final hours = difference.inHours;
      return '$hours ${hours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inDays < 7) {
      final days = difference.inDays;
      return '$days ${days == 1 ? 'day' : 'days'} ago';
    } else {
      return DateFormat('MMM d, yyyy').format(timestamp);
    }
  }
}
