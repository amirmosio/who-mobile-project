import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:who_mobile_project/general/models/auth/admin_user.dart';
import 'package:who_mobile_project/providers/auth/auth_repository_provider.dart';

part 'admin_users_provider.g.dart';

/// Stream provider for admin users list (for admin panel)
/// Uses Firestore offline persistence for caching
/// Only super admin should access this provider
///
/// Example usage:
/// ```dart
/// final adminsAsync = ref.watch(adminUsersStreamProvider);
/// adminsAsync.when(
///   data: (admins) => ListView.builder(...),
///   loading: () => CircularProgressIndicator(),
///   error: (e, _) => ErrorWidget(e),
/// );
/// ```
@Riverpod(keepAlive: true)
Stream<List<AdminUser>> adminUsersStream(Ref ref) {
  final repository = ref.watch(firebaseAuthRepositoryProvider);
  return repository.getAdminUsersStream();
}

/// Provider for filtered active admin users only
/// Useful for displaying only active admins in certain views
@riverpod
List<AdminUser> activeAdminUsers(Ref ref) {
  final adminsAsync = ref.watch(adminUsersStreamProvider);
  return adminsAsync.when(
    data: (admins) => admins.where((admin) => admin.isActive).toList(),
    loading: () => [],
    error: (_, __) => [],
  );
}

/// Provider for filtered inactive admin users only
/// Useful for displaying deactivated admins in admin panel
@riverpod
List<AdminUser> inactiveAdminUsers(Ref ref) {
  final adminsAsync = ref.watch(adminUsersStreamProvider);
  return adminsAsync.when(
    data: (admins) => admins.where((admin) => !admin.isActive).toList(),
    loading: () => [],
    error: (_, __) => [],
  );
}

/// Provider for total admin count (excluding super admin count)
@riverpod
int adminCount(Ref ref) {
  final adminsAsync = ref.watch(adminUsersStreamProvider);
  return adminsAsync.when(
    data: (admins) => admins.where((admin) => !admin.isSuperAdmin).length,
    loading: () => 0,
    error: (_, __) => 0,
  );
}
