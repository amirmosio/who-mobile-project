import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
// COMMENTED OUT - Firebase (keeping for future use)
// import 'package:who_mobile_project/app_core/firebase_notification/firebase_service_manager.dart';
// import 'package:who_mobile_project/app_core/firebase_notification/handlers.dart';
import 'package:who_mobile_project/generated/i18n/app_localizations.dart';
import 'package:who_mobile_project/routing_config/routes.dart';
import 'package:who_mobile_project/ui/base_template/yr_bottom_nav_bar.dart';
import 'package:showcaseview/showcaseview.dart';

class BasePageWithNavBar extends ConsumerStatefulWidget {
  /// The navigation shell and container for the branch Navigators.
  final StatefulNavigationShell navigationShell;

  const BasePageWithNavBar(this.navigationShell, {super.key});

  @override
  ConsumerState<BasePageWithNavBar> createState() => _BasePageWithNavBarState();
}

class _BasePageWithNavBarState extends ConsumerState<BasePageWithNavBar>
    with WidgetsBindingObserver {
  // TODO: Removed - Authentication state handling and guest mode snackbar
  // bool _hasShownGuestSnackbar = false;
  // bool _hasCheckedAddress = false;
  // void _showGuestSnackbarIfNeeded() { ... }
  // void _handleAuthenticationState(BaseApiState authState) { ... }
  // void _checkSubscribedUserAddress() { ... }

  void _onNavigationItemSelected(int index) {
    // If the same tab is selected, navigate to root of that branch
    if (widget.navigationShell.currentIndex == index) {
      // Navigate to the root route of the current branch
      switch (index) {
        case 0: // Home tab
          context.go(YRRoutes.dashBoard);
          break;
        // TODO: Re-enable when Store feature is ready
        // case 1: // Store tab
        //   context.go(YRRoutes.recentCallList);
        //   break;
        case 1: // Blog tab
          context.go(YRRoutes.dashBoard);
          break;
        case 2: // Profile tab
          context.go(YRRoutes.dashBoard);
          break;
      }
    } else {
      // Navigate to different branch
      widget.navigationShell.goBranch(index);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Removed - Authentication state listener
    // ref.listen(appAccountingProvider, (previous, next) { ... });

    final orientation = MediaQuery.of(context).orientation;
    final isLandscape = orientation == Orientation.landscape;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
      body: SafeArea(
        top: true,
        bottom: false,
        child: ShowCaseWidget(
          disableBarrierInteraction: true,
          onFinish: () {},
          globalTooltipActionConfig: const TooltipActionConfig(
            position: TooltipActionPosition.outside,
          ),
          builder: (context) {
            return Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  key: ValueKey("navigationShell padding"),
                  children: [
                    Expanded(child: widget.navigationShell),
                    if (!isLandscape)
                      SizedBox(
                        height: YRBottomNavBar.bottomNavBarHeight,
                        width: double.infinity,
                      ),
                  ],
                ),
                if (!isLandscape)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: YRBottomNavBar(
                      key: ValueKey(widget.navigationShell.currentIndex),
                      selectedIndex: widget.navigationShell.currentIndex,
                      onDestinationSelected: (int index) {
                        _onNavigationItemSelected(index);
                      },
                      icons: [
                        (
                          'assets/images/figma_designs/icon_nav_home.svg',
                          AppLocalizations.of(context)!.home,
                          0,
                        ),
                        // TODO: Re-enable when Store feature is ready
                        // (
                        //   'assets/images/figma_designs/icon_nav_store.svg',
                        //   AppLocalizations.of(context)!.store,
                        //   1
                        // ),
                        (
                          'assets/images/figma_designs/icon_nav_blog.svg',
                          AppLocalizations.of(context)!.news,
                          1,
                        ),
                        (
                          'assets/images/figma_designs/icon_nav_profile.svg',
                          AppLocalizations.of(context)!.profile,
                          2,
                        ),
                      ],
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
