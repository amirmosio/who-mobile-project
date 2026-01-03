import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:who_mobile_project/providers/installation/installation_provider.dart';
import 'package:who_mobile_project/routing_config/routes.dart';

class InstallationStepsListPage extends ConsumerStatefulWidget {
  const InstallationStepsListPage({super.key});

  @override
  ConsumerState<InstallationStepsListPage> createState() =>
      _InstallationStepsListPageState();
}

class _InstallationStepsListPageState
    extends ConsumerState<InstallationStepsListPage> {
  final Set<String> _expandedSteps = {};

  @override
  Widget build(BuildContext context) {
    final installationDataAsync = ref.watch(installationDataProvider);
    final flattenedList = ref.watch(flattenedSubstepsProvider);
    final lastCompletedIndex = ref.watch(installationProgressProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Installation Guide'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(installationDataProvider.notifier).refresh();
            },
          ),
        ],
      ),
      body: installationDataAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref.read(installationDataProvider.notifier).refresh();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (installationData) {
          final sections = installationData.sections;
          final totalSubsteps = flattenedList.length;
          final progress = ref
              .read(installationProgressProvider.notifier)
              .getOverallProgress(totalSubsteps);

          return Column(
            children: [
              // Progress indicator
              if (totalSubsteps > 0)
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Overall Progress',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            '${(progress * 100).toStringAsFixed(0)}%',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: progress,
                        minHeight: 8,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${lastCompletedIndex + 1} of $totalSubsteps steps completed',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),

              // Steps list
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: sections.length,
                  itemBuilder: (context, index) {
                    final section = sections[index];
                    final isExpanded = _expandedSteps.contains(section.id);
                    final substeps = section.allSubsteps;

                    // Find substeps in flattened list for this section
                    final sectionSubsteps = flattenedList
                        .where((item) => item.stepId == section.id)
                        .toList();

                    final completedSubsteps = sectionSubsteps
                        .where((item) => item.globalIndex <= lastCompletedIndex)
                        .length;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Column(
                        children: [
                          ListTile(
                            leading: CircleAvatar(
                              backgroundColor:
                                  completedSubsteps == substeps.length &&
                                          substeps.isNotEmpty
                                      ? Colors.green
                                      : Theme.of(context).colorScheme.primary,
                              child: completedSubsteps == substeps.length &&
                                      substeps.isNotEmpty
                                  ? const Icon(Icons.check, color: Colors.white)
                                  : Text(
                                      '${index + 1}',
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                            ),
                            title: Text(
                              section.title,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            subtitle: substeps.isNotEmpty
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 4),
                                      if (section.description != null)
                                        Text(
                                          section.description!,
                                          maxLines: isExpanded ? null : 2,
                                          overflow: isExpanded
                                              ? null
                                              : TextOverflow.ellipsis,
                                        ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: LinearProgressIndicator(
                                              value: substeps.isEmpty
                                                  ? 0
                                                  : completedSubsteps /
                                                      substeps.length,
                                              minHeight: 4,
                                              borderRadius:
                                                  BorderRadius.circular(2),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            '$completedSubsteps/${substeps.length}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall,
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                                : section.description != null
                                    ? Text(
                                        section.description!,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      )
                                    : null,
                            trailing: substeps.isNotEmpty
                                ? Icon(
                                    isExpanded
                                        ? Icons.expand_less
                                        : Icons.expand_more,
                                  )
                                : const Icon(Icons.chevron_right),
                            onTap: () {
                              if (substeps.isNotEmpty) {
                                setState(() {
                                  if (isExpanded) {
                                    _expandedSteps.remove(section.id);
                                  } else {
                                    _expandedSteps.add(section.id);
                                  }
                                });
                              } else {
                                // Navigate to step detail if no substeps
                                context.push(
                                  YRRoutes.installationStepDetail.replaceFirst(
                                    ':stepId',
                                    section.id,
                                  ),
                                );
                              }
                            },
                          ),

                          // Substeps list (when expanded)
                          if (isExpanded && substeps.isNotEmpty)
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.only(
                                left: 16,
                                right: 16,
                                bottom: 8,
                              ),
                              itemCount: substeps.length,
                              separatorBuilder: (context, index) =>
                                  const Divider(height: 1),
                              itemBuilder: (context, substepIndex) {
                                final substep = substeps[substepIndex];
                                final flattenedItem = sectionSubsteps
                                    .firstWhere((item) =>
                                        item.substepId == substep.id);
                                final isCompleted = flattenedItem.globalIndex <=
                                    lastCompletedIndex;

                                return ListTile(
                                  dense: true,
                                  leading: Icon(
                                    isCompleted
                                        ? Icons.check_circle
                                        : Icons.radio_button_unchecked,
                                    color: isCompleted
                                        ? Colors.green
                                        : Colors.grey,
                                  ),
                                  title: Text(substep.title),
                                  trailing: const Icon(
                                    Icons.chevron_right,
                                    size: 20,
                                  ),
                                  onTap: () {
                                    context.push(
                                      YRRoutes.installationSubstepDetail
                                          .replaceFirst(':stepId', section.id)
                                          .replaceFirst(
                                              ':substepId', substep.id),
                                    );
                                  },
                                );
                              },
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
