import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:who_mobile_project/app_core/theme/colors.dart';
import 'package:who_mobile_project/general/constants/available_languages.dart';
import 'package:who_mobile_project/generated/i18n/app_localizations.dart';

class TranslateLanguageSelector extends ConsumerStatefulWidget {
  /// Called when translation is enabled/disabled or language changes
  /// When enabled is false, the language parameter will be null
  final ValueChanged<({bool enabled, AvailableLanguage? language})> onChanged;

  const TranslateLanguageSelector({super.key, required this.onChanged});

  @override
  ConsumerState<TranslateLanguageSelector> createState() =>
      _TranslateLanguageSelectorState();
}

class _TranslateLanguageSelectorState
    extends ConsumerState<TranslateLanguageSelector> {
  // Local toggle state (not persisted)
  bool _isTranslateEnabled = false;

  // Local selected language state (not persisted)
  AvailableLanguage? _selectedLanguage;

  /// Get all available languages for translation
  /// Excludes the current app language
  List<AvailableLanguage> _getAvailableLanguages(
    AvailableLanguage appLanguage,
  ) {
    return AvailableLanguage.all.where((lang) => lang != appLanguage).toList();
  }

  void _showLanguageSelector(
    BuildContext context,
    AvailableLanguage currentLanguage,
    AvailableLanguage appLanguage,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final availableLanguages = _getAvailableLanguages(appLanguage);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                l10n.quiz_translate,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: GVColors.black,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Divider(height: 1),
            // Language options (all languages except app language)
            for (final language in availableLanguages)
              ListTile(
                title: Text(
                  language.getDisplayName(l10n),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: GVColors.black,
                  ),
                ),
                trailing: currentLanguage == language
                    ? const Icon(Icons.check, color: GVColors.guidaEvaiOrange)
                    : null,
                onTap: () async {
                  // TODO: Removed - appPreferencesProvider no longer available
                  // Language preference is now only stored locally in widget state
                  setState(() {
                    _selectedLanguage = language;
                  });

                  // Use local toggle state
                  widget.onChanged((
                    enabled: _isTranslateEnabled,
                    language: language,
                  ));
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                },
              ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // Initialize in next frame to ensure ref is available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeLanguageState();
    });
  }

  void _initializeLanguageState() {
    // TODO: Removed - appPreferencesProvider no longer available
    // Default to Italian locale
    const defaultLocale = Locale('it', 'IT');
    final appLanguage = AvailableLanguage.fromLocale(defaultLocale);
    final availableLanguages = _getAvailableLanguages(appLanguage);

    // If no valid selection, use first available language
    if (_selectedLanguage == null && availableLanguages.isNotEmpty) {
      setState(() {
        _selectedLanguage = availableLanguages.first;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // TODO: Removed - appPreferencesProvider no longer available
    // Default to Italian locale
    const defaultLocale = Locale('it', 'IT');
    final AvailableLanguage appLanguage = AvailableLanguage.fromLocale(
      defaultLocale,
    );
    final availableLanguages = _getAvailableLanguages(appLanguage);

    // Determine current language to display:
    // - If switch is OFF: show app language
    // - If switch is ON: show selected language or first available
    final AvailableLanguage displayLanguage;
    if (_isTranslateEnabled) {
      displayLanguage =
          _selectedLanguage ??
          (availableLanguages.isNotEmpty
              ? availableLanguages.first
              : appLanguage);
    } else {
      displayLanguage = appLanguage;
    }

    return Container(
      height: 45,
      color: GVColors.greyFieldBackground,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            const Icon(Icons.translate, size: 20, color: GVColors.darkGreyText),
            const SizedBox(width: 8),
            Text(
              l10n.quiz_translate,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: GVColors.darkGreyText,
                height: 1.2,
              ),
            ),
            const Spacer(),
            // Toggle switch (local state)
            Switch(
              value: _isTranslateEnabled,
              activeThumbColor: GVColors.guidaEvaiOrange,
              onChanged: (value) {
                setState(() {
                  _isTranslateEnabled = value;
                });

                if (value) {
                  // When enabling, use selected language or first available
                  final languageToUse =
                      _selectedLanguage ??
                      (availableLanguages.isNotEmpty
                          ? availableLanguages.first
                          : null);

                  if (languageToUse != null) {
                    // Ensure selected language is set
                    if (_selectedLanguage == null) {
                      setState(() {
                        _selectedLanguage = languageToUse;
                      });
                    }

                    // TODO: Removed - appPreferencesProvider no longer available
                    // Language preference stored only in local widget state

                    widget.onChanged((enabled: true, language: languageToUse));
                  }
                } else {
                  // When disabling, callback with null language
                  widget.onChanged((enabled: false, language: null));
                }
              },
            ),
            const SizedBox(width: 8),
            // Language selector (disabled when switch is off)
            Opacity(
              opacity: _isTranslateEnabled ? 1.0 : 0.5,
              child: InkWell(
                onTap: _isTranslateEnabled
                    ? () => _showLanguageSelector(
                        context,
                        displayLanguage,
                        appLanguage,
                      )
                    : null,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 13,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: GVColors.white,
                    borderRadius: BorderRadius.circular(3),
                    border: Border.all(
                      color: GVColors.lightGreyBorder,
                      width: 0.5,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        displayLanguage.getDisplayName(l10n),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: GVColors.black,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Icon(
                        Icons.keyboard_arrow_down,
                        size: 13,
                        color: _isTranslateEnabled
                            ? GVColors.black
                            : GVColors.darkGreyText,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
