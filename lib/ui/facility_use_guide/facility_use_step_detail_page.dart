import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:who_mobile_project/general/models/facility_use/facility_use_step_model.dart';
import 'package:who_mobile_project/providers/facility_use/facility_use_provider.dart';
import 'package:who_mobile_project/routing_config/routes.dart';

class FacilityUseStepDetailPage extends ConsumerWidget {
  final String stepId;

  const FacilityUseStepDetailPage({super.key, required this.stepId});

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
      appBar: AppBar(title: const Text('Section Detail')),
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
            orElse: () => FacilityUseStepModel(id: '', title: 'Not Found'),
          );

          if (step.id.isEmpty) {
            return const Center(child: Text('Section not found'));
          }

          final substeps = step.steps ?? [];
          final sectionColor = _getSectionColor(step.id);

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with title
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  color: sectionColor.withValues(alpha: 0.15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        step.title,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
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
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: sectionColor.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            '${substeps.length} subsection${substeps.length > 1 ? 's' : ''}',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: sectionColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
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
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
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
                                .read(facilityUseDataProvider.notifier)
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

                // Requirements Section
                if (step.requirements != null && step.requirements!.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'Requirements',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 12),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: step.requirements!.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final requirement = step.requirements![index];

                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.check_circle_outline,
                                        color: sectionColor,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          requirement.title,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),

                                  // Requirement Images
                                  if (requirement.images != null && requirement.images!.isNotEmpty) ...[
                                    const SizedBox(height: 12),
                                    SizedBox(
                                      height: 180,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: requirement.images!.length,
                                        itemBuilder: (context, imgIndex) {
                                          final image = requirement.images![imgIndex];
                                          final imagePath = ref
                                              .read(facilityUseDataProvider.notifier)
                                              .getImagePath(image.filename);

                                          return Card(
                                            margin: const EdgeInsets.only(right: 12),
                                            child: Container(
                                              width: 200,
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
                                                            return const Center(
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment.center,
                                                                children: [
                                                                  Icon(
                                                                    Icons.broken_image,
                                                                    size: 32,
                                                                  ),
                                                                  SizedBox(height: 4),
                                                                  Text(
                                                                    'Image not found',
                                                                    style: TextStyle(fontSize: 10),
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                          },
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    image.description ?? "-",
                                                    style: Theme.of(context).textTheme.bodySmall,
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
                                    const SizedBox(height: 12),
                                  ],

                                  ...requirement.content.map(
                                    (item) => Padding(
                                      padding: const EdgeInsets.only(
                                        left: 28,
                                        bottom: 4,
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text('• '),
                                          Expanded(
                                            child: Text(
                                              item,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
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
                          'Subsections',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
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

                          return Card(
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: sectionColor,
                                child: Text(
                                  '${index + 1}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
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
                                  YRRoutes.facilityUseSubstepDetail
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
