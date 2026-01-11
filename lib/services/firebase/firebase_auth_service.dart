import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:who_mobile_project/general/constants/user_roles.dart';
import 'package:who_mobile_project/general/models/auth/admin_user.dart';

/// Firebase Authentication Service
/// Handles all Firebase Auth and Firestore operations for authentication
/// Registered as singleton via FirebaseModule in DI
class FirebaseAuthService {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  /// Secondary Firebase app for creating users without signing out current user
  static FirebaseApp? _secondaryApp;

  /// Super admin email constant
  static const String superAdminEmail = 'admin@who.int';

  /// Firestore collection name for users
  static const String _usersCollection = 'users';

  FirebaseAuthService()
      : _auth = FirebaseAuth.instance,
        _firestore = FirebaseFirestore.instance;

  /// Stream of auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Get current Firebase user
  User? get currentFirebaseUser => _auth.currentUser;

  /// Check if there is an authenticated user
  bool get isAuthenticated => _auth.currentUser != null;

  /// Sign in with email and password
  /// Returns UserCredential on success, throws FirebaseAuthException on failure
  Future<UserCredential> signInWithEmailPassword(
    String email,
    String password,
  ) async {
    return await _auth.signInWithEmailAndPassword(
      email: email.trim().toLowerCase(),
      password: password,
    );
  }

  /// Sign out from Firebase Auth
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Get user data from Firestore by UID
  /// Returns null if user document doesn't exist
  Future<Map<String, dynamic>?> getUserData(String uid) async {
    final doc = await _firestore.collection(_usersCollection).doc(uid).get();
    return doc.data();
  }

  /// Check if user document exists in Firestore
  Future<bool> userExistsInFirestore(String uid) async {
    final doc = await _firestore.collection(_usersCollection).doc(uid).get();
    return doc.exists;
  }

  /// Create user document in Firestore
  Future<void> createUserDocument({
    required String uid,
    required String email,
    required UserRole role,
    required String createdBy,
    String? displayName,
  }) async {
    await _firestore.collection(_usersCollection).doc(uid).set({
      'email': email.toLowerCase(),
      'role': role.toFirestoreValue(),
      'displayName': displayName,
      'createdAt': FieldValue.serverTimestamp(),
      'createdBy': createdBy,
      'isActive': true,
    });
  }

  /// Create new admin user (Firebase Auth + Firestore)
  /// Returns the created user's UID
  /// Uses a secondary Firebase app instance to avoid signing out the current user
  Future<String> createAdminUser({
    required String email,
    required String password,
    required String createdBy,
    String? displayName,
  }) async {
    // Initialize secondary app if not already done
    _secondaryApp ??= await Firebase.initializeApp(
      name: 'SecondaryApp',
      options: Firebase.app().options,
    );

    // Use secondary auth instance to create user
    final secondaryAuth = FirebaseAuth.instanceFor(app: _secondaryApp!);

    try {
      // Create Firebase Auth user using secondary app (doesn't affect current session)
      final credential = await secondaryAuth.createUserWithEmailAndPassword(
        email: email.trim().toLowerCase(),
        password: password,
      );

      final uid = credential.user!.uid;

      // Create Firestore document (Firestore is shared across apps)
      await createUserDocument(
        uid: uid,
        email: email,
        role: UserRole.admin,
        createdBy: createdBy,
        displayName: displayName,
      );

      // Sign out from secondary app (cleanup)
      await secondaryAuth.signOut();

      return uid;
    } catch (e) {
      // Sign out from secondary app on error
      await secondaryAuth.signOut();
      rethrow;
    }
  }

