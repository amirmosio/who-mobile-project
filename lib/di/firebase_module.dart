import 'package:injectable/injectable.dart';
import 'package:who_mobile_project/repository/auth/firebase_auth_repository.dart';
import 'package:who_mobile_project/services/firebase/firebase_auth_service.dart';

/// Dependency injection module for Firebase services
@module
abstract class FirebaseModule {
  /// Provides FirebaseAuthService as a singleton
  /// The service handles all Firebase Auth and Firestore operations
  @singleton
  FirebaseAuthService get firebaseAuthService => FirebaseAuthService();

  /// Provides FirebaseAuthRepository
  /// Repository wraps the service with error handling and returns RepositoryState
  @injectable
  FirebaseAuthRepository firebaseAuthRepository(
    FirebaseAuthService authService,
  ) =>
      FirebaseAuthRepository(authService);
}
