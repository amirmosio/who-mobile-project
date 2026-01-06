import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:who_mobile_project/providers/maintenance_guide/maintenance_provider.dart';
import 'package:who_mobile_project/ui/maintenance_guide/widgets/maintenance_step_item.dart';

class MaintenanceStepsListPage extends ConsumerStatefulWidget {
  const MaintenanceStepsListPage({super.key});

  @override
  ConsumerState<MaintenanceStepsListPage> createState() =>
      _MaintenanceStepsListPageState();
}

class _MaintenanceStepsListPageState
    extends ConsumerState<MaintenanceStepsListPage> {
  final Set<String> _expandedSteps = {};

  @override
  Widget build(BuildContext context) {
    final maintenanceDataAsync = ref.watch(maintenanceDataProvider);
    final flattenedList = ref.watch(flattenedMaintenanceSubstepsProvider);
    final lastCompletedIndex = ref.watch(maintenanceProgressProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Maintenance Guide'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(maintenanceDataProvider.notifier).refresh();
            },
          ),
        ],
      ),
      body: maintenanceDataAsync.when(
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
                  ref.read(maintenanceDataProvider.notifier).refresh();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (maintenanceData) {
          final sections = maintenanceData.sections;
          final totalSubsteps = flattenedList.length;
          final progress = ref
              .read(maintenanceProgressProvider.notifier)
              .getOverallProgress(totalSubsteps);

          return Column(
            children: [
              // Progress indicator
              if (totalSubsteps > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  color: Colors.green.shade600,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Overall Progress',
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '${(progress * 100).toStringAsFixed(0)}%',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      LinearProgressIndicator(
                        value: progress,
                        minHeight: 6,
                        borderRadius: BorderRadius.circular(3),
                        backgroundColor: Colors.white.withValues(alpha: 0.3),
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${lastCompletedIndex + 1} of $totalSubsteps steps completed',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
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

                    return MaintenanceStepItem(
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