  /// Get stream of all admin users (for admin panel)
  /// Returns users with role 'admin' or 'superAdmin'
  /// Requires Firestore composite index: users (role ASC, createdAt DESC)
  Stream<List<AdminUser>> getAdminUsersStream() {
    return _firestore
        .collection(_usersCollection)
        .where('role', whereIn: ['admin', 'superAdmin'])
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => AdminUser.fromFirestore(doc)).toList());
  }

  /// Get all admin users once (not a stream)
  /// Requires Firestore composite index: users (role ASC, createdAt DESC)
  Future<List<AdminUser>> getAdminUsers() async {
    final snapshot = await _firestore
        .collection(_usersCollection)
        .where('role', whereIn: ['admin', 'superAdmin'])
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map((doc) => AdminUser.fromFirestore(doc)).toList();
  }

  /// Deactivate admin user (soft delete)
  Future<void> deactivateAdmin(String uid) async {
    await _firestore.collection(_usersCollection).doc(uid).update({
      'isActive': false,
    });
  }

  /// Reactivate admin user
  Future<void> reactivateAdmin(String uid) async {
    await _firestore.collection(_usersCollection).doc(uid).update({
      'isActive': true,
    });
  }

  /// Update admin display name
  Future<void> updateAdminDisplayName(String uid, String displayName) async {
    await _firestore.collection(_usersCollection).doc(uid).update({
      'displayName': displayName,
    });
  }

  /// Delete admin user document from Firestore
  /// Note: This only deletes Firestore document, Firebase Auth user remains
  /// Full deletion requires Firebase Admin SDK (server-side)
  Future<void> deleteAdminDocument(String uid) async {
    await _firestore.collection(_usersCollection).doc(uid).delete();
  }

  /// Check if email is the super admin email
  bool isSuperAdminEmail(String email) {
    return email.trim().toLowerCase() == superAdminEmail.toLowerCase();
  }

  /// Initialize super admin account if it doesn't exist
  /// This should be called once during initial setup
  /// Call this method only in development or during first deployment
  Future<void> initializeSuperAdmin({
    required String password,
    String displayName = 'Super Admin',
  }) async {
    try {
      // Try to sign in with super admin credentials
      final credential = await _auth.signInWithEmailAndPassword(
        email: superAdminEmail,
        password: password,
      );

      // Check if Firestore document exists
      final exists = await userExistsInFirestore(credential.user!.uid);

      if (!exists) {
        // Create Firestore document with super admin role
        await createUserDocument(
          uid: credential.user!.uid,
          email: superAdminEmail,
          role: UserRole.superAdmin,
          createdBy: 'system',
          displayName: displayName,
        );
      }

      // Sign out after setup
      await signOut();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        // Create the super admin account
        final credential = await _auth.createUserWithEmailAndPassword(
          email: superAdminEmail,
          password: password,
        );

        await createUserDocument(
          uid: credential.user!.uid,
          email: superAdminEmail,
          role: UserRole.superAdmin,
          createdBy: 'system',
          displayName: displayName,
        );

        await signOut();
      } else {
        rethrow;
      }
    }
  }

  /// Re-authenticate user with email and password
  /// Useful after creating a new admin (which signs in as the new user)
  Future<UserCredential> reauthenticate(String email, String password) async {
    return await signInWithEmailPassword(email, password);
  }

  /// Send password reset email
  /// Firebase handles the email template and reset link generation
  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email.trim().toLowerCase());
  }

  /// Sign in with Google using Firebase Authentication
  /// Returns UserCredential on success, throws on failure
  Future<UserCredential> signInWithGoogle() async {
    // Ensure GoogleSignIn is initialized
    try {
      await GoogleSignIn.instance.initialize();
    } catch (_) {
      // Already initialized, ignore
    }

    // Trigger the Google Sign-In flow
    final GoogleSignInAccount account = await GoogleSignIn.instance
        .authenticate(scopeHint: ['email', 'profile']);

    // Get authentication details (idToken only in google_sign_in v7.2.0+)
    final GoogleSignInAuthentication googleAuth = account.authentication;

    // Create a new credential for Firebase using idToken
    // Note: accessToken is optional for Firebase Auth with Google
    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );

    // Sign in to Firebase with the Google credential
    return await _auth.signInWithCredential(credential);
  }

  /// Sign out from Google (in addition to Firebase sign out)
  Future<void> signOutFromGoogle() async {
    try {
      await GoogleSignIn.instance.signOut();
    } catch (_) {
      // Ignore errors during sign out
    }
  }

  /// Update user's installation state in Firestore
  /// Used to persist installation progress across devices
  Future<void> updateInstallationState(
    String uid, {
    String? phase,
    String? installationId,
    String? facilityId,
    String? facilityName,
  }) async {
    // ignore: avoid_print
    print('🔥 FirebaseAuthService.updateInstallationState called');
    // ignore: avoid_print
    print('🔥 uid: $uid');
    // ignore: avoid_print
    print('🔥 phase: $phase');
    // ignore: avoid_print
    print('🔥 installationId: $installationId');
    // ignore: avoid_print
    print('🔥 facilityId: $facilityId');
    // ignore: avoid_print
    print('🔥 facilityName: $facilityName');

    // Use set with merge to add new fields without overwriting existing data
    await _firestore.collection(_usersCollection).doc(uid).set({
      'installationPhase': phase,
      'installationId': installationId,
      'facilityId': facilityId,
      'facilityName': facilityName,
    }, SetOptions(merge: true));

    // ignore: avoid_print
    print('🔥 Firestore set() completed successfully');
  }

  /// Clear user's installation state in Firestore
  /// Called when installation is completed or abandoned
  Future<void> clearInstallationState(String uid) async {
    // ignore: avoid_print
    print('🔥 FirebaseAuthService.clearInstallationState called for uid: $uid');

    // Use set with merge to update fields without overwriting existing data
    await _firestore.collection(_usersCollection).doc(uid).set({
      'installationPhase': null,
      'installationId': null,
      'facilityId': null,
      'facilityName': null,
    }, SetOptions(merge: true));

    // ignore: avoid_print
    print('🔥 Firestore clear completed successfully');
  }
}
