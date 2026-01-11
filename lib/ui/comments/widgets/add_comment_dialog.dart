import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:who_mobile_project/app_core/theme/colors.dart';
import 'package:who_mobile_project/app_core/theme/text_styles/app_text_styles.dart';
import 'package:who_mobile_project/general/constants/comment_categories.dart';
import 'package:who_mobile_project/general/widgets/formfields/my_text_formfield.dart';
import 'package:who_mobile_project/providers/auth/current_user_provider.dart';
import 'package:who_mobile_project/providers/base/base_api_state.dart';
import 'package:who_mobile_project/providers/comments/comments_provider.dart';
import 'package:who_mobile_project/services/firebase/firebase_comments_service.dart';

/// Dialog for creating a new comment
/// Only accessible by admin users
class AddCommentDialog extends ConsumerStatefulWidget {
  final CommentCategory? initialCategory;

  const AddCommentDialog({
    super.key,
    this.initialCategory,
  });

  @override
  ConsumerState<AddCommentDialog> createState() => _AddCommentDialogState();
}

class _AddCommentDialogState extends ConsumerState<AddCommentDialog> {
  final _formKey = GlobalKey<FormState>();
  final _commentController = TextEditingController();
  late CommentCategory _selectedCategory;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory ?? CommentCategory.general;
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final currentUser = ref.read(currentUserProvider).value;
    if (currentUser == null) {
      _showError('Unable to get current user');
      setState(() => _isLoading = false);
      return;
    }

    final commentId = await ref.read(createCommentProvider.notifier).createComment(
          text: _commentController.text.trim(),
          category: _selectedCategory,
          authorId: currentUser.uid ?? 'unknown',
          authorName: currentUser.displayName ?? 'Unknown',
          authorEmail: currentUser.email ?? 'unknown@email.com',
        );

    setState(() => _isLoading = false);

    if (commentId != null && mounted) {
      Navigator.of(context).pop(true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Comment added successfully',
            style: AppTextStyles.smallText.copyWith(color: GVColors.white),
          ),
          backgroundColor: GVColors.greenSuccess,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: AppTextStyles.smallText.copyWith(color: GVColors.white),
        ),
        backgroundColor: GVColors.redError,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Listen for errors
    ref.listen(createCommentProvider, (previous, next) {
      if (next is BaseApiError) {
        _showError(next.exception.message ?? 'Failed to add comment');
      }
    });

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                _buildHeader(),

                const SizedBox(height: 24),

                // Category selection
                _buildCategoryDropdown(),

                const SizedBox(height: 16),

                // Comment text field
                MyTextFormField(
                  controller: _commentController,
                  hintText: 'Enter your comment...',
                  labelText: 'Comment',
                  isMandatoryStartSign: true,
                  maxLines: 4,
                  keyboardType: TextInputType.multiline,
                  validator: _validateComment,
                ),

                const SizedBox(height: 8),

                // Character count hint
                Text(
                  'Maximum ${FirebaseCommentsService.maxCommentLength} characters',
                  style: AppTextStyles.subtitleText.copyWith(
                    color: GVColors.darkGrey,
                  ),
                ),

                const SizedBox(height: 24),

                // Action buttons
                _buildActionButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: GVColors.purpleAccent.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            Icons.add_comment,
            color: GVColors.purpleAccent,
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            'Add Comment',
            style: AppTextStyles.headingH2.copyWith(
              color: GVColors.black,
            ),
          ),
        ),
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.close,
            color: GVColors.darkGrey,
          ),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(
            minWidth: 32,
            minHeight: 32,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category',
          style: AppTextStyles.bodyTextStrong.copyWith(
            color: GVColors.black,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(color: GVColors.lightBorderGrey),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButton<CommentCategory>(
            value: _selectedCategory,
            isExpanded: true,
            underline: const SizedBox.shrink(),
            icon: Icon(
              Icons.keyboard_arrow_down,
              color: GVColors.darkGrey,
            ),
            items: CommentCategory.values.map((category) {
              return DropdownMenuItem<CommentCategory>(
                value: category,
                child: Row(
                  children: [
                    Icon(
                      _getCategoryIcon(category),
                      size: 20,
                      color: GVColors.purpleAccent,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      category.displayName,
                      style: AppTextStyles.bodyText.copyWith(
                        color: GVColors.black,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() => _selectedCategory = value);
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
            style: OutlinedButton.styleFrom(
              foregroundColor: GVColors.purpleAccent,
              side: BorderSide(color: GVColors.purpleAccent),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(60),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: Text(
              'Cancel',
              style: AppTextStyles.buttonSmall.copyWith(
                color: GVColors.purpleAccent,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: _isLoading ? null : _handleSubmit,
            style: ElevatedButton.styleFrom(
              backgroundColor: GVColors.purpleAccent,
              foregroundColor: GVColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(60),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
              disabledBackgroundColor:
                  GVColors.purpleAccent.withValues(alpha: 0.6),
            ),
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        GVColors.white,
                      ),
                    ),
                  )
                : Text(
                    'Submit',
                    style: AppTextStyles.buttonSmall.copyWith(
                      color: GVColors.white,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  IconData _getCategoryIcon(CommentCategory category) {
    switch (category) {
      case CommentCategory.install:
        return Icons.build_outlined;
      case CommentCategory.maintenance:
        return Icons.settings_outlined;
      case CommentCategory.disassemble:
        return Icons.construction_outlined;
      case CommentCategory.general:
        return Icons.chat_bubble_outline;
    }
  }

  String? _validateComment(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a comment';
    }
    if (value.length > FirebaseCommentsService.maxCommentLength) {
      return 'Comment exceeds maximum length';
    }
    return null;
  }
}
