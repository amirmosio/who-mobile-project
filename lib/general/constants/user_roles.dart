/// User roles for the WHO Mobile app
/// Used for role-based access control throughout the application
enum UserRole {
  /// Default role for non-authenticated users
  /// Can access limited features (to be defined in future sprints)
  guest,

  /// Authenticated admin user
  /// Has full access to all features
  admin,

  /// Super admin with admin management capabilities
  /// Can create, deactivate, and manage admin users
  superAdmin;

  /// Check if role has admin privileges (admin or super admin)
  bool get isAdminOrAbove => this == admin || this == superAdmin;

  /// Check if role is super admin
  bool get isSuperAdmin => this == superAdmin;

  /// Check if role is guest
  bool get isGuest => this == guest;

  /// Convert role to Firestore string value
  String toFirestoreValue() {
    switch (this) {
      case UserRole.guest:
        return 'guest';
      case UserRole.admin:
        return 'admin';
      case UserRole.superAdmin:
        return 'superAdmin';
    }
  }

  /// Parse role from Firestore string value
  /// Returns guest if value is null or unrecognized
  static UserRole fromFirestoreValue(String? value) {
    switch (value) {
      case 'admin':
        return UserRole.admin;
      case 'superAdmin':
        return UserRole.superAdmin;
      case 'guest':
      default:
        return UserRole.guest;
    }
  }

  /// Get display name for the role
  String get displayName {
    switch (this) {
      case UserRole.guest:
        return 'Guest';
      case UserRole.admin:
        return 'Admin';
      case UserRole.superAdmin:
        return 'Super Admin';
    }
  }
}
