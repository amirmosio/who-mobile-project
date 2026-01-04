import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:who_mobile_project/general/models/installation/flattened_substep_model.dart';
import 'package:who_mobile_project/general/models/installation/installation_step_model.dart';
import 'package:who_mobile_project/routing_config/routes.dart';

class InstallationStepItem extends StatelessWidget {
  final InstallationStepModel section;
  final int index;
  final bool isExpanded;
  final int completedSubsteps;
  final List<FlattenedSubstepModel> sectionSubsteps;
  final int lastCompletedIndex;
  final VoidCallback onExpandToggle;

  const InstallationStepItem({
    super.key,
    required this.section,
    required this.index,
    required this.isExpanded,
    required this.completedSubsteps,
    required this.sectionSubsteps,
    required this.lastCompletedIndex,
    required this.onExpandToggle,
  });

  @override
  Widget build(BuildContext context) {
    final substeps = section.steps ?? [];

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              context.push(
                YRRoutes.installationStepDetail.replaceFirst(
                  ':stepId',
                  section.id,
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Leading avatar
                  CircleAvatar(
                    radius: 18,
                    backgroundColor:
                        completedSubsteps == substeps.length &&
                            substeps.isNotEmpty
                        ? Colors.green
                        : Theme.of(context).colorScheme.primary,
                    child:
                        completedSubsteps == substeps.length &&
                            substeps.isNotEmpty
                        ? const Icon(Icons.check, color: Colors.white, size: 18)
                        : Text(
                            '${index + 1}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          ),
                  ),
                  const SizedBox(width: 12),

                  // Content (title and subtitle)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          section.title,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        if (substeps.isNotEmpty) ...[
                          const SizedBox(height: 3),
                          if (section.description != null)
                            Text(
                              section.description!,
                              maxLines: isExpanded ? null : 2,
                              overflow: isExpanded
                                  ? null
                                  : TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Expanded(
                                child: LinearProgressIndicator(
                                  value: substeps.isEmpty
                                      ? 0
                                      : completedSubsteps / substeps.length,
                                  minHeight: 3,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '$completedSubsteps/${substeps.length}',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ] else if (section.description != null) ...[
                          const SizedBox(height: 3),
                          Text(
                            section.description!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Trailing icon
                  IconButton(
                    iconSize: 24,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 40,
                      minHeight: 40,
                    ),
                    color: substeps.isEmpty
                        ? Colors.grey.shade400
                        : Colors.black,
                    icon: Icon(
                      isExpanded ? Icons.expand_less : Icons.expand_more,
                    ),
                    onPressed: substeps.isEmpty ? null : onExpandToggle,
                  ),
                ],
              ),
            ),
          ),

          // Substeps list (when expanded)
          if (isExpanded && substeps.isNotEmpty)
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.only(left: 12, right: 12, bottom: 6),
              itemCount: substeps.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, substepIndex) {
                final substep = substeps[substepIndex];
                final flattenedItem = sectionSubsteps.firstWhere(
                  (item) => item.substepId == substep.id,
                );
                final isCompleted =
                    flattenedItem.globalIndex <= lastCompletedIndex;

                return ListTile(
                  dense: true,
                  visualDensity: VisualDensity.compact,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 0,
                  ),
                  leading: Icon(
                    isCompleted
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                    size: 20,
                    color: isCompleted ? Colors.green : Colors.grey,
                  ),
                  title: Text(
                    substep.title,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  trailing: const Icon(Icons.chevron_right, size: 18),
                  onTap: () {
                    context.push(
                      YRRoutes.installationSubstepDetail
                          .replaceFirst(':stepId', section.id)
                          .replaceFirst(':substepId', substep.id),
                    );
                  },
                );
              },
            ),
        ],
      ),
    );
  }
}
