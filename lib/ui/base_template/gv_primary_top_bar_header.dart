import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:who_mobile_project/general/utils/email_launcher.dart';

class GVPrimaryTopBarHeader extends ConsumerWidget {
  static const double height = 50;
  final Widget child;
  final bool isScrollable;

  const GVPrimaryTopBarHeader({
    super.key,
    required this.child,
    this.isScrollable = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        (isScrollable)
            ? SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(top: height),
                  child: child,
                ),
              )
            : Padding(
                padding: const EdgeInsets.only(top: height),
                child: child,
              ),
        _buildTopBar(context, ref),
      ],
    );
  }

  Widget _buildTopBar(BuildContext context, WidgetRef ref) {
    // TODO: Removed - User profile and notifications
    // No user profile or notifications available anymore
    const bool hasUnreadNotifications = false;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          alignment: Alignment.topCenter,
          height: height,
          width: double.infinity,
          color: Colors.white.withValues(alpha: 0.6),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Logo or app name placeholder
              Image.asset(
                'assets/images/figma_designs/login_illustration.png',
                height: 32,
              ),
              Row(
                children: [
                  IconButton(
                    icon: SvgPicture.asset(
                      'assets/images/figma_designs/email_icon.svg',
                      width: 33,
                      height: 33,
                      colorFilter: const ColorFilter.mode(
                        Colors.black,
                        BlendMode.srcIn,
                      ),
                    ),
                    padding: const EdgeInsets.only(top: 2),
                    onPressed: () => EmailLauncher.launchSupportEmail(context),
                  ),
                  Stack(
                    children: [
                      IconButton(
                        icon: SvgPicture.asset(
                          'assets/images/figma_designs/icon_notification.svg',
                          width: 23,
                          height: 23,
                          colorFilter: const ColorFilter.mode(
                            Colors.black,
                            BlendMode.srcIn,
                          ),
                        ),
                        onPressed: () {},
                      ),
                      if (hasUnreadNotifications)
                        Positioned(
                          top: 14,
                          right: 14,
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 1.2,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
