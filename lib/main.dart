import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:who_mobile_project/general/services/storage/storage_manager.dart';
import 'package:who_mobile_project/general/services/device/device_service.dart';
import 'package:who_mobile_project/di/injector.dart';
import 'package:who_mobile_project/app_core/config/environment_constants.dart';
import 'package:who_mobile_project/general/widgets/restart_widget.dart';
import 'package:who_mobile_project/firebase_options.dart';

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

  // Initialize Firebase with offline persistence
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );
  debugPrint('Firebase initialized successfully');

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
    // await getIt.get<NotificationManager>().initialize();
  } catch (e) {
    debugPrint('Notification initialization failed: $e');
    // Continue with app initialization even if notifications fail
  }
}

void main() async {
  Constants.setEnvironment(Environment.local);

  await initialSetup();
  runApp(
    DefaultAssetBundle(
      bundle: SentryAssetBundle(),
      child: RestartWidget(child: MyApp()),
    ),
  );
}
