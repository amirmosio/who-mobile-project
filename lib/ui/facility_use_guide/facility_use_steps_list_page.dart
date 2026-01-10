import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:who_mobile_project/providers/facility_use/facility_use_provider.dart';
import 'package:who_mobile_project/ui/facility_use_guide/widgets/facility_use_step_item.dart';

class FacilityUseStepsListPage extends ConsumerStatefulWidget {
  const FacilityUseStepsListPage({super.key});

  @override
  ConsumerState<FacilityUseStepsListPage> createState() =>
      _FacilityUseStepsListPageState();
}

class _FacilityUseStepsListPageState
    extends ConsumerState<FacilityUseStepsListPage> {
  final Set<String> _expandedSections = {};

  @override
  Widget build(BuildContext context) {
    final facilityUseDataAsync = ref.watch(facilityUseDataProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Facility Use Guide'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(facilityUseDataProvider.notifier).refresh();
            },
          ),
        ],
      ),
      body: facilityUseDataAsync.when(
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
                  ref.read(facilityUseDataProvider.notifier).refresh();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (facilityUseData) {
          final sections = facilityUseData.sections;

          return Column(
            children: [
              // Header with brief description
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                color: Colors.teal.shade50,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.apartment_outlined,
                          color: Colors.teal.shade700,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'IDTM Facility Use & Functioning',
                            style:
                                Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.teal.shade900,
                                    ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Browse sections for operational guidance, safety warnings, and site selection requirements.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.teal.shade700,
                          ),
                    ),
                  ],
                ),
              ),

              // Sections list
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: sections.length,
                  itemBuilder: (context, index) {
                    final section = sections[index];
                    final isExpanded = _expandedSections.contains(section.id);

                    return FacilityUseStepItem(
                      section: section,
                      index: index,
                      isExpanded: isExpanded,
                      onExpandToggle: () {
                        setState(() {
                          if (isExpanded) {
                            _expandedSections.remove(section.id);
                          } else {
                            _expandedSections.add(section.id);
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
