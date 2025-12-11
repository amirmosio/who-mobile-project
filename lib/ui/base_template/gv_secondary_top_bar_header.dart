import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:who_mobile_project/app_core/theme/colors.dart';
import 'package:who_mobile_project/app_core/theme/text_styles/app_text_styles.dart';

class GVSecondaryTopBarHeader extends StatelessWidget {
  static const double height = 45;
  final String title;
  final Widget child;
  final bool includePadding;
  final bool includeScrollable;

  static EdgeInsets paddingHorizontal = EdgeInsets.symmetric(horizontal: 16);

  const GVSecondaryTopBarHeader({
    super.key,
    required this.child,
    required this.title,
    this.includePadding = true,
    this.includeScrollable = true,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = Padding(
      padding: includePadding
          ? paddingHorizontal.add(EdgeInsets.only(top: height + 24))
          : EdgeInsets.only(top: height),
      child: child,
    );
    return Scaffold(
      backgroundColor: GVColors.white,
      body: Stack(
        children: [
          includeScrollable ? SingleChildScrollView(child: content) : content,
          _buildTopBar(context),
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
