import 'package:flutter/material.dart';
import 'package:who_mobile_project/app_core/theme/colors.dart';
import 'package:who_mobile_project/generated/i18n/app_localizations.dart';

class AccountUnificationWidget extends StatelessWidget {
  const AccountUnificationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      constraints: BoxConstraints(maxWidth: 500),
      child: Stack(
        alignment: Alignment.topRight,
        clipBehavior: Clip.none,
        children: [
          // Banner layer - Orange container with text (fixed height)
          Container(
            constraints: BoxConstraints(minWidth: 150),
            decoration: BoxDecoration(
              color: GVColors.guidaEvaiOrange.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: GVColors.guidaEvaiOrange, width: 0.5),
            ),
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.account_unification,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        AppLocalizations.of(
                          context,
                        )!.account_unification_short_description,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 110),
              ],
            ),
          ),
          // Salvatore image layer - Independent from banner, positioned on the right
          Positioned(
            right: -50, // Extend beyond the banner
            top: 0,
            child: Image.asset(
              "assets/images/figma_designs/avatar_default_user.png",
              width: 256,
              height: 256,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 256,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.person,
                    size: 128,
                    color: Colors.grey,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
