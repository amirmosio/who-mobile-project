import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:who_mobile_project/app_core/theme/colors.dart';
import 'package:who_mobile_project/providers/maintenance/scheduled_alerts_provider.dart';

/// Page for maintenance mode - system is installed and operational
class MaintenancePage extends ConsumerWidget {
  final String installationId;

  const MaintenancePage({
    super.key,
    required this.installationId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheduledAlertsState = ref.watch(scheduledAlertsProvider);
    final hasAlerts = scheduledAlertsState.hasScheduledAlerts(installationId);
    final alertCount = scheduledAlertsState.getScheduledCount(installationId);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Maintenance Mode'),
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
                          'System Operational',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Installation completed successfully',
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
            _buildScheduledAlertsCard(context, alertCount),
            const SizedBox(height: 24),
          ],

          // Maintenance tasks section
          Text(
            'Maintenance Tasks',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),

          _MaintenanceTaskCard(
            title: 'Daily Inspection',
            description: 'Check system status and connections',
            icon: Icons.today,
            color: Colors.blue,
            onTap: () {
              // TODO: Navigate to daily inspection checklist
            },
          ),

          _MaintenanceTaskCard(
            title: 'Weekly Maintenance',
            description: 'Perform routine maintenance checks',
            icon: Icons.calendar_today,
            color: Colors.orange,
            onTap: () {
              // TODO: Navigate to weekly maintenance
            },
          ),

          _MaintenanceTaskCard(
            title: 'Monthly Review',
            description: 'Complete monthly system review',
            icon: Icons.calendar_month,
            color: Colors.purple,
            onTap: () {
              // TODO: Navigate to monthly review
            },
          ),

          _MaintenanceTaskCard(
            title: 'View Installation Notes',
            description: 'Review notes from installation',
            icon: Icons.note,
            color: BZColors.bronzeDark,
            onTap: () {
              // TODO: Navigate to notes
            },
          ),

          _MaintenanceTaskCard(
            title: 'Add Comment',
            description: 'Leave notes for future reference',
            icon: Icons.comment,
            color: Colors.teal,
            onTap: () {
              // TODO: Navigate to add comment
            },
          ),

          const SizedBox(height: 24),

          // Quick actions
          Text(
            'Quick Actions',
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
            label: const Text('View Documentation'),
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
            label: const Text('Export Maintenance Log'),
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

  Widget _buildScheduledAlertsCard(BuildContext context, int alertCount) {
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
                    'Maintenance Alerts Active',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade700,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$alertCount scheduled reminder${alertCount == 1 ? '' : 's'}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.blue.shade600,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'You will receive periodic notifications for maintenance tasks',
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

  const _MaintenanceTaskCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
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
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
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
        ),
      ),
    );
  }
}
