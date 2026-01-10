import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:who_mobile_project/general/models/facility_use/facility_use_step_model.dart';
import 'package:who_mobile_project/routing_config/routes.dart';

class FacilityUseStepItem extends StatelessWidget {
  final FacilityUseStepModel section;
  final int index;
  final bool isExpanded;
  final VoidCallback onExpandToggle;

  const FacilityUseStepItem({
    super.key,
    required this.section,
    required this.index,
    required this.isExpanded,
    required this.onExpandToggle,
  });

  /// Get icon based on section id
  IconData get _sectionIcon {
    if (section.id == 'idtm-overview') {
      return Icons.apartment_outlined;
    } else if (section.id == 'operating-requirements') {
      return Icons.build_outlined;
    } else if (section.id == 'safety-warnings') {
      return Icons.warning_amber_outlined;
    } else if (section.id == 'site-selection') {
      return Icons.place_outlined;
    }
    return Icons.info_outline;
  }

  /// Get color based on section id
  Color get _sectionColor {
    if (section.id == 'idtm-overview') {
      return Colors.teal;
    } else if (section.id == 'operating-requirements') {
      return Colors.blue;
    } else if (section.id == 'safety-warnings') {
      return Colors.red;
    } else if (section.id == 'site-selection') {
      return Colors.green;
    }
    return Colors.blueGrey;
  }

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
                YRRoutes.facilityUseStepDetail.replaceFirst(
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
                  // Leading avatar with section-specific icon and color
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: _sectionColor,
                    child: Icon(
                      _sectionIcon,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Content (title and description)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          section.title,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        if (section.description != null) ...[
                          const SizedBox(height: 3),
                          Text(
                            section.description!,
                            maxLines: isExpanded ? null : 2,
                            overflow: isExpanded ? null : TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                        if (substeps.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            '${substeps.length} subsection${substeps.length > 1 ? 's' : ''}',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: _sectionColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Expand/collapse button (only show if has substeps)
                  if (substeps.isNotEmpty)
                    IconButton(
                      iconSize: 24,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 40,
                        minHeight: 40,
                      ),
                      icon: Icon(
                        isExpanded ? Icons.expand_less : Icons.expand_more,
                      ),
                      onPressed: onExpandToggle,
                    )
                  else
                    const Icon(
                      Icons.chevron_right,
                      size: 24,
                      color: Colors.grey,
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

                return ListTile(
                  dense: true,
                  visualDensity: VisualDensity.compact,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 0,
                  ),
                  leading: CircleAvatar(
                    radius: 12,
                    backgroundColor: _sectionColor.withValues(alpha: 0.2),
                    child: Text(
                      '${substepIndex + 1}',
                      style: TextStyle(
                        fontSize: 11,
                        color: _sectionColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    substep.title,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  trailing: const Icon(Icons.chevron_right, size: 18),
                  onTap: () {
                    context.push(
                      YRRoutes.facilityUseSubstepDetail
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
