import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:who_mobile_project/app_core/theme/colors.dart';
import 'package:who_mobile_project/app_core/theme/theme.dart';
import 'package:who_mobile_project/generated/i18n/app_localizations.dart';
import 'package:who_mobile_project/routing_config/base_navigator_route_builder.dart';
import 'package:who_mobile_project/ui/feedback/feedback_floating_button.dart';
import 'package:who_mobile_project/app_core/config/environment_constants.dart';
import 'package:who_mobile_project/general/constants/available_languages.dart';

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  /// dirty code
  /// Provider can be used instead if it causes more problems or effect the performance
  static late StatefulNavigationShell navigationShell;

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  final GoRouter baseNavRouter = baseNavRouterBuilder();

  // GlobalKey for screenshot capture (used in builder below)
  // ignore: unused_field
  final GlobalKey _appScreenKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    // TODO: Removed - appPreferencesProvider no longer available
    // Using default values: isDsaFontEnabled = false, locale = Italian
    return Container(
      color: BZColors.background,
      child: Container(
        color: BZColors.background,
        child: MaterialApp.router(
          key: UniqueKey(),
          title: 'App Material',
          color: Colors.transparent,
          debugShowCheckedModeBanner: false,
          theme: YRTheme.getTheme(false), // Default: DSA font disabled
          routerDelegate: baseNavRouter.routerDelegate,
          routeInformationParser: baseNavRouter.routeInformationParser,
          routeInformationProvider: baseNavRouter.routeInformationProvider,
          localizationsDelegates: [
            AppLocalizations.delegate, // Add this line
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          locale: const Locale('it', 'IT'), // Default: Italian
          supportedLocales: AvailableLanguage.allLocales,
          builder: (context, child) {
            return Stack(
              children: [
                // Wrap entire app navigation with RepaintBoundary for screenshots
                RepaintBoundary(
                  key: _appScreenKey,
                  child: child ?? const SizedBox.shrink(),
                ),
                // Global feedback button - appears on all pages in staging
                if (Constants.env == Environment.staging ||
                    Constants.env == Environment.local)
                  FeedbackFloatingButton(
                    screenKey: _appScreenKey, // Pass key for screenshot capture
                    bottom: 100, // Position from bottom
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
