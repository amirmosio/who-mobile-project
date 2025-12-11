import 'dart:convert';
import 'package:who_mobile_project/general/models/login/login_response.dart';
import 'package:who_mobile_project/general/models/user/user_model.dart';
import 'package:who_mobile_project/general/services/storage/base_storage.dart';

/// Mixin for authentication-related storage operations
mixin AuthStorageMixin on BaseStorage {
  // Storage keys
  static const _userAuthDataKey = "user_auth_data";
  static const _fireBaseRegistrationTokenKey = "firebase_registration_token";
  static const _userProfileKey = "user_profile";

  /// Set user authentication data
  Future<void> setUserAuthData(LoginResponse loginAuth) async {
    await secureStorage.write(
      key: _userAuthDataKey,
      value: jsonEncode(loginAuth.toJson()),
    );
  }

  /// Get user authentication data
  Future<LoginResponse?> getUserAuthData() async {
    try {
      final authDataString = await secureStorage.read(key: _userAuthDataKey);
      if (authDataString != null && authDataString.isNotEmpty) {
        final authData = jsonDecode(authDataString) as Map<String, dynamic>;
        return LoginResponse.fromJson(authData);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Set Firebase registration token
  Future<void> setFireBaseRegistrationToken(String? token) async {
    await secureStorage.write(key: _fireBaseRegistrationTokenKey, value: token);
  }

  /// Get Firebase registration token
  Future<String?> getFireBaseRegistrationToken() async {
    return secureStorage.read(key: _fireBaseRegistrationTokenKey);
  }

  /// Set user profile
  Future<void> setUserProfile(UserModel profile) async {
    await secureStorage.write(
      key: _userProfileKey,
      value: jsonEncode(profile.toJson()),
    );
  }

  /// Get user profile
  Future<UserModel?> getUserProfile() async {
    try {
      final profileString = await secureStorage.read(key: _userProfileKey);
      if (profileString != null && profileString.isNotEmpty) {
        final profileData = jsonDecode(profileString) as Map<String, dynamic>;
        return UserModel.fromJson(profileData);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Remove user authentication data
  Future<void> removeUserAuthData() async {
    await secureStorage.delete(key: _userAuthDataKey);
    await secureStorage.delete(key: _fireBaseRegistrationTokenKey);
    await secureStorage.delete(key: _userProfileKey);
  }
}
