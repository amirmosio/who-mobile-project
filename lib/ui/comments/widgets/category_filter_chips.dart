import 'package:flutter/material.dart';
import 'package:who_mobile_project/app_core/theme/colors.dart';
import 'package:who_mobile_project/app_core/theme/text_styles/app_text_styles.dart';
import 'package:who_mobile_project/general/constants/comment_categories.dart';

/// Horizontal scrolling filter chips for comment categories
class CategoryFilterChips extends StatelessWidget {
  final CommentCategory? selectedCategory;
  final ValueChanged<CommentCategory?> onCategorySelected;

  const CategoryFilterChips({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          // "All" chip
          _buildChip(
            label: 'All',
            isSelected: selectedCategory == null,
            onTap: () => onCategorySelected(null),
            icon: Icons.list,
          ),
          const SizedBox(width: 8),

          // Category chips
          ...CommentCategory.values.map((category) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _buildChip(
                label: category.displayName,
                isSelected: selectedCategory == category,
                onTap: () => onCategorySelected(category),
                icon: _getCategoryIcon(category),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required IconData icon,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? GVColors.purpleAccent
              : GVColors.purpleAccent.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? GVColors.purpleAccent
                : GVColors.purpleAccent.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? GVColors.white : GVColors.purpleAccent,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: AppTextStyles.buttonSmall.copyWith(
                color: isSelected ? GVColors.white : GVColors.purpleAccent,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
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
}
