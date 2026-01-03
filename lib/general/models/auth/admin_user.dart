import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:who_mobile_project/general/constants/user_roles.dart';

/// Model for admin users displayed in the admin management panel
/// Used by super admin to manage admin accounts
class AdminUser {
  /// Firebase user ID
  final String uid;

  /// User email address
  final String email;

  /// Display name (optional)
  final String? displayName;

  /// User role (admin or superAdmin)
  final UserRole role;

  /// Account creation timestamp
  final DateTime createdAt;

  /// ID of the user who created this admin account
  final String createdBy;

  /// Whether the account is active
  final bool isActive;

  const AdminUser({
    required this.uid,
    required this.email,
    this.displayName,
    required this.role,
    required this.createdAt,
    required this.createdBy,
    required this.isActive,
  });

  /// Create AdminUser from Firestore document snapshot
  factory AdminUser.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return AdminUser(
      uid: doc.id,
      email: data['email'] as String? ?? '',
      displayName: data['displayName'] as String?,
      role: UserRole.fromFirestoreValue(data['role'] as String?),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      createdBy: data['createdBy'] as String? ?? 'system',
      isActive: data['isActive'] as bool? ?? true,
    );
  }

  /// Create AdminUser from Firestore data map with document ID
  factory AdminUser.fromMap(String docId, Map<String, dynamic> data) {
    return AdminUser(
      uid: docId,
      email: data['email'] as String? ?? '',
      displayName: data['displayName'] as String?,
      role: UserRole.fromFirestoreValue(data['role'] as String?),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      createdBy: data['createdBy'] as String? ?? 'system',
      isActive: data['isActive'] as bool? ?? true,
    );
  }

  /// Convert to Firestore document data
  Map<String, dynamic> toFirestore() => {
        'email': email,
        'displayName': displayName,
        'role': role.toFirestoreValue(),
        'createdAt': FieldValue.serverTimestamp(),
        'createdBy': createdBy,
        'isActive': isActive,
      };

  /// Get initials for avatar display
  String get initials {
    if (displayName != null && displayName!.isNotEmpty) {
      final parts = displayName!.split(' ');
      if (parts.length >= 2) {
        return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
      }
      return displayName![0].toUpperCase();
    }
    if (email.isNotEmpty) {
      return email[0].toUpperCase();
    }
    return 'A';
  }

  /// Check if this is a super admin account
  bool get isSuperAdmin => role.isSuperAdmin;

  /// Create a copy with updated fields
  AdminUser copyWith({
    String? uid,
    String? email,
    String? displayName,
    UserRole? role,
    DateTime? createdAt,
    String? createdBy,
    bool? isActive,
  }) {
    return AdminUser(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AdminUser &&
          runtimeType == other.runtimeType &&
          uid == other.uid &&
          email == other.email;

  @override
  int get hashCode => Object.hash(uid, email);

  @override
  String toString() =>
      'AdminUser(uid: $uid, email: $email, role: ${role.displayName}, '
      'isActive: $isActive)';
}
