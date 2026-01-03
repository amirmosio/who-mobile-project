import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:who_mobile_project/general/constants/user_roles.dart';
import 'package:who_mobile_project/providers/auth/current_user_provider.dart';

part 'role_access_provider.g.dart';

/// Provider for role-based access control
/// Use this to check permissions throughout the app
///
/// Example usage:
/// ```dart
/// final role = ref.watch(roleAccessProvider);
/// if (role.isAdminOrAbove) {
///   // Show admin features
/// }
/// ```
@Riverpod(keepAlive: true)
class RoleAccess extends _$RoleAccess {
  @override
  UserRole build() {
    final userAsync = ref.watch(currentUserProvider);
    return userAsync.when(
      data: (user) => user.role,
      loading: () => UserRole.guest,
      error: (_, __) => UserRole.guest,
    );
  }

  /// Check if current user is authenticated (not guest)
  bool get isAuthenticated {
    final userAsync = ref.read(currentUserProvider);
    return userAsync.value?.isAuthenticated ?? false;
  }

  /// Check if current user is guest
  bool get isGuest => state == UserRole.guest;

  /// Check if current user has admin access (admin or super admin)
  bool get hasAdminAccess => state.isAdminOrAbove;

  /// Check if current user is super admin
  bool get isSuperAdmin => state.isSuperAdmin;

  /// Check if user can access a specific feature
  /// This method can be expanded for feature gating in future sprints
  ///
  /// Currently defined features:
  /// - 'admin_panel': Only super admin
  /// - 'manage_content': Admin or super admin
  /// - 'view_analytics': Admin or super admin
  /// - Default: All users (guests included)
  bool canAccess(String feature) {
    switch (feature) {
      case 'admin_panel':
        return isSuperAdmin;
      case 'manage_content':
      case 'view_analytics':
      case 'edit_settings':
        return hasAdminAccess;
      default:
        // By default, guests can access most features
        return true;
    }
  }

  /// Check if user has at least the specified minimum role
  bool hasMinimumRole(UserRole minimumRole) {
    switch (minimumRole) {
      case UserRole.guest:
        return true; // Everyone has at least guest access
      case UserRole.admin:
        return state.isAdminOrAbove;
      case UserRole.superAdmin:
        return state.isSuperAdmin;
    }
  }
}

/// Convenience provider to check if user has admin access
/// Use this in widgets for quick admin checks
///
/// Example:
/// ```dart
/// final canEdit = ref.watch(hasAdminAccessProvider);
/// if (canEdit) {
///   // Show edit button
/// }
/// ```
@riverpod
bool hasAdminAccess(Ref ref) {
  final role = ref.watch(roleAccessProvider);
  return role.isAdminOrAbove;
}

/// Convenience provider to check if user is super admin
/// Use this to conditionally show admin management features
///
/// Example:
/// ```dart
/// final isSuperAdmin = ref.watch(isSuperAdminProvider);
/// if (isSuperAdmin) {
///   // Show admin management button
/// }
/// ```
@riverpod
bool isSuperAdmin(Ref ref) {
  final role = ref.watch(roleAccessProvider);
  return role.isSuperAdmin;
}

/// Convenience provider to check if user is guest (not authenticated)
/// Use this to show login prompts or restricted content messages
///
/// Example:
/// ```dart
/// final isGuest = ref.watch(isGuestProvider);
/// if (isGuest) {
///   // Show "Login to access this feature" message
/// }
/// ```
@riverpod
bool isGuest(Ref ref) {
  final role = ref.watch(roleAccessProvider);
  return role == UserRole.guest;
}

/// Provider that returns the current user's role
/// Useful for displaying role badges or role-specific UI
@riverpod
UserRole currentUserRole(Ref ref) {
  return ref.watch(roleAccessProvider);
}
