import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:who_mobile_project/app_core/theme/colors.dart';
import 'package:who_mobile_project/providers/installation/installation_provider.dart';
import 'package:who_mobile_project/routing_config/routes.dart';

/// Dashboard card for accessing Installation Guide with progress tracking
class InstallationGuideCard extends ConsumerWidget {
  const InstallationGuideCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final installationDataAsync = ref.watch(installationDataProvider);
    final lastCompletedIndex = ref.watch(installationProgressProvider);

    return installationDataAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (installationData) {
        final flattenedList = ref.watch(flattenedSubstepsProvider);
        final totalSubsteps = flattenedList.length;
        final progress = totalSubsteps > 0
            ? ((lastCompletedIndex + 1) / totalSubsteps).clamp(0.0, 1.0)
            : 0.0;
        final completedCount = lastCompletedIndex + 1;

        return Card(
          elevation: 2,
          margin: const EdgeInsets.all(16),
          child: InkWell(
            onTap: () => context.push(YRRoutes.installationStepsList),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.engineering,
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
                              'Installation Guide',
                              style:
                                  Theme.of(context).textTheme.titleLarge?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              installationData.title,
                              style:
                                  Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: Colors.grey[600],
                                      ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 20,
                        color: Colors.grey[400],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Progress section
                  if (totalSubsteps > 0) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: progress > 0
                            ? Colors.green.shade50
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
                                'Progress',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              Text(
                                '${(progress * 100).toStringAsFixed(0)}%',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: progress > 0
                                          ? Colors.green
                                          : Colors.grey,
                                    ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: progress,
                              minHeight: 8,
                              backgroundColor: Colors.grey.shade200,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                progress > 0.7
                                    ? Colors.green
                                    : progress > 0.3
                                        ? Colors.orange
                                        : Colors.blue,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '$completedCount of $totalSubsteps steps completed',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.grey[600],
                                ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],

                  // Quick info
                  Row(
                    children: [
                      _InfoChip(
                        icon: Icons.layers,
                        label: '${installationData.sections.length} Sections',
                      ),
                      const SizedBox(width: 8),
                      _InfoChip(
                        icon: Icons.image,
                        label: '${installationData.totalImages} Images',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: BZColors.bronzeDark.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: BZColors.bronzeDark,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: BZColors.bronzeDark,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ),
    );
  }
}
