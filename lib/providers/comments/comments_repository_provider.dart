import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:who_mobile_project/di/injector.dart';
import 'package:who_mobile_project/repository/comments/comments_repository.dart';

part 'comments_repository_provider.g.dart';

/// Provider for CommentsRepository
/// Uses GetIt to retrieve the repository instance
@riverpod
CommentsRepository commentsRepository(Ref ref) {
  return getIt<CommentsRepository>();
}
