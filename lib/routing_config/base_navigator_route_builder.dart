import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:who_mobile_project/application.dart';
import 'package:who_mobile_project/main.dart';
import 'package:who_mobile_project/ui/base_template/nav_bar_base_page.dart';
import 'package:who_mobile_project/ui/auth_pages/login/login_page.dart';
import 'package:who_mobile_project/ui/auth_pages/login/admin_login_page.dart';
import 'package:who_mobile_project/ui/auth_pages/admin_panel/admin_panel_page.dart';
import 'package:who_mobile_project/ui/not_found/not_found.dart';
import 'package:who_mobile_project/ui/auth_pages/register/registration_page.dart';
import 'package:who_mobile_project/ui/auth_pages/reset_password/reset_password_page.dart';
import 'package:who_mobile_project/ui/auth_pages/reset_password/reset_password_successful.dart';
import 'package:who_mobile_project/ui/installation_guide/installation_steps_list_page.dart';
import 'package:who_mobile_project/ui/installation_guide/installation_step_detail_page.dart';
import 'package:who_mobile_project/ui/installation_guide/installation_substep_detail_page.dart';
import 'package:who_mobile_project/ui/dismantling_guide/dismantling_steps_list_page.dart';
import 'package:who_mobile_project/ui/dismantling_guide/dismantling_step_detail_page.dart';
import 'package:who_mobile_project/ui/dismantling_guide/dismantling_substep_detail_page.dart';
import 'routes.dart';
import 'route_observer.dart';
import 'package:who_mobile_project/services/navigation_tracker.dart';
import 'package:who_mobile_project/ui/dashboard/dashboard_page.dart';
import 'package:who_mobile_project/ui/initial_loading/initial_loading.dart';
import 'package:who_mobile_project/general/widgets/section_placeholder.dart';
import 'package:who_mobile_project/ui/profile_and_settings/profile_menu_page.dart';
import 'package:who_mobile_project/ui/idtm/packing_list_page.dart';
import 'package:who_mobile_project/ui/idtm/maintenance_page.dart';
import 'package:who_mobile_project/ui/idtm/dismantling_page.dart';

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
    initialLocation: YRRoutes.dashBoard,
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

      // Admin Routes
      GoRoute(
        path: YRRoutes.adminLogin,
        name: YRRoutes.adminLogin,
        pageBuilder: (context, state) =>
            const MaterialPage(child: AdminLoginPage()),
      ),
      GoRoute(
        path: YRRoutes.adminPanel,
        name: YRRoutes.adminPanel,
        pageBuilder: (context, state) =>
            const MaterialPage(child: AdminPanelPage()),
      ),

      // Installation Guide Routes
      GoRoute(
        path: YRRoutes.installationStepsList,
        name: YRRoutes.installationStepsList,
        pageBuilder: (context, state) =>
            const MaterialPage(child: InstallationStepsListPage()),
      ),
      GoRoute(
        path: YRRoutes.installationStepDetail,
        name: YRRoutes.installationStepDetail,
        pageBuilder: (context, state) {
          final stepId = state.pathParameters['stepId']!;
          return MaterialPage(
            child: InstallationStepDetailPage(stepId: stepId),
          );
        },
      ),
      GoRoute(
        path: YRRoutes.installationSubstepDetail,
        name: YRRoutes.installationSubstepDetail,
        pageBuilder: (context, state) {
          final stepId = state.pathParameters['stepId']!;
          final substepId = state.pathParameters['substepId']!;
          return MaterialPage(
            child: InstallationSubstepDetailPage(
              stepId: stepId,
              substepId: substepId,
            ),
          );
        },
      ),

      // Dismantling Guide Routes
      GoRoute(
        path: YRRoutes.dismantlingStepsList,
        name: YRRoutes.dismantlingStepsList,
        pageBuilder: (context, state) =>
            const MaterialPage(child: DismantlingStepsListPage()),
      ),
      GoRoute(
        path: YRRoutes.dismantlingStepDetail,
        name: YRRoutes.dismantlingStepDetail,
        pageBuilder: (context, state) {
          final stepId = state.pathParameters['stepId']!;
          return MaterialPage(
            child: DismantlingStepDetailPage(stepId: stepId),
          );
        },
      ),
      GoRoute(
        path: YRRoutes.dismantlingSubstepDetail,
        name: YRRoutes.dismantlingSubstepDetail,
        pageBuilder: (context, state) {
          final stepId = state.pathParameters['stepId']!;
          final substepId = state.pathParameters['substepId']!;
          return MaterialPage(
            child: DismantlingSubstepDetailPage(
              stepId: stepId,
              substepId: substepId,
            ),
          );
        },
      ),

      // IDTM Routes
      GoRoute(
        path: YRRoutes.idtmPackingList,
        name: YRRoutes.idtmPackingList,
        pageBuilder: (context, state) =>
            const MaterialPage(child: PackingListPage()),
      ),
      GoRoute(
        path: YRRoutes.idtmInstallationDetail,
        name: YRRoutes.idtmInstallationDetail,
        pageBuilder: (context, state) {
          return const MaterialPage(child: InstallationStepsListPage());
        },
      ),
      GoRoute(
        path: YRRoutes.idtmMaintenance,
        name: YRRoutes.idtmMaintenance,
        pageBuilder: (context, state) {
          final installationId = state.pathParameters['installationId'] ?? '';
          return MaterialPage(
            child: MaintenancePage(installationId: installationId),
          );
        },
      ),
      GoRoute(
        path: YRRoutes.idtmDismantling,
        name: YRRoutes.idtmDismantling,
        pageBuilder: (context, state) {
          final installationId = state.pathParameters['installationId'] ?? '';
          return MaterialPage(
            child: DismantlingPage(installationId: installationId),
          );
        },
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
                    body: Center(child: SectionPlaceholder(text: 'Blog')),
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
                  child: ProfileMenuPage(),
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
