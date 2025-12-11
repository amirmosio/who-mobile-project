import 'package:flutter/material.dart';
import 'package:who_mobile_project/app_core/theme/colors.dart';
import 'package:who_mobile_project/app_core/theme/text_styles/app_text_styles.dart';

Future<T?> showErrorDialog<T>(
  BuildContext context,
  dynamic content, {
  bool barrierDismissible = true,
  Function()? onButtonTap,
  String? buttonText,
}) {
  assert(
    (onButtonTap == null && buttonText == null) ||
        (onButtonTap != null && buttonText != null),
  );

  // Convert String to Widget if needed
  Widget contentWidget;
  if (content is String) {
    contentWidget = Center(
      child: Text(
        content,
        textAlign: TextAlign.center,
        style: AppTextStyles.bodyTextStrong.copyWith(
          color: GVColors.purpleAccent,
        ),
      ),
    );
  } else if (content is Widget) {
    contentWidget = content;
  } else {
    throw ArgumentError('Content must be either String or Widget');
  }

  return showDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (context) {
      return PopScope(
        canPop: barrierDismissible,
        child: GestureDetector(
          onTap: barrierDismissible ? () => Navigator.maybePop(context) : null,
          child: Scaffold(
            backgroundColor: GVColors.transparent,
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {}, // Prevent tap from propagating to parent
                  child: Container(
                    constraints: BoxConstraints(minHeight: 100, minWidth: 100),
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                    margin: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: GVColors.white,
                    ),
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        contentWidget,
                        if (onButtonTap != null) ...[
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: onButtonTap,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: GVColors.purpleAccent,
                              visualDensity: VisualDensity.compact,
                            ),
                            child: Text(
                              buttonText!,
                              style: AppTextStyles.buttonPrimary.copyWith(
                                color: GVColors.white,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
