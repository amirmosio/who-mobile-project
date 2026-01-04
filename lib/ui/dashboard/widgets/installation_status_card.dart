import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:who_mobile_project/app_core/theme/colors.dart';
import 'package:who_mobile_project/di/injector.dart';
import 'package:who_mobile_project/general/models/idtm/installation_phase.dart';
import 'package:who_mobile_project/general/services/storage/storage_manager.dart';
import 'package:who_mobile_project/providers/installation/installation_provider.dart';
import 'package:who_mobile_project/routing_config/routes.dart';

/// Dashboard card showing installation status and action buttons
class InstallationStatusCard extends ConsumerStatefulWidget {
  final VoidCallback? onStatusChanged;

  const InstallationStatusCard({super.key, this.onStatusChanged});

  @override
  ConsumerState<InstallationStatusCard> createState() =>
      _InstallationStatusCardState();
}

class _InstallationStatusCardState
    extends ConsumerState<InstallationStatusCard> {
  late final StorageManager _storageManager;
  late FacilityInstallationPhase _currentPhase;

  @override
  void initState() {
    super.initState();
    _storageManager = getIt<StorageManager>();
    _currentPhase = _storageManager.getCurrentPhase();
  }

  Color _getStatusColor() {
    switch (_currentPhase) {
      case FacilityInstallationPhase.initial:
        return Colors.grey;
      case FacilityInstallationPhase.installing:
        return Colors.orange;
      case FacilityInstallationPhase.maintenance:
        return Colors.green;
      case FacilityInstallationPhase.dismantling:
        return Colors.red;
      case FacilityInstallationPhase.completed:
        return Colors.blue;
    }
  }

  IconData _getStatusIcon() {
    switch (_currentPhase) {
      case FacilityInstallationPhase.initial:
        return Icons.download_outlined;
      case FacilityInstallationPhase.installing:
        return Icons.build_outlined;
      case FacilityInstallationPhase.maintenance:
        return Icons.check_circle_outline;
      case FacilityInstallationPhase.dismantling:
        return Icons.delete_outline;
      case FacilityInstallationPhase.completed:
        return Icons.done_all;
    }
  }

  String _getStatusDescription() {
    switch (_currentPhase) {
      case FacilityInstallationPhase.initial:
        return 'Ready to begin installation process';
      case FacilityInstallationPhase.installing:
        return 'Installation in progress';
      case FacilityInstallationPhase.maintenance:
        return 'System installed and operational';
      case FacilityInstallationPhase.dismantling:
        return 'Dismantling in progress';
      case FacilityInstallationPhase.completed:
        return 'Installation completed';
    }
  }

  List<Widget> _buildActionButtons() {
    final buttons = <Widget>[];

    // Primary action based on status
    switch (_currentPhase) {
      case FacilityInstallationPhase.initial:
        buttons.add(
          _ActionButton(
            label: 'Start Installation',
            icon: Icons.play_arrow,
            color: BZColors.bronzeDark,
            onPressed: () async {
              // Create a new installation
              final installationId =
                  'installation_${DateTime.now().millisecondsSinceEpoch}';
              await _storageManager.startInstallation(
                installationId: installationId,
                facilityId: 'default',
                facilityName: 'Default Facility',
              );

              if (mounted) {
                // Navigate to installation steps and refresh on return
                context
                    .push(
                      YRRoutes.idtmInstallationDetail.replaceAll(
                        ':installationId',
                        installationId,
                      ),
                    )
                    .then((_) {
                      widget.onStatusChanged?.call();
                    });
              }
            },
          ),
        );
        break;

      case FacilityInstallationPhase.installing:
        buttons.add(
          _ActionButton(
            label: 'Continue Installation',
            icon: Icons.build,
            color: Colors.orange,
            onPressed: () {
              final installationId = _storageManager.getInstallationId();
              if (installationId != null) {
                context
                    .push(
                      YRRoutes.idtmInstallationDetail.replaceAll(
                        ':installationId',
                        installationId,
                      ),
                    )
                    .then((_) {
                      widget.onStatusChanged?.call();
                    });
              }
            },
          ),
        );
        break;

      case FacilityInstallationPhase.maintenance:
        buttons.add(
          _ActionButton(
            label: 'Maintenance Mode',
            icon: Icons.settings,
            color: Colors.green,
            onPressed: () {
              final installationId = _storageManager.getInstallationId();
              if (installationId != null) {
                context
                    .push(
                      YRRoutes.idtmMaintenance.replaceAll(
                        ':installationId',
                        installationId,
                      ),
                    )
                    .then((_) {
                      widget.onStatusChanged?.call();
                    });
              }
            },
          ),
        );
        buttons.add(const SizedBox(height: 8));
        buttons.add(
          _ActionButton(
            label: 'Dismantling',
            icon: Icons.delete,
            color: Colors.red,
            outlined: true,
            onPressed: () {
              final installationId = _storageManager.getInstallationId();
              if (installationId != null) {
                context
                    .push(
                      YRRoutes.idtmDismantling.replaceAll(
                        ':installationId',
                        installationId,
                      ),
                    )
                    .then((_) {
                      widget.onStatusChanged?.call();
                    });
              }
            },
          ),
        );
        break;

      case FacilityInstallationPhase.dismantling:
        buttons.add(
          _ActionButton(
            label: 'Continue Dismantling',
            icon: Icons.delete,
            color: Colors.red,
            onPressed: () {
              final installationId = _storageManager.getInstallationId();
              if (installationId != null) {
                context
                    .push(
                      YRRoutes.idtmDismantling.replaceAll(
                        ':installationId',
                        installationId,
                      ),
                    )
                    .then((_) {
                      widget.onStatusChanged?.call();
                    });
              }
            },
          ),
        );
        break;

      case FacilityInstallationPhase.completed:
        buttons.add(
          _ActionButton(
            label: 'View Details',
            icon: Icons.info_outline,
            color: Colors.blue,
            onPressed: () {
              final installationId = _storageManager.getInstallationId();
              if (installationId != null) {
                context
                    .push(
                      YRRoutes.idtmInstallationDetail.replaceAll(
                        ':installationId',
                        installationId,
                      ),
                    )
                    .then((_) {
                      widget.onStatusChanged?.call();
                    });
              }
            },
          ),
        );
        break;
    }

    // Always show packing list button
    if (buttons.isNotEmpty) {
      buttons.add(const SizedBox(height: 8));
    }
    buttons.add(
      _ActionButton(
        label: 'Show Packing List',
        icon: Icons.inventory_2_outlined,
        color: BZColors.bronzeDark,
        outlined: true,
        onPressed: () {
          context.push(YRRoutes.idtmPackingList).then((_) {
            widget.onStatusChanged?.call();
          });
        },
      ),
    );

    return buttons;
  }

  Widget _buildInstallationGuideProgress() {
    final installationDataAsync = ref.watch(installationDataProvider);
    final lastCompletedIndex = ref.watch(installationProgressProvider);

    return installationDataAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (installationData) {
        final flattenedList = ref.watch(flattenedSubstepsProvider);
        final totalSubsteps = flattenedList.length;

        if (totalSubsteps == 0) return const SizedBox.shrink();

        final progress = ((lastCompletedIndex + 1) / totalSubsteps).clamp(
          0.0,
          1.0,
        );
        final completedCount = lastCompletedIndex + 1;
        final isComplete = progress >= 1.0;

        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isComplete
                ? Colors.green.shade50
                : progress > 0
                ? Colors.blue.shade50
                : Colors.grey.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isComplete
                        ? 'Installation Complete!'
                        : 'Installation Guide Progress',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isComplete ? Colors.green : null,
                    ),
                  ),
                  if (isComplete)
                    const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 20,
                    )
                  else
                    Text(
                      '${(progress * 100).toStringAsFixed(0)}%',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: progress > 0 ? Colors.blue : Colors.grey,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 6,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isComplete
                        ? Colors.green
                        : progress > 0.7
                        ? Colors.lightGreen
                        : progress > 0.3
                        ? Colors.orange
                        : Colors.blue,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '$completedCount of $totalSubsteps steps completed',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
              ),

              // Complete Installation Button
              // Only show if installation is complete AND not already in maintenance/dismantling/completed phase
              if (isComplete &&
                  _currentPhase == FacilityInstallationPhase.installing) ...[
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      // Update phase to maintenance
                      await _storageManager.setCurrentPhase(
                        FacilityInstallationPhase.maintenance,
                      );

                      if (mounted) {
                        setState(() {
                          _currentPhase = FacilityInstallationPhase.maintenance;
                        });
                        widget.onStatusChanged?.call();

                        // Show success message
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Row(
                              children: [
                                const Icon(
                                  Icons.check_circle,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'Installation completed! Opening maintenance mode.',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                            backgroundColor: Colors.green,
                            duration: const Duration(seconds: 2),
                          ),
                        );

                        // Navigate to maintenance page
                        final installationId = _storageManager
                            .getInstallationId();
                        if (installationId != null) {
                          context
                              .push(
                                YRRoutes.idtmMaintenance.replaceAll(
                                  ':installationId',
                                  installationId,
                                ),
                              )
                              .then((_) {
                                widget.onStatusChanged?.call();
                              });
                        }
                      }
                    },
                    icon: const Icon(Icons.done_all, size: 18),
                    label: const Text('Finish & Go to Maintenance'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with status
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _getStatusColor().withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getStatusIcon(),
                    size: 32,
                    color: _getStatusColor(),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'IDTM Installation',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _getStatusColor().withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              _currentPhase.displayName,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: _getStatusColor(),
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Status description
            Text(
              _getStatusDescription(),
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ),

            const SizedBox(height: 16),

            // Installation Guide Progress
            _buildInstallationGuideProgress(),

            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),

            // Action buttons
            ..._buildActionButtons(),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final bool outlined;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onPressed,
    this.outlined = false,
  });

  @override
  Widget build(BuildContext context) {
    if (outlined) {
      return OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 20),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          foregroundColor: color,
          side: BorderSide(color: color),
          minimumSize: const Size(double.infinity, 44),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }

    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 20),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 44),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
