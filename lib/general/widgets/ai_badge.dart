import 'package:flutter/material.dart';
import 'package:who_mobile_project/app_core/theme/colors.dart';

/// A small "AI" badge widget that can be overlaid on avatars to indicate AI functionality
class AIBadge extends StatelessWidget {
  const AIBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: GVColors.purpleAccent,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1)),
        ],
      ),
      child: Text(
        'AI',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
          fontSize: 10,
        ),
      ),
    );
  }
}
