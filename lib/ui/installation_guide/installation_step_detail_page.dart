import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:who_mobile_project/general/models/installation/installation_step_model.dart';
import 'package:who_mobile_project/providers/installation/installation_provider.dart';
import 'package:who_mobile_project/routing_config/routes.dart';

class InstallationStepDetailPage extends ConsumerWidget {
  final String stepId;

  const InstallationStepDetailPage({
    super.key,
    required this.stepId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final installationDataAsync = ref.watch(installationDataProvider);
    final flattenedList = ref.watch(flattenedSubstepsProvider);
    final lastCompletedIndex = ref.watch(installationProgressProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Step Detail'),
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
            ],
          ),
        ),
        data: (installationData) {
          final step = installationData.sections.firstWhere(
            (section) => section.id == stepId,
            orElse: () => InstallationStepModel(
              id: '',
              title: 'Not Found',
            ),
          );

          if (step.id.isEmpty) {
            return const Center(
              child: Text('Step not found'),
            );
          }

          final substeps = step.allSubsteps;

          // Find substeps in flattened list for this section
          final sectionSubsteps =
              flattenedList.where((item) => item.stepId == step.id).toList();

          final completedSubsteps = sectionSubsteps
              .where((item) => item.globalIndex <= lastCompletedIndex)
              .length;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with title and progress
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        step.title,
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      if (step.pdfReference != null) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.picture_as_pdf, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              'Reference: ${step.pdfReference}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ],
                      if (substeps.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: LinearProgressIndicator(
                                value: substeps.isEmpty
                                    ? 0
                                    : completedSubsteps / substeps.length,
                                minHeight: 8,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              '$completedSubsteps/${substeps.length}',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),

                // Description
                if (step.description != null)
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      step.description!,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),

                // Images
                if (step.images != null && step.images!.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'Images',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 200,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: step.images!.length,
                          itemBuilder: (context, index) {
                            final image = step.images![index];
                            final imagePath = ref
                                .read(installationDataProvider.notifier)
                                .getImagePath(image.filename);

                            return Card(
                              margin: const EdgeInsets.only(right: 12),
                              child: Container(
                                width: 250,
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
                                                const Icon(Icons.broken_image,
                                                    size: 48),
                                                const SizedBox(height: 8),
                                                Text(
                                                  'Image not found',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall,
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      image.description,
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
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

                // Substeps List
                if (substeps.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'Steps',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: substeps.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final substep = substeps[index];
                          final flattenedItem = sectionSubsteps
                              .firstWhere((item) => item.substepId == substep.id);
                          final isCompleted =
                              flattenedItem.globalIndex <= lastCompletedIndex;

                          return Card(
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: isCompleted
                                    ? Colors.green
                                    : Theme.of(context).colorScheme.primary,
                                child: isCompleted
                                    ? const Icon(Icons.check,
                                        color: Colors.white)
                                    : Text(
                                        '${index + 1}',
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                              ),
                              title: Text(substep.title),
                              subtitle: substep.purpose != null
                                  ? Text(
                                      substep.purpose!,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  : null,
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () {
                                context.push(
                                  YRRoutes.installationSubstepDetail
                                      .replaceFirst(':stepId', step.id)
                                      .replaceFirst(':substepId', substep.id),
                                );
                              },
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
