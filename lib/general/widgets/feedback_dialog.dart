import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:who_mobile_project/app_core/theme/colors.dart';
import 'package:who_mobile_project/app_core/theme/text_styles/app_text_styles.dart';
import 'package:who_mobile_project/general/services/feedback_service.dart';

/// Feedback dialog with optional screenshot capture
///
/// Usage:
/// ```dart
/// // Wrap your screen with RepaintBoundary for screenshot capture
/// RepaintBoundary(
///   key: screenKey,
///   child: Scaffold(...),
/// )
///
/// // Show dialog
/// showDialog(
///   context: context,
///   builder: (context) => FeedbackDialog(
///     screenKey: screenKey, // Optional: enables screenshot capture
///   ),
/// )
/// ```
class FeedbackDialog extends ConsumerStatefulWidget {
  final VoidCallback? onClose;
  final GlobalKey?
  screenKey; // Optional: key to RepaintBoundary for screenshots

  const FeedbackDialog({super.key, this.onClose, this.screenKey});

  @override
  ConsumerState<FeedbackDialog> createState() => _FeedbackDialogState();
}

class _FeedbackDialogState extends ConsumerState<FeedbackDialog> {
  final _formKey = GlobalKey<FormState>();
  final _commentController = TextEditingController();

  String _selectedFeedbackType = 'bug';
  final _feedbackService = FeedbackService();
  bool _isSubmitted = false;
  bool _isSubmitting = false;
  bool _includeScreenshot = true;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submitFeedback() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isSubmitting = true;
      });

      // Submit feedback with optional screenshot
      final success = await _feedbackService.submitFeedback(
        comments: _commentController.text.trim(),
        level: _selectedFeedbackType,
        ref: ref,
        context: widget.screenKey?.currentContext ?? context,
        includeScreenshot: _includeScreenshot && widget.screenKey != null,
      );

      if (mounted) {
        setState(() {
          _isSubmitting = false;
          _isSubmitted = success;
        });

        if (success) {
          // Auto-close dialog after 2 seconds
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) {
              widget.onClose?.call();
            }
          });
        } else {
          // Show error
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text(
                  'Failed to submit feedback. Please try again.',
                ),
                backgroundColor: GVColors.redError,
              ),
            );
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Overlay(
      initialEntries: [
        OverlayEntry(
          builder: (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            insetPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 24,
            ),
            child: Container(
              padding: const EdgeInsets.all(16),
              constraints: const BoxConstraints(maxWidth: 420),
              child: _isSubmitted
                  ? _buildSuccessContent()
                  : _isSubmitting
                  ? _buildLoadingContent()
                  : _buildFeedbackForm(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSuccessContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.check_circle, color: GVColors.greenSuccess, size: 48),
        const SizedBox(height: 12),
        Text(
          'Feedback submitted successfully!',
          style: AppTextStyles.headingH3.copyWith(
            color: GVColors.blackWithAlpha87,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 6),
        Text(
          _includeScreenshot && widget.screenKey != null
              ? 'Thank you! Your feedback and screenshot have been sent.'
              : 'Thank you for your feedback!',
          style: AppTextStyles.bodyText.copyWith(
            color: GVColors.blackWithAlpha60,
            fontSize: 13,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildLoadingContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const CircularProgressIndicator(),
        const SizedBox(height: 16),
        Text(
          _includeScreenshot && widget.screenKey != null
              ? 'Capturing screenshot and submitting...'
              : 'Submitting feedback...',
          style: AppTextStyles.bodyText.copyWith(
            color: GVColors.blackWithAlpha60,
            fontSize: 13,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildFeedbackForm() {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  Icons.feedback_outlined,
                  color: GVColors.guidaEvaiOrange,
                  size: 22,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Feedback',
                    style: AppTextStyles.headingH3.copyWith(
                      color: GVColors.blackWithAlpha87,
                      fontSize: 18,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => widget.onClose?.call(),
                  icon: Icon(
                    Icons.close,
                    color: GVColors.blackWithAlpha60,
                    size: 20,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Help us improve the app by sharing your feedback.',
              style: AppTextStyles.bodyText.copyWith(
                color: GVColors.blackWithAlpha60,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 16),

            // Feedback Type Selection (Compact)
            Row(
              children: [
                Expanded(
                  child: _buildTypeButton('bug', "Bug", Icons.bug_report),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildTypeButton(
                    'feature',
                    "Feature",
                    Icons.lightbulb_outline,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildTypeButton(
                    'other',
                    "Other",
                    Icons.chat_bubble_outline,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Screenshot Option (only show if screenKey is provided)
            if (widget.screenKey != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: GVColors.lightGreyBackground,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: GVColors.borderGrey),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.screenshot_outlined,
                      color: GVColors.guidaEvaiOrange,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Include screenshot',
                        style: AppTextStyles.bodyText.copyWith(
                          color: GVColors.blackWithAlpha87,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    Switch(
                      value: _includeScreenshot,
                      onChanged: (value) {
                        setState(() {
                          _includeScreenshot = value;
                        });
                      },
                      activeTrackColor: GVColors.guidaEvaiOrange,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Text(
                  _includeScreenshot
                      ? 'Screenshot will help us better understand the issue'
                      : 'Screenshot will not be included',
                  style: AppTextStyles.subtitleText.copyWith(
                    color: GVColors.textGrey,
                    fontSize: 11,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Comments Field (Compact)
            Text(
              'Comments',
              style: AppTextStyles.inputFieldLabel.copyWith(
                color: GVColors.blackWithAlpha87,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 6),
            TextFormField(
              controller: _commentController,
              minLines: 5,
              maxLines: 8,
              decoration: InputDecoration(
                hintText: 'Please describe your feedback...',
                hintStyle: AppTextStyles.bodyText.copyWith(
                  color: GVColors.textGrey,
                  fontSize: 13,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: GVColors.borderGrey),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: GVColors.borderGrey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: GVColors.guidaEvaiOrange,
                    width: 2,
                  ),
                ),
                filled: true,
                fillColor: GVColors.lightGreyBackground,
                contentPadding: const EdgeInsets.all(12),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your feedback';
                }
                if (value.trim().length < 5) {
                  return 'Please enter at least 5 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Action Buttons (Compact)
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => widget.onClose?.call(),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: GVColors.borderGrey),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      fixedSize: const Size(double.infinity, 44),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      'Cancel',
                      style: AppTextStyles.buttonSmall.copyWith(
                        color: GVColors.blackWithAlpha60,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _submitFeedback,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: GVColors.guidaEvaiOrange,
                      foregroundColor: GVColors.white,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      fixedSize: const Size(double.infinity, 44),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      "Send",
                      style: AppTextStyles.buttonSmall.copyWith(
                        color: GVColors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeButton(String type, String label, IconData icon) {
    final isSelected = _selectedFeedbackType == type;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFeedbackType = type;
        });
      },
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: BoxDecoration(
          color: isSelected
              ? GVColors.guidaEvaiOrange.withValues(alpha: 0.1)
              : GVColors.lightGreyBackground,
          border: Border.all(
            color: isSelected ? GVColors.guidaEvaiOrange : GVColors.borderGrey,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(10),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: GVColors.guidaEvaiOrange.withValues(alpha: 0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? GVColors.guidaEvaiOrange
                  : GVColors.blackWithAlpha60,
              size: 20,
            ),
            const SizedBox(height: 4),
            Flexible(
              child: Text(
                label,
                style: AppTextStyles.subtitleText.copyWith(
                  color: isSelected
                      ? GVColors.guidaEvaiOrange
                      : GVColors.blackWithAlpha60,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
