import 'package:flutter/material.dart';
import 'package:who_mobile_project/app_core/theme/colors.dart';
import 'package:who_mobile_project/app_core/theme/text_styles/app_text_styles.dart';
import 'package:who_mobile_project/general/models/maintenance/alert_template.dart';

/// List item widget for displaying an alert template
class AlertTemplateListItem extends StatelessWidget {
  final AlertTemplate template;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onToggleActive;

  const AlertTemplateListItem({
    super.key,
    required this.template,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleActive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: template.isActive
            ? GVColors.white
            : GVColors.lightGrey.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: template.isActive
              ? GVColors.lightBorderGrey
              : GVColors.lightBorderGrey.withValues(alpha: 0.5),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onEdit,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Priority indicator
                    Container(
                      width: 4,
                      height: 40,
                      decoration: BoxDecoration(
                        color: _getPriorityColor(template.priority),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Title and interval
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            template.title,
                            style: AppTextStyles.headingH3.copyWith(
                              color: template.isActive
                                  ? GVColors.black
                                  : GVColors.darkGrey,
                              decoration: template.isActive
                                  ? null
                                  : TextDecoration.lineThrough,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 14,
                                color: GVColors.darkGrey,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                template.intervalDisplay,
                                style: AppTextStyles.subtitleText.copyWith(
                                  color: GVColors.darkGrey,
                                ),
                              ),
                              const SizedBox(width: 12),
                              _buildPriorityChip(),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Active toggle
                    Transform.scale(
                      scale: 0.8,
                      child: Switch.adaptive(
                        value: template.isActive,
                        onChanged: (_) => onToggleActive(),
                        activeTrackColor:
                            GVColors.purpleAccent.withValues(alpha: 0.5),
                        thumbColor: WidgetStateProperty.resolveWith((states) {
                          if (states.contains(WidgetState.selected)) {
                            return GVColors.purpleAccent;
                          }
                          return GVColors.darkGrey;
                        }),
                        trackColor: WidgetStateProperty.resolveWith((states) {
                          if (states.contains(WidgetState.selected)) {
                            return GVColors.purpleAccent.withValues(alpha: 0.5);
                          }
                          return GVColors.lightGrey;
                        }),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Description
                Text(
                  template.description,
                  style: AppTextStyles.bodyText.copyWith(
                    color: template.isActive
                        ? GVColors.darkGrey
                        : GVColors.darkGrey.withValues(alpha: 0.6),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 12),

                // Action buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: onEdit,
                      icon: Icon(
                        Icons.edit_outlined,
                        size: 18,
                        color: GVColors.purpleAccent,
                      ),
                      label: Text(
                        'Edit',
                        style: AppTextStyles.smallText.copyWith(
                          color: GVColors.purpleAccent,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    TextButton.icon(
                      onPressed: onDelete,
                      icon: Icon(
                        Icons.delete_outline,
                        size: 18,
                        color: GVColors.redError,
                      ),
                      label: Text(
                        'Delete',
                        style: AppTextStyles.smallText.copyWith(
                          color: GVColors.redError,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: _getPriorityColor(template.priority).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        template.priority.displayName,
        style: AppTextStyles.subtitleText.copyWith(
          color: _getPriorityColor(template.priority),
          fontWeight: FontWeight.w500,
          fontSize: 10,
        ),
      ),
    );
  }

  Color _getPriorityColor(AlertPriority priority) {
    switch (priority) {
      case AlertPriority.low:
        return GVColors.greenSuccess;
      case AlertPriority.medium:
        return GVColors.yellowWarning;
      case AlertPriority.high:
        return GVColors.redError;
      case AlertPriority.critical:
        return Colors.deepPurple;
    }
  }
}
