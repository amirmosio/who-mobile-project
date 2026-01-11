import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:who_mobile_project/app_core/theme/colors.dart';
import 'package:who_mobile_project/di/injector.dart';
import 'package:who_mobile_project/general/models/idtm/installation_phase.dart';
import 'package:who_mobile_project/general/services/storage/storage_manager.dart';
import 'package:who_mobile_project/general/widgets/progress_card_widget.dart';
import 'package:who_mobile_project/providers/auth/current_user_provider.dart';
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
    debugPrint('🔥 IdtmStatusCard initState - phase from storage: ${_currentPhase.value}');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh phase when dependencies change (e.g., after navigation)
    _refreshPhase();
  }

  /// Refresh the current phase from storage
  void _refreshPhase() {
    final newPhase = _storageManager.getCurrentPhase();
    debugPrint('🔥 IdtmStatusCard _refreshPhase - newPhase: ${newPhase.value}, currentPhase: ${_currentPhase.value}');
    if (newPhase != _currentPhase && mounted) {
      setState(() {
        _currentPhase = newPhase;
      });
    }
  }

  /// Sync current installation state to Firebase for cross-device persistence
  Future<void> _syncToFirebase(FacilityInstallationPhase phase) async {
    debugPrint('🔥 _syncToFirebase called with phase: ${phase.value}');
    try {
      final currentUser = await ref.read(currentUserProvider.future);
      debugPrint(
        '🔥 Current user: ${currentUser.uid}, authenticated: ${currentUser.isAuthenticated}',
      );

      if (!currentUser.isAuthenticated || currentUser.uid == null) {
        debugPrint('🔥 User not authenticated, skipping sync');
        return;
      }

      final installationId = _storageManager.getInstallationId();
      final facilityId = _storageManager.getFacilityId();
      final facilityName = _storageManager.getFacilityName();

      debugPrint('🔥 Calling updateInstallationState...');
      debugPrint('🔥 installationId: $installationId');
      debugPrint('🔥 facilityId: $facilityId');
      debugPrint('🔥 facilityName: $facilityName');

      await _authService.updateInstallationState(
        currentUser.uid!,
        phase: phase.value,
        installationId: installationId,
        facilityId: facilityId,
        facilityName: facilityName,
      );
      debugPrint('🔥 Firebase sync completed successfully!');
    } catch (e, st) {
      debugPrint('🔥 Firebase sync FAILED: $e');
      debugPrint('🔥 Stack trace: $st');
    }
  }

  /// Clear installation state from Firebase
  Future<void> _clearFirebaseState() async {
    debugPrint('🔥 _clearFirebaseState called');
    try {
      final currentUser = await ref.read(currentUserProvider.future);
      debugPrint(
        '🔥 Current user for clear: ${currentUser.uid}, authenticated: ${currentUser.isAuthenticated}',
      );

      if (!currentUser.isAuthenticated || currentUser.uid == null) {
        debugPrint('🔥 User not authenticated, skipping clear');
        return;
      }

      await _authService.clearInstallationState(currentUser.uid!);
      debugPrint('🔥 Firebase state cleared successfully!');
    } catch (e, st) {
      debugPrint('🔥 Firebase clear FAILED: $e');
      debugPrint('🔥 Stack trace: $st');
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
            label: 'Start Dismantling',
            icon: Icons.delete,
            color: Colors.red,
            outlined: true,
            onPressed: () => _showDismantlingConfirmation(context),
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
            label: 'Start New Installation',
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
                            'System reset. Ready for new installation.',
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

  Future<void> _showDismantlingConfirmation(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.warning, color: Colors.orange, size: 28),
              const SizedBox(width: 12),
              const Text('Start Dismantling?'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'You are about to start the dismantling process. This will:',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 12),
              _ConfirmationItem(
                icon: Icons.exit_to_app,
                text: 'Exit maintenance mode',
              ),
              _ConfirmationItem(
                icon: Icons.delete_outline,
                text: 'Begin dismantling phase',
              ),
              _ConfirmationItem(
                icon: Icons.checklist,
                text: 'Open dismantling guide',
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
                        'Make sure all maintenance tasks are completed before proceeding.',
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
              child: const Text('Cancel'),
            ),
            ElevatedButton.icon(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              icon: const Icon(Icons.check, size: 18),
              label: const Text('Start Dismantling'),
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
      // Update phase to dismantling
      await _storageManager.startDismantling();

      // Sync to Firebase
      await _syncToFirebase(FacilityInstallationPhase.dismantling);

      if (mounted) {
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
                    'Dismantling phase started. Opening dismantling guide.',
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

        return ProgressCardWidget(
          title: 'Installation Guide Progress',
          completeTitle: 'Installation Complete!',
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
                                  'Installation completed! Opening maintenance mode.',
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
                  label: const Text('Finish & Go to Maintenance'),
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

  Widget _buildDismantlingGuideProgress() {
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
          title: 'Dismantling Guide Progress',
          completeTitle: 'Dismantling Complete!',
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
                                  'Dismantling completed! IDTM lifecycle finished.',
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
                  label: const Text('Complete Dismantling'),
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

  Widget _buildCompletedSummary() {
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
            'IDTM Lifecycle Completed!',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade900,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),

          // Description
          Text(
            'Installation, maintenance, and dismantling phases have been successfully completed.',
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
                label: 'Installed',
                color: Colors.green,
              ),
              _CompletionBadge(
                icon: Icons.settings,
                label: 'Maintained',
                color: Colors.blue,
              ),
              _CompletionBadge(
                icon: Icons.inventory_2,
                label: 'Dismantled',
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

            // Show progress based on current phase
            if (_currentPhase == FacilityInstallationPhase.installing ||
                _currentPhase == FacilityInstallationPhase.maintenance)
              _buildInstallationGuideProgress()
            else if (_currentPhase == FacilityInstallationPhase.dismantling)
              _buildDismantlingGuideProgress()
            else if (_currentPhase == FacilityInstallationPhase.completed)
              _buildCompletedSummary(),

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
