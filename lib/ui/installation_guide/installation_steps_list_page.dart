import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:who_mobile_project/providers/installation/installation_provider.dart';
import 'package:who_mobile_project/ui/installation_guide/widgets/installation_step_item.dart';

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
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Overall Progress',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          Text(
                            '${(progress * 100).toStringAsFixed(0)}%',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      LinearProgressIndicator(
                        value: progress,
                        minHeight: 6,
                        borderRadius: BorderRadius.circular(3),
                      ),
                      const SizedBox(height: 3),
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
                  padding: const EdgeInsets.all(8),
                  itemCount: sections.length,
                  itemBuilder: (context, index) {
                    final section = sections[index];
                    final isExpanded = _expandedSteps.contains(section.id);

                    // Find substeps in flattened list for this section
                    final sectionSubsteps = flattenedList
                        .where((item) => item.stepId == section.id)
                        .toList();

                    final completedSubsteps = sectionSubsteps
                        .where((item) => item.globalIndex <= lastCompletedIndex)
                        .length;

                    return InstallationStepItem(
                      section: section,
                      index: index,
                      isExpanded: isExpanded,
                      completedSubsteps: completedSubsteps,
                      sectionSubsteps: sectionSubsteps,
                      lastCompletedIndex: lastCompletedIndex,
                      onExpandToggle: () {
                        setState(() {
                          if (isExpanded) {
                            _expandedSteps.remove(section.id);
                          } else {
                            _expandedSteps.add(section.id);
                          }
                        });
                      },
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
