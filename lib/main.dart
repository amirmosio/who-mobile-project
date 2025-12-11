import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
// COMMENTED OUT - Firebase Messaging (keeping for future use)
// import 'package:who_mobile_project/app_core/firebase_notification/firebase_service_manager.dart';
import 'package:who_mobile_project/app_core/notification/notification_manager.dart';

import 'package:who_mobile_project/general/services/storage/storage_manager.dart';
import 'package:who_mobile_project/general/services/device/device_service.dart';
import 'package:who_mobile_project/di/injector.dart';
import 'package:who_mobile_project/app_core/config/environment_constants.dart';
import 'package:who_mobile_project/general/widgets/restart_widget.dart';

import '../application.dart';

final GlobalKey<NavigatorState> mainRouterKey = GlobalKey<NavigatorState>();

Future<void> initialSetup() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock app to portrait orientation by default
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [
      SystemUiOverlay.top,
    ], // no overlays = both status and nav bars are hidden
  );

  // Initialize CallKeep and set up handlers BEFORE any other initialization

  // Initialize Firebase Core with platform-specific options (required for Firestore)
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  debugPrint('✅ Firebase initialized successfully');

  await configureDependencies();

  // Initialize cached app version for synchronous access
  await DeviceUtils.init();

  await getIt.get<StorageManager>().initialize();
  if (Constants.env == Environment.local) {
    String? storageBaseUrl = (await SharedPreferences.getInstance()).getString(
      "base_url_local",
    );
    String? storageBaseWebsocketUrl = (await SharedPreferences.getInstance())
        .getString("base_websocket_url_local");
    if (storageBaseUrl != null && storageBaseUrl.isNotEmpty) {
      NetworkAddressConfig.localConstants[NetworkAddressConfig.baseUrl] =
          storageBaseUrl;
    }
    if (storageBaseWebsocketUrl != null && storageBaseWebsocketUrl.isNotEmpty) {
      NetworkAddressConfig.localConstants[NetworkAddressConfig.baseSocketUrl] =
          storageBaseWebsocketUrl;
    }
  }

  try {
    // COMMENTED OUT - Firebase (keeping for future use)
    // await getIt.get<FirebaseServiceManager>().initialize();
    // getIt.get<FirebaseServiceManager>().configureBackgroundMessageHandler();

    // Initialize local notifications (independent of push notifications)
    await getIt.get<NotificationManager>().initialize();
  } catch (e) {
    debugPrint('Notification initialization failed: $e');
    // Continue with app initialization even if notifications fail
  }
}

void main() async {
  Constants.setEnvironment(Environment.staging);
  await dotenv.load(fileName: ".env");

  // Configure Sentry for all environments (local, staging, production)
  await SentryFlutter.init(
    (options) async {
      options.dsn = dotenv.env['SENTRY_DSN'];
      options.environment = Constants.env.name;
      options.screenshotQuality = SentryScreenshotQuality.low;

      if (Constants.env == Environment.local) {
        // Local environment: Only user feedback, no crashes/exceptions
        options.debug = false;

        // Capture 100% of feedback messages (no sampling)
        options.sampleRate = 1.0;

        // Disable automatic error capture
        options.enableAutoSessionTracking = false;
        options.enableAutoNativeBreadcrumbs = false;
        options.attachScreenshot = false;
        options.attachViewHierarchy = false;

        // Disable performance monitoring
        options.tracesSampleRate = 0.0;
        options.profilesSampleRate = 0.0;

        // Only send events that are explicitly captured (user feedback)
        options.beforeSend = (event, hint) {
          // Allow feedback context events
          if (event.contexts['feedback'] != null ||
              event.contexts['feedback_details'] != null) {
            return event;
          }

          // Drop all automatic crash/exception events
          return null;
        };
      } else if (Constants.env == Environment.staging) {
        options.debug = true;
        options.sampleRate = 1.0;
        options.enableAutoSessionTracking = true;
        options.attachScreenshot = true;
        options.attachViewHierarchy = true;
      } else {
        options.debug = false;
        options.sampleRate = 1.0;
        options.enableAutoSessionTracking = true;
        options.attachScreenshot = true;
        options.attachViewHierarchy = true;
      }
    },
    appRunner: () async {
      await initialSetup();
      runApp(
        DefaultAssetBundle(
          bundle: SentryAssetBundle(),
          child: RestartWidget(child: MyApp()),
        ),
      );
    },
  );
}
