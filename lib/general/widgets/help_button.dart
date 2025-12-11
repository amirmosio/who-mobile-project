import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:who_mobile_project/app_core/theme/colors.dart';
import 'package:who_mobile_project/generated/i18n/app_localizations.dart';
import 'package:who_mobile_project/app_core/theme/text_styles/app_text_styles.dart';

/// A reusable help button that opens WhatsApp support
///
/// [style] determines the visual style:
/// - [HelpButtonStyle.iconButton]: Button with icon and shadow (for prominent placement)
/// - [HelpButtonStyle.simpleText]: Simple text container (for subtle placement)
class HelpButton extends StatelessWidget {
  final HelpButtonStyle style;
  final EdgeInsets? padding;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final String? whatsappMessage;

  const HelpButton({
    super.key,
    this.style = HelpButtonStyle.iconButton,
    this.padding,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.whatsappMessage,
  });

  @override
  Widget build(BuildContext context) {
    final uri = Uri.parse(
      'https://wa.me/393801711368?text=${whatsappMessage ?? 'Ciao, ho bisogno di aiuto'}',
    );

    if (style == HelpButtonStyle.iconButton) {
      return Center(
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor ?? Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: (borderColor ?? const Color(0xFFF29915)).withValues(
                alpha: 0.3,
              ),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () async {
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                }
              },
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding:
                    padding ??
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.help_outline,
                      size: 16,
                      color: textColor ?? const Color(0xFFF29915),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      AppLocalizations.of(context)!.needHelp,
                      style: AppTextStyles.bodyText.copyWith(
                        fontSize: 12,
                        color: textColor ?? const Color(0xFFF29915),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      return Center(
        child: GestureDetector(
          onTap: () async {
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            }
          },
          child: Container(
            padding:
                padding ??
                const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            decoration: BoxDecoration(
              color: backgroundColor ?? GVColors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: borderColor ?? GVColors.guidaEvaiOrange,
                width: 0.5,
              ),
            ),
            child: Text(
              AppLocalizations.of(context)!.needHelp,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 12,
                color: textColor ?? GVColors.guidaEvaiOrange,
                height: 20 / 12,
              ),
            ),
          ),
        ),
      );
    }
  }
}

enum HelpButtonStyle {
  /// Button with icon and shadow - for prominent placement
  iconButton,

  /// Simple text container - for subtle placement
  simpleText,
}
