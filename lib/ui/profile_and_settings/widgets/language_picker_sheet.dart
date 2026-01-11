import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:who_mobile_project/app_core/theme/colors.dart';
import 'package:who_mobile_project/app_core/theme/text_styles/app_text_styles.dart';
import 'package:who_mobile_project/general/constants/available_languages.dart';
import 'package:who_mobile_project/generated/i18n/app_localizations.dart';
import 'package:who_mobile_project/providers/app_locale/app_locale_provider.dart';

/// Bottom sheet widget for selecting the app language
class LanguagePickerSheet extends ConsumerWidget {
  const LanguagePickerSheet({super.key});

  /// Show the language picker bottom sheet
  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const LanguagePickerSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final currentLocale = ref.watch(appLocaleProvider);
    final currentLanguage = AvailableLanguage.fromLocale(currentLocale);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: GVColors.lightGrey,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Title
            Text(
              l10n.select_language,
              style: AppTextStyles.headingH3.copyWith(
                color: GVColors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Language options
            ...AvailableLanguage.values.map((language) {
              final isSelected = language == currentLanguage;
              return _buildLanguageOption(
                context,
                ref,
                language,
                isSelected,
                l10n,
              );
            }),

            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(
    BuildContext context,
    WidgetRef ref,
    AvailableLanguage language,
    bool isSelected,
    AppLocalizations l10n,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: isSelected
            ? GVColors.blueFeature.withValues(alpha: 0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () async {
            await ref.read(appLocaleProvider.notifier).setLocale(language);
            if (context.mounted) {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    l10n.language_changed,
                    style: AppTextStyles.smallText.copyWith(
                      color: GVColors.white,
                    ),
                  ),
                  backgroundColor: GVColors.greenSuccess,
                  behavior: SnackBarBehavior.floating,
                  margin: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  duration: const Duration(seconds: 2),
                ),
              );
            }
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              border: Border.all(
                color:
                    isSelected ? GVColors.blueFeature : GVColors.lightBorderGrey,
                width: isSelected ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                // Flag emoji
                Text(
                  language == AvailableLanguage.italian ? '🇮🇹' : '🇬🇧',
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(width: 12),

                // Language name
                Expanded(
                  child: Text(
                    language.getDisplayName(l10n),
                    style: AppTextStyles.bodyText.copyWith(
                      color: GVColors.black,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),

                // Checkmark for selected
                if (isSelected)
                  Icon(
                    Icons.check_circle,
                    color: GVColors.blueFeature,
                    size: 24,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
