import 'package:flutter/material.dart';
import 'package:who_mobile_project/app_core/theme/colors.dart';

/// A simple placeholder widget for sections under development
class SectionPlaceholder extends StatelessWidget {
  final String text;
  final double? height;
  final EdgeInsets? padding;

  const SectionPlaceholder({
    super.key,
    required this.text,
    this.height,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: GVColors.lightGreyBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: GVColors.borderGrey,
          width: 1,
        ),
      ),
      child: Center(
        child: Text(
          text,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: GVColors.textGrey,
                fontWeight: FontWeight.w500,
              ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
