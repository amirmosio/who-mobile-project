import 'package:get_it/get_it.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:who_mobile_project/general/models/auth/app_user.dart';
import 'package:who_mobile_project/general/services/storage/storage_manager.dart';
import 'package:who_mobile_project/providers/auth/auth_repository_provider.dart';
import 'package:who_mobile_project/providers/auth/current_user_provider.dart';
import 'package:who_mobile_project/providers/base/base_api_notifier.dart';
import 'package:who_mobile_project/providers/base/base_api_state.dart';
import 'package:who_mobile_project/providers/maintenance/scheduled_alerts_provider.dart';
import 'package:who_mobile_project/repository/auth/firebase_auth_repository.dart';

part 'auth_provider.g.dart';

/// Main authentication provider
/// Manages login/logout state and auth operations
@Riverpod(keepAlive: true)
class AuthNotifier extends BaseApiNotifier<BaseApiState> {
  late final FirebaseAuthRepository _repository;
  late final StorageManager _storageManager;

  @override
  BaseApiState build() {
    _repository = ref.read(firebaseAuthRepositoryProvider);
    _storageManager = GetIt.instance<StorageManager>();
    return const BaseApiInitial();
  }

  /// Sign in with email and password
  /// Returns AppUser on success, null on failure
  Future<AppUser?> signIn(String email, String password) async {
    final user = await executeApiCallAndSetState<AppUser>(
      () => _repository.signIn(email, password),
      loadingMessage: 'Signing in...',
      successMessage: 'Signed in successfully',
    );

    if (user != null) {
      // Cache user data for quick access
      await _storageManager.cacheUserData(user);
      await _storageManager.cacheUserRole(user.role);

      // Update current user provider
      ref.read(currentUserProvider.notifier).setUser(user);
    }

    return user;
  }

  /// Sign out from Firebase Auth
  /// Clears cached data, cancels alerts, and resets current user
  Future<bool> signOut() async {
    final success = await executeOperationAndSetState(
      () => _repository.signOut(),
      successMessage: 'Signed out successfully',
      onSuccess: () async {
        // Cancel all scheduled maintenance alerts
        await ref.read(scheduledAlertsProvider.notifier).cancelAllAlerts();

        // Clear cached user data
        await _storageManager.clearRoleCache();

        // Reset current user to guest
        ref.read(currentUserProvider.notifier).clearUser();

        // Reset auth state
        state = const BaseApiInitial();
      },
    );

    return success;
  }

  /// Create new admin user (super admin only)
  /// Uses secondary Firebase app to create user without signing out current user
  Future<bool> createAdmin({
    required String email,
    required String password,
    String? displayName,
    required String createdBy,
  }) async {
    return executeOperationAndSetState(
      () => _repository.createAdmin(
        email: email,
        password: password,
        createdBy: createdBy,
        displayName: displayName,
      ),
      successMessage: 'Admin created successfully',
      errorMessage: 'Failed to create admin',
    );
  }

  /// Deactivate admin user (super admin only)
  Future<bool> deactivateAdmin(String uid) async {
    return executeOperationAndSetState(
      () => _repository.deactivateAdmin(uid),
      successMessage: 'Admin deactivated successfully',
      errorMessage: 'Failed to deactivate admin',
    );
  }

  /// Reactivate admin user (super admin only)
  Future<bool> reactivateAdmin(String uid) async {
    return executeOperationAndSetState(
      () => _repository.reactivateAdmin(uid),
      successMessage: 'Admin reactivated successfully',
      errorMessage: 'Failed to reactivate admin',
    );
  }

  /// Update admin display name
  Future<bool> updateAdminDisplayName(String uid, String displayName) async {
    return executeOperationAndSetState(
      () => _repository.updateAdminDisplayName(uid, displayName),
      successMessage: 'Display name updated',
      errorMessage: 'Failed to update display name',
    );
  }

  /// Check if there's a currently authenticated user
  bool get isAuthenticated => _repository.isAuthenticated;

  /// Reset provider state to initial
  void reset() {
    state = const BaseApiInitial();
  }
}
