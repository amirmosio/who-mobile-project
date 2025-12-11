import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:who_mobile_project/app_core/theme/colors.dart';
import 'package:who_mobile_project/general/services/device/device_service.dart';
// TODO: Re-enable when AI feature is ready
// import 'package:who_mobile_project/general/widgets/ai_badge.dart';

class YRBottomNavBar extends StatefulWidget {
  static const double bottomNavBarHeight = 70;
  static const double iconSize = 40;

  /// Each tuple is (svgAssetPath, title, index)
  final List<(String, String, int)> icons;
  final Function(int) onDestinationSelected;
  final int selectedIndex;

  const YRBottomNavBar({
    super.key,
    required this.icons,
    required this.onDestinationSelected,
    required this.selectedIndex,
  });

  @override
  State<YRBottomNavBar> createState() => _YRBottomNavBarState();
}

class _YRBottomNavBarState extends State<YRBottomNavBar> {
  late int currentIndex;
  // bool _showChatBubble = false;
  OverlayEntry? _chatOverlayEntry;

  // void _insertChatOverlay() {
  //   if (_chatOverlayEntry != null) return;
  //   _chatOverlayEntry = OverlayEntry(
  //     builder: (context) {
  //       return Material(
  //         type: MaterialType.transparency,
  //         child: Stack(
  //           children: [
  //             // Backdrop to allow closing when tapping outside
  //             Positioned.fill(
  //               child: GestureDetector(
  //                 behavior: HitTestBehavior.opaque,
  //                 onTap: _removeChatOverlay,
  //                 child: const SizedBox.shrink(),
  //               ),
  //             ),
  //             Positioned(
  //               left: 0,
  //               right: 0,
  //               bottom: 20,
  //               child: Center(
  //                 child: SalvoChatBubble(
  //                   onClose: _removeChatOverlay,
  //                   onOptionSelected: (String _) {
  //                     _removeChatOverlay();
  //                   },
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  //   Overlay.of(context).insert(_chatOverlayEntry!);
  // }

  void _removeChatOverlay() {
    _chatOverlayEntry?.remove();
    _chatOverlayEntry = null;
    // _showChatBubble = false;
  }

  @override
  void dispose() {
    _removeChatOverlay();
    super.dispose();
  }

  @override
  void initState() {
    currentIndex = widget.selectedIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: GVColors.white,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(46.8),
          topLeft: Radius.circular(46.8),
        ),
        boxShadow: [
          BoxShadow(
            color: GVColors.blackWithAlpha3,
            offset: const Offset(0, -10.4),
            blurRadius: 31.2,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Container(
        constraints: const BoxConstraints(
          minHeight: YRBottomNavBar.bottomNavBarHeight - 10,
          maxHeight: YRBottomNavBar.bottomNavBarHeight + 10,
        ),
        alignment: Alignment.center,
        child: Padding(
          padding: EdgeInsets.only(
            bottom: DeviceUtils.getInstance().isIos ? 15 : 0,
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // All navigation items (Home, Blog, Profile)
                  // TODO: When Store is re-enabled, restore the take(2)/skip(2) pattern
                  ...widget.icons.map<Widget>(
                    (e) => destinationItem(
                      assetPath: e.$1,
                      title: e.$2,
                      index: e.$3,
                    ),
                  ),
                  // Center spacer for profile image with AI badge (hidden for now)
                  // TODO: Re-enable when AI chat feature is ready
                  // Stack(
                  //   clipBehavior: Clip.none,
                  //   children: [
                  //     IconButton(
                  //       onPressed: () {
                  //         // _showChatBubble = !_showChatBubble;
                  //         // if (_showChatBubble) {
                  //         //   _insertChatOverlay();
                  //         // } else {
                  //         //   _removeChatOverlay();
                  //         // }
                  //       },
                  //       style: IconButton.styleFrom(
                  //         padding: EdgeInsets.zero,
                  //         shape: CircleBorder(
                  //           side: BorderSide(
                  //             color: GVColors.guidaEvaiOrange,
                  //             width: 2,
                  //           ),
                  //         ),
                  //       ),
                  //       icon: ClipOval(
                  //         child: Image.asset(
                  //           'assets/images/qp_logo.png',
                  //           width: 48,
                  //           height: 48,
                  //           fit: BoxFit.cover,
                  //         ),
                  //       ),
                  //       padding: EdgeInsets.zero,
                  //       constraints: const BoxConstraints(),
                  //     ),
                  //     // TODO: Re-enable AI badge when AI feature is ready
                  //     // AI badge positioned at bottom-right of avatar
                  //     // const Positioned(
                  //     //   right: -2,
                  //     //   bottom: -4,
                  //     //   child: AIBadge(),
                  //     // ),
                  //   ],
                  // ),
                ],
              ),
              // Chat bubble moved to overlay to allow hit testing outside nav bar bounds
            ],
          ),
        ),
      ),
    );
  }

  Widget destinationItem({
    required String assetPath,
    required String title,
    required int index,
  }) {
    bool isSelected = index == currentIndex;

    return Expanded(
      flex: 1,
      child: InkWell(
        onTap: () {
          widget.onDestinationSelected(index);
          setState(() {
            currentIndex = index;
          });
        },
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                assetPath,
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(
                  isSelected ? GVColors.black : GVColors.inactiveNavItemColor,
                  BlendMode.srcIn,
                ),
              ),
              SizedBox(height: 4),
              Text(
                title,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: isSelected
                      ? GVColors.black
                      : GVColors.inactiveNavItemColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
