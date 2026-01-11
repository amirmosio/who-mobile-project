import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:who_mobile_project/app_core/theme/colors.dart';
import 'package:who_mobile_project/app_core/theme/theme.dart';
import 'package:who_mobile_project/generated/i18n/app_localizations.dart';
import 'package:who_mobile_project/providers/app_locale/app_locale_provider.dart';
import 'package:who_mobile_project/routing_config/base_navigator_route_builder.dart';
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

  @override
  Widget build(BuildContext context) {
    // Watch the locale provider for reactive updates
    final locale = ref.watch(appLocaleProvider);

    return Container(
      color: BZColors.background,
      child: Container(
        color: BZColors.background,
        child: MaterialApp.router(
          key: ValueKey(locale), // Rebuild when locale changes
          title: 'App Material',
          color: Colors.transparent,
          debugShowCheckedModeBanner: false,
          theme: YRTheme.getTheme(false), // Default: DSA font disabled
          routerDelegate: baseNavRouter.routerDelegate,
          routeInformationParser: baseNavRouter.routeInformationParser,
          routeInformationProvider: baseNavRouter.routeInformationProvider,
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          locale: locale, // Dynamic locale from provider
          supportedLocales: AvailableLanguage.allLocales,
        ),
      ),
    );
  }
}
