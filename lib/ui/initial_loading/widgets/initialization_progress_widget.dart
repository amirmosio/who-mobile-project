import 'package:flutter/material.dart';
import 'package:who_mobile_project/app_core/theme/colors.dart';
import 'package:who_mobile_project/generated/i18n/app_localizations.dart';
import 'package:who_mobile_project/ui/initial_loading/initialization_progress_controller.dart';

/// Widget that displays initialization progress using a controller
/// with shimmer animation and animated step labels
class InitializationProgressWidget extends StatelessWidget {
  final InitializationProgressController controller;

  const InitializationProgressWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, child) {
        final localizations = AppLocalizations.of(context);
        final stepLabel = localizations != null
            ? controller.currentStep.getLocalizedLabel(localizations)
            : '';

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Progress bar container
            Container(
              width: double.infinity,
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 40),
              decoration: BoxDecoration(
                color: GVColors.lightGreyBackground,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Stack(
                children: [
                  // Background progress
                  FractionallySizedBox(
                    widthFactor: controller.progress,
                    alignment: Alignment.centerLeft,
                    child: Container(
                      decoration: BoxDecoration(
                        color: GVColors.orange,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  // Shimmer effect
                  if (controller.progress > 0 && controller.progress < 1.0)
                    _ShimmerProgressEffect(progress: controller.progress),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Current step label with animated dots
            if (stepLabel.isNotEmpty) _AnimatedStepLabel(label: stepLabel),
          ],
        );
      },
    );
  }
}

/// Shimmer effect that animates across the progress bar
class _ShimmerProgressEffect extends StatefulWidget {
  final double progress;

  const _ShimmerProgressEffect({required this.progress});

  @override
  State<_ShimmerProgressEffect> createState() => _ShimmerProgressEffectState();
}

class _ShimmerProgressEffectState extends State<_ShimmerProgressEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(
      begin: -1.0,
      end: 2.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: FractionallySizedBox(
            widthFactor: widget.progress,
            alignment: Alignment.centerLeft,
            child: ShaderMask(
              shaderCallback: (bounds) {
                return LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: const [
                    Colors.transparent,
                    Colors.white54,
                    Colors.transparent,
                  ],
                  stops: [
                    _animation.value - 0.3,
                    _animation.value,
                    _animation.value + 0.3,
                  ].map((e) => e.clamp(0.0, 1.0)).toList(),
                ).createShader(bounds);
              },
              blendMode: BlendMode.srcATop,
              child: Container(
                decoration: BoxDecoration(
                  color: GVColors.orange,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Animated step label with three animated dots (. -> .. -> ...)
class _AnimatedStepLabel extends StatefulWidget {
  final String label;

  const _AnimatedStepLabel({required this.label});

  @override
  State<_AnimatedStepLabel> createState() => _AnimatedStepLabelState();
}

class _AnimatedStepLabelState extends State<_AnimatedStepLabel>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _dotsAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat();

    _dotsAnimation = StepTween(begin: 0, end: 3).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _dotsAnimation,
      builder: (context, child) {
        final activeDotsCount = _dotsAnimation.value;

        return Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: GVColors.textGrey,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            // Three dots with changing opacity
            for (int i = 0; i < 3; i++)
              Text(
                '.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: GVColors.textGrey.withValues(
                    alpha: i <= activeDotsCount ? 1.0 : 0.2,
                  ),
                  fontSize: 14,
                ),
              ),
          ],
        );
      },
    );
  }
}
