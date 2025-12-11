import 'package:flutter/material.dart';
import 'package:who_mobile_project/app_core/theme/colors.dart';
import "package:who_mobile_project/app_core/theme/text_styles/app_text_styles.dart";

class ReviewSectionWidget extends StatelessWidget {
  final VoidCallback? onTap;
  final EdgeInsets? margin;
  final String title;
  final String subtitle;

  const ReviewSectionWidget({
    super.key,
    required this.onTap,
    required this.title,
    required this.subtitle,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 12),
      height: 58,
      width: double.infinity,
      decoration: BoxDecoration(
        color: GVColors.yellowWarning,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.smallTextBold.copyWith(
                          color: GVColors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: AppTextStyles.subtitleTextLight.copyWith(
                          color: GVColors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 18,
                  height: 18,
                  child: Icon(Icons.arrow_forward_ios_rounded),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
