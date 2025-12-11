import 'package:flutter/material.dart';
import 'package:who_mobile_project/app_core/theme/colors.dart';

class MyProgressBar extends StatelessWidget {
  /// The progress value (0.0 to 1.0)
  final double progress;

  /// The height of the progress bar (default: 10)
  final double height;

  /// The border radius of the progress bar (default: 3)
  final double borderRadius;

  /// Whether to show the percentage text (default: false)
  final bool showPercentage;

  /// Custom background color (default: orange with alpha)
  final Color? backgroundColor;

  /// Custom progress color (default: orange)
  final Color? progressColor;

  /// Custom text style for percentage (optional)
  final TextStyle? percentageTextStyle;

  /// Animation for the progress bar (optional)
  final Animation<double>? animation;

  const MyProgressBar({
    super.key,
    required this.progress,
    this.height = 10,
    this.borderRadius = 3,
    this.showPercentage = false,
    this.backgroundColor,
    this.progressColor,
    this.percentageTextStyle,
    this.animation,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentProgress = animation?.value ?? progress;

    // Default colors following app theme
    final defaultBackgroundColor =
        backgroundColor ?? GVColors.orangeWithAlpha20; // rgba(242,153,21,0.2)
    final defaultProgressColor = progressColor ?? GVColors.orange;

    final progressBar = Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: defaultBackgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: currentProgress.clamp(0.0, 1.0),
        child: Container(
          decoration: BoxDecoration(
            color: defaultProgressColor,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
      ),
    );

    if (!showPercentage) {
      return progressBar;
    }

    // Return progress bar with percentage text
    return Row(
      children: [
        Expanded(child: progressBar),
        const SizedBox(width: 16),
        Text(
          '${(currentProgress * 100).round()}%',
          style:
              percentageTextStyle ??
              theme.textTheme.bodyMedium?.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: defaultProgressColor,
                height: 1.2,
              ),
        ),
      ],
    );
  }
}

/// A specialized progress bar for small items (like topic cards)
class MySmallProgressBar extends StatelessWidget {
  final double progress;
  final Color? backgroundColor;
  final Color? progressColor;

  const MySmallProgressBar({
    super.key,
    required this.progress,
    this.backgroundColor,
    this.progressColor,
  });

  @override
  Widget build(BuildContext context) {
    return MyProgressBar(
      progress: progress,
      height: 7,
      borderRadius: 2.849,
      backgroundColor:
          backgroundColor ?? GVColors.orangeWithAlpha, // For small items
      progressColor: progressColor ?? GVColors.orange,
    );
  }
}

/// A specialized progress bar for auth pages with animation
class MyAuthProgressBar extends StatelessWidget {
  final Animation<double> animation;
  final Color? backgroundColor;
  final Color? progressColor;

  const MyAuthProgressBar({
    super.key,
    required this.animation,
    this.backgroundColor,
    this.progressColor,
  });

  @override
  Widget build(BuildContext context) {
    return MyProgressBar(
      progress: 0, // Animation value is used instead
      animation: animation,
      height: 10,
      borderRadius: 3,
      backgroundColor: backgroundColor ?? GVColors.borderGrey,
      progressColor: progressColor ?? GVColors.orange,
    );
  }
}

/// A specialized progress bar for cards with white theme
class MyCardProgressBar extends StatelessWidget {
  final double progress;
  final double height;

  const MyCardProgressBar({
    super.key,
    required this.progress,
    this.height = 16,
  });

  @override
  Widget build(BuildContext context) {
    return MyProgressBar(
      progress: progress,
      height: height,
      borderRadius: 5,
      backgroundColor: Colors.white.withValues(alpha: 0.4),
      progressColor: Colors.white,
    );
  }
}
