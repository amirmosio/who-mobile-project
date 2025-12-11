import 'package:flutter/material.dart';
import 'package:who_mobile_project/app_core/theme/colors.dart';
import 'package:who_mobile_project/app_core/theme/text_styles/app_text_styles.dart';
import 'package:who_mobile_project/generated/i18n/app_localizations.dart';

class InfoWidget extends StatelessWidget {
  /// The color of the info icon
  final Color color;

  /// The title displayed in the dialog
  final String title;

  /// The description displayed in the dialog
  final String description;

  /// The size of the info icon (default: 20.0)
  final double iconSize;

  /// Whether the dialog can be dismissed by tapping outside (default: true)
  final bool barrierDismissible;

  const InfoWidget({
    super.key,
    required this.color,
    required this.title,
    required this.description,
    this.iconSize = 20.0,
    this.barrierDismissible = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showInfoDialog(context),
      child: Icon(Icons.info_outline, color: color, size: iconSize),
    );
  }

  /// Shows the info dialog with title and description
  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) {
        return PopScope(
          canPop: barrierDismissible,
          child: Material(
            color: GVColors.transparent,
            child: InkWell(
              onTap: () {
                Navigator.maybePop(context);
              },
              child: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      constraints: const BoxConstraints(
                        minHeight: 100,
                        minWidth: 280,
                        maxWidth: 320,
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 24,
                        horizontal: 20,
                      ),
                      margin: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 20,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: GVColors.white,
                        boxShadow: [
                          BoxShadow(
                            color: GVColors.blackWithAlpha10,
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Info icon
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.info_outline,
                              color: color,
                              size: 24,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Title
                          Text(
                            title,
                            textAlign: TextAlign.center,
                            style: AppTextStyles.headingH3.copyWith(
                              color: GVColors.darkTextBlack,
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Description
                          Text(
                            description,
                            textAlign: TextAlign.center,
                            style: AppTextStyles.bodyText.copyWith(
                              color: GVColors.textGrey,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Close button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () => Navigator.maybePop(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: color,
                                foregroundColor: GVColors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                AppLocalizations.of(context)!.close,
                                style: AppTextStyles.buttonSmall.copyWith(
                                  color: GVColors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

Future<T?> showInfoDialog<T>(
  BuildContext context, {
  required Color color,
  required String title,
  required String description,
  bool barrierDismissible = true,
}) {
  return showDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (context) {
      return PopScope(
        canPop: barrierDismissible,
        child: Material(
          color: GVColors.transparent,
          child: InkWell(
            onTap: () {
              Navigator.maybePop(context);
            },
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    constraints: const BoxConstraints(
                      minHeight: 100,
                      minWidth: 280,
                      maxWidth: 320,
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 24,
                      horizontal: 20,
                    ),
                    margin: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 20,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: GVColors.white,
                      boxShadow: [
                        BoxShadow(
                          color: GVColors.blackWithAlpha10,
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Info icon
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.info_outline,
                            color: color,
                            size: 24,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Title
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.headingH3.copyWith(
                            color: GVColors.darkTextBlack,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Description
                        Text(
                          description,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodyText.copyWith(
                            color: GVColors.textGrey,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Close button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => Navigator.maybePop(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: color,
                              foregroundColor: GVColors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              AppLocalizations.of(context)!.close,
                              style: AppTextStyles.buttonSmall.copyWith(
                                color: GVColors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
