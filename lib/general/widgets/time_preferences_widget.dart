import 'package:flutter/material.dart';
import 'package:who_mobile_project/app_core/theme/colors.dart';
import 'package:who_mobile_project/app_core/theme/text_styles/app_text_styles.dart';
import 'package:who_mobile_project/general/models/time_preference_item.dart';
import 'package:who_mobile_project/generated/i18n/app_localizations.dart';

class TimePreferencesWidget extends StatefulWidget {
  final List<TimePreferenceItem> selectedPreferences;
  final Function(List<TimePreferenceItem>) onSelectionChanged;
  final int maxSelections;

  const TimePreferencesWidget({
    super.key,
    required this.selectedPreferences,
    required this.onSelectionChanged,
    this.maxSelections = 3,
  });

  @override
  State<TimePreferencesWidget> createState() => _TimePreferencesWidgetState();
}

class _TimePreferencesWidgetState extends State<TimePreferencesWidget> {
  List<TimePreferenceItem> _selectedItems = [];
  bool _isExpanded = false; // Start collapsed to match Figma design

  @override
  void initState() {
    super.initState();
    _selectedItems = List.from(widget.selectedPreferences);
  }

  void _toggleSelection(TimePreferenceItem item) {
    setState(() {
      if (_selectedItems.contains(item)) {
        _selectedItems.remove(item);
      } else if (_selectedItems.length < widget.maxSelections) {
        _selectedItems.add(item);
      }
      widget.onSelectionChanged(_selectedItems);
    });
  }

  @override
  Widget build(BuildContext context) {
    final allPreferences = TimePreferenceItem.getAllTimePreferences();
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey.withValues(alpha: 0.5),
          width: 0.5,
        ),
      ),
      child: Column(
        children: [
          // Header section - always visible and clickable to toggle expansion
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.express_your_preference,
                      style: AppTextStyles.smallText.copyWith(
                        color: GVColors.black,
                      ),
                    ),
                    const Spacer(),
                    AnimatedRotation(
                      duration: const Duration(milliseconds: 200),
                      turns: _isExpanded ? 0.5 : 0, // 90 degrees when expanded
                      child: const Icon(
                        Icons.keyboard_arrow_down,
                        size: 18,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Expandable content
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: _isExpanded
                ? Column(
                    children: [
                      // Time preferences list
                      ...allPreferences.map((preference) {
                        final isSelected = _selectedItems.contains(preference);
                        final canSelect =
                            _selectedItems.length < widget.maxSelections ||
                            isSelected;

                        return Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 2,
                          ),
                          height: 36,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFFF29915).withValues(alpha: 0.1)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: canSelect
                                  ? () => _toggleSelection(preference)
                                  : null,
                              borderRadius: BorderRadius.circular(8),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        _getTranslatedText(preference, l10n),
                                        style: AppTextStyles.smallText.copyWith(
                                          color: GVColors.black,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 15,
                                      height: 15,
                                      child: Checkbox(
                                        value: isSelected,
                                        onChanged: canSelect
                                            ? (value) =>
                                                  _toggleSelection(preference)
                                            : null,
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        visualDensity: VisualDensity.compact,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            3,
                                          ),
                                        ),
                                        side: BorderSide(
                                          color: isSelected
                                              ? const Color(0xFF008C15)
                                              : Colors.grey,
                                          width: 0.5,
                                        ),
                                        activeColor: const Color(0xFF008C15),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }),

                      const SizedBox(height: 16),
                    ],
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  String _getTranslatedText(
    TimePreferenceItem preference,
    AppLocalizations l10n,
  ) {
    return preference.getTranslatedDisplayText(l10n);
  }
}
