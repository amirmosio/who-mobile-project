import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:who_mobile_project/general/constants/comment_categories.dart';
import 'package:who_mobile_project/general/models/comments/comment.dart';
import 'package:who_mobile_project/generated/i18n/app_localizations.dart';
import 'package:who_mobile_project/providers/auth/role_access_provider.dart';
import 'package:who_mobile_project/providers/comments/comments_provider.dart';
import 'package:who_mobile_project/routing_config/routes.dart';
import 'package:who_mobile_project/ui/comments/widgets/add_comment_dialog.dart';

/// A reusable comments section widget that can be embedded in any page
/// Shows comments filtered by category with option to add new comments
/// Only visible to admin users
class CommentsSectionWidget extends ConsumerWidget {
  /// The category of comments to show
  final CommentCategory category;

  /// Maximum number of comments to display (null for all)
  final int? maxComments;

  /// Whether to show the "Add Comment" button
  final bool showAddButton;

  /// Whether to show the "View All" link
  final bool showViewAll;

  /// Custom title for the section (defaults to "Comments")
  final String? title;

  /// Whether to show as a collapsible section
  final bool collapsible;

  /// Initially collapsed state (only used if collapsible is true)
  final bool initiallyCollapsed;

  const CommentsSectionWidget({
    super.key,
    required this.category,
    this.maxComments = 3,
    this.showAddButton = true,
    this.showViewAll = true,
    this.title,
    this.collapsible = false,
    this.initiallyCollapsed = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final hasAdminAccess = ref.watch(hasAdminAccessProvider);

    // Only show to admins
    if (!hasAdminAccess) {
      return const SizedBox.shrink();
    }

    final commentsAsync = ref.watch(commentsByCategoryProvider(category));

    return commentsAsync.when(
      data: (comments) {
        final displayComments =
            maxComments != null ? comments.take(maxComments!).toList() : comments;
        final hasMore = maxComments != null && comments.length > maxComments!;
        final commentCount = comments.length;

        if (collapsible) {
          return _CollapsibleCommentsSection(
            category: category,
            comments: displayComments,
            commentCount: commentCount,
            hasMore: hasMore,
            showAddButton: showAddButton,
            showViewAll: showViewAll,
            title: title,
            initiallyCollapsed: initiallyCollapsed,
          );
        }

        return _CommentsSection(
          category: category,
          comments: displayComments,
          commentCount: commentCount,
          hasMore: hasMore,
          showAddButton: showAddButton,
          showViewAll: showViewAll,
          title: title,
        );
      },
      loading: () => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, ref, l10n, title, category, 0, showAddButton),
              const SizedBox(height: 16),
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(),
                ),
              ),
            ],
          ),
        ),
      ),
      error: (error, _) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, ref, l10n, title, category, 0, showAddButton),
              const SizedBox(height: 16),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    l10n.error_loading_comments,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.red,
                        ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    String? title,
    CommentCategory category,
    int commentCount,
    bool showAddButton,
  ) {
    final sectionTitle = title ?? '${category.displayName} ${l10n.comments}';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              Icons.comment_outlined,
              size: 20,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              sectionTitle,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            if (commentCount > 0) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$commentCount',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ],
          ],
        ),
        if (showAddButton)
          IconButton(
            icon: const Icon(Icons.add_comment_outlined),
            onPressed: () => _showAddCommentDialog(context, ref, category),
            tooltip: l10n.add_comment,
          ),
      ],
    );
  }

  void _showAddCommentDialog(
    BuildContext context,
    WidgetRef ref,
    CommentCategory category,
  ) {
    showDialog(
      context: context,
      builder: (context) => AddCommentDialog(initialCategory: category),
    );
  }
}

class _CommentsSection extends ConsumerWidget {
  final CommentCategory category;
  final List<Comment> comments;
  final int commentCount;
  final bool hasMore;
  final bool showAddButton;
  final bool showViewAll;
  final String? title;

