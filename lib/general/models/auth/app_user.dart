import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:who_mobile_project/general/constants/user_roles.dart';

/// Represents the current app user with Firebase auth and role information
/// This model combines Firebase Authentication data with Firestore role data
class AppUser {
  /// Firebase user ID (null for guests)
  final String? uid;

  /// User email address
  final String? email;

  /// Display name for the user
  final String? displayName;

  /// User's role in the system
  final UserRole role;

  /// Whether the user is authenticated with Firebase
  final bool isAuthenticated;

  /// Account creation timestamp
  final DateTime? createdAt;

  /// ID of the user who created this account (for admin tracking)
  final String? createdBy;

  /// Whether the account is active
  final bool isActive;

  const AppUser({
    this.uid,
    this.email,
    this.displayName,
    required this.role,
    required this.isAuthenticated,
    this.createdAt,
    this.createdBy,
    this.isActive = true,
  });

  /// Factory constructor for guest users (not authenticated)
  factory AppUser.guest() => const AppUser(
        role: UserRole.guest,
        isAuthenticated: false,
      );

  /// Create AppUser from Firebase Auth user and Firestore document data
  factory AppUser.fromFirebase(
    firebase_auth.User? firebaseUser,
    Map<String, dynamic>? firestoreData,
  ) {
    if (firebaseUser == null) {
      return AppUser.guest();
    }

    return AppUser(
      uid: firebaseUser.uid,
      email: firebaseUser.email,
      displayName: firestoreData?['displayName'] as String? ??
          firebaseUser.displayName,
      role: UserRole.fromFirestoreValue(firestoreData?['role'] as String?),
      isAuthenticated: true,
      createdAt: firestoreData?['createdAt']?.toDate() as DateTime?,
      createdBy: firestoreData?['createdBy'] as String?,
      isActive: firestoreData?['isActive'] as bool? ?? true,
    );
  }

  /// Check if user is a guest (not authenticated)
  bool get isGuest => role == UserRole.guest || !isAuthenticated;

  /// Check if user has admin access (admin or super admin)
  bool get hasAdminAccess => role.isAdminOrAbove;

  /// Check if user is super admin
  bool get isSuperAdmin => role.isSuperAdmin;

  /// Get initials for avatar display
  String get initials {
    if (displayName != null && displayName!.isNotEmpty) {
      final parts = displayName!.split(' ');
      if (parts.length >= 2) {
        return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
      }
      return displayName![0].toUpperCase();
    }
    if (email != null && email!.isNotEmpty) {
      return email![0].toUpperCase();
    }
    return 'G';
  }

  /// Convert to JSON for caching/serialization
  Map<String, dynamic> toJson() => {
        'uid': uid,
        'email': email,
        'displayName': displayName,
        'role': role.toFirestoreValue(),
        'isAuthenticated': isAuthenticated,
        if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
        if (createdBy != null) 'createdBy': createdBy,
        'isActive': isActive,
      };

  /// Create from cached JSON data
  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      uid: json['uid'] as String?,
      email: json['email'] as String?,
      displayName: json['displayName'] as String?,
      role: UserRole.fromFirestoreValue(json['role'] as String?),
      isAuthenticated: json['isAuthenticated'] as bool? ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
      createdBy: json['createdBy'] as String?,
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  /// Create a copy with updated fields
  AppUser copyWith({
    String? uid,
    String? email,
    String? displayName,
    UserRole? role,
    bool? isAuthenticated,
    DateTime? createdAt,
    String? createdBy,
    bool? isActive,
  }) {
    return AppUser(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      role: role ?? this.role,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppUser &&
          runtimeType == other.runtimeType &&
          uid == other.uid &&
          role == other.role &&
          isActive == other.isActive;

  @override
  int get hashCode => Object.hash(uid, role, isActive);

  @override
  String toString() =>
      'AppUser(uid: $uid, email: $email, role: ${role.displayName}, '
      'isAuthenticated: $isAuthenticated, isActive: $isActive)';
}
