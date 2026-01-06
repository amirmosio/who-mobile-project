import 'package:flutter/material.dart';

/// A reusable navigation widget that displays Next and Previous buttons
/// at the bottom of a page.
///
/// Buttons are only shown when there is a valid next/previous destination.
/// The widget handles navigation through provided callbacks.
class NextPrevNavigationWidget extends StatelessWidget {
  /// Callback for the Previous button. If null, the button won't be shown.
  final VoidCallback? onPrevious;

  /// Callback for the Next button. If null, the button won't be shown.
  final VoidCallback? onNext;

  /// Label for the Previous button. Defaults to "Previous".
  final String previousLabel;

  /// Label for the Next button. Defaults to "Next".
  final String nextLabel;

  const NextPrevNavigationWidget({
    super.key,
    this.onPrevious,
    this.onNext,
    this.previousLabel = 'Previous',
    this.nextLabel = 'Next',
  });

  @override
  Widget build(BuildContext context) {
    // Don't show the widget if both callbacks are null
    if (onPrevious == null && onNext == null) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Previous Button (icon only)
            if (onPrevious != null)
              OutlinedButton(
                onPressed: onPrevious,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.all(8),
                  minimumSize: const Size(40, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Icon(Icons.arrow_back, size: 20),
              ),

            // Spacer between buttons
            if (onPrevious != null && onNext != null) const SizedBox(width: 10),

            // Next Button (with text)
            if (onNext != null)
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onNext,
                  icon: const Icon(Icons.arrow_forward, size: 16),
                  label: Text(
                    nextLabel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 13),
                  ),
                  iconAlignment: IconAlignment.end,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
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
