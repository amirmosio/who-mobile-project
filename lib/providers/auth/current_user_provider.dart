import 'package:get_it/get_it.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:who_mobile_project/general/models/auth/app_user.dart';
import 'package:who_mobile_project/general/services/storage/storage_manager.dart';
import 'package:who_mobile_project/providers/auth/auth_repository_provider.dart';

part 'current_user_provider.g.dart';

/// Provider for the current authenticated user
/// Uses caching for performance - returns cached data when available
/// Returns AppUser.guest() if not authenticated
@Riverpod(keepAlive: true)
class CurrentUser extends _$CurrentUser {
  late final StorageManager _storageManager;

  /// Cache validity duration (5 minutes)
  static const Duration _cacheValidityDuration = Duration(minutes: 5);

  /// In-memory cache for current user
  AppUser? _cachedUser;
  DateTime? _lastFetch;

  /// Check if in-memory cache is still valid
  bool get _isCacheValid =>
      _cachedUser != null &&
      _lastFetch != null &&
      DateTime.now().difference(_lastFetch!) < _cacheValidityDuration;

  @override
  Future<AppUser> build() async {
    _storageManager = GetIt.instance<StorageManager>();

    // First, try in-memory cache
    if (_isCacheValid && _cachedUser != null) {
      return _cachedUser!;
    }

    // Second, try local storage cache
    final cachedUser = await _storageManager.getCachedUserData();
    if (cachedUser != null && cachedUser.isAuthenticated) {
      _cachedUser = cachedUser;
      _lastFetch = DateTime.now();
      return cachedUser;
    }

    // Finally, fetch from Firebase
    final repository = ref.read(firebaseAuthRepositoryProvider);
    final user = await repository.getCurrentUser();

    // Cache the result
    _cachedUser = user;
    _lastFetch = DateTime.now();

    if (user.isAuthenticated) {
      await _storageManager.cacheUserData(user);
      await _storageManager.cacheUserRole(user.role);
    }

    return user;
  }

  /// Refresh current user data from Firebase
  /// Invalidates cache and fetches fresh data
  Future<void> refresh() async {
    _invalidateCache();
    state = const AsyncLoading();

    try {
      final repository = ref.read(firebaseAuthRepositoryProvider);
      final user = await repository.getCurrentUser();

      _cachedUser = user;
      _lastFetch = DateTime.now();

      if (user.isAuthenticated) {
        await _storageManager.cacheUserData(user);
        await _storageManager.cacheUserRole(user.role);
      }

      state = AsyncData(user);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  /// Set user after successful login
  /// Updates both in-memory and local storage cache
  void setUser(AppUser user) {
    _cachedUser = user;
    _lastFetch = DateTime.now();
    state = AsyncData(user);

    // Also update local storage cache
    _storageManager.cacheUserData(user);
    _storageManager.cacheUserRole(user.role);
  }

  /// Clear user on logout
  /// Clears all caches and sets user to guest
  void clearUser() {
    _invalidateCache();
    _storageManager.clearRoleCache();
    state = AsyncData(AppUser.guest());
  }

  /// Invalidate in-memory cache
  void _invalidateCache() {
    _cachedUser = null;
    _lastFetch = null;
  }

  /// Force invalidate all caches and trigger a refresh
  Future<void> invalidateAndRefresh() async {
    _invalidateCache();
    await _storageManager.clearRoleCache();
    ref.invalidateSelf();
  }
}
