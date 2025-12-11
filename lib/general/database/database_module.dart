import 'package:injectable/injectable.dart';
import 'app_database.dart';

/// Dependency injection module for database
@module
abstract class DatabaseModule {
  /// Provide singleton instance of AppDatabase
  @lazySingleton
  AppDatabase get appDatabase => AppDatabase();
}
