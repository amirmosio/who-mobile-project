import 'package:flutter/material.dart';

/// Reusable progress card widget for displaying progress tracking
/// Used for installation and dismantling guides
class ProgressCardWidget extends StatelessWidget {
  final String title;
  final String completeTitle;
  final int completedCount;
  final int totalCount;
  final double progress;
  final bool isComplete;
  final Color progressColor;
  final Color completeColor;
  final Color backgroundColor;
  final Widget? actionButton;

  const ProgressCardWidget({
    super.key,
    required this.title,
    required this.completeTitle,
    required this.completedCount,
    required this.totalCount,
    required this.progress,
    required this.isComplete,
    required this.progressColor,
    required this.completeColor,
    required this.backgroundColor,
    this.actionButton,
  });

  Color _getProgressBarColor() {
    if (isComplete) return completeColor;
    if (progress > 0.7) {
      return progressColor.withValues(alpha: 0.7);
    }
    if (progress > 0.3) {
      return Colors.orange;
    }
    return progressColor;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and percentage
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  isComplete ? completeTitle : title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isComplete ? completeColor : null,
                  ),
                ),
              ),
              if (isComplete)
                Icon(Icons.check_circle, color: completeColor, size: 20)
              else
                Text(
                  '${(progress * 100).toStringAsFixed(0)}%',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: progress > 0 ? progressColor : Colors.grey,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),

          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(_getProgressBarColor()),
            ),
          ),
          const SizedBox(height: 6),

          // Subtitle
          Text(
            '$completedCount of $totalCount steps completed',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
          ),

          // Optional action button
          if (actionButton != null) ...[
            const SizedBox(height: 12),
            SizedBox(width: double.infinity, child: actionButton),
          ],
        ],
      ),
    );
  }
}
