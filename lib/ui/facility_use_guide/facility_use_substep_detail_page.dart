import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:who_mobile_project/general/models/facility_use/facility_use_substep_model.dart';
import 'package:who_mobile_project/providers/facility_use/facility_use_provider.dart';

class FacilityUseSubstepDetailPage extends ConsumerWidget {
  final String stepId;
  final String substepId;

  const FacilityUseSubstepDetailPage({
    super.key,
    required this.stepId,
    required this.substepId,
  });

  /// Get color based on section id
  Color _getSectionColor(String sectionId) {
    if (sectionId == 'idtm-overview') {
      return Colors.teal;
    } else if (sectionId == 'operating-requirements') {
      return Colors.blue;
    } else if (sectionId == 'safety-warnings') {
      return Colors.red;
    } else if (sectionId == 'site-selection') {
      return Colors.green;
    }
    return Colors.blueGrey;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final facilityUseDataAsync = ref.watch(facilityUseDataProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail'),
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
            ],
          ),
        ),
        data: (facilityUseData) {
          final step = facilityUseData.sections.firstWhere(
            (section) => section.id == stepId,
            orElse: () => throw Exception('Step not found'),
          );

          // Only search in actual steps, not requirements
          final substeps = step.steps ?? [];
          final substep = substeps.firstWhere(
            (sub) => sub.id == substepId,
            orElse: () => FacilityUseSubstepModel(
              id: '',
              title: 'Not Found',
              content: [],
            ),
          );

          if (substep.id.isEmpty) {
            return const Center(child: Text('Subsection not found'));
          }

          final sectionColor = _getSectionColor(stepId);

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  color: sectionColor.withValues(alpha: 0.15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: sectionColor,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              substep.title,
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      if (substep.pdfStepReference != null) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.picture_as_pdf, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              'Reference: ${substep.pdfStepReference}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),

                // Purpose
                if (substep.purpose != null)
                  Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: sectionColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: sectionColor.withValues(alpha: 0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.info_outline, color: sectionColor),
                            const SizedBox(width: 8),
                            Text(
                              'Purpose',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: sectionColor,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          substep.purpose!,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),

                // Images
                if (substep.images != null && substep.images!.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'Images',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 220,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: substep.images!.length,
                          itemBuilder: (context, index) {
                            final image = substep.images![index];
                            final imagePath = ref
                                .read(facilityUseDataProvider.notifier)
                                .getImagePath(image.filename);

                            return Card(
                              margin: const EdgeInsets.only(right: 12),
                              child: Container(
                                width: 280,
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Image.asset(
                                        imagePath,
                                        fit: BoxFit.contain,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                              return Center(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    const Icon(
                                                      Icons.broken_image,
                                                      size: 48,
                                                    ),
                                                    const SizedBox(height: 8),
                                                    Text(
                                                      'Image not found',
                                                      style: Theme.of(
                                                        context,
                                                      ).textTheme.bodySmall,
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      image.description ?? "-",
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodySmall,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),

                // Content
                if (substep.content.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Details',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        ...substep.content.map(
                          (item) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  '• ',
                                  style: TextStyle(fontSize: 20),
                                ),
                                Expanded(
                                  child: Text(
                                    item,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyLarge,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Actions
                if (substep.actions != null && substep.actions!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Actions',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        ...substep.actions!.asMap().entries.map((entry) {
                          final index = entry.key;
                          final action = entry.value;
                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.orange.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.orange.shade200),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 12,
                                  backgroundColor: Colors.orange,
                                  child: Text(
                                    '${index + 1}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    action,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),

                // Warnings
                if (substep.warnings != null && substep.warnings!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Warnings',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                        ),
                        const SizedBox(height: 12),
                        ...substep.warnings!.map(
                          (warning) => Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.red.shade200),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.warning,
                                  color: Colors.red,
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    warning,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }
}
