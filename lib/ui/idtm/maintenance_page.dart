import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:who_mobile_project/app_core/theme/colors.dart';
import 'package:who_mobile_project/general/constants/comment_categories.dart';
import 'package:who_mobile_project/general/models/maintenance/alert_template.dart';
import 'package:who_mobile_project/generated/i18n/app_localizations.dart';
import 'package:who_mobile_project/providers/maintenance/alert_template_provider.dart';
import 'package:who_mobile_project/providers/maintenance/scheduled_alerts_provider.dart';
import 'package:who_mobile_project/routing_config/routes.dart';
import 'package:who_mobile_project/ui/comments/widgets/comments_section_widget.dart';

/// Page for maintenance mode - system is installed and operational
class MaintenancePage extends ConsumerWidget {
  final String installationId;

  const MaintenancePage({
    super.key,
    required this.installationId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final scheduledAlertsState = ref.watch(scheduledAlertsProvider);
    final hasAlerts = scheduledAlertsState.hasScheduledAlerts(installationId);
    final alertCount = scheduledAlertsState.getScheduledCount(installationId);

    // Watch cached alerts for each interval type
    final dailyAlerts = ref.watch(alertTemplatesByIntervalProvider('daily'));
    final weeklyAlerts = ref.watch(alertTemplatesByIntervalProvider('weekly'));
    final monthlyAlerts = ref.watch(alertTemplatesByIntervalProvider('monthly'));

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.maintenance_mode),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Status card
          Card(
            color: Colors.green.withValues(alpha: 0.1),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle,
                    size: 48,
                    color: Colors.green,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.system_operational,
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.installation_completed_successfully,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Scheduled Alerts Section
          if (hasAlerts) ...[
            _buildScheduledAlertsCard(context, l10n, alertCount),
            const SizedBox(height: 24),
          ],

          // Maintenance tasks section
          Text(
            l10n.maintenance_tasks,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),

          _MaintenanceTaskCard(
            title: l10n.view_maintenance_guide,
            description: l10n.maintenance_guide_description,
            icon: Icons.menu_book,
            color: Colors.green,
            onTap: () {
              context.push(YRRoutes.maintenanceStepsList);
            },
          ),

          _MaintenanceTaskCard(
            title: l10n.daily_inspection,
            description: l10n.daily_inspection_description,
            icon: Icons.today,
            color: Colors.blue,
            alerts: dailyAlerts,
            onTap: () {
              // TODO: Navigate to daily inspection checklist
            },
          ),

          _MaintenanceTaskCard(
            title: l10n.weekly_maintenance,
            description: l10n.weekly_maintenance_description,
            icon: Icons.calendar_today,
            color: Colors.orange,
            alerts: weeklyAlerts,
            onTap: () {
              // TODO: Navigate to weekly maintenance
            },
          ),

          _MaintenanceTaskCard(
            title: l10n.monthly_review,
            description: l10n.monthly_review_description,
            icon: Icons.calendar_month,
            color: Colors.purple,
            alerts: monthlyAlerts,
            onTap: () {
              // TODO: Navigate to monthly review
            },
          ),

          const SizedBox(height: 24),

          // Maintenance Comments Section (Admin only)
          CommentsSectionWidget(
            category: CommentCategory.maintenance,
            maxComments: 3,
            showAddButton: true,
            showViewAll: true,
            title: l10n.maintenance_notes,
            collapsible: true,
            initiallyCollapsed: false,
          ),

          const SizedBox(height: 24),

          // Quick actions
          Text(
            l10n.quick_actions,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),

          ElevatedButton.icon(
            onPressed: () {
              // TODO: View full documentation
            },
            icon: const Icon(Icons.book),
            label: Text(l10n.view_documentation),
            style: ElevatedButton.styleFrom(
              backgroundColor: BZColors.bronzeDark,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 48),
            ),
          ),

          const SizedBox(height: 8),

          OutlinedButton.icon(
            onPressed: () {
              // TODO: Export maintenance log
            },
            icon: const Icon(Icons.download),
            label: Text(l10n.export_maintenance_log),
            style: OutlinedButton.styleFrom(
              foregroundColor: BZColors.bronzeDark,
              side: const BorderSide(color: BZColors.bronzeDark),
              minimumSize: const Size(double.infinity, 48),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduledAlertsCard(BuildContext context, AppLocalizations l10n, int alertCount) {
    return Card(
      color: Colors.blue.withValues(alpha: 0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.notifications_active,
                size: 32,
                color: Colors.blue,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.maintenance_alerts_active,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade700,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.scheduled_reminders_count(alertCount),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.blue.shade600,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.maintenance_notifications_info,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MaintenanceTaskCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final List<AlertTemplate>? alerts;

  const _MaintenanceTaskCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.onTap,
    this.alerts,
  });

  @override
  Widget build(BuildContext context) {
    final hasAlerts = alerts != null && alerts!.isNotEmpty;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        // When alerts exist, tapping the card shows alerts dialog
        onTap: hasAlerts ? () => _showAlertsDialog(context) : onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      icon,
                      color: color,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          description,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey[400],
                  ),
                ],
              ),
              // Show alert reminder banner if alerts exist
              if (hasAlerts) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: _getAlertColor().withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _getAlertColor().withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.notifications_active,
                        size: 16,
                        color: _getAlertColor(),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _getAlertText(),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: _getAlertColor(),
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        size: 18,
                        color: _getAlertColor(),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Color _getAlertColor() {
    if (alerts == null || alerts!.isEmpty) return Colors.grey;

    // Get highest priority alert
    final highestPriority = alerts!.fold<AlertPriority>(
      AlertPriority.low,
      (prev, alert) => alert.priority.index > prev.index ? alert.priority : prev,
    );

    switch (highestPriority) {
      case AlertPriority.critical:
        return Colors.red;
      case AlertPriority.high:
        return Colors.orange;
      case AlertPriority.medium:
        return Colors.blue;
      case AlertPriority.low:
        return Colors.green;
    }
  }

  String _getAlertText() {
    if (alerts == null || alerts!.isEmpty) return '';

    final count = alerts!.length;
    return '$count scheduled reminder${count == 1 ? '' : 's'}';
  }

  void _showAlertsDialog(BuildContext context) {
    if (alerts == null || alerts!.isEmpty) return;
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.notifications_active,
              color: _getAlertColor(),
              size: 24,
            ),
            const SizedBox(width: 12),
            Text(
              l10n.scheduled_reminders,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: alerts!.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final alert = alerts![index];
              return _AlertListItem(alert: alert);
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.close),
          ),
        ],
      ),
    );
  }
}

class _AlertListItem extends StatelessWidget {
  final AlertTemplate alert;

  const _AlertListItem({required this.alert});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  alert.title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              _buildPriorityBadge(context),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            alert.description,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                Icons.schedule,
                size: 14,
                color: Colors.grey[500],
              ),
              const SizedBox(width: 4),
              Text(
                _getIntervalDisplay(),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[500],
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriorityBadge(BuildContext context) {
    final color = _getPriorityColor();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        alert.priority.name.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  Color _getPriorityColor() {
    switch (alert.priority) {
      case AlertPriority.critical:
        return Colors.red;
      case AlertPriority.high:
        return Colors.orange;
      case AlertPriority.medium:
        return Colors.blue;
      case AlertPriority.low:
        return Colors.green;
    }
  }

  String _getIntervalDisplay() {
    final hours = alert.intervalHours;
    if (hours < 24) return 'Every $hours hour${hours == 1 ? '' : 's'}';
    if (hours == 24) return 'Daily';
    if (hours == 168) return 'Weekly';
    if (hours == 720) return 'Monthly';
    final days = hours ~/ 24;
    return 'Every $days days';
  }
}
