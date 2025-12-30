import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@module
abstract class StorageModule {
  @preResolve
  @singleton
  Future<SharedPreferences> sharedPreferencesProvider() async {
    return await SharedPreferences.getInstance();
  }
}
