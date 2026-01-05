import 'package:flutter/material.dart';
import 'package:who_mobile_project/app_core/theme/colors.dart';
import 'package:who_mobile_project/app_core/theme/text_styles/app_text_styles.dart';
import 'package:who_mobile_project/general/models/maintenance/alert_template.dart';

/// Compact card widget showing scheduled maintenance alert reminders
/// Displayed in maintenance step detail pages when alerts are configured
class ScheduledAlertCard extends StatelessWidget {
  final List<AlertTemplate> alerts;

  const ScheduledAlertCard({super.key, required this.alerts});

  @override
  Widget build(BuildContext context) {
    if (alerts.isEmpty) return const SizedBox.shrink();

    // Use the first (most relevant) alert for display
    final primaryAlert = alerts.first;

    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: _getPriorityColor(primaryAlert.priority).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _getPriorityColor(primaryAlert.priority).withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Bell icon with priority color
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: _getPriorityColor(primaryAlert.priority).withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications_active,
              size: 16,
              color: _getPriorityColor(primaryAlert.priority),
            ),
          ),
          const SizedBox(width: 10),

          // Reminder text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Reminder: ${primaryAlert.intervalDisplay}',
                  style: AppTextStyles.bodyText.copyWith(
                    color: GVColors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                if (alerts.length > 1)
                  Text(
                    '+${alerts.length - 1} more alert${alerts.length > 2 ? 's' : ''}',
                    style: AppTextStyles.subtitleText.copyWith(
                      color: GVColors.darkGrey,
                      fontSize: 11,
                    ),
                  ),
              ],
            ),
          ),

          // Priority badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getPriorityColor(primaryAlert.priority),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              primaryAlert.priority.displayName,
              style: AppTextStyles.subtitleText.copyWith(
                color: GVColors.white,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
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
