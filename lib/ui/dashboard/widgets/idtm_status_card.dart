import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:who_mobile_project/app_core/theme/colors.dart';
import 'package:who_mobile_project/di/injector.dart';
import 'package:who_mobile_project/general/models/idtm/installation_phase.dart';
import 'package:who_mobile_project/general/services/storage/storage_manager.dart';
import 'package:who_mobile_project/general/widgets/progress_card_widget.dart';
import 'package:who_mobile_project/providers/auth/current_user_provider.dart';
import 'package:who_mobile_project/generated/i18n/app_localizations.dart';
import 'package:who_mobile_project/providers/dismantling/dismantling_provider.dart';
import 'package:who_mobile_project/providers/installation/installation_provider.dart';
import 'package:who_mobile_project/routing_config/routes.dart';
import 'package:who_mobile_project/services/firebase/firebase_auth_service.dart';

/// Dashboard card showing IDTM status and action buttons
/// Handles installation, maintenance, and dismantling phases
class IdtmStatusCard extends ConsumerStatefulWidget {
  final VoidCallback? onStatusChanged;

  const IdtmStatusCard({super.key, this.onStatusChanged});

  @override
  ConsumerState<IdtmStatusCard> createState() => _IdtmStatusCardState();
}

class _IdtmStatusCardState extends ConsumerState<IdtmStatusCard> {
  late final StorageManager _storageManager;
  late final FirebaseAuthService _authService;
  FacilityInstallationPhase _currentPhase = FacilityInstallationPhase.initial;

  @override
  void initState() {
    super.initState();
    _storageManager = getIt<StorageManager>();
    _authService = getIt<FirebaseAuthService>();
    // Read phase from storage - this gets the latest value after Firebase restore
    _currentPhase = _storageManager.getCurrentPhase();
  }

  /// Sync current installation state to Firebase for cross-device persistence
  Future<void> _syncToFirebase(FacilityInstallationPhase phase) async {
    try {
      final currentUser = await ref.read(currentUserProvider.future);
      if (!currentUser.isAuthenticated || currentUser.uid == null) {
        return;
      }

      await _authService.updateInstallationState(
        currentUser.uid!,
        phase: phase.value,
        installationId: _storageManager.getInstallationId(),
        facilityId: _storageManager.getFacilityId(),
        facilityName: _storageManager.getFacilityName(),
      );
    } catch (_) {
      // Silently fail - Firebase sync is not critical
    }
  }