  const _CommentsSection({
    required this.category,
    required this.comments,
    required this.commentCount,
    required this.hasMore,
    required this.showAddButton,
    required this.showViewAll,
    this.title,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final sectionTitle = title ?? '${category.displayName} ${l10n.comments}';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.comment_outlined,
                      size: 20,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      sectionTitle,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    if (commentCount > 0) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '$commentCount',
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                    ],
                  ],
                ),
                if (showAddButton)
                  IconButton(
                    icon: const Icon(Icons.add_comment_outlined),
                    onPressed: () => _showAddCommentDialog(context, ref),
                    tooltip: l10n.add_comment,
                  ),
              ],
            ),
            const SizedBox(height: 12),

            // Comments list
            if (comments.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Center(
                  child: Text(
                    l10n.no_comments,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                ),
              )
            else
              ...comments.map((comment) => _MiniCommentCard(comment: comment)),

            // View all link
            if (showViewAll && hasMore)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: TextButton(
                  onPressed: () {
                    // Navigate to comments page with this category selected
                    ref
                        .read(selectedCommentCategoryProvider.notifier)
                        .selectCategory(category);
                    context.go(YRRoutes.comments);
                  },
                  child: Text(l10n.view_all_comments(commentCount)),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showAddCommentDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AddCommentDialog(initialCategory: category),
    );
  }
}

class _CollapsibleCommentsSection extends ConsumerStatefulWidget {
  final CommentCategory category;
  final List<Comment> comments;
  final int commentCount;
  final bool hasMore;
  final bool showAddButton;
  final bool showViewAll;
  final String? title;
  final bool initiallyCollapsed;

  const _CollapsibleCommentsSection({
    required this.category,
    required this.comments,
    required this.commentCount,
    required this.hasMore,
    required this.showAddButton,
    required this.showViewAll,
    this.title,
    required this.initiallyCollapsed,
  });

  @override
  ConsumerState<_CollapsibleCommentsSection> createState() =>
      _CollapsibleCommentsSectionState();
}

class _CollapsibleCommentsSectionState
    extends ConsumerState<_CollapsibleCommentsSection> {
  late bool _isCollapsed;

  @override
  void initState() {
    super.initState();
    _isCollapsed = widget.initiallyCollapsed;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final sectionTitle =
        widget.title ?? '${widget.category.displayName} ${l10n.comments}';

    return Card(
      child: Column(
        children: [
          // Header (always visible)
          InkWell(
            onTap: () => setState(() => _isCollapsed = !_isCollapsed),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    Icons.comment_outlined,
                    size: 20,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    sectionTitle,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  if (widget.commentCount > 0) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${widget.commentCount}',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ],
                  const Spacer(),
                  if (widget.showAddButton && !_isCollapsed)
                    IconButton(
                      icon: const Icon(Icons.add_comment_outlined),
                      onPressed: () => _showAddCommentDialog(context),
                      tooltip: l10n.add_comment,
                    ),
                  Icon(
                    _isCollapsed
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_up,
                    color: Colors.grey[600],
                  ),
                ],
              ),
            ),
          ),

          // Collapsible content
          if (!_isCollapsed) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.comments.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Center(
                        child: Text(
                          l10n.no_comments,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                        ),
                      ),
                    )
                  else
                    ...widget.comments
                        .map((comment) => _MiniCommentCard(comment: comment)),

                  // View all link
                  if (widget.showViewAll && widget.hasMore)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: TextButton(
                        onPressed: () {
                          ref
                              .read(selectedCommentCategoryProvider.notifier)
                              .selectCategory(widget.category);
                          context.go(YRRoutes.comments);
                        },
                        child:
                            Text(l10n.view_all_comments(widget.commentCount)),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showAddCommentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) =>
          AddCommentDialog(initialCategory: widget.category),
    );
  }
}

class _MiniCommentCard extends StatelessWidget {
  final Comment comment;

  const _MiniCommentCard({required this.comment});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM d, yyyy');

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Author and date
          Row(
            children: [
              CircleAvatar(
                radius: 12,
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: Text(
                  comment.authorName.isNotEmpty
                      ? comment.authorName[0].toUpperCase()
                      : '?',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                comment.authorName,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const Spacer(),
              Text(
                dateFormat.format(comment.createdAt),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[500],
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Comment text
          Text(
            comment.text,
            style: Theme.of(context).textTheme.bodyMedium,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
