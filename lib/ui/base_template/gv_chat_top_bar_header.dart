import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:who_mobile_project/app_core/theme/colors.dart';
import 'package:who_mobile_project/app_core/theme/text_styles/app_text_styles.dart';

class GVChatTopBarHeader extends StatelessWidget {
  static const double height = 58;
  final String title;
  final Widget child;
  final Widget? floatingWidget;
  final EdgeInsets? floatingWidgetPadding;

  const GVChatTopBarHeader({
    super.key,
    required this.child,
    required this.title,
    this.floatingWidget,
    this.floatingWidgetPadding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GVColors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(height),
        child: _buildTopBar(context),
      ),
      body: Stack(
        children: [
          // Main content area
          if (floatingWidget != null)
            Positioned.fill(
              bottom: floatingWidgetPadding != null
                  ? 80 + floatingWidgetPadding!.bottom
                  : 96, // Default space for floating widget
              child: child,
            )
          else
            Positioned.fill(child: child),

          // Floating widget at bottom
          if (floatingWidget != null)
            Positioned(
              left: floatingWidgetPadding?.left ?? 16,
              right: floatingWidgetPadding?.right ?? 16,
              bottom: floatingWidgetPadding?.bottom ?? 16,
              child: floatingWidget!,
            ),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: GVColors.white,
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.08),
            offset: Offset(0, 2),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 10),
          // Back button
          IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 20,
              color: GVColors.black,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 30, minHeight: 30),
          ),
          // Title
          Expanded(
            child: Text(
              title,
              style: AppTextStyles.headingH2
                  .copyWith(color: GVColors.black)
                  .copyWith(fontSize: 16, fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 20),
        ],
      ),
    );
  }
}