  /// Clear installation state from Firebase
  Future<void> _clearFirebaseState() async {
    try {
      final currentUser = await ref.read(currentUserProvider.future);
      if (!currentUser.isAuthenticated || currentUser.uid == null) {
        return;
      }

      await _authService.clearInstallationState(currentUser.uid!);
    } catch (_) {
      // Silently fail - Firebase sync is not critical
    }
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

  String _getStatusDescription(AppLocalizations l10n) {
    switch (_currentPhase) {
      case FacilityInstallationPhase.initial:
        return l10n.ready_to_begin_installation;
      case FacilityInstallationPhase.installing:
        return l10n.installation_in_progress;
      case FacilityInstallationPhase.maintenance:
        return l10n.system_operational;
      case FacilityInstallationPhase.dismantling:
        return l10n.dismantling_in_progress_status;
      case FacilityInstallationPhase.completed:
        return l10n.installation_completed;
    }
  }

  List<Widget> _buildActionButtons(AppLocalizations l10n) {
    final buttons = <Widget>[];

    // Primary action based on status
    switch (_currentPhase) {
      case FacilityInstallationPhase.initial:
        buttons.add(
          _ActionButton(
            label: l10n.start_installation,
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

              // Sync to Firebase
              await _syncToFirebase(FacilityInstallationPhase.installing);

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
            label: l10n.continue_installation,
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
            label: l10n.maintenance_mode,
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
            label: l10n.start_dismantling,
            icon: Icons.delete,
            color: Colors.red,
            outlined: true,
            onPressed: () => _showDismantlingConfirmation(context, l10n),
          ),
        );
        break;

      case FacilityInstallationPhase.dismantling:
        buttons.add(
          _ActionButton(
            label: l10n.continue_dismantling,
            icon: Icons.delete,
            color: Colors.red,
            onPressed: () {
              context.push(YRRoutes.dismantlingStepsList).then((_) {
                widget.onStatusChanged?.call();
              });
            },
          ),
        );
        break;

      case FacilityInstallationPhase.completed:
        buttons.add(
          _ActionButton(
            label: l10n.start_new_installation,
            icon: Icons.refresh,
            color: BZColors.bronzeDark,
            onPressed: () async {
              // Reset to initial state
              await _storageManager.resetToInitial();

              // Clear Firebase state
              await _clearFirebaseState();

              if (mounted) {
                // Invalidate providers to refresh progress state
                ref.invalidate(installationProgressProvider);
                ref.invalidate(dismantlingProgressProvider);

                setState(() {
                  _currentPhase = FacilityInstallationPhase.initial;
                });
                widget.onStatusChanged?.call();

                // Show success message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        const Icon(Icons.check_circle, color: Colors.white),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            l10n.system_reset_ready,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    backgroundColor: BZColors.bronzeDark,
                    duration: const Duration(seconds: 2),
                  ),
                );
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
        label: l10n.show_packing_list,
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

  Future<void> _showDismantlingConfirmation(
    BuildContext context,
    AppLocalizations l10n,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.warning, color: Colors.orange, size: 28),
              const SizedBox(width: 12),
              Text(l10n.start_dismantling_question),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.dismantling_confirmation_message,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 12),
              _ConfirmationItem(
                icon: Icons.exit_to_app,
                text: l10n.exit_maintenance_mode,
              ),
              _ConfirmationItem(
                icon: Icons.delete_outline,
                text: l10n.begin_dismantling_phase,
              ),
              _ConfirmationItem(
                icon: Icons.checklist,
                text: l10n.open_dismantling_guide,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.orange.shade700,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        l10n.maintenance_complete_before_dismantling,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.orange.shade900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(l10n.cancel),
            ),
            ElevatedButton.icon(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              icon: const Icon(Icons.check, size: 18),
              label: Text(l10n.start_dismantling),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        );
      },
    );

    if (confirmed == true && mounted) {
      // Update phase to dismantling (this also resets dismantling progress)
      await _storageManager.startDismantling();

      // Sync to Firebase
      await _syncToFirebase(FacilityInstallationPhase.dismantling);

      if (mounted) {
        // Invalidate dismantling provider to refresh with reset progress
        ref.invalidate(dismantlingProgressProvider);

        setState(() {
          _currentPhase = FacilityInstallationPhase.dismantling;
        });
        widget.onStatusChanged?.call();

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    l10n.dismantling_started_message,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.white),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );

        // Navigate to dismantling guide
        context.push(YRRoutes.dismantlingStepsList).then((_) {
          widget.onStatusChanged?.call();
        });
      }
    }
  }

  Widget _buildInstallationGuideProgress(AppLocalizations l10n) {
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

        return ProgressCardWidget(
          title: l10n.installation_guide_progress,
          completeTitle: l10n.installation_complete_title,
          completedCount: completedCount,
          totalCount: totalSubsteps,
          progress: progress,
          isComplete: isComplete,
          progressColor: Colors.blue,
          completeColor: Colors.green,
          backgroundColor: isComplete
              ? Colors.green.shade50
              : progress > 0
              ? Colors.blue.shade50
              : Colors.grey.shade50,
          actionButton:
              (isComplete &&
                  _currentPhase == FacilityInstallationPhase.installing)
              ? ElevatedButton.icon(
                  onPressed: () async {
                    // Update phase to maintenance
                    await _storageManager.setCurrentPhase(
                      FacilityInstallationPhase.maintenance,
                    );

                    // Sync to Firebase
                    await _syncToFirebase(FacilityInstallationPhase.maintenance);

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
                                  l10n.installation_complete_maintenance,
                                  style: Theme.of(context).textTheme.bodyMedium
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
                  label: Text(l10n.finish_go_to_maintenance),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                )
              : null,
        );
      },
    );
  }

  Widget _buildDismantlingGuideProgress(AppLocalizations l10n) {
    final dismantlingDataAsync = ref.watch(dismantlingDataProvider);
    final lastCompletedIndex = ref.watch(dismantlingProgressProvider);

    return dismantlingDataAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (dismantlingData) {
        final flattenedList = ref.watch(flattenedDismantlingSubstepsProvider);
        final totalSubsteps = flattenedList.length;

        if (totalSubsteps == 0) return const SizedBox.shrink();

        final progress = ((lastCompletedIndex + 1) / totalSubsteps).clamp(
          0.0,
          1.0,
        );
        final completedCount = lastCompletedIndex + 1;
        final isComplete = progress >= 1.0;

        return ProgressCardWidget(
          title: l10n.dismantling_guide_progress,
          completeTitle: l10n.dismantling_complete_title,
          completedCount: completedCount,
          totalCount: totalSubsteps,
          progress: progress,
          isComplete: isComplete,
          progressColor: Colors.red,
          completeColor: Colors.blue,
          backgroundColor: isComplete
              ? Colors.blue.shade50
              : progress > 0
              ? Colors.red.shade50
              : Colors.grey.shade50,
          actionButton:
              (isComplete &&
                  _currentPhase == FacilityInstallationPhase.dismantling)
              ? ElevatedButton.icon(
                  onPressed: () async {
                    // Update phase to completed
                    await _storageManager.completeDismantling();

                    // Sync to Firebase
                    await _syncToFirebase(FacilityInstallationPhase.completed);

                    if (mounted) {
                      setState(() {
                        _currentPhase = FacilityInstallationPhase.completed;
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
                                  l10n.dismantling_lifecycle_complete,
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          backgroundColor: Colors.blue,
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.done_all, size: 18),
                  label: Text(l10n.complete_dismantling),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                )
              : null,
        );
      },
    );
  }

  Widget _buildCompletedSummary(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade50, Colors.green.shade50],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade200, width: 2),
      ),
      child: Column(
        children: [
          // Success icon
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.shade100,
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Icon(Icons.verified, size: 48, color: Colors.blue),
          ),
          const SizedBox(height: 16),

          // Title
          Text(
            l10n.idtm_lifecycle_completed,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade900,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),

          // Description
          Text(
            l10n.lifecycle_completed_description,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade700),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

          // Summary items
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _CompletionBadge(
                icon: Icons.build_circle,
                label: l10n.installed,
                color: Colors.green,
              ),
              _CompletionBadge(
                icon: Icons.settings,
                label: l10n.maintained,
                color: Colors.blue,
              ),
              _CompletionBadge(
                icon: Icons.inventory_2,
                label: l10n.dismantled,
                color: Colors.orange,
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

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
                        l10n.idtm_installation,
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
              _getStatusDescription(l10n),
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ),

            const SizedBox(height: 16),

            // Show progress based on current phase
            if (_currentPhase == FacilityInstallationPhase.installing ||
                _currentPhase == FacilityInstallationPhase.maintenance)
              _buildInstallationGuideProgress(l10n)
            else if (_currentPhase == FacilityInstallationPhase.dismantling)
              _buildDismantlingGuideProgress(l10n)
            else if (_currentPhase == FacilityInstallationPhase.completed)
              _buildCompletedSummary(l10n),

            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),

            // Action buttons
            ..._buildActionButtons(l10n),
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

class _ConfirmationItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _ConfirmationItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey.shade700),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text, style: TextStyle(color: Colors.grey.shade700)),
          ),
        ],
      ),
    );
  }
}

class _CompletionBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _CompletionBadge({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
            border: Border.all(color: color.withValues(alpha: 0.3), width: 2),
          ),
          child: Icon(icon, size: 28, color: color),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
