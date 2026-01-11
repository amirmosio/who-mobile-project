import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:who_mobile_project/app_core/theme/colors.dart';
import 'package:who_mobile_project/app_core/theme/text_styles/app_text_styles.dart';
import 'package:who_mobile_project/general/constants/comment_categories.dart';
import 'package:who_mobile_project/general/models/comments/comment.dart';
import 'package:who_mobile_project/generated/i18n/app_localizations.dart';
import 'package:who_mobile_project/providers/auth/current_user_provider.dart';
import 'package:who_mobile_project/providers/auth/role_access_provider.dart';
import 'package:who_mobile_project/providers/base/base_api_state.dart';
import 'package:who_mobile_project/providers/comments/comments_provider.dart';
import 'package:who_mobile_project/ui/comments/widgets/add_comment_dialog.dart';
import 'package:who_mobile_project/ui/comments/widgets/category_filter_chips.dart';
import 'package:who_mobile_project/ui/comments/widgets/comment_list_item.dart';

/// Comments page for viewing and adding comments
/// Only accessible by admin users
class CommentsPage extends ConsumerStatefulWidget {
  const CommentsPage({super.key});

  @override
  ConsumerState<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends ConsumerState<CommentsPage> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final hasAdminAccess = ref.watch(hasAdminAccessProvider);
    final currentUser = ref.watch(currentUserProvider);
    final selectedCategory = ref.watch(selectedCommentCategoryProvider);
    final commentsAsync = ref.watch(commentsStreamProvider(selectedCategory));

    // Check access permission
    if (!hasAdminAccess) {
      return _buildAccessDenied(l10n);
    }

    // Listen for delete state changes
    ref.listen(deleteCommentProvider, (previous, next) {
      if (next is BaseApiError) {
        _showSnackBar(
          next.exception.message ?? l10n.failed_to_delete_comment,
          isError: true,
        );
      } else if (next is BaseApiOperationSuccess) {
        _showSnackBar(l10n.comment_deleted);
      }
    });

    return Scaffold(
      backgroundColor: GVColors.white,
      appBar: _buildAppBar(l10n),
      body: Column(
        children: [
          // Category filter chips
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: CategoryFilterChips(
              selectedCategory: selectedCategory,
              onCategorySelected: (category) {
                ref
                    .read(selectedCommentCategoryProvider.notifier)
                    .selectCategory(category);
              },
            ),
          ),

          // Divider
          Container(
            height: 1,
            color: GVColors.lightBorderGrey,
          ),

          // Comments list
          Expanded(
            child: commentsAsync.when(
              data: (comments) => _buildCommentsList(
                comments,
                currentUser.value?.uid,
                l10n,
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => _buildError(error.toString(), l10n),
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFAB(selectedCategory, l10n),
    );
  }

  PreferredSizeWidget _buildAppBar(AppLocalizations l10n) {
    return AppBar(
      backgroundColor: GVColors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Text(
        l10n.comments,
        style: AppTextStyles.headingH2.copyWith(
          color: GVColors.black,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          color: GVColors.lightBorderGrey,
        ),
      ),
    );
  }

  Widget _buildCommentsList(
    List<Comment> comments,
    String? currentUserId,
    AppLocalizations l10n,
  ) {
    if (comments.isEmpty) {
      return _buildEmptyState(l10n);
    }

    return RefreshIndicator(
      onRefresh: () async {
        // Invalidate the provider to refresh
        final selectedCategory = ref.read(selectedCommentCategoryProvider);
        ref.invalidate(commentsStreamProvider(selectedCategory));
      },
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 8, bottom: 100),
        itemCount: comments.length,
        itemBuilder: (context, index) {
          final comment = comments[index];
          final isCurrentUserComment = comment.authorId == currentUserId;
          final isSuperAdmin = ref.watch(isSuperAdminProvider);

          return CommentListItem(
            comment: comment,
            isCurrentUserComment: isCurrentUserComment,
            onDelete: (isCurrentUserComment || isSuperAdmin)
                ? () => _showDeleteConfirmation(comment, l10n)
                : null,
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(AppLocalizations l10n) {
    final selectedCategory = ref.watch(selectedCommentCategoryProvider);
    final categoryName =
        selectedCategory?.displayName.toLowerCase() ?? '';

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: GVColors.lightGrey,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.chat_bubble_outline,
                size: 40,
                color: GVColors.darkGrey,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.no_comments,
              style: AppTextStyles.headingH2.copyWith(
                color: GVColors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              selectedCategory == null
                  ? l10n.be_first_to_comment
                  : l10n.no_comments_in_category(categoryName),
              style: AppTextStyles.bodyText.copyWith(
                color: GVColors.darkGrey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError(String error, AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: GVColors.redError,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.error_loading_comments,
              style: AppTextStyles.headingH2.copyWith(
                color: GVColors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: AppTextStyles.bodyText.copyWith(
                color: GVColors.darkGrey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                final selectedCategory =
                    ref.read(selectedCommentCategoryProvider);
                ref.invalidate(commentsStreamProvider(selectedCategory));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: GVColors.purpleAccent,
                foregroundColor: GVColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(60),
                ),
              ),
              child: Text(l10n.retry),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccessDenied(AppLocalizations l10n) {
    return Scaffold(
      backgroundColor: GVColors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.lock_outline,
                size: 64,
                color: GVColors.redError,
              ),
              const SizedBox(height: 24),
              Text(
                l10n.access_denied,
                style: AppTextStyles.headingH1.copyWith(
                  color: GVColors.black,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                l10n.admin_required_for_comments,
                style: AppTextStyles.bodyText.copyWith(
                  color: GVColors.darkGrey,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFAB(CommentCategory? selectedCategory, AppLocalizations l10n) {
    return FloatingActionButton.extended(
      onPressed: () => _showAddCommentDialog(selectedCategory),
      backgroundColor: GVColors.purpleAccent,
      foregroundColor: GVColors.white,
      icon: const Icon(Icons.add_comment),
      label: Text(l10n.add_comment),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }

  Future<void> _showAddCommentDialog(CommentCategory? initialCategory) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AddCommentDialog(
        initialCategory: initialCategory,
      ),
    );
  }

  Future<void> _showDeleteConfirmation(Comment comment, AppLocalizations l10n) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          l10n.delete_comment,
          style: AppTextStyles.headingH3.copyWith(
            color: GVColors.black,
          ),
        ),
        content: Text(
          l10n.delete_comment_confirmation,
          style: AppTextStyles.bodyText.copyWith(
            color: GVColors.darkGrey,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              l10n.cancel,
              style: AppTextStyles.bodyText.copyWith(
                color: GVColors.darkGrey,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: GVColors.redError,
              foregroundColor: GVColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(60),
              ),
            ),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await ref.read(deleteCommentProvider.notifier).deleteComment(comment.id);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: AppTextStyles.smallText.copyWith(color: GVColors.white),
        ),
        backgroundColor: isError ? GVColors.redError : GVColors.greenSuccess,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
