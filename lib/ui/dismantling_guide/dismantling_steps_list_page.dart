import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:who_mobile_project/providers/dismantling/dismantling_provider.dart';
import 'package:who_mobile_project/ui/dismantling_guide/widgets/dismantling_step_item.dart';

class DismantlingStepsListPage extends ConsumerStatefulWidget {
  const DismantlingStepsListPage({super.key});

  @override
  ConsumerState<DismantlingStepsListPage> createState() =>
      _DismantlingStepsListPageState();
}

class _DismantlingStepsListPageState
    extends ConsumerState<DismantlingStepsListPage> {
  final Set<String> _expandedSteps = {};

  @override
  Widget build(BuildContext context) {
    final dismantlingDataAsync = ref.watch(dismantlingDataProvider);
    final flattenedList = ref.watch(flattenedDismantlingSubstepsProvider);
    final lastCompletedIndex = ref.watch(dismantlingProgressProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dismantling Guide'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(dismantlingDataProvider.notifier).refresh();
            },
          ),
        ],
      ),
      body: dismantlingDataAsync.when(
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
                  ref.read(dismantlingDataProvider.notifier).refresh();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (dismantlingData) {
          final sections = dismantlingData.sections;
          final totalSubsteps = flattenedList.length;
          final progress = ref
              .read(dismantlingProgressProvider.notifier)
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
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: Theme.of(context).colorScheme.onPrimaryContainer,
                            ),
                          ),
                          Text(
                            '${(progress * 100).toStringAsFixed(0)}%',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      LinearProgressIndicator(
                        value: progress,
                        minHeight: 6,
                        borderRadius: BorderRadius.circular(3),
                        backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer.withValues(alpha: 0.3),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${lastCompletedIndex + 1} of $totalSubsteps steps completed',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimaryContainer.withValues(alpha: 0.9),
                        ),
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

                    return DismantlingStepItem(
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
