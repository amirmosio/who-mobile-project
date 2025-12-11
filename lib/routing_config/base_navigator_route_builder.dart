import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:who_mobile_project/application.dart';
import 'package:who_mobile_project/main.dart';
import 'package:who_mobile_project/ui/base_template/nav_bar_base_page.dart';
import 'package:who_mobile_project/ui/auth_pages/login/login_page.dart';
import 'package:who_mobile_project/ui/not_found/not_found.dart';
import 'package:who_mobile_project/ui/auth_pages/register/registration_page.dart';
import 'package:who_mobile_project/ui/auth_pages/reset_password/reset_password_page.dart';
import 'package:who_mobile_project/ui/auth_pages/reset_password/reset_password_successful.dart';
import 'routes.dart';
import 'route_observer.dart';
import 'package:who_mobile_project/services/navigation_tracker.dart';
import 'package:who_mobile_project/ui/dashboard/dashboard_page.dart';
import 'package:who_mobile_project/ui/initial_loading/initial_loading.dart';
import 'package:who_mobile_project/general/widgets/section_placeholder.dart';

GoRouter baseNavRouterBuilder() {
  final homeGlobalKey = GlobalKey<NavigatorState>(debugLabel: "homeGlobalKey");
  // TODO: Re-enable when Store feature is ready
  // final callGlobalKey = GlobalKey<NavigatorState>(debugLabel: 'callGlobalKey');
  final blogGlobalKey = GlobalKey<NavigatorState>(debugLabel: 'blogGlobalKey');
  final settingsGlobalKey = GlobalKey<NavigatorState>(
    debugLabel: 'settingsGlobalKey',
  );

  GoRouter baseNavRouter = GoRouter(
    navigatorKey: mainRouterKey,
    observers: [routeObserver],
    initialLocation: YRRoutes.initialLoading,
    redirect: (context, state) {
      // Track GoRouter navigation
      GoRouterTracker().trackNavigation(
        state.uri.toString(),
        state.uri.path,
        params: state.pathParameters,
      );

      return null;
    },
    onException: (context, state, router) {
      Logger().e(
        "fullPath: ${state.fullPath}\nerror: ${state.error}\n${state.uri}",
      );
    },
    routes: [
      GoRoute(
        path: YRRoutes.initialLoading,
        name: YRRoutes.initialLoading,
        pageBuilder: (context, state) =>
            MaterialPage(child: InitialAppLoading()),
      ),
      GoRoute(
        name: YRRoutes.login,
        path: YRRoutes.login,
        pageBuilder: (context, state) => MaterialPage(child: LoginPage()),
      ),
      GoRoute(
        name: YRRoutes.register,
        path: YRRoutes.register,
        pageBuilder: (context, state) =>
            MaterialPage(child: RegistrationPage()),
      ),
      GoRoute(
        name: YRRoutes.resetPassword,
        path: YRRoutes.resetPassword,
        pageBuilder: (context, state) =>
            MaterialPage(child: ResetPasswordPage()),
      ),
      GoRoute(
        path: YRRoutes.resetPasswordSuccess,
        name: YRRoutes.resetPasswordSuccess,
        pageBuilder: (context, state) =>
            MaterialPage(child: ResetPasswordSuccessfulConfirmationPage()),
      ),
      GoRoute(
        path: YRRoutes.unknown,
        pageBuilder: (context, state) =>
            MaterialPage(child: NotFoundPage("Error")),
      ),

      StatefulShellRoute.indexedStack(
        // pageBuilder: (context, state, navigationShell) {
        //   /// TODO dirty code, provider can be used here instead to pass the navigationShell to children
        //   MyApp.navigationShell = navigationShell;
        //   return MaterialPage(child: );
        // },
        builder: (context, state, navigationShell) {
          MyApp.navigationShell = navigationShell;
          return BasePageWithNavBar(navigationShell);
        },
        branches: [
          StatefulShellBranch(
            navigatorKey: homeGlobalKey,
            routes: <RouteBase>[
              GoRoute(
                path: YRRoutes.dashBoard,
                name: YRRoutes.dashBoard,
                pageBuilder: (context, state) =>
                    MaterialPage(child: DashboardPage()),
              ),
            ],
          ),
          // TODO: Re-enable when Store feature is ready
          // StatefulShellBranch(
          //   navigatorKey: callGlobalKey,
          //   routes: [
          //     GoRoute(
          //       path: YRRoutes.recentCallList,
          //       name: YRRoutes.recentCallList,
          //       pageBuilder: (context, state) =>
          //           MaterialPage(child: Placeholder()),
          //     ),
          //   ],
          // ),
          StatefulShellBranch(
            navigatorKey: blogGlobalKey,
            routes: <RouteBase>[
              GoRoute(
                path: YRRoutes.blog,
                name: YRRoutes.blog,
                pageBuilder: (context, state) => const MaterialPage(
                  child: Scaffold(
                    body: Center(
                      child: SectionPlaceholder(text: 'Blog'),
                    ),
                  ),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: settingsGlobalKey,
            routes: <RouteBase>[
              GoRoute(
                path: YRRoutes.profileMenu,
                name: YRRoutes.profileMenu,
                pageBuilder: (context, state) => const MaterialPage(
                  child: Scaffold(
                    body: Center(
                      child: SectionPlaceholder(text: 'Profile & Settings'),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );
  return baseNavRouter;
}
