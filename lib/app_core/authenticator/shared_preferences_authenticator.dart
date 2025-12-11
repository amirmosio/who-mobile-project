import 'package:injectable/injectable.dart';
import 'package:who_mobile_project/general/services/storage/storage_manager.dart';
import 'package:who_mobile_project/general/models/login/login_response.dart';

@preResolve
@Singleton()
class SharedPreferencesAuthenticator {
  final StorageManager _storage;

  SharedPreferencesAuthenticator(this._storage);

  @factoryMethod
  static Future<SharedPreferencesAuthenticator> create(
    StorageManager storage,
  ) async {
    return SharedPreferencesAuthenticator(storage);
  }

  Future<String?> peekAuthToken() async {
    LoginResponse? userAuth = await _storage.getUserAuthData();
    return userAuth?.jwtToken;
  }

  Future<String?> peekRefreshToken() async {
    LoginResponse? userAuth = await _storage.getUserAuthData();
    return userAuth?.refreshToken;
  }

  Future<void> setUserAuth(LoginResponse authData) async {
    await _storage.setUserAuthData(authData);
  }

  Future<LoginResponse?> getUserAuth() {
    return _storage.getUserAuthData();
  }

  void removeUserRelatedInfo() async {
    _storage.removeUserRelatedInfo();
  }
}
