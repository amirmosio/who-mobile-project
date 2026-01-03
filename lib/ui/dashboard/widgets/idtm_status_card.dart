import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:who_mobile_project/app_core/theme/colors.dart';
import 'package:who_mobile_project/general/models/idtm/installation_phase.dart';
import 'package:who_mobile_project/general/models/idtm/progress_tracker.dart';
import 'package:who_mobile_project/providers/idtm/installations_list_provider.dart';
import 'package:who_mobile_project/routing_config/routes.dart';

/// Dashboard card showing current IDTM installation status
class IdtmStatusCard extends ConsumerWidget {
  const IdtmStatusCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final installationsAsync = ref.watch(installationsListProvider);

    return installationsAsync.when(
      loading: () => _buildLoadingCard(context),
      error: (error, stack) => _buildErrorCard(context),
      data: (installations) {
        // Find the most recent active installation
        final activeInstallations = installations
            .where((i) => i.currentPhase != FacilityInstallationPhase.completed)
            .toList()
          ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

        if (activeInstallations.isEmpty) {
          return _buildNoActiveInstallationCard(context);
        }

        return _buildActiveInstallationCard(
          context,
          activeInstallations.first,
        );
      },
    );
  }

  Widget _buildLoadingCard(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            const SizedBox(width: 16),
            Text(
              'Loading IDTM status...',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorCard(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red[700]),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                'Unable to load IDTM status',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoActiveInstallationCard(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(16),
      child: InkWell(
        onTap: () => context.push(YRRoutes.idtmHome),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.construction,
                  size: 24,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'No Active Installation',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Start a new IDTM installation',
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

  Widget _buildActiveInstallationCard(
    BuildContext context,
    ProgressTracker progress,
  ) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(16),
      child: InkWell(
        onTap: () => context.push(YRRoutes.idtmHome),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with facility name and phase
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: _getPhaseColor(progress.currentPhase)
                          .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      _getPhaseIcon(progress.currentPhase),
                      size: 24,
                      color: _getPhaseColor(progress.currentPhase),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Current Installation',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          progress.facilityName,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
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
              const SizedBox(height: 16),

              // Phase badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _getPhaseColor(progress.currentPhase).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _getPhaseColor(progress.currentPhase),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.circle,
                      size: 8,
                      color: _getPhaseColor(progress.currentPhase),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      progress.currentPhase.displayName,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: _getPhaseColor(progress.currentPhase),
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Progress bar
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Progress',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                      Text(
                        '${progress.completedStepsInPhase} / ${progress.totalStepsInPhase} steps',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress.totalStepsInPhase > 0
                          ? progress.completedStepsInPhase /
                              progress.totalStepsInPhase
                          : 0,
                      minHeight: 8,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _getPhaseColor(progress.currentPhase),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${progress.progressPercentage.toStringAsFixed(0)}% complete',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                          fontSize: 11,
                        ),
                  ),
                ],
              ),

              // Location if available
              if (progress.location != null) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 14,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 6),
                    Text(
                      progress.location!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Color _getPhaseColor(FacilityInstallationPhase phase) {
    switch (phase) {
      case FacilityInstallationPhase.initial:
        return Colors.grey;
      case FacilityInstallationPhase.installing:
        return BZColors.bronzeDark;
      case FacilityInstallationPhase.maintenance:
        return Colors.blue;
      case FacilityInstallationPhase.dismantling:
        return Colors.orange;
      case FacilityInstallationPhase.completed:
        return Colors.green;
    }
  }

  IconData _getPhaseIcon(FacilityInstallationPhase phase) {
    switch (phase) {
      case FacilityInstallationPhase.initial:
        return Icons.pending_outlined;
      case FacilityInstallationPhase.installing:
        return Icons.construction;
      case FacilityInstallationPhase.maintenance:
        return Icons.settings;
      case FacilityInstallationPhase.dismantling:
        return Icons.inventory_2_outlined;
      case FacilityInstallationPhase.completed:
        return Icons.check_circle_outline;
    }
  }
}
