import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:who_mobile_project/general/models/installation/installation_substep_model.dart';
import 'package:who_mobile_project/general/widgets/next_prev_navigation_widget.dart';
import 'package:who_mobile_project/providers/installation/installation_provider.dart';

class InstallationSubstepDetailPage extends ConsumerStatefulWidget {
  final String stepId;
  final String substepId;

  const InstallationSubstepDetailPage({
    super.key,
    required this.stepId,
    required this.substepId,
  });

  @override
  ConsumerState<InstallationSubstepDetailPage> createState() =>
      _InstallationSubstepDetailPageState();
}

class _InstallationSubstepDetailPageState
    extends ConsumerState<InstallationSubstepDetailPage> {
  @override
  void initState() {
    super.initState();
    _markAsCompleted();
  }

  @override
  void didUpdateWidget(InstallationSubstepDetailPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Mark as completed when substep changes (e.g., via next/previous navigation)
    if (oldWidget.stepId != widget.stepId ||
        oldWidget.substepId != widget.substepId) {
      _markAsCompleted();
    }
  }

  void _markAsCompleted() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final flattenedList = ref.read(flattenedSubstepsProvider);
      final currentItem = flattenedList.firstWhere(
        (item) =>
            item.stepId == widget.stepId && item.substepId == widget.substepId,
        orElse: () => flattenedList.first,
      );

      final currentIndex = currentItem.globalIndex;
      final lastCompletedIndex = ref.read(installationProgressProvider);

      // Only update if this substep is not already completed
      if (currentIndex > lastCompletedIndex) {
        ref
            .read(installationProgressProvider.notifier)
            .markSubstepCompletedByIndex(currentIndex);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final installationDataAsync = ref.watch(installationDataProvider);
    final flattenedList = ref.watch(flattenedSubstepsProvider);
    final lastCompletedIndex = ref.watch(installationProgressProvider);
    final navigationInfo = ref.watch(
      installationSubstepNavigationProvider(widget.stepId, widget.substepId),
    );

    // Find the current substep in the flattened list
    final currentItem = flattenedList.firstWhere(
      (item) =>
          item.stepId == widget.stepId && item.substepId == widget.substepId,
      orElse: () => flattenedList.first,
    );

    final isCompleted = currentItem.globalIndex <= lastCompletedIndex;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Step Detail'),
        actions: [
          // Manual completion toggle button
          IconButton(
            icon: Icon(
              isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
              color: isCompleted ? Colors.green : null,
            ),
            onPressed: () {
              if (isCompleted) {
                // Mark as incomplete by setting progress to one step before
                final newIndex = currentItem.globalIndex - 1;
                ref
                    .read(installationProgressProvider.notifier)
                    .markSubstepCompletedByIndex(newIndex);
              } else {
                // Mark as complete
                ref
                    .read(installationProgressProvider.notifier)
                    .markSubstepCompletedByIndex(currentItem.globalIndex);
              }
            },
            tooltip: isCompleted ? 'Mark as incomplete' : 'Mark as complete',
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
            ],
          ),
        ),
        data: (installationData) {
          final step = installationData.sections.firstWhere(
            (section) => section.id == widget.stepId,
            orElse: () => throw Exception('Step not found'),
          );

          // Only search in actual steps, not requirements
          final substeps = step.steps ?? [];
          final substep = substeps.firstWhere(
            (sub) => sub.id == widget.substepId,
            orElse: () => InstallationSubstepModel(
              id: '',
              title: 'Not Found',
              content: [],
            ),
          );

          if (substep.id.isEmpty) {
            return const Center(child: Text('Substep not found'));
          }

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                // Header with completion status
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  color: isCompleted
                      ? Colors.green.shade100
                      : Theme.of(context).colorScheme.primaryContainer,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            isCompleted
                                ? Icons.check_circle
                                : Icons.pending_actions,
                            color: isCompleted ? Colors.green : null,
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.picture_as_pdf, size: 16),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                'Reference: ${substep.pdfStepReference}',
                                style: Theme.of(context).textTheme.bodySmall,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                      if (isCompleted) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.check, color: Colors.white, size: 16),
                              SizedBox(width: 4),
                              Text(
                                'Completed',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
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
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.info_outline, color: Colors.blue),
                            const SizedBox(width: 8),
                            Text(
                              'Purpose',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue.shade900,
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
                                .read(installationDataProvider.notifier)
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
                ),
              ),
              // Next/Prev Navigation Widget
              NextPrevNavigationWidget(
                previousLabel: 'Previous',
                nextLabel: navigationInfo.nextLabel ?? 'Next',
                onPrevious: navigationInfo.previousRoute != null
                    ? () => context.pushReplacement(navigationInfo.previousRoute!)
                    : null,
                onNext: navigationInfo.nextRoute != null
                    ? () => context.pushReplacement(navigationInfo.nextRoute!)
                    : null,
              ),
            ],
          );
        },
      ),
    );
  }
}
