import 'package:firebase_auth/firebase_auth.dart';
import 'package:who_mobile_project/general/models/auth/admin_user.dart';
import 'package:who_mobile_project/general/models/auth/app_user.dart';
import 'package:who_mobile_project/repository/repo_state.dart';
import 'package:who_mobile_project/services/firebase/firebase_auth_service.dart';

/// Repository for Firebase authentication operations
/// Provides consistent error handling and returns RepositoryState
/// Registered via FirebaseModule in DI
class FirebaseAuthRepository {
  final FirebaseAuthService _authService;

  FirebaseAuthRepository(this._authService);

  /// Sign in with email and password
  /// Returns AppUser with role on success
  Future<RepositoryState> signIn(String email, String password) async {
    try {
      final credential = await _authService.signInWithEmailPassword(
        email,
        password,
      );

      final userData = await _authService.getUserData(credential.user!.uid);
      final appUser = AppUser.fromFirebase(credential.user, userData);

      // Check if user is active
      if (userData != null && userData['isActive'] == false) {
        await _authService.signOut();
        return ErrorState(RepositoryException(
          message: 'Account is deactivated. Contact administrator.',
          error: null,
        ));
      }

      // Check if user has admin role
      if (!appUser.hasAdminAccess) {
        await _authService.signOut();
        return ErrorState(RepositoryException(
          message: 'Access denied. Admin privileges required.',
          error: null,
        ));
      }

      return SuccessState(appUser, null);
    } on FirebaseAuthException catch (e) {
      return ErrorState(RepositoryException(
        message: _getFirebaseAuthErrorMessage(e.code),
        error: null,
      ));
    } catch (e) {
      return ErrorState(RepositoryException(
        message: 'Authentication failed. Please try again.',
        error: null,
      ));
    }
  }

  /// Sign out from Firebase Auth
  Future<RepositoryState> signOut() async {
    try {
      await _authService.signOut();
      return SuccessState(true, null);
    } catch (e) {
      return ErrorState(RepositoryException(
        message: 'Failed to sign out. Please try again.',
        error: null,
      ));
    }
  }

  /// Get current authenticated user with role
  /// Returns AppUser.guest() if not authenticated
  Future<AppUser> getCurrentUser() async {
    final firebaseUser = _authService.currentFirebaseUser;
    if (firebaseUser == null) {
      return AppUser.guest();
    }

    try {
      final userData = await _authService.getUserData(firebaseUser.uid);
      return AppUser.fromFirebase(firebaseUser, userData);
    } catch (e) {
      // If Firestore fails, return user with guest role
      return AppUser(
        uid: firebaseUser.uid,
        email: firebaseUser.email,
        displayName: firebaseUser.displayName,
        role: _authService.isSuperAdminEmail(firebaseUser.email ?? '')
            ? throw Exception('Super admin must have Firestore document')
            : throw Exception('User must have Firestore document'),
        isAuthenticated: true,
      );
    }
  }

  /// Check if user is currently authenticated
  bool get isAuthenticated => _authService.isAuthenticated;

  /// Create new admin user (super admin only)
  /// Returns the created user's UID on success
  Future<RepositoryState> createAdmin({
    required String email,
    required String password,
    required String createdBy,
    String? displayName,
  }) async {
    try {
      // Validate email format
      if (!_isValidEmail(email)) {
        return ErrorState(RepositoryException(
          message: 'Please enter a valid email address.',
          error: null,
        ));
      }

      // Validate password strength
      if (password.length < 6) {
        return ErrorState(RepositoryException(
          message: 'Password must be at least 6 characters.',
          error: null,
        ));
      }

      final uid = await _authService.createAdminUser(
        email: email,
        password: password,
        createdBy: createdBy,
        displayName: displayName,
      );

      return SuccessState(uid, null);
    } on FirebaseAuthException catch (e) {
      return ErrorState(RepositoryException(
        message: _getFirebaseAuthErrorMessage(e.code),
        error: null,
      ));
    } catch (e) {
      return ErrorState(RepositoryException(
        message: 'Failed to create admin. Please try again.',
        error: null,
      ));
    }
  }

  /// Get stream of admin users for admin panel
  Stream<List<AdminUser>> getAdminUsersStream() {
    return _authService.getAdminUsersStream();
  }

  /// Get admin users list once
  Future<RepositoryState> getAdminUsers() async {
    try {
      final admins = await _authService.getAdminUsers();
      return SuccessState(admins, null);
    } catch (e) {
      return ErrorState(RepositoryException(
        message: 'Failed to load admin users.',
        error: null,
      ));
    }
  }

  /// Deactivate admin user (soft delete)
  Future<RepositoryState> deactivateAdmin(String uid) async {
    try {
      await _authService.deactivateAdmin(uid);
      return SuccessState(true, null);
    } catch (e) {
      return ErrorState(RepositoryException(
        message: 'Failed to deactivate admin.',
        error: null,
      ));
    }
  }

  /// Reactivate admin user
  Future<RepositoryState> reactivateAdmin(String uid) async {
    try {
      await _authService.reactivateAdmin(uid);
      return SuccessState(true, null);
    } catch (e) {
      return ErrorState(RepositoryException(
        message: 'Failed to reactivate admin.',
        error: null,
      ));
    }
  }

  /// Update admin display name
  Future<RepositoryState> updateAdminDisplayName(
    String uid,
    String displayName,
  ) async {
    try {
      await _authService.updateAdminDisplayName(uid, displayName);
      return SuccessState(true, null);
    } catch (e) {
      return ErrorState(RepositoryException(
        message: 'Failed to update display name.',
        error: null,
      ));
    }
  }

  /// Re-authenticate current user (after creating new admin)
  Future<RepositoryState> reauthenticate(String email, String password) async {
    try {
      await _authService.reauthenticate(email, password);
      return SuccessState(true, null);
    } on FirebaseAuthException catch (e) {
      return ErrorState(RepositoryException(
        message: _getFirebaseAuthErrorMessage(e.code),
        error: null,
      ));
    } catch (e) {
      return ErrorState(RepositoryException(
        message: 'Re-authentication failed.',
        error: null,
      ));
    }
  }

  /// Send password reset email to user
  /// Returns SuccessState(true) on success, ErrorState on failure
  Future<RepositoryState> sendPasswordResetEmail(String email) async {
    try {
      if (!_isValidEmail(email)) {
        return ErrorState(RepositoryException(
          message: 'Please enter a valid email address.',
          error: null,
        ));
      }
      await _authService.sendPasswordResetEmail(email);
      return SuccessState(true, null);
    } on FirebaseAuthException catch (e) {
      return ErrorState(RepositoryException(
        message: _getFirebaseAuthErrorMessage(e.code),
        error: null,
      ));
    } catch (e) {
      return ErrorState(RepositoryException(
        message: 'Failed to send reset email. Please try again.',
        error: null,
      ));
    }
  }

  /// Map Firebase Auth error codes to user-friendly messages
  String _getFirebaseAuthErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'invalid-email':
        return 'Invalid email address.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'weak-password':
        return 'Password is too weak. Use at least 6 characters.';
      case 'operation-not-allowed':
        return 'Email/password sign-in is not enabled.';
      case 'too-many-requests':
        return 'Too many failed attempts. Please try again later.';
      case 'invalid-credential':
        return 'Invalid email or password.';
      case 'network-request-failed':
        return 'Network error. Please check your connection.';
      default:
        return 'Authentication failed. Please try again.';
    }
  }

  /// Validate email format
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}
