import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// Enum defining all supported login methods with their properties
enum LoginMethod {
  email('email', 'Email', Icons.email_outlined, Color(0xFF6B7280)),
  google('google', 'Google', Icons.g_mobiledata, Color(0xFF4285F4)),
  apple('apple', 'Apple', Icons.apple, Color(0xFF000000)),
  facebook(
    'facebook',
    'Facebook',
    FontAwesomeIcons.facebook,
    Color(0xFF1877F2),
  );

  const LoginMethod(this.id, this.displayName, this.icon, this.color);

  /// Unique identifier for the login method (used for API calls)
  final String id;

  /// Display name for UI
  final String displayName;

  /// Icon to represent the login method
  final IconData icon;

  /// Associated color for the login method
  final Color color;

  /// Get the merge account type for API requests
  /// Returns 'credentials' for email/password, 'oauth' for social logins
  String get mergeAccountType => isSocialLogin ? 'oauth' : 'credentials';

  /// Check if this is a social login method (Google, Apple, Facebook)
  bool get isSocialLogin =>
      this == LoginMethod.google ||
      this == LoginMethod.apple ||
      this == LoginMethod.facebook;

  /// Check if this is email/password login
  bool get isEmailLogin => this == LoginMethod.email;

  static LoginMethod fromId(String id) {
    return LoginMethod.values.firstWhere(
      (method) => method.id.toLowerCase() == id.toLowerCase(),
    );
  }

  /// Get all social login methods
  static List<LoginMethod> get socialMethods =>
      LoginMethod.values.where((method) => method.isSocialLogin).toList();

  /// Check if a login method ID is valid
  static bool isValidId(String id) {
    return LoginMethod.values.any((method) => method.id == id);
  }

  @override
  String toString() => id;
}
