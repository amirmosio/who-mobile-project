import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:who_mobile_project/app_core/config/environment_constants.dart';
import 'package:who_mobile_project/routing_config/routes.dart';
import 'package:who_mobile_project/di/injector.dart';
import 'package:who_mobile_project/general/services/storage/storage_manager.dart';
import 'package:who_mobile_project/general/database/native_database_migration_service.dart';
import 'package:who_mobile_project/general/database/app_database.dart';
import 'package:who_mobile_project/ui/initial_loading/initialization_progress_controller.dart';
import 'package:who_mobile_project/general/services/permissions/permission_service.dart';
import 'package:who_mobile_project/general/widgets/my_loading_gif.dart';
import 'package:who_mobile_project/ui/initial_loading/widgets/initialization_progress_widget.dart';

class InitialAppLoading extends ConsumerStatefulWidget {
  const InitialAppLoading({super.key});

  @override
  ConsumerState<InitialAppLoading> createState() => _InitialAppLoadingState();
}

class _InitialAppLoadingState extends ConsumerState<InitialAppLoading> {
  late final InitializationProgressController _progressController;

  @override
  void initState() {
    super.initState();
    _progressController = InitializationProgressController();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _progressController.updateStep(InitializationStep.starting);
      final nativeDatabaseMigrationService =
          getIt<NativeDatabaseMigrationService>();

      // Check if reset has already been done
      if (!getIt<StorageManager>().getDevelopmentResetOfDatabase() &&
          [Environment.staging, Environment.local].contains(Constants.env)) {
        try {
          await getIt<AppDatabase>().resetDatabase();
        } finally {
          await getIt<StorageManager>().setLastDatabaseUpdate(
            -1,
            DateTime.now().subtract(Duration(days: 365 * 20)).toIso8601String(),
          );
          await getIt<StorageManager>().setDevelopmentResetOfDatabase(true);
          await getIt<StorageManager>().setTagBookQrCache({});
        }
      }

      // await getIt<AppDatabase>().resetDatabase();
      // await getIt<StorageManager>().setLastDatabaseUpdate(-1,
      //     DateTime.now().subtract(Duration(days: 365 * 20)).toIso8601String());
      //await storageManager.setNativeDatabaseMigrationCompleted(false);

      _progressController.updateStep(InitializationStep.migration);
      await nativeDatabaseMigrationService.migrateIfNeeded();

      // Pre-open DB and reduce first heavy-write contention
      try {
        await getIt<AppDatabase>().getDatabaseStats();
      } catch (_) {}

      // TODO: Removed - Load Redvertising campaigns on app startup (fire and forget)
      // ref.read(redvertisingCampaignsProvider);

      _progressController.updateStep(InitializationStep.auth);
      // TODO: Removed - Authentication initialization and user profile fetching

      // Request notification + exact alarm permissions (Android)
      // Done after UI is loaded to avoid blocking app startup
      try {
        await YRPermissionHandler.ensureReminderPermissions();
      } catch (e) {
        debugPrint('Permission request failed: $e');
        // Continue with app initialization even if permissions fail
      }

      _progressController.updateStep(InitializationStep.version);
      await checkForVersionAndAuthentication();
    });
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  // TODO: Removed - Store update functionality
  // void openProperStoreForUpdating({String? updateLink}) { ... }

  Future<void> checkForVersionAndAuthentication() async {
    // TODO: Removed - Version check no longer available
    // Skip version check and go directly to dashboard
    if (mounted) {
      context.go(YRRoutes.dashBoard, extra: {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SizedBox(
          width: 280,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MyLoadingGifWidget(),
              const SizedBox(height: 60),
              InitializationProgressWidget(controller: _progressController),
            ],
          ),
        ),
      ),
    );
  }
}
