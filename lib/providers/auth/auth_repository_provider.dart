import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:who_mobile_project/di/injector.dart';
import 'package:who_mobile_project/repository/auth/firebase_auth_repository.dart';

part 'auth_repository_provider.g.dart';

/// Provider for FirebaseAuthRepository
/// Uses GetIt to retrieve the repository instance
@riverpod
FirebaseAuthRepository firebaseAuthRepository(Ref ref) {
  return getIt<FirebaseAuthRepository>();
}
